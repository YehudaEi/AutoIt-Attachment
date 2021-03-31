Func Price()	;Capture value of support horiz line and color it red
;Capture the price and set color of Support Horizontal Line
;Cursor needs to be on the line, which is normal after positioning the line

;Delta Cursor movement Positioning Constants:

Local $edit[]=[50,16]
;Save this delta-moved cursor position (The top left corner of the Edit Horizontal Line popup)
;All other coordinates are referenced from here

Local $value=[177,77]
Local $color[]=[192,50]
Local $Scolor=[222,184]
Local $Dcolor=[270,210]
Local $Tcolor=[366,184]
Local $Bcolor=[293,209]
Local $ColorOK=[203,181]

;Activate Buy Sell Parameters Sheet for data entry
_ExcelSheetActivate($oExcelDP, "Buy Data")
_ExcelWriteCell($oExcelDP, $Prc, 3, 2) ;Write current price to Buy Data Display

;Bring Data for Symbol up
;func BuyDataRow($sym)
$BDrow=BuyDataRow($ActSym)	;Get the row number of buy data for symbol (returns 0 if no data for symbol, sym not found)

if $BDrow=0 Then
	;Set all Buy Entry Data to 0
	_ExcelWriteCell($oExcelDP, $ActSym, 3, 1)
	_ExcelWriteCell($oExcelDP, 0, 3, 3)	;DP Hi
	_ExcelWriteCell($oExcelDP, 100, 3, 4)	;Qty
	_ExcelWriteCell($oExcelDP, 0, 3, 8) ;Buy Price
	_ExcelWriteCell($oExcelDP, 0, 3, 9)	;Tgt
	_ExcelWriteCell($oExcelDP, 0, 3, 10)	;Support
Else
	;Copy data from storage into entry data parameters
	_ExcelWriteCell($oExcelDP, $ActSym, 3, 1)
	_ExcelWriteCell($oExcelDP, _ExcelReadCell($oExcelDP, $BDrow, 54), 3, 3)	;DP Hi
	_ExcelWriteCell($oExcelDP,  _ExcelReadCell($oExcelDP, $BDrow, 55), 3, 4)	;Qty
	_ExcelWriteCell($oExcelDP,  _ExcelReadCell($oExcelDP, $BDrow, 56), 3, 8) ;Buy Price
	_ExcelWriteCell($oExcelDP,  _ExcelReadCell($oExcelDP, $BDrow, 57), 3, 9)	;Tgt
	_ExcelWriteCell($oExcelDP,  _ExcelReadCell($oExcelDP, $BDrow, 58), 3, 10)	;Support
EndIf


MouseClick("left")	;Click on the Horiz Line for edit menue
;sleep(2000)

Local $pos[2]
$pos = MouseGetPos()	;Save the mouse position for the delta position moves
consolewrite("Mouse x,y " & $pos[0] & "," & $pos[1] & @CRLF)


;Move to edit and click

Local $posref[2]

$PosRef[0]=$pos[0]+$edit[0]
$PosRef[1]=$pos[1]+$edit[1]	;Reference cursor position (TL of Edit Popup) for the rest of the click positions
consolewrite("Reference x,y " & $PosRef[0] & "," & $PosRef[1] & @CRLF)


MouseMove($Pos[0]+$edit[0], $Pos[1]+$edit[1], 5) ;Move mouse to the value window of popup window
MouseClick("left")	;Click on edit, to get the edit popup for the horizontal line

MouseMove($PosRef[0]+$value[0], $PosRef[1]+$value[1], 5) ;Move mouse to the value window of popup edit window
MouseClick("left")

;Call("GetElementInfo" ;Get the price value of the line



;NOTE:  THE CALL FUNCTION (ABOVE) CAUSES A MICROSOFT STOPAGE OF THE FUNCTION, BUT THE FUNCTIONS CODE INSERTED(BELOW) WORKS FINE????
Local $hWnd, $i, $parentCount
	Local $tStruct = DllStructCreate($tagPOINT) ; Create a structure that defines the point to be checked.

	$x=MouseGetPos(0)
	$y=MouseGetPos(1)
	DllStructSetData($tStruct, "x", $x)
	DllStructSetData($tStruct, "y", $y)

	$UIA_oUIAutomation.ElementFromPoint($tStruct,$UIA_pUIElement )

	;~ consolewrite("Element from point is passed, trying to convert to object ")
	$oUIElement = objcreateinterface($UIA_pUIElement,$sIID_IUIAutomationElement, $dtagIUIAutomationElement)

If IsObj($oUIElement) Then
	local $title=_UIA_getPropertyValue($oUIElement,$UIA_NamePropertyId)
		EndIf

;Write the Purchase Price Value to Buy Sell Parameters for the symbol
 _ExcelWriteCell($oExcelDP, $title, 3, 8)
;ConsoleWrite("Wrote XO Price Value")

;Store the Updated Data back into data storage
if($BDrow=0) Then
	;Store a new row in data, insert the new row at the top
	_ExcelRowInsert($oExcelDP, 5,1) ;Insert 1 Row at row 5

	_ExcelWriteCell($oExcelDP, $ActSym, 5, 53)
	_ExcelWriteCell($oExcelDP, _ExcelReadCell($oExcelDP, 3,3), 5, 54)	;DP Hi
	_ExcelWriteCell($oExcelDP, _ExcelReadCell($oExcelDP, 3,4), 5, 55)	;Qty
	_ExcelWriteCell($oExcelDP, _ExcelReadCell($oExcelDP, 3,8), 5, 56) ;Buy Price
	_ExcelWriteCell($oExcelDP, _ExcelReadCell($oExcelDP, 3,9), 5, 57)	;Tgt
	_ExcelWriteCell($oExcelDP, _ExcelReadCell($oExcelDP, 3,10), 5, 58)	;Support
Else
	;Copy data from storage into entry data parameters
	_ExcelWriteCell($oExcelDP, $ActSym, $BDrow, 53)
	_ExcelWriteCell($oExcelDP, _ExcelReadCell($oExcelDP, 3,3), $BDrow, 54)	;DP Hi
	_ExcelWriteCell($oExcelDP, _ExcelReadCell($oExcelDP, 3,4), $BDrow, 55)	;Qty
	_ExcelWriteCell($oExcelDP, _ExcelReadCell($oExcelDP, 3,8), $BDrow, 56) ;Buy Price
	_ExcelWriteCell($oExcelDP, _ExcelReadCell($oExcelDP, 3,9), $BDrow, 57)	;Tgt
	_ExcelWriteCell($oExcelDP, _ExcelReadCell($oExcelDP, 3,10), $BDrow, 58)	;Support
EndIf

MouseMove($PosRef[0]+$color[0], $PosRef[1]+$color[1], 5) ;Move mouse to the color select of popup edit window
MouseClick("left")

MouseMove($PosRef[0]+$Bcolor[0], $PosRef[1]+$Bcolor[1], 5) ;Move mouse to the color desired
MouseClick("left")

MouseMove($PosRef[0]+$ColorOK[0], $PosRef[1]+$ColorOK[1], 5) ;Move mouse to OK
MouseClick("left")

EndFunc