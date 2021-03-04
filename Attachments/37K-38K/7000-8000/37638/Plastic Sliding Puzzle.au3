#NoTrayIcon
#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=PSSP.ico
#AutoIt3Wrapper_UseX64=n
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#cs ----------------------------------------------------------------------------
	AutoIt Version: 3.3.6.1
	Author:      Garth Bigelow
	email:       garthbigelow@gmail.com
	Script Function: Sliding Squiare Puzzle
#ce ----------------------------------------------------------------------------

#include <ButtonConstants.au3>
#include <GUIConstantsEx.au3>
#Include <GuiMenu.au3>
#include <WindowsConstants.au3>

Const $version = "Plastic Sliding Squares Puzzle v1.01"

; Size of the Grid
; 3 to 12
$Size  = 4
;
; Speed of Sliding Movement
; 0 to ridiculously slow
$Speed = 10
;
; Number of potential moves
; needs to be rather larger as movement back and forth happens more often than you would think
; the smaller the grid the larger complexity needs to be
; the greater complexity the more challenging the puzzle
$Complexity = 36
;
; Whether empty square is the last number or not
; 0 for not
$Advanced = 0
;
; Disregard the Ini file and use the values above or not
$Ignore = False

If FileExists("PSSP.ini") = 0 Then
	iniWrite("PSSP.ini", "Config", "Grid Size", 4)
	iniWrite("PSSP.ini", "Config", "Speed", 10)
	iniWrite("PSSP.ini", "Config", "Complexity", 36)
	iniWrite("PSSP.ini", "Config", "Adanced", 0)
Endif
If Not $Ignore  Then
	$Size = IniRead("PSSP.ini", "Config", "Grid Size", 4)
	$Speed = IniRead("PSSP.ini", "Config", "Speed", 10)
	$Complexity = IniRead("PSSP.ini", "Config", "Complexity", 36)
	$Advanced = IniRead("PSSP.ini", "Config", "Adanced", 0)
EndIf
$Size -= 1

Dim $hBoard[($Size + 1)][($Size + 1)]

Global $GoX, $GoY, $MoveCount = 0, $MenuSpace = 0
$hGUI = GUICreate($version, 68 * ($Size + 1)+3, 68 * ($Size + 1) + ($MenuSpace) + 3, -1, -1, -1, $WS_EX_COMPOSITED)
GUISetFont(14, 600)
GUISetBkColor(0xAA4444)
If $Advanced = 0 Then
	$EmptySquare = ($Size+1) * ($Size+1)
Else
	$EmptySquare = Rand(($Size+1) * ($Size+1))
EndIf
For $x = 0 To $Size
	For $y = 0 To $Size
		$label = ($y) * ($Size + 1) + ($x + 1)
		$hBoard[$x][$y] = GUICtrlCreateButton($label, $x * 68 + 3, $y * 68 + 3, 65, 65, $BS_FLAT)
		GUICtrlSetPos($hBoard[$x][$y], $x * 68 + 3, ($y * 68 + 3 + $MenuSpace))
		If Odd($label) Then
			$Color = 0xff0000
		Else
			$Color = 0x000000
		EndIf
		GUICtrlSetColor(-1, $Color)
		If $EmptySquare = $label Then GUICtrlSetState($hBoard[$x][$y], $GUI_HIDE)
	Next
Next
GUISetState()
;SystemMenu()
Scramble()
$MoveCount = 0

While True
	$msg = GUIGetMsg()
	If $msg = $GUI_EVENT_CLOSE Then
		GUIDelete()
		Exit
	EndIf
	ProcessClick()
	If Over() Then
		NumToCoord($EmptySquare)
		GUICtrlSetState($hBoard[$GoX][$GoY], $GUI_SHOW)
		MsgBox(48, "Puzzle Completed", "You completed the puzzle in " & $MoveCount & " moves.")
		Exit
	EndIf
WEnd

Func ProcessClick()

	For $px = 0 To $Size
		For $py = 0 To $Size
			If $msg = $hBoard[$px][$py] Then
				If IsValidClick($px, $py) Then
					Slide($px, $py)
					Return
				EndIf
				Return
			EndIf
		Next
	Next
	Sleep(10)

EndFunc

