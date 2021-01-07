#region _FtpOpen

;===============================================================================
;
; Function Name:    _FtpOpen()
;
; Description:      Connects to an Ftp server.
;
; Parameter(s):     (InternetConnect)
;					$s_ServerName 		- Server name/ip.
;                   $s_Username  		- Username.
;                   $s_Password			- Password.
;                   $i_ServerPort  		- Server port ( 0 is default (21) )
;					1			- Type of service to access.
;					$l_Flags			- Special flags.
;
; 					(InternetOpen)
;					$s_Agent      	- Random name. ( like "myftp" )
;                   $l_AccessType 	- I dont got a clue what this does.
;                   $s_ProxyName  	- ProxyName.
;                   $s_ProxyBypass	- ProxyByPasses's.
;                   $l_Flags2      	- Special flags.
;
; Requirement(s):   DllCall, wininet.dll
;
; Return Value(s):  On Success - Returns 2 indentifier's.
;                   On Failure - 0  and sets @ERROR
;
; Author(s):        Wouter van Kesteren
;
;===============================================================================

Func _FtpOpen($s_ServerName, $s_Username = '', $s_Password = '', $i_ServerPort = 0, $l_Flags = 0, $s_Agent = 'AutoIt v3', $l_AccessType = 1, $s_ProxyName = '', $s_ProxyBypass = '', $l_Flags2 = 0)
	
	Local $h_dll = DllOpen('wininet.dll')
	
	Local $ai_InternetOpen = DllCall($h_dll, 'long', 'InternetOpen', 'str', $s_Agent, 'long', $l_AccessType, 'str', $s_ProxyName, 'str', $s_ProxyBypass, 'long', $l_Flags2)
	If @error Or $ai_InternetOpen[0] = 0 Then
		DllClose($h_dll)
		SetError(1)
		Return 0
	EndIf
	
	Local $ai_InternetConnect = DllCall($h_dll, 'long', 'InternetConnect', 'long', $ai_InternetOpen[0], 'str', $s_ServerName, 'int', $i_ServerPort, 'str', $s_Username, 'str', $s_Password, 'long', 1, 'long', $l_Flags, 'long', 0)
	If @error Or $ai_InternetConnect[0] = 0 Then
		DllCall($h_dll, 'int', 'InternetCloseHandle', 'long', $ai_InternetOpen[0])
		DllClose($h_dll)
		SetError(2)
		Return 0
	EndIf
	
	Local $ai_Return[3] = [$ai_InternetOpen[0], $ai_InternetConnect[0], $h_dll]
	
	Return $ai_Return
	
EndFunc   ;==>_FtpOpen

#endregion

#region _FtpClose

;===============================================================================
;
; Function Name:    _FtpClose()
;
; Description:      Closes the _FtpOpen session.
;
; Parameter(s):     $l_InternetSession	- The Array from _FtpOpen()
;
; Requirement(s):   DllCall, wininet.dll
;
; Return Value(s):  Always Returns 0
;
; Author(s):        Wouter van Kesteren
;
;===============================================================================

Func _FtpClose($l_FtpSession)
	
	DllCall($l_FtpSession[2], 'int', 'InternetCloseHandle', 'long', $l_FtpSession[1])
	DllCall($l_FtpSession[2], 'int', 'InternetCloseHandle', 'long', $l_FtpSession[0])
	DllClose($l_FtpSession[2])
	
EndFunc   ;==>_FtpClose

#endregion

#region _FtpPutFile

;===============================================================================
;
; Function Name:    _FtpPutFile()
;
; Description:      Puts an file on an Ftp server.
;
; Parameter(s):     $l_FtpSession	- The Array from _FtpOpen()
;                   $s_LocalFile 	- The local file.
;                   $s_RemoteFile  	- The remote Location for the file.
;					$i_overwrite	- Overwrite ?
;                   $l_Flags		- Special flags.
;
; Requirement(s):   DllCall, wininet.dll
;
; Return Value(s):  On Exists  - 2
;					On Success - 1
;                   On Failure - 0
;
; Author(s):        Wouter van Kesteren
;
;===============================================================================

