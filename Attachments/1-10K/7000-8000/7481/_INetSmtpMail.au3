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
;					$s_helo			- Helo identifier (default @COMPUTERNAME) sometime needed by smtp server
;					$s_first		- send before Helo identifier (default @CRLF) sometime needed by smtp server
;					$s_UserName     - Username used to login to smtp server
;					$s_Password		- Password used to login to smtp server
;					$f_trace		- trace on a splash window (default false = no trace), true = trace window
; Requirement(s):   _Base64 if using login feature
; Return Value(s):  On Success - Returns 1
;                   On Failure - 0  and sets
;									@ERROR = 1		-	Invalid Parameters
;									@ERROR = 2		-	Unable to start TCP
;									@ERROR = 3		-	Unable to resolve IP
;									@ERROR = 4		-	Unable to create socket				(check server url)
;									@ERROR = 5		-	Cannot open SMTP session			(no responce from sever)
;									@ERROR = 5x		-	Cannot Auth Login for SMTP session	(Bad Password?)
;									@ERROR = 50x	-	Cannot send headers
;									@ERROR = 500x	-	Cannot send body
;									@ERROR = 6x		-	Cannot close SMTP session
; Authors:        Original function to send email via TCP 	- Asimzameer
;					Conversion to UDF						- Walkabout
;					Correction	Helo, timeout, trace		- Jpm
;					Correction send before Helo				- Jpm
;					Changed some code, added Login feature	- Mikeytown2
;
;===============================================================================
#include-once
#include <Date.au3>
#include <Constants.au3>

Func _INetSmtpMail($s_FromName, $s_FromAddress, $s_ToAddress, $s_SmtpServer = "", $s_Subject = "", $as_Body = "", $s_helo = "", $s_UserName = "", $s_Password = "", $f_trace = 0)
	
	Local $v_Socket
	Local $s_IPAddress
	Local $i_Count
	Local $s_MxAdd = ""
	
	Local $as_Auth[3]
	Local $as_AuthReplyCode[3];Return code from SMTP server indicating success 250 334 ect...
	
	Local $as_Send[4]
	Local $as_SendReplyCode[4];Return code from SMTP server indicating success 250 334 ect...
	
	Local $as_End[2]
	Local $as_EndReplyCode[2];Return code from SMTP server indicating success 250 334 ect...
	Local $s_Receive
	
	If $s_SmtpServer = "" Then
		$s_MxAdd = 	"Received-Path:" & "<" & $s_FromAddress & ">" & @CRLF _
					& "Received: from localhost[127.0.0.1] by localhost[127.0.0.1] with esmtp (AutoIt)" _
					& ";" & _DateDayOfWeek ( @WDAY, 1) & ", " & @MDAY & " " & _DateMonthOfYear(@MON, 1) _
					& " " & @YEAR & " " & @HOUR & ":" & @MIN & ":" & @SEC & " " _
					& StringRegExpReplace(RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Time Zones\" _
					& RegRead ('HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Control\TimeZoneInformation','StandardName'),'Display'), "[^0-9-]", "") _
					& @CRLF
		;MX Lookup
		$s_Server = StringSplit($s_ToAddress, "@")
		$s_Server = $s_Server[$s_Server[0]]
		$from = StringSplit($s_FromAddress, "@")
		
		$RunPID = Run(@ComSpec & " /c nslookup -type=mx " & $s_Server, "", @SW_HIDE, $STDOUT_CHILD)
		$out = StdoutRead($RunPID)
		While StdoutRead($RunPID, "", True)
			$out &= StdoutRead($RunPID)
		WEnd
		$temp = StringSplit($out, "mail exchanger = ", 1)
		$temp = StringSplit($temp[$temp[0]], @LF)
		$s_SmtpServer = StringReplace(StringStripCR($temp[1]), @LF, "")
	EndIf
	
	If $s_SmtpServer = "" Or $s_FromAddress = "" Or $s_ToAddress = "" Or $s_FromName = "" Or StringLen($s_FromName) > 256 Then
		SetError(1)
		Return 0
	EndIf
	If $s_helo = "" Then $s_helo = @ComputerName
	If TCPStartup() = 0 Then
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
	If $f_trace Then 
		_SmtpTrace("<SYS>  Variables Passed Look OK" & @CRLF)
		_SmtpTrace("<SYS>  Connecting to " & $s_IPAddress & " ("& $s_SmtpServer & ")" &  @CRLF)
	EndIf
	
	$v_Socket = TCPConnect($s_IPAddress, 25)
	If $v_Socket = -1 Then
		TCPShutdown()
		SetError(4)
		Return 0
	EndIf
	If $f_trace Then _SmtpTrace("<SYS>  TCP Connection Established" & @CRLF)
	
	;Login with Username And Password Commands
	$as_Auth[0] = "AUTH LOGIN" & @CRLF
	$as_AuthReplyCode[0] = "334"
	$as_Auth[1] = $s_UserName & @CRLF
	$as_AuthReplyCode[1] = "334"
	$as_Auth[2] = $s_Password & @CRLF
	$as_AuthReplyCode[2] = "235"
	
	;Send Mail Headers
	$as_Send[0] = "MAIL FROM: <" & $s_FromAddress & ">" & @CRLF
	$as_SendReplyCode[0] = "250"
	$as_Send[1] = "RCPT TO: <" & $s_ToAddress & ">" & @CRLF
	$as_SendReplyCode[1] = "250"
	$as_Send[2] = "DATA" & @CRLF
	$as_SendReplyCode[2] = "354"
	
	$as_Send[3] = $s_MxAdd & "From:" & $s_FromName & "<" & $s_FromAddress & ">" & @CRLF & _
			"To:" & "<" & $s_ToAddress & ">" & @CRLF & _
			"Subject:" & $s_Subject & @CRLF & _
			"Mime-Version: 1.0" & @CRLF & _
			"Content-Type: text/plain; charset=US-ASCII" & @CRLF & _
			@CRLF
	$as_SendReplyCode[3] = ""
	
	;body would go in here but that was passed to us all ready
	
	;Close Email and Session
	$as_End[0] = @CRLF & "." & @CRLF
	$as_EndReplyCode[0] = "250"
	$as_End[1] = "QUIT" & @CRLF
	$as_EndReplyCode[1] = "221"
	
	;Start Connection with SMTP Host
	$s_Receive = _GetLastReplyMsg($v_Socket, "220", $f_trace) ;grab the connected message if there
	If @error Then
		_SmtpSend($v_Socket, @CRLF, $f_trace) ;if no welcome screen send return key
		$s_Receive = _GetLastReplyMsg($v_Socket, "220", $f_trace) ;grab the connected message if there
	EndIf
	_SmtpSend($v_Socket, "EHLO" & " " & $s_helo & @CRLF, $f_trace) ;send loginstring, helo or ehlo
	$s_Receive = _GetLastReplyMsg($v_Socket, "250", $f_trace)
	If @error Then
		_SmtpSend($v_Socket, "HELO" & " " & $s_helo & @CRLF, $f_trace)
		$s_Receive = _GetLastReplyMsg($v_Socket, "250", $f_trace)
		If @error Then
			SetError(5)
			Return False
		EndIf
	EndIf
	
	;Send Login
	If $s_UserName And $s_Password Then
		For $i_Count = 0 To (UBound($as_Auth) - 1) Step + 1
			_SmtpSend($v_Socket, $as_Auth[$i_Count ], $f_trace)
			$s_Receive = _GetLastReplyMsg($v_Socket, $as_AuthReplyCode[$i_Count], $f_trace)
			If @error Then
				SetError(50 + $i_Count)
				Return False
			EndIf
		Next
	EndIf
	
	;Send To, From, Ect...
	For $i_Count = 0 To (UBound($as_Send) - 2) Step + 1 ;should be -2 because of smptsend at bottom
		_SmtpSend($v_Socket, $as_Send[$i_Count], $f_trace)
		$s_Receive = _GetLastReplyMsg($v_Socket, $as_SendReplyCode[$i_Count], $f_trace)
		If @error Then
			SetError(500 + $i_Count)
			Return False
		EndIf
	Next
	_SmtpSend($v_Socket, $as_Send[3], $f_trace);send last one, dont need to recieve anything
	
	;Send Body
	For $i_Count = 0 To (UBound($as_Body) - 1) Step + 1
		If StringLeft($as_Body[$i_Count], 1) = "." Then $as_Body[$i_Count] = "." & $as_Body[$i_Count]
		If Not _SmtpSend($v_Socket, $as_Body[$i_Count] & @CRLF, $f_trace) Then
			SetError(5000 + $i_Count)
			Return False
		EndIf
	Next
	
	;Close Message and Connection
	For $i_Count = 0 To (UBound($as_Body) - 1) Step + 1
		_SmtpSend($v_Socket, $as_End[$i_Count], $f_trace)
		$s_Receive = _GetLastReplyMsg($v_Socket, $as_EndReplyCode[$i_Count], $f_trace)
		If @error Then
			SetError(60 + $i_Count)
			Return False
		EndIf
	Next
	
	TCPCloseSocket($v_Socket)
	TCPShutdown()
	Return True
