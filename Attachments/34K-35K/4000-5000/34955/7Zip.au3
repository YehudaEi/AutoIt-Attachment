; #VARIABLES# ===================================================================================================================
Global Const $FNAME_MAX32 = 512
Global $hArchiveProc

;File attributes constants
Global Const $FA_RDONLY    = 0x01 ;Reading private file
Global Const $FA_HIDDEN    = 0x02 ;Invisibility attribute file
Global Const $FA_SYSTEM    = 0x04 ;System file
Global Const $FA_LABEL     = 0x08 ;Volume label
Global Const $FA_DIREC     = 0x10 ;Directory
Global Const $FA_ARCH      = 0x20 ;Retention bit
Global Const $FA_ENCRYPTED = 0x40 ;The password the file which is protected
; ===============================================================================================================================

; #STRUCTURES# ==================================================================================================================
Global $tagINDIVIDUALINFO = "int dwOriginalSize;int dwCompressedSize;int dwCRC;uint uFlag;uint uOSType;short wRatio;" & _
							"short wDate;short wTime;char szFileName[" & $FNAME_MAX32 + 1 & "];char dummy1[3];" & _
							"char szAttribute[8];char szMode[8]"

Global Const $tagEXTRACTINGINFO = "int dwFileSize;int dwWriteSize;char szSourceFileName[" & $FNAME_MAX32 + 1 & "];" & _
								  "char dummy1[3];char szDestFileName[" & $FNAME_MAX32 + 1 & "];char dummy[3]"

Global Const $tagEXTRACTINGINFOEX = $tagEXTRACTINGINFO & ";dword dwCompressedSize;dword dwCRC;uint uOSType;short wRatio;" & _
									"short wDate;short wTime;char szAttribute[8];char szMode[8]"
; ===============================================================================================================================

; #FUNCTION# ====================================================================================================================
; Name...........: _7ZipStartup
; Description ...: Opens the 7-zip dll and returns a handle to it
; Syntax.........: _7ZipStartup([$dLoc="7-zip32.dll"])
; Parameters ....: $dLoc         - Location of 7-zip dll
; Return values .: Success       - Returns handle
;                  Failure       - Returns -1
; Author ........: James Ciasullo (Deltaforce229)
; ===============================================================================================================================
Func _7ZipStartup($dLoc="7-zip32.dll")
	Return DllOpen($dLoc)
EndFunc


; #FUNCTION# ====================================================================================================================
; Name...........: _7ZipShutdown
; Description ...: Closes the 7-zip dll
; Syntax.........: _7ZipShutdown($dHnd)
; Parameters ....: $dHnd - Dll handle
; Return values .: None
; Author ........: James Ciasullo (Deltaforce229)
; ===============================================================================================================================
Func _7ZipShutdown($dHnd)
	DllClose($dHnd)
	If $hArchiveProc Then DllCallbackFree($hArchiveProc)
EndFunc

; #FUNCTION# ====================================================================================================================
; Name...........: _7ZipAdd
; Description ...: Adds files to archive
; Syntax.........: _7ZipAdd($hWnd, $sArcName, $sFileName[, $sHide = 0[, $sCompress = 5[, $sRecurse = 1[, $sIncludeFile = 0[, _
;				   $sExcludeFile = 0[, $sPassword = 0[, $sSFX = 0[, $sVolume = 0[, $sWorkDir = 0]]]]]]]]])
; Parameters ....: $dHnd		 - Handle to 7-zip dll
;				   $hWnd         - Handle to parent or owner window
;				   $sArcName     - Archive file name
;				   $sFileName    - File names to archive up
;				   $sHide        - Use this switch if you want the CallBack function to be called
;				   $sCompress    - Compress level 0-9
;				   $sRecurse     - Recursion method: 0 - Disable recursion
;													 1 - Enable recursion
;													 2 - Enable recursion only for wildcard names
;				   $sIncludeFile - Include filenames, specifies filenames and wildcards or list file that specify processed files
;				   $sExcludeFile - Exclude filenames, specifies what filenames or (and) wildcards must be excluded from operation
;				   $sPassword    - Specifies password
;				   $sSFX         - Creates self extracting archive
;				   $sVolume      - Specifies volumes sizes
;				   $sWorkDir     - Sets working directory for temporary base archive
; Return values .: Success       - Returns the string with results
;                  Failure       - Returns 0 and and sets the @error flag to 1
; Author ........: R. Gilman (rasim)
; ===============================================================================================================================
Func _7ZipAdd($dHnd, $hWnd, $sArcName, $sFileName, $sHide = 0, $sCompress = 5, $sRecurse = 1, $sIncludeFile = 0, $sExcludeFile = 0, _
			  $sPassword = 0, $sSFX = 0, $sVolume = 0, $sWorkDir = 0)

	$sArcName = '"' & $sArcName & '"'
	$sFileName = '"' & $sFileName & '"'

	Local $iSwitch = ""

	If $sHide Then $iSwitch &= " -hide"

	$iSwitch &= " -mx" & $sCompress
	$iSwitch &= _RecursionSet($sRecurse)

	If $sIncludeFile Then $iSwitch &= _IncludeFileSet($sIncludeFile)
	If $sExcludeFile Then $iSwitch &= _ExcludeFileSet($sExcludeFile)

	If $sPassword Then $iSwitch &= " -p" & $sPassword

	If FileExists($sSFX) Then $iSwitch &= " -sfx" & $sSFX

	If $sVolume Then $iSwitch &= " -v" & $sVolume

	If $sWorkDir Then $iSwitch &= " -w" & $sWorkDir

	Local $tOutBuffer = DllStructCreate("char[32768]")

	Local $aRet = DllCall($dHnd, "int", "SevenZip", _
											 "hwnd", $hWnd, _
											 "str", "a " & $sArcName & " " & $sFileName & " " & $iSwitch, _
											 "ptr", DllStructGetPtr($tOutBuffer), _
											 "int", DllStructGetSize($tOutBuffer))

	If Not $aRet[0] Then Return SetError(0, 0, DllStructGetData($tOutBuffer, 1))
	Return SetError(1, 0, 0)
EndFunc   ;==>_7ZipAdd

; #FUNCTION# ====================================================================================================================
; Name...........: _7ZipDelete
; Description ...: Deletes files from archive
; Syntax.........: _7ZipDelete($hWnd, $sArcName, $sFileName[, $sHide = 0[, $sCompress = 5[, $sRecurse = 1[, $sIncludeFile = 0[, _
;				   $sExcludeFile = 0[, $sPassword = 0[, $sWorkDir = 0]]]]]]])
; Parameters ....: $dHnd		 - Handle to 7-zip dll
;				   $hWnd         - Handle to parent or owner window
;				   $sArcName     - Archive file name
;				   $sFileName    - File names to deleting
;				   $sHide        - Use this switch if you want the CallBack function to be called
;				   $sCompress    - Compress level 0-9
;				   $sRecurse     - Recursion method: 0 - Disable recursion
;													 1 - Enable recursion
;													 2 - Enable recursion only for wildcard names
;				   $sIncludeFile - Include filenames, specifies filenames and wildcards or list file that specify processed files
;				   $sExcludeFile - Exclude filenames, specifies what filenames or (and) wildcards must be excluded from operation
;				   $sPassword    - Specifies password
;				   $sWorkDir     - Sets working directory for temporary base archive
; Return values .: Success       - Returns the string with results
;                  Failure       - Returns 0 and and sets the @error flag to 1
; Author ........: R. Gilman (rasim)
; ===============================================================================================================================
Func _7ZipDelete($dHnd, $hWnd, $sArcName, $sFileName, $sHide = 0, $sCompress = 5, $sRecurse = 1, $sIncludeFile = 0, $sExcludeFile = 0, _
				 $sPassword = 0, $sWorkDir = 0)

	$sArcName = '"' & $sArcName & '"'
	$sFileName = '"' & $sFileName & '"'

	Local $iSwitch = ""

	If $sHide Then $iSwitch &= " -hide"

	$iSwitch &= " -mx" & $sCompress
	$iSwitch &= _RecursionSet($sRecurse)

	If $sIncludeFile Then $iSwitch &= _IncludeFileSet($sIncludeFile)

	If $sExcludeFile Then $iSwitch &= _ExcludeFileSet($sExcludeFile)

	If $sPassword Then $iSwitch &= " -p" & $sPassword
	If $sWorkDir Then $iSwitch &= " -w" & $sWorkDir

	Local $tOutBuffer = DllStructCreate("char[32768]")

	Local $aRet = DllCall($dHnd, "int", "SevenZip", _
											 "hwnd", $hWnd, _
											 "str", "d " & $sArcName & " " & $sFileName & " " & $iSwitch, _
											 "ptr", DllStructGetPtr($tOutBuffer), _
											 "int", DllStructGetSize($tOutBuffer))

	If Not $aRet[0] Then Return SetError(0, 0, DllStructGetData($tOutBuffer, 1))
	Return SetError(1, 0, 0)
EndFunc   ;==>_7ZipDelete

