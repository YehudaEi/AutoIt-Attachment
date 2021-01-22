#include <GUIConstants.au3>
#include <.\Prospeed.au3>
#include <Sound.au3>

HotKeySet("{Esc}", "_exit")
Opt("MouseCoordMode", 2)
$user32dll = DllOpen("user32.dll")

If @error = 1 Then Exit
Global $bubblesize = 0
Dim $aPicBubble[1][1]
Dim $aBubbleGrid[1][1]
Dim $aMousePos[2] = [0, 0]
Dim $aOldMousePos[2] = [-1, -1]
Dim $aSameColorX[2]
Dim $aSameColorY[2]
Global $mainGui = ""
Global $bmpToDraw = ""
Global $iSCAmount = 1 ; iSameColorAmount
Global $bg
Global $bgPic = LoadExtImage(@scriptdir & "\misc\bg700.jpg")
Global $bgBubblePic
Global $totalScore = 0
Global $forceFlip = False
Global $maskPng
Global $mask
Global $array_mask
Global $snd, $sndMusic
Global $gameOver = False

Dim $aBubbleFile[5]
Dim $aBubbleSprite[5]

_initBubbleFiles()
_buildNewGui()

$snd = _SoundOpen(@scriptdir & "\misc\welcome.mp3")
_SoundSeek($snd, 0, 0, 0)
_SoundPlay($snd)
Global $gridSize = InputBox("Question", "Grid size?" & @CRLF & @CRLF & "Please turn your speakers on. The soundtrack and sounds are too good to miss! ;-)", 11, "")
If @error = 1 Then Exit
$initialHDC = CreateExtBmp(700, 700)
_initGrid($initialHDC)
Do
	$aRealMousePos = MouseGetPos()
Until $aRealMousePos[0] > 0 And $aRealMousePos[0] < 700 And $aRealMousePos[1] > 0 And $aRealMousePos[1] < 700

_SoundStop($snd)
$snd = _SoundOpen(@scriptdir & "\misc\letsplay.mp3")
_SoundSeek($snd, 0, 0, 0)
_SoundPlay($snd, 0)

$introPic = CreateExtBmp(700, 700)
CopyExtBmp($introPic, 0, 0, 700, 700, $initialHDC, 0, 0, 0)

For $loop = 255 To 1 Step -4
	Sleep(10)
	$tempFX = InitExtFX($introPic)
	darken($tempFX, 0, 0, $tempFX, $loop)
	CopyArray($hDC, 0, 0, $tempFX)
	FreeExtFX($tempFX)
Next
FreeExtBmp($introPic)

CopyExtBmp($hDC, 0, 0, 700, 700, $initialHDC, 0, 0, 0)
FreeExtBmp($initialHDC)

$aMousePos = _getMousePosInGrid()
_flip($aMousePos)
_updateOldMousePos()

$sndMusic = _SoundOpen(@scriptdir & "\misc\bb_music.mp3")
_SoundSeek($sndMusic, 0, 0, 0)
_SoundPlay($sndMusic, 0)

While 1
	Sleep(10)
	$aRealMousePos = MouseGetPos()
	If $aRealMousePos[0] > 0 And $aRealMousePos[0] < 700 And $aRealMousePos[1] > 0 And $aRealMousePos[1] < 700 Then
		$aMousePos = _getMousePosInGrid()
		If _MousePosIsNotOldMousePos() Or $forceFlip Then
			;MsgBox(0, 0, $aMousePos[0] & @CRLF & $aMousePos[1])
			If $aBubbleGrid[$aMousePos[0]][$aMousePos[1]] <> $aBubbleGrid[$aOldMousePos[0]][$aOldMousePos[1]] Or $forceFlip Then
				_unflip($aOldMousePos)
				_flip($aMousePos)
				_updateOldMousePos()
			EndIf
			$forceFlip = False
		EndIf
	Else
		$hDC_backup = CreateExtBmp(700, 700)
		CopyExtBmp($hDC_backup, 0, 0, 700, 700, $hDC, 0, 0, 0)
		Do
			Sleep(10)
			$aRealMousePos = MouseGetPos()
		Until $aRealMousePos[0] > 0 And $aRealMousePos[0] < 700 And $aRealMousePos[1] > 0 And $aRealMousePos[1] < 700
		CopyExtBmp($hDC, 0, 0, 700, 700, $hDC_backup, 0, 0, 0)
		FreeExtBmp($hDC_backup)
		$aMousePos = _getMousePosInGrid()
		_unflip($aOldMousePos)
		_flip($aMousePos)
		_updateOldMousePos()
	EndIf
	$msg = GUIGetMsg()
	If $msg = $GUI_EVENT_PRIMARYDOWN Then
		_processLeftClick($aRealMousePos)
		$forceFlip = True
	ElseIf $msg = $GUI_EVENT_CLOSE Then
		_exit()
	EndIf
	_checkMusic()
