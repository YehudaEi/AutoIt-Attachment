; It looks like I have a newer version of the FTP UDF, so I will incude that with this post
#include <FTPEx.au3>

#include <File.au3>
#include <Array.au3>

; This forces all variables to be predecared, which really helps
; ferret out bugs that are because of spelling mistakes
AutoItSetOption  ("MustDeclareVars", 1)

;Open Files
Local $dominios = FileOpen('dominios.txt', 0)
Local $logins = FileOpen('logins.txt', 0)
Local $pastas = FileOpen('lista.txt', 0)

; I changed this part to avoid mixing filenames and filehandles
; I turned it into a function because I like to leave as few 
; temporary variable around as possible, becasue they eat an
; (admittably small) chunk of memory, and they can cause wierd
; bugs if I forget what I have declared
Local $logfile = OpenOrCreateLog (@ScriptDir & '\log upload.txt')

While 1
    Local $server = FileReadLine($dominios)
    If @error = -1 Then ExitLoop
    Local $username = FileReadLine($logins)
    If @error = -1 Then ExitLoop
    Local $linha = FileReadLine($pastas)
    If @error = -1 Then ExitLoop
    
	Local $password = 'jomag@jovial'


    TrayTip('...', 'Conectando a ' & $server, 3)
	
	; I wrapped these with functions to make debugging easier, and to help
	; me understand the steps a little better
	
	; Create an FTP Session
	Local $FTPsession = FTPSessionOpen ('MyFTP Control', $logfile, $linha)
	If Not $FTPsession Then ContinueLoop
	
	; Open a connection
	Local $FTPconnect = FTPSessionConnect ($FTPsession, $server, $username, $password, $logfile, $linha)
	If Not $FTPconnect Then 
		; This was probably the problem, if you ran into a problem the FTP Session and etc was left open
		; and this could create problems with lack of memory, and thus the script hanging
		If FTPSessionClose ($FTPsession, $logfile, $linha) Then ContinueLoop
	EndIf
	
	; Change remote directory
	; This test structure shortcircuits, so the FTPSessionClose will ONLY run if FTPSet..Dir fails
	If Not FTPSetRemoteDir ($FTPconnect, '\httpdocs\', $logfile, $linha) And FTPSessionClose ($FTPsession, $logfile, $linha) Then ContinueLoop
	
	; Get the names of the remote files
	Local $RemoteFiles = FTPGetFileNames ($FTPconnect, $logfile, $linha)
	If Not $RemoteFiles And FTPSessionClose ($FTPsession, $logfile, $linha) Then ContinueLoop
	
	; Delete the remote files
	FTPDeleteFiles ($RemoteFiles, $FTPconnect, $logfile, $server)
	
	; Get the names of the local files to send
    Local $LocalFiles = _FileListToArray(@ScriptDir & '\' & $linha, '*.*', 1)
	
	; Not entirely sure why there is a two second delay here
    Sleep(2000)
	
	; Send the files to the server
	FTPSendFiles (@ScriptDir & '\' & $linha, '\httpdocs\', $LocalFiles, $FTPconnect, $logfile, $linha, $server)

	; Create a remote directory
	If Not _FTP_DirCreate($FTPconnect, 'httpdocs\arquivos') Then
		FileWriteLine($logfile, $linha & ' (Erro ao criar pasta httpdocs\arquivos)' & @CRLF)
		; Jump to the next loop because we can't write to a directory that doesn't exist
		If FTPSessionClose ($FTPsession, $logfile, $linha) Then ContinueLoop
	EndIf
    
	; Get the files to copy into the directory we just made
	Local $LocalFiles_Arquivos = _FileListToArray(@ScriptDir & '\' & $linha & '\arquivos', '*.*', 1)
	
	; Send the files to the server
	FTPSendFiles (@ScriptDir & '\' & $linha & '\arquivos\', '\httpdocs\arquivos\', $LocalFiles_Arquivos, $FTPconnect, $logfile, $linha, $server)
    
	; Clean everything up for the next round
	FTPSessionClose ($FTPsession, $logfile, $linha)
WEnd

FileClose($dominios)
FileClose($logins)
FileClose($pastas)
FileClose($logfile)

Func FTPSendFiles ($SourceDir, $DestDir, $LocalFiles, $FTPconnectHandle, $LogHandle, $LinePrefix, $ServerName)
	For $index = 1 To UBound($LocalFiles) - 1
		If Not _FTP_FilePut($FTPconnect, $SourceDir & '\' & $LocalFiles[$index], $DestDir & $LocalFiles[$index]) Then
			FileWriteLine($LogHandle, $SourceDir & '\' & $LocalFiles[$index] & ' (Erro ao copiar arquivo para ' & $ServerName & ')' & @CRLF)
		EndIf
	Next
EndFunc

Func FTPGetFileNames ($FTPConnectionHandle, $LogHandle, $LinePrefix)
	Local $RFileArray = _FTP_ListToArray($FTPConnectionHandle, 2)
    If Not $RFileArray[0] Then
        FileWriteLine($LogHandle, $LinePrefix & ' (Erro ao listar os arquivos da pasta httpdocs)' & @CRLF)
        Return False
    EndIf
	Return $RFileArray
EndFunc

Func FTPDeleteFiles ($RemoteFileArray, $FTPconnect, $LogHandle, $ServerName)
	For $index = 1 To UBound($RemoteFileArray) - 1
        If Not _FTP_FileDelete($FTPconnect, $RemoteFileArray[$index]) Then 
			FileWriteLine($LogHandle, $RemoteFileArray[$index] & ' (Erro ao apagar arquivo em ' & $ServerName & ')' & @CRLF)
		EndIf
    Next
EndFunc

Func FTPSetRemoteDir ($FTPconnectionHandle, $RemoteDir, $LogFileHandle, $LinePrefix)
	If Not _FTP_DirSetCurrent($FTPconnectionHandle, $RemoteDir) Then
		FileWriteLine($LogFileHandle, $LinePrefix & ' (Erro ao Encontrar o diretório httpdocs)' & @CRLF)
		Return False
	EndIf
	Return True
EndFunc

Func FTPSessionClose ($FTPsessionHandle, $LogHandle, $LinePrefix)
	If Not _FTP_Close ($FTPsessionHandle) Then
        FileWriteLine($LogHandle, $LinePrefix & ' (Erro ao fechar conexão com o servidor FTP)' & @CRLF)
        ; If we can't close the connection, then bad, bad things are happening (or at least I would assume so)
		MsgBox (0, "FATAL ERROR:", "Unable to close session, verify internet connection.")
		Exit
    EndIf
	Return True
EndFunc

Func FTPSessionOpen ($name, $logHandle, $linePrefix)
    Local $FTPsessionHandle = _FTP_Open($name)
    If Not $FTPsessionHandle Then
        FileWriteLine($logfile, $linha & ' (Erro ao Abrir o Servidor FTP)' & @CRLF)
        Return False
    EndIf
	
	Return $FTPsessionHandle
EndFunc

Func FTPSessionConnect ($FTPsessionHandle, $ServerURL, $UserName, $Password, $LogHandle, $LinePrefix)
	Local $ConnectionHandle = _FTP_Connect($FTPsessionHandle, $ServerURL, $UserName, $Password)
	If Not $ConnectionHandle Then
        FileWriteLine($LogHandle, $LinePrefix & ' (Erro ao Conectar no Servidor FTP)' & @CRLF)
        Return False
    EndIf
	Return 
EndFunc

Func OpenOrCreateLog ($log)
	Local $weCreated = False
	If Not FileExists ($log) Then $weCreated = True
		
	Local $logHandle = FileOpen ($log, 1)
	
	If $weCreated Then FileWrite ($logHandle, 'Problemas de Upload:' & @CRLF)
		
	Return $logHandle
EndFunc