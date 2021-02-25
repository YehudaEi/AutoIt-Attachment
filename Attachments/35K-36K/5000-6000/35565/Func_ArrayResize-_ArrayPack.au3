
#include <Array.au3>
#include <File.au3>

;===============================================================================
; Example of usage for function _ArrayResize and function _ArrayPack
;===============================================================================
ConsoleWrite("_ArrayResize Example" & @TAB & "create a one dimensional array containing a list of files in directory" & @CRLF)
;create a one dimensional array containing a list of files in directory
$testArray = _FileListToArray(@ScriptDir)
For $row = 1 To UBound($testArray, 1) - 1
	$testArray[$row] = @ScriptDir & "\" & $testArray[$row]
Next

ShowArray($testArray)

;===============================================================================
ConsoleWrite("_ArrayResize Example" & @TAB & "add a column to the array      *note: changes the array to a 2 dimensional array" & @CRLF)
;add a column to the array      *note: changes the array to a 2 dimensional array
_ArrayResize($testArray, 0, 1)

; insert some data
$testArray[0][1] = "size"

ShowArray($testArray)

ConsoleWrite(@TAB & @TAB & @TAB & "Fill in some data" & @CRLF)
;insert some data
For $row = 1 To UBound($testArray) - 1
	$testArray[$row][1] = FileGetSize($testArray[$row][0])
Next

ShowArray($testArray)


;===============================================================================
ConsoleWrite("_ArrayResize Example" & @TAB & "add 2 more columns to the array" & @CRLF)
;add 2 more columns to the array
_ArrayResize($testArray, 0, 2)

ConsoleWrite(@TAB & @TAB & @TAB & "Fill in some data" & @CRLF)
;insert some data
$testArray[0][2] = "Attributes"
$testArray[0][3] = "Short Name"

ShowArray($testArray)

ConsoleWrite(@TAB & @TAB & @TAB & "Fill in some data" & @CRLF)
;insert some data
For $row = 1 To UBound($testArray) - 1
	$testArray[$row][2] = FileGetAttrib($testArray[$row][0])
	$testArray[$row][3] = FileGetShortName($testArray[$row][0], 1)
Next

ShowArray($testArray)

;===============================================================================
ConsoleWrite("_ArrayResize Example" & @TAB & "add a row to the array" & @CRLF)
;add a row to the array
_ArrayResize($testArray, 1)

ShowArray($testArray)

ConsoleWrite(@TAB & @TAB & @TAB & "Fill in some data" & @CRLF)
;insert some data
$testArray[0][0] = $testArray[0][0] + 1
For $col = 0 To UBound($testArray, 2) - 1
	$testArray[UBound($testArray, 1) - 1][$col] = $testArray[1][$col]
Next

ShowArray($testArray)

;===============================================================================
ConsoleWrite("_ArrayResize Example" & @TAB & "remove a column from the array" & @CRLF)
;remove a column from the array
_ArrayResize($testArray, 0, -1)

ShowArray($testArray)

;===============================================================================
ConsoleWrite("_ArrayResize Example" & @TAB & "remove a row from the array" & @CRLF)
;remove a row from the array
_ArrayResize($testArray, -1)

ShowArray($testArray)

