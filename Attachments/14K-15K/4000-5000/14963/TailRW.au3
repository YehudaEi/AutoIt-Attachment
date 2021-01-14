;TailRW.au3   ;  based on "APIRW.au3""
; ------------------------------------------------------------------------------
; AutoIt Version: 3.0
; Language:       English
; Description:    Functions that assist with reading binary files./ writing to tail by line number fast/ writing to any line
;Author	:		 Write tail etc by Randallc; original binary by Larry, Zedna [binary wites by EriFash?]
; ------------------------------------------------------------------------------
#include-once
#include <File.au3>
#include <array.au3>
#include <string.au3>
Func _BinRead($sFile)
	;##############################
	; _BinRead( <FileName> )
	;
	; Reads any file into a string in hex format.
	;
	; Return - file contents in hex
	;##############################
	Local $GENERIC_READ = 0x80000000, $OPEN_ALWAYS = 4, $FILE_ATTRIBUTE_NORMAL = 0x00000080, $hDLL = DllOpen("kernel32.dll"), $iBytes = FileGetSize($sFile), $AFR_ret = "", $hFile = DllCall($hDLL, "hwnd", "CreateFile", "str", $sFile, "long", $GENERIC_READ, "long", 0, "ptr", 0, "long", $OPEN_ALWAYS, "long", $FILE_ATTRIBUTE_NORMAL, "long", 0), $AFR_ptr = DllStructCreate("byte[" & $iBytes & "]"), $AFR_r = DllCall($hDLL, "int", "ReadFile", "hwnd", $hFile[0], "ptr", DllStructGetPtr($AFR_ptr), "long", $iBytes, "long_ptr", 0, "ptr", 0)
	For $i = 1 To $AFR_r[4]
		$AFR_ret = $AFR_ret & Hex(DllStructGetData($AFR_ptr, 1, $i), 2)
	Next
	$AFR_ptr = "";DllStructDelete($AFR_ptr)
	DllCall($hDLL, "int", "CloseHandle", "hwnd", $hFile[0])
	DllClose($hDLL)
	Return $AFR_ret
EndFunc   ;==>_BinRead
Func _BinWrite($sFile, $sHex)
	;##############################
	; _BinWrite( <FileName>, <String> )
	;
	; Writes a hex formatted string to a file.
	;
	; Return - idk...
	;##############################
	Local $GENERIC_WRITE = 0x40000000, $OPEN_ALWAYS = 4, $FILE_ATTRIBUTE_NORMAL = 0x00000080, $c = -1, $hDLL = DllOpen("kernel32.dll"), $iBytes = StringLen($sHex) / 2, $hFile = DllCall($hDLL, "hwnd", "CreateFile", "str", $sFile, "long", $GENERIC_WRITE, "long", 0, "ptr", 0, "long", $OPEN_ALWAYS, "long", $FILE_ATTRIBUTE_NORMAL, "long", 0), $AFW_ptr = DllStructCreate("byte[" & $iBytes & "]")
	For $i = 1 To $iBytes
		$c = $c + 2
		DllStructSetData($AFW_ptr, 1, Dec(StringMid($sHex, $c, 2)), $i)
	Next
	Local $AFW_r = DllCall($hDLL, "int", "WriteFile", "hwnd", $hFile[0], "ptr", DllStructGetPtr($AFW_ptr), "long", $iBytes, "long_ptr", 0, "ptr", 0)
	$AFR_ptr = "";DllStructDelete($AFR_ptr)
	DllCall($hDLL, "int", "CloseHandle", "hwnd", $hFile[0])
	DllClose($hDLL)
	SetError($AFW_r[0])
	Return $AFW_r[4]
EndFunc   ;==>_BinWrite
Func _LastErr($hDLL = "kernel32.dll")
	;##############################
	; _LastErr( [ <handle of kernel32.dll if already opened> ] )
	;
	; Gets the last api error.
	;
	; Return - value from GetLastError api
	;##############################
	Local $err = DllCall($hDLL, "int", "GetLastError")
	Return $err[0]
EndFunc   ;==>_LastErr
Func _APIFileOpen($sFile)
	;##############################
	; _APIFileOpen( <FileName> )
	;
	; Creates a "REAL" file handle for reading and writing.
	;
	; Return - value from CreateFile api
	;##############################
	Local $GENERIC_READ = 0x80000000, $GENERIC_WRITE = 0x40000000, $OPEN_ALWAYS = 4, $FILE_ATTRIBUTE_NORMAL = 0x00000080
	Local $AFO_h ,$FILE_SHARE_READ = 0x00000001,$OPEN_EXISTING = 3,$FILE_READ_DATA = 1
	$AFO_h = DllCall("kernel32.dll", "hwnd", "CreateFile", "str", $sFile, "long", $GENERIC_READ, "long", 7, "ptr", 0, "long", $OPEN_EXISTING, "long", $FILE_ATTRIBUTE_NORMAL, "long", 0)
	Return $AFO_h[0]
