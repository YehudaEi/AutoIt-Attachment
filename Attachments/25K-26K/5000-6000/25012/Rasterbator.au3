#include <ComboConstants.au3>
#include <EditConstants.au3>
#include <GDIPlusConstants.au3>
#include <WindowsConstants.au3>
#include <GUIConstantsEx.au3>
#include <SliderConstants.au3>
#include <Misc.au3>
#include <GDIPlus.au3>

Opt("MustDeclareVars", 1)
Opt("GUIOnEventMode", 1)

Global $libhpdfdll = DllOpen(@ScriptDir & "\libhpdf.dll")
If $libhpdfdll = -1 Then
	MsgBox(0, "ERROR", "Error loading libhpdf.dll")
	Exit
EndIf

Global $hImage, $iWidth, $iHeight, $iImageX, $iImageY, $iImageW, $iImageH, $iImageS, $CustomColor = 0xFF0000

_GDIPlus_Startup()
Global $hBrush = _GDIPlus_BrushCreateSolid(0xFFFFFFFF)

Global $hGui = GUICreate("Autoit Rasterbator Clone by Eukalyptus", 400, 685)
GUISetOnEvent($GUI_EVENT_CLOSE, "_Exit")
GUICtrlCreateButton("Load Source Image", 10, 10, 120, 20)
GUICtrlSetOnEvent(-1, "_LoadImage")
GUICtrlCreateLabel("", 10, 35, 380, 280)
GUICtrlSetBkColor(-1, 0xFFFFFF)
GUICtrlSetState(-1, $GUI_DISABLE)
GUICtrlCreateLabel("PaperSize:", 10, 333, 50, 20)
Global $hPaperWidth = GUICtrlCreateInput("210", 70, 330, 40, 20, $ES_NUMBER)
GUICtrlSetOnEvent(-1, "_ReDrawPreview")
GUICtrlCreateLabel("x", 115, 333, 10, 20)
Global $hPaperHeight = GUICtrlCreateInput("297", 130, 330, 40, 20, $ES_NUMBER)
GUICtrlSetOnEvent(-1, "_ReDrawPreview")
GUICtrlCreateLabel("mm", 175, 333, 20, 20)
GUICtrlCreateCombo("", 210, 330, 180, 20, $CBS_DROPDOWNLIST)
GUICtrlSetOnEvent(-1, "_SetPaperSize")
GUICtrlSetData(-1, "US LETTER PORTRAIT|US LETTER LANDSCAPE|US LEGAL PORTRAIT|US LEGAL LANDSCAPE|A3 PORTRAIT|A3 LANDSCAPE|A4 PORTRAIT|A4 LANDSCAPE|A5 PORTRAIT|A5 LANDSCAPE", "A4 PORTRAIT")
Global $hPaperCount = GUICtrlCreateInput("5", 100, 365, 35, 20, $ES_NUMBER)
GUICtrlSetOnEvent(-1, "_ReDrawPreview")
GUICtrlCreateUpdown(-1)
GUICtrlSetLimit(-1, 50, 1)
GUICtrlCreateLabel("Sheets /", 145, 368, 50, 20)
Global $hPaperCountDir = GUICtrlCreateCombo("", 200, 365, 60, 20, $CBS_DROPDOWNLIST)
GUICtrlSetOnEvent(-1, "_ReDrawPreview")
GUICtrlSetData(-1, "Width|Height", "Width")
GUICtrlCreateLabel("OutputSize: ", 10, 368, 60, 20)
Global $hOutPutSize = GUICtrlCreateLabel("", 80, 393, 300, 20)
GUICtrlCreateLabel("Optional Scale to Papersize:", 10, 428, 140, 20)
Global $hScale = GUICtrlCreateSlider(160, 415, 150, 30, BitOR($TBS_LEFT, $TBS_AUTOTICKS))
GUICtrlSetOnEvent(-1, "_SetScale")
GUICtrlSetLimit(-1, 100, 10)
GUICtrlSendMsg(-1, $TBM_SETTICFREQ, 10, 0)
GUICtrlSetData(-1, 90)
Global $hScaleInfo = GUICtrlCreateLabel("0.9", 330, 428, 50, 20)
GUICtrlCreateLabel("DotSize:", 10, 463, 50, 20)
Global $hDotSize = GUICtrlCreateInput("5", 100, 460, 35, 20, $ES_NUMBER)
GUICtrlCreateUpdown(-1)
GUICtrlSetLimit(-1, 50, 1)
GUICtrlCreateLabel("mm", 140, 465, 50, 20)
Global $hOutline = GUICtrlCreateCheckbox("Draw Outline", 200, 460, 100, 20)
GUICtrlCreateLabel("DotColor:", 10, 498, 50, 20)
GUIStartGroup()
Global $hColorBlack = GUICtrlCreateRadio("Black", 100, 495, 50, 20)
Global $hColorCustom = GUICtrlCreateRadio("Custom:", 100, 520, 60, 20)
Global $hColorMulti = GUICtrlCreateRadio("Original Colors", 100, 545, 100, 20)
GUICtrlSetState(-1, $GUI_CHECKED)
Global $hCustomColor = GUICtrlCreateLabel("", 180, 520, 30, 20)
GUICtrlSetBkColor(-1, 0xFF0000)
GUICtrlCreateButton("Select Color", 230, 521, 80, 18)
GUICtrlSetOnEvent(-1, "_SelectColor")
GUICtrlCreateLabel("Output File:", 10, 583, 80, 20)
Global $hOutputFile = GUICtrlCreateInput("", 100, 580, 290, 20)
GUICtrlCreateButton("Rasterbate", 150, 615, 100, 30)
GUICtrlSetOnEvent(-1, "_Rasterbate")
Global $hProgress = GUICtrlCreateProgress(10, 655, 380, 20)
GUISetState()
Global $hGraphics = _GDIPlus_GraphicsCreateFromHWND($hGui)
GUIRegisterMsg($WM_PAINT, "_WM_PAINT")
GUIRegisterMsg($WM_ACTIVATE, "_WM_ACTIVATE")

