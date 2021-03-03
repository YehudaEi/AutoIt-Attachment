#include-once
#include <_FileMapping.au3>
#include <_FileEx.au3>
#include <WinAPI.au3>
#include <File.au3>
#include <Memory.au3>

; #FUNCTION# ====================================================================================================================
; Name ..........: _SecureFileDelete
; Description ...: Securely overwrite a file.
; Syntax ........: _SecureFileDelete($sFile[, $fDelete = True[, $aPatterns = -1]])
; Parameters ....: $sFile               - Path to file to securely delete.
;                  $fDelete             - [Optional] Delete the file when finished (Default = True)
;                  $aPatterns           - [Optional] User array of integers 0 to 255 (decimal or hex) to use as patterns
;                                       + $aPatterns[] = [0xAA,0x4F,135,etc...]
;                                       + If $aPatterns = -1, then the default DoD_E method is used
; Return values .: Success              - Returns 1
;                  Failure              - 0 and sets @error
;                                       | 1 - File does not exist
;                                       | 2 - $sFile is a directory or reparse point
;                                       | 3 - Error with the user array
;                                       | 4 - Error getting file map
;                                       | 5 - Error opening file
;                                       | 6 - Error allocating buffer
;                                       | 7 - Error overwriting file
;                                       | 8 - Error creating temp file
;                                       | 9 - Error deleting file
;                                       |10 - Error overwriting special sectors
; Author ........: Erik Pilsits
; Modified ......:
; Remarks .......: If the file is Encrypted, Compressed, or Sparse, it will be deleted regardless. This is necessary to
;                  overwrite the clusters on disk containing the data.
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _SecureFileDelete($sFile, $fDelete = True, $aPatterns = -1)
	;
	; check input file
	;
	Local $iAttr = _FileEx_GetAttributes($sFile)
	If @error Then Return SetError(1, 0, 0)
	If _SD_IsIllegalFile($iAttr) Then Return SetError(2, 0, 0)
	Local $sDrive = _FM_PathGetDrive($sFile)
	;
	; check patterns
	;
	If $aPatterns <> -1 And Not IsArray($aPatterns) Then Return SetError(3, 0, 0)
	If $aPatterns = -1 Then
		; default patterns
		Dim $aPatterns[3]
		; DoD 3-pass method:
		; 1st pass = random character decimal 0 to 255
		; 2nd pass = complement of first pass
		; 3rd pass = random character
		$aPatterns[0] = Random(0, 255, 1) ; random decimal value
		$aPatterns[1] = BitAND(BitNOT($aPatterns[0]), 0xFF) ; get previous value's complement
		$aPatterns[2] = Random(0, 255, 1)
	Else
		; check user array values
		For $i = 0 To UBound($aPatterns) - 1
			If ($aPatterns[$i] < 0) Or ($aPatterns[$i] > 255) Then Return SetError(3, 0, 0)
		Next
	EndIf
	;
	; declare some vars, set some defaults
	Local $hFile, $eraseMethod = 1, $inMFT = 0, $pBuffer, $iWriteSize, $iClusters, $iBytes, $iErr = 0
	;
	; get file map
	;
	Local $aMAP = _FM_GetFileMapping($sFile)
	;
	Switch @error
		Case 4
			; no extents, file is probably in MFT, use normal method with sector sized block
			$inMFT = 1
		Case 0
			; file is on disk, check if encrypted, compressed, or sparse
			If _SD_IsSpecialFile($iAttr) Then $eraseMethod = 2
			; else use normal method with cluster sized block
		Case Else
			; unrecoverable error
			Return SetError(4, 0, 0)
	EndSwitch
	;
	_FM_PrintMapInfo($aMAP)
	;
	Switch $eraseMethod
		Case 1
			ConsoleWrite("NORMAL" & @CRLF)
			; normal erase method used for regular files on disk and files in MFT
			;
			; FILE_FLAG_RANDOM_ACCESS | FILE_FLAG_NO_BUFFERING | FILE_FLAG_WRITE_THROUGH
			$hFile = _FileEx_CreateFile($sFile, $GENERIC_WRITE, $FILE_SHARE_READ, $OPEN_EXISTING, 0xB0000000)
			If Not $hFile Then Return SetError(5, 0, 0)
			;
			; get write size for unbuffered i/o
			If $inMFT Then
				; sector size
				$iWriteSize = $aMAP[0][1]
			Else
				; multiple of cluster size
				$iWriteSize = $aMAP[0][2]
				; if file is > 2 MB, then increase write size
				; seems to optimize around 2 MB
				If $aMAP[0][3] > (1024^2*2) Then $iWriteSize = Ceiling(1024^2*2 / $iWriteSize) * $iWriteSize
			EndIf
			; if 0, default to 512 and hope for the best, at worst the write operation will fail later on
			If $iWriteSize = 0 Then $iWriteSize = 512
			ConsoleWrite("SIZE: " & $iWriteSize & @CRLF)
			;
			; create aligned buffer
			$pBuffer = _MemVirtualAlloc(0, $iWriteSize, $MEM_COMMIT, $PAGE_READWRITE)
			If Not $pBuffer Then
				_WinAPI_CloseHandle($hFile)
				Return SetError(6, 0, 0)
			EndIf
			;
			; remove attributes, set NORMAL
			_FileEx_SetAttributes($sFile, 0x80)
			;
			; get number of write operations
			Local $iCycles = Ceiling($aMAP[0][3] / $iWriteSize)
			;
			ConsoleWrite("STARTING..." & @CRLF)
			Local $timer = TimerInit()
			For $i = 0 To (UBound($aPatterns) - 1) ; # of overwrites
				; fill buffer with pattern
				DllCall("msvcrt.dll", "ptr:cdecl", "memset", "ptr", $pBuffer, "int", $aPatterns[$i], "ulong_ptr", $iWriteSize)
				; overwrite file
				; may increase filesize by a max of 1 sector
				For $k = 1 To $iCycles
					If (Not _WinAPI_WriteFile($hFile, $pBuffer, $iWriteSize, $iBytes)) Or ($iWriteSize <> $iBytes) Then
						_WinAPI_CloseHandle($hFile)
						_MemVirtualFree($pBuffer, 0, $MEM_RELEASE)
						Return SetError(7, 0, 0)
					EndIf
				Next
				; reset file pointer to beginning of the file
				DllCall("kernel32.dll", "bool", "SetFilePointerEx", "handle", $hFile, "int64", 0, "ptr", 0, "dword", 0)
			Next
			ConsoleWrite("DONE: " & TimerDiff($timer)/1000 & @CRLF)
			_WinAPI_CloseHandle($hFile)
			_MemVirtualFree($pBuffer, 0, $MEM_RELEASE)
		Case 2
			ConsoleWrite("SPECIAL" & @CRLF)
			; special erase method used for encrypted, compressed, or sparse files
			;
			; NOTE: This method first deletes the file then uses the defragmentation API to move a cluster sized file
			; into the vacated sectors, essentially overwriting the old data.
			;
			; prepare...
			;
			; create temp file on same volume as target file
			Local $sTemp = _TempFile($sDrive & ":\")
			ConsoleWrite("Temp file: " & $sTemp & @CRLF & @CRLF)
			$hFile = _FileEx_CreateFile($sTemp, $GENERIC_WRITE, $FILE_SHARE_READ, $OPEN_ALWAYS, 0xB0000000)
			If @error Then Return SetError(8, 0, 0)
			;
			; max number of clusters to overwrite at a time
			; optimally a multiple of 16
			; operation seems to be optimized somewhere around 2-4 MB
			;
			; set temp file size ~2 MB as multiple of 16 clusters
			If $aMAP[0][2] Then
				$iWriteSize = Ceiling(1024^2*2 / ($aMAP[0][2]*16)) * ($aMAP[0][2]*16)
				; get cluster count
				$iClusters = $iWriteSize / $aMAP[0][2]
			Else
				; default
				$iWriteSize = 1024^2*2
				$iClusters = $iWriteSize / 4096
			EndIf
			ConsoleWrite("SIZE: " & $iWriteSize & @CRLF)
			; create aligned buffer
			$pBuffer = _MemVirtualAlloc(0, $iWriteSize, $MEM_COMMIT, $PAGE_READWRITE)
			If Not $pBuffer Then
				_WinAPI_CloseHandle($hFile)
				FileDelete($sTemp)
				Return SetError(6, 0, 0)
			EndIf
			;
			; FILE_DEVICE_FILE_SYSTEM, 29, METHOD_BUFFERED, FILE_SPECIAL_ACCESS
			Local Const $FSCTL_MOVE_FILE = _FM_CTL_CODE(0x00000009, 29, 0, 0)
			; create MOVE_FILE_DATA structure and set temp file handle
			Local $tagMOVE_FILE_DATA = "handle FileHandle;int64 StartingVcn;int64 StartingLcn;dword ClusterCount"
			Local $MFD = DllStructCreate($tagMOVE_FILE_DATA)
			DllStructSetData($MFD, "FileHandle", $hFile)
			DllStructSetData($MFD, "StartingVcn", 0)
			DllStructSetData($MFD, "ClusterCount", $iClusters)
			;
			; get handle to volume containing destination file
			Local $hVolume = _FileEx_CreateFile("\\.\" & $sDrive & ":", $GENERIC_READ, BitOR($FILE_SHARE_READ, $FILE_SHARE_WRITE), $OPEN_EXISTING, 0)
			If @error Then
				_WinAPI_CloseHandle($hFile)
				FileDelete($sTemp)
				_MemVirtualFree($pBuffer, 0, $MEM_RELEASE)
				Return SetError(9, 0, 0)
			EndIf
			;
			; remove attributes, set NORMAL
			_FileEx_SetAttributes($sFile, 0x80)
			; delete the file, remove flag
			$fDelete = False
			_SD_DeleteFile($sFile)
			If @error Then
				_WinAPI_CloseHandle($hVolume)
				_WinAPI_CloseHandle($hFile)
				FileDelete($sTemp)
				_MemVirtualFree($pBuffer, 0, $MEM_RELEASE)
				Return SetError(9, 0, 0)
			EndIf
			;
			Local $aRet, $iLCN, $iCycles, $iToFinish
			;
			ConsoleWrite("STARTING..." & @CRLF)
			Local $timer = TimerInit()
			; walk the output array, processing each extent
			For $i = 1 To $aMAP[0][0]
				; skip LCN's of -1
				If $aMAP[$i][1] = -1 Then ContinueLoop
				; # of overwrites
				For $p = 0 To (UBound($aPatterns) - 1)
					; fill buffer with pattern
					DllCall("msvcrt.dll", "ptr:cdecl", "memset", "ptr", $pBuffer, "int", $aPatterns[$p], "ulong_ptr", $iWriteSize)
					; reset file pointer to beginning of the file
					DllCall("kernel32.dll", "bool", "SetFilePointerEx", "handle", $hFile, "int64", 0, "ptr", 0, "dword", 0)
					; fill file with new pattern
					_WinAPI_WriteFile($hFile, $pBuffer, $iWriteSize, $iBytes)
					;
					; set first LCN of this extent
					$iLCN = $aMAP[$i][1]
					; overwrite each cluster in the extent
					$iCycles = Ceiling($aMAP[$i][2] / $iClusters)
					For $k = 1 To $iCycles
						; process last extent
						If $k = $iCycles Then
							; get remaining clusters = total clusters - already overwritten
							$iToFinish = $aMAP[$i][2] - (($k - 1) * $iClusters)
							; this shouldn't happen, but check for 0
							If $iToFinish = 0 Then ExitLoop
							DllStructSetData($MFD, "ClusterCount", $iToFinish)
						EndIf
						; set target LCN to struct
						DllStructSetData($MFD, "StartingLcn", $iLCN)
						; move our temp file to target cluster
						$aRet = DllCall("kernel32.dll", "bool", "DeviceIoControl", "handle", $hVolume, "dword", $FSCTL_MOVE_FILE, _
								"ptr", DllStructGetPtr($MFD), "dword", DllStructGetSize($MFD), "ptr", 0, "dword", 0, "dword*", 0, "ptr", 0)
						If Not $aRet[0] Then
							; failure, this means the file system has used this cluster for something else
							; it is likely most of the data has been overwritten, but some will remain if the
							; cluster has not been fully utilized
							$iErr += 1
						EndIf
						; next cluster in extent
						$iLCN += $iClusters
					Next
				Next
			Next
			ConsoleWrite("DONE: " & TimerDiff($timer)/1000 & @CRLF)
			; cleanup
			_WinAPI_CloseHandle($hVolume)
			_WinAPI_CloseHandle($hFile)
			FileDelete($sTemp)
			_MemVirtualFree($pBuffer, 0, $MEM_RELEASE)
	EndSwitch
	;
	; post processing
	;
	If $fDelete Then
		_SD_DeleteFile($sFile)
		If @error Then Return SetError(9, 0, 0)
	EndIf
	; $iErr is only > 0 if using Special method, which implies $fDelete = False
	If $iErr Then Return SetError(10, $iErr, 0)
	;
;~ 	ConsoleWrite("Recovering..." & @CRLF)
;~ 	_FM_ReadMapToFile($aMAP, @DesktopDir & "\recovered.dat")
	Return 1
EndFunc   ;==>_SecureFileDelete

Func _SecureFreespaceErase($sDrive, $aPatterns = -1)
	; format drive path and check it
	$sDrive = _FM_PathGetDrive($sDrive) & ":\"
	If Not FileExists($sDrive) Then Return SetError(1, 0, 0)
	; get sector size
	Local $iSectorSize = _FM_GetDiskSectorSize(StringLeft($sDrive, 1))
	; default
	If $iSectorSize = 0 Then $iSectorSize = 512
	;
	; allocate largest unbuffered file
	; use multiple of sector size
	ConsoleWrite("UNBUFF 2M" & @CRLF)
	;
	Local $aFiles[1] = [0]
	Local $ret, $iSize, $hTemp
	Local $iWrite = Ceiling(1024^2*2 / $iSectorSize) * $iSectorSize
	Local $sTemp = _FileEx_GetTempFile($sDrive)
	If @error Then
		_SD_ErrorRemoveTempFiles($aFiles)
		Return SetError(2, 0, 0)
	Else
		$hTemp = _FileEx_CreateFile($sTemp, $GENERIC_WRITE, 0, $CREATE_ALWAYS, 0xA0000000)
		If @error Then
			_SD_ErrorRemoveTempFiles($aFiles)
			Return SetError(3, 0, 0)
		Else
			ConsoleWrite($sTemp & " : ")
			_SD_AddTempFile($aFiles, $sTemp)
			Do
				_WinAPI_SetFilePointer($hTemp, $iWrite, 1)
				$ret = _WinAPI_SetEndOfFile($hTemp)
			Until Not $ret
			$iSize = _WinAPI_GetFileSizeEx($hTemp)
			ConsoleWrite($iSize & @CRLF)
			_WinAPI_CloseHandle($hTemp)
		EndIf
	EndIf
	;
	; allocate largest unbuffered file
	; use sector size
	ConsoleWrite("UNBUFF SECTOR" & @CRLF)
	;
	$iWrite = $iSectorSize
	$sTemp = _FileEx_GetTempFile($sDrive)
	If @error Then
		_SD_ErrorRemoveTempFiles($aFiles)
		Return SetError(4, 0, 0)
	Else
		$hTemp = _FileEx_CreateFile($sTemp, $GENERIC_WRITE, 0, $CREATE_ALWAYS, 0xA0000000)
		If @error Then
			_SD_ErrorRemoveTempFiles($aFiles)
			Return SetError(5, 0, 0)
		Else
			ConsoleWrite($sTemp & " : ")
			_SD_AddTempFile($aFiles, $sTemp)
			Do
				_WinAPI_SetFilePointer($hTemp, $iWrite, 1)
				$ret = _WinAPI_SetEndOfFile($hTemp)
			Until Not $ret
			$iSize = _WinAPI_GetFileSizeEx($hTemp)
			ConsoleWrite($iSize & @CRLF)
			_WinAPI_CloseHandle($hTemp)
		EndIf
	EndIf
	;
	; allocate buffered files
	; use 1 byte, allocate as many as possible
	ConsoleWrite("BUFF" & @CRLF)
	;
	$iWrite = 1
	While 1
		$sTemp = _FileEx_GetTempFile($sDrive)
		If @error Then
			_SD_ErrorRemoveTempFiles($aFiles)
			Return SetError(6, 0, 0)
		EndIf
		$hTemp = _FileEx_CreateFile($sTemp, $GENERIC_WRITE, 0, $CREATE_ALWAYS, 0)
		; MFT is full, done on NTFS
		If @error Then ExitLoop
		ConsoleWrite($sTemp & " : ")
		Do
			_WinAPI_SetFilePointer($hTemp, $iWrite, 1)
			$ret = _WinAPI_SetEndOfFile($hTemp)
		Until Not $ret
		$iSize = _WinAPI_GetFileSizeEx($hTemp)
		ConsoleWrite($iSize & @CRLF)
		_WinAPI_CloseHandle($hTemp)
		If Not $iSize Then
			; done on FAT, FAT32
			FileDelete($sTemp)
			ExitLoop
		Else
			_SD_AddTempFile($aFiles, $sTemp)
		EndIf
	WEnd
	;
	; securely delete all the temp files
	For $i = 1 To $aFiles[0]
		ConsoleWrite($aFiles[$i] & @CRLF)
		_SecureFileDelete($aFiles[$i], True, $aPatterns)
	Next
	;
	Return 1
EndFunc

#region INTERNAL FUNCTIONS
Func _SD_DeleteFile($sFile)
	; set length to 0
	_WinAPI_CloseHandle(_FileEx_CreateFile($sFile, $GENERIC_WRITE, $FILE_SHARE_READ, $TRUNCATE_EXISTING, 0))
	; rename the file 10 times
	Local $newfile
	Local $sDir = StringRegExpReplace($sFile, "^(.*)\\.*?$", "${1}")
	For $i = 1 To 10
		$newfile = _TempFile($sDir)
		FileMove($sFile, $newfile)
		$sFile = $newfile
	Next
	; set file time
	For $i = 0 To 2
		; reset all file timestamps to Jan. 1, 1980, 12:00:01am
		FileSetTime($sFile, "19800101000001", $i)
	Next
	; delete
	If Not FileDelete($sFile) Then Return SetError(1)
EndFunc   ;==>_SD_DeleteFile

Func _SD_IsIllegalFile($iAttr)
	; test if file is a directory or reparse point
	Return ((BitAND($iAttr, 0x10) = 0x10) Or (BitAND($iAttr, 0x400) = 0x400))
EndFunc   ;==>_SD_IsDirectory

Func _SD_IsSpecialFile($iAttr)
	; test if file is sparse, compressed, or encrypted
	Return ((BitAND($iAttr, 0x200) = 0x200) Or (BitAND($iAttr, 0x800) = 0x800) Or (BitAND($iAttr, 0x4000) = 0x4000))
EndFunc   ;==>_SD_IsSpecialFile

Func _SD_AddTempFile(ByRef $aArr, $sFile)
	$aArr[0] += 1
	ReDim $aArr[$aArr[0] + 1]
	$aArr[$aArr[0]] = $sFile
EndFunc

Func _SD_ErrorRemoveTempFiles(ByRef $aFiles)
	For $i = 1 To $aFiles[0]
		FileDelete($aFiles[$i])
	Next
EndFunc
#endregion INTERNAL FUNCTIONS
