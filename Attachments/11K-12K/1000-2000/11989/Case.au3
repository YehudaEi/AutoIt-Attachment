; Include Version:1.00 (15 November 2006)
#include-once

; ------------------------------------------------------------------------------
;
; AutoIt Version: 3.0
; Language:       English
; Description:    Functions that assist with string management.
; Other:          The quick brown fox jumps over the lazy dog. 1234567890
;
; ------------------------------------------------------------------------------

;===============================================================================
;
; Function Name:    case_char($char,$opt=1)
; Description:      Change the case of a single character
; Return Values(s): On success - returns character in case of choice
;                   On failure - returns 0
; Author(s):        Zach Borboa
; Note(s):          Use $opt=1 to make character uppercase (default)
;                   Use $opt=2 to make character lowercase
;                   Use $opt=3 to toggle character case
;                   Possible uses:
;                     $opt=1 example:
;                       Before: a
;                       After:  A
;                     $opt=1 example 2:
;                       Before: A
;                       After:  A
;                     $opt=2 example:
;                       Before: A
;                       After:  a
;                     $opt=2 example 2:
;                       Before: a
;                       After:  a
;                     $opt=3 example:
;                       Before: a
;                       After:  A
;                     $opt=3 example 2:
;                       Before: A
;                       After:  a
;
;===============================================================================
Func case_char($char,$opt=1)
	If NOT StringIsAlpha($char) Then
		Return $char
	Else
		If $opt = 1 Then ;uppercase
			If StringIsUpper($char) Then
				Return $char
			Else
				If $char = "a" Then
					Return "A"
				ElseIf $char = "b" Then
					Return "B"
				ElseIf $char = "c" Then
					Return "C"
				ElseIf $char = "d" Then
					Return "D"
				ElseIf $char = "e" Then
					Return "E"
				ElseIf $char = "f" Then
					Return "F"
				ElseIf $char = "g" Then
					Return "G"
				ElseIf $char = "h" Then
					Return "H"
				ElseIf $char = "i" Then
					Return "I"
				ElseIf $char = "j" Then
					Return "J"
				ElseIf $char = "k" Then
					Return "K"
				ElseIf $char = "l" Then
					Return "L"
				ElseIf $char = "m" Then
					Return "M"
				ElseIf $char = "n" Then
					Return "N"
				ElseIf $char = "o" Then
					Return "O"
				ElseIf $char = "p" Then
					Return "P"
				ElseIf $char = "q" Then
					Return "Q"
				ElseIf $char = "r" Then
					Return "R"
				ElseIf $char = "s" Then
					Return "S"
				ElseIf $char = "t" Then
					Return "T"
				ElseIf $char = "u" Then
					Return "U"
				ElseIf $char = "v" Then
					Return "V"
				ElseIf $char = "w" Then
					Return "W"
				ElseIf $char = "x" Then
					Return "X"
				ElseIf $char = "y" Then
					Return "Y"
				ElseIf $char = "z" Then
					Return "Z"
				EndIf
			EndIf
		ElseIf $opt = 2 Then ;lowercase
			If StringIsLower($char) Then
				Return $char
			Else
				If $char = "A" Then
					Return "a"
				ElseIf $char = "B" Then
					Return "b"
				ElseIf $char = "C" Then
					Return "c"
				ElseIf $char = "D" Then
					Return "d"
				ElseIf $char = "E" Then
					Return "e"
				ElseIf $char = "F" Then
					Return "f"
				ElseIf $char = "G" Then
					Return "g"
				ElseIf $char = "H" Then
					Return "h"
				ElseIf $char = "I" Then
					Return "i"
				ElseIf $char = "J" Then
					Return "j"
				ElseIf $char = "K" Then
					Return "k"
				ElseIf $char = "L" Then
					Return "l"
				ElseIf $char = "M" Then
					Return "m"
				ElseIf $char = "N" Then
					Return "n"
				ElseIf $char = "O" Then
					Return "o"
				ElseIf $char = "P" Then
					Return "p"
				ElseIf $char = "Q" Then
					Return "q"
				ElseIf $char = "R" Then
					Return "r"
				ElseIf $char = "S" Then
					Return "s"
				ElseIf $char = "T" Then
					Return "t"
				ElseIf $char = "U" Then
					Return "u"
				ElseIf $char = "V" Then
					Return "v"
				ElseIf $char = "W" Then
					Return "w"
				ElseIf $char = "X" Then
					Return "x"
				ElseIf $char = "Y" Then
					Return "y"
				ElseIf $char = "Z" Then
					Return "z"
				EndIf
			EndIf
		ElseIf $opt = 3 Then ;toggle
			If StringIsLower($char) Then
				Return case_char($char,1)
			Else
				Return case_char($char,2)
			EndIf
		EndIf
	EndIf