EndFunc   ;==>_APIFileOpen
Func _APIFileClose($hFile)
	;##############################
	; _APIFileClose( <FileHandle> )
	;
	; Return - value from CloseHandle api
	;##############################
	Local $AFC_r
	$AFC_r = DllCall("kernel32.dll", "int", "CloseHandle", "hwnd", $hFile)
	Return $AFC_r[0]
EndFunc   ;==>_APIFileClose
Func _APIFileSetPos($hFile, $nPos)
	;##############################
	; _APIFileSetPos( <FileHandle>, <Position in the file to read/write to/from> )
	;
	; Return - value from SetFilePointer api
	;##############################
	Local $FILE_BEGIN = 0
	Local $AFSP_r = DllCall("kernel32.dll", "long", "SetFilePointer", "hwnd", $hFile, "long", $nPos, "long_ptr", 0, "long", $FILE_BEGIN)
	Return $AFSP_r[0]
EndFunc   ;==>_APIFileSetPos
Func _APIFileRead($hFile, $nBytes, $Option = 0)
	;##############################
	; _APIFileRead( <FileHandle>, <Number of Bytes to read>, [ <Option 0=String | 1=Binary(hex)> ] )
	;
	; Binary is comma delimited Hex values.
	;
	; Return - the data read
	;          sets @error to the return from ReadFile api
	;##############################
;~ 	$timer = TimerInit()
	Local $AFR_r, $AFR_n, $AFR_str, $AFR_ret = ""
	If $Option = 0 Then
		$AFR_str = DllStructCreate("char[" & $nBytes & "]")
	Else
		$AFR_str = DllStructCreate("byte[" & $nBytes & "]")
	EndIf
	$AFR_r = DllCall("kernel32.dll", "int", "ReadFile", "hwnd", $hFile, "ptr", DllStructGetPtr($AFR_str), "long", $nBytes, "long_ptr", 0, "ptr", 0)
	If $Option = 0 Then
		$AFR_ret = StringLeft(DllStructGetData($AFR_str, 1), $AFR_r[4])
	Else
		For $AFR_n = 1 To $AFR_r[4]
			$AFR_ret = $AFR_ret & Hex(DllStructGetData($AFR_str, 1, $AFR_n), 2) & ","
		Next
		$AFR_ret = StringTrimRight($AFR_ret, 1)
	EndIf
	SetError($AFR_r[0])
	$AFR_ptr = "";DllStructDelete($AFR_ptr)
;~ 	ConsoleWrite("_APIFileRead time=" & TimerDiff($timer) & @LF)
	Return $AFR_ret
EndFunc   ;==>_APIFileRead
Func _APIFileWrite($hFile, $szData, $Option = 0)
	;##############################
	; _APIFileWrite( <FileHandle>, <Data to Write>, [ <Option 0=String | 1=Binary(hex)> ] )
	;
	; For binary <Data to Write> must be comma delimited hex values.
	;
	; Return - # of Bytes written
	;          sets @error to the return from WriteFile api
	;##############################
;~ 	$timerw = TimerInit()
	Local $AFW_r, $AFW_n, $AFW_i, $AFW_ptr
	If $Option = 0 Then
		$AFW_n = StringLen($szData)
		$AFW_ptr = DllStructCreate("char[" & $AFW_n + 1 & "]");+1; workaround fix
		DllStructSetData($AFW_ptr, 1, String($szData))
	Else
		$szData = StringSplit($szData, ",")
		$AFW_n = $szData[0]
		$AFW_ptr = DllStructCreate("byte[" & $AFW_n & "]")
		For $AFW_i = 1 To $AFW_n
			DllStructSetData($AFW_ptr, 1, Dec($szData[$AFW_i]), $AFW_i)
		Next
	EndIf
	$AFW_r = DllCall("kernel32.dll", "int", "WriteFile", "hwnd", $hFile, "ptr", DllStructGetPtr($AFW_ptr), "long", $AFW_n, "long_ptr", 0, "ptr", 0)
	SetError($AFW_r[0])
	$AFR_ptr = "";DllStructDelete($AFR_ptr)
