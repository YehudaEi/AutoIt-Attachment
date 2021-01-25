#include <winapi.au3>
#include <file.au3>


#CS Changelog
	- 1.0 (24/2-09)
	First release
	
	- 1.01
	Types in headers are now unsigned
	FAF header signature is now 4 bytes!
	_FAF_DeleteFileFromArchive() now implemented
	
	
#CE

#cs
	Flexible Archive Format (FAF) specification
	
	- Header - Contains generic data about the format such as version info and author
	{
	uint version; Archive version
	wchar author[32]; Who created the archive, can be blank
	uint magic; Should be 0x12FA86B
	uint firstentry; Where the index start, should be same as sizeof(Header)
	uint lastentry; Where is the last entry
	uint entrycount; Number of entries in the index
	}
	
	The files is in an linked list where each element point to the next element, last element point at 0
	FILEENTRY
	{
	uint flag; Flags for compression, encryption etc.
	uint id; Unique id to identify the file
	wchar filename[256];
	uint datasize; Size of the raw data
	uint nextentry; Adress of the next entry
	byte raw[n]; The raw binary data
	}
	
	
#ce

Global Const $FAF_FLAG_RAW = 1 ; Just storing the file
Global Const $FAF_FLAG_LZ1 = 2 ;
Global Const $FAF_MAGIC = 0x12FA86B
Global Const $FAF_HEADER = "uint version;wchar author[32];uint magic;uint firstentry;uint lastentry;uint entrycount;"
Global Const $FAF_FILEENTRY = "uint flag;uint id;wchar filename[256];uint datasize;uint uncompressedsize;uint nextentry;"
Global Const $FAF_BUFFERSIZE = (1024 ^ 2) * 2
Global Const $FAF_COMPRESSIONBUFFERSIZE = (1024 ^ 2) * 6
Global Const $FAF_VERSION = 1010








; Returns array:
; [n][0]=filename
; [n][1]=size in archive
; [n][2]=extracted size
; [n][3]=unique id
; [n][4]=pointer in file
Func _FAF_ReadArchiveIndex($FAF_Handle)
	Local $read
	Local $fpointer = _WinAPI_SetFilePointer($FAF_Handle, 0, 1)

	$fafheader = _FAF_ReadHeader($FAF_Handle)

;~ 	_FAF_Debug_Header($fafheader)

	Local $RetArr[DllStructGetData($fafheader, "entrycount")][5]

	$entryptr = DllStructGetData($fafheader, "firstentry")
	For $i = 0 To UBound($RetArr) - 1
		$fentry = DllStructCreate($FAF_FILEENTRY)
		_WinAPI_SetFilePointer($FAF_Handle, $entryptr)
		_WinAPI_ReadFile($FAF_Handle, _ptr($fentry), sizeof($fentry), $read)
		$RetArr[$i][0] = DllStructGetData($fentry, "filename")
		$RetArr[$i][1] = DllStructGetData($fentry, "datasize")
		$RetArr[$i][2] = DllStructGetData($fentry, "uncompressedsize")
		$RetArr[$i][3] = DllStructGetData($fentry, "id")
		$RetArr[$i][4] = _WinAPI_SetFilePointer($FAF_Handle, 0, 1) - sizeof($fentry)
		$entryptr = DllStructGetData($fentry, "nextentry")
	Next
	_WinAPI_SetFilePointer($FAF_Handle, $fpointer)
	Return $RetArr

EndFunc   ;==>_FAF_ReadArchiveIndex

Func _FAF_Debug_Header($fhs)
	MsgBox(0, "Debugging header", "Version: " & DllStructGetData($fhs, "version") & @CRLF & _
			"Author: " & DllStructGetData($fhs, "Author") & @CRLF & _
			"Magic: " & DllStructGetData($fhs, "magic") & @CRLF & _
			"First Entry: " & DllStructGetData($fhs, "firstentry") & @CRLF & _
			"Last Entry: " & DllStructGetData($fhs, "lastentry") & @CRLF & _
			"Entry Count: " & DllStructGetData($fhs, "entrycount"))

EndFunc   ;==>_FAF_Debug_Header

Func _FAF_Debug_FileEntry($ffe)
	MsgBox(0, "Debugging header", "Flag: " & DllStructGetData($ffe, "flag") & @CRLF & _
			"Id: " & DllStructGetData($ffe, "id") & @CRLF & _
			"Filename: " & DllStructGetData($ffe, "filename") & @CRLF & _
			"Datasize: " & DllStructGetData($ffe, "datasize") & @CRLF & _
			"Uncompressed size: " & DllStructGetData($ffe, "uncompressedsize") & @CRLF & _
			"Next Entry: " & DllStructGetData($ffe, "nextentry") & @CRLF)


EndFunc   ;==>_FAF_Debug_FileEntry


Func _FAF_OpenArchive($sFilename)
	$hFile = _WinAPI_CreateFile($sFilename, 2, 6)
	If Not $hFile Then Return -1
	$fafheader = _FAF_ReadHeader($hFile)
	If DllStructGetData($fafheader, "magic") <> $FAF_MAGIC Then
		_WinAPI_CloseHandle($hFile)
		Return -1
	EndIf
	Return $hFile
EndFunc   ;==>_FAF_OpenArchive


Func _FAF_WriteHeader($FAF_Handle, $fafheader)
	Local $written
	$fpointer = _WinAPI_SetFilePointer($FAF_Handle, 0, 1)
	_WinAPI_SetFilePointer($FAF_Handle, 0)
	_WinAPI_WriteFile($FAF_Handle, _ptr($fafheader), sizeof($fafheader), $written)
	_WinAPI_SetFilePointer($FAF_Handle, $fpointer)
EndFunc   ;==>_FAF_WriteHeader


Func _FAF_ReadHeader($FAF_Handle)
	$read = 0
	$fpointer = _WinAPI_SetFilePointer($FAF_Handle, 0, 1)
	_WinAPI_SetFilePointer($FAF_Handle, 0)
	$fafheader = DllStructCreate($FAF_HEADER)
	_WinAPI_ReadFile($FAF_Handle, _ptr($fafheader), sizeof($fafheader), $read)
	_WinAPI_SetFilePointer($FAF_Handle, $fpointer)
	Return $fafheader
EndFunc   ;==>_FAF_ReadHeader


Func _FAF_ExtractFile($FAF_Handle, $UniqueID, $SavePath)
	Local $read, $written
	$fpointer = _WinAPI_SetFilePointer($FAF_Handle, 0, 1)

	$index = _FAF_ReadArchiveIndex($FAF_Handle)

	For $i = 0 To UBound($index) - 1
		If $index[$i][3] = $UniqueID Then
			_WinAPI_SetFilePointer($FAF_Handle, $index[$i][4])

			$entry = DllStructCreate($FAF_FILEENTRY)
			_WinAPI_ReadFile($FAF_Handle, _ptr($entry), sizeof($entry), $read)

			$outfhandle = _WinAPI_CreateFile($SavePath, 1, 4)
			$toreadwrite = DllStructGetData($entry, "datasize")

			If BitAND(DllStructGetData($entry, "flag"), $FAF_FLAG_RAW) Then

				$buffer = DllStructCreate("byte[" & $FAF_BUFFERSIZE & "]")

				Do
					If $toreadwrite <= $FAF_BUFFERSIZE Then
						_WinAPI_ReadFile($FAF_Handle, _ptr($buffer), $toreadwrite, $read)
						_WinAPI_WriteFile($outfhandle, _ptr($buffer), $read, $written)
						$toreadwrite -= $written
					Else
						_WinAPI_ReadFile($FAF_Handle, _ptr($buffer), sizeof($buffer), $read)
						_WinAPI_WriteFile($outfhandle, _ptr($buffer), sizeof($buffer), $written)
						$toreadwrite -= $written
					EndIf
				Until $toreadwrite = 0

			ElseIf BitAND(DllStructGetData($entry, "flag"), $FAF_FLAG_LZ1) Then
				$miniheader = DllStructCreate("int")
				Do
					_WinAPI_ReadFile($FAF_Handle, _ptr($miniheader), sizeof($miniheader), $read)
