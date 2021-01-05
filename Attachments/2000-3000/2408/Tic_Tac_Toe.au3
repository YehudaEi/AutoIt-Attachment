#include <GuiConstants.au3>
Global $turn, $mark, $computer, $player[2][9], $CtrlButtons[9], $botturn, $buttons[9]
Func NextPlayer($label)
	If $turn <> 1 Then
		$turn = 1
		$mark = "X"
		GUICtrlSetData($label, "Player 1's Turn")
	ElseIf $turn = 1 AND $computer = 0 Then
		$turn = 2
		$mark = "O"
		GUICtrlSetData($label, "Player 2's Turn")
	Else
		$turn = 2
		$mark = "O"
		GUICtrlSetData($label, "Computer's Turn")
	EndIf
EndFunc   ;==>NextPlayer

Func BotTurn()
    Local $numgen = Random(0, 8, 1)
    If $buttons[$numgen] = 1 Then
        BotTurn()
    Else
        ;MsgBox(0, "Bot's Move", $numgen + 1)
		$botturn = $buttons[$numgen]
    EndIf
EndFunc ;==>BotTurn

Func Check($activegui)
	Local $winner, $nowinner
	;;Check to see if someone won
	For $x = 0 To 1
		If $player[$x][0] = 1 And $player[$x][1] = 1 And $player[$x][2] = 1 Then $winner = $x + 1
		If $player[$x][3] = 1 And $player[$x][4] = 1 And $player[$x][5] = 1 Then $winner = $x + 1
		If $player[$x][6] = 1 And $player[$x][7] = 1 And $player[$x][8] = 1 Then $winner = $x + 1
		If $player[$x][0] = 1 And $player[$x][3] = 1 And $player[$x][6] = 1 Then $winner = $x + 1
		If $player[$x][1] = 1 And $player[$x][4] = 1 And $player[$x][7] = 1 Then $winner = $x + 1
		If $player[$x][2] = 1 And $player[$x][5] = 1 And $player[$x][8] = 1 Then $winner = $x + 1
		If $player[$x][0] = 1 And $player[$x][4] = 1 And $player[$x][8] = 1 Then $winner = $x + 1
		If $player[$x][2] = 1 And $player[$x][4] = 1 And $player[$x][6] = 1 Then $winner = $x + 1
	Next
	For $x = 0 To 8
		If $buttons[$x] = 1 Then $nowinner += 1
	Next
	If $nowinner = 9 AND $winner = 0 Then $winner = 3
	;;Congratulate winner, prompt for new game
	If $winner <> 0 Then
		If $winner = 1 Or $winner = 2 Then $newgame = MsgBox(4, "Winner!", "And the winner is: Player " & $winner & "!" & @CRLF & @CRLF & "New Game?")
		If $winner = 3 Then $newgame = MsgBox(4, "Draw!", "The game ended in a draw." & @CRLF & @CRLF & "New Game?")
		If $newgame = 6 Then
			GUIDelete($activegui)
			Sleep(300)
			NewGame()
		Else
			Exit
		EndIf
	EndIf
EndFunc   ;==>Check
Func NewGame()
	;;Reset tracking variables
	For $x = 0 To 1
		For $y = 0 To 8
			$player[$x][$y] = 0
			$buttons[$y] = 0
			$CtrlButtons[$y] = 0
		Next
	Next
	$turn = 0
	;;Create GUI
	$maingui = GUICreate("Tic-Tac-Toe", 145, 220, (@DesktopWidth - 145) / 2, (@DesktopHeight - 220) / 2, $WS_DLGFRAME)
	$CtrlButtons[0] = GUICtrlCreateButton("", 15, 30, 25, 25)
	$CtrlButtons[1] = GUICtrlCreateButton("", 60, 30, 25, 25)
	$CtrlButtons[2] = GUICtrlCreateButton("", 105, 30, 25, 25)
	$CtrlButtons[3] = GUICtrlCreateButton("", 15, 60, 25, 25)
	$CtrlButtons[4] = GUICtrlCreateButton("", 60, 60, 25, 25)
	$CtrlButtons[5] = GUICtrlCreateButton("", 105, 60, 25, 25)
	$CtrlButtons[6] = GUICtrlCreateButton("", 15, 90, 25, 25)
	$CtrlButtons[7] = GUICtrlCreateButton("", 60, 90, 25, 25)
	$CtrlButtons[8] = GUICtrlCreateButton("", 105, 90, 25, 25)
	Dim $Who_Goes = GUICtrlCreateLabel("Player 1's Turn", 15, 120, 115, 25)
	Dim $Exit = GUICtrlCreateButton("Exit", 60, 150, 30, 25)
	GUICtrlSetStyle($Who_Goes, $SS_CENTER)
	$bot = MsgBox(4, "Tic-Tac-Toe", "Do you want to play against the computer?")
	If $bot = 6 Then
		$computer = 1
	Else
		$computer = 0
	EndIf
	GUISetState()
	;;Start Playing!
	While 1
		NextPlayer($Who_Goes)
		If $turn = 2 AND $computer = 1 Then BotTurn()
		Check($maingui)
		$nextturn = False
		While Not $nextturn
			$msg = GUIGetMsg()
			Select
				Case $msg = $GUI_EVENT_CLOSE Or $msg = $Exit
					Exit
				Case $msg = $CtrlButtons[0] Or $botturn = $CtrlButtons[0]
					If $buttons[0] = 0 Then
						GUICtrlSetData($CtrlButtons[0], $mark)
						$player[$turn - 1][0] = 1
						$buttons[0] = 1
						$nextturn = True
					EndIf
				Case $msg = $CtrlButtons[1] Or $botturn = $CtrlButtons[1]
					If $buttons[1] = 0 Then
						GUICtrlSetData($CtrlButtons[1], $mark)
						$player[$turn - 1][1] = 1
						$buttons[1] = 1
						$nextturn = True
					EndIf
				Case $msg = $CtrlButtons[2] Or $botturn = $CtrlButtons[2]
					If $buttons[2] = 0 Then
						GUICtrlSetData($CtrlButtons[2], $mark)
						$player[$turn - 1][2] = 1
						$buttons[2] = 1
						$nextturn = True
					EndIf
				Case $msg = $CtrlButtons[3] Or $botturn = $CtrlButtons[3]
					If $buttons[3] = 0 Then
						GUICtrlSetData($CtrlButtons[3], $mark)
						$player[$turn - 1][3] = 1
						$buttons[3] = 1
						$nextturn = True
					EndIf
				Case $msg = $CtrlButtons[4] Or $botturn = $CtrlButtons[4]
					If $buttons[4] = 0 Then
						GUICtrlSetData($CtrlButtons[4], $mark)
						$player[$turn - 1][4] = 1
						$buttons[4] = 1
						$nextturn = True
					EndIf
				Case $msg = $CtrlButtons[5] Or $botturn = $CtrlButtons[5]
					If $buttons[5] = 0 Then
						GUICtrlSetData($CtrlButtons[5], $mark)
						$player[$turn - 1][5] = 1
						$buttons[5] = 1
						$nextturn = True
					EndIf
				Case $msg = $CtrlButtons[6] Or $botturn = $CtrlButtons[6]
					If $buttons[6] = 0 Then
						GUICtrlSetData($CtrlButtons[6], $mark)
						$player[$turn - 1][6] = 1
						$buttons[6] = 1
						$nextturn = True
					EndIf
				Case $msg = $CtrlButtons[7] Or $botturn = $CtrlButtons[7]
					If $buttons[7] = 0 Then
						GUICtrlSetData($CtrlButtons[7], $mark)
						$player[$turn - 1][7] = 1
						$buttons[7] = 1
						$nextturn = True
					EndIf
 				Case $msg = $CtrlButtons[8] Or $botturn = $CtrlButtons[8]
					If $buttons[8] = 0 Then
						GUICtrlSetData($CtrlButtons[8], $mark)
						$player[$turn - 1][8] = 1
						$buttons[8] = 1
						$nextturn = True
					EndIf
			EndSelect
		WEnd
	WEnd
EndFunc   ;==>NewGame
Func HotKeyQuit()
	Exit
EndFunc   ;==>HotKeyQuit
HotKeySet("^z", "HotKeyQuit")
NewGame()