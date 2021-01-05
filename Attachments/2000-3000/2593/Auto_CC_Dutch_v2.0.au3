;Dutch  version of the automated download & install script.

Global $fileExists
$fileExists =  FileExists(@ProgramFilesDir & "\CCleaner\ccleaner.exe")
	
While 1	
If $fileExists = 1 then ExitLoop
If $fileExists = 0 then
	
		$func1 = MsgBox(4100, "", "Crap Cleaner is not installed,  Do you wish to download and install?")
	
		If $func1 = 7 Then Exit
		If $func1 = 6 Then

			Sleep(200)
	
	dim $Size
    $Size=InetGetSize("http://download.ccleaner.com/download1198bin.asp")
    ProgressOn("Crap Cleaner","Downloading")
    $r=InetGet("http://download.ccleaner.com/download1198bin.asp", @DesktopDir & "\ccsetup119.exe" , 0, 1)
    if $r=0 then 
        msgbox(0,"Error","Cant connect to the internet!!")								
		Exit
    EndIf
    
	While @InetGetActive

        ProgressSet(@InetGetBytesRead / $Size * 100,Round( @InetGetBytesRead / $Size * 100,0) & " %")
        Sleep(250)
    Wend
    ProgressOff()


Sleep (200)

Run(@DesktopDir & "\ccsetup119.exe")
Sleep(200)
Send("!u")

WinWaitActive ( "Installer Language", "", 2)
WinSetOnTop ( "Installer Language", "Please select a language.", 1)
WinActivate ( "Installer Language" )

Sleep (300)
ControlFocus("Installer Language", "", 1002)
ControlClick("Installer Language", "", 1002, "left", 1)
Sleep (300)
Send ("n")
Sleep (300)
Send ("{ENTER}")
Sleep (300)

ControlFocus("Installer Language", "OK", 1)
ControlClick("Installer Language", "OK", 1, "left", 1)

WinWaitActive("CCleaner v1.19 Installatie")
Sleep(200)

Send("!v")
Sleep(100)
Send("!a")
Sleep(100)
Send("!v")
Sleep(100)
Send("!i")
Sleep(2000)
Send("!v")
Sleep(1000)

While 1
	$func1 = ControlCommand("CCleaner v1.19 Installatie", "&Voltooien", 1, "IsEnabled", "")
	If $func1 = 1 Then ExitLoop
	If $func1 = 0 Then
		Sleep(200)
	EndIf
WEnd

Sleep(2000)
ControlFocus("CCleaner v1.19 Installatie", "&Voltooien", 1)
ControlClick("CCleaner v1.19 Installatie", "&Voltooien", 1, "left", 1)
MsgBox(64, "Auto-CC", "Installation completed, Going to run Crap Cleaner for the first time.", 2)
FileDelete(@DesktopDir & "\ccsetup119.exe" )
Sleep(2000)

; Run the newly installed program and adjust some setting for future use.

Run(@ProgramFilesDir & "\CCleaner\ccleaner.exe")
WinWaitActive("CCleaner")

; Begin cleaning of the windows section

ControlFocus("CCleaner", "Opschonen", 3)
ControlClick("CCleaner", "Opschonen", 3, "left", 1)

Sleep (200)

ControlFocus("", "Dit bericht voortaan niet meer weergeven", 1)
ControlClick("", "Dit bericht voortaan niet meer weergeven", 1, "left", 1)

Sleep (50)	

ControlFocus("", "OK", 4)
ControlClick("", "OK", 4, "left", 1)

Sleep (50)

; Wait for button to become active then continue

While 1
	If ControlCommand("CCleaner", "Opschonen", 3, "IsEnabled", "") Then ExitLoop
WEnd

For $i = 1 To 8
	Send("{TAB}")
	Sleep(100)
Next
Send("{RIGHT}")
Sleep(100)

ControlFocus("CCleaner", "Opschonen", 3)
ControlClick("CCleaner", "Opschonen", 3, "left", 1)

Sleep (200)

ControlFocus("", "Dit bericht voortaan niet meer weergeven", 1)
ControlClick("", "Dit bericht voortaan niet meer weergeven", 1, "left", 1)

Sleep (50)	

ControlFocus("", "OK", 4)
ControlClick("", "OK", 4, "left", 1)

Sleep (50)

; Wait for button to become active then continue

While 1
	If ControlCommand("CCleaner", "Opschonen", 3, "IsEnabled", "") Then ExitLoop
WEnd

; Begin cleaning errors

For $i = 1 To 8
	Send("{TAB}")
	Sleep(100)
Next
Send("{RIGHT}")
Sleep(100)

ControlFocus("CCleaner", "Scannen naar fouten", 3)
ControlClick("CCleaner", "Scannen naar fouten", 3, "left", 1)

