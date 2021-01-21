;_XLFindRow3.au3
#include"ExcelCom.au3"
;****** Create Blank Files, then add some data to XL file as example in column "Z"  on 
$ReadXLPath=@ScriptDir&"\$ReadXLPath.xls"
$TempCSVPath=@ScriptDir&"\$TempCSVPath.csv"
;_XLCreateBlank($ReadXLPath)
_XLCreateBlank($TempCSVPath)
$DataString="12,7,6,9,23,45,3,17,18,9"&@CRLF&"3,12,7,6,9,23,45,3,17,18"&@CRLF&"3,12,8,6,9,23,45,3,17,18"&@CRLF&"3,12,9,6,9,23,45,3,17,18"
$DataString=StringReplace($DataString,",",@TAB)
$XLRange=_XLpaste($ReadXLPath,1,"Z",11,$DataString,1)
;****** Now Copy Desired range to File, and read line required as String*****************
;_XLcopyRow(ByRef $sFilePath,$Sheet=1, $CopyRange="A1:B20",$Line=1)
$XLCopyRange=_XLCopy($ReadXLPath,1,"A:B")			;Columns A, B (or B, c if yopu want)
$XLCopyRange=_XLCopy($ReadXLPath,1,"Z11:AI14")			;Columns A, B (or B, c if yopu want)
_XLCopyTo($TempCSVPath,1,"A",1,$XLCopyRange)		;copy as range into Temporary Sheet csv
_XLSaveAs($TempCSVPath,$TempCSVPath,"csv")			;save Sheet csv as Dos text csv
_XLclose($TempCSVPath,0); no changes and close workboot; not  Excel
$RowNumberToReadToString=1
; now find correct row in file;
;$File=FileOpen($TempCSVPath,0)
$OnlyString=FileReadLine($TempCSVPath,$RowNumberToReadToString)
;$File=Fileclose($TempCSVPath)
msgbox (0," visible if shown", "$RowNumberToReadToString ="&$RowNumberToReadToString&@crlf&"$OnlyString ="&$OnlyString)

