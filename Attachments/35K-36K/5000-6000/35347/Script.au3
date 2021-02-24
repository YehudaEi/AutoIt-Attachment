
; Prompt for Serial Number.
#include <File.au3>
$Loop = 1
While $Loop = 1
$s_serial = InputBox("SERVER", "Scan Parent Serial Number."&@CRLF&"Then Click OK to proceed.")
    If @error = 1 Then
    $answer = MsgBox(4, "WARNING!", "You pressed 'Cancel', Do you want to Exit?")
    If $answer = 6 Then
        Exit
    EndIf
Else
	If $s_serial = "" Then
    MsgBox(4096, "ERROR", "You Must Enter a Serial Number- try again!")
        Else
$Loop = 0
    EndIf
EndIf
WEnd

		DirCreate("C:\customer\$s_serial ")
Exit