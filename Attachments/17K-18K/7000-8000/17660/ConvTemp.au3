;####################
; Written by FireLord
;####################
; If you find any mistakes, feel free to fix them.

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; UPDATE: Changed it up a bit from the previous version,
; just one input and you choose what you want to convert
; from and to.
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

#include <GUIConstants.au3>
$version = "v1.1"
GUICreate("Temp Conversion " & $version, 350, 140)
GUISetState()
$font = "Arial Bold"
$flabel = GUICtrlCreateLabeL("Choose from the conversion selection:", 15, 10, 180)	
$utemp = GUICtrlCreateInput("", 15, 33, 140, 20)	; Enters Temp (K,F,C)
$F_to_C_button = GUICtrlCreateButton ("F to C", 200, 5, 40)
GUICtrlSetFont(-1, 9, 400, -1, $font)
$C_to_F_button = GUICtrlCreateButton ("C to F", 240, 5, 40)
GUICtrlSetFont(-1, 9, 400, -1, $font)
$F_to_K_button = GUICtrlCreateButton ("F to K", 280, 5, 40)
GUICtrlSetFont(-1, 9, 400, -1, $font)
$K_to_F_button = GUICtrlCreateButton ("K to F", 200, 30, 40)
GUICtrlSetFont(-1, 9, 400, -1, $font)
$C_to_K_button = GUICtrlCreateButton ("C to K", 240, 30, 40)
GUICtrlSetFont(-1, 9, 400, -1, $font)
$K_to_C_button = GUICtrlCreateButton ("K to C", 280, 30, 40)
GUICtrlSetFont(-1, 9, 400, -1, $font)


While 1
	$msg = GUIGetMsg()
	Select
		Case $msg = $GUI_Event_Close
			Exit 0
		;Case $msg = $button1
		
		Case $msg = $F_to_C_button
			F_to_C()
		Case $msg = $C_to_F_button
			C_to_F()
		Case $msg = $F_to_K_button
			F_to_K()
		Case $msg = $K_to_F_button
			K_to_F()
		Case $msg = $C_to_K_button
			C_to_K()
		Case $msg = $K_to_C_button
			K_to_C()
	EndSelect
WEnd

Func F_to_C()
	$celsius = (GUICtrlRead($utemp) - 32)/1.8	; Equations
	GUICtrlCreateLabel($celsius & " degrees celsius = " & GUICtrlRead($utemp) & " fahrenheit", 15, 60, 70, 150)
EndFunc

Func C_to_F()
	$fahrenheit = (GUICtrlRead($utemp) * (212 -32)/100 + 32)
	GUICtrlCreateLabel($fahrenheit & " degrees fahrenheit equals " & GUICtrlRead($utemp) & " celsius", 15, 60, 70, 150)
EndFunc

Func F_to_K()
	$kelvin = (GUICtrlRead($utemp) + 459.67) / 1.8
	GUICtrlCreateLabel($kelvin & " degrees kelvin equals " & GUICtrlRead($utemp) & " fahrenheit", 15, 60, 70, 150)
EndFunc

Func K_to_F()
	$fahrenheit = GUICtrlRead(($utemp) * 1.8) - 459.67
	GUICtrlCreateLabel($fahrenheit & " degrees fahrenheit equals " & GUICtrlRead($utemp) & " kelvin", 15, 60, 70, 150)
EndFunc

Func C_to_K()
	$kelvin = GUICtrlRead($utemp) + 273.15
	GUICtrlCreateLabel($kelvin & " degrees kelvin equals " & GUICtrlRead($utemp) & " celsius", 15, 60, 70, 150)
EndFunc

Func K_to_C()
	$celsius = GUICtrlRead($utemp) - 273.15
	GUICtrlCreateLabel($celsius & " degrees celsius equals " & GUICtrlRead($utemp) & " kelvin", 15, 60, 70, 150)
EndFunc