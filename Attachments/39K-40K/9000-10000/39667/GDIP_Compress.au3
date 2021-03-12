
;.......script written by trancexx (trancexx at yahoo dot com)

#include <GDIPlus.au3> ; Gdip based thing, so GDIPlus.au3 is needed

; Picture file to save the image to
$sPic = @ScriptDir & "\Test_Image.png"
; Will save this particular script
$sData = FileRead(@ScriptFullPath)

; And here it is:
SaveAsPic($sData, $sPic)

; ReadFromPic returns binary data. Convert it to string and print to console.
ConsoleWrite(BinaryToString(ReadFromPic($sPic)) & @CRLF)

; Used functions are defined below.
; That's it. Bye, and don't forget to recycle.


;XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
; Returns True in case of success and False otherwise
Func SaveAsPic($vData, $sFile, $sFormat = "png")
	; Initialize GDIPlus
	If _GDIPlus_Startup() Then
		Local $bImage, $hImage = MakeImage($vData)
		If $hImage Then
			; Convert to PNG format
			$bImage = GdipImageSaveToVariable($hImage, $sFormat)
			; Release $hImage object
			_GDIPlus_ImageDispose($hImage)
		EndIf
		; Kill GDIPlus
		_GDIPlus_Shutdown()
		; Write binary to file
		If $bImage Then
			Local $hFile = FileOpen($sFile, 26)
			If $hFile <> -1 Then
				FileWrite($hFile, $bImage)
				FileClose($hFile)
				Return True
			EndIf
		EndIf
	EndIf
	; If here something went wrong
	Return SetError(1, 0, False)
EndFunc

; Returns binary data read from pic file or nothing in case of error
Func ReadFromPic($sFile)
	; Initialize GDIPlus
	If _GDIPlus_Startup() Then
		; Load pic from the file
		Local $hImage = _GDIPlus_ImageLoadFromFile($sFile)
		; Convert to BMP format
		Local $bNewImage
		If $hImage Then
			$bNewImage = GdipImageSaveToVariable($hImage, "bmp")
			; Release $hImage object
			_GDIPlus_ImageDispose($hImage)
		EndIf
		; Kill GDIPlus
		_GDIPlus_Shutdown()
		; Return right size of data found at right position.
		If $bNewImage Then
			; Will do simple check if data is actually valid
			Local $iDataSize = BinaryLen($bNewImage)
			Local $iSavedDataSize = Int(BinaryMid($bNewImage, $iDataSize - 3))
			Local $iDiff = $iDataSize - $iSavedDataSize
			Local $bValidData = False
			; Considering the techique calculated difference must be within [58, 69] range,
			; 54 bytes is BMP header, 4 bytes is appended dword representing size and max padding is 11 bytes.
			If ($iDiff > 57) And ($iDiff < 70) Then $bValidData = True
			If $bValidData Then Return BinaryMid($bNewImage, 55, $iSavedDataSize)
		EndIf
	EndIf
	; If here something went wrong
	Return SetError(1, 0, "")
EndFunc

; Reurns Bitmap object pointer or 0
Func MakeImage($bBinary)
	Local $iLenOr = BinaryLen($bBinary)
	; The idea is to make bitmap image out of raw data.
	; Because BMPs have data aligned, some padding will be often required.
	; In order not to read padded data later, info about the data size should be preserved.
	; I will append dword value to the original data holding the size of it,
	; therefore I must make space for that dword (4 bytes)
	Local $iLen = $iLenOr + 4
	; 24-bit Bitmap will be created. That means every pixel will have 24 bits - that's 3 bytes (RGB).
	; According to BMP specification one line of picture is 4-bytes aligned.
	; For example if 24-bit BMP has 6 pixels and every pixel is of course 3 bytes, that means one line
	; is 20 bytes, 3x6=18 bytes for data plus 2 bytes padding (probably will be filled with 0). That's a wasting space.
	; To use the space as much as possible obviously I should make input 12 bytes aligned.
	Local $iPadd = Mod($iLen, 12)
	If $iPadd Then $iLen += 12 - $iPadd
	; There. $iLen is the number of bytes I must allocate
	Local $tBinary = DllStructCreate("byte[" & $iLen & "]")
	; Filling buffer with passed data
	DllStructSetData($tBinary, 1, $bBinary)
	;... And the last 4 bytes are dword value of tha size info
	DllStructSetData(DllStructCreate("dword", DllStructGetPtr($tBinary) + DllStructGetSize($tBinary) - 4), 1, $iLenOr)
	; Calculate optimal size of the pic
	Local $iHeight = $iLen / 12
	Local $iWidth = $iLen / (3 * $iHeight)
	; Try to make wider pic, for example 4x28 will be turned into 8x14
	While 1
		If Mod($iHeight, 2) Then ExitLoop
		$iHeight /= 2
		$iWidth *= 2
	WEnd
	; Finally create Bitmap
	Local Const $PixelFormat24bppRGB = 0x21808
	Local $hBitmap = 0
	; Initialize GDIPlus
	If _GDIPlus_Startup() Then
		$hBitmap = GdipCreateBitmapFromScan0($iWidth, $iHeight, $iWidth * 3, $PixelFormat24bppRGB, $tBinary)
		; GdipCreateBitmapFromScan0 creates flipped image, get it back by flipping it
		If $hBitmap Then GdipImageRotateFlip($hBitmap, 6) ; RotateNoneFlipY
		; Kill GDIPlus
		_GDIPlus_Shutdown()
	EndIf
	; All done. Return the Bitmap or whatever
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

