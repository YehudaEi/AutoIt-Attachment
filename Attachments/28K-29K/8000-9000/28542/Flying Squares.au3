;coded by UEZ 2009-01-08
#AutoIt3Wrapper_Run_Obfuscator=y
#Obfuscator_Parameters=/sf /sv /om /cs=0 /cn=0
#AutoIt3Wrapper_UseUpx=n
;~ #AutoIt3Wrapper_Run_After=upx.exe --best "%out%"
#AutoIt3Wrapper_Run_After=upx.exe --ultra-brute "%out%"
#AutoIt3Wrapper_Run_After=del "Flying Squares_Obfuscated.au3"

#include <GuiConstantsEx.au3>
#include <GDIPlus.au3>
Opt('MustDeclareVars', 1)
Global Const $Pi = 4 * ATan(1)
Global Const $width = 400
Global Const $height = 400
Global $hGUI, $hWnd, $hGraphic, $ParticleBitmap, $ParticleBuffer, $hBrush0, $Brush, $hBrush2, $Pen
Global $starting_point, $i, $j, $k, $xcoord, $ycoord, $size, $red, $green, $blue, $start

; Create GUI
$hGUI = GUICreate("GDI+: Flying Squares by UEZ 2009", $width, $height)
$hWnd = WinGetHandle($hGUI)
GUISetState()

_GDIPlus_Startup ()
$hGraphic = _GDIPlus_GraphicsCreateFromHWND ($hWnd) ;create graphic
$ParticleBitmap = _GDIPlus_BitmapCreateFromGraphics($width, $height, $hGraphic) ;create bitmap
$ParticleBuffer = _GDIPlus_ImageGetGraphicsContext($ParticleBitmap) ;create buffer
;~ $Brush = _GDIPlus_BrushCreateSolid(0x7F777777)
$Pen = _GDIPlus_PenCreate(0, 1)
_GDIPlus_GraphicsClear($ParticleBuffer) ;clear buffer

$start = -25
$i = $start
$starting_point = 0
; Loop until user exits
Do
    _GDIPlus_GraphicsClear($ParticleBuffer, 0x7F000000) ;clear buffer
    $k = 256
    $starting_point -= 0.025
    For $j = $k To 0 Step -16; 256 / 16 = 16 squares
		$red = ((Sin(2 ^ 0 * ($j - $i) / 2 ^ 5) + 1) / 2) * 256
		$green = ((Sin(2 ^ 0 * ($j - $i) / 2 ^ 7) + 1) / 2) * 256
		$blue = ((Sin(2 ^ 0 * ($j - $i) / 2 ^ 9) + 1) / 2) * 256
;~ 		$Brush = _GDIPlus_BrushCreateSolid("0x0F" & Hex($red, 2) & Hex($green, 2) & Hex($blue, 2))
		_GDIPlus_PenSetColor($Pen, "0xEF" & Hex($red, 2) & Hex($green, 2) & Hex($blue, 2))
		$size = $i - $j
        $xcoord = $width / 2 - (($i - $j) / 2) + Sin($starting_point) * -Sin(($i - $j) * $Pi / 180) * 64
        $ycoord = $height / 2 - (($i - $j) / 2) + -Cos($starting_point) * Cos(($i - $j) * $Pi / 150) * 32
        _GDIPlus_GraphicsDrawRect($ParticleBuffer, $xcoord, $ycoord, $size, $size, $Pen)
;~         _GDIPlus_GraphicsFillRect($ParticleBuffer, $xcoord, $ycoord, $size, $size, $Brush);filled squares
    Next
;~    _GDIPlus_BrushDispose($Brush)
    _GDIPlus_GraphicsDrawImageRect($hGraphic, $ParticleBitmap, 0, 0, $width, $height) ;copy to bitmap
    $i += 2
    If $i > $k + 2^9 Then $i = $start
    Sleep(20)
Until GUIGetMsg() = $GUI_EVENT_CLOSE

; Clean up resources
_GDIPlus_GraphicsDispose ($hGraphic)
_GDIPlus_BitmapDispose($ParticleBitmap)
_GDIPlus_GraphicsDispose($ParticleBuffer)
;~ _GDIPlus_BrushDispose($Brush)
_GDIPlus_Shutdown ()
Exit