; #FUNCTION# ====================================================================================================================
; Name...........: _7ZIPExtract
; Description ...: Extracts files from archive to the current directory or to the output directory
; Syntax.........: _7ZIPExtract($hWnd, $sArcName[, $sOutput = 0[, $sHide = 0[, $sOverwrite = 0[, $sRecurse = 1[, _
;				   				$sIncludeArc[, $sExcludeArc[, $sIncludeFile = 0[, $sExcludeFile = 0[, $sPassword = 0[, _
;								$sYes = 0]]]]]]]]]])
; Parameters ....: $dHnd		 - Handle to 7-zip dll
;				   $hWnd         - Handle to parent or owner window
;				   $sArcName     - Archive file name
;				   $sOutput      - Output directory
;				   $sHide        - Use this switch if you want the CallBack function to be called
;				   $sOverwrite   - Overwrite mode:   0 - Overwrite All existing files without prompt, _
;												     1 - Skip extracting of existing files, _
;												     2 - Auto rename extracting file, _
;												     3 - auto rename existing file
;				   $sRecurse     - Recursion method: 0 - Disable recursion
;													 1 - Enable recursion
;													 2 - Enable recursion only for wildcard names
;				   $sIncludeArc  - Include archive filenames
;				   $sExcludeArc  - Exclude archive filenames
;				   $sIncludeFile - Include filenames, specifies filenames and wildcards or list file that specify processed files
;				   $sExcludeFile - Exclude filenames, specifies what filenames or (and) wildcards must be excluded from operation
;				   $sPassword    - Specifies password
;				   $Yes          - assume Yes on all queries
; Return values .: Success       - Returns the string with results
;                  Failure       - Returns 0 and and sets the @error flag to 1
; Author ........: R. Gilman (rasim)
; ===============================================================================================================================
Func _7ZIPExtract($dHnd, $hWnd, $sArcName, $sOutput = 0, $sHide = 0, $sOverwrite = 0, $sRecurse = 1, $sIncludeArc = 0, $sExcludeArc = 0, _
				  $sIncludeFile = 0, $sExcludeFile = 0, $sPassword = 0, $sYes = 0)

	$sArcName = '"' & $sArcName & '"'

	Local $iSwitch = ""

	If $sOutput Then $iSwitch = ' -o"' & $sOutput & '"'
	If $sHide Then $iSwitch &= " -hide"

	$iSwitch &= _OverwriteSet($sOverwrite)
	$iSwitch &= _RecursionSet($sRecurse)

	If $sIncludeArc Then $iSwitch &= _IncludeArcSet($sIncludeArc)
	If $sExcludeArc Then $iSwitch &= _ExcludeArcSet($sExcludeArc)

	If $sIncludeFile Then $iSwitch &= _IncludeFileSet($sIncludeFile)
	If $sExcludeFile Then $iSwitch &= _ExcludeFileSet($sExcludeFile)

	If $sPassword Then $iSwitch &= " -p" & $sPassword
	If $sYes Then $iSwitch &= " -y"

	Local $tOutBuffer = DllStructCreate("char[32768]")

	Local $aRet = DllCall($dHnd, "int", "SevenZip", _
											 "hwnd", $hWnd, _
											 "str", "e " & $sArcName & " " & $iSwitch, _
											 "ptr", DllStructGetPtr($tOutBuffer), _
											 "int", DllStructGetSize($tOutBuffer))

	If Not $aRet[0] Then Return SetError(0, 0, DllStructGetData($tOutBuffer, 1))
	Return SetError(1, 0, 0)
EndFunc   ;==>_7ZIPExtract

; #FUNCTION# ====================================================================================================================
; Name...........: _7ZIPExtractEx
; Description ...: Extracts files from archive with full paths to the current directory or to the output directory
; Syntax.........: _7ZIPExtract($hWnd, $sArcName[, $sOutput = 0[, $sHide = 0[, $sOverwrite = 0[, $sRecurse = 1[, _
;				   				$sIncludeArc[, $sExcludeArc[, $sIncludeFile = 0[, $sExcludeFile = 0[, $sPassword = 0[, _
;								$sYes = 0]]]]]]]]]])
;; Parameters ....:$dHnd		 - Handle to 7-zip dll
;				   $hWnd         - Handle to parent or owner window
;				   $sArcName     - Archive file name
;				   $sOutput      - Output directory
;				   $sHide        - Use this switch if you want the CallBack function to be called
;				   $sOverwrite   - Overwrite mode:   0 - Overwrite All existing files without prompt, _
;												     1 - Skip extracting of existing files, _
;												     2 - Auto rename extracting file, _
;												     3 - auto rename existing file
;				   $sRecurse     - Recursion method: 0 - Disable recursion
;													 1 - Enable recursion
;													 2 - Enable recursion only for wildcard names
;				   $sIncludeArc  - Include archive filenames
;				   $sExcludeArc  - Exclude archive filenames
;				   $sIncludeFile - Include filenames, specifies filenames and wildcards or list file that specify processed files
;				   $sExcludeFile - Exclude filenames, specifies what filenames or (and) wildcards must be excluded from operation
;				   $sPassword    - Specifies password
;				   $Yes          - assume Yes on all queries
; Return values .: Success       - Returns the string with results
;                  Failure       - Returns 0 and and sets the @error flag to 1
; Author ........: R. Gilman (rasim)
; ===============================================================================================================================
Func _7ZipExtractEx($dHnd, $hWnd, $sArcName, $sOutput = 0, $sHide = 0, $sOverwrite = 0, $sRecurse = 1, $sIncludeArc = 0, _
					$sExcludeArc = 0, $sIncludeFile = 0, $sExcludeFile = 0, $sPassword = 0, $sYes = 0)

	$sArcName = '"' & $sArcName & '"'

	Local $iSwitch = ""

	If $sOutput Then $iSwitch = ' -o"' & $sOutput & '"'
	If $sHide Then $iSwitch &= " -hide"

	$iSwitch &= _OverwriteSet($sOverwrite)
	$iSwitch &= _RecursionSet($sRecurse)

	If $sIncludeArc Then $iSwitch &= _IncludeArcSet($sIncludeArc)
	If $sExcludeArc Then $iSwitch &= _ExcludeArcSet($sExcludeArc)

	If $sIncludeFile Then $iSwitch &= _IncludeFileSet($sIncludeFile)
	If $sExcludeFile Then $iSwitch &= _ExcludeFileSet($sExcludeFile)

	If $sPassword Then $iSwitch &= " -p" & $sPassword
	If $sYes Then $iSwitch &= " -y"

	Local $tOutBuffer = DllStructCreate("char[32768]")

	Local $aRet = DllCall($dHnd, "int", "SevenZip", _
											 "hwnd", $hWnd, _
											 "str", "x " & $sArcName & " " & $iSwitch, _
											 "ptr", DllStructGetPtr($tOutBuffer), _
											 "int", DllStructGetSize($tOutBuffer))

	If Not $aRet[0] Then Return SetError(0, 0, DllStructGetData($tOutBuffer, 1))
	Return SetError(1, 0, 0)
