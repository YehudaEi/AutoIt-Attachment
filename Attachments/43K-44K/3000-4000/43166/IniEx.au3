#include-Once

; #INDEX# =======================================================================================================================
; Title .........: IniEx
; AutoIt Version : v3.3.9.22++
; Language ......: English
; Description ...: INI File Processing Functions
; Author(s) .....: DXRW4E
; ===============================================================================================================================

; #CURRENT# =====================================================================================================================
;_IniClearCache()
;_IniCloseFileEx()
;_IniDeleteEx()
;_IniFileWriteEx()
;_IniGetFileInformationEx()
;_IniGetFileStringData()
;_IniGetSectionNumberEx()
;_IniOpenFileEx()
;_IniOpenFile()
;_IniReadEx()
;_IniReadSectionEx()
;_IniReadSectionNamesEx()
;_IniRenameSectionEx()
;_IniWriteEx()
;_IniWriteSectionEx()
; ===============================================================================================================================

; #INTERNAL_USE_ONLY# ===========================================================================================================
;__GetSeparatorCharacter()
;__IniFileWriteEx()
;__IniGetFileStringData()
;__IniReadSectionEx()
;__IniSaveCache()
;__IniWriteSectionEx()
; ===============================================================================================================================

; #CONSTANTS# ===================================================================================================================
Global Const $INI_STRIPLEADING            = 1           ; $STR_STRIPLEADING  - strip leading white space
Global Const $INI_STRIPTRAILING           = 2           ; $STR_STRIPTRAILING - strip trailing white space
Global Const $INI_STRIPLEADTRAILING       = 3	        ; BitOR($STR_STRIPLEADING,  $STR_STRIPTRAILING)

Global Const $INI_ARRAYDATA               = 4
Global Const $INI_ARRAYDATA_NOCOUNT       = 8
Global Const $INI_NOWRITEREADONLY         = 16
Global Const $INI_FO_UNICODE              = 32          ; $FO_UNICODE
Global Const $INI_FO_UTF16_LE             = 32          ; $FO_UTF16_LE
Global Const $INI_FO_UTF16_BE             = 64          ; $FO_UTF16_BE
Global Const $INI_FO_UTF8                 = 128         ; $FO_UTF8
Global Const $INI_FO_UTF8_NOBOM           = 256         ; $FO_UTF8_NOBOM
Global Const $INI_NOOCCURRENCE            = 512
Global Const $INI_MERGE                   = 1024
Global Const $INI_NOCREATE                = 2048
Global Const $INI_APPENDDATA              = 4096
Global Const $INI_REPLACEONLY             = 8192
Global Const $INI_FO_UTF8_FULL            = 16384       ; $FO_UTF8_FULL
Global Const $INI_NOOVERWRITE             = 32768
Global Const $INI_OVERWRITEALL            = 65536
Global Const $INI_IGNOREDUPLICATE         = 131072
Global Const $INI_DELETE                  = 262144
Global Const $INI_RENAME                  = 524288
Global Const $INI_REMOVE                  = 1048576
;Global Const $INI_RESERVED*               = 2097152
;Global Const $INI_RESERVED*               = 4194304
;Global Const $INI_RESERVED*               = 8388608
Global Const $INI_OPEN_EXISTING           = 16777216
Global Const $INI_CREATEPATH              = 33554432
Global Const $INI_REPAIR_ERROR            = 67108864
Global Const $INI_DISCARDCHANGES          = 134217728
Global Const $INI_OPEN_FILEQUEUE          = 268435456
;Global Const $INI_RESERVED*               = 536870912
Global Const $INI_2DARRAYFIELD            = 1073741824

;;;; THESE ARE SPECIAL FLAGS, ARE USED INTERNALLY ONLY ;;;;
Global Const $INI_INTERNAL_USE_ONLY       = 2147483648
Global Const $INI_FO_STYLE                = BitOR(31, $INI_OPEN_EXISTING, $INI_CREATEPATH, $INI_REPAIR_ERROR, $INI_OPEN_FILEQUEUE)
Global Const $INI_MERGE_NOOCCURRENCE      = BitOR($INI_MERGE, $INI_NOOCCURRENCE)
Global Const $INI_REMOVE_RENAME           = BitOR($INI_REMOVE, $INI_RENAME)
Global Const $INI_REMOVE_DELETE           = BitOR($INI_REMOVE, $INI_DELETE)
Global Const $INI_NOCREATE_REMOVE_DELETE  = BitOR($INI_NOCREATE, $INI_REMOVE, $INI_DELETE)
Global Const $INI_NOOCCURRENCE_IGNOREDUPLICATE = BitOr($INI_NOOCCURRENCE, $INI_IGNOREDUPLICATE)
Global Const $INI_OVERWRITEALL_APPENDDATA = BitOR($INI_OVERWRITEALL, $INI_APPENDDATA)

Global Const $NULL_REF = Null
Global Const $sINI_OPENFILE_EX            = @LF & "[]" & @LF

;;;; DO NOT EVER USE\CHANGE\EDIT THESE VARIABLES ;;;;
;;;;  THESE VARIABLES ARE USED INTERNALLY ONLY   ;;;;
Global Static $INI_NULL_REF = Null
Global Static $_HINI[11][11] = [[10, 0]]
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; ===============================================================================================================================



; #FUNCTION# ====================================================================================================================
; Name...........: _IniOpenFileEx
; Description ...: The _IniOpenFileEx function opens an INI file and returns a handle to it.
; Syntax.........: _IniOpenFileEx($sFilePath[, $iFlags]])
; Parameters ....: $sFilePath       - INI File Path
;				   $iFlags          - Optional, (add the flags together for multiple operations):
;                  This Flags will be ignored if the $INI_CREATEPATH is not set\used
;                  | A file may fail to open due to access rights or attributes.
;                  | The default mode when writing text is ANSI - use the unicode flags to change this. When writing unicode files
;                  | the Windows default mode (and the fastest in AutoIt due to the least conversion) is UTF16 Little Endian (mode 32).
;                  | $INI_FO_* Flags will be ignored if the $INI_CREATEPATH is not Set\Used
;                  |$INI_FO_UNICODE or $INI_UTF16_LE (32) - Use Unicode UTF16 Little Endian reading and writing mode. Reading does not override existing BOM.
;                  |$INI_FO_UTF16_BE (64)                 - Use Unicode UTF16 Big Endian reading and writing mode. Reading does not override existing BOM.
;                  |$INI_FO_UTF8 (128)                    - Use Unicode UTF8 (with BOM) reading and writing mode. Reading does not override existing BOM.
;                  |$INI_FO_UTF8_NOBOM (256)              - Use Unicode UTF8 (without BOM) reading and writing mode.
;                  |$INI_FO_UTF8_FULL (16384)             - When opening for reading and no BOM is present, use full file UTF8 detection. If this is not used then only the initial part of the file is checked for UTF8.
;                  ;;;;;;;;;;;;
;                  |$INI_OPEN_EXISTING (16777216)      - If the INI File (Path) is Already Open use that (Handle) (Default Always Opens a New)
;                  |$INI_CREATEPATH (33554432)         - Create INI File if does not exist (Default if file not exist Return Error)
;                  |$INI_REPAIR_ERROR (67108864)       - If exist Error when Opening the INI File Repair Error, example as this line (@CRLF & [SectionName & @CRLF) repair in (@CRLF & [SectionName] & @CRLF), Default Return Error
;                  |$INI_OPEN_FILEQUEUE (268435456)    - Open INI file from Memory\Variable, $sFilePath must contain String Text Data of INI file
; Return values .: Success - INI Handle
;                  Failure - Returns 0 or String\Text of error line (check @Extended for error line number)
;                  @Error  - 0 = No error.
;                  |1 = File cannot be opened or found.
;                  |2 = Error when Opening the INI File
; Remarks .......:
; Author ........: DXRW4E
; ===============================================================================================================================
Func _IniOpenFileEx($sFilePath, $iFlags = 0)
	If BitAND($iFlags, $INI_OPEN_EXISTING) Then
		For $i = 1 To $_HINI[0][0]
			If $_HINI[$i][2] = $sFilePath Then Return SetError(0, $i, $i)
		Next
	EndIf
	Local $sCS, $_sCS = "\r", $hFilePath, $iFileEncoding, $aFileData, $aErrorLine, $iFO_Style = BitXOR(BitOR($iFlags, $INI_FO_STYLE), $INI_FO_STYLE)
	If BitAND($iFlags, $INI_OPEN_FILEQUEUE) Then
		$aFileData = StringRegExpReplace($sINI_OPENFILE_EX & $sFilePath, '\r(?!\n)', @CRLF)	;;;;, '(?<!\r)\n', @CRLF)
		$sFilePath = "FileQueue"
		$iFileEncoding = $iFO_Style	;;(StringIsASCII($aFileData) ? 0 : 32)
	Else
		$hFilePath = FileOpen($sFilePath)
		If $hFilePath = -1 Then
			If Not FileExists($sFilePath) Then
				If Not BitAND($iFlags, $INI_CREATEPATH) Then Return SetError(1, 0, 0)
				$iFO_Style += 10		;;$iFO_Style = 42
			EndIf
			$hFilePath = FileOpen($sFilePath, $iFO_Style)
			If $hFilePath = -1 Then Return SetError(1, 0, 0)
		EndIf
		$aFileData = StringRegExpReplace($sINI_OPENFILE_EX & FileRead($hFilePath), '\r(?!\n)', @CRLF)	;;;;, '(?<!\r)\n', @CRLF)
		$iFileEncoding = FileGetEncoding($hFilePath)
		FileClose($hFilePath)
	EndIf
	$aErrorLine = StringRegExp($aFileData, '\n\K[\h\f\xb\x0]*\[[^\]\n]*(?:\n|$)', 1)
	If Not @Error Then
		Local $iErrorLine = @Extended - (StringLen($aErrorLine[0]) - 1)
		If Not BitAND($iFlags, $INI_REPAIR_ERROR) Then Return SetError(2, StringSplit(StringLeft($aFileData, $iErrorLine), @LF)[0] - 2, $aErrorLine[0])
		$aFileData = StringRegExpReplace($aFileData, '(\n[\h\f\xb\x0]*\[[^\]\r\n]*)(?=[\r\n]|$)', "$1]")
	EndIf
	$sCS = __GetSeparatorCharacter($aFileData)
	If $sCS = @CR Then $_sCS = ""
	$aFileData = StringRegExpReplace($aFileData & @CRLF & "[", "\n\K(?>[" & $_sCS & "\n\h\f\xb\x0]*\n|\x0*)(?=[\h\f\xb\x0]*\[)", $sCS & "${0}" & $sCS)
	$aFileData = StringRegExp($aFileData & $sCS, $sCS & "([\h\f\xb\x0]*\[)([^\]\n]*)(\][^\n]*\n)((?>[" & $_sCS & "\n\h\f\xb\x0]*\n)*)([^" & $sCS & "]*)" & $sCS & "([^" & $sCS & "]*)", 3)
	$aFileData[0] = UBound($aFileData) - 1
	If $aFileData[0] < 5 Then Return SetError(1, 0, 0) ; should not happen ever
	$aFileData[$aFileData[0]] = StringTrimRight($aFileData[$aFileData[0]], 2)
	For $iHINI = 1 To $_HINI[0][0]
		If Not $_HINI[$iHINI][0] Then ExitLoop
	Next
	If $iHINI > $_HINI[0][0] Then
		ReDim $_HINI[$iHINI + $iHINI][11]
		$_HINI[0][0] = $iHINI + $iHINI - 1
	EndIf
	$aFileData[2] = $iHINI
	If Not $_sCS Then
		$aFileData[3] = StringAddCR($aFileData[3])
		$aFileData[4] = StringAddCR($aFileData[4])
		$aFileData[5] = StringAddCR($aFileData[5])
	EndIf
	For $i = 7 To $aFileData[0] Step 6
		$_HINI[$iHINI][5] &= @LF & $aFileData[$i] & @CR & $i
		If Not $_sCS Then
			$aFileData[$i + 1] = StringAddCR($aFileData[$i + 1])
			$aFileData[$i + 2] = StringAddCR($aFileData[$i + 2])
			$aFileData[$i + 3] = StringAddCR($aFileData[$i + 3])
			$aFileData[$i + 4] = StringAddCR($aFileData[$i + 4])
		EndIf
	Next
	$_HINI[0][1] += 1	;;($_HINI[0][1] < 1) ? 1 : $_HINI[0][1] + 1
	$_HINI[$iHINI][0] = $iHINI
	$_HINI[$iHINI][1] = $aFileData
	$_HINI[$iHINI][2] = $sFilePath
	$_HINI[$iHINI][3] = $iFileEncoding
	$_HINI[$iHINI][4] = ($aFileData[0] - 5) / 6
	$_HINI[$iHINI][5] = StringReplace($_HINI[$iHINI][5], "\E", "\e", 0, 1)
	$_HINI[$iHINI][7] = Null
	Return $iHINI
