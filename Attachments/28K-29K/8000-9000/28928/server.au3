#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Change2CUI=y
#AutoIt3Wrapper_AU3Check_Parameters=-d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#NoTrayIcon
#include "MailSlot.au3"
#include <array.au3>

Global Const $sMailSlotName = "\\.\mailslot\EventLog"
Global $sLastData = ""
Global $hMailSlot = _MailSlotCreate($sMailSlotName)
If @error Then
	MsgBox(48 + 262144, "MailSlot", "Failed to create new account!" & @CRLF & "Probably one using that 'address' already exists.")
	Exit
EndIf
Global $iSize,$sData
while True
	$iSize = _MailSlotCheckForNextMessage($hMailSlot)
	If $iSize Then
		$sData = _MailSlotRead($hMailSlot, $iSize, 1)
		if $sData <> $sLastData Then
			$aRes = StringSplit($sData,"|",1)
			ConsoleWrite($aRes[14] & @CRLF)
			$sLastData = $sData
		EndIf
	EndIf
	Sleep(100)
WEnd

#cs
True|31559|12/17/2009|10:44:22 PM|12/17/2009|10:44:22 PM|102|4|Information|1|ESENT|Jan-PC||Windows7188Windows: 060171000000
Success: Array with the following format:
    [ 0] - True on success, False on failure
    [ 1] - Number of the record
    [ 2] - Date at which this entry was submitted
    [ 3] - Time at which this entry was submitted
    [ 4] - Date at which this entry was received to be written to the log
    [ 5] - Time at which this entry was received to be written to the log
    [ 6] - Event identifier
    [ 7] - Event type. This can be one of the following values:
    1 - Error event
    2 - Warning event
    4 - Information event
    8 - Success audit event
    16 - Failure audit event
    [ 8] - Event type string
    [ 9] - Event category
    [10] - Event source
    [11] - Computer name
    [12] - Username
    [13] - Event description
    [14] - Event data array
#ce