; Returns binary data of Image in specified format (BMP, PNG,...) or nothing in case of error
; _GDIPlus_Startup() must be called before usage
Func GdipImageSaveToVariable($hImage, $sFormat)
	Local $aCall = DllCall($ghGDIPDll, "dword", "GdipGetImageEncodersSize", "dword*", 0, "dword*", 0)
	; Check for errors
	If @error Or $aCall[0] Then Return SetError(1, 0, "")
	; Read data
	Local $iCount = $aCall[1], $iSize = $aCall[2]
	; Allocate space
	Local $tBuffer = DllStructCreate("byte[" & $iSize & "]")
	Local $pBuffer = DllStructGetPtr($tBuffer)
	; Fill allocated space with Encoders data
	$aCall = DllCall($ghGDIPDll, "dword", "GdipGetImageEncoders", _
			"int", $iCount, _
			"int", $iSize, _
			"struct*", $tBuffer)
	; Check for errors
	If @error Or $aCall[0] Then Return SetError(2, 0, "")
	; Loop through Codecs until right one is found
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
		; Read FilenameExtension field ad see if it's one that's wanted
		If StringInStr(DllStructGetData(DllStructCreate("wchar[32]", DllStructGetData($tCodec, "FilenameExtension")), 1), $sFormat) Then
			$pCLSID = $pBuffer ; DllStructGetPtr($tCodec, "ClassID")
			ExitLoop
		EndIf
		; Go to next struct (by skipping the size of this one)
		$pBuffer += DllStructGetSize($tCodec)
	Next
	; Check for unsupported codec. $pCLSID must have value
	If Not $pCLSID Then Return SetError(3, 0, "")

	; IStream definition
	Local Const $sIID_IStream = "{0000000C-0000-0000-C000-000000000046}"
	; Define IStream methods:
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
	; Create stream object
	Local $oStream = ObjCreateInterface(CreateStreamOnHGlobal(), $sIID_IStream, $tagIStream)
	; Check for errors
	If @error Then Return SetError(2, 0, "")
	; Save Image to that stream.
	$aCall = DllCall($ghGDIPDll, "dword", "GdipSaveImageToStream", _
			"handle", $hImage, _
			"ptr", $oStream(), _
			"ptr", $pCLSID, _
			"ptr", 0)
	; Check for errors
	If @error Or $aCall[0] Then Return SetError(3, 0, "")

	; Read stream size
	Local Enum $STREAM_SEEK_SET = 0, $STREAM_SEEK_END = 2
	Local $iSize
	$oStream.Seek(0, $STREAM_SEEK_END, $iSize)
	; Set stream position to the start of it
	$oStream.Seek(0, $STREAM_SEEK_SET, 0)
	; Allocate space for binary
	Local $tBinary = DllStructCreate("byte[" & $iSize & "]")
	; Read from stream to struct
	Local $iRead
	$oStream.Read($tBinary, $iSize, $iRead)
	; All done
	Return DllStructGetData($tBinary, 1)
EndFunc

Func CreateStreamOnHGlobal($hGlobal = 0, $iFlag = 1)
	Local $aCall = DllCall("ole32.dll", "long", "CreateStreamOnHGlobal", "handle", $hGlobal, "int", $iFlag, "ptr*", 0)
	If @error Or $aCall[0] Then Return SetError(1, 0, 0)
	Return $aCall[3]
EndFunc
;XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX

