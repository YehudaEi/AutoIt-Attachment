#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.6.1
 Author:         David Berliner

 Script Function:
	Format a DVD_RAM disk when the format Button is clicked.

#ce ----------------------------------------------------------------------------

;MonitorWindow()
Opt("GUIOnEventMode", 1)					;Change to on event mode

;Scan for the FORMAT window to be displayed
While 1
	Select
		Case WinActive("Select Action for Deck A","Cannot read deck. It could be unformatted")
;			MsgBox(4096,"Window Test...","The format selection window is open.")
			$EjectHandle = ControlGetHandle("Select Action for Deck A","Cannot read deck. It could be unformatted", "[ID:1]")
			$FormatHandle = ControlGetHandle("Select Action for Deck A","Cannot read deck. It could be unformatted", "[ID:1468]")
			$Eject = GUICtrlSetOnEvent($EjectHandle, "EjectPressed")
			$Format = GUICtrlSetOnEvent($FormatHandle, "FormatPressed")
			ExitLoop
		Case Else						;Handle all other cases
	EndSelect
	Sleep(500)
WEnd

While 1
	Sleep(10)
WEnd

Func EjectPressed()
	MsgBox(4096,"Eject","We are here")
	Exit
EndFunc

Func FormatPressed()
	MsgBox(4096,"Format","We are here")
	Exit
EndFunc

;MsgBox(4096,"Test","We are here")
Exit

;Open a DOS Window and force a FAT32 format
;RunWait( @ComSpec & " /C Format Z:/FS:FAT32 /Q /Y","",@SW_SHOW )