;~ 					ConsoleWrite(DllStructGetData($miniheader,1)&@CRLF)
					$buffer = DllStructCreate("byte[" & DllStructGetData($miniheader, 1) & "]")
					_WinAPI_ReadFile($FAF_Handle, _ptr($buffer), sizeof($buffer), $read)
					$CompressedBin = Binary(DllStructGetData($buffer, 1))
					$Decompressed = _LZNTDecompress($CompressedBin)
					$DecompressedBuffer = DllStructCreate("byte[" & BinaryLen($Decompressed) & "]")
					DllStructSetData($DecompressedBuffer, 1, $Decompressed)
					_WinAPI_WriteFile($outfhandle, _ptr($DecompressedBuffer), sizeof($DecompressedBuffer), $written)
					ConsoleWrite($toreadwrite & @CRLF)
					$toreadwrite -= (4 + $read)
				Until $toreadwrite = 0



			EndIf


			_WinAPI_CloseHandle($outfhandle)

			ExitLoop
		EndIf
	Next
	_WinAPI_SetFilePointer($FAF_Handle, $fpointer)

EndFunc   ;==>_FAF_ExtractFile



Func _FAF_CloseArchive($FAF_Handle)
	Return _WinAPI_CloseHandle($FAF_Handle)
EndFunc   ;==>_FAF_CloseArchive

Func _FAF_CreateArchive($sFilename, $Author = @UserName)

	Local $written, $read, $uncompressedsize = 0
	Local $fpointer = 0

	; Create the file and open it for reading
	$hFile = _WinAPI_CreateFile($sFilename, 1, 6)
	If Not $hFile Then Return -1

	; Create the archive header
	$header = DllStructCreate($FAF_HEADER)
	DllStructSetData($header, "author", @UserName)
	DllStructSetData($header, "version", $FAF_VERSION)
	DllStructSetData($header, "magic", $FAF_MAGIC)
	DllStructSetData($header, "firstentry", 0)
	DllStructSetData($header, "lastentry", 0)
	DllStructSetData($header, "entrycount", 0)

	; Write the header to the file
	$err = _WinAPI_WriteFile($hFile, _ptr($header), sizeof($header), $written)

	Return $hFile


EndFunc   ;==>_FAF_CreateArchive

Func _FAF_DeleteFileFromArchive($FAF_Handle, $ID)
	Local $read, $written
	$fpointer = _WinAPI_SetFilePointer($FAF_Handle, 0, 1)

	; Reading the index
	$index = _FAF_ReadArchiveIndex($FAF_Handle)

	; Readin the header
	$fafheader = _FAF_ReadHeader($FAF_Handle)

	; If it's only one file in the archive and it's this file
	If UBound($index) = 1 And $index[0][3] = $ID Then
		DllStructSetData($fafheader, "firstentry", 0)
		DllStructSetData($fafheader, "lastentry", 0)
		DllStructSetData($fafheader, "entrycount", 0)
		_WinAPI_SetFilePointer($FAF_Handle, sizeof($fafheader))
		; Chop of the file directly after the header
		_WinAPI_SetEndOfFile($FAF_Handle)

	Else

		; Loop until we find the correct ID
		For $i = 0 To UBound($index) - 1
			If $i = $ID Then

				$entrytodel = _FAF_ReadFileEntry($FAF_Handle, $index[$i][4])
				; The total size that needs to be deleted fomr the archive
				$sizetodel = sizeof($entrytodel) + DllStructGetData($entrytodel, "datasize")

				; All the entries AFTER the soon to be deleted entry need to have their headers corrected (next entry & id)
				For $j = $i + 1 To UBound($index) - 1
					$entrytomod = _FAF_ReadFileEntry($FAF_Handle, $index[$j][4])

					DllStructSetData($entrytomod, "nextentry", DllStructGetData($entrytomod, "nextentry") - $sizetodel)

					DllStructSetData($entrytomod, "id", DllStructGetData($entrytomod, "id") - 1)

					_FAF_WriteFileEntry($FAF_Handle, $entrytomod, $index[$j][4])
				Next


				; How much of the file need
