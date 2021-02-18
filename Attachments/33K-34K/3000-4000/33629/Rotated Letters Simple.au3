;coded by UEZ 2011 build 2011-04-06
;~ #AutoIt3Wrapper_AU3Check_Parameters=-d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6
#AutoIt3Wrapper_Run_Obfuscator=y
#Obfuscator_Parameters=/sf /sv /om /cs=0 /cn=0
#AutoIt3Wrapper_Run_After=del /f /q "%scriptdir%\%scriptfile%_Obfuscated.au3"
#AutoIt3Wrapper_UseUpx=y
#AutoIt3Wrapper_UPX_Parameters=--brute --crp-ms=999999 --all-methods --all-filters

#include <Array.au3>
#include <GDIPlus.au3>
Opt("GUIOnEventMode", 1)
Opt("MustDeclareVars", 1)

_GDIPlus_Startup()

Global Const $iW = 600
Global Const $iH = 600
Global Const $iW2 = $iW / 2
Global Const $iH2 = $iH / 2

Global Const $hgui = GUICreate("GDI+ Rotated Letters by UEZ 2011 Beta", $iW, $iH)
GUISetBkColor(0x202040, $hgui)
WinSetTrans($hgui, "", 0xFF)
GUISetState()

Global $hGraphic = _GDIPlus_GraphicsCreateFromHWND($hgui)
Global $hBitmap = _GDIPlus_BitmapCreateFromGraphics($iW, $iH, $hGraphic)
Global $hBackbuffer = _GDIPlus_ImageGetGraphicsContext($hBitmap)
_GDIPlus_GraphicsSetSmoothingMode($hBackbuffer, 2)
Global $ps = 4
Global $hPen = _GDIPlus_PenCreate(0xFFFFA000, $ps)
Global $radius = 250
Global $sText = " Rotated Letters by UEZ 2011 Beta #"
Global $hBMP = CreateRotatedLetters($sText, $iW, $iH)

Global $hMatrix = _GDIPlus_MatrixCreate()
_GDIPlus_GraphicsDrawImageRect($hBackbuffer, $hBMP, 0, 0, $iW, $iH)

GUISetOnEvent(-3, "_Exit")
Global $i = 0
While Sleep(10)
	$i -= 0.01
	_GDIPlus_GraphicsClear($hBackbuffer, 0x80202020)
	_GDIPlus_GraphicsDrawImageRect($hBackbuffer, $hBMP, 0, 0, $iW, $iH)
	_GDIPlus_GraphicsDrawEllipse($hBackbuffer, $ps - 2, $ps - 2, $iW - $ps - 2, $iH - $ps - 2, $hPen)
	_GDIPlus_GraphicsDrawEllipse($hBackbuffer, 95, 95, $iW - 2 * 95, $iH - 2 * 95, $hPen)
	_GDIPlus_MatrixTranslate($hMatrix, $iW2, $iH2)
	_GDIPlus_MatrixRotate($hMatrix, Sin($i), False)
	_GDIPlus_MatrixTranslate($hMatrix, -$iW2, -$iH2)
	_GDIPlus_GraphicsSetTransform($hBackbuffer, $hMatrix)
	_GDIPlus_GraphicsDrawImageRect($hGraphic, $hBitmap, 0, 0, $iW, $iH)
WEnd

