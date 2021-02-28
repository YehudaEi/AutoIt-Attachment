#include-Once
#include <Array.au3>

#cs
	From function _ArrayInsert in AutoIt array.au3 marked as AutoIt Version 3.2.10++, file dated 12/23/08 06:10
	
#ce


; #INTERNAL_USE_ONLY# ====================================================================================================================
; Name...........: __ArrayInsert2d
; Description ...: Add a new value or 2-dimensional array at the specified position.
; Syntax.........: __ArrayInsert2d(ByRef $avArray, $iElement[, $vValue = ""])
; Parameters ....: $avArray  - Array to modify
;                  $iElement - Position to insert item at
;                  $vValue   - A 2d array to insert.
; Return values .: Success - New size of the array
;                  Failure - 0, sets @error
;                  |1 - $avArray is not an array
;                  |2 - $avArray is not a 2 dimensional array
;                  |3 $vValue is not a 2-dimensional array
; Author ........: Jos van der Zande <jdeb at autoitscript dot com>
; Modified.......: Ultima - code cleanup
;                  GaryC - $vValue can be an array, $iElement can be 1 past the end of the array in which case _ArrayAdd or _ArrayConcatenate is called.
; Remarks .......:
; Related .......: _ArrayAdd, _ArrayDelete, _ArrayPop, _ArrayPush
; Link ..........;
; Example .......; Yes
; ===============================================================================================================================
Func __ArrayInsert2d(ByRef $avArray, $iElement, ByRef Const $vValue)
	;DbgMsg("Enter __ArrayInsert2d: dimensions of $gaNodes are " & UBound($gaNodes, 1) & ", " & UBound($gaNodes, 2))   ; debug
	Local $iUBound2 = UBound($avArray, 2)
	Local $iUBound2b = UBound($vValue, 2)
	Local $iUBound2Min = $iUBound2
	If $iUBound2b < $iUBound2 Then $iUBound2Min = $iUBound2b
	Local $iOffset = UBound($vValue)
	; Increase the array's size.
	Local $iUBound = UBound($avArray) + $iOffset
	ReDim $avArray[$iUBound][UBound($avArray, 2)]
	If $iElement + $iOffset <= $iUBound - 1 Then
		; Move all entries over til the specified element
		;DbgMsg("My__ArrayInsert2d: moving: $iElement = " & $iElement & ", $iOffset = " & $iOffset & ", $avArray[" & UBound($avArray, 1) & "," & UBound($avArray, 2) & "], $vValue[" & UBound($vValue, 1) & "," & UBound($vValue, 2) & "]")   ; debug
		;DbgMsg("for $i=" & $iUBound - 1 & " to " & $iElement + $iOffset & " step -1, $j = 0 to " & $iUBound2 - 1)   ; debug
		For $i = $iUBound - 1 To $iElement + $iOffset Step -1
			For $j = 0 To $iUBound2 - 1
				;DbgMsg("$i=" & $i & ", $j=" & $j)   ; debug
				$avArray[$i][$j] = $avArray[$i - $iOffset][$j]
			Next ; $j
		Next ; $i
	EndIf ; move
	; Add the value in the specified element
	For $i = 0 To $iOffset - 1

		For $j = 0 To $iUBound2Min - 1
			$avArray[$iElement + $i][$j] = $vValue[$i][$j]
		Next ; $j
		If $iUBound2Min < $iUBound2 Then
			; Inserted array 2nd dimension is smaller, fill extra elements with 0.
			For $j = $iUBound2Min To $iUBound2 - 1
				$avArray[$iElement + $i][$j] = 0
			Next ; $j
		EndIf ; if $iUBound2Min < $iUBound2
	Next ; $i
	;DbgMsg("Exit __ArrayInsert2d: dimensions of $gaNodes are " & UBound($gaNodes, 1) & ", " & UBound($gaNodes, 2))   ; debug
	Return $iUBound
EndFunc   ;==>__ArrayInsert2d

