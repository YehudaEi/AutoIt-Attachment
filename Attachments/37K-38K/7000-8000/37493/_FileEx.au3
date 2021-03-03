#include-once
#include <WinAPI.au3>

Global Const $INVALID_FILE_ATTRIBUTES = 4294967295 ; (DWORD)-1
Global Const $FILE_ATTRIBUTES_SETTABLE = 0x31A7

Func _FileEx_FileExists($sPath)
	_FileEx_GetAttributes($sPath)
	If @error Then Return SetError(@error, 0, 0)
	Return 1
EndFunc   ;==>_FileEx_FileExists

Func _FileEx_CreateFile($sPath, $iAccess, $iShareMode, $iCreation, $iFlags)
	; open the file with existing HIDDEN or SYSTEM attributes to avoid failure when using CREATE_ALWAYS
	If $iCreation = $CREATE_ALWAYS Then
		Local $sAttrib = FileGetAttrib($sPath)
		If StringInStr($sAttrib, "H") Then $iFlags = BitOR($iFlags, $FILE_ATTRIBUTE_HIDDEN)
		If StringInStr($sAttrib, "S") Then $iFlags = BitOR($iFlags, $FILE_ATTRIBUTE_SYSTEM)
	EndIf
	Local $hFile = DllCall("kernel32.dll", "handle", "CreateFileW", "wstr", $sPath, "dword", $iAccess, "dword", $iShareMode, "ptr", 0, _
			"dword", $iCreation, "dword", $iFlags, "ptr", 0)
	If @error Or ($hFile[0] = Ptr(-1)) Then Return SetError(1, 0, 0)
	Return $hFile[0]
EndFunc   ;==>_FileEx_CreateFile

Func _FileEx_AttrSettable($iAttr)
	Return BitAND($iAttr, 0x31A7)
EndFunc   ;==>_FileEx_AttrSettable

Func _FileEx_GetAttributes($sPath)
	; readonly = 0x1
	; hidden = 0x2
	; system = 0x4
	; directory = 0x10
	; archive = 0x20
	; device = 0x40
	; normal = 0x80
	; temporary = 0x100
	; sparse_file = 0x200
	; reparse_point = 0x400
	; compressed = 0x800
	; offline = 0x1000
	; not_content_indexed = 0x2000
	; encrypted = 0x4000
	; all_settable = 0x31A7
	; $INVALID_FILE_ATTRIBUTES = (DWORD)-1 = 4294967295
	Local $ret = DllCall("kernel32.dll", "dword", "GetFileAttributesW", "wstr", $sPath)
	If @error Or ($ret[0] = 4294967295) Then Return SetError(1, 0, -1)
	Return $ret[0]
EndFunc   ;==>_FileEx_GetAttributes

Func _FileEx_SetAttributes($sPath, $iAttr)
	Local $ret = DllCall("kernel32.dll", "bool", "SetFileAttributesW", "wstr", $sPath, "dword", _FileEx_AttrSettable($iAttr))
	If @error Or Not $ret[0] Then Return SetError(1, 0, 0)
	Return 1
EndFunc   ;==>_FileEx_SetAttributes

Func _FileEx_AddAttributes($sPath, $iAttr)
	Local $iA = _FileEx_GetAttributes($sPath)
	If @error Then Return SetError(1, 0, 0)
	_FileEx_SetAttributes($sPath, BitOR($iA, $iAttr))
	If @error Then Return SetError(2, 0, 0)
	Return 1
EndFunc   ;==>_FileEx_AddAttributes

Func _FileEx_RemoveAttributes($sPath, $iAttr)
	Local $iA = _FileEx_GetAttributes($sPath)
	If @error Then Return SetError(1, 0, 0)
	_FileEx_SetAttributes($sPath, BitAND($iA, BitNOT($iAttr)))
	If @error Then Return SetError(2, 0, 0)
	Return 1
EndFunc   ;==>_FileEx_RemoveAttributes

