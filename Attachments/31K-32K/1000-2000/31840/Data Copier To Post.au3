; Set up the variables
#include <Excel.au3>
#include <Array.au3>
#include <Constants.au3>
#Include <string.au3>
#Region Variable declarations
Global $sXlsMasterFile = "C:\1data\SLD_Data_Master.xls"
Global $DLFile = "C:\1data\Tester.xls"
#EndRegion

#Region new code
$oExcel = ObjCreate("Excel.Application")
$oExcel.Visible = 2
$oExcel.WorkBooks.Open($sXlsMasterFile)
$oExcel.WorkBooks.Open($DLFile)
$oExcel.Application.ActiveSheet.Range("A2:BB16").select
$oExcel.Application.ActiveSheet.Range("A2:BB16").copy
;$oExcel.WorkBooks.Visible($sXlsMasterFile)    tried this
;$oExcel.WorkBooks.($sXlsMasterFile).Select    tried this
$oExcel.WorkBooks.Select($sXlsMasterFile) ;    tried this
$oExcel.Application.ActiveSheet.Range("A2:BB16").select
$oExcel.Application.ActiveSheet.Range("A2:BB16").paste

#EndRegion

