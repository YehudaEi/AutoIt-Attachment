#NoTrayIcon

#include <ButtonConstants.au3>
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>

Global $status[10] ;ary to hold status of button clicked or not
$status[0] = 9 ;first one as a count
Global $Button[10] ;ary for buttons
$Button[0] = 9 ;first one as a count
Global $var ;other vars
Global $count = 0 ;count to check when to see for win
Enum $User, $PC ;Pc or user is playing
Global $Deep = 0 ;recursion depth
Global $player = "User" ;initial player is user

main() ;main gui

Func main()
	Global $Main = GUICreate("Tic Tak Toe", 123, 123, 192, 124, BitOR($WS_SYSMENU, $WS_CAPTION, $WS_POPUP, $WS_POPUPWINDOW, $WS_BORDER, $WS_CLIPSIBLINGS), BitOR($WS_EX_TOOLWINDOW, $WS_EX_WINDOWEDGE))
	$Button[1] = GUICtrlCreateButton("", 0, 0, 40, 40)
	$status[1] = "enabled"
	$Button[2] = GUICtrlCreateButton("", 40, 0, 40, 40)
	$status[2] = "enabled"
	$Button[3] = GUICtrlCreateButton("", 80, 0, 40, 40)
	$status[3] = "enabled"
	$Button[4] = GUICtrlCreateButton("", 0, 40, 40, 40)
	$status[4] = "enabled"
	$Button[5] = GUICtrlCreateButton("", 40, 40, 40, 40)
	$status[5] = "enabled"
	$Button[6] = GUICtrlCreateButton("", 80, 40, 40, 40)
	$status[6] = "enabled"
	$Button[7] = GUICtrlCreateButton("", 0, 81, 40, 40)
	$status[7] = "enabled"
	$Button[8] = GUICtrlCreateButton("", 40, 80, 40, 40)
	$status[8] = "enabled"
	$Button[9] = GUICtrlCreateButton("", 80, 80, 40, 40)
	$status[9] = "enabled"

	GUISetState(@SW_SHOW)

	While 1

		$nMsg = GUIGetMsg()

		Switch $nMsg
			Case $GUI_EVENT_CLOSE
				Exit

			Case $Button[1]
				If Islegal(1) Then ;Islegal checks if move is legal
					$player = "User" ;set player to user if from previous call the pc is set to player
					MakeMove(1) ;make a move a current button
					$count += 1 ;increament count
					If $count >= 5 Then _CheckWin() ;if count > 5 check win as no win can occur before 5 moves
					computerplay() ;make the coumputer play
				Else
					ContinueLoop ;if not legal then just keep lookin for a move
				EndIf

			Case $Button[2]
				If Islegal(2) Then ;Islegal checks if move is legal
					$player = "User" ;set player to user if from previous call the pc is set to player
					MakeMove(2) ;make a move a current button
					$count += 1 ;increament count
					If $count >= 5 Then _CheckWin() ;if count > 5 check win as no win can occur before 5 moves
					computerplay() ;make the coumputer play
				Else
					ContinueLoop ;if not legal then just keep lookin for a move
				EndIf

			Case $Button[3]
				If Islegal(3) Then ;Islegal checks if move is legal
					$player = "User" ;set player to user if from previous call the pc is set to player
					MakeMove(3) ;make a move a current button
					$count += 1 ;increament count
					If $count >= 5 Then _CheckWin() ;if count > 5 check win as no win can occur before 5 moves
					computerplay() ;make the coumputer play
				Else
					ContinueLoop ;if not legal then just keep lookin for a move
				EndIf

			Case $Button[4]
				If Islegal(4) Then ;Islegal checks if move is legal
					$player = "User" ;set player to user if from previous call the pc is set to player
					MakeMove(4) ;make a move a current button
					$count += 1 ;increament count
					If $count >= 5 Then _CheckWin() ;if count > 5 check win as no win can occur before 5 moves
					computerplay() ;make the coumputer play
				Else
					ContinueLoop ;if not legal then just keep lookin for a move
				EndIf

			Case $Button[5]
				If Islegal(5) Then ;Islegal checks if move is legal
					$player = "User" ;set player to user if from previous call the pc is set to player
					MakeMove(5) ;make a move a current button
					$count += 1 ;increament count
					If $count >= 5 Then _CheckWin() ;if count > 5 check win as no win can occur before 5 moves
					computerplay() ;make the coumputer play
				Else
					ContinueLoop ;if not legal then just keep lookin for a move
				EndIf

			Case $Button[6]
				If Islegal(6) Then ;Islegal checks if move is legal
					$player = "User" ;set player to user if from previous call the pc is set to player
					MakeMove(6) ;make a move a current button
					$count += 1 ;increament count
					If $count >= 5 Then _CheckWin() ;if count > 5 check win as no win can occur before 5 moves
					computerplay() ;make the coumputer play
				Else
					ContinueLoop ;if not legal then just keep lookin for a move
				EndIf

			Case $Button[7]
				If Islegal(7) Then ;Islegal checks if move is legal
					$player = "User" ;set player to user if from previous call the pc is set to player
					MakeMove(7) ;make a move a current button
					$count += 1 ;increament count
					If $count >= 5 Then _CheckWin() ;if count > 5 check win as no win can occur before 5 moves
					computerplay() ;make the coumputer play
				Else
					ContinueLoop ;if not legal then just keep lookin for a move
				EndIf

			Case $Button[8]
				If Islegal(8) Then ;Islegal checks if move is legal
					$player = "User" ;set player to user if from previous call the pc is set to player
					MakeMove(8) ;make a move a current button
					$count += 1 ;increament count
					If $count >= 5 Then _CheckWin() ;if count > 5 check win as no win can occur before 5 moves
					computerplay() ;make the coumputer play
				Else
					ContinueLoop ;if not legal then just keep lookin for a move
				EndIf

			Case $Button[9]
				If Islegal(9) Then ;Islegal checks if move is legal
					$player = "User" ;set player to user if from previous call the pc is set to player
					MakeMove(9) ;make a move a current button
					$count += 1 ;increament count
					If $count >= 5 Then _CheckWin() ;if count > 5 check win as no win can occur before 5 moves
					computerplay() ;make the coumputer play
				Else
					ContinueLoop ;if not legal then just keep lookin for a move
				EndIf

		EndSwitch
	WEnd
