#include <GuiConstants.au3>
#include <GuiListView.au3>
#include <array.au3>

Opt ('MustDeclareVars', 1)
Dim $listview, $Btn_MoveUp, $Btn_MoveDown, $Btn_Exit, $msg, $Status, $GUI, $i, $j
Global $avRowCache[1][2], $sHighlightNew =''; Cache vor Rowtxt
$GUI = GUICreate("Move Up/Down and hightlight it", 392, 322)

$listview = GUICtrlCreateListView("col1|col2|col3", 40, 30, 310, 149, BitOR($LVS_SHOWSELALWAYS, $LVS_NOSORTHEADER))
GUICtrlCreateListViewItem("line1|data1|more1", $listview)
GUICtrlCreateListViewItem("line2|data2|more2", $listview)
GUICtrlCreateListViewItem("line3|data3|more3", $listview)
GUICtrlCreateListViewItem("line4|data4|more4", $listview)
GUICtrlCreateListViewItem("line5|data5|more5", $listview)
$Btn_MoveUp = GUICtrlCreateButton("Move Up", 75, 200, 90, 40)
$Btn_MoveDown = GUICtrlCreateButton("Move Down", 200, 200, 90, 40)
$Btn_Exit = GUICtrlCreateButton("Exit", 300, 260, 70, 30)
$Status = GUICtrlCreateLabel("", 0, 302, 392, 20, BitOR($SS_SUNKEN, $SS_CENTER))

GUISetState()
While 1
	$msg = GUIGetMsg()
	Select
		Case $msg = $GUI_EVENT_CLOSE Or $msg = $Btn_Exit
			ExitLoop
		Case $msg = $Btn_MoveUp
			_MoveUpDown($listview, 0)
		Case $msg = $Btn_MoveDown
			_MoveUpDown($listview, 1)
	EndSelect
WEnd
Exit

Func _MoveUpDown($sLView, $iUpDown)
	Dim $avTxt1, $avTxt2,  $i, $j, $sHighlightNew = '', $iErr = 0, $avSelectRows, $iNextIndex = 0, $avHighlightNew
	;$iUpDown = 0 means up, $iUpDown = 1 means down
	If $iUpDown < 0 then $iErr = $iErr + 1
	If $iUpDown < 1 then $iErr = $iErr + 2
	
	$avSelectRows = _GUICtrlListViewGetSelectedIndices($listview, 1)
	For $i = 1 to $avSelectRows[0]
		If $iUpDown == 0 AND $avSelectRows[$i] == 0 then $iErr = $iErr +4 ; has already the lowest pos.
		If $iUpDown == 1 AND $avSelectRows[$i] ==_GUICtrlListViewGetItemCount ($listview) then $iErr = $iErr +8	; has already the hightest pos.

		If $iUpDown == 0 Then $iNextIndex = Number($avSelectRows[$i])-1
		If $iUpDown == 1 Then $iNextIndex = Number($avSelectRows[$i])+1		
		$avTxt1 = StringSplit(_GUICtrlListViewGetItemText($listview, $avSelectRows[$i]), '|')
		$avTxt2 = StringSplit(_GUICtrlListViewGetItemText($listview, $iNextIndex), '|')
		For $j = 0 to $avTxt1[0]-1 ;cause cero-based, swap contents of both rows
			 _GUICtrlListViewSetItemText ($listview, $avSelectRows[$i], $j, $avTxt2[$j +1])
			 _GUICtrlListViewSetItemText ($listview, $iNextIndex, $j, $avTxt1[$j +1])
			 $sHighlightNew = $sHighlightNew & '|' & $iNextIndex
		Next
	Next
	$avHighlightNew = StringSplit(StringTrimLeft ($sHighlightNew,1),'|')
	For $i = 1 to $avHighlightNew[0]
		_GUICtrlListViewSetItemSelState ($listview, $avHighlightNew[$i])
	Next 
	SetError ($iErr, 0, $iErr)
EndFunc