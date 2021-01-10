#cs
Version:			AutoIt 3.1.1
					Windows XP necessary for JPG-File
Problem:			Transparent background of label with a normal background of an GUI window				
#ce

#include <GUIConstants.au3>
$LbLtxt="   I wanna have a white font with a transparent background as label ;-)"

;>>>>>>>>>>>>>>>>>>>> main window <<<<<<<<<<<<<<<<<<<<<<<<<
$main=GUICreate("Transparent Label?",250,310,-1,-1)  
GUICtrlCreatePic(@Systemdir & "\oobe\images\wpakey.jpg",0,0, 248,281)
GUICtrlCreateLabel($LbLtxt,10,20,230,30)
	GUICtrlSetColor ( -1, 0xFFFFFF)
$btn1=GUICtrlCreateButton('Next try',180,281,60,20)
;>>>>>>>>>>>>>>>>>>>> child window <<<<<<<<<<<<<<<<<<<<<<<<<
$child=GUICreate("Next Try",250,300,-1,-1,$WS_POPUP,$WS_EX_TRANSPARENT)  
GUICtrlCreatePic(@Systemdir & "\oobe\images\wpakey.jpg",0,0, 248,281)
GUICtrlCreateLabel($LbLtxt,10,20,230,30,-1,$WS_EX_TRANSPARENT)
	GUICtrlSetColor ( -1, 0xFFFFFF)
GUISwitch($main)	
GUISetState(@SW_SHOW)


; Run the GUI until the dialog is closed
While 1
    $msg = GUIGetMsg(1)
	Select
	    Case $msg[0] = $GUI_EVENT_CLOSE And $msg[1] = $main 
			Exit
		Case $msg[0]=$btn1 
			GUISwitch($child)
			GUISetState()
	EndSelect
	
Wend





