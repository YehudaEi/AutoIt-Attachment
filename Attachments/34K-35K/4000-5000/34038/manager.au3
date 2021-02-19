#include <ButtonConstants.au3>
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#Region ### START Koda GUI section ### Form=
$Form1 = GUICreate("Form1", 615, 438, 192, 124)
$Group1 = GUICtrlCreateGroup("List Software Web Browsers", 48, 48, 521, 161)
$Checkbox1 = GUICtrlCreateCheckbox("FireFox 4.1", 72, 80, 97, 17)
$Checkbox2 = GUICtrlCreateCheckbox("Google Chrome", 232, 80, 97, 17)
$Checkbox3 = GUICtrlCreateCheckbox("Safari", 72, 152, 97, 17)
$Checkbox5 = GUICtrlCreateCheckbox("Opera", 368, 80, 97, 17)
GUICtrlCreateGroup("", -99, -99, 1, 1)
$Group2 = GUICtrlCreateGroup("Other", 48, 232, 521, 161)
$Checkbox7 = GUICtrlCreateCheckbox("Picasa", 72, 264, 97, 17)
$Checkbox8 = GUICtrlCreateCheckbox("Foxit Reader", 72, 336, 97, 17)
$Checkbox9 = GUICtrlCreateCheckbox("Open Office", 248, 264, 97, 17)
$Checkbox10 = GUICtrlCreateCheckbox("Avast", 256, 336, 97, 17)
GUICtrlCreateGroup("", -99, -99, 1, 1)
$Button1 = GUICtrlCreateButton("Install", 264, 400, 75, 25)
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###

While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			Exit

	EndSwitch
WEnd
