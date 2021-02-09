#cs ----------------------------------------------------------------------------

	AutoIt Version: 3.3.6.1
	Author:         WeaponX

	Script Function:
	Checkers

	Script Version:
	Beta 7

	7/20/10 - Beta 7
	-Allow human player to opt out of making multiple jumps after first jump
	-Reworked Setup GUI with new options
	-Added new fields to Main GUI and modified colors to make them more readable
	-Initial work for "AI Battle Mode"
	-Animate movement of pieces for 'slide' effect
	-Removed flicker during board setup
	-Added blink to turn indicator
	-Convert End-of-Game popups to label

	2/24/09 - Beta 6
	-Fixed win checking, "no moves found" bug for last enemy piece
	-Updated theme for Survival Mode
	-Added setup option for showing move hints
	-Selected piece is now marked with an indicator

	2/20/09 - Beta 5
	-Fixed so enemy will always jump if possible
	-Removed RandomMovePiece() function
	-Changed moves array from 3 dimensions to 2
	-Added survival mode (Left 4 Dead Mode)
	-Slowed down CPU moves for visibility

	2/17/09 - Beta 4
	-Selected piece can be changed if a jump hasn't been performed
	-Removed Skip option
	-New interface design
	-Added move counter
	-Added longest jump record
	-Optimized movement to reduce flickering

	2/6/09 - Beta 3
	- Updated for v3.3.0.0 compatibility
	- Added setup gui to for choosing player type
	- Cleaned up variable names

	11/20/07 - Beta 2
	- Possible moves are found recursively, allowing for up to 9 jumps
	- No AI added yet

#ce ----------------------------------------------------------------------------

#include <Array.au3>
;#include <ComboConstants.au3>
#include <File.au3>
#include <GUIComboBox.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <ButtonConstants.au3>

; #CONSTANTS# ===================================================================================================================
Global Const $Version = "Beta 7"
Global Const $Board_Rows = 8, $Board_Cols = 8 ;8x8 Standard gameboard size
Global Const $Board_Width = 400, $Board_Height = 400
Global Const $Move_Color = 0x575757, $Stat_Color = 0x404040, $Selected_Color = 0x7CE8FC
Global Const $Board_HCenter = $Board_Width/2
Global Const $Cell_Width = $Board_Width / $Board_Cols, $Cell_Height = $Board_Height / $Board_Rows
Global Const $Font_Labels = "Arial", $Font_Pieces = "Wingdings"

; #GLOBALS# ===================================================================================================================
Global $GUI_Main, $GUI_EOG
Global $Turn_Delay = 300
Global $Move_Delay = 600
Global $Board_Color[3] = [0, 0x707070, 0xEEEEEE]
Global $Title = "Checkers: " & $Version

Global $PName[3] = ["", "PLAYER 1", "PLAYER 2"]
Global $PType[3] = [0, 1, 2] ;Player type (1 = Human, 2 = CPU)
Global $PAI[3] = ["", "AI_Standard", "AI_Standard"] ;Player AI

Global $PColor[3] = [0x000000, 0xCC0033, 0x004D99]
Global $PSelectColor[3] = [0, 0x950101, 0x326DA9]
Global $PScore[3][2]  = [[0, 0],[0, 0],[0, 0]] ; player[current game, all games]
Global $PAvgTurnSpeed[3] = [0, 0, 0] ;average turn time
Global $PMaxJumpCount[3] = [0, 0, 0] ;Most jumps in a single move
Global $PMoves[3][2] = [[0, 0],[0, 0],[0, 0]] ; player[current game, all games]
Global $PWins[3] = [0, 0, 0], $Draws

Global $hPScore[3][2] ; player[current game, all games]
Global $hPWins[3], $hDraw
Global $hPAvgTurnSpeed[3]
Global $hPMoves[3][2], $hAvgMoves
Global $hTotalGames
Global $hPIndicator[3], $Blink, $Blink_Delay = 40
Global $Check_Slide, $Check_Hints, $Combo_Games, $GamesPerMatch = 1, $Combo_Delay, $Check_Animate
Global $Animate = 1, $Slide = 1

Global $hAICtrl[5]

Global $Debug = False ;Enable to see full output
Global $Game_Mode = 0 ;(0 = Normal Mode, 1 = Survival Mode)
Global $Move_Symbol = "¥"
Global $MovePending = False, $PiecePending = False
Global $CurrentPlayer = 1 ;Starting player
Global $Piece_Selected[3];X,Y,ControlId
Global $Jump_Count = 0 ;Current move count
Global $Games_Played, $Play_Again, $AI_Battle, $EOG_Label1, $EOG_Label2

;Define 3 DIMENSIONAL ARRAY! *GASP*
;[y][x][0] = Piece control id
;[y][x][1] = Team designation (null, 1, or 2)
;[y][x][2] = King status
Global $aBoard[$Board_Rows][$Board_Cols][3]

;[n][0] = Move X
;[n][1] = Move Y
;[n][2] = Move control id
;[n][3] = Move weight
;[n][4] = Nested moves
Global $aMoves
Global $aPieces ;Clone of $aBoard used to restore pieces back to runtime positions

