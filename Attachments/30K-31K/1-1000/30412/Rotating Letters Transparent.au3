;coded by UEZ 2009
#AutoIt3Wrapper_UseUpx=n
#AutoIt3Wrapper_Run_Obfuscator=y
#Obfuscator_Parameters=/sf /sv /om /cs=0 /cn=0
;~ #AutoIt3Wrapper_Run_After=upx.exe --best "%out%"
#AutoIt3Wrapper_Run_After=upx.exe --ultra-brute "%out%" ;very slow
#AutoIt3Wrapper_Run_After=del "Rotating Letters Transparent_Obfuscated.au3"

#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include <GUIConstants.au3>
#include <GDIPlus.au3>
#include <String.au3>

Global Const $width = 640
Global Const $height = 480
Global Const $pi_div_180 = 4 * ATan(1) / 180
Global $graphics, $backbuffer, $bitmap, $Pen, $arrTxt1, $arrTxt2, $fontsize_txt1, $fontsize_txt2
Global $brush_color, $hFamily1, $hFamily2, $hFont1, $hFont2, $hFormat, $tLayout
Global $ScreenDc, $dc, $tSize, $pSize, $tSource, $pSource, $tBlend, $pBlend, $tPoint, $pPoint, $gdibitmap
Global $x1, $x2, $y1, $y2, $a, $b, $c, $r, $g, $b
Global $i = 0, $j = 360, $m = 0, $n = 0
Global $radius_x, $radius_y
Global $title = "GDI+: Rotating Letters by UEZ 2009!"

Global Const $MSLLHOOKSTRUCT = $tagPOINT & ";dword mouseData;dword flags;dword time;ulong_ptr dwExtraInfo"
;Register callback
$hKey_Proc = DllCallbackRegister("_Mouse_Proc", "int", "int;ptr;ptr")
$hM_Module = DllCall("kernel32.dll", "hwnd", "GetModuleHandle", "ptr", 0)
$hM_Hook = DllCall("user32.dll", "hwnd", "SetWindowsHookEx", "int", $WH_MOUSE_LL, "ptr", DllCallbackGetPtr($hKey_Proc), "hwnd", $hM_Module[0], "dword", 0)

Opt("GUIOnEventMode", 1)
$hwnd = GUICreate($title, $width, $height, -1, -1, 0, $WS_EX_LAYERED + $WS_EX_TOPMOST)
GUISetOnEvent($GUI_EVENT_CLOSE, "Close")

_GDIPlus_Startup()
$graphics = _GDIPlus_GraphicsCreateFromHWND($hwnd)
$bitmap = _GDIPlus_BitmapCreateFromGraphics($width, $height, $graphics)
$backbuffer = _GDIPlus_ImageGetGraphicsContext($bitmap)
_GDIPlus_GraphicsSetSmoothingMode($backbuffer, 2)

$ScreenDc = _WinAPI_GetDC($hWnd)
$gdibitmap = _GDIPlus_BitmapCreateHBITMAPFromBitmap($bitmap)
$dc = _WinAPI_CreateCompatibleDC($ScreenDc)
_WinAPI_SelectObject($dc, $gdibitmap)
; _WinAPI_UpdateLayeredWindow parameters
$tSize = DllStructCreate($tagSIZE)
$pSize = DllStructGetPtr($tSize)
DllStructSetData($tSize, "X", $width)
DllStructSetData($tSize, "Y", $height)
$tSource = DllStructCreate($tagPOINT)
$pSource = DllStructGetPtr($tSource)
$tBlend = DllStructCreate($tagBLENDFUNCTION)
$pBlend = DllStructGetPtr($tBlend)
Global $alpha = 200
Global $alpha_steps = 5
DllStructSetData($tBlend, "Alpha", $alpha)
DllStructSetData($tBlend, "Format", 1)
$tPoint = DllStructCreate($tagPOINT)
$pPoint = DllStructGetPtr($tPoint)
DllStructSetData($tPoint, "X", 0)
DllStructSetData($tPoint, "Y", 0)

GUISetState()

$fontsize_txt1 = 48
$fontsize_txt2 = 24

