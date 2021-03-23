; Note: if you are using AutoIt v3.3.8.1 or lower, comment out lines (63, 127, 174) and uncomment lines (64, 128, 175).
#include <GDIPlus.au3>
#include <WinAPI.au3>
#include <WindowsConstants.au3>
#include <GuiConstantsEx.au3>
#include <Math.au3>
#include <Misc.au3>
#include <WinAPI.au3>
#include <Memory.au3>

; #AutoIt3Wrapper_au3check_parameters=-d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6 -w- 7

Global Const $AC_SRC_ALPHA = 1
Global Const $nPI = 3.1415926535897932384626433832795

Global $ahDrawState
Global $iN, $iMsg

Global $iRadius = 200
Global $iPrevRadius = 200
Global $iMaxRadius = 300
Global $iCursorSec = $iRadius / 20, $iCursorMin = $iRadius / 20, $iCursorHour = Int($iRadius / 40 + $iRadius / 100)
Global $aiSecCursorPos[$iCursorSec][2], $aiMinCursorPos[$iCursorMin][2], $aiHourCursorPos[$iCursorHour][2]

_GDIPlus_Startup()
Global Enum $iCURSOR_W, $iCURSOR_B, $iCURSOR_R, $iCURSOR_Bl, $iCURSOR_P, $iCURSOR_MAX
Global $ahCursor[5]
_SetCursorBinary($ahCursor)
For $i = 0 To $iCURSOR_MAX - 1
	$ahCursor[$i] = _GDIPlus_BMPFromMemory($ahCursor[$i])
Next

#Region GUI
Global $hGUI = GUICreate("Cursor Clock", $iMaxRadius * 2 + 17, $iMaxRadius * 2 + 24, -1, -1, $WS_POPUP, $WS_EX_LAYERED)
Global $hLable = GUICtrlCreateLabel("", 0, 0, $iMaxRadius * 2 + 17, $iMaxRadius * 2 + 24, -1, $GUI_WS_EX_PARENTDRAG)
Global $hContextMenu = GUICtrlCreateContextMenu($hLable)

Global $hContextMenu_Resize = GUICtrlCreateMenu("Size", $hContextMenu)
Global $ahResizeMenuItems[8]
For $x = 0 To 7
	$ahResizeMenuItems[$x] = GUICtrlCreateMenuItem($x * 20 + 160, $hContextMenu_Resize)
Next
GUICtrlSetState($ahResizeMenuItems[($iRadius - 160) / 20], $GUI_CHECKED)

GUICtrlCreateMenuItem("", $hContextMenu)
Global $hContextMenu_Exit = GUICtrlCreateMenuItem("Exit", $hContextMenu)

GUISetState(@SW_SHOW)
#EndRegion GUI
#Region Clock intro
Global $iStep = 25, $nCurRadius = 1, $nAddtoCurRadius = $iRadius / $iStep
Global $nCurRadian = 0, $nAddToCurRadian = 20 / $iStep
For $iStepAmount = 1 To $iStep
	$nCurRadius += $nAddtoCurRadius
	$nCurRadian += $nAddToCurRadian

	$ahDrawState = _LayeredWindow_StartDraw($iMaxRadius * 2 + 17, $iMaxRadius * 2 + 24)
	_GDIPlus_GraphicsDrawImage_Int($ahDrawState[1], $ahCursor[$iCURSOR_W], $iMaxRadius, $iMaxRadius)

	$iN = 0
	For $iI = 0 To 2 * $nPI Step $nPI / 30
		If $iN > 59 Then ExitLoop
		_GDIPlus_GraphicsDrawImage_Int($ahDrawState[1], (Mod($iN, 5) = 0) ? ($ahCursor[$iCURSOR_Bl]) : ($ahCursor[$iCURSOR_W]), $iMaxRadius + Cos($iI) * $nCurRadius, $iMaxRadius - Sin($iI) * $nCurRadius)
;~ 		_GDIPlus_GraphicsDrawImage_Int($ahDrawState[1], _Iif(Mod($iN, 5) = 0, $ahCursor[$iCURSOR_Bl], $ahCursor[$iCURSOR_W]), $iMaxRadius + Cos($iI) * $nCurRadius, $iMaxRadius - Sin($iI) * $nCurRadius) ; <= 3.3.8.1
		$iN += 1
	Next

	For $x = 1 To $iCursorSec
		If $x <= $iCursorMin Then
			_GDIPlus_GraphicsDrawImage_Int($ahDrawState[1], $ahCursor[$iCURSOR_R], $iMaxRadius + Cos(TimeToRadians("min")) * ($x * $nCurRadian), $iMaxRadius - Sin(TimeToRadians("min")) * ($x * $nCurRadian))
		EndIf
		If $x <= $iCursorHour Then
			_GDIPlus_GraphicsDrawImage_Int($ahDrawState[1], $ahCursor[$iCURSOR_P], $iMaxRadius + Cos(TimeToRadians("hour")) * ($x * $nCurRadian), $iMaxRadius - Sin(TimeToRadians("hour")) * ($x * $nCurRadian))
		EndIf
		_GDIPlus_GraphicsDrawImage_Int($ahDrawState[1], $ahCursor[$iCURSOR_B], $iMaxRadius + Cos(TimeToRadians("sec")) * ($x * $nCurRadian), $iMaxRadius - Sin(TimeToRadians("sec")) * ($x * $nCurRadian))
	Next

	_LayeredWindow_EndDraw($hGUI, $ahDrawState)
