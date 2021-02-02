#include <GDIPlus.au3>
#include <WinAPI.au3>
#include <Constants.au3>
#include <Color.au3>
;style is icon; text size, style and colour
;border is corners; border width; gradient

Func iconavg($control, $text = "", $sIcon = "", $iIndex = "", $hstate = 0, $font = "Arial", $size = 12, $style = 0)
    If Not $sIcon = "" Then
        _GDIPlus_Startup()
        If $font = "" Then $font = "Arial"
        If $size = "" Then $size = "12"
        If $style = "" Then $style = 0
        If $hstate = "" Then $hstate = 0
        $hwd = GUICtrlGetHandle($control)
        $width = _WinAPI_GetClientWidth($hwd)
        $height = _WinAPI_GetClientHeight($hwd)
        $hGraphic = _GDIPlus_GraphicsCreateFromHWND($hwd)
        $hBitmap1 = _GDIPlus_BitmapCreateFromGraphics($width, $height, $hGraphic)
        $hBitmap1 = _drawicon2($hBitmap1, $width, $height, $sIcon, $iIndex, $hstate)
        If $hstate = 0 Then $fontcol = _InvertColor("0x" & $avgcol)
        If $hstate = 1 Or $hstate = 2 Then $fontcol = "0xDDDDDD"
        $hImage1 = _GDIPlus_ImageGetGraphicsContext($hBitmap1)
        ;this is needed because adding an icon results in the background turning black
        $hBitmap1 = _ImageColorRegExpReplace($hBitmap1, "(000000FF)", "FFFFFF00"); Change black to transparent
        If Not $text = "" Then $hBitmap1 = _drawtext($hBitmap1, $width, $height, $text, $font, $size, $style, $fontcol, 0, 1)
        _GDIPlus_GraphicsSetSmoothingMode($hImage1, 2)
        $hBMP1 = _GDIPlus_BitmapCreateHBITMAPFromBitmap($hBitmap1)
        _WinAPI_DeleteObject(GUICtrlSendMsg($control, 0x0172, 0, $hBMP1))

        _GDIPlus_GraphicsDispose($hImage1)
        _WinAPI_DeleteObject($hBMP1)
        _GDIPlus_BitmapDispose($hBitmap1)
        _GDIPlus_GraphicsDispose($hGraphic)
        _GDIPlus_Shutdown()
    EndIf
EndFunc ;==>iconavg


;extremely simplified.  Few options and a thick border
func background($control,$col1,$col2,$col3)
	_GDIPlus_Startup ()
	$hwd=GUICtrlGetHandle($control)
	;$guiname=_WinAPI_GetParent($hwd)
	$width=_WinAPI_GetClientWidth($hwd)
	$height=_WinAPI_GetClientHeight($hwd)
	$hGraphic = _GDIPlus_GraphicsCreateFromHWND($hwd)
	$hBitmap1 = _GDIPlus_BitmapCreateFromGraphics($width,$height, $hGraphic)
	$hBitmap1=_drawborder($hBitmap1,$col1,$col2,$col3,"4","14",3)
	$hImage1 = _GDIPlus_ImageGetGraphicsContext($hBitmap1)
	_GDIPlus_GraphicsSetSmoothingMode($hImage1, 2)
	$hBMP1 = _GDIPlus_BitmapCreateHBITMAPFromBitmap($hBitmap1)
	 _WinAPI_DeleteObject(GUICtrlSendMsg($control, 0x0172, 0, $hBMP1))
	_GDIPlus_ImageDispose ($hImage1)
	_WinAPI_DeleteObject($hBMP1)
	_WinAPI_DeleteObject($hBitmap1)
	_GDIPlus_GraphicsDispose ($hGraphic)
	_GDIPlus_Shutdown ()
EndFunc	

Func iconbutton_1($control, $sIcon = "", $iIndex = "", $hstate = 0)
    If Not $sIcon = "" Then
        _GDIPlus_Startup()
        If $hstate = "" Then $hstate = 0
        $hwd = GUICtrlGetHandle($control)
        $width = _WinAPI_GetClientWidth($hwd)
        $height = _WinAPI_GetClientHeight($hwd)
        $hGraphic = _GDIPlus_GraphicsCreateFromHWND($hwd)
        $hBitmap1 = _GDIPlus_BitmapCreateFromGraphics($width, $height, $hGraphic)
        $hBitmap1 = _drawicon($hBitmap1, $width, $height, $sIcon, $iIndex)
        If $hstate = 1 Or $hstate = 2 Then $fontcol = "0xDDDDDD"
        $hImage1 = _GDIPlus_ImageGetGraphicsContext($hBitmap1)
        ;this is needed because adding an icon results in the background turning black
        $hBitmap1 = _ImageColorRegExpReplace($hBitmap1, "(000000FF)", "FFFFFF00"); Change black to transparent
        ;Swap red and blue channels on half the image. Image is 400x300 = 120,000 pixels. Number of pixels to replace is 60,000.
        If $hstate = 1 Then $hBitmap1 = _ImageColorRegExpReplace($hBitmap1, "([0-9A-F]{2})([0-9A-F]{2})([0-9A-F]{2})(FF)", "${3}${2}${1}${4}", $width * $height)
        _GDIPlus_GraphicsSetSmoothingMode($hImage1, 2)
        $hBMP1 = _GDIPlus_BitmapCreateHBITMAPFromBitmap($hBitmap1)
        _WinAPI_DeleteObject(GUICtrlSendMsg($control, 0x0172, 0, $hBMP1))
        _GDIPlus_GraphicsDispose($hImage1)
        _WinAPI_DeleteObject($hBMP1)
        _GDIPlus_BitmapDispose($hBitmap1)
        _GDIPlus_GraphicsDispose($hGraphic)
        _GDIPlus_Shutdown()
    EndIf
EndFunc ;==>iconbutton_1

Func createbutton_3($control, $col1, $col2, $col3, $text = "", $font = "Arial", $size = 12, $style = 0, $fontcol = "0x222222", $halign = 0, $sIcon = "", $iIndex = "")
    _GDIPlus_Startup()
    If $font = "" Then $font = "Arial"
    If $size = "" Then $size = "12"
    If $style = "" Then $style = 0
    If $fontcol = "" Then $fontcol = "0x222222"
    If $halign = "" Then $halign = 0
    $hwd = GUICtrlGetHandle($control)
    ;$guiname=_WinAPI_GetParent($hwd)
    $width = _WinAPI_GetClientWidth($hwd)
    $height = _WinAPI_GetClientHeight($hwd)
    $hGraphic = _GDIPlus_GraphicsCreateFromHWND($hwd)
    $hBitmap1 = _GDIPlus_BitmapCreateFromGraphics($width, $height, $hGraphic)
    $hBitmap1 = _drawborder($hBitmap1, $col1, $col2, $col3, "2", "14")
    If Not $sIcon = "" Then
        $hBitmap1 = _drawicon($hBitmap1, $width, $height, $sIcon, $iIndex)
        $textleft = 1
    Else
        $textleft = 0
    EndIf
    $hImage1 = _GDIPlus_ImageGetGraphicsContext($hBitmap1)
    If Not $text = "" Then $hBitmap1 = _drawtext($hBitmap1, $width, $height, $text, $font, $size, $style, $fontcol, $halign, $textleft)
    _GDIPlus_GraphicsSetSmoothingMode($hImage1, 2)
    $hBMP1 = _GDIPlus_BitmapCreateHBITMAPFromBitmap($hBitmap1)
    _WinAPI_DeleteObject(GUICtrlSendMsg($control, 0x0172, 0, $hBMP1))
    _GDIPlus_GraphicsDispose($hImage1)
    _WinAPI_DeleteObject($hBMP1)
    _GDIPlus_BitmapDispose($hBitmap1)
    _GDIPlus_GraphicsDispose($hGraphic)
    _GDIPlus_Shutdown()
EndFunc ;==>createbutton_3

Func createbutton_3c($control, $col1, $col2, $col3, $text = "", $font = "Arial", $size = 12, $style = 0, $fontcol = "0x222222", $halign = 0, $sIcon = "", $iIndex = "")
    _GDIPlus_Startup()
    If $font = "" Then $font = "Arial"
    If $size = "" Then $size = "12"
    If $style = "" Then $style = 0
    If $fontcol = "" Then $fontcol = "0x222222"
    If $halign = "" Then $halign = 0
    $hwd = GUICtrlGetHandle($control)
    ;$guiname=_WinAPI_GetParent($hwd)
    $width = _WinAPI_GetClientWidth($hwd)
    $height = _WinAPI_GetClientHeight($hwd)
    $hGraphic = _GDIPlus_GraphicsCreateFromHWND($hwd)
    $hBitmap1 = _GDIPlus_BitmapCreateFromGraphics($width, $height, $hGraphic)
    $hBitmap1 = _drawborder1($hBitmap1, $col1, $col2, $col3, "2", "14")
    If Not $sIcon = "" Then
        $hBitmap1 = _drawicon($hBitmap1, $width, $height, $sIcon, $iIndex)
        $hBitmap1 = _ImageColorRegExpReplace($hBitmap1, "(000000FF)", "FFFFFF00"); Change black to transparent
        $textleft = 1
    Else

        $textleft = 0
    EndIf
    $hImage1 = _GDIPlus_ImageGetGraphicsContext($hBitmap1)
    If Not $text = "" Then $hBitmap1 = _drawtext($hBitmap1, $width, $height, $text, $font, $size, $style, $fontcol, $halign, $textleft)

    _GDIPlus_GraphicsSetSmoothingMode($hImage1, 2)
    $hBMP1 = _GDIPlus_BitmapCreateHBITMAPFromBitmap($hBitmap1)
    _WinAPI_DeleteObject(GUICtrlSendMsg($control, 0x0172, 0, $hBMP1))
    _GDIPlus_GraphicsDispose($hImage1)
    _WinAPI_DeleteObject($hBMP1)
    _GDIPlus_BitmapDispose($hBitmap1)
    _GDIPlus_GraphicsDispose($hGraphic)
    _GDIPlus_Shutdown()