EndFunc   ;==>case_char

;===============================================================================
;
; Function Name:    case_string($string,$opt=1)
; Description:      Change the case of an entire string
; Return Values(s): On success - returns string in case of choice
;                   On failure - none
; Author(s):        Zach Borboa
; Note(s):          Use $opt=1 to make string uppercase (default)
;                   Use $opt=2 to make string lowercase
;                   Use $opt=3 to toggle string case
;                   Use $opt=4 to make string capitalized
;                   Possible uses:
;                     $opt=1 example:
;                       Before: The quick brown fox jumps over the lazy dog. 1234567890
;                       After:  THE QUICK BROWN FOX JUMPS OVER THE LAZY DOG. 1234567890
;                     $opt=2 example:
;                       Before: The quick brown fox jumps over the lazy dog. 1234567890
;                       After:  the quick brown fox jumps over the lazy dog. 1234567890
;                     $opt=3 example:
;                       Before: The QuIcK bRowN fOx JumpS ovEr tHE LAZy DOG. 1234567890
;                       After:  tHE qUiCk BrOWn FoX jUMPs OVeR The lazY dog. 1234567890
;                     $opt=4 example:
;                       Before: The quick brown fox jumps over the lazy dog. 1234567890
;                       After:  The Quick Brown Fox Jumps Over The Lazy Dog. 1234567890
;
;===============================================================================
Func case_string($string,$opt=1)
	Local $newstring
	Local $string_len = StringLen($string)
	If $opt = 1 Then ;uppercase
		If StringIsUpper($string) Then
			Return $string
		Else
			$string = StringReplace($string,"  "," ")
			Local $i = 0
			While $i <> $string_len + 1
				$char = StringMid($string,$i,1)
				If StringIsUpper($char) Then
					$char = $char
				Else
					$char = case_char($char,1)
				EndIf
				$newstring = $newstring & $char
				$i = $i + 1
			WEnd
			Return $newstring
		EndIf
	ElseIf $opt = 2 Then ;lowercase
		If StringIsLower($string) Then
			Return $string
		Else
			$string = StringReplace($string,"  "," ")
			Local $i = 0
			While $i <> $string_len + 1
				$char = StringMid($string,$i,1)
				If StringIsLower($char) Then
					$char = $char
				Else
					$char = case_char($char,2)
				EndIf
				$newstring = $newstring & $char
				$i = $i + 1
			WEnd
			Return $newstring
		EndIf
	ElseIf $opt = 3 Then ;toggle
		$string = StringReplace($string,"  "," ")
		Local $i = 0
		While $i <> $string_len + 1
			$char = StringMid($string,$i,1)
			If StringIsLower($char) Then
				$char = case_char($char,1)
			Else
				$char = case_char($char,2)
			EndIf
			$newstring = $newstring & $char
			$i = $i + 1
		WEnd
		Return $newstring
	ElseIf $opt = 4 Then ;capitalize
		$string = StringReplace($string,"  "," ")
		$string = StringSplit($string," ",1)
		For $a = 1 To $string[0] Step 1
			$len = StringLen($string[$a])
			$leftletter = StringTrimRight($string[$a],$len - 1)
			$else = StringTrimLeft($string[$a],1)
			$newstring = $newstring & " " & case_char($leftletter,1) & $else
		Next
		$newstring = StringTrimLeft($newstring,1)
		Return $newstring
	EndIf
EndFunc   ;==>case_string
