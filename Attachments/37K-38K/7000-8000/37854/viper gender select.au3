#include <ButtonConstants.au3>
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#Region ### START Koda GUI section ### Form=gender select.kxf
$Form2 = GUICreate("Select your Gender", 279, 213, 468, 254)
$GroupBox1 = GUICtrlCreateGroup("", 48, 33, 185, 129)
GUICtrlSetBkColor(-1, 0x008080)
GUICtrlCreateGroup("", -99, -99, 1, 1)
$Button1 = GUICtrlCreateButton("Male", 54, 107, 75, 25)
GUICtrlSetBkColor(-1, 0x0054E3)
$Button2 = GUICtrlCreateButton("Female", 149, 108, 75, 25)
GUICtrlSetBkColor(-1, 0xFF00FF)
$Button3 = GUICtrlCreateButton("Select Your Gender", 85, 52, 115, 25)
GUICtrlSetBkColor(-1, 0x00FF00)
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###

While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg

		Case $GUI_EVENT_CLOSE
			Exit


	EndSwitch
WEnd
