#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=warning.ico
#AutoIt3Wrapper_UseX64=n
#AutoIt3Wrapper_Res_Comment=Close ShutdownBlocker
#AutoIt3Wrapper_Res_Description=Close ShutdownBlocker
#AutoIt3Wrapper_Res_Fileversion=1.0.0.0
#AutoIt3Wrapper_Res_requestedExecutionLevel=highestAvailable
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

;http://www.autoitscript.com/forum/topic/133896-prevent-shutdownsleep-in-vista7/
;by /Manko, modified by T_Bear

;This app made as a helper app for an installation app to block shutdown while an installation is running.
;It consists of two scripts, one to block, and another to thell the blocking app to stop.
;This is the app to stop the blocking app, it sends a WM_CLOSE to the blocking app.
;inputs params is: "Title to be displayed" [/debug]

AutoItSetOption("TrayAutoPause","0")
AutoItSetOption("MustDeclareVars", True)
AutoItSetOption("TrayIconHide", True)
AutoItSetOption("ExpandEnvStrings", True)
AutoItSetOption("TrayOnEventMode", True)
AutoItSetOption("WinTitleMatchMode", 3) ;Exact match

#include <Debug.au3>
#include <Misc.au3>
#include <WindowsConstants.au3>
#include <SendMessage.au3>
Global $bDebug = False
Global $WindowTitle = "Block-Shutdown+Restart+Logoff"

If _Singleton("shutdownblocker_close", 1) = 0 Then
    Exit 0
EndIf


Local $bFoundWindowTitle=False
For $i = 1 To $cmdline[0] step 1
	;ConsoleWrite("Getting cmdline param " & $i & " of " & $cmdline[0] & @CRLF)
	Switch StringLower($cmdline[$i])
		case "/debug"
			$bDebug = True
		Case Else
			if not $bFoundWindowTitle Then
				$WindowTitle = $cmdline[$i]
				$bFoundWindowTitle = True
			EndIf
	EndSwitch
Next

if $bDebug Then
	_DebugSetup("ShutdownBlocker_Close",False,1)
EndIf

_DebugOut("Closing window: " & $WindowTitle)
if WinClose($WindowTitle) Then
	_DebugOut("-Success, window found and sent WM_CLOSE")
Else
	_DebugOut("-Fail, window not found, trying to find pid of shutdownblocker")
	Local $shutdownblockerpid = ProcessExists("shutdownblocker.exe")
	if not $shutdownblockerpid = 0 Then
		_DebugOut("Pid of shutdownblocker is: " & $shutdownblockerpid)
		Local $shudownblockerwindowhandle = _GetHwndFromPID($shutdownblockerpid)
		if not @error Then
			if not WinClose($shudownblockerwindowhandle) Then
				_DebugOut("-Fail, window not found by window handle")
			Else
				_DebugOut("-Success, window sendt WM_CLOSE by windowhandle")
			EndIf
		Else
			_DebugOut("-Fail, could not find windowhandle of pid " & $shutdownblockerpid)
		EndIf
	Else
		_DebugOut("Shutdownblocker is not running.")
	EndIf

EndIf

if $bDebug Then
	_DebugOut("Autoclosing this window after 5sec.")
	sleep(5000)
	WinClose("ShutdownBlocker_Close")
EndIf

exit 0




;Function for getting HWND from PID
Func _GetHwndFromPID($PID)
	Local $hWnd = 0
	Local $winlist = WinList()
	Do
		For $i = 1 To $winlist[0][0]
			If $winlist[$i][0] <> "" Then
				Local $iPID2 = WinGetProcess($winlist[$i][1])
				If $iPID2 = $PID Then
					Local $hWnd = $winlist[$i][1]
					ExitLoop
				EndIf
			EndIf
		Next
	Until $hWnd <> 0
	Return $hWnd
EndFunc;==>_GetHwndFromPID