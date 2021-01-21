;_XLArrayExample2Single.au3
#include"ExcelCom.au3"
;#include <Array.au3>
$FilePath=@ScriptDir&"\Blank5.xls"
$DataString="12,7,6,9,23,45,3,17,18,9"&@CRLF&"3,12,7,6,9,23,45,3,17,18"&@CRLF&"3,12,8,6,9,23,45,3,17,18"&@CRLF&"3,12,9,6,9,23,45,3,17,18"
$DataString=StringReplace($DataString,",",@TAB)
;MsgBox(0,"","$DataString="&$DataString)
$XLRange=_XLpaste($FilePath,1,"Z",11,$DataString,1)
;MsgBox(0,"","$XLRange="&$XLRange)
$XLArray=_XLArrayRead($FilePath,1,$XLRange)
_Array2dDisplay($XLArray, "Array as read",0)
_Array2DTo1D($XLArray,"Array", 0,9,1)
_XLShow($FilePath,1,"Z",11)
MsgBox(0,"","Here, Sheet 1")
_XLClose($FilePath,1)
