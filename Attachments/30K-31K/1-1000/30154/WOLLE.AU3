#include <Array.au3>
#include <WindowsConstants.au3>
#include <GUIConstantsEx.au3>
#include <GuiListView.au3>
#Include <Date.au3>

AutoItSetOption ( "GUICoordMode",1)
Global $aNetWorkAdapters [1] [2] ; Global array for network adapter and ip
global $NextHH,$NextMM,$NextSS,$NextRun
_getnetworkadapter ()

$filemaclist="MACLIST.DAT"

Dim $MACAddressList[1]


; ===================================================================
; Gui
;   
; ===================================================================
$mainwindow=GUICreate("WOLLE",500,600)
$mwbtnExit=GUICtrlCreateButton("Exit",350,150,100)
$mwbtnGetMac=GUICtrlCreateButton("Get Mac adresses",10,150,100)
$mwbtnWakeupall=GUICtrlCreateButton("Wake up all in list",130,150,100)
$mwbtnWakeupSelected=GUICtrlCreateButton("Wake up selected",240,150,100)
$mwlblIpRange=GUICtrlCreateLabel("Enter Start and End IP for search, will only search for last segment, sorry....",10,115,200,30)

$mvinpIpStart=GUICtrlCreateInput("192.168.0.1",250,120,100,15)
$mvinpIpStop=GUICtrlCreateInput("192.168.0.10",350,120,100,15)
$mvinpWakeupTimeHH=GUICtrlCreateCombo("00",10,220,40)
$mvinpWakeupTimeMM=GUICtrlCreateCombo("00",50,220,40)
$mvinpWakeupTimeSS=GUICtrlCreateCombo("00",90,220,40)
FillTimeCombos()
$mwbtnActivateTimer=GUICtrlCreateButton("Activate Timer",290,220,120)
$mwbtnSetTimertoNow=GUICtrlCreateButton("Set Timer to now",160,220,120)
$mwbtnReadMacListFile=GUICtrlCreateButton("read MACLIST.DAT",260,20,120)
$mwbtnMarkAllMacList=GUICtrlCreateButton("Mark All",260,50,80)
$mwbtnUNMarkAllMacList=GUICtrlCreateButton("Un-Mark All",260,80,80)
$mwlvMacadresses=GUICtrlCreateListView("MacAdresses   |IP                ",10,10,250,100,-1,bitor($LVS_EX_FULLROWSELECT,$LVS_EX_GRIDLINES,$LVS_EX_CHECKBOXES))
$mwlblStatus=GUICtrlCreateLabel("Status:",10,180,400)
GUICtrlSetColor(-1,0xff0000)
$mwlblStatusNext=GUICtrlCreateLabel("Next:",10,200,400)
GUICtrlSetColor(-1,0x0099aa)

$mwlblWOLDelay1=GUICtrlCreateLabel("WOL DelayTimer (between two WOL msg)",10,500,100,15)
$mwinpWOLDelay=GUICtrlCreateInput("1000",110,500,100,15)
$mwlblWOLDelay2=GUICtrlCreateLabel("ms (Keep an eye on  the power usage on startup of a PC)",150,500,400,15)



$mwlvNetWorkAdapters=GUICtrlCreateListView("Name           |IP                ",10,270,405,200,-1,bitor($LVS_EX_FULLROWSELECT,$LVS_EX_GRIDLINES,$LVS_EX_CHECKBOXES))
$mwbtnMarkAllAdapters=GUICtrlCreateButton("Mark All",415,220,80)
$mwbtnUNMarkAllAdapters=GUICtrlCreateButton("Un-Mark All",415,250,80)






readmacfile()
setTimertoNow()


addNetworkAdapters2ListView()

global $RunType="GUI"
if $CmdLine[0]=2 then
	GUISetState(@SW_SHOW)
	$RunType="COMMANDLINE"
	$CommandlineWakeUpTime=$CmdLine[1]
	$CommandlineCompleteCommand=$CmdLine[2]

	local $aCommandLineTime=StringSplit($CommandlineWakeUpTime,":")
	guictrlsetdata($mvinpWakeupTimeHH,$aCommandLineTime[1])
    guictrlsetdata($mvinpWakeupTimeMM,$aCommandLineTime[2])
    guictrlsetdata($mvinpWakeupTimeSS,$aCommandLineTime[3])
	$boolTimerActive=1
	DisableControls(1)
elseif $CmdLine[0]=1  then
	msgbox(0,"WOLLE","Commandline Parameter"&@CRLF&"PARA1 = Wakeuptime"&@CRLF&"PARA2 = COMMAND after WAKUP (EXIT - RESTART)"&@CRLF&"WOLLE HH:MM:SS EXIT")
	exit
