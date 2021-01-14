#NoTrayIcon
#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.2.2.0
 Author:         Vacuus

 Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------

; Does the USB Drive exist?
$usb = IniRead("Flashback.ini", "Default", "USB_Drive", "NONE")
$BackupDir = IniRead("Flashback.ini", "Default", "Backup_Folder", "NONE")
$CopyDir = IniRead("Flashback.ini", "Default", "Copy_Folder", "NONE")
$ClearUSB = IniRead("Flashback.ini", "Default", "Clear_USB", "NONE")
if $usb == "NONE" Then
	Local $alph[24]
	$alph[0] = "c"
	$alph[1] = "d"
	$alph[2] = "e"
	$alph[3] = "f"
	$alph[4] = "g"
	$alph[5] = "h"
	$alph[6] = "i"
	$alph[7] = "j"
	$alph[8] = "k"
	$alph[9] = "l"
	$alph[10] = "m"
	$alph[11] = "n"
	$alph[12] = "o"
	$alph[13] = "p"
	$alph[14] = "q"
	$alph[15] = "r"
	$alph[16] = "s"
	$alph[17] = "t"
	$alph[18] = "u"
	$alph[19] = "v"
	$alph[20] = "w"
	$alph[21] = "x"
	$alph[22] = "y"
	$alph[23] = "z"

	$numDrives = 0
	Local $removables[24]


	for $letter in $alph
		if DriveGetType($letter&':'&'/') == "Removable" Then
			$removables[$numDrives] = $letter
			$numDrives += 1
		EndIf
	next

	reDim $removables[($numDrives)]

	for $drive in $removables
		$ret = MsgBox(35, "Flashback", "Is "&$drive&":\ your desired drive for Flashback?")
		Switch $ret
		case 2
			Exit
		case 6
			$usb = $drive
			IniWrite("Flashback.ini","Default","USB_Drive",$usb)
			ExitLoop
		EndSwitch
	next
EndIf

if $BackupDir == "NONE" Then
	while $BackupDir == "NONE"
		$bDir = FileSelectFolder("Please select the root directory for backups", "", 3)
		if $bDir <> "" Then
			$BackupDir = $bDir
			IniWrite("Flashback.ini", "Default", "Backup_Folder", $BackupDir)
			ExitLoop
		EndIf
	WEnd
EndIf

If $CopyDir == "NONE" Then
	while $CopyDir =="NONE"
		$cDir = FileSelectFolder("Please select the root directory of files to copy", "", 3)
		If $cDir <> "" Then
			$CopyDir = $cDir
			IniWrite("Flashback.ini", "Default", "Copy_Folder", $CopyDir)
			ExitLoop
		EndIf
	WEnd
EndIf
If $ClearUSB == "NONE" Then
	$ret = MsgBox(35, "Clear USB?", "Would you like to have your flash drive cleared before copying? (You will have a backup)")
	Switch $ret
	Case 2
		Exit
	Case 7
		$ClearUSB = "No"
	Case 6
		$ClearUSB = "Yes"
	EndSwitch
	IniWrite("Flashback.ini", "Default", "Clear_USB", $ClearUSB)
EndIf

If Not FileExists($usb&":\") Then
	MsgBox(32, "Error!", "Please check if your USB drive is plugged in correctly at "&$usb&":\ !")
	IniWrite("Flashback.ini", "Default", "USB_Drive", "NONE")
	Exit
EndIf

;Now That we're configured, backup:
$ret = DirCopy($usb&':\', $BackupDir&'\'&@YEAR&'\'&@MON&'\'&@MDAY, 1)
If $ret == 0 Then
	MsgBox(48, "Error!", "Couldn't copy from "&$usb&":\ To "&$BackupDir&'\'&@YEAR&'\'&@MON&'\'&@MDAY)
	Exit
EndIf

;Update the USB!
If $ClearUSB == "Yes" Then
	DirRemove($usb&":\", 1)
EndIf
If StringInStr($CopyDir, "\", 0, -1) == 0 Then
	$ret &= "\"
EndIf	
$ret = DirCopy($CopyDir, $usb&":\", 1)
If $ret == 0 Then
	MsgBox(48, "Error!", "Couldn't copy from "&$CopyDir&" To "&$usb&":\")
	Exit
EndIf
MsgBox(0, "Flashback", "Done!")