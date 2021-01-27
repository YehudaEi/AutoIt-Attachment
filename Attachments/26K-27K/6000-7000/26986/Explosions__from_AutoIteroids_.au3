#AutoIt3Wrapper_Run_Obfuscator=y
#Obfuscator_Parameters=/so
#AutoIt3Wrapper_Res_SaveSource=n
#AutoIt3Wrapper_UseUpx=n
#AutoIt3Wrapper_Run_After=upx.exe --best "%out%"
#AutoIt3Wrapper_Run_After=del /f /q "Explosions (from AutoIteroids)_Obfuscated.au3"
#include <GuiConstantsEx.au3>
#include <GDIPlus.au3>
#include <WindowsConstants.au3>

Opt('MustDeclareVars', 1)
Global $fps = 0, $fps_diff, $fps_maintimer, $fps_timer
Global $hGUI, $hWnd, $hGraphic, $width, $height, $win_title = "Particle Explosions (from AUTOITEROIDS modified) using GDI+ by UEZ 2009!"
$width = @DesktopWidth * 0.75
$height = @DesktopHeight * 0.75
Global Const $explosion_step = 8, $explosion_length = ($width + $height) / 7, $explosion_max_amount = 20, $explosion_max_particle = 15
Global $explosion_coordinate[$explosion_max_particle][$explosion_step * $explosion_max_amount] ; on/off, x, y, vx, vy, v, brush, color
Global $explosion_amount = 0
; Create GUI
$hGUI = GUICreate($win_title, $width, $height)
$hWnd = WinGetHandle($hGUI)
_GDIPlus_Startup()
Global $graphics = _GDIPlus_GraphicsCreateFromHWND($hWnd)
Global $bitmap = _GDIPlus_BitmapCreateFromGraphics($width, $height, $graphics)
Global $backbuffer = _GDIPlus_ImageGetGraphicsContext($bitmap)
Global $ScreenDC = _WinAPI_GetDC($hGUI)
Global $gdibitmap, $dc
_GDIPlus_GraphicsSetSmoothingMode($backbuffer, 2)
;~ Global $pen_size = 1
;~ Global $pen_color = 0xAFFF8070
;~ Global $pen = _GDIPlus_PenCreate($pen_color, $pen_size)
Global $brush_color
Global $x_min = $explosion_length * 0.75, $x_max = $width - $x_min, $y_min = $explosion_length * 0.75, $y_max = $height - $y_min

For $o = 0 To $explosion_step * ($explosion_max_amount - 1) Step $explosion_step
	$brush_color = 0; 0xFF000000 + Random(0x400000, 0xFFFFFF, 1)
	For $n = 0 To $explosion_max_particle - 1
;~ 		$brush_color = 0; 0xFF000000 + Random(0x400000, 0xFFFFFF, 1)
		$explosion_coordinate[$n][$o + 6] = _GDIPlus_BrushCreateSolid($brush_color)
	Next
Next
GUISetState()

$fps_maintimer = TimerInit()
Do
	$fps_timer = TimerInit()
	_GDIPlus_GraphicsClear($backbuffer, 0xA0000000)
	If Mod(Random(1, 10, 1), 9) >= 4 Then
		Explosion_Init(Random($x_min, $x_max, 1), Random($y_min, $y_max, 1))
	EndIf
	Explosion()

	$gdibitmap = _GDIPlus_BitmapCreateHBITMAPFromBitmap($bitmap) ;copy drawn image to GUI
	$dc = _WinAPI_CreateCompatibleDC($screendc)
	_WinAPI_SelectObject($dc, $gdibitmap)
	_WinAPI_DeleteObject($gdibitmap)
	_WinAPI_BitBlt($screendc, 0, 0, $width, $height, $dc, 0, 0, $srccopy)
	_WinAPI_DeleteDC($dc)

	$fps_diff = TimerDiff($fps_timer)
	If TimerDiff($fps_maintimer) > 1000 Then ;calculate FPS
		$fps = Round(1000 / $fps_diff, 2)
		$fps_maintimer = TimerInit()
	EndIf
	WinSetTitle($hWnd, "", $win_title & " (fps: " & $fps & ",  #explosions: " & $explosion_amount &  ",  #particles: " & $explosion_amount * $explosion_max_particle & ")")
Until Not Sleep(20) Or GUIGetMsg() = $GUI_EVENT_CLOSE

; Clean up resources
For $o = 0 To $explosion_step * ($explosion_max_amount - 1) Step $explosion_step
	For $n = 0 To $explosion_max_particle - 1
		_GDIPlus_BrushDispose($explosion_coordinate[$n][$o + 6])
	Next
Next
;~ _GDIPlus_PenDispose($pen)
_GDIPlus_BitmapDispose($bitmap)
_GDIPlus_GraphicsDispose($graphics)
_GDIPlus_GraphicsDispose($backbuffer)
_GDIPlus_Shutdown()


Func Explosion_Init($ex, $ey) ;initialise explosion
	For $o = 0 To $explosion_step * ($explosion_max_amount - 1) Step $explosion_step ;fill array with coordinate of hit object
		If $explosion_coordinate[0][$o] <> 1 Then
			$explosion_coordinate[0][$o] = 1
			$explosion_coordinate[0][$o + 1] = $ex ;save x coordinate
			$explosion_coordinate[0][$o + 2] = $ey ;save y coordinate
			$brush_color = 0xFF000000 + Random(0xF0F0F0, 0xFFFFFF, 1)
			For $n = 0 To $explosion_max_particle - 1
				$explosion_coordinate[$n][$o + 1] = $explosion_coordinate[0][$o + 1] ;duplicate x start position of all explosion particles
				$explosion_coordinate[$n][$o + 2] = $explosion_coordinate[0][$o + 2] ;duplicate y start position of all explosion particles
				$explosion_coordinate[$n][$o + 3] = _Random(-7, 7, 1) ;create random x vector (explosion particle speed)
				$explosion_coordinate[$n][$o + 4] = _Random(-7, 7, 1) ;create random y vector (explosion particle speed)
				$explosion_coordinate[$n][$o + 5] = Abs($explosion_coordinate[$n][3 + $o]) + Abs($explosion_coordinate[$n][4 + $o]) ;add absolute distance of vectors x and y
;~ 				$brush_color = 0xFF000000 + Random(0xF0F0F0, 0xFFFFFF, 1) ;each particle gets another color
				$explosion_coordinate[$n][$o + 7] = $brush_color
				_GDIPlus_BrushSetSolidColor($explosion_coordinate[$n][$o + 6], $explosion_coordinate[$n][$o + 7])
			Next
			ExitLoop
		EndIf
	Next
EndFunc   ;==>Explosion_Init

Func Explosion() ;draw explosions coordinates
	Local $q, $k, $r, $g, $b
	$explosion_amount = 0
	For $k = 0 To $explosion_step * ($explosion_max_amount - 1) Step $explosion_step
		If $explosion_coordinate[0][$k] = 1 Then ;only draw active explosions
			$explosion_amount += 1
			For $q = 0 To $explosion_max_particle - 1
				$explosion_coordinate[$q][$k + 1] += $explosion_coordinate[$q][$k + 3] ;draw new x coordinate of a particle
				$explosion_coordinate[$q][$k + 2] += $explosion_coordinate[$q][$k + 4] ;draw new y coordinate of a particle
				$explosion_coordinate[$q][$k + 5] += Abs($explosion_coordinate[$q][$k + 3]) + Abs($explosion_coordinate[$q][$k + 4]) ;absolute vector length
				If $explosion_coordinate[$q][$k + 5] <= $explosion_length Then ;draw until max. distance has been reached
;~                     _GDIPlus_GraphicsDrawEllipse($backbuffer, $explosion_coordinate[$q][$k + 1], $explosion_coordinate[$q][$k + 2], 2, 2, $pen)
					_GDIPlus_GraphicsFillEllipse($backbuffer, $explosion_coordinate[$q][$k + 1], $explosion_coordinate[$q][$k + 2], 3, 3, $explosion_coordinate[$q][$k + 6])
					;fade out colors
					$r = BitAND($explosion_coordinate[$q][$k + 7], 0x00FF0000) / 0x10000 * 0.925 ;decrease red channel
					$g = BitAND($explosion_coordinate[$q][$k + 7], 0x0000FF00) / 0x100 * 0.925 ;decrease green channel
					$b = BitAND($explosion_coordinate[$q][$k + 7], 0x000000FF) * 0.925 ;decrease blue channel
					$explosion_coordinate[$q][$k + 7] = "0xFF" & Hex($r, 2) & Hex($g, 2) & Hex($b, 2)
					_GDIPlus_BrushSetSolidColor($explosion_coordinate[$q][$k + 6], $explosion_coordinate[$q][$k + 7]) ;set new color
				Else ;when max. distance has been reached then set x vector and y vector to 0
					$explosion_coordinate[0][$k] = 0
				EndIf
			Next
		EndIf
	Next
EndFunc   ;==>Explosion

Func _Random($w1, $w2, $w3 = 0) ;just to avoid 0 as random number
	Local $x = 0, $l1 = 0.50
	While $x = 0
		$x = Random($w1, $w2, $w3)
		If $x < $l1 And $x >= 0 Then $x += $l1
		If $x > -$l1 And $x <= 0 Then $x -= $l1
	WEnd
	Return $x
EndFunc   ;==>_Random

Func _GDIPlus_BrushSetSolidColor($hBrush, $iARGB = 0xFF000000)
	Local $aResult
	$aResult = DllCall($ghGDIPDll, "int", "GdipSetSolidFillColor", "hwnd", $hBrush, "int", $iARGB)
	If @error Then Return SetError(@error, @extended, 0)
	Return SetError($aResult[0], 0, $aResult[0] = 0)
EndFunc   ;==>_GDIPlus_BrushSetSolidColor
