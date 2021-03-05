#NoTrayIcon
#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=Worm Head.ico
#AutoIt3Wrapper_UseX64=n
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.6.1
 Author:         Garth Bigelow

 Script Function:
	Reflex - an arcade style video game
	See Reflex.rtf for player instructions

Joystick routines modified from a post by Ejoc
http://www.autoitscript.com/forum/topic/10953-joystick-udf/
made compatible with newer versions of Autoit by MKISH
http://www.autoitscript.com/forum/topic/139767-reading-joystick-inputs/page__p__980973__hl__joystick__fromsearch__1#entry980973

#ce ----------------------------------------------------------------------------

Const $ver = "2.05"

#include <Array.au3>
#include <GUIConstantsEx.au3>
#Include <Misc.au3>
#include <Sound.au3>
#include <Timers.au3>
#include <WindowsConstants.au3>

;
If Not FileExists(".\Images\Silo2a.bmp") Then
	MsgBox(16, "Fatal Error", "Version 2.0 Image files not found.")
	Exit
EndIf
SplashTextOn("", @CRLF & "Loading", 100, 90)

If FileExists("Reflex.ini") = 0 Then
	IniWrite("Reflex.ini", "GUI", "Columns", 12)
	IniWrite("Reflex.ini", "GUI", "Rows", "Auto")
	IniWrite("Reflex.ini", "Input", "Device", "Mouse")
	IniWrite("Reflex.ini", "Config", "Speed", 1010)
	IniWrite("Reflex.ini", "Config", "FontName", "Arial")
	IniWrite("Reflex.ini", "Config", "FontSize", 22)
EndIf

; determine row and column width
Global $WidthX = IniRead( "Reflex.ini", "GUI", "Columns", 16 )
Global $WidthY = IniRead( "Reflex.ini", "GUI", "Rows", "Auto" )
Global $Speed  = IniRead( "Reflex.ini", "Config", "Speed", 1010)

If StringUpper($WidthX) = "AUTO" Then
	$WidthX = Int(@DesktopWidth/64)-4
EndIf
If StringUpper($WidthY) = "AUTO" Then
	$WidthY = Int(@DesktopHeight/64)-2
EndIf
; set input device type
Const $Mouse    = 1
Const $Joystick = 2
Const $Keyboard = 3
Switch StringUpper(IniRead( "Reflex.ini", "Input", "Device", "Mouse" ))
	Case "MOUSE"
		$InputDevice = $Mouse
	Case "JOYSTICK"
		$InputDevice = $Joystick
		Global $JOYINFOEX_struct    = "dword[13]"
		$Joy=DllStructCreate($JOYINFOEX_struct)
		If @error Then
			MsgBox(16, "Error","Can not initialize Joystick")
			Exit
		EndIf
		DllStructSetData($Joy, 1, DllStructGetSize($Joy), 1);dwSize = sizeof(struct)
		DllStructSetData($Joy, 1, 255, 2)
	Case "KEYBOARD"
		$InputDevice = $Keyboard
	Case Else
		; default to Mouse
		$InputDevice = $Mouse
EndSwitch
;
; values of the field items
Dim $Field[$WidthX][$WidthY]
; handles to the picture squares
Dim $FieldHandle[$WidthX][$WidthY]
$WidthX -= 1
$WidthY -= 1

Global Const $PacManHead      = 0   ; worm head in pac man mode
Global Const $WormHead        = 1	; current point
Global Const $WormBody        = 2   ; one life lost
Global Const $DecayedWormBody = 3	; no action
Global Const $Flowers         = 4	; no action
Global Const $Death           = 5	; one life lost
Global Const $Elevator        = 6	; one level gained
Global Const $Gift            = 7	; 100 points
Global Const $Devolve         = 8	; all shapes (except voids, worm bodies and fields) go backwards one item value
Global Const $MiniPacMan      = 9	; pacman for two moves
Global Const $PacMan          = 10	; pacman mode (gooble items for 10 points per item value for 4 to 9 rounds) death on void regardless
Global Const $Angel           = 11	; one life gained
Global Const $Devil			  = 12	; 0 to 3 lives lost
Global Const $AtomBomb        = 13	; Reset field
Global Const $Cross           = 14	; all shapes cleared to field in column and row from position
Global Const $BrickWall       = 15	; Deletes all brickwalls
Global Const $PreVoid		  = 16
Global Const $Void            = 17	; death & never gets erased
Global Const $ForceHead       = 18  ; worm head when forcefield is on
; death leaves a void in its space
; SCORING:
; 	movement one point per level
;   leveling up, locks in points into score
;   Gift, Pacman bonuses


; Movements
Global Const $mvDownLeft	= 1
Global Const $mvLeft		= 2
Global Const $mvUpLeft		= 3
Global Const $mvUp			= 4
Global Const $mvUpRight		= 5
Global Const $mvRight		= 6
Global Const $mvDownRight	= 7
Global Const $mvDown		= 8
Global Const $keyForceField	= 9
Global Const $keyPause		= 10

