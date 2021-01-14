#include-once
;===============================================================================
;
; Description:      Retrieve MP3 tag info
; Parameter(s):     File name
; Requirement(s):   Autoit Beta 3.104.123+ (DllStruct, Binary, RegExp)
; Return Value(s):  On Success - array with data:
;                       0 - Title
;                       1 - Artist
;                       2 - Album
;                       3 - Year
;                       4 - Comment
;                       5 - Track number
;                       6 - Genre
;                       7 - Length (for V2 only, may be used for determine length for VBR files)
;                       8 - Tag version
;                   On Failure empty string and sets @ERROR:
;                       1 - Info not found
; Author(s):        YDY (Lazycat)
; Version:          2.5.1
; Date:             06.05.2006
; Note(s):          None
;
;===============================================================================

Func _MP3GetTag($sFile)
    Local $ret = DllCall("kernel32.dll","int","CreateFile", _
                        "str",$sFile, _
                        "int",0x80000000, _
                        "int",0, _
                        "ptr",0, _
                        "int",3, _
                        "int",0x80, _
                        "ptr",0)
                        
    If @error OR Not $ret[0] Then 
        SetError(1)
        Return ""
    Endif
    Local $vTag = _MP3GetV2Tag($ret[0])
    If not IsArray($vTag) Then $vTag = _MP3GetV1Tag($ret[0], FileGetSize($sFile) - 128)
    DllCall("kernel32.dll","int","CloseHandle","int", $ret[0])
    If IsArray($vTag) Then Return $vTag
    SetError(1)
    Return ""
EndFunc

Func _MP3GetV1Tag($hFile, $nTagPos)
    Local $pTag = _FileReadToStruct("char[3];char[30];char[30];char[30];char[4];char[30];byte", $hFile, $nTagPos)    
    If not (_DllStructArrayAsString($pTag, 1, 3) == "TAG") Then Return "" ; ID3v1 tag NOT found
    Local $asInfo[9]
    $asInfo[0] = _DllStructArrayAsString($pTag, 2, 30) ; Title
    $asInfo[1] = _DllStructArrayAsString($pTag, 3, 30) ; Peformer
    $asInfo[2] = _DllStructArrayAsString($pTag, 4, 30) ; Album
    $asInfo[3] = _DllStructArrayAsString($pTag, 5, 4)  ; Year
    $asInfo[4] = _DllStructArrayAsString($pTag, 6, 30) ; Comment
    $asInfo[5] = ""                                    ; Track number  
    $asInfo[8] = "1.0"
    If DllStructGetData($pTag, 6, 29) = 0 Then ; Version 1.1
        $asInfo[5] = DllStructGetData($pTag, 6, 30) 
        $asInfo[8] = "1.1"
    EndIf
    $asInfo[6] = _MP3GetGenreByID(DllStructGetData($pTag, 7)) ; Genre
    $asInfo[7] = ""
    Return($asInfo)
EndFunc

Func _MP3GetV2Tag($hFile)
Local $nTagSize = 1, $nFrameOffset = 10, $nTagInfo
Local $asInfo[9], $sID, $pFrame, $pHeader, $pTemp, $nFrameSize, $sData

$pHeader = _FileReadToStruct("char[3];byte;byte;byte;dword;dword", $hFile, 0)
If not (StringLeft(DllStructGetData($pHeader, 1), 3) = "ID3") Then Return

For $i = 0 To 8
    $asInfo[$i] = ""
Next

; Set tag version
$asInfo[8] = StringFormat("2.%d.%d", DllStructGetData($pHeader, 2), DllStructGetData($pHeader, 3))

$nTagInfo = DllStructGetData($pHeader, 4)
$nTagSize = _SSIntToInt(DllStructGetData($pHeader, 5)) + 10

If _IsBitSet($nTagInfo, 4) Then $nTagSize = $nTagSize + 10  ; Footer presented, RARE case
If _IsBitSet($nTagInfo, 6) Then $nFrameOffset = 10 + _SSIntToInt(DllStructGetData($p, 5)) ; ExtHeader presented

$pFrame = DllStructCreate("char[4];dword;short")

