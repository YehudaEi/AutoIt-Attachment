;coded by UEZ 2009
#AutoIt3Wrapper_UseUpx=n
#AutoIt3Wrapper_Run_After=upx.exe --best "%out%"
#AutoIt3Wrapper_Run_Obfuscator=y
#Obfuscator_Parameters=/SO
#include <GDIPlus.au3>
#include <WindowsConstants.au3>
#include <Array.au3>

Opt("GUIOnEventMode", 1)
Opt("MouseCoordMode", 1)

Global Const $Width = 800
Global Const $Height = 600

Global $hwnd = GUICreate("Rotating Cube by UEZ 2009", $Width, $Height)
GUISetOnEvent(-3, "Close")
GUISetState()

_GDIPlus_Startup()
Global $graphics = _GDIPlus_GraphicsCreateFromHWND($hwnd)
Global $bitmap = _GDIPlus_BitmapCreateFromGraphics($Width, $Height, $graphics)
Global $backbuffer = _GDIPlus_ImageGetGraphicsContext($bitmap)
_GDIPlus_GraphicsClear($backbuffer)
_GDIPlus_GraphicsSetSmoothingMode($backbuffer, 4)

Global $amout_of_balls, $ball_distance
Global $a, $j, $n, $m, $x, $y, $z, $mx, $my, $size, $start_x, $start_y, $mouse_sense, $r, $g, $b
Global Const $Pi =  4 * ATan(1)
Global Const $Pi_Div_180 = $Pi / 180

$amout_of_balls = 3 ^ 3 ;amount of balls
$ball_distance = 128 ;ball distance between balls to each other

$mouse_sense = 75 ;higher = more sensitive
$n = 800 ;z depth ratio -> lower means deeper z
$m = -1 * $n / 120
$start_x = $Width / 1.750 ;center x position
$start_y = $Height / 1.675 ;;center y position

Global $draw_coordinates[$amout_of_balls][4]
Global $calc_coordinates[$amout_of_balls][3] = [[-$ball_distance, 	-$ball_distance, 	-$ball_distance	], _
												[0, 				-$ball_distance, 	-$ball_distance	], _
												[$ball_distance, 	-$ball_distance, 	-$ball_distance	], _
												[-$ball_distance, 	0, 					-$ball_distance	], _
												[0, 				0, 					-$ball_distance	], _
												[$ball_distance, 	0, 					-$ball_distance	], _
												[-$ball_distance, 	$ball_distance, 	-$ball_distance	], _
												[0, 				$ball_distance, 	-$ball_distance	], _
												[$ball_distance, 	$ball_distance, 	-$ball_distance	], _
												[-$ball_distance, 	-$ball_distance, 	0				], _
												[0, 				-$ball_distance, 	0				], _
												[$ball_distance, 	-$ball_distance, 	0				], _
												[-$ball_distance, 	0, 					0				], _
												[0, 				0, 					0				], _
												[$ball_distance, 	0, 					0				], _
												[-$ball_distance, 	$ball_distance, 	0				], _
												[0, 				$ball_distance, 	0				], _
												[$ball_distance, 	$ball_distance, 	0				], _
												[-$ball_distance, 	-$ball_distance, 	$ball_distance	], _
												[0, 				-$ball_distance, 	$ball_distance	], _
												[$ball_distance, 	-$ball_distance, 	$ball_distance	], _
												[-$ball_distance, 	0, 					$ball_distance	], _
												[0, 				0, 					$ball_distance	], _
												[$ball_distance, 	0, 					$ball_distance	], _
												[-$ball_distance, 	$ball_distance, 	$ball_distance	], _
												[0, 				$ball_distance, 	$ball_distance	], _
												[$ball_distance, 	$ball_distance, 	$ball_distance	]]

Global $k

For $k = 0 To $amout_of_balls - 1
	$draw_coordinates[$k][3] = _GDIPlus_CreateLineBrushFromRect(1500, 500, 800, 750, -1, -1, 0xFF5555FF, 0xD0F0F0F7, 0x00000002, 3)
Next

$pen = _GDIPlus_PenCreate(0x8FAAAAAF, 1) ;color of the outer circle border

$pen2 = _GDIPlus_PenCreate(0x50FFFFFF, 4)

$j = 0

Do
	_GDIPlus_GraphicsClear($backbuffer, 0xEFFFFFFF) ;clear screen
	$mouse_pos = MouseGetPos()
	Do
		Calc(-(-@DesktopHeight / 2 + $mouse_pos[1]) / $mouse_sense, (-@DesktopWidth / 2 + $mouse_pos[0]) / $mouse_sense, $j) ;calculate new coordinates of balls
		$j += 1
	Until $j = $amout_of_balls
	$j = 0
	Draw() ;draw to screen
	_GDIPlus_GraphicsDrawImageRect($graphics, $bitmap, 0, 0, $Width, $Height) ;copy to display screen
Until Not Sleep(30)