;~ 				$toreadwrite = _WinAPI_SetFilePointer($FAF_Handle,0,2)

				$topos = $index[$i][4]
				$frompos = $index[$i][4] + $sizetodel
				$buffer = DllStructCreate("byte[" & $FAF_BUFFERSIZE & "]")
				Do

					$toread = $FAF_BUFFERSIZE

					; Read from after the soon to be deleted entry
					_WinAPI_SetFilePointer($FAF_Handle, $frompos)
					_WinAPI_ReadFile($FAF_Handle, _ptr($buffer), $toread, $read)
					
					; Write to position before
					_WinAPI_SetFilePointer($FAF_Handle, $topos)
					_WinAPI_WriteFile($FAF_Handle, _ptr($buffer), $read, $written)
					
					; Move the positions ahead
					$topos += $written
					$frompos += $written

					; When $written=0 we have reached EOF
				Until $written = 0
				
				; Move the fpointer and chop of the file.
				_WinAPI_SetFilePointer($FAF_Handle, -$sizetodel, 2)
				_WinAPI_SetEndOfFile($FAF_Handle)
				
				; Modify the archive header to reflect the changes
				DllStructSetData($fafheader, "entrycount", DllStructGetData($fafheader, "entrycount") - 1)
				DllStructSetData($fafheader, "lastentry", DllStructGetData($fafheader, "lastentry") - $sizetodel)


				ExitLoop
			EndIf
		Next
	EndIf
	_FAF_WriteHeader($FAF_Handle, $fafheader)

EndFunc   ;==>_FAF_DeleteFileFromArchive

Func _FAF_WriteFileEntry($FAF_Handle, $FileEntry, $Pos, $MovePointer = False)
	$written = 0
	$fpointer = _WinAPI_SetFilePointer($FAF_Handle, 0, 1)
	_WinAPI_SetFilePointer($FAF_Handle, $Pos)
	_WinAPI_WriteFile($FAF_Handle, _ptr($FileEntry), sizeof($FileEntry), $written)
;~ 	MsgBox(0,"",$written)
	If Not $MovePointer Then _WinAPI_SetFilePointer($FAF_Handle, $fpointer)
EndFunc   ;==>_FAF_WriteFileEntry

Func _FAF_ReadFileEntry($FAF_Handle, $Pos)
	Local $read
	$fpointer = _WinAPI_SetFilePointer($FAF_Handle, 0, 1)
	_WinAPI_SetFilePointer($FAF_Handle, $Pos)
	$FileEntry = DllStructCreate($FAF_FILEENTRY)
	_WinAPI_ReadFile($FAF_Handle, _ptr($FileEntry), sizeof($FileEntry), $read)
	_WinAPI_SetFilePointer($FAF_Handle, $fpointer)
	Return $FileEntry

EndFunc   ;==>_FAF_ReadFileEntry



