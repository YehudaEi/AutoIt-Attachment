#include"ExcelCom.au3"
;#include"Array2D.au3"
$FilePath=@ScriptDir&"\book1.xls"
;_XLClose($FilePath, 0)
$XLArray=_XLArrayRead($FilePath,1,"A1:B3")
;_ArrayViewText($XLArray, 'Title')
;exit
;Make any 2D array you like and call it "$XLArray"
$XLArrayAddress=_XLArrayWrite($XLArray,$FilePath,2,"A1",1)
_XLsort($FilePath,"A1",1,"C1",2,$XLArrayAddress,2)
$XLArray=_XLArrayRead($FilePath,2,$XLArrayAddress,1)
;_XLClose($FilePath,1)
MsgBox(0,"","Sorted")