#include-once
#include <GuiConstantsEx.au3>
#include <Constants.au3>
#include <GuiToolbar.au3>

Global $g_hToolbar, $g_hGUI, $g_bTray

; #FUNCTION# ;===============================================================================
;
; Name...........: _MinimizeToTray
; Description ...: Enables a GUI to minimize to a tray icon
; Syntax.........: _MinimizeToTray($hGUI, $bTray)
; Parameters ....: $hGUI - handle to the main GUI window, as returned by GUICreate()
;				   $bTray - show / hide tray icon also
; Return values .: Success - Returns True
;                  Failure - Returns False and Sets @Error to 1
; Author ........: Erik Pilsits
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
;
; ;==========================================================================================
Func _MinimizeToTray($hGUI, $bTray = False)
	Local $return = False, $err = 1
	$g_hToolbar = _FindToolbarWindow()
	If $g_hToolbar Then
		; these options MUST be set
		Opt("GUIOnEventMode", 1) ; OnEvent mode
		Opt("TrayOnEventMode", 1) ; ditto
		Opt("TrayMenuMode", 1) ; no default tray menu (no pause or exit), user can still create custom menu
		Opt("GUIEventOptions", 1) ; minimize, maximize, and restore only send notifications, we handle the actions
		$g_hGUI = $hGUI ; store global handle
		$g_bTray = $bTray ; change tray icon state also
		; set min/max/restore events
		GUISetOnEvent($GUI_EVENT_MINIMIZE, "_OnEventMinimize")
		GUISetOnEvent($GUI_EVENT_MAXIMIZE, "_OnEventMaximize")
		GUISetOnEvent($GUI_EVENT_RESTORE, "_OnEventRestore")
		$return = True
		$err = 0
	EndIf
	Return SetError($err, 0, $return)
EndFunc

; ===================================================
; INTERNAL FUNCTIONS
; ===================================================
Func _OnEventMinimize()
	; set tray restore event
	TraySetOnEvent($TRAY_EVENT_PRIMARYDOWN, "_OnEventRestore")
	GUISetState(@SW_MINIMIZE, $g_hGUI)
	_HideToolbarButton($g_hGUI, $g_hToolbar)
	If $g_bTray Then TraySetState(1) ; show tray icon
EndFunc

Func _OnEventMaximize()
	; unset tray event, hide icon, and show toolbar button in case we're max'ing from tray menu or hotkey
	If $g_bTray Then TraySetState(2)
	TraySetOnEvent($TRAY_EVENT_PRIMARYDOWN, "")
	GUISetState(@SW_MAXIMIZE, $g_hGUI)
	_HideToolbarButton($g_hGUI, $g_hToolbar, False)
EndFunc

Func _OnEventRestore()
	If $g_bTray Then TraySetState(2) ; hide tray icon
	; unset tray event
	TraySetOnEvent($TRAY_EVENT_PRIMARYDOWN, "")
	GUISetState(@SW_RESTORE, $g_hGUI)
	_HideToolbarButton($g_hGUI, $g_hToolbar, False)
EndFunc

Func _FindToolbarWindow()
	; find explorer toolbar window
	; XP+
	Local $hDesktop = _WinAPI_GetDesktopWindow()
	Local $hTray = _FindWindowEx($hDesktop, 0, "Shell_TrayWnd", "")
	Local $hReBar = _FindWindowEx($hTray, 0, "ReBarWindow32", "")
	Local $hTask = _FindWindowEx($hReBar, 0, "MSTaskSwWClass", "")
	Return _FindWindowEx($hTask, 0, "ToolbarWindow32", "")
EndFunc

Func _FindWindowEx($hParent, $hChild, $sClass, $sWindow)
	; must create structs and use ptrs to account for passing a true NULL as classname or window title
	; simply using "wstr" and "" does NOT work
	Local $s1, $s2
	If $sClass == "" Then
		$sClass = 0
	Else
		$s1 = DllStructCreate("wchar[256]")
		DllStructSetData($s1, 1, $sClass)
		$sClass = DllStructGetPtr($s1)
	EndIf
	If $sWindow == "" Then
		$sWindow = 0
	Else
		$s2 = DllStructCreate("wchar[256]")
		DllStructSetData($s2, 1, $sWindow)
		$sWindow = DllStructGetPtr($s2)
	EndIf
	Local $ret = DllCall("user32.dll", "hwnd", "FindWindowExW", "hwnd", $hParent, "hwnd", $hChild, "ptr", $sClass, "ptr", $sWindow)
	$s1 = 0
	$s2 = 0
	Return $ret[0]
EndFunc

Func _FindToolbarButton($hwnd, $hTB)
	; finds and returns the toolbar button ID for given window handle
	Local $return = -1
	Local $s = DllStructCreate("ptr")
	; open process owning toolbar control
	Local $PID
	_WinAPI_GetWindowThreadProcessId($hTB, $PID)
	Local $hProcess = _WinAPI_OpenProcess(0x410, False, $PID)
	If $hProcess Then
		Local $count = _GUICtrlToolbar_ButtonCount($hTB)
		For $i = 0 To $count - 1
			Local $ID = _GUICtrlToolbar_IndexToCommand($hTB, $i)
			; button param is ptr to owner's window handle, stored in target process's memory space :)
			Local $dwData = _GUICtrlToolbar_GetButtonParam($hTB, $ID)
			; read the window handle from the explorer process
			Local $ret = DllCall("kernel32.dll", "int", "ReadProcessMemory", "ptr", $hProcess, "ptr", $dwData, "ptr", DllStructGetPtr($s), "uint", 4, "uint*", 0)
			If $ret[5] Then
				If $hwnd == DllStructGetData($s, 1) Then
					$return = $ID
					ExitLoop
				EndIf
			EndIf
		Next
		_WinAPI_CloseHandle($hProcess)
	EndIf
	Return $return
EndFunc

Func _HideToolbarButton($hwnd, $hTB, $hide = True)
	; hides / shows a window's toolbar button
	Local $ID = _FindToolbarButton($hwnd, $hTB)
	If $ID <> -1 Then
		_GUICtrlToolbar_HideButton($hTB, $ID, $hide)
	EndIf
EndFunc