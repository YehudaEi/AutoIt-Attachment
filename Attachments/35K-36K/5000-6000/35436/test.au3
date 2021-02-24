
#include <Constants.au3>
#include <WinAPI.au3>
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>

$Form1  = GUICreate("Test", 288, 284,-1,-1)

$Input1 = GUICtrlCreateInput("", 12, 8, 57, 21)
_WinAPI_SetWindowLong(GUICtrlGetHandle(-1), $GWL_STYLE, BitAND(_WinAPI_GetWindowLong(GUICtrlGetHandle(-1), $GWL_STYLE), BitNOT($WS_TABSTOP)))

$radio1 = GUICtrlCreateRadio("Radio1", 150, 8, 55, 21)
GUICtrlSetState($radio1, $GUI_CHECKED)
_WinAPI_SetWindowLong(GUICtrlGetHandle(-1), $GWL_STYLE, BitAND(_WinAPI_GetWindowLong(GUICtrlGetHandle(-1), $GWL_STYLE), BitNOT($WS_TABSTOP)))

$radio2 = GUICtrlCreateRadio("Radio2", 210, 8, 55, 21)
_WinAPI_SetWindowLong(GUICtrlGetHandle(-1), $GWL_STYLE, BitAND(_WinAPI_GetWindowLong(GUICtrlGetHandle(-1), $GWL_STYLE), BitNOT($WS_TABSTOP)))

GUISetState(@SW_SHOW)

While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			Exit
	EndSwitch			
WEnd