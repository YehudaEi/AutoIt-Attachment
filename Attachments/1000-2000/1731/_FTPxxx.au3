;===================================================================================================;
;																									;
; Function Name:    _FTPput()																		;
;																									;
; Description:      Uploads a file to an ftp server.												;
;																									;
; Parameter(s):     $s_p_Host		- 	IP or URL to the host.										;
; 										(ex. '24.158.58.154')										;
;				 	$s_p_PathFile	-	The path and filename.										;
; 										(ex. 'C:\windows\notepad.exe')								;
;					$s_p_Acc		-	Account to log into.										;
;										(ex. 'Sander')												;
;					$s_p_Pwd		-	Password for the account.									;
; 										(ex. 'Monkey')												;
;					$s_p_Cd			-	Path where the file should go to on the server.				;
;										(ex. 'uploads\scripts')										;
;					$i_p_Check		- 	Enable/Disable download checking.							;
;										(ex. 1)														;
;					$s_p_Aftp		-	Additional ftp commands that you want exectued.				;
;										(Executed before the send) (Separate commands by @CRLF)		;
; 										(ex. 'bell')												;
;																									;
; Requirement(s):   None																			;
;																									;
; Notes:			It is possible to send multiple files using wildcards BUT you will				;
;					not be able to check if it was successfull by turning $i_p_Check to 1.			;
;																									;
; Return Value(s):  ($i_p_Check = 0) (Default)														;
;					Always Returns 0																;
;																									;
;					($i_p_Check = 1)																;
;					On Success - Returns 1															;
;                   On Failure - Returns -1															;
;																									;
; Author(s):		(KiXtart) (                                         )							;
;					Andrew Mack																		;
;					Richard H.																		;
;																									;
;					(AutoIt) (Re-Written from scratch)												;
;					Wouter Van Kesteren <w0ut3r88@gmail.com>										;
;																									;
; Example Usage:	_FTPput('24.132.95.223', 'C:\WINDOWS\NOTEPAD.EXE', 'uploads', 'fakepass')		;
;===================================================================================================;

