#NoTrayIcon

#cs ----------------------------------------------------------------------------
AutoIt Version: 3.3.6.1
Author:      Garth Bigelow
email:       garthbigelow@gmail.com
Script Function: The board game IX
#ce ----------------------------------------------------------------------------
#include <ButtonConstants.au3>
#include <GUIConstantsEx.au3>
#Include <Misc.au3>
#include <WindowsConstants.au3>

Global Const $debug = True
Global Const $Size = 8 ; $Size + 1 is the number of squares (4, 6 or 8)

Global Const $Tribe    = 2^0 ;1
Global Const $Clan     = 2^1 ;2
Global Const $Hunter   = 2^2  ; used only for comparisions
Global Const $HunterN  = 2^3 ;8
Global Const $HunterS  = 2^4 ;16
Global Const $HunterE  = 2^5 ;32
Global Const $HunterW  = 2^6 ;64
Global Const $HunterNE = 2^7 ;128
Global Const $HunterNW = 2^8 ;256
Global Const $HunterSE = 2^9 ;512
Global Const $HunterSW = 2^10 ;1024
Global Const $Red      = 2^11 ;2048
Global Const $Green    = 2^12 ;4196

Global $CurrentPlayerTurn = $Red ; who starts the game
Global $TotalMoves = 0

Global Const $Black  = 2^13  ; no action
Global Const $Yellow = 2^14 ; selected
Global Const $Cyan   = 2^15  ; option

Dim $Board[($Size+1)][($Size+1)]
Dim $hBoard[($Size+1)][($Size+1)]
Dim $Color[($Size+1)][($Size+1)]
Dim $hColor[($Size+1)][($Size+1)]
Dim $holdBoard[($Size+1)][($Size+1)]
Dim $holdColor[($Size+1)][($Size+1)]

Global $RedCalc, $GreenCalc, $RedTribeCount, $GreenTribeCount

Local $hGUI = GUICreate("IX ver 0.02", 68 * ($Size+1) + 300, 68 * ($Size+1))
InitializeBoard()
GUISetState()
DrawBoard()

Local $hRedCount  = GUICtrlCreateButton("", 10, 68 * ($Size+1) - 40, 130, 30)
Local $hGreenCount  = GUICtrlCreateButton("", (68 * ($Size+1)) + 130 + 30, 68 * ($Size+1) - 40, 130, 30)
Local $hUndo = GUICtrlCreateButton("Undo", GetColumnX($CurrentPlayerTurn), 200, 130, 30)
GUICtrlSetState($hUndo, $GUI_HIDE)
BoardIsValid()

; the main loop
While True
	$msg = GUIGetMsg()
	Switch $msg
		Case $GUI_EVENT_CLOSE
			OnExit()
		Case $hUndo
			OkayBeep()
			$Board = $holdBoard
			$Color = $holdColor
			DrawBoard()
			NextPlayer()
			$TotalMoves -= 2
			GUICtrlDelete($hUndo)
	EndSwitch
	For $side = 0 to $Size
		For $fore = 0 to $Size
			If $msg = $hBoard[$fore][$side] Then
				If CheckPiece($Board[$fore][$side]) Then
					$holdBoard = $Board
					$holdColor = $Color

					If NeedAction($fore, $side) Then
						GUICtrlDelete($hUndo)

						DoAction($fore, $side)
						BoardIsValid()

						; Hack
						NextPlayer()
						$hUndo = GUICtrlCreateButton("Undo", GetColumnX($CurrentPlayerTurn), 200, 130, 30)
						NextPlayer()
						$TotalMoves -= 2
					EndIF
					ContinueLoop 3
				EndIf
			EndIf
		Next
	Next
	Sleep(25)
	If $RedCalc = 16 Then
		Msgbox(48, "Game Over", "Green wins after " & $TotalMoves & " moves.")
		Exit
	EndIf
	If $GreenCalc = 16 Then
		MsgBox(48, "Game Over", "Red wins after " & $TotalMoves & " moves.")
		Exit
	EndIf
	If $RedCalc = 17 And $GreenCalc = 17 Then
		MsgBox(48, "Game Over", "Draw! After " & $TotalMoves & " moves.")
		Exit
	EndIf
WEnd

Func GetColumnX($player)
	If $player = $Red Then
		Return 10
	Else
		Return (68 * ($Size+1)) + 130 + 30
	EndIf
EndFunc

Func CheckPiece($piece)
	If $debug Then ConsoleWrite("@@debug CheckPiece(" & $piece & ")" & @CRLF)

	Return BitAND($piece, $CurrentPlayerTurn)
EndFunc

