; Converted to AutoIt script by SvenP

;*******************************************************************************
; MODULE:       CMD5
; AUTHOR:       Phil Fresle
; CREATED:      16-Feb-2001
; COPYRIGHT:    Copyright 2001 Frez Systems Limited. All Rights Reserved.
; DESCRIPTION:
; Derived from the RSA Data Security, Inc. MD5 Message-Digest Algorithm,
; as set out in the memo RFC1321.
; Web Site:                       
; E-mail:    sales@frez.co.uk
;*******************************************************************************

Const $BITS_TO_A_BYTE  = 8
Const $BYTES_TO_A_WORD = 4
Const $BITS_TO_A_WORD  = $BYTES_TO_A_WORD * $BITS_TO_A_BYTE

Dim $m_lOnBits[31]
Dim $m_l2Power[31]

Func Class_Initialize()
    $m_lOnBits[0] = 1            ; 00000000000000000000000000000001
    $m_lOnBits[1] = 3            ; 00000000000000000000000000000011
    $m_lOnBits[2] = 7            ; 00000000000000000000000000000111
    $m_lOnBits[3] = 15           ; 00000000000000000000000000001111
    $m_lOnBits[4] = 31           ; 00000000000000000000000000011111
    $m_lOnBits[5] = 63           ; 00000000000000000000000000111111
    $m_lOnBits[6] = 127          ; 00000000000000000000000001111111
    $m_lOnBits[7] = 255          ; 00000000000000000000000011111111
    $m_lOnBits[8] = 511          ; 00000000000000000000000111111111
    $m_lOnBits[9] = 1023         ; 00000000000000000000001111111111
    $m_lOnBits[10] = 2047        ; 00000000000000000000011111111111
    $m_lOnBits[11] = 4095        ; 00000000000000000000111111111111
    $m_lOnBits[12] = 8191        ; 00000000000000000001111111111111
    $m_lOnBits[13] = 16383       ; 00000000000000000011111111111111
    $m_lOnBits[14] = 32767       ; 00000000000000000111111111111111
    $m_lOnBits[15] = 65535       ; 00000000000000001111111111111111
    $m_lOnBits[16] = 131071      ; 00000000000000011111111111111111
    $m_lOnBits[17] = 262143      ; 00000000000000111111111111111111
    $m_lOnBits[18] = 524287      ; 00000000000001111111111111111111
    $m_lOnBits[19] = 1048575     ; 00000000000011111111111111111111
    $m_lOnBits[20] = 2097151     ; 00000000000111111111111111111111
    $m_lOnBits[21] = 4194303     ; 00000000001111111111111111111111
    $m_lOnBits[22] = 8388607     ; 00000000011111111111111111111111
    $m_lOnBits[23] = 16777215    ; 00000000111111111111111111111111
    $m_lOnBits[24] = 33554431    ; 00000001111111111111111111111111
    $m_lOnBits[25] = 67108863    ; 00000011111111111111111111111111
    $m_lOnBits[26] = 134217727   ; 00000111111111111111111111111111
    $m_lOnBits[27] = 268435455   ; 00001111111111111111111111111111
    $m_lOnBits[28] = 536870911   ; 00011111111111111111111111111111
    $m_lOnBits[29] = 1073741823  ; 00111111111111111111111111111111
    $m_lOnBits[30] = 2147483647  ; 01111111111111111111111111111111

    $m_l2Power[0] = 1            ; 00000000000000000000000000000001
    $m_l2Power[1] = 2            ; 00000000000000000000000000000010
    $m_l2Power[2] = 4            ; 00000000000000000000000000000100
    $m_l2Power[3] = 8            ; 00000000000000000000000000001000
    $m_l2Power[4] = 16           ; 00000000000000000000000000010000
    $m_l2Power[5] = 32           ; 00000000000000000000000000100000
    $m_l2Power[6] = 64           ; 00000000000000000000000001000000
    $m_l2Power[7] = 128          ; 00000000000000000000000010000000
    $m_l2Power[8] = 256          ; 00000000000000000000000100000000
    $m_l2Power[9] = 512          ; 00000000000000000000001000000000
    $m_l2Power[10] = 1024        ; 00000000000000000000010000000000
    $m_l2Power[11] = 2048        ; 00000000000000000000100000000000
    $m_l2Power[12] = 4096        ; 00000000000000000001000000000000
    $m_l2Power[13] = 8192        ; 00000000000000000010000000000000
    $m_l2Power[14] = 16384       ; 00000000000000000100000000000000
    $m_l2Power[15] = 32768       ; 00000000000000001000000000000000
    $m_l2Power[16] = 65536       ; 00000000000000010000000000000000
    $m_l2Power[17] = 131072      ; 00000000000000100000000000000000
    $m_l2Power[18] = 262144      ; 00000000000001000000000000000000
    $m_l2Power[19] = 524288      ; 00000000000010000000000000000000
    $m_l2Power[20] = 1048576     ; 00000000000100000000000000000000
    $m_l2Power[21] = 2097152     ; 00000000001000000000000000000000
    $m_l2Power[22] = 4194304     ; 00000000010000000000000000000000
    $m_l2Power[23] = 8388608     ; 00000000100000000000000000000000
    $m_l2Power[24] = 16777216    ; 00000001000000000000000000000000
    $m_l2Power[25] = 33554432    ; 00000010000000000000000000000000
    $m_l2Power[26] = 67108864    ; 00000100000000000000000000000000
    $m_l2Power[27] = 134217728   ; 00001000000000000000000000000000
    $m_l2Power[28] = 268435456   ; 00010000000000000000000000000000
    $m_l2Power[29] = 536870912   ; 00100000000000000000000000000000
    $m_l2Power[30] = 1073741824  ; 01000000000000000000000000000000
