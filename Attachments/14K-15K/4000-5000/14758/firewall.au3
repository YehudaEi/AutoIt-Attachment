;firewall

TcpStartup()

$logfile = 'firewall.log'

$from = 1
$to = 3000

Dim $portsocket[$to+1]

While 1
	For $x = $from To $to
		$portsocket[$x] = TcpListen(@IPAddress1, $x)
		If $portsocket[$x] = -1 Then 
			$log = FileOpen($logfile,1)
			FileWrite($log,@MDAY&'/'&@MON&'-'&@YEAR&' '&@HOUR&':'&@MIN&':'&@SEC&' '&'Error trying to listen on port: '&$x&''&@CRLF)
			FileClose($log)
			;ConsoleWrite('error opening port: '&$x&@CRLF)
		EndIf
	Next
	
	$log = FileOpen($logfile,1)
	FileWrite($log,@MDAY&'/'&@MON&'-'&@YEAR&' '&@HOUR&':'&@MIN&':'&@SEC&' '&'Firewall is now running. '&@CRLF)
	FileClose($log)
	
	
	Do
		For $x = $from To $to
			$ConnectedSocket = TCPAccept($portsocket[$x])
			If $ConnectedSocket <> -1 Then
				TCPSend($ConnectedSocket,'Port '&$x&' is blocked.')
				
				$log = FileOpen($logfile,1)
				FileWrite($log,@MDAY&'/'&@MON&'-'&@YEAR&' '&@HOUR&':'&@MIN&':'&@SEC&' '&SocketToIP($ConnectedSocket)&' tried to connect on port: '&$x&' connection refused.'&@CRLF)
				FileClose($log)
				
				;ConsoleWrite('Kicked atempt to connect on port: '&$x&' from ip: '&SocketToIP($ConnectedSocket)&@CRLF)
				TCPCloseSocket($ConnectedSocket)
				$ConnectedSocket = -1
			EndIf
		Next
	Until $ConnectedSocket <> -1
WEnd

Func SocketToIP($SHOCKET)
    Local $sockaddr = DLLStructCreate("short;ushort;uint;char[8]")

    Local $aRet = DLLCall("Ws2_32.dll","int","getpeername","int",$SHOCKET, _
            "ptr",DLLStructGetPtr($sockaddr),"int_ptr",DLLStructGetSize($sockaddr))
    If Not @error And $aRet[0] = 0 Then
        $aRet = DLLCall("Ws2_32.dll","str","inet_ntoa","int",DLLStructGetData($sockaddr,3))
        If Not @error Then $aRet = $aRet[0]
    Else
        $aRet = 0
    EndIf

    $sockaddr = 0

    Return $aRet
EndFunc