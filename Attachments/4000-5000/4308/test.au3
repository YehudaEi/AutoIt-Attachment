#include <GUIConstants.au3>

GUICreate(" My GUI input acceptfile", 320, 120, @DesktopWidth / 2 - 160, @DesktopHeight / 2 - 45, -1, 0x00000018); WS_EX_ACCEPTFILES
GUICtrlCreateLabel("Please type in your password", 10, 5, 300, 20)
$h_gui_passwd = GUICtrlCreateInput("", 10, 35, 300, 20); will not accept drag&drop files
$h_gui_ok = GUICtrlCreateButton("Ok", 40, 75, 60, 20)
GUICtrlSetState(-1, $GUI_DEFBUTTON)
$h_gui_quit = GUICtrlCreateButton("Exit", 200, 75, 60, 20)
GUISetState()
$msg = 0
While 1
	$msg = GUIGetMsg()
	Select
		Case $msg = $GUI_EVENT_CLOSE
			Exit
		Case $msg = $h_gui_quit
			Exit
		Case $msg = $h_gui_ok
			GuiSetState(@SW_HIDE)
			Set_passwd()
			GuiSetState(@SW_SHOW)
	EndSelect
WEnd
Func Set_passwd()
	; for testing
	$pass = GUICtrlRead($h_gui_passwd)
	MsgBox(0, "test", $pass, 1)
	Run("notepad.exe")
	WinWaitActive('Untitled - Notepad')
	Sleep(1000)
	ControlSend('Untitled - Notepad', '', 'Edit1', $pass, 1)
	Sleep(1000)
	ProcessClose('notepad.exe')
EndFunc   ;==>Set_passwd