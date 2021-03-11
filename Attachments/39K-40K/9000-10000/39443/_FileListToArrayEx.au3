#include-once

; #UDF# =======================================================================================================================
; Title .........: File List To Array
; AutoIt Version : 3.3.8.1
; Language ......: English
; Description ...: Lists files and\or folders in a specified path (Similar to using Dir with the /B Switch)
; Author(s) .....: DXRW4E
; Notes .........:
; ===============================================================================================================================

; #CURRENT# =====================================================================================================================
;~ _FileListToArrayEx
; ===============================================================================================================================

; #FUNCTION# =======================================================================================================================================================
; Name...........: _FileListToArrayEx
; Description ...: Lists files and\or folders in a specified path (Similar to using Dir with the /B Switch)
; Syntax.........: _FileListToArrayEx($sPath[, $sFilter = "*"[, $iFlag = 0]])
; Parameters ....: $sPath   - Path to generate filelist for.
;                  $sFilter - Optional the filter to use, default is *. (Multiple filter groups such as "All "*.png|*.jpg|*.bmp") Search the Autoit3 helpfile for the word "WildCards" For details.
;                  $iFlag   - Optional: specifies whether to return files folders or both Or Full Path (add the flags together for multiple operations):
;                  |$iFlag = 0 (Default) Return both files and folders
;                  |$iFlag = 1 Return files only
;                  |$iFlag = 2 Return Folders only
;                  |$iFlag = 4 Search SubDirectory
;                  |$iFlag = 8 Return Full Path
;                  |$iFlag = 16 $sFilter do Case-Sensitive matching (By Default $sFilter do Case-Insensitive matching)
;                  |$iFlag = 32 Disable the return the count in the first element - effectively makes the array 0-based (must use UBound() to get the size in this case).
;                    By Default the first element ($array[0]) contains the number of file found, the remaining elements ($array[1], $array[2], etc.)
;                  |$iFlag = 64 $sFilter is REGEXP Mod, See Pattern Parameters in StringRegExp (Can not be combined with flag 16)
;                  |$iFlag = 128 Return Backslash at the beginning of the file name, example Return "\Filename1.xxx" (Can not be combined with flag 8)
; Return values .: Failure - @Error
;                  |1 = Path not found or invalid
;                  |2 = Invalid $sFilter
;                  |3 = No File(s) Found
; Author ........: DXRW4E
; Modified.......:
; Remarks .......: The array returned is one-dimensional and is made up as follows:
;                                $array[0] = Number of Files\Folders returned
;                                $array[1] = 1st File\Folder
;                                $array[2] = 2nd File\Folder
;                                $array[3] = 3rd File\Folder
;                                $array[n] = nth File\Folder
; Related .......:
; Link ..........:
; Example .......: Yes
; Note ..........: Special Thanks to SolidSnake & Tlem
; ==================================================================================================================================================================
Func _FileListToArrayEx($sPath, $sFilter = "*", $iFlag = 0)
    $sPath = StringRegExpReplace($sPath & "\", "(?!\A)[\\/]+\h*", "\\")
    If Not FileExists($sPath) Then Return SetError(1, 1, "")
	If StringRegExp($sFilter, StringReplace('^\s*$|\v|[\\/:><"]|^\||\|\||\|$', "[" & Chr(BitAND($iFlag, 64) + 28) & '\/:><"]|^\||\|\||\|$', "\\\\")) Then Return SetError(2, 2, "")
	Local $hSearch, $sFile, $sFileList, $sSubDir = BitAND($iFlag, 4), $sDelim = "|", $sDirFilter = StringReplace($sFilter, "*", "")
    $hSearch = FileFindFirstFile($sPath & "*")
    If @Error Then Return SetError(3, 3, "")
	Local $hWSearch = $hSearch, $hWSTMP, $SearchWD, $Extended, $iFlags = StringReplace(BitAND($iFlag, 1) + BitAND($iFlag, 2), "3", "0")
	If BitAND($iFlag, 8) Then $sDelim &= $sPath
	If BitAND($iFlag, 128) Then $sDelim = "|\"
	If Not BitAND($iFlag, 64) Then $sFilter = StringRegExpReplace(BitAND($iFlag, 16) & "(?i)(", "16\(\?\i\)|\d+", "") & StringRegExpReplace(StringRegExpReplace(StringRegExpReplace(StringRegExpReplace($sFilter, "[^*?|]+", "\\Q$0\\E"), "\\E(?=\||$)", "$0\$"), "(?<=^|\|)\\Q", "^$0"), "\*+", ".*") & ")"
	While 1
        $sFile = FileFindNextFile($hWSearch)
        If @Error Then
            If $hWSearch = $hSearch Then ExitLoop
            FileClose($hWSearch)
            $hWSearch -= 1
            $SearchWD = StringLeft($SearchWD, StringInStr($SearchWD, "\", 1, -2))
        ElseIf $sSubDir Then
            $Extended = @Extended
            If ($iFlags + $Extended <> 2) Then
                If $sDirFilter Then
                    If StringRegExp($sFile, $sFilter) Then $sFileList &= $sDelim & $SearchWD & $sFile
                Else
                    $sFileList &= $sDelim & $SearchWD & $sFile
                EndIf
            EndIf
            If Not $Extended Then ContinueLoop
            $hWSTMP = FileFindFirstFile($sPath & $SearchWD & $sFile & "\*")
            If $hWSTMP = -1 Then ContinueLoop
            $hWSearch = $hWSTMP
            $SearchWD &= $sFile & "\"
        Else
            If ($iFlags + @Extended = 2) Or StringRegExp($sFile, $sFilter) = 0 Then ContinueLoop
            $sFileList &= $sDelim & $sFile
        EndIf
    WEnd
    FileClose($hSearch)
    If Not $sFileList Then Return SetError(3, 3, "")
	Return StringSplit(StringTrimLeft($sFileList, 1), "|", StringReplace(BitAND($iFlag, 32), "32", 2))
EndFunc	;==>_FileListToArrayEx