EndFunc   ;==>_INetSmtpMail

; internals routines----------------------------------
;Waits for Reply
Func _GetLastReplyMsg($v_Socket, $i_ReplyCode, $f_trace)
	Local $s_Receive
	Local $i_Count
	For $i_Count = 0 To 20 Step + 1
		$s_Receive = TCPRecv($v_Socket, 1000)
		If $s_Receive = "" Then
		Else
			If $f_trace Then
				_SmtpTrace("<Recv>  " & $s_Receive)
			EndIf
			If StringInStr($s_Receive, $i_ReplyCode) Then
				Return $s_Receive
			EndIf
		EndIf
		Sleep(200) ;will wait a max of 4 seconds for reply
	Next
	SetError(1) ;Recieve Timed out, it never got the right reply code
	Return $s_Receive
EndFunc   ;==>_GetLastReplyMsg

;Trace the I/O to a gui
Func _SmtpTrace($s_DisplayString, $i_Timeout = 0)
	Local $W_TITLE = "SMTP trace"
	Local $g_smtptrace = ControlGetText($W_TITLE, "", "Static1")
	$g_smtptrace &= $s_DisplayString ;& @LF
	If WinExists($W_TITLE) Then
		ControlSetText($W_TITLE, "", "Static1", $g_smtptrace)
	Else
		SplashTextOn($W_TITLE, $g_smtptrace, 450, 700, @DesktopWidth - 450, 100, 4 + 16, "", 8)
	EndIf
	If $i_Timeout Then Sleep($i_Timeout * 1000)
EndFunc   ;==>_SmtpTrace

;send a command/msg to the smtp server
Func _SmtpSend($v_Socket, $s_Command, $f_trace)
	TCPSend($v_Socket, $s_Command)
	If @error Then
		SetError(1)
		Return False
	EndIf
	If $f_trace Then
		_SmtpTrace("<Send>  " & $s_Command)
	EndIf
	Return True
EndFunc   ;==>_SmtpSend