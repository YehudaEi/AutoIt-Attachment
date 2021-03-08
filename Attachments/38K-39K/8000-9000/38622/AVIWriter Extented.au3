#include-once
#include <WinAPI.au3>

#region AVIWriter UDF
Global Const $OF_CREATE = 0x00001000
Global Const $AVIIF_KEYFRAME = 0x00000010
Global Const $ICMF_CHOOSE_KEYFRAME = 1, $ICMF_CHOOSE_DATARATE = 2
Global Const $AVIERR_UNSUPPORTED = 0x80044065
Global Const $AVIERR_BADPARAM = 0x80044066
Global Const $AVIERR_MEMORY = 0x80044067
Global Const $AVIERR_NOCOMPRESSOR = 0x80044071
Global Const $AVIERR_CANTCOMPRESS = 0x80044075
Global Const $AVIERR_ERROR = 0x800440C7
Global Const $AVIERR_OK = 0
Global $Avi32_Dll

Global Const $ICINFO = _
	"DWORD dwSize;DWORD fccType;DWORD fccHandler;DWORD dwFlags;DWORD dwVersion;DWORD dwVersionICM;" & _
	"WCHAR szName[16];WCHAR szDescription[128];WCHAR szDriver[128];"

;http://msdn.microsoft.com/en-us/library/dd183374(v=vs.85).aspx
Global Const $BITMAPFILEHEADER = "WORD bfType;DWORD bfSize;WORD bfReserved1;WORD bfReserved2;DWORD bfOffBits;"
;~ Global Const $BITMAPFILEHEADER = "align 2;char magic[2];int size;short res1;short res2;ptr offset;"

;http://msdn.microsoft.com/en-us/library/dd183376(v=vs.85).aspx
Global Const $BITMAPINFOHEADER = _
        "dword biSize;long biWidth;long biHeight;short biPlanes;short biBitCount;dword biCompression;" & _
        "dword biSizeImage;long biXPelsPerMeter;long biYPelsPerMeter;dword biClrUsed;dword biClrImportant;"

;http://msdn.microsoft.com/en-us/library/ms899423.aspx
Global Const $AVISTREAMINFO = _
        "dword fccType;dword fccHandler;dword dwFlags;dword dwCaps;short wPriority;short wLanguage;dword dwScale;" & _
        "dword dwRate;dword dwStart;dword dwLength;dword dwInitialFrames;dword dwSuggestedBufferSize;dword dwQuality;" & _
        "dword dwSampleSize;int rleft;int rtop;int rright;int rbottom;dword dwEditCount;dword dwFormatChangeCount;wchar[64];"

;http://msdn.microsoft.com/en-us/library/dd756791(v=VS.85).aspx
Global Const $AVICOMPRESSOPTIONS = _
        "DWORD fccType;DWORD fccHandler;DWORD dwKeyFrameEvery;DWORD dwQuality;DWORD dwBytesPerSecond;" & _
        "DWORD dwFlags;PTR lpFormat;DWORD cbFormat;PTR lpParms;DWORD cbParms;DWORD dwInterleaveEvery;"

;http://www.fourcc.org/codecs.php
Func _Create_mmioFOURCC($FOURCC) ;coded by UEZ
    If StringLen($FOURCC) <> 4 Then Return SetError(1, 0, 0)
    Local $aFOURCC = StringSplit($FOURCC, "", 2)
    Return BitOR(Asc($aFOURCC[0]), BitShift(Asc($aFOURCC[1]), -8), BitShift(Asc($aFOURCC[2]), -16), BitShift(Asc($aFOURCC[3]), -24))
EndFunc   ;==>_Create_mmioFOURCC

Func _DecodeFOURCC($iFOURCC);coded by UEZ
    If Not IsInt($iFOURCC) Then Return SetError(1, 0, 0)
    Return Chr(BitAND($iFOURCC, 0xFF)) & Chr(BitShift(BitAND(0x0000FF00, $iFOURCC), 8)) & Chr(BitShift(BitAND(0x00FF0000, $iFOURCC), 16)) & Chr(BitShift($iFOURCC, 24))
EndFunc   ;==>_DecodeFOURCC