While 1
	Sleep(100)
WEnd

Func _LoadImage()
	Local $sFilename, $sPdfFile, $Cnt = 0
	$sFilename = FileOpenDialog("Select Image...", @WorkingDir, "(*.bmp;*.jpg;*.tif)", 1)
	If @error Then Return
	$hImage = _GDIPlus_ImageLoadFromFile($sFilename)
	If @error Then Return
	$iWidth = _GDIPlus_ImageGetWidth($hImage)
	$iHeight = _GDIPlus_ImageGetHeight($hImage)
	If 380 / $iWidth < 280 / $iHeight Then
		$iImageS = 380 / $iWidth
	Else
		$iImageS = 280 / $iHeight
	EndIf
	$iImageW = $iWidth * $iImageS
	$iImageH = $iHeight * $iImageS
	$iImageX = 200 - $iImageW / 2
	$iImageY = 175 - $iImageH / 2
	$sPdfFile = StringLeft($sFilename, StringInStr($sFilename, ".", 0, -1) - 1)
	If FileExists($sPdfFile & ".pdf") Then
		While 1
			$Cnt += 1
			If FileExists($sPdfFile & "_" & String($Cnt) & ".pdf") = 0 Then ExitLoop
		WEnd
		GUICtrlSetData($hOutputFile, $sPdfFile & "_" & String($Cnt) & ".pdf")
	Else
		GUICtrlSetData($hOutputFile, $sPdfFile & ".pdf")
	EndIf
	_ReDrawPreview()
EndFunc   ;==>_LoadImage

Func _SetScale()
	GUICtrlSetData($hScaleInfo, GUICtrlRead($hScale) / 100)
EndFunc   ;==>_SetScale

Func _ReDrawPreview()
	_WM_Paint($hGui, 0, 0, 0)
EndFunc   ;==>_ReDrawPreview

Func _SelectColor()
	Local $Color
	$Color = _ChooseColor(2, $CustomColor, 2, $hGui)
	If @error Then Return
	$CustomColor = $Color
	If $CustomColor = 0xFFFFFF Then $CustomColor -= 0x000001
	GUICtrlSetBkColor($hCustomColor, $CustomColor)
	GUICtrlSetState($hColorCustom, $GUI_CHECKED)
