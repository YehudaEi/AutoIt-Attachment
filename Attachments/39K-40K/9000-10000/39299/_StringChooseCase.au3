#include-once
#include <Array.au3> ;_ArrayToString UDF used in Return

; #FUNCTION# ====================================================================================================================
; Name...........: _StringChooseCase
; Description ...: Returns a string in the selected upper & lower case format: Initial Caps, Title Case, or Sentence Case
; Syntax.........: _StringChooseCase($sMixed, $iOption[, $sCapExcepts = "Mc^|Mac^|O'^|II|III|IV"])
;PROSPECTIVE: add param for Ignore mixed case input
; Parameters ....: $sMixed - 	  	String to change capitalization of.
;                  $iOption -	  	1: Initial Caps: Capitalize Every Word;
;									2: Title Case: Use Standard Rules for the Capitalization of Work Titles;
;									3: Sentence Case: Capitalize as in a sentence.
;                  $sCapExcepts	-  [optional] Exceptions to capitalizing set by options, delimited by | character. Use the ^
;									character to cause the next input character (whatever it is) to be capitalized
; Return values .: Success - Returns the same string, capitalized as selected.
;                  Failure - ""
; Author ........: Tim Curran <tim at timcurran dot com>
; Remarks .......: Option 1 is similar to standard UDF _StringProper, but avoids anomalies like capital following an apostrophe
; Related .......: _StringProper, StringUpper, StringLower
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================


Func _StringChooseCase(ByRef $sMixed, $iOption, $sCapExcepts = "Mc^|Mac^|O'^|I|II|III|IV")
	Local $asSegments, $sTrimtoAlpha, $iCapPos = 1
	$sMixed = StringLower($sMixed)
	Switch $iOption
		Case 1 ;Initial Caps
			$asSegments = StringRegExp($sMixed, ".*?(?:\s|\Z)", 3) ;break by word
		Case 2 ;Title Case
			$asSegments = StringRegExp($sMixed, ".*?(?:\s|\Z)", 3) ;break by word
		Case 3 ;Sentence Case
			$asSegments = StringRegExp($sMixed, ".*?(?:\.\W*|\?\W*|\!\W*|\:\W*|\Z)", 3) ;break by sentence
	EndSwitch
	Local $iLastWord = UBound($asSegments) - 2
	For $iIndex = 0 to $iLastWord ;Capitalize the first letter of each element in array
		$sTrimtoAlpha = StringRegExp($asSegments[$iIndex], "\w.*", 1)
		If @error = 0 Then $iCapPos = StringInStr($asSegments[$iIndex], $sTrimtoAlpha[0])
		If $iOption <> 2 Or $iIndex = 0 Then ;Follow non-cap rules for Title Case if option selected (including cap last word)
			$asSegments[$iIndex] = StringReplace($asSegments[$iIndex], $iCapPos, StringUpper(StringMid($asSegments[$iIndex], $iCapPos, 1)))
		ElseIf $iIndex = $iLastWord Or StringRegExp($asSegments[$iIndex], "\band\b|\bthe\b|\ba\b|\ban\b|\bbut\b|\bfor\b|\bor\b|\bin\b|\bon\b|\bfrom\b|\bto\b|\bby\b|\bover\b|\bof\b|\bto\b|\bwith\b|\bas\b|\bat\b", 0) = 0 Then
			$asSegments[$iIndex] = StringReplace($asSegments[$iIndex], $iCapPos, StringUpper(StringMid($asSegments[$iIndex], $iCapPos, 1)))
		EndIf
		;Capitalization exceptions
		$asSegments[$iIndex] = _CapExcept($asSegments[$iIndex], $sCapExcepts)
	Next
	Return _ArrayToString($asSegments, "")
EndFunc ;==> _StringChooseCase

Func _CapExcept($sSource, $sExceptions)
	Local $sRegExaExcept, $iMakeUCPos
	Local $avExcept = StringSplit($sExceptions, "|")
	For $iIndex = 1 to $avExcept[0]
		$sRegExaExcept = "(?i)\b" & $avExcept[$iIndex]
		$iMakeUCPos = StringInStr($avExcept[$iIndex], "^")
		If $iMakeUCPos <> 0 Then
			$sRegExaExcept = StringReplace($sRegExaExcept, "^", "")
		Else
			$sRegExaExcept &= "\b"
		EndIf
		$avExcept[$iIndex] = StringReplace($avExcept[$iIndex], "^", "") ;remove ^ from replacement text
		$sSource = StringRegExpReplace($sSource, $sRegExaExcept, $avExcept[$iIndex])
		If $iMakeUCPos <> 0 Then
			Local $iNextUC = _StringRegExpPos($sSource, $sRegExaExcept)
			Local $iMatches = @extended
			Local $iCapThis = $iNextUC + $iMakeUCPos
			For $x = 1 to $iMatches
				$sSource = StringLeft($sSource, $iCapThis - 2) & StringUpper(StringMid($sSource, $iCapThis - 1, 1)) & StringMid($sSource, $iCapThis)
			Next
		EndIf
	Next
	Return $sSource
EndFunc ;==> _CapExcept

Func _StringRegExpPos($sTest, $sPattern, $iOcc = 1, $iStart = 1)
	Local $sDelim, $iHits
	If $iStart > StringLen($sTest) Then Return SetError(1)
	;Delimiter creation snippet by dany from his version of _StringRegExpSplit
	For $i = 1 To 31
		$sDelim &= Chr($i)
		If Not StringInStr($sTest, $sDelim) Then ExitLoop
		If 32 = StringLen($sDelim) Then Return SetError(3, 0, 0)
	Next
	Local $aResults = StringRegExpReplace(StringMid($sTest, $iStart + (StringLen($sDelim) * ($iOcc - 1))), "(" & $sPattern & ")", $sDelim & "$1")
	If @error = 2 Then Return SetError(2, @extended, 0)
	$iHits = @extended
	If $iHits = 0 Then Return 0
	If $iOcc > $iHits Then Return SetError(1)
	Local $iPos = StringInStr($aResults, $sDelim, 0, $iOcc)
	SetExtended($iHits)
	Return $iStart - 1 + $iPos
EndFunc ;<== _StringRegExpPos