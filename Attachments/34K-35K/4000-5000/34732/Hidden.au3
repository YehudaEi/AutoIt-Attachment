#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#Region ### START Koda GUI section ### Form=
$Form1 = GUICreate("", @DesktopWidth, @DesktopHeight, -1, -1, $WS_POPUP, $WS_EX_TOPMOST)
GUISetBkColor(0xFFFFFF)
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###

WinSetTrans("", "", 1)

While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			Exit

	EndSwitch
WEnd