EndFunc   ;==>_SelectColor

Func _WM_PAINT($hWnd, $Msg, $wParam, $lParam)
	If $hImage = 0 Then Return
	Local $iPageW = _mm2px(GUICtrlRead($hPaperWidth))
	Local $iPageH = _mm2px(GUICtrlRead($hPaperHeight))
	Local $iPageC = GUICtrlRead($hPaperCount)
	Local $iPageCX, $iPageCY
	_GDIPlus_GraphicsFillRect($hGraphics, 10, 35, 380, 280, $hBrush)
	_GDIPlus_GraphicsDrawImageRect($hGraphics, $hImage, $iImageX, $iImageY, $iImageW, $iImageH)
	Switch GUICtrlRead($hPaperCountDir)
		Case "Width"
			$iPageCX = $iWidth / $iPageC
			$iPageCY = $iWidth / $iPageC * $iPageH / $iPageW
		Case Else
			$iPageCY = $iHeight / $iPageC
			$iPageCX = $iHeight / $iPageC * $iPageW / $iPageH
	EndSwitch
	For $i = 0 To $iWidth Step Round($iPageCX)
		_GDIPlus_GraphicsDrawLine($hGraphics, $iImageX + $i * $iImageS, $iImageY, $iImageX + $i * $iImageS, $iImageY + $iImageH)
	Next
	For $j = 0 To $iHeight Step Round($iPageCY)
		_GDIPlus_GraphicsDrawLine($hGraphics, $iImageX, $iImageY + $j * $iImageS, $iImageX + $iImageW, $iImageY + $j * $iImageS)
	Next
	$iPageCX = Ceiling($iWidth / $iPageCX)
	$iPageCY = Ceiling($iHeight / $iPageCY)
	GUICtrlSetData($hOutPutSize, $iPageCX & " x " & $iPageCY & " = " & $iPageCX * $iPageCY & " sheets   Size: " & _px2mm($iPageW * $iPageCX) & "mm x " & _px2mm($iPageH * $iPageCY) & "mm")
EndFunc   ;==>_WM_PAINT

Func _WM_ACTIVATE($hWnd, $Msg, $wParam, $lParam)
	Sleep(10)
	_ReDrawPreview()
	Return $GUI_RUNDEFMSG
EndFunc   ;==>_WM_ACTIVATE

Func _SetPaperSize()
	Local $iX = GUICtrlRead($hPaperWidth), $iY = GUICtrlRead($hPaperHeight)
	Switch GUICtrlRead(@GUI_CtrlId)
		Case "US LETTER PORTRAIT"
			$iX = 216
			$iY = 279
		Case "US LETTER LANDSCAPE"
			$iX = 279
			$iY = 216
		Case "US LEGAL PORTRAIT"
			$iX = 216
			$iY = 355
		Case "US LEGAL LANDSCAPE"
			$iX = 355
			$iY = 216
		Case "A3 PORTRAIT"
			$iX = 297
			$iY = 420
		Case "A3 LANDSCAPE"
			$iX = 420
			$iY = 297
		Case "A4 PORTRAIT"
			$iX = 210
			$iY = 297
		Case "A4 LANDSCAPE"
			$iX = 297
			$iY = 210
		Case "A5 PORTRAIT"
			$iX = 148
			$iY = 210
		Case "A5 LANDSCAPE"
			$iX = 210
			$iY = 148
	EndSwitch
	GUICtrlSetData($hPaperWidth, $iX)
	GUICtrlSetData($hPaperHeight, $iY)
	_ReDrawPreview()
EndFunc   ;==>_SetPaperSize

Func _mm2px($imm)
	Return Round($imm * 72 / 25.4)
EndFunc   ;==>_mm2px

Func _px2mm($imm)
	Return Round($imm * 25.4 / 72, 1)
EndFunc   ;==>_px2mm

