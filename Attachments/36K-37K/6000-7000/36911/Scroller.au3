;coded by UEZ 2012 build 2012-03-11
#include-once
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <GDIPlus.au3>

Func Scroller_Init($hGUI, $iY, $sText, $sFont = "Arial", $iFSize = 24, $iFStyle = 0, $iFColor = 0x000000, $hl = False, $bgc = False, $bgcolor = 0xFEDCBA)
	If Not IsHWnd($hGUI) Then Return SetError(1, 0, 0)
	If $sText = "" Then Return SetError(2, 0, 0)
	Local $aSize = WinGetClientSize($hGUI)
	Local $aStringSize =  GetStringSize($sText, $sFont, $iFSize, $iFStyle)
	Local $idLabel_Scroller = GUICtrlCreateLabel($sText, $aSize[0], $iY, $aStringSize[0], $aStringSize[1])
	Local $fWeight = 400
	If BitAND($iFStyle, 1) Then $fWeight = 800
	GUICtrlSetFont($idLabel_Scroller, $iFSize, $fWeight , BitXOR($iFStyle, 1), $sFont, 4)
	GUICtrlSetColor($idLabel_Scroller, $iFColor)
	If $bgc Then
		Local $idLabel_BG = GUICtrlCreateLabel("", 0, $iY - 3, $aSize[0], $aStringSize[1] + 3)
		GUICtrlSetBkColor($idLabel_BG, $bgcolor)
		GUICtrlSetState($idLabel_BG, $GUI_DISABLE)
		GUICtrlSetBkColor($idLabel_Scroller, $bgcolor)
	EndIf
	If $hl Then
		Local $idLabel_HorizontalLine1 = GUICtrlCreateLabel("", 0, $iY - 4, $aSize[0] + 4, 2, $SS_ETCHEDHORZ)
		Local $idLabel_HorizontalLine2 = GUICtrlCreateLabel("", 0, $iY + $aStringSize[1], $aSize[0] + 4, 2, $SS_ETCHEDHORZ)
	EndIf
	Local $aData[4] = [$idLabel_Scroller, $aStringSize[0], $aSize[0] + $iFSize, $aSize[0] + $iFSize] ;id label, string width, gui width, $iPos
	Return $aData
EndFunc

Func Scroller_Off($idControl)
	GUICtrlSetState($idControl, $GUI_HIDE)
EndFunc

Func Scroller_On($idControl)
	GUICtrlSetState($idControl, $GUI_SHOW)
EndFunc

Func Scroller_Reset(ByRef $aData)
	$aData[3] = $aData[2]
EndFunc

Func Scroller_Move(ByRef $aData, $iSpeed = 1)
	$aData[3] -= $iSpeed
	GUICtrlSetPos($aData[0], $aData[3])
	If $aData[3] < -$aData[1] Then $aData[3] = $aData[2]
EndFunc

Func GetStringSize($string, $font, $fontsize, $fontstyle)
	Local $GDIp = False
	Local $iWidth = StringLen($string) * $fontsize
	Local $iHeight = 2 * $fontsize
	If Not $ghGDIPDll Then
		_GDIPlus_Startup()
		$GDIp = True
	EndIf
	Local $aResult = DllCall($ghGDIPDll, "uint", "GdipCreateBitmapFromScan0", "int", $iWidth, "int", $iHeight, "int", 0, "int",  0x0026200A, "ptr", 0, "int*", 0)
	Local $hBitmap = $aResult[6]
	Local $hGrphContext = _GDIPlus_ImageGetGraphicsContext($hBitmap)
	Local $hFormat = _GDIPlus_StringFormatCreate()
	Local $hFamily = _GDIPlus_FontFamilyCreate($font)
	Local $hFont = _GDIPlus_FontCreate($hFamily, $fontsize, $fontstyle)
	Local $tLayout = _GDIPlus_RectFCreate(0, 0, 0, 0)
	Local $aInfo = _GDIPlus_GraphicsMeasureString($hGrphContext, $string, $hFont, $tLayout, $hFormat)
	_GDIPlus_FontDispose($hFont)
	_GDIPlus_FontFamilyDispose($hFamily)
	_GDIPlus_StringFormatDispose($hFormat)
	_GDIPlus_BitmapDispose($hBitmap)
	_GDIPlus_GraphicsDispose($hGrphContext)
	If $GDIp Then _GDIPlus_Shutdown()
	Local $aDim[2] = [Int(DllStructGetData($aInfo[0], "Width")), Int(DllStructGetData($aInfo[0], "Height"))]
	Return $aDim
EndFunc