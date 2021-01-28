; #FUNCTION# ;===============================================================================
;
; Name...........: _StringDiff
; Description ...: Returns the difference between 2 strings, expressed in the type requested
; Syntax.........: _StringDiff($sFirst,$sSecond[,$iStart = 1][,$iReturn = 0})
; Parameters ....: $sFirst - First String
;                  $sSecond - String to match to $sFirst, this is the string which is checked for differences.
;                  $iReturn - One of the following:
;                  |0 - Returns character that differs (Default)
;                  |1 - Returns position of character that differs
;                  $iStart - Where to start matching in the first string
;                  |1 to max length of first string. See StringMid() in help
; Return values .: Success - Returns first found difference between 2 strings,
;                  |either position or char depending on $iReturn
;                  Failure - Returns 0 and Sets @Error:
;                  |0 - No error.
;                  |1 - Start pos higher/lower then string length.
;                  |2 - No Difference found.
; Author ........: Emanuel "Datenshi" Lindgren
; Example .......; No
;
; ;==========================================================================================
Func _StringDiff($sFirst, $sSecond, $iStart = 1, $iReturn = 0)
	If StringLen($sFirst) < $iStart Or $iStart < 1 Then SetError(1)
	For $i = $iStart To StringLen($sFirst)
		If StringMid($sFirst, $i, 1) <> StringMid($sSecond, $i, 1) Then
			Switch $iReturn
				Case 0
					Return StringMid($sSecond, $i, 1)
				Case 1
					Return $i
			EndSwitch
		EndIf
	Next
	SetError(2)
EndFunc   ;==>_StringDiff
