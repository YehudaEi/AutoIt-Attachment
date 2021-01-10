Func _nCrypt($sString, $bKey)
	Local $Cipher[256], $Keys[256], $Loop = 0, $Return = "", $Temp1 = 0, $Temp2 = 0, $Temp3 = 0
	$intLength = StringLen($bKey)
	For $Loop = 0 To 255
		$Keys[$Loop] = Asc(StringMid($bKey, (Mod($Loop, $intLength)) + 1, 1))
		$Cipher[$Loop] = $Loop
	Next
	For $Loop = 0 To 255
		$Temp1 = Mod($Temp1 + $Cipher[$Loop] + $Keys[$Loop], 256)
		$Cipher[$Loop] = $Cipher[$Temp1]
		$Cipher[$Temp1] = $Cipher[$Loop]
	Next
	For $Loop = 1 To StringLen($sString)
		$Temp2 = Mod(($Temp2 + 1), 256)
		$Temp3 = Mod(($Temp3 + $Cipher[$Temp2]), 256)
		$Return = $Return & Chr(BitXOR(Asc(StringMid($sString, $Loop, 1)), $Cipher[Mod(($Cipher[$Temp3] + $Cipher[$Temp2]), 256)]))
	Next
	Return $Return
EndFunc   ;==>_nCrypt