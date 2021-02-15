
#include <GUIConstants.au3>
#include <String.au3>
#include <array.au3>
#include <GuiListView.au3>



HotKeySet("!x","Terminate") ;Alt x 
UDPStartup()


$Form1 = GUICreate(" SYSLOG     Alt x  stops program", 1234, 811, -1, -1)

$Critical = GUICtrlCreateListView("       Time   Stamp      |  Source IP   |    Location   | Seq Num | Severity |     Description     ", 16, 8, 1209, 162,0x0020,0x00010000)
GUICtrlSetBkColor($Critical, 0xFFFF00)
_GUICtrlListView_SetItemCount($Critical,32)

$Router = GUICtrlCreateListView  ("       Time   Stamp      |  Source IP   |    Location   | Seq Num | Severity |     Description     ", 16, 184, 1209, 175,0x0020,0x00010000)
GUICtrlSetBkColor($Router, 0xC6D2A2)
_GUICtrlListView_SetItemCount($Router,32)

$Switches = GUICtrlCreateListView("       Time   Stamp      |  Source IP   |    Location   | Seq Num | Severity |     Description     ", 16, 368, 1209, 314,0x0020,0x00010000)
GUICtrlSetBkColor($Switches, 0xC0C0C0)
_GUICtrlListView_SetItemCount($Switches,32)

$Else = GUICtrlCreateListView    ("       Time   Stamp      |  Source IP   |    Location   | Seq Num | Severity |     Description     ", 16, 700, 1209, 101,0x0020,0x00010000)
GUICtrlSetBkColor($Else, 0x777777)
_GUICtrlListView_SetItemCount($Else,32)

GUISetState(@SW_SHOW)


$socketsyslog = UDPBind(@IPAddress1, 514)
;variable sent to Func before they have a true value
$rcvData = ""
$AlarmSeverity = ""
$Location = ""
$WhichList = ""

   

While 1    
    ; Flag 2 = array    ; [0] = Data    ; [1] = Source IP    ; [2] = Source Port
    $rcvData = UDPRecv($socketsyslog, 1024, 2)
	$SleepingPill = 250 		; if we have no traffic then sleep longer
