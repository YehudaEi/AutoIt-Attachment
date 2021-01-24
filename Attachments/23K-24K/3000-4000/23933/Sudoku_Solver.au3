#include <GuiConstants.au3>
#include <Array.au3>
#include <String.au3>
#include <EditConstants.au3>

Dim $Box[10][10],$BoxData[10][10]
Dim $Row1Array[10],$Row2Array[10],$Row3Array[10],$Row4Array[10],$Row5Array[10],$Row6Array[10],$Row7Array[10],$Row8Array[10],$Row9Array[10]
Dim $Cell1Array[10],$Cell2Array[10],$Cell3Array[10],$Cell4Array[10],$Cell5Array[10],$Cell6Array[10],$Cell7Array[10],$Cell8Array[10],$Cell9Array[10]
Dim $Column1Array[10],$Column2Array[10],$Column3Array[10],$Column4Array[10],$Column5Array[10],$Column6Array[10],$Column7Array[10],$Column8Array[10],$Column9Array[10]

Global $MissingNumber, $BlankSpot
Opt("TrayIconDebug", 1)
$Form1 = GUICreate("Sudoku", 650, 650)
For $Row = 1 To 3
	For $Column = 1 To 3
		$Box[$Row][$Column] = GUICtrlCreateInput("", 15 + (65 * ($Column - 1)), 15 + (65 * ($Row - 1)), 65, 65, $ES_CENTER + $ES_NUMBER)
		GUICtrlSetLimit(-1, 1)
		GUICtrlSetFont(-1, 38, 400, 0, "Arial")
	Next
Next
For $Row = 1 To 3
	For $Column = 4 To 6
		$Box[$Row][$Column] = GUICtrlCreateInput("", 20 + (65 * ($Column - 1)), 15 + (65 * ($Row - 1)), 65, 65, $ES_CENTER + $ES_NUMBER)
		GUICtrlSetLimit(-1, 1)
		GUICtrlSetFont(-1, 38, 400, 0, "Arial")
	Next
Next
For $Row = 1 To 3
	For $Column = 7 To 9
		$Box[$Row][$Column] = GUICtrlCreateInput("", 25 + (65 * ($Column - 1)), 15 + (65 * ($Row - 1)), 65, 65, $ES_CENTER + $ES_NUMBER)
		GUICtrlSetLimit(-1, 1)
		GUICtrlSetFont(-1, 38, 400, 0, "Arial")
	Next
Next
For $Row = 4 To 6
	For $Column = 1 To 3
		$Box[$Row][$Column] = GUICtrlCreateInput("", 15 + (65 * ($Column - 1)), 20 + (65 * ($Row - 1)), 65, 65, $ES_CENTER + $ES_NUMBER)
		GUICtrlSetLimit(-1, 1)
		GUICtrlSetFont(-1, 38, 400, 0, "Arial")
	Next
Next
For $Row = 4 To 6
	For $Column = 4 To 6
		$Box[$Row][$Column] = GUICtrlCreateInput("", 20 + (65 * ($Column - 1)), 20 + (65 * ($Row - 1)), 65, 65, $ES_CENTER + $ES_NUMBER)
		GUICtrlSetLimit(-1, 1)
		GUICtrlSetFont(-1, 38, 400, 0, "Arial")
	Next
Next
For $Row = 4 To 6
	For $Column = 7 To 9
		$Box[$Row][$Column] = GUICtrlCreateInput("", 25 + (65 * ($Column - 1)), 20 + (65 * ($Row - 1)), 65, 65, $ES_CENTER + $ES_NUMBER)
		GUICtrlSetLimit(-1, 1)
		GUICtrlSetFont(-1, 38, 400, 0, "Arial")
	Next
Next
For $Row = 7 To 9
	For $Column = 1 To 3
		$Box[$Row][$Column] = GUICtrlCreateInput("", 15 + (65 * ($Column - 1)), 25 + (65 * ($Row - 1)), 65, 65, $ES_CENTER + $ES_NUMBER)
		GUICtrlSetLimit(-1, 1)
		GUICtrlSetFont(-1, 38, 400, 0, "Arial")
	Next
Next
For $Row = 7 To 9
	For $Column = 4 To 6
		$Box[$Row][$Column] = GUICtrlCreateInput("", 20 + (65 * ($Column - 1)), 25 + (65 * ($Row - 1)), 65, 65, $ES_CENTER + $ES_NUMBER)
		GUICtrlSetLimit(-1, 1)
		GUICtrlSetFont(-1, 38, 400, 0, "Arial")
	Next