Else

	GUISetState(@SW_SHOW)
	$boolTimerActive=0
EndIf





    While 1
        $msg = GUIGetMsg()
        select 
            case $msg = $GUI_EVENT_CLOSE 
                ExitLoop
            case $msg = $mwbtnExit 
                ExitLoop
            case $msg = $mwbtnWakeupall 
                wol_all()
            case $msg = $mwbtnGetMac 
                getmacinrange()
            case $msg = $mwbtnGetMac 
                getmacinrange()
            case $msg = $mwbtnWakeupSelected 
                wol_selected()              
            case $msg = $mwbtnReadMacListFile 
                readmacfile()
            case $msg = $mwbtnMarkAllMacList 
                togglelistviewcheckboxes($mwlvMacadresses,true)
			case $msg = $mwbtnUNMarkAllMacList 
                togglelistviewcheckboxes($mwlvMacadresses,false)
            case $msg = $mwbtnMarkAllAdapters
                togglelistviewcheckboxes($mwlvNetWorkAdapters,true)
			case $msg = $mwbtnUNMarkAllAdapters
                togglelistviewcheckboxes($mwlvNetWorkAdapters,false)
            case $msg = $mwbtnActivateTimer
                if $boolTimerActive=1 Then
                    DisableControls(0)
                Else
                    DisableControls(1)
                endif
            case $msg = $mwbtnSetTimertoNow 
                setTimertoNow()


                
            EndSelect   
            if $boolTimerActive=1 Then
                CheckWakeup()
                sleep(100)
            endif
    WEnd
    GUIDelete()
    exit

; ===================================================================
; Function: setTimertoNow
;   sets the thre time controls to the current time 
; ===================================================================
func setTimertoNow()
    guictrlsetdata($mvinpWakeupTimeHH,@HOUR)
    guictrlsetdata($mvinpWakeupTimeMM,@MIN)
    guictrlsetdata($mvinpWakeupTimeSS,@SEC)
EndFunc

; ===================================================================
; Function: DisableControls($TimerState)
;~ 			$TimerState = 0 = Enable
;~ 			$TimerState = 1 = Disable
;   Toggle for the Timer button 
; ===================================================================
func DisableControls($TimerState)
    $boolTimerActive=$TimerState
    if $TimerState = "0" Then
        GUICtrlSetState($mwbtnExit,$GUI_ENABLE)
        GUICtrlSetState($mwbtnGetMac,$GUI_ENABLE)
        GUICtrlSetState($mwbtnWakeupall,$GUI_ENABLE)
        GUICtrlSetState($mwbtnWakeupSelected,$GUI_ENABLE)
        GUICtrlSetState($mvinpIpStart,$GUI_ENABLE)
        GUICtrlSetState($mvinpIpStop,$GUI_ENABLE)
        GUICtrlSetState($mvinpWakeupTimeHH,$GUI_ENABLE)
        GUICtrlSetState($mvinpWakeupTimeMM,$GUI_ENABLE)
        GUICtrlSetState($mvinpWakeupTimeSS,$GUI_ENABLE)
        GUICtrlSetState($mwbtnReadMacListFile,$GUI_ENABLE)
        GUICtrlSetState($mwbtnSetTimertoNow,$GUI_ENABLE)
GUICtrlSetState($mwlvMacadresses,$GUI_ENABLE)       
GUICtrlSetState($mwlvNetWorkAdapters,$GUI_ENABLE)      
        GUICtrlSetState($mwbtnMarkAllMacList,$GUI_ENABLE)       
        GUICtrlSetState($mwbtnUNMarkAllMacList,$GUI_ENABLE)       
        GUICtrlSetState($mwbtnMarkAllAdapters,$GUI_ENABLE)       
        GUICtrlSetState($mwbtnUNMarkAllAdapters,$GUI_ENABLE)       



        GUICtrlSetData($mwbtnActivateTimer," Activate Timer")
        setStatusMsg("Timer deactivated")
		setStatusMsgNext("")
        
    Else
        GUICtrlSetState($mwbtnExit,$GUI_DISABLE)
        GUICtrlSetState($mwbtnGetMac,$GUI_DISABLE)
        GUICtrlSetState($mwbtnWakeupall,$GUI_DISABLE)
        GUICtrlSetState($mwbtnWakeupSelected,$GUI_DISABLE)
        GUICtrlSetState($mvinpIpStart,$GUI_DISABLE)
        GUICtrlSetState($mvinpIpStop,$GUI_DISABLE)
        GUICtrlSetState($mvinpWakeupTimeHH,$GUI_DISABLE)
        GUICtrlSetState($mvinpWakeupTimeMM,$GUI_DISABLE)
        GUICtrlSetState($mvinpWakeupTimeSS,$GUI_DISABLE)
        GUICtrlSetState($mwbtnReadMacListFile,$GUI_DISABLE)
        GUICtrlSetState($mwbtnSetTimertoNow,$GUI_DISABLE)       
