#include <Constants.au3>
Global $_SMTP_RunPID = 0
Global $_SMTP_Log = @CRLF
Global $_SMTP_Debug = False
Global $_SMTP_Counter = 0
Global $SleepTime = 50

;Main Functions (public)

Func _SMTP_Connect($SMTP_Server, $SMTP_Port, $SSL_Exe_loc, $Debug)
	$_SMTP_Debug = $Debug
	;Connect To Server Using OpenSSL
	$_SMTP_RunPID = Run(@ComSpec & " /c " & $SSL_Exe_loc & " s_client -crlf -ign_eof -connect " & $SMTP_Server & ":" & $SMTP_Port, "", @SW_HIDE, $STDOUT_CHILD + $STDIN_CHILD + $STDERR_CHILD + $STDERR_MERGED)
	
	;Hide Command Prompt
	WinWait(@SystemDir & "\cmd.exe")
	WinMove(@SystemDir & "\cmd.exe", "", @DesktopWidth, @DesktopHeight)
	WinSetState(@SystemDir & "\cmd.exe", "", @SW_HIDE)
	
	;Read Buffer
	$Buffer = _SMTP_ReadBuffer_Lock();_SMTP_ReadBuffer_Until("220 ")
	$_SMTP_Log &= $Buffer
	
	;Check buffer for reply code
	If _SMTP_ChkForCode($Buffer, "220 ") == 0 Then
		SetError(1) ;Connection Failed
		_SMTP_DebugToConsole(@CRLF & @CRLF & "Connection Failed" & @CRLF)
		Return False
	EndIf
	
	;Send Hello
	$hello = "ehlo " & @ComputerName & @CRLF
	_SMTP_WriteBuffer_GUI($hello)
	_SMTP_WriteBuffer($hello)
	$_SMTP_Log &= $hello
	
	;Check buffer for reply code
	$Buffer = _SMTP_ReadBuffer_Lock();_SMTP_ReadBuffer_Until("250 ")
	$_SMTP_Log &= $Buffer
	If _SMTP_ChkForCode($Buffer, "250 ") == 0 Then
		SetError(2) ;GUI Input Failed
		_SMTP_DebugToConsole(@CRLF & @CRLF & "GUI Input Failed" & @CRLF)
		Return False
	EndIf
	
	;SSL Connection Ready
	Return True
EndFunc   ;==>_SMTP_Connect

Func _SMTP_Login($Username, $Password)
	;Send Login Request
	$Login = "AUTH LOGIN" & @CRLF
	_SMTP_WriteBuffer($Login)
	$_SMTP_Log &= $Login
	;Get Responce
	$Buffer = _SMTP_ReadBuffer_Lock();_SMTP_ReadBuffer_Until("334 ")
	$_SMTP_Log &= $Buffer
	If _SMTP_ChkForCode($Buffer, "334 ") == 0 Then
		SetError(3) ;Doesn't support Authenticated Logins
		_SMTP_DebugToConsole(@CRLF & @CRLF & "Doesn't support Authenticated Logins" & @CRLF)
		Return False
	EndIf
	
	
	;Send Username
	_SMTP_WriteBuffer($Username & @CRLF)
	$_SMTP_Log &= $Username & @CRLF
	;Get Responce
	$Buffer = _SMTP_ReadBuffer_Lock();_SMTP_ReadBuffer_Until("334 ")
	$_SMTP_Log &= $Buffer
	If _SMTP_ChkForCode($Buffer, "334 ") == 0 Then
		SetError(4) ;Sent in a bad username
		_SMTP_DebugToConsole(@CRLF & @CRLF & "Sent in a bad username" & @CRLF)
		Return False
	EndIf
	
	
	;Send Password
	_SMTP_WriteBuffer($Password & @CRLF)
	$_SMTP_Log &= $Password & @CRLF
	;Get Responce
	$Buffer = _SMTP_ReadBuffer_Until("235 ")
	$_SMTP_Log &= $Buffer
	If _SMTP_ChkForCode($Buffer, "235 ") == 0 Then
		SetError(5) ;Sent in a bad username/password
		_SMTP_DebugToConsole(@CRLF & @CRLF & "Sent in a bad username/password" & @CRLF)
		Return False
	EndIf
	
	
	Return True
EndFunc   ;==>_SMTP_Login


