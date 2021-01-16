#include <GUIConstants.au3>
#include <GDIplus.au3>
#include <misc.au3>

Global Const $width = 650
Global Const $height = 600
Global Const $PI = 3.14159

Global $title = "Lissajous Curve"

; Build your GUI here
Opt("GUIOnEventMode", 1)
$hwnd = GUICreate($title, $width, $height)
GUISetOnEvent($GUI_EVENT_CLOSE, "close")
GUISetBkColor(0x0)

GUICtrlCreateLabel("A =" & @CRLF & "B =", 6, 2, 60, 55)
GUICtrlSetFont(-1, 18)
GUICtrlSetColor(-1, 0xFFFFFF)

$inputa = GUICtrlCreateInput(Round($width / 3), 55, 4, 50, 20)
GUICtrlSetBkColor(-1, 0)
GUICtrlSetColor(-1, 0xFFFFFF)
GUICtrlCreateUpdown(-1)

$inputb = GUICtrlCreateInput(Round($height / 3), 55, 30, 50, 20)
GUICtrlSetBkColor(-1, 0)
GUICtrlSetColor(-1, 0xFFFFFF)
GUICtrlCreateUpdown(-1)

GUICtrlCreateLabel("a =" & @CRLF & "b =", 150, 2, 60, 55)
GUICtrlSetFont(-1, 18)
GUICtrlSetColor(-1, 0xFFFFFF)

$inputsmalla = GUICtrlCreateInput(1, 55 + 144, 4, 50, 20)
GUICtrlSetBkColor(-1, 0)
GUICtrlSetColor(-1, 0xFFFFFF)
GUICtrlCreateUpdown(-1)

$inputsmallb = GUICtrlCreateInput(2, 55 + 144, 30, 50, 20)
GUICtrlSetBkColor(-1, 0)
GUICtrlSetColor(-1, 0xFFFFFF)
GUICtrlCreateUpdown(-1)

GUICtrlCreateLabel("Delta       = ", 150 + 144, 2, 120, 40)
GUICtrlSetFont(-1, 18)
GUICtrlSetColor(-1, 0xFFFFFF)
$inputdelta = GUICtrlCreateInput($PI / 2, 90 + 144 + 144 + 75, 4, 75, 20)
GUICtrlSetBkColor(-1, 0)
GUICtrlSetColor(-1, 0xFFFFFF)
GUICtrlCreateUpdown(-1)

GUICtrlCreateLabel("Precision = ", 150 + 144, 30, 120, 40)
GUICtrlSetFont(-1, 18)
GUICtrlSetColor(-1, 0xFFFFFF)
$inputprec = GUICtrlCreateInput(50, 90 + 144 + 144 + 75, 32, 75, 20)
GUICtrlSetBkColor(-1, 0)
GUICtrlSetColor(-1, 0xFFFFFF)
GUICtrlCreateUpdown(-1)

$refreshbutton = GUICtrlCreateButton("Refresh", $width - 110, 2, 100, 50)
GUICtrlSetOnEvent(-1, "refresh")

$label = GUICtrlCreateLabel("", 0, 60, $width, $height - 60)


; Load your GDI+ resources here:
_GDIPlus_Startup()
$graphics = _GDIPlus_GraphicsCreateFromHWND(ControlGetHandle($hwnd, "", $label))
$bitmap = _GDIPlus_BitmapCreateFromGraphics($width, $height - 60, $graphics)
$backbuffer = _GDIPlus_ImageGetGraphicsContext($bitmap)
_GDIPlus_GraphicsSetSmoothingMode($backbuffer, 4)
$matrix = _GDIPlus_MatrixCreate()
_GDIPlus_MatrixTranslate($matrix, $width / 2, $height / 2)
_GDIPlus_GraphicsSetTransform($backbuffer, $matrix)

$redbrush = _GDIPlus_BrushCreateSolid(0xFFFF0000)
$redpen = _GDIPlus_PenCreate(0xFFFF0000)

$family = _GDIPlus_FontFamilyCreate("Georgia")
$font = _GDIPlus_FontCreate($family, 48)
$rectf = _GDIPlus_RectFCreate(-$width / 2, -200, $width, $height)
$sformat = _GDIPlus_StringFormatCreate()
_GDIPlus_StringFormatSetAlign($sformat, 1)
$greybrush = _GDIPlus_BrushCreateSolid(0xEE888888)


GUISetState()
_GDIPlus_GraphicsClear($backbuffer)
_GDIPlus_GraphicsDrawStringEx($backbuffer, "Click here to learn more about the Lissajous Curve", $font, $rectf, $sformat, $greybrush)
_GDIPlus_GraphicsDrawImageRect($graphics, $bitmap, 0, 0, $width, $height - 60)

Opt("MouseCoordMode", 2)
Do

	If WinActive($hwnd) And _IsPressed("01") Then
		$mpos = MouseGetPos()
		If $mpos[0] > 0 And $mpos[0] < $width And $mpos[1] > 60 And $mpos[1] < $height Then
			Do
				Sleep(10)
			Until Not _IsPressed("01")
			ShellExecute("http://en.wikipedia.org/wiki/Lissajous_curve")
		EndIf
	EndIf

	_GDIPlus_GraphicsDrawImageRect($graphics, $bitmap, 0, 0, $width, $height - 60)
	Sleep(10)
Until False

Func refresh()
	_GDIPlus_GraphicsClear($backbuffer)
	_GDIPlus_GraphicsDrawStringEx($backbuffer, "DRAWING...", $font, $rectf, $sformat, $greybrush)
	_GDIPlus_GraphicsDrawImageRect($graphics, $bitmap, 0, 0, $width, $height - 60)
	_GDIPlus_GraphicsClear($backbuffer)
	LissajousCurve($backbuffer, $width, _
			GUICtrlRead($inputa), GUICtrlRead($inputb), GUICtrlRead($inputsmalla), _
			GUICtrlRead($inputsmallb), GUICtrlRead($inputdelta), GUICtrlRead($inputprec), $redbrush)
	_GDIPlus_GraphicsDrawImageRect($graphics, $bitmap, 0, 0, $width, $height - 60)
EndFunc   ;==>refresh


Func LissajousCurve(ByRef $g, $trange, $sizeX, $sizeY, $a, $b, $delta, $precision, $brush)
	For $t = -$trange / 2 To $trange / 2 Step 1 / $precision
		$x = $sizeX * Sin($a * $t + $delta)
		$y = $sizeY * Sin($b * $t)
		_GDIPlus_GraphicsFillEllipse($g, $x, $y, 2, 2, $brush)
	Next
EndFunc   ;==>LissajousCurve







Func close()
	_GDIPlus_GraphicsDispose($backbuffer)
	_GDIPlus_BitmapDispose($bitmap)
	_GDIPlus_GraphicsDispose($graphics)
	_GDIPlus_Shutdown()
	Exit
EndFunc   ;==>close