;===================================================================================================================================
GUI_Setup() ;Not required
GUI_Main()
Func GUI_Main()
	Debug("","GUI_Main()")

	Opt("GUIOnEventMode", 1) ;Switch to OnEvent mode
	$GUI_Main = GUICreate($Title, $Board_Width, $Board_Height + 110) ;Add bottom margin for controls
	GUISetBkColor(0xD0D0D0) ;Black background
	GUICtrlCreateGraphic(0, $Board_Height, $Board_Width, 3)
	GUICtrlSetBkColor(-1, 0x0000FF)
	GUISetOnEvent($GUI_EVENT_CLOSE, "ClickClosed")
	GUISetState(@SW_SHOW)

	; PLAYER 1
	GUICtrlCreateLabel($PName[1], 20, $Board_Height + 10, 70, 15, $SS_CENTER)
	GUICtrlSetColor(-1, $PColor[1])
	GUICtrlSetFont(-1, 10, 400, 0, $Font_Labels)
	;GUICtrlSetBkColor(-1, 0x225577) ;DEBUG ONLY

	$hPIndicator[1] = GUICtrlCreateLabel("«", 90, $Board_Height + 5, 20, 20)
	GUICtrlSetColor(-1, 0x404040) ; dark grey
	GUICtrlSetFont(-1, 14, 600, 0, $Font_Labels)
	;GUICtrlSetBkColor(-1, 0x225577) ;DEBUG ONLY

	$hPMoves[1][0] = GUICtrlCreateLabel("MOVES: 0", 15, $Board_Height + 25, 80, 15, $SS_CENTER)
	GUICtrlSetColor(-1, $PColor[1])
	GUICtrlSetFont(-1, 8, 400, 0, $Font_Labels)

	$hPScore[1][0] = GUICtrlCreateLabel("0", 28, $Board_Height + 35, 50, 30, $SS_CENTER) ; curr game
	GUICtrlSetColor(-1, $PColor[1])
	GUICtrlSetFont(-1, 24, 500, 0, $Font_Labels)
	;GUICtrlSetBkColor(-1, 0x225577) ;DEBUG ONLY

	$hPScore[1][1] = GUICtrlCreateLabel(0, $Board_HCenter-85, $Board_Height + 40, 20, 15, $SS_RIGHT) ; game avg
	GUICtrlSetFont(-1, 8, 400, 0, $Font_Labels)
	;GUICtrlSetBkColor(-1, 0x225577) ;DEBUG ONLY
	GUICtrlSetColor(-1, $PColor[1])

	$hPAvgTurnSpeed[1] = GUICtrlCreateLabel(0, $Board_HCenter-85, $Board_Height + 55, 20, 15, $SS_RIGHT)
	GUICtrlSetFont(-1, 8, 400, 0, $Font_Labels)
	;GUICtrlSetBkColor(-1, 0x225577) ;DEBUG ONLY
	GUICtrlSetColor(-1, $PColor[1])

	$hPWins[1] = GUICtrlCreateLabel("WINS: 0", 15, $Board_Height + 70, 80, 15, $SS_CENTER)
	GUICtrlSetColor(-1, $PColor[1])
	GUICtrlSetFont(-1, 10, 400, 0, $Font_Labels)

	; PLAYER 2
	$Player = 2
	GUICtrlCreateLabel($PName[2], $Board_Width-90, $Board_Height + 10, 70, 15, $SS_CENTER)
	GUICtrlSetColor(-1, $PColor[2])
	GUICtrlSetFont(-1, 10, 400, 0, $Font_Labels)
	;GUICtrlSetBkColor(-1, 0x225577) ;DEBUG ONLY

	$hPIndicator[2] = GUICtrlCreateLabel("»", $Board_Width-110, $Board_Height + 5, 20, 20, $SS_RIGHT)
	Hide($hPIndicator[2])
	GUICtrlSetColor(-1, 0x0404040) ; dark grey
	GUICtrlSetFont(-1, 14, 600, 0, $Font_Labels)
	;GUICtrlSetBkColor(-1, 0x225577) ;DEBUG ONLY

	$hPMoves[2][0] = GUICtrlCreateLabel("MOVES: 0", $Board_Width-95, $Board_Height + 25, 80, 15, $SS_CENTER)
	GUICtrlSetColor(-1, $PColor[2])
	GUICtrlSetFont(-1, 8, 400, 0, $Font_Labels)

	$hPScore[2][0] = GUICtrlCreateLabel("0", $Board_Width-50-32, $Board_Height + 35, 50, 30, $SS_CENTER) ; curr game
	GUICtrlSetColor(-1, $PColor[2])
	GUICtrlSetFont(-1, 24, 400, 0, $Font_Labels)
	;GUICtrlSetBkColor(-1, 0x225577) ;DEBUG ONLY

	$hPScore[2][1] = GUICtrlCreateLabel(0, $Board_HCenter+65, $Board_Height + 40, 20, 15) ;  game avg
	GUICtrlSetFont(-1, 8, 400, 0, $Font_Labels)
	;GUICtrlSetBkColor(-1, 0x225577) ;DEBUG ONLY
	GUICtrlSetColor(-1, $PColor[2])

	$hPAvgTurnSpeed[2] = GUICtrlCreateLabel(0, $Board_HCenter+65, $Board_Height + 55, 20, 15)
	GUICtrlSetFont(-1, 8, 400, 0, $Font_Labels)
	;GUICtrlSetBkColor(-1, 0x225577) ;DEBUG ONLY
	GUICtrlSetColor(-1, $PColor[2])

	$hPWins[2] = GUICtrlCreateLabel("WINS: 0", $Board_Width-95, $Board_Height + 70, 80, 15, $SS_CENTER)
	GUICtrlSetColor(-1, $PColor[2])
	GUICtrlSetFont(-1, 10, 400, 0, $Font_Labels)

	$hDraws = GUICtrlCreateLabel("DRAWS: 0", 150, $Board_Height + 70, 100, 15, $SS_CENTER)
	GUICtrlSetFont(-1, 10, 400, 0, $Font_Labels)

	;Games played
	$hTotalGames = GUICtrlCreateLabel("GAMES PLAYED: 0", $Board_HCenter-(140/2), $Board_Height + 6, 140, 15, $SS_CENTER)
	GUICtrlSetFont(-1, 10, 400, 0, $Font_Labels)
	;GUICtrlSetBkColor(-1, 0x225577) ;DEBUG ONLY

	;Total moves
	$hAvgMoves = GUICtrlCreateLabel("AVG MOVES PER GAME: 0", $Board_HCenter-(140/2), $Board_Height + 25, 140, 15, $SS_CENTER)
	GUICtrlSetFont(-1, 8, 400, 0, $Font_Labels)
	;GUICtrlSetBkColor(-1, 0x225577) ;DEBUG ONLY
	GUICtrlSetColor(-1, $Stat_Color)

	;Average score
	GUICtrlCreateLabel("<      AVG SCORE      >", $Board_HCenter-(110/2), $Board_Height + 40, 110, 15, $SS_CENTER)
	GUICtrlSetFont(-1, 8, 400, 0, $Font_Labels)
	;GUICtrlSetBkColor(-1, 0x225577) ;DEBUG ONLY
	GUICtrlSetColor(-1, $Stat_Color)

	;Avg AI Speed
	GUICtrlCreateLabel("< AVG TURN SPEED >", $Board_HCenter-(110/2), $Board_Height + 55, 110, 15, $SS_CENTER)
	GUICtrlSetFont(-1, 8, 400, 0, $Font_Labels)
	;GUICtrlSetBkColor(-1, 0x225577) ;DEBUG ONLY
	GUICtrlSetColor(-1, $Stat_Color)

	;Create reset button
	GUICtrlCreateButton("RESTART", 5, $Board_Height + 87, 90, 20)
	GUICtrlSetFont(-1, 8, 400, 0, $Font_Labels)
	GUICtrlSetOnEvent(-1, "ClickReset")

	GUICtrlCreateButton("CLEAR STATS", 105, $Board_Height + 87, 90, 20)
	GUICtrlSetFont(-1, 8, 400, 0, $Font_Labels)
	GUICtrlSetOnEvent(-1, "ClickResetAll")

	GUICtrlCreateButton("MENU", 205, $Board_Height + 87, 90, 20)
	GUICtrlSetFont(-1, 8, 400, 0, $Font_Labels)
	GUICtrlSetOnEvent(-1, "ClickMenu")

	GUICtrlCreateButton("EXIT", 305, $Board_Height + 87, 90, 20)
	GUICtrlSetFont(-1, 8, 400, 0, $Font_Labels)
	GUICtrlSetOnEvent(-1, "ClickClosed")

	;Create skip button - DEBUG ONLY
	If $Debug Then
		GUICtrlCreateButton("Skip", $Board_Width - 160, $Board_Height + 45, 40)
		GUICtrlSetOnEvent(-1, "ClickSkip")
	EndIf

	CreateBoard() ;Render gameboard
	CreatePieces() ;Render gamepieces

	;Setup double jump
	;MovePiece(4,5,3,4)
	;MovePiece(3,4,2,3)
	;MovePiece(3,6,4,5)

	While 1
		$LastPlayer = $CurrentPlayer
		$PiecePending = True
		$MovePending = True
		$Jump_Count = 0 ;Jump count

		While $LastPlayer = $CurrentPlayer ;Loop until current player changes
			If $PType[$CurrentPlayer] = 1 Then ;Human move
				WaitPiece() ;Loop until a valid piece is chosen
				;Loop until no moves are left
				While IsArray($aMoves)
					$MovePending = True
					WaitMove() ;Loop until a valid move is chosen
				WEnd
			Else
				CPU_Move() ;CPU move
			EndIf
			CheckWin()
			TogglePlayer()
		WEnd
		If $Turn_Delay Then Sleep($Turn_Delay) ;If both players are CPU, slow speed down for visibility
	WEnd