Func OnExit()
	If $debug Then ConsoleWrite("@@debug OnExit()" & @CRLF)
	OkayBeep()
	If MsgBox(36, "Exit Program","End the Game?") = 6 Then
		GUIDelete($hGUI)
		Exit
	EndIf
EndFunc

Func WipeColor()
	If $debug Then ConsoleWrite("@@debug WipeColor()" & @CRLF)
	For $x = 0 to $Size
		For $y = 0 to $Size
			$Color[$x][$y] = 0
		Next
	Next
	DrawBoard()

EndFunc

Func DrawBoard()
	If $debug Then ConsoleWrite("@@debug DrawBoard()" & @CRLF)

	GUISetState(@SW_LOCK)
	For $x = 0 to $Size
		For $y = 0 to $Size
			GUICtrlSetImage ( $hColor[$x][$y], ColorName($Color[$x][$y]))
			GUICtrlSetImage ( $hBoard[$x][$y], PieceName($Board[$x][$y]))
		Next
	Next
	GUISetState(@SW_UNLOCK)
	Return 1

EndFunc

Func BoardIsValid()
	If $debug Then ConsoleWrite("@@debug BoardIsValid()" & @CRLF)

	$RedCalc = 0
	$GreenCalc = 0
	$RedTribeCount = 0
	$GreenTribeCount = 0
	For $x = 0 To $Size
		For $y = 0 To $Size
			Switch $Board[$x][$y]
				Case 0
				Case $Tribe + $Red
					$RedTribeCount += 1
					$RedCalc += 16
				Case $Clan + $Red
					$RedCalc += 4
				Case $Tribe + $Green
					$GreenTribeCount += 1
					$GreenCalc += 16
				Case $Clan + $Green
					$GreenCalc += 4
				Case Else
					If $Board[$x][$y] < $Green Then
						$RedCalc += 1
					Else
						$GreenCalc += 1
					EndIf
			EndSwitch
		Next
	Next
	; last tribe rule
	If $RedTribeCount = 0 Or $GreenTribeCount = 0 Then
		Msgbox(0, "Warning", "No turn can be made which removes the last Tribe")
		$Board = $holdBoard
		$Color = $holdColor
		DrawBoard()
		Return 0
	EndIf
	GUICtrlSetData($hRedCount, "Count: " & $RedCalc)
	GUICtrlSetData($hGreenCount, "Count: " & $GreenCalc)

	Return 1
EndFunc

; create the board picture handles
; and set all pieces to opening positions
Func InitializeBoard()
	If $debug Then ConsoleWrite("@@debug InitializeBoard()" & @CRLF)

	For $x = 0 To $Size
		For $y = 0 To $Size

			$Color[$x][$y]  = $Black
			$hColor[$x][$y] = GUICtrlCreatePic(ColorName($Color[$x][$y]), $x * 68 + 150, $y * 68, 68, 68, $gui_disable)

			$Board[$x][$y] = 0  ; empty squares
			$hBoard[$x][$y] = GUICtrlCreateButton("", $x * 68 + 2 + 150, $y * 68 + 2, 64, 64, BitOR($BS_BITMAP, $BS_FLAT))
		Next
	Next
	For $x = 1 to ($Size - 1) Step 2
		$Board[0][$x] = $Tribe + $Red
		$Board[$Size][$x] = $Tribe + $Green
	Next

EndFunc

Func NextPlayer()
	If $debug Then ConsoleWrite("@@debug NextPlayer()" & @CRLF)

	OkayBeep()
	If $CurrentPlayerTurn = $Red Then
		$CurrentPlayerTurn = $Green
	Else
		$CurrentPlayerTurn = $Red
	EndIf

	$TotalMoves += 1
EndFunc

Func NeedAction($fore, $side)
	If $debug Then ConsoleWrite("@@debug DoAction(" & $fore & ", " & $side & ")" & @CRLF)

	Switch $Board[$fore][$side]
		Case 0 ; empy square
			Return 1
		Case $Tribe + $CurrentPlayerTurn; tribe
			Return 1
		Case $Clan + $CurrentPlayerTurn; clan
			Return 1
		Case Else
			Return 1
	EndSwitch

	Return 0
EndFunc

Func DoAction($fore, $side)
	If $debug Then ConsoleWrite("@@debug DoAction(" & $fore & ", " & $side & ")" & @CRLF)

	Switch $Board[$fore][$side]
		Case 0 ; empy square
			BadBeep()
		Case $Tribe + $CurrentPlayerTurn; tribe
			Tribe($fore, $side)
		Case $Clan + $CurrentPlayerTurn; clan
			Clan($fore, $side)
		Case Else
			Hunter($fore, $side)
	EndSwitch