;monoceres, Prog@ndy, UEZ
Func _CreateAvi($sFilename, $FrameRate, $Width, $Height, $BitCount = 24, $mmioFOURCC = "MSVC", $iKeyFrameEvery = 10)
    Local $RetArr[6] ;avi file handle, compressed stream handle, bitmap count, BitmapInfoheader, Stride, stream handle

    Local $aRet, $pFile, $tASI, $tACO, $pStream, $psCompressed

    Local $stride = BitAND(($Width * ($BitCount / 8) + 3), BitNOT(3))

    Local $tBI = DllStructCreate($BITMAPINFOHEADER)
    DllStructSetData($tBI, "biSize", DllStructGetSize($tBI))
    DllStructSetData($tBI, "biWidth", $Width)
    DllStructSetData($tBI, "biHeight", $Height)
    DllStructSetData($tBI, "biPlanes", 1)
    DllStructSetData($tBI, "biBitCount", $BitCount)
    DllStructSetData($tBI, "biSizeImage", $stride * $Height)

    $tASI = DllStructCreate($AVISTREAMINFO)
    DllStructSetData($tASI, "fccType", _Create_mmioFOURCC("vids"))
    DllStructSetData($tASI, "fccHandler", _Create_mmioFOURCC($mmioFOURCC))
    DllStructSetData($tASI, "dwScale", 1)
    DllStructSetData($tASI, "dwRate", $FrameRate)
    DllStructSetData($tASI, "dwQuality", -1) ;Quality is represented as a number between 0 and 10,000. For compressed data, this typically represents the value of the quality parameter passed to the compression software. If set to &#8211;1, drivers use the default quality value.
    DllStructSetData($tASI, "dwSuggestedBufferSize", $stride * $Height)
    DllStructSetData($tASI, "rright", $Width)
    DllStructSetData($tASI, "rbottom", $Height)


;~ 	$tParms = DllStructCreate($ICINFO)
;~ 	DllCall("Msvfw32.dll", "BOOL", "ICInfo", "DWORD", _Create_mmioFOURCC("vidc"), "DWORD", _Create_mmioFOURCC($mmioFOURCC), "ptr", DllStructGetPtr($tParms))

;~     $tACO = DllStructCreate($AVICOMPRESSOPTIONS)
;~     DllStructSetData($tACO, "fccType", _Create_mmioFOURCC("vids"))
;~     DllStructSetData($tACO, "fccHandler", _Create_mmioFOURCC($mmioFOURCC))
;~     DllStructSetData($tACO, "dwKeyFrameEvery", 10)
;~     DllStructSetData($tACO, "dwQuality", 10000)
;~     DllStructSetData($tACO, "dwBytesPerSecond", 0)
;~     DllStructSetData($tACO, "dwFlags", 8)
;~     DllStructSetData($tACO, "lpFormat", 0)
;~     DllStructSetData($tACO, "cbFormat", 0)
;~     DllStructSetData($tACO, "lpParms", DllStructGetPtr($tParms))
;~     DllStructSetData($tACO, "cbParms", DllStructGetSize($tParms))
;~     DllStructSetData($tACO, "dwInterleaveEvery", 0)

    $tACO = DllStructCreate($AVICOMPRESSOPTIONS)
    DllStructSetData($tACO, "fccType", _Create_mmioFOURCC("vids"))
    DllStructSetData($tACO, "fccHandler", _Create_mmioFOURCC($mmioFOURCC))
    DllStructSetData($tACO, "dwKeyFrameEvery", $iKeyFrameEvery)


    $aRet = DllCall($Avi32_Dll, "int", "AVIFileOpenW", "ptr*", 0, "wstr", $sFilename, "uint", $OF_CREATE, "ptr", 0)
    $pFile = $aRet[1]

    $aRet = DllCall($Avi32_Dll, "int", "AVIFileCreateStream", "ptr", $pFile, "ptr*", 0, "ptr", DllStructGetPtr($tASI))
    $pStream = $aRet[2]

    $aRet = DllCall($Avi32_Dll, "int_ptr", "AVISaveOptions", "hwnd", 0, "uint", BitOR($ICMF_CHOOSE_DATARATE, $ICMF_CHOOSE_KEYFRAME), "int", 1, "ptr*", $pStream, "ptr*", DllStructGetPtr($tACO))
    If $aRet[0] <> 1 Then
		$RetArr[0] = $pFile
		$RetArr[1] = $pStream
		$RetArr[2] = 0
		$RetArr[3] = $tBI
		$RetArr[4] = $Stride
		$RetArr[5] = $pStream
        Return SetError(1, 0, $RetArr)
    EndIf

;~     ConsoleWrite(_DecodeFOURCC(DllStructGetData($tACO, "fccHandler")) & @CRLF)

    ;http://msdn.microsoft.com/en-us/library/dd756811(v=VS.85).aspx
    $aRet = DllCall($Avi32_Dll, "int", "AVIMakeCompressedStream", "ptr*", 0, "ptr", $pStream, "ptr", DllStructGetPtr($tACO), "ptr", 0)
    If $aRet[0] <> $AVIERR_OK Then
			$RetArr[0] = $pFile
			$RetArr[1] = $pStream
			$RetArr[2] = 0
			$RetArr[3] = $tBI
			$RetArr[4] = $stride
			$RetArr[5] = $pStream
        Return SetError(2, 0, $RetArr)
    EndIf
    $psCompressed = $aRet[1]

    ;The format for the stream is the same as BITMAPINFOHEADER
    $aRet = DllCall($Avi32_Dll, "int", "AVIStreamSetFormat", "ptr", $psCompressed, "long", 0, "ptr", DllStructGetPtr($tBI), "long", DllStructGetSize($tBI))

    $RetArr[0] = $pFile
    $RetArr[1] = $psCompressed
    $RetArr[2] = 0
    $RetArr[3] = $tBI
    $RetArr[4] = $stride
    $RetArr[5] = $pStream
    Return $RetArr
