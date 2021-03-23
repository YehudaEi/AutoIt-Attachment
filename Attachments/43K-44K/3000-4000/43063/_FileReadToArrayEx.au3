; #CONSTANTS# ====================================================
#Region ;**** Global vars for _FileReadToArrayEx
Global Const $FRTA_NOCOUNT         = 1
Global Const $FRTA_ARRAYFIELD      = 2
Global Const $FRTA_STRIPLEADING    = 4
Global Const $FRTA_STRIPTRAILING   = 8
Global Const $FRTA_STRIPLINEEMPTY  = 16
Global Const $FRTA_CHECKSINGEQUOTE = 32
Global Const $FRTA_STRIP_TRAILINGLEADING  = BitOR($FRTA_STRIPLEADING, $FRTA_STRIPTRAILING) ;INTERNALLY USE ONLY
Global Const $FRTA_STRIPALL        = BitOR($FRTA_STRIPLEADING, $FRTA_STRIPTRAILING, $FRTA_STRIPLINEEMPTY)
#EndRegion ;**** Global vars for _FileReadToArrayEx
; ================================================================

; #FUNCTION# ====================================================================================================================
; Name...........: _FileReadToArrayEx
; Description ...: Reads the specified file into an array.
; Parameters ....: $sFilePath - Path and filename of the file to be read.
;                 $sDelim     - Optional, Fiels separator character, Default is ',', This parameter can not be '"' or "'"  or ';' or Whitespace character
;                 $iFlags     - Optional, Flag to indicate the type of stripping that should be performed (add the flags together for multiple operations)
;                 |  Default (0) - Return All line)s and set array count in the 0th index
;                 |$FRTA_NOCOUNT (1)          - Don't return the array count
;                 |$FRTA_ARRAYFIELD (2)       - Array field Mod
;                 |$FRTA_STRIPLEADING (4)     - Strip Line leading white space
;                 |$FRTA_STRIPTRAILING (8)    - Strip Line trailing white space
;                 |$FRTA_STRIPLINEEMPTY (16)  - Don't return Line empty (ignores @CRLF & @CRLF & @CRLF ect ect)
;                 |$FRTA_CHECKSINGEQUOTE (64) - Check also Single Quote "'" for compatibility with AU3 file, Default check Double Quote only
;                                                This Flags will be ignored if the $FRTA_ARRAYFIELD is not set\used,
; Return values .: If the function succeeds, it returns Array (Check @extended for array count); otherwise, 0.
;                  @error  - 0 = No error
;                  |1 = File does not exist (or has not $GENERIC_READ Security Access Rights) or No line\fiels found
; Author ........: DXRW4E
; ===============================================================================================================================
Func _FileReadToArrayEx($sFilePath, $sDelim = "", $iFlags = 0)
    If BitAND($iFlags, $FRTA_ARRAYFIELD) Then
        Local $sData = StringTrimLeft(StringTrimRight(StringRegExpReplace(@LF & FileRead($sFilePath) & @LF, "[\s\x0]*[\r\n][\s\x0]*+", @LF), 1), 1)
        If Not $sData Then Return SetError(1, 0, 0)
        If Not $sDelim Then $sDelim = ","
        If BitAND($iFlags, $FRTA_CHECKSINGEQUOTE) Then
            $sData = StringRegExpReplace($sData, "(?:[^" & $sDelim & '\s"''\x0]+|''[^'']*''|"[^"]*"|[\h\f\xb\x0]*+(?!\n|' & $sDelim & "))*+\K[\h\f\xb\x0]*+" & $sDelim & "[\h\f\xb\x0]*+", @CR)
        Else
            $sData = StringRegExpReplace($sData, "(?:[^" & $sDelim & '\s"\x0]+|"[^"]*"|[\h\f\xb\x0]*+(?!\n|' & $sDelim & "))*+\K[\h\f\xb\x0]*+" & $sDelim & "[\h\f\xb\x0]*+", @CR)
        EndIf
        Local $STR_COUNT = (BitAND($iFlags, $FRTA_NOCOUNT) ? 3 : 1)
        $sData = StringSplit($sData, @LF, $STR_COUNT)
        Local $iaData = ($STR_COUNT = 1 ? $sData[0] : UBound($sData) - 1), $_iaData = ($STR_COUNT = 1 ? 1 : 0)
        For $i = $_iaData To $iaData
            $sData[$i] = StringSplit($sData[$i], @CR, $STR_COUNT)
        Next
        Return SetError(0, $iaData, $sData)
    Else
        Local $iCount = 0, $sData = BitAND($iFlags, $FRTA_NOCOUNT) ? FileRead($sFilePath) : "0" & @LF & FileRead($sFilePath)
        If Not BitAND($iFlags, $FRTA_STRIPALL) Then
            $sData = StringRegExp($sData, "(?s)([^\r\n]*+)\r?+\n?+", 3)
        ElseIf BitAND($iFlags, $FRTA_STRIPALL) = $FRTA_STRIPALL Then
            $sData = StringRegExp($sData, "(?s)[\s\x0]*+((?:[^\s\x0]+|[\h\f\xb\x0]*+(?![\r\n]|$))+)[\s\x0]*+", 3)
        Else
            $sData = StringRegExp($sData, (BitAND($iFlags, $FRTA_STRIPLINEEMPTY) ? "(?s)[\r\n]*+" : "(?s)") & (BitAND($iFlags, $FRTA_STRIPLEADING) ? "[\h\f\xb\x0]*+" : "") & (BitAND($iFlags, $FRTA_STRIPTRAILING) ? "((?:[^\s\x0]+|[\h\f\xb\x0]*+(?![\r\n]|$))*+)[\h\f\xb\x0]*+" : "([^\r\n]*+)") & (BitAND($iFlags, $FRTA_STRIPLINEEMPTY) ? "[\r\n]*+" : ""), 3)
        EndIf
        If @Error Then Return SetError(1, 0, 0)
        $iCount = UBound($sData)
        If Not BitAND($iFlags, $FRTA_NOCOUNT) Then $sData[0] = $iCount - 1
        Return SetError(0, $iCount, $sData)
    EndIf
EndFunc ;==>_FileReadToArrayEx