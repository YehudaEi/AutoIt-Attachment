; ExcelCOM UDF Example #1 by SEO
; Open, write simple data, create formulas, save document

#include"P:\Downloads\_AutoIt\Excel\ExcelDarwin\ExcelCOM_UDF.au3"

$iBegin = MsgBox(1, "ExcelCOM UDF Example #1", _
			"        This example will open Excel, write a simple data table," & @CR _
			& "    create a set of formulas based on that table, then prompt the" & @CR _
			& "user to save the workbook.  Click OK to begin, or CANCEL to exit.")

If $iBegin = 2 Then Exit		; Close out if the user clicked "Cancel"

; Create new workbook, visible, and return an object handle to it
$oExcel = _ExcelBookNew()
$oExcel2 = _ExcelBookNew()

; Write a few tables of data to the workbook using loops (R1C1 format)
For $x = 2 to 9
	For $y = 1 to 20
		_ExcelWriteCellR1C1($oExcel, $y, $x, ($x - 1) * $y)
	Next
Next

; Create a divider line down at the bottom of the tables (A1 format)
_ExcelWriteCellA1($oExcel, "B21", "'=====================================================================")

; Below the divider, create SUM formulas for each table using a loop (R1C1 format)
_ExcelWriteCellA1($oExcel, "A22", "Sum:")
For $x = 2 to 9
	_ExcelWriteFormulaR1C1($oExcel, 22, $x, "=SUM(R1C" & $x & ":R20C" & $x & ")")
Next

; Below the sum, create AVERAGE formulas for each table using copy & paste (A1 format)
_ExcelWriteCellA1($oExcel, "A23", "Average:")
_ExcelWriteFormulaA1($oExcel, "B23", "=AVERAGE(B1:B20)")
_ExcelCopyA1($oExcel, "B23")
_ExcelPasteA1($oExcel2, "C23:I23")

; Below the averages, create MEDIAN formulas for each table using a loop (R1C1 format)
_ExcelWriteCellA1($oExcel, "A24", "Median:")
For $x = 2 to 9
	_ExcelWriteFormulaR1C1($oExcel, 24, $x, "=MEDIAN(R1C" & $x & ":R20C" & $x & ")")
Next

; Prompt user to save the workbook
$iAnswer = MsgBox(4, "Save workbook?", "Would you like to save this workbook?")
If $iAnswer = 7 Then Exit
_ExcelBookSaveAs($oExcel, @DesktopDir & "\dude02.xls")
		
Exit