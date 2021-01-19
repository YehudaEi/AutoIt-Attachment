#include-once
#include <math.au3>
#Include <String.au3>

;===============================================================================
;
; Description:      Returns the Hamming Distance between two strings of
;					identical length
; Parameter(s):     $sString1	- First String to be Compared
;					$sString2	- Second String to be Compared
; Requirement(s):   None
; Return Value(s):  On Success - Hamming Distance as an Integer
;                   On Failure - -1  and Set
;                                   @ERROR to:  1 - $sString1 and $sString2
;													are not the same length
; Author(s):        Ben Gibb
; Note(s):			http://en.wikipedia.org/wiki/Hamming_distance
;
;===============================================================================
Func _StringHammingDist($sString1, $sString2)
	Local $iEachChar
	Local $iHammingDist = 0
	Local $iString1Len = StringLen($sString1)
	If $iString1Len <> StringLen($sString2) Then
		SetError(1)
		Return -1
	EndIf
	For $iEachChar = 1 To $iString1Len
		If StringMid($sString1, $iEachChar, 1) <> StringMid($sString2, $iEachChar, 1) Then
			$iHammingDist = $iHammingDist + 1
		EndIf
	Next
	Return $iHammingDist
EndFunc   ;==>_StringHammingDist

;===============================================================================
;
; Description:      Returns an array of nGrams for a given string
; Parameter(s):     $sString	- The string to be split into nGrams
;					$iSegmentSize	- The length of the nGrams used
; Requirement(s):   String.au3
; Return Value(s):  On Success - An array containing the nGrams from $sString
;                   On Failure - -1  and Set
;                                   @ERROR to:  1 - Empty String: $sString
;                                               2 - $iSegmentSize < 2
; Author(s):        Ben Gibb
; Note(s):			Used by _StringFuzzyCompareDice()
;
;===============================================================================
Func _StringToNgrams($sString, $iSegmentSize)
	Select
		Case $sString = ""
			SetError(1)
			Return -1
		Case $iSegmentSize < 2
			SetError(2)
			Return -1
	EndSelect
	Local $iSplitingLoop, $iNgramCount, $iStringLength, $asNgrams[1]
	$sString = _StringRepeat("%", $iSegmentSize - 1) & $sString & _StringRepeat("#", $iSegmentSize - 1)
	$iStringLength = StringLen($sString)
	$iNgramCount = $iStringLength - $iSegmentSize
	ReDim $asNgrams[$iNgramCount]
	For $iSplitingLoop = 0 To $iNgramCount - 1
		$asNgrams[$iSplitingLoop] = StringMid($sString, $iSplitingLoop + 1, $iSegmentSize)
	Next
	Return $asNgrams
EndFunc   ;==>_StringToNgrams

;===============================================================================
;
; Description:      Returns the Dice Coefficient of two strings
; Parameter(s):     $sString1	- First String to be Compared
;					$sString2	- Second String to be Compared
;					$iSegmentSize	- The length of the nGrams used
; Requirement(s):   None
; Return Value(s):  On Success - Dice Coefficient of two strings as a float
;                   On Failure - -1  and Set
;                                   @ERROR to:  1 - Empty String: $sString1
;												2 -	Empty String: $sString2
;                                               3 - $iSegmentSize < 2
; Author(s):        Ben Gibb
; Note(s):			http://en.wikipedia.org/wiki/Dice_coefficient
;				 	A good Dice Coefficient value is greater than 0.33
;
;===============================================================================
Func _StringFuzzyCompareDice($sString1, $sString2, $iSegmentSize)
	If $iSegmentSize < 2 Then
		SetError(3)
		Return -1
	EndIf
	Local $asNgram1 = _StringToNgrams($sString1, $iSegmentSize)
	If @error = 1 Then
		SetError(1)
		Return -1
	EndIf
	Local $asNgram2 = _StringToNgrams($sString2, $iSegmentSize)
	If @error = 1 Then
		SetError(2)
		Return -1
	EndIf
	Local $iSharedNgrams, $iNgramCount1, $iNgramCount2
	Local $sNgram1, $sNgram2, $iTotalNgrams1, $iTotalNgrams2
	
	$iTotalNgrams1 = UBound($asNgram1) - 1
	$iTotalNgrams2 = UBound($asNgram2) - 1
	;	If ($iNgramCount1 = 0) Or ($iNgramCount2 = 0) Then
	;		Return
	;	EndIf
	For $iNgramCount1 = 0 To $iTotalNgrams1
		$sNgram1 = $asNgram1[$iNgramCount1]
		For $iNgramCount2 = 0 To $iTotalNgrams2
			$sNgram2 = $asNgram2[$iNgramCount2]
			If (Not $sNgram1 = "") And (Not $sNgram2 = "") Then
				If $sNgram1 = $sNgram2 Then
					$iSharedNgrams = $iSharedNgrams + 1
				EndIf
			EndIf
		Next
	Next
	Return (2 * $iSharedNgrams) / ($iTotalNgrams1 + $iTotalNgrams2)
