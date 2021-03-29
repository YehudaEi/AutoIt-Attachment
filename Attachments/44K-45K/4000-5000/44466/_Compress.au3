#include-once
#include <GDIPlus.au3>

_GDIPlus_Startup()
OnAutoItExitRegister("_exitCompress")

Func Compress($vData)
	Local $sFormat = "png"
	Local $bImage, $hImage = MakeImage($vData)
	If $hImage Then
		$bImage = GdipImageSaveToVariable($hImage, $sFormat)
		_GDIPlus_ImageDispose($hImage)
	EndIf
	Return BinaryToString($bImage)
EndFunc

Func Decompress($vData)
	Local $hImage = GdipImageLoadFromVariable($vData)
	Local $bNewImage
	If $hImage Then
		$bNewImage = GdipImageSaveToVariable($hImage, "bmp")
		_GDIPlus_ImageDispose($hImage)
	EndIf
	If $bNewImage Then
		Local $iDataSize = BinaryLen($bNewImage)
		Local $iSavedDataSize = Int(BinaryMid($bNewImage, $iDataSize - 3))
		Local $iDiff = $iDataSize - $iSavedDataSize
		Local $bValidData = False
		If ($iDiff > 57) And ($iDiff < 70) Then $bValidData = True
		If $bValidData Then Return BinaryToString(BinaryMid($bNewImage, 55, $iSavedDataSize))
	EndIf
	Return SetError(1, 0, "")
EndFunc

Func IsCompressed($vData)
	Return StringLeft($vData, 4) = "‰PNG"
EndFunc

Func MakeImage($bBinary)
	Local $iLenOr = BinaryLen($bBinary)
	Local $iLen = $iLenOr + 4
	Local $iPadd = Mod($iLen, 12)
	If $iPadd Then $iLen += 12 - $iPadd
	Local $tBinary = DllStructCreate("byte[" & $iLen & "]")
	DllStructSetData($tBinary, 1, $bBinary)
	DllStructSetData(DllStructCreate("dword", DllStructGetPtr($tBinary) + DllStructGetSize($tBinary) - 4), 1, $iLenOr)
	Local $iHeight = $iLen / 12
	Local $iWidth = $iLen / (3 * $iHeight)
	While 1
		If Mod($iHeight, 2) Then ExitLoop
		$iHeight /= 2
		$iWidth *= 2
	WEnd
	Local Const $PixelFormat24bppRGB = 0x21808
	Local $hBitmap = 0
	$hBitmap = GdipCreateBitmapFromScan0($iWidth, $iHeight, $iWidth * 3, $PixelFormat24bppRGB, $tBinary)
	If $hBitmap Then GdipImageRotateFlip($hBitmap, 6) ; RotateNoneFlipY
	Return $hBitmap
EndFunc

Func GdipCreateBitmapFromScan0($iWidth, $iHeight, $iStride = 0, $iPixelFormat = 0, $pScan0 = 0)
	Local $aCall = DllCall($ghGDIPDll, "dword", "GdipCreateBitmapFromScan0", "int", $iWidth, "int", $iHeight, "int", $iStride, "dword", $iPixelFormat, "struct*", $pScan0, "handle*", 0)
	If @error Or $aCall[0] Then Return SetError(1, 0, 0)
	Return $aCall[6]
EndFunc

Func GdipImageRotateFlip($hImage, $iType)
	Local $aCall = DllCall($ghGDIPDll, "dword", "GdipImageRotateFlip", "handle", $hImage, "dword", $iType)
	If @error Or $aCall[0] Then Return SetError(1, 0, 0)
	Return 1
EndFunc