EndFunc

Func Tribe($fore, $side)
	If $debug Then ConsoleWrite("@@debug Tribe(" & $fore & ", " & $side & ")" & @CRLF)

	ValidBeep()
	$Color[$fore][$side] = $Yellow
	$hSplit  = GUICtrlCreateButton("Split", GetColumnX($CurrentPlayerTurn), 10, 130, 30)
	If $fore = 0 Or $fore = $Size Or $side = 0 Or $side = $Size Then
		$hRemove = GUICtrlCreateButton("Remove", GetColumnX($CurrentPlayerTurn), 50, 130, 30)
		$CancelLine = 90
	Else
		$hRemove = GUICtrlCreateDummy()
		$CancelLine = 50
	EndIf
	$hCancel = GUICtrlCreateButton("Cancel", GetColumnX($CurrentPlayerTurn), $CancelLine, 130, 30)

	While True
		$msg = GUIGetMsg()
		If $msg = $GUI_EVENT_CLOSE Then
			OnExit()
		EndIf
		If $msg = $hCancel Then
			OkayBeep()
			$Color[$fore][$side] = $Black
			DrawBoard()
			GUICtrlDelete($hSplit)
			GUICtrlDelete($hRemove)
			GUICtrlDelete($hCancel)
			Return
		EndIf
		If $msg = $hRemove Then
			OkayBeep()
			$Color[$fore][$side] = $Black
			$Board[$fore][$side] = 0
			DrawBoard()
			GUICtrlDelete($hSplit)
			GUICtrlDelete($hRemove)
			GUICtrlDelete($hCancel)
			If BoardIsValid() Then
				NextPlayer()
			Else
				DrawBoard()
			EndIf
			Return
		EndIf
		If $msg = $hSplit Then
			OkayBeep()
			$Color[$fore][$side] = $Black
			$Board[$fore][$side] = 0
			If $fore > 0 And $side > 0 Then $Board[$fore-1][$side-1] = $Clan + $CurrentPlayerTurn
			If $fore > 0 And $side < $Size Then $Board[$fore-1][$side+1] = $Clan + $CurrentPlayerTurn
			If $fore < $Size And $side > 0 Then $Board[$fore+1][$side-1] = $Clan + $CurrentPlayerTurn
			If $fore < $Size And $side < $Size Then $Board[$fore+1][$side+1] = $Clan + $CurrentPlayerTurn
			DrawBoard()
			GUICtrlDelete($hSplit)
			GUICtrlDelete($hRemove)
			GUICtrlDelete($hCancel)
			If BoardIsValid() Then
				NextPlayer()
			Else
				DrawBoard()
			EndIf
			Return
		EndIf
		For $aside = 0 to $Size
			For $afore = 0 to $Size
				If $msg = $hBoard[$afore][$aside] Then
					If $fore = $afore And $side = $aside Then
						OkayBeep()
						$Color[$fore][$side] = $Black
						GUICtrlDelete($hSplit)
						GUICtrlDelete($hRemove)
						GUICtrlDelete($hCancel)
						DrawBoard()
						Return
					EndIf
					If ValidateTribeMove($fore, $side, $afore, $aside) Then
						ValidBeep()
						$Color[$fore][$side] = $Black
						$Board[$fore][$side] = 0
						$Color[$afore][$aside] = $Black
						$Board[$afore][$aside] = $Tribe + $CurrentPlayerTurn
						DrawBoard()
						GUICtrlDelete($hSplit)
						GUICtrlDelete($hRemove)
						GUICtrlDelete($hCancel)
						If BoardIsValid() Then
							NextPlayer()
						Else
							DrawBoard()
						EndIf
						Return
					Endif
					BadBeep()
				EndIf
			Next
		Next
	WEnd
EndFunc

Func ValidateTribeMove($baseF, $baseS, $newF, $newS)
	If $debug Then ConsoleWrite("@@debug ValidateTribeMove(" & $baseF & ", " & $baseS & ", " & $newF & ", " & $newS & ")" & @CRLF)

	If $baseF = $newF And $baseS = $newS + 1 Then return 1
	If $baseF = $newF And $baseS = $newS - 1 Then return 1
	If $baseS = $newS And $baseF = $newF + 1 Then return 1
	If $baseS = $newS And $baseF = $newF - 1 Then return 1
	Return 0

EndFunc

