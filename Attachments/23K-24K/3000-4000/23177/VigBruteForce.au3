#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Compression=0
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#include <Array.au3>
$timer = TimerInit()
$Alphabet = StringSplit("ABCDEFGHIJKLMNOPQRSTUVWXYZ", "")
_ArrayDelete($Alphabet, 0)
Global $Text
Global $possib
Global $name
$name = 0
$possib = 0
$Possibles = FileOpenDialog("select file to save possibles to...", "C:\", "txt (*.txt)")
$File = FileOpenDialog("select file to decrypt...", "C;\", "txt (*.txt)")
$Text = FileRead($File)
$Text = StringRegExpReplace(StringUpper(StringStripCR($Text)), "[^:ABCDEFGHIJKLMNOPQRSTUVWXYZ:]", "")
Global $VigCypher[26][26]
For $i = 0 To 25
	Global $icopy = $i
	VigFill($i)
Next
$look4word = True
$word = InputBox("Word to look for?", "If there is a specific word you know is in the text, please give it.")
If @error = 1 Then
	$look4word = False
EndIf
$maxkey = InputBox("Maximum Key length?", "Please specify, what you think is the maximum length of the key." & @CRLF & "Warning, for every single length added it takes almost 30 times as long!")
EasyWay($maxkey)

Func EasyWay($easyw)
	For $easy = 1 To $easyw
		$allComb = StringSplit(_AllCOmbinations($easy), @CRLF, 1)
		For $c = 26 ^ ($easy - 1) To $allComb[0]
			$time = Round(TimerDiff($timer) / 60000, 2)
			ToolTip("Keyword: " & $allComb[$c] & @CRLF & "Possibles found: " & $possib & @CRLF & "Names found: " & $name & @CRLF & "Minutes ran: " & $time & @CRLF & "Tries: " & $c, 0, 0)
			DecryptCheck($allComb[$c])
		Next
	Next
EndFunc   ;==>EasyWay

Func DecryptCheck($KeyWord)
	$a = 1
	$EncryptText = ""
	While $a < StringLen($Text)
		For $i = 1 To StringLen($KeyWord)
			$KeyPlace = _ArraySearch($Alphabet, StringMid($KeyWord, $i, 1))
			$TextPlace = _ArraySearch($Alphabet, StringMid($Text, $a, 1))
			$EncryptText = $EncryptText & $VigCypher[$KeyPlace][$TextPlace]
			$a += 1
			If $a = StringLen($Text) Then
				ExitLoop
			EndIf
		Next
	WEnd
	$length = StringLen($EncryptText)
	Dim $freq[26]
	For $i = 1 To 26
		$TestText = $EncryptText
		StringRegExpReplace($TestText, $Alphabet[$i - 1], "@")
		$freq[$i - 1] = Round(@extended / $length * 100, 3)
	Next
	If StringInStr($EncryptText, $word) Then
		FileWriteLine($Possibles, "----------------------WORD FOUND!!!!-------------" & @CRLF & "Keyword: " & $KeyWord & @CRLF & $EncryptText)
		$name += 1
	Else
		$Pos = 0
		Select
			Case $freq[-1 + 5] > 5;c
				$Pos += 1
			Case $freq[-1 + 5] > 5;z
				$Pos += 1
			Case $freq[-1 + 6] > 5;b
				$Pos += 1
			Case $freq[-1 + 10] > 5;j
				$Pos += 1
			Case $freq[-1 + 14] > 5;n
				$Pos += 1
			Case $freq[-1 + 17] > 5;q
				$Pos += 1
			Case $freq[-1 + 24] > 5;x
				$Pos += 1
			Case $freq[-1 + 25] > 5;y
				$Pos += 1
			Case $freq[-1 + 24] > 5;p
				$Pos += 1
			Case $freq[-1 + 25] > 5;w
				$Pos += 1
		EndSelect
		If $look4word = True And $Pos < 3 And $freq[-1 + 5] > 10 And $freq[-1 + 14] > 5 And StringInStr($EncryptText, "EN") Then
			FileWriteLine($Possibles, "Keyword: " & $KeyWord & @CRLF & "---" & @CRLF & $EncryptText & @CRLF & "---" & @CRLF)
			$possib += 1
		EndIf
	EndIf
EndFunc   ;==>DecryptCheck

Func VigFill($offset)
	Dim $res[26]
	For $a = 0 To 25
		$VigCypher[$icopy][$a] = $Alphabet[Mod(26 + $a - $offset, 26)]
	Next
EndFunc   ;==>VigFill

Func _AllCOmbinations($MaxLen = 8)
	Global $RetString
	For $i = Asc("A") To Asc("Z")
		$Char = Chr($i)
		$RetString &= $Char & @CRLF
		$RetString &= _AllCOmbinationsRec($Char, $MaxLen - 1)
	Next
	Return StringTrimRight($RetString, 2)
EndFunc   ;==>_AllCOmbinations

Func _AllCOmbinationsRec($string, $MaxLen)
	If $MaxLen = 0 Then Return ""
	Local $RetString, $chars
	For $i = Asc("A") To Asc("Z")
		$chars = $string & Chr($i)
		$RetString &= $chars & @CRLF
		$RetString &= _AllCOmbinationsRec($chars, $MaxLen - 1)
	Next
	Return $RetString
EndFunc   ;==>_AllCOmbinationsRec

MsgBox(0, "FINISHED!", "Finished!")