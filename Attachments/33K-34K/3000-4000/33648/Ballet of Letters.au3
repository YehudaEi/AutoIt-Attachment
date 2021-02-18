;coded by UEZ 2011 build 2011-04-08
#AutoIt3Wrapper_AU3Check_Parameters=-d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6
#AutoIt3Wrapper_Run_Obfuscator=y
#Obfuscator_Parameters=/sf /sv /om /cs=0 /cn=0
#AutoIt3Wrapper_Run_After=del /f /q "%scriptdir%\%scriptfile%_Obfuscated.au3"
#AutoIt3Wrapper_UseUpx=y
#AutoIt3Wrapper_UPX_Parameters=--brute --crp-ms=999999 --all-methods --all-filters
#include <Array.au3>
#include <GDIPlus.au3>
Opt("GUIOnEventMode", 1)

_GDIPlus_Startup()

Global Const $iW = 600
Global Const $iW2 = $iW / 2
Global Const $iH = 600
Global Const $iH2 = $iH / 2

Global $hgui = GUICreate("GDI+ Ballet of Letters by UEZ 2011 Build 2011-04-08", $iW, $iH)
GUISetBkColor(0x000000, $hgui)

Global $hGraphic = _GDIPlus_GraphicsCreateFromHWND($hgui)
Global $hBitmap = _GDIPlus_BitmapCreateFromGraphics($iW, $iH, $hGraphic)
Global $hBackbuffer = _GDIPlus_ImageGetGraphicsContext($hBitmap)
Global $hPen = _GDIPlus_PenCreate(0)

;~ _GDIPlus_GraphicsSetSmoothingMode($hBackbuffer, 2)

Global $sText = " Ballet of Letters by UEZ 2011 #"
Const $sLen = StringLen($sText)
Const $delta_a = Floor(360 / $sLen)
Const $letter_w = 100
Const $letter_w2 = $letter_w / 2
Const $letter_h = 100
Const $letter_h2 = $letter_h / 2
Const $center_x = $iW2 - $letter_w2
Const $center_y = $iH2 - $letter_h2

Const $font = "Impact"
Const $fontsize = $sLen * 1.75
Const $radius = 220
Const $deg = ACos(-1) / 180

Global $aTable[$sLen][12]
Global $j = $sLen / 2, $r, $g, $b, $a, $lW, $lH, $x, $y

For $i = 0 To $sLen - 1 ;generate table
	$aTable[$i][0] = StringMid($sText, $i + 1, 1) ;get next letter
	$aTable[$i][1] = _GDIPlus_BitmapCreateFromGraphics($letter_w, $letter_h, $hGraphic) ;create bitmap
	$aTable[$i][2] = _GDIPlus_ImageGetGraphicsContext($aTable[$i][1]) ;create context of bitmap to draw to bitmap
	$r = 0xFF - Sin($j / 10) * 20
	$g = 0xFF - Sin($j / 10) * 100
	$b = 0xFF - Sin($j / 10) * 220
	$j -= 0.5
	$aTable[$i][3] = _GDIPlus_BrushCreateSolid("0xE0" & Hex($r, 2) & Hex($g, 2) & Hex($b, 2))
	$aTable[$i][4] = _GDIPlus_StringFormatCreate() ;$hFormat
	$aTable[$i][5] = _GDIPlus_FontFamilyCreate($font) ;$hFamily
	$aTable[$i][6] = _GDIPlus_FontCreate($aTable[$i][5], $fontsize) ;$hFont
	$aTable[$i][7] = _GDIPlus_RectFCreate(0, 0, 0, 0) ;$tLayout
	$aTable[$i][8] = _GDIPlus_GraphicsMeasureString($hGraphic, $aTable[$i][0], $aTable[$i][6], $aTable[$i][7], $aTable[$i][4])
	$aTable[$i][9] = _GDIPlus_MatrixCreate() ;create a matrix for each letter
	$aTable[$i][10] = $i * $delta_a ;calculate angle of letter
	$aTable[$i][11] = $radius ;radius
	_GDIPlus_GraphicsSetSmoothingMode($aTable[$i][2], 2)
	DllCall($ghGDIPDll, "uint", "GdipSetTextRenderingHint", "handle", $aTable[$i][2], "int", 4)
;~ 	DllCall($ghGDIPDll, "uint", "GdipSetTextRenderingHint", "handle", $hBackbuffer, "int", 4)

	_GDIPlus_GraphicsClear($aTable[$i][2], 0x00000000)
	;calculated possition of letter to place it in the middle of the graphic
	$a = $aTable[$i][8]
	$lW = DllStructGetData($a[0], "width")
	$lH = DllStructGetData($a[0], "height")
	DllStructSetData($a[0], "x", $letter_w2 - $lW / 2)
	DllStructSetData($a[0], "y", $letter_h2 - $lH / 2)

	;rotate letter
	_GDIPlus_MatrixTranslate($aTable[$i][9], $letter_w2, $letter_h2)
	_GDIPlus_MatrixRotate($aTable[$i][9], -27 + $aTable[$i][10], False)
	_GDIPlus_MatrixTranslate($aTable[$i][9], -$letter_w2, -$letter_h2)
	_GDIPlus_GraphicsSetTransform($aTable[$i][2], $aTable[$i][9])

	;print letter to graphic
	_GDIPlus_GraphicsDrawStringEx($aTable[$i][2], $aTable[$i][0], $aTable[$i][6], $a[0], $aTable[$i][4], $aTable[$i][3])

	;copy letter to main screen in a circle
	$x = $center_x + Cos(-90 + $aTable[$i][10] * $deg) * $aTable[$i][11]
	$y = $center_y + Sin(-90 + $aTable[$i][10] * $deg) * $aTable[$i][11]
	_GDIPlus_GraphicsDrawImage($hBackbuffer, $aTable[$i][1], $x, $y)
