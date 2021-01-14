#NoTrayIcon
#include <GUIConstants.au3>
#include <Misc.au3>
Opt("GUIOnEventMode", 1)
#region -- Define Variables --
Global $BGColor = 0x555555, $PlayerColor = 0x5555FF, $CPUColor = 0xFF5555, $BallColor = 0xFFFFFF  ; Colors
Global $Difficulty = 2  ; Difficulty
Global $SmallSize[2] = [375, 200], $MedSize[2] = [500, 350], $LargeSize[2] = [650, 500], $curSize[2] = [$MedSize[0], $MedSize[1]]  ; Sizes
Global $ballSize = 30 / $Difficulty, $ballSpeed = 10 / $Difficulty  ; Set ball size and speed - what difficulty is
Global $playerScore = 0, $CPUScore = 0  ; Scores

Const $TITLE = "Pong!"                     ; application name
Const $VERSION = "0.1"                        ; software version
Const $REGS = "HKEY_CURRENT_USER\Software\Pong" ; key in registry
#endregion

#region -- Get Preset Values or Set if first time run --
$regExsistsQ = RegRead($REGS, "Version")

If $regExsistsQ <> $VERSION Then  ; Set Values to Registery if version is old or non-esistent
	
EndIf
#endregion

#Region  -- Setup main GUI, menu, background, paddles,and ball --
$pongGUI = GUICreate("PONG", $curSize[0], $curSize[1], "-1", "-1")
GUISetBkColor($BGColor)

$player = GUICtrlCreateLabel("", 7, $curSize[1] / 2 - 25, 7, 50)  ; Create Player Paddle
GUICtrlSetBkColor(-1, $PlayerColor)

$CPU = GUICtrlCreateLabel("", $curSize[0] - 15, $curSize[1] / 2 - 25, 7, 50)  ; Create CPU Paddle
GUICtrlSetBkColor(-1, $CPUColor)

For $n = 0 To $LargeSize[0] Step 40
	GUICtrlCreateLabel("", $curSize[0] / 2 - 5, $n, 10, 30)
	GUICtrlSetBkColor(-1, 0xf9f9f9)
Next

$fileMenu = GUICtrlCreateMenu("&File")
$menuPause = GUICtrlCreateMenuitem("&Pause", $fileMenu)
GUICtrlSetOnEvent(-1, "")
$menuNewGame = GUICtrlCreateMenuitem("New Game  (F2)", $fileMenu)
GUICtrlSetOnEvent(-1, "")
GUICtrlCreateMenuitem("", $fileMenu)
$menuExit = GUICtrlCreateMenuitem("E&xit", $fileMenu)
GUICtrlSetOnEvent(-1, "end")
$optMenu = GUICtrlCreateMenu("&Options")
$colorMenu = GUICtrlCreateMenu("Color: ", $optMenu)
$colorBall = GUICtrlCreateMenuitem("Ball Color", $colorMenu)
GUICtrlSetOnEvent(-1, "setColor")
GUICtrlSetColor(-1, $BallColor)
$colorCPU = GUICtrlCreateMenuitem("CPU Paddle Color", $colorMenu)
GUICtrlSetOnEvent(-1, "setColor")
GUICtrlSetColor(-1, $colorCPU)
$colorPlayer = GUICtrlCreateMenuitem("Player Paddle Color", $colorMenu)
GUICtrlSetOnEvent(-1, "setColor")
GUICtrlSetColor(-1, $colorPlayer)
$colorBG = GUICtrlCreateMenuitem("Back-Ground Color", $colorMenu)
GUICtrlSetOnEvent(-1, "setColor")
GUICtrlSetColor(-1, $colorBG)
$sizeMenu = GUICtrlCreateMenu("Size: ", $optMenu)
$sizeSmall = GUICtrlCreateMenuitem("Small", $sizeMenu)
GUICtrlSetOnEvent(-1, "setSize")
$sizeMed = GUICtrlCreateMenuitem("Medium", $sizeMenu)
GUICtrlSetOnEvent(-1, "setSize")
$sizeLarge = GUICtrlCreateMenuitem("Large", $sizeMenu)
GUICtrlSetOnEvent(-1, "setSize")
$levelMenu = GUICtrlCreateMenu("Difficulty: ", $optMenu)
$level1 = GUICtrlCreateMenuitem("Easy", $levelMenu)
GUICtrlSetOnEvent(-1, "")
$level2 = GUICtrlCreateMenuitem("Medium", $levelMenu)
GUICtrlSetOnEvent(-1, "")
$level3 = GUICtrlCreateMenuitem("Hard", $levelMenu)
GUICtrlSetOnEvent(-1, "")
$helpMenu = GUICtrlCreateMenu("&Help")
$menuAbout = GUICtrlCreateMenuitem("About Pong", $helpMenu)
GUISetOnEvent(-1, "")

