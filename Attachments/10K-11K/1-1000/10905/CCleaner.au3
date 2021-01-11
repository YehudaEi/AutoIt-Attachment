#include <GUIConstants.au3>
#include <GuiList.au3>
Opt("WinWaitDelay",100)
Opt("WinTitleMatchMode",4)
Opt("WinDetectHiddenText",1)
Opt("MouseCoordMode",0)

; == GUI generated with Koda ==
$Form1 = GUICreate("AForm1", 622, 441, 192, 125)
$Button1 = GUICtrlCreateButton("Run ccleaner", 504, 72, 75, 25, 0)
$List1 = GUICtrlCreateList("", 32, 16, 401, 357)
GUISetState(@SW_SHOW)
While 1
	$msg = GuiGetMsg()
	Select
	Case $msg = $GUI_EVENT_CLOSE
		ExitLoop
	Case $msg = $Button1
		Run("c:\program files\ccleaner\ccleaner.exe")
		WinWaitActive("CCleaner","")
		ControlClick("CCleaner", "", 2) ;run cleaner
		Sleep(5000)
		ControlListView("CCleaner", "", "SysListView321", "SelectAll")
		ControlListView("CCleaner", "", "SysListView321", "Deselect", 2, 5)
		MsgBox(0, "", ControlListView("CCleaner", "", "SysListView321", "GetText", 9, 0) )
		MsgBox(0, "", ControlListView("CCleaner", "", "SysListView321", "FindItem", "CLEANING COMPLETE", 1) )
		MsgBox(0, "", ControlListView("CCleaner", "", "SysListView321", "GetSelected", 1) )
;		$var1 = ControlListView("CCleaner", "", "SysListView321", "GetText", 9, 0)
;		_GUICtrlListInsertItem($List1, $var1, -1)		
	Case Else
		;;;;;;;
	EndSelect
WEnd
Exit
