
; define some constants - can be used with _FTPPutFile and _FTPGetFile and ftp open flags
Global Const $INTERNET_FLAG_PASSIVE = 0x08000000
Global Const $INTERNET_FLAG_TRANSFER_ASCII = 0x00000001
Global Const $INTERNET_FLAG_TRANSFER_BINARY = 0x00000002
Global Const $INTERNET_DEFAULT_FTP_PORT = 21
Global Const $INTERNET_SERVICE_FTP = 1


Global Const $INTERNET_OPEN_TYPE_PRECONFIG = 0
Global Const $INTERNET_OPEN_TYPE_DIRECT = 1
Global Const $INTERNET_OPEN_TYPE_PROXY = 3


;dwFileAttributes for $WIN32_FIND_DATA ==================================================
Global Const $FILE_ATTRIBUTE_ARCHIVE  = 0x00000020 ;The file or directory is an archive file or directory. Applications use this attribute to mark files for backup or removal.
Global Const $FILE_ATTRIBUTE_COMPRESSED = 0x00000800 ;The file or directory is compressed. For a file, this means that all of the data in the file is compressed.For a directory, this means that compression is the default for newly created files and subdirectories.
Global Const $FILE_ATTRIBUTE_DIRECTORY = 0x00000010 ;The handle identifies a directory. 
Global Const $FILE_ATTRIBUTE_ENCRYPTED = 0x00004000 ;The file or directory is encrypted.For a file, this means that all data in the file is encrypted. For a directory, this means that encryption is the default for newly created files and subdirectories.
Global Const $FILE_ATTRIBUTE_HIDDEN = 0x00000002 ;The file or directory is hidden. It is not included in an ordinary directory listing.
Global Const $FILE_ATTRIBUTE_NORMAL = 0x00000080 ;The file or directory does not have other attributes set. This attribute is valid only when used alone.
Global Const $FILE_ATTRIBUTE_OFFLINE = 0x00001000 ;The file data is not available immediately. This attribute indicates that the file data is physically moved to offline storage.
;This attribute is used by Remote Storage, which is the hierarchical storage management software. Note  Applications should not arbitrarily change this attribute.
Global Const $FILE_ATTRIBUTE_READONLY = 0x00000001 ;The file or directory is read-only. For a file, applications can read the file, but cannot write to it or delete it.For a directory, applications cannot delete it.
Global Const $FILE_ATTRIBUTE_REPARSE_POINT = 0x00000400 ;The file or directory has an associated reparse point. 
Global Const $FILE_ATTRIBUTE_SPARSE_FILE  = 0x00000200 ;The file is a sparse file. 
Global Const $FILE_ATTRIBUTE_SYSTEM = 0x00000004 ;The file or directory is part of the operating system, or the operating system uses the file or directory exclusively. 
Global Const $FILE_ATTRIBUTE_TEMPORARY = 0x00000100 ; The file is being used for temporary storage. File systems attempt to keep all of the data in memory for quick access, rather than flushing it back to mass storage. 
;An application should delete a temporary file as soon as it is not needed.
Global Const $FILE_ATTRIBUTE_VIRTUAL = 0x00020000 ;A file is a virtual file. 
;===============================================================================

;dwFlags for FtpFindFirstFile ==================================================
If Not(IsDeclared("INTERNET_FLAG_HYPERLINK")) Then Global Const $INTERNET_FLAG_HYPERLINK = 0x400 ;Forces a reload if there was no Expires time and no LastModified time returned from the server when determining whether to reload the item from the network.
If Not(IsDeclared("INTERNET_FLAG_NEED_FILE")) Then Global Const $INTERNET_FLAG_NEED_FILE = 0x00000010 ;Causes a temporary file to be created if the file cannot be cached
If Not(IsDeclared("INTERNET_FLAG_NO_CACHE_WRITE")) Then Global Const $INTERNET_FLAG_NO_CACHE_WRITE = 0x04000000 ;Does not add the returned entity to the cache
If Not(IsDeclared("INTERNET_FLAG_RELOAD")) Then Global Const $INTERNET_FLAG_RELOAD = 0x80000000 ;Forces a download of the requested file, object, or directory listing from the origin server, not from the cache
If Not(IsDeclared("INTERNET_FLAG_RESYNCHRONIZE")) Then Global Const $INTERNET_FLAG_RESYNCHRONIZE = 0x00000800 ;Reloads HTTP resources if the resource has been modified since the last time it was downloaded. All FTP resources are reloaded
;===============================================================================
If Not(IsDeclared("s_WIN32_FIND_DATA")) Then Dim Const $s_WIN32_FIND_DATA = "dword;dword[2];dword[2];dword[2];dword;dword;dword;dword;char[256];char[14]"
If Not(IsDeclared("WIN32_FIND_DATA")) Then Dim $WIN32_FIND_DATA = 0 ;Allocate varible for pointer to WIN32_FIND_DATA Struct

