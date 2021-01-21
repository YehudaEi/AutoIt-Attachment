Global $p, $y, $u
HotKeySet("{ESC}", "Terminate")
While 1
$t = MsgBox(4, "Yes/No?", "Did you get it?" & @CRLF & "ESC to exit.")
If $t = 6 Then
	$y = $y + 1
EndIf
$u = $u + 1
$p = $y / $u
$p = $p * 100
ToolTip($p & "%", 10, 10)
WEnd

Func Terminate()
	Exit
EndFunc