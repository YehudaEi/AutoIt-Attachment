#include <file.au3>

Dim $file
Dim $lines

$file=FileOpenDialog("Select your file",@DesktopDir,"All files (*.*)")
$lines = _FileCountLines($file)
MsgBox(64, "Processed", "There are " & $lines & " lines in the selected file.")

For $startwork = 3 To $lines Step 4
	WinActivate("[CLASS:Notepad++]", "")
	Send("^g")
	Send("XXX") <-- CAN SEND INCREMENTAL LINE NOs HERE?
...	
	Next

Exit