EndFunc   ;==>_7ZIPExtractEx

; #FUNCTION# ====================================================================================================================
; Name...........: _7ZIPUpdate
; Description ...: Update older files in the archive and add files that are new to the archive
; Syntax.........: _7ZIPUpdate($hWnd, $sArcName, $sFileName[, $sHide = 0[, $sCompress = 5[, $sRecurse = 1[, _
;				   			   $sIncludeFile = 0[, $sExcludeFile = 0[, $sPassword = 0[, $sSFX = 0[, $sWorkDir = 0]]]]]]]])
; Parameters ....: $dHnd		 - Handle to 7-zip dll
;				   $hWnd         - Handle to parent or owner window
;				   $sArcName     - Archive file name
;				   $sFileName    - File names to archive up
;				   $sHide        - Use this switch if you want the CallBack function to be called
;				   $sCompress    - Compress level 0-9
;				   $sRecurse     - Recurse method: 0 - Disable recursion
;												   1 - Enable recursion
;												   2 - Enable recursion only for wildcard names
;				   $sIncludeFile - Include filenames, specifies filenames and wildcards or list file that specify processed files
;				   $sExcludeFile - Exclude filenames, specifies what filenames or (and) wildcards must be excluded from operation
;				   $sPassword    - Specifies password
;				   $sSFX         - Creates self extracting archive
;				   $sWorkDir     - Sets working directory for temporary base archive
; Return values .: Success       - Returns the string with results
;                  Failure       - Returns 0 and and sets the @error flag to 1
; Author ........: R. Gilman (rasim)
; ===============================================================================================================================
Func _7ZipUpdate($dHnd, $hWnd, $sArcName, $sFileName, $sHide = 0, $sCompress = 5, $sRecurse = 1, $sIncludeFile = 0, $sExcludeFile = 0, _
				 $sPassword = 0, $sSFX = 0, $sWorkDir = 0)

	$sArcName = '"' & $sArcName & '"'
	$sFileName = '"' & $sFileName & '"'

	Local $iSwitch = ""

	If $sHide Then $iSwitch &= " -hide"

	$iSwitch = " -mx" & $sCompress
	$iSwitch &= _RecursionSet($sRecurse)

	If $sIncludeFile Then $iSwitch &= _IncludeFileSet($sIncludeFile)
	If $sExcludeFile Then $iSwitch &= _ExcludeFileSet($sExcludeFile)

	If $sPassword Then $iSwitch &= " -p" & $sPassword
	If FileExists($sSFX) Then $iSwitch &= " -sfx" & $sSFX
	If $sWorkDir Then $iSwitch &= " -w" & $sWorkDir

	Local $tOutBuffer = DllStructCreate("char[32768]")

	Local $aRet = DllCall($dHnd, "int", "SevenZip", _
											 "hwnd", $hWnd, _
											 "str", "u " & $sArcName & " " & $sFileName & " " & $iSwitch, _
											 "ptr", DllStructGetPtr($tOutBuffer), _
											 "int", DllStructGetSize($tOutBuffer))

	If Not $aRet[0] Then Return SetError(0, 0, DllStructGetData($tOutBuffer, 1))
	Return SetError(1, 0, 0)
EndFunc   ;==>_7ZIPUpdate

