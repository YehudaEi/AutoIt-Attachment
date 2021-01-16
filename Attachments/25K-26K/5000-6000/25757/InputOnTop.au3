AdlibEnable("SpineInputOnTop")

While 1
	Sleep(500)
WEnd

Func SpineInputOnTop()
	;MsgBox(262144, "Got Here", 1)
	If WinExists("Left Spine Text", "") Then
		;MsgBox(262144, "Got Here", 2)
		WinSetOnTop("Left Spine Text", "", 1)
		AdlibDisable()
		Exit
	ElseIf WinExists("Right Spine Text", "") Then
		WinSetOnTop("Right Spine Text", "", 1)
		AdlibDisable()
		Exit
	EndIf
EndFunc ;=> SpineInputOnTop
