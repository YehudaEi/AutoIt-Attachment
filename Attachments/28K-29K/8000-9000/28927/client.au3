#NoTrayIcon
#include <GuiConstantsEx.au3>
#include <EventLog.au3>
#include <WinAPI.au3>
#include <array.au3>
#include "mailslot.au3"

Global $hEventLog,$hEvent,$sEventLog = "System", $sLastEvent = ""
Global Const $sServer = @ComputerName
Global Const $sMailSlotName = "\\"&$sServer&"\mailslot\EventLog"

service_start()
service_running()
service_end()

Func service_start()
	$hEventLog = _EventLog__Open("", $sEventLog)
	$hEvent = _WinAPI_CreateEvent(0, False, False, "")
	_EventLog__Notify($hEventLog, $hEvent)
EndFunc   ;==>service_start

Func service_running()
	Local $iResult,$res
	While True
		$iResult = _WinAPI_WaitForSingleObject($hEvent,0)
		if $iResult <> -1 Then
			$iEventLogCount = _EventLog__Count($hEventLog)
			$aResult = _EventLog__Read($hEventLog,False,False,$iEventLogCount)
			$sDataToSend = _ArrayToString($aResult)
			if $sDataToSend <> $sLastEvent Then
				_MailSlotWrite($sMailSlotName, $sDataToSend)
				$sLastEvent = $sDataToSend
			EndIf
		EndIf
		Sleep(1)
	WEnd
EndFunc   ;==>service_running

Func service_end()
	_WinAPI_CloseHandle($hEvent)
	_EventLog__Close($hEventLog)
EndFunc   ;==>service_end
