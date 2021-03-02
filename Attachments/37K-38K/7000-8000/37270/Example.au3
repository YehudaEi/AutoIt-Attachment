#include <_PixelGetColor.au3>

Dim $testMaxX = 100
Dim $testMaxY = 100

ConsoleWrite("Starting test in field (0,0) to (" & $testMaxX & "," & $testMaxY & ")" & @CRLF)

ToolTip(1)

$hDll = DllOpen("gdi32.dll")
$vDC = _PixelGetColor_CreateDC($hDll)

ToolTip(2)

$a = TimerInit()
CaptureNative($testMaxX, $testMaxY)
$a1 = TimerDiff($a)

ToolTip(3)

$b = TimerInit()
CaptureUDF($testMaxX, $testMaxY)
$b1 = TimerDiff($b)

ToolTip(4)

_PixelGetColor_ReleaseDC($vDC, $hDll)
DllClose($hDll)

ToolTip(5)

ConsoleWrite("Native: " & $a1 & @CRLF)
ConsoleWrite("UDF   : " & $b1 & @CRLF)

Func CaptureNative($xmax, $ymax)
	For $x = 0 To $xmax
		For $y = 0 To $ymax
			PixelGetColor($x, $y)
		Next
	Next
EndFunc   ;==>CaptureNative

Func CaptureUDF($xmax, $ymax)
	$vRegion = _PixelGetColor_CaptureRegion($vDC, 0, 0, $xmax, $ymax, False, $hDll)
	For $x = 0 To $xmax
		For $y = 0 To $ymax
			_PixelGetColor_GetPixelRaw($vDC, $x, $y, $hDll)
		Next
	Next
	_PixelGetColor_ReleaseRegion($vRegion)
EndFunc   ;==>CaptureUDF