EndFunc
Func LShift($lValue,  $iShiftBits)
    If $iShiftBits = 0 Then
        Return $lValue
    ElseIf $iShiftBits = 31 Then
        If BitAND($lValue, 1) Then
            Return 0x80000000
        Else
            Return 0
        Endif
    ElseIf $iShiftBits < 0 Or $iShiftBits > 31 Then
        SetError(6)
    Endif
    If BitAND($lValue, $m_l2Power[31 - $iShiftBits]) Then
        Return BitOR((BitAND($lValue, $m_lOnBits[31 - ($iShiftBits + 1)]) * _
            $m_l2Power[$iShiftBits]) , 0x80000000)
    
    Else
        Return (BitAND($lValue, $m_lOnBits[31 - $iShiftBits]) * _
            $m_l2Power[$iShiftBits])
        
    Endif
EndFunc
Func RShift($lValue, $iShiftBits)
    
	Local $RShift
    If $iShiftBits = 0 Then
        Return $lValue
    ElseIf $iShiftBits = 31 Then
        If BitAND($lValue, 0x80000000) Then
            Return 1
        Else
            Return 0
        Endif
    ElseIf $iShiftBits < 0 Or $iShiftBits > 31 Then
        SetError(6)
    Endif
    $RShift = int(BitAND($lValue, 0x7FFFFFFE) / $m_l2Power[$iShiftBits])
    If BitAND($lValue, 0x80000000) Then
        $RShift = int(BitOR($RShift, (0x40000000 / $m_l2Power[$iShiftBits - 1])))
    Endif
	
	Return $RShift
	
EndFunc
Func RShiftSigned($lValue , $iShiftBits)
    If $iShiftBits = 0 Then
        Return $lValue
    ElseIf $iShiftBits = 31 Then
        If BitAND($lValue, 0x80000000) Then
            Return -1
        Else
            Return 0
        Endif
    ElseIf $iShiftBits < 0 Or $iShiftBits > 31 Then
        SetError(6)
    Endif
    Return Int($lValue / $m_l2Power[$iShiftBits])
EndFunc
Func RotateLeft($lValue , $iShiftBits)
    Return BitOR(LShift($lValue, $iShiftBits), RShift($lValue, (32 - $iShiftBits)))
