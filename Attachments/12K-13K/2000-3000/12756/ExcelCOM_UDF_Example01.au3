; ExcelCOM Example 01 by SEO
; 01/05/07

#include <ExcelCOM_UDF.au3>  ; Include the collection

; Open new book, make it visible
Local $oExcel = _ExcelBookNew(1)

; Write a message to the first cell of the first sheet
_ExcelWriteCell($oExcel, "I'm going to fill some cells up with random data", "A1")

; A loop to fill cells up with random data
For $xx = 1 to 10
	For $yy = 3 to 15
		_ExcelWriteCell($oExcel, Random(22, 55), $yy, $xx)
	Next
Next

; Now we'll read a cell and MsgBox the result
Local $sReadCell = _ExcelReadCell($oExcel, "C5")
MsgBox(0, "Cell C5", $sReadCell)

; Now we save it into the temp directory; overwrite existing file if necessary
_ExcelBookSaveAs($oExcel, @TempDir & "\temp.xls", "xls", 0, 1)

; And finally we close out
_ExcelBookClose($oExcel)
