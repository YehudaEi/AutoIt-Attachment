;coded by UEZ 2009
#AutoIt3Wrapper_UseUpx=n
#AutoIt3Wrapper_Run_Obfuscator=y
#Obfuscator_Parameters=/SO
#AutoIt3Wrapper_Run_After=upx.exe --best "%out%"

#include <GuiButton.au3>
#include <GUIConstantsEx.au3>
#include <GDIplus.au3>
#include <Misc.au3>
#include <WindowsConstants.au3>

Opt('MustDeclareVars', 1)
Opt('MouseCoordMode', 2)

HotKeySet("{F5}", "Initialize")

Global $dll = DllOpen("user32.dll")
Global Const $width = 1024
Global Const $height = $width * 9 / 16

Global $field_size = 90
Global $hwnd = GUICreate("Simple Ball Collision Simulation BETA by UEZ 2009  - Press F5 to Refresh!", $width, $height + $field_size, -1, -1, Default, $WS_EX_TOOLWINDOW)
_GDIPlus_Startup()
Global $graphics = _GDIPlus_GraphicsCreateFromHWND($hwnd)
Global $bitmap = _GDIPlus_BitmapCreateFromGraphics($width, $height, $graphics)
Global $backbuffer = _GDIPlus_ImageGetGraphicsContext($bitmap)
_GDIPlus_GraphicsClear($backbuffer)
_GDIPlus_GraphicsSetSmoothingMode($backbuffer, 2)
Global $brush_color
Global $brush = _GDIPlus_BrushCreateSolid()
_GDIPlus_BrushSetSolidColor($brush, $brush_color)
Global $pen = _GDIPlus_PenCreate(0, 2)
_GDIPlus_PenSetColor($pen, 0xFFFFFFFF)
Global $max_balls = 50
Global $amount_balls = 24
Global $min_balls = 2

Global $max_speed = 6
Global $pi = 3.1415926535897932384626
Global $pi_div_180 = $pi / 180

Global $diameter = 64
Global $radius = $diameter / 2
Global $friction = 0
Global $friction_max = 100
Dim $coordinates[$max_balls][10]
Global $angle, $distance, $dist, $DX, $DY, $mass_tot, $matrix11, $matrix12, $matrix21, $matrix22, $v_p1, $v_p2, $v_x1, $v_x2, $v_y1, $v_y2
Global $q, $msg
Dim $brush[$max_balls]

Global $ball_size_min = 10
Global $ball_size_max = 3 * Int(@DesktopHeight / 16)

Global $mouse_pos[2], $mouse_pos_temp[2]

GUICtrlCreateLabel("Ball size (min: " & $ball_size_min & "  -  max: " & $ball_size_max & ")", 4, $height + 12)
GUICtrlCreateLabel("Current ball size = " & $diameter, 4, $height + 68)
Global $slider_ball_size = GUICtrlCreateSlider(4, $height + 28, 150, 35)
GUICtrlSetLimit(-1, $ball_size_max, $ball_size_min)
GUICtrlSetTip(-1, "Move slider to change size of balls but pay attention to the amount of balls!")

GUICtrlCreateLabel("Friction (min: 0 -  max: 100)", 160, $height + 12)
GUICtrlCreateLabel("Current friction value = " & $friction, 160, $height + 68)
Global $slider_friction = GUICtrlCreateSlider(160, $height + 28, 150, 35)
GUICtrlSetLimit(-1, $friction_max, $friction)
GUICtrlSetData(-1, 0)
GUICtrlSetTip(-1, "Move slider to change friction value! The higher the value the more fraction." & @CRLF & "You need to press F5 when the balls have no speed anymore!")

GUICtrlCreateLabel("Amount of balls (min: " & $min_balls & "  -  max: " & $max_balls & ")", 316, $height + 12)
GUICtrlCreateLabel("Current balls = " & $amount_balls, 316, $height + 68)
Global $slider_amount_balls = GUICtrlCreateSlider(316, $height + 28, 168, 35)
GUICtrlSetLimit(-1, $max_balls, 2)
GUICtrlSetData(-1, $amount_balls)
GUICtrlSetTip(-1, "Move slider to change amount of balls!" & @CRLF & @CRLF & "But if ball size and amount of balls is too high then it will hard to place balls " & @CRLF & "on screen without collide with other balls!!!")

Global $Checkbox = GUICtrlCreateCheckbox(" Enable random mass", 492, $height + 08)
GUICtrlSetState($Checkbox, $GUI_UNCHECKED)
GUICtrlSetTip(-1, "Enable or disable random ball mass! When selected / unselected press F5 to apply!")
Global $random_mass = False
Global $nMsg

GUISetBkColor(0xF0F0F0)
GUISetState(@SW_SHOW)
GUICtrlSetData($slider_ball_size, $diameter)

GUIRegisterMsg($WM_HSCROLL, "WM_HSCROLL")

Initialize()

