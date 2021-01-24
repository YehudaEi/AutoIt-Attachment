;_FTPPutFile
;_FTPOpen
;_FTPConnect
;_FTPDelFile
;_FTPRenameFile
;_FTPMakeDir
;_FTPDelDir
;_FTPClose
;_FTPPutFolderContents
;_FTPCommand
;_FTPGetCurrentDir
;_FtpSetCurrentDir
;_FTPGetFileSize
;_FTPFileFindFirst
;_FTPFileFindNext
;_FTPFileFindClose
;_FTPGetFile
; _FileTimeToSystemTime
;#include <A3LWinAPI.au3>
;#include <Datetrest.au3>
;#include <A3LConstants.au3>
#include <date.au3>
; ====================================================================================================
; Windows Notification Message Constants
; ====================================================================================================

;Global Const $NM_FIRST                          = 0

;Global Const $NM_OUTOFMEMORY                    = $NM_FIRST - 1
;Global Const $NM_CLICK                          = $NM_FIRST - 2
;Global Const $NM_DBLCLK                         = $NM_FIRST - 3
;Global Const $NM_RETURN                         = $NM_FIRST - 4
;Global Const $NM_RCLICK                         = $NM_FIRST - 5
;Global Const $NM_RDBLCLK                        = $NM_FIRST - 6
;Global Const $NM_SETFOCUS                       = $NM_FIRST - 7
;Global Const $NM_KILLFOCUS                      = $NM_FIRST - 8
;Global Const $NM_CUSTOMDRAW                     = $NM_FIRST - 12
;Global Const $NM_HOVER                          = $NM_FIRST - 13
;Global Const $NM_NCHITTEST                      = $NM_FIRST - 14
;Global Const $NM_KEYDOWN                        = $NM_FIRST - 15
;Global Const $NM_RELEASEDCAPTURE                = $NM_FIRST - 16
;Global Const $NM_SETCURSOR                      = $NM_FIRST - 17
;Global Const $NM_CHAR                           = $NM_FIRST - 18
;Global Const $NM_TOOLTIPSCREATED                = $NM_FIRST - 19
;Global Const $NM_LDOWN                          = $NM_FIRST - 20
;Global Const $NM_RDOWN                          = $NM_FIRST - 21
;Global Const $NM_THEMECHANGED                   = $NM_FIRST - 22

; ====================================================================================================
; FormatMessage Constants
; ====================================================================================================

;Global Const $FORMAT_MESSAGE_ALLOCATE_BUFFER    = 0x0100
;Global Const $FORMAT_MESSAGE_IGNORE_INSERTS     = 0x0200
;Global Const $FORMAT_MESSAGE_FROM_STRING        = 0x0400
;Global Const $FORMAT_MESSAGE_FROM_HMODULE       = 0x0800
;Global Const $FORMAT_MESSAGE_FROM_SYSTEM        = 0x1000
;Global Const $FORMAT_MESSAGE_ARGUMENT_ARRAY     = 0x2000
; ====================================================================================================
; SYSTEMTIME Definition
; ====================================================================================================

Global Const $SYSTEMTIME                        = "ushort;ushort;ushort;ushort;ushort;ushort;" & _
                                                  "ushort;ushort"

Global Const $ST_YEAR                           = 1
Global Const $ST_MONTH                          = 2
Global Const $ST_DOW                            = 3
Global Const $ST_DAY                            = 4
Global Const $ST_HOUR                           = 5
Global Const $ST_MINUTE                         = 6
Global Const $ST_SECOND                         = 7
Global Const $ST_MSECONDS                       = 8

; ====================================================================================================
; FILETIME Definition
; ====================================================================================================

Global Const $FILETIME                          = "uint;uint"

Global Const $FT_LOWDATETIME                    = 1
Global Const $FT_HIGHDATETIME                   = 2


;Global Const $FORMAT_MESSAGE_FROM_SYSTEM = 4096
;===============================================================================
;
; Function Name:    _FTPOpen()
; Description:      Opens an FTP session.
; Parameter(s):     $s_Agent      	- Random name. ( like "myftp" )

;	$l_AccessType
;    Access type required, use one of:
;
;    INTERNET_OPEN_TYPE_DIRECT = 1
;        Resolve all host names locally.
;
;    INTERNET_OPEN_TYPE_PRECONFIG
;        Retrieve proxy or direct configuration from the registry.
;
;    INTERNET_OPEN_TYPE_PRECONFIG_WITH_NO_AUTOPROXY
;        Retrieves proxy or direct configuration from the registry and prevents the use of any start-up script.
;
;    INTERNET_OPEN_TYPE_PROXY
;        Requests passed on to the proxy. If a proxy bypass list is supplied and the name is on that
;           list then INTERNET_OPEN_TYPE_DIRECT is used instead.
;
;
;                   $l_AccessType 	- I dont got a clue what this does.See above
;                   $s_ProxyName  	- ProxyName.
;                   $s_ProxyBypass	- ProxyByPasses's.
;                   $l_Flags       	- Special flags.
; Requirement(s):   DllCall, wininet.dll
; Return Value(s):  On Success - Returns an indentifier.
;                                (Handle for use by FtpConnect and maybe some other WiniNet functions)
;                   On Failure - 0  and sets @ERROR to -1
; Author(s):        Wouter van Kesteren.
;
;===============================================================================

Func _FTPOpen($s_Agent, $l_AccessType = 1, $s_ProxyName = '', $s_ProxyBypass = '', $l_Flags = 0)
	
	Local $ai_InternetOpen = DllCall('wininet.dll', 'long', 'InternetOpen', 'str', $s_Agent, 'long', $l_AccessType, 'str', $s_ProxyName, 'str', $s_ProxyBypass, 'long', $l_Flags)
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

Func _FTPConnect($l_InternetSession, $s_ServerName, $s_Username, $s_Password, $i_ServerPort = 0, $l_Service = 1, $l_Flags = 0, $l_Context = 0)
	
	Local $ai_InternetConnect = DllCall('wininet.dll', 'long', 'InternetConnect', 'long', $l_InternetSession, 'str', $s_ServerName, 'int', $i_ServerPort, 'str', $s_Username, 'str', $s_Password, 'long', $l_Service, 'long', $l_Flags, 'long', $l_Context)
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

