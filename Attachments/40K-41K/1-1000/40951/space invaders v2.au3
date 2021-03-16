#include <GDIPlus.au3>
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include <Misc.au3>
#include <WinAPI.au3>
#include <Array.au3>

Opt("GUIOnEventMode", 1)
Opt("MustDeclareVars", 1)

#region setup
Global $hWidth = 416
Global $hHeight = 416
Global $dll = DllOpen("user32.dll")
HotKeySet("{SPACE}", "_shoot")

_GDIPlus_Startup()
Global $hWnd = GUICreate("", $hWidth, $hHeight) ;, -1, -1, $WS_BORDER)
GUISetOnEvent($GUI_EVENT_CLOSE, "close")
GUISetState()
;Transparency: _WinAPI_SetLayeredWindowAttributes($hWnd, 0x000000, 255)

Global $hGraphics = _GDIPlus_GraphicsCreateFromHWND($hWnd)
Global $hBMP = _GDIPlus_BitmapCreateFromGraphics($hWidth, $hHeight, $hGraphics)
Global $bmG = _GDIPlus_ImageGetGraphicsContext($hBMP)
_GDIPlus_GraphicsSetSmoothingMode($bmG, 2)
_GDIPlus_GraphicsClear($bmG, 0xFF000000)
#endregion
#cs
#ce

#region text & brushes
Global $hBrushWhite = _GDIPlus_BrushCreateSolid(0xFFFFFFFF)
Global $hBrushGreen = _GDIPlus_BrushCreateSolid(0xFF00FF00)
Global $hFormat = _GDIPlus_StringFormatCreate()
Global $hFamily = _GDIPlus_FontFamilyCreate("Courier New")
Global $hFont = _GDIPlus_FontCreate($hFamily, 10)
Global $tLayout_ScoreName = _GDIPlus_RectFCreate(20, 10, 100, 20)
Global $tLayout_Score = _GDIPlus_RectFCreate(24, 22, 100, 20)
Global $tLayout_HiScoreName = _GDIPlus_RectFCreate($hWidth - 100 + 10, 10, 100, 20)
Global $tLayout_HiScore = _GDIPlus_RectFCreate($hWidth - 100 + 24, 22, 100, 20)
Global $tLayout_Lives = _GDIPlus_RectFCreate(10, $hHeight - 20, 100, 20)
Global $tLayout_Title = _GDIPlus_RectFCreate($hWidth/2 - 60, 10, 150, 20)
Global $tLayout_Credit = _GDIPlus_RectFCreate($hWidth - 100 + 10, $hHeight - 20, 100, 20)
Global $tLayout_Play = _GDIPlus_RectFCreate($hWidth/2 - 20, 75, 150, 20)
Global $tLayout_ScoreList = _GDIPlus_RectFCreate($hWidth/2 - 90, 150, 200, 20)
Global $tLayout_Mystery = _GDIPlus_RectFCreate($hWidth/2 - 35, 175, 150, 20)
Global $tLayout_Points1 = _GDIPlus_RectFCreate($hWidth/2 - 35, 200, 150, 20)
Global $tLayout_Points2 = _GDIPlus_RectFCreate($hWidth/2 - 35, 225, 150, 20)
Global $tLayout_Points3 = _GDIPlus_RectFCreate($hWidth/2 - 35, 250, 150, 20)
Global $tLayout_Wavenumber = _GDIPlus_RectFCreate($hWidth/2 - 25, 175, 150, 20)
#endregion
#cs
#ce

Global $player[2] = [$hWidth/2, 0]
Global $score = 0
Global $lives = 3
Global $wave = 1
Global $aliens[1][5] = [[30, 30, 1, 0, 0]] ;x,y,type,lives,anim
Global $shot[1][2] = [[0,0]]
Global $count = 0, $dir = +4, $n = 0, $trigger = 2, $down_right = 0
Global $rightMax, $leftMax, $basemax
Global $missile[1][3] = [[0,0,0]]
Global $highscore = 0
Global $hit = False
Global $mShip = False
Global $mTimer
Global $sFired = 0
Global $hCount = 0