Do
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $Checkbox
			If BitAND(GUICtrlRead($Checkbox), $GUI_CHECKED) Then
				$random_mass = True
			ElseIf BitAND(GUICtrlRead($Checkbox), $GUI_UNCHECKED) Then
				$random_mass = False
			EndIf
	EndSwitch
	_GDIPlus_GraphicsClear($backbuffer, 0xFF000000)
	Collision_Check()
	Draw_Dots()
	Calculate_New_Position()
	_GDIPlus_GraphicsDrawImageRect($graphics, $bitmap, 0, 0, $width, $height)
	Sleep(25)
Until $nMsg = $GUI_EVENT_CLOSE


Func WM_HSCROLL() ;check for slider activity
	$diameter = GUICtrlRead($slider_ball_size)
	$radius = $diameter / 2
	$friction = GUICtrlRead($slider_friction)
	$amount_balls = GUICtrlRead($slider_amount_balls)
	GUICtrlCreateLabel($diameter, 90, $height + 68) ;update only the value
	GUICtrlCreateLabel($friction, 160 + 109, $height + 68)
	GUICtrlCreateLabel($amount_balls, 386, $height + 68)
	$friction = 1 - ($friction / 4000) ;set friction
EndFunc   ;==>WM_HSCROLL

Func Initialize()
	$friction = 1
	For $k = 0 To $max_balls - 1
		$brush_color = 0xFF000000 + Random(0x400000, 0xFFFFFF, 1)
		$brush[$k] = _GDIPlus_BrushCreateSolid($brush_color)
		Create_New_Coordinates($k)
	Next
	WM_HSCROLL()
EndFunc   ;==>Initialize

Func Create_New_Coordinates($k)
	Local $z = 0, $d, $time = TimerInit(), $time_diff
	$coordinates[$k][0] = Random(1, $width - $diameter - 1, 1);start x position
	$coordinates[$k][1] = Random(1, $height - $diameter - 1, 1) ;start y position
	If $k > 0 Then
		While $z < $k ;check each ball for collision during creation of random x,y position -> can take a while when amount of balls and ball size are big
			$d = Pixel_Distance($coordinates[$k][0], $coordinates[$k][1], $coordinates[$z][0], $coordinates[$z][1])
			If $d <= $diameter + 1 Then
				$coordinates[$k][0] = Random(1, $width - $diameter - 1, 1);start x position
				$coordinates[$k][1] = Random(1, $height - $diameter - 1, 1) ;start y position
;~ 				_GDIPlus_GraphicsDrawEllipse($graphics, $coordinates[$k][0], $coordinates[$k][1], $diameter, $diameter, $pen) ;only for debugging needed
				$z = 0
			Else
				$z += 1
			EndIf
			$time_diff = TimerDiff($time) / ($amount_balls * $diameter)
			If $time_diff > 500 Then ExitLoop ;avoid searching for position endlessly
		WEnd
	EndIf
	$coordinates[$k][2] = Random(5, $max_speed, 1) ;speed of pixel
	$angle = Random(0, 359, 1)
	$coordinates[$k][3] = $coordinates[$k][2] * Cos($angle * $pi_div_180) ;slope of x -> vector x
	$coordinates[$k][4] = $coordinates[$k][2] * Sin($angle * $pi_div_180) ;slope of y -> vector y
	If $random_mass Then
		$coordinates[$k][5] = Random(0.5, 5.0)
	Else
		$coordinates[$k][5] = 1 ;mass of the ball
	EndIf
	$coordinates[$k][6] = $coordinates[$k][0] ;previous x coordinate
	$coordinates[$k][7] = $coordinates[$k][1] ;previous y coordinate
	$coordinates[$k][8] = $coordinates[$k][3] ;previous x slope
	$coordinates[$k][9] = $coordinates[$k][4] ;previous y slope
EndFunc   ;==>Create_New_Coordinates