Func Calc($mx, $my, $i) ;calculate rotation depending on mouse movement
	$x = ($calc_coordinates[$i][0] * Cos($my * $Pi_Div_180)) + ($calc_coordinates[$i][2] * Sin($my * $Pi_Div_180))
	$y = $calc_coordinates[$i][1]
	$z = (-$calc_coordinates[$i][0] * Sin($my * $Pi_Div_180)) + ($calc_coordinates[$i][2] * Cos($my * $Pi_Div_180))
	$calc_coordinates[$i][0] = $x
	$calc_coordinates[$i][1] = ($y * Cos($mx * $Pi_Div_180)) - ($z * Sin($mx * $Pi_Div_180))
	$calc_coordinates[$i][2] = ($y * Sin($mx * $Pi_Div_180)) + ($z * Cos($mx * $Pi_Div_180))
	$draw_coordinates[$i][0] = $calc_coordinates[$i][0] ;duplicate for draw operation
	$draw_coordinates[$i][1] = $calc_coordinates[$i][1]
	$draw_coordinates[$i][2] = $calc_coordinates[$i][2]
EndFunc   ;==>Calc

Func Draw()
	_ArraySort($draw_coordinates, 0, 0, $amout_of_balls, 2); sort z axis for depth -> smaller balls are in the background
	For $a = 0 To $amout_of_balls - 1
		$size = ($draw_coordinates[$a][2] + $n) / $m ;calculate size of balls (z axis)
		$r = 0xFF * -Cos(0.25 * $size / 8 * $Pi_Div_180)
		$g = 0xFF * Cos(1.90 * $size / 8 * $Pi_Div_180)
		$b = 0xFF * -Sin(0.90 * $size / 8 * $Pi_Div_180)
		$c = "0xEF" & Hex($r, 2) & Hex($g, 2) & Hex($b, 2)
		_GDIPlus_SetLineColors($draw_coordinates[$a][3], $c, 0xD0F0F0F7)
		_GDIPlus_GraphicsFillEllipse($backbuffer, $start_x + $draw_coordinates[$a][0], $start_y + $draw_coordinates[$a][1], $size, $size, $draw_coordinates[$a][3]) ;filled circle
		_GDIPlus_GraphicsDrawArc ($backbuffer, $start_x + $draw_coordinates[$a][0] - Abs($size) + 40, $start_y + $draw_coordinates[$a][1] - Abs($size) + 20, Abs($size / 2), Abs($size / 2), 10, -90, $pen2) ;try to give balls a 3D look
		_GDIPlus_GraphicsDrawArc ($backbuffer, $start_x + $draw_coordinates[$a][0] - Abs($size) + 25, $start_y + $draw_coordinates[$a][1] - Abs($size) + 40, Abs($size / 2), Abs($size / 2), -210, -45, $pen2) ;try to give balls a 3D look
		_GDIPlus_GraphicsDrawEllipse($backbuffer, $start_x + $draw_coordinates[$a][0], $start_y + $draw_coordinates[$a][1], $size, $size, $pen) ;outer boarder
	Next
EndFunc   ;==>Draw

Func _GDIPlus_BrushSetSolidColor($hBrush, $iARGB = 0xFF000000)
	Local $aResult
	$aResult = DllCall($ghGDIPDll, "int", "GdipSetSolidFillColor", "hwnd", $hBrush, "int", $iARGB)
	If @error Then Return SetError(@error, @extended, 0)
	Return SetError($aResult[0], 0, $aResult[0] = 0)
EndFunc   ;==>_GDIPlus_BrushSetSolidColor

Func _GDIPlus_CreateLineBrushFromRect($iX, $iY, $iWidth, $iHeight, $aFactors, $aPositions, $iArgb1 = 0xFF0000FF, $iArgb2 = 0xFFFF0000, $LinearGradientMode = 0x00000001, $WrapMode = 0)
	Local $tRect, $pRect, $aRet, $tFactors, $pFactors, $tPositions, $pPositions, $iCount

	If $iArgb1 = -1 Then $iArgb1 = 0xFF0000FF
	If $iArgb2 = -1 Then $iArgb2 = 0xFFFF0000
	If $LinearGradientMode = -1 Then $LinearGradientMode = 0x00000001
	If $WrapMode = -1 Then $WrapMode = 1

	$tRect = DllStructCreate("float X;float Y;float Width;float Height")
	$pRect = DllStructGetPtr($tRect)
	DllStructSetData($tRect, "X", $iX)
	DllStructSetData($tRect, "Y", $iY)
	DllStructSetData($tRect, "Width", $iWidth)
	DllStructSetData($tRect, "Height", $iHeight)

	;Note: Withn _GDIPlus_Startup(), $ghGDIPDll is defined
	$aRet = DllCall($ghGDIPDll, "int", "GdipCreateLineBrushFromRect", "ptr", $pRect, "int", $iArgb1, _
			"int", $iArgb2, "int", $LinearGradientMode, "int", $WrapMode, "int*", 0)

	If IsArray($aFactors) = 0 Then Dim $aFactors[4] = [0.0, 0.4, 0.6, 1.0]
	If IsArray($aPositions) = 0 Then Dim $aPositions[4] = [0.0, 0.3, 0.7, 1.0]

	$iCount = UBound($aPositions)
	$tFactors = DllStructCreate("float[" & $iCount & "]")
	$pFactors = DllStructGetPtr($tFactors)
	For $iI = 0 To $iCount - 1
		DllStructSetData($tFactors, 1, $aFactors[$iI], $iI + 1)
	Next
	$tPositions = DllStructCreate("float[" & $iCount & "]")
	$pPositions = DllStructGetPtr($tPositions)
	For $iI = 0 To $iCount - 1
		DllStructSetData($tPositions, 1, $aPositions[$iI], $iI + 1)
	Next

	$hStatus = DllCall($ghGDIPDll, "int", "GdipSetLineBlend", "hwnd", $aRet[6], _
			"ptr", $pFactors, "ptr", $pPositions, "int", $iCount)
	Return $aRet[6] ; Handle of Line Brush
