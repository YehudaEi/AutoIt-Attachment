#include "..\MyInclude\dbug.au3"

Opt ( "GUIOnEventMode", 1 )

$Gui = GUICreate("Test", 200, 100, 100, 100)
GUISetOnEvent($GUI_EVENT_CLOSE, "GuiClose")
GUISetState(@SW_SHOW)

While 1
	Sleep(100)
WEnd


Func GuiClose()
   MsgBox (0,"Message","Ok")
   Exit
EndFunc








