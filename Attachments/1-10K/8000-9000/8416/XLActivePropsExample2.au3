;XLActivePropsExample2.au3
#include"ExcelCom.au3"
; most of these shorter commands are not visible until you say "_XLshow"
dim $FilePath,$iSheet,$iAddress,$iExcelValue,$iSheetsCount,$iName,$iCurrentRange,$iUsedRange
;** if you want to load a sheet by name first; 
$FilePath=@ScriptDir&"\book1.xls"
;_XLShow($FilePath)
;SYNTAX...._XLGetActive($sFilePath,$Sheet,$Address,$ExcelValue,$SheetsCount,$Name,$CurrentRange,$iUsedRange)====================================
$ArrayProp=_XLGetActive($FilePath,$iSheet,$iAddress,$iExcelValue,$iSheetsCount,$iName,$iCurrentRange,$iUsedRange)
$WorkbookPropArray=_XLSheetProps($FilePath)
;SYNTAX...._XLshow($sFilePath[,$Sheet,$Column,$Row]) ====================================
;_XLShow($FilePath,$iSheet)
_ArrayDisplay($ArrayProp,"Active Book properties")
MsgBox(0,"","$iAddress="&$iAddress&@CRLF&"$iExcelValue="&$iExcelValue&@CRLF&"$FilePath="&$FilePath&@CRLF&"$iSheetsCount="&$iSheetsCount&@CRLF&"$iName="&$iName&@CRLF&"$iSheet="&$iSheet&@CRLF&"$iCurrentRange="&$iCurrentRange&@CRLF&"$iUsedRange="&$iUsedRange)
_ArrayDisplay($WorkbookPropArray,"Number and name of each sheet")
; read [D11] in each worksheet
global $WorkbookCellArray[$WorkbookPropArray[0]+1]
for $i = 1 to $WorkbookPropArray[0]
	;SYNTAX...._XLread($sFilePath,$Sheet,$Column,$Row[,$Visible])====================================
	;$WorkbookCellArray[$i]=_XLread($FilePath,$i,"D11",1,1)
	$WorkbookCellArray[$i]=_XLread($FilePath,$i,"D11",1)
next
;_XLShow($FilePath,$iSheet)
_ArrayDisplay($WorkbookCellArray,"Cell contents of A1 in each sheet")
_XLExit($FilePath)
