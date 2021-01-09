#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#NoTrayIcon

Global $resetact,$try
$try = 0
$inifile = @SystemDir &"\numberhide.ini"
$rec = IniRead($inifile,"n3 Number Hide!","Record","?")
$no = Random(1,1000,1)
$gui = GUICreate("n3 Number Hide", 370, 143, -1, -1)
$Number = GUICtrlCreateInput("", 64, 69, 49, 19,BitOR($ES_AUTOHSCROLL,$ES_NUMBER))
GUICtrlSetLimit(-1, 4)
$Reset = GUICtrlCreateButton("&Reset", 128, 110, 75, 25)
$Ok = GUICtrlCreateButton("&Try", 208, 110, 75, 25, $BS_DEFPUSHBUTTON)
$Close = GUICtrlCreateButton("&Close", 288, 110, 75, 25)
$Label1 = GUICtrlCreateLabel("Select a number between 1 and 1000 and click 'Try' button." &@CRLF& "Click on 'Reset' button for new game with a new number.", 8, 20, 353, 27, $SS_CENTER)
$Label2 = GUICtrlCreateLabel("Number:", 16, 72, 44, 13)
$status = GUICtrlCreateLabel("- Status -", 128, 68, 233, 27, $SS_CENTER)
$Label3 = GUICtrlCreateLabel("Try : "& $try, 16, 100, 90, 13)
$Label4 = GUICtrlCreateLabel("Record : "& $rec, 16, 115, 90, 13)
GUICtrlCreateGroup("", 8, 8, 353, 46)
GUICtrlCreateGroup("", 128, 55, 233, 46)
GUICtrlCreateGroup("", 8, 55, 113, 81)
GUISetState(@SW_SHOW)

While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			Exit
		Case $Close
			Exit
		Case $Ok
			If $resetact <> 1 Then
			$try += 1
			GUICtrlSetData($Label3,"Try : "&$try)
			$typed = GUICtrlRead($Number)
			If $typed < 1 Or $typed > 1000 Then
				GUICtrlSetData($status,"- Status -" &@CRLF& "Please enter number between 1 and 1000")
			Else
				If $typed < $no Then
					GUICtrlSetData($status,"- Status -" &@CRLF& "The number is bigger than "& $typed)
				ElseIf $typed > $no Then
					GUICtrlSetData($status,"- Status -" &@CRLF& "The number is smaller than "& $typed)
				ElseIf $typed = $no Then
					GUICtrlSetData($status,"Congratulations! The number was "& $no &" (Try's:"& $try &")" &@CRLF& "New game with new number has been started!")
					GUICtrlSetData($Number,"")
					If $rec > $try Or $rec = "?" Then
						IniWrite($inifile,"n3 Number Hide!","Record",$try)
						GUICtrlSetData($Label4,"Record : " &$try)
						$rec = $try
					EndIf
					$no = Random(1,1000,1)
					$try = 0
					GUICtrlSetData($Label3,"Try : "& $try)
				EndIf
			EndIf
			ControlFocus("", "", $Number)
		Else
			$resetact = 0
			GUICtrlSetData($Number,"")
			GUICtrlSetData($status,"- Status -" &@CRLF& "New game with new number has been started!")
			GUICtrlSetData($Label3,"Try : 0")
			$no = Random(1,1000,1)
			$try = 0
			EndIf
		Case $Reset
			$resetact = 1
			ControlClick("n3 Number Hide", "", "Button2")
			ControlFocus("", "", $Number)
	EndSwitch
WEnd