EndFunc   ;==>Main

Func GUI_Setup()
	Debug("","GUI_Setup()")

	Local $GUI_Width = 410, $GUI_Height = 160
	Local $Radio_Human[3], $Radio_AI[3]

; 	Load AI files in array
	$aAI_Array = _FileListToArray(@ScriptDir, "AI_*.xxe", 1)
	If Not IsArray($aAI_Array) Then Dim $aAI_Array[2] = [1, "AI_Standard.exe"] ; temporary?
	For $x = 1 To $aAI_Array[0]
		$aAI_Array[$x] = StringTrimLeft(StringTrimRight($aAI_Array[$x], 4) , 3)
	Next

	Opt("GUIOnEventMode", 0) ;Switch to OnEvent mode
	$hGUI_Setup = GUICreate($Title & " -  Setup", $GUI_Width, $GUI_Height, -1, -1, Default,$WS_EX_TOOLWINDOW ) ;Add bottom margin for controls
	GUISetState(@SW_SHOW)

	; PLAYER 1
	GUICtrlCreateLabel("Player 1", 10, 5, 100)
	GUICtrlSetFont(-1, 12, 600, 0, $Font_Labels)
	GUIStartGroup()
	$Radio_Human[1] = GUICtrlCreateRadio("Human", 10, 30)
	$Radio_AI[1] = GUICtrlCreateRadio("CPU", 10, 50)
	GUICtrlSetState($Radio_Human[1], $GUI_CHECKED)
	GUICtrlCreateLabel("", 85, 5, 20, 20)
	GUICtrlSetBkColor(-1, $PColor[1])
	$Label_AI1 = GUICtrlCreateLabel("AI:", 10, 75, 15, 20)
	Hide($Label_AI1)
	$Combo_AI1 = GUICtrlCreateCombo("", 25, 72, 85, 20)
	_GUICtrlComboBox_SetItemHeight($Combo_AI1, 12)
	GUICtrlSetData(-1, _ArrayToString($aAI_Array, "|", 1), "Standard")
	Hide($Combo_AI1)

	; PLAYER 2
	GUICtrlCreateLabel("Player 2", 335, 5, 100)
	GUICtrlSetFont(-1, 12, 600, 0, $Font_Labels)
	GUIStartGroup()
	$Radio_Human[2] = GUICtrlCreateRadio("Human", 305, 30)
	$Radio_AI[2] = GUICtrlCreateRadio("CPU", 305, 50)
	GUICtrlSetState($Radio_AI[2], $GUI_CHECKED)
	GUICtrlCreateLabel("", 305, 5, 20, 20)
	GUICtrlSetBkColor(-1, $PColor[2])
	$Label_AI2 = GUICtrlCreateLabel("AI:", 305, 75, 15, 20)
	$Combo_AI2 = GUICtrlCreateCombo("", 320, 72, 85, 12)
	_GUICtrlComboBox_SetItemHeight($Combo_AI2, 12)
	GUICtrlSetData(-1, _ArrayToString($aAI_Array, "|", 1), "Standard")

	$Check_Survival = GUICtrlCreateCheckbox("Survival Mode",10,110)
	$Check_Debug = GUICtrlCreateCheckbox("Debug Mode",110,110)
	$Check_Slide = GUICtrlCreateCheckbox("Slide pieces",210,110)
	Check($Check_Slide)
	$Check_Hints = GUICtrlCreateCheckbox("Show move hints",310,110)
	Check($Check_Hints)
	$BTN_Start = GUICtrlCreateButton("Start Game", 140, 135, 120, 20)

	;AI Battle controls
	$hAICtrl[0] = GUICtrlCreateGraphic(118, 4, 164, 105)
	GUICtrlSetColor(-1, $Stat_Color)
	GUICtrlSetColor(-1, 0x33CC00)
	GUICtrlSetState(-1, $GUI_DISABLE)
	GUICtrlSetState(-1, $GUI_HIDE)

	$hAICtrl[1] = GUICtrlCreateLabel("AI BATTLE MODE", 145, 8, 120, 15)
	GUICtrlSetFont(-1, 9, 600, 0, $Font_Labels)
	GUICtrlSetColor(-1, 0x000000)
	GUICtrlSetState(-1, $GUI_HIDE)

	$hAICtrl[2] = GUICtrlCreateLabel("GAMES TO PLAY:", 130, 28, 105, 15)
	GUICtrlSetFont(-1, 8, 400, 0, $Font_Labels)
	GUICtrlSetColor(-1, 0x000000)
	GUICtrlSetState(-1, $GUI_HIDE)
	$Combo_Games =  GUICtrlCreateCombo("100", 220, 24, 45, 12, $CBS_DROPDOWNLIST)
	GUICtrlSetFont(-1, 8, 400, 0, $Font_Labels)
	_GUICtrlComboBox_SetItemHeight($Combo_Games, 12)
	GUICtrlSetData($Combo_Games, "10|25|50|100|250|500", "10")
	GUICtrlSetState(-1, $GUI_HIDE)

	$hAICtrl[3] = GUICtrlCreateLabel("AI DELAY:", 130, 51, 70, 15)
	GUICtrlSetFont(-1, 8, 400, 0, $Font_Labels)
	GUICtrlSetColor(-1, 0x000000)
	GUICtrlSetState(-1, $GUI_HIDE)
	$Combo_Delay =  GUICtrlCreateCombo("NONE", 190, 47, 75, 12, $CBS_DROPDOWNLIST)
	GUICtrlSetFont(-1, 8, 400, 0, $Font_Labels)
	_GUICtrlComboBox_SetItemHeight($Combo_Delay, 12)
	GUICtrlSetData($Combo_Delay, "100 MS|250 MS|500 MS|750 MS|1000 MS", "NONE")
	GUICtrlSetState(-1, $GUI_HIDE)

	$Check_Animate = GUICtrlCreateCheckbox("DISABLE ANIMATION", 130, 69, 140, 15)
	GUICtrlSetFont(-1, 8, 400, 0, $Font_Labels)
	GUICtrlSetColor(-1, 0x000000)
	GUICtrlSetState(-1, $GUI_HIDE)

	GUICtrlCreateCheckbox("??????????", 130, 89, 140, 15)
	GUICtrlSetFont(-1, 8, 400, 0, $Font_Labels)
	GUICtrlSetColor(-1, 0x000000)
	GUICtrlSetState(-1, $GUI_HIDE)