Next
_ResetCursorPosBuffers()

GUIRegisterMsg($WM_NCHITTEST, "WM_NCHITTEST")
OnAutoItExitRegister("_Exit")
_Update()
AdlibRegister("_Update", 1000)
#EndRegion Clock intro

While 1
	$iMsg = GUIGetMsg()
	If $iMsg = $GUI_EVENT_CLOSE Or $iMsg = $hContextMenu_Exit Then
		Exit
	EndIf
	For $x = 0 To 7
		If $iMsg = $ahResizeMenuItems[$x] And $x <> ($iRadius - 160) / 20 Then
			AdlibUnRegister("_Update")
			GUICtrlSetState($ahResizeMenuItems[($iRadius - 160) / 20], $GUI_UNCHECKED)
			$iPrevRadius = $iRadius
			$iRadius = $x * 20 + 160
			GUICtrlSetState($ahResizeMenuItems[($iRadius - 160) / 20], $GUI_CHECKED)
			$iCursorSec = $iRadius / 20
			$iCursorMin = $iRadius / 20
			$iCursorHour = Int($iRadius / 40 + $iRadius / 100)
			ReDim $aiSecCursorPos[$iCursorSec][2], $aiMinCursorPos[$iCursorMin][2], $aiHourCursorPos[$iCursorHour][2]
			_ResetCursorPosBuffers()
			_Update()
			AdlibRegister("_Update", 1000)
			ExitLoop
		EndIf
	Next
WEnd

Func _Exit()
	AdlibUnRegister("_Update")
	Local $iStep = 25, $nCurRadius = $iRadius, $nAddtoCurRadius = $iRadius / $iStep
	Local $nCurRadian = 20, $nAddToCurRadian = 20 / $iStep
	For $iStepAmount = 1 To $iStep
		$nCurRadius -= $nAddtoCurRadius
		$nCurRadian -= $nAddToCurRadian

		$ahDrawState = _LayeredWindow_StartDraw($iMaxRadius * 2 + 17, $iMaxRadius * 2 + 24)

		_GDIPlus_GraphicsDrawImage_Int($ahDrawState[1], $ahCursor[$iCURSOR_W], $iMaxRadius, $iMaxRadius)

		$iN = 0
		For $iI = 0 To 2 * $nPI Step $nPI / 30
			If $iN > 59 Then ExitLoop
			_GDIPlus_GraphicsDrawImage_Int($ahDrawState[1], (Mod($iN, 5) = 0) ? ($ahCursor[$iCURSOR_Bl]) : ($ahCursor[$iCURSOR_W]), $iMaxRadius + Cos($iI) * $nCurRadius, $iMaxRadius - Sin($iI) * $nCurRadius)
;~ 			_GDIPlus_GraphicsDrawImage_Int($ahDrawState[1], _Iif(Mod($iN, 5) = 0, $ahCursor[$iCURSOR_Bl], $ahCursor[$iCURSOR_W]), $iMaxRadius + Cos($iI) * $nCurRadius, $iMaxRadius - Sin($iI) * $nCurRadius) ; <= 3.3.8.1
			$iN += 1
		Next

		For $x = 0 To $iCursorSec - 1
			If $x < $iCursorMin Then
				_GDIPlus_GraphicsDrawImage_Int($ahDrawState[1], $ahCursor[$iCURSOR_R], $iMaxRadius + Cos(TimeToRadians("min")) * (($x + 1) * $nCurRadian), $iMaxRadius - Sin(TimeToRadians("min")) * (($x + 1) * $nCurRadian))
			EndIf
			If $x < $iCursorHour Then
				_GDIPlus_GraphicsDrawImage_Int($ahDrawState[1], $ahCursor[$iCURSOR_P], $iMaxRadius + Cos(TimeToRadians("hour")) * (($x + 1) * $nCurRadian), $iMaxRadius - Sin(TimeToRadians("hour")) * (($x + 1) * $nCurRadian))
			EndIf
			_GDIPlus_GraphicsDrawImage_Int($ahDrawState[1], $ahCursor[$iCURSOR_B], $iMaxRadius + Cos(TimeToRadians("sec")) * (($x + 1) * $nCurRadian), $iMaxRadius - Sin(TimeToRadians("sec")) * (($x + 1) * $nCurRadian))
		Next

		_LayeredWindow_EndDraw($hGUI, $ahDrawState)
	Next

	For $i = 0 To $iCURSOR_MAX - 1
		_GDIPlus_BitmapDispose($ahCursor[$i])
	Next
	_GDIPlus_Shutdown()