EndFunc   ;==>_StringFuzzyCompareDice

;===============================================================================
;
; Description:      Returns the length of the longest common subsequence
; Parameter(s):     $sString1	- First String to be Compared
;					$sString2	- Second String to be Compared
; Requirement(s):   None
; Return Value(s):  On Success - Longest common subsequence as an Integer
;                   On Failure - -1  and Set
;                                   @ERROR to:  1 - Empty String: $sString1
;												2 -	Empty String: $sString2
; Author(s):        Ben Gibb
; Note(s):			http://en.wikipedia.org/wiki/Longest_common_subsequence
;				 	Should not be confused with "longest common substring"
;
;===============================================================================
Func _StringLCSLength($sString1, $sString2)
	Local $iString1Len = StringLen($sString1)
	Local $iString2Len = StringLen($sString2)
	Select
		Case $iString1Len = 0
			SetError(1)
			Return -1
		Case $iString2Len = 0
			SetError(2)
			Return -1
	EndSelect
	Local $aiMatrix[$iString1Len + 1][$iString2Len + 1]
	Local $iString1Loop, $iString2Loop
	
	For $iString1Loop = 0 To $iString1Len
		$aiMatrix[$iString1Loop][0] = 0
	Next
	For $iString2Loop = 0 To $iString2Len
		$aiMatrix[0][$iString2Loop] = 0
	Next
	For $iString1Loop = 1 To $iString1Len
		For $iString2Loop = 1 To $iString2Len
			If StringMid($sString1, $iString1Loop, 1) = StringMid($sString2, $iString2Loop, 1) Then
				$aiMatrix[$iString1Loop][$iString2Loop] = $aiMatrix[$iString1Loop - 1][$iString2Loop - 1] + 1
			Else
				$aiMatrix[$iString1Loop][$iString2Loop] = _Max($aiMatrix[$iString1Loop][$iString2Loop - 1], $aiMatrix[$iString1Loop - 1][$iString2Loop])
			EndIf
		Next
	Next
	Return $aiMatrix[$iString1Len][$iString2Len]
EndFunc   ;==>_StringLCSLength



;===============================================================================
;
; Description:      Returns the edit distance between two strings.
; Parameter(s):     $sString1	- First String to be Compared
;					$sString2	- Second String to be Compared
; Requirement(s):   math.au3
; Return Value(s):  On Success - The edit distance as an Integer
;                   On Failure - -1  and Set
;                                   @ERROR to:  1 - Empty String: $sString1
;												2 -	Empty String: $sString2
; Author(s):        Ben Gibb
; Note(s):			http://en.wikipedia.org/wiki/Damerau-Levenshtein_distance
;
;===============================================================================
Func _StringFuzzyCompareDamLevDist($sString1, $sString2)
	Local $iString1Len = StringLen($sString1)
	Local $iString2Len = StringLen($sString2)
	Select
		Case $iString1Len = 0
			SetError(1)
			Return -1
		Case $iString2Len = 0
			SetError(2)
			Return -1
	EndSelect

	Local $aiMatrix[$iString1Len + 1][$iString2Len + 1]
	Local $iString1Loop, $iString2Loop, $iCost

	For $iString1Loop = 0 To $iString1Len
		$aiMatrix[$iString1Loop][0] = $iString1Loop
	Next
	For $iString2Loop = 1 To $iString2Len
		$aiMatrix[0][$iString2Loop] = $iString2Loop
	Next

	For $iString1Loop = 1 To $iString1Len
		For $iString2Loop = 1 To $iString2Len
			If StringMid($sString1, $iString1Loop, 1) = StringMid($sString2, $iString2Loop, 1) Then
				$iCost = 0
			Else
				$iCost = 1
			EndIf
			$aiMatrix[$iString1Loop][$iString2Loop] = _Min(_Min($aiMatrix[$iString1Loop - 1][$iString2Loop] + 1, $aiMatrix[$iString1Loop][$iString2Loop - 1] + 1), $aiMatrix[$iString1Loop - 1][$iString2Loop - 1] + $iCost)
			If ($iString1Loop > 1) And ($iString2Loop > 1) And (StringMid($sString1, $iString1Loop, 1) = StringMid($sString2, $iString2Loop - 1, 1)) And (StringMid($sString1, $iString1Loop - 1, 1) = StringMid($sString2, $iString2Loop, 1)) Then
				$aiMatrix[$iString1Loop][$iString2Loop] = _Min($aiMatrix[$iString1Loop][$iString2Loop], $aiMatrix[$iString1Loop - 2][$iString2Loop - 2] + $iCost)
			EndIf
		Next
	Next
	Return $aiMatrix[$iString1Len][$iString2Len]
EndFunc   ;==>_StringFuzzyCompareDamLevDist