;-------------------------------------------------------------------------------
	While 1
		Switch GUIGetMsg()
			Case $GUI_EVENT_CLOSE
				Exit
			Case $Radio_Human[1]
				Hide($Label_AI1)
				Hide($Combo_AI1)
			Case $Radio_AI[1]
				Show($Label_AI1)
				Show($Combo_AI1)
			Case $Radio_Human[2]
				Hide($Label_AI2)
				Hide($Combo_AI2)
			Case $Radio_AI[2]
				Show($Label_AI2)
				Show($Combo_AI2)
			Case $Combo_Games
				$GamesPerMatch = Number(GUICtrlRead($Combo_Games))
			Case $Combo_Delay
				$Move_Delay = Number(GUICtrlRead($Combo_Delay))
				$Turn_Delay = $Move_Delay / 2
			Case $BTN_Start
				;Player 1 type
				If IsChecked($Radio_Human[1]) Then
					$PType[1] = 1
				Else
					$PType[1] = 2
					$PAI[1] = "AI_" & GUICtrlRead($Combo_AI1)
				EndIf

				;Player 2 type
				If IsChecked($Radio_Human[2]) Then
					$PType[2] = 1
				Else
					$PType[2] = 2
					$PAI[2] = "AI_" & GUICtrlRead($Combo_AI2)
				EndIf
				If $PType[1] = 2 And $PType[2] = 2 Then $Turn = 500 ; set turn delat here

				If IsChecked($Check_Animate) Then
					$Animate = 0
				Else
					$Animate = 1
				EndIf

				If IsChecked($Check_Slide) Then
					$Slide = 1
				Else
					$Slide = 0
				EndIf

				;Setup Survival Mode
				If IsChecked($Check_Survival) Then
					$Game_Mode = 1
					$PName[1] = "HUMANS"
					$PName[2] = "UNDEAD"
					$Board_Color[2] = 0x000000 ;Black
					$PColor[2] = 0x8ea146;0x6e774d ;Olive green
					$PSelectColor[2] = 0x566910
					$Title &= " - SURVIVAL MODE"
				EndIf
				If IsChecked($Check_Debug) Then $Debug = True
				If NOT IsChecked($Check_Hints) Then $Move_Symbol = ""
				ExitLoop
		EndSwitch
		If IsChecked($Radio_AI[1]) And IsChecked($Radio_AI[2]) Then
			If Not $Ai_Battle Then
				$Ai_Battle = 1
				$GamesPerMatch = 10
				$Turn_Delay = 0
				$Move_Delay = 0
				Toggle_Battle_Controls()
			EndIf
		Else
			$GamesPerMatch = 1
			$Move_Delay = 600
			$Turn_Delay = 300
			If $Ai_Battle Then
				$Ai_Battle = 0
				Toggle_Battle_Controls()
			EndIf
		EndIf
	WEnd
	GUIDelete()
EndFunc   ;==>Setup

Func Toggle_Battle_Controls()
	If $Ai_Battle Then
		GUICtrlSetState($Check_Slide, $GUI_UNCHECKED)
		GUICtrlSetState($Check_Hints, $GUI_UNCHECKED)
		GUICtrlSetState($Check_Animate, $GUI_CHECKED)
		GUICtrlSetState($Check_Animate, $GUI_SHOW)
		GUICtrlSetState($Combo_Games, $GUI_SHOW)
		GUICtrlSetState($Combo_Delay, $GUI_SHOW)
		For $x = 0 to 3
			GUICtrlSetState($hAICtrl[$x], $GUI_SHOW)
		Next
	Else
		GUICtrlSetState($Check_Slide, $GUI_CHECKED)
		GUICtrlSetState($Check_Hints, $GUI_CHECKED)
		GUICtrlSetState($Check_Animate, $GUI_UNCHECKED)
		GUICtrlSetState($Check_Animate, $GUI_HIDE)
		GUICtrlSetState($Combo_Games, $GUI_HIDE)
		GUICtrlSetState($Combo_Delay, $GUI_HIDE)
		For $x = 0 to 3
			GUICtrlSetState($hAICtrl[$x], $GUI_HIDE)
		Next
	EndIf
EndFunc

; #EVENTS# =====================================================================================================================

;Click action for piece
Func ClickPiece()

	If $Jump_Count > 0 Then
		ClickSkip() ; Allow player to skip multiple jumps if desired
		Return
	EndIf

	FindPieceId()

	Local $X = $Piece_Selected[0]
	Local $Y = $Piece_Selected[1]

	Debug("Piece selected at [" & $X & "," & $Y & "]","ClickPiece() - Player " & $CurrentPlayer)

	If IsEnemy($X, $Y) Then
		Debug("Piece selected at [" & $X & "," & $Y & "] belongs to the enemy","")
		Return
	EndIf

	FlushMoves()

	$aMoves = FindMoves($X, $Y) ;<-- MOVE TO MAIN LOOP
	If Not IsArray($aMoves) Then
		;ConsoleWrite("PIECE @ " & $X & "," & $Y & " - CANNOT MOVE" & @CRLF)
	Else
		;ConsoleWrite("PIECE @ " & $X & "," & $Y & " - MOVES AVAILABLE" & @CRLF)
		HighlightMoves()
		;MsgBox(0,"",DebugNestedMoves($aMoves))

		$PiecePending = False
	EndIf
EndFunc   ;==>ClickPiece

;Click action for movement destination
;[n][0] = Move X
;[n][1] = Move Y
;[n][2] = Move control id
;[n][3] = Move weight
;[n][4] = Nested moves
Func ClickMove()
	If NOT $MovePending Then Return

	$N = FindMoveId()

	$X1 = $Piece_Selected[0]
	$Y1 = $Piece_Selected[1]

	$X2 = $aMoves[$N][0]
	$Y2 = $aMoves[$N][1]

	Debug("Move selected at [" & $X2 & "," & $Y2 & "] - Source: [X,Y]","ClickMove() - Player " & $CurrentPlayer)

	MovePiece($X1, $Y1, $X2, $Y2)
	If @EXTENDED Then ;Jump performed
		$Jump_Count += 1 ;Increment jump count
	EndIf

	If $Jump_Count > $PMaxJumpCount[$CurrentPlayer] Then $PMaxJumpCount[$CurrentPlayer] = $Jump_Count

	;If sub-moves (double jumps) are available
	If IsArray($aMoves[$N][4]) Then
		;Copy move coordinates to piece coordinates
		$Piece_Selected[0] = $X2
		$Piece_Selected[1] = $Y2

		$TempArray = $aMoves[$N][4] ;Store nested array temporarily
		FlushMoves()

		$aMoves = $TempArray ;Copy temp array over global array

		HighlightMoves()
	Else
		FlushMoves()
		$MovePending = False
	EndIf
EndFunc   ;==>ClickMove

Func ClickClosed()
	Exit
EndFunc   ;==>ClickClosed

Func ClickMenu()
	If @Compiled Then
		Run(@ScriptFullPath) ; only works when compiled
		Exit
	Else
		MsgBox(0,"","This option presently only works with compiled scripts")
	EndIf
EndFunc   ;==>ClickClosed
;==============================================================================================================================

