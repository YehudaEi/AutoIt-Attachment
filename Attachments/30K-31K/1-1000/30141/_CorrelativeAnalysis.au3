; #FUNCTION# ;===============================================================================
;
; Name...........:  _VectorDelta
; Description ...: Returns a similarity score between two lists
; Syntax.........: _DateDiff($sType, $sStartDate, $sEndDate)
; Parameters ....: $aDatasetA, $aDatasetB - One of the following:
; Return values .: Success - Similarity score.
;                  Failure - potentially encounters division by zero.
; Author ........: JRowe, derived from php by Timothy Robert Keal, aka "alias Jargon"
; Modified.......:
; Remarks .......: Not to be used directly, for use by _Similarity()
; Related .......: _Similarity
; Link ..........;
; Example .......; Yes
;
; ;==========================================================================================
Func _VectorDelta($aDatasetA, $aDatasetB)
	;count
	Local $iCount = 0
	;return
	Local $return = 0
	;temp value
	Local $tempValue = 0
	;index
	Local $index = 0
	;value
	Local $value = 0

	;iterate through each value in $aDatasetA and compare to values in $aDatasetB
	;Iterate comparisons from here...
	For $value In $aDatasetA
		;increment index
		$index += 1
		;check if index is lesser than or equal to the size of $aDatasetB
		If $index <= UBound($aDatasetB) Then
			$iCount += 1
			$tempValue = $aDatasetB[$index - 1] - $value
			$tempValueSquared = $tempValue * $tempValue
			$return += $tempValueSquared
		EndIf
	Next
	;... to here.

	;Check the count of compared dataset pairs, return the square root of the summed comparisons or else 0
	If $iCount > 0 Then
		If $return > 0 Then
			$return = Sqrt($return)
		EndIf
	EndIf

	;Return the result.
	Return $return
EndFunc   ;==>_VectorDelta

; #FUNCTION# ;===============================================================================
;
; Name...........:  _Similarity
; Description ...: Returns a similarity score between a list of elements and a set of other lists
; Syntax.........: _Similarity($aArrayH, $iIndexA, $iIndexB)
; Parameters ....: $aArrayH, $iIndexA, $iIndexB
; Return values .: Success - Similarity score comparing $aArrayH[$iIndexA] to $aArrayH[$iIndexB] against $iIndexA to each other array.
;                  Failure - potentially encounters division by zero.
; Author ........: JRowe, derived from php by Timothy Robert Keal, aka "alias Jargon"
; Modified.......:
; Remarks .......: Compares element to element, doesn't do iterative correlation.
; Related .......: _VectorDelta
; Link ..........;
; Example .......; Yes
;
; ;==========================================================================================
Func _Similarity($aArrayH, $iIndexA, $iIndexB)
	;return
	Local $return = 0
	;tally
	Local $tally = 0
	;Vector delta of A to B
	Local $similarityOfAToB = _VectorDelta($aArrayH[$iIndexA], $aArrayH[$iIndexB])
	Local $index = 0

	;Iterate through each array, comparing similarity of every array
	For $iIndexC In $aArrayH
		$index += 1
		;don't include self comparisons in $result
		If ($index<> $iIndexA) AND ($index<>$iIndexB) Then
			;increment tally of comparisons
			$tally += 1
			;Get Vector Delta of array[A] and array[index-1]
			$similarityOfAToList = _VectorDelta($aArrayH[$iIndexA], $aArrayH[$index-1])
			;Get Vector Delta of array[B] and array[index-1]
			$similarityOfBToList = _VectorDelta($aArrayH[$iIndexB], $aArrayH[$index-1])
			;increment $return if similarity is greater than A to list
			If $similarityOfAToB > $similarityOfAToList Then $return += 1
			;increment $return if similarity is greater than B to list
			If $similarityOfAToB > $similarityOfBToList Then $return += 1
		EndIf
	Next
	;return $return divided by 2 over the number of tallied comparisons
	Return 1-($return / 2 / $tally)
EndFunc   ;==>_Similarity
