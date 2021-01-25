#include <_PixelGetColor.au3> ;download UDF url : http://www.autoitscript.com/forum/index.php?showtopic=63318

HotKeySet('{ESC}', 'Quit'); Press ESC to quit

#Region Capture notepad
ShellExecute('notepad.exe') ;Run notepad
WinWait('[CLASS:Notepad]', '', 3) ;Wait notepad window
WinSetState('[CLASS:Notepad]', '', @SW_MAXIMIZE) ;Maximize notepad window
ControlSetText('[CLASS:Notepad]', '', '[CLASS:Edit; INSTANCE:1]', ' Draw Region example by FireFox') ;Write text to capture

$hgdi32 = DllOpen('gdi32.dll') ;Open gdi32 dll
$hUser32 = DllOpen('user32.dll') ;Open user32 dll

$vDC = _PixelGetColor_CreateDC($hgdi32) ;Create DC
$vRegion = _PixelGetColor_CaptureRegion($vDC, 0, 0, @DesktopWidth, @DesktopHeight, $hgdi32) ;Capture the screen

ProcessClose('notepad.exe') ;Close notepad
#EndRegion Capture notepad
;

#Region Draw capture
For $x = 1 To 250 ;Only draw x text region
	For $y = 45 To 60 ;Only draw y text region
		$sPixelC = _PixelGetColor_GetPixel($vDC, $x, $y, $hgdi32) ;Get Pixel color of $x, $y
		$sBGR = _HexToBGR('0x' & $sPixelC) ;Get BGR color of hexadecimal color
		If $sBGR <> 0xFFFFFF Then ;avoid drawing white color
			_DrawPixel($x + 70, $y + 42, _HexToBGR('0x' & $sPixelC)) ;Draw pixel on screen to $x + 70, $y + 43 with BGR color
		EndIf
	Next
Next
#EndRegion Draw capture
;

#Region Func
Func OnAutoItExit()
	_PixelGetColor_ReleaseRegion($vRegion)
	_PixelGetColor_ReleaseDC($vDC, $hgdi32)
	DllClose($hgdi32)
	DllClose($hUser32)
EndFunc   ;==>OnAutoItExit

Func _HexToBGR($iColor)
	Local $iColorRef = Hex(String($iColor), 6)
	Return '0x' & StringMid($iColorRef, 5, 2) & StringMid($iColorRef, 3, 2) & StringMid($iColorRef, 1, 2)
EndFunc   ;==>_HexToBGR

Func _DrawPixel($iX, $iY, $sColor)
	Local $hDC = DllCall('user32.dll', 'int', 'GetDC', 'hwnd', 0)
	DllCall('gdi32.dll', 'long', 'SetPixel', 'long', $hDC[0], 'long', $iX, 'long', $iY, 'long', $sColor)
	DllCall('user32.dll', 'int', 'ReleaseDC', 'hwnd', 0, 'int', $hDC[0])
EndFunc   ;==>_DrawPixel

Func Quit()
	Exit
EndFunc   ;==>Quit
#EndRegion Func