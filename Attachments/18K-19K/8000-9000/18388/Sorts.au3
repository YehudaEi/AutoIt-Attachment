#cs ----------------------------------------------------------------------------
	
	AutoIt Version: 3.2.10.0
	Language:       English
	Author:         "Nutster" David Nuttall
	
	Description:    Sorting functions.
	
#ce ----------------------------------------------------------------------------

#Tidy_parameters /proper /var 3 /tabchar 0 /kv 5

#include-once

#comments-start
	Here is a set of sorting functions.  All use the same interface:
	- An array passed by reference which gets sorted.
	- An optional parameter that says whether to skip the first element (for arrays created with StringSplit, etc.)
	Returns true if the sort finished properly.  Returns false and sets @Error if an error occured.
	@Error = 1 if the first parameter is not actually an array
	@Error = 2 if the first parameter is an array, but has more than one dimension.
	@Error = 3 if the second paramenter is not boolean
	If the array stores the number of elements in element 0, Set the optional parameter to True.
#comments-end

;=============================================================================
;
; Function Name:	_Sort_Bozo()
;
; Description:		Performs a bozo sort on the given array.
;
; Syntax:			_Sort_Bozo(ByRef $aValues, Const $bSkipFirst = False)
;
; Parameter(s):		$aValues = Array of values to be sorted.
;					$bSkipFirst = (Optional) Skip the first element of the array if it not part of the values to be sorted.
;
; Requirement(s):	External:   = None.
;					Internal:   = None.
;
; Return Value(s):	On Success: = Returns True and the array will be sorted.
;					On Failure: = Sets @Error and returns False.
;					@ERROR:     = 0 = No error.
;                                1 = The first parameter is not actually an array.
;                                2 = The first parameter is an array, but has more than one dimension.
;								 3 = The second paramenter is not boolean.
;
; Author(s):		"Nutster" David Nuttall <danuttall at rocketmail dot com>
;
; Notes:			- If the array stores the number of elements in element 0, set the second parameter to True.
;				   	- All the values in the array should be the same internal type.  Inconsistant
;					conversion from string to numerics can occur, causing unexpected orderings.
;					- The bozo sort is a very poor sort, generally used only to show what not to do
;					when sorting.  It scans the array to find if any elements are out of sequence.  If there are,
;					swap any two elements at random and try again.
;
; Example(s):
;   Local $aNums[100], $I, $sMsg
;
;   For $I = 0 To 99
;      $aNums[$I] = Random(1, 1000, True)
;   Next
;   _Sort_Bozo($aNums)
;   $sMsg = $aNums[0]
;   For $I = 1 To 99
;      $sMsg &= ", " & $aNums[$I]
;   Next
;   MsgBox(48, "Sort Test", $sMsg)
;
;=============================================================================
Func _Sort_Bozo(ByRef $aValues, Const $bSkipFirst = False)
	If Not IsArray($aValues) Then ;Make sure that it is an array
		SetError(1)
		Return False
	ElseIf UBound($aValues, 0) <> 1 Then ;Make sure that it is single dimensioned
		SetError(2)
		Return False
	ElseIf Not IsBool($bSkipFirst) Then
		SetError(3)
		Return False
	EndIf
	; Passed all those tests
	; Actual optimized bozo sort
	Local $nStart = 0
	Local $I, $K, $bSorted
	
	If $bSkipFirst Then $nStart = 1
	
	While 1
		$bSorted = True
		For $I = $nStart To UBound($aValues) - 2
			If $aValues[$I] > $aValues[$I + 1] Then
				; Out of sequence.
				$bSorted = False
				ExitLoop
			EndIf
		Next
		If $bSorted Then
			; Yeah!  The list is sorted.
			ExitLoop
		Else
			; Try switching two elements and see if that helps.
			Do
				; Find two elements to swap
				$I = Random($nStart, UBound($aValues) - 1, 1)
				$K = Random($nStart, UBound($aValues) - 1, 1)
			Until $I <> $K
			; And swap them.
			Swap($aValues[$I], $aValues[$K])
		EndIf
	WEnd
	Return True
EndFunc   ;==>_Sort_Bozo

;=============================================================================
;
; Function Name:	_Sort_OptBozo()
;
; Description:		Performs an optimized bozo sort on the given array.
;
; Syntax:			_Sort_OptBozo(ByRef $aValues, Const $bSkipFirst = False)
;
; Parameter(s):		$aValues = Array of values to be sorted.
;					$bSkipFirst = (Optional) Skip the first element of the array if it not part of the values to be sorted.
;
; Requirement(s):	External:   = None.
;					Internal:   = None.
;
; Return Value(s):	On Success: = Returns True and the array will be sorted.
;					On Failure: = Sets @Error and returns False.
;					@ERROR:     = 0 = No error.
;                                1 = The first parameter is not actually an array.
;                                2 = The first parameter is an array, but has more than one dimension.
;								 3 = The second paramenter is not boolean.
;
; Author(s):		"Nutster" David Nuttall <danuttall at rocketmail dot com>
;
; Notes:			- If the array stores the number of elements in element 0, set the second parameter to True.
;				   	- All the values in the array should be the same internal type.  Inconsistant
;					conversion from string to numerics can occur, causing unexpected orderings.
;					- The bozo sort is a very poor sort, generally used only to show what not to do
;					when sorting.  The normal algorithm just grabs any two elements to swap; this one uses the
;					element discovered to be out-of-sequence and a random values in the WRONG position relative
;					to the first value.
;
; Example(s):
;   Local $aNums[100], $I, $sMsg
;
;   For $I = 0 To 99
;      $aNums[$I] = Random(1, 1000, True)
;   Next
;   _Sort_OptBozo($aNums)
;   $sMsg = $aNums[0]
;   For $I = 1 To 99
;      $sMsg &= ", " & $aNums[$I]
;   Next
;   MsgBox(48, "Sort Test", $sMsg)
;
;=============================================================================
Func _Sort_OptBozo(ByRef $aValues, Const $bSkipFirst = False)
	If Not IsArray($aValues) Then ;Make sure that it is an array
		SetError(1)
		Return False
	ElseIf UBound($aValues, 0) <> 1 Then ;Make sure that it is single dimensioned
		SetError(2)
		Return False
	ElseIf Not IsBool($bSkipFirst) Then
		SetError(3)
		Return False
	EndIf
	; Passed all those tests
	; Actual optimized bozo sort
	Local $nStart = 0
	Local $I, $K, $bSorted
	
	If $bSkipFirst Then $nStart = 1
	
	While 1
		$bSorted = True
		For $I = $nStart To UBound($aValues) - 2
			If $aValues[$I] > $aValues[$I + 1] Then
				; Out of sequence.
				$bSorted = False
				ExitLoop
			EndIf
		Next
		If $bSorted Then
			; Yeah!  The list is sorted.
			ExitLoop
		Else
			; Try switching two elements and see if that helps.
			Do
				; Find another element that is in the wrong location with respect to $I
				$K = Random($nStart, UBound($aValues) - 1, 1)
			Until ($I < $K And $aValues[$I] > $aValues[$K]) Or ($I > $K And $aValues[$I] < $aValues[$K])
			; And swap them.
			Swap($aValues[$I], $aValues[$K])
		EndIf
	WEnd
	Return True
