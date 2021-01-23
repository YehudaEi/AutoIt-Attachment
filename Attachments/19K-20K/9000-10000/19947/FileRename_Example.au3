#include <FileRename.au3>
#include <File.au3>
_FileCreate(@desktopdir & "\FileRenameTest.au3")
$ren = FileRename(@desktopdir & "\FileRenameTest.au3", "FileRename New name.au3")
MsgBox(34, "Information", "The success code : " & $ren)