GUISetOnEvent($GUI_EVENT_CLOSE, "end")
GUISetState()
#Endregion
; -- Main Loop --
While 1
	Sleep(100)
WEnd

Func end ()
	Exit
EndFunc   ;==>end

Func pause ()
	
	
EndFunc   ;==>pause

Func load ()
	
	
EndFunc   ;==>load

Func save ()
	
	
EndFunc   ;==>save

Func updateBallPos ()
	
	
EndFunc   ;==>updateBallPos

Func movePaddles ()
	
	
EndFunc   ;==>movePaddles

Func score ()
	;If $who Then
	;	$playerScore += 1
	;Else
	;	$CPUScore += 1
	;EndIf
	;GUICtrlSetData( $playerScoreLabel, $playerScore )
	;GUICtrlSetData( $CPUScoreLabel, $CPUScore )
EndFunc   ;==>score

Func newGame ()
	$playerScore = 0   ; Reset Scores
	$CPUScore = 0
	;GUICtrlSetData( $playerScoreLabel, $playerScore )
	;GUICtrlSetData( $CPUScoreLabel, $CPUScore )
	
EndFunc   ;==>newGame

Func setDifficulty ()
	
	
EndFunc   ;==>setDifficulty

Func setColor ()
	Select
		Case @GUI_CtrlId = $colorBall
			$BallColor = _ChooseColor(2, $BallColor, 2)
			;GUICtrlSetBkColor( $ball, $BallColor )
		Case @GUI_CtrlId = $colorCPU
			$CPUColor = _ChooseColor(2, $CPUColor, 2)
			GUICtrlSetBkColor($CPU, $CPUColor)
		Case @GUI_CtrlId = $colorPlayer
			$PlayerColor = _ChooseColor(2, $PlayerColor, 2)
			GUICtrlSetBkColor($player, $PlayerColor)
		Case @GUI_CtrlId = $colorBG
			$BGColor = _ChooseColor(2, $BGColor, 2)
			GUISetBkColor($BGColor)
	EndSelect
EndFunc   ;==>setColor

Func setSize ()
	Select
		Case @GUI_CtrlId = $sizeSmall
			WinMove("PONG", "", Default, Default, $SmallSize[0], $SmallSize[1])
			$curSize[0] = $SmallSize[0]
			$curSize[1] = $SmallSize[1]
			GUICtrlSetPos($CPU, $curSize[0] - 15, $curSize[1] / 2 - 25, 7, 50)
		Case @GUI_CtrlId = $sizeMed
			WinMove("PONG", "", Default, Default, $MedSize[0], $MedSize[1])
			$curSize[0] = $MedSize[0]
			$curSize[1] = $MedSize[1]
			GUICtrlSetPos($CPU, $curSize[0] - 15, $curSize[1] / 2 - 25, 7, 50)
		Case @GUI_CtrlId = $sizeLarge
			WinMove("PONG", "", Default, Default, $LargeSize[0], $LargeSize[1])
			$curSize[0] = $LargeSize[0]
			$curSize[1] = $LargeSize[1]
			GUICtrlSetPos($CPU, $curSize[0] - 15, $curSize[1] / 2 - 25, 7, 50)
	EndSelect
EndFunc   ;==>setSize