WEnd

Func _checkMusic()
	If _SoundStatus($sndMusic) = "stopped" Then
		_SoundSeek($sndMusic, 0, 0, 0)
		_SoundPlay($sndMusic, 0)
	EndIf
EndFunc   ;==>_checkMusic

Func _processLeftClick($aRealMousePos)
	Do
		$msg = GUIGetMsg()
	Until $msg = $GUI_EVENT_PRIMARYUP
	
	Local $aMousePos = _getMousePosInGrid($aRealMousePos)
	_fillSameColorArray($aMousePos)
	If $iSCAmount > 1 Then
		_killBubbles($aMousePos)
		If _noMoreMovesPossible() Then
			_gameOver()
		EndIf
	EndIf
EndFunc   ;==>_processLeftClick

Func _gameOver()
	_SoundPause($sndMusic)
	Local $hDC_backup = CreateExtBmp(700, 700)
	CopyExtBmp($hDC_backup, 0, 0, 700, 700, $hDC, 0, 0, 0)
	_SoundStop($snd)
	$snd = _SoundOpen(@scriptdir & "\misc\gameover.mp3")
	_SoundSeek($snd, 0, 0, 0)
	_SoundPlay($snd, 1)
	_speakTotalScore()
	_SoundResume($sndMusic)
	FreeExtBmp($hDC_backup)
	$gameOver = True
	_exit()
EndFunc   ;==>_gameOver

Func _noMoreMovesPossible()
	For $x = 0 To $gridSize - 1
		For $y = 0 To $gridSize - 1
			Dim $coord[2] = [$x, $y]
			_fillSameColorArray($coord)
			If $iSCAmount > 1 Then Return False
		Next
	Next
	Return True
EndFunc   ;==>_noMoreMovesPossible

Func _updateOldMousePos()
	$aOldMousePos[0] = $aMousePos[0]
	$aOldMousePos[1] = $aMousePos[1]
EndFunc   ;==>_updateOldMousePos

Func _killBubbles($tMP)
	If Not ($tMP[0] = -1 And $tMP[1] = -1) Then
		If $iSCAmount > 1 Then
			Local $sndBubWeg = _SoundOpen(@scriptdir & "\misc\bubblweg.mp3")
			_SoundPlay($sndBubWeg)

			Local $newMajorPicture = CreateExtBmp(700, 700)
			CopyExtBmp($newMajorPicture, 0, 0, 700, 700, $hDC, 0, 0, 0)
			$totalScore += $iSCAmount * ($iSCAmount - 1)
			WinSetTitle("", "", "BubbleBreaker - Projected score for this move: 0. Total score: " & $totalScore & ".")
			For $loop = 0 To $iSCAmount - 1
				Local $x = $aSameColorX[$loop]
				Local $y = $aSameColorY[$loop]
				$aBubbleGrid[$x][$y] = -1
				_paintNormalBubble($x, $y, $newMajorPicture)
			Next
			_dropBubbles($newMajorPicture)
			_ProcessEmptyColumns($newMajorPicture)
			CopyExtBmp($hDC, 0, 0, 700, 700, $newMajorPicture, 0, 0, 0)
			FreeExtBmp($newMajorPicture)
		EndIf
	EndIf
EndFunc   ;==>_killBubbles

Func _ProcessEmptyColumns(ByRef $picture)
	Local $firstMostRightFreeColumn = -1
	Local $mostRightFreeColumn = -1
	While 1
		$mostRightFreeColumn = _getMostRightFreeColumn()
		If $mostRightFreeColumn = -1 Then ExitLoop
		If _theresSomthingToLeftOfColumn($mostRightFreeColumn) Then
			If $firstMostRightFreeColumn = -1 Then $firstMostRightFreeColumn = $mostRightFreeColumn
			_moveColumnsLeftOfXToRight($mostRightFreeColumn)
		Else
			ExitLoop
		EndIf
	WEnd
	
	If $firstMostRightFreeColumn > -1 Then
		Local $sndKolWeg = _SoundOpen(@scriptdir & "\misc\kolomweg.mp3")
		_SoundPlay($sndKolWeg)
		For $x = 0 To $firstMostRightFreeColumn
			For $y = 0 To $gridSize - 1
				_paintNormalBubble($x, $y, $picture)
			Next
		Next
	EndIf
