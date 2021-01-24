;coded by UEZ 2009-01-12
#AutoIt3Wrapper_Run_Obfuscator=y
#Obfuscator_Parameters=/SO
#AutoIt3Wrapper_UseUpx=n
#AutoIt3Wrapper_Run_After=upx.exe --best "%out%"
#include <GuiConstantsEx.au3>
#include <GDIPlus.au3>
Opt('MustDeclareVars', 1)
Global Const $Pi = 3.1415926535897932384626
Global Const $width = @DesktopWidth / 2
Global Const $height = @DesktopHeight / 2
Global $hGUI, $hGraphic, $Bitmap, $GDI_Buffer, $Pen, $Brush
Global $i, $j, $k, $xcoord, $ycoord, $red, $green, $blue
Global $x1, $x2, $x3, $x4, $y1, $y2, $y3, $y4

$hGUI = GUICreate("GDI+: Rotating Squares by UEZ 2009", $width, $height)
GUISetState(@SW_SHOW)

_GDIPlus_Startup ()
$hGraphic = _GDIPlus_GraphicsCreateFromHWND ($hGUI) ;create graphic
$Bitmap = _GDIPlus_BitmapCreateFromGraphics($width, $height, $hGraphic) ;create bitmap
$GDI_Buffer = _GDIPlus_ImageGetGraphicsContext($Bitmap) ;create buffer
$Pen = _GDIPlus_PenCreate(0, 2)
$Brush = _GDIPlus_BrushCreateSolid(0xFF000000)
_GDIPlus_GraphicsSetSmoothingMode($GDI_Buffer, 4)

_GDIPlus_GraphicsClear($GDI_Buffer)
$i = 1
Do
;~     _GDIPlus_GraphicsClear($GDI_Buffer) ;clear buffer
	_GDIPlus_GraphicsFillEllipse($GDI_Buffer, $width / 2 - $k,  $height / 2 - $k, 2 * $k, 2 * $k, $Brush) ;clear only area where the squares are drawn
	If $k <= 3 * $width / 7  Then $k += 1
    For $j = 8 To $k Step 24 + Cos($i * $Pi / 60) * 12
        $red = ((Sin(2^0 * ($j - $i) / 2^5) + 1) / 2) * 256
        $green = ((Sin(2^0 * ($j - $i) / 2^7) + 1) / 2) * 256
        $blue = ((Sin(2^0 * ($j - $i) / 2^9) + 1) / 2) * 256
		_GDIPlus_PenSetColor($Pen, "0xEF" & Hex($red, 2) & Hex($green, 2) & Hex($blue, 2)) ;Set the pen color
        $xcoord = $j ;+ Sin($i * $Pi / 60) * 8
        $ycoord = $j ;+ Cos($i * $Pi / 60) * 8
        Square($xcoord, $ycoord, $j * Sin($i / $k * $Pi * 4) * 2 / 3)
    Next
    _GDIPlus_GraphicsDrawImageRect($hGraphic, $Bitmap, 0, 0, $width, $height) ;copy to bitmap
    $i += 1.5
	Sleep(30)
Until GUIGetMsg() = $GUI_EVENT_CLOSE

; Clean up resources
_GDIPlus_PenDispose($Pen)
_GDIPlus_BitmapDispose($Bitmap)
_GDIPlus_GraphicsDispose($GDI_Buffer)
_GDIPlus_GraphicsDispose ($hGraphic)
_GDIPlus_Shutdown ()


Func Square($xx1, $yy1, $i)
	Local $degree
	$degree = 45
    $x1 = $xx1 * Cos(($i + $degree + 0) * $Pi / 180) + $width / 2
    $y1 = $yy1 * Sin(($i + $degree + 0) * $Pi / 180) + $height / 2
    $x2 = $xx1 * Cos(($i + $degree + 90) * $Pi / 180) + $width / 2
    $y2 = $yy1 * Sin(($i + $degree + 90) * $Pi / 180) + $height / 2
    $x3 = $xx1 * Cos(($i + $degree + 180) * $Pi / 180) + $width / 2
    $y3 = $yy1 * Sin(($i + $degree + 180) * $Pi / 180) + $height / 2
    $x4 = $xx1 * Cos(($i + $degree + 270) * $Pi / 180) + $width / 2
    $y4 = $yy1 * Sin(($i + $degree + 270) * $Pi / 180) + $height / 2
    _GDIPlus_GraphicsDrawLine($GDI_Buffer, $x1, $y1, $x2, $y2, $Pen)
    _GDIPlus_GraphicsDrawLine($GDI_Buffer, $x2, $y2, $x3, $y3, $Pen)
    _GDIPlus_GraphicsDrawLine($GDI_Buffer, $x3, $y3, $x4, $y4, $Pen)
    _GDIPlus_GraphicsDrawLine($GDI_Buffer, $x4, $y4, $x1, $y1, $Pen)
EndFunc
