; Converted to AutoIt script by SvenP


;*******************************************************************************
; MODULE:       CMD5
; FILENAME:     C:\My Code\vb\md5\CMD5.cls
; AUTHOR:       Phil Fresle
; CREATED:      16-Feb-2001
; COPYRIGHT:    Copyright 2001 Frez Systems Limited. All Rights Reserved.
;
; DESCRIPTION:
; Derived from the RSA Data Security, Inc. MD5 Message-Digest Algorithm,
; as set out in the memo RFC1321.
;
; This class is used to generate an MD5 ;digest; or ;signature; of a string. The
; MD5 algorithm is one of the industry standard methods for generating digital
; signatures. It is generically known as a digest, digital signature, one-way
; encryption, hash or checksum algorithm. A common use for MD5 is for password
; encryption as it is one-way in nature, that does not mean that your passwords
; are not free from a dictionary attack. If you are using the
; routine for passwords, you can make it a little more secure by concatenating
; some known random characters to the password before you generate the signature
; and on Funcsequent tests, so even if a hacker knows you are using MD5 for
; your passwords, the random characters will make it harder to dictionary attack.
;
; *** CAUTION ***
; See the comment attached to the MD5 method below regarding use on systems
; with different character sets.
;
; This is 'free' software with the following restrictions:
;
; You may not redistribute this code as a 'sample'or 'demo'. However, you are free
; to use the source code in your own code, but you may not claim that you created
; the sample code. It is expressly forbidden to sell or profit from this source code
; other than by the knowledge gained or the enhanced value added by your own code.
;
; Use of this software is also done so at your own risk. The code is supplied as
; is without warranty or guarantee of any kind.
;
; Should you wish to commission some derivative work based on this code provided
; here, or any consultancy work, please do not hesitate to contact us.
;
; Web Site:                       
; E-mail:    sales@frez.co.uk
;
; MODIFICATION HISTORY:
; 1.0       16-Feb-2001
;           Phil Fresle
;           Initial Version
;*******************************************************************************

Const $BITS_TO_A_BYTE  = 8
Const $BYTES_TO_A_WORD = 4
Const $BITS_TO_A_WORD  = $BYTES_TO_A_WORD * $BITS_TO_A_BYTE

Dim $m_lOnBits[31]
Dim $m_l2Power[31]

;*******************************************************************************
; Class_Initialize (Func)
;
; DESCRIPTION:
; We will usually get quicker results by preparing arrays of bit patterns and
; powers of 2 ahead of time instead of calculating them every time, unless of
; course the methods are only ever getting called once per instantiation of the
; class.
;*******************************************************************************
Func Class_Initialize()
    ; Could have done this with a loop calculating each value, but simply
    ; assigning the values is quicker - BITS SET FROM RIGHT
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
    
    ; Could have done this with a loop calculating each value, but simply
    ; assigning the values is quicker - POWERS OF 2
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

;*******************************************************************************
; LShift (FUNCTION)
;
; PARAMETERS:
; (In) - $lValue     - Long    - The value to be shifted
; (In) - $iShiftBits - Integer - The number of bits to shift the value by
;
; RETURN VALUE:
; Long - The shifted long integer
;
; DESCRIPTION:
; A left shift takes all the set binary bits and moves them left, in-filling
; with zeros in the vacated bits on the right. This function is equivalent to
; the << operator in Java and C++
;*******************************************************************************
Func LShift($lValue,  $iShiftBits)
    ; NOTE: If you can guarantee that the Shift parameter will be in the
    ; range 1 to 30 you can safely strip of this first nested if structure for
    ; speed.
    ;
    ; A shift of zero is no shift at all.
    If $iShiftBits = 0 Then
        Return $lValue
        
        
    ; A shift of 31 will result in the right most bit becoming the left most
    ; bit and all other bits being cleared
    ElseIf $iShiftBits = 31 Then
        If BitAND($lValue, 1) Then
            Return 0x80000000
        Else
            Return 0
        Endif
        
        
    ; A shift of less than zero or more than 31 is undefined
    ElseIf $iShiftBits < 0 Or $iShiftBits > 31 Then
        SetError(6)
    Endif
    
    ; If the left most bit that remains will end up in the negative bit
    ; position (0x80000000) we would end up with an overflow if we took the
    ; standard route. We need to strip the left most bit and add it back
    ; afterwards.
    If BitAND($lValue, $m_l2Power[31 - $iShiftBits]) Then
    
        ; (Value And OnBits(31 - (Shift + 1))) chops off the left most bits that
        ; we are shifting into, but also the left most bit we still want as this
        ; is going to end up in the negative bit marker position (0x80000000).
        ; After the multiplication/shift we Or the result with 0x80000000 to
        ; turn the negative bit on.
        Return BitOR((BitAND($lValue, $m_lOnBits[31 - ($iShiftBits + 1)]) * _
            $m_l2Power[$iShiftBits]) , 0x80000000)
    
    Else
    
        ; (Value And OnBits(31-Shift)) chops off the left most bits that we are
        ; shifting into so we do not get an overflow error when we do the
        ; multiplication/shift
        Return (BitAND($lValue, $m_lOnBits[31 - $iShiftBits]) * _
            $m_l2Power[$iShiftBits])
        
    Endif
