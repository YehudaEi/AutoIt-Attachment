#NoTrayIcon

Global $TriviaFile = @ScriptDir & "\Trivia.ini"
Global $GetQuestions, $CurrentQuestion, $CurrentQuestionCount = 1
Global $Miss = 0

$GUI = GUICreate("Human Body Trivia", 211, 266)
GUICtrlCreateLabel("Question:", 0, 0, 49, 17)
$Edit = GUICtrlCreateEdit("", 0, 16, 209, 113, 4)
$Answer1 = GUICtrlCreateCheckbox("", 0, 144, 209, 17)
$Answer2 = GUICtrlCreateCheckbox("", 0, 176, 209, 17)
$Answer3 = GUICtrlCreateCheckbox("", 0, 208, 209, 17)
$Ok = GUICtrlCreateButton("Ok", 64, 240, 75, 25, 0)
_NewQuestion()
GUISetState(@SW_SHOW, $GUI)

While 1
	Switch GUIGetMsg()
		Case - 3
			Exit
		Case $Answer1
			If GUICtrlRead($Answer2) Or GUICtrlRead($Answer3) = 1 Then
				 GUICtrlSetState($Answer2, 4)
				 GUICtrlSetState($Answer3, 4)
			EndIf
		Case $Answer2
			If GUICtrlRead($Answer1) Or GUICtrlRead($Answer3) = 1 Then
				GUICtrlSetState($Answer1, 4)
				GUICtrlSetState($Answer3, 4)
			EndIf
		Case $Answer3
			If GUICtrlRead($Answer1) Or GUICtrlRead($Answer2) = 1 Then
				GUICtrlSetState($Answer1, 4)
				GUICtrlSetState($Answer2, 4)
			EndIf
		Case $Ok
			$GetCorrect = IniRead($TriviaFile, $CurrentQuestion, "Correct", "")
			If $GetCorrect = "Answer1" And GUICtrlRead($Answer1) = 4 Then $Miss += 1
			If $GetCorrect = "Answer2" And GUICtrlRead($Answer2) = 4 Then $Miss += 1
			If $GetCorrect = "Answer3" And GUICtrlRead($Answer3) = 4 Then $Miss += 1
			_NewQuestion()
			If $CurrentQuestionCount = 11 Then
				If MsgBox(68, "Human Body Trivia", "Congratulations! You finished the " & $GetQuestions[0] & " questions, and missed: " & $Miss & "." & @CRLF & "Play again?") = 6 Then
					$CurrentQuestion = 0
					$CurrentQuestionCount = 1
					$Miss = 0
					_NewQuestion()
				Else
					Exit
				EndIf
			EndIf
	EndSwitch
WEnd

Func _NewQuestion()
	GUICtrlSetState($Answer1, 4)
	GUICtrlSetState($Answer2, 4)
	GUICtrlSetState($Answer3, 4)
	$GetQuestions = IniReadSectionNames($TriviaFile)
	$CurrentQuestion = $GetQuestions[$CurrentQuestionCount]
	GUICtrlSetData($Edit, $CurrentQuestion)
	GUICtrlSetData($Answer1, IniRead($TriviaFile, $CurrentQuestion, "Answer1", ""))
	GUICtrlSetData($Answer2, IniRead($TriviaFile, $CurrentQuestion, "Answer2", ""))
	GUICtrlSetData($Answer3, IniRead($TriviaFile, $CurrentQuestion, "Answer3", ""))
	$CurrentQuestionCount += 1
EndFunc