Func _FTPPutFile($l_FTPSession, $s_LocalFile, $s_RemoteFile, $l_Flags = 0, $l_Context = 0)

	Local $ai_FTPPutFile = DllCall('wininet.dll', 'int', 'FtpPutFile', 'long', $l_FTPSession, 'str', $s_LocalFile, 'str', $s_RemoteFile, 'long', $l_Flags, 'long', $l_Context)
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
	
	Local $ai_FTPPutFile = DllCall('wininet.dll', 'int', 'FtpDeleteFile', 'long', $l_FTPSession, 'str', $s_RemoteFile)
	If @error OR $ai_FTPPutFile[0] = 0 Then
		SetError(-1)
		Return 0
	EndIf
	
	Return $ai_FTPPutFile[0]
	
EndFunc ;==> _FTPDelFile()

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
	
	Local $ai_FTPRenameFile = DllCall('wininet.dll', 'int', 'FtpRenameFile', 'long', $l_FTPSession, 'str', $s_Existing, 'str', $s_New)
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
	
	Local $ai_FTPMakeDir = DllCall('wininet.dll', 'int', 'FtpCreateDirectory', 'long', $l_FTPSession, 'str', $s_Remote)
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
;                  Only deletes an empty Directory
; Author(s):        Wouter van Kesteren
;
;===============================================================================

Func _FTPDelDir($l_FTPSession, $s_Remote)
	
	Local $ai_FTPDelDir = DllCall('wininet.dll', 'int', 'FtpRemoveDirectory', 'long', $l_FTPSession, 'str', $s_Remote)
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
	
	Local $ai_InternetCloseHandle = DllCall('wininet.dll', 'int', 'InternetCloseHandle', 'long', $l_InternetSession)
	If @error OR $ai_InternetCloseHandle[0] = 0 Then
		SetError(-1)
		Return 0
	EndIf
	
	Return $ai_InternetCloseHandle[0]
	
EndFunc ;==> _FTPClose()



;===================================================================================================

;
; Function Name:    _FTPPutFolderContents()
; Description:      Puts an folder on an FTP server. Recursivley if selected
; Parameter(s):     $l_InternetSession    - The Long from _FTPConnect()
;                   $s_LocalFolder     - The local folder i.e. "c:\temp".
;                   $s_RemoteFolder - The remote folder i.e. '/website/home'.
;                   $b_RecursivePut - Recurse through sub-dirs. 0=Non recursive, 1=Recursive
; Requirement(s):   DllCall, wininet.dll
; Author(s):        Stumpii
;
;===================================================================================================

