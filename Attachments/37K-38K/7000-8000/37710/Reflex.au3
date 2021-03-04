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

#ce ----------------------------------------------------------------------------

; This was my first script written without help from the forums. Eternally grateful just the same.


Const $ver = "1.05"

DirCreate ( ".\Images" )
DirCreate ( ".\Sounds" )

FileInstall(".\Images\01 Worm Head.bmp", ".\Images\", 0)
FileInstall(".\Images\02 Worm Body.bmp", ".\Images\", 0)
FileInstall(".\Images\03 Decayed Worm Body.bmp", ".\Images\", 0)
FileInstall(".\Images\04 Flowers.bmp", ".\Images\", 0)
FileInstall(".\Images\05 pigman.bmp", ".\Images\", 0)
FileInstall(".\Images\06 Elevator.bmp", ".\Images\", 0)
FileInstall(".\Images\07 Gift.bmp", ".\Images\", 0)
FileInstall(".\Images\08 PacMan.bmp", ".\Images\", 0)
FileInstall(".\Images\09 Devolve.bmp", ".\Images\", 0)
FileInstall(".\Images\10 Angel.bmp", ".\Images\", 0)
FileInstall(".\Images\11 Devil.bmp", ".\Images\", 0)
FileInstall(".\Images\12 Atom.bmp", ".\Images\", 0)
FileInstall(".\Images\13 Cross.bmp", ".\Images\", 0)
FileInstall(".\Images\14 BrickWall.bmp", ".\Images\", 0)
FileInstall(".\Images\15 Void.bmp", ".\Images\", 0)
FileInstall(".\Images\PacManModeHead.bmp", ".\Images\", 0)
FileInstall(".\Images\Forcefield.bmp", ".\Images\", 0)

FileInstall(".\Sounds\Brickwall.mp3", ".\Sounds\", 0)
FileInstall(".\Sounds\Cross.mp3", ".\Sounds\", 0)
FileInstall(".\Sounds\Death.mp3", ".\Sounds\", 0)
FileInstall(".\Sounds\Devolve.mp3", ".\Sounds\", 0)
FileInstall(".\Sounds\ExtraLife.wav", ".\Sounds\", 0)
FileInstall(".\Sounds\Gift.mp3", ".\Sounds\", 0)
FileInstall(".\Sounds\Pacman.wav", ".\Sounds\", 0)
FileInstall(".\Sounds\PacManBegins.mp3", ".\Sounds\", 0)
FileInstall(".\Sounds\Transporter.mp3", ".\Sounds\", 0)

#include <Array.au3>
#include <GUIConstantsEx.au3>
#Include <Misc.au3>
#include <Sound.au3>
#include <Timers.au3>
#include <WindowsConstants.au3>

If FileExists("Reflex.ini") = 0 Then
	IniWrite("Reflex.ini", "GUI", "Columns", 16)
	IniWrite("Reflex.ini", "GUI", "Rows", "Auto")
	IniWrite("Reflex.ini", "Input", "Device", "Mouse")
	IniWrite("Reflex.ini", "Config", "Speed", 1010)
EndIf

; determine row and column width
Global $WidthX = IniRead( "Reflex.ini", "GUI", "Columns", 16 )
Global $WidthY = IniRead( "Reflex.ini", "GUI", "Rows", "Auto" )
Global $Speed  = IniRead( "Reflex.ini", "Config", "Speed", 1010)

If StringUpper($WidthX) = "AUTO" Then
	$WidthX = Int(@DesktopWidth/64)-1
EndIf
If StringUpper($WidthY) = "AUTO" Then
	$WidthY = Int(@DesktopHeight/64)-3
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
Global Const $PacMan          = 9	; pacman mode (gooble items for 10 points per item value for 4 to 9 rounds) death on void regardless
Global Const $Angel           = 10	; one life gained
Global Const $Devil			  = 11	; 0 to 3 lives lost
Global Const $ExpressElevator = 12	; 4 levels gained
Global Const $Cross           = 13	; all shapes cleared to field in column and row from position
Global Const $BrickWall       = 14	;
Global Const $Void            = 15	; death & never gets erased
Global Const $ForceHead       = 16  ; worm head when forcefield is on
Global Const $SemiForceHead   = 17  ; building to forcefield
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

Global $PosX  = Rand($WidthX)
Global $PosY  = Rand($WidthY)
Global $DirectionX = 0, $DirectionY = 1
Global $Level = 0, $Score = 0, $LevelScore = 0, $ClearStrip
Global $Lives = 3, $ForceField = -1
Global $ForceFieldMode = False, $spacetoggle = False

; numbers to an array of sound bites
Global Const $sndCross    = 0
Global Const $sndDeath    = 1
Global Const $sndElevator = 2
Global Const $sndPacMan   = 3
Global Const $sndExtraLife= 4
Global Const $sndGift     = 5
Global Const $sndDevolve  = 6
Global Const $sndScissors = 7
Global Const $sndThunk    = 8
Dim $Sound[10]
LoadSounds()

; the field and info displays
$hGUI = GUICreate("Reflex - ver " & $ver, ($WidthX + 1) * 64, ($WidthY + 2) * 64)
GUISetFont(22, 800, 0, "Courier New")
$hDisplay  = GUICtrlCreateLabel("" , 10, 3,  1000, 28)
$hDisplay2 = GUICtrlCreateLabel("" , 10, 31, 500, 28)
$testlabel = GUIctrlcreatelabel("", 510, 31, 1000, 28)

$HighScore = IniRead("Reflex.ini","Score","Top", 0)

GUISetState()
; define an array of picture controls and set each cell to a clear field
InitializeField()
;
; begin level 1
UpLevel()

Opt("GUIOnEventMode",1)
$dll = DllOpen("user32.dll")
GUISetOnEvent($GUI_EVENT_CLOSE, "OnExit")
; the main loop
While True
	; are we in regular or forcedfield play
	If $ForceFieldMode Then
		ForceFieldMove()
	Else
		StandardMove()
	EndIf
WEnd

;
;
;
Func OnExit()

	; close the sound handles
	For $loop = 0 to 8
		_SoundClose($Sound[$loop])
	Next
	;
	DllClose($dll)
	GUIDelete($hGUI)
	Exit

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
; do you know why it takes a round for the force field to charge? Neither do I.
Func ForceFieldMove()

	If Not $ForceFieldMode Then Return
	$StartTime = _Timer_Init()
	While _Timer_Diff($StartTime) < ($Speed - ($Level * 20))
        ReadyMovement()
	WEnd
	If Not $ForceFieldMode Then Return
	If $ForceField <= 0 Then
		$ForceFieldMode = False
		Return
	EndIf
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
			$FieldHandle[$x][$y] = GUICtrlCreatePic (PictureName($Flowers), $x * 64, ($y + 1) * 64, 64, 64)
		Next
	Next

EndFunc

; clear the current field
; Also used by Devolve function to lower each object on the field by 1
Func DrawField($DevolveFlag)

    ; display that worm head (you)
	SetOnField($PosX, $PosY, $WormHead)

	For $x = 0 To $WidthX
		For $y = 0 To $WidthY
			; voids are eternal
			If $Field[$x][$y] < $Void Then
				If $DevolveFlag Then
					; knock objects down one step
					If $Field[$x][$y] > $Flowers Then
						$Field[$x][$y] -= 1
					EndIf
				Else
					; set field to flowers
					$Field[$x][$y] = $Flowers
				EndIf
			EndIf
			; Don't draw is current space (to preserve worm head which is not a field object
			If $x <> $PosX Or $y <> $PosY Then	GUICtrlSetImage ( $FieldHandle[$x][$y], PictureName($Field[$x][$y]))
		Next
	Next

EndFunc

; draw and object at field coordinate $x, $y
Func SetOnField($x, $y, $item)

	GUICtrlSetImage ( $FieldHandle[$x][$y], PictureName($item))

EndFunc

; move, you crazy worm
Func Move()

	; if not a void leave a worm body seqment behind
	If $Field[$PosX][$PosY] < $Void Then
		$Field[$PosX][$PosY] = $WormBody
		SetOnField($PosX, $PosY, $WormBody)
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

	$ForceFieldMode = _IsPressed("1", $dll)
	AutoItSetOption("MouseCoordMode", 2)
	$MouseX = MouseGetPos(0)
	$MouseY = MouseGetPos(1)
	$SquareX = Int($MouseX/64)
	$SquareY = Int($MouseY/64)-1
	$DiffX = $SquareX - $PosX
	$DiffY = $SquareY - $PosY
	If Abs($DiffX) > 1 Then Return
	If Abs($DiffY) > 1 Then Return
	If $DiffX = 0 And $DiffY = 0 Then Return
	$DirectionX = $DiffX
	$DirectionY = $DiffY

EndFunc

; prepare directional movement (forcefield selection too)
Func ReadyMovement()

	Switch $InputDevice
		Case $Mouse
			If $ForceField > 0 And $ForceFieldMode Then
				SetOnField($PosX, $PosY, $SemiForceHead)
			EndIf
		Case $Joystick
		Case $Keyboard
			GetKeyboard()
	EndSwitch

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
	; never implemented pause function
	If _IsPressed("50", $dll) Then Return $keyPause
	If _IsPressed("13", $dll) Then Return $keyPause

	Return 0

EndFunc

; display score, current level, number of lives and forcefield charges on one line
;  	current points accrued on another
Func DisplayScore()

	Local $temp = "Score:  " & $Score & "  Level: " & $Level &  "  Lives: " & $Lives & "  Forcefeld: " & $ForceField
	GUICtrlSetData($hDisplay, $temp)
	$temp = "Points: " & $LevelScore
	GUICtrlSetData($hDisplay2, $temp)

EndFunc

Func StopAllSounds()

	For $loop = 0 to 8
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
			_SoundPlay($Sound[$sndElevator])
			Flicker()
			UpLevel()
;			_SoundStop($Sound[$sndElevator])
		Case $Gift
			; multiple gifts sometimes would not sound so I used to SoundPlay and SoundStop to better define sound timing
			_SoundPlay($Sound[$sndGift])
			Flicker()
			$LevelScore += 100
;			_SoundStop($Sound[$sndGift])
		Case $PacMan
			PacManMode()
		Case $Devolve
			Devolve()
		Case $Angel
			_SoundPlay($Sound[$sndExtraLife])
			Flicker()
			If $Lives < 9 Then $Lives += 1
		Case $Devil
			; 0 to 3 lives lost
			For $loop = 1 to Rand(3)
				Death()
			Next
		Case $ExpressElevator
			For $loop = 1 to 4
				_SoundPlay($Sound[$sndElevator])
				Flicker()
				UpLevel()
;				_SoundStop($Sound[$sndElevator])
			Next
		Case $Cross
			Cross()
		Case $BrickWall
			_SoundPlay($Sound[$sndThunk])
			Flicker()
			; increment the force field charge by two
			; still topping out at 8 charges
			If $ForceField < 7 Then $ForceField += 1
			If $ForceField < 8 Then $ForceField += 1

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
	$LevelScore = 0
	Flicker()
	$Lives -= 1
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
Func PacManMode()

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
	For $loop = 1 to 5 + Rand(4)
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
	SoundtoArray("Transporter.mp3", $sndElevator)
	SoundtoArray("Pacman.wav", $sndPacMan)
	SoundtoArray("ExtraLife.wav", $sndExtraLife)
	SoundtoArray("Gift.mp3", $sndGift)
	SoundtoArray("Devolve.mp3", $sndDevolve)
	SoundtoArray("PacManBegins.mp3", $sndScissors)
	SoundtoArray("Cross.mp3", $sndCross)
	SoundtoArray("Brickwall.mp3", $sndThunk)

EndFunc

; create a handle to sound effect $file
Func SoundtoArray($file, $SoundNumber)

	$Sound[$SoundNumber] = _SoundOpen(".\Sounds\" & $file)
	If @error = 2 Then
		MsgBox(0, "Initialization Error", $file & " not found.")
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
		Case $PacMan
			$FileName = ".\Images\08 PacMan.bmp"
		Case $Devolve
			$FileName = ".\Images\09 Devolve.bmp"
		Case $Angel
			$FileName = ".\Images\10 Angel.bmp"
		Case $Devil
			$FileName = ".\Images\11 Devil.bmp"
		Case $ExpressElevator
			$FileName = ".\Images\12 Atom.bmp"
		Case $Cross
			$FileName = ".\Images\13 Cross.bmp"
		Case $BrickWall
			$FileName = ".\Images\14 BrickWall.bmp"
		Case $Void
			$FileName = ".\Images\15 Void.bmp"
		Case $ForceHead
			$FileName = ".\Images\Forcefield.bmp"
		Case $SemiForceHead
			$FileName = ".\Images\Semi Forcefield.bmp"
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

; guess
Func SwapVar(byref $a, byref $b)

	Local $temp
	$temp = $b
	$b = $a
	$a = $temp

EndFunc
;
; Display Top Twenty High Scores
;
Func HighScore()

	; high score pane top most and moveable but nothing else - closes by game pane close
	$StatID = GUICreate("High Scores", 220, 495-30)
	GUISetFont(16, 800, -1, "Courier New")

	; if no high score file, create it
	If Not FileExists("Reflex.dat") Then
		$file = FileOpen("Reflex.dat", 2)
		If $file = -1 Then
			MsgBox(0, "Fatal Error", "Can not create high score file")
			Exit
		EndIf
		$temp = StringFormat("%4s%6d", "GACB", 10)
		For $loop = 1 to 20
			FileWriteLine($file, $temp)
		Next
		FileClose($file)
	EndIf
	; Load Score Array from file
	$file = FileOpen("Reflex.dat", 0) ; read only
	Const $Names  = 0
	Const $Scores = 1
	Dim $ArrayOfScores[2][21]
	For $loop = 1 to 20
		$linescore = FileReadLine($file)
		$ArrayOfScores[$Names][$loop]  = StringLeft($linescore & "    ", 4)
		$ArrayOfScores[$Scores][$loop] = int(StringMid($linescore, 5, 6))
	Next
	FileClose($file)
	; Test if new score must be added to scoreboard
	If $Score > $ArrayOfScores[$Scores][20] Then
		$temp = InputBox("New Score for Scoreboard", "Enter Your Initials: ", "", "", -1, 120)
		$temp = StringLeft($temp & "    ",4)
		$ArrayOfScores[$Names][0]  = StringUpper($temp)
	Else
		$ArrayOfScores[$Names][0]  = ""
	EndIf
	$ArrayOfScores[$Scores][0] = int($Score)
	Sort($ArrayOfScores)
	; write high score file
	$file = FileOpen("Reflex.dat", 2) ; write fresh
	If $file = -1 Then
		MsgBox(0, "Fatal Error", "Can not update high score file")
		Exit
	EndIf
	For $loop = 0 to 19
		$temp = StringLeft($ArrayOfScores[$Names][$loop],4)
		FileWriteLine($file, $temp & $ArrayOfScores[$Scores][$loop])
	Next
	FileClose($file)

    ; Display Scores
	$temp = ""
    For $loop = 0 to 19
		GUICtrlCreateLabel($loop+1 & ".", 10, $loop * 21 + 10)
		GUICtrlCreateLabel($ArrayOfScores[$Names][$loop], 60, $loop * 21 + 10)
		$temp = StringFormat("%6d", $ArrayOfScores[$Scores][$loop])
		GUICtrlCreateLabel($temp, 130, $loop * 21 + 10)
	Next
	GUISetState()

	; wait until window is closed
	$close = GUICtrlCreateButton("Close", 220-100, 431, 90, 30)
	Do
		$msg = GUIGetMsg()
		If $msg = $close Then ExitLoop
		Sleep(20)
	Until $msg = $GUI_EVENT_CLOSE
	GUIDelete($StatID)
	OnExit()

EndFunc   ;==>DisplayStatHistory

Func Sort( byref $ArrayOfScores)

	Const $Names  = 0
	Const $Scores = 1
	For $a = 0 to 19
		for $b = $a + 1 to 1 step -1
			if $ArrayOfScores[$Scores][$b] > $ArrayOfScores[$Scores][$b-1] Then
				SwapVar($ArrayOfScores[$Scores][$b-1], $ArrayOfScores[$Scores][$b])
				SwapVar($ArrayOfScores[$Names][$b-1],  $ArrayOfScores[$Names][$b])
			EndIf
		Next
	Next

EndFunc
