;===============================================================================
;
; Description:      Return JPEG, TIFF, BMP, PNG and GIF image size.
; Parameter(s):     File name
; Requirement(s):   None
; Return Value(s):  On Success - array with width and height
;                   On Failure empty string and sets @ERROR:
;                       1 - Not valid image or info not found
; Author(s):        YDY (Lazycat) <mpc@nm.ru>
; Version:          1.0.00
; Date:             18.08.2004
; Note(s):          None
;
;===============================================================================

Func _GetImageSize($file)
    Local $header = _FileReadAtOffsetHEX($file, 1, 8) ; Get header bytes 
    Local $ident = StringSplit("FFD8 424D 89504E470D0A1A 4749463839 4749463837 4D4D 4949", " ")
    Local $size = ""
    For $ic = 1 To $ident[0]
        If StringInStr($header, $ident[$ic]) = 1 Then
            Select
                Case $ic = 1 ; JPEG
                    $size = _GetJpegSize($file)
                    Exitloop
                Case $ic = 2 ; BMP
                    $size = _GetSimpleSize($file, 19, 23, 0)
                    Exitloop
                Case $ic = 3 ; PNG
                    $size = _GetSimpleSize($file, 19, 23, 1)
                    Exitloop
                Case ($ic = 4) or ($ic = 5) ; GIF
                    $size = _GetSimpleSize($file, 7, 9, 0)
                    Exitloop
                Case ($ic = 6) or ($ic = 7) ; TIFF
                    $size = _GetTIFFSize($file)
                    Exitloop
            EndSelect
        Endif
    Next
    if not IsArray ($size) Then SetError(1)
    Return($size)
EndFunc

;; Functions

Func _GetSimpleSize($file, $xoff, $yoff, $ByteOrder)
    Local $size[2]
    $size[0] = _Dec(_FileReadAtOffsetHEX($file, $xoff, 2), $ByteOrder)
    $size[1] = _Dec(_FileReadAtOffsetHEX($file, $yoff, 2), $ByteOrder)
    Return ($size)
EndFunc

Func _GetJpegSize($file)
Local $size[2]
Local $fs, $pos = 3

$fs = FileGetSize($file)

While $pos < $fs
    $data = _FileReadAtOffsetHEX ($file, $pos, 4)
    if StringLeft($data, 2) = "FF" then ; Valid segment start
        if StringInStr("C0 C2 CA C1 C3 C5 C6 C7 C9 CB CD CE CF", StringMid($data, 3, 2)) then ; Segment with size data
           $seg = _FileReadAtOffsetHEX ($file, $pos+5, 4)
           $size[1] = Dec(StringLeft($seg, 4))
           $size[0] = Dec(StringRight($seg, 4))
           Return($size)
        else
           $pos = $pos + Dec(StringRight($data, 4)) + 2
        endif
    else
        exitloop
    endif
Wend
Return("")
EndFunc

Func _GetTIFFSize($file)
Local $pos = 3, $ByteOrder = 0, $size[2]

$id = _FileReadAtOffsetHEX ($file, 1, 2)
If $id = "4D4D" then $ByteOrder = 1

$offset = _Dec(_FileReadAtOffsetHEX($file, 5, 4), $ByteOrder) + 1
$fields = _Dec(_FileReadAtOffsetHEX($file, $offset, 2), $ByteOrder)

For $ic = 0 To $fields-1
    $field = _FileReadAtOffsetHEX($file, $offset + 2 + 12 * $ic, 12)
    $tag = StringLeft($field, 4)
    If $ByteOrder Then $tag = StringRight($tag, 2) & StringLeft($tag, 2)
    Select
        Case $tag = "0001"
            $size[0] = _ParseField($file, $field, $ByteOrder)
        Case $tag = "0101"
            $size[1] = _ParseField($file, $field, $ByteOrder)
    EndSelect
Next
If ($size[0] = 0) or ($size[1] = 0) Then Return("")
Return($size)
Endfunc

;; Parse TIFF fields

Func _ParseField($file, $tag, $ByteOrder)
    Local $type = _Dec(StringMid($tag, 5, 4), $ByteOrder)
    If $type < 5 Then Return (_Dec(StringRight($tag, 8), $ByteOrder))
    Local $count = _Dec(StringMid($tag, 9, 8), $ByteOrder)
    Local $offset = _Dec(StringRight($tag, 8), $ByteOrder)
    Local $tStr = _FileReadAtOffsetHEX ($file, $offset, $count)
    Local $oStr = ""
    While StringLen($tStr) > 0
       $oStr = $oStr & Chr(Dec(StringLeft($tStr, 2)))
       $tStr = StringTrimLeft($tStr, 2)
    WEnd
    Return($oStr)
EndFunc

Func _Dec($input, $ByteOrder)
    If $ByteOrder then Return(Dec($input))
    Local $tStr = ""
    While StringLen($input) > 0
        $tStr = $tStr & StringRight($input, 2)
        $input = StringTrimRight($input, 2)
    WEnd
    Return (Dec($tStr))
EndFunc

Func _FileReadAtOffsetHEX ($file, $offset, $bytes)
    Local $tfile = FileOpen($file, 0)
    Local $tstr = ""
    FileRead($tfile, $offset-1)
    For $i = $offset To $offset + $bytes - 1
        $tstr =  $tstr & Hex(Asc(FileRead($tfile, 1)), 2)
    Next
    FileClose($tfile)
    Return ($tstr)
Endfunc