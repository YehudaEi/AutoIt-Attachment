;
; AutoIt Version: 3.0
; Language:       English
; Platform:       WinXP
; Author:         Jason Smith
;
; Script Function:
; 	COPDB Backup Folder Dialog Box

; Set Options
Opt("TrayIconHide", 0)

; Wait time after each action.
$Wait = 50
Sleep($Wait)

; Declare Variables
Dim $dest

; Centres Folder Dialog Box no matter what resolution the monitor is set to.
If StringInStr($cmdlineraw, '/MoveWin') Then
	$cmdlineraw = StringSplit(StringMid($cmdlineraw, StringInStr($cmdlineraw, '/MoveWin')), ':')
	While 1
		Select
			Case WinExists($cmdlineraw[2])
				$size = WinGetPos($cmdlineraw[2])
				$PosX = @DesktopWidth / 2 - $size[2] / 2
				$PosY = @DesktopHeight / 2 - $size[3] / 2
				WinMove($cmdlineraw[2], "", $PosX, $PosY)
				WinActivate($cmdlineraw[2])
				ExitLoop
		EndSelect
		Sleep(50)
	WEnd
	Exit
EndIf

; Read the value of the backup destination in C:\COPDB\Backup.ini file.
$old = IniRead("c:\\COPDB\\Backup.ini", "Backup", "DestinationPath", "")

; Opens Folder Dialog Box for user to choose COPDB backup destination.
Do
	$PID = _FindBrowseWin('Browse for Folder')
	$dest = FileSelectFolder("Choose a destination folder for the COPDB backup." & @CRLF & _
			"If destination is a network drive, map the drive first", "", "3", "c:\")

; If chosen backup destination is "" or user clicks cancel it opens a message box saying folder chosen invalid.
	If @error = 1 Or $old = "" Then
		Sleep($Wait)
		MsgBox(64, "Backup destination invalid", "The COPDB backup destination set is invalid." & @CRLF & _
				"                                                                                        " _
				 & @CRLF & "Add a valid backup destination." & @CRLF & "", 8)

	Else
		Sleep($Wait)
		ExitLoop
	EndIf
Until $dest <> ""
Sleep($Wait)

; Message box saying the C:\COPDB\Backup.ini was updated.
$updated = MsgBox(64, "Backup destination updated", "The COPDB backup destination has been updated." & @CRLF & _
		"                                                                                        " _
		 & @CRLF & "Old Destination -  " & $old & @CRLF & "New Destination - " & $dest & @CRLF & "", 8)
If $updated = 1 Or 2 Then
	IniWrite("C:\\COPDB\\Backup.ini", "Backup", "DestinationPath", $dest)
	Sleep($Wait)
	Exit
EndIf
Exit


; _FindBrowseWin Function.
Func _FindBrowseWin($sTitle)
	If @Compiled Then
		Return (Run(@ScriptFullPath & ' /MoveWin:' & $sTitle))
	Else
		Return (Run(@AutoItExe & ' "' & @ScriptFullPath & '" /MoveWin:' & $sTitle))
	EndIf
EndFunc ;End FindBrowseWin Function.
Exit