EndFunc ;==>createbutton_3c

Func letterbutton_1($control, $text = "", $font = "Arial", $size = 12, $style = 2, $fontcol = "0x000000")
    _GDIPlus_Startup()
    $hwd = GUICtrlGetHandle($control)
    ;$guiname=_WinAPI_GetParent($hwd)
    $width = _WinAPI_GetClientWidth($hwd)
    $height = _WinAPI_GetClientHeight($hwd)
    $hGraphic = _GDIPlus_GraphicsCreateFromHWND($hwd)
    $hBitmap1 = _GDIPlus_BitmapCreateFromGraphics($width, $height, $hGraphic)
    ;$hBitmap1=_drawborder($hBitmap1,$col1,$col2,$col3,"2","14")
    If Not $text = "" Then $hBitmap1 = _drawtext($hBitmap1, $width, $height, $text, $font, $size, $style, $fontcol, 2)
    $hImage1 = _GDIPlus_ImageGetGraphicsContext($hBitmap1)
    _GDIPlus_GraphicsSetSmoothingMode($hImage1, 2)
    $hBMP1 = _GDIPlus_BitmapCreateHBITMAPFromBitmap($hBitmap1)
    _WinAPI_DeleteObject(GUICtrlSendMsg($control, 0x0172, 0, $hBMP1))
    _GDIPlus_GraphicsDispose($hImage1)
    _WinAPI_DeleteObject($hBMP1)
    _GDIPlus_BitmapDispose($hBitmap1)
    _GDIPlus_GraphicsDispose($hGraphic)
    _GDIPlus_Shutdown()
EndFunc ;==>letterbutton_1

Func topbar2($control, $slant, $pos, $col1, $col2, $col3, $text = "", $font = "Arial", $size = 12, $style = 0, $fontcol = "0xFFFFFF", $halign = 0, $sIcon = "", $iIndex = "")
    _GDIPlus_Startup()
    If $font = "" Then $font = "Arial"
    If $size = "" Then $size = "12"
    If $style = "" Then $style = 0
    If $fontcol = "" Then $fontcol = "0x222222"
    If $halign = "" Then $halign = 0
    $hwd = GUICtrlGetHandle($control)
    ;$guiname=_WinAPI_GetParent($hwd)
    $width = _WinAPI_GetClientWidth($hwd)
    $height = _WinAPI_GetClientHeight($hwd)
    $hGraphic = _GDIPlus_GraphicsCreateFromHWND($hwd)
    $hBitmap1 = _GDIPlus_BitmapCreateFromGraphics($width, $height, $hGraphic)
    $hBitmap1 = _drawborder3b($hBitmap1, $col1, $col2, $col3, 1, 0, $slant, $pos)
    $hImage1 = _GDIPlus_ImageGetGraphicsContext($hBitmap1)
    If Not $sIcon = "" Then
        $hBitmap1 = _drawicon($hBitmap1, $width, $height, $sIcon, $iIndex)
        $textleft = 1
    Else
        $textleft = 0
    EndIf
    If Not $text = "" Then $hBitmap1 = _drawtext($hBitmap1, $width, $height, $text, $font, $size, $style, $fontcol, $halign, $textleft)
    _GDIPlus_GraphicsSetSmoothingMode($hImage1, 2)
    $hBMP1 = _GDIPlus_BitmapCreateHBITMAPFromBitmap($hBitmap1)
    _WinAPI_DeleteObject(GUICtrlSendMsg($control, 0x0172, 0, $hBMP1))
    _GDIPlus_GraphicsDispose($hImage1)
    _WinAPI_DeleteObject($hBMP1)
    _GDIPlus_BitmapDispose($hBitmap1)
    _GDIPlus_GraphicsDispose($hGraphic)
    _GDIPlus_Shutdown()
EndFunc ;==>topbar2

Func topbar3($control, $slant, $pos, $col1, $col2, $col3, $text = "", $font = "Arial", $size = 12, $style = 0, $fontcol = "0xFFFFFF", $halign = 0, $sIcon = "", $iIndex = "")
    _GDIPlus_Startup()
    If $font = "" Then $font = "Arial"
    If $size = "" Then $size = "12"
    If $style = "" Then $style = 0
    If $fontcol = "" Then $fontcol = "0x222222"
    If $halign = "" Then $halign = 0
    $hwd = GUICtrlGetHandle($control)
    ;$guiname=_WinAPI_GetParent($hwd)
    $width = _WinAPI_GetClientWidth($hwd)
    $height = _WinAPI_GetClientHeight($hwd)
    $hGraphic = _GDIPlus_GraphicsCreateFromHWND($hwd)
    $hBitmap1 = _GDIPlus_BitmapCreateFromGraphics($width, $height, $hGraphic)
    $hBitmap1 = _drawborder3($hBitmap1, $col1, $col2, $col3, 1, 0, $slant, $pos)
    $hImage1 = _GDIPlus_ImageGetGraphicsContext($hBitmap1)
    If Not $sIcon = "" Then
        $hBitmap1 = _drawicon($hBitmap1, $width, $height, $sIcon, $iIndex)
        $textleft = 1
    Else
        $textleft = 0
    EndIf
    If Not $text = "" Then $hBitmap1 = _drawtext($hBitmap1, $width, $height, $text, $font, $size, $style, $fontcol, $halign, $textleft)
    _GDIPlus_GraphicsSetSmoothingMode($hImage1, 2)
    $hBMP1 = _GDIPlus_BitmapCreateHBITMAPFromBitmap($hBitmap1)
    _WinAPI_DeleteObject(GUICtrlSendMsg($control, 0x0172, 0, $hBMP1))
    _GDIPlus_GraphicsDispose($hImage1)
    _WinAPI_DeleteObject($hBMP1)
    _GDIPlus_BitmapDispose($hBitmap1)
    _GDIPlus_GraphicsDispose($hGraphic)
    _GDIPlus_Shutdown()
EndFunc ;==>topbar3

Func createtab_1($control, $col1, $col2, $col3, $text = "", $font = "Arial", $size = 12, $style = 0, $fontcol = "0x222222", $halign = 0, $sIcon = "", $iIndex = "")
    _GDIPlus_Startup()
    If $font = "" Then $font = "Arial"
    If $size = "" Then $size = "12"
    If $style = "" Then $style = 0
    If $fontcol = "" Then $fontcol = "0x222222"
    If $halign = "" Then $halign = 0
    $hwd = GUICtrlGetHandle($control)
    ;$guiname=_WinAPI_GetParent($hwd)
    $width = _WinAPI_GetClientWidth($hwd)
    $height = _WinAPI_GetClientHeight($hwd)
    $hGraphic = _GDIPlus_GraphicsCreateFromHWND($hwd)
    $hBitmap1 = _GDIPlus_BitmapCreateFromGraphics($width, $height, $hGraphic)
    $hBitmap1 = _drawborder2($hBitmap1, $col1, $col2, $col3, "1", "14")
    $hImage1 = _GDIPlus_ImageGetGraphicsContext($hBitmap1)
    If Not $sIcon = "" Then
        $hBitmap1 = _drawicon($hBitmap1, $width, $height, $sIcon, $iIndex)
        $textleft = 1
    Else
        $textleft = 0
    EndIf
    If Not $text = "" Then $hBitmap1 = _drawtext($hBitmap1, $width, $height, $text, $font, $size, $style, $fontcol, $halign, $textleft)
    _GDIPlus_GraphicsSetSmoothingMode($hImage1, 2)
    $hBMP1 = _GDIPlus_BitmapCreateHBITMAPFromBitmap($hBitmap1)
    _WinAPI_DeleteObject(GUICtrlSendMsg($control, 0x0172, 0, $hBMP1))
    _GDIPlus_GraphicsDispose($hImage1)
    _WinAPI_DeleteObject($hBMP1)
    _GDIPlus_BitmapDispose($hBitmap1)
    _GDIPlus_GraphicsDispose($hGraphic)
    _GDIPlus_Shutdown()
EndFunc ;==>createtab_1

