;coded by UEZ 2009-01-29
#AutoIt3Wrapper_Run_Obfuscator=y
#Obfuscator_Parameters=/sf /sv /om /cs=0 /cn=0
#AutoIt3Wrapper_UseUpx=n
;~ #AutoIt3Wrapper_Run_After=upx.exe --best "%out%"
#AutoIt3Wrapper_Run_After=upx.exe --ultra-brute "%out%"
#AutoIt3Wrapper_Run_After=del /f /q "Sinus Scroller_Obfuscated.au3"

#include <GUIConstantsEx.au3>
#include <GDIplus.au3>

Opt("GUIOnEventMode", 1)
Opt('MustDeclareVars', 1)

Global Const $width = Int(@DesktopWidth * (@DesktopHeight / @DesktopWidth) * 0.666)
Global Const $height = Int(@DesktopHeight * (@DesktopHeight / @DesktopWidth) * 0.666)
Global Const $pi = 4 * ATan(1)
Global Const $pi_div_m170 = $pi / - 270
Global Const $pi_div_10 = $pi / 10
Global Const $pi_div_180 = $pi / 180
Global Const $height_div_2 = $height / 2
Global Const $width_div_2 = $width / 2
Global Const $font_size = Int(($width + $height) / 16)
Global Const $font_size2 = Int(($width + $height) / 32)

Global $hGUI, $graphics, $bitmap, $GDI_Buffer
Global $hBrush, $hFormat, $hFamily, $hFont, $hFont2, $text_color, $text_sin, $text_scroller, $tLayout, $pen, $brush
Global $i, $j, $k, $l
Global $m, $n, $x, $y, $z, $color
Global $arr_text_sin, $letter_distance, $x, $y, $lenght, $end, $scroller_length
Global $dc, $ScreenDc, $gdibitmap
Global $title = "GDI+: Sinus Scroller by UEZ 2009"


$hGUI = GUICreate($title, $width, $height)
GUISetState(@SW_SHOW)
GUISetOnEvent($GUI_EVENT_CLOSE, "_Exit")

_GDIPlus_Startup()
$graphics = _GDIPlus_GraphicsCreateFromHWND($hGUI)
$bitmap = _GDIPlus_BitmapCreateFromGraphics($width, $height, $graphics)
$GDI_Buffer = _GDIPlus_ImageGetGraphicsContext($bitmap)
_GDIPlus_GraphicsSetSmoothingMode($GDI_Buffer, 4)

$ScreenDc = _WinAPI_GetDC($hGUI)
$text_color = 0xEFD0D0FF
$hBrush = _GDIPlus_BrushCreateSolid($text_color)
$hFormat = _GDIPlus_StringFormatCreate()
$hFamily = _GDIPlus_FontFamilyCreate("Arial")
$hFont = _GDIPlus_FontCreate($hFamily, $font_size, 2)
$hFont2 = _GDIPlus_FontCreate($hFamily, $font_size2, 2)
$pen = _GDIPlus_PenCreate(0)
$brush = _GDIPlus_BrushCreateSolid(0)

$text_scroller = "YES, another GDI+ example, SINUS SCROLLER, by UEZ in 01/2009! :-)                                      Let's start... "
$text_sin = "I was inspired by the old good intro school on C64 when I was 15 and did some assembler intros :-). "
$text_sin &= "Greetings to all forum members at www.autoitscript.com and www.autoit.de.  I hope you like it!  ;-)                             The END."
$arr_text_sin = StringSplit($text_sin, "")

Global $stars = 128
Dim $arr_stars_x[$stars]
Dim $arr_stars_y[$stars]
Dim $aFont_Sized[Int($height / 4)]
Global Const $min_size = 4
Global Const $max_size = UBound($aFont_Sized) - 1

For $n = 0 To UBound($aFont_Sized) - 1
	$aFont_Sized[$n] = _GDIPlus_FontCreate($hFamily, $n + $min_size, 0)
Next

For $n = 0 To UBound($arr_stars_y) - 1
	$arr_stars_y[$n] = Random(1, $height - 1, 1)
Next

For $n = 0 To UBound($arr_stars_x) - 1
	$arr_stars_x[$n] = Random(-$width * 1.5, -1, 1)
Next

Dim $arr_star_speed[8]
$arr_star_speed[0] = 1.00
$arr_star_speed[1] = 1.33
$arr_star_speed[2] = 1.66
$arr_star_speed[3] = 2.00
$arr_star_speed[4] = 2.33
$arr_star_speed[5] = 2.66
$arr_star_speed[6] = 3.33
$arr_star_speed[7] = 4.50
_GDIPlus_GraphicsSetSmoothingMode($GDI_Buffer, 2)

$tLayout = _GDIPlus_RectFCreate(0, 0)

Scroller_Ini()

Do
	Sinus_Scroller()
Until False

Func Stars()
	$m = 0
	For $n = 0 To UBound($arr_stars_x) - 1
		Switch $arr_star_speed[$m]
			Case 1.00
				$color = 0xAF888888
			Case 1.33
				$color = 0xBF999999
			Case 1.66
				$color = 0xCFAAAAAA
			Case 2.00
				$color = 0xCFBBBBBB
			Case 2.33
				$color = 0xDFCCCCCC
			Case 2.66
				$color = 0xDFDDDDDD
			Case 3.33
				$color = 0xEFEEEEEE
			Case 4.50
				$color = 0xEFFFFFFF
		EndSwitch
;~ 		If $arr_stars_x[$n] >= 0 And $arr_stars_x[$n] <= $width Then Set_Pixel($arr_stars_x[$n], $arr_stars_y[$n], $color)
		If $arr_stars_x[$n] >= 0 And $arr_stars_x[$n] <= $width Then _GDIPlus_BitmapSetPixel($bitmap, $arr_stars_x[$n], $arr_stars_y[$n], $color)
		$arr_stars_x[$n] += $arr_star_speed[$m]
		$m += 1
		If $m = UBound($arr_star_speed) - 1 Then $m = 0
		If $arr_stars_x[$n] >= $width Then
			$arr_stars_y[$n] = Random(1, $height - 1, 1)
			$arr_stars_x[$n] = 0
		EndIf
	Next
	Sleep(5)
EndFunc   ;==>Stars

Func Sinus_Scroller()
	$letter_distance = 32
	$l = 0
	For $k = $width To 0 - (StringLen($text_sin) * $letter_distance * 1.1) Step -1.5
		_GDIPlus_GraphicsClear($GDI_Buffer, 0xFF000000)
		For $i = 1 To UBound($arr_text_sin) - 1
			$x = $k + ($i * $letter_distance) + ($width_div_2 * Cos($l - ($i * $pi / ATan($i * $pi_div_m170) * - 0.25))) * 0.4
			$y = ($height_div_2 - 1.666 * $font_size2) + ($height * Sin($l - ($i * $pi_div_10))) * 0.35
			$l += 0.00025
			If $x > -$max_size And $x <= $width Then
				DllStructSetData($tLayout, "x", $x)
				DllStructSetData($tLayout, "y", $y)
				$z = Sin(($y * 0.25) * $pi_div_180) * $max_size
				If $z < 0 Then Abs($z)
				_GDIPlus_GraphicsDrawStringEx($GDI_Buffer, $arr_text_sin[$i], $aFont_Sized[$z], $tLayout, $hFormat, $hBrush)
			EndIf
		Next
		Sleep(5)
		Stars()
;~ 		_GDIPlus_GraphicsDrawImageRect($graphics, $bitmap, 0, 0, $width, $height)
		$gdibitmap = _GDIPlus_BitmapCreateHBITMAPFromBitmap($bitmap)
		$dc = _WinAPI_CreateCompatibleDC($ScreenDc)
		_WinAPI_SelectObject($dc, $gdibitmap)
		_WinAPI_DeleteObject($gdibitmap)
		_WinAPI_BitBlt($ScreenDc, 0, 0, $Width, $Height, $dc, 0, 0, 0x00CC0020) ; 0x00CC0020 = $SRCCOPY
		_WinAPI_DeleteDC($dc)
	Next
EndFunc   ;==>Sinus_Scroller

Func Scroller_Ini() ;very simple scroller
	$letter_distance = $font_size
	$lenght = $font_size * 1.666 * 0.36
	$k = $width
	$end = 0
	$scroller_length = StringLen($text_scroller) * $lenght
	$y = -($font_size * 0.2) + ($height_div_2 - $font_size * 0.5) ;center scroller
	AdlibEnable("Scroller", 15)
	While Not $end
		Sleep(10)
	WEnd
EndFunc   ;==>Scroller

Func Scroller()
	_GDIPlus_GraphicsClear($GDI_Buffer, 0xFF000000)
	$x = $k + $letter_distance
	DllStructSetData($tLayout, "x", $x)
	DllStructSetData($tLayout, "y", $y)
	_GDIPlus_GraphicsDrawStringEx($GDI_Buffer, $text_scroller, $hFont, $tLayout, $hFormat, $hBrush)
	_GDIPlus_GraphicsDrawImageRect($graphics, $bitmap, 0, 0, $width, $height)
	$k -= 2
	If -$scroller_length >= $k Then
		$end = 1
		AdlibDisable()
	EndIf
EndFunc

Func _GDIPlus_BitmapSetPixel($hBitmap, $iX, $iY, $iARGB = 0xFF000000)
	Local $aRet
	$aRet = DllCall($ghGDIPDll, "int", "GdipBitmapSetPixel", "hwnd", $hBitmap, "int", $iX, "int", $iY, "dword", $iARGB)
	Return
EndFunc   ;==>_GDIPlus_BitmapSetPixel

;~ Func _GDIPlus_BrushSetSolidColor($hBrush, $iARGB = 0xFF000000)
;~ 	Local $aResult
;~ 	$aResult = DllCall($ghGDIPDll, "int", "GdipSetSolidFillColor", "hwnd", $hBrush, "int", $iARGB)
;~ 	If @error Then Return SetError(@error, @extended, 0)
;~ 	Return SetError($aResult[0], 0, $aResult[0] = 0)
;~ EndFunc   ;==>_GDIPlus_BrushSetSolidColor

Func _Exit()
	_WinAPI_ReleaseDC($hGUI, $ScreenDc)
	_WinAPI_DeleteObject ($gdibitmap)
	For $n = 0 To UBound($aFont_Sized) - 1
		_GDIPlus_FontDispose($aFont_Sized[$n])
	Next
	_GDIPlus_PenDispose($pen)
	_GDIPlus_BrushDispose($hBrush)
	_GDIPlus_BrushDispose($brush)
	_GDIPlus_FontDispose($hFont)
	_GDIPlus_FontDispose($hFont2)
	_GDIPlus_FontFamilyDispose($hFamily)
	_GDIPlus_StringFormatDispose($hFormat)
	_GDIPlus_GraphicsDispose($GDI_Buffer)
	_GDIPlus_BitmapDispose($bitmap)
	_GDIPlus_GraphicsDispose($graphics)
	_GDIPlus_Shutdown()
	Exit
EndFunc   ;==>_Exit