EndFunc   ;==>GDIPlus_CreateLineBrushFromRect


; Description:  Creates a LinearGradientBrush object from a set of boundary points and boundary colors.
; Parameters:
; $iPoint1X, $iPoint1Y -  [in] x,y co-ordinates of a PointF object that specifies the starting point
;                        of the gradient.     The starting boundary line passes through the starting point.
; $iPoint2X, $iPoint2Y -  [in] x,y co-ordinates of a  PointF object that specifies the ending point of the
;                         gradient.  The ending boundary line passes through the ending point.
; $iArgb1              -  [in] ARGB color that specifies the color at the starting boundary line of this
;                        linear gradient brush.
; $iArgb2              -  [in] ARGB color object that specifies the color at the ending boundary line of
;                        this linear gradient brush.
; $WrapMode            -  [in] A member of the WrapMode enumeration that specifies how areas filled with
;                        the brush are tiled.
; $aRet[6] is the lineGradient [out] Pointer to a variable that receives a pointer (Handle)to the new
;                           created LinearGradientBrush object.
; GdipCreateLineBrush(GDIPCONST GpPointF* point1, GDIPCONST GpPointF* point2, ARGB color1, ARGB color2,
;                                                  GpWrapMode wrapMode, GpLineGradient **lineGradient)
; Reference:  http://msdn.microsoft.com/en-us/library/ms534043(VS.85).aspx
Func _GDIPlus_CreateLineBrush($iPoint1X, $iPoint1Y, $iPoint2X, $iPoint2Y, $iArgb1 = 0xFF0000FF, $iArgb2 = 0xFFFF0000, $WrapMode = 0)

    Local $tPoint1, $pPoint1, $tPoint2, $pPoint2, $aRet, $res

    If $iArgb1 = "" Then $iArgb1 = 0xFF0000FF
    If $iArgb2 = "" Then $iArgb2 = 0xFFFF0000
    If $WrapMode = -1 Then $WrapMode = 0

    $tPoint1 = DllStructCreate("float X;float Y")
    $pPoint1 = DllStructGetPtr($tPoint1)
    DllStructSetData($tPoint1, "X", $iPoint1X)
    DllStructSetData($tPoint1, "Y", $iPoint1Y)

    $tPoint2 = DllStructCreate("float X;float Y")
    $pPoint2 = DllStructGetPtr($tPoint2)
    DllStructSetData($tPoint2, "X", $iPoint2X)
    DllStructSetData($tPoint2, "Y", $iPoint2Y)
    ;Note: Withn _GDIPlus_Startup(), $ghGDIPDll is defined
    $aRet = DllCall($ghGDIPDll, "int", "GdipCreateLineBrush", "ptr", $pPoint1, "ptr", $pPoint2, "int", $iArgb1, "int", $iArgb2, "int", $WrapMode, "int*", 0)
    Return $aRet[6]
EndFunc   ;==>GDIPlus_CreateLineBrush

; Description - Sets the starting color and ending color of this linear gradient brush.
; $hBrush     - Handle of existing LineBrush
; $iArgb1,  $iArgb2 are the colours to change to in 0xAARRGGBB hex colour format.
Func _GDIPlus_SetLineColors($hBrush, $iArgb1, $iArgb2)
    Local $hStatus
    $hStatus = DllCall($ghGDIPDll, "int", "GdipSetLineColors", "hwnd", $hBrush, "int", $iArgb1, "int", $iArgb2)
    Return
EndFunc   ;==>_GDIPlus_SetLineColors

Func Close()
	_GDIPlus_PenDispose($pen)
	_GDIPlus_PenDispose($pen2)
	For $a = 0 To $amout_of_balls - 1
		_GDIPlus_BrushDispose($draw_coordinates[$a][3])
	Next
	_GDIPlus_BitmapDispose($bitmap)
	_GDIPlus_GraphicsDispose($graphics)
	_GDIPlus_GraphicsDispose($backbuffer)
	_GDIPlus_Shutdown()
	Exit
EndFunc   ;==>Close
