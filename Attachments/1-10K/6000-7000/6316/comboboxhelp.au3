; ----------------------------------------------------------------------------
;
; AutoIt Version: 3.1.0
; Author:         A.N.Other <myemail@nowhere.com>
;
; Script Function:
;	Template AutoIt script.
;  This script is to select the fuction you want to execute and then click go to execute the funtion.
;  When the function is executed the GIU will minimize to the system tray.
; ----------------------------------------------------------------------------

; Script Start - Add your code below here
#include <GuiConstants.au3>

GUICreate("", 170, 60,)
GUISetState()
$Combo_1 = GUICtrlCreateCombo("", 10, 10, 150, 21)
GUICtrlSetData($Combo_1, 'Notepad |Calculator')
$Button1 = GUICtrlCreateButton('GO', 35, 35, 100, 17)
While 1
	$MainMsg = GUIGetMsg()
	Select
		Case $MainMsg = $GUI_EVENT_CLOSE
			Exit
		Case $MainMsg = $Combo_1 ;Calculator
			Run("notepad.exe")		
		Case $MainMsg = $Combo_1 ;Calculator
			Run("calc.exe")	
	EndSelect
WEnd
			


GUISetState()
While GUIGetMsg() <> $GUI_EVENT_CLOSE
WEnd