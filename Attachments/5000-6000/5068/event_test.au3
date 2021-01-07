; Include GUI constants and functions
#include <GUIConstants.au3>

; Subscribe to GUI events to trigger handlers
opt("GUIOnEventMode", 1)

; Create a GUI to allow user to select a subset of matching properties
GUICreate("Event test")
GUISetOnEvent($GUI_EVENT_CLOSE, "Cancel")

; Button to do a task
$okbutton = GUICtrlCreateButton("OK", 10, 10, 65)
GUICtrlSetOnEvent($okbutton, "OK")

; Button to end processing and quit
$cancelbutton = GUICtrlCreateButton("Cancel", 85, 10, 65)
GUICtrlSetOnEvent($cancelbutton, "Cancel")

; Display the GUI
GUISetState(@SW_SHOW)

; Start waiting for events
While 1
	Sleep(10)
WEnd

Func OK()
	For $i = 1 To 50
		Sleep(100)
	Next
	
	MsgBox(0, "Anybody home?", "The process was not canceled.")
EndFunc

Func Cancel()
	MsgBox(0, "Canceled", "Good-bye!")
	
	Exit
EndFunc
