;coded by UEZ 2011 Build 2011-06-04
#AutoIt3Wrapper_Run_Obfuscator=y
#Obfuscator_Parameters=/sf /sv /om /cs=0 /cn=0
#AutoIt3Wrapper_UseX64=n
#AutoIt3Wrapper_UseUpx=y
#AutoIt3Wrapper_UPX_Parameters=--ultra-brute --crp-ms=999999 --all-methods --all-filters
#AutoIt3Wrapper_Run_After=del /f /q "%scriptdir%\%scriptfile%_Obfuscated.au3"
#include <GUIConstantsEx.au3>
#include <GDIPlus.au3>
#include <WindowsConstants.au3>
Opt("GUIOnEventMode", 1)


Global Const $width = 800
Global Const $width2 = $width / 2 - 100
Global Const $height = 600
Global Const $height2 = $height / 2 - 100
Global Const $bs = 20
Global Const $bs2 = $bs / 2
Global Const $max_r = $height * 0.7

Global $hGUI = GUICreate("GDI+ Perfect Illusion by UEZ 2011", $width, $height);, -1, -1, Default, BitOR($WS_EX_TOPMOST, $WS_EX_TOOLWINDOW))
GUISetState()

_GDIPlus_Startup()

Global Const $screens = 8
Global $screen_bitmap[$screens]
Global $screen_context[$screens]
Global Const $hBrush_bg = _GDIPlus_BrushCreateSolid(0xFF101020)
Global Const $hGraphic = _GDIPlus_GraphicsCreateFromHWND($hGUI)

Global Const $iInterpolationMode = 7
Global $i, $j, $m, $r, $dir, $red, $green, $blue, $z = 0

For $i = 0 To $screens - 1
	$screen_bitmap[$i] = _GDIPlus_BitmapCreateFromGraphics($width, $height, $hGraphic)
	$screen_context[$i] = _GDIPlus_ImageGetGraphicsContext($screen_bitmap[$i])
	_GDIPlus_GraphicsFillRect($screen_context[$i], 0, 0, $width, $height, $hBrush_bg)
	DllCall($ghGDIPDll, "uint", "GdipSetInterpolationMode", "handle", $screen_context[$i], "int", $iInterpolationMode)
Next

Global Const $iColor1 = 0xFFFFFFFF
Global $hPath, $hBrush, $aColor[2], $iColor2, $hBmp
$aColor[0] = 1

GUISetOnEvent($GUI_EVENT_CLOSE, "_Exit")

$dir = 1
$i = 0
$j = 0.05
$m = 0
$r = 1

Do
	$red = Hex(((Sin(1 * $z / 1) + 1) / 2) * 0xFF, 2)
    $green = Hex(((Sin(2 * $z / 1) + 1) / 2) * 0xFF, 2)
    $blue = Hex(((Sin(3 * $z / 1) + 1) / 2) * 0xFF, 2)
	$z += 0.01
	$hBmp = CreateGlowingBall($hGraphic, Min($r, 128), $iColor1, "0xB0" & $red & $green & $blue)
	_GDIPlus_GraphicsDrawImageRect($screen_context[$m], $hBmp,  ($width2 - $bs2) - Cos(-$i) * $r, ($height2 - $bs2) - Sin(-$i) * $r, $r, $r)
	_GDIPlus_BitmapDispose($hBmp)
	_GDIPlus_GraphicsDrawImageRect($hGraphic, $screen_bitmap[$m], 0, 0, $width, $height)
	$m = Mod($m + 1, $screens)
	$i += $j
	If $r > $max_r Or $r < 1 Then $dir *= -1
	$r += (0.075 + Sin($i / 3.5) ) * $dir
Until Not Sleep(20)

Func CreateGlowingBall($hGraphics, $iRadius, $iColor1 = 0xFFFFFFFF, $iColor2 = 0xFF00FF00) ; thanks to Eukalyptus for this function ;-)
    Local $hBitmap = _GDIPlus_BitmapCreateFromGraphics($iRadius * 2, $iRadius * 2, $hGraphics)
    Local $hContext = _GDIPlus_ImageGetGraphicsContext($hBitmap)