EndFunc   ;==>_ProcessEmptyColumns

Func _getMostRightFreeColumn()
	For $x = $gridSize - 1 To 1 Step -1
		If _columnIsEmpty($x) Then
			Return $x
		EndIf
	Next
	Return -1
EndFunc   ;==>_getMostRightFreeColumn

Func _theresSomthingToLeftOfColumn($x)
	For $xCheck = 0 To $x - 1
		For $yCheck = 0 To $gridSize - 1
			If $aBubbleGrid[$xCheck][$yCheck] > -1 Then Return True
		Next
	Next
	Return False
EndFunc   ;==>_theresSomthingToLeftOfColumn

Func _moveColumnsLeftOfXToRight($xMax)
	For $x = $xMax To 1 Step -1
		For $y = 0 To $gridSize - 1
			$aBubbleGrid[$x][$y] = $aBubbleGrid[$x - 1][$y]
		Next
	Next
	For $y = 0 To $gridSize - 1
		$aBubbleGrid[0][$y] = -1
	Next
EndFunc   ;==>_moveColumnsLeftOfXToRight

Func _columnIsEmpty($x)
	For $y = 0 To $gridSize - 1
		If $aBubbleGrid[$x][$y] > -1 Then Return False
	Next
	Return True
EndFunc   ;==>_columnIsEmpty

Func _dropBubbles(ByRef $picture)
	Local $minX = _getMinXFromSCArray()
	Local $maxX = _getMaxXFromSCArray()
	For $x = $minX To $maxX
		For $y = $gridSize - 1 To 1 Step -1
			If $aBubbleGrid[$x][$y] = -1 Then _dropBubblesAtXAboveY($x, $y, $picture)
		Next
	Next
EndFunc   ;==>_dropBubbles

Func _dropBubblesAtXAboveY($x, $y, ByRef $picture)
	For $yLoop = $y - 1 To 0 Step -1
		If $aBubbleGrid[$x][$yLoop] > -1 Then _dropSingleBubble($x, $yLoop, $picture)
	Next
	$aBubbleGrid[$x][0] = -1
EndFunc   ;==>_dropBubblesAtXAboveY

Func _dropSingleBubble($x, $y, ByRef $picture)
	Local $lowestFreeY = _getLowestFreeYOnColumn($x, $y)
	If $lowestFreeY > -1 Then
		$aBubbleGrid[$x][$lowestFreeY] = $aBubbleGrid[$x][$y]
		$aBubbleGrid[$x][$y] = -1
		_paintNormalBubble($x, $y, $picture)
		_paintNormalBubble($x, $lowestFreeY, $picture)
	EndIf
EndFunc   ;==>_dropSingleBubble

Func _getLowestFreeYOnColumn($x, $yOffset)
	Local $iResult = -1
	For $yLoop = $yOffset To $gridSize - 1
		If $aBubbleGrid[$x][$yLoop] = -1 Then $iResult = $yLoop
	Next
	Return $iResult
EndFunc   ;==>_getLowestFreeYOnColumn

Func _getMinXFromSCArray()
	Local $iResult = $gridSize
	For $loop = 0 To $iSCAmount - 1
		If $aSameColorX[$loop] < $iResult Then $iResult = $aSameColorX[$loop]
	Next
	Return $iResult
EndFunc   ;==>_getMinXFromSCArray

Func _getMaxXFromSCArray()
	Local $iResult = 0
	For $loop = 0 To $iSCAmount - 1
		If $aSameColorX[$loop] > $iResult Then $iResult = $aSameColorX[$loop]
	Next
	Return $iResult
EndFunc   ;==>_getMaxXFromSCArray

Func _unflip($tMP)
	_flip($tMP, True)
EndFunc   ;==>_unflip

