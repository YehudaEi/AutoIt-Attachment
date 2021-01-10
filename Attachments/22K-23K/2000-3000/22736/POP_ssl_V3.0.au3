#include <Constants.au3>
#Include <Array.au3>

Global $_POP_RunPID = 0
Global $_POP_Log = @CRLF
Global $_POP_Debug = False
Global $_POP_Counter = 0
Global $SleepTime = 50

;Main Functions (public)


Func _POP_Connect($POP_Server, $POP_Port, $SSL_Exe_loc, $Debug)
	$_POP_Debug = $Debug
	;Connect To Server Using OpenSSL
	$_POP_RunPID = Run(@ComSpec & " /c " & $SSL_Exe_loc & " s_client -crlf -ign_eof -connect " & $POP_Server & ":" & $POP_Port, "", @SW_HIDE, $STDOUT_CHILD + $STDIN_CHILD + $STDERR_CHILD + $STDERR_MERGED)
	
	;Hide Command Prompt
	WinWait(@SystemDir & "\cmd.exe")
	WinMove(@SystemDir & "\cmd.exe", "", @DesktopWidth, @DesktopHeight)
	WinSetState(@SystemDir & "\cmd.exe", "", @SW_HIDE)
	
	;Read Buffer
	$Buffer = _OpenSSL_ReadBuffer_Lock()
	$_POP_Log &= $Buffer
	
	;Check buffer for reply code
	If _OpenSSL_ChkForCode($Buffer, "+OK ") == 0 Then
		SetError(1) ;Connection Failed
		_OpenSSL_DebugToConsole(@CRLF & @CRLF & "Connection Failed" & @CRLF)
		Return False
	EndIf
	
	;Fix GUI Bug
	_OpenSSL_WriteBuffer_GUI("NOOP" & @CRLF)
	$_POP_Log &= "NOOP" & @CRLF
	;Read Buffer
	$Buffer = _OpenSSL_ReadBuffer()
	$_POP_Log &= $Buffer
	_OpenSSL_DebugToConsole("Read : " & $Buffer & @CRLF)
	
	Return True
EndFunc

Func _POP_Login($Username, $Password)
	;Send Username
	$User = "USER " & $Username & @CRLF
	_OpenSSL_WriteBuffer($User)
	$_POP_Log &= $User
	;Get Responce
	$Buffer = _OpenSSL_ReadBuffer_Lock()
	$_POP_Log &= $Buffer
	If _OpenSSL_ChkForCode($Buffer, "+OK ") == 0 Then
		SetError(3) ;Wrong Username
		_OpenSSL_DebugToConsole(@CRLF & @CRLF & "Wrong Username" & @CRLF)
		Return False
	EndIf
	
	
	;Send Password
	$Pass = "PASS " & $Password & @CRLF
	_OpenSSL_WriteBuffer($Pass)
	$_POP_Log &= $Pass
	;Get Responce
	$Buffer = _OpenSSL_ReadBuffer_Lock()
	$_POP_Log &= $Buffer
	If _OpenSSL_ChkForCode($Buffer, "+OK ") == 0 Then
		SetError(4) ;Sent in a bad username/password
		_OpenSSL_DebugToConsole(@CRLF & @CRLF & "Sent in a bad username/password" & @CRLF)
		Return False
	EndIf
	
	Return True
EndFunc

Func _POP_GetStats()
	;Send Stat
	_OpenSSL_WriteBuffer("STAT" & @CRLF)
	$_POP_Log &= "STAT" & @CRLF
	;Get Responce
	$Buffer = _OpenSSL_ReadBuffer_Lock()
	$_POP_Log &= $Buffer
	If _OpenSSL_ChkForCode($Buffer, "+OK ") == 0 Then
		SetError(5) ;Stats Not Available
		_OpenSSL_DebugToConsole(@CRLF & @CRLF & "Stats Not Available" & @CRLF)
		Return False
	EndIf
	
	$Buffer = StringReplace($Buffer, "+OK ", "")
	
	Return $Buffer
EndFunc

Func _POP_GetList()
	;Request List
	_OpenSSL_WriteBuffer("LIST" & @CRLF)
	$_POP_Log &= "LIST" & @CRLF
	;Get Responce
	$Buffer = _OpenSSL_ReadBuffer_Until(@CRLF & ".")
	$_POP_Log &= $Buffer
	If _OpenSSL_ChkForCode($Buffer, @CRLF & ".") == 0 Then
		SetError(6) ;Couldn't Get List
		_OpenSSL_DebugToConsole(@CRLF & @CRLF & "Couldn't Get List" & @CRLF)
		Return False
	EndIf
	
	$Buffer = StringAddCR($Buffer)
	$Buffer = StringStripWS($Buffer, 4)
	$Buffer = StringSplit($Buffer, @CRLF)
	_ArrayDelete($Buffer, 0)
	_ArrayDelete($Buffer, 0)
	_ArrayPop($Buffer)
	_ArrayPop($Buffer)
	
	Return $Buffer
