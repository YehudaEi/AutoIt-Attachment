;Idea taken from http://js1k.com/demo/304
;Ported to AutoIt by UEZ 2010
#AutoIt3Wrapper_UseUpx=n
#AutoIt3Wrapper_Run_Obfuscator=y
#Obfuscator_Parameters=/sf /sv /om /cs=0 /cn=0
#AutoIt3Wrapper_Run_After=del /f /q "Tramp of Particles_Obfuscated.au3"
#AutoIt3Wrapper_Run_After=upx.exe --ultra-brute "%out%"
;~ #AutoIt3Wrapper_Run_After=upx.exe --best "%out%"

;~ #include <Array.au3>
#include <GuiConstantsEx.au3>
#include <GDIPlus.au3>
Opt("MustDeclareVars", 1)
Opt("GUIOnEventMode", 1)
Local $hWnd, $hGraphic, $hBitmap, $hBackbuffer, $hBrush
Local $hFormat, $hFamily, $hFont, $tLayout, $aInfo, $hBrush_Font
Local $width = 640, $height = 480
Local $max_particle = 500
Local $size_x = 1
Local $size_y = 1
Local $aParticles[$max_particle][5] ;x,y,vx,vy,color
Local $i, $x, $pi = ACos(-1), $pi180 = $pi / 180, $r, $g, $b
Local $gui_text = "GDI+ version of Tramp of " & $max_particle & " Particles by UEZ v2010 Build 2010-08-14   d•¿•b"
Local $fps = 0, $fps_maintimer, $fps_timer, $fps_diff

For $i = 0 To UBound($aParticles) - 1
	$aParticles[$i][0] = Random(0, $width, 1)
	$aParticles[$i][1] = Random(0, $height, 1)
	$aParticles[$i][2] = 0
	$aParticles[$i][3] = 0
	$aParticles[$i][4] = 0xFFFFFFFF
;~ 	$r = 0x10 + Int(0xD0 * Abs(Sin($i * 0.05) * 2))
;~ 	$g = 0x10 + Int(0xD0 * Abs(Sin($i * 0.05) * 2))
;~ 	$b = 0x10 + Int(0xD0 * Abs(Sin($i * 0.05) * 2))
;~ 	$aParticles[$i][4] = "0xFF" & Hex($r, 2) & Hex($g, 2) & Hex($b, 2)
Next

;~ _ArrayDisplay($aParticles)

_GDIPlus_Startup()
$hWnd = GUICreate($gui_text, $width, $height)
GUISetState()

$hGraphic = _GDIPlus_GraphicsCreateFromHWND($hWnd)
$hBitmap = _GDIPlus_BitmapCreateFromGraphics($width, $height, $hGraphic)
$hBackbuffer = _GDIPlus_ImageGetGraphicsContext($hBitmap)
$hBrush = _GDIPlus_BrushCreateSolid(0xFFFFFFFF)

$hBrush_Font = _GDIPlus_BrushCreateSolid(0xFF7070F0)
$hFormat = _GDIPlus_StringFormatCreate ()
$hFamily = _GDIPlus_FontFamilyCreate ("Arial")
$hFont = _GDIPlus_FontCreate ($hFamily, 11, 1)
$tLayout = _GDIPlus_RectFCreate (1, 12, 0, 0)
$aInfo = _GDIPlus_GraphicsMeasureString ($hGraphic, "", $hFont, $tLayout, $hFormat)


GUIRegisterMsg(0x000F, "WM_PAINT") ;$WM_PAINT = 0x000F
GUIRegisterMsg(0x0014 , "WM_ERASEBKGND") ;WM_ERASEBKGND = 0x0014

GUISetOnEvent($GUI_EVENT_CLOSE, "_Exit")

$fps_maintimer = TimerInit()

While 1
	$fps_timer = TimerInit()
	_GDIPlus_GraphicsClear($hBackbuffer, 0xFF000000)
	_GDIPlus_GraphicsDrawStringEx($hBackbuffer, "FPS: " & StringFormat("%.2f", $fps), $hFont, $aInfo[0], $hFormat, $hBrush_Font)
	For $x = 0 To $max_particle - 1
		$aParticles[$x][0] += $aParticles[$x][2]
		$aParticles[$x][1] += $aParticles[$x][3]
		If $aParticles[$x][0] < 0 Then $aParticles[$x][0] += $width
		If $aParticles[$x][0] > $width Then $aParticles[$x][0] -= $width
		If $aParticles[$x][1] < 0 Then $aParticles[$x][1] += $height
		If $aParticles[$x][1] > $height Then $aParticles[$x][1] -= $height
		$aParticles[$x][3] = Cos($aParticles[$x][0] * 0.02) + 0.25
		$aParticles[$x][2] = Sin($aParticles[$x][1] * 0.025) + 0.5
		If $aParticles[$x][0] > -1 And $aParticles[$x][0] < $width And $aParticles[$x][1] > -1 And $aParticles[$x][1] < $height Then _
			_GDIPlus_BitmapSetPixel($hBitmap, $aParticles[$x][0], $aParticles[$x][1], $aParticles[$x][4])
;~ 			_GDIPlus_GraphicsFillRect($hBackbuffer, $aParticles[$x][0], $aParticles[$x][1], $size_x, $size_y, $hBrush)
	Next
	_GDIPlus_GraphicsDrawImageRect($hGraphic, $hBitmap, 0, 0, $width, $height)
	$fps_diff = TimerDiff($fps_timer)
	If TimerDiff($fps_maintimer) > 999 Then ;calculate FPS
		$fps = Round(1000 / $fps_diff, 2)
		$fps_maintimer = TimerInit()
	EndIf
;~ 	WinSetTitle($hWnd,"", $gui_text & "   /   FPS: " & StringFormat("%.2f", $fps))
WEnd

Func _Exit()
	$aParticles = 0
	GUIRegisterMsg(0x000F, "")
	GUIRegisterMsg(0x0014, "")
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
EndFunc

Func WM_PAINT()
    _GDIPlus_GraphicsDrawImageRect($hGraphic, $hBitmap, 0, 0, $width, $height)
    Return "GUI_RUNDEFMSG"
EndFunc   ;==>WM_PAINT

Func WM_ERASEBKGND()
    _GDIPlus_GraphicsDrawImageRect($hGraphic, $hBitmap, 0, 0, $width, $height)
    Return "GUI_RUNDEFMSG"
EndFunc

Func _GDIPlus_BitmapSetPixel($hBitmap, $iX, $iY, $iARGB = 0xFFFFFFFF)
	Local $aRet
	$aRet = DllCall($ghGDIPDll, "int", "GdipBitmapSetPixel", "hwnd", $hBitmap, "int", $iX, "int", $iY, "dword", $iARGB)
	Return
EndFunc   ;==>_GDIPlus_BitmapSetPixel