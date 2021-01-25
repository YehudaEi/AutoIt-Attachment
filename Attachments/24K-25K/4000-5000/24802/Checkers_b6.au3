#cs ----------------------------------------------------------------------------
	
	AutoIt Version: 3.3.0.0
	Author:         WeaponX
	
	Script Function:
	Checkers
	
	Script Version:
	Beta 6
	
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

#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <ButtonConstants.au3>

; #CONSTANTS# ===================================================================================================================
Global Const $Version = "Beta 6"
Global Const $Board_Rows = 8, $Board_Cols = 8 ;8x8 Standard gameboard size
Global Const $Board_Width = 400, $Board_Height = 400
Global Const $Move_Color = 0x575757, $Stat_Color = 0x555555, $Selected_Color = 0x7CE8FC
Global Const $Board_HCenter = $Board_Width/2
Global Const $Cell_Width = $Board_Width / $Board_Cols, $Cell_Height = $Board_Height / $Board_Rows
Global Const $Font_Labels = "Arial", $Font_Pieces = "Wingdings"
Global Const $Simulation_Delay = 500

; #GLOBALS# ===================================================================================================================
Global $Board_Color1 = 0x333333, $Board_Color2 = 0xEEEEEE
Global $Title = "Checkers: " & $Version

Global $P1_Name = "PLAYER 1", $P2_Name = "PLAYER 2"
Global $P1_Type = 1, $P2_Type = 2 ;Player type (1 = Human, 2 = CPU)
Global $P1_Color = 0xCC0000, $P2_Color = 0x6699CC
Global $P1_SelectColor = 0x950101, $P2_SelectColor = 0x326DA9
Global $P1_Score = 0, $P2_Score = 0
Global $P1_LongestJump = 0, $P2_LongestJump = 0 ;Most jumps in a single move
Global $P1_TotalMoves = 0, $P2_TotalMoves = 0

Global $hP1_Score, $hP2_Score
Global $hP1_LongestJump,$hP2_LongestJump
Global $hP1_TotalMoves,$hP2_TotalMoves
Global $hP1_Indicator, $hP2_Indicator

Global $Debug = False ;Enable to see full output
Global $Game_Mode = 0 ;(0 = Normal Mode, 1 = Survival Mode)
Global $Move_Symbol = "¥"
Global $MovePending = False, $PiecePending = False
Global $CurrentPlayer = 1 ;Starting player
Global $Piece_Selected[3];X,Y,ControlId
Global $Jump_Count = 0 ;Current move count

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

