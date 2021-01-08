;===============================================================================
;
; Description:      Return JPEG, TIFF, BMP, PNG and GIF image size.
; Parameter(s):     File name
; Requirement(s):   None special
; Return Value(s):  On Success - array with width and height
;                   On Failure empty string and sets @ERROR:
;                       1 - Not valid image or info not found
; Author(s):        YDY (Lazycat)
; Version:          1.1.00
; Date:             15.03.2005
;
;===============================================================================

Func _ImageGetSize($sFile)
    Local $sHeader = _FileReadAtOffsetHEX($sFile, 1, 24); Get header bytes
    Local $asIdent = StringSplit("FFD8 424D 89504E470D0A1A 4749463839 4749463837 4949 4D4D", " ")
    Local $anSize = ""
    For $i = 1 To $asIdent[0]
        If StringInStr($sHeader, $asIdent[$i]) = 1 Then
            Select
                Case $i = 1; JPEG
                    $anSize = _ImageGetSizeJPG($sFile)
                    Exitloop
                Case $i = 2; BMP
                    $anSize = _ImageGetSizeSimple($sHeader, 19, 23, 0)
                    Exitloop
                Case $i = 3; PNG
                    $anSize = _ImageGetSizeSimple($sHeader, 19, 23, 1)
                    Exitloop
                Case ($i = 4) or ($i = 5); GIF
                    $anSize = _ImageGetSizeSimple($sHeader, 7, 9, 0)
                    Exitloop
                Case $i = 6; TIFF MM
                    $anSize = _ImageGetSizeTIF($sFile, 0)
                    Exitloop
                Case $i = 7; TIFF II
                    $anSize = _ImageGetSizeTIF($sFile, 1)
                    Exitloop
            EndSelect
        Endif
    Next
    If not IsArray ($anSize) Then SetError(1)
    Return($anSize)
EndFunc

;===============================================================================
;
; Description:      Get image size at given bytes
; Parameter(s):     File header 
; Return Value(s):  Array with dimension
;
;===============================================================================
Func _ImageGetSizeSimple($sHeader, $nXoff, $nYoff, $nByteOrder)
    Local $anSize[2]
    $anSize[0] = _Dec(StringMid($sHeader, $nXoff*2-1, 4), $nByteOrder)
    $anSize[1] = _Dec(StringMid($sHeader, $nYoff*2-1, 4), $nByteOrder)
    Return ($anSize)
EndFunc

;===============================================================================
;
; Description:      Get JPG image size (may be used standalone with checking)
; Parameter(s):     File name
; Return Value(s):  On Success - array with dimension
;
;===============================================================================
Func _ImageGetSizeJPG($sFile)
    Local $anSize[2], $sData, $sSeg, $nFileSize, $nPos = 3
    $nFileSize = FileGetSize($sFile)
    While $nPos < $nFileSize
        $sData = _FileReadAtOffsetHEX ($sFile, $nPos, 4)
        If StringLeft($sData, 2) = "FF" then; Valid segment start
            If StringInStr("C0 C2 CA C1 C3 C5 C6 C7 C9 CB CD CE CF", StringMid($sData, 3, 2)) Then; Segment with size data
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
    Return("")
EndFunc

;===============================================================================
;
; Description:      Get TIFF image size (may be used standalone with checking)
; Parameter(s):     File name
; Return Value(s):  On Success - array with dimension
;
;===============================================================================
Func _ImageGetSizeTIF($sFile, $nByteOrder)
    Local $anSize[2], $pos = 3
    $nTagsOffset = _Dec(_FileReadAtOffsetHEX($sFile, 5, 4), $nByteOrder) + 1
    $nFieldCount = _Dec(_FileReadAtOffsetHEX($sFile, $nTagsOffset, 2), $nByteOrder)
    For $i = 0 To $nFieldCount - 1
        $sField = _FileReadAtOffsetHEX($sFile, $nTagsOffset + 2 + 12 * $i, 12)
        $sTag = StringLeft($sField, 4)
        If $nByteOrder Then $sTag = StringRight($sTag, 2) & StringLeft($sTag, 2)
        Select
            Case $sTag = "0001"
                $anSize[0] = _Dec(StringRight($sField, 8), $nByteOrder)
            Case $sTag = "0101"
                $anSize[1] = _Dec(StringRight($sField, 8), $nByteOrder)
        EndSelect
    Next
    If ($anSize[0] = 0) or ($anSize[1] = 0) Then Return("")
    Return($anSize)
Endfunc

;===============================================================================
;
; Description:      Basic function that read binary data into HEX-string
; Parameter(s):     File name, Start offset, Number bytes to read
; Return Value(s):  Hex string
;
;===============================================================================
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

;===============================================================================
;
; Description:      Basic function, similar Dec, but take in account byte order
; Parameter(s):     Hex string, Byte order
; Return Value(s):  Decimal value
;
;===============================================================================
Func _Dec($sHexStr, $nByteOrder)
    If $nByteOrder Then Return(Dec($sHexStr))
    Local $sTempStr = ""
    While StringLen($sHexStr) > 0
        $sTempStr = $sTempStr & StringRight($sHexStr, 2)
        $sHexStr = StringTrimRight($sHexStr, 2)
    WEnd
    Return (Dec($sTempStr))
EndFunc