Func _drawtext($hBitmap1, $leftpos, $toppos, $text, $font, $size, $style, $fontcol, $align = 2, $lpadding = 0) ; left justify $align=0; right justify $align=1 ;center $align=2
    $hImage1 = _GDIPlus_ImageGetGraphicsContext($hBitmap1)
    $fcol = StringReplace($fontcol, "0x", "0xFF")
    $hBrushed = _GDIPlus_BrushCreateSolid($fcol)
    $hFormat = _GDIPlus_StringFormatCreate()
    $hFamily = _GDIPlus_FontFamilyCreate($font)
    $hFont = _GDIPlus_FontCreate($hFamily, $size, $style)
    $tLayout = _GDIPlus_RectFCreate($leftpos, $toppos, 0, 0)
    $aInfo = _GDIPlus_GraphicsMeasureString($hImage1, $text, $hFont, $tLayout, $hFormat)
    Local $iWidth = Ceiling(DllStructGetData($aInfo[0], "Width"))
    Local $iHeight = Ceiling(DllStructGetData($aInfo[0], "Height"))
    If $align = 1 Or $align = 2 Then $lpos = ($leftpos / $align) - ($iWidth / $align)
    If $align = 0 And $lpadding = 0 Then $lpos = 5
    If $align = 0 And $lpadding = 1 Then $lpos = 34
    $tLayout = _GDIPlus_RectFCreate($lpos, ($toppos / 2) - ($iHeight / 2), 0, 0)
    $aInfo = _GDIPlus_GraphicsMeasureString($hImage1, $text, $hFont, $tLayout, $hFormat)
    _GDIPlus_GraphicsDrawStringEx($hImage1, $text, $hFont, $aInfo[0], $hFormat, $hBrushed)
    _GDIPlus_GraphicsDispose($hImage1)
    _GDIPlus_FontDispose($hFont)
    _GDIPlus_FontFamilyDispose($hFamily)
    _GDIPlus_StringFormatDispose($hFormat)
    _GDIPlus_BrushDispose($hBrushed)
    Return $hBitmap1
EndFunc ;==>_drawtext

Func _GetTextSize($nText, $iFontSize = 8.5, $sFont = 'Microsoft Sans Serif', $iFontAttributes = 0)
    ;Author: Bugfix
    ;Modified: funkey
    If $nText = '' Then Return
    Local $hGUI = GUICreate("Textmeter by Bugfix")
    _GDIPlus_Startup()
    Local $hFormat = _GDIPlus_StringFormatCreate(0)
    Local $hFamily = _GDIPlus_FontFamilyCreate($sFont)
    Local $hFont = _GDIPlus_FontCreate($hFamily, $iFontSize, $iFontAttributes, 3)
    Local $tLayout = _GDIPlus_RectFCreate(15, 171, 0, 0)
    Local $hGraphic = _GDIPlus_GraphicsCreateFromHWND($hGUI)
    Local $aInfo = _GDIPlus_GraphicsMeasureString($hGraphic, $nText, $hFont, $tLayout, $hFormat)
    Local $iWidth = Ceiling(DllStructGetData($aInfo[0], "Width"))
    Local $iHeight = Ceiling(DllStructGetData($aInfo[0], "Height"))
    _GDIPlus_StringFormatDispose($hFormat)
    _GDIPlus_FontDispose($hFont)
    _GDIPlus_FontFamilyDispose($hFamily)
    _GDIPlus_GraphicsDispose($hGraphic)
    _GDIPlus_Shutdown()
    GUIDelete($hGUI)
    Local $aSize[2] = [$iWidth, $iHeight]
    Return $aSize
EndFunc ;==>_GetTextSize

Func _drawicon($bitmap, $width, $height, $ico, $ind)
    $hbmp = _GDIPlus_BitmapCreateHBITMAPFromBitmap($bitmap)
    $hIcon = _WinAPI_SHExtractIcons($ico, $ind, 32, 32)
    $hDC = _WinAPI_GetDC(0)
    $hBackDC = _WinAPI_CreateCompatibleDC($hDC)
    $hBackSv = _WinAPI_SelectObject($hBackDC, $hbmp)
    If $hIcon <> 0 Then _WinAPI_DrawIconEx($hBackDC, 3, $height / 2 - 15, $hIcon, 0, 0, 0, 0, $DI_NORMAL)
    $bitmap = _GDIPlus_BitmapCreateFromHBITMAP($hbmp)
    _WinAPI_DeleteObject($hbmp)
    _WinAPI_SelectObject($hBackDC, $hBackSv)
    _WinAPI_DeleteDC($hBackDC)
    _WinAPI_ReleaseDC(0, $hDC)
    _WinAPI_DestroyIcon($hIcon)
    Return $bitmap
    Return
EndFunc ;==>_drawicon
Func _drawicon2($bitmap, $width, $height, $ico, $ind, $hstate)
    $avgcol = ""
    $hIcon = _WinAPI_SHExtractIcons($ico, $ind, 32, 32) ; extract the icon
    ;create an extra bitmap to extract the icon to
    $hbmp2 = _GDIPlus_BitmapCreateHBITMAPFromBitmap($bitmap)
    $hDC2 = _WinAPI_GetDC(0)
    $hBackDC2 = _WinAPI_CreateCompatibleDC($hDC2)
    $hBackSv2 = _WinAPI_SelectObject($hBackDC2, $hbmp2)

    If $hIcon <> 0 Then
        _WinAPI_DrawIconEx($hBackDC2, 3, $height / 2 - 15, $hIcon, 0, 0, 0, 0, $DI_NORMAL)
        $bitmap2 = _GDIPlus_BitmapCreateFromHBITMAP($hbmp2)

        ;get average colour from newly extracted icon, draw background with colour and place icon in new bmp.
        Global $avgcol = _Area_Average_Colour($bitmap2, 10, 3, $height / 2 - 15, 32, 32)
        $hGraphic = _GDIPlus_GraphicsCreateFromHWND(0)
        $hbmp = _GDIPlus_BitmapCreateFromGraphics($width, $height, $hGraphic)

        If $hstate = 0 Then
            $bitmap = _drawborder($hbmp, "0xFFFFFF", "0x" & $avgcol, "0x555555", "2", "14")
        Else
            $bitmap = _drawborder($hbmp, "0x000000", "0x" & $avgcol, "0x555555", "2", "14")
        EndIf
        $hbmp = _GDIPlus_BitmapCreateHBITMAPFromBitmap($bitmap)
        $hDC = _WinAPI_GetDC(0)
        $hBackDC = _WinAPI_CreateCompatibleDC($hDC)
        $hBackSv = _WinAPI_SelectObject($hBackDC, $hbmp)
        _WinAPI_DrawIconEx($hBackDC, 3, $height / 2 - 15, $hIcon, 0, 0, 0, 0, $DI_NORMAL)
        $bitmap2 = _GDIPlus_BitmapCreateFromHBITMAP($hbmp)
    EndIf
    ;dispose of all resources except for $bitmap2
    _WinAPI_DeleteObject($hbmp)
    _WinAPI_DeleteObject($bitmap)
    _WinAPI_SelectObject($hBackDC, $hBackSv)
    _WinAPI_DeleteDC($hBackDC)
    _WinAPI_ReleaseDC(0, $hDC)

    _GDIPlus_GraphicsDispose($hGraphic)
    _WinAPI_DeleteObject($hbmp2)
    _WinAPI_SelectObject($hBackDC2, $hBackSv2)
    _WinAPI_DeleteDC($hBackDC2)
    _WinAPI_ReleaseDC(0, $hDC2)

    _WinAPI_DestroyIcon($hIcon)
    Return $bitmap2
    Return
EndFunc ;==>_drawicon2

Func _WinAPI_SHExtractIcons($sIcon, $iIndex, $iWidth, $iHeight)
    Local $Ret = DllCall('shell32.dll', 'int', 'SHExtractIconsW', 'wstr', $sIcon, 'int', $iIndex, 'int', $iWidth, 'int', $iHeight, 'ptr*', 0, 'ptr*', 0, 'int', 1, 'int', 0)
    If (@error) Or ($Ret[0] = 0) Or ($Ret[5] = Ptr(0)) Then
        Return SetError(1, 0, 0)
    EndIf
    Return $Ret[5]
EndFunc ;==>_WinAPI_SHExtractIcons



func closebutton($control,$col1)
	_GDIPlus_Startup ()
	$hwd=GUICtrlGetHandle($control)
	;$guiname=_WinAPI_GetParent($hwd)
	$width=_WinAPI_GetClientWidth($hwd)
	$height=_WinAPI_GetClientHeight($hwd)
	$hGraphic = _GDIPlus_GraphicsCreateFromHWND($hwd)
	$hBitmap1 = _GDIPlus_BitmapCreateFromGraphics($width,$height, $hGraphic)
;	$hBitmap1=_drawborderclosed($hBitmap1,$col1,"4","14",3)
		; Instead of calling a seperate function, include right in first function
			$iC1 = StringReplace($col1, "0x", "0xFF")
			$hGraphics = _GDIPlus_ImageGetGraphicsContext($hBitmap1)
			Global $hBrush = _GDIPlus_BrushCreateSolid($iC1)
			_GDIPlus_GraphicsSetSmoothingMode($hGraphics, 4)
			_GDIPlus_GraphicsDrawclose($hGraphics, 0, 0, $width,$height, 44, $hBrush)
			_GDIPlus_BrushDispose($hBrush)
			_GDIPlus_GraphicsDispose($hGraphics)
			;;;;;;;;;;;
	$hImage1 = _GDIPlus_ImageGetGraphicsContext($hBitmap1)
	_GDIPlus_GraphicsSetSmoothingMode($hImage1, 2)
	$hBMP1 = _GDIPlus_BitmapCreateHBITMAPFromBitmap($hBitmap1)
	 _WinAPI_DeleteObject(GUICtrlSendMsg($control, 0x0172, 0, $hBMP1))
	_GDIPlus_ImageDispose ($hImage1)
	_WinAPI_DeleteObject($hBMP1)
	_WinAPI_DeleteObject($hBitmap1)
	_GDIPlus_GraphicsDispose ($hGraphic)
	_GDIPlus_GraphicsDispose ($hGraphics)
	_GDIPlus_Shutdown ()
