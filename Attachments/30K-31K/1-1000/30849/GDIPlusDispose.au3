#include-once

#include "GDIPlusConstants.au3"
#include "WinAPI.au3"
#include "StructureConstants.au3"

; #INDEX# =======================================================================================================================
; Title .........: GDIPlus
; AutoIt Version : 3.2.3++
; Language ......: English
; Description ...: Functions that assist with Microsoft Windows GDI+ management.
;                  It enables applications to use graphics and formatted text on both the video display and the printer.
;                  Applications based on the Microsoft Win32 API do not access graphics hardware directly.
;                  Instead, GDI+ interacts with device drivers on behalf of applications.
;                  GDI+ can be used in all Windows-based applications.
;                  GDI+ is new technology that is included in Windows XP and  the Windows Server 2003.
;                  It is required as a redistributable for applications that run on the Windows NT 4.0 SP6,
;                  Windows 2000, Windows 98, and Windows Me operating systems.
; Author ........: Paul Campbell (PaulIA)
; Dll ...........: GDIPlus.dll
; ===============================================================================================================================

; #VARIABLES# ===================================================================================================================
Global $ghGDIPBrush = 0
Global $ghGDIPDll = 0
Global $ghGDIPPen = 0
Global $giGDIPRef = 0
Global $giGDIPToken = 0
; ===============================================================================================================================

; #VARIABLES FOR ObjectDispose# =================================================================================================
Global $ghGDIDis_sArrowCap, $ghGDIDis_sBitmap, $ghGDIDis_sBitmapObj, $ghGDIDis_sBrush, $ghGDIDis_sCap, $ghGDIDis_sFont
Global $ghGDIDis_sFontFamily, $ghGDIDis_sGraphics, $ghGDIDis_sImage, $ghGDIDis_sMatrix, $ghGDIDis_sPen, $ghGDIDis_sString
Global $ghGDIPDis_ConsoleOut, $ghGDIPDis_ManualMode = True
; ===============================================================================================================================

; #CURRENT# =====================================================================================================================
;_GDIPlus_ArrowCapCreate
;_GDIPlus_ArrowCapDispose
;_GDIPlus_ArrowCapGetFillState
;_GDIPlus_ArrowCapGetHeight
;_GDIPlus_ArrowCapGetMiddleInset
;_GDIPlus_ArrowCapGetWidth
;_GDIPlus_ArrowCapSetFillState
;_GDIPlus_ArrowCapSetHeight
;_GDIPlus_ArrowCapSetMiddleInset
;_GDIPlus_ArrowCapSetWidth
;_GDIPlus_BitmapCloneArea
;_GDIPlus_BitmapCreateFromFile
;_GDIPlus_BitmapCreateFromGraphics
;_GDIPlus_BitmapCreateFromHBITMAP
;_GDIPlus_BitmapCreateHBITMAPFromBitmap
;_GDIPlus_BitmapDispose
;_GDIPlus_BitmapLockBits
;_GDIPlus_BitmapUnlockBits
;_GDIPlus_BrushClone
;_GDIPlus_BrushCreateSolid
;_GDIPlus_BrushDispose
;_GDIPlus_BrushGetSolidColor
;_GDIPlus_BrushGetType
;_GDIPlus_BrushSetSolidColor
;_GDIPlus_CustomLineCapDispose
;_GDIPlus_Decoders
;_GDIPlus_DecodersGetCount
;_GDIPlus_DecodersGetSize
;_GDIPlus_DrawImagePoints
;_GDIPlus_Encoders
;_GDIPlus_EncodersGetCLSID
;_GDIPlus_EncodersGetCount
;_GDIPlus_EncodersGetParamList
;_GDIPlus_EncodersGetParamListSize
;_GDIPlus_EncodersGetSize
;_GDIPlus_FontCreate
;_GDIPlus_FontDispose
;_GDIPlus_FontFamilyCreate
;_GDIPlus_FontFamilyDispose
;_GDIPlus_GraphicsClear
;_GDIPlus_GraphicsCreateFromHDC
;_GDIPlus_GraphicsCreateFromHWND
;_GDIPlus_GraphicsDispose
;_GDIPlus_GraphicsDrawArc
;_GDIPlus_GraphicsDrawBezier
;_GDIPlus_GraphicsDrawClosedCurve
;_GDIPlus_GraphicsDrawCurve
;_GDIPlus_GraphicsDrawEllipse
;_GDIPlus_GraphicsDrawImage
;_GDIPlus_GraphicsDrawImageRect
;_GDIPlus_GraphicsDrawImageRectRect
;_GDIPlus_GraphicsDrawLine
;_GDIPlus_GraphicsDrawPie
;_GDIPlus_GraphicsDrawPolygon
;_GDIPlus_GraphicsDrawRect
;_GDIPlus_GraphicsDrawString
;_GDIPlus_GraphicsDrawStringEx
;_GDIPlus_GraphicsFillClosedCurve
;_GDIPlus_GraphicsFillEllipse
;_GDIPlus_GraphicsFillPie
;_GDIPlus_GraphicsFillPolygon
;_GDIPlus_GraphicsFillRect
;_GDIPlus_GraphicsGetDC
;_GDIPlus_GraphicsGetSmoothingMode
;_GDIPlus_GraphicsMeasureString
;_GDIPlus_GraphicsReleaseDC
;_GDIPlus_GraphicsSetTransform
;_GDIPlus_GraphicsSetSmoothingMode
;_GDIPlus_ImageDispose
;_GDIPlus_ImageGetFlags
;_GDIPlus_ImageGetGraphicsContext
;_GDIPlus_ImageGetHeight
;_GDIPlus_ImageGetHorizontalResolution
;_GDIPlus_ImageGetPixelFormat
;_GDIPlus_ImageGetRawFormat
;_GDIPlus_ImageGetType
;_GDIPlus_ImageGetVerticalResolution
;_GDIPlus_ImageGetWidth
;_GDIPlus_ImageLoadFromFile
;_GDIPlus_ImageSaveToFile
;_GDIPlus_ImageSaveToFileEx
;_GDIPlus_MatrixCreate
;_GDIPlus_MatrixDispose
;_GDIPlus_MatrixRotate
;_GDIPlus_MatrixScale
;_GDIPlus_MatrixTranslate
;_GDIPlus_ParamAdd
;_GDIPlus_ParamInit
;_GDIPlus_PenCreate
;_GDIPlus_PenDispose
;_GDIPlus_PenGetAlignment
;_GDIPlus_PenGetColor
;_GDIPlus_PenGetCustomEndCap
;_GDIPlus_PenGetDashCap
;_GDIPlus_PenGetDashStyle
;_GDIPlus_PenGetEndCap
;_GDIPlus_PenGetWidth
;_GDIPlus_PenSetAlignment
;_GDIPlus_PenSetColor
;_GDIPlus_PenSetDashCap
;_GDIPlus_PenSetCustomEndCap
;_GDIPlus_PenSetDashStyle
;_GDIPlus_PenSetEndCap
;_GDIPlus_PenSetWidth
;_GDIPlus_RectFCreate
;_GDIPlus_Shutdown
;_GDIPlus_Startup
;_GDIPlus_StringFormatCreate
;_GDIPlus_StringFormatDispose
;_GDIPlus_StringFormatSetAlign
; ===============================================================================================================================

; #INTERNAL_USE_ONLY# ===========================================================================================================
;__GDIPlus_BrushDefCreate
;__GDIPlus_BrushDefDispose
;__GDIPlus_ExtractFileExt
;__GDIPlus_LastDelimiter
;__GDIPlus_PenDefCreate
;__GDIPlus_PenDefDispose
; ===============================================================================================================================

; #INTERNAL_USE_ONLY ObjectDispose# =============================================================================================
;__GDIPlus_ObjectDispose_ListAdd
;__GDIPlus_ObjectDispose_ListRemove
;__GDIPlus_ObjectDispose_All
;__GDIPlus_ObjectDispose_Type
;__GDIPlus_ObjectDispose_DisposeType
; ===============================================================================================================================

; #FUNCTION# ====================================================================================================================
; Name...........: _GDIPlus_ArrowCapCreate
; Description ...: Creates an adjustable arrow line cap with the specified height and width
; Syntax.........: _GDIPlus_ArrowCapCreate($nHeight, $nWidth[, $bFilled = True])
; Parameters ....: $fHeight - Specifies the length, in units, of the arrow from its base to its point
;                  $fWidth  - Specifies the distance, in units, between the corners of the base of the arrow
;                  $bFilled - Fill flag:
;                  |True  - Arrow will be filled
;                  |False - Arrow will not be filled
; Return values .: Success      - Returns a handle to a new ArrowCap object
;                  Failure      - 0
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost
; Remarks .......: After you are done with the object, call _GDIPlus_ArrowCapDispose to release the object resources
; Related .......: _GDIPlus_ArrowCapDispose
; Link ..........: @@MsdnLink@@ GdipCreateAdjustableArrowCap
; Example .......: Yes
; ===============================================================================================================================
Func _GDIPlus_ArrowCapCreate($fHeight, $fWidth, $bFilled = True)
	Local $aResult = DllCall($ghGDIPDll, "int", "GdipCreateAdjustableArrowCap", "float", $fHeight, "float", $fWidth, "bool", $bFilled, "ptr*", 0)
	If @error Then Return SetError(@error, @extended, 0)
	__GDIPlus_ObjectDispose_ListAdd($aResult[4], "ArrowCap")
	Return SetExtended($aResult[0], $aResult[4])
EndFunc   ;==>_GDIPlus_ArrowCapCreate

; #FUNCTION# ====================================================================================================================
; Name...........: _GDIPlus_ArrowCapDispose
; Description ...: Release an adjustable arrow line cap object
; Syntax.........: _GDIPlus_ArrowCapDispose($hCap)
; Parameters ....: $hCap        - Handle to a adjustable arrow line cap object
; Return values .: Success      - True
;                  Failure      - False
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost
; Remarks .......:
; Related .......: _GDIPlus_ArrowCapCreate
; Link ..........: @@MsdnLink@@ GdipDeleteCustomLineCap
; Example .......: Yes
; ===============================================================================================================================
Func _GDIPlus_ArrowCapDispose($hCap)
	Local $aResult = DllCall($ghGDIPDll, "int", "GdipDeleteCustomLineCap", "handle", $hCap)
	If @error Then Return SetError(@error, @extended, False)
	__GDIPlus_ObjectDispose_ListRemove($hCap, "ArrowCap")
	Return $aResult[0] = 0
EndFunc   ;==>_GDIPlus_ArrowCapDispose

; #FUNCTION# ====================================================================================================================
; Name...........: _GDIPlus_ArrowCapGetFillState
; Description ...: Determines whether the arrow cap is filled
; Syntax.........: _GDIPlus_ArrowCapGetFillState($hArrowCap)
; Parameters ....: $hArrowCap   - Handle to a ArrowCap object
; Return values .: True         - Arrow cap is filled
;                  False        - Arrow cap is not filled or if error then @error is set
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost
; Remarks .......:
; Related .......: _GDIPlus_ArrowCapSetFillState
; Link ..........: @@MsdnLink@@ GdipGetAdjustableArrowCapFillState
; Example .......: Yes
; ===============================================================================================================================
Func _GDIPlus_ArrowCapGetFillState($hArrowCap)
	Local $aResult = DllCall($ghGDIPDll, "int", "GdipGetAdjustableArrowCapFillState", "handle", $hArrowCap, "bool*", 0)
	If @error Then Return SetError(@error, @extended, False)
	Return $aResult[0] = 0
EndFunc   ;==>_GDIPlus_ArrowCapGetFillState

; #FUNCTION# ====================================================================================================================
; Name...........: _GDIPlus_ArrowCapGetHeight
; Description ...: Gets the height of the arrow cap
; Syntax.........: _GDIPlus_ArrowCapGetHeight($hArrowCap)
; Parameters ....: $hArrowCap   - Handle to a ArrowCap object
; Return values .: Success      - Returns the height of the arrow cap
;                  Failure      - 0
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost
; Remarks .......: The height is the distance from the base of the arrow to its vertex
; Related .......: _GDIPlus_ArrowCapSetHeight
; Link ..........: @@MsdnLink@@ GdipGetAdjustableArrowCapHeight
; Example .......: Yes
; ===============================================================================================================================
Func _GDIPlus_ArrowCapGetHeight($hArrowCap)
	Local $aResult = DllCall($ghGDIPDll, "int", "GdipGetAdjustableArrowCapHeight", "handle", $hArrowCap, "float*", 0)
	If @error Then Return SetError(@error, @extended, 0)
	Return SetExtended($aResult[0], $aResult[2])
EndFunc   ;==>_GDIPlus_ArrowCapGetHeight

