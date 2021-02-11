;Idea taken from http://js1k.com/demo/173
;Ported to AutoIt by UEZ Build 2010-08-22
#AutoIt3Wrapper_UseUpx=n
#AutoIt3Wrapper_Run_Obfuscator=y
#Obfuscator_Parameters=/sf /sv /om /cs=0 /cn=0
#AutoIt3Wrapper_Run_After=del /f /q "Warp Starfield_Obfuscated.au3"
#AutoIt3Wrapper_Run_After=upx.exe --ultra-brute "%out%"
;~ #AutoIt3Wrapper_Run_After=upx.exe --best "%out%"
#include <GDIPlus.au3>
#include <GUIConstantsEx.au3>
Opt("MustDeclareVars", 1)
Opt("GUIOnEventMode", 1)
Opt("MouseCoordMode", 0)

Local $hGUI, $hGraphics, $hBackbuffer, $hBitmap
Local $W = 1024, $H = 768
Local $W2 = $W * 0.5, $H2 = $H * 0.5
; Initialize GDI+
_GDIPlus_Startup()

Local $gui_text = "GDI+ Warp Starfield by UEZ 2010"
$hGUI = GUICreate($gui_text, $W, $H)
GUISetState()

$hGraphics = _GDIPlus_GraphicsCreateFromHWND($hGUI)
$hBitmap = _GDIPlus_BitmapCreateFromGraphics($W, $H, $hGraphics)
$hBackbuffer = _GDIPlus_ImageGetGraphicsContext($hBitmap)

; Using antialiasing
_GDIPlus_GraphicsSetSmoothingMode($hBackbuffer, 2)


; Create a Brush object
Local $hPen = _GDIPlus_PenCreate(0, 2)

GUISetOnEvent($GUI_EVENT_CLOSE, "_Exit")

Local $i, $cx, $cy, $xx, $yy, $e, $r, $g, $b, $mpos, $color
Local $fps = 0, $fps_maintimer, $fps_timer, $fps_diff
Local $deg = ACos(-1) / 180
Local $warpZ = 10
Local $units = 250
Local $freq = 0.3
Local $cycle = 0
Local $Z = 0.1
Local $stars[$units][5] ;x,y,z,px,py

For $i = 0 To $units - 1
	Reset_Star($i)
Next

MouseMove($W2, $H2, 5)

GUIRegisterMsg(0x020A, "WM_MOUSEWHEEL")

$fps_maintimer = TimerInit()

While Sleep(30)
	$fps_timer = TimerInit()
	_GDIPlus_GraphicsClear($hBackbuffer, 0x60000000)

	GUISetCursor(3, 1)
	$mpos = MouseGetPos()
	$cx = ($mpos[0] - $W2) + $W2
	$cy = ($mpos[1] - $H2) + $H2
	For $i = 0 To $units - 1
		$xx = $stars[$i][0] / $stars[$i][2]
		$yy = $stars[$i][1] / $stars[$i][2]
		$e = 1 + 1 / $stars[$i][2] * 5
		$r = Sin($freq * $i + $cycle) * 0x15 + 0xC0
		$g = Sin($freq * $i + 2 + $cycle) * 0x15 + 0xC0
		$b = Sin($freq * $i + 4 + $cycle) * 0x15 + 0xC0
		If $stars[$i][3] <> 0 Then
			$color = "0xFF"& Hex($r, 2) & Hex($g, 2) & Hex($b, 2)
			_GDIPlus_PenSetWidth($hPen, $e)
			_GDIPlus_PenSetColor($hPen, $color)
;~ 			_GDIPlus_GraphicsDrawRect($hBackbuffer, $xx + $cx, $yy + $cy, $e, $e, $hPen)
			_GDIPlus_GraphicsDrawLine($hBackbuffer, $xx + $cx, $yy + $cy, $stars[$i][3] + $cx, $stars[$i][4] + $cy, $hPen)
		EndIf
		$stars[$i][2] -= $Z
		$stars[$i][3] = $xx
		$stars[$i][4] = $yy
		If $stars[$i][2] < $Z Or $stars[$i][3] > $W Or $stars[$i][4] > $H Then Reset_Star($i)
	Next
	$cycle += 0.1

	_GDIPlus_GraphicsDrawImageRect($hGraphics, $hBitmap, 0, 0, $W, $H)

	$fps_diff = TimerDiff($fps_timer)
	If TimerDiff($fps_maintimer) > 999.999 Then ;calculate FPS
		$fps = Round(1000 / $fps_diff, 2)
		$fps_maintimer = TimerInit()
	EndIf
	WinSetTitle($hGUI, "", $gui_text & "   /   Warp: " & StringFormat("%.2f", $Z * 10) & " /  FPS: " & StringFormat("%.2f", $fps))
WEnd

Func Reset_Star($a)
	$stars[$a][0] = (Random(0, 1) * $W - ($W * 0.5)) * $warpZ
	$stars[$a][1] = (Random(0, 1) * $H - ($H * 0.5)) * $warpZ
	$stars[$a][2] = $warpZ
	$stars[$a][3] = 0
	$stars[$a][4] = 0
EndFunc

Func WM_MOUSEWHEEL($hWnd, $iMsg, $iwParam, $ilParam)
	Local $wheel = BitAND($iwParam, 0x00FF0000) ; up = 0x00780000, down = 0x00880000
	If $wheel = 0x00780000 Then
		If $Z < 1.01 Then $Z += 0.01
	EndIf
	If $wheel = 0x00880000 Then
		If $Z > 0.04 Then $Z -= 0.01
	EndIf
	Return "GUI_RUNDEFMSG"
EndFunc   ;==>WM_COMMAND


Func _Exit()
	GUIRegisterMsg(0x020A, "")
	; Clean up
	_GDIPlus_PenDispose($hPen)
	_GDIPlus_BitmapDispose($hBitmap)
	_GDIPlus_GraphicsDispose($hBackbuffer)
	_GDIPlus_GraphicsDispose($hGraphics)

	; Uninitialize GDI+
	_GDIPlus_Shutdown()
	$stars = 0
	GUIDelete($hGUI)
	Exit
EndFunc