; Available flags are: FAF_FLAG_RAW & FAF_FLAG_LZ1
Func _FAF_AddFileToArchive($FAF_Handle, $Filename, $Flag)
	Local $written, $read, $uncompressedsize = 0, $unique = 0
	Local $fpointer = _WinAPI_SetFilePointer($FAF_Handle, 0, 2) ; Set the pointer to eof
	Local $previouslastentry = 0

	; Rewrite header and reset the file pointer
	$fafheader = _FAF_ReadHeader($FAF_Handle)


	If DllStructGetData($fafheader, "firstentry") = 0 Then ; If this is the first entry then modify header to reflect that
		DllStructSetData($fafheader, "firstentry", $fpointer)
	Else
		; .. else the nextentry in the old lastentry need to be modified to point at this entry


		$previouslastentry = DllStructGetData($fafheader, "lastentry")
		_WinAPI_SetFilePointer($FAF_Handle, $previouslastentry)
		$entry = DllStructCreate($FAF_FILEENTRY)
		_WinAPI_ReadFile($FAF_Handle, _ptr($entry), sizeof($entry), $read)
		DllStructSetData($entry, "nextentry", $fpointer)
		_WinAPI_SetFilePointer($FAF_Handle, $previouslastentry)
		_WinAPI_WriteFile($FAF_Handle, _ptr($entry), sizeof($entry), $written)


	EndIf


	DllStructSetData($fafheader, "lastentry", $fpointer)
	DllStructSetData($fafheader, "entrycount", DllStructGetData($fafheader, "entrycount") + 1)
	$unique = DllStructGetData($fafheader, "entrycount") - 1
	_WinAPI_SetFilePointer($FAF_Handle, 0)
	_WinAPI_WriteFile($FAF_Handle, _ptr($fafheader), sizeof($fafheader), $written)
	_WinAPI_SetFilePointer($FAF_Handle, $fpointer)



	$entry = DllStructCreate($FAF_FILEENTRY)

	; Move the file pointer so we can write the header after we have written the raw data
	_WinAPI_SetFilePointer($FAF_Handle, sizeof($entry), 1)
	$fpointer += sizeof($entry)

	; Open the file for reading
	$temphandle = _WinAPI_CreateFile($Filename, 2, 2)

	$totalwritten = 0
	; Just raw data
	If BitAND($Flag, $FAF_FLAG_RAW) Then
		; Create a buffer for the file data
		$buff = DllStructCreate("byte[" & $FAF_BUFFERSIZE & "]")
		; Loop and read data forever or until maybe something happens..
		While _WinAPI_ReadFile($temphandle, _ptr($buff), sizeof($buff), $read)
			; No more data could be read, must be EOF! Lets get out of here
			If $read = 0 Then ExitLoop
			; Push the data into the archive
			_WinAPI_WriteFile($FAF_Handle, _ptr($buff), $read, $written)

			; Keep track of how much data we have written and where the file pointer is.
			$fpointer += $written
			$totalwritten += $written
			$uncompressedsize = $totalwritten
		WEnd
	ElseIf BitAND($Flag, $FAF_FLAG_LZ1) Then

		$buff = DllStructCreate("byte[" & $FAF_COMPRESSIONBUFFERSIZE & "]")
		While _WinAPI_ReadFile($temphandle, _ptr($buff), sizeof($buff), $read)
			; No more data could be read, must be EOF! Lets get out of here
			$uncompressedsize += $read
			If $read = 0 Then ExitLoop
			$buff_rightsize = DllStructCreate("byte[" & $read & "]", _ptr($buff))
			$Binary = Binary(DllStructGetData($buff_rightsize, 1))
			$Compressed = _LZNTCompress($Binary)
			$CompressedLength = BinaryLen($Compressed)
			$miniheader = DllStructCreate("int;")
			$newbuff = DllStructCreate("byte[" & $CompressedLength & "];")
			DllStructSetData($miniheader, 1, $CompressedLength)
			DllStructSetData($newbuff, 1, $Compressed)
			_WinAPI_WriteFile($FAF_Handle, _ptr($miniheader), sizeof($miniheader), $written)
			$fpointer += $written
			$totalwritten += $written

			_WinAPI_WriteFile($FAF_Handle, _ptr($newbuff), sizeof($newbuff), $written)
			$fpointer += $written
			$totalwritten += $written

		WEnd


	EndIf

	; Move the file pointer back to where the entry header sould be
	_WinAPI_SetFilePointer($FAF_Handle, -(sizeof($entry) + $totalwritten), 1)
	$fpointer -= (sizeof($entry) + $totalwritten)

	; Set the data in the entry header and write it.
	DllStructSetData($entry, "flag", $Flag)
	DllStructSetData($entry, "id", $unique)
	DllStructSetData($entry, "filename", RemoveDir($Filename))
	DllStructSetData($entry, "datasize", $totalwritten)
	DllStructSetData($entry, "uncompressedsize", $uncompressedsize)

	DllStructSetData($entry, "nextentry", 0)

	; Write..
	_WinAPI_WriteFile($FAF_Handle, _ptr($entry), sizeof($entry), $written)
	$fpointer += $written
	; Move the file pointer to after the raw data again.
	_WinAPI_SetFilePointer($FAF_Handle, $totalwritten, 1)
	$fpointer += $totalwritten


	_WinAPI_CloseHandle($temphandle)

EndFunc   ;==>_FAF_AddFileToArchive




Func RemoveDir($Filename)
	Local $blah
	$arr = _PathSplit($Filename, $blah, $blah, $blah, $blah)
	Return $arr[3] & $arr[4]
EndFunc   ;==>RemoveDir


Func _ptr($s)
	Return DllStructGetPtr($s)
EndFunc   ;==>_ptr


Func sizeof($s)
	Return DllStructGetSize($s)
EndFunc   ;==>sizeof







