#include <GUIConstantsEx.au3>
#include <GDIPlus.au3>
#include <WindowsConstants.au3>
#include "wiimote.au3"

Opt("GUIOnEventMode", 1)

Global $kernel32 = DllOpen('Kernel32.dll')
Global $Time = TimerInit()

;GUI is going to be half the size of IR Screen Resolution. Data will be divided in half to match.
Global Const $width = 1023/2 ;  $aIRD[4] = raw X coordinate (0-1023)
Global Const $height = 767/2 ;  $aIRD[5] = raw Y coordinate (0-767)

;Create GUI and Set Exit
Global $hGUI = GUICreate("Wiimote IR Tracking GDI+ Example", $width, $height)
GUISetState()
GUISetOnEvent($GUI_EVENT_CLOSE, "_Exit");

;Connect to Wiimote
_Wii_Connect()
If @error Then
	MsgBox(16, 'Error', 'Failed connecting to WiiMote....Exiting', 5)
	Exit
Else
	ConsoleWrite('Connected!!' & @CRLF)
EndIf

;Set IR Dot Tracking Handler and enable IR Tracking
_Wii_SetIRDotTrackingHandler('_UpdateDotArrays')
_Wii_SetIRTrackingMode(1)

;Setup GDI+
_GDIPlus_Startup()
Global Const $hBrush_bg = _GDIPlus_BrushCreateSolid(0xFF000000)
Global Const $hGraphic = _GDIPlus_GraphicsCreateFromHWND($hGUI)
Global Const $g_hDC = _WinAPI_GetDC($hGUI)
Global $hBitmap = _GDIPlus_BitmapCreateFromGraphics($width, $height, $hGraphic)
Global $Buffer = _GDIPlus_ImageGetGraphicsContext($hBitmap)
_GDIPlus_GraphicsSetSmoothingMode($Buffer, 4)
_GDIPlus_GraphicsFillRect($Buffer, 0, 0, $width, $height, $hBrush_bg)
_GDIPlus_GraphicsClear($Buffer, 0xFF000000)
_WriteBuffer($hBitmap, $g_hDC, 0, 0, $width, $height)

;Create a bunch of different size glowing balls. not needed right now since im only using one size but will later.
Global Const $iBallColor = 0xFFFFFFFF
Global $aBalls[101]
For $i = 1 To 100
	$aBalls[$i] = CreateGlowingBall($hGraphic, $i, $iBallColor, 0xB00000ff)
Next

;these arrays hold invidual IR Dot data 1-4. (3 and 4 are not working)
Global $g_aIRDot0[8], $g_aIRDot1[8], $g_aIRDot2[8], $g_aIRDot3[8]
Global $r = 35; ball size
Do
	;check wiimote for new messages
	_Wii_CheckMsg()

	;If Dot is visible and the cordinates and not x = 0, y  = 0 the Draw ball. x and y are divided by to to match our drawing grid.
	If $g_aIRDot0[1] And $g_aIRDot0[4] <> 0 And $g_aIRDot0[5] <> 0 Then _DrawBall($r, $g_aIRDot0[4]/2, $height - ($g_aIRDot0[5]/2), $r, $r)
	If $g_aIRDot1[1] And $g_aIRDot1[4] <> 0 And $g_aIRDot1[5] <> 0 Then _DrawBall($r, $g_aIRDot1[4]/2, $height - ($g_aIRDot1[5]/2), $r, $r)
	If $g_aIRDot2[1] And $g_aIRDot2[4] <> 0 And $g_aIRDot2[5] <> 0 Then _DrawBall($r, $g_aIRDot2[4]/2, $height - ($g_aIRDot2[5]/2), $r, $r)
	If $g_aIRDot3[1] And $g_aIRDot3[4] <> 0 And $g_aIRDot3[5] <> 0 Then _DrawBall($r, $g_aIRDot3[4]/2, $height - ($g_aIRDot3[5]/2), $r, $r)

	;Write Buffer to screen
	_WriteBuffer($hBitmap, $g_hDC, 0, 0, $width, $height)

	;Clear the buffer.
	_GDIPlus_GraphicsClear($Buffer, 0xFF000000)

Until Not _Sleep(5)

;Handles updating the indivdual IR Dot arrays
Func _UpdateDotArrays($aIRD)

