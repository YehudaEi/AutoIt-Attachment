#include <GUIConstants.au3>

#Region ### START Koda GUI section ### Form=c:\users\deviousdude\desktop\best logistics\form1_1.kxf
$Form1_1 = GUICreate("Regex Run", 637, 402, 191, 127)
GUICtrlCreateInput("", 16, 32, 601, 21)
$Label1 = GUICtrlCreateLabel("Regular Expression", 16, 14, 95, 17)
GUICtrlCreateInput("", 16, 184, 417, 21)
$Label2 = GUICtrlCreateLabel("Input File", 16, 160, 47, 17)
$Button1 = GUICtrlCreateButton("Browse", 440, 184, 75, 25)
GUICtrlCreateInput("", 16, 232, 417, 21)
$Label3 = GUICtrlCreateLabel("Output File", 16, 208, 55, 17)
$Button2 = GUICtrlCreateButton("Browse", 440, 231, 75, 25)
$Combo1 = GUICtrlCreateCombo("", 288, 264, 145, 25)
GUICtrlSetData(-1, "Tab|Comma|Space")
$Label4 = GUICtrlCreateLabel("Delimiter", 240, 264, 44, 17)
$Tab1 = GUICtrlCreateTab(360, 168, 1, 49)
GUICtrlSetResizing(-1, $GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
GUICtrlCreateTabItem("")
$Button3 = GUICtrlCreateButton("Run", 32, 272, 139, 89)
$Progress1 = GUICtrlCreateProgress(184, 312, 398, 33)
$MenuItem4 = GUICtrlCreateMenu("&File")
$MenuItem5 = GUICtrlCreateMenuItem("New", $MenuItem4)
$MenuItem7 = GUICtrlCreateMenuItem("Open...", $MenuItem4)
$MenuItem6 = GUICtrlCreateMenuItem("Save", $MenuItem4)
$MenuItem8 = GUICtrlCreateMenuItem("Save As...", $MenuItem4)
$MenuItem10 = GUICtrlCreateMenuItem("Page Setup...", $MenuItem4)
$MenuItem9 = GUICtrlCreateMenuItem("Print...", $MenuItem4)
$MenuItem11 = GUICtrlCreateMenuItem("Exit", $MenuItem4)
$MenuItem3 = GUICtrlCreateMenu("&Edit")
$MenuItem21 = GUICtrlCreateMenuItem("Undo", $MenuItem3)
$MenuItem20 = GUICtrlCreateMenuItem("Cut", $MenuItem3)
$MenuItem19 = GUICtrlCreateMenuItem("Copy", $MenuItem3)
$MenuItem18 = GUICtrlCreateMenuItem("Paste", $MenuItem3)
$MenuItem17 = GUICtrlCreateMenuItem("Delete", $MenuItem3)
$MenuItem16 = GUICtrlCreateMenuItem("Find...", $MenuItem3)
$MenuItem15 = GUICtrlCreateMenuItem("Find Next", $MenuItem3)
$MenuItem14 = GUICtrlCreateMenuItem("Replace...", $MenuItem3)
$MenuItem13 = GUICtrlCreateMenuItem("Go To...", $MenuItem3)
$MenuItem12 = GUICtrlCreateMenuItem("Select All", $MenuItem3)
$MenuItem2 = GUICtrlCreateMenu("&View")
$MenuItem22 = GUICtrlCreateMenuItem("Status Bar", $MenuItem2)
$MenuItem1 = GUICtrlCreateMenu("&Help")
$MenuItem24 = GUICtrlCreateMenuItem("View Help", $MenuItem1)
$MenuItem23 = GUICtrlCreateMenuItem("About Regex Run", $MenuItem1)
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###

While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			Exit

	EndSwitch
WEnd
