; child udf of aion.au3
Global Const $STATIC_KEY = BinaryToArray(StringToBinary("nKO/WctQ0AVLbpzfBkS6NevDYT8ourG5CRlmdjyJ72aswx4EPq1UgZhFMXH?3iI9"))
Global Const $CLIENT_PACKET_KEY = clientPacketKey = new byte[] { (byte) (key & 0xff), (byte) ((key >> 8) & 0xff), (byte) ((key >> 16) & 0xff),
			(byte) ((key >> 24) & 0xff), (byte) 0xa1, (byte) 0x6c, (byte) 0x54, (byte) 0x87 };

ConsoleWrite(BinaryLen($STATIC_KEY) & @CRLF)

Func decrypt($aion_packet)
	if BinaryLen($aion_packet) = 0 then Return False
	$res = BinaryToArray($aion_packet)
	Local $decrypted[UBound($res)]
	$decrypted[0] = $res[0]
	if BinaryLen($aion_packet) = dec(hex(Binary("0x" & $res[2]&$res[1]))) Then
		ConsoleWrite("Packet OK: " & BinaryLen($aion_packet) & @CRLF)
		Local $decrypted
		for $i = 1 to $res[0]
			$decrypted[$i] = 0
		Next
	Else
		Return False
	EndIf
EndFunc

Func BinaryToArray($bin)
	$len = BinaryLen($bin)
	$bin = StringTrimLeft($bin,2)
	$a_bin = StringSplit($bin,"",1)
	Local $a_res[$len+1]
	$a_res[0] = $len
	$j = 0
	for $i = 1 to $len*2 step 2
		$j +=1
		$a_res[$j] = $a_bin[$i] & $a_bin[$i+1]
	Next
	Return $a_res
EndFunc
