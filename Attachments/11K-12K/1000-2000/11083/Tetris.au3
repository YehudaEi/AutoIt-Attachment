#NoTrayIcon

#include <GUIConstants.au3>

AutoItSetOption("MustDeclareVars", 1)

Global Const $BOARD_WIDTH = 10
Global Const $BOARD_HEIGHT = 20
Global Const $EMPTY_COLOUR = -1
Global Const $TOWER_COLOUR = 0xff0000
Global Const $BOX_COLOUR = 0x00ff00
Global Const $PYRAMID_COLOUR = 0xffff00
Global Const $LLEANER_COLOUR = 0xffa500
Global Const $RLEANER_COLOUR = 0xff00ff
Global Const $LKNIGHT_COLOUR = 0x40e0d0
Global Const $RKNIGHT_COLOUR = 0xff1493

Global $g_lblGameBoard[$BOARD_WIDTH][$BOARD_HEIGHT]
Global $g_lblPreviewBoard[4][4]
Global $g_aBoard[$BOARD_WIDTH][$BOARD_HEIGHT]
Global $g_aGameShape[4][4], $g_aPreShape[4][4]
Global $g_nShapeX, $g_nShapeY
Global $g_nGameTick
Global $g_lblScore
Global $g_btnMoveLeft, $g_btnMoveRight
Global $g_btnRotate, $g_btnDrop
Global $g_btnStart
Global $g_bGameStarted = False
Global $msg

GUICreate("AutoIT Tetris", 490, 560)

_DrawGameBoard()
_DrawPreviewBoard()

$g_lblScore = GUICtrlCreateLabel("SCORE: 0", 305, 200, 165, 20, $SS_CENTER)
GUICtrlSetFont(-1, 10, 800)

$g_btnMoveLeft = GUICtrlCreateButton("Move Left", 305, 280, 80, 25)
$g_btnMoveRight = GUICtrlCreateButton("Move Right", 390, 280, 80, 25)

$g_btnRotate = GUICtrlCreateButton("Rotate", 305, 320, 80, 25)
$g_btnDrop = GUICtrlCreateButton("Drop", 390, 320, 80, 25)

$g_btnStart = GUICtrlCreateButton("START", 350, 400, 80, 35)
GUICtrlSetState(-1, $GUI_FOCUS)

GUISetState(@SW_SHOW)

While 1
	$msg = GuiGetMsg()
	Select
	Case $msg = $GUI_EVENT_CLOSE
		ExitLoop
	Case $msg = $g_btnStart
		GUICtrlSetState($g_btnStart, $GUI_DISABLE)
		_NewGame()
	Case $msg = $g_btnMoveLeft
		_MoveShape(-1, 0)
	Case $msg = $g_btnMoveRight
		_MoveShape(1, 0)
	Case $msg = $g_btnRotate
		_RotateShape()
	Case $msg = $g_btnDrop
		AdlibRegister("_MoveShapeDown", 25)
	EndSelect
WEnd
GUIDelete()

