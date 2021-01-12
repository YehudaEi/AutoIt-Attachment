#include <GUIConstants.au3>

#Region ### START Koda GUI section ### Form=C:\Documents and Settings\CurrentUser\Desktop\Robots\AForm1.kxf
$AForm1 = GUICreate("Dialog", 278, 186, 439, 211)
GUISetIcon("D:\009.ico")
$GroupBox1 = GUICtrlCreateGroup("", 8, 32, 161, 145)
$Radio1 = GUICtrlCreateRadio(" Tony", 32, 56, 113, 17)
GUICtrlSetFont(-1, 12, 800, 2, "Times New Roman")
GUICtrlSetColor(-1, 0x800000)
GUICtrlSetBkColor(-1, 0xA6CAF0)
$Radio2 = GUICtrlCreateRadio(" Greg", 32, 96, 113, 17)
GUICtrlSetFont(-1, 12, 800, 2, "Times New Roman")
GUICtrlSetColor(-1, 0x800000)
GUICtrlSetBkColor(-1, 0xA6CAF0)
$Radio3 = GUICtrlCreateRadio(" Randy", 32, 136, 113, 17)
GUICtrlSetFont(-1, 12, 800, 2, "Times New Roman")
GUICtrlSetColor(-1, 0x800000)
GUICtrlSetBkColor(-1, 0xA6CAF0)
GUICtrlCreateGroup("", -99, -99, 1, 1)
$Button1 = GUICtrlCreateButton("&OK", 184, 40, 75, 25, 0)
$Button2 = GUICtrlCreateButton("&Cancel", 184, 72, 75, 25, 0)
$Label1 = GUICtrlCreateLabel("Choose  Appraiser for New Zapp", 8, 8, 262, 26)
GUICtrlSetFont(-1, 14, 800, 2, "Times New Roman")
GUICtrlSetColor(-1, 0x800000)
GUICtrlSetBkColor(-1, 0xA6CAF0)
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###

While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			Exit
		
		Case $AForm1

		
		Case $Radio1

		
		Case $Button1

		
		Case $Button2

		
		Case $Label1
	EndSwitch
WEnd