; #FUNCTION# ====================================================================================================================
; Name...........: _7ZipSetOwnerWindowEx
; Description ...: Appoints the call-back function in order to receive the information of the compressing/unpacking
; Syntax.........: _7ZipSetOwnerWindowEx($hWnd, $sProcFunc)
; Parameters ....: $dHnd	  - Handle to 7-zip dll
;				   $hWnd      - Handle to parent or owner window
;				   $sProcFunc - The call-back function name
; Return values .: Success  - Returns 1
;                  Failure  - Returns 0
; Author ........: R. Gilman (rasim)
; ===============================================================================================================================
Func _7ZipSetOwnerWindowEx($dHnd, $hWnd, $sProcFunc)
	If $hArchiveProc Then DllCallbackFree($hArchiveProc)
	$hArchiveProc = DllCallbackRegister($sProcFunc, "int", "hwnd;uint;uint;ptr")
	If $hArchiveProc = 0 Then Return SetError(1, 0, 0)

	Local $aRet = DllCall($dHnd, "int", "SevenZipSetOwnerWindowEx", _
											 "hwnd", $hWnd, _
											 "ptr", DllCallbackGetPtr($hArchiveProc))
	Return $aRet[0]
EndFunc   ;==>_7ZipSetOwnerWindowEx

; #FUNCTION# ====================================================================================================================
; Name...........: _7ZipKillOwnerWindowEx
; Description ...: Cancels a window owner
; Syntax.........: _7ZipKillOwnerWindowEx($hWnd)
; Parameters ....: $dHnd	  - Handle to 7-zip dll
;				   $hWnd      - Handle to parent or owner window
; Return values .: Success  - Returns 1
;                  Failure  - Returns 0
; Author ........: R. Gilman (rasim)
; ===============================================================================================================================
Func _7ZipKillOwnerWindowEx($dHnd, $hWnd)
	Local $aRet = DllCall($dHnd, "int", "SevenZipKillOwnerWindowEx", _
											 "hwnd", $hWnd)
	Return $aRet[0]
EndFunc   ;==>_7ZipKillOwnerWindowEx

; #FUNCTION# ====================================================================================================================
; Name...........: _7ZipOpenArchive
; Description ...: Opens a arcive file
; Syntax.........: _7ZipOpenArchive($sArcName)
; Parameters ....: $dHnd	 - Handle to 7-zip dll
;				   hWnd      - Handle to parent or owner window
;				   $sArcName - Archive file name
; Return values .: Success   - Returns a archive handle
;                  Failure   - Returns 0
; Author ........: R. Gilman (rasim)
; ===============================================================================================================================
Func _7ZipOpenArchive($dHnd, $hWnd, $sArcName)
	Local $hArc = DllCall($dHnd, "hwnd", "SevenZipOpenArchive", "hwnd", $hWnd, "str", $sArcName, "int", 0)
	Return $hArc[0]
EndFunc   ;==>_7ZipOpenArchive

; #FUNCTION# ====================================================================================================================
; Name...........: _7ZipCloseArchive
; Description ...: Closes a previously opened archive handle
; Syntax.........: _7ZipCloseArchive($hArc)
; Parameters ....: $dHnd - Handle to 7-zip dll
;				   $hArc - Archive handle
; Return values .: Success   - Returns 0
;                  Failure   - Returns -1
; Author ........: R. Gilman (rasim)
; ===============================================================================================================================
Func _7ZipCloseArchive($dHnd, $hArc)
	Local $aRet = DllCall($dHnd, "int", "SevenZipCloseArchive", "hwnd", $hArc)
	Return $aRet[0]
EndFunc   ;==>_7ZipCloseArchive

; #FUNCTION# ====================================================================================================================
; Name...........: _7ZipFindFirst
; Description ...: Returns a $INDIVIDUALINFO structure with information of the first finded file
; Syntax.........: _7ZipFindFirst($hArc, $sSearch)
; Parameters ....: $dHnd	- Handle to 7-zip dll
;				   $hArc    - Archive handle
;				   $sSearch - File search string. (wildcards are supported)
; Return values .: Success  - Returns a $INDIVIDUALINFO structure
;                  Failure  - Returns -1
; Author ........: R. Gilman (rasim)
; ===============================================================================================================================
Func _7ZipFindFirst($dHnd, $hArc, $sSearch)
	Local $INDIVIDUALINFO = DllStructCreate($tagINDIVIDUALINFO)

	Local $aRet = DllCall($dHnd, "int", "SevenZipFindFirst", _
											 "hwnd", $hArc, _
											 "str", $sSearch, _
											 "ptr", DllStructGetPtr($INDIVIDUALINFO))
	If $aRet[0] = -1 Then Return $aRet[0]
	Return $INDIVIDUALINFO
EndFunc   ;==>_7ZipFindFirst

; #FUNCTION# ====================================================================================================================
; Name...........: _7ZipFindNext
; Description ...: Returns a $tINDIVIDUALINFO structure according to a previous call to _7ZipFindFirst
; Syntax.........: _7ZipFindNext($hArc, $tINDIVIDUALINFO)
; Parameters ....: $dHnd		 	- Handle to 7-zip dll
;				   $hArc            - Archive handle
;				   $tINDIVIDUALINFO - The $tINDIVIDUALINFO structure
; Return values .: Success  - Returns a $INDIVIDUALINFO structure
;                  Failure  - Returns 0
; Author ........: R. Gilman (rasim)
; ===============================================================================================================================
Func _7ZipFindNext($dHnd, $hArc, $tINDIVIDUALINFO)
	Local $aRet = DllCall($dHnd, "int", "SevenZipFindNext", _
											 "hwnd", $hArc, _
											 "ptr", DllStructGetPtr($tINDIVIDUALINFO))
	If $aRet[0] = 0 Then Return $tINDIVIDUALINFO
