;###############################
;#      Author: Pyzonet #      #
;###############################

#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include <GuiListView.au3>
#include <Excel.au3>

#NoTrayIcon

Local $style = BitOR($LVS_EX_GRIDLINES, $LVS_EX_FULLROWSELECT)
Local $msg

GUICreate("Export Listview to Excel & Print!",500,500); CREATE GUI
$lv = GUICtrlCreateListView("",0,0,500,450)
_GUICtrlListView_SetExtendedListViewStyle(-1,$style)
_GUICtrlListView_SetSelectedColumn(-1, 0)
$export = GUICtrlCreateButton("EXPORT TO EXCEL",20,460,120,30)
$exit = GUICtrlCreateButton("EXIT",360,460,120,30)

colanditems()

GUISetState(@SW_SHOW)

While 1

	Select
		Case $msg = $export
			exporttoexcel()

		Case $msg = $exit
			Exit
	EndSelect

		$msg = GUIGetMsg()

		If $msg = $GUI_EVENT_CLOSE Then ExitLoop
	WEnd

GUIDelete()

Func colanditems(); CREATE COLUMNS, ITEMS AND SUBITEMS
For $x = 1 to 9
	_GUICtrlListView_InsertColumn($lv,$x,"Col " & $x, 100)
	_GUICtrlListView_AddItem($lv, "Row " & $x & " item " & $x)
	For $x2 = 1 to 10
	_GUICtrlListView_AddSubItem($lv, $x2 - 2, "subitem 1", 1)
	_GUICtrlListView_AddSubItem($lv, $x2 - 2, "subitem 2", 2)
	_GUICtrlListView_AddSubItem($lv, $x2 - 2, "subitem 3", 3)
	_GUICtrlListView_AddSubItem($lv, $x2 - 2, "subitem 4", 4)
	_GUICtrlListView_AddSubItem($lv, $x2 - 2, "subitem 5", 5)
	_GUICtrlListView_AddSubItem($lv, $x2 - 2, "subitem 6", 6)
	_GUICtrlListView_AddSubItem($lv, $x2 - 2, "subitem 7", 7)
	_GUICtrlListView_AddSubItem($lv, $x2 - 2, "subitem 8", 8)
	Next
Next
EndFunc

Func exporttoexcel();EXPORT TO EXCEL
$col = 9
$count = _GUICtrlListView_GetItemCount($lv)
GUICtrlSetState($export,$gui_disable)
$excel = _ExcelBookNew()
For $colexcel = 1 To $col
_ExcelWriteCell($excel,"Col " & $colexcel,1,$colexcel)
	$i = 0
	do
		_ExcelWriteCell($excel, _GUICtrlListView_GetItemText($lv,$i,0),2 + $i,1)
		_ExcelWriteCell($excel, _GUICtrlListView_GetItemText($lv,$i,1),2 + $i,2)
		_ExcelWriteCell($excel, _GUICtrlListView_GetItemText($lv,$i,2),2 + $i,3)
		_ExcelWriteCell($excel, _GUICtrlListView_GetItemText($lv,$i,3),2 + $i,4)
		_ExcelWriteCell($excel, _GUICtrlListView_GetItemText($lv,$i,4),2 + $i,5)
		_ExcelWriteCell($excel, _GUICtrlListView_GetItemText($lv,$i,5),2 + $i,6)
		_ExcelWriteCell($excel, _GUICtrlListView_GetItemText($lv,$i,6),2 + $i,7)
		_ExcelWriteCell($excel, _GUICtrlListView_GetItemText($lv,$i,7),2 + $i,8)
		_ExcelWriteCell($excel, _GUICtrlListView_GetItemText($lv,$i,8),2 + $i,9)
	$i = $i + 1
	Until $i = $count
Next

$ask = MsgBox(4,"Message","Export completed!" & @cr & @cr & "Do you want to print it now?")
if $ask = 6 Then
	Send("^p")
EndIf

EndFunc