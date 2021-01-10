#include <GUIConstants.au3>
#250,110
#Region ### START Koda GUI section ### Form=F:\koda\Forms\printer.kxf
$Form1 = GUICreate("Change Printer Message", 265, 110, 260, 115)
$Group1 = GUICtrlCreateGroup("Printer Info.", 5, 2, 257, 105)

#Labels
$Label1 = GUICtrlCreateLabel("Printer IP:", 15, 16, 50, 17)
$Label1 = GUICtrlCreateLabel(".", 113, 20, 3, 11)
$Label1 = GUICtrlCreateLabel(".", 163, 20, 3, 11)
$Label1 = GUICtrlCreateLabel(".", 213, 20, 3, 11)
$Label2 = GUICtrlCreateLabel("Message:", 15, 48, 50, 17)

#Inputs
$Input1 = GUICtrlCreateInput("1", 70, 12, 40, 21,BitOR($ES_NUMBER,$ES_READONLY))
$Input2 = GUICtrlCreateInput("1", 120, 12, 40, 21,BitOR($ES_NUMBER,$ES_READONLY))
$Input3 = GUICtrlCreateInput("1", 170, 12, 40, 21,BitOR($ES_NUMBER,$ES_READONLY))
$Input4 = GUICtrlCreateInput("1", 220, 12, 40, 21,BitOR($ES_NUMBER,$ES_READONLY))
$Input5 = GUICtrlCreateInput("", 70, 45, 105, 21,$ES_UPPERCASE)

#Buttons
$send = GUICtrlCreateButton("Send", 10, 80, 49, 17, 0)
$cancel = GUICtrlCreateButton("Cancel", 100, 80, 57, 17, 0)
$revert = GUICtrlCreateButton("Revert", 200, 80, 57, 17, 0)

GUICtrlCreateGroup("", -99, -99, 1, 1)
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###

$limit = GUICtrlCreateUpdown($input1)
GUICtrlSetLimit($limit,255,1)
$limit = GUICtrlCreateUpdown($input2)
GUICtrlSetLimit($limit,255,1)
$limit = GUICtrlCreateUpdown($input3)
GUICtrlSetLimit($limit,255,1)
$limit = GUICtrlCreateUpdown($input4)
GUICtrlSetLimit($limit,255,1)
While 1

	$msg = GUIGetMsg()
	Select

		Case $msg = $GUI_EVENT_CLOSE
			ExitLoop

		Case $msg = $send
			$exe_string = "HPHack.exe "
			$exe_string &= GUICtrlRead($Input1)
			$exe_string &= "."
			$exe_string &= GUICtrlRead($Input2)
			$exe_string &= "."
			$exe_string &= GUICtrlRead($Input3)
			$exe_string &= "."
			$exe_string &= GUICtrlRead($Input4)
			$exe_string &= ' "'
			$exe_string &= GUICtrlRead($Input5)
			$exe_string &= '"'
			run($exe_string)

		Case $msg = $cancel
			ExitLoop

		Case $msg = $revert
			$exe_string = "HPHack.exe "
			$exe_string &= GUICtrlRead($Input1)
			$exe_string &= "."
			$exe_string &= GUICtrlRead($Input2)
			$exe_string &= "."
			$exe_string &= GUICtrlRead($Input3)
			$exe_string &= "."
			$exe_string &= GUICtrlRead($Input4)
			$exe_string &= " Ready"
			run($exe_string)

		Case $Input1 = "***."
		Send("{TAB}",)

		Case $Input2 = "***."
		Send("{TAB}",)

		Case $Input3 = "***."
		Send("{TAB}",)

		Case $Input4 = "***."
		Send("{TAB}",)

		Case $Input1 = "**."
		Send("{TAB}",)

		Case $Input2 = "**."
		Send("{TAB}",)

		Case $Input3 = "**."
		Send("{TAB}",)

		Case $Input4 = "**."
		Send("{TAB}",)
		
		Case $Input1 = "*."
		Send("{TAB}",)

		Case $Input2 = "*."
		Send("{TAB}",)

		Case $Input3 = "*."
		Send("{TAB}",)

		Case $Input4 = "*."
		Send("{TAB}",)

	EndSelect
WEnd