$width_mul_045 = $width * 0.45
$height_mul_045 = $height * 0.45
$radius_x1 = ($width_mul_045) * 0.95
$radius_y1 = ($height_mul_045) * 0.95
$radius_x2 = ($width_mul_045) * 0.45
$radius_y2 = ($height_mul_045) * 0.45
$text1 = _StringReverse(" Rotating Letters using GDI+")
$text2 = " By UEZ '09 ;-)"
$arrTxt1 = StringSplit($text1, "")
$arrTxt2 = StringSplit($text2, "")
Dim $arrX1[UBound($arrTxt1)]
Dim $arrY1[UBound($arrTxt1)]
Dim $arrX2[UBound($arrTxt2)]
Dim $arrY2[UBound($arrTxt2)]
Dim $brush1[UBound($arrTxt1)]
Dim $brush2[UBound($arrTxt2)]

$r = 1
$c = (255 / UBound($arrTxt1) - 1) * 2 - 1
$r = 0x80
$g = 0xA0
$b = $c
For $k = 0 To UBound($arrTxt1) - 1
	$brush_color = "0xFF" & Hex($r, 2) & Hex($g, 2) & Hex($b, 2)
	$brush1[$k] = _GDIPlus_BrushCreateSolid($brush_color)
	If $r = 1 Then
		$b += $c
	Else
		$b -= $c
	EndIf
	If $b >= 255 Then $r = 0
	If $b <= $c Then $r = 1
Next

For $k = 0 To (UBound($arrTxt2) - 1)
	$brush_color = 0xFF808080
	$brush2[$k] = _GDIPlus_BrushCreateSolid($brush_color)
Next
_GDIPlus_BrushSetSolidColor($brush2[0], 0xFFD08020)
_GDIPlus_BrushSetSolidColor($brush2[1], 0xFFFFA060)
_GDIPlus_BrushSetSolidColor($brush2[2], 0xFFD08020)

$hFormat = _GDIPlus_StringFormatCreate()
$hFamily1 = _GDIPlus_FontFamilyCreate("Arial")
$hFamily2 = _GDIPlus_FontFamilyCreate("Comic Sans MS")
$hFont1 = _GDIPlus_FontCreate($hFamily1, $fontsize_txt1, 2)
$hFont2 = _GDIPlus_FontCreate($hFamily2, $fontsize_txt2, 2)
$tLayout = _GDIPlus_RectFCreate(0, 0)
$a = 360 / (UBound($arrTxt1) - 1)
$b = 360 / (UBound($arrTxt2) - 1)
$y = 0

Do
	_GDIPlus_GraphicsClear($backbuffer, 0x00000000)
	For $x = 1 To UBound($arrTxt1) - 1
		$x1 = $width_mul_045 + Cos(($i + $m) * $pi_div_180) * $radius_x1
		$y1 = $height_mul_045 + Sin(($i + $m) * $pi_div_180) * $radius_y1 - $fontsize_txt1 / 4
		$arrX1[$x] = $x1
		$arrY1[$x] = $y1
		DllStructSetData($tLayout, "x", $arrX1[$x])
		DllStructSetData($tLayout, "y", $arrY1[$x])
		_GDIPlus_GraphicsDrawStringEx($backbuffer, $arrTxt1[$x], $hFont1, $tLayout, $hFormat, $brush1[$x])
		$m += $a
	Next
	For $x = 1 To UBound($arrTxt2) - 1
		$x2 = $width_mul_045 + Cos(($j + $n) * $pi_div_180) * $radius_x2 * Cos($y * $pi_div_180)
		$y2 = $height_mul_045 + Sin(($j + $n) * $pi_div_180) * $radius_y2 - $fontsize_txt2 / 4
		$arrX2[$x] = $x2
		$arrY2[$x] = $y2
		DllStructSetData($tLayout, "x", $arrX2[$x])
		DllStructSetData($tLayout, "y", $arrY2[$x])
		_GDIPlus_GraphicsDrawStringEx($backbuffer, $arrTxt2[$x], $hFont2, $tLayout, $hFormat, $brush2[$x])
		$n += $b
	Next
	If Mod($y, 2) = 1 Then Array_Rot($brush2, 1)
	$y += 1

