;Windows Management Tool
;Developed by Paul Wilson
;Version 0.2 beta
;
; 0.3b - Implemented Embeded RDP
;
; 0.2 - Improvements and Mods
; a. Perfected Recent list of hosts
;	 1. Added Dynamic Menubar logic and Functionality
; b. Changed About MsgBox to SplashText
; c. Execution Logic Mod
;	 1. Moddified Execution to account for recent host list
; d. Removed SystemTray Icon
;
; 0.1 - Original Release - Initial Design and Functionality (Scope/Purpose: Domain Admin usage/Remote Administration of Windows PCs)
; a. GUI Design - (Menubar, Buttons, Statusbar)
; b. Created Functions for buttons
;	 1. System Info - Runs msinfo32 against remote pc
;	 2. Manage System - Runs Computer Management MMC against remote pc
;	 3. Explore | Browse - Browses remote pc
;	 4. Remote Desktop - Verifies Remote Desktop is available/enabled and connects to remote pc
; c. GUI Function Logic
;	 1. Enabled/Disable buttons
;	 2. Statusbar Logic
;	 3. Window Fade
;	 4. Execution Logic

#region Included and Refferences
#Include <GUIConstants.au3>
#Include <GuiStatusBar.au3>
#endregion

#region GUI Layout
$gui = GUICreate("Windows Management Tool",250,150,-1,-1)
Fade("Windows Management Tool","",50,-1)

;Hide Tray Icon
TraySetState(2)

;Variables
Global $hostname, $hostlist[1]
$hostlist[0] = "none"

;Menu Bar
$filemenu = GUICtrlCreateMenu ("&File")
	$fileitem = GUICtrlCreateMenuitem ("Connect",$filemenu)
	GUICtrlSetState(-1,$GUI_DEFBUTTON)
	$recentfilemenu = GUICtrlCreateMenu ("Recent",$filemenu,1)
	$separator1 = GUICtrlCreateMenuitem ("",$filemenu,2)
	$exititem = GUICtrlCreateMenuitem ("Exit",$filemenu)
$viewmenu = GUICtrlCreateMenu("&View")
	$viewstatusitem = GUICtrlCreateMenuitem ("Statusbar",$viewmenu)
	GUICtrlSetState(-1,$GUI_CHECKED)
$helpmenu = GUICtrlCreateMenu ("&Help")
	$infoitem = GUICtrlCreateMenuitem ("About",$helpmenu)

;Status Bar
$StatusBar1 = _GUICtrlStatusBarCreate ($gui, 250, "Idle")

;Buttons
$sysinfobutton = GUICtrlCreateButton ("System Info",15,15,100,30)
$managebutton = GUICtrlCreateButton ("Manage System",135,15,100,30)	
$explorebutton = GUICtrlCreateButton ("Explore | Browse",135,60,100,30)
$remotedesktopbutton = GUICtrlCreateButton ("Remote Desktop",15,60,100,30)
#endregion

#region User Created Functions
;Gui Functions
Func DisableButtons()
	GUICtrlSetState($sysinfobutton,$GUI_DISABLE)
	GUICtrlSetState($managebutton,$GUI_DISABLE)
	GUICtrlSetState($explorebutton,$GUI_DISABLE)
	GUICtrlSetState($remotedesktopbutton,$GUI_DISABLE)	
EndFunc 

Func EnableButtons()
	GUICtrlSetState($sysinfobutton,$GUI_ENABLE)
	GUICtrlSetState($managebutton,$GUI_ENABLE)
	GUICtrlSetState($explorebutton,$GUI_ENABLE)
	GUICtrlSetState($remotedesktopbutton,$GUI_ENABLE)	
EndFunc 

Func Init()
	DisableButtons()    
	_GUICtrlStatusBarSetText($StatusBar1, "Idle")
EndFunc

;Special Functions
Func PingHost($host)
	_GUICtrlStatusBarSetText($StatusBar1, "Attempting to ping " & $host & " ...")
	$result = Ping($host,250)
	If @error = 0 Then 
		$strActualHost = ActualHost($host)
		If $strActualHost <> "0" Then
			EnableButtons()
			$found = False
			For $i = 0 to UBound($hostlist) - 1
				if $host = $hostlist[$i] then $found = True
			Next
			If $found <> True then RecentList($host)
			
			$hostname = $strActualHost
			_GUICtrlStatusBarSetText($StatusBar1, "Connected to " & $hostname & "...")
		EndIf
	Else
		_GUICtrlStatusBarSetText($StatusBar1, "Idle - Failed to ping " & $host)
	EndIf
EndFunc

Func ConnectTo()
    Init()
	$hostname = InputBox("Connect to...", "Hostname to connect to?", "localhost", "",50,100)
	if $hostname <> "" then PingHost($hostname)
EndFunc

Func RecentList($host)
	If $hostlist[0] <> "none" Then
		ReDim $hostlist[UBound($hostlist)+1]
		$hostlist[UBound($hostlist)-1] = $host
	Else
		$hostlist[0] = $host
	EndIf
	
	GUICtrlCreateMenuitem ($hostlist[UBound($hostlist)-1],$recentfilemenu)
EndFunc

