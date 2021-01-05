#include <GuiConstants.au3>
Opt("RunErrorsFatal", 0)
Opt("TrayIconDebug", 1)
Global $turn, $mark, $CtrlButtons[9], $player[2][9], $buttons[9], $computer
Func NextPlayer($label)
	If $turn = 1 Then
		$turn = 2
		$mark = "O"
		If $computer = 1 Then
			GUICtrlSetData($label, "Computer's Turn")
			Sleep(1000)
		Else
			GUICtrlSetData($label, "Player 2's Turn")
		EndIf
	Else
		$turn = 1
		$mark = "X"
		GUICtrlSetData($label, "Player 1's Turn")
	EndIf
EndFunc   ;==>NextPlayer
Func Check($activegui)
	Local $winner, $draw, $newgame
	For $x = 0 To 1
		If $player[$x][0] = 1 And $player[$x][1] = 1 And $player[$x][2] = 1 Then $winner = $x + 1
		If $player[$x][3] = 1 And $player[$x][4] = 1 And $player[$x][5] = 1 Then $winner = $x + 1
		If $player[$x][6] = 1 And $player[$x][7] = 1 And $player[$x][8] = 1 Then $winner = $x + 1
		If $player[$x][0] = 1 And $player[$x][3] = 1 And $player[$x][6] = 1 Then $winner = $x + 1
		If $player[$x][1] = 1 And $player[$x][4] = 1 And $player[$x][7] = 1 Then $winner = $x + 1
		If $player[$x][2] = 1 And $player[$x][5] = 1 And $player[$x][8] = 1 Then $winner = $x + 1
		If $player[$x][0] = 1 And $player[$x][4] = 1 And $player[$x][8] = 1 Then $winner = $x + 1
		If $player[$x][2] = 1 And $player[$x][4] = 1 And $player[$x][6] = 1 Then $winner = $x + 1
		For $y = 0 To 8
			If $buttons[$y] = 1 Then $draw += 1
		Next
		If $draw = 9 Then $winner = 3
	Next
	Select
		Case $winner = 1 Or $winner = 2
			$newgame = MsgBox(4, "Winner!", "And the winner is: Player " & $winner & "!" & @CRLF & @CRLF & "New Game?")
		Case $winner = 3
			$newgame = MsgBox(4, "Draw!", "The game ended in a draw." & @CRLF & @CRLF & "New Game?")
	EndSelect
	If $newgame = 6 Then
		GUIDelete($activegui)
		NewGame()
	Else
		Exit
	EndIf
EndFunc   ;==>Check
Func BotTurn()
	$numgen = Random(0, 8, 1)
	If $buttons[$numgen] = 1 Then
		BotTurn()
	Else
		;	GUICtrlSendMsg($CtrlButtons[$numgen], "", "", "")
	EndIf
