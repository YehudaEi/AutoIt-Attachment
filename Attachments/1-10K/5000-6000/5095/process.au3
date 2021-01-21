#include-once

;===============================================================================
;
; Description -   Returns a string containing the process name that belongs to a given PID.
;
; Syntax -        _ProcessGetName( $iPID )
;
; Parameters -    $iPID - The PID of a currently running process
;
; Requirements -  None.
;
; Return Values - Success - The name of the process
;                 Failure - Blank string and sets @error
;                       1 - Process doesn't exist
;                       2 - Error getting process list
;                       3 - No processes found
;
; Author(s) -     Erifash <erifash [at] gmail [dot] com>, Wouter van Kesteren.
;
; Notes -         Supplementary to ProcessExists().
;
;===============================================================================
Func _ProcessGetName( $iPID )
	If Not ProcessExists($i_PID) Then
		SetError(1)
		Return ''
	EndIf
	Local $a_Processes = ProcessList()
	If Not @error Then
		For $i = 1 To $a_Processes[0][0]
			If $a_Processes[$i][1] = $i_PID Then Return $a_Processes[$i][0]
		Next
	EndIf
	SetError(1)
	Return ''
EndFunc   ;==>_ProcessGetName