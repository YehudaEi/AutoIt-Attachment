#include <GUIConstantsEx.au3>
#include <ButtonConstants.au3>
#include <Array.au3>

Opt("GUIOnEventMode", 1)

Global $FirstRun, $Answer1, $Answer2, $Answer3, $Answer4, $QuestionButton, $String, $Answer, $CurrentPlayerNumber = 1, $CurrentPlayer, $CurrentMoney, $Stakes
Dim $UsedQuestions[20000], $Name[100],$NameCash[100]

$Questions = IniReadSection("QuestionDatabase.ini", "Level1")

$NumberOfPlayers = InputBox("Number of players", "How many people will be playing?")
For $i = 1 To $NumberOfPlayers Step +1
	$Name[$i] = InputBox("Player Name", "What is player " & $i & "'s name?")
	$NameCash[$i] = 1000
Next

_CreateGUI()

Func _CreateGUI()
$Gui = GuiCreate("Trivia!", 800,600)
GUISetOnEvent($GUI_EVENT_CLOSE, "_Closed")
GuiCtrlCreateGroup("",10,5,780,80)
$CurrentPlayer = GuiCtrlCreateLabel($Name[1],15,15,700,30)
$CurrentMoney = GuiCtrlCreateLabel("$ " & $NameCash[1], 15,50,700,20)
GuiCtrlSetFont($CurrentMoney, 15)
GuiCtrlSetFont($CurrentPlayer, 15)
GUICtrlCreateGroup("", -99, -99, 1, 1)
GUICtrlCreatePic("Blank.bmp", 20, 100, 755, 200)
$Random = Random(1,$Questions[0][0],1)
_ArrayAdd($UsedQuestions,$Random)
$QuestionButton = GuiCtrlCreateButton($Questions[$Random][0],20,100,755,200,BitOr($BS_CENTER, $BS_MULTILINE))
$SplitPossibleAnswers = StringSplit($Questions[$Random][1],",")
$String = StringSplit($SplitPossibleAnswers[4],":")
$Answer = StringStripWS($String[2],1)
StringStripWS($String[2],2)
GuiCtrlCreateGroup("",20,310,755,200)
$Answer1 = GuiCtrlCreateButton($SplitPossibleAnswers[1],30,330,365,75,BitOr($BS_CENTER, $BS_MULTILINE))
GUICtrlSetOnEvent($Answer1, "_Check1")
$Answer2 = GuiCtrlCreateButton($SplitPossibleAnswers[2],397,330,365,75,BitOr($BS_CENTER, $BS_MULTILINE))
GUICtrlSetOnEvent($Answer2, "_Check2")
$Answer3 = GuiCtrlCreateButton($SplitPossibleAnswers[3],30,420,365,75,BitOr($BS_CENTER, $BS_MULTILINE))
GUICtrlSetOnEvent($Answer3, "_Check3")
$Answer4 = GuiCtrlCreateButton($String[1],397,420,365,75,BitOr($BS_CENTER, $BS_MULTILINE))
GUICtrlSetOnEvent($Answer4, "_Check4")
GuiSetState()
			$Gambler = MsgBox(4,"Gambler", "Do you wish to raise the stakes?")
	If $Gambler = 6 Then
		$Stakes = InputBox("Amount", "How much would you like to wager?")
	Else
		Sleep(10)
	EndIf
EndFunc

Func _Random()
	$Random = Random(1,$Questions[0][0],1)
	_ArraySearch($UsedQuestions,$Random)
	If @Error Then
			$Gambler = MsgBox(4,"Gambler", "Do you wish to raise the stakes?")
	If $Gambler = 6 Then
		$Stakes = InputBox("Amount", "How much would you like to wager?")
	Else
		Sleep(10)
	EndIf
	_ArrayAdd($UsedQuestions,$Random)
	GuiCtrlSetData($QuestionButton, $Questions[$Random][0])
	$SplitPossibleAnswers = StringSplit($Questions[$Random][1],",")
	$String = StringSplit($SplitPossibleAnswers[4],":")
	$Answer = StringStripWS($String[2],1)
	StringStripWS($String[2],2)
	GuiCtrlCreateGroup("",20,310,755,200)
	GuiCtrlSetData($Answer1, $SplitPossibleAnswers[1])
	GuiCtrlSetData($Answer2, $SplitPossibleAnswers[2])
	GuiCtrlSetData($Answer3, $SplitPossibleAnswers[3])
	GuiCtrlSetData($Answer4, $String[1])
