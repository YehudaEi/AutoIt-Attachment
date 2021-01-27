#include <GDIPlus.au3>
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>

GUICreate("Tst", 600, 520,-1,-1)
$pic = GUICtrlCreatePic("simple.jpg", 0, 0, 600, 520)
GUICtrlSetState(-1, $GUI_DISABLE)

$tstlabel=GuiCtrlCreateLabel("restore", 280, 200, 75, 20)
GUICtrlSetBkColor($tstlabel, $GUI_BKCOLOR_TRANSPARENT)
GUICtrlSetCursor(-1, 0)
$_tst = GUICtrlCreateButton("Check", 280, 240, 76)

GUISetState()

While 1
    $msg = GUIGetMsg()
    If $msg = $GUI_EVENT_CLOSE Then ExitLoop
WEnd