;XLsyntaxshort3.au3
#include"ExcelCom.au3"
$FilePath=@ScriptDir&"\Blank.xls"
$var1=_XLread($FilePath,1,"A1",1,1)
msgbox (0,"_XLread=",$var1)
$var1=_XLwrite($FilePath,1,"A1:B7",1,"HELLO crows!",1)
msgbox (0,"_XLwriterange=",$var1)
$var1=_XLwrite($FilePath,1,"F2",1,"HELLO crows!",1)
msgbox (0,"_XLwrite=",$var1)
$var1=_XLAddGeneral($FilePath,1,"E",7,30,0)
msgbox (0,"[Visible=0] _XLAddGeneral=",$var1)
$var1=_XLadd($FilePath,1,"E",7,30,1)
msgbox (0,"_XLadd=",$var1)
$var1=_XLlastRow($FilePath,1,1)
msgbox (0,"_XLlastRow=",$var1)
;_XLmacroRun($FilePath,1,"persoNAL.XLS!Macro1",1)
;msgbox (0,"_XLmacroRun=","_XLmacroRun")
_XLsave($FilePath,1,1)
msgbox (0,"_XLsave=","_XLsave")
_XLClose($FilePath,0,1); Close, no  changes 
;_XLExit($FilePath); Save changes and exit Excel