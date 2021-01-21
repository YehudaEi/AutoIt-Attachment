;ExcelFormulae Ex2.au3
#include"ExcelCom.au3"
$FilePath=@ScriptDir&"\Blank2.xls"
$Formula1="=roman(2005,1)"
$var1=_XLwrite($FilePath,3,"A",1,$Formula1)
$Formula2="=fact(12)"
$var2=_XLwrite($FilePath,3,"A",2,$Formula2)
$Formula3="=sin(radians(30))"
$var3=_XLwrite($FilePath,3,"A",3,$Formula3)
$Formula4="=power(2005,-1.3)"
$var4=_XLwrite($FilePath,3,"A",4,$Formula4)
$Formula5="=power(2005,1/3)"
$var5=_XLwrite($FilePath,3,"A",5,$Formula5)
_XLShow($FilePath,3); no changes and close workbook; not  Excel
msgbox (0,"_XLformula=", $Formula1&"="&@tab&@tab&$var1&@CRLF&$Formula2&"="&@tab&@tab&$var2&@tab&@CRLF&$Formula3&"="&@tab&@tab&$var3&@CRLF&$Formula4&"="&@tab&$var4&@CRLF&$Formula5&"="&@tab&$var5)
_XLClose($FilePath,0); no changes and close workbook; not  Excel