EndFunc   ;==>_IniOpenFileEx


; #FUNCTION# ====================================================================================================================
; Name...........: _IniOpenFile
; Description ...: The _IniOpenFile function opens an INI file and returns a handle to it.
; Parameters ....: the same as the _IniOpenFileEx(), See _IniOpenFileEx()
; Return values .: See _IniOpenFileEx()
; Author ........: DXRW4E
; Modified.......:
; Remarks .......: _IniOpenFile() is the same as the _IniOpenFileEx(), only that _IniOpenFile()  force the check\repair of @CR or @LF in @CRLF
;                    performance\speed does not change much with _IniOpenFileEx(), _IniOpenFile() can only be about 1% or 5% or10% slower
; ===============================================================================================================================
Func _IniOpenFile($sFilePath, $iFlags = 0)
    If BitAND($iFlags, $INI_OPEN_EXISTING) Then
        For $i = 1 To $_HINI[0][0]
            If $_HINI[$i][2] = $sFilePath Then Return SetError(0, $i, $i)
        Next
    EndIf
    Local $hFilePath, $iFileEncoding, $aFileData, $aErrorLine, $iFO_Style = BitXOR(BitOR($iFlags, $INI_FO_STYLE), $INI_FO_STYLE)
    If BitAND($iFlags, $INI_OPEN_FILEQUEUE) Then
        $aFileData = StringRegExpReplace($sINI_OPENFILE_EX & $sFilePath, '\r\n?', @LF)
        $sFilePath = "FileQueue"
        $iFileEncoding = $iFO_Style    ;;(StringIsASCII($aFileData) ? 0 : 32)
    Else
        $hFilePath = FileOpen($sFilePath)
        If $hFilePath = -1 Then
            If Not FileExists($sFilePath) Then
                If Not BitAND($iFlags, $INI_CREATEPATH) Then Return SetError(1, 0, 0)
                $iFO_Style += 10        ;;$iFO_Style = 42
            EndIf
            $hFilePath = FileOpen($sFilePath, $iFO_Style)
            If $hFilePath = -1 Then Return SetError(1, 0, 0)
        EndIf
        $aFileData = StringRegExpReplace($sINI_OPENFILE_EX & FileRead($hFilePath), '\r\n?', @LF)
        $iFileEncoding = FileGetEncoding($hFilePath)
        FileClose($hFilePath)
    EndIf
    $aErrorLine = StringRegExp($aFileData, '\n\K[\h\f\xb\x0]*\[[^\]\n]*(?:\n|$)', 1)
    If Not @Error Then
        Local $iErrorLine = @Extended - (StringLen($aErrorLine[0]) - 1)
        If Not BitAND($iFlags, $INI_REPAIR_ERROR) Then Return SetError(2, StringSplit(StringLeft($aFileData, $iErrorLine), @LF)[0] - 2, $aErrorLine[0])
        $aFileData = StringRegExpReplace($aFileData, '(\n[\h\f\xb\x0]*\[[^\]\n]*)(?=\n|$)', "$1]")
    EndIf
    $aFileData = StringRegExpReplace($aFileData & @LF & "[", '\n\K(?>[\n\h\f\xb\x0]*\n|\x0*)(?=[\h\f\xb\x0]*\[)', @CR & "${0}" & @CR)
    $aFileData = StringRegExp($aFileData & @CR, '\r([\h\f\xb\x0]*\[)([^\]\n]*)(\][^\n]*\n)((?>[\n\h\f\xb\x0]*\n)*)([^\r]*)\r([^\r]*)', 3)
    $aFileData[0] = UBound($aFileData) - 1
    If $aFileData[0] < 5 Then Return SetError(1, 0, 0) ; should not happen ever
    $aFileData[$aFileData[0]] = StringTrimRight($aFileData[$aFileData[0]], 1)
    For $iHINI = 1 To $_HINI[0][0]
        If Not $_HINI[$iHINI][0] Then ExitLoop
    Next
    If $iHINI > $_HINI[0][0] Then
        ReDim $_HINI[$iHINI + $iHINI][11]
        $_HINI[0][0] = $iHINI + $iHINI - 1
    EndIf
    $aFileData[2] = $iHINI
	$aFileData[3] = StringAddCR($aFileData[3])
    $aFileData[4] = StringAddCR($aFileData[4])
    $aFileData[5] = StringAddCR($aFileData[5])
    For $i = 7 To $aFileData[0] Step 6
        $_HINI[$iHINI][5] &= @LF & $aFileData[$i] & @CR & $i
        $aFileData[$i + 1] = StringAddCR($aFileData[$i + 1])
        $aFileData[$i + 2] = StringAddCR($aFileData[$i + 2])
        $aFileData[$i + 3] = StringAddCR($aFileData[$i + 3])
        $aFileData[$i + 4] = StringAddCR($aFileData[$i + 4])
    Next
    $_HINI[0][1] += 1    ;;($_HINI[0][1] < 1) ? 1 : $_HINI[0][1] + 1
    $_HINI[$iHINI][0] = $iHINI
    $_HINI[$iHINI][1] = $aFileData
    $_HINI[$iHINI][2] = $sFilePath
    $_HINI[$iHINI][3] = $iFileEncoding
    $_HINI[$iHINI][4] = ($aFileData[0] - 5) / 6
    $_HINI[$iHINI][5] = StringReplace($_HINI[$iHINI][5], "\E", "\e", 0, 1)
    $_HINI[$iHINI][7] = Null
    Return $iHINI
EndFunc   ;==>_IniOpenFileEx


; #FUNCTION# ====================================================================================================================
; Name...........: _IniCloseFileEx
; Description ...: The _IniCloseFileEx function closes the INI file opened by a call to _IniOpenFileEx.
; Syntax.........: _IniCloseFileEx($hIniFile[, $iFlags])
; Parameters ....: $hIniFile - Handle or INI Path to the INI file to be closed, This parameter can be NULL (use the $NULL_REF to set NULL this parameter)
;                    if $hIniFile is NULL Function Close All Open Handle or INI Path
;				   $iFlags  - Optional, Flag to indicate the type of action that should be performed (add the flags together for multiple operations):
;                  |Default - always Commits the changes that were made when the INI file was opened by _IniOpenFileEx()
;                  |$INI_DISCARDCHANGES (134217728) - Discards the changes that were made when the INI file was opened by _IniOpenFileEx()
; Return values .: NONE
; Author ........: DXRW4E
; Remarks .......:
; ===============================================================================================================================
Func _IniCloseFileEx($hIniFile, $iFlags = 0)
	If $hIniFile = $NULL_REF Then
		For $i = 1 To $_HINI[0][0]
			If Not BitAND($iFlags, $INI_DISCARDCHANGES) And $_HINI[$i][2] <> "FileQueue" Then _IniFileWriteEx($i, $iFlags)
			For $y = 0 To 10
				$_HINI[$i][$y] = ""
			Next
		Next
		$_HINI[0][1] = 0
	Else
		$hIniFile = _IniGetFileInformationEx($hIniFile)
		If @Error Then Return SetError(1, 0, 0)
		If Not BitAND($iFlags, $INI_DISCARDCHANGES) And $_HINI[$hIniFile][2] <> "FileQueue" Then _IniFileWriteEx($hIniFile, $iFlags)
		For $i = 0 To 10
			$_HINI[$hIniFile][$i] = ""
		Next
		$_HINI[0][1] -= 1
	EndIf
	Return 0
EndFunc   ;==>_IniCloseFileEx


