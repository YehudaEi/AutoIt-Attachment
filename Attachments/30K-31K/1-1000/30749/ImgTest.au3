#include <GUIConstantsEx.au3>

;Set options
	Opt("GUIOnEventMode", 1)
	Opt('MustDeclareVars', 1)
;Create GUI Window
	GUICreate("My Test of Images", 600, 300) 
;Graphic
GuiCtrlCreatePic("test.gif",0,0, 600,78)
	GUISetOnEvent($GUI_EVENT_CLOSE, "CLOSEClicked")
;Displays the window
	GUISetState(@SW_SHOW)
; Enter an infinite loop
	While 1
		Sleep(10)
	WEnd

Func CLOSEClicked()
	Exit
EndFunc