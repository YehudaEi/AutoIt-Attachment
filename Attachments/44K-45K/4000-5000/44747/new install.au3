#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>

$Form1 = GUICreate("Form1", @DesktopWidth, 80, -1, -1, $WS_POPUPWINDOW)

$Label1 = GUICtrlCreateLabel("Center this line", 224, 24, 143, 24)
GUICtrlSetFont(-1, 12, 800, 0, "MS Sans Serif")

GUISetState(@SW_SHOW)


While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			Exit

	EndSwitch
WEnd