;Recursively find moves for a single piece, returns nested array if multiple jumps are available, returns 0 if no moves are available
Func FindMoves($XX, $YY, $Source_X = -1, $Source_Y = -1, $Origin_X = -1, $Origin_Y = -1, $Level = 0)
	If $Level = 0 Then Debug("","FindMoves() - Player " & $CurrentPlayer & " [" & $XX & "," & $YY & "]")

	;Store original piece position, this will remain static throughout recursion
	If $Origin_X = -1 Then $Origin_X = $XX
	If $Origin_Y = -1 Then $Origin_Y = $YY

	Local $MoveCount = 0

	;[n][0] = Move X
	;[n][1] = Move Y
	;[n][2] = Move control id
	;[n][3] = Move weight
	;[n][4] = Nested moves
	Local $aM[1][5]

	;Look at each corner
	For $Corner = 1 To 4

		;If an enemy piece exists, look to position beyond it, else break loop
		For $Offset = 1 To 2
			$Offset_X = $Offset
			$Offset_Y = $Offset

			Switch $Corner
				Case 1 ;Look up + left
					$Offset_X *= -1
					$Offset_Y *= -1

				Case 2 ;Look up + right
					$Offset_X *= 1
					$Offset_Y *= -1

				Case 3 ;Look down + left
					$Offset_X *= -1
					$Offset_Y *= 1

				Case 4 ;Look down + right
					$Offset_X *= 1
					$Offset_Y *= 1
			EndSwitch

			$Destination_X = $XX + $Offset_X
			$Destination_Y = $YY + $Offset_Y

			;Validate move
			If IsValidMove($XX, $YY, $Destination_X, $Destination_Y, $Source_X, $Source_Y, $Origin_X, $Origin_Y) Then
				;ConsoleWrite("Valid Move" & @CRLF)

				;If destination contains enemy, look for jump
				If $Offset = 1 Then
					If IsEnemy($Destination_X, $Destination_Y) Then ContinueLoop
					If $Level Then ExitLoop
				EndIf

				;If space is unoccupied
				If Not IsOccupied($Destination_X, $Destination_Y) Then
					;ConsoleWrite("Unoccupied" & @CRLF)

					If $MoveCount > 0 Then ReDim $aM[$MoveCount+1][5]

					$aM[$MoveCount][0] = $Destination_X
					$aM[$MoveCount][1] = $Destination_Y

					;Jump
					If $Offset = 2 Then
						;ConsoleWrite("Jump" & @CRLF)

						$aM[$MoveCount][4] = FindMoves($Destination_X, $Destination_Y, $XX, $YY, $Origin_X, $Origin_Y, $Level + 1)
						$aM[$MoveCount][3] = 1
					EndIf

					$MoveCount += 1
				EndIf

				ExitLoop ;Loop will only continue if an enemy piece is nearby
			EndIf
		Next
	Next

	If $MoveCount Then Return $aM

	Return 0
EndFunc   ;==>FindMoves

;CPU move
;[n][0] = Move X
;[n][1] = Move Y
;[n][2] = Move control id
;[n][3] = Move weight
;[n][4] = Nested moves
Func CPU_Move()
	Debug("","CPU_Move() - Player " & $CurrentPlayer)

	Local $Count = 0
	Local $aTempPieces[1][4]

	;Search through all pieces and build array of pieces with moves available
	For $Y = 0 To $Board_Rows - 1
		For $X = 0 To $Board_Cols - 1
			If IsOccupied($X, $Y) And ($aBoard[$Y][$X][1] = $CurrentPlayer) AND IsShown($aBoard[$Y][$X][0]) Then
				$aMoves = FindMoves($X, $Y)
				If IsArray($aMoves) Then
					;MsgBox(0,"",DebugNestedMoves($aMoves))

					If $Count <> 0 Then ReDim $aTempPieces[$Count + 1][4]

					$aTempPieces[$Count][0] = $X
					$aTempPieces[$Count][1] = $Y

					For $N = 0 to Ubound($aMoves)-1
						If $aMoves[$N][3] Then $aTempPieces[$Count][2] = 1
					Next

					Shuffle2DArray($aMoves) ;Shuffle moves so first found isn't always taken
					Sort2DArray($aMoves,3) ;Sort moves by weight

					;Store moves for piece
					$aTempPieces[$Count][3] = $aMoves

					$Count += 1
				EndIf
			EndIf
		Next
	Next

	;Count number of pieces with moves available
;	If Not $Count Then
;		MsgBox(0, "", "No moves available for player " & $CurrentPlayer)
;		Return
;	Endif

	Shuffle2DArray($aTempPieces) ;Shuffle pieces so first available isn't always chosen
	Sort2DArray($aTempPieces,2) ;Sort pieces by weight

	$Piece_Selected[0] = $aTempPieces[0][0]
	$Piece_Selected[1] = $aTempPieces[0][1]

	$aMoves = $aTempPieces[0][3]
	HighlightMoves()
	If $Move_Delay Then Sleep($Move_Delay) ;Delay for human player to see move take place
	;Take highest weighted move from highest weighted piece
	MovePiece($Piece_Selected[0], $Piece_Selected[1], $aMoves[0][0], $aMoves[0][1])
	FlushMoves()
EndFunc   ;==>CPU_Move

;Move piece located at X1,Y1 with piece at X2,Y2
Func MovePiece($XX1, $YY1, $XX2, $YY2)
	Debug("[" & $XX1 & "," & $YY1 & "] -> [" & $XX2 & "," & $YY2 & "]","MovePiece() - Player " & $CurrentPlayer)

	;If source square is empty, or destination is occupied, return
	If NOT IsOccupied($XX1,$YY1) Or IsOccupied($XX2,$YY2) Then Return 0

	If $Animate Then
		$xDir = -1 + ($XX1 < $XX2) * 2
		$yDir = -1 + ($YY1 < $YY2) * 2
		$xTemp2 = $XX2 * $Cell_Width
		If $Slide Then
			$xTemp1 = $XX1 * $Cell_Width
			$yTemp1 = $YY1 * $Cell_Width
		Else
			$xTemp1 = $xTemp2 - $xDir
			$yTemp1 = $YY2 * $Cell_Width - $yDir
		EndIf
		While $xTemp1 <> $xTemp2
			$xTemp1 += $xDir
			$yTemp1 += $yDir
			GUICtrlSetPos($aBoard[$YY1][$XX1][0], $xTemp1, $yTemp1, $Cell_Width, $Cell_Height) ;Move piece
			For $x = 1 to $Turn_Delay * 8 ; sleep(10) is too slow
			Next
		Wend
	EndIf

	;Copy all attributes
	For $Z = 0 To 2
		$aBoard[$YY2][$XX2][$Z] = $aBoard[$YY1][$XX1][$Z]
		$aBoard[$YY1][$XX1][$Z] = ""
	Next

	If IsOccupied($XX2, $YY2) AND (($YY2 = $Board_Rows - 1) OR ($YY2 = 0)) Then King($XX2,$YY2)

	$PMoves[$CurrentPlayer][0] += 1

	;JUMP
	;Remove jumped piece if applicable
	;If Abs($XX1 - $XX2) > 1 And Abs($YY1 - $YY2) > 1 Then
	If IsJump($XX1, $YY1, $XX2, $YY2) Then
		$X = ($XX1 + $XX2) / 2
		$Y = ($YY1 + $YY2) / 2

		Hide($aBoard[$Y][$X][0]) ;Hide jumped piece

		;Delete all attributes
		For $Z = 0 To 2
			$aBoard[$Y][$X][$Z] = ""
		Next

		$PScore[$CurrentPlayer][0] += 1 ; increment player score
		RefreshStats()
		Return SetError(0,1,1) ;Set extended to indicate jump
	EndIf
EndFunc   ;==>MovePiece

