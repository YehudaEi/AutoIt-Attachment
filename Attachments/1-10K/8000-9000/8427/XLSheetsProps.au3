;XLSheetsProps.au3
#include"ExcelCom.au3"
$FilePath=@ScriptDir&"\book1.xls"
$WorkbookPropArray=_XLSheetProps($FilePath)
_ArrayDisplay($WorkbookPropArray,"Number and name of each sheet")
; read [A1] in each worksheet
global $WorkbookCellArray[$WorkbookPropArray[0]+1]
for $i = 1 to $WorkbookPropArray[0]
$WorkbookCellArray[$i]=_XLread($FilePath,$i,"A",1)
next
_ArrayDisplay($WorkbookCellArray,"Cell contents of A1 in each sheet")
