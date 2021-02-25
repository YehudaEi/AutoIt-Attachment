#include-once

; #INDEX# =======================================================================================================================
; Title .........: WinMove
; AutoIt Version : 3.2.10++
; Language ......: English
; Description ...: Functions for manipulating windows.
; Author(s) .....: Ricardo Vermeltfoort
; ===============================================================================================================================

; #CURRENT# =====================================================================================================================
;_WinMove
; ===============================================================================================================================

; #FUNCTION# ====================================================================================================================
; Name...........: _WinMove
; Description ...: Moves and/or resizes a window to get the right control size.
; Syntax.........: _WinMove($title, $text, $controlID, $x, $y, $width, $height[, $speed = Default])
; Parameters ....: $title      - The title of the window to move/resize. See Title special definition.
;                  $text       - The text of the window to move/resize.
;                  $controlID  - The control to interact with. See Controls.
;                  $x          - X coordinate to move to.
;                  $y          - Y coordinate to move to.
;                  $width      - New width of the control.
;                  $height     - New height of the control.
;                  $speed      - [optional] the speed to move the windows in the range 1 (fastest) to 100 (slowest). If not defined the move is instantaneous.
; Return values .: Success - 1
;                  Failure - 0, sets @error
;                  |1 - if control is not found
;                  |2 - if window is not found
; Author ........: Ricardo Vermeltfoort <ricardovermeltfoort at google dot com>
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........: http://www.autoitscript.com/forum/topic/134928-udf-winmove-moves-andor-resizes-a-window-to-get-the-right-control-size/
; Example .......: Yes
; ===============================================================================================================================
Func _WinMove($title, $text, $controlID, $x, $y, $width, $height, $speed = Default)
	Local $handleWin, $handleControl, $state, $posWin, $posControl

	$handleWin = WinGetHandle($title, $text)
	If @error Then Return SetError(2, 0, 0)
	$handleControl = ControlGetHandle($handleWin, Default, $controlID)
	If @error Then Return SetError(1, 0, 0)

	$state = WinGetState($handleWin)
	If BitAND($state, 16) Then
		WinSetState($handleWin, Default, @SW_RESTORE)
	EndIf
	If BitAND($state, 32) Then
		WinSetState($handleWin, Default, @SW_RESTORE)
	EndIf
	$posWin = WinGetPos($handleWin)
	$posControl = ControlGetPos($handleWin, Default, $handleControl)
	WinMove($handleWin, Default, $x, $y, $posWin[2] - $posControl[2] + $width, $posWin[3] - $posControl[3] + $height, $speed)

	Return 1
EndFunc   ;==>_WinMove