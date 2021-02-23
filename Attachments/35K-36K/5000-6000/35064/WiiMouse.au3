#include <GUIConstantsEx.au3>
#include "Wiimote.au3"

; Wiimote key setup :
;   A		- primary mouse button (default = left)
;   B		- double click primary mouse button
;   -		- middle mouse button
;   +		- secondary mouse button (default = right)
;   HOME	- Exit program

;Set a default keyboard escape in case things go wonky
HotKeySet('{ESC}', '_Close')

; Create a default window showing Wiimote X / Y
Global $main = GUICreate("WiiMouse",110,20,1,1)
Global $lblx = GUICtrlCreateLabel("",1,1,50)
Global $lbly = GUICtrlCreateLabel("",51,1,50)

; Minimize the window to display the desktop
GUISetState(@SW_MINIMIZE)

; Global declarations
Global $WiiMotion[8]            ; Define the motion array
; IR screen dimensions are 1023 x 767 scale up to 1360 x 768
Global Const $xfactor = 1.33    ; Scaling factor for X
Global Const $yfactor = 1.04    ; Scaling factor for Y

;ConsoleWrite("desktop width="&@DesktopWidth&" hieght="&@DesktopHeight&@CRLF)
;ConsoleWrite("xfactor="&$xfactor&" yfactor="&$yfactor&@CRLF)

$Found = _Wii_Startup($main) ; Start up the Wiimote functions
Global $Wii = _Wii_Connect() ; Connect to the Wiimote
If @error Then
	MsgBox(1,'Error', 'Could not connnect to wiimote')
	Exit
EndIf

; Define the button and motion handlers
_Wii_SetButtonHandler($Wii, '_ButtonPressed')
_Wii_SetIRTrackingMode($Wii,1) ; Turn on IR tracking
_Wii_SetIRDotTrackingHandler($Wii, '_Motion')

; Main message handling loop
Do
	; Check for Wiimote or GUI messages
	_Wii_CheckMsgs()
	$nMsg = GUIGetMsg()

	; Check to see if GUI requested exit
	If $nMsg = $GUI_EVENT_CLOSE Then Exit

	; Display Wiimote X / Y data
	GUICtrlSetData($lblx, $WiiMotion[0]&" / "&$WiiMotion[1])
	GUICtrlSetData($lbly, $WiiMotion[4]&" / "&$WiiMotion[5])

	; If the Wiimote X / Y have changed move the mouse to where it is pointing
	If $WiiMotion[0] = 0 And $WiiMotion[1] And $WiiMotion[4] <> 0 And $WiiMotion[5] <> 0 Then
		MouseMove(Int($WiiMotion[4] * $xfactor), Int($WiiMotion[5] * $yfactor),0)
	EndIf
; Pause 5 milliseconds to allow messages to get processed
Until Not Sleep(5)

Exit

; Hotkey requested exit
Func _Close()
	Exit
EndFunc

; Convert Wiimote code to button name
Func _GetButtonString($iButton)
	Switch $iButton
		Case 1
			Return 'A'
		Case 2
			Return 'B'
		Case 3
			Return 'UP'
		Case 4
			Return 'DOWN'
		Case 5
			Return 'LEFT'
		Case 6
			Return 'RIGHT'
		Case 7
			Return 'MINUS'
		Case 8
			Return 'PLUS'
		Case 9
			Return 'ONE'
		Case 10
			Return 'TWO'
		Case 11
			Return 'HOME'
	EndSwitch
EndFunc

; Wiimote button handler
Func _ButtonPressed($sButton)
	If $sButton[0] = 6 Then
		Local $but = _GetButtonString($sButton[1])
		Switch $but
			Case 'A'
				MouseClick("primary")
			Case 'B'
				MouseClick("primary",Default,Default,2)
			Case 'PLUS'
				MouseClick("secondary")
			Case 'MINUS'
				MouseClick("middle")
			Case 'UP'
			Case 'DOWN'
			Case 'LEFT'
			Case 'RIGHT'
			Case 'ONE'
			Case 'TWO'
			Case 'HOME'
				Exit
		EndSwitch
	EndIf
EndFunc   ;==&gt;_ButtonPressed

; Wiimote motion handler
Func _Motion($aMotion)
	; Copy array if first IR dot passed to handler
	If $aMotion[0] = 0 Then $WiiMotion = $aMotion
EndFunc   ;==>_Motion
