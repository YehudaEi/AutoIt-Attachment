#include <GuiConstants.au3>
#include <Array.au3>
#include <String.au3>

Dim $Box[5][5],$Input[17], $Row1Array[5], $Row2Array[5], $Row3Array[5], $Row4Array[5], $Column1Array[5], $Column2Array[5]
Dim $Column3Array[5], $Column4Array[5], $Cell1Array[5], $Cell2Array[5], $Cell3Array[5], $Cell4Array[5], $NRow1Array[1]
Dim $NRow2Array[1], $NRow3Array[1], $NRow4Array[1], $NColumn1Array[1], $NColumn2Array[1], $NColumn3Array[1], $NColumn4Array[1]
Dim $NCell1Array[1], $NCell2Array[1], $NCell3Array[1], $NCell4Array[1]

Opt("TrayIconDebug", 1)

$Form1 = GUICreate("Sudoku", 633, 447, 193, 125)
$Input[1] = GUICtrlCreateInput("", 128, 88, 30, 30)
$Input[2] = GUICtrlCreateInput("", 157, 88, 30, 30)
$Input[5] = GUICtrlCreateInput("", 128, 117, 30, 30)
$Input[6] = GUICtrlCreateInput("", 157, 117, 30, 30)
$Input[3] = GUICtrlCreateInput("", 200, 88, 30, 30)
$Input[4] = GUICtrlCreateInput("", 229, 88, 30, 30)
$Input[7] = GUICtrlCreateInput("", 200, 117, 30, 30)
$Input[8] = GUICtrlCreateInput("", 229, 117, 30, 30)
$Input[9] = GUICtrlCreateInput("", 128, 160, 30, 30)
$Input[10] = GUICtrlCreateInput("", 157, 160, 30, 30)
$Input[13] = GUICtrlCreateInput("", 128, 189, 30, 30)
$Input[14] = GUICtrlCreateInput("", 157, 189, 30, 30)
$Input[11] = GUICtrlCreateInput("", 200, 160, 30, 30)
$Input[12] = GUICtrlCreateInput("", 229, 160, 30, 30)
$Input[15] = GUICtrlCreateInput("", 200, 189, 30, 30)
$Input[16] = GUICtrlCreateInput("", 229, 189, 30, 30)
$Button1 = GUICtrlCreateButton("Auto", 152, 256, 65, 33, 0)
$a = 0
For $x = 1 To 16
	GUICtrlSetLimit($Input[$x], 1)
Next
GUISetState(@SW_SHOW)

While 1
	While 1
		$msg = GUIGetMsg()
		If $msg = $GUI_EVENT_CLOSE Then Exit
		If $msg = $Button1 Then
			Values()
			If Check() = 0 Then
				ExitLoop
			Else
				Solve()
			EndIf
		EndIf
	WEnd
WEnd
Func Values();write values in each box to an array
	$z = 0
	For $x = 1 To 4;row
		For $y = 1 To 4;column
			$z = $z+1
			$Box[$x][$y] = GUICtrlRead($Input[$z])
		Next
	Next
