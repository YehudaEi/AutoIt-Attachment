#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <ListViewConstants.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#Region ### START Koda GUI section ### Form=
$Form1 = GUICreate("Form1", 289, 193, 192, 124)
$ListView1 = GUICtrlCreateListView("Name", 152, 8, 122, 174)
GUICtrlSendMsg(-1, $LVM_SETCOLUMNWIDTH, 0, 50)
$ListView1_0 = GUICtrlCreateListViewItem("yo", $ListView1)
$ListView1_1 = GUICtrlCreateListViewItem("123", $ListView1)
$ListView1_2 = GUICtrlCreateListViewItem("4324", $ListView1)
$ListView1_3 = GUICtrlCreateListViewItem("3423543", $ListView1)
$ListView1_4 = GUICtrlCreateListViewItem("", $ListView1)
$Input1 = GUICtrlCreateInput("Input1", 16, 40, 121, 21)
$Label1 = GUICtrlCreateLabel("Selected Item", 16, 16, 69, 17)
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###

While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			Exit

	EndSwitch
WEnd
