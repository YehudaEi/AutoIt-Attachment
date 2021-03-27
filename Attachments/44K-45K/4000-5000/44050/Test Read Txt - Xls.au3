#include <IE.au3>
#include <File.au3>
#include <Array.au3>
#include <Date.au3>
#Include <Excel.au3>
#include <Word.au3>
#include <FTPEx.au3>





$partData = FileReadLine ("Control.txt",2)
$oExcelData = _ExcelBookOpen($partData)


$CellName = FileReadLine ("Control.txt",17)
_ExcelWriteCell ($oExcelData,"Name Malibu",4,$CellName)

$CellPhone = FileReadLine ("Control.txt",8)
_ExcelWriteCell ($oExcelData,"0012848299124",4,$CellPhone)



