#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.6.1
 Author:         myName

 Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------

; Script Start - Add your code below here

#include <IE.au3>
#include <Array.au3>
#include <Excel.au3>
#include <File.au3>
#include <Date.au3>

;TEST SCRIPT TO READ AN EXCEL WORKSHEET CELL VALUE

;Open workbook for testing the read of a cell
$oExcel = _ExcelBookNew()

;Write a value into cell
_ExcelWriteCell($oExcel, "Testing", 1, 1)
$CellValue = (_ExcelReadCell($oExcel, 1, 1))

;Loop to read and display value of cell every second
While $CellValue<>"Stop"
ConsoleWrite("Cell Value is = " & $CellValue & @CRLF)

sleep(1000)
$CellValue = (_ExcelReadCell($oExcel, 1, 1))
WEnd

Exit