EndFunc   ;==>_Sort_OptBozo

;=============================================================================
;
; Function Name:	_Sort_Stooge()
;
; Description:		Performs a stooge sort on the given array.
;
; Syntax:			_Sort_Stooge(ByRef $aValues, Const $bSkipFirst = False)
;
; Parameter(s):		$aValues = Array of values to be sorted.
;					$bSkipFirst = (Optional) Skip the first element of the array if it not part of the values to be sorted.
;
; Requirement(s):	External:   = None.
;					Internal:   = None.
;
; Return Value(s):	On Success: = Returns True and the array will be sorted.
;					On Failure: = Sets @Error and returns False.
;					@ERROR:     = 0 = No error.
;                                1 = The first parameter is not actually an array.
;                                2 = The first parameter is an array, but has more than one dimension.
;								 3 = The second paramenter is not boolean.
;
; Author(s):		"Nutster" David Nuttall <danuttall at rocketmail dot com>
;
; Notes:			- If the array stores the number of elements in element 0, set the second parameter to True.
;				   	- All the values in the array should be the same internal type.  Inconsistant
;					conversion from string to numerics can occur, causing unexpected orderings.
;					- The stooge sort is a poor sort, that is generally slower than bubble sort, begin about O(n^2.7)
;					Generally only used for educational purposes.
;
; Example(s):
;   Local $aNums[100], $I, $sMsg
;
;   For $I = 0 To 99
;      $aNums[$I] = Random(1, 1000, True)
;   Next
;   _Sort_Stooge($aNums)
;   $sMsg = $aNums[0]
;   For $I = 1 To 99
;      $sMsg &= ", " & $aNums[$I]
;   Next
;   MsgBox(48, "Sort Test", $sMsg)
;
;=============================================================================
Func _Sort_Stooge(ByRef $aValues, Const $bSkipFirst = False)
	If Not IsArray($aValues) Then ;Make sure that it is an array
		SetError(1)
		Return False
	ElseIf UBound($aValues, 0) <> 1 Then ;Make sure that it is single dimensioned
		SetError(2)
		Return False
	ElseIf Not IsBool($bSkipFirst) Then
		SetError(3)
		Return False
	EndIf
	; Passed all those tests
	; Actual Stooge sort
	Local $nStart = 0
	
	If $bSkipFirst Then $nStart = 1
	
	Return Stooge2($aValues, $nStart, UBound($aValues) - 1)
EndFunc   ;==>_Sort_Stooge

;=============================================================================
;
; Function Name:	_Sort_Bubble()
;
; Description:		Performs a bubble sort on the given array.
;
; Syntax:			_Sort_Bubble(ByRef $aValues, Const $bSkipFirst = False)
;
; Parameter(s):		$aValues = Array of values to be sorted.
;					$bSkipFirst = (Optional) Skip the first element of the array if it not part of the values to be sorted.
;
; Requirement(s):	External:   = None.
;					Internal:   = None.
;
; Return Value(s):	On Success: = Returns True and the array will be sorted.
;					On Failure: = Sets @Error and returns False.
;					@ERROR:     = 0 = No error.
;                                1 = The first parameter is not actually an array.
;                                2 = The first parameter is an array, but has more than one dimension.
;								 3 = The second paramenter is not boolean.
;
; Author(s):		"Nutster" David Nuttall <danuttall at rocketmail dot com>
;
; Notes:			- If the array stores the number of elements in element 0, set the second parameter to True.
;				   	- All the values in the array should be the same internal type.  Inconsistant
;					conversion from string to numerics can occur, causing unexpected orderings.
;					- The bubble sort is one of the simplest but also one of slowest of the common sorts.
;                   Because other sorts are generally faster, it is usually only used with small data sets.
;
; Example(s):
;   Local $aNums[100], $I, $sMsg
;
;   For $I = 0 To 99
;      $aNums[$I] = Random(1, 1000, True)
;   Next
;   _Sort_Bubble($aNums)
;   $sMsg = $aNums[0]
;   For $I = 1 To 99
;      $sMsg &= ", " & $aNums[$I]
;   Next
;   MsgBox(48, "Sort Test", $sMsg)
;
;=============================================================================
Func _Sort_Bubble(ByRef $aValues, Const $bSkipFirst = False)
	If Not IsArray($aValues) Then ;Make sure that it is an array
		SetError(1)
		Return False
	ElseIf UBound($aValues, 0) <> 1 Then ;Make sure that it is single dimensioned
		SetError(2)
		Return False
	ElseIf Not IsBool($bSkipFirst) Then
		SetError(3)
		Return False
	EndIf
	; Passed all those tests
	; Actual bubble sort
	Local $I
	Local $nStart = 0, $nHigh = UBound($aValues) - 1, $nLastSwap

	If $bSkipFirst Then $nStart = 1
	Do
		$nLastSwap = -1
		For $I = $nStart To $nHigh - 1
			If $aValues[$I] > $aValues[$I + 1] Then
				Swap($aValues[$I], $aValues[$I + 1])
				$nLastSwap = $I
			EndIf
		Next
		$nHigh = $nLastSwap
	Until $nLastSwap < 0
	Return True
