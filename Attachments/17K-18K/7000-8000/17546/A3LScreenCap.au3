#include-once
#include <A3LGDIPlus.au3>
#include <A3LString.au3>

Opt("MustDeclareVars", 1)

; #INDEX# =======================================================================================================================
; Title .........: Screen Capture
; Description ...: This module allows you to copy the screen or a region of the screen and save it to file. Depending on the type
;                  of image, you can set various image parameters such as pixel format, quality and compression.
; Author ........: Paul Campbell (PaulIA)
; ===============================================================================================================================

; #VARIABLES# ===================================================================================================================
  Global $giA3LBMPFormat        = $GDIP_PXF24RGB
  Global $giA3LJPGQuality       = 100
  Global $giA3LTIFColorDepth    = 24
  Global $giA3LTIFCompression   = $GDIP_EVTCOMPRESSIONLZW
; ===============================================================================================================================

; #FUNCTION# ====================================================================================================================
; Description ...: Captures a region of the screen
; Parameters ....: $sFileName   - Full path and extension of the image file
;                  $iLeft       - X coordinate of the upper left corner of the rectangle
;                  $iTop        - Y coordinate of the upper left corner of the rectangle
;                  $iRight      - X coordinate of the lower right corner of the rectangle.  If this is  -1,  the  current  screen
;                  +width will be used.
;                  $iBottom     - Y coordinate of the lower right corner of the rectangle.  If this is  -1,  the  current  screen
;                  +height will be used.
;                  $fCursor     - If True the cursor will be captured with the image
; Return values .: See remarks
; Author ........: Paul Campbell (PaulIA)
; Remarks .......: If FileName is not blank this function will capture the screen and save it to file. If FileName is blank, this
;                  function will capture the screen and return a HBITMAP handle to the bitmap image.  In this case, after you are
;                  finished with the bitmap you must call _API_DeleteObject to delete the bitmap handle.
; Related .......: _API_DeleteObject
; ===============================================================================================================================
Func _ScreenCap_Capture($sFileName="", $iLeft=0, $iTop=0, $iRight=-1, $iBottom=-1, $fCursor=True)
  Local $iH, $iW, $hWnd, $hDDC, $hCDC, $hBMP, $aCursor, $aIcon, $hIcon

  if $iRight  = -1 then $iRight  = _API_GetSystemMetrics($SM_CXSCREEN)
  if $iBottom = -1 then $iBottom = _API_GetSystemMetrics($SM_CYSCREEN)
  if $iRight  < $iLeft then Return SetError(-1, 0, 0)
  if $iBottom < $iTop  then Return SetError(-2, 0, 0)

  $iW   = $iRight  - $iLeft
  $iH   = $iBottom - $iTop
  $hWnd = _API_GetDesktopWindow()
  $hDDC = _API_GetDC($hWnd)
  $hCDC = _API_CreateCompatibleDC($hDDC)
  $hBMP = _API_CreateCompatibleBitmap($hDDC, $iW, $iH)
  _API_SelectObject($hCDC, $hBMP)
  _API_BitBlt($hCDC, 0, 0, $iW, $iH, $hDDC, $iLeft, $iTop, $SRCCOPY)

  if $fCursor then
    $aCursor = _API_GetCursorInfo()
    if $aCursor[1] then
      $hIcon = _API_CopyIcon($aCursor[2])
      $aIcon = _API_GetIconInfo($hIcon)
      _API_DrawIcon($hCDC, $aCursor[3] - $aIcon[2], $aCursor[4] - $aIcon[3], $hIcon)
    endif
  endif

  _API_ReleaseDC($hWnd, $hDDC)
  _API_DeleteDC($hCDC)
  if $sFileName = "" then Return $hBMP

  _ScreenCap_SaveImage($sFileName, $hBMP)
EndFunc