EndFunc   ;==>_Exit
Func _Update()
	Local $aiSecCursorPosCur[$iCursorSec][2], $aiSecCursorStep[$iCursorSec][2], $iStep = Int(10 * (200 / $iRadius))
	Local $aiMinCursorPosCur[$iCursorMin][2], $aiMinCursorStep[$iCursorMin][2]
	Local $aiHourCursorPosCur[$iCursorHour][2], $aiHourCursorStep[$iCursorHour][2]
	Local $iCurRadiusStep = ($iRadius - $iPrevRadius) / $iStep, $iCurRadius = $iPrevRadius
	Local $hBrush, $sString, $hFormat, $hFamily, $hFont, $tLayout, $aInfo

	_GetBufferPos("sec", $aiSecCursorPosCur, $aiSecCursorPos, $aiSecCursorStep, $iStep)
	_GetBufferPos("min", $aiMinCursorPosCur, $aiMinCursorPos, $aiMinCursorStep, $iStep)
	_GetBufferPos("hour", $aiHourCursorPosCur, $aiHourCursorPos, $aiHourCursorStep, $iStep)

	For $iStepAmount = 1 To $iStep
		$ahDrawState = _LayeredWindow_StartDraw($iMaxRadius * 2 + 17, $iMaxRadius * 2 + 24)
		$iCurRadius += $iCurRadiusStep

		$hBrush = _GDIPlus_BrushCreateSolid(0x01FFFFFF)
		_GDIPlus_GraphicsFillEllipse($ahDrawState[1], $iMaxRadius - $iCurRadius, $iMaxRadius - $iCurRadius, $iCurRadius * 2 + 17, $iCurRadius * 2 + 24, $hBrush)
		_GDIPlus_BrushDispose($hBrush)

		_GDIPlus_GraphicsDrawImage_Int($ahDrawState[1], $ahCursor[$iCURSOR_W], $iMaxRadius, $iMaxRadius)

		$iN = 0
		For $iI = 0 To 2 * $nPI Step $nPI / 30
			If $iN > 59 Then ExitLoop
			_GDIPlus_GraphicsDrawImage_Int($ahDrawState[1], (Mod($iN, 5) = 0) ? ($ahCursor[$iCURSOR_Bl]) : ($ahCursor[$iCURSOR_W]), $iMaxRadius + Cos($iI) * $nCurRadius, $iMaxRadius - Sin($iI) * $nCurRadius)
;~ 			_GDIPlus_GraphicsDrawImage_Int($ahDrawState[1], _Iif(Mod($iN, 5) = 0, $ahCursor[$iCURSOR_Bl], $ahCursor[$iCURSOR_W]), $iMaxRadius + Cos($iI) * $nCurRadius, $iMaxRadius - Sin($iI) * $nCurRadius) ; <= 3.3.8.1
			$iN += 1
		Next

		For $x = 0 To $iCursorSec - 1
			If $x < $iCursorMin Then
				_AddPosAndDraw($aiMinCursorPos[$x][0], $aiMinCursorPos[$x][1], $aiMinCursorStep[$x][0], $aiMinCursorStep[$x][1], $iCURSOR_R)
			EndIf
			If $x < $iCursorHour Then
				_AddPosAndDraw($aiHourCursorPos[$x][0], $aiHourCursorPos[$x][1], $aiHourCursorStep[$x][0], $aiHourCursorStep[$x][1], $iCURSOR_P)
			EndIf
			_AddPosAndDraw($aiSecCursorPos[$x][0], $aiSecCursorPos[$x][1], $aiSecCursorStep[$x][0], $aiSecCursorStep[$x][1], $iCURSOR_B)
		Next

		$hBrush = _GDIPlus_BrushCreateSolid(0x7FFFFFFF)
		Local $iRectWidth = $iCurRadius / 1.5 - $iCurRadius / 12, $iRectHeight = $iCurRadius / 4 - $iCurRadius / 11
		Local $iRectX = $iMaxRadius - $iRectWidth / 2, $iRectY = $iMaxRadius / 3 + $iMaxRadius / 4
		_GDIPlus_GraphicsFillRect($ahDrawState[1], $iRectX, $iRectY, $iRectWidth, $iRectHeight, $hBrush)

		$sString = StringFormat("%02d:%02d:%02d", @HOUR, @MIN, @SEC)
		_GDIPlus_BrushSetSolidColor($hBrush, 0xFF000000)
		$hFormat = _GDIPlus_StringFormatCreate()
		$hFamily = _GDIPlus_FontFamilyCreate("Arial")
		$hFont = _GDIPlus_FontCreate($hFamily, $iCurRadius / 10, 1)
		$tLayout = _GDIPlus_RectFCreate($iRectX, $iRectY, 0, 0)
		$aInfo = _GDIPlus_GraphicsMeasureString($ahDrawState[1], $sString, $hFont, $tLayout, $hFormat)
		DllStructSetData($aInfo[0], "X", ($iRectWidth / 2) - (DllStructGetData($aInfo[0], "Width") / 2) + $iRectX)
		DllStructSetData($aInfo[0], "Y", ($iRectHeight / 2) - (DllStructGetData($aInfo[0], "Height") / 2) + $iRectY)
		_GDIPlus_GraphicsDrawStringEx($ahDrawState[1], $sString, $hFont, $aInfo[0], $hFormat, $hBrush)
		_GDIPlus_FontDispose($hFont)
		_GDIPlus_FontFamilyDispose($hFamily)
		_GDIPlus_StringFormatDispose($hFormat)
		_GDIPlus_BrushDispose($hBrush)

		_LayeredWindow_EndDraw($hGUI, $ahDrawState)
	Next
	_SetBufferPos($aiSecCursorPos, $aiSecCursorPosCur)
	_SetBufferPos($aiMinCursorPos, $aiMinCursorPosCur)
	_SetBufferPos($aiHourCursorPos, $aiHourCursorPosCur)

	$iPrevRadius = $iRadius
