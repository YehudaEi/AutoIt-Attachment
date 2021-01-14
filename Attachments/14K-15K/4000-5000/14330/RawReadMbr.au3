;~ ====================================
;~ demo for read sectors on an disk
;~ # be carefull or you can loss data
;~ used some code from larry
;~ 	  APIFileReadWrite.au3 udf http://www.autoitscript.com/forum/index.php?showtopic=12604&st=0&p=86564&#entry86564
;~    Read CD Boot Image, http://www.autoitscript.com/forum/index.php?showtopic=17190&hl=LarryCDImage.
;~ ====================================

#region
#include <String.au3>
Dim $Drive = "C:"
Dim $table[23][3] = [ _
		[0x00, "hex 3", "JMP instruction"], _
		[0x03, "char 8", "SystemID"], _
		[0x0B, "uint 16", "Bytes per sector"], _
		[0x0D, "uint 8", "Sectors per cluster"], _
		[0x0E, "uint 16", "Reserved sectors"], _
		[0x10, "hex 3", "(always zero)"], _
		[0x13, "hex 2", "(unused)"], _
		[0x15, "hex 1", "Media descriptor"], _
		[0x16, "hex 2", "(unused)"], _
		[0x18, "uint 16", "Sectors per track"], _
		[0x1A, "uint 16", "Heads"], _
		[0x1C, "uint 32", "Hidden Sectors"], _
		[0x20, "hex 4", "(unused)" ], _
		[0x24, "hex 4", "(always 80 00 80 00)"], _
		[0x28, "int 64", "Total sectors"], _
		[0x30, "int 64", "Start C# $MFT"], _
		[0x38, "int 64", "Start C# $MFTMirr"], _
		[0x40, "uint 32", "Clust per MFT rec"], _
		[0x44, "uint 32", "Clust per index block"], _
		[0x48, "hex 4", "32-bit serial number (hex)"], _
		[0x48, "hex 8", "64-bit serial number (hex)"], _
		[0x50, "uint 32", "Checksum"], _
		[0x1FE, "hex 2", "Signature (55 AA)"]]

#endregion

