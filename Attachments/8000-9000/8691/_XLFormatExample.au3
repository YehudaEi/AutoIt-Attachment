;_XLFormatExample.au3
;#include"ExcelCom.au3"
#include"ExcelComSimulDel.au3"
$FilePath=@ScriptDir&"\Blank5.xls"
$DataString="12,7,6,9,23,45,3,17,18,9"&@CRLF&"3,12,7,6,9,23,45,3,17,18"&@CRLF&"3,12,8,6,9,23,45,3,17,18"&@CRLF&"3,12,9,6,9,23,45,3,17,18"
$DataString=StringReplace($DataString,",",@TAB)
$XLRange=_XLpaste($FilePath,1,"Z",11,$DataString,1)
;=====================================================================================================
;_XLSetColumnWidth(ByRef $s_FilePath, $s_i_Sheet, $s_i_Column, $s_i_ColumnWidth, $s_i_Visible) 
;Notes: $s_i_ColumnWidth can either be a number or "Autofit". For example:
_XLSetColumnWidth($FilePath, 1, 27, "20", 1)
MsgBox(0,"","_XLSetColumnWidth")
;=====================================================================================================
;_XLSetCellFontName(ByRef $s_FilePath, $s_i_Sheet, $s_i_Column, $i_Row, $s_FontName, $s_i_Visible) 
;Notes: Set a cells font, ie 
_XLSetCellFontName($FilePath,1,27,11,"Wingdings",1)
MsgBox(0,"","_XLSetCellFontName")
;=====================================================================================================
;_XLSetCellFontColor(ByRef $s_FilePath, $s_i_Sheet, $s_i_Column, $i_Row, $i_FontColor, $s_i_Visible) 
;Notes: ;Note. '5' is the color code
_XLSetCellFontColor($FilePath,1,$XLRange,11,5,1) 
MsgBox(0,"","_XLSetCellFontColor")
;=====================================================================================================
;_XLSetCellColor(ByRef $s_FilePath, $s_i_Sheet, $s_i_Column, $i_Row, $i_FontColor, $s_i_Visible) 
;Notes: Sets a cell's background color, use in the same way as _XLSetCellFontColor
_XLSetCellColor($FilePath,1,$XLRange,11,6,1) 
_XLSetColumnWidth($FilePath, 1, $XLRange, "Autofit", 1)
MsgBox(0,"","_XLSetCellColor")
