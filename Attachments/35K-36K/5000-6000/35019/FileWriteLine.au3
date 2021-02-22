
#include <Constants.au3>

Local Const $sFile = "c:\hello.txt"
Local $hFile = FileOpen($sFile, 1)

If $hfile = -1 Then
	MsgBox(0, "Error", "Unable to open file.")
	Exit
EndIf

FileWriteLine($hfile, "Line1")
FileWriteLine($hfile, "Line2")
FileWriteLine($hfile, "Line3")

Local $n = FileSetPos($hFile, 0, $FILE_BEGIN)
FileWrite($hfile, "Line4") ; this will always overwrite the first line?
FileClose($hfile)



ShellExecute("c:\hello.txt")