Local $pixelArray[8][12][10]
Local $bmpObj[8]
#region ships
#cs
[[0,0,0,0,0,0,0,0,0,0,0,0], _
 [0,0,0,0,0,0,0,0,0,0,0,0], _
 [0,0,0,0,0,0,0,0,0,0,0,0], _
 [0,0,0,0,0,0,0,0,0,0,0,0], _
 [0,0,0,0,0,0,0,0,0,0,0,0], _
 [0,0,0,0,0,0,0,0,0,0,0,0], _
 [0,0,0,0,0,0,0,0,0,0,0,0], _
 [0,0,0,0,0,0,0,0,0,0,0,0], _
 [0,0,0,0,0,0,0,0,0,0,0,0], _
 [0,0,0,0,0,0,0,0,0,0,0,0]]
#ce
Local $type0[10][12] = _
[[0,0,0,0,0,1,1,0,0,0,0,0], _
 [0,0,0,0,0,1,1,0,0,0,0,0], _
 [0,0,0,0,0,1,1,0,0,0,0,0], _
 [0,1,1,1,1,1,1,1,1,1,1,0], _
 [1,1,1,1,1,1,1,1,1,1,1,1], _
 [1,1,1,1,1,1,1,1,1,1,1,1], _
 [1,1,1,1,1,1,1,1,1,1,1,1], _
 [1,1,1,1,1,1,1,1,1,1,1,1], _
 [0,0,0,0,0,0,0,0,0,0,0,0], _
 [0,0,0,0,0,0,0,0,0,0,0,0]]
Local $type1[10][12] = _
[[0,0,0,0,0,0,0,0,0,0,0,0], _
 [0,0,0,0,0,1,1,0,0,0,0,0], _
 [0,0,0,0,1,1,1,1,0,0,0,0], _
 [0,0,0,1,1,1,1,1,1,0,0,0], _
 [0,0,1,1,0,1,1,0,1,1,0,0], _
 [0,0,1,1,1,1,1,1,1,1,0,0], _
 [0,0,0,0,1,0,0,1,0,0,0,0], _
 [0,0,0,1,0,1,1,0,1,0,0,0], _
 [0,0,1,0,1,0,0,1,0,1,0,0], _
 [0,0,0,0,0,0,0,0,0,0,0,0]]
Local $type2[10][12] = _
[[0,0,1,0,0,0,0,0,1,0,0,0], _
 [1,0,0,1,0,0,0,1,0,0,1,0], _
 [1,0,1,1,1,1,1,1,1,0,1,0], _
 [1,1,1,0,1,1,1,0,1,1,1,0], _
 [1,1,1,1,1,1,1,1,1,1,1,0], _
 [0,1,1,1,1,1,1,1,1,1,0,0], _
 [0,0,1,0,0,0,0,0,1,0,0,0], _
 [0,1,0,0,0,0,0,0,0,1,0,0], _
 [0,0,0,0,0,0,0,0,0,0,0,0], _
 [0,0,0,0,0,0,0,0,0,0,0,0]]
Local $type3[10][12] = _
[[0,0,0,0,0,0,0,0,0,0,0,0], _
 [0,0,0,0,0,0,0,0,0,0,0,0], _
 [0,0,0,0,1,1,1,1,0,0,0,0], _
 [0,1,1,1,1,1,1,1,1,1,1,0], _
 [1,1,1,1,1,1,1,1,1,1,1,1], _
 [1,1,1,0,0,1,1,0,0,1,1,1], _
 [1,1,1,1,1,1,1,1,1,1,1,1], _
 [0,0,0,1,1,0,0,1,1,0,0,0], _
 [0,0,1,1,0,1,1,0,1,1,0,0], _
 [1,1,0,0,0,0,0,0,0,0,1,1]]