EndFunc	

Func _drawborder2($hBitmap, $colour1, $colour2, $colour3, $depth, $corner, $slanty = 1) ;this one is for tabs i.e. only top corners are curved
    Local $gwt = _GDIPlus_ImageGetWidth($hBitmap) - 1
    Local $ght = _GDIPlus_ImageGetHeight($hBitmap) - 1
    Local $iC1 = StringReplace($colour1, "0x", "0xFF")
    Local $iC2 = StringReplace($colour2, "0x", "0xFF")
    Local $iC3 = StringReplace($colour3, "0x", "0xFF")
    Local $hGraphics = _GDIPlus_ImageGetGraphicsContext($hBitmap)
    Local $hBrush = _GDIPlus_BrushCreateSolid($iC1)
    Local $hBrush2 = _GDIPlus_BrushCreateSolid($iC2)

    Local $aFactors[4] = [0.0, 0.6, 0.8, 1.0], $aPositions[4] = [0.0, 0.6, 0.8, 1.0]
    Local $bGammaCorrection = False
    Local $hBrush1 = _GDIPlus_CreateLineBrushFromRect(0, 0, $gwt, $ght, $aFactors, $aPositions, $iC1, $iC2, $slanty)
    GDIPlus_SetLineGammaCorrection($hBrush1, $bGammaCorrection)
    Local $hBrush3 = _GDIPlus_BrushCreateSolid($iC3)
    _GDIPlus_GraphicsSetSmoothingMode($hGraphics, 4)
    _GDIPlus_GraphicsDrawtab($hGraphics, 0, 0, $gwt, $ght, $corner, $hBrush3)
    _GDIPlus_GraphicsDrawtab($hGraphics, $depth, $depth, $gwt - ($depth * 2), $ght - ($depth * 2), $corner - 2, $hBrush1)

    _GDIPlus_BrushDispose($hBrush)
    _GDIPlus_BrushDispose($hBrush1)
    _GDIPlus_BrushDispose($hBrush2)
    _GDIPlus_BrushDispose($hBrush3)
    _GDIPlus_GraphicsDispose($hGraphics)
    Return $hBitmap
EndFunc ;==>_drawborder2

Func _drawborder3($hBitmap, $colour1, $colour2, $colour3, $depth, $corner, $slanty = 1, $pos = 0) ;this is for normal buttons
    Local $gwt = _GDIPlus_ImageGetWidth($hBitmap) - 1
    Local $ght = _GDIPlus_ImageGetHeight($hBitmap) - 1
    Local $iC1 = StringReplace($colour1, "0x", "0xFF")
    Local $iC2 = StringReplace($colour2, "0x", "0xFF")
    Local $iC3 = StringReplace($colour3, "0x", "0xFF")
    Local $hGraphics = _GDIPlus_ImageGetGraphicsContext($hBitmap)
    Local $hBrush = _GDIPlus_BrushCreateSolid($iC1)
    Local $hBrush2 = _GDIPlus_BrushCreateSolid($iC2)

    Local $aFactors[4] = [0.1, 0.3, 0.7, 0.9], $aPositions[4] = [0.1, 0.3, 0.7, 0.9]
    Local $bGammaCorrection = False
    Local $hBrush1 = _GDIPlus_CreateLineBrushFromRect(0, 0, $gwt, $ght, $aFactors, $aPositions, $iC1, $iC2, $slanty)
    Local $hBrush3 = _GDIPlus_CreateLineBrushFromRect(0, 0, $gwt, $ght, $aFactors, $aPositions, $iC2, $iC1, $slanty)
    GDIPlus_SetLineGammaCorrection($hBrush1, $bGammaCorrection)
    Local $hBrush = _GDIPlus_BrushCreateSolid($iC3)
    _GDIPlus_GraphicsSetSmoothingMode($hGraphics, 4)
    If $pos = 0 Then
        _GDIPlus_GraphicsDrawRoundRect($hGraphics, 0, 0, $gwt, $ght, 0, $hBrush)
        _GDIPlus_GraphicsDrawRoundRect($hGraphics, $depth, $depth, $gwt - ($depth * 2), $ght, 0, $hBrush1)
        ; _GDIPlus_GraphicsDrawRoundRect($hGraphics, $depth, $ght/2, $gwt-($depth*2), ($ght-($depth*2))/2, 0,$hBrush3)
    ElseIf $pos = 1 Then
        _GDIPlus_leftend($hGraphics, 0, 0, $gwt, $ght, 22, $hBrush)
        _GDIPlus_leftend($hGraphics, $depth, $depth, $gwt - ($depth * 2), $ght, 20, $hBrush3, 0, 0)
        ;   _GDIPlus_leftend($hGraphics, $depth, $ght/2, $gwt-($depth*2), ($ght-($depth*2))/2, 20,$hBrush1,0,2)
        ;   _GDIPlus_leftend($hGraphics, 0, 0, $gwt,$ght, 22, $hBrush)
        ;   _GDIPlus_leftend($hGraphics, $depth, $depth, $gwt-($depth*2), $ght-($depth*2), 20,$hBrush1)
    ElseIf $pos = 2 Then
        _GDIPlus_rightend($hGraphics, 0, 0, $gwt, $ght, 22, $hBrush)
        _GDIPlus_rightend($hGraphics, $depth, $depth, $gwt - ($depth * 2), $ght, 20, $hBrush3, 0, 0)
        ;   _GDIPlus_rightend($hGraphics, $depth, $ght/2, $gwt-($depth*2), ($ght-($depth*2))/2, 20,$hBrush1,0,2)
    EndIf
    _GDIPlus_BrushDispose($hBrush)
    _GDIPlus_BrushDispose($hBrush1)
    _GDIPlus_BrushDispose($hBrush2)
    _GDIPlus_BrushDispose($hBrush3)
    _GDIPlus_GraphicsDispose($hGraphics)
    Return $hBitmap
EndFunc ;==>_drawborder3
Func _drawborder3b($hBitmap, $colour1, $colour2, $colour3, $depth, $corner, $slanty = 1, $pos = 0) ;this is for normal buttons
    $gwt = _GDIPlus_ImageGetWidth($hBitmap) - 1
    $ght = _GDIPlus_ImageGetHeight($hBitmap) - 1
    $iC1 = StringReplace($colour1, "0x", "0xFF")
    $iC2 = StringReplace($colour2, "0x", "0xFF")
    $iC3 = StringReplace($colour3, "0x", "0xFF")
    $hGraphics = _GDIPlus_ImageGetGraphicsContext($hBitmap)
    Global $hBrush = _GDIPlus_BrushCreateSolid($iC1)
    Global $hBrush2 = _GDIPlus_BrushCreateSolid($iC2)

    Local $aFactors[4] = [0.1, 0.3, 0.7, 0.9], $aPositions[4] = [0.1, 0.3, 0.7, 0.9]
    Local $bGammaCorrection = False
    $hBrush1 = _GDIPlus_CreateLineBrushFromRect(0, 0, $gwt, $ght / 2, $aFactors, $aPositions, $iC1, $iC2, $slanty)
    $hBrush3 = _GDIPlus_CreateLineBrushFromRect(0, 0, $gwt, $ght / 2, $aFactors, $aPositions, $iC2, $iC1, $slanty)
    GDIPlus_SetLineGammaCorrection($hBrush1, $bGammaCorrection)
    Global $hBrush = _GDIPlus_BrushCreateSolid($iC3)
    _GDIPlus_GraphicsSetSmoothingMode($hGraphics, 4)
    If $pos = 0 Then
        _GDIPlus_GraphicsDrawRoundRect($hGraphics, 0, 0, $gwt, $ght, 0, $hBrush)
        _GDIPlus_GraphicsDrawRoundRect($hGraphics, $depth, $depth, $gwt - ($depth * 2), $ght / 2, 0, $hBrush1)
        _GDIPlus_GraphicsDrawRoundRect($hGraphics, $depth, $ght / 2, $gwt - ($depth * 2), ($ght - ($depth * 2)) / 2, 0, $hBrush3)
    ElseIf $pos = 1 Then
        _GDIPlus_leftend($hGraphics, 0, 0, $gwt, $ght, 22, $hBrush)
        _GDIPlus_leftend($hGraphics, $depth, $depth, $gwt - ($depth * 2), $ght / 2, 20, $hBrush3, 0, 1)
        _GDIPlus_leftend($hGraphics, $depth, $ght / 2, $gwt - ($depth * 2), ($ght - ($depth * 2)) / 2, 20, $hBrush1, 0, 2)
        ;   _GDIPlus_leftend($hGraphics, 0, 0, $gwt,$ght, 22, $hBrush)
        ;   _GDIPlus_leftend($hGraphics, $depth, $depth, $gwt-($depth*2), $ght-($depth*2), 20,$hBrush1)
    ElseIf $pos = 2 Then
        _GDIPlus_rightend($hGraphics, 0, 0, $gwt, $ght, 22, $hBrush)
        _GDIPlus_rightend($hGraphics, $depth, $depth, $gwt - ($depth * 2), $ght / 2, 20, $hBrush3, 0, 1)
        _GDIPlus_rightend($hGraphics, $depth, $ght / 2, $gwt - ($depth * 2), ($ght - ($depth * 2)) / 2, 20, $hBrush1, 0, 2)
    EndIf
    _GDIPlus_BrushDispose($hBrush)
    _GDIPlus_BrushDispose($hBrush1)
    _GDIPlus_BrushDispose($hBrush2)
    _GDIPlus_BrushDispose($hBrush3)
    _GDIPlus_GraphicsDispose($hGraphics)
    Return $hBitmap
