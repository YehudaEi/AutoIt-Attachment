Local $repetitions = 4
Local $items = 2000
Local $subitems = 1
Local $iTestCase = 4

; Parameters
Local $iDescending = 0
Local $iStart = 0
Local $iEnd = $items-1
Local $iSubItem = -1

; Set $avReference up
If $subitems < 1 Then
	MsgBox(0, "Error", "$subitems must be a positive integer!")
	Exit
EndIf
If $subitems = 1 Then Global $avReference[$items]
If $subitems > 1 Then
	If $iSubItem < 0 Then
		$iSubItem = 0
	ElseIf $iSubItem >= $subitems Then
		$iSubItem = $subitems-1
	EndIf
	Global $avReference[$items][$subitems]
EndIf

Local $rand

Switch $iTestCase
	Case 1 ; All 0
		For $i = 0 To $items-1
			If $subitems = 1 Then
				$avReference[$i] = 0
			Else
				For $j = 0 To $subitems-1
					$avReference[$i][$j] = 0
				Next
			EndIf
		Next
	Case 2 ; All numbers
		For $i = 0 To $items-1
			$rand = Random(0, 2147483647, 1)
			If $subitems = 1 Then
				$avReference[$i] = $rand
			Else
				For $j = 0 To $subitems-1
					$avReference[$i][$j] = $rand
				Next
			EndIf
		Next
	Case 3 ; ~50% numberstrings, ~50% integers
		For $i = 0 To $items-1
			$rand = Random(0, 2147483647, 1)
			If Random() > 0.5 Then $rand = '"'&String($rand)&'"'
			If $subitems = 1 Then
				$avReference[$i] = $rand
			Else
				For $j = 0 To $subitems-1
					$avReference[$i][$j] = $rand
				Next
			EndIf
		Next
	Case 4 ; ~90% lowercase alphabet, ~10% integers
		For $i = 0 To $items-1
			$rand = Random(0, 2147483647, 1)
			If Random() < 0.9 Then $rand = Chr(97 + Mod($rand, 26))
			If $subitems = 1 Then
				$avReference[$i] = $rand
			Else
				For $j = 0 To $subitems-1
					$avReference[$i][$j] = $rand
				Next
			EndIf
		Next
	Case Else ; All null
EndSwitch

; Variables...
Local $array, $timer, $totalT1, $totalT2, $array_oldresult

;local $avreference[3][2] = [["a", 4], ["a", 2], ["a", 8]]

For $i = 1 To $repetitions
	$array = $avReference
	Switch $subitems
		Case 1
			$array[0] = $array[0]
		Case 2
			$array[0][0] = $array[0][0]
	EndSwitch
	$timer = TimerInit()
	_ArraySort1($array, $iDescending, $iStart, $iEnd, $iSubItem)
	$totalT1 += TimerDiff($timer)
Next
$array_oldresult = $array

For $i = 1 To $repetitions
	$array = $avReference
	Switch $subitems
		Case 1
			$array[0] = $array[0]
		Case 2
			$array[0][0] = $array[0][0]
	EndSwitch
	$timer = TimerInit()
	_ArraySort2($array, $iDescending, $iStart, $iEnd, $iSubItem)
	$totalT2 += TimerDiff($timer)
Next

; Check/compare/show results
If Not IsIdentical($array, $array_oldresult) Then Exit
If IsSorted($array, $iDescending, $iStart, $iEnd, $iSubItem) Then ConsoleWrite(StringFormat("1: %.10f" & @CRLF & "2: %.10f\nDiff: %.2f%%" & @CRLF, $totalT1/1000, $totalT2/1000, 100*($totalT2-$totalT1)/$totalT1))