Func _NewShape()
	Local $nShape, $i, $j

	For $i = 0 To 3
		For $j = 0 To 3
			$g_aGameShape[$i][$j] = $EMPTY_COLOUR
		Next
	Next

	$g_nShapeX = ($BOARD_WIDTH/2)-2
	$g_nShapeY = -1
	If Not $g_bGameStarted Then
		$nShape = Random(1, 7, 1)
		; Block types
		;  1   2   3   4   5    6   7
		;  X
		;  X   XX   X  XX   XX  XX   XX
		;  X   XX  XXX  XX XX    X   X
		;  X                     X   X
		Switch $nShape
			Case 1
				; Tower
				$g_aGameShape[1][0] = $TOWER_COLOUR
				$g_aGameShape[1][1] = $TOWER_COLOUR
				$g_aGameShape[1][2] = $TOWER_COLOUR
				$g_aGameShape[1][3] = $TOWER_COLOUR
				$g_nShapeY = 0
			Case 2
				; Box
				$g_aGameShape[1][1] = $BOX_COLOUR
				$g_aGameShape[1][2] = $BOX_COLOUR
				$g_aGameShape[2][1] = $BOX_COLOUR
				$g_aGameShape[2][2] = $BOX_COLOUR
			case 3
				; Pyramid
				$g_aGameShape[1][1] = $PYRAMID_COLOUR
				$g_aGameShape[0][2] = $PYRAMID_COLOUR
				$g_aGameShape[1][2] = $PYRAMID_COLOUR
				$g_aGameShape[2][2] = $PYRAMID_COLOUR
			case 4
				; Left Leaner
				$g_aGameShape[0][1] = $LLEANER_COLOUR
				$g_aGameShape[1][1] = $LLEANER_COLOUR
				$g_aGameShape[1][2] = $LLEANER_COLOUR
				$g_aGameShape[2][2] = $LLEANER_COLOUR
			case 5
				; Right Leaner
				$g_aGameShape[2][1] = $RLEANER_COLOUR
				$g_aGameShape[1][1] = $RLEANER_COLOUR
				$g_aGameShape[1][2] = $RLEANER_COLOUR
				$g_aGameShape[0][2] = $RLEANER_COLOUR
			case 6
				; Left Knight
				$g_aGameShape[1][1] = $LKNIGHT_COLOUR
				$g_aGameShape[2][1] = $LKNIGHT_COLOUR
				$g_aGameShape[2][2] = $LKNIGHT_COLOUR
				$g_aGameShape[2][3] = $LKNIGHT_COLOUR
			case 7
				; Right Knight
				$g_aGameShape[2][1] = $RKNIGHT_COLOUR
				$g_aGameShape[1][1] = $RKNIGHT_COLOUR
				$g_aGameShape[1][2] = $RKNIGHT_COLOUR
				$g_aGameShape[1][3] = $RKNIGHT_COLOUR
		EndSwitch
	Else
		For $i = 0 To 3
			For $j = 0 To 3
				$g_aGameShape[$i][$j] = $g_aPreShape[$i][$j]
			Next
		Next
		If $g_aGameShape[1][0] = $TOWER_COLOUR Then $g_nShapeY = 0
	EndIf
	For $i = 0 To 3
		For $j = 0 To 3
			$g_aPreShape[$i][$j] = $EMPTY_COLOUR
		Next
	Next
	$nShape = Random(1, 7, 1)
	Switch $nShape
		Case 1
			; Tower
			$g_aPreShape[1][0] = $TOWER_COLOUR
			$g_aPreShape[1][1] = $TOWER_COLOUR
			$g_aPreShape[1][2] = $TOWER_COLOUR
			$g_aPreShape[1][3] = $TOWER_COLOUR
		Case 2
			; Box
			$g_aPreShape[1][1] = $BOX_COLOUR
			$g_aPreShape[1][2] = $BOX_COLOUR
			$g_aPreShape[2][1] = $BOX_COLOUR
			$g_aPreShape[2][2] = $BOX_COLOUR
		case 3
			; Pyramid
			$g_aPreShape[1][1] = $PYRAMID_COLOUR
			$g_aPreShape[0][2] = $PYRAMID_COLOUR
			$g_aPreShape[1][2] = $PYRAMID_COLOUR
			$g_aPreShape[2][2] = $PYRAMID_COLOUR
		case 4
			; Left Leaner
			$g_aPreShape[0][1] = $LLEANER_COLOUR
			$g_aPreShape[1][1] = $LLEANER_COLOUR
			$g_aPreShape[1][2] = $LLEANER_COLOUR
			$g_aPreShape[2][2] = $LLEANER_COLOUR
		case 5
			; Right Leaner
			$g_aPreShape[2][1] = $RLEANER_COLOUR
			$g_aPreShape[1][1] = $RLEANER_COLOUR
			$g_aPreShape[1][2] = $RLEANER_COLOUR
			$g_aPreShape[0][2] = $RLEANER_COLOUR
		case 6
			; Left Knight
			$g_aPreShape[1][1] = $LKNIGHT_COLOUR
			$g_aPreShape[2][1] = $LKNIGHT_COLOUR
			$g_aPreShape[2][2] = $LKNIGHT_COLOUR
			$g_aPreShape[2][3] = $LKNIGHT_COLOUR
		case 7
			; Right Knight
			$g_aPreShape[2][1] = $RKNIGHT_COLOUR
			$g_aPreShape[1][1] = $RKNIGHT_COLOUR
			$g_aPreShape[1][2] = $RKNIGHT_COLOUR
			$g_aPreShape[1][3] = $RKNIGHT_COLOUR
	EndSwitch
	For $i = 0 To 3
		For $j = 0 To 3
			If $g_aPreShape[$i][$j] = $EMPTY_COLOUR Then
				GUICtrlSetBkColor($g_lblPreviewBoard[$i][$j], $GUI_BKCOLOR_TRANSPARENT)
			Else
				GUICtrlSetBkColor($g_lblPreviewBoard[$i][$j], $g_aPreShape[$i][$j])
			EndIf
		Next
	Next
EndFunc

Func _MoveShapeLeft()
	_MoveShape(-1, 0)
