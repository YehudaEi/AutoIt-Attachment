#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.2.12.1
 Author:         SetEnv

 Script Function:
	Check firewall logs to find unwanted IP.
	If an external IP was found in the log file, then reporting it to a 'central server'.
	This server will check if this IP was found in other users firewall log,
	if yes, then an hacker (...) could be trying to make some bad stuff to you.
	The 'central server' will then send an email to the provider, and if no response, 
	will *try* to 'flood' the unwated Ip.
	
	=> This tool is like an 'offensive firewall'.
#ce ----------------------------------------------------------------------------

; Changes
; * New Function: CreateNewIdentity --- Create new identify sended by server
; * AutoSaving Work --- See '$SaveInc' and SaveWork()
; * Function 'Loop()' revisited and reorganized.
; * Function 'Replace($string, $token)' Rewritted (This function really suck now... I need to re-rewrite it!)
; * If log file present, then correctly exact unknown ip's.
; * Correction of several bugs, again...
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


; includes
#Include <File.au3>
#Include <Array.au3>
#Include <String.au3>

; Start main thread...
MainThread()

; ==============================================================================
; Function CreateNewIdentity($cData)
; $cData = "blablabla:blabla MYNEWIDENTITY"
; ==============================================================================

Func CreateNewIdentity($cData)
	$cSplit = StringSplit($cData," ")
	IniWrite("config.cfg","config", "myid", $cSplit[2])
	TrayTip("Config", "Welcome! Your new identity is: "&IniRead("config.cfg", "config", "myid", "ERROR"),5,2)
EndFunc


; ==============================================================================
; Function 'ChkConfig' : Check if files needed are present or not.
; ==============================================================================

Func ChkConfig()
	
	; Is Firewall Log file present?
	
	If FileExists($FirewallFile) == "0" Then
		
		TrayTip("chkconfig", "Firewall logs not found."&@CRLF&" The script will probaby never find any IP..." , 2, 3)
		Sleep(1200)
		TrayTip("LogChecker", "Starting anyway...", 3, 2)
		
	Else
		TrayTip("LogChecker", "Starting... ", 3,1) 
	EndIf
EndFunc


; ==============================================================================
; Function RC4(Encode|Decode, datas)
; Just crypt/decrypt text using '_StringEncrypt'
; It's just that the key is loaded from config file and cannot be given by user.
; ==============================================================================

Func RC4($type,$text) ; $type : encode or decode , $text : text to crypt/encrypt
	If $type == "Encode" Then $RC4 = _StringEncrypt("1", $text, IniRead("config.cfg", "config", "myid", "newuser"),3)
	If $type == "Decode" Then $RC4 = _StringEncrypt("0", $text, IniRead("config.cfg", "config", "myid", "newuser"),3)
	Return $rc4
EndFunc

; ==============================================================================
; Function SendReport($SendString)
; Reporting String To server
; ==============================================================================

Func SendReport($SendString)
	TrayTip("SendReport",$SendString,2,1)
	Sleep(2100)
	; '$Rserver' is the report server defined for this session (ip port)
	Local $RServer = FileRead( $RServersFile)
	
	$RSocket = TCPConnect($RServer[1], $RServer[2]) ; creating socket
	
	If $RSocket <> -1 Then ; If no error then
		
		$send = RC4("Encode",IniRead("config.cfg", "user", "login", "newuser"))
		
		TCPSend($RSocket, $send) ; Sending ID
		
		$ConnectedSocket = -1 ; Set '$ConnectedSocket' to -1
				
		Do ; wait response
			$ConnectedSocket = TCPAccept($RSocket)
		Until $ConnectedSocket <> -1
	
		$recv = TCPRecv($ConnectedSocket, 2048) ; Get Data
	
		If @Error Then ; If Error: Close Socket
			TCPCloseSocket($ConnectedSocket)
	
		Else ; Else
	
			$decrypt = RC4("Decode", $recv) ; decoding datas
			
			;if response equals to '300:WELCOME' then login was a success. Reporting List.
			If StringInStr($decrypt,"300:WELCOME") == "1" Then TCPSend($ConnectedSocket,RC4("1","REPORT:" & $SendString)) ; sending list
			
			;if response equals to '400:ERRLOGIN' then the login failed. Closing socket.
			If StringInStr($decrypt, "400:ERRLOGIN") == "1" Then TCPCloseSocket($ConnectedSocket)
			
			;if response equals to '500:RESETSTRING' then I know the sended string was recorded by the server. Removing it.
			If StringInStr($decrypt,"500:RESETSTRING") == "1" Then $Report = " " ; setting string '$Report' as blank
			
			; if "600:ACTION:" is in datas, then the server is asking for assistance.
			If StringInStr($decrypt,"600:ACTION") == "1" Then ServerCmd($decrypt)
			
			;if "800:NIDENTITY" is in string then the server send a new identity -USED IF NEW USER-
			If StringInStr($decrypt,"800:NIDENTITY") == "1" Then CreateNewIdentity($decrypt)
			
		EndIf ; EndIf
	EndIf ; Again
	$SaveInc += 1
	If $SaveInc >= 100 Then SaveWorck() ; If var '$SaveIc' >= 100 then saving current position in firewall's log file.
