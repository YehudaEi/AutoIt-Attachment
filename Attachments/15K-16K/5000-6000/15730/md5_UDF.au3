;===============================================================================
;
; Function Name:	_StringMD5($string)
; Description:		Calculates the MD5 hash of a string argument
; Parameter:		$string is the string you want to hash.
; Requirement:		AutoIT version 3.2.5.0 (beta)
; Return Value:		Returns the MD5 hash string of the string argument.
; Author:			Arses
;
;===============================================================================

Func _StringMD5($string)
	$string = String($string)
	Local $bitLen, $bytes, $bytesLen, $blockN, $i
	Local $A, $B, $C, $D, $X[16], $Am, $Bm, $Cm, $Dm, $T[65]
	$bytes = StringToBinary($string)
	$bitLen = 8 * BinaryLen($bytes)
	$bytes += BinaryMid(Binary(0x80), 1, 1)
	$bytesLen = BinaryLen($bytes)
	While Mod($bytesLen + 8, 64) <> 0
		$bytes += BinaryMid(Binary(0x00), 1, 1)
		$bytesLen = BinaryLen($bytes)
	WEnd
	$bytes += BinaryMid(Binary($bitLen) + Binary(0), 1, 8)
	$bytesLen = BinaryLen($bytes)
	$A = 0x67452301
	$B = 0xEFCDAB89
	$C = 0x98BADCFE
	$D = 0x10325476
	For $i = 0 To 64 Step 1
		$T[$i] = 4294967296 * Abs(Sin($i))
	Next
	$blockN = 0
	Do
		For $i = 0 To 15 Step 1
			$X[$i] = BinaryMid($bytes, $blockN * 64 + 4 + $i * 4, 1) + BinaryMid($bytes, $blockN * 64 + 3 + $i * 4, 1) + _
					BinaryMid($bytes, $blockN * 64 + 2 + $i * 4, 1) + BinaryMid($bytes, $blockN * 64 + 1 + $i * 4, 1)
		Next
		$Am = $A
		$Bm = $B
		$Cm = $C
		$Dm = $D
		;Stage 1
		$A = Dec(Hex(BitRotate(Dec(Hex(Dec(Hex(Dec(Hex(Dec(Hex($X[0])) + $T[1])) + BitOR(BitAND($B, $C), BitAND(BitNOT($B), $D)))) + $A)), 7, "D") + $B))
		$D = Dec(Hex(BitRotate(Dec(Hex(Dec(Hex(Dec(Hex(Dec(Hex($X[1])) + $T[2])) + BitOR(BitAND($A, $B), BitAND(BitNOT($A), $C)))) + $D)), 12, "D") + $A))
		$C = Dec(Hex(BitRotate(Dec(Hex(Dec(Hex(Dec(Hex(Dec(Hex($X[2])) + $T[3])) + BitOR(BitAND($D, $A), BitAND(BitNOT($D), $B)))) + $C)), 17, "D") + $D))
		$B = Dec(Hex(BitRotate(Dec(Hex(Dec(Hex(Dec(Hex(Dec(Hex($X[3])) + $T[4])) + BitOR(BitAND($C, $D), BitAND(BitNOT($C), $A)))) + $B)), 22, "D") + $C))
		$A = Dec(Hex(BitRotate(Dec(Hex(Dec(Hex(Dec(Hex(Dec(Hex($X[4])) + $T[5])) + BitOR(BitAND($B, $C), BitAND(BitNOT($B), $D)))) + $A)), 7, "D") + $B))
		$D = Dec(Hex(BitRotate(Dec(Hex(Dec(Hex(Dec(Hex(Dec(Hex($X[5])) + $T[6])) + BitOR(BitAND($A, $B), BitAND(BitNOT($A), $C)))) + $D)), 12, "D") + $A))
		$C = Dec(Hex(BitRotate(Dec(Hex(Dec(Hex(Dec(Hex(Dec(Hex($X[6])) + $T[7])) + BitOR(BitAND($D, $A), BitAND(BitNOT($D), $B)))) + $C)), 17, "D") + $D))
		$B = Dec(Hex(BitRotate(Dec(Hex(Dec(Hex(Dec(Hex(Dec(Hex($X[7])) + $T[8])) + BitOR(BitAND($C, $D), BitAND(BitNOT($C), $A)))) + $B)), 22, "D") + $C))
		$A = Dec(Hex(BitRotate(Dec(Hex(Dec(Hex(Dec(Hex(Dec(Hex($X[8])) + $T[9])) + BitOR(BitAND($B, $C), BitAND(BitNOT($B), $D)))) + $A)), 7, "D") + $B))
		$D = Dec(Hex(BitRotate(Dec(Hex(Dec(Hex(Dec(Hex(Dec(Hex($X[9])) + $T[10])) + BitOR(BitAND($A, $B), BitAND(BitNOT($A), $C)))) + $D)), 12, "D") + $A))
		$C = Dec(Hex(BitRotate(Dec(Hex(Dec(Hex(Dec(Hex(Dec(Hex($X[10])) + $T[11])) + BitOR(BitAND($D, $A), BitAND(BitNOT($D), $B)))) + $C)), 17, "D") + $D))
		$B = Dec(Hex(BitRotate(Dec(Hex(Dec(Hex(Dec(Hex(Dec(Hex($X[11])) + $T[12])) + BitOR(BitAND($C, $D), BitAND(BitNOT($C), $A)))) + $B)), 22, "D") + $C))
		$A = Dec(Hex(BitRotate(Dec(Hex(Dec(Hex(Dec(Hex(Dec(Hex($X[12])) + $T[13])) + BitOR(BitAND($B, $C), BitAND(BitNOT($B), $D)))) + $A)), 7, "D") + $B))
		$D = Dec(Hex(BitRotate(Dec(Hex(Dec(Hex(Dec(Hex(Dec(Hex($X[13])) + $T[14])) + BitOR(BitAND($A, $B), BitAND(BitNOT($A), $C)))) + $D)), 12, "D") + $A))
		$C = Dec(Hex(BitRotate(Dec(Hex(Dec(Hex(Dec(Hex(Dec(Hex($X[14])) + $T[15])) + BitOR(BitAND($D, $A), BitAND(BitNOT($D), $B)))) + $C)), 17, "D") + $D))
		$B = Dec(Hex(BitRotate(Dec(Hex(Dec(Hex(Dec(Hex(Dec(Hex($X[15])) + $T[16])) + BitOR(BitAND($C, $D), BitAND(BitNOT($C), $A)))) + $B)), 22, "D") + $C))
		;Stage 2
		$A = Dec(Hex(BitRotate(Dec(Hex(Dec(Hex(Dec(Hex(Dec(Hex($X[1])) + $T[17])) + BitOR(BitAND($B, $D), BitAND($C, BitNOT($D))))) + $A)), 5, "D") + $B))
		$D = Dec(Hex(BitRotate(Dec(Hex(Dec(Hex(Dec(Hex(Dec(Hex($X[6])) + $T[18])) + BitOR(BitAND($A, $C), BitAND($B, BitNOT($C))))) + $D)), 9, "D") + $A))
		$C = Dec(Hex(BitRotate(Dec(Hex(Dec(Hex(Dec(Hex(Dec(Hex($X[11])) + $T[19])) + BitOR(BitAND($D, $B), BitAND($A, BitNOT($B))))) + $C)), 14, "D") + $D))
		$B = Dec(Hex(BitRotate(Dec(Hex(Dec(Hex(Dec(Hex(Dec(Hex($X[0])) + $T[20])) + BitOR(BitAND($C, $A), BitAND($D, BitNOT($A))))) + $B)), 20, "D") + $C))
		$A = Dec(Hex(BitRotate(Dec(Hex(Dec(Hex(Dec(Hex(Dec(Hex($X[5])) + $T[21])) + BitOR(BitAND($B, $D), BitAND($C, BitNOT($D))))) + $A)), 5, "D") + $B))
		$D = Dec(Hex(BitRotate(Dec(Hex(Dec(Hex(Dec(Hex(Dec(Hex($X[10])) + $T[22])) + BitOR(BitAND($A, $C), BitAND($B, BitNOT($C))))) + $D)), 9, "D") + $A))
		$C = Dec(Hex(BitRotate(Dec(Hex(Dec(Hex(Dec(Hex(Dec(Hex($X[15])) + $T[23])) + BitOR(BitAND($D, $B), BitAND($A, BitNOT($B))))) + $C)), 14, "D") + $D))
		$B = Dec(Hex(BitRotate(Dec(Hex(Dec(Hex(Dec(Hex(Dec(Hex($X[4])) + $T[24])) + BitOR(BitAND($C, $A), BitAND($D, BitNOT($A))))) + $B)), 20, "D") + $C))
		$A = Dec(Hex(BitRotate(Dec(Hex(Dec(Hex(Dec(Hex(Dec(Hex($X[9])) + $T[25])) + BitOR(BitAND($B, $D), BitAND($C, BitNOT($D))))) + $A)), 5, "D") + $B))
		$D = Dec(Hex(BitRotate(Dec(Hex(Dec(Hex(Dec(Hex(Dec(Hex($X[14])) + $T[26])) + BitOR(BitAND($A, $C), BitAND($B, BitNOT($C))))) + $D)), 9, "D") + $A))
		$C = Dec(Hex(BitRotate(Dec(Hex(Dec(Hex(Dec(Hex(Dec(Hex($X[3])) + $T[27])) + BitOR(BitAND($D, $B), BitAND($A, BitNOT($B))))) + $C)), 14, "D") + $D))
		$B = Dec(Hex(BitRotate(Dec(Hex(Dec(Hex(Dec(Hex(Dec(Hex($X[8])) + $T[28])) + BitOR(BitAND($C, $A), BitAND($D, BitNOT($A))))) + $B)), 20, "D") + $C))
		$A = Dec(Hex(BitRotate(Dec(Hex(Dec(Hex(Dec(Hex(Dec(Hex($X[13])) + $T[29])) + BitOR(BitAND($B, $D), BitAND($C, BitNOT($D))))) + $A)), 5, "D") + $B))
		$D = Dec(Hex(BitRotate(Dec(Hex(Dec(Hex(Dec(Hex(Dec(Hex($X[2])) + $T[30])) + BitOR(BitAND($A, $C), BitAND($B, BitNOT($C))))) + $D)), 9, "D") + $A))
		$C = Dec(Hex(BitRotate(Dec(Hex(Dec(Hex(Dec(Hex(Dec(Hex($X[7])) + $T[31])) + BitOR(BitAND($D, $B), BitAND($A, BitNOT($B))))) + $C)), 14, "D") + $D))
		$B = Dec(Hex(BitRotate(Dec(Hex(Dec(Hex(Dec(Hex(Dec(Hex($X[12])) + $T[32])) + BitOR(BitAND($C, $A), BitAND($D, BitNOT($A))))) + $B)), 20, "D") + $C))
		;Stage 3
		$A = Dec(Hex(BitRotate(Dec(Hex(Dec(Hex(Dec(Hex(Dec(Hex($X[5])) + $T[33])) + BitXOR($B, $C, $D))) + $A)), 4, "D") + $B))
		$D = Dec(Hex(BitRotate(Dec(Hex(Dec(Hex(Dec(Hex(Dec(Hex($X[8])) + $T[34])) + BitXOR($A, $B, $C))) + $D)), 11, "D") + $A))
		$C = Dec(Hex(BitRotate(Dec(Hex(Dec(Hex(Dec(Hex(Dec(Hex($X[11])) + $T[35])) + BitXOR($D, $A, $B))) + $C)), 16, "D") + $D))
		$B = Dec(Hex(BitRotate(Dec(Hex(Dec(Hex(Dec(Hex(Dec(Hex($X[14])) + $T[36])) + BitXOR($C, $D, $A))) + $B)), 23, "D") + $C))
		$A = Dec(Hex(BitRotate(Dec(Hex(Dec(Hex(Dec(Hex(Dec(Hex($X[1])) + $T[37])) + BitXOR($B, $C, $D))) + $A)), 4, "D") + $B))
		$D = Dec(Hex(BitRotate(Dec(Hex(Dec(Hex(Dec(Hex(Dec(Hex($X[4])) + $T[38])) + BitXOR($A, $B, $C))) + $D)), 11, "D") + $A))
		$C = Dec(Hex(BitRotate(Dec(Hex(Dec(Hex(Dec(Hex(Dec(Hex($X[7])) + $T[39])) + BitXOR($D, $A, $B))) + $C)), 16, "D") + $D))
		$B = Dec(Hex(BitRotate(Dec(Hex(Dec(Hex(Dec(Hex(Dec(Hex($X[10])) + $T[40])) + BitXOR($C, $D, $A))) + $B)), 23, "D") + $C))
		$A = Dec(Hex(BitRotate(Dec(Hex(Dec(Hex(Dec(Hex(Dec(Hex($X[13])) + $T[41])) + BitXOR($B, $C, $D))) + $A)), 4, "D") + $B))
		$D = Dec(Hex(BitRotate(Dec(Hex(Dec(Hex(Dec(Hex(Dec(Hex($X[0])) + $T[42])) + BitXOR($A, $B, $C))) + $D)), 11, "D") + $A))
		$C = Dec(Hex(BitRotate(Dec(Hex(Dec(Hex(Dec(Hex(Dec(Hex($X[3])) + $T[43])) + BitXOR($D, $A, $B))) + $C)), 16, "D") + $D))
		$B = Dec(Hex(BitRotate(Dec(Hex(Dec(Hex(Dec(Hex(Dec(Hex($X[6])) + $T[44])) + BitXOR($C, $D, $A))) + $B)), 23, "D") + $C))
		$A = Dec(Hex(BitRotate(Dec(Hex(Dec(Hex(Dec(Hex(Dec(Hex($X[9])) + $T[45])) + BitXOR($B, $C, $D))) + $A)), 4, "D") + $B))
		$D = Dec(Hex(BitRotate(Dec(Hex(Dec(Hex(Dec(Hex(Dec(Hex($X[12])) + $T[46])) + BitXOR($A, $B, $C))) + $D)), 11, "D") + $A))
		$C = Dec(Hex(BitRotate(Dec(Hex(Dec(Hex(Dec(Hex(Dec(Hex($X[15])) + $T[47])) + BitXOR($D, $A, $B))) + $C)), 16, "D") + $D))
		$B = Dec(Hex(BitRotate(Dec(Hex(Dec(Hex(Dec(Hex(Dec(Hex($X[2])) + $T[48])) + BitXOR($C, $D, $A))) + $B)), 23, "D") + $C))
		;Stage 4
		$A = Dec(Hex(BitRotate(Dec(Hex(Dec(Hex(Dec(Hex(Dec(Hex($X[0])) + $T[49])) + BitXOR($C, BitOR($B, BitNOT($D))))) + $A)), 6, "D") + $B))
		$D = Dec(Hex(BitRotate(Dec(Hex(Dec(Hex(Dec(Hex(Dec(Hex($X[7])) + $T[50])) + BitXOR($B, BitOR($A, BitNOT($C))))) + $D)), 10, "D") + $A))
		$C = Dec(Hex(BitRotate(Dec(Hex(Dec(Hex(Dec(Hex(Dec(Hex($X[14])) + $T[51])) + BitXOR($A, BitOR($D, BitNOT($B))))) + $C)), 15, "D") + $D))
		$B = Dec(Hex(BitRotate(Dec(Hex(Dec(Hex(Dec(Hex(Dec(Hex($X[5])) + $T[52])) + BitXOR($D, BitOR($C, BitNOT($A))))) + $B)), 21, "D") + $C))
		$A = Dec(Hex(BitRotate(Dec(Hex(Dec(Hex(Dec(Hex(Dec(Hex($X[12])) + $T[53])) + BitXOR($C, BitOR($B, BitNOT($D))))) + $A)), 6, "D") + $B))
		$D = Dec(Hex(BitRotate(Dec(Hex(Dec(Hex(Dec(Hex(Dec(Hex($X[3])) + $T[54])) + BitXOR($B, BitOR($A, BitNOT($C))))) + $D)), 10, "D") + $A))
		$C = Dec(Hex(BitRotate(Dec(Hex(Dec(Hex(Dec(Hex(Dec(Hex($X[10])) + $T[55])) + BitXOR($A, BitOR($D, BitNOT($B))))) + $C)), 15, "D") + $D))
		$B = Dec(Hex(BitRotate(Dec(Hex(Dec(Hex(Dec(Hex(Dec(Hex($X[1])) + $T[56])) + BitXOR($D, BitOR($C, BitNOT($A))))) + $B)), 21, "D") + $C))
		$A = Dec(Hex(BitRotate(Dec(Hex(Dec(Hex(Dec(Hex(Dec(Hex($X[8])) + $T[57])) + BitXOR($C, BitOR($B, BitNOT($D))))) + $A)), 6, "D") + $B))
		$D = Dec(Hex(BitRotate(Dec(Hex(Dec(Hex(Dec(Hex(Dec(Hex($X[15])) + $T[58])) + BitXOR($B, BitOR($A, BitNOT($C))))) + $D)), 10, "D") + $A))
		$C = Dec(Hex(BitRotate(Dec(Hex(Dec(Hex(Dec(Hex(Dec(Hex($X[6])) + $T[59])) + BitXOR($A, BitOR($D, BitNOT($B))))) + $C)), 15, "D") + $D))
		$B = Dec(Hex(BitRotate(Dec(Hex(Dec(Hex(Dec(Hex(Dec(Hex($X[13])) + $T[60])) + BitXOR($D, BitOR($C, BitNOT($A))))) + $B)), 21, "D") + $C))
		$A = Dec(Hex(BitRotate(Dec(Hex(Dec(Hex(Dec(Hex(Dec(Hex($X[4])) + $T[61])) + BitXOR($C, BitOR($B, BitNOT($D))))) + $A)), 6, "D") + $B))
		$D = Dec(Hex(BitRotate(Dec(Hex(Dec(Hex(Dec(Hex(Dec(Hex($X[11])) + $T[62])) + BitXOR($B, BitOR($A, BitNOT($C))))) + $D)), 10, "D") + $A))
		$C = Dec(Hex(BitRotate(Dec(Hex(Dec(Hex(Dec(Hex(Dec(Hex($X[2])) + $T[63])) + BitXOR($A, BitOR($D, BitNOT($B))))) + $C)), 15, "D") + $D))
		$B = Dec(Hex(BitRotate(Dec(Hex(Dec(Hex(Dec(Hex(Dec(Hex($X[9])) + $T[64])) + BitXOR($D, BitOR($C, BitNOT($A))))) + $B)), 21, "D") + $C))
		$A = Dec(Hex($A + $Am))
		$B = Dec(Hex($B + $Bm))
		$C = Dec(Hex($C + $Cm))
		$D = Dec(Hex($D + $Dm))
		$blockN += 1
	Until $blockN * 64 >= $bytesLen
	Return Hex(Binary($A) + Binary($B) + Binary($C) + Binary($D))
EndFunc   ;==>_StringMD5