Func CreateRotatedLetters($sText, $iW, $iH, $fontsize = 60, $radius = 250, $letter_w = 100, $letter_h = 100, $font = "Impact", $rv = 20, $gv = 100, $bv = 240, $start_angle = 0)
	Local Const $iW2 = $iW / 2
	Local Const $iH2 = $iH / 2
	Local Const $sLen = StringLen($sText)
	Local $j = $sLen / 2
	Local Const $delta_a = Floor(360 / $sLen)
	Local Const $letter_w2 = $letter_w / 2
	Local Const $letter_h2 = $letter_h / 2
	Local Const $center_x = $iW2 - $letter_w2
	Local Const $center_y = $iH2 - $letter_h2
	Local Const $deg = ACos(-1) / 180

	Local $aTable[$sLen][12]
	Local $i, $r, $g, $b, $a, $lW, $lH, $x, $y
	Local $hImage = _GDIPlus_BitmapCreateFromScan0($iW, $iH)
	Local $hContext = _GDIPlus_ImageGetGraphicsContext($hImage)
	For $i = 0 To $sLen - 1 ;generate table
		$aTable[$i][0] = StringMid($sText, $i + 1, 1) ;get next letter
		$aTable[$i][1] = _GDIPlus_BitmapCreateFromScan0($letter_w, $letter_h) ;create bitmap
		$aTable[$i][2] = _GDIPlus_ImageGetGraphicsContext($aTable[$i][1]) ;create context of bitmap to draw to bitmap
		$r = 0xFF - Sin($j / 10) * $rv
		$g = 0xFF - Sin($j / 10) * $gv
		$b = 0xFF - Sin($j / 10) * $bv
		$j -= 0.5
		$aTable[$i][3] = _GDIPlus_BrushCreateSolid("0xFF" & Hex($r, 2) & Hex($g, 2) & Hex($b, 2))
		$aTable[$i][4] = _GDIPlus_StringFormatCreate() ;$hFormat
		$aTable[$i][5] = _GDIPlus_FontFamilyCreate($font) ;$hFamily
		$aTable[$i][6] = _GDIPlus_FontCreate($aTable[$i][5], $fontsize) ;$hFont
		$aTable[$i][7] = _GDIPlus_RectFCreate(0, 0, 0, 0) ;$tLayout
		$aTable[$i][8] = _GDIPlus_GraphicsMeasureString($hGraphic, $aTable[$i][0], $aTable[$i][6], $aTable[$i][7], $aTable[$i][4])
		$aTable[$i][9] = _GDIPlus_MatrixCreate() ;create a matrix for each letter
		$aTable[$i][10] = $i * $delta_a + $start_angle ;calculate angle of letter
		$aTable[$i][11] = $radius ;radius
		_GDIPlus_GraphicsSetSmoothingMode($aTable[$i][2], 2)
		DllCall($ghGDIPDll, "uint", "GdipSetTextRenderingHint", "handle", $aTable[$i][2], "int", 3)

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

		;print letter to bitmap
		_GDIPlus_GraphicsDrawStringEx($aTable[$i][2], $aTable[$i][0], $aTable[$i][6], $a[0], $aTable[$i][4], $aTable[$i][3])

		;copy letter to main screen in a circle
		$x = $center_x + Cos(-90 + $aTable[$i][10] * $deg) * $aTable[$i][11]
		$y = $center_y + Sin(-90 + $aTable[$i][10] * $deg) * $aTable[$i][11]
		_GDIPlus_GraphicsDrawImage($hContext, $aTable[$i][1], $x, $y)
	Next

	For $i = 0 To $sLen - 1
		_GDIPlus_BitmapDispose($aTable[$i][1])
		_GDIPlus_GraphicsDispose($aTable[$i][2])
		_GDIPlus_BrushDispose($aTable[$i][3])
		_GDIPlus_StringFormatDispose($aTable[$i][4])
		_GDIPlus_FontFamilyDispose($aTable[$i][5])
		_GDIPlus_FontDispose($aTable[$i][6])
		_GDIPlus_MatrixDispose($aTable[$i][9])
	Next
	_GDIPlus_GraphicsDispose($hContext)
	Return $hImage
EndFunc   ;==>CreateRotatedLetters

Func _GDIPlus_BitmapCreateFromScan0($iWidth, $iHeight, $iStride = 0, $iPixelFormat = 0x0026200A, $pScan0 = 0)
	Local $aResult = DllCall($ghGDIPDll, "uint", "GdipCreateBitmapFromScan0", "int", $iWidth, "int", $iHeight, "int", $iStride, "int", $iPixelFormat, "ptr", $pScan0, "int*", 0)
	If @error Then Return SetError(@error, @extended, 0)
	Return $aResult[6]
EndFunc   ;==>_GDIPlus_BitmapCreateFromScan0

Func _Exit()
	_GDIPlus_MatrixDispose($hMatrix)
	_GDIPlus_GraphicsDispose($hBackbuffer)
	_GDIPlus_BitmapDispose($hBitmap)
	_GDIPlus_BitmapDispose($hBMP)
	_GDIPlus_GraphicsDispose($hGraphic)
	_GDIPlus_Shutdown()
	GUIDelete($hgui)
	Exit
EndFunc   ;==>_Exit