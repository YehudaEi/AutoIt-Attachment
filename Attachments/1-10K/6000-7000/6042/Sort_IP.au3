#include <GuiConstants.au3>
#include <GuiListView.au3>

;Const $LVS_SORTDESCENDING = 0x0020
opt('MustDeclareVars', 1)
Dim $listview, $Btn_Exit, $msg, $Status, $Btn_Insert, $ret, $Input_Index
GUICreate("ListView Sort", 392, 322)

$listview = GUICtrlCreateListView("col1|col2|col3", 40, 30, 310, 149, -1, BitOR($LVS_EX_REGIONAL, $LVS_EX_FULLROWSELECT, $LVS_EX_GRIDLINES))
GUICtrlCreateListViewItem("192.100.100.2|5data|more_a", $listview)
GUICtrlCreateListViewItem("192.100.100.50|4data|more_c", $listview)
GUICtrlCreateListViewItem("192.100.100.5|3data|more_e", $listview)
GUICtrlCreateListViewItem("192.100.100.100|2data|more_d", $listview)
GUICtrlCreateListViewItem("192.100.100.245|1data|more_b", $listview)
_GUICtrlListViewSetColumnWidth ($listview, 0, 75)
_GUICtrlListViewSetColumnWidth ($listview, 1, 75)
_GUICtrlListViewSetColumnWidth ($listview, 2, 75)
$Btn_Exit = GUICtrlCreateButton("Exit", 300, 260, 70, 30)

GUISetState()

Dim $B_DESCENDING[_GUICtrlListViewGetSubItemsCount ($listview) ]

While 1
   $msg = GUIGetMsg()
   Select
      Case $msg = $GUI_EVENT_CLOSE Or $msg = $Btn_Exit
         ExitLoop
		Case $msg = $listview
			; sort the list by the column header clicked on
			_GUICtrlListViewSort($listview, $B_DESCENDING, GUICtrlGetState($listview))
   EndSelect
WEnd
Exit
