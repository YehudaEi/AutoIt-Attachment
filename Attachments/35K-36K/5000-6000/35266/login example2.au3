	$active = WinActive("Title of login window here", "text in popup here")
	If $active > 0 Then
		ControlSend("Titel of login window here", "text in popup here", 1003, "MyUsernameHere", 1)
		ControlSend("Titel of login window here", "text in popup here", 1005, "MyPasswordHere", 1)
		Sleep(1000)
		ControlClick("Titel of login window here", "text in popup here", 1)
		Sleep(1000)
		_IELoadWait($oIE)
	Else
		MsgBox(0, "Error", "Login popup niet actief, probeer opnieuw.")
		Exit
	EndIf
EndFunc