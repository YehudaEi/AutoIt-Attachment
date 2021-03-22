#include <SFTPEx.au3>
#include <Array.au3>

; example provided by GreenCan

; open session
Global $hSession = _SFTP_Open()
If @error Then Exit MsgBox(48, "Error",  "_SFTP_Open error " & @error )
ConsoleWrite( @ScriptLineNumber & " " & " _SFTP_Open OK" & @CR)


; Variable setup
;~ ========================================
; please fill your own for testing
;~ Global $sServerName = "server name" 				; ==> fill in
;~ Global $sUsername = "user name" 					; ==> fill in
;~ Global $sPassword = "user password"				; ==> fill in
;~ Global $iServerPort = 22							; ==> fill in optionally, default should be 22, not 0 as far as i know
;~ Global $cRemoteDir = "/some remote paths"		; ==> fill in
;~ ========================================
Global $sLocalFile = @ScriptDir & "\" & "test.txt"  ; you have to create this file in your @ScriptDir for the test purpose !!!!
Global $sRemoteFile = "test.tmp"
Global $sRemoteFinalFile = "test.txt"
Global $sRemoteNewDir = "TestDir"
Global $sRemoteFilesWithWildcard = "*.txt"

; connect to host
Global $hConnection = _SFTP_Connect($hSession, $sServerName, $sUsername, $sPassword, $iServerPort)
If @error Then Exit MsgBox(48, "Error",  "_SFTP_Connect error " & @error )
ConsoleWrite(@ScriptLineNumber & " " & " _SFTP_Connect " & $sServerName & " = OK" & @CR)

; list current dir
Global $sDefaultRemoteDir = _SFTP_DirGetCurrent($hConnection)
If @error Then
	;MsgBox(48, "Error",  "_SFTP_DirGetCurrent error " & @error )
	ConsoleWrite(@ScriptLineNumber & " " & " _SFTP_DirGetCurrent = Failure with error " & @error & @CR)
Else
	ConsoleWrite(@ScriptLineNumber & " " & " _SFTP_DirGetCurrent = " & $sDefaultRemoteDir & " = OK" &  @CR)
EndIf

; Set Current Remote Directory
Global $sCurrentRemoteDir = _SFTP_DirSetCurrent($hConnection, $cRemoteDir)
If @error Then Exit MsgBox(48, "Error",  "_SFTP_DirSetCurrent error " & @error )
ConsoleWrite(@ScriptLineNumber & " " & " _SFTP_DirSetCurrent = " & $sCurrentRemoteDir & " = OK" & @CR)


; List Current Remote Directory (Full LS)
$aFileList = _SFTP_ListToArrayEx($hConnection, $cRemoteDir)
If @error Then
	;MsgBox(48, "Error",  "_SFTP_ListToArrayEx error " & @error )
	ConsoleWrite( @ScriptLineNumber & " " & " _SFTP_ListToArrayEx " & $cRemoteDir & " = Failure with error " & @error & @CR)
Else
	ConsoleWrite(@ScriptLineNumber & " " & " _SFTP_ListToArrayEx " & $cRemoteDir & " = OK" & @CR)
	_ArrayDisplay($aFileList, "Remote directory content")
EndIf

; Put a new file in the remote directory
_SFTP_FilePut($hConnection, $sLocalFile, $sRemoteFile)
If @error Then
	;MsgBox(48, "Error",  "_SFTP_FilePut error " & @error )  ; don't exit
	ConsoleWrite(@ScriptLineNumber & " " & " _SFTP_FilePut " & $sLocalFile & " => " & $sRemoteFile & " = Failure with error " & @error & @CR)
Else
	ConsoleWrite(@ScriptLineNumber & " " & " _SFTP_FilePut " & $sLocalFile & " => " & $sRemoteFile & " = OK" & @CR)
EndIf