EndFunc   ;==>_Sort_Bubble

;=============================================================================
;
; Function Name:	_Sort_Cocktail()
;
; Description:		Performs a cocktail sort on the given array.
;
; Syntax:			_Sort_Cocktail(ByRef $aValues, Const $bSkipFirst = False)
;
; Parameter(s):		$aValues = Array of values to be sorted.
;					$bSkipFirst = (Optional) Skip the first element of the array if it not part of the values to be sorted.
;
; Requirement(s):	External:   = None.
;					Internal:   = None.
;
; Return Value(s):	On Success: = Returns True and the array will be sorted.
;					On Failure: = Sets @Error and returns False.
;					@ERROR:     = 0 = No error.
;                                1 = The first parameter is not actually an array.
;                                2 = The first parameter is an array, but has more than one dimension.
;								 3 = The second paramenter is not boolean.
;
; Author(s):		"Nutster" David Nuttall <danuttall at rocketmail dot com>
;
; Notes:			- If the array stores the number of elements in element 0, set the second parameter to True.
;				   	- All the values in the array should be the same internal type.  Inconsistant
;					conversion from string to numerics can occur, causing unexpected orderings.
;					- The cocktail sort is based on a bubble sort, but sorts in one direction and then the
;					other on each pass.  This tends to move heavy and light elements into their positions
; 					faster than a straight bubble sort.  The name comes from shaking a cocktail back and forth
;					during its preparation.
;
; Example(s):
;   Local $aNums[100], $I, $sMsg
;
;   For $I = 0 To 99
;      $aNums[$I] = Random(1, 1000, True)
;   Next
;   _Sort_Cocktail($aNums)
;   $sMsg = $aNums[0]
;   For $I = 1 To 99
;      $sMsg &= ", " & $aNums[$I]
;   Next
;   MsgBox(48, "Sort Test", $sMsg)
;
;=============================================================================
Func _Sort_Cocktail(ByRef $aValues, Const $bSkipFirst = False)
	If Not IsArray($aValues) Then ;Make sure that it is an array
		SetError(1)
		Return False
	ElseIf UBound($aValues, 0) <> 1 Then ;Make sure that it is single dimensioned
		SetError(2)
		Return False
	ElseIf Not IsBool($bSkipFirst) Then
		SetError(3)
		Return False
	EndIf
	; Passed all those tests
	; Actual Cocktail sort
	Local $I
	Local $nStart = 0, $nLow, $nHigh = UBound($aValues) - 1, $nLastSwap

	If $bSkipFirst Then $nStart = 1
	$nLow = $nStart
	
	Do
		$nLastSwap = -1
		For $I = $nLow To $nHigh - 1
			If $aValues[$I] > $aValues[$I + 1] Then
				Swap($aValues[$I], $aValues[$I + 1])
				$nLastSwap = $I
			EndIf
		Next
		If $nLastSwap > 0 Then
			$nHigh = $nLastSwap
			$nLastSwap = -1
			For $I = $nHigh - 1 To $nLow Step - 1
				If $aValues[$I] > $aValues[$I + 1] Then
					Swap($aValues[$I], $aValues[$I + 1])
					$nLastSwap = $I
				EndIf
			Next
			$nLow = $nLastSwap
		EndIf
	Until $nLastSwap < 0
	Return True
EndFunc   ;==>_Sort_Cocktail

;=============================================================================
;
; Function Name:	_Sort_Selection()
;
; Description:		Performs a selection sort on the given array.
;
; Syntax:			_Sort_Selection(ByRef $aValues, Const $bSkipFirst = False)
;
; Parameter(s):		$aValues = Array of values to be sorted.
;					$bSkipFirst = (Optional) Skip the first element of the array if it not part of the values to be sorted.
;
; Requirement(s):	External:   = None.
;					Internal:   = None.
;
; Return Value(s):	On Success: = Returns True and the array will be sorted.
;					On Failure: = Sets @Error and returns False.
;					@ERROR:     = 0 = No error.
;                                1 = The first parameter is not actually an array.
;                                2 = The first parameter is an array, but has more than one dimension.
;								 3 = The second paramenter is not boolean.
;
; Author(s):		"Nutster" David Nuttall <danuttall at rocketmail dot com>
;
; Notes:			- If the array stores the number of elements in element 0, set the second parameter to True.
;				   	- All the values in the array should be the same internal type.  Inconsistant
;					conversion from string to numerics can occur, causing unexpected orderings.
;					- The selection sort goes through the array determining the smallest remaining number each time.
;                   Although slow, it generally performs the least number of writes of data of any sorting algorithm.
;                   - Generally this sort always runs in about the same time, no matter what the ordering.
;
; Example(s):
;   Local $aNums[100], $I, $sMsg
;
;   For $I = 0 To 99
;      $aNums[$I] = Random(1, 1000, True)
;   Next
;   _Sort_Selection($aNums)
;   $sMsg = $aNums[0]
;   For $I = 1 To 99
;      $sMsg &= ", " & $aNums[$I]
;   Next
;   MsgBox(48, "Sort Test", $sMsg)
;
;=============================================================================
Func _Sort_Selection(ByRef $aValues, Const $bSkipFirst = False)
	If IsArray($aValues) = False Then
		SetError(1)
		Return False
	ElseIf UBound($aValues, 0) <> 1 Then
		; Only designed for one-dimensional arrays
		SetError(2)
		Return False
	ElseIf Not IsBool($bSkipFirst) Then
		SetError(3)
		Return False
	EndIf
	; Passed all those tests
	; Actual selection sort
	Local $I, $K
	Local $nStart = 0, $nNextSwap

	If $bSkipFirst Then $nStart = 1

	For $K = $nStart To UBound($aValues) - 2 ; Last element will be sorted by the end.
		$nNextSwap = $K
		For $I = $K + 1 To UBound($aValues) - 1
			If $aValues[$nNextSwap] > $aValues[$I] Then
				$nNextSwap = $I
			EndIf
		Next
		If $nNextSwap > $K Then
			; If the first element isn't already the lowest, swap the lowest element there.
			Swap($aValues[$K], $aValues[$nNextSwap])
		EndIf
	Next
	Return True
