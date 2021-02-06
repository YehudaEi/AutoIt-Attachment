;coded by UEZ 2009-01-09 - thanks to smashly for _GDIPlus_BrushSetSolidColor() function :-)
#AutoIt3Wrapper_Run_Obfuscator=y
#Obfuscator_Parameters=/sf /sv /om /cs=0 /cn=0
#AutoIt3Wrapper_UseUpx=n
;~ #AutoIt3Wrapper_Run_After=upx.exe --best "%out%"
#AutoIt3Wrapper_Run_After=upx.exe --ultra-brute "%out%"
#AutoIt3Wrapper_Run_After=del "Flying Pearl Necklaces_Obfuscated.au3"

#include <GuiConstantsEx.au3>
#include <GDIPlus.au3>
Opt('MustDeclareVars', 1)
Opt("GUIOnEventMode", 1)

Global Const $Pi = 4 * ATan(1)
Global Const $width = 400
Global Const $height = $width
Global $hGUI, $Graphic, $ParticleBitmap, $ParticleBuffer, $Brush1, $Brush2
Global $starting_point, $i, $j, $k, $l, $xcoord1, $ycoord1, $xcoord2, $ycoord2, $size, $red, $green, $blue, $min_size
Global $pi_div_90 = $Pi / 90, $pi_div_120 = $Pi / 120, $pi_div_75 = $Pi / 75
$hGUI = GUICreate("GDI+: Flying Pearl Necklaces by UEZ 2009", $width, $height)
GUISetOnEvent($GUI_EVENT_CLOSE, "Close")
GUISetState(@SW_SHOW)

_GDIPlus_Startup ()
$Graphic = _GDIPlus_GraphicsCreateFromHWND ($hGUI) ;create graphic
$ParticleBitmap = _GDIPlus_BitmapCreateFromGraphics($width, $height, $Graphic) ;create bitmap
$ParticleBuffer = _GDIPlus_ImageGetGraphicsContext($ParticleBitmap) ;create buffer
_GDIPlus_GraphicsSetSmoothingMode($ParticleBuffer, 4) ;Antialiasing
_GDIPlus_GraphicsClear($ParticleBuffer) ;clear buffer
$Brush1 = _GDIPlus_BrushCreateSolid(0)
$Brush2 = _GDIPlus_BrushCreateSolid(0)

$i = -650
$l = $i
$starting_point = 0
$min_size = 13
Do
    _GDIPlus_GraphicsClear($ParticleBuffer, 0xFFFFFFFF) ;clear buffer
    $k = 4096 ;2^12
    $starting_point -= 0.05
    For $j = 0 To $k Step 32
        $red = ((Sin(($i + $j) * 0.001953125) + 1) * 0.5) * 256 ;2/1024=0.001953125
        $green = ((Sin(($i + $j) * 0.0078125) + 1) * 0.5) * 256 ;4/512=0.0078125
        $blue = ((Sin(($i + $j) * 0.03125) + 1) * 0.5) * 256 ;8/256=0.03125
        _GDIPlus_BrushSetSolidColor($Brush1, "0xCF" & Hex($red, 2) & Hex($green, 2) & Hex($blue, 2))
        _GDIPlus_BrushSetSolidColor($Brush2, "0xCF" & Hex($blue, 2) & Hex($red, 2) & Hex($green, 2))
		$size = $i - $j
		If $size > -$min_size And $size < $min_size Then $size = $min_size
        $xcoord1 = $width / 2 - (($i - $j) * 0.5) + Sin($starting_point) * -Sin(($i - $j) * $pi_div_90) * 64
        $ycoord1 = $height / 2 - (($i - $j) * 0.5) + -Cos($starting_point) * Cos(($i - $j) * $pi_div_90) * 32
		_GDIPlus_GraphicsFillEllipse($ParticleBuffer, $xcoord1, $ycoord1, $size * 0.166666666, $size * 0.166666666, $Brush1)
        $xcoord2 = $width / 2 - (-($i - $j) / -1.75) - Sin($starting_point) * Sin(($i - $j) * $pi_div_120) * 32
        $ycoord2 = $height / 2 - (($i - $j) / -1.75) - Cos($starting_point) * Cos(($i - $j) * $pi_div_75) * 16
        _GDIPlus_GraphicsFillEllipse($ParticleBuffer, $xcoord2, $ycoord2, $size * 0.125 , $size * 0.125, $Brush2)
    Next
    _GDIPlus_GraphicsDrawImageRect($Graphic, $ParticleBitmap, 0, 0, $width, $height) ;copy to bitmap
    $i += 3
    If $i > $k + Abs($l) Then $i = $l
Until Not Sleep(30)

Func Close(); Clean up resources
	_GDIPlus_BrushDispose($Brush1)
	_GDIPlus_BrushDispose($Brush2)
	_GDIPlus_GraphicsDispose ($Graphic)
	_GDIPlus_BitmapDispose($ParticleBitmap)
	_GDIPlus_GraphicsDispose($ParticleBuffer)
	_GDIPlus_Shutdown ()
	Exit
EndFunc
