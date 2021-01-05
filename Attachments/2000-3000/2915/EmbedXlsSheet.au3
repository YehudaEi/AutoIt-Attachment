#include "GUIConstants.au3"
; Author:	Roy
; AutoIt Version: 3.1.1.49
; Description: Very Simple example: Embedding Microsoft Office SpreadSheet object 
; Date:	21 jun 2006

$oSpreadSheet = ObjCreate("OWC11.Spreadsheet.11")

; Create a simple GUI for our output
GUICreate ( "Embedded Web control Test", 640, 580,(@DesktopWidth-640)/2, (@DesktopHeight-580)/2 , $WS_OVERLAPPEDWINDOW + $WS_VISIBLE + $WS_CLIPSIBLINGS)
$GUIActiveX			= GUICtrlCreateObj		( $oSpreadSheet,		 10, 40 , 600 , 360 )
$GUI_PutData = GuiCtrlCreateButton	("PutData",	 10, 420, 100,  30)
$GUI_AutoFit	= GuiCtrlCreateButton	("AutoFit",	120, 420, 100,  30)
$GUI_Evaluate	= GuiCtrlCreateButton	("Evaluate",	230, 420, 100,  30)

GUISetState ()       ;Show GUI

; Waiting for user to close the window
While 1
    $msg = GUIGetMsg()
    
	Select
		Case $msg = $GUI_EVENT_CLOSE
			ExitLoop
		Case $msg = $GUI_PutData
			_PutData()
		Case $msg = $GUI_AutoFit
			_AutoFit()
		Case $msg = $GUI_Evaluate
			MsgBox(0,"Evaluate=AVERAGE(5,15,25,33)",$oSpreadSheet.ActiveSheet.Evaluate("=AVERAGE(5,15,25,33)"))
	EndSelect
	
Wend

GUIDelete ()

Exit

Func _PutData()
	Dim $row, $col
	With $oSpreadSheet
		For $row = 1 to 4
			For $col = 1 To 5
				.Cells($row,$col) = "Row " & $row & " - Col: " & $col
			Next
		Next
	EndWith
EndFunc

Func _AutoFit()
	With $oSpreadSheet
		.Cells.Select
        .Cells.EntireColumn.AutoFit
		.Range("A1").Select
	EndWith
EndFunc