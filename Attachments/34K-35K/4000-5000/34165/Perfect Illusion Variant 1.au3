;coded by UEZ 2011 Build 2011-06-02
#AutoIt3Wrapper_Run_Obfuscator=y
#Obfuscator_Parameters=/sf /sv /om /cs=0 /cn=0
#AutoIt3Wrapper_UseX64=n
#AutoIt3Wrapper_UseUpx=y
#AutoIt3Wrapper_UPX_Parameters=--ultra-brute --crp-ms=999999 --all-methods --all-filters
#AutoIt3Wrapper_Run_After=del /f /q "%scriptdir%\%scriptfile%_Obfuscated.au3"
#include <GUIConstantsEx.au3>
#include <GDIplus.au3>
#include <WindowsConstants.au3>
Opt("GUIOnEventMode", 1)

Global Const $width = 800
Global Const $width2 = $width / 2 - 50
Global Const $height = 600
Global Const $height2 = $height / 2 - 50
Global Const $bs = 20
Global Const $bs2 = $bs / 2
Global Const $max_r = $height * 0.8

Global $hGUI = GUICreate("GDI+ Perfect Illusion by UEZ 2011", $width, $height);, -1, -1, Default, BitOR($WS_EX_TOPMOST, $WS_EX_TOOLWINDOW))
GUISetState()

_GDIPlus_Startup()

Global Const $screens = 8
Global $screen_bitmap[$screens]
Global $screen_context[$screens]
Global Const $hBrush = _GDIPlus_BrushCreateSolid(0xFF404040)
Global Const $hGraphic = _GDIPlus_GraphicsCreateFromHWND($hGUI)

Global $i, $j, $m, $r, $dir

For $i = 0 To $screens - 1
	$screen_bitmap[$i] = _GDIPlus_BitmapCreateFromGraphics($width, $height, $hGraphic)
	$screen_context[$i] = _GDIPlus_ImageGetGraphicsContext($screen_bitmap[$i])
	_GDIPlus_GraphicsFillRect($screen_context[$i], 0, 0, $width, $height, $hBrush)
	_GDIPlus_GraphicsSetSmoothingMode($screen_context[$i], 2)
Next

GUISetOnEvent($GUI_EVENT_CLOSE, "_Exit")

$dir = 1
$i = 0
$j = 0.05
$m = 0
$r = 1

_GDIPlus_BrushSetSolidColor($hBrush, 0xC00000FF)
Do
	_GDIPlus_GraphicsFillEllipse($screen_context[$m], ($width2 - $bs2) - Cos(-$i) * $r, ($height2 - $bs2) - Sin(-$i) * $r, $r / 2, $r / 2, $hBrush)
	_GDIPlus_GraphicsDrawEllipse($screen_context[$m], ($width2 - $bs2) - Cos(-$i) * $r, ($height2 - $bs2) - Sin(-$i) * $r, $r / 2, $r / 2)
	_GDIPlus_GraphicsDrawImageRect($hGraphic, $screen_bitmap[$m], 0, 0, $width, $height)
	$m = Mod($m + 1, $screens)
	$i += $j
	If $r > $max_r Or $r < 1 Then $dir *= -1
	$r += (0.075 + Sin($i / 3.5) ) * $dir
Until Not Sleep(30)

Func _Exit()
	_GDIPlus_BrushDispose($hBrush)
	For $i = 0 To $screens - 1
		_GDIPlus_BitmapDispose($screen_bitmap[$i])
		_GDIPlus_GraphicsDispose($screen_context[$i])
	Next
	_GDIPlus_GraphicsDispose($hGraphic)
	GUIDelete($hGUI)
	_GDIPlus_Shutdown()
	Exit
EndFunc   ;==>_Exit
