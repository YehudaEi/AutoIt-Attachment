;Coded by UEZ Build 2010-06-25
#include <GDIPlus.au3>
#Include <Misc.au3>
Opt("MustDeclareVars", 1)
Opt("GUIOnEventMode", 1)
Opt("MouseCoordMode", 2)
Local Const $width = 1024
Local Const $height = 600
Local $hGUI = GUICreate("GDI+ Ball Trajectory by UEZ 2010", $width, $height)
GUISetState()

_GDIPlus_Startup()
Local $hGraphics = _GDIPlus_GraphicsCreateFromHWND($hGUI)
Local $hBitmap = _GDIPlus_BitmapCreateFromGraphics($width, $height, $hGraphics)
Local $hBuffer = _GDIPlus_ImageGetGraphicsContext($hBitmap)
_GDIPlus_GraphicsSetSmoothingMode($hBuffer, 2)
_GDIPlus_GraphicsClear($hBuffer, 0xFFF0F0F0)

Local $hPen = _GDIPlus_PenCreate(0xFF0000A0, 2)
Local $hBrush = _GDIPlus_BrushCreateSolid(0xA000A000)

GUISetOnEvent(-3, "_Exit")
Local $mpos, $d, $dx,$dy, $lx, $ly, $cl
Local Const $180_div_pi = 180 / ACos(-1)
Local Const $pi_div_180 = ACos(-1) / 180
Local $lmb = 0
Local $angle = 0
Local $ball_x = 0
Local $ball_y = 0
Local Const $ball_r = 16
Local Const $ball_r2 = $ball_r / 2
Local $fire = 0
Local $power = 2
Local $power_scale = 0
Local Const $max_power = 30
Local Const $gravity = 1
Local Const $max_dist = 350
Local Const $min_dist = 100

While Sleep(30)
    _GDIPlus_GraphicsClear($hBuffer, 0xE0F0F0F0)
    $mpos = MouseGetPos()
	If _IsPressed("01") And $fire = 0 And WinActive($hGUI) Then
		$lmb = 1
		If $power < $max_power Then $power += 1
		_GDIPlus_PenSetWidth($hPen, $power)
		$d = Pixel_Distance(0, $height, $mpos[0], $mpos[1])
		If $d > $max_dist Then
			$angle = ATan(($height - $mpos[1]) / $mpos[0]) * $180_div_pi
			$lx = Cos($angle * $pi_div_180) * $max_dist
			$ly = Sin($angle * $pi_div_180) * $max_dist
			_GDIPlus_GraphicsDrawLine($hBuffer, 0, $height, $lx, $height - $ly, $hPen)
			$ball_x = $lx
			$ball_y = $height - $ly
			$power_scale = 0.005 * $power
			$dx = -$lx * $power_scale
			$dy = $ly * $power_scale
		ElseIf $d < $min_dist Then
			$angle = ATan(($height - $mpos[1]) / $mpos[0]) * $180_div_pi
			$lx = Cos($angle * $pi_div_180) * $min_dist
			$ly = Sin($angle * $pi_div_180) * $min_dist
			_GDIPlus_GraphicsDrawLine($hBuffer, 0, $height, $lx, $height - $ly, $hPen)
			$ball_x = $lx
			$ball_y = $height - $ly
			$power_scale = 0.005 * $power
			$dx = -$lx * $power_scale
			$dy = $ly * $power_scale
		Else
			_GDIPlus_GraphicsDrawLine($hBuffer, 0, $height, $mpos[0], $mpos[1], $hPen)
			$ball_x = $mpos[0]
			$ball_y = $mpos[1]
			$dx = -$mpos[0] * 0.005 * $power
			$dy = ($height - $mpos[1]) * 0.005 * $power
		EndIf
	Else
		If $lmb = 1 Then
			$fire = 1
			$lmb = 0
		EndIf
		$power = 2
		_GDIPlus_PenSetWidth($hPen, $power)
		$d = Pixel_Distance(0, $height, $mpos[0], $mpos[1])
		$angle = ATan(($height - $mpos[1]) / $mpos[0]) * $180_div_pi
		If $d > $max_dist Then
			$lx = Cos($angle * $pi_div_180) * $max_dist
			$ly = Sin($angle * $pi_div_180) * $max_dist
			_GDIPlus_GraphicsDrawLine($hBuffer, 0, $height, $lx, $height - $ly, $hPen)
			$cl = Pixel_Distance(0, $height, $lx, $height - $ly)
		ElseIf $d < $min_dist Then
			$lx = Cos($angle * $pi_div_180) * $min_dist
			$ly = Sin($angle * $pi_div_180) * $min_dist
			_GDIPlus_GraphicsDrawLine($hBuffer, 0, $height, $lx, $height - $ly, $hPen)
			$cl = Pixel_Distance(0, $height, $lx, $height - $ly)
		Else
			_GDIPlus_GraphicsDrawLine($hBuffer, 0, $height, $mpos[0], $mpos[1], $hPen)
			$cl = Pixel_Distance(0, $height, $mpos[0], $mpos[1])
		EndIf
	EndIf
	ToolTip("Canon Angle: " & Int($angle) & "°, Canon Power: " & $power & ", Canon Length: " & Int($cl) & ", Ball x: " & Int($ball_x) & ", Ball y: " & Int($ball_y))
	If $fire Then
		_GDIPlus_GraphicsFillEllipse($hBuffer, $ball_x - $ball_r2, $ball_y - $ball_r2, $ball_r, $ball_r, $hBrush)
		$ball_x -= $dx
		$ball_y -= $dy
		$dy -= $gravity
		If $ball_x > $width Or $ball_y > $height Or $ball_x < -$ball_r Then
			$fire = 0
			$ball_x = 0
			$ball_y = 0
		EndIf
	EndIf
	_GDIPlus_GraphicsDrawString($hBuffer, "Coded by UEZ 2010", $width - 105, $height - 15, "Arial", 8)
    _GDIPlus_GraphicsDrawImage($hGraphics, $hBitmap, 0, 0)
WEnd

Func _Exit()
    _GDIPlus_BrushDispose($hBrush)
    _GDIPlus_PenDispose($hPen)
    _GDIPlus_BitmapDispose($hBitmap)
    _GDIPlus_GraphicsDispose($hBuffer)
    _GDIPlus_Shutdown()
	GUIDelete($hGUI)
    Exit
EndFunc


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