GUI_Setup() ;Not required
GUI_Main()
Func GUI_Main()
	Debug("","GUI_Main()")

	Opt("GUIOnEventMode", 1) ;Switch to OnEvent mode
	GUICreate($Title, $Board_Width, $Board_Height + 75) ;Add bottom margin for controls
	GUISetBkColor(0x000000) ;Black background
	GUISetOnEvent($GUI_EVENT_CLOSE, "ClickClosed")
	GUISetState(@SW_SHOW)

	;----------------------------
	; PLAYER 1
	;----------------------------
	;Score
	GUICtrlCreateLabel($P1_Name, 30, $Board_Height + 5, 50,15,$SS_CENTER)
	GUICtrlSetColor(-1, $P1_Color)
	GUICtrlSetFont(-1, 8, 400, 0, $Font_Labels)
	;GUICtrlSetBkColor(-1, 0x225577) ;DEBUG ONLY
	
	$hP1_Score = GUICtrlCreateLabel("0", 30, $Board_Height + 25, 50,50, $SS_CENTER)
	GUICtrlSetColor(-1, $P1_Color)
	GUICtrlSetFont(-1, 30, 500, 0, $Font_Labels)
	;GUICtrlSetBkColor(-1, 0x225577) ;DEBUG ONLY

	$hP1_Indicator = GUICtrlCreateLabel("«", 90, $Board_Height, 20,20)
	GUICtrlSetColor(-1, 0xFFFFFF)
	GUICtrlSetFont(-1, 14, 600, 0, $Font_Labels)
	;GUICtrlSetBkColor(-1, 0x225577) ;DEBUG ONLY
	
	$hP1_LongestJump = GUICtrlCreateLabel(0, $Board_HCenter-75, $Board_Height + 5, 20,20, $SS_RIGHT)
	GUICtrlSetFont(-1, 8, 400, 0, $Font_Labels)
	;GUICtrlSetBkColor(-1, 0x225577) ;DEBUG ONLY
	GUICtrlSetColor(-1, $Stat_Color)
	
	$hP1_TotalMoves = GUICtrlCreateLabel(0, $Board_HCenter-75, $Board_Height + 20, 20,20, $SS_RIGHT)
	GUICtrlSetFont(-1, 8, 400, 0, $Font_Labels)
	;GUICtrlSetBkColor(-1, 0x225577) ;DEBUG ONLY
	GUICtrlSetColor(-1, $Stat_Color)	

	;----------------------------
	; PLAYER 2
	;----------------------------
	;Score
	GUICtrlCreateLabel($P2_Name, $Board_Width-50-30, $Board_Height + 5, 50,15,$SS_CENTER)
	GUICtrlSetColor(-1, $P2_Color)
	GUICtrlSetFont(-1, 8, 400, 0, $Font_Labels)
	;GUICtrlSetBkColor(-1, 0x225577) ;DEBUG ONLY
	
	$hP2_Score = GUICtrlCreateLabel("0", $Board_Width-50-30, $Board_Height + 25, 50, 50,$SS_CENTER)
	GUICtrlSetColor(-1, $P2_Color)
	GUICtrlSetFont(-1, 30, 400, 0, $Font_Labels)
	;GUICtrlSetBkColor(-1, 0x225577) ;DEBUG ONLY
	
	$hP2_Indicator = GUICtrlCreateLabel("»", $Board_Width-20-90, $Board_Height, 20,20,$SS_RIGHT)
	Hide($hP2_Indicator)
	GUICtrlSetColor(-1, 0xFFFFFF)
	GUICtrlSetFont(-1, 14, 600, 0, $Font_Labels)
	;GUICtrlSetBkColor(-1, 0x225577) ;DEBUG ONLY
	
	$hP2_LongestJump = GUICtrlCreateLabel(0, $Board_HCenter+55, $Board_Height + 5, 20,20)
	GUICtrlSetFont(-1, 8, 400, 0, $Font_Labels)
	;GUICtrlSetBkColor(-1, 0x225577) ;DEBUG ONLY
	GUICtrlSetColor(-1, $Stat_Color)
	
	$hP2_TotalMoves = GUICtrlCreateLabel(0, $Board_HCenter+55, $Board_Height + 20, 20,20)
	GUICtrlSetFont(-1, 8, 400, 0, $Font_Labels)
	;GUICtrlSetBkColor(-1, 0x225577) ;DEBUG ONLY
	GUICtrlSetColor(-1, $Stat_Color)
	
	
	;Longest jump
	GUICtrlCreateLabel("< LONGEST JUMP >", $Board_HCenter-(100/2), $Board_Height + 5, 100,20, $SS_CENTER)
	GUICtrlSetFont(-1, 8, 400, 0, $Font_Labels)
	;GUICtrlSetBkColor(-1, 0x225577) ;DEBUG ONLY
	GUICtrlSetColor(-1, $Stat_Color)
	
	;Total moves
	GUICtrlCreateLabel("< TOTAL MOVES >", $Board_HCenter-(100/2), $Board_Height + 20, 100,20, $SS_CENTER)
	GUICtrlSetFont(-1, 8, 400, 0, $Font_Labels)
	;GUICtrlSetBkColor(-1, 0x225577) ;DEBUG ONLY
	GUICtrlSetColor(-1, $Stat_Color)

	;Create reset button
	GUICtrlCreateButton("Reset", $Board_HCenter-(40/2), $Board_Height + 45, 40)
	GUICtrlSetOnEvent(-1, "ClickReset")
	
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
			If GetPlayerType() = 1 Then ;Human move
				
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

		If IsSimulation() Then Sleep($Simulation_Delay) ;If both players are CPU, slow speed down for visibility
	WEnd
EndFunc   ;==>Main