EndFunc ; ==> EndFunc SendReport()


; ==============================================================================
; Function ServerCmd($sCmd)
; $cCmd: "600:ACTION COMMAND and maybe some args"
;
; -- Instead of watching your log files, this tool could ALSO create some 
; -- 'attacks' against 'unknown IP'S'.
; -- If Ip's found in YOUR logs file were found in several user's LogFile AND
; -- if this client is configured to follow those kind of 'mass-attack', then
; -- this client will MAYBE react.
;
; But, no command added yet... And nothing panned at this time
; ==============================================================================

Func ServerCmd($sCmd)
	TrayTip("ServerCMD",$sCmd,3, 2)
EndFunc

; ==============================================================================
; Function Replace()
; ==============================================================================

Func Replace($rmString, $rmTokens) ; If someone has a better idea... I tryied to make a While or a For , without success...
	$Return = StringReplace($rmString, "'", $rmTokens)
	$Return = StringReplace($Return, "@", $rmTokens)
	$Return = StringReplace($Return, "#", $rmTokens)
	$Return = StringReplace($Return, "{", $rmTokens)
	$Return = StringReplace($Return, "}", $rmTokens)
	$Return = StringReplace($Return, "[", $rmTokens)
	$Return = StringReplace($Return, "]", $rmTokens)
	$Return = StringReplace($Return, "!", $rmTokens)
	$Return = StringReplace($Return, "^", $rmTokens)
	$Return = StringReplace($Return, ",", $rmTokens)
	$Return = StringReplace($Return, ";", $rmTokens)
	$Return = StringReplace($Return, "&", $rmTokens)
	$Return = StringReplace($Return, " ", $rmTokens)
	$Return = StringReplace($Return, '"', $rmTokens)
	Return $Return
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
; Function 'MainThread()'
; 
; This function Reads lines from the firewall logs file, extract unknown Ips.
;
; At the end, if items are present in the list, then sending it to the report
; server.
; ==============================================================================

Func MainThread()
	
	TCPStartup() ; Start TCPServices
	
	Global $line = IniRead("config.cfg","config", "line", "1"), $FirewallFile = IniRead("config.cfg", "config", "fw.logfile", "NULL")
	Global $DontReport = IniRead("config.cfg", "config", "dontReport", "127.0.0.1 "&@IPAddress1), $SaveInc
	Global $RServersFile = IniRead("config.cfg","config", "ReportServersFile","servers.lst")
	Dim $Report[1000]

	; Checking if Firewall LogFile is defined.
	ChkConfig()

	; Ok, main thread now (while 1)
	While 1
		
		If $line <= _FileCountLines($FirewallFile) Then ; If var 'line' is less or equal as maxlines contain in the log file
			
			; $read = line readed in file
			Local $read = FileReadLine($FirewallFile, $line), $Report[500], $StringSplit[500]  
			
			$read = Replace($read,':') ; replace several chars
			
			$StringSplit = StringSplit($read,":") ; creating list '$StringSplit'
			
			For $loop = $StringSplit[0] To 0 Step -1	 ; For $loop > 0
				
				Local $lItem = $stringsplit[$loop] ; set current item

				; If Item is an IP and IS NOT protected, then adding it to '$Report'
				If IsGoodItem($lItem) == "True" Then  _ArrayAdd($Report, $lItem) 
			Next

			$line += 1
		EndIf
		
		; If total items in list '$report' >= 1 then, reporting to server for more analyze.
		If $Report[0] >= 1 Then SendReport($Report)
			
	WEnd ; End Of While
	
	; If Wend, stopping TCPServices??
	TCPShutdown()
EndFunc ; ===> EndFunc 'Loop()'

Func SaveWorck()
	IniWrite("config.cfg", "config", "line", $line) ; This last line will be loaded at next startup if program crash
	$SaveInc = 0 ; and will be re-saved when '$SaveInc' >= 100 and again, again...
	TrayTip("LogCheck", "New position saved... ["&$line&"]" , 3, 1)
EndFunc

Func IsGoodItem($igItem)
	; If this item is NOT an ip, or is present in '$DontReport' , or if item is null, then return 'false'
	If IsIp($igItem) <> 'True' Or StringInStr($DontReport, $igItem) <> '1' Or $igItem == '' Or $igItem == ' ' Then 
		Return 'False'
	Else ; else : return 'true'
		Return 'True'
	EndIf
EndFunc