Func _FtpPutFile($l_FtpSession, $s_LocalFile, $s_RemoteFile, $i_overwrite = 1, $l_Flags = 0)
	
	If StringLeft($s_RemoteFile, 1) = '/' Then $s_RemoteFile = StringTrimLeft($s_RemoteFile, 1)
	
	If $i_overwrite = 0 Then
		
		Local $av_FtpOpenFile = DllCall($l_FtpSession[2], 'int', 'FtpOpenFile', 'long', $l_FtpSession[1], 'str', $s_RemoteFile, 'long', 0x80000000, 'long', $l_Flags, 'long', 0)
		DllCall($l_FtpSession[2], 'int', 'InternetCloseHandle', 'long', $av_FtpOpenFile[0])
		If $av_FtpOpenFile[0] <> 0 Then Return 2
		
	EndIf
	
	Local $ai_FtpPutFile = DllCall($l_FtpSession[2], 'int', 'FtpPutFile', 'long', $l_FtpSession[1], 'str', $s_LocalFile, 'str', $s_RemoteFile, 'long', $l_Flags, 'long', 0)
	If @error Or $ai_FtpPutFile[0] = 0 Then
		SetError(1)
		Return 0
	EndIf
	
	Return $ai_FtpPutFile[0]
	
EndFunc   ;==>_FtpPutFile

#endregion

#region _FtpGetFile

;===============================================================================
;
; Function Name:    _FtpGetFile()
;
; Description:      Puts an file on an Ftp server.
;
; Parameter(s):     $l_FtpSession	- The Array from _FtpOpen()
;                   $s_RemoteFile  	- The remote Location for the file.
;					$i_overwrite	- Fail If Local File Exists?
;                   $s_LocalFile  	- The local file.
;					$l_Flags_a_a	- Flags And Attributes
;                   $l_Flags		- Special flags.
;
; Requirement(s):   DllCall, wininet.dll
;
; Return Value(s):  On Success - 1
;                   On Failure - 0
;
; Author(s):        Wouter van Kesteren
;
;===============================================================================

Func _FtpGetFile($l_FtpSession, $s_RemoteFile, $s_LocalFile, $i_overwrite = 0, $l_Flags_a_a = 0, $l_Flags = 0)
	
	Local $ai_FtpPutFile = DllCall($l_FtpSession[2], 'int', 'FtpGetFile', 'long', $l_FtpSession[1], 'str', $s_RemoteFile, 'str', $s_LocalFile, 'int', $i_overwrite, 'long', $l_Flags_a_a, 'long', $l_Flags, 'long', 0)
	If @error Or $ai_FtpPutFile[0] = 0 Then
		SetError(1)
		Return 0
	EndIf
	
	Return $ai_FtpPutFile[0]
	
EndFunc   ;==>_FtpGetFile

#endregion

#region _FtpDelFile

;===============================================================================
;
; Function Name:    _FtpDelFile()
;
; Description:      Delete an file from an Ftp server.
;
; Parameter(s):     $l_FtpSession	- The Array from _FtpOpen()
;                   $s_RemoteFile  	- The remote Location for the file.
;
; Requirement(s):   DllCall, wininet.dll
;
; Return Value(s):  On Success - 1
;                   On Failure - 0
;
; Author(s):        Wouter van Kesteren
;
;===============================================================================

Func _FtpDelFile($l_FtpSession, $s_RemoteFile)
	
	Local $ai_FtpPutFile = DllCall($l_FtpSession[2], 'int', 'FtpDeleteFile', 'long', $l_FtpSession[1], 'str', $s_RemoteFile)
	If @error Or $ai_FtpPutFile[0] = 0 Then
		SetError(1)
		Return 0
	EndIf
	
	Return $ai_FtpPutFile[0]
	
