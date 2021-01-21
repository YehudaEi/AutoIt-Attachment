#include <File.au3>

$Message_1 = "Does anybody know how to make the 'FileOpenDialog'-Box appear in the middle of the screen" & @CRLF & "instead of at the top-left corner of the screen ?" & @CRLF & "If you click 'OK' you'll see what I mean."
$Message_2 = "Did you notice ? The 'FileOpenDialog'-Box always appears on the top-left corner of the screen."

MsgBox(4096, "Please Help", $Message_1)
$Read_File = FileOpenDialog ( "Open file Dialog Box", @ScriptDir & "\", "AutoIt Files (*.au3)",3,@ScriptFullPath)
If @error = 0 Then
    MsgBox(4096, "Please Help", $Message_2)
Else
    MsgBox(4096, "Please Help", $Message_2)
EndIf
Exit