; From function _ArrayInsert in AutoIt array.au3 marked as AutoIt Version 3.2.10++, file dated 12/23/08 06:10
; #FUNCTION# ====================================================================================================================
; Name...........: MyArrayInsert
; Description ...: Add a new value or 1 or 2-dimensional array at the specified position.
; Syntax.........: MyArrayInsert(ByRef $avArray, $iElement[, $vValue = ""])
; Parameters ....: $avArray  - Array to modify
;                  $iElement - Position in $avArray to insert item at.  Can be 1 past the last element to append to the array.
;                  $vValue   - [optional] Value of item to insert, if a 1 or 2-demensional array, all elements are inserted.  If $vValue is an array it must have the same number of dimensions as $avArray.
; Return values .: Success - New size of the array
;                  Failure - 0, sets @error
;                  |1 - $avArray is not an array
;                  |2 - $avArray is not a 1 or 2 dimensional array
;                  |3 $vValue has more than 2 dimensions
;                  |4 The number of dimensions of $avArray and $vValue are not equal
; Author ........: Jos van der Zande <jdeb at autoitscript dot com>
; Modified.......: Ultima - code cleanup
;                  GaryC - $vValue can be an array, $iElement can be 1 past the end of the array.
; Remarks .......: If $avArray is a 2-dimensional array and $vValue is not an array then $vValue is stored at $avArray[$iElement][0].
; Related .......: _ArrayAdd, _ArrayDelete, _ArrayPop, _ArrayPush
; Link ..........;
; Example .......; Yes
; ===============================================================================================================================
Func MyArrayInsert(ByRef $avArray, $iElement, ByRef Const $vValue)
	If Not IsArray($avArray) Then Return SetError(1, 0, 0)
	If UBound($avArray, 0) > 2 Then Return SetError(2, 0, 0)

	If IsArray($vValue) And UBound($vValue, 0) > 2 Then Return SetError(3, 0, 0)
	; We're rid of the obvious problems.
	If IsArray($vValue) Then
		If UBound($avArray, 0) <> UBound($vValue, 0) Then Return SetError(4, 0, 0)

		;DbgMsg("MyArrayInsert: Before calling __ArrayInsert2d UBound($vValue, 0) = " & UBound($vValue, 0))   ; debug
		; $avArray and $vValue are both arrays with the same number of dimensions.
		;If UBound($vValue, 0) == 2 Then
		If UBound($avArray, 0) == 2 Then
			Return __ArrayInsert2d($avArray, $iElement, $vValue)
			;EndIf ; if $vValue is 2d
		EndIf ; if $avArray is 2d
	EndIf ; IsArray($vValue)
	#cs
		If $iElement == UBound($avArray) Then
		; concatenate
		If IsArray($vValue) Then
		_ArrayConcatenate($avArray, $vValue)
		Else
		_ArrayAdd($avArray, $vValue)
		EndIf
		Return UBound($avArray)
		EndIf ; at end
	#ce

	; If $vValue is an array then both $avArray and $vValue are 1-dimensional.  If $vValue is a scalar then $avArray could be 2-dimensional.
	Local $iOffset = 1
	If IsArray($vValue) Then $iOffset = UBound($vValue)
	; Increase the array's size.
	Local $iUBound = UBound($avArray) + $iOffset
	If UBound($avArray, 0) = 2 Then
		ReDim $avArray[$iUBound][UBound($avArray, 2)]
	Else
		ReDim $avArray[$iUBound]
	EndIf ; else $avArray not 2d

	If $iUBound - $iOffset > $iElement Then
		; Move all entries over til the specified element
		If UBound($avArray, 0) = 2 Then
			For $i = $iUBound - 1 To $iElement + $iOffset Step -1
				For $j = 0 To UBound($avArray, 2) - 1
					$avArray[$i][$j] = $avArray[$i - $iOffset][$j]
				Next ; $j
			Next ; $i
		Else
			; 1d
			For $i = $iUBound - 1 To $iElement + $iOffset Step -1
				$avArray[$i] = $avArray[$i - $iOffset]
			Next ; $i
		EndIf ; else 1d
	EndIf ; not appending

	; Add the value in the specified element
	If IsArray($vValue) Then
		If UBound($avArray, 0) = 2 Then
			; The current constraint that the two arrays have the same number of dimensions and that 2d $avArray is handled by __ArrayInsert2d mean that we should not get here.
			For $i = 0 To $iOffset - 1
				$avArray[$iElement + $i][0] = $vValue[$i]
				For $j = 0 To UBound($avArray, 2) - 1
					$avArray[$i][$j] = 0
				Next ; $j
			Next ; $i
		Else
			; $avArray is 1d
			For $i = 0 To $iOffset - 1
				$avArray[$iElement + $i] = $vValue[$i]
			Next ; $i
		EndIf ; else $avArray is 1d
	Else
		; $vValue is a single value.
		If UBound($avArray, 2) = 2 Then
			$avArray[$iElement][0] = $vValue
			For $j = 1 To UBound($avArray, 2) - 1
				$avArray[$iElement][$j] = 0
			Next ; $j
		Else
			; $avArray is 1d
			$avArray[$iElement] = $vValue
		EndIf ; else 1d
	EndIf ; else single value
	Return $iUBound
