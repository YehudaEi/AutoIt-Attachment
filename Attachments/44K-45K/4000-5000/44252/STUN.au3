
; STUN client - written by trancexx
; Donations are wellcome and can be accepted via PayPal address: trancexx at yahoo dot com
; Thank you for the shiny stuff :kiss:

$hTimer = TimerInit()
$sIp = STUN_GetMyIP()
$iErr = @error
$iDiff = TimerDiff($hTimer)

MsgBox(4096, "STUN", "Your public IP address is: " & $sIp & @CRLF & "Error number is: " & $iErr & @CRLF & "Resolved in " & $iDiff & "ms")
ConsoleWrite("Your public IP address is: " & $sIp & @CRLF)

Func STUN_GetMyIP()
	; Some STUN servers and their ports
	Local $aServers[14][2] = [["stun.l.google.com", 19302], _
			["stun.ekiga.net", 3478], _
			["stun.sipgate.net", 10000], _
			["stun1.l.google.com", 19302], _
			["stun.ideasip.com", 3478], _
			["stun2.l.google.com", 19302], _
			["stunserver.org", 3478], _
			["stun3.l.google.com", 19302], _
			["stun.rixtelecom.se", 3478], _
			["stun4.l.google.com", 19302], _
			["stun.schlund.de", 3478], _
			["stun.voiparound.com", 3478], _
			["stun.voipbuster.com", 3478], _
			["stun.voipstunt.com", 3478]]

	Local Const $MAPPED_ADDRESS = 0x0001 ; interested in this info
	Local Const $IPv4 = 0x01 ; IPv4 format
	Local Const $IPv6 = 0x02 ; IPv6 format

	; Generate request
	Local $bRandom12 = STUN_GenerateRandom12() ; some random unique ID in size of 12 bytes
	; Binding request has class=0x00 and  method=0x000000000001 (Binding) and is encoded into the first two bytes as 0x0001. Check http://tools.ietf.org/html/rfc5389#section-15
	Local $bBinary = Binary("0x0001000000000000") & $bRandom12

	Local $sIpServ, $aSocket, $bRcvData
	UDPStartup()
	For $i = 0 To UBound($aServers) - 1
		$sIpServ = TCPNameToIP($aServers[$i][0])
		If @error Then ContinueLoop ; couldn't resolve server's IP
		$aSocket = UDPOpen($sIpServ, $aServers[$i][1])
		UDPSend($aSocket, $bBinary)
		For $j = 1 To 3 ; read few (e.g. three) times if necessary
			$bRcvData = UDPRecv($aSocket, 1280) ; never more than 1280 bytes can be returned by the server. Usually it's 50-something bytes.
			If @error Then ExitLoop ; e.g. firewall rule blocks
			If $bRcvData Then ExitLoop 2 ; successfully read, get out of the loops
			Sleep(0) ; give it time to process
		Next
		UDPCloseSocket($aSocket)
	Next
	UDPCloseSocket($aSocket)
	UDPShutdown()
	#cs
		; Struct can be written now in place of binary data, but it's all big-endian (weird for reading in AutoIt):
		Local $tSTUN = DllStructCreate("byte Header_[8]; byte Header_ID[12];" & _
		"byte Type[2];" & _
		"byte Length[2];" & _
		"byte Attrib;" & _
		"byte Family;" & _
		"byte Port[2];" & _
		"byte IP[4];")
	#ce
	; ...so I will just parse binary directly instead.
	Local $iSizeData = BinaryLen($bRcvData)
	If $iSizeData Then ; sanity check
		Local $bReadID = BinaryMid($bRcvData, 9, 12) ; server returns my unique "ID"
		Local $iType, $iLength = 0
		Local $iPos = 21 ; further parsing starts after the header, see the struct and STUN doc

		If $bReadID = $bRandom12 Then ; check validity of the response by checking returned ID (handle)
			While $iPos < $iSizeData
				$iType = STUN_Read_BE_Bin(BinaryMid($bRcvData, $iPos, 2))
				$iPos += 2 ; skip the size of "Type" field
				$iLength = STUN_Read_BE_Bin(BinaryMid($bRcvData, $iPos, 2))
				$iPos += 2 ; skip the size of "Length" field
				If $iType = $MAPPED_ADDRESS Then ExitLoop
				$iPos += $iLength ; skip the size of all of the data in this chunk
			WEnd
		EndIf
		$iPos += 1 ; skip the size of "Attrib" field
		Local $iFamily = STUN_Read_BE_Bin(BinaryMid($bRcvData, $iPos, 1)) ; read "Family" info.
		$iPos += 1 ; skip the size of "Family" field
		$iPos += 2 ; skip the size of "Port" field

		If $iFamily = $IPv4 Then
			; Read IP info. Four bytes are IP in network byte order (big endian)
			Return Int(BinaryMid($bRcvData, $iPos, 1)) & "." & Int(BinaryMid($bRcvData, $iPos + 1, 1)) & "." & Int(BinaryMid($bRcvData, $iPos + 2, 1)) & "." & Int(BinaryMid($bRcvData, $iPos + 3, 1))
		ElseIf $iFamily = $IPv6 Then
			; IPv6 - you do it, I'll just return error:
			Return SetError(1, 0, ":::::::")
		EndIf
		; No such data available
		Return SetError(2, 0, "")
	EndIf
	; You are blocked or something
	Return SetError(3, 0, "")
EndFunc

Func STUN_Read_BE_Bin($bBinary)
	; Big endian to number
	Return Dec(Hex($bBinary))
EndFunc

Func STUN_GenerateRandom12()
	; Whatever
	Return BinaryMid(BinaryMid(Binary(Random(1.1, 2 ^ 31 - 1)), 1, 6) & Binary(Random(1.1, 2 ^ 31 - 1)), 1, 12)
EndFunc

