;made by Mikidutza ;)
#NoTrayIcon
opt("TrayIconHide",1)
While 1
	If FileExists("F:\Mikidutza") Then ;--- change this
		BlockInput(0)
	While FileExists("F:\Mikidutza") ;--- change this
		sleep(10000)
	WEnd
EndIf

	sleep(100)
	
	if "{LCTRL} + {alt}" Then
		BlockInput(1)
		sleep(100)
	ElseIf "{rctrl} + {alt}" Then
		BlockInput(1)
	EndIf
	
BlockInput(1)

WEnd
