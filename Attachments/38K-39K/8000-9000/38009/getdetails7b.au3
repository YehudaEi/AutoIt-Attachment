;routine to find hard drives and free space,on a computer and to install a program  of the correct
;architecture to the home drive and a folder to the next available drive with enougth space.

Local $aDrives, $iHomeDrive, $iFolderDrive = 0, $sMsg = ""

$aDrives = DriveGetDrive("FIXED")
If @error Then
MsgBox(0, "Error", "Could not get drive information.")
Exit
EndIf

Dim $aDriveInfo[$aDrives[0] + 1][2]
$aDriveInfo[0][0] = $aDrives[0]
For $i=1 to $aDrives[0]
	$aDriveInfo[$i][0] = StringUpper($aDrives[$i])
	$aDriveInfo[$i][1] = DriveSpaceFree($aDrives[$i] & "\")
	If $aDriveInfo[$i][0] = @HomeDrive Then
	   $iHomeDriveFreeSpace = $aDriveInfo[$i][1]
	   $iHomeDrive = $i
   Else
	   If $iFolderDrive == 0 And $aDriveInfo[$i][1] >= 1024 Then $iFolderDrive = $i
   EndIf
   $sMsg &= StringFormat("%s\\ (%.2f MB)\n", $aDriveInfo[$i][0], $aDriveInfo[$i][1])
Next
MsgBox(0, "", $sMsg)
If $aDriveInfo[$iHomeDrive][1] < 1024 Then
MsgBox(0,"Cannot Install","Not enough space or Operating System on wrong Drive"&@OSVersion&@OSArch)
Exit
ElseIf $iFolderDrive == 0 And $aDriveInfo[$iHomeDrive][1] < 2048 Then
	MsgBox(0,"Cannot Install","Not enough space for folders"&@OSVersion&@OSArch)
	Exit
Else
	$sMsg = ""
	If $iFolderDrive == 0 Then $iFolderDrive = $iHomeDrive
	Switch @OSVersion
		Case "WIN_XP"
			Switch @OSArch
				Case "X86"
					;I cannot seem to get the coding correct to install a program to the home drive  and a folder
					;to the folder drive selected as suitable by this routine.

						;eg: run ("$iHomeDrive\temp\myxp32bitprogram")
						;FileMove("$iHomeDrive\temp\myfolder", "$iFolderDrive\myfolder")

						;My problem is manipulating the contents  of the array, the line below tells me where I need
						;to install to.  I need to get the drive letters that the arrays point to.
						;the value of the two variables only point to the location of the contents in the array
						; not the actual content itself.
						; any pointers would be very much appriciated

					$sMsg = StringFormat("Installing 32 bit Software to Drive %s and Folders to Drive %s [%s %s]", _
					    $aDriveInfo[$iHomeDrive][0], $aDriveInfo[$iFolderDrive][0], @OSVersion, @OSArch)
						MsgBox(0, "", "XP 32bit Case expression was true")


				Case "IA64", "X64"
					$sMsg = StringFormat("Installing 64 bit Software to Drive %s and Folders to Drive %s [%s %s]", _
						$aDriveInfo[$iHomeDrive][0], $aDriveInfo[$iFolderDrive][0], @OSVersion, @OSArch)
			EndSwitch
			MsgBox(0, "", $sMsg)


	EndSwitch
EndIf