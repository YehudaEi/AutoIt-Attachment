#include-once

;===============================================================================
;
; Description:      Close all windows according to $sd_method
; Syntax:           _ShutDown($sd_method, $sd_leaveopen)
; Parameter(s):     $sd_method - =====================================================
;                         method 0- close all windows and log off
;                         method 1- close all windows and shutdown
;                         method 2- close all windows and reboot
;                         method 3- close all windows
;                         method 4- close all windows except for $sd_leaveopen
;                         =====================================================
;               $sd_leaveopen - "Window Title|Another|and one more"
;
; Requirement(s):   $sd_method
; Return Value(s):  On Success - None
;                   On Failure - None
; Author(s):        AutoItKing <bendudefu [at] aim [dot] com> and Danny35d
; Note(s):          Use with caution!
;
;===============================================================================

Func _ShutDown($SMETHOD, $SLEAVEOPEN = "Program Manager")
	$I = 1
	If Not IsArray($SLEAVEOPEN) Then $SLEAVEOPEN = StringSplit($SLEAVEOPEN, '|')
	$SWINDOWS = WinList()
	While 1
		$FCLOSE = True
		If $SWINDOWS[$I][0] <> "" And BitAND( WinGetState($SWINDOWS[$I][1]), 2) And $SWINDOWS[$I][0] <> "Program Manager" Then
			If $SMETHOD == 4 Then
				For $X = 1 To $SLEAVEOPEN[0]
					If StringInStr($SWINDOWS[$I][0], $SLEAVEOPEN[$X]) <> 0 Then $CLOSE = False
				Next
				If $FCLOSE Then WinClose($SWINDOWS[$I][0])
			Else
				WinClose($SWINDOWS[$I][0])
			EndIf
		EndIf
		$I += 1
		If $I == $SWINDOWS[0][0] Then
			If $SMETHOD == 0 Or $SMETHOD == 1 Or $SMETHOD == 2 Then Shutdown(Int($SMETHOD))
			ExitLoop
		EndIf
	WEnd
EndFunc   ;==>_ShutDown
