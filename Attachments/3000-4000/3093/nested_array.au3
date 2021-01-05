Func _ArrayNGet(ByRef $aArray, $nBound)
	Local $aBound = StringSplit($nBound, ";"), $aNest = $aArray
	For $i = 1 to $aBound[0]
		$aNest = _ArrayNGetLevel($aNest, $aBound[$i])
	Next
	Return $aNest
EndFunc

Func _ArrayNGetLevel(ByRef $aArray, $nLevel)
	Return $aArray[$nLevel]
EndFunc

Func _ArrayDim(ByRef $aArray)
	If not IsArray($aArray) Then Return 0
	If UBound($aArray, 2) Then Return 2
	Return 1
EndFunc

Func _ArrayFill(ByRef $aArray, $sFill = '')
	For $i = 0 to _ArrayLevel($aArray) - 1
		$aArray[$i] = $sFill
	Next
	Return $aArray
EndFunc

Func _ArrayLevel(ByRef $aArray)
	Return UBound($aArray, 1)
EndFunc