#include <Misc.au3>

$speed = 6
$leftDown = 0
$rightDown = 0
$speedHalfed = False

HotKeySet("{NUMPADDIV}", "quit")
HotKeySet("{NUMPADADD}", "speedUp")
HotKeySet("{NUMPADSUB}", "speedDown")

Func leftMouseClick()
	MouseClick("left")
EndFunc

Func rightMouseClick()
	MouseClick("right")
EndFunc

Func speedUp()
	If $speed < 50 Then $speed += 1
EndFunc

Func speedDown()
	If $speed > 1 Then $speed -= 1
EndFunc

HotKeySet("{NUMPAD1}", "doNothing")
HotKeySet("{NUMPAD2}", "doNothing")
HotKeySet("{NUMPAD3}", "doNothing")
HotKeySet("{NUMPAD4}", "doNothing")
HotKeySet("{NUMPAD5}", "doNothing")
HotKeySet("{NUMPAD6}", "doNothing")
HotKeySet("{NUMPAD7}", "doNothing")
HotKeySet("{NUMPAD8}", "doNothing")
HotKeySet("{NUMPAD9}", "doNothing")
HotKeySet("{NUMPAD0}", "doNothing")
HotKeySet("{NUMPADDOT}", "doNothing")


Func doNothing()
	; only here to keep numbers from being passed to the active window when using them as a mouse
EndFunc

while 1
	Sleep(10)
	;  if 5 is pressed and $speedHalfed == 0  (5 key down)
	if _IsPressed(65) And Not $speedHalfed Then
		;$speed = $speed * 0.2 ;original
		;$speed = 1.2
		$speed = $speed /3
		$speedHalfed  = True
	EndIf
	
	; if 5 is NOT pressed and $speedHalfed == 1  (5 key up)
	if Not _IsPressed(65) And $speedHalfed Then
		;$speed = $speed * 5 ;original
		;$speed = 6
		$speed = $speed *3
		$speedHalfed = False
	EndIf
	
	;  0 key is pressed (this is a left mouse click)
	if _IsPressed(60) And $leftDown == 0 Then
		;MouseDown("left")
		MouseClick("left")
		$leftDown = 1
	EndIf
	
	if Not _IsPressed(60) And $leftDown == 1 Then
		;MouseUp("left")
		$leftDown = 0
	EndIf
	
	;  . key is pressed (right mouse click)
	if _IsPressed("6E") And $rightDown == 0 Then
		;MouseDown("right")
		MouseClick("right")
		$rightDown = 1
	EndIf
	
	if not _IsPressed("6E") And $rightDown == 1 Then
		;MouseUp("right")
		$rightDown = 0
	EndIf
	
	; 1 key is pressed
	if _IsPressed(61) Then
		$oldPos = MouseGetPos()
		MouseMove($oldPos[0] - $speed, $oldPos[1] + $speed, 0)
	EndIf
	
	; 2 key is pressed
	if _IsPressed(62) Then
		$oldPos = MouseGetPos()
		MouseMove($oldPos[0], $oldPos[1] + $speed, 0)
	EndIf
	
	; 3 key is pressed
	if _IsPressed(63) Then
		$oldPos = MouseGetPos()
		MouseMove($oldPos[0] + $speed, $oldPos[1] + $speed, 0)
	EndIf
	
	; 4 key is pressed
	if _IsPressed(64) Then
		$oldPos = MouseGetPos()
		MouseMove($oldPos[0] - $speed, $oldPos[1], 0)
	EndIf

	
	; 6 key is pressed
	if _IsPressed(66) Then
		$oldPos = MouseGetPos()
		MouseMove($oldPos[0] + $speed, $oldPos[1], 0)
	EndIf
	
	; 7 key is pressed
	if _IsPressed(67) Then
		$oldPos = MouseGetPos()
		MouseMove($oldPos[0] - $speed, $oldPos[1] - $speed, 0)
	EndIf
	
	; 8 key is pressed
	if _IsPressed(68) Then
		$oldPos = MouseGetPos()
		MouseMove($oldPos[0], $oldPos[1] - $speed, 0)
	EndIf
	
	; 9 key is pressed
	if _IsPressed(69) Then
		$oldPos = MouseGetPos()
		MouseMove($oldPos[0] + $speed, $oldPos[1] - $speed, 0)
	EndIf
	
WEnd

Func quit()
	HotKeySet("{NUMPAD0}")
	HotKeySet("{NUMPAD1}")
	HotKeySet("{NUMPAD2}")
	HotKeySet("{NUMPAD3}")
	HotKeySet("{NUMPAD4}")
	HotKeySet("{NUMPAD5}")
	HotKeySet("{NUMPAD6}")
	HotKeySet("{NUMPAD7}")
	HotKeySet("{NUMPAD8}")
	HotKeySet("{NUMPAD9}")
	HotKeySet("{NUMPADDOT}")
	HotKeySet("{NUMPADADD}")
	HotKeySet("{NUMPADSUB}")
	HotKeySet("{NUMPADDIV}")
	Exit
EndFunc