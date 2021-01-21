;XLListViewSel2.au3
#include-once
#include <GuiConstants.au3>
#include <GuiListView.au3>
;Opt ('MustDeclareVars', 1)
;Dim $listview, $Btn_Exit, $msg, $Status, $Btn_piped, $Btn_array, $ret
#include"ExcelCom.au3"
;#include<ExcelCom2_37a.au3>
;#include <ExcelCom.au3>
;$FilePath=@ScriptDir&"\Blank.xls"
;_XLCreateBlank($FilePath)
;_XLClose($FilePath,0,0)
;_XLExit($FilePath)
;Opt ('MustDeclareVars', 1)
Dim $listview, $Btn_Get, $Btn_GetSelected, $Btn_Exit, $msg, $Status, $ret,$Btn_Excel,$CsvFile,$XLFile, $f,$ExcelLine,$Btn_piped
Dim $Btn_GetSelectedOld,$Btn_array,$oXLDummy, $Btn_GetSelected2
$CsvFile =@ScriptDir&"\"&"ListView.csv"
$XLFile =@ScriptDir&"\"&"ListView.xls"
If not WinExists("Microsoft Excel") Then
	$oXLDummy=ObjCreate("Excel.Application")
EndIf
If FileExists($CsvFile) Then
	FileDelete($CsvFile)
endif
GUICreate("ListView Get Selected Indices", 392, 322)
$listview = GUICtrlCreateListView("col1|col2|col3", 40, 30, 310, 149, BitOR($LVS_SHOWSELALWAYS, $LVS_NOSORTHEADER), BitOR($LVS_EX_GRIDLINES, $LVS_EX_FULLROWSELECT, $LVS_EX_REGIONAL))
GUICtrlCreateListViewItem("line1|data1|more1", $listview)
GUICtrlCreateListViewItem("line2|data2|more2", $listview)
GUICtrlCreateListViewItem("line3|data3|more3", $listview)
GUICtrlCreateListViewItem("line4|data4|more4", $listview)
GUICtrlCreateListViewItem("line5|data5|more5", $listview)
$Btn_piped = GUICtrlCreateButton("Return string", 75, 210, 90, 30)
$Btn_GetSelected = GUICtrlCreateButton("Excel Selected", 75, 260, 90, 30)
$Btn_array = GUICtrlCreateButton("Return array", 180, 210, 90, 30)
$Btn_Exit = GUICtrlCreateButton("Exit", 180, 260, 70, 30)
$Status = GUICtrlCreateLabel("", 0, 302, 392, 20, BitOR($SS_SUNKEN, $SS_CENTER))
GUISetState()
While 1
	$msg = GUIGetMsg()
	Select
		Case $msg = $GUI_EVENT_CLOSE Or $msg = $Btn_Exit
			ExitLoop
		Case $msg = $Btn_piped
			Local $s_indices =  _GUICtrlListViewGetSelectedIndices($listview)
			If($s_indices == $LV_ERR) Then
				GUICtrlSetData($Status, "Not Items Selected")
			Else
				MsgBox(0,"Selected", $s_indices)
			EndIf
		Case $msg = $Btn_array
			Local $a_indices = _GUICtrlListViewGetSelectedIndices($listview,1)
			If(IsArray($a_indices))Then
				Local $i
				For $i = 1 To $a_indices[0]
					;MsgBox(0,"Selected", $a_indices[$i])
					$ret = _GUICtrlListViewGetItemText ($listview,  $a_indices[$i])
					If ($ret <> $LV_ERR) Then
						MsgBox(0, "Selected Item, Row", $ret)
					EndIf
				Next
			Else
				GUICtrlSetData($Status, "Not Items Selected")
			EndIf

		Case $msg = $Btn_GetSelected
				_XLFromListView($XLFile,$Listview,1,1)	
			EndSelect
WEnd
Exit
