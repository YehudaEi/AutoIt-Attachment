

#include <WindowsConstants.au3>
#include <GUIConstantsEx.au3>
#Region ### START Koda GUI section ### Form=
Global $Form1=0
$Form1 = GUICreate("Form1", 555, 331, 270, 190, -1, BitOR($WS_EX_ACCEPTFILES,$WS_EX_WINDOWEDGE))

$Input1 = GUICtrlCreateInput("", 88, 64, 233, 21)
GUICtrlSetState(-1,$GUI_DROPACCEPTED)
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###
#RequireAdmin

While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			Exit

	EndSwitch
WEnd