Func Clan($fore, $side)
	If $debug Then ConsoleWrite("@@debug Clan(" & $fore & ", " & $side & ")" & @CRLF)

	ValidBeep()
	$Color[$fore][$side] = $Yellow
	DrawBoard()
	$hSplit  = GUICtrlCreateButton("Split", GetColumnX($CurrentPlayerTurn), 10, 130, 30)
	If $fore = 0 Or $fore = $Size Or $side = 0 Or $side = $Size Then
		$hRemove = GUICtrlCreateButton("Remove", GetColumnX($CurrentPlayerTurn), 50, 130, 30)
		$CancelLine = 90
	Else
		$hRemove = GUICtrlCreateDummy()
		$CancelLine = 50
	EndIf
	$hCancel = GUICtrlCreateButton("Cancel", GetColumnX($CurrentPlayerTurn), $CancelLine, 130, 30)

	While True
		$msg = GUIGetMsg()
		If $msg = $GUI_EVENT_CLOSE Then
			OnExit()
		EndIf
		If $msg = $hCancel Then
			OkayBeep()
			$Color[$fore][$side] = $Black
			DrawBoard()
			GUICtrlDelete($hSplit)
			GUICtrlDelete($hRemove)
			GUICtrlDelete($hCancel)
			Return
		EndIf
		If $msg = $hRemove Then
			OkayBeep()
			$Color[$fore][$side] = $Black
			$Board[$fore][$side] = 0
			DrawBoard()
			GUICtrlDelete($hSplit)
			GUICtrlDelete($hRemove)
			GUICtrlDelete($hCancel)
			NextPlayer()
			Return
		EndIf
		If $msg = $hSplit Then
			OkayBeep()
			$Color[$fore][$side] = $Black
			$Board[$fore][$side] = 0
			If $side > 0 Then $Board[$fore][$side-1] = HunterAdjust($fore, $side-1, $HunterN) + $CurrentPlayerTurn
			If $fore > 0 Then $Board[$fore-1][$side] = HunterAdjust($fore-1, $side, $HunterW) + $CurrentPlayerTurn
			If $fore < $Size Then $Board[$fore+1][$side] = HunterAdjust($fore+1, $side, $HunterE) + $CurrentPlayerTurn
			If $side < $Size Then $Board[$fore][$side+1] = HunterAdjust($fore, $side+1, $HunterS) + $CurrentPlayerTurn
			DrawBoard()
			GUICtrlDelete($hSplit)
			GUICtrlDelete($hRemove)
			GUICtrlDelete($hCancel)
			If BoardIsValid() Then
				NextPlayer()
			Else
				DrawBoard()
			EndIf
			Return
		EndIf
		For $aside = 0 to $Size
			For $afore = 0 to $Size
				If $msg = $hBoard[$afore][$aside] Then
					If $fore = $afore And $side = $aside Then
						OkayBeep()
						$Color[$fore][$side] = $Black
						GUICtrlDelete($hSplit)
						GUICtrlDelete($hRemove)
						GUICtrlDelete($hCancel)
						DrawBoard()
						Return
					EndIf
					If ValidateClanMove($fore, $side, $afore, $aside) Then
						ValidBeep()
						$Color[$fore][$side] = $Black
						$Board[$fore][$side] = 0
						$Color[$afore][$aside] = $Black
						$Board[$afore][$aside] = $Clan + $CurrentPlayerTurn
						DrawBoard()
						GUICtrlDelete($hSplit)
						GUICtrlDelete($hRemove)
						GUICtrlDelete($hCancel)
						If BoardIsValid() Then
							NextPlayer()
						Else
							DrawBoard()
						EndIf
						Return
					Endif
					BadBeep()
				EndIf
			Next
		Next
	WEnd
EndFunc

Func ValidateClanMove($baseF, $baseS, $newF, $newS)
	If $debug Then ConsoleWrite("@@debug ValidateClanMove(" & $baseF & ", " & $baseS & ", " & $newF & ", " & $newS & ")" & @CRLF)

	If $baseF = $newF + 1 And $baseS = $newS + 1 Then return 1
	If $baseF = $newF - 1 And $baseS = $newS - 1 Then return 1
	If $baseS = $newS + 1 And $baseF = $newF - 1 Then return 1
	If $baseS = $newS - 1 And $baseF = $newF + 1 Then return 1
	Return 0

EndFunc

