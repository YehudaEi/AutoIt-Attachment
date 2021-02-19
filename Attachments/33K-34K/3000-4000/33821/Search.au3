
#include <Excel.au3>
#include<Array.au3>
$sFilePath1 = "C:\DOT.xls" 
$oExcel = _ExcelBookOpen($sFilePath1)
$Select_Col = (1)
$sCellValue = _ExcelReadCell($oExcel,$Select_Col)
$sSearch = InputBox("", "find Name")
If $sCellvalue = $sSearch Then
MsgBox(0, "Name Found")
ElseIf
	Exit
Else
MsgBox(0, "Name Not Found")

;If @error Then
;MsgBox(0, "Name Not Found",'"' & $sSearch & '".')
;Else
;MsgBox(0, "Name Found",'"' & $sSearch & '" was found'.')


EndIf


