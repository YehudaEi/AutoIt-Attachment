#include <Array.au3>
#include <Excel.au3>
#include <file.au3>

Dim $szDrive, $szDir, $szFName, $szExt


MsgBox(64,"This utility will attempt to convert Lotus wk3 files.","You will be prompted to select the initial file to convert." & @CRLF & "The utility assumes all Lotus files are in the same folder" & @CRLF & "and will attempt to convert all files in that folder.")
Sleep(1500)

$var = FileOpenDialog("Select the first file to convert", @MyDocumentsDir & "\", "Lotus Files (*.wk3)", 3)

If @error Then
    MsgBox(4096,"","No File(s) chosen")
	Exit
EndIf

$LotusPath = _PathSplit($var, $szDrive, $szDir, $szFName, $szExt)
$LotusDir = $LotusPath[1] & $LotusPath[2]

$FileList =_FileListToArray($LotusDir,"*.wk3",1)
If Not IsArray($FileList) Then
	MsgBox(16,"Error","There are no wk3 files located in the specified path.")
	Exit
EndIf

$myExcel = ObjCreate("Excel.Application")
$myExcel.Visible = 0

For $i = 1 to $FileList[0]
	$myExcel.WorkBooks.Open($LotusDir & $FileList[$i])
	$FileName = StringLeft($FileList[$i],(StringLen($FileList[$i]) - 4))
	_ExcelBookSaveAs($myExcel,$LotusDir & $FileName & ".xls")
	_ExcelBookClose($myExcel, 0, 0)
	Sleep(500)
Next

Sleep(2000)
$myExcel.Application.Quit

MsgBox(0,"Lotus wk3 file conversion","Conversion complete")