;~     _GDIPlus_GraphicsSetSmoothingMode($hContext, 2)

	;create glow
    $hPath = DllCall($ghGDIPDll, "uint", "GdipCreatePath", "int", 0, "int*", 0) ;_GDIPlus_PathCreate()
	$hPath =  $hPath[2]
    DllCall($ghGDIPDll, "uint", "GdipAddPathEllipse", "hwnd", $hPath, "float", 0, "float", 0, "float",$iRadius * 2, "float", $iRadius * 2) ;_GDIPlus_PathAddEllipse($hPath, 0, 0, $iRadius * 2, $iRadius * 2)
    $hBrush = DllCall($ghGDIPDll, "uint", "GdipCreatePathGradientFromPath", "hwnd", $hPath, "int*", 0) ;_GDIPlus_PathBrushCreateFromPath($hPath)
	$hBrush = $hBrush[2]
    DllCall($ghGDIPDll, "uint", "GdipSetPathGradientSigmaBlend", "hwnd", $hBrush, "float", 0.4, "float", 0.45) ;_GDIPlus_PathBrushSetSigmaBlend($hBrush, 0.4, 0.45)
    DllCall($ghGDIPDll, "uint", "GdipSetPathGradientCenterColor", "hwnd", $hBrush, "uint", $iColor2) ;_GDIPlus_PathBrushSetCenterColor($hBrush, $iColor2)
     Local $aColor[2] = [1, BitAND($iColor1, 0x00FFFFFF)]
    _GDIPlus_PathBrushSetSurroundColorsWithCount($hBrush, $aColor)
    DllCall($ghGDIPDll, "uint", "GdipDeletePath", "hwnd", $hPath) ;_GDIPlus_PathDispose($hPath)
    _GDIPlus_GraphicsFillEllipse($hContext, 0, 0, $iRadius * 2, $iRadius * 2, $hBrush)
    _GDIPlus_BrushDispose($hBrush)

	;create ball
    $hPath = DllCall($ghGDIPDll, "uint", "GdipCreatePath", "int", 0, "int*", 0) ;_GDIPlus_PathCreate()
	$hPath =  $hPath[2]
    DllCall($ghGDIPDll, "uint", "GdipAddPathEllipse", "hwnd", $hPath, "float", $iRadius / 2, "float", $iRadius / 2, "float", $iRadius, "float", $iRadius) ;_GDIPlus_PathAddEllipse($hPath, $iRadius / 2, $iRadius / 2, $iRadius, $iRadius)
    $hBrush = DllCall($ghGDIPDll, "uint", "GdipCreatePathGradientFromPath", "hwnd", $hPath, "int*", 0) ;_GDIPlus_PathBrushCreateFromPath($hPath)
	$hBrush = $hBrush[2]
    DllCall($ghGDIPDll, "uint", "GdipSetPathGradientSigmaBlend", "hwnd", $hBrush, "float", 1, "float", 0.95) ;_GDIPlus_PathBrushSetSigmaBlend($hBrush, 1, 0.95)
    DllCall($ghGDIPDll, "uint", "GdipSetPathGradientGammaCorrection", "hwnd", $hBrush, "int", True) ;_GDIPlus_PathBrushSetGammaCorrection($hBrush, True)
    _GDIPlus_PathBrushSetCenterPoint($hBrush, $iRadius, $iRadius)
    DllCall($ghGDIPDll, "uint", "GdipSetPathGradientCenterColor", "hwnd", $hBrush, "uint", $iColor1) ;_GDIPlus_PathBrushSetCenterColor($hBrush, $iColor1)
    Local $aColor[2] = [1, $iColor2]
    _GDIPlus_PathBrushSetSurroundColorsWithCount($hBrush, $aColor)
    DllCall($ghGDIPDll, "uint", "GdipDeletePath", "hwnd", $hPath) ;_GDIPlus_PathDispose($hPath)
    _GDIPlus_GraphicsFillEllipse($hContext, $iRadius / 2, $iRadius / 2, $iRadius, $iRadius, $hBrush)
    _GDIPlus_BrushDispose($hBrush)

    _GDIPlus_GraphicsDispose($hContext)

	Return $hBitmap
EndFunc   ;==>CreateGlowingBall

Func _GDIPlus_PathBrushSetCenterPoint($hPathGradientBrush, $nX, $nY)
	Local $pPointF, $tPointF, $aResult
	$tPointF = DllStructCreate("float;float")
	$pPointF = DllStructGetPtr($tPointF)
	DllStructSetData($tPointF, 1, $nX)
	DllStructSetData($tPointF, 2, $nY)
	$aResult = DllCall($ghGDIPDll, "uint", "GdipSetPathGradientCenterPoint", "handle", $hPathGradientBrush, "ptr", $pPointF)
	If @error Then Return SetError(@error, @extended, False)
	Return $aResult[0] = 0
EndFunc   ;==>_GDIPlus_PathBrushSetCenterPoint

Func _GDIPlus_PathBrushSetSurroundColorsWithCount($hPathGradientBrush, $aColors)
	Local $iI, $iCount, $iColors, $tColors, $pColors, $aResult
	$iCount = $aColors[0]
	$iColors = DllCall($ghGDIPDll, "uint", "GdipGetPathGradientPointCount", "hwnd", $hPathGradientBrush, "int*", 0) ;_GDIPlus_PathBrushGetPointCount($hPathGradientBrush)
	If @error Then Return SetError(@error, @extended, False)
	$iColors = $iColors[2]

	$tColors = DllStructCreate("uint[" & $iCount & "]")
	$pColors = DllStructGetPtr($tColors)

	For $iI = 1 To $iCount
		DllStructSetData($tColors, 1, $aColors[$iI], $iI)
	Next
	$aResult = DllCall($ghGDIPDll, "uint", "GdipSetPathGradientSurroundColorsWithCount", "hwnd", $hPathGradientBrush, "ptr", $pColors, "int*", $iCount)
	If @error Then Return SetError(@error, @extended, False)
	Return $aResult[0] = 0
EndFunc   ;==>_GDIPlus_PathBrushSetSurroundColorsWithCount

Func Min($a, $b)
	If $a > $b Then Return $b
	Return $a
EndFunc

Func _Exit()
	_GDIPlus_BrushDispose($hBrush)
	_GDIPlus_BrushDispose($hBrush_bg)
	For $i = 0 To $screens - 1
		_GDIPlus_BitmapDispose($screen_bitmap[$i])
		_GDIPlus_GraphicsDispose($screen_context[$i])
	Next
	_GDIPlus_GraphicsDispose($hGraphic)
	GUIDelete($hGUI)
	_GDIPlus_Shutdown()
	Exit
EndFunc   ;==>_Exit