EndFunc
Func AddUnsigned($lX , $lY )
 
    $lX8 = BitAND($lX, 0x80000000)
    $lY8 = BitAND($lY, 0x80000000)
    $lX4 = BitAND($lX, 0x40000000)
    $lY4 = BitAND($lY, 0x40000000)
 
    $lResult = BitAND($lX, 0x3FFFFFFF) + BitAND($lY, 0x3FFFFFFF)
 
    If BitAND($lX4, $lY4) Then
        $lResult = BitXOR($lResult, 0x80000000, $lX8, $lY8)
    ElseIf BitOR($lX4 , $lY4) Then
        If BitAND($lResult, 0x40000000) Then
            $lResult = BitXOR($lResult, 0xC0000000, $lX8, $lY8)
        Else
            $lResult = BitXOR($lResult, 0x40000000, $lX8, $lY8)
        Endif
    Else
        $lResult = BitXOR($lResult, $lX8, $lY8)
    Endif
 
    Return $lResult
EndFunc
Func F($x , $y , $z )
    Return BitOR(BitAND($x, $y) , BitAND((BitNOT($x)), $z))
EndFunc
Func G($x , $y , $z )
    Return BitOR(BitAND($x, $z) , BitAND($y , (BitNOT($z))))
EndFunc
Func H($x , $y , $z )
    Return BitXOR($x , $y , $z)
EndFunc
Func I($x , $y , $z )
    Return BitXOR($y , BitOR($x , (BitNOT($z))))
EndFunc
Func FF(ByRef $a , $b , $c , $d , $x , $s , $ac )
    $a = AddUnsigned($a, AddUnsigned(AddUnsigned(F($b, $c, $d), $x), $ac))
    $a = RotateLeft($a, $s)
    $a = AddUnsigned($a, $b)
EndFunc
Func GG(ByRef $a , $b , $c , $d , $x , $s , $ac )
    $a = AddUnsigned($a, AddUnsigned(AddUnsigned(G($b, $c, $d), $x), $ac))
    $a = RotateLeft($a, $s)
    $a = AddUnsigned($a, $b)
EndFunc
Func HH(ByRef $a , $b , $c , $d , $x , $s , $ac )
    $a = AddUnsigned($a, AddUnsigned(AddUnsigned(H($b, $c, $d), $x), $ac))
    $a = RotateLeft($a, $s)
    $a = AddUnsigned($a, $b)
EndFunc
Func II(ByRef $a , $b , $c , $d , $x , $s , $ac )
    $a = AddUnsigned($a, AddUnsigned(AddUnsigned(I($b, $c, $d), $x), $ac))
    $a = RotateLeft($a, $s)
    $a = AddUnsigned($a, $b)
EndFunc
Func ConvertToWordArray($sMessage )
    Dim $lWordArray[1]
    
    Const $MODULUS_BITS     = 512
    Const $CONGRUENT_BITS   = 448
    
    $lMessageLength = StringLen($sMessage)

    $lNumberOfWords = (int(($lMessageLength + _
        int(($MODULUS_BITS - $CONGRUENT_BITS) / $BITS_TO_A_BYTE)) / _
        int($MODULUS_BITS / $BITS_TO_A_BYTE)) + 1) * _
        int($MODULUS_BITS / $BITS_TO_A_WORD)
    ReDim $lWordArray[$lNumberOfWords]
    
    $lBytePosition = 0
    $lByteCount = 0
    Do 
        $lWordCount = int($lByteCount / $BYTES_TO_A_WORD)
        $lBytePosition = (Mod($lByteCount , $BYTES_TO_A_WORD)) * $BITS_TO_A_BYTE
        $lWordArray[$lWordCount] = BitOR($lWordArray[$lWordCount] , _
            LShift(Asc(StringMid($sMessage, $lByteCount + 1, 1)), $lBytePosition))
        $lByteCount = $lByteCount + 1
    Until $lByteCount >= $lMessageLength
    $lWordCount = int($lByteCount / $BYTES_TO_A_WORD)
    $lBytePosition = (Mod($lByteCount , $BYTES_TO_A_WORD)) * $BITS_TO_A_BYTE
    $lWordArray[$lWordCount] = BitOR($lWordArray[$lWordCount] , _
        LShift(0x80, $lBytePosition))
    $lWordArray[$lNumberOfWords - 2] = LShift($lMessageLength, 3)
    $lWordArray[$lNumberOfWords - 1] = RShift($lMessageLength, 29)
    
    Return $lWordArray
