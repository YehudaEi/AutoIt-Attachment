#include <config.au3>
#include <File.au3>
Dim $Directories = _FileListToArray("                                 ","*", 2)
Dim $Files = _FileListToArray("                                 ","*", 1)
If @Error=1 Then
	MsgBox(0,"","No Files\Folders Found.")
	Exit
EndIf
_ArrayDisplay($Directories, "$Directories")
_ArrayDisplay($Files, "$Files")