Else
	_Random()
EndIf
EndFunc

Func _Check1()
	$Data = GuiCtrlRead($Answer1)
	$TestAnswer = StringStripWS($Data,1)
	$TestAnswer2 = StringStripWS($TestAnswer,2)
	$FinalAnswer = MsgBox(4,"Final Answer", "Is " & $TestAnswer2 & " your final answer?")
	If $FinalAnswer = 6 Then
		If $TestAnswer2 = $Answer Then
			MsgBox(0, "Correct", "Your answer was correct!")
			$NameCash[$CurrentPlayerNumber] += $Stakes+200
			$CurrentPlayerNumber += 1
			If $CurrentPlayerNumber > $NumberOfPlayers Then
				$CurrentPlayerNumber = 1
				GuiCtrlSetData($CurrentPlayer, $Name[$CurrentPlayerNumber])
				GuiCtrlSetData($CurrentMoney, "$ " & $NameCash[$CurrentPlayerNumber])
				$Stakes = 0
				_Random()
			Else
				GuiCtrlSetData($CurrentPlayer, $Name[$CurrentPlayerNumber])
				GuiCtrlSetData($CurrentMoney, "$ " & $NameCash[$CurrentPlayerNumber])
				$Stakes = 0
				_Random()
			EndIf
		Else
			MsgBox(0, "Incorrect", "I'm sorry, your answer was wrong!")
			$NameCash[$CurrentPlayerNumber] -= $Stakes+200
			$CurrentPlayerNumber += 1
			If $CurrentPlayerNumber > $NumberOfPlayers Then
				$CurrentPlayerNumber = 1
				GuiCtrlSetData($CurrentPlayer, $Name[$CurrentPlayerNumber])
				GuiCtrlSetData($CurrentMoney, "$ " & $NameCash[$CurrentPlayerNumber])
				$Stakes = 0
				_Random()
			Else
				GuiCtrlSetData($CurrentPlayer, $Name[$CurrentPlayerNumber])
				GuiCtrlSetData($CurrentMoney, "$ " & $NameCash[$CurrentPlayerNumber])
				$Stakes = 0
				_Random()
			EndIf
		EndIf
	EndIf
EndFunc

Func _Check2()
	$Data = GuiCtrlRead($Answer2)
	$TestAnswer = StringStripWS($Data,1)
	$TestAnswer2 = StringStripWS($TestAnswer,2)
	$FinalAnswer = MsgBox(4,"Final Answer", "Is " & $TestAnswer2 & " your final answer?")
	If $FinalAnswer = 6 Then
		If $TestAnswer2 = $Answer Then
			MsgBox(0, "Correct", "Your answer was correct!")
			$NameCash[$CurrentPlayerNumber] += $Stakes+200
			$CurrentPlayerNumber += 1
			If $CurrentPlayerNumber > $NumberOfPlayers Then
				$CurrentPlayerNumber = 1
				GuiCtrlSetData($CurrentPlayer, $Name[$CurrentPlayerNumber])
				GuiCtrlSetData($CurrentMoney, "$ " & $NameCash[$CurrentPlayerNumber])
				$Stakes = 0
				_Random()
			Else
				GuiCtrlSetData($CurrentPlayer, $Name[$CurrentPlayerNumber])
				GuiCtrlSetData($CurrentMoney, "$ " & $NameCash[$CurrentPlayerNumber])
				$Stakes = 0
				_Random()
			EndIf
		Else
			MsgBox(0, "Incorrect", "I'm sorry, your answer was wrong!")
			$NameCash[$CurrentPlayerNumber] -= $Stakes+200
			$CurrentPlayerNumber += 1
			If $CurrentPlayerNumber > $NumberOfPlayers Then
				$CurrentPlayerNumber = 1
				GuiCtrlSetData($CurrentPlayer, $Name[$CurrentPlayerNumber])
				GuiCtrlSetData($CurrentMoney, "$ " & $NameCash[$CurrentPlayerNumber])
				$Stakes = 0
				_Random()
			Else
				GuiCtrlSetData($CurrentPlayer, $Name[$CurrentPlayerNumber])
				GuiCtrlSetData($CurrentMoney, "$ " & $NameCash[$CurrentPlayerNumber])
				$Stakes = 0
				_Random()
			EndIf
		EndIf
	EndIf
