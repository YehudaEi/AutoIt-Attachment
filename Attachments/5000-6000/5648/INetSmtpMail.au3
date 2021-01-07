;===============================================================================
;
; Function Name:    _INetSmtpMail()
; Description:      Sends an email using SMTP over TCP IP.
; Parameter(s):     $s_SmtpServer	- SMTP server to be used for sending email
;                   $s_FromName		- Name of sender
;                   $s_FromAddress	- eMail address of sender
;                   $s_ToAddress	- Address that email is to be sent to
;                   $s_Subject		- Subject of eMail
;					$as_Body		- Single dimension array containing the body of eMail as strings
; Requirement(s):   None
; Return Value(s):  On Success - Returns 1
;                   On Failure - 0  and sets
;											@ERROR = 1	-	Invalid Parameters
;											@ERROR = 2	-	Unable to start TCP
;											@ERROR = 3	-	Unable to resolve IP
;											@ERROR = 4	-	Unable to create socket
;											@ERROR = 5	-	Data send or SMTP Protocol error
; Authors:        Original function to send email via TCP 	- Asimzameer
;					Conversion to UDF						- Walkabout
;
;===============================================================================
Func _INetSmtpMail($s_SmtpServer, $s_FromName, $s_FromAddress, $s_ToAddress, $s_Subject, $as_Body)
	
	Local $i_ReturnErrorCode
	Local $i_LocalErrorCode
	Local $v_Socket
	Local $s_IPAddress
	Local $i_SendReturn
	Local $i_Count
	Local $s_Send[10]
	Local $s_ReplyCode[10];Return code from SMTP server indicating success
	
	If $s_SmtpServer = "" Or $s_FromAddress = "" Or $s_ToAddress = "" Or $s_FromName = "" Or StringLen($s_FromName) > 256 Then
		SetError(1)
		Return 0
	EndIf
	$i_LocalErrorCode = TCPStartup()
	If $i_LocalErrorCode = 0 Then
		SetError(2)
		Return 0
	EndIf
	StringRegExp($s_SmtpServer, "(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)")
	If @extended Then
		$s_IPAddress = $s_SmtpServer
	Else
		$s_IPAddress = TCPNameToIP($s_SmtpServer)
	EndIf
	If $s_IPAddress = "" Then
		TCPShutdown()
		SetError(3)
		Return 0
	EndIf
	$v_Socket = TCPConnect($s_IPAddress, 25)
	If $v_Socket = -1 Then
		TCPShutdown()
		SetError(4)
		Return (0)
	EndIf
	Sleep(100)
	$s_Send[0] = "HELO " & $s_FromAddress & @CRLF
	$s_ReplyCode[0] = "220"
	$s_Send[1] = "MAIL FROM: <" & $s_FromAddress & ">" & @CRLF
	$s_ReplyCode[1] = "250"
	$s_Send[2] = "RCPT TO: <" & $s_ToAddress & ">" & @CRLF
	$s_ReplyCode[2] = "250"
	$s_Send[3] = "DATA" & @CRLF
	$s_ReplyCode[3] = "354"
	$s_Send[4] = "From:" & $s_FromName & "< " & $s_FromAddress & " >" & @CRLF
	$s_ReplyCode[4] = ""
	$s_Send[5] = "To:" & $s_ToAddress & @CRLF
	$s_ReplyCode[5] = ""
	$s_Send[6] = "Subject:" & $s_Subject & @CRLF
	$s_ReplyCode[6] = ""
	;$s_Send[7] = "Sender: AutoIt3" & @CRLF
	$s_Send[7] = "Mime-Version: 1.0" & @CRLF
	$s_ReplyCode[7] = ""
	$s_Send[8] = "Content-Type: text/plain; charset=US-ASCII" & @CRLF
	$s_ReplyCode[8] = ""
	$s_Send[9] = @CRLF
	$s_ReplyCode[9] = ""
	
	For $i_Count = 0 To UBound($s_Send) - 1
		$i_SendReturn = TCPSend($v_Socket, $s_Send[$i_Count])
		If $i_SendReturn = 0 Then
			TCPCloseSocket($v_Socket)
			TCPShutdown()
			SetError(5)
			Return 0
		EndIf
		Sleep(100)
		$s_Receive = TCPRecv($v_Socket, 1000)
		If $s_ReplyCode[$i_Count] <> "" And StringLeft($s_Receive, StringLen($s_ReplyCode[$i_Count])) <> $s_ReplyCode[$i_Count] Then
			TCPCloseSocket($v_Socket)
			TCPShutdown()
			SetError(5)
			Return 0
		EndIf
	Next
	Sleep(100)
	For $i_Count = 0 To UBound($as_Body) - 1
		$i_SendReturn = TCPSend($v_Socket, $as_Body[$i_Count] & @CRLF)
		Sleep(100)
		If $i_SendReturn = 0 Then
			TCPCloseSocket($v_Socket)
			TCPShutdown()
			SetError(5)
			Return 0
		EndIf
		$s_Receive = TCPRecv($v_Socket, 1000)
		Sleep(100)
	Next
	$i_SendReturn = TCPSend($v_Socket, @CRLF & "." & @CRLF)
	If $i_SendReturn = 0 Then
		TCPCloseSocket($v_Socket)
		TCPShutdown()
		SetError(5)
		Return 0
	EndIf
	Sleep(100)
	TCPCloseSocket($v_Socket)
	TCPShutdown()
	Return 1
EndFunc   ;==>_INetSmtpMail