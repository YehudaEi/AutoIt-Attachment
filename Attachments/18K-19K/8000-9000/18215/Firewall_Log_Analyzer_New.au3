;--------------------------------------------
;FireWall Log Analyzer
;
;My first AutoIT project and first programming, with a little help of my friends (AutoIT Forum)
;PTRex started 29/06/05
;
;Completed: 
;# Lines Selection
;Auto Refresh
;Show Exception Apps & Open Ports
;Included hyperlink
;Drag&Drop columns + Sort columns header
;Check on Domain or Local Profile registry settings
;Included FW object
;Check status FW On or Off using WMI techniques
;Include IE Object browser
;Include Whois function
;Included improved GUI, lock and Wait functions Gafrost
;---------------------------------------------

;Includes
#include <GuiConstants.au3>
#include <Array.au3>
#include <GuiListView.au3>
#include <GuiTab.au3>
#NoTrayIcon


;Declare Vars
Dim $Font ="Arial Bold"
Dim $OS = @OSVersion
Dim $SP = @OSServicePack
Dim $aArray
Dim $AvArray[14]
Dim $Datacol
Dim $Combo2Item, $Help, $Info
Dim $Button_ON, $Label_ON, $Status
Dim $IP, $Line
Dim $DataListApps, $DataListPorts, $Browser, $HTTP
Dim $ObjFirewall, $ObjPolicy, $On_off
Dim $oMyError

; Initialize SvenP 's  error handler 
$oMyError = ObjEvent("AutoIt.Error","MyErrFunc")

;Main GUI
;---------
$Gui = GuiCreate("Firewall Log Analyzer for XP v1.3", 975, 571,(@DesktopWidth-975)/2, (@DesktopHeight-571)/2 , _ 
$WS_OVERLAPPEDWINDOW + $WS_VISIBLE + $WS_CLIPSIBLINGS)

$Helpmenu = GUICtrlCreateMenu ("?")
$Helpitem = GUICtrlCreateMenuitem ("Help",$Helpmenu)
$Infoitem = GUICtrlCreateMenuitem ("Info",$Helpmenu)

$Tab=GUICtrlCreateTab (8,30, 962,520)
GUICtrlSetResizing ($Tab,$GUI_DOCKAUTO)

;Tab1
$Tab1=GUICtrlCreateTabitem ("LogData")
$ListView = GUICtrlCreateListView("date|time|action| protocol| src-ip| dst-ip| src-port| dst-port| size| tcpflags|tcpsyn| tcpack| tcpwin| icmptype" _
, 10, 60, 957, 483,-1,$LVS_EX_HEADERDRAGDROP+$LVS_EX_FULLROWSELECT) ;Drag&Drop Columns
GUICtrlSetResizing ($Listview,$GUI_DOCKAUTO)
GUICtrlSetState($ListView,$GUI_FOCUS)
GUICtrlSetImage($ListView, "xpsp2res.dll", -68) ;Set Icons for records Important see - index nr.
_GUICtrlListView_SetColumnWidth ($listview, 0,90) ;Set Column with

$Tab1combo1=GUICtrlCreateCombo ("# Lines", 10,6,60,40)
GUICtrlSetData(-1,"100|150|300|500|1000|2000|3000|4000", "100") 	;Set default 100
GUICtrlCreateLabel("Select # of lines",80,10)

$Tab1combo2=GUICtrlCreateCombo ("Auto Refresh  ", 200,6,100)
GUICtrlSetData(-1,"1|5|10|20|30") 									;Set default none

$Refresh = GuiCtrlCreateButton("Refresh", 852, 6, 90, 30)
GUICtrlSetTip($Refresh,"Use this button to manually refresh the data")

$Button_ON = GUICtrlCreateButton ("FW Status ", 380,5,40,40, $BS_ICON) ;Check status of FW & set Icon & Label
GUICtrlSetTip($button_ON,"Use this button to manually refresh the status") 
Enabled() 															

$Whois = GuiCtrlCreateButton("Whois", 650, 6, 90, 30)
GUICtrlSetTip($Whois,"Select an item in the list, and then use click the WHOIS button")

$Status= GUICtrlCreateLabel("Your firewall is " & $Label_ON ,440,10,$SS_SUNKEN)	;Create Label with variable FW status data

$Refresh_label= GUICtrlCreateLabel("Seconds",320,10,$SS_SUNKEN)

