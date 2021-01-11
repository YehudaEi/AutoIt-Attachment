#include<string.au3>

Global $char, $base64string, $binarystring, $bytecount = 1, $bytes, $padbyte, $i, $teststring, $addbyte, $finalchange, $finalresult, $binarystring, $bytecount, $bits

Func _SMTPMail($from_mail, $to_mail, $server, $subject = "", $mail_body = "", $port = 25, $user = "", $password = "")
	
	Local $return_value, $step

	If $from_mail = "" Then Return "from: field cannot be empty"
	If $to_mail = "" Then Return "to: field cannot be empty"
	If $server = "" Then Return "server address is needed"
	
	$multircpt = StringSplit($to_mail, " ", 1)
	
	$servercheck = StringSplit($server, ".", 1)

	For $i = 1 To $servercheck[0]
		$digit_check = StringIsDigit($servercheck[$i])
		$return_value = $return_value + $digit_check
	Next
	If $return_value = 4 Then
		TCPStartup()
		$connection_socket_1 = TCPConnect($server, $port)
	Else
		TCPStartup()
		$connection_socket_1 = TCPConnect(TCPNameToIP($server), $port)
	EndIf
	If $connection_socket_1 = -1 Then Return "cannot connect to SMTP server specified"

	While 1
		Do
			$reply_message = TCPRecv($connection_socket_1, 512)
		Until $reply_message <> ""
		$step = $step + 1
		Select
			Case StringInStr($reply_message, "220") > 0 And $step = 1
				TCPSend($connection_socket_1, "HELO " & @ComputerName & @CRLF)
				
			Case StringInStr($reply_message, "250") > 0 And $user = "" And $step = 2
				TCPSend($connection_socket_1, "MAIL FROM:<" & $from_mail & ">" & @CRLF)
				
			Case StringInStr($reply_message, "250") > 0 And $user <> "" And $step = 2
				TCPSend($connection_socket_1, "AUTH LOGIN" & @CRLF)
				
			Case StringInStr($reply_message, "250") > 0 And $user = "" And $step = 3
				TCPSend($connection_socket_1, "RCPT TO:<" & $multircpt[$multircpt[0]] & ">" & @CRLF)
				
			Case StringInStr($reply_message, "334") > 0 And $user <> "" And $step = 3
				TCPSend($connection_socket_1, base64 ($user) & @CRLF)
				
			Case StringInStr($reply_message, "334") > 0 And $user <> "" And $step = 4
				TCPSend($connection_socket_1, base64 ($password) & @CRLF)
				
			Case StringInStr($reply_message, "250") > 0 And $user = "" And $step = 4
				TCPSend($connection_socket_1, "DATA" & @CRLF)
				
			Case StringInStr($reply_message, "235") > 0 And $user <> "" And $step = 5
				TCPSend($connection_socket_1, "MAIL FROM:<" & $from_mail & ">" & @CRLF)
				
			Case StringInStr($reply_message, "354") > 0 And $user = "" And $step = 5
				TCPSend($connection_socket_1, "SUBJECT:" & $subject & @CRLF & "Mime-Version: 1.0" & @CRLF & "Content-Type: text/plain; charset=US-ASCII" & @CRLF & "Return-Path:" & $from_mail & @CRLF & @CRLF & $mail_body & @CRLF & "." & @CRLF)
				If $multircpt[0] > 1 Then 
					$step = 2
					$multircpt[0] = $multircpt[0] - 1
				EndIf
				
			Case StringInStr($reply_message, "250") > 0 And $user <> "" And $step = 6
				TCPSend($connection_socket_1, "RCPT TO:<" & $multircpt[$multircpt[0]] & ">" & @CRLF)
				
			Case StringInStr($reply_message, "250") > 0 And $user = "" And $step = 6
				TCPSend($connection_socket_1, "QUIT" & @CRLF)
				$step = 0
				Return "mail sent ok"
				
			Case StringInStr($reply_message, "250") > 0 And $user <> "" And $step = 7
				TCPSend($connection_socket_1, "DATA" & @CRLF)
				
			Case StringInStr($reply_message, "354") > 0 And $user <> "" And $step = 8
				TCPSend($connection_socket_1, "SUBJECT:" & $subject & @CRLF & "Mime-Version: 1.0" & @CRLF & "Content-Type: text/plain; charset=US-ASCII" & @CRLF & "Return-Path:" & $from_mail & @CRLF & @CRLF & $mail_body & @CRLF & "." & @CRLF)
				If $multircpt[0] > 1 Then 
					$step = 5
					$multircpt[0] = $multircpt[0] - 1
				EndIf
				
			Case StringInStr($reply_message, "250") > 0 And $user <> "" And $step = 9
				TCPSend($connection_socket_1, "QUIT" & @CRLF)
				$step = 0
				Return "mail sent ok"
			Case StringInStr($reply_message, "250") = 0 And StringInStr($reply_message, "220") = 0 And StringInStr($reply_message, "334") = 0 And StringInStr($reply_message, "235") = 0 And StringInStr($reply_message, "354") = 0 
				TCPSend($connection_socket_1, "QUIT" & @CRLF)
				$step = 0
				Return $reply_message
		EndSelect
		$reply_message = ""
	WEnd
EndFunc

Func base64($inputstring)
	$finalresult = ""
	$binarystring = ""
	$bytecount = 1
	$stringlenght = StringLen($inputstring)
	For $i = 1 To $stringlenght Step 1
		$split = StringMid($inputstring, $i, 1)
		$splitresult = ascii_to_binary($split)
		$binarystring = $binarystring & $splitresult
	Next
	base64bytes()
	Return $finalresult
EndFunc

Func ascii_to_binary($char)
	$bits = ""
	$char = Asc($char)
	For $i = 0 To 7
		$bits = BitAND($char, 1) & $bits
		$char = BitShift($char, 1)
	Next
	Return $bits
EndFunc

Func base64bytes()
	Dim $base64string[1000]
	$padbyte = StringLen($binarystring)
	$bytes = $padbyte / 8
	Do
		$teststring = StringIsInt($bytes / 3)
		$bytes = $bytes + 1
		$addbyte = $addbyte + 1
	Until $teststring = 1
	$addbyte = $addbyte - 1
	If $bytes <> 0 Then
		For $i = 1 To $addbyte Step 1
			$binarystring = $binarystring & "00000000"
		Next
	EndIf
	Do
		$base64string[$bytecount] = StringMid($binarystring, $bytecount, 6)
		$bytecount = $bytecount + 6
	Until $base64string[$bytecount - 6] = ""
	$bytecount = $bytecount - 12
	If $addbyte > 0 Then $bytecount = $bytecount - (6 * $addbyte)
	For $i = 1 To $bytecount Step 6
		$finalchange = base64convert($base64string[$i])
		$finalresult = $finalresult & $finalchange
	Next
	If $addbyte > 0 Then
		For $i = 1 To $addbyte Step 1
			$finalresult = $finalresult & "="
		Next
	EndIf
	Return
EndFunc

Func base64convert($char)
	$char = _StringReverse($char)
	$split = StringSplit($char, "")
	$dec = 0
	For $i = 1 To StringLen($char)
		$dec = $dec + ($split[$i]* (2^ ($i - 1)))
	Next
	$char = $dec
	If $char >= 0 And $char <= 25 Then $char = Chr($char + 65)
	If $char >= 26 And $char <= 51 Then $char = Chr($char + 71)
	If $char >= 52 And $char <= 61 Then $char = Chr($char - 4)
	If $char = "62" Then $char = "+"
	If $char = "63" Then $char = "/"
	Return $char
EndFunc