#include<array.au3>
#include <Date.au3>
#include <StructureConstants.au3>
Global $GLOBAL_FTP_WININETHANDLE = -1
Global Const $INTERNET_OPEN_TYPE_DIRECT = 1
Global Const $INTERNET_OPEN_TYPE_PRECONFIG = 0
Global Const $INTERNET_OPEN_TYPE_PRECONFIG_WITH_NO_AUTOPROXY = 4
Global Const $INTERNET_OPEN_TYPE_PROXY = 3

Global Const $GENERIC_READ = 0x80000000
Global Const $GENERIC_WRITE = 0x40000000
Global Const $FTP_TRANSFER_TYPE_UNKNOWN = 0 ;Defaults to FTP_TRANSFER_TYPE_BINARY.
Global Const $FTP_TRANSFER_TYPE_ASCII = 1 ;Transfers the file using FTP's ASCII (Type A) transfer method. Control and formatting information is converted to local equivalents.
Global Const $FTP_TRANSFER_TYPE_BINARY = 2 ;Transfers the file using FTP's Image (Type I) transfer method. The file is transferred exactly as it exists with no changes. This is the default transfer method.

Global Const $INTERNET_FLAG_PASSIVE = 0x08000000
Global Const $INTERNET_FLAG_TRANSFER_ASCII = 0x00000001
Global Const $INTERNET_FLAG_TRANSFER_BINARY = 0x00000002
Global Const $INTERNET_DEFAULT_FTP_PORT = 21
Global Const $INTERNET_SERVICE_FTP = 1

Global Const $tagWIN32_FIND_DATA = "DWORD dwFileAttributes; dword ftCreationTime[2]; dword ftLastAccessTime[2]; dword ftLastWriteTime[2]; DWORD nFileSizeHigh; DWORD nFileSizeLow; dword dwReserved0; dword dwReserved1; CHAR cFileName[260]; CHAR cAlternateFileName[14];"

; Could be called at the End of Script
; Closes the wininet.dll used for FTP-Functions
Func _FTPUnInit()
	DllClose($GLOBAL_FTP_WININETHANDLE)
	$GLOBAL_FTP_WININETHANDLE = -1
EndFunc   ;==>_FTPUnInit

;===============================================================================
;
; Function Name:    _FTPOpen()
; Description:      Opens an FTP session.
; Parameter(s):     $s_Agent      	- Random name. ( like "myftp" )
;                   $l_AccessType 	- Set if proxy is used.
;                   $s_ProxyName  	- ProxyName.
;                   $s_ProxyBypass	- ProxyByPasses's.
;                   $l_Flags       	- Special flags.
; Requirement(s):   DllCall, wininet.dll
; Return Value(s):  On Success - Returns an indentifier.
;                   On Failure - 0  and sets @ERROR
; Remarks:          Values for $l_AccessType
;                        $INTERNET_OPEN_TYPE_DIRECT -> no proxy
;                        $INTERNET_OPEN_TYPE_PRECONFIG -> Retrieves the proxy
;                                    or direct configuration from the registry.
;                        $INTERNET_OPEN_TYPE_PRECONFIG_WITH_NO_AUTOPROXY
;                               -> Retrieves the proxy or direct configuration
;                                  from the registry and prevents the use of a
;                                  startup Microsoft JScript or Internet Setup (INS) file.
;                        $INTERNET_OPEN_TYPE_PROXY -> Passes requests to the
;                                  proxy unless a proxy bypass list is supplied
;                                  and the name to be resolved bypasses the proxy.
;                                  Then no proxy is used.
; Author(s):        Wouter van Kesteren.
;
;===============================================================================

Func _FTPOpen($s_Agent, $l_AccessType = 1, $s_ProxyName = '', $s_ProxyBypass = '', $l_Flags = 0)
	If $GLOBAL_FTP_WININETHANDLE = -1 Then ___FTPInit()
	Local $ai_InternetOpen = DllCall($GLOBAL_FTP_WININETHANDLE, 'hwnd', 'InternetOpen', 'str', $s_Agent, 'long', $l_AccessType, 'str', $s_ProxyName, 'str', $s_ProxyBypass, 'long', $l_Flags)
	If @error Or $ai_InternetOpen[0] = 0 Then
		SetError(-1)
		Return 0
	EndIf

	Return SetError(0,0,$ai_InternetOpen[0])

EndFunc   ;==>_FTPOpen

;===============================================================================
;
; Function Name:    _FTPConnect()
; Description:      Connects to an FTP server.
; Parameter(s):     $l_InternetSession	- The Long from _FTPOpen()
;                   $s_ServerName 		- Server name/ip.
;                   $s_Username  		- Username.
;                   $s_Password			- Password.
;                   $i_Passive			- Passive mode?.
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

Func _FTPConnect($l_InternetSession, $s_ServerName, $s_Username, $s_Password, $i_Passive = 0, $i_ServerPort = 0, $l_Service = 1, $l_Flags = 0, $l_Context = 0)

	If $i_Passive == True Then $l_Flags = BitOR($l_Flags, 0x08000000)
	Local $ai_InternetConnect = DllCall($GLOBAL_FTP_WININETHANDLE, 'hwnd', 'InternetConnect', 'hwnd', $l_InternetSession, 'str', $s_ServerName, 'int', $i_ServerPort, 'str', $s_Username, 'str', $s_Password, 'long', $l_Service, 'long', $l_Flags, 'long', $l_Context)

	If @error Or $ai_InternetConnect[0] = 0 Then
		SetError(-1 - @error)
		Return 0
	EndIf

	Return $ai_InternetConnect[0]

EndFunc   ;==>_FTPConnect

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

	Local $ai_FTPPutFile = DllCall($GLOBAL_FTP_WININETHANDLE, 'int', 'FtpPutFile', 'hwnd', $l_FTPSession, 'str', $s_LocalFile, 'str', $s_RemoteFile, 'long', $l_Flags, 'long', $l_Context)
	If @error Or $ai_FTPPutFile[0] = 0 Then
		SetError(-1)
		Return 0
	EndIf

	Return $ai_FTPPutFile[0]

EndFunc   ;==>_FTPPutFile

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

	Local $ai_FTPPutFile = DllCall($GLOBAL_FTP_WININETHANDLE, 'int', 'FtpDeleteFile', 'hwnd', $l_FTPSession, 'str', $s_RemoteFile)
	If @error Or $ai_FTPPutFile[0] = 0 Then
		SetError(-1)
		Return 0
	EndIf

	Return $ai_FTPPutFile[0]

EndFunc   ;==>_FTPDelFile

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

	Local $ai_FTPRenameFile = DllCall($GLOBAL_FTP_WININETHANDLE, 'int', 'FtpRenameFile', 'hwnd', $l_FTPSession, 'str', $s_Existing, 'str', $s_New)
	If @error Or $ai_FTPRenameFile[0] = 0 Then
		SetError(-1)
		Return 0
	EndIf

	Return $ai_FTPRenameFile[0]

EndFunc   ;==>_FTPRenameFile

;===============================================================================
;
; Function Name:    _FTPMakeDir()
; Description:      Makes an Directory on an FTP server.
; Parameter(s):     $l_FTPSession	- The Long from _FTPConnect()
;                   $s_Remote 		- The Directory to Create.
; Requirement(s):   DllCall, wininet.dll
; Return Value(s):  On Success - 1
;                   On Failure - 0
; Author(s):        Wouter van Kesteren
;
;===============================================================================