; #FUNCTION# ====================================================================================================================
; Name...........: _IniDeleteEx
; Description ...: Delete\Remove - Section\KeyName in INI File.
; Syntax.........: _IniDeleteEx(ByRef $hIniFile, $sSectionName[, $sKeyName[, $iFlags[, $scKeyName]]])
; Parameters ....: $hIniFile     - Handle to the INI file to query "see _IniOpenFileEx()"
;				   $sSectionName - The name of the section containing the Key\Value, This parameter can be NULL (use the $NULL_REF to set NULL this parameter)
;                    If $sSectionName is NULL, $hIniFile must be contain Section String\Key\Value\Data and $sKeyName the name of the key to delete
;                  $sKeyName     - The key name to delete, If $INI_OVERWRITEALL if set\used, $sKeyName will be writte exactly as in $sKeyName (without Edit\Formatting)
;                    This parameter can be NULL (use the $NULL_REF to set NULL this parameter), If $sKeyName is NULL, $hIniFile must be contain INI String\Text Data and $sSectionName the name of the section to delete
;				   $iFlags       - Optional, Flag to indicate the type of action that should be performed (add the flags together for multiple operations):
;                  |$INI_NOOCCURRENCE (512)       - Check only first section if there are more than one
;                  |$INI_IGNOREDUPLICATE (131072) - Proceed\Execute (Add\Delete\Replace\Edit ect ect) Once Only (Ignore all other Duplicate\Occurrences of KeyName\Value\Data)
;                  |$INI_DELETE (262144)          - Delete\Remove KeyName\Value\Data
;                  |$INI_REMOVE (1048576)         - Remove\Delete Section
;				   $scKeyName    - Optional, Key-Name separator character, Default is '=', This parameter can not be '"' or @CR or @LF
; Return values .: Returns a 0 (check @Extended for number of edit performed)
;                  @Error  - 0 = No error.
;                  |1 = Invalid IniHandle.
;                  |3 = SectionName not found
; Remarks .......: $INI_MERGE (1024) - (Join section if more than one in INI file) is always set\used by default, to disable it just use the $INI_NOOCCURRENCE
; Author ........: DXRW4E
; ===============================================================================================================================
Func _IniDeleteEx(ByRef $hIniFile, $sSectionName, $sKeyName = "", $iFlags = 0, $scKeyName = "=")
	If Not $scKeyName Then $scKeyName = "="
	If $sSectionName = $NULL_REF Then
		Local $iOffSet = StringInStr($hIniFile, @LF, 1)
		If StringRegExp(StringLeft($hIniFile, $iOffSet), '^(?i)[\h\f\xb\x0]*(?>\Q"' & $sKeyName & '"\E|\Q' & $sKeyName & '\E)[\h\f\xb\x0]*' & $scKeyName & '[\h\f\xb\x0]*[^\n]*') Then
			If Not BitAND($iFlags, $INI_IGNOREDUPLICATE) Then $hIniFile = StringRegExpReplace($hIniFile, '\n[\h\f\xb\x0]*(?i)(?>\Q"' & $sKeyName & '"\E|\Q' & $sKeyName & '\E)[\h\f\xb\x0]*' & $scKeyName & '[\h\f\xb\x0]*[^\n]*', "")
			$hIniFile = StringTrimLeft($hIniFile, $iOffSet)
			SetExtended(1)
		Else
			$hIniFile = StringRegExpReplace($hIniFile, '\n[\h\f\xb\x0]*(?i)(?>\Q"' & $sKeyName & '"\E|\Q' & $sKeyName & '\E)[\h\f\xb\x0]*' & $scKeyName & '[\h\f\xb\x0]*[^\n]*', "", (BitAND($iFlags, $INI_IGNOREDUPLICATE) ? 1 : 0))
		EndIf
	ElseIf $sKeyName = $NULL_REF Then
		;Not Recommended (NOT SAFE), if the Section (contains) String\Text Data is greater than 4.5 MB, the Section will be ignored
		$hIniFile = StringTrimRight(StringRegExpReplace($hIniFile & @LF & "[", "(?is)\n[\h\f\xb\x0]*\[\Q" & StringReplace($sSectionName, "\E", "\e", 0, 1) & "\E\][^\n]*(?>\n?(?![\h\f\xb\x0]*\[))(.*?(?=\n[\h\f\xb\x0]*\[))", "", (BitAND($iFlags, $INI_IGNOREDUPLICATE) ? 1 : 0)), 2)
	Else
		If $hIniFile < 1 Or $hIniFile > $_HINI[0][0] Then Return SetError(1, 0, "")
		;;;;If Not $sSectionName Then Return SetError(2, 0, "")	;Invalid Section Name
		If StringInStr($sSectionName, "\E", 1) Then $sSectionName = StringReplace($sSectionName, "\E", "\e", 0, 1)
		If Not $sKeyName Or BitAND($iFlags, $INI_REMOVE_DELETE) = $INI_REMOVE Then
			$iFlags = BitOr($iFlags, $INI_REMOVE)
			__IniWriteSectionEx($hIniFile, $sSectionName, $INI_NULL_REF, $iFlags, $INI_NULL_REF, $_HINI[$hIniFile][1])
		Else
			$iFlags = BitOR(BitAND($iFlags, $INI_NOOCCURRENCE_IGNOREDUPLICATE), $INI_DELETE, $INI_MERGE)
			If $_HINI[$hIniFile][7] <> $sSectionName Or ($_HINI[$hIniFile][8] > 1 And BitAND($iFlags, $INI_MERGE_NOOCCURRENCE) <> BitAND($_HINI[$hIniFile][9], $INI_MERGE_NOOCCURRENCE)) Then
				__IniReadSectionEx($hIniFile, $sSectionName, $iFlags, $_HINI[$hIniFile][1])
				If @Error Then Return SetError(3, 0, "")
			EndIf
			Local $aKeyValue[2][3] = [[1],[$sKeyName]]
			__IniWriteSectionEx($hIniFile, $sSectionName, $aKeyValue, $iFlags, $scKeyName, $_HINI[$hIniFile][1])
		EndIf
	EndIf
	Return SetError(0, @Extended, 0)
EndFunc


; #FUNCTION# ====================================================================================================================
; Name...........: _IniReadEx
; Description ...: The _IniReadEx Retrieves a string from the specified section in an Ini file
; Syntax.........: _IniReadEx($hIniFile, $sSectionName, $sKeyName[, $sDefault[, $iFlags[, $scKeyName]]])
; Parameters ....: $hIniFile      - Handle to the INI file to query "see _IniOpenFileEx()"
;				   $sSectionName  - The name of the section containing the key name, This parameter can be NULL (use the $NULL_REF to set NULL this parameter)
;                    If $sSectionName is NULL, $hIniFile must be contain Section String\Key\Value\Data
;				   $sKeyName      - The name of the key whose associated string is to be retrieved
;				   $sDefault      - The default value to return if the requested KeyName is not found.
;				   $iFlags        - Optional, Flag to indicate the type of action that should be performed (add the flags together for multiple operations):
;                  |$INI_ARRAYDATA (4)         - Read All KeyName and Return Array of ValueString
;                  |$INI_ARRAYDATA_NOCOUNT (8) - Disable the return count in the first element, This Flags will be ignored if the $INI_ARRAYDATA is not set\used
;                  |$INI_NOOCCURRENCE (512)    - Read only first section if there are more than one
;                  |$INI_MERGE (1024)          - Join section if more than one in INI file, This Flag will be ignored if the $INI_NOOCCURRENCE is set\used
;				   $scKeyName - Optional, Key-Name separator character, Default is '=', This parameter can not be '"' or @CR or @LF
; Return values .: The first occurrence of requested key value as a string Or Array of Value String
;                  Failure - Returns $sDefault parameter
;                  @Error  - 0 = No error.
;                  |1 = Invalid IniHandle.
;                  |3 = SectionName not found
;                  |5 = Invalid KeyName
;                  |6 = KeyName not found
; Remarks .......:
; Author ........: DXRW4E
; ===============================================================================================================================
Func _IniReadEx(ByRef $hIniFile, $sSectionName, $sKeyName, $sDefault = "", $iFlags = 0, $scKeyName = "=")
	;;If Not $sKeyName Then Return SetError(5, 0, "")
	If StringInStr($sKeyName, "\E", 1) Then $sKeyName = StringReplace($sKeyName, "\E", "\e", 0, 1)
	Local $aValueString, $sValueString, $iArray = BitAND($iFlags, $INI_ARRAYDATA)
	If $sSectionName = $NULL_REF Then
		$aValueString = StringRegExp(StringLeft($hIniFile, StringInStr($hIniFile, @LF, 1)), '^(?i)[\h\f\xb\x0]*(?>\Q"' & $sKeyName & '"\E|\Q' & $sKeyName & '\E)(?>[\h\f\xb\x0]*' & $scKeyName & '[\h\f\xb\x0]*)(?|"([^\r\n]*)"|(.*?))[\h\f\xb\x0]*(?=[\r\n]|$)', 1)
	Else
		If $hIniFile < 1 Or $hIniFile > $_HINI[0][0] Then Return SetError(1, 0, "")
		If StringInStr($sSectionName, "\E", 1) Then $sSectionName = StringReplace($sSectionName, "\E", "\e", 0, 1)
		If $_HINI[$hIniFile][7] <> $sSectionName Or ($_HINI[$hIniFile][8] > 1 And BitAND($iFlags, $INI_MERGE_NOOCCURRENCE) <> BitAND($_HINI[$hIniFile][9], $INI_MERGE_NOOCCURRENCE)) Then
			_IniReadSectionEx($hIniFile, $sSectionName, BitOR($iFlags, $INI_STRIPLEADTRAILING))
			If @Error Then Return SetError(3, 0, "")
		EndIf
		$aValueString = StringRegExp(StringLeft(($_HINI[$hIniFile][1])[$_HINI[$hIniFile][10]], StringInStr(($_HINI[$hIniFile][1])[$_HINI[$hIniFile][10]], @LF, 1)), '^(?i)[\h\f\xb\x0]*(?>\Q"' & $sKeyName & '"\E|\Q' & $sKeyName & '\E)(?>[\h\f\xb\x0]*' & $scKeyName & '[\h\f\xb\x0]*)(?|"([^\r\n]*)"|(.*?))[\h\f\xb\x0]*(?=[\r\n]|$)', 1)
		;;;;$aValueString = StringRegExp(($sSectionName = $NULL_REF ? $hIniFile : ($_HINI[$hIniFile][1])[$_HINI[$hIniFile][10]]), '(?im)^[\h\f\xb\x0]*(?>\Q"' & $sKeyName & '"\E|\Q' & $sKeyName & '\E)[\h\f\xb\x0]*' & $scKeyName & '[\h\f\xb\x0]*(?|"([^\r\n]*)"|(.*?))[\h\f\xb\x0]*(?=[\r\n]|$)', 3)
	EndIf
	If Not @Error Then
		If Not $iArray Then Return $aValueString[0]
		$sValueString = $aValueString[0] & @LF
	EndIf
	$aValueString = StringRegExp(($sSectionName = $NULL_REF ? $hIniFile : ($_HINI[$hIniFile][1])[$_HINI[$hIniFile][10]]), '\n[\h\f\xb\x0]*(?i)(?>\Q"' & $sKeyName & '"\E|\Q' & $sKeyName & '\E)(?>[\h\f\xb\x0]*' & $scKeyName & '[\h\f\xb\x0]*)(?|"([^\r\n]*)"|(.*?))[\h\f\xb\x0]*(?=[\r\n]|$)', ($iArray ? 3 : 1))
	If @Error Then Return SetError(6, 0, $sDefault)
	If Not $iArray Then Return $aValueString[0]
	For $i = 0 To UBound($aValueString) - 1
		$sValueString &= $aValueString[$i] & @LF
	Next
	Return StringSplit(StringTrimRight($sValueString, 1), @LF, (BitAND($iFlags, $INI_ARRAYDATA_NOCOUNT) ? 3 : 1))
EndFunc   ;==>_IniReadEx