EndFunc ;==>_drawborder3b

;handler, to draw background and createbutton3
Func _drawborder($hBitmap, $colour1, $colour2, $colour3, $depth, $corner, $slanty = 1, $pos = 0) ;this is for normal buttons
    $gwt = _GDIPlus_ImageGetWidth($hBitmap) - 1
    $ght = _GDIPlus_ImageGetHeight($hBitmap) - 1
    $iC1 = StringReplace($colour1, "0x", "0xFF")
    $iC2 = StringReplace($colour2, "0x", "0xFF")
    $iC3 = StringReplace($colour3, "0x", "0xFF")
    $hGraphics = _GDIPlus_ImageGetGraphicsContext($hBitmap)
    Global $hBrush = _GDIPlus_BrushCreateSolid($iC1)
    Global $hBrush2 = _GDIPlus_BrushCreateSolid($iC2)

    Local $aFactors[4] = [0.0, 0.6, 0.8, 1.0], $aPositions[4] = [0.0, 0.6, 0.8, 1.0]
    Local $bGammaCorrection = False
    $hBrush1 = _GDIPlus_CreateLineBrushFromRect(0, 0, $gwt, $ght, $aFactors, $aPositions, $iC1, $iC2, $slanty)
    GDIPlus_SetLineGammaCorrection($hBrush1, $bGammaCorrection)
    Global $hBrush = _GDIPlus_BrushCreateSolid($iC3)
    _GDIPlus_GraphicsSetSmoothingMode($hGraphics, 4)
    If $pos = 0 Then
        _GDIPlus_GraphicsDrawRoundRect($hGraphics, 0, 0, $gwt, $ght, $corner, $hBrush)
        _GDIPlus_GraphicsDrawRoundRect($hGraphics, $depth, $depth, $gwt - ($depth * 2), $ght - ($depth * 2), $corner - 2, $hBrush1)
    ElseIf $pos = 1 Then
        _GDIPlus_leftend($hGraphics, 0, 0, $gwt, $ght, 22, $hBrush)
        _GDIPlus_leftend($hGraphics, $depth, $depth, $gwt - ($depth * 2), $ght - ($depth * 2), 20, $hBrush1)
    ElseIf $pos = 2 Then
        _GDIPlus_rightend($hGraphics, 0, 0, $gwt, $ght, 22, $hBrush)
        _GDIPlus_rightend($hGraphics, $depth, $depth, $gwt - ($depth * 2), $ght - ($depth * 2), 20, $hBrush1)
    EndIf
    _GDIPlus_BrushDispose($hBrush)
    _GDIPlus_BrushDispose($hBrush1)
    _GDIPlus_BrushDispose($hBrush2)
    _GDIPlus_GraphicsDispose($hGraphics)
    Return $hBitmap
EndFunc ;==>_drawborder

;handler to draw createbutton3c
Func _drawborder1($hBitmap, $colour1, $colour2, $colour3, $depth, $corner, $slanty = 1, $pos = 0) ;this is for normal buttons
    $gwt = _GDIPlus_ImageGetWidth($hBitmap) - 1
    $ght = _GDIPlus_ImageGetHeight($hBitmap) - 1
    $iC1 = StringReplace($colour1, "0x", "0xFF")
    $iC2 = StringReplace($colour2, "0x", "0xFF")
    $iC3 = StringReplace($colour3, "0x", "0xFF")
    $hGraphics = _GDIPlus_ImageGetGraphicsContext($hBitmap)
    Global $hBrush = _GDIPlus_BrushCreateSolid($iC1)
    Global $hBrush2 = _GDIPlus_BrushCreateSolid($iC2)

    Local $aFactors[4] = [0.0, 0.6, 0.8, 1.0], $aPositions[4] = [0.0, 0.6, 0.8, 1.0]
    Local $bGammaCorrection = False
    $hBrush1 = _GDIPlus_CreateLineBrushFromRect(0, 0, $gwt, $ght / 2, $aFactors, $aPositions, $iC1, $iC2, $slanty)
    $hBrush3 = _GDIPlus_CreateLineBrushFromRect(0, 0, $gwt, $ght / 2, $aFactors, $aPositions, $iC2, $iC1, $slanty)
    GDIPlus_SetLineGammaCorrection($hBrush1, $bGammaCorrection)
    Global $hBrush = _GDIPlus_BrushCreateSolid($iC3)
    _GDIPlus_GraphicsSetSmoothingMode($hGraphics, 4)
    If $pos = 0 Then
        _GDIPlus_GraphicsDrawRoundRect($hGraphics, 0, 0, $gwt, $ght, $corner, $hBrush)
        _GDIPlus_GraphicsDrawtab($hGraphics, $depth, $depth, $gwt - ($depth * 2), $ght / 2, $corner, $hBrush1)
        _GDIPlus_GraphicsDrawtab2($hGraphics, $depth, $ght / 2, $gwt - ($depth * 2), ($ght - ($depth * 2)) / 2, $corner, $hBrush3)
    ElseIf $pos = 1 Then
        _GDIPlus_leftend($hGraphics, 0, 0, $gwt, $ght, 22, $hBrush)
        _GDIPlus_leftend($hGraphics, $depth, $depth, $gwt - ($depth * 2), $ght / 2, $corner, $hBrush3, 0, 1)
        _GDIPlus_leftend($hGraphics, $depth, $ght / 2, $gwt - ($depth * 2), ($ght - ($depth * 2)) / 2, 20, $hBrush1, 0, 2)
    ElseIf $pos = 2 Then
        _GDIPlus_rightend($hGraphics, 0, 0, $gwt, $ght, 22, $hBrush)
        _GDIPlus_rightend($hGraphics, $depth, $depth, $gwt - ($depth * 2), $ght / 2, $corner, $hBrush3, 0, 1)
        _GDIPlus_rightend($hGraphics, $depth, $ght / 2, $gwt - ($depth * 2), ($ght - ($depth * 2)) / 2, 20, $hBrush1, 0, 2)
    EndIf
    _GDIPlus_BrushDispose($hBrush)
    _GDIPlus_BrushDispose($hBrush1)
    _GDIPlus_BrushDispose($hBrush2)
    _GDIPlus_GraphicsDispose($hGraphics)
    Return $hBitmap
EndFunc ;==>_drawborder1

; rounded rect
Func _GDIPlus_GraphicsDrawRoundRect($hGraphics, $iX, $iY, $iWidth, $iHeight, $iRadius, $hBrush = 0, $hPen = 0)
    _GDIPlus_PenCreate($hPen)
    Local $hPath = _GDIPlus_GraphicsPathCreate()
    _GDIPlus_GraphicsPathAddLine($hPath, $iX + $iRadius, $iY, $iX + $iWidth - ($iRadius * 2), $iY)
    _GDIPlus_GraphicsPathAddArc($hPath, $iX + $iWidth - ($iRadius * 2), $iY, $iRadius * 2, $iRadius * 2, 270, 90)
    _GDIPlus_GraphicsPathAddLine($hPath, $iX + $iWidth, $iY + $iRadius, $iX + $iWidth, $iY + $iHeight - ($iRadius * 2))
    _GDIPlus_GraphicsPathAddArc($hPath, $iX + $iWidth - ($iRadius * 2), $iY + $iHeight - ($iRadius * 2), $iRadius * 2, $iRadius * 2, 0, 90)
    _GDIPlus_GraphicsPathAddLine($hPath, $iX + $iWidth - ($iRadius * 2), $iY + $iHeight, $iX + $iRadius, $iY + $iHeight)
    _GDIPlus_GraphicsPathAddArc($hPath, $iX, $iY + $iHeight - ($iRadius * 2), $iRadius * 2, $iRadius * 2, 90, 90)
    _GDIPlus_GraphicsPathAddLine($hPath, $iX, $iY + $iHeight - ($iRadius * 2), $iX, $iY + $iRadius)
    _GDIPlus_GraphicsPathAddArc($hPath, $iX, $iY, $iRadius * 2, $iRadius * 2, 180, 90)

    ;Draw the font onto the new bitmap
    _GDIPlus_GraphicsPathCloseFigure($hPath)
    If $hBrush <> 0 Then _GDIPlus_GraphicsFillPath($hGraphics, $hBrush, $hPath)
    _GDIPlus_GraphicsDrawPath($hGraphics, $hPen, $hPath)
    _GDIPlus_GraphicsPathDispose($hPath)
    _GDIPlus_PenDispose($hPen)
EndFunc ;==>_GDIPlus_GraphicsDrawRoundRect