Func _FTPMakeDir($l_FTPSession, $s_Remote)

	Local $ai_FTPMakeDir = DllCall($GLOBAL_FTP_WININETHANDLE, 'int', 'FtpCreateDirectory', 'hwnd', $l_FTPSession, 'str', $s_Remote)
	If @error Or $ai_FTPMakeDir[0] = 0 Then
		SetError(-1)
		Return 0
	EndIf

	Return $ai_FTPMakeDir[0]

EndFunc   ;==>_FTPMakeDir

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

	Local $ai_FTPDelDir = DllCall($GLOBAL_FTP_WININETHANDLE, 'int', 'FtpRemoveDirectory', 'hwnd', $l_FTPSession, 'str', $s_Remote)
	If @error Or $ai_FTPDelDir[0] = 0 Then
		SetError(-1)
		Return 0
	EndIf

	Return $ai_FTPDelDir[0]

EndFunc   ;==>_FTPDelDir

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

	Local $ai_InternetCloseHandle = DllCall($GLOBAL_FTP_WININETHANDLE, 'int', 'InternetCloseHandle', 'hwnd', $l_InternetSession)
	If @error Or $ai_InternetCloseHandle[0] = 0 Then
		SetError(-1)
		Return 0
	EndIf

	Return $ai_InternetCloseHandle[0]

EndFunc   ;==>_FTPClose

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

	Local $ai_FTPGetCurrentDir = DllCall($GLOBAL_FTP_WININETHANDLE, 'int', 'FtpGetCurrentDirectory', 'hwnd', $l_FTPSession, 'str', "", 'long*', 260)
	If @error Or $ai_FTPGetCurrentDir[0] = 0 Then
		SetError(-1)
		Return 0
	EndIf

	Return $ai_FTPGetCurrentDir[2]


EndFunc   ;==>_FTPGetCurrentDir

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

	Local $ai_FTPSetCurrentDir = DllCall($GLOBAL_FTP_WININETHANDLE, 'int', 'FtpSetCurrentDirectory', 'hwnd', $l_FTPSession, 'str', $s_Remote)
	If @error Or $ai_FTPSetCurrentDir[0] = 0 Then
		SetError(-1)
		Return 0
	EndIf

	Return $ai_FTPSetCurrentDir[0]


EndFunc   ;==>_FtpSetCurrentDir



;===============================================================================
;
; Function Name:    _FTPGetFile()
; Description:      Get file from a FTP server.
; Parameter(s):     $l_FTPSession    - The Long from _FTPConnect()
;                   $s_RemoteFile      - The remote Location for the file.
;                   $s_LocalFile     - The local file.
;                   $fFailIfExists   - True: do not overwrite existing (default = False)
;                   $dwFlagsAndAttributes - special flags
;                   $l_Flags        - Special flags.
;                   $l_Context      - I dont got a clue what this does.
; Requirement(s):   DllCall, wininet.dll
; Return Value(s):  On Success - 1
;                   On Failure - 0
; Author(s):        Wouter van Kesteren
;
;===============================================================================

Func _FTPGetFile($l_FTPSession, $s_RemoteFile, $s_LocalFile, $fFailIfExists = False, $dwFlagsAndAttributes = 0, $l_Flags = 0, $l_Context = 0)

	Local $ai_FTPGetFile = DllCall($GLOBAL_FTP_WININETHANDLE, 'int', 'FtpGetFile', 'hwnd', $l_FTPSession, 'str', $s_RemoteFile, 'str', $s_LocalFile, "int", $fFailIfExists, "DWORD", $dwFlagsAndAttributes, 'dword', $l_Flags, 'dword', $l_Context)
	If @error Or $ai_FTPGetFile[0] = 0 Then
		SetError(-1)
		Return 0
	EndIf

	Return $ai_FTPGetFile[0]

EndFunc   ;==>_FTPGetFile


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

	Local $ai_FTPGetSizeHandle = DllCall($GLOBAL_FTP_WININETHANDLE, 'hwnd', 'FtpOpenFile', 'hwnd', $l_FTPSession, 'str', $s_FileName, 'long', 0x80000000, 'long', 0x04000002, 'long', 0)
	Local $ai_FTPGetFileSize = DllCall($GLOBAL_FTP_WININETHANDLE, 'dword', 'FtpGetFileSize', 'long', $ai_FTPGetSizeHandle[0], 'dword*', 0)
	If @error Or $ai_FTPGetFileSize[0] = 0 Then
		SetError(-1)
		Return 0
	EndIf
	DllCall($GLOBAL_FTP_WININETHANDLE, 'int', 'InternetCloseHandle', 'hwnd', $ai_FTPGetSizeHandle[0])

;~ 	Return $ai_FTPGetFileSize[0]
	Return BitOR(BitShift($ai_FTPGetFileSize[2], -32), BitAND($ai_FTPGetFileSize[0], 0xFFFFFFFF))

EndFunc   ;==>_FTPGetFileSize


;===============================================================================
;
; Function Name:    _FtpFileListto2DArray()
; Description:      Get Filenames and filesizes of current Directory.
; Parameter(s):
; Requirement(s):   DllCall, wininet.dll
; Return Value(s):  On Success - 2D Array with Files
;                   On Failure - 0
; Author(s):        Prog@ndy
;
;===============================================================================
Func _FTPFilesListTo2DArray($l_FTPSession, $Return_Type = 0, $l_Flags = 0, $l_Context = 0)
	Local $WIN32_FIND_DATA
	Local $FileArray[1][2], $DirectoryArray[1][2], $DirectoryIndex = 0, $FileIndex = 0
	If $Return_Type < 0 Or $Return_Type > 2 Then Return SetError(1, 0, $FileArray)


	Local $callFindFirst, $File
	$File = _FTPFileFindFirst($l_FTPSession, "", $callFindFirst, $WIN32_FIND_DATA, $l_Flags, $l_Context)
	If Not $callFindFirst Then
		Return SetError(1, 0, 0)
	EndIf
	Local $IsDir
	While 1
;~ 		ConsoleWrite($File[10] & @CRLF)
;~ 		ConsoleWrite($File[11] & @CRLF)
		$IsDir = BitAND($File[1], 16) = 16
		Select
		Case $IsDir And ($Return_Type <> 2)
			$DirectoryIndex += 1
			ReDim $DirectoryArray[$DirectoryIndex + 1][2]
			$DirectoryArray[$DirectoryIndex][0] = $File[10]
			$DirectoryArray[$DirectoryIndex][1] = BitOR(BitShift($File[8], -32), BitAND($File[9], 0xFFFFFFFF))
		Case Not $IsDir And $Return_Type <> 1
			$FileIndex += 1
			ReDim $FileArray[$FileIndex + 1][2]
			$FileArray[$FileIndex][0] = $File[10]
			$FileArray[$FileIndex][1] = BitOR(BitShift($File[8], -32), BitAND($File[9], 0xFFFFFFFF))
		EndSelect

		$File = _FTPFileFindNext($callFindFirst, $WIN32_FIND_DATA)
		If @error <> 0 Then ExitLoop
	WEnd
	_FTPFileFindClose($callFindFirst, $WIN32_FIND_DATA)
	$DirectoryArray[0][0] = $DirectoryIndex
	$FileArray[0][0] = $FileIndex

	Switch $Return_Type
		Case 0
			If $DirectoryArray[0][0] = 0 Then Return $FileArray
			ReDim $DirectoryArray[$DirectoryArray[0][0] + $FileArray[0][0] + 1][2]
			For $i = 1 To $FileIndex
				$DirectoryArray[$DirectoryArray[0][0] + $i][0] = $FileArray[$i][0]
				$DirectoryArray[$DirectoryArray[0][0] + $i][1] = $FileArray[$i][1]
			Next
			$DirectoryArray[0][0] += $FileArray[0][0]
			Return $DirectoryArray
		Case 1
			Return $DirectoryArray
		Case 2
			Return $FileArray
	EndSwitch