;Constants for ftpFileRead
Global Const $GENERIC_READ = 0x80000000
Global Const $GENERIC_WRITE = 0x40000000
Global Const $FTP_TRANSFER_TYPE_UNKNOWN = 0 ;Defaults to FTP_TRANSFER_TYPE_BINARY.
Global Const $FTP_TRANSFER_TYPE_ASCII = 1 ;Transfers the file using FTP's ASCII (Type A) transfer method. Control and formatting information is converted to local equivalents. 
Global Const $FTP_TRANSFER_TYPE_BINARY = 2 ;Transfers the file using FTP's Image (Type I) transfer method. The file is transferred exactly as it exists with no changes. This is the default transfer method. 


Dim $h_WinINetDLL = 0

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

Func _FTPOpen($s_Agent, $l_AccessType = 1, $s_ProxyName = '', $s_ProxyBypass = '', $l_Flags = 0)
	
	$h_WinINetDLL = DllOpen('wininet.dll')
	
	Local $ai_InternetOpen = DllCall('wininet.dll', 'hwnd', 'InternetOpen', 'str', $s_Agent, 'long', $l_AccessType, _
						'str', $s_ProxyName, 'str', $s_ProxyBypass, 'long', $l_Flags)
	If @error OR $ai_InternetOpen[0] = 0 Then
		DllClose($h_WinINetDLL)
		$h_WinINetDLL = 0
		SetError(1)
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
	
	Local $ai_InternetConnect = DllCall('wininet.dll', 'long', 'InternetConnect', _
						'long', $l_InternetSession, _
						'str', $s_ServerName, _
						'int', $i_ServerPort, _
						'str', $s_Username, _
						'str', $s_Password, _
						'long', $l_Service, _
						'long', $l_Flags, _
						'long', $l_Context)
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

	Local $ai_FTPPutFile = DllCall('wininet.dll', 'int', 'FtpPutFile', _
						'long', $l_FTPSession, _
						'str', $s_LocalFile, _
						'str', $s_RemoteFile, _
						'long', $l_Flags, _
						'long', $l_Context)
	If @error OR $ai_FTPPutFile[0] = 0 Then
		MsgBox(0,"_FTPPutFile @error",@error)
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
	
	Local $ai_FTPPutFile = DllCall('wininet.dll', 'int', 'FtpDeleteFile', _
						'long', $l_FTPSession, _
						'str', $s_RemoteFile)
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
	
	Local $ai_FTPRenameFile = DllCall('wininet.dll', 'int', 'FtpRenameFile', _
						'long', $l_FTPSession, _
						'str', $s_Existing, _
						'str', $s_New)
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
	
	Local $ai_InternetCloseHandle = DllCall('wininet.dll', 'int', 'InternetCloseHandle', 'hwnd', $l_InternetSession)
	
	DllClose($h_WinINetDLL)
	$h_WinINetDLL = 0
	
	If @error OR $ai_InternetCloseHandle[0] = 0 Then
		SetError(-1)
		Return 0
	EndIf
	
	Return $ai_InternetCloseHandle[0]
	
EndFunc ;==> _FTPClose()


;===================================================================================================

;===============================================================================
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

;===============================================================================
;
; Function Name:    _FTPCommand()
; Description:      Sends a command to an FTP server.
; Parameter(s):     $l_FTPSession    - The Long from _FTPOpen()
;            		$s_FTPCommand     - Commad string to send to FTP Server
;            		$l_ExpectResponse   - Data socket for response in Async mode
;            		$s_Context         -  A pointer to a variable that contains an application-defined 
;                      value used to identify the application context in callback operations
;            		$s_Handle - A pointer to a handle that is created if a valid data socket is opened. 
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