EndFunc   ;==>main


Func _Reset() ;reset function to set all status to enabled
	For $i = 1 To 9
		$status[$i] = "enabled"
	Next
EndFunc   ;==>_Reset

Func _ResetWithData() ;resetwithdata function to set all status and data to enabled
	For $i = 1 To 9
		$status[$i] = "enabled"
		GUICtrlSetData($Button[$i], "")
	Next
EndFunc   ;==>_ResetWithData

Func _CheckWin() ;function to check win
	If GUICtrlRead($Button[1]) = GUICtrlRead($Button[2]) And GUICtrlRead($Button[2]) = GUICtrlRead($Button[3]) And GUICtrlRead($Button[3]) = GUICtrlRead($Button[1]) Then
		$windata = GUICtrlRead($Button[1])
		If $windata = "" Then ;they can be equal if all are blank :)
			;;
			;;
		Else
			declarewin($windata) ;if not blank then the one with its data on all of 'em wins
		EndIf
	EndIf

	If GUICtrlRead($Button[4]) = GUICtrlRead($Button[5]) And GUICtrlRead($Button[5]) = GUICtrlRead($Button[6]) And GUICtrlRead($Button[6]) = GUICtrlRead($Button[4]) Then
		$windata = GUICtrlRead($Button[4])
		If $windata = "" Then
			;;
			;;
		Else
			declarewin($windata)
		EndIf
	EndIf

	If GUICtrlRead($Button[7]) = GUICtrlRead($Button[8]) And GUICtrlRead($Button[8]) = GUICtrlRead($Button[9]) And GUICtrlRead($Button[9]) = GUICtrlRead($Button[7]) Then
		$windata = GUICtrlRead($Button[7])
		If $windata = "" Then
			;;
			;;
		Else
			declarewin($windata)
		EndIf
	EndIf

	If GUICtrlRead($Button[1]) = GUICtrlRead($Button[4]) And GUICtrlRead($Button[4]) = GUICtrlRead($Button[7]) And GUICtrlRead($Button[7]) = GUICtrlRead($Button[4]) Then
		$windata = GUICtrlRead($Button[1])
		If $windata = "" Then
			;;
			;;
		Else
			declarewin($windata)
		EndIf
	EndIf



	If GUICtrlRead($Button[2]) = GUICtrlRead($Button[5]) And GUICtrlRead($Button[5]) = GUICtrlRead($Button[8]) And GUICtrlRead($Button[8]) = GUICtrlRead($Button[2]) Then
		$windata = GUICtrlRead($Button[2])
		If $windata = "" Then
			;;
			;;
		Else
			declarewin($windata)
		EndIf
	EndIf

	If GUICtrlRead($Button[3]) = GUICtrlRead($Button[6]) And GUICtrlRead($Button[6]) = GUICtrlRead($Button[9]) And GUICtrlRead($Button[9]) = GUICtrlRead($Button[3]) Then
		$windata = GUICtrlRead($Button[3])
		If $windata = "" Then
			;;
			;;
		Else
			declarewin($windata)
		EndIf
	EndIf

	If GUICtrlRead($Button[1]) = GUICtrlRead($Button[5]) And GUICtrlRead($Button[5]) = GUICtrlRead($Button[9]) And GUICtrlRead($Button[9]) = GUICtrlRead($Button[1]) Then
		$windata = GUICtrlRead($Button[5])
		If $windata = "" Then
			;;
			;;
		Else
			declarewin($windata)
		EndIf
	EndIf

	If GUICtrlRead($Button[3]) = GUICtrlRead($Button[5]) And GUICtrlRead($Button[5]) = GUICtrlRead($Button[7]) And GUICtrlRead($Button[7]) = GUICtrlRead($Button[3]) Then
		$windata = GUICtrlRead($Button[3])
		If $windata = "" Then
			;;
			;;
		Else
			declarewin($windata)
		EndIf
	EndIf

	If Not GUICtrlRead($Button[1]) = "" And Not GUICtrlRead($Button[2]) = "" And Not GUICtrlRead($Button[3]) = "" And Not GUICtrlRead($Button[4]) = "" And Not GUICtrlRead($Button[5]) = "" And Not GUICtrlRead($Button[6]) = "" And Not GUICtrlRead($Button[7]) = "" And Not GUICtrlRead($Button[8]) = "" And Not GUICtrlRead($Button[9]) = "" Then
		MsgBox(Default, "Tie", "No one wins - Let's replay :)", 5) ;tie
		GUIDelete($Main) ;delete main
		main() ;start game again
	EndIf

