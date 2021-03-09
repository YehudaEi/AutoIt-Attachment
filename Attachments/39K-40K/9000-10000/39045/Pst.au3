#include-once
#include<Array.au3>
Global $str,$drive,$objFile,$objWMIService,$colFiles,$Filepath[1],$Filename[1],$objFSO,$path

Func pst($str,$drive)
$objWMIService = ObjGet("winmgmts:\\" & $str & "\root\cimv2")

$colFiles = $objWMIService.ExecQuery("Select * from CIM_DataFile Where Extension = 'pst' AND Drive = '"&$drive&"'")
If IsObj($colFiles) Then
For $objFile in $colFiles
    ;_ArrayInsert($Filepath,UBound($Filepath)-1,$objFile.Drive & $objFile.Path)
	_ArrayInsert($Filepath,UBound($Filepath)-1,$objFile.Drive & $objFile.Path &$objFile.FileName&".pst")
Next
Return $Filepath
Else
	Return "No PST Found!"
EndIf
EndFunc

Func Foldexist($path)
$objFSO = ObjCreate("Scripting.FileSystemObject")

IF $objFSO.FolderExists($path) THEN
	Return True
ELSE
	Return False
ENDIF
EndFunc
