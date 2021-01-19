;Original by AlmarM at http://www.autoitscript.com/forum/index.php?showtopic=53962
#include <GuiConstants.au3>
#include <Constants.au3>

Global $dif

HotKeySet("{F4}", "HighScores")

$Main = GUICreate("How fast are u ?", 370, 540) ; Given this GUI a name
GUISetState(@SW_SHOW)

$Start_Button = GUICtrlCreateButton("Start", 10, 10, 50, 50)
GUICtrlSetState($Start_Button, $GUI_ENABLE)
$Stop_Button = GUICtrlCreateButton("Stop", 310, 310, 50, 50)
GUICtrlSetState($Stop_Button, $GUI_DISABLE)
$Button_1 = GUICtrlCreateButton("Click", 70, 10, 50, 50)
GUICtrlSetState($Button_1, $GUI_DISABLE)
$Button_2 = GUICtrlCreateButton("Click", 130, 10, 50, 50)
GUICtrlSetState($Button_2, $GUI_DISABLE)
$Button_3 = GUICtrlCreateButton("Click", 190, 10, 50, 50)
GUICtrlSetState($Button_3, $GUI_DISABLE)
$Button_4 = GUICtrlCreateButton("Click", 250, 10, 50, 50)
GUICtrlSetState($Button_4, $GUI_DISABLE)
$Button_5 = GUICtrlCreateButton("Click", 310, 10, 50, 50)
GUICtrlSetState($Button_5, $GUI_DISABLE)
$Button_6 = GUICtrlCreateButton("Click", 10, 70, 50, 50)
GUICtrlSetState($Button_6, $GUI_DISABLE)
$Button_7 = GUICtrlCreateButton("Click", 70, 70, 50, 50)
GUICtrlSetState($Button_7, $GUI_DISABLE)
$Button_8 = GUICtrlCreateButton("Click", 130, 70, 50, 50)
GUICtrlSetState($Button_8, $GUI_DISABLE)
$Button_9 = GUICtrlCreateButton("Click", 190, 70, 50, 50)
GUICtrlSetState($Button_9, $GUI_DISABLE)
$Button_10 = GUICtrlCreateButton("Click", 250, 70, 50, 50)
GUICtrlSetState($Button_10, $GUI_DISABLE)
$Button_11 = GUICtrlCreateButton("Click", 310, 70, 50, 50)
GUICtrlSetState($Button_11, $GUI_DISABLE)
$Button_12 = GUICtrlCreateButton("Click", 10, 130, 50, 50)
GUICtrlSetState($Button_12, $GUI_DISABLE)
$Button_13 = GUICtrlCreateButton("Click", 70, 130, 50, 50)
GUICtrlSetState($Button_13, $GUI_DISABLE)
$Button_14 = GUICtrlCreateButton("Click", 130, 130, 50, 50)
GUICtrlSetState($Button_14, $GUI_DISABLE)
$Button_15 = GUICtrlCreateButton("Click", 190, 130, 50, 50)
GUICtrlSetState($Button_15, $GUI_DISABLE)
$Button_16 = GUICtrlCreateButton("Click", 250, 130, 50, 50)
GUICtrlSetState($Button_16, $GUI_DISABLE)
$Button_17 = GUICtrlCreateButton("Click", 310, 130, 50, 50)
GUICtrlSetState($Button_17, $GUI_DISABLE)
$Button_18 = GUICtrlCreateButton("Click", 10, 190, 50, 50)
GUICtrlSetState($Button_18, $GUI_DISABLE)
$Button_19 = GUICtrlCreateButton("Click", 70, 190, 50, 50)
GUICtrlSetState($Button_19, $GUI_DISABLE)
$Button_20 = GUICtrlCreateButton("Click", 130, 190, 50, 50)
GUICtrlSetState($Button_20, $GUI_DISABLE)
$Button_21 = GUICtrlCreateButton("Click", 190, 190, 50, 50)
GUICtrlSetState($Button_21, $GUI_DISABLE)
$Button_22 = GUICtrlCreateButton("Click", 250, 190, 50, 50)
GUICtrlSetState($Button_22, $GUI_DISABLE)
$Button_23 = GUICtrlCreateButton("Click", 310, 190, 50, 50)
GUICtrlSetState($Button_23, $GUI_DISABLE)
$Button_24 = GUICtrlCreateButton("Click", 10, 250, 50, 50)
GUICtrlSetState($Button_24, $GUI_DISABLE)
$Button_25 = GUICtrlCreateButton("Click", 70, 250, 50, 50)
GUICtrlSetState($Button_25, $GUI_DISABLE)
$Button_26 = GUICtrlCreateButton("Click", 130, 250, 50, 50)
GUICtrlSetState($Button_26, $GUI_DISABLE)
$Button_27 = GUICtrlCreateButton("Click", 190, 250, 50, 50)
GUICtrlSetState($Button_27, $GUI_DISABLE)
$Button_28 = GUICtrlCreateButton("Click", 250, 250, 50, 50)
GUICtrlSetState($Button_28, $GUI_DISABLE)
$Button_29 = GUICtrlCreateButton("Click", 310, 250, 50, 50)
GUICtrlSetState($Button_29, $GUI_DISABLE)
$Button_30 = GUICtrlCreateButton("Click", 10, 310, 50, 50)
GUICtrlSetState($Button_30, $GUI_DISABLE)
$Button_31 = GUICtrlCreateButton("Click", 70, 310, 50, 50)
GUICtrlSetState($Button_31, $GUI_DISABLE)
$Button_32 = GUICtrlCreateButton("Click", 130, 310, 50, 50)
GUICtrlSetState($Button_32, $GUI_DISABLE)
$Button_33 = GUICtrlCreateButton("Click", 190, 310, 50, 50)
GUICtrlSetState($Button_33, $GUI_DISABLE)
$Button_34 = GUICtrlCreateButton("Click", 250, 310, 50, 50)
GUICtrlSetState($Button_34, $GUI_DISABLE)
$HighScore = GUICtrlCreateEdit("Highscore:" & @CRLF & @CRLF, 10, 370, 350, 120)
$Restart_Button = GUICtrlCreateButton("Restart", 100, 500, 80, 30)
$HighScores = GUICtrlCreateButton("High Scores", 200, 500, 80, 30)