EndFunc   ;==>MyArrayInsert

; #FUNCTION# ====================================================================================================================
; Name...........: MyArrayBinarySearch
; Description ...: Uses the binary search algorithm to search through a 1 or 2-dimensional array.
; Syntax.........: MyArrayBinarySearch(Const ByRef $avArray, $vValue[, $iStart = 0[, $iEnd = 0[, $fReturnMid=False[, $iCol=0]]]])
; Parameters ....: $avArray    - Array to search
;                  $vValue     - Value to find
;                  $iStart     - [optional] Index (first dimension) of array to start searching at
;                  $iEnd       - [optional] Index (first dimension) of array to stop searching at
;                  $fReturnMid - [optional] If true then if value not found the position of element before which to insert value is returned instead of -1, default False.
;                  $iCol - [optional] for a 2-dimensional array the index of the second dimension to search, default 0.
; Return values .: Success - Index that value was found at
;                  Failure - -1 or index to insert value if $fReturnMid is Ttrue, sets @error to:
;                  |1 - $avArray is not an array
;                  |2 - $vValue outside of array's (or specified column's) min/max values.  If $fReturnMid is True then returns $iStart if $vValue
;                       < min array value and $iEnd+1 if > max array value.
;                  |3 - $vValue was not found in array
;                  |4 - $iStart is greater than $iEnd
;                  |5 - $avArray is not a 1 or 2 dimensional array
; Author ........: Jos van der Zande <jdeb at autoitscript dot com>
; Modified.......: Ultima - added $iEnd as parameter, code cleanup
;                  GaryC - Added optional parm $fReturnMid to cause index to insert value to be returned if item not found.
;                  GaryC - Added support for 2d arrays, added optional parm $iCol for 2nd dimension index.
; Remarks .......: When performing a binary search on an array of items, the contents of the column to be searched MUST be sorted before the search is done.
;                  Otherwise undefined results will be returned.
; Related .......: _ArrayFindAll, _ArraySearch
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func MyArrayBinarySearch(Const ByRef $avArray, $vValue, $iStart = 0, $iEnd = 0, $fReturnMid = False, $iCol = 0)
	;DbgMsg("MyArrayBinarySearch: $fReturnMid = " & $fReturnMid)   ; debug
	If Not IsArray($avArray) Then Return SetError(1, 0, -1)
	Local $iCols = UBound($avArray, 0)
	;DbgMsg("MyArrayBinarySearch: $iCols = " & $iCols) ; debug
	If $iCols > 2 Then Return SetError(5, 0, -1)

	Local $iUBound = UBound($avArray) - 1 ; index of last array value

	; Bounds checking
	If $iEnd < 1 Or $iEnd > $iUBound Then $iEnd = $iUBound
	If $iStart < 0 Then $iStart = 0
	If $iStart > $iEnd Then Return SetError(4, 0, -1)
	Local $iRtn
	If $iCols = 1 Then
		$iRtn = __ArrayBinarySearch1D($avArray, $vValue, $iStart, $iEnd, $fReturnMid)
	Else
		$iRtn = __ArrayBinarySearch2D($avArray, $vValue, $iStart, $iEnd, $fReturnMid, $iCol)
	EndIf
	If @error Then Return SetError(@error, 0, $iRtn)
	Return $iRtn
EndFunc   ;==>MyArrayBinarySearch

