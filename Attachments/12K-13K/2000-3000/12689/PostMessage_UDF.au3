;--PostMessage User Defined Functions--
;--Written by Shynd for use with DA--

#include-once

Func _MakeLong($LoWord, $HiWord)
	Return BitOR($HiWord * 0x10000, BitAND($LoWord, 0xFFFF))
EndFunc

Func _MouseClick($hWnd, $button, $x, $y, $times=1, $delay=250)
	If $hWnd = 0 Then
		SetError(-1)
		Return
	EndIf
	
	Local $ix
	Local $lParam = _MakeLong($x, $y)
	Local $user32 = DllOpen("user32.dll")
	
	$button = StringLower($button)
	
	If $button = "left" Then
		For $ix = 1 To $times
			DllCall($user32, "int", "PostMessage", "hwnd", $hWnd, "int", 0x200, "int", 0, "long", $lParam)
			DllCall($user32, "int", "PostMessage", "hwnd", $hWnd, "int", 0x201, "int", 1, "long", $lParam)
			DllCall($user32, "int", "PostMessage", "hwnd", $hWnd, "int", 0x202, "int", 0, "long", $lParam)
			
			If $ix < $times Then Sleep($delay)
		Next
	ElseIf $button = "right" Then
		For $ix = 1 To $times
			DllCall($user32, "int", "PostMessage", "hwnd", $hWnd, "int", 0x200, "int", 0, "long", $lParam)
			DllCall($user32, "int", "PostMessage", "hwnd", $hWnd, "int", 0x204, "int", 2, "long", $lParam)
			DllCall($user32, "int", "PostMessage", "hwnd", $hWnd, "int", 0x205, "int", 0, "long", $lParam)
			
			If $ix < $times Then Sleep($delay)
		Next
	Else
		SetError(-2)
		If $user32 <> -1 Then DllClose($user32)
		Return
	EndIf
	If $user32 <> -1 Then DllClose($user32)
EndFunc

Func _MouseUseSpell($hWnd, $x, $y, $selfcast=False, $sx=310, $sy=163)
	Local $user32 = DllOpen("user32.dll")
	
	;Click the spell panel
	DllCall($user32, "int", "PostMessage", "hwnd", $hWnd, "int", 0x200, "int", 0, "long", _MakeLong(547, 400))
	DllCall($user32, "int", "PostMessage", "hwnd", $hWnd, "int", 0x201, "int", 0, "long", _MakeLong(547, 400))
	DllCall($user32, "int", "PostMessage", "hwnd", $hWnd, "int", 0x202, "int", 0, "long", _MakeLong(547, 400))
	
	;Double-click the spell
	DllCall($user32, "int", "PostMessage", "hwnd", $hWnd, "int", 0x200, "int", 0, "long", _MakeLong($x, $y))
	DllCall($user32, "int", "PostMessage", "hwnd", $hWnd, "int", 0x201, "int", 0, "long", _MakeLong($x, $y))
	DllCall($user32, "int", "PostMessage", "hwnd", $hWnd, "int", 0x202, "int", 0, "long", _MakeLong($x, $y))
	DllCall($user32, "int", "PostMessage", "hwnd", $hWnd, "int", 0x201, "int", 0, "long", _MakeLong($x, $y))
	DllCall($user32, "int", "PostMessage", "hwnd", $hWnd, "int", 0x202, "int", 0, "long", _MakeLong($x, $y))
	
	;If selfcast, click on character
	If $selfcast Then
		DllCall($user32, "int", "PostMessage", "hwnd", $hWnd, "int", 0x200, "int", 0, "long", _MakeLong($sx, $sy))
		DllCall($user32, "int", "PostMessage", "hwnd", $hWnd, "int", 0x201, "int", 0, "long", _MakeLong($sx, $sy))
		DllCall($user32, "int", "PostMessage", "hwnd", $hWnd, "int", 0x202, "int", 0, "long", _MakeLong($sx, $sy))
	EndIf
	
	If $user32 <> -1 Then DllClose($user32)
EndFunc

Func _MouseUseSkill($hWnd, $x, $y)
	Local $user32 = DllOpen("user32.dll")
	
	;Click the skill panel
	DllCall($user32, "int", "PostMessage", "hwnd", $hWnd, "int", 0x200, "int", 0, "long", _MakeLong(547, 370))
	DllCall($user32, "int", "PostMessage", "hwnd", $hWnd, "int", 0x201, "int", 0, "long", _MakeLong(547, 370))
	DllCall($user32, "int", "PostMessage", "hwnd", $hWnd, "int", 0x202, "int", 0, "long", _MakeLong(547, 370))
	
	;Double-click the skill
	DllCall($user32, "int", "PostMessage", "hwnd", $hWnd, "int", 0x200, "int", 0, "long", _MakeLong($x, $y))
	DllCall($user32, "int", "PostMessage", "hwnd", $hWnd, "int", 0x201, "int", 0, "long", _MakeLong($x, $y))
	DllCall($user32, "int", "PostMessage", "hwnd", $hWnd, "int", 0x202, "int", 0, "long", _MakeLong($x, $y))
	DllCall($user32, "int", "PostMessage", "hwnd", $hWnd, "int", 0x201, "int", 0, "long", _MakeLong($x, $y))
	DllCall($user32, "int", "PostMessage", "hwnd", $hWnd, "int", 0x202, "int", 0, "long", _MakeLong($x, $y))
	
	If $user32 <> -1 Then DllClose($user32)
EndFunc

