#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=warning.ico
#AutoIt3Wrapper_UseX64=n
#AutoIt3Wrapper_Res_Comment=Shutdown/Reboot/Logoff Blocker is tested for WinXp (SP3) and Win7 64 (SP1)
#AutoIt3Wrapper_Res_Description=Shutdown/Reboot/Logoff Blocker
#AutoIt3Wrapper_Res_Fileversion=1.0.0.0
#AutoIt3Wrapper_Res_requestedExecutionLevel=highestAvailable
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

;http://www.autoitscript.com/forum/topic/133896-prevent-shutdownsleep-in-vista7/
;by /Manko, modified by T_Bear

;This app made as a helper app for an installation app to block shutdown while an installation is running.
;It consists of two scripts, one to block, and another to thell the blocking app to stop.
;This is the blocking app, run the shutdownblocker_close to stop this app. (it will send a WM_CLOSE to this app)
;inputs params are: "Title to be displayed" "Message to be displayed" [/debug]

AutoItSetOption("TrayAutoPause","0")
AutoItSetOption("MustDeclareVars", True)
AutoItSetOption("TrayIconHide", True)
AutoItSetOption("ExpandEnvStrings", True)
AutoItSetOption("TrayOnEventMode", True)
AutoItSetOption("WinTitleMatchMode", 3) ;Exact match

#include <Debug.au3>
#include <Misc.au3>
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>

Global Const $ES_AWAYMODE_REQUIRED=0x00000040
Global Const $ES_CONTINUOUS=0x80000000
Global Const $ES_DISPLAY_REQUIRED=0x00000002
Global Const $ES_SYSTEM_REQUIRED=0x00000001
Global Const $ES_USER_PRESENT=0x00000004
Global Const $PBT_APMSUSPEND = 0x0004
;Global Const $WM_QUERYENDSESSION = 0x0011
;Global Const $WM_ENDSESSION = 0x0016
;Global Const $WM_POWERBROADCAST = 0x0218
Global $bQuit=False
Global $bSendMsg2Desktop = False
Global $bDebug = False

If _Singleton("shutdownblocker", 1) = 0 Then
    MsgBox(0, "Warning", "An occurence of this program is already running, aborting.",3)
    Exit 0
EndIf

Global $WindowTitle = "Block-Shutdown+Restart+Logoff"
Global $BlockReason = "WARNING: Software job in progress. Do not shutdown, reboot or logoff your computer! Doing so may harm the computer."

Local $bFoundWindowTitle=False
Local $bFoundBlockReason=False
For $i = 1 To $cmdline[0] step 1
	;ConsoleWrite("Getting cmdline param " & $i & " of " & $cmdline[0] & @CRLF)
	Switch StringLower($cmdline[$i])
		case "/debug"
			$bDebug = True
		Case Else
			if not $bFoundWindowTitle Then
				$WindowTitle = $cmdline[$i]
				$bFoundWindowTitle = True
			elseif not $bFoundBlockReason Then
				$BlockReason = $cmdline[$i]
				$bFoundBlockReason = True
			Else
				;another param, just add it to blockreason
				$BlockReason = $BlockReason & " " & $cmdline[$i]
			EndIf
	EndSwitch
Next

Global $hGUI=GUICreate($WindowTitle,1,1)
GUISetSTate(@SW_HIDE)

if $bDebug Then
	_DebugSetup("Debug_" & $WindowTitle,False,1)
EndIf
_DebugOut ("Title: " & $WindowTitle)
_DebugOut ("BlockReason: " & $BlockReason)
_DebugOut ("@OSBuild: " & @OSBuild)

;Init/Setup
if @OSBuild <= 2600 Then ;Winxp or lower
	Register_WM_CLOSE()
	Register_WM_QUERYENDSESSION()
	Register_WM_POWERBROADCAST()
	Register_SetProcessShutdownParameters()
Else ;Vista or higher
	Register_WM_CLOSE()
	Register_WM_QUERYENDSESSION()
	Register_WM_POWERBROADCAST()
	Register_SetProcessShutdownParameters()
	Register_ShutdownBlockReason($BlockReason)
	Register_ThreadExecutionState()
EndIf
;@OSVersion "WIN_2008R2", "WIN_7", "WIN_8", "WIN_2008", "WIN_VISTA", "WIN_2003", "WIN_XP", "WIN_XPe", "WIN_2000".

;Wait loop... somehow after two logoff attempts.. it stops blocking shutdown...
_DebugOut("Waiting for Control+x to quit")
While 1
	if $bQuit = True then ExitLoop
	if $bSendMsg2Desktop Then
		MsgBox(48+262144,$WindowTitle & " - message",$BlockReason,1000,$hGUI) ;Exclamation-point icon + MsgBox has top-most attribute set
		$bSendMsg2Desktop = False
	EndIf
	Sleep(250)