Next
For $Row = 7 To 9
	For $Column = 7 To 9
		$Box[$Row][$Column] = GUICtrlCreateInput("", 25 + (65 * ($Column - 1)), 25 + (65 * ($Row - 1)), 65, 65, $ES_CENTER + $ES_NUMBER)
		GUICtrlSetLimit(-1, 1)
		GUICtrlSetFont(-1, 38, 400, 0, "Arial")
	Next
Next
$Button1 = GUICtrlCreateButton("Auto", 125, 615, 65, 33, 0)
GUISetState(@SW_SHOW)
While 1
	$msg = GUIGetMsg()
	If $msg = $GUI_EVENT_CLOSE Then Exit
	If $msg = $Button1 Then
		RecordInput()
		If Check() = 1 Then
			Solve()
		EndIf
	EndIf
WEnd
Func RecordInput()
	For $Row = 1 To 9
		For $Column = 1 To 9
			$BoxData[$Row][$Column] = GUICtrlRead($Box[$Row][$Column])
		Next
	Next
	Dim $Row1Array[10] = ["", $BoxData[1][1], $BoxData[1][2], $BoxData[1][3], $BoxData[1][4], $BoxData[1][5], $BoxData[1][6], $BoxData[1][7], $BoxData[1][8], $BoxData[1][9]]
	Dim $Row2Array[10] = ["", $BoxData[2][1], $BoxData[2][2], $BoxData[2][3], $BoxData[2][4], $BoxData[2][5], $BoxData[2][6], $BoxData[2][7], $BoxData[2][8], $BoxData[2][9]]
	Dim $Row3Array[10] = ["", $BoxData[3][1], $BoxData[3][2], $BoxData[3][3], $BoxData[3][4], $BoxData[3][5], $BoxData[3][6], $BoxData[3][7], $BoxData[3][8], $BoxData[3][9]]
	Dim $Row4Array[10] = ["", $BoxData[4][1], $BoxData[4][2], $BoxData[4][3], $BoxData[4][4], $BoxData[4][5], $BoxData[4][6], $BoxData[4][7], $BoxData[4][8], $BoxData[4][9]]
	Dim $Row5Array[10] = ["", $BoxData[5][1], $BoxData[5][2], $BoxData[5][3], $BoxData[5][4], $BoxData[5][5], $BoxData[5][6], $BoxData[5][7], $BoxData[5][8], $BoxData[5][9]]
	Dim $Row6Array[10] = ["", $BoxData[6][1], $BoxData[6][2], $BoxData[6][3], $BoxData[6][4], $BoxData[6][5], $BoxData[6][6], $BoxData[6][7], $BoxData[6][8], $BoxData[6][9]]
	Dim $Row7Array[10] = ["", $BoxData[7][1], $BoxData[7][2], $BoxData[7][3], $BoxData[7][4], $BoxData[7][5], $BoxData[7][6], $BoxData[7][7], $BoxData[7][8], $BoxData[7][9]]
	Dim $Row8Array[10] = ["", $BoxData[8][1], $BoxData[8][2], $BoxData[8][3], $BoxData[8][4], $BoxData[8][5], $BoxData[8][6], $BoxData[8][7], $BoxData[8][8], $BoxData[8][9]]
	Dim $Row9Array[10] = ["", $BoxData[9][1], $BoxData[9][2], $BoxData[9][3], $BoxData[9][4], $BoxData[9][5], $BoxData[9][6], $BoxData[9][7], $BoxData[9][8], $BoxData[9][9]]

	Dim $Column1Array[10] = ["", $BoxData[1][1], $BoxData[2][1], $BoxData[3][1], $BoxData[4][1], $BoxData[5][1], $BoxData[6][1], $BoxData[7][1], $BoxData[8][1], $BoxData[9][1]]
	Dim $Column2Array[10] = ["", $BoxData[1][2], $BoxData[2][2], $BoxData[3][2], $BoxData[4][2], $BoxData[5][2], $BoxData[6][2], $BoxData[7][2], $BoxData[8][2], $BoxData[9][2]]
	Dim $Column3Array[10] = ["", $BoxData[1][3], $BoxData[2][3], $BoxData[3][3], $BoxData[4][3], $BoxData[5][3], $BoxData[6][3], $BoxData[7][3], $BoxData[8][3], $BoxData[9][3]]
	Dim $Column4Array[10] = ["", $BoxData[1][4], $BoxData[2][4], $BoxData[3][4], $BoxData[4][4], $BoxData[5][4], $BoxData[6][4], $BoxData[7][4], $BoxData[8][4], $BoxData[9][4]]
	Dim $Column5Array[10] = ["", $BoxData[1][5], $BoxData[2][5], $BoxData[3][5], $BoxData[4][5], $BoxData[5][5], $BoxData[6][5], $BoxData[7][5], $BoxData[8][5], $BoxData[9][5]]
	Dim $Column6Array[10] = ["", $BoxData[1][6], $BoxData[2][6], $BoxData[3][6], $BoxData[4][6], $BoxData[5][6], $BoxData[6][6], $BoxData[7][6], $BoxData[8][6], $BoxData[9][6]]
	Dim $Column7Array[10] = ["", $BoxData[1][7], $BoxData[2][7], $BoxData[3][7], $BoxData[4][7], $BoxData[5][7], $BoxData[6][7], $BoxData[7][7], $BoxData[8][7], $BoxData[9][7]]
	Dim $Column8Array[10] = ["", $BoxData[1][8], $BoxData[2][8], $BoxData[3][8], $BoxData[4][8], $BoxData[5][8], $BoxData[6][8], $BoxData[7][8], $BoxData[8][8], $BoxData[9][8]]
	Dim $Column9Array[10] = ["", $BoxData[1][9], $BoxData[2][9], $BoxData[3][9], $BoxData[4][9], $BoxData[5][9], $BoxData[6][9], $BoxData[7][9], $BoxData[8][9], $BoxData[9][9]]

	Dim $Cell1Array[10] = ["", $BoxData[1][1], $BoxData[1][2], $BoxData[1][3], $BoxData[2][1], $BoxData[2][2], $BoxData[2][3], $BoxData[3][1], $BoxData[3][2], $BoxData[3][3]]
	Dim $Cell2Array[10] = ["", $BoxData[1][4], $BoxData[1][5], $BoxData[1][6], $BoxData[2][4], $BoxData[2][5], $BoxData[2][6], $BoxData[3][4], $BoxData[3][5], $BoxData[3][6]]
	Dim $Cell3Array[10] = ["", $BoxData[1][7], $BoxData[1][8], $BoxData[1][9], $BoxData[2][7], $BoxData[2][8], $BoxData[2][9], $BoxData[3][7], $BoxData[3][8], $BoxData[3][9]]
	Dim $Cell4Array[10] = ["", $BoxData[4][1], $BoxData[4][2], $BoxData[4][3], $BoxData[5][1], $BoxData[5][2], $BoxData[5][3], $BoxData[6][1], $BoxData[6][2], $BoxData[6][3]]
	Dim $Cell5Array[10] = ["", $BoxData[4][4], $BoxData[4][5], $BoxData[4][6], $BoxData[5][4], $BoxData[5][5], $BoxData[5][6], $BoxData[6][4], $BoxData[6][5], $BoxData[6][6]]
	Dim $Cell6Array[10] = ["", $BoxData[4][7], $BoxData[4][8], $BoxData[4][9], $BoxData[5][7], $BoxData[5][8], $BoxData[5][9], $BoxData[6][7], $BoxData[6][8], $BoxData[6][9]]
	Dim $Cell7Array[10] = ["", $BoxData[7][1], $BoxData[7][2], $BoxData[7][3], $BoxData[8][1], $BoxData[8][2], $BoxData[8][3], $BoxData[9][1], $BoxData[9][2], $BoxData[9][3]]
	Dim $Cell8Array[10] = ["", $BoxData[7][4], $BoxData[7][5], $BoxData[7][6], $BoxData[8][4], $BoxData[8][5], $BoxData[8][6], $BoxData[9][4], $BoxData[9][5], $BoxData[9][6]]
	Dim $Cell9Array[10] = ["", $BoxData[7][7], $BoxData[7][8], $BoxData[7][9], $BoxData[8][7], $BoxData[8][8], $BoxData[8][9], $BoxData[9][7], $BoxData[9][8], $BoxData[9][9]]