Func GUI_Setup()
	Debug("","GUI_Setup()")
	
	Local $GUI_Width = 300, $GUI_Height = 160
	
	Opt("GUIOnEventMode", 0) ;Switch to OnEvent mode
	GUICreate($Title & " -  Setup", $GUI_Width, $GUI_Height, -1, -1, Default,$WS_EX_TOOLWINDOW ) ;Add bottom margin for controls
	GUISetState(@SW_SHOW)

	;----------------------------
	; PLAYER 1
	;----------------------------
	GUICtrlCreateLabel("Player 1", 10, 5, 100)
	GUICtrlSetFont(-1, 12, 600, 0, $Font_Labels)
	GUIStartGroup()
	$Radio_P1a = GUICtrlCreateRadio("Human", 10, 30)
	$Radio_P1b = GUICtrlCreateRadio("CPU", 10, 50)
	GUICtrlSetState($Radio_P1a, $GUI_CHECKED)
	
	GUICtrlCreateLabel("", 85, 5, 20, 20);Longest jump
	;GUICtrlSetBkColor(-1, 0x000000)
	;GUICtrlCreateLabel("", 86, 6, 18, 18) ;Total moves
	GUICtrlSetBkColor(-1, $P1_Color)

	;----------------------------
	; PLAYER 2
	;----------------------------
	GUICtrlCreateLabel("Player 2", 225, 5, 100)
	GUICtrlSetFont(-1, 12, 600, 0, $Font_Labels)
	GUIStartGroup()
	$Radio_P2a = GUICtrlCreateRadio("Human", 235, 30)
	$Radio_P2b = GUICtrlCreateRadio("CPU", 235, 50)
	GUICtrlSetState($Radio_P2b, $GUI_CHECKED)

	GUICtrlCreateLabel("", 195, 5, 20, 20) ;Longest jump
	;GUICtrlSetBkColor(-1, 0x000000)
	;GUICtrlCreateLabel("", 196, 6, 18, 18) ;Total moves
	GUICtrlSetBkColor(-1, $P2_Color)

	$BTN_Start = GUICtrlCreateButton("Start", 120, 60, 60)
	
	$Check_Survival = GUICtrlCreateCheckbox("Survival Mode",110,95)
	$Check_Debug = GUICtrlCreateCheckbox("Debug Mode",110,115)
	$Check_Hints = GUICtrlCreateCheckbox("Show move hints",110,135)
	Check($Check_Hints)

	While 1
		Switch GUIGetMsg()
			Case $GUI_EVENT_CLOSE
				ExitLoop
			Case $BTN_Start
				;Player 1 type
				If IsChecked($Radio_P1a) Then
					$P1_Type = 1
				Else
					$P1_Type = 2
				EndIf

				;Player 2 type
				If IsChecked($Radio_P2a) Then
					$P2_Type = 1
				Else
					$P2_Type = 2
				EndIf
				
				;Setup Survival Mode
				If IsChecked($Check_Survival) Then
					$Game_Mode = 1
					$P1_Name = "HUMANS"
					$P2_Name = "UNDEAD"
					$Board_Color2 = 0x000000 ;Black
					$P2_Color = 0x8ea146;0x6e774d ;Olive green
					$P2_SelectColor = 0x566910
					$Title &= " - SURVIVAL MODE"
				EndIf
				If IsChecked($Check_Debug) Then $Debug = True
				If NOT IsChecked($Check_Hints) Then $Move_Symbol = ""

				ExitLoop
		EndSwitch
	WEnd
	GUIDelete()
EndFunc   ;==>Setup

; #EVENTS# =====================================================================================================================

;Click action for piece
Func ClickPiece()
	
	If $Jump_Count > 0 Then Return ;Ignore if player has already made a jump as part of multiple jumps
	
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
	
	If $Jump_Count > $P1_LongestJump Then $P1_LongestJump = $Jump_Count		

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

Func ClickReset()
	Debug("","ClickReset()")
	$P1_Score = 0
	$P2_Score = 0
	$P1_LongestJump = 0
	$P2_LongestJump = 0
	$P1_TotalMoves = 0
	$P2_TotalMoves = 0
	
	RefreshStats()
	
	FlushMoves()
	
	$CurrentPlayer = 1
	
	ToggleIndicator()
	
	$aBoard = $aPieces ;Swap live array with copy from start
	ResetPieces(1) ;IMPORTANT - unhide flag
EndFunc   ;==>ClickReset

;Skip move - DEBUG ONLY
Func ClickSkip()
	FlushMoves()
	$PiecePending = False
	$MovePending = False
EndFunc   ;==>ClickSkip

;EXIT
Func ClickClosed()
	Exit
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
	If Not $Count Then
		;MsgBox(0, "", "No moves available for player " & $CurrentPlayer)
	Else
		
		Shuffle2DArray($aTempPieces) ;Shuffle pieces so first available isn't always chosen
		Sort2DArray($aTempPieces,2) ;Sort pieces by weight
		
		$Piece_Selected[0] = $aTempPieces[0][0]
		$Piece_Selected[1] = $aTempPieces[0][1]
		
		$aMoves = $aTempPieces[0][3]
		HighlightMoves()
		Sleep(600) ;Delay for human player to see move take place
		
		;Take highest weighted move from highest weighted piece
		MovePiece($Piece_Selected[0], $Piece_Selected[1], $aMoves[0][0], $aMoves[0][1])
		FlushMoves()
	EndIf
