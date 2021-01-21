; define some constants - can be used with _FTPPutFile and _FTPGetFile and ftp open flags
Const $INTERNET_FLAG_PASSIVE = 0x08000000
Const $INTERNET_FLAG_TRANSFER_ASCII = 0x00000001
Const $INTERNET_FLAG_TRANSFER_BINARY = 0x00000002
Const $INTERNET_DEFAULT_FTP_PORT = 21
Const $INTERNET_SERVICE_FTP = 1

$__ftp_hWinInetDll = DllOpen( 'wininet.dll' )
If $__ftp_hWinInetDll == -1 Then
	ConsoleWrite( "-- ERROR FROM FTP.au3: Unable to open WinInet.dll" & @LF )
	$__ftp_hWinInetDll = 'wininet.dll'
EndIf

Func _FTPCleanUp()
	If $__ftp_hWinInetDll <> 'wininet.dll' Then
		DllClose( $__ftp_hWinInetDll )
		$__ftp_hWinInetDll = 'wininet.dll'
	EndIf
EndFunc


Func _FTPListFiles($l_FTPSession, $l_search = "" , $l_Flags = 0x00000001, $l_Context = 0)
    $str = "dword;int64;int64;int64;dword;dword;dword;dword;char[256];char[14]"
    $WIN32_FIND_DATA = DllStructCreate($str)
    Local $callFindFirst = DllCall($__ftp_hWinInetDll, 'int', 'FtpFindFirstFile', 'long', $l_FTPSession, 'str', $l_search&Chr(0), 'ptr', DllStructGetPtr($WIN32_FIND_DATA), 'long', $l_Flags, 'long', $l_Context)
    If Not $callFindFirst[0] Then
        ConsoleWrite( "--- FTP LIST: No Files Found "&@LF)
        Return 0
    EndIf
    $ret = ""
    While 1
        If DllStructGetData($WIN32_FIND_DATA, 1) <> 16 Then $ret = $ret & DllStructGetData($WIN32_FIND_DATA, 9) & "|"
        Local $callFindNext = DllCall($__ftp_hWinInetDll, 'int', 'InternetFindNextFile', 'long', $callFindFirst[0], 'ptr', DllStructGetPtr($WIN32_FIND_DATA))
        If Not $callFindNext[0] Then
            ExitLoop
        EndIf
    WEnd
    $WIN32_FIND_DATA = 0
    Return StringTrimRight($ret, 1)
EndFunc ;==>_FTPListFiles

;===============================================================================
;
; Function Name:    _FTPCommand()
; Description:      Sends a command to an FTP server.
; Parameter(s):     $l_FTPSession    - The Long from _FTPOpen()
;            $s_FTPCommand     - Commad string to send to FTP Server
;            $l_ExpectResponse   - Data socket for response in Async mode
;            $s_Context         -  A pointer to a variable that contains an application-defined
;                      value used to identify the application context in callback operations
;            $s_Handle - A pointer to a handle that is created if a valid data socket is opened.
;                The $s_ExpectResponse parameter must be set to TRUE for phFtpCommand to be filled.
;
; Requirement(s):   DllCall, wininet.dll
; Return Value(s):  On Success - Returns an indentifier.
;                   On Failure - 0  and sets @ERROR
; Author(s):        Bill Mezian
;
;    Command Examples: depends on server syntax. The following is for
;    Binary transfer, ASCII transfer, Passive transfer mode (used with firewalls)
;    'type I' 'type A'  'pasv'
;
;===============================================================================

Func _FTPCommand($l_FTPSession, $s_FTPCommand, $l_Flags = 0x00000001, $l_ExpectResponse = 0, $l_Context = 0, $s_Handle = '')

	Local $ai_FTPCommand = DllCall($__ftp_hWinInetDll, 'int', 'FtpCommand', 'long', $l_FTPSession, 'long', $l_ExpectResponse, 'long', $l_Flags, 'str', $s_FTPCommand, 'long', $l_Context, 'str', $s_Handle)
    If @error OR $ai_FTPCommand[0] = 0 Then
        SetError(-1)
        Return 0
    EndIf
	
    Return $ai_FTPCommand[0]
    
EndFunc;==> _FTPCommand()

;===============================================================================
;
; Function Name:    _FTPOpen()
; Description:      Opens an FTP session.
; Parameter(s):     $s_Agent      	- Random name. ( like "myftp" )
;                   $l_AccessType 	- I dont got a clue what this does.
;                   $s_ProxyName  	- ProxyName.
;                   $s_ProxyBypass	- ProxyByPasses's.
;                   $l_Flags       	- Special flags.
; Requirement(s):   DllCall, wininet.dll
; Return Value(s):  On Success - Returns an indentifier.
;                   On Failure - 0  and sets @ERROR
; Author(s):        Wouter van Kesteren.
;
;===============================================================================

