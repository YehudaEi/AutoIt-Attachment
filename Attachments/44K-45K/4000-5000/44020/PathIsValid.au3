

$Path = "C:"
ConsoleWrite('Example 1 - check path "'&$Path&'"'&@CRLF)
If PathIsValid($Path) Then
	ConsoleWrite("Path is valid"&@CRLF)
Else
	ConsoleWrite("Path not valid"&@CRLF)
EndIf
ConsoleWrite(@CRLF)


$Path = "C:\"
ConsoleWrite('Example 2 - check path "'&$Path&'"'&@CRLF)
If PathIsValid($Path) Then
	ConsoleWrite("Path is valid"&@CRLF)
Else
	ConsoleWrite("Path not valid"&@CRLF)
EndIf
ConsoleWrite(@CRLF)


$Path = "CC:\"
ConsoleWrite('Example 3 - check path "'&$Path&'"'&@CRLF)
If PathIsValid($Path) Then
	ConsoleWrite("Path is valid"&@CRLF)
Else
	ConsoleWrite("Path not valid"&@CRLF)
EndIf
ConsoleWrite(@CRLF)


$Path = "C\"
ConsoleWrite('Example 4 - check path "'&$Path&'"'&@CRLF)
If PathIsValid($Path) Then
	ConsoleWrite("Path is valid"&@CRLF)
Else
	ConsoleWrite("Path not valid"&@CRLF)
EndIf
ConsoleWrite(@CRLF)


$Path = "C:\aaa"
ConsoleWrite('Example 5 - check path "'&$Path&'"'&@CRLF)
If PathIsValid($Path) Then
	ConsoleWrite("Path is valid"&@CRLF)
Else
	ConsoleWrite("Path not valid"&@CRLF)
EndIf
ConsoleWrite(@CRLF)



$Path = "C:\aaa\bbb"
ConsoleWrite('Example 6 - check path "'&$Path&'"'&@CRLF)
If PathIsValid($Path) Then
	ConsoleWrite("Path is valid"&@CRLF)
Else
	ConsoleWrite("Path not valid"&@CRLF)
EndIf
ConsoleWrite(@CRLF)



$Path = "C:\aaa\\bbb"
ConsoleWrite('Example 7 - check path "'&$Path&'"'&@CRLF)
If PathIsValid($Path) Then
	ConsoleWrite("Path is valid"&@CRLF)
Else
	ConsoleWrite("Path not valid"&@CRLF)
EndIf
ConsoleWrite(@CRLF)


$Path = "C:\a/aa\bbb"
ConsoleWrite('Example 8 - check path "'&$Path&'"'&@CRLF)
If PathIsValid($Path) Then
	ConsoleWrite("Path is valid"&@CRLF)
Else
	ConsoleWrite("Path not valid"&@CRLF)
EndIf
ConsoleWrite(@CRLF)


$Path = "C:\\"
ConsoleWrite('Example 9 - check path "'&$Path&'"'&@CRLF)
If PathIsValid($Path) Then
	ConsoleWrite("Path is valid"&@CRLF)
Else
	ConsoleWrite("Path not valid"&@CRLF)
EndIf
ConsoleWrite(@CRLF)


$Path = "C:\  \bbb"
ConsoleWrite('Example 10 - check path "'&$Path&'"'&@CRLF)
If PathIsValid($Path) Then
	ConsoleWrite("Path is valid"&@CRLF)
Else
	ConsoleWrite("Path not valid"&@CRLF)
EndIf
ConsoleWrite(@CRLF)


$Path = "C:\    aaa\bbb"
ConsoleWrite('Example 11 - check path "'&$Path&'"'&@CRLF)
If PathIsValid($Path) Then
	ConsoleWrite("Path is valid"&@CRLF)
Else
	ConsoleWrite("Path not valid"&@CRLF)
EndIf
ConsoleWrite(@CRLF)


$Path = "C:\aaa    \bbb"
ConsoleWrite('Example 12 - check path "'&$Path&'"'&@CRLF)
If PathIsValid($Path) Then
	ConsoleWrite("Path is valid"&@CRLF)
Else
	ConsoleWrite("Path not valid"&@CRLF)
EndIf
ConsoleWrite(@CRLF)



$Path = "C:\aaa          aaaa\bbb"
ConsoleWrite('Example 13 - check path "'&$Path&'"'&@CRLF)
If PathIsValid($Path) Then
	ConsoleWrite("Path is valid"&@CRLF)
Else
	ConsoleWrite("Path not valid"&@CRLF)
EndIf
ConsoleWrite(@CRLF)



$Path = "C:\aaa          aaaa    \bbb"
ConsoleWrite('Example 14 - check path "'&$Path&'"'&@CRLF)
If PathIsValid($Path) Then
	ConsoleWrite("Path is valid"&@CRLF)
Else
	ConsoleWrite("Path not valid"&@CRLF)
EndIf
ConsoleWrite(@CRLF)

; #FUNCTION# ====================================================================================================================
; Name ..........: PathIsValid
; Description ...: Checks if the path is valid  or not
; Syntax ........: PathIsValid($Path)
; Parameters ....: $Path                - the path string to check.
; Return values .: 1 if the path is valid and 0 if the path is not valid
; Author ........: gil900
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: yes
; ===============================================================================================================================
Func PathIsValid($Path)
	Local $var = StringSplit($Path,"\",1)
	If StringLen($var[1]) = 2 And StringRight($var[1],1) = ":" And StringIsASCII($var[1]) And StringIsAlpha(StringLeft($var[1],1)) Then
		;Return 1
		If $var[0] > 1 Then
			Local $Excluded[9] = [8, "?", "*", '"', "<", ">", "|" , "/" , ":"]
			For $a = 2 To $var[0]
				If $var[$a] = "" And $a > 2 Or StringIsSpace($var[$a]) Then Return 0
				If StringStripWS($var[$a],3) <> $var[$a] Then Return 0
				For $a2 = 1 To $Excluded[0]
					If StringInStr($var[$a],$Excluded[$a2]) > 0 Then Return 0

				Next
			Next
			Return 1
		Else
			Return 1
		EndIf
	Else
		Return 0
	EndIf
EndFunc