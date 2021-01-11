#include <File.au3>
#include<Array.au3>

;
; AutoIt Version: 3.0
; Language:       English
; Platform:       Win9x/NT/2000
; Author:         Robins Tomar
;
; Script Function: Gets the defect ids & write them to respective .rc file.
;


$file = FileOpen("copy.txt", 0)

; Check if file opened for reading OK
If $file = -1 Then
    MsgBox(0, "Error", "Unable to open file.")
    Exit
EndIf

; Read in lines of text until the EOF is reached
While 1
	$check_rc = FileRead($file,4)
	If $check_rc = "scm=" Then
    $line = FileReadLine($file)
    If @error = -1 Then ExitLoop
    _FileWriteToLine("paste.txt", 1, $line, 0)
	
	EndIf

Wend

FileClose($file)