; numbers to an array of sound bites
Global Const $sndCross    = 0
Global Const $sndDeath    = 1
Global Const $sndGunShot  = 2
Global Const $sndPacMan   = 3
Global Const $sndExtraLife= 4
Global Const $sndGift     = 5
Global Const $sndDevolve  = 6
Global Const $sndScissors = 7
Global Const $sndThunk    = 8
Global Const $sndAtomBomb = 9
Global Const $sndSilo     = 10
Global Const $sndWhaWha   = 11
$MaxSound = 11
Dim $Sound[$MaxSound+1]
LoadSounds()

; the field and info displays
$hGUI = GUICreate("Reflex - ver " & $ver, ($WidthX + 3) * 64, ($WidthY + 1) * 64)
GUISetBkColor(0x000000)
; prepare display area
$FontName = IniRead("Reflex.ini", "Config", "FontName", "Arial")
$FontSize = IniRead("Reflex.ini", "Config", "FontSize", 22)

GUISetFont(FontResize($FontSize), 400, 0, $FontName)
GUICtrlSetDefColor(0xFFFFFF)
GUICtrlCreateLabel("", 124,0,127,2048)
GUICtrlSetBkColor(-1, 0xFFFFFF)
GUICtrlCreateLabel("Score", 16, 16, 107, 38)
$dScore = GUICtrlCreateLabel("", 16, 50, 107, 38)
GUICtrlCreateLabel("Points", 16, 101, 107, 38)
$dPoints = GUICtrlCreateLabel("", 16, 135, 107, 38)
GUICtrlCreateLabel("Level", 16, 185, 107, 38)
$dLevel = GUICtrlCreateLabel("", 16, 220, 107, 38)
GUICtrlCreateLabel("Lives", 16, 270, 107, 38)
$dLives = GUICtrlCreateLabel("", 16, 304, 107, 38)
GUICtrlCreateLabel("Force", 16, 355, 107, 38)
$dForce = GUICtrlCreateLabel("", 16, 389, 107, 38)

SplashOff()

; define an array of picture controls and set each cell to a clear field
InitializeField()
GUISetState()
;
$dll = DllOpen("user32.dll")
Opt("GUIOnEventMode",1)
GUISetOnEvent($GUI_EVENT_CLOSE, "OnExit")

; the seasion loop
While True
	Global $PosX  = Rand($WidthX)
	Global $PosY  = Rand($WidthY)
	Global $OpenX = $PosX, $OpenY = $PosY
	Global $DirectionX = 0, $DirectionY = 1
	Global $Level = 0, $Score = 0, $LevelScore = 0, $ClearStrip
	Global $Lives = 3, $ForceField = 0
	Global $ForceFieldMode = False, $spacetoggle = False
	Global $DeadFlag = False
	LoadSounds()
	Opt("GUIOnEventMode",1)
	; prepare closing routine
	; and pause function
	;
	; begin level 1
	DisplayScore()
	UpLevel()
	; the game loop
	While True
		; are we in regular or forcedfield play
		If $ForceFieldMode Then
			ForceFieldMove()
		Else
			StandardMove()
		EndIf
		If $DeadFlag Then ExitLoop
	WEnd
	ResetField()
	If MsgBox(4, "Game Over", "Play again?", 0, $hGUI) = 7 Then ExitLoop
WEnd
GUIDelete($hGUI)
DllClose($dll)
;
;
;
Func OnExit()

	; close the sound handles
	For $loop = 0 to $MaxSound
		_SoundClose($Sound[$loop])
	Next

	$DeadFlag = True
;	Exit

EndFunc

Func StandardMove()

	If $ForceFieldMode Then Return
	; pause between moves
	; but check for direction commands while doing dso
	$StartTime = _Timer_Init()
	While _Timer_Diff($StartTime) < ($Speed - ($Level * 20))
        ReadyMovement()
	WEnd
	If $ForceFieldMode Then Return
	StopAllSounds()
	; movement sound.
	; used beep instead of soundplay to avoid cancelation problems
	Beep(500,63)
	; check for mouse movement selection
	GetMouse()
	GetJoystick()
	; advance a square
	Move()
	; place worm head (visually) at current location
	SetOnField($PosX, $PosY, $WormHead)
	; perform action depending on what object is encountered
	TriggerEvent($Field[$PosX][$PosY])
	; one object per level per move is selected
	; objects are evolved. A random spot is selected. If that spot contains a field it becomes a danger.
	;   A Danger becomes a Gift, etc. Until Void is reached. Voids do not evolve.
	For $loop = 1 to $Level
		Evolve()
	Next

EndFunc

; this is structurally much like StandardMove(). Only Tigger event is removed so there is no effect.
Func ForceFieldMove()

	If Not $ForceFieldMode Then Return
	$StartTime = _Timer_Init()
	While _Timer_Diff($StartTime) < ($Speed - ($Level * 20))
        ReadyMovement()
	WEnd
	If $ForceField <= 0 Then
		$ForceFieldMode = False
		Beep(300, 250)
	EndIf
	If Not $ForceFieldMode Then Return
	; higher pitch beep signifies forcefield mode
	Beep(1500,75)
	; check for mouse movement selection
	GetMouse()
	; advance a square
	Move()
	; if Void encountered, then death.
	If $Field[$PosX][$PosY] = $Void Then
		Flicker()
		Death()
		Return
	EndIf
	SetOnField($PosX, $PosY, $ForceHead)
	DisplayScore()
	$ForceField -= 1
	; No TriggerEvent($Field[$PosX][$PosY])
	; keep on Evoloving
	For $loop = 1 to $Level
		Evolve()
	Next

