; AutoIt Version: 3.1.1.103 (beta)

Global $wininet_dll = DllOpen("wininet.dll")

$remote_folder = ""
$server = "ftp.mcafee.com"
$username = "anonymous"
$pass = ""

$Open = _FTPOpen("MyFTP Control")
$Conn = _FTPConnect($Open, $server, $username, $pass)

MsgBox(64, "_FTPFolderTree Output", _FTPFolderTree($Conn))

_FTPClose($Open)
DllClose($wininet_dll)
Exit
;
;
func _FTPFolderTree($l_FTPSession, $s_Remote = "") 
	; on success: returns string of readable folders (seperated by @LF)
	; on failure: returns empty string and sets error to 1
	; $l_FTPSession	 - The Long from _FTPConnect()
	; $s_Remote      - the foldername from where to search the subfolders - empty string = root folder
	if StringLeft($s_Remote,1) = "/" then $s_Remote = StringTrimleft($s_Remote,1)
	;try to set the $s_remote directory (check for FTP-read-access)
	_FtpSetCurrentDir($l_FTPSession, "/" & $s_Remote)
	if @error Then   ; no read access , return empty string
		SetError(1)
		return ""
	EndIf
	Local $l_handle 
	Local $dll_struct
	Local $ret_folders = ""	
	;store $s_Remote
	$ret_folders = $ret_folders & "/" & $s_Remote & @LF
	;search for subfolders in $s_Remote
	Local $ret_array = _FTPFileFindFirst($l_FTPSession, "*.*", $l_handle, $dll_struct)
	If @error = 0 Then
		if ($ret_array[1] = 16) and ($ret_array[10] <> ".") and ($ret_array[10] <> "..") Then 
			; _FTPFileFindFirst has returned a subfolder
			;recursive function call, pass subfolder as $s_Remote
			$ret_folders = $ret_folders & _FTPFolderTree($l_FTPSession,$s_Remote & "/" & $ret_array[10] )
		EndIf
		Do
			$ret_array = _FTPFileFindNext($l_handle, $dll_struct)
			If $ret_array[0] <> 0 Then
				if ($ret_array[1] = 16) and ($ret_array[10] <> ".") and ($ret_array[10] <> "..") Then 
					; _FTPFileFindNext has returned a subfolder
					; recursive function call, pass subfolder as $s_Remote					
					$ret_folders = $ret_folders & _FTPFolderTree($l_FTPSession,$s_Remote & "/" & $ret_array[10] )
				EndIf
			EndIf
		Until $ret_array[0] = 0  ; _FTPFileFindNext does not find anything more
	EndIf
	_FTPFileFindClose($l_handle, $dll_struct)
	return $ret_folders
EndFunc
;
#region foreign functions
Func _FTPOpen($s_Agent, $l_AccessType = 1, $s_ProxyName = '', $s_ProxyBypass = '', $l_Flags = 0)
	; $s_Agent = beliebiger Name ; returns session handle for connect / close
	Local $ai_InternetOpen = DllCall($wininet_dll, 'long', 'InternetOpen', 'str', $s_Agent, 'long', $l_AccessType, 'str', $s_ProxyName, 'str', $s_ProxyBypass, 'long', $l_Flags)
	If @error Or $ai_InternetOpen[0] = 0 Then
		SetError(-1)
		Return 0
	EndIf
	Return $ai_InternetOpen[0]
EndFunc   ;==>_FTPOpen
;
Func _FTPConnect($l_InternetSession, $s_ServerName, $s_Username, $s_Password, $i_ServerPort = 0, $l_Service = 1, $l_Flags = 0, $l_Context = 0)
	; $l_InternetSession from _FTPOpen ; returns connection handle for many ftp functions
	Local $ai_InternetConnect = DllCall($wininet_dll, 'long', 'InternetConnect', 'long', $l_InternetSession, 'str', $s_ServerName, 'int', $i_ServerPort, 'str', $s_Username, 'str', $s_Password, 'long', $l_Service, 'long', $l_Flags, 'long', $l_Context)
	If @error Or $ai_InternetConnect[0] = 0 Then
		SetError(-1)
		Return 0
	EndIf
	Return $ai_InternetConnect[0]
EndFunc   ;==>_FTPConnect
;
Func _FtpSetCurrentDir($l_FTPSession, $s_Remote)
	; $l_FTPSession from _FTPConnect
	Local $ai_FTPSetCurrentDir = DllCall($wininet_dll, 'int', 'FtpSetCurrentDirectory', 'long', $l_FTPSession, 'str', $s_Remote)
	If @error Or $ai_FTPSetCurrentDir[0] = 0 Then
		SetError(-1)
		Return 0
	EndIf
	Return $ai_FTPSetCurrentDir[0]
EndFunc   ;==>_FtpSetCurrentDir
;
Func _FTPClose($l_InternetSession)
	; $l_InternetSession from _FTPOpen
	Local $ai_InternetCloseHandle = DllCall($wininet_dll, 'int', 'InternetCloseHandle', 'long', $l_InternetSession)
	If @error Or $ai_InternetCloseHandle[0] = 0 Then
		SetError(-1)
		Return 0
	EndIf
	Return $ai_InternetCloseHandle[0]
EndFunc   ;==>_FTPClose
;
Func _FTPFileFindFirst($l_FTPSession, $s_RemoteFile, ByRef $h_Handle, ByRef $l_DllStruct, $l_Flags = 0, $l_Context = 0)
	Local $str = "int;uint[2];uint[2];uint[2];int;int;int;int;char[256];char[14]"
	$l_DllStruct = DllStructCreate($str)
	If @error Then
		SetError(-2)
		Return ""
	EndIf
	Dim $a_FTPFileList[1]
	$a_FTPFileList[0] = 0
	Local $ai_FTPPutFile = DllCall($wininet_dll, 'int', 'FtpFindFirstFile', 'long', $l_FTPSession, 'str', $s_RemoteFile, 'ptr', DllStructGetPtr($l_DllStruct), 'long', $l_Flags, 'long', $l_Context)
	If @error Or $ai_FTPPutFile[0] = 0 Then
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
EndFunc   ;==>_FTPFileFindFirst
;
Func _FTPFileFindNext($h_Handle, $l_DllStruct)
	Dim $a_FTPFileList[1]
	$a_FTPFileList[0] = 0
	Local $ai_FTPPutFile = DllCall($wininet_dll, 'int', 'InternetFindNextFile', 'long', $h_Handle, 'ptr', DllStructGetPtr($l_DllStruct))
	If @error Or $ai_FTPPutFile[0] = 0 Then
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
EndFunc   ;==>_FTPFileFindNext
;
Func _FTPFileFindClose($h_Handle, $l_DllStruct)
	$l_DllStruct = 0
	Local $ai_FTPPutFile = DllCall($wininet_dll, 'int', 'InternetCloseHandle', 'long', $h_Handle)
	If @error Or $ai_FTPPutFile[0] = 0 Then
		SetError(-1)
		Return ""
	EndIf
	Return $ai_FTPPutFile[0]
EndFunc   ;==>_FTPFileFindClose
#endregion