EndFunc   ;==>_Sort_Selection

;=============================================================================
;
; Function Name:	_Sort_Insertion()
;
; Description:		Performs an linear insertion sort on the given array.
;
; Syntax:			_Sort_Insertion(ByRef $aValues, Const $bSkipFirst = False)
;
; Parameter(s):		$aValues = Array of values to be sorted.
;					$bSkipFirst = (Optional) Skip the first element of the array if it not part of the values to be sorted.
;
; Requirement(s):	External:   = None.
;					Internal:   = None.
;
; Return Value(s):	On Success: = Returns True and the array will be sorted.
;					On Failure: = Sets @Error and returns False.
;					@ERROR:     = 0 = No error.
;                                1 = The first parameter is not actually an array.
;                                2 = The first parameter is an array, but has more than one dimension.
;								 3 = The second paramenter is not boolean.
;
; Author(s):		"Nutster" David Nuttall <danuttall at rocketmail dot com>
;
; Notes:			- If the array stores the number of elements in element 0, set the second parameter to True.
;				   	- All the values in the array should be the same internal type.  Inconsistant
;					conversion from string to numerics can occur, causing unexpected orderings.
;					- The insertion sort goes through the array determining where each element belongs
;					in the already sorted part of the list, moves the other elements out
;					of the way and inserts the element in its place.
;
; Example(s):
;   Local $aNums[100], $I, $sMsg
;
;   For $I = 0 To 99
;      $aNums[$I] = Random(1, 1000, True)
;   Next
;   _Sort_Insertion($aNums)
;   $sMsg = $aNums[0]
;   For $I = 1 To 99
;      $sMsg &= ", " & $aNums[$I]
;   Next
;   MsgBox(48, "Sort Test", $sMsg)
;
;=============================================================================
Func _Sort_Insertion(ByRef $aValues, Const $bSkipFirst = False)
	If IsArray($aValues) = False Then
		SetError(1)
		Return False
	ElseIf UBound($aValues, 0) <> 1 Then
		; Only designed for one-dimensional arrays
		SetError(2)
		Return False
	ElseIf Not IsBool($bSkipFirst) Then
		SetError(3)
		Return False
	EndIf
	; Passed all those tests
	; Actual Insertion sort
	Local $I, $K, $nStart = 0
	Local $nLow, $nHigh, $nCurrent, $vValue

	If $bSkipFirst Then $nStart = 1
	
	For $I = $nStart + 1 To UBound($aValues) - 1
		; Assume the previous parts of the list is already sorted
		; First find where the current element would go, using a binary search
		$nLow = $nStart
		$nHigh = $I - 1
		$vValue = $aValues[$I]
		If $aValues[$nHigh] > $vValue Then
			; Values out-of-sequence.  If already in sequence, then this value belongs at the end of the list.
			For $K = $I - 1 To $nLow Step - 1
				If $aValues[$K] > $vValue Then
					$aValues[$K + 1] = $aValues[$K]
				Else
					$aValues[$K] = $vValue
					ExitLoop
				EndIf
			Next
		EndIf
	Next
	Return True
EndFunc   ;==>_Sort_Insertion

;=============================================================================
;
; Function Name:	_Sort_BinInsert()
;
; Description:		Performs an binary insertion sort on the given array.
;
; Syntax:			_Sort_BinInsert(ByRef $aValues, Const $bSkipFirst = False)
;
; Parameter(s):		$aValues = Array of values to be sorted.
;					$bSkipFirst = (Optional) Skip the first element of the array if it not part of the values to be sorted.
;
; Requirement(s):	External:   = None.
;					Internal:   = None.
;
; Return Value(s):	On Success: = Returns True and the array will be sorted.
;					On Failure: = Sets @Error and returns False.
;					@ERROR:     = 0 = No error.
;                                1 = The first parameter is not actually an array.
;                                2 = The first parameter is an array, but has more than one dimension.
;								 3 = The second paramenter is not boolean.
;
; Author(s):		"Nutster" David Nuttall <danuttall at rocketmail dot com>
;
; Notes:			- If the array stores the number of elements in element 0, set the second parameter to True.
;				   	- All the values in the array should be the same internal type.  Inconsistant
;					conversion from string to numerics can occur, causing unexpected orderings.
;					- The binary insertion sort goes through the array determining where each element belongs
;					in the already sorted part of the list using binary search, moves the other elements out
;					of the way and inserts the element in its place.
;
; Example(s):
;   Local $aNums[100], $I, $sMsg
;
;   For $I = 0 To 99
;      $aNums[$I] = Random(1, 1000, True)
;   Next
;   _Sort_BinInsert($aNums)
;   $sMsg = $aNums[0]
;   For $I = 1 To 99
;      $sMsg &= ", " & $aNums[$I]
;   Next
;   MsgBox(48, "Sort Test", $sMsg)
;
;=============================================================================
Func _Sort_BinInsert(ByRef $aValues, Const $bSkipFirst = False)
	If IsArray($aValues) = False Then
		SetError(1)
		Return False
	ElseIf UBound($aValues, 0) <> 1 Then
		; Only designed for one-dimensional arrays
		SetError(2)
		Return False
	ElseIf Not IsBool($bSkipFirst) Then
		SetError(3)
		Return False
	EndIf
	; Passed all those tests
	; Actual BinInsert sort
	Local $I, $K, $nStart = 0
	Local $nLow, $nHigh, $nCurrent, $vValue

	If $bSkipFirst Then $nStart = 1
	
	For $I = $nStart + 1 To UBound($aValues) - 1
		; Assume the previous parts of the list is already sorted
		; First find where the current element would go, using a binary search
		$nLow = $nStart
		$nHigh = $I - 1
		$vValue = $aValues[$I]
		If $aValues[$nHigh] > $vValue Then
			; Values out-of-sequence.  If already in sequence, then this value belongs at the end of the list.
			While $nLow < $nHigh
				$nCurrent = Int(($nLow + $nHigh) / 2)
				If $vValue < $aValues[$nCurrent] Then
					$nHigh = $nCurrent - 1
				ElseIf $vValue > $aValues[$nCurrent] Then
					$nLow = $nCurrent + 1
				Else ; Equal!  Found it.
					ExitLoop
				EndIf
			WEnd
			If $vValue = $aValues[$nCurrent] Then
				; Found it.  Looks like a duplicate.
				; Find the end of the duplicates to insert the new element.
				For $K = $nCurrent To $I
					If $aValues[$K] > $aValues[$nCurrent] Then ExitLoop
				Next
			Else
				; Not found
				; Find where it does belong.
				For $K = Max($nLow - 1, 0) To Min($nHigh + 1, $I - 1)
					; Somewhere in here should be the correct place to insert the value.
					If $vValue < $aValues[$K] Then ExitLoop
				Next
			EndIf
			$nCurrent = $K ; $nCurrent is the element where the new element should go.
			For $K = $I - 1 To $nCurrent Step - 1
				$aValues[$K + 1] = $aValues[$K]
			Next
			$aValues[$nCurrent] = $vValue
		EndIf
	Next
	Return True