EndFunc

Func _MoveShapeRight()
	_MoveShape(1, 0)
EndFunc

Func _MoveShapeDown()
	_MoveShape(0, 1)
EndFunc

Func _DropShape()
	AdlibUnRegister()
	AdlibRegister("_MoveShapeDown", 25)
EndFunc

Func _MoveShape($nMoveX, $nMoveY)
	Local $nCollision, $i, $j
	Local $bFilled, $x, $y
	Local $sScoreText, $nScore

	If _CollisionTest($nMoveX, $nMoveY) Then
		If $nMoveY = 1 Then
			If $g_nShapeY < 1 Then
				MsgBox(0, "AutoIT Tetris", "GAME OVER!")
				GUICtrlSetState($g_btnStart, $GUI_ENABLE)
				HotKeySet("{LEFT}")
				HotKeySet("{RIGHT}")
				HotKeySet("{DOWN}")
				HotKeySet("{SPACE}")
				Return
			Else
				; Fill board with shape
				For $i = 0 To 3
					For $j = 0 To 3
						If $g_aGameShape[$i][$j] <> $EMPTY_COLOUR Then
							$g_aBoard[$g_nShapeX+$i][$g_nShapeY+$j] = $g_aGameShape[$i][$j]
						EndIf
					Next
				Next
				; Check for cleared row
                For $j = 0 To ($BOARD_HEIGHT-1)
                    $bFilled = True
                    For $i = 0 To ($BOARD_WIDTH-1)
                        If $g_aBoard[$i][$j] = $EMPTY_COLOUR Then
							$bFilled = False
							ExitLoop
						EndIf
					Next
                    If $bFilled Then
						; Increase score
						$sScoreText = GUICtrlRead($g_lblScore)
						$nScore = Number(StringRight($sScoreText, StringLen($sScoreText)-7))+10
						If Mod($nScore, 50) = 0 Then
							; Reduce game tick by 10 every 50 points scored
							$g_nGameTick -= 10
						EndIf
						GUICtrlSetData($g_lblScore, "SCORE: " & $nScore)
						For $x = 0 To ($BOARD_WIDTH-1)
							For $y = $j To 1 Step -1
								$g_aBoard[$x][$y] = $g_aBoard[$x][$y-1]
							Next
						Next
						_RedrawGameBoard()
					EndIf
				Next
				AdlibRegister()
				_NewShape()
				_DrawGameShape()
				AdlibEnable("_MoveShapeDown", $g_nGameTick)
			EndIf
		EndIf
	Else
		_DrawGameShape(True)
		If $nMoveX <> 0 Then $g_nShapeX += $nMoveX
		If $nMoveY <> 0 Then $g_nShapeY += $nMoveY
		_DrawGameShape()
	EndIf
EndFunc

Func _RotateShape()
	Local $i, $j, $aTempShape[4][4]

	; Copy & rotate to temporary array
    For $i = 0 To 3
        For $j = 0 To 3
            $aTempShape[3-$j][$i] = $g_aGameShape[$i][$j]
		Next
	Next

	; Check collision of temporary array with borders
    For $i = 0 To 3
        For $j = 0 To 3
            If $aTempShape[$i][$j] <> $EMPTY_COLOUR Then
                If ($g_nShapeX+$i) < 0 Or ($g_nShapeX+$i) > ($BOARD_WIDTH- 1) Or _
				   ($g_nShapeY+$j) < 0 Or ($g_nShapeY+$j) > ($BOARD_HEIGHT-1) Then
					Return
				EndIf
			EndIf
		Next
	Next

    ; Check collision of temporary array with blocks on the board
    For $x = 0 To ($BOARD_WIDTH-1)
        For $y = 0 To ($BOARD_HEIGHT-1)
            If $x >= $g_nShapeX And $x < ($g_nShapeX+4) Then
                If $y >= $g_nShapeY And $y < ($g_nShapeY+4) Then
                    If $g_aBoard[$x][$y] <> $EMPTY_COLOUR Then
                        If $aTempShape[$x-$g_nShapeX][$y-$g_nShapeY] <> $EMPTY_COLOUR Then
							Return
						EndIf
					EndIf
				EndIf
			EndIf
		Next
	Next

	; Clear previous shape
	_DrawGameShape(True)
    ; Copy rotated temporary array to original
    For $i = 0 To 3
        For $j = 0 To 3
            $g_aGameShape[$i][$j] = $aTempShape[$i][$j]
		Next
	Next
	_DrawGameShape()
EndFunc