EndFunc

Func _POP_GetMessage($id_num)
	;Request List
	$Get = "RETR " & $id_num & @CRLF
	_OpenSSL_WriteBuffer($Get)
	$_POP_Log &= $Get
	;Get Responce
	$Buffer = _OpenSSL_ReadBuffer_Until(@CRLF & ".")
	$_POP_Log &= $Buffer
	If _OpenSSL_ChkForCode($Buffer, @CRLF & ".") == 0 Then
		SetError(7) ;Couldn't Get List
		_OpenSSL_DebugToConsole(@CRLF & @CRLF & "Couldn't Get List" & @CRLF)
		Return False
	EndIf
	
	Return $Buffer
EndFunc


Func _POP_Disconnect()
	_OpenSSL_WriteBuffer("QUIT" & @CRLF)
	Sleep($SleepTime)
	_OpenSSL_Kill()
	Return True
EndFunc   ;==>_SMTP_Disconnect




;Support Functions (private)
Func _OpenSSL_ReadBuffer()
	$Buffer = ""
	$MoreToRead = 1
	While $MoreToRead > 0
		$_POP_Counter += 1
		Sleep($SleepTime)
		$temp = StdoutRead($_POP_RunPID)
		$Buffer &= $temp
		;_OpenSSL_DebugToConsole("Read #" & $_POP_Counter & ": "& $temp & @CRLF )
		$MoreToRead = @extended
	WEnd
	Return $Buffer
EndFunc   ;==>_SMTP_ReadBuffer

Func _OpenSSL_ReadBuffer_Lock()
	$Buffer = ""
	$len = StringLen($Buffer)
	For $x = 0 To 250 Step +1
		$Buffer = _OpenSSL_ReadBuffer()
		If StringLen($Buffer) > 0 Then
			ExitLoop
		EndIf
	Next
	_OpenSSL_DebugToConsole("Read : " & $Buffer & @CRLF)
	_OpenSSL_DebugToConsole("ReadBuffer_Lock ran " & $x & " times" & @CRLF)
	Return $Buffer
EndFunc   ;==>_SMTP_ReadBuffer_Lock

Func _OpenSSL_ReadBuffer_Until($code)
	$Buffer = ""
	;Wait up to 25 seconds
	For $x = 0 To 500 Step +1
		$Buffer &= _OpenSSL_ReadBuffer()
		$chk = _OpenSSL_ChkForCode($Buffer, $code)
		If $chk > 0 Then
			_OpenSSL_DebugToConsole("Found " & $code & " at " & $chk & ": " & $Buffer & @CRLF)
			ExitLoop
		EndIf
		Sleep($SleepTime)
	Next
	_OpenSSL_DebugToConsole("ReadBuffer_Until ran " & $x & " times" & @CRLF)
	Return $Buffer
EndFunc   ;==>_SMTP_ReadBuffer_Until

Func _OpenSSL_ChkForCode($Buffer, $code)
	Return StringInStr($Buffer, $code)
EndFunc   ;==>_SMTP_ChkForCode

Func _OpenSSL_WriteBuffer_GUI($Msg)
	WinSetState(@SystemDir & "\cmd.exe", "", @SW_SHOW)
	BlockInput(1)
	WinActivate(@SystemDir & "\cmd.exe")
	WinWaitActive(@SystemDir & "\cmd.exe")
	Send($Msg & "{ENTER}{NUMPADENTER}")
	BlockInput(0)
	WinSetState(@SystemDir & "\cmd.exe", "", @SW_HIDE)
	_OpenSSL_DebugToConsole("Write: " & $Msg & @CRLF)
	Sleep($SleepTime)
EndFunc   ;==>_SMTP_WriteBuffer_GUI

Func _OpenSSL_WriteBuffer($Msg)
	StdinWrite($_POP_RunPID, $Msg)
	_OpenSSL_DebugToConsole("Write: " & $Msg & @CRLF)
	Sleep($SleepTime)
EndFunc   ;==>_SMTP_WriteBuffer

Func _OpenSSL_Kill()
	StdioClose($_POP_RunPID)
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

Func _OpenSSL_DebugToConsole($string)
	If $_POP_Debug Then
		ConsoleWrite(StringStripWS($string, 4))
	EndIf
EndFunc   ;==>_SMTP_DebugToConsole