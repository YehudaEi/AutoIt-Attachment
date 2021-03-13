#include <Excel.au3>
#include <File.au3>
#include <String.au3>

Global $ext,$slnum = "-1"

Func write($book,$val,$row,$col)
	$zVAL = _ExcelReadCell($book,$row - 1,3)
	If _ExcelReadCell($book,$row,3) = $zVAL Then
		_ExcelWriteCell($book,$slnum,$row,10)
	Else
		$slnum += 1
		_ExcelWriteCell($book,$slnum,$row,10)
	EndIf
	$book.Range("G" & $row).Formula="=$A"&$row&"+$D"&$row
	$book.Range("H" & $row).Formula="=$B"&$row&"+$E"&$row
	$book.Range("I" & $row).Formula="=$C"&$row&"+$F"&$row
	If Number(Round($row / $val * 100)) > "0" Then
		$per = Round($row / $val * 100)
		ProgressSet($per,$per & " Percent complete")
	EndIf
EndFunc

Func parse($file,$tmpfile,$book,$lcount)
	ProgressOn("","","",1,1)
	Local $line,$col
	If Not StringInStr(FileRead($file),"GOTO",1) Then
		MsgBox(0,"ERROR",'This is not an "aptsource" file.')
		ex($book,$tmpfile)
	EndIf
	_ExcelWriteCell($book,"in machine datum : xm=-zb ; ym=-xb ; zm=yb with rotation (0.223deg)",1,1)
	_ExcelWriteCell($book,"Xc",2,1)
	_ExcelWriteCell($book,"Yc",2,2)
	_ExcelWriteCell($book,"Zc",2,3)
	_ExcelWriteCell($book,"i",2,4)
	_ExcelWriteCell($book,"j",2,5)
	_ExcelWriteCell($book,"k",2,6)
	_ExcelWriteCell($book,"x+i",2,7)
	_ExcelWriteCell($book,"y+j",2,8)
	_ExcelWriteCell($book,"z+k",2,9)
	_ExcelWriteCell($book,"scan line " & @CRLF & "number",2,10)
	_ExcelHorizontalAlignSet($book,1,1,1,1,"center")
	$book.Range($book.Cells(1,1),$book.Cells(1,10)).MergeCells=True
	$read = StringReplace(FileRead($file),"GOTO","",0,1);_StringStripChr(FileRead($file),"GOTO/ ",8)
	$read = StringReplace($read," ","",0,1)
	$read = FileWrite($tmpfile,StringReplace($read,"/","",0,1))
	For $i = 1 To $lcount
		$read = FileReadLine($tmpfile,$i)
		_ExcelWriteArray($book, $i + 2, 1, _StringExplode($read,","))
		write($book,$lcount,$i + 2,"")
	Next
	$book.columns.autofit
	_ExcelBookSaveAs($book,FileSaveDialog("Save",@MyDocumentsDir,"Excel Files(*.xls;*.xlsx)",18),"xls|xlsx")
	ex($book,$tmpfile)
EndFunc

Func lcount($file)
	If $file = "" Then Exit
	Local $line
	_FileReadToArray($file,$line)
	parse($file,_TempFile(),_ExcelBookNew(1),$line[0])
EndFunc

Func ex($book,$tmpfile)
	_ExcelBookClose($book,0)
	FileDelete($tmpfile)
EndFunc

lcount(FileOpenDialog("Open","","All(*.*)",3))