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