Next

Global Const $warpZ = 16
Global Const $units = 200
Global $cycle = 0 ;for color
Global Const  $Z = 0.1
Global $stars[$units][5] ;x,y,z,px,py
Global $cx = $iW2, $cy = $iH2

For $i = 0 To $units - 1
	Reset_Star($i)
Next

GUISetState()

GUISetOnEvent(-3, "_Exit")

While Sleep(10)
	_GDIPlus_GraphicsClear($hBackbuffer, 0x70000000)
	Draw_Stars()
	Rotation()
	_GDIPlus_GraphicsDrawImage($hGraphic, $hBitmap, 0, 0)
WEnd

Func Rotation()
	Local Static $aa = 0
	Local Static $bb = 0
	Local Static $c = 1

	$aa += 0.01
	$bb += 1.5 * $c
	If $bb < -50 Or $bb > 50 Then $c *= -1

	For $i = 0 To $sLen - 1
		_GDIPlus_GraphicsClear($aTable[$i][2], 0x00000000)

		$aTable[$i][10] -= 1.5 * Cos($aa)
		$aTable[$i][11] += -$bb / 8 + Cos($bb ^2* $aa)

		$a = $aTable[$i][8]
		_GDIPlus_MatrixTranslate($aTable[$i][9], $letter_w2, $letter_h2)

		_GDIPlus_MatrixRotate($aTable[$i][9], -1 + Sin($aa) * 15, False)

		_GDIPlus_MatrixTranslate($aTable[$i][9], -$letter_w2, -$letter_h2)
		_GDIPlus_GraphicsSetTransform($aTable[$i][2], $aTable[$i][9])
		_GDIPlus_GraphicsDrawStringEx($aTable[$i][2], $aTable[$i][0], $aTable[$i][6], $a[0], $aTable[$i][4], $aTable[$i][3])

		$x = $center_x + Cos(-90 * (1 + Sin(-$aa / 100)) + $aTable[$i][10] * $deg) * $aTable[$i][11]
		$y = $center_y + Sin(-90 * (1 + Cos($aa /  20)) + $aTable[$i][10] * $deg) * $aTable[$i][11]
		_GDIPlus_GraphicsDrawImage($hBackbuffer, $aTable[$i][1], $x, $y)
	Next
EndFunc   ;==>Rotation1

Func Draw_Stars()
	Local $i, $r, $g, $b, $xx, $yy, $e, $color
	Local Static $ii = -99
	$ii += 0.0075
	$cx = $iW2 + (110 * Cos($ii * 3))
	$cy = $iH2 + (100 * Sin($ii * 4))

	For $i = 0 To $units - 1
		$xx = $stars[$i][0] / $stars[$i][2]
		$yy = $stars[$i][1] / $stars[$i][2]
		$e = 1 + 1 / $stars[$i][2] * 2
		If $stars[$i][3] <> 0 Then
			$r = 0x40 + Sin($i + $cycle) * 50
			$g = 0x40 + Sin($i + $cycle) * 50
			$b = 0x40 + Sin($i + $cycle) * 50
			$color = "0xF0"& Hex($r, 2) & Hex($g, 2) & Hex($b, 2)
			_GDIPlus_PenSetWidth($hPen, $e)
			_GDIPlus_PenSetColor($hPen, $color)
			_GDIPlus_GraphicsDrawRect($hBackbuffer, $xx + $cx, $yy + $cy, $e, $e, $hPen)
		EndIf
		$stars[$i][2] -= $Z
		$stars[$i][3] = $xx
		$stars[$i][4] = $yy
		If $stars[$i][2] < $Z Or $stars[$i][3] > $iW Or $stars[$i][4] > $iH Then Reset_Star($i)
	Next
	$cycle += 0.1
EndFunc

Func Reset_Star($a)
	$stars[$a][0] = (Random(0, 1) * $iW - ($iW / 2)) * $warpZ
	$stars[$a][1] = (Random(0, 1) * $iH - ($iH / 2)) * $warpZ
	$stars[$a][2] = $warpZ
	$stars[$a][3] = 0
	$stars[$a][4] = 0
EndFunc

Func _Exit()
	_GDIPlus_PenDispose($hPen)
	For $i = 0 To $sLen - 1
		_GDIPlus_BitmapDispose($aTable[$i][1])
		_GDIPlus_GraphicsDispose($aTable[$i][2])
		_GDIPlus_BrushDispose($aTable[$i][3])
		_GDIPlus_StringFormatDispose($aTable[$i][4])
		_GDIPlus_FontFamilyDispose($aTable[$i][5])
		_GDIPlus_FontDispose($aTable[$i][6])
		_GDIPlus_MatrixDispose($aTable[$i][9])
	Next
	_GDIPlus_GraphicsDispose($hBackbuffer)
	_GDIPlus_BitmapDispose($hBitmap)
	_GDIPlus_GraphicsDispose($hGraphic)
	_GDIPlus_Shutdown()
	GUIDelete($hgui)
	Exit
EndFunc   ;==>_Exit