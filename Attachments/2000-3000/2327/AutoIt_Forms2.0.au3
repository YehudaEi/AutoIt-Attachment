#include <GUIConstants.au3>

$oForm = ObjCreate("Forms.Form.1")
$oFormEvt=ObjEvent($oForm,"Form_")

$oForm.caption = "Forms Frame Test"
$oForm.Designmode=-1
$oForm.ShowToolBox=-1

$oButton=$oForm.Add("Forms.CommandButton.1","TestButton",1)   ;ok
$oButtonEvt=ObjEvent($oButton,"Button_")

With $oButton
	.caption="Test Button"
	.Left=10
	.Top=8
	.Height=20
	.Width=70
	.Visible=1
EndWith

$oCheckBox=$oForm.Add("Forms.CheckBox.1","TestCheck",1)   ;ok
$oCheckBoxEvt=ObjEvent($oCheckBox,"CheckBox_")

With $oCheckBox
	.caption="Test Check"
	.Left=10
	.Top=28
	.Height=20
	.Width=100
	.Visible=1
EndWith

$oSpinButton=$oForm.Add("Forms.SpinButton.1","TestSpin",1)   ;ok
$oSpinButtonEvt=ObjEvent($oSpinButton,"SpinButton_")

With $oSpinButton
	.Left=10
	.Top=45
	.Height=15
	.Width=50
	.Visible=1
EndWith

$oToggleButton=$oForm.Add("Forms.ToggleButton.1","TestToggle",1)   ;ok
With $oToggleButton
	.caption="Toggle"
	.Left=10
	.Top=63
	.Height=20
	.Width=50
	.Visible=1
EndWith

; Create a simple GUI for our output
GUICreate ( "Embedded ActiveX Test", 640, 480 )
$GUI_ActiveX=GUICtrlCreateActiveX ( $oForm, 10, 10 , 200 , 200 )
$GUI_Label=GUICtrlCreateLabel ( "", 10, 220 , 200 , 20 )
GUISetState ()       ;Show GUI

  ; Waiting for user to close the window
  While 1
    $msg = GUIGetMsg()
    If $msg = $GUI_EVENT_CLOSE Then ExitLoop
  Wend

  GUIDelete ()
Exit

; -----Some example Event Functions
Func Form_MouseMove($Button, $Shift, $X, $Y)
	GUICtrlSetData($GUI_Label,"Form Mousemove: X:" & $X  & "  Y:" & $Y)
EndFunc

Func Form_Click()
	GUICtrlSetData($GUI_Label,"Form: Single mouseclick!")
EndFunc

Func button_click()
	GUICtrlSetData($GUI_Label,"Button: Single mouseclick!")
EndFunc

Func button_doubleclick()
	GUICtrlSetData($GUI_Label,"Button: Double mouseclick!")
EndFunc
