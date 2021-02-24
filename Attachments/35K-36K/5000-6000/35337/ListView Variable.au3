#include <GUIConstantsEx.au3>
;#include <GUIListViewEx_20110824.au3>; by Melba23
#include <GUIListView.au3>
#include <WindowsConstants.au3>

Global $Font="MS Sans Serif"

#Region ### START Koda GUI section ### Form=C:\AutoIt NDB Kit\Disk_Information\- NDBDiskInfo\ListView_Linha variável.kxf
$Form1 = GUICreate("Form1", 443, 177, 192, 124)

$ListView1 = GUICtrlCreateListView("Col1|Col2", 16, 16, 409, 145, BitOR($LVS_ICON,$LVS_NOSORTHEADER,$LVS_SINGLESEL), BitOR($WS_EX_CLIENTEDGE,$LVS_EX_GRIDLINES))
;$LBS_OWNERDRAWVARIABLE=0x00000020
;_GUICtrlListView_SetView($ListView1, 4)

GUICtrlSendMsg(-1, $LVM_SETCOLUMNWIDTH, 0, 200)
GUICtrlSendMsg(-1, $LVM_SETCOLUMNWIDTH, 1, 200)
GUICtrlSetFont(-1, 10, 400, 2, $Font)
$ListView1_0 = GUICtrlCreateListViewItem("Col1_Lin1|Col2_Lin1 Col2_Lin2 Col2_Lin3 Col2_Lin4", $ListView1)
$ListView1_1 = GUICtrlCreateListViewItem("Col1_Lin2|Col2_Lin2", $ListView1)
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###

While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			Exit

		Case $Form1

		Case $ListView1
	EndSwitch
WEnd
