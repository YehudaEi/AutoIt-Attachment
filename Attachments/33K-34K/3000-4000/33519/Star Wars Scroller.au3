;Coded by UEZ 2011 build 2011-03-28
#AutoIt3Wrapper_UseUpx=y
#AutoIt3Wrapper_UPX_Parameters=--brute --crp-ms=999999 --all-methods --all-filters
#AutoIt3Wrapper_Run_Obfuscator=y
#Obfuscator_Parameters=/sf /sv /om /cs=0 /cn=0
#AutoIt3Wrapper_Run_After=del /f /q "%scriptdir%\%scriptfile%_Obfuscated.au3"

#include <GDIPlus.au3>
#include <GUIConstantsEx.au3>
Opt("GuiOnEventMode", 1)

Const $FlatnessDefault = 0.25
Const $width = 800
Const $height = 500
$hGui = GUICreate("Star Wars Scroller by UEZ 2011", $width, $height)
GUISetBkColor(0x000000, $hGui)
If @OSBuild < 7600 Then WinSetTrans($hGui,"", 0xFF) ;workaround for XP machines when alpha blending is activated on _GDIPlus_GraphicsClear() function to avoid slow drawing
_GDIPlus_Startup()
$hGraphics = _GDIPlus_GraphicsCreateFromHWND($hGui)
$hBitmap = _GDIPlus_BitmapCreateFromGraphics($width, $height, $hGraphics)
$hContext = _GDIPlus_ImageGetGraphicsContext($hBitmap)
$hBmp_back = _GDIPlus_BitmapCreateFromGraphics($width, $height, $hGraphics)
For $i = 0 To 1000
	$x = Random(0, $width, 1)
	$y = Random(0, $height, 1)
	$c = Random(0x10, 0xF0, 1)
	DllCall($ghGDIPDll, "uint", "GdipBitmapSetPixel", "hwnd", $hBmp_back, "int", $x, "int", $y, "uint", "0xFF" & Hex($c, 2) & Hex($c, 2) & Hex($c, 2))
Next
_GDIPlus_GraphicsSetSmoothingMode($hContext, 2)
GUISetState()

$hBrush = _GDIPlus_LineBrushCreate(0, 0, 0, $height, 0xFF000000, 0xFFFFFFFF, 0)

$speedy = 10
Const $sy = 1900
Const $dy = 150

$text = "Starwars Scroller|Coded by| | UEZ 2011| |Everything is|Done using| |G D I +| | |Powered by| |AutoIt| | |" &  ChrW(9787)
$aString = StringSplit($text, "|", 2)

Dim $aText[UBound($aString)][3]
For $i = 0 To UBound($aText) - 1
	$aText[$i][0] = $aString[$i]
	$aText[$i][1] = $sy + $i * $dy
Next

$hFamily = _GDIPlus_FontFamilyCreate ("Impact")
$tLayout = _GDIPlus_RectFCreate (0, 0, 0, 0)

$hFont = _GDIPlus_FontCreate ($hFamily, 60, 0)
For $i = 0 To UBound($aText) - 1
	$aText[$i][0] = StringUpper($aText[$i][0])
	$aInfo = _GDIPlus_GraphicsMeasureString($hGraphics, $aText[$i][0], $hFont, $tLayout, 0)
	$aText[$i][2] = Floor($width / 2 - (DllStructGetData($aInfo[0], "Width") / 2))
Next
_GDIPlus_FontDispose ($hFont)

$hPath = _GDIPlus_PathCreate()

Dim $aPoints[5][2] = [	[4, 0], _
										[$width / 2 - $width / 3, 	$height * 0.55], _ 	;x1, y1
										[$width / 2 + $width / 3, 	$height * 0.55], _ 	;x2, y2
										[0, 										$height * 0.85], _ 	;x3, y3
										[$width , 							$height * 0.85]]		;x4, y4

GUISetOnEvent(-3, "_Exit")

$1 = True

While Sleep(30)
	_GDIPlus_GraphicsClear($hContext, 0xF0000000)
	_GDIPlus_GraphicsDrawImageRect($hContext, $hBmp_back, 0, 0, $width, $height)
	For $i = 0 To UBound($aText) - 1
		DllStructSetData($tLayout, "x", $aText[$i][2])
		DllStructSetData($tLayout, "y", $aText[$i][1])
		_GDIPlus_PathAddString($hPath, $aText[$i][0], $tLayout, $hFamily, 0, 80)
		$aText[$i][1] -= $speedy
	Next
 	If $1 Then
		$aWB = _GDIPlus_PathGetWorldBounds($hPath)
		$1 = False
	EndIf
	_GDIPlus_PathWarp($hPath, 0, $aPoints, 0, 0, $width, 1500)
	_GDIPlus_GraphicsFillPath($hContext, $hPath, $hBrush)
	_GDIPlus_PathReset($hPath)
	_GDIPlus_GraphicsDrawImageRect($hGraphics, $hBitmap, 0, 0, $width, $height)
	If $aText[UBound($aText) - 1][1] < $aWB[3] / 16 Then $speedy *= 1.005
	If $aText[UBound($aText) - 1][1]  < $sy * -7 Then
		For $i = 0 To UBound($aText) - 1
			$aText[$i][1] = $sy + $i * $dy
		Next
		$speedy = 10
	EndIf
WEnd

Func _Exit()
	_GDIPlus_FontFamilyDispose ($hFamily)
	_GDIPlus_PathDispose($hPath)
    _GDIPlus_BrushDispose($hBrush)
    _GDIPlus_GraphicsDispose($hContext)
    _GDIPlus_BitmapDispose($hBmp_back)
    _GDIPlus_BitmapDispose($hBitmap)
    _GDIPlus_GraphicsDispose($hGraphics)
    _GDIPlus_Shutdown()
    Exit