EndFunc   ;==>_Update

Func TimeToRadians($sTimeType)
	Switch $sTimeType
		Case "sec"
			Return ($nPI / 2) - (@SEC * ($nPI / 30))
		Case "min"
			Return ($nPI / 2) - (@MIN * ($nPI / 30)) - ((@SEC / 10) * ($nPI / 180))
		Case "hour"
			Return ($nPI / 2) - (@HOUR * ($nPI / 6)) - (@MIN / 12) * ($nPI / 30)
	EndSwitch
EndFunc   ;==>TimeToRadians
Func WM_NCHITTEST($hWnd, $iMsg, $iwParam, $ilParam)
	#forceref $hWnd, $iwParam, $ilParam
	If $iMsg = $WM_NCHITTEST Then
		Return $HTCAPTION
	EndIf
	Return $GUI_RUNDEFMSG
EndFunc   ;==>WM_NCHITTEST
Func _ResetCursorPosBuffers() ; Resets the positions of the cursors in the buffers (Call after changing clock radius and on init)
	For $x = 0 To $iCursorSec - 1
		If $x < $iCursorMin Then
			$aiMinCursorPos[$x][0] = $iMaxRadius + Cos(TimeToRadians("min")) * (($x + 1) * $nCurRadian)
			$aiMinCursorPos[$x][1] = $iMaxRadius - Sin(TimeToRadians("min")) * (($x + 1) * $nCurRadian)
		EndIf
		If $x < $iCursorHour Then
			$aiHourCursorPos[$x][0] = $iMaxRadius + Cos(TimeToRadians("hour")) * (($x + 1) * $nCurRadian)
			$aiHourCursorPos[$x][1] = $iMaxRadius - Sin(TimeToRadians("hour")) * (($x + 1) * $nCurRadian)
		EndIf
		$aiSecCursorPos[$x][0] = $iMaxRadius + Cos(TimeToRadians("sec")) * (($x + 1) * $nCurRadian)
		$aiSecCursorPos[$x][1] = $iMaxRadius - Sin(TimeToRadians("sec")) * (($x + 1) * $nCurRadian)
	Next
EndFunc   ;==>_ResetCursorPosBuffers
Func _AddPosAndDraw(ByRef $nXPos, ByRef $nYPos, ByRef $nXStep, ByRef $nYStep, $iIndex)
	$nXPos += $nXStep
	$nYPos += $nYStep
	_GDIPlus_GraphicsDrawImage_Int($ahDrawState[1], $ahCursor[$iIndex], $nXPos, $nYPos)
EndFunc   ;==>_AddOffsetsAndDraw
Func _SetBufferPos(ByRef $anOld, ByRef $anNew)
	For $iI = 0 To UBound($anOld) - 1
		$anOld[$iI][0] = $anNew[$iI][0]
		$anOld[$iI][1] = $anNew[$iI][1]
	Next
EndFunc   ;==>_SetOffsets
Func _GetBufferPos($sTimeType, ByRef $anPosCur, ByRef $anPosOld, ByRef $anStep, ByRef $iStep)
	For $iI = 0 To UBound($anPosCur) - 1
		$anPosCur[$iI][0] = $iMaxRadius + Cos(TimeToRadians($sTimeType)) * (($iI + 1) * 20)
		$anPosCur[$iI][1] = $iMaxRadius - Sin(TimeToRadians($sTimeType)) * (($iI + 1) * 20)
		$anStep[$iI][0] = ($anPosCur[$iI][0] - $anPosOld[$iI][0]) / $iStep
		$anStep[$iI][1] = ($anPosCur[$iI][1] - $anPosOld[$iI][1]) / $iStep
	Next
EndFunc   ;==>_GetBufferOffsets

