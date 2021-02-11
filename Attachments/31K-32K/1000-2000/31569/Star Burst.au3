;Idea taken from http://js1k.com/demo/462
;Ported to AutoIt by UEZ Build 2010-08-22
#AutoIt3Wrapper_UseUpx=n
#AutoIt3Wrapper_Run_Obfuscator=y
#Obfuscator_Parameters=/sf /sv /om /cs=0 /cn=0
#AutoIt3Wrapper_Run_After=del /f /q "Star Burst_Obfuscated.au3"
#AutoIt3Wrapper_Run_After=upx.exe --ultra-brute "%out%"
;~ #AutoIt3Wrapper_Run_After=upx.exe --best "%out%"
#include <GDIPlus.au3>
#include <GUIConstantsEx.au3>
Opt("MustDeclareVars", 1)
Opt("GUIOnEventMode", 1)

Local $hGUI, $hGraphics, $hBackbuffer, $hBitmap
Local $iX = 1024, $iY = 768
Local $x2 = $iX * 0.5, $y2 = $iY * 0.5
; Initialize GDI+
_GDIPlus_Startup()

Local $gui_text = "GDI+ Star Burst by UEZ 2010"
$hGUI = GUICreate($gui_text, $iX, $iY)
GUISetState()

$hGraphics = _GDIPlus_GraphicsCreateFromHWND($hGUI)
$hBitmap = _GDIPlus_BitmapCreateFromGraphics($iX, $iY, $hGraphics)
$hBackbuffer = _GDIPlus_ImageGetGraphicsContext($hBitmap)

; Using antialiasing
;~ _GDIPlus_GraphicsSetSmoothingMode($hBackbuffer, 0)


; Create a Brush object
Local $hBrush = _GDIPlus_BrushCreateSolid()
GUISetOnEvent($GUI_EVENT_CLOSE, "_Exit")

Local $pi = ACos(-1), $2pi = 2 * $pi
Local $c = 300
Local $R = 1000
Local $L = 1000
Local $max_pixel = 400
Local $o = 0
Local $i, $j, $K, $xD, $xDD, $yD, $yDD, $red, $green, $blue
Local $r1, $i1, $r2, $i2, $calc1, $calc2
Local $fps = 0, $fps_maintimer, $fps_timer, $fps_diff

$fps_maintimer = TimerInit()
While Sleep(40)
	$fps_timer = TimerInit()
	_GDIPlus_GraphicsClear($hBackbuffer, 0x18000000)
	If ($R * $R + $L * $L) > 2 Then
		$K = Random(0, 1)
		$R = Random(-1, 1) - 1.5
		$L = Random(-1, 1) - 0.5
		$xD = Cos(Random(0, 1) * $2pi) / $c
		$yD = Sin(Random(0, 1) * $2pi) / $c
		$xDD = (Cos(Random(0, 1) * $2pi) / $c - $xD * 0.5) / $c * 10
		$yDD = (Sin(Random(0, 1) * $2pi) / $c - $yD * 0.5) / $c * 10
	EndIf

	$o += 1
	$j = (Cos($o / 100) + 1) * $pi
	$calc1 = $K * $pi + $j
	$calc2 = 0.5 * 0xFF
	$red = Hex((Cos(2 * $calc1) + 1) * $calc2, 2)
	$green = Hex((Sin(4 * $calc1) + 1) * $calc2, 2)
	$blue =  Hex((-Cos(2 * $calc1) + 1) * $calc2, 2)
	_GDIPlus_BrushSetSolidColor($hBrush, "0xFF" & $red & $green & $blue)

	$xD += $xDD
	$yD += $yDD
	$R += $xD
	$L += $yD
	$r1 = $R
	$i1 = $L
	$i = 0
	While Sqrt($r1 * $r1 + $i1 * $i1) < 3 And $i < $max_pixel
		_GDIPlus_GraphicsFillRect($hBackbuffer, $r1 * $x2 + $x2, $i1 * $y2 + $y2, 2, 2, $hBrush)
		$r2 = $r1 * $r1 - $i1 * $i1 + $R
		$i2 = 1.5 * $r1 * $i1 + $L
		$r1 = $r2
		$i1 = $i2
		$i += 1
	WEnd
	_GDIPlus_GraphicsDrawImageRect($hGraphics, $hBitmap, 0, 0, $iX, $iY)

	$fps_diff = TimerDiff($fps_timer)
	If TimerDiff($fps_maintimer) > 999 Then ;calculate FPS
		$fps = Round(1000 / $fps_diff, 2)
		$fps_maintimer = TimerInit()
	EndIf
	WinSetTitle($hGUI, "", $gui_text & "   /   FPS: " & StringFormat("%.2f", $fps))
WEnd


Func _Exit()
	; Clean up
	_GDIPlus_BrushDispose($hBrush)
	_GDIPlus_BitmapDispose($hBitmap)
	_GDIPlus_GraphicsDispose($hBackbuffer)
	_GDIPlus_GraphicsDispose($hGraphics)

	; Uninitialize GDI+
	_GDIPlus_Shutdown()
	Exit
EndFunc