;-------------------------------------------------------------------------------
; IsIdentical
;-------------------------------------------------------------------------------
Func IsIdentical(Const ByRef $avArray1, ByRef $avArray2, $iStart = 0, $iEnd = -1)
	Local $iUbound = UBound($avArray1) - 1, $iUBoundSub = UBound($avArray1, 2)

	; Bounds checking
	If $iEnd < $iStart Or $iEnd > $iUBound Then $iEnd = $iUBound
	If $iStart < 0 Or $iStart > $iEnd Then $iStart = 0

	; Check
	For $i = $iStart To $iEnd-1
		If $iUBoundSub = 0 Then
			If $avArray1[$i] <> $avArray2[$i] Then
				ConsoleWrite(StringFormat("diff @ $i = %d" & @CRLF, $i))
				ConsoleWrite(StringFormat("$array[%d]=%s" & @CRLF, $i, $array[$i]))
				ConsoleWrite(StringFormat("$array_oldresult[%d]=%s" & @CRLF, $i, $array_oldresult[$i]))
				Return SetError(1, 0, 0)
			EndIf
		Else
			For $j = 0 To $iUBoundSub-1
				If $avArray1[$i][$j] <> $avArray2[$i][$j] Then
					ConsoleWrite(StringFormat("diff @ $i = %d, $j = %d" & @CRLF, $i, $j))
					ConsoleWrite(StringFormat("$array[%d][%d] = %s" & @CRLF, $i, $j, $array[$i][$j]))
					ConsoleWrite(StringFormat("$array_oldresult[%d][%d] = %s" & @CRLF, $i, $j, $array_oldresult[$i][$j]))
					Return SetError(1, 0, 0)
				EndIf
			Next
		EndIf
	Next

	Return 1
EndFunc

;-------------------------------------------------------------------------------
; IsSorted
;-------------------------------------------------------------------------------
Func IsSorted(Const ByRef $avArray, $iDescending = 0, $iStart = 0, $iEnd = -1, $iSubItem = -1)
	If Not IsArray($avArray) Then Return SetError(1, 0, 0)

	Local $iUbound = UBound($avArray) - 1, $iDimension = UBound($avArray, 0)

	; Bounds checking
	If $iEnd < $iStart Or $iEnd > $iUBound Then $iEnd = $iUBound
	If $iStart < 0 Or $iStart > $iEnd Then $iStart = 0

	; Dimension checking
	Switch $iDimension
		Case 1
		Case 2
			If $iSubItem < 0 Or $iSubItem >= UBound($avArray, 2) Then Return SetError(2, 0, 0)
		Case Else
			Return SetError(3, 0, 0)
	EndSwitch

	If $iDescending Then
		$iDescending = -1
	Else
		$iDescending = 1
	EndIf

	Local $iTmp1, $iTmp2

	; Check
	For $i = $iStart To $iEnd-1
		If $iSubItem < 0 Then
			$iTmp1 = $avArray[$i]
			$iTmp2 = $avArray[$i+1]
		Else
			$iTmp1 = $avArray[$i][$iSubItem]
			$iTmp2 = $avArray[$i+1][$iSubItem]
		EndIf

		If (IsNumber($iTmp1) And IsNumber($iTmp2) And $iDescending*($iTmp1 - $iTmp2) > 0) Or (Not (IsNumber($iTmp1) And IsNumber($iTmp2)) And $iDescending*StringCompare($iTmp1, $iTmp2) > 0) Then
			ConsoleWrite(StringFormat("not sorted @ $i = %d" & @CRLF, $i))
			Return SetError(1, 0, $i)
		EndIf
	Next
	
	Return 1
EndFunc

;-------------------------------------------------------------------------------
; ArrayReverse
;-------------------------------------------------------------------------------
Func _ArrayReverse(ByRef $avArray, $iStart = 0, $iEnd = 0)
	If Not IsArray($avArray) Then Return SetError(1, 0, 0)

	Local $vTmp, $iUBound = UBound($avArray) - 1

	; Bounds checking
	If $iEnd < 1 Or $iEnd > $iUBound Then $iEnd = $iUBound
	If $iStart < 0 Then $iStart = 0
	If $iStart > $iEnd Then Return SetError(2, 0, 0)

	; Reverse
	For $i = $iStart To Int(($iStart + $iEnd - 1)/2)
		$vTmp = $avArray[$i]
		$avArray[$i] = $avArray[$iEnd]
		$avArray[$iEnd] = $vTmp
		$iEnd -= 1
	Next

	Return 1
EndFunc   ;==>_ArrayReverse










