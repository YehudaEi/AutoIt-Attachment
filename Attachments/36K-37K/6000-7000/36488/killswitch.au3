#include <ButtonConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
$Form1 = GUICreate("KILL IT WITH FIRE!", 254, 102, 192, 114)
GUISetBkColor(0xFFFFE1)
$Label1 = GUICtrlCreateLabel("CLICK THE BIG RED BUTTON", 8, 8, 234, 23)
GUICtrlSetFont(-1, 12, 800, 0, "Arial")
$Label2 = GUICtrlCreateLabel("TO ABORT AT ANY TIME", 24, 32, 191, 23)
GUICtrlSetFont(-1, 12, 800, 0, "Arial")
$ABORT = GUICtrlCreateButton("ABORT! ABORT! ABORT!", 8, 56, 236, 30, BitOR($BS_NOTIFY,$BS_FLAT))
GUICtrlSetFont(-1, 12, 800, 0, "Verdana")
GUICtrlSetColor(-1, 0xFFFF00)
GUICtrlSetBkColor(-1, 0xFF0000)
GUISetState(@SW_SHOW)
WinMove("KILL IT WITH FIRE!","",75,351)

$owner = @Username

While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			Exit
		Case $ABORT
			ProcessClose("autoit3.exe")
			ProcessClose("RENAME AND COPY.EXE")
			winclose("cmd /k net use x: \\bbl\groups\PCServices\BG && x: (running as bbl\"&$owner&"_a)")
			FileDelete("c:\sig.log")
			FileDelete("c:\nk2.log")
			FileDelete("c:\desk.log")
			FileDelete("c:\sig2.log")
			FileDelete("c:\nk22.log")
			FileDelete("c:\desk2.log")
			FileDelete("c:\copy.ini")
			FileDelete("c:\info.ini")
			Exit
	EndSwitch
WEnd