EndFunc

;*******************************************************************************
; RShift (FUNCTION)
;
; PARAMETERS:
; (In) - $lValue     - Long    - The value to be shifted
; (In) - $iShiftBits - Integer - The number of bits to shift the value by
;
; RETURN VALUE:
; Long - The shifted long integer
;
; DESCRIPTION:
; The right shift of an unsigned long integer involves shifting all the set bits
; to the right and in-filling on the left with zeros. This function is
; equivalent to the >>> operator in Java or the >> operator in C++ when used on
; an unsigned long.
;*******************************************************************************
Func RShift($lValue, $iShiftBits)
    
	Local $RShift
	
    ; NOTE: If you can guarantee that the Shift parameter will be in the
    ; range 1 to 30 you can safely strip of this first nested if structure for
    ; speed.
    ;
    ; A shift of zero is no shift at all
    If $iShiftBits = 0 Then
        Return $lValue
        
    ; A shift of 31 will clear all bits and move the left most bit to the right
    ; most bit position
    ElseIf $iShiftBits = 31 Then
        If BitAND($lValue, 0x80000000) Then
            Return 1
        Else
            Return 0
        Endif
        
    ; A shift of less than zero or more than 31 is undefined
    ElseIf $iShiftBits < 0 Or $iShiftBits > 31 Then
        SetError(6)
    Endif
    
    ; We do not care about the top most bit or the final bit, the top most bit
    ; will be taken into account in the next stage, the final bit (whether it
    ; is an odd number or not) is being shifted into, so we do not give a jot
    ; about it
    $RShift = int(BitAND($lValue, 0x7FFFFFFE) / $m_l2Power[$iShiftBits])
    
    ; If the top most bit (0x80000000) was set we need to do things differently
    ; as in a normal VB signed long integer the top most bit is used to indicate
    ; the sign of the number, when it is set it is a negative number, so just
    ; deviding by a factor of 2 as above would not work.
    ; NOTE: (lValue And  0x80000000) is equivalent to (lValue < 0], you could
    ; get a very marginal speed improvement by changing the test to (lValue < 0)
    If BitAND($lValue, 0x80000000) Then
        ; We take the value computed so far, and then add the left most negative
        ; bit after it has been shifted to the right the appropriate number of
        ; places
        $RShift = int(BitOR($RShift, (0x40000000 / $m_l2Power[$iShiftBits - 1])))
    Endif
	
	Return $RShift
	
EndFunc

