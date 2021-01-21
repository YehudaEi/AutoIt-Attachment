Global $Paused
HotKeySet("{F2}", "TogglePause")
HotKeySet("{ESC}", "Terminate")
Call("TogglePause")

While 1
	Send("{F8}")
	Sleep(2000)
WEnd

Func TogglePause()
	$Paused = Not $Paused
	While $Paused
		Sleep(100)
		ToolTip('Script is "Paused"', 0, 0)
	WEnd
	ToolTip("")
EndFunc   ;==>TogglePause

Func Terminate()
	Exit 0
EndFunc   ;==>Terminate