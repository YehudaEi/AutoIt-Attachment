HotKeySet("^+c", "_FormatCoCreate")
HotKeySet("{END}", "_exit")

While 1
	Sleep(50)
WEnd

Func _FormatCoCreate()
	Send("^c")
	Sleep(500)
	$rawText = ClipGet()
	If StringInStr($rawText, "$[") Then
		MsgBox(0,"Error","Function cannot contain the special delimiter: $[" & @CRLF & "Please replace text and try again.")
	EndIf
	If StringInStr($rawText, "|") Then
		If StringInStr($rawText, "~{[]}~") Then
			$delim = InputBox('Input custom delimiter, as both "|" and "~{[]}~" exist in your function', "Delimiter")
		Else
			$delim = "~{[]}~"
		EndIf
	Else
		$delim = "|"
	EndIf
;~ 	$replacedText = StringReplace($rawText, @CRLF, $delim)
	$replacedText = ""
	$splitText = StringSplit($rawText, @CRLF)
	For $lineCount = 1 To $splitText[0]
		$textParts = StringRegExp($splitText[$lineCount], '(\s*)(.*)', 1)
		If IsArray($textParts) And UBound($textParts) == 2 Then
			$replacedText &= $textParts[0] & "'" & $textParts[1] & $delim & "'"
			If $lineCount <> $splitText[0] Then
				$replacedText &= " & _" & @CRLF
			EndIf
		ElseIf IsArray($textParts) And UBound($textParts) == 1 Then
			$replacedText &= "'" & $textParts[0] & $delim & "'"
			If $lineCount <> $splitText[0] Then
				$replacedText &= " & _" & @CRLF
			EndIf
		EndIf
	Next
	If $delim <> "|" Then
		$setText = '$ThreadName = _CoCreate(' & $replacedText & ', ''' & $delim & ''')'
	Else
		$setText = '$YourThreadNameHere = _CoCreate(' & $replacedText & ')'
	EndIf
	ClipPut($setText)
	Send("^v")
EndFunc

Func _exit()
	Exit
EndFunc