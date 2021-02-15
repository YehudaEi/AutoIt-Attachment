#include <GUIConstantsEx.au3>

$hGUI = GUICreate("ISO 8859-1 Code Table Characters", 250, 100)
$label = GUICtrlCreateLabel("♠ ♣ ♥ ♦", 0, 0, 250, 50)
GUICtrlSetFont(-1, 40)
$button = GUICtrlCreateButton("Δεμω", 100, 60, 50)
GUISetState(@SW_SHOW)

While 1
    $nMsg = GUIGetMsg()
    Switch $nMsg
        Case $GUI_EVENT_CLOSE, $button
            Exit
    EndSwitch
WEnd