; #FUNCTION# ====================================================================================================================
; Description ...: Captures a screen shot of a specified window
; Parameters ....: $sFileName   - Full path and extension of the image file
;                  $hWnd        - Handle to the window to be captured
;                  $iLeft       - X coordinate of the upper left corner of the client rectangle
;                  $iTop        - Y coordinate of the upper left corner of the client rectangle
;                  $iRight      - X coordinate of the lower right corner of the rectangle
;                  $iBottom     - Y coordinate of the lower right corner of the rectangle
;                  $fCursor     - If True the cursor will be captured with the image
; Return values .: See remarks
; Author ........: Paul Campbell (PaulIA)
; Remarks .......: If FileName is not blank this function will capture the screen and save it to file. If FileName is blank, this
;                  function will capture the screen and return a HBITMAP handle to the bitmap image.  In this case, after you are
;                  finished with the bitmap you must call _API_DeleteObject to delete the bitmap handle.  All coordinates are  in
;                  client coordinate mode.
; Related .......: _API_DeleteObject
; Credits .......: Thanks to SmOke_N for his suggestion for capturing part of the client window
; ===============================================================================================================================
Func _ScreenCap_CaptureWnd($sFileName, $hWnd, $iLeft=0, $iTop=0, $iRight=-1, $iBottom=-1, $fCursor=True)
  Local $tRect

  $tRect  = _API_GetWindowRect($hWnd)
  $iLeft   += DllStructGetData($tRect, "Left")
  $iTop    += DllStructGetData($tRect, "Top" )
  if $iRight  = -1 then $iRight  = DllStructGetData($tRect, "Right" ) - DllStructGetData($tRect, "Left")
  if $iBottom = -1 then $iBottom = DllStructGetData($tRect, "Bottom") - DllStructGetData($tRect, "Top" )
  $iRight  += DllStructGetData($tRect, "Left")
  $iBottom += DllStructGetData($tRect, "Top" )
  if $iLeft   > DllStructGetData($tRect, "Right" ) then $iLeft   = DllStructGetData($tRect, "Left"  )
  if $iTop    > DllStructGetData($tRect, "Bottom") then $iTop    = DllStructGetData($tRect, "Top"   )
  if $iRight  > DllStructGetData($tRect, "Right" ) then $iRight  = DllStructGetData($tRect, "Right" )
  if $iBottom > DllStructGetData($tRect, "Bottom") then $iBottom = DllStructGetData($tRect, "Bottom")
  Return _ScreenCap_Capture($sFileName, $iLeft, $iTop, $iRight, $iBottom, $fCursor)
EndFunc

; #FUNCTION# ====================================================================================================================
; Description ...: Saves an image to file
; Parameters ....: $sFileName   - Full path and extension of the bitmap file to be saved
;                  $hBitmap     - HBITMAP handle
;                  $fFreeBmp    - If True, hBitmap will be freed on a successful save
; Return values .: Success      - True
;                  Failure      - False
; Author ........: Paul Campbell (PaulIA)
; Remarks .......: This function saves a bitmap to file, converting it to the image format specified by the file name  extension.
;                  For Windows XP, the valid extensions are BMP, GIF, JPEG, PNG and TIF.
; Related .......: _ScreenCap_Capture
; ===============================================================================================================================
Func _ScreenCap_SaveImage($sFileName, $hBitmap, $fFreeBmp=True)
  Local $hClone, $sCLSID, $tData, $sExt, $hImage, $pParams, $tParams, $iResult, $iX, $iY

  _GDIP_StartUp()
  if @Error then Return SetError(-1, -1, False)

  $sExt   = StringUpper(_Str_ExtractFileExt($sFileName))
  $sCLSID = _GDIP_EncodersGetCLSID($sExt)
  if $sCLSID = "" then Return SetError(-2, -2, False)
  $hImage = _GDIP_BitmapCreateFromHBITMAP($hBitmap)
  if @Error then Return SetError(-3, -3, False)

  Switch $sExt
    case "BMP"
      $iX = _GDIP_ImageGetWidth ($hImage)
      $iY = _GDIP_ImageGetHeight($hImage)
      $hClone = _GDIP_BitmapCloneArea($hImage, 0, 0, $iX, $iY, $giA3LBMPFormat)
      _GDIP_ImageDispose($hImage)
      $hImage = $hClone
    case "JPG", "JPEG"
      $tParams = _GDIP_ParamInit(1)
      $tData   = DllStructCreate("int Quality")
      DllStructSetData($tData, "Quality", $giA3LJPGQuality)
      _GDIP_ParamAdd($tParams, $GDIP_EPGQUALITY    , 1, $GDIP_EPTLONG, DllStructGetPtr($tData))
    case "TIF", "TIFF"
      $tParams = _GDIP_ParamInit(2)
      $tData   = DllStructCreate("int ColorDepth;int Compression")
      DllStructSetData($tData, "ColorDepth", $giA3LTIFColorDepth)
      DllStructSetData($tData, "Compression", $giA3LTIFCompression)
      _GDIP_ParamAdd($tParams, $GDIP_EPGCOLORDEPTH , 1, $GDIP_EPTLONG, DllStructGetPtr($tData, "ColorDepth" ))
      _GDIP_ParamAdd($tParams, $GDIP_EPGCOMPRESSION, 1, $GDIP_EPTLONG, DllStructGetPtr($tData, "Compression"))
  EndSwitch
  if IsDllStruct($tParams) then $pParams = DllStructGetPtr($tParams)

  $iResult = _GDIP_ImageSaveToFileEx($hImage, $sFileName, $sCLSID, $pParams)
  _GDIP_ImageDispose($hImage)
  if $fFreeBmp then _API_DeleteObject($hBitmap)
  _GDIP_ShutDown()

  Return SetError($iResult, 0, $iResult=0)
