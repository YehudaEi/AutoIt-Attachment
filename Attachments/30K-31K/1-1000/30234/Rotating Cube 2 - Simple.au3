;coded by UEZ 2010
#AutoIt3Wrapper_UseUpx=n
#AutoIt3Wrapper_Run_Obfuscator=y
#Obfuscator_Parameters=/sf /sv /om /cs=0 /cn=0
#AutoIt3Wrapper_Run_After=del /f /q "Rotating Cube 2 - Simple_Obfuscated.au3"
;~ #AutoIt3Wrapper_Run_After=upx.exe --best "%out%"
#AutoIt3Wrapper_Run_After=upx.exe --ultra-brute "%out%"
#include <GDIPlus.au3>

Opt("MustDeclareVars", 1)
Opt("GUIOnEventMode", 1)
Opt("MouseCoordMode", 1)

Local Const $Width = 1024
Local Const $Height = 768

Local $hwnd = GUICreate("Rotating Cube 2 Simple v0.70 Build 2010-04-06 by UEZ 2010 (use mouse wheel to zoom)", $Width, $Height)

GUISetState()

If @OSBuild < 7600 Then WinSetTrans($hwnd,"", 0xFF) ;workaround for XP machines when alpha blending is activated on _GDIPlus_GraphicsClear() function to avoid slow drawing

_GDIPlus_Startup()
Local $hGraphics = _GDIPlus_GraphicsCreateFromHWND($hwnd)
Local $hBitmap = _GDIPlus_BitmapCreateFromGraphics($Width, $Height, $hGraphics)
Local $hBackbuffer = _GDIPlus_ImageGetGraphicsContext($hBitmap)
_GDIPlus_GraphicsClear($hBackbuffer)
_GDIPlus_GraphicsSetSmoothingMode($hBackbuffer, 2)

Local $hPen = _GDIPlus_PenCreate(0xF0000060, 1)
Local $hBrush = _GDIPlus_BrushCreateSolid(0)

Local Const $Pi = ACos(-1)
Local Const $180_Div_Pi = 180 / $Pi
Local Const $amout_of_dots = 8
Local Const $dx = @DesktopWidth * 0.5, $dy = @DesktopHeight * 0.5
Local Const $zoom_min = 50
Local Const $zoom_max = 150
Local $zoom_counter = 100
Local $dot_distance = 150
Local $b, $j, $x, $y, $z, $mx, $my, $start_x, $start_y, $mouse_pos, $mouse_sense
Local $draw_coordinates[$amout_of_dots][4] = [ _;	X					y					Z
												[-$dot_distance, 	-$dot_distance, 	-$dot_distance	], _
												[$dot_distance, 	-$dot_distance,		-$dot_distance	], _
												[$dot_distance, 	$dot_distance, 		-$dot_distance	], _
												[-$dot_distance, 	$dot_distance, 		-$dot_distance	], _
												[-$dot_distance, 	-$dot_distance, 	$dot_distance	], _
												[$dot_distance, 	-$dot_distance,		$dot_distance	], _
												[$dot_distance, 	$dot_distance, 		$dot_distance	], _
												[-$dot_distance, 	$dot_distance, 		$dot_distance	]]

;       4 -- - - - 5
;     / |        / |
;    0 - -  - - 1  |
;    |  |       |  |
;    |  7 -- - -|- 6
;    | /        | /
;    3 - -  - - 2

$mouse_sense = 4000
$start_x = $Width / 2
$start_y = $Height / 2
MouseMove($dx, $dy, 1)

GUIRegisterMsg(0x020A, "WM_MOUSEWHEEL")

GUISetOnEvent(-3, "Close")