;-------------------------------------------------------------------------------
; OLD SORTING
;-------------------------------------------------------------------------------
Func _ArraySort1(ByRef $avArray, $iDescending = 0, $iStart = 0, $iEnd = 0, $iSubItem = 0)
	If Not IsArray($avArray) Then Return SetError(1, 0, 0)

	Local $iUBound = UBound($avArray) - 1, $iDimension = UBound($avArray, 0)

	; Bounds checking
	If $iEnd < 1 Or $iEnd > $iUBound Then $iEnd = $iUBound
	If $iStart < 0 Then $iStart = 0
	If $iStart > $iEnd Then Return SetError(2, 0, 0)

	; Sort
	Switch $iDimension
		Case 1
			___ArrayQSort1($avArray, $iStart, $iEnd)
			If $iDescending Then _ArrayReverse($avArray, $iStart, $iEnd)
		Case 2
			Local $iUBoundSub = UBound($avArray, 2)
			If $iSubItem < 0 Then $iSubItem = 0
			If $iSubItem > $iUBoundSub Then $iSubItem = $iUBoundSub

			___ArrayQSort2($avArray, $iStart, $iEnd, $iUBoundSub, $iSubItem, $iDescending)
		Case Else
			Return SetError(3, 0, 0)
	EndSwitch
EndFunc   ;==>_ArraySort

; Private
Func ___ArrayQSort1(ByRef $array, ByRef $left, ByRef $right)
	Local $i, $j, $t
	If $right - $left < 10 Then
		; InsertSort - fastest on small segments (= 25% total speedup)
		For $i = $left + 1 To $right
			$t = $array[$i]
			$j = $i
			While $j > $left _
					And ((IsNumber($array[$j - 1]) = IsNumber($t) And $array[$j - 1] > $t) _
					Or (IsNumber($array[$j - 1]) <> IsNumber($t) And String($array[$j - 1]) > String($t)))
				$array[$j] = $array[$j - 1]
				$j = $j - 1
			WEnd
			$array[$j] = $t
		Next
		Return
	EndIf

	; QuickSort - fastest on large segments
	Local $pivot = $array[Int(($left + $right) / 2)]
	Local $L = $left
	Local $R = $right
	Do
		While ((IsNumber($array[$L]) = IsNumber($pivot) And $array[$L] < $pivot) _
				Or (IsNumber($array[$L]) <> IsNumber($pivot) And String($array[$L]) < String($pivot)))
			;While $array[$L] < $pivot
			$L = $L + 1
		WEnd
		While ((IsNumber($array[$R]) = IsNumber($pivot) And $array[$R] > $pivot) _
				Or (IsNumber($array[$R]) <> IsNumber($pivot) And String($array[$R]) > String($pivot)))
			;	While $array[$R] > $pivot
			$R = $R - 1
		WEnd
		; Swap
		If $L <= $R Then
			$t = $array[$L]
			$array[$L] = $array[$R]
			$array[$R] = $t
			$L = $L + 1
			$R = $R - 1
		EndIf
	Until $L > $R

	___ArrayQSort1($array, $left, $R)
	___ArrayQSort1($array, $L, $right)
EndFunc   ;==>__ArrayQSort1

; Private
Func ___ArrayQSort2(ByRef $array, ByRef $left, ByRef $right, ByRef $dim2, ByRef $sortIdx, ByRef $decend)
	If $left >= $right Then Return
	Local $t, $d2 = $dim2 - 1
	Local $pivot = $array[Int(($left + $right) / 2) ][$sortIdx]
	Local $L = $left
	Local $R = $right
	Do
		If $decend Then
			While ((IsNumber($array[$L][$sortIdx]) = IsNumber($pivot) And $array[$L][$sortIdx] > $pivot) _
					Or (IsNumber($array[$L][$sortIdx]) <> IsNumber($pivot) And String($array[$L][$sortIdx]) > String($pivot)))
				;While $array[$L][$sortIdx] > $pivot
				$L = $L + 1
			WEnd
			While ((IsNumber($array[$R][$sortIdx]) = IsNumber($pivot) And $array[$R][$sortIdx] < $pivot) _
					Or (IsNumber($array[$R][$sortIdx]) <> IsNumber($pivot) And String($array[$R][$sortIdx]) < String($pivot)))
				;While $array[$R][$sortIdx] < $pivot
				$R = $R - 1
			WEnd
		Else
			While ((IsNumber($array[$L][$sortIdx]) = IsNumber($pivot) And $array[$L][$sortIdx] < $pivot) _
					Or (IsNumber($array[$L][$sortIdx]) <> IsNumber($pivot) And String($array[$L][$sortIdx]) < String($pivot)))
				;While $array[$L][$sortIdx] < $pivot
				$L = $L + 1
			WEnd
			While ((IsNumber($array[$R][$sortIdx]) = IsNumber($pivot) And $array[$R][$sortIdx] > $pivot) _
					Or (IsNumber($array[$R][$sortIdx]) <> IsNumber($pivot) And String($array[$R][$sortIdx]) > String($pivot)))
				;While $array[$R][$sortIdx] > $pivot
				$R = $R - 1
			WEnd
		EndIf
		If $L <= $R Then
			For $x = 0 To $d2
				$t = $array[$L][$x]
				$array[$L][$x] = $array[$R][$x]
				$array[$R][$x] = $t
			Next
			$L = $L + 1
			$R = $R - 1
		EndIf
	Until $L > $R

	___ArrayQSort2($array, $left, $R, $dim2, $sortIdx, $decend)
	___ArrayQSort2($array, $L, $right, $dim2, $sortIdx, $decend)
