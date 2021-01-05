#include <FTP.au3>

$server = 'ftp.xxx.com'
$username = 'user'
$pass = 'passwd'


$Open = _FTPOpen('MyFTP Control')
If @error Then Failed("Open")
$Conn = _FTPConnect($Open, $server, $username, $pass)
If @error Then Failed("Connect")

Dim $Handle
Dim $DllRect

$FileInfo = _FtpFileFindFirst($Conn, 'A*', $Handle, $DllRect)
If $FileInfo[0] Then
    Do
        MsgBox(0, "Find", $FileInfo[1] & @CR & $FileInfo[2] & @CR & $FileInfo[3] & @CR & $FileInfo[4] & @CR & $FileInfo[5] & @CR & $FileInfo[6] & @CR & $FileInfo[7] & @CR & $FileInfo[8] & @CR & $FileInfo[9] & @CR & $FileInfo[10])
        $FileInfo = _FtpFileFindNext($Handle, $DllRect)
    Until Not $FileInfo[0]
EndIf
_FtpFileFindClose($Handle, $DllRect)


$Ftpc = _FTPClose($Open)
If @error Then Failed("Close")

Exit

Func Failed($F)
    MsgBox(0, "FTP", "Failed on: " & $F)
    Exit 1
EndFunc


; =================================================  FTP Functions for UDF  ==========================================================


Local Const $FTP_ASCII = 1
Local Const $FTP_BINARY = 2
Local Const $FTP_OVERWRITE = 0
Local Const $FTP_DONTOVERWRIRE = -1
Local Const $FTP_PASSIVE = 0x8000000
Local Const $FTP_NONPASSIVE = 0

;===============================================================================
;
; Function Name:    _FTPFileFindFirst()
; Description:      Delete an file from an FTP server.
; Parameter(s):     $l_FTPSession	- The Long from _FTPConnect()
;                   $s_RemoteFile  	- The remote Location for the file.
;                   $l_Flags		- use the dwFlags parameter to specify 1 for transferring the file in ASCII (Type A transfer method) or 2 for transferring the file in Binary (Type I transfer method).
;                   $l_Context  	- lContext is used to identify the application context when using callbacks. Since we’re not using callbacks we’ll pass 0.
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
    $a_FTPFileList[1] = DllStructGetData($l_DllStruct, 1)       ; File Attributes
    $a_FTPFileList[2] = DllStructGetData($l_DllStruct, 2, 1)    ; Creation Time Low
    $a_FTPFileList[3] = DllStructGetData($l_DllStruct, 2, 2)    ; Creation Time High
    $a_FTPFileList[4] = DllStructGetData($l_DllStruct, 3, 1)    ; Access Time Low
    $a_FTPFileList[5] = DllStructGetData($l_DllStruct, 3, 2)    ; Access Time High
    $a_FTPFileList[6] = DllStructGetData($l_DllStruct, 4, 1)    ; Last Write Low
    $a_FTPFileList[7] = DllStructGetData($l_DllStruct, 4, 2)    ; Last Write High
    $a_FTPFileList[8] = DllStructGetData($l_DllStruct, 5)       ; File Size High
    $a_FTPFileList[9] = DllStructGetData($l_DllStruct, 6)       ; File Size Low
    $a_FTPFileList[10] = DllStructGetData($l_DllStruct, 9)      ; File Name
    $a_FTPFileList[11] = DllStructGetData($l_DllStruct, 10)     ; Altername

    Return $a_FTPFileList
	
EndFunc ;==> _FTPFileFindFirst()

;===============================================================================
;
; Function Name:    _FTPFileFindNext()
; Description:      Delete an file from an FTP server.
; Parameter(s):     $l_FTPSession	- The Long from _FTPConnect()
;                   $s_RemoteFile  	- The remote Location for the file.
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
    $a_FTPFileList[1] = DllStructGetData($l_DllStruct, 1)       ; File Attributes
    $a_FTPFileList[2] = DllStructGetData($l_DllStruct, 2, 1)    ; Creation Time Low
    $a_FTPFileList[3] = DllStructGetData($l_DllStruct, 2, 2)    ; Creation Time High
    $a_FTPFileList[4] = DllStructGetData($l_DllStruct, 3, 1)    ; Access Time Low
    $a_FTPFileList[5] = DllStructGetData($l_DllStruct, 3, 2)    ; Access Time High
    $a_FTPFileList[6] = DllStructGetData($l_DllStruct, 4, 1)    ; Last Write Low
    $a_FTPFileList[7] = DllStructGetData($l_DllStruct, 4, 2)    ; Last Write High
    $a_FTPFileList[8] = DllStructGetData($l_DllStruct, 5)       ; File Size High
    $a_FTPFileList[9] = DllStructGetData($l_DllStruct, 6)       ; File Size Low
    $a_FTPFileList[10] = DllStructGetData($l_DllStruct, 9)      ; File Name
    $a_FTPFileList[11] = DllStructGetData($l_DllStruct, 10)     ; Altername

    Return $a_FTPFileList
	
EndFunc ;==> _FTPFileFindNext()

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
	
    DllStructDelete($l_DllStruct)
    
    Local $ai_FTPPutFile = DllCall('wininet.dll', 'int', 'InternetCloseHandle', 'long', $h_Handle)
	If @error OR $ai_FTPPutFile[0] = 0 Then
		SetError(-1)
        Return ""
	EndIf

	Return $ai_FTPPutFile[0]
    
EndFunc ;==> _FTPFileFindClose()