EndFunc

; #FUNCTION# ====================================================================================================================
; Description ...: Sets the bit format that will be used for BMP screen captures
; Parameters ....: $iFormat     - Image bits per pixel (bpp) setting:
;                  |0 = 16 bpp; 5 bits for each RGB component
;                  |1 = 16 bpp; 5 bits for red, 6 bits for green and 5 bits blue
;                  |2 = 24 bpp; 8 bits for each RGB component
;                  |3 = 32 bpp; 8 bits for each RGB component. No alpha component.
;                  |4 = 32 bpp; 8 bits for each RGB and alpha component
; Return values .:
; Author ........: Paul Campbell (PaulIA)
; Remarks .......: If not explicitly set, BMP screen captures default to 24 bpp
; Related .......:
; ===============================================================================================================================
Func _ScreenCap_SetBMPFormat($iFormat)
  Switch $iFormat
    case 0
      $giA3LBMPFormat = $GDIP_PXF16RGB555
    case 1
      $giA3LBMPFormat = $GDIP_PXF16RGB565
    case 2
      $giA3LBMPFormat = $GDIP_PXF24RGB
    case 3
      $giA3LBMPFormat = $GDIP_PXF32RGB
    case 4
      $giA3LBMPFormat = $GDIP_PXF32ARGB
    case else
      $giA3LBMPFormat = $GDIP_PXF24RGB
  EndSwitch
EndFunc

; #FUNCTION# ====================================================================================================================
; Description ...: Sets the quality level that will be used for JPEG screen captures
; Parameters ....: $iQuality    - The quality level of the image. Must be in the range of 0 to 100.
; Return values .:
; Author ........: Paul Campbell (PaulIA)
; Remarks .......: If not explicitly set, JPEG screen captures default to a quality level of 100
; Related .......:
; ===============================================================================================================================
Func _ScreenCap_SetJPGQuality($iQuality)
  if $iQuality <   0 then $iQuality = 0
  if $iQuality > 100 then $iQuality = 100
  $giA3LJPGQuality = $iQuality
EndFunc

; #FUNCTION# ====================================================================================================================
; Description ...: Sets the color depth used for TIFF screen captures
; Parameters ....: $iDepth      - Image color depth:
;                  | 0 - Default encoder color depth
;                  |24 - 24 bit
;                  |32 - 32 bit
; Return values .:
; Author ........: Paul Campbell (PaulIA)
; Remarks .......: If not explicitly set, TIFF screen captures default to 24 bits
; Related .......: _ScreenCap_SetTIFFCompression
; ===============================================================================================================================
Func _ScreenCap_SetTIFColorDepth($iDepth)
  Switch $iDepth
    case 24
      $giA3LTIFColorDepth = 24
    case 32
      $giA3LTIFColorDepth = 32
    case else
      $giA3LTIFColorDepth = 0
  EndSwitch
EndFunc

; #FUNCTION# ====================================================================================================================
; Description ...: Sets the compression used for TIFF screen captures
; Parameters ....: $iCompress   - Image compression type:
;                  |0 - Default encoder compression
;                  |1 - No compression
;                  |2 - LZW compression
; Return values .:
; Author ........: Paul Campbell (PaulIA)
; Remarks .......: If not explicitly set, TIF screen captures default to LZW compression
; Related .......: _ScreenCap_SetTIFFColorDepth
; ===============================================================================================================================
Func _ScreenCap_SetTIFCompression($iCompress)
  Switch $iCompress
    case 1
      $giA3LTIFCompression = $GDIP_EVTCOMPRESSIONNONE
    case 2
      $giA3LTIFCompression = $GDIP_EVTCOMPRESSIONLZW
    case else
      $giA3LTIFCompression = 0
  EndSwitch
EndFunc

Opt("MustDeclareVars", 0)