Func _SendKeys($hWnd, $keys)
	If $hWnd <= 0 Or StringLen($keys) = 0 Then
		SetError(-1)
		Return False
	EndIf
	
	$keys = StringUpper($keys)
	
	$keys = StringReplace($keys, "`", Chr(0xC0))
	$keys = StringReplace($keys, "~", Chr(0xC0))
	$keys = StringReplace($keys, "-", Chr(0xBD))
	$keys = StringReplace($keys, "=", Chr(0xBB))
	$keys = StringReplace($keys, "{ENTER}", Chr(0xD))
	$keys = StringReplace($keys, "{TAB}", Chr(0x9))
	$keys = StringReplace($keys, "{ESC}", Chr(0x1B))
	$keys = StringReplace($keys, "{F5}", Chr(0x74))
	$keys = StringReplace($keys, "{F12}", Chr(0x7B))
	$keys = StringReplace($keys, "{SHIFT}", "+")
	
	Local $i, $ret
	Local $shiftdown = False
	Local $user32 = DllOpen("user32.dll")
	
	For $i = 1 To StringLen($keys)
		If StringMid($keys, $i, 1) = "+" Then
			DllCall($user32, "int", "PostMessage", "hwnd", $hWnd, "int", 0x100, "int", 0x10, "long", 0x002A0001)
			DllCall($user32, "int", "PostMessage", "hwnd", $hWnd, "int", 0x100, "int", 0x10, "long", 0x402A0001)
			$shiftdown = True
			Sleep(1)
			ContinueLoop
		Else
			$ret = DllCall($user32, "int", "MapVirtualKey", "int", Asc(StringMid($keys, $i, 1)), "int", 0)
			If IsArray($ret) Then
				DllCall($user32, "int", "PostMessage", "hwnd", $hWnd, "int", 0x100, "int", Asc(StringMid($keys, $i, 1)), "long", _MakeLong(1, $ret[0]))
				Sleep(1)
				DllCall($user32, "int", "PostMessage", "hwnd", $hWnd, "int", 0x101, "int", Asc(StringMid($keys, $i, 1)), "long", _MakeLong(1, $ret[0]) + 0xC0000000)
				Sleep(1)
			EndIf
		EndIf
		If $shiftdown Then
			DllCall($user32, "int", "PostMessage", "hwnd", $hWnd, "int", 0x101, "int", 0x10, "long", 0xC02A0001)
			Sleep(1)
			$shiftdown = False
		EndIf
	Next
	
	If $user32 <> -1 Then DllClose($user32)
	
	Return True
EndFunc

Func _SendText($hWnd, $str)
	If $hWnd = 0 Or StringLen($str) = 0 Then
		SetError(-1)
		Return
	EndIf
	
	Local $user32 = DllOpen("user32.dll")
	
	For $i = 1 To StringLen($str)
		DllCall($user32, "int", "PostMessage", "hwnd", $hWnd, "int", 0x102, "int", Asc(StringMid($str, $i, 1)), "long", 0)
		Sleep(1)
	Next
	
	If $user32 <> -1 Then DllClose($user32)
EndFunc

Func _SendChatMessage($hWnd, $str)
	If $hWnd = 0 Or StringLen($str) = 0 Then
		SetError(-1)
		Return
	EndIf
	
	_SendKeys($hWnd, "{ENTER}")
	Sleep(50)
	_SendText($hWNd, $str)
	Sleep(30)
	_SendKeys($hWNd, "{ENTER}")
EndFunc

Func _SendWhisper($hWnd, $name, $str)
	If $hWnd = 0 Or StringLen($str) = 0 Or StringLen($name) = 0 Then
		SetError(-1)
		Return
	EndIf
	
	_SendKeys($hWnd, "{ESC}+" & Chr(0xDE))
	Sleep(50)
	_SendText($hWnd, $name)
	Sleep(1)
	_SendKeys($hWNd, "{ENTER}")
	Sleep(30)
	_SendText($hWnd, $str)
	Sleep(30)
	_SendKeys($hWnd, "{ENTER}")
EndFunc

Func _ArrowKey($hWnd, $key)
	If $hWnd <= 0 Or ( $key <> "left" And $key <> "right" And $key <> "up" And $key <> "down" ) Then
		SetError(-1)
		Return
	EndIf
	
	Local $wParam, $lParam, $ret
	
	If $key = "left" Then
		$wParam = 0x25
		$lParam = 0x14B0001
	ElseIf $key = "right" Then
		$wParam = 0x27
		$lParam = 0x14D0001
	ElseIf $key = "down" Then
		$wParam = 0x28
		$lParam = 0x1500001
	ElseIf $key = "up" Then
		$wParam = 0x26
		$lParam = 0x1480001
	EndIf
	
	Local $user32 = DllOpen("user32.dll")
	
	$ret = DllCall($user32, "int", "PostMessage", "hwnd", $hWnd, "int", 0x100, "int", $wParam, "int", $lParam)
	If $ret[0] = 0 Then
		SetError(-2)
		If $user32 <> -1 Then DllClose($user32)
		Return
	EndIf
	
	Sleep(2)
	
	$ret = DllCall($user32, "int", "PostMessage", "hwnd", $hWnd, "int", 0x101, "int", $wParam, "int", ($lParam + 0xC0000000))
	If $ret[0] = 0 Then
		SetError(-3)
		If $user32 <> -1 Then DllClose($user32)
		Return
	EndIf
	
	If $user32 <> -1 Then DllClose($user32)
EndFunc

Func _PostMessage($hWnd, $msgID, $wParam, $lParam)
	Local $ret = DllCall("user32.dll", "int", "PostMessage", "hwnd", $hWnd, "int", $msgID, "int", $wParam, "int", $lParam)
	If IsArray($ret) Then
		Return $ret[0]
	Else
		SetError(-1)
		Return False
	EndIf
EndFunc