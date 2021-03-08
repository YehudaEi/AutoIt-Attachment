#AutoIt3Wrapper_Au3Check_Parameters= -d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6
#AutoIt3Wrapper_Au3Check_Stop_OnWarning=Y
#include <OutlookEX.au3>

; *****************************************************************************
; Example Script
; Handle Outlook Folder event when a new item arrives in a folder.
; This script checks the Sent Items folder to display a message when a mail
; has been sent (= a copy of the sent mail is stored in this folder).
; This script loops until Shift-Alt-E is pressed to exit.
; *****************************************************************************
HotKeySet("+!e", "_Exit") ;Shift-Alt-E to Exit the script
MsgBox(64, "OutlookEX UDF Example Script", "Hotkey to exit the script: 'Shift-Alt-E'!")

Global $oOApp = ObjCreate("Outlook.Application")
Global $oItems = $oOApp.GetNamespace("MAPI").GetDefaultFolder($olFolderSentMail).Items
ObjEvent($oItems, "oItems_")

While 1
	Sleep(10)
WEnd

; Outlook 2007 - ItemAdd event - http://msdn.microsoft.com/en-us/library/bb220152%28v=office.12%29.aspx
Func oItems_ItemAdd($oOL_Item)

	MsgBox(64, "OutlookEX UDF Example Script", "Mail has been sent!" & @CRLF & @CRLF & _
			"Subject: " & $oOL_Item.Subject)

EndFunc   ;==>oOFolder_ItemAdd

Func _Exit()
	Exit
EndFunc   ;==>_Exit