Func HunterAdjust($fore, $side, $newpiece)

	If $debug Then ConsoleWrite("@@debug HunterAdjust(" & $fore & ", " & $side & ", " & $newpiece & ")" & @CRLF)

	; Get the piece already on the new location
	$originalpiece = $Board[$fore][$side]
	; Remove its color
	If $originalpiece > $Green Then $originalpiece -= $Green
	If $originalpiece > $Red   Then $originalpiece -= $Red
	; If its not a Hunter do not change the new Hunter
	If $originalpiece < $Hunter Then Return $newpiece
	; Make new Hunter 180 degrees from old Hunter
	Switch $originalpiece
		Case $HunterS
			Return $HunterN
		Case $HunterSE
			Return $HunterNW
		Case $HunterE
			Return $HunterW
		Case $HunterNE
			Return $HunterSW
		Case $HunterN
			Return $HunterS
		Case $HunterNW
			Return $HunterSW
		Case $HunterW
			Return $HunterE
		Case $HunterSW
			Return $HunterSE
	EndSwitch
	; unknown game piece if this is reached
	MsgBox(0, "Fatal Error 3", "Invalid piece: " & $originalpiece)
	Exit
EndFunc

Func IsRemoveHunterValid($fore, $side)
	If $debug Then ConsoleWrite("@@debug IsRemoveHunterValid(" & $fore & ", " & $side & ")")

	$piece = $Board[$fore][$side] - $CurrentPlayerTurn
	Switch $piece
		Case $HunterN
			If $side = 0 Then Return 1
			If $fore = 0 Then Return 1
			If $fore = $Size Then Return 1
			Return 0
		Case $HunterS
			If $side = $Size Then Return 1
			If $fore = 0 Then Return 1
			If $fore = $Size Then Return 1
		Case $HunterW
			If $fore = 0 Then Return 1
			If $side = 0 Then Return 1
			If $side = $Size Then Return 1
		Case $HunterE
			If $fore = $Size Then Return 1
			If $side = 0 Then Return 1
			If $side = $Size Then Return 1
		Case $HunterNE
			If $fore = 0 Then Return 1
			If $side = 0 Then Return 1
		Case $HunterNW
			If $fore = $Size Then Return 1
			If $side = 0 Then Return 1
		Case $HunterSE
			If $fore = 0 Then Return 1
			If $side = $Size Then Return 1
		Case $HunterSW
			If $fore = 1 Then Return 1
			If $side = 1 Then Return 1
		Case Else
			MsgBox(0,"Fatal Error 5","Invalid Piece: " & $piece)
			Exit
	EndSwitch
	Return 0

EndFunc