Local $ai_FTPCommand = DllCall('wininet.dll', 'int', 'FtpCommand', 'long', $l_FTPSession, 'long', $l_ExpectResponse, 'long', $l_Flags, 'str', $s_FTPCommand, 'long', $l_Context, 'str', $s_Handle)
    If @error OR $ai_FTPCommand[0] = 0 Then
        SetError(-1)
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

    Local $ai_FTPGetCurrentDir = DllCall('wininet.dll', 'int', 'FtpGetCurrentDirectory', 'long', $l_FTPSession, 'str', "", 'long_ptr', 260)
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
Func _FTPGetFile($l_FTPSession, $s_RemoteFile, $s_LocalFile, $l_Flags = 2, $l_Fail = -1, $l_Attributes = 0, $l_Context = 0)

   Local $ai_FTPGetFile = DllCall('wininet.dll', 'int', 'FtpGetFile', 'long', $l_FTPSession, 'str', $s_RemoteFile, 'str', $s_LocalFile, 'long', $l_Fail, 'long', $l_Attributes, 'long', $l_Flags, 'long', $l_Context)
   If @error OR $ai_FTPGetFile[0] = 0 Then
       SetError(-1)
       Return 0
   EndIf
   
   Return $ai_FTPGetFile[0]
   
EndFunc;==> _FTPGetFile()

;===============================================================================
;===============================================================================


;===============================================================================
; Function Name:    _FTPFindFirstFile()
; Description:      Returns a search handle to be used with _FTPFindNextFile()
; Parameter(s):     $l_FTPSession 		- The long from _FTPConnect()
;                   $lpszSearchFile   	- The remote Location for the file.
;                   $dwFlags  			- use the dwFlags parameter to specify 1 for transferring the file in ASCII (Type A transfer method) or 2 for transferring the file in Binary (Type I transfer method).
;                   $dwContext   		- lContext is used to identify the application context when using callbacks (Default: 0)
; Requirement(s):   DllCall, wininet.dll
; Return Value(s):  On Success - Returns Search Handle
;                   On Failure - 0; Sets @error = -1
; Comments:			Tested with Current Remote Directory only, use _FtpSetCurrentDir() to change directory before calling _FTPFindFirstFile()
;					Remember to call _FTPClose($SearchHwnd) to close the search handle
;===============================================================================
Func _FTPFindFirstFile($l_FTPSession, $lpszSearchFile = "",$dwFlags = 0, $dwContext = 0)
	
	$WIN32_FIND_DATA = DllStructCreate($s_WIN32_FIND_DATA) ;declared above
	If @error Then 
		SetError(-2)
		Return 0
	EndIf

	Local $ai_FTPFirstFile = DllCall('wininet.dll', 'hwnd', 'FtpFindFirstFile', _
						'long', $l_FTPSession, _ 							;HINTERNET hConnect
						'str', $lpszSearchFile, _  						;LPCTSTR lpszSearchFile
						'ptr',DllStructGetPtr($WIN32_FIND_DATA), _ 		;LPWIN32_FIND_DATA lpFindFileData
						'dword',$dwFlags, _  							;DWORD dwFlags
						'dword', $dwContext) 							;DWORD_PTR dwContext
							
	If @error OR $ai_FTPFirstFile[0] = 0 Then
		SetError(-1)
		Return 0
	EndIf
		
	Return $ai_FTPFirstFile[0]
	
EndFunc ;==> _FTPFindFirstFile()