Func _Rasterbate()
	If $hImage = 0 Then Return
	Opt("GUIOnEventMode", 0)
	Local $iDotSize = GUICtrlRead($hDotSize)
	Local $iPageW = _mm2px(GUICtrlRead($hPaperWidth))
	Local $iPageH = _mm2px(GUICtrlRead($hPaperHeight))
	Local $iPageC = GUICtrlRead($hPaperCount)
	Local $iPageDir = 0
	If GUICtrlRead($hPaperCountDir) = "Height" Then $iPageDir = 1
	Local $Color = $CustomColor
	If GUICtrlRead($hColorBlack) = 1 Then $Color = 0x000000
	If GUICtrlRead($hColorMulti) = 1 Then $Color = 0xFFFFFF
	Local $bOutLine = False
	If GUICtrlRead($hOutline) = 1 Then $bOutLine = True
	Local $sPdfFile = GUICtrlRead($hOutputFile)
	Local $nScale = GUICtrlRead($hScale) / 100
	Local $hPdf = _HPDF_New()
	_Rasterize($hPdf, $iPageW, $iPageH, $hImage, $iWidth, $iHeight, $iPageC, $iPageDir, $nScale, $iDotSize, $Color, $bOutLine, $hProgress)
	_HPDF_SaveToFile($hPdf, $sPdfFile)
	_HPDF_Free($hPdf)
	GUICtrlSetData($hProgress, 0)
	Opt("GUIOnEventMode", 1)
	WinActivate($hGui)
EndFunc   ;==>_Rasterbate