Func Hunter($fore, $side)

	If $debug Then ConsoleWrite("@@debug Hunter(" & $fore & ", " & $side & ")")

	ValidBeep()
	$Color[$fore][$side] = $Yellow
	DrawBoard()
	$hLeft90  = GUICtrlCreateButton("Rotate 90 Degrees" & @CRLF & "Counter Clockwise", GetColumnX($CurrentPlayerTurn), 10, 130, 40, $BS_MULTILINE)
	$hLeft45  = GUICtrlCreateButton("Rotate 45 Degrees" & @CRLF & "Counter Clockwise", GetColumnX($CurrentPlayerTurn), 50, 130, 40, $BS_MULTILINE)
	$hRight45 = GUICtrlCreateButton("Rotate 45 Degrees" & @CRLF & "Clockwise", GetColumnX($CurrentPlayerTurn), 90, 130, 40, $BS_MULTILINE)
	$hRight90 = GUICtrlCreateButton("Rotate 90 Degrees" & @CRLF & "Clockwise", GetColumnX($CurrentPlayerTurn), 130, 130, 40, $BS_MULTILINE)
	If IsRemoveHunterValid($fore, $side) Then
		$hRemove = GUICtrlCreateButton("Remove", GetColumnX($CurrentPlayerTurn), 170, 130, 30)
		$CancelLine = 200
	Else
		$hRemove = GUICtrlCreateDummy()
		$CancelLine = 170
	EndIf
	$hCancel = GUICtrlCreateButton("Cancel", GetColumnX($CurrentPlayerTurn), $CancelLine, 130, 30)

	While True
		$msg = GUIGetMsg()
		If $msg = $GUI_EVENT_CLOSE Then
			OnExit()
		EndIf
		If $msg = $hCancel Then
			OkayBeep()
			$Color[$fore][$side] = $Black
			DrawBoard()
			ExitLoop
		EndIf
		If $msg = $hRemove Then
			OkayBeep()
			$Color[$fore][$side] = $Black
			$Board[$fore][$side] = 0
			If $side = 1 Then
				$Board[$fore][0] = 0
			EndIf
			DrawBoard()
			GUICtrlDelete($hLeft45)
			GUICtrlDelete($hLeft90)
			GUICtrlDelete($hRight45)
			GUICtrlDelete($hRight90)
			GUICtrlDelete($hCancel)
			GUICtrlDelete($hRemove)
			GUICtrlDelete($hCancel)
			NextPlayer()
			Return
		EndIf
		If $msg = $hLeft45 Then TurnHunter($fore, $side, 1)
		If $msg = $hLeft90 Then TurnHunter($fore, $side, 2)
		If $msg = $hRight45 Then TurnHunter($fore, $side, 3)
		If $msg = $hRight90 Then TurnHunter($fore, $side, 4)
		If $msg = $hLeft45 Or $msg = $hLeft90 Or $msg = $hRight45 Or $msg = $hRight90 Then
			$Color[$fore][$side] = $Black
			DrawBoard()
			GUICtrlDelete($hLeft45)
			GUICtrlDelete($hLeft90)
			GUICtrlDelete($hRight45)
			GUICtrlDelete($hRight90)
			GUICtrlDelete($hCancel)
			GUICtrlDelete($hRemove)
			GUICtrlDelete($hCancel)
			NextPlayer()
			Return
		EndIf
		For $aside = 0 to $Size
			For $afore = 0 to $Size
				If $msg = $hBoard[$afore][$aside] Then
					; turn off selection if piece is clicked again
					If $fore = $afore And $side = $aside Then
						OkayBeep()
						$Color[$fore][$side] = $Black
							DrawBoard()
						ExitLoop 3
					EndIf
					If ValidateHunterMove($fore, $side, $afore, $aside) Then
						ValidBeep()
						$piece = $Board[$fore][$side]
						$Board[$fore][$side] = 0
						$Color[$afore][$aside] = $Black
						$Board[$afore][$aside] = $piece
						GUICtrlDelete($hLeft45)
						GUICtrlDelete($hLeft90)
						GUICtrlDelete($hRight45)
						GUICtrlDelete($hRight90)
						GUICtrlDelete($hCancel)
						GUICtrlDelete($hRemove)
						GUICtrlDelete($hCancel)
						$Color[$fore][$side] = $Black
						DrawBoard()
						If BoardIsValid() Then NextPlayer()
					Return
					Endif
					BadBeep()
				EndIf
			Next
		Next
	WEnd
	$Color[$fore][$side] = $Black
	DrawBoard()
	GUICtrlDelete($hLeft45)
	GUICtrlDelete($hLeft90)
	GUICtrlDelete($hRight45)
	GUICtrlDelete($hRight90)
	GUICtrlDelete($hCancel)
	GUICtrlDelete($hRemove)
	GUICtrlDelete($hCancel)

EndFunc

Func TurnHunter($fore, $side, $mode)
	If $debug Then ConsoleWrite("@@debug TurnHunter(" & $fore & ", " & $side & "," & $mode & ")")

	Const $L45 = 1
	Const $L90 = 2
	Const $R45 = 3
	Const $R90 = 4

	OkayBeep()

	Switch $Board[$fore][$side] - $CurrentPlayerTurn
		Case $HunterN
			If $mode = $L45 Then $Board[$fore][$side] = $HunterNW + $CurrentPlayerTurn
			If $mode = $L90 Then $Board[$fore][$side] = $HunterW + $CurrentPlayerTurn
			If $mode = $R45 Then $Board[$fore][$side] = $HunterNE + $CurrentPlayerTurn
			If $mode = $R90 Then $Board[$fore][$side] = $HunterE + $CurrentPlayerTurn
		Case $HunterS
			If $mode = $R45 Then $Board[$fore][$side] = $HunterSW + $CurrentPlayerTurn
			If $mode = $R90 Then $Board[$fore][$side] = $HunterW + $CurrentPlayerTurn
			If $mode = $L45 Then $Board[$fore][$side] = $HunterSE + $CurrentPlayerTurn
			If $mode = $L90 Then $Board[$fore][$side] = $HunterE + $CurrentPlayerTurn
		Case $HunterE
			If $mode = $L45 Then $Board[$fore][$side] = $HunterNE + $CurrentPlayerTurn
			If $mode = $R90 Then $Board[$fore][$side] = $HunterS + $CurrentPlayerTurn
			If $mode = $R45 Then $Board[$fore][$side] = $HunterSE + $CurrentPlayerTurn
			If $mode = $L90 Then $Board[$fore][$side] = $HunterN + $CurrentPlayerTurn
		Case $HunterW
			If $mode = $R45 Then $Board[$fore][$side] = $HunterNW + $CurrentPlayerTurn
			If $mode = $L90 Then $Board[$fore][$side] = $HunterS + $CurrentPlayerTurn
			If $mode = $L45 Then $Board[$fore][$side] = $HunterSW + $CurrentPlayerTurn
			If $mode = $R90 Then $Board[$fore][$side] = $HunterN + $CurrentPlayerTurn
		Case $HunterNE
			If $mode = $L45 Then $Board[$fore][$side] = $HunterN + $CurrentPlayerTurn
			If $mode = $R90 Then $Board[$fore][$side] = $HunterSE + $CurrentPlayerTurn
			If $mode = $R45 Then $Board[$fore][$side] = $HunterE + $CurrentPlayerTurn
			If $mode = $L90 Then $Board[$fore][$side] = $HunterNW + $CurrentPlayerTurn
		Case $HunterNW
			If $mode = $L45 Then $Board[$fore][$side] = $HunterW + $CurrentPlayerTurn
			If $mode = $R90 Then $Board[$fore][$side] = $HunterNE + $CurrentPlayerTurn
			If $mode = $R45 Then $Board[$fore][$side] = $HunterN + $CurrentPlayerTurn
			If $mode = $L90 Then $Board[$fore][$side] = $HunterSW + $CurrentPlayerTurn
		Case $HunterSE
			If $mode = $L45 Then $Board[$fore][$side] = $HunterE + $CurrentPlayerTurn
			If $mode = $R90 Then $Board[$fore][$side] = $HunterSW + $CurrentPlayerTurn
			If $mode = $R45 Then $Board[$fore][$side] = $HunterS + $CurrentPlayerTurn
			If $mode = $L90 Then $Board[$fore][$side] = $HunterNE + $CurrentPlayerTurn
		Case $HunterSW
			If $mode = $L45 Then $Board[$fore][$side] = $HunterS + $CurrentPlayerTurn
			If $mode = $R90 Then $Board[$fore][$side] = $HunterNW + $CurrentPlayerTurn
			If $mode = $R45 Then $Board[$fore][$side] = $HunterW + $CurrentPlayerTurn
			If $mode = $L90 Then $Board[$fore][$side] = $HunterSE + $CurrentPlayerTurn
		EndSwitch

