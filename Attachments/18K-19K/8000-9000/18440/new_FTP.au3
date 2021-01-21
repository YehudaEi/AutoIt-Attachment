#include-once

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






; define some constants - can be used with _FTPPutFile and _FTPGetFile and ftp open flags
Const $INTERNET_FLAG_PASSIVE = 0x08000000
Const $INTERNET_FLAG_TRANSFER_ASCII = 0x00000001
Const $INTERNET_FLAG_TRANSFER_BINARY = 0x00000002
Const $INTERNET_DEFAULT_FTP_PORT = 21
Const $INTERNET_SERVICE_FTP = 1

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
; Function Name:    _FTPGetFileSize()
; Description:      Gets filesize of a file on the FTP server.
; Parameter(s):     $l_FTPSession	- The Long from _FTPConnect()
;                   $s_FileName 	- The file name.
; Requirement(s):   DllCall, wininet.dll
; Return Value(s):  On Success - 1
;                   On Failure - 0
; Author(s):        J.o.a.c.h.i.m. d.e. K.o.n.i.n.g.
;
;===============================================================================

Func _FTPGetFileSize($l_FTPSession, $s_FileName)

	Local $ai_FTPGetSizeHandle = DllCall('wininet.dll', 'int', 'FtpOpenFile', 'long', $l_FTPSession, 'str', $s_FileName, 'long', 0x80000000, 'long', 0x04000002, 'long', 0)
	Local $ai_FTPGetFileSize = DllCall('wininet.dll', 'int', 'FtpGetFileSize', 'long', $ai_FTPGetSizeHandle[0])
	If @error OR $ai_FTPGetFileSize[0] = 0 Then
		SetError(-1)
		Return 0
	EndIf
	DllCall('wininet.dll', 'int', 'InternetCloseHandle', 'str', $l_FTPSession)

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
; Return Value(s):  On Success - 1
;                   On Failure - 0
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
#ce
Func _FTPFileFindFirst($l_FTPSession, $s_RemoteFile, ByRef $h_Handle, ByRef $l_DllStruct, $l_Flags = 0, $l_Context = 0)

   Local $str  = "int;uint[2];uint[2];uint[2];int;int;int;int;char[256];char[14]"
   $l_DllStruct = DllStructCreate($str)
   if @error Then
SetError(-2)
Return ""
   endif

   Dim $a_FTPFileList[1]
   $a_FTPFileList[0] = 0

   Local $ai_FTPPutFile = DllCall('wininet.dll', 'int', 'FtpFindFirstFile', 'long', $l_FTPSession, 'str', $s_RemoteFile, 'ptr', DllStructGetPtr($l_DllStruct), 'long', $l_Flags, 'long', $l_Context)
If @error OR $ai_FTPPutFile[0] = 0 Then
SetError(-1)
Return $a_FTPFileList
EndIf
   $h_Handle = $ai_FTPPutFile[0]
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
; Return Value(s):  On Success - 1
;                   On Failure - 0
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

   Return $a_FTPFileList

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


Func _FTPGetFile($l_FTPSession, $s_RemoteFile, $s_LocalFile, $l_Flags = 2, $l_Fail = -1, $l_Attributes = 0, $l_Context = 0)

   Local $ai_FTPGetFile = DllCall('wininet.dll', 'int', 'FtpGetFile', 'long', $l_FTPSession, 'str', $s_RemoteFile, 'str', $s_LocalFile, 'long', $l_Fail, 'long', $l_Attributes, 'long', $l_Flags, 'long', $l_Context)
   If @error OR $ai_FTPGetFile[0] = 0 Then
       SetError(-1)
       Return 0
   EndIf
   
   Return $ai_FTPGetFile[0]
   
EndFunc;==> _FTPGetFile()






;===============================================================================
;
; Function Name:    _FTP_File_List_To_Array
; Description:      Lists all files and folders in a specified path on FTP server.
; Syntax :			_FTP_File_List_To_Array($l_FTPSession, $s_Remote)
; Parameter(s):     $l_FTPSession   - The Long from _FTPConnect()
;                   $s_Remote      	- The remote Location for the directory.
; Requirement(s):   DllCall, wininet.dll, Array.au3.
;					FTP.au3 of Wouter van Kesteren.
;					Functions : _FtpFileFindFirst(), _FtpFileFindNext(), _FtpFileFindClose() of Dick Bronsdijk.
; Return Value(s):  On Success - returns an array with list of directory and files.
;                   On Failure - returns False.
; Author(s):        Neuro - Jérémy GUILLOT.
;
;===============================================================================

