;~ Based off of the Android game 2048 by Estoty Entertainment Lab
;~ Coded by Ian Maxwell (llewxam @ AutoIt forum) May 2014
;~ AutoIt version 3.3.12.0
;~ To play the game use the arrow keys to slide the tiles.  Tiles that are the same number will merge together, and the goal is to reach a tile worth 2048.
;~ Tiles are added together in the direction that you press, so if you press right the right-most tiles will be added first, press left and the left-most tiles will be added first.
;~ If there are no blank tiles or tiles that can be added in a particular direction, pressing that arrow key will not do anything, including no random placed tile.
;~ (Try using mostly left and up, only use right when the top row is full so you don't get a small tile in there by accident (unless you have no other choice), and NEVER use down unless it is your only move!)
;~ Hit Escape any time to quit, if you get a 2048 tile you can continue playing just to try to get a high score, or you can start a new game.
;~ Set $Verbose to True to see more detailed information while playing, may be handy for beginners.


#include <Misc.au3>
#include <Array.au3>
#include <GUIListView.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>

;~ options for _StringAddThousandsSep
Local $rKey = "HKCU\Control Panel\International"
Local $sThousands = ',', $sDecimal = '.'
If $sDecimal = -1 Then $sDecimal = RegRead($rKey, "sDecimal")
If $sThousands = -1 Then $sThousands = RegRead($rKey, "sThousand")

Global $Tile[16]
Global $Val[16]
Global $Score
Global $High
$Verbose = False
$Won = False

If $Verbose == True Then
	$GUI = GUICreate("2048", 915, 680)
	$ShowVerbose = GUICtrlCreateListView("verbose", 625, 10, 280, 660)
	_GUICtrlListView_SetColumnWidth($ShowVerbose, 0, 250)
	GUICtrlCreateListViewItem("new game started", $ShowVerbose)
	GUICtrlSetBkColor($ShowVerbose, 0xffffff)
Else
	$GUI = GUICreate("2048", 615, 680)
	$ShowVerbose = GUICtrlCreateDummy()
EndIf
GUISetBkColor(0xb2ccff, $GUI)
GUISetFont(30, 400)
$DrawCells = GUICtrlCreateGraphic(0, 0, 620, 670)
GUICtrlSetGraphic($DrawCells, $GUI_GR_COLOR, 0x000000)
GUICtrlSetGraphic($DrawCells, $GUI_GR_MOVE, 157, 70)
GUICtrlSetGraphic($DrawCells, $GUI_GR_LINE, 157, 665)
GUICtrlSetGraphic($DrawCells, $GUI_GR_MOVE, 307, 70)
GUICtrlSetGraphic($DrawCells, $GUI_GR_LINE, 307, 665)
GUICtrlSetGraphic($DrawCells, $GUI_GR_MOVE, 457, 70)
GUICtrlSetGraphic($DrawCells, $GUI_GR_LINE, 457, 665)
GUICtrlSetGraphic($DrawCells, $GUI_GR_MOVE, 10, 217)
GUICtrlSetGraphic($DrawCells, $GUI_GR_LINE, 605, 217)
GUICtrlSetGraphic($DrawCells, $GUI_GR_MOVE, 10, 367)
GUICtrlSetGraphic($DrawCells, $GUI_GR_LINE, 605, 367)
GUICtrlSetGraphic($DrawCells, $GUI_GR_MOVE, 10, 517)
GUICtrlSetGraphic($DrawCells, $GUI_GR_LINE, 605, 517)
GUICtrlCreateLabel("Score:", 10, 10, 120, 50)
$ShowScore = GUICtrlCreateLabel("", 140, 10, 155, 40)
GUICtrlSetBkColor($ShowScore, 0xffffff)
GUICtrlCreateLabel("High:", 305, 10, 120, 50)
$ShowHigh = GUICtrlCreateLabel("", 435, 10, 155, 40)
GUICtrlSetBkColor($ShowHigh, 0xffffff)

;~ build tiles
$X = 10
$Y = 70
For $a = 0 To 15
	$Tile[$a] = GUICtrlCreateLabel("2048", $X, $Y, 145, 145, BitOR($SS_CENTERIMAGE, $SS_CENTER))
	$X += 150
	If $X > 500 Then
		$Y += 150
		$X = 10
	EndIf
Next
GUISetState(@SW_SHOW, $GUI)

Local $High = RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\2048", "HighScore")
If Not @error Then
	GUICtrlSetData($ShowHigh, _StringAddThousandsSep($High))
Else
	GUICtrlSetData($ShowHigh, "0")
EndIf
Sleep(2000)
_PlaceRandom()
_Play()


Func _Play()
	Do
		$MSG = GUIGetMsg()
		If $MSG == $GUI_EVENT_CLOSE Then
			$YesOrNo = MsgBox(4, "Quit?", "Are you sure you want to quit?")
			If $YesOrNo == 6 Then Exit
		EndIf
		If WinActive("2048") Then; needed to make sure the game isn't messed up if you use the arrow keys on another application
			If _IsPressed("25") Then ;left
				_CondenseLeft()
				_CheckForWin()
				$MSG = ""
			EndIf
			If _IsPressed("26") Then ;up
				_CondenseTop()
				_CheckForWin()
				$MSG = ""
			EndIf
			If _IsPressed("27") Then ;right
				_CondenseRight()
				_CheckForWin()
				$MSG = ""
			EndIf
			If _IsPressed("28") Then ;down
				_CondenseBottom()
				_CheckForWin()
				$MSG = ""
			EndIf
		EndIf
		$Count = _GUICtrlListView_GetItemCount($ShowVerbose)
		_GUICtrlListView_EnsureVisible($ShowVerbose, $Count - 1, True)
	Until True == False
EndFunc   ;==>_Play


Func _Redraw()
	For $a = 0 To 15
		Switch $Val[$a]
			Case 2
				GUICtrlSetColor($Tile[$a], 0x021550)
			Case 4
				GUICtrlSetColor($Tile[$a], 0x03385b)
			Case 8
				GUICtrlSetColor($Tile[$a], 0x036567)
			Case 16
				GUICtrlSetColor($Tile[$a], 0x03734c)
			Case 32
				GUICtrlSetColor($Tile[$a], 0x027f26)
			Case 64
				GUICtrlSetColor($Tile[$a], 0x0e8b02)
			Case 128
				GUICtrlSetColor($Tile[$a], 0x469602)
			Case 256
				GUICtrlSetColor($Tile[$a], 0x86a201)
			Case 512
				GUICtrlSetColor($Tile[$a], 0xae8c01)
			Case 1024
				GUICtrlSetColor($Tile[$a], 0xba5000)
			Case 2048
				GUICtrlSetColor($Tile[$a], 0xc60b00)
			Case 4096
				GUICtrlSetColor($Tile[$a], 0xc60078)
			Case 8192
				GUICtrlSetColor($Tile[$a], 0xffffff)
		EndSwitch
		$GetCurrent = GUICtrlRead($Tile[$a])
		If $GetCurrent <> $Val[$a] Then GUICtrlSetData($Tile[$a], $Val[$a])
	Next
	GUICtrlSetData($ShowScore, _StringAddThousandsSep($Score))
	If $Score > $High Then GUICtrlSetData($ShowHigh, _StringAddThousandsSep($Score))
EndFunc   ;==>_Redraw


Func _PlaceRandom()
	_Redraw()
	_CheckForMoves()
	Do
		$PickTile = Random(0, 15, 1)
		If $Val[$PickTile] == "" Then
			$OddsAre = Random(1, 9, 1)
			If $OddsAre == 1 Then
				$Val[$PickTile] = 4
			Else
				$Val[$PickTile] = 2
			EndIf
			ExitLoop
		EndIf
	Until True == False
	Sleep(250)
	_Redraw()
	_CheckForMoves()
EndFunc   ;==>_PlaceRandom


Func _CheckForMoves()
	$NoMoves = True
;~ 	left
	For $a = 0 To 12 Step 4
		Dim $CondenseLeft[4]
		For $b = 0 To 3
			$CondenseLeft[$b] = $Val[$a + $b]
		Next
		For $b = 0 To 2
			If $CondenseLeft[$b] == $CondenseLeft[$b + 1] And $CondenseLeft[$b] <> "" Then
				$NoMoves = False
				ExitLoop (2)
			EndIf
		Next
	Next
;~ right
	If $NoMoves == True Then
		For $a = 0 To 12 Step 4
			Dim $CondenseRight[4]
			For $b = 0 To 3
				$CondenseRight[$b] = $Val[$a + $b]
			Next
			For $b = 3 To 1 Step -1
				If $CondenseRight[$b] == $CondenseRight[$b - 1] And $CondenseRight[$b] <> "" Then
					$NoMoves = False
					ExitLoop (2)
				EndIf
			Next
		Next
	EndIf
;~ top
	If $NoMoves == True Then
		For $a = 0 To 3
			Dim $CondenseTop[4]
			For $b = 0 To 3
				$CondenseTop[$b] = $Val[$a + ($b * 4)]
			Next
			For $b = 0 To 2
				If $CondenseTop[$b] == $CondenseTop[$b + 1] And $CondenseTop[$b] <> "" Then
					$NoMoves = False
					ExitLoop (2)
				EndIf
			Next
		Next
	EndIf
;~ bottom
	If $NoMoves == True Then
		For $a = 0 To 3
			Dim $CondenseBottom[4]
			For $b = 0 To 3
				$CondenseBottom[$b] = $Val[$a + ($b * 4)]
			Next
			For $b = 3 To 1 Step -1
				If $CondenseBottom[$b] == $CondenseBottom[$b - 1] And $CondenseBottom[$b] <> "" Then
					$NoMoves = False
					ExitLoop (2)
				EndIf
			Next
		Next
	EndIf
;~ blanks
	If $NoMoves == True Then
		For $a = 0 To 15
			If $Val[$a] == "" Then
				$NoMoves = False
				ExitLoop
			EndIf
		Next
	EndIf

	If $NoMoves == True Then
		GUICtrlCreateListViewItem("no moves left, game lost", $ShowVerbose)
		MsgBox(0, "Game Over", "Game Over")
		If $Score > $High Then RegWrite("HKEY_LOCAL_MACHINE\SOFTWARE\2048", "HighScore", "REG_SZ", $Score)
		$YesOrNo = MsgBox(4, "Play Again?", "Do you want to play again?")
		If $YesOrNo == 6 Then
			For $a = 0 To 15
				$Val[$a] = ""
				GUICtrlSetData($Tile[$a], "2048")
				GUICtrlSetColor($Tile[$a], 0x000000)
			Next
			GUICtrlSetData($ShowScore, "")
			Sleep(2000)
			$Score = 0
			GUICtrlCreateListViewItem("new game started", $ShowVerbose)
			_PlaceRandom()
			_Play()
		Else
			Exit
		EndIf
	EndIf
EndFunc   ;==>_CheckForMoves


Func _CheckForLeft()
	$AvailableMoves = False
	For $a = 0 To 12 Step 4
		Dim $CondenseLeft[4]
		For $b = 0 To 3
			$CondenseLeft[$b] = $Val[$a + $b]
		Next
;~ 	check for mid-stream blanks
		$Status = 0
		For $b = 0 To 3
			If $Status == 1 And $CondenseLeft[$b] <> "" Then $AvailableMoves = True
			If $Status == 0 And $CondenseLeft[$b] == "" Then $Status = 1
		Next
;~ check for available adds
		For $b = 0 To 2
			If $CondenseLeft[$b] == $CondenseLeft[$b + 1] And $CondenseLeft[$b] <> "" Then $AvailableMoves = True
		Next
	Next
	If $Verbose == True Then
		If $AvailableMoves == False Then
			GUICtrlCreateListViewItem("can not move left", $ShowVerbose)
			Sleep(250)
		EndIf
	EndIf
	Return $AvailableMoves
EndFunc   ;==>_CheckForLeft


Func _CheckForRight()
	$AvailableMoves = False
	For $a = 0 To 12 Step 4
		Dim $CondenseRight[4]
		For $b = 0 To 3
			$CondenseRight[$b] = $Val[$a + $b]
		Next
;~ 	check for mid-stream blanks
		$Status = 0
		For $b = 3 To 0 Step -1
			If $Status == 1 And $CondenseRight[$b] <> "" Then $AvailableMoves = True
			If $Status == 0 And $CondenseRight[$b] == "" Then $Status = 1
		Next
;~ check for available adds
		For $b = 3 To 1 Step -1
			If $CondenseRight[$b] == $CondenseRight[$b - 1] And $CondenseRight[$b] <> "" Then $AvailableMoves = True
		Next
	Next
	If $Verbose == True Then
		If $AvailableMoves == False Then
			GUICtrlCreateListViewItem("can not move right", $ShowVerbose)
			Sleep(250)
		EndIf
	EndIf
	Return $AvailableMoves
EndFunc   ;==>_CheckForRight


Func _CheckForTop()
	$AvailableMoves = False
	For $a = 0 To 3
		Dim $CondenseTop[4]
		For $b = 0 To 3
			$CondenseTop[$b] = $Val[$a + ($b * 4)]
		Next
;~ 	check for mid-stream blanks
		$Status = 0
		For $b = 0 To 3
			If $Status == 1 And $CondenseTop[$b] <> "" Then $AvailableMoves = True
			If $Status == 0 And $CondenseTop[$b] == "" Then $Status = 1
		Next
;~ check for available adds
		For $b = 0 To 2
			If $CondenseTop[$b] == $CondenseTop[$b + 1] And $CondenseTop[$b] <> "" Then $AvailableMoves = True
		Next
	Next
	If $Verbose == True Then
		If $AvailableMoves == False Then
			GUICtrlCreateListViewItem("can not move up", $ShowVerbose)
			Sleep(250)
		EndIf
	EndIf
	Return $AvailableMoves
EndFunc   ;==>_CheckForTop


Func _CheckForBottom()
	$AvailableMoves = False
	For $a = 0 To 3
		Dim $CondenseBottom[4]
		For $b = 0 To 3
			$CondenseBottom[$b] = $Val[$a + ($b * 4)]
		Next
;~ 	check for mid-stream blanks
		$Status = 0
		For $b = 3 To 0 Step -1
			If $Status == 1 And $CondenseBottom[$b] <> "" Then $AvailableMoves = True
			If $Status == 0 And $CondenseBottom[$b] == "" Then $Status = 1
		Next
;~ check for available adds
		For $b = 3 To 1 Step -1
			If $CondenseBottom[$b] == $CondenseBottom[$b - 1] And $CondenseBottom[$b] <> "" Then $AvailableMoves = True
		Next
	Next
	If $Verbose == True Then
		If $AvailableMoves == False Then
			GUICtrlCreateListViewItem("can not move down", $ShowVerbose)
			Sleep(250)
		EndIf
	EndIf
	Return $AvailableMoves
EndFunc   ;==>_CheckForBottom


Func _CondenseLeft()
	$LeftMoves = _CheckForLeft()
	If $LeftMoves == True Then
		$ScoreAdd = 0
		For $a = 0 To 12 Step 4
			Dim $CondenseLeft[4]
			For $b = 0 To 3
				$CondenseLeft[$b] = $Val[$a + $b]
			Next
;~ strip
			Do
				$FindBlank = _ArraySearch($CondenseLeft, "")
				If $FindBlank <> -1 Then
					_ArrayDelete($CondenseLeft, $FindBlank)
				EndIf
			Until $FindBlank == -1
			ReDim $CondenseLeft[4]
;~ /strip
;~ add
			For $b = 0 To 2
				If $CondenseLeft[$b] == $CondenseLeft[$b + 1] Then
					$CondenseLeft[$b] = $CondenseLeft[$b] * 2
					$CondenseLeft[$b + 1] = "x"
					$ScoreAdd += $CondenseLeft[$b]
				EndIf
			Next
			Do
				$FindX = _ArraySearch($CondenseLeft, "x")
				If $FindX <> -1 Then _ArrayDelete($CondenseLeft, $FindX)
			Until $FindX == -1
;~ /add
;~ rebuild $Val
			ReDim $CondenseLeft[4]
			For $b = 0 To 3
				$Val[$a + $b] = $CondenseLeft[$b]
			Next
;~ /rebuild
		Next
		$Score += $ScoreAdd
		If $ScoreAdd > 0 Then GUICtrlCreateListViewItem("score +" & $ScoreAdd, $ShowVerbose)
		_PlaceRandom()
	EndIf
EndFunc   ;==>_CondenseLeft


Func _CondenseRight()
	$RightMoves = _CheckForRight()
	If $RightMoves == True Then
		$ScoreAdd = 0
		For $a = 0 To 12 Step 4
			Dim $CondenseRight[4]
			For $b = 0 To 3
				$CondenseRight[$b] = $Val[$a + $b]
			Next
;~ strip
			Do
				$FindBlank = _ArraySearch($CondenseRight, "")
				If $FindBlank <> -1 Then
					_ArrayDelete($CondenseRight, $FindBlank)
				EndIf
			Until $FindBlank == -1
;~ /strip
;~ add
			Do
				$Size = UBound($CondenseRight)
				If $Size == 0 Then
					Dim $CondenseRight[4]
					$Size = 4
				EndIf
				If $Size < 4 Then
					_ArrayInsert($CondenseRight, 0, "")
				EndIf
			Until $Size == 4
			For $b = 3 To 1 Step -1
				If $CondenseRight[$b] == $CondenseRight[$b - 1] Then
					$CondenseRight[$b] = $CondenseRight[$b] * 2
					$CondenseRight[$b - 1] = "x"
					$ScoreAdd += $CondenseRight[$b]
				EndIf
			Next
			Do
				$FindX = _ArraySearch($CondenseRight, "x")
				If $FindX <> -1 Then _ArrayDelete($CondenseRight, $FindX)
			Until $FindX == -1
;~ /add
;~ rebuild $Val
			Do
				$Size = UBound($CondenseRight)
				If $Size == 0 Then
					Dim $CondenseRight[4]
					$Size = 4
				EndIf
				If $Size < 4 Then
					_ArrayInsert($CondenseRight, 0, "")
				EndIf
			Until $Size == 4
			For $b = 0 To 3
				$Val[$a + $b] = $CondenseRight[$b]
			Next
;~ /rebuild
		Next
		$Score += $ScoreAdd
		If $ScoreAdd > 0 Then GUICtrlCreateListViewItem("score +" & $ScoreAdd, $ShowVerbose)
		_PlaceRandom()
	EndIf
EndFunc   ;==>_CondenseRight


Func _CondenseTop()
	$TopMoves = _CheckForTop()
	If $TopMoves == True Then
		$ScoreAdd = 0
		For $a = 0 To 3
			Dim $CondenseTop[4]
			For $b = 0 To 3
				$CondenseTop[$b] = $Val[$a + ($b * 4)]
			Next
;~ strip
			Do
				$FindBlank = _ArraySearch($CondenseTop, "")
				If $FindBlank <> -1 Then
					_ArrayDelete($CondenseTop, $FindBlank)
				EndIf
			Until $FindBlank == -1
;~ /strip
;~ add
			ReDim $CondenseTop[4]
			For $b = 0 To 2
				If $CondenseTop[$b] == $CondenseTop[$b + 1] Then
					$CondenseTop[$b] = $CondenseTop[$b] * 2
					$CondenseTop[$b + 1] = "x"
					$ScoreAdd += $CondenseTop[$b]
				EndIf
			Next
			Do
				$FindX = _ArraySearch($CondenseTop, "x")
				If $FindX <> -1 Then _ArrayDelete($CondenseTop, $FindX)
			Until $FindX == -1
;~ /add
;~ rebuild $Val
			ReDim $CondenseTop[4]
			For $b = 0 To 3
				$Val[$a + ($b * 4)] = $CondenseTop[$b]
			Next
;~ /rebuild
		Next
		$Score += $ScoreAdd
		If $ScoreAdd > 0 Then GUICtrlCreateListViewItem("score +" & $ScoreAdd, $ShowVerbose)
		_PlaceRandom()
	EndIf
EndFunc   ;==>_CondenseTop


Func _CondenseBottom()
	$BottomMoves = _CheckForBottom()
	If $BottomMoves == True Then
		$ScoreAdd = 0
		For $a = 0 To 3
			Dim $CondenseBottom[4]
			For $b = 0 To 3
				$CondenseBottom[$b] = $Val[$a + ($b * 4)]
			Next
;~ strip
			Do
				$FindBlank = _ArraySearch($CondenseBottom, "")
				If $FindBlank <> -1 Then
					_ArrayDelete($CondenseBottom, $FindBlank)
				EndIf
			Until $FindBlank == -1
;~ /strip
;~ add
			Do
				$Size = UBound($CondenseBottom)
				If $Size == 0 Then
					Dim $CondenseBottom[4]
					$Size = 4
				EndIf
				If $Size < 4 Then
					_ArrayInsert($CondenseBottom, 0, "")
				EndIf
			Until $Size == 4
			For $b = 3 To 1 Step -1
				If $CondenseBottom[$b] == $CondenseBottom[$b - 1] Then
					$CondenseBottom[$b] = $CondenseBottom[$b] * 2
					$CondenseBottom[$b - 1] = "x"
					$ScoreAdd += $CondenseBottom[$b]
				EndIf
			Next
			Do
				$FindX = _ArraySearch($CondenseBottom, "x")
				If $FindX <> -1 Then _ArrayDelete($CondenseBottom, $FindX)
			Until $FindX == -1
;~ /add
;~ rebuild $Val
			Do
				$Size = UBound($CondenseBottom)
				If $Size == 0 Then
					Dim $CondenseBottom[4]
					$Size = 4
				EndIf
				If $Size < 4 Then
					_ArrayInsert($CondenseBottom, 0, "")
				EndIf
			Until $Size == 4
			For $b = 0 To 3
				$Val[$a + ($b * 4)] = $CondenseBottom[$b]
			Next
;~ /rebuild
		Next
		$Score += $ScoreAdd
		If $ScoreAdd > 0 Then GUICtrlCreateListViewItem("score +" & $ScoreAdd, $ShowVerbose)
		_PlaceRandom()
	EndIf
EndFunc   ;==>_CondenseBottom


Func _CheckForWin()
	For $a = 0 To 15
		If $Val[$a] == 2048 And $Won == False Then; check for win
			$Won = True
			GUICtrlCreateListViewItem("2048!!!  game won", $ShowVerbose)
			MsgBox(0, "WON!", "You got 2048!")
			$YesOrNo = MsgBox(4, "Continue playing?", "Do you want to continue playing?")
			If $YesOrNo == 6 Then
				ExitLoop
			Else
				If $Score > $High Then RegWrite("HKEY_LOCAL_MACHINE\SOFTWARE\2048", "HighScore", "REG_SZ", $Score)
				$YesOrNo = MsgBox(4, "Play Again?", "Do you want to start a new game?")
				If $YesOrNo == 6 Then
					For $a = 0 To 15
						$Val[$a] = ""
						GUICtrlSetData($Tile[$a], "2048")
						GUICtrlSetColor($Tile[$a], 0x000000)
					Next
					GUICtrlSetData($ShowScore, "")
					$Score = 0
					$Won = False
					Sleep(2000)
					_PlaceRandom()
					_Play()
				Else
					Exit
				EndIf
			EndIf
		EndIf
	Next
EndFunc   ;==>_CheckForWin


Func _StringAddThousandsSep($sText)
	If Not StringIsInt($sText) And Not StringIsFloat($sText) Then Return 0
	Local $aSplit = StringSplit($sText, "-" & $sDecimal)
	Local $iInt = 1, $iMod
	If Not $aSplit[1] Then
		$aSplit[1] = "-"
		$iInt = 2
	EndIf
	If $aSplit[0] > $iInt Then
		$aSplit[$aSplit[0]] = "." & $aSplit[$aSplit[0]]
	EndIf
	$iMod = Mod(StringLen($aSplit[$iInt]), 3)
	If Not $iMod Then $iMod = 3
	$aSplit[$iInt] = StringRegExpReplace($aSplit[$iInt], '(?<=\d{' & $iMod & '})(\d{3})', $sThousands & '\1')
	For $i = 2 To $aSplit[0]
		$aSplit[1] &= $aSplit[$i]
	Next
	Return $aSplit[1]
EndFunc   ;==>_StringAddThousandsSep