;===============================================================================
; Function Name:    _FTPFindNextFile()
; Description:      Find Next File on an FTP server.
; Parameter(s):     $h_Search 		- The search hwnd returned by _FTPFindFirstFile()
;                   $s_Filter    - Search Filter (Default = "*.*").
;					$s_Flag		- 0(Default) Return both files and folders names
;								- 1 Return file names only (Folders are returned as -1)
;								- 2 Return folder names only (Files are returned as -1)
;								- 3 Return Attributes Array (includes file/folder name)
; Requirement(s):   DllCall, wininet.dll
; Return Value(s):  On Success - Filename or Attributes Array
;                   On Failure - Last Filename or Attributes Array and @error = -1
;===============================================================================
Func _FTPFindNextFile($h_Search,$s_Filter = "*.*", $s_Flag = 0)

	Local Const $MAXDWORD = 4294967295
	Local $LastFilename
	Local $a_FTPFileData[8]
		$a_FTPFileData[0] = 7
	Local $FileAttributes = DllStructGetData($WIN32_FIND_DATA, 1)    ; File Attributes
	
	Switch $s_Flag
		
		Case 0 ;0(Default) Return both files and folders names
			
			$LastFilename = DllStructGetData($WIN32_FIND_DATA, 9)
			
		Case 1;Return file names only (Folders are returned as -1)
			If $FileAttributes <> $FILE_ATTRIBUTE_DIRECTORY Then
				$LastFilename = DllStructGetData($WIN32_FIND_DATA, 9)
			Else
				$LastFilename = -1
			EndIf
			
		Case 2 ;Return folder names only (Files are returned as -1)
			If $FileAttributes == $FILE_ATTRIBUTE_DIRECTORY Then
				$LastFilename = DllStructGetData($WIN32_FIND_DATA, 9)
			Else
				$LastFilename = -1
			EndIf
			
		Case 3 ;Return Attributes Array (includes file/folder name)
			
			$a_FTPFileData[1] = DllStructGetData($WIN32_FIND_DATA, 1)    ; File Attributes
			
			$FILETIME = DllStructCreate("dword;dword")
			DllStructSetData($FILETIME, 1, DllStructGetData($WIN32_FIND_DATA, 2, 1)); Creation Time Low
			DllStructSetData($FILETIME, 2, DllStructGetData($WIN32_FIND_DATA, 2, 2)); Creation Time High
			$a_FTPFileData[2] = _FileTimeToSystemTime(DllStructGetPtr($FILETIME))

			DllStructSetData($FILETIME, 1, DllStructGetData($WIN32_FIND_DATA, 3, 1)); Access Time Low
			DllStructSetData($FILETIME, 2, DllStructGetData($WIN32_FIND_DATA, 3, 2)); Access Time High
			$a_FTPFileData[3] = _FileTimeToSystemTime(DllStructGetPtr($FILETIME))

			DllStructSetData($FILETIME, 1, DllStructGetData($WIN32_FIND_DATA, 4, 1));  Last Write Time Low
			DllStructSetData($FILETIME, 2, DllStructGetData($WIN32_FIND_DATA, 4, 2));  Last Write Time High
			$a_FTPFileData[4] = _FileTimeToSystemTime(DllStructGetPtr($FILETIME))
			
			;The size of the file is equal to (nFileSizeHigh * (MAXDWORD+1)) + nFileSizeLow
			$a_FTPFileData[5] = (DllStructGetData($WIN32_FIND_DATA, 5) * ($MAXDWORD + 1)) + DllStructGetData($WIN32_FIND_DATA, 6)
			
			$a_FTPFileData[6] = DllStructGetData($WIN32_FIND_DATA, 9); File Name
			$a_FTPFileData[7] = DllStructGetData($WIN32_FIND_DATA, 10)  ; Altername
			
;~ 			_ArrayDisplay($a_FTPFileData,"$a_FTPFileData")
			
	EndSwitch
	
	
	;Need to add code to handle the string filter
	
	Local $ai_FTPNextFile = DllCall('wininet.dll', 'int', 'InternetFindNextFile', _
						'long', $h_Search, _								;HINTERNET hFind
						'ptr',DllStructGetPtr($WIN32_FIND_DATA))		;LPVOID lpvFindData
	

	If @error OR $ai_FTPNextFile[0] = 0 Then
		_FTPFindFileClose($h_Search) ;close the handle to the search when no more files or folders are found
		SetError(-1)
		If $s_Flag == 3 Then
			Return $a_FTPFileData
		Else
			Return $LastFilename
		EndIf
	EndIf
	
	If $s_Flag == 3 Then
		Return $a_FTPFileData
	Else
		Return $LastFilename
	EndIf
	
	
EndFunc ;==> _FTPFindNextFile()

;===============================================================================
; Function Name:    _FTPFindFileClose()
; Description:      Delete $WIN32_FIND_DATA Structure.
; Parameter(s):     
; Requirement(s):   DllCall, wininet.dll
; Return Value(s):  On Success - 1
;                   On Failure - 0
;===============================================================================
Func _FTPFindFileClose($h_Search)

  $WIN32_FIND_DATA = 0 ;free memory
   
   Local $ai_FTPCloseHwnd = DllCall('wininet.dll', 'int', 'InternetCloseHandle', 'long', $h_Search)
   If @error OR $ai_FTPCloseHwnd[0] = 0 Then
		SetError(-1)
		Return 0
   EndIf

   Return $ai_FTPCloseHwnd[0]
EndFunc;==> _FTPFileFindClose()