Func _flip($tMP, $unflip = False)
	Local $bs = $bubblesize + 1
	If Not ($tMP[0] = -1 And $tMP[1] = -1) Then
		_fillSameColorArray($tMP)
		If $iSCAmount > 1 Then
			Local $newMajorPicture = CreateExtBmp(700, 700)
			CopyExtBmp($newMajorPicture, 0, 0, 700, 700, $hDC, 0, 0, 0)

			Local $finalBmp = CreateExtBmp($bs, $bs)
			Size($finalBmp, 0, 0, $bs, $bs, $aBubbleFile[$aBubbleGrid[$tMP[0]][$tMP[1]]], 0, 0, 80, 80)
			If $unflip = False Then
				;Local $fxArray1 = createExtFx($bs, $bs)
				Local $fxArray1 = InitExtFX($finalBmp)
				Lighten($fxArray1, 0, 0, $fxArray1, 75)
				CopyArray($finalBmp, 0, 0, $fxArray1)
				;blur($finalBmp, 0, 0, $fxArray1)
				FreeExtFx($fxArray1)
			EndIf

			For $loop = 0 To $iSCAmount - 1
				Local $x = $aSameColorX[$loop]
				Local $y = $aSameColorY[$loop]
				_paintNormalBubble($x, $y, $newMajorPicture, $finalBmp)
			Next
			CopyExtBmp($hDC, 0, 0, 700, 700, $newMajorPicture, 0, 0, 0)
			FreeExtBmp($newMajorPicture)
			FreeExtBmp($finalBmp)
			WinSetTitle("", "", "BubbleBreaker - Projected score for this move: " & $iSCAmount * ($iSCAmount - 1) & ". Total score: " & $totalScore & ".")
		Else
			WinSetTitle("", "", "BubbleBreaker - Projected score for this move: 0. Total score: " & $totalScore & ".")
		EndIf
	EndIf
EndFunc   ;==>_flip

Func _paintNormalBubble($x, $y, ByRef $picture, $picToWrite = "")
	Local $bs = $bubblesize + 1
	Local $finalBmp = CreateExtBmp($bs, $bs)
	Local $tempBgBmp = CreateExtBmp($bs, $bs)
	CopyExtBmp($tempBgBmp, 0, 0, $bs, $bs, $bgPic, $x * $bubblesize, $y * $bubblesize, 0)
	If $aBubbleGrid[$x][$y] > -1 Then
		Local $tempBmp = CreateExtBmp($bs, $bs)
		If $picToWrite = "" Then
			Size($tempBmp, 0, 0, $bs, $bs, $aBubbleFile[$aBubbleGrid[$x][$y]], 0, 0, 80, 80)
		Else
			CopyExtBmp($tempBmp, 0, 0, $bs, $bs, $picToWrite, 0, 0, 0)
		EndIf

		$array1 = InitExtFX($tempBgBmp)
		$array2 = InitExtFX($tempBmp)
		
		BitBltArray($array1, 0, 0, $bs, $bs, $array2, 0, 0, 2, $array_mask)
		CopyArray($finalBmp, 0, 0, $array1)

		FreeExtBmp($tempBmp)
		FreeExtBmp($tempBgBmp)
		FreeExtFX($array1)
		FreeExtFX($array2)
	Else
		CopyExtBmp($finalBmp, 0, 0, $bs, $bs, $bgPic, $x * $bubblesize, $y * $bubblesize, 0)
	EndIf
	CopyExtBmp($picture, $x * $bubblesize, $y * $bubblesize, $bs, $bs, $finalBmp, 0, 0, 0)
	FreeExtBmp($tempBgBmp)
	FreeExtBmp($finalBmp)
EndFunc   ;==>_paintNormalBubble

Func _fillSameColorArray($tMP)
	$iSCAmount = 1
	ReDim $aSameColorX[1]
	ReDim $aSameColorY[1]
	$aSameColorX[0] = $tMP[0]
	$aSameColorY[0] = $tMP[1]
	If $aBubbleGrid[$tMP[0]][$tMP[1]] > -1 Then _recurseFindSameColor($tMP)
EndFunc   ;==>_fillSameColorArray

