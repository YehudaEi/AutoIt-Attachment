; ----------------------------------------------------------------------------
;
; AutoIt Version: 3.1.0
; Author:         A.N.Other <myemail@nowhere.com>
;
; Script Function:
;	Template AutoIt script.
;
; ----------------------------------------------------------------------------

; Script Start - Add your code below here

MsgBox(0, "Tutorial", "You can do the following to make your RGP experience unique!" & @CRLF & "F2: Take a break and get you account wiped" & @CRLF & "F3: Level up!" & @CRLF & "F4: Finish a Quest!" & @CRLF & "F5: Try to cheat using autoit!" & @CRLF & @CRLF & "Of course you are alwas killing monsters or something so your exp will alwas go up." & @CRLF & "")
HotKeySet("{F2}", "Restart")
HotKeySet("{ESC}", "Terminate")
HotKeySet("{F3}", "Level")
HotKeySet("{F4}", "Quest")
HotKeySet("{F5}","Cheat")
$t = 1
$s = 1
While 1
	ToolTip("Exp: " & $t, @DesktopWidth / 2, @DesktopHeight / 2 - 10)
	$t = $t + $s
	If $t > 120000000 Then
		MsgBox(0, "Congrats!", "You have gotten to level 99!" & @CRLF & @CRLF & @CRLF & @CRLF & "Woop De Dang Do...")
		Exit
	EndIf
	If Random(1, 1000000, 1) = 1000000 Then
		MsgBox(0, "Time off!", "You decide to take a break and you account gets canceled!" & @CRLF & "O well, you didn't get that far anyway...")
		Restart()
	EndIf
WEnd
Func Restart()
	$t = 1
	$s = 1
EndFunc   ;==>Restart
Func Terminate()
	Exit
EndFunc   ;==>Terminate
Func Level()
	If $s = 1 Then
		$s = 2
	ElseIf $s = 2 Then
		$s = 6
	ElseIf $s = 6 Then
		$s = 11
	ElseIf $s = 11 Then
		$s = 21
	ElseIf $s = 21 Then
		$s = 31
	ElseIf $s = 31 Then
		$s = 61
	ElseIf $s = 61 Then
		$s = 73
	ElseIf $s = 73 Then
		$s = 93
	ElseIf $s = 93 Then
		$s = 139
	EndIf
EndFunc   ;==>Speed
Func Quest()
	$t = $t + $s * 5000
EndFunc   ;==>Boost
Func Cheat()
	$t = $t + $s * 20000
	If Random(1, 10, 1) = 10 Then
		MsgBox(0, "Cought!", "You have just been cought cheating! You were banned." & @CRLF & "Time to move on the next game.")
		Exit
	EndIf
EndFunc