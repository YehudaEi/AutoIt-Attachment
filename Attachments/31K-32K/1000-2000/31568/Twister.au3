;Idea taken from http://js1k.com/demo/213
;Ported to AutoIt by UEZ 2010
#AutoIt3Wrapper_UseUpx=n
#AutoIt3Wrapper_Run_Obfuscator=y
#Obfuscator_Parameters=/sf /sv /om /cs=0 /cn=0
#AutoIt3Wrapper_Run_After=del /f /q "Twister_Obfuscated.au3"
#AutoIt3Wrapper_Run_After=upx.exe --ultra-brute "%out%"
;~ #AutoIt3Wrapper_Run_After=upx.exe --best "%out%"

#include <GuiConstantsEx.au3>
#include <WindowsConstants.au3>
#include <GDIPlus.au3>
Opt("MustDeclareVars", 1)
Opt("GUIOnEventMode", 1)
Local $hWnd, $hGraphic, $hBitmap, $hBackbuffer, $hBrush
Local $hFormat, $hFamily, $hFont, $tLayout, $aInfo, $hBrush_Font
Local $fps = 0, $fps_maintimer, $fps_timer, $fps_diff

Local $width = 80, $height = 250
Local $gui_text = "Twister"
Local $pi = ACos(-1)

_GDIPlus_Startup()
Local $win_x = 3 * $width
Local $win_x_d = $win_x / 3
$hWnd = GUICreate($gui_text, $win_x, $height)
GUISetBkColor(0)
GUISetState()

$hGraphic = _GDIPlus_GraphicsCreateFromHWND($hWnd)
$hBitmap = _GDIPlus_BitmapCreateFromGraphics($width, $height, $hGraphic)
$hBackbuffer = _GDIPlus_ImageGetGraphicsContext($hBitmap)
_GDIPlus_GraphicsSetSmoothingMode($hBackbuffer, 2)
$hBrush = _GDIPlus_BrushCreateSolid(0)

$hBrush_Font = _GDIPlus_BrushCreateSolid(0xFF7070F0)
$hFormat = _GDIPlus_StringFormatCreate ()
$hFamily = _GDIPlus_FontFamilyCreate ("Arial")
$hFont = _GDIPlus_FontCreate ($hFamily, 11, 1)
$tLayout = _GDIPlus_RectFCreate (1, 12, 0, 0)
$aInfo = _GDIPlus_GraphicsMeasureString ($hGraphic, "", $hFont, $tLayout, $hFormat)

Local $pi2 = 2 * $pi
Local $STEPS = 15
Local $iteration = 0
Local $speed = 4
Local $yMin[$height +  1], $yMax[$height + 1]
Local $i, $min, $max, $previousX, $twist, $step, $angle, $radius, $x, $r

For $i = 0 To $height - 1
	$yMin[$i] = $width
	$yMax[$i] = 0
Next

GUISetOnEvent($GUI_EVENT_CLOSE, "_Exit")

$fps_maintimer = TimerInit()
Do
	$fps_timer = TimerInit()

	_GDIPlus_GraphicsClear($hBackbuffer, 0xFF000000)
	$iteration += 0.05
	For $y = 0 To $height - 1 Step $speed
;~ 		$min = $width
;~ 		$max = 0
;~ 		$previousX = $width
		$twist = $iteration + 10 * Cos($iteration) * ($y / $height)
		For $step = 0 To $STEPS
			$angle = $pi * $step / $STEPS
			$radius = Cos($angle)
			$radius = (1 - 0.4 * $radius * $radius)
;~ 			$x = ($width + $width * Cos($angle + $twist) * $radius) * 0.5
			$x = BitShift($width + $width * Cos($angle + $twist) * $radius, 1)
			If $previousX < $x Then
				$r = 255 * $radius
;~ 				If Mod($step, 3) Then
;~ 					Line($previousX, $x, $y, $r, $r)
;~ 				Else
					Line($previousX, $x, $y, $r)
;~ 				EndIf
			EndIf
			$previousX = $x
			If $x < $min Then $min = $x
			If $x > $max Then $max = $x
		Next
	Next
;~ 	Line($yMin[$y], $min, $y)
;~ 	Line($max, $yMin[$y], $y)
;~ 	$yMin[$y] = $min
;~ 	$yMax[$y] = $max
;~ 	_GDIPlus_GraphicsDrawStringEx($hBackbuffer, "FPS: " & StringFormat("%.2f", $fps), $hFont, $aInfo[0], $hFormat, $hBrush_Font)
	_GDIPlus_GraphicsDrawImageRect($hGraphic, $hBitmap, $win_x_d, 0, $width, $height)

	$fps_diff = TimerDiff($fps_timer)
	If TimerDiff($fps_maintimer) > 999 Then ;calculate FPS
		$fps = Round(1000 / $fps_diff, 2)
		$fps_maintimer = TimerInit()
	EndIf
	WinSetTitle($hWnd, "", $gui_text & "   /   FPS: " & StringFormat("%.2f", $fps))
Until 0

Func Line($x1, $x2, $y, $r = 0, $gb = 0)
	Local $z = 0, $color
	While $x1 < $x2
		If $z < 3 Then
			$color = 0xFF000000
;~ 			_GDIPlus_BrushSetSolidColor($hBrush, 0x80000000)
		Else
			$color = 0xFF000000 + $r * 0x10000 + $gb * 0x100 + $gb
;~ 			_GDIPlus_BrushSetSolidColor($hBrush, $color)
		EndIf
;~ 		_GDIPlus_GraphicsFillRect($hBackbuffer, $x1, $y, 4, 4, $hBrush)
		_GDIPlus_BitmapSetPixel($hBitmap, $x1, $y, $color)
		$z += $speed - 1
		$x1 += 1
	WEnd
EndFunc

Func _Exit()
    _GDIPlus_FontDispose ($hFont)
    _GDIPlus_FontFamilyDispose ($hFamily)
    _GDIPlus_StringFormatDispose ($hFormat)
	_GDIPlus_BrushDispose($hBrush)
	_GDIPlus_BrushDispose($hBrush_Font)
	_GDIPlus_BitmapDispose($hBitmap)
	_GDIPlus_GraphicsDispose($hBackbuffer)
    _GDIPlus_GraphicsDispose($hGraphic)
    _GDIPlus_Shutdown()
	GUIDelete($hWnd)
    Exit
EndFunc   ;==>_Exit

Func _GDIPlus_BitmapSetPixel($hBitmap, $iX, $iY, $iARGB = 0xFFFFFFFF)
	Local $aRet
	$aRet = DllCall($ghGDIPDll, "int", "GdipBitmapSetPixel", "hwnd", $hBitmap, "int", $iX, "int", $iY, "dword", $iARGB)
	Return
EndFunc   ;==>_GDIPlus_BitmapSetPixel