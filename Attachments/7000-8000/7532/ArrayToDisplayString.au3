;===============================================================================
;
; Function Name:    _ArrayToDisplayString()
; Description:      Converts an Array of up to 4 dimensions into a string
;						displaying the contents of the array.
;						NOTE: now supports nested arrays
; Parameter(s):     $vDispVar - Array to convert
;					$iStyle[optional] - 0 = Cascading style (Default)
;					$iLevel - used for recursion, DO NOT CHANGE
; Return Value(s):  If array is passed - String representing array
;					If non-array is passed - String representing variable
; Author(s):        Ben Brightwell
;
;===============================================================================
Func _ArrayToDisplayString($vDispVar, $iStyle = 0, $iLevel = 0)
	If $iStyle <> 0 And $iStyle <> 1 Then
		$iStyle = 0
	EndIf
	$iNumDims = UBound($vDispVar, 0) ; Number of dimensions of $vDispVar
	Local $sDisplayStr = ""
	Local $iDimCounter = "" ; Main Dimension Counter
	Local $iCounter1 = "" ; Nested Counter
	Local $iCounter2 = "" ; Nested Counter
	Local $iCounter3 = "" ; Nested Counter
	Local $iCounter4 = "" ; Nested Counter
	Select
	Case $iNumDims == 1
		For $iCounter1 = 0 To UBound($vDispVar, 1) - 1
			If $iLevel > 0 Then
				For $i = 1 To $iLevel
					$sDisplayStr &= "     "
				Next
			EndIf
			If IsArray($vDispVar[$iCounter1]) Then
				$sDisplayStr &= "[" & $iCounter1 & "]= " & @CRLF
			Else
				$sDisplayStr &= "[" & $iCounter1 & "]= "
			EndIf
			$sDisplayStr &= _ArrayToDisplayString($vDispVar[$iCounter1], $iStyle, $iLevel+1)
		Next
	Case $iNumDims == 2
		For $iCounter1 = 0 To UBound($vDispVar, 1) - 1
			If $iStyle == 0 Then
				For $i = 1 To $iLevel
					$sDisplayStr &= "     "
				Next
				$sDisplayStr &= "[" & $iCounter1 & "]= " & @CRLF
			EndIf
			For $iCounter2 = 0 To UBound($vDispVar, 2) - 1
				If $iStyle == 0 Then
					$sDisplayStr &= "     "
				EndIf
				If $iLevel > 0 Then
					For $i = 1 To $iLevel
						$sDisplayStr &= "     "
					Next
				EndIf
				If $iStyle = 0 Then
					If IsArray($vDispVar[$iCounter1][$iCounter2]) Then
						$sDisplayStr &= "[" & $iCounter2 & "]= " & @CRLF
					Else
						$sDisplayStr &= "[" & $iCounter2 & "]= "
					EndIf
				ElseIf $iStyle == 1 Then
					If IsArray($vDispVar[$iCounter1][$iCounter2]) Then
						$sDisplayStr &= "[" & $iCounter1 & "][" & $iCounter2 & "]= " & @CRLF
					Else
						$sDisplayStr &= "[" & $iCounter1 & "][" & $iCounter2 & "]= "
					EndIf
				EndIf
				$sDisplayStr &= _ArrayToDisplayString($vDispVar[$iCounter1][$iCounter2], $iStyle, $iLevel+1)
			Next
		Next
	Case $iNumDims == 3
		For $iCounter1 = 0 To UBound($vDispVar, 1) - 1
			If $iStyle == 0 Then
				For $i = 1 To $iLevel
					$sDisplayStr &= "     "
				Next
				$sDisplayStr &= "[" & $iCounter1 & "]= " & @CRLF
			EndIf
			For $iCounter2 = 0 To UBound($vDispVar, 2) - 1
				If $iStyle == 0 Then
					For $i = 1 To $iLevel
						$sDisplayStr &= "     "
					Next
					$sDisplayStr &= "     [" & $iCounter2 & "]= " & @CRLF
				EndIf
				For $iCounter3 = 0 To UBound($vDispVar, 3) - 1
					If $iStyle == 0 Then
						$sDisplayStr &= "          "
					EndIf
					If $iLevel > 0 Then
						For $i = 1 To $iLevel
							$sDisplayStr &= "     "
						Next
					EndIf
					If $iStyle == 0 Then
						If IsArray($vDispVar[$iCounter1][$iCounter2][$iCounter3]) Then
							$sDisplayStr &= "[" & $iCounter3 & "]= " & @CRLF
						Else
							$sDisplayStr &= "[" & $iCounter3 & "]= "
						EndIf
					ElseIf $iStyle == 1 Then
						If IsArray($vDispVar[$iCounter1][$iCounter2][$iCounter3]) Then
							$sDisplayStr &= "[" & $iCounter1 & "][" & $iCounter2 & "][" & $iCounter3 & "]= " & @CRLF
						Else
							$sDisplayStr &= "[" & $iCounter1 & "][" & $iCounter2 & "][" & $iCounter3 & "]= "
						EndIf
					EndIf
					$sDisplayStr &= _ArrayToDisplayString($vDispVar[$iCounter1][$iCounter2][$iCounter3], $iStyle, $iLevel+1)
				Next
			Next
		Next
	Case $iNumDims == 4
		For $iCounter1 = 0 To UBound($vDispVar, 1) - 1
			If $iStyle == 0 Then
				For $i = 1 To $iLevel
					$sDisplayStr &= "     "
				Next
				$sDisplayStr &= "[" & $iCounter1 & "]= " & @CRLF
			EndIf
			For $iCounter2 = 0 To UBound($vDispVar, 2) - 1
				If $iStyle == 0 Then
					For $i = 1 To $iLevel
						$sDisplayStr &= "     "
					Next
					$sDisplayStr &= "     [" & $iCounter2 & "]= " & @CRLF
				EndIf
				For $iCounter3 = 0 To UBound($vDispVar, 3) - 1
					If $iStyle == 0 Then
						For $i = 1 To $iLevel
							$sDisplayStr &= "     "
						Next
						$sDisplayStr &= "          [" & $iCounter3 & "]= " & @CRLF
					EndIf
					For $iCounter4 = 0 To UBound($vDispVar, 4) - 1
						If $iStyle == 0 Then
							$sDisplayStr &= "               "
						EndIf
						If $iLevel > 0 Then
							For $i = 1 To $iLevel
								$sDisplayStr &= "     "
							Next
						EndIf
						If $iStyle == 0 Then
							If IsArray($vDispVar[$iCounter1][$iCounter2][$iCounter3][$iCounter4]) Then
								$sDisplayStr &= "[" & $iCounter4 & "]= " & @CRLF
							Else
								$sDisplayStr &= "[" & $iCounter4 & "]= "
							EndIf
						ElseIf $iStyle == 1 Then
							If IsArray($vDispVar[$iCounter1][$iCounter2][$iCounter3][$iCounter4]) Then
								$sDisplayStr &= "[" & $iCounter1 & "][" & $iCounter2 & "][" & $iCounter3 & "][" & $iCounter4 & "]= " & @CRLF
							Else
								$sDisplayStr &= "[" & $iCounter1 & "][" & $iCounter2 & "][" & $iCounter3 & "][" & $iCounter4 & "]= "
							EndIf
						EndIf
						$sDisplayStr &= _ArrayToDisplayString($vDispVar[$iCounter1][$iCounter2][$iCounter3][$iCounter4], $iStyle, $iLevel+1)
					Next
				Next
			Next
		Next
	EndSelect
	If $iNumDims == 0 Then
		$sDisplayStr &= $vDispVar & @CRLF
	EndIf
	Return $sDisplayStr
EndFunc