EndFunc

; create the field picture handles
; and set all objects to empty field (fields were original flowers <g>)
Func InitializeField()

	For $x = 0 To $WidthX
		For $y = 0 To $WidthY
			$Field[$x][$y] = $Flowers
			$FieldHandle[$x][$y] = GUICtrlCreatePic (PictureName($Flowers), ($x + 2) * 64, ($y + 0) * 64, 64, 64)
		Next
	Next

EndFunc

; Clears field to Flowers including Voids
; used for the start of each seasion
Func ResetField()

	For $x = 0 To $WidthX
		For $y = 0 To $WidthY
			$Field[$x][$y] = $Flowers
		Next
	Next

EndFunc

; clear the current field
; Also used by Devolve function to lower each object on the field by 1
Func DrawField($Flag)

    ; display that worm head (you)
	If $Flag <> 0 Then 	SetOnField($PosX, $PosY, $WormHead)
	For $x = 0 To $WidthX
		For $y = 0 To $WidthY
			; voids are eternal
			If $Field[$x][$y] < $Void Then
				Switch $Flag
					Case 1 ; Devolver
						; knock objects down one step
						If $Field[$x][$y] > $Flowers Then
							$Field[$x][$y] -= 1
						EndIf
					Case 2 ; Atomic Bomb
						Switch $Field[$x][$y]
							Case $WormBody To $DecayedWormBody
								$Field[$x][$y] = $DecayedWormBody
							Case Else
								$Field[$x][$y] = $Flowers
						EndSwitch
					Case 3 ; Brick Wall
						If $Field[$x][$y] = $BrickWall Then
							$Field[$x][$y] = $Death
						EndIf
					Case Else
						; new level
						; set field to flowers
						$Field[$x][$y] = $Flowers
				EndSwitch
			EndIf
			; Don't draw is current space (to preserve worm head which is not a field object
			If $x <> $PosX Or $y <> $PosY Then	GUICtrlSetImage ( $FieldHandle[$x][$y], PictureName($Field[$x][$y]))
		Next
	Next

EndFunc

; draw object item at field coordinate $x, $y
Func SetOnField($x, $y, $item)

	GUICtrlSetImage($FieldHandle[$x][$y], PictureName($item))

EndFunc

; Silo doors animated gif simulation
Func SiloEmpty()

	GUICtrlSetImage($FieldHandle[$PosX][$PosY], ".\Images\06 Elevator.bmp")
	Sleep(300)
	GUICtrlSetImage($FieldHandle[$PosX][$PosY], ".\Images\Silo2a.bmp")
	Sleep(500)
	GUICtrlSetImage($FieldHandle[$PosX][$PosY], ".\Images\Silo3a.bmp")
	Sleep(500)
	GUICtrlSetImage($FieldHandle[$PosX][$PosY], ".\Images\Silo4a.bmp")
	Sleep(500)
	GUICtrlSetImage($FieldHandle[$PosX][$PosY], ".\Images\Silo5a.bmp")
	Sleep(250)
	StopAllSounds()
	Sleep(250)

EndFunc

Func SiloFull()

	GUICtrlSetImage($FieldHandle[$PosX][$PosY], ".\Images\06 Elevator.bmp")
	Sleep(300)
	GUICtrlSetImage($FieldHandle[$PosX][$PosY], ".\Images\Silo2b.bmp")
	Sleep(500)
	GUICtrlSetImage($FieldHandle[$PosX][$PosY], ".\Images\Silo3b.bmp")
	Sleep(500)
	GUICtrlSetImage($FieldHandle[$PosX][$PosY], ".\Images\Silo4b.bmp")
	Sleep(500)
	GUICtrlSetImage($FieldHandle[$PosX][$PosY], ".\Images\Silo5b.bmp")
	Sleep(250)
	GUICtrlSetImage($FieldHandle[$PosX][$PosY], ".\Images\Silo6b.bmp")
	StopAllSounds()
	Sleep(150)

EndFunc

; move, you crazy worm
Func Move()

	; if not a void leave a worm body seqment behind
	If $Field[$PosX][$PosY] < $Void Then
		$Field[$PosX][$PosY] = $WormBody
		If $PosX = $OpenX And $PosY = $OpenY Then
			; opening spot retains silo door
			GUICtrlSetImage($FieldHandle[$PosX][$PosY], ".\Images\SiloOpen.bmp")
		Else
			; pod
			SetOnField($PosX, $PosY, $WormBody)
		EndIf
	EndIf
	; move one square in the desired direction
	$PosX += $DirectionX
	$PosY += $DirectionY
	; wrap if movement is off the screen
	If $PosX < 0 Then $PosX = $WidthX
	If $PosX > $WidthX Then $PosX = 0
	If $PosY < 0 Then $PosY = $WidthY
	If $PosY > $WidthY Then $PosY = 0
	; display the proper worm head
	If $ForceFieldMode Then
		SetOnField($PosX, $PosY, $WormHead)
	Else
		SetOnField($PosX, $PosY, $ForceHead)
	EndIf
	; score is one point per level per move
	$LevelScore += $Level
	DisplayScore()

