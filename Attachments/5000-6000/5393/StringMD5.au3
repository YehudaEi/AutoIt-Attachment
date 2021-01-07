Func MD5_String($string)
	#region configure MD5 VB-Code ($VBCode)
		Local $VBCode = 'Private Const BITS_TO_A_BYTE = 8' & @CRLF
		$VBCode &= 'Private Const BYTES_TO_A_WORD = 4' & @CRLF
		$VBCode &= 'Private Const BITS_TO_A_WORD = 32' & @CRLF
		$VBCode &= '' & @CRLF
		$VBCode &= 'Private m_lOnBits(30)' & @CRLF
		$VBCode &= 'Private m_l2Power(30)' & @CRLF
		$VBCode &= ' ' & @CRLF
		$VBCode &= '    m_lOnBits(0) = CLng(1)' & @CRLF
		$VBCode &= '    m_lOnBits(1) = CLng(3)' & @CRLF
		$VBCode &= '    m_lOnBits(2) = CLng(7)' & @CRLF
		$VBCode &= '    m_lOnBits(3) = CLng(15)' & @CRLF
		$VBCode &= '    m_lOnBits(4) = CLng(31)' & @CRLF
		$VBCode &= '    m_lOnBits(5) = CLng(63)' & @CRLF
		$VBCode &= '    m_lOnBits(6) = CLng(127)' & @CRLF
		$VBCode &= '    m_lOnBits(7) = CLng(255)' & @CRLF
		$VBCode &= '    m_lOnBits(8) = CLng(511)' & @CRLF
		$VBCode &= '    m_lOnBits(9) = CLng(1023)' & @CRLF
		$VBCode &= '    m_lOnBits(10) = CLng(2047)' & @CRLF
		$VBCode &= '    m_lOnBits(11) = CLng(4095)' & @CRLF
		$VBCode &= '    m_lOnBits(12) = CLng(8191)' & @CRLF
		$VBCode &= '    m_lOnBits(13) = CLng(16383)' & @CRLF
		$VBCode &= '    m_lOnBits(14) = CLng(32767)' & @CRLF
		$VBCode &= '    m_lOnBits(15) = CLng(65535)' & @CRLF
		$VBCode &= '    m_lOnBits(16) = CLng(131071)' & @CRLF
		$VBCode &= '    m_lOnBits(17) = CLng(262143)' & @CRLF
		$VBCode &= '    m_lOnBits(18) = CLng(524287)' & @CRLF
		$VBCode &= '    m_lOnBits(19) = CLng(1048575)' & @CRLF
		$VBCode &= '    m_lOnBits(20) = CLng(2097151)' & @CRLF
		$VBCode &= '    m_lOnBits(21) = CLng(4194303)' & @CRLF
		$VBCode &= '    m_lOnBits(22) = CLng(8388607)' & @CRLF
		$VBCode &= '    m_lOnBits(23) = CLng(16777215)' & @CRLF
		$VBCode &= '    m_lOnBits(24) = CLng(33554431)' & @CRLF
		$VBCode &= '    m_lOnBits(25) = CLng(67108863)' & @CRLF
		$VBCode &= '    m_lOnBits(26) = CLng(134217727)' & @CRLF
		$VBCode &= '    m_lOnBits(27) = CLng(268435455)' & @CRLF
		$VBCode &= '    m_lOnBits(28) = CLng(536870911)' & @CRLF
		$VBCode &= '    m_lOnBits(29) = CLng(1073741823)' & @CRLF
		$VBCode &= '    m_lOnBits(30) = CLng(2147483647)' & @CRLF
		$VBCode &= '    ' & @CRLF
		$VBCode &= '    m_l2Power(0) = CLng(1)' & @CRLF
		$VBCode &= '    m_l2Power(1) = CLng(2)' & @CRLF
		$VBCode &= '    m_l2Power(2) = CLng(4)' & @CRLF
		$VBCode &= '    m_l2Power(3) = CLng(8)' & @CRLF
		$VBCode &= '    m_l2Power(4) = CLng(16)' & @CRLF
		$VBCode &= '    m_l2Power(5) = CLng(32)' & @CRLF
		$VBCode &= '    m_l2Power(6) = CLng(64)' & @CRLF
		$VBCode &= '    m_l2Power(7) = CLng(128)' & @CRLF
		$VBCode &= '    m_l2Power(8) = CLng(256)' & @CRLF
		$VBCode &= '    m_l2Power(9) = CLng(512)' & @CRLF
		$VBCode &= '    m_l2Power(10) = CLng(1024)' & @CRLF
		$VBCode &= '    m_l2Power(11) = CLng(2048)' & @CRLF
		$VBCode &= '    m_l2Power(12) = CLng(4096)' & @CRLF
		$VBCode &= '    m_l2Power(13) = CLng(8192)' & @CRLF
		$VBCode &= '    m_l2Power(14) = CLng(16384)' & @CRLF
		$VBCode &= '    m_l2Power(15) = CLng(32768)' & @CRLF
		$VBCode &= '    m_l2Power(16) = CLng(65536)' & @CRLF
		$VBCode &= '    m_l2Power(17) = CLng(131072)' & @CRLF
		$VBCode &= '    m_l2Power(18) = CLng(262144)' & @CRLF
		$VBCode &= '    m_l2Power(19) = CLng(524288)' & @CRLF
		$VBCode &= '    m_l2Power(20) = CLng(1048576)' & @CRLF
		$VBCode &= '    m_l2Power(21) = CLng(2097152)' & @CRLF
		$VBCode &= '    m_l2Power(22) = CLng(4194304)' & @CRLF
		$VBCode &= '    m_l2Power(23) = CLng(8388608)' & @CRLF
		$VBCode &= '    m_l2Power(24) = CLng(16777216)' & @CRLF
		$VBCode &= '    m_l2Power(25) = CLng(33554432)' & @CRLF
		$VBCode &= '    m_l2Power(26) = CLng(67108864)' & @CRLF
		$VBCode &= '    m_l2Power(27) = CLng(134217728)' & @CRLF
		$VBCode &= '    m_l2Power(28) = CLng(268435456)' & @CRLF
		$VBCode &= '    m_l2Power(29) = CLng(536870912)' & @CRLF
		$VBCode &= '    m_l2Power(30) = CLng(1073741824)' & @CRLF
		$VBCode &= '' & @CRLF
		$VBCode &= 'Private Function LShift(lValue, iShiftBits)' & @CRLF
		$VBCode &= '    If iShiftBits = 0 Then' & @CRLF
		$VBCode &= '        LShift = lValue' & @CRLF
		$VBCode &= '        Exit Function' & @CRLF
		$VBCode &= '    ElseIf iShiftBits = 31 Then' & @CRLF
		$VBCode &= '        If lValue And 1 Then' & @CRLF
		$VBCode &= '            LShift = &H80000000' & @CRLF
		$VBCode &= '        Else' & @CRLF
		$VBCode &= '            LShift = 0' & @CRLF
		$VBCode &= '        End If' & @CRLF
		$VBCode &= '        Exit Function' & @CRLF
		$VBCode &= '    ElseIf iShiftBits < 0 Or iShiftBits > 31 Then' & @CRLF
		$VBCode &= '        Err.Raise 6' & @CRLF
		$VBCode &= '    End If' & @CRLF
		$VBCode &= '' & @CRLF
		$VBCode &= '    If (lValue And m_l2Power(31 - iShiftBits)) Then' & @CRLF
		$VBCode &= '        LShift = ((lValue And m_lOnBits(31 - (iShiftBits + 1))) * m_l2Power(iShiftBits)) Or &H80000000' & @CRLF
		$VBCode &= '    Else' & @CRLF
		$VBCode &= '        LShift = ((lValue And m_lOnBits(31 - iShiftBits)) * m_l2Power(iShiftBits))' & @CRLF
		$VBCode &= '    End If' & @CRLF
		$VBCode &= 'End Function' & @CRLF
		$VBCode &= '' & @CRLF
		$VBCode &= 'Private Function RShift(lValue, iShiftBits)' & @CRLF
		$VBCode &= '    If iShiftBits = 0 Then' & @CRLF
		$VBCode &= '        RShift = lValue' & @CRLF
		$VBCode &= '        Exit Function' & @CRLF
		$VBCode &= '    ElseIf iShiftBits = 31 Then' & @CRLF
		$VBCode &= '        If lValue And &H80000000 Then' & @CRLF
		$VBCode &= '            RShift = 1' & @CRLF
		$VBCode &= '        Else' & @CRLF
		$VBCode &= '            RShift = 0' & @CRLF
		$VBCode &= '        End If' & @CRLF
		$VBCode &= '        Exit Function' & @CRLF
		$VBCode &= '    ElseIf iShiftBits < 0 Or iShiftBits > 31 Then' & @CRLF
		$VBCode &= '        Err.Raise 6' & @CRLF
		$VBCode &= '    End If' & @CRLF
		$VBCode &= '    ' & @CRLF
		$VBCode &= '    RShift = (lValue And &H7FFFFFFE) \ m_l2Power(iShiftBits)' & @CRLF
		$VBCode &= '' & @CRLF
		$VBCode &= '    If (lValue And &H80000000) Then' & @CRLF
		$VBCode &= '        RShift = (RShift Or (&H40000000 \ m_l2Power(iShiftBits - 1)))' & @CRLF
		$VBCode &= '    End If' & @CRLF
		$VBCode &= 'End Function' & @CRLF
		$VBCode &= '' & @CRLF
		$VBCode &= 'Private Function RotateLeft(lValue, iShiftBits)' & @CRLF
		$VBCode &= '    RotateLeft = LShift(lValue, iShiftBits) Or RShift(lValue, (32 - iShiftBits))' & @CRLF
		$VBCode &= 'End Function' & @CRLF
		$VBCode &= '' & @CRLF
		$VBCode &= 'Private Function AddUnsigned(lX, lY)' & @CRLF
		$VBCode &= '    Dim lX4' & @CRLF
		$VBCode &= '    Dim lY4' & @CRLF
		$VBCode &= '    Dim lX8' & @CRLF
		$VBCode &= '    Dim lY8' & @CRLF
		$VBCode &= '    Dim lResult' & @CRLF
		$VBCode &= ' ' & @CRLF
		$VBCode &= '    lX8 = lX And &H80000000' & @CRLF
		$VBCode &= '    lY8 = lY And &H80000000' & @CRLF
		$VBCode &= '    lX4 = lX And &H40000000' & @CRLF
		$VBCode &= '    lY4 = lY And &H40000000' & @CRLF
		$VBCode &= ' ' & @CRLF
		$VBCode &= '    lResult = (lX And &H3FFFFFFF) + (lY And &H3FFFFFFF)' & @CRLF
		$VBCode &= ' ' & @CRLF
		$VBCode &= '    If lX4 And lY4 Then' & @CRLF
		$VBCode &= '        lResult = lResult Xor &H80000000 Xor lX8 Xor lY8' & @CRLF
		$VBCode &= '    ElseIf lX4 Or lY4 Then' & @CRLF
		$VBCode &= '        If lResult And &H40000000 Then' & @CRLF
		$VBCode &= '            lResult = lResult Xor &HC0000000 Xor lX8 Xor lY8' & @CRLF
		$VBCode &= '        Else' & @CRLF
		$VBCode &= '            lResult = lResult Xor &H40000000 Xor lX8 Xor lY8' & @CRLF
		$VBCode &= '        End If' & @CRLF
		$VBCode &= '    Else' & @CRLF
		$VBCode &= '        lResult = lResult Xor lX8 Xor lY8' & @CRLF
		$VBCode &= '    End If' & @CRLF
		$VBCode &= ' ' & @CRLF
		$VBCode &= '    AddUnsigned = lResult' & @CRLF
		$VBCode &= 'End Function' & @CRLF
		$VBCode &= '' & @CRLF
		$VBCode &= 'Private Function F(x, y, z)' & @CRLF
		$VBCode &= '    F = (x And y) Or ((Not x) And z)' & @CRLF
		$VBCode &= 'End Function' & @CRLF
		$VBCode &= '' & @CRLF
		$VBCode &= 'Private Function G(x, y, z)' & @CRLF
		$VBCode &= '    G = (x And z) Or (y And (Not z))' & @CRLF
		$VBCode &= 'End Function' & @CRLF
		$VBCode &= '' & @CRLF
		$VBCode &= 'Private Function H(x, y, z)' & @CRLF
		$VBCode &= '    H = (x Xor y Xor z)' & @CRLF
		$VBCode &= 'End Function' & @CRLF
		$VBCode &= '' & @CRLF
		$VBCode &= 'Private Function I(x, y, z)' & @CRLF
		$VBCode &= '    I = (y Xor (x Or (Not z)))' & @CRLF
		$VBCode &= 'End Function' & @CRLF
		$VBCode &= '' & @CRLF
		$VBCode &= 'Private Sub FF(a, b, c, d, x, s, ac)' & @CRLF
		$VBCode &= '    a = AddUnsigned(a, AddUnsigned(AddUnsigned(F(b, c, d), x), ac))' & @CRLF
		$VBCode &= '    a = RotateLeft(a, s)' & @CRLF
		$VBCode &= '    a = AddUnsigned(a, b)' & @CRLF
		$VBCode &= 'End Sub' & @CRLF
		$VBCode &= '' & @CRLF
		$VBCode &= 'Private Sub GG(a, b, c, d, x, s, ac)' & @CRLF
		$VBCode &= '    a = AddUnsigned(a, AddUnsigned(AddUnsigned(G(b, c, d), x), ac))' & @CRLF
		$VBCode &= '    a = RotateLeft(a, s)' & @CRLF
		$VBCode &= '    a = AddUnsigned(a, b)' & @CRLF
		$VBCode &= 'End Sub' & @CRLF
		$VBCode &= '' & @CRLF
		$VBCode &= 'Private Sub HH(a, b, c, d, x, s, ac)' & @CRLF
		$VBCode &= '    a = AddUnsigned(a, AddUnsigned(AddUnsigned(H(b, c, d), x), ac))' & @CRLF
		$VBCode &= '    a = RotateLeft(a, s)' & @CRLF
		$VBCode &= '    a = AddUnsigned(a, b)' & @CRLF
		$VBCode &= 'End Sub' & @CRLF
		$VBCode &= '' & @CRLF
		$VBCode &= 'Private Sub II(a, b, c, d, x, s, ac)' & @CRLF
		$VBCode &= '    a = AddUnsigned(a, AddUnsigned(AddUnsigned(I(b, c, d), x), ac))' & @CRLF
		$VBCode &= '    a = RotateLeft(a, s)' & @CRLF
		$VBCode &= '    a = AddUnsigned(a, b)' & @CRLF
		$VBCode &= 'End Sub' & @CRLF
		$VBCode &= '' & @CRLF
		$VBCode &= 'Private Function ConvertToWordArray(sMessage)' & @CRLF
		$VBCode &= '    Dim lMessageLength' & @CRLF
		$VBCode &= '    Dim lNumberOfWords' & @CRLF
		$VBCode &= '    Dim lWordArray()' & @CRLF
		$VBCode &= '    Dim lBytePosition' & @CRLF
		$VBCode &= '    Dim lByteCount' & @CRLF
		$VBCode &= '    Dim lWordCount' & @CRLF
		$VBCode &= '    ' & @CRLF
		$VBCode &= '    Const MODULUS_BITS = 512' & @CRLF
		$VBCode &= '    Const CONGRUENT_BITS = 448' & @CRLF
		$VBCode &= '    ' & @CRLF
		$VBCode &= '    lMessageLength = Len(sMessage)' & @CRLF
		$VBCode &= '    ' & @CRLF
		$VBCode &= '    lNumberOfWords = (((lMessageLength + ((MODULUS_BITS - CONGRUENT_BITS) \ BITS_TO_A_BYTE)) \ (MODULUS_BITS \ BITS_TO_A_BYTE)) + 1) * (MODULUS_BITS \ BITS_TO_A_WORD)' & @CRLF
		$VBCode &= '    ReDim lWordArray(lNumberOfWords - 1)' & @CRLF
		$VBCode &= '    ' & @CRLF
		$VBCode &= '    lBytePosition = 0' & @CRLF
		$VBCode &= '    lByteCount = 0' & @CRLF
		$VBCode &= '    Do Until lByteCount >= lMessageLength' & @CRLF
		$VBCode &= '        lWordCount = lByteCount \ BYTES_TO_A_WORD' & @CRLF
		$VBCode &= '        lBytePosition = (lByteCount Mod BYTES_TO_A_WORD) * BITS_TO_A_BYTE' & @CRLF
		$VBCode &= '        lWordArray(lWordCount) = lWordArray(lWordCount) Or LShift(Asc(Mid(sMessage, lByteCount + 1, 1)), lBytePosition)' & @CRLF
		$VBCode &= '        lByteCount = lByteCount + 1' & @CRLF
		$VBCode &= '    Loop' & @CRLF
		$VBCode &= '' & @CRLF
		$VBCode &= '    lWordCount = lByteCount \ BYTES_TO_A_WORD' & @CRLF
		$VBCode &= '    lBytePosition = (lByteCount Mod BYTES_TO_A_WORD) * BITS_TO_A_BYTE' & @CRLF
		$VBCode &= '' & @CRLF
		$VBCode &= '    lWordArray(lWordCount) = lWordArray(lWordCount) Or LShift(&H80, lBytePosition)' & @CRLF
		$VBCode &= '' & @CRLF
		$VBCode &= '    lWordArray(lNumberOfWords - 2) = LShift(lMessageLength, 3)' & @CRLF
		$VBCode &= '    lWordArray(lNumberOfWords - 1) = RShift(lMessageLength, 29)' & @CRLF
		$VBCode &= '    ' & @CRLF
		$VBCode &= '    ConvertToWordArray = lWordArray' & @CRLF
		$VBCode &= 'End Function' & @CRLF
		$VBCode &= '' & @CRLF
		$VBCode &= 'Private Function WordToHex(lValue)' & @CRLF
		$VBCode &= '    Dim lByte' & @CRLF
		$VBCode &= '    Dim lCount' & @CRLF
		$VBCode &= '    ' & @CRLF
		$VBCode &= '    For lCount = 0 To 3' & @CRLF
		$VBCode &= '        lByte = RShift(lValue, lCount * BITS_TO_A_BYTE) And m_lOnBits(BITS_TO_A_BYTE - 1)' & @CRLF
		$VBCode &= '        WordToHex = WordToHex & Right("0" & Hex(lByte), 2)' & @CRLF
		$VBCode &= '    Next' & @CRLF
		$VBCode &= 'End Function' & @CRLF
		$VBCode &= '' & @CRLF
		$VBCode &= 'Public Function MD5(sMessage)' & @CRLF
		$VBCode &= '    Dim x' & @CRLF
		$VBCode &= '    Dim k' & @CRLF
		$VBCode &= '    Dim AA' & @CRLF
		$VBCode &= '    Dim BB' & @CRLF
		$VBCode &= '    Dim CC' & @CRLF
		$VBCode &= '    Dim DD' & @CRLF
		$VBCode &= '    Dim a' & @CRLF
		$VBCode &= '    Dim b' & @CRLF
		$VBCode &= '    Dim c' & @CRLF
		$VBCode &= '    Dim d' & @CRLF
		$VBCode &= '    ' & @CRLF
		$VBCode &= '    Const S11 = 7' & @CRLF
		$VBCode &= '    Const S12 = 12' & @CRLF
		$VBCode &= '    Const S13 = 17' & @CRLF
		$VBCode &= '    Const S14 = 22' & @CRLF
		$VBCode &= '    Const S21 = 5' & @CRLF
		$VBCode &= '    Const S22 = 9' & @CRLF
		$VBCode &= '    Const S23 = 14' & @CRLF
		$VBCode &= '    Const S24 = 20' & @CRLF
		$VBCode &= '    Const S31 = 4' & @CRLF
		$VBCode &= '    Const S32 = 11' & @CRLF
		$VBCode &= '    Const S33 = 16' & @CRLF
		$VBCode &= '    Const S34 = 23' & @CRLF
		$VBCode &= '    Const S41 = 6' & @CRLF
		$VBCode &= '    Const S42 = 10' & @CRLF
		$VBCode &= '    Const S43 = 15' & @CRLF
		$VBCode &= '    Const S44 = 21' & @CRLF
		$VBCode &= '' & @CRLF
		$VBCode &= '    x = ConvertToWordArray(sMessage)' & @CRLF
		$VBCode &= '    ' & @CRLF
		$VBCode &= '    a = &H67452301' & @CRLF
		$VBCode &= '    b = &HEFCDAB89' & @CRLF
		$VBCode &= '    c = &H98BADCFE' & @CRLF
		$VBCode &= '    d = &H10325476' & @CRLF
		$VBCode &= '' & @CRLF
		$VBCode &= '    For k = 0 To UBound(x) Step 16' & @CRLF
		$VBCode &= '        AA = a' & @CRLF
		$VBCode &= '        BB = b' & @CRLF
		$VBCode &= '        CC = c' & @CRLF
		$VBCode &= '        DD = d' & @CRLF
		$VBCode &= '    ' & @CRLF
		$VBCode &= '        FF a, b, c, d, x(k + 0), S11, &HD76AA478' & @CRLF
		$VBCode &= '        FF d, a, b, c, x(k + 1), S12, &HE8C7B756' & @CRLF
		$VBCode &= '        FF c, d, a, b, x(k + 2), S13, &H242070DB' & @CRLF
		$VBCode &= '        FF b, c, d, a, x(k + 3), S14, &HC1BDCEEE' & @CRLF
		$VBCode &= '        FF a, b, c, d, x(k + 4), S11, &HF57C0FAF' & @CRLF
		$VBCode &= '        FF d, a, b, c, x(k + 5), S12, &H4787C62A' & @CRLF
		$VBCode &= '        FF c, d, a, b, x(k + 6), S13, &HA8304613' & @CRLF
		$VBCode &= '        FF b, c, d, a, x(k + 7), S14, &HFD469501' & @CRLF
		$VBCode &= '        FF a, b, c, d, x(k + 8), S11, &H698098D8' & @CRLF
		$VBCode &= '        FF d, a, b, c, x(k + 9), S12, &H8B44F7AF' & @CRLF
		$VBCode &= '        FF c, d, a, b, x(k + 10), S13, &HFFFF5BB1' & @CRLF
		$VBCode &= '        FF b, c, d, a, x(k + 11), S14, &H895CD7BE' & @CRLF
		$VBCode &= '        FF a, b, c, d, x(k + 12), S11, &H6B901122' & @CRLF
		$VBCode &= '        FF d, a, b, c, x(k + 13), S12, &HFD987193' & @CRLF
		$VBCode &= '        FF c, d, a, b, x(k + 14), S13, &HA679438E' & @CRLF
		$VBCode &= '        FF b, c, d, a, x(k + 15), S14, &H49B40821' & @CRLF
		$VBCode &= '    ' & @CRLF
		$VBCode &= '        GG a, b, c, d, x(k + 1), S21, &HF61E2562' & @CRLF
		$VBCode &= '        GG d, a, b, c, x(k + 6), S22, &HC040B340' & @CRLF
		$VBCode &= '        GG c, d, a, b, x(k + 11), S23, &H265E5A51' & @CRLF
		$VBCode &= '        GG b, c, d, a, x(k + 0), S24, &HE9B6C7AA' & @CRLF
		$VBCode &= '        GG a, b, c, d, x(k + 5), S21, &HD62F105D' & @CRLF
		$VBCode &= '        GG d, a, b, c, x(k + 10), S22, &H2441453' & @CRLF
		$VBCode &= '        GG c, d, a, b, x(k + 15), S23, &HD8A1E681' & @CRLF
		$VBCode &= '        GG b, c, d, a, x(k + 4), S24, &HE7D3FBC8' & @CRLF
		$VBCode &= '        GG a, b, c, d, x(k + 9), S21, &H21E1CDE6' & @CRLF
		$VBCode &= '        GG d, a, b, c, x(k + 14), S22, &HC33707D6' & @CRLF
		$VBCode &= '        GG c, d, a, b, x(k + 3), S23, &HF4D50D87' & @CRLF
		$VBCode &= '        GG b, c, d, a, x(k + 8), S24, &H455A14ED' & @CRLF
		$VBCode &= '        GG a, b, c, d, x(k + 13), S21, &HA9E3E905' & @CRLF
		$VBCode &= '        GG d, a, b, c, x(k + 2), S22, &HFCEFA3F8' & @CRLF
		$VBCode &= '        GG c, d, a, b, x(k + 7), S23, &H676F02D9' & @CRLF
		$VBCode &= '        GG b, c, d, a, x(k + 12), S24, &H8D2A4C8A' & @CRLF
		$VBCode &= '            ' & @CRLF
		$VBCode &= '        HH a, b, c, d, x(k + 5), S31, &HFFFA3942' & @CRLF
		$VBCode &= '        HH d, a, b, c, x(k + 8), S32, &H8771F681' & @CRLF
		$VBCode &= '        HH c, d, a, b, x(k + 11), S33, &H6D9D6122' & @CRLF
		$VBCode &= '        HH b, c, d, a, x(k + 14), S34, &HFDE5380C' & @CRLF
		$VBCode &= '        HH a, b, c, d, x(k + 1), S31, &HA4BEEA44' & @CRLF
		$VBCode &= '        HH d, a, b, c, x(k + 4), S32, &H4BDECFA9' & @CRLF
		$VBCode &= '        HH c, d, a, b, x(k + 7), S33, &HF6BB4B60' & @CRLF
		$VBCode &= '        HH b, c, d, a, x(k + 10), S34, &HBEBFBC70' & @CRLF
		$VBCode &= '        HH a, b, c, d, x(k + 13), S31, &H289B7EC6' & @CRLF
		$VBCode &= '        HH d, a, b, c, x(k + 0), S32, &HEAA127FA' & @CRLF
		$VBCode &= '        HH c, d, a, b, x(k + 3), S33, &HD4EF3085' & @CRLF
		$VBCode &= '        HH b, c, d, a, x(k + 6), S34, &H4881D05' & @CRLF
		$VBCode &= '        HH a, b, c, d, x(k + 9), S31, &HD9D4D039' & @CRLF
		$VBCode &= '        HH d, a, b, c, x(k + 12), S32, &HE6DB99E5' & @CRLF
		$VBCode &= '        HH c, d, a, b, x(k + 15), S33, &H1FA27CF8' & @CRLF
		$VBCode &= '        HH b, c, d, a, x(k + 2), S34, &HC4AC5665' & @CRLF
		$VBCode &= '    ' & @CRLF
		$VBCode &= '        II a, b, c, d, x(k + 0), S41, &HF4292244' & @CRLF
		$VBCode &= '        II d, a, b, c, x(k + 7), S42, &H432AFF97' & @CRLF
		$VBCode &= '        II c, d, a, b, x(k + 14), S43, &HAB9423A7' & @CRLF
		$VBCode &= '        II b, c, d, a, x(k + 5), S44, &HFC93A039' & @CRLF
		$VBCode &= '        II a, b, c, d, x(k + 12), S41, &H655B59C3' & @CRLF
		$VBCode &= '        II d, a, b, c, x(k + 3), S42, &H8F0CCC92' & @CRLF
		$VBCode &= '        II c, d, a, b, x(k + 10), S43, &HFFEFF47D' & @CRLF
		$VBCode &= '        II b, c, d, a, x(k + 1), S44, &H85845DD1' & @CRLF
		$VBCode &= '        II a, b, c, d, x(k + 8), S41, &H6FA87E4F' & @CRLF
		$VBCode &= '        II d, a, b, c, x(k + 15), S42, &HFE2CE6E0' & @CRLF
		$VBCode &= '        II c, d, a, b, x(k + 6), S43, &HA3014314' & @CRLF
		$VBCode &= '        II b, c, d, a, x(k + 13), S44, &H4E0811A1' & @CRLF
		$VBCode &= '        II a, b, c, d, x(k + 4), S41, &HF7537E82' & @CRLF
		$VBCode &= '        II d, a, b, c, x(k + 11), S42, &HBD3AF235' & @CRLF
		$VBCode &= '        II c, d, a, b, x(k + 2), S43, &H2AD7D2BB' & @CRLF
		$VBCode &= '        II b, c, d, a, x(k + 9), S44, &HEB86D391' & @CRLF
		$VBCode &= '    ' & @CRLF
		$VBCode &= '        a = AddUnsigned(a, AA)' & @CRLF
		$VBCode &= '        b = AddUnsigned(b, BB)' & @CRLF
		$VBCode &= '        c = AddUnsigned(c, CC)' & @CRLF
		$VBCode &= '        d = AddUnsigned(d, DD)' & @CRLF
		$VBCode &= '    Next' & @CRLF
		$VBCode &= '    ' & @CRLF
		$VBCode &= '    MD5 = LCase(WordToHex(a) & WordToHex(b) & WordToHex(c) & WordToHex(d))' & @CRLF
		$VBCode &= 'End Function' & @CRLF
	#endregion
	Local $vbscript = ObjCreate('ScriptControl')
	$vbscript.language='vbscript'
	$vbscript.addcode($VBCode)
	Return $vbscript.run('MD5', $string)
EndFunc