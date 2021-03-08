#include <GUIConstantsEx.au3>
#include "GUICtrlOnHover.au3"
Example()

Func Example()

    Opt("GUICoordMode", 2)
    Opt("GUIResizeMode", 1)
    Opt("GUIOnEventMode", 1)

    GUICreate("Parent1")
    GUISetOnEvent($GUI_EVENT_CLOSE, "SpecialEvents")
    GUISetOnEvent($GUI_EVENT_MINIMIZE, "SpecialEvents")
    GUISetOnEvent($GUI_EVENT_RESTORE, "SpecialEvents")

    $w = GUICtrlCreateInput("Input1", 16, 64, 121, 21)
    _GUICtrl_OnHoverRegister($w,-1,-1,"InputPressed")

    GUICtrlCreateButton("OK", 10, 30, 50)
    GUICtrlSetOnEvent(-1, "OKPressed")
    GUICtrlCreateButton("Cancel", 0, -1)
    GUICtrlSetOnEvent(-1, "CancelPressed")
    GUISetState(@SW_SHOW)

    While 1
        Sleep(10)
    WEnd
EndFunc   ;==>Example

Func OKPressed()
    MsgBox(0, "OK Pressed", "ID=" & @GUI_CtrlId & " WinHandle=" & @GUI_WinHandle & " CtrlHandle=" & @GUI_CtrlHandle)
EndFunc   ;==>OKPressed

Func CancelPressed()
    MsgBox(0, "Cancel Pressed", "ID=" & @GUI_CtrlId & " WinHandle=" & @GUI_WinHandle & " CtrlHandle=" & @GUI_CtrlHandle)
EndFunc   ;==>CancelPressed

Func SpecialEvents()
    Select
        Case @GUI_CtrlId = $GUI_EVENT_CLOSE
            MsgBox(0, "Close Pressed", "ID=" & @GUI_CtrlId & " WinHandle=" & @GUI_WinHandle)
            Exit
        Case @GUI_CtrlId = $GUI_EVENT_MINIMIZE
            MsgBox(0, "Window Minimized", "ID=" & @GUI_CtrlId & " WinHandle=" & @GUI_WinHandle)
        Case @GUI_CtrlId = $GUI_EVENT_RESTORE
            MsgBox(0, "Window Restored", "ID=" & @GUI_CtrlId & " WinHandle=" & @GUI_WinHandle)
    EndSelect
EndFunc   ;==>SpecialEvents



Func InputPressed($cttrlId)
	TrayTip("Input Pressed", "ID="&$cttrlId&"  CtrlHandel="&GUICtrlGetHandle($cttrlId),10)
	;The functions should not introduce significant delays in the main script,
	;for example by calling functions like Sleep() or MsgBox().
EndFunc