; get more files to add to array
$testArray2 = _FileListToArray("c:\")
For $row = 1 To UBound($testArray2, 1) - 1
	$testArray2[$row] = "c:\" & $testArray2[$row]
Next
$x = UBound($testArray2, 1) - 1
;===============================================================================
ConsoleWrite("_ArrayResize Example" & @TAB & "add " & $x & " more rows to the array" & @CRLF)
;add x number more rows to the array
_ArrayResize($testArray, $x)

ShowArray($testArray)

ConsoleWrite(@TAB & @TAB & @TAB & "Fill in some data" & @CRLF)
;insert some data
$testArray[0][0] = $testArray[0][0] + $x
For $row2 = 1 To $x
	For $row = 1 To UBound($testArray) - 1
		If $testArray[$row][0] = "" Then
			$testArray[$row][0] = $testArray2[$row2]
			ExitLoop
		EndIf
	Next
Next
For $row = 1 To UBound($testArray) - 1
	$testArray[$row][1] = FileGetSize($testArray[$row][0])
	$testArray[$row][2] = FileGetAttrib($testArray[$row][0])
Next

ShowArray($testArray)


; randomly select some elements for deletion
For $row = 1 To UBound($testArray) - 1
	If Random(1, UBound($testArray) - 1) < ((UBound($testArray) - 1) / 5) And $testArray[$row][0] > "" Then $testArray[$row][0] = ""
Next
;===============================================================================
ConsoleWrite("_ArrayPack Example" & @TAB & "Delete x number rows from the 2-dimensional array. " & @CRLF & @TAB & @TAB & @TAB & "Elements removed determined by having no data stored in the selected index." & _
			@CRLF & @TAB & @TAB & @TAB & "In this case, the selected index is 0." & @CRLF)

;Delete x number rows from the 2-dimensional array.       Elements removed determined by having no data stored in the selected index.          In this case, the selected index is 0
ShowArray($testArray)

$deleted = _ArrayPack($testArray)
ConsoleWrite(@TAB & @TAB & @TAB & "Delete " & $deleted & " elements from the array" & @CRLF)

$testArray[0][0] = $testArray[0][0] - $deleted
ShowArray($testArray)

; randomly select some elements for deletion
For $row = 1 To UBound($testArray) - 1
	If Random(1, UBound($testArray) - 1) < ((UBound($testArray) - 1) / 5) And $testArray[$row][1] > "" Then $testArray[$row][1] = ""
Next
;===============================================================================
ConsoleWrite("_ArrayPack Example" & @TAB & "Delete x number rows from the 2-dimensional array. " & @CRLF & @TAB & @TAB & @TAB & "Elements removed determined by having no data stored in the selected index." & _
			@CRLF & @TAB & @TAB & @TAB & "In this case, the selected index is 1." & @CRLF)

;Delete x number rows from the 2-dimensional array.    Elements removed determined by having no data stored in the selected index.       In this case, the selected index is 1
ShowArray($testArray)

$deleted = _ArrayPack($testArray, 1)
ConsoleWrite(@TAB & @TAB & @TAB & "Delete " & $deleted & " elements from the array" & @CRLF)

$testArray[0][0] = $testArray[0][0] - $deleted
ShowArray($testArray)

;===============================================================================
ConsoleWrite("_ArrayResize Example" & @TAB & "remove 3 rows and 1 column from the array" & @CRLF)
;add x number more rows to the array

_ArrayResize($testArray, -3, -1)

$testArray[0][0] = $testArray[0][0] - 3
ShowArray($testArray)


;===============================================================================
ConsoleWrite("_ArrayResize Example" & @TAB & "change the array back to a 1 demension array by removing the remaining columns" & @CRLF)
;remove a column from the array
_ArrayResize($testArray, 0, -1)

ShowArray($testArray)

; randomly select some elements for deletion
For $row = 1 To UBound($testArray) - 1
	If Random(1, UBound($testArray) - 1) < ((UBound($testArray) - 1) / 5) And $testArray[$row] > "" Then $testArray[$row] = ""
Next
;===============================================================================
ConsoleWrite("_ArrayPack Example" & @TAB & "Delete x number rows from the 1-dimensional array. " & @CRLF & @TAB & @TAB & @TAB & "Elements removed determined by having no data stored in the element." & @CRLF)

;Delete x number rows from the 1-dimensional array.       Elements removed determined by having no data stored in the element
ShowArray($testArray)

$deleted = _ArrayPack($testArray)
ConsoleWrite(@TAB & @TAB & @TAB & "Delete " & $deleted & " elements from the array" & @CRLF)

$testArray[0] = $testArray[0] - $deleted
ShowArray($testArray)

Func ShowArray(ByRef $array)
	$dims = UBound($array, 0)
	$rows = UBound($array)
	$cols = UBound($array, 2)
	If $dims = 1 Then
		$message = "This " & $dims & "-dimensional array has " & $rows & " elements"
		ConsoleWrite(@TAB & @TAB & @TAB & "This " & $dims & "-dimensional array has " & $rows & " elements" & @CRLF & @CRLF)
	EndIf
	If $dims = 2 Then
		$message = "This " & $dims & "-dimensional array has " & $rows & " rows, and " & $cols & " columns"
		ConsoleWrite(@TAB & @TAB & @TAB & "This " & $dims & "-dimensional array has " & $rows & " rows, and " & $cols & " columns" & @CRLF & @CRLF)
	EndIf
	_ArrayDisplay($array, "List of Files - " & " " & $message)
EndFunc


; #FUNCTION# ====================================================================================================================
; Name...........: _ArrayResize
; Description ...: ReDim Array adding or substracting elements/rows and/or columns
; Syntax.........: _ArrayResize(ByRef $avArray [, $cRows = 0[, $cCols = 0]])
; Parameters ....: $avArray  - Array to modify
;                  $cRows - Elements to add or delete     	-x to delete x elements   x to add x elements
;                  $cCols - Columns to add or delete		-x to delete x columns    x to add x columns
; Return values .: Success - 2 element array - first element contains number of elements or rows in new array;
;											   second element contains number of columns in new array
;                  Failure - 0, sets @error to:
;                  |1 - $avArray is not an array
;                  |3 - $avArray has too many dimensions (only up to 2D supported)
;                  |4 - new array would be invalid
;                  |(2 - Deprecated error code)
; Author ........: Ray <ray at stolz dot org>
; Modified.......:
; Remarks .......: Elements/Rows and Columns are added to or deleted from the end of the array.
;+
;
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _ArrayResize(ByRef $avArray, $cRows = 1, $cCols = 0)
	If Not IsArray($avArray) Then Return SetError(1, 0, 0)

	Local $dims = UBound($avArray, 0)
	Local $rows = UBound($avArray, 1)
	Local $cols = UBound($avArray, 2)
	local $elements[2]
	If $rows + $cRows <= 0 Or $cols + $cCols < 0 Then
		Return SetError(4, 0, 0)
	EndIf
	If $cols = 0 Then $cols = 1

	Switch $dims
		Case 1
			If $cCols > 0 Then
				Dim $tArray[$rows + $cRows][$cols + $cCols]
				For $r = 0 To $rows - 1
					$tArray[$r][0] = $avArray[$r]
				Next
				ReDim $avArray[UBound($tArray)][UBound($tArray, 2)]
				For $r = 0 To $rows - 1
					$avArray[$r][0] = $tArray[$r][0]
				Next
			Else
				ReDim $avArray[$rows + $cRows]
			EndIf
			$elements[0] = UBound($avArray, 1)
			$elements[1] = UBound($avArray, 2)
			Return $elements

		Case 2
			If $cols + $cCols = 1 Then
				$tArray = $avArray
				ReDim $avArray[$rows + $cRows]
				For $r = 0 To UBound($tArray, 1) - 1
					$avArray[$r] = $tArray[$r][0]
				Next
				Return
			Else
				ReDim $avArray[$rows + $cRows][$cols + $cCols]
			EndIf
			$elements[0] = UBound($avArray, 1)
			$elements[1] = UBound($avArray, 2)
			Return $elements
		Case Else
			Return SetError(3, 0, 0)
	EndSwitch
EndFunc

; #FUNCTION# ====================================================================================================================
; Name...........: _ArrayPack
; Description ...: ReDim Array adding or substracting elements/rows and/or columns
; Syntax.........: _ArrayPack(ByRef $avArray, $iCol = 0)
; Parameters ....: $avArray  - Array to modify
;                  $iCol - Column used as index for rows to be deleted		if contents of index is empty then row is deleted
; Return values .: Success - Number of elements removed
;                  Failure - 0, sets @error to:
;                  |1 - $avArray is not an array
;                  |3 - $avArray has too many dimensions (only up to 2D supported)
;                  |(2 - Deprecated error code)
;                  |4 - invalid index
; Author ........: Ray <ray at stolz dot org>
; Modified.......:
; Remarks .......:
;+
;
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _ArrayPack(ByRef $avArray, $iCol = 0)
	If Not IsArray($avArray) Then Return SetError(1, 0, 0)

	Local $dims = UBound($avArray, 0)
	Local $rows = UBound($avArray, 1)
	Local $cols = UBound($avArray, 2)
	If $cols = 0 Then $cols = 1

	Local $keep[$rows]
	Local $pointer = 1
	Local $row = 0

	Switch $dims
		Case 1
			For $r = 0 To $rows - 1
				If	$avArray[$r] <> "" Then
					$keep[$pointer] = $r
					$pointer = $pointer + 1
					$keep[0] = $keep[0] + 1
				EndIf
			Next
			$pointer = 1
				For $pointer = 1 To $keep[0]
					$avArray[$row] = $avArray[$keep[$pointer]]
					$row = $row + 1
					If $row = $rows - 1 Then ExitLoop
				Next
		Case 2
			; find number of records to be deleted
			For $r = 0 To $rows - 1
				If	$avArray[$r][$iCol] <> "" Then
					$keep[$pointer] = $r
					$pointer = $pointer + 1
					$keep[0] = $keep[0] + 1
				EndIf
			Next
			$pointer = 1
				For $pointer = 1 To $keep[0]
					For $c = 0 To $cols - 1
						$avArray[$row][$c] = $avArray[$keep[$pointer]][$c]
					Next
					$row = $row + 1
					If $row = $rows - 1 Then ExitLoop
				Next
		Case Else
			Return SetError(3, 0, 0)
	EndSwitch
	$remove = $rows - $keep[0]
	_ArrayResize($avArray, (0 - $remove))
	Return $remove
EndFunc