Func _FileEx_HasAttributes($sPath, $iAttr)
	Local $iA = _FileEx_GetAttributes($sPath)
	If @error Then Return SetError(1, 0, 0)
	Return Number(BitAND($iA, $iAttr) = $iAttr)
EndFunc   ;==>_FileEx_HasAttributes

Func _FileEx_IsReparsePoint($sPath)
	Local $ret = _FileEx_HasAttributes($sPath, 0x400)
	If @error Then Return SetError(1, 0, 0)
	Return $ret
EndFunc   ;==>_FileEx_IsReparsePoint

Func _FileEx_IsDirectory($sPath)
	Local $ret = _FileEx_HasAttributes($sPath, 0x10)
	If @error Then Return SetError(1, 0, 0)
	Return $ret
EndFunc   ;==>_FileEx_IsDirectory

Func _FileEx_GetFileTime($sPath, ByRef $tCreated, ByRef $tAccessed, ByRef $tModified)
	$tCreated = DllStructCreate("dword;dword")
	$tAccessed = DllStructCreate("dword;dword")
	$tModified = DllStructCreate("dword;dword")
	; FILE_FLAG_BACKUP_SEMANTICS so we can get dir handles
	Local $hFile = _FileEx_CreateFile($sPath, $GENERIC_READ, $FILE_SHARE_READ, $OPEN_EXISTING, 0x02000000)
	Local $err = 0
	Local $ret = DllCall("kernel32.dll", "bool", "GetFileTime", "handle", $hFile, "ptr", DllStructGetPtr($tCreated), "ptr", DllStructGetPtr($tAccessed), "ptr", DllStructGetPtr($tModified))
	If @error Or Not $ret[0] Then $err = 1
	_WinAPI_CloseHandle($hFile)
	Return SetError($err, 0, Abs($err - 1))
EndFunc   ;==>_FileEx_GetFileTime

Func _FileEx_SetFileTime($sPath, ByRef $tCreated, ByRef $tAccessed, ByRef $tModified)
	; FILE_FLAG_BACKUP_SEMANTICS so we can get dir handles
	Local $hFile = _FileEx_CreateFile($sPath, BitOR($GENERIC_READ, $GENERIC_WRITE), BitOR($FILE_SHARE_READ, $FILE_SHARE_WRITE), $OPEN_EXISTING, 0x02000000)
	Local $err = 0
	Local $ret = DllCall("kernel32.dll", "bool", "SetFileTime", "handle", $hFile, "ptr", DllStructGetPtr($tCreated), "ptr", DllStructGetPtr($tAccessed), "ptr", DllStructGetPtr($tModified))
	If @error Or Not $ret[0] Then $err = 1
	_WinAPI_CloseHandle($hFile)
	Return SetError($err, 0, Abs($err - 1))
EndFunc   ;==>_FileEx_SetFileTime

Func _FileEx_GetTempFile($s_DirectoryName = @TempDir, $s_FilePrefix = "~", $s_FileExtension = ".tmp", $i_RandomLength = 7)
	; Check parameters
	If Not FileExists($s_DirectoryName) Then Return SetError(1, 0, 0)
	; add trailing \ for directory name
	If StringRight($s_DirectoryName, 1) <> "\" Then $s_DirectoryName &= "\"
	;
	Local $s_TempName
	Do
		$s_TempName = ""
		While StringLen($s_TempName) < $i_RandomLength
			$s_TempName &= Chr(Random(97, 122, 1))
		WEnd
		$s_TempName = $s_DirectoryName & $s_FilePrefix & $s_TempName & $s_FileExtension
	Until Not FileExists($s_TempName)
	;
	Return $s_TempName
EndFunc   ;==>_FileEx_GetTempFile