EndFunc   ;==>_Sort_BinInsert

;=============================================================================
;
; Function Name:	_Sort_Gnome()
;
; Description:		Performs a gnome sort on the given array.
;
; Syntax:			_Sort_Gnome(ByRef $aValues, Const $bSkipFirst = False)
;
; Parameter(s):		$aValues = Array of values to be sorted.
;					$bSkipFirst = (Optional) Skip the first element of the array if it not part of the values to be sorted.
;
; Requirement(s):	External:   = None.
;					Internal:   = None.
;
; Return Value(s):	On Success: = Returns True and the array will be sorted.
;					On Failure: = Sets @Error and returns False.
;					@ERROR:     = 0 = No error.
;                                1 = The first parameter is not actually an array.
;                                2 = The first parameter is an array, but has more than one dimension.
;								 3 = The second paramenter is not boolean.
;
; Author(s):		"Nutster" David Nuttall <danuttall at rocketmail dot com>
;
; Notes:			- If the array stores the number of elements in element 0, set the second parameter to True.
;				   	- All the values in the array should be the same internal type.  Inconsistant
;					conversion from string to numerics can occur, causing unexpected orderings.
;					- The gnome sort goes through the list, similar to an BinInsert sort, and swaps each element
; 					until it is in its correct location.
;
; Example(s):
;   Local $aNums[100], $I, $sMsg
;
;   For $I = 0 To 99
;      $aNums[$I] = Random(1, 1000, True)
;   Next
;   _Sort_Gnome($aNums)
;   $sMsg = $aNums[0]
;   For $I = 1 To 99
;      $sMsg &= ", " & $aNums[$I]
;   Next
;   MsgBox(48, "Sort Test", $sMsg)
;
;=============================================================================
Func _Sort_Gnome(ByRef $aValues, Const $bSkipFirst = False)
	If IsArray($aValues) = False Then
		SetError(1)
		Return False
	ElseIf UBound($aValues, 0) <> 1 Then
		; Only designed for one-dimensional arrays
		SetError(2)
		Return False
	ElseIf Not IsBool($bSkipFirst) Then
		SetError(3)
		Return False
	EndIf
	; Passed all those tests
	; Actual gnome sort
	Local $I, $K, $nStart = 0

	If $bSkipFirst Then $nStart = 1
	
	For $I = $nStart + 1 To UBound($aValues) - 1
		; Assume the previous parts of the list is already sorted
		; Start swapping the current element until it is in the correct location in the sorted list.
		For $K = $I - 1 To $nStart Step - 1
			; If the current element and the next are out of sequence, swap them and check the previous pair.
			If $aValues[$K] > $aValues[$K + 1] Then
				Swap($aValues[$K], $aValues[$K + 1])
			Else
				; If not out of sequence, break out and get the next value.
				ExitLoop
			EndIf
		Next
	Next
	Return True
EndFunc   ;==>_Sort_Gnome

;=============================================================================
;
; Function Name:	_Sort_Comb()
;
; Description:		Performs a comb sort on the given array.
;
; Syntax:			_Sort_Comb(ByRef $aValues, Const $bSkipFirst = False)
;
; Parameter(s):		$aValues = Array of values to be sorted.
;					$bSkipFirst = (Optional) Skip the first element of the array if it not part of the values to be sorted.
;
; Requirement(s):	External:   = None.
;					Internal:   = None.
;
; Return Value(s):	On Success: = Returns True and the array will be sorted.
;					On Failure: = Sets @Error and returns False.
;					@ERROR:     = 0 = No error.
;                                1 = The first parameter is not actually an array.
;                                2 = The first parameter is an array, but has more than one dimension.
;								 3 = The second paramenter is not boolean.
;
; Author(s):		"Nutster" David Nuttall <danuttall at rocketmail dot com>
;
; Notes:			- If the array stores the number of elements in element 0, set the second parameter to True.
;				   	- All the values in the array should be the same internal type.  Inconsistant
;					conversion from string to numerics can occur, causing unexpected orderings.
;					- The comb sort is similar to the bubble sort, except it starts out by comparing
;					elements that are far away to start with, and moves closer.  This can speed up the
;					sorting if values are significantly out-of-sequence.  For sets that are mostly
;					in-sequence, the extra overhead of checking far away can slow things down.
;					- Shaker sort is very similar to a comb sort.
;
; Example(s):
;   Local $aNums[100], $I, $sMsg
;
;   For $I = 0 To 99
;      $aNums[$I] = Random(1, 1000, True)
;   Next
;   _Sort_Comb($aNums)
;   $sMsg = $aNums[0]
;   For $I = 1 To 99
;      $sMsg &= ", " & $aNums[$I]
;   Next
;   MsgBox(48, "Sort Test", $sMsg)
;
;=============================================================================
Func _Sort_Comb(ByRef $aValues, Const $bSkipFirst = False)
	If IsArray($aValues) = False Then
		SetError(1)
		Return False
	ElseIf UBound($aValues, 0) <> 1 Then
		; Only designed for one-dimensional arrays
		SetError(2)
		Return False
	ElseIf Not IsBool($bSkipFirst) Then
		SetError(3)
		Return False
	EndIf
	; Passed all those tests
	; Actual comb sort
	Local $nStart = 0, $I, $bSwapped
	Local $nSep = Int(UBound($aValues) / 2)

	If $bSkipFirst Then $nStart = 1
	
	While $nSep > 0
		Do
			$bSwapped = False
			For $I = $nStart To UBound($aValues) - $nSep - 1
				If $aValues[$I] > $aValues[$I + $nSep] Then
					Swap($aValues[$I], $aValues[$I + $nSep])
					$bSwapped = True
				EndIf
			Next
		Until Not $bSwapped
		$nSep = Int($nSep * 0.8) 	; Pretty close to optimal comb gap change
		; There are some issues around using a gap of 9 or 10, so set them to 11
		Switch ($nSep)
			Case 9, 10
				$nSep = 11
		EndSwitch
	WEnd
	Return True