EndFunc   ;==>SevenZipFindNext

; #FUNCTION# ====================================================================================================================
; Name...........: _7ZipGetFileName
; Description ...: Returns a file name
; Syntax.........: _7ZipGetFileName($hArc)
; Parameters ....: $dHnd - Handle to 7-zip dll
;				   $hArc - Archive handle
; Return values .: Success - Returns a string with a file name
;                  Failure - Returns 0
; Author ........: R. Gilman (rasim)
; ===============================================================================================================================
Func _7ZipGetFileName($dHnd, $hArc)
	Local $tNameBuffer = DllStructCreate("char[" & $FNAME_MAX32 + 1 & "]")

	Local $aRet = DllCall($dHnd, "int", "SevenZipGetFileName", _
											 "hwnd", $hArc, _
											 "ptr", DllStructGetPtr($tNameBuffer), _
											 "int", DllStructGetSize($tNameBuffer))
	If $aRet[0] = 0 Then Return DllStructGetData($tNameBuffer, 1)
EndFunc   ;==>_7ZipGetFileName

; #FUNCTION# ====================================================================================================================
; Name...........: _7ZipGetArcOriginalSize
; Description ...: Returns a original size of files in an archive
; Syntax.........: _7ZipGetArcOriginalSize($hArc)
; Parameters ....: $dHnd - Handle to 7-zip dll
;				   $hArc - Archive handle
; Return values .: Success - Returns a total size
;                  Failure - Returns -1
; Author ........: R. Gilman (rasim)
; ===============================================================================================================================
Func _7ZipGetArcOriginalSize($dHnd, $hArc)
	Local $aRet = DllCall($dHnd, "int", "SevenZipGetArcOriginalSize", _
											 "hwnd", $hArc)
	Return $aRet[0]
EndFunc   ;==>_7ZipGetArcOriginalSize

; #FUNCTION# ====================================================================================================================
; Name...........: _7ZipGetArcCompressedSize
; Description ...: Returns a compressed size of files in an archive
; Syntax.........: _7ZipGetArcCompressedSize($hArc)
; Parameters ....: $dHnd - Handle to 7-zip dll
;				   $hArc - Archive handle
; Return values .: Success - Returns a total size
;                  Failure - Returns -1
; Author ........: R. Gilman (rasim)
; ===============================================================================================================================
Func _7ZipGetArcCompressedSize($dHnd, $hArc)
	Local $aRet = DllCall($dHnd, "int", "SevenZipGetArcCompressedSize", _
											 "hwnd", $hArc)
	Return $aRet[0]
EndFunc   ;==>_7ZipGetArcCompressedSize

; #FUNCTION# ====================================================================================================================
; Name...........: _7ZipGetArcRatio
; Description ...: Returns a compressing ratio
; Syntax.........: _7ZipGetArcRatio($hArc)
; Parameters ....: $dHnd - Handle to 7-zip dll
;				    $hArc - Archive handle
; Return values .: Success - Returns a compressing ratio
;                  Failure - Returns -1
; Author ........: R. Gilman (rasim)
; ===============================================================================================================================
Func _7ZipGetArcRatio($dHnd, $hArc)
	Local $aRet = DllCall($dHnd, "short", "SevenZipGetArcRatio", _
											 "hwnd", $hArc)
	Return $aRet[0]
EndFunc   ;==>_7ZipGetArcRatio

; #FUNCTION# ====================================================================================================================
; Name...........: _7ZipGetDate
; Description ...: Returns a date of files in an archive
; Syntax.........: _7ZipGetDate($hArc)
; Parameters ....: $dHnd - Handle to 7-zip dll
;				    $hArc - Archive handle
; Return values .: Success - Returns a date in an MSDOS format
;                  Failure - Returns -1
; Author ........: R. Gilman (rasim)
; ===============================================================================================================================
Func _7ZipGetDate($dHnd, $hArc)
	Local $aRet = DllCall($dHnd, "short", "SevenZipGetDate", _
												"hwnd", $hArc)
	If $aRet[0] = -1 Then Return $aRet[0]
	Return "0x" & Hex($aRet[0], 4)
EndFunc   ;==>_7ZipGetDate

; #FUNCTION# ====================================================================================================================
; Name...........: _7ZipGetTime
; Description ...: Returns a time of files in an archive
; Syntax.........: _7ZipGetTime($hArc)
; Parameters ....: $dHnd - Handle to 7-zip dll
;				    $hArc - Archive handle
; Return values .: Success - Returns a time in an MSDOS format
;                  Failure - Returns -1
; Author ........: R. Gilman (rasim)
; ===============================================================================================================================
Func _7ZipGetTime($dHnd, $hArc)
	Local $aRet = DllCall($dHnd, "short", "SevenZipGetTime", _
												"hwnd", $hArc)
	If $aRet[0] = -1 Then Return $aRet[0]
	Return "0x" & Hex($aRet[0], 4)
