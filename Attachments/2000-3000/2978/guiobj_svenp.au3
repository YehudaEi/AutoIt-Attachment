
#include <GUIConstants.au3>

GUICreate ( "Embedded ActiveX Test", 800, 600 )

$GUI_ActiveX=GUICtrlCreateObj ( "Word.Document", 30, 30 , 750 , 550 )

GUISetState ()      ;Show GUI

While 1
    $msg = GUIGetMsg()
    If $msg = $GUI_EVENT_CLOSE Then ExitLoop
Wend

GUIDelete ()