EndFunc

; add 1 to a random object on the field
Func Evolve()

	; pick a random spot
	;  but not on the barren area (your initial position vertically.
	;    this position is kept free of objects through level twenty
	Do
		$x = Rand($WidthX)
	Until $x <> $ClearStrip
	$y = Rand($WidthY)
	; do not drop an object directly on the worm head
	If $x = $PosX And $y = $PosY Then Return
	; or the entrance to level
	If $x = $OpenX And $y = $OpenY Then Return
	; evolve this spot (if not a Void)
	If $Field[$x][$y] < $Void Then $Field[$x][$y] += 1
	; display new shape
	SetOnField($x, $y, $Field[$x][$y])

EndFunc

; flash wormhead and field object
;   gives player a chance to see what happened
Func Flicker()

	For $loop = 1 to 60
		SetOnField($PosX, $PosY, $WormHead)
		Sleep(5)
		SetOnField($PosX, $PosY, $Field[$PosX][$PosY])
		Sleep(5)
		; also check for directional keystroke
		;  intended direction can be changed up to the last second
		ReadyMovement()
	Next

EndFunc

Func GetMouse()

	If $InputDevice <> $Mouse Then Return

	; check for left mouse down and set force field accordingly
	$ForceFieldMode = _IsPressed("1", $dll)
	AutoItSetOption("MouseCoordMode", 2)
	; get position of mouse
	$MouseX = MouseGetPos(0)
	$MouseY = MouseGetPos(1)
	; translate to number of squares from mouse
	$SquareX = Int($MouseX/64)-2
	$SquareY = Int($MouseY/64)
		; translate -0.x to -1.x
	If $MouseY < 0.0 Then $SquareY -= 1.0
	; translate to direction from worm head
	$DiffX = $SquareX - $PosX
	$DiffY = $SquareY - $PosY
	; if not near the worm head ignore
	If Abs($DiffX) > 1 Then Return
	If Abs($DiffY) > 1 Then Return
	; if on the worm head ignore
	If $DiffX = 0 And $DiffY = 0 Then Return
	; set direction change if made it this far
	$DirectionX = $DiffX
	$DirectionY = $DiffY

EndFunc

Func GetJoystick()

	If $InputDevice <> $Joystick Then Return
	Switch ReadJoy(0)  ; X movement
		Case 0 To 9999
			$DiffX = -1
		Case 10000 To 55999
			$DiffX = 0
		Case 56000 To 65535
			$DiffX = 1
	EndSwitch
	Switch ReadJoy(1) ; Y movement
		Case 0 To 9999
			$DiffY = -1
		Case 10000 To 55999
			$DiffY = 0
		Case 56000 To 65535
			$DiffY = 1
	EndSwitch
	If $DiffX = 0 And $DiffY = 0 Then Return
	$DirectionX = $DiffX
	$DirectionY = $DiffY

EndFunc

Func ReadJoy($function)

    Dim $coor[8]
    DllCall("Winmm.dll","int","joyGetPosEx", "int", 0, "ptr", DllStructGetPtr($Joy))
	If Not @error Then
        $coor[0]    = DllStructGetData($Joy,1,3)
        $coor[1]    = DllStructGetData($Joy,1,4)
        $coor[2]    = DllStructGetData($Joy,1,5)
        $coor[3]    = DllStructGetData($Joy,1,6)
        $coor[4]    = DllStructGetData($Joy,1,7)
        $coor[5]    = DllStructGetData($Joy,1,8)
        $coor[6]    = DllStructGetData($Joy,1,11)
        $coor[7]    = DllStructGetData($Joy,1,9)
    EndIf
    ; coor[0] = X
	; coor[1] = y
	; coor[7] = primary button, 1 = pressed
	Return $coor[$function]

EndFunc

; prepare directional movement (forcefield selection too)
Func ReadyMovement()

	; Pause
	If _IsPressed("50") Then PauseGame()

	; forcefield activated by Spacebar, left mouse button or primary joystick button
	Switch $InputDevice
		Case $Mouse
			$ForceFieldMode = _IsPressed("1", $dll) ; mouse left click
		Case $Joystick
			$ForceFieldMode = ReadJoy(7)  ; joystick primary button
		Case $Keyboard
			GetKeyboard()
	EndSwitch
	If $ForceField <= 0 Then $ForceFieldMode = False

EndFunc

; up/down sideways are turned into their directional grid changes
Func GetKeyboard()

	Switch GetKeys()
		Case $mvDownLeft
			$DirectionX = -1
			$DirectionY = 1
		Case $mvDown
			$DirectionX = 0
			$DirectionY = 1
		Case $mvDownRight
			$DirectionX = 1
			$DirectionY = 1
		Case $mvLeft
			$DirectionX = -1
			$DirectionY = 0
		Case $mvUpLeft
			$DirectionX = -1
			$DirectionY = -1
		Case $mvUp
			$DirectionX = 0
			$DirectionY = -1
		Case $mvUpRight
			$DirectionX = 1
			$DirectionY = -1
		Case $mvRight
			$DirectionX = 1
			$DirectionY = 0
		Case $keyForceField
			; spacebar toggles forcefield mode
			; but don't test again until spacebar has been released
			If Not $spacetoggle Then
			   $ForceFieldMode = Not $ForceFieldMode
			   $spacetoggle = True
			EndIf
		Case Else
			$spacetoggle = False
	EndSwitch

EndFunc

;Return $Direction
; turn specific keys into directional constants
Func GetKeys()

	If _IsPressed("61", $dll) Then Return $mvDownLeft
	If _IsPressed("62", $dll) Then Return $mvDown
	If _IsPressed("28", $dll) Then Return $mvDown
	If _IsPressed("63", $dll) Then Return $mvDownRight
	If _IsPressed("64", $dll) Then Return $mvLeft
	If _IsPressed("25", $dll) Then Return $mvLeft
	If _IsPressed("66", $dll) Then Return $mvRight
	If _IsPressed("27", $dll) Then Return $mvRight
	If _IsPressed("67", $dll) Then Return $mvUpLeft
	If _IsPressed("68", $dll) Then Return $mvUp
	If _IsPressed("26", $dll) Then Return $mvUp
	If _IsPressed("69", $dll) Then Return $mvUpRight
	If _IsPressed("20", $dll) Then Return $keyForceField
	Return 0

EndFunc

; display score, current level, number of lives and forcefield charges on one line
;  	current points accrued on another
Func DisplayScore()

	GUICtrlSetData($dScore, $Score)
	GUICtrlSetData($dPoints, $LevelScore)
	GUICtrlSetData($dLevel, $Level)
	GUICtrlSetData($dLives, $Lives)
	GUICtrlSetData($dForce, $ForceField)

EndFunc

Func StopAllSounds()

	For $loop = 0 to $MaxSound
		_SoundStop($Sound[$loop])
	Next

EndFunc

;
;
; the object you collide with triggers certain responses
Func TriggerEvent($item)

	Switch $item
		Case $WormBody
			Death()
		Case $Death
			Death()
		Case $Elevator
			; wormhead
;			GUICtrlSetImage($FieldHandle[$PosX][$PosY], ".\Images\06 Elevator.bmp")
			StopAllSounds()
			_SoundPlay($Sound[$sndSilo])
			SiloEmpty()
			UpLevel()
			$OpenX = $PosX
			$OpenY = $PosY
		Case $Gift
			_SoundPlay($Sound[$sndGift])
			Flicker()
			$LevelScore += 100
		Case $MiniPacMan
			PacManMode(3)
		Case $PacMan
			$Count = 5 + Rand(4)
			PacManMode($Count)
		Case $Devolve
			Devolve()
		Case $Angel
			If $Lives < 9 Then
				_SoundPlay($Sound[$sndExtraLife])
			Else
				_SoundPlay($Sound[$sndWhaWha])
			EndIf
			Flicker()
			If $Lives < 9 Then $Lives += 1
		Case $Devil
			; 0 to 3 lives lost
			For $loop = 1 to Rand(3)
				Death()
			Next
		Case $AtomBomb
			AtomBomb()
		Case $Cross
			Cross()
		Case $BrickWall
			_SoundPlay($Sound[$sndThunk])
			Flicker()
			Drawfield(3) ;wipe out all brickwalls
			; Add two forcefields
			; still topping out at 8 charges
			If $ForceField < 7 Then $ForceField += 1
			If $ForceField < 8 Then $ForceField += 1
		Case $PreVoid
			Flicker()
		Case $Void
			Death()
	EndSwitch

EndFunc

; Hitting a WormBody, Warning (PigMan) or Devil
; 	or hitting a void in any mode
; 	causes loss of one life
;   and leaves a void
Func Death()

	_SoundPlay($Sound[$sndDeath])
	Flicker()
	$Lives -= 1
	DisplayScore() ; just so lives say 0 if you croak.
	$LevelScore = 0 ; after display score so you can see how much 'you got cheated out of.'
	; check for no lives left and display game over and highscore if there are.
	If $Lives < 1 Then
;		SetOnField($PosX, $PosY, $WormHead)
		; uncommenting line above shows where death occurred but not by what
		; as is it shows what you hit but not where
		; neither is an ideal solution
		HighScore()
		; end the game
		OnExit()
	EndIf
	; turn the death spot into a void.
	$Field[$PosX][$PosY] = $Void
	SetOnField($PosX, $PosY, $Field[$PosX][$PosY])

EndFunc

; Elevator
Func UpLevel()

	; lock points into score
	$Score += $LevelScore
	$LevelScore = 0
	DisplayScore()
	; raise to next level
	$Level += 1
	; increment the force field charge
	If $ForceField < 8 Then $ForceField += 1
	; determine the new clear strip (barren area)
	; no objects fall on the clear strip
	; before level 20 the clear strip is the column of the elevator
	; level 20 and above the clear strip column is randomly determined
	If $Level < 20 Then
		$ClearStrip = $PosX
	Else
		$ClearStrip = Rand($WidthX)
	EndIf
	; initialize the new level to be clear of all objects except voids
	DrawField(0)
	DisplayScore()
	GUICtrlSetImage ( $FieldHandle[$PosX][$PosY], ".\Images\06 Elevator.bmp")
	Sleep(100)
	StopAllSounds()
	_SoundPlay($Sound[$sndSilo])
	SiloFull()
;	GUICtrlSetImage ( $FieldHandle[$PosX][$PosY], ".\Images\Silo7.bmp")

EndFunc

; Hitting a Devolver
Func Devolve()

	; 300 points for hitting the devolver
	$LevelScore += 300
	DisplayScore()
	_SoundPlay($Sound[$sndDevolve])
	Flicker()
	; make every object on the field one degree lower
	; PacMen become Devolvers, Elevators become Dangers, etc.
	DrawField(1)

EndFunc

; Hitting a PacMan
Func PacManMode($Count)

	_SoundPlay($Sound[$sndScissors])
	; flicker with Pac Man Mode Head
	For $loop = 1 to 60
		SetOnField($PosX, $PosY, $WormHead)
		Sleep(5)
		SetOnField($PosX, $PosY, $PacManHead)
		Sleep(5)
		ReadyMovement()
	Next
	; gobble for 5 to 9 squares
	For $loop = 1 to $Count
		_SoundPlay($Sound[$sndPacMan])
		Local $StartTime = _Timer_Init()
		While _Timer_Diff($StartTime) < ($Speed - ($Level * 20))
			ReadyMovement()
		WEnd
		; high beep in Pac Man Mode
		Beep(1000, 75)
		GetMouse()
		Move()
		SetOnField($PosX, $PosY, $PacManHead)
		; Voids still kill
		If $Field[$PosX][$PosY] = $Void Then
			Death()
			Return
		Endif
		; earn points equal to object gobbled
		; 10 for a Danger
		; 20 for an Elevator
		; 50 for a Pac Mac, etc.
		; Move() still generates standard movement score as well
		Local $point = $Field[$PosX][$PosY] - $Flowers
		If $point < 0 then $point = 0
		$LevelScore += ($point * 10)
		DisplayScore()
		_SoundStop($Sound[$sndPacMan])
	Next
	; Give a short pause and visual to signify that Pac Man Mode is over
	$Field[$PosX][$PosY] = $WormBody
	Flicker()

EndFunc

; wipe out all but the voids
Func AtomBomb()

	Flicker()
	_SoundPlay($Sound[$sndAtomBomb])
	; Clear the field
	DrawField(2)
	$ForceField = 0

EndFunc

; Hitting a Cross
; the only thing that can remove a void
Func Cross()

	_SoundPlay($Sound[$sndCross])
	Local $change, $distance = 0, $temp
	$Field[$PosX][$PosY] = $Flowers
	; rows and column of the current position are cleared
	; I like the visual effect, using worm bodies like bowling balls
	Do
		$change = False
		$distance += 1
		$temp = $PosX - $distance
		If $temp >= 0 Then
			$Field[$temp][$PosY] = $Flowers
			SetOnField($temp, $PosY, $WormBody)
			$change = True
		Endif
		$temp = $PosY - $distance
		If $temp >= 0 Then
			$Field[$PosX][$temp] = $Flowers
			SetOnField($PosX, $temp, $WormBody)
			$change = True
		Endif
		$temp = $PosX + $distance
		If $temp <= $WidthX Then
			$Field[$temp][$PosY] = $Flowers
			SetOnField($temp, $PosY, $WormBody)
			$change = True
		Endif
		$temp = $PosY + $distance
		If $temp <= $WidthY Then
			$Field[$PosX][$temp] = $Flowers
			SetOnField($PosX, $temp, $WormBody)
			$change = True
		Endif
		Local $StartTime = _Timer_Init()
		While _Timer_Diff($StartTime) < 200
			ReadyMovement()
		WEnd
		$temp = $PosX - $distance
		If $temp >= 0 Then
			SetOnField($temp, $PosY, $Flowers)
		Endif
		$temp = $PosY - $distance
		If $temp >= 0 Then
			SetOnField($PosX, $temp, $Flowers)
		Endif
		$temp = $PosX + $distance
		If $temp <= $WidthX Then
			SetOnField($temp, $PosY, $Flowers)
		Endif
		$temp = $PosY + $distance
		If $temp <= $WidthY Then
			SetOnField($PosX, $temp, $Flowers)
		Endif
	Until Not $change
	_SoundStop($Sound[$sndCross])

EndFunc

;
; building an array for pointers to the sound effects
Func LoadSounds()

	SoundtoArray("Death.mp3", $sndDeath)
	SoundtoArray("Pacman.wav", $sndPacMan)
	SoundtoArray("ExtraLife.wav", $sndExtraLife)
	SoundtoArray("Gift.mp3", $sndGift)
	SoundtoArray("Devolve.mp3", $sndDevolve)
	SoundtoArray("PacManBegins.mp3", $sndScissors)
	SoundtoArray("Cross.wav", $sndCross)
	SoundtoArray("Brickwall.mp3", $sndThunk)
	SoundtoArray("AtomBomb.mp3", $sndAtomBomb)
	SoundtoArray("Silo.mp3", $sndSilo)
	SoundtoArray("GunShot.mp3", $sndGunShot)
	SoundtoArray("WhaWha.mp3", $sndWhaWha)

EndFunc

; create a handle to sound effect $file
Func SoundtoArray($file, $SoundNumber)

	$Sound[$SoundNumber] = _SoundOpen(".\Sounds\" & $file)
	If @error = 2 Then
		MsgBox(16, "Initialization Error", $file & " not found.")
		Exit
	EndIf

EndFunc

; return the file name for a given shape
Func PictureName($item)

	Switch $item
		Case $PacManHead
			$FileName = ".\Images\PacManModeHead.bmp"
		Case $WormHead
			$FileName = ".\Images\01 Worm Head.bmp"
		Case $WormBody
			$FileName = ".\Images\02 Worm Body.bmp"
		Case $DecayedWormBody
			$FileName = ".\Images\03 Decayed Worm Body.bmp"
		Case $Flowers
			$FileName = ".\Images\04 Flowers.bmp"
		Case $Death
			$FileName = ".\Images\05 pigman.bmp"
		Case $Elevator
			$FileName = ".\Images\06 Elevator.bmp"
		Case $Gift
			$FileName = ".\Images\07 Gift.bmp"
		Case $Devolve
			$FileName = ".\Images\09 Devolve.bmp"
		Case $MiniPacMan
			$FileName = ".\Images\MiniPacMan.bmp"
		Case $PacMan
			$FileName = ".\Images\08 PacMan.bmp"
		Case $Angel
			$FileName = ".\Images\10 Angel.bmp"
		Case $Devil
			$FileName = ".\Images\11 Devil.bmp"
		Case $AtomBomb
			$FileName = ".\Images\12 Atom.bmp"
		Case $Cross
			$FileName = ".\Images\13 Cross.bmp"
		Case $BrickWall
			$FileName = ".\Images\14 BrickWall.bmp"
		Case $PreVoid
			$FileName = ".\Images\PreVoid.bmp"
		Case $Void
			$FileName = ".\Images\15 Void.bmp"
		Case $ForceHead
			$FileName = ".\Images\Forcefield.bmp"
		Case Else
			$FileName = False
	EndSwitch
	Return $FileName

EndFunc

;
; bend random() function to my needs
;
Func Rand($pMax)

	Return Random(0, $pMax, 1)

EndFunc

;
; Display Top Twenty High Scores
;
Func HighScore()

	$FileName = "Reflex.T20"

	SetOnField($PosX, $PosY, $WormHead)
	_SoundPlay($Sound[$sndGunShot])
	Sleep(500)
	GUICtrlSetImage ( $FieldHandle[$PosX][$PosY], ".\Images\DeadHead.bmp")
	Opt("GUIOnEventMode",0)

	; if no high score file, create it
	If Not FileExists($FileName) Then
		$file = FileOpen($FileName, 2)
		If $file = -1 Then
			MsgBox(16, "Fatal Error", "Can not create high score file")
			Exit
		EndIf
		$temp = ".... 1 1"
		For $loop = 1 to 20
			FileWriteLine($file, $temp)
		Next
		FileClose($file)
	EndIf
	; Load Score Array from file
	$file = FileOpen($FileName, 0) ; read only
	Const $Names  = 0
	Const $Scores = 1
	Const $Levels = 2
	Dim $ArrayOfScores[3][21]
	For $loop = 1 to 20
		$linescore = FileReadLine($file)
		$Values = StringSplit($linescore, " ", 2)
		$ArrayOfScores[$Names][$loop]  = $Values[$Names]
		$ArrayOfScores[$Scores][$loop] = int($Values[$Scores])
		$ArrayOfScores[$Levels][$loop] = $Values[$Levels]
	Next
	FileClose($file)
	; Test if new score must be added to scoreboard
	If $Score > $ArrayOfScores[$Scores][20] Then
		$temp = ValidInit()
		If StringIsSpace($temp) Then $temp = "----"
		$ArrayOfScores[$Names][0]  = StringUpper($temp)
	Else
		$ArrayOfScores[$Names][0]  = ""
	EndIf
	$ArrayOfScores[$Scores][0] = int($Score)
	$ArrayOfScores[$Levels][0] = int($Level)
	Sort($ArrayOfScores)
	; write high score file
	$file = FileOpen($FileName, 2) ; write fresh
	If $file = -1 Then
		MsgBox(16, "Fatal Error", "Can not update high score file")
		Exit
	EndIf
	For $loop = 0 to 19
		$temp = StringLeft($ArrayOfScores[$Names][$loop],4) & " " & $ArrayOfScores[$Scores][$loop] & " " & $ArrayOfScores[$Levels][$loop]
		FileWriteLine($file, $temp)
	Next
	FileClose($file)

    ; Display Scores
	$Form1 = GUICreate("Form1", 710, 384, 192, 124, -1, -1, $hGUI)
	GUISetFont(FontResize(18), 800, 0, "Courier New")
	GUICtrlCreateLabel("Init.", 64, 16, 76, 36)
	GUICtrlCreateLabel(" Score", 144, 16, 87, 36)
	GUICtrlCreateLabel("Level", 248, 16, 80, 36)
	GUICtrlCreateLabel("Init.", 432, 16, 76, 36)
	GUICtrlCreateLabel(" Score", 512, 16, 87, 36)
	GUICtrlCreateLabel("Level", 616, 16, 80, 36)

	For $rank = 1 To 20
		$x = 0
		$y = $rank
		If $rank > 10 Then
			$x = 384-16
			$y = $rank - 10
		Endif
		$y = 32 * $y + 16

		$data1 = StringFormat("%2d", $rank)
		$data2 = $ArrayOfScores[$Names][$rank-1]
		$data3 = StringFormat("%6d", $ArrayOfScores[$Scores][$rank-1])
		$data4 = StringFormat("%5d", $ArrayOfScores[$Levels][$rank-1])
		$BkColor = 0xFFFF00
		If Int($rank/2) = ($rank/2) Then $BkColor = 0xEDDE11
		$Label0 = GUICtrlCreateLabel("", $x + 16, $y, 248, 36)
		GUICtrlSetBkColor($label0, $BkColor)
		$Label1 = GUICtrlCreateLabel($data1 & ".", $x + 16, $y, 43, 36)
		GUICtrlSetBkColor($label1, $BkColor)
		$Label2 = GUICtrlCreateLabel($data2, $x + 64, $y, 72, 36)
		GUICtrlSetBkColor($label2, $BkColor)
		$Label3 = GUICtrlCreateLabel($data3, $x + 144, $y, 94, 36)
		GUICtrlSetBkColor($label3, $BkColor)
		$Label4 = GUICtrlCreateLabel($data4, $x + 248, $y, 72, 36)
		GUICtrlSetBkColor($label4, $BkColor)
	Next

	GUISetState()

	; wait until window is closed
	Do
		$msg = GUIGetMsg()
		Sleep(20)
	Until $msg = $GUI_EVENT_CLOSE
	GUIDelete($form1)
	OnExit()

EndFunc   ;==>DisplayStatHistory

Func ValidInit()

	While True
		$temp = InputBox("New Score for Scoreboard", "Enter Your Initials: ", "", "", -1, 120)
		If $temp = "" Then Return "...."
		$temp = StringLeft($temp, 4)
		If StringInStr($temp, " ") = 0 Then Return $temp
		Msgbox(48, "Initials", "Initials may not contain a space")
	WEnd

EndFunc


; just felt like doing it myself
Func Sort( byref $ArrayOfScores)

	Const $Names  = 0
	Const $Scores = 1
	Const $Levels = 2
	For $a = 0 to 19
		for $b = $a + 1 to 1 step -1
			if $ArrayOfScores[$Scores][$b] > $ArrayOfScores[$Scores][$b-1] Then
				SwapVar($ArrayOfScores[$Scores][$b-1], $ArrayOfScores[$Scores][$b])
				SwapVar($ArrayOfScores[$Names][$b-1],  $ArrayOfScores[$Names][$b])
				SwapVar($ArrayOfScores[$Levels][$b-1], $ArrayOfScores[$Levels][$b])
			EndIf
		Next
	Next

EndFunc

Func SwapVar(byref $a, byref $b)

	Local $temp
	$temp = $b
	$b = $a
	$a = $temp

EndFunc

;pause
Func PauseGame()

	$LevelScore = 0
	DisplayScore()
	$hPause = GUICreate("Pause", 228, 134, -1, -1, $WS_BORDER, -1, $hGUI)
	GUICtrlCreateLabel("Game Paused", 32, 24, 158, 37)
	GUICtrlSetFont(-1, FontResize(22), 400, 0, "Times New Roman")
	$hButton = GUICtrlCreateButton("Resume", 128, 72, 75, 25)
	GUICtrlSetFont(-1, FontResize(8), 800, 0, "MS Sans Serif")
	GUISetState(@SW_SHOW)

	Opt("GUIOnEventMode",0)
	While True
		$nMsg = GUIGetMsg()
		Switch $nMsg
			Case $hButton
				ExitLoop
			Case $GUI_EVENT_CLOSE
				ExitLoop
		EndSwitch
		Sleep(20)
	WEnd
	GUIDelete($hPause)
	Opt("GUIOnEventMode",1)
EndFunc

Func FontResize($Size)

	Switch RegRead("HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\ThemeManager", "LastLoadedDPI")
		Case 119 To 126
			Return Int($Size / 125 * 100)
		Case 145 To 155
			Return Int($Size / 2)
		Case Else
			Return $Size
	EndSwitch

EndFunc


