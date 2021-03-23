#include <winapiex.au3>
Global $WM_SETCURSOR
$hGUI = Guicreate("My Cursos by monoscout999",-1,-1)
$Label = GUICtrlCreateLabel('lable', 100, 100, 200, 200)
$hCursor = _winapi_LoadCursorFromFile(@Scriptdir&"\Untitled.cur")
;~ _WinAPI_SetCursor($hCursor)
GUIRegisterMsg(0x0020, 'WM_SETCURSOR')
Guisetstate()
Do
until GuigetMsg() = -3
_WinAPI_DestroyCursor($hCursor)
Func WM_SETCURSOR($hWnd, $iMsg, $wParam, $lParam)
    Switch $hWnd
        Case $hGUI
            _WinAPI_SetCursor($hCursor)
                Return 0
    EndSwitch
    Return "GUI_RUNDEFMSG"
EndFunc   ;==>WM_SETCURSOR