Func _Rasterize($hPdf, $iPageW, $iPageH, $hBitmap, $iWidth, $iHeight, $iStep, $iDir, $nScale, $iRaster, $Color, $bOutLine = False, $hProgress = 0)
	$iRaster = $iRaster * 72 / 25.4
	Switch $iDir
		Case 0
			$iRaster = $iRaster / ($iStep * $iPageW / $iWidth)
		Case Else
			$iRaster = $iRaster / ($iStep * $iPageH / $iHeight)
	EndSwitch
	Local $BitmapData = _GDIPlus_BitmapLockBits($hBitmap, 0, 0, $iWidth, $iHeight, $GDIP_ILMREAD, $GDIP_PXF24RGB)
	Local $Stride = DllStructGetData($BitmapData, "Stride")
	Local $Width = DllStructGetData($BitmapData, "Width")
	Local $Height = DllStructGetData($BitmapData, "Height")
	Local $PixelFormat = DllStructGetData($BitmapData, "PixelFormat")
	Local $Scan0 = DllStructGetData($BitmapData, "Scan0")
	Local $pPixels = $Scan0
	Local $SquareX = Ceiling($Width / $iRaster), $SquareY = Ceiling($Height / $iRaster)
	Local $Row, $Col, $Cnt = 0, $Luma = 0, $Red, $Green, $Blue, $Size, $iRRaster = Ceiling($iRaster)
	Local $PixelData = DllStructCreate("ubyte lData[" & (Abs($Stride) * $Height - 1) & "]", $Scan0)
	Local $iStepW, $iStepH, $nPageScale = 1, $hPage, $iStepPageX, $iStepPageY
	Local $iPageCnt, $iPageDone = 0
	Switch $iDir
		Case 0
			$iStepW = Ceiling($SquareX / $iStep)
			$iStepH = Ceiling($SquareX / $iStep * $iPageH / $iPageW)
			$iStepPageX = Ceiling(($Width / $iRaster) / $iStepW)
			$iStepPageY = Ceiling(($Height / $iRaster) / $iStepH)
		Case 1
			$iStepH = Ceiling($SquareY / $iStep)
			$iStepW = Ceiling($SquareY / $iStep * $iPageW / $iPageH)
			$iStepPageX = Ceiling(($Width / $iRaster) / $iStepW)
			$iStepPageY = Ceiling(($Height / $iRaster) / $iStepH)
	EndSwitch
	If $iPageH / ($iStepH * $iRaster) < $iPageW / ($iStepW * $iRaster) Then
		$nPageScale = $iPageH / ($iStepH * $iRaster)
	Else
		$nPageScale = $iPageW / ($iStepW * $iRaster)
	EndIf
	$iPageCnt = $iStepPageX * $iStepPageY
	For $iStepY = 0 To $iStepPageY - 1
		For $iStepX = 0 To $iStepPageX - 1
			$hPage = _HPDF_AddPage($hPdf)
			_HPDF_Page_SetWidth($hPage, $iPageW)
			_HPDF_Page_SetHeight($hPage, $iPageH)
			_HPDF_Page_SetRotate($hPage, 180)
			_HPDF_Page_Concat($hPage, -1 * $nScale, 0, 0, 1 * $nScale, $iPageW - ($iPageW * (1 - $nScale) / 2), $iPageH * (1 - $nScale) / 2)
			_HPDF_Page_SetLineWidth($hPage, 0)
			For $iPosY = -1 To $iStepH
				GUICtrlSetData($hProgress, Round($iPageDone * 100 / $iPageCnt + ($iPosY * 100 / $iStepH) / $iPageCnt))
				If $iStepY * $iStepH * $iRaster + $iPosY * $iRaster + $iRaster > $Height Then ExitLoop
				If $iStepY * $iStepH * $iRaster + $iPosY * $iRaster < 0 Then ContinueLoop
				For $iPosX = -1 To $iStepW
					If $iStepX * $iStepW * $iRaster + $iPosX * $iRaster + $iRaster > $Width Then ExitLoop
					If $iStepX * $iStepW * $iRaster + $iPosX * $iRaster < 0 Then ContinueLoop
					$Luma = 0
					$Cnt = 0
					$Red = 0
					$Green = 0
					$Blue = 0
					For $Row = 0 To $iRRaster - 1
						For $Col = 0 To $iRRaster - 1
							Switch $Color
								Case 0xFFFFFF
									$Red += DllStructGetData($PixelData, 1, Round($iStepY * $iStepH * $iRaster + $iPosY * $iRaster + $Row) * $Stride + Round($iStepX * $iStepW * $iRaster + $iPosX * $iRaster + $Col) * 3 + 3)
									$Green += DllStructGetData($PixelData, 1, Round($iStepY * $iStepH * $iRaster + $iPosY * $iRaster + $Row) * $Stride + Round($iStepX * $iStepW * $iRaster + $iPosX * $iRaster + $Col) * 3 + 2)
									$Blue += DllStructGetData($PixelData, 1, Round($iStepY * $iStepH * $iRaster + $iPosY * $iRaster + $Row) * $Stride + Round($iStepX * $iStepW * $iRaster + $iPosX * $iRaster + $Col) * 3 + 1)
								Case Else
									$Red = DllStructGetData($PixelData, 1, Round($iStepY * $iStepH * $iRaster + $iPosY * $iRaster + $Row) * $Stride + Round($iStepX * $iStepW * $iRaster + $iPosX * $iRaster + $Col) * 3 + 3)
									$Green = DllStructGetData($PixelData, 1, Round($iStepY * $iStepH * $iRaster + $iPosY * $iRaster + $Row) * $Stride + Round($iStepX * $iStepW * $iRaster + $iPosX * $iRaster + $Col) * 3 + 2)
									$Blue = DllStructGetData($PixelData, 1, Round($iStepY * $iStepH * $iRaster + $iPosY * $iRaster + $Row) * $Stride + Round($iStepX * $iStepW * $iRaster + $iPosX * $iRaster + $Col) * 3 + 1)
									$Luma += $Red * 0.3 + $Green * 0.59 + $Blue * 0.11
							EndSwitch
							$Cnt += 1
						Next
					Next
					Switch $Color
						Case 0xFFFFFF
							$Luma = $Red * 0.3 + $Green * 0.59 + $Blue * 0.11
							$Size = ((0xFF - ($Luma / $Cnt)) * $iRaster / 0xAF)
							_WritePdfData($hPage, ($iPosX * $iRaster + $iRaster / 2) * $nPageScale, ($iPosY * $iRaster + $iRaster / 2) * $nPageScale, $Size * $nPageScale, $Red / $Cnt / 0xFF, $Green / $Cnt / 0xFF, $Blue / $Cnt / 0xFF)
						Case Else
							$Size = ((0xFF - ($Luma / $Cnt)) * $iRaster / 0xAF)
							_WritePdfData($hPage, ($iPosX * $iRaster + $iRaster / 2) * $nPageScale, ($iPosY * $iRaster + $iRaster / 2) * $nPageScale, $Size * $nPageScale, BitAND(BitShift($Color, 16), 0xFF) / 0xFF, BitAND(BitShift($Color, 8), 0xFF) / 0xFF, BitAND($Color, 0xFF) / 0xFF)
					EndSwitch
				Next
			Next
			If $iStepY > 0 Or $iStepY < $iStepPageY - 1 Or $iStepX > 0 Or $iStepX < $iStepPageX - 1 Then _HPDF_Page_SetRGBFill($hPage, 1, 1, 1)
			If $iStepY > 0 Then _HPDF_Page_Rectangle($hPage, -$iRaster * 2 * $nPageScale, -$iRaster * 2 * $nPageScale, ($iStepW * $iRaster + $iRaster * 4) * $nPageScale, $iRaster * 2 * $nPageScale)
			If $iStepY < $iStepPageY - 1 Then _HPDF_Page_Rectangle($hPage, -$iRaster * 2 * $nPageScale, $iStepH * $iRaster * $nPageScale, ($iStepW * $iRaster + $iRaster * 4) * $nPageScale, $iRaster * 2 * $nPageScale)
			If $iStepX > 0 Then _HPDF_Page_Rectangle($hPage, -$iRaster * 2 * $nPageScale, -$iRaster * 2 * $nPageScale, $iRaster * 2 * $nPageScale, ($iStepH * $iRaster + $iRaster * 4) * $nPageScale)
			If $iStepX < $iStepPageX - 1 Then _HPDF_Page_Rectangle($hPage, $iStepW * $iRaster * $nPageScale, -$iRaster * 2 * $nPageScale, $iRaster * 2 * $nPageScale, ($iStepH * $iRaster + $iRaster * 4) * $nPageScale)
			If $iStepY > 0 Or $iStepY < $iStepPageY - 1 Or $iStepX > 0 Or $iStepX < $iStepPageX - 1 Then _HPDF_Page_Fill($hPage)
			If $bOutLine = True Then
				If $iStepX > 0 Then _DrawLineVertikal($hPage, 0, 0, $iStepH * $iRaster * $nPageScale)
				If $iStepX < $iStepPageX - 1 Then _DrawLineVertikal($hPage, $iStepW * $iRaster * $nPageScale, 0, $iStepH * $iRaster * $nPageScale)
				If $iStepY > 0 Then _DrawLineHorizontal($hPage, 0, 0, $iStepW * $iRaster * $nPageScale)
				If $iStepY < $iStepPageY - 1 Then _DrawLineHorizontal($hPage, 0, $iStepH * $iRaster * $nPageScale, $iStepW * $iRaster * $nPageScale)
			EndIf
			$iPageDone += 1
		Next
	Next
	GUICtrlSetData($hProgress, 100)
	_GDIPlus_BitmapUnlockBits($hBitmap, $BitmapData)
