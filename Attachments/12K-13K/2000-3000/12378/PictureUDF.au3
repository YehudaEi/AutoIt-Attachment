;===============================================================================
; 
; Description:      Formats a string according to the way specified by $sPicture
; Syntax:           _Picture($sPicture, $sString2Format, $sAPriority = "DL", $sXPriority = "DLC")
;
; Parameter(s):    	$sPicture = The picture to use for formatting the string. See notes for details.
;                   $iNumber = The string to be formatted.
;
;
;
; Requirement(s):   None
; Return Value(s):  On Success - Returns a string representation of $iNumber formatted according to $sPicture
;					On Failure - Returns an empty string "" if no files are found and sets @Error on errors
;						@Error=1 $sPicture length is zero
;						@Error=2 $sString2Format length is zero
;						@Error=3 $sAPriority is invalid (must have a length of 2 and contain both an N and an L)
;						@Error=4 $sXPriority is invalid (must have a length of 3 and contain an N , an L , and a C)
;						@Error=5 More digit requests in $sPicture than digits in $sString2Format
;						@Error=6 More letter requests in $sPicture than digits in $sString2Format
;						@Error=7 "a" request failed because no more letters or digits were available
;						@Error=8 "X" request failed because no more letters, digits, or numbers were available
; Author(s):        SolidSnake <MetalGX91 at GMail dot com>
; 
; Note(s):			a capital A in $sPicture would be replaced with a numeric character from $sString2Format
;                   a lowercase a in $sPicture would be replaced with an alphanumeric character from $sString2Format in the precedence specified by $iAPriority
;                   an uppercase X in $sPicture would be replaced with an any character from $sString2Format in the precedence specified by $iXPriority
;                   a C in $sPicture would be replaced by a nonalphanumeric character from $sString2Format
;                   a slash / specified that the next character is to be taken literally and not to be replaced.
;                   For example _Picture("AAAC999","123ABC-")  would return ABC-123
; Version :         2.0
;===============================================================================
Func _Picture($sPicture, $sString2Format, $sAPriority = "DL", $sXPriority = "DLC")
	Local $iCounter, $sCurrentChar, $sDigits, $sLetters, $sChars, $iDigitLen, $iLetterLen, $iCharLen, $iDigitPos, $iLetterPos, $iCharPos, $sReturn, $iCounter2, $sP
	If $sPicture = "" Then
		SetError(1)
		Return ""
	EndIf
	If $sString2Format = "" Then
		SetError(2)
		Return ""
	EndIf
	If (StringLen($sAPriority) <> 2) or (Not StringInStr($sAPriority, "D")) or (Not StringInStr($sAPriority, "L")) Then
		SetError(3)
		Return ""
	EndIf
	If (StringLen($sXPriority) <> 3) or (Not StringInStr($sXPriority, "D")) or (Not StringInStr($sXPriority, "L")) or (Not StringInStr($sXPriority, "C")) Then
		SetError(4)
		Return ""
	EndIf
	For $iCounter = 1 To StringLen($sString2Format)
		$sCurrentChar = StringMid($sString2Format, $iCounter, 1)
		Select
			Case StringIsDigit($sCurrentChar)
				$sDigits = $sDigits & $sCurrentChar
			Case StringIsAlpha($sCurrentChar)
				$sLetters = $sLetters & $sCurrentChar
			Case Else
				$sChars = $sChars & $sCurrentChar
		EndSelect
	Next
	$iDigitLen = StringLen($sDigits)
	$iLetterLen = StringLen($sLetters)
	$iCharLen = StringLen($sChars)
	For $iCounter = 1 To StringLen($sPicture)
		$sCurrentChar = StringMid($sPicture, $iCounter, 1)
		Select
			Case $sCurrentChar = "9"
				$iDigitPos = $iDigitPos + 1
				If $iDigitPos > $iDigitLen Then
					SetError(5)
					Return ""
				EndIf
				$sReturn = $sReturn & StringMid($sDigits, $iDigitPos, 1)
			Case $sCurrentChar == "A"
				$iLetterPos = $iLetterPos + 1
				If $iLetterPos > $iLetterLen Then
					SetError(6)
					Return ""
				EndIf
				$sReturn = $sReturn & StringMid($sLetters, $iLetterPos, 1)
			Case $sCurrentChar = "C"
				$iCharPos = $iCharPos + 1
				If $iCharPos > $iCharLen Then
					SetError(6)
					Return ""
				EndIf
				$sReturn = $sReturn & StringMid($sChars, $iCharPos, 1)
			Case $sCurrentChar == "a"
				For $iCounter2 = 1 To 2
					$sP = StringMid($sAPriority, $iCounter2, 1)
					Select
						Case $sP = "D"
							$iDigitPos = $iDigitPos + 1
							If $iDigitPos <= $iDigitLen Then
								$sReturn = $sReturn & StringMid($sDigits, $iDigitPos, 1)
								$iS = 1
								ExitLoop
							EndIf
						Case $sP = "L"
							$iLetterPos = $iLetterPos + 1
							If $iLetterPos <= $iLetterLen Then
								$sReturn = $sReturn & StringMid($sLetters, $iLetterPos, 1)
								$iS = 1
								ExitLoop
							EndIf
					EndSelect
				Next
				If $iS <> 1 Then
					SetError(7)
					Return ""
				EndIf
				$iS = 0
			Case $sCurrentChar == "X"
				For $iCounter2 = 1 To 3
					$sP = StringMid($sXPriority, $iCounter2, 1)
					Select
						Case $sP = "D"
							$iDigitPos = $iDigitPos + 1
							If $iDigitPos <= $iDigitLen Then
								$sReturn = $sReturn & StringMid($sDigits, $iDigitPos, 1)
								$iS = 1
								ExitLoop
							EndIf
						Case $sP = "L"
							$iLetterPos = $iLetterPos + 1
							If $iLetterPos <= $iLetterLen Then
								$sReturn = $sReturn & StringMid($sLetters, $iLetterPos, 1)
								$iS = 1
								ExitLoop
							EndIf
						Case $sP = "C"
							$iCharPos = $iCharPos + 1
							If $iCharPos <= $iCharLen Then
								$sReturn = $sReturn & StringMid($sChars, $iCharPos, 1)
								$iS = 1
								ExitLoop
							EndIf
					EndSelect
				Next
				If $iS <> 1 Then
					SetError(8)
					Return ""
				EndIf
				$iS = 0
			Case $sCurrentChar = "/"
				$iCounter = $iCounter + 1
				$sReturn = $sReturn & StringMid($sPicture, $iCounter, 1)
			Case Else
				$sReturn = $sReturn & $sCurrentChar
		EndSelect
	Next
	Return $sReturn
EndFunc   ;==>_Picture