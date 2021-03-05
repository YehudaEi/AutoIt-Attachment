#include <ButtonConstants.au3>
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#Region ### START Koda GUI section ### Form=gender select.kxf
$Form2 = GUICreate("Select Gender", 279, 213, 361, 262)
GUISetBkColor(0xA0A0A4)
$GroupBox1 = GUICtrlCreateGroup("", 24, 1, 233, 193)
GUICtrlSetBkColor(-1, 0xA0A0A4)
$label2 = GUICtrlCreateLabel("or", 135, 168, 15, 17)
GUICtrlSetBkColor(-1, 0xA0A0A4)
$Label1 = GUICtrlCreateLabel("Click on the Gender of the New User", 48, 136, 177, 18)
GUICtrlCreateGroup("", -99, -99, 1, 1)
$Button1 = GUICtrlCreateButton("Male", 30, 163, 75, 25, $BS_PUSHLIKE)
GUICtrlSetBkColor(-1, 0x0054E3)
$Button2 = GUICtrlCreateButton("Female", 173, 163, 75, 25, $BS_PUSHLIKE)
GUICtrlSetBkColor(-1, 0xFF00FF)
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###

While 1
   $msg = GUIGetMsg()

   Switch $msg
	Case $GUI_EVENT_CLOSE
	;insert code here
     MsgBox(4, "", "Are you sure ? This will Install the Default settings")
			;I would like to install from here or go back to the beging dependent on the response to
			;the yes or no buttons displayed by the msgbox4 function. yes =instal and exit no = go back to the begining
			;of selection routine.
			;I need the msgbox to be displayed in line with and on top of the main window

Exit
Case $Button1
_maleFunction()
Case $Button2
_femaleFunction()
   EndSwitch
WEnd

Func _maleFunction()
   ;insert code here
    MsgBox(4, "", "Are you sure about Installing settings for a Male ?")
			;I would like to install from here or go back to the beging dependent on the response to
			; the yes or no buttons displayed by the msgbox4 function. yes =install and exit,no = go back to the begining
			;I need the msgbox to be displayed in line with and on top of the main window
			;I need to store the response into a variable for later use

   Exit
EndFunc

Func _femaleFunction()
   ;insert code here
   MsgBox(4, "", "Are you sure about Installing Female settings?")
			;I would like to install from here or go back to the beging dependent on the response to
			; the yes or no buttons displayed by the msgbox4 function. yes =install and exit, no = go back to the begining
			;I need the msgbox to be displayed in line with and on top of the main window
			;I need to store the response into a variable for later use

   Exit
EndFunc