;Coded by UEZ 2010 Build 2010-09-01
#AutoIt3Wrapper_UseUpx=n
#AutoIt3Wrapper_Run_Obfuscator=y
#Obfuscator_Parameters=/sf /sv /om /cs=0 /cn=0
#AutoIt3Wrapper_Run_After=del /f /q "Zoomer_Obfuscated.au3"
#AutoIt3Wrapper_Run_After=upx.exe --ultra-brute "%out%"
#AutoIt3Wrapper_Run_After=upx.exe --best "%out%"
#include <Color.au3>
#include <GDIP.au3>
#include <GUIConstantsEx.au3>

Opt("MustDeclareVars", 1)
Opt("GUIOnEventMode", 1)
Opt("MouseCoordMode", 1)

Local $hGUI, $hGraphics, $hBackbuffer, $hBitmap, $hBuffer, $hContext, $timer
Local $hFormat, $hFamily, $hFont, $tLayout, $hBrush_Font
Local Const $W = 800, $H = $W
Local Const $W2 = $W / 2, $H2 = $H / 2

Local $GUI_title = "GDI+ Zoomer by UEZ 2010"
$hGUI = GUICreate($GUI_title, $W, $H)
GUISetBkColor(0x000000, $hGUI)
GUISetState()

; Initialize GDI+
_GDIPlus_Startup()

$hGraphics = _GDIPlus_GraphicsCreateFromHWND($hGUI)
$hBitmap = _GDIPlus_BitmapCreateFromGraphics($W, $H, $hGraphics)
$hBackbuffer = _GDIPlus_ImageGetGraphicsContext($hBitmap)
; Using antialiasing
_GDIPlus_GraphicsSetSmoothingMode($hBackbuffer, 2)

; Create a Brush and a Pen object
Local $hBrush_col[3]
Local $hBrush = _GDIPlus_BrushCreateSolid()
Local $hPen = _GDIPlus_PenCreate(0xA0000000, 2)

GUISetOnEvent($GUI_EVENT_CLOSE, "_Exit")

Local $p = 40
Local $k = 40
Local $ps = $p / 10
Local $t = 0
Local Const $min = 8
Local Const $mouse_sense = 5
Local Const $scale = 0.05
Local $i, $mpos, $fps, $cx, $cy, $pp

$hBuffer = _GDIPlus_BitmapCreateFromScan0($W, $H)
$hContext = _GDIPlus_ImageGetGraphicsContext($hBuffer)

_GDIPlus_GraphicsTranslateTransform($hContext, -$W2 * $scale, -$H2 * $scale)
_GDIPlus_GraphicsScaleTransform($hContext, 1 + $scale, 1 + $scale)

_GDIPlus_GraphicsSetInterpolationMode($hContext, 0)

$hFormat = _GDIPlus_StringFormatCreate ()
$hFamily = _GDIPlus_FontFamilyCreate ("Comic Sans MS")
$hFont = _GDIPlus_FontCreate ($hFamily, 20, 0)
Local $tLayout = DllStructCreate($tagGDIPRECTF)
DllStructSetData($tLayout, "X", 0)
DllStructSetData($tLayout, "Y", 0)
DllStructSetData($tLayout, "Width", $W)
DllStructSetData($tLayout, "Height", 30)
$hBrush_Font = _GDIPlus_BrushCreateSolid(0xFF000000)

MouseMove(@DesktopWidth / 2, @DesktopHeight / 2, 20)
WinSetTitle($hGUI, "", $GUI_title & " / FPS: 0")
AdlibRegister("FPS", 1000)
$timer = TimerInit()

While Sleep(20)
	_GDIPlus_GraphicsDrawImageRect($hBackbuffer, $hBuffer, 0, 0, $W, $H)

	$mpos = MouseGetPos()
	If $mpos[0] / $mouse_sense > $min Then $p = $mpos[0] / $mouse_sense
	If $mpos[1] / $mouse_sense > $min Then $k = $mpos[1] / $mouse_sense

	For $i = 0 To 4
		$hBrush_col[0] = 0xFF - Random(0, 0x07, 1)
		$hBrush_col[1] = 0xFF - Random(0, 0x07, 1)
		$hBrush_col[2] = 0xFF - Random(0, 0x07, 1)
		_GDIPlus_BrushSetSolidColor($hBrush, "0x70" & Hex(_ColorSetRGB($hBrush_col), 6))
		_GDIPlus_PenSetWidth($hPen, $ps)
		$pp = $p / 2
		$cx = $W2 - $pp + Sin($t / 15 + $i * 1.3) * $k
		$cy = $W2 - $pp + Cos($t / 23 - $i * 2.3) * $k
		_GDIPlus_GraphicsDrawEllipse($hBackbuffer, $cx , $cy, $p, $p, $hPen)
		_GDIPlus_GraphicsFillEllipse($hBackbuffer, $cx , $cy, $p, $p, $hBrush)
	Next
	$t += 2
	If TimerDiff($timer) > Random(5000, 15000, 1) Then
		DllStructSetData($tLayout, "X", Random($W2 / 10, $W2, 1))
		DllStructSetData($tLayout, "Y",  Random($H / 3, $H * 0.66, 1))
		_GDIPlus_GraphicsDrawStringEx($hBackbuffer, "Coded by UEZ 2010 d-|-b", $hFont, $tLayout, $hFormat, $hBrush_Font)
		$timer = TimerInit()
	EndIf

	_GDIPlus_GraphicsDrawImageRect($hGraphics, $hBitmap, 0, 0, $W, $H)
	_GDIPlus_GraphicsDrawImageRect($hContext, $hBitmap, 0, 0, $W, $H)

	$fps += 1
WEnd

Func FPS()
	WinSetTitle($hGUI, "", $GUI_title & " / FPS: " & $fps)
	$fps = 0
EndFunc

Func _Exit()
	AdlibUnRegister("FPS")
	; Clean up
    _GDIPlus_FontDispose ($hFont)
    _GDIPlus_FontFamilyDispose ($hFamily)
    _GDIPlus_StringFormatDispose ($hFormat)
	_GDIPlus_BrushDispose($hBrush)
	_GDIPlus_BrushDispose($hBrush_Font)
	_GDIPlus_PenDispose($hPen)
	_GDIPlus_BitmapDispose($hBuffer)
	_GDIPlus_GraphicsDispose($hContext)
	_GDIPlus_BitmapDispose($hBitmap)
	_GDIPlus_GraphicsDispose($hBackbuffer)
	_GDIPlus_GraphicsDispose($hGraphics)

	; Uninitialize GDI+
	_GDIPlus_Shutdown()
	GUIDelete($hGUI)
	Exit
EndFunc