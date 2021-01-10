#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.2.12.1
 Author:         SetEnv

 Script Function:
	LogCheck server.

#ce ----------------------------------------------------------------------------


; Changes
; * GetAbuseEmail($IpAddress) : Try to find an abuse email about ip adress -telnetting whois.arin.net:43-
; * Create new Identity for client : Create random identity for new client,
; * Craeted function 'SendReportToProvider($IpAddress)' : Report an abuse to the e-mail address found with 'GetAbuseEmail()',
; * Correction of several bugs,
; * Many others things...

; Note: The code could be optimized, for sure...

MainThread()

Func MainThread()
	
	Local $myip = "127.0.0.1", $nPORT = IniRead("config.ini", "server", "port", "300")
	
	Local $MainSocket, $ConnectedSocket, $szIP_Accepted, $recv

	TCPStartup()

	$MainSocket = TCPListen($myip, $nPORT, 500)

	If $MainSocket <> -1 Then
		TrayTip("LogCheck [server]","Waiting for connection...", 5, 1)
		
		While 1
			
			$ConnectedSocket = -1

			Do
				$ConnectedSocket = TCPAccept($MainSocket)
			Until $ConnectedSocket <> -1

			$recv = TCPRecv($ConnectedSocket, 2048)
		
			; If the receive failed with @error then the socket has disconnected
			; AND Removing socket from identified socket...
			;=====================================================================
			If @error Then 
				IniDelete("auth.ini", "logged", $ConnectedSocket)
			
			Else
		
				If IsLogged($ConnectedSocket) == "False" Then IsKnownClient($ConnectedSocket, $recv)
				
				If IsLogged($ConnectedSocket) == "True" Then 
					$DecodedDatas = Decode($ConnectedSocket,$recv) ; decode datas
					; If '$decodeddatas' <> "empty" then analyzing datas.
					If $DecodedDatas <> "empty" Then Analyze($ConnectedSocket, $DecodedDatas)
				EndIf
			EndIf
		WEnd
	EndIf
EndFunc

Func SendNewIdentity($client)	
	$NewId = xRandom(10)
	$NewDomain = xRandom(25)
	TCPSend($client, Encode("800:NIDENTITY "&$NewId&"@"&$NewDomain, $key))
EndFunc

Func xRandom($len)
	For $xLopp = $len To 0 Step -1
		$xrdm &= Chr(Random(Asc("a"), Asc("z"), 1))
	Next
	Return $xrdm
EndFunc

Func IsLogged($iClient)
	Return IniRead("items.db", "logged", $iClient, "False")
EndFunc

Func Encode($client, $datas)
	Return _StringEncrypt("1", $datas, IniRead("items.db", "logged", $client, "empty")
EndFunc

Func Decode($client, $datas)
	Return _StringEncrypt("0", $datas, IniRead("items.db", "logged", $client, "empty")
EndFunc

Func IsKnowClient($client, $send)
	For $iLoop = _FileCountLines("users") To 0 Step -1
		$iRead = FileReadLine("users", $iLoop)
		
		$iVerif = _StringEncrypt("0", $send, $iRead)
		If  $iVerif == $iRead Then 
			IniWrite("items.db", "logged", $client, $iRead)
			TCPSend($client, "300:WELCOME")
		EndIf
	Next
	TCPCloseSocket($client)
EndFunc

Func SendMailToProvider($rIp)
	$IsEmail = IniRead("items.db","abusedb", $rIp, "NONE")
	
	If $IsEmail == "NONE" Then 
		GetAbuseEmail($rIp)

	Else
		$LastSend = IniRead("items.db", "SendEmail", $rIp, "NEVER")
		If $LastSend == "NEVER" Then SendIt($IsEmail, $rip)
	EndIf
EndFunc

Func SendIt($To, $sIp)
	$IsSended = _INetSmtpMail("mail.amyfirewall.org", "dont reply", "abuse@amyfirewall.org", $IsEmail,"Ip '" &$rip "' was found in several client log files."&@CRLF&"Please stop this unothorized activities or a revange will be launched."&@CRLF&@CRLF&"THANKS")
	If $IsSended == "1" Then IniWrite("items.db", "SendEmail", $rIp, "1")
	; now, this IniWrite needs to be removed after One day
EndFunc

Func GetAbuseEmail($Ip)

	$Domain = TCPNameToIP("whois.arin.net");whois.arin.net  whois.internic.net  whois.ripe.net
	$Port = 43
	
	Global $recv, $aloop[500]

	$socket = TCPConnect($Domain, $Port)

	If $socket <> -1 Then
		TCPSend($socket, $IP & @CRLF)
  
		Do
			$recv &= TCPRecv($socket, 2048)
		Until @error

		$sRecv = StringSplit($recv,@CRLF)

		For $aloop = $sRecv[0] To 1 Step -1
		
			$aitem = $sRecv[$aloop]

			If StringInStr($aitem, '@') <> "0" Then 
				$tempSplit = StringSplit($aitem, ":")
				If $tempSplit[1] == "OrgAbuseEmail" Then 
					IniWrite("items.db", "abusedb", $Ip, $tempSplit[2])
					Exit
				EndIf
				
			EndIf
		Next
		TrayTip("error", "No Abuse email found for "&$Ip, 3, 2)
		Sleep(1000)
	TCPCloseSocket($socket)
	EndIf
EndFunc ;==> GetAbuseEmail

Func Analyze($aSocket, $aSource, $aChain)
	Local $aList[1000], $aRead[100]
	$aList = $aChain
	For $aLoop = $aList[0] To 0 Step -1
		
		$aItem = $aList[$aLoop] ; current item
		$aRead = IniRead("items.db", "uIp", $aItem, "NULL"); check if items was already reported
		
		If $aRead == "NULL" Then ; If no reports against this ip
			IniWrite("items.db", "uIp", $aItem, $aSocket) ; writing socketname as reporter
		Else ; else
			Local $aNewChain[100] ; create var
			$aNewChain = _ArrayAdd($aRead, $aSocket) ; adding current reporter to already known reporters list ...
			
			If $aNewChain <> $aRead Then; If NewChain is different as the old one
				$aTotalItemsInChain = $aNewChain[0] ; how many items are in the chain?
				
				If $aTotalItemsInChain < 10 Then ; if less than 10, just writing the new chain
					IniWrite("items.db", "uIp", $aItem, $aNewChain)
				Else; else
					If $aTotalItemsInChain > 20 Then NeedAction($aItem) ; If more than 20, then an attack is asked against '$aItem'
					If $aTotalItemsInChain < 20 Then SendMailToProvider($aItem) ; If less than 20, Sending a mail to provider
				EndIf
			EndIf
		EndIf
		
	Next
	TCPSend($aSocket, Encode($asocket, "500:OK:"))
EndFunc