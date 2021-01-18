Local $Message_Enc, $Message_Dec, $key, $message
$key = "8787878787878787"
$message = "This is a test message."
$Message_Enc = des($key, $message)
MsgBox(4096, "Encoded Message", $Message_Enc)
$Message_Dec = des($key, $Message_Enc, 1)
MsgBox(4096, "Decoded Message", $Message_Dec)

Func des_createkeys($key)
	Local $Odd_Parity[256] = [0x01, 0x01, 0x02, 0x02, 0x04, 0x04, 0x07, 0x07, 0x08, 0x08, 0x0B, 0x0B, 0x0D, 0x0D, 0x0E, 0x0E, 0x10, 0x10, 0x13, 0x13, 0x15, 0x15, 0x16, 0x16, 0x19, 0x19, 0x1A, 0x1A, 0x1C, 0x1C, 0x1F, 0x1F, 0x20, 0x20, 0x23, 0x23, 0x25, 0x25, 0x26, 0x26, 0x29, 0x29, 0x2A, 0x2A, 0x2C, 0x2C, 0x2F, 0x2F, 0x31, 0x31, 0x32, 0x32, 0x34, 0x34, 0x37, 0x37, 0x38, 0x38, 0x3B, 0x3B, 0x3D, 0x3D, 0x3E, 0x3E, 0x40, 0x40, 0x43, 0x43, 0x45, 0x45, 0x46, 0x46, 0x49, 0x49, _
			0x4A, 0x4A, 0x4C, 0x4C, 0x4F, 0x4F, 0x51, 0x51, 0x52, 0x52, 0x54, 0x54, 0x57, 0x57, 0x58, 0x58, 0x5B, 0x5B, 0x5D, 0x5D, 0x5E, 0x5E, 0x61, 0x61, 0x62, 0x62, 0x64, 0x64, 0x67, 0x67, 0x68, 0x68, 0x6B, 0x6B, 0x6D, 0x6D, 0x6E, 0x6E, 0x70, 0x70, 0x73, 0x73, 0x75, 0x75, 0x76, 0x76, 0x79, 0x79, 0x7A, 0x7A, 0x7C, 0x7C, 0x7F, 0x7F, 0x80, 0x80, 0x83, 0x83, 0x85, 0x85, 0x86, 0x86, 0x89, 0x89, 0x8A, 0x8A, 0x8C, 0x8C, 0x8F, 0x8F, 0x91, 0x91, 0x92, 0x92, 0x94, 0x94, 0x97, _
			0x97, 0x98, 0x98, 0x9B, 0x9B, 0x9D, 0x9D, 0x9E, 0x9E, 0xA1, 0xA1, 0xA2, 0xA2, 0xA4, 0xA4, 0xA7, 0xA7, 0xA8, 0xA8, 0xAB, 0xAB, 0xAD, 0xAD, 0xAE, 0xAE, 0xB0, 0xB0, 0xB3, 0xB3, 0xB5, 0xB5, 0xB6, 0xB6, 0xB9, 0xB9, 0xBA, 0xBA, 0xBC, 0xBC, 0xBF, 0xBF, 0xC1, 0xC1, 0xC2, 0xC2, 0xC4, 0xC4, 0xC7, 0xC7, 0xC8, 0xC8, 0xCB, 0xCB, 0xCD, 0xCD, 0xCE, 0xCE, 0xD0, 0xD0, 0xD3, 0xD3, 0xD5, 0xD5, 0xD6, 0xD6, 0xD9, 0xD9, 0xDA, 0xDA, 0xDC, 0xDC, 0xDF, 0xDF, 0xE0, 0xE0, 0xE3, 0xE3, _
			0xE5, 0xE5, 0xE6, 0xE6, 0xE9, 0xE9, 0xEA, 0xEA, 0xEC, 0xEC, 0xEF, 0xEF, 0xF1, 0xF1, 0xF2, 0xF2, 0xF4, 0xF4, 0xF7, 0xF7, 0xF8, 0xF8, 0xFB, 0xFB, 0xFD, 0xFD, 0xFE, 0xFE]
	Local $PC_1[56] = [57, 49, 41, 33, 25, 17, 9, 1, 58, 50, 42, 34, 26, 18, 10, 2, 59, 51, 43, 35, 27, 19, 11, 3, 60, 52, 44, 36, 63, 55, 47, 39, 31, 23, 15, 7, 62, 54, 46, 38, 30, 22, 14, 6, 61, 53, 45, 37, 29, 21, 13, 5, 28, 20, 12, 4]
	Local $shift[16] = [1, 1, 2, 2, 2, 2, 2, 2, 1, 2, 2, 2, 2, 2, 2, 1]
	Local $PC_2[48] = [14, 17, 11, 24, 1, 5, 3, 28, 15, 6, 21, 10, 23, 19, 12, 4, 26, 8, 16, 7, 27, 20, 13, 2, 41, 52, 31, 37, 47, 55, 30, 40, 51, 45, 33, 48, 44, 49, 39, 56, 34, 53, 46, 42, 50, 36, 29, 32]
	Local $k = "", $C[17], $D[17], $keys[16]
	$key = StringSplit(_HexToBin($key), "")
	For $i = 0 To 55
		$k &= $key[$PC_1[$i]]
	Next
	$C[0] = StringLeft($k, 28)
	$D[0] = StringRight($k, 28)
	For $i = 1 To 16
		$C[$i] = _RotateLeft($C[$i - 1], $shift[$i - 1])
		$D[$i] = _RotateLeft($D[$i - 1], $shift[$i - 1])
	Next
	For $i = 1 To 16
		$temp = StringSplit($C[$i] & $D[$i], "")
		For $j = 0 To 47
			$keys[$i - 1] &= $temp[$PC_2[$j]]
		Next
	Next
	
	Return $keys
