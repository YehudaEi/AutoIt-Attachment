#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <GUIListBox.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#Region ### START Koda GUI section ### Form=
$Form1 = GUICreate("Form1", 633, 443, 192, 124)
$Button1 = GUICtrlCreateButton("Button1", 392, 296, 75, 25, $WS_GROUP)
$Input1 = GUICtrlCreateInput("Input1", 120, 296, 265, 21)
$Checkbox1 = GUICtrlCreateCheckbox("Checkbox1", 120, 320, 97, 17)
$Checkbox2 = GUICtrlCreateCheckbox("Checkbox2", 120, 336, 97, 17)
$List1 = GUICtrlCreateList("", 120, 136, 345, 149)
GUICtrlCreateLabel("", 120, 104, 348, 28)
$Group1 = GUICtrlCreateGroup("Group1", 0, 48, 497, 321)
GUICtrlCreateGroup("", -99, -99, 1, 1)
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###

While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			Exit
		Case $Button1
			MsgBox(0, "Submision succesful", "thank-you for your submission")
	EndSwitch
WEnd