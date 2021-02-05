; #FUNCTION# ====================================================================================================================
; Name...........: _ArrayRandom
; Description ...: Randomize the row order of (part of) a 1D or 2D array.
; Syntax.........: _ArrayRandom(ByRef $avArray, $iStart = 0, $iEnd = 0)
; Parameters ....: $avArray     - Array to randomize
;                  $iStart      - [optional] Index of array to start at
;                  $iEnd        - [optional] Index of array to stop at
; Return values .: Success - 1
;                  Failure - 0, sets @error:
;                  |1 - $avArray is not an array
;                  |2 - $iStart is greater than $iEnd
; Author ........: Tom Vernooij
; Modified.......:
; Remarks .......: Based on Yashied's method
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _ArrayRandom(ByRef $avArray, $iStart=0, $iEnd=0)
	If Not IsArray($avArray) Then Return SetError(1,0,0)

	Local $iRow, $iCol, $rRow, $Temp, $numCols = UBound($avArray,2), $Ubound = UBound($avArray) -1

	; Bounds checking
	If $iEnd < 1 Or $iEnd > $UBound Then $iEnd = $UBound
	If $iStart < 0 Then $iStart = 0
	If $iStart > $iEnd Then Return SetError(2, 0, 0)

	;	for 2 dimentional arrays:
	If $numCols Then
		For $iRow = $iStart To $iEnd ;for each row...
			$rRow = Random($iStart, $iEnd, 1) ;...select a random row
			For $iCol = 0 To $numCols -1	;swich the values for each cell in the rows
				$Temp = $avArray[$iRow][$iCol]
				$avArray[$iRow][$iCol] = $avArray[$rRow][$iCol]
				$avArray[$rRow][$iCol] = $Temp
			Next
		Next

	;	for 1 dimentional arrays:
	Else
		For $iRow = $iStart To $iEnd ;for each cell...
			$rRow = Random($iStart, $iEnd, 1) ;...select a random cell
			$Temp = $avArray[$iRow]	;switch the values in the cells
			$avArray[$iRow] = $avArray[$rRow]
			$avArray[$rRow] = $Temp
		Next
	EndIf
	Return 1
EndFunc
