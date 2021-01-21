#include "GuiConstants.au3"
GUICreate("App with treeview",212,212)

$treeview = GUICtrlCreateTreeView (6,6,200,200,BitOr($TVS_HASBUTTONS,$TVS_HASLINES,$TVS_LINESATROOT),$WS_EX_CLIENTEDGE)
$root = GUICtrlCreateTreeViewitem ("Root",$treeview)

$item1 = GUICtrlCreateTreeViewitem ("Item 1",$root)
$item11 = GUICtrlCreateTreeViewitem ("Item 11",$item1)
$item12 = GUICtrlCreateTreeViewitem ("Item 12",$item1)

$item2 = GUICtrlCreateTreeViewitem ("Item 2",$root)
$item21 = GUICtrlCreateTreeViewitem ("Item 21",$item2)
$item22 = GUICtrlCreateTreeViewitem ("Item 22",$item2)

$item3 = GUICtrlCreateTreeViewitem ("Item 3",$root)
$item4 = GUICtrlCreateTreeViewitem ("Item 4",$root)
$item5 = GUICtrlCreateTreeViewitem ("Item 5",$root)

GUISetState ()

ControlSend("App with treeview","","SysTreeView321","{Right}") ; open root

While 1
    $msg = GUIGetMsg()
    If $msg = $GUI_EVENT_CLOSE Then ExitLoop
WEnd

GUIDelete()
Exit