GUICtrlSetState($mwlvMacadresses,$GUI_DISABLE)       
GUICtrlSetState($mwlvNetWorkAdapters,$GUI_DISABLE)      

        GUICtrlSetState($mwbtnMarkAllMacList,$GUI_DISABLE)       
        GUICtrlSetState($mwbtnUNMarkAllMacList,$GUI_DISABLE)       
        GUICtrlSetState($mwbtnMarkAllAdapters,$GUI_DISABLE)       
        GUICtrlSetState($mwbtnUNMarkAllAdapters,$GUI_DISABLE)       

        GUICtrlSetData($mwbtnActivateTimer," De-Activate Timer")

        EndIf
EndFunc


; ===================================================================
; Function: CheckWakeup
; critical only equal time will trigger (needs something better like a small range)
; ===================================================================
func CheckWakeup()
    
    local $intWakeupTime=(GUICtrlRead($mvinpWakeupTimeHH)*60*60)+(GUICtrlRead($mvinpWakeupTimeMM)*60)+GUICtrlRead($mvinpWakeupTimess)
    local $intNow=(@HOUR*60*60)+(@MIN*60)+@SEC
		
    setStatusMsg("Current time:"&@HOUR&":"&@MIN&":"&@SEC)
	$NextRun=$intWakeupTime-$intNow
	if $NextRun<0 then 
		$NextRun=($NextRun+(24*60*60))*1000
	EndIf
	_TicksToTime($NextRun,$NextHH,$NextMM,$NextSS)
	
	setStatusMsgNext(""&$NextHH&":"&$NextMM&":"&$NextSS)
	
	_DebugConsole("WAKESECS:"&$intWakeupTime&":NOWSECS:"&$intNow&":TICKSNEXT:"&$NextRun)
    if $intNow = $intWakeupTime Then
        SoundPlay(@WindowsDir & "\media\tada.wav",0)
        if $RunType = "GUI"  Then
			wol_selected()
		Else
			wol_all()
		EndIf
			

	select 
		case $RunType = "COMMANDLINE" 
		Select 
			case $CommandlineCompleteCommand="EXIT"
				Exit
			case Else
;~ 				RESTART			
				$boolTimerActive=1
				DisableControls(1)
				sleep(500)
		EndSelect
		
		case else
;~ 		GUI
	EndSelect
	EndIf
EndFunc 
; ===================================================================
; Function: FillTimeCombos
;          filling the controls with data 
; ===================================================================
func FillTimeCombos()
    for $i=1 to 9
            GUICtrlSetData($mvinpWakeupTimeHH,"0"&$i)
            GUICtrlSetData($mvinpWakeupTimeMM,"0"&$i)
            GUICtrlSetData($mvinpWakeupTimeSS,"0"&$i)
			
        Next
    for $i=10 to 23 
            GUICtrlSetData($mvinpWakeupTimeHH,$i)
        Next

	for $i=10 to 59
            GUICtrlSetData($mvinpWakeupTimeMM,$i)
            GUICtrlSetData($mvinpWakeupTimeSS,$i)
	Next
    
EndFunc