;flat left side
Func _GDIPlus_rightend($hGraphics, $iX, $iY, $iWidth, $iHeight, $iRadius, $hBrush = 0, $hPen = 0, $1corner = 0)
    _GDIPlus_PenCreate($hPen)
    Local $hPath = _GDIPlus_GraphicsPathCreate()
    _GDIPlus_GraphicsPathAddLine($hPath, $iX, $iY, $iX + $iWidth, $iY)
    If $1corner <> 2 Then _GDIPlus_GraphicsPathAddArc($hPath, $iX + $iWidth - ($iRadius * 2), $iY, $iRadius * 2, $iRadius * 2, 270, 90)
    _GDIPlus_GraphicsPathAddLine($hPath, $iX + $iWidth, $iY + $iRadius, $iX + $iWidth, $iY + $iHeight - ($iRadius * 2))
    If $1corner <> 1 Then _GDIPlus_GraphicsPathAddArc($hPath, $iX + $iWidth - ($iRadius * 2), $iY + $iHeight - ($iRadius * 2), $iRadius * 2, $iRadius * 2, 0, 90)
    _GDIPlus_GraphicsPathAddLine($hPath, $iX + $iWidth, $iY + $iHeight, $iX, $iY + $iHeight)
    _GDIPlus_GraphicsPathCloseFigure($hPath)
    If $hBrush <> 0 Then _GDIPlus_GraphicsFillPath($hGraphics, $hBrush, $hPath)
    _GDIPlus_GraphicsDrawPath($hGraphics, $hPen, $hPath)
    _GDIPlus_GraphicsPathDispose($hPath)
    _GDIPlus_PenDispose($hPen)
EndFunc ;==>_GDIPlus_rightend
;flat right side
Func _GDIPlus_leftend($hGraphics, $iX, $iY, $iWidth, $iHeight, $iRadius, $hBrush = 0, $hPen = 0, $1corner = 0)

    _GDIPlus_PenCreate($hPen)
    Local $hPath = _GDIPlus_GraphicsPathCreate()
    _GDIPlus_GraphicsPathAddLine($hPath, $iX, $iY, $iX + $iWidth, $iY)
    _GDIPlus_GraphicsPathAddLine($hPath, $iX + $iWidth, $iY + $iHeight, $iX, $iY + $iHeight)
    If $1corner <> 1 Then
        _GDIPlus_GraphicsPathAddArc($hPath, $iX, $iY + $iHeight - ($iRadius * 2), $iRadius * 2, $iRadius * 2, 90, 90)
    Else
        _GDIPlus_GraphicsPathAddArc($hPath, $iX, $iY + $iHeight, $iRadius * 2, $iY, 90, 90)
    EndIf

    If $1corner <> 2 Then
        _GDIPlus_GraphicsPathAddLine($hPath, $iX, $iY + $iHeight, $iX, $iY)
        _GDIPlus_GraphicsPathAddArc($hPath, $iX, $iY, $iRadius * 2, $iRadius * 2, 180, 90)
    EndIf
    ;Draw the font onto the new bitmap
    _GDIPlus_GraphicsPathCloseFigure($hPath)
    If $hBrush <> 0 Then _GDIPlus_GraphicsFillPath($hGraphics, $hBrush, $hPath)
    _GDIPlus_GraphicsDrawPath($hGraphics, $hPen, $hPath)
    _GDIPlus_GraphicsPathDispose($hPath)
    _GDIPlus_PenDispose($hPen)
EndFunc ;==>_GDIPlus_leftend

;rounded on bottom half only
Func _GDIPlus_GraphicsDrawtab2($hGraphics, $iX, $iY, $iWidth, $iHeight, $iRadius, $hBrush = 0, $hPen = 0)
    _GDIPlus_PenCreate($hPen)
    Local $hPath = _GDIPlus_GraphicsPathCreate()
    _GDIPlus_GraphicsPathAddLine($hPath, $iX + $iRadius, $iY, $iX + $iWidth - ($iRadius * 2), $iY)
    _GDIPlus_GraphicsPathAddArc($hPath, $iX + $iWidth, $iY, $iRadius * 2, $iRadius * 2, 270, 90)
    _GDIPlus_GraphicsPathAddLine($hPath, $iX + $iWidth, $iY, $iX + $iWidth + 2, $iY + $iHeight / 2)
    _GDIPlus_GraphicsPathAddArc($hPath, $iX + $iWidth - ($iRadius * 2), $iY + $iHeight - ($iRadius * 2), $iRadius * 2, $iRadius * 2, 0, 90)
    _GDIPlus_GraphicsPathAddLine($hPath, $iX + $iWidth, $iY + $iHeight, $iX, $iY + $iHeight)
    _GDIPlus_GraphicsPathAddArc($hPath, $iX, $iY + $iHeight - ($iRadius * 2), $iRadius * 2, $iRadius * 2, 90, 90)
    _GDIPlus_GraphicsPathAddLine($hPath, $iX, $iY + $iHeight / 2, $iX, $iY)
    ; _GDIPlus_GraphicsPathAddArc($hPath, $iX, $iY, $iRadius * 2, $iRadius * 2, 180, 90)

    ;Draw the font onto the new bitmap
    _GDIPlus_GraphicsPathCloseFigure($hPath)
    If $hBrush <> 0 Then _GDIPlus_GraphicsFillPath($hGraphics, $hBrush, $hPath)
    _GDIPlus_GraphicsDrawPath($hGraphics, $hPen, $hPath)
    _GDIPlus_GraphicsPathDispose($hPath)
    _GDIPlus_PenDispose($hPen)
EndFunc ;==>_GDIPlus_GraphicsDrawtab2

;rounded on top half only
Func _GDIPlus_GraphicsDrawtab($hGraphics, $iX, $iY, $iWidth, $iHeight, $iRadius, $hBrush = 0, $hPen = 0)
    _GDIPlus_PenCreate($hPen)
    Local $hPath = _GDIPlus_GraphicsPathCreate()
    _GDIPlus_GraphicsPathAddLine($hPath, $iX + $iRadius, $iY, $iX + $iWidth - ($iRadius * 2), $iY)
    _GDIPlus_GraphicsPathAddArc($hPath, $iX + $iWidth - ($iRadius * 2), $iY, $iRadius * 2, $iRadius * 2, 270, 90)
    _GDIPlus_GraphicsPathAddLine($hPath, $iX + $iWidth, $iY + $iRadius, $iX + $iWidth, $iY + $iHeight)
    ; _GDIPlus_GraphicsPathAddArc($hPath, $iX + $iWidth - ($iRadius * 2), $iY + $iHeight - ($iRadius * 2), $iRadius * 2, $iRadius * 2, 0, 90)
    _GDIPlus_GraphicsPathAddLine($hPath, $iX + $iWidth, $iY + $iHeight, $iX, $iY + $iHeight)
    ; _GDIPlus_GraphicsPathAddArc($hPath, $iX, $iY + $iHeight - ($iRadius * 2), $iRadius * 2, $iRadius * 2, 90, 90)
    _GDIPlus_GraphicsPathAddLine($hPath, $iX, $iY + $iHeight - ($iRadius * 2), $iX, $iY + $iRadius)
    _GDIPlus_GraphicsPathAddArc($hPath, $iX, $iY, $iRadius * 2, $iRadius * 2, 180, 90)

    ;Draw the font onto the new bitmap
    _GDIPlus_GraphicsPathCloseFigure($hPath)
    If $hBrush <> 0 Then _GDIPlus_GraphicsFillPath($hGraphics, $hBrush, $hPath)
    _GDIPlus_GraphicsDrawPath($hGraphics, $hPen, $hPath)
    _GDIPlus_GraphicsPathDispose($hPath)
    _GDIPlus_PenDispose($hPen)
EndFunc ;==>_GDIPlus_GraphicsDrawtab

Func _GDIPlus_GraphicsPathCreate($iFillMode = 0)
    Local $aResult = DllCall($ghGDIPDll, "int", "GdipCreatePath", "int", $iFillMode, "int*", 0);
    If @error Then Return SetError(@error, @extended, 0)
    Return SetError($aResult[0], 0, $aResult[2])
EndFunc ;==>_GDIPlus_GraphicsPathCreate
Func _GDIPlus_GraphicsPathAddLine($hGraphicsPath, $iX1, $iY1, $iX2, $iY2)
    Local $aResult = DllCall($ghGDIPDll, "int", "GdipAddPathLine", "hwnd", $hGraphicsPath, "float", $iX1, "float", $iY1, _
            "float", $iX2, "float", $iY2)
    If @error Then Return SetError(@error, @extended, 0)
    Return SetError($aResult[0], 0, 0)
EndFunc ;==>_GDIPlus_GraphicsPathAddLine
Func _GDIPlus_GraphicsPathAddArc($hGraphicsPath, $iX, $iY, $iWidth, $iHeight, $iStartAngle, $iSweepAngle)
    Local $aResult = DllCall($ghGDIPDll, "int", "GdipAddPathArc", "hwnd", $hGraphicsPath, "float", $iX, "float", $iY, _
            "float", $iWidth, "float", $iHeight, "float", $iStartAngle, "float", $iSweepAngle)
    If @error Then Return SetError(@error, @extended, 0)
    Return SetError($aResult[0], 0, 0)
EndFunc ;==>_GDIPlus_GraphicsPathAddArc
Func _GDIPlus_GraphicsPathCloseFigure($hGraphicsPath)
    Local $aResult = DllCall($ghGDIPDll, "int", "GdipClosePathFigure", "hwnd", $hGraphicsPath)
    If @error Then Return SetError(@error, @extended, 0)
    Return SetError($aResult[0], 0, 0)