EndFunc

Func ValidateHunterMove($baseF, $baseS, $newF, $newS)
	If $debug Then ConsoleWrite("@@debug ValidateHunterMove(" & $baseF & ", " & $baseS & ", " & $newF & ", " & $newS & ")" & @CRLF)

	Switch $Board[$baseF][$baseS] - $CurrentPlayerTurn
		Case $HunterN
			If $baseS = $newS + 1 And Abs($baseF - $newF) <= 1 Then Return 1
			If $baseS = $newS + 2 And $baseF = $newF Then
				$Board[$baseF][$BaseS-1] = 0  ; remove inbetween spot (much less code if placed here)
				Return 1
			EndIf
		Case $HunterS
			If $baseS = $newS - 1 And Abs($baseF - $newF) <= 1 Then Return 1
			If $baseS = $newS - 2 And $baseF = $newF Then
				$Board[$baseF][$BaseS+1] = 0  ; remove inbetween spot (much less code if placed here)
				Return 1
			EndIf
		Case $HunterE
			If $baseF = $newF - 1 And Abs($baseS - $newS) <= 1 Then Return 1
			If $baseS = $newS And $baseF = $newF - 2 Then
				$Board[$baseF+1][$BaseS] = 0  ; remove inbetween spot (much less code if placed here)
				Return 1
			EndIf
		Case $HunterW
			If $baseF = $newF + 1 And Abs($baseS - $newS) <= 1 Then Return 1
			If $baseS = $newS And $baseF = $newF + 2 Then
				$Board[$baseF-1][$BaseS] = 0  ; remove inbetween spot (much less code if placed here)
				Return 1
			EndIf
		Case $HunterNE
			If $baseS = $newS + 1 And $baseF = $newF - 1 Then Return 1
			If $baseS = $newS + 2 And $baseF = $newF - 2 Then
				$Board[$newF-1][$newS+1] = 0  ; remove inbetween spot (much less code if placed here)
				Return 1
			EndIf
			If $baseS = $newS + 1 And $baseF = $newF Then Return 1
			If $baseS = $newS And $baseF = $newF - 1 Then Return 1
		Case $HunterSE
			If $baseS = $newS - 1 And $baseF = $newF - 1 Then Return 1
			If $baseS = $newS - 2 And $baseF = $newF - 2 Then
				$Board[$newF-1][$newS-1] = 0  ; remove inbetween spot (much less code if placed here)
				Return 1
			EndIf
			If $baseS = $newS - 1 And $baseF = $newF Then Return 1
			If $baseS = $newS And $baseF = $newF - 1 Then Return 1
		Case $HunterNW
			If $baseS = $newS + 1 And $baseF = $newF + 1 Then Return 1
			If $baseS = $newS + 2 And $baseF = $newF + 2 Then
				$Board[$newF+1][$newS+1] = 0  ; remove inbetween spot (much less code if placed here)
				Return 1
			EndIf
			If $baseS = $newS + 1 And $baseF = $newF Then Return 1
			If $baseS = $newS And $baseF = $newF + 1 Then Return 1
		Case $HunterSW
			If $baseS = $newS - 1 And $baseF = $newF + 1 Then Return 1
			If $baseS = $newS - 2 And $baseF = $newF + 2 Then
				$Board[$newF+1][$newS-1] = 0  ; remove inbetween spot (much less code if placed here)
				Return 1
			EndIf
			If $baseS = $newS - 1 And $baseF = $newF Then Return 1
			If $baseS = $newS And $baseF = $newF + 1 Then Return 1

	EndSwitch
	Return 0