;===============================================================================
; Function Name:    _FTPGetLinkStringInfo()
; Description:      Gets Information about an ftp string (ie. "ftp://user:pass@servername:port/path/"  or "servername:port/path"
; Parameter(s):     $s_FTPLink 		- [in]The string to get the information from (ie. "ftp://user:pass@servername:port/")
;                   $s_ServerName   - [in/out] Name of the Server (ie. name.host.net)
;					$s_Username		- [in/out] Name of the user if found in $s_FTPLink
;					$s_Password		- [in/out] Password for user if found in $s_FTPLink
;					$i_ServerPort	- [in/out] Port toi connect on if found in $s_FTPLink (Default: 21)
; Requirement(s):   None
; Return Value(s):  On Success  - Returns the path from $s_FTPLink
;								- Sets Extended to 1 for $s_FTPLink to ahve form of "ftp://...../"
;								- Sets Extended to 2 for $s_FTPLink to ahve form of " name.host.net...."
;                   On Failure  - 0 and @error = -1
;===============================================================================
Func _FTPGetLinkStringInfo($s_FTPLink,ByRef $s_ServerName, ByRef $s_Username, ByRef $s_Password, ByRef $i_ServerPort)
	
	Local $errFlag = 0,$extFlag = 0
	Local $s_ServerPort,$s_FTPPath
	
	If StringInStr($s_FTPLink,"ftp://") Then ;Written as Link ie. ftp://user:pass@servername:port/path/)
		$extFlag = 2
		If StringInStr($s_FTPLink,"@") Then ;has info about username and password (ie. ftp://user:pass@servername/)
			$s_Username = StringMid($s_FTPLink,StringInStr($s_FTPLink,"ftp://") + 6,StringInStr($s_FTPLink,":",0,2) - StringInStr($s_FTPLink,"ftp://") - 6)
			$s_Password = StringMid($s_FTPLink,StringInStr($s_FTPLink,":",0,2) + 1,StringInStr($s_FTPLink,"@") - StringInStr($s_FTPLink,":",0,2)-1)
			
			If StringInStr($s_FTPLink,":",0,3) Then ;has info about port (ftp://user:pass@servername:port or ftp://user:pass@servername:port/)
				If StringInStr($s_FTPLink,"/",0,3) Then ;trailing slash exists or a path was included (ie. ftp://user:pass@servername:port/path/)
					$s_ServerName = StringMid($s_FTPLink,StringInStr($s_FTPLink,"@") + 1,StringInStr($s_FTPLink,":",0,3) - StringInStr($s_FTPLink,"@") - 1)
					$s_ServerPort = StringMid($s_FTPLink,StringInStr($s_FTPLink,":",0,3) + 1,StringInStr($s_FTPLink,"/",0,3) - StringInStr($s_FTPLink,"ftp://")-1)
					$i_ServerPort = Number($s_ServerPort)
					$s_FTPPath = StringMid($s_FTPLink,StringInStr($s_FTPLink,"/",0,3)) ;including root "/"
				Else ;no trailing slash (ftp://user:pass@servername:port)
					$s_ServerName = StringMid($s_FTPLink,StringInStr($s_FTPLink,"@") + 1,StringInStr($s_FTPLink,":",0,3) - StringInStr($s_FTPLink,"@")-1)
					$s_ServerPort = StringMid($s_FTPLink,StringInStr($s_FTPLink,":",0,3) + 1)
					$i_ServerPort = Number($s_ServerPort)
					$s_FTPPath = "/"
				EndIf
				
			Else ; no info about port assume default: 21 (ftp://user:pass@servername or ftp://user:pass@servername/)
				$i_ServerPort = 21
				If StringInStr($s_FTPLink,"/",0,3) Then ;trailing slash exists or a path was included (ie. ftp://user:pass@servername/path/)
					$s_ServerName = StringMid($s_FTPLink,StringInStr($s_FTPLink,"@") + 1,StringInStr($s_FTPLink,"/",0,3) - StringInStr($s_FTPLink,"@")-1)
					$s_FTPPath = StringMid($s_FTPLink,StringInStr($s_FTPLink,"/",0,3)) ;including root "/"
				Else ;no trailing slash (ftp://user:pass@servername)
					$s_ServerName = StringMid($s_FTPLink,StringInStr($s_FTPLink,"@") + 1)
					$s_FTPPath = "/"
				EndIf
			EndIf
		Else ;no info about username and password (ie. ftp://servername/ or ftp://servername:port)
			If StringInStr($s_FTPLink,":",0,2) Then ;has info about port (ftp://servername:port or ftp://servername:port/)
				If StringInStr($s_FTPLink,"/",0,3) Then ;trailing slash exists or a path was included (ie. ftp://servername:port/path/)
					$s_ServerName = StringMid($s_FTPLink,StringInStr($s_FTPLink,"ftp://") + 6,StringInStr($s_FTPLink,":",0,2) - StringInStr($s_FTPLink,"ftp://")-6)
					$s_ServerPort = StringMid($s_FTPLink,StringInStr($s_FTPLink,":",0,2) + 1,StringInStr($s_FTPLink,"/",0,3) - StringInStr($s_FTPLink,"ftp://")-1)
					$i_ServerPort = Number($s_ServerPort)
					$s_FTPPath = StringMid($s_FTPLink,StringInStr($s_FTPLink,"/",0,3)) ;including root "/"
				Else ;no trailing slash (ftp://servername:port)
					$s_ServerName = StringMid($s_FTPLink,StringInStr($s_FTPLink,"ftp://") + 6,StringInStr($s_FTPLink,":",0,2) - StringInStr($s_FTPLink,"ftp://")-6)
					$s_ServerPort = StringMid($s_FTPLink,StringInStr($s_FTPLink,":",0,2) + 1)
					$i_ServerPort = Number($s_ServerPort)
					$s_FTPPath = "/"
				EndIf
			Else ; no info about port assume default: 21 (ie. ftp://servername or ftp://servername/)
				$i_ServerPort = 21
				If StringInStr($s_FTPLink,"/",0,3) Then ;trailing slash exists or a path was included (ie. ftp://servername/path/)
					$s_ServerName = StringMid($s_FTPLink,StringInStr($s_FTPLink,"ftp://") + 6,StringInStr($s_FTPLink,"/",0,3) - StringInStr($s_FTPLink,"ftp://")-6)
					$s_FTPPath = StringMid($s_FTPLink,StringInStr($s_FTPLink,"/",0,3)) ;including root "/"
				Else ;no trailing slash (ftp://servername)
					$s_ServerName = StringMid($s_FTPLink,StringInStr($s_FTPLink,"ftp://") + 6,StringInStr($s_FTPLink,"/",0,3) - StringInStr($s_FTPLink,"ftp://")-6)
					$s_FTPPath = "/"
				EndIf
			EndIf
		EndIf
		
		
	ElseIf StringInStr($s_FTPLink,".") Then ;Written with ftp servername not as Link ie. servername:port/path
		$extFlag = 1
		If StringInStr($s_FTPLink,":") Then ;port number exists servername:port or servername:port/path
			$s_ServerName = StringMid($s_FTPLink,1,StringInStr($s_FTPLink,":") - 1)
			If StringInStr($s_FTPLink,"/") Then ;path info exists servername:port/path
				$s_ServerPort = StringMid($s_FTPLink,StringInStr($s_FTPLink,":") + 1,StringInStr($s_FTPLink,"/") - StringInStr($s_FTPLink,":")-1)
				$i_ServerPort = Number($s_ServerPort)
				$s_FTPPath = StringMid($s_FTPLink,StringInStr($s_FTPLink,"/"))
			Else ;no slash found servername:port
				$s_ServerPort = StringMid($s_FTPLink,StringInStr($s_FTPLink,":") + 1)
				$i_ServerPort = Number($s_ServerPort)
				$s_FTPPath = "/"
			EndIf
		Else ; no port info assume default: 21 (ie. servername or servername/path)
			$i_ServerPort = 21
			If StringInStr($s_FTPLink,"/") Then ;path info exists
				$s_ServerName = StringMid($s_FTPLink,1,StringInStr($s_FTPLink,"/") - 1)
				$s_FTPPath = StringMid($s_FTPLink,StringInStr($s_FTPLink,"/"))
			Else
				$s_ServerName = $s_FTPLink
				$s_FTPPath = "/"
			EndIf
			
		EndIf
	Else ;might not be a string containg ftp information
		$extFlag = 0
		$errFlag = -1
		$s_FTPPath = 0
	EndIf
	
	SetExtended($extFlag)
	SetError($errFlag)
	Return $s_FTPPath
	
EndFunc


;===============================================================================
; Function Name:    _FileTimeToSystemTime()
; Description:      Converts the FILETIME struct to more useful information.
; Parameter(s):     $p_FILETIME 	- [in] pointer to the FILETIME struct
; Requirement(s):   DllCall, Kernel32.dll
; Return Value(s):  On Success - A pipe delimited string (ie. Year|Month|DayOfWeek|Day|Hour|Minute|Second|Milliseconds|)
;                   On Failure - 0 and Sets @error = -1
;Notes	
;~ wYear WORD
;~ 		The year. The valid values for this member are 1601 through 30827. 
;~ wMonth WORD
;~ 		The month. This member can be one of the following values.Value Meaning 
;~ 		1 January 
;~ 		2 February 
;~ 		3 March 
;~ 		4 April 
;~ 		5 May 
;~ 		6 June 
;~ 		7 July 
;~ 		8 August 
;~ 		9 September 
;~ 		10 October 
;~ 		11 November 
;~ 		12 December 
;~ wDayOfWeek WORD
;~ 		The day of the week. This member can be one of the following values. Value Meaning 
;~ 		0 Sunday 
;~ 		1 Monday 
;~ 		2 Tuesday 
;~ 		3 Wednesday 
;~ 		4 Thursday 
;~ 		5 Friday 
;~ 		6 Saturday 
;~ wDay WORD
;~ 		The day of the month. The valid values for this member are 1 through 31. 
;~ wHour WORD
;~ 		The hour. The valid values for this member are 0 through 23. 
;~ wMinute WORD
;~ 		The minute. The valid values for this member are 0 through 59. 
;~ wSecond WORD
;~ 		The second. The valid values for this member are 0 through 59. 
;~ wMilliseconds WORD
;~ 		The millisecond. The valid values for this member are 0 through 999
;===============================================================================
Func _FileTimeToSystemTime($p_FILETIME) ;uses Kernel32.dll

	Local $s_FileTime = ""
	Local $SYSTEMTIME = DllStructCreate("short;short;short;short;short;short;short;short")
	If @error Then 
		SetError(-2)
		Return 0
	EndIf

	Local $ai_FileTime = DllCall('Kernel32.dll', 'int', 'FileTimeToSystemTime', _
						'ptr', $p_FILETIME, _					;const FILETIME* lpFileTime
						'ptr',DllStructGetPtr($SYSTEMTIME))		;LPSYSTEMTIME lpSystemTime
						
	If @error OR $ai_FileTime[0] == 0 Then
		$SYSTEMTIME = 0 ;free memory
		SetError(-1)
		Return 0
	EndIf
	
	For $i = 1 To 8
		$s_FileTime &= DllStructGetData($SYSTEMTIME,$i) & "|"
	Next

	$SYSTEMTIME = 0 ;free memory
	
	Return $s_FileTime					
	
EndFunc




;===============================================================================
; Function Name:    _FTPOpenFile()
; Description:      Initiates access to a remote file on an FTP server for reading or writing. Use _FTPCloseFile()
;					to close the ftp file.
; Parameter(s):     $hConnect 		- The long from _FTPConnect()
;					$lpszFileName	- String of the ftp file to open
;					$dwAccess		- GENERIC_READ or GENERIC_WRITE (Default is GENERIC_READ)
;					$dwFlags		- Settings for the transfer see notes below (Default is 2 for FTP_TRANSFER_TYPE_BINARY)
;					$dwContext		- (Not Used) See notes below
; Requirement(s):   DllCall, wininet.dll
; Return Value(s):  On Success - Returns the handle to ftp file for read/write with _FTPReadFile()
;                   On Failure - 0 and Sets @error = -1
;Notes:
;~ hConnect 
;~ 		[in] Handle to an FTP session. 
;~ lpszFileName 
;~ 		[in] Pointer to a null-terminated string that contains the name of the file to be accessed. 
;~ dwAccess 
;~ 		[in] File access. This parameter can be GENERIC_READ or GENERIC_WRITE, but not both. 
;~ dwFlags 
;~ 		[in] Conditions under which the transfers occur. The application should select one transfer type and any of 
;				the flags that indicate how the caching of the file will be controlled.
;~ The transfer type can be one of the following values.
;~ 		FTP_TRANSFER_TYPE_ASCII Transfers the file using FTP's ASCII (Type A) transfer method. Control and 
;				formatting information is converted to local equivalents. 
;~ 		FTP_TRANSFER_TYPE_BINARY Transfers the file using FTP's Image (Type I) transfer method. The file is 
;				transferred exactly as it exists with no changes. This is the default transfer method. 
;~ 		FTP_TRANSFER_TYPE_UNKNOWN Defaults to FTP_TRANSFER_TYPE_BINARY. 
;~ 		INTERNET_FLAG_TRANSFER_ASCII Transfers the file as ASCII. 
;~ 		INTERNET_FLAG_TRANSFER_BINARY Transfers the file as binary. 
;~ The following values are used to control the caching of the file. The application can use one or more of these values.
;~ 		INTERNET_FLAG_HYPERLINK Forces a reload if there was no Expires time and no LastModified time returned from the server 
;				when determining whether to reload the item from the network. 
;~ 		INTERNET_FLAG_NEED_FILE Causes a temporary file to be created if the file cannot be cached. 
;~ 		INTERNET_FLAG_RELOAD Forces a download of the requested file, object, or directory listing from the origin server, 
;				not from the cache. 
;~ 		INTERNET_FLAG_RESYNCHRONIZE Reloads HTTP resources if the resource has been modified since the last time it was 
;				downloaded. All FTP and Gopher resources are reloaded. 
;~ dwContext 
;~ 		[in] Pointer to a variable that contains the application-defined value that associates this search with any 
;				application data. This is only used if the application has already called InternetSetStatusCallback to set 
;				up a status callback function. 
;===============================================================================
Func _FTPOpenFile($hConnect,$lpszFileName,$dwAccess = 0x80000000,$dwFlags = 2,$dwContext = 0)

	Local $ai_FTPOpenFile = DllCall('wininet.dll', 'hwnd', 'FtpOpenFile', _
						'hwnd', $hConnect, _			;HINTERNET hConnect
						'str', $lpszFileName, _			;LPCTSTR lpszFileName
						'udword', $dwAccess, _		;DWORD dwAccess
						'dword', $dwFlags, _						;DWORD dwFlags
						'dword',$dwContext)						;DWORD_PTR dwContext
						
	If @error OR $ai_FTPOpenFile[0] == 0 Then
		SetError(-1)
		Return 0
	EndIf
	
	Return $ai_FTPOpenFile[0]
	
EndFunc

;===============================================================================
; Function Name:    _FTPReadFile()
; Description:      Reads data from a handle opened by _FTPOpenFile()
; Parameter(s):     $h_File 				- Handle returned by _FTPOpenFile to the ftp file
;					$dwNumberOfBytesToRead	- Number of bytes to read
; Requirement(s):   DllCall, wininet.dll
; Return Value(s):  On Success - Returns the binary/string read.
;                   On Failure - 0 and Sets @error = -1 for end-of-file, @error = 1 for other errors
;Notes:	(InternetReadFile() parameters)
;~ hFile 
;~ 		[in] Handle returned from a previous call to InternetOpenUrl, FtpOpenFile, GopherOpenFile, or HttpOpenRequest. 
;~ lpBuffer 
;~ 		[out] Pointer to a buffer that receives the data. 
;~ dwNumberOfBytesToRead 
;~ 		[in] Number of bytes to be read. 
;~ lpdwNumberOfBytesRead 
;~ 		[out] Pointer to a variable that receives the number of bytes read. InternetReadFile sets this value to zero before doing any work or error checking. 
;===============================================================================
Func _FTPReadFile($h_File,$dwNumberOfBytesToRead)
	
	Local $s_FileRead = "",$BytesRead = 0
	$lpBuffer = DllStructCreate("byte[" & $dwNumberOfBytesToRead & "]")
	$lpdwNumberOfBytesRead = DllStructCreate("long")
	
	Local $ai_FTPReadFile = DllCall('wininet.dll', 'int', 'InternetReadFile', _
						'hwnd', $h_File, _								;HINTERNET hFile
						'ptr', DllStructGetPtr($lpBuffer), _			;LPVOID lpBuffer
						'dword', $dwNumberOfBytesToRead, _				;DWORD dwNumberOfBytesToRead
						'ptr',DllStructGetPtr($lpdwNumberOfBytesRead))	;LPDWORD lpdwNumberOfBytesRead
	$BytesRead = DllStructGetData($lpdwNumberOfBytesRead,1)
	If @error OR $ai_FTPReadFile[0] == 0 Then
		$lpBuffer = 0
		$lpdwNumberOfBytesRead = 0
		If $BytesRead == 0 Then
			SetError(-1)   	;end-of-file error
		Else
			SetError(1)	;general error
		EndIf
		Return 0
	EndIf
	$s_FileRead = DllStructGetData($lpBuffer,1);index is omitted so the entire array is written into $s_FileRead as a BinaryString

	$lpBuffer = 0
	$lpdwNumberOfBytesRead = 0

	If $BytesRead = 1 Then
		Return Chr($s_FileRead) ;without this a 1 byte read will return a decimal value of the 8 bits read
	Else
		Return $s_FileRead ;return as binarystring (character string where all 0-255 ASCII values are allowed)
	EndIf
		
EndFunc

;===============================================================================
; Function Name:    _FTPCloseFile()
; Description:      Closes the Handle returned by _FTPOpenFile.
; Parameter(s):     $l_InternetSession	- The handles from _FTPOpenFile.()
; Requirement(s):   DllCall, wininet.dll
; Return Value(s):  On Success - 1
;                   On Failure - 0 Sets @error = -1
;===============================================================================
Func _FTPCloseFile($l_InternetSession)
	
	Local $ai_InternetCloseHandle = DllCall('wininet.dll', 'int', 'InternetCloseHandle', 'hwnd', $l_InternetSession)
	
	
	If @error OR $ai_InternetCloseHandle[0] = 0 Then
		SetError(-1)
		Return 0
	EndIf
	
	Return $ai_InternetCloseHandle[0]
	
EndFunc