EndFunc ;==>_GDIPlus_GraphicsPathCloseFigure
Func _GDIPlus_GraphicsPathDispose($hGraphicsPath)
    Local $aResult = DllCall($ghGDIPDll, "int", "GdipDeletePath", "hwnd", $hGraphicsPath)
    If @error Then Return SetError(@error, @extended, 0)
    Return SetError($aResult[0], 0, 0)
EndFunc ;==>_GDIPlus_GraphicsPathDispose
Func _GDIPlus_GraphicsDrawPath($hGraphics, $hPen, $hGraphicsPath)
    Local $aResult = DllCall($ghGDIPDll, "int", "GdipDrawPath", "hwnd", $hGraphics, "hwnd", $hPen, "hwnd", $hGraphicsPath)
    If @error Then Return SetError(@error, @extended, 0)
    Return SetError($aResult[0], 0, 0)
EndFunc ;==>_GDIPlus_GraphicsDrawPath
Func _GDIPlus_GraphicsFillPath($hGraphics, $hBrush, $hGraphicsPath)
    Local $aResult = DllCall($ghGDIPDll, "int", "GdipFillPath", "hwnd", $hGraphics, "hwnd", $hBrush, "hwnd", $hGraphicsPath)
    If @error Then Return SetError(@error, @extended, 0)
    Return SetError($aResult[0], 0, 0)
EndFunc ;==>_GDIPlus_GraphicsFillPath

;==== GDIPlus_CreateLineBrushFromRect === Malkey's function
Func _GDIPlus_CreateLineBrushFromRect($iX, $iY, $iWidth, $iHeight, $aFactors, $aPositions, _
        $iArgb1 = 0xFF0000FF, $iArgb2 = 0xFFFF0000, $LinearGradientMode = 0x00000001, $WrapMode = 0)

    Local $tRect, $pRect, $aRet, $tFactors, $pFactors, $tPositions, $pPositions, $iCount

    If $iArgb1 = Default Then $iArgb1 = 0xFF0000FF
    If $iArgb2 = Default Then $iArgb2 = 0xFFFF0000
    If $LinearGradientMode = -1 Or $LinearGradientMode = Default Then $LinearGradientMode = 0x00000001
    If $WrapMode = -1 Or $LinearGradientMode = Default Then $WrapMode = 1

    $tRect = DllStructCreate("float X;float Y;float Width;float Height")
    $pRect = DllStructGetPtr($tRect)
    DllStructSetData($tRect, "X", $iX)
    DllStructSetData($tRect, "Y", $iY)
    DllStructSetData($tRect, "Width", $iWidth)
    DllStructSetData($tRect, "Height", $iHeight)
    $aRet = DllCall($ghGDIPDll, "int", "GdipCreateLineBrushFromRect", "ptr", $pRect, "int", $iArgb1, _
            "int", $iArgb2, "int", $LinearGradientMode, "int", $WrapMode, "int*", 0)

    If IsArray($aFactors) = 0 Then Dim $aFactors[4] = [0.0, 0.4, 0.6, 1.0]
    If IsArray($aPositions) = 0 Then Dim $aPositions[4] = [0.0, 0.3, 0.7, 1.0]
    $iCount = UBound($aPositions)
    $tFactors = DllStructCreate("float[" & $iCount & "]")
    $pFactors = DllStructGetPtr($tFactors)
    For $iI = 0 To $iCount - 1
        DllStructSetData($tFactors, 1, $aFactors[$iI], $iI + 1)
    Next
    $tPositions = DllStructCreate("float[" & $iCount & "]")
    $pPositions = DllStructGetPtr($tPositions)
    For $iI = 0 To $iCount - 1
        DllStructSetData($tPositions, 1, $aPositions[$iI], $iI + 1)
    Next
    $hStatus = DllCall($ghGDIPDll, "int", "GdipSetLineBlend", "hwnd", $aRet[6], _
            "ptr", $pFactors, "ptr", $pPositions, "int", $iCount)
    Return $aRet[6] ; Handle of Line Brush
EndFunc ;==>_GDIPlus_CreateLineBrushFromRect

Func GDIPlus_SetLineGammaCorrection($hBrush, $useGammaCorrection = True)
    Local $aResult
    $aResult = DllCall($ghGDIPDll, "int", "GdipSetLineGammaCorrection", "hwnd", $hBrush, "int", $useGammaCorrection)
    Return $aResult[0]
EndFunc ;==>GDIPlus_SetLineGammaCorrection

; ====== Examples calling _ImageColorRegExpReplace() =========================
; Note colour format hex 0xBBGGRRAA - Blue, Green, Red, Alpha (transparency)

;$hImage2 = _ImageColorRegExpReplace($hImage, "(000000FF)" , "FFFFFFFF" ); Change black to white
;$hImage2 = _ImageColorRegExpReplace($hImage, "(FFFFFFFF)" , "FFFFFF00" ); Change white to transparent
; $hImage2 = _ImageColorRegExpReplace($hImage, "(([0-1][0-9A-F]){3})(FF)" , "${1}00" ); Change near to white to transparent
;$hImage2 = _ImageColorRegExpReplace($hImage, "(FF0000FF|0000AAFF|FFFFFFFF)", "000000FF"); Change blue, off red, white to black

;Swap red and blue channels on half the image. Image is 400x300 = 120,000 pixels. Number of pixels to replace is 60,000.
;$hImage2 = _ImageColorRegExpReplace($hImage, "([0-9A-F]{2})([0-9A-F]{2})([0-9A-F]{2})(FF)", "${3}${2}${1}${4}", 60000)

;$hImage2 = _ImageColorRegExpReplace($hImage, "(([0-9E-F]){6})(FF)", "0000FFFF"); Change near to white to red

; $hImage2 = _ImageColorRegExpReplace($hImage, "av", "FF0000FF"); Change Average colour to blue in BBGGRRAA hex colour format.
;
; ========= _ImageColorRegExpReplace($hImage, $iColSrch, $iColNew,$iCount = 0) =====================
;Paramerers:-
; $hImage   - Handle to a Bitmap object
; $iColSrch - A regular expression pattern to compare the colours to in 0xBBGGRRAA hex colour format.
; $iColNew  - The colour which will replace the regular expression matching colour.Also in 0xBBGGRRAA hex colour format.
; $iCount - [optional] The number of times to execute the replacement in the image. The default is 0. Use 0 for global replacement.
; Note :- Colour format in hex 0xBBGGRRAA
;
Func _ImageColorRegExpReplace($hImage, $iColSrch, $iColNew, $iCount = 0)
    Local $Reslt, $stride, $format, $Scan0, $iIW, $iIH, $hBitmap1
    Local $v_BufferA, $AllPixels, $sREResult1, $sResult

    $iIW = _GDIPlus_ImageGetWidth($hImage)
    $iIH = _GDIPlus_ImageGetHeight($hImage)

    $hBitmap1 = _GDIPlus_BitmapCloneArea($hImage, 0, 0, $iIW, $iIH, $GDIP_PXF32ARGB)

    ; Locks a portion of a bitmap for reading or writing
    $Reslt = _GDIPlus_BitmapLockBits($hBitmap1, 0, 0, $iIW, $iIH, BitOR($GDIP_ILMREAD, $GDIP_ILMWRITE), $GDIP_PXF32ARGB)

    ;Get the returned values of _GDIPlus_BitmapLockBits ()
    $width = DllStructGetData($Reslt, "width")
    $height = DllStructGetData($Reslt, "height")
    $stride = DllStructGetData($Reslt, "stride")
    $format = DllStructGetData($Reslt, "format")
    $Scan0 = DllStructGetData($Reslt, "Scan0")

    $v_BufferA = DllStructCreate("byte[" & $height * $width * 4 & "]", $Scan0) ; Create DLL structure for all pixels
    $AllPixels = DllStructGetData($v_BufferA, 1)
    ;ConsoleWrite("$AllPixels, raw data, first 9 colours = " & StringRegExpReplace($AllPixels, "(.{98})(.*)", "\1") & @CRLF)

    ; Searches on this string - $sREResult1 whch has the prefix "0x"  removed and a space put between pixels 8 characters long.
    $sREResult1 = StringRegExpReplace(StringTrimLeft($AllPixels, 2), "(.{8})", "\1 ")
    ;ConsoleWrite("$sREResult1 first 9 colours = " & StringRegExpReplace($sREResult1, "(.{81})(.*)", "\1") & @CRLF)

    ;======================  Average colour ===============================
    If StringInStr($iColSrch, "av") > 0 Then
        Local $iBlue, $iGreen, $iRed, $iAlpha, $avBlue, $avGreen, $avRed, $aviAlpha
        For $x = 1 To StringLen($sREResult1) Step 9
            $iBlue += Dec(Hex("0x" & StringMid($sREResult1, $x, 2)))
            $iGreen += Dec(Hex("0x" & StringMid($sREResult1, $x + 2, 2)))
            $iRed += Dec(Hex("0x" & StringMid($sREResult1, $x + 4, 2)))
            $iAlpha += Dec(Hex("0x" & StringMid($sREResult1, $x + 6, 2)))
            ;MsgBox(0,"","0x" & Hex($iAlpha,2) & Hex($iRed,2)  & Hex($iGreen,2)  &  Hex($iBlue,2) )
        Next
        $avBlue = Hex(Round($iBlue / ($height * $width), 0), 2)
        $avGreen = Hex(Round($iGreen / ($height * $width), 0), 2)
        $avRed = Hex(Round($iRed / ($height * $width), 0), 2)
        $aviAlpha = Hex(Round($iAlpha / ($height * $width), 0), 2)

        MsgBox(0, "", "$width = " & $width & @CRLF & _
                "$height = " & $height & @CRLF & _
                "Blue = " & $avBlue & @CRLF & _
                "$iGreen = " & $avGreen & @CRLF & _
                "$iRed = " & $avRed & @CRLF & _
                "$iAlpha = " & $aviAlpha & @CRLF & _
                "Av.Col ARGB = " & "0x" & $aviAlpha & $avRed & $avGreen & $avBlue)

        Local $iRnge = 30 ; Range 30 is plus or minus 15 for each colour channel, max 0xFF and min 0x00.
        $iColSrch = StringRERange("0x" & $avBlue, $iRnge) & StringRERange("0x" & $avGreen, $iRnge) & _
                StringRERange("0x" & $avRed, $iRnge) & StringRERange("0x" & $aviAlpha, $iRnge)
        ;ConsoleWrite("$iColSrch " & $iColSrch & @CRLF)
    EndIf
    ;=================> End of Average colour ===============================

    If StringInStr($iColNew, "0x") > 0 Then $iColNew = StringReplace($iColNew, "0x", ""); Remove "0x" not needed

    ; StringRegExpReplace performed and white spaces removed
    $sResult = StringStripWS(StringRegExpReplace($sREResult1, $iColSrch, $iColNew, $iCount), 8)

    ; Replace "0x" prefix and set modified data back to DLL structure, $v_BufferA
    DllStructSetData($v_BufferA, 1, "0x" & $sResult)
    _GDIPlus_BitmapUnlockBits($hBitmap1, $Reslt) ; releases the locked region

    Return $hBitmap1