EndFunc

Func _Check3()
	$Data = GuiCtrlRead($Answer3)
	$TestAnswer = StringStripWS($Data,1)
	$TestAnswer2 = StringStripWS($TestAnswer,2)
	$FinalAnswer = MsgBox(4,"Final Answer", "Is " & $TestAnswer2 & " your final answer?")
	If $FinalAnswer = 6 Then
		If $TestAnswer2 = $Answer Then
			MsgBox(0, "Correct", "Your answer was correct!")
			$NameCash[$CurrentPlayerNumber] += $Stakes+200
			$CurrentPlayerNumber += 1
			If $CurrentPlayerNumber > $NumberOfPlayers Then
				$CurrentPlayerNumber = 1
				GuiCtrlSetData($CurrentPlayer, $Name[$CurrentPlayerNumber])
				GuiCtrlSetData($CurrentMoney, "$ " & $NameCash[$CurrentPlayerNumber])
				$Stakes = 0
				_Random()
			Else
				GuiCtrlSetData($CurrentPlayer, $Name[$CurrentPlayerNumber])
				GuiCtrlSetData($CurrentMoney, "$ " & $NameCash[$CurrentPlayerNumber])
				_Random()
			EndIf
		Else
			MsgBox(0, "Incorrect", "I'm sorry, your answer was wrong!")
			$NameCash[$CurrentPlayerNumber] -= $Stakes+200
			$CurrentPlayerNumber += 1
			If $CurrentPlayerNumber > $NumberOfPlayers Then
				$CurrentPlayerNumber = 1
				GuiCtrlSetData($CurrentPlayer, $Name[$CurrentPlayerNumber])
				GuiCtrlSetData($CurrentMoney, "$ " & $NameCash[$CurrentPlayerNumber])
				$Stakes = 0
				_Random()
			Else
				GuiCtrlSetData($CurrentPlayer, $Name[$CurrentPlayerNumber])
				GuiCtrlSetData($CurrentMoney, "$ " & $NameCash[$CurrentPlayerNumber])
				$Stakes = 0
				_Random()
			EndIf
		EndIf
	EndIf
EndFunc

Func _Check4()
	$Data = GuiCtrlRead($Answer4)
	$TestAnswer = StringStripWS($Data,1)
	$TestAnswer2 = StringStripWS($TestAnswer,2)
	$FinalAnswer = MsgBox(4,"Final Answer", "Is " & $TestAnswer2 & " your final answer?")
	If $FinalAnswer = 6 Then
		If $TestAnswer2 = $Answer Then
			MsgBox(0, "Correct", "Your answer was correct!")
			$NameCash[$CurrentPlayerNumber] += $Stakes+200
			$CurrentPlayerNumber += 1
			If $CurrentPlayerNumber > $NumberOfPlayers Then
				$CurrentPlayerNumber = 1
				GuiCtrlSetData($CurrentPlayer, $Name[$CurrentPlayerNumber])
				GuiCtrlSetData($CurrentMoney, "$ " & $NameCash[$CurrentPlayerNumber])
				$Stakes = 0
				_Random()
			Else
				GuiCtrlSetData($CurrentPlayer, $Name[$CurrentPlayerNumber])
				GuiCtrlSetData($CurrentMoney, "$ " & $NameCash[$CurrentPlayerNumber])
				$Stakes = 0
				_Random()
			EndIf
		Else
			MsgBox(0, "Incorrect", "I'm sorry, your answer was wrong!")
			$NameCash[$CurrentPlayerNumber] -= $Stakes+200
			$CurrentPlayerNumber += 1
			If $CurrentPlayerNumber > $NumberOfPlayers Then
				$CurrentPlayerNumber = 1
				GuiCtrlSetData($CurrentPlayer, $Name[$CurrentPlayerNumber])
				GuiCtrlSetData($CurrentMoney, "$ " & $NameCash[$CurrentPlayerNumber])
				$Stakes = 0
				_Random()
			Else
				GuiCtrlSetData($CurrentPlayer, $Name[$CurrentPlayerNumber])
				GuiCtrlSetData($CurrentMoney, "$ " & $NameCash[$CurrentPlayerNumber])
				$Stakes = 0
				_Random()
			EndIf
		EndIf
	EndIf
EndFunc

Func _Closed()
	Exit
EndFunc


While 1
	Sleep(10)
WEnd