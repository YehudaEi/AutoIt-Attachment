While 1
	If WinActivate("Unable to install the font", "") Then
		F_F("Unable to install the font")
	Elseif WinActivate("Windows Fonts Folder", "") Then
		F_F("Windows Fonts Folder")
;~ 	Else
;~ 		ExitLoop
	EndIf
WEnd

Func F_F($Title)
	WinActivate($Title, "")
	ControlClick($Title, "", "[CLASS:Button; TEXT:OK; INSTANCE:1]")
	Opt("MouseClickDelay", 1)
	Opt("WinWaitDelay", 1)
EndFunc