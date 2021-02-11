;Idea taken from                         
;Ported to AutoIt by UEZ Build 2010-08-24
#AutoIt3Wrapper_UseUpx=n
#AutoIt3Wrapper_Run_Obfuscator=y
#Obfuscator_Parameters=/sf /sv /om /cs=0 /cn=0
#AutoIt3Wrapper_Run_After=del /f /q "Plasma 2_Obfuscated.au3"
#AutoIt3Wrapper_Run_After=upx.exe --ultra-brute "%out%"
;~ #AutoIt3Wrapper_Run_After=upx.exe --best "%out%"
#include <GDIPlus.au3>
#include <GUIConstantsEx.au3>
#include <Array.au3>

Opt("MustDeclareVars", 1)
Opt("GUIOnEventMode", 1)
Opt("MouseCoordMode", 1)

Local $hGUI, $hGraphics, $hBackbuffer, $hBitmap, $hMatrix, $hBuffer, $hContext
Local $w = 0x00000386, $h = 0x00000256
; Initialize GDI+
_GDIPlus_Startup()

Local $GUI_text = "GDI+ Plasma 2 by UEZ 2010"
$hGUI = GUICreate($GUI_text, $w, $h)
GUISetBkColor(0, $hGUI)
GUISetState()

$hGraphics = _GDIPlus_GraphicsCreateFromHWND($hGUI)
$hBitmap = _GDIPlus_BitmapCreateFromGraphics($w, $h, $hGraphics)
$hBackbuffer = _GDIPlus_ImageGetGraphicsContext($hBitmap)
; Using antialiasing
;~ _GDIPlus_GraphicsSetSmoothingMode($hBackbuffer, 2)


; Create a Brush object
Local $hBrush = _GDIPlus_BrushCreateSolid()

GUISetOnEvent($GUI_EVENT_CLOSE, "_Exit")

Local Const $pi = ACos(0xFFFFFFFF)
Local $t = 0x00000000
Local $val = 0x00000000
Local $a, $b, $c, $d, $i, $j, $k
Local $r, $g, $b, $fps = 0x00000000
Local Const $r1 = Random(0.5, 1.5)
Local Const $r2 = Random(0.5, 1.5)
Local Const $w3 = $w / 0x00000003
Local Const $r1_10 = $r1 / 0x0000000A
Local Const $ii = 0x0000023, $jj = 0x00000019
Local Const $w_ii = $w / $ii
Local Const $h_jj = $h / $jj
Local Const $r1_17 = $r1 / 0x00000011
Local Const $r2_17 = $r2 / 0x00000011

AdlibRegister("FPS", 1000)

While Sleep(20)
;~ 	_GDIPlus_GraphicsClear($hBackbuffer, 0x00000000)

	$t += 0.04
	For $i = 0 To $ii
		For $j = 0 To $jj
			$a = Sin(Cos(-$t) * $i * $r1_17)
			$b = -Cos(Sin($t) * $j * $r2_17)
			$c = $w3 + Cos($t * $pi)
			$k = Cos($r1_10)
			$d = $h + $k * $k / 0x0000001E
			$val = Sin(dist($a, $b, $c, $d)) + 0x00000001 - (Log($t * $pi)) + Cos($r2) / 0x0000001E
			$r = Hex(n256(Sin($pi * $val * 0x00000002)), 0x00000002)
			$g = Hex(n256(Sin($pi * $val)), 0x00000002)
			$b = Hex(n256(Sin($pi * $val / 0x00000002)), 0x00000002)
			_GDIPlus_BrushSetSolidColor($hBrush, "0xFF" & $r & $g & $b)
			_GDIPlus_GraphicsFillRect($hBackbuffer, $i * $w_ii, $j * $h_jj, $i + $w_ii, $j + $h_jj, $hBrush)
;~ 			_GDIPlus_GraphicsFillRect($hBackbuffer, Random(-1, 16) + $i * $w_ii, Random(-1, 16) + $j * $h_jj, $i + $w_ii, $j + $h_jj, $hBrush)
		Next
	Next

	_GDIPlus_GraphicsDrawImageRect($hGraphics, $hBitmap, 0x00000000, 0x00000000, $w, $h)
	$fps += 0x00000001
WEnd

Func n256($x)
	$x = ($x + 1) / 2
	Return 0x00000100 * $x
EndFunc

Func dist($a, $b, $c, $d)
	Local $ac = $a - $c, $bd = $b - $d
	Return Sqrt($ac * $ac + $bd * $bd)
EndFunc

Func FPS()
	WinSetTitle($hGUI, "", $GUI_text & "  /  FPS: " & $fps)
	$fps = 0x00000000
EndFunc

Func _Exit()
	AdlibUnRegister("FPS")
	; Clean up
	_GDIPlus_BrushDispose($hBrush)
	_GDIPlus_BitmapDispose($hBitmap)
	_GDIPlus_GraphicsDispose($hBackbuffer)
	_GDIPlus_GraphicsDispose($hGraphics)

	; Uninitialize GDI+
	_GDIPlus_Shutdown()
	Exit
EndFunc