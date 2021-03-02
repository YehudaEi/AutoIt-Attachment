#cs ==========================================================================

Chkdsk gui for the Windows PE enviroment.

Will run chkdsk with the following parameters: /R /X
Will give us the option to run once, run 3 times, or set a custom number.
Will log the output to a file on the hard drive. For now, thinking that the
root of C:\ would work, then when in the Windows enviroment, have EagleFix
check for the file and move it to the Log folder.
Will also display output in a box in the GUI.

<Neo>

#ce ==========================================================================
#include <GUIConstantsEx.au3> ;Constants for GUI Events
#include <WindowsConstants.au3>
Func _Exit()
	Exit
EndFunc

_Main()
Func _Main()
	HotKeySet("^!e", "_Exit")
	GUICreate("CheckThatDrive",490,390)
	GUICtrlCreateGroup("Select the drives you want to chkdsk.",5,5, 195, 45)
	GUICtrlCreateCheckbox("C:\",10,25)
	GUICtrlCreateCheckbox("D:\",55,25)
	GUICtrlCreateCheckbox("E:\",100,25)
	GUICtrlCreateCheckbox("X:\",145,25)
	GUICtrlCreateInput("Chkdsk log info here:" ,255, 5, 225, 350)
	GUICtrlCreateGroup("How many times should it be ran:", 5, 50, 195, 45)
	GUICtrlCreateRadio("1", 10, 65)
	GUICtrlCreateRadio("3", 35, 65)
	GUICtrlCreateRadio("Custom:", 60, 65)
	GUICtrlCreateInput("5",115, 65,30)
	GUICtrlCreateCheckbox("Open Log when done.", 10, 95)
	GUICtrlCreateCheckbox("Save log to C:\", 10, 115)
	GUISetState(@SW_SHOW)
While 1
	Switch GUIGetMsg()
		Case $GUI_EVENT_CLOSE
			Exit
	EndSwitch
WEnd
EndFunc