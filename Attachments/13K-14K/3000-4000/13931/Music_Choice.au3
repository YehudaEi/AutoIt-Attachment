#include <GUIConstants.au3>

GUICreate ("Music Selection")  ; will create a dialog box that when displayed is centered

GUISetBkColor (0xAAAAAA)  ; will change background color

GUISetState  ()       ; will display an empty dialog box
GUICtrlCreateButton ("Rock N Roll",10,50,100,100,-1,$BS_CENTER+$BS_DEFPUSHBUTTON)
GUICtrlCreateButton ("Easy Listening",10,200,100,100,-1,$BS_CENTER+$BS_DEFPUSHBUTTON)
; Run the GUI until the dialog is closed
While 1
	$msg = GUIGetMsg()
	
	If $msg = $GUI_EVENT_CLOSE Then ExitLoop
Wend