;*******************************************************************************
; RShiftSigned (FUNCTION)
;
; PARAMETERS:
; (In) - $lValue     - Long    -
; (In) - $iShiftBits - Integer -
;
; RETURN VALUE:
; Long -
;
; DESCRIPTION:
; The right shift of a signed long integer involves shifting all the set bits to
; the right and in-filling on the left with the sign bit (0 if positive, 1 if
; negative. This function is equivalent to the >> operator in Java or the >>
; operator in C++ when used on a signed long integer. Not used in this class,
; but included for completeness.
;*******************************************************************************
Func RShiftSigned($lValue , $iShiftBits)
    
    ; NOTE: If you can guarantee that the Shift parameter will be in the
    ; range 1 to 30 you can safely strip of this first nested if structure for
    ; speed.
    ;
    ; A shift of zero is no shift at all
    If $iShiftBits = 0 Then
        Return $lValue
    
    ; A shift of 31 will clear all bits if the left most bit was zero, and will
    ; set all bits if the left most bit was 1 (a negative indicator)
    ElseIf $iShiftBits = 31 Then
        
        ; NOTE: (lValue And  0x80000000) is equivalent to (lValue < 0), you
        ; could get a very marginal speed improvement by changing the test to
        ; (lValue < 0)
        If BitAND($lValue, 0x80000000) Then
            Return -1
        Else
            Return 0
        Endif
    
    ; A shift of less than zero or more than 31 is undefined
    ElseIf $iShiftBits < 0 Or $iShiftBits > 31 Then
        SetError(6)
    Endif
    
    ; We get the same result by dividing by the appropriate power of 2 and
    ; rounding in the negative direction
    Return Int($lValue / $m_l2Power[$iShiftBits])
EndFunc

;*******************************************************************************
; RotateLeft (FUNCTION)
;
; PARAMETERS:
; (In) - $lValue     - Long    - Value to act on
; (In) - $iShiftBits - Integer - Bits to move by
;
; RETURN VALUE:
; Long - Result
;
; DESCRIPTION:
; Rotates the bits in a long integer to the left, those bits falling off the
; left edge are put back on the right edge
;*******************************************************************************
Func RotateLeft($lValue , $iShiftBits)
    Return BitOR(LShift($lValue, $iShiftBits), RShift($lValue, (32 - $iShiftBits)))
EndFunc

;*******************************************************************************
; AddUnsigned (FUNCTION)
;
; PARAMETERS:
; (In) - $lX - Long - First value
; (In) - $lY - Long - Second value
;
; RETURN VALUE:
; Long - Result
;
; DESCRIPTION:
; Adds two potentially large unsigned numbers without overflowing
;*******************************************************************************
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

;*******************************************************************************
; F (FUNCTION)
;
; DESCRIPTION:
; MD5's F function
;*******************************************************************************
Func F($x , $y , $z )
    Return BitOR(BitAND($x, $y) , BitAND((BitNOT($x)), $z))
EndFunc

;*******************************************************************************
; G (FUNCTION)
;
; DESCRIPTION:
; MD5's G function
;*******************************************************************************
Func G($x , $y , $z )
    Return BitOR(BitAND($x, $z) , BitAND($y , (BitNOT($z))))
EndFunc

;*******************************************************************************
; H (FUNCTION)
;
; DESCRIPTION:
; MD5's H function
;*******************************************************************************
Func H($x , $y , $z )
    Return BitXOR($x , $y , $z)
EndFunc

;*******************************************************************************
; I (FUNCTION)
;
; DESCRIPTION:
; MD5's I function
;*******************************************************************************
Func I($x , $y , $z )
    Return BitXOR($y , BitOR($x , (BitNOT($z))))
EndFunc

;*******************************************************************************
; FF (Func)
;
; DESCRIPTION:
; MD5's FF procedure
;*******************************************************************************
Func FF(ByRef $a , $b , $c , $d , $x , $s , $ac )
    $a = AddUnsigned($a, AddUnsigned(AddUnsigned(F($b, $c, $d), $x), $ac))
    $a = RotateLeft($a, $s)
    $a = AddUnsigned($a, $b)
EndFunc

;*******************************************************************************
; GG (Func)
;
; DESCRIPTION:
; MD5's GG procedure
;*******************************************************************************
Func GG(ByRef $a , $b , $c , $d , $x , $s , $ac )
    $a = AddUnsigned($a, AddUnsigned(AddUnsigned(G($b, $c, $d), $x), $ac))
    $a = RotateLeft($a, $s)
    $a = AddUnsigned($a, $b)
EndFunc

;*******************************************************************************
; HH (Func)
;
; DESCRIPTION:
; MD5's HH procedure
;*******************************************************************************
Func HH(ByRef $a , $b , $c , $d , $x , $s , $ac )
    $a = AddUnsigned($a, AddUnsigned(AddUnsigned(H($b, $c, $d), $x), $ac))
    $a = RotateLeft($a, $s)
    $a = AddUnsigned($a, $b)
EndFunc

;*******************************************************************************
; II (Func)
;
; DESCRIPTION:
; MD5's II procedure
;*******************************************************************************
Func II(ByRef $a , $b , $c , $d , $x , $s , $ac )
    $a = AddUnsigned($a, AddUnsigned(AddUnsigned(I($b, $c, $d), $x), $ac))
    $a = RotateLeft($a, $s)
    $a = AddUnsigned($a, $b)
EndFunc

;*******************************************************************************
; ConvertToWordArray (FUNCTION)
;
; PARAMETERS:
; (In/Out) - $sMessage - String - String message
;
; RETURN VALUE:
; Long() - Converted message as long array
;
; DESCRIPTION:
; Takes the string message and puts it in a long array with padding according to
; the MD5 rules.
;*******************************************************************************
Func ConvertToWordArray($sMessage )
    Dim $lWordArray[1]
    
    Const $MODULUS_BITS     = 512
    Const $CONGRUENT_BITS   = 448
    
    $lMessageLength = StringLen($sMessage)
    
    ; Get padded number of words. Message needs to be congruent to 448 bits,
    ; modulo 512 bits. If it is exactly congruent to 448 bits, modulo 512 bits
    ; it must still have another 512 bits added. 512 bits = 64 bytes
    ; (or 16 * 4 byte words), 448 bits = 56 bytes. This means lMessageSize must
    ; be a multiple of 16 (i.e. 16 * 4 (bytes) * 8 (bits))
    $lNumberOfWords = (int(($lMessageLength + _
        int(($MODULUS_BITS - $CONGRUENT_BITS) / $BITS_TO_A_BYTE)) / _
        int($MODULUS_BITS / $BITS_TO_A_BYTE)) + 1) * _
        int($MODULUS_BITS / $BITS_TO_A_WORD)
    ReDim $lWordArray[$lNumberOfWords]
    
    ; Combine each block of 4 bytes (ascii code of character) into one long
    ; value and store in the message. The high-order (most significant) bit of
    ; each byte is listed first. However, the low-order (least significant) byte
    ; is given first in each word.
    $lBytePosition = 0
    $lByteCount = 0
    Do 
        ; Each word is 4 bytes
        $lWordCount = int($lByteCount / $BYTES_TO_A_WORD)
        
        ; The bytes are put in the word from the right most edge
        $lBytePosition = (Mod($lByteCount , $BYTES_TO_A_WORD)) * $BITS_TO_A_BYTE
        $lWordArray[$lWordCount] = BitOR($lWordArray[$lWordCount] , _
            LShift(Asc(StringMid($sMessage, $lByteCount + 1, 1)), $lBytePosition))
        $lByteCount = $lByteCount + 1
    Until $lByteCount >= $lMessageLength

    ; Terminate according to MD5 rules with a 1 bit, zeros and the length in
    ; bits stored in the last two words
    $lWordCount = int($lByteCount / $BYTES_TO_A_WORD)
    $lBytePosition = (Mod($lByteCount , $BYTES_TO_A_WORD)) * $BITS_TO_A_BYTE

    ; Add a terminating 1 bit, all the rest of the bits to the end of the
    ; word array will default to zero
    $lWordArray[$lWordCount] = BitOR($lWordArray[$lWordCount] , _
        LShift(0x80, $lBytePosition))

    ; We put the length of the message in bits into the last two words, to get
    ; the length in bits we need to multiply by 8 (or left shift 3). This left
    ; shifted value is put in the first word. Any bits shifted off the left edge
    ; need to be put in the second word, we can work out which bits by shifting
    ; right the length by 29 bits.
    $lWordArray[$lNumberOfWords - 2] = LShift($lMessageLength, 3)
    $lWordArray[$lNumberOfWords - 1] = RShift($lMessageLength, 29)
    
    Return $lWordArray
EndFunc

;*******************************************************************************
; 