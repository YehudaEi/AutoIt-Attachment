#include <GUIConstants.au3>

Opt("GUICoordMode", 1)
GuiCreate("Test OCR", 537,424,0,0)
GUICtrlCreatePic("security.bmp", 121, 142, 302, 97)

GUISetState()

While 1
    $msg = GUIGetMsg()
	If $msg = $GUI_EVENT_CLOSE Then
		Exit
	EndIf
WEnd
Exit
