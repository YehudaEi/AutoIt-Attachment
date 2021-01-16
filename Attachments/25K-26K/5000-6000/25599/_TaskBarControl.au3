; script downloaded from http://www.autoitscript.com/forum/index.php?showtopic=82838&st=15
; posted by Wraithdu on Jan 27 2009, 10:09 PM 
; minor mods - nothing but commenting main program code lines done by rajesh v r 
; Posted on Apr 12, 2009 

#include <GuiConstantsEx.au3>
#include <Constants.au3>
#include <GuiToolbar.au3>

Global $hToolbar = _FindToolbarWindow()

#cs for using this script as an example purpose only  

;~ Opt("TrayAutoPause", 0)
;~ Opt("TrayMenuMode", 1)

;~ Global $gui = GUICreate("Test GUI", 200, 100)
;~ Global $cbox = GUICtrlCreateCheckbox("Hide my taskbar button", 20, 20)

;~ GUISetState()

While 1
    $msg = GUIGetMsg()
    Switch $msg
        Case $cbox
            Switch BitAND(GUICtrlRead($cbox), $GUI_CHECKED)
                Case $GUI_CHECKED
                    _HideToolbarButton($gui, $hToolbar)
                Case Else
                    _HideToolbarButton($gui, $hToolbar, False)
            EndSwitch
        Case $GUI_EVENT_MINIMIZE
            ; hide taskbar button
            _HideToolbarButton($gui, $hToolbar)
        Case $GUI_EVENT_CLOSE
            ExitLoop
    EndSwitch
    $msg = TrayGetMsg()
    Switch $msg
        Case $TRAY_EVENT_PRIMARYDOWN
            GUISetState(@SW_RESTORE)
            If BitAND(GUICtrlRead($cbox), $GUI_CHECKED) <> $GUI_CHECKED Then _HideToolbarButton($gui, $hToolbar, False)
    EndSwitch
WEnd
#ce 

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
            ; button param is ptr to owner's window handle, stored in target process's memory space smile.gif
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
    Local $ID = _FindToolbarButton($hwnd, $hTB)
    If $ID <> -1 Then
        _GUICtrlToolbar_HideButton($hTB, $ID, $hide)
    EndIf
EndFunc