; ===================================================================
; Function: readmacfile
;           reads mac list in ini format
; ===================================================================
func readmacfile($filemaclist="MACLIST.DAT")
    if FileExists($filemaclist) Then
        $aMaclist=IniReadSection(@scriptdir&"\"&$filemaclist,"MACLIST")
        _GUICtrlListView_DeleteAllItems($mwlvMacadresses) 
        for $i  = 1 to $aMaclist[0][0] 
                GUICtrlCreateListViewItem(""&$aMaclist[$i][1]&"|"&$aMaclist[$i][0]&"", $mwlvMacadresses)    
            Next
    EndIf
            
    
    EndFunc
; ===================================================================
; Function: getmacinrange
;           simple try to get all mac adresses from a given range (only last segment)
; ===================================================================
func getmacinrange()
    FileDelete(@ScriptDir&"\"&$filemaclist)
    $aIpStart=StringSplit(GUICtrlRead($mvinpIpStart),".")
    $aIpStop=StringSplit(GUICtrlRead($mvinpIpStop),".")
    
    
                for $IpSegD = $aIpStart[4] to $aIpStop[4]
                    get_mac($aIpStart[1]&"."&$aIpStart[2]&"."&$aIpStart[3]&"."&$IpSegD) 
                Next
                readmacfile()

EndFunc

; ===================================================================
; Function: togglelistviewcheckboxes($listviewcontrol,$state)
;           $listviewcontrol      --- Handle of control
;           unmark all entries in a list
; ===================================================================
func togglelistviewcheckboxes($listviewcontrol,$state)
	for $i = 0 to _GUICtrlListView_GetItemCount($listviewcontrol)
		_GUICtrlListView_SetItemChecked($listviewcontrol,-1,$state)
	next
EndFunc


; ===================================================================
; Function: wol_selected
;   sents magic paket to the macadress selected in listview
; ===================================================================
func wol_selected()
	local $SelectedMacEntries=0
	local $SelectedNetworkAdapters=0
	local $WOLSendCounter=0
	for $i = 0 to _GUICtrlListView_GetItemCount($mwlvMacadresses)
		if _GUICtrlListView_GetItemChecked($mwlvMacadresses, $i) Then
			$SelectedMacEntries=$SelectedMacEntries+1
			
				_DebugConsole("Adresses:"&$SelectedMacEntries)
				local $SelectedNetworkAdapters=0
				for $j = 0 to _GUICtrlListView_GetItemCount($mwlvNetWorkAdapters)
					if _GUICtrlListView_GetItemChecked($mwlvNetWorkAdapters, $j) Then
						$SelectedNetworkAdapters=$SelectedNetworkAdapters+1
						_DebugConsole("Adapters:"&$SelectedNetworkAdapters)

							local $macadress=_GUICtrlListView_GetItemText($mwlvMacadresses,$i)
							local $adapter =_GUICtrlListView_GetItemText($mwlvNetWorkAdapters,$j,1)
 							wol_adapter($adapter,$macadress)
							_DebugConsole("WOL for MAC:"&$macadress&" on ADAP:"&$adapter)
 							setStatusMsg("Check "&$macadress&" awake?")
							$WOLSendCounter=$WOLSendCounter+1
					EndIf
					
				Next
			
			
		EndIf
	Next
	if $WOLSendCounter<>0 then 
		msgbox(64,"WOLLE","Done",60)
	EndIf   
	if $SelectedMacEntries=0 then 
		msgbox(64,"WOLLE","Sorry, no MAC/Ip selected for WakeUp")
	EndIf    
	if $SelectedNetworkAdapters=0 then 
		msgbox(64,"WOLLE","Sorry, no Adapter for Broadcast selected")
	EndIf    

endfunc

; ===================================================================
; Function: wol_all
; 
; ===================================================================
func wol_all()
    togglelistviewcheckboxes($mwlvMacadresses,true)
    togglelistviewcheckboxes($mwlvNetWorkAdapters,true)
    wol_selected()
endfunc
; ===================================================================
; Function: setStatusMsg($msgtext)
;           $msg    --- Message for status text
; ===================================================================
func setStatusMsg($msgtext)
    GUICtrlSetData($mwlblStatus,"Status:"&$msgtext)
endfunc
; ===================================================================
; Function: setStatusMsgNext($msgtext)
;           $msg    --- Message for status text
; ===================================================================
func setStatusMsgNext($msgtext)
    GUICtrlSetData($mwlblStatusNext,"Next trigger in:"&$msgtext)
endfunc
; ===================================================================
; Function: wol_adapter($adapter,$$macadress)
;           $adapter        --- is the ipadress of the adapter
;          $macadress       --- is the macadress
; ===================================================================

func wol_adapter($adapter,$macadress)
    if $adapter <> "0.0.0.0" Then
        $IPADRESS = StringSplit($adapter,".")
        $Broadcast = $IPADRESS[1] & "." & $IPADRESS[2] & "." & $IPADRESS[3] & "." & "255"

        $String=""
                setStatusMsg("Sent WOL via "&$Broadcast&" for:"&$macadress)
				_DebugConsole("Sent WOL via "&$Broadcast&" for:"&$macadress)
                WOL($Broadcast,$macadress)
    EndIf
    
    EndFunc

; ===================================================================
; Function: WOL($Broadcast,$element)
;          $Broadcast       --- is ipadress of adapter with 255 at the End
;           $MACAddress     --- is the macadress 
; ===================================================================

; Wake up on Lan Function (Open connection and broadcast to Lan)
Func WOL($Broadcast,$MACAddress)
UDPStartUp()
$connexion = UDPOpen($Broadcast,7)
UDPSend($connexion, GenerateMagicPacket($MACAddress))
UDPCloseSocket($connexion)
UDPShutdown()
EndFunc


; This function convert a MAC Address Byte (e.g. "1f") to a char
Func HexToChar($strHex)
    
    Return Chr(Dec($strHex))
    
EndFunc

; This function generate the "Magic Packet"
Func GenerateMagicPacket($strMACAddress)
    
    $MagicPacket = ""
    $MACData = ""
    
    For $p = 1 To 11 Step 2
        $MACData = $MACData & HexToChar(StringMid($strMACAddress, $p, 2))
    Next
    
    For $p = 1 To 6
        $MagicPacket = HexToChar("ff") & $MagicPacket
    Next
    
    For $p = 1 To 16
        $MagicPacket = $MagicPacket & $MACData
    Next
    
    Return $MagicPacket
    
EndFunc

; ===================================================================
; Function: get_mac($remote_ip,$filemaclist)
;           $remote_ip      --- remote ip
;           $filemaclist    --- file in ini format
; enhanced by TheSovereign - skip local mac adress
; ===================================================================
func get_mac($remote_ip,$filemaclist="MACLIST.DAT")
                    Ping($remote_ip,200)
                    if @error =0 Then
                        $arpinfo = Run(@ComSpec & " /c ARP -a "&$remote_ip, @SystemDir, @SW_HIDE, 2)
                        sleep(200)
                        $output = StdoutRead($arpinfo, -1)
                            $aOutputLine=StringSplit($output,@CRLF)
                            If UBound($aOutputLine) > 5 Then ; <=== added so script doesn't choke when processing the IP for the computer it's running on
                                $macadress=Stringmid($aOutputLine[7],25,17)
                                $macadress=StringReplace($macadress,"-","")
                                IniWrite(@ScriptDir&"\"&$filemaclist,"MACLIST",$remote_ip,$macadress)
                                setStatusMsg("Found maclist "&$macadress)
                            EndIf ; <=== and this one...

                        Else
                            setStatusMsg("Host "&$remote_ip&" not reachable")
                            Return
                        endif
                    EndFunc
 
 
 
 
; ===================================================================
; Function: addNetworkAdapters2ListView()
;           Adds all networkadapters to the listviw
; ===================================================================
Func addNetworkAdapters2ListView()
        _GUICtrlListView_DeleteAllItems($mwlvNetWorkAdapters) 
        for $i = 0 to Ubound($aNetWorkAdapters)-1
                GUICtrlCreateListViewItem(""&$aNetWorkAdapters[$i][0]&"|"&$aNetWorkAdapters[$i][1], $mwlvNetWorkAdapters)    
        Next
    _GUICtrlListView_SetColumnWidth($mwlvNetWorkAdapters,0,$LVSCW_AUTOSIZE)

EndFunc
; ===================================================================
; Function: _getnetworkadapter()
;           Get All Network adapters with WMI
;			@IPAddressx does only support 4 
; Original : 99ojo http://www.autoitscript.com/forum/index.php?showtopic=107247&view=findpost&p=756774
; ===================================================================

; WMI get only Adapter with ip settings
; If WMI fail or no adapter with ip settings Return 0
Func _getnetworkadapter ()
    $wbemFlagReturnImmediately = 0x10
    $wbemFlagForwardOnly = 0x20
    $colItems = ""
    $found = False
    $strComputer = "localhost"
    $count = 0
    $objWMIService = ObjGet("winmgmts:\\" & $strComputer & "\root\CIMV2")
    $colItems = $objWMIService.ExecQuery("SELECT * FROM Win32_NetworkAdapterConfiguration", "WQL", _
                                              $wbemFlagReturnImmediately + $wbemFlagForwardOnly)

    If IsObj($colItems) then
        For $objItem In $colItems
            If StringInStr ($objItem.IPAddress(0), ".") <> 0 Then
                ReDim $aNetWorkAdapters [$count + 1] [2]
                $aNetWorkAdapters [$count] [0] = $objItem.Caption ;corrected to $count
                $aNetWorkAdapters [$count] [1] = $objItem.IPAddress(0) ;corrected to $count
                $count += 1
                $found = True
            EndIf
        Next
    Else
        Return 0
    EndIf
    If Not $found Then Return 0
EndFunc
; ===================================================================
; Function: _DebugConsole()
;           Simple Console Output
; =================================================================== 
Func  _DebugConsole($strString)
	consolewrite(@HOUR&@MIN&@SEC&" :"&$strString&@LF)
	EndFunc