#NoTrayIcon
#include <GUIConstantsEx.au3>
#include <EditConstants.au3>
#include <WindowsConstants.au3>
#include <File.au3>

NewGame()
WordGuess()
Winner()

Func NewGame()

	Global $Main = GUICreate("Word Guess", 230, 160, -1, -1)
	GUISetBkColor(0x000000)
	GUICtrlCreateLabel("Word:", 10, 20)
	GUICtrlSetColor(-1, 0xED1C24)
	Global $RandWord = GUICtrlCreateCheckbox(" ", 45, 65)
	GUICtrlCreateLabel("Use Random Word", 69, 70)
	GUICtrlSetColor(-1, 0xED1C24)
	Global $Word = GUICtrlCreateInput("", 45, 19, 160, 18)
	GUICtrlSetLimit(-1, 12)
	Global $AllowSolved = GUICtrlCreateCheckbox(" ", 45, 45)
	GUICtrlCreateLabel("Allow Word to be Solved", 69, 50)
	GUICtrlSetColor(-1, 0xED1C24)
	GUICtrlSetState($AllowSolved, $GUI_CHECKED)
	$Begin = GUICtrlCreateButton("Begin", 80, 98, 70, 30)
	$About = GUICtrlCreateButton("About", 0, 140, 70, 20)
	$Help = GUICtrlCreateButton("Help", 80, 140, 70, 20)
	$Exit = GUICtrlCreateButton("Exit", 160, 140, 70, 20)

	GUISetState()

	While 1
		$nMsg = GUIGetMsg()
		Switch $nMsg
			Case -3
				Exit
			Case $Exit
				Exit
			Case $About
				MsgBox(0, "About Word Guess", "Word Guess v1.1" & @LF & @LF & "Created By ReaperX (C) 2012")
			Case $Help
				MsgBox(32, "Help", 'Someone Enter a Word. Then Check "Allow to Be Solved" If You Would Like The Other Player to Have the Solving Ability. Then Click Begin. The Other Player then Enters Letters One at a Time and Clicks "Guess" to Guess the Letters In the Word or Clicks "Solve" To Completely Guess the Whole Word At Once If Allowed. Enjoy!')
			Case $Begin
				If BitAnd(GUICtrlRead($RandWord), $GUI_CHECKED) = $GUI_CHECKED Then
					Local $Line
					_FileReadToArray("dictionary.txt", $Line)
					$RandLine = Random(1, $Line[0], 1)
					Global $Word = FileReadLine("dictionary.txt", $RandLine + 1)
					GUISetState(@SW_HIDE)
					WordGuess()
				EndIf
				If StringInStr(GUICtrlRead($Word), Chr(32)) Then
					MsgBox(0, "Error!", "No Spaces Allowed!")
					GUIDelete()
					NewGame()
				EndIf
				If StringLen(GUICtrlRead($Word)) = 0 Then
					MsgBox(0, "Error!", "Make Sure You Type In a Word!")
					GUIDelete()
					NewGame()
				EndIf
				If StringIsAlpha(GUICtrlRead($Word)) = 0 Then
					MsgBox(0, "Error!", "Only Letters Are Allowed!")
					GUIDelete()
					NewGame()
				EndIf
				GUISetState(@SW_HIDE)
				WordGuess()
		EndSwitch
	WEnd
EndFunc   ;==>NewGame


Func WordGuess()
	Global $Word, $AllowSolved, $RandWord

	GUICreate("Word Guess", 300, 270)
	GUISetBkColor(0x000000)
	GUICtrlCreateLabel("Mistake Meter", 110, 50)
	GUICtrlSetColor(-1, 0xED1C24)
	$NewGame = GUICtrlCreateButton("New Game", 230, 0, 70, 20)
	$MistakeMeter = GUICtrlCreateProgress(20, 70, 260, 30)
	GUICtrlCreateLabel("Letter to Guess:", 30, 190)
	GUICtrlSetColor(-1, 0xED1C24)
	$Letter = GUICtrlCreateInput("", 110, 189, 23, 18)
	GUICtrlSetLimit(-1, 1)
	$Guess = GUICtrlCreateButton("Guess", 160, 188, 50, 20)
	GUICtrlCreateLabel("Letters Used:", 10, 243)
	GUICtrlSetColor(-1, 0xED1C24)
	$LettersUsed = GUICtrlCreateInput("", 80, 240, 210, 20, $ES_READONLY + $WS_HSCROLL)

	If BitAND(GUICtrlRead($RandWord), $GUI_CHECKED) = $GUI_CHECKED Then
		$Base = $Word
	Else
		$Base = GUICtrlRead($Word)
	EndIf

	If BitAND(GUICtrlRead($RandWord), $GUI_CHECKED) = $GUI_CHECKED Then
	$SpacesLeft = StringLen($Word)
Else
	$SpacesLeft = StringLen($Base)