Local $type4[10][12] = _
[[0,0,0,0,0,0,0,0,0,0,0,0], _
 [0,0,0,0,0,1,1,0,0,0,0,0], _
 [0,0,0,0,1,1,1,1,0,0,0,0], _
 [0,0,0,1,1,1,1,1,1,0,0,0], _
 [0,0,1,1,0,1,1,0,1,1,0,0], _
 [0,0,1,1,1,1,1,1,1,1,0,0], _
 [0,0,0,1,0,1,1,0,1,0,0,0], _
 [0,0,1,0,0,0,0,0,0,1,0,0], _
 [0,0,0,1,0,0,0,0,1,0,0,0], _
 [0,0,0,0,0,0,0,0,0,0,0,0]]
Local $type5[10][12] = _
[[0,0,0,1,0,0,0,0,0,1,0,0], _
 [0,0,0,0,1,0,0,0,1,0,0,0], _
 [0,0,0,1,1,1,1,1,1,1,0,0], _
 [0,0,1,1,0,1,1,1,0,1,1,0], _
 [0,1,1,1,1,1,1,1,1,1,1,1], _
 [0,1,0,1,1,1,1,1,1,1,0,1], _
 [0,1,0,1,0,0,0,0,0,1,0,1], _
 [0,0,0,0,1,1,0,1,1,0,0,0], _
 [0,0,0,0,0,0,0,0,0,0,0,0], _
 [0,0,0,0,0,0,0,0,0,0,0,0]]
Local $type6[10][12] = _
[[0,0,0,0,0,0,0,0,0,0,0,0], _
 [0,0,0,0,0,0,0,0,0,0,0,0], _
 [0,0,0,0,1,1,1,1,0,0,0,0], _
 [0,1,1,1,1,1,1,1,1,1,1,0], _
 [1,1,1,1,1,1,1,1,1,1,1,1], _
 [1,1,1,0,0,1,1,0,0,1,1,1], _
 [1,1,1,1,1,1,1,1,1,1,1,1], _
 [0,0,1,1,1,0,0,1,1,1,0,0], _
 [0,1,1,0,0,1,1,0,0,1,1,0], _
 [0,0,1,1,0,0,0,0,1,1,0,0]]
Local $type7[10][12] = _
[[0,0,0,0,0,0,0,0,0,0,0,0], _
 [0,0,0,0,0,0,0,0,0,0,0,0], _
 [0,0,0,1,1,1,1,1,0,0,0,0], _
 [0,0,1,1,1,1,1,1,1,0,0,0], _
 [0,1,1,1,1,1,1,1,1,1,0,0], _
 [1,1,0,1,0,1,0,1,0,1,1,0], _
 [1,1,1,1,1,1,1,1,1,1,1,0], _
 [0,1,1,0,0,1,0,0,1,1,0,0], _
 [0,0,1,0,0,0,0,0,1,0,0,0], _
 [0,0,0,0,0,0,0,0,0,0,0,0]]
For $i = 0 To 11
   For $j = 0 To 9
	  $pixelArray[0][$i][$j] = $type0[$j][$i]
	  $pixelArray[1][$i][$j] = $type1[$j][$i]
	  $pixelArray[2][$i][$j] = $type2[$j][$i]
	  $pixelArray[3][$i][$j] = $type3[$j][$i]
	  $pixelArray[4][$i][$j] = $type4[$j][$i]
	  $pixelArray[5][$i][$j] = $type5[$j][$i]
	  $pixelArray[6][$i][$j] = $type6[$j][$i]
	  $pixelArray[7][$i][$j] = $type7[$j][$i]
   Next
Next
$type0 = 0
$type1 = 0
$type2 = 0
$type3 = 0
$type4 = 0
$type5 = 0
$type6 = 0
For $i = 0 To UBound($pixelArray,1)-1
   $bmpObj[$i] = _GDIPlus_BitmapCreateFromGraphics(24, 20, $hGraphics)
   Local $graphics2 = _GDIPlus_ImageGetGraphicsContext($bmpObj[$i])
   _GDIPlus_GraphicsSetSmoothingMode($graphics2, 2)
   _GDIPlus_GraphicsClear($graphics2, 0xFF000000)
   _drawAlien(12, 10, $i, $graphics2)
   _GDIPlus_GraphicsDispose($graphics2)
