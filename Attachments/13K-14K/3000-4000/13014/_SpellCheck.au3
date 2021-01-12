;;;;;;;;;;;;; _SPELLCHECK ;;;;;;;;;;;;;
;Please keep in mind that this is NOT designed to correct
;large amounts of text. Run this script for a small example

$string = "thsi is tset"
$Spellcheck = _SpellCheck($string)
MsgBox(0,"","There are " & $Spellcheck[0][0] & " mistake(s) in the string" & @CRLF & _
	$Spellcheck[1][0] &  "    is misspelled. Our suggestion:     " & $Spellcheck[2][0] & @CRLF & _
	$Spellcheck[1][1] &  "    is misspelled. Our suggestion:    "  & $Spellcheck[2][1])


#include <Inet.au3>
#include-once
#include <GUIConstants.au3>

;===============================================================================
;
; Function Name:    _SpellCheck
; Description:      Finds the number of mistake(s) within a string
;                   Finds the misspelled word(s)
;                   Finds a suggestion for the misspelled word
; Parameter(s):     $string  -  The text, or string, to spellcheck
; Requirement(s):   Internet Access
; Return Value(s):  Failure = -1
;					Success = $array[0][0] => Contains # of mistakes (1,2,3,etc.)
;							  $array[1][x] => Contains all misspelled words
;							  $array[2][x] => Contains all mistake suggestions
; Author(s):        _Kurt
; Remarks:			The x in $array[1][x] will always be the same value of $array[2][x]
;					Example: $array[1][0] is a mistake, $array[2][0] is the suggestion
;					for the mistake
;
;===============================================================================

Func _SpellCheck($string)
	$strspl = StringSplit($string, " ")
	Local $array[3][UBound($strspl)], $err = 0
	For $i = 1 To UBound($strspl)-1
		$source = _INetGetSource("                                                  " & $strspl[$i])
		$regexp = StringRegExp($source, '<font color="#990033">(.*?)</font>', 3)
		If IsArray($regexp) Then
			If $regexp[0] = '"' & $strspl[$i] & '" is misspelled.' Then
				;;;;       GET # OF MISTAKES       ;;;;
				$array[0][0] = $array[0][0]+1
				;;;; GET WORDS THAT ARE MISSPELLED ;;;;
				$strim = StringTrimLeft($regexp[0], 1)
				$strim = StringTrimRight($strim, 16)
				$array[1][$err] = $strim
				;;;;  GET SUGGESTIONS PER MISTAKE  ;;;;
				$suggest = StringRegExp($source, 'q=define:(.*?)">', 3)
				If IsArray($suggest) Then
					$array[2][$err] = $suggest[0]
				Else
					$array[2][$err] = "No Suggestions"
				EndIf
				$err = $err+1
			EndIf
		EndIf
	Next
	If IsArray($array) Then
		Return $array
	Else
		Return -1
	EndIf
EndFunc