EndFunc   ;==>_Sort_Comb

;=============================================================================
;
; Function Name:	_Sort_Shell()
;
; Description:		Performs a shell sort on the given array.
;
; Syntax:			_Sort_Shell(ByRef $aValues, Const $bSkipFirst = False)
;
; Parameter(s):		$aValues = Array of values to be sorted.
;					$bSkipFirst = (Optional) Skip the first element of the array if it not part of the values to be sorted.
;
; Requirement(s):	External:   = None.
;					Internal:   = None.
;
; Return Value(s):	On Success: = Returns True and the array will be sorted.
;					On Failure: = Sets @Error and returns False.
;					@ERROR:     = 0 = No error.
;                                1 = The first parameter is not actually an array.
;                                2 = The first parameter is an array, but has more than one dimension.
;								 3 = The second paramenter is not boolean.
;
; Author(s):		"Nutster" David Nuttall <danuttall at rocketmail dot com>
;
; Notes:			- If the array stores the number of elements in element 0, set the second parameter to True.
;				   	- All the values in the array should be the same internal type.  Inconsistant
;					conversion from string to numerics can occur, causing unexpected orderings.
;					- The shell sort is similar to the BinInsert sort, except it starts out by comparing
;					elements that are far away to start with, and moves closer.  This can speed up the
;					sorting if values are significantly out-of-sequence.  For sets that are mostly
;					in-sequence, the extra overhead of checking far away can slow things down.
;
; Example(s):
;   Local $aNums[100], $I, $sMsg
;
;   For $I = 0 To 99
;      $aNums[$I] = Random(1, 1000, True)
;   Next
;   _Sort_Shell($aNums)
;   $sMsg = $aNums[0]
;   For $I = 1 To 99
;      $sMsg &= ", " & $aNums[$I]
;   Next
;   MsgBox(48, "Sort Test", $sMsg)
;
;=============================================================================
Func _Sort_Shell(ByRef $aValues, Const $bSkipFirst = False)
	If IsArray($aValues) = False Then
		SetError(1)
		Return False
	ElseIf UBound($aValues, 0) <> 1 Then
		; Only designed for one-dimensional arrays
		SetError(2)
		Return False
	ElseIf Not IsBool($bSkipFirst) Then
		SetError(3)
		Return False
	EndIf
	; Passed all those tests
	; Actual Shell sort
	Local $nStart = 0, $I, $K, $vTmp
	Local $nSep = Int(UBound($aValues) / 2)

	If $bSkipFirst Then $nStart = 1
	
	While $nSep > 0
		For $I = $nSep To UBound($aValues) - 1
			$K = $I
			$vTmp = $aValues[$I]
			While $K >= $nSep And $aValues[$K - $nSep] > $vTmp
				$aValues[$K] = $aValues[$K - $nSep]
				$K -= $nSep
			WEnd
			$aValues[$K] = $vTmp
		Next
		If $nSep = 2 Then
			$nSep = 1
		Else
			$nSep = Int($nSep * 0.4545) 	; This value is a little more optimal than 0.5.
		EndIf
	WEnd
	Return True
EndFunc   ;==>_Sort_Shell

;=============================================================================
;
; Function Name:	_Sort_Merge()
;
; Description:		Performs a merge sort on the given array.
;
; Syntax:			_Sort_Merge(ByRef $aValues, Const $bSkipFirst = False)
;
; Parameter(s):		$aValues = Array of values to be sorted.
;					$bSkipFirst = (Optional) Skip the first element of the array if it not part of the values to be sorted.
;
; Requirement(s):	External:   = None.
;					Internal:   = None.
;
; Return Value(s):	On Success: = Returns True and the array will be sorted.
;					On Failure: = Sets @Error and returns False.
;					@ERROR:     = 0 = No error.
;                                1 = The first parameter is not actually an array.
;                                2 = The first parameter is an array, but has more than one dimension.
;								 3 = The second paramenter is not boolean.
;
; Author(s):		"Nutster" David Nuttall <danuttall at rocketmail dot com>
;
; Notes:			- If the array stores the number of elements in element 0, set the second parameter to True.
;				   	- All the values in the array should be the same internal type.  Inconsistant
;					conversion from string to numerics can occur, causing unexpected orderings.
;					- The merge sort breaks the array into smaller sub-arrays that are then sorted and then
;					brings them together, merging the sorted sub-arrays.  This can be very fast, but
;					has HUGE memory requirements.
;
; Example(s):
;   Local $aNums[100], $I, $sMsg
;
;   For $I = 0 To 99
;      $aNums[$I] = Random(1, 1000, True)
;   Next
;   _Sort_Merge($aNums)
;   $sMsg = $aNums[0]
;   For $I = 1 To 99
;      $sMsg &= ", " & $aNums[$I]
;   Next
;   MsgBox(48, "Sort Test", $sMsg)
;
;=============================================================================
Func _Sort_Merge(ByRef $aValues, Const $bSkipFirst = False)
	If IsArray($aValues) = False Then
		SetError(1)
		Return False
	ElseIf UBound($aValues, 0) <> 1 Then
		; Only designed for one-dimensional arrays
		SetError(2)
		Return False
	ElseIf Not IsBool($bSkipFirst) Then
		SetError(3)
		Return False
	EndIf
	; Passed all those tests
	; Actual merge sort
	Local $nStart = 0
	
	If $bSkipFirst Then
		; Copy the elements to a new array and call recursive merge.
		Local $I, $a1[UBound($aValues) - 1]
		
		For $I = 0 To UBound($aValues) - 2
			$a1[$I] = $aValues[$I + 1]
		Next
		If Merge_Sort($a1) Then
			; Now copy it back
			For $I = 0 To UBound($aValues) - 2
				$aValues[$I + 1] = $a1[$I]
			Next
		Else
			Return False
		EndIf
	Else
		Return Merge_Sort($aValues)
	EndIf