Func Scramble()

	$holdSpeed = $Speed
	$Speed = 0
	$a = $Complexity
	While $a > 0
		$x = Rand($Size)
		$y = Rand($Size)
		If IsValidClick($x, $y) Then
			Slide($x, $y)
			$a -= 1
		EndIf
	WEnd
	$Speed = $holdSpeed

EndFunc

Func Slide($x, $y)

	NumToCoord($EmptySquare)
	if $x > $GoX Then SlideLeft($x, $y)
	if $x < $GoX Then SlideRight($x, $y)
	if $y > $GoY Then SlideUp($x, $y)
	If $y < $GoY Then SlideDown($x, $y)
	$MoveCount += 1

EndFunc

Func SlideDown($x, $y)

	NumToCoord($EmptySquare)
	For $line = 0 To 68
		For $b = $y To $GoY
			GUICtrlSetPos($hBoard[$x][$b], $x * 68 + 3, ($b * 68 + 3 + $MenuSpace) + $line)
		Next
		Sleep($Speed)
	Next
	$holdHandle = $hBoard[$GoX][$GoY]
	For $b = $GoY - 1 To $y Step - 1
		$hBoard[$x][$b+1] = $hBoard[$x][$b]
	Next
	$hBoard[$x][$y] = $holdHandle

EndFunc

Func SlideLeft($x, $y)

	NumToCoord($EmptySquare)
	For $line = 0 To 68
		For $b = $GoX To $x
			GUICtrlSetPos($hBoard[$b][$y], ($b * 68 + 3) - $line, ($y * 68 + 3 + $MenuSpace))
		Next
		Sleep($Speed)
	Next
	$holdHandle = $hBoard[$GoX][$GoY]
	For $b = $GoX + 1 To $x
		$hBoard[$b-1][$y] = $hBoard[$b][$y]
	Next
	$hBoard[$x][$y] = $holdHandle

EndFunc

Func SlideRight($x, $y)

	NumToCoord($EmptySquare)
	For $line = 0 To 68
		For $b = $x To $GoX - 1
			GUICtrlSetPos($hBoard[$b][$y], ($b * 68 + 3) + $line, ($y * 68 + 3 + $MenuSpace))
		Next
		Sleep($Speed)
	Next
	$holdHandle = $hBoard[$GoX][$GoY]
	For $b = $GoX - 1 To $x Step - 1
		$hBoard[$b+1][$y] = $hBoard[$b][$y]
	Next
	$hBoard[$x][$y] = $holdHandle

EndFunc

Func SlideUp($x, $y) ; checked

	NumToCoord($EmptySquare)
	For $line = 0 To 68
		For $b = $GoY To $y
			GUICtrlSetPos($hBoard[$x][$b], $x * 68 + 3, ($b * 68 + 3 + $MenuSpace) - $line)
		Next
		Sleep($Speed)
	Next
	$holdHandle = $hBoard[$GoX][$GoY]
	For $b = $GoY + 1 To $y
		$hBoard[$x][$b-1] = $hBoard[$x][$b]
	Next
	$hBoard[$x][$y] = $holdHandle

EndFunc

Func IsValidClick($x, $y)

	NumToCoord($EmptySquare)
	$EmptyX = $GoX
	$EmptyY = $GoY
	NumToCoord(GUICtrlRead($hBoard[$x][$y]))
	If $EmptyX = $GoX Or $EmptyY = $GoY Then Return 1
	Return 0

EndFunc

Func NumToCoord($Num)

	For $x = 0 To $Size
		For $y = 0 To $Size
			$lnum = GUICtrlRead($hBoard[$x][$y])
			If $num = $lnum Then
				$GoX = $x
				$GoY = $y
				ExitLoop 2
			EndIf
		Next
	Next

EndFunc

Func Over()

	For $x = 0 to $Size
		For $y = 0 To $Size
			If ($y) * ($Size + 1) + ($x + 1) <> GUICtrlRead($hBoard[$x][$y]) Then Return 0
		Next
	Next
	Return 1

EndFunc

Func Odd($num)

	If ($num / 2) = Int($num / 2) Then Return 0
	Return 1

EndFunc
;
; bend random() function to my needs
;
Func Rand($pMax)

	Return Random(0, $pMax, 1)

EndFunc