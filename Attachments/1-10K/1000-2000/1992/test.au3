#NoTrayIcon
#include <GUIConstants.au3>

HotKeySet( "^e", "encrypt2")
HotKeySet( "^d", "decrypt2")

$w = 300
$h = 200
$l = (@DesktopWidth - $w) / 2
$t = (@DesktopHeight - $h) / 2
$win = "ENCRYPTION - 2.0"

$gui = GUICreate($win, $w, $h, $l, $t, $WS_MINIMIZEBOX + $WS_SYSMENU)
$edit = GUICtrlCreateEdit("Encrypting 1 Encrypting 2 Encrypting 3 Encrypting 4 Encrypting 5", 0, 0, $w - 5, $h - 51, $ES_WANTRETURN + $ES_MULTILINE + $WS_TABSTOP + $ES_AUTOVSCROLL + $ES_AUTOHSCROLL + $WS_VSCROLL + $WS_HSCROLL)
$encrypt = GUICtrlCreateButton("E n c r y p t", 0, $h - 51, ($w / 3) - 2, 20)
$decrypt = GUICtrlCreateButton("D e c r y p t", ($w / 3) - 2, $h - 51, ($w / 3) - 2, 20)
$clipboard = GUICtrlCreateButton("C o p y", ($w / 3 * 2) - 4, $h - 51, ($w / 3) - 2, 20)

GUISetState(@SW_HIDE)

$trans = 0

WinSetTrans($win, "", $trans)

GUISetState(@SW_SHOW)

Do
	$trans = $trans + 1
	WinSetTrans($win, "", $trans)
Until $trans >= 255

GUISetBkColor("0xFFFFFF", $gui)

GUICtrlSetState($edit, $GUI_FOCUS)

WinSetOnTop($win, "", 1)

While 1
	$msg = GUIGetMsg()
	Select
		Case $msg = $GUI_EVENT_CLOSE
			myexit()
		Case $msg = $decrypt
			decrypt2 ()
		Case $msg = $encrypt
			encrypt2()
		Case $msg = $clipboard
			ClipPut(GUICtrlRead($edit))
	EndSelect
	Sleep(1)
WEnd

Func abcdef($sz_t)
	If StringIsUpper($sz_t) Then
		If $sz_t = "A" Then Return "C"
		If $sz_t = "C" Then Return "A"
		If $sz_t = "B" Then Return "D"
		If $sz_t = "D" Then Return "B"
		If $sz_t = "E" Then Return "G"
		If $sz_t = "G" Then Return "E"
		If $sz_t = "F" Then Return "H"
		If $sz_t = "H" Then Return "F"
		If $sz_t = "I" Then Return "K"
		If $sz_t = "K" Then Return "I"
		If $sz_t = "J" Then Return "L"
		If $sz_t = "L" Then Return "J"
		If $sz_t = "M" Then Return "O"
		If $sz_t = "O" Then Return "M"
		If $sz_t = "N" Then Return "P"
		If $sz_t = "P" Then Return "N"
		If $sz_t = "Q" Then Return "S"
		If $sz_t = "S" Then Return "Q"
		If $sz_t = "R" Then Return "T"
		If $sz_t = "T" Then Return "R"
		If $sz_t = "U" Then Return "W"
		If $sz_t = "W" Then Return "U"
		If $sz_t = "V" Then Return "X"
		If $sz_t = "X" Then Return "V"
		If $sz_t = "Y" Then Return "Z"
		If $sz_t = "Z" Then Return "Y"
	EndIf
	If $sz_t = "a" Then Return "c"
	If $sz_t = "c" Then Return "a"
	If $sz_t = "b" Then Return "d"
	If $sz_t = "d" Then Return "b"
	If $sz_t = "e" Then Return "g"
	If $sz_t = "g" Then Return "e"
	If $sz_t = "f" Then Return "h"
	If $sz_t = "h" Then Return "f"
	If $sz_t = "i" Then Return "k"
	If $sz_t = "k" Then Return "i"
	If $sz_t = "j" Then Return "l"
	If $sz_t = "l" Then Return "j"
	If $sz_t = "m" Then Return "o"
	If $sz_t = "o" Then Return "m"
	If $sz_t = "n" Then Return "p"
	If $sz_t = "p" Then Return "n"
	If $sz_t = "q" Then Return "s"
	If $sz_t = "s" Then Return "q"
	If $sz_t = "r" Then Return "t"
	If $sz_t = "t" Then Return "r"
	If $sz_t = "u" Then Return "w"
	If $sz_t = "w" Then Return "u"
	If $sz_t = "v" Then Return "x"
	If $sz_t = "x" Then Return "v"
	If $sz_t = "y" Then Return "z"
	If $sz_t = "z" Then Return "y"
	
	If $sz_t = "0" Then Return "2"
	If $sz_t = "2" Then Return "0"
	If $sz_t = "1" Then Return "3"
	If $sz_t = "3" Then Return "1"
	If $sz_t = "4" Then Return "6"
	If $sz_t = "6" Then Return "4"
	If $sz_t = "5" Then Return "7"
	If $sz_t = "7" Then Return "5"
	If $sz_t = "8" Then Return "9"
	If $sz_t = "9" Then Return "8"
	
	If $sz_t = ")" Then Return "@"
	If $sz_t = "@" Then Return ")"
	If $sz_t = "!" Then Return "#"
	If $sz_t = "#" Then Return "!"
	If $sz_t = "$" Then Return "^"
	If $sz_t = "^" Then Return "$"
	If $sz_t = "%" Then Return "&"
	If $sz_t = "&" Then Return "%"
	If $sz_t = "*" Then Return "("
	If $sz_t = "(" Then Return "*"
	
	If $sz_t = "?" Then Return "+"
	If $sz_t = "+" Then Return "?"
	
	If $sz_t = " " Then Return ":"
	If $sz_t = ":" Then Return " "
	
	If $sz_t = @CR Then Return ""
	If $sz_t = @LF Then Return "¤"
	If $sz_t = "" Then Return @CR
	If $sz_t = "¤" Then Return @LF
	
	Return $sz_t