EndFunc   ;==>_ImageColorRegExpReplace


; #FUNCTION# =========================================================================================================
; Name...........: _Area_Average_Colour
; Description ...: Returns average colour within a defined are of the display
; Syntax ........: _Area_Average_Colour([$iStep [, $iLeft [, $iTop [, $iWidth [, $iHeight ]]]]])
; Parameters ....: $iStep - Pixel resolution value. Lower values give better resolution but take longer. (Default = 10)
;   $iLeft - X coordinate of top-left corner of area (Default = 0 - left edge of screen)
;   $iTop   - Y coordinate of top-left corner of area (Default = 0 - top edge of screen)
;   $iWidth - Width of the area (Default = @DesktopWidth)
;   $iHeight - Height of the area (Default = @DesktopHeight)
; Requirement(s) : v3.3.0.0 or higher
; Return values .: Success - Returns six character string containing RGB hex values
;   Failure - Returns 0 and sets @error:
;   1 - Screen Capture failure
;   2 - GDI function failure
; Author ........: Melba23. Credit to Malkey for the basic GDI code
; Modified ......: Minor change by Picea892 pass bmp instead of using screenshot
; Remarks .......:
; Example .......: Yes
;=====================================================================================================================
Func _Area_Average_Colour($hImage, $iStep = 10, $iLeft = 0, $iTop = 0, $iWidth = 32, $iHeight = 32)

    Local $iBlue = 0, $iGreen = 0, $iRed = 0, $iInterim_Blue = 0, $iInterim_Green = 0, $iInterim_Red = 0, $iInner_Count = 0, $iOuter_Count = 0
    Local $tRes = _GDIPlus_BitmapLockBits($hImage, 0, 0, $iWidth, $iHeight, BitOR($GDIP_ILMREAD, $GDIP_ILMWRITE), $GDIP_PXF32ARGB)
    If @error Then
        _GDIPlus_GraphicsDispose($hImage)
        Return SetError(2, 0, 0)
    EndIf

    ;Get the returned values of _GDIPlus_BitmapLockBits()
    Local $iLock_Width = DllStructGetData($tRes, "width")
    Local $iLock_Height = DllStructGetData($tRes, "height")
    Local $iLock_Stride = DllStructGetData($tRes, "stride")
    Local $iLock_Scan0 = DllStructGetData($tRes, "Scan0")

    ; Run through the BitMap testing pixels at the step distance
    For $i = 0 To $iWidth - 1 Step $iStep
        For $j = 0 To $iHeight - 1 Step $iStep
            Local $v_Buffer = DllStructCreate("dword", $iLock_Scan0 + ($j * $iLock_Stride) + ($i * 4))
            ; Get colour value of pixel
            Local $v_Value = DllStructGetData($v_Buffer, 1)
            ; Add components
            $iBlue += _ColorGetBlue($v_Value)
            $iGreen += _ColorGetGreen($v_Value)
            $iRed += _ColorGetRed($v_Value)
            ; Adjust counter
            $iInner_Count += 1
        Next
        ; Determine average value so far - this prevents value becoming too large
        $iInterim_Blue += $iBlue / $iInner_Count
        $iBlue = 0
        $iInterim_Green += $iGreen / $iInner_Count
        $iGreen = 0
        $iInterim_Red += $iRed / $iInner_Count
        $iRed = 0
        ; Adjust counters
        $iInner_Count = 0
        $iOuter_Count += 1
    Next
    ; Determine final average
    Local $avBlue = Hex(Round($iInterim_Blue / $iOuter_Count, 0), 2)
    Local $avGreen = Hex(Round($iInterim_Green / $iOuter_Count, 0), 2)
    Local $avRed = Hex(Round($iInterim_Red / $iOuter_Count, 0), 2)

    ; Clear up
    _GDIPlus_BitmapUnlockBits($hImage, $tRes)
    _GDIPlus_GraphicsDispose($hImage)

    Return ($avRed & $avGreen & $avBlue)

EndFunc ;==>_Area_Average_Colour

Func _InvertColor($iColor, $mode = 1)
    Switch $mode
        Case 0
            Return "0x" & Hex(0xFFFFFF - $iColor, 6)
        Case 1
            Return "0x" & StringRegExpReplace(Hex($iColor, 6), "(.{2})(.{2})(.{2})", "\3\2\1")
        Case 2
            Return "0x" & StringRegExpReplace(Hex(0xFFFFFF - $iColor, 6), "(.{2})(.{2})(.{2})", "\3\2\1")
    EndSwitch
EndFunc ;==>_InvertColor
 
 Func StringRERange($iColSrch, $iRnge)
    Local $str = "(", $iColSrchMin, $iColSrchMax
    $iColSrchMin = "0x" & Hex((Dec(Hex($iColSrch)) - $iRnge) * ((Dec(Hex($iColSrch)) - $iRnge) > 0), 2)
    $iColSrchMax = "0x" & Hex((Dec(Hex($iColSrch)) + $iRnge) * ((Dec(Hex($iColSrch)) + $iRnge) < 255) + 255, 2)
    For $n = $iColSrchMin To $iColSrchMax
        $str &= Hex($n, 2) & "|"
    Next
    $str = StringTrimRight($str, 1) & ")"
    Return $str
EndFunc   ;==>StringRERange


Func _GDIPlus_GraphicsDrawclose($hGraphics, $iX, $iY, $iWidth, $iHeight, $iRadius, $hBrush = 0, $hPen = 0)
    _GDIPlus_PenCreate($hPen)
    Local $hPath = _GDIPlus_GraphicsPathCreate()
	$leftit=$iWidth-31
	$downit=5
    _GDIPlus_GraphicsPathAddArc($hPath, $leftit-3, $downit-3, 22,22,0, 360) ; this is the circle around the X
    ;;;;;;;;;;;;;;;;;;;;;;;;;;Script for the X
        _GDIPlus_GraphicsPathAddLine($hPath,  $leftit+2, $downit, $leftit+2,$downit)
        _GDIPlus_GraphicsPathAddLine($hPath, $leftit+8, $downit+6,$leftit+14,$downit)
        _GDIPlus_GraphicsPathAddLine($hPath,$leftit+16, $downit+2,$leftit+10,$downit+8)
        _GDIPlus_GraphicsPathAddLine($hPath, $leftit+16,$downit+14,$leftit+14,$downit+16)
        _GDIPlus_GraphicsPathAddLine($hPath, $leftit+8,$downit+10,$leftit+2,$downit+16)
        _GDIPlus_GraphicsPathAddLine($hPath, $leftit, $downit+14,$leftit+6 ,$downit+8)
        _GDIPlus_GraphicsPathAddLine($hPath, $leftit, $downit+2,$leftit, $downit+2)
      ;  _GDIPlus_GraphicsPathAddLine($hPath, $leftit ,$downit,$iWidth - ($iRadius * 2), $iY)
        ;;;;;;;;;;;;;;;;;;;;;;;;;Script for the X ends
    ;Draw the font onto the new bitmap
    _GDIPlus_GraphicsPathCloseFigure($hPath)
    If $hBrush <> 0 Then _GDIPlus_GraphicsFillPath($hGraphics, $hBrush, $hPath)
    _GDIPlus_GraphicsDrawPath($hGraphics, $hPen, $hPath)
    _GDIPlus_GraphicsPathDispose($hPath)
    _GDIPlus_PenDispose($hPen)
	Return $hGraphics
EndFunc