#Region Native compression
; #FUNCTION# ;===============================================================================
;
; Name...........: _LZNTDecompress
; Description ...: Decompresses input data.
; Syntax.........: _LZNTDecompress ($bBinary)
; Parameters ....: $vInput - Binary data to decompress.
; Return values .: Success - Returns decompressed binary data.
;                          - Sets @error to 0
;                  Failure - Returns empty string and sets @error:
;                  |1 - Error decompressing.
; Author ........: trancexx
; Related .......: _LZNTCompress
; Link ..........; http://msdn.microsoft.com/en-us/library/bb981784.aspx
;
;==========================================================================================
Func _LZNTDecompress($bBinary)

	$bBinary = Binary($bBinary)

	Local $tInput = DllStructCreate("byte[" & BinaryLen($bBinary) & "]")
	DllStructSetData($tInput, 1, $bBinary)

	Local $tBuffer = DllStructCreate("byte[" & 16 * DllStructGetSize($tInput) & "]") ; initially oversizing buffer

	Local $a_Call = DllCall("ntdll.dll", "int", "RtlDecompressBuffer", _
			"ushort", 2, _
			"ptr", DllStructGetPtr($tBuffer), _
			"dword", DllStructGetSize($tBuffer), _
			"ptr", DllStructGetPtr($tInput), _
			"dword", DllStructGetSize($tInput), _
			"dword*", 0)

	If @error Or $a_Call[0] Then
		Return SetError(1, 0, "") ; error decompressing
	EndIf

	Local $tOutput = DllStructCreate("byte[" & $a_Call[6] & "]", DllStructGetPtr($tBuffer))

	Return SetError(0, 0, DllStructGetData($tOutput, 1))

EndFunc   ;==>_LZNTDecompress



; #FUNCTION# ;===============================================================================
;
; Name...........: _LZNTCompress
; Description ...: Compresses input data.
; Syntax.........: _LZNTCompress ($vInput [, $iCompressionFormatAndEngine])
; Parameters ....: $vInput - Data to compress.
;                  $iCompressionFormatAndEngine - Compression format and engine type. Default is 2 (standard compression). Can be:
;                  |2 - COMPRESSION_FORMAT_LZNT1 | COMPRESSION_ENGINE_STANDARD
;                  |258 - COMPRESSION_FORMAT_LZNT1 | COMPRESSION_ENGINE_MAXIMUM
; Return values .: Success - Returns compressed binary data.
;                          - Sets @error to 0
;                  Failure - Returns empty string and sets @error:
;                  |1 - Error determining workspace buffer size.
;                  |2 - Error compressing.
; Author ........: trancexx
; Related .......: _LZNTDecompress
; Link ..........; http://msdn.microsoft.com/en-us/library/bb981783.aspx
;
;==========================================================================================
Func _LZNTCompress($vInput, $iCompressionFormatAndEngine = 2)

	If Not ($iCompressionFormatAndEngine = 258) Then
		$iCompressionFormatAndEngine = 2
	EndIf

	Local $bBinary = Binary($vInput)

	Local $tInput = DllStructCreate("byte[" & BinaryLen($bBinary) & "]")
	DllStructSetData($tInput, 1, $bBinary)

	Local $a_Call = DllCall("ntdll.dll", "int", "RtlGetCompressionWorkSpaceSize", _
			"ushort", $iCompressionFormatAndEngine, _
			"dword*", 0, _
			"dword*", 0)

	If @error Or $a_Call[0] Then
		Return SetError(1, 0, "") ; error determining workspace buffer size
	EndIf

	Local $tWorkSpace = DllStructCreate("byte[" & $a_Call[2] & "]") ; workspace is needed for compression

	Local $tBuffer = DllStructCreate("byte[" & 16 * DllStructGetSize($tInput) & "]") ; initially oversizing buffer

	Local $a_Call = DllCall("ntdll.dll", "int", "RtlCompressBuffer", _
			"ushort", $iCompressionFormatAndEngine, _
			"ptr", DllStructGetPtr($tInput), _
			"dword", DllStructGetSize($tInput), _
			"ptr", DllStructGetPtr($tBuffer), _
			"dword", DllStructGetSize($tBuffer), _
			"dword", 4096, _
			"dword*", 0, _
			"ptr", DllStructGetPtr($tWorkSpace))

	If @error Or $a_Call[0] Then
		Return SetError(2, 0, "") ; error compressing
	EndIf

	Local $tOutput = DllStructCreate("byte[" & $a_Call[7] & "]", DllStructGetPtr($tBuffer))

	Return SetError(0, 0, DllStructGetData($tOutput, 1))

EndFunc   ;==>_LZNTCompress
#EndRegion Native compression