Func _FTPPutFolderContents($l_InternetSession, $s_LocalFolder, $s_RemoteFolder, $b_RecursivePut)

	; Shows the filenames of all files in the current directory.
	$search = FileFindFirstFile($s_LocalFolder & "\*.*")

	; Check if the search was successful
	If $search = -1 Then
		MsgBox(0, "Error", "No files/directories matched the search pattern")
		Exit
	EndIf

	While 1
		$file = FileFindNextFile($search)
		If @error Then ExitLoop
		If StringInStr(FileGetAttrib($s_LocalFolder & "\" & $file), "D") Then
			_FTPMakeDir($l_InternetSession, $s_RemoteFolder & "/" & $file)
			If $b_RecursivePut Then
				_FTPPutFolderContents($l_InternetSession, $s_LocalFolder & "\" & $file, $s_RemoteFolder & "/" & $file, $b_RecursivePut)
			EndIf
		Else
			_FTPPutFile($l_InternetSession, $s_LocalFolder & "\" & $file, $s_RemoteFolder & "/" & $file, 0, 0)
		EndIf
	WEnd

	; Close the search handle
	FileClose($search)

EndFunc ;==>_FTPPutFolderContents

Func _FTPListFiles($l_FTPSession, $s_RemotePath,$l_Flags = 0, $l_Context = 0)
	Dim $ret[2]
	#cs
		typedef struct _WIN32_FIND_DATA {
		DWORD dwFileAttributes;
		FILETIME ftCreationTime;
		FILETIME ftLastAccessTime;
		FILETIME ftLastWriteTime;
		DWORD nFileSizeHigh;
		DWORD nFileSizeLow;
		DWORD dwReserved0;
		DWORD dwReserved1;
		TCHAR cFileName[MAX_PATH];
		TCHAR cAlternateFileName[14];
		}
		
	#ce
	$str = "dword;int[2];int[2];int[2];dword;dword;dword;dword;char[256];char[14]"
	$WIN32_FIND_DATA = DllStructCreate($str)
	$fd= DLLStructCreate($FILETIME)
	;msgbox(0,'','List1')
	Local $callFindFirst = DllCall('wininet.dll', 'int', 'FtpFindFirstFile', 'long', $l_FTPSession, 'str',$s_RemotePath, 'ptr', DllStructGetPtr($WIN32_FIND_DATA), 'long', $l_Flags, 'long', $l_Context)
	;msgbox(0,'',$callFindFirst[0])
	If Not $callFindFirst[0] Then
		MsgBox(0, "Folder Empty", "No Files Found ")
		SetError(-1)
		Return 0
	EndIf
	$ret[0] = ""
	$ret[1] = ""
	While 1
		$date = '';DLLStructCreate("char[260]")
		;$pdate = DllStructGetPtr($date)

		If DllStructGetData($WIN32_FIND_DATA, 1) <> 16 Then
					
			DllStructSetData($fd, 1, DLLStructGetData($WIN32_FIND_DATA, 4,1))
			DllStructSetData($fd, 2, DLLStructGetData($WIN32_FIND_DATA, 4,2))
			$datetime = _FileTimeToSystemTime($fd)
			$iMonth     = DllStructGetData($datetime, $ST_MONTH)
			$iDay       = DllStructGetData($datetime, $ST_DAY  )
			$iYear      = DllStructGetData($datetime, $ST_YEAR )
			$iHours     = DllStructGetData($datetime, $ST_HOUR  )
			$iMinutes   = DllStructGetData($datetime, $ST_MINUTE)
			$iSeconds   = DllStructGetData($datetime, $ST_SECOND)
			
			$shout = StringFormat("%4d/%02d/%02d %02d:%02d:%02", $iYear , $iMonth, $iDay, $iHours, $iMinutes, $iSeconds);, $sAMPM)
			$dateback =  _DateAdd('h', 6, $shout)
			;msgbox(0,$dateback,'@error = ' & @error)
			$filename = DllStructGetData($WIN32_FIND_DATA, 9)
			while StringLen($filename) < 20	
				$filename = $filename & ' '
				WEnd
			while StringLen($filename) < 30
				$filename = $filename & '.'
			WEnd
			
			$ret[0] = $ret[0] & $filename & $dateback & "|"
			
			;$ret[0] = $ret[0] & DllStructGetData($WIN32_FIND_DATA, 9) & '  ' & DllStructGetData($WIN32_FIND_DATA, 4, 1) _
			;		&  DllStructGetData($WIN32_FIND_DATA, 4, 2) & "|"
		EndIf
		If DllStructGetData($WIN32_FIND_DATA, 1) = 16 Then
			
			
			
			DllStructSetData($fd, 1, DLLStructGetData($WIN32_FIND_DATA, 4,1))
			DllStructSetData($fd, 2, DLLStructGetData($WIN32_FIND_DATA, 4,2))
			$datetime = _FileTimeToSystemTime($fd)
			$iMonth     = DllStructGetData($datetime, $ST_MONTH)
			$iDay       = DllStructGetData($datetime, $ST_DAY  )
			$iYear      = DllStructGetData($datetime, $ST_YEAR )
			$iHours     = DllStructGetData($datetime, $ST_HOUR  )
			$iMinutes   = DllStructGetData($datetime, $ST_MINUTE)
			$iSeconds   = DllStructGetData($datetime, $ST_SECOND)
			
			$shout = StringFormat("%4d/%02d/%02d %02d:%02d:%02", $iYear , $iMonth, $iDay, $iHours, $iMinutes, $iSeconds);, $sAMPM)
			$dateback =  _DateAdd('h', 6, $shout)
			;msgbox(0,$dateback,'@error = ' & @error)
			$filename = DllStructGetData($WIN32_FIND_DATA, 9)
			while StringLen($filename) < 20	
				$filename = $filename & ' '
				WEnd
			while StringLen($filename) < 30
				$filename = $filename & '.'
			WEnd
			
			$ret[1] = $ret[1] & $filename & $dateback & "|"
		EndIf
		
		;msgbox(0,'','list 3')
		Local $callFindNext = DllCall('wininet.dll', 'int', 'InternetFindNextFile', 'long', $callFindFirst[0], 'ptr', DllStructGetPtr($WIN32_FIND_DATA))
		;msgbox(0,'next is',$callFindNext[0])
		If Not $callFindNext[0] Then
			ExitLoop
		EndIf
	WEnd
	
	 _FTPFileFindClose($callFindFirst[0], $WIN32_FIND_DATA)
	$WIN32_FIND_DATA = 0;destroy the struct
	$fd = 0;destroy the struct
	$WIN32_FIND_DATA = 0;destroy the struct
	;$ret[0] = StringRight($ret[0], 1)
	;$ret[1] = StringRight($ret[1], 1)
	Return $ret;StringTrimRight($ret, 1)
EndFunc ;==>_FTPListFiles





; define some constants - can be used with _FTPPutFile and _FTPGetFile and ftp open flags
Const $INTERNET_FLAG_PASSIVE = 0x08000000
Const $INTERNET_FLAG_TRANSFER_ASCII = 0x00000001
Const $INTERNET_FLAG_TRANSFER_BINARY = 0x00000002
Const $INTERNET_DEFAULT_FTP_PORT = 21
Const $INTERNET_SERVICE_FTP = 1
Const $ERROR_INTERNET_EXTENDED_ERROR = 12003

;===============================================================================
;
; Function Name:    _FTPCommand()
;modified by mg to set @error to getlasterror if ftpcommand fails.
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
; Return Value(s):  On Success - Returns true.
;                   On Failure - 0  and sets @ERROR
; to read the response from the server use  InternetGetLastResponseInfo.
; Author(s):        Bill Mezian
;
;    Command Examples: depends on server syntax. The following is for
;    Binary transfer, ASCII transfer, Passive transfer mode (used with firewalls)
;    'type I' 'type A'  'pasv'
;
;===============================================================================

Func _FTPCommand($HD,$l_FTPSession, $s_FTPCommand, $l_Flags = 0x00000001, $l_ExpectResponse = 0, $l_Context = 0, $s_Handle = '')
       if $HD = 0 Then  $HD = 'wininet.dll'
		   
	   $le = 0
		$es = ''
	Local $ai_FTPCommand = DllCall($HD, 'int', 'FtpCommand', 'long', $l_FTPSession, 'long', $l_ExpectResponse, 'long', $l_Flags, 'str', $s_FTPCommand, 'long', $l_Context, 'str', $s_Handle)
	;_InternetGetLastResponseInfo($le,$es)
	If @error OR $ai_FTPCommand[0] = 0 Then
		$x = DLLCall("kernel32.dll","long","GetLastError")
		msgbox(0,'ftpcommand last error was',$x[0])
		if $x[0] = 12003 Then
		$le = 0
		$es = ''
		_InternetGetLastResponseInfo($HD,$le,$es)
		;msgbox(0,$le,$es)
		
		EndIf
		
       ;MsgBox(0,"",$x[0])
		SetError(-$x[0])
		Return 0
	EndIf
	;Return $s_return
	Return $ai_FTPCommand[0]

EndFunc;==> _FTPCommand()

;===============================================================================
;
; Function Name:    _FTPGetCurrentDir()
; Description:      Get Current Directory on an FTP server.
; Parameter(s):     $l_FTPSession    - The Long from _FTPConnect()
; Requirement(s):   DllCall, wininet.dll
; Return Value(s):  On Success - Directory Name
;                   On Failure - 0
; Author(s):        Beast
;
;===============================================================================

Func _FTPGetCurrentDir($l_FTPSession)
	Local $ai_FTPGetCurrentDir = DllCall('wininet.dll', 'int', 'FtpGetCurrentDirectory', 'long', $l_FTPSession, 'str', "", 'long*', 260)
	If @error OR $ai_FTPGetCurrentDir[0] = 0 Then
		SetError(-1)
		Return 0
	EndIf

 Return $ai_FTPGetCurrentDir[2]


EndFunc;==> _FTPGetCurrentDir()

;===============================================================================
;
; Function Name:    _FtpSetCurrentDir()
; Description:      Set Current Directory on an FTP server.
; Parameter(s):     $l_FTPSession    - The Long from _FTPConnect()
;                   $s_Remote         - The Directory to be set.
; Requirement(s):   DllCall, wininet.dll
; Return Value(s):  On Success - 1
;                   On Failure - 0
; Author(s):        Beast
;
;===============================================================================

Func _FtpSetCurrentDir($l_FTPSession, $s_Remote)

	Local $ai_FTPSetCurrentDir = DllCall('wininet.dll', 'int', 'FtpSetCurrentDirectory', 'long', $l_FTPSession, 'str', $s_Remote)
	If @error OR $ai_FTPSetCurrentDir[0] = 0 Then
		SetError(-1)
		Return 0
	EndIf

	Return $ai_FTPSetCurrentDir[0]


EndFunc;==> _FtpSetCurrentDir()


;===============================================================================
;
; Function Name:    _FTPGetFileSize()
; Description:      Gets filesize of a file on the FTP server.
; Parameter(s):     $l_FTPSession	- The Long from _FTPConnect()
;                   $s_FileName 	- The file name.
; Requirement(s):   DllCall, wininet.dll
; Return Value(s):  On Success - 1
;                   On Failure - 0
; Author(s):        J.o.a.c.h.i.m. d.e. K.o.n.i.n.g.
;corrected 27th Nov 2007.  ",$ai_FTPGetSizeHandle[0])" was ",$ai_FTPGetSizeHandle[0])"
;===============================================================================

Func _FTPGetFileSize($l_FTPSession, $s_FileName)

	Local $ai_FTPGetSizeHandle = DllCall('wininet.dll', 'int', 'FtpOpenFile', 'long', $l_FTPSession, 'str', $s_FileName, 'long', 0x80000000, 'long', 0x04000002, 'long', 0)
	Local $ai_FTPGetFileSize = DllCall('wininet.dll', 'int', 'FtpGetFileSize', 'long', $ai_FTPGetSizeHandle[0])
	If @error OR $ai_FTPGetFileSize[0] = 0 Then
		SetError(-1)
		Return 0
	EndIf
	DllCall('wininet.dll', 'int', 'InternetCloseHandle', 'str', $ai_FTPGetSizeHandle[0])

	Return $ai_FTPGetFileSize[0]
	
EndFunc ;==> _FTPGetFileSize()



;===============================================================================

;
; Function Name:    _FTPFileFindFirst()
; Description:      Find First File on an FTP server.
; Parameter(s):     $l_FTPSession - The Long from _FTPConnect()
;                   $s_RemoteFile   - The remote Location for the file.
;                   $l_Flags  - use the dwFlags parameter to specify 1 for transferring the file in ASCII (Type A transfer method) or 2 for transferring the file in Binary (Type I transfer method).
;                   $l_Context   - lContext is used to identify the application context when using callbacks. Since we’re not using callbacks we’ll pass 0.
; Requirement(s):   DllCall, wininet.dll
; Return Value(s):  On Success - an array with element [0] = 12
;                   On Failure - array with element [0] = 0
; Author(s):        Dick Bronsdijk
;
;===============================================================================


#cs
	typedef struct _WIN32_FIND_DATA {
	DWORD dwFileAttributes;
	FILETIME ftCreationTime;
	FILETIME ftLastAccessTime;
	FILETIME ftLastWriteTime;
	DWORD nFileSizeHigh;
	DWORD nFileSizeLow;
	DWORD dwReserved0;
	DWORD dwReserved1;
	TCHAR cFileName[MAX_PATH];
	TCHAR cAlternateFileName[14];
	} WIN32_FIND_DATA;
	typedef struct _FILETIME {
	DWORD dwLowDateTime;
	DWORD dwHighDateTime;
	} FILETIME;
	
	
	HINTERNET FtpFindFirstFile(
	HINTERNET hConnect,
	LPCTSTR lpszSearchFile,
	LPWIN32_FIND_DATA lpFindFileData,
	DWORD dwFlags,
	DWORD_PTR dwContext
	);
	
#ce
Func _FTPFileFindFirst($l_FTPSession, $s_RemotePath, ByRef $h_Handle, ByRef $l_DllStruct, $l_Flags = 0, $l_Context = 0);flag = 0 changed to 2 to see if stops hanging

	Local $str  = "int;uint[2];uint[2];uint[2];int;int;int;int;char[256];char[14]"
	$l_DllStruct = DllStructCreate($str)
	if @error Then
		SetError(-2)
		Return ""
	endif

	Dim $a_FTPFileList[1]
	$a_FTPFileList[0] = 0

	Local $ai_FTPFirstFile = DllCall('wininet.dll', 'int', 'FtpFindFirstFile', 'long', $l_FTPSession, 'str', $s_RemotePath, 'ptr', DllStructGetPtr($l_DllStruct), 'long', $l_Flags, 'long', $l_Context)
	If @error OR $ai_FTPFirstFile[0] = 0 Then
		SetError(-1)
		Return $ai_FTPFirstFile
	EndIf
	$h_Handle = $ai_FTPFirstFile[0]
	$FileName = DllStructGetData($l_DllStruct, 9)

	Dim $a_FTPFileList[12]
	$a_FTPFileList[0] = 12
	$a_FTPFileList[1] = DllStructGetData($l_DllStruct, 1)    ; File Attributes
	$a_FTPFileList[2] = DllStructGetData($l_DllStruct, 2, 1) ; Creation Time Low
	$a_FTPFileList[3] = DllStructGetData($l_DllStruct, 2, 2) ; Creation Time High
	$a_FTPFileList[4] = DllStructGetData($l_DllStruct, 3, 1) ; Access Time Low
	$a_FTPFileList[5] = DllStructGetData($l_DllStruct, 3, 2) ; Access Time High
	$a_FTPFileList[6] = DllStructGetData($l_DllStruct, 4, 1) ; Last Write Low
	$a_FTPFileList[7] = DllStructGetData($l_DllStruct, 4, 2) ; Last Write High
	$a_FTPFileList[8] = DllStructGetData($l_DllStruct, 5)    ; File Size High
	$a_FTPFileList[9] = DllStructGetData($l_DllStruct, 6)    ; File Size Low
	$a_FTPFileList[10] = DllStructGetData($l_DllStruct, 9); File Name
	$a_FTPFileList[11] = DllStructGetData($l_DllStruct, 10)  ; Altername

	Return $a_FTPFileList

EndFunc;==> _FTPFileFindFirst()

;===============================================================================

;
; Function Name:    _FTPFileFindNext()
; Description:      Find Next File on an FTP server.
; Parameter(s):     $l_FTPSession - The Long from _FTPConnect()
;                   $s_RemoteFile   - The remote Location for the file.
; Requirement(s):   DllCall, wininet.dll
; Return Value(s):  On Success - filename
;                   On Failure - 0 and @error = -1
; Author(s):        Dick Bronsdijk
;
;===============================================================================


Func _FTPFileFindNext($h_Handle, $l_DllStruct)

	Dim $a_FTPFileList[1]
	$a_FTPFileList[0] = 0

	Local $ai_FTPPutFile = DllCall('wininet.dll', 'int', 'InternetFindNextFile', 'long', $h_Handle, 'ptr', DllStructGetPtr($l_DllStruct))
	If @error OR $ai_FTPPutFile[0] = 0 Then
		SetError(-1)
		Return $a_FTPFileList
	EndIf

	Dim $a_FTPFileList[12]
	$a_FTPFileList[0] = 12
	$a_FTPFileList[1] = DllStructGetData($l_DllStruct, 1)    ; File Attributes
	$a_FTPFileList[2] = DllStructGetData($l_DllStruct, 2, 1) ; Creation Time Low
	$a_FTPFileList[3] = DllStructGetData($l_DllStruct, 2, 2) ; Creation Time High
	$a_FTPFileList[4] = DllStructGetData($l_DllStruct, 3, 1) ; Access Time Low
	$a_FTPFileList[5] = DllStructGetData($l_DllStruct, 3, 2) ; Access Time High
	$a_FTPFileList[6] = DllStructGetData($l_DllStruct, 4, 1) ; Last Write Low
	$a_FTPFileList[7] = DllStructGetData($l_DllStruct, 4, 2) ; Last Write High
	$a_FTPFileList[8] = DllStructGetData($l_DllStruct, 5)    ; File Size High
	$a_FTPFileList[9] = DllStructGetData($l_DllStruct, 6)    ; File Size Low
	$a_FTPFileList[10] = DllStructGetData($l_DllStruct, 9); File Name
	$a_FTPFileList[11] = DllStructGetData($l_DllStruct, 10)  ; Altername

	Return $a_FTPFileList[10]

EndFunc;==> _FTPFileFindNext()

;===============================================================================

;
; Function Name:    _FTPFileFindClose()
; Description:      Delete FindFile Structure.
; Parameter(s):
; Requirement(s):   DllCall, wininet.dll
; Return Value(s):  On Success - 1
;                   On Failure - 0
; Author(s):        Dick Bronsdijk
;
;===============================================================================


Func _FTPFileFindClose($h_Handle, $l_DllStruct)

	$l_DllStruct=0

	Local $ai_FTPPutFile = DllCall('wininet.dll', 'int', 'InternetCloseHandle', 'long', $h_Handle)
	If @error OR $ai_FTPPutFile[0] = 0 Then
		SetError(-1)
		Return ""
	EndIf

	Return $ai_FTPPutFile[0]

EndFunc;==> _FTPFileFindClose()

;===============================================================================
;
; Function Name:    _FTPGetFile() - db Test
; Description:      Gets an file from an FTP server.
; Parameter(s):     $l_FTPSession    - The Long from _FTPConnect()
;                   $s_RemoteFile      - The remote Location for the file.
;                   $s_LocalFile     - The local file.
;                   $l_Flags        - use the dwFlags parameter to specify
;                                   -    1 for transferring the file in ASCII (Type A transfer method) or
;                                   -    2 for transferring the file in Binary (Type I transfer method).
;                   $l_Fail         - Allow local file to be overwritten if it exists
;                                   -   -1 Don't allow overwrite (default)
;                                   -    0 Allow overwrite
;                   $l_Attributes   - Attributes for local file
;                   $l_Context      - lContext is used to identify the application context when using callbacks. Since we’re not using callbacks we’ll pass 0.
; Requirement(s):   DllCall, wininet.dll
; Return Value(s):  On Success - 1
;                   On Failure - 0
; Author(s):        Dick Bronsdijk
;
;===============================================================================



Func _FTPGetFile($l_FTPSession, $s_RemoteFile, $s_LocalFile, $l_Flags = 2, $l_Fail = 0, $l_Attributes = 0x00000080, $l_Context = 0,$Hd=0)

	Local $ai_FTPGetFile = DllCall('wininet.dll', 'int', 'FtpGetFile', 'long', $l_FTPSession, 'str', $s_RemoteFile, 'str', $s_LocalFile, 'long', $l_Fail, 'long', $l_Attributes, 'long', $l_Flags, 'long', $l_Context)
	If @error OR $ai_FTPGetFile[0] = 0 Then
		SetError(-1)
		Return 0
	EndIf

	Return $ai_FTPGetFile[0]

EndFunc;==> _FTPGetFile()


; Use InternetGetLastResponseInfo when GetLastError returns ERROR_INTERNET_EXTENDED_ERROR.
Func _InternetGetLastResponseInfo($LeHD,ByRef $LstErr,ByRef $ErrStrg)
	
		msgbox(0,'getting last response info','')
#cs	
	$Res = DllCall ("wininet.dll", "int", "InternetGetLastResponseInfo",  "str", "",  "str", "", "int", 0 )

; The empty strings got filled by the function, so we get their values
$LstErr = $Res[1]
$ErrStrg = $Res[2]
	
#ce
	;$savedll = $ll
	$struct_Buffer = DllStructCreate("char[300]") ;
	;DllStructSetData($struct_Buffer,1,$ll,1)
	$erBuf = DllStructCreate('int')
	$szBuf = DllStructCreate('int')
	DllStructSetData($szBuf,1,300)
	$Res = DllCall($LeHD,'int', 'InternetGetLastResponseInfo','int*',DllStructGetPtr($erBuf),'ptr',DllStructGetPtr($struct_Buffer),'int*',DllStructGetPtr($szBuf))
	;$Res = DllCall('wininet.dll','int', 'InternetGetLastResponseInfo','int*',DllStructGetPtr($erBuf),'ptr','','int*',DllStructGetPtr($szBuf))
	$LstErr = DllStructGetData($erBuf, 1)
	$ErrStrg = DllStructGetData($struct_Buffer, 1)
	msgbox(0,'size requested is',DllStructGetData($szBuf,1))
	msgbox(0,'LstErr = ' & $LstErr,'Error message = ' & $ErrStrg)
	if @error = 1 then msgbox(0,'dll failed','')
		msgbox(0,'ftpplus 750. err string is',$ErrStrg)
	;if	$ll <> $savedll then msgbox(0,'error with buffer size','Need ' & $ll & ' chars')
	$rreess = ''
	for $rr = 0 to UBound($res)- 1
		$rreess = $rreess & $res[$rr] & @CRLF
	Next
	msgbox(0,'From lastresponse',$rreess)



	return $Res;[0]
       

#cs

    $struct_Buffer = DllStructCreate("char[" & $length & "]") ; need to set 1st word to length?
    If @error Then Return SetError(-1, -1, "")
    DllStructSetData($struct_Buffer,1,$length,1)
    Local $iResult = _SendMessage($h_Edit, $EM_GETLINE, $i_line-1, DllStructGetPtr($struct_Buffer))
    If @error Then Return SetError(-2, -2, "")
    Return DllStructGetData($struct_Buffer, 1)
 
var lpdwError: DWORD; lpszBuffer: PChar;  var lpdwBufferLength: DWORD): BOOL;
BOOL InternetGetLastResponseInfo(
  LPDWORD lpdwError,
  LPTSTR lpszBuffer,
  LPDWORD lpdwBufferLength
);
Parameters:

    lpdwError
        Updated to hold the most recent error code.

    lpszBuffer
        Buffer to receive the error text.

    lpdwBufferLength
        On entry this should be set to the available size of the buffer (lpszBuffer), updated on exit to hold the size of the string written to the buffer (less the null terminator). If the buffer is too small this will hold the necessary buffer size.

Returns: True if some error text was successfully written to the buffer, False (0) otherwise. If the function fails, further information can be found by calling GetLastError. If the buffer is too small to hold the full error text then GetLastError will return ERROR_INSUFFICIENT_BUFFER.
#ce
EndFunc

; ====================================================================================================
; Description ..: Converts a file time to system time format
; Parameters ...: $rFileTime    - FILETIME structure containing the UTC-based  file  time  to  convert
;                   into a local file time.
; Return values : SYSTEMTIME structure that contains the converted file time
; ====================================================================================================
Func _FileTimeToSystemTime($rFileTime)
  Local $pFileTime, $pSystTime, $rSystTime, $aResult

  $rSystTime = DllStructCreate($SYSTEMTIME)
  $pSystTime = DllStructGetPtr($rSystTime )
  $pFileTime = DllStructGetPtr($rFileTime )
  $aResult   = DllCall("Kernel32.dll", "int", "FileTimeToSystemTime", "ptr", $pFileTime, _
                       "ptr", $pSystTime)
  _Check("_FileTimeToSystemTime", ($aResult[0] = 0), 0, True)
  Return $rSystTime
EndFunc


; ====================================================================================================
; Description ..: Displays any errors produced by the Auto3Lib library
; Parameters ...: $Function     - Name of function
;                 $bError       - True if error occurred
;                 $iError       - Error code
;                 $bTranslate   - Translate error using _GetLastErrorMessage
; Return values : None
; ====================================================================================================
Func _Check($sFunction, $bError, $vError, $bTranslate=False)
  if $bError then
    if $bTranslate then
      $vError = _GetLastErrorMessage()
    endif
    _ShowError($sFunction & ": " & $vError)
  endif
EndFunc

; ====================================================================================================
; Description ..: Returns the calling thread's lasterror code value.  The lasterror code is maintained
;                 on a per-thread basis.
; Parameters ...: None
; Return values : Last error code
; ====================================================================================================
Func _GetLastError()
  Local $aResult

  $aResult = DllCall("Kernel32.dll", "int", "GetLastError")
  Return $aResult[0]
EndFunc
; ====================================================================================================
; Description ..: Displays an error message box with an optional exit
; Parameters ...: $sText        - Error text to display
;                 $bExit        - True  = Return normally after display
;                                 False = Exit program after display
; Return values : None
; ====================================================================================================
Func _ShowError($sText, $bExit=True)
  MsgBox(16 + 4096, "Error", $sText)
  if $bExit then Exit
EndFunc


; ====================================================================================================
; Description ..: Returns the calling threads last error message
; Parameters ...: None
; Return values : Last error message
; ====================================================================================================
Func _GetLastErrorMessage()
  Local $pBuffer, $rBuffer

  $rBuffer = DllStructCreate("char[4096]")
  $pBuffer = DllStructGetPtr($rBuffer    )
  _FormatMessage($FORMAT_MESSAGE_FROM_SYSTEM, 0, _GetLastError(), 0, $pBuffer, 4096, 0)
  Return DllStructGetData($rBuffer, 1)
EndFunc

; ====================================================================================================
; Description ..: Formats a message string.  The function requires a message definition as input.  The
;                 message definition can come from a buffer passed into the function. It can come from
;                 a message table resource in an already-loaded module.   Or the caller  can  ask  the
;                 function to search the system's message table resources for the message  definition.
;                 The function finds the message definition in a message table  resource  based  on  a
;                 message identifier and a language identifier.   The function  copies  the  formatted
;                 message text to an output  buffer,  processing  any  embedded  insert  sequences  if
;                 requested.
; Parameters ...: $iFlags       - Contains a set of bit flags that specify aspects of  the  formatting
;                   process and how to interpret the lpSource parameter. The low-order byte of $iFlags
;                   specifies how the function handles line breaks in the output buffer. The low-order
;                   byte can also specify the maximum width of a formatted output line.
;                 $pSource      - Pointer to message source
;                 $iMessageID   - Requested message identifier
;                 $iLanguageID  - Language identifier for requested message
;                 $pBuffer      - Pointer to message buffer
;                 $iSize        - Maximum size of message buffer
;                 $vArguments   - Address of array of message inserts
; Return values : Number of bytes stored in message buffer
; ====================================================================================================
Func _FormatMessage($iFlags, $pSource, $iMessageID, $iLanguageID, $pBuffer, $iSize, $vArguments)
  Local $aResult

  $aResult = DllCall("Kernel32.dll", "int", "FormatMessageA", "int", $iFlags, "hwnd", $pSource, _
                     "int", $iMessageID, "int", $iLanguageID, "ptr", $pBuffer, "int", $iSize, _
                     "ptr", $vArguments)
  Return $aResult[0]
EndFunc




#cs
	API Flags
	
	Many of the WinINet functions accept an array of flags as a parameter.
	The following is a brief description of the defined flags.
	
	INTERNET_COOKIE_EVALUATE_P3P     0x80
	;Indicates that a Platform for Privacy Protection (P3P) header is to be associated with a cookie.
	INTERNET_COOKIE_THIRD_PARTY    0x10
	;Indicates that a third-party cookie is being set or retrieved.
	INTERNET_FLAG_ASYNC    0x10000000
	;Makes only asynchronous requests on handles descended from the handle returned from this function.
	Only the InternetOpen function uses this flag.
	INTERNET_FLAG_CACHE_ASYNC    0x00000080
	;Allows a lazy cache write.
	INTERNET_FLAG_CACHE_IF_NET_FAIL    0x00010000
	;Returns the resource from the cache if the network request for the resource fails due to an ERROR_INTERNET_CONNECTION_RESET or ERROR_INTERNET_CANNOT_CONNECT error. This flag is used by HttpOpenRequest.
	INTERNET_FLAG_DONT_CACHE    0x04000000
	;Does not add the returned entity to the cache. This is identical to the preferred value, INTERNET_FLAG_NO_CACHE_WRITE.
	INTERNET_FLAG_EXISTING_CONNECT    0x20000000
	;Attempts to use an existing InternetConnect object if one exists with the same attributes required to make the request.
	;This is useful only with FTP operations, since FTP is the only protocol that typically performs multiple operations during the same session.
	;WinINet caches a single connection handle for each HINTERNET handle generated by InternetOpen.
	;The InternetOpenUrl and InternetConnect functions use this flag for Http and Ftp connections.
	INTERNET_FLAG_FORMS_SUBMIT    0x00000040
	;Indicates that this is a Forms submission.
	INTERNET_FLAG_FROM_CACHE    0x01000000
	;Does not make network requests. All entities are returned from the cache. If the requested item is not in the cache, a suitable error, such as ERROR_FILE_NOT_FOUND, is returned. Only the InternetOpen function uses this flag.
	INTERNET_FLAG_FWD_BACK    0x00000020
	;Indicates that the function should use the copy of the resource that is currently in the Internet cache. The expiration date and other information about the resource is not checked. If the requested item is not found in the Internet cache, the system attempts to locate the resource on the network. This value was introduced in Microsoft Internet Explorer 5 and is associated with the Forward and Back button operations of Internet Explorer.
	INTERNET_FLAG_HYPERLINK    0x00000400
	;Forces a reload if there is no Expires time and no LastModified time returned from the server when determining whether to reload the item from the network.
	;This flag can be used by GopherFindFirstFile, GopherOpenFile, FtpFindFirstFile, FtpGetFile, FtpOpenFile, FtpPutFile, HttpOpenRequest, and InternetOpenUrl.
	INTERNET_FLAG_IGNORE_CERT_CN_INVALID    0x00001000
	;Disables checking of SSL/PCT-based certificates that are returned from the server against the host name given in the request. WinINet uses a simple check against certificates by comparing for matching host names and simple wildcarding rules. This flag can be used by HttpOpenRequest and InternetOpenUrl (for HTTP requests).
	INTERNET_FLAG_IGNORE_CERT_DATE_INVALID    0x00002000
	;Disables checking of SSL/PCT-based certificates for proper validity dates. This flag can be used by HttpOpenRequest and InternetOpenUrl (for HTTP requests).
	INTERNET_FLAG_IGNORE_REDIRECT_TO_HTTP    0x00008000
	;Disables detection of this special type of redirect. When this flag is used, WinINet transparently allows redirects from HTTPS to HTTP URLs. This flag can be used by HttpOpenRequest and InternetOpenUrl (for HTTP requests).
	INTERNET_FLAG_IGNORE_REDIRECT_TO_HTTPS    0x00004000
	;Disables detection of this special type of redirect. When this flag is used, WinINet transparently allow redirects from HTTP to HTTPS URLs. This flag can be used by HttpOpenRequest and InternetOpenUrl (for HTTP requests).
	INTERNET_FLAG_KEEP_CONNECTION    0x00400000
	;Uses keep-alive semantics, if available, for the connection. This flag is used by HttpOpenRequest and InternetOpenUrl (for HTTP requests). This flag is required for Microsoft Network (MSN), NTLM, and other types of authentication.
	INTERNET_FLAG_MAKE_PERSISTENT    0x02000000
	;No longer supported.
	INTERNET_FLAG_MUST_CACHE_REQUEST    0x00000010
	;Identical to the preferred value, INTERNET_FLAG_NEED_FILE. Causes a temporary file to be created if the file cannot be cached.
	;This flag can be used by GopherFindFirstFile, GopherOpenFile, FtpFindFirstFile, FtpGetFile, FtpOpenFile, FtpPutFile, HttpOpenRequest, and InternetOpenUrl.
	INTERNET_FLAG_NEED_FILE    0x00000010
	;Causes a temporary file to be created if the file cannot be cached.
	;This flag can be used by GopherFindFirstFile, GopherOpenFile, FtpFindFirstFile, FtpGetFile, FtpOpenFile, FtpPutFile, HttpOpenRequest, and InternetOpenUrl.
	INTERNET_FLAG_NO_AUTH    0x00040000
	;Does not attempt authentication automatically. This flag can be used by HttpOpenRequest and InternetOpenUrl (for HTTP requests).
	INTERNET_FLAG_NO_AUTO_REDIRECT    0x00200000
	;Does not automatically handle redirection in HttpSendRequest. This flag can also be used by InternetOpenUrl for HTTP requests.
	INTERNET_FLAG_NO_CACHE_WRITE    0x04000000
	;Does not add the returned entity to the cache. This flag is used by GopherFindFirstFile, GopherOpenFile, HttpOpenRequest, and InternetOpenUrl.
	INTERNET_FLAG_NO_COOKIES    0x00080000
	;Does not automatically add cookie headers to requests, and does not automatically add returned cookies to the cookie database. This flag can be used by HttpOpenRequest and InternetOpenUrl (for HTTP requests).
	INTERNET_FLAG_NO_UI    0x00000200
	;Disables the cookie dialog box. This flag can be used by HttpOpenRequest and InternetOpenUrl (HTTP requests only).
	INTERNET_FLAG_OFFLINE    0x01000000
	;Identical to INTERNET_FLAG_FROM_CACHE. Does not make network requests. All entities are returned from the cache. If the requested item is not in the cache, a suitable error, such as ERROR_FILE_NOT_FOUND, is returned. Only the InternetOpen function uses this flag.
	INTERNET_FLAG_PASSIVE    0x08000000
	;Uses passive FTP semantics.
	;Only InternetConnect and InternetOpenUrl use this flag.
	;InternetConnect uses this flag for FTP requests, and InternetOpenUrl uses this flag for FTP files and directories.
	INTERNET_FLAG_PRAGMA_NOCACHE    0x00000100
	;Forces the request to be resolved by the origin server, even if a cached copy exists on the proxy. The InternetOpenUrl function (on HTTP and HTTPS requests only) and HttpOpenRequest function use this flag.
	INTERNET_FLAG_RAW_DATA    0x40000000
	;Returns the data as a GOPHER_FIND_DATA structure when retrieving Gopher directory information, or as a WIN32_FIND_DATA structure when retrieving FTP directory information.
	;If this flag is not specified or if the call is made through a CERN proxy, InternetOpenUrl returns the HTML version of the directory. Only the InternetOpenUrl function uses this flag.
	INTERNET_FLAG_READ_PREFETCH    0x00100000
	;This flag is currently disabled.
	INTERNET_FLAG_RELOAD    0x80000000
	;Forces a download of the requested file, object, or directory listing from the origin server, not from the cache.
	;The GopherFindFirstFile, GopherOpenFile, FtpFindFirstFile, FtpGetFile, FtpOpenFile, FtpPutFile, HttpOpenRequest, and InternetOpenUrl functions utilize this flag.
	INTERNET_FLAG_RESTRICTED_ZONE    0x00020000
	;Indicates that the cookie being set is associated with an untrusted site.
	INTERNET_FLAG_RESYNCHRONIZE    0x00000800
	;Reloads HTTP resources if the resource has been modified since the last time it was downloaded. All FTP and Gopher resources are reloaded. This flag can be used by GopherFindFirstFile, GopherOpenFile, FtpFindFirstFile, FtpGetFile, FtpOpenFile, FtpPutFile, HttpOpenRequest, and InternetOpenUrl.
	INTERNET_FLAG_SECURE    0x00800000
	;Uses secure transaction semantics. This translates to using Secure Sockets Layer/Private Communications Technology (SSL/PCT) and is only meaningful in HTTP requests. This flag is used by HttpOpenRequest and InternetOpenUrl, but this is redundant if https:// appears in the URL.The InternetConnect function uses this flag for HTTP connections; all the request handles created under this connection will inherit this flag.
	INTERNET_FLAG_TRANSFER_ASCII    0x00000001
	;Transfers file as ASCII (FTP only). This flag can be used by FtpOpenFile, FtpGetFile, and FtpPutFile.
	INTERNET_FLAG_TRANSFER_BINARY    0x00000002
	;Transfers file as binary (FTP only). This flag can be used by FtpOpenFile, FtpGetFile, and FtpPutFile.
	INTERNET_NO_CALLBACK    0x00000000
	;Indicates that no callbacks should be made for that API. This is used for the dxContext parameter of the functions that allow asynchronous operations.
	WININET_API_FLAG_ASYNC    0x00000001
	;Forces asynchronous operations.
	WININET_API_FLAG_SYNC    0x00000004
	;Forces synchronous operations.
	WININET_API_FLAG_USE_CONTEXT    0x00000008
	;Forces the API to use the context value, even if it is set to zero.
	
	
#ce