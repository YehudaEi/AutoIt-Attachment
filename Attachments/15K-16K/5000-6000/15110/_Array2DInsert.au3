;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;	Function		_Array2DInsert(ByRef $avArray, $iElement [, $sValue=''])
;
;	Description		Insert an Array element on a given position
;					Works with any occurences in 2nd Dimension
;					Works also with 1D-Array
;
;	Parameter		$avArray	Given Array
;					$iElement	0-based Array Index, to insert new Element
;		optional	$sValue		Value of new Element, parts must be seperate with '|'
;
;	Return			Succes		the given Array with new Element
;					Failure		0 and set @error
;								@error = 1	given array is not array
;								@error = 2	given parts of Element too less/much
;								@error = 3	$iElement larger then Ubound
;
;	Author			BugFix  (bugfix@autoit.de)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Func _Array2DInsert(ByRef $avArray, $iElement, $sValue='')
	If ( Not IsArray($avArray) ) Then
		SetError(1)
		Return 0
	EndIf
	Local $UBound2nd = UBound($avArray,2)
	If @error = 2 Then
		Local $arTMP[UBound($avArray)+1]
		If $iElement > UBound($avArray) Then 
			SetError(3)
			Return 0
		EndIf
		For $i = 0 To UBound($arTMP)-1
			If $i < $iElement Then
				$arTMP[$i] = $avArray[$i]
			ElseIf $i = $iElement Then
				If $i < UBound($avArray) Then
					$arTMP[$i] = $sValue
					$arTMP[$i+1] = $avArray[$i]
				Else
					$arTMP[$i] = $sValue
				EndIf
			ElseIf ($i > $iElement) And ($i < UBound($avArray))Then
				$arTMP[$i+1] = $avArray[$i]
			EndIf
		Next
	Else
		Local $arTMP[UBound($avArray)+1][$UBound2nd], $arValue
		If $sValue = '' Then
			For $i = 0 To $UBound2nd-2
				$sValue &= '|'
			Next
		EndIf
		$arValue = StringSplit($sValue, '|')
		If $arValue[0] <> $UBound2nd Then 
			SetError(2)
			Return 0
		EndIf
		If $iElement > UBound($avArray) Then 
			SetError(3)
			Return 0
		EndIf
		For $i = 0 To UBound($arTMP)-1
			If $i < $iElement Then
				For $k = 0 To $UBound2nd-1
					$arTMP[$i][$k] = $avArray[$i][$k]
				Next
			ElseIf $i = $iElement Then
				If $i < UBound($avArray) Then
					For $k = 0 To $UBound2nd-1
						$arTMP[$i][$k] = $arValue[$k+1]
						$arTMP[$i+1][$k] = $avArray[$i][$k]
					Next
				Else
					For $k = 0 To $UBound2nd-1
						$arTMP[$i][$k] = $arValue[$k+1]
					Next
				EndIf
			ElseIf ($i > $iElement) And ($i < UBound($avArray))Then
				For $k = 0 To $UBound2nd-1
					$arTMP[$i+1][$k] = $avArray[$i][$k]
				Next
			EndIf
		Next
	EndIf
	$avArray = $arTMP
EndFunc ;==>_Array2DInsert
