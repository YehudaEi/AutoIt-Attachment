#include <GUIConstantsEx.au3>

;Set Hotkeys
HotKeySet ("{Esc}", "endnow" )
HotKeySet("^`", "CaptureHotkey") ;Change The '`' To Whatever You Want That'S Not Reserved

While 1
    Sleep(100)
WEnd

Exit

Func CaptureHotkey()
	;1. Capture The Text
	Send("{CTRLDOWN}c") ;Send("{CTRLDOWN}c{CTRLUP}")

	;2. Reformat The Text
	$x = Titlecase(ClipGet())
	ClipPut($x)

	;3. paste the text
	send("^v")

	;fixes 'CTRL' key from sticking
	Send("{CTRLUP}{CTRLUP}")

EndFunc   ;==>CaptureHotkey

Func endnow()
	Exit
EndFunc

Func Titlecase($_x)
	$y = StringLeft($_x, 1)
	$y1 = $y
	$out = StringUpper($y)
	$_x = StringTrimLeft($_x, 1)

	For $i = 0 To StringLen($_x)
		$y = StringLeft($_x, 1)
		If Asc($y1) > 90 And Asc($y1) < 97 or (Asc($y1) < 65 Or Asc($y1) > 122) Then
			$out = $out & StringUpper($y)
		Else
			$out = $out & $y
		EndIf
		$y1 = StringLeft($_x, 1)
		$_x = StringTrimLeft($_x, 1)
	Next
	Return $out
EndFunc   ;==>Titlecase