EndFunc   ;==>_FTPFilesListTo2DArray


;===============================================================================
;
; Function Name:    _FtpFileListtoArray()
; Description:      Get Filenames, Directorys,  or Both of a Directory.
; Parameter(s):     $l_FTPSession  - Long From _FileConnect
;					$Return_type          - 0 = Both Files and Directorys, 1 = Directorys, 2 = Files
; Requirement(s):   DllCall, wininet.dll
; Return Value(s):  On Success - 1
;                   On Failure - 0
; Author(s):        Beast, Prog@ndy
;
;===============================================================================


Func _FTPFilesListToArray($l_FTPSession, $Return_Type = 0, $l_Flags = 0, $l_Context = 0)
	Local $WIN32_FIND_DATA, $FileTime
	Local $FileArray[1], $DirectoryArray[1], $DirectoryIndex = 0, $FileIndex = 0
	If $Return_Type < 0 Or $Return_Type > 2 Then Return SetError(1, 0, $FileArray)

;~ 	$tagWIN32_FIND_DATA = "DWORD dwFileAttributes; uint64 ftCreationTime; uint64 ftLastAccessTime; uint64 ftLastWriteTime; DWORD nFileSizeHigh; DWORD nFileSizeLow; short dwReserved0; short dwReserved1; CHAR cFileName[260]; CHAR cAlternateFileName[14];"

	$WIN32_FIND_DATA = DllStructCreate($tagWIN32_FIND_DATA)
	Local $callFindFirst = DllCall($GLOBAL_FTP_WININETHANDLE, 'hwnd', 'FtpFindFirstFile', 'hwnd', $l_FTPSession, 'str', "", 'ptr', DllStructGetPtr($WIN32_FIND_DATA), 'long', $l_Flags, 'long', $l_Context)
	If Not $callFindFirst[0] Then
		Return SetError(1, 0, 0)
	EndIf
	Local $IsDir
	While 1
		$IsDir = BitAND(DllStructGetData($WIN32_FIND_DATA, 1), 16) = 16
		Select
		Case $IsDir And ($Return_Type <> 2)
			$DirectoryIndex += 1
			ReDim $DirectoryArray[$DirectoryIndex + 1]
			$DirectoryArray[$DirectoryIndex] = DllStructGetData($WIN32_FIND_DATA, 9)
		Case Not $IsDir And $Return_Type <> 1
			$FileIndex += 1
			ReDim $FileArray[$FileIndex + 1]
			$FileArray[$FileIndex] = DllStructGetData($WIN32_FIND_DATA, 9)
		EndSelect

		Local $callFindNext = DllCall($GLOBAL_FTP_WININETHANDLE, 'int', 'InternetFindNextFile', 'hwnd', $callFindFirst[0], 'ptr', DllStructGetPtr($WIN32_FIND_DATA))
		If Not $callFindNext[0] Then
			ExitLoop
		EndIf
	WEnd
	DllCall($GLOBAL_FTP_WININETHANDLE, "int", "InternetCloseHandle", "hwnd", $callFindFirst[0])
	$DirectoryArray[0] = $DirectoryIndex
	$FileArray[0] = $FileIndex

	Switch $Return_Type
		Case 0
			ReDim $DirectoryArray[$DirectoryArray[0] + $FileArray[0] + 1]
			For $i = 1 To $FileIndex
				$DirectoryArray[$DirectoryArray[0] + $i] = $FileArray[$i]
			Next
			$DirectoryArray[0] += $FileArray[0]
			Return $DirectoryArray
		Case 1
			Return $DirectoryArray
		Case 2
			Return $FileArray
	EndSwitch
EndFunc   ;==>_FTPFilesListToArray

;===============================================================================
;
; Function Name:    _FtpFileListtoArrayEx()
; Description:      Get Filenames, Directorys,  or Both of a Directory.
; Parameter(s):     $l_FTPSession  - Long From _FileConnect
;					$Return_type          - 0 = Both Files and Directorys, 1 = Directorys, 2 = Files
; Requirement(s):   DllCall, wininet.dll
; Return Value(s):  On Success - 1
;                   On Failure - 0
; Author(s):        Beast, Prog@ndy
;
;===============================================================================


Func _FTPFilesListToArrayEx($l_FTPSession, $Return_Type = 0, $l_Flags = 0, $l_Context = 0)
	Local $WIN32_FIND_DATA, $ret, $FileTime, $IsDir
	Local $ArrayCount = 10
	Local $FileArray[1][$ArrayCount], $DirectoryArray[1][$ArrayCount], $DirectoryIndex = 0, $FileIndex = 0
	If $Return_Type < 0 Or $Return_Type > 2 Then Return SetError(1, 0, $FileArray)
