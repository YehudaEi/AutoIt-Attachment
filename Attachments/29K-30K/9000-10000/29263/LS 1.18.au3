#include <GUIConstants.au3>
#include <IE.au3>

$GUI = GUICreate("Ladder Slasher v.1.18",1350, 700)
$object = ObjCreate("Shell.Explorer.2")
$object2 = ObjCreate("Shell.Explorer.2")
$object_ctrl = GUICtrlCreateObj($object, 16, 10, 1382, 754)
_IENavigate($object, "http://ladderslasher.d2jsp.org/LS_118S.htm")
_IENavigate($object2, "http://google.dk")

GUISetState()

While 1
	$msg = GUIGetMsg()
	Select		
	Case $msg = $GUI_EVENT_CLOSE
		Exit
	EndSelect
WEnd