Func _LayeredWindow_StartDraw($iW, $iH, $iSmooth = 2)
	Local $hBitmap = DllCall($ghGDIPDll, "uint", "GdipCreateBitmapFromScan0", "int", $iW, "int", $iH, "int", 0, "int", $GDIP_PXF32ARGB, "ptr", 0, "int*", 0)
	$hBitmap = $hBitmap[6]
	Local $hCtxt = _GDIPlus_ImageGetGraphicsContext($hBitmap)
	_GDIPlus_GraphicsSetSmoothingMode($hCtxt, $iSmooth)

	Local $ahState[2] = [$hBitmap, $hCtxt]
	Return $ahState
EndFunc   ;==>_LayeredWindow_StartDraw
Func _LayeredWindow_EndDraw($hGUI, ByRef $ahState, $iOpacity = 255)
	SetBitmap($hGUI, $ahState[0], $iOpacity)
	_GDIPlus_GraphicsDispose($ahState[1])
	_GDIPlus_BitmapDispose($ahState[0])
EndFunc   ;==>_LayeredWindow_EndDraw

; Draw image with integer point precision (some images appear blurry with floating point precision)
Func _GDIPlus_GraphicsDrawImage_Int($hGraphics, $hImage, $nX, $nY)
	Return _GDIPlus_GraphicsDrawImage($hGraphics, $hImage, Int($nX), Int($nY))
EndFunc   ;==>_GDIPlus_GraphicsDrawImage_Int

Func _GDIPlus_BMPFromMemory($bImage, $hHBITMAP = False)
	If Not IsBinary($bImage) Then Return SetError(1, 0, 0)
	Local $aResult
	Local Const $memBitmap = Binary($bImage) ;load image  saved in variable (memory) and convert it to binary
	Local Const $len = BinaryLen($memBitmap) ;get length of image
	Local Const $hData = _MemGlobalAlloc($len, $GMEM_MOVEABLE) ;allocates movable memory  ($GMEM_MOVEABLE = 0x0002)
	Local Const $pData = _MemGlobalLock($hData) ;translate the handle into a pointer
	Local $tMem = DllStructCreate("byte[" & $len & "]", $pData) ;create struct
	DllStructSetData($tMem, 1, $memBitmap) ;fill struct with image data
	_MemGlobalUnlock($hData) ;decrements the lock count  associated with a memory object that was allocated with GMEM_MOVEABLE
	$aResult = DllCall("ole32.dll", "int", "CreateStreamOnHGlobal", "handle", $pData, "int", True, "ptr*", 0) ;Creates a stream object that uses an HGLOBAL memory handle to store the stream contents
	If @error Then Return SetError(2, 0, 0)
	Local Const $hStream = $aResult[3]
	$aResult = DllCall($ghGDIPDll, "uint", "GdipCreateBitmapFromStream", "ptr", $hStream, "int*", 0) ;Creates a Bitmap object based on an IStream COM interface
	If @error Then Return SetError(3, 0, 0)
	Local Const $hBitmap = $aResult[2]
	Local $tVARIANT = DllStructCreate("word vt;word r1;word r2;word r3;ptr data; ptr")
	DllCall("oleaut32.dll", "long", "DispCallFunc", "ptr", $hStream, "dword", 8 + 8 * @AutoItX64, _
			"dword", 4, "dword", 23, "dword", 0, "ptr", 0, "ptr", 0, "ptr", DllStructGetPtr($tVARIANT)) ;release memory from $hStream to avoid memory leak
	$tMem = 0
	$tVARIANT = 0
	If $hHBITMAP Then
		Local Const $hHBmp = _WinAPI_BitmapCreateDIBFromBitmap($hBitmap)
		_GDIPlus_BitmapDispose($hBitmap)
		Return $hHBmp
	EndIf
	Return $hBitmap
