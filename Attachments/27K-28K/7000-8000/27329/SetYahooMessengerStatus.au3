#include <SendMessage.au3>

Global	$YM_MESSAGE_TO_CONTROL=0x0111
Global	$MESSAGE_PARAMETER=388


; Name...........: _SetYahooMessengerStatus
; Description ...: Sets a status message to an opened Y!M Window
; Syntax.........: _SendMessage($sStaus)
; Parameters ....: $sStatus      - Status text/message
; Return values .: Success       - 1 and sets @error to 0
;                  Failure       - 0 and sets @erro to :
;							     - 1, if Y!M execuatble is not found
;								 - 2, if Y!M Window or Process is not found running
; Author ........: Iuli
; Example .......; Yes
Func _SetYahooMessengerStatus($sStatus)
	Local $sID
	Local $hYMHnd

	;Check for Y!M installation
	If Not FileExists(@ProgramFilesDir & "\Yahoo!\Messenger\YahooMessenger.exe") Then
		Return SetError(1,0,0) ;Y!M executale was not found
	EndIf

	;Check if Y!M is running
	If Not WinExists("Yahoo! Messenger") Or Not ProcessExists("YahooMessenger.exe") Then
		Return SetError(2,0,0) ;Y!M Window or Process was not found
	EndIf

	;Read Y!M ID that is using Y!M application
	$sID=RegRead("HKEY_CURRENT_USER\Software\yahoo\pager\","Yahoo! User ID")
	;Set status for the current ID in registry
	RegWrite("HKEY_CURRENT_USER\Software\yahoo\pager\profiles\" & $sID & "\custom msgs\","1_W", "REG_SZ", $sStatus)
	;Send message to Y!M Window to update the new status
	$hYMHnd=WinGetHandle("Yahoo! Messenger")
	_SendMessage($hYMHnd,$YM_MESSAGE_TO_CONTROL,$MESSAGE_PARAMETER)


	Return SetError(0,0,1) ;All done !
EndFunc
