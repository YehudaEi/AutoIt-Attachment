;APITailRW.au3   ;  based on "APIRW.au3" by Larry, modified Zedna; now by Randallc
; ------------------------------------------------------------------------------
; AutoIt Version: 3.2
; Language:       English
; Description:    Functions that assist with reading binary files./ reading/ writing/ deleting to tail by line number fast/ writing to any line
;Author	:		 Write tail etc by Randallc; original binary by Larry, Zedna [binary wites by EriFash?]
; ------------------------------------------------------------------------------
#include-once
#include <string.au3>
;~ Opt('MustDeclareVars', 1)
#cs
	;Main funcs=============================
	_FileReadLineAPI($s_File, $i_LineNumber = -1, $i_Beginning = 1, $i_ToEnd = 0, $i_BufferSize = 8388608)
	_FileReplaceLineAPI($s_File, $i_LineNumber = -1, $s_ReplaceLine = "", $s_PaddingChar = " ", $i_Beginning = 1, $i_IfLonge
	_FileDeleteLineAPI($s_File, $i_LineNumber = -1, $i_Pad = 1, $s_PaddingChar = " ", $i_Beginning = 1, $i_BufferSize = 8388
	_FileInsertLineAPI($s_File, $i_LineNumber = -1, $s_InsertLine = "", $i_Beginning = 1, $i_BufferSize = 8388608)
	_FileReadAPI($hFile, $nBytes, $i_FileSetPosAPI = -1)
	_FileWriteAPI($hFile, $szData, $i_FileSetPosAPI = -1)
	_FileSetPosAPI($hFile, $nPos)
	_FileSetEndAPI($hFile)
	_FileOpenAPI($sFile)
	_FileCloseAPI($hFile)
	;Helper funcs=============================
	_FileFindPosOfLine($s_1stFile, $i_LineNumber = -1, $i_BeginningF = 1, $i_BufferSize = 8388608)
	_FileFindPosOfLineTail($s_1stFile, $i_LineNumber = -1, $i_BeginningF = 1, $i_BufferSize = 8388608)
	_CharInsertByByte($s_FileRead, $textInsertF, $i_StartByte, $i_Replace = 1, $i_Tail = 0, $i_Buff = 50000000)
#ce
;===============================================================================
;
; Function Name:  	_FileOpenAPI() ; ( <FileHandle> )
; Description:      _FileOpenAPI; Creates a "REAL" file handle for reading and writing.
; Parameter(s):     $sFile				- Complete path to  file to open
; Requirement(s):   Requires AutoIT 3.2 minimum
; Return Value(s):  On Success - value from CreateFile api;the return value is nonzero
;                   On Failure 	- ?** not set - value from CreateFile api; ;the return value is zero
; Author(s):        Larry
;
;===============================================================================
Func _FileOpenAPI($sFile)
	Local $GENERIC_READ = 0x80000000, $GENERIC_WRITE = 0x40000000, $OPEN_ALWAYS = 4, $FILE_ATTRIBUTE_NORMAL = 0x00000080
	Local $AFO_h
	$AFO_h = DllCall("kernel32.dll", "hwnd", "CreateFile", "str", $sFile, "long", BitOR($GENERIC_READ, $GENERIC_WRITE), "long", 0, "ptr", 0, "long", $OPEN_ALWAYS, "long", $FILE_ATTRIBUTE_NORMAL, "long", 0)
	Return $AFO_h[0]
EndFunc   ;==>_FileOpenAPI
;===============================================================================
;
; Function Name:  	_FileCloseAPI() ; ( <FileHandle> )
; Description:      _FileCloseAPI
; Parameter(s):     $hFile				- FileHandle of open (API) file
; Requirement(s):   Requires AutoIT 3.2 minimum
; Return Value(s):  On Success - value from CloseHandle api
;                   On Failure 	- ** not set
; Author(s):        Larry
;
;===============================================================================
Func _FileCloseAPI($hFile)
	Local $AFC_r
	$AFC_r = DllCall("kernel32.dll", "int", "CloseHandle", "hwnd", $hFile)
	Return $AFC_r[0]
EndFunc   ;==>_FileCloseAPI
;===============================================================================
;
; Function Name:  	_FileSetPosAPI() ; ( <FileHandle>, <Position in the file to read/write to/from> )
; Description:      Sets pointer position in file
; Parameter(s):     $hFile				- FileHandle of open (API) file
; Requirement(s):   Requires AutoIT 3.2 minimum
; Return Value(s):  On Success - value from SetFilePointer api;the return value is nonzero
;                   On Failure 	- ?** not set - value from SetFilePointer api; ;the return value is zero
; Author(s):        Larry
;
;===============================================================================
Func _FileSetPosAPI($hFile, $nPos)
	Local $FILE_BEGIN = 0
	Local $AFSP_r = DllCall("kernel32.dll", "long", "SetFilePointer", "hwnd", $hFile, "long", $nPos, "long*", 0, "long", $FILE_BEGIN)
	Return $AFSP_r[0]
EndFunc   ;==>_FileSetPosAPI
;===============================================================================
;
; Function Name:  	_FileReadAPI() ; ( <FileHandle>, <Number of Bytes to read>, [ <$i_FileSetPosAPI - position to start Read> ] )
; Description:      Read data from position in file
; Parameter(s):     $hFile				- FileHandle of open (API) file
;                   $nBytes				- Number of bytes to read
;					$i_FileSetPosAPI	- Optional: position to start Read
;										numeric>=0 = change pointer position in file
;										-1 = (Default) don't change pointer position in file
; Requirement(s):   Requires AutoIT 3.2 minimum
; Return Value(s):  On Success - Returns the data read
;                   On Failure 	- Returns 0 and sets @error to the return from ReadFile api
; Author(s):        Larry, modified Randall Clapp <randallc@ozemail.com.au>
;
;===============================================================================
Func _FileReadAPI($hFile, $nBytes, $i_FileSetPosAPI = -1, $Option = 0)
	Local $AFR_r, $AFR_str, $AFR_ret = ""
	If $Option = 0 Then
		If $i_FileSetPosAPI > -1 Then _FileSetPosAPI($hFile, $i_FileSetPosAPI)
		$AFR_str = DllStructCreate("char[" & $nBytes & "]")
	Else
		If $i_FileSetPosAPI > -1 Then _FileSetPosAPI($hFile, $i_FileSetPosAPI)
		$AFR_str = DllStructCreate("byte[" & $nBytes & "]")
	EndIf
	$AFR_r = DllCall("kernel32.dll", "int", "ReadFile", "hwnd", $hFile, "ptr", DllStructGetPtr($AFR_str), "long", $nBytes, "long*", 0, "ptr", 0)
	If $Option = 0 Then
		$AFR_ret = StringLeft(DllStructGetData($AFR_str, 1), $AFR_r[4])
	Else
		$AFR_ret = BinaryMid(DllStructGetData($AFR_str, 1), 1, $AFR_r[4])
	EndIf
	;===============================================================================
	SetError($AFR_r[0])
	$AFR_str = "";DllStructDelete($AFR_str)
	Return $AFR_ret
EndFunc   ;==>_FileReadAPI
Func _FileWriteAPIOLD($hFile, $szData, $i_FileSetPosAPI = -1)
	Local $AFW_r, $AFW_n, $AFW_ptr
	If $i_FileSetPosAPI > -1 Then _FileSetPosAPI($hFile, $i_FileSetPosAPI)
	$AFW_n = StringLen($szData)
	$AFW_ptr = DllStructCreate("char[" & $AFW_n + 1 & "]");+1; workaround fix
	DllStructSetData($AFW_ptr, 1, String($szData))
	$AFW_r = DllCall("kernel32.dll", "int", "WriteFile", "hwnd", $hFile, "ptr", DllStructGetPtr($AFW_ptr), "long", $AFW_n, "long*", 0, "ptr", 0)
	SetError($AFW_r[0])
	$AFW_ptr = "";DllStructDelete($AFR_ptr)
	Return $AFW_r[4]
EndFunc   ;==>_FileWriteAPIOLD
;===============================================================================
;
; Function Name: 	 _FileWriteAPI() ; ( <FileHandle>, <Data to Write>, [ <$i_FileSetPosAPI - position to start Write> ] , [ <$Option 0=String | 1=Binary> ])
; Description:      Write data at position in file
; Parameter(s):     $hFile				- FileHandle of open (API) file
;                   $szData				- Data to Write
;					$i_FileSetPosAPI	- Optional: position to start Write
;										numeric>=0 = change pointer position in file
;										-1 = (Default) don't change pointer position in file
;					$Option				- Optional: data 0=String | 1=Binary
;										0 = (Default) String
;										1 = Binary
; Requirement(s):   Requires AutoIT 3.2 minimum
; Return Value(s):  On Success - Returns # of Bytes written
;                   On Failure 	- Returns 0 and sets @error to the return from WriteFile api
; Author(s):        Larry, modified Randall Clapp <randallc@ozemail.com.au>
;
;===============================================================================
Func _FileWriteAPI($hFile, $szData, $i_FileSetPosAPI = -1, $Option = 0)
	Local $AFW_r, $AFW_n, $AFW_ptr
	If $i_FileSetPosAPI > -1 Then _FileSetPosAPI($hFile, $i_FileSetPosAPI)
	If $Option = 0 Then
		$AFW_n = StringLen($szData)
		$AFW_ptr = DllStructCreate("char[" & $AFW_n + 1 & "]");+1; workaround fix
		DllStructSetData($AFW_ptr, 1, String($szData))
	Else
		$AFW_n = BinaryLen($szData)
		$AFW_ptr = DllStructCreate("byte[" & $AFW_n + 1 & "]");+1; workaround fix
		DllStructSetData($AFW_ptr, 1, Binary($szData))
	EndIf
	$AFW_r = DllCall("kernel32.dll", "int", "WriteFile", "hwnd", $hFile, "ptr", DllStructGetPtr($AFW_ptr), "long", $AFW_n, "long*", 0, "ptr", 0)
	SetError($AFW_r[0])
	$AFR_ptr = "";DllStructDelete($AFR_ptr)
	Return $AFW_r[4]
EndFunc   ;==>_FileWriteAPI
;===============================================================================
;
; Function Name:  	_FileSetEndAPI() ; ( <FileHandle>)
; Description:      Sets eof position in file
; Parameter(s):     $hFile				- FileHandle of open (API) file
; Requirement(s):   Requires AutoIT 3.2 minimum
; Return Value(s):  On Success 	- The return value comes directly from "SetEndOfFile" api ;the return value is nonzero
;                   On Failure 	- The return value comes directly from "SetEndOfFile" api ;the return value is zero
; Author(s):        Zedna
;
;===============================================================================
Func _FileSetEndAPI($hFile)
	Local $AFSP_r
	$AFSP_r = DllCall("kernel32.dll", "int", "SetEndOfFile", _
			"hwnd", $hFile)
	Return $AFSP_r[0]
EndFunc   ;==>_FileSetEndAPI
;===============================================================================
;
; Function Name:   _FileFindPosOfLine()
; Description:      Count @LF s till appropriate number or EOF
; Parameter(s):     $s_1stFile		- Complete path to  file to count
;                   $i_LineNumber	- Optional: Line number to read (Default) -1; reads last line ; ** Negative numbers count lines from Tail **
;					$i_BeginningF	- Optional: Indicates (for speed) if known whether to start buffer reads at end, middle, or start
;										0 = start at tail
;										1 = (Default) start at beginning
;										2 = start at middle
;                   $i_BufferSize	- Optional: BufferSize to use during count
; Requirement(s):   Requires AutoIT 3.2 minimum
; Return Value(s):  On Success - Returns Array of values for positions in file;
;                   Array[0]	- Line Count [number of @LF in file]
;                   Array[1]	- Byte position of end of line in file
;                   Array[2]	- Byte position of end of previous line in file
;                   Array[3]	- Number bytes in string on  line
;                   On Failure 	- Returns 0 and sets the @error flag in the following fashion:
;					@error = 1 	- Wrong version of AutoIT (minimum = 3.1.1.77)
;					@error = 2 	- ; the  files doesn't exist
;					@error = 3	- ; file size <0 (duh!)
;					@error = 4 	- Bad buffer size
;					@error = 5	- Cannot compare complete file (increase BufferSize)
;					@error = 6	- Cannot open file for read
;					@error = 7	- Content doesn't match (compare fail)
;					<  xx@extended = ? **?
; Remarks:			Low buffer values result in poor performance
; Author(s):        Randall Clapp <randallc@ozemail.com.au>
;
;===============================================================================
Func _FileFindPosOfLine($s_1stFile, $i_LineNumber = -1, $i_BeginningF = 1, $i_BufferSize = 8388608) ; count lines files
	Local $h_1stFile, $h_2ndFile, $i_Loop1, $i_Loop2, $i_ChunkOffset, $i_ByteOffset, $i_DeBug, $i_Divisor, $b_Source, $i_NumberMoreLFs, $i_Pos
	Local $i_CountLFtotal, $ar_Return[4], $i_ByteOffsetLast, $i_PosLast, $i_ByteOffsetPrev, $i_FileGetSize, $ar_CountLFtemp, $i_CountLFtemp
	If $i_BeginningF = 0 Then $i_Divisor = 1 ;tail
	If $i_BeginningF = 1 Then $i_Divisor = 50; beginning
	If $i_BeginningF = 2 Then $i_Divisor = 3 ; ;middle
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
	For $i_Loop1 = 1 To 999999999 ; Binary count of  file. For/Next for speed
		$i_ChunkOffset = $i_BufferSize * ($i_Loop1 - 1) ; How many chunks have been processed * buffer size
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
				$i_NumberMoreLFs = $i_LineNumber - $i_CountLFtotal
				If $i_CountLFtemp > $i_NumberMoreLFs Then $i_CountLFtemp = $i_NumberMoreLFs
				$i_ByteOffset = $i_ChunkOffset + StringInStr($b_Source, Chr(10), 0, $i_CountLFtemp)
				If $i_CountLFtemp > 1 Then $i_ByteOffsetPrev = $i_ChunkOffset + StringInStr($b_Source, Chr(10), 0, $i_CountLFtemp - 1)
				If $i_CountLFtemp <= 1 Then $i_ByteOffsetPrev = $i_ByteOffsetLast
				$i_ByteOffsetLast = $i_ChunkOffset + StringInStr($b_Source, Chr(10), 0, -1) ; Yup so that's where the difference is.
				$i_CountLFtotal += $i_CountLFtemp
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
	Return $ar_Return
EndFunc   ;==>_FileFindPosOfLine
;===============================================================================
;
; Function Name:   _FileFindPosOfLineTail()
; Description:      Count @LF s till appropriate number or EOF
; Parameter(s):     $s_1stFile		- Complete path to  file to count
;                   $i_LineNumber	- Optional: Line number to read (Default) -1; reads last line ; ** Negative numbers count lines from Tail **
;					$i_BeginningF	- Optional: Indicates (for speed) if known whether to start buffer reads at end, middle, or start
;										0 = start at tail
;										1 = (Default) start at beginning
;										2 = start at middle
;                   $i_BufferSize	- Optional: BufferSize to use during count
; Requirement(s):   Requires AutoIT 3.2 minimum
; Return Value(s):  On Success - Returns Array of values for positions in file;
;                   Array[0]	- Line Count [number of @LF in file]
;                   Array[1]	- Byte position of end of line in file
;                   Array[2]	- Byte position of end of previous line in file
;                   Array[3]	- Number bytes in string on  line
;                   On Failure 	- Returns 0 and sets the @error flag in the following fashion:
;					@error = 1 	- Wrong version of AutoIT (minimum = 3.1.1.77)
;					@error = 2 	- ; the  files doesn't exist
;					@error = 3	- ; file size <0 (duh!)
;					@error = 4 	- Bad buffer size
;					@error = 5	- Cannot compare complete file (increase BufferSize)
;					@error = 6	- Cannot open file for read
;					@error = 7	- Content doesn't match (compare fail)
;					<  xx@extended = ? **?
; Remarks:			Low buffer values result in poor performance
; Author(s):        Randall Clapp <randallc@ozemail.com.au>
;
;===============================================================================
Func _FileFindPosOfLineTail($s_1stFile, $i_LineNumber = -1, $i_BeginningF = 1, $i_BufferSize = 8388608)
	Local $h_1stFile, $h_2ndFile, $i_Loop1, $i_Loop2, $i_ChunkOffset, $i_ByteOffset, $i_DeBug, $i_Divisor, $b_Source, $ar_CountLFtemp
	Local $i_CountLFtotal, $ar_Return[4], $i_ByteOffsetLast, $i_PosLast, $i_ByteOffsetPrev, $i_FileGetSize, $i_StartByte, $i_CountLFtemp
	If $i_BeginningF = 0 Then $i_Divisor = 1 ;tail
	If $i_BeginningF = 1 Then $i_Divisor = 50; beginning
	If $i_BeginningF = 2 Then $i_Divisor = 3 ; ;middle
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
	$h_1stFile = _FileOpenAPI($s_1stFile)
	$i_StartByte = 1
	$b_Source = _FileReadAPI($h_1stFile, $i_BufferSize, $i_FileGetSize - $i_BufferSize) ; Get chunk of first file
	If @error = -1 Then
		ConsoleWrite("not $b_Source=" & $b_Source & @LF)
		Exit
	EndIf
	$ar_CountLFtemp = StringSplit($b_Source, @LF)
	$i_CountLFtemp = UBound($ar_CountLFtemp) - 2
	If (Not IsArray($ar_CountLFtemp)) Or $i_CountLFtemp < $i_LineNumber Then ; If there are  not enough LFs in the buffer
		$i_BufferSize = $i_BufferSize * 2
		$b_Source = _FileReadAPI($h_1stFile, $i_BufferSize, $i_FileGetSize - $i_BufferSize) ; Get chunk of first file
		$ar_CountLFtemp = StringSplit($b_Source, @LF)
		$i_CountLFtemp = UBound($ar_CountLFtemp) - 2
		If (Not IsArray($ar_CountLFtemp)) Or $i_CountLFtemp < $i_LineNumber Then
			$i_BufferSize = $i_FileGetSize
			$b_Source = _FileReadAPI($h_1stFile, $i_BufferSize, $i_FileGetSize - $i_BufferSize) ; Get chunk of first file
			$ar_CountLFtemp = StringSplit($b_Source, @LF)
			$i_CountLFtemp = UBound($ar_CountLFtemp) - 2
		EndIf
	EndIf
	If StringInStr($b_Source, Chr(10)) Then ; If there is a LF in the buffer
		If $i_LineNumber <> 1 Then $i_ByteOffset = $i_FileGetSize - $i_BufferSize + StringInStr($b_Source, Chr(10), 0, -$i_LineNumber + 1)
		$i_ByteOffsetPrev = $i_FileGetSize - $i_BufferSize + StringInStr($b_Source, Chr(10), 0, -$i_LineNumber)
		$i_CountLFtotal = $i_LineNumber
	EndIf
	If $i_LineNumber = 1 Then
		$i_ByteOffset = $i_FileGetSize + 2
	EndIf
	_FileCloseAPI($h_1stFile); Close first file
	$ar_Return[0] = $i_CountLFtotal
	$ar_Return[1] = $i_ByteOffset
	$ar_Return[2] = $i_ByteOffsetPrev
	$ar_Return[3] = $i_ByteOffset - $i_ByteOffsetPrev - 2
	Return $ar_Return; Return "Yes, both file compare"
EndFunc   ;==>_FileFindPosOfLineTail
;===============================================================================
;
; Function Name:   	_FileReadLineAPI()
; Description:      Read File starting at given line, 1 line or to the end
; Parameter(s):     $s_File		- Complete path to  file to count
;                   $i_LineNumber	- Optional: Line number to read (Default) -1; reads last line ; ** Negative numbers count lines from Tail **
;					$i_Beginning	- Optional: Indicates (for speed) if known whether to start buffer reads at end, middle, or start
;										0 = start at tail
;										1 = (Default) start at beginning
;										2 = start at middle
;                   $i_ToEnd		- Optional: Read only line number ;or reads to the last line
;										0 = (Default) Read only line number
;										1 = reads to the last line
;                   $i_BufferSize	- Optional: BufferSize to use during count
; Requirement(s):   Requires AutoIT 3.2 minimum
; Return Value(s):  On Success - Returns Array of values for positions in file;
;                   Array[0]	- Line Count [number of @LF in file]
;                   Array[1]	- Byte position of end of line in file
;                   Array[2]	- Byte position of end of previous line in file
;                   Array[3]	- Number bytes in string on  line
;                   On Failure 	- Returns 0 and sets the @error flag in the following fashion:
;					@error = 1 	- Wrong version of AutoIT (minimum = 3.2)
;					@error = 2 	- ; the  files doesn't exist
;					@error = 3	- ; file size <0 (duh!)
;					@error = 4 	- Bad buffer size
;					@error = 5	- Cannot compare complete file (increase BufferSize)
;					@error = 6	- Cannot open file for read
;					@error = 7	- Content doesn't match (compare fail)
;					<  xx@extended = ? **?
; Remarks:			Low buffer values result in poor performance
; Author(s):        Randall Clapp <randallc@ozemail.com.au>
;
;===============================================================================
Func _FileReadLineAPI($s_File, $i_LineNumber = -1, $i_Beginning = 1, $i_ToEnd = 0, $i_BufferSize = 8388608)
	Local $i_Tail, $timer, $ar_CountLines, $h_File, $i_EndLength, $s_TextReadBin
	$i_LineNumber = Int($i_LineNumber)
	If $i_LineNumber > 0 Then
		$ar_CountLines = _FileFindPosOfLine($s_File, $i_LineNumber, $i_Beginning, $i_BufferSize)
	Else
		$i_Tail = 1
		$ar_CountLines = _FileFindPosOfLineTail($s_File, -$i_LineNumber, $i_Beginning, $i_BufferSize)
	EndIf
	If Not IsArray($ar_CountLines) Then
		SetError(@error) ; array not returned
		Return 0
	EndIf
	$h_File = _FileOpenAPI($s_File);1
	If $i_ToEnd Then $i_EndLength = FileGetSize($s_File) - $ar_CountLines[2]
	If Not $i_ToEnd Then $i_EndLength = $ar_CountLines[3]
	$s_TextReadBin = _FileReadAPI($h_File, $i_EndLength, $ar_CountLines[2]);6
	_FileCloseAPI($h_File)
	Return $s_TextReadBin;
EndFunc   ;==>_FileReadLineAPI
;===============================================================================
;
; Function Name:  	_FileReplaceLineAPI()
; Description:      Replace Line API write; option of fast write by padding/ trimming line to fit!
; Parameter(s):     $s_File			- Complete path to  file to count
;                   $i_LineNumber	- Optional: Line number to write (Default) -1; writes to last line ; ** Negative numbers count lines from Tail **
;                   $s_ReplaceLine	- Optional: Line  to write (Default) ""
;                   $s_PaddingChar	- Optional: Padding character (Default) " " -blank space
;					$i_Beginning	- Optional: Indicates (for speed) if known whether to start buffer reads at end, middle, or start
;										0 = start at tail
;										1 = (Default) start at beginning
;										2 = start at middle
;                   $i_IfLonger		- Optional: trimming; so must shift rest of file down [slower]; or trim to same length as original line, , so fast write
;										0 =  trim to same length as original line, , so fast write
;										1 = (Default) no trimming; so must shift rest of file down [slower]
;                   $i_IfShorter	- Optional: Pad with $s_PaddingChar, so fast write, o move rest of file up
;										0 = (Default) Pad with $s_PaddingChar, so fast write
;										1 = no padding; so must shift rest of file up
;                   $i_BufferSize	- Optional: BufferSize to use during count
; Requirement(s):   Requires AutoIT 3.2 minimum
; Return Value(s):  On Success - Returns Array of values for original positions of line in file;
;                   Array[0]	- Line Count [number of @LF in file]
;                   Array[1]	- Byte position of end of line in file
;                   Array[2]	- Byte position of end of previous line in file
;                   Array[3]	- Number bytes in string on  line
;                   On Failure 	- Returns 0 and sets the @error flag in the following fashion:
;					@error = 1 	- Wrong version of AutoIT (minimum = 3.2)
;					@error = 2 	- ; the  files doesn't exist
;					@error = 3	- ; file size <0 (duh!)
;					@error = 4 	- Bad buffer size
;					@error = 5	- Cannot compare complete file (increase BufferSize)
;					@error = 6	- Cannot open file for read
;					@error = 7	- Content doesn't match (compare fail)
;					<  xx@extended = ? **?
; Remarks:			Low buffer values result in poor performance
; Author(s):        Randall Clapp <randallc@ozemail.com.au>
;
;===============================================================================
Func _FileReplaceLineAPI($s_File, $i_LineNumber = -1, $s_ReplaceLine = "", $s_PaddingChar = " ", $i_Beginning = 1, $i_IfLonger = 1, $i_IfShorter = 0, $i_BufferSize = 8388608)
	Local $i_Tail, $i_Replace = 1, $timer, $ar_CountLines, $i_StringLen
	If $s_ReplaceLine = -1 Then $s_ReplaceLine = ""
	If $s_PaddingChar = -1 Then $s_PaddingChar = " "
	If $i_Beginning = -1 Then $i_Beginning = 1
	If $i_IfLonger = -1 Then $i_IfLonger = 1
	If $i_IfShorter = -1 Then $i_IfShorter = 0
	$i_LineNumber = Int($i_LineNumber)
	$timer = TimerInit()
	If $i_LineNumber > 0 Then
		$ar_CountLines = _FileFindPosOfLine($s_File, $i_LineNumber, $i_Beginning, $i_BufferSize)
	Else
		$i_Tail = 1
		$ar_CountLines = _FileFindPosOfLineTail($s_File, -$i_LineNumber, $i_Beginning, $i_BufferSize)
	EndIf
	If Not IsArray($ar_CountLines) Then
		SetError(@error) ; array not returned
		Return 0
	EndIf
	$i_StringLen = StringLen($s_ReplaceLine)
	If $i_IfLonger And ($i_StringLen > $ar_CountLines[3]) Then ; replace and then "insert" from next line [** remember $i_Replace >1 means amount to advanc eto find next line]
		$i_Replace = $ar_CountLines[3] ; start the read from the beginning of next line for insert
		_CharInsertByByte($s_File, $s_ReplaceLine, $ar_CountLines[2] + 1, $i_Replace, $i_Tail, $i_BufferSize) ;$i_Replace=1 [else Insert]
	ElseIf $i_IfShorter And ($i_StringLen < $ar_CountLines[3]) Then ; replace and then "insert" from next line [** remember $i_Replace >1 means amount to advanc eto find next line]
		$i_Replace = $ar_CountLines[3] ; start the read from the beginning of next line for insert
		_CharInsertByByte($s_File, $s_ReplaceLine, $ar_CountLines[2] + 1, $i_Replace, $i_BufferSize) ;$i_Replace=1 [else Insert]
	Else ; replace with fixed length for speed
		If $i_StringLen < $ar_CountLines[3] Then $s_ReplaceLine = StringLeft($s_ReplaceLine & _StringRepeat($s_PaddingChar, $ar_CountLines[3]), $ar_CountLines[3])
		If $i_StringLen > $ar_CountLines[3] Then $s_ReplaceLine = StringLeft($s_ReplaceLine, $ar_CountLines[3])
		_CharInsertByByte($s_File, $s_ReplaceLine, $ar_CountLines[2] + 1, $i_Replace, $i_Tail, $i_BufferSize) ;$i_Replace=1 [else Insert]
	EndIf
	Return $ar_CountLines;
EndFunc   ;==>_FileReplaceLineAPI
;===============================================================================
;
; Function Name:  	_FileDeleteLineAPI()
; Description:      Delete Line API write; option of fast write by padding previous line to fit!
; Parameter(s):     $s_File			- Complete path to  file to count
;                   $i_LineNumber	- Optional: Line number to write (Default) -1; deletes last line ; ** Negative numbers count lines from Tail **
;                   $i_Pad			- Optional: Read only line number ;or reads to the last line
;										0 =  no padding, so must move rest of file up
;										1 = (Default) fast write by padding previous line to fit
;                   $s_PaddingChar	- Optional: Padding character (Default) " " -blank space
;					$i_Beginning	- Optional: Indicates (for speed) if known whether to start buffer reads at end, middle, or start
;										0 = start at tail
;										1 = (Default) start at beginning
;										2 = start at middle
;                   $i_BufferSize	- Optional: BufferSize to use during count
; Requirement(s):   Requires AutoIT 3.2 minimum
; Return Value(s):  On Success - Returns Array of values for original positions of line in file;
;                   Array[0]	- Line Count [number of @LF in file]
;                   Array[1]	- Byte position of end of line in file
;                   Array[2]	- Byte position of end of previous line in file
;                   Array[3]	- Number bytes in string on  line
;                   On Failure 	- Returns 0 and sets the @error flag in the following fashion:
;					@error = 1 	- Wrong version of AutoIT (minimum = 3.2)
;					@error = 2 	- ; the  files doesn't exist
;					@error = 3	- ; file size <0 (duh!)
;					@error = 4 	- Bad buffer size
;					@error = 5	- Cannot compare complete file (increase BufferSize)
;					@error = 6	- Cannot open file for read
;					@error = 7	- Content doesn't match (compare fail)
;					<  xx@extended = ? **?
; Remarks:			Low buffer values result in poor performance
; Author(s):        Randall Clapp <randallc@ozemail.com.au>
;
;===============================================================================
Func _FileDeleteLineAPI($s_File, $i_LineNumber = -1, $i_Pad = 1, $s_PaddingChar = " ", $i_Beginning = 1, $i_BufferSize = 8388608)
	Local $i_Tail, $ar_CountLines, $s_ReplaceLine
	If $s_PaddingChar = -1 Then $s_PaddingChar = " "
	If $i_Beginning = -1 Then $i_Beginning = 1
	If $i_Pad = -1 Then $i_Pad = 1
	$i_LineNumber = Int($i_LineNumber)
	If $i_LineNumber > 0 Then
		$ar_CountLines = _FileFindPosOfLine($s_File, $i_LineNumber, $i_Beginning, $i_BufferSize)
	Else
		$i_Tail = 1
		$ar_CountLines = _FileFindPosOfLineTail($s_File, -$i_LineNumber, $i_Beginning, $i_BufferSize)
	EndIf
	If Not IsArray($ar_CountLines) Then
		SetError(@error) ; array not returned
		Return 0
	EndIf
	If $i_Pad Then
		$s_ReplaceLine = _StringRepeat($s_PaddingChar, $ar_CountLines[3] + 1)
		_CharInsertByByte($s_File, $s_ReplaceLine, $ar_CountLines[2], 1, $i_Tail, $i_BufferSize) ;$i_Replace=1 [else Insert]
	Else
		_CharInsertByByte($s_File, "", $ar_CountLines[2] + 1, $ar_CountLines[3] + 1, $i_Tail, $i_BufferSize) ;$i_Replace=1 [else Insert]
	EndIf
	Return $ar_CountLines;
EndFunc   ;==>_FileDeleteLineAPI
;===============================================================================
;
; Function Name:  	_FileInsertLineAPI()
; Description:      Replace Line API write; option of fast write by padding/ trimming line to fit!
; Parameter(s):     $s_File			- Complete path to  file to count
;                   $i_LineNumber	- Optional: Line number to write (Default) -1; inserts before last line ; ** Negative numbers count lines from Tail **
;                   $s_InsertLine	- Optional: Line  to write (Default) ""
;					$i_Beginning	- Optional: Indicates (for speed) if known whether to start buffer reads at end, middle, or start
;										0 = start at tail
;										1 = (Default) start at beginning
;										2 = start at middle
;                   $i_BufferSize	- Optional: BufferSize to use during count
; Requirement(s):   Requires AutoIT 3.2 minimum
; Return Value(s):  On Success - Returns Array of values for original positions of line in file;
;                   Array[0]	- Line Count [number of @LF in file]
;                   Array[1]	- Byte position of end of line in file
;                   Array[2]	- Byte position of end of previous line in file
;                   Array[3]	- Number bytes in string on  line
;                   On Failure 	- Returns 0 and sets the @error flag in the following fashion:
;					@error = 1 	- Wrong version of AutoIT (minimum = 3.2)
;					@error = 2 	- ; the  files doesn't exist
;					@error = 3	- ; file size <0 (duh!)
;					@error = 4 	- Bad buffer size
;					@error = 5	- Cannot compare complete file (increase BufferSize)
;					@error = 6	- Cannot open file for read
;					@error = 7	- Content doesn't match (compare fail)
;					<  xx@extended = ? **?
; Remarks:			Low buffer values result in poor performance
; Author(s):        Randall Clapp <randallc@ozemail.com.au>
;
;===============================================================================
Func _FileInsertLineAPI($s_File, $i_LineNumber = -1, $s_InsertLine = "", $i_Beginning = 1, $i_BufferSize = 8388608)
	Local $i_Tail = 0, $timer, $ar_CountLines, $i_StringLen
	If $s_InsertLine = -1 Then $s_InsertLine = ""
	If $i_Beginning = -1 Then $i_Beginning = 1
	$i_LineNumber = Int($i_LineNumber)
	$timer = TimerInit()
	If $i_LineNumber > 0 Then
		$ar_CountLines = _FileFindPosOfLine($s_File, $i_LineNumber, $i_Beginning, $i_BufferSize)
	Else
		$i_Tail = 1
		$ar_CountLines = _FileFindPosOfLineTail($s_File, -$i_LineNumber, $i_Beginning, $i_BufferSize)
	EndIf
	If Not IsArray($ar_CountLines) Then
		SetError(@error) ; array not returned
		Return 0
	EndIf
	$i_StringLen = StringLen($s_InsertLine)
	_CharInsertByByte($s_File, $s_InsertLine & @CRLF, $ar_CountLines[2] + 1, 0, $i_Tail, $i_BufferSize) ;$i_Replace=1 [else Insert]
	Return $ar_CountLines;
EndFunc   ;==>_FileInsertLineAPI
;===============================================================================
;
; Function Name:  	_CharInsertByByte()
; Description:      Replace Line API write; option of fast write by padding/ trimming line to fit!
; Parameter(s):     $s_File			- Complete path to  file to count
;                   $i_LineNumber	- Optional: Line number to write (Default) -1; writes to last line ; ** Negative numbers count lines from Tail **
;                   $s_ReplaceLine	- Optional: Line  to write (Default) ""
;                   $s_PaddingChar	- Optional: Padding character (Default) " " -blank space
;					$i_Beginning	- Optional: Indicates (for speed) if known whether to start buffer reads at end, middle, or start
;										0 = start at tail
;										1 = (Default) start at beginning
;										2 = start at middle
;                   $i_IfLonger		- Optional: Read only line number ;or reads to the last line
;										0 =  trim to same length as original line, , so fast write
;										1 = (Default) no trimming; so must shift rest of file down [slower]
;                   $i_IfShorter	- Optional: Read only line number ;or reads to the last line
;										0 = (Default) Pad with $s_PaddingChar, so fast write
;										1 = no padding; so must shift rest of file up
;                   $i_BufferSize	- Optional: BufferSize to use during count
; Requirement(s):   Requires AutoIT 3.2 minimum
; Return Value(s):  On Success - Returns Array of values for original positions of line in file;
;                   Array[0]	- Line Count [number of @LF in file]
;                   Array[1]	- Byte position of end of line in file
;                   Array[2]	- Byte position of end of previous line in file
;                   Array[3]	- Number bytes in string on  line
;                   On Failure 	- Returns 0 and sets the @error flag in the following fashion:
;					@error = 1 	- Wrong version of AutoIT (minimum = 3.2)
;					@error = 2 	- ; the  files doesn't exist
;					@error = 3	- ; file size <0 (duh!)
;					@error = 4 	- Bad buffer size
;					@error = 5	- Cannot compare complete file (increase BufferSize)
;					@error = 6	- Cannot open file for read
;					@error = 7	- Content doesn't match (compare fail)
;					<  xx@extended = ? **?
; Remarks:			Low buffer values result in poor performance
; Author(s):        Randall Clapp <randallc@ozemail.com.au>
;
;===============================================================================
Func _CharInsertByByte($s_FileRead, $textInsertF, $i_StartByte, $i_Replace = 1, $i_Tail = 0, $i_Buff = 50000000);, $i_Hex = 0)
	Local $s_FileCopy, $h_File, $s_TextReadBin, $timerc, $h_Copy, $i_StringLen, $timerm
	If $i_Replace < 0 Then $i_Replace = 0
	$s_FileCopy = @ScriptDir & "\APIwwritecopy.txt"
	If $i_Replace = 1 Then ; $i_Replace gives number of bytes along to end of current string
		$h_File = _FileOpenAPI($s_FileRead)
		_FileWriteAPI($h_File, $textInsertF, $i_StartByte - 1)
		_FileCloseAPI($h_File)
	ElseIf $i_Tail <> 0 Then ; and therefore $i_Replace =0 or >1
		$h_File = _FileOpenAPI($s_FileRead);1
		$s_TextReadBin = _FileReadAPI($h_File, $i_Buff, $i_StartByte - 1 + $i_Replace);6
;~ 		$s_TextReadBin = _FileReadAPI($h_File, $i_Tail, $i_StartByte - 1 + $i_Replace);6
		_FileWriteAPI($h_File, $textInsertF, $i_StartByte - 1);3
		_FileSetEndAPI($h_File);4
		_FileWriteAPI($h_File, $s_TextReadBin);8
		_FileCloseAPI($h_File)
	Else ; $i_Replace gives number of bytes along to end of current string
		$timerc = TimerInit()
		FileCopy($s_FileRead, $s_FileCopy, 1)
		ConsoleWrite("FileCopy time=" & TimerDiff($timerc) & @LF)
		$h_File = _FileOpenAPI($s_FileRead);1
		$h_Copy = _FileOpenAPI($s_FileCopy)
		_FileWriteAPI($h_Copy, $textInsertF, $i_StartByte - 1);3
		_FileSetEndAPI($h_Copy);4
		$i_StringLen = StringLen($textInsertF)
		For $a = 0 To FileGetSize($s_FileRead) / $i_Buff
			If ($i_StartByte - 1 + $a * $i_Buff + $i_Replace) < FileGetSize($s_FileRead) - 2 Then ;don't read if within 1 of eof
				$s_TextReadBin = _FileReadAPI($h_File, $i_Buff, $i_StartByte - 1 + $a * $i_Buff + $i_Replace);6
				_FileWriteAPI($h_Copy, $s_TextReadBin, $i_StartByte - 1 + $i_StringLen + $a * $i_Buff);8
			EndIf
		Next
		_FileCloseAPI($h_Copy)
		_FileCloseAPI($h_File)
		$timerm = TimerInit()
		FileMove($s_FileCopy, $s_FileRead, 1)
		ConsoleWrite("FileMove time=" & TimerDiff($timerm) & @LF)
	EndIf
EndFunc   ;==>_CharInsertByByte
Func _APIGetFileSize($szFile)
	Local $ret = 0
	Local $hFile = _FileOpenAPI($szFile)
	$AFR_r = DllCall("kernel32.dll", "int", "GetFileSize", _
			"hwnd", $hFile, _
			"ptr", 0)
	_FileCloseAPI($hFile)
	Return $AFR_r[0]
EndFunc   ;==>_APIGetFileSize