;~ - $aIRD[0] = IR Source Number
;~ - $aIRD[1] = Visible
;~ - $aIRD[2] = interpolated X coordinate
;~ - $aIRD[3] = interpolated Y coordinate
;~ - $aIRD[4] = raw X coordinate (0-1023)
;~ - $aIRD[5] = raw Y coordinate (0-767)
;~ - $aIRD[6] = increasing order by x-axis value
;~ - $aIRD[7] = size of the IR dot (0-15)

	Switch $aIRD[0]
		Case 0
			$g_aIRDot0 = $aIRD
		Case 1
			$g_aIRDot1 = $aIRD
		Case 2
			$g_aIRDot2 = $aIRD
		Case 3
			$g_aIRDot3 = $aIRD
	EndSwitch

EndFunc

Func _Sleep($ms = 1)
	DllCall($kernel32, 'none', 'Sleep', 'DWORD', $ms)
	Return True
EndFunc   ;==>_Sleep

;Writes buffer to screen
Func _WriteBuffer($BitmapHandle, $DC_Handle, $iX, $iY, $iWidth, $iHeight)

	Local $hGDI_HBitmap = _GDIPlus_BitmapCreateHBITMAPFromBitmap($BitmapHandle)
	Local $hDC = _WinAPI_CreateCompatibleDC($DC_Handle)
	_WinAPI_SelectObject($hDC, $hGDI_HBitmap)
	_WinAPI_BitBlt($DC_Handle, $iX, $iY, $iWidth, $iHeight, $hDC, 0, 0, 0x00CC0020);$SRCCOPY)
	_WinAPI_DeleteObject($hGDI_HBitmap)
	_WinAPI_DeleteDC($hDC)

EndFunc   ;==>_WriteBuffer

;Draws ball to buffer
Func _DrawBall($size, $x, $y, $w, $h)
	_GDIPlus_GraphicsDrawImageRect($Buffer, $aBalls[$size], $x, $y, $w, $h)
EndFunc

;Release resources.
Func _Exit()
	; None of the registered exit functions seem to be getting called if in OnEventMode. need to check
	_Release();_wii_Release
	_WiiClose()
	_GDIPlus_BrushDispose($hBrush_bg)
	_GDIPlus_BitmapDispose($hBitmap)
	_GDIPlus_GraphicsDispose($Buffer)
	_GDIPlus_GraphicsDispose($hGraphic)
	_GDIPlus_Shutdown()
	Exit
EndFunc   ;==>_Exit

#region Create Glowing Ball functions
Func CreateGlowingBall($hGraphics, $iRadius, $iBallColor = 0xFFFFFFFF, $iColor2 = 0xFF00FF00) ; thanks to Eukalyptus for this function ;-)
	Local $hBitmap = _GDIPlus_BitmapCreateFromGraphics($iRadius * 2, $iRadius * 2, $hGraphics)
	Local $hContext = _GDIPlus_ImageGetGraphicsContext($hBitmap)