;~ 	$array = _ArrayCreate($array)
;~ 	$array2d = _ArrayCreate($array2d)
;~ 	$str = "dword;int64;int64;int64;dword;dword;dword;dword;char[256];char[14]"
;~ 	$tagWIN32_FIND_DATA = "DWORD dwFileAttributes; uint64 ftCreationTime; uint64 ftLastAccessTime; uint64 ftLastWriteTime; DWORD nFileSizeHigh; DWORD nFileSizeLow; short dwReserved0; short dwReserved1; CHAR cFileName[260]; CHAR cAlternateFileName[14];"

	$WIN32_FIND_DATA = DllStructCreate($tagWIN32_FIND_DATA)
	Local $callFindFirst = DllCall($GLOBAL_FTP_WININETHANDLE, 'hwnd', 'FtpFindFirstFile', 'hwnd', $l_FTPSession, 'str', "", 'ptr', DllStructGetPtr($WIN32_FIND_DATA), 'long', $l_Flags, 'long', $l_Context)
	If Not $callFindFirst[0] Then
		Return SetError(1, 0, 0)
	EndIf
	$ret = ""
	While 1
		$IsDir = BitAND(DllStructGetData($WIN32_FIND_DATA, 1), 16) = 16
		If $IsDir And ($Return_Type <> 2) Then
			$DirectoryIndex += 1
			ReDim $DirectoryArray[$DirectoryIndex + 1][$ArrayCount]
			$DirectoryArray[$DirectoryIndex][0] = DllStructGetData($WIN32_FIND_DATA, 9)
			$FileTime = DllStructCreate("dword;dword", DllStructGetPtr($WIN32_FIND_DATA, 2))
			If (DllStructGetData($FileTime, 1) + DllStructGetData($FileTime, 2)) Then $DirectoryArray[$DirectoryIndex][1] = _Date_Time_FileTimeToStr($FileTime)
			$FileTime = DllStructCreate("dword;dword", DllStructGetPtr($WIN32_FIND_DATA, 3))
			If (DllStructGetData($FileTime, 1) + DllStructGetData($FileTime, 2)) Then $DirectoryArray[$DirectoryIndex][2] = _Date_Time_FileTimeToStr($FileTime)
			$FileTime = DllStructCreate("dword;dword", DllStructGetPtr($WIN32_FIND_DATA, 4))
			If (DllStructGetData($FileTime, 1) + DllStructGetData($FileTime, 2)) Then $DirectoryArray[$DirectoryIndex][3] = _Date_Time_FileTimeToStr($FileTime)
			If DllStructGetData($WIN32_FIND_DATA, 1) <> 128 Then
				$DirectoryArray[$DirectoryIndex][4] = __FileListToArrayEx_HasAttribute($WIN32_FIND_DATA, 2) ; Hidden
				$DirectoryArray[$DirectoryIndex][5] = __FileListToArrayEx_HasAttribute($WIN32_FIND_DATA, 1) ; Readonly
			EndIf
		ElseIf Not $IsDir And $Return_Type <> 1 Then
			$FileIndex += 1
			ReDim $FileArray[$FileIndex + 1][$ArrayCount]
			$FileArray[$FileIndex][0] = DllStructGetData($WIN32_FIND_DATA, 9)
			$FileTime = DllStructCreate("dword;dword", DllStructGetPtr($WIN32_FIND_DATA, 2))
			If (DllStructGetData($FileTime, 1) + DllStructGetData($FileTime, 2)) Then $FileArray[$FileIndex][1] = _Date_Time_FileTimeToStr($FileTime)
			$FileTime = DllStructCreate("dword;dword", DllStructGetPtr($WIN32_FIND_DATA, 3))
			If (DllStructGetData($FileTime, 1) + DllStructGetData($FileTime, 2)) Then $FileArray[$FileIndex][2] = _Date_Time_FileTimeToStr($FileTime)
			$FileTime = DllStructCreate("dword;dword", DllStructGetPtr($WIN32_FIND_DATA, 4))
			If (DllStructGetData($FileTime, 1) + DllStructGetData($FileTime, 2)) Then $FileArray[$FileIndex][3] = _Date_Time_FileTimeToStr($FileTime)
			If DllStructGetData($WIN32_FIND_DATA, 1) <> 128 Then
				$FileArray[$FileIndex][4] = __FileListToArrayEx_HasAttribute($WIN32_FIND_DATA, 2) ; Hidden
				$FileArray[$FileIndex][5] = __FileListToArrayEx_HasAttribute($WIN32_FIND_DATA, 1) ; Readonly
			EndIf
		EndIf
		Local $callFindNext = DllCall($GLOBAL_FTP_WININETHANDLE, 'int', 'InternetFindNextFile', 'hwnd', $callFindFirst[0], 'ptr', DllStructGetPtr($WIN32_FIND_DATA))
		If Not $callFindNext[0] Then
			ExitLoop
		EndIf
	WEnd
	DllCall($GLOBAL_FTP_WININETHANDLE, "int", "InternetCloseHandle", "hwnd", $callFindFirst[0])
	$DirectoryArray[0][0] = $DirectoryIndex
	$FileArray[0][0] = $FileIndex
;~ 	ConsoleWrite($DirectoryIndex & @CRLF)
;~ 	ConsoleWrite($FileIndex & @CRLF)
	Switch $Return_Type
		Case 0
			ReDim $DirectoryArray[$DirectoryArray[0][0] + $FileArray[0][0] + 1][$ArrayCount]
			For $i = 1 To $FileIndex
				$DirectoryArray[$DirectoryArray[0][0] + $i][0] = $FileArray[$i][0]
				$DirectoryArray[$DirectoryArray[0][0] + $i][1] = $FileArray[$i][1]
				$DirectoryArray[$DirectoryArray[0][0] + $i][2] = $FileArray[$i][2]
				$DirectoryArray[$DirectoryArray[0][0] + $i][3] = $FileArray[$i][3]
				$DirectoryArray[$DirectoryArray[0][0] + $i][4] = $FileArray[$i][4]
				$DirectoryArray[$DirectoryArray[0][0] + $i][5] = $FileArray[$i][5]
			Next
			$DirectoryArray[0][0] += $FileArray[0][0]
			Return $DirectoryArray
		Case 1
			Return $DirectoryArray
		Case 2
			Return $FileArray
	EndSwitch
EndFunc   ;==>_FTPFilesListToArrayEx

Func __FileListToArrayEx_HasAttribute(ByRef $WIN32_FIND_DATA, $attib)
	Return (BitAND(DllStructGetData($WIN32_FIND_DATA, 1), $attib) = $attib)
EndFunc   ;==>__FileListToArrayEx_HasAttribute

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
;                -> Parameter removed, is returned as @extended
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

Func _FTPCommand($l_FTPSession, $s_FTPCommand, $l_Flags = 0x00000001, $l_ExpectResponse = 0, $l_Context = 0)

	Local $ai_FTPCommand = DllCall($GLOBAL_FTP_WININETHANDLE, 'int', 'FtpCommand', 'hwnd', $l_FTPSession, 'long', $l_ExpectResponse, 'long', $l_Flags, 'str', $s_FTPCommand, 'ulong', $l_Context, 'dword*', 0)
	If @error Or $ai_FTPCommand[0] = 0 Then
		SetError(-1)
		Return 0
	EndIf
	;Return $s_return
	SetExtended($ai_FTPCommand[6])
	Return $ai_FTPCommand[0]

EndFunc   ;==>_FTPCommand

;======================================================================================================
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
;======================================================================================================

Func _FTPPutFolderContents($l_InternetSession, $s_LocalFolder, $s_RemoteFolder, $b_RecursivePut)

	If StringRight($s_LocalFolder,1) == "\" Then $s_LocalFolder = StringTrimRight($s_LocalFolder,1)
	; Shows the filenames of all files in the current directory.
	$search = FileFindFirstFile($s_LocalFolder & "\*.*")

	; Check if the search was successful
	If $search = -1 Then
		Return SetError(1, 0, 0)