;~ 	ConsoleWrite("_APIFileWrite time=" & TimerDiff($timerw) & @LF)
	Return $AFW_r[4]
EndFunc   ;==>_APIFileWrite
Func _BinaryFileRead(ByRef $hFile, ByRef $buff_ptr, $buff_bytes = 0)
	;##############################
	; _BinaryFileRead( <FileHandle>, <ptr buffer>, [ <buffer bytes=0> ] )
	;
	; Reads file into struct <ptr buffer>.
	;
	; Return - value from ReadFile api
	;##############################
	Local $AFR_r
	If $buff_bytes = 0 Then $buff_bytes = DllStructGetSize($buff_ptr)
	$AFR_r = DllCall("kernel32.dll", "int", "ReadFile", "hwnd", $hFile, "ptr", DllStructGetPtr($buff_ptr), "long", $buff_bytes, "long_ptr", 0, "ptr", 0)
	Return $AFR_r[0]
EndFunc   ;==>_BinaryFileRead
Func _BinaryFileWrite(ByRef $hFile, ByRef $buff_ptr, $buff_bytes = 0)
	;##############################
	; _BinaryFileWrite( <FileHandle>, <ptr buffer>, [ <buffer bytes=0> ] )
	;
	; Return - # of bytes written
	;          sets @error to the return from WriteFile api
	;##############################
	Local $AFW_r
	If $buff_bytes = 0 Then $buff_bytes = DllStructGetSize($buff_ptr)
	$AFW_r = DllCall("kernel32.dll", "int", "WriteFile", "hwnd", $hFile, "ptr", DllStructGetPtr($buff_ptr), "long", $buff_bytes, "long_ptr", 0, "ptr", 0)
	SetError($AFW_r[0])
	Return $AFW_r[4]
EndFunc   ;==>_BinaryFileWrite
Func _APIFileSetEnd($hFile)
	; _APIFileSetEnd( <FileHandle> )
	;
	; function moves the end-of-file (EOF) to the current position of the file pointer
	; The return value comes directly from "SetEndOfFile" api.
	; If the function succeeds, the return value is nonzero. If it fail, return zero.
;~ 	$timer = TimerInit()
	Local $AFSP_r
	$AFSP_r = DllCall("kernel32.dll", "int", "SetEndOfFile", _
			"hwnd", $hFile)
;~ 	ConsoleWrite("_APIFileSetEnd time=" & TimerDiff($timer) & @LF)
	Return $AFSP_r[0]
EndFunc   ;==>_APIFileSetEnd
Func _CharInsertByByte($s_FileRead, $textInsertF, $i_StartByte, $i_Replace = 1, $i_Tail = 0, $i_Buff = 50000000, $i_Hex = 0)
	If $i_Replace < 0 Then $i_Replace = 0
	$s_FileCopy = @ScriptDir & "\APIwwritecopy.txt"
	;==============================================
;~ 	$s_FileCopy2 = @ScriptDir & "\APIwwritecopy2.txt"
;~ 	FileCopy($s_FileRead, $s_FileCopy2, 1)
;~ 	FileOpen($s_FileCopy2,0)
;~ 	$timercc = TimerInit()
;~ 	$s_TextReadBin2 = FileRead($s_FileCopy2)
;~ 	ConsoleWrite("StringLen($s_TextReadBin2)=" & StringLen($s_TextReadBin2) & @LF)
;~ 	ConsoleWrite("FileRead time=" & TimerDiff($timercc) & @LF)
	;==============================================
	If $i_Replace = 1 Then ; $i_Replace gives number of bytes along to end of current string
		$h_File = _APIFileOpen($s_FileRead)
		_APIFileSetPos($h_File, $i_StartByte - 1)
		_APIFileWrite($h_File, $textInsertF)
		_APIFileClose($h_File)
	ElseIf $i_Tail <> 0 Then ; and therefore $i_Replace =0 or >1
		$h_File = _APIFileOpen($s_FileRead);1
		_APIFileSetPos($h_File, $i_StartByte - 1 + $i_Replace);5 ;read first
		$s_TextReadBin = _APIFileRead($h_File, $i_Tail);6
		_APIFileSetPos($h_File, $i_StartByte - 1) ;2;then write new line
		_APIFileWrite($h_File, StringTrimRight($textInsertF, 2) & @CRLF);3
		_APIFileSetEnd($h_File);4
		_APIFileWrite($h_File, $s_TextReadBin);8
		_APIFileClose($h_File)
	Else ; $i_Replace gives number of bytes along to end of current string
		$timerc = TimerInit()
		FileCopy($s_FileRead, $s_FileCopy, 1)
		ConsoleWrite("FileCopy time=" & TimerDiff($timerc) & @LF)
		$h_File = _APIFileOpen($s_FileRead);1
		$h_Copy = _APIFileOpen($s_FileCopy)
		_APIFileSetPos($h_Copy, $i_StartByte - 1);2
		_APIFileWrite($h_Copy, $textInsertF);3
		_APIFileSetEnd($h_Copy);4
		$i_StringLen = StringLen($textInsertF)
		For $a = 0 To FileGetSize($s_FileRead) / $i_Buff
			If ($i_StartByte - 1 + $a * $i_Buff + $i_Replace) < FileGetSize($s_FileRead) - 2 Then ;don't read if within 1 of eof
				_APIFileSetPos($h_File, $i_StartByte - 1 + $a * $i_Buff + $i_Replace);5
				$s_TextReadBin = _APIFileRead($h_File, $i_Buff);6
				;==============================================
