;_XLRowToArrayExample.au3
#include"ExcelCom.au3"
;#include <Array.au3>
$FilePath=@ScriptDir&"\Blank5.xls"
_XLCreateBlank($FilePath)
$DataString="12,7,6,9,23,45,3,17,18,9"&@CRLF&"5,12,7,6,9,23,45,3,17,18"&@CRLF&"7,12,8,6,9,23,45,3,17,18"&@CRLF&"9,12,9,6,9,23,45,3,17,18"
$DataString=StringReplace($DataString,",",@TAB)
$XLRange=_XLpaste($FilePath,1,"A",7,$DataString,1)

;_XLColumnToArray($FilePath,$Sheet,$XLRange,$Line)
$XLColumnToArray=_XLColumnToArray($FilePath,1,$XLRange,3)

;_XLRowToArray($FilePath,$Sheet,$XLRange,$Line)
$XLRowToArray=_XLRowToArray($FilePath,1,$XLRange,3)

_XLShow($FilePath,1)
_ArrayDisplay($XLColumnToArray,"Column")
_ArrayDisplay($XLRowToArray,"Row")
;_XLClose($FilePath,1)