Next
#endregion
#cs
#ce

Global $wCount
Global $waveOver = False
#region wave formats
Global $waveStructure[11][5] = _ ; Written top to bottom. 1 = hard, 2 = med, 3 = easy
[[1,2,2,3,3], _
 [1,2,2,2,3], _
 [1,1,2,3,3], _
 [1,1,2,2,3], _
 [1,2,2,2,2], _
 [1,1,2,2,2], _
 [1,1,1,2,3], _
 [1,1,1,2,2], _
 [1,1,1,1,3], _
 [1,1,1,1,2], _
 [1,1,1,1,1]]
#endregion
#cs
#ce


_menu()
$mTimer = TimerInit()
$waveOver = True
$wCount = TimerInit()
;_loadWave(1)
While 1
   Local $fps = TimerInit()
   $trigger = 2 + (UBound($aliens,1)-1)
   $count += 1
   If $hit Then $hCount += 1
   If $hCount >= 120 Then
	  $hit = False
	  $player[0] = $hWidth/2
	  $hCount = 0
   EndIf

   If _IsPressed(25, $dll) Then $player[0] -= 2
   If _IsPressed(27, $dll) Then $player[0] += 2
   If $player[0] <= 16 Then $player[0] = 16
   If $player[0] >= $hWidth-16 Then $player[0] = $hWidth-16
   
   _GDIPlus_GraphicsClear($bmG, 0xFF000000)
   
   For $i = UBound($shot,1)-1 To 1 Step -1
	  $shot[$i][1] -= 4
	  _drawShot($shot[$i][0], $shot[$i][1])
	  If $shot[$i][1] < 0 Then _ArrayDelete($shot, $i)
   Next
   For $i = UBound($missile,1)-1 To 1 Step -1
	  $missile[$i][1] += 3
	  _drawMissile($missile[$i][0], $missile[$i][1], $missile[$i][2])
	  
	  If _inRect($missile[$i][0], $missile[$i][1], $player[0]-12, $hHeight - 36 - 8 - 10, 24, 20) Then
		 _ArrayDelete($missile, $i)
		 If Not $hit Then $lives -= 1
		 $hit = True
		 ContinueLoop
	  EndIf
	  If $missile[$i][1] > $hHeight - 31 Then _ArrayDelete($missile, $i)
   Next
   
   $down_right = 0
   If $count >= $trigger Then
	  $count = 0
	  $n += ($dir/Abs($dir))
	  If ($leftMax < 10 And $dir < 0) Or ($rightMax > $hWidth-10 And $dir > 0) Then
		 $down_right = 1
		 $dir = -1*$dir
	  Else
		 $down_right = 2
	  EndIf
   EndIf
   $rightMax = 0
   $leftMax = $hWidth
   $baseMax = 0
   
   For $i = UBound($aliens,1)-1 To 1 Step -1
	  If $aliens[$i][2] = 4 Then
		 If $down_right Then $aliens[$i][0] += 10
		 If $aliens[$i][0] >= $hWidth Then
			_ArrayDelete($aliens, $i)
			$mShip = False
			$mTimer = TimerInit()
			ContinueLoop
		 EndIf
		 _GDIPlus_GraphicsDrawImageRect($bmG, $bmpObj[$aliens[$i][2]+3], $aliens[$i][0]-12, $aliens[$i][1]-10, 24, 20)
		 For $j = UBound($shot,1)-1 To 1 Step -1
			If _inRect($shot[$j][0], $shot[$j][1], $aliens[$i][0]-12, $aliens[$i][1]-10, 24, 20) Then
			   _ArrayDelete($shot, $j)
			   $aliens[$i][3] -= 1
			   If $aliens[$i][3] <= 0 Then
				  $score += Round(Random(50, 300, 1), -1)
				  _ArrayDelete($aliens, $i)
				  $mShip = False
				  $mTimer = TimerInit()
				  ContinueLoop 2
			   EndIf
			EndIf
		 Next
		 ContinueLoop
	  EndIf
	  
	  If $down_right = 1 Then
		 $aliens[$i][1] += 4
	  ElseIf $down_right = 2 Then
		 $aliens[$i][0] += $dir
	  EndIf
	  
	  If $aliens[$i][0] - 12 < $leftMax Then $leftMax = $aliens[$i][0] - 12
	  If $aliens[$i][0] + 12 > $rightMax Then $rightMax = $aliens[$i][0] + 12
	  If $aliens[$i][1] > $baseMax Then $baseMax = $aliens[$i][1]
		 
	  If Random(1, 10) > 9.995 Then
		 ReDim $missile[UBound($missile,1)+1][UBound($missile,2)]
		 $missile[UBound($missile,1)-1][0] = $aliens[$i][0]
		 $missile[UBound($missile,1)-1][1] = $aliens[$i][1] + 10
		 $missile[UBound($missile,1)-1][2] = $aliens[$i][2]
	  EndIf
	  
	  _GDIPlus_GraphicsDrawImageRect($bmG, $bmpObj[$aliens[$i][2]+3], $aliens[$i][0]-12, $aliens[$i][1]-10, 24, 20)
	  
	  For $j = UBound($shot,1)-1 To 1 Step -1
		 If _inRect($shot[$j][0], $shot[$j][1], $aliens[$i][0]-12, $aliens[$i][1]-10, 24, 20) Then
			_ArrayDelete($shot, $j)
			$aliens[$i][3] -= 1
			If $aliens[$i][3] <= 0 Then
			   $score += 10*(4-$aliens[$i][2])
			   _ArrayDelete($aliens, $i)
			   ContinueLoop 2
			EndIf
		 EndIf
	  Next
   Next
   If Random(0, 100) > 99.975 And Not $mShip And TimerDiff($mTimer) > 5000 And UBound($aliens,1)-1 > 8 Then
	  ReDim $aliens[UBound($aliens,1)+1][5]
	  $aliens[UBound($aliens,1)-1][0] = 0
	  $aliens[UBound($aliens,1)-1][1] = 40
	  $aliens[UBound($aliens,1)-1][2] = 4
	  $aliens[UBound($aliens,1)-1][3] = 1
	  $mShip = True
   EndIf
   
   If $baseMax >= $hHeight - 66 Then $lives = 0
   
   If Not $hit Then _GDIPlus_GraphicsDrawImageRect($bmG, $bmpObj[0], $player[0]-12, $hHeight - 36 - 8 - 10, 24, 20)
   
   _GDIPlus_GraphicsFillRect($bmG, 0, $hHeight - 26, $hWidth, 1, $hBrushGreen)
   
   _GDIPlus_GraphicsDrawStringEx($bmG, "SCORE", $hFont, $tLayout_ScoreName, $hFormat, $hBrushWhite)
   _GDIPlus_GraphicsDrawStringEx($bmG, _padScore($score), $hFont, $tLayout_Score, $hFormat, $hBrushWhite)
   _GDIPlus_GraphicsDrawStringEx($bmG, "HI-SCORE", $hFont, $tLayout_HiScoreName, $hFormat, $hBrushWhite)
   _GDIPlus_GraphicsDrawStringEx($bmG, _padScore($highscore), $hFont, $tLayout_HiScore, $hFormat, $hBrushWhite)
   _GDIPlus_GraphicsDrawStringEx($bmG, "LIVES", $hFont, $tLayout_Lives, $hFormat, $hBrushWhite)
   _GDIPlus_GraphicsDrawStringEx($bmG, "SPACE INVADERS", $hFont, $tLayout_Title, $hFormat, $hBrushWhite)
   _GDIPlus_GraphicsDrawStringEx($bmG, "CREDIT 00", $hFont, $tLayout_Credit, $hFormat, $hBrushWhite)
   For $i = 1 To $lives
	  _GDIPlus_GraphicsDrawImageRect($bmG, $bmpObj[0], 10 + 50 + (24+2)*($i-1), $hHeight - 22, 24, 20)
   Next
   If $waveOver Then _GDIPlus_GraphicsDrawStringEx($bmG, "WAVE " & $wave, $hFont, $tLayout_Wavenumber, $hFormat, $hBrushWhite)
   
   _GDIPlus_GraphicsDrawImageRect($hGraphics, $hBMP, 0, 0, $hWidth, $hHeight)
   
   If $score > $highscore Then $highscore = $score
   If UBound($aliens,1)-1 == 0 And Not $waveOver Then
	  $wave += 1
	  $waveOver = True
	  $wCount = TimerInit()
   ElseIf $waveOver And TimerDiff($wCount) > 1500 Then
	  _loadWave($wave)
	  $waveOver = False
   EndIf
   
   If $lives == 0 Then
	  _menu()
	  $score = 0
	  $lives = 3
	  $wave = 1
	  ReDim $shot[1][2]
	  ReDim $missile[1][3]
	  $mTimer = TimerInit()
	  _loadWave($wave)
   EndIf
   
   ;Sleep((1000/100) - TimerDiff($fps))