Func Collision_Check()
	Global $back_v1, $back_v2, $old_x1, $old_y1, $old_x2, $old_y2
	For $x = 0 To $amount_balls - 1
		For $y = $x + 1 To $amount_balls - 1
			$distance = Pixel_Distance($coordinates[$x][0], $coordinates[$x][1], $coordinates[$y][0], $coordinates[$y][1]) ;get distance
			If $distance <= $diameter Then
				$DX = $coordinates[$y][0] - $coordinates[$x][0] ;save delta x
				$DY = $coordinates[$y][1] - $coordinates[$x][1] ;save delta y

				;matrix with new coordinate axis (orthographic / parallel to collision object)
				$matrix11 = $DX / $distance
				$matrix12 = -$DY / $distance
				$matrix21 = $DY / $distance
				$matrix22 = $DX / $distance

				;scalar product of vectors
				$v_x1 = $coordinates[$x][3] * $matrix11 + $coordinates[$x][4] * - $matrix12
				$v_y1 = $coordinates[$x][3] * - $matrix21 + $coordinates[$x][4] * $matrix22
				$v_x2 = $coordinates[$y][3] * $matrix11 + $coordinates[$y][4] * - $matrix12
				$v_y2 = $coordinates[$y][3] * - $matrix21 + $coordinates[$y][4] * $matrix22

				;calculate new vectors according to mass
				$mass_tot = $coordinates[$x][5] + $coordinates[$y][5] ;total mass
				$v_p1 = ($coordinates[$x][5] - $coordinates[$y][5]) / $mass_tot * $v_x1 + 2 * $coordinates[$y][5] / $mass_tot * $v_x2
				$v_p2 = ($coordinates[$y][5] - $coordinates[$x][5]) / $mass_tot * $v_x2 + 2 * $coordinates[$x][5] / $mass_tot * $v_x1

				If $v_p1 - $v_p2 > 0 Then ;avoid orbiting effect -> still in beta phase 
					$coordinates[$x][0] = $coordinates[$x][6] + $coordinates[$x][8] * 1.75 ;replace ball1's x coordinate to prevoius x position
					$coordinates[$x][1] = $coordinates[$x][7] + $coordinates[$x][9] * 1.75 ;replace ball1's y coordinate to prevoius y position
					$coordinates[$y][0] = $coordinates[$y][6] + $coordinates[$y][8] * 1.75 ;replace ball2's x coordinate to prevoius x position
					$coordinates[$y][1] = $coordinates[$y][7] + $coordinates[$y][9] * 1.75 ;replace ball2's y coordinate to prevoius y position
				EndIf
				$coordinates[$x][3] = $v_p1 * $matrix11 + $v_y1 * $matrix12
				$coordinates[$x][4] = $v_p1 * $matrix21 + $v_y1 * $matrix22
				$coordinates[$y][3] = $v_p2 * $matrix11 + $v_y2 * $matrix12
				$coordinates[$y][4] = $v_p2 * $matrix21 + $v_y2 * $matrix22
			EndIf
		Next
	Next
EndFunc   ;==>Collision_Check

Func Calculate_New_Position()
	Local $k, $dist_tmp
	For $k = 0 To $amount_balls - 1
		$coordinates[$k][6] = $coordinates[$k][0] ;save previous x coordinate
		$coordinates[$k][7] = $coordinates[$k][1] ;save previous y coordinate
		$coordinates[$k][8] = $coordinates[$k][3] ;save previous x slope
		$coordinates[$k][9] = $coordinates[$k][4] ;save previous y slope
		$coordinates[$k][0] += $coordinates[$k][3] ;increase x coordinate with appropriate slope (x vector)
		$coordinates[$k][1] += $coordinates[$k][4] ;increase y coordinate with appropriate slope (y vector)
		If $coordinates[$k][0] <= 0 Then ;border collision x left
			$coordinates[$k][0] = 1
			$coordinates[$k][3] *= -1
		ElseIf $coordinates[$k][0] >= $width - $diameter Then ;border collision x right
			$coordinates[$k][0] = $width - ($diameter + 1)
			$coordinates[$k][3] *= -1
		EndIf
		If $coordinates[$k][1] <= 0 Then ;border collision y top
			$coordinates[$k][1] = 1
			$coordinates[$k][4] *= -1
		ElseIf $coordinates[$k][1] >= $height - $diameter Then ;border collision y bottom
			$coordinates[$k][1] = $height - ($diameter + 1)
			$coordinates[$k][4] *= -1
		EndIf
		$coordinates[$k][3] *= $friction ;friction of the ball with the ground (x vector)
		$coordinates[$k][4] *= $friction ;friction of the ball with the ground (y vector)
	Next
EndFunc   ;==>Calculate_New_Position

Func Pixel_Distance($x1, $y1, $x2, $y2) ;Pythagoras theorem
	Local $a, $b, $c
	If $x2 = $x1 And $y2 = $y1 Then
		Return 0
	Else
		$a = $y2 - $y1
		$b = $x2 - $x1
		$c = Sqrt($a * $a + $b * $b)
		Return $c
	EndIf
EndFunc   ;==>Pixel_Distance

Func Draw_Dots()
	Local $i, $temp_x, $temp_y
	For $i = 0 To $amount_balls - 1
		_GDIPlus_GraphicsFillEllipse($backbuffer, $coordinates[$i][0], $coordinates[$i][1], $diameter, $diameter, $brush[$i])
;~ 		_GDIPlus_GraphicsDrawEllipse($backbuffer, $coordinates[$i][6], $coordinates[$i][7], $diameter, $diameter, $pen) ;show previous coorinate
	Next
EndFunc   ;==>Draw_Dots

Func Close()
	_GDIPlus_PenDispose($pen)
	For $x = 0 To UBound($brush) - 1
		_GDIPlus_BrushDispose($brush[$x])
	Next
	_GDIPlus_BitmapDispose($bitmap)
	_GDIPlus_GraphicsDispose($graphics)
	_GDIPlus_GraphicsDispose($backbuffer)
	_GDIPlus_Shutdown()
	DllClose($dll)
	Exit
EndFunc   ;==>Close

Func _GDIPlus_BrushSetSolidColor($hBrush, $iARGB = 0xFF000000)
	Local $aResult
	$aResult = DllCall($ghGDIPDll, "int", "GdipSetSolidFillColor", "hwnd", $hBrush, "int", $iARGB)
	If @error Then Return SetError(@error, @extended, 0)
	Return SetError($aResult[0], 0, $aResult[0] = 0)
EndFunc   ;==>_GDIPlus_BrushSetSolidColor