While $nFrameOffset < $nTagSize
    $pFrame = _FileReadToStruct($pFrame, $hFile, $nFrameOffset)
    $sID = DllStructGetData($pFrame, 1)
    $nFrameSize = _SSIntToInt(DllStructGetData($pFrame, 2))
    If $nFrameSize > $nTagSize Then Exitloop
    $pTemp = _FileReadToStruct("byte;byte[" & $nFrameSize - 1 & "]", $hFile, $nFrameOffset + 10)

    $sData = _GetDecodedText(DllStructGetData($pTemp, 1), DllStructGetData($pTemp, 2), $nFrameSize)

    Select
        Case $sID == "TIT2" ; Title 
            $asInfo[0] = $sData
        Case $sID == "TPE1" ; Performer (primary)
            $asInfo[1] = $sData
        Case $sID == "TPE2" ; Performer (secondary)
            If $asInfo[1] == "" Then $asInfo[1] = $sData
        Case $sID == "TALB" ; Album
            $asInfo[2] = $sData
        Case $sID == "TYER" ; Year
            $asInfo[3] = $sData
        Case $sID == "COMM" ; Required special
            If $asInfo[4] == "" Then ; MS ShellExt tag editor add empty COMM at the end of tag...
                ; Not sure if this is correct method...
                If DllStructGetData($pTemp, 2, 4) = 0 Then
                   If DllStructGetData($pTemp, 2, 5) = 0 Then
                       $asInfo[4] = _GetDecodedText(DllStructGetData($pTemp, 1), StringTrimLeft(DllStructGetData($pTemp, 2), 5), $nFrameSize)
                   Else
                       $asInfo[4] = _GetDecodedText(DllStructGetData($pTemp, 1), StringTrimLeft(DllStructGetData($pTemp, 2), 4), $nFrameSize)
                   EndIf
                EndIf
            EndIf
        Case $sID == "TRCK" ; Track number
            $asInfo[5] = $sData
        Case $sID == "TCON" ; Genre
            $asInfo[6] = $sData
            $sData = StringRegExp($sData, "\((\d{1,3})\)", 1)
            If @extended Then $asInfo[6] = _MP3GetGenreByID($sData[0])
        Case $sID == "TLEN" ; Length!
            $asInfo[7] = Int(Number($sData)/1000)
            $asInfo[7] = StringFormat("%d:%02d", Int($asInfo[7] / 60), $asInfo[7] - Int($asInfo[7] / 60) * 60)
        Case StringLen($sID) < 4 or not StringIsAlNum($sID)
            Exitloop ; Zero-byte padding (end of tag), wrong sID -> Exitloop                           
    EndSelect
    $nFrameOffset = $nFrameOffset + $nFrameSize + 10  
    $pTemp = 0
Wend
Return($asInfo)
EndFunc

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Support functions ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Func _MP3GetGenreByID($iID)
    Local $asGenre = StringSplit("Blues,Classic Rock,Country,Dance,Disco,Funk,Grunge,Hip-Hop," & _
    "Jazz,Metal,New Age, Oldies,Other,Pop,R&B,Rap,Reggae,Rock,Techno,Industrial,Alternative," & _
    "Ska,Death Metal,Pranks,Soundtrack,Euro-Techno,Ambient,Trip-Hop,Vocal,Jazz+Funk,Fusion," & _
    "Trance,Classical,Instrumental,Acid,House,Game,Sound Clip,Gospel,Noise,Alternative Rock," & _
    "Bass,Soul,Punk,Space,Meditative,Instrumental Pop,Instrumental Rock,Ethnic,Gothic,Darkwave," & _
    "Techno-Industrial,Electronic,Pop-Folk,Eurodance,Dream,Southern Rock,Comedy,Cult,Gangsta," & _
    "Top 40,Christian Rap,Pop/Funk,Jungle,Native US,Cabaret,New Wave,Psychadelic,Rave,Showtunes," & _
    "Trailer,Lo-Fi,Tribal,Acid Punk,Acid Jazz,Polka,Retro,Musical,Rock & Roll,Hard Rock,Folk," & _
    "Folk-Rock,National Folk,Swing,Fast Fusion,Bebob,Latin,Revival,Celtic,Bluegrass,Avantgarde," & _
    "Gothic Rock,Progressive Rock,Psychedelic Rock,Symphonic Rock,Slow Rock,Big Band,Chorus," & _
    "Easy Listening,Acoustic,Humour,Speech,Chanson,Opera,Chamber Music,Sonata,Symphony,Booty Bass," & _
    "Primus,Porn Groove,Satire,Slow Jam,Club,Tango,Samba,Folklore,Ballad,Power Ballad,Rhytmic Soul," & _
    "Freestyle,Duet,Punk Rock,Drum Solo,Acapella,Euro-House,Dance Hall,Goa,Drum & Bass,Club-House," & _
    "Hardcore,Terror,Indie,BritPop,Negerpunk,Polsk Punk,Beat,Christian Gangsta,Heavy Metal,Black Metal," & _
    "Crossover,Contemporary C,Christian Rock,Merengue,Salsa,Thrash Metal,Anime,JPop,SynthPop", ",")
    If ($iID >= 0) and ($iID < 148) Then Return $asGenre[$iID + 1]
    Return("")