;~ 				$timercc = TimerInit()
;~ 				FileWrite($s_FileCopy2,$s_TextReadBin)
;~ 				ConsoleWrite("FileWrite time=" & TimerDiff($timercc) & @LF)
				;==============================================
				_APIFileSetPos($h_Copy, $i_StartByte - 1 + $i_StringLen + $a * $i_Buff);7
				_APIFileWrite($h_Copy, $s_TextReadBin);8
			EndIf
		Next
		_APIFileClose($h_Copy)
		_APIFileClose($h_File)
		$timerm = TimerInit()
		FileMove($s_FileCopy, $s_FileRead, 1)
		ConsoleWrite("FileMove time=" & TimerDiff($timerm) & @LF)
	EndIf
	;==============================================
;~ 	FileClose($s_FileCopy2)
	;==============================================
EndFunc   ;==>_CharInsertByByte
Func _FileCountLinesBinary($s_1stFile, $i_LineNumber = -1, $i_BeginningF = 1, $i_BufferSize = 8388608) ; Compare two files to see if their content match
	;===============================================================================
	;
	; Function Name:   _FileCountBinary()
	; Description:      Count @LF s till appropriate number or EOF
	; Parameter(s):     $s_1stFile		- Complete path to first file to compare
	;                   $i_BufferSize	- BufferSize to use during compare (optionnal).
	; Requirement(s):   Requires AutoIT 3.1.1.77 minimum
	; Return Value(s):  On Success - Returns 1
	;                   On Failure - Returns 0 and sets the @error flag in the following fashion:
	;					@error = 1 - Wrong version of AutoIT (minimum = 3.1.1.77)
	;					@error = 2 - ; the  files doesn't exist
	;					@error = 3 - ; file size <0 (duh!)
	;					@error = 4 - Bad buffer size
	;					@error = 5 - Cannot compare complete file (increase BufferSize)
	;					@error = 6 - Cannot open file for read
	;					@error = 7 - Content doesn't match (compare fail)
	;					@extended = Offset (in bytes) of first difference
	; Remarks:			Low buffer values result in poor performance
	; Author(s):        Louis Horvath (celeri@videotron.ca)
	;
	;===============================================================================
	If $i_BeginningF = 0 Then $i_Divisor = 1 ;tail
	If $i_BeginningF = 1 Then $i_Divisor = 50; beginning
	If $i_BeginningF = 2 Then $i_Divisor = 3 ; ;middle
	Local $h_1stFile, $h_2ndFile, $i_Loop1, $i_Loop2, $i_ChunkOffset, $i_ByteOffset, $i_DeBug
	Local $i_CountLFtotal, $ar_Return[4], $i_ByteOffsetLast, $i_PosLast, $i_ByteOffsetPrev
;~ 	$i_DeBug = 1
	If $i_DeBug Then ConsoleWrite(" $i_BufferSize=" & $i_BufferSize & @LF)
	If $i_DeBug Then ConsoleWrite(" $i_LineNumber=" & $i_LineNumber & @LF)
	; Basic sanity checks
	If Not StringLen(Chr(0)) Then
		SetError(1) ; Cannot detect character "0" then wrong version of AutoIT ...
		Return 0
	EndIf
	If Not FileExists($s_1stFile) Then
		SetError(2) ; the  files doesn't exist
		Return 0
	EndIf
	$i_FileGetSize = FileGetSize($s_1stFile)
	If $i_BufferSize > $i_FileGetSize / $i_Divisor Then $i_BufferSize = Int($i_FileGetSize / $i_Divisor) + 1
	If $i_BeginningF = 1 And $i_BufferSize > $i_LineNumber * 256 Then $i_BufferSize = $i_LineNumber * 256
