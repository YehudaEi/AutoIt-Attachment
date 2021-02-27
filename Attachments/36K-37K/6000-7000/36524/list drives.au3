
Local $Drive = DriveGetDrive("ALL")
If @error Then
    ; An error occurred when retrieving the drives.
    MsgBox(4096, "List Drives", "It appears an error occurred.")
Else
    For $i = 1 To $Drive[0]
        ; Show all the drives found and convert the drive letter to uppercase.
		MsgBox(4096, "DriveGetDrive", "Drive " & $i & "/" & $Drive[0] & ":" & @CRLF & StringUpper($Drive[$i]))




	Next
EndIf