;~     _GDIPlus_GraphicsSetSmoothingMode($hContext, 2)

	;create glow
	$hPath = DllCall($ghGDIPDll, "uint", "GdipCreatePath", "int", 0, "int*", 0) ;_GDIPlus_PathCreate()
	$hPath = $hPath[2]
	DllCall($ghGDIPDll, "uint", "GdipAddPathEllipse", "hwnd", $hPath, "float", 0, "float", 0, "float", $iRadius * 2, "float", $iRadius * 2) ;_GDIPlus_PathAddEllipse($hPath, 0, 0, $iRadius * 2, $iRadius * 2)
	$hBrush = DllCall($ghGDIPDll, "uint", "GdipCreatePathGradientFromPath", "hwnd", $hPath, "int*", 0) ;_GDIPlus_PathBrushCreateFromPath($hPath)
	$hBrush = $hBrush[2]
	DllCall($ghGDIPDll, "uint", "GdipSetPathGradientSigmaBlend", "hwnd", $hBrush, "float", 0.4, "float", 0.45) ;_GDIPlus_PathBrushSetSigmaBlend($hBrush, 0.4, 0.45)
	DllCall($ghGDIPDll, "uint", "GdipSetPathGradientCenterColor", "hwnd", $hBrush, "uint", $iColor2) ;_GDIPlus_PathBrushSetCenterColor($hBrush, $iColor2)
	Local $aColor[2] = [1, BitAND($iBallColor, 0x00FFFFFF)]
	_GDIPlus_PathBrushSetSurroundColorsWithCount($hBrush, $aColor)
	DllCall($ghGDIPDll, "uint", "GdipDeletePath", "hwnd", $hPath) ;_GDIPlus_PathDispose($hPath)
	_GDIPlus_GraphicsFillEllipse($hContext, 0, 0, $iRadius * 2, $iRadius * 2, $hBrush)
	_GDIPlus_BrushDispose($hBrush)

	;create ball
	$hPath = DllCall($ghGDIPDll, "uint", "GdipCreatePath", "int", 0, "int*", 0) ;_GDIPlus_PathCreate()
	$hPath = $hPath[2]
	DllCall($ghGDIPDll, "uint", "GdipAddPathEllipse", "hwnd", $hPath, "float", $iRadius / 2, "float", $iRadius / 2, "float", $iRadius, "float", $iRadius) ;_GDIPlus_PathAddEllipse($hPath, $iRadius / 2, $iRadius / 2, $iRadius, $iRadius)
	$hBrush = DllCall($ghGDIPDll, "uint", "GdipCreatePathGradientFromPath", "hwnd", $hPath, "int*", 0) ;_GDIPlus_PathBrushCreateFromPath($hPath)
	$hBrush = $hBrush[2]
	DllCall($ghGDIPDll, "uint", "GdipSetPathGradientSigmaBlend", "hwnd", $hBrush, "float", 1, "float", 0.95) ;_GDIPlus_PathBrushSetSigmaBlend($hBrush, 1, 0.95)
	DllCall($ghGDIPDll, "uint", "GdipSetPathGradientGammaCorrection", "hwnd", $hBrush, "int", True) ;_GDIPlus_PathBrushSetGammaCorrection($hBrush, True)
	_GDIPlus_PathBrushSetCenterPoint($hBrush, $iRadius, $iRadius)
	DllCall($ghGDIPDll, "uint", "GdipSetPathGradientCenterColor", "hwnd", $hBrush, "uint", $iBallColor) ;_GDIPlus_PathBrushSetCenterColor($hBrush, $iBallColor)
	Local $aColor[2] = [1, $iColor2]
	_GDIPlus_PathBrushSetSurroundColorsWithCount($hBrush, $aColor)
	DllCall($ghGDIPDll, "uint", "GdipDeletePath", "hwnd", $hPath) ;_GDIPlus_PathDispose($hPath)
	_GDIPlus_GraphicsFillEllipse($hContext, $iRadius / 2, $iRadius / 2, $iRadius, $iRadius, $hBrush)
	_GDIPlus_BrushDispose($hBrush)

	_GDIPlus_GraphicsDispose($hContext)

	Return $hBitmap
EndFunc   ;==>CreateGlowingBall

Func _GDIPlus_PathBrushSetCenterPoint($hPathGradientBrush, $nX, $nY)
	Local $pPointF, $tPointF, $aResult
	$tPointF = DllStructCreate("float;float")
	$pPointF = DllStructGetPtr($tPointF)
	DllStructSetData($tPointF, 1, $nX)
	DllStructSetData($tPointF, 2, $nY)
	$aResult = DllCall($ghGDIPDll, "uint", "GdipSetPathGradientCenterPoint", "handle", $hPathGradientBrush, "ptr", $pPointF)
	If @error Then Return SetError(@error, @extended, False)
	Return $aResult[0] = 0
EndFunc   ;==>_GDIPlus_PathBrushSetCenterPoint

Func _GDIPlus_PathBrushSetSurroundColorsWithCount($hPathGradientBrush, $aColors)
	Local $iI, $iCount, $iColors, $tColors, $pColors, $aResult
	$iCount = $aColors[0]
	$iColors = DllCall($ghGDIPDll, "uint", "GdipGetPathGradientPointCount", "hwnd", $hPathGradientBrush, "int*", 0) ;_GDIPlus_PathBrushGetPointCount($hPathGradientBrush)
	If @error Then Return SetError(@error, @extended, False)
	$iColors = $iColors[2]

	$tColors = DllStructCreate("uint[" & $iCount & "]")
	$pColors = DllStructGetPtr($tColors)

	For $iI = 1 To $iCount
		DllStructSetData($tColors, 1, $aColors[$iI], $iI)
	Next
	$aResult = DllCall($ghGDIPDll, "uint", "GdipSetPathGradientSurroundColorsWithCount", "hwnd", $hPathGradientBrush, "ptr", $pColors, "int*", $iCount)
	If @error Then Return SetError(@error, @extended, False)
	Return $aResult[0] = 0
EndFunc   ;==>_GDIPlus_PathBrushSetSurroundColorsWithCount

Func Min($a, $b)
	If $a > $b Then Return $b
	Return $a
EndFunc   ;==>Min
#endregion