;~ 	If $i_BeginningF = 1 And $i_BufferSize > 8192 Then $i_BufferSize = 8192
	If $i_DeBug Then ConsoleWrite("NEW $i_BufferSize=" & $i_BufferSize & @LF)
	If $i_DeBug Then ConsoleWrite("NEW $i_BeginningF=" & $i_BeginningF & @LF)
	If $i_DeBug Then ConsoleWrite("NEW $i_Divisor=" & $i_Divisor & @LF)
	If Not $i_FileGetSize Then
		SetError(3) ; file size <0 (duh!)
		Return 0
	EndIf
	If (Not IsInt($i_BufferSize)) Or ($i_BufferSize < 1 And $i_BufferSize > 65536) Then
		SetError(4) ; Bad buffer size
		Return 0
	EndIf
	If $i_FileGetSize > $i_BufferSize * 999999999 Then
		SetError(5) ; Cannot check complete file (increase BufferSize)
		Return 0
	EndIf
	$h_1stFile = FileOpen($s_1stFile, 0) ; Open the first file
	If $h_1stFile = -1 Then
		SetError(6) ; Cannot open file
		Return 0
	EndIf
	For $i_Loop1 = 1 To 999999999 ; Binary compare of both files. For/Next for speed
		$i_ChunkOffset = $i_BufferSize* ($i_Loop1 - 1) ; How many chunks have been processed * buffer size
		$b_Source = FileRead($h_1stFile, $i_BufferSize) ; Get chunk of first file
		If @error = -1 Then
			If ($i_LineNumber - $i_CountLFtotal) = 1 Then
				$i_CountLFtotal += 1
				$i_ByteOffsetPrev = $i_ByteOffset
				$i_ByteOffset = $i_FileGetSize + 2
			EndIf
			ExitLoop
		EndIf
		If StringInStr($b_Source, Chr(10)) Then ; If there is a LF in the buffer
			$ar_CountLFtemp = StringSplit($b_Source, @LF)
			$i_CountLFtemp = UBound($ar_CountLFtemp) - 2
			If $i_LineNumber > 0 Then  ; line number IS defined
				If $i_DeBug Then ConsoleWrite(" $i_CountLFtemp=" & $i_CountLFtemp & @LF)
				$i_NumberMoreLFs = $i_LineNumber - $i_CountLFtotal
				If $i_DeBug Then ConsoleWrite(" $i_NumberMoreLFs =" & $i_NumberMoreLFs & @LF)
				If $i_CountLFtemp > $i_NumberMoreLFs Then $i_CountLFtemp = $i_NumberMoreLFs
				If $i_DeBug Then ConsoleWrite(" $i_CountLFtemp =" & $i_CountLFtemp & @LF)
				If $i_DeBug Then ConsoleWrite("  StringInStr($b_Source, Chr(10), 0, $i_CountLFtemp) =" & StringInStr($b_Source, Chr(10), 0, $i_CountLFtemp) & @LF)
				$i_ByteOffset = $i_ChunkOffset + StringInStr($b_Source, Chr(10), 0, $i_CountLFtemp)
				If $i_DeBug Then ConsoleWrite(" $i_ByteOffset =" & $i_ByteOffset & @LF)
				If $i_CountLFtemp > 1 Then $i_ByteOffsetPrev = $i_ChunkOffset + StringInStr($b_Source, Chr(10), 0, $i_CountLFtemp - 1)
				If $i_CountLFtemp <= 1 Then $i_ByteOffsetPrev = $i_ByteOffsetLast
				If $i_DeBug Then ConsoleWrite(" $i_ByteOffsetPrev =" & $i_ByteOffsetPrev & @LF)
				$i_ByteOffsetLast = $i_ChunkOffset + StringInStr($b_Source, Chr(10), 0, -1) ; Yup so that's where the difference is.
				If $i_DeBug Then ConsoleWrite(" $i_ByteOffsetLast =" & $i_ByteOffsetLast & @LF)
				$i_CountLFtotal += $i_CountLFtemp
				If $i_DeBug Then ConsoleWrite(" $i_CountLFtotal =" & $i_CountLFtotal & @LF)
				If $i_DeBug Then ConsoleWrite(";======================================================================================== " & @LF)
				If $i_DeBug Then ConsoleWrite(" $i_LineNumber - $i_CountLFtotal =" & $i_LineNumber - $i_CountLFtotal & @LF)
				If ($i_LineNumber - $i_CountLFtotal) = 0 Then ExitLoop
			ElseIf $i_ChunkOffset + $i_BufferSize >= $i_FileGetSize - 1 Then ;at the end of the buffers; line number IS NOT defined
				$i_NumberMoreLFs = $i_LineNumber - $i_CountLFtotal
				$i_Pos = StringInStr($b_Source, Chr(10), 0, -1)
				$i_ByteOffset = $i_ChunkOffset + $i_Pos ; Yup so that's where the difference is.
				$i_CountLFtotal += $i_CountLFtemp
				ExitLoop
			Else ;not yet at the end of the buffers; line number IS NOT defined
				$i_NumberMoreLFs = $i_LineNumber - $i_CountLFtotal
				$i_Pos = StringInStr($b_Source, Chr(10), 0, $i_NumberMoreLFs)
				$i_ByteOffset = $i_ChunkOffset + $i_Pos ; Yup so that's where the difference is.
				$i_PosLast = StringInStr($b_Source, Chr(10), 0, -1)
				$i_ByteOffsetLast = $i_ChunkOffset + $i_PosLast ; Yup so that's where the difference is.
				$i_CountLFtotal += $i_CountLFtemp
			EndIf
		EndIf
		$i_ByteOffset = $i_ByteOffsetLast
	Next
	FileClose($h_1stFile) ; Close first file
	$ar_Return[0] = $i_CountLFtotal
	$ar_Return[1] = $i_ByteOffset
	$ar_Return[2] = $i_ByteOffsetPrev
	$ar_Return[3] = $i_ByteOffset - $i_ByteOffsetPrev - 2
	Return $ar_Return; Return "Yes, both file compare"