EndFunc

#region functions from GDIP.au3
Func _GDIPlus_LineBrushCreate($nX1, $nY1, $nX2, $nY2, $iARGBClr1, $iARGBClr2, $iWrapMode = 0)
	Local $tPointF1, $pPointF1, $tPointF2, $pPointF2, $aResult
	$tPointF1 = DllStructCreate("float;float")
	$pPointF1 = DllStructGetPtr($tPointF1)
	$tPointF2 = DllStructCreate("float;float")
	$pPointF2 = DllStructGetPtr($tPointF2)
	DllStructSetData($tPointF1, 1, $nX1)
	DllStructSetData($tPointF1, 2, $nY1)
	DllStructSetData($tPointF2, 1, $nX2)
	DllStructSetData($tPointF2, 2, $nY2)
	$aResult = DllCall($ghGDIPDll, "uint", "GdipCreateLineBrush", "ptr", $pPointF1, "ptr", $pPointF2, "uint", $iARGBClr1, "uint", $iARGBClr2, "int", $iWrapMode, "int*", 0)
	If @error Then Return SetError(@error, @extended, 0)
	Return $aResult[6]
EndFunc   ;==>_GDIPlus_LineBrushCreate

Func _GDIPlus_PathCreate($iFillMode = 0)
	Local $aResult = DllCall($ghGDIPDll, "uint", "GdipCreatePath", "int", $iFillMode, "int*", 0)
	If @error Then Return SetError(@error, @extended, 0)
	Return $aResult[2]
EndFunc   ;==>_GDIPlus_PathCreate

Func _GDIPlus_PathAddString($hPath, $sString, $tLayout, $hFamily = 0, $iStyle = 0, $nSize = 8.5, $hFormat = 0)
	Local $pLayout, $aResult
	$pLayout = DllStructGetPtr($tLayout)
	$aResult = DllCall($ghGDIPDll, "uint", "GdipAddPathString", "hwnd", $hPath, "wstr", $sString, "int", -1, "hwnd", $hFamily, "int", $iStyle, "float", $nSize, "ptr", $pLayout, "hwnd", $hFormat)
	If @error Then Return SetError(@error, @extended, False)
	Return $aResult[0] = 0
EndFunc   ;==>_GDIPlus_PathAddString

Func _GDIPlus_PathGetWorldBounds($hPath, $hMatrix = 0, $hPen = 0)
	Local $tRectF, $pRectF, $iI, $aRectF[4], $aResult
	$tRectF = DllStructCreate($tagGDIPRECTF)
	$pRectF = DllStructGetPtr($tRectF)
	$aResult = DllCall($ghGDIPDll, "uint", "GdipGetPathWorldBounds", "hwnd", $hPath, "ptr", $pRectF, "hwnd", $hMatrix, "hwnd", $hPen)
	If @error Then Return SetError(@error, @extended, -1)
	If $aResult[0] Then Return -1
	For $iI = 1 To 4
		$aRectF[$iI - 1] = DllStructGetData($tRectF, $iI)
	Next
	Return $aRectF
EndFunc   ;==>_GDIPlus_PathGetWorldBounds

Func _GDIPlus_PathWarp($hPath, $hMatrix, $aPoints, $nX, $nY, $nWidth, $nHeight, $iWarpMode = 0, $nFlatness = $FlatnessDefault)
	Local $iI, $iCount, $pPoints, $tPoints, $aResult
	$iCount = $aPoints[0][0]
	If $iCount <> 3 And $iCount <> 4 Then Return False
	$tPoints = DllStructCreate("float[" & $iCount * 2 & "]")
	$pPoints = DllStructGetPtr($tPoints)
	For $iI = 1 To $iCount
		DllStructSetData($tPoints, 1, $aPoints[$iI][0], ($iI - 1) * 2 + 1)
		DllStructSetData($tPoints, 1, $aPoints[$iI][1], ($iI - 1) * 2 + 2)
	Next
	$aResult = DllCall($ghGDIPDll, "uint", "GdipWarpPath", "hwnd", $hPath, "hwnd", $hMatrix, "ptr", $pPoints, "int", $iCount, "float", $nX, "float", $nY, "float", $nWidth, "float", $nHeight, "int", $iWarpMode, "float", $nFlatness)
	If @error Then Return SetError(@error, @extended, False)
	Return $aResult[0] = 0
EndFunc   ;==>_GDIPlus_PathWarp

Func _GDIPlus_GraphicsFillPath($hGraphics, $hPath, $hBrush = 0)
	Local $iTmpErr, $iTmpExt, $aResult
	__GDIPlus_BrushDefCreate($hBrush)
	$aResult = DllCall($ghGDIPDll, "uint", "GdipFillPath", "hwnd", $hGraphics, "hwnd", $hBrush, "hwnd", $hPath)
	$iTmpErr = @error
	$iTmpExt = @extended
	__GDIPlus_BrushDefDispose()
	If $iTmpErr Then Return SetError($iTmpErr, $iTmpExt, False)
	Return $aResult[0] = 0
EndFunc   ;==>_GDIPlus_GraphicsFillPath

Func _GDIPlus_PathReset($hPath)
	Local $aResult = DllCall($ghGDIPDll, "uint", "GdipResetPath", "hwnd", $hPath)
	If @error Then Return SetError(@error, @extended, False)
	Return $aResult[0] = 0
EndFunc   ;==>_GDIPlus_PathReset

Func _GDIPlus_PathDispose($hPath)
	Local $aResult = DllCall($ghGDIPDll, "uint", "GdipDeletePath", "hwnd", $hPath)
	If @error Then Return SetError(@error, @extended, False)
	Return $aResult[0] = 0
EndFunc   ;==>_GDIPlus_PathDispose
#endregion