#include <Array.au3>

Func _FTP_File_List_To_Array($l_FTPSession, $s_Remote = "/")

	Local $array[2]
	Local $array_end = UBound($array)
	Local $i
	Local $line
	Local $Handle
	Local $DllRect
	Local $j
	
	If $s_Remote == "" Then
		$s_Remote = "/"
	ElseIf $s_Remote <> "" And $s_Remote <> "/" Then
		If StringLeft($s_Remote, 1) <> "/" Then
			$s_Remote = "/" & $s_Remote
		EndIf
		If StringRight($s_Remote, 1) <> "/" Then
			$s_Remote = $s_Remote & "/"
		EndIf
	EndIf	
	
	$array[0] = 1
	$array[1] = "directory" & ";;;;;" & $s_Remote & ";;;;;" & "0"

;~ directory list
	While $i <= $array_end
		$line = StringSplit($array[$i], ";;;;;", 1)
		If IsArray($line) And $line[0] == 3 Then
			If $line[3] == 0 Then
				
				$j = 1
				Local $FileInfo = _FtpFileFindFirst($l_FTPSession, $line[2] & "*", $Handle, $DllRect)
				If @error Then Return False
				
				If $FileInfo[0] Then
					Do
						
;~ 		 			   	If current is directory then insert directory in array
						If $FileInfo[1] == 16 And $FileInfo[10] <> "." And $FileInfo[10] <> ".." Then ; dir attrib = 16
							ReDim $array[UBound($array)]
							$array_end = UBound($array)
							$array[0] += 1
							_ArrayInsert($array, $i + $j, "directory" & ";;;;;" & $line[2] & $FileInfo[10] & "/" & ";;;;;" & "0")
							$j += 1
						EndIf
				
						$FileInfo = _FtpFileFindNext($Handle, $DllRect)
					   
					Until Not $FileInfo[0]

				EndIf
				_FtpFileFindClose($Handle, $DllRect)
				$array[$i] = "directory" & ";;;;;" & $line[2] & ";;;;;" & "1"
				$i = 1				
				
			EndIf
;~ 			ConsoleWrite("directory find : " & $line[2] & @CRLF)
		EndIf		
		$i += 1
	WEnd

;~ set all 1 in array to 0, to perform a new search
	For $i = 1 To UBound($array) - 1
		$line = StringSplit($array[$i], ";;;;;", 1)
		If IsArray($line) And $line[0] == 3 Then
			If $line[3] <> 0 Then
				$array[$i] = "directory" & ";;;;;" & $line[2] & ";;;;;" & "0"
			EndIf
		EndIf
	Next

;~ files list
	$i = 1
	While $i <= $array_end
		$line = StringSplit($array[$i], ";;;;;", 1)
		If IsArray($line) And $line[0] == 3 Then
			If $line[1] == "directory" And $line[3] == 0 Then
				
				$j = 1
				$FileInfo = _FtpFileFindFirst($l_FTPSession, $line[2] & "*", $Handle, $DllRect)
				If @error Then Return False
				
				If $FileInfo[0] Then
					Do
						
;~ 		 			   	If current is file then insert the file in array
						If $FileInfo[1] == 128 Then ; file attrib = 128
;~ 		 					ConsoleWrite("file find : " & $line[2] & $FileInfo[10] & @CRLF)
							ReDim $array[UBound($array)]
							$array_end = UBound($array)
							$array[0] += 1
							_ArrayInsert($array, $i + $j, "file" & ";;;;;" & $line[2] & $FileInfo[10] & ";;;;;" & "1")
							$j += 1
						EndIf	
				
						$FileInfo = _FtpFileFindNext($Handle, $DllRect)
					   
					Until Not $FileInfo[0]

				EndIf
				_FtpFileFindClose($Handle, $DllRect)
				$array[$i] = "directory" & ";;;;;" & $line[2] & ";;;;;" & "1"
				$i = 1
				
			EndIf
		EndIf
		$i += 1
	WEnd