EndFunc   ;==>RecordInput
Func Check()
	For $x = 1 To 9
		If UBound(_ArrayFindAll($Row1Array, $x)) > 1 Then
			MsgBox(0, "Error", "You have entered an invalid value into row 1")
			Return 0
		ElseIf UBound(_ArrayFindAll($Row2Array, $x)) > 1 Then
			MsgBox(0, "Error", "You have entered an invalid value into row 2")
			Return 0
		ElseIf UBound(_ArrayFindAll($Row3Array, $x)) > 1 Then
			MsgBox(0, "Error", "You have entered an invalid value into row 3")
			Return 0
		ElseIf UBound(_ArrayFindAll($Row4Array, $x)) > 1 Then
			MsgBox(0, "Error", "You have entered an invalid value into row 4")
			Return 0
		ElseIf UBound(_ArrayFindAll($Row5Array, $x)) > 1 Then
			MsgBox(0, "Error", "You have entered an invalid value into row 5")
			Return 0
		ElseIf UBound(_ArrayFindAll($Row6Array, $x)) > 1 Then
			MsgBox(0, "Error", "You have entered an invalid value into row 6")
			Return 0
		ElseIf UBound(_ArrayFindAll($Row7Array, $x)) > 1 Then
			MsgBox(0, "Error", "You have entered an invalid value into row 7")
			Return 0
		ElseIf UBound(_ArrayFindAll($Row8Array, $x)) > 1 Then
			MsgBox(0, "Error", "You have entered an invalid value into row 8")
			Return 0
		ElseIf UBound(_ArrayFindAll($Row9Array, $x)) > 1 Then
			MsgBox(0, "Error", "You have entered an invalid value into row 9")
			Return 0
		ElseIf UBound(_ArrayFindAll($Column1Array, $x)) > 1 Then
			MsgBox(0, "Error", "You have entered an invalid value into column 1")
			Return 0
		ElseIf UBound(_ArrayFindAll($Column2Array, $x)) > 1 Then
			MsgBox(0, "Error", "You have entered an invalid value into column 2")
			Return 0
		ElseIf UBound(_ArrayFindAll($Column3Array, $x)) > 1 Then
			MsgBox(0, "Error", "You have entered an invalid value into column 3")
			Return 0
		ElseIf UBound(_ArrayFindAll($Column4Array, $x)) > 1 Then
			MsgBox(0, "Error", "You have entered an invalid value into column 4")
			Return 0
		ElseIf UBound(_ArrayFindAll($Column5Array, $x)) > 1 Then
			MsgBox(0, "Error", "You have entered an invalid value into column 5")
			Return 0
		ElseIf UBound(_ArrayFindAll($Column6Array, $x)) > 1 Then
			MsgBox(0, "Error", "You have entered an invalid value into column 6")
			Return 0
		ElseIf UBound(_ArrayFindAll($Column7Array, $x)) > 1 Then
			MsgBox(0, "Error", "You have entered an invalid value into column 7")
			Return 0
		ElseIf UBound(_ArrayFindAll($Column8Array, $x)) > 1 Then
			MsgBox(0, "Error", "You have entered an invalid value into column 8")
			Return 0
		ElseIf UBound(_ArrayFindAll($Column9Array, $x)) > 1 Then
			MsgBox(0, "Error", "You have entered an invalid value into column 9")
			Return 0
		ElseIf UBound(_ArrayFindAll($Cell1Array, $x)) > 1 Then
			MsgBox(0, "Error", "You have entered an invalid value into cell 1")
			Return 0
		ElseIf UBound(_ArrayFindAll($Cell2Array, $x)) > 1 Then
			MsgBox(0, "Error", "You have entered an invalid value into cell 2")
			Return 0
		ElseIf UBound(_ArrayFindAll($Cell3Array, $x)) > 1 Then
			MsgBox(0, "Error", "You have entered an invalid value into cell 3")
			Return 0
		ElseIf UBound(_ArrayFindAll($Cell4Array, $x)) > 1 Then
			MsgBox(0, "Error", "You have entered an invalid value into cell 4")
			Return 0
		ElseIf UBound(_ArrayFindAll($Cell5Array, $x)) > 1 Then
			MsgBox(0, "Error", "You have entered an invalid value into cell 5")
			Return 0
		ElseIf UBound(_ArrayFindAll($Cell6Array, $x)) > 1 Then
			MsgBox(0, "Error", "You have entered an invalid value into cell 6")
			Return 0
		ElseIf UBound(_ArrayFindAll($Cell7Array, $x)) > 1 Then
			MsgBox(0, "Error", "You have entered an invalid value into cell 7")
			Return 0
		ElseIf UBound(_ArrayFindAll($Cell8Array, $x)) > 1 Then
			MsgBox(0, "Error", "You have entered an invalid value into cell 8")
			Return 0
		ElseIf UBound(_ArrayFindAll($Cell9Array, $x)) > 1 Then
			MsgBox(0, "Error", "You have entered an invalid value into cell 9")
			Return 0
		EndIf
	Next
	Return 1