EndFunc   ;==>_Rasterize

Func _WritePdfData($hPage, $iX, $iY, $iD, $nR, $nG, $nB)
	_HPDF_Page_SetRGBFill($hPage, $nR, $nG, $nB)
	_HPDF_Page_Circle($hPage, $iX, $iY, $iD / 2)
	_HPDF_Page_Fill($hPage)
EndFunc   ;==>_WritePdfData

Func _DrawLineHorizontal($hPage, $iX, $iY, $iW)
	Local $j
	For $i = $iX To $iW Step 10
		$j = $i
		If $j > $iW - 10 Then $j = $iW - 10
		_HPDF_Page_SetRGBStroke($hPage, 1, 1, 0)
		_HPDF_Page_MoveTo($hPage, $j, $iY)
		_HPDF_Page_LineTo($hPage, $j + 5, $iY)
		_HPDF_Page_Stroke($hPage)
		_HPDF_Page_SetRGBStroke($hPage, 0, 0, 0)
		_HPDF_Page_MoveTo($hPage, $j + 5, $iY)
		_HPDF_Page_LineTo($hPage, $j + 10, $iY)
		_HPDF_Page_Stroke($hPage)
	Next
EndFunc   ;==>_DrawLineHorizontal

Func _DrawLineVertikal($hPage, $iX, $iY, $iW)
	Local $j
	For $i = $iY To $iW Step 10
		$j = $i
		If $j > $iW - 10 Then $j = $iW - 10
		_HPDF_Page_SetRGBStroke($hPage, 1, 1, 0)
		_HPDF_Page_MoveTo($hPage, $iX, $j)
		_HPDF_Page_LineTo($hPage, $iX, $j + 5)
		_HPDF_Page_Stroke($hPage)
		_HPDF_Page_SetRGBStroke($hPage, 0, 0, 0)
		_HPDF_Page_MoveTo($hPage, $iX, $j + 5)
		_HPDF_Page_LineTo($hPage, $iX, $j + 10)
		_HPDF_Page_Stroke($hPage)
	Next
