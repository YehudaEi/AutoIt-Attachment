Global Const $Z_OK = 0
Global Const $Z_STREAM_END = 1
Global Const $Z_NEED_DICT = 2
Global Const $Z_ERRNO = (-1)
Global Const $Z_STREAM_ERROR = (-2)
Global Const $Z_DATA_ERROR = (-3)
Global Const $Z_MEM_ERROR = (-4)
Global Const $Z_BUF_ERROR = (-5)
Global Const $Z_VERSION_ERROR = (-6)

Global Const $Z_NO_COMPRESSION = 0
Global Const $Z_BEST_SPEED = 1
Global Const $Z_BEST_COMPRESSION = 9
Global Const $Z_DEFAULT_COMPRESSION = (-1)

Global $Zlib_Dll = 0


;~ #include "zlib udf.au3"
_Zlib_Startup()
$bin=StringToBinary("hahahahahahahahahahahehe")
$binlen=BinaryLen($bin)

$compressed=_Zlib_CompressBinary($bin)

$uncompressed=_Zlib_UncompressBinary($compressed,$binlen)

MsgBox(64,BinaryToString($bin),"Original:"&@CRLF&$bin&@CRLF&@CRLF&"Compressed: "&@CRLF&$compressed&@CRLF&@CRLF&"Uncompressed: "&@CRLF&$uncompressed)
_Zlib_Shutdown()


; Returns the Zlib version as a string, i.e 3.2.1
Func _Zlib_Version()
	$call = DllCall($Zlib_Dll, "str:cdecl", "zlibVersion")
	Return $call[0]
EndFunc   ;==>_Zlib_Version

; Closes the zlib dll
Func _Zlib_Shutdown()
	DllClose($Zlib_Dll)
EndFunc   ;==>_Zlib_Shutdown

; Opens the zlib dll, default name is zlibwapi.dll
Func _Zlib_Startup($Filename = "zlib1.dll")
	$Zlib_Dll = DllOpen($Filename)
EndFunc   ;==>_Zlib_Startup

; An implementation of the Adler32 checksum included in the zlib lib
Func _Zlib_CalculateAdler32($DataPtr, $DataSize)
	Local Const $ADLER32_BASE = 65521
	$call = DllCall($Zlib_Dll, "ulong:cdecl", "adler32", "ulong", $ADLER32_BASE, "ptr", $DataPtr, "int", $DataSize)
	Return $call[0]
EndFunc   ;==>_Zlib_CalculateAdler32


; Decompresses data, you need to know how large the decompressed data will be.
Func _Zlib_Uncompress($CompressedPtr, $CompressedSize, $UncompressedPtr, $UncompressedSize)
	$call = DllCall($Zlib_Dll, "int:cdecl", "uncompress", "ptr", $UncompressedPtr, "long*", $UncompressedSize, "ptr", $CompressedPtr, "long", $CompressedSize)
	Return $call[0]
EndFunc   ;==>_Zlib_Uncompress

; Compresses data, the output buffer have to be at least InputBuffer + 0.1 % + 12 byte
Func _Zlib_Compress($InBufferPtr, $InBufferSize, $OutBufferPtr, ByRef $OutBufferSize, $CompressionLevel = $Z_DEFAULT_COMPRESSION)
	$call = DllCall($Zlib_Dll, "int:cdecl", "compress2", "ptr", $OutBufferPtr, "long*", $OutBufferSize, "ptr", $InBufferPtr, "long", $InBufferSize, "int", $CompressionLevel)
	$OutBufferSize = $call[2]
	Return $call[0]
EndFunc   ;==>_Zlib_Compress

; Compresses binary data
Func _Zlib_CompressBinary($binary, $CompressionLevel = $Z_DEFAULT_COMPRESSION)
	$InByteArr = DllStructCreate("byte[" & BinaryLen($binary) + 1 & "]")
	DllStructSetData($InByteArr, 1, $binary)
	
	$OutByteArr = DllStructCreate("byte[" & Round(BinaryLen($binary) * 1.0001) + 12 & "]")
	$OutByteArrSize = DllStructGetSize($OutByteArr)
	
	$ret = _Zlib_Compress(DllStructGetPtr($InByteArr), DllStructGetSize($InByteArr), DllStructGetPtr($OutByteArr), $OutByteArrSize, $CompressionLevel)
	
	If $ret <> 0 Then Return $ret
	
	$CompressedBuffer = DllStructCreate("byte[" & $OutByteArrSize & "]", DllStructGetPtr($OutByteArr))
	
	$RetBinary = DllStructGetData($CompressedBuffer, 1)
	Return $RetBinary
EndFunc   ;==>_Zlib_CompressBinary

; Decompresses binary data, you need to know the binary length of the decompressed data
Func _Zlib_UncompressBinary($compressedbinary, $UncompressedBinaryLength)
	$InByteArr = DllStructCreate("byte[" & BinaryLen($compressedbinary) + 1 & "]")
	DllStructSetData($InByteArr, 1, $compressedbinary)
	
	$OutByteArr = DllStructCreate("byte[" & $UncompressedBinaryLength + 1 & "]")

	$ret = _Zlib_Uncompress(DllStructGetPtr($InByteArr), DllStructGetSize($InByteArr), DllStructGetPtr($OutByteArr), DllStructGetSize($OutByteArr))
	
	If $ret <> 0 Then Return $ret
	$WithoutNull = DllStructCreate("byte[" & DllStructGetSize($OutByteArr) - 1 & "]", DllStructGetPtr($OutByteArr))
	Return DllStructGetData($WithoutNull, 1)
EndFunc   ;==>_Zlib_UncompressBinary