EndFunc   ;==>Check
Func Solve();solves the puzzle

;                     redo whole function

	If FindBlank($Row1Array) <> 0 Then GUICtrlSetData($Box[1][$BlankSpot], $MissingNumber)
	If FindBlank($Row2Array) <> 0 Then GUICtrlSetData($Box[2][$BlankSpot], $MissingNumber)
	If FindBlank($Row3Array) <> 0 Then GUICtrlSetData($Box[3][$BlankSpot], $MissingNumber)
	If FindBlank($Row4Array) <> 0 Then GUICtrlSetData($Box[4][$BlankSpot], $MissingNumber)
	If FindBlank($Row5Array) <> 0 Then GUICtrlSetData($Box[5][$BlankSpot], $MissingNumber)
	If FindBlank($Row6Array) <> 0 Then GUICtrlSetData($Box[6][$BlankSpot], $MissingNumber)
	If FindBlank($Row7Array) <> 0 Then GUICtrlSetData($Box[7][$BlankSpot], $MissingNumber)
	If FindBlank($Row8Array) <> 0 Then GUICtrlSetData($Box[8][$BlankSpot], $MissingNumber)
	If FindBlank($Row9Array) <> 0 Then GUICtrlSetData($Box[9][$BlankSpot], $MissingNumber)
	
	If FindBlank($Column1Array) <> 0 Then GUICtrlSetData($Box[$BlankSpot][1], $MissingNumber)
	If FindBlank($Column2Array) <> 0 Then GUICtrlSetData($Box[$BlankSpot][2], $MissingNumber)
	If FindBlank($Column3Array) <> 0 Then GUICtrlSetData($Box[$BlankSpot][3], $MissingNumber)
	If FindBlank($Column4Array) <> 0 Then GUICtrlSetData($Box[$BlankSpot][4], $MissingNumber)
	If FindBlank($Column5Array) <> 0 Then GUICtrlSetData($Box[$BlankSpot][5], $MissingNumber)
	If FindBlank($Column6Array) <> 0 Then GUICtrlSetData($Box[$BlankSpot][6], $MissingNumber)
	If FindBlank($Column7Array) <> 0 Then GUICtrlSetData($Box[$BlankSpot][7], $MissingNumber)
	If FindBlank($Column8Array) <> 0 Then GUICtrlSetData($Box[$BlankSpot][8], $MissingNumber)
	If FindBlank($Column9Array) <> 0 Then GUICtrlSetData($Box[$BlankSpot][9], $MissingNumber)
	
	If FindBlank($Cell1Array) <> 0 And $BlankSpot = 1 Then GUICtrlSetData($Box[1][1], $MissingNumber)
	If FindBlank($Cell1Array) <> 0 And $BlankSpot = 2 Then GUICtrlSetData($Box[1][2], $MissingNumber)
	If FindBlank($Cell1Array) <> 0 And $BlankSpot = 3 Then GUICtrlSetData($Box[1][3], $MissingNumber)
	If FindBlank($Cell1Array) <> 0 And $BlankSpot = 4 Then GUICtrlSetData($Box[2][1], $MissingNumber)
	If FindBlank($Cell1Array) <> 0 And $BlankSpot = 5 Then GUICtrlSetData($Box[2][2], $MissingNumber)
	If FindBlank($Cell1Array) <> 0 And $BlankSpot = 6 Then GUICtrlSetData($Box[2][3], $MissingNumber)
	If FindBlank($Cell1Array) <> 0 And $BlankSpot = 7 Then GUICtrlSetData($Box[3][1], $MissingNumber)
	If FindBlank($Cell1Array) <> 0 And $BlankSpot = 8 Then GUICtrlSetData($Box[3][2], $MissingNumber)
	If FindBlank($Cell1Array) <> 0 And $BlankSpot = 9 Then GUICtrlSetData($Box[3][3], $MissingNumber)
	
	If FindBlank($Cell2Array) <> 0 And $BlankSpot = 1 Then GUICtrlSetData($Box[1][4], $MissingNumber)
	If FindBlank($Cell2Array) <> 0 And $BlankSpot = 2 Then GUICtrlSetData($Box[1][5], $MissingNumber)
	If FindBlank($Cell2Array) <> 0 And $BlankSpot = 3 Then GUICtrlSetData($Box[1][6], $MissingNumber)
	If FindBlank($Cell2Array) <> 0 And $BlankSpot = 4 Then GUICtrlSetData($Box[2][4], $MissingNumber)
	If FindBlank($Cell2Array) <> 0 And $BlankSpot = 5 Then GUICtrlSetData($Box[2][5], $MissingNumber)
	If FindBlank($Cell2Array) <> 0 And $BlankSpot = 6 Then GUICtrlSetData($Box[2][6], $MissingNumber)
	If FindBlank($Cell2Array) <> 0 And $BlankSpot = 7 Then GUICtrlSetData($Box[3][4], $MissingNumber)
	If FindBlank($Cell2Array) <> 0 And $BlankSpot = 8 Then GUICtrlSetData($Box[3][5], $MissingNumber)
	If FindBlank($Cell2Array) <> 0 And $BlankSpot = 9 Then GUICtrlSetData($Box[3][6], $MissingNumber)
	
	If FindBlank($Cell3Array) <> 0 And $BlankSpot = 1 Then GUICtrlSetData($Box[1][7], $MissingNumber)
	If FindBlank($Cell3Array) <> 0 And $BlankSpot = 2 Then GUICtrlSetData($Box[1][8], $MissingNumber)
	If FindBlank($Cell3Array) <> 0 And $BlankSpot = 3 Then GUICtrlSetData($Box[1][9], $MissingNumber)
	If FindBlank($Cell3Array) <> 0 And $BlankSpot = 4 Then GUICtrlSetData($Box[2][7], $MissingNumber)
	If FindBlank($Cell3Array) <> 0 And $BlankSpot = 5 Then GUICtrlSetData($Box[2][8], $MissingNumber)
	If FindBlank($Cell3Array) <> 0 And $BlankSpot = 6 Then GUICtrlSetData($Box[2][9], $MissingNumber)
	If FindBlank($Cell3Array) <> 0 And $BlankSpot = 7 Then GUICtrlSetData($Box[3][7], $MissingNumber)
	If FindBlank($Cell3Array) <> 0 And $BlankSpot = 8 Then GUICtrlSetData($Box[3][8], $MissingNumber)
	If FindBlank($Cell3Array) <> 0 And $BlankSpot = 9 Then GUICtrlSetData($Box[3][9], $MissingNumber)
	
	If FindBlank($Cell4Array) <> 0 And $BlankSpot = 1 Then GUICtrlSetData($Box[4][1], $MissingNumber)
	If FindBlank($Cell4Array) <> 0 And $BlankSpot = 2 Then GUICtrlSetData($Box[4][2], $MissingNumber)
	If FindBlank($Cell4Array) <> 0 And $BlankSpot = 3 Then GUICtrlSetData($Box[4][3], $MissingNumber)
	If FindBlank($Cell4Array) <> 0 And $BlankSpot = 4 Then GUICtrlSetData($Box[5][1], $MissingNumber)
	If FindBlank($Cell4Array) <> 0 And $BlankSpot = 5 Then GUICtrlSetData($Box[5][2], $MissingNumber)
	If FindBlank($Cell4Array) <> 0 And $BlankSpot = 6 Then GUICtrlSetData($Box[5][3], $MissingNumber)
	If FindBlank($Cell4Array) <> 0 And $BlankSpot = 7 Then GUICtrlSetData($Box[6][1], $MissingNumber)
	If FindBlank($Cell4Array) <> 0 And $BlankSpot = 8 Then GUICtrlSetData($Box[6][2], $MissingNumber)
	If FindBlank($Cell4Array) <> 0 And $BlankSpot = 9 Then GUICtrlSetData($Box[6][3], $MissingNumber)
	
	If FindBlank($Cell5Array) <> 0 And $BlankSpot = 1 Then GUICtrlSetData($Box[4][4], $MissingNumber)
	If FindBlank($Cell5Array) <> 0 And $BlankSpot = 2 Then GUICtrlSetData($Box[4][5], $MissingNumber)
	If FindBlank($Cell5Array) <> 0 And $BlankSpot = 3 Then GUICtrlSetData($Box[4][6], $MissingNumber)
	If FindBlank($Cell5Array) <> 0 And $BlankSpot = 4 Then GUICtrlSetData($Box[5][4], $MissingNumber)
	If FindBlank($Cell5Array) <> 0 And $BlankSpot = 5 Then GUICtrlSetData($Box[5][5], $MissingNumber)
	If FindBlank($Cell5Array) <> 0 And $BlankSpot = 6 Then GUICtrlSetData($Box[5][6], $MissingNumber)
	If FindBlank($Cell5Array) <> 0 And $BlankSpot = 7 Then GUICtrlSetData($Box[6][4], $MissingNumber)
	If FindBlank($Cell5Array) <> 0 And $BlankSpot = 8 Then GUICtrlSetData($Box[6][5], $MissingNumber)
	If FindBlank($Cell5Array) <> 0 And $BlankSpot = 9 Then GUICtrlSetData($Box[6][6], $MissingNumber)
	
	If FindBlank($Cell6Array) <> 0 And $BlankSpot = 1 Then GUICtrlSetData($Box[4][7], $MissingNumber)
	If FindBlank($Cell6Array) <> 0 And $BlankSpot = 2 Then GUICtrlSetData($Box[4][8], $MissingNumber)
	If FindBlank($Cell6Array) <> 0 And $BlankSpot = 3 Then GUICtrlSetData($Box[4][9], $MissingNumber)
	If FindBlank($Cell6Array) <> 0 And $BlankSpot = 4 Then GUICtrlSetData($Box[5][7], $MissingNumber)
	If FindBlank($Cell6Array) <> 0 And $BlankSpot = 5 Then GUICtrlSetData($Box[5][8], $MissingNumber)
	If FindBlank($Cell6Array) <> 0 And $BlankSpot = 6 Then GUICtrlSetData($Box[5][9], $MissingNumber)
	If FindBlank($Cell6Array) <> 0 And $BlankSpot = 7 Then GUICtrlSetData($Box[6][7], $MissingNumber)
	If FindBlank($Cell6Array) <> 0 And $BlankSpot = 8 Then GUICtrlSetData($Box[6][8], $MissingNumber)
	If FindBlank($Cell6Array) <> 0 And $BlankSpot = 9 Then GUICtrlSetData($Box[6][9], $MissingNumber)
	
	If FindBlank($Cell7Array) <> 0 And $BlankSpot = 1 Then GUICtrlSetData($Box[7][1], $MissingNumber)
	If FindBlank($Cell7Array) <> 0 And $BlankSpot = 2 Then GUICtrlSetData($Box[7][2], $MissingNumber)
	If FindBlank($Cell7Array) <> 0 And $BlankSpot = 3 Then GUICtrlSetData($Box[7][3], $MissingNumber)
	If FindBlank($Cell7Array) <> 0 And $BlankSpot = 4 Then GUICtrlSetData($Box[8][1], $MissingNumber)
	If FindBlank($Cell7Array) <> 0 And $BlankSpot = 5 Then GUICtrlSetData($Box[8][2], $MissingNumber)
	If FindBlank($Cell7Array) <> 0 And $BlankSpot = 6 Then GUICtrlSetData($Box[8][3], $MissingNumber)
	If FindBlank($Cell7Array) <> 0 And $BlankSpot = 7 Then GUICtrlSetData($Box[9][1], $MissingNumber)
	If FindBlank($Cell7Array) <> 0 And $BlankSpot = 8 Then GUICtrlSetData($Box[9][2], $MissingNumber)
	If FindBlank($Cell7Array) <> 0 And $BlankSpot = 9 Then GUICtrlSetData($Box[9][3], $MissingNumber)
	
	If FindBlank($Cell8Array) <> 0 And $BlankSpot = 1 Then GUICtrlSetData($Box[7][4], $MissingNumber)
	If FindBlank($Cell8Array) <> 0 And $BlankSpot = 2 Then GUICtrlSetData($Box[7][5], $MissingNumber)
	If FindBlank($Cell8Array) <> 0 And $BlankSpot = 3 Then GUICtrlSetData($Box[7][6], $MissingNumber)
	If FindBlank($Cell8Array) <> 0 And $BlankSpot = 4 Then GUICtrlSetData($Box[8][4], $MissingNumber)
	If FindBlank($Cell8Array) <> 0 And $BlankSpot = 5 Then GUICtrlSetData($Box[8][5], $MissingNumber)
	If FindBlank($Cell8Array) <> 0 And $BlankSpot = 6 Then GUICtrlSetData($Box[8][6], $MissingNumber)
	If FindBlank($Cell8Array) <> 0 And $BlankSpot = 7 Then GUICtrlSetData($Box[9][4], $MissingNumber)
	If FindBlank($Cell8Array) <> 0 And $BlankSpot = 8 Then GUICtrlSetData($Box[9][5], $MissingNumber)
	If FindBlank($Cell8Array) <> 0 And $BlankSpot = 9 Then GUICtrlSetData($Box[9][6], $MissingNumber)
	
	If FindBlank($Cell9Array) <> 0 And $BlankSpot = 1 Then GUICtrlSetData($Box[7][7], $MissingNumber)
	If FindBlank($Cell9Array) <> 0 And $BlankSpot = 2 Then GUICtrlSetData($Box[7][8], $MissingNumber)
	If FindBlank($Cell9Array) <> 0 And $BlankSpot = 3 Then GUICtrlSetData($Box[7][9], $MissingNumber)
	If FindBlank($Cell9Array) <> 0 And $BlankSpot = 4 Then GUICtrlSetData($Box[8][7], $MissingNumber)
	If FindBlank($Cell9Array) <> 0 And $BlankSpot = 5 Then GUICtrlSetData($Box[8][8], $MissingNumber)
	If FindBlank($Cell9Array) <> 0 And $BlankSpot = 6 Then GUICtrlSetData($Box[8][9], $MissingNumber)
	If FindBlank($Cell9Array) <> 0 And $BlankSpot = 7 Then GUICtrlSetData($Box[9][7], $MissingNumber)
	If FindBlank($Cell9Array) <> 0 And $BlankSpot = 8 Then GUICtrlSetData($Box[9][8], $MissingNumber)
	If FindBlank($Cell9Array) <> 0 And $BlankSpot = 9 Then GUICtrlSetData($Box[9][9], $MissingNumber)