EndFunc   ;==>des_createkeys

Func f($R, $k)
	Local $E_Table[48] = [32, 1, 2, 3, 4, 5, 4, 5, 6, 7, 8, 9, 8, 9, 10, 11, 12, 13, 12, 13, 14, 15, 16, 17, 16, 17, 18, 19, 20, 21, 20, 21, 22, 23, 24, 25, 24, 25, 26, 27, 28, 29, 28, 29, 30, 31, 32, 1]
	Local $P_Table[32] = [16, 7, 20, 21, 29, 12, 28, 17, 1, 15, 23, 26, 5, 18, 31, 10, 2, 8, 24, 14, 32, 27, 3, 9, 19, 13, 30, 6, 22, 11, 4, 25]
	Local $S_Table[8]
	$S_Table[0] = "E4D12FB83A6C59070F74E2D1A6CB953841E8D62BFC973A50FC8249175B3EA06D"
	$S_Table[1] = "F18E6B34972DC05A3D47F28EC01A69B50E7BA4D158C6932FD8A13F42B67C05E9"
	$S_Table[2] = "A09E63F51DC7B428D709346A285ECBF1D6498F30B12C5AE71AD069874FE3B52C"
	$S_Table[3] = "7DE3069A1285BC4FD8B56F03472C1AE9A690CB7DF13E52843F06A1D8945BC72E"
	$S_Table[4] = "2C417AB6853FD0E9EB2C47D150FA3986421BAD78F9C5630EB8C71E2D6F09A453"
	$S_Table[5] = "C1AF92680D34E75B0F427C9561DE0B389EF528C3704A1DB6432C95FABE17608D"
	$S_Table[6] = "4B2EF08D3C975A61D0B7491AE35C2F8614BDC37EAF6805926BD814A7950FE23C"
	$S_Table[7] = "D2846FB1A93E50C71FD8A374C56B0E927B419CE206ADF35821E74A8DFC90356B"
	
	Local $E, $KE, $S, $F
	Local $G, $row, $column
	Local $count = 0
	$R = StringSplit($R, "")
	For $i = 0 To 47
		$E &= $R[$E_Table[$i]]
	Next
	$KE = _XOR($E, $k)
	For $i = 1 To 48 Step 6
		$G = StringMid($KE, $i, 6)
		$row = _BinToDec(StringLeft($G, 1) & StringRight($G, 1))
		$column = _BinToDec(StringMid($G, 2, 4))
		$pos = (($row * 16) + $column) + 1
		$S &= _HexToBin(StringMid($S_Table[$count], $pos, 1))
		$count += 1
	Next
	$S = StringSplit($S, "")
	For $i = 0 To 31
		$F &= $S[$P_Table[$i]]
	Next
	Return $F
EndFunc   ;==>f

