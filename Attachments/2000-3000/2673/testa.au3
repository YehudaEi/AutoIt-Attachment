#include <GUIConstants.au3>
Opt("GUIOnEventMode",1)

GUICreate("test")
$treeview = GUICtrlCreateTreeView (6,6,300,434,BitOr($TVS_HASBUTTONS,$TVS_HASLINES,$TVS_LINESATROOT,$TVS_DISABLEDRAGDROP,$TVS_SHOWSELALWAYS,$TVS_CHECKBOXES,$TVS_TRACKSELECT ),$WS_EX_CLIENTEDGE )
$item1 = GUICtrlCreateTreeViewItem("Item1",$treeview)
GUICtrlSetOnEvent(-1,"ItemSelection")
$item2 = GUICtrlCreateTreeViewItem("Item2",$treeview)
GUICtrlSetOnEvent(-1,"ItemSelection")
$item3 = GUICtrlCreateTreeViewItem("Item3",$treeview)
GUICtrlSetOnEvent(-1,"ItemSelection")
$item4 = GUICtrlCreateTreeViewItem("Item4",$treeview)
GUICtrlSetOnEvent(-1,"ItemSelection")
$subitem1 = GUICtrlCreateTreeViewItem("SubItem1",$item1)
GUICtrlSetOnEvent(-1,"ItemSelection")
$subitem2 = GUICtrlCreateTreeViewItem("SubItem2",$item1)
GUICtrlSetOnEvent(-1,"ItemSelection")
$status = GUICtrlCreateLabel("0",350,10,50,20)

GUISetOnEvent($GUI_EVENT_CLOSE,"ExitGUI")

GUISetState()

While 1
    Sleep(10)
WEnd
Exit
Func ItemSelection()
    GUICtrlSetData($status,@GUI_CtrlId)
    Msgbox(0,"Event",@GUI_CtrlId,1)
EndFunc

Func ExitGUI()
    Exit
EndFunc
