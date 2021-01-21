#include <WinAPI.au3>
;~ #include <WindowsConstants.au3>

Global Const $SW_HIDE                           = 0
Global Const $SW_SHOW                           = 5

_ShowTaskBar(False)
Sleep ( 2000 )
_ShowTaskBar()

_ShowStartButton(False)
Sleep ( 2000 )
_ShowStartButton()

_ShowTaskBarClock(False)
Sleep ( 2000 )
_ShowTaskBarClock()

_ShowTaskBarIcons(False)
Sleep ( 2000 )
_ShowTaskBarIcons()

For $x = 1 To _TaskBarIndexCount()
    _ShowProgramsShowingInTaskBar(False, $x)
    Sleep(2000)
    _ShowProgramsShowingInTaskBar(True, $x)
Next

Func _ShowTaskBar($fShow = True)
    Local $hTaskBar
    $hTaskBar = _WinAPI_FindWindow("Shell_TrayWnd", "")
    If $fShow Then
        _WinAPI_ShowWindow($hTaskBar, $SW_SHOW)
    Else
        _WinAPI_ShowWindow($hTaskBar, $SW_HIDE)
    EndIf
EndFunc   ;==>_ShowTaskBar

Func _ShowStartButton($fShow = True)
    Local $hTaskBar, $hStartButton
    $hTaskBar = _WinAPI_FindWindow("Shell_TrayWnd", "")
    $hStartButton = ControlGetHandle($hTaskBar, "", "Button1")
    If $fShow Then
        _WinAPI_ShowWindow($hStartButton, $SW_SHOW)
    Else
        _WinAPI_ShowWindow($hStartButton, $SW_HIDE)
    EndIf
EndFunc   ;==>_ShowStartButton

Func _ShowTaskBarClock($fShow = True)
    Local $hTaskBar, $hParent, $hClock
    $hTaskBar = _WinAPI_FindWindow("Shell_TrayWnd", "")
    $hParent = ControlGetHandle($hTaskBar, "", "TrayNotifyWnd1")
    $hClock = ControlGetHandle($hParent, "", "TrayClockWClass1")
    If $fShow Then
        _WinAPI_ShowWindow($hClock, $SW_SHOW)
    Else
        _WinAPI_ShowWindow($hClock, $SW_HIDE)
    EndIf
EndFunc   ;==>_ShowTaskBarClock

Func _ShowTaskBarIcons($fShow = True)
    Local $hTaskBar, $hParent, $hChild
    $hTaskBar = _WinAPI_FindWindow("Shell_TrayWnd", "")
    $hParent = ControlGetHandle($hTaskBar, "", "TrayNotifyWnd1")
    $hChild = ControlGetHandle($hParent, "", "ToolbarWindow321")
    If $fShow Then
        _WinAPI_ShowWindow($hChild, $SW_SHOW)
    Else
        _WinAPI_ShowWindow($hChild, $SW_HIDE)
    EndIf
EndFunc   ;==>_ShowTaskBarIcons

Func _ShowProgramsShowingInTaskBar($fShow = True, $iIndex = 1)
    Local $hTaskBar, $hRebar, $hToolBar
    $hTaskBar = _WinAPI_FindWindow("Shell_TrayWnd", "")
    $hRebar = ControlGetHandle($hTaskBar, "", "ReBarWindow321")
    $hToolBar = ControlGetHandle($hRebar, "", "ToolbarWindow32" & $iIndex)
    If $hToolBar <> 0x00000000 Then
        If $fShow Then
            _WinAPI_ShowWindow($hToolBar, $SW_SHOW)
        Else
            _WinAPI_ShowWindow($hToolBar, $SW_HIDE)
        EndIf
    EndIf
EndFunc   ;==>_ShowProgramsShowingInTaskBar

Func _TaskBarIndexCount()
    Local $hTaskBar, $hRebar, $hToolBar, $iCount = 0
    $hTaskBar = _WinAPI_FindWindow("Shell_TrayWnd", "")
    $hRebar = ControlGetHandle($hTaskBar, "", "ReBarWindow321")
    While 1
        $hToolBar = ControlGetHandle($hRebar, "", "ToolbarWindow32" & $iCount + 1)
        If $hToolBar = 0x00000000 Then ExitLoop
        $iCount += 1
    WEnd
    Return $iCount
EndFunc   ;==>_ShowProgramsShowingInTaskBar