; #INTERNAL_USE_ONLY# ====================================================================================================================
; Name...........: __ArrayBinarySearch1D
; Description ...: Helper function to do binary search on a 1-dimensional array.
; Syntax.........: MyArrayBinarySearch(Const ByRef $avArray, $vValue[, $iStart = 0[, $iEnd = 0[, $fReturnMid=False]]])
; Parameters ....: $avArray    - Array to search
;                  $vValue     - Value to find
;                  $iStart     - [optional] Index (first dimension) of array to start searching at
;                  $iEnd       - [optional] Index (first dimension) of array to stop searching at
;                  $fReturnMid - [optional] If true then if value not found the position of element before which to insert value is returned instead of -1, default False.
; Return values .: Success - Index that value was found at
;                  Failure - -1 or index to insert value if $fReturnMid is Ttrue, sets @error to:
;                  |2 - $vValue outside of array's min/max values.  If $fReturnMid is True then returns $iStart if $vValue
;                       < min array value and $iEnd+1 if > max array value.
;                  |3 - $vValue was not found in array
; Author ........: Jos van der Zande <jdeb at autoitscript dot com>
; Modified.......: Ultima - added $iEnd as parameter, code cleanup
;                  GaryC - Added optional parm $fReturnMid to cause index to insert value to be returned if item not found.
; Remarks .......: Internal use only.
; Related .......: _ArrayFindAll, _ArraySearch, _ArrayBinarySearch, _ArrayBinarySearch2D
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func __ArrayBinarySearch1D(Const ByRef $avArray, $vValue, $iStart = 0, $iEnd = 0, $fReturnMid = False)
	;DbgMsg("Enter __ArrayBinarySearch1D: $iStart = " & $iStart & ", $iEnd = " & $iEnd) ; debug
	Local $iMid = Int(($iEnd + $iStart) / 2)

	If $fReturnMid Then
		If $avArray[$iStart] > $vValue Then
			;DbgMsg("__ArrayBinarySearch1D: $avArray[" & $iStart & "]  " & $avArray[$iStart] & " > $vValue " & $vValue & ", setting error 2 and returning " & $iStart) ; debug
			Return SetError(2, 0, $iStart)
		EndIf ; if $avArray[$iStart] > $vValue
		If $avArray[$iEnd] < $vValue Then
			;DbgMsg("$avArray[" & $iEnd & "]  " & $avArray[$iEnd]  & " < $vValue " & $vValue & ", setting error 2 and returning " & $iEnd + 1) ; debug
			Return SetError(2, 0, $iEnd + 1)
		EndIf

	Else
		; not $fReturnMid
		If $avArray[$iStart] > $vValue Or $avArray[$iEnd] < $vValue Then
			;DbgMsg("__ArrayBinarySearch1D: start value = " & $avArray[$iStart]  & ", end value = " & $avArray[$iEnd] & ", $vValue = " & $vValue & ", setting error 2 and returning -1") ; debug
			Return SetError(2, 0, -1)
		EndIf ; if error
	EndIf ; else not $fReturnMid

	; Search
	While $iStart <= $iMid And $vValue <> $avArray[$iMid]
		If $vValue < $avArray[$iMid] Then
			$iEnd = $iMid - 1
		Else
			$iStart = $iMid + 1
		EndIf
		$iMid = Int(($iEnd + $iStart) / 2)
	WEnd

	If $fReturnMid Then
		Local $iRtn = $iMid + 1
		;DbgMsg("__ArrayBinarySearch1D: $iStart = " & $iStart & ", $iEnd = " & $iEnd & ", returning $iMid + 1 = " & $iRtn)   ; debug
	Else
		; not $fReturnMid
		;DbgMsg("__ArrayBinarySearch1D: $fReturnMid is false returning -1")   ; debug
		$iRtn = -1
	EndIf ; else not $fReturnMid
	If $iStart > $iEnd Then Return SetError(3, 0, $iRtn) ; Entry not found

	Return $iMid
EndFunc   ;==>__ArrayBinarySearch1D