#region Open Drive
$f = _APIFileOpen("\\.\" & $Drive, 1)
If $f = "0xFFFFFFFF" Then
	MsgBox(4096, "Error", "Could not open " & $Drive)
	Exit 1
EndIf
#endregion

#region read MBR
_APIFileSetPos($f, 0)
$str = "char[3];char[8];ushort;ubyte;ushort;char[3];char[2];char[1];char[2];ushort;ushort;uint;char[4];char[4];int64;int64;int64;uint;uint;char[4];char[8];uint"

$buffer = DllStructCreate("byte[" & 0x200 & "]")
_BinaryFileRead($f, $buffer)
$pBuffer = DllStructGetPtr($buffer)
$rMbr = DllStructCreate($str, $pBuffer)
$mbr = DllStructGetData($buffer, 1)
#endregion

#region display MBR Data
;~ ConsoleWrite(_StringToHex(DllStructGetData($buffer, 1)) & @CRLF)

For $i = 0 To UBound($table) - 1
	ConsoleWrite($i & @TAB & _readData($mbr, $table[$i][0], $table[$i][1], $i + 1) & ";" & $table[$i][2] & @CRLF)
Next
#endregion

#region end program
$buffer = 0
$pBuffer = 0
$rMbr = 0
$mbr = 0

_APIFileClose($f)

Exit
#endregion


; _APIFileOpen( <FileName> )
;
; Returns a "REAL" file handle for reading and writing.
; The return value comes directly from "CreateFile" api.
Func _APIFileOpen($szFile, $mode = 0)
	Local $GENERIC_READ = 0x80000000, $GENERIC_WRITE = 0x40000000
	Local $STANDARD_RIGHTS_REQUIRED = 0x000f0000
	Local $SYNCHRONIZE = 0x00100000
	Local $FILE_READ_DATA = 0x1
	Local $FILE_ALL_ACCESS = BitOR(0x1FF, $STANDARD_RIGHTS_REQUIRED, $SYNCHRONIZE)
	Local $FILE_SHARE_READ = 1
	Local $FILE_SHARE_WRITE = 2
	Local $OPEN_ALWAYS = 4, $FILE_ATTRIBUTE_NORMAL = 0x00000080
	Local $OPEN_EXISTING = 3
	Local $AFO_h, $AFO_ret
	Local $AFO_bWrite = 1
	If $mode = 0 Then
		$AFO_h = DllCall("kernel32.dll", "hwnd", "CreateFile", _
				"str", $szFile, _
				"long", $FILE_ALL_ACCESS, _
				"long", 7, _
				"ptr", 0, _
				"long", $OPEN_ALWAYS, _
				"long", $FILE_ATTRIBUTE_NORMAL, _
				"long", 0)
	EndIf
	If $mode = 1 Or $AFO_h[0] = 0xFFFFFFFF Then
		$AFO_bWrite = 0
		$AFO_h = DllCall("kernel32.dll", "hwnd", "CreateFile", _
				"str", $szFile, _
				"long", $GENERIC_READ, _
				"long", BitOR($FILE_SHARE_WRITE, $FILE_SHARE_READ), _
				"ptr", 0, _
				"long", $OPEN_EXISTING, _
				"long", $FILE_ATTRIBUTE_NORMAL, _
				"long", 0)

	EndIf
	$AFO_ret = DllCall("kernel32.dll", "int", "GetLastError")
	SetExtended($AFO_bWrite)
	SetError($AFO_ret[0])
	Return $AFO_h[0]
EndFunc   ;==>_APIFileOpen

; _APIFileClose( <FileHandle> )
;
; The return value comes directly from "CloseHandle" api.
Func _APIFileClose(ByRef $hFile)
	Local $AFC_r
	$AFC_r = DllCall("kernel32.dll", "int", "CloseHandle", _
			"hwnd", $hFile)
	Return $AFC_r[0]
EndFunc   ;==>_APIFileClose


; _APIFileSetPos( <FileHandle>, <Position in the file to read/write to/from> )
;
; The return value comes directly from "SetFilePointer" api.
Func _APIFileSetPos(ByRef $hFile, $nPos)
	Local $FILE_BEGIN = 0
	Local $AFSP_r
	$AFSP_r = DllCall("kernel32.dll", "long", "SetFilePointer", _
			"hwnd", $hFile, _
			"long", $nPos, _
			"long_ptr", 0, _
			"long", $FILE_BEGIN)
	Return $AFSP_r[0]
EndFunc   ;==>_APIFileSetPos


; _BinaryFileRead( <FileHandle>, <ptr buffer>)
;
; Reads file into struct <ptr buffer>
; Return from ReadFile api.
Func _BinaryFileRead(ByRef $hFile, ByRef $buff_ptr, $buff_bytes = 0)
	Local $AFR_r
	If $buff_bytes = 0 Then $buff_bytes = DllStructGetSize($buff_ptr)
	$AFR_r = DllCall("kernel32.dll", "int", "ReadFile", _
			"hwnd", $hFile, _
			"ptr", DllStructGetPtr($buff_ptr), _
			"long", $buff_bytes, _
			"long_ptr", 0, _
			"ptr", 0)
	SetExtended($AFR_r[3])
	Return $AFR_r[0]
EndFunc   ;==>_BinaryFileRead


Func _readData($data, $pos, $len, $i)
	Dim $tmp, $tmp1
	$pos = $pos + 0x01	;sting begins with 1
	If Not IsInt($len) Then
		$array = StringSplit($len, " ")
		Switch $array[1]
			Case "int"
				Return DllStructGetData($rMbr, $i)
			Case "uint"
				Return DllStructGetData($rMbr, $i)
			Case "hex"
				$len = $array[2]
				Return _StringToHex(StringMid($data, $pos, $len))
			Case "char"
				$len = $array[2]
				Return StringMid($data, $pos, $len)
			Case Else
				Return"What are you still doing up?"
		EndSwitch
	EndIf
	Return _StringToHex(StringMid($data, $pos, $len))
EndFunc   ;==>_readData