#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include <StaticConstants.au3>
Opt("GUIOnEventMode", 1)  

$mainwindow = GUICreate("Truck GapGun Interface",1680,1050,-1,-1, BitOr($WS_MINIMIZEBOX, $WS_MAXIMIZEBOX, $WS_CAPTION, $WS_POPUP, $WS_SYSMENU, $WS_SIZEBOX, $WS_MAXIMIZE))
GUISetBkColor(0xFFFF00, $mainwindow)
GUICtrlCreateLabel("THIS IS A DOCKED LABEL", 10, 10, 900, 400 )
GUICtrlSetBkColor(-1, 0x00FFFF)
GUICtrlSetResizing(-1, $GUI_DOCKAll)
	
GUISetOnEvent($GUI_EVENT_CLOSE, "Close_Clicked")
GUISetState(@SW_SHOW)

While 1
 Sleep (200)
WEnd

Func Close_Clicked()
  Exit
EndFunc

