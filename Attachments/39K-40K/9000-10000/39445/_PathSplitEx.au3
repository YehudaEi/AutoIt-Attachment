#include-once

; #UDF# =======================================================================================================================
; Title .........: PathSplitEx
; AutoIt Version : 3.3.8.1
; Language ......: English
; Description ...: Splits a path into the drive, directory, file name and file extension parts
; Author(s) .....: DXRW4E
; Notes .........:
; ===============================================================================================================================

; #CURRENT# =====================================================================================================================
; _PathSplitEx
; _PathSplitParentDir
; _FileExistsEx
; ===============================================================================================================================


; #FUNCTION# ====================================================================================================================
; Name...........: _PathSplitEx
; Description ...: Splits a path into the drive, directory, file name and file extension parts. An empty string is set if a part is missing.
; Syntax.........: _PathSplitEx($sFilePath, ByRef $sDrive, ByRef $sDir, ByRef $sFileName, ByRef $sExtension)
; Parameters ....: $sFilePath  - The path to be split (Can contain a UNC server or drive letter)
;                  $sDrive     - String to hold the drive
;                  $sDir       - String to hold the directory
;                  $sFileName  - String to hold the file name
;                  $sExtension - String to hold the file extension
; Return values .: Success - Returns an array with 5 elements where 0 = original path 1 = drive, 2 = directory, 3 = filename, 4 = extension
; Author ........: DXRW4E
; Modified.......:
; Remarks .......: This function does not take a command line string. It works on paths, not paths with arguments.
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _PathSplitEx($sFilePath, ByRef $sDrive, ByRef $sDir, ByRef $sFileName, ByRef $sExtension)
    $sFilePath = StringRegExp($sFilePath, "^((?:\\\\\?\\)*(\\\\[^\?\/\\]+|[A-Za-z]:)?(.*[\/\\])?((?:[^\.\/\\]|(?(?=\.[^\/\\]*\.)\.))*)?([^\/\\]*))$", 1)
	$sDrive = $sFilePath[1]
	$sDir = StringRegExpReplace($sFilePath[2], "[\/\\]+\h*", "\" & StringLeft($sFilePath[2], 1))
	$sFileName = $sFilePath[3]
	$sExtension = $sFilePath[4]
	Return $sFilePath
EndFunc


; #FUNCTION# ====================================================================================================================
; Name...........: _PathSplitParentDir
; Description ...: Splits a path into the drive, directory, file name and file extension parts. An empty string is set if a part is missing.
; Syntax.........: _PathSplit($sFilePath, ByRef $sDrive, ByRef $sDir, ByRef $sParentDir, ByRef $sFileName, ByRef $sExtension)
; Parameters ....: $sFilePath  - The path to be split (Can contain a UNC server or drive letter)
;                  $sDrive     - String to hold the drive
;                  $sDir       - String to hold the directory
;                  $sParentDir - String to hold the parent directory
;                  $sFileName  - String to hold the file name
;                  $sExtension - String to hold the file extension
; Return values .: Success - Returns an array with 6 elements where 0 = original path 1 = drive, 2 = directory, 3 = parentdir, 4 = filename, 5 = extension
; Author ........: DXRW4E
; Modified.......:
; Remarks .......: This function does not take a command line string. It works on paths, not paths with arguments.
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _PathSplitParentDir($sFilePath, ByRef $sDrive, ByRef $sDir, ByRef $sParentDir, ByRef $sFileName, ByRef $sExtension)
    $sFilePath = StringRegExp($sFilePath & " ", "^((?:\\\\\?\\)*(\\\\[^\?\/\\]+|[A-Za-z]:)?(.*?[\/\\]+)?([^\/\\]*[\/\\])?[\/\\]*((?:[^\.\/\\]|(?(?=\.[^\/\\]*\.)\.))*)?([^\/\\]*))$", 1)
	$sDrive = $sFilePath[1]
	$sFilePath[2] = StringRegExpReplace($sFilePath[2], "[\/\\]+\h*", "\" & StringLeft($sFilePath[2], 1))
	$sDir = $sFilePath[2]
	$sParentDir = $sFilePath[3]
	$sFileName = $sFilePath[4]
	$sExtension = $sFilePath[5]
	Return $sFilePath
EndFunc


; #FUNCTION# ====================================================================================================================
; Name...........: _FileExistsEx
; Description ...: Get New Files Name
; Syntax.........: _FileExistsEx(ByRef $sFilePath[, $iFileExists])
; Parameters ....: $sFilePath   - The Fullpath file
;                  $iFileExists - Optional
; Author ........: DXRW4E
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _FileExistsEx(ByRef $sFilePath, $iFileExists = 0)
	While FileExists($sFilePath)
		$iFileExists += 1
		$sFilePath = StringRegExpReplace($sFilePath & " ", "( - \(\d+\))?(\.[^\.\\]*)?(\h)$", " - (" & $iFileExists & ")$2")
	WEnd
EndFunc