EndFunc   ;==>_7ZipGetTime

; #FUNCTION# ====================================================================================================================
; Name...........: _7ZipGetCRC
; Description ...: Returns a CRC of files in an archive
; Syntax.........: _7ZipGetCRC($hArc)
; Parameters ....: $dHnd - Handle to 7-zip dll
;				   $hArc - Archive handle
; Return values .: Success - Returns a CRC
;                  Failure - Returns -1
; Author ........: R. Gilman (rasim)
; ===============================================================================================================================
Func _7ZipGetCRC($dHnd, $hArc)
	Local $aRet = DllCall($dHnd, "dword", "SevenZipGetCRC", _
												"hwnd", $hArc)
	Return $aRet[0]
EndFunc   ;==>_7ZipGetCRC

; #FUNCTION# ====================================================================================================================
; Name...........: _7ZipGetAttribute
; Description ...: Returns a attribute of files in an archive
; Syntax.........: _7ZipGetAttribute($hArc)
; Parameters ....: $dHnd - Handle to 7-zip dll
;				   $hArc - Archive handle
; Return values .: Success - Returns attribute of the file
;                  Failure - Returns -1
; Author ........: R. Gilman (rasim)
; ===============================================================================================================================
Func _7ZipGetAttribute($dHnd, $hArc)
	Local $aRet = DllCall($dHnd, "int", "SevenZipGetAttribute", _
											 "hwnd", $hArc)
	If $aRet[0] = -1 Then Return $aRet[0]
	Return "0x" & Hex($aRet[0], 2)
EndFunc   ;==>_7ZipGetAttribute

; #FUNCTION# ====================================================================================================================
; Name...........: _7ZipGetMethod
; Description ...: Returns a string with the method of compressing
; Syntax.........: _7ZipGetMethod($hArc)
; Parameters ....: $dHnd - Handle to 7-zip dll
;				   $hArc - Archive handle
; Return values .: Success - Returns the method of compressing
;                  Failure - Returns -1
; Author ........: R. Gilman (rasim)
; ===============================================================================================================================
Func _7ZipGetMethod($dHnd, $hArc)
	Local $sBUFFER = DllStructCreate("char[8]")

	Local $aRet = DllCall($dHnd, "int", "SevenZipGetMethod", _
											 "hwnd", $hArc, _
											 "ptr", DllStructGetPtr($sBUFFER), _
											 "int", DllStructGetSize($sBUFFER))
	If $aRet[0] <> 0 Then Return False
	Return DllStructGetData($sBUFFER, 1)
EndFunc   ;==>_7ZipGetMethod

; #FUNCTION# ====================================================================================================================
; Name...........: _7ZIPCheckArchive
; Description ...: Checks archive files
; Syntax.........: _7ZIPCheckArchive($sArcName)
; Parameters ....: $dHnd	 - Handle to 7-zip dll
;				   $sArcName - Archive file name
; Return values .: Success   - 1
;                  Failure   - 0
; Author ........: R. Gilman (rasim)
; ===============================================================================================================================
Func _7ZipCheckArchive($dHnd, $sArcName)
	Local $aRet = DllCall($dHnd, "int", "SevenZipCheckArchive", _
											 "str", $sArcName, _
											 "int", 0)
	Return $aRet[0]
EndFunc   ;==>_7ZIPCheckArchive

; #FUNCTION# ====================================================================================================================
; Name...........: _7ZipGetArchiveType
; Description ...: Returns the archive type
; Syntax.........: _7ZipGetArchiveType($sArcName)
; Parameters ....: $dHnd	 - Handle to 7-zip dll
;				   $sArcName - Archive file name
; Return values .: Success: 1 - ZIPtype
;							2 - 7Ztype
;							0 - Unknown type
;                  Failure    - -1
; Author ........: R. Gilman (rasim)
; ===============================================================================================================================
Func _7ZipGetArchiveType($dHnd, $sArcName)
	Local $aRet = DllCall($dHnd, "int", "SevenZipGetArchiveType", _
											 "str", $sArcName)
	Return $aRet[0]
EndFunc   ;==>_7ZIPGetArchiveType

; #FUNCTION# ====================================================================================================================
; Name...........: _7ZipGetFileCount
; Description ...: Returns the archive files count
; Syntax.........: _7ZipGetFileCount($sArcName)
; Parameters ....: $dHnd	 - Handle to 7-zip dll
;				   $sArcName - Archive file name
; Return values .: Success   - Returns the number of files
;                  Failure   - Returns -1
; Author ........: R. Gilman (rasim)
; ===============================================================================================================================
Func _7ZipGetFileCount($dHnd, $sArcName)
	Local $aRet = DllCall($dHnd, "int", "SevenZipGetFileCount", _
											 "str", $sArcName)
	Return $aRet[0]
EndFunc