EndFunc   ;==>_CheckWin


Func declarewin($var) ;decalre win msg by checkin the argument passed

	If $var = "X" Then
		MsgBox(Default, "You Win", "Well played you win", 5)
	ElseIf $var = "O" Then
		MsgBox(Default, "I Win", "I win, better luck next time", 5)
	Else
		MsgBox(Default, "error", "Some error occured", 5)
		Exit
	EndIf
	$count = 0 ;reset count
	GUIDelete($Main) ;delete game
	main() ;start again
EndFunc   ;==>declarewin

Func _CheckWinTemp() ;check win same as abobve but will return true or false rather than delare a win msg
	If GUICtrlRead($Button[1]) = GUICtrlRead($Button[2]) And GUICtrlRead($Button[2]) = GUICtrlRead($Button[3]) And GUICtrlRead($Button[3]) = GUICtrlRead($Button[1]) Then
		$windata = GUICtrlRead($Button[1])
		If $windata = "" Then
			Return True
		Else
			Return False
		EndIf
	EndIf

	If GUICtrlRead($Button[4]) = GUICtrlRead($Button[5]) And GUICtrlRead($Button[5]) = GUICtrlRead($Button[6]) And GUICtrlRead($Button[6]) = GUICtrlRead($Button[4]) Then
		$windata = GUICtrlRead($Button[4])
		If $windata = "" Then
			Return True
		Else
			Return False
		EndIf
	EndIf

	If GUICtrlRead($Button[7]) = GUICtrlRead($Button[8]) And GUICtrlRead($Button[8]) = GUICtrlRead($Button[9]) And GUICtrlRead($Button[9]) = GUICtrlRead($Button[7]) Then
		$windata = GUICtrlRead($Button[7])
		If $windata = "" Then
			Return True
		Else
			Return False
		EndIf
	EndIf

	If GUICtrlRead($Button[1]) = GUICtrlRead($Button[4]) And GUICtrlRead($Button[4]) = GUICtrlRead($Button[7]) And GUICtrlRead($Button[7]) = GUICtrlRead($Button[4]) Then
		$windata = GUICtrlRead($Button[1])
		If $windata = "" Then
			Return True
		Else
			Return False
		EndIf
	EndIf

	If GUICtrlRead($Button[2]) = GUICtrlRead($Button[5]) And GUICtrlRead($Button[5]) = GUICtrlRead($Button[8]) And GUICtrlRead($Button[8]) = GUICtrlRead($Button[2]) Then
		$windata = GUICtrlRead($Button[2])
		If $windata = "" Then
			Return True
		Else
			Return False
		EndIf
	EndIf

	If GUICtrlRead($Button[3]) = GUICtrlRead($Button[6]) And GUICtrlRead($Button[6]) = GUICtrlRead($Button[9]) And GUICtrlRead($Button[9]) = GUICtrlRead($Button[3]) Then
		$windata = GUICtrlRead($Button[3])
		If $windata = "" Then
			Return True
		Else
			Return False
		EndIf
	EndIf

	If GUICtrlRead($Button[1]) = GUICtrlRead($Button[5]) And GUICtrlRead($Button[5]) = GUICtrlRead($Button[9]) And GUICtrlRead($Button[9]) = GUICtrlRead($Button[1]) Then
		$windata = GUICtrlRead($Button[5])
		If $windata = "" Then
			Return True
		Else
			Return False
		EndIf
	EndIf

	If GUICtrlRead($Button[3]) = GUICtrlRead($Button[5]) And GUICtrlRead($Button[5]) = GUICtrlRead($Button[7]) And GUICtrlRead($Button[7]) = GUICtrlRead($Button[3]) Then
		$windata = GUICtrlRead($Button[3])
		If $windata = "" Then
			Return True
		Else
			Return False
		EndIf
	EndIf

	If Not GUICtrlRead($Button[1]) = "" And Not GUICtrlRead($Button[2]) = "" And Not GUICtrlRead($Button[3]) = "" And Not GUICtrlRead($Button[4]) = "" And Not GUICtrlRead($Button[5]) = "" And Not GUICtrlRead($Button[6]) = "" And Not GUICtrlRead($Button[7]) = "" And Not GUICtrlRead($Button[8]) = "" And Not GUICtrlRead($Button[9]) = "" Then
		Return False
	EndIf

