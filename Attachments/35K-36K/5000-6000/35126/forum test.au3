#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#region ### START Koda GUI section ### Form=
$Form1 = GUICreate("Form1", 319, 140, 254, 124)
$Button1 = GUICtrlCreateButton("save", 32, 88, 129, 33, $WS_GROUP)
$Button2 = GUICtrlCreateButton("load", 176, 88, 121, 33, $WS_GROUP)
$Edit1 = GUICtrlCreateEdit("", 32, 16, 257, 73, BitOR($ES_AUTOVSCROLL, $ES_AUTOHSCROLL, $ES_WANTRETURN, $WS_VSCROLL))
GUISetState(@SW_SHOW)
#endregion ### END Koda GUI section ###
$count = 0
$saving = ""

While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			Exit
		Case $Button1
			If GUICtrlRead($Edit1) <> "" Then
				If GUICtrlRead($Edit1) <> "" Then
					$solution_string = ""
					$solution = StringSplit(GUICtrlRead($Edit1), Chr(10))
					While $count <= $solution[0]
						$solution_string = $solution_string & $solution[$count] & "IITII"
						$count += 1
					WEnd
					$solution_string = StringTrimRight($solution_string, 5)
					$solution_string = StringTrimLeft($solution_string, 6)
					$saving = $saving & "solution=" & $solution_string & @LF
					$count = 0
				EndIf
			EndIf
			IniWriteSection("Test.ini", "test", $saving)
		Case $Button2
			$solution = IniReadSection("Test.ini", "test")
			$solution_string = ""
			$solution = StringSplit($solution[1][1], "IITII")
			While $count <= $solution[0]
				$solution_string = $solution_string & $solution[$count] & @CRLF
				$count += 1
			WEnd
			$solution_string = StringTrimRight($solution_string, 1)
			$solution_string = StringTrimLeft($solution_string, 2)
			$count = 0
			GUICtrlSetData($Edit1, $solution_string)
	EndSwitch
WEnd