WEnd
_DebugOut("Stopping Blocking shutdown, cleanup and exit.")

;Cleanup
if @OSBuild <= 2600 Then ;Winxp or lower
	;Nothing to do
Else ;Vista or higher
	DeRegister_ThreadExecutionState()
	DeRegister_ShutdownBlockReason()
EndIf

if $bDebug Then
	_DebugOut("Autoclosing this window after 5sec: " & "Debug_" & $WindowTitle)
	sleep(5000)
	WinClose("Debug_" & $WindowTitle)
EndIf

exit 0


Func Register_WM_QUERYENDSESSION()
	_DebugOut("Registrering for GUIMsg WM_QUERYENDSESSION.")
	;For Xp, register for WM_QUERYENDSESSION, then abort the shutdown/logoff
	If Not GUIRegisterMsg($WM_QUERYENDSESSION, "HANDLE_WM_QUERYENDSESSION") then ; enough for windows xp, but in Vista/7, we will add "Shutdownblockreason"...
		_DebugOut("Error registrering WM_QUERYENDSESSION")
		Sleep(3000)
	EndIf
EndFunc

Func Register_WM_POWERBROADCAST()
	_DebugOut("Registrering for GUIMsg WM_POWERBROADCAST")
	; ***************** In Vista/7 there is no longer a way to prevent Sleep/hibernate instigated by user action, cause of the risk of backpack-attack.... ********* ;
	If Not GUIRegisterMsg($WM_POWERBROADCAST, "HANDLE_WM_POWERBROADCAST") THEN ; But we still have about 2secs to do some cleanup...
		_DebugOut("Error registrering WM_POWERBROADCAST")
		Sleep(3000)
	EndIf
EndFunc

Func Register_WM_CLOSE()
	_DebugOut("Registrering for GUIMsg WM_CLOSE")
	If Not GUIRegisterMsg($WM_CLOSE, "HANDLE_WM_CLOSE") THEN ; But we still have about 2secs to do some cleanup...
		_DebugOut("Error registrering WM_CLOSE")
		Sleep(3000)
	EndIf
EndFunc

Func Register_SetProcessShutdownParameters()
	_DebugOut("Setting ProcessShutdownParameters")
	; We wanna be first in the queue when notifications come about shutdown/sleep...
	If Not _SetProcessShutdownParameters(0xFFF) Then ; MSDN says maximum is 0x4FF, but it worked for me (Prog@ndy)
		_DebugOut("Error setting SetProgressShutdownParameters to 0xFFF (try1/4)")
		Sleep(3000)
		If Not _SetProcessShutdownParameters(0x4FF) Then ; MSDN says this is reserved for System, but worked for me (Prog@ndy)
			_DebugOut("Error setting SetProgressShutdownParameters to 0x4FF (try2/4)")
			Sleep(3000)
			If Not _SetProcessShutdownParameters(0x3FF) Then ; highest not reserved number, if everything else does not work
				_DebugOut("Error setting SetProgressShutdownParameters to 0x3FF (try 3/4)")
				Sleep(3000)
				if Not _SetProcessShutdownParameters(0x300) Then ;
					_DebugOut("Error setting SetProgressShutdownParameters to 0x3FF (try 4/4), total falure, cannot control if apps are closed under windows vista/7.")
					Sleep(3000)
				EndIf
			EndIf
		EndIf
	EndIf
EndFunc

Func Register_ShutdownBlockReason($messagetext = "WARNING: Software job in progress. Do not shutdown, reboot or logoff your computer! Doing so may harm the computer.")
	_DebugOut("Setting ShutdownBlockReason")
	; without this, computer will sometimes shutdown but sometimes be saved by the app_unresponsive screen after some or no apps close...
	; The descriptive text should be short and to the point or users might ignore....
	if not _ShutdownBlockReasonCreate($hGUI,$messagetext) Then
		_DebugOut("Error setting _ShutdownBlockReasonCreate")
		Sleep(3000)
	EndIf
EndFunc

Func Register_ThreadExecutionState()
	_DebugOut("Setting TreadExecutionState")
	;To prevent sleep, telling the OS that we're running an app that cannot be interrupted
	;The ES_AWAYMODE_REQUIRED value should be used only when absolutely necessary by media applications that require the system
	;to perform background tasks such as recording television content or streaming media to other devices while the system appears to be sleeping
	If Not _ThreadExecutionState_Set() Then
		_DebugOut("Error setting _ThreadExecutionState_Set")
		Sleep(3000)
	EndIf
EndFunc