EndFunc   ;==>_DrawLineVertikal

Func _HPDF_Page_SetRotate($hPage, $iAngle)
	Local $aReturn
	$aReturn = DllCall($libhpdfdll, "int", "HPDF_Page_SetRotate", "ptr", $hPage, "uint", $iAngle)
	If @error Then Return SetError(@error, @extended, 0)
	Return $aReturn[0]
EndFunc   ;==>_HPDF_Page_SetRotate

Func _HPDF_Page_Concat($hPage, $a, $b, $c, $d, $X, $Y)
	Local $aReturn
	$aReturn = DllCall($libhpdfdll, "int", "HPDF_Page_Concat", "ptr", $hPage, "float", $a, "float", $b, "float", $c, "float", $d, "float", $X, "float", $Y)
	If @error Then Return SetError(@error, @extended, 0)
	Return $aReturn[0]
EndFunc   ;==>_HPDF_Page_Concat

Func _HPDF_SetPageMode($hPage, $iMode)
	Local $aReturn
	$aReturn = DllCall($libhpdfdll, "int", "HPDF_SetPageMode", "ptr", $hPage, "dword", $iMode)
	If @error Then Return SetError(@error, @extended, 0)
	Return $aReturn[0]
EndFunc   ;==>_HPDF_SetPageMode

Func _HPDF_Page_Stroke($hPage)
	Local $aReturn
	$aReturn = DllCall($libhpdfdll, "int", "HPDF_Page_Stroke", "ptr", $hPage)
	If @error Then Return SetError(@error, @extended, 0)
	Return $aReturn[0]
EndFunc   ;==>_HPDF_Page_Stroke

Func _HPDF_Page_SetRGBStroke($hPage, $nRed, $nGreen, $nBlue)
	Local $aReturn
	$aReturn = DllCall($libhpdfdll, "int", "HPDF_Page_SetRGBStroke", "ptr", $hPage, "float", $nRed, "float", $nGreen, "float", $nBlue)
	If @error Then Return SetError(@error, @extended, 0)
	Return $aReturn[0]
EndFunc   ;==>_HPDF_Page_SetRGBStroke

Func _HPDF_Page_Fill($hPage)
	Local $aReturn
	$aReturn = DllCall($libhpdfdll, "int", "HPDF_Page_Fill", "ptr", $hPage)
	If @error Then Return SetError(@error, @extended, 0)
	Return $aReturn[0]
EndFunc   ;==>_HPDF_Page_Fill

Func _HPDF_Page_SetRGBFill($hPage, $nRed, $nGreen, $nBlue)
	Local $aReturn
	$aReturn = DllCall($libhpdfdll, "int", "HPDF_Page_SetRGBFill", "ptr", $hPage, "float", $nRed, "float", $nGreen, "float", $nBlue)
	If @error Then Return SetError(@error, @extended, 0)
	Return $aReturn[0]
EndFunc   ;==>_HPDF_Page_SetRGBFill

Func _HPDF_Page_MoveTo($hPage, $nX, $nY)
	Local $aReturn
	$aReturn = DllCall($libhpdfdll, "int", "HPDF_Page_MoveTo", "ptr", $hPage, "float", $nX, "float", $nY)
	If @error Then Return SetError(@error, @extended, 0)
	Return $aReturn[0]
EndFunc   ;==>_HPDF_Page_MoveTo

Func _HPDF_Page_LineTo($hPage, $nX, $nY)
	Local $aReturn
	$aReturn = DllCall($libhpdfdll, "int", "HPDF_Page_LineTo", "ptr", $hPage, "float", $nX, "float", $nY)
	If @error Then Return SetError(@error, @extended, 0)
	Return $aReturn[0]