if $rcvData <> "" then
	
	$TempFile = @MON & "-" &@MDAY & "-" &@YEAR  ;routine to write a log msg with this info
	$File = ("C:\AU3\"&$TempFile&".log")
	FileOpen($File,9)
	fileWrite($File, "Local Timestamp  " &@MON &"/"& @MDAY&"/"&@YEAR &"  "&@HOUR &":"&@MIN&":"&@SEC &"  "& $rcvData[1] &" Msg " & $rcvData[0] &  @CRLF)
	FileClose($File)
	$msg = $rcvData[0]
	$ArraySyslog = _StringExplode($msg, ":", 0)
	
	$Level          = $ArraySyslog[0] 	;alarm process and a dummy seq number 
	$SeqNumber      = $ArraySyslog[1] 	;sequence Number
	$MonDayHour     = $ArraySyslog[2] 	;Month Day Hour
	$Minute         = $ArraySyslog[3] 	;minute
	$SecMS          = $ArraySyslog[4] 	;sec . Ms
	$AlarmSevRaw    = $ArraySyslog[5] 	;alarm type -X- is severity level
	$AlarmDesc      = $ArraySyslog[6] 	;description
	$SourceIP       = $rcvData[1] 
	
	ListFinder($SourceIP, $WhichList ) 										;which list to place this into
	AlarmSeverity($AlarmSevRaw, $AlarmSeverity, $WhichList )				;pop the alarm level number
	AlarmFinder($AlarmSeverity) 											;changes number readable english
	NameFinder($SourceIP, $Location) 										;changs IP to city name
	
	$TimeStamp = $MonDayHour &":"& $Minute &":"& $SecMS 					;reform timestamp into 1 lump
	$LocalArray = _StringBetween($msg,"%","") 								;trim msg from % to the end  elimate duplicated info
	$Desc = _ArrayToString($LocalArray) 									;convert arrzy to string
	$StringValue =  $TimeStamp & " |" & $SourceIP & " |" & $Location & "|" & $SeqNumber & " |" &$AlarmSeverity & "| " & $Desc
	
	GUICtrlCreateListViewItem($StringValue,$WhichList)			
	 
	ListCleaner()			;have data now check to see if we need to trim the lists to a managable size

	$rcvData 		= ""	
	$Level          = ""
	$SeqNumber      = ""
	$MonDayHour     = ""
	$Minute         = ""
	$SecMS          = ""
	$AlarmSevRaw    = ""
	$AlarmSevFind   = ""
	$AlarmSeverity  = ""
	$AlarmIDS       = ""
	$AlarmDesc      = ""
	$SourceIP       = ""
	$Location       = ""
	$WhichList      = ""
	$SleepingPill   = 20 		;just had traffic so sleep will be short in case more in buffer waiting to process

EndIf
    sleep($SleepingPill)
WEnd

Func AlarmSeverity(ByRef $AlarmSevRaw, ByRef $AlarmSeverity, ByRef $WhichList ) 	; look into alarm to find its value
	
Select	;bust out data to find alarm level if critical data // change GUI List to critical 
	case  StringInStr($AlarmSevRaw, "-0-") = True
		$AlarmSeverity = "0"
		$WhichList = $Critical
	case  StringInStr($AlarmSevRaw, "-1-") = True
		$AlarmSeverity = "1"
		$WhichList = $Critical
	case  StringInStr($AlarmSevRaw, "-2-") = True
		$AlarmSeverity = "2"
		$WhichList = $Critical
		
	case  StringInStr($AlarmSevRaw, "-3-") = True
		$AlarmSeverity = "3"
	case  StringInStr($AlarmSevRaw, "-4-") = True
		$AlarmSeverity = "4"
	case  StringInStr($AlarmSevRaw, "-5-") = True
		$AlarmSeverity = "5"
	case  StringInStr($AlarmSevRaw, "-6-") = True
		$AlarmSeverity = "6"
	case  StringInStr($AlarmSevRaw, "-7-") = True
		$AlarmSeverity = "7"
	
	case  Else
		$AlarmSeverity = "?"
EndSelect

	if  StringInStr($AlarmSevRaw, "IDS") = True then 	$WhichList = $Critical
	
EndFunc

Func AlarmFinder(ByRef $AlarmSeverity)		 ;alarm number to readable form
	
Switch $AlarmSeverity
Case 0
	$AlarmSeverity = " 0 - Emergency"
Case 1
	$AlarmSeverity = " 1 - Alert"
Case 2
	$AlarmSeverity = " 2 - Critical"
Case 3
	$AlarmSeverity = " 3 - Error"
Case 4
	$AlarmSeverity = " 4 - Warning"
Case 5
	$AlarmSeverity = " 5 - Notice"
Case 6
	$AlarmSeverity = " 6 - Informational"	
Case Else
	$AlarmSeverity = " 7 - Debug"
EndSwitch
EndFunc

Func NameFinder(ByRef $SourceIP, ByRef $Location) 		;change source ip to city name
	
Switch $SourceIP

	;Denver========================
case "10.16.129.65"
	$Location = "Denver Router 1"	
case "10.16.129.69"
	$Location = "Denver Router 2"
case "10.16.129.5"
	$Location = "Denver Switch 1"	
case "10.16.129.6"
	$Location = "Denver Switch 2"	
		;Atlanta========================
case "10.20.99.65"
	$Location = "Atlanta Router 1"	
case "10.20.99.69"
	$Location = "Atlanta Router 2"
case "10.20.99.5"
	$Location = "Atlanta Switch 1"	
case "10.20.99.6"
	$Location = "Atlanta Switch 2"
		;PDX Host========================
case "10.22.31.65"
	$Location = "Portland Router 1"	
case "10.22.31.69"
	$Location = "Portland Router 2"
case "10.22.31.5"
	$Location = "Portland Switch 1"	
case "10.22.31.6"
	$Location = "Portland Switch 2"
	;SeattleHost========================
case "10.21.76.65"
	$Location = "Seattle Router 1"	
case "10.21.76.69"
	$Location = "Seattle Router 2"
case "10.21.76.5"
	$Location = "Seattle Switch 1"	
case "10.21.76.6"
	$Location = "Seattle Switch 2"
		;Key West Host========================
case "10.23.104.65"
	$Location = "Key West Router 1"	
case "10.23.104.69"
	$Location = "Key West Router 2"
case "10.23.104.5"
	$Location = "Key West Switch 1"	
case "10.23.104.6"
	$Location = "Key West Switch 2"
	
	
case Else
	$Location = $SourceIP
EndSwitch	

EndFunc

Func ListFinder(ByRef $SourceIP, ByRef $WhichList) 		; Uses IP to decided which list to sent to
	
$HostSwitchTemp = _StringExplode($SourceIP, ".", 0)
$HostSwitch = $HostSwitchTemp[3] ; IP 4th octect is 5 6 19 18 17 16 253 are alwasy switches 1 2 65 69 254 always routers

Select 
case $HostSwitch = "5" 
	$WhichList = $Switches
	
case $HostSwitch = "6" 
	$WhichList = $Switches
	
case $HostSwitch = "19" 
	$WhichList = $Switches
	
case $HostSwitch = "18" 
	$WhichList = $Switches
	
case $HostSwitch = "17" 
	$WhichList = $Switches
	
case $HostSwitch = "16" 
	$WhichList = $Switches
	
case $HostSwitch = "253"
	$WhichList = $Switches
	
	
case $HostSwitch = "1"
	$WhichList = $Router
	
case $HostSwitch = "2"
	$WhichList = $Router
	
case $HostSwitch = "65"
	$WhichList = $Router
	
case $HostSwitch = "69"
	$WhichList = $Router
	
case $HostSwitch = "254"
	$WhichList = $Router

	
case Else
	$WhichList = $Else
	
EndSelect

EndFunc

Func ListCleaner()  		;ctrls lists size
	
	
	$RouterCound   = _GUICtrlListView_GetItemCount($Router)
	$SwitchesCound = _GUICtrlListView_GetItemCount($Switches)
	$CriticalCound = _GUICtrlListView_GetItemCount($Critical)
	$ElseCound     = _GUICtrlListView_GetItemCount($Else)

	if $RouterCound   > 30 then _GUICtrlListView_DeleteItem($Router,   31)
	if $SwitchesCound > 30 then _GUICtrlListView_DeleteItem($Switches, 31)
	if $CriticalCound > 30 then _GUICtrlListView_DeleteItem($Critical, 31)
	if $ElseCound     > 30 then _GUICtrlListView_DeleteItem($Else,     31)
EndFunc

Func Terminate() 					
	UDPCloseSocket($socketsyslog)
	UDPShutdown()
	Exit
EndFunc