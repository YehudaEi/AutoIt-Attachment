#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.2.12.1
 Author:         SetEnv

 Script Function:
	Check for unwanted Ip's in the firewall log file, and then send the ip's to a server for more analyze.
	If thoses ip were found in others user's log file, then the system will try to stop these 'attacks'...
	More Infos: <myemail>
#ce ----------------------------------------------------------------------------

; Changes
; * Replaced created-function 'StringAddToken()' by '_ArrayAdd()',
; * Replaced 2 'while' by 'For x = y to z then step',
; * Several minor bugs,
; * Now the datas between the client / server are crypted, 
; * Function TCPShutdown() added,
; * Can now receive data from ReportServer,



; includes
#Include <File.au3>
#Include <Array.au3>

; Start main thread...
Loop()

; ==============================================================================
; Function RC4(0/1, datas)
; Just crypt/decrypt text using '_StringEncrypt'
; It's just that the key is loaded from config file.
; ==============================================================================

Func RC4($type,$text) ; $type : 0 or 1 , $text : text to crypt/encrypt
	$rc4 = _StringEncrypt($type, $text, IniRead("config.cfg", "user", "passwd", "passwd", IniRead("config.cfg", "config", "RC4Level", "3"))
	Return $rc4
EndFunc

; ==============================================================================
; Function SendReport($SendString)
; Reporting String To server
; ==============================================================================

Func SendReport($SendString)
	
	Local $RServer[2] = StringSplit( FileRead( IniRead("config.cfg","config","rServer.file", "servers.lst")), ":") ; Rserver= the report server (ip port)
	
	$RSocket = TCPConnect($RServer[1], $RServer[2]) ; creating socket
	
	If $RSocket <> -1 Then ; If no error then
		
		$send = RC4("1","login:"& IniRead("config.cfg", "user", "login", "user"))
		TCPSend($RSocket, $send) ; Sending ID/PASSWD
		
		$ConnectedSocket = -1 ; Setting '$ConnectedSocket' to -1
				
		Do ; wait response
			$ConnectedSocket = TCPAccept($ReportSocket)
		Until $ConnectedSocket <> -1
	
		$recv = TCPRecv($ConnectedSocket, 2048) ; Getting Data
	
		If @Error Then ; If Error: Closing Socket
			TCPCloseSocket($ConnectedSocket)
	
		Else ; Else
			$decrypt = RC4("0", $recv)
			
			;if response equals to '400:ERRLOGIN' then the login failed. Closing socket.
			If StringInStr($decrypt, "400:ERRLOGIN") == "1" Then TCPCloseSocket($ConnectedSocket)	
			
			;if response equals to '300:WELCOME' then login was a success. Reporting string.
			If StringInStr($decrypt,"300:WELCOME") == "1" Then TCPSend($ConnectedSocket,RC4("1","REPORT:" & $SendString)) ; sending string
			
			;if response equals to '500:OK' then I know the sended string was recorded by the server. Removing it.
			If StringInStr($decrypt,"500:OK") == "1" Then $Report = " " ; setting string '$Report' as blank
			
			; if "600:ACTION:" is in datas, then the server is asking for assistance.
			If StringInStr($decrypt,"600:ACTION:") == "1" Then
				$cmdSplited = StringSplit($decrypt, ":")
				;commands need to be created
				TrayTip("ReportServer", $cmdSplited, 3,2)
				
			EndIf ;Endif
		EndIf ; Again
	EndIf ; And Again...
EndFunc ; ==> EndFunc SendReport()

; ==============================================================================
; Function Replace($ReplaceString, "replaceitem1 replaceitem2 replaceitem3 ..., $ReplaceToken)
; this function replace multi chr in string /// 
; ie: Replace( "this;is'agt@e!s;t", "; @ ! g ? ; .", ":") *should* return 'this:is:a:t:e:s:t'
; ==============================================================================

Func Replace($rString,$rChars, $rTokens)
	Dim $rArray = StringSplit($rChars," ")
	For $rloop = $rArray[0] To 0 Step -1
		$rString = StringReplace($rString, $rArray[$rloop], $rTokens)
	Next
	Return $rString
EndFunc
	
; ==============================================================================
; Function 'Isip($xisip)' : If item is an IP Return True, otherwise, return False
; ==============================================================================

Func IsIp($sIP)
	Local $eval = StringRegExp($sIP, "(?:(f\d|[1-9]\d|1\d{2}|2[0-4]\d|25[0-5])(\.)){3}(?:(25[0-5]$|2[0-4]\d$|1\d{2}$|[1-9]\d$|\d$))")
	If $eval <> "1" Then Return "False"
	If $eval == "1" Then Return "True"
EndFunc

; ==============================================================================
; Function 'loop()'
; ==============================================================================
Func Loop() ; Main thread
	
	TCPStartup()
		
	;setting some vars
		
	Global $line = IniRead("config.cfg","config", "line", "1"), $path = IniRead("config.cfg", "config", "path", "NULL"
	
	; Traytips
	
	If $path == "NULL" Then
		TrayTip("chkconfig", "Firewall's log not found."&@CRLF&" The script will probaby never find any IP..." , 2, 3)
		Sleep(1800)
		TrayTip("loop", "Starting anyway...", 3, 1)
		
	Else
		TrayTip("Loop", "Starting... ", 3,1) 
	EndIf
	
	; Setting '$DontReport' var : Ip who will not be reported.
	Dim $DontReport[10]
	$DontReport = IniRead("config.cfg", "config", "DontReport", "127.0.0.1 " & @IPAddress1 & " " & @IPAddress2 & " " & @IPAddress3)  

	While 1 ; While
		
		If $line <= _FileCountLines($path) Then ; If var 'line' is less or equal as maxlines contain in the log file:
		
			; Setting some var
			
			Local $read = FileReadLine($path, $line), $read = Replace($read,'@ " ; # ! ^ < > \ / + -', ":")
			
			Dim $Report[500], $stringsplit[500] 
			
			$stringsplit = StringSplit($read,":") 
			
			Local $stringDec = $stringsplit[0]

			; While items in list
			For $loop = $stringDec To 0 Step -1				
				;  Check if item is an IP         ,  check if item is in '$DontReport' (like localhost, 127.0.0.1, ...)
				Local $isip = isip($stringsplit[$loop]), $IsProtect = StringInStr($DontReport,$stringsplit[$loop])
				
				; if current item is an Ip AND is not protected, then adding item to var '$Report'
				If $isip == "True" And $IsProtect == "0" Then _ArrayAdd($Report, $stringsplit[$loop])
			Next 
			
		; If total items in '$report' > 0 then, reporting unknow ip's to server for more analyze.
		If $Report[0] > 0 Then SendReport($Report)
		EndIf ; EndIf
	WEnd ; End Of While
	
	; If Wend, stopping TCPServices
	TCPShutdown()
EndFunc ; ===> EndFunc 'Loop()'