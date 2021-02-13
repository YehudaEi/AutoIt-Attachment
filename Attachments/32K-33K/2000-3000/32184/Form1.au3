#include <ButtonConstants.au3>
#include <GUIConstantsEx.au3>
#include <ListViewConstants.au3>
#include <WindowsConstants.au3>
#Region ### START Koda GUI section ### Form=e:\documents and settings\lucamad\desktop\koda_1.7.3.0\forms\form1.kxf
$Form1 = GUICreate("Form1", 623, 173, 192, 124, BitOR($GUI_SS_DEFAULT_GUI,$WS_MAXIMIZEBOX,$WS_SIZEBOX,$WS_THICKFRAME,$WS_TABSTOP))
$Group1 = GUICtrlCreateGroup("Group1", 8, 8, 609, 161)
$ListView1 = GUICtrlCreateListView("", 24, 24, 586, 134)
GUICtrlCreateGroup("", -99, -99, 1, 1)
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###

While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			Exit

	EndSwitch
WEnd