EndFunc   ;==>__ArrayQSort2







;-------------------------------------------------------------------------------
; NEW SORTING
;-------------------------------------------------------------------------------
Func _ArraySort2(ByRef $avArray, $iDescending = 0, $iStart = 0, $iEnd = 0, $iSubItem = 0)
	If Not IsArray($avArray) Then Return SetError(1, 0, 0)

	Local $iUBound = UBound($avArray)-1

	; Bounds checking
	If $iEnd < 1 Or $iEnd > $iUBound Then $iEnd = $iUBound
	If $iStart < 0 Then $iStart = 0
	If $iStart > $iEnd Then Return SetError(2, 0, 0)

	; Descending sort setup

	; Sort
	Switch UBound($avArray, 0)
		Case 1
			__ArrayQuickSort1D2($avArray, $iStart, $iEnd)
			If $iDescending Then _ArrayReverse($avArray)
		Case 2
			Local $iSubMax = UBound($avArray, 2)-1
			If $iSubItem > $iSubMax Then Return SetError(3, 0, 0)
			
			If $iDescending Then
				$iDescending = -1
			Else
				$iDescending = 1
			EndIf

			__ArrayQuickSort2D2($avArray, $iDescending, $iStart, $iEnd, $iSubItem, $iSubMax) 
		Case Else
			Return SetError(4, 0, 0)
	EndSwitch

EndFunc   ;==>_ArraySort

; Private
Func __ArrayQuickSort1D2(ByRef $avArray, ByRef $iStart, ByRef $iEnd)
	If $iEnd <= $iStart Then Return

	; InsertionSort (faster for smaller segments)
	If ($iEnd - $iStart) < 15 Then
		Local $i, $j, $vTmp, $vCur
		For $i = $iStart+1 To $iEnd
			$vTmp = $avArray[$i]

			If IsNumber($vTmp) Then
				For $j = $i-1 To $iStart Step -1
					$vCur = $avArray[$j]
					If ($vTmp >= $vCur And IsNumber($vCur)) Or (Not IsNumber($vCur) And StringCompare($vTmp, $vCur) >= 0) Then ExitLoop
					$avArray[$j+1] = $vCur
				Next
			Else
				For $j = $i-1 To $iStart Step -1
					If (StringCompare($vTmp, $avArray[$j]) >= 0) Then ExitLoop
					$avArray[$j+1] = $avArray[$j]
				Next
			EndIf

			$avArray[$j+1] = $vTmp
		Next
		Return
	EndIf

	; QuickSort
	Local $vTmp, $L = $iStart, $R = $iEnd, $vPivot = $avArray[Int(($iStart + $iEnd) / 2)], $fNum = IsNumber($vPivot)
	Do
		If $fNum Then
			While ($avArray[$L] < $vPivot And IsNumber($avArray[$L])) Or (Not IsNumber($avArray[$L]) And StringCompare($avArray[$L], $vPivot) < 0)
				$L += 1
			WEnd
			While ($avArray[$R] > $vPivot And IsNumber($avArray[$R])) Or (Not IsNumber($avArray[$R]) And StringCompare($avArray[$R], $vPivot) > 0)
				$R -= 1
			WEnd
		Else
			While (StringCompare($avArray[$L], $vPivot) < 0)
				$L += 1
			WEnd
			While (StringCompare($avArray[$R], $vPivot) > 0)
				$R -= 1
			WEnd
		EndIf

		; Swap
		If $L <= $R Then
			$vTmp = $avArray[$L]
			$avArray[$L] = $avArray[$R]
			$avArray[$R] = $vTmp
			$L += 1
			$R -= 1
		EndIf
	Until $L > $R

	__ArrayQuickSort1D2($avArray, $iStart, $R)
	__ArrayQuickSort1D2($avArray, $L, $iEnd)
