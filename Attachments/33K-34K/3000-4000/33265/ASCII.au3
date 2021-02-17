
For $i = 0 to 127
    HotKeySet(Chr($i), "checkpresskey")
Next

While 1
	Sleep(80)
WEnd

Func checkpresskey()
	HotKeySet(@HotKeyPressed)
	Send(@HotKeyPressed)
EndFunc