; #FUNCTION# ====================================================================================================================
; Name...........: _GDIPlus_ArrowCapGetMiddleInset
; Description ...: Gets the value of the inset
; Syntax.........: _GDIPlus_ArrowCapGetMiddleInset($hArrowCap)
; Parameters ....: $hArrowCap   - Handle to a ArrowCap object
; Return values .: Success      - Inset value
;                  Failure      - 0
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost
; Remarks .......: The middle inset is the number of units that the midpoint of the base shifts towards the vertex.  A middle
;                  inset of zero results in no shift (the base is a straight line, giving the arrow a triangular shape).  A
;                  positive (greater than zero) middle inset results in a shift the specified number of units toward the vertex
;                  (the base is an arrow shape that points toward the vertex, giving the arrow cap a V-shape).  A negative (less
;                  than zero) middle inset results in a shift the specified number of units away from the vertex (the base
;                  becomes an arrow shape that points away from the vertex, giving the arrow either a diamond shape (if the
;                  absolute value of the middle inset is equal to the height) or distorted diamond shape.  If the middle inset is
;                  equal to or greater than the height of the arrow cap, the cap does not appear at all.  The value of the middle
;                  inset affects the arrow cap only if the arrow cap is filled.
; Related .......: _GDIPlus_ArrowCapSetMiddleInset
; Link ..........: @@MsdnLink@@ GdipGetAdjustableArrowCapMiddleInset
; Example .......: Yes
; ===============================================================================================================================
Func _GDIPlus_ArrowCapGetMiddleInset($hArrowCap)
	Local $aResult = DllCall($ghGDIPDll, "int", "GdipGetAdjustableArrowCapMiddleInset", "handle", $hArrowCap, "float*", 0)
	If @error Then Return SetError(@error, @extended, 0)
	Return SetExtended($aResult[0], $aResult[2])
EndFunc   ;==>_GDIPlus_ArrowCapGetMiddleInset

; #FUNCTION# ====================================================================================================================
; Name...........: _GDIPlus_ArrowCapGetWidth
; Description ...: Gets the width of the arrow cap
; Syntax.........: _GDIPlus_ArrowCapGetWidth($hArrowCap)
; Parameters ....: $hArrowCap   - Handle to a ArrowCap object
; Return values .: Success      - Returns the width of the arrow cap
;                  Failure      - 0
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost
; Remarks .......: The width is the distance between the endpoints of the base of the arrow
; Related .......: _GDIPlus_ArrowCapSetWidth
; Link ..........: @@MsdnLink@@ GdipGetAdjustableArrowCapWidth
; Example .......: Yes
; ===============================================================================================================================
Func _GDIPlus_ArrowCapGetWidth($hArrowCap)
	Local $aResult = DllCall($ghGDIPDll, "int", "GdipGetAdjustableArrowCapWidth", "handle", $hArrowCap, "float*", 0)
	If @error Then Return SetError(@error, @extended, 0)
	Return SetExtended($aResult[0], $aResult[2])
EndFunc   ;==>_GDIPlus_ArrowCapGetWidth

; #FUNCTION# ====================================================================================================================
; Name...........: _GDIPlus_ArrowCapSetFillState
; Description ...: Sets whether the arrow cap is filled
; Syntax.........: _GDIPlus_ArrowCapSetFillState($hArrowCap, $bFilled = True)
; Parameters ....: $hArrowCap   - Handle to a ArrowCap object
;                  $bFilled     - Fill state:
;                  |True  - Arrow cap is filled
;                  |False - Arrow cap is not filled
; Return values .: Success      - True
;                  Failure      - False
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost
; Remarks .......:
; Related .......: _GDIPlus_ArrowCapGetFillState
; Link ..........: @@MsdnLink@@ GdipSetAdjustableArrowCapFillState
; Example .......: Yes
; ===============================================================================================================================
Func _GDIPlus_ArrowCapSetFillState($hArrowCap, $bFilled = True)
	Local $aResult = DllCall($ghGDIPDll, "int", "GdipSetAdjustableArrowCapFillState", "handle", $hArrowCap, "bool", $bFilled)
	If @error Then Return SetError(@error, @extended, False)
	Return $aResult[0] = 0
EndFunc   ;==>_GDIPlus_ArrowCapSetFillState

; #FUNCTION# ====================================================================================================================
; Name...........: _GDIPlus_ArrowCapSetHeight
; Description ...: Sets the height of the arrow cap
; Syntax.........: _GDIPlus_ArrowCapSetHeight($hArrowCap, $fHeight)
; Parameters ....: $hArrowCap   - Handle to a ArrowCap object
;                  $fHeight     - Specifies the length, in units, of the arrow from its base to its point
; Return values .: Success      - True
;                  Failure      - False
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost
; Remarks .......:
; Related .......: _GDIPlus_ArrowCapGetHeight
; Link ..........: @@MsdnLink@@ GdipSetAdjustableArrowCapHeight
; Example .......: Yes
; ===============================================================================================================================
Func _GDIPlus_ArrowCapSetHeight($hArrowCap, $fHeight)
	Local $aResult = DllCall($ghGDIPDll, "int", "GdipSetAdjustableArrowCapHeight", "handle", $hArrowCap, "float", $fHeight)
	If @error Then Return SetError(@error, @extended, False)
	Return $aResult[0] = 0
EndFunc   ;==>_GDIPlus_ArrowCapSetHeight

; #FUNCTION# ====================================================================================================================
; Name...........: _GDIPlus_ArrowCapSetMiddleInset
; Description ...: Gets the value of the inset
; Syntax.........: _GDIPlus_ArrowCapSetMiddleInset($hArrowCap, $fInset)
; Parameters ....: $hArrowCap   - Handle to a ArrowCap object
;                  $fInset      - Inset value
; Return values .: Success      - True
;                  Failure      - False
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost
; Remarks .......: The middle inset is the number of units that the midpoint of the base shifts towards the vertex.  A middle
;                  inset of zero results in no shift (the base is a straight line, giving the arrow a triangular shape).  A
;                  positive (greater than zero) middle inset results in a shift the specified number of units toward the vertex
;                  (the base is an arrow shape that points toward the vertex, giving the arrow cap a V-shape).  A negative (less
;                  than zero) middle inset results in a shift the specified number of units away from the vertex (the base
;                  becomes an arrow shape that points away from the vertex, giving the arrow either a diamond shape (if the
;                  absolute value of the middle inset is equal to the height) or distorted diamond shape.  If the middle inset is
;                  equal to or greater than the height of the arrow cap, the cap does not appear at all.  The value of the middle
;                  inset affects the arrow cap only if the arrow cap is filled.
; Related .......: _GDIPlus_ArrowCapGetMiddleInset
; Link ..........: @@MsdnLink@@ GdipSetAdjustableArrowCapMiddleInset
; Example .......: Yes
; ===============================================================================================================================
Func _GDIPlus_ArrowCapSetMiddleInset($hArrowCap, $fInset)
	Local $aResult = DllCall($ghGDIPDll, "int", "GdipSetAdjustableArrowCapMiddleInset", "handle", $hArrowCap, "float", $fInset)
	If @error Then Return SetError(@error, @extended, False)
	Return $aResult[0] = 0
EndFunc   ;==>_GDIPlus_ArrowCapSetMiddleInset

; #FUNCTION# ====================================================================================================================
; Name...........: _GDIPlus_ArrowCapSetWidth
; Description ...: Sets the width of the arrow cap
; Syntax.........: _GDIPlus_ArrowCapSetWidth($hArrowCap, $fWidth)
; Parameters ....: $hArrowCap   - Handle to a ArrowCap object
;                  $fWidth      - Specifies the width, in units, of the arrow between the endpoints of the base of the arrow
; Return values .: Success      - True
;                  Failure      - False
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost
; Remarks .......:
; Related .......: _GDIPlus_ArrowCapGetWidth
; Link ..........: @@MsdnLink@@ GdipSetAdjustableArrowCapWidth
; Example .......: Yes
; ===============================================================================================================================
Func _GDIPlus_ArrowCapSetWidth($hArrowCap, $fWidth)
	Local $aResult = DllCall($ghGDIPDll, "int", "GdipSetAdjustableArrowCapWidth", "handle", $hArrowCap, "float", $fWidth)
	If @error Then Return SetError(@error, @extended, False)
	Return $aResult[0] = 0
EndFunc   ;==>_GDIPlus_ArrowCapSetWidth

; #FUNCTION# ====================================================================================================================
; Name...........: _GDIPlus_BitmapCloneArea
; Description ...: Create a clone of a Bitmap object from the coordinates and format specified
; Syntax.........: _GDIPlus_BitmapCloneArea($hBmp, $iLeft, $iTop, $iWidth, $iHeight[, $iFormat = 0x00021808])
; Parameters ....: $hBmp        - Handle to a Bitmap object
;                  $iLeft       - X coordinate of upper left corner of the rectangle to copy
;                  $iTop        - Y coordinate of upper left corner of the rectangle to copy
;                  $iWidth      - The width of the rectangle that specifies the portion of this bitmap to copy
;                  $iHeight     - The height of the rectangle that specifies the portion of this bitmap to copy
;                  $iFormat     - Pixel format for the new bitmap:
;                  |$GDIP_PXF01INDEXED   = 1 bit per pixel, indexed
;                  |$GDIP_PXF04INDEXED   = 4 bits per pixel, indexed
;                  |$GDIP_PXF08INDEXED   = 8 bits per pixel, indexed
;                  |$GDIP_PXF16GRAYSCALE = 16 bits per pixel, grayscale
;                  |$GDIP_PXF16RGB555    = 16 bits per pixel; 5 bits for each RGB component
;                  |$GDIP_PXF16RGB565    = 16 bits per pixel; 5 bits for red, 6 bits for green and 5 bits blue
;                  |$GDIP_PXF16ARGB1555  = 16 bits per pixel; 1 bit for alpha and 5 bits for each RGB component
;                  |$GDIP_PXF24RGB       = 24 bits per pixel; 8 bits for each RGB component
;                  |$GDIP_PXF32RGB       = 32 bits per pixel; 8 bits for each RGB component. No alpha component.
;                  |$GDIP_PXF32ARGB      = 32 bits per pixel; 8 bits for each RGB and alpha component
;                  |$GDIP_PXF32PARGB     = 32 bits per pixel; 8 bits for each RGB and alpha component, pre-mulitiplied
;                  |$GDIP_PXF48RGB       = 48 bits per pixel; 16 bits for each RGB component
;                  |$GDIP_PXF64ARGB      = 64 bits per pixel; 16 bits for each RGB and alpha component
;                  |$GDIP_PXF64PARGB     = 64 bits per pixel; 16 bits for each RGB and alpha component, pre-multiplied
; Return values .: Success      - Returns a handle to a new Bitmap object
;                  Failure      - 0
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost
; Remarks .......: When you are done with the Bitmap object, call _WinAPI_DeleteObject to release the resources
; Related .......: _WinAPI_DeleteObject, _GDIPlus_ImageGetPixelFormat
; Link ..........: @@MsdnLink@@ GdipCloneBitmapAreaI
; Example .......: Yes
; ===============================================================================================================================
Func _GDIPlus_BitmapCloneArea($hBmp, $iLeft, $iTop, $iWidth, $iHeight, $iFormat = 0x00021808)
	Local $aResult = DllCall($ghGDIPDll, "int", "GdipCloneBitmapAreaI", "int", $iLeft, "int", $iTop, "int", $iWidth, "int", $iHeight, _
			"int", $iFormat, "handle", $hBmp, "ptr*", 0)
	If @error Then Return SetError(@error, @extended, 0)
	__GDIPlus_ObjectDispose_ListAdd($aResult[7], "BitmapObj")
	Return SetExtended($aResult[0], $aResult[7])
EndFunc   ;==>_GDIPlus_BitmapCloneArea

; #FUNCTION# ====================================================================================================================
; Name...........: _GDIPlus_BitmapCreateFromFile
; Description ...: Create a Bitmap object from file
; Syntax.........: _GDIPlus_BitmapCreateFromFile($sFileName)
; Parameters ....: $sFileName   - Path to a bitmap file
; Return values .: Success      - Handle to a Bitmap object
;                  Failure      - 0
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost
; Remarks .......: When you are done with the Bitmap object, call _GDIPlus_BitmapDispose to release the resources
; Related .......: _WinAPI_DeleteObject
; Link ..........: @@MsdnLink@@ GdipCreateBitmapFromFile
; Example .......: Yes
; ===============================================================================================================================
Func _GDIPlus_BitmapCreateFromFile($sFileName)
	Local $aResult = DllCall($ghGDIPDll, "int", "GdipCreateBitmapFromFile", "wstr", $sFileName, "ptr*", 0)
	If @error Then Return SetError(@error, @extended, 0)
	__GDIPlus_ObjectDispose_ListAdd($aResult[2], "Bitmap")
	Return SetExtended($aResult[0], $aResult[2])
EndFunc   ;==>_GDIPlus_BitmapCreateFromFile

; #FUNCTION# ====================================================================================================================
; Name...........: _GDIPlus_BitmapCreateFromGraphics
; Description ...: Creates a Bitmap object based on a Graphics object, a width, and a height
; Syntax.........: _GDIPlus_BitmapCreateFromGraphics($iWidth, $iHeight, $hGraphics)
; Parameters ....: $iWidth      - Specifies the width, in pixels, of the bitmap
;                  $iHeight     - Specifies the height, in pixels, of the bitmap
;                  $hGraphics   - Handle to a Graphics object
; Return values .: Success      - Handle to a Bitmap object
;                  Failure      - 0
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost
; Remarks .......: When you are done with the Bitmap object, call _GDIPlus_BitmapDispose to release the resources
; Related .......: _WinAPI_DeleteObject
; Link ..........: @@MsdnLink@@ GdipCreateBitmapFromGraphics
; Example .......:
; ===============================================================================================================================
Func _GDIPlus_BitmapCreateFromGraphics($iWidth, $iHeight, $hGraphics)
	Local $aResult = DllCall($ghGDIPDll, "int", "GdipCreateBitmapFromGraphics", "int", $iWidth, "int", $iHeight, "handle", $hGraphics, _
			"ptr*", 0)
	If @error Then Return SetError(@error, @extended, 0)
	__GDIPlus_ObjectDispose_ListAdd($aResult[4], "Bitmap")
	Return SetExtended($aResult[0], $aResult[4])
EndFunc   ;==>_GDIPlus_BitmapCreateFromGraphics

; #FUNCTION# ====================================================================================================================
; Name...........: _GDIPlus_BitmapCreateFromHBITMAP
; Description ...: Create a Bitmap object from a bitmap handle
; Syntax.........: _GDIPlus_BitmapCreateFromHBITMAP($hBmp[, $hPal = 0])
; Parameters ....: $hBmp        - Handle to a HBITMAP
;                  $hPal        - Handle to a HPALETTE
; Return values .: Success      - Handle to a Bitmap object
;                  Failure      - 0
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost
; Remarks .......: When you are done with the Bitmap object, call _GDIPlus_BitmapDispose to release the resources
; Related .......: _WinAPI_DeleteObject
; Link ..........: @@MsdnLink@@ GdipCreateBitmapFromHBITMAP
; Example .......: Yes
; ===============================================================================================================================
Func _GDIPlus_BitmapCreateFromHBITMAP($hBmp, $hPal = 0)
	Local $aResult = DllCall($ghGDIPDll, "int", "GdipCreateBitmapFromHBITMAP", "handle", $hBmp, "handle", $hPal, "ptr*", 0)
	If @error Then Return SetError(@error, @extended, 0)
	__GDIPlus_ObjectDispose_ListAdd($aResult[3], "Bitmap")
	Return SetExtended($aResult[0], $aResult[3])
EndFunc   ;==>_GDIPlus_BitmapCreateFromHBITMAP

; #FUNCTION# ====================================================================================================================
; Name...........: _GDIPlus_BitmapCreateHBITMAPFromBitmap
; Description ...: Create a handle to a bitmap from a bitmap object
; Syntax.........: _GDIPlus_BitmapCreateHBITMAPFromBitmap($hBitmap[, $iARGB = 0xFF000000])
; Parameters ....: $hBitmap     - Handle to a bitmap object
;                  $iARGB       - Color object that specifies the background color
; Return values .: Success      - Handle to a HBITMAP
;                  Failure      - 0
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost
; Remarks .......: When you are done with the Bitmap object, call _WinAPI_DeleteObject to release the resources
; Related .......: _WinAPI_DeleteObject
; Link ..........: @@MsdnLink@@ GdipCreateHBITMAPFromBitmap
; Example .......: Yes
; ===============================================================================================================================
Func _GDIPlus_BitmapCreateHBITMAPFromBitmap($hBitmap, $iARGB = 0xFF000000)
	Local $aResult = DllCall($ghGDIPDll, "int", "GdipCreateHBITMAPFromBitmap", "handle", $hBitmap, "ptr*", 0, "dword", $iARGB)
	If @error Then Return SetError(@error, @extended, 0)
	__GDIPlus_ObjectDispose_ListAdd($aResult[2], "BitmapObj")
	Return SetExtended($aResult[0], $aResult[2])
EndFunc   ;==>_GDIPlus_BitmapCreateHBITMAPFromBitmap

; #FUNCTION# ====================================================================================================================
; Name...........: _GDIPlus_BitmapDispose
; Description ...: Release a bitmap object
; Syntax.........: _GDIPlus_BitmapDispose($hBitmap)
; Parameters ....: $hBitmap     - Handle to a bitmap object
; Return values .: Success      - True
;                  Failure      - False
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost
; Remarks .......:
; Related .......:
; Link ..........: @@MsdnLink@@ GdipDisposeImage
; Example .......:
; ===============================================================================================================================
Func _GDIPlus_BitmapDispose($hBitmap)
	Local $aResult = DllCall($ghGDIPDll, "int", "GdipDisposeImage", "handle", $hBitmap)
	If @error Then Return SetError(@error, @extended, False)
	__GDIPlus_ObjectDispose_ListRemove($hBitmap, "Bitmap")
	Return $aResult[0] = 0
EndFunc   ;==>_GDIPlus_BitmapDispose

; #FUNCTION# ====================================================================================================================
; Name...........: _GDIPlus_BitmapLockBits
; Description ...: Locks a portion of a bitmap for reading or writing
; Syntax.........: _GDIPlus_BitmapLockBits($hBitmap, $iLeft, $iTop, $iWidth, $iHeight, $iFlags = $GDIP_ILMREAD, $iFormat = $GDIP_PXF32RGB)
; Parameters ....: $hBitmap     - Handle to a bitmap object
;                  $iLeft       - X coordinate of the upper-left corner of the rectangle to lock
;                  $iTop        - Y coordinate of the upper-left corner of the rectangle to lock
;                  $iWidth      - The width of the rectangle to lock
;                  $iHeight     - The height of the rectangle to lock
;                  $iFlags      - Set of flags that specify whether the locked portion of the bitmap is available for reading  or
;                  +for writing and whether the caller has already allocated a buffer. Can be a combination of the following:
;                  |$GDIP_ILMREAD         - A portion of the image is locked for reading
;                  |$GDIP_ILMWRITE        - A portion of the image is locked for writing
;                  |$GDIP_ILMUSERINPUTBUF - The buffer is allocated by the user
;                  $iFormat     - Specifies the format of the pixel data in the temporary buffer. Can be one of the following:
;                  |$GDIP_PXF01INDEXED   - 1 bpp, indexed
;                  |$GDIP_PXF04INDEXED   - 4 bpp, indexed
;                  |$GDIP_PXF08INDEXED   - 8 bpp, indexed
;                  |$GDIP_PXF16GRAYSCALE - 16 bpp, grayscale
;                  |$GDIP_PXF16RGB555    - 16 bpp; 5 bits for each RGB
;                  |$GDIP_PXF16RGB565    - 16 bpp; 5 bits red, 6 bits green, and 5 bits blue
;                  |$GDIP_PXF16ARGB1555  - 16 bpp; 1 bit for alpha and 5 bits for each RGB component
;                  |$GDIP_PXF24RGB       - 24 bpp; 8 bits for each RGB
;                  |$GDIP_PXF32RGB       - 32 bpp; 8 bits for each RGB. No alpha.
;                  |$GDIP_PXF32ARGB      - 32 bpp; 8 bits for each RGB and alpha
;                  |$GDIP_PXF32PARGB     - 32 bpp; 8 bits for each RGB and alpha, pre-mulitiplied
; Return values .: Success      - $tagGDIPBITMAPDATA structure
;                  Failure      - @error is set
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost
; Remarks .......: When you are done with the locked portion, call _GDIPlus_BitmapUnlockBits to release the locked region
; Related .......: _WinAPI_DeleteObject, _GDIPlus_ImageGetPixelFormat
; Link ..........: @@MsdnLink@@ GdipBitmapLockBits
; Example .......:
; ===============================================================================================================================
Func _GDIPlus_BitmapLockBits($hBitmap, $iLeft, $iTop, $iWidth, $iHeight, $iFlags = $GDIP_ILMREAD, $iFormat = $GDIP_PXF32RGB)
	Local $tData = DllStructCreate($tagGDIPBITMAPDATA)
	Local $pData = DllStructGetPtr($tData)
	Local $tRect = DllStructCreate($tagRECT)
	Local $pRect = DllStructGetPtr($tRect)

	; The RECT is initialized strange for this function.  It wants the Left and
	; Top members set as usual but instead of Right and Bottom also being
	; coordinates they are expected to be the Width and Height sizes
	; respectively.
	DllStructSetData($tRect, "Left", $iLeft)
	DllStructSetData($tRect, "Top", $iTop)
	DllStructSetData($tRect, "Right", $iWidth)
	DllStructSetData($tRect, "Bottom", $iHeight)
	Local $aResult = DllCall($ghGDIPDll, "int", "GdipBitmapLockBits", "handle", $hBitmap, "ptr", $pRect, "uint", $iFlags, "int", $iFormat, "ptr", $pData)
	If @error Then Return SetError(@error, @extended, 0)
	Return SetExtended($aResult[0], $tData)
EndFunc   ;==>_GDIPlus_BitmapLockBits

; #FUNCTION# ====================================================================================================================
; Name...........: _GDIPlus_BitmapUnlockBits
; Description ...: Unlocks a portion of a bitmap that was locked by _GDIPlus_BitmapLockBits
; Syntax.........: _GDIPlus_BitmapUnlockBits($hBitmap, $tBitmapData)
; Parameters ....: $hBitmap     - Handle to a bitmap object
;                  $tBitmapData - $tagGDIPBITMAPDATA structure previously passed to _GDIPlus_BitmapLockBits
; Return values .: Success      - True
;                  Failure      - False
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost
; Remarks .......: When you are done with the locked portion, call _GDIPlus_BitmapUnlockBits to release the locked region
; Related .......: _WinAPI_DeleteObject
; Link ..........: @@MsdnLink@@ GdipBitmapUnlockBits
; Example .......:
; ===============================================================================================================================
Func _GDIPlus_BitmapUnlockBits($hBitmap, $tBitmapData)
	Local $aResult = DllCall($ghGDIPDll, "int", "GdipBitmapUnlockBits", "handle", $hBitmap, "ptr", DllStructGetPtr($tBitmapData))
	If @error Then Return SetError(@error, @extended, False)
	Return $aResult[0] = 0
EndFunc   ;==>_GDIPlus_BitmapUnlockBits

; #FUNCTION# ====================================================================================================================
; Name...........: _GDIPlus_BrushClone
; Description ...: Clone a Brush object
; Syntax.........: _GDIPlus_BrushClone($hBrush)
; Parameters ....: $hBrush      - Handle to a Brush object
; Return values .: Success      - Handle to a new Brush object
;                  Failure      - 0
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost
; Remarks .......: When you are done with the Brush object, call _GDIPlus_BrushDispose to release the resources
; Related .......: _GDIPlus_BrushDispose
; Link ..........: @@MsdnLink@@ GdipCloneBrush
; Example .......: Yes
; ===============================================================================================================================
Func _GDIPlus_BrushClone($hBrush)
	Local $aResult = DllCall($ghGDIPDll, "int", "GdipCloneBrush", "handle", $hBrush, "ptr*", 0)
	If @error Then Return SetError(@error, @extended, 0)
	__GDIPlus_ObjectDispose_ListAdd($aResult[2], "Brush")
	Return SetExtended($aResult[0], $aResult[2])
EndFunc   ;==>_GDIPlus_BrushClone

; #FUNCTION# ====================================================================================================================
; Name...........: _GDIPlus_BrushCreateSolid
; Description ...: Create a solid Brush object
; Syntax.........: _GDIPlus_BrushCreateSolid([$iARGB = 0xFF000000])
; Parameters ....: $iARGB       - Alpha, Red, Green and Blue components of brush
; Return values .: Success      - Handle to a solid Brush object
;                  Failure      - 0
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost
; Remarks .......: When you are done with the Brush object, call _GDIPlus_BrushDispose to release the resources
; Related .......: _GDIPlus_BrushDispose
; Link ..........: @@MsdnLink@@ GdipCreateSolidFill
; Example .......: Yes
; ===============================================================================================================================
Func _GDIPlus_BrushCreateSolid($iARGB = 0xFF000000)
	Local $aResult = DllCall($ghGDIPDll, "int", "GdipCreateSolidFill", "int", $iARGB, "dword*", 0)
	If @error Then Return SetError(@error, @extended, 0)
	__GDIPlus_ObjectDispose_ListAdd($aResult[2], "Brush")
	Return SetExtended($aResult[0], $aResult[2])
EndFunc   ;==>_GDIPlus_BrushCreateSolid

; #FUNCTION# ====================================================================================================================
; Name...........: _GDIPlus_BrushDispose
; Description ...: Release a Brush object
; Syntax.........: _GDIPlus_BrushDispose($hBrush)
; Parameters ....: $hBrush      - Handle to a Brush object
; Return values .: Success      - True
;                  Failure      - False
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost
; Remarks .......:
; Related .......: _GDIPlus_BrushCreateSolid, _GDIPlus_BrushClone
; Link ..........: @@MsdnLink@@ GdipDeleteBrush
; Example .......: Yes
; ===============================================================================================================================
Func _GDIPlus_BrushDispose($hBrush)
	Local $aResult = DllCall($ghGDIPDll, "int", "GdipDeleteBrush", "handle", $hBrush)
	If @error Then Return SetError(@error, @extended, False)
	__GDIPlus_ObjectDispose_ListRemove($hBrush, "Brush")
	Return $aResult[0] = 0
EndFunc   ;==>_GDIPlus_BrushDispose

; #FUNCTION# ====================================================================================================================
; Name...........: _GDIPlus_BrushGetSolidColor
; Description ...: Get the color of a Solid Brush object
; Syntax.........: _GDIPlus_BrushGetSolidColor($hBrush, [$iARGB = 0xFF000000])
; Parameters ....: $hBrush      - Handle to a Brush object
;				   $iARGB		- The color of the brush.
; Return values .: Success      - Brush color
;                  Failure      - -1 and @error is set
; Author ........:
; Modified.......: smashly
; Remarks .......:
; Related .......:
; Link ..........: @@MsdnLink@@ GdipGetSolidFillColor
; Example .......: Yes
; ===============================================================================================================================
Func _GDIPlus_BrushGetSolidColor($hBrush)
	Local $aResult = DllCall($ghGDIPDll, "int", "GdipGetSolidFillColor", "handle", $hBrush, "dword*", 0)
	If @error Then Return SetError(@error, @extended, -1)
	Return SetExtended($aResult[0], $aResult[2])
EndFunc   ;==>_GDIPlus_BrushGetSolidColor

; #FUNCTION# ====================================================================================================================
; Name...........: _GDIPlus_BrushGetType
; Description ...: Retrieve the type of Brush object
; Syntax.........: _GDIPlus_BrushGetType($hBrush)
; Parameters ....: $hBrush      - Handle to a Brush object
; Return values .: Success      - Brush type:
;                  |0 - Solid color
;                  |1 - Hatch fill
;                  |2 - Texture fill
;                  |3 - Path gradient
;                  |4 - Linear gradient
;                  Failure     - -1 and @error is set
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost
; Remarks .......:
; Related .......:
; Link ..........: @@MsdnLink@@ GdipGetBrushType
; Example .......: Yes
; ===============================================================================================================================
Func _GDIPlus_BrushGetType($hBrush)
	Local $aResult = DllCall($ghGDIPDll, "int", "GdipGetBrushType", "handle", $hBrush, "int*", 0)
	If @error Then Return SetError(@error, @extended, -1)
	Return SetExtended($aResult[0], $aResult[2])
EndFunc   ;==>_GDIPlus_BrushGetType

; #FUNCTION# ====================================================================================================================
; Name...........: _GDIPlus_BrushSetSolidColor
; Description ...: Set the color of a Solid Brush object
; Syntax.........: _GDIPlus_BrushSetSolidColor($hBrush, [$iARGB = 0xFF000000])
; Parameters ....: $hBrush      - Handle to a Brush object
;                  $iARGB       - Alpha, Red, Green and Blue components of brush
; Return values .: Success      - True
;                  Failure      - False
; Author ........:
; Modified.......: smashly
; Remarks .......:
; Related .......:
; Link ..........: @@MsdnLink@@ GdipSetSolidFillColor
; Example .......: Yes
; ===============================================================================================================================
Func _GDIPlus_BrushSetSolidColor($hBrush, $iARGB = 0xFF000000)
	Local $aResult = DllCall($ghGDIPDll, "int", "GdipSetSolidFillColor", "handle", $hBrush, "dword", $iARGB)
	If @error Then Return SetError(@error, @extended, 0)
	Return $aResult[0] = 0
EndFunc   ;==>_GDIPlus_BrushSetSolidColor

; #FUNCTION# ====================================================================================================================
; Name...........: _GDIPlus_CustomLineCapDispose
; Description ...: Release a custom line cap object
; Syntax.........: _GDIPlus_CustomLineCapDispose($hCap)
; Parameters ....: $hCap        - Handle to a custom line cap object
; Return values .: Success      - True
;                  Failure      - False
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost
; Remarks .......:
; Related .......:
; Link ..........: @@MsdnLink@@ GdipDeleteCustomLineCap
; Example .......:
; ===============================================================================================================================
Func _GDIPlus_CustomLineCapDispose($hCap)
	Local $aResult = DllCall($ghGDIPDll, "int", "GdipDeleteCustomLineCap", "handle", $hCap)
	If @error Then Return SetError(@error, @extended, False)
	__GDIPlus_ObjectDispose_ListRemove($hCap, "Cap")
	Return $aResult[0] = 0
EndFunc   ;==>_GDIPlus_CustomLineCapDispose

; #FUNCTION# ====================================================================================================================
; Name...........: _GDIPlus_Decoders
; Description ...: Get an array of information about the available image decoders
; Syntax.........: _GDIPlus_Decoders()
; Parameters ....:
; Return values .: Success      - Array with the following format:
;                  |[0][ 0] - Number of decoders
;                  |[1][ 1] - Codec identifier
;                  |[1][ 2] - File format identifier
;                  |[1][ 3] - Codec name
;                  |[1][ 4] - Dll in which the code resides
;                  |[1][ 5] - The name of the file format used by the codec
;                  |[1][ 6] - Filename extensions associated with the codec
;                  |[1][ 7] - The mime type of the codec
;                  |[1][ 8] - Combination of $GDIP_ICF flags
;                  |[1][ 9] - The version of the codec
;                  |[1][10] - The number of signatures used by the file format
;                  |[1][11] - The number of bytes in each signature
;                  |[1][12] - Pointer to the pattern for each signature
;                  |[1][13] - Pointer to the mask for each signature
;                  Failure     - @error is set
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost
; Remarks .......:
; Related .......: _GDIPlus_Encoders
; Link ..........: @@MsdnLink@@ GdipGetImageDecoders
; Example .......: Yes
; ===============================================================================================================================
Func _GDIPlus_Decoders()
	Local $iCount = _GDIPlus_DecodersGetCount()
	Local $iSize = _GDIPlus_DecodersGetSize()
	Local $tBuffer = DllStructCreate("byte[" & $iSize & "]")
	Local $pBuffer = DllStructGetPtr($tBuffer)
	Local $aResult = DllCall($ghGDIPDll, "int", "GdipGetImageDecoders", "uint", $iCount, "uint", $iSize, "ptr", $pBuffer)
	If @error Then Return SetError(@error, @extended, 0)
	If $aResult[0] <> 0 Then Return SetError($aResult[0], 0, 0)

	Local $tCodec, $aInfo[$iCount + 1][14]
	$aInfo[0][0] = $iCount
	For $iI = 1 To $iCount
		$tCodec = DllStructCreate($tagGDIPIMAGECODECINFO, $pBuffer)
		$aInfo[$iI][1] = _WinAPI_StringFromGUID(DllStructGetPtr($tCodec, "CLSID"))
		$aInfo[$iI][2] = _WinAPI_StringFromGUID(DllStructGetPtr($tCodec, "FormatID"))
		$aInfo[$iI][3] = _WinAPI_WideCharToMultiByte(DllStructGetData($tCodec, "CodecName"))
		$aInfo[$iI][4] = _WinAPI_WideCharToMultiByte(DllStructGetData($tCodec, "DllName"))
		$aInfo[$iI][5] = _WinAPI_WideCharToMultiByte(DllStructGetData($tCodec, "FormatDesc"))
		$aInfo[$iI][6] = _WinAPI_WideCharToMultiByte(DllStructGetData($tCodec, "FileExt"))
		$aInfo[$iI][7] = _WinAPI_WideCharToMultiByte(DllStructGetData($tCodec, "MimeType"))
		$aInfo[$iI][8] = DllStructGetData($tCodec, "Flags")
		$aInfo[$iI][9] = DllStructGetData($tCodec, "Version")
		$aInfo[$iI][10] = DllStructGetData($tCodec, "SigCount")
		$aInfo[$iI][11] = DllStructGetData($tCodec, "SigSize")
		$aInfo[$iI][12] = DllStructGetData($tCodec, "SigPattern")
		$aInfo[$iI][13] = DllStructGetData($tCodec, "SigMask")
		$pBuffer += DllStructGetSize($tCodec)
	Next
	Return $aInfo
EndFunc   ;==>_GDIPlus_Decoders

; #FUNCTION# ====================================================================================================================
; Name...........: _GDIPlus_DecodersGetCount
; Description ...: Get the number of available image decoders
; Syntax.........: _GDIPlus_DecodersGetCount()
; Parameters ....:
; Return values .: Success      - Number of image decoders
;                  Failure      - -1 and @error is set
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost
; Remarks .......:
; Related .......: _GDIPlus_DecodersGetSize
; Link ..........: @@MsdnLink@@ GdipGetImageDecodersSize
; Example .......: Yes
; ===============================================================================================================================
Func _GDIPlus_DecodersGetCount()
	Local $aResult = DllCall($ghGDIPDll, "int", "GdipGetImageDecodersSize", "uint*", 0, "uint*", 0)
	If @error Then Return SetError(@error, @extended, -1)
	Return SetExtended($aResult[0], $aResult[1])
EndFunc   ;==>_GDIPlus_DecodersGetCount

; #FUNCTION# ====================================================================================================================
; Name...........: _GDIPlus_DecodersGetSize
; Description ...: Get the total size of the structure that is returned by _GDIPlus_GetImageDecoders
; Syntax.........: _GDIPlus_DecodersGetSize()
; Parameters ....:
; Return values .: Success      - Total size, in bytes
;                  Failure      - -1 and @error is set
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost
; Remarks .......:
; Related .......: _GDIPlus_DecodersGetCount
; Link ..........: @@MsdnLink@@ GdipGetImageDecodersSize
; Example .......: Yes
; ===============================================================================================================================
Func _GDIPlus_DecodersGetSize()
	Local $aResult = DllCall($ghGDIPDll, "int", "GdipGetImageDecodersSize", "uint*", 0, "uint*", 0)
	If @error Then Return SetError(@error, @extended, -1)
	Return SetExtended($aResult[0], $aResult[2])
EndFunc   ;==>_GDIPlus_DecodersGetSize

; #FUNCTION# =====================================================================
; Name...........: _GDIPlus_DrawImagePoints
; Description ...: Draws an image at a specified location.
; Syntax.........: _GDIPlus_DrawImagePoints($hGraphic, $hImage, $nULX, $nULY, $nURX, $nURY, $nLLX, $nLLY[, $count = 3])
; Parameters ....: $hGraphic    - Handle to a Graphics object
;                  $hImage      - Handle to an Image object
;                  $nULX        - The X coordinate of the upper left corner of the source image
;                  $nULY        - The Y coordinate of the upper left corner of the source image
;                  $nURX        - The X coordinate of the upper right corner of the source image
;                  $nURY        - The Y coordinate of the upper right corner of the source image
;                  $nLLX        - The X coordinate of the lower left corner of the source image
;                  $nLLY        - The Y coordinate of the lower left corner of the source image
;                  $count       - Specifies the number of points (x,y)'s in the structure.
; Return values .: Success      - True
;                  Failure      - False
; Author ........: Malkey
; Modified.......:
; Remarks .......: The value of the count parameter must equal 3 to specify the coordinates of
;                  the upper-left corner, upper-right corner, and lower-left corner of the
;                  parallelogram. The coordinate of the lower-right corner, the width, and the
;                  height of the image, are calculated using the three given coordinates.
;                  The image is scaled to fit the parallelogram.
; Related .......:
; Link ..........: @@MsdnLink@@ GdipDrawImagePoints
; Example .......: Yes
; ===============================================================================
Func _GDIPlus_DrawImagePoints($hGraphic, $hImage, $nULX, $nULY, $nURX, $nURY, $nLLX, $nLLY, $count = 3)
	Local $tPoint = DllStructCreate("float X;float Y;float X2;float Y2;float X3;float Y3")
	DllStructSetData($tPoint, "X", $nULX)
	DllStructSetData($tPoint, "Y", $nULY)
	DllStructSetData($tPoint, "X2", $nURX)
	DllStructSetData($tPoint, "Y2", $nURY)
	DllStructSetData($tPoint, "X3", $nLLX)
	DllStructSetData($tPoint, "Y3", $nLLY)
	Local $pPoint = DllStructGetPtr($tPoint)
	Local $aResult = DllCall($ghGDIPDll, "int", "GdipDrawImagePoints", "handle", $hGraphic, "handle", $hImage, "ptr", $pPoint, "int", $count)
	If @error Then Return SetError(@error, @extended, False)
	Return $aResult[0] = 0
EndFunc   ;==>_GDIPlus_DrawImagePoints

; #FUNCTION# ====================================================================================================================
; Name...........: _GDIPlus_Encoders
; Description ...: Get an array of information about the available image encoders
; Syntax.........: _GDIPlus_Encoders()
; Parameters ....:
; Return values .: Success      - Array with the following format:
;                  |[0][ 0] - Number of decoders
;                  |[1][ 1] - Codec identifier
;                  |[1][ 2] - File format identifier
;                  |[1][ 3] - Codec name
;                  |[1][ 4] - Dll in which the code resides
;                  |[1][ 5] - The name of the file format used by the codec
;                  |[1][ 6] - Filename extensions associated with the codec
;                  |[1][ 7] - The mime type of the codec
;                  |[1][ 8] - Combination of $GDIP_ICF flags
;                  |[1][ 9] - The version of the codec
;                  |[1][10] - The number of signatures used by the file format
;                  |[1][11] - The number of bytes in each signature
;                  |[1][12] - Pointer to the pattern for each signature
;                  |[1][13] - Pointer to the mask for each signature
;                  Failure     - @error is set
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost
; Remarks .......:
; Related .......: _GDIPlus_Decoders
; Link ..........: @@MsdnLink@@ GdipGetImageEncoders
; Example .......: Yes
; ===============================================================================================================================
Func _GDIPlus_Encoders()
	Local $iCount = _GDIPlus_EncodersGetCount()
	Local $iSize = _GDIPlus_EncodersGetSize()
	Local $tBuffer = DllStructCreate("byte[" & $iSize & "]")
	Local $pBuffer = DllStructGetPtr($tBuffer)
	Local $aResult = DllCall($ghGDIPDll, "int", "GdipGetImageEncoders", "uint", $iCount, "uint", $iSize, "ptr", $pBuffer)
	If @error Then Return SetError(@error, @extended, 0)
	If $aResult[0] <> 0 Then Return SetError($aResult[0], 0, 0)

	Local $tCodec, $aInfo[$iCount + 1][14]
	$aInfo[0][0] = $iCount
	For $iI = 1 To $iCount
		$tCodec = DllStructCreate($tagGDIPIMAGECODECINFO, $pBuffer)
		$aInfo[$iI][1] = _WinAPI_StringFromGUID(DllStructGetPtr($tCodec, "CLSID"))
		$aInfo[$iI][2] = _WinAPI_StringFromGUID(DllStructGetPtr($tCodec, "FormatID"))
		$aInfo[$iI][3] = _WinAPI_WideCharToMultiByte(DllStructGetData($tCodec, "CodecName"))
		$aInfo[$iI][4] = _WinAPI_WideCharToMultiByte(DllStructGetData($tCodec, "DllName"))
		$aInfo[$iI][5] = _WinAPI_WideCharToMultiByte(DllStructGetData($tCodec, "FormatDesc"))
		$aInfo[$iI][6] = _WinAPI_WideCharToMultiByte(DllStructGetData($tCodec, "FileExt"))
		$aInfo[$iI][7] = _WinAPI_WideCharToMultiByte(DllStructGetData($tCodec, "MimeType"))
		$aInfo[$iI][8] = DllStructGetData($tCodec, "Flags")
		$aInfo[$iI][9] = DllStructGetData($tCodec, "Version")
		$aInfo[$iI][10] = DllStructGetData($tCodec, "SigCount")
		$aInfo[$iI][11] = DllStructGetData($tCodec, "SigSize")
		$aInfo[$iI][12] = DllStructGetData($tCodec, "SigPattern")
		$aInfo[$iI][13] = DllStructGetData($tCodec, "SigMask")
		$pBuffer += DllStructGetSize($tCodec)
	Next
	Return $aInfo
EndFunc   ;==>_GDIPlus_Encoders

; #FUNCTION# ====================================================================================================================
; Name...........: _GDIPlus_EncodersGetCLSID
; Description ...: Return the encoder CLSID for a specific image file type
; Syntax.........: _GDIPlus_EncodersGetCLSID($sFileExt)
; Parameters ....: $sFileExt    - File extension to search for (BMP, JPG, TIF, etc.)
; Return values .: Success      - CLSID of the encoder in string format
;                  Failure      - Blank string
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........: @@MsdnLink@@ GdipGetImageEncoders
; Example .......: Yes
; ===============================================================================================================================
Func _GDIPlus_EncodersGetCLSID($sFileExt)
	Local $aEncoders = _GDIPlus_Encoders()
	For $iI = 1 To $aEncoders[0][0]
		If StringInStr($aEncoders[$iI][6], "*." & $sFileExt) > 0 Then Return $aEncoders[$iI][1]
	Next
	Return SetError(-1, -1, "")
EndFunc   ;==>_GDIPlus_EncodersGetCLSID

; #FUNCTION# ====================================================================================================================
; Name...........: _GDIPlus_EncodersGetCount
; Description ...: Get the number of available image encoders
; Syntax.........: _GDIPlus_EncodersGetCount()
; Parameters ....:
; Return values .: Success      - Number of image encoders
;                  Failure      - -1 and @error is set
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost
; Remarks .......:
; Related .......: _GDIPlus_EncodersGetSize
; Link ..........: @@MsdnLink@@ GdipGetImageEncodersSize
; Example .......: Yes
; ===============================================================================================================================
Func _GDIPlus_EncodersGetCount()
	Local $aResult = DllCall($ghGDIPDll, "int", "GdipGetImageEncodersSize", "uint*", 0, "uint*", 0)
	If @error Then Return SetError(@error, @extended, -1)
	Return SetExtended($aResult[0], $aResult[1])
EndFunc   ;==>_GDIPlus_EncodersGetCount

; #FUNCTION# ====================================================================================================================
; Name...........: _GDIPlus_EncodersGetParamList
; Description ...: Get the parameter list for a specified image encoder
; Syntax.........: _GDIPlus_EncodersGetParamList($hImage, $sEncoder)
; Parameters ....: $hImage      - Handle to an image object
;                  $sEncoder    - GUID string of encoder to be used
; Return values .: Success      - $tagGDIPPENCODERPARAMS structure
;                  Failure      - 0
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost
; Remarks .......:
; Related .......: _GDIPlus_EncodersGetParamListSize, $tagGDIPENCODERPARAMS
; Link ..........: @@MsdnLink@@ GdipGetEncoderParameterList
; Example .......: Yes
; ===============================================================================================================================
Func _GDIPlus_EncodersGetParamList($hImage, $sEncoder)
	Local $iSize = _GDIPlus_EncodersGetParamListSize($hImage, $sEncoder)
	If @error Then Return SetError(@error, -1, 0)
	Local $tGUID = _WinAPI_GUIDFromString($sEncoder)
	Local $pGUID = DllStructGetPtr($tGUID)
	Local $tBuffer = DllStructCreate("dword Count;byte Params[" & $iSize - 4 & "]")
	Local $pBuffer = DllStructGetPtr($tBuffer)
	Local $aResult = DllCall($ghGDIPDll, "int", "GdipGetEncoderParameterList", "handle", $hImage, "ptr", $pGUID, "uint", $iSize, "ptr", $pBuffer)
	If @error Then Return SetError(@error, @extended, 0)
	Return SetExtended($aResult[0], $tBuffer)
EndFunc   ;==>_GDIPlus_EncodersGetParamList

; #FUNCTION# ====================================================================================================================
; Name...........: _GDIPlus_EncodersGetParamListSize
; Description ...: Get the size of the parameter list for a specified image encoder
; Syntax.........: _GDIPlus_EncodersGetParamListSize($hImage, $sEncoder)
; Parameters ....: $hImage      - Handle to an image object
;                  $sEncoder    - GUID string of encoder to be used
; Return values .: Success      - Size, in bytes, of the parameter list
;                  Failure      - 0
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost
; Remarks .......:
; Related .......: _GDIPlus_EncodersGetParamList
; Link ..........: @@MsdnLink@@ GdipGetEncoderParameterListSize
; Example .......: Yes
; ===============================================================================================================================
Func _GDIPlus_EncodersGetParamListSize($hImage, $sEncoder)
	Local $tGUID = _WinAPI_GUIDFromString($sEncoder)
	Local $pGUID = DllStructGetPtr($tGUID)
	Local $aResult = DllCall($ghGDIPDll, "int", "GdipGetEncoderParameterListSize", "handle", $hImage, "ptr", $pGUID, "uint*", 0)
	If @error Then Return SetError(@error, @extended, 0)
	Return SetExtended($aResult[0], $aResult[3])
EndFunc   ;==>_GDIPlus_EncodersGetParamListSize

; #FUNCTION# ====================================================================================================================
; Name...........: _GDIPlus_EncodersGetSize
; Description ...: Get the total size of the structure that is returned by _GDIPlus_GetImageEncoders
; Syntax.........: _GDIPlus_EncodersGetSize()
; Parameters ....:
; Return values .: Success      - Total size, in bytes
;                  Failure      - -1 and @error is set
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost
; Remarks .......:
; Related .......: _GDIPlus_EncodersGetCount
; Link ..........: @@MsdnLink@@ GdipGetImageEncodersSize
; Example .......: Yes
; ===============================================================================================================================
Func _GDIPlus_EncodersGetSize()
	Local $aResult = DllCall($ghGDIPDll, "int", "GdipGetImageEncodersSize", "uint*", 0, "uint*", 0)
	If @error Then Return SetError(@error, @extended, -1)
	Return SetExtended($aResult[0], $aResult[2])
EndFunc   ;==>_GDIPlus_EncodersGetSize

; #FUNCTION# ====================================================================================================================
; Name...........: _GDIPlus_FontCreate
; Description ...: Create a Font object
; Syntax.........: _GDIPlus_FontCreate($hFamily, $fSize[, $iStyle = 0[, $iUnit = 3]])
; Parameters ....: $hFamily     - Handle to a Font Family object
;                  $fSize       - The size of the font measured in the units specified in the $iUnit parameter
;                  $iStyle      - The style of the typeface. Can be a combination of the following:
;                  |0 - Normal weight or thickness of the typeface
;                  |1 - Bold typeface
;                  |2 - Italic typeface
;                  |4 - Underline
;                  |8 - Strikethrough
;                  $iUnit       - Unit of measurement for the font size:
;                  |0 - World coordinates, a nonphysical unit
;                  |1 - Display units
;                  |2 - A unit is 1 pixel
;                  |3 - A unit is 1 point or 1/72 inch
;                  |4 - A unit is 1 inch
;                  |5 - A unit is 1/300 inch
;                  |6 - A unit is 1 millimeter
; Return values .: Success      - Handle to a Font object
;                  Failure      - 0
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost
; Remarks .......: When you are done with the Font object, call _GDIPlus_FontDispose to release the resources
; Related .......: _GDIPlus_FontDispose
; Link ..........: @@MsdnLink@@ GdipCreateFont
; Example .......: Yes
; ===============================================================================================================================
Func _GDIPlus_FontCreate($hFamily, $fSize, $iStyle = 0, $iUnit = 3)
	Local $aResult = DllCall($ghGDIPDll, "int", "GdipCreateFont", "handle", $hFamily, "float", $fSize, "int", $iStyle, "int", $iUnit, "ptr*", 0)
	If @error Then Return SetError(@error, @extended, 0)
	__GDIPlus_ObjectDispose_ListAdd($aResult[5], "Font")
	Return SetExtended($aResult[0], $aResult[5])
EndFunc   ;==>_GDIPlus_FontCreate

; #FUNCTION# ====================================================================================================================
; Name...........: _GDIPlus_FontDispose
; Description ...: Release a Font object
; Syntax.........: _GDIPlus_FontDispose($hFont)
; Parameters ....: $hFont       - Handle to a Font object
; Return values .: Success      - True
;                  Failure      - False
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost
; Remarks .......:
; Related .......: _GDIPlus_FontCreate
; Link ..........: @@MsdnLink@@ GdipDeleteFont
; Example .......: Yes
; ===============================================================================================================================
Func _GDIPlus_FontDispose($hFont)
	Local $aResult = DllCall($ghGDIPDll, "int", "GdipDeleteFont", "handle", $hFont)
	If @error Then Return SetError(@error, @extended, False)
	__GDIPlus_ObjectDispose_ListRemove($hFont, "Font")
	Return $aResult[0] = 0
EndFunc   ;==>_GDIPlus_FontDispose

; #FUNCTION# ====================================================================================================================
; Name...........: _GDIPlus_FontFamilyCreate
; Description ...: Create a Font Family object
; Syntax.........: _GDIPlus_FontFamilyCreate($sFamily)
; Parameters ....: $sFamily     - Name of the Font Family
; Return values .: Success      - Handle to a Font Family object
;                  Failure      - 0
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost
; Remarks .......: When you are done with the Font Family object, call _GDIPlus_FontFamilyDispose to release the resources
; Related .......: _GDIPlus_FontFamilyDispose
; Link ..........: @@MsdnLink@@ GdipCreateFontFamilyFromName
; Example .......: Yes
; ===============================================================================================================================
Func _GDIPlus_FontFamilyCreate($sFamily)
	Local $aResult = DllCall($ghGDIPDll, "int", "GdipCreateFontFamilyFromName", "wstr", $sFamily, "ptr", 0, "handle*", 0)
	If @error Then Return SetError(@error, @extended, 0)
	__GDIPlus_ObjectDispose_ListAdd($aResult[3], "FontFamily")
	Return SetExtended($aResult[0], $aResult[3])
EndFunc   ;==>_GDIPlus_FontFamilyCreate

; #FUNCTION# ====================================================================================================================
; Name...........: _GDIPlus_FontFamilyDispose
; Description ...: Release a Font Family object
; Syntax.........: _GDIPlus_FontFamilyDispose($hFamily)
; Parameters ....: $hFamily     - Handle to a Font Family object
; Return values .: Success      - True
;                  Failure      - False
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost
; Remarks .......:
; Related .......: _GDIPlus_FontFamilyCreate
; Link ..........: @@MsdnLink@@ GdipDeleteFontFamily
; Example .......: Yes
; ===============================================================================================================================
Func _GDIPlus_FontFamilyDispose($hFamily)
	Local $aResult = DllCall($ghGDIPDll, "int", "GdipDeleteFontFamily", "handle", $hFamily)
	If @error Then Return SetError(@error, @extended, False)
	__GDIPlus_ObjectDispose_ListRemove($hFamily, "FontFamily")
	Return $aResult[0] = 0
EndFunc   ;==>_GDIPlus_FontFamilyDispose

; #FUNCTION# ====================================================================================================================
; Name...........: _GDIPlus_GraphicsClear
; Description ...: Clears a Graphics object to a specified color
; Syntax.........: _GDIPlus_GraphicsClear($hGraphics[, $iARGB = 0xFF000000])
; Parameters ....: $hGraphics   - Handle to a Graphics object
;                  $iARGB       - Alpha, Red, Green and Blue components of color
; Return values .: Success      - True
;                  Failure      - False
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost
; Remarks .......:
; Related .......:
; Link ..........: @@MsdnLink@@ GdipGraphicsClear
; Example .......: Yes
; ===============================================================================================================================
Func _GDIPlus_GraphicsClear($hGraphics, $iARGB = 0xFF000000)
	Local $aResult = DllCall($ghGDIPDll, "int", "GdipGraphicsClear", "handle", $hGraphics, "dword", $iARGB)
	If @error Then Return SetError(@error, @extended, False)
	Return $aResult[0] = 0
EndFunc   ;==>_GDIPlus_GraphicsClear

; #FUNCTION# ====================================================================================================================
; Name...........: _GDIPlus_GraphicsCreateFromHDC
; Description ...: Create a Graphics object from a device contect (DC)
; Syntax.........: _GDIPlus_GraphicsCreateFromHDC($hDC)
; Parameters ....: $hDC         - Device context
; Return values .: Success      - Handle to a Graphics object
;                  Failure      - 0
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost
; Remarks .......: When you are done with the Graphics object, call _GDIPlus_GraphicsDispose to release the resources
; Related .......: _GDIPlus_GraphicsDispose
; Link ..........: @@MsdnLink@@ GdipCreateFromHDC
; Example .......: Yes
; ===============================================================================================================================
Func _GDIPlus_GraphicsCreateFromHDC($hDC)
	Local $aResult = DllCall($ghGDIPDll, "int", "GdipCreateFromHDC", "handle", $hDC, "ptr*", 0)
	If @error Then Return SetError(@error, @extended, 0)
	__GDIPlus_ObjectDispose_ListAdd($aResult[2], "Graphics")
	Return SetExtended($aResult[0], $aResult[2])
EndFunc   ;==>_GDIPlus_GraphicsCreateFromHDC

; #FUNCTION# ====================================================================================================================
; Name...........: _GDIPlus_GraphicsCreateFromHWND
; Description ...: Create a Graphics object from a window handle
; Syntax.........: _GDIPlus_GraphicsCreateFromHWND($hWnd)
; Parameters ....: $hWnd        - Handle to a window
; Return values .: Success      - Handle to a Graphics object
;                  Failure      - 0
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost
; Remarks .......: When you are done with the Graphics object, call _GDIPlus_GraphicsDispose to release the resources
; Related .......: _GDIPlus_GraphicsDispose
; Link ..........: @@MsdnLink@@ GdipCreateFromHWND
; Example .......: Yes
; ===============================================================================================================================
Func _GDIPlus_GraphicsCreateFromHWND($hWnd)
	Local $aResult = DllCall($ghGDIPDll, "int", "GdipCreateFromHWND", "hwnd", $hWnd, "ptr*", 0)
	If @error Then Return SetError(@error, @extended, 0)
	__GDIPlus_ObjectDispose_ListAdd($aResult[2], "Graphics")
	Return SetExtended($aResult[0], $aResult[2])
EndFunc   ;==>_GDIPlus_GraphicsCreateFromHWND

; #FUNCTION# ====================================================================================================================
; Name...........: _GDIPlus_GraphicsDispose
; Description ...: Release a Graphics object
; Syntax.........: _GDIPlus_GraphicsDispose($hGraphics)
; Parameters ....: $hGraphics   - Handle to a Graphics object
; Return values .: Success      - True
;                  Failure      - False
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost
; Remarks .......:
; Related .......: _GDIPlus_GraphicsCreateFromHDC, _GDIPlus_GraphicsCreateFromHWND
; Link ..........: @@MsdnLink@@ GdipDeleteGraphics
; Example .......: Yes
; ===============================================================================================================================
Func _GDIPlus_GraphicsDispose($hGraphics)
	Local $aResult = DllCall($ghGDIPDll, "int", "GdipDeleteGraphics", "handle", $hGraphics)
	If @error Then Return SetError(@error, @extended, False)
	__GDIPlus_ObjectDispose_ListRemove($hGraphics, "Graphics")
	Return $aResult[0] = 0
EndFunc   ;==>_GDIPlus_GraphicsDispose

; #FUNCTION# ====================================================================================================================
; Name...........: _GDIPlus_GraphicsDrawArc
; Description ...: Draw an arc
; Syntax.........: _GDIPlus_GraphicsDrawArc($hGraphics, $iX, $iY, $iWidth, $iHeight, $fStartAngle, $fSweepAngle[, $hPen = 0])
; Parameters ....: $hGraphics   - Handle to a Graphics object
;                  $iX          - The X coordinate of the upper left corner of the rectangle that bounds the ellipse in which  to
;                  +draw the arc
;                  $iY          - The Y coordinate of the upper left corner of the rectangle that bounds the ellipse in which  to
;                  +draw the arc
;                  $iWidth      - The width of the rectangle that bounds the ellipse in which to draw the arc
;                  $iHeight     - The height of the rectangle that bounds the ellipse in which to draw the arc
;                  $fStartAngle - The angle between the X axis and the starting point of the arc
;                  $fSweepAngle - The angle between the starting and ending points of the arc
;                  $hPen        - Handle to a pen object that is used to draw the arc.  If 0, a solid black pen with a width of 1
;                  +will be used.
; Return values .: Success      - True
;                  Failure      - False
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost
; Remarks .......:
; Related .......:
; Link ..........: @@MsdnLink@@ GdipDrawArcI
; Example .......: Yes
; ===============================================================================================================================
Func _GDIPlus_GraphicsDrawArc($hGraphics, $iX, $iY, $iWidth, $iHeight, $fStartAngle, $fSweepAngle, $hPen = 0)
	__GDIPlus_PenDefCreate($hPen)
	Local $aResult = DllCall($ghGDIPDll, "int", "GdipDrawArcI", "handle", $hGraphics, "handle", $hPen, "int", $iX, "int", $iY, _
			"int", $iWidth, "int", $iHeight, "float", $fStartAngle, "float", $fSweepAngle)
	Local $tmpError = @error, $tmpExtended = @extended
	__GDIPlus_PenDefDispose()
	If $tmpError Then Return SetError($tmpError, $tmpExtended, False)
	Return $aResult[0] = 0
EndFunc   ;==>_GDIPlus_GraphicsDrawArc

; #FUNCTION# ====================================================================================================================
; Name...........: _GDIPlus_GraphicsDrawBezier
; Description ...: Draw a bezier spline
; Syntax.........: _GDIPlus_GraphicsDrawBezier($hGraphics, $iX1, $iY1, $iX2, $iY2, $iX3, $iY3, $iX4, $iY4[, $hPen = 0])
; Parameters ....: $hGraphics   - Handle to a Graphics object
;                  $hPen        - Handle to a pen object that is used to draw the arc
;                  $iX1         - X coordinate of the starting point
;                  $iY1         - Y coordinate of the starting point
;                  $iX2         - X coordinate of the first control point
;                  $iY2         - Y coordinate of the first control point
;                  $iX3         - X coordinate of the second control point
;                  $iY3         - Y coordinate of the second control point
;                  $iX4         - X coordinate of the ending point
;                  $iY4         - Y coordinate of the ending point
;                  $hPen        - Handle to a pen object that is used to draw the bezier. If 0, a solid black pen with a width of
;                  +1 will be used.
; Return values .: Success      - True
;                  Failure      - False
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost
; Remarks .......: A Bezier spline does not pass through its control points. The control points act as magnets, pulling the curve
;                  in certain directions to influence the way the spline bends.
; Related .......:
; Link ..........: @@MsdnLink@@ GdipDrawBezierI
; Example .......: Yes
; ===============================================================================================================================
Func _GDIPlus_GraphicsDrawBezier($hGraphics, $iX1, $iY1, $iX2, $iY2, $iX3, $iY3, $iX4, $iY4, $hPen = 0)
	__GDIPlus_PenDefCreate($hPen)
	Local $aResult = DllCall($ghGDIPDll, "int", "GdipDrawBezierI", "handle", $hGraphics, "handle", $hPen, "int", $iX1, "int", $iY1, _
			"int", $iX2, "int", $iY2, "int", $iX3, "int", $iY3, "int", $iX4, "int", $iY4)
	Local $tmpError = @error, $tmpExtended = @extended
	__GDIPlus_PenDefDispose()
	If $tmpError Then Return SetError($tmpError, $tmpExtended, False)
	Return $aResult[0] = 0
EndFunc   ;==>_GDIPlus_GraphicsDrawBezier

; #FUNCTION# ====================================================================================================================
; Name...........: _GDIPlus_GraphicsDrawClosedCurve
; Description ...: Draw a closed cardinal spline
; Syntax.........: _GDIPlus_GraphicsDrawClosedCurve($hGraphics, $aPoints[, $hPen = 0])
; Parameters ....: $hGraphics   - Handle to a Graphics object
;                  $aPoints     - Array that specifies the points of the curve:
;                  |[0][0] - Number of points
;                  |[1][0] - Point 1 X position
;                  |[1][1] - Point 1 Y position
;                  |[2][0] - Point 2 X position
;                  |[2][1] - Point 2 Y position
;                  |[n][0] - Point n X position
;                  |[n][1] - Point n Y position
;                  $hPen        - Handle to a pen object that is used to draw the spline. If 0, a solid black pen with a width of
;                  +1 will be used.
; Return values .: Success      - True
;                  Failure      - False
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost
; Remarks .......: In a closed cardinal spline, the curve continues through the last point in the points array and connects  with
;                  the first point in the array. The array of points must contain a minimum of three elements.
; Related .......:
; Link ..........: @@MsdnLink@@ GdipDrawClosedCurveI
; Example .......: Yes
; ===============================================================================================================================
Func _GDIPlus_GraphicsDrawClosedCurve($hGraphics, $aPoints, $hPen = 0)
	Local $iCount = $aPoints[0][0]
	Local $tPoints = DllStructCreate("long[" & $iCount * 2 & "]")
	Local $pPoints = DllStructGetPtr($tPoints)
	For $iI = 1 To $iCount
		DllStructSetData($tPoints, 1, $aPoints[$iI][0], (($iI - 1) * 2) + 1)
		DllStructSetData($tPoints, 1, $aPoints[$iI][1], (($iI - 1) * 2) + 2)
	Next

	__GDIPlus_PenDefCreate($hPen)
	Local $aResult = DllCall($ghGDIPDll, "int", "GdipDrawClosedCurveI", "handle", $hGraphics, "handle", $hPen, "ptr", $pPoints, "int", $iCount)
	Local $tmpError = @error, $tmpExtended = @extended
	__GDIPlus_PenDefDispose()
	If $tmpError Then Return SetError($tmpError, $tmpExtended, False)
	Return $aResult[0] = 0
EndFunc   ;==>_GDIPlus_GraphicsDrawClosedCurve

; #FUNCTION# ====================================================================================================================
; Name...........: _GDIPlus_GraphicsDrawCurve
; Description ...: Draw a cardinal spline
; Syntax.........: _GDIPlus_GraphicsDrawCurve($hGraphics, $aPoints[, $hPen = 0])
; Parameters ....: $hGraphics   - Handle to a Graphics object
;                  $aPoints     - Array that specifies the points of the curve:
;                  |[0][0] - Number of points
;                  |[1][0] - Point 1 X position
;                  |[1][1] - Point 1 Y position
;                  |[2][0] - Point 2 X position
;                  |[2][1] - Point 2 Y position
;                  |[n][0] - Point n X position
;                  |[n][1] - Point n Y position
;                  $hPen        - Handle to a pen object that is used to draw the spline. If 0, a solid black pen with a width of
;                  +1 will be used.
; Return values .: Success      - True
;                  Failure      - False
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost
; Remarks .......: A segment is defined as a curve that connects two consecutive points in the cardinal spline.  The ending point
;                  of each segment is the starting point for the next.
; Related .......:
; Link ..........: @@MsdnLink@@ GdipDrawCurveI
; Example .......: Yes
; ===============================================================================================================================
Func _GDIPlus_GraphicsDrawCurve($hGraphics, $aPoints, $hPen = 0)
	Local $iCount = $aPoints[0][0]
	Local $tPoints = DllStructCreate("long[" & $iCount * 2 & "]")
	Local $pPoints = DllStructGetPtr($tPoints)
	For $iI = 1 To $iCount
		DllStructSetData($tPoints, 1, $aPoints[$iI][0], (($iI - 1) * 2) + 1)
		DllStructSetData($tPoints, 1, $aPoints[$iI][1], (($iI - 1) * 2) + 2)
	Next

	__GDIPlus_PenDefCreate($hPen)
	Local $aResult = DllCall($ghGDIPDll, "int", "GdipDrawCurveI", "handle", $hGraphics, "handle", $hPen, "ptr", $pPoints, "int", $iCount)
	Local $tmpError = @error, $tmpExtended = @extended
	__GDIPlus_PenDefDispose()
	If $tmpError Then Return SetError($tmpError, $tmpExtended, False)
	Return $aResult[0] = 0
EndFunc   ;==>_GDIPlus_GraphicsDrawCurve

; #FUNCTION# ====================================================================================================================
; Name...........: _GDIPlus_GraphicsDrawEllipse
; Description ...: Draw an ellipse
; Syntax.........: _GDIPlus_GraphicsDrawEllipse($hGraphics, $iX, $iY, $iWidth, $iHeight[, $hPen = 0])
; Parameters ....: $hGraphics   - Handle to a Graphics object
;                  $iX          - The X coordinate of the upper left corner of the rectangle that bounds the ellipse
;                  $iY          - The Y coordinate of the upper left corner of the rectangle that bounds the ellipse
;                  $iWidth      - The width of the rectangle that bounds the ellipse
;                  $iHeight     - The height of the rectangle that bounds the ellipse
;                  $hPen        - Handle to a pen object that is used to draw the arc.  If 0, a solid black pen with a width of 1
;                  +will be used.
; Return values .: Success      - True
;                  Failure      - False
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost
; Remarks .......:
; Related .......:
; Link ..........: @@MsdnLink@@ GdipDrawEllipseI
; Example .......: Yes
; ===============================================================================================================================
Func _GDIPlus_GraphicsDrawEllipse($hGraphics, $iX, $iY, $iWidth, $iHeight, $hPen = 0)
	__GDIPlus_PenDefCreate($hPen)
	Local $aResult = DllCall($ghGDIPDll, "int", "GdipDrawEllipseI", "handle", $hGraphics, "handle", $hPen, "int", $iX, "int", $iY, _
			"int", $iWidth, "int", $iHeight)
	Local $tmpError = @error, $tmpExtended = @extended
	__GDIPlus_PenDefDispose()
	If $tmpError Then Return SetError($tmpError, $tmpExtended, False)
	Return $aResult[0] = 0
EndFunc   ;==>_GDIPlus_GraphicsDrawEllipse

; #FUNCTION# ====================================================================================================================
; Name...........: _GDIPlus_GraphicsDrawImage
; Description ...: Draw an Image object
; Syntax.........: _GDIPlus_GraphicsDrawImage($hGraphics, $hImage, $iX, $iY)
; Parameters ....: $hGraphics   - Handle to a Graphics object
;                  $hImage      - Handle to an Image object
;                  $iX          - The X coordinate of the upper left corner of the rendered image
;                  $iY          - The Y coordinate of the upper left corner of the rendered image
; Return values .: Success      - True
;                  Failure      - False
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost
; Remarks .......:
; Related .......:
; Link ..........: @@MsdnLink@@ GdipDrawImageI
; Example .......: Yes
; ===============================================================================================================================
Func _GDIPlus_GraphicsDrawImage($hGraphics, $hImage, $iX, $iY)
	Local $aResult = DllCall($ghGDIPDll, "int", "GdipDrawImageI", "handle", $hGraphics, "handle", $hImage, "int", $iX, "int", $iY)
	If @error Then Return SetError(@error, @extended, False)
	Return $aResult[0] = 0
EndFunc   ;==>_GDIPlus_GraphicsDrawImage

; #FUNCTION# ====================================================================================================================
; Name...........: _GDIPlus_GraphicsDrawImageRect
; Description ...: Draws an image at a specified location
; Syntax.........: _GDIPlus_GraphicsDrawImageRect($hGraphics, $hImage, $iX, $iY, $iW, $iH )
; Parameters ....: $hGraphics   - Handle to a Graphics object
;                  $hImage      - Handle to an Image object
;                  $iX          - The X coordinate of the upper left corner of the rendered image
;                  $iY          - The Y coordinate of the upper left corner of the rendered image
;                  $iW          - Specifies the width of the destination rectangle at which to draw the image
;                  $iH          - Specifies the height of the destination rectangle at which to draw the image
; Return values .: Success      - True
;                  Failure      - False
; Author ........: smashly
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........: @@MsdnLink@@ GdipDrawImageRectI
; Example .......: Yes
; ===============================================================================================================================
Func _GDIPlus_GraphicsDrawImageRect($hGraphics, $hImage, $iX, $iY, $iW, $iH)
	Local $aResult = DllCall($ghGDIPDll, "int", "GdipDrawImageRectI", "handle", $hGraphics, "handle", $hImage, "int", $iX, "int", $iY, _
			"int", $iW, "int", $iH)
	If @error Then Return SetError(@error, @extended, False)
	Return $aResult[0] = 0
EndFunc   ;==>_GDIPlus_GraphicsDrawImageRect

; #FUNCTION# ====================================================================================================================
; Name...........: _GDIPlus_GraphicsDrawImageRectRect
; Description ...: Draw an Image object
; Syntax.........: _GDIPlus_GraphicsDrawImageRectRect($hGraphics, $hImage, $iSrcX, $iSrcY, $iSrcWidth, $iSrcHeight, $iDstX, $iDstY, $iDstWidth, $iDstHeight[, $iUnit = 2])
; Parameters ....: $hGraphics   - Handle to a Graphics object
;                  $hImage      - Handle to an Image object
;                  $iSrcX       - The X coordinate of the upper left corner of the source image
;                  $iSrcY       - The Y coordinate of the upper left corner of the source image
;                  $iSrcWidth   - Width of the source image
;                  $iSrcHeight  - Height of the source image
;                  $iDstX       - The X coordinate of the upper left corner of the destination image
;                  $iDstY       - The Y coordinate of the upper left corner of the destination image
;                  $iDstWidth   - Width of the destination image
;                  $iDstHeight  - Height of the destination image
;                  $iUnit       - Specifies the unit of measure for the image
; Return values .: Success      - True
;                  Failure      - False
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost
; Remarks .......:
; Related .......:
; Link ..........: @@MsdnLink@@ GdipDrawImageRectRectI
; Example .......: Yes
; ===============================================================================================================================
Func _GDIPlus_GraphicsDrawImageRectRect($hGraphics, $hImage, $iSrcX, $iSrcY, $iSrcWidth, $iSrcHeight, $iDstX, $iDstY, $iDstWidth, $iDstHeight, $iUnit = 2)
	Local $aResult = DllCall($ghGDIPDll, "int", "GdipDrawImageRectRectI", "handle", $hGraphics, "handle", $hImage, "int", $iDstX, _
			"int", $iDstY, "int", $iDstWidth, "int", $iDstHeight, "int", $iSrcX, "int", $iSrcY, "int", $iSrcWidth, _
			"int", $iSrcHeight, "int", $iUnit, "int", 0, "int", 0, "int", 0)
	If @error Then Return SetError(@error, @extended, False)
	Return $aResult[0] = 0
EndFunc   ;==>_GDIPlus_GraphicsDrawImageRectRect

; #FUNCTION# ====================================================================================================================
; Name...........: _GDIPlus_GraphicsDrawLine
; Description ...: Draw a line
; Syntax.........: _GDIPlus_GraphicsDrawLine($hGraphics, $iX1, $iY1, $iX2, $iY2[, $hPen = 0])
; Parameters ....: $hGraphics   - Handle to a Graphics object
;                  $iX1         - The X coordinate of the starting point of the line
;                  $iY1         - The Y coordinate of the starting point of the line
;                  $iX2         - The X coordinate of the ending point of the line
;                  $iY2         - The Y coordinate of the ending point of the line
;                  $hPen        - Handle to a pen object that is used to draw the arc.  If 0, a solid black pen with a width of 1
;                  +will be used.
; Return values .: Success      - True
;                  Failure      - False
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost
; Remarks .......:
; Related .......:
; Link ..........: @@MsdnLink@@ GdipDrawLineI
; Example .......: Yes
; ===============================================================================================================================
Func _GDIPlus_GraphicsDrawLine($hGraphics, $iX1, $iY1, $iX2, $iY2, $hPen = 0)
	__GDIPlus_PenDefCreate($hPen)
	Local $aResult = DllCall($ghGDIPDll, "int", "GdipDrawLineI", "handle", $hGraphics, "handle", $hPen, "int", $iX1, "int", $iY1, _
			"int", $iX2, "int", $iY2)
	Local $tmpError = @error, $tmpExtended = @extended
	__GDIPlus_PenDefDispose()
	If $tmpError Then Return SetError($tmpError, $tmpExtended, False)
	Return $aResult[0] = 0
EndFunc   ;==>_GDIPlus_GraphicsDrawLine

; #FUNCTION# ====================================================================================================================
; Name...........: _GDIPlus_GraphicsDrawPie
; Description ...: Draw a pie
; Syntax.........: _GDIPlus_GraphicsDrawPie($hGraphics, $iX, $iY, $iWidth, $iHeight, $fStartAngle, $fSweepAngle[, $hPen = 0])
; Parameters ....: $hGraphics   - Handle to a Graphics object
;                  $iX          - The X coordinate of the upper left corner of the rectangle that bounds the ellipse in which  to
;                  +draw the pie
;                  $iY          - The Y coordinate of the upper left corner of the rectangle that bounds the ellipse in which  to
;                  +draw the pie
;                  $iWidth      - The width of the rectangle that bounds the ellipse in which to draw the pie
;                  $iHeight     - The height of the rectangle that bounds the ellipse in which to draw the pie
;                  $fStartAngle - The angle, in degrees, between the X axis and the starting point of the arc  that  defines  the
;                  +pie. A positive value specifies clockwise rotation.
;                  $fSweepAngle - The angle, in degrees, between the starting and ending points of the arc that defines the  pie.
;                  +A positive value specifies clockwise rotation.
;                  $hPen        - Handle to a pen object that is used to draw the arc.  If 0, a solid black pen with a width of 1
;                  +will be used.
; Return values .: Success      - True
;                  Failure      - False
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost
; Remarks .......:
; Related .......:
; Link ..........: @@MsdnLink@@ GdipDrawPieI
; Example .......: Yes
; ===============================================================================================================================
Func _GDIPlus_GraphicsDrawPie($hGraphics, $iX, $iY, $iWidth, $iHeight, $fStartAngle, $fSweepAngle, $hPen = 0)
	__GDIPlus_PenDefCreate($hPen)
	Local $aResult = DllCall($ghGDIPDll, "int", "GdipDrawPieI", "handle", $hGraphics, "handle", $hPen, "int", $iX, "int", $iY, _
			"int", $iWidth, "int", $iHeight, "float", $fStartAngle, "float", $fSweepAngle)
	Local $tmpError = @error, $tmpExtended = @extended
	__GDIPlus_PenDefDispose()
	If $tmpError Then Return SetError($tmpError, $tmpExtended, False)
	Return $aResult[0] = 0
EndFunc   ;==>_GDIPlus_GraphicsDrawPie

; #FUNCTION# ====================================================================================================================
; Name...........: _GDIPlus_GraphicsDrawPolygon
; Description ...: Draw a polygon
; Syntax.........: _GDIPlus_GraphicsDrawPolygon($hGraphics, $aPoints[, $hPen = 0])
; Parameters ....: $hGraphics   - Handle to a Graphics object
;                  $aPoints     - Array that specify the vertices of the polygon:
;                  |[0][0] - Number of vertices
;                  |[1][0] - Vertice 1 X position
;                  |[1][1] - Vertice 1 Y position
;                  |[2][0] - Vertice 2 X position
;                  |[2][1] - Vertice 2 Y position
;                  |[n][0] - Vertice n X position
;                  |[n][1] - Vertice n Y position
;                  $hPen        - Handle to a pen object that is used to draw the polygon.  If 0, a solid black pen with a  width
;                  +of 1 will be used.
; Return values .: Success      - True
;                  Failure      - False
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost
; Remarks .......: If the first and last points are not identical, a line is drawn between them to close the polygon
; Related .......:
; Link ..........: @@MsdnLink@@ GdipDrawPolygonI
; Example .......: Yes
; ===============================================================================================================================
Func _GDIPlus_GraphicsDrawPolygon($hGraphics, $aPoints, $hPen = 0)
	Local $iCount = $aPoints[0][0]
	Local $tPoints = DllStructCreate("long[" & $iCount * 2 & "]")
	Local $pPoints = DllStructGetPtr($tPoints)
	For $iI = 1 To $iCount
		DllStructSetData($tPoints, 1, $aPoints[$iI][0], (($iI - 1) * 2) + 1)
		DllStructSetData($tPoints, 1, $aPoints[$iI][1], (($iI - 1) * 2) + 2)
	Next

	__GDIPlus_PenDefCreate($hPen)
	Local $aResult = DllCall($ghGDIPDll, "int", "GdipDrawPolygonI", "handle", $hGraphics, "handle", $hPen, "ptr", $pPoints, "int", $iCount)
	Local $tmpError = @error, $tmpExtended = @extended
	__GDIPlus_PenDefDispose()
	If $tmpError Then Return SetError($tmpError, $tmpExtended, False)
	Return $aResult[0] = 0
EndFunc   ;==>_GDIPlus_GraphicsDrawPolygon

; #FUNCTION# ====================================================================================================================
; Name...........: _GDIPlus_GraphicsDrawRect
; Description ...: Draw a rectangle
; Syntax.........: _GDIPlus_GraphicsDrawRect($hGraphics, $iX, $iY, $iWidth, $iHeight[, $hPen = 0])
; Parameters ....: $hGraphics   - Handle to a Graphics object
;                  $iX          - The X coordinate of the upper left corner of the rectangle
;                  $iY          - The Y coordinate of the upper left corner of the rectangle
;                  $iWidth      - The width of the rectangle
;                  $iHeight     - The height of the rectangle
;                  $hPen        - Handle to a pen object that is used to draw the rectangle. If 0, a solid black pen with a width
;                  +of 1 will be used
; Return values .: Success      - True
;                  Failure      - False
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost
; Remarks .......:
; Related .......:
; Link ..........: @@MsdnLink@@ GdipDrawRectangleI
; Example .......: Yes
; ===============================================================================================================================
Func _GDIPlus_GraphicsDrawRect($hGraphics, $iX, $iY, $iWidth, $iHeight, $hPen = 0)
	__GDIPlus_PenDefCreate($hPen)
	Local $aResult = DllCall($ghGDIPDll, "int", "GdipDrawRectangleI", "handle", $hGraphics, "handle", $hPen, "int", $iX, "int", $iY, _
			"int", $iWidth, "int", $iHeight)
	Local $tmpError = @error, $tmpExtended = @extended
	__GDIPlus_PenDefDispose()
	If $tmpError Then Return SetError($tmpError, $tmpExtended, False)
	Return $aResult[0] = 0
EndFunc   ;==>_GDIPlus_GraphicsDrawRect

; #FUNCTION# ====================================================================================================================
; Name...........: _GDIPlus_GraphicsDrawString
; Description ...: Draw a string
; Syntax.........: _GDIPlus_GraphicsDrawString($hGraphics, $sString, $nX, $nY[, $sFont = "Arial"[, $nSize = 10[, $iFormat = 0]]])
; Parameters ....: $hGraphics   - Handle to a Graphics object
;                  $sString     - String to be drawn
;                  $nX          - X coordinate where the string will be drawn
;                  $nY          - Y coordinate where the string will be drawn
;                  $sFont       - Name of the font to use for drawing
;                  $nSize       - Font size to use for drawing
;                  $iFormat     - Format flags. Can be one or more of the following:
;                  |0x0001 - Specifies that reading order is right to left
;                  |0x0002 - Specifies that individual lines of text are drawn vertically on the display device
;                  |0x0004 - Specifies that parts of characters are allowed to overhang the string's layout rectangle
;                  |0x0020 - Specifies that Unicode layout control characters are displayed with a representative character
;                  |0x0400 - Specifies that an alternate font is used for characters that are not supported in the requested font
;                  |0x0800 - Specifies that the space at the end of each line is included in a string measurement
;                  |0x1000 - Specifies that the wrapping of text to the next line is disabled
;                  |0x2000 - Specifies that only entire lines are laid out in the layout rectangle
;                  |0x4000 - Specifies that characters overhanging the layout rectangle and text  extending  outside  the  layout
;                  +rectangle are allowed to show
; Return values .: Success      - True
;                  Failure      - False
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; Remarks .......:
; Related .......: _GDIPlus_GraphicsDrawStringEx
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _GDIPlus_GraphicsDrawString($hGraphics, $sString, $nX, $nY, $sFont = "Arial", $nSize = 10, $iFormat = 0)
	Local $hBrush = _GDIPlus_BrushCreateSolid()
	Local $hFormat = _GDIPlus_StringFormatCreate($iFormat)
	Local $hFamily = _GDIPlus_FontFamilyCreate($sFont)
	Local $hFont = _GDIPlus_FontCreate($hFamily, $nSize)
	Local $tLayout = _GDIPlus_RectFCreate($nX, $nY, 0, 0)
	Local $aInfo = _GDIPlus_GraphicsMeasureString($hGraphics, $sString, $hFont, $tLayout, $hFormat)
	Local $aResult = _GDIPlus_GraphicsDrawStringEx($hGraphics, $sString, $hFont, $aInfo[0], $hFormat, $hBrush)
	Local $iError = @error
	_GDIPlus_FontDispose($hFont)
	_GDIPlus_FontFamilyDispose($hFamily)
	_GDIPlus_StringFormatDispose($hFormat)
	_GDIPlus_BrushDispose($hBrush)
	Return SetError($iError, 0, $aResult)
EndFunc   ;==>_GDIPlus_GraphicsDrawString

; #FUNCTION# ====================================================================================================================
; Name...........: _GDIPlus_GraphicsDrawStringEx
; Description ...: Draw a string
; Syntax.........: _GDIPlus_GraphicsDrawStringEx($hGraphics, $sString, $hFont, $tLayout, $hFormat, $hBrush)
; Parameters ....: $hGraphics   - Handle to a Graphics object
;                  $sString     - String to be drawn
;                  $hFont       - Handle to the font to use to draw the string
;                  $tLayout     - $tagGDIPRECTF structure that bounds the string
;                  $hFormat     - Handle to the string format to draw the string
;                  $hBrush      - Handle to the brush to draw the string
; Return values .: Success      - True
;                  Failure      - False
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost
; Remarks .......:
; Related .......: _GDIPlus_GraphicsDrawString, $tagGDIPRECTF
; Link ..........: @@MsdnLink@@ GdipDrawString
; Example .......: Yes
; ===============================================================================================================================
Func _GDIPlus_GraphicsDrawStringEx($hGraphics, $sString, $hFont, $tLayout, $hFormat, $hBrush)
	Local $pLayout = DllStructGetPtr($tLayout)
	Local $aResult = DllCall($ghGDIPDll, "int", "GdipDrawString", "handle", $hGraphics, "wstr", $sString, "int", -1, "handle", $hFont, _
			"ptr", $pLayout, "handle", $hFormat, "handle", $hBrush)
	If @error Then Return SetError(@error, @extended, False)
	Return $aResult[0] = 0
EndFunc   ;==>_GDIPlus_GraphicsDrawStringEx

; #FUNCTION# ====================================================================================================================
; Name...........: _GDIPlus_GraphicsFillClosedCurve
; Description ...: Fill a closed cardinal spline
; Syntax.........: _GDIPlus_GraphicsFillClosedCurve($hGraphics, $aPoints[, $hBrush = 0])
; Parameters ....: $hGraphics   - Handle to a Graphics object
;                  $aPoints     - Array that specifies the points of the curve:
;                  |[0][0] - Number of points
;                  |[1][0] - Point 1 X position
;                  |[1][1] - Point 1 Y position
;                  |[2][0] - Point 2 X position
;                  |[2][1] - Point 2 Y position
;                  |[n][0] - Point n X position
;                  |[n][1] - Point n Y position
;                  $hBrush      - Handle to a brush object that is used to fill the ellipse. If 0, a black brush will be used.
; Return values .: Success      - True
;                  Failure      - False
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost
; Remarks .......: In a closed cardinal spline, the curve continues through the last point in the points array and connects  with
;                  the first point in the array. The array of points must contain a minimum of three elements.
; Related .......:
; Link ..........: @@MsdnLink@@ GdipFillClosedCurveI
; Example .......: Yes
; ===============================================================================================================================
Func _GDIPlus_GraphicsFillClosedCurve($hGraphics, $aPoints, $hBrush = 0)
	Local $iCount = $aPoints[0][0]
	Local $tPoints = DllStructCreate("long[" & $iCount * 2 & "]")
	Local $pPoints = DllStructGetPtr($tPoints)
	For $iI = 1 To $iCount
		DllStructSetData($tPoints, 1, $aPoints[$iI][0], (($iI - 1) * 2) + 1)
		DllStructSetData($tPoints, 1, $aPoints[$iI][1], (($iI - 1) * 2) + 2)
	Next

	__GDIPlus_BrushDefCreate($hBrush)
	Local $aResult = DllCall($ghGDIPDll, "int", "GdipFillClosedCurveI", "handle", $hGraphics, "handle", $hBrush, "ptr", $pPoints, "int", $iCount)
	Local $tmpError = @error, $tmpExtended = @extended
	__GDIPlus_BrushDefDispose()
	If $tmpError Then Return SetError($tmpError, $tmpExtended, False)
	Return $aResult[0] = 0
EndFunc   ;==>_GDIPlus_GraphicsFillClosedCurve

; #FUNCTION# ====================================================================================================================
; Name...........: _GDIPlus_GraphicsFillEllipse
; Description ...: Fill an ellipse
; Syntax.........: _GDIPlus_GraphicsFillEllipse($hGraphics, $iX, $iY, $iWidth, $iHeight[, $hBrush = 0])
; Parameters ....: $hGraphics   - Handle to a Graphics object
;                  $iX          - The X coordinate of the upper left corner of the rectangle that bounds the ellipse
;                  $iY          - The Y coordinate of the upper left corner of the rectangle that bounds the ellipse
;                  $iWidth      - The width of the rectangle that bounds the ellipse
;                  $iHeight     - The height of the rectangle that bounds the ellipse
;                  $hBrush      - Handle to a brush object that is used to fill the ellipse. If 0, a black brush will be used.
; Return values .: Success      - True
;                  Failure      - False
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost
; Remarks .......:
; Related .......:
; Link ..........: @@MsdnLink@@ GdipFillEllipseI
; Example .......: Yes
; ===============================================================================================================================
Func _GDIPlus_GraphicsFillEllipse($hGraphics, $iX, $iY, $iWidth, $iHeight, $hBrush = 0)
	__GDIPlus_BrushDefCreate($hBrush)
	Local $aResult = DllCall($ghGDIPDll, "int", "GdipFillEllipseI", "handle", $hGraphics, "handle", $hBrush, "int", $iX, "int", $iY, _
			"int", $iWidth, "int", $iHeight)
	Local $tmpError = @error, $tmpExtended = @extended
	__GDIPlus_BrushDefDispose()
	If $tmpError Then Return SetError($tmpError, $tmpExtended, False)
	Return $aResult[0] = 0
EndFunc   ;==>_GDIPlus_GraphicsFillEllipse

; #FUNCTION# ====================================================================================================================
; Name...........: _GDIPlus_GraphicsFillPie
; Description ...: Fill a pie
; Syntax.........: _GDIPlus_GraphicsFillPie($hGraphics, $iX, $iY, $iWidth, $iHeight, $fStartAngle, $fSweepAngle[, $hBrush = 0])
; Parameters ....: $hGraphics   - Handle to a Graphics object
;                  $iX          - The X coordinate of the upper left corner of the rectangle that bounds the ellipse in which  to
;                  +draw the pie
;                  $iY          - The Y coordinate of the upper left corner of the rectangle that bounds the ellipse in which  to
;                  +draw the pie
;                  $iWidth      - The width of the rectangle that bounds the ellipse in which to draw the pie
;                  $iHeight     - The height of the rectangle that bounds the ellipse in which to draw the pie
;                  $fStartAngle - The angle, in degrees, between the X axis and the starting point of the arc  that  defines  the
;                  +pie. A positive value specifies clockwise rotation.
;                  $fSweepAngle - The angle, in degrees, between the starting and ending points of the arc that defines the  pie.
;                  +A positive value specifies clockwise rotation.
;                  $hBrush      - Handle to a brush object that is used to fill the pie. If 0, a black brush will be used.
; Return values .: Success      - True
;                  Failure      - False
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost
; Remarks .......:
; Related .......:
; Link ..........: @@MsdnLink@@ GdipFillPieI
; Example .......: Yes
; ===============================================================================================================================
Func _GDIPlus_GraphicsFillPie($hGraphics, $iX, $iY, $iWidth, $iHeight, $fStartAngle, $fSweepAngle, $hBrush = 0)
	__GDIPlus_BrushDefCreate($hBrush)
	Local $aResult = DllCall($ghGDIPDll, "int", "GdipFillPieI", "handle", $hGraphics, "handle", $hBrush, "int", $iX, "int", $iY, _
			"int", $iWidth, "int", $iHeight, "float", $fStartAngle, "float", $fSweepAngle)
	Local $tmpError = @error, $tmpExtended = @extended
	__GDIPlus_BrushDefDispose()
	If $tmpError Then Return SetError($tmpError, $tmpExtended, False)
	Return $aResult[0] = 0
EndFunc   ;==>_GDIPlus_GraphicsFillPie

; #FUNCTION# ====================================================================================================================
; Name...........: _GDIPlus_GraphicsFillPolygon
; Description ...: Fill a polygon
; Syntax.........: _GDIPlus_GraphicsFillPolygon($hGraphics, $aPoints[, $hBrush = 0])
; Parameters ....: $hGraphics   - Handle to a Graphics object
;                  $aPoints     - Array that specify the vertices of the polygon:
;                  |[0][0] - Number of vertices
;                  |[1][0] - Vertice 1 X position
;                  |[1][1] - Vertice 1 Y position
;                  |[2][0] - Vertice 2 X position
;                  |[2][1] - Vertice 2 Y position
;                  |[n][0] - Vertice n X position
;                  |[n][1] - Vertice n Y position
;                  $hBrush      - Handle to a brush object that is used to fill the polygon.
;                               - If $hBrush is 0, a solid black brush is used.
; Return values .: Success      - True
;                  Failure      - False
; Author ........:
; Modified.......: smashly
; Remarks .......:
; Related .......:
; Link ..........: @@MsdnLink@@ GdipFillPolygonI
; Example .......: Yes
; ===============================================================================================================================
Func _GDIPlus_GraphicsFillPolygon($hGraphics, $aPoints, $hBrush = 0)
	Local $iCount = $aPoints[0][0]
	Local $tPoints = DllStructCreate("long[" & $iCount * 2 & "]")
	Local $pPoints = DllStructGetPtr($tPoints)
	For $iI = 1 To $iCount
		DllStructSetData($tPoints, 1, $aPoints[$iI][0], (($iI - 1) * 2) + 1)
		DllStructSetData($tPoints, 1, $aPoints[$iI][1], (($iI - 1) * 2) + 2)
	Next

	__GDIPlus_BrushDefCreate($hBrush)
	Local $aResult = DllCall($ghGDIPDll, "int", "GdipFillPolygonI", "handle", $hGraphics, "handle", $hBrush, _
			"ptr", $pPoints, "int", $iCount, "int", "FillModeAlternate")
	Local $tmpError = @error, $tmpExtended = @extended
	__GDIPlus_BrushDefDispose()
	If $tmpError Then Return SetError($tmpError, $tmpExtended, False)
	Return $aResult[0] = 0
EndFunc   ;==>_GDIPlus_GraphicsFillPolygon

; #FUNCTION# ====================================================================================================================
; Name...........: _GDIPlus_GraphicsFillRect
; Description ...: Fill a rectangle
; Syntax.........: _GDIPlus_GraphicsFillRect($hGraphics, $iX, $iY, $iWidth, $iHeight[, $hBrush = 0])
; Parameters ....: $hGraphics   - Handle to a Graphics object
;                  $iX          - The X coordinate of the upper left corner of the rectangle
;                  $iY          - The Y coordinate of the upper left corner of the rectangle
;                  $iWidth      - The width of the rectangle
;                  $iHeight     - The height of the rectangle
;                  $hBrush      - Handle to a brush object that is used to fill the rectangle. If 0, a black brush will be used.
; Return values .: Success      - True
;                  Failure      - False
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost
; Remarks .......:
; Related .......:
; Link ..........: @@MsdnLink@@ GdipFillRectangleI
; Example .......: Yes
; ===============================================================================================================================
Func _GDIPlus_GraphicsFillRect($hGraphics, $iX, $iY, $iWidth, $iHeight, $hBrush = 0)
	__GDIPlus_BrushDefCreate($hBrush)
	Local $aResult = DllCall($ghGDIPDll, "int", "GdipFillRectangleI", "handle", $hGraphics, "handle", $hBrush, "int", $iX, "int", $iY, _
			"int", $iWidth, "int", $iHeight)
	Local $tmpError = @error, $tmpExtended = @extended
	__GDIPlus_BrushDefDispose()
	If $tmpError Then Return SetError($tmpError, $tmpExtended, False)
	Return $aResult[0] = 0
EndFunc   ;==>_GDIPlus_GraphicsFillRect

; #FUNCTION# ====================================================================================================================
; Name...........: _GDIPlus_GraphicsGetDC
; Description ...: Gets a handle to the device context of the Graphics object
; Syntax.........: _GDIPlus_GraphicsGetDC($hGraphics)
; Parameters ....: $hGraphics   - Handle to a Graphics object
; Return values .: Success      - DC of the Graphics object
;                  Failure      - 0
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost
; Remarks .......: Each call to the _GDIPlus_GraphicsGetDC should be paired with a call to the _GDIPlus_GraphicsReleaseDC.  Do not call
;                  any methods of the Graphics object between the calls.
; Related .......: _GDIPlus_GraphicsReleaseDC
; Link ..........: @@MsdnLink@@ GdipGetDC
; Example .......:
; ===============================================================================================================================
Func _GDIPlus_GraphicsGetDC($hGraphics)
	Local $aResult = DllCall($ghGDIPDll, "int", "GdipGetDC", "handle", $hGraphics, "ptr*", 0)
	If @error Then Return SetError(@error, @extended, False)
	__GDIPlus_ObjectDispose_ListAdd($aResult[2], "DC")
	Return SetExtended($aResult[0], $aResult[2])
EndFunc   ;==>_GDIPlus_GraphicsGetDC

; #FUNCTION# ====================================================================================================================
; Name...........: _GDIPlus_GraphicsGetSmoothingMode
; Description ...: Gets the graphics object rendering quality
; Syntax.........: _GDIPlus_GraphicsGetSmoothingMode($hGraphics)
; Parameters ....: $hGraphics   - Handle to a Graphics object
; Return values .: Success      - Smoothing mode. Can be one of the following:
;                  |0 - Smoothing is not applied
;                  |1 - Smoothing is applied using an 8 X 4 box filter
;                  |2 - Smoothing is applied using an 8 X 8 box filter
;                  Failure      - -1 and @error is set
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost
; Remarks .......:
; Related .......: _GDIPlus_GraphicsSetSmoothingMode
; Link ..........: @@MsdnLink@@ GdipGetSmoothingMode
; Example .......:
; ===============================================================================================================================
Func _GDIPlus_GraphicsGetSmoothingMode($hGraphics)
	Local $aResult = DllCall($ghGDIPDll, "int", "GdipGetSmoothingMode", "handle", $hGraphics, "int*", 0)
	If @error Then Return SetError(@error, @extended, -1)
	Switch $aResult[2]
		Case 3
			Return SetExtended($aResult[0], 1)
		Case 7
			Return SetExtended($aResult[0], 2)
		Case Else
			Return SetExtended($aResult[0], 0)
	EndSwitch
EndFunc   ;==>_GDIPlus_GraphicsGetSmoothingMode

; #FUNCTION# ====================================================================================================================
; Name...........: _GDIPlus_GraphicsMeasureString
; Description ...: Measures the size of a string
; Syntax.........: _GDIPlus_GraphicsMeasureString($hGraphics, $sString, $hFont, $tLayout, $hFormat)
; Parameters ....: $hGraphics   - Handle to a Graphics object
;                  $sString     - String to be drawn
;                  $hFont       - Handle to the font to use to draw the string
;                  $tLayout     - $tagGDIPRECTF structure that bounds the string
;                  $hFormat     - Handle to the string format to draw the string
; Return values .: Success      - Array with the following format
;                  |[0] - $tagGDIPRECTF structure that receives the rectangle that bounds the string
;                  |[1] - The number of characters that actually fit into the layout rectangle
;                  |[2] - The number of lines that fit into the layout rectangle
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost
; Remarks .......:
; Related .......: $tagGDIPRECTF
; Link ..........: @@MsdnLink@@ GdipMeasureString
; Example .......: Yes
; ===============================================================================================================================
Func _GDIPlus_GraphicsMeasureString($hGraphics, $sString, $hFont, $tLayout, $hFormat)
	Local $pLayout = DllStructGetPtr($tLayout)
	Local $tRectF = DllStructCreate($tagGDIPRECTF)
	Local $pRectF = DllStructGetPtr($tRectF)
	Local $aResult = DllCall($ghGDIPDll, "int", "GdipMeasureString", "handle", $hGraphics, "wstr", $sString, "int", -1, "handle", $hFont, _
			"ptr", $pLayout, "handle", $hFormat, "ptr", $pRectF, "int*", 0, "int*", 0)
	If @error Then Return SetError(@error, @extended, 0)

	Local $aInfo[3]
	$aInfo[0] = $tRectF
	$aInfo[1] = $aResult[8]
	$aInfo[2] = $aResult[9]
	Return SetExtended($aResult[0], $aInfo)
EndFunc   ;==>_GDIPlus_GraphicsMeasureString

; #FUNCTION# ====================================================================================================================
; Name...........: _GDIPlus_GraphicsReleaseDC
; Description ...: Releases the device context of the Graphics object
; Syntax.........: _GDIPlus_GraphicsReleaseDC($hGraphics, $hDC)
; Parameters ....: $hGraphics   - Handle to a Graphics object
;                  $hDC         - Handle to the Graphics device context
; Return values .: Success      - True
;                  Failure      - False
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost
; Remarks .......:
; Related .......: _GDIPlus_GraphicsGetDC
; Link ..........: @@MsdnLink@@ GdipReleaseDC
; Example .......:
; ===============================================================================================================================
Func _GDIPlus_GraphicsReleaseDC($hGraphics, $hDC)
	Local $aResult = DllCall($ghGDIPDll, "int", "GdipReleaseDC", "handle", $hGraphics, "handle", $hDC)
	If @error Then Return SetError(@error, @extended, False)
	__GDIPlus_ObjectDispose_ListRemove($hDC, "DC")
	Return SetExtended($aResult[0], $aResult[2])
EndFunc   ;==>_GDIPlus_GraphicsReleaseDC

; #FUNCTION# ====================================================================================================================
; Name...........: _GDIPlus_GraphicsSetTransform
; Description ...: Sets the world transformation for a graphics object
; Syntax.........: _GDIPlus_GraphicsSetTransform($hGraphics, $hMatrix)
; Parameters ....: $hGraphics   - Handle to a Graphics object
;                  $hMatrix     - Handle to a Matrix object that specifies the world transformation
; Return values .: Success      - True
;                  Failure      - False
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost
; Remarks .......:
; Related .......:
; Link ..........: @@MsdnLink@@ GdipSetWorldTransform
; Example .......: Yes
; ===============================================================================================================================
Func _GDIPlus_GraphicsSetTransform($hGraphics, $hMatrix)
	Local $aResult = DllCall($ghGDIPDll, "int", "GdipSetWorldTransform", "handle", $hGraphics, "handle", $hMatrix)
	If @error Then Return SetError(@error, @extended, False)
	Return $aResult[0] = 0
EndFunc   ;==>_GDIPlus_GraphicsSetTransform

; #FUNCTION# ====================================================================================================================
; Name...........: _GDIPlus_GraphicsSetSmoothingMode
; Description ...: Sets the graphics object rendering quality
; Syntax.........: _GDIPlus_GraphicsSetSmoothingMode($hGraphics, $iSmooth)
; Parameters ....: $hGraphics   - Handle to a Graphics object
;                  $iSmooth     - Smoothing mode:
;                  |0 - Smoothing is not applied
;                  |1 - Smoothing is applied using an 8 X 4 box filter
;                  |2 - Smoothing is applied using an 8 X 8 box filter
; Return values .: Success      - True
;                  Failure      - False
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost
; Remarks .......:
; Related .......: _GDIPlus_GraphicsGetSmoothingMode
; Link ..........: @@MsdnLink@@ GdipSetSmoothingMode
; Example .......:
; ===============================================================================================================================
Func _GDIPlus_GraphicsSetSmoothingMode($hGraphics, $iSmooth)
	If $iSmooth < 0 Or $iSmooth > 4 Then $iSmooth = 0
	Local $aResult = DllCall($ghGDIPDll, "int", "GdipSetSmoothingMode", "handle", $hGraphics, "int", $iSmooth)
	If @error Then Return SetError(@error, @extended, False)
	Return $aResult[0] = 0
EndFunc   ;==>_GDIPlus_GraphicsSetSmoothingMode

; #FUNCTION# ====================================================================================================================
; Name...........: _GDIPlus_ImageDispose
; Description ...: Release an image object
; Syntax.........: _GDIPlus_ImageDispose($hImage)
; Parameters ....: $hImage      - Handle to an image object
; Return values .: Success      - True
;                  Failure      - False
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost
; Remarks .......:
; Related .......:
; Link ..........: @@MsdnLink@@ GdipDisposeImage
; Example .......: Yes
; ===============================================================================================================================
Func _GDIPlus_ImageDispose($hImage)
	Local $aResult = DllCall($ghGDIPDll, "int", "GdipDisposeImage", "handle", $hImage)
	If @error Then Return SetError(@error, @extended, False)
	__GDIPlus_ObjectDispose_ListRemove($hImage, "Image")
	Return $aResult[0] = 0
EndFunc   ;==>_GDIPlus_ImageDispose

; #FUNCTION# ====================================================================================================================
; Name...........: _GDIPlus_ImageGetFlags
; Description ...: Returns enumeration of pixel data attributes contained in an image
; Syntax.........: _GDIPlus_ImageGetFlags($hImage)
; Parameters ....: $hImage - Handle to an image object
; Return values .: Success - Array with the following format
;                  |[0] -  - Integer flag set of pixel data attributes
;                  |[1] -  - String of pixel data attributes separated by delimiter "|"
;                  Failure - Returns empty array and @error is set, @extended set to error location
;                  |0 - No error.
;                  |4 - Invalid image handle
; Author ........: rover
; Modified.......:
; Remarks .......: @error 4 relies on GDI+ UDF return of -1 or 0 instead of image handle for errors
;                  Use BitAND on returned integer flag set with GdipGetImageFlags constants
; Related .......: _GDIPlus_ImageGetPixelFormat
; Link ..........: @@MsdnLink@@ GdipGetImageFlags
; Example .......: Yes
; ===============================================================================================================================
Func _GDIPlus_ImageGetFlags($hImage)
	Local $aFlag[2] = [0, ""]
	If ($hImage = -1) Or (Not $hImage) Then Return SetError(10, 1, $aFlag)
	Local $aImageFlags[13][2] = _
			[["Pixel data Cacheable", $GDIP_IMAGEFLAGS_CACHING], _
			["Pixel data read-only", $GDIP_IMAGEFLAGS_READONLY], _
			["Pixel size in image", $GDIP_IMAGEFLAGS_HASREALPIXELSIZE], _
			["DPI info in image", $GDIP_IMAGEFLAGS_HASREALDPI], _
			["YCCK color space", $GDIP_IMAGEFLAGS_COLORSPACE_YCCK], _
			["YCBCR color space", $GDIP_IMAGEFLAGS_COLORSPACE_YCBCR], _
			["Grayscale image", $GDIP_IMAGEFLAGS_COLORSPACE_GRAY], _
			["CMYK color space", $GDIP_IMAGEFLAGS_COLORSPACE_CMYK], _
			["RGB color space", $GDIP_IMAGEFLAGS_COLORSPACE_RGB], _
			["Partially scalable", $GDIP_IMAGEFLAGS_PARTIALLYSCALABLE], _
			["Alpha values other than 0 (transparent) and 255 (opaque)", $GDIP_IMAGEFLAGS_HASTRANSLUCENT], _
			["Alpha values", $GDIP_IMAGEFLAGS_HASALPHA], _
			["Scalable", $GDIP_IMAGEFLAGS_SCALABLE]]
	Local $aResult = DllCall($ghGDIPDll, "int", "GdipGetImageFlags", "handle", $hImage, "long*", 0)
	If @error Then Return SetError(@error, 2, $aFlag)
	If $aResult[2] = $GDIP_IMAGEFLAGS_NONE Then
		$aFlag[1] = "No pixel data"
		Return SetError($aResult[0], 3, $aFlag)
	EndIf
	$aFlag[0] = $aResult[2]
	For $i = 0 To 12
		If BitAND($aResult[2], $aImageFlags[$i][1]) = $aImageFlags[$i][1] Then
			If StringLen($aFlag[1]) Then $aFlag[1] &= "|"
			$aResult[2] -= $aImageFlags[$i][1]
			$aFlag[1] &= $aImageFlags[$i][0]
		EndIf
	Next
	Return SetExtended($aResult[0], $aFlag)
EndFunc   ;==>_GDIPlus_ImageGetFlags

; #FUNCTION# ====================================================================================================================
; Name...........: _GDIPlus_ImageGetGraphicsContext
; Description ...: Get the graphics context of the image
; Syntax.........: _GDIPlus_ImageGetGraphicsContext($hImage)
; Parameters ....: $hImage      - Handle to an image object
; Return values .: Success      - Handle to a Graphics object
;                  Failure      - -1 and @error is set
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost
; Remarks .......:
; Related .......:
; Link ..........: @@MsdnLink@@ GdipGetImageGraphicsContext
; Example .......: Yes
; ===============================================================================================================================
Func _GDIPlus_ImageGetGraphicsContext($hImage)
	Local $aResult = DllCall($ghGDIPDll, "int", "GdipGetImageGraphicsContext", "handle", $hImage, "ptr*", 0)
	If @error Then Return SetError(@error, @extended, -1)
	Return SetExtended($aResult[0], $aResult[2])
EndFunc   ;==>_GDIPlus_ImageGetGraphicsContext

; #FUNCTION# ====================================================================================================================
; Name...........: _GDIPlus_ImageGetHeight
; Description ...: Get the image height
; Syntax.........: _GDIPlus_ImageGetHeight($hImage)
; Parameters ....: $hImage      - Handle to an image object
; Return values .: Success      - Image height, in pixels
;                  Failure      - -1 and @error is set
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost
; Remarks .......:
; Related .......: _GDIPlus_ImageGetWidth
; Link ..........: @@MsdnLink@@ GdipGetImageHeight
; Example .......: Yes
; ===============================================================================================================================
Func _GDIPlus_ImageGetHeight($hImage)
	Local $aResult = DllCall($ghGDIPDll, "int", "GdipGetImageHeight", "handle", $hImage, "uint*", 0)
	If @error Then Return SetError(@error, @extended, -1)
	Return SetExtended($aResult[0], $aResult[2])
EndFunc   ;==>_GDIPlus_ImageGetHeight

; #FUNCTION# ====================================================================================================================
; Name...........: _GDIPlus_ImageGetHorizontalResolution
; Description ...: Returns horizontal resolution in DPI (pixels per inch) of an image
; Syntax.........: _GDIPlus_ImageGetHorizontalResolution($hImage)
; Parameters ....: $hImage - Handle to an image object
; Return values .: Success - Integer of DPI (pixels per inch)
;                  Failure - Returns 0 and @error is set
;                  |0 - No error.
;                  |4 - Invalid image handle
; Author ........: rover
; Modified.......:
; Remarks .......: @error 4 relies on GDI+ UDF return of -1 or 0 instead of image handle for errors
; Related .......: _GDIPlus_ImageGetVerticalResolution
; Link ..........: @@MsdnLink@@ GdipGetImageHorizontalResolution
; Example .......: Yes
; ===============================================================================================================================
Func _GDIPlus_ImageGetHorizontalResolution($hImage)
	If ($hImage = -1) Or (Not $hImage) Then Return SetError(10, 1, 0)
	Local $aResult = DllCall($ghGDIPDll, "int", "GdipGetImageHorizontalResolution", "handle", $hImage, "float*", 0)
	If @error Then Return SetError(@error, @extended, 0)
	Return SetExtended($aResult[0], Round($aResult[2]))
EndFunc   ;==>_GDIPlus_ImageGetHorizontalResolution

; #FUNCTION# ====================================================================================================================
; Name...........: _GDIPlus_ImageGetPixelFormat
; Description ...: Returns pixel format of an image: Bits per pixel, Alpha channels, RGB, Grayscale, Indexed etc.
; Syntax.........: _GDIPlus_ImageGetPixelFormat($hImage)
; Parameters ....: $hImage - Handle to an image object
; Return values .: Success - Array with the following format
;                  |[0] -  - Integer of pixel format constant
;                  |[1] -  - String of pixel format
;                  Failure - Returns empty array and @error is set, @extended set to error location
;                  |0 - No error.
;                  |4 - Invalid image handle
; Author ........: rover
; Modified.......:
; Remarks .......: @error 4 relies on GDI+ UDF return of -1 or 0 instead of image handle for errors
; Related .......: _GDIPlus_ImageGetFlags, _GDIPlus_BitmapLockBits, _GDIPlus_BitmapCloneArea
; Link ..........: @@MsdnLink@@ GdipGetImagePixelFormat
; Example .......: Yes
; ===============================================================================================================================
Func _GDIPlus_ImageGetPixelFormat($hImage)
	Local $aFormat[2] = [0, ""]
	If ($hImage = -1) Or (Not $hImage) Then Return SetError(10, 1, $aFormat)
	Local $aPixelFormat[14][2] = _
			[["1 Bpp Indexed", $GDIP_PXF01INDEXED], _
			["4 Bpp Indexed", $GDIP_PXF04INDEXED], _
			["8 Bpp Indexed", $GDIP_PXF08INDEXED], _
			["16 Bpp Grayscale", $GDIP_PXF16GRAYSCALE], _
			["16 Bpp RGB 555", $GDIP_PXF16RGB555], _
			["16 Bpp RGB 565", $GDIP_PXF16RGB565], _
			["16 Bpp ARGB 1555", $GDIP_PXF16ARGB1555], _
			["24 Bpp RGB", $GDIP_PXF24RGB], _
			["32 Bpp RGB", $GDIP_PXF32RGB], _
			["32 Bpp ARGB", $GDIP_PXF32ARGB], _
			["32 Bpp PARGB", $GDIP_PXF32PARGB], _
			["48 Bpp RGB", $GDIP_PXF48RGB], _
			["64 Bpp ARGB", $GDIP_PXF64ARGB], _
			["64 Bpp PARGB", $GDIP_PXF64PARGB]]
	Local $aResult = DllCall($ghGDIPDll, "int", "GdipGetImagePixelFormat", "handle", $hImage, "int*", 0)
	If @error Then Return SetError(@error, @extended, $aFormat)
	For $i = 0 To 13
		If $aPixelFormat[$i][1] = $aResult[2] Then
			$aFormat[0] = $aPixelFormat[$i][1]
			$aFormat[1] = $aPixelFormat[$i][0]
			Return SetExtended($aResult[0], $aFormat)
		EndIf
	Next
	Return SetExtended($aResult[0], $aFormat)
EndFunc   ;==>_GDIPlus_ImageGetPixelFormat

; #FUNCTION# ====================================================================================================================
; Name...........: _GDIPlus_ImageGetRawFormat
; Description ...: Returns file format GUID and image format name of an image
; Syntax.........: _GDIPlus_ImageGetRawFormat($hImage)
; Parameters ....: $hImage - Handle to an image object
; Return values .: Success - Array with the following format
;                  |[0] -  - String of file format GUID
;                  |[1] -  - String of image format name
;                  Failure - Returns empty array and @error is set, @extended set to error location
;                  |0 - No error.
;                  |4 - Invalid image handle
; Author ........: rover
; Modified.......:
; Remarks .......: @error 4 relies on GDI+ UDF return of -1 or 0 instead of image handle for errors
; Related .......: _GDIPlus_ImageGetType
; Link ..........: @@MsdnLink@@ GdipGetImageRawFormat
; Example .......: Yes
; ===============================================================================================================================
Func _GDIPlus_ImageGetRawFormat($hImage)
	Local $aGuid[2]
	If ($hImage = -1) Or (Not $hImage) Then Return SetError(10, 1, $aGuid)
	Local $aImageType[11][2] = _
			[["UNDEFINED", $GDIP_IMAGEFORMAT_UNDEFINED], _
			["MEMORYBMP", $GDIP_IMAGEFORMAT_MEMORYBMP], _
			["BMP", $GDIP_IMAGEFORMAT_BMP], _
			["EMF", $GDIP_IMAGEFORMAT_EMF], _
			["WMF", $GDIP_IMAGEFORMAT_WMF], _
			["JPEG", $GDIP_IMAGEFORMAT_JPEG], _
			["PNG", $GDIP_IMAGEFORMAT_PNG], _
			["GIF", $GDIP_IMAGEFORMAT_GIF], _
			["TIFF", $GDIP_IMAGEFORMAT_TIFF], _
			["EXIF", $GDIP_IMAGEFORMAT_EXIF], _
			["ICON", $GDIP_IMAGEFORMAT_ICON]]
	Local $tStruc = DllStructCreate("byte[16]")
	Local $aResult1 = DllCall($ghGDIPDll, "int", "GdipGetImageRawFormat", "handle", $hImage, "ptr", DllStructGetPtr($tStruc))
	If @error Then Return SetError(@error, @extended, $aGuid)
	If (Not IsArray($aResult1)) Or (Not IsPtr($aResult1[2])) Or _
			(Not $aResult1[2]) Then Return SetError(1, 3, $aGuid)
	Local $sResult2 = _WinAPI_StringFromGUID($aResult1[2])
	If @error Then Return SetError(@error, 4, $aGuid)
	For $i = 0 To 10
		If $aImageType[$i][1] == $sResult2 Then
			$aGuid[0] = $aImageType[$i][1]
			$aGuid[1] = $aImageType[$i][0]
			Return SetExtended($aResult1[0], $aGuid)
		EndIf
	Next
	Return SetError(-1, 5, $aGuid)
EndFunc   ;==>_GDIPlus_ImageGetRawFormat

; #FUNCTION# ====================================================================================================================
; Name...........: _GDIPlus_ImageGetType
; Description ...: Returns type (bitmap or metafile) of an image
; Syntax.........: _GDIPlus_ImageGetType($hImage)
; Parameters ....: $hImage - Handle to an image object
; Return values .: Success - Integer of image type
;                  |$GDIP_IMAGETYPE_UNKNOWN  - Non bitmap file or not identified as bitmap by GDI+
;                  |$GDIP_IMAGETYPE_BITMAP   - Bitmap types: BMP, PNG, GIF, JPEG, TIFF, ICO, EXIF
;                  |$GDIP_IMAGETYPE_METAFILE - Metafile types: EMF, WMF
;                  Failure - Returns -1 and @error is set
;                  |0 - No error.
;                  |4 - Invalid image handle
; Author ........: rover
; Modified.......:
; Remarks .......: @error 4 relies on GDI+ UDF return of -1 or 0 instead of image handle for errors
; Related .......: _GDIPlus_ImageGetRawFormat
; Link ..........: @@MsdnLink@@ GdipGetImageType
; Example .......: Yes
; ===============================================================================================================================
Func _GDIPlus_ImageGetType($hImage)
	If ($hImage = -1) Or (Not $hImage) Then Return SetError(10, 0, -1)
	Local $aResult = DllCall($ghGDIPDll, "int", "GdipGetImageType", "handle", $hImage, "int*", 0)
	If @error Then Return SetError(@error, @extended, -1)
	Return SetExtended($aResult[0], $aResult[2])
EndFunc   ;==>_GDIPlus_ImageGetType

; #FUNCTION# ====================================================================================================================
; Name...........: _GDIPlus_ImageGetVerticalResolution
; Description ...: Returns horizontal resolution in DPI (pixels per inch) of an image
; Syntax.........: _GDIPlus_ImageGetVerticalResolution($hImage)
; Parameters ....: $hImage - Handle to an image object
; Return values .: Success - Integer of DPI (pixels per inch)
;                  Failure - Returns 0 and @error is set
;                  |0 - No error.
;                  |4 - Invalid image handle
; Author ........: rover
; Modified.......:
; Remarks .......: @error 4 relies on GDI+ UDF return of -1 or 0 instead of image handle for errors
; Related .......: _GDIPlus_ImageGetHorizontalResolution
; Link ..........: @@MsdnLink@@ GdipGetImageVerticalResolution
; Example .......: Yes
; ===============================================================================================================================
Func _GDIPlus_ImageGetVerticalResolution($hImage)
	If ($hImage = -1) Or (Not $hImage) Then Return SetError(10, 0, 0)
	Local $aResult = DllCall($ghGDIPDll, "int", "GdipGetImageVerticalResolution", "handle", $hImage, "float*", 0)
	If @error Then Return SetError(@error, @extended, 0)
	Return SetExtended($aResult[0], Round($aResult[2]))
EndFunc   ;==>_GDIPlus_ImageGetVerticalResolution

; #FUNCTION# ====================================================================================================================
; Name...........: _GDIPlus_ImageGetWidth
; Description ...: Get the image width
; Syntax.........: _GDIPlus_ImageGetWidth($hImage)
; Parameters ....: $hImage      - Handle to an image object
; Return values .: Success      - Image width, in pixels
;                  Failure      - -1 and @error is set
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost
; Remarks .......:
; Related .......: _GDIPlus_ImageGetHeight
; Link ..........: @@MsdnLink@@ GdipGetImageWidth
; Example .......: Yes
; ===============================================================================================================================
Func _GDIPlus_ImageGetWidth($hImage)
	Local $aResult = DllCall($ghGDIPDll, "int", "GdipGetImageWidth", "handle", $hImage, "uint*", -1)
	If @error Then Return SetError(@error, @extended, -1)
	Return SetExtended($aResult[0], $aResult[2])
EndFunc   ;==>_GDIPlus_ImageGetWidth

; #FUNCTION# ====================================================================================================================
; Name...........: _GDIPlus_ImageLoadFromFile
; Description ...: Create an image object based on a file
; Syntax.........: _GDIPlus_ImageLoadFromFile($sFileName)
; Parameters ....: $sFileName   - Fully qualified image file name
; Return values .: Success      - Handle to the new image object
;                  Failure      - -1 and @error is set
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost/martin
; Remarks .......:
; Related .......: _GDIPlus_ImageSaveToFile, _GDIPlus_ImageSaveToFileEx
; Link ..........: @@MsdnLink@@ GdipLoadImageFromFile
; Example .......: Yes
; ===============================================================================================================================
Func _GDIPlus_ImageLoadFromFile($sFileName)
	Local $aResult = DllCall($ghGDIPDll, "int", "GdipLoadImageFromFile", "wstr", $sFileName, "ptr*", 0)
	If @error Then Return SetError(@error, @extended, -1)
	Return SetExtended($aResult[0], $aResult[2])
EndFunc   ;==>_GDIPlus_ImageLoadFromFile

; #FUNCTION# ====================================================================================================================
; Name...........: _GDIPlus_ImageSaveToFile
; Description ...: Save an image to file
; Syntax.........: _GDIPlus_ImageSaveToFile($hImage, $sFileName)
; Parameters ....: $hImage      - Handle to an image object
;                  $sFileName   - Fully qualified image file name
; Return values .: Success      - True
;                  Failure      - False
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost
; Remarks .......:
; Related .......: _GDIPlus_ImageLoadFromFile, _GDIPlus_ImageSaveToFileEx
; Link ..........: @@MsdnLink@@ GdipSaveImageToFile
; Example .......: Yes
; ===============================================================================================================================
Func _GDIPlus_ImageSaveToFile($hImage, $sFileName)
	Local $sExt = __GDIPlus_ExtractFileExt($sFileName)
	Local $sCLSID = _GDIPlus_EncodersGetCLSID($sExt)
	If $sCLSID = "" Then Return SetError(-1, 0, False)
	Return _GDIPlus_ImageSaveToFileEx($hImage, $sFileName, $sCLSID, 0)
EndFunc   ;==>_GDIPlus_ImageSaveToFile

; #FUNCTION# ====================================================================================================================
; Name...........: _GDIPlus_ImageSaveToFileEx
; Description ...: Save an image to file
; Syntax.........: _GDIPlus_ImageSaveToFileEx($hImage, $sFileName, $sEncoder[, $pParams = 0])
; Parameters ....: $hImage      - Handle to an image object
;                  $sFileName   - Fully qualified image file name
;                  $sEncoder    - GUID string of encoder to be used
;                  $pParams     - Pointer to a $tagGDIPPENCODERPARAMS structure
; Return values .: Success      - True
;                  Failure      - False
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost
; Remarks .......:
; Related .......: _GDIPlus_ImageLoadFromFile, _GDIPlus_ImageSaveToFile, $tagGDIPPENCODERPARAMS
; Link ..........: @@MsdnLink@@ GdipSaveImageToFile
; Example .......: Yes
; ===============================================================================================================================
Func _GDIPlus_ImageSaveToFileEx($hImage, $sFileName, $sEncoder, $pParams = 0)
	Local $tGUID = _WinAPI_GUIDFromString($sEncoder)
	Local $pGUID = DllStructGetPtr($tGUID)
	Local $aResult = DllCall($ghGDIPDll, "int", "GdipSaveImageToFile", "handle", $hImage, "wstr", $sFileName, "ptr", $pGUID, "ptr", $pParams)
	If @error Then Return SetError(@error, @extended, False)
	Return $aResult[0] = 0
EndFunc   ;==>_GDIPlus_ImageSaveToFileEx

; #FUNCTION# ====================================================================================================================
; Name...........: _GDIPlus_MatrixCreate
; Description ...: Creates and initializes a Matrix object that represents the identity matrix
; Syntax.........: _GDIPlus_MatrixCreate()
; Parameters ....:
; Return values .: Success      - Handle to a Matrix object
;                  Failure      - 0
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost
; Remarks .......: When you are done with the matrix, call _GDIPlus_MatrixDispose to release the resources
; Related .......: _GDIPlus_MatrixDispose
; Link ..........: @@MsdnLink@@ GdipCreateMatrix
; Example .......: Yes
; ===============================================================================================================================
Func _GDIPlus_MatrixCreate()
	Local $aResult = DllCall($ghGDIPDll, "int", "GdipCreateMatrix", "ptr*", 0)
	If @error Then Return SetError(@error, @extended, 0)
	__GDIPlus_ObjectDispose_ListAdd($aResult[1], "Matrix")
	Return SetExtended($aResult[0], $aResult[1])
EndFunc   ;==>_GDIPlus_MatrixCreate

; #FUNCTION# ====================================================================================================================
; Name...........: _GDIPlus_MatrixDispose
; Description ...: Release a matrix object
; Syntax.........: _GDIPlus_MatrixDispose($hMatrix)
; Parameters ....: $hMatrix     - Handle to a Matrix object
; Return values .: Success      - True
;                  Failure      - False
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost
; Remarks .......:
; Related .......: _GDIPlus_MatrixCreate
; Link ..........: @@MsdnLink@@ GdipDeleteMatrix
; Example .......: Yes
; ===============================================================================================================================
Func _GDIPlus_MatrixDispose($hMatrix)
	Local $aResult = DllCall($ghGDIPDll, "int", "GdipDeleteMatrix", "handle", $hMatrix)
	If @error Then Return SetError(@error, @extended, False)
	__GDIPlus_ObjectDispose_ListRemove($hMatrix, "Matrix")
	Return $aResult[0] = 0
EndFunc   ;==>_GDIPlus_MatrixDispose

; #FUNCTION# ====================================================================================================================
; Name...........: _GDIPlus_MatrixRotate
; Description ...: Updates a matrix with the product of itself and a rotation matrix
; Syntax.........: _GDIPlus_MatrixRotate($hMatrix, $fAngle[, $bAppend = False])
; Parameters ....: $hMatrix     - Handle to a Matrix object
;                  $fAngle      - The angle of rotation in degrees. Positive values specify clockwise rotation.
;                  $bAppend     - Specifies the order of the multiplication:
;                  |True  - Specifies that the rotation matrix is on the left
;                  |False - Specifies that the rotation matrix is on the right
; Return values .: Success      - True
;                  Failure      - False
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost
; Remarks .......:
; Related .......:
; Link ..........: @@MsdnLink@@ GdipRotateMatrix
; Example .......: Yes
; ===============================================================================================================================
Func _GDIPlus_MatrixRotate($hMatrix, $fAngle, $bAppend = False)
	Local $aResult = DllCall($ghGDIPDll, "int", "GdipRotateMatrix", "handle", $hMatrix, "float", $fAngle, "int", $bAppend)
	If @error Then Return SetError(@error, @extended, False)
	Return $aResult[0] = 0
EndFunc   ;==>_GDIPlus_MatrixRotate

; #FUNCTION# ====================================================================================================================
; Name...........: _GDIPlus_MatrixScale
; Description ...: Updates a matrix with the product of itself and a scaling matrix
; Syntax.........: _GDIPlus_MatrixScale($hMatrix, $fScaleX, $fScaleY[, $bOrder = False])
; Parameters ....: $hMatrix     - Handle to a Matrix object
;                  $fScaleX     - Multiplyier to scale the x-axis
;                  $fScaleY     - Multiplyier to scale the y-axis
;                  $bOrder      - Specifies the order of the multiplication:
;                  |True  - Specifies that the scaling matrix is on the left
;                  |False - Specifies that the scaling matrix is on the right
; Return values .: Success      - True
;                  Failure      - False
; Author ........: monoceres
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........: @@MsdnLink@@ GdipScaleMatrix
; Example .......: Yes
; ===============================================================================================================================
Func _GDIPlus_MatrixScale($hMatrix, $fScaleX, $fScaleY, $bOrder = False)
	Local $aResult = DllCall($ghGDIPDll, "int", "GdipScaleMatrix", "handle", $hMatrix, "float", $fScaleX, "float", $fScaleY, "int", $bOrder)
	If @error Then Return SetError(@error, @extended, False)
	Return $aResult[0] = 0
EndFunc   ;==>_GDIPlus_MatrixScale

; #FUNCTION# ====================================================================================================================
; Name...........: _GDIPlus_MatrixTranslate
; Description ...: Updates a matrix with the product of itself and a translation matrix
; Syntax.........: _GDIPlus_MatrixTranslate($hMatrix, $fOffsetX, $fOffsetY[, $bAppend = False])
; Parameters ....: $hMatrix     - Handle to a Matrix object
;                  $fOffsetX    - Amount of pixels to add along the x-axis
;                  $fOffsetY    - Amount of pixels to add along the y-axis
;                  $bAppend     - Specifies the order of the multiplication:
;                  |True  - Specifies that the translation matrix is on the left
;                  |False - Specifies that the translation matrix is on the right
; Return values .: Success      - True
;                  Failure      - False
; Author ........: monoceres
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........: @@MsdnLink@@ GdipTranslateMatrix
; Example .......: Yes
; ===============================================================================================================================
Func _GDIPlus_MatrixTranslate($hMatrix, $fOffsetX, $fOffsetY, $bAppend = False)
	Local $aResult = DllCall($ghGDIPDll, "int", "GdipTranslateMatrix", "handle", $hMatrix, "float", $fOffsetX, "float", $fOffsetY, "int", $bAppend)
	If @error Then Return SetError(@error, @extended, False)
	Return $aResult[0] = 0
EndFunc   ;==>_GDIPlus_MatrixTranslate

; #FUNCTION# ====================================================================================================================
; Name...........: _GDIPlus_ParamAdd
; Description ...: Add a value to an encoder parameter list
; Syntax.........: _GDIPlus_ParamAdd(ByRef $tParams, $sGUID, $iCount, $iType, $pValues)
; Parameters ....: $tParams     - $tagGDIPPENCODERPARAMS structure returned from _GDIPlus_ParamInit
;                  $sGUID       - Encoder parameter GUID. Can be one of the following:
;                  |$GDIP_EPGCHROMINANCETABLE - Chrominance table settings
;                  |$GDIP_EPGCOLORDEPTH       - Color depth settings
;                  |$GDIP_EPGCOMPRESSION      - Compression settings
;                  |$GDIP_EPGLUMINANCETABLE   - Luminance table settings
;                  |$GDIP_EPGQUALITY          - Quality settings
;                  |$GDIP_EPGRENDERMETHOD     - Render method settings
;                  |$GDIP_EPGSAVEFLAG         - Save flag settings
;                  |$GDIP_EPGSCANMETHOD       - Scan mode settings
;                  |$GDIP_EPGTRANSFORMATION   - Transformation settings
;                  |$GDIP_EPGVERSION          - Software version settings
;                  $iCount      - Number of elements in the $pValues array
;                  $iType       - Encoder parameter value type. Can be one of the following:
;                  |$GDIP_EPTBYTE          - 8 bit unsigned integer
;                  |$GDIP_EPTASCII         - Null terminated character string
;                  |$GDIP_EPTSHORT         - 16 bit unsigned integer
;                  |$GDIP_EPTLONG          - 32 bit unsigned integer
;                  |$GDIP_EPTRATIONAL      - Two longs (numerator, denomintor)
;                  |$GDIP_EPTLONGRANGE     - Two longs (low, high)
;                  |$GDIP_EPTUNDEFINED     - Array of bytes of any type
;                  |$GDIP_EPTRATIONALRANGE - Two ratationals (low, high)
;                  $pValues     - Pointer to an array of values. Each value has the type specified by the $iType data member.
; Return values .:
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; Remarks .......:
; Related .......: _GDIPlus_ParamInit, $tagGDIPPENCODERPARAMS
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _GDIPlus_ParamAdd(ByRef $tParams, $sGUID, $iCount, $iType, $pValues)
	Local $tParam = DllStructCreate($tagGDIPENCODERPARAM, DllStructGetPtr($tParams, "Params") + (DllStructGetData($tParams, "Count") * 28))
	_WinAPI_GUIDFromStringEx($sGUID, DllStructGetPtr($tParam, "GUID"))
	DllStructSetData($tParam, "Type", $iType)
	DllStructSetData($tParam, "Count", $iCount)
	DllStructSetData($tParam, "Values", $pValues)
	DllStructSetData($tParams, "Count", DllStructGetData($tParams, "Count") + 1)
EndFunc   ;==>_GDIPlus_ParamAdd

; #FUNCTION# ====================================================================================================================
; Name...........: _GDIPlus_ParamInit
; Description ...: Initialize an encoder parameter list
; Syntax.........: _GDIPlus_ParamInit($iCount)
; Parameters ....: $iCount      - The total number of parameters that the list will contain
; Return values .: Success      - $tagGDIPPENCODERPARAMS structure
;                  Failure      - 0
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; Remarks .......: In order to pass parameters to any of the encoder functions, you must use  an  encoder  parameter  list.  This
;                  function is used to initialize an encoder parameter list that can then be passed to _GDIPlus_Param add to add the
;                  actual parameters.
; Related .......: _GDIPlus_ParamAdd, $tagGDIPPENCODERPARAMS
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _GDIPlus_ParamInit($iCount)
	If $iCount <= 0 Then Return SetError(-1, -1, 0)
	Return DllStructCreate("dword Count;byte Params[" & $iCount * 28 & "]")
EndFunc   ;==>_GDIPlus_ParamInit

; #FUNCTION# ====================================================================================================================
; Name...........: _GDIPlus_PenCreate
; Description ...: Create a pen object
; Syntax.........: _GDIPlus_PenCreate([$iARGB = 0xFF000000[, $nWidth = 1[, $iUnit = 2]]])
; Parameters ....: $iARGB       - Alpha, Red, Green and Blue components of pen color
;                  $nWidth      - The width of the pen measured in the units specified in the $iUnit parameter
;                  $iUnit       - Unit of measurement for the pen size:
;                  |0 - World coordinates, a nonphysical unit
;                  |1 - Display units
;                  |2 - A unit is 1 pixel
;                  |3 - A unit is 1 point or 1/72 inch
;                  |4 - A unit is 1 inch
;                  |5 - A unit is 1/300 inch
;                  |6 - A unit is 1 millimeter
; Return values .: Success      - Handle to a pen object
;                  Failure      - 0
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost
; Remarks .......: When you are done with the pen, call _GDIPlus_PenDispose to release the resources
; Related .......: _GDIPlus_PenDispose
; Link ..........: @@MsdnLink@@ GdipCreatePen1
; Example .......: Yes
; ===============================================================================================================================
Func _GDIPlus_PenCreate($iARGB = 0xFF000000, $fWidth = 1, $iUnit = 2)
	Local $aResult = DllCall($ghGDIPDll, "int", "GdipCreatePen1", "dword", $iARGB, "float", $fWidth, "int", $iUnit, "ptr*", 0)
	If @error Then Return SetError(@error, @extended, 0)
	__GDIPlus_ObjectDispose_ListAdd($aResult[4], "Pen")
	Return SetExtended($aResult[0], $aResult[4])
EndFunc   ;==>_GDIPlus_PenCreate

; #FUNCTION# ====================================================================================================================
; Name...........: _GDIPlus_PenDispose
; Description ...: Release a pen object
; Syntax.........: _GDIPlus_PenDispose($hPen)
; Parameters ....: $hPen        - Handle to a pen object
; Return values .: Success      - True
;                  Failure      - False
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost
; Remarks .......:
; Related .......: _GDIPlus_PenCreate
; Link ..........: @@MsdnLink@@ GdipDeletePen
; Example .......: Yes
; ===============================================================================================================================
Func _GDIPlus_PenDispose($hPen)
	Local $aResult = DllCall($ghGDIPDll, "int", "GdipDeletePen", "handle", $hPen)
	If @error Then Return SetError(@error, @extended, False)
	__GDIPlus_ObjectDispose_ListRemove($hPen, "Pen")
	Return $aResult[0] = 0
EndFunc   ;==>_GDIPlus_PenDispose

; #FUNCTION# ====================================================================================================================
; Name...........: _GDIPlus_PenGetAlignment
; Description ...: Gets the pen alignment
; Syntax.........: _GDIPlus_PenGetAlignment($hPen)
; Parameters ....: $hPen        - Handle to a pen object
; Return values .: Success      - Alignment type:
;                  |0 - Specifies that the pen is aligned on the center of the line that is drawn
;                  |1 - Specifies, when drawing a polygon, that the pen is aligned on the inside of the edge of the polygon
;                  Failure      - -1 and @error is set
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost
; Remarks .......:
; Related .......: _GDIPlus_PenSetAlignment
; Link ..........: @@MsdnLink@@ GdipGetPenMode
; Example .......: Yes
; ===============================================================================================================================
Func _GDIPlus_PenGetAlignment($hPen)
	Local $aResult = DllCall($ghGDIPDll, "int", "GdipGetPenMode", "handle", $hPen, "int*", 0)
	If @error Then Return SetError(@error, @extended, -1)
	Return SetExtended($aResult[0], $aResult[2])
EndFunc   ;==>_GDIPlus_PenGetAlignment

; #FUNCTION# ====================================================================================================================
; Name...........: _GDIPlus_PenGetColor
; Description ...: Gets the pen color
; Syntax.........: _GDIPlus_PenGetColor($hPen)
; Parameters ....: $hPen        - Handle to a pen object
; Return values .: Success      - Pen color
;                  Failure      - -1 and @error is set
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost
; Remarks .......:
; Related .......: _GDIPlus_PenSetColor
; Link ..........: @@MsdnLink@@ GdipGetPenColor
; Example .......:
; ===============================================================================================================================
Func _GDIPlus_PenGetColor($hPen)
	Local $aResult = DllCall($ghGDIPDll, "int", "GdipGetPenColor", "handle", $hPen, "dword*", 0)
	If @error Then Return SetError(@error, @extended, -1)
	Return SetExtended($aResult[0], $aResult[2])
EndFunc   ;==>_GDIPlus_PenGetColor

; #FUNCTION# ====================================================================================================================
; Name...........: _GDIPlus_PenGetCustomEndCap
; Description ...: Gets the custom end cap for the pen
; Syntax.........: _GDIPlus_PenGetCustomEndCap($hPen)
; Parameters ....: $hPen        - Handle to a pen object
; Return values .: Success      - Handle to a CustomLineCap object that specifies the pen custom end cap
;                  Failure      - 0
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost
; Remarks .......:
; Related .......: _GDIPlus_PenSetCustomEndCap
; Link ..........: @@MsdnLink@@ GdipGetPenCustomEndCap
; Example .......: Yes
; ===============================================================================================================================
Func _GDIPlus_PenGetCustomEndCap($hPen)
	Local $aResult = DllCall($ghGDIPDll, "int", "GdipGetPenCustomEndCap", "handle", $hPen, "ptr*", 0)
	If @error Then Return SetError(@error, @extended, 0)
	Return SetExtended($aResult[0], $aResult[2])
EndFunc   ;==>_GDIPlus_PenGetCustomEndCap

; #FUNCTION# ====================================================================================================================
; Name...........: _GDIPlus_PenGetDashCap
; Description ...: Gets the pen dash cap style
; Syntax.........: _GDIPlus_PenGetDashCap($hPen)
; Parameters ....: $hPen        - Handle to a pen object
; Return values .: Success      - Dash cap style:
;                  |$GDIP_DASHCAPFLAT     - A square cap that squares off both ends of each dash
;                  |$GDIP_DASHCAPROUND    - A circular cap that rounds off both ends of each dash
;                  |$GDIP_DASHCAPTRIANGLE - A triangular cap that points both ends of each dash
;                  Failure      - -1 and @error is set
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost
; Remarks .......:
; Related .......: _GDIPlus_PenSetDashCap
; Link ..........: @@MsdnLink@@ GdipGetPenDashCap197819
; Example .......: Yes
; ===============================================================================================================================
Func _GDIPlus_PenGetDashCap($hPen)
	Local $aResult = DllCall($ghGDIPDll, "int", "GdipGetPenDashCap197819", "handle", $hPen, "int*", 0)
	If @error Then Return SetError(@error, @extended, -1)
	Return SetExtended($aResult[0], $aResult[2])
EndFunc   ;==>_GDIPlus_PenGetDashCap

; #FUNCTION# ====================================================================================================================
; Name...........: _GDIPlus_PenGetDashStyle
; Description ...: Gets the pen dash style
; Syntax.........: _GDIPlus_PenGetDashStyle($hPen)
; Parameters ....: $hPen        - Handle to a pen object
; Return values .: Success      - Dash style:
;                  |$GDIP_DASHSTYLESOLID      - A solid line
;                  |$GDIP_DASHSTYLEDASH       - A dashed line
;                  |$GDIP_DASHSTYLEDOT        - A dotted line
;                  |$GDIP_DASHSTYLEDASHDOT    - An alternating dash-dot line
;                  |$GDIP_DASHSTYLEDASHDOTDOT - An alternating dash-dot-dot line
;                  |$GDIP_DASHSTYLECUSTOM     - A a user-defined, custom dashed line
;                  Failure      - -1 and @error is set
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost
; Remarks .......:
; Related .......: _GDIPlus_PenSetDashStyle
; Link ..........: @@MsdnLink@@ GdipGetPenDashStyle
; Example .......: Yes
; ===============================================================================================================================
Func _GDIPlus_PenGetDashStyle($hPen)
	Local $aResult = DllCall($ghGDIPDll, "int", "GdipGetPenDashStyle", "handle", $hPen, "int*", 0)
	If @error Then Return SetError(@error, @extended, -1)
	Return SetExtended($aResult[0], $aResult[2])
EndFunc   ;==>_GDIPlus_PenGetDashStyle

; #FUNCTION# ====================================================================================================================
; Name...........: _GDIPlus_PenGetEndCap
; Description ...: Gets the pen end cap
; Syntax.........: _GDIPlus_PenGetEndCap($hPen)
; Parameters ....: $hPen        - Handle to a pen object
; Return values .: Success      - End cap type:
;                  |$GDIP_LINECAPFLAT          - Specifies a flat cap
;                  |$GDIP_LINECAPSQUARE        - Specifies a square cap
;                  |$GDIP_LINECAPROUND         - Specifies a circular cap
;                  |$GDIP_LINECAPTRIANGLE      - Specifies a triangular cap
;                  |$GDIP_LINECAPNOANCHOR      - Specifies that the line ends are not anchored
;                  |$GDIP_LINECAPSQUAREANCHOR  - Specifies that the line ends are anchored with a square
;                  |$GDIP_LINECAPROUNDANCHOR   - Specifies that the line ends are anchored with a circle
;                  |$GDIP_LINECAPDIAMONDANCHOR - Specifies that the line ends are anchored with a diamond
;                  |$GDIP_LINECAPARROWANCHOR   - Specifies that the line ends are anchored with arrowheads
;                  |$GDIP_LINECAPCUSTOM        - Specifies that the line ends are made from a CustomLineCap
;                  Failure      - -1 and @error is set
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost
; Remarks .......:
; Related .......: _GDIPlus_PenSetEndCap
; Link ..........: @@MsdnLink@@ GdipGetPenEndCap
; Example .......: Yes
; ===============================================================================================================================
Func _GDIPlus_PenGetEndCap($hPen)
	Local $aResult = DllCall($ghGDIPDll, "int", "GdipGetPenEndCap", "handle", $hPen, "int*", 0)
	If @error Then Return SetError(@error, @extended, -1)
	Return SetExtended($aResult[0], $aResult[2])
EndFunc   ;==>_GDIPlus_PenGetEndCap

; #FUNCTION# ====================================================================================================================
; Name...........: _GDIPlus_PenGetWidth
; Description ...: Retrieve the width of a pen
; Syntax.........: _GDIPlus_PenGetWidth($hPen)
; Parameters ....: $hPen        - Handle to a pen object
; Return values .: Success      - Width of pen
;                  Failure      - -1 and @error is set
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost
; Remarks .......:
; Related .......: _GDIPlus_PenSetWidth
; Link ..........: @@MsdnLink@@ GdipGetPenWidth
; Example .......: Yes
; ===============================================================================================================================
Func _GDIPlus_PenGetWidth($hPen)
	Local $aResult = DllCall($ghGDIPDll, "int", "GdipGetPenWidth", "handle", $hPen, "float*", 0)
	If @error Then Return SetError(@error, @extended, -1)
	Return SetExtended($aResult[0], $aResult[2])
EndFunc   ;==>_GDIPlus_PenGetWidth

; #FUNCTION# ====================================================================================================================
; Name...........: _GDIPlus_PenSetAlignment
; Description ...: Sets the pen alignment
; Syntax.........: _GDIPlus_PenSetAlignment($hPen[, $iAlignment = 0])
; Parameters ....: $hPen        - Handle to a pen object
;                  $iAlignment  - Pen alignment. Can be one of the following:
;                  |0 - Specifies that the pen is aligned on the center of the line that is drawn
;                  |1 - Specifies, when drawing a polygon, that the pen is aligned on the inside of the edge of the polygon
; Return values .: Success      - True
;                  Failure      - False
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost
; Remarks .......:
; Related .......: _GDIPlus_PenGetAlignment
; Link ..........: @@MsdnLink@@ GdipSetPenMode
; Example .......: Yes
; ===============================================================================================================================
Func _GDIPlus_PenSetAlignment($hPen, $iAlignment = 0)
	Local $aResult = DllCall($ghGDIPDll, "int", "GdipSetPenMode", "handle", $hPen, "int", $iAlignment)
	If @error Then Return SetError(@error, @extended, False)
	Return $aResult[0] = 0
EndFunc   ;==>_GDIPlus_PenSetAlignment

; #FUNCTION# ====================================================================================================================
; Name...........: _GDIPlus_PenSetColor
; Description ...: Sets the pen color
; Syntax.........: _GDIPlus_PenSetColor($hPen, $iARGB)
; Parameters ....: $hPen        - Handle to a pen object
;                  $iARGB       - Alpha, Red, Green and Blue components of pen color
; Return values .: Success      - True
;                  Failure      - False
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost
; Remarks .......:
; Related .......: _GDIPlus_PenGetColor
; Link ..........: @@MsdnLink@@ GdipSetPenColor
; Example .......:
; ===============================================================================================================================
Func _GDIPlus_PenSetColor($hPen, $iARGB)
	Local $aResult = DllCall($ghGDIPDll, "int", "GdipSetPenColor", "handle", $hPen, "dword", $iARGB)
	If @error Then Return SetError(@error, @extended, False)
	Return $aResult[0] = 0
EndFunc   ;==>_GDIPlus_PenSetColor

; #FUNCTION# ====================================================================================================================
; Name...........: _GDIPlus_PenSetDashCap
; Description ...: Sets the pen dash cap style
; Syntax.........: _GDIPlus_PenSetDashCap($hPen[, $iDash = 0])
; Parameters ....: $hPen        - Handle to a pen object
;                  $iDash       - Dash cap style. Can be one of the following:
;                  |$GDIP_DASHCAPFLAT     - A square cap that squares off both ends of each dash
;                  |$GDIP_DASHCAPROUND    - A circular cap that rounds off both ends of each dash
;                  |$GDIP_DASHCAPTRIANGLE - A triangular cap that points both ends of each dash
; Return values .: Success      - True
;                  Failure      - False
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost
; Remarks .......:
; Related .......: _GDIPlus_PenGetDashCap
; Link ..........: @@MsdnLink@@ GdipSetPenDashCap197819
; Example .......: Yes
; ===============================================================================================================================
Func _GDIPlus_PenSetDashCap($hPen, $iDash = 0)
	Local $aResult = DllCall($ghGDIPDll, "int", "GdipSetPenDashCap197819", "handle", $hPen, "int", $iDash)
	If @error Then Return SetError(@error, @extended, False)
	Return $aResult[0] = 0
EndFunc   ;==>_GDIPlus_PenSetDashCap

; #FUNCTION# ====================================================================================================================
; Name...........: _GDIPlus_PenSetCustomEndCap
; Description ...: Sets the custom end cap for the pen
; Syntax.........: _GDIPlus_PenSetCustomEndCap($hPen, $hEndCap)
; Parameters ....: $hPen        - Handle to a pen object
;                  $hEndCap     - Handle to a CustomLineCap object that specifies the pen custom end cap
; Return values .: Success      - True
;                  Failure      - False
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost
; Remarks .......:
; Related .......: _GDIPlus_PenGetCustomEndCap
; Link ..........: @@MsdnLink@@ GdipSetPenCustomEndCap
; Example .......: Yes
; ===============================================================================================================================
Func _GDIPlus_PenSetCustomEndCap($hPen, $hEndCap)
	Local $aResult = DllCall($ghGDIPDll, "int", "GdipSetPenCustomEndCap", "handle", $hPen, "handle", $hEndCap)
	If @error Then Return SetError(@error, @extended, False)
	Return $aResult[0] = 0
EndFunc   ;==>_GDIPlus_PenSetCustomEndCap

; #FUNCTION# ====================================================================================================================
; Name...........: _GDIPlus_PenSetDashStyle
; Description ...: Sets the pen dash style
; Syntax.........: _GDIPlus_PenSetDashStyle($hPen[, $iStyle = 0])
; Parameters ....: $hPen        - Handle to a pen object
;                  $iStyle      - Dash style. Can be one of the following:
;                  |$GDIP_DASHSTYLESOLID      - A solid line
;                  |$GDIP_DASHSTYLEDASH       - A dashed line
;                  |$GDIP_DASHSTYLEDOT        - A dotted line
;                  |$GDIP_DASHSTYLEDASHDOT    - An alternating dash-dot line
;                  |$GDIP_DASHSTYLEDASHDOTDOT - An alternating dash-dot-dot line
;                  |$GDIP_DASHSTYLECUSTOM     - A a user-defined, custom dashed line
; Return values .: Success      - True
;                  Failure      - False
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost
; Remarks .......:
; Related .......: _GDIPlus_PenGetDashStyle
; Link ..........: @@MsdnLink@@ GdipSetPenDashStyle
; Example .......: Yes
; ===============================================================================================================================
Func _GDIPlus_PenSetDashStyle($hPen, $iStyle = 0)
	Local $aResult = DllCall($ghGDIPDll, "int", "GdipSetPenDashStyle", "handle", $hPen, "int", $iStyle)
	If @error Then Return SetError(@error, @extended, False)
	Return $aResult[0] = 0
EndFunc   ;==>_GDIPlus_PenSetDashStyle

; #FUNCTION# ====================================================================================================================
; Name...........: _GDIPlus_PenSetEndCap
; Description ...: Sets the pen end cap
; Syntax.........: _GDIPlus_PenSetEndCap($hPen, $iEndCap)
; Parameters ....: $hPen        - Handle to a pen object
;                  $iEndCap     - End cap type. Can be one of the following:
;                  |$GDIP_LINECAPFLAT          - Specifies a flat cap
;                  |$GDIP_LINECAPSQUARE        - Specifies a square cap
;                  |$GDIP_LINECAPROUND         - Specifies a circular cap
;                  |$GDIP_LINECAPTRIANGLE      - Specifies a triangular cap
;                  |$GDIP_LINECAPNOANCHOR      - Specifies that the line ends are not anchored
;                  |$GDIP_LINECAPSQUAREANCHOR  - Specifies that the line ends are anchored with a square
;                  |$GDIP_LINECAPROUNDANCHOR   - Specifies that the line ends are anchored with a circle
;                  |$GDIP_LINECAPDIAMONDANCHOR - Specifies that the line ends are anchored with a diamond
;                  |$GDIP_LINECAPARROWANCHOR   - Specifies that the line ends are anchored with arrowheads
;                  |$GDIP_LINECAPCUSTOM        - Specifies that the line ends are made from a CustomLineCap
; Return values .: Success      - True
;                  Failure      - False
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost
; Remarks .......:
; Related .......: _GDIPlus_PenGetEndCap
; Link ..........: @@MsdnLink@@ GdipSetPenEndCap
; Example .......: Yes
; ===============================================================================================================================
Func _GDIPlus_PenSetEndCap($hPen, $iEndCap)
	Local $aResult = DllCall($ghGDIPDll, "int", "GdipSetPenEndCap", "handle", $hPen, "int", $iEndCap)
	If @error Then Return SetError(@error, @extended, False)
	Return $aResult[0] = 0
EndFunc   ;==>_GDIPlus_PenSetEndCap

; #FUNCTION# ====================================================================================================================
; Name...........: _GDIPlus_PenSetWidth
; Description ...: Sets the width of a pen
; Syntax.........: _GDIPlus_PenSetWidth($hPen, $fWidth)
; Parameters ....: $hPen        - Handle to a pen object
;                  $fWidth      - Width of pen
; Return values .: Success      - True
;                  Failure      - False
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost
; Remarks .......:
; Related .......: _GDIPlus_PenGetWidth
; Link ..........: @@MsdnLink@@ GdipSetPenWidth
; Example .......: Yes
; ===============================================================================================================================
Func _GDIPlus_PenSetWidth($hPen, $fWidth)
	Local $aResult = DllCall($ghGDIPDll, "int", "GdipSetPenWidth", "handle", $hPen, "float", $fWidth)
	If @error Then Return SetError(@error, @extended, False)
	Return $aResult[0] = 0
EndFunc   ;==>_GDIPlus_PenSetWidth

; #FUNCTION# ====================================================================================================================
; Name...........: _GDIPlus_RectFCreate
; Description ...: Create a $tagGDIPRECTF structure
; Syntax.........: _GDIPlus_RectFCreate([$nX = 0[, $nY = 0[, $nWidth = 0[, $nHeight = 0]]]])
; Parameters ....: $nX      - X coordinate of upper left hand corner of rectangle
;                  $nY      - Y coordinate of upper left hand corner of rectangle
;                  $nWidth  - Rectangle width
;                  $nHeight - Rectangle height
; Return values .: Success      - $tagGDIPRECTF structure
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; Remarks .......:
; Related .......: $tagGDIPRECTF
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _GDIPlus_RectFCreate($nX = 0, $nY = 0, $nWidth = 0, $nHeight = 0)
	Local $tRectF = DllStructCreate($tagGDIPRECTF)
	DllStructSetData($tRectF, "X", $nX)
	DllStructSetData($tRectF, "Y", $nY)
	DllStructSetData($tRectF, "Width", $nWidth)
	DllStructSetData($tRectF, "Height", $nHeight)
	Return $tRectF
EndFunc   ;==>_GDIPlus_RectFCreate

; #FUNCTION# ====================================================================================================================
; Name...........: _GDIPlus_Shutdown
; Description ...: Clean up resources used by Microsoft Windows GDI+
; Syntax.........: _GDIPlus_Shutdown()
; Parameters ....:
; Return values .: Success      - True
;                  Failure      - False
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; Remarks .......: You must dispose of all of your GDI+ objects before you call _GDIPlus_Shutdown
; Related .......: _GDIPlus_Startup
; Link ..........: @@MsdnLink@@ GdiplusShutdown
; Example .......: Yes
; ===============================================================================================================================
Func _GDIPlus_Shutdown()
	__GDIPlus_ObjectDispose_All()
	If $ghGDIPDll = 0 Then Return SetError(-1, -1, False)
	$giGDIPRef -= 1
	If $giGDIPRef = 0 Then
		DllCall($ghGDIPDll, "none", "GdiplusShutdown", "ptr", $giGDIPToken)
		DllClose($ghGDIPDll)
		$ghGDIPDll = 0
	EndIf
	Return True
EndFunc   ;==>_GDIPlus_Shutdown

; #FUNCTION# ====================================================================================================================
; Name...........: _GDIPlus_Startup
; Description ...: Initialize Microsoft Windows GDI+
; Syntax.........: _GDIPlus_Startup($fConsoleOut = False)
; Parameters ....: $fConsoleOut - Set true or False for feed back in console of created and destoryed graphic objects
; Return values .: Success      - True
;                  Failure      - False
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost, Yoriz
; Remarks .......: Call _GDIPlus_Startup before you create any GDI+ objects.  GDI+ requires a redistributable for applications  that
;                  run on the Microsoft Windows NT 4.0 SP6, Windows 2000, Windows 98, and Windows Me operating systems.
; Related .......: _GDIPlus_Shutdown
; Link ..........: @@MsdnLink@@ GdiplusStartup
; Example .......: Yes
; ===============================================================================================================================
Func _GDIPlus_Startup($fConsoleOut = False)
	$ghGDIPDis_ConsoleOut = $fConsoleOut
	$giGDIPRef += 1
	If $giGDIPRef > 1 Then Return True

	$ghGDIPDll = DllOpen("GDIPlus.dll")
	If $ghGDIPDll = -1 Then Return SetError(1, 2, False)
	Local $tInput = DllStructCreate($tagGDIPSTARTUPINPUT)
	Local $pInput = DllStructGetPtr($tInput)
	Local $tToken = DllStructCreate("ulong_ptr Data")
	Local $pToken = DllStructGetPtr($tToken)
	DllStructSetData($tInput, "Version", 1)
	Local $aResult = DllCall($ghGDIPDll, "int", "GdiplusStartup", "ptr", $pToken, "ptr", $pInput, "ptr", 0)
	If @error Then Return SetError(@error, @extended, False)
	$giGDIPToken = DllStructGetData($tToken, "Data")
	Return $aResult[0] = 0
EndFunc   ;==>_GDIPlus_Startup

; #FUNCTION# ====================================================================================================================
; Name...........: _GDIPlus_StringFormatCreate
; Description ...: Create a String Format object
; Syntax.........: _GDIPlus_StringFormatCreate([$iFormat = 0[, $iLangID = 0]])
; Parameters ....: $iFormat     - Format flags. Can be one or more of the following:
;                  |0x0001 - Specifies that reading order is right to left
;                  |0x0002 - Specifies that individual lines of text are drawn vertically on the display device
;                  |0x0004 - Specifies that parts of characters are allowed to overhang the string's layout rectangle
;                  |0x0020 - Specifies that Unicode layout control characters are displayed with a representative character
;                  |0x0400 - Specifies that an alternate font is used for characters that are not supported in the requested font
;                  |0x0800 - Specifies that the space at the end of each line is included in a string measurement
;                  |0x1000 - Specifies that the wrapping of text to the next line is disabled
;                  |0x2000 - Specifies that only entire lines are laid out in the layout rectangle
;                  |0x4000 - Specifies that characters overhanging the layout rectangle and text  extending  outside  the  layout
;                  +rectangle are allowed to show
;                  $iLangID     - The language to use
; Return values .: Success      - Handle to a string format object
;                  Failure      - 0
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost
; Remarks .......: When you are done with the String Format object, call _GDIPlus_StringFormatDispose to release the resources
; Related .......: _GDIPlus_StringFormatDispose, _GDIPlus_StringFormatSetAlign
; Link ..........: @@MsdnLink@@ GdipCreateStringFormat
; Example .......: Yes
; ===============================================================================================================================
Func _GDIPlus_StringFormatCreate($iFormat = 0, $iLangID = 0)
	Local $aResult = DllCall($ghGDIPDll, "int", "GdipCreateStringFormat", "int", $iFormat, "word", $iLangID, "ptr*", 0)
	If @error Then Return SetError(@error, @extended, 0)
	__GDIPlus_ObjectDispose_ListAdd($aResult[3], "String")
	Return SetExtended($aResult[0], $aResult[3])
EndFunc   ;==>_GDIPlus_StringFormatCreate

; #FUNCTION# ====================================================================================================================
; Name...........: _GDIPlus_StringFormatDispose
; Description ...: Release a String Format object
; Syntax.........: _GDIPlus_StringFormatDispose($hFormat)
; Parameters ....: $hFormat     - Handle to a String Format object
; Return values .: Success      - True
;                  Failure      - False
; Author ........: Paul Campbell (PaulIA)
; Modified.......: Gary Frost
; Remarks .......:
; Related .......: _GDIPlus_StringFormatCreate
; Link ..........: @@MsdnLink@@ GdipDeleteStringFormat
; Example .......: Yes
; ===============================================================================================================================
Func _GDIPlus_StringFormatDispose($hFormat)
	Local $aResult = DllCall($ghGDIPDll, "int", "GdipDeleteStringFormat", "handle", $hFormat)
	If @error Then Return SetError(@error, @extended, False)
	__GDIPlus_ObjectDispose_ListRemove($hFormat, "String")
	Return $aResult[0] = 0
EndFunc   ;==>_GDIPlus_StringFormatDispose

; #FUNCTION# ====================================================================================================================
; Name...........: _GDIPlus_StringFormatSetAlign
; Description ...: Sets the text alignment of a string format object
; Syntax.........: _GDIPlus_StringFormatSetAlign($hStringFormat,$iFlag)
; Parameters ....: $hStringFormat	- The string format object which is aligned
;                  $iFlag           - The alignment can be one of the following:
;                  |0 - The text is aligned to the left
;                  |1 - The text is centered
;                  |2 - The text is aligned to the right
; Return values .: Success      - 1
;                  Failure      - 0 and @error=1
; Author ........: Andreas Karlsson (monoceres)
; Modified.......:
; Remarks .......:
; Related .......: _GDIPlus_StringFormatCreate
; Link ..........: @@MsdnLink@@ GdipSetStringFormatAlign
; Example .......: Yes
; ===============================================================================================================================
Func _GDIPlus_StringFormatSetAlign($hStringFormat, $iFlag)
	Local $aResult = DllCall($ghGDIPDll, "int", "GdipSetStringFormatAlign", "handle", $hStringFormat, "int", $iFlag)
	If @error Then Return SetError(@error, @extended, 0)
	Return $aResult[0] = 0
EndFunc   ;==>_GDIPlus_StringFormatSetAlign

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name...........: __GDIPlus_BrushDefCreate
; Description ...: Create a default Brush object if needed
; Syntax.........: __GDIPlus_BrushDefCreate(ByRef $hBrush)
; Parameters ....: $hBrush      - Handle to a Brush object
; Return values .: Success      - $hBrush or a default Brush object
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func __GDIPlus_BrushDefCreate(ByRef $hBrush)
	If $hBrush = 0 Then
		$ghGDIPBrush = _GDIPlus_BrushCreateSolid()
		$hBrush = $ghGDIPBrush
	EndIf
EndFunc   ;==>__GDIPlus_BrushDefCreate

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name...........: __GDIPlus_BrushDefDispose
; Description ...: Free default Brush object
; Syntax.........: __GDIPlus_BrushDefDispose()
; Parameters ....:
; Return values .:
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func __GDIPlus_BrushDefDispose()
	If $ghGDIPBrush <> 0 Then
		_GDIPlus_BrushDispose($ghGDIPBrush)
		$ghGDIPBrush = 0
	EndIf
EndFunc   ;==>__GDIPlus_BrushDefDispose

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name...........: __GDIPlus_ExtractFileExt
; Description ...: Extracts the extension part of the given filename
; Syntax.........: __GDIPlus_ExtractFileExt($sFileName[, $fNoDot = True])
; Parameters ....: $sFileName   - Filename
;                  $fNoDot      - Determines whether the filename/extension separator is returned
;                  |True  - The separator is returned with the extension
;                  |False - The separator is not returned with the extension
; Return values .: Success      - Extension part
;                  Failure      - Empty string
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func __GDIPlus_ExtractFileExt($sFileName, $fNoDot = True)
	Local $iIndex = __GDIPlus_LastDelimiter(".\:", $sFileName)
	If ($iIndex > 0) And (StringMid($sFileName, $iIndex, 1) = '.') Then
		If $fNoDot Then
			Return StringMid($sFileName, $iIndex + 1)
		Else
			Return StringMid($sFileName, $iIndex)
		EndIf
	Else
		Return ""
	EndIf
EndFunc   ;==>__GDIPlus_ExtractFileExt

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name...........: __GDIPlus_LastDelimiter
; Description ...: Returns the index of the right most whole character that matches any character in a delimiter string
; Syntax.........: __GDIPlus_LastDelimiter($sDelimiters, $sString)
; Parameters ....: $sDelimiters - Delimiters
;                  $String      - String to be searched
; Return values .: Success      - Right most whole character that matches one of the delimiters
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func __GDIPlus_LastDelimiter($sDelimiters, $sString)
	Local $sDelimiter, $iN

	For $iI = 1 To StringLen($sDelimiters)
		$sDelimiter = StringMid($sDelimiters, $iI, 1)
		$iN = StringInStr($sString, $sDelimiter, 0, -1)
		If $iN > 0 Then Return $iN
	Next
EndFunc   ;==>__GDIPlus_LastDelimiter

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name...........: __GDIPlus_PenDefCreate
; Description ...: Create a default Pen object if needed
; Syntax.........: __GDIPlus_PenDefCreate(ByRef $hPen)
; Parameters ....: $hPen        - Handle to a pen object
; Return values .: Success      - $hPen or a default pen object
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func __GDIPlus_PenDefCreate(ByRef $hPen)
	If $hPen = 0 Then
		$ghGDIPPen = _GDIPlus_PenCreate()
		$hPen = $ghGDIPPen
	EndIf
EndFunc   ;==>__GDIPlus_PenDefCreate

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name...........: __GDIPlus_PenDefDispose
; Description ...: Free default Pen object
; Syntax.........: __GDIPlus_PenDefDispose()
; Parameters ....:
; Return values .:
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func __GDIPlus_PenDefDispose()
	If $ghGDIPPen <> 0 Then
		_GDIPlus_PenDispose($ghGDIPPen)
		$ghGDIPPen = 0
	EndIf
EndFunc   ;==>__GDIPlus_PenDefDispose

; ===============================================================================================================================
; __GDIPlus_ObjectDispose
; ===============================================================================================================================


; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name...........: __GDIPlus_ObjectDispose_ListAdd
; Description ...: Add a Gdi object to dispose list
; Syntax.........: __GDIPlus_ObjectDispose_ListAdd($hWnd, $sType)
; Parameters ....: $hWnd 		- Handle to Gdi Object
;				   $sType		- Dispose type index
;				   | Available Types: "ArrowCap", "Bitmap", "BitmapObj", "Brush", "Cap", "Font", "FontFamily", "Graphics"
;				   | "Image", "Matrix", "Pen", "String"
; Return values .:
; Author ........: Yoriz
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func __GDIPlus_ObjectDispose_ListAdd($hWnd, $sType)
	Local $sString = __GDIPlus_ObjectDispose_Type($sType)
	If Not StringInStr($sString, "|" & $hWnd) Then
		$sString &= "|" & $hWnd
		If $ghGDIPDis_ConsoleOut Then ConsoleWrite($hWnd & " - Added as type: " & $sType & @CR)
		__GDIPlus_ObjectDispose_Type($sType, 1, $sString)
	EndIf
EndFunc   ;==>__GDIPlus_ObjectDispose_ListAdd

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name...........: __GDIPlus_ObjectDispose_ListRemove
; Description ...: Remove a Gdi object to dispose list
; Syntax.........: __GDIPlus_ObjectDispose_ListRemove($hWnd, $sType)
; Parameters ....: $hWnd 		- Handle to Gdi Object
;				   $sType		- Dispose type index
;				   | Available Types: "ArrowCap", "Bitmap", "BitmapObj", "Brush", "Cap", "Font", "FontFamily", "Graphics"
;				   | "Image", "Matrix", "Pen", "String"
; Return values .:
; Author ........: Yoriz
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func __GDIPlus_ObjectDispose_ListRemove($hWnd, $sType)
	Local $sString = __GDIPlus_ObjectDispose_Type($sType)
	If StringInStr($sString, "|" & $hWnd) Then
		$sString = StringReplace($sString, "|" & $hWnd, "")
		If $ghGDIPDis_ConsoleOut And $ghGDIPDis_ManualMode Then ConsoleWrite($hWnd & " - Manually disposed of type: " & $sType & @CR)
		__GDIPlus_ObjectDispose_Type($sType, 1, $sString)
	EndIf
EndFunc   ;==>__GDIPlus_ObjectDispose_ListRemove

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name...........: __GDIPlus_ObjectDispose_All
; Description ...: Calls __GDIPlus_ObjectDispose_DisposeType() for all Disposable Types
; Syntax.........: __GDIPlus_ObjectDispose_All()
; Parameters ....:
; Return values .:
; Author ........: Yoriz
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func __GDIPlus_ObjectDispose_All()
	Local $aObjects, $sString
	If $ghGDIPDis_ConsoleOut Then ConsoleWrite("****** Disposing of GdiPlus Objects Before shuting down dll ******" & @CR)
	__GDIPlus_ObjectDispose_DisposeType("ArrowCap")
	__GDIPlus_ObjectDispose_DisposeType("Bitmap")
	__GDIPlus_ObjectDispose_DisposeType("BitmapObj")
	__GDIPlus_ObjectDispose_DisposeType("Brush")
	__GDIPlus_ObjectDispose_DisposeType("Cap")
	__GDIPlus_ObjectDispose_DisposeType("Font")
	__GDIPlus_ObjectDispose_DisposeType("FontFamily")
	__GDIPlus_ObjectDispose_DisposeType("Graphics")
	__GDIPlus_ObjectDispose_DisposeType("Image")
	__GDIPlus_ObjectDispose_DisposeType("Matrix")
	__GDIPlus_ObjectDispose_DisposeType("Pen")
	__GDIPlus_ObjectDispose_DisposeType("String")
EndFunc   ;==>__GDIPlus_ObjectDispose_All

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name...........: __GDIPlus_ObjectDispose_Type
; Description ...: Controls the storing, recalling and diposing of Gdi Objects
; Syntax.........: __GDIPlus_ObjectDispose_Type($sType, $iFlag = 0, $sString = "")
; Parameters ....: $sType		- Dispose type index
;				   | Available Types: "ArrowCap", "Bitmap", "BitmapObj", "Brush", "Cap", "Font", "FontFamily", "Graphics"
;				   | "Image", "Matrix", "Pen", "String"
;				   $iFlag		- See below
;				   | 0			- Return a string of a certain $sType
;				   | 1			- Store $sString in a string of $sType
;				   | 2			- Dispose of $sType using Gdi Object handle $sString
; Return values .: $iFlag 0 returns $sType variable, $iFlag 1 no reuturn, $iFlag 2 reutrns dispose function success/Fail
; Author ........: Yoriz
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func __GDIPlus_ObjectDispose_Type($sType, $iFlag = 0, $sString = "")
	Switch $sType
		Case "ArrowCap"
			Switch $iFlag
				Case 0
					Return $ghGDIDis_sArrowCap
				Case 1
					$ghGDIDis_sArrowCap = $sString
				Case 2
					Return _GDIPlus_ArrowCapDispose($sString)
			EndSwitch
		Case "Bitmap"
			Switch $iFlag
				Case 0
					Return $ghGDIDis_sBitmap
				Case 1
					$ghGDIDis_sBitmap = $sString
				Case 2
					Return _GDIPlus_BitmapDispose($sString)
			EndSwitch
		Case "BitmapObj"
			Switch $iFlag
				Case 0
					Return $ghGDIDis_sBitmapObj
				Case 1
					$ghGDIDis_sBitmapObj = $sString
				Case 2
					Return _WinAPI_DeleteObject($sString)
			EndSwitch
		Case "Brush"
			Switch $iFlag
				Case 0
					Return $ghGDIDis_sBrush
				Case 1
					$ghGDIDis_sBrush = $sString
				Case 2
					Return _GDIPlus_BrushDispose($sString)
			EndSwitch
		Case "Cap"
			Switch $iFlag
				Case 0
					Return $ghGDIDis_sCap
				Case 1
					$ghGDIDis_sCap = $sString
				Case 2
					Return _GDIPlus_CustomLineCapDispose($sString)
			EndSwitch
		Case "Font"
			Switch $iFlag
				Case 0
					Return $ghGDIDis_sFont
				Case 1
					$ghGDIDis_sFont = $sString
				Case 2
					Return _GDIPlus_FontDispose($sString)
			EndSwitch
		Case "FontFamily"
			Switch $iFlag
				Case 0
					Return $ghGDIDis_sFontFamily
				Case 1
					$ghGDIDis_sFontFamily = $sString
				Case 2
					Return _GDIPlus_FontFamilyDispose($sString)
			EndSwitch
		Case "Graphics"
			Switch $iFlag
				Case 0
					Return $ghGDIDis_sGraphics
				Case 1
					$ghGDIDis_sGraphics = $sString
				Case 2
					Return _GDIPlus_GraphicsDispose($sString)
			EndSwitch
		Case "Image"
			Switch $iFlag
				Case 0
					Return $ghGDIDis_sImage
				Case 1
					$ghGDIDis_sImage = $sString
				Case 2
					Return _GDIPlus_ImageDispose($sString)
			EndSwitch

		Case "Matrix"
			Switch $iFlag
				Case 0
					Return $ghGDIDis_sMatrix
				Case 1
					$ghGDIDis_sMatrix = $sString
				Case 2
					Return _GDIPlus_MatrixDispose($sString)
			EndSwitch
		Case "Pen"
			Switch $iFlag
				Case 0
					Return $ghGDIDis_sPen
				Case 1
					$ghGDIDis_sPen = $sString
				Case 2
					Return _GDIPlus_PenDispose($sString)
			EndSwitch
		Case "String"
			Switch $iFlag
				Case 0
					Return $ghGDIDis_sString
				Case 1
					$ghGDIDis_sString = $sString
				Case 2
					Return _GDIPlus_StringFormatDispose($sString)
			EndSwitch
		Case Else
			Return ""
	EndSwitch
EndFunc   ;==>__GDIPlus_ObjectDispose_Type

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name...........: __GDIPlus_ObjectDispose_DisposeType
; Description ...: Disposes of Gdi Objects of $sType
; Syntax.........: __GDIPlus_ObjectDispose_DisposeType($sType)
; Parameters ....: $sType		- Dispose type index
;				   | Available Types: "ArrowCap", "Bitmap", "BitmapObj", "Brush", "Cap", "Font", "FontFamily", "Graphics"
;				   | "Image", "Matrix", "Pen", "String"
; Return values .:
; Author ........: Yoriz
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func __GDIPlus_ObjectDispose_DisposeType($sType)
	Local $sString = __GDIPlus_ObjectDispose_Type($sType), $aString, $fResult, $hWnd
	$ghGDIPDis_ManualMode = False
	If $sString Then
		$aString = StringSplit(StringTrimLeft($sString, 1), "|")
		For $i = 1 To $aString[0] Step 1
			$hWnd = $aString[$i]
			$fResult = __GDIPlus_ObjectDispose_Type($sType, 2, $hWnd)
			If $ghGDIPDis_ConsoleOut Then
				If $fResult Then
					ConsoleWrite($hWnd & " - Successfully Auto disposed of type: " & $sType & @CR)
				Else
					ConsoleWrite($hWnd & " - Failed to Auto dispose of type: " & $sType & @CR)
				EndIf
			EndIf
		Next
		__GDIPlus_ObjectDispose_Type($sType, 1, 0)
	EndIf
	$ghGDIPDis_ManualMode = True
EndFunc   ;==>__GDIPlus_ObjectDispose_DisposeType