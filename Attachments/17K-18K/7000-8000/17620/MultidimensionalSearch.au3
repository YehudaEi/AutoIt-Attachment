#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.2.8.1
 Author:         WeaponX
 
 Created: 11/16/2007

 Script Function:
	Recursively search multidimensional array (any number of dimensions)
	
 Usage:
	_SearchMultiDimensional(ByRef $smdArray, $smdValue, $smdCaseSense = False, $smdPartialMatch = False, $smdDepth = 1, $smdElement = "$smdArray")
	smdArray = Multidimensional Array
	smdValue = The value to search for
	smdCaseSense = Case sensitivity
	smdPartialMatch = Alloe partial matches
	smdDepth = Current dimension, starting at 1
	smdElement = String to execute

#ce ----------------------------------------------------------------------------

Func _SearchMultiDimensional(ByRef $smdArray, $smdValue, $smdCaseSense = False, $smdPartialMatch = False, $smdDepth = 1, $smdElement = "$smdArray")

	;Loop through all elements within the current dimension
	For $X = 0 to Ubound($smdArray, $smdDepth)
		
		;Recurse only to # of dimensions
		If $smdDepth < Ubound($smdArray, 0) Then
			$smdResult = _SearchMultiDimensional($smdArray, $smdValue, $smdCaseSense, $smdPartialMatch, $smdDepth + 1, $smdElement & "[" & $X & "]")
			If $smdResult <> "" Then Return $X & "," & $smdResult
		EndIf
		
		;If case sensitive
		If $smdCaseSense Then
			;If partial match is allowed
			If $smdPartialMatch Then
				If StringInStr(Execute($smdElement & "[" & $X & "]"),$smdValue,1) Then Return String($X)
			Else
				If Execute($smdElement & "[" & $X & "]") == $smdValue Then Return String($X)
			EndIf
		Else
			;If partial match is allowed
			If $smdPartialMatch Then
				If StringInStr(Execute($smdElement & "[" & $X & "]"),$smdValue,0) Then Return String($X)
			Else
				If Execute($smdElement & "[" & $X & "]") = $smdValue Then Return String($X)
			EndIf
		EndIf
	Next
	
	Return ""
EndFunc