Func _FileEx_CrackPath($sPath)
	; make sure path is terminated
	$sPath = StringRegExpReplace($sPath, "\\+$", "") & "\"
	; get prefix
	Local $aRet = StringRegExp($sPath, "(?i)^\\\\\?\\unc\\|\\\\\?\\|\\\\", 1)
	If Not IsArray($aRet) Then
		$aRet = ""
	Else
		$aRet = $aRet[0]
	EndIf
	; capture and remove the root
	If ($aRet = "\\") Or ($aRet = "\\?\UNC\") Then
		; UNC network path
		$aRet = StringRegExp($sPath, "(?i)^(" & StringReplace(StringReplace($aRet, "\", "\\"), "?", "\?") & ".*?\\.*?\\)", 1)
	Else
		; $aRet = "" or \\?\ => local path
		Local $iTrim = StringLen($aRet) + 3
		Local $aRet[1] = [StringLeft($sPath, $iTrim)]
	EndIf
	Local $aPath = StringTrimLeft($sPath, StringLen($aRet[0]))
	; check if path given was just a root
	If $aPath <> "" Then
		; crack path, prepend \ to get first segment
		$aPath = StringRegExp("\" & $aPath, "\\(.*?)(?=\\)", 3)
		ReDim $aRet[UBound($aPath) + 1]
		For $i = 0 To UBound($aPath) - 1
			$aRet[$i + 1] = $aPath[$i]
		Next
	EndIf
	;
	Return $aRet
EndFunc   ;==>_FileEx_CrackPath

Func _FileEx_CreateDirectory($sPath)
	; check path already exists
	If FileExists($sPath) Then
		; check if it is a direcotry
		If StringInStr(FileGetAttrib($sPath), "D") Then
			Return 1
		Else
			Return SetError(1, 0, 0)
		EndIf
	EndIf
	;
	; remove any terminations
	$sPath = StringRegExpReplace($sPath, "\\+$", "")
	Local $aPath = _FileEx_CrackPath($sPath)
	; make sure root exists
	Local $sSegment = $aPath[0]
	If Not FileExists($sSegment) Then Return SetError(2, 0, 0)
	Local $ret
	For $i = 1 To UBound($aPath) - 1
		$sSegment &= $aPath[$i] & "\"
		If Not FileExists($sSegment) Then
			; create sub-path
			$ret = DllCall("kernel32.dll", "bool", "CreateDirectoryW", "wstr", $sSegment, "ptr", 0)
			If @error Or Not $ret[0] Then Return SetError(3, 0, 0)
		EndIf
	Next
	Return 1
EndFunc   ;==>_FileEx_CreateDirectory

Func _FileEx_RemoveDirectory($sPath, $fRoot = True)
	; only run checks for root path
	If $fRoot Then
		; check it exists
		If Not FileExists($sPath) Then Return SetError(1, 0, 0)
		; remove trailing \'s
		$sPath = StringRegExpReplace($sPath, "\\+$", "")
		; check it is a directory
		If Not StringInStr(FileGetAttrib($sPath), "D") Then Return SetError(2, 0, 0)
	EndIf
	;
	Local $item, $ret
	Local $search = FileFindFirstFile($sPath & "\*.*")
	If $search <> -1 Then
		While 1
			$item = FileFindNextFile($search)
			If @error Then ExitLoop
			If @extended Then
				; sub-dir
				_FileEx_RemoveDirectory($sPath & "\" & $item, False)
				If @error Then
					FileClose($search)
					Return SetError(3, 0, 0)
				EndIf
			Else
				; file
				$ret = DllCall("kernel32.dll", "bool", "DeleteFileW", "wstr", $sPath & "\" & $item)
				If @error Or Not $ret[0] Then
					FileClose($search)
					Return SetError(4, 0, 0)
				EndIf
			EndIf
		WEnd
		FileClose($search)
	EndIf
	; delete dir
	$ret = DllCall("kernel32.dll", "bool", "RemoveDirectoryW", "wstr", $sPath)
	If @error Or Not $ret[0] Then Return SetError(5, 0, 0)
	Return 1
EndFunc   ;==>_FileEx_RemoveDirectory