EndFunc

Func WordToHex($lValue)
    
	$WordToHex=""
	
    For $lCount = 0 To 3
        $lByte = BitAND(RShift($lValue, $lCount * $BITS_TO_A_BYTE) , _
            $m_lOnBits[$BITS_TO_A_BYTE - 1])
        $WordToHex = $WordToHex & StringRight("0" & Hex($lByte,2), 2)
    Next
	Return $WordToHex
EndFunc

Func MD5($sMessage)
    
    Const $S11  = 7
    Const $S12  = 12
    Const $S13  = 17
    Const $S14  = 22
    Const $S21  = 5
    Const $S22  = 9
    Const $S23  = 14
    Const $S24  = 20
    Const $S31  = 4
    Const $S32  = 11
    Const $S33  = 16
    Const $S34  = 23
    Const $S41  = 6
    Const $S42  = 10
    Const $S43  = 15
    Const $S44  = 21

    Class_Initialize()
	
    $x = ConvertToWordArray($sMessage)
    
    $a = 0x67452301
    $b = 0xEFCDAB89
    $c = 0x98BADCFE
    $d = 0x10325476
	
    For $k = 0 To UBound($x)-1 Step 16
        $AA = $a
        $BB = $b
        $CC = $c
        $DD = $d
        FF( $a, $b, $c, $d, $x[$k + 0], $S11, 0xD76AA478 )
        FF( $d, $a, $b, $c, $x[$k + 1], $S12, 0xE8C7B756 )
        FF( $c, $d, $a, $b, $x[$k + 2], $S13, 0x242070DB )
        FF( $b, $c, $d, $a, $x[$k + 3], $S14, 0xC1BDCEEE )
        FF( $a, $b, $c, $d, $x[$k + 4], $S11, 0xF57C0FAF )
        FF( $d, $a, $b, $c, $x[$k + 5], $S12, 0x4787C62A )
        FF( $c, $d, $a, $b, $x[$k + 6], $S13, 0xA8304613 )
        FF( $b, $c, $d, $a, $x[$k + 7], $S14, 0xFD469501 )
        FF( $a, $b, $c, $d, $x[$k + 8], $S11, 0x698098D8 )
        FF( $d, $a, $b, $c, $x[$k + 9], $S12, 0x8B44F7AF )
        FF( $c, $d, $a, $b, $x[$k + 10], $S13, 0xFFFF5BB1)
        FF( $b, $c, $d, $a, $x[$k + 11], $S14, 0x895CD7BE)
        FF( $a, $b, $c, $d, $x[$k + 12], $S11, 0x6B901122)
        FF( $d, $a, $b, $c, $x[$k + 13], $S12, 0xFD987193)
        FF( $c, $d, $a, $b, $x[$k + 14], $S13, 0xA679438E)
        FF( $b, $c, $d, $a, $x[$k + 15], $S14, 0x49B40821)
    
        GG( $a, $b, $c, $d, $x[$k + 1], $S21, 0xF61E2562 )
        GG( $d, $a, $b, $c, $x[$k + 6], $S22, 0xC040B340 )
        GG( $c, $d, $a, $b, $x[$k + 11], $S23, 0x265E5A51)
        GG( $b, $c, $d, $a, $x[$k + 0], $S24, 0xE9B6C7AA )
        GG( $a, $b, $c, $d, $x[$k + 5], $S21, 0xD62F105D )
        GG( $d, $a, $b, $c, $x[$k + 10], $S22, 0x2441453 )
        GG( $c, $d, $a, $b, $x[$k + 15], $S23, 0xD8A1E681)
        GG( $b, $c, $d, $a, $x[$k + 4], $S24, 0xE7D3FBC8 )
        GG( $a, $b, $c, $d, $x[$k + 9], $S21, 0x21E1CDE6 )
        GG( $d, $a, $b, $c, $x[$k + 14], $S22, 0xC33707D6)
        GG( $c, $d, $a, $b, $x[$k + 3], $S23, 0xF4D50D87 )
        GG( $b, $c, $d, $a, $x[$k + 8], $S24, 0x455A14ED )
        GG( $a, $b, $c, $d, $x[$k + 13], $S21, 0xA9E3E905)
        GG( $d, $a, $b, $c, $x[$k + 2], $S22, 0xFCEFA3F8 )
        GG( $c, $d, $a, $b, $x[$k + 7], $S23, 0x676F02D9 )
        GG( $b, $c, $d, $a, $x[$k + 12], $S24, 0x8D2A4C8A)
            
        HH( $a, $b, $c, $d, $x[$k + 5], $S31, 0xFFFA3942 )
        HH( $d, $a, $b, $c, $x[$k + 8], $S32, 0x8771F681 )
        HH( $c, $d, $a, $b, $x[$k + 11], $S33, 0x6D9D6122)
        HH( $b, $c, $d, $a, $x[$k + 14], $S34, 0xFDE5380C)
        HH( $a, $b, $c, $d, $x[$k + 1], $S31, 0xA4BEEA44 )
        HH( $d, $a, $b, $c, $x[$k + 4], $S32, 0x4BDECFA9 )
        HH( $c, $d, $a, $b, $x[$k + 7], $S33, 0xF6BB4B60 )
        HH( $b, $c, $d, $a, $x[$k + 10], $S34, 0xBEBFBC70)
        HH( $a, $b, $c, $d, $x[$k + 13], $S31, 0x289B7EC6)
        HH( $d, $a, $b, $c, $x[$k + 0], $S32, 0xEAA127FA )
        HH( $c, $d, $a, $b, $x[$k + 3], $S33, 0xD4EF3085 )
        HH( $b, $c, $d, $a, $x[$k + 6], $S34, 0x4881D05  )
        HH( $a, $b, $c, $d, $x[$k + 9], $S31, 0xD9D4D039 )
        HH( $d, $a, $b, $c, $x[$k + 12], $S32, 0xE6DB99E5)
        HH( $c, $d, $a, $b, $x[$k + 15], $S33, 0x1FA27CF8)
        HH( $b, $c, $d, $a, $x[$k + 2], $S34, 0xC4AC5665 )
    
        II( $a, $b, $c, $d, $x[$k + 0], $S41, 0xF4292244 )
        II( $d, $a, $b, $c, $x[$k + 7], $S42, 0x432AFF97 )
        II( $c, $d, $a, $b, $x[$k + 14], $S43, 0xAB9423A7)
        II( $b, $c, $d, $a, $x[$k + 5], $S44, 0xFC93A039 )
        II( $a, $b, $c, $d, $x[$k + 12], $S41, 0x655B59C3)
        II( $d, $a, $b, $c, $x[$k + 3], $S42, 0x8F0CCC92 )
        II( $c, $d, $a, $b, $x[$k + 10], $S43, 0xFFEFF47D)
        II( $b, $c, $d, $a, $x[$k + 1], $S44, 0x85845DD1 )
        II( $a, $b, $c, $d, $x[$k + 8], $S41, 0x6FA87E4F )
        II( $d, $a, $b, $c, $x[$k + 15], $S42, 0xFE2CE6E0)
        II( $c, $d, $a, $b, $x[$k + 6], $S43, 0xA3014314 )
        II( $b, $c, $d, $a, $x[$k + 13], $S44, 0x4E0811A1)
        II( $a, $b, $c, $d, $x[$k + 4], $S41, 0xF7537E82 )
        II( $d, $a, $b, $c, $x[$k + 11], $S42, 0xBD3AF235)
        II( $c, $d, $a, $b, $x[$k + 2], $S43, 0x2AD7D2BB )
        II( $b, $c, $d, $a, $x[$k + 9], $S44, 0xEB86D391 )
    
        $a = AddUnsigned($a, $AA)
        $b = AddUnsigned($b, $BB)
        $c = AddUnsigned($c, $CC)
        $d = AddUnsigned($d, $DD)
    Next
   Return StringLower(WordToHex($a) & WordToHex($b) & WordToHex($c) & WordToHex($d))
EndFunc