; #INTERNAL_USE_ONLY# ====================================================================================================================
; Name...........: __ArrayBinarySearch2D
; Description ...: Helper function to do binary search algorithm on a 2-dimensional array.
; Syntax.........: MyArrayBinarySearch(Const ByRef $avArray, $vValue[, $iStart = 0[, $iEnd = 0[, $fReturnMid=False[, $iCol=0]]]])
; Parameters ....: $avArray    - Array to search
;                  $vValue     - Value to find
;                  $iStart     - [optional] Index (first dimension) of array to start searching at
;                  $iEnd       - [optional] Index (first dimension) of array to stop searching at
;                  $fReturnMid - [optional] If true then if value not found the position of element before which to insert value is returned instead of -1, default False.
;                  $iCol - [optional] for a 2-dimensional array the index of the second dimension to search, default 0.
; Return values .: Success - Index that value was found at
;                  Failure - -1 or index to insert value if $fReturnMid is Ttrue, sets @error to:
;                  |2 - $vValue outside of array's (or specified column's) min/max values.  If $fReturnMid is True then returns $iStart if $vValue
;                       < min array value and $iEnd+1 if > max array value.
;                  |3 - $vValue was not found in array
; Author ........: Jos van der Zande <jdeb at autoitscript dot com>
; Modified.......: Ultima - added $iEnd as parameter, code cleanup
;                  GaryC - Added optional parm $fReturnMid to cause index to insert value to be returned if item not found.
;                  GaryC - Added support for 2d arrays, added optional parm $iCol for 2nd dimension index.
; Remarks .......: For internal use only.
; Related .......: _ArrayFindAll, _ArraySearch, _ArrayBinarySearch, _ArrayBinarySearch1D
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func __ArrayBinarySearch2D(Const ByRef $avArray, $vValue, $iStart = 0, $iEnd = 0, $fReturnMid = False, $iCol = 0)
	Local $iMid = Int(($iEnd + $iStart) / 2)

	If $fReturnMid Then
		If $avArray[$iStart][$iCol] > $vValue Then Return SetError(2, 0, $iStart)
		If $avArray[$iEnd][$iCol] < $vValue Then Return SetError(2, 0, $iEnd + 1)

	Else
		If $avArray[$iStart][$iCol] > $vValue Or $avArray[$iEnd][$iCol] < $vValue Then Return SetError(2, 0, -1)

	EndIf ; else not $fReturnMid
	; Search
	While $iStart <= $iMid And $vValue <> $avArray[$iMid][$iCol]
		If $vValue < $avArray[$iMid][$iCol] Then
			$iEnd = $iMid - 1
		Else
			$iStart = $iMid + 1
		EndIf
		$iMid = Int(($iEnd + $iStart) / 2)
	WEnd

	If $fReturnMid Then
		Local $iRtn = $iMid + 1
		;DbgMsg("__ArrayBinarySearch2D: $iStart = " & $iStart & ", $iEnd = " & $iEnd & ", returning $iMid + 1 = " & $iRtn)   ; debug
	Else
		;DbgMsg("__ArrayBinarySearch2D: $fReturnMid is false returning -1")   ; debug
		$iRtn = -1
	EndIf
	If $iStart > $iEnd Then Return SetError(3, 0, $iRtn) ; Entry not found

	Return $iMid
EndFunc   ;==>__ArrayBinarySearch2D

; Synonym for MyArrayAdd to match my old code.
Func MyAddArray(ByRef $avArray, $vValue)
	MyArrayAdd($avArray, $vValue)
EndFunc   ;==>MyAddArray