EndFunc   ;==>_GDIPlus_BMPFromMemory
Func _WinAPI_BitmapCreateDIBFromBitmap($hBitmap) ;create 32-bit bitmap v5 (alpha channel supported)
	Local $tBIHDR, $aRet, $tData, $pBits, $hResult = 0
	$aRet = DllCall($ghGDIPDll, 'uint', 'GdipGetImageDimension', 'ptr', $hBitmap, 'float*', 0, 'float*', 0)
	If (@error) Or ($aRet[0]) Then Return 0
	$tData = _GDIPlus_BitmapLockBits($hBitmap, 0, 0, $aRet[2], $aRet[3], $GDIP_ILMREAD, $GDIP_PXF32ARGB)
	$pBits = DllStructGetData($tData, 'Scan0')
	If Not $pBits Then Return 0
	$tBIHDR = DllStructCreate('dword bV5Size;long bV5Width;long bV5Height;word bV5Planes;word bV5BitCount;dword bV5Compression;' & _ ;http://msdn.microsoft.com/en-us/library/windows/desktop/dd183381(v=vs.85).aspx
			'dword bV5SizeImage;long bV5XPelsPerMeter;long bV5YPelsPerMeter;dword bV5ClrUsed;dword bV5ClrImportant;' & _
			'dword bV5RedMask;dword bV5GreenMask;dword bV5BlueMask;dword bV5AlphaMask;dword bV5CSType;' & _
			'int bV5Endpoints[3];dword bV5GammaRed;dword bV5GammaGreen;dword bV5GammaBlue;dword bV5Intent;' & _
			'dword bV5ProfileData;dword bV5ProfileSize;dword bV5Reserved')
	DllStructSetData($tBIHDR, 'bV5Size', DllStructGetSize($tBIHDR))
	DllStructSetData($tBIHDR, 'bV5Width', $aRet[2])
	DllStructSetData($tBIHDR, 'bV5Height', $aRet[3])
	DllStructSetData($tBIHDR, 'bV5Planes', 1)
	DllStructSetData($tBIHDR, 'bV5BitCount', 32)
	DllStructSetData($tBIHDR, 'bV5Compression', 0) ; $BI_BITFIELDS = 3, $BI_RGB = 0, $BI_RLE8 = 1, $BI_RLE4 = 2, $RGBA = 0x41424752
	DllStructSetData($tBIHDR, 'bV5SizeImage', $aRet[3] * DllStructGetData($tData, 'Stride'))
	DllStructSetData($tBIHDR, 'bV5AlphaMask', 0xFF000000)
	DllStructSetData($tBIHDR, 'bV5RedMask', 0x00FF0000)
	DllStructSetData($tBIHDR, 'bV5GreenMask', 0x0000FF00)
	DllStructSetData($tBIHDR, 'bV5BlueMask', 0x000000FF)
	DllStructSetData($tBIHDR, 'bV5CSType', 2) ; LCS_WINDOWS_COLOR_SPACE = 2
	DllStructSetData($tBIHDR, 'bV5Intent', 4) ; $LCS_GM_IMA
	$hResult = DllCall('gdi32.dll', 'ptr', 'CreateDIBSection', 'hwnd', 0, 'ptr', DllStructGetPtr($tBIHDR), 'uint', 0, 'ptr*', 0, 'ptr', 0, 'dword', 0)
	If (Not @error) And ($hResult[0]) Then
		DllCall('gdi32.dll', 'dword', 'SetBitmapBits', 'ptr', $hResult[0], 'dword', $aRet[2] * $aRet[3] * 4, 'ptr', DllStructGetData($tData, 'Scan0'))
		$hResult = $hResult[0]
	Else
		$hResult = 0
	EndIf
	_GDIPlus_BitmapUnlockBits($hBitmap, $tData)
	$tData = 0
	$tBIHDR = 0
	Return $hResult
EndFunc   ;==>_WinAPI_BitmapCreateDIBFromBitmap
Func SetBitmap($hGUI, $hImage, $iOpacity = 255)
	Local $hScrDC, $hMemDC, $hBitmap, $hOld, $pSize, $tSize, $pSource, $tSource, $pBlend, $tBlend

	$hScrDC = _WinAPI_GetDC(0)
	$hMemDC = _WinAPI_CreateCompatibleDC($hScrDC)
	$hBitmap = _GDIPlus_BitmapCreateHBITMAPFromBitmap($hImage)
	$hOld = _WinAPI_SelectObject($hMemDC, $hBitmap)
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
EndFunc   ;==>SetBitmap