; #FUNCTION# ====================================================================================================================
; Name...........: _7ZipConfigDialog
; Description ...: Shows a about dialog of the 7-zip32.dll
; Syntax.........: SevenZipConfigDialog($hWnd)
; Parameters ....: $dHnd   - Handle to 7-zip dll
;				   $hWnd   - Handle to parent or owner window
; Return values .: Success - Returns 1
;                  Failure - Returns 0
; Author ........: R. Gilman (rasim)
; ===============================================================================================================================
Func _7ZipConfigDialog($dHnd, $hWnd)
	Local $aRet = DllCall($dHnd, "int", "SevenZipConfigDialog", _
											 "hwnd", $hWnd, _
											 "ptr", 0, _
											 "int", 0)
	Return $aRet[0]
EndFunc   ;==>SevenZipConfigDialog

; #FUNCTION# ====================================================================================================================
; Name...........: _7ZipQueryFunctionList
; Description ...: Checks whether or not API function which is appointed with 7-zip32.dll
; Syntax.........: _7ZipQueryFunctionList($iFunction)
; Parameters ....: $dHnd	  - Handle to 7-zip dll
;				   $iFunction - The unique numerical value of the function
; Return values .: Success - Returns 1
;                  Failure - Returns 0
; Author ........: R. Gilman (rasim)
; ===============================================================================================================================
Func _7ZipQueryFunctionList($dHnd, $iFunction = 0)
	Local $aRet = DllCall($dHnd, "int", "SevenZipQueryFunctionList", _
											 "int", $iFunction)
	Return $aRet[0]
EndFunc   ;==>_7ZipQueryFunctionList

; #FUNCTION# ====================================================================================================================
; Name...........: _7ZipGetVersion
; Description ...: Returns a version of the 7-zip32.dll
; Syntax.........: _7ZipGetVersion()
; Parameters ....: $dHnd - Handle to 7-zip dll
; Return values .: The version number
; Author ........: R. Gilman (rasim)
; ===============================================================================================================================
Func _7ZipGetVersion($dHnd)
	Local $aRet = DllCall($dHnd, "short", "SevenZipGetVersion")
	Return StringLeft($aRet[0], 1) & "." & StringTrimLeft($aRet[0], 1)
EndFunc   ;==>_7ZipGetVersion

; #FUNCTION# ====================================================================================================================
; Name...........: _7ZipGetSubVersion
; Description ...: Returns a sub-version of the 7-zip32.dll
; Syntax.........: _7ZipGetSubVersion()
; Parameters ....: $dHnd - Handle to 7-zip dll
; Return values .: The sub-version number
; Author ........: R. Gilman (rasim)
; ===============================================================================================================================
Func _7ZipGetSubVersion($dHnd)
	Local $aRet = DllCall($dHnd, "short", "SevenZipGetSubVersion")
	Return $aRet[0]
EndFunc   ;==>_7ZipGetSubVersion

; #FUNCTIONS FOR INTERNAL USE# ==================================================================================================
Func _RecursionSet($sVal)
	Switch $sVal
		Case 1
			Return " -r"
		Case 2
			Return " -r0"
		Case Else
			Return " -r-"
	EndSwitch
EndFunc   ;==>_RecursionSet

Func _IncludeFileSet($sVal)
	If StringInStr($sVal, "*") Then
		Return ' -i!"' & $sVal & '"'
	ElseIf StringLeft($sVal, 1) = "@" Then
		Return ' -i"' & $sVal  & '"'
	Else
		Return ' -i!"' & $sVal & '"'
	EndIf
EndFunc   ;==>_IncludeFileSet

Func _ExcludeFileSet($sVal)
	If StringInStr($sVal, "*") Then
		Return ' -x!"' & $sVal & '"'
	ElseIf StringLeft($sVal, 1) = "@" Then
		Return ' -x"' & $sVal & '"'
	Else
		Return ' -x!"' & $sVal & '"'
	EndIf
EndFunc   ;==>_ExcludeFileSet

Func _OverwriteSet($sVal)
	Switch $sVal
		Case 0
			Return " -aoa"
		Case 1
			Return " -aos"
		Case 2
			Return " -aou"
		Case 3
			Return " -aot"
		Case Else
			Return " -aoa"
	EndSwitch
EndFunc   ;==>_OverwriteSet

Func _IncludeArcSet($sVal)
	If StringInStr($sVal, "*") Then
		Return ' -ai!"' & $sVal & '"'
	ElseIf StringLeft($sVal, 1) = "@" Then
		Return ' -ai"' & $sVal & '"'
	Else
		Return ' -ai!"' & $sVal & '"'
	EndIf
EndFunc   ;==>_IncludeArcSet

Func _ExcludeArcSet($sVal)
	If StringInStr($sVal, "*") Then
		Return ' -ax!"' & $sVal & '"'
	ElseIf StringLeft($sVal, 1) = "@" Then
		Return ' -ax"' & $sVal & '"'
	Else
		Return ' -ax!"' & $sVal & '"'
	EndIf
EndFunc   ;==>_ExcludeArcSet