EndFunc   ;==>CPU_Move

;Move piece located at X1,Y1 with piece at X2,Y2
Func MovePiece($XX1, $YY1, $XX2, $YY2)
	Debug("[" & $XX1 & "," & $YY1 & "] -> [" & $XX2 & "," & $YY2 & "]","MovePiece() - Player " & $CurrentPlayer)

	;If source square is empty, or destination is occupied, return
	If NOT IsOccupied($XX1,$YY1) Or IsOccupied($XX2,$YY2) Then Return 0
	
	GUICtrlSetPos($aBoard[$YY1][$XX1][0], $XX2 * $Cell_Width, $YY2 * $Cell_Height, $Cell_Width, $Cell_Height) ;Move piece

	;Copy all attributes
	For $Z = 0 To 2
		$aBoard[$YY2][$XX2][$Z] = $aBoard[$YY1][$XX1][$Z]
		$aBoard[$YY1][$XX1][$Z] = ""
	Next

	If IsOccupied($XX2, $YY2) AND (($YY2 = $Board_Rows - 1) OR ($YY2 = 0)) Then King($XX2,$YY2)
	
	Switch $CurrentPlayer
		Case 1
			$P1_TotalMoves += 1
		Case 2
			;If $Jump_Count > $P2_LongestJump Then $P2_LongestJump = $Jump_Count			
			$P2_TotalMoves += 1
	EndSwitch
	
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
		
		AddPoint() ;Increment score for current player
		Return SetError(0,1,1) ;Set extended to indicate jump
	EndIf

	;Redraw() ;Unnecessary
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
	$Piece_Selected[2] = GUICtrlCreateLabel("«",$Source_X * $Cell_Width, $Source_Y * $Cell_Height, $Cell_Width,$Cell_Height, BitOr($SS_CENTER,$SS_CENTERIMAGE))
	If $CurrentPlayer = 1 Then
		GUICtrlSetColor(-1, $P1_SelectColor)
	Else
		GUICtrlSetColor(-1, $P2_SelectColor)
	EndIf
	GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
	GUICtrlSetFont(-1, 25, "", "", $Font_Pieces)

	For $N = 0 to Ubound($aMoves)-1
		$X = $aMoves[$N][0]
		$Y = $aMoves[$N][1]
		$aMoves[$N][2] = GUICtrlCreateLabel($Move_Symbol, $X * $Cell_Width, $Y * $Cell_Height, $Cell_Width,$Cell_Height, BitOr($SS_CENTER,$SS_CENTERIMAGE))
		GUICtrlSetOnEvent(-1, "ClickMove")
		GUICtrlSetColor(-1, $Move_Color)
		GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
		GUICtrlSetFont(-1, 38, "", "", $Font_Pieces)
		Debug("Move controlid created: " & $aMoves[$N][2] & " at [" & $X & "," & $Y & "]","")
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

	Local $NumPieces_P1 = 0, $NumPieces_P2 = 0, $NumMoves_P1 = 0, $NumMoves_P2 = 0
	Local $aMovesTemp
	Local $CurrentPlayer_Backup = $CurrentPlayer ;FindMoves IsEnemy uses $CurrentPlayer

	;Search through all pieces and build array of pieces with moves available
	For $Y = 0 To $Board_Rows - 1
		For $X = 0 To $Board_Cols - 1
			If IsOccupied($X, $Y) AND IsShown($aBoard[$Y][$X][0]) Then
				$CurrentPlayer = $aBoard[$Y][$X][1] ;Update CurrentPlayer temporarily
				
				$aMovesTemp = FindMoves($X, $Y)
				
				Switch $CurrentPlayer
					Case 1
						$NumPieces_P1 += 1
						If IsArray($aMovesTemp) Then $NumMoves_P1 += 1
					Case 2
						$NumPieces_P2 += 1
						If IsArray($aMovesTemp) Then $NumMoves_P2 += 1
				EndSwitch
				
				$aMovesTemp = ""
			EndIf
		Next
	Next
	
	Debug("$NumPieces_P1 = " & $NumPieces_P1 & ", $NumPieces_P2 = " & $NumPieces_P2 & ", $NumMoves_P1 = " & $NumMoves_P1 & ", $NumMoves_P2 = " & $NumMoves_P2,"")
	
	If $NumPieces_P1 = 0 OR $NumPieces_P2 = 0 Then
	
		;Victory
		If $NumPieces_P2 = 0 Then
			;Player 1 wins
			MsgBox(0, "", "Player 1 is victorious!")
			;ClickReset()
			;Return
		ElseIf $NumPieces_P1 = 0 Then
			;Player 2 wins
			MsgBox(0, "", "Player 2 is victorious!")
			;ClickReset()
			;Return
		EndIf
		$CurrentPlayer = $CurrentPlayer_Backup
		ClickReset()
		Return
	EndIf
	
	If $NumMoves_P1 = 0 AND $NumMoves_P2 = 0 Then

		;Count number of pieces with moves available
		If $NumMoves_P2 = 0 Then
			MsgBox(0, "", "No moves available for Player 2")
			;ClickReset()
			;Return
		ElseIf $NumMoves_P1 = 0 Then
			MsgBox(0, "", "No moves available for Player 1")
			;ClickReset()
			;Return
		EndIf
		$CurrentPlayer = $CurrentPlayer_Backup
		ClickReset()
		Return
	EndIf
	
	$CurrentPlayer = $CurrentPlayer_Backup