WEnd

Func _menu()
   While 1
	  If _IsPressed("0D", $dll) Then Return
	  _GDIPlus_GraphicsClear($bmG, 0xFF000000)
	  _GDIPlus_GraphicsDrawStringEx($bmG, "SCORE", $hFont, $tLayout_ScoreName, $hFormat, $hBrushWhite)
	  _GDIPlus_GraphicsDrawStringEx($bmG, _padScore($score), $hFont, $tLayout_Score, $hFormat, $hBrushWhite)
	  _GDIPlus_GraphicsDrawStringEx($bmG, "HI-SCORE", $hFont, $tLayout_HiScoreName, $hFormat, $hBrushWhite)
	  _GDIPlus_GraphicsDrawStringEx($bmG, _padScore($highscore), $hFont, $tLayout_HiScore, $hFormat, $hBrushWhite)
	  _GDIPlus_GraphicsDrawStringEx($bmG, "SPACE INVADERS", $hFont, $tLayout_Title, $hFormat, $hBrushWhite)
	  _GDIPlus_GraphicsDrawStringEx($bmG, "CREDIT 00", $hFont, $tLayout_Credit, $hFormat, $hBrushWhite)
	  _GDIPlus_GraphicsDrawStringEx($bmG, "PLAY", $hFont, $tLayout_Play, $hFormat, $hBrushWhite)
	  _GDIPlus_GraphicsDrawStringEx($bmG, "*SCORE ADVANCE TABLE*", $hFont, $tLayout_ScoreList, $hFormat, $hBrushWhite)
	  
	  _GDIPlus_GraphicsDrawStringEx($bmG, "= ? MYSTERY", $hFont, $tLayout_Mystery, $hFormat, $hBrushWhite)
	  _GDIPlus_GraphicsDrawImageRect($bmG, $bmpObj[7], $hWidth/2 - 63, 170, 24, 20)
	  _GDIPlus_GraphicsDrawStringEx($bmG, "= 30 POINTS", $hFont, $tLayout_Points1, $hFormat, $hBrushWhite)
	  _GDIPlus_GraphicsDrawImageRect($bmG, $bmpObj[1], $hWidth/2 - 63, 195, 24, 20)
	  _GDIPlus_GraphicsDrawStringEx($bmG, "= 20 POINTS", $hFont, $tLayout_Points2, $hFormat, $hBrushWhite)
	  _GDIPlus_GraphicsDrawImageRect($bmG, $bmpObj[5], $hWidth/2 - 63, 220, 24, 20)
	  _GDIPlus_GraphicsDrawStringEx($bmG, "= 10 POINTS", $hFont, $tLayout_Points3, $hFormat, $hBrushGreen)
	  _GDIPlus_GraphicsDrawImageRect($bmG, $bmpObj[6], $hWidth/2 - 63, 245, 24, 20)
	  _GDIPlus_GraphicsDrawImageRect($hGraphics, $hBMP, 0, 0, $hWidth, $hHeight)
   WEnd
