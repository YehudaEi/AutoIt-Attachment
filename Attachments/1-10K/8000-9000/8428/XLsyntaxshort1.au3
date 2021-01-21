;XLsyntaxshort1.au3
#include"ExcelCom.au3"
; none of these shorter commands are visible until you say "_XLshow"
dim $FilePath,$var1,$LastRow
$FilePath=@ScriptDir&"\book1.xls"
$s_Write="a"&@TAB&"b"&@TAB&"c"
If Not FileExists($FilePath) Or Not StringInStr($FilePath, "xls") Then
  $FilePath = FileOpenDialog("Go - Choose your excel file as inbuilt one not exists", $FilePath, "Worksheet" & " (" & "*.xls" & ")", 1)
EndIf
$var1=_XLread($FilePath,1,"A",1)
_XLshow($FilePath,1)
msgbox (0,"_XLread=",$var1)
;$var1=_XLwrite($FilePath,1,"A1:B7",1,"HELLO crows!")
$var1=_XLwrite($FilePath,1,"A",1,"HELLO crows!")
;$var1=_XLpaste($FilePath,1,"A",1,$s_Write,1)
_XLshow($FilePath,1)
;exit
msgbox (0,"_XLwriterange=",$var1)
;$var1=_XLwrite($FilePath,1,"F2",1,"HELLO crows!")
$var1=_XLwrite($FilePath,1,"F2",1,"HELLO crows!")
_XLshow($FilePath,1)
msgbox (0,"_XLwrite=",$var1)
$var1=_XLadd($FilePath,1,"E",7,30)
_XLshow($FilePath,1)
msgbox (0,"_XLadd=",$var1)
$var1=_XLlastRow($FilePath,1)
_XLshow($FilePath,1)
msgbox (0,"_XLlastRow=",$var1)
_XLmacroRun($FilePath,1,"persoNAL.XLS!Macro1")
_XLshow($FilePath,1)
msgbox (0,"_XLmacroRun=","_XLmacroRun")
_XLsave($FilePath,1)
_XLshow($FilePath,1)
msgbox (0,"_XLsave=","_XLsave")
_XLexit($FilePath); Save changes and exit Excel