;Tab2
$Tab2=GUICtrlCreateTabitem ( "Whois ")
$oIE = ObjCreate("Shell.Explorer.2") 								;Include Embedded IE Object
$GUIActiveX	= GUICtrlCreateObj	($oIE,	10, 60 , 952 , 486)
GUICtrlSetStyle ( $GUIActiveX,  $WS_VISIBLE )						;Show IE Object on tab2
GUICtrlSetResizing ($GUIActiveX,$GUI_DOCKAUTO)
$oIE.navigate("http://www.ripe.net")

;Tab3
$Tab3=GUICtrlCreateTabitem ( "Firewall Config ")

$Listbox1 = GUICtrlCreateList("", 10, 70, 930, 225)
GUICtrlSetResizing ($Listview,$GUI_DOCKAUTO)
GUICtrlCreateLabel("Applications allowed : ",15,55)
GUICtrlSetColor(-1,0xff0000) 										;Set Red color
GUICtrlSetFont (-1,7.5, 100, 4, $font)								;Set Font
Open_apps()

$Listbox2 = GUICtrlCreateList("", 10, 300, 930, 225)
GUICtrlSetResizing ($Listview,$GUI_DOCKAUTO)
GUICtrlCreateLabel("Open Ports : ",15,285)
GUICtrlSetColor(-1,0xff0000)
GUICtrlSetFont (-1,7.5, 100, 4, $font)
Open_ports()

$Link = GuiCtrlCreateLabel("Click here for more info : Ports Database", 120, 285, 290, 12)
GUICtrlSetColor ( -1, 0x0000ff) 									;Set Blue color
GUICtrlSetFont (-1, 7.5 , 100 , 4 )									;Set Font
GUICtrlSetCursor ( -1, 0 )											;Activate Hyperlink function
GetBrowser()

GUICtrlSetState($Tab1,$GUI_SHOW) ; Show first Tab as default
GUICtrlCreateTabitem ("") ; End of Tabs

;Error checking : Test OS = XP/SP2 
;----------------------------------
If $OS <> "Win_XP"  Then
	MsgBox (0, "Your OS is not XP : ", $OS, 3)
	ElseIf  $SP <> "Service Pack 2"  Then
	MsgBox (0, "Your OS is not on SP2 : ", $SP, 3)
Else 								
$filename = @WindowsDir &"\pfirewall.log" 								;Open the file and read data
EndIf

_LockAndWait()
Getdata()
_ResetLockWait()	

;GUI handling
;------------
GuiSetState()

GUIRegisterMsg($WM_NOTIFY, "WM_NOTIFY") ;Used by Sort Click Header
Global $B_DESCENDING [_GUICtrlListView_GetColumnCount ($ListView) ]


While 1
	$msg = GuiGetMsg()
	Select
	Case $msg = $GUI_EVENT_CLOSE
		ExitLoop
	Case $msg = $Tab1combo1 										;Read Combo Data
		GUICtrlRead($Tab1combo1)
		 Status()
	Case $msg = $Tab1combo2 
		Do
		 AutoRefresh()												;Run Auto Refresh per Second
		 sleep ($Combo2Item * 1000)
		 DeleteList()
		 Getdata()
		 Status()
		Until $Combo2Item = 0 Or $msg = $GUI_EVENT_CLOSE
	Case $msg = $Button_ON											;Read Firewall ON_OFF Status
		 Status()
	Case $msg = $Whois
		 ReadLine()
		 Status()
	Case $msg= $Link												;Active Hyperlink
        run($HTTP,"",@SW_MAXIMIZE)		
	Case $msg = $infoitem
		Info()
		Msgbox(0,"Info",$Info)
	Case $msg = $Helpitem
		Help()
		Msgbox(0,"Help",$Help)
	Case else
		If $msg = $Refresh Then
		DeleteList()
		_LockAndWait()
		Getdata()
		_ResetLockWait()
		Status()	
		EndIf
	EndSelect
WEnd
Exit

;Functions
;----------
Func Enabled() 														 
		$objFirewall = ObjCreate("HNetCfg.FwMgr")
		$objPolicy = $objFirewall.LocalPolicy.CurrentProfile
		Status()
EndFunc

Func Status()														;Check Firewall Status using WMI
	$on_off = $objPolicy.FirewallEnabled
	If $on_off = -1 Then
		GUICtrlSetImage($Button_ON, "xpsp2res.dll", -69) ;Set Icons for records Important see - index nr.
		$Label_ON = "enabled"
	Else 
		GUICtrlSetImage($Button_ON, "xpsp2res.dll", -67) 
		$Label_ON = "disabled"		
	Endif
	GUICtrlSetData($Status,"Your firewall is " & $Label_ON)