Func GdipImageSaveToVariable($hImage, $sFormat)
	Local $aCall = DllCall($ghGDIPDll, "dword", "GdipGetImageEncodersSize", "dword*", 0, "dword*", 0)
	If @error Or $aCall[0] Then Return SetError(1, 0, "")
	Local $iCount = $aCall[1], $iSize = $aCall[2]
	Local $tBuffer = DllStructCreate("byte[" & $iSize & "]")
	Local $pBuffer = DllStructGetPtr($tBuffer)
	$aCall = DllCall($ghGDIPDll, "dword", "GdipGetImageEncoders", _
			"int", $iCount, _
			"int", $iSize, _
			"struct*", $tBuffer)
	If @error Or $aCall[0] Then Return SetError(2, 0, "")
	Local $tCodec, $sExtension, $pCLSID
	For $i = 1 To $iCount
		$tCodec = DllStructCreate("byte ClassID[16];" & _
				"byte FormatID[16];" & _
				"ptr CodecName;" & _
				"ptr DllName;" & _
				"ptr FormatDescription;" & _
				"ptr FilenameExtension;" & _
				"ptr MimeType;" & _
				"dword Flags;" & _
				"dword Version;" & _
				"dword SigCount;" & _
				"dword SigSize;" & _
				"ptr SigPattern;" & _
				"ptr SigMask", _
				$pBuffer)
		If StringInStr(DllStructGetData(DllStructCreate("wchar[32]", DllStructGetData($tCodec, "FilenameExtension")), 1), $sFormat) Then
			$pCLSID = $pBuffer ; DllStructGetPtr($tCodec, "ClassID")
			ExitLoop
		EndIf
		$pBuffer += DllStructGetSize($tCodec)
	Next
	If Not $pCLSID Then Return SetError(3, 0, "")
	Local Const $sIID_IStream = "{0000000C-0000-0000-C000-000000000046}"
	Local Const $tagIStream = "Read hresult(struct*;dword;dword*);" & _
			"Write hresult(struct*;dword;dword*);" & _ ; ISequentialStream
			"Seek hresult(int64;dword;uint64*);" & _
			"SetSize hresult(uint64);" & _
			"CopyTo hresult(ptr;uint64;uint64*;uint64*);" & _
			"Commit hresult(dword);" & _
			"Revert hresult();" & _
			"LockRegion hresult(uint64;uint64;dword);" & _
			"UnlockRegion hresult(uint64;uint64;dword);" & _
			"Stat hresult(ptr;dword);" & _
			"Clone hresult(ptr*);"
	Local $oStream = ObjCreateInterface(CreateStreamOnHGlobal(), $sIID_IStream, $tagIStream)
	If @error Then Return SetError(2, 0, "")
	$aCall = DllCall($ghGDIPDll, "dword", "GdipSaveImageToStream", _
			"handle", $hImage, _
			"ptr", $oStream(), _
			"ptr", $pCLSID, _
			"ptr", 0)
	Local $err = @error
	If $err Or $aCall[0] Then Return SetError(3, 0, "")
	Local Enum $STREAM_SEEK_SET = 0, $STREAM_SEEK_END = 2
	Local $iSize
	$oStream.Seek(0, $STREAM_SEEK_END, $iSize)
	$oStream.Seek(0, $STREAM_SEEK_SET, 0)
	Local $tBinary = DllStructCreate("byte[" & $iSize & "]")
	Local $iRead
	$oStream.Read($tBinary, $iSize, $iRead)
	Return DllStructGetData($tBinary, 1)
EndFunc

Func CreateStreamOnHGlobal($hGlobal = 0, $iFlag = 1)
	Local $aCall = DllCall("ole32.dll", "long", "CreateStreamOnHGlobal", "handle", $hGlobal, "int", $iFlag, "ptr*", 0)
	If @error Or $aCall[0] Then Return SetError(1, 0, 0)
	Return $aCall[3]
EndFunc

Func GdipImageLoadFromVariable($vImage)
    Local Const $sIID_IStream = "{0000000C-0000-0000-C000-000000000046}"
    Local Const $tagIStreamReadWrite = "Read hresult(struct*;dword;dword*); Write hresult(struct*;dword;dword*);"
    Local $oStream = ObjCreateInterface(CreateStreamOnHGlobal(), $sIID_IStream, $tagIStreamReadWrite)
    If @error Then Return SetError(1, 0, 0)
    Local $tBinary = DllStructCreate("byte[" & BinaryLen($vImage) & "]")
    DllStructSetData($tBinary, 1, $vImage)
    Local $iWritten
    $oStream.Write($tBinary, DllStructGetSize($tBinary), $iWritten)
    Local $hImage = GdipLoadImageFromStream($oStream())
    If @error Then Return SetError(2, 0, 0)
    Return $hImage
EndFunc

Func GdipLoadImageFromStream($pStream)
    Local $aCall = DllCall($ghGDIPDll, "dword", "GdipLoadImageFromStream", _
            "ptr", $pStream, _
            "ptr*", 0)
    If @error Or $aCall[0] Then Return SetError(1, 0, 0)
    Return $aCall[2]
EndFunc

Func _exitCompress()
	_GDIPlus_Shutdown()
EndFunc