EndFunc   ;==>_HPDF_Page_LineTo

Func _HPDF_Page_SetLineWidth($hPage, $nW)
	Local $aReturn
	$aReturn = DllCall($libhpdfdll, "int", "HPDF_Page_SetLineWidth", "ptr", $hPage, "float", $nW)
	If @error Then Return SetError(@error, @extended, 0)
	Return $aReturn[0]
EndFunc   ;==>_HPDF_Page_SetLineWidth

Func _HPDF_Page_Rectangle($hPage, $nX, $nY, $nW, $nH)
	Local $aReturn
	$aReturn = DllCall($libhpdfdll, "int", "HPDF_Page_Rectangle", "ptr", $hPage, "float", $nX, "float", $nY, "float", $nW, "float", $nH)
	If @error Then Return SetError(@error, @extended, 0)
	Return $aReturn[0]
EndFunc   ;==>_HPDF_Page_Rectangle

Func _HPDF_Page_Circle($hPage, $nX, $nY, $nRadius)
	Local $aReturn
	$aReturn = DllCall($libhpdfdll, "int", "HPDF_Page_Circle", "ptr", $hPage, "float", $nX, "float", $nY, "float", $nRadius)
	If @error Then Return SetError(@error, @extended, 0)
	Return $aReturn[0]
EndFunc   ;==>_HPDF_Page_Circle

Func _HPDF_Page_SetWidth($hPage, $nWidth)
	Local $aReturn
	$aReturn = DllCall($libhpdfdll, "int", "HPDF_Page_SetWidth", "ptr", $hPage, "float", $nWidth)
	If @error Then Return SetError(@error, @extended, 0)
	Return $aReturn[0]
EndFunc   ;==>_HPDF_Page_SetWidth

Func _HPDF_Page_SetHeight($hPage, $nHeight)
	Local $aReturn
	$aReturn = DllCall($libhpdfdll, "int", "HPDF_Page_SetHeight", "ptr", $hPage, "float", $nHeight)
	If @error Then Return SetError(@error, @extended, 0)
	Return $aReturn[0]
EndFunc   ;==>_HPDF_Page_SetHeight

Func _HPDF_Page_SetSize($hPage, $iSize, $iDirection)
	Local $aReturn
	$aReturn = DllCall($libhpdfdll, "int", "HPDF_Page_SetSize", "ptr", $hPage, "dword", $iSize, "dword", $iDirection)
	If @error Then Return SetError(@error, @extended, 0)
	Return $aReturn[0]
EndFunc   ;==>_HPDF_Page_SetSize

Func _HPDF_Free($hPdf)
	Local $aReturn
	$aReturn = DllCall($libhpdfdll, "int", "HPDF_Free", "ptr", $hPdf)
	If @error Then Return SetError(@error, @extended, 0)
	Return $aReturn[0]
EndFunc   ;==>_HPDF_Free

Func _HPDF_AddPage($hPdf)
	Local $aReturn
	$aReturn = DllCall($libhpdfdll, "int", "HPDF_AddPage", "ptr", $hPdf)
	If @error Then Return SetError(@error, @extended, 0)
	Return $aReturn[0]
EndFunc   ;==>_HPDF_AddPage

Func _HPDF_SaveToFile($hPdf, $sFilename)
	Local $aReturn
	$aReturn = DllCall($libhpdfdll, "int", "HPDF_SaveToFile", "ptr", $hPdf, "str", $sFilename)
	If @error Then Return SetError(@error, @extended, 0)
	Return $aReturn[0]
EndFunc   ;==>_HPDF_SaveToFile

Func _HPDF_New()
	Local $aReturn
	Local $error_handler = DllStructCreate("ulong error_no;ulong detail_no;ptr* user_data")
	$aReturn = DllCall($libhpdfdll, "int", "HPDF_New", "ptr", $error_handler, "ptr", 0)
	If @error Then Return SetError(@error, @extended, 0)
	Return $aReturn[0]
EndFunc   ;==>_HPDF_New

Func _Exit()
	_GDIPlus_Shutdown()
	Exit
EndFunc   ;==>_Exit