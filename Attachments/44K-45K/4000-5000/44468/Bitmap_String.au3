#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.6.1
 Author:         Matwachich, Thanks UEZ!

 Script Function:
	Simple converting between bitmaps and binary string

#ce ----------------------------------------------------------------------------

#include <GDIPlus.au3>
#include <Memory.au3>

Global Const $InterpolationModeInvalid = -1
Global Const $InterpolationModeDefault = 0
Global Const $InterpolationModeLowQuality = 1
Global Const $InterpolationModeHighQuality = 2
Global Const $InterpolationModeBilinear = 3
Global Const $InterpolationModeBicubic = 4
Global Const $InterpolationModeNearestNeighbor = 5
Global Const $InterpolationModeHighQualityBilinear = 6
Global Const $InterpolationModeHighQualityBicubic = 7

; ##############################################################

Func _BinaryString2hBitmap($pic)
	Local $Bitmap = _BinaryString2Bitmap($pic)
	Local $hBitmap = _GDIPlus_BitmapCreateHBITMAPFromBitmap($Bitmap)
	_GDIPlus_BitmapDispose($Bitmap)
	Return $hbitmap
EndFunc

Func _BinaryString2Bitmap($pic)
	;thanks to ProgAndy for mem allocation lines (now thahanks UEZ for memory leak correction)
	;   http://www.autoitscript.com/forum/topic/132103-udf-g-engin/page__view__findpost__p__920873
	Local $declared = True
    If Not $ghGDIPDll Then
        _GDIPlus_Startup()
        $declared = False
    EndIf
	; ---
	Local $memBitmap, $len, $tMem, $hData, $pData, $hStream, $hBitmapFromStream
    $memBitmap = Binary($pic) ;load image  saved in variable (memory) and convert it to binary
    $len = BinaryLen($memBitmap) ;get length of image

    $hData  = _MemGlobalAlloc($len, $GMEM_MOVEABLE) ;allocates movable memory  ($GMEM_MOVEABLE = 0x0002)
    $pData = _MemGlobalLock($hData)  ;translate the handle into a pointer
    $tMem =  DllStructCreate("byte[" & $len & "]", $pData) ;create struct
    DllStructSetData($tMem, 1, $memBitmap) ;fill struct with image data
    _MemGlobalUnlock($hData) ;decrements the lock count  associated with a memory object that was allocated with GMEM_MOVEABLE

	$hStream = _WinAPI_CreateStreamOnHGlobal($pData) ;Creates a stream object that uses an HGLOBAL memory handle to store the stream contents
    $hBitmapFromStream = _GDIPlus_BitmapCreateFromStream($hStream) ;Creates a Bitmap object based on an IStream COM interface

	Local $tVARIANT = DllStructCreate("word vt;word r1;word r2;word r3;ptr data; ptr")
    DllCall("oleaut32.dll", "long", "DispCallFunc", "ptr", $hStream, "dword", 8 + 8 * @AutoItX64, "dword", 4, "dword", 23, "dword", 0, "ptr", 0, "ptr", 0, "ptr", DllStructGetPtr($tVARIANT))
    $tMem = 0

	If Not $declared Then _GDIPlus_Shutdown()

	Return $hBitmapFromStream
EndFunc