Sleep(2000)

WinWaitActive("CCleaner")

; Wait for button to become active then continue

While 1
	$func1 = ControlCommand("CCleaner", "Herstel geselecteerde fouten...", 4, "IsEnabled", "")
	$func2 = ControlCommand("CCleaner", "Sluiten", 6, "IsEnabled", "")
	
	If $func1 = 1 And $func2 = 1 Then ExitLoop
	If $func1 = 0 And $func2 = 1 Then
		Sleep(2000)
		MsgBox(64, "Auto-CC", "Cleaning Completed")
		ControlFocus("CCleaner", "Sluiten", 6)
		ControlClick("CCleaner", "Sluiten", 6, "left", 1)
		Sleep(2000)
		Exit
	EndIf
WEnd

Sleep(2000)

ControlFocus("CCleaner", "Herstel geselecteerde fouten...", 4)
ControlClick("CCleaner", "Herstel geselecteerde fouten...", 4, "left", 1)

Sleep(300)

Send("!n")

WinWaitActive("Fix issues")
Sleep(100)

ControlFocus("Fix issues", "Herstel alle geselecteerde fouten", 3)
ControlClick("Fix issues", "Herstel alle geselecteerde fouten", 3, "left", 1)

Sleep(300)

Send("{ENTER}")

Sleep(300)

ControlFocus("Fix issues", "Sluiten", 5)
ControlClick("Fix issues", "Sluiten", 5, "left", 1)

Sleep(300)

ControlFocus("CCleaner", "Sluiten", 6)
ControlClick("CCleaner", "Sluiten", 6, "left", 1)

Sleep(300)

MsgBox(64, "Auto-CC", "Cleaning Completed")

Exit
EndIf
EndIf
WEnd

;Section if allready installed

Run(@ProgramFilesDir & "\CCleaner\ccleaner.exe")
WinWaitActive("CCleaner")

; Begin cleaning of the windows section

ControlFocus("CCleaner", "Opschonen", 3)
ControlClick("CCleaner", "Opschonen", 3, "left", 1)

Sleep (200)

; Wait for button to become active then continue

While 1
	If ControlCommand("CCleaner", "Opschonen", 3, "IsEnabled", "") Then ExitLoop
WEnd

; Begin cleaning the applications section
; Tab 8 times, with 100 sleep between.

For $i = 1 To 8
	Send("{TAB}")
	Sleep(100)
Next
Send("{RIGHT}")
Sleep(100)

ControlFocus("CCleaner", "Opschonen", 3)
ControlClick("CCleaner", "Opschonen", 3, "left", 1)

Sleep (200)

; Wait for button to become active then continue

While 1
	If ControlCommand("CCleaner", "Opschonen", 3, "IsEnabled", "") Then ExitLoop
WEnd

; Begin cleaning errors

For $i = 1 To 8
	Send("{TAB}")
	Sleep(100)
Next
Send("{RIGHT}")
Sleep(100)

ControlFocus("CCleaner", "Scannen naar fouten", 3)
ControlClick("CCleaner", "Scannen naar fouten", 3, "left", 1)

Sleep(2000)

WinWaitActive("CCleaner")

; Wait for button to become active then continue

While 1
	$func1 = ControlCommand("CCleaner", "Herstel geselecteerde fouten...", 4, "IsEnabled", "")
	$func2 = ControlCommand("CCleaner", "Sluiten", 6, "IsEnabled", "")
	
	If $func1 = 1 And $func2 = 1 Then ExitLoop
	If $func1 = 0 And $func2 = 1 Then
		Sleep(2000)
		MsgBox(64, "Auto-CC", "Cleaning Completed")
		ControlFocus("CCleaner", "Sluiten", 6)
		ControlClick("CCleaner", "Sluiten", 6, "left", 1)
		Sleep(2000)
		Exit
	EndIf
WEnd

Sleep(2000)

ControlFocus("CCleaner", "Herstel geselecteerde fouten...", 4)
ControlClick("CCleaner", "Herstel geselecteerde fouten...", 4, "left", 1)

Sleep(300)

Send("!n")

WinWaitActive("Fix issues")
Sleep(100)

ControlFocus("Fix issues", "Herstel alle geselecteerde fouten", 3)
ControlClick("Fix issues", "Herstel alle geselecteerde fouten", 3, "left", 1)

Sleep(300)

Send("{ENTER}")

Sleep(300)

ControlFocus("Fix issues", "Sluiten", 5)
ControlClick("Fix issues", "Sluiten", 5, "left", 1)

Sleep(300)

ControlFocus("CCleaner", "Sluiten", 6)
ControlClick("CCleaner", "Sluiten", 6, "left", 1)

Sleep(300)

MsgBox(64, "Auto-CC", "Cleaning Completed")

Exit
	