EndFunc

Func _shoot()
   If $hit Then Return
   If UBound($shot,1) > 1 Then Return
   ReDim $shot[UBound($shot,1)+1][UBound($shot,2)]
   $shot[UBound($shot,1)-1][0] = $player[0]
   $shot[UBound($shot,1)-1][1] = $hHeight - 28 - 10 - 3
   $sFired += 1
EndFunc

Func _drawAlien($iX, $iY, $iType, $hDest = $bmG) 
   For $i = 0 To 11
	  For $j = 0 To 9
		 If $pixelArray[$iType][$i][$j] == 1 Then
			If $iType > 0 Then _GDIPlus_GraphicsFillRect($hDest, $iX - ($i-5)*2, $iY + ($j-5)*2, 2, 2, $hBrushWhite)
			If $iType = 0 Then _GDIPlus_GraphicsFillRect($hDest, $iX - ($i-5)*2, $iY + ($j-5)*2, 2, 2, $hBrushGreen)
		 EndIf
	  Next
   Next
EndFunc

Func _drawShot($iX, $iY)
   _GDIPlus_GraphicsFillRect($bmG, $iX - 2, $iY + 1, 2, 2, $hBrushGreen)
   _GDIPlus_GraphicsFillRect($bmG, $iX - 2, $iY - 1, 2, 2, $hBrushGreen)
   _GDIPlus_GraphicsFillRect($bmG, $iX - 2, $iY - 3, 2, 2, $hBrushGreen)
   _GDIPlus_GraphicsFillRect($bmG, $iX, $iY + 1, 2, 2, $hBrushGreen)
   _GDIPlus_GraphicsFillRect($bmG, $iX, $iY - 1, 2, 2, $hBrushGreen)
   _GDIPlus_GraphicsFillRect($bmG, $iX, $iY - 3, 2, 2, $hBrushGreen)
