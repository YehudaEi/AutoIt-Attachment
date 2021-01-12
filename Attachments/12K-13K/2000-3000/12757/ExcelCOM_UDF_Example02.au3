; ExcelCOM Example 02 by SEO
; 01/05/07

; Create book, write a table on first sheet, create some formulas, save, close

#include <ExcelCOM_UDF.au3>  ; Include the function collection

; Open new book, make it visible
Local $oExcel = _ExcelBookNew(1)

; Write a message to the first cell of the first sheet
_ExcelWriteCell($oExcel, "I'm going to create a table of data and use formulas on it", "A1")

; We can fill part of the table up using a simple loop
For $xx = 2 to 11
	For $yy = 3 to 10
		_ExcelWriteCell($oExcel, Random(22, 200), $yy, $xx)
	Next
Next

; And we can fill the rest of the table up using the _ExcelWriteArray() function
Dim $aTempArray[10]
For $yy = 11 to 20
	For $temp = 0 to 9
		$aTempArray[$temp] = Random(22, 200)
	Next
	; Write the zero-based array from left to write starting at cell 11, 1
	_ExcelWriteArray($oExcel, $yy, 2, $aTempArray, 0, 0)
Next

; Run a line across the bottom of the table
_ExcelWriteCell($oExcel, "'================================================================================", 21, 2)

; Create a "totals" line with SUM formulas
_ExcelWriteCell($oExcel, "Totals:", 22, 1)				; Just a row header
_ExcelWriteFormula($oExcel, "=SUM(B3:B20)", "B22")		; Create the formula for the leftmost cell
_ExcelCopy($oExcel, "B22")								; Copy the formula to clipboard
_ExcelPaste($oExcel, "C22:K22")							; Paste the formula across the rest of the row

; Create an "averages" line with AVERAGE formulas
_ExcelWriteCell($oExcel, "Averages:", 23, 1)
_ExcelWriteFormula($oExcel, "=AVERAGE(B3:B20)", "B23")
_ExcelCopy($oExcel, "B23")
_ExcelPaste($oExcel, "C23:K23")

; Create a "minimum" line with MIN formulas
_ExcelWriteCell($oExcel, "Minimum:", 24, 1)
_ExcelWriteFormula($oExcel, "=MIN(B3:B20)", "B24")
_ExcelCopy($oExcel, "B24")
_ExcelPaste($oExcel, "C24:K24")

; Create a "maximum" line with MAX formulas
_ExcelWriteCell($oExcel, "Maximum:", 25, 1)
_ExcelWriteFormula($oExcel, "=MAX(B3:B20)", "B25")
_ExcelCopy($oExcel, "B25")
_ExcelPaste($oExcel, "C25:K25")

; Wait for user input
MsgBox(0, "", "Click OK to save to temp dir, and quit")

; Now we save it into the temp directory; overwrite existing file if necessary
_ExcelBookSaveAs($oExcel, @TempDir & "\temp.xls", "xls", 0, 1)

; And finally we close out
_ExcelBookClose($oExcel)
