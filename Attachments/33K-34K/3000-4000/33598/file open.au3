#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.6.1
 Author:         myName

 Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------

; Script Start - Add your code below here

$flopen = FileOpen("C:\Documents and Settings\43633201\Desktop\test.csv",0)
If $flopen = -1 Then
MsgBox(0,"Failure","Failed to open file")
Exit
EndIf
;While 1

$lineVariableName = FileReadLine($flopen,1)
;If @error = -1 Then ExitLoop
MsgBox(0, "MyLine = ", $lineVariableName)
;WEnd
FileClose($flopen)