EndFunc   ;==>_FileCountLinesBinary
Func _FileCountLinesTail($s_1stFile, $i_LineNumber = -1, $i_BeginningF = 1, $i_BufferSize = 8388608) ; Compare two files to see if their content match
	;===============================================================================
	;
	; Function Name:   _FileCountLinesReverse ; as for _FileCountBinary()
	; Description:      Count @LF s till appropriate number or EOF
	; Parameter(s):     $s_1stFile		- Complete path to first file to compare
	;                   $i_BufferSize	- BufferSize to use during compare (optionnal).
	; Requirement(s):   Requires AutoIT 3.1.1.77 minimum
	; Return Value(s):  On Success - Returns 1
	;                   On Failure - Returns 0 and sets the @error flag in the following fashion:
	;					@error = 1 - Wrong version of AutoIT (minimum = 3.1.1.77)
	;					@error = 2 - ; the  files doesn't exist
	;					@error = 3 - ; file size <0 (duh!)
	;					@error = 4 - Bad buffer size
	;					@error = 5 - Cannot compare complete file (increase BufferSize)
	;					@error = 6 - Cannot open file for read
	;					@error = 7 - Content doesn't match (compare fail)
	;					@extended = Offset (in bytes) of first difference
	; Remarks:			Low buffer values result in poor performance
	; Author(s):        Louis Horvath (celeri@videotron.ca)
	;
	;===============================================================================
;~ 	$i_BufferSize = 8192
$i_Divisor = 1
	If $i_BeginningF = 0 Then $i_Divisor = 1 ;tail
	If $i_BeginningF = 1 Then $i_Divisor = 50; beginning
	If $i_BeginningF = 2 Then $i_Divisor = 3 ; ;middle
	Local $h_1stFile, $h_2ndFile, $i_Loop1, $i_Loop2, $i_ChunkOffset, $i_ByteOffset, $i_DeBug
	Local $i_CountLFtotal, $ar_Return[4], $i_ByteOffsetLast, $i_PosLast, $i_ByteOffsetPrev
;~ 	$i_DeBug = 1
	If $i_DeBug Then ConsoleWrite(" $i_BufferSize=" & $i_BufferSize & @LF)
	If $i_DeBug Then ConsoleWrite(" $i_LineNumber=" & $i_LineNumber & @LF)
;~ 	$i_LineNumber-=1
	; Basic sanity checks
	If Not StringLen(Chr(0)) Then
		SetError(1) ; Cannot detect character "0" then wrong version of AutoIT ...
		Return 0
	EndIf
	If Not FileExists($s_1stFile) Then
		SetError(2) ; the  files doesn't exist
		Return 0
	EndIf
	$i_FileGetSize = FileGetSize($s_1stFile)
	If $i_BufferSize > $i_FileGetSize / $i_Divisor Then $i_BufferSize = Int($i_FileGetSize / $i_Divisor) + 1
	If ($i_BeginningF = 1) And ($i_BufferSize > $i_LineNumber * 256) Then $i_BufferSize = $i_LineNumber * 256