; If array exists calls _ArrayAdd.  If it does not exist (is not an array), c`reates an array containing the element.
Func MyArrayAdd(ByRef $avArray, $vValue)
	If IsArray($avArray) Then
		Return _ArrayAdd($avArray, $vValue)
	EndIf
	; $avArray is not an array, create it.
	Local $aTmp[1]
	$aTmp[0] = $vValue
	$avArray = $aTmp
	Return UBound($avArray)
EndFunc   ;==>MyArrayAdd

; Same as _Arraypop except it can receive a count of items to pop.
; $iCount - [Optional]Number of items to pop.  The last one popped is returned.  (Default 1).
; It is roughly equivalent to:
;   for $i=1 to $iCount - 1
;     _ArrayPop($avArray)
;   Next
;   Return _ArrayPop($avArray)
; Does the same error checking that _ArrayPop does and adds error 3, stack underflow.
Func MyArrayPop(ByRef $avArray, $iCount = 1)
	If Not IsArray($avArray) Then Return SetError(1, 0, "")
	If UBound($avArray, 0) <> 1 Then Return SetError(2, 0, "")

	If UBound($avArray) < $iCount Then
		; Stack underflow.
		$avArray = ""
		Return SetError(3, 0, "")
	EndIf ; stack underflow

	Local $iUBound = UBound($avArray) - $iCount, $sLastVal = $avArray[$iUBound]

	; Remove last item(s)
	If $iUBound <= 0 Then
		$avArray = "" ; should already be taken care of
	Else
		ReDim $avArray[$iUBound]
	EndIf

	; Return last item
	Return $sLastVal
EndFunc   ;==>MyArrayPop

#region testArrayInsert
; Moved outside of commenting out of tests because it is used for debugging elsewhere in ccousins.au3.
; $iStart - d1 index to start displaying
; $iEnd - last d1 index to display
; If $iStart < 0 0 is used, if iEnd > UBound($a,1) UBound is used, otherwise no checking of $iStart and $iEnd is done.  If $iEnd = 0 then it is set to UBound($a, 1) - 1.
Func Display2D(Const ByRef $a, $iStart = 0, $iEnd = 0)
	Local $s = ""
	If $iStart < 0 Then $iStart = 0
	If $iEnd >= UBound($a, 1) Then $iEnd = UBound($a, 1) - 1
	For $i = $iStart To $iEnd
		If $i > $iStart Then $s &= ", "
		$s &= "["
		For $j = 0 To UBound($a, 2) - 1

			If $j > 0 Then $s &= ", "
			$s &= $a[$i][$j]
		Next ; $j
		$s &= "]"
	Next ; $i
	Return $s
EndFunc   ;==>Display2D

#cs
; There are calls to these functions at the end of the file, so you can test by putting ; in front of the cs and ce lines and commenting or uncommenting the desired calls.

Func TestArrayInsert()
	Local $a1d1[5] = [1, 2, 3, 4, 5]
	Local $a1d2[5] = [21, 22, 23, 24, 25]
	Local $a2d1[5][2] = [[1, 1],[2, 2],[3, 3],[4, 4],[5, 5]]
	Local $a2d2[3][2] = [[21, 1],[22, 2],[23, 3]]
	Local $a2d3[3][1] = [[21],[22],[23]]
	Local $a2d4[5][3] = [[1, 1, 1],[2, 2, 2],[3, 3, 3],[4, 4, 4],[5, 5, 5]]
	Local $a = $a1d1
	MyArrayInsert($a, 2, $a1d2)

	InfoMsg("testArrayInsert: $a1d1 = " & _ArrayToString($a1d1, ", "))
	InfoMsg("$a1d2 = " & _ArrayToString($a1d2, ", "))
	InfoMsg("insert($a1d1, 2, $a1d2) = " & _ArrayToString($a, ", "))
	$a = $a1d1
	; Insert at end.
	MyArrayInsert($a, 5, $a1d2)
	InfoMsg("insert at end($a1d1, 5, $a1d2) = " & _ArrayToString($a, ", "))
	$a = $a1d1
	; Insert at start.
	MyArrayInsert($a, 0, $a1d2)
	InfoMsg("insert at start($a1d1, 0, $a1d2) = " & _ArrayToString($a, ", "))
	$a = $a1d1
	; Insert a number at 1.
	MyArrayInsert($a, 1, 6)
	$a = $a1d1
	MyArrayInsert($a, 5, 6)
	InfoMsg("append 6 to $a1d1 = " & _ArrayToString($a, ","))
	$a = $a1d1
	MyArrayInsert($a, 4, 6)
	InfoMsg("Inserting before last element = " & _ArrayToString($a, ","))
	InfoMsg("insert($a1d1, 1, 6) = " & _ArrayToString($a, ", "))

	InfoMsg("$a2d1 = " & Display2D($a2d1))
	InfoMsg("$a2d2 = " & Display2D($a2d2))
	$a = $a2d1

	MyArrayInsert($a, 2, $a2d2)
	InfoMsg("insert($a2d1, 2, $a2d2) = " & Display2D($a))
	$a = $a2d1
	; Insert at end.
	MyArrayInsert($a, 5, $a2d2)
	InfoMsg("insert at end($a2d1, 5, $a2d2) = " & Display2D($a))
	$a = $a2d1
	; Insert at start.
	MyArrayInsert($a, 0, $a2d2)
	InfoMsg("insert at start($a2d1, 0, $a2d2) = " & Display2D($a))
	$a = $a2d1
	; Insert before last element.
	MyArrayInsert($a, 4, $a2d2)
	InfoMsg("insert before last($a2d1, 4, $a2d2) = " & Display2D($a))
	InfoMsg("$a2d3 = " & Display2D($a2d3))

	; Test inserting a narrower array into a wider one.
	; Insert before last element.
	$a = $a2d1
	MyArrayInsert($a, 4, $a2d3)
	InfoMsg("insert before last($a2d1, 4, $a2d3) = " & Display2D($a))
	InfoMsg("$a2d4 = " & Display2D($a2d4))
	$a = $a2d4
	; Insert before last element.
	MyArrayInsert($a, 4, $a2d2)
	InfoMsg("insert before last($a2d4, 4, $a2d2) = " & Display2D($a))

	; Test inserting a number into a 2d array.
	; Insert before last element.
	$a = $a2d1
	MyArrayInsert($a, 4, 6)
	InfoMsg("insert before last($a2d1, 4, 6) = " & Display2D($a))
	; Insert after last element.
	$a = $a2d1
	MyArrayInsert($a, 5, 6)
	InfoMsg("append($a2d1, 5, 6) = " & Display2D($a))

	;InfoMsg("Testing inserting a 1d array into a 2d array")
	;$a = $a2d1
	;$rtn = MyArrayInsert($a, 4, $a1d2)
	;If @error Then InfoMsg("@error = " & @error & ", return was " & $rtn)
	;InfoMsg("After Insert($a2d1, 4, $a1d2) = " & Display2D($a))
	;
	;$a = $a2d1
	;$rtn = MyArrayInsert($a, 5, $a1d2)
	;If @error Then InfoMsg("@error = " & @error & ", return was " & $rtn)
	;InfoMsg("After Insert at end($a2d1, 5, $a1d2) = " & Display2D($a))
EndFunc   ;==>TestArrayInsert

; Test behavior of myArrayBinarySearch WrT insertion point for new items.
Func TestMyArrayBinarySearch()
	InfoMsg(@CRLF & "Testing MyArrayBinarySearch:" & @CRLF & _
			"(We search for a character and add it if not found.  The result" & @CRLF & _
			"array initially contains the first character.  The result should be sorted in ascending order.)")
	Local $a = TstArrayBinSearch("abcdefg")
	InfoMsg("Result is " & _ArrayToString($a, "") & ", UBound " & UBound($a))
	$a = TstArrayBinSearch("mnobdfrqpcea")
	InfoMsg("Result is " & _ArrayToString($a, "") & ", UBound " & UBound($a))

	; test 2d
	InfoMsg("Testing with 2D array")
	Local $d2[5][2] = [["", "a"],["", "b"],["", "c"],["", "d"],["", "e"]]
	Local $iRtn = MyArrayBinarySearch($d2, "c", 0, 0, False, 1)
	InfoMsg("Testing 2d: c in abcde in 2nd column should be at 2 and is at " & $iRtn)
EndFunc   ;==>TestMyArrayBinarySearch

; This receives a string of sorted letters which it uses to generate an array of test values.  It bulilds a test array containing the first element.  It then searches for each letter in the arg, inserting it if not found.  It returns the test array.
Func TstArrayBinSearch(ByRef $sArg)
	InfoMsg("TstArrayBinSearch: Working with array with elements " & $sArg)
	Local $d1 = StringSplit($sArg, "", 2)
	Local $a[1], $fFirstTime = True
	For $s In $d1
		If $fFirstTime = 1 Then
			$a[0] = $s
			$fFirstTime = False
			ContinueLoop
		EndIf
		Local $iRtn = MyArrayBinarySearch($a, $s, 0, 0, True)
		If @error Then
			Local $iError = @error
			If $iError <> 3 And $iError <> 2 Then
				InfoMsg("TstArrayBinSearch: MyArrayBinarySearch returned error " & $iError)
				ContinueLoop
			EndIf ; if @error <> 2 and @error <> 3
			;InfoMsg("TstArrayBinSearch: inserting " & $s & " at location " & $iRtn & ", UBound($a) =" & UBound($a))   ; debug
			MyArrayInsert($a, $iRtn, $s)
		Else
			; Found (not @error
			InfoMsg("TstArrayBinSearch: @error = " & @error & ", Found " & $s & " at " & $iRtn)
		EndIf ; else found
	Next ; $s
	Return $a
EndFunc   ;==>TstArrayBinSearch

Func DbgMsg($s)
	InfoMsg($s)
EndFunc   ;==>DbgMsg
Func InfoMsg($s)
	ConsoleWrite($s & @CRLF)
EndFunc   ;==>InfoMsg

TestArrayInsert()
TestMyArrayBinarySearch()
#ce
#endregion testArrayInsert