While 1
	$msg = GUIGetMsg()

	Select
		Case $msg = $GUI_EVENT_CLOSE
			Exit

		Case $msg = $Start_Button
			$begin = TimerInit()
			GUICtrlSetState($Button_28, $GUI_ENABLE)
			GUICtrlSetState($Start_Button, $GUI_DISABLE)
			Beep(500, 100)

		Case $msg = $Button_28
			GUICtrlSetState($Button_3, $GUI_ENABLE)
			GUICtrlSetState($Button_28, $GUI_DISABLE)

		Case $msg = $Button_3
			GUICtrlSetState($Button_30, $GUI_ENABLE)
			GUICtrlSetState($Button_3, $GUI_DISABLE)

		Case $msg = $Button_30
			GUICtrlSetState($Button_15, $GUI_ENABLE)
			GUICtrlSetState($Button_30, $GUI_DISABLE)

		Case $msg = $Button_15
			GUICtrlSetState($Button_7, $GUI_ENABLE)
			GUICtrlSetState($Button_15, $GUI_DISABLE)

		Case $msg = $Button_7
			GUICtrlSetState($Button_29, $GUI_ENABLE)
			GUICtrlSetState($Button_7, $GUI_DISABLE)

		Case $msg = $Button_29
			GUICtrlSetState($Button_13, $GUI_ENABLE)
			GUICtrlSetState($Button_29, $GUI_DISABLE)

		Case $msg = $Button_13
			GUICtrlSetState($Button_5, $GUI_ENABLE)
			GUICtrlSetState($Button_13, $GUI_DISABLE)

		Case $msg = $Button_5
			GUICtrlSetState($Button_14, $GUI_ENABLE)
			GUICtrlSetState($Button_5, $GUI_DISABLE)

		Case $msg = $Button_14
			GUICtrlSetState($Button_34, $GUI_ENABLE)
			GUICtrlSetState($Button_14, $GUI_DISABLE)

		Case $msg = $Button_34
			GUICtrlSetState($Button_8, $GUI_ENABLE)
			GUICtrlSetState($Button_34, $GUI_DISABLE)

		Case $msg = $Button_8
			GUICtrlSetState($Button_32, $GUI_ENABLE)
			GUICtrlSetState($Button_8, $GUI_DISABLE)

		Case $msg = $Button_32
			GUICtrlSetState($Button_16, $GUI_ENABLE)
			GUICtrlSetState($Button_32, $GUI_DISABLE)

		Case $msg = $Button_16
			GUICtrlSetState($Button_18, $GUI_ENABLE)
			GUICtrlSetState($Button_16, $GUI_DISABLE)

		Case $msg = $Button_18
			GUICtrlSetState($Button_21, $GUI_ENABLE)
			GUICtrlSetState($Button_18, $GUI_DISABLE)

		Case $msg = $Button_21
			GUICtrlSetState($Button_1, $GUI_ENABLE)
			GUICtrlSetState($Button_21, $GUI_DISABLE)

		Case $msg = $Button_1
			GUICtrlSetState($Button_33, $GUI_ENABLE)
			GUICtrlSetState($Button_1, $GUI_DISABLE)

		Case $msg = $Button_33
			GUICtrlSetState($Button_20, $GUI_ENABLE)
			GUICtrlSetState($Button_33, $GUI_DISABLE)

		Case $msg = $Button_20
			GUICtrlSetState($Button_11, $GUI_ENABLE)
			GUICtrlSetState($Button_20, $GUI_DISABLE)

		Case $msg = $Button_11
			GUICtrlSetState($Button_19, $GUI_ENABLE)
			GUICtrlSetState($Button_11, $GUI_DISABLE)

		Case $msg = $Button_19
			GUICtrlSetState($Button_4, $GUI_ENABLE)
			GUICtrlSetState($Button_19, $GUI_DISABLE)

		Case $msg = $Button_4
			GUICtrlSetState($Button_22, $GUI_ENABLE)
			GUICtrlSetState($Button_4, $GUI_DISABLE)

		Case $msg = $Button_22
			GUICtrlSetState($Button_2, $GUI_ENABLE)
			GUICtrlSetState($Button_22, $GUI_DISABLE)

		Case $msg = $Button_2
			GUICtrlSetState($Button_25, $GUI_ENABLE)
			GUICtrlSetState($Button_2, $GUI_DISABLE)

		Case $msg = $Button_25
			GUICtrlSetState($Button_10, $GUI_ENABLE)
			GUICtrlSetState($Button_25, $GUI_DISABLE)

		Case $msg = $Button_10
			GUICtrlSetState($Button_6, $GUI_ENABLE)
			GUICtrlSetState($Button_10, $GUI_DISABLE)

		Case $msg = $Button_6
			GUICtrlSetState($Button_23, $GUI_ENABLE)
			GUICtrlSetState($Button_6, $GUI_DISABLE)

		Case $msg = $Button_23
			GUICtrlSetState($Button_31, $GUI_ENABLE)
			GUICtrlSetState($Button_23, $GUI_DISABLE)

		Case $msg = $Button_31
			GUICtrlSetState($Button_9, $GUI_ENABLE)
			GUICtrlSetState($Button_31, $GUI_DISABLE)

		Case $msg = $Button_9
			GUICtrlSetState($Button_17, $GUI_ENABLE)
			GUICtrlSetState($Button_9, $GUI_DISABLE)

		Case $msg = $Button_17
			GUICtrlSetState($Button_12, $GUI_ENABLE)
			GUICtrlSetState($Button_17, $GUI_DISABLE)

		Case $msg = $Button_12
			GUICtrlSetState($Button_27, $GUI_ENABLE)
			GUICtrlSetState($Button_12, $GUI_DISABLE)

		Case $msg = $Button_27
			GUICtrlSetState($Button_24, $GUI_ENABLE)
			GUICtrlSetState($Button_27, $GUI_DISABLE)

		Case $msg = $Button_24
			GUICtrlSetState($Button_26, $GUI_ENABLE)
			GUICtrlSetState($Button_24, $GUI_DISABLE)

		Case $msg = $Button_26
			GUICtrlSetState($Stop_Button, $GUI_ENABLE)
			GUICtrlSetState($Button_26, $GUI_DISABLE)

		Case $msg = $Stop_Button
			Beep(500, 100)
			$dif = Round(TimerDiff($begin) / 1000, 1)
			MsgBox(0, "Your Time: ", "Your time is: " & $dif & " seconds.    ")
			GUICtrlSetData($HighScore, $dif & " Seconds" & @CRLF, "|")
			;Asks the user if they want to save their score
			If Not IsDeclared("iMsgBoxAnswer") Then Local $iMsgBoxAnswer
			$iMsgBoxAnswer = MsgBox(36, "Save", "Would you like to save your score?")
			Select
				Case $iMsgBoxAnswer = 6 ;Yes
					Save() ; Goes to the save function
				Case $iMsgBoxAnswer = 7 ;No
					;nothing
			EndSelect
		Case $msg = $Restart_Button
			_Reset()
		Case $msg = $HighScores
			HighScores()
	EndSelect