Func _FTPput($s_p_Host, $s_p_PathFile, $s_p_Acc, $s_p_Pwd, $s_p_Cd = '', $i_p_Check = 0, $s_p_Aftp = '')
	
	; Declaring local variables.
	Local $i_p_Return
	
	; Creating a random nummber to minimize the chance of writing to an existing file.
	Local $i_p_Random = Random(100000000, 999999999, 1)
	
	; Creating the file.
	Local $h_p_CmdFile = FileOpen(@TempDir & "\FTPcmds" & $i_p_Random & ".txt", 1)
	
	; Check if wildcards are used.
	If StringInStr($s_p_PathFile, "*") <> 0 Then Local $i_p_Check = 0
	
	; Getting the path and the filename from $s_p_PathFile.
	Local $s_p_Path = StringTrimRight($s_p_PathFile, StringLen($s_p_PathFile) - StringInStr($s_p_PathFile, "\", 0, -1) + 1)
	Local $s_p_File = StringTrimLeft($s_p_PathFile, StringInStr($s_p_PathFile, "\", 0, -1))
	
	; Create an FTP command file if the file is sucsesfully created.
	If $h_p_CmdFile <> -1 Then
		
		; Writing the account and password.
		FileWriteLine($h_p_CmdFile, $s_p_Acc & @CRLF)
		FileWriteLine($h_p_CmdFile, $s_p_Pwd & @CRLF)
		
		; Set the transfermode to binary
		FileWriteLine($h_p_CmdFile, "binary" & @CRLF)
		
		; Additional FTP commands passed to the function are actioned here.
		If $s_p_Aftp <> '' Then FileWriteLine($h_p_CmdFile, $s_p_Aftp & @CRLF)
			
		; Making the destination dir if it doesnot exist
		FileWriteLine($h_p_CmdFile, 'mkdir ' & $s_p_Cd & @CRLF)
		
		; Set the destination dir if one is given. Else 'root' will be used.
		If $s_p_Cd <> '' Then FileWriteLine($h_p_CmdFile, "cd " & $s_p_Cd & @CRLF)
		
		; Set the local directory and send the files.
		FileWriteLine($h_p_CmdFile, "lcd " & $s_p_Path & @CRLF)
		FileWriteLine($h_p_CmdFile, "mput " & $s_p_File & @CRLF)
		
		; If $i_p_Check is set to 1 it will get the transferred file back to a check area so we can confirm it worked.
		If $i_p_Check = 1 Then
			FileWriteLine($h_p_CmdFile, "lcd " & @TempDir & @CRLF)
			FileWriteLine($h_p_CmdFile, "mget " & $s_p_File & @CRLF)
		EndIf
		
		; Closes the FTP connecetion and exits the FTP program.
		FileWriteLine($h_p_CmdFile, "close" & @CRLF)
		FileWriteLine($h_p_CmdFile, "quit" & @CRLF)
		
		; Closes the file.
		FileClose($h_p_CmdFile)
		
	EndIf
	
	; Start FTP with the cmdfile to transfer the file(s) concerned.
	RunWait(@ComSpec & " /c " & 'ftp -v -i -s:' & @TempDir & "\FTPcmds" & $i_p_Random & ".txt " & $s_p_Host, "", @SW_HIDE)
	
	; Setting the return value's.
	If $i_p_Check = 1 And Not FileExists(@TempDir & "\" & $s_p_File) Then
		$i_p_Return = -1
	ElseIf $i_p_Check = 1 And FileExists(@TempDir & "\" & $s_p_File) Then
		$i_p_Return = 1
	Else
		$i_p_Return = 0
	EndIf
	
	; Delete the temp files.
	FileDelete(@TempDir & "\" & $s_p_File)
	FileDelete(@TempDir & "\FTPcmds" & $i_p_Random & ".txt")
	
	; Return the returnvalue.
	Return $i_p_Return
	
EndFunc   ;==>_FTPput

;===================================================================================================;
;																									;
; Function Name:    _FTPdel()																		;
;																									;
; Description:      Deletes a file from an ftp server.												;
;																									;
; Parameter(s):     $s_d_Host		- 	IP or URL to the host.										;
; 										(ex. '24.158.58.154')										;
;				 	$s_d_PathFile	-	The path and filename.										;
; 										(ex. 'uploads\autoitscript.exe')							;
;					$s_d_Acc		-	Account to log into.										;
;										(ex. 'rootacc')												;
;					$s_d_Pwd		-	Password for the account.									;
; 										(ex. 'pass')												;
;					$i_d_Check		- 	Enable/Disable download checking.							;
;										(ex. 1)														;
;					$s_d_Aftp		-	Additional ftp commands that you want exectued.				;
;										(Executed before the send) (Separate commands by @CRLF)		;
; 										(ex. 'bell')												;
;																									;
; Requirement(s):   None																			;
;																									;
; Notes:			It is possible to delete multiple files using wildcards BUT you will			;
;					not be able to check if it was successfull by turning $i_d_Check to 1.			;
;																									;
; Return Value(s):  ($i_d_Check = 0) (Default)														;
;					Always Returns 0																;
;																									;
;					($i_d_Check = 1)																;
;					On Success - Returns 1															;
;					On Failure (B/C the information is incorrect) - Returns -2						;
;                   On Failure (Other) - Returns -1													;
;																									;
; Author(s):		(KiXtart) (                                         )							;
;					Andrew Mack																		;
;					Richard H.																		;
;																									;
;					(AutoIt) (Re-Written from scratch)												;
;					Wouter Van Kesteren <w0ut3r88@gmail.com>										;
;																									;
; Example Usage:	_FTPdel('24.132.95.223', 'uploads\autoitscript.exe', 'rootacc', 'pass', 1)		;
;===================================================================================================;

Func _FTPdel($s_d_Host, $s_d_PathFile, $s_d_Acc, $s_d_Pwd, $i_d_Check = 0, $s_d_Aftp = '')
	
	; Checking of the file is actually there before saying 'omg omg errorrrrrrrrr'
	; srry had to let out my frustration :D
	Local $size = InetGetSize('ftp://' & $s_d_Acc & ':' & $s_d_Pwd & '@' & $s_d_Host & '/' & $s_d_PathFile)
	If $size = 0 Then Return -2
	
	; Declaring local variable.
	Local $i_d_Return
	
	; Creating a random nummber to minimize the chance of writing to an existing file.
	Local $i_d_Random = Random(100000000, 999999999, 1)
	
	; Creating the file.
	Local $h_d_CmdFile = FileOpen(@TempDir & "\FTPcmds" & $i_d_Random & ".txt", 1)
	
	; Check if wildcards are used.
	If StringInStr($s_d_PathFile, "*") <> 0 Then Local $i_d_Check = 0
	
	; Getting the path and the filename from $s_d_PathFile.
	Local $s_d_Path = StringTrimRight($s_d_PathFile, StringLen($s_d_PathFile) - StringInStr($s_d_PathFile, "\", 0, -1) + 1)
	Local $s_d_File = StringTrimLeft($s_d_PathFile, StringInStr($s_d_PathFile, "\", 0, -1))
	
	; Create an FTP command file if the file is sucsesfully created.
	If $h_d_CmdFile <> -1 Then
		
		; Writing the account and password.
		FileWriteLine($h_d_CmdFile, $s_d_Acc & @CRLF)
		FileWriteLine($h_d_CmdFile, $s_d_Pwd & @CRLF)
		
		; Set the transfermode to binary
		FileWriteLine($h_d_CmdFile, "binary" & @CRLF)
		
		; Additional FTP commands passed to the function are actioned here.
		If $s_d_Aftp <> '' Then FileWriteLine($h_d_CmdFile, $s_d_Aftp & @CRLF)
		
		; Set the remote directory and delete the files.
		If $s_d_Path <> '' Then FileWriteLine($h_d_CmdFile, 'cd ' & $s_d_Path & @CRLF)
		FileWriteLine($h_d_CmdFile, "mdelete " & $s_d_File & @CRLF)
		
		; Closes the FTP connecetion and exits the FTP program.
		FileWriteLine($h_d_CmdFile, "close" & @CRLF)
		FileWriteLine($h_d_CmdFile, "quit" & @CRLF)
		
		; Closes the file.
		FileClose($h_d_CmdFile)
		
	EndIf
	
	; Start FTP with the cmdfile to transfer the file(s) concerned.
	RunWait(@ComSpec & " /c " & 'ftp -v -i -s:' & @TempDir & "\FTPcmds" & $i_d_Random & ".txt " & $s_d_Host, "", @SW_HIDE)
	
	; If $i_d_Check is set to 1 it will get the transferred file back to a check area so we can confirm it worked.
	If $i_d_Check = 1 Then
		Local $i_d_Get = InetGet('ftp://' & $s_d_Acc & ':' & $s_d_Pwd & '@' & $s_d_Host & '/' & $s_d_PathFile, @TempDir & "\" & $s_d_File, 1)
	EndIf
	
	; Setting the return value's.
	MsgBox(0, 'Local', $i_d_Get)
	
	If $i_d_Check = 1 And $i_d_Get = 1 Then $i_d_Return = -1
	If $i_d_Check = 1 And $i_d_Get = 0 Then	$i_d_Return = 1
	If $i_d_Check <> 1 Then	$i_d_Return = 0
	
	; Delete the temp files.
	FileDelete(@TempDir & "\" & $s_d_File)
	FileDelete(@TempDir & "\FTPcmds" & $i_d_Random & ".txt")
	
	; Return the returnvalue.
	Return $i_d_Return
	
EndFunc   ;==>_FTPdel

;===================================================================================================;
;																									;
; Function Name:    _FTPadv()																		;
;																									;
; Description:      Sends FTP commands to an ftp server.											;
;																									;
; Parameter(s):     $s_a_Host		- 	IP or URL to the host.										;
; 										(ex. '24.158.58.154')										;
;					$s_a_Acc		-	Account to log into.										;
;										(ex. 'Sander')												;
;					$s_a_Pwd		-	Password for the account.									;
; 										(ex. 'Monkey')												;
;					$s_a_Ftp		-	FTP commands that you want exectued.						;
;										(Separate commands by @CRLF)								;
; 										(ex. 'rename ' & $filename & $newfilename)					;
;																									;
; Requirement(s):   None																			;
;																									;
; Return Value(s):  None																			;
;																									;
; Author(s):		(KiXtart) (                                         )							;
;					Andrew Mack																		;
;					Richard H.																		;
;																									;
;					(AutoIt) (Re-Written from scratch)												;
;					Wouter Van Kesteren <w0ut3r88@gmail.com>										;
;																									;
; Example Usage:	_FTPadv('24.132.95.223', 'upload', 'pass', 'rename ' & $filename & $newfilename);
;===================================================================================================;

Func _FTPadv($s_a_Host, $s_a_Acc, $s_a_Pwd, $s_a_Ftp)
	
	; Creating a random nummber to minimize the chance of writing to an existing file.
	Local $i_a_Random = Random(100000000, 999999999, 1)
	
	; Creating the file.
	Local $h_a_CmdFile = FileOpen(@TempDir & "\FTPcmds" & $i_a_Random & ".txt", 1)
	
	; Create an FTP command file if the file is sucsesfully created.
	If $h_a_CmdFile <> -1 Then
		
		; Writing the account and password.
		FileWriteLine($h_a_CmdFile, $s_a_Acc & @CRLF)
		FileWriteLine($h_a_CmdFile, $s_a_Pwd & @CRLF)
		
		; FTP commands are actioned here.
		FileWriteLine($h_a_CmdFile, $s_a_Ftp & @CRLF)
		
		; Closes the FTP connecetion and exits the FTP program.
		FileWriteLine($h_a_CmdFile, "close" & @CRLF)
		FileWriteLine($h_a_CmdFile, "quit" & @CRLF)
		
		; Closes the file.
		FileClose($h_a_CmdFile)
		
	EndIf
	
	; Start FTP with the cmdfile to transfer the file(s) concerned.
	RunWait(@ComSpec & " /c " & 'ftp -v -i -s:' & @TempDir & "\FTPcmds" & $i_a_Random & ".txt " & $s_a_Host, "", @SW_HIDE)
	
EndFunc   ;==>_FTPadv