EndFunc   ;==>BotTurn
Func NewGame()
	For $x = 0 To 1
		For $y = 0 To 8
			$player[$x][$y] = 0
		Next
	Next
	For $x = 0 To 8
		$buttons[$x] = 0
		$CtrlButtons[$x] = 0
	Next
	$winner = 0
	$turn = 0
	$maingui = GUICreate("Tic-Tac-Toe", 145, 220, (@DesktopWidth - 145) / 2, (@DesktopHeight - 200) / 2, $WS_DLGFRAME)
	$CtrlButtons[0] = GUICtrlCreateButton("", 15, 30, 25, 25)
	$CtrlButtons[1] = GUICtrlCreateButton("", 60, 30, 25, 25)
	$CtrlButtons[2] = GUICtrlCreateButton("", 105, 30, 25, 25)
	$CtrlButtons[3] = GUICtrlCreateButton("", 15, 60, 25, 25)
	$CtrlButtons[4] = GUICtrlCreateButton("", 60, 60, 25, 25)
	$CtrlButtons[5] = GUICtrlCreateButton("", 105, 60, 25, 25)
	$CtrlButtons[6] = GUICtrlCreateButton("", 15, 90, 25, 25)
	$CtrlButtons[7] = GUICtrlCreateButton("", 60, 90, 25, 25)
	$CtrlButtons[8] = GUICtrlCreateButton("", 105, 90, 25, 25)
	Dim $Who_Goes = GUICtrlCreateLabel("", 15, 120, 115, 25)
	Dim $Exit = GUICtrlCreateButton("Exit", 60, 150, 30, 25)
	GUICtrlSetStyle($Who_Goes, $SS_CENTER)
	GUISetState()
	Local $bot = MsgBox(4, "Tic-Tac-Toe", "Would you like to play against the computer?")
	If $bot = 6 Then
		$computer = 1
	Else
		$computer = 0
	EndIf
	While 1
		NextPlayer($Who_Goes)
		Check($maingui)
		$nextturn = False
		If $computer = 1 And $turn = 2 Then BotTurn()
		While Not $nextturn
			$msg = GUIGetMsg()
			Select
				Case $msg = $GUI_EVENT_CLOSE Or $msg = $Exit
					Exit
				Case $msg = $CtrlButtons[0]
					GUICtrlSetData($CtrlButtons[0], $mark)
					GUICtrlSetState($CtrlButtons[0], $GUI_DISABLE)
					$player[$turn - 1][0] = 1
					$buttons[0] = 1
					$nextturn = True
				Case $msg = $CtrlButtons[1]
					GUICtrlSetData($CtrlButtons[1], $mark)
					GUICtrlSetState($CtrlButtons[1], $GUI_DISABLE)
					$player[$turn - 1][1] = 1
					$buttons[1] = 1
					$nextturn = True
				Case $msg = $CtrlButtons[2]
					GUICtrlSetData($CtrlButtons[2], $mark)
					GUICtrlSetState($CtrlButtons[2], $GUI_DISABLE)
					$player[$turn - 1][2] = 1
					$buttons[2] = 1
					$nextturn = True
				Case $msg = $CtrlButtons[3]
					GUICtrlSetData($CtrlButtons[3], $mark)
					GUICtrlSetState($CtrlButtons[3], $GUI_DISABLE)
					$player[$turn - 1][3] = 1
					$buttons[3] = 1
					$nextturn = True
				Case $msg = $CtrlButtons[4]
					GUICtrlSetData($CtrlButtons[4], $mark)
					GUICtrlSetState($CtrlButtons[4], $GUI_DISABLE)
					$player[$turn - 1][4] = 1
					$buttons[4] = 1
					$nextturn = True
				Case $msg = $CtrlButtons[5]
					GUICtrlSetData($CtrlButtons[5], $mark)
					GUICtrlSetState($CtrlButtons[5], $GUI_DISABLE)
					$player[$turn - 1][5] = 1
					$buttons[5] = 1
					$nextturn = True
				Case $msg = $CtrlButtons[6]
					GUICtrlSetData($CtrlButtons[6], $mark)
					GUICtrlSetState($CtrlButtons[6], $GUI_DISABLE)
					$player[$turn - 1][6] = 1
					$buttons[6] = 1
					$nextturn = True
				Case $msg = $CtrlButtons[7]
					GUICtrlSetData($CtrlButtons[7], $mark)
					GUICtrlSetState($CtrlButtons[7], $GUI_DISABLE)
					$player[$turn - 1][7] = 1
					$buttons[7] = 1
					$nextturn = True
				Case $msg = $CtrlButtons[8]
					GUICtrlSetData($CtrlButtons[8], $mark)
					GUICtrlSetState($CtrlButtons[8], $GUI_DISABLE)
					$player[$turn - 1][8] = 1
					$buttons[8] = 1
					$nextturn = True
			EndSelect
		WEnd
	WEnd
EndFunc   ;==>NewGame
Func HotKeyQuit()
	Exit
EndFunc   ;==>HotKeyQuit
HotKeySet("^z", "HotKeyQuit")
NewGame()