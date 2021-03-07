#cs ----------------------------------------------------------------------------

	AutoIt Version: 3.3.8.1
	Author:         XxFxX
	Version:        1.00

	Script Function:
	Jeopardy tool to help with the questions.

#ce ----------------------------------------------------------------------------

#include <GUIConstantsEx.au3>
#include <GUIListBox.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <Questions.au3>
#include <Answers.au3>



Opt("GUIOnEventMode", 1)
SplashImageOn("", "C:\AUTOIT\Jeopardy_tool\jeopardy192.jpg", "-1", "-1", "-1", "-1", 3)
SoundPlay("j.mp3", 0)
Sleep(5000)
SplashOff()



Global $Jeopardy = GUICreate("Jeopardy", 521, 465)
GUISetBkColor(0x000080)
Global $AnswersLabel = GUICtrlCreateLabel("Answer List", 16, 8, 170, 38, $WS_BORDER)
GUICtrlSetFont($AnswersLabel, 22, 800, 0, "Gyparody Hv")
GUICtrlSetColor($AnswersLabel, 0xFFFF00)
GUICtrlCreatePic("C:\AUTOIT\Jeopardy_tool\jeopardy192.jpg", 200, 0, 300, 276)
Global $QuestionsLabel = GUICtrlCreateLabel("Question", 224, 280, 100, 33)
GUICtrlSetFont($QuestionsLabel, 18, 400, 0, "Gyparody Rg")
GUICtrlSetColor($QuestionsLabel, 0xFFFF00)
Global $AnswersList = GUICtrlCreateList($Answers, 8, 48, 177, 253)
Global $QuestionsList = GUICtrlCreateList($Questions, 8, 328, 489, 97)


GUISetState(@SW_SHOW)



While 1
	Sleep(100)
WEnd