Do
	_GDIPlus_GraphicsClear($hBackbuffer, 0xF0506070)

	For $b = 0 To $amout_of_dots - 1 ;correct perspective
		$draw_coordinates[$b][3] = 1 + $draw_coordinates[$b][2] / 0x600
	Next

	;draw surfaces
	Draw_Lines(3, 2, 6, 7)
	Draw_Lines(5, 1, 0, 4)
	Draw_Lines(1, 2, 3, 0)
	Draw_Lines(7, 6, 5 ,4)
	Draw_Lines(6, 2, 1, 5)
	Draw_Lines(0, 3, 7, 4)

	$mouse_pos = MouseGetPos()
	For $j = 0 To $amout_of_dots - 1
		Calc(-(-$dy + $mouse_pos[1]) / $mouse_sense, (-$dx + $mouse_pos[0]) / $mouse_sense, $j) ;calculate new coordinates
	Next

	_GDIPlus_GraphicsDrawImageRect($hGraphics, $hBitmap, 0, 0, $Width, $Height)
Until Not Sleep(40)

Func Draw_Lines($p1, $p2, $p3, $p4)
	Local $k1, $k2, $k3, $k4, $x1, $y1, $x2, $y2, $x3, $y3, $x4, $y4, $z1, $z2, $z3
	$x1 = $draw_coordinates[$p1][0] * $draw_coordinates[$p1][3]
	$y1 = $draw_coordinates[$p1][1] * $draw_coordinates[$p1][3]
	$z1 = $draw_coordinates[$p1][2]
	$x2 = $draw_coordinates[$p2][0] * $draw_coordinates[$p2][3]
	$y2 = $draw_coordinates[$p2][1] * $draw_coordinates[$p2][3]
	$z2 = $draw_coordinates[$p2][2]
	$x3 = $draw_coordinates[$p3][0] * $draw_coordinates[$p3][3]
	$y3 = $draw_coordinates[$p3][1] * $draw_coordinates[$p3][3]
	$z3 = $draw_coordinates[$p3][2]
	$x4 = $draw_coordinates[$p4][0] * $draw_coordinates[$p4][3]
	$y4 = $draw_coordinates[$p4][1] * $draw_coordinates[$p4][3]

	$k1 = $x1 - $x2
	$k2 = $y3 - $y2
	$k3 = $y1 - $y2
	$k4 = $x3 - $x2

	If $k1 * $k2 - $k3 * $k4 > 0 Then ;draw only visible surfaces -> max. 3 surfaces possible
		Local $aPoints[5][2], $v1, $v2, $v3, $deg, $r, $g, $b
		$aPoints[0][0] = 4
		$aPoints[1][0] = $start_x + $x1
		$aPoints[1][1] = $start_y + $y1
		$aPoints[2][0] = $start_x + $x2
		$aPoints[2][1] = $start_y + $y2
		$aPoints[3][0] = $start_x + $x3
		$aPoints[3][1] = $start_y + $y3
		$aPoints[4][0] = $start_x + $x4
		$aPoints[4][1] = $start_y + $y4

        $v1 = ($y1 - $y2) * ($z3 - $z2) - ($z1 - $z2) * ($y3 - $y2)
		$v2 = ($z1 - $z2) * ($x3 - $x2) - ($x1 - $x2) * ($z3 - $z2)
		$v3 = ($x1 - $x2) * ($y3 - $y2) - ($y1 - $y2) * ($x3 - $x2)
		$deg = ASin(Sqrt(($v2 * $v2 + $v1 * $v1) / ($v1 * $v1 + $v2 * $v2 + $v3 * $v3))) * $180_Div_Pi
        $r = 0xA0 - $deg
        $g = 0xA0 - $deg
		$b = 0xFF - $deg
        _GDIPlus_BrushSetSolidColor($hBrush, "0xFF" & Hex($r, 0x2) & Hex($g, 0x2) & Hex($b, 0x2))

		_GDIPlus_GraphicsFillPolygon($hBackbuffer, $aPoints, $hBrush)

		_GDIPlus_GraphicsDrawLine($hBackbuffer, $aPoints[1][0], $aPoints[1][1], $aPoints[2][0], $aPoints[2][1], $hPen)
		_GDIPlus_GraphicsDrawLine($hBackbuffer, $aPoints[2][0], $aPoints[2][1], $aPoints[3][0], $aPoints[3][1], $hPen)
		_GDIPlus_GraphicsDrawLine($hBackbuffer, $aPoints[3][0], $aPoints[3][1], $aPoints[4][0], $aPoints[4][1], $hPen)
		_GDIPlus_GraphicsDrawLine($hBackbuffer, $aPoints[4][0], $aPoints[4][1], $aPoints[1][0], $aPoints[1][1], $hPen)
	EndIf