WEnd

Func _Reset()
	Sleep(100)
	MsgBox(0, "Restart", "Restarting" & @CRLF & "Please wait...", 2)
	GUICtrlSetState($Button_1, $GUI_DISABLE)
	GUICtrlSetState($Button_2, $GUI_DISABLE)
	GUICtrlSetState($Button_3, $GUI_DISABLE)
	GUICtrlSetState($Button_4, $GUI_DISABLE)
	GUICtrlSetState($Button_5, $GUI_DISABLE)
	GUICtrlSetState($Button_6, $GUI_DISABLE)
	GUICtrlSetState($Button_7, $GUI_DISABLE)
	GUICtrlSetState($Button_8, $GUI_DISABLE)
	GUICtrlSetState($Button_9, $GUI_DISABLE)
	GUICtrlSetState($Button_10, $GUI_DISABLE)
	GUICtrlSetState($Button_11, $GUI_DISABLE)
	GUICtrlSetState($Button_12, $GUI_DISABLE)
	GUICtrlSetState($Button_13, $GUI_DISABLE)
	GUICtrlSetState($Button_14, $GUI_DISABLE)
	GUICtrlSetState($Button_15, $GUI_DISABLE)
	GUICtrlSetState($Button_16, $GUI_DISABLE)
	GUICtrlSetState($Button_17, $GUI_DISABLE)
	GUICtrlSetState($Button_18, $GUI_DISABLE)
	GUICtrlSetState($Button_19, $GUI_DISABLE)
	GUICtrlSetState($Button_20, $GUI_DISABLE)
	GUICtrlSetState($Button_21, $GUI_DISABLE)
	GUICtrlSetState($Button_22, $GUI_DISABLE)
	GUICtrlSetState($Button_23, $GUI_DISABLE)
	GUICtrlSetState($Button_24, $GUI_DISABLE)
	GUICtrlSetState($Button_25, $GUI_DISABLE)
	GUICtrlSetState($Button_26, $GUI_DISABLE)
	GUICtrlSetState($Button_27, $GUI_DISABLE)
	GUICtrlSetState($Button_28, $GUI_DISABLE)
	GUICtrlSetState($Button_29, $GUI_DISABLE)
	GUICtrlSetState($Button_30, $GUI_DISABLE)
	GUICtrlSetState($Button_31, $GUI_DISABLE)
	GUICtrlSetState($Button_32, $GUI_DISABLE)
	GUICtrlSetState($Button_33, $GUI_DISABLE)
	GUICtrlSetState($Button_34, $GUI_DISABLE)
	GUICtrlSetState($Stop_Button, $GUI_DISABLE)
	GUICtrlSetState($Start_Button, $GUI_ENABLE)
	Sleep(100)