EndFunc
Func Check();Makes sure there isn't two numbers in a single row, box, or column
	;value arrangement: topleft, topright, bottomleft, bottomright
	Dim $Row1Array[4] = [$Box[1][1], $Box[1][2], $Box[1][3], $Box[1][4]]
	For $x = 1 To 4
		$NRow1Array = _ArrayFindAll($Row1Array, $x)
		If UBound($NRow1Array) > 1 Then
			MsgBox(0, "Error", "You have entered an invalid value into row 1")
			Return 0
		EndIf
	Next
	Dim $Row2Array[4] = [$Box[2][1], $Box[2][2], $Box[2][3], $Box[2][4]]
	For $x = 1 To 4
		$NRow2Array = _ArrayFindAll($Row2Array, $x)
		If UBound($NRow2Array) > 1 Then
			MsgBox(0, "Error", "You have entered an invalid value into row 2")
			Return 0
		EndIf
	Next
	Dim $Row3Array[4] = [$Box[3][1], $Box[3][2], $Box[3][3], $Box[3][4]]
	For $x = 1 To 4
		$NRow3Array =  _ArrayFindAll($Row3Array, $x)
		If UBound($NRow3Array) > 1 Then
			MsgBox(0, "Error", "You have entered an invalid value into row 3")
			Return 0
		EndIf
	Next
	Dim $Row4Array[4] = [$Box[4][1], $Box[4][2], $Box[4][3], $Box[4][4]]
	For $x = 1 To 4
		$NRow4Array =  _ArrayFindAll($Row4Array, $x)
		If UBound($NRow4Array) > 1 Then
			MsgBox(0, "Error", "You have entered an invalid value into row 4")
			Return 0
		EndIf
	Next
	
	Dim $Column1Array[4] = [$Box[1][1], $Box[2][1], $Box[3][1], $Box[4][1]]
	For $x = 1 To 4
		$NColumn1Array =  _ArrayFindAll($Column1Array, $x)
		If UBound($NColumn1Array) > 1 Then
			MsgBox(0, "Error", "You have entered an invalid value into column 1")
			Return 0
		EndIf
	Next
	Dim $Column2Array[4] = [$Box[1][2], $Box[2][2], $Box[3][2], $Box[4][2]]
	For $x = 1 To 4
		$NColumn2Array =  _ArrayFindAll($Column2Array, $x)
		If UBound($NColumn2Array) > 1 Then
			MsgBox(0, "Error", "You have entered an invalid value into column 2")
			Return 0
		EndIf
	Next
	Dim $Column3Array[4] = [$Box[1][3], $Box[2][3], $Box[3][3], $Box[4][3]]
	For $x = 1 To 4
		$NColumn3Array =  _ArrayFindAll($Column3Array, $x)
		If UBound($NColumn3Array) > 1 Then
			MsgBox(0, "Error", "You have entered an invalid value into column 3")
			Return 0
		EndIf
	Next
	Dim $Column4Array[4] = [$Box[1][4], $Box[2][4], $Box[3][4], $Box[4][4]]
	For $x = 1 To 4
		$NColumn4Array =  _ArrayFindAll($Column4Array, $x)
		If UBound($NColumn4Array) > 1 Then
			MsgBox(0, "Error", "You have entered an invalid value into column 4")
			Return 0
		EndIf
	Next
	
	Dim $Cell1Array[4] = [$Box[1][1], $Box[1][2], $Box[2][1], $Box[2][2]]
	For $x = 1 To 4
		$NCell1Array =  _ArrayFindAll($Cell1Array, $x)
		If UBound($NCell1Array) > 1 Then
			MsgBox(0, "Error", "You have entered an invalid value into cell 1")
			Return 0
		EndIf
	Next
	Dim $Cell2Array[4] = [$Box[1][3], $Box[1][4], $Box[2][3], $Box[2][4]]
	For $x = 1 To 4
		$NCell2Array =  _ArrayFindAll($Cell2Array, $x)
		If UBound($NCell2Array) > 1 Then
			MsgBox(0, "Error", "You have entered an invalid value into cell 2")
			Return 0
		EndIf
	Next
	Dim $Cell3Array[4] = [$Box[3][1], $Box[3][2], $Box[4][1], $Box[4][2]]
	For $x = 1 To 4
		$NCell3Array =  _ArrayFindAll($Cell3Array, $x)
		If UBound($NCell3Array) > 1 Then
			MsgBox(0, "Error", "You have entered an invalid value into cell 3")
			Return 0
		EndIf
	Next
	Dim $Cell4Array[4] = [$Box[3][3], $Box[3][4], $Box[4][3], $Box[4][4]]
	For $x = 1 To 4
		$NCell4Array =  _ArrayFindAll($Cell4Array, $x)
		If UBound($NCell4Array) > 1 Then
			MsgBox(0, "Error", "You have entered an invalid value into cell 4")
			Return 0
		EndIf
	Next
	Return 1
EndFunc
Func Solve();solves the puzzle
	;progressing
	FindBlank($Row1Array)
	_ArrayDisplay($Row1Array)
EndFunc
Func FindBlank($Array)
	$Blank = _ArrayFindAll($Array, "")
	If UBound($Blank) = 1 Then
		$BlankSpot = $Blank[0]
		$Value = ""
		For $element In $Array
			$EValue = _StringToHex($element)
			$Value = $Value + $EValue
		Next
		$MissingHex = 130 - $Value
		$MissingNumber = _HexToString($MissingHex)
	EndIf
EndFunc