;~ 	If FindBlank($Row1Array) <> 0 Then GUICtrlSetData($Box[1][$BlankSpot], $MissingNumber)
;~ 	If FindBlank($Row2Array) <> 0 Then GUICtrlSetData($Box[2][$BlankSpot], $MissingNumber)
;~ 	If FindBlank($Row3Array) <> 0 Then GUICtrlSetData($Box[3][$BlankSpot], $MissingNumber)
;~ 	If FindBlank($Row4Array) <> 0 Then GUICtrlSetData($Box[4][$BlankSpot], $MissingNumber)
;~ 	If FindBlank($Column1Array) <> 0 Then GUICtrlSetData($Box[$BlankSpot][1], $MissingNumber)
;~ 	If FindBlank($Column2Array) <> 0 Then GUICtrlSetData($Box[$BlankSpot][2], $MissingNumber)
;~ 	If FindBlank($Column3Array) <> 0 Then GUICtrlSetData($Box[$BlankSpot][3], $MissingNumber)
;~ 	If FindBlank($Column4Array) <> 0 Then GUICtrlSetData($Box[$BlankSpot][4], $MissingNumber)
;~ 	If FindBlank($Cell1Array) <> 0 And $BlankSpot = 1 Then GUICtrlSetData($Box[1][1], $MissingNumber)
;~ 	If FindBlank($Cell1Array) <> 0 And $BlankSpot = 2 Then GUICtrlSetData($Box[1][2], $MissingNumber)
;~ 	If FindBlank($Cell1Array) <> 0 And $BlankSpot = 3 Then GUICtrlSetData($Box[2][1], $MissingNumber)
;~ 	If FindBlank($Cell1Array) <> 0 And $BlankSpot = 4 Then GUICtrlSetData($Box[2][2], $MissingNumber)
;~ 	If FindBlank($Cell2Array) <> 0 And $BlankSpot = 1 Then GUICtrlSetData($Box[1][3], $MissingNumber)
;~ 	If FindBlank($Cell2Array) <> 0 And $BlankSpot = 2 Then GUICtrlSetData($Box[1][4], $MissingNumber)
;~ 	If FindBlank($Cell2Array) <> 0 And $BlankSpot = 3 Then GUICtrlSetData($Box[2][3], $MissingNumber)
;~ 	If FindBlank($Cell2Array) <> 0 And $BlankSpot = 4 Then GUICtrlSetData($Box[2][4], $MissingNumber)
;~ 	If FindBlank($Cell3Array) <> 0 And $BlankSpot = 1 Then GUICtrlSetData($Box[3][1], $MissingNumber)
;~ 	If FindBlank($Cell3Array) <> 0 And $BlankSpot = 2 Then GUICtrlSetData($Box[3][2], $MissingNumber)
;~ 	If FindBlank($Cell3Array) <> 0 And $BlankSpot = 3 Then GUICtrlSetData($Box[4][1], $MissingNumber)
;~ 	If FindBlank($Cell3Array) <> 0 And $BlankSpot = 4 Then GUICtrlSetData($Box[4][2], $MissingNumber)
;~ 	If FindBlank($Cell4Array) <> 0 And $BlankSpot = 1 Then GUICtrlSetData($Box[3][3], $MissingNumber)
;~ 	If FindBlank($Cell4Array) <> 0 And $BlankSpot = 2 Then GUICtrlSetData($Box[3][4], $MissingNumber)
;~ 	If FindBlank($Cell4Array) <> 0 And $BlankSpot = 3 Then GUICtrlSetData($Box[4][3], $MissingNumber)
;~ 	If FindBlank($Cell4Array) <> 0 And $BlankSpot = 4 Then GUICtrlSetData($Box[4][4], $MissingNumber)
EndFunc   ;==>Solve
Func FindBlank($Array)
	$Blank = _ArrayFindAll($Array, "")
	If UBound($Blank) = 2 Then
		$BlankSpot = $Blank[1]
		$Value = ""
		For $element In $Array
			$EValue = _StringToHex($element)
			$Value = $Value + $EValue
		Next
		$MissingHex = 315 - $Value
		$MissingNumber = _HexToString($MissingHex)
		Return $MissingNumber
	Else
		Return 0
	EndIf
EndFunc   ;==>FindBlank