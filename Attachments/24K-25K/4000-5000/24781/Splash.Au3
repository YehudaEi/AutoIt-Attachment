#include <WindowsConstants.au3>
#include <GUIConstants.au3>
#Include <GDIPlus.au3>
Global $SplashGUI, $hSplashImage
Global $HotLabelTxt

Func DisplaySplash()
Local $pngSrc, $width, $height, $i
	; Load PNG file as GDI bitmap
	$pngSrc = @WorkingDir & "\Splash.png"
	If NOT FileExists($pngSrc) Then
	   SetError(1)
	   Return
	EndIf
	_GDIPlus_Startup()
	$hSplashImage = _GDIPlus_ImageLoadFromFile($pngSrc)
	; Extract image width and height from PNG
	$width = _GDIPlus_ImageGetWidth($hSplashImage)
	$height = _GDIPlus_ImageGetHeight($hSplashImage)
	; Create layered window
	$SplashGUI = GUICreate("", $width, $height, -1, -1, $WS_POPUP, $WS_EX_LAYERED, $DS_MODALFRAME)
	SetBitmap($SplashGUI, $hSplashImage, 0)
	GUISetState()
	WinSetOnTop($SplashGUI, "", 1)
	;fade in png background
	For $i = 0 To 255 Step 5
    	SetBitmap($SplashGUI, $hSplashImage, $i)
	Next
EndFunc	;==>DisplaySplash

Func DismissSplash()
Local $i
	If Not IsHWnd($SplashGUI) Then
	   SetError(1)
	   Return
	EndIf
	;fade out png background
	For $i = 255 To 0 Step - 5
      SetBitmap($SplashGUI, $hSplashImage, $i)
	Next
	; Release resources
	_GDIPlus_ImageDispose($hSplashImage)
	_GDIPlus_Shutdown()
	GUIDelete($SplashGUI)
EndFunc	;==>DismissSplash()

Func SetBitmap($hGUI, $hImage, $iOpacity)
Const $AC_SRC_ALPHA = 1
;Const $ULW_ALPHA = 2
Local $hScrDC, $hMemDC, $hBitmap, $hOld, $pSize, $tSize, $pSource, $tSource, $pBlend, $tBlend
local $hBrush, $hFormat, $hFamily, $hFont, $tLayout,$hGraphic
    $hScrDC = _WinAPI_GetDC(0)
    $hMemDC = _WinAPI_CreateCompatibleDC($hScrDC)
    $hBitmap = _GDIPlus_BitmapCreateHBITMAPFromBitmap($hImage)
    $hOld = _WinAPI_SelectObject($hMemDC, $hBitmap)
    $hGraphic = _GDIPlus_GraphicsCreateFromHDC ($hMemDC)

    $hBrush  = _GDIPlus_BrushCreateSolid (0xffFA0C0A)
    $hFormat = _GDIPlus_StringFormatCreate ()
    $hFamily = _GDIPlus_FontFamilyCreate ("Arial")
    $hFont   = _GDIPlus_FontCreate ($hFamily, 32, 1)
    $tLayout = _GDIPlus_RectFCreate ( 100, 200, 350, 50 )
    _GDIPlus_GraphicsDrawStringEx ($hGraphic, $HotLabelTxt, $hFont, $tLayout, $hFormat, $hBrush)

    $tSize = DllStructCreate($tagSIZE)
    $pSize = DllStructGetPtr($tSize)
    DllStructSetData($tSize, "X", _GDIPlus_ImageGetWidth($hImage))
    DllStructSetData($tSize, "Y", _GDIPlus_ImageGetHeight($hImage))
    $tSource = DllStructCreate($tagPOINT)
    $pSource = DllStructGetPtr($tSource)
    $tBlend = DllStructCreate($tagBLENDFUNCTION)
    $pBlend = DllStructGetPtr($tBlend)
    DllStructSetData($tBlend, "Alpha", $iOpacity)
    DllStructSetData($tBlend, "Format", $AC_SRC_ALPHA)
    _WinAPI_UpdateLayeredWindow($hGUI, $hScrDC, 0, $pSize, $hMemDC, $pSource, 0, $pBlend, $ULW_ALPHA)
    _WinAPI_ReleaseDC(0, $hScrDC)
    _WinAPI_SelectObject($hMemDC, $hOld)
    _WinAPI_DeleteObject($hBitmap)
    _WinAPI_DeleteDC($hMemDC)
    _GDIPlus_FontDispose ($hFont)
    _GDIPlus_FontFamilyDispose ($hFamily)
   _GDIPlus_StringFormatDispose ($hFormat)
   _GDIPlus_BrushDispose ($hBrush)
EndFunc   ;==>SetBitmap