Func ActualHost($host)
	_GUICtrlStatusBarSetText($StatusBar1, "Checking hostname...")
	$objWMIService = ObjGet("winmgmts:{impersonationLevel=impersonate}!\\" & $host & "\root\CIMV2")
	If not IsObj($objWMIService) then
		_GUICtrlStatusBarSetText($StatusBar1, "Idle - Failed to connect to " & $host)
	Else
		$colItems = $objWMIService.ExecQuery ("SELECT * FROM Win32_ComputerSystem")
		For $objItem In $colItems
			$strHost = $objItem.name
		Next
		If StringUpper($host) = $strHost then return $strHost
		If StringLower($host) = "localhost" then return $strHost
		$strFirstIPOctet = StringLeft($host,2)
		If IsNumber(Number($strFirstIPOctet)) then return $strHost
		Return 0
	EndIf
	$objWMIService = 0
EndFunc

Func RemoteDesktop($host)
	$oReg = ObjGet("winmgmts:{impersonationLevel=impersonate}!\\" & $host & "\root\default:StdRegProv")
	If not IsObj($oReg) Then
		_GUICtrlStatusBarSetText($StatusBar1, "Idle - Failed to connect to " & $host)
	Else
		$HKLM = 2147483650
		$strKeyPath = "SOFTWARE\Microsoft\Windows NT\CurrentVersion"
		$strValueName = "ProductName"
		local $szValue
		$oReg.GetStringValue ($HKLM, $strKeyPath, $strValueName, $szValue)
		If StringInStr($szValue,"2000") > 0 Then
			msgbox(48,"Windows 2000 Detected","Remote Desktop is not available on Windows 2000.")
		Else			
			$strKeyPath = "SYSTEM\CurrentControlSet\Control\Terminal Server"
			$strValueName = "fDenyTSConnections"
			local $dwValue
			$oReg.GetDWORDValue ($HKLM, $strKeyPath, $strValueName, $dwValue)
			if $dwValue <> 0 then
				$iMsgBoxAnswer = MsgBox(52,"Remote Desktop Disabled","Would you like to Enable RemoteDesktop?")
				If $iMsgBoxAnswer = 6 then
					$oReg.SetDWORDValue ($HKLM, $strKeyPath, $strValueName, 0)
					MsgBox(64,"Remote Desktop Enabled","A reboot may be necessary if you cannot connect after a few moments.")
				EndIf
			EndIf
			run(@comspec & ' /c ' & "mstsc.exe /v:" & $host,@TempDir,@SW_HIDE)
		EndIf
	EndIf
EndFunc

Func Manage($host)
	run(@comspec & ' /c ' & "compmgmt.msc /computer=\\" & $host,@tempdir,@SW_HIDE)
EndFunc 

Func Explore($host)
	run(@comspec & ' /c ' & "start \\" & $host,@tempdir,@SW_HIDE)
EndFunc 

Func SystemInfo($host)
	run(@comspec & ' /c ' & "%windir%\system32\dllcache\msinfo32.exe /computer " & $host,@tempdir,@SW_HIDE)
EndFunc 

Func Fade($windowname,$windowtext,$speed,$direction)
	Select
		Case $direction = -1
			For $x = 255 to 1 step $speed * -1
				WinSetTrans($windowname, $windowtext, $x)
				sleep(10)
			Next
		Case $direction = 0
			For $x = 1 to 255 step $speed * 1
				WinSetTrans($windowname, $windowtext, $x)
				sleep(10)
			Next
	EndSelect
EndFunc

Func RDPConnection()
	
EndFunc
#endregion

#region Execution - GUI Logic
;Show Gui 
Init()
GUISetState ()
Fade("Windows Management Tool","",6,0)

;Execution - Gui Logic
While 1

	$msg = GUIGetMsg()
	
    If $msg = $sysinfobutton then SystemInfo($hostname)
	If $msg = $managebutton then Manage($hostname)
	If $msg = $explorebutton then Explore($hostname)
	If $msg = $remotedesktopbutton then RemoteDesktop($hostname)
	If $msg = $fileitem Then ConnectTo()

    If $msg = $viewstatusitem Then
        If BitAnd(GUICtrlRead($viewstatusitem),$GUI_CHECKED) = $GUI_CHECKED Then
            GUICtrlSetState($viewstatusitem,$GUI_UNCHECKED)
            _GuiCtrlStatusBarShowHide($StatusBar1, @SW_HIDE)
        Else
            GUICtrlSetState($viewstatusitem,$GUI_CHECKED)
            _GuiCtrlStatusBarShowHide($StatusBar1, @SW_SHOW)
        EndIf
    EndIf
	
    If $msg = $GUI_EVENT_CLOSE Or $msg = $exititem Then ExitLoop
    If $msg = $infoitem Then 
		SplashTextOn("About Information",@LF & "Version 0.2 beta" & @CRLF & "Built with AutoIt v3",200,80,-1,-1,1)
		Sleep(2500)
		SplashOff()
	EndIf
	
	If $msg > 15 then
		;$id = $msg
		For $i = 0 to UBound($hostlist) - 1
			If GUICtrlRead($msg,1) = $hostlist[$i] then 
				Init()
				PingHost($hostlist[$i])
			EndIf
		Next
	EndIf
	
WEnd

;Kill Gui
Fade("Windows Management Tool","",6,-1)
GUIDelete()
Exit
#endregion
