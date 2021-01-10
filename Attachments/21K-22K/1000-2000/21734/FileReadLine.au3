#include <file.au3>
#include <String.au3>
Dim $file
Dim $line
Dim $result = 0

$file = FileOpen("c:\toto.txt", 0)
$result = IsString("failed")

While 1
	$line = FileRead($file)
	
	If $result = 1 Then
	 	  MsgBox(0, "Ok", "Occurence OK ")
		  ExitLoop
	  Else 
		  MsgBox(0, $line, "Occurence ...")
		  ExitLoop
	EndIf 
Wend
FileClose($file)