;Highlight possible moves
Func HighlightMoves()
	Debug("","HighlightMoves() - Player " & $CurrentPlayer)
	;NOTE - Need to delete existing labels first
	Local $X,$Y

	Local $Source_X = $Piece_Selected[0],$Source_Y = $Piece_Selected[1]

	;Highlight selected piece (Causes flickering)
	;#cs
	;$Piece_Selected[2] = GUICtrlCreateGraphic($Source_X * $Cell_Width, $Source_Y * $Cell_Height, $Cell_Width,$Cell_Height, 0)
	;GUICtrlSetBkColor(-1, $Selected_Color)
	;GUICtrlSetGraphic(-1, $GUI_GR_COLOR, $Board_Color1,$Board_Color1)
	;GUICtrlSetGraphic(-1, $GUI_GR_RECT, 3,3,$Cell_Width-6,$Cell_Height-6)
	;GUICtrlSetGraphic(-1, $GUI_GR_REFRESH)
	;#ce
	If $Animate Then
		$Piece_Selected[2] = GUICtrlCreateLabel("«",$Source_X * $Cell_Width, $Source_Y * $Cell_Height, $Cell_Width,$Cell_Height, BitOr($SS_CENTER,$SS_CENTERIMAGE))
		GUICtrlSetColor(-1, $PSelectColor[$CurrentPlayer])
		GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
		GUICtrlSetFont(-1, 25, "", "", $Font_Pieces)
	EndIf

	For $N = 0 to Ubound($aMoves)-1
		$X = $aMoves[$N][0]
		$Y = $aMoves[$N][1]
		If $Animate Then
			$aMoves[$N][2] = GUICtrlCreateLabel($Move_Symbol, $X * $Cell_Width, $Y * $Cell_Height, $Cell_Width,$Cell_Height, BitOr($SS_CENTER,$SS_CENTERIMAGE))
			GUICtrlSetOnEvent(-1, "ClickMove")
			GUICtrlSetColor(-1, $Move_Color)
			GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
			GUICtrlSetFont(-1, 38, "", "", $Font_Pieces)
			Debug("Move controlid created: " & $aMoves[$N][2] & " at [" & $X & "," & $Y & "]","")
		EndIf
	Next
EndFunc   ;==>HighlightMoves

;Destroy moves array and all controls within it (no need to recurse)
Func FlushMoves()
	Debug("","FlushMoves() - Player " & $CurrentPlayer)
	GUICtrlDelete($Piece_Selected[2]) ;Delete selected piece highlight

	;Empty moves array, delete move indicators
	If IsArray($aMoves) Then
		For $N = 0 to Ubound($aMoves)-1
			Debug("Deleting control id: " & $aMoves[$N][2],"")
			GUICtrlDelete($aMoves[$N][2])
		Next
	EndIf
	$aMoves = "" ;Invalidate moves array
EndFunc   ;==>FlushMoves

;Check to see if there are any moves left on the board or if a player has run out of pieces
Func CheckWin()
	Debug("","CheckWin() - Player " & $CurrentPlayer)
	;MsgBox(0,"",DebugBoard())

	Local $NumPieces[3] =[0, 0, 0], $NumMoves[3] = [0, 0, 0]
	Local $aMovesTemp
	Local $CurrentPlayer_Backup = $CurrentPlayer ;FindMoves IsEnemy uses $CurrentPlayer

	;Search through all pieces and build array of pieces with moves available
	For $Y = 0 To $Board_Rows - 1
		For $X = 0 To $Board_Cols - 1
			If IsOccupied($X, $Y) AND IsShown($aBoard[$Y][$X][0]) Then
				$CurrentPlayer = $aBoard[$Y][$X][1] ;Update CurrentPlayer temporarily
				$aMovesTemp = FindMoves($X, $Y)
				$NumPieces[$CurrentPlayer] += 1
				If IsArray($aMovesTemp) Then $NumMoves[$CurrentPlayer] += 1
				$aMovesTemp = ""
			EndIf
		Next
	Next

	Debug("$NumPieces_P1 = " & $NumPieces[1] & ", $NumPieces_P2 = " & $NumPieces[2] & ", $NumMoves_P1 = " & $NumMoves[1] & ", $NumMoves_P2 = " & $NumMoves[2],"")

	If Not ($NumPieces[1] * $NumPieces[2]) Then ; normal win
		;Victory
		If $NumPieces[2] = 0 Then
			$CurrentPlayer = 1
		Else
			$CurrentPlayer = 2
		EndIf
		$PWins[$CurrentPlayer] += 1
		End_of_Game($CurrentPlayer, "WIN")
;		ClickReset()
		$CurrentPlayer = $CurrentPlayer_Backup
		Return
	EndIf


	If Not ($NumMoves[1] * $NumMoves[2]) Then
		If $NumMoves[1] + $NumMoves[2] = 0 Then ; draw
			$Draws += 1
			End_of_Game(0, "DRAW")
		Else ; forfeit win
			If $NumMoves[2] = 0 Then
				$CurrentPlayer = 1
			Else
				$CurrentPlayer = 2
			EndIf
			$PWins[$CurrentPlayer] += 1
			End_of_Game($CurrentPlayer, "WIN")
		EndIf
;		ClickReset()
		$CurrentPlayer = $CurrentPlayer_Backup
		Return
	EndIf
	$CurrentPlayer = $CurrentPlayer_Backup
EndFunc

Func End_of_Game($Player, $string)
	$Games_Played += 1
	RefreshMasterStats()
	$EOG_Label = GUICtrlCreateLabel($string, 100, 167, 200, 85, $SS_CENTER)
	GUICtrlSetFont(-1, 44, 600)
	GUICtrlSetColor(-1, $PColor[$Player])
	GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
	Sleep(50 + $Turn_Delay)
	If $Games_Played And (Mod($Games_Played, $GamesPerMatch) = 0) Then
		$Play_Again = 0
		While Not $Play_Again
		WEnd
	Else
		ClickReset()
	EndIf
	GUICtrlDelete($EOG_Label)
EndFunc

Func ClickResetAll()
	$Games_Played = 0
	For $x = 1 to 2 ; clear master totals
		$PWins[$x] = 0
		$PAvgTurnSpeed[$x] = 0
		$PScore[$x][1] = 0
		$PMoves[$x][1] = 0
	Next
	For $x = 1 to 2 ; clear game totals
		$PScore[$x][0] = 0
		$PMoves[$x][0] = 0
	Next
	RefreshMasterStats()
	RefreshStats()
EndFunc   ;==>ClickResetAll

Func ClickReset()
	Debug("","ClickReset()")
	$Play_Again = 1
	For $x = 1 to 2 ; clear game totals
		$PScore[$x][0] = 0
		$PMoves[$x][0] = 0
	Next
	RefreshStats()
	FlushMoves()
	$CurrentPlayer = 1
	ToggleIndicator()
	$aBoard = $aPieces ;Swap live array with copy from start
	ResetPieces(1) ;IMPORTANT - unhide flag
EndFunc   ;==>ClickReset

Func RefreshMasterStats()
	GUICtrlSetData($hTotalGames, "GAMES PLAYED: " & $Games_Played)
	For $x = 1 to 2 ; players
		$PMoves[$x][1] += $PMoves[$x][0]
		If $PMoves[$x][1] Then
			GUICtrlSetData($hAvgMoves, "AVG MOVES PER GAME: " & Int(($PMoves[$x][1] + $PMoves[$x][1]) / ($Games_Played * 2)))
		Else
			GUICtrlSetData($hAvgMoves,"AVG MOVES PER GAME: "  & 0)
		EndIf
		$PScore[$x][1] += $PScore[$x][0]
		If $PScore[$x][1] Then
			GUICtrlSetData($hPScore[$x][1], Int($PScore[$x][1] / $Games_Played))
		Else
			GUICtrlSetData($hPScore[$x][1], 0)
		EndIf
		GUICtrlSetData($hPWins[$x], "WINS: " & $PWins[$x])
	Next
	GUICtrlSetData($hDraw, "DRAWS: " & $Draws)