EndFunc

; Private
Func __ArrayQuickSort2D2(ByRef $avArray, ByRef $iStep, ByRef $iStart, ByRef $iEnd, ByRef $iSubItem, ByRef $iSubMax)
	If $iEnd <= $iStart Then Return
#cs
	; InsertionSort (faster for smaller segments)
	If ($iEnd - $iStart) < 15 Then
		Local $i, $j, $k, $vTmp[$iSubMax+1]
		For $i = $iStart+1 To $iEnd
			For $k = 0 To $iSubMax
				$vTmp[$k] = $avArray[$i][$k]
			Next

			If IsNumber($vTmp[$iSubItem]) Then
				For $j = $i-1 To $iStart Step -1
					If ($iStep*($vTmp[$iSubItem] - $avArray[$j][$iSubItem]) >= 0 And IsNumber($avArray[$j][$iSubItem])) Or (Not IsNumber($avArray[$j][$iSubItem]) And $iStep*StringCompare($vTmp[$iSubItem], $avArray[$j][$iSubItem]) >= 0) Then ExitLoop
					For $k = 0 To $iSubMax
						$avArray[$j+1][$k] = $avArray[$j][$k]
					Next
				Next
			Else
				For $j = $i-1 To $iStart Step -1
					If ($iStep*StringCompare($vTmp[$iSubItem], $avArray[$j][$iSubItem]) >= 0) Then ExitLoop
					For $k = 0 To $iSubMax
						$avArray[$j+1][$k] = $avArray[$j][$k]
					Next
				Next
			EndIf

			$j += 1
			For $k = 0 To $iSubMax
				$avArray[$j][$k] = $vTmp[$k]
			Next
		Next
		Return
	EndIf
#ce
	; QuickSort
	Local $i, $vTmp, $L = $iStart, $R = $iEnd, $vPivot = $avArray[Int(($iStart + $iEnd) / 2)][$iSubItem], $fNum = IsNumber($vPivot)
	Do
		If $fNum Then
			While ($iStep*($avArray[$L][$iSubItem] - $vPivot) < 0 And IsNumber($avArray[$L][$iSubItem])) Or (Not IsNumber($avArray[$L][$iSubItem]) And $iStep*StringCompare($avArray[$L][$iSubItem], $vPivot) < 0)
				$L += 1
			WEnd
			While ($iStep*($avArray[$R][$iSubItem] - $vPivot) > 0 And IsNumber($avArray[$R][$iSubItem])) Or (Not IsNumber($avArray[$R][$iSubItem]) And $iStep*StringCompare($avArray[$R][$iSubItem], $vPivot) > 0)
				$R -= 1
			WEnd
		Else
			While ($iStep*StringCompare($avArray[$L][$iSubItem], $vPivot) < 0)
				$L += 1
			WEnd
			While ($iStep*StringCompare($avArray[$R][$iSubItem], $vPivot) > 0)
				$R -= 1
			WEnd
		EndIf

		; Swap
		If $L <= $R Then
			For $i = 0 To $iSubMax
				$vTmp = $avArray[$L][$i]
				$avArray[$L][$i] = $avArray[$R][$i]
				$avArray[$R][$i] = $vTmp
			Next
			$L += 1
			$R -= 1
		EndIf
	Until $L > $R

	__ArrayQuickSort2D2($avArray, $iStep, $iStart, $R, $iSubItem, $iSubMax)
	__ArrayQuickSort2D2($avArray, $iStep, $L, $iEnd, $iSubItem, $iSubMax)
EndFunc
