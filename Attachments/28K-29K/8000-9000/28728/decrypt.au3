; child udf of aion.au3
Global Const $STATIC_KEY = StringToBinary("nKO/WctQ0AVLbpzfBkS6NevDYT8ourG5CRlmdjyJ72aswx4EPq1UgZhFMXH?3iI9")
Global $DA_KEY = 0, $b_BUFFER
Global Const $Y = 0xCD92E451
Global Const $Z = 0x3FF2CC87
Global Const $S = 0xa16c5487
#cs
	2: the SM_KEY packet send you only half of the key (4 bytes)
	ie : 09 00 XX XX XX K1 K2 K3 K4
	with the 4 bytes K1 to K4 you build an integer, then substract Z from your integer, then you xor the result with Y
	This gives you the 4 first bytes of the key
	The 4 last bytes S of the key are static in the client.
	The values of Z,Y and S can be found in the aion emu sources .
#ce
Func decrypt($aion_packet)
	If BinaryLen($aion_packet) = 0 Then Return False
	ConsoleWrite(StringToBinary(BinaryToString(BinaryMid($aion_packet, 1, 2), 2), 3) & @CRLF)
	If Hex(StringToBinary(BinaryToString(BinaryMid($aion_packet, 1, 2), 2), 3)) = 0x0009 Then
		$server_part = BinaryMid($aion_packet, 6, 4)
		$server_part2 = "0x" & hex(Int($server_part) - Int($Z))
		$server_part3 = BitXOR($server_part2,$Y)
		if $DA_KEY = 0 then $DA_KEY = StringReplace($server_part3 & "" & Hex($S, 8), "0x", "")
		ConsoleWrite("!Got decryption Key: 0x" & $DA_KEY & " from step1: " & $server_part & " step2: " & $server_part2 & " step3: 0x" & hex($server_part3,8)& @CRLF)
	Else
		If $DA_KEY <> 0 Then buffer($aion_packet)
	EndIf
EndFunc   ;==>decrypt


Func buffer($aion_packet)
	$b_BUFFER &= StringReplace($aion_packet, "0x", "")
	ConsoleWrite($b_BUFFER & @CRLF& @CRLF)
EndFunc   ;==>buffer

Func decrypt2($aion_packet)
	Local $laenge = StringToBinary(BinaryToString(BinaryMid($aion_packet, 1, 2), 2), 3)
	$data = BinaryMid($aion_packet, 3, $laenge)

	Return $data
EndFunc   ;==>decrypt2