EndFunc

Func RefreshStats()
	For $x = 1 to 2 ; players
		GUICtrlSetData($hPScore[$x][0], $PScore[$x][0])
		GUICtrlSetData($hPMoves[$x][0],"MOVES: " & $PMoves[$x][0])
		GUICtrlSetData($hPAvgTurnSpeed[$x],$PAvgTurnSpeed[$x])
	Next
EndFunc

;Skip move - DEBUG ONLY
Func ClickSkip()
	FlushMoves()
	$PiecePending = False
	$MovePending = False
EndFunc   ;==>ClickSkip

;===================================================================================================================================
;Draw static checkerboard
Func CreateBoard()
	Debug("","CreateBoard()")

	$BoardGraphic = GUICtrlCreateGraphic(0, 0, $Board_Width, $Board_Height)
	GUICtrlSetState(-1, $GUI_DISABLE) ;IMPORTANT
	GUICtrlSetBkColor(-1, $Board_Color[2])

	Local $Flip = false
    For $Y = 0 To $Board_Rows - 1
        For $X = 0 to $Board_Cols - 1
            If $Flip Then
				;Draw square color1
				GUICtrlSetGraphic($BoardGraphic, $GUI_GR_COLOR, $Board_Color[1], $Board_Color[1])
				GUICtrlSetGraphic($BoardGraphic, $GUI_GR_RECT, $X * $Cell_Width, $Y * $Cell_Height, $Cell_Width, $Cell_Height)
            Else
				;GUICtrlSetGraphic($boardGraphic,$GUI_GR_COLOR, $Board_Color[2],$Board_Color[2])
            EndIf
            $Flip = Not $Flip
        Next
        $Flip = Not $Flip
    Next

	GUICtrlSetGraphic($BoardGraphic, $GUI_GR_REFRESH) ;Refresh graphic
EndFunc   ;==>CreateBoard

;This function will build the array, assigning default positions
Func CreatePieces()
	Debug("","CreatePieces()")
	Local $RowsPieces = Int(($Board_Rows / 2) - 1) ;This should create a buffer of two rows between teams
	Local $Flip = False
	Local $Player

	If $Game_Mode = 0 Then
		;Create 3 rows of pieces from top of board
		For $Y = 0 To $Board_Rows  - 1
			For $X = 0 To $Board_Cols - 1
				Switch $Y
					Case 0, 1, 2
						$Player = 1
					Case 3, 4
						ContinueLoop
					Case 5, 6, 7
						$Player = 2
				EndSwitch
				If $Flip Then CreatePiece($X,$Y,$Player,$PColor[$Player])
				$Flip = Not $Flip
			Next
			$Flip = Not $Flip
		Next
	Else
		;ULTRA INSANE SURVIVAL MODE
		For $Y = 0 To $Board_Rows  - 1
			For $X = 0 To $Board_Cols - 1
				Switch $Y
					Case 0
						$Player = 1
						If $Flip Then CreatePiece($X,$Y,$Player,$PColor[$Player], 1)
					Case 1, 2, 3
						ContinueLoop
					Case 4, 5, 6, 7
						$Player = 2
						If $Flip Then CreatePiece($X,$Y,$Player,$PColor[$Player])
				EndSwitch
				$Flip = Not $Flip
			Next
			$Flip = Not $Flip
		Next
	EndIf

	$aPieces = $aBoard ;Copy array for reset later

	ResetPieces() ;IMPORTANT
EndFunc   ;==>CreatePieces

;Add piece to board (must be called from CreatePieces() for it to show)
Func CreatePiece($XX,$YY,$PP,$CC,$K=0)
	;Generate label now so its controlid stays constant (instead of creating new labels on redraw)
	$aBoard[$YY][$XX][0] = GUICtrlCreateLabel("l", -500, -500, 0, 0, BitOR($SS_CENTER, $SS_CENTERIMAGE))
	GUICtrlSetOnEvent(-1, "ClickPiece")
	GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
	GUICtrlSetFont(-1, 47, "", "", $Font_Pieces)
	GUICtrlSetColor(-1, $CC)
	$aBoard[$YY][$XX][1] = $PP ;Assign piece to player
	If $K Then $aBoard[$YY][$XX][2] = True
	;Debug("Piece created for Player " & $PP & " @ [" & $XX & "," & $YY & "]","")
EndFunc

;Generate game pieces based on position in array, team designation
Func ResetPieces($Unhide = 0)
	Debug("","ResetPieces()")

	For $Y = 0 To $Board_Rows - 1
		For $X = 0 To $Board_Cols - 1
			If NOT IsOccupied($X, $Y) Then ContinueLoop

			If $Animate Then GUICtrlSetPos($aBoard[$Y][$X][0], $X * $Cell_Width, $Y * $Cell_Height, $Cell_Width, $Cell_Height) ;Move piece
			If $Unhide Then Show($aBoard[$Y][$X][0]) ;Unhide pieces
			;Determine if piece is king
			If IsKing($X, $Y) Then
				GUICtrlSetData($aBoard[$Y][$X][0], "®")
			Else
				GUICtrlSetData($aBoard[$Y][$X][0], "l")
			EndIf
		Next
	Next
EndFunc   ;==>ResetPieces

; #COMMON FUNCTIONS# ===============================================================================================================

Func IsJump($XX1, $YY1, $XX2, $YY2)
	If Abs($XX1 - $XX2) > 1 And Abs($YY1 - $YY2) > 1 Then Return True
	Return False
EndFunc

Func IsValidMove($XX, $YY, $DX, $DY, $SX, $SY, $OX, $OY)
	;ConsoleWrite("$XX: " & $XX & ", $YY: " & $YY & ", $DX: " & $DX & ", $DY: " & $DY & ", $SX: " & $SX & ", $SY: " & $SY & ", $OX: " & $OX & ", $OY: " & $OY & " - ") ;DEBUG ONLY

	If IsWithinBoard($DX, $DY) Then

		If NOT ($DX = $SX And $DY = $SY) Then ;Destination can't be the current position

			;Verify movement direction (Player 1 - Positive, Player 2 - Negative)
			If (($CurrentPlayer = 1 And $DY > $YY) Or ($CurrentPlayer = 2 And $DY < $YY) Or IsKing($OX, $OY)) Then
				;ConsoleWrite("VALID" & @CRLF) ;DEBUG ONLY
				Return True
			EndIf
		EndIf
	EndIf
	;ConsoleWrite("INVALID" & @CRLF) ;DEBUG ONLY
	Return False
EndFunc

;Locate piece handle
Func FindPieceId()
	For $Y = 0 To $Board_Rows - 1
		For $X = 0 To $Board_Cols - 1
			If @GUI_CtrlId = $aBoard[$Y][$X][0] Then
				$Piece_Selected[0] = $X
				$Piece_Selected[1] = $Y
				Return 1
			EndIf
		Next
	Next
	Return 0
EndFunc

;Locate move handle
Func FindMoveId()
	For $N = 0 To Ubound($aMoves)-1
		If @GUI_CtrlId = $aMoves[$N][2] Then Return $N
	Next

	Return -1
EndFunc

Func IsSelected($XX,$YY)
	If $XX = $Piece_Selected[0] AND $YY = $Piece_Selected[1] Then Return True
	Return False
EndFunc

;Loop until a piece is chosen
Func WaitPiece()
	Local $x
	Debug("Waiting for player " & $CurrentPlayer & " to select a piece","WaitPiece() - Player " & $CurrentPlayer)
	While $PiecePending
		Blink_Indicator()
	WEnd
	Show($hPIndicator[$CurrentPlayer])
EndFunc

;Loop until a move is chosen
Func WaitMove()
	Debug("Waiting for player " & $CurrentPlayer & " to select a move","WaitMove() - Player " & $CurrentPlayer)
	While $MovePending
		Blink_Indicator()
	WEnd
	$Blink = 0
EndFunc

Func Blink_Indicator()
	$Blink += 1
	If $Blink > $Blink_Delay Then
		If IsHidden($hPIndicator[$CurrentPlayer]) Then
			Show($hPIndicator[$CurrentPlayer])
		Else
			Hide($hPIndicator[$CurrentPlayer])
		EndIf
		$Blink = 0
	EndIf
	Sleep(10) ;Reduce cpu usage
EndFunc

Func ToggleIndicator()
	GUICtrlSetState($hPIndicator[2 - ($CurrentPlayer = 2)], $GUI_HIDE)
	GUICtrlSetState($hPIndicator[1 + ($CurrentPlayer = 2)], $GUI_SHOW)
EndFunc

;Alternate player
Func TogglePlayer()
	RefreshStats()
	$CurrentPlayer = 2 - ($CurrentPlayer = 2)
	ToggleIndicator()
EndFunc

;Check if piece belongs to enemy
Func IsEnemy($XX, $YY)
	If IsOccupied($XX, $YY) And ($aBoard[$YY][$XX][1] <> $CurrentPlayer) Then Return True ;IsOccupied important for FindMoves
	;If ($aBoard[$YY][$XX][1] <> $CurrentPlayer) Then Return True
	Return False
EndFunc   ;==>IsEnemy

#cs
;Check if piece belongs to current player
Func IsFriendly($XX, $YY)
	If ($aBoard[$YY][$XX][1] = $CurrentPlayer) Then Return True
	Return False
EndFunc
#ce

;Check if piece has king status
Func IsKing($XX, $YY)
	If $aBoard[$YY][$XX][2] Then Return True
	Return False
EndFunc   ;==>IsKing

Func King($XX,$YY)
	$aBoard[$YY][$XX][2] = True
	GUICtrlSetData($aBoard[$YY][$XX][0], "®")
EndFunc

;Verify if X,Y is within constraints of the board
Func IsWithinBoard($XX, $YY)
	If ($YY >= 0 And $YY < $Board_Rows) And ($XX >= 0 And $XX < $Board_Cols) Then Return True
	Return False
EndFunc   ;==>IsWithinBoard

;Check if X,Y contains any piece
Func IsOccupied($XX, $YY)
	If $aBoard[$YY][$XX][1] Then Return True
	Return False
EndFunc   ;==>IsOccupied

Func Sort2DArray(ByRef $aArray,$iColumn=0,$iDirection=0)
	Local $Rows = Ubound($aArray)
	Local $Columns = Ubound($aArray,2)
	Local $aTemp[$Columns]

	;Sort pieces array by move weight
	For $A = 0 to $Rows-2
		For $B = ($A+1) to $Rows-1
			If $aArray[$B][$iColumn] > $aArray[$A][$iColumn] Then
				;Copy all columns
				For $C = 0 to $Columns-1
					$aTemp[$C] = $aArray[$A][$C]
					$aArray[$A][$C] = $aArray[$B][$C]
					$aArray[$B][$C] = $aTemp[$C]
				Next
			EndIf
		Next
	Next
EndFunc

Func Shuffle2DArray(ByRef $aArray)
	Local $Rows = Ubound($aArray)
	Local $Columns = Ubound($aArray,2)
	Local $aTemp[$Columns]

	;Loop through all array elements
	For $A = 0 to $Rows - 1
		$R = Random($A,$Rows-1,1)

		For $B = 0 to $Columns-1
			$aTemp[$B] = $aArray[$A][$B]
			$aArray[$A][$B] = $aArray[$R][$B]
			$aArray[$R][$B] = $aTemp[$B]
		Next
	Next
EndFunc

; #CONTROL FUNCTIONS# ===================================================================================================================

Func IsChecked($hControl)
	Return BitAND(GUICtrlRead($hControl), $GUI_CHECKED) = $GUI_CHECKED
EndFunc   ;==>IsChecked

Func Check($hControl)
	GUICtrlSetState($hControl,$GUI_CHECKED)
EndFunc

Func Hide($hControl)
	GUICtrlSetState($hControl, $GUI_HIDE)
EndFunc

Func IsHidden($hControl)
	Return BitAND(GUICtrlGetState($hControl), $GUI_HIDE)
EndFunc

Func Show($hControl)
	GUICtrlSetState($hControl, $GUI_SHOW)
EndFunc

Func IsShown($hControl)
	Return BitAND(GUICtrlGetState($hControl), $GUI_SHOW)
EndFunc

; #DEBUG FUNCTIONS# ===================================================================================================================

;Dump string / 1-dim array to console with optional description
Func Debug($mVar, $sDescription = '')
	If NOT $Debug Then Return

	If $sDescription <> '' Then ConsoleWrite('+' & $sDescription & @CRLF)

	$Indent = @TAB

	;Show all elements of array with index
	If IsArray($mVar) Then
		For $X = 0 to UBound($mVar) - 1
			ConsoleWrite($Indent & '['&$X&']: ' & $mVar[$X] & @CRLF)
		Next
		ConsoleWrite(@CRLF)
	ElseIf $mVar <> "" Then
		ConsoleWrite($Indent & $mVar & @CRLF)
		;ConsoleWrite(@CRLF)
	EndIf
EndFunc

;Display all pieces
Func DebugBoard()
	;3 dimensional Array Display
	$string = ""
	For $Y = 0 To $Board_Rows - 1
		For $X = 0 To $Board_Cols - 1
			$string &= $X & "," & $Y & " ControlId: " & $aBoard[$Y][$X][0] & " " & $aBoard[$Y][$X][1] & " " & $aBoard[$Y][$X][2] & @CRLF
		Next
	Next

	MsgBox(0, "", $string)
EndFunc   ;==>Debug

;Display all moves (recursive), returns a string
;[n][0] = Move X
;[n][1] = Move Y
;[n][2] = Move control id
;[n][3] = Move weight
;[n][4] = Nested moves
Func DebugNestedMoves($TempArray, $Level = 0)
	If Not IsArray($TempArray) Then Return "Moves array is empty"

	;Maximum number of jumps is 9, unlikely to ever be seen
	If $Level > 10 Then Return "Moves array is hosed"

	Local $string = ""
	Local $TabString = ""

	;If current level is greater than zero
	If $Level Then
		;Add tabs for indentation
		For $Z = 1 To $Level
			$TabString &= @TAB
		Next
	EndIf

	For $N = 0 To Ubound($aMoves)- 1

		$string &= $TabString & $Level & ": " & $aMoves[0] & "," & $aMoves[1] & " - " & $aMoves[$N][3] & @CRLF

		If IsArray($aMoves[$N][4]) Then
			;$string &= "ARRAY"
			$string &= DebugNestedMoves($aMoves[$N][4], $Level + 1)
		EndIf
	Next

	Return $string
EndFunc   ;==>DebugNestedMoves