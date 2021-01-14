#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.2.2.0
 Author:         myName

 Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------

; Script Start - Add your code below here
HotKeySet("x", "Butterfly")
Global $paused = true
Func Butterfly()
	$paused = false
	Send("{SPACE}")
	Send("w")
	Send("w")
	MouseClick("left")
	Sleep(200)
	Send("{LSHIFT}")
	$paused = true
EndFunc
While $paused = true
	Sleep(500)
WEnd