;~ 		MsgBox(0, "Error", "No files/directories matched the search pattern")
;~ 		Exit
	EndIf

	While 1
		$File = FileFindNextFile($search)
		If @error Then ExitLoop
		If StringInStr(FileGetAttrib($s_LocalFolder & "\" & $File), "D") Then
			_FTPMakeDir($l_InternetSession, $s_RemoteFolder & "/" & $File)
			If $b_RecursivePut Then
				_FTPPutFolderContents($l_InternetSession, $s_LocalFolder & "\" & $File, $s_RemoteFolder & "/" & $File, $b_RecursivePut)
			EndIf
		Else
			_FTPPutFile($l_InternetSession, $s_LocalFolder & "\" & $File, $s_RemoteFolder & "/" & $File, 0, 0)
		EndIf
	WEnd

	; Close the search handle
	FileClose($search)
	Return 1
EndFunc   ;==>_FTPPutFolderContents

#Region Internal
;Internal Func, DO NOT USE YOURSELF
Func ___FTPInit()
	$GLOBAL_FTP_WININETHANDLE = DllOpen('wininet.dll')
EndFunc   ;==>___FTPInit
#EndRegion Internal
;===============================================================================
;
; Function Name:   _FTP_UploadProgress()
; Description::    Uploadsd a file in Binary Mode and shows Progress in Tooltip or by Calling a User defined Function
; Parameter(s):     $l_FTPSession	- The Long from _FTPConnect()
;                   $s_LocalFile 	- The local file.
;                   $s_RemoteFile  	- The remote Location for the file.
;                   $FunctionToCall - [Optional] A function which can update a Progressbar and
;                                       react on UserInput like Click on Abort or Close App.
;                                       (More info in the end of this comment)
; Requirement(s):  ??
; Return Value(s): Success: 1
;                  Error: 0 and @error:
;                           -3 -> Create File failed
;                           -4 -> Write to file failed
;                           -5 -> Close File failed
;                  Upload aborted by PercentageFunc:
;                   ReturnValue: Return of Called Function
;                           And @error -6
; Author(s):       limette, Prog@ndy
;
; Information about $FunctionToCall:
;   Parameter: $Percentage - The Percentage of Progress
;   Return Values: Continue Download - 1
;                  Abort Download    - 0 Or negative
;                       These Return Values are returned by _FTP_UploadProgress, too,
;                       so you can react on different Actions like Aborting by User, closing App or TimeOut of whatever
;   Examples:
;~                   Func _UpdateProgress($Percentage)
;~                      ProgressSet($percent,$percent &"%")
;~                      If _IsPressed("77") Then Return 0 ; Abort on F8
;~                      Return 1 ; bei 1 Fortsetzten
;~                   Endfunc
;
;~                   Func _UpdateProgress($Percentage)
;~                      GUICtrlSetData($ProgressBarCtrl,$percent)
;~                      Switch GUIGetMsg()
;~                         Case $GUI_EVENT_CLOSE
;~                            Return -1 ; _FTP_UploadProgress Aborts with -1, so you can exit you app afterwards
;~                        Case $Btn_Cancel
;~                           Return 0 ; Just Cancel, without special Return value
;~                      EndSwitch
;~                      Return 1 ; Otherwise contine Upload
;~                   Endfunc
;
;===============================================================================
;
Func _FTP_UploadProgress($l_FTPSession, $s_LocalFile, $s_RemoteFile, $FunctionToCall = "")
	#Region Declaration
	Local $ai_ftpopenfile, $ai_InternetCloseHandle, $fhandle, $glen, $last, $x, $parts, $buffer, $ai_ftpwrite, $result, $out, $i
	#EndRegion Declaration
	#Region OpenFile
	Local $ai_ftpopenfile = DllCall($GLOBAL_FTP_WININETHANDLE, 'ptr', 'FtpOpenFile', 'hwnd', $l_FTPSession, 'str', $s_RemoteFile, 'dword', 0x40000000, 'dword', 0x02, 'dword', 0)
	If @error Or $ai_ftpopenfile[0] = 0 Then
		SetError(-3)
		Return 0
	EndIf
	#EndRegion OpenFile
	If $FunctionToCall = "" Then ProgressOn("FTP Upload", "Uploading " & $s_LocalFile)
	#Region DataSend
	Local $fhandle = FileOpen($s_LocalFile, 16)

	$glen = FileGetSize($s_LocalFile)
	$last = Mod($glen, 100)

	$x = ($glen - $last) / 100
;~ If $x = 0 Then $x = 1
	If $x = 0 Then
		$x = $last
		$parts = 1
	ElseIf $last > 0 Then
		$parts = 101
	Else
		$parts = 100
	EndIf
	If $x < $last Then
		$buffer = DllStructCreate("byte[" & $last & "]")
	Else
		$buffer = DllStructCreate("byte[" & $x & "]")
	EndIf

;~ 	Dim $out, $i = 0, $result
	For $i = 1 To $parts
		Select
			Case $i = 101 And $last > 0
				$x = $last
		EndSelect
		DllStructSetData($buffer, 1, FileRead($fhandle, $x))

		Local $ai_ftpwrite = DllCall($GLOBAL_FTP_WININETHANDLE, 'int', 'InternetWriteFile', 'ptr', $ai_ftpopenfile[0], 'ptr', DllStructGetPtr($buffer), 'int', $x, 'dword*', $out)
		If @error Or $ai_ftpwrite[0] = 0 Then
			$ai_InternetCloseHandle = DllCall($GLOBAL_FTP_WININETHANDLE, 'int', 'InternetCloseHandle', 'ptr', $ai_ftpopenfile[0])
			FileClose($fhandle)

			SetError(-4)
			Return 0
		EndIf

		Switch $FunctionToCall
			Case ""
				ProgressSet($i)
			Case Else
				Select
					Case $parts = 1
						$result = 100
					Case $i = 101
						$result = 100
					Case Else
						$result = $i
				EndSelect
				$ret = Call($FunctionToCall, $result)
				Select
					Case $ret <= 0
						$ai_InternetCloseHandle = DllCall($GLOBAL_FTP_WININETHANDLE, 'int', 'InternetCloseHandle', 'ptr', $ai_ftpopenfile[0])
						DllCall($GLOBAL_FTP_WININETHANDLE, 'int', 'FtpDeleteFile', 'hwnd', $l_FTPSession, 'str', $s_RemoteFile)
						FileClose($fhandle)
						SetError(-6)
						Return $ret
				EndSelect
		EndSwitch
		Sleep(10)

	Next

	FileClose($fhandle)
	#EndRegion DataSend
	If $FunctionToCall = "" Then ProgressOff()
	#Region disconnect
	$ai_InternetCloseHandle = DllCall($GLOBAL_FTP_WININETHANDLE, 'int', 'InternetCloseHandle', 'ptr', $ai_ftpopenfile[0])
	If @error Or $ai_InternetCloseHandle[0] = 0 Then
		SetError(-5)
		Return 0
	EndIf
	#EndRegion disconnect

	Return 1
EndFunc   ;==>_FTP_UploadProgress


;===============================================================================
;
; Function Name:   _FTP_DownloadProgress()
; Description::    Downloads a file in Binary Mode and shows Progress in Tooltip or by Calling a User defined Function
; Parameter(s):     $l_FTPSession	- The Long from _FTPConnect()
;                   $s_LocalFile 	- The local file to create.
;                   $s_RemoteFile  	- The remote source file.
;                   $FunctionToCall - [Optional] A function which can update a Progressbar and
;                                       react on UserInput like Click on Abort or Close App.
;                                       (More info in the end of this comment)
; Requirement(s):  ??
; Return Value(s): Success: 1
;                  Error: 0 and @error:
;                           -1 -> Local file couldn't be created
;                           -3 -> Open RemoteFile failed
;                           -4 -> Read from Remotefile failed
;                           -5 -> Close RemoteFile failed
;                  Download aborted by PercentageFunc:
;                    ReturnValue: Return of Called Function
;                           And @error -6
; Author(s):       limette, Prog@ndy
;
; Information about $FunctionToCall:
;   Parameter: $Percentage - The Percentage of Progress
;   Return Values: Continue Download - 1
;                  Abort Download    - 0 Or negative
;                       These Return Values are returned by _FTP_DownloadProgress, too,
;                       so you can react on different Actions like Aborting by User, closing App or TimeOut of whatever
;   Examples:
;~                   Func _UpdateProgress($Percentage)
;~                      ProgressSet($percent,$percent &"%")
;~                      If _IsPressed("77") Then Return 0 ; Abort on F8
;~                      Return 1 ; bei 1 Fortsetzten
;~                   Endfunc
;
;~                   Func _UpdateProgress($Percentage)
;~                      GUICtrlSetData($ProgressBarCtrl,$percent)
;~                      Switch GUIGetMsg()
;~                         Case $GUI_EVENT_CLOSE
;~                            Return -1 ; _FTP_UploadProgress Aborts with -1, so you can exit you app afterwards
;~                        Case $Btn_Cancel
;~                           Return 0 ; Just Cancel, without special Return value
;~                      EndSwitch
;~                      Return 1 ; Otherwise contine Upload
;~                   Endfunc
;
;===============================================================================
;
Func _FTP_DownloadProgress($l_FTPSession, $s_LocalFile, $s_RemoteFile, $FunctionToCall = "")
	#Region Declaration
	Local $ai_ftpopenfile, $ai_InternetCloseHandle, $fhandle, $glen, $last, $x, $parts, $buffer, $ai_FTPread, $result, $out, $i
	#EndRegion Declaration
	#Region OpenFile
	Local $fhandle = FileOpen($s_LocalFile, 18)
	If @error Then
		SetError(-1)
		Return 0
	EndIf
	Local $ai_ftpopenfile = DllCall($GLOBAL_FTP_WININETHANDLE, 'ptr', 'FtpOpenFile', 'hwnd', $l_FTPSession, 'str', $s_RemoteFile, 'dword', 0x80000000, 'dword', 0x02, 'dword', 0)
	If @error Or $ai_ftpopenfile[0] = 0 Then
		SetError(-3)
		Return 0
	EndIf
	#EndRegion OpenFile
	If $FunctionToCall = "" Then ProgressOn("FTP Download", "Downloading " & $s_LocalFile)
	#Region DataSend
	Local $ai_FTPGetFileSize = DllCall($GLOBAL_FTP_WININETHANDLE, 'dword', 'FtpGetFileSize', 'ptr', $ai_ftpopenfile[0], 'dword*', 0)
	$glen = BitOR(BitShift($ai_FTPGetFileSize[2], -32), BitAND($ai_FTPGetFileSize[0], 0xFFFFFFFF)) ;FileGetSize($s_LocalFile)
	$last = Mod($glen, 100)
	$x = ($glen - $last) / 100
;~ If $x = 0 Then $x = 1
	If $x = 0 Then
		$x = $last
		$parts = 1
	ElseIf $last > 0 Then
		$parts = 101
	Else
		$parts = 100
	EndIf
	If $x < $last Then
		$buffer = DllStructCreate("byte[" & $last & "]")
	Else
		$buffer = DllStructCreate("byte[" & $x & "]")
	EndIf

;~ 	Dim $out, $i = 0, $result
	For $i = 1 To $parts
		Select
			Case $i = 101 And $last > 0
				$x = $last
		EndSelect

		Local $ai_FTPread = DllCall($GLOBAL_FTP_WININETHANDLE, 'int', 'InternetReadFile', 'ptr', $ai_ftpopenfile[0], 'ptr', DllStructGetPtr($buffer), 'int', $x, 'dword*', $out)
		If @error Or $ai_FTPread[0] = 0 Then
			$ai_InternetCloseHandle = DllCall($GLOBAL_FTP_WININETHANDLE, 'int', 'InternetCloseHandle', 'ptr', $ai_ftpopenfile[0])
			FileClose($fhandle)

			SetError(-4)
			Return 0
		EndIf
		FileWrite($fhandle, BinaryMid(DllStructGetData($buffer, 1), 1, $ai_FTPread[4]))
		Switch $FunctionToCall
			Case ""
				ProgressSet($i)
			Case Else
				Select
					Case $parts = 1
						$result = 100
					Case $i = 101
						$result = 100
					Case Else
						$result = $i
				EndSelect
				$ret = Call($FunctionToCall, $result)
				Select
					Case $ret <= 0
						$ai_InternetCloseHandle = DllCall($GLOBAL_FTP_WININETHANDLE, 'int', 'InternetCloseHandle', 'ptr', $ai_ftpopenfile[0])
;~ 						DllCall($GLOBAL_FTP_WININETHANDLE, 'int', 'FtpDeleteFile', 'hwnd', $l_FTPSession, 'str', $s_RemoteFile)
						FileClose($fhandle)
						FileDelete($s_LocalFile)
						SetError(-6)
						Return $ret
				EndSelect
		EndSwitch
		Sleep(10)

	Next

	FileClose($fhandle)
	#EndRegion DataSend
	If $FunctionToCall = "" Then ProgressOff()
	#Region disconnect
	$ai_InternetCloseHandle = DllCall($GLOBAL_FTP_WININETHANDLE, 'int', 'InternetCloseHandle', 'ptr', $ai_ftpopenfile[0])
	If @error Or $ai_InternetCloseHandle[0] = 0 Then
		SetError(-5)
		Return 0
	EndIf
	#EndRegion disconnect

	Return 1
EndFunc   ;==>_FTP_DownloadProgress

;===============================================================================
; Function Name:    _FTPOpenFile()
; Description:      Initiates access to a remote file on an FTP server for reading or writing. Use _FTPCloseFile()
;               to close the ftp file.
; Parameter(s):     $hConnect     - The long from _FTPConnect()
;               $lpszFileName  - String of the ftp file to open
;               $dwAccess    - GENERIC_READ or GENERIC_WRITE (Default is GENERIC_READ)
;               $dwFlags      - Settings for the transfer see notes below (Default is 2 for FTP_TRANSFER_TYPE_BINARY)
;               $dwContext  - (Not Used) See notes below
; Requirement(s):   DllCall, wininet.dll
; Return Value(s):  On Success - Returns the handle to ftp file for read/write with _FTPReadFile()
;                   On Failure - 0 and Sets @error = -1
;Notes:
;~ hConnect
;~   [in] Handle to an FTP session.
;~ lpszFileName
;~   [in] Pointer to a null-terminated string that contains the name of the file to be accessed.
;~ dwAccess
;~   [in] File access. This parameter can be GENERIC_READ or GENERIC_WRITE, but not both.
;~ dwFlags
;~   [in] Conditions under which the transfers occur. The application should select one transfer type and any of
;            the flags that indicate how the caching of the file will be controlled.
;~ The transfer type can be one of the following values.
;~   FTP_TRANSFER_TYPE_ASCII Transfers the file using FTP's ASCII (Type A) transfer method. Control and
;            formatting information is converted to local equivalents.
;~   FTP_TRANSFER_TYPE_BINARY Transfers the file using FTP's Image (Type I) transfer method. The file is
;            transferred exactly as it exists with no changes. This is the default transfer method.
;~   FTP_TRANSFER_TYPE_UNKNOWN Defaults to FTP_TRANSFER_TYPE_BINARY.
;~   INTERNET_FLAG_TRANSFER_ASCII Transfers the file as ASCII.
;~   INTERNET_FLAG_TRANSFER_BINARY Transfers the file as binary.
;~ The following values are used to control the caching of the file. The application can use one or more of these values.
;~   INTERNET_FLAG_HYPERLINK Forces a reload if there was no Expires time and no LastModified time returned from the server
;            when determining whether to reload the item from the network.
;~   INTERNET_FLAG_NEED_FILE Causes a temporary file to be created if the file cannot be cached.
;~   INTERNET_FLAG_RELOAD Forces a download of the requested file, object, or directory listing from the origin server,
;            not from the cache.
;~   INTERNET_FLAG_RESYNCHRONIZE Reloads HTTP resources if the resource has been modified since the last time it was
;            downloaded. All FTP and Gopher resources are reloaded.
;~ dwContext
;~   [in] Pointer to a variable that contains the application-defined value that associates this search with any
;            application data. This is only used if the application has already called InternetSetStatusCallback to set
;            up a status callback function.
; Function from http://www.autoitscript.com/forum/index.php?s=&showtopic=12473&view=findpost&p=331340
; modified by Prog@ndy
;===============================================================================
Func _FTPOpenFile($hConnect, $lpszFileName, $dwAccess = 0x80000000, $dwFlags = 2, $dwContext = 0)

	Local $ai_ftpopenfile = DllCall($GLOBAL_FTP_WININETHANDLE, 'hwnd', 'FtpOpenFile', _
			'hwnd', $hConnect, _            ;HINTERNET hConnect
			'str', $lpszFileName, _   ;LPCTSTR lpszFileName
			'udword', $dwAccess, _  ;DWORD dwAccess
			'dword', $dwFlags, _                        ;DWORD dwFlags
			'dword', $dwContext) ;DWORD_PTR dwContext

	If @error Or $ai_ftpopenfile[0] == 0 Then
		SetError(-1)
		Return 0
	EndIf

	Return $ai_ftpopenfile[0]

EndFunc   ;==>_FTPOpenFile

;===============================================================================
; Function Name:    _FTPReadFile()
; Description:      Reads data from a handle opened by _FTPOpenFile()
; Parameter(s):     $h_File                 - Handle returned by _FTPOpenFile to the ftp file
;               $dwNumberOfBytesToRead - Number of bytes to read
; Requirement(s):   DllCall, wininet.dll
; Return Value(s):  On Success - Returns the binary/string read.
;                   On Failure - 0 and Sets @error = -1 for end-of-file, @error = 1 for other errors
;Notes: (InternetReadFile() parameters)
;~ hFile
;~   [in] Handle returned from a previous call to InternetOpenUrl, FtpOpenFile, GopherOpenFile, or HttpOpenRequest.
;~ lpBuffer
;~   [out] Pointer to a buffer that receives the data.
;~ dwNumberOfBytesToRead
;~   [in] Number of bytes to be read.
;~ lpdwNumberOfBytesRead
;~   [out] Pointer to a variable that receives the number of bytes read. InternetReadFile sets this value to zero before doing any work or error checking.
; Function from http://www.autoitscript.com/forum/index.php?s=&showtopic=12473&view=findpost&p=331340
; modified by Prog@ndy
;===============================================================================
Func _FTPReadFile($h_File, $dwNumberOfBytesToRead)

	Local $s_FileRead = ""
	Local $lpBuffer = DllStructCreate("byte[" & $dwNumberOfBytesToRead & "]")

	Local $ai_FTPReadFile = DllCall($GLOBAL_FTP_WININETHANDLE, 'int', 'InternetReadFile', _
			'hwnd', $h_File, _                ;HINTERNET hFile
			'ptr', DllStructGetPtr($lpBuffer), _            ;LPVOID lpBuffer
			'dword', $dwNumberOfBytesToRead, _        ;DWORD dwNumberOfBytesToRead
			'dword*', 0) ;LPDWORD lpdwNumberOfBytesRead
	If @error Then
		$lpBuffer = 0
		$lpdwNumberOfBytesRead = 0
		Return SetError(1, 0, 0)
	EndIf
	Local $lpdwNumberOfBytesRead = $ai_FTPReadFile[4]
	If $lpdwNumberOfBytesRead == 0 And $ai_FTPReadFile[0] == 1 Then
		$lpBuffer = 0
		Return SetError(-1, 0, 0)
	ElseIf $ai_FTPReadFile[0] == 0 Then
		$lpBuffer = 0
		Return SetError(2, 0, 0)
	EndIf

	If $dwNumberOfBytesToRead > $lpdwNumberOfBytesRead Then
		$s_FileRead = BinaryMid(DllStructGetData($lpBuffer, 1), 1, $lpdwNumberOfBytesRead) ;index is omitted so the entire array is written into $s_FileRead as a BinaryString
	Else
		$s_FileRead = DllStructGetData($lpBuffer, 1) ;index is omitted so the entire array is written into $s_FileRead as a BinaryString
	EndIf

	$lpBuffer = 0
	$lpdwNumberOfBytesRead = 0
	SetExtended($lpdwNumberOfBytesRead)
	Return $s_FileRead

EndFunc   ;==>_FTPReadFile

;===============================================================================
; Function Name:    _FTPCloseFile()
; Description:      Closes the Handle returned by _FTPOpenFile.
; Parameter(s):     $l_InternetSession  - The handles from _FTPOpenFile.()
; Requirement(s):   DllCall, wininet.dll
; Return Value(s):  On Success - 1
;                   On Failure - 0 Sets @error = -1
; Function from http://www.autoitscript.com/forum/index.php?s=&showtopic=12473&view=findpost&p=331340
; modified by Prog@ndy
;===============================================================================
Func _FTPCloseFile($l_InternetSession)

	Local $ai_InternetCloseHandle = DllCall($GLOBAL_FTP_WININETHANDLE, 'int', 'InternetCloseHandle', 'hwnd', $l_InternetSession)


	If @error Or $ai_InternetCloseHandle[0] = 0 Then
		SetError(-1)
		Return 0
	EndIf

	Return $ai_InternetCloseHandle[0]

EndFunc   ;==>_FTPCloseFile



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
;===============================================================================

;
; Function Name:    _FTPFileFindFirst()
; Description:      Find First File on an FTP server.
; Parameter(s):     $l_FTPSession - The Long from _FTPConnect()
;                   $s_RemoteFile   - The remote Location for the file.
;                   $l_Flags  - use the dwFlags parameter to specify 1 for transferring the file in ASCII (Type A transfer method) or 2 for transferring the file in Binary (Type I transfer method).
;                   $l_Context   - lContext is used to identify the application context when using callbacks. Since we’re not using callbacks we’ll pass 0.
; Requirement(s):   DllCall, wininet.dll
; Return Value(s):  On Success - an array with element [0] = 11
;                   On Failure - array with element [0] = 0
; Author(s):        Dick Bronsdijk
; Modified:         Prog@ndy
;
;	ReturnArray:
;       [0]  - Number of elements
;       [1]  - File Attributes
;       [2]  - Creation Time Low
;       [3]  - Creation Time Hi
;       [4]  - Access Time Low
;       [5]  - Access Time Hi
;       [6]  - Last Write Low
;       [7]  - Last Write Hi
;       [8]  - File Size High
;       [9]  - File Size Low
;       [10] - File Name
;       [11] - Altername
;
;===============================================================================
Func _FTPFileFindFirst($l_FTPSession, $s_RemotePath, ByRef $h_Handle, ByRef $l_DllStruct, $l_Flags = 0, $l_Context = 0);flag = 0 changed to 2 to see if stops hanging

;~ 	Local $str  = "int;uint[2];uint[2];uint[2];dword;dword;dword;dword;char[256];char[14]"
;~ 	$l_DllStruct = DllStructCreate($str)
	$l_DllStruct = DllStructCreate($tagWIN32_FIND_DATA)
	If @error Then
		SetError(-2)
		Return ""
	EndIf

	Local $a_FTPFileList[1]
	$a_FTPFileList[0] = 0

	Local $ai_FTPFirstFile = DllCall($GLOBAL_FTP_WININETHANDLE, 'hwnd', 'FtpFindFirstFile', 'hwnd', $l_FTPSession, 'str', $s_RemotePath, 'ptr', DllStructGetPtr($l_DllStruct), 'long', $l_Flags, 'long', $l_Context)
	If @error Or $ai_FTPFirstFile[0] = 0 Then
		SetError(-1)
		Return $ai_FTPFirstFile
	EndIf
	$h_Handle = $ai_FTPFirstFile[0]
;~ 	$FileName = DllStructGetData($l_DllStruct, 9)
;~ ConsoleWrite($FileName & @CRLF)
	Local $a_FTPFileList[12]
	$a_FTPFileList[0] = 11
	$a_FTPFileList[1] = DllStructGetData($l_DllStruct, 1) ; File Attributes
	$a_FTPFileList[2] = DllStructGetData($l_DllStruct, 2, 1) ; Creation Time Low
	$a_FTPFileList[3] = DllStructGetData($l_DllStruct, 2, 2) ; Creation Time High
	$a_FTPFileList[4] = DllStructGetData($l_DllStruct, 3, 1) ; Access Time Low
	$a_FTPFileList[5] = DllStructGetData($l_DllStruct, 3, 2) ; Access Time High
	$a_FTPFileList[6] = DllStructGetData($l_DllStruct, 4, 1) ; Last Write Low
	$a_FTPFileList[7] = DllStructGetData($l_DllStruct, 4, 2) ; Last Write High
	$a_FTPFileList[8] = DllStructGetData($l_DllStruct, 5) ; File Size High
	$a_FTPFileList[9] = DllStructGetData($l_DllStruct, 6) ; File Size Low
	$a_FTPFileList[10] = DllStructGetData($l_DllStruct, 9); File Name
	$a_FTPFileList[11] = DllStructGetData($l_DllStruct, 10) ; Altername

	Return $a_FTPFileList

EndFunc   ;==>_FTPFileFindFirst

;===============================================================================

;
; Function Name:    _FTPFileFindNext()
; Description:      Find Next File on an FTP server.
; Parameter(s):     $l_FTPSession - The Long from _FTPConnect()
;                   $s_RemoteFile   - The remote Location for the file.
; Requirement(s):   DllCall, wininet.dll
; Return Value(s):  On Success - WIN32_FIND_DATA as array, see above
;                   On Failure - 0 and @error = -1
; Author(s):        Dick Bronsdijk
; Modified:			Prog@ndy
;
;===============================================================================
Func _FTPFileFindNext($h_Handle, ByRef $l_DllStruct)

	Local $a_FTPFileList[1]
	$a_FTPFileList[0] = 0

	Local $ai_FTPPutFile = DllCall($GLOBAL_FTP_WININETHANDLE, 'int', 'InternetFindNextFile', 'hwnd', $h_Handle, 'ptr', DllStructGetPtr($l_DllStruct))
	If @error Or $ai_FTPPutFile[0] = 0 Then
		SetError(-1)
		Return $a_FTPFileList
	EndIf

	Local $a_FTPFileList[12]
	$a_FTPFileList[0] = 11
	$a_FTPFileList[1] = DllStructGetData($l_DllStruct, 1) ; File Attributes
	$a_FTPFileList[2] = DllStructGetData($l_DllStruct, 2, 1) ; Creation Time Low
	$a_FTPFileList[3] = DllStructGetData($l_DllStruct, 2, 2) ; Creation Time High
	$a_FTPFileList[4] = DllStructGetData($l_DllStruct, 3, 1) ; Access Time Low
	$a_FTPFileList[5] = DllStructGetData($l_DllStruct, 3, 2) ; Access Time High
	$a_FTPFileList[6] = DllStructGetData($l_DllStruct, 4, 1) ; Last Write Low
	$a_FTPFileList[7] = DllStructGetData($l_DllStruct, 4, 2) ; Last Write High
	$a_FTPFileList[8] = DllStructGetData($l_DllStruct, 5) ; File Size High
	$a_FTPFileList[9] = DllStructGetData($l_DllStruct, 6) ; File Size Low
	$a_FTPFileList[10] = DllStructGetData($l_DllStruct, 9); File Name
	$a_FTPFileList[11] = DllStructGetData($l_DllStruct, 10) ; Altername

	Return $a_FTPFileList

EndFunc   ;==>_FTPFileFindNext

;===============================================================================
;
; Function Name:    _FTPFileTimeLoHiToStr()
; Description:      Get FileTime String
; Parameter(s):
; Requirement(s):   DllCall, date.au3
; Return Value(s):  On Success - Date
;                   On Failure - "" (empty String)
; Author(s):        Prog@ndy
;
;===============================================================================
Func _FTPFileTimeLoHiToStr($LoDWORD, $HiDWORD)
	Local $FileTime = DllStructCreate("dword;dword")
	If Not $LoDWORD And Not $HiDWORD Then Return SetError(1, 0, "")
	DllStructSetData($FileTime, 1, $LoDWORD)
	DllStructSetData($FileTime, 2, $HiDWORD)
	Local $date = _Date_Time_FileTimeToStr($FileTime)
	Return SetError(@error, @extended, $date)
EndFunc   ;==>_FTPFileTimeLoHiToStr

;===============================================================================
;
; Function Name:    _FTPFileSizeLoHi()
; Description:      Get FileSize
; Parameter(s):
; Return Value(s):  Size
; Author(s):        Prog@ndy
;
;===============================================================================
Func _FTPFileSizeLoHi($LoDWORD, $HiDWORD)
	Return BitOR(BitShift($LoDWORD, -32), BitAND($HiDWORD, 0xFFFFFFFF))
EndFunc   ;==>_FTPFileSizeLoHi

;===============================================================================

;
; Function Name:    _FTPFileFindClose()
; Description:      Delete FindFile Structure.
; Parameter(s):
; Requirement(s):   DllCall, wininet.dll
; Return Value(s):  On Success - 1
;                   On Failure - 0
; Author(s):        Dick Bronsdijk
; Modified:			Prog@ndy
;
;===============================================================================
Func _FTPFileFindClose($h_Handle, ByRef $l_DllStruct)

	$l_DllStruct = 0

	Local $ai_FTPPutFile = DllCall($GLOBAL_FTP_WININETHANDLE, 'int', 'InternetCloseHandle', 'hwnd', $h_Handle)
	If @error Or $ai_FTPPutFile[0] = 0 Then
		SetError(-1)
		Return ""
	EndIf

	Return $ai_FTPPutFile[0]

EndFunc   ;==>_FTPFileFindClose