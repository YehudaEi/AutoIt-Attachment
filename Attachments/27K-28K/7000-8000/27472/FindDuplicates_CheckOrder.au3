#include <Array.au3>

Dim $File,$ARRAY[1]
Dim $FileReadLine
$file = FileOpen("targetnums.txt", 0)

If $file = -1 Then
    MsgBox(0, "Error", "Unable to open file.")
    Exit
EndIf

While 1
    $line = FileReadLine($file)
    If @error = -1 Then ExitLoop
	_ArrayAdd($ARRAY,$line)
Wend

FileClose($file)

_ArraySort($ARRAY)
_ArrayDisplay($ARRAY)