EndFunc   ;==>_FtpDelFile

#endregion

#region _FtpRenameFile

;===============================================================================
;
; Function Name:    _FtpRenameFile()
;
; Description:      Renames an file on an Ftp server.
;
; Parameter(s):     $l_FtpSession	- The Array from _FtpOpen()
;                   $s_Existing 	- The old file name.
;                   $s_New  		- The new file name.
;
; Requirement(s):   DllCall, wininet.dll
;
; Return Value(s):  On Success - 1
;                   On Failure - 0
;
; Author(s):        Wouter van Kesteren
;
;===============================================================================

Func _FtpRenameFile($l_FtpSession, $s_Existing, $s_New)
	
	Local $ai_FtpRenameFile = DllCall($l_FtpSession[2], 'int', 'FtpRenameFile', 'long', $l_FtpSession[1], 'str', $s_Existing, 'str', $s_New)
	If @error Or $ai_FtpRenameFile[0] = 0 Then
		SetError(1)
		Return 0
	EndIf
	
	Return $ai_FtpRenameFile[0]
	
EndFunc   ;==>_FtpRenameFile

#endregion

#region _FtpMakeDir

;===============================================================================
;
; Function Name:    _FtpMakeDir()
;
; Description:      Makes an Directory on an Ftp server.
;
; Parameter(s):     $l_FtpSession	- The Array from _FtpOpen()
;                   $s_Remote 		- The file name to be deleted.
;
; Requirement(s):   DllCall, wininet.dll
;
; Return Value(s):  On Success - 1
;                   On Failure - 0
;
; Author(s):        Wouter van Kesteren
;
;===============================================================================

Func _FtpMakeDir($l_FtpSession, $s_Remote)
	
	Local $ai_FtpMakeDir = DllCall($l_FtpSession[2], 'int', 'FtpCreateDirectory', 'long', $l_FtpSession[1], 'str', $s_Remote)
	If @error Or $ai_FtpMakeDir[0] = 0 Then
		SetError(1)
		Return 0
	EndIf
	
	Return $ai_FtpMakeDir[0]
	
EndFunc   ;==>_FtpMakeDir

#endregion

#region _FtpDelDir

;===============================================================================
;
; Function Name:    _FtpDelDir()
;
; Description:      Delete's an Directory on an Ftp server.
;
; Parameter(s):     $l_FtpSession	- The Array from _FtpOpen()
;                   $s_Remote 		- The Directory to be deleted.
;
; Requirement(s):   DllCall, wininet.dll
;
; Return Value(s):  On Success - 1
;                   On Failure - 0
;
; Author(s):        Wouter van Kesteren
;
;===============================================================================

Func _FtpDelDir($l_FtpSession, $s_Remote)
	
	Local $ai_FtpDelDir = DllCall($l_FtpSession[2], 'int', 'FtpRemoveDirectory', 'long', $l_FtpSession[1], 'str', $s_Remote)
	If @error Or $ai_FtpDelDir[0] = 0 Then
		SetError(1)
		Return 0
	EndIf
	
	Return $ai_FtpDelDir[0]
	
EndFunc   ;==>_FtpDelDir

#endregion

#region _FtpCommand

;===============================================================================
;
; Function Name:    _FtpCommand()
;
; Description:      Sends a command to the server.
;
; Parameter(s):     $l_InternetSession	- The Array from _FtpOpen()
;
; Requirement(s):   DllCall, wininet.dll
;
; Return Value(s):  On Success - 1
;                   On Failure - Returns 0 and sets @error
;
; Author(s):        Wouter van Kesteren
;
;===============================================================================

Func _FtpCommand($l_FtpSession, $s_Command, $l_Flags = 0, $b_ExpectResponse = False)
	