; Simple List Current Remote Directory (LS)
$aFileList = _SFTP_ListToArray($hConnection, $cRemoteDir)
If @error Then
	;MsgBox(48, "Error",  "_SFTP_ListToArray error " & @error )
	ConsoleWrite(@ScriptLineNumber & " " & " _SFTP_ListToArray " & $cRemoteDir & " = Failure with error " & @error & @CR)
Else
	ConsoleWrite(@ScriptLineNumber & " " & " _SFTP_ListToArray " & $cRemoteDir & " = OK" & @CR)
	ConsoleWrite(@ScriptLineNumber & " " & _ArrayToString($aFileList, "|") & @CR)
EndIf

; rename file in the remote directory
_SFTP_FileMove($hConnection, $sRemoteFile, $sRemoteFinalFile)
If @error Then
	;MsgBox(48, "Error",  "_SFTP_FileMove error " & @error )  ; don't exit
	ConsoleWrite(@ScriptLineNumber & " " & " _SFTP_FileMove " & $sRemoteFile & " => " & $sRemoteFinalFile & " = Failure with error " & @error & @CR)
Else
	ConsoleWrite(@ScriptLineNumber & " " & " _SFTP_FileMove " & $sRemoteFile & " => " & $sRemoteFinalFile & " = OK" & @CR)
EndIf

; Simple List Current Remote Directory (LS)
$aFileList = _SFTP_ListToArray($hConnection, $cRemoteDir)
If @error Then
	;MsgBox(48, "Error",  "_SFTP_ListToArray error " & @error )
	ConsoleWrite(@ScriptLineNumber & " " & " _SFTP_ListToArray " & $cRemoteDir & " = Failure with error " & @error & @CR)
Else
	ConsoleWrite(@ScriptLineNumber & " " & " _SFTP_ListToArray " & $cRemoteDir & " = OK" & @CR)
	ConsoleWrite(@ScriptLineNumber & " " & _ArrayToString($aFileList, "|") & @CR)
EndIf

; Create a new directory on the remote host
_SFTP_DirCreate($hConnection, $sRemoteNewDir)
If @error Then
	;MsgBox(48, "Error",  "_SFTP_DirCreate error " & @error )  ; don't exit
	ConsoleWrite(@ScriptLineNumber & " " & " _SFTP_DirCreate " & $sRemoteNewDir & " = Failure with error " & @error & @CR)
Else
	ConsoleWrite(@ScriptLineNumber & " " & " _SFTP_DirCreate " & $sRemoteNewDir & " = OK" & @CR)
EndIf

; move files *.txt in the remote directory to Test Alain
_SFTP_FileMove($hConnection, $sRemoteFilesWithWildcard, $sRemoteNewDir)
If @error Then
	;MsgBox(48, "Error",  "_SFTP_FileMove error " & @error )  ; don't exit
	ConsoleWrite(@ScriptLineNumber & " " & " _SFTP_FileMove " & $sRemoteFilesWithWildcard & " => " & $sRemoteNewDir & " = Failure with error " & @error & @CR)
Else
	ConsoleWrite(@ScriptLineNumber & " " & " _SFTP_FileMove " & $sRemoteFilesWithWildcard & " => " & $sRemoteNewDir & " = OK" & @CR)
EndIf

; Simple List Current Remote Directory (LS)
$aFileList = _SFTP_ListToArray($hConnection, $cRemoteDir)
If @error Then
	;MsgBox(48, "Error",  "_SFTP_ListToArray error " & @error )
	ConsoleWrite(@ScriptLineNumber & " " & " _SFTP_ListToArray " & $cRemoteDir & " = Failure with error " & @error & @CR)
Else
	ConsoleWrite(@ScriptLineNumber & " " & " _SFTP_ListToArray " & $cRemoteDir & " = OK" & @CR)
	ConsoleWrite(@ScriptLineNumber & " " & _ArrayToString($aFileList, "|") & @CR)
EndIf

; close session
_SFTP_Close($hSession)
If @error Then Exit MsgBox(48, "Error",  "_SFTP_Close error " & @error )
ConsoleWrite(@ScriptLineNumber & " " & " _SFTP_Close OK" & @CR)

Exit