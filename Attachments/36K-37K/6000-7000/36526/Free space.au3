

Local $aArray = DriveGetDrive("ALL")
If @error Then
    ; An error occurred when retrieving the drives.
    MsgBox(4096, "DriveGetDrive", "It appears an error occurred.")
Else
    For $i = 1 To $aArray[0]
        ; Show all the drives found and convert the drive letter to uppercase.
        $drive = StringUpper($aArray[$i])
		Local $iFreeSpace = DriveSpaceFree($drive & "\") ; Find the free disk space of the home drive, generally this is the C:\ drive.
		$iFreeSpacegb = $iFreeSpace / 1000
		$iFreeSpacegb2 = Round ( $iFreeSpacegb ,2)
		MsgBox(4096, "Free Space:" & $drive, $iFreeSpacegb2 & " GB")
    Next
EndIf