;~ 	$l_FtpSession = $l_FtpSession[1]
;~
;~ 	#cs
;~ 		BOOL FtpCommand(
;~ 		HINTERNET hConnect,
;~ 		BOOL fExpectResponse,
;~ 		DWORD dwFlags,
;~ 		LPCTSTR lpszCommand,
;~ 		DWORD_PTR dwContext,
;~ 		HINTERNET* phFtpCommand
;~ 		);
;~ 	#ce
;~
;~ 	$av_FtpCommand = DllCall($l_FtpSession[2], 'int', 'FtpCommand', 'long', $l_FtpSession, 'int', $b_ExpectResponse, 'long', $l_Flags, '
	
EndFunc   ;==>_FtpCommand

#endregion

#region _FtpFindFirstFile

;===============================================================================
;
; Function Name:    _FtpFindFirstFile()
;
; Description:      Closes the _FtpOpen session.
;
; Parameter(s):     $l_FtpSession	- The Array from _FtpOpen()
;                   $s_RemoteFile  	- The remote Location for the file.
;                   $l_Flags		- Special flags.
;
; Requirement(s):   DllCall, wininet.dll
;
; Return Value(s):  On Success - An array (see notes.)
;                   On Failure - 0
;
; Author(s):        Wouter van Kesteren
;
;===============================================================================

Func _FtpFindFirstFile($l_FtpSession, $s_RemoteFile = '', $l_Flags = 0x80000000)
	
;~ 	$l_FtpSession = $l_FtpSession[1]
;~
;~ 	Local $v_Struct = DllStructCreate('dword;dword[2];dword[2];dword[2];dword;dword;dword;dword;char[260];char[14]')
;~
;~ 	Local $ai_FtpFindFirstFile = DllCall($l_FtpSession[2], 'int', 'FtpFindFirstFile', 'long', $l_FtpSession, 'str', $s_RemoteFile, 'ptr', DllStructGetPtr($v_Struct), 'long', $l_Flags, 'long', 0)
;~ 	If @error Or $ai_FtpFindFirstFile[0] = 0 Then
;~ 		SetError(1)
;~ 		Return 0
;~ 	EndIf
;~
;~ 	Local $av_R[14]
;~
;~ 	$av_R[0] = DllStructGetData($v_Struct, 1)
;~
;~ 	$av_R[1] = DllStructGetData($v_Struct, 2, 1)
;~ 	$av_R[2] = DllStructGetData($v_Struct, 2, 2)
;~ 	$av_R[3] = DllStructGetData($v_Struct, 3, 1)
;~ 	$av_R[4] = DllStructGetData($v_Struct, 3, 2)
;~ 	$av_R[5] = DllStructGetData($v_Struct, 4, 1)
;~ 	$av_R[6] = DllStructGetData($v_Struct, 4, 2)
;~
;~ 	For $i = 7 to 12
;~ 		$av_R[$i] = DllStructGetData($v_Struct, $i)
;~ 	Next
;~
;~ 	DllStructDelete($v_Struct)
;~
;~ 	$av_R[13] = $ai_FtpFindFirstFile[0]
;~
;~ 	Return $av_R
	
	
EndFunc   ;==>_FtpFindFirstFile

#endregion

#region _FtpFindNextFile

Func _FtpFindNextFile($l_FtpSession, $h_Find)
	
;~ 	Local $v_Struct = DllStructCreate('dword;dword[2];dword[2];dword[2];dword;dword;dword;dword;char[260];char[14]')
	
;~ 	$av_InternetFindNextFile = DllCall($l_FtpSession[2], 'int', 'InternetFindNextFile', 'long', $h_Find, 'ptr', DllStructGetPtr($v_Struct))
;~ 	If @error Or $av_InternetFindNextFile[0] = 0 Then
;~ 		SetError(1)
;~ 		Return 0
;~ 	EndIf
	
;~ 	$av_InternetFindNextFile = DllStructGetData($v_Struct, 8)
;~ 	DllStructDelete($v_Struct)
	
;~ 	return $av_InternetFindNextFile
	
EndFunc   ;==>_FtpFindNextFile

#endregion