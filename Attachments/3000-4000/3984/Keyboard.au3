HotKeySet("{Esc}", "Terminate")
HotKeySet("{F9}", "Done")
HotKeySet("{F1}", "Speed1")
HotKeySet("{F2}", "Speed2")
HotKeySet("{F3}", "Speed3")
HotKeySet("{F4}", "Speed4")
HotKeySet("{F5}", "Speed5")
HotKeySet("{F6}", "Speed6")
HotKeySet("{F7}", "Speed7")
HotKeySet("{F8}", "Speed8")
opt("SendCapslockMode", 0)
Global $loop, $speed
$speed = 500
MsgBox(0, "Info", "This program makes the lock lights on your keyboard light up in patterns." & @CRLF & "Functions are:" & @CRLF & "F1 - F8: Speeds" & @CRLF & "F9: Change pattern" & @CRLF & @CRLF & "ESC to stop.")

While 1
	Loop1()
	Loop2()
	Loop3()
	Loop4()
	Loop5()
	Loop6()
	Loop7()
WEnd

Func Terminate()
	Send("{NUMLOCK on}{CAPSLOCK off}{SCROLLLOCK off}")
	Exit
EndFunc   ;==>Terminate

Func Done()
	$loop = 0
EndFunc   ;==>Done

Func Loop1()
	$loop = 1
	Send("{NUMLOCK off}{CAPSLOCK off}{SCROLLLOCK off}")
	While $loop
		Sleep($speed)
		Send("{NUMLOCK toggle}")
		Sleep($speed)
		Send("{CAPSLOCK toggle}")
		Sleep($speed)
		Send("{SCROLLLOCK toggle}")
	WEnd
EndFunc   ;==>Loop1

Func Loop2()
	$loop = 1
	Send("{NUMLOCK on}{CAPSLOCK off}{SCROLLLOCK on}")
	While $loop
		Sleep($speed)
		Send("{NUMLOCK toggle}{CAPSLOCK toggle}{SCROLLLOCK toggle}")
	WEnd
EndFunc   ;==>Loop2

Func Loop3()
	$loop = 1
	Send("{NUMLOCK on}{CAPSLOCK on}{SCROLLLOCK off}")
	While $loop
		Sleep($speed)
		Send("{NUMLOCK toggle}{SCROLLLOCK toggle}")
	WEnd
EndFunc   ;==>Loop3

Func Loop4()
	$loop = 1
	Send("{NUMLOCK off}{CAPSLOCK off}{SCROLLLOCK off}")
	While $loop
		Sleep($speed)
		Send("{NUMLOCK toggle}{CAPSLOCK toggle}{SCROLLLOCK toggle}")
	WEnd
EndFunc   ;==>Loop4

Func Loop5()
	$loop = 1
	Send("{NUMLOCK on}{CAPSLOCK on}{SCROLLLOCK off}")
	While $loop
		Sleep($speed)
		Send("{NUMLOCK toggle}{SCROLLLOCK toggle}")
		Sleep($speed)
		Send("{NUMLOCK toggle}{CAPSLOCK toggle}")
		Sleep($speed)
		Send("{CAPSLOCK toggle}{SCROLLLOCK toggle}")
	WEnd
EndFunc   ;==>Loop5

Func Loop6()
	$loop = 1
	Send("{NUMLOCK on}{CAPSLOCK off}{SCROLLLOCK off}")
	While $loop
		Sleep($speed)
		Send("{NUMLOCK toggle}{CAPSLOCK toggle}")
		Sleep($speed)
		Send("{CAPSLOCK toggle}{SCROLLLOCK toggle}")
		Sleep($speed)
		Send("{NUMLOCK toggle}{SCROLLLOCK toggle}")
	WEnd
EndFunc   ;==>Loop6

Func Loop7()
	$loop = 1
	Send("{NUMLOCK on}{CAPSLOCK off}{SCROLLLOCK off}")
	While $loop
		Sleep($speed)
		Send("{NUMLOCK toggle}{CAPSLOCK toggle}")
		Sleep($speed)
		Send("{CAPSLOCK toggle}{SCROLLLOCK toggle}")
		Sleep($speed)
		Send("{CAPSLOCK toggle}{SCROLLLOCK toggle}")
		Sleep($speed)
		Send("{NUMLOCK toggle}{CAPSLOCK toggle}")
	WEnd
EndFunc   ;==>Loop7

Func Speed1()
	$speed = 50
EndFunc   ;==>Speed1

Func Speed2()
	$speed = 100
EndFunc   ;==>Speed2

Func Speed3()
	$speed = 150
EndFunc   ;==>Speed3

Func Speed4()
	$speed = 200
EndFunc   ;==>Speed4

Func Speed5()
	$speed = 250
EndFunc   ;==>Speed5

Func Speed6()
	$speed = 300
EndFunc   ;==>Speed6

Func Speed7()
	$speed = 350
EndFunc   ;==>Speed7

Func Speed8()
	$speed = 400
EndFunc   ;==>Speed8