$NumClass = 0
$button_calc_y = 0
$GUI_height = 0
Func ask()
	$NumClass = InputBox("GPA Calculator", "How many classes are you taking? (2-7)", "", "", 220, 120)
	Call("Check")
	$button_calc_y = (($NumClass - 2) * 25) + 85
	$GUI_height = $button_calc_y + 30
EndFunc
Call("ask")

#include <GUIConstants.au3>

Func Check()
	If $NumClass > 7 Then
		MsgBox(0,"GPA - Error", "Invalid Amount of Classes, must be between 2 and 7")
		Call("ask")
	EndIf
	If $NumClass < 2 Then
		MsgBox(0,"GPA - Error", "Invalid Amount of Classes, must be between 2 and 7")
		Call("ask")
	EndIf
EndFunc

GUICreate("GPA", 120, $GUI_height)
GUISetState (@SW_SHOW)
;-----------------------------------------------------------

GuiCtrlCreateLabel("Credits",10,10)
GuiCtrlCreateLabel("Grade",65,10)

$Button_calc = GUICtrlCreateButton ("Calculate",30, $button_calc_y, 60, 20)
	
If $NumClass > 1 Then
	$c1c = GUICtrlCreateInput ("",10, 30,45,20)
	$c1g = GUICtrlCreateInput ("",65, 30,45,20)

	$c2c = GUICtrlCreateInput ("",10, 55,45,20)
	$c2g = GUICtrlCreateInput ("",65, 55,45,20)
EndIf

If $NumClass > 2 Then
	$c3c = GUICtrlCreateInput ("",10, 80,45,20)
	$c3g = GUICtrlCreateInput ("",65, 80,45,20)
EndIf

If $NumClass > 3 Then
	$c4c = GUICtrlCreateInput ("",10, 105,45,20)
	$c4g = GUICtrlCreateInput ("",65, 105,45,20)
EndIf

If $NumClass > 4 Then
	$c5c = GUICtrlCreateInput ("",10, 130,45,20)
	$c5g = GUICtrlCreateInput ("",65, 130,45,20)
EndIf

If $NumClass > 5 Then
	$c6c = GUICtrlCreateInput ("",10, 155,45,20)
	$c6g = GUICtrlCreateInput ("",65, 155,45,20)
EndIf

If $NumClass > 6 Then
	$c7c = GUICtrlCreateInput ("",10, 180,45,20)
	$c7g = GUICtrlCreateInput ("",65, 180,45,20)
EndIf

Func Calculate()
	If $NumClass > 1 Then
		$c1c = GUICtrlRead($c1c)
		$c1g = GUICtrlRead($c1g)
		$c2c = GUICtrlRead($c2c)
		$c2g = GUICtrlRead($c2g)
		$cct = $c1c + $c2c
		$cgt = ($c1c * $c1g) + ($c2c * $c2g)
	EndIf
	If $NumClass > 2 Then
		$c3c = GUICtrlRead($c3c)
		$c3g = GUICtrlRead($c3g)
		$cct = $cct + $c3c
		$cgt = $cgt + ($c3c * $c3g)
	EndIf
	If $NumClass > 3 Then
		$c4c = GUICtrlRead($c4c)
		$c4g = GUICtrlRead($c4g)
		$cct = $cct + $c4c
		$cgt = $cgt + ($c4c * $c4g)
	EndIf
	If $NumClass > 4 Then
		$c5c = GUICtrlRead($c5c)
		$c5g = GUICtrlRead($c5g)
		$cct = $cct + $c5c
		$cgt = $cgt + ($c5c * $c5g)
	EndIf
	If $NumClass > 5 Then
		$c6c = GUICtrlRead($c6c)
		$c6g = GUICtrlRead($c6g)
		$cct = $cct + $c6c
		$cgt = $cgt + ($c6c * $c6g)
	EndIf
	If $NumClass > 6 Then
		$c7c = GUICtrlRead($c7c)
		$c7g = GUICtrlRead($c7g)
		$cct = $cct + $c7c
		$cgt = $cgt + ($c7c * $c7g)
	EndIf
	$GPA = $cgt/$cct
	MsgBox(0, "GPA Calculator", "Your GPA is: " & $GPA)
EndFunc

;-----------------------------------------------------------
While 1
    $msg = GUIGetMsg()
    Select
        Case $msg = $GUI_EVENT_CLOSE
            ExitLoop
		Case $msg = $Button_calc
            Call("Calculate")
    EndSelect
Wend