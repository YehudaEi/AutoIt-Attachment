;####################
; Written by FireLord
;####################
; If you find any mistakes, feel free to fix them.

#include <GUIConstants.au3>
GUICreate("Temp Conversion", 350, 140)
GUISetState()
$flabel = GUICtrlCreateLabeL("Enter Fahrenheit", 15, 18, 80)	
GUICtrlSetColor(-1,0xff0000)    ; Red
$ftemp = GUICtrlCreateInput("", 15, 40, 50, 20)	; Enters Fahrenheit
$fbutton = GUICtrlCreateButton("Calculate", 105, 13)	; Calculates temperature
$clabel = GUICtrlCreateLabeL("Enter Celsius", 180, 18, 80)	
GUICtrlSetColor(-1,0x0000ff)    ; Blue
$ctemp = GUICtrlCreateInput("", 180, 40, 50, 20)	; Enters Celsius
$cbutton = GUICtrlCreateButton("Calculate", 270, 13)	; Calculates temperature

While 1
	$msg = GUIGetMsg()
	Select
		Case $msg = $GUI_Event_Close
			Exit 0
		Case $msg = $fbutton
			$celsius = (GUICtrlRead($ftemp) - 32)/1.8
			GUICtrlCreateLabel($celsius & " degrees celsius equals " & GUICtrlRead($ftemp) & " fahrenheit", 15, 60, 70, 150)
		Case $msg = $cbutton
			$fahrenheit = (GUICtrlRead($ctemp) * (212 -32)/100 + 32)
			GUICtrlCreateLabel($fahrenheit & " degrees fahrenheit equals " & GUICtrlRead($ctemp) & " celsius", 180, 60, 70, 150)
	EndSelect
WEnd