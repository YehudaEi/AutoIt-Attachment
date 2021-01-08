;_XLCheckboxExample.au3 0_2
#include"ExcelCom.au3"
$FilePath=@ScriptDir&"\Blank5.xls"
$DataString="12,7,6,9,23,45,3,17,18,9"&@CRLF&"3,12,7,6,9,23,45,3,17,18"&@CRLF&"3,12,8,6,9,23,45,3,17,18"&@CRLF&"3,12,9,6,9,23,45,3,17,18"
$DataString=StringReplace($DataString,",",@TAB)
$XLRange=_XLpaste($FilePath,1,"Z",11,$DataString,1)
_XLSetFontSize($FilePath,1,$XLRange,1,8,1) 
MsgBox(0,"","_XLSetFontSize="&"8")
;=====================================================================================================
;_XLSetFontSize(ByRef $s_FilePath, $s_i_Sheet, $s_i_Column, $i_Row, $i_FontSize, $s_i_Visible)
;Notes: ;Note. '5' is the color code
_XLSetFontSize($FilePath,1,$XLRange,1,14,1) 
MsgBox(0,"","_XLSetFontSize="&"14")
;=====================================================================================================
;_XLCheckBoxValue(ByRef $s_FilePath, $s_i_Sheet, $s_CheckBox)
;$s_CheckBox="CheckBox1"
$FilePath2=@ScriptDir&"\Book5.xls"
;MsgBox(0,"","You will need to make your own file with a tristate checkbox!")
;$s_AnswerValue=_XLCheckBoxValue($FilePath2,2, "CheckBox1",1,1)
$s_AnswerValue=_XLCheckBoxValue($FilePath2,2, "CheckBox1",1,1)
;===================================================================================================
MsgBox(0,"","$s_AnswerValue="&$s_AnswerValue)
_xlclose($FilePath2)