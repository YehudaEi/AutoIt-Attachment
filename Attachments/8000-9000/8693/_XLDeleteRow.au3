;_XLCopyRow.au3
#include"ExcelComSimulDel.au3"
;****** Create Blank Files, then add some data to XL file as example in column "Z"  on 
$ReadXLPath=@ScriptDir&"\$ReadXLPath.xls"
_XLCreateBlank($ReadXLPath)
$DataString="12,7,6,9,23,45,3,17,18,9"&@CRLF&"3,12,7,6,9,23,45,3,17,18"&@CRLF&"3,12,8,6,9,23,45,3,17,18"&@CRLF&"3,12,9,6,9,23,45,3,17,18"
$DataString=StringReplace($DataString,",",@TAB)
$XLRange=_XLpaste($ReadXLPath,1,"Z",11,$DataString,1)
;****** Now Copy Desired range to File, and read line required as String*****************
;_XLRowToString($FilePath,$Sheet, $CopyRange,$Line)
;$RowAsString=_XLRowToString($ReadXLPath,1, $XLRange,2)
;msgbox (0," visible if shown", "$RowNumberToReadToString ="&$RowAsString)
;****** Now Delete Row*****************
;_XLDeleteRow(ByRef $s_FilePath, $s_i_Sheet, $i_Row, $s_i_Visible = 0)
$RowAsString=_XLDeleteRow($ReadXLPath,1, 12,1)
msgbox (0," visible if shown", "Deleted Row ="&$RowAsString)
;****** Now Delete Row*****************
;_XLDeleteColumn(ByRef $s_FilePath, $s_i_Sheet, $s_i_Column, $s_i_Visible = 0)
$RowAsString=_XLDeleteColumn($ReadXLPath,1, "AA:AD",1)
msgbox (0," visible if shown", "Column deleted ="&$RowAsString)