EndFunc   ;==>Draw

Func Calc($angle_x, $angle_y, $i, $angle_z = 0)
	;calculate 3D rotation
	$x = $draw_coordinates[$i][0] * Cos($angle_y) + $draw_coordinates[$i][2] * Sin($angle_y)
	$y = $draw_coordinates[$i][1]
	$z = -$draw_coordinates[$i][0] * Sin($angle_y) + $draw_coordinates[$i][2] * Cos($angle_y)
	$draw_coordinates[$i][0] = $x
	$draw_coordinates[$i][1] = $y * Cos($angle_x) - $z * Sin($angle_x)
	$draw_coordinates[$i][2] = $y * Sin($angle_x) + $z * Cos($angle_x)
;~ 	Local $sx, $sy, $sz, $cx, $cy, $cz, $px, $py, $pz

;~ 	$sx = Sin($angle_x)
;~ 	$cx = Cos($angle_x)
;~ 	$sy = Sin($angle_y)
;~ 	$cy = Cos($angle_y)
;~ 	$sz = Sin($angle_z)
;~ 	$cz = Cos($angle_z)

;~ 	$px = $draw_coordinates[$i][0]
;~ 	$py = $draw_coordinates[$i][1]
;~ 	$pz = $draw_coordinates[$i][2]
;~ 	;rotation x-axis
;~ 	$draw_coordinates[$i][1] = $py * $cx - $pz * $sx
;~ 	$draw_coordinates[$i][2] = $py * $sx + $pz * $cx
;~ 	$py = $draw_coordinates[$i][1]
;~ 	$pz = $draw_coordinates[$i][2]
;~ 	;rotation y-axis
;~ 	$draw_coordinates[$i][0] = $px * $cy + $pz * $sy
;~ 	$draw_coordinates[$i][2] = -$px * $sy + $pz * $cy
;~ 	$px = $draw_coordinates[$i][0]
;~ 	;rotation z-axis
;~ 	$draw_coordinates[$i][0] = $px * $cz - $py * $sz
;~ 	$draw_coordinates[$i][1] = $py * $cz + $px * $sz
EndFunc   ;==>Calc

Func Close()
	_GDIPlus_BrushDispose($hBrush)
	_GDIPlus_PenDispose($hPen)
	_GDIPlus_BitmapDispose($hBitmap)
	_GDIPlus_GraphicsDispose($hBackbuffer)
	_GDIPlus_GraphicsDispose($hGraphics)
	_GDIPlus_Shutdown()
	Exit
EndFunc   ;==>Close

Func Zoom($factor)
	Local $m
	For $m = 0 To $amout_of_dots - 1
		$draw_coordinates[$m][0] *= $factor
		$draw_coordinates[$m][1] *= $factor
		$draw_coordinates[$m][2] *= $factor
	Next
EndFunc

Func WM_MOUSEWHEEL($hWnd, $iMsg, $wParam, $lParam)
	Local $wheel_Dir = BitAND($wParam, 0x800000)
	If $wheel_Dir > 0 Then
		If $zoom_counter <= $zoom_max Then
			Zoom(1.05)
			$zoom_counter += 1
		EndIf
	Else
		If $zoom_counter >= $zoom_min Then
			Zoom(0.95)
			$zoom_counter -= 1
		EndIf
	EndIf
    Return "GUI_RUNDEFMSG"
EndFunc   ;==>WM_MOUSEWHEEL