Func _recurseFindSameColor($pos)
	Local $x = $pos[0]
	Local $y = $pos[1]
	Local $tx, $ty
	For $tx = $x - 1 To $x + 1 Step 2
		$ty = $y
		If $tx >= 0 And $tx <= $gridSize - 1 And $ty >= 0 And $ty <= $gridSize - 1 Then
			If $aBubbleGrid[$tx][$ty] = $aBubbleGrid[$x][$y] Then
				If _targetPosIsNotInArrayYet($tx, $ty) Then
					_addPosToSCArray($tx, $ty)
					Dim $newSearchPos[2] = [$tx, $ty]
					_recurseFindSameColor($newSearchPos)
				EndIf
			EndIf
		EndIf
	Next
	For $ty = $y - 1 To $y + 1 Step 2
		;For $ty = $y - 1 To $y + 1 Step 2
		$tx = $x
		If $tx >= 0 And $tx <= $gridSize - 1 And $ty >= 0 And $ty <= $gridSize - 1 Then
			If $aBubbleGrid[$tx][$ty] = $aBubbleGrid[$x][$y] Then
				If _targetPosIsNotInArrayYet($tx, $ty) Then
					_addPosToSCArray($tx, $ty)
					Dim $newSearchPos[2] = [$tx, $ty]
					_recurseFindSameColor($newSearchPos)
				EndIf
			EndIf
		EndIf
		;Next
	Next
EndFunc   ;==>_recurseFindSameColor

Func _addPosToSCArray($x, $y)
	$iSCAmount += 1
	ReDim $aSameColorX[$iSCAmount + 1]
	ReDim $aSameColorY[$iSCAmount + 1]
	$aSameColorX[$iSCAmount - 1] = $x
	$aSameColorY[$iSCAmount - 1] = $y
EndFunc   ;==>_addPosToSCArray

Func _targetPosIsNotInArrayYet($iX, $iY)
	For $loop = 1 To $iSCAmount
		If $aSameColorX[$loop - 1] = $iX And $aSameColorY[$loop - 1] = $iY Then Return False
	Next
	Return True
EndFunc   ;==>_targetPosIsNotInArrayYet

Func _MousePosIsNotOldMousePos()
	If $aMousePos[0] <> $aOldMousePos[0] Or $aMousePos[1] <> $aOldMousePos[1] Then Return 1
	Return 0
EndFunc   ;==>_MousePosIsNotOldMousePos

Func _getMousePosInGrid($tempMousePos = "")
	If $tempMousePos = "" Then
		Do
			$realMousePos = MouseGetPos()
		Until $realMousePos[0] > 0 And $realMousePos[1] > 0 And $realMousePos[0] < 700 And $realMousePos[1] < 700
	Else
		$realMousePos = $tempMousePos
	EndIf
	Dim $aResult[2] = [Int($realMousePos[0] / $bubblesize), Int($realMousePos[1] / $bubblesize)]
	Return $aResult
EndFunc   ;==>_getMousePosInGrid

Func _buildNewGui()
	If $mainGui <> "" Then GUIDelete($mainGui)
	$mainGui = GUICreate("BubbleBreaker - Projected score for this move: 0. Total score: " & $totalScore & ".", 700, 700)
	GUISetState()
	$bg = Background(@scriptdir & "\misc\bg700.jpg", 0, 0, 700, 700)
EndFunc   ;==>_buildNewGui

Func _initGrid($picture)
	$bmpToDraw = CreateExtBmp(700, 700)
	
	$bubblesize = 700 / $gridSize
	ReDim $aPicBubble[$gridSize][$gridSize]
	ReDim $aBubbleGrid[$gridSize + 1][$gridSize]
	
	$maskPng = LoadExtImage(@scriptdir & "\misc\mask.png")
	$mask = CreateExtBmp($bubblesize + 1, $bubblesize + 1)
	Size($mask, 0, 0, $bubblesize + 1, $bubblesize + 1, $maskPng, 0, 0, 80, 80, 0)
	$array_mask = InitExtFX($mask)

	For $x = 0 To $gridSize - 1
		For $y = 0 To $gridSize - 1
			$aBubbleGrid[$x][$y] = Random(0, 4, 1)
			_paintNormalBubble($x, $y, $bmpToDraw)
		Next
	Next

	CopyExtBmp($picture, 0, 0, 700, 700, $bmpToDraw, 0, 0, 0)
EndFunc   ;==>_initGrid

Func _initBubbleFiles($initBubbleSize = 40)
	$aBubbleFile[0] = LoadExtImage(@scriptdir & "\misc\bubbleB.jpg") ; color 0 = blue
	$aBubbleFile[1] = LoadExtImage(@scriptdir & "\misc\bubbleG.jpg") ; color 1 = green
	$aBubbleFile[2] = LoadExtImage(@scriptdir & "\misc\bubbleR.jpg") ; color 2 = red
	$aBubbleFile[3] = LoadExtImage(@scriptdir & "\misc\bubbleY.jpg") ; color 3 = yellow
	$aBubbleFile[4] = LoadExtImage(@scriptdir & "\misc\bubbleP.jpg") ; color 4 = purple