EndFunc   ;==>_Reset

Func Save()
	$i = 1 + $i ; Will write the score to the next number in line
	IniWrite(@ScriptDir & "\Scores.ini", "Scores", $i, $dif & " Seconds") ; Writes to the scores file
	MsgBox(64, "Saved", "Your high score has been saved!") ; Tells you it is saved
	HighScores() ; Opens the high scores window
EndFunc   ;==>Save


Func HighScores()
	GUISetState(@SW_HIDE, $Main)
	$i = 1 + $i
	$Scores = IniRead(@ScriptDir & "\Scores.ini", "Scores", $i, "") ; Reads the scores from the ini (semi-working)
	$HS = GUICreate("HighScores", 386, 287)
	$Group = GUICtrlCreateGroup("HighScores", 8, 8, 369, 273)
	$HSList = GUICtrlCreateEdit("", 40, 40, 305, 209, BitOR($ES_READONLY, $ES_WANTRETURN))
	GUICtrlCreateGroup("", -99, -99, 1, 1)
	GUICtrlSetData($HSList, $Scores) ; Sets the scores to the HS box (semi-working)
	GUISetState(@SW_SHOW)

	While 2
		$msg2 = GUIGetMsg()
		Select
			Case $msg2 = $GUI_EVENT_CLOSE
				ExitLoop
		EndSelect
	WEnd
	GUIDelete($HS)
	GUISetState(@SW_SHOW, $Main)
EndFunc   ;==>HighScores