EndFunc   ;==>_Sort_Merge

;=============================================================================
;
; Function Name:	_Sort_Heap()
;
; Description:		Performs a heap sort on the given array.
;
; Syntax:			_Sort_Heap(ByRef $aValues, Const $bSkipFirst = False)
;
; Parameter(s):		$aValues = Array of values to be sorted.
;					$bSkipFirst = (Optional) Skip the first element of the array if it not part of the values to be sorted.
;
; Requirement(s):	External:   = None.
;					Internal:   = None.
;
; Return Value(s):	On Success: = Returns True and the array will be sorted.
;					On Failure: = Sets @Error and returns False.
;					@ERROR:     = 0 = No error.
;                                1 = The first parameter is not actually an array.
;                                2 = The first parameter is an array, but has more than one dimension.
;								 3 = The second paramenter is not boolean.
;
; Author(s):		"Nutster" David Nuttall <danuttall at rocketmail dot com>
;
; Notes:			- If the array stores the number of elements in element 0, set the second parameter to True.
;				   	- All the values in the array should be the same internal type.  Inconsistant
;					conversion from string to numerics can occur, causing unexpected orderings.
;					- The heap sort sorts using a version of an in-place binary tree called a heap, where the
;					largest elements are at the beginning of the heap.  The sort happens by swapping the
;					value from the beginning of the complete heap to the end of the array and rebuilding
;					the heap.
;
; Example(s):
;   Local $aNums[100], $I, $sMsg
;
;   For $I = 0 To 99
;      $aNums[$I] = Random(1, 1000, True)
;   Next
;   _Sort_Heap($aNums)
;   $sMsg = $aNums[0]
;   For $I = 1 To 99
;      $sMsg &= ", " & $aNums[$I]
;   Next
;   MsgBox(48, "Sort Test", $sMsg)
;
;=============================================================================
Func _Sort_Heap(ByRef $aValues, Const $bSkipFirst = False)
	If IsArray($aValues) = False Then
		SetError(1)
		Return False
	ElseIf UBound($aValues, 0) <> 1 Then
		; Only designed for one-dimensional arrays
		SetError(2)
		Return False
	ElseIf Not IsBool($bSkipFirst) Then
		SetError(3)
		Return False
	EndIf
	; Passed all those tests
	Local $I, $bSwapped, $nStart = 0
	
	If $bSkipFirst Then $nStart = 1
	; Actual heap sort
	; Set up the heap.  Largest element to the front.  Each element is smaller than the element with half the index.
	Do
		$bSwapped = False
		For $I = UBound($aValues) - 1 To $nStart + 1 Step - 1
			If $aValues[Int($I / 2)] < $aValues[$I] Then
				Swap($aValues[Int($I / 2)], $aValues[$I])
				$bSwapped = True
			EndIf
		Next
	Until Not $bSwapped
	For $M = UBound($aValues) - 1 To $nStart + 1 Step - 1
		; The largest element is now at the beginning.  Swap it to the end.
		Swap($aValues[$nStart], $aValues[$M])
		; Now determine where the new top element actually goes in the heap.
		$I = $nStart
		While $I * 2 < $M - 1
			Switch MaxIndex($aValues[$I], $aValues[2 * $I], $aValues[2 * $I + 1])
				Case 1
					; Current element is largest.  Stop
					ExitLoop
				Case 2
					Swap($aValues[$I], $aValues[2 * $I])
					$I *= 2
				Case 3
					Swap($aValues[$I], $aValues[2 * $I + 1])
					$I = 2 * $I + 1
			EndSwitch
		WEnd
	Next
	Return True
EndFunc   ;==>_Sort_Heap

;=============================================================================
;
; Function Name:	_Sort_Quick()
;
; Description:		Performs a quick sort on the given array.
;
; Syntax:			_Sort_Quick(ByRef $aValues, Const $bSkipFirst = False)
;
; Parameter(s):		$aValues = Array of values to be sorted.
;					$bSkipFirst = (Optional) Skip the first element of the array if it not part of the values to be sorted.
;
; Requirement(s):	External:   = None.
;					Internal:   = None.
;
; Return Value(s):	On Success: = Returns True and the array will be sorted.
;					On Failure: = Sets @Error and returns False.
;					@ERROR:     = 0 = No error.
;                                1 = The first parameter is not actually an array.
;                                2 = The first parameter is an array, but has more than one dimension.
;								 3 = The second paramenter is not boolean.
;
; Author(s):		"Nutster" David Nuttall <danuttall at rocketmail dot com>
;
; Notes:			- If the array stores the number of elements in element 0, set the second parameter to True.
;				   	- All the values in the array should be the same internal type.  Inconsistant
;					conversion from string to numerics can occur, causing unexpected orderings.
;					- The quick sort works by partitioning the values above and below a pivot value, swapping
;					the pivot into the correct location and then separately sorting the sub-array below the
;					pivot and the sub-array above the pivot.
;					- The pivot is chosen as the middle element in the sub-array to be sorted.  This allows this
;					method to sort a mostly sorted list even faster than an unsorted list and not get trapped in
;					the generally worst-case scenario for quick sort of a list that is mostly sorted.
;					- The worst case scenario for this style of quick sort is when a large group of values is all
;					identical values.
;
; Example(s):
;   Local $aNums[100], $I, $sMsg
;
;   For $I = 0 To 99
;      $aNums[$I] = Random(1, 1000, True)
;   Next
;   _Sort_Quick($aNums)
;   $sMsg = $aNums[0]
;   For $I = 1 To 99
;      $sMsg &= ", " & $aNums[$I]
;   Next
;   MsgBox(48, "Sort Test", $sMsg)
;
;=============================================================================
Func _Sort_Quick(ByRef $aValues, Const $bSkipFirst = False)
	If IsArray($aValues) = False Then
		SetError(1)
		Return False
	ElseIf UBound($aValues, 0) <> 1 Then
		; Only designed for one-dimensional arrays
		SetError(2)
		Return False
	ElseIf Not IsBool($bSkipFirst) Then
		SetError(3)
		Return False
	EndIf
	; Passed all those tests
	; Call the actual quicksort function with correct parameters
	If $bSkipFirst Then
		QuickSort3($aValues, 1, UBound($aValues) - 1)
	Else
		QuickSort3($aValues, 0, UBound($aValues) - 1)
	EndIf
	Return True