Func _FTPOpen($s_Agent, $l_AccessType = 1, $s_ProxyName = '', $s_ProxyBypass = '', $l_Flags = 0x10000000  )
	
	Local $ai_InternetOpen = DllCall($__ftp_hWinInetDll, 'long', 'InternetOpen', 'str', $s_Agent, 'long', $l_AccessType, 'str', $s_ProxyName, 'str', $s_ProxyBypass, 'dword', $l_Flags)
	If @error OR $ai_InternetOpen[0] = 0 Then
		SetError(-1)
		Return 0
	EndIf
	
	Return $ai_InternetOpen[0]
	
EndFunc ;==> _FTPOpen()

;===============================================================================
;
; Function Name:    _FTPConnect()
; Description:      Connects to an FTP server.
; Parameter(s):     $l_InternetSession	- The Long from _FTPOpen()
;                   $s_ServerName 		- Server name/ip.
;                   $s_Username  		- Username.
;                   $s_Password			- Password.
;                   $i_ServerPort  		- Server port ( 0 is default (21) )
;					$l_Service			- I dont got a clue what this does.
;					$l_Flags			- Special flags.
;					$l_Context			- I dont got a clue what this does.
; Requirement(s):   DllCall, wininet.dll
; Return Value(s):  On Success - Returns an indentifier.
;                   On Failure - 0  and sets @ERROR
; Author(s):        Wouter van Kesteren
;
;===============================================================================

Func _FTPConnect($l_InternetSession, $s_ServerName, $s_Username, $s_Password, $i_ServerPort = 0, $l_Service = 1, $l_Flags = 0x00000001 , $l_Context = 0)
	
	Local $ai_InternetConnect = DllCall($__ftp_hWinInetDll, 'long', 'InternetConnect', 'long', $l_InternetSession, 'str', $s_ServerName, 'int', $i_ServerPort, 'str', $s_Username, 'str', $s_Password, 'long', $l_Service, 'dword', $l_Flags, 'long', $l_Context)
	If @error OR $ai_InternetConnect[0] = 0 Then
		SetError(-1)
		Return 0
	EndIf
	
	Return $ai_InternetConnect[0]
	
EndFunc ;==> _FTPConnect()

;===============================================================================
;
; Function Name:    _FTPPutFile()
; Description:      Puts an file on an FTP server.
; Parameter(s):     $l_FTPSession	- The Long from _FTPConnect()
;                   $s_LocalFile 	- The local file.
;                   $s_RemoteFile  	- The remote Location for the file.
;                   $l_Flags		- Special flags.
;                   $l_Context  	- I dont got a clue what this does.
; Requirement(s):   DllCall, wininet.dll
; Return Value(s):  On Success - 1
;                   On Failure - 0
; Author(s):        Wouter van Kesteren
;
;===============================================================================

Func _FTPPutFile($l_FTPSession, $s_LocalFile, $s_RemoteFile, $l_Flags = 0x00000001, $l_Context = 0)

	Local $ai_FTPPutFile = DllCall($__ftp_hWinInetDll, 'int', 'FtpPutFile', 'long', $l_FTPSession, 'str', $s_LocalFile, 'str', $s_RemoteFile, 'long', $l_Flags, 'long', $l_Context)
	If @error OR $ai_FTPPutFile[0] = 0 Then
		SetError(-1)
		Return 0
	EndIf
	
	Return $ai_FTPPutFile[0]
	
EndFunc ;==> _FTPPutFile()

;===============================================================================
;
; Function Name:    _FTPDelFile()
; Description:      Delete an file from an FTP server.
; Parameter(s):     $l_FTPSession	- The Long from _FTPConnect()
;                   $s_RemoteFile  	- The remote Location for the file.
; Requirement(s):   DllCall, wininet.dll
; Return Value(s):  On Success - 1
;                   On Failure - 0
; Author(s):        Wouter van Kesteren
;
;===============================================================================

Func _FTPDelFile($l_FTPSession, $s_RemoteFile)
	
	Local $ai_FTPPutFile = DllCall($__ftp_hWinInetDll, 'int', 'FtpDeleteFile', 'long', $l_FTPSession, 'str', $s_RemoteFile)
	If @error OR $ai_FTPPutFile[0] = 0 Then
		SetError(-1)
		Return 0
	EndIf
	
	Return $ai_FTPPutFile[0]
	
