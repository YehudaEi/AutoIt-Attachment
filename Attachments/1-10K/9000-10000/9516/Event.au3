#include-once

Global Const $EVENT_TYPE_ERROR = 0x0001
Global Const $EVENT_TYPE_WARNING = 0x0002
Global Const $EVENT_TYPE_INFORMATION = 0x0003

;===============================================================================
;
; Function Name: _EventCreate()
; Description: Creates an event handle
; Parameter(s): $lpSourceName - Text shown under source in event veiwer
; Requirement(s): AutoIt Beta
; Return Value(s): On Success - Handle and @error = 0
;                  On Failure - -1 and @error <> 0
; Author(s): Emperor
;
;===============================================================================
Func _EventCreate($lpSourceName = @ScriptName)
	Local $Return = DllCall("advapi32.dll", "long", "RegisterEventSource", "ptr", 0, "str", $lpSourceName)
	If @error Then
		Return -1
	EndIf
	If $Return[0] = 0 Then
		SetError(1)
		Return -1
	EndIf
	Return $Return[0]
EndFunc   ;==>_EventCreate

;===============================================================================
;
; Function Name: _EventWrite()
; Description: Reports an event to the event log
; Parameter(s): $hEventLog - Handle of event
;               $wType - Event type
;               $lpStrings - Information to be included in report
; Requirement(s): AutoIt Beta
; Return Value(s): On Success - 1 and @error = 0
;                  On Failure - -1 and @error <> 0
; Author(s): Emperor
;
;===============================================================================
Func _EventWrite(ByRef $hEventLog, $wType, $lpStrings)
	Local $MainData = DllStructCreate("char[32]")
	DllStructSetData($MainData, 1, $lpStrings)
	Local $MainVar = DllStructCreate("int")
	DllStructSetData($MainVar, 1, DllStructGetPtr($MainData))
	Local $Return = DllCall("advapi32.dll", "long", "ReportEvent", "long", $hEventLog, "int", $wType, "int", 0, "int", 0x1003, "int", 0, "int", 1, "int", 0, "ptr", DllStructGetPtr($MainVar), "ptr", 0)
	If @error Then
		Return -1
	EndIf
	If $Return[0] = 0 Then
		SetError(1)
		Return -1
	EndIf
	Return $Return[0]
EndFunc   ;==>_EventWrite

;===============================================================================
;
; Function Name: _EventClose()
; Description: Closes an event handle
; Parameter(s): $hEventLog - Handle of event
; Requirement(s): AutoIt Beta
; Return Value(s): On Success - 1 and @error = 0
;                  On Failure - -1 and @error <> 0
; Author(s): Emperor
;
;===============================================================================
Func _EventClose(ByRef $hEventLog)
	Local $Return = DllCall("advapi32.dll", "int", "DeregisterEventSource", "long", $hEventLog)
	If @error Then
		Return -1
	EndIf
	If $Return[0] = 0 Then
		SetError(1)
		Return -1
	EndIf
	Return $Return[0]
EndFunc   ;==>_EventClose

;===============================================================================
;
; Function Name: _EventClear()
; Description: Clears an event handle
; Parameter(s): $hEventLog - Handle of event
; Requirement(s): AutoIt Beta
; Return Value(s): On Success - Nonzero and @error = 0
;                  On Failure - -1 and @error <> 0
; Author(s): Emperor
;
;===============================================================================
Func _EventClear(ByRef $hEventLog)
	Local $Return = DllCall("advapi32.dll", "int", "ClearEventLog", "long", $hEventLog, "ptr", 0)
	If @error Then
		Return -1
	EndIf
	If $Return[0] = 0 Then
		SetError(1)
		Return -1
	EndIf
	Return $Return[0]
EndFunc   ;==>_EventClear