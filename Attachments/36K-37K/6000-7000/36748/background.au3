#include <StaticConstants.au3>
#include <GUIConstantsEx.au3>

$gui = GUICreate("Title of Windows", 400, 300)

$pic = GUICtrlCreatePic("img\bg3.bmp", 0, 0, 400, 300, $SS_BITMAP)

$chk = GUICtrlCreateCheckbox("This is checkbox - Lorem ipsum dolor sit amet.", 20, 20)
$lbl = GUICtrlCreateLabel("This is label - Lorem ipsum dolor sit amet", 20, 100)
$rdo = GUICtrlCreateRadio("This is radio - Lorem ipsum dolor sit amet", 20, 180)

GUICtrlSetBkColor($chk, $GUI_BKCOLOR_TRANSPARENT)
GUICtrlSetBkColor($lbl, $GUI_BKCOLOR_TRANSPARENT)
GUICtrlSetBkColor($rdo, $GUI_BKCOLOR_TRANSPARENT)

GUISetState()

While 1
	If GUIGetMsg() = $GUI_EVENT_CLOSE Then Exit
WEnd