;~ 	clean array
	For $i = 1 To UBound($array) - 1
		$line = StringSplit($array[$i], ";;;;;", 1)
		If IsArray($line) And $line[0] == 3 Then
			$array[$i] = $line[2]
		EndIf
	Next	
	
	Return $array

EndFunc ;==> _FTP_File_List_To_Array





;===============================================================================
;
; Function Name:    _FTP_Delete_Recursive
; Description:      Delete all files and folders in a specified path on FTP server.
; Syntax :			_FTP_Delete_Recursive($l_FTPSession, $s_Remote)
; Parameter(s):     $l_FTPSession   - The Long from _FTPConnect()
;                   $s_Remote      	- The remote Location for the directory.
; Requirement(s):   DllCall, wininet.dll, Array.au3.
;					FTP.au3 of Wouter van Kesteren.
;					Functions : _FtpFileFindFirst(), _FtpFileFindNext(), _FtpFileFindClose() of Dick Bronsdijk.
; Return Value(s):  On Success - returns True.
;                   On Failure - returns False.
; Author(s):        Neuro - Jérémy GUILLOT.
;
;===============================================================================

#include <Array.au3>

Func _FTP_Delete_Recursive($l_FTPSession, $s_Remote)

	Local $array[2]
	Local $array_end = UBound($array)
	Local $i
	Local $line
	Local $Handle
	Local $DllRect
	Local $j
	Local $k
	
	If $s_Remote == "" Then
		$s_Remote = "/"
		$array[0] = $s_Remote & ";;;;;" & "0"
		$i = 0
	ElseIf $s_Remote <> "" And $s_Remote <> "/" Then
		If StringLeft($s_Remote, 1) <> "/" Then
			$s_Remote = "/" & $s_Remote
		EndIf
		If StringRight($s_Remote, 1) <> "/" Then
			$s_Remote = $s_Remote & "/"
		EndIf
		$array[1] = $s_Remote & ";;;;;" & "0"
		$i = 1
	Else
		$array[1] = $s_Remote & ";;;;;" & "0"
		$i = 1
	EndIf	

;~ 	directory list and files delete
	While $i <= $array_end
		
		$line = StringSplit($array[$i], ";;;;;", 1)
		If IsArray($line) And $line[0] == 2 Then
			If $line[2] == 0 Then
					
				$j = 1
				$k = 0
				Local $FileInfo = _FtpFileFindFirst($l_FTPSession, $line[1] & "*", $Handle, $DllRect)
				If @error Then Return False
					
				If $FileInfo[0] Then
					Do
							
;~ 			 		   	If current is directory then insert directory in array
						If $FileInfo[1] == 16 And $FileInfo[10] <> "." And $FileInfo[10] <> ".." Then ; dir attrib = 16
;~ 							ConsoleWrite("dir find : " & $line[1] & $FileInfo[10] & "/" & @CRLF)
							ReDim $array[UBound($array)]
							$array_end = UBound($array)
							_ArrayInsert($array, $i + $j, $line[1] & $FileInfo[10] & "/" & ";;;;;" & "0")
							$j += 1
							$k += 1
						EndIf
							
;~ 						If current is file then delete the file
						If $FileInfo[1] == 128 Then ; file attrib = 128
;~ 							ConsoleWrite("delete file : " & $line[1] & $FileInfo[10] & @CRLF)
							_FTPDelFile($l_FTPSession, $line[1] & $FileInfo[10])
							If @error Then Return False
							$k += 1

						EndIf							
					
						$FileInfo = _FtpFileFindNext($Handle, $DllRect)
						   
					Until Not $FileInfo[0]

				EndIf
				_FtpFileFindClose($Handle, $DllRect)

				If $array[$i] == $s_Remote & ";;;;;" & "0" And $k == 0 Then
					$array_end -= 1				
				EndIf

				$array[$i] = $line[1] & ";;;;;" & "1"
				$i = 0	
				
			EndIf
			
		EndIf

		$i += 1
		
	WEnd	

;~ 	delete all directory
	For $i = UBound($array) - 1 To 1 Step -1
		$line = StringSplit($array[$i], ";;;;;", 1)
		If IsArray($line) And $line[0] == 2 Then
;~ 			ConsoleWrite("delete dir : " & $line[1] & @CRLF)
			_FTPDelDir($l_FTPSession, $line[1])
			If @error Then Return False

		EndIf
	Next

	Return True

EndFunc ;==> _FTP_Delete_Recursive

