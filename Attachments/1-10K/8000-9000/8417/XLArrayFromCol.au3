;XLArrayFromCol.au3
#include"ExcelCom.au3"
$XLFilePath=@ScriptDir&"\book1.xls"
$sFile=@ScriptDir&"\results.txt"
$XLArray=_XLColumnToArray( $XLFilePath,1, "A1:A10")
_Array2dDisplay($XLArray, "Array as read",0)


