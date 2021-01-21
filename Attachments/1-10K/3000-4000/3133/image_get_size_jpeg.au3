;===============================================================================
;
; Description:      Return JPEG size
; Parameter(s):     File name
; Requirement(s):   None
; Return Value(s):  On Success - array with width and height
;                   On Failure empty string and sets @ERROR:
;                       1 - File is not valid JPEG
;                       2 - Info not found
; Author(s):        YDY (Lazycat)
; Version:          1.2.00
; Date:             15.03.2005
; Note(s):          None
;
;===============================================================================

Func _ImageGetSizeJPG($sFile)
    If not (_FileReadAtOffsetHEX ($sFile, 1, 2) = "FFD8") Then
        SetError(1) ; Not Jpeg
        Return("")
    Endif
    Local $anSize[2], $sData, $sSeg, $nFileSize, $nPos = 3
    $nFileSize = FileGetSize($sFile)
    While $nPos < $nFileSize
        $sData = _FileReadAtOffsetHEX ($sFile, $nPos, 4)
        If StringLeft($sData, 2) = "FF" then ; Valid segment start
            If StringInStr("C0 C2 CA C1 C3 C5 C6 C7 C9 CB CD CE CF", StringMid($sData, 3, 2)) Then ; Segment with size data
               $sSeg = _FileReadAtOffsetHEX ($sFile, $nPos + 5, 4)
               $anSize[1] = Dec(StringLeft($sSeg, 4))
               $anSize[0] = Dec(StringRight($sSeg, 4))
               Return($anSize)
            Else
               $nPos= $nPos + Dec(StringRight($sData, 4)) + 2
            Endif
        Else
            ExitLoop
        Endif
    Wend
    SetError(2) ; Segment not found
    Return("")
EndFunc

Func _FileReadAtOffsetHEX ($sFile, $nOffset, $nBytes)
    Local $hFile = FileOpen($sFile, 0)
    Local $sTempStr = ""
    FileRead($hFile, $nOffset - 1)
    For $i = $nOffset To $nOffset + $nBytes - 1
        $sTempStr = $sTempStr & Hex(Asc(FileRead($hFile, 1)), 2)
    Next
    FileClose($hFile)
    Return ($sTempStr)
Endfunc
