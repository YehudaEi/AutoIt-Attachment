; #FUNCTION# ====================================================================================================================
; Name ..........: _FindInFile
; Description ...: Search for a string within files located in a specific directory.
; Syntax ........: _FindInFile($sSearch, $sFilePath[, $sMask = '*'[, $fRecursive = True[, $fLiteral = Default[,
;                  $fCaseSensitive = Default[, $fDetail = Default]]]]])
; Parameters ....: $sSearch             - The keyword to search for.
;                  $sFilePath           - The folder location of where to search.
;                  $sMask               - [optional] A list of filetype extensions separated with ';' e.g. '*.au3;*.txt'. Default is all files.
;                  $fRecursive          - [optional] Search within subfolders. Default is True.
;                  $fLiteral            - [optional] Use the string as a literal search string. Default is False.
;                  $fCaseSensitive      - [optional] Use Search is case-sensitive searching. Default is False.
;                  $fDetail             - [optional] Show filenames only. Default is False.
; Return values .: Success - Returns a one-dimensional and is made up as follows:
;                            $aArray[0] = Number of rows
;                            $aArray[1] = 1st file
;                            $aArray[n] = nth file
;                  Failure - Returns an empty array and sets @error to non-zero
; Author ........: guinness
; Remarks .......: For more details: http://ss64.com/nt/findstr.html
; Example .......: Yes
; ===============================================================================================================================
Func _FindInFile($sSearch, $sFilePath, $sMask = '*', $fRecursive = True, $fLiteral = Default, $fCaseSensitive = Default, $fDetail = Default)
    Local $sCaseSensitive = '/i', $sDetail = '/m', $sRecursive = ''
    If $fCaseSensitive Then
        $sCaseSensitive = ''
    EndIf
    If $fDetail Then
        $sDetail = '/n'
    EndIf
    If $fLiteral Then
        $sSearch = ' /c:' & $sSearch
    EndIf
    If $fRecursive Or $fRecursive = Default Then
        $sRecursive = '/s'
    EndIf
    If $sMask = Default Then
        $sMask = '*'
    EndIf

    $sFilePath = StringRegExpReplace($sFilePath, '[\\/]+\z', '') & '\'
    Local Const $aMask = StringSplit($sMask, ';')
    Local $iPID = 0, $sOutput = ''
    For $i = 1 To $aMask[0]
        $iPID = Run(@ComSpec & ' /c ' & 'findstr ' & $sCaseSensitive & ' ' & $sDetail & ' ' & $sRecursive & ' "' & $sSearch & '" "' & $sFilePath & $aMask[$i] & '"', @SystemDir, @SW_HIDE, 6)
        While 1
            $sOutput &= StdoutRead($iPID)
            If @error Then
                ExitLoop
            EndIf
        WEnd
    Next

    Return StringSplit(StringStripWS(StringStripCR($sOutput), 3), @LF)
EndFunc   ;==>_FindInFile