AdlibRegister("Check",250)
While 1
	Sleep(100)
WEnd

Func Check()
	$Active = WinGetTitle("[Active]")
	$Info = IniReadSection("Windows.ini",$Active)
	If @error Then
		Return
	Else
		ControlSend($Active,$Info[1][1],"",$Info[2][1])
	EndIf
EndFunc
