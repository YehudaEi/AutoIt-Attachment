#include"ExcelCom.au3"
Dim $cFilePath=@ScriptDir&"\book3.csv" , $FilePath=@ScriptDir&"\Blank6.xls"
_XLCreateBlank($FilePath)
$XLCopyRange=_XLCopy($cFilePath,1,"",1)
_XLCopyTo($FilePath,3,"A",5,$XLCopyRange,1)