EndFunc   ;==>_initBubbleFiles

Func _exit()
	HotKeySet("{Esc}")
	Local $hDC_backup = CreateExtBmp(700, 700)
	CopyExtBmp($hDC_backup, 0, 0, 700, 700, $hDC, 0, 0, 0)
	If Not $gameOver Then
		Local $tempFX = InitExtFX($hDC_backup)
		For $loop = 1 To 10
			blur($hDC, 0, 0, $tempFX)
			Sleep(5)
		Next
		FreeExtFx($tempFX)
		_SoundPause($sndMusic)
		_SoundStop($snd)
		If $totalScore > 0 Then _sayMakeSound(@ScriptDir & "\numbers\scoreis.mp3")
		If $totalScore > 0 Then _say($totalScore)
		$snd = _SoundOpen(@scriptdir & "\misc\rusure.mp3")
		_SoundSeek($snd, 0, 0, 0)
		_SoundPlay($snd, 1)
		_SoundResume($sndMusic)
		Local $answer = MsgBox(4, "Are You Sure?", "Are you sure you want to quit?")
		If $answer = 6 Then
			_quitForReal()
		EndIf
	Else
		MsgBox(0, "Game Over", "Game Over!" & @CRLF & @CRLF & "Total score: " & $totalScore & @CRLF & @CRLF & "Press OK to quit.")
		_quitForReal()
	EndIf
	_SoundStop($snd)
	_SoundResume($sndMusic)
	CopyExtBmp($hDC, 0, 0, 700, 700, $hDC_backup, 0, 0, 0)
	FreeExtBmp($hDC_backup)
	HotKeySet("{Esc}", "_exit")
EndFunc   ;==>_exit

Func _exit2()
	Exit
EndFunc   ;==>_exit2

Func _quitForReal()
	_SoundStop($snd)
	_SoundStop($sndMusic)
	HotKeySet("{Esc}", "_exit2")
	$snd = _SoundOpen(@scriptdir & "\misc\MandG.mp3")
	_SoundSeek($snd, 0, 0, 0)
	_SoundPlay($snd, 0)
	While _SoundStatus($snd) = "playing"
		Sleep(10)
	WEnd
	Sleep(500)
	$snd = _SoundOpen(@scriptdir & "\misc\thanks.mp3")
	_SoundSeek($snd, 0, 0, 0)
	_SoundPlay($snd, 0)
	While _SoundStatus($snd) = "playing"
		Sleep(10)
	WEnd
	FreeAllExtBmps()
	Exit
EndFunc   ;==>_quitForReal

Func _speakTotalScore()
	Local $t = $totalScore
	_SoundStop($snd)
	_sayMakeSound(@ScriptDir & "\numbers\TotalScr.mp3")
	_say($t)
EndFunc   ;==>_speakTotalScore

Func _say($i)
	If $i = 0 Then Return
	If $i > 1000 Then
		_say(Int($i / 1000))
		_say(1000)
		_say(Mod($i, 1000))
	ElseIf $i = 1000 Then
		_sayMakeSound(@ScriptDir & "\numbers\1000.mp3")
	ElseIf $i = 100 Then
		_sayMakeSound(@ScriptDir & "\numbers\1.mp3")
		_sayMakeSound(@ScriptDir & "\numbers\100.mp3")
	ElseIf Int($i / 100) > 0 Then ; 100 < $i < 999
		_say(Int($i / 100))
		_sayMakeSound(@ScriptDir & "\numbers\100.mp3")
		If Mod($i, 100) > 0 Then _sayMakeSound(@ScriptDir & "\numbers\and.mp3")
		_say(Mod($i, 100))
	ElseIf $i > 19 Then ; 20 <= $i < 99
		_sayMakeSound(@ScriptDir & "\numbers\" & Int($i / 10) & "0.mp3")
		_sayMakeSound(@ScriptDir & "\numbers\" & Mod($i, 10) & ".mp3")
	Else ; 1 <= $i < 20
		_sayMakeSound(@ScriptDir & "\numbers\" & $i & ".mp3")
	EndIf
EndFunc   ;==>_say

Func _sayMakeSound($fileToPlay)
	$snd = _SoundOpen($fileToPlay)
	;_SoundSeek($snd, 0, 0, 0)
	_SoundPlay($snd, 1)
EndFunc   ;==>_sayMakeSound