;~ 	If $i_BeginningF = 1 And $i_BufferSize > 8192 Then $i_BufferSize = 8192
;~ 	if $i_BeginningF = 1 And $i_BufferSize<128 then $i_BufferSize=128
	If $i_DeBug Then ConsoleWrite("NEW $i_BufferSize=" & $i_BufferSize & @LF)
	If $i_DeBug Then ConsoleWrite("NEW $i_BeginningF=" & $i_BeginningF & @LF)
	If $i_DeBug Then ConsoleWrite("NEW $i_Divisor=" & $i_Divisor & @LF)
;~ 	if $i_BufferSize<8192 then $i_BufferSize=8192
;~ 	if $i_BufferSize<128 then $i_BufferSize=128
	If Not $i_FileGetSize Then
		SetError(3) ; file size <0 (duh!)
		Return 0
	EndIf
	If (Not IsInt($i_BufferSize)) Or ($i_BufferSize < 1 And $i_BufferSize > 65536) Then
		SetError(4) ; Bad buffer size
		Return 0
	EndIf
	If $i_FileGetSize > $i_BufferSize * 999999999 Then
		SetError(5) ; Cannot check complete file (increase BufferSize)
		Return 0
	EndIf
	; Actual count loop
	$h_1stFile = _APIFileOpen($s_1stFile)
	$i_StartByte = 1
	_APIFileSetPos($h_1stFile, $i_FileGetSize - $i_BufferSize)
	$b_Source = _APIFileRead($h_1stFile, $i_BufferSize) ; Get chunk of first file
	If @error = -1 Then
		ConsoleWrite("not $b_Source=" & $b_Source & @LF)
		Exit
	EndIf
	$ar_CountLFtemp = StringSplit($b_Source, @LF)
	$i_CountLFtemp = UBound($ar_CountLFtemp) - 2
	If (Not IsArray($ar_CountLFtemp)) Or $i_CountLFtemp < $i_LineNumber Then ; If there are  not enough LFs in the buffer
		$i_BufferSize = $i_BufferSize * 2
		_APIFileSetPos($h_1stFile, $i_FileGetSize - $i_BufferSize)
		$b_Source = _APIFileRead($h_1stFile, $i_BufferSize) ; Get chunk of first file
		$ar_CountLFtemp = StringSplit($b_Source, @LF)
		$i_CountLFtemp = UBound($ar_CountLFtemp) - 2
		If (Not IsArray($ar_CountLFtemp)) Or $i_CountLFtemp < $i_LineNumber Then
			$i_BufferSize = $i_FileGetSize
			_APIFileSetPos($h_1stFile, $i_FileGetSize - $i_BufferSize)
			$b_Source = _APIFileRead($h_1stFile, $i_BufferSize) ; Get chunk of first file
			$ar_CountLFtemp = StringSplit($b_Source, @LF)
			$i_CountLFtemp = UBound($ar_CountLFtemp) - 2
		EndIf
	EndIf
	If StringInStr($b_Source, Chr(10)) Then ; If there is a LF in the buffer
		if $i_LineNumber<>1 then $i_ByteOffset = $i_FileGetSize - $i_BufferSize + StringInStr($b_Source, Chr(10), 0, -$i_LineNumber + 1)
		$i_ByteOffsetPrev = $i_FileGetSize - $i_BufferSize + StringInStr($b_Source, Chr(10), 0, -$i_LineNumber)
		$i_CountLFtotal = $i_LineNumber
	EndIf
	if $i_LineNumber=1 then 
;~ 		$i_ByteOffsetPrev= $i_ByteOffset
		$i_ByteOffset= $i_FileGetSize + 2
	EndIf
	_APIFileClose($h_1stFile); Close first file
	$ar_Return[0] = $i_CountLFtotal
	$ar_Return[1] = $i_ByteOffset
	$ar_Return[2] = $i_ByteOffsetPrev
	$ar_Return[3] = $i_ByteOffset - $i_ByteOffsetPrev - 2
	Return $ar_Return; Return "Yes, both file compare"