Func des($key, $message, $encrypt = 0)
	Local $IP_1[64] = [58, 50, 42, 34, 26, 18, 10, 2, 60, 52, 44, 36, 28, 20, 12, 4, 62, 54, 46, 38, 30, 22, 14, 6, 64, 56, 48, 40, 32, 24, 16, 8, 57, 49, 41, 33, 25, 17, 9, 1, 59, 51, 43, 35, 27, 19, 11, 3, 61, 53, 45, 37, 29, 21, 13, 5, 63, 55, 47, 39, 31, 23, 15, 7]
	Local $IP_2[64] = [40, 8, 48, 16, 56, 24, 64, 32, 39, 7, 47, 15, 55, 23, 63, 31, 38, 6, 46, 14, 54, 22, 62, 30, 37, 5, 45, 13, 53, 21, 61, 29, 36, 4, 44, 12, 52, 20, 60, 28, 35, 3, 43, 11, 51, 19, 59, 27, 34, 2, 42, 10, 50, 18, 58, 26, 33, 1, 41, 9, 49, 17, 57, 25]
	Local $mhex, $m[1] = [0]
	Local $ip, $L[17], $R[17]
	Local $RL, $enc, $enc_hex, $enc_message = "", $fill
	
	If StringLen($key) <> 16 Then
		SetError(1)
		Return 0
	EndIf
	
	$keys = des_createkeys($key)
	If $encrypt == 0 Then
		$fill = 8
		If Mod(StringLen($message), 8) <> 0 Then
			$fill = 8 - Mod(StringLen($message), 8)
		EndIf
		For $i = 1 To $fill
			$message &= Chr($fill)
		Next
	EndIf
	$message = StringSplit($message, "")
	For $i = 1 To $message[0]
		$mhex &= Hex(Asc($message[$i]), 2)
	Next
	While Mod(StringLen($mhex), 16) <> 0
		$mhex &= 0
	WEnd
	For $i = 1 To StringLen($mhex) Step 16
		ReDim $m[UBound($m) + 1]
		$m[0] += 1
		$m[UBound($m) - 1] = StringMid($mhex, $i, 16)
	Next
	
	For $loop = 1 To $m[0]
		$mess = StringSplit(_HexToBin($m[$loop]), "")
		$ip = ""
		For $i = 0 To 63
			$ip &= $mess[$IP_1[$i]]
		Next
		$L[0] = StringLeft($ip, 32)
		$R[0] = StringRight($ip, 32)
		If $encrypt == 1 Then $encrypt = 17
		For $n = 1 To 16
			$L[$n] = $R[$n - 1]
			$R[$n] = _XOR($L[$n - 1], f($R[$n - 1], $keys[Abs($encrypt - $n) - 1]))
		Next
		$RL = $R[16] & $L[16]
		$RL = StringSplit($RL, "")
		For $i = 0 To 63
			$enc &= $RL[$IP_2[$i]]
		Next
		$enc_hex &= _BinToHex($enc)
		$enc = ""
	Next
	ConsoleWrite("0x" & $enc_hex & @CRLF)
	For $i = 1 To StringLen($enc_hex) Step 2
		$enc_message &= Chr(Dec(StringMid($enc_hex, $i, 2)))
	Next
	If $encrypt = 17 Then
		$fill = Asc(StringRight($enc_message, 1))
		$enc_message = StringTrimRight($enc_message, $fill)
	EndIf
	Return $enc_message
EndFunc   ;==>des

Func _DecToBin($dec, $size = 0)
	If (Not IsInt($dec)) Or ($dec < 0) Then Return -1
	$bin = ""
	If $dec = 0 Then Return "0000"
	While $dec <> 0
		$bin = BitAND($dec, 1) & $bin
		$dec = BitShift($dec, 1)
	WEnd
	$diff = $size - StringLen($bin)
	If $diff > 0 Then
		For $i = 1 To $diff
			$bin = 0 & $bin
		Next
	EndIf
	Return $bin
EndFunc   ;==>_DecToBin

Func _BinToDec($bin)
	If (Not IsString($bin)) Then Return -1
	$end = StringLen($bin)
	$dec = 0
	For $cpt = 1 To $end
		$char = StringMid($bin, $end + 1 - $cpt, 1)
		Select
			Case $char = "1"
				$dec = BitXOR($dec, BitShift(1, -($cpt - 1)))
			Case $char = "0"
				; nothing
			Case Else
				;error
				Return -1
		EndSelect
	Next
	Return $dec
EndFunc   ;==>_BinToDec

Func _HexToDec($hex)
	Local $dec = 0
	$hex = StringSplit($hex, "")
	For $i = $hex[0] To 1 Step - 1
		$dec += Dec($hex[$i]) * (16 ^ ($i - 1))
	Next
	Return $dec
EndFunc   ;==>_HexToDec

Func _HexToBin($hex)
	Local $bin = ""
	$hex = StringSplit($hex, "")
	For $i = 1 To $hex[0]
		$bin &= _DecToBin(Dec($hex[$i]), 4)
	Next
	Return $bin
EndFunc   ;==>_HexToBin

Func _BinToHex($bin)
	Local $hex
	For $i = 1 To StringLen($bin) Step 4
		$hex &= Hex(_BinToDec(StringMid($bin, $i, 4)), 1)
	Next
	Return $hex
EndFunc   ;==>_BinToHex

Func _XOR($bits1, $bits2)
	Local $return
	$bits1 = StringSplit($bits1, "")
	$bits2 = StringSplit($bits2, "")
	
	For $i = 1 To $bits1[0]
		If $bits1[$i] <> $bits2[$i] Then
			$return &= 1
		Else
			$return &= 0
		EndIf
	Next
	
	Return $return
EndFunc   ;==>_XOR

Func _RotateLeft($bin, $pos)
	Return StringRight($bin, StringLen($bin) - $pos) & StringLeft($bin, $pos)
EndFunc   ;==>_RotateLeft