Func DeRegister_ThreadExecutionState()
	_DebugOut("Disabling ThreadExecutionState")
	if not _ThreadExecutionState_Disable() Then
		_DebugOut("Error setting _ThreadExecutionState_Disable")
		Sleep(3000)
	EndIf
EndFunc

Func DeRegister_ShutdownBlockReason()
	_DebugOut("Disabling ShutdownBlockReason")
	if not _ShutdownBlockReasonDestroy($hGUI) Then
		_DebugOut("Error setting _ThreadExecutionState_Disable")
		Sleep(3000)
	EndIf
EndFunc


Func HANDLE_WM_QUERYENDSESSION($hWndGUI, $MsgID, $WParam, $LParam)
    ; DO NOT ADD A MSGBOX HERE
    ; Windows shows a not responding box after ~5 secs and allows to kill your app.
	;
	; http://msdn.microsoft.com/en-us/library/aa376890(VS.85).aspx#CommunityContent'
	; $LParam:
	;	ENDSESSION_CLOSEAPP
	;	0x00000001 The application is using a file that must be replaced, the system is being serviced, or system resources are exhausted. For more information, see Guidelines for Applications.
	;
	;	ENDSESSION_CRITICAL
	;	0x40000000 The application is forced to shut down.
	;
	;	ENDSESSION_LOGOFF
	;	0x80000000 The user is logging off. For more information, see Logging Off.

	_DebugOut("WM_QUERYENDSESSION, cancel session change: " & $LParam)
	if @OSBuild <= 2600 Then ;Winxp or lower
		$bSendMsg2Desktop = True
	EndIf
    Return False ; DO NOT SHUTDOWN
EndFunc

Func HANDLE_WM_CLOSE($hwnd, $msg, $wparam, $lparam)
	;Sent as a signal that a window or an application should terminate.
	;http://msdn.microsoft.com/en-us/library/windows/desktop/ms632617(v=vs.85).aspx
	_DebugOut("WM_CLOSE recieved!")
	WinClose($WindowTitle & " - message") ;on Xp, a messagebox is displayed on logoffs, it it is displayed it must be closed
	$bQuit = True
	Return $GUI_RUNDEFMSG ;Proceed the default AutoIt3 internal message commands
EndFunc

Func HANDLE_WM_POWERBROADCAST($hwnd, $msg, $wparam, $lparam)
	_DebugOut("WM_POWERBROADCAST recieved!")
	if $wparam=$PBT_APMSUSPEND then
		; We have about 2 secs...
		; Do some cleanup!
		; ...or whatever
		_DebugOut("WM_POWERBROADCAST, Shutdown with powerbutton/sleep/hibernate, do cleanup within 2 sec's, cause then you'll die!")
	EndIf
	Return 1 ;Try to cancel the powerbroadcast.
EndFunc

Func _SetProcessShutdownParameters($dwLevel, $dwFlags=0)
    ; http://msdn.microsoft.com/en-us/library/ms686227%28VS.85%29.aspx
    ; Prog@ndy
    Local $aResult = DllCall("Kernel32.dll", "int", "SetProcessShutdownParameters", "dword", $dwLevel, "dword", $dwFlags)
    If @error Then Return SetError(1,0,0)
    Return $aResult[0]
EndFunc

Func _ShutdownBlockReasonCreate($Hwnd, $wStr)
	Local $aResult = DllCall("User32.dll", "int", "ShutdownBlockReasonCreate", "hwnd", $Hwnd, "wstr", $wStr)
    If @error Then Return SetError(1,0,0)
    Return $aResult[0]
EndFunc

Func _ShutdownBlockReasonDestroy($Hwnd)
    Local $aResult = DllCall("User32.dll", "int", "ShutdownBlockReasonDestroy", "hwnd", $Hwnd)
    If @error Then Return SetError(1,0,0)
    Return $aResult[0]
EndFunc

Func _ThreadExecutionState_Set()
	;The ES_AWAYMODE_REQUIRED value should be used only when absolutely necessary by media applications that require the system
	;to perform background tasks such as recording television content or streaming media to other devices while the system appears to be sleeping
	Local $aResult = DllCall("kernel32.dll", "int", "SetThreadExecutionState", "int", BitOR($ES_CONTINUOUS, $ES_SYSTEM_REQUIRED, $ES_AWAYMODE_REQUIRED)) ;$ES_AWAYMODE_REQUIRED
	if @error Then Return SetError(1,0,0)
	Return $aResult[0]
EndFunc

Func _ThreadExecutionState_Disable()
	;// Clear EXECUTION_STATE flags to disable away mode and allow the system to idle to sleep normally.
	Local $aResult = DllCall("kernel32.dll", "int", "SetThreadExecutionState", "int", $ES_CONTINUOUS)
	if @error Then Return SetError(1,0,0)
	Return $aResult[0]
EndFunc




