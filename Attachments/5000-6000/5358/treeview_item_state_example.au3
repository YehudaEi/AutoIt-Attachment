#include <GUIConstants.au3>
#include <GuiTreeView.au3>
#include "_TreeViewGetItemState.au3"

const $TVGN_ROOT = 0

$gui = GUICreate("Treeview item state",212,212)
$treeview = GUICtrlCreateTreeView (6,6,200,160,BitOr($TVS_HASBUTTONS,$TVS_HASLINES,$TVS_LINESATROOT,$TVS_CHECKBOXES),$WS_EX_CLIENTEDGE)
$h_tree = ControlGetHandle("", "", $treeview)

$root = GUICtrlCreateTreeViewitem ("Root",$treeview)
$item1 = GUICtrlCreateTreeViewitem ("Item 1",$root)
$item2 = GUICtrlCreateTreeViewitem ("Item 2",$root)
$item3 = GUICtrlCreateTreeViewitem ("Item 3",$root)
$item4 = GUICtrlCreateTreeViewitem ("Item 4",$root)
$item5 = GUICtrlCreateTreeViewitem ("Item 5",$root)

GUICtrlSetState($item2,$GUI_CHECKED) 
GUICtrlSetState($item4,$GUI_CHECKED) 
_GUICtrlTreeViewExpand($gui, $treeview, 1, 0)

$show = GUICtrlCreateButton("Show", 70, 180, 70, 20)

GUISetState ()
While 1
    $msg = GUIGetMsg()
    Select
		Case $msg = $show
			Show()
        Case $msg = $GUI_EVENT_CLOSE
            ExitLoop
    EndSelect
WEnd
GUIDelete()
Exit

Func Show()
	$result = ""
	
	$h_item = GUICtrlSendMsg($treeview, $TVM_GETNEXTITEM, $TVGN_ROOT, 0)
	$result &= GetItemInfo($h_item)
	$h_item = GUICtrlSendMsg($treeview, $TVM_GETNEXTITEM, $TVGN_CHILD, $h_item)
	
	While 1
		$result &= GetItemInfo($h_item)
		$h_item = GUICtrlSendMsg($treeview, $TVM_GETNEXTITEM, $TVGN_NEXT, $h_item)
		If $h_item <= 0 Then ExitLoop
	WEnd
	
	MsgBox(64, "Result", $result)
EndFunc

Func GetItemInfo($h_item)
	$text = _TreeViewGetItemText($h_tree, $h_item)
	$state = _TreeViewGetItemState($h_tree, $h_item)
	
	If BitAND($state, $TVIS_STATEIMAGEMASK) = 0x2000 Then ; unchecked=0x1000 checked=0x2000
		$state = "checked"
	Else
		$state = "unchecked"
	EndIf
	
	Return $text & @TAB & $state & @CRLF
EndFunc