EndFunc   ;==>_CheckWinTemp

Func Islegal($move) ;check if move is legal
	If GUICtrlRead($Button[$move]) = "" And $status[$move] = "enabled" Then
		Return True
	Else
		Return False
	EndIf
EndFunc   ;==>Islegal

Func MakeMove($move) ;make a move at argument passed
	GUICtrlSetData($Button[$move], "X")
	$status[$move] = "disabled"
EndFunc   ;==>MakeMove


Func MakeMovePC($move) ;make move for pc
	GUICtrlSetData($Button[$move], "Y")
	$status[$move] = "disabled"
EndFunc   ;==>MakeMovePC

Func computerplay() ;computer play
	$player = "PC" ;change player
	_Evaluate() ;the main function with AI
EndFunc   ;==>computerplay


Func _Evaluate() ;this is the fucntion I am gettin error in to make it work with AI as shown in the link of website
	;all this function is taken from that site so please check that link and then see if there is an error
	Dim Const $winscore = 100
	Dim Const $drawscore = 50
	Dim $legalmoves = 0
	Dim $totalscore = 0
	Dim $highscore = 0
	Dim $avgscore, $score2
	Dim $waswin = False
	Dim $wasother = False
	$Deep += 1
	Dim $returnmove

	For $move = 1 To $move <= 9
		If Islegal($move) Then
			If $legalmoves = 0 Then
				$returnmove = $move
				$legalmoves += 1
				MakeMovePC($move)
				If _CheckWinTemp() Then
					$waswin = True
					$highscore = $winscore
					$totalscore += $winscore
					$returnmove = $move
				Else
					If $player = "User" Then
						$newplayer = "PC"
					Else
						$newplayer = "User"
					EndIf

					_Evaluate($score2)
					If $score2 = $winscore Then
						$waswin = True
					Else
						$wasother = True
					EndIf

					$totalscore += $score2

					If $score2 > $highscore Then
						$highscore = $score2
						$returnmove = $move
					EndIf

				EndIf

				If $legalmoves = 0 Then
					$score = $drawscore
					$Deep -= 1
					Return (11)

				Else
					$avgscore = $totalscore / $legalmoves

					If $waswin And $wasother Then
						$score = $winscore - ($winscore - $avgscore)

					Else
						$score = $avgscore

					EndIf

					$score = 100 - $score

					$Deep -= 1

					Return ($returnmove)

				EndIf

			EndIf
		EndIf
	Next


EndFunc   ;==>_Evaluate



Func _compare() ;compare function to check if there would be a win at any place
	;this one is also taken from link

	Dim $comp
	Dim $aAry[10]
	If $player = "User" Then
		For $i = 1 To 9
			$aAry[$i] = $status[$i]
		Next
	ElseIf $player = "PC" Then
		For $i = 1 To 9
			$aAry[$i] = $status[$i]
		Next
	EndIf

	If ($aAry(1) = "disabled" And $aAry(2) = "disabled" And $aAry(3) = "disabled") Or _
			($aAry(3) = "disabled" And $aAry(4) = "disabled" And $aAry(6) = "disabled") Or _
			($aAry(7) = "disabled" And $aAry(8) = "disabled" And $aAry(9) = "disabled") Then
		$comp = True
	ElseIf ($aAry(1) = "disabled" And $aAry(4) = "disabled" And $aAry(7) = "disabled") Or _
			($aAry(2) = "disabled" And $aAry(5) = "disabled" And $aAry(8) = "disabled") Or _
			($aAry(3) = "disabled" And $aAry(6) = "disabled" And $aAry(9) = "disabled") Then
		$comp = True
	ElseIf ($aAry(1) = "disabled" And $aAry(5) = "disabled" And $aAry(9) = "disabled") Or _
			($aAry(3) = "disabled" And $aAry(5) = "disabled" And $aAry(7) = "disabled") Then
		$comp = True
	Else
		;;
	EndIf
EndFunc   ;==>_compare

