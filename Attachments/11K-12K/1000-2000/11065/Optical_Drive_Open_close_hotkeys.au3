; Place at the top of your script
; Allows only one instance of this script
$g_szVersion = "CD Hotkey B1"
If WinExists($g_szVersion) Then Exit ; It's already running
AutoItWinSetTitle($g_szVersion)
; Rest of your script goes here
Select 

	Case HotKeySet("^!1") then ;CTRL+ALT+1
		$d = DriveGetDrive("CDROM"); close all optical drives
		For $x = 1 to $d[0]
			CDTray($d[$x],"close")
		EndIf
		Next
	Case HotKeySet("^!2") then ;CTRL+ALT+2
		$d = DriveGetDrive("CDROM"); Open all Optical Drives
		For $x = 1 to $d[0]
			CDTray($d[$x],"open")
		EndIf
		Next
	Case HotKeySet("^!3") then ;CTRL+ALT+3
		$d = DriveGetDrive("CDROM")
		For $x = 1 to $d[0]; Open all Optical Drives
			if DriveStatus($d[$x]) = "NOTREADY" then
				$test = CDTray($d[$x],"open")
		EndIf
		Next
		For $x = 1 to $d[0]; close all optical drives
			if DriveStatus($d[$x]) = "NOTREADY" then
				$test = CDTray($d[$x],"close")
		EndIf
		Next
	Case HotKeySet("^!4") then ;CTRL+ALT+4
		CDTray("F:", "open"); Open the CD tray on drive F:
		EndIf