EndFunc   ;==>_Sort_Quick

; Support functions.  Not to be usually called directly

Func Swap(ByRef $vA, ByRef $vB)
	Local $T = $vA
	$vA = $vB
	$vB = $T
EndFunc   ;==>Swap

Func Min($vA, $vB)
	If IsArray($vA) Or IsArray($vB) Then
		SetError(1)
		Return False
	EndIf
	If $vA < $vB Then
		Return $vA
	Else
		Return $vB
	EndIf
EndFunc   ;==>Min

Func Max($vA, $vB)
	If IsArray($vA) Or IsArray($vB) Then
		SetError(1)
		Return False
	EndIf
	If $vA > $vB Then
		Return $vA
	Else
		Return $vB
	EndIf
EndFunc   ;==>Max

Func MaxIndex($v1, $v2, $v3)
	; Returns 1, 2, or 3 depending on which variable is largest
	If $v1 < $v2 Then
		If $v2 < $v3 Then
			Return 3
		Else
			Return 2
		EndIf
	ElseIf $v1 < $v3 Then
		Return 3
	Else
		Return 1
	EndIf
EndFunc   ;==>MaxIndex

; Recursive functions

Func Stooge2(ByRef $aValues, Const $nLow, Const $nHigh)
	If $nLow < $nHigh Then
		Local $nThird = Int(($nHigh - $nLow + 1) / 3)
		
		If $aValues[$nLow] > $aValues[$nHigh] Then Swap($aValues[$nLow], $aValues[$nHigh])
		If $nThird > 0 Then
			Return _
					Stooge2($aValues, $nLow, $nHigh - $nThird) And _
					Stooge2($aValues, $nLow + $nThird, $nHigh) And _
					Stooge2($aValues, $nLow, $nHigh - $nThird)
		EndIf
	EndIf
	Return True
EndFunc   ;==>Stooge2

Func Merge_Sort(ByRef $aValues)
	; Not going to bother checking if values are proper type.  Should have already been checked.
	Switch UBound($aValues)
		Case 1
			; Only one element.  Consider it sorted.
			Return True
		Case 2
			; Check that the two elements are in order and swap them if needed.
			If $aValues[0] > $aValues[1] Then Swap($aValues[0], $aValues[1])
			; Now the array is sorted
			Return True
		Case Else
			; Bigger array needs to be broken down.
			Local $M, $N, $a1[Ceiling(UBound($aValues) / 2)], $a2[Floor(UBound($aValues) / 2)]
			For $M = 0 To UBound($a2) - 1
				$a1[$M] = $aValues[$M * 2]
				$a2[$M] = $aValues[$M * 2 + 1]
			Next
			; Add the last element if it did not get added in the loop
			If UBound($a1) > UBound($a2) Then
				$a1[$M] = $aValues[$M * 2]
			EndIf
			If Merge_Sort($a1) And Merge_Sort($a2) Then
				; Sub-arrays are sorted.  Merge them into the original array.
				$M = 0
				$N = 0
				While $M < UBound($a1) And $N < UBound($a2)
					If $a1[$M] < $a2[$N] Then
						$aValues[$M + $N] = $a1[$M]
						$M += 1
					Else
						$aValues[$M + $N] = $a2[$N]
						$N += 1
					EndIf
				WEnd
				; One of the arrays usually gets all used up before the other one.
				; Walk through them, bringing the last elements into the original.
				For $M = $M To UBound($a1) - 1
					$aValues[$M + $N] = $a1[$M]
				Next
				For $N = $N To UBound($a2) - 1
					$aValues[$M + $N] = $a2[$N]
				Next
				Return True
			Else
				; Something went wrong in a sub-sort
				Return False
			EndIf
	EndSwitch
EndFunc   ;==>Merge_Sort

Func QuickSort3(ByRef $aValues, Const $nLow, Const $nHigh)
	; Not going to bother checking if values are proper type.  Should have already been checked.
	If $nLow < $nHigh Then
		; Choose a pivot from the middle of the list and swap it to the front.  This is less
		; likely to get trapped in the worst-case scenario.
		Swap($aValues[$nLow], $aValues[($nLow + $nHigh) / 2])
		
		Local $nPivot = $aValues[$nLow]
		Local $M = $nLow + 1, $N = $nHigh

		; Go though the list, swapping those that are on the wrong side of the pivot.
		While $M < $N
			While $M < $N And $aValues[$M] <= $nPivot
				$M += 1
			WEnd
			While $M < $N And $aValues[$N] >= $nPivot
				$N -= 1
			WEnd
			; $aValues[$M] and $aValues[$N] are out of sequence, so swap them.
			If $M < $N Then Swap($aValues[$M], $aValues[$N])
		WEnd
		; Now determine where to put the pivot
		While $M > $nLow And $aValues[$M] >= $nPivot
			$M -= 1
		WEnd
		If $aValues[$M] < $aValues[$nLow] Then
			Swap($aValues[$M], $aValues[$nLow])
		EndIf
		QuickSort3($aValues, $nLow, $M - 1)
		QuickSort3($aValues, $M + 1, $nHigh)
	EndIf
EndFunc   ;==>QuickSort3

; Debugging functions

Func DumpArray(Const ByRef $aValues, Const $sTitle = "Array")
	Local $I, $sMsg
	
	$sMsg = $sTitle & ": " & $aValues[0]
	For $I = 1 To UBound($aValues) - 1
		$sMsg &= ", " & $aValues[$I]
	Next
	ConsoleWrite($sMsg & @CRLF)
	Return True
EndFunc   ;==>DumpArray