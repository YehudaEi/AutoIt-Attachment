$code = "Private Const BITS_TO_A_BYTE = 8" & @CrLf
$code = $code & "Private Const BYTES_TO_A_WORD = 4" & @CrLf
$code = $code & "Private Const BITS_TO_A_WORD = 32" & @CrLf
$code = $code & "Private m_lOnBits(30)" & @CrLf
$code = $code & "Private m_l2Power(30)" & @CrLf
$code = $code & "     m_lOnBits(0) = CLng(1)" & @CrLf
$code = $code & "    m_lOnBits(1) = CLng(3)" & @CrLf
$code = $code & "    m_lOnBits(2) = CLng(7)" & @CrLf
$code = $code & "    m_lOnBits(3) = CLng(15)" & @CrLf
$code = $code & "    m_lOnBits(4) = CLng(31)" & @CrLf
$code = $code & "    m_lOnBits(5) = CLng(63)" & @CrLf
$code = $code & "    m_lOnBits(6) = CLng(127)" & @CrLf
$code = $code & "    m_lOnBits(7) = CLng(255)" & @CrLf
$code = $code & "    m_lOnBits(8) = CLng(511)" & @CrLf
$code = $code & "    m_lOnBits(9) = CLng(1023)" & @CrLf
$code = $code & "    m_lOnBits(10) = CLng(2047)" & @CrLf
$code = $code & "    m_lOnBits(11) = CLng(4095)" & @CrLf
$code = $code & "    m_lOnBits(12) = CLng(8191)" & @CrLf
$code = $code & "    m_lOnBits(13) = CLng(16383)" & @CrLf
$code = $code & "    m_lOnBits(14) = CLng(32767)" & @CrLf
$code = $code & "    m_lOnBits(15) = CLng(65535)" & @CrLf
$code = $code & "    m_lOnBits(16) = CLng(131071)" & @CrLf
$code = $code & "    m_lOnBits(17) = CLng(262143)" & @CrLf
$code = $code & "    m_lOnBits(18) = CLng(524287)" & @CrLf
$code = $code & "    m_lOnBits(19) = CLng(1048575)" & @CrLf
$code = $code & "    m_lOnBits(20) = CLng(2097151)" & @CrLf
$code = $code & "    m_lOnBits(21) = CLng(4194303)" & @CrLf
$code = $code & "    m_lOnBits(22) = CLng(8388607)" & @CrLf
$code = $code & "    m_lOnBits(23) = CLng(16777215)" & @CrLf
$code = $code & "    m_lOnBits(24) = CLng(33554431)" & @CrLf
$code = $code & "    m_lOnBits(25) = CLng(67108863)" & @CrLf
$code = $code & "    m_lOnBits(26) = CLng(134217727)" & @CrLf
$code = $code & "    m_lOnBits(27) = CLng(268435455)" & @CrLf
$code = $code & "    m_lOnBits(28) = CLng(536870911)" & @CrLf
$code = $code & "    m_lOnBits(29) = CLng(1073741823)" & @CrLf
$code = $code & "    m_lOnBits(30) = CLng(2147483647)" & @CrLf
$code = $code & "    m_l2Power(0) = CLng(1)" & @CrLf
$code = $code & "    m_l2Power(1) = CLng(2)" & @CrLf
$code = $code & "    m_l2Power(2) = CLng(4)" & @CrLf
$code = $code & "    m_l2Power(3) = CLng(8)" & @CrLf
$code = $code & "    m_l2Power(4) = CLng(16)" & @CrLf
$code = $code & "    m_l2Power(5) = CLng(32)" & @CrLf
$code = $code & "    m_l2Power(6) = CLng(64)" & @CrLf
$code = $code & "    m_l2Power(7) = CLng(128)" & @CrLf
$code = $code & "    m_l2Power(8) = CLng(256)" & @CrLf
$code = $code & "    m_l2Power(9) = CLng(512)" & @CrLf
$code = $code & "    m_l2Power(10) = CLng(1024)" & @CrLf
$code = $code & "    m_l2Power(11) = CLng(2048)" & @CrLf
$code = $code & "    m_l2Power(12) = CLng(4096)" & @CrLf
$code = $code & "    m_l2Power(13) = CLng(8192)" & @CrLf
$code = $code & "    m_l2Power(14) = CLng(16384)" & @CrLf
$code = $code & "    m_l2Power(15) = CLng(32768)" & @CrLf
$code = $code & "    m_l2Power(16) = CLng(65536)" & @CrLf
$code = $code & "    m_l2Power(17) = CLng(131072)" & @CrLf
$code = $code & "    m_l2Power(18) = CLng(262144)" & @CrLf
$code = $code & "    m_l2Power(19) = CLng(524288)" & @CrLf
$code = $code & "    m_l2Power(20) = CLng(1048576)" & @CrLf
$code = $code & "    m_l2Power(21) = CLng(2097152)" & @CrLf
$code = $code & "    m_l2Power(22) = CLng(4194304)" & @CrLf
$code = $code & "    m_l2Power(23) = CLng(8388608)" & @CrLf
$code = $code & "    m_l2Power(24) = CLng(16777216)" & @CrLf
$code = $code & "    m_l2Power(25) = CLng(33554432)" & @CrLf
$code = $code & "    m_l2Power(26) = CLng(67108864)" & @CrLf
$code = $code & "    m_l2Power(27) = CLng(134217728)" & @CrLf
$code = $code & "    m_l2Power(28) = CLng(268435456)" & @CrLf
$code = $code & "    m_l2Power(29) = CLng(536870912)" & @CrLf
$code = $code & "    m_l2Power(30) = CLng(1073741824)" & @CrLf
$code = $code & "Private Function LShift(lValue, iShiftBits)" & @CrLf
$code = $code & "    If iShiftBits = 0 Then" & @CrLf
$code = $code & "        LShift = lValue" & @CrLf
$code = $code & "        Exit Function" & @CrLf
$code = $code & "    ElseIf iShiftBits = 31 Then" & @CrLf
$code = $code & "        If lValue And 1 Then" & @CrLf
$code = $code & "            LShift = &H80000000" & @CrLf
$code = $code & "        Else" & @CrLf
$code = $code & "            LShift = 0" & @CrLf
$code = $code & "        End If" & @CrLf
$code = $code & "        Exit Function" & @CrLf
$code = $code & "    ElseIf iShiftBits < 0 Or iShiftBits > 31 Then" & @CrLf
$code = $code & "        Err.Raise 6" & @CrLf
$code = $code & "    End If" & @CrLf
$code = $code & "    If (lValue And m_l2Power(31 - iShiftBits)) Then" & @CrLf
$code = $code & "        LShift = ((lValue And m_lOnBits(31 - (iShiftBits + 1))) * m_l2Power(iShiftBits)) Or &H80000000" & @CrLf
$code = $code & "    Else" & @CrLf
$code = $code & "        LShift = ((lValue And m_lOnBits(31 - iShiftBits)) * m_l2Power(iShiftBits))" & @CrLf
$code = $code & "    End If" & @CrLf
$code = $code & "End Function" & @CrLf
$code = $code & "Private Function RShift(lValue, iShiftBits)" & @CrLf
$code = $code & "    If iShiftBits = 0 Then" & @CrLf
$code = $code & "        RShift = lValue" & @CrLf
$code = $code & "        Exit Function" & @CrLf
$code = $code & "    ElseIf iShiftBits = 31 Then" & @CrLf
$code = $code & "        If lValue And &H80000000 Then" & @CrLf
$code = $code & "            RShift = 1" & @CrLf
$code = $code & "        Else" & @CrLf
$code = $code & "            RShift = 0" & @CrLf
$code = $code & "        End If" & @CrLf
$code = $code & "        Exit Function" & @CrLf
$code = $code & "    ElseIf iShiftBits < 0 Or iShiftBits > 31 Then" & @CrLf
$code = $code & "        Err.Raise 6" & @CrLf
$code = $code & "    End If" & @CrLf
$code = $code & "    RShift = (lValue And &H7FFFFFFE) \ m_l2Power(iShiftBits)" & @CrLf
$code = $code & "    If (lValue And &H80000000) Then" & @CrLf
$code = $code & "        RShift = (RShift Or (&H40000000 \ m_l2Power(iShiftBits - 1)))" & @CrLf
$code = $code & "    End If" & @CrLf
$code = $code & "End Function" & @CrLf
$code = $code & "Private Function RotateLeft(lValue, iShiftBits)" & @CrLf
$code = $code & "    RotateLeft = LShift(lValue, iShiftBits) Or RShift(lValue, (32 - iShiftBits))" & @CrLf
$code = $code & "End Function" & @CrLf
$code = $code & "Private Function AddUnsigned(lX, lY)" & @CrLf
$code = $code & "    Dim lX4" & @CrLf
$code = $code & "    Dim lY4" & @CrLf
$code = $code & "    Dim lX8" & @CrLf
$code = $code & "    Dim lY8" & @CrLf
$code = $code & "    Dim lResult" & @CrLf
$code = $code & "    lX8 = lX And &H80000000" & @CrLf
$code = $code & "    lY8 = lY And &H80000000" & @CrLf
$code = $code & "    lX4 = lX And &H40000000" & @CrLf
$code = $code & "    lY4 = lY And &H40000000" & @CrLf
$code = $code & "	lResult = (lX And &H3FFFFFFF) + (lY And &H3FFFFFFF)" & @CrLf
$code = $code & "    If lX4 And lY4 Then" & @CrLf
$code = $code & "        lResult = lResult Xor &H80000000 Xor lX8 Xor lY8" & @CrLf
$code = $code & "    ElseIf lX4 Or lY4 Then" & @CrLf
$code = $code & "        If lResult And &H40000000 Then" & @CrLf
$code = $code & "            lResult = lResult Xor &HC0000000 Xor lX8 Xor lY8" & @CrLf
$code = $code & "        Else" & @CrLf
$code = $code & "            lResult = lResult Xor &H40000000 Xor lX8 Xor lY8" & @CrLf
$code = $code & "        End If" & @CrLf
$code = $code & "    Else" & @CrLf
$code = $code & "        lResult = lResult Xor lX8 Xor lY8" & @CrLf
$code = $code & "    End If" & @CrLf
$code = $code & "    AddUnsigned = lResult" & @CrLf
$code = $code & "End Function" & @CrLf
$code = $code & "Private Function F(x, y, z)" & @CrLf
$code = $code & "    F = (x And y) Or ((Not x) And z)" & @CrLf
$code = $code & "End Function" & @CrLf
$code = $code & "Private Function G(x, y, z)" & @CrLf
$code = $code & "    G = (x And z) Or (y And (Not z))" & @CrLf
$code = $code & "End Function" & @CrLf
$code = $code & "Private Function H(x, y, z)" & @CrLf
$code = $code & "    H = (x Xor y Xor z)" & @CrLf
$code = $code & "End Function" & @CrLf
$code = $code & "Private Function I(x, y, z)" & @CrLf
$code = $code & "    I = (y Xor (x Or (Not z)))" & @CrLf
$code = $code & "End Function" & @CrLf
$code = $code & "Private Sub FF(a, b, c, d, x, s, ac)" & @CrLf
$code = $code & "    a = AddUnsigned(a, AddUnsigned(AddUnsigned(F(b, c, d), x), ac))" & @CrLf
$code = $code & "    a = RotateLeft(a, s)" & @CrLf
$code = $code & "    a = AddUnsigned(a, b)" & @CrLf
$code = $code & "End Sub" & @CrLf
$code = $code & "Private Sub GG(a, b, c, d, x, s, ac)" & @CrLf
$code = $code & "    a = AddUnsigned(a, AddUnsigned(AddUnsigned(G(b, c, d), x), ac))" & @CrLf
$code = $code & "    a = RotateLeft(a, s)" & @CrLf
$code = $code & "    a = AddUnsigned(a, b)" & @CrLf
$code = $code & "End Sub" & @CrLf
$code = $code & "Private Sub HH(a, b, c, d, x, s, ac)" & @CrLf
$code = $code & "    a = AddUnsigned(a, AddUnsigned(AddUnsigned(H(b, c, d), x), ac))" & @CrLf
$code = $code & "    a = RotateLeft(a, s)" & @CrLf
$code = $code & "    a = AddUnsigned(a, b)" & @CrLf
$code = $code & "End Sub" & @CrLf
$code = $code & "Private Sub II(a, b, c, d, x, s, ac)" & @CrLf
$code = $code & "    a = AddUnsigned(a, AddUnsigned(AddUnsigned(I(b, c, d), x), ac))" & @CrLf
$code = $code & "    a = RotateLeft(a, s)" & @CrLf
$code = $code & "    a = AddUnsigned(a, b)" & @CrLf
$code = $code & "End Sub" & @CrLf
$code = $code & "Private Function ConvertToWordArray(sMessage)" & @CrLf
$code = $code & "    Dim lMessageLength" & @CrLf
$code = $code & "    Dim lNumberOfWords" & @CrLf
$code = $code & "    Dim lWordArray()" & @CrLf
$code = $code & "    Dim lBytePosition" & @CrLf
$code = $code & "    Dim lByteCount" & @CrLf
$code = $code & "    Dim lWordCount" & @CrLf
$code = $code & "    Const MODULUS_BITS = 512" & @CrLf
$code = $code & "    Const CONGRUENT_BITS = 448" & @CrLf
$code = $code & "    lMessageLength = Len(sMessage)" & @CrLf
$code = $code & "    lNumberOfWords = (((lMessageLength + ((MODULUS_BITS - CONGRUENT_BITS) \ BITS_TO_A_BYTE)) \ (MODULUS_BITS \ BITS_TO_A_BYTE)) + 1) * (MODULUS_BITS \ BITS_TO_A_WORD)" & @CrLf
$code = $code & "    ReDim lWordArray(lNumberOfWords - 1)" & @CrLf
$code = $code & "    lBytePosition = 0" & @CrLf
$code = $code & "    lByteCount = 0" & @CrLf
$code = $code & "    Do Until lByteCount >= lMessageLength" & @CrLf
$code = $code & "        lWordCount = lByteCount \ BYTES_TO_A_WORD" & @CrLf
$code = $code & "        lBytePosition = (lByteCount Mod BYTES_TO_A_WORD) * BITS_TO_A_BYTE" & @CrLf
$code = $code & "        lWordArray(lWordCount) = lWordArray(lWordCount) Or LShift(Asc(Mid(sMessage, lByteCount + 1, 1)), lBytePosition)" & @CrLf
$code = $code & "        lByteCount = lByteCount + 1" & @CrLf
$code = $code & "    Loop" & @CrLf
$code = $code & "    lWordCount = lByteCount \ BYTES_TO_A_WORD" & @CrLf
$code = $code & "    lBytePosition = (lByteCount Mod BYTES_TO_A_WORD) * BITS_TO_A_BYTE" & @CrLf
$code = $code & "    lWordArray(lWordCount) = lWordArray(lWordCount) Or LShift(&H80, lBytePosition)" & @CrLf
$code = $code & "    lWordArray(lNumberOfWords - 2) = LShift(lMessageLength, 3)" & @CrLf
$code = $code & "    lWordArray(lNumberOfWords - 1) = RShift(lMessageLength, 29)" & @CrLf
$code = $code & "    ConvertToWordArray = lWordArray" & @CrLf
$code = $code & "End Function" & @CrLf
$code = $code & "Private Function WordToHex(lValue)" & @CrLf
$code = $code & "    Dim lByte" & @CrLf
$code = $code & "    Dim lCount" & @CrLf
$code = $code & "    For lCount = 0 To 3" & @CrLf
$code = $code & "        lByte = RShift(lValue, lCount * BITS_TO_A_BYTE) And m_lOnBits(BITS_TO_A_BYTE - 1)" & @CrLf
$code = $code & "        WordToHex = WordToHex & Right(" & '"' & "0" & '"' & " & Hex(lByte), 2)" & @CrLf
$code = $code & "    Next" & @CrLf
$code = $code & "End Function" & @CrLf
$code = $code & "Public Function MD5(sMessage)" & @CrLf
$code = $code & "    Dim x" & @CrLf
$code = $code & "    Dim k" & @CrLf
$code = $code & "    Dim AA" & @CrLf
$code = $code & "    Dim BB" & @CrLf
$code = $code & "    Dim CC" & @CrLf
$code = $code & "    Dim DD" & @CrLf
$code = $code & "    Dim a" & @CrLf
$code = $code & "    Dim b" & @CrLf
$code = $code & "    Dim c" & @CrLf
$code = $code & "    Dim d" & @CrLf
$code = $code & "	Const S11 = 7" & @CrLf
$code = $code & "    Const S12 = 12" & @CrLf
$code = $code & "    Const S13 = 17" & @CrLf
$code = $code & "    Const S14 = 22" & @CrLf
$code = $code & "    Const S21 = 5" & @CrLf
$code = $code & "    Const S22 = 9" & @CrLf
$code = $code & "    Const S23 = 14" & @CrLf
$code = $code & "    Const S24 = 20" & @CrLf
$code = $code & "    Const S31 = 4" & @CrLf
$code = $code & "    Const S32 = 11" & @CrLf
$code = $code & "    Const S33 = 16" & @CrLf
$code = $code & "    Const S34 = 23" & @CrLf
$code = $code & "    Const S41 = 6" & @CrLf
$code = $code & "    Const S42 = 10" & @CrLf
$code = $code & "    Const S43 = 15" & @CrLf
$code = $code & "    Const S44 = 21" & @CrLf
$code = $code & "    x = ConvertToWordArray(sMessage)" & @CrLf
$code = $code & "    a = &H67452301" & @CrLf
$code = $code & "    b = &HEFCDAB89" & @CrLf
$code = $code & "    c = &H98BADCFE" & @CrLf
$code = $code & "    d = &H10325476" & @CrLf
$code = $code & "    For k = 0 To UBound(x) Step 16" & @CrLf
$code = $code & "        AA = a" & @CrLf
$code = $code & "        BB = b" & @CrLf
$code = $code & "        CC = c" & @CrLf
$code = $code & "        DD = d" & @CrLf
$code = $code & "        FF a, b, c, d, x(k + 0), S11, &HD76AA478" & @CrLf
$code = $code & "        FF d, a, b, c, x(k + 1), S12, &HE8C7B756" & @CrLf
$code = $code & "        FF c, d, a, b, x(k + 2), S13, &H242070DB" & @CrLf
$code = $code & "        FF b, c, d, a, x(k + 3), S14, &HC1BDCEEE" & @CrLf
$code = $code & "        FF a, b, c, d, x(k + 4), S11, &HF57C0FAF" & @CrLf
$code = $code & "        FF d, a, b, c, x(k + 5), S12, &H4787C62A" & @CrLf
$code = $code & "        FF c, d, a, b, x(k + 6), S13, &HA8304613" & @CrLf
$code = $code & "        FF b, c, d, a, x(k + 7), S14, &HFD469501" & @CrLf
$code = $code & "        FF a, b, c, d, x(k + 8), S11, &H698098D8" & @CrLf
$code = $code & "        FF d, a, b, c, x(k + 9), S12, &H8B44F7AF" & @CrLf
$code = $code & "        FF c, d, a, b, x(k + 10), S13, &HFFFF5BB1" & @CrLf
$code = $code & "        FF b, c, d, a, x(k + 11), S14, &H895CD7BE" & @CrLf
$code = $code & "        FF a, b, c, d, x(k + 12), S11, &H6B901122" & @CrLf
$code = $code & "        FF d, a, b, c, x(k + 13), S12, &HFD987193" & @CrLf
$code = $code & "        FF c, d, a, b, x(k + 14), S13, &HA679438E" & @CrLf
$code = $code & "        FF b, c, d, a, x(k + 15), S14, &H49B40821" & @CrLf
$code = $code & "        GG a, b, c, d, x(k + 1), S21, &HF61E2562" & @CrLf
$code = $code & "        GG d, a, b, c, x(k + 6), S22, &HC040B340" & @CrLf
$code = $code & "        GG c, d, a, b, x(k + 11), S23, &H265E5A51" & @CrLf
$code = $code & "        GG b, c, d, a, x(k + 0), S24, &HE9B6C7AA" & @CrLf
$code = $code & "        GG a, b, c, d, x(k + 5), S21, &HD62F105D" & @CrLf
$code = $code & "        GG d, a, b, c, x(k + 10), S22, &H2441453" & @CrLf
$code = $code & "        GG c, d, a, b, x(k + 15), S23, &HD8A1E681" & @CrLf
$code = $code & "        GG b, c, d, a, x(k + 4), S24, &HE7D3FBC8" & @CrLf
$code = $code & "        GG a, b, c, d, x(k + 9), S21, &H21E1CDE6" & @CrLf
$code = $code & "        GG d, a, b, c, x(k + 14), S22, &HC33707D6" & @CrLf
$code = $code & "        GG c, d, a, b, x(k + 3), S23, &HF4D50D87" & @CrLf
$code = $code & "        GG b, c, d, a, x(k + 8), S24, &H455A14ED" & @CrLf
$code = $code & "        GG a, b, c, d, x(k + 13), S21, &HA9E3E905" & @CrLf
$code = $code & "        GG d, a, b, c, x(k + 2), S22, &HFCEFA3F8" & @CrLf
$code = $code & "        GG c, d, a, b, x(k + 7), S23, &H676F02D9" & @CrLf
$code = $code & "        GG b, c, d, a, x(k + 12), S24, &H8D2A4C8A" & @CrLf
$code = $code & "        HH a, b, c, d, x(k + 5), S31, &HFFFA3942" & @CrLf
$code = $code & "        HH d, a, b, c, x(k + 8), S32, &H8771F681" & @CrLf
$code = $code & "        HH c, d, a, b, x(k + 11), S33, &H6D9D6122" & @CrLf
$code = $code & "        HH b, c, d, a, x(k + 14), S34, &HFDE5380C" & @CrLf
$code = $code & "        HH a, b, c, d, x(k + 1), S31, &HA4BEEA44" & @CrLf
$code = $code & "        HH d, a, b, c, x(k + 4), S32, &H4BDECFA9" & @CrLf
$code = $code & "        HH c, d, a, b, x(k + 7), S33, &HF6BB4B60" & @CrLf
$code = $code & "        HH b, c, d, a, x(k + 10), S34, &HBEBFBC70" & @CrLf
$code = $code & "        HH a, b, c, d, x(k + 13), S31, &H289B7EC6" & @CrLf
$code = $code & "        HH d, a, b, c, x(k + 0), S32, &HEAA127FA" & @CrLf
$code = $code & "        HH c, d, a, b, x(k + 3), S33, &HD4EF3085" & @CrLf
$code = $code & "        HH b, c, d, a, x(k + 6), S34, &H4881D05" & @CrLf
$code = $code & "        HH a, b, c, d, x(k + 9), S31, &HD9D4D039" & @CrLf
$code = $code & "        HH d, a, b, c, x(k + 12), S32, &HE6DB99E5" & @CrLf
$code = $code & "        HH c, d, a, b, x(k + 15), S33, &H1FA27CF8" & @CrLf
$code = $code & "        HH b, c, d, a, x(k + 2), S34, &HC4AC5665" & @CrLf
$code = $code & "        II a, b, c, d, x(k + 0), S41, &HF4292244" & @CrLf
$code = $code & "        II d, a, b, c, x(k + 7), S42, &H432AFF97" & @CrLf
$code = $code & "        II c, d, a, b, x(k + 14), S43, &HAB9423A7" & @CrLf
$code = $code & "        II b, c, d, a, x(k + 5), S44, &HFC93A039" & @CrLf
$code = $code & "        II a, b, c, d, x(k + 12), S41, &H655B59C3" & @CrLf
$code = $code & "        II d, a, b, c, x(k + 3), S42, &H8F0CCC92" & @CrLf
$code = $code & "        II c, d, a, b, x(k + 10), S43, &HFFEFF47D" & @CrLf
$code = $code & "        II b, c, d, a, x(k + 1), S44, &H85845DD1" & @CrLf
$code = $code & "        II a, b, c, d, x(k + 8), S41, &H6FA87E4F" & @CrLf
$code = $code & "        II d, a, b, c, x(k + 15), S42, &HFE2CE6E0" & @CrLf
$code = $code & "        II c, d, a, b, x(k + 6), S43, &HA3014314" & @CrLf
$code = $code & "        II b, c, d, a, x(k + 13), S44, &H4E0811A1" & @CrLf
$code = $code & "        II a, b, c, d, x(k + 4), S41, &HF7537E82" & @CrLf
$code = $code & "        II d, a, b, c, x(k + 11), S42, &HBD3AF235" & @CrLf
$code = $code & "        II c, d, a, b, x(k + 2), S43, &H2AD7D2BB" & @CrLf
$code = $code & "        II b, c, d, a, x(k + 9), S44, &HEB86D391" & @CrLf
$code = $code & "        a = AddUnsigned(a, AA)" & @CrLf
$code = $code & "        b = AddUnsigned(b, BB)" & @CrLf
$code = $code & "        c = AddUnsigned(c, CC)" & @CrLf
$code = $code & "        d = AddUnsigned(d, DD)" & @CrLf
$code = $code & "    Next" & @CrLf
$code = $code & "    MD5 = LCase(WordToHex(a) & WordToHex(b) & WordToHex(c) & WordToHex(d))" & @CrLf
$code = $code & "End Function"

$oMD5 = ObjCreate("ScriptControl")
$oMD5.language="vbscript"
$oMD5.addcode($code)

Func _md5($szIn)
	Return $oMD5.run("MD5", $szIn)
EndFunc