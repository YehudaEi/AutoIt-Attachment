#AutoIt3Wrapper_UseUpx=n
#AutoIt3Wrapper_Run_After=upx.exe --best "%out%"
#AutoIt3Wrapper_Run_Obfuscator=y
#Obfuscator_Parameters=/SO

#include <GUIConstantsEx.au3>
#include <GDIplus.au3>
#include <Misc.au3>
#include <WindowsConstants.au3>

Opt('MouseCoordMode', 2)
Opt("GUIOnEventMode", 1)

Global Const $width = 640
Global Const $height = 512
Global $title = "GDI+ Particle Catapult by UEZ'09 -=> Move mouse within window and press lmb to change particle source pos.!"

Global Const $WM_MOUSEWHEEL = 0x020A ;wheel up/down
Global Const $MSLLHOOKSTRUCT = $tagPOINT & ";dword mouseData;dword flags;dword time;ulong_ptr dwExtraInfo"
;Register callback
$hKey_Proc = DllCallbackRegister("_Mouse_Proc", "int", "int;ptr;ptr")
$hM_Module = DllCall("kernel32.dll", "hwnd", "GetModuleHandle", "ptr", 0)
$hM_Hook = DllCall("user32.dll", "hwnd", "SetWindowsHookEx", "int", $WH_MOUSE_LL, "ptr", DllCallbackGetPtr($hKey_Proc), "hwnd", $hM_Module[0], "dword", 0)

Global $hwnd = GUICreate($title, $width, $height, -1, -1, Default, BitOR($WS_EX_TOPMOST, $WS_EX_TOOLWINDOW))
GUISetOnEvent($GUI_EVENT_CLOSE, "Close")
GUISetState()

_GDIPlus_Startup()
Global $graphics = _GDIPlus_GraphicsCreateFromHWND($hwnd)
Global $bitmap = _GDIPlus_BitmapCreateFromGraphics($width, $height, $graphics)
Global $backbuffer = _GDIPlus_ImageGetGraphicsContext($bitmap)
_GDIPlus_GraphicsClear($backbuffer)
_GDIPlus_GraphicsSetSmoothingMode($backbuffer, 4)

Global Const $Pi = 3.1415926535897932384626
Global Const $Pi_Div_180 = $Pi / 180
Global $side, $r, $g, $b
Global $max_dots = 500
Global $iWidth = 32
Global $iHeight = 32
Global $center_x = 1
Global $center_y = 1
Global $max_speed = 10
Global $distance_dots = 25
Global Const $radius = Pixel_Distance($width / 2, $height / 2, 0, 0)
Global $mouse_pos, $win_pos, $particle_pos_x = $width / 2, $particle_pos_y = $height / 2, $angle
Global $dll = DllOpen("user32.dll")

Global $brush_color
Dim $coordinates[$max_dots][8]
Dim $brush[$max_dots]

For $k = 0 To UBound($coordinates) - 1
	$brush[$k] = _GDIPlus_BrushCreateSolid(0xCFFFFFFF)
	New_Coordinates($k)
Next

Do
	_GDIPlus_GraphicsClear($backbuffer, 0xEF000000)
	Draw_Dots()
	Calculate_New_Position()
	_GDIPlus_GraphicsDrawImageRect($graphics, $bitmap, 0, 0, $width, $height)
	Sleep(30)
Until False

Func Draw_Dots()
	Local $i, $d
	For $i = $max_dots - 1 To 0 Step -1
		If $coordinates[$i][6] >= $distance_dots Then
			$d = Pixel_Distance($width / 2, $height / 2, $coordinates[$i][0], $coordinates[$i][1]) / 10
			_GDIPlus_GraphicsFillEllipse($backbuffer, $coordinates[$i][0], $coordinates[$i][1], $iWidth + $d, $iHeight + $d, $brush[$i])
		EndIf
		$coordinates[$i][6] += 0.25
	Next
EndFunc   ;==>Draw_Dots


Func Calculate_New_Position()
	Local $k
	For $k = 0 To $max_dots - 1
		$m = $coordinates[$k][5]
		If $coordinates[$k][0] < $coordinates[$k][3] And $coordinates[$k][1] < $coordinates[$k][4] Then
			$coordinates[$k][1] -= (($coordinates[$k][0] + $coordinates[$k][2]) - $coordinates[$k][0]) * $m
			$coordinates[$k][0] -= $coordinates[$k][2]
		ElseIf $coordinates[$k][0] > $coordinates[$k][3] And $coordinates[$k][1] < $coordinates[$k][4] Then
			$coordinates[$k][1] += (($coordinates[$k][0] + $coordinates[$k][2]) - $coordinates[$k][0]) * $m
			$coordinates[$k][0] += $coordinates[$k][2]
		ElseIf $coordinates[$k][0] > $coordinates[$k][3] And $coordinates[$k][1] > $coordinates[$k][4] Then
			$coordinates[$k][1] += (($coordinates[$k][0] + $coordinates[$k][2]) - $coordinates[$k][0]) * $m
			$coordinates[$k][0] += $coordinates[$k][2]
		ElseIf $coordinates[$k][0] < $coordinates[$k][3] And $coordinates[$k][1] > $coordinates[$k][4] Then
			$coordinates[$k][1] -= (($coordinates[$k][0] + $coordinates[$k][2]) - $coordinates[$k][0]) * $m
			$coordinates[$k][0] -= $coordinates[$k][2]
		EndIf
		$coordinates[$k][7] += $coordinates[$k][2]
		If $coordinates[$k][7] >= $radius Then New_Coordinates($k)
	Next
EndFunc   ;==>Calculate_New_Position

Func New_Coordinates($i)
	If _IsPressed("01", $dll) Then
		$mouse_pos = MouseGetPos()
		If $mouse_pos[0] > 0 And $mouse_pos[0] < $width Then $particle_pos_x = $mouse_pos[0] ;set new x coordinate for particle source
		If $mouse_pos[1] > 0 And $mouse_pos[1] < $height Then $particle_pos_y = $mouse_pos[1] ;set new y coordinate for particle source
		$r = Random(10, 255, 1)
		$g = Random(10, 255, 1)
		$b = Random(10, 255, 1)
		$brush_color = "0xCF" & Hex($r, 2) & Hex($g, 2) & Hex($b, 2) ;set random color when the lmb was pressed
	Else
		$brush_color = 0xCFFFFFFF ;else set white as standard particle color
	EndIf
	_GDIPlus_BrushSetSolidColor($brush[$i], $brush_color)
	$coordinates[$i][0] = $particle_pos_x + Tan($i * $Pi_Div_180) * 10 ;start x position
	$coordinates[$i][1] = $particle_pos_y + ATan($i * $Pi_Div_180) * 10 ;start y position
	$coordinates[$i][2] = Random(1, $max_speed, 1) ;speed of pixel
	$coordinates[$i][3] = Random(0, $width, 1) ;new destination x
	$coordinates[$i][4] = Random(0, $height, 1);new destination y
;~ 	$angle = Random(0, 359, 1)
;~ 	$coordinates[$i][5] = $coordinates[$i][2] * Cos($angle * $Pi_Div_180)
;~ 	$coordinates[$i][6] = $coordinates[$i][2] * Sin($angle * $Pi_Div_180)
	$coordinates[$i][5] = Random(-5, 5) ;radient between 2 points
	If Round($coordinates[$i][5], 2) = 0 Then $coordinates[$i][5] += 1
	$coordinates[$i][6] = $i ;pixel distance to next pixel
	$coordinates[$i][7] = 0 ;pixel start length
EndFunc   ;==>New_Coordinates

Func Pixel_Distance($x1, $y1, $x2, $y2)
	Local $a, $b, $c
	If $x2 = $x1 And $y2 = $y1 Then
		Return 0
	Else
		$a = $y2 - $y1
		$b = $x2 - $x1
		$c = Sqrt($a * $a + $b * $b)
		Return $c
	EndIf
EndFunc   ;==>Pixel_Distance


Func Close()
	For $i = 0 To UBound($brush) -1
		_GDIPlus_BrushDispose($brush[$i])
	Next
	_GDIPlus_BitmapDispose($bitmap)
	_GDIPlus_GraphicsDispose($graphics)
	_GDIPlus_GraphicsDispose($backbuffer)
	_GDIPlus_Shutdown()
	DllClose($dll)
	DllCall("user32.dll", "int", "UnhookWindowsHookEx", "hwnd", $hM_Hook[0])
	$hM_Hook[0] = 0
	DllCallbackFree($hKey_Proc)
	$hKey_Proc = 0
	Exit
EndFunc   ;==>close

; #FUNCTION# ====================================================================
; Name...........: _GDIPlus_BrushSetSolidColor
; Description ...: Set the color of a Solid Brush object
; Syntax.........: _GDIPlus_BrushSetSolidColor($hBrush, [$iARGB = 0xFF000000])
; Parameters ....: $hBrush      - Handle to a Brush object
;                  $iARGB       - Alpha, Red, Green and Blue components of brush
; Return values .: Success      - True
;                  Failure      - False
; Author ........:
; Modified.......: smashly
; Remarks .......:
; Related .......:
; Link ..........; @@MsdnLink@@ GdipSetSolidFillColor
; Example .......; Yes
; ================================================================================
Func _GDIPlus_BrushSetSolidColor($hBrush, $iARGB = 0xFF000000)
	Local $aResult
	$aResult = DllCall($ghGDIPDll, "int", "GdipSetSolidFillColor", "hwnd", $hBrush, "int", $iARGB)
	If @error Then Return SetError(@error, @extended, 0)
	Return SetError($aResult[0], 0, $aResult[0] = 0)
EndFunc   ;==>_GDIPlus_BrushSetSolidColor


;http://www.autoitscript.com/forum/index.php?showtopic=81761
Func _Mouse_Proc($nCode, $wParam, $lParam) ;function called for mouse events.. Made by _Kurt
	;define local vars
	Local $info, $mouseData

	If $nCode < 0 Then ;recommended, see http://msdn.microsoft.com/en-us/library/ms644986(VS.85).aspx
		$ret = DllCall("user32.dll", "long", "CallNextHookEx", "hwnd", $hM_Hook[0], "int", $nCode, "ptr", $wParam, "ptr", $lParam) ;recommended
		Return $ret[0]
	EndIf
	$info = DllStructCreate($MSLLHOOKSTRUCT, $lParam)
	$mouseData = DllStructGetData($info, 3)

	;Find which event happened
	Select
		Case $wParam = $WM_MOUSEWHEEL And WinActive($hwnd)
			If _WinAPI_HiWord($mouseData) > 0 Then
				If $iWidth < 64 And $iHeight < 64 Then
					$iWidth += 1
					$iHeight += 1
				EndIf
			Else
				If $iWidth > 2 And $iHeight > 2 Then
					$iWidth -= 1
					$iHeight -= 1
				EndIf
			EndIf
	EndSelect

	;This is recommended instead of Return 0
	$ret = DllCall("user32.dll", "long", "CallNextHookEx", "hwnd", $hM_Hook[0], _
			"int", $nCode, "ptr", $wParam, "ptr", $lParam)
	Return $ret[0]
EndFunc   ;==>_Mouse_Proc