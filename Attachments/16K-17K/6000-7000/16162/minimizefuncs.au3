Global Const $VK_OEM_PLUS = 0xBB
Global Const $VK_OEM_MINUS = 0xBD
Global Const $VK_OEM_3 = 0xC0
Global Const $VK_TAB = 0x9
Global Const $VK_ESC = 0x1B
Global Const $VK_F5 = 0x74
Global Const $VK_F12 = 0x7B
Global Const $VK_Period = 0x6E
Global Const $VK_SEMICOLON = 0xBA
Global Const $VK_COLON = 0x3A

Func _MakeLong($LoWord, $HiWord)
    Return BitOR($HiWord * 0x10000, BitAND($LoWord, 0xFFFF))
EndFunc 
Func _MouseClick($hWnd, $button, $x, $y, $times = 1, $delay = 0)
    Local $ret, $ix
    $ret = DllCall("user32.dll", "int", "PostMessage", "hwnd", $hWnd, "int", 0x200, "int", 0, "long", _MakeLong($x, $y))
    If $ret[0] = 0 Then
        SetError(-1)
        Return
    EndIf
    $button = StringLower($button)
    If $button = "left" Then
        For $ix = 1 To $times
            $ret = DllCall("user32.dll", "int", "PostMessage", "hwnd", $hWnd, "int", 0x201, "int", 1, "long", _MakeLong($x, $y))
            If $ret[0] = 0 Then
                SetError(-2)
                Return
            Else
                $ret = DllCall("user32.dll", "int", "PostMessage", "hwnd", $hWnd, "int", 0x202, "int", 0, "long", _MakeLong($x, $y))
                If $ret[0] = 0 Then
                    SetError(-3)
                    Return
                EndIf
            EndIf
            Sleep($delay)
        Next
    ElseIf $button = "right" Then
        For $ix = 1 To $times
            $ret = DllCall("user32.dll", "int", "PostMessage", "hwnd", $hWnd, "int", 0x204, "int", 2, "long", _MakeLong($x, $y))
            If $ret[0] = 0 Then
                SetError(-4)
                Return
            Else
                $ret = DllCall("user32.dll", "int", "PostMessage", "hwnd", $hWnd, "int", 0x205, "int", 0, "long", _MakeLong($x, $y))
                If $ret[0] = 0 Then
                    SetError(-5)
                    Return
                EndIf
            EndIf
            Sleep($delay)
        Next
    Else
        SetError(-6)
        Return
    EndIf
EndFunc 

Func _SendKeys($hWnd, $keys)
    If $hWnd <= 0 Or StringLen($keys) = 0 Then
        SetError(-1)
        Return False
    EndIf
    $keys = StringUpper($keys)
    $keys = StringReplace($keys, "`", Chr($VK_OEM_3))
    $keys = StringReplace($keys, "~", Chr($VK_OEM_3))
    $keys = StringReplace($keys, "-", Chr($VK_OEM_MINUS))
    $keys = StringReplace($keys, "=", Chr($VK_OEM_PLUS))
    $keys = StringReplace($keys, "{ENTER}", Chr(0xD))
    $keys = StringReplace($keys, "{TAB}", Chr(0x9))
    $keys = StringReplace($keys, "{ESC}", Chr($VK_ESC))
    $keys = StringReplace($keys, "{F5}", Chr($VK_F5))
    $keys = StringReplace($keys, "{F12}", Chr($VK_F12))
    $keys = StringReplace($keys, "{SHIFT}", "+")
    $keys = StringReplace($keys, ".", Chr($VK_Period))
	$keys = StringReplace($keys, ";", chr($VK_SEMICOLON))
	;$keys = StringReplace($keys, ":", chr($VK_SEMICOLON))
    Local $i, $ret
    Local $shiftdown = False
    For $i = 1 To StringLen($keys)
        If StringMid($keys, $i, 1) = "+" Then
            DllCall("user32.dll", "int", "PostMessage", "hwnd", $hWnd, "int", 0x100, "int", 0x10, "long", 0x002A0001)
            DllCall("user32.dll", "int", "PostMessage", "hwnd", $hWnd, "int", 0x100, "int", 0x10, "long", 0x402A0001)
            $shiftdown = True
            Sleep(1)
            ContinueLoop
        Else
			
            $ret = DllCall("user32.dll", "int", "MapVirtualKey", "int", Asc(StringMid($keys, $i, 1)), "int", 0)
            If IsArray($ret) Then
                DllCall("user32.dll", "int", "PostMessage", "hwnd", $hWnd, "int", 0x100, "int", Asc(StringMid($keys, $i, 1)), "long", _MakeLong(1, $ret[0]))
                Sleep(1)
                DllCall("user32.dll", "int", "PostMessage", "hwnd", $hWnd, "int", 0x101, "int", Asc(StringMid($keys, $i, 1)), "long", _MakeLong(1, $ret[0]) + 0xC0000000)
            EndIf
        EndIf
        If $shiftdown Then
            Sleep(1)
            DllCall("user32.dll", "int", "PostMessage", "hwnd", $hWnd, "int", 0x101, "int", 0x10, "long", 0xC02A0001)
            $shiftdown = False
        EndIf
    Next
    Return True
EndFunc 

Func _ArrowKey($hWnd, $key)
    If $hWnd <= 0 Or ($key <> "left" And $key <> "right" And $key <> "up" And $key <> "down") Then
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
    $ret = DllCall("user32.dll", "int", "PostMessage", "hwnd", $hWnd, "int", 0x100, "int", $wParam, "int", $lParam)
    If $ret[0] = 0 Then
        MsgBox(16, "_ArrowKey Error", "There was an error posting the WM_KEYDOWN message")
        SetError(-2)
        Return
    EndIf
    Sleep(2)
    $ret = DllCall("user32.dll", "int", "PostMessage", "hwnd", $hWnd, "int", 0x101, "int", $wParam, "int", ($lParam + 0xC0000000))
    If $ret[0] = 0 Then
        MsgBox(16, "_ArrowKey Error", "There was an error posting the WM_KEYUP message")
        SetError(-3)
        Return
    EndIf
EndFunc