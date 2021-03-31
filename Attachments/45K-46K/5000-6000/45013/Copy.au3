#include <FileConstants.au3>
If ProcessExists( "palemoon.exe" ) Then
If MsgBox(0x24, "Problem", "Palemoon is currently running. Do you want close and continue?") = 6 Then
DirRemove( "C:\Users\Draygoes\Dropbox\tt84i0zg.default\",1 )
DirCopy(@AppDataDir & "\Moonchild Productions\Pale Moon\Profiles\tt84i0zg.default\", "C:\Users\Draygoes\Dropbox\tt84i0zg.default\", 9)
Else
	Exit
EndIf
Else
DirRemove( "C:\Users\Draygoes\Dropbox\tt84i0zg.default\",1 )
DirCopy(@AppDataDir & "\Moonchild Productions\Pale Moon\Profiles\tt84i0zg.default\", "C:\Users\Draygoes\Dropbox\tt84i0zg.default\", 9)
	EndIf