EndFunc	

Func Getdata()
$File = FileOpen($Filename,0)
	If $file = -1 Then												;Check if file is opened for reading, OK
	MsgBox(0, "Error", "Unable to open file. Make sure that your Firewall Logging is turned on !!")
		Exit
	EndIf
$Combo1Item=Number(GUICtrlRead($Tab1combo1))						;Get # of lines selected
$aArray = StringSplit(FileRead($file,FileGetSize($filename)),@LF)	;Read lines of text until the EOF is reached		
 for $i = (UBound($aArray) - 2) to $i+1-$combo1Item Step -1 		;Ubound read lines bottom up, to # of lines
	$string = StringSplit($aArray[$i], " ", 0)						;Split lines in 17 dimensions
	For $a=0 To 13													;Assign each 13 dimensions to a new Array
      $avArray[$a]=$string[$a]
	next															;Create string for displaying in ListView
	$data=$avArray[1]&"|"&$avArray[2]&"|"&$avArray[3]&"|"&$avArray[4]&"|"&$avArray[5]&"|" _	
	&$avArray[6]&"|"&$avArray[7]&"|"&$avArray[8]&"|"&$avArray[9]&"|"&$avArray[10]&"|"&$avArray[11]&"|"&$avArray[12]&"|"&$avArray[13]
	$dataCol=GUICtrlCreateListViewItem($data,$listview)
Next
FileClose($file)
EndFunc
	
Func DeleteList()
	_GUICtrlListView_DeleteAllItems ($listview)	
EndFunc

Func AutoRefresh()
	$combo2Item=Number(GUICtrlRead($Tab1combo2)) 					;Read # of seconds
EndFunc

Func GetBrowser() 													;Get Registry Default Browser settings
	$Browser = StringSplit(RegRead("HKLM\SOFTWARE\Classes\HTTP\shell\open\command",""),"%")
	$HTTP = $Browser[1] & " " & "http://www.grc.com/port_0.htm" ; "www.portsdb.org/bin/portsdb.cgi" 
EndFunc

Func ReadLine()														;Read Selected IP Address from ListView
	$line = _GUICtrlListView_GetItemTextArray ($listview)
	If $line = $LV_ERR or $line = "" Then 
		MsgBox(0, "Retry Again", "Nothing Selected, click the first column to select an item.",5)
	Else
	$IP = $Line[5] 	
		MsgBox(0, "Source IP Selected", $IP,5)
		RipeWhois()
	EndIf
EndFunc
	
Func Open_Apps()
	$i = 1
	Do
	$Apps = RegEnumVal("HKLM\SYSTEM\CurrentControlSet\Services\SharedAccess\Parameters\FirewallPolicy\DomainProfile\AuthorizedApplications\List", $i)
	$i += 1
	$DataListApps = $DatalistApps & $Apps & "|"
	if @error <> 0 Then ExitLoop ; Added as of Beta 120
	Until $Apps =""
	GUICtrlSetData($listbox1,$DataListApps)
EndFunc	

Func Open_Ports()
	$i = 1
	Do
	$Ports = RegEnumVal("HKLM\SYSTEM\CurrentControlSet\Services\SharedAccess\Parameters\FirewallPolicy\DomainProfile\GloballyOpenPorts\List", $i)
	$i += 1
	$DataListPorts =  $datalistPorts & $Ports & "|"
	if @error <> 0 Then ExitLoop ; Added as of Beta 120
	Until $Ports =""
	GUICtrlSetData($Listbox2,$DataListPorts)
EndFunc	

Func RipeWhois() 
$URL = "http://www.ripe.net/whois?form_type=simple&full_query_string=&searchtext="&$IP&"&do_search=Search"
$oIE.navigate($URL)
GUICtrlSetState($tab2,$GUI_SHOW) 										;Jump to and show Tab3
Endfunc

;GUI lock's from Gafrost
Func _LockAndWait()
	Local $Cursor_WAIT
    GUISetState(@SW_LOCK)
    GUISetCursor($Cursor_WAIT, 1)
EndFunc  ;==>_LockAndWait

Func _ResetLockWait()
	local $Cursor_ARROW
    GUISetState(@SW_UNLOCK)
    GUISetCursor($Cursor_ARROW, 1)
EndFunc  ;==>_ResetLockWait

