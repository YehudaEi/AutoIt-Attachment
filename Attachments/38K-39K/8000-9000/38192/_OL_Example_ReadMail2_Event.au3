; *****************************************************************************
; Handle Outlook events when an item is changed.
; This script loops until Shift-Alt-E is pressed to exit.
; *****************************************************************************
HotKeySet("+!e", "_Exit") 								; Shift-Alt-E to exit the script
MsgBox(64, "OutlookEX UDF Example Script", "Hotkey to exit the script: 'Shift-Alt-E'!")

Global $oItem, $oEvent
Global Const $olViewList = 0 							; The selection is in a list of items in an explorer
Global $oOApp = ObjCreate("Outlook.Application")		; Connect to Outlook
Global $oExplorer = $oOApp.ActiveExplorer()				; Get the active Explorer object
ObjEvent($oExplorer, "oExplorer_")						; Define an event for a selection change
$oItem = $oExplorer.Selection(1) 						; Get first item of the selection
$oEvent = ObjEvent($oItem, "oItem_") 					; Define an event for the first item of the selection
While 1
	Sleep(100)
WEnd

Func oExplorer_SelectionChange()
	If $oExplorer.Selection.Location = $olViewList Then	; Selection changed in the view part of the Explorer
		$oItem = $oExplorer.Selection(1)				; Get first item of the new selection
		$oEvent.Stop									; Stop receiving events for the last selection
		$oEvent = ObjEvent($oItem, "oItem_") 			; Define an event for the first item of the new selection
	EndIf
EndFunc   ;==>oExplorer_SelectionChange

Func oItem_PropertyChange($sProperty)
	For $oSelected In $oExplorer.Selection
		ConsoleWrite($oSelected.Subject & " " & $sProperty & " changed to " & $oSelected.Unread & @CRLF)
	Next
EndFunc   ;==>oMailSelected_PropertyChange

Func _Exit()
	Exit
EndFunc   ;==>_Exit