Func _CollisionTest($nMoveX, $nMoveY)
	Local $nNewX = $g_nShapeX+$nMoveX
    Local $nNewY = $g_nShapeY+$nMoveY
    Local $i, $j, $x, $y

	; Check collision of temporary array with borders
    For $i = 0 To 3
		For $j = 0 To 3
            If $g_aGameShape[$i][$j] <> $EMPTY_COLOUR Then
                If ($nNewX+$i) < 0 Or ($nNewX+$i) > ($BOARD_WIDTH-1) Or _
				   ($nNewY+$j) < 0 Or ($nNewY+$j) > ($BOARD_HEIGHT-1) Then
					Return True
				EndIf
			EndIf
		Next
	Next

	; Check collision of temporary array with blocks on the board
    For $x = 0 To ($BOARD_WIDTH-1)
        For $y = 0 To ($BOARD_HEIGHT-1)
            If $x >= $nNewX And $x < ($nNewX+4) Then
                If $y >= $nNewY And $y < ($nNewY+4) Then
					If $g_aBoard[$x][$y] <> $EMPTY_COLOUR Then
                        If $g_aGameShape[$x-$nNewX][$y-$nNewY] <> $EMPTY_COLOUR Then
                            Return True
						EndIf
					EndIf
				EndIf
			EndIf
		Next
	Next
    Return False
EndFunc

Func _DrawGameShape($bRemove = False)
	Local $i, $j

	For $i = 0 To 3
		For $j = 0 To 3
			If $g_aGameShape[$i][$j] <> $EMPTY_COLOUR Then
				If $bRemove Then
					GUICtrlSetBkColor($g_lblGameBoard[$g_nShapeX+$i][$g_nShapeY+$j], $GUI_BKCOLOR_TRANSPARENT)
				Else
					GUICtrlSetBkColor($g_lblGameBoard[$g_nShapeX+$i][$g_nShapeY+$j], $g_aGameShape[$i][$j])
				EndIf
			EndIf
		Next
	Next
EndFunc

Func _DrawGameBoard()
	Local $i, $j
	Local $x, $y

	$x = 20
	$y = 20
	For $i = 0 To $BOARD_WIDTH-1
		For $j = 0 To $BOARD_HEIGHT-1
			GUICtrlCreateLabel("", $x, $y, 25, 25, $SS_BLACKFRAME)
			$g_lblGameBoard[$i][$j] = GUICtrlCreateLabel("", $x+1, $y+1, 23, 23)
			GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
			$y = $y+26
		Next
		$x = $x+26
		$y = 20
	Next
EndFunc

Func _DrawPreviewBoard()
	Local $i, $j
	Local $x, $y

	$x = 340
	$y = 40
	GUICtrlCreateLabel("Next Shape:", $x, 20, 104, 18, $SS_CENTER)
	For $i = 0 To 3
		For $j = 0 To 3
			GUICtrlCreateLabel("", $x, $y, 25, 25, $SS_BLACKFRAME)
			$g_lblPreviewBoard[$i][$j] = GUICtrlCreateLabel("", $x+1, $y+1, 23, 23)
			GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
			$y = $y+26
		Next
		$x = $x+26
		$y = 40
	Next
EndFunc

Func _RedrawGameBoard()
	Local $i, $j

	For $i = 0 To $BOARD_WIDTH-1
		For $j = 0 To $BOARD_HEIGHT-1
			If $g_aBoard[$i][$j] = $EMPTY_COLOUR Then
				GUICtrlSetBkColor($g_lblGameBoard[$i][$j], $GUI_BKCOLOR_TRANSPARENT)
			Else
				GUICtrlSetBkColor($g_lblGameBoard[$i][$j], $g_aBoard[$i][$j])
			EndIf
		Next
	Next
EndFunc

Func _NewGame()
	Local $i, $j

	AdlibRegister()
	HotKeySet("{LEFT}", "_MoveShapeLeft")
	HotKeySet("{RIGHT}", "_MoveShapeRight")
	HotKeySet("{DOWN}", "_RotateShape")
	HotKeySet("{SPACE}", "_DropShape")
	$g_bGameStarted = False
	For $i = 0 To $BOARD_WIDTH-1
		For $j = 0 To $BOARD_HEIGHT-1
			$g_aBoard[$i][$j] = $EMPTY_COLOUR
			GUICtrlSetBkColor($g_lblGameBoard[$i][$j], $GUI_BKCOLOR_TRANSPARENT)
		Next
	Next
	_NewShape()
	$g_bGameStarted = True
	_DrawGameShape()
	$g_nGameTick = 500
	AdlibEnable("_MoveShapeDown", $g_nGameTick)
EndFunc
