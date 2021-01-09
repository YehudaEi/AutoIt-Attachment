;===============================================================================
;
; Function Name:   _MouseClick
; Description::    Adds ability to send mouse clicks not supported by
;					built in MouseClick()
; Parameter(s):    _MouseClick(Button, opt = Keystate)
;					Available buttons: middle, X1, X2
;					Available keystates: down, up, click (= down->up)
; Requirement(s):  user32.dll
; Return Value(s): Sets @error to 1 if DllCall fails
;					 @error to 2 if wrong button specified
;					 @error to 3 if wrong keystate specified
; Author(s):       Markos
;
;===============================================================================
;
#include-once

Func _MouseClick($aButton, $aState = 'click')
	Local $aMultiplier
	Local $dwFlags
	Local $dwData
	
	Switch $aState
		Case 'down'
			$aMultiplier = 1
		Case 'up'
			$aMultiplier = 2
		Case 'click'
			$aMultiplier = 3
		Case Else
			SetError(3)
	EndSwitch
	
	Switch $aButton
		Case 'middle'
			$dwFlags = 32
			$dwData = 0
		Case 'X1'
			$dwFlags = 128
			$dwData = 1
		Case 'X2'
			$dwFlags = 128
			$dwData = 2
		Case Else
			SetError(2)
	EndSwitch
		
	DllCall('user32.dll', 'none', 'mouse_event', 'dword', $dwFlags * $aMultiplier, 'dword', 0, 'dword', 0, 'dword', $dwData, 'ptr', 0) 
	If @error Then SetError(1)
EndFunc