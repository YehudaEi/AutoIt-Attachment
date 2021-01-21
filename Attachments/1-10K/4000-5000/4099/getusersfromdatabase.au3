#include "file.au3"
$linesinfile = _FileCountLines("c:\userlist.txt")
$typeuser = InputBox("username?", "enter username")
;user types name
For $j = 1 to $linesinfile
;this'll happen over every line in the file
$fileuser = FileReadLine("c:\userlist.txt", $j)
;it reads the user database
If $fileuser <> $typeuser Then
;if the name typed by the user isn't the line just read from the file
Do
$j = $j + 2
;add 2 to the line count since the password is on every other line as is the username
$fileuser = FileReadLine("c:\userlist.txt", $j)
;reads from the file on the line equal to $j
Until $fileuser = $typeuser OR $j > $linesinfile
;until the username is found or you reach the end of the file
EndIf
If $fileuser = $typeuser Then
;if the username is right-i hope it is after all that
$j = $j + 1
;adds a number to $j, which remember still is the line number where the username typed in is found
$typepass = InputBox("password?", "enter password for " & $fileuser, "", "*")
;the user types his/her password in, each character is replaced with a *
$filepass = FileReadLine("c:\userlist.txt", $j)
;reads the password from the file
If $filepass <> $typepass Then
;if the idiot user entered a wrong passwd
msgbox(0, "error", "pass not correct!!!")
;displays an error, heres where you'd put an alert to the computer owner
EndIf
If $filepass = $typepass Then
;if the password is corect
MsgBox(0, "Wellcome " & $fileuser, "")
;a wellcome msg, here put the script to login to the shared drive
Exit
EndIf
EndIf
Next