EndFunc

Func _drawMissile($iX, $iY, $iStyle)
   Switch $iStyle
	  Case 1
		 _GDIPlus_GraphicsFillRect($bmG, $iX - 3, $iY - 5, 2, 2, $hBrushWhite)
		 _GDIPlus_GraphicsFillRect($bmG, $iX - 3, $iY - 1, 2, 2, $hBrushWhite)
		 _GDIPlus_GraphicsFillRect($bmG, $iX - 3, $iY + 3, 2, 2, $hBrushWhite)
		 _GDIPlus_GraphicsFillRect($bmG, $iX - 1, $iY + 3, 2, 2, $hBrushWhite)
		 _GDIPlus_GraphicsFillRect($bmG, $iX - 1, $iY + 1, 2, 2, $hBrushWhite)
		 _GDIPlus_GraphicsFillRect($bmG, $iX - 1, $iY - 1, 2, 2, $hBrushWhite)
		 _GDIPlus_GraphicsFillRect($bmG, $iX - 1, $iY - 3, 2, 2, $hBrushWhite)
		 _GDIPlus_GraphicsFillRect($bmG, $iX - 1, $iY - 5, 2, 2, $hBrushWhite)
		 _GDIPlus_GraphicsFillRect($bmG, $iX + 1, $iY + 1, 2, 2, $hBrushWhite)
		 _GDIPlus_GraphicsFillRect($bmG, $iX + 1, $iY - 3, 2, 2, $hBrushWhite)
	  Case 2
		 _GDIPlus_GraphicsFillRect($bmG, $iX - 3, $iY + 1, 2, 2, $hBrushWhite)
		 _GDIPlus_GraphicsFillRect($bmG, $iX - 3, $iY - 3, 2, 2, $hBrushWhite)
		 _GDIPlus_GraphicsFillRect($bmG, $iX - 1, $iY + 3, 2, 2, $hBrushWhite)
		 _GDIPlus_GraphicsFillRect($bmG, $iX - 1, $iY + 1, 2, 2, $hBrushWhite)
		 _GDIPlus_GraphicsFillRect($bmG, $iX - 1, $iY - 1, 2, 2, $hBrushWhite)
		 _GDIPlus_GraphicsFillRect($bmG, $iX - 1, $iY - 3, 2, 2, $hBrushWhite)
		 _GDIPlus_GraphicsFillRect($bmG, $iX - 1, $iY - 5, 2, 2, $hBrushWhite)
		 _GDIPlus_GraphicsFillRect($bmG, $iX + 1, $iY - 1, 2, 2, $hBrushWhite)
		 _GDIPlus_GraphicsFillRect($bmG, $iX + 1, $iY + 3, 2, 2, $hBrushWhite)
	  Case 3
		 _GDIPlus_GraphicsFillRect($bmG, $iX - 3, $iY - 1, 2, 2, $hBrushWhite)
		 _GDIPlus_GraphicsFillRect($bmG, $iX - 1, $iY + 3, 2, 2, $hBrushWhite)
		 _GDIPlus_GraphicsFillRect($bmG, $iX - 1, $iY + 1, 2, 2, $hBrushWhite)
		 _GDIPlus_GraphicsFillRect($bmG, $iX - 1, $iY - 1, 2, 2, $hBrushWhite)
		 _GDIPlus_GraphicsFillRect($bmG, $iX - 1, $iY - 3, 2, 2, $hBrushWhite)
		 _GDIPlus_GraphicsFillRect($bmG, $iX - 1, $iY - 5, 2, 2, $hBrushWhite)
		 _GDIPlus_GraphicsFillRect($bmG, $iX + 1, $iY - 1, 2, 2, $hBrushWhite)
   EndSwitch