EndIf

	$Mistake = 0
	$Solve = GUICtrlCreateButton("Solve", 210, 188, 50, 20)
	If BitAND(GUICtrlRead($AllowSolved), $GUI_UNCHECKED) = $GUI_UNCHECKED Then
		GUICtrlSetState(-1, $GUI_DISABLE)
	Else
		GUICtrlSetState(-1, $GUI_ENABLE)
	EndIf
	ControlFocus("", "", $Letter)

	;Sets Spaces For Letters in the Word
	If StringLen($Base) = 1 Then
		GUICtrlCreatePic("space.jpg", 140, 150, 15, 3)
		$Space1Letter = GUICtrlCreateLabel("", 144, 134, 15, 14)
		GUICtrlSetColor(-1, 0xED1C24)
	EndIf
	If StringLen($Base) = 2 Then
		GUICtrlCreatePic("space.jpg", 130, 150, 15, 3)
		GUICtrlCreatePic("space.jpg", 150, 150, 15, 3)
		$Space1Letter = GUICtrlCreateLabel("", 134, 134, 15, 14)
		GUICtrlSetColor(-1, 0xED1C24)
		$Space2Letter = GUICtrlCreateLabel("", 154, 134, 15, 14)
		GUICtrlSetColor(-1, 0xED1C24)
	EndIf
	If StringLen($Base) = 3 Then
		GUICtrlCreatePic("space.jpg", 120, 150, 15, 3)
		GUICtrlCreatePic("space.jpg", 140, 150, 15, 3)
		GUICtrlCreatePic("space.jpg", 160, 150, 15, 3)
		$Space1Letter = GUICtrlCreateLabel("", 124, 134, 15, 14)
		GUICtrlSetColor(-1, 0xED1C24)
		$Space2Letter = GUICtrlCreateLabel("", 144, 134, 15, 14)
		GUICtrlSetColor(-1, 0xED1C24)
		$Space3Letter = GUICtrlCreateLabel("", 164, 134, 15, 14)
		GUICtrlSetColor(-1, 0xED1C24)
	EndIf
	If StringLen($Base) = 4 Then
		GUICtrlCreatePic("space.jpg", 110, 150, 15, 3)
		GUICtrlCreatePic("space.jpg", 130, 150, 15, 3)
		GUICtrlCreatePic("space.jpg", 150, 150, 15, 3)
		GUICtrlCreatePic("space.jpg", 170, 150, 15, 3)
		$Space1Letter = GUICtrlCreateLabel("", 114, 134, 15, 13)
		GUICtrlSetColor(-1, 0xED1C24)
		$Space2Letter = GUICtrlCreateLabel("", 134, 134, 15, 13)
		GUICtrlSetColor(-1, 0xED1C24)
		$Space3Letter = GUICtrlCreateLabel("", 154, 134, 15, 13)
		GUICtrlSetColor(-1, 0xED1C24)
		$Space4Letter = GUICtrlCreateLabel("", 174, 134, 15, 13)
		GUICtrlSetColor(-1, 0xED1C24)
	EndIf
	If StringLen($Base) = 5 Then
		GUICtrlCreatePic("space.jpg", 100, 150, 15, 3)
		GUICtrlCreatePic("space.jpg", 120, 150, 15, 3)
		GUICtrlCreatePic("space.jpg", 140, 150, 15, 3)
		GUICtrlCreatePic("space.jpg", 160, 150, 15, 3)
		GUICtrlCreatePic("space.jpg", 180, 150, 15, 3)
		$Space1Letter = GUICtrlCreateLabel("", 104, 134, 15, 13)
		GUICtrlSetColor(-1, 0xED1C24)
		$Space2Letter = GUICtrlCreateLabel("", 124, 134, 15, 13)
		GUICtrlSetColor(-1, 0xED1C24)
		$Space3Letter = GUICtrlCreateLabel("", 144, 134, 15, 13)
		GUICtrlSetColor(-1, 0xED1C24)
		$Space4Letter = GUICtrlCreateLabel("", 164, 134, 15, 13)
		GUICtrlSetColor(-1, 0xED1C24)
		$Space5Letter = GUICtrlCreateLabel("", 184, 134, 15, 13)
		GUICtrlSetColor(-1, 0xED1C24)
	EndIf
	If StringLen($Base) = 6 Then
		GUICtrlCreatePic("space.jpg", 90, 150, 15, 3)
		GUICtrlCreatePic("space.jpg", 110, 150, 15, 3)
		GUICtrlCreatePic("space.jpg", 130, 150, 15, 3)
		GUICtrlCreatePic("space.jpg", 150, 150, 15, 3)
		GUICtrlCreatePic("space.jpg", 170, 150, 15, 3)
		GUICtrlCreatePic("space.jpg", 190, 150, 15, 3)
		$Space1Letter = GUICtrlCreateLabel("", 94, 134, 15, 13)
		GUICtrlSetColor(-1, 0xED1C24)
		$Space2Letter = GUICtrlCreateLabel("", 114, 134, 15, 13)
		GUICtrlSetColor(-1, 0xED1C24)
		$Space3Letter = GUICtrlCreateLabel("", 134, 134, 15, 13)
		GUICtrlSetColor(-1, 0xED1C24)
		$Space4Letter = GUICtrlCreateLabel("", 154, 134, 15, 13)
		GUICtrlSetColor(-1, 0xED1C24)
		$Space5Letter = GUICtrlCreateLabel("", 174, 134, 15, 13)
		GUICtrlSetColor(-1, 0xED1C24)
		$Space6Letter = GUICtrlCreateLabel("", 194, 134, 15, 13)
		GUICtrlSetColor(-1, 0xED1C24)
	EndIf
	If StringLen($Base) = 7 Then
		GUICtrlCreatePic("space.jpg", 80, 150, 15, 3)
		GUICtrlCreatePic("space.jpg", 100, 150, 15, 3)
		GUICtrlCreatePic("space.jpg", 120, 150, 15, 3)
		GUICtrlCreatePic("space.jpg", 140, 150, 15, 3)
		GUICtrlCreatePic("space.jpg", 160, 150, 15, 3)
		GUICtrlCreatePic("space.jpg", 180, 150, 15, 3)
		GUICtrlCreatePic("space.jpg", 200, 150, 15, 3)
		$Space1Letter = GUICtrlCreateLabel("", 84, 134, 15, 13)
		GUICtrlSetColor(-1, 0xED1C24)
		$Space2Letter = GUICtrlCreateLabel("", 104, 134, 15, 13)
		GUICtrlSetColor(-1, 0xED1C24)
		$Space3Letter = GUICtrlCreateLabel("", 124, 134, 15, 13)
		GUICtrlSetColor(-1, 0xED1C24)
		$Space4Letter = GUICtrlCreateLabel("", 144, 134, 15, 13)
		GUICtrlSetColor(-1, 0xED1C24)
		$Space5Letter = GUICtrlCreateLabel("", 164, 134, 15, 13)
		GUICtrlSetColor(-1, 0xED1C24)
		$Space6Letter = GUICtrlCreateLabel("", 184, 134, 15, 13)
		GUICtrlSetColor(-1, 0xED1C24)
		$Space7Letter = GUICtrlCreateLabel("", 204, 134, 15, 13)
		GUICtrlSetColor(-1, 0xED1C24)
	EndIf
	If StringLen($Base) = 8 Then
		GUICtrlCreatePic("space.jpg", 70, 150, 15, 3)
		GUICtrlCreatePic("space.jpg", 90, 150, 15, 3)
		GUICtrlCreatePic("space.jpg", 110, 150, 15, 3)
		GUICtrlCreatePic("space.jpg", 130, 150, 15, 3)
		GUICtrlCreatePic("space.jpg", 150, 150, 15, 3)
		GUICtrlCreatePic("space.jpg", 170, 150, 15, 3)
		GUICtrlCreatePic("space.jpg", 190, 150, 15, 3)
		GUICtrlCreatePic("space.jpg", 210, 150, 15, 3)
		$Space1Letter = GUICtrlCreateLabel("", 74, 134, 15, 13)
		GUICtrlSetColor(-1, 0xED1C24)
		$Space2Letter = GUICtrlCreateLabel("", 94, 134, 15, 13)
		GUICtrlSetColor(-1, 0xED1C24)
		$Space3Letter = GUICtrlCreateLabel("", 114, 134, 15, 13)
		GUICtrlSetColor(-1, 0xED1C24)
		$Space4Letter = GUICtrlCreateLabel("", 134, 134, 15, 13)
		GUICtrlSetColor(-1, 0xED1C24)
		$Space5Letter = GUICtrlCreateLabel("", 154, 134, 15, 13)
		GUICtrlSetColor(-1, 0xED1C24)
		$Space6Letter = GUICtrlCreateLabel("", 174, 134, 15, 13)
		GUICtrlSetColor(-1, 0xED1C24)
		$Space7Letter = GUICtrlCreateLabel("", 194, 134, 15, 13)
		GUICtrlSetColor(-1, 0xED1C24)
		$Space8Letter = GUICtrlCreateLabel("", 214, 134, 15, 13)
		GUICtrlSetColor(-1, 0xED1C24)
	EndIf
	If StringLen($Base) = 9 Then
		GUICtrlCreatePic("space.jpg", 60, 150, 15, 3)
		GUICtrlCreatePic("space.jpg", 80, 150, 15, 3)
		GUICtrlCreatePic("space.jpg", 100, 150, 15, 3)
		GUICtrlCreatePic("space.jpg", 120, 150, 15, 3)
		GUICtrlCreatePic("space.jpg", 140, 150, 15, 3)
		GUICtrlCreatePic("space.jpg", 160, 150, 15, 3)
		GUICtrlCreatePic("space.jpg", 180, 150, 15, 3)
		GUICtrlCreatePic("space.jpg", 200, 150, 15, 3)
		GUICtrlCreatePic("space.jpg", 220, 150, 15, 3)
		$Space1Letter = GUICtrlCreateLabel("", 64, 134, 15, 13)
		GUICtrlSetColor(-1, 0xED1C24)
		$Space2Letter = GUICtrlCreateLabel("", 84, 134, 15, 13)
		GUICtrlSetColor(-1, 0xED1C24)
		$Space3Letter = GUICtrlCreateLabel("", 104, 134, 15, 13)
		GUICtrlSetColor(-1, 0xED1C24)
		$Space4Letter = GUICtrlCreateLabel("", 124, 134, 15, 13)
		GUICtrlSetColor(-1, 0xED1C24)
		$Space5Letter = GUICtrlCreateLabel("", 144, 134, 15, 13)
		GUICtrlSetColor(-1, 0xED1C24)
		$Space6Letter = GUICtrlCreateLabel("", 164, 134, 15, 13)
		GUICtrlSetColor(-1, 0xED1C24)
		$Space7Letter = GUICtrlCreateLabel("", 184, 134, 15, 13)
		GUICtrlSetColor(-1, 0xED1C24)
		$Space8Letter = GUICtrlCreateLabel("", 204, 134, 15, 13)
		GUICtrlSetColor(-1, 0xED1C24)
		$Space9Letter = GUICtrlCreateLabel("", 224, 134, 15, 13)
		GUICtrlSetColor(-1, 0xED1C24)
	EndIf
	If StringLen($Base) = 10 Then
		GUICtrlCreatePic("space.jpg", 50, 150, 15, 3)
		GUICtrlCreatePic("space.jpg", 70, 150, 15, 3)
		GUICtrlCreatePic("space.jpg", 90, 150, 15, 3)
		GUICtrlCreatePic("space.jpg", 110, 150, 15, 3)
		GUICtrlCreatePic("space.jpg", 130, 150, 15, 3)
		GUICtrlCreatePic("space.jpg", 150, 150, 15, 3)
		GUICtrlCreatePic("space.jpg", 170, 150, 15, 3)
		GUICtrlCreatePic("space.jpg", 190, 150, 15, 3)
		GUICtrlCreatePic("space.jpg", 210, 150, 15, 3)
		GUICtrlCreatePic("space.jpg", 230, 150, 15, 3)
		$Space1Letter = GUICtrlCreateLabel("", 54, 134, 15, 13)
		GUICtrlSetColor(-1, 0xED1C24)
		$Space2Letter = GUICtrlCreateLabel("", 74, 134, 15, 13)
		GUICtrlSetColor(-1, 0xED1C24)
		$Space3Letter = GUICtrlCreateLabel("", 94, 134, 15, 13)
		GUICtrlSetColor(-1, 0xED1C24)
		$Space4Letter = GUICtrlCreateLabel("", 114, 134, 15, 13)
		GUICtrlSetColor(-1, 0xED1C24)
		$Space5Letter = GUICtrlCreateLabel("", 134, 134, 15, 13)
		GUICtrlSetColor(-1, 0xED1C24)
		$Space6Letter = GUICtrlCreateLabel("", 154, 134, 15, 13)
		GUICtrlSetColor(-1, 0xED1C24)
		$Space7Letter = GUICtrlCreateLabel("", 174, 134, 15, 13)
		GUICtrlSetColor(-1, 0xED1C24)
		$Space8Letter = GUICtrlCreateLabel("", 194, 134, 15, 13)
		GUICtrlSetColor(-1, 0xED1C24)
		$Space9Letter = GUICtrlCreateLabel("", 214, 134, 15, 13)
		GUICtrlSetColor(-1, 0xED1C24)
		$Space10Letter = GUICtrlCreateLabel("", 234, 134, 15, 13)
		GUICtrlSetColor(-1, 0xED1C24)
	EndIf
	If StringLen($Base) = 11 Then
		GUICtrlCreatePic("space.jpg", 40, 150, 15, 3)
		GUICtrlCreatePic("space.jpg", 60, 150, 15, 3)
		GUICtrlCreatePic("space.jpg", 80, 150, 15, 3)
		GUICtrlCreatePic("space.jpg", 100, 150, 15, 3)
		GUICtrlCreatePic("space.jpg", 120, 150, 15, 3)
		GUICtrlCreatePic("space.jpg", 140, 150, 15, 3)
		GUICtrlCreatePic("space.jpg", 160, 150, 15, 3)
		GUICtrlCreatePic("space.jpg", 180, 150, 15, 3)
		GUICtrlCreatePic("space.jpg", 200, 150, 15, 3)
		GUICtrlCreatePic("space.jpg", 220, 150, 15, 3)
		GUICtrlCreatePic("space.jpg", 240, 150, 15, 3)
		$Space1Letter = GUICtrlCreateLabel("", 44, 134, 15, 13)
		GUICtrlSetColor(-1, 0xED1C24)
		$Space2Letter = GUICtrlCreateLabel("", 64, 134, 15, 13)
		GUICtrlSetColor(-1, 0xED1C24)
		$Space3Letter = GUICtrlCreateLabel("", 84, 134, 15, 13)
		GUICtrlSetColor(-1, 0xED1C24)
		$Space4Letter = GUICtrlCreateLabel("", 104, 134, 15, 13)
		GUICtrlSetColor(-1, 0xED1C24)
		$Space5Letter = GUICtrlCreateLabel("", 124, 134, 15, 13)
		GUICtrlSetColor(-1, 0xED1C24)
		$Space6Letter = GUICtrlCreateLabel("", 144, 134, 15, 13)
		GUICtrlSetColor(-1, 0xED1C24)
		$Space7Letter = GUICtrlCreateLabel("", 164, 134, 15, 13)
		GUICtrlSetColor(-1, 0xED1C24)
		$Space8Letter = GUICtrlCreateLabel("", 184, 134, 15, 13)
		GUICtrlSetColor(-1, 0xED1C24)
		$Space9Letter = GUICtrlCreateLabel("", 204, 134, 15, 13)
		GUICtrlSetColor(-1, 0xED1C24)
		$Space10Letter = GUICtrlCreateLabel("", 224, 134, 15, 13)
		GUICtrlSetColor(-1, 0xED1C24)
		$Space11Letter = GUICtrlCreateLabel("", 244, 134, 15, 13)
		GUICtrlSetColor(-1, 0xED1C24)
	EndIf
	If StringLen($Base) = 12 Then
		GUICtrlCreatePic("space.jpg", 30, 150, 15, 3)
		GUICtrlCreatePic("space.jpg", 50, 150, 15, 3)
		GUICtrlCreatePic("space.jpg", 70, 150, 15, 3)
		GUICtrlCreatePic("space.jpg", 90, 150, 15, 3)
		GUICtrlCreatePic("space.jpg", 110, 150, 15, 3)
		GUICtrlCreatePic("space.jpg", 130, 150, 15, 3)
		GUICtrlCreatePic("space.jpg", 150, 150, 15, 3)
		GUICtrlCreatePic("space.jpg", 170, 150, 15, 3)
		GUICtrlCreatePic("space.jpg", 190, 150, 15, 3)
		GUICtrlCreatePic("space.jpg", 210, 150, 15, 3)
		GUICtrlCreatePic("space.jpg", 230, 150, 15, 3)
		GUICtrlCreatePic("space.jpg", 250, 150, 15, 3)
		$Space1Letter = GUICtrlCreateLabel("", 34, 134, 15, 13)
		GUICtrlSetColor(-1, 0xED1C24)
		$Space2Letter = GUICtrlCreateLabel("", 54, 134, 15, 13)
		GUICtrlSetColor(-1, 0xED1C24)
		$Space3Letter = GUICtrlCreateLabel("", 74, 134, 15, 13)
		GUICtrlSetColor(-1, 0xED1C24)
		$Space4Letter = GUICtrlCreateLabel("", 94, 134, 15, 13)
		GUICtrlSetColor(-1, 0xED1C24)
		$Space5Letter = GUICtrlCreateLabel("", 114, 134, 15, 13)
		GUICtrlSetColor(-1, 0xED1C24)
		$Space6Letter = GUICtrlCreateLabel("", 134, 134, 15, 13)
		GUICtrlSetColor(-1, 0xED1C24)
		$Space7Letter = GUICtrlCreateLabel("", 154, 134, 15, 13)
		GUICtrlSetColor(-1, 0xED1C24)
		$Space8Letter = GUICtrlCreateLabel("", 174, 134, 15, 13)
		GUICtrlSetColor(-1, 0xED1C24)
		$Space9Letter = GUICtrlCreateLabel("", 194, 134, 15, 13)
		GUICtrlSetColor(-1, 0xED1C24)
		$Space10Letter = GUICtrlCreateLabel("", 214, 134, 15, 13)
		GUICtrlSetColor(-1, 0xED1C24)
		$Space11Letter = GUICtrlCreateLabel("", 234, 134, 15, 13)
		GUICtrlSetColor(-1, 0xED1C24)
		$Space12Letter = GUICtrlCreateLabel("", 254, 134, 15, 13)
		GUICtrlSetColor(-1, 0xED1C24)
	EndIf

	GUISetState()

	While 1
		$iMsg = GUIGetMsg()
		Switch $iMsg
			Case -3
				$Confirm = MsgBox(36, "Exit", "There is a Game In Progress. Are You Sure You Want to Exit?")
				If $Confirm = 6 Then Exit
			Case $NewGame
				$Confirm = MsgBox(36, "New Game", "Are You Sure You Want to Start a New Game?")
				If $Confirm = 6 Then
					GUIDelete()
					NewGame()
				EndIf
			Case $Guess
				If StringLen($Base) = 1 Then
					If StringIsAlpha(GUICtrlRead($Letter)) Then
						If StringInStr($Base, GUICtrlRead($Letter)) Then
							GUICtrlSetData($Space1Letter, GUICtrlRead($Letter))
							Winner()

						Else
							If StringInStr(GUICtrlRead($LettersUsed), GUICtrlRead($Letter)) = 0 Then
								GUICtrlSetData($MistakeMeter, GUICtrlRead($MistakeMeter) + 17)
								GUICtrlSetData($LettersUsed, GUICtrlRead($LettersUsed) & GUICtrlRead($Letter))

							EndIf
						EndIf
					EndIf
				EndIf

				If StringLen($Base) = 2 Then
					If StringIsAlpha(GUICtrlRead($Letter)) Then
						If StringInStr($Base, GUICtrlRead($Letter)) Then
							If GUICtrlRead($Space1Letter) = "" Then
								$WordMath = Execute(StringLen($Base) - 1)
								$Trim = StringTrimRight($Base, $WordMath)
								If $Trim = GUICtrlRead($Letter) Then
									GUICtrlSetData($Space1Letter, $Trim)
									$SpacesLeft = $SpacesLeft - 1
									If $SpacesLeft = 0 Then Winner()
								EndIf
							EndIf
							If GUICtrlRead($Space2Letter) = "" Then
								$LeftSide = StringTrimLeft($Base, 1)
								If $LeftSide = GUICtrlRead($Letter) Then
									GUICtrlSetData($Space2Letter, GUICtrlRead($Letter))
									$SpacesLeft = $SpacesLeft - 1
									If $SpacesLeft = 0 Then Winner()
								EndIf
							EndIf
						Else
							If StringInStr(GUICtrlRead($LettersUsed), GUICtrlRead($Letter)) = 0 Then
								GUICtrlSetData($MistakeMeter, GUICtrlRead($MistakeMeter) + 17)
								GUICtrlSetData($LettersUsed, GUICtrlRead($LettersUsed) & GUICtrlRead($Letter))
							EndIf
						EndIf
						GUICtrlSetData($Letter, "")
					EndIf
				EndIf

				If StringLen($Base) = 3 Then
					If StringIsAlpha(GUICtrlRead($Letter)) Then
						If StringInStr($Base, GUICtrlRead($Letter)) Then
							If GUICtrlRead($Space1Letter) = "" Then
								$Trim = StringTrimRight($Base, 2)
								If $Trim = GUICtrlRead($Letter) Then
									GUICtrlSetData($Space1Letter, $Trim)
									$SpacesLeft = $SpacesLeft - 1
									If $SpacesLeft = 0 Then Winner()
								EndIf
							EndIf
							If GUICtrlRead($Space2Letter) = "" Then
								$LeftSide = StringTrimLeft($Base, 1)
								$RightSide = StringTrimRight($LeftSide, 1)
								If $RightSide = GUICtrlRead($Letter) Then
									GUICtrlSetData($Space2Letter, GUICtrlRead($Letter))
									$SpacesLeft = $SpacesLeft - 1
									If $SpacesLeft = 0 Then Winner()
								EndIf
							EndIf
							If GUICtrlRead($Space3Letter) = "" Then
								$LeftSide = StringTrimLeft($Base, 2)
								If $LeftSide = GUICtrlRead($Letter) Then
									GUICtrlSetData($Space3Letter, GUICtrlRead($Letter))
									$SpacesLeft = $SpacesLeft - 1
									If $SpacesLeft = 0 Then Winner()
								EndIf
							EndIf
						Else
							If StringInStr(GUICtrlRead($LettersUsed), GUICtrlRead($Letter)) = 0 Then
								GUICtrlSetData($MistakeMeter, GUICtrlRead($MistakeMeter) + 17)
								GUICtrlSetData($LettersUsed, GUICtrlRead($LettersUsed) & GUICtrlRead($Letter))
							EndIf
						EndIf
						GUICtrlSetData($Letter, "")
					EndIf
				EndIf

				If StringLen($Base) = 4 Then
					If StringIsAlpha(GUICtrlRead($Letter)) Then
						If StringInStr($Base, GUICtrlRead($Letter)) Then
							If GUICtrlRead($Space1Letter) = "" Then
								$Trim = StringTrimRight($Base, 3)
								If $Trim = GUICtrlRead($Letter) Then
									GUICtrlSetData($Space1Letter, $Trim)
									$SpacesLeft = $SpacesLeft - 1
									If $SpacesLeft = 0 Then Winner()
								EndIf
							EndIf
							If GUICtrlRead($Space2Letter) = "" Then
								$LeftSide = StringTrimLeft($Base, 1)
								$RightSide = StringTrimRight($LeftSide, 2)
								If $RightSide = GUICtrlRead($Letter) Then
									GUICtrlSetData($Space2Letter, GUICtrlRead($Letter))
									$SpacesLeft = $SpacesLeft - 1
									If $SpacesLeft = 0 Then Winner()
								EndIf
							EndIf
							If GUICtrlRead($Space3Letter) = "" Then
								$LeftSide = StringTrimLeft($Base, 2)
								$RightSide = StringTrimRight($LeftSide, 1)
								If $RightSide = GUICtrlRead($Letter) Then
									GUICtrlSetData($Space3Letter, GUICtrlRead($Letter))
									$SpacesLeft = $SpacesLeft - 1
									If $SpacesLeft = 0 Then Winner()
								EndIf
							EndIf
							If GUICtrlRead($Space4Letter) = "" Then
								$LeftSide = StringTrimLeft($Base, 3)
								If $LeftSide = GUICtrlRead($Letter) Then
									GUICtrlSetData($Space4Letter, GUICtrlRead($Letter))
									$SpacesLeft = $SpacesLeft - 1
									If $SpacesLeft = 0 Then Winner()
								EndIf
							EndIf
						Else
							If StringInStr(GUICtrlRead($LettersUsed), GUICtrlRead($Letter)) = 0 Then
								GUICtrlSetData($MistakeMeter, GUICtrlRead($MistakeMeter) + 17)
								GUICtrlSetData($LettersUsed, GUICtrlRead($LettersUsed) & GUICtrlRead($Letter))

							EndIf
						EndIf
						GUICtrlSetData($Letter, "")
					EndIf
				EndIf

				If StringLen($Base) = 5 Then
					If StringIsAlpha(GUICtrlRead($Letter)) Then
						If StringInStr($Base, GUICtrlRead($Letter)) Then
							If GUICtrlRead($Space1Letter) = "" Then
								$Trim = StringTrimRight($Base, 4)
								If $Trim = GUICtrlRead($Letter) Then
									GUICtrlSetData($Space1Letter, $Trim)
									$SpacesLeft = $SpacesLeft - 1
									If $SpacesLeft = 0 Then Winner()
								EndIf
							EndIf
							If GUICtrlRead($Space2Letter) = "" Then
								$LeftSide = StringTrimLeft($Base, 1)
								$RightSide = StringTrimRight($LeftSide, 3)
								If $RightSide = GUICtrlRead($Letter) Then
									GUICtrlSetData($Space2Letter, GUICtrlRead($Letter))
									$SpacesLeft = $SpacesLeft - 1
									If $SpacesLeft = 0 Then Winner()
								EndIf
							EndIf
							If GUICtrlRead($Space3Letter) = "" Then
								$LeftSide = StringTrimLeft($Base, 2)
								$RightSide = StringTrimRight($LeftSide, 2)
								If $RightSide = GUICtrlRead($Letter) Then
									GUICtrlSetData($Space3Letter, GUICtrlRead($Letter))
									$SpacesLeft = $SpacesLeft - 1
									If $SpacesLeft = 0 Then Winner()
								EndIf
							EndIf
							If GUICtrlRead($Space4Letter) = "" Then
								$LeftSide = StringTrimLeft($Base, 3)
								$RightSide = StringTrimRight($LeftSide, 1)
								If $RightSide = GUICtrlRead($Letter) Then
									GUICtrlSetData($Space4Letter, GUICtrlRead($Letter))
									$SpacesLeft = $SpacesLeft - 1
									If $SpacesLeft = 0 Then Winner()
								EndIf
							EndIf
							If GUICtrlRead($Space5Letter) = "" Then
								$LeftSide = StringTrimLeft($Base, 4)
								If $LeftSide = GUICtrlRead($Letter) Then
									GUICtrlSetData($Space5Letter, GUICtrlRead($Letter))
									$SpacesLeft = $SpacesLeft - 1
									If $SpacesLeft = 0 Then Winner()
								EndIf
							EndIf
						Else
							If StringInStr(GUICtrlRead($LettersUsed), GUICtrlRead($Letter)) = 0 Then
								GUICtrlSetData($MistakeMeter, GUICtrlRead($MistakeMeter) + 17)
								GUICtrlSetData($LettersUsed, GUICtrlRead($LettersUsed) & GUICtrlRead($Letter))

							EndIf
						EndIf
						GUICtrlSetData($Letter, "")
					EndIf
				EndIf

				If StringLen($Base) = 6 Then
					If StringIsAlpha(GUICtrlRead($Letter)) Then
						If StringInStr($Base, GUICtrlRead($Letter)) Then
							If GUICtrlRead($Space1Letter) = "" Then
								$Trim = StringTrimRight($Base, 5)
								If $Trim = GUICtrlRead($Letter) Then
									GUICtrlSetData($Space1Letter, $Trim)
									$SpacesLeft = $SpacesLeft - 1
									If $SpacesLeft = 0 Then Winner()
								EndIf
							EndIf
							If GUICtrlRead($Space2Letter) = "" Then
								$LeftSide = StringTrimLeft($Base, 1)
								$RightSide = StringTrimRight($LeftSide, 4)
								If $RightSide = GUICtrlRead($Letter) Then
									GUICtrlSetData($Space2Letter, GUICtrlRead($Letter))
									$SpacesLeft = $SpacesLeft - 1
									If $SpacesLeft = 0 Then Winner()
								EndIf
							EndIf
							If GUICtrlRead($Space3Letter) = "" Then
								$LeftSide = StringTrimLeft($Base, 2)
								$RightSide = StringTrimRight($LeftSide, 3)
								If $RightSide = GUICtrlRead($Letter) Then
									GUICtrlSetData($Space3Letter, GUICtrlRead($Letter))
									$SpacesLeft = $SpacesLeft - 1
									If $SpacesLeft = 0 Then Winner()
								EndIf
							EndIf
							If GUICtrlRead($Space4Letter) = "" Then
								$LeftSide = StringTrimLeft($Base, 3)
								$RightSide = StringTrimRight($LeftSide, 2)
								If $RightSide = GUICtrlRead($Letter) Then
									GUICtrlSetData($Space4Letter, GUICtrlRead($Letter))
									$SpacesLeft = $SpacesLeft - 1
									If $SpacesLeft = 0 Then Winner()
								EndIf
							EndIf
							If GUICtrlRead($Space5Letter) = "" Then
								$LeftSide = StringTrimLeft($Base, 4)
								$RightSide = StringTrimRight($LeftSide, 1)
								If $RightSide = GUICtrlRead($Letter) Then
									GUICtrlSetData($Space5Letter, GUICtrlRead($Letter))
									$SpacesLeft = $SpacesLeft - 1
									If $SpacesLeft = 0 Then Winner()
								EndIf
							EndIf
							If GUICtrlRead($Space6Letter) = "" Then
								$LeftSide = StringTrimLeft($Base, 5)
								If $LeftSide = GUICtrlRead($Letter) Then
									GUICtrlSetData($Space6Letter, GUICtrlRead($Letter))
									$SpacesLeft = $SpacesLeft - 1
									If $SpacesLeft = 0 Then Winner()
								EndIf
							EndIf
						Else
							If StringInStr(GUICtrlRead($LettersUsed), GUICtrlRead($Letter)) = 0 Then
								GUICtrlSetData($MistakeMeter, GUICtrlRead($MistakeMeter) + 17)
								GUICtrlSetData($LettersUsed, GUICtrlRead($LettersUsed) & GUICtrlRead($Letter))

							EndIf
						EndIf
						GUICtrlSetData($Letter, "")
					EndIf
				EndIf

				If StringLen($Base) = 7 Then
					If StringIsAlpha(GUICtrlRead($Letter)) Then
						If StringInStr($Base, GUICtrlRead($Letter)) Then
							If GUICtrlRead($Space1Letter) = "" Then
								$Trim = StringTrimRight($Base, 6)
								If $Trim = GUICtrlRead($Letter) Then
									GUICtrlSetData($Space1Letter, $Trim)
									$SpacesLeft = $SpacesLeft - 1
									If $SpacesLeft = 0 Then Winner()
								EndIf
							EndIf
							If GUICtrlRead($Space2Letter) = "" Then
								$LeftSide = StringTrimLeft($Base, 1)
								$RightSide = StringTrimRight($LeftSide, 5)
								If $RightSide = GUICtrlRead($Letter) Then
									GUICtrlSetData($Space2Letter, GUICtrlRead($Letter))
									$SpacesLeft = $SpacesLeft - 1
									If $SpacesLeft = 0 Then Winner()
								EndIf
							EndIf
							If GUICtrlRead($Space3Letter) = "" Then
								$LeftSide = StringTrimLeft($Base, 2)
								$RightSide = StringTrimRight($LeftSide, 4)
								If $RightSide = GUICtrlRead($Letter) Then
									GUICtrlSetData($Space3Letter, GUICtrlRead($Letter))
									$SpacesLeft = $SpacesLeft - 1
									If $SpacesLeft = 0 Then Winner()
								EndIf
							EndIf
							If GUICtrlRead($Space4Letter) = "" Then
								$LeftSide = StringTrimLeft($Base, 3)
								$RightSide = StringTrimRight($LeftSide, 3)
								If $RightSide = GUICtrlRead($Letter) Then
									GUICtrlSetData($Space4Letter, GUICtrlRead($Letter))
									$SpacesLeft = $SpacesLeft - 1
									If $SpacesLeft = 0 Then Winner()
								EndIf
							EndIf
							If GUICtrlRead($Space5Letter) = "" Then
								$LeftSide = StringTrimLeft($Base, 4)
								$RightSide = StringTrimRight($LeftSide, 2)
								If $RightSide = GUICtrlRead($Letter) Then
									GUICtrlSetData($Space5Letter, GUICtrlRead($Letter))
									$SpacesLeft = $SpacesLeft - 1
									If $SpacesLeft = 0 Then Winner()
								EndIf
							EndIf
							If GUICtrlRead($Space6Letter) = "" Then
								$LeftSide = StringTrimLeft($Base, 5)
								$RightSide = StringTrimRight($LeftSide, 1)
								If $RightSide = GUICtrlRead($Letter) Then
									GUICtrlSetData($Space6Letter, GUICtrlRead($Letter))
									$SpacesLeft = $SpacesLeft - 1
									If $SpacesLeft = 0 Then Winner()
								EndIf
							EndIf
							If GUICtrlRead($Space7Letter) = "" Then
								$LeftSide = StringTrimLeft($Base, 6)
								If $LeftSide = GUICtrlRead($Letter) Then
									GUICtrlSetData($Space7Letter, GUICtrlRead($Letter))
									$SpacesLeft = $SpacesLeft - 1
									If $SpacesLeft = 0 Then Winner()
								EndIf
							EndIf
						Else
							If StringInStr(GUICtrlRead($LettersUsed), GUICtrlRead($Letter)) = 0 Then
								GUICtrlSetData($MistakeMeter, GUICtrlRead($MistakeMeter) + 17)
								GUICtrlSetData($LettersUsed, GUICtrlRead($LettersUsed) & GUICtrlRead($Letter))

							EndIf
						EndIf
						GUICtrlSetData($Letter, "")
					EndIf
				EndIf

				If StringLen($Base) = 8 Then
					If StringIsAlpha(GUICtrlRead($Letter)) Then
						If StringInStr($Base, GUICtrlRead($Letter)) Then
							If GUICtrlRead($Space1Letter) = "" Then
								$Trim = StringTrimRight($Base, 7)
								If $Trim = GUICtrlRead($Letter) Then
									GUICtrlSetData($Space1Letter, $Trim)
									$SpacesLeft = $SpacesLeft - 1
									If $SpacesLeft = 0 Then Winner()
								EndIf
							EndIf
							If GUICtrlRead($Space2Letter) = "" Then
								$LeftSide = StringTrimLeft($Base, 1)
								$RightSide = StringTrimRight($LeftSide, 6)
								If $RightSide = GUICtrlRead($Letter) Then
									GUICtrlSetData($Space2Letter, GUICtrlRead($Letter))
									$SpacesLeft = $SpacesLeft - 1
									If $SpacesLeft = 0 Then Winner()
								EndIf
							EndIf
							If GUICtrlRead($Space3Letter) = "" Then
								$LeftSide = StringTrimLeft($Base, 2)
								$RightSide = StringTrimRight($LeftSide, 5)
								If $RightSide = GUICtrlRead($Letter) Then
									GUICtrlSetData($Space3Letter, GUICtrlRead($Letter))
									$SpacesLeft = $SpacesLeft - 1
									If $SpacesLeft = 0 Then Winner()
								EndIf
							EndIf
							If GUICtrlRead($Space4Letter) = "" Then
								$LeftSide = StringTrimLeft($Base, 3)
								$RightSide = StringTrimRight($LeftSide, 4)
								If $RightSide = GUICtrlRead($Letter) Then
									GUICtrlSetData($Space4Letter, GUICtrlRead($Letter))
									$SpacesLeft = $SpacesLeft - 1
									If $SpacesLeft = 0 Then Winner()
								EndIf
							EndIf
							If GUICtrlRead($Space5Letter) = "" Then
								$LeftSide = StringTrimLeft($Base, 4)
								$RightSide = StringTrimRight($LeftSide, 3)
								If $RightSide = GUICtrlRead($Letter) Then
									GUICtrlSetData($Space5Letter, GUICtrlRead($Letter))
									$SpacesLeft = $SpacesLeft - 1
									If $SpacesLeft = 0 Then Winner()
								EndIf
							EndIf
							If GUICtrlRead($Space6Letter) = "" Then
								$LeftSide = StringTrimLeft($Base, 5)
								$RightSide = StringTrimRight($LeftSide, 2)
								If $RightSide = GUICtrlRead($Letter) Then
									GUICtrlSetData($Space6Letter, GUICtrlRead($Letter))
									$SpacesLeft = $SpacesLeft - 1
									If $SpacesLeft = 0 Then Winner()
								EndIf
							EndIf
							If GUICtrlRead($Space7Letter) = "" Then
								$LeftSide = StringTrimLeft($Base, 6)
								$RightSide = StringTrimRight($LeftSide, 1)
								If $RightSide = GUICtrlRead($Letter) Then
									GUICtrlSetData($Space7Letter, GUICtrlRead($Letter))
									$SpacesLeft = $SpacesLeft - 1
									If $SpacesLeft = 0 Then Winner()
								EndIf
							EndIf
							If GUICtrlRead($Space8Letter) = "" Then
								$LeftSide = StringTrimLeft($Base, 7)
								If $LeftSide = GUICtrlRead($Letter) Then
									GUICtrlSetData($Space8Letter, GUICtrlRead($Letter))
									$SpacesLeft = $SpacesLeft - 1
									If $SpacesLeft = 0 Then Winner()
								EndIf
							EndIf
						Else
							If StringInStr(GUICtrlRead($LettersUsed), GUICtrlRead($Letter)) = 0 Then
								GUICtrlSetData($MistakeMeter, GUICtrlRead($MistakeMeter) + 17)
								GUICtrlSetData($LettersUsed, GUICtrlRead($LettersUsed) & GUICtrlRead($Letter))

							EndIf
						EndIf
						GUICtrlSetData($Letter, "")
					EndIf
				EndIf

				If StringLen($Base) = 9 Then
					If StringIsAlpha(GUICtrlRead($Letter)) Then
						If StringInStr($Base, GUICtrlRead($Letter)) Then
							If GUICtrlRead($Space1Letter) = "" Then
								$Trim = StringTrimRight($Base, 8)
								If $Trim = GUICtrlRead($Letter) Then
									GUICtrlSetData($Space1Letter, $Trim)
									$SpacesLeft = $SpacesLeft - 1
									If $SpacesLeft = 0 Then Winner()
								EndIf
							EndIf
							If GUICtrlRead($Space2Letter) = "" Then
								$LeftSide = StringTrimLeft($Base, 1)
								$RightSide = StringTrimRight($LeftSide, 7)
								If $RightSide = GUICtrlRead($Letter) Then
									GUICtrlSetData($Space2Letter, GUICtrlRead($Letter))
									$SpacesLeft = $SpacesLeft - 1
									If $SpacesLeft = 0 Then Winner()
								EndIf
							EndIf
							If GUICtrlRead($Space3Letter) = "" Then
								$LeftSide = StringTrimLeft($Base, 2)
								$RightSide = StringTrimRight($LeftSide, 6)
								If $RightSide = GUICtrlRead($Letter) Then
									GUICtrlSetData($Space3Letter, GUICtrlRead($Letter))
									$SpacesLeft = $SpacesLeft - 1
									If $SpacesLeft = 0 Then Winner()
								EndIf
							EndIf
							If GUICtrlRead($Space4Letter) = "" Then
								$LeftSide = StringTrimLeft($Base, 3)
								$RightSide = StringTrimRight($LeftSide, 5)
								If $RightSide = GUICtrlRead($Letter) Then
									GUICtrlSetData($Space4Letter, GUICtrlRead($Letter))
									$SpacesLeft = $SpacesLeft - 1
									If $SpacesLeft = 0 Then Winner()
								EndIf
							EndIf
							If GUICtrlRead($Space5Letter) = "" Then
								$LeftSide = StringTrimLeft($Base, 4)
								$RightSide = StringTrimRight($LeftSide, 4)
								If $RightSide = GUICtrlRead($Letter) Then
									GUICtrlSetData($Space5Letter, GUICtrlRead($Letter))
									$SpacesLeft = $SpacesLeft - 1
									If $SpacesLeft = 0 Then Winner()
								EndIf
							EndIf
							If GUICtrlRead($Space6Letter) = "" Then
								$LeftSide = StringTrimLeft($Base, 5)
								$RightSide = StringTrimRight($LeftSide, 3)
								If $RightSide = GUICtrlRead($Letter) Then
									GUICtrlSetData($Space6Letter, GUICtrlRead($Letter))
									$SpacesLeft = $SpacesLeft - 1
									If $SpacesLeft = 0 Then Winner()
								EndIf
							EndIf
							If GUICtrlRead($Space7Letter) = "" Then
								$LeftSide = StringTrimLeft($Base, 6)
								$RightSide = StringTrimRight($LeftSide, 2)
								If $RightSide = GUICtrlRead($Letter) Then
									GUICtrlSetData($Space7Letter, GUICtrlRead($Letter))
									$SpacesLeft = $SpacesLeft - 1
									If $SpacesLeft = 0 Then Winner()
								EndIf
							EndIf
							If GUICtrlRead($Space8Letter) = "" Then
								$LeftSide = StringTrimLeft($Base, 7)
								$RightSide = StringTrimRight($LeftSide, 1)
								If $RightSide = GUICtrlRead($Letter) Then
									GUICtrlSetData($Space8Letter, GUICtrlRead($Letter))
									$SpacesLeft = $SpacesLeft - 1
									If $SpacesLeft = 0 Then Winner()
								EndIf
							EndIf
							If GUICtrlRead($Space9Letter) = "" Then
								$LeftSide = StringTrimLeft($Base, 8)
								If $LeftSide = GUICtrlRead($Letter) Then
									GUICtrlSetData($Space9Letter, GUICtrlRead($Letter))
									$SpacesLeft = $SpacesLeft - 1
									If $SpacesLeft = 0 Then Winner()
								EndIf
							EndIf
						Else
							If StringInStr(GUICtrlRead($LettersUsed), GUICtrlRead($Letter)) = 0 Then
								GUICtrlSetData($MistakeMeter, GUICtrlRead($MistakeMeter) + 17)
								GUICtrlSetData($LettersUsed, GUICtrlRead($LettersUsed) & GUICtrlRead($Letter))

							EndIf
						EndIf
						GUICtrlSetData($Letter, "")
					EndIf
				EndIf

				If StringLen($Base) = 10 Then
					If StringIsAlpha(GUICtrlRead($Letter)) Then
						If StringInStr($Base, GUICtrlRead($Letter)) Then
							If GUICtrlRead($Space1Letter) = "" Then
								$Trim = StringTrimRight($Base, 9)
								If $Trim = GUICtrlRead($Letter) Then
									GUICtrlSetData($Space1Letter, $Trim)
									$SpacesLeft = $SpacesLeft - 1
									If $SpacesLeft = 0 Then Winner()
								EndIf
							EndIf
							If GUICtrlRead($Space2Letter) = "" Then
								$LeftSide = StringTrimLeft($Base, 1)
								$RightSide = StringTrimRight($LeftSide, 8)
								If $RightSide = GUICtrlRead($Letter) Then
									GUICtrlSetData($Space2Letter, GUICtrlRead($Letter))
									$SpacesLeft = $SpacesLeft - 1
									If $SpacesLeft = 0 Then Winner()
								EndIf
							EndIf
							If GUICtrlRead($Space3Letter) = "" Then
								$LeftSide = StringTrimLeft($Base, 2)
								$RightSide = StringTrimRight($LeftSide, 7)
								If $RightSide = GUICtrlRead($Letter) Then
									GUICtrlSetData($Space3Letter, GUICtrlRead($Letter))
									$SpacesLeft = $SpacesLeft - 1
									If $SpacesLeft = 0 Then Winner()
								EndIf
							EndIf
							If GUICtrlRead($Space4Letter) = "" Then
								$LeftSide = StringTrimLeft($Base, 3)
								$RightSide = StringTrimRight($LeftSide, 6)
								If $RightSide = GUICtrlRead($Letter) Then
									GUICtrlSetData($Space4Letter, GUICtrlRead($Letter))
									$SpacesLeft = $SpacesLeft - 1
									If $SpacesLeft = 0 Then Winner()
								EndIf
							EndIf
							If GUICtrlRead($Space5Letter) = "" Then
								$LeftSide = StringTrimLeft($Base, 4)
								$RightSide = StringTrimRight($LeftSide, 5)
								If $RightSide = GUICtrlRead($Letter) Then
									GUICtrlSetData($Space5Letter, GUICtrlRead($Letter))
									$SpacesLeft = $SpacesLeft - 1
									If $SpacesLeft = 0 Then Winner()
								EndIf
							EndIf
							If GUICtrlRead($Space6Letter) = "" Then
								$LeftSide = StringTrimLeft($Base, 5)
								$RightSide = StringTrimRight($LeftSide, 4)
								If $RightSide = GUICtrlRead($Letter) Then
									GUICtrlSetData($Space6Letter, GUICtrlRead($Letter))
									$SpacesLeft = $SpacesLeft - 1
									If $SpacesLeft = 0 Then Winner()
								EndIf
							EndIf
							If GUICtrlRead($Space7Letter) = "" Then
								$LeftSide = StringTrimLeft($Base, 6)
								$RightSide = StringTrimRight($LeftSide, 3)
								If $RightSide = GUICtrlRead($Letter) Then
									GUICtrlSetData($Space7Letter, GUICtrlRead($Letter))
									$SpacesLeft = $SpacesLeft - 1
									If $SpacesLeft = 0 Then Winner()
								EndIf
							EndIf
							If GUICtrlRead($Space8Letter) = "" Then
								$LeftSide = StringTrimLeft($Base, 7)
								$RightSide = StringTrimRight($LeftSide, 2)
								If $RightSide = GUICtrlRead($Letter) Then
									GUICtrlSetData($Space8Letter, GUICtrlRead($Letter))
									$SpacesLeft = $SpacesLeft - 1
									If $SpacesLeft = 0 Then Winner()
								EndIf
							EndIf
							If GUICtrlRead($Space9Letter) = "" Then
								$LeftSide = StringTrimLeft($Base, 8)
								$RightSide = StringTrimRight($LeftSide, 1)
								If $RightSide = GUICtrlRead($Letter) Then
									GUICtrlSetData($Space9Letter, GUICtrlRead($Letter))
									$SpacesLeft = $SpacesLeft - 1
									If $SpacesLeft = 0 Then Winner()
								EndIf
							EndIf
							If GUICtrlRead($Space10Letter) = "" Then
								$LeftSide = StringTrimLeft($Base, 9)
								If $LeftSide = GUICtrlRead($Letter) Then
									GUICtrlSetData($Space10Letter, GUICtrlRead($Letter))
									$SpacesLeft = $SpacesLeft - 1
									If $SpacesLeft = 0 Then Winner()
								EndIf
							EndIf
						Else
							If StringInStr(GUICtrlRead($LettersUsed), GUICtrlRead($Letter)) = 0 Then
								GUICtrlSetData($MistakeMeter, GUICtrlRead($MistakeMeter) + 17)
								GUICtrlSetData($LettersUsed, GUICtrlRead($LettersUsed) & GUICtrlRead($Letter))

							EndIf
						EndIf
						GUICtrlSetData($Letter, "")
					EndIf
				EndIf

				If StringLen($Base) = 11 Then
					If StringIsAlpha(GUICtrlRead($Letter)) Then
						If StringInStr($Base, GUICtrlRead($Letter)) Then
							If GUICtrlRead($Space1Letter) = "" Then
								$Trim = StringTrimRight($Base, 10)
								If $Trim = GUICtrlRead($Letter) Then
									GUICtrlSetData($Space1Letter, $Trim)
									$SpacesLeft = $SpacesLeft - 1
									If $SpacesLeft = 0 Then Winner()
								EndIf
							EndIf
							If GUICtrlRead($Space2Letter) = "" Then
								$LeftSide = StringTrimLeft($Base, 1)
								$RightSide = StringTrimRight($LeftSide, 9)
								If $RightSide = GUICtrlRead($Letter) Then
									GUICtrlSetData($Space2Letter, GUICtrlRead($Letter))
									$SpacesLeft = $SpacesLeft - 1
									If $SpacesLeft = 0 Then Winner()
								EndIf
							EndIf
							If GUICtrlRead($Space3Letter) = "" Then
								$LeftSide = StringTrimLeft($Base, 2)
								$RightSide = StringTrimRight($LeftSide, 8)
								If $RightSide = GUICtrlRead($Letter) Then
									GUICtrlSetData($Space3Letter, GUICtrlRead($Letter))
									$SpacesLeft = $SpacesLeft - 1
									If $SpacesLeft = 0 Then Winner()
								EndIf
							EndIf
							If GUICtrlRead($Space4Letter) = "" Then
								$LeftSide = StringTrimLeft($Base, 3)
								$RightSide = StringTrimRight($LeftSide, 7)
								If $RightSide = GUICtrlRead($Letter) Then
									GUICtrlSetData($Space4Letter, GUICtrlRead($Letter))
									$SpacesLeft = $SpacesLeft - 1
									If $SpacesLeft = 0 Then Winner()
								EndIf
							EndIf
							If GUICtrlRead($Space5Letter) = "" Then
								$LeftSide = StringTrimLeft($Base, 4)
								$RightSide = StringTrimRight($LeftSide, 6)
								If $RightSide = GUICtrlRead($Letter) Then
									GUICtrlSetData($Space5Letter, GUICtrlRead($Letter))
									$SpacesLeft = $SpacesLeft - 1
									If $SpacesLeft = 0 Then Winner()
								EndIf
							EndIf
							If GUICtrlRead($Space6Letter) = "" Then
								$LeftSide = StringTrimLeft($Base, 5)
								$RightSide = StringTrimRight($LeftSide, 5)
								If $RightSide = GUICtrlRead($Letter) Then
									GUICtrlSetData($Space6Letter, GUICtrlRead($Letter))
									$SpacesLeft = $SpacesLeft - 1
									If $SpacesLeft = 0 Then Winner()
								EndIf
							EndIf
							If GUICtrlRead($Space7Letter) = "" Then
								$LeftSide = StringTrimLeft($Base, 6)
								$RightSide = StringTrimRight($LeftSide, 4)
								If $RightSide = GUICtrlRead($Letter) Then
									GUICtrlSetData($Space7Letter, GUICtrlRead($Letter))
									$SpacesLeft = $SpacesLeft - 1
									If $SpacesLeft = 0 Then Winner()
								EndIf
							EndIf
							If GUICtrlRead($Space8Letter) = "" Then
								$LeftSide = StringTrimLeft($Base, 7)
								$RightSide = StringTrimRight($LeftSide, 3)
								If $RightSide = GUICtrlRead($Letter) Then
									GUICtrlSetData($Space8Letter, GUICtrlRead($Letter))
									$SpacesLeft = $SpacesLeft - 1
									If $SpacesLeft = 0 Then Winner()
								EndIf
							EndIf
							If GUICtrlRead($Space9Letter) = "" Then
								$LeftSide = StringTrimLeft($Base, 8)
								$RightSide = StringTrimRight($LeftSide, 2)
								If $RightSide = GUICtrlRead($Letter) Then
									GUICtrlSetData($Space9Letter, GUICtrlRead($Letter))
									$SpacesLeft = $SpacesLeft - 1
									If $SpacesLeft = 0 Then Winner()
								EndIf
							EndIf
							If GUICtrlRead($Space10Letter) = "" Then
								$LeftSide = StringTrimLeft($Base, 9)
								$RightSide = StringTrimRight($LeftSide, 1)
								If $RightSide = GUICtrlRead($Letter) Then
									GUICtrlSetData($Space10Letter, GUICtrlRead($Letter))
									$SpacesLeft = $SpacesLeft - 1
									If $SpacesLeft = 0 Then Winner()
								EndIf
							EndIf
							If GUICtrlRead($Space11Letter) = "" Then
								$LeftSide = StringTrimLeft($Base, 10)
								If $LeftSide = GUICtrlRead($Letter) Then
									GUICtrlSetData($Space11Letter, GUICtrlRead($Letter))
									$SpacesLeft = $SpacesLeft - 1
									If $SpacesLeft = 0 Then Winner()
								EndIf
							EndIf
						Else
							If StringInStr(GUICtrlRead($LettersUsed), GUICtrlRead($Letter)) = 0 Then
								GUICtrlSetData($MistakeMeter, GUICtrlRead($MistakeMeter) + 17)
								GUICtrlSetData($LettersUsed, GUICtrlRead($LettersUsed) & GUICtrlRead($Letter))

							EndIf
						EndIf
						GUICtrlSetData($Letter, "")
					EndIf
				EndIf

				If StringLen($Base) = 12 Then
					If StringIsAlpha(GUICtrlRead($Letter)) Then
						If StringInStr($Base, GUICtrlRead($Letter)) Then
							If GUICtrlRead($Space1Letter) = "" Then
								$Trim = StringTrimRight($Base, 11)
								If $Trim = GUICtrlRead($Letter) Then
									GUICtrlSetData($Space1Letter, $Trim)
									$SpacesLeft = $SpacesLeft - 1
									If $SpacesLeft = 0 Then Winner()
								EndIf
							EndIf
							If GUICtrlRead($Space2Letter) = "" Then
								$LeftSide = StringTrimLeft($Base, 1)
								$RightSide = StringTrimRight($LeftSide, 10)
								If $RightSide = GUICtrlRead($Letter) Then
									GUICtrlSetData($Space2Letter, GUICtrlRead($Letter))
									$SpacesLeft = $SpacesLeft - 1
									If $SpacesLeft = 0 Then Winner()
								EndIf
							EndIf
							If GUICtrlRead($Space3Letter) = "" Then
								$LeftSide = StringTrimLeft($Base, 2)
								$RightSide = StringTrimRight($LeftSide, 9)
								If $RightSide = GUICtrlRead($Letter) Then
									GUICtrlSetData($Space3Letter, GUICtrlRead($Letter))
									$SpacesLeft = $SpacesLeft - 1
									If $SpacesLeft = 0 Then Winner()
								EndIf
							EndIf
							If GUICtrlRead($Space4Letter) = "" Then
								$LeftSide = StringTrimLeft($Base, 3)
								$RightSide = StringTrimRight($LeftSide, 8)
								If $RightSide = GUICtrlRead($Letter) Then
									GUICtrlSetData($Space4Letter, GUICtrlRead($Letter))
									$SpacesLeft = $SpacesLeft - 1
									If $SpacesLeft = 0 Then Winner()
								EndIf
							EndIf
							If GUICtrlRead($Space5Letter) = "" Then
								$LeftSide = StringTrimLeft($Base, 4)
								$RightSide = StringTrimRight($LeftSide, 7)
								If $RightSide = GUICtrlRead($Letter) Then
									GUICtrlSetData($Space5Letter, GUICtrlRead($Letter))
									$SpacesLeft = $SpacesLeft - 1
									If $SpacesLeft = 0 Then Winner()
								EndIf
							EndIf
							If GUICtrlRead($Space6Letter) = "" Then
								$LeftSide = StringTrimLeft($Base, 5)
								$RightSide = StringTrimRight($LeftSide, 6)
								If $RightSide = GUICtrlRead($Letter) Then
									GUICtrlSetData($Space6Letter, GUICtrlRead($Letter))
									$SpacesLeft = $SpacesLeft - 1
									If $SpacesLeft = 0 Then Winner()
								EndIf
							EndIf
							If GUICtrlRead($Space7Letter) = "" Then
								$LeftSide = StringTrimLeft($Base, 6)
								$RightSide = StringTrimRight($LeftSide, 5)
								If $RightSide = GUICtrlRead($Letter) Then
									GUICtrlSetData($Space7Letter, GUICtrlRead($Letter))
									$SpacesLeft = $SpacesLeft - 1
									If $SpacesLeft = 0 Then Winner()
								EndIf
							EndIf
							If GUICtrlRead($Space8Letter) = "" Then
								$LeftSide = StringTrimLeft($Base, 7)
								$RightSide = StringTrimRight($LeftSide, 4)
								If $RightSide = GUICtrlRead($Letter) Then
									GUICtrlSetData($Space8Letter, GUICtrlRead($Letter))
									$SpacesLeft = $SpacesLeft - 1
									If $SpacesLeft = 0 Then Winner()
								EndIf
							EndIf
							If GUICtrlRead($Space9Letter) = "" Then
								$LeftSide = StringTrimLeft($Base, 8)
								$RightSide = StringTrimRight($LeftSide, 3)
								If $RightSide = GUICtrlRead($Letter) Then
									GUICtrlSetData($Space9Letter, GUICtrlRead($Letter))
									$SpacesLeft = $SpacesLeft - 1
									If $SpacesLeft = 0 Then Winner()
								EndIf
							EndIf
							If GUICtrlRead($Space10Letter) = "" Then
								$LeftSide = StringTrimLeft($Base, 9)
								$RightSide = StringTrimRight($LeftSide, 2)
								If $RightSide = GUICtrlRead($Letter) Then
									GUICtrlSetData($Space10Letter, GUICtrlRead($Letter))
									$SpacesLeft = $SpacesLeft - 1
									If $SpacesLeft = 0 Then Winner()
								EndIf
							EndIf
							If GUICtrlRead($Space11Letter) = "" Then
								$LeftSide = StringTrimLeft($Base, 10)
								$RightSide = StringTrimRight($LeftSide, 1)
								If $RightSide = GUICtrlRead($Letter) Then
									GUICtrlSetData($Space11Letter, GUICtrlRead($Letter))
									$SpacesLeft = $SpacesLeft - 1
									If $SpacesLeft = 0 Then Winner()
								EndIf
							EndIf
							If GUICtrlRead($Space12Letter) = "" Then
								$LeftSide = StringTrimLeft($Base, 11)
								If $LeftSide = GUICtrlRead($Letter) Then
									GUICtrlSetData($Space12Letter, GUICtrlRead($Letter))
									$SpacesLeft = $SpacesLeft - 1
									If $SpacesLeft = 0 Then Winner()
								EndIf
							EndIf
						Else
							If StringInStr(GUICtrlRead($LettersUsed), GUICtrlRead($Letter)) = 0 Then
								GUICtrlSetData($MistakeMeter, GUICtrlRead($MistakeMeter) + 17)
								GUICtrlSetData($LettersUsed, GUICtrlRead($LettersUsed) & GUICtrlRead($Letter))

							EndIf
						EndIf
						GUICtrlSetData($Letter, "")
					EndIf
				EndIf
				ControlClick("", "", $Letter)
				If GUICtrlRead($MistakeMeter) = 100 Then
					GUICtrlSetState($Guess, $GUI_DISABLE)
					GUICtrlSetState($NewGame, $GUI_DISABLE)
					GUICtrlSetState($Solve, $GUI_DISABLE)
					Sleep(1000)
					MsgBox(0, "You Lost!", 'You Didnt get the Word. It Was "' & $Base & '".')
					GUIDelete()
					NewGame()
				EndIf
			Case $Solve
				$WordGuess = InputBox("Solve Word", "Think You Got it? Enter the Word you Think It Is...", "", "", 200, 200)
				If Not @error Then
					If $WordGuess = $Base Then
						Winner()
					Else
						Sleep(1000)
						MsgBox(0, "Aww Man!", 'You Didnt Get it! It Was "' & $Base & '".')
						GUIDelete()
						NewGame()
					EndIf
				EndIf

		EndSwitch
	WEnd
EndFunc   ;==>WordGuess

Func Winner()

	Sleep(1000)
	MsgBox(0, "Winner!", "You Got the Word!")
	GUIDelete()
	NewGame()

EndFunc   ;==>Winner