#Region ### Base64 Strings ###
;Code below was generated by: 'File to Base64 String' Code Generator v1.12 Build 2013-03-25
Func _SetCursorBinary(ByRef $abBinary)
	$abBinary[0] = 'iVBORw0KGgoAAAANSUhEUgAAABEAAAAYCAYAAAAcYhYyAAAACXBIWXMAAA7DAAAOwwHHb6hkAAACfUlEQVR4nJ2V70uTURTHz6MXkqKgtvmjet0bwSSioIg0ndBAalqOfmhuElgsG9Sa6xfUzNB6EdaLQorIIJzlCmOBGRKBYJYv6l9Y9TqK3Obz3Kdzb+eOx/3I1YXvzr1393yec86ze8aqNtaYjx4O3XI21gUBwBTCweEfBhMfHZ09gfir18y119mLS0PTtEW0XNCKhnx4PwlbtzX5x2MTK1rczWHcWkClEWYUA5KQ9VUVCnR87Gms9OABt4hIQ6WKATE1sYB8o9FxzdPW0ktfLQti1oUF5EUQFAti2Rv/A8qBiFFZ4YDZmThs3+EqCpQD4ZxLlZfb4d3bF7Br975lQSwfwDAMKYd9HbyZjEJDU9tfQawQQNd1ae0Iik+MgKu5XYFC8OeXnUIZGUghgLBCNttaeP7sPuxv7fLi8WsE4RiNvCIZiAIkEl/B4bBJ581bGvPVfRUqTZHowl1CrIC6hla4MXAJ9tTvlB6hYPd04PTJQXJIokopA2E1MTIQBbhyORALhiLu2ZmXKoV6PHKdnr5AWqR6iHRMCVGAvqtnxrp8x4axPbjn5z9DdfUmGc3Q7bvBnlPdF3H6A/UT9YugPFNYAbg5eGHkyGHPPRFmf19w9IQ/7JmeisKTx3fg0FG/E/fPUwRJkq76DvuW+FSGdjUCbFQ009vZHsFoPHNzHx/U1tb4qKAa1cGkCDKNi9EiTSHqlGsa4RvOhQe+iEP9kbPDXm+HcC4h2JLByEm8ru/0JE6wEgRVol2DgDJyNiiSpRCRl2qHln1OT1VhryRIkurCc+4OgUyaS4trbsk/RRBdQbLTAauzdS0umSU9FWHOv0HefpIFVvdEK9TZfgMB+Z2S78EXcQAAAABJRU5ErkJggg=='
	$abBinary[1] = 'iVBORw0KGgoAAAANSUhEUgAAABEAAAAYCAYAAAAcYhYyAAAACXBIWXMAAA7DAAAOwwHHb6hkAAAC8ElEQVR4nJWVX2hSURzHz71ecTUSRtCzKxpBjvRhZXNkDpQ5H7Y5MVY9tcIhDnwZrdqetsD2tAcflPKxBRFTqC3wwbC5dTd0DHyThEGsCKQROp1O7+137s4Z7o+bHfhxPL/D73O/v9/vnCMniuLvdDozNzTkGFtfXxcRQuASBfQfgwNj2tqu9CSTSS4QCIwXi8UqwzB74BcwrVEIGh4evhYMBmVOp1OxsLDwDFxFsDLAqo2AJMji4iLa2Ni4qtFoZFardUan043zPM/AVqkREEd/aLVa1NnZeXl5eZkZHLS/Asg42ToTxNUucrkc0uv1rRgEId75+Q9Y0ZmgQ5BUKiXNoEi1srJivKW77TXc0Z+piDvqwCOfz6Ouri5VPB43WiwW7/b29qmKToRQRQaDQRWLxYy9vb1eWNZVdCKEjkKhgLq7u1XRaFQC1VN0KiSRSEiz2WxWRSIR4+zsrBfinq6uruLgElj1AALUY4COjg7EsqxkuP0AUHk8nruhUEgJ2xgiQJx0RepCcDCR/oO4cCArl8ubYS4TJRUMO4C0tLQgpVKJNjc3kXNkBInC/h2cnn75PZlMzAiCUIGxC3AZyUC2H8owHP2qw+FAfr9/h+fXIgG/X+9yuS75fD40MfHiut1ur4bDYfz1IrE9Ug+cjihBbDYbzjkfCn/8vPT1y2ud7qbGZDKjeHwJb++AsrFsNjsB7c7BOo8bR1KS5HJvgm//jI56mubevQ8/uH8vgGWazZa1gYH+Zp7/htW0ut3uc9NTUwJRsEusQt8d7snjhzdgvgB2EQwXTZycfD7V02PSQrqfMpnMI+xj9qsvo52hKmiLBSKtQKpdhfNRbm9vN8LJTW79/JXq6+vnycFicTGPdpIjBcLt+ku+hKGVcrnMqtVqjUKhUMKz2USCq0TJYQjOiz6HNX4hnU6zNbLPE8guqYtw7O4QkEh+i+TsCDX5lwikQiFH00G1wbVrfMloelQhOuHf4NQLSMD0njD1XrZ/xpubTeglEfsAAAAASUVORK5CYII='
	$abBinary[2] = 'iVBORw0KGgoAAAANSUhEUgAAABEAAAAYCAYAAAAcYhYyAAAACXBIWXMAAA7DAAAOwwHHb6hkAAACAElEQVR4nJ2VSy9DQRTHzzBBCBskEnvxCWwRuiCxqKALhFaIiNdGPGInIrESFh6N1DPiEV1IWIiILV/AY21lJYS2bu845/aMjLbqMsm5M2fa85v/mblzrgSl1PnF1YKnvmYMABQZNhv+0CQ9PHXVo6dn57KxwTOBblwI8YG9TTTXkGhVFeReXw8eh09ym71Nkzj1jhZDWNwNyIHk3NxoUO/hUTi7tcVLigTx3YCkHhigwP7BsfC1NU/wT7+CpOkYID+CwC1IJk/8B5QC0SAlBAilXIHSQnRzC8oIcQv6FZIGNA6JNzuKFncNMUE4nGWIjWqcK5IRItKfaAFajJVYBEuBUOBTRSWUPNw5/sLi8uXoyMA8B0TQsjkD6gU1mQxYC4bCpfe3XpLPKdTCyMAcr/7ORheU9oPSUdIErIe2Dnv6AkHo9XtN+OLSytjwUP80Dl/QXtHeGOqUDKkBu3sH2+2BrlWSGdrc2cc5n6HGA0P9U6wgwmbpuiMxqzzsC9sBinnTlL+7cwa6OnzJ28X7oFjBV+GS7MRYosW5xvD8ylHBI/0ptLEd9CeCsxj2rUkOouN65pUIamVRgBBlOC5CQB4Hx1nJdwjlpcuhMW/zqlp2PkMivC92yt1hkOKx06NvG/lHGWJpSHI6YAabPl0ynZ6hMOVrkLkUJMD6noifKtsnB6FEr1aUYxQAAAAASUVORK5CYII='
	$abBinary[3] = 'iVBORw0KGgoAAAANSUhEUgAAABEAAAAYCAYAAAAcYhYyAAAACXBIWXMAAA7DAAAOwwHHb6hkAAAB8UlEQVR4nJ2VO0sDQRDHZ82ComgjgmDt42MoJIWCRUQ9ENQkooj4SCM+sBMRrHyAqIEYFQJRSQpBCwX9GGJvpY0omsTLnTOXOVkvr4sLk90Zdn73n8ntnjQBzLu7h22ft3sRcE2Gw4AqhqQfr7c7fH1zK/t6fcvo5oQQ3zgbRHMNEbjXFGI2mbqqHfD3r2DoCy2LsJwbkLQXDJq8uEx5hgb9pEigZdyApOowKJQ4TwpteGCZwxVB0hlgUBDOk+AWVAD5D6gopFpQSUg1oLIQt6CKkCKgJci/2Rm0nGuICtIANhhioBrriJSFYFKxcANalpXoBCuAUGLL0yO8tnda/s7O/n14YWaLE9JoHq6AZkFDOgGRo2jqpaPLT/K5hJ4wwCY//Yvtm/tB5ZhSBUSjJxdTofHIJIBfhe/uHSzOz02v4fId7QPtk6HWlSFtQDyeOJsY0Q5JZix2lsCYpqjxzQOssoI0m27fOxJbV4dzI4xozdw0MxgYXQ8AaI52Ce6DyQp+Ly7JTpYl6lxrFne2oYJn2hQ7Po1AcIySaxj2Z0hOor/rjZ9EUL0mn9CK1oSAOk7OsZK/EKrLvg6VuMFPtWXXMyTNfTEKzg6DTF5bM/qGUn+GIboNcZYDarLq0yGzy1MUFnwNyr/2ebB9TkSpm+0HrLkx734NdV8AAAAASUVORK5CYII='
	$abBinary[4] = 'iVBORw0KGgoAAAANSUhEUgAAABEAAAAYCAYAAAAcYhYyAAAACXBIWXMAAA7DAAAOwwHHb6hkAAAB40lEQVR4nJ2Vzy9DQRDHZ3UTDeHiIvHPVOiBxOEJ3kGoVoiI4iJ+xE1E4iQkgoaqRqRIe5BwaIR/xh8ghLbee2umZmW1Va82me7OxHz2O9vOkKBA5e8fd8K9oSUA9NBwedDAkvQR7gkt3t7lZX9feAVdVwjxgbtHNN8QJRQIJeayuZvmQWtgFUPvaCWEuX5AUh8YNHV1nQsMD1mkSKAV/YCk6TAolrnMCntkcIXDf4JkZYBBUQSBX1AV5D+gmpBGQb9CGgHVhfgF/QmpAVqGr192Ec31DTFBeNxkiIdqyi1SF4JJtcKtaCVW4hCsCkKJdKteO7v7D4sLs9ucUEALcAW0C1qyEnCUOMnhbhGIS+iGBdji29/ZqEHpPagcJU3AcTJ1NTkdScAUWCZ8d+9gaT4+s47HF7RXtDeGlkeG1IDzi0x6NGYfksxkKp3BmG2oCUMc1lhBgc3Rc0dirwZxbxsFu4MfTUUnxjYgAnblc/E7KFbwPbgkOyWW6HCtJU9AFyp4oj9Knp4lojBOyU0M+7EkJ9HX9cw3EdRpogQBnXhuR0CQk11W8hNCdelxaMQ9vlXLbmFIgd/Fq+odBik+l3f0PaP+IkMcDaksB8xk06cm0+UZCqv+G9QfBV9g3Sfit8n2CSm6NFYxWCiCAAAAAElFTkSuQmCC'

	For $i = 0 To 4
		$abBinary[$i] = Binary(_Base64Decode($abBinary[$i]))
	Next
	Return 1
EndFunc   ;==>_SetCursorBinary
Func _Base64Decode($sB64String)
	Local $struct = DllStructCreate("int")
	Local $a_Call = DllCall("Crypt32.dll", "int", "CryptStringToBinary", "str", $sB64String, "int", 0, "int", 1, "ptr", 0, "ptr", DllStructGetPtr($struct, 1), "ptr", 0, "ptr", 0)
	If @error Or Not $a_Call[0] Then Return SetError(1, 0, "")
	Local $a = DllStructCreate("byte[" & DllStructGetData($struct, 1) & "]")
	$a_Call = DllCall("Crypt32.dll", "int", "CryptStringToBinary", "str", $sB64String, "int", 0, "int", 1, "ptr", DllStructGetPtr($a), "ptr", DllStructGetPtr($struct, 1), "ptr", 0, "ptr", 0)
	If @error Or Not $a_Call[0] Then Return SetError(2, 0, "")
	Return DllStructGetData($a, 1)
EndFunc   ;==>_Base64Decode
#EndRegion ### Base64 Strings ###