Func _SMTP_SendEmail($To, $From, $FromName, $Subject, $Body)
	
	;Set From Address
	$FromLine = "MAIL FROM: <" & $From & ">" & @CRLF
	_SMTP_WriteBuffer($FromLine)
	$_SMTP_Log &= $FromLine
	;Get Responce
	$Buffer = _SMTP_ReadBuffer_Lock();_SMTP_ReadBuffer_Until("250 ")
	$_SMTP_Log &= $Buffer
	If _SMTP_ChkForCode($Buffer, "250 ") == 0 Then
		SetError(6) ;Sent a bad From Address
		_SMTP_DebugToConsole(@CRLF & @CRLF & "Sent a bad From Address" & @CRLF)
		Return False
	EndIf
	
	;Set To Address
	$ToLine = "RCPT TO: <" & $To & ">" & @CRLF
	_SMTP_WriteBuffer($ToLine)
	$_SMTP_Log &= $ToLine
	;Get Responce
	$Buffer = _SMTP_ReadBuffer_Lock();_SMTP_ReadBuffer_Until("250 ")
	$_SMTP_Log &= $Buffer
	If _SMTP_ChkForCode($Buffer, "250 ") == 0 Then
		SetError(7) ;Sent a bad To Address
		_SMTP_DebugToConsole(@CRLF & @CRLF & "Sent a bad To Address" & @CRLF)
		Return False
	EndIf
	
	;Send In Accept Data Command
	$Data = "DATA" & @CRLF
	_SMTP_WriteBuffer($Data)
	$_SMTP_Log &= $Data
	;Get Responce
	$Buffer = _SMTP_ReadBuffer_Until("354 ")
	$_SMTP_Log &= $Buffer
	If _SMTP_ChkForCode($Buffer, "354 ") == 0 Then
		SetError(7) ;Server not ready for data
		_SMTP_DebugToConsole(@CRLF & @CRLF & "Server not ready for data" & @CRLF)
		Return False
	EndIf
	
	;Send Email Body and send email on its way!
	$EmailBody = "" & _
			"From:" & $FromName & "<" & $From & ">" & @CRLF & _
			"To:" & "<" & $To & ">" & @CRLF & _
			"Subject:" & $Subject & @CRLF & _
			"Mime-Version: 1.0" & @CRLF & _
			"Content-Type: text/plain; charset=US-ASCII" & @CRLF & _
			@CRLF & $Body & _
			@CRLF & @CRLF & "." & @CRLF
	
	_SMTP_WriteBuffer($EmailBody)
	$_SMTP_Log &= $EmailBody
	;Get Responce
	$Buffer = _SMTP_ReadBuffer_Until("250 ")
	$_SMTP_Log &= $Buffer
	If _SMTP_ChkForCode($Buffer, "250 ") == 0 Then
		SetError(8) ;Email Not Sent
		_SMTP_DebugToConsole(@CRLF & @CRLF & "Email Possibly Not Sent" & @CRLF)
		Return False
	EndIf
	
	Return True
EndFunc   ;==>_SMTP_SendEmail

Func _SMTP_Disconnect()
	_SMTP_WriteBuffer("Quit" & @CRLF)
	Sleep($SleepTime)
	_SMTP_Kill()
	Return True
EndFunc   ;==>_SMTP_Disconnect


;Support Functions (private)
Func _SMTP_ReadBuffer()
	$Buffer = ""
	$MoreToRead = 1
	While $MoreToRead > 0
		$_SMTP_Counter += 1
		Sleep($SleepTime)
		$temp = StdoutRead($_SMTP_RunPID)
		$Buffer &= $temp
		;_SMTP_DebugToConsole("Read #" & $_SMTP_Counter & ": "& $temp & @CRLF )
		$MoreToRead = @extended
	WEnd
	Return $Buffer
EndFunc   ;==>_SMTP_ReadBuffer

Func _SMTP_ReadBuffer_Lock()
	$Buffer = ""
	$len = StringLen($Buffer)
	For $x = 0 To 250 Step +1
		$Buffer = _SMTP_ReadBuffer()
		If StringLen($Buffer) > 0 Then
			ExitLoop
		EndIf
	Next
	_SMTP_DebugToConsole("Read : " & $Buffer & @CRLF)
	_SMTP_DebugToConsole("ReadBuffer_Lock ran " & $x & " times" & @CRLF)
	Return $Buffer
EndFunc   ;==>_SMTP_ReadBuffer_Lock

Func _SMTP_ReadBuffer_Until($code)
	$Buffer = ""
	;Wait up to 25 seconds
	For $x = 0 To 500 Step +1
		$Buffer &= _SMTP_ReadBuffer()
		$chk = _SMTP_ChkForCode($Buffer, $code)
		If $chk > 0 Then
			_SMTP_DebugToConsole("Found " & $code & " at " & $chk & ": " & $Buffer & @CRLF)
			ExitLoop
		EndIf
		Sleep($SleepTime)
	Next
	_SMTP_DebugToConsole("ReadBuffer_Until ran " & $x & " times" & @CRLF)
	Return $Buffer
EndFunc   ;==>_SMTP_ReadBuffer_Until


Func _SMTP_ChkForCode($Buffer, $code)
	Return StringInStr($Buffer, $code)
EndFunc   ;==>_SMTP_ChkForCode

Func _SMTP_WriteBuffer_GUI($Msg)
	WinSetState(@SystemDir & "\cmd.exe", "", @SW_SHOW)
	BlockInput(1)
	WinActivate(@SystemDir & "\cmd.exe")
	WinWaitActive(@SystemDir & "\cmd.exe")
	Send($Msg & "{ENTER}{NUMPADENTER}")
	BlockInput(0)
	WinSetState(@SystemDir & "\cmd.exe", "", @SW_HIDE)
	_SMTP_DebugToConsole("Write: " & $Msg & @CRLF)
	Sleep($SleepTime)
EndFunc   ;==>_SMTP_WriteBuffer_GUI

Func _SMTP_WriteBuffer($Msg)
	StdinWrite($_SMTP_RunPID, $Msg)
	_SMTP_DebugToConsole("Write: " & $Msg & @CRLF)
	Sleep($SleepTime)
EndFunc   ;==>_SMTP_WriteBuffer

Func _SMTP_Kill()
	StdioClose($_SMTP_RunPID)
	Sleep(1000)
	If ProcessExists("openssl.exe") Then
		$s = MsgBox(4, "Kill Child Processes?", "Do you want to kill the command prompt and openssl?")
		If $s = 6 Then
			ProcessClose("cmd.exe")
			ProcessExists("openssl.exe")
			While ProcessExists("openssl.exe")
				ProcessClose("cmd.exe")
				ProcessClose("openssl.exe")
			WEnd
		EndIf
	EndIf
EndFunc   ;==>_SMTP_Kill

Func _SMTP_DebugToConsole($string)
	If $_SMTP_Debug Then
		ConsoleWrite(StringStripWS($string, 4))
	EndIf
EndFunc   ;==>_SMTP_DebugToConsole