
_Example()

Func _Example()

	Local $sTest = FileRead(@ScriptFullPath)

	Local $sEnc = _Base91Encode($sTest)
	Local $sDec = _Base91Decode($sEnc)
	If $sDec = $sTest Then
		ConsoleWrite($sEnc & @LF & $sDec & @LF & '**Test Passed**' & @LF & @LF)
	Else
		ConsoleWrite($sEnc & @LF & $sDec & @LF & '**Test Failed**' & @LF & @LF)
	EndIf

	$sEnc = _Base128Encode($sTest)
	$sDec = _Base128Decode($sEnc)
	If $sDec = $sTest Then
		ConsoleWrite($sEnc & @LF & $sDec & @LF & '**Test Passed**' & @LF)
	Else
		ConsoleWrite($sEnc & @LF & $sDec & @LF & '**Test Failed**' & @LF)
	EndIf

EndFunc   ;==>_Example

; #FUNCTION# ====================================================================================================================
; Name...........: _Base91Encode
; Description ...: Encodes string to Base91
; Author ........: Brian J Christy (Beege)
; Source ........: http://base91.sourceforge.net/  [Joachim Henke]
; ===============================================================================================================================
Func _Base91Encode($sStr)

	Local $aB91 = StringSplit('ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789!#$%&()*+,./:;<=>?@[]^_`{|}~"', '', 2)
	Local $sEncoded, $b, $n, $v, $aStr = StringToASCIIArray($sStr)

	For $i = 0 To UBound($aStr) - 1
		$b = BitOR($b, BitShift($aStr[$i], ($n * - 1)))
		$n += 8
		If $n > 13 Then
			$v = BitAND($b, 8191)
			If ($v > 88) Then
				$b = BitShift($b, 13)
				$n -= 13
			Else
				$v = BitAND($b, 16383)
				$b = BitShift($b, 14)
				$n -= 14
			EndIf
			$sEncoded &= $aB91[Mod($v, 91)] & $aB91[$v / 91]
		EndIf
	Next

	If $n Then
		$sEncoded &= $aB91[Mod($b, 91)]
		If $n > 7 Or $b > 90 Then $sEncoded &= $aB91[$b / 91]
	EndIf

	Return $sEncoded

EndFunc   ;==>_Base91Encode

; #FUNCTION# ====================================================================================================================
; Name...........: _Base91Encode
; Description ...: Decodes string from Base91
; Author ........: Brian J Christy (Beege)
; Source ........: http://base91.sourceforge.net/  [Joachim Henke]
; ===============================================================================================================================
Func _Base91Decode($sStr)

	Local $sB91 = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789!#$%&()*+,./:;<=>?@[]^_`{|}~"'
	Local $sDecoded, $n, $c, $b, $v = -1, $aStr = StringSplit($sStr, '', 2)

	For $i = 0 To UBound($aStr) - 1
		$c = StringInStr($sB91, $aStr[$i], 1) - 1
		If $v < 0 Then
			$v = $c
		Else
			$v += $c * 91
			$b = BitOR($b, BitShift($v, ($n * - 1)))
			$n += 13 + (BitAND($v, 8191) <= 88)
			Do
				$sDecoded &= Chr(BitAND($b, 255))
				$b = BitShift($b, 8)
				$n -= 8
			Until Not ($n > 7)
			$v = -1
		EndIf
	Next

	If ($v + 1) Then $sDecoded &= Chr(BitAND(BitOR($b, BitShift($v, ($n * - 1))), 255))

	Return $sDecoded

EndFunc   ;==>_Base91Decode

; #FUNCTION# ====================================================================================================================
; Name...........: _Base128Encode
; Description ...: Decodes string from Base128
; Author ........: Brian J Christy (Beege)
; Source ........: https://github.com/seizu/base128/blob/master/base128.php  [Erich Pribitzer]
; ===============================================================================================================================
Func _Base128Encode($sStr)

	Local $aB128 = StringSplit('!#$%()*,.0123456789:;=@ABCDEFGHIJKLMNOPQRSTUVWXYZ[]^_abcdefghijklmnopqrstuvwxyz{|}~¡¢£¤¥¦§¨©ª«¬®¯°±²³´µ¶·¸¹º»¼½¾¿ÀÁÂÃÄÅÆÇÈÉÊËÌÍÎ', '', 2)
	Local $sEncoded, $ls, $r, $rs = 7, $aStr = StringToASCIIArray($sStr & ' ')

	For $i = 0 To UBound($aStr) - 1
		If $ls > 7 Then
			$i -= 1
			$ls = 0
			$rs = 7
		EndIf
		$nc = BitOR(BitAND(BitShift($aStr[$i], ($ls * - 1)), 0x7f), $r)
		$r = BitAND(BitShift($aStr[$i], $rs), 0x7f)
		$rs -= 1
		$ls += 1
		$sEncoded &= $aB128[$nc]
	Next

	Return $sEncoded

EndFunc   ;==>_Base128Encode

; #FUNCTION# ====================================================================================================================
; Name...........: _Base91Encode
; Description ...: Decodes string from Base128
; Author ........: Brian J Christy (Beege)
; Source ........: https://github.com/seizu/base128/blob/master/base128.php  [Erich Pribitzer]
; ===============================================================================================================================
Func _Base128Decode($sStr)

	Local $sB128 = '!#$%()*,.0123456789:;=@ABCDEFGHIJKLMNOPQRSTUVWXYZ[]^_abcdefghijklmnopqrstuvwxyz{|}~¡¢£¤¥¦§¨©ª«¬®¯°±²³´µ¶·¸¹º»¼½¾¿ÀÁÂÃÄÅÆÇÈÉÊËÌÍÎ'
	Local $sDecoded, $r, $rs = 8, $ls = 7, $aStr = StringSplit($sStr, '', 2)

	For $i = 0 To UBound($aStr) - 1
		$nc = StringInStr($sB128, $aStr[$i], 1) - 1
		If $rs > 7 Then
			$rs = 1
			$ls = 7
			$r = $nc
			ContinueLoop
		EndIf
		$r1 = $nc
		$nc = BitOR(BitAND(BitShift($nc, ($ls * - 1)), 0xFF), $r)
		$r = BitShift($r1, $rs)
		$rs += 1
		$ls -= 1
		$sDecoded &= Chr($nc)
	Next

	Return $sDecoded

EndFunc   ;==>_Base128Decode