EndFunc   ;==>_CreateAvi

;Adds a bitmap file to an already opened avi file.
;monoceres, Prog@ndy
Func _AddHBitmapToAvi(ByRef $Avi_Handle, $hBitmap)
    Local $DC = _WinAPI_GetDC(0)
    Local $hDC = _WinAPI_CreateCompatibleDC($DC)
    _WinAPI_ReleaseDC(0, $DC)

    Local $OldBMP = _WinAPI_SelectObject($hDC, $hBitmap)
    Local $bits = DllStructCreate("byte[" & DllStructGetData($Avi_Handle[3], "biSizeImage") & "]")
    _WinAPI_GetDIBits($hDC, $hBitmap, 0, Abs(DllStructGetData($Avi_Handle[3], "biHeight")), DllStructGetPtr($bits), DllStructGetPtr($Avi_Handle[3]), 0)
    _WinAPI_SelectObject($hDC, $OldBMP)
    _WinAPI_DeleteDC($hDC)

    DllCall($Avi32_Dll, "int", "AVIStreamWrite", "ptr", $Avi_Handle[1], "long", $Avi_Handle[2], "long", 1, "ptr", DllStructGetPtr($bits), _
										"long", DllStructGetSize($bits), "long", $AVIIF_KEYFRAME, "ptr*", 0, "ptr*", 0)
    $Avi_Handle[2] += 1
EndFunc   ;==>_AddHBitmapToAvi

;Adds a bitmap file to an already opened avi file.
Func _AddBitmapToAvi(ByRef $Avi_Handle, $sBitmap)
    Local $bm = LoadBitmap($sBitmap, True)
    DllCall($Avi32_Dll, "int", "AVIStreamWrite", "ptr", $Avi_Handle[1], "long", $Avi_Handle[2], "long", 1, "ptr", DllStructGetPtr($bm[2]), _
										"long", DllStructGetSize($bm[2]), "long", $AVIIF_KEYFRAME, "ptr*", 0, "ptr*", 0)
    $Avi_Handle[2] += 1
EndFunc   ;==>_AddBitmapToAvi

;Returns array with 3 elements
;[0]=BITMAPFILEHEADER
;[1]=BITMAPINFOHEADER
;[2]=Bitmap data buffer (if specified)
Func LoadBitmap($sFilename, $LoadData = False)
    Local $RetArr[3]
    Local $byref
    Local $tBIH, $tBFH, $buffer, $fhandle
    $tBFH = DllStructCreate($BITMAPFILEHEADER)
    $tBIH = DllStructCreate($BITMAPINFOHEADER)
    $fhandle = _WinAPI_CreateFile($sFilename, 2, 2, 0, 0)
    _WinAPI_ReadFile($fhandle, DllStructGetPtr($tBFH), DllStructGetSize($tBFH), $byref)
    _WinAPI_ReadFile($fhandle, DllStructGetPtr($tBIH), DllStructGetSize($tBIH), $byref)
    $RetArr[0] = $tBFH
    $RetArr[1] = $tBIH

    If Not $LoadData Then
        _WinAPI_CloseHandle($fhandle)
        Return $RetArr
    EndIf

    $buffer = DllStructCreate("byte[" & DllStructGetData($tBFH, "size") - 54 & "]")
    $RetArr[2] = $buffer
    _WinAPI_ReadFile($fhandle, DllStructGetPtr($buffer), DllStructGetSize($buffer), $byref)
    _WinAPI_CloseHandle($fhandle)

    Return $RetArr
EndFunc   ;==>LoadBitmap

;Init the avi library
Func _StartAviLibrary()
    $Avi32_Dll = DllOpen("Avifil32.dll")
    DllCall($Avi32_Dll, "none", "AVIFileInit")
EndFunc   ;==>_StartAviLibrary

;Release the library
Func _StopAviLibrary()
    DllCall($Avi32_Dll, "none", "AVIFileExit")
    DllClose($Avi32_Dll)
EndFunc   ;==>_StopAviLibrary

Func _CloseAvi($Avi_Handle)
    DllCall($Avi32_Dll, "int", "AVIStreamRelease", "ptr", $Avi_Handle[1])
    DllCall($Avi32_Dll, "int", "AVIStreamRelease", "ptr", $Avi_Handle[5])
    DllCall($Avi32_Dll, "int", "AVIFileRelease", "ptr", $Avi_Handle[0])
EndFunc   ;==>_CloseAvi
#endregion AVIWriter UDF