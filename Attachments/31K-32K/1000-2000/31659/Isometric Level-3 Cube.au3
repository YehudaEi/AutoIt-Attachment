;Idea taken from                         
;Ported to AutoIt by UEZ Build 2010-08-28
#AutoIt3Wrapper_UseUpx=n
#AutoIt3Wrapper_Run_Obfuscator=y
#Obfuscator_Parameters=/sf /sv /om /cs=0 /cn=0
#AutoIt3Wrapper_Run_After=del /f /q "Isometric Level-3 Cube_Obfuscated.au3"
#AutoIt3Wrapper_Run_After=upx.exe --ultra-brute "%out%"
;~ #AutoIt3Wrapper_Run_After=upx.exe --best "%out%"
#include <GDIPlus.au3>
#include <GUIConstantsEx.au3>

Opt("MustDeclareVars", 0x00000001)
Opt("GUIOnEventMode", 0x00000001)

Local $hGUI, $hGraphics, $hBackbuffer, $hBitmap, $hMatrix, $hBuffer, $hContext
Local $w = 1024, $h = 800
; Initialize GDI+
_GDIPlus_Startup()

Local $GUI_text = "GDI+ Isometric Level-3 Cube by UEZ 2010"
$hGUI = GUICreate($GUI_text, $w, $h)
GUISetBkColor(0x101020, $hGUI)
GUISetState()

$hGraphics = _GDIPlus_GraphicsCreateFromHWND($hGUI)
$hBitmap = _GDIPlus_BitmapCreateFromGraphics($w, $h, $hGraphics)
$hBackbuffer = _GDIPlus_ImageGetGraphicsContext($hBitmap)
; Using antialiasing
_GDIPlus_GraphicsSetSmoothingMode($hBackbuffer, 0x00000002)


; Create a Brush object
Local $hBrush = _GDIPlus_BrushCreateSolid()

GUISetOnEvent($GUI_EVENT_CLOSE, "_Exit")

Local $live = 0, $max_cycles = 0x00004CE3 ;19683
Local $aPoints[0x00000005][0x00000002]
$aPoints[0x00000000][0x00000000] = 0x00000004
Local Const $q = $w / 0x0000004E; * 0.166666
Local Const $r = $q / 0x00000002
Local Const $s = $q * 0.853
Local $z = 0x00000001, $time
GUIRegisterMsg(0x00000014, "WM_ERASEBKGND") ;$WM_ERASEBKGND
$time = TimerInit()
Calc()
If Not $live Then _GDIPlus_GraphicsDrawImageRect($hGraphics, $hBitmap, 0x00000000, 0x00000000, $w, $h)
ConsoleWrite("Cycles: " & $z & " in " & Round(TimerDiff($time) / 1000, 2)  & " seconds!" & @CRLF)

While Sleep(200000)
WEnd

Func WM_ERASEBKGND()
	_GDIPlus_GraphicsDrawImageRect($hGraphics, $hBitmap, 0x00000000, 0x00000000, $w, $h)
	Return "GUI_RUNDEFMSG"
EndFunc

Func Calc()
	Local $b, $d, $e, $f, $g, $i, $j, $o, $u
	For $b = 0x00000003 To 0x00000001 Step 0xFFFFFFFF
		For $d = 0x00000003 To 0x00000001 Step 0xFFFFFFFF
			For $e = 0x00000000 To 0x00000002
				For $f = 0x00000000 To 0x00000002
					For $g = 0x00000003 To 0x00000001 Step 0xFFFFFFFF
						For $i = 0x00000003 To 0x00000001 Step 0xFFFFFFFF
							For $j = 0x00000003 To 0x00000001 Step 0xFFFFFFFF
								For $o = 0x00000003 To 0x00000001 Step 0xFFFFFFFF
									For $u = 0x00000000 To 0x00000002
										If 	Not(($j == 0x00000002 And $o == 0x00000002) Or _
												($u == 0x00000001 And $j == 0x00000002) Or _
												($u == 0x00000001 And $o == 0x00000002) Or _
												($g == 0x00000002 And $i == 0x00000002) Or _
												($f == 0x00000001 And $g == 0x00000002) Or _
												($f == 0x00000001 And $i == 0x00000002) Or _
												($b == 0x00000002 And $d == 0x00000002) Or _
												($e == 0x00000001 And $b == 0x00000002) Or _
												($e == 0x00000001 And $d == 0x00000002)) Then Draw($j + $g * 0x00000003 + $d * 0x00000009, $o + $i * 0x00000003 + $b * 0x00000009, $u + $f * 0x00000003 + $e *0x00000009)
										$z += 0x00000001
									Next
								Next
							Next
						Next
					Next
				Next
			Next
		Next
	Next
EndFunc

Func Draw($b, $d, $e)
	Local $dr, $bse, $a = "0xF0"
	$d = $h / 0x00000002 - $q * 0x00000014 + $d * $s * 1.18 - $b * $q / 0x00000002 + $e * $r
	$b = $w / 0x00000002 - $q * 0x00000022 + $b * $s + $e * $s
	_GDIPlus_BrushSetSolidColor($hBrush, $a & "C8C8E8")
	$dr = $d - $r
    $aPoints[0x00000001][0x00000000] = $b
    $aPoints[0x00000001][0x00000001] = $d
    $aPoints[0x00000002][0x00000000] = $b + $s
    $aPoints[0x00000002][0x00000001] = $dr
    $aPoints[0x00000003][0x00000000] = $b
    $aPoints[0x00000003][0x00000001] = $d - $q
    $aPoints[0x00000004][0x00000000] = $b - $s
    $aPoints[0x00000004][0x00000001] = $dr
    _GDIPlus_GraphicsFillPolygon($hBackbuffer, $aPoints, $hBrush)
	For $e = 0x00000002 To 0x00000003
		If $e == 0x00000002 Then
			_GDIPlus_BrushSetSolidColor($hBrush, $a & "696989")
		Else
			_GDIPlus_BrushSetSolidColor($hBrush, $a & "282848")
		EndIf
		$bse = $b + $s * 0xFFFFFFFF ^ $e
		$aPoints[0x00000001][0x00000000] = $b
		$aPoints[0x00000001][0x00000001] = $d
		$aPoints[0x00000002][0x00000000] = $bse
		$aPoints[0x00000002][0x00000001] = $dr
		$aPoints[0x00000003][0x00000000] = $bse
		$aPoints[0x00000003][0x00000001] = $d + $r
		$aPoints[0x00000004][0x00000000] = $b
		$aPoints[0x00000004][0x00000001] = $d + $q
		_GDIPlus_GraphicsFillPolygon($hBackbuffer, $aPoints, $hBrush)
	Next

	If $live Then _GDIPlus_GraphicsDrawImageRect($hGraphics, $hBitmap, 0x00000000, 0x00000000, $w, $h)
	WinSetTitle($hGUI, "", $GUI_text & " / Progress: " & StringFormat("%.2f", 100 * $z / $max_cycles) & " %")
EndFunc

Func _Exit()
	; Clean up
	_GDIPlus_BrushDispose($hBrush)
	_GDIPlus_BitmapDispose($hBitmap)
	_GDIPlus_GraphicsDispose($hBackbuffer)
	_GDIPlus_GraphicsDispose($hGraphics)

	; Uninitialize GDI+
	_GDIPlus_Shutdown()
	GUIDelete($hGUI)
	Exit
EndFunc