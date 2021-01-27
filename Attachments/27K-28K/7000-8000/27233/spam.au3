#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#Region ### START Koda GUI section ### Form=
$Form1 = GUICreate("Dialog", 260, 80, 302, 218)
GUISetIcon("D:\009.ico")
$GroupBox1 = GUICtrlCreateGroup("", 8, 8, 241, 65)
$Input1 = GUICtrlCreateInput("Put your text here", 96, 32, 145, 21)
$Text = GUICtrlCreateLabel("Text", 48, 32, 25, 17)
GUICtrlCreateGroup("", -99, -99, 1, 1)
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###

While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			Exit

		Case $Input1
	EndSwitch
WEnd