EndFunc ;==> _FTPDelFile()

Func _FTPChangeDir($l_FTPSession, $s_RemoteFile)
																	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $s_RemoteFile = ' & $s_RemoteFile & @crlf & '>Error code: ' & @error & @crlf) ;### Debug Console
	
	Local $ai_FTPDirChanged = DllCall($__ftp_hWinInetDll, 'int', 'FtpSetCurrentDirectory', 'long', $l_FTPSession, 'str', $s_RemoteFile)
	If @error OR $ai_FTPDirChanged[0] = 0 Then
		SetError(-1)
		Return 0
	EndIf
	
	Return $ai_FTPDirChanged[0]
	
EndFunc


;===============================================================================
;
; Function Name:    _FTPRenameFile()
; Description:      Renames an file on an FTP server.
; Parameter(s):     $l_FTPSession	- The Long from _FTPConnect()
;                   $s_Existing 	- The old file name.
;                   $s_New  		- The new file name.
; Requirement(s):   DllCall, wininet.dll
; Return Value(s):  On Success - 1
;                   On Failure - 0
; Author(s):        Wouter van Kesteren
;
;===============================================================================

Func _FTPRenameFile($l_FTPSession, $s_Existing, $s_New)
	
	Local $ai_FTPRenameFile = DllCall($__ftp_hWinInetDll, 'int', 'FtpRenameFile', 'long', $l_FTPSession, 'str', $s_Existing, 'str', $s_New)
	If @error OR $ai_FTPRenameFile[0] = 0 Then
		SetError(-1)
		Return 0
	EndIf
	
	Return $ai_FTPRenameFile[0]
	
EndFunc ;==> _FTPRenameFile()

;===============================================================================
;
; Function Name:    _FTPMakeDir()
; Description:      Makes an Directory on an FTP server.
; Parameter(s):     $l_FTPSession	- The Long from _FTPConnect()
;                   $s_Remote 		- The file name to be deleted.
; Requirement(s):   DllCall, wininet.dll
; Return Value(s):  On Success - 1
;                   On Failure - 0
; Author(s):        Wouter van Kesteren
;
;===============================================================================

Func _FTPMakeDir($l_FTPSession, $s_Remote)
	
	Local $ai_FTPMakeDir = DllCall($__ftp_hWinInetDll, 'int', 'FtpCreateDirectory', 'long', $l_FTPSession, 'str', $s_Remote)
	If @error OR $ai_FTPMakeDir[0] = 0 Then
		SetError(-1)
		Return 0
	EndIf
	
	Return $ai_FTPMakeDir[0]
	
EndFunc ;==> _FTPMakeDir()

;===============================================================================
;
; Function Name:    _FTPDelDir()
; Description:      Delete's an Directory on an FTP server.
; Parameter(s):     $l_FTPSession	- The Long from _FTPConnect()
;                   $s_Remote 		- The Directory to be deleted.
; Requirement(s):   DllCall, wininet.dll
; Return Value(s):  On Success - 1
;                   On Failure - 0
; Author(s):        Wouter van Kesteren
;
;===============================================================================

Func _FTPDelDir($l_FTPSession, $s_Remote)
	
	Local $ai_FTPDelDir = DllCall($__ftp_hWinInetDll, 'int', 'FtpRemoveDirectory', 'long', $l_FTPSession, 'str', $s_Remote)
	If @error OR $ai_FTPDelDir[0] = 0 Then
		SetError(-1)
		Return 0
	EndIf
		
	Return $ai_FTPDelDir[0]
	
EndFunc ;==> _FTPDelDir()

;===============================================================================
;
; Function Name:    _FTPClose()
; Description:      Closes the _FTPOpen session.
; Parameter(s):     $l_InternetSession	- The Long from _FTPOpen()
; Requirement(s):   DllCall, wininet.dll
; Return Value(s):  On Success - 1
;                   On Failure - 0
; Author(s):        Wouter van Kesteren
;
;===============================================================================

Func _FTPClose($l_InternetSession)
	
	Local $ai_InternetCloseHandle = DllCall($__ftp_hWinInetDll, 'int', 'InternetCloseHandle', 'long', $l_InternetSession)
	If @error OR $ai_InternetCloseHandle[0] = 0 Then
		SetError(-1)
		Return 0
	EndIf
	
	Return $ai_InternetCloseHandle[0]
	
EndFunc ;==> _FTPClose()