EndFunc   ;==>_FileCountLinesTail
Func __FileWriteToLine($s_File, $i_LineNumber = -1, $s_ReplaceLine = "", $i_Replace = 1, $i_Beginning = 1, $i_IfLonger = 0, $_IfShorter = 0, $i_BufferSize = 8388608)
	;**************************** $i_Replace=0 means "insert"  ;$i_IfLonger=1,
	Local $i_Tail
	If $i_Replace = -1 Then $i_Replace = 1
	If $i_IfLonger = -1 Then $i_IfLonger = 0
	If $_IfShorter = -1 Then $_IfShorter = 0
	$i_LineNumber = Int($i_LineNumber)
	$timer = TimerInit()
	If $i_LineNumber > 0 Then
		$ar_CountLines = _FileCountLinesBinary($s_File, $i_LineNumber, $i_Beginning, $i_BufferSize)
;~ 		ConsoleWrite("_FileCountLinesBinary time=" & TimerDiff($timer) & @LF)
	Else
		$i_Tail = 1
		$ar_CountLines = _FileCountLinesTail($s_File, -$i_LineNumber, $i_Beginning, $i_BufferSize)
;~ 		ConsoleWrite("_FileCountLinesTAIL time=" & TimerDiff($timer) & @LF)
	EndIf
	$i_StringLen = StringLen($s_ReplaceLine)
;~ 	$timer2 = TimerInit()
	If (Not $i_Replace) Then ; insert
		_CharInsertByByte($s_File, $s_ReplaceLine & @CRLF, $ar_CountLines[2] + 1, 0, $i_BufferSize) ;$i_Replace=1 [else Insert]
	ElseIf $i_IfLonger And ($i_StringLen > $ar_CountLines[3]) Then ; replace and then "insert" from next line [** remember $i_Replace >1 means amount to advanc eto find next line]
		$i_Replace = $ar_CountLines[3] ; start the read from the beginning of next line for insert
		_CharInsertByByte($s_File, $s_ReplaceLine, $ar_CountLines[2] + 1, $i_Replace, $i_BufferSize) ;$i_Replace=1 [else Insert]
	ElseIf $_IfShorter And ($i_StringLen < $ar_CountLines[3]) Then ; replace and then "insert" from next line [** remember $i_Replace >1 means amount to advanc eto find next line]
		$i_Replace = $ar_CountLines[3] ; start the read from the beginning of next line for insert
		_CharInsertByByte($s_File, $s_ReplaceLine, $ar_CountLines[2] + 1, $i_Replace, $i_BufferSize) ;$i_Replace=1 [else Insert]
	Else ; replace with fixed length for speed
		If $i_StringLen < $ar_CountLines[3] Then $s_ReplaceLine = StringLeft($s_ReplaceLine & _StringRepeat(" ", $ar_CountLines[3]), $ar_CountLines[3])
		If $i_StringLen > $ar_CountLines[3] Then $s_ReplaceLine = StringLeft($s_ReplaceLine, $ar_CountLines[3])
		_CharInsertByByte($s_File, $s_ReplaceLine, $ar_CountLines[2] + 1, $i_Replace, $i_BufferSize) ;$i_Replace=1 [else Insert]
	EndIf
;~ 	ConsoleWrite("__FileWriteToLine _CharInsertByByte time=" & TimerDiff($timer2) & @LF)
	Return $ar_CountLines;
EndFunc   ;==>__FileWriteToLine
Func __FileReadLine($s_File, $i_LineNumber = -1, $i_Beginning = 1, $i_ToEnd = 0, $i_BufferSize = 8388608)
	Local $i_Tail
	$i_LineNumber = Int($i_LineNumber)
	$timer = TimerInit()
	If $i_LineNumber > 0 Then
		$ar_CountLines = _FileCountLinesBinary($s_File, $i_LineNumber, $i_Beginning, $i_BufferSize)
	Else
		$i_Tail = 1
		$ar_CountLines = _FileCountLinesTail($s_File, -$i_LineNumber, $i_Beginning, $i_BufferSize)
	EndIf
;~ 	_ArrayDisplay($ar_CountLines,"$ar_CountLines")
	$h_File = _APIFileOpen($s_File);1
	_APIFileSetPos($h_File, $ar_CountLines[2]);5 ;read first
;~ 	ConsoleWrite($ar_CountLines[2] & @LF)
	If $i_ToEnd Then $i_EndLength = FileGetSize($s_File) - $ar_CountLines[2]
	If Not $i_ToEnd Then $i_EndLength = $ar_CountLines[3] 
;~ 		If $i_LineNumber = -1 Then
;~ 			ConsoleWrite($ar_CountLines[3] & @LF)
;~ 			$i_EndLength = $ar_CountLines[3]
;~ 		EndIf
;~ 	EndIf
	$s_TextReadBin = _APIFileRead($h_File, $i_EndLength);6
	_APIFileClose($h_File)
	Return $s_TextReadBin;
EndFunc   ;==>__FileReadLine