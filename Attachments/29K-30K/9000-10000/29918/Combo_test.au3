#NoTrayIcon

#include <ButtonConstants.au3>
#include <GuiComboBoxEX.au3>
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>

HotKeySet("{ESC}", "CLOSE")

Opt("MustDeclareVars", 0)

Global $Line, $Edit
Global $Username, $Combo1

Gui()
CLOSE()


Func Gui()
$Form1_1_1 = GUICreate("Userinfo", 200, 180, 190, 122)
GUICtrlSetResizing(-1, $GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
$Tab1 = GUICtrlCreateTab(0, 0, 913, 761)
;### TEST
$Suchen2 = GUICtrlCreateButton("Suchen2", 48, 60, 105, 33, $BS_DEFPUSHBUTTON)
GUICtrlSetFont(-1, 18, 800, 0, "Arial")

$Combo1 = GUICtrlCreateCombo("", 50, 100, 100, 25)
$Label1 = GUICtrlCreateLabel("Computername", 220, 552, 75, 17)

GUICtrlSetState(-1, $GUI_HIDE)
GUISetState(@SW_SHOW)
GUICtrlSetState($Username, $GUI_CHECKED)
GUISetState(@SW_SHOW)

GUICtrlSetData($Combo1, "111|aaa|222|ccc","222")

	$x = 1
	While 1
		$nMsg = GUIGetMsg()
		Select 
			Case $nMsg = $GUI_EVENT_CLOSE
			Exit
			Case $nMsg = $Suchen2
				_GUICtrlComboBoxEx_ResetContent($Combo1)
		EndSelect
	WEnd
EndFunc

Func CLOSE()
	FileDelete(@TempDir & "\adfind.exe")
	Exit
EndFunc