EndFunc
; return the name of the square color for a given color
Func ColorName($setting)

	Switch $setting
		Case $Black
			$FileName = @scriptdir & "\Images\Black.bmp"
		Case $Yellow
			$FileName = @scriptdir & "\Images\Yellow.bmp"
		Case $Cyan
			$FileName = @scriptdir & "\Images\Cyan.bmp"
		Case Else
			MsgBox(0, "Fatal Error 2", "Invalid Square Color: " & $setting)
			Exit
	EndSwitch
	Return $FileName

EndFunc

; return the file name for a given shape
Func PieceName($piece)

	Switch $piece
		Case 0
			$FileName = @scriptdir & "\Images\Square.bmp"
		Case $Tribe + $Red
			$FileName = @scriptdir & "\Images\Red Tribe.bmp"
		Case $Tribe + $Green
			$FileName = @scriptdir & "\Images\Green Tribe.bmp"
		Case $Clan + $Red
			$FileName = @scriptdir & "\Images\Red Clan.bmp"
		Case $Clan + $Green
			$FileName = @scriptdir & "\Images\Green Clan.bmp"
		Case $HunterN + $Red
			$FileName = @scriptdir & "\Images\Red Hunter North.bmp"
		Case $HunterN + $Green
			$FileName = @scriptdir & "\Images\Green Hunter North.bmp"
		Case $HunterS + $Red
			$FileName = @scriptdir & "\Images\Red Hunter South.bmp"
		Case $HunterS + $Green
			$FileName = @scriptdir & "\Images\Green Hunter South.bmp"
		Case $HunterE + $Red
			$FileName = @scriptdir & "\Images\Red Hunter East.bmp"
		Case $HunterE + $Green
			$FileName = @scriptdir & "\Images\Green Hunter East.bmp"
		Case $HunterW + $Red
			$FileName = @scriptdir & "\Images\Red Hunter West.bmp"
		Case $HunterW + $Green
			$FileName = @scriptdir & "\Images\Green Hunter West.bmp"
		Case $HunterNE + $Red
			$FileName = @scriptdir & "\Images\Red Hunter NorthEast.bmp"
		Case $HunterNE + $Green
			$FileName = @scriptdir & "\Images\Green Hunter NorthEast.bmp"
		Case $HunterNW + $Red
			$FileName = @scriptdir & "\Images\Red Hunter NorthWest.bmp"
		Case $HunterNW + $Green
			$FileName = @scriptdir & "\Images\Green Hunter NorthWest.bmp"
		Case $HunterSE + $Red
			$FileName = @scriptdir & "\Images\Red Hunter SouthEast.bmp"
		Case $HunterSE + $Green
			$FileName = @scriptdir & "\Images\Green Hunter SouthEast.bmp"
		Case $HunterSW + $Red
			$FileName = @scriptdir & "\Images\Red Hunter SouthWest.bmp"
		Case $HunterSW + $Green
			$FileName = @scriptdir & "\Images\Green Hunter SouthWest.bmp"
		Case Else
			MsgBox(0, "Fatal Error 1","Invalid Piece Number: " & $piece)
			DebugEval()
			Exit
	EndSwitch
	If Not FileExists($FileName) Then
		msgbox(0,"Fatal Error","Image file: " & $FileName & " not found.")
		Exit
	EndIf
	Return $FileName

EndFunc

Func DebugEval()
	$d = ""
	While 1
		$s = InputBox("Eval me this", $d)
		If @error Then ExitLoop
		$d = Execute($s)
	WEnd
EndFunc

Func BadBeep()

	Beep(300,200)

EndFunc

Func OkayBeep()

	Beep(500, 150)

EndFunc

Func ValidBeep()

	beep(800, 200)

EndFunc