; #FUNCTION# ====================================================================================================================
; Name...........: _IniReadSectionEx
; Description ...: The _IniReadSectionEx Retrieves all the lines for the specified section
; Syntax.........: _IniReadSectionEx(ByRef $hIniFile, $sSectionName[, $iFlags[, $scKeyName])
; Parameters ....: $hIniFile      - Handle to the INI file to query "see _IniOpenFileEx()"
;				   $sSectionName  - The name of the section containing the Key\Value, This parameter can be NULL (use the $NULL_REF to set NULL this parameter)
;                    If $sSectionName is NULL, $hIniFile must be contain Section String\Key\Value\Data
;				   $iFlags        - Optional, Flag to indicate the type of action that should be performed (add the flags together for multiple operations):
;                    Default Return Section String\Text Data
;                  |$INI_NOOCCURRENCE (512)        - Read only first section if there are more than one
;                  |$INI_MERGE (1024)              - Join section if more than one in INI file, This Flag will be ignored if the $INI_NOOCCURRENCE is set\used
;                  |$INI_2DARRAYFIELD (1073741824) - Return 2DArray
;                     $aArray[0][0] = number of elements
;                     $aArray[0][1] = Key-Name separator character, Defaut is '='
;                     $aArray[1][0] = "KeyName"
;                     $aArray[1][1] = "Value"
;                     $aArray[1][2] = "Unmodified contents of a line (example '	KeyName  = Value')"
;                     $aArray[n][0] = "KeyName"
;                     $aArray[n][1] = "Value"
;                     $aArray[n][2] = "Unmodified contents of a line (example ' KeyName =  Value')"
;				   $scKeyName - Optional, Key-Name separator character, Default is '=', This parameter can not be '"' or @CR or @LF
; Return values .: String\Text Data Or 2D Array
;                  @Error  - 0 = No error.
;                  |1 = Invalid IniHandle.
;                  |3 = SectionName's not found
;                  |4 = Array is invalid, Key\Value not found
; Remarks .......:
; Author ........: DXRW4E
; ===============================================================================================================================
Func _IniReadSectionEx(ByRef $hIniFile, $sSectionName, $iFlags = 0, $scKeyName = "=")
	If Not $scKeyName Then $scKeyName = "="
	If $sSectionName = $NULL_REF Then
		Local $_aSectionData = StringRegExp($hIniFile, '(?m)^((?>[\h\f\xb\x0]*)((?>"[^"\r\n]+"|(?:[^"\s' & $scKeyName & '\x0]+|(?>[\h\f\xb\x0]+)(?!' & $scKeyName & '))*))(?>[\h\f\xb\x0]*' & $scKeyName & '[\h\f\xb\x0]*)(?|"([^\r\n]*)"|(.*?))[\h\f\xb\x0]*(?=[\r\n]|$))', 3)
	Else
		If $hIniFile < 1 Or $hIniFile > $_HINI[0][0] Then Return SetError(1, 0, "")
		If $_HINI[$hIniFile][7] <> $sSectionName Or ($_HINI[$hIniFile][8] > 1 And BitAND($iFlags, $INI_MERGE_NOOCCURRENCE) <> BitAND($_HINI[$hIniFile][9], $INI_MERGE_NOOCCURRENCE)) Then
			$iFlags = BitOR($iFlags, $INI_NOCREATE)
			__IniReadSectionEx($hIniFile, $sSectionName, $iFlags, $_HINI[$hIniFile][1])
			If @Error Then Return SetError(3, 0, "")
		EndIf
		If Not BitAND($iFlags, $INI_2DARRAYFIELD) Then Return ($_HINI[$hIniFile][1])[$_HINI[$hIniFile][10]]
		Local $_aSectionData = StringRegExp(($_HINI[$hIniFile][1])[$_HINI[$hIniFile][10]], '(?m)^((?>[\h\f\xb\x0]*)((?>"[^"\r\n]+"|(?:[^"\s' & $scKeyName & '\x0]+|(?>[\h\f\xb\x0]+)(?!' & $scKeyName & '))*))(?>[\h\f\xb\x0]*' & $scKeyName & '[\h\f\xb\x0]*)(?|"([^\r\n]*)"|(.*?))[\h\f\xb\x0]*(?=[\r\n]|$))', 3)
	EndIf
	If @Error Then Return SetError(4, 0, "")
	Local $iaSectionData = UBound($_aSectionData), $aSectionData[$iaSectionData / 3 + 1][3] = [[0,$scKeyName,$iaSectionData - 1]]
	For $i = 0 To $aSectionData[0][2] Step 3
		$aSectionData[0][0] += 1
		$aSectionData[$aSectionData[0][0]][0] = $_aSectionData[$i + 1]
		$aSectionData[$aSectionData[0][0]][1] = $_aSectionData[$i + 2]
		$aSectionData[$aSectionData[0][0]][2] = $_aSectionData[$i]
	Next
	Return SetError(0, $aSectionData[0][0], $aSectionData)
EndFunc   ;==>_IniReadSectionEx


; #FUNCTION# ====================================================================================================================
; Name...........: _IniReadSectionNamesEx
; Description ...: The _IniReadSectionNamesEx Retrieves the names of all sections in an INI file
; Syntax.........: _IniReadSectionNamesEx($hIniFile[, $iFlags])
; Parameters ....: $hIniFile - Handle to the INI file to query "see _IniOpenFileEx()"
;				   $iFlags   - Optional, Flag to indicate the type of action that should be performed
;                  |$INI_ARRAYDATA_NOCOUNT (8) - disable the return count in the first element
;                  |$NULL_REF (NULL)           - $hIniFile must be contain INI String\Section\Key\Value\Data
; Return values .: Array of SectionNames String, and set @Extended = Number of Section's
;                  @Error  - 0 = No error.
;                  |1 = Array is invalid, Invalid IniHandle.
;                  |3 = Array is invalid, SectionName's not found
; Remarks .......:
; Author ........: DXRW4E
; ===============================================================================================================================
Func _IniReadSectionNamesEx(ByRef $hIniFile, $iFlags = 0)
	If $iFlags = $NULL_REF Then
		Local $aSectionNames, $iANC = BitAND($iFlags, $INI_ARRAYDATA_NOCOUNT)
		$aSectionNames = StringRegExp(($iANC ? @LF : @LF & "[]" & @LF) & $hIniFile, "\n[\h\f\xb\x0]*\[([^\r\n]*)\]", 3)
		If @Error Then Return SetError(1, 0, "")
		If $iANC Then Return SetError(0, UBound($aSectionNames), $aSectionNames)
		$aSectionNames[0] = UBound($aSectionNames) - 1
		Return SetError(0, $aSectionNames[0], $aSectionNames)
	EndIf
	If $hIniFile < 1 Or $hIniFile > $_HINI[0][0] Then Return SetError(1, 0, "")
	If Not $_HINI[$hIniFile][4] Then Return SetError(3, 0, "")
	If BitAND($iFlags, $INI_ARRAYDATA_NOCOUNT) Then Return SetError(0, $_HINI[$hIniFile][4], StringRegExp($_HINI[$hIniFile][5], "\n([^\r\n]*)", 3))
	Return SetError(0, $_HINI[$hIniFile][4], StringRegExp(@LF & $_HINI[$hIniFile][4] & $_HINI[$hIniFile][5], "\n([^\r\n]*)", 3))
EndFunc   ;==>_IniReadSectionNamesEx


; #FUNCTION# ====================================================================================================================
; Name...........: _IniRenameSectionEx
; Description ...: The _IniRenameSectionEx rename the sections in an INI file
; Syntax.........: _IniRenameSectionEx($hIniFile[, $iFlags])
; Parameters ....: $hIniFile      - Handle to the INI file to query "see _IniOpenFileEx()"
;				   $iFlags        - Optional, Flag to indicate the type of action that should be performed (add the flags together for multiple operations):
;                  |$INI_NOOCCURRENCE (512) - Rename only first section if there are more than one
;                  |$INI_MERGE (1024)       - Join section if more than one in INI\INI file, This Flag will be ignored if the $INI_NOOCCURRENCE is set\used
;                  |$NULL_REF (NULL)        - $hIniFile must be contain INI String\Section\Key\Value\Data
; Return values .: Returns a 0 (check @Extended for number of edit performed)
;                  @Error  - 0 = No error.
;                  |1 = Invalid IniHandle.
;                  |3 = SectionName's not found
; Remarks .......:
; Author ........: DXRW4E
; ===============================================================================================================================
Func _IniRenameSectionEx(ByRef $hIniFile, $sSectionName, $sNewSectionName, $iFlags = 0)
	;;;;If Not $sSectionName Or Not $sNewSectionName Then Return SetError(2, 0, "")	;Invalid Section Name
	If $iFlags = $NULL_REF Then
		$hIniFile = StringRegExpReplace($hIniFile, "(?mi)^[\h\f\xb\x0]*\[\K\Q" & StringReplace($sSectionName, "\E", "\e", 0, 1) & "\E(?=\])", StringReplace($sNewSectionName, "\", "\\", 0, 1), (BitAND($iFlags, $INI_NOOCCURRENCE) ? 1 : 0))
	Else
		If $hIniFile < 1 Or $hIniFile > $_HINI[0][0] Then Return SetError(1, 0, "")
		If StringInStr($sSectionName, "\E", 1) Then $sSectionName = StringReplace($sSectionName, "\E", "\e", 0, 1)
		$iFlags = BitXOR(BitOR($iFlags, $INI_REMOVE_RENAME), $INI_REMOVE)
		If BitAND($iFlags, $INI_MERGE_NOOCCURRENCE) = $INI_MERGE And Not __IniReadSectionEx($hIniFile, $sSectionName, $iFlags, $_HINI[$hIniFile][1]) Then Return SetError(3, 0, 0)
		__IniWriteSectionEx($hIniFile, $sSectionName, $sNewSectionName, $iFlags, $INI_NULL_REF, $_HINI[$hIniFile][1])
	EndIf
	Return SetError(@Error, @Extended, 0)
EndFunc   ;==>_IniRenameSectionEx


; #FUNCTION# ====================================================================================================================
; Name...........: _IniWriteEx
; Description ...: Write\Add\Replace\Delete\Change\Edit a KeyName\Value\Data in INI File
; Syntax.........: _IniWriteEx(ByRef $hIniFile, $sSectionName, $sKeyName, $sValue[, $iFlags[, $scKeyName]])
; Parameters ....: $hIniFile     - Handle to the INI file to query "see _IniOpenFileEx()"
;				   $sSectionName - The name of the section containing the Key\Value, This parameter can be NULL (use the $NULL_REF to set NULL this parameter)
;                    If $sSectionName is NULL, $hIniFile must be contain Section String\Key\Value\Data
;                  $sKeyName     - The key name in the in the .ini file.
;                  $sKeyName     - The value to write/change.
;				   $iFlags       - Optional, Flag to indicate the type of action that should be performed (add the flags together for multiple operations):
;                  |$INI_STRIPLEADING (1)         - strip leading white space Section, This Flag will be ignored if the $INI_OVERWRITEALL or $INI_APPENDDATA is set\used
;                  |$INI_STRIPTRAILING (2)        - trailing white space Section, This Flag will be ignored if the $INI_OVERWRITEALL or $INI_APPENDDATA is set\used
;                  |$INI_NOOCCURRENCE (512)       - Check only first section if there are more than one
;                  |$INI_NOCREATE (2048)          - Not Create New Section If Section Not Exist
;                  |$INI_APPENDDATA (4096)        - Add KeyName\Value\Data (Append Mod)
;                  |$INI_REPLACEONLY (8192)       - Add KeyName\Value\Data Only if Exist
;                  |$INI_NOOVERWRITE (32768)      - Add KeyName\Value\Data Only if Not Exist
;                  |$INI_OVERWRITEALL (65536)     - Overwrite All data in Section (Replaces all KeyName\Value\Data in the Section)
;                  |$INI_IGNOREDUPLICATE (131072) - Proceed\Execute (Add\Delete\Replace\Edit ect ect) Once Only (Ignore all other Duplicate\Occurrences of KeyName\Value\Data)
;                  |$INI_DELETE (262144)          - Delete\Remove KeyName\Value\Data
;				   $scKeyName     - Optional, Key-Name separator character, Default is '=', This parameter can not be '"' or @CR or @LF
; Return values .: Returns a 0 (check @Extended for number of edit performed)
;                  @Error  - 0 = No error.
;                  |1 = Invalid IniHandle.
;                  |3 = SectionName's not found
;                  |5 = Invalid KeyName
; Author ........: DXRW4E
; Remarks .......: $INI_MERGE (1024) - (Join section if more than one in INI file) is always set\used by default, to disable it just use the $INI_NOOCCURRENCE
; ===============================================================================================================================
Func _IniWriteEx(ByRef $hIniFile, $sSectionName, $sKeyName, $sValue, $iFlags = 0, $scKeyName = "=")
	;;If Not $sKeyName Then Return SetError(5, 0, "")
	If Not $scKeyName Then $scKeyName = "="
	If $sSectionName = $NULL_REF Then
		If BitAND($iFlags, $INI_OVERWRITEALL_APPENDDATA) Then
			If BitAND($iFlags, $INI_OVERWRITEALL) Then $hIniFile = ""
			$hIniFile &= $sKeyName & $scKeyName & $sValue & @CRLF
		Else
			Local $asKeyValue, $sKNPattern, $iOffSet = StringInStr($hIniFile, @LF, 1)
			$sKNPattern = '\n[\h\f\xb\x0]*(?i)(?>\Q"' & $sKeyName & '"\E|\Q' & $sKeyName & '\E)[\h\f\xb\x0]*' & $scKeyName & '[\h\f\xb\x0]*[^\n]*'
			If StringRegExp(StringLeft($hIniFile, $iOffSet), '^(?i)[\h\f\xb\x0]*(?>\Q"' & $sKeyName & '"\E|\Q' & $sKeyName & '\E)[\h\f\xb\x0]*' & $scKeyName & '[\h\f\xb\x0]*[^\n]*') Then
				If Not BitAND($iFlags, $INI_IGNOREDUPLICATE) Then $hIniFile = StringRegExpReplace($hIniFile, $sKNPattern, "")
				If BitAND($iFlags, $INI_DELETE) Then
					$hIniFile = StringTrimLeft($hIniFile, $iOffSet)
				ElseIf Not BitAND($iFlags, $INI_NOOVERWRITE) Then
					$hIniFile = $sKeyName & $scKeyName & $sValue & @CRLF & StringTrimLeft($hIniFile, $iOffSet)
				EndIf
			ElseIf BitAND($iFlags, $INI_DELETE) Then
				$hIniFile = StringRegExpReplace($hIniFile, $sKNPattern, "", (BitAND($iFlags, $INI_IGNOREDUPLICATE) ? 1 : 0))
			Else
				$asKeyValue = StringRegExp($hIniFile, $sKNPattern, 1)
				$iOffSet = @Extended - 1
				If Not @Error Then
					If BitAND($iFlags, $INI_NOOVERWRITE) Then
						If Not BitAND($iFlags, $INI_IGNOREDUPLICATE) Then $hIniFile = StringLeft($hIniFile, $iOffSet) & StringRegExpReplace(StringTrimLeft($hIniFile, $iOffSet), $sKNPattern, "")
					Else
						$hIniFile = StringLeft($hIniFile, $iOffSet + 1 - StringLen($asKeyValue[0])) & $sKeyName & $scKeyName & $sValue & @CR & (BitAND($iFlags, $INI_IGNOREDUPLICATE) ? StringTrimLeft($hIniFile, $iOffSet) : StringRegExpReplace(StringTrimLeft($hIniFile, $iOffSet), $sKNPattern, ""))
					EndIf
				ElseIf Not BitAND($iFlags, $INI_REPLACEONLY) Then
					$hIniFile &= $sKeyName & $scKeyName & $sValue & @CRLF
				Else
					Return SetError(0, 0, 0)
				EndIf
			EndIf
		EndIf
		Return SetError(0, 1, 0)
	Else
		If $hIniFile < 1 Or $hIniFile > $_HINI[0][0] Then Return SetError(1, 0, "")
		;;;;If Not $sSectionName Then Return SetError(2, 0, "")	;Invalid Section Name
		If StringInStr($sSectionName, "\E", 1) Then $sSectionName = StringReplace($sSectionName, "\E", "\e", 0, 1)
		Local $aKeyValue[2][3] = [[1],[$sKeyName,"",$sKeyName & $scKeyName & $sValue]]
		$iFlags = BitOR(BitXOR($iFlags, BitAND($iFlags, $INI_REMOVE_RENAME)), $INI_MERGE)
		If $_HINI[$hIniFile][7] <> $sSectionName Or ($_HINI[$hIniFile][8] > 1 And BitAND($iFlags, $INI_MERGE_NOOCCURRENCE) <> BitAND($_HINI[$hIniFile][9], $INI_MERGE_NOOCCURRENCE)) Then
			__IniReadSectionEx($hIniFile, $sSectionName, $iFlags, $_HINI[$hIniFile][1])
			If @Error Then Return SetError(3, 0, "")
		EndIf
		__IniWriteSectionEx($hIniFile, $sSectionName, $aKeyValue, $iFlags, $scKeyName, $_HINI[$hIniFile][1])
	EndIf
	Return SetError(@Error, @Extended, 0)
EndFunc


; #FUNCTION# ====================================================================================================================
; Name...........: _IniWriteSectionEx
; Description ...: Add\Replace\Delete\Remove\Rename\Change\Edit a Section\KeyName\Value\Data in INI File.
; Syntax.........: _IniWriteSectionEx()
; Parameters ....: $hIniFile     - Handle to the INI file to query "see _IniOpenFileEx()"
;				   $sSectionName - The name of the section containing the Key\Value\Data
;                  $aKeyValue    - String\Text Data (example 'KeyName=Value 7 @LF & KeyName2=Value2') or an 2DArray is passed as data, the return Array of IniReadSectionEx() can be used immediately.
;                    If $aKeyValue is String\Text Data and $INI_OVERWRITEALL or $INI_APPENDDATA if Set\Used, $aKeyValue will be writte exactly as in $aKeyValue (without Edit\Formatting)
;				   $iFlags       - Optional, Flag to indicate the type of action that should be performed (add the flags together for multiple operations):
;                  |$INI_STRIPLEADING (1)         - strip leading white space Section, This Flag will be ignored if the $INI_OVERWRITEALL or $INI_APPENDDATA is set\used
;                  |$INI_STRIPTRAILING (2)        - trailing white space Section, This Flag will be ignored if the $INI_OVERWRITEALL or $INI_APPENDDATA is set\used
;                  |$INI_NOOCCURRENCE (512)       - Check only first section if there are more than one
;                  |$INI_NOCREATE (2048)          - Not Create New Section If Section Not Exist
;                  |$INI_APPENDDATA (4096)        - Add KeyName\Value\Data (Append Mod)
;                  |$INI_REPLACEONLY (8192)       - Add KeyName\Value\Data Only if Exist
;                  |$INI_NOOVERWRITE (32768)      - Add KeyName\Value\Data Only if Not Exist
;                  |$INI_OVERWRITEALL (65536)     - Overwrite All data in Section (Replaces all KeyName\Value\Data in the Section)
;                  |$INI_IGNOREDUPLICATE (131072) - Proceed\Execute (Add\Delete\Replace\Edit ect ect) Once Only (Ignore all other Duplicate\Occurrences of KeyName\Value\Data)
;                  |$INI_DELETE (262144)          - Delete\Remove KeyName\Value\Data
;                  |$INI_RENAME (524288)          - Renames a section
;                  |$INI_REMOVE (1048576)         - Remove\Delete Section
;				   $scKeyName     - Optional, Key-Name separator character, Default is '=', This parameter can not be '"' or @CR or @LF
; Return values .: Returns a 0 (check @Extended for number of edit performed)
;                  @Error  - 0 = No error.
;                  |1 = Invalid IniHandle.
;                  |3 = SectionName's not found
;                  |5 = Invalid KeyName
; Remarks .......:
; Author ........: DXRW4E
; Remarks .......: $INI_MERGE (1024) - (Join section if more than one in INI file) is always set\used by default, to disable it just use the $INI_NOOCCURRENCE
; ===============================================================================================================================
Func _IniWriteSectionEx(ByRef $hIniFile, $sSectionName, $aKeyValue, $iFlags = 0, $scKeyName = "=")
;~ 	If $sSectionName = $NULL_REF Then
;~ 		If Not $scKeyName Then $scKeyName = "="
;~ 		If IsArray($aKeyValue) Then
;~ 			Local $iCols = UBound($aKeyValue, 2)
;~ 			If UBound($aKeyValue, 0) <> 2 Or $iCols < 2 Then Return SetError(7, 0, "")
;~ 			If $iCols = 2 Then
;~ 				ReDim $aKeyValue[$aKeyValue[0][0] + 1][3]
;~ 				For $i = 1 To $aKeyValue[0][0]
;~ 					$aKeyValue[$i][2] = $aKeyValue[$i][0] & $scKeyName & $aKeyValue[$i][1]
;~ 				Next
;~ 			EndIf
;~ 		ElseIf Not BitAND($iFlags, $INI_OVERWRITEALL_APPENDDATA) Then
;~ 			$aKeyValue = _IniReadSectionEx($aKeyValue, Null, $INI_2DARRAYFIELD, $scKeyName)
;~ 			If @Error Then Return SetError(7, 0, "")
;~ 		EndIf
;~ 		If BitAND($iFlags, $INI_OVERWRITEALL_APPENDDATA) Then
;~ 			If BitAND($iFlags, $INI_OVERWRITEALL) Then $hIniFile = ""
;~ 			If IsArray($aKeyValue) Then
;~ 				For $i = 1 To $aKeyValue[0][0]
;~ 					$hIniFile &= $aKeyValue[$i][2] & @CRLF
;~ 				Next
;~ 			Else
;~ 				;;	KeyName\Value\Text Data will be writte exactly as in $aKeyValue (without Edit\Formatting ect ect)
;~ 				$hIniFile &= $aKeyValue & (StringRight($aKeyValue, 1) = @LF ? "" : @CRLF)
;~ 			EndIf
;~ 			Return SetError(0, 1, 0)
;~ 		Else
;~ 			Local $asKeyValue, $iKeyValue = 0, $sKNPattern, $iOffSet = StringInStr($hIniFile, @LF, 1)
;~ 			For $i = 1 To $aKeyValue[0][0]
;~ 				$sKNPattern = '\n[\h\f\xb\x0]*(?i)(?>\Q"' & $aKeyValue[$i][0] & '"\E|\Q' & $aKeyValue[$i][0] & '\E)[\h\f\xb\x0]*' & $scKeyName & '[\h\f\xb\x0]*[^\n]*'
;~ 				If StringRegExp(StringLeft($hIniFile, $iOffSet), '^(?i)[\h\f\xb\x0]*(?>\Q"' & $aKeyValue[$i][0] & '"\E|\Q' & $aKeyValue[$i][0] & '\E)[\h\f\xb\x0]*' & $scKeyName & '[\h\f\xb\x0]*[^\n]*') Then
;~ 					If Not BitAND($iFlags, $INI_IGNOREDUPLICATE) Then $hIniFile = StringRegExpReplace($hIniFile, $sKNPattern, "")
;~ 					If BitAND($iFlags, $INI_DELETE) Then
;~ 						$hIniFile = StringTrimLeft($hIniFile, $iOffSet)
;~ 					ElseIf Not BitAND($iFlags, $INI_NOOVERWRITE) Then
;~ 						$hIniFile = $aKeyValue[$i][2] & @CRLF & StringTrimLeft($hIniFile, $iOffSet)
;~ 					EndIf
;~ 				ElseIf BitAND($iFlags, $INI_DELETE) Then
;~ 					$hIniFile = StringRegExpReplace($hIniFile, $sKNPattern, "", (BitAND($iFlags, $INI_IGNOREDUPLICATE) ? 1 : 0))
;~ 				Else
;~ 					$asKeyValue = StringRegExp($hIniFile, $sKNPattern, 1)
;~ 					$iOffSet = @Extended - 1
;~ 					If Not @Error Then
;~ 						If BitAND($iFlags, $INI_NOOVERWRITE) Then
;~ 							If Not BitAND($iFlags, $INI_IGNOREDUPLICATE) Then $hIniFile = StringLeft($hIniFile, $iOffSet) & StringRegExpReplace(StringTrimLeft($hIniFile, $iOffSet), $sKNPattern, "")
;~ 						Else
;~ 							$hIniFile = StringLeft($hIniFile, $iOffSet + 1 - StringLen($asKeyValue[0])) & $aKeyValue[$i][2] & @CR & (BitAND($iFlags, $INI_IGNOREDUPLICATE) ? StringTrimLeft($hIniFile, $iOffSet) : StringRegExpReplace(StringTrimLeft($hIniFile, $iOffSet), $sKNPattern, ""))
;~ 						EndIf
;~ 					ElseIf Not BitAND($iFlags, $INI_REPLACEONLY) Then
;~ 						$hIniFile &= $aKeyValue[$i][2] & @CRLF
;~ 					Else
;~ 						$iKeyValue -= 1
;~ 					EndIf
;~ 				EndIf
;~ 				$iKeyValue += 1
;~ 			Next
;~ 			Return SetError(0, $iKeyValue, 0)
;~ 		EndIf
;~ 	EndIf
	If $hIniFile < 1 Or $hIniFile > $_HINI[0][0] Then Return SetError(1, 0, "")
	;;;;If Not $sSectionName Then Return SetError(2, 0, "")	;Invalid Section Name
	If StringInStr($sSectionName, "\E", 1) Then $sSectionName = StringReplace($sSectionName, "\E", "\e", 0, 1)
	If BitAND($iFlags, $INI_REMOVE) Then
		__IniWriteSectionEx($hIniFile, $sSectionName, $INI_NULL_REF, $iFlags, $INI_NULL_REF, $_HINI[$hIniFile][1])
	ElseIf BitAND($iFlags, $INI_RENAME) Then
		;;;;	$aKeyValue is New Section Name
		;;If Not $aKeyValue Then Return SetError(5, 0, "")
		If BitAND($iFlags, $INI_MERGE_NOOCCURRENCE) = $INI_MERGE And Not __IniReadSectionEx($hIniFile, $sSectionName, $iFlags, $_HINI[$hIniFile][1]) Then Return SetError(3, 0, 0)
		__IniWriteSectionEx($hIniFile, $sSectionName, $aKeyValue, $iFlags, $INI_NULL_REF, $_HINI[$hIniFile][1])
	Else
		If Not $scKeyName Then $scKeyName = "="
		If IsArray($aKeyValue) Then
			Local $iCols = UBound($aKeyValue, 2)
			If UBound($aKeyValue, 0) <> 2 Or $iCols < 2 Then Return SetError(5, 0, "")
			If $iCols = 2 Then
				ReDim $aKeyValue[$aKeyValue[0][0] + 1][3]
				For $i = 1 To $aKeyValue[0][0]
					$aKeyValue[$i][2] = $aKeyValue[$i][0] & $scKeyName & $aKeyValue[$i][1]
				Next
			EndIf
		ElseIf Not BitAND($iFlags, $INI_OVERWRITEALL_APPENDDATA) Then
			$aKeyValue = _IniReadSectionEx($aKeyValue, Null, $INI_2DARRAYFIELD, $scKeyName)
			If @Error Then Return SetError(5, 0, "")
		EndIf
		$iFlags = BitOR($iFlags, $INI_MERGE)
		If $_HINI[$hIniFile][7] <> $sSectionName Or ($_HINI[$hIniFile][8] > 1 And BitAND($iFlags, $INI_MERGE_NOOCCURRENCE) <> BitAND($_HINI[$hIniFile][9], $INI_MERGE_NOOCCURRENCE)) Then
			__IniReadSectionEx($hIniFile, $sSectionName, $iFlags, $_HINI[$hIniFile][1])
			If @Error Then Return SetError(3, 0, "")
		EndIf
		__IniWriteSectionEx($hIniFile, $sSectionName, $aKeyValue, $iFlags, $scKeyName, $_HINI[$hIniFile][1])
	EndIf
	Return SetError(@Error, @Extended, 0)
EndFunc


; #FUNCTION# ====================================================================================================================
; Name...........: _IniGetSectionNumberEx
; Description ...: The _IniGetSectionNumberEx Retrieves the number of all sections in an INI file
; Syntax.........: _IniGetSectionNumberEx(Byref $hIniFile)
; Parameters ....: $hIniFile      - Handle to the INI file to query "see _IniOpenFileEx()"
; Return values .: Number of Section's
;                  @Error  - 0 = No error.
;                  |1 = Invalid IniHandle.
;                  |3 = SectionName's not found
; Remarks .......:
; Author ........: DXRW4E
; ===============================================================================================================================
Func _IniGetSectionNumberEx(ByRef $hIniFile)
	If $hIniFile < 1 Or $hIniFile > $_HINI[0][0] Then
		Local $aSectionNames = StringRegExp(@LF & $hIniFile, "\n[\h\f\xb\x0]*\[[^\r\n]*\K\]", 3)	;StringRegExp($hIniFile, "(?m)^[\h\f\xb\x0]*\[[^\r\n]*\]", 3)
		Return SetError(@Error, 0, UBound($aSectionNames))
	EndIf
	Return SetError(($_HINI[$hIniFile][4] ? 0 : 3), 0, $_HINI[$hIniFile][4])
EndFunc   ;==>_IniGetSectionNumberEx


; #FUNCTION# ===========================================================================================================
; Name...........: _IniGetFileInformationEx
; Description ...: Returns information about an INI file
; Syntax.........: _IniGetFileInformationEx($hIniFile[, $iFlags])
; Parameters ....: $hIniFile    - Handle of INI file previously opened by _IniOpenFileEx, see _IniOpenFileEx()
;                  $iFlags - Optional
;                  |0  - Return INI Handle (Default)
;                  |1  - Return INI File Array Data (is array of arrays)
;                  |2  - Return INI File Path
;                  |3  - Return INI Encoding
;                  |4  - Return INI Section Number
; Return values .: See Flag parameter
; Author ........: DXRW4E
; Modified.......:
; Remarks .......:
; ===============================================================================================================================
Func _IniGetFileInformationEx($hIniFile, $iFlags = 0)
	If Not $hIniFile Then Return SetError(1, 0, "")
	If $_HINI[0][1] < 0 Then
		$_HINI[0][1] = 0
		Return SetError(1, 0, "")
	ElseIf IsString($hIniFile) Then
		;;If StringIsDigit($hIniFile) And StringLeft($hIniFile, 1) <> "0" Then
		;;	$hIniFile = Number($hIniFile)
		;;Else
			For $i = 1 To $_HINI[0][0]
				If $_HINI[$i][2] = $hIniFile Then ExitLoop
			Next
			$hIniFile = $i
		;;EndIf
	EndIf
	If $hIniFile < 1 Or $hIniFile > $_HINI[0][0] Then Return SetError(1, 0, "")	; Or $hIniFile <> $_HINI[$hIniFile][0]
	If $iFlags < 1 Or $iFlags > 4 Then Return $hIniFile
	Return SetError(0, $hIniFile, $_HINI[$hIniFile][$iFlags])
EndFunc   ;==>_IniGetFileInformationEx


; #FUNCTION# ====================================================================================================================
; Name...........: _IniGetFileStringData
; Description ...: The _IniGetFileStringData Retrieves all INI Lines\String\Text Data
; Syntax.........: _IniGetFileStringData(ByRef $hIniFile[, $iFlags])
; Parameters ....: $hIniFile      - Handle to the INI file to query "see _IniOpenFileEx()"
;				   $iFlags        - Optional, Flag to indicate the type of action that should be performed (add the flags together for multiple operations):
;                  |$INI_STRIPLEADING (1)          - strip leading white space Section
;                  |$INI_STRIPTRAILING (2)         - strip trailing white space Section
; Return values .: String\Text Data
;                  @Error  - 0 = No error.
;                  |1 = Invalid IniHandle.
; Remarks .......:
; Author ........: DXRW4E
; ===============================================================================================================================
Func _IniGetFileStringData(ByRef $hIniFile, $iFlags = 0)
	If $hIniFile < 1 Or $hIniFile > $_HINI[0][0] Then Return SetError(1, 0, "")
	;;Local $sData, $iSL = BitAND($iFlags, $INI_STRIPLEADING), $iST = BitAND($iFlags, $INI_STRIPTRAILING)
	;;$sData = ($iSL ? "" : ($_HINI[$hIniFile][1])[3]) & ($_HINI[$hIniFile][1])[4] & ($iST ? "" : ($_HINI[$hIniFile][1])[5])
	;;For $i = 6 To ($_HINI[$hIniFile][1])[0] Step 6
	;;	$sData &= ($_HINI[$hIniFile][1])[$i] & ($_HINI[$hIniFile][1])[$i + 1] & ($_HINI[$hIniFile][1])[$i + 2] & ($iSL ? "" : ($_HINI[$hIniFile][1])[$i + 3]) & ($_HINI[$hIniFile][1])[$i + 4] & ($iST ? "" : ($_HINI[$hIniFile][1])[$i + 5])
	;;Next
	Local $sData = __IniGetFileStringData($hIniFile, $iFlags, $_HINI[$hIniFile][1])
	Return SetError(0, $_HINI[$hIniFile][3], $sData)
EndFunc   ;==>_IniGetFileStringData


; #FUNCTION# ====================================================================================================================
; Name...........: _IniClearCache
; Description ...: Clear INI File Processing Functions Cache
; Syntax.........: _IniClearCache(ByRef $aIniFile)
; Parameters ....: $hIniFile     - Handle to the INI file to query "see _IniOpenFileEx()"
; Return values .: None
; Author ........: DXRW4E
; Modified.......:
; Remarks .......: This function is useful to Run after _IniRea*Ex Funcion's, only in the case when in the INI file are duplicated function
;                   and if the flag $INI_MERGE or $INI_NOOCCURRENCE is not set\used, because in this case the _IniReadEx\_IniReadSectionEx saves
;                   in cache the Function's\String\Data to be fast during the loop ect ect, so only in cases when you Get\Read Occurrence Function
;                   and the flag $INI_MERGE or $INI_NOOCCURRENCE is not set\used
;                   All other function as _IniDeleteEx or _IniWrite*Ex use by Default or Force the use of $INI_MERGE flag
;                   So in 99.9% of cases you do not Need\Have to run _IniClearCache(), because the INI File Processing Functions Work's only By Reference
; ===============================================================================================================================
Func _IniClearCache(ByRef $hIniFile)
	If $hIniFile < 1 Or $hIniFile > $_HINI[0][0] Then Return SetError(1, 0, "")
	$_HINI[$hIniFile][6] = ""
	__IniSaveCache($hIniFile, $_HINI[$hIniFile][6], $INI_NULL_REF, $_HINI[$hIniFile][6], $_HINI[$hIniFile][6], $_HINI[$hIniFile][1])
	Return 0
EndFunc   ;==>_IniClearCache


; #FUNCTION# ====================================================================================================================
; Name...........: _IniFileWrite
; Description ...: Write a Ini File
; Syntax.........: _IniFileWriteEx(ByRef $hIniFile[, $iFlags[, $sFilePath[, $iFileEncoding]]])
; Parameters ....: $hIniFile      - Handle to the INI file to query "see _IniOpenFileEx()"
;				   $iFlags        - Optional, Flag to indicate the type of action that should be performed (add the flags together for multiple operations):
;                  |$INI_STRIPLEADING (1)     - strip leading white space Section
;                  |$INI_STRIPTRAILING (2)    - trailing white space Section
;                  |$INI_NOWRITEREADONLY (16) - Do not Write\Replace\Edit the ReadOnly file (Default Write\Replace\Edit the ReadOnly files)
;				   $sFilePath     - Optional, use alternative FilePath, By Default always is used (Default) PathFile
;				   $iFileEncoding - Optional, use alternative FileEncoding, By Default always is used (Default) FileEncoding
; Return values .: Returns a 0
;                  @Error  - 0 = No error.
;                  |1  =  Invalid IniHandle.
;                  |9  =  Invalid FilePath
;                  |10 = A file may fail to open due to access rights or attributes.
; Remarks .......:
; Author ........: DXRW4E
; ===============================================================================================================================
Func _IniFileWriteEx(ByRef $hIniFile, $iFlags = 0, $sFilePath = Default, $iFileEncoding = Default)
	If $hIniFile < 1 Or $hIniFile > $_HINI[0][0] Then Return SetError(1, 0, "")
	If $_HINI[$hIniFile][2] = "FileQueue" And Not $sFilePath Then Return SetError(9, 0, "")
	If $sFilePath = Default Then $sFilePath = $_HINI[$hIniFile][2]
	If $iFileEncoding = Default Then $iFileEncoding = $_HINI[$hIniFile][3] + 10
	;;Local $hFileOpen, $iSL = BitAND($iFlags, $INI_STRIPLEADING), $iST = BitAND($iFlags, $INI_STRIPTRAILING)
	;;$hFileOpen = FileOpen($_HINI[$hIniFile][2], $_HINI[$hIniFile][3] + 10)
	;; ;; Check if file opened for writing OK
	;;If $hFileOpen = -1 Then
	;;	Return SetError(10, 0, 0)
	;;EndIf
	;;FileWrite($hFileOpen, ($iSL ? "" : ($_HINI[$hIniFile][1])[3]) & ($_HINI[$hIniFile][1])[4] & ($iST ? "" : ($_HINI[$hIniFile][1])[5]))
	;;For $i = 6 To ($_HINI[$hIniFile][1])[0] Step 6
	;;	FileWrite($hFileOpen, ($_HINI[$hIniFile][1])[$i] & ($_HINI[$hIniFile][1])[$i + 1] & ($_HINI[$hIniFile][1])[$i + 2] & ($iSL ? "" : ($_HINI[$hIniFile][1])[$i + 3]) & ($_HINI[$hIniFile][1])[$i + 4] & ($iST ? "" : ($_HINI[$hIniFile][1])[$i + 5]))
	;;Next
	;;FileClose($hFileOpen)
	__IniFileWriteEx($hIniFile, $iFlags, $sFilePath, $iFileEncoding, $_HINI[$hIniFile][1])
	Return SetError(@Error, @Extended, 0)
EndFunc   ;==>_IniFileWriteEx



; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name...........: __IniReadSectionEx
; Description ...: Support Function for _IniReadSectionEx
; Syntax.........: __IniReadSectionEx(ByRef $aIniFile, ByRef $sSectionName, ByRef $iFlags)
; Parameters ....: See _IniReadSectionEx()
; Return values .: See _IniReadSectionEx()
; Author ........: DXRW4E
; Modified.......:
; Remarks .......: This function is used internally by _IniReadSectionEx
; ===============================================================================================================================
Func __IniReadSectionEx(ByRef $hIniFile, ByRef $sSectionName, ByRef $iFlags, ByRef $aIniFile)
	;;;;If Not $sSectionName Then Return SetError(2, 0, "")	;Invalid Section Name
	If StringInStr($sSectionName, "\E", 1) Then $sSectionName = StringReplace($sSectionName, "\E", "\e", 0, 1)
	Local $sSectionData, $aSectionName, $iSectionName = 1
	$aSectionName = StringRegExp($_HINI[$hIniFile][5], "\n(?is)\Q" & $sSectionName & "\E\r([^\n]+)", 3)
	If @Error Then
		If BitAND($iFlags, $INI_NOCREATE_REMOVE_DELETE) Then Return SetError(3, 0, "")
		$aIniFile[0] += 6
		Redim $aIniFile[$aIniFile[0] + 1]
		$aIniFile[$aIniFile[0] - 5] = "["
		$aIniFile[$aIniFile[0] - 4] = $sSectionName
		$aIniFile[$aIniFile[0] - 3] = "]" & @CRLF
		$_HINI[$hIniFile][4] += 1
		$_HINI[$hIniFile][5] &= @LF & $sSectionName & @CR & ($aIniFile[0] - 4)
		$_HINI[$hIniFile][6] = $aIniFile[0] - 1
	Else
		$_HINI[$hIniFile][6] = $aSectionName[0] + 3
		$iSectionName = UBound($aSectionName)
		;;If BitAND($iFlags, $INI_STRIPLEADTRAILING) = $INI_STRIPLEADTRAILING Then	;; BitOR($INI_STRIPLEADING,  $INI_STRIPTRAILING)
		;;	$sSectionData = $aIniFile[$aSectionName[0] + 3]
		;;ElseIf BitAND($iFlags, $INI_STRIPLEADING) Then
		;;	$sSectionData = $aIniFile[$aSectionName[0] + 3] & $aIniFile[$aSectionName[0] + 4]
		;;ElseIf BitAND($iFlags, $INI_STRIPTRAILING) Then
		;;	$sSectionData = $aIniFile[$aSectionName[0] + 2] & $aIniFile[$aSectionName[0] + 3]
		;;Else
		;;	$sSectionData = $aIniFile[$aSectionName[0] + 2] & $aIniFile[$aSectionName[0] + 3] & $aIniFile[$aSectionName[0] + 4]
		;;EndIf
		If Not BitAND($iFlags, $INI_NOOCCURRENCE) And $iSectionName > 1 Then
			$sSectionData = $aIniFile[$aSectionName[0] + 3]
			For $i = 1 To $iSectionName - 1
				$sSectionData &= $aIniFile[$aSectionName[$i] + 3]
				If BitAND($iFlags, $INI_MERGE) Then
					For $y = $aSectionName[$i] - 1 To $aSectionName[$i] + 4
						$aIniFile[$y] = ""
					Next
					$_HINI[$hIniFile][5] = StringRegExpReplace($_HINI[$hIniFile][5], '\n(?is)\Q' & $sSectionName & '\E\r' & $aSectionName[$i], "")
				EndIf
			Next
			If BitAND($iFlags, $INI_MERGE) Then $aIniFile[$aSectionName[0] + 3] = $sSectionData
		EndIf
	EndIf
	__IniSaveCache($hIniFile, $sSectionData, $sSectionName, $iFlags, $iSectionName, $aIniFile)
	Return $iSectionName	;SetError(Not $iSectionName, $iSectionName, $sSectionData)
EndFunc   ;==>__IniReadSectionEx


; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name...........: __IniWriteSectionEx
; Description ...: Support Function for _IniWriteSectionEx
; Syntax.........: __IniWriteSectionEx(ByRef $hIniFile, ByRef $sSectionName, ByRef $aKeyValue, ByRef $iFlags, ByRef $scKeyName, ByRef $aIniFile)
; Parameters ....: See _IniWriteSectionEx()
; Return values .: See _IniWriteSectionEx()
; Author ........: DXRW4E
; Modified.......:
; Remarks .......: This function is used internally by _IniWriteSectionEx
; ===============================================================================================================================
Func __IniWriteSectionEx(ByRef $hIniFile, ByRef $sSectionName, ByRef $aKeyValue, ByRef $iFlags, ByRef $scKeyName, ByRef $aIniFile)
	If BitAND($iFlags, $INI_REMOVE) Then
		Local $iaSectionName, $aSectionName = StringRegExp($_HINI[$hIniFile][5], '\n(?is)\Q' & $sSectionName & '\E\r([^\n]+)', 3)
		If @Error Then Return SetError(3, 0, 0)
		$iaSectionName = UBound($aSectionName) - 1
		If BitAND($iFlags, $INI_NOOCCURRENCE) Then $iaSectionName = 0
		For $i = 0 To $iaSectionName
			For $y = $aSectionName[$i] - 1 To $aSectionName[$i] + 4
				$aIniFile[$y] = ""
			Next
		Next
		$_HINI[$hIniFile][4] -= $iaSectionName + 1
		$_HINI[$hIniFile][5] = StringRegExpReplace($_HINI[$hIniFile][5], '\n(?is)\Q' & $sSectionName & '\E\r[^\r\n]+', "", Int($iaSectionName = 0))
		Return SetError(0, @Extended, 0)
	ElseIf BitAND($iFlags, $INI_RENAME) Then
		Local $iaSectionName, $aSectionName = StringRegExp($_HINI[$hIniFile][5], '\n(?is)\Q' & $sSectionName & '\E\r([^\n]+)', 3)
		If @Error Then Return SetError(3, 0, 0)
		$iaSectionName = UBound($aSectionName) - 1
		If BitAND($iFlags, $INI_NOOCCURRENCE) Then $iaSectionName = 0
		;; $aKeyValue is New Section Name
		For $i = 0 To $iaSectionName
			$aIniFile[$aSectionName[$i]] = $aKeyValue
		Next
		$_HINI[$hIniFile][5] = StringRegExpReplace($_HINI[$hIniFile][5], '\n\K(?is)\Q' & $sSectionName & '\E(?=\r)', StringReplace(StringReplace($aKeyValue, "\", "\\", 0, 1), "\E", "\e", 0, 1), Int($iaSectionName = 0))
		Return SetError(0, @Extended, 0)
	Else
		Local $iSN = $_HINI[$hIniFile][10]
		If BitAND($iFlags, $INI_OVERWRITEALL_APPENDDATA) Then
			If BitAND($iFlags, $INI_OVERWRITEALL) Then $aIniFile[$iSN] = ""
			If BitAND($iFlags, $INI_STRIPLEADING) Then $aIniFile[$iSN - 1] = ""
			If BitAND($iFlags, $INI_STRIPTRAILING) Then $aIniFile[$iSN + 1] = ""
			If IsArray($aKeyValue) Then
				For $i = 1 To $aKeyValue[0][0]
					$aIniFile[$iSN] &= $aKeyValue[$i][2] & @CRLF
				Next
			Else
				;;	KeyName\Value\Text Data will be writte exactly as in $aKeyValue (without Edit\Formatting ect ect)
				$aIniFile[$iSN] &= $aKeyValue & (StringRight($aKeyValue, 1) = @LF ? "" : @CRLF)
			EndIf
			Return SetError(0, 1, 0)
		Else
			Local $asKeyValue, $iKeyValue = 0, $sKNPattern, $iOffSet = StringInStr($aIniFile[$iSN], @LF, 1)
			For $i = 1 To $aKeyValue[0][0]
				$sKNPattern = '\n[\h\f\xb\x0]*(?i)(?>\Q"' & $aKeyValue[$i][0] & '"\E|\Q' & $aKeyValue[$i][0] & '\E)[\h\f\xb\x0]*' & $scKeyName & '[\h\f\xb\x0]*[^\n]*'
				If StringRegExp(StringLeft($aIniFile[$iSN], $iOffSet), '^(?i)[\h\f\xb\x0]*(?>\Q"' & $aKeyValue[$i][0] & '"\E|\Q' & $aKeyValue[$i][0] & '\E)[\h\f\xb\x0]*' & $scKeyName & '[\h\f\xb\x0]*[^\n]*') Then
					If Not BitAND($iFlags, $INI_IGNOREDUPLICATE) Then $aIniFile[$iSN] = StringRegExpReplace($aIniFile[$iSN], $sKNPattern, "")
					If BitAND($iFlags, $INI_DELETE) Then
						$aIniFile[$iSN] = StringTrimLeft($aIniFile[$iSN], $iOffSet)
					ElseIf Not BitAND($iFlags, $INI_NOOVERWRITE) Then
						$aIniFile[$iSN] = $aKeyValue[$i][2] & @CRLF & StringTrimLeft($aIniFile[$iSN], $iOffSet)
					EndIf
				ElseIf BitAND($iFlags, $INI_DELETE) Then
					$aIniFile[$iSN] = StringRegExpReplace($aIniFile[$iSN], $sKNPattern, "", (BitAND($iFlags, $INI_IGNOREDUPLICATE) ? 1 : 0))
				Else
					$asKeyValue = StringRegExp($aIniFile[$iSN], $sKNPattern, 1)
					$iOffSet = @Extended - 1
					If Not @Error Then
						If BitAND($iFlags, $INI_NOOVERWRITE) Then
							If Not BitAND($iFlags, $INI_IGNOREDUPLICATE) Then $aIniFile[$iSN] = StringLeft($aIniFile[$iSN], $iOffSet) & StringRegExpReplace(StringTrimLeft($aIniFile[$iSN], $iOffSet), $sKNPattern, "")
						Else
							$aIniFile[$iSN] = StringLeft($aIniFile[$iSN], $iOffSet + 1 - StringLen($asKeyValue[0])) & $aKeyValue[$i][2] & @CR & (BitAND($iFlags, $INI_IGNOREDUPLICATE) ? StringTrimLeft($aIniFile[$iSN], $iOffSet) : StringRegExpReplace(StringTrimLeft($aIniFile[$iSN], $iOffSet), $sKNPattern, ""))
						EndIf
					ElseIf Not BitAND($iFlags, $INI_REPLACEONLY) Then
						$aIniFile[$iSN] &= $aKeyValue[$i][2] & @CRLF
					Else
						$iKeyValue -= 1
					EndIf
				EndIf
				$iKeyValue += 1
			Next
			Return SetError(0, $iKeyValue, 0)
		EndIf
	EndIf
EndFunc


; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name...........: __IniFileWriteEx
; Description ...: Support Function for _IniFileWriteEx
; Syntax.........: __IniFileWriteEx(ByRef $hIniFile, ByRef $iFlags, ByRef $sFilePath, ByRef $iFileEncoding, ByRef $aIniFile)
; Parameters ....: See _IniFileWriteEx()
; Return values .: See _IniFileWriteEx()
; Author ........: DXRW4E
; Modified.......:
; Remarks .......: This function is used internally by _IniFileWriteEx
; ===============================================================================================================================
Func __IniFileWriteEx(ByRef $hIniFile, ByRef $iFlags, ByRef $sFilePath, ByRef $iFileEncoding, ByRef $aIniFile)
	Local $hFileOpen, $iSL = BitAND($iFlags, $INI_STRIPLEADING), $iST = BitAND($iFlags, $INI_STRIPTRAILING), $iReadOnly = 0
	$hFileOpen = FileOpen($sFilePath, $iFileEncoding)
	; Check if file opened for writing OK
	If $hFileOpen = -1 Then
		If Not BitAND($iFlags, $INI_NOWRITEREADONLY) And StringInStr(FileGetAttrib($sFilePath), "R") Then
			FileSetAttrib($sFilePath, "-R")
			$iReadOnly = 1
			$hFileOpen = FileOpen($sFilePath, $iFileEncoding)
			If $hFileOpen = -1 Then Return SetError(10, 0, 0)
		Else
			Return SetError(10, 0, 0)
		EndIf
	EndIf
	FileWrite($hFileOpen, ($iSL ? "" : $aIniFile[3]) & $aIniFile[4] & ($iST ? "" : $aIniFile[5]))
	For $i = 6 To $aIniFile[0] Step 6
		FileWrite($hFileOpen, $aIniFile[$i] & $aIniFile[$i + 1] & $aIniFile[$i + 2] & ($iSL ? "" : $aIniFile[$i + 3]) & $aIniFile[$i + 4] & ($iST ? "" : $aIniFile[$i + 5]))
	Next
	FileClose($hFileOpen)
	If $iReadOnly Then FileSetAttrib($sFilePath, "+R")
	Return 0
EndFunc   ;==>__IniFileWriteEx


; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name...........: __IniGetFileStringData
; Description ...: Support Function for _IniGetFileStringData
; Syntax.........: __IniGetFileStringData(ByRef $hIniFile, ByRef $iFlags, ByRef $aIniFile)
; Parameters ....: See _IniGetFileStringData()
; Return values .: See _IniGetFileStringData()
; Author ........: DXRW4E
; Modified.......:
; Remarks .......: This function is used internally by _IniGetFileStringData
; ===============================================================================================================================
Func __IniGetFileStringData(ByRef $hIniFile, ByRef $iFlags, ByRef $aIniFile)
	Local $sData, $iSL = BitAND($iFlags, $INI_STRIPLEADING), $iST = BitAND($iFlags, $INI_STRIPTRAILING)
	Local $sData = ($iSL ? "" : $aIniFile[3]) & $aIniFile[4] & ($iST ? "" : $aIniFile[5])
	For $i = 6 To $aIniFile[0] Step 6
		$sData &= $aIniFile[$i] & $aIniFile[$i + 1] & $aIniFile[$i + 2] & ($iSL ? "" : $aIniFile[$i + 3]) & $aIniFile[$i + 4] & ($iST ? "" : $aIniFile[$i + 5])
	Next
	Return $sData
EndFunc   ;==>__IniGetFileStringData


; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name...........: __IniSaveCache
; Description ...: Save in Cache last Read Section
; Syntax.........: __IniSaveCache(ByRef $hIniFile, ByRef $sSectionData, ByRef $sSectionName, ByRef $iFlags, ByRef $iSectionName, ByRef $aIniFile)
; Parameters ....: $hIniFile     - Handle to the INI file to query "see _IniOpenFileEx()"
;                  $sSectionData - Section Strings text/data
;                  $sSectionName - Section Name
;                  $iFlags       - Section Flags
;                  $iSectionName - Number of SectionName in INI File
;                  $aIniFile     - Array of INI File
; Return values .: None
; Author ........: DXRW4E
; Modified.......:
; Remarks .......: This function is Internal Only
; ===============================================================================================================================
Func __IniSaveCache(ByRef $hIniFile, ByRef $sSectionData, ByRef $sSectionName, ByRef $iFlags, ByRef $iSectionName, ByRef $aIniFile)
	$_HINI[$hIniFile][7] = $sSectionName
	$_HINI[$hIniFile][8] = (BitAND($iFlags, $INI_MERGE_NOOCCURRENCE) = $INI_MERGE) ? 1 : $iSectionName
	$_HINI[$hIniFile][9] = $iFlags
	If $iSectionName > 1 And Not BitAND($iFlags, $INI_MERGE_NOOCCURRENCE) Then
		$aIniFile[1] = $sSectionData
		$_HINI[$hIniFile][10] = 1
	Else
		$aIniFile[1] = ""
		$_HINI[$hIniFile][10] = $_HINI[$hIniFile][6]
	EndIf
	Return 0
EndFunc   ;==>__IniSaveCache


; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name...........: __GetSeparatorCharacter
; Description ...: Get Separator Character (non present character)
; Syntax.........: __GetSeparatorCharacter(ByRef $sData)
; Parameters ....: $sData  - INI String\Text Data
; Return values .: None
; Author ........: DXRW4E
; Modified.......:
; Remarks .......: For Internal Use Only
; ===============================================================================================================================
Func __GetSeparatorCharacter(ByRef $sData)
	If Not StringInStr($sData, ChrW(8232), 1) Then Return ChrW(8232)
	If Not StringInStr($sData, ChrW(8233), 1) Then Return ChrW(8233)
	For $i = 1 To 31
		If $i > 8 And $i < 14 Then ContinueLoop
		If Not StringInStr($sData, Chr($i), 1) Then Return Chr($i)
	Next
	$sData = StringRegExpReplace($sData, '\r\n?', @LF)
	Return @CR
EndFunc   ;==>__GetSeparatorCharacter
