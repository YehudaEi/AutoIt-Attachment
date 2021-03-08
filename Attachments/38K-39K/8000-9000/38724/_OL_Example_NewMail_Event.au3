#AutoIt3Wrapper_Au3Check_Parameters= -d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6
#AutoIt3Wrapper_Au3Check_Stop_OnWarning=Y
#include <OutlookEX.au3>

; *****************************************************************************
; Example Script
; Handle Outlook NewmailEX event when a new mail arrives.
; This script loops until Shift-Alt-E is pressed to exit.
; *****************************************************************************
HotKeySet("+!e", "_Exit") ;Shift-Alt-E to Exit the script
MsgBox(64, "OutlookEX UDF Example Script", "Hotkey to exit the script: 'Shift-Alt-E'!")

Global $oOApp = ObjCreate("Outlook.Application")
Global $test = ObjEvent($oOApp, "oOApp_")

While 1
	Sleep(10)
WEnd

; Outlook 2007 - NewMailEx event - http://msdn.microsoft.com/en-us/library/bb147646%28v=office.12%29.aspx
Func oOApp_NewMailEx($sOL_EntryId)

	Local $oOL_Item = $oOApp.Session.GetItemFromID($sOL_EntryId, Default)
	MsgBox(64, "OutlookEX UDF Example Script", "New mail has arrived!" & @CRLF & @CRLF & _
			"From:    " & $oOL_Item.SenderName & @CRLF & _
			"Subject: " & $oOL_Item.Subject)

EndFunc   ;==>oOApp_NewMailEx

Func _Exit()
	Exit
EndFunc   ;==>_Exit