Func WM_NOTIFY($hWnd, $iMsg, $iwParam, $ilParam) ; HeaderSort
	Local $hWndFrom, $iIDFrom, $iCode, $tNMHDR, $hWndListView
	;_LockAndWait()
	$hWndListView = $ListView
	If Not IsHWnd($ListView) Then $hWndListView = GUICtrlGetHandle($ListView)

	$tNMHDR = DllStructCreate($tagNMHDR, $ilParam)
	$hWndFrom = HWnd(DllStructGetData($tNMHDR, "hWndFrom"))
	$iIDFrom = DllStructGetData($tNMHDR, "IDFrom")
	$iCode = DllStructGetData($tNMHDR, "Code")
	Switch $hWndFrom
		Case $hWndListView
			Switch $iCode
				Case $LVN_COLUMNCLICK ; A column was clicked
					Local $tInfo = DllStructCreate($tagNMLISTVIEW, $ilParam)
						_GUICtrlListView_SimpleSort ($hWndListView, $B_DESCENDING, DllStructGetData($tInfo, "SubItem"))
					; No return value
			EndSwitch
	EndSwitch
	
	;_ResetLockWait()
	;Status()
	Return $GUI_RUNDEFMSG
EndFunc

;This Custom error handler
Func MyErrFunc()
  $HexNumber=hex($oMyError.number,8)
  Msgbox(0,"COM Error","We intercepted a COM Error !"       & @CRLF  & @CRLF & _
			 "err.description is: "    & @TAB & $oMyError.description    & @CRLF & _
			 "err.windescription:"     & @TAB & $oMyError.windescription & @CRLF & _
			 "err.number is: "         & @TAB & $HexNumber              & @CRLF & _
			 "err.lastdllerror is: "   & @TAB & $oMyError.lastdllerror   & @CRLF & _
			 "err.scriptline is: "     & @TAB & $oMyError.scriptline     & @CRLF & _
			 "err.source is: "         & @TAB & $oMyError.source         & @CRLF & _
			 "err.helpfile is: "       & @TAB & $oMyError.helpfile       & @CRLF & _
			 "err.helpcontext is: "    & @TAB & $oMyError.helpcontext _
			)
  SetError(1)  ; to check for after this function returns
Endfunc


Func Info()
	$Info = "Sytem Requirements :"&@CR&@CR& _
			"- In order to use this application you need to have XP/SP2."&@CR&@CR& _
			"- You need to activate the firewall logging."&@CR& _
			"  Goto : Control Panel-> Security Center-> Windows Firewall->"&@CR& _
			"  Advanced-> Select Security Logging-> Settings->"&@CR&@CR&"  Select : Log Dropped Packets"    
EndFunc

Func Help()
	$Help = "Number of line :"&@CR& _
			"- This will allow you to select more lines from the firewall logging, than the default 100."&@CR&@CR& _
			"Auto Refresh :"&@CR& _
			"- This will allow you to set an 'Auto Refresh' rate in seconds."&@CR&@CR& _
			"Firewall Status :"&@CR& _
			"- If your firewall is enabled, the 'GREEN' icon will appear."&@CR& _
			"- If an external application disables your firewall, the 'RED' icon will appear."&@CR& _
			"  This will also happen when you turn off your firewall manually."&@CR& _
			"  The status will be updated, whenever you use any of the functions in this application."&@CR&@CR& _
			"Whois :"&@CR& _
			"- You can use the 'Whois' button, after you made a selection of an item in the list."&@CR& _
			"  By clicking this button, it will read the source IP address from you selection, and show it."&@CR& _
			"  After that, it will redirect you to the whois database on the internet. Here you can read"&@CR& _
			"  extensive information on who is trying to access you computer from the outside."&@CR&@CR& _
			"Refresh :"&@CR& _
			"- This button will allow you to manually update the data."&@CR&@CR& _
			"LogData :"&@CR& _
			"- This shows the XP Personal Firewall logdata. Most recent items on top of the list."&@CR& _
			"- It is possible to drag the columns in a different order."&@CR& _
			"- Clicking on the column headers will reorder the list accordingly."&@CR&@CR& _
			"Firewall config :"&@CR& _
			"- This shows the configuration settings of your firewall."&@CR& _
			"  In applications allowed, you will see which application are allowed to go through the firewall."&@CR& _
			"  In open ports, you can see which ports are configured as open. If you need more info on"&@CR& _
			"  which port has which function, you can click the hyperlink."&@CR& _
			"  This will redirect you to the internet, to search for more info on any specific protocol and port"
EndFunc