EndFunc   ;==>abcdef

Func _Scramble($sText)
	;; Scramble a text string.
	$iLen = StringLen($sText)
	$Scrambled = ""
	For $i1 = 1 To Int($iLen / 2)
		$Scrambled = $Scrambled & StringMid($sText, $iLen - $i1 + 1, 1) & StringMid($sText, $i1, 1)
	Next; $i1
	; Pick up the odd character.
	If Mod($iLen, 2) Then
		$Scrambled = $Scrambled & StringMid($sText, $i1, 1)
	EndIf
	Return $Scrambled
EndFunc   ;==>_Scramble


Func _Unscramble($sText)
	;; De-Scramble a Scrambled text that was scrambled by _Scramble.
	Local $iLen = StringLen($sText)
	Local $i, $Unscrambled1, $Unscrambled2
	$Unscrambled1 = ""
	$Unscrambled2 = ""
	For $i1 = 1 To $iLen Step 2
		$Unscrambled1 = StringMid($sText, $i1, 1) & $Unscrambled1
		$Unscrambled2 = $Unscrambled2 & StringMid($sText, $i1 + 1, 1)
	Next; $i1
	; Pick up the odd character.
	If Mod($iLen, 2) Then
		$Unscrambled1 = StringMid($sText, $i1, 1) & $Unscrambled1
	EndIf
	$sText = $Unscrambled2 & $Unscrambled1
	Return $Unscrambled2 & $Unscrambled1
EndFunc   ;==>_Unscramble

Func myexit()
	
	Do
		$trans = $trans - 1
		WinSetTrans($win, "", $trans)
	Until $trans <= 0
	Exit
EndFunc   ;==>myexit

Func encrypt2()
	$Timer = TimerStart ()
	$sz_dec = GUICtrlRead($edit)
	GUICtrlSetData($edit, "")
	GUICtrlSetData($edit, "Encrypting...")
	$sz_dec = _Unscramble($sz_dec)
	$sz_tmptxt = ""
	For $i = 1 To StringLen($sz_dec)
		$sz_tmptxt = $sz_tmptxt & abcdef(StringMid($sz_dec, $i, 1))
	Next
	$sz_tmptxt = _Unscramble($sz_tmptxt)
	GUICtrlSetData($edit, "")
	GUICtrlSetData($edit, $sz_tmptxt & @CRLF & "Done in " & TimerDiff($Timer) & " ms")
	
	ClipPut(GUICtrlRead($edit))
EndFunc   ;==>encrypt2

Func decrypt2 ()
	$Timer = TimerStart ()
	$sz_enc = GUICtrlRead($edit)
	GUICtrlSetData($edit, "")
	GUICtrlSetData($edit, "Decrypting...")
	$sz_enc = _Scramble($sz_enc)
	$sz_tmptxt = ""
	For $i = 1 To StringLen($sz_enc)
		$sz_tmptxt = $sz_tmptxt & abcdef(StringMid($sz_enc, $i, 1))
	Next
	$sz_tmptxt = _Scramble($sz_tmptxt)
	GUICtrlSetData($edit, "")
	GUICtrlSetData($edit, $sz_tmptxt & @CRLF & "Done in " & TimerDiff($Timer) & " ms")
	ClipPut(GUICtrlRead($edit))
EndFunc   ;==>decrypt2