EndFunc

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Common functions ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Func _DllStructArrayAsString($p, $index, $size, $start = 1)
    Local $sTemp = "", $char
    For $i = $start to $size
        $char = DllStructGetData($p, $index, $i)
        If $char = 0 then Return $sTemp
        $sTemp &= Chr($char)
    Next
    Return $sTemp
EndFunc

Func _SSIntToInt($nSSInt)
    Local $nRet = 0
    For $i = 0 To 3
        $nRet = $nRet + BitShift(BitAND(BitShift($nSSInt, 8 * (3-$i)), 0xFF), -7 * $i)
    Next
    Return($nRet)
EndFunc

Func _IsBitSet($nNum, $nBit)
    Return BitAND(BitShift($nNum, $nBit), 1)
EndFunc

Func _FileReadToStruct($vStruct, $hFile, $nOffset)
    If not DllStructGetSize($vStruct) Then $vStruct = DllStructCreate($vStruct)
    Local $nLen	= DllStructGetSize($vStruct)
	Local $ret	= DllCall("kernel32.dll","int","SetFilePointer", _
					"int",$hFile, _
					"int",$nOffset, _
					"int",0, _
					"int",0) ; FILE_BEGIN
    Local $pRead = DllStructCreate("dword")
	$ret	= DllCall("kernel32.dll","int","ReadFile", _
					"int",$hFile, _
					"ptr",DllStructGetPtr($vStruct), _
					"int", $nLen, _
					"ptr",DllStructGetPtr($pRead), _
					"ptr",0)
    If @error Then 
        SetError(1)
	EndIf
    Local $nRead = DllStructGetData($pRead, 1)
    $pRead = 0
    SetExtended($nRead)
    If not ($nRead = $nLen) Then SetError(2)
    Return $vStruct
EndFunc

Func _GetDecodedText($nType, $sText, $nSize)
    Switch $nType
        Case 0        ; ASCII
            If ($nSize - 1) = 1 Then Return Chr($sText)
            Return $sText
        Case 0x1, 0x2 ; Unicode
            Return _Unicode2Asc($sText)
        Case 0x3      ; UTF-8
            Return _Unicode2Asc(_Utf82Unicode($sText))
    EndSwitch
EndFunc

;;;;;;;;;;;;;;;;;;;;;;;; Unicode conversion functions originally written by Arilvv ;;;;;;;;;;;;;;;;;;;;;;;

Func _Unicode2Asc($UniString)
    Local $lb, $hb, $InpBuf
    Local $BufferLen = StringLen($UniString)
    Local $Input = DllStructCreate("ubyte[" & $BufferLen & "]")
    DllStructSetData($Input, 1, $UniString)
    $lb = DllStructGetData($Input, 1, 1)
    $hb = DllStructGetData($Input, 1, 2)
    If (($lb = 0xFF) and ($hb = 0xFE)) or (($lb = 0xFE) and ($hb = 0xFF)) Then ; BOM found
        $BufferLen -= 2
        $InpBuf = DllStructCreate("byte[" & $BufferLen & "]", DllStructGetPtr($Input) + 2)
    Else
        $InpBuf = DllStructCreate("byte[" & $BufferLen & "]", DllStructGetPtr($Input))
    EndIf

    Local $Output = DllStructCreate("char[" &  $BufferLen & "]")    
    Local $Return = DllCall("kernel32.dll", "int", "WideCharToMultiByte", _
        "int", 0, _
        "int", 0, _
        "ptr", DllStructGetPtr($InpBuf), _
        "int", $BufferLen / 2, _
        "ptr", DllStructGetPtr($Output), _
        "int", $BufferLen, _
        "int", 0, _
        "int", 0)   
    Return DllStructGetData($Output, 1)
EndFunc

Func _Utf82Unicode($Utf8String)
    Local $BufferSize = StringLen($Utf8String) * 2
    Local $Buffer = DllStructCreate("byte[" & $BufferSize & "]")
    Local $Return = DllCall("Kernel32.dll", "int", "MultiByteToWideChar", _
        "int", 65001, _
        "int", 0, _
        "str", $Utf8String, _
        "int", StringLen($Utf8String), _
        "ptr", DllStructGetPtr($Buffer), _
        "int", $BufferSize)
    Return StringLeft(DllStructGetData($Buffer, 1), $Return[0] * 2)
EndFunc