EndFunc

Func _inRect($iX, $iY, $iTopX, $iTopY, $iWidth, $iHeight)
   If $iX < $iTopX Then Return 0
   If $iY < $iTopY Then Return 0
   If $iX > $iTopX+$iWidth Then Return 0
   If $iY > $iTopY+$iHeight Then Return 0
   Return 1
EndFunc

Func _padScore($number)
   Local $l = StringLen($number)
   Local $zeros = 4 - $l
   Local $str = "" & $number
   If $l > 4 Then Return $str ;StringMid($number, $l-4, 4)
   For $i = 1 To $zeros
	  $str = "0" & $str
   Next
   Return $str
EndFunc

Func _loadWave($iWaveNumber)
   If $iWaveNumber > UBound($waveStructure,1) Then $iWaveNumber = UBound($waveStructure,1)
   For $j = 1 To 5
	  For $i = 1 To 11
		 ReDim $aliens[$i+(($j-1)*11)+1][5]
		 $aliens[$i+(($j-1)*11)][0] = 6+6+2 + (24+12)*($i-1)
		 $aliens[$i+(($j-1)*11)][1] = 60 + (20+12)*($j-1)
		 $aliens[$i+(($j-1)*11)][2] = $waveStructure[$iWaveNumber-1][$j-1]
		 $aliens[$i+(($j-1)*11)][3] = 4 - $waveStructure[$iWaveNumber-1][$j-1]
	  Next
   Next
EndFunc


Func close() ;shuts down GDIPlus
   _GDIPlus_GraphicsDispose($hGraphics)
   _GDIPlus_GraphicsDispose($bmG)
   _GDIPlus_BitmapDispose($hBMP)
   _GDIPlus_BrushDispose($hBrushWhite)
   _GDIPlus_BrushDispose($hBrushGreen)
   _GDIPlus_StringFormatDispose($hFormat)
   _GDIPlus_FontFamilyDispose($hFamily)
   _GDIPlus_FontDispose($hFont)
   For $i = 0 To UBound($bmpObj)-1
	  _GDIPlus_BitmapDispose($bmpObj[$i])
   Next
   _GDIPlus_Shutdown()
   DLLClose($dll)
   Exit
EndFunc