;GDIPlus.au3 must be included; JPG quality: 0 - 100 (worst - best)
;$Bitmap must be a GDI+ compatible bitmap format!!!
Func _Bitmap2BinaryString($Bitmap, $JPEG_Quality = 90) ;code by Andreik, modified by UEZ
    Local $declared = True
    If Not $ghGDIPDll Then
        _GDIPlus_Startup()
        $declared = False
    EndIf
	; ---
    Local $STREAM = _WinAPI_CreateStreamOnHGlobal(0)
    Local $JPG_ENCODER = _GDIPlus_EncodersGetCLSID("JPG")
    Local $TAG_ENCODER = _WinAPI_GUIDFromString($JPG_ENCODER)
    Local $PTR_ENCODER = DllStructGetPtr($TAG_ENCODER)
    Local $tParams = _GDIPlus_ParamInit (1)
    Local $tData = DllStructCreate("int Quality")
    DllStructSetData($tData, "Quality", $JPEG_Quality)
    Local $pData = DllStructGetPtr($tData)
    _GDIPlus_ParamAdd($tParams, $GDIP_EPGQUALITY, 1, $GDIP_EPTLONG, $pData)
    Local $pParams = DllStructGetPtr($tParams)
	_GDIPlus_ImageSaveToStream($Bitmap, $STREAM, $PTR_ENCODER, $pParams)
;~     DllCall($ghGDIPDll, "uint", "GdipSaveImageToStream", "ptr", $Bitmap, "ptr", $STREAM, "ptr", $PTR_ENCODER, "ptr", $pParams)
    $tData = 0
    $tParams = 0
    Local $MEMORY = DllCall("ole32.dll", "uint", "GetHGlobalFromStream", "ptr", $STREAM, "ptr*", 0)
    $MEMORY = $MEMORY[2]
    Local $MEM_SIZE = _MemGlobalSize($MEMORY)
    Local $MEM_PTR = _MemGlobalLock($MEMORY)
    Local $DATA_STRUCT = DllStructCreate("byte[" & $MEM_SIZE & "]", $MEM_PTR)
    Local $DATA = DllStructGetData($DATA_STRUCT, 1)
    Local $tVARIANT = DllStructCreate("word vt;word r1;word r2;word r3;ptr data; ptr")
    DllCall("oleaut32.dll", "long", "DispCallFunc", "ptr", $STREAM, "dword", 8 + 8 * @AutoItX64, "dword", 4, "dword", 23, "dword", 0, "ptr", 0, "ptr", 0, "ptr", DllStructGetPtr($tVARIANT))
    _MemGlobalFree($MEMORY)
	; ---
    If Not $declared Then _GDIPlus_Shutdown()
    Return $DATA
EndFunc

; ##############################################################

Func _GDIPlus_HBitmapToHBitmap($hBitmap, $iWidth, $iHeight, $Quality = $InterpolationModeHighQualityBicubic)
	Local $Bitmap = _GDIPlus_HBitmapToBitmap($hBitmap, $iWidth, $iHeight, $Quality)
	$hBitmap = _GDIPlus_BitmapCreateHBITMAPFromBitmap($Bitmap)
	_GDIPlus_BitmapDispose($Bitmap)
	Return $hBitmap
EndFunc

Func _GDIPlus_HBitmapToBitmap($hBitmap, $iWidth, $iHeight, $Quality = $InterpolationModeHighQualityBicubic)
    Local $declared = True
    If Not $ghGDIPDll Then
        _GDIPlus_Startup()
        $declared = False
    EndIf
    Local $Bitmap = _GDIPlus_BitmapCreateFromHBITMAP($hBitmap)
	; ---
    Local $graphics = _GDIPlus_ImageGetGraphicsContext($Bitmap)
    Local $resizedbitmap = _GDIPlus_BitmapCreateFromGraphics($iWidth, $iHeight, $graphics)
    Local $graphics2 = _GDIPlus_ImageGetGraphicsContext($resizedbitmap)
    _GDIPLUS_GraphicsSetInterpolationMode($graphics2, $Quality)
    _GDIPlus_GraphicsDrawImageRect($graphics2, $Bitmap, 0, 0, $iWidth, $iHeight)
    _GDIPlus_GraphicsDispose($graphics)
    _GDIPlus_GraphicsDispose($graphics2)
    _GDIPlus_BitmapDispose($Bitmap)
   If Not $declared Then _GDIPlus_Shutdown()
   Return $resizedbitmap
EndFunc  ;==>_SavehBitmap