EndFunc

;Add piece to board (must be called from CreatePieces() for it to show)
Func CreatePiece($XX,$YY,$PP,$CC,$K=0)
	;Generate label now so its controlid stays constant (instead of creating new labels on redraw)
	$aBoard[$YY][$XX][0] = GUICtrlCreateLabel("l", 0, 0, 0, 0, BitOR($SS_CENTER, $SS_CENTERIMAGE))
	GUICtrlSetOnEvent(-1, "ClickPiece")
	GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
	GUICtrlSetFont(-1, 47, "", "", $Font_Pieces)
	GUICtrlSetColor(-1, $CC)
	$aBoard[$YY][$XX][1] = $PP ;Assign piece to player
	If $K Then $aBoard[$YY][$XX][2] = True
	;Debug("Piece created for Player " & $PP & " @ [" & $XX & "," & $YY & "]","")
EndFunc

;This function will build the array, assigning default positions
Func CreatePieces()
	Debug("","CreatePieces()")

	Local $RowsPieces = Int(($Board_Rows / 2) - 1) ;This should create a buffer of two rows between teams
	Local $Flip = False
	Local $Player
	Local $Color
	
	If $Game_Mode = 0 Then
		;Create 3 rows of pieces from top of board
		For $Y = 0 To $Board_Rows  - 1
			For $X = 0 To $Board_Cols - 1
				;If within top or bottom 3 rows
				If ($Y < $RowsPieces) Then
					$Player = 1
					$Color = $P1_Color
					
					If $Flip Then CreatePiece($X,$Y,$Player,$Color)
				ElseIf ($Y >= ($Board_Rows-$RowsPieces)) Then
					;Create only bottom row - DEBUG ONLY
					;If ($Y=$Board_Rows-1) AND $X = 6 Then
						$Player = 2
						$Color = $P2_Color
						If $Flip Then CreatePiece($X,$Y,$Player,$Color)
					;EndIf
				Else
					ContinueLoop
				EndIf
				
				;If $Flip Then CreatePiece($X,$Y,$Player,$Color)
				$Flip = ($Flip=0)
			Next
			$Flip = ($Flip=0)
		Next
	Else
		;ULTRA INSANE SURVIVAL MODE
		For $Y = 0 To $Board_Rows  - 1
			For $X = 0 To $Board_Cols - 1
				;If within top or bottom 3 rows
				If ($Y < $RowsPieces) Then
					If $Y = 0 Then
						$Player = 1
						$Color = $P1_Color
						If $Flip Then CreatePiece($X,$Y,$Player,$Color,1)
					EndIf
				ElseIf ($Y >= ($Board_Rows-$RowsPieces-1)) Then
					$Player = 2
					$Color = $P2_Color
					If $Flip Then CreatePiece($X,$Y,$Player,$P2_Color)
				Else
					ContinueLoop
				EndIf
				
				;If $Flip Then CreatePiece($X,$Y,$Player,$Color)
				$Flip = ($Flip=0)
			Next
			$Flip = ($Flip=0)
		Next
	EndIf

	$aPieces = $aBoard ;Copy array for reset later

	ResetPieces() ;IMPORTANT
EndFunc   ;==>CreatePieces

;Generate game pieces based on position in array, team designation
Func ResetPieces($Unhide = 0)
	Debug("","ResetPieces()")
	
	For $Y = 0 To $Board_Rows - 1
		For $X = 0 To $Board_Cols - 1
			If NOT IsOccupied($X, $Y) Then ContinueLoop
				
			GUICtrlSetPos($aBoard[$Y][$X][0], $X * $Cell_Width, $Y * $Cell_Height, $Cell_Width, $Cell_Height) ;Move piece

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

;Draw static checkerboard
Func CreateBoard()
	Debug("","CreateBoard()")
	
	$BoardGraphic = GUICtrlCreateGraphic(0, 0, $Board_Width, $Board_Height)
	GUICtrlSetState(-1, $GUI_DISABLE) ;IMPORTANT
	GUICtrlSetBkColor(-1, $Board_Color2)

	Local $Flip = False
	For $Y = 0 To $Board_Rows - 1
		For $X = 0 To $Board_Cols - 1
			If $Flip Then
				;Draw square color1
				GUICtrlSetGraphic($BoardGraphic, $GUI_GR_COLOR, $Board_Color1, $Board_Color1)
				GUICtrlSetGraphic($BoardGraphic, $GUI_GR_RECT, $X * $Cell_Width, $Y * $Cell_Height, $Cell_Width, $Cell_Height)

				$Flip = False
			Else
				;Draw square color2
				;GUICtrlSetGraphic($boardGraphic,$GUI_GR_COLOR, $Board_Color2,$Board_Color2)
				$Flip = True
			EndIf
		Next
		$Flip = ($Flip=0)
	Next

	GUICtrlSetGraphic($BoardGraphic, $GUI_GR_REFRESH) ;Refresh graphic
EndFunc   ;==>CreateBoard

; #COMMON FUNCTIONS# ===================================================================================================================

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

Func RefreshStats()
	GUICtrlSetData($hP1_Score, $P1_Score)
	GUICtrlSetData($hP1_LongestJump,$P1_LongestJump)
	GUICtrlSetData($hP1_TotalMoves,$P1_TotalMoves)
	
	GUICtrlSetData($hP2_Score, $P2_Score)
	GUICtrlSetData($hP2_LongestJump,$P2_LongestJump)
	GUICtrlSetData($hP2_TotalMoves,$P2_TotalMoves)
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
	Debug("Waiting for player " & $CurrentPlayer & " to select a piece","WaitPiece() - Player " & $CurrentPlayer)
	While $PiecePending
		Sleep(10) ;Reduce cpu usage
	WEnd
EndFunc

;Loop until a move is chosen
Func WaitMove()
	Debug("Waiting for player " & $CurrentPlayer & " to select a move","WaitMove() - Player " & $CurrentPlayer)
	While $MovePending
		Sleep(10) ;Reduce cpu usage
	WEnd
EndFunc

;Increment score for current player
Func AddPoint()
	Switch $CurrentPlayer
		Case 1
			$P1_Score += 1
		Case 2
			$P2_Score += 1
	EndSwitch
	RefreshStats()
EndFunc

Func ToggleIndicator()
	Switch $CurrentPlayer
		Case 1
			GUICtrlSetState($hP2_Indicator, $GUI_HIDE)
			GUICtrlSetState($hP1_Indicator, $GUI_SHOW)
		Case 2
			GUICtrlSetState($hP1_Indicator, $GUI_HIDE)
			GUICtrlSetState($hP2_Indicator, $GUI_SHOW)
	EndSwitch
EndFunc

;Alternate player
Func TogglePlayer()
	RefreshStats()
	
	If $CurrentPlayer = 1 Then
		$CurrentPlayer = 2
	Else
		$CurrentPlayer = 1
	EndIf
	
	ToggleIndicator()	
EndFunc

;Return 0 if current player is human or 1 if current player is CPU
Func GetPlayerType()
	;Debug("","GetPlayerType() - Player " & $CurrentPlayer)
	Switch $CurrentPlayer
		Case 1
			Return $P1_Type
		Case 2
			Return $P2_Type
	EndSwitch
EndFunc   ;==>GetPlayerType

Func IsSimulation()
	If $P1_Type = 2 And $P2_Type = 2 Then Return True
	Return False
EndFunc   ;==>IsSimulation

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