;~ 	_GDIPlus_GraphicsDrawImageRect($graphics, $bitmap, 0, 0, $width, $height)

    $gdibitmap = _GDIPlus_BitmapCreateHBITMAPFromBitmap($bitmap)
    _WinAPI_SelectObject($dc, $gdibitmap)
    _WinAPI_UpdateLayeredWindow($hWnd, $ScreenDc, 0, $pSize, $dc, $pSource, 0, $pBlend, 2)
	_WinAPI_DeleteObject($gdibitmap)
	$i += 1
	If $i >= 360 Then
		$i = 0
		$m = 0
	EndIf
	$j -= 2
	If $j <= 0 Then
		$j = 360
		$n = 0
	EndIf
Until False * Not Sleep(30)


Func Array_Rot(ByRef $arr, $dir = 0) ;0 for left, 1 for right
	Local $tmp, $p,$q
	If $dir = 0 Then ;left rotation
		$tmp = $arr[0]
		$q = 0
		For $p = 1 To UBound($arr) - 1
			$arr[$q] = $arr[$p]
			$q += 1
		Next
		$arr[UBound($arr) - 1] = $tmp
	ElseIf $dir = 1 Then ;right rotation
		$tmp = $arr[UBound($arr) - 1]
		$q = UBound($arr) - 1
		For $p = UBound($arr) - 2 To 0 Step - 1
			$arr[$q] = $arr[$p]
			$q -= 1
		Next
		$arr[0] = $tmp
	EndIf
EndFunc

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
			If _WinAPI_HiWord($mouseData) > 0 Then ;wheel up
				If $alpha + $alpha_steps <= 512 Then $alpha += $alpha_steps
				Switch $alpha
					Case 0 To 255
						DllStructSetData($tBlend, "Alpha", $alpha)
						DllStructSetData($tBlend, "Format", 1)
					Case 256 To 512
						DllStructSetData($tBlend, "Alpha", $alpha - 256)
						DllStructSetData($tBlend, "Format", 0)
				EndSwitch
			Else ;wheel down
				If $alpha - $alpha_steps > 0 Then $alpha -= $alpha_steps
				Switch $alpha
					Case 0 To 255
						DllStructSetData($tBlend, "Alpha", $alpha) ;wheel up
						DllStructSetData($tBlend, "Format", 1)
					Case 256 To 512
						DllStructSetData($tBlend, "Alpha", $alpha - 256) ;wheel up
						DllStructSetData($tBlend, "Format", 0)
				EndSwitch
			EndIf
			ConsoleWrite($alpha & @CRLF)
	EndSelect

	;This is recommended instead of Return 0
	$ret = DllCall("user32.dll", "long", "CallNextHookEx", "hwnd", $hM_Hook[0], "int", $nCode, "ptr", $wParam, "ptr", $lParam)
	Return $ret[0]
EndFunc   ;==>_Mouse_Proc

Func Close()
	DllCall("user32.dll", "int", "UnhookWindowsHookEx", "hwnd", $hM_Hook[0])
	$hM_Hook[0] = 0
	DllCallbackFree($hKey_Proc)
	$hKey_Proc = 0
	For $x = 0 To UBound($arrTxt1) - 1
		_GDIPlus_BrushDispose($brush1[$x])
	Next
	For $x = 0 To UBound($arrTxt2) - 1
		_GDIPlus_BrushDispose($brush2[$x])
	Next
	_WinAPI_DeleteDC($dc)
    _WinAPI_ReleaseDC($hWnd, $ScreenDc)
	_GDIPlus_FontDispose($hFont1)
	_GDIPlus_FontDispose($hFont2)
	_GDIPlus_FontFamilyDispose($hFamily1)
	_GDIPlus_FontFamilyDispose($hFamily2)
	_GDIPlus_StringFormatDispose($hFormat)
	_GDIPlus_GraphicsDispose($backbuffer)
	_GDIPlus_BitmapDispose($bitmap)
	_GDIPlus_GraphicsDispose($graphics)
	_GDIPlus_Shutdown()
	WinClose($hwnd)
	Exit
EndFunc   ;==>Close
