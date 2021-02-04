
	FileDelete("c:\google.html")
;	$sResponse = _HTTPGet("10.8.30.12", "/")
	$sResponse = _HTTPGet("www.google.com", "/")
	ConsoleWrite( "CLIENT: [" & "]" & @crlf & "-----------------------------------------------------------------------------------" & @crlf)
	Exit

Func _HTTPGet($sHost, $sPage)

    Local $iSocket = _HTTPConnect($sHost)
    If @error Then Return SetError(1, 0, "")

;	$sPage = "/fmi/xml/fmresultset.xml?-db=Call%20Center%20One&-lay=IncomingCallRoutes&InternalCallRoute=110&-find"
    Local $sCommand = "GET " & $sPage & " HTTP/1.1" & @CRLF
    $sCommand &= "Host: " & $sHost & @CRLF
    $sCommand &= "User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.8.1) Gecko/20061010 Firefox/2.0" & @CRLF
    $sCommand &= "Referer: " & $sHost & @CRLF
    $sCommand &= "Connection: close" & @CRLF & @CRLF

    Local $BytesSent = TCPSend($iSocket, $sCommand)
    If $BytesSent = 0 Then Return SetError(2, @error, 0)

	$FileHandle=FileOpen("c:\google.html",2)
	If $FileHandle = -1 Then
		MsgBox(64,"File Open Error", $FileHandle)
	EndIf

    Local $sRecv = "", $sCurrentRecv, $CCBTest
    While 1
;		$sCurrentRecv = TCPRecv($iSocket,16);	Receive 16 bytes, binary
;		$sCurrentRecv = TCPRecv($iSocket,32);	Receive 16 bytes, binary
;		$sCurrentRecv = TCPRecv($iSocket,64);	Receive 16 bytes, binary
;		$sCurrentRecv = TCPRecv($iSocket,128);	Receive 16 bytes, binary
;		$sCurrentRecv = TCPRecv($iSocket,256);	Receive 16 bytes, binary
;		$sCurrentRecv = TCPRecv($iSocket,512);	Receive 16 bytes, binary
;		$sCurrentRecv = TCPRecv($iSocket,1024);	Receive 16 bytes, binary
;		$sCurrentRecv = TCPRecv($iSocket,2048);	Receive 16 bytes, binary
;		$sCurrentRecv = TCPRecv($iSocket,4096);	Receive 16 bytes, binary
;		$sCurrentRecv = TCPRecv($iSocket,8192);	Receive 16 bytes, binary
;       $sCurrentRecv = TCPRecv($iSocket,16384);	Receive 16 bytes, binary
		$sCurrentRecv = TCPRecv($iSocket,32768);	Receive 16 bytes, binary
        If @error <> 0 Then ExitLoop
		ConsoleWrite ("1-->" & $sCurrentRecv & "<--" & @crlf)
        If $sCurrentRecv <> "" Then
			If StringInStr($sCurrentRecv,@CRLF)>0 THen msgbox (64,"Found:" & StringInStr($sCurrentRecv,@CRLF) ,$sCurrentRecv)
			StringReplace ( $sCurrentRecv, "/intl/en_ALL/images/logo.gif", "http://www.google.com/intl/en_ALL/images/logo.gif")
			FileWrite($FileHandle,$sCurrentRecv)
		EndIf

    WEnd
	FileClose($FileHandle)
    _HTTPShutdown($iSocket)

    Return $sRecv
EndFunc

Func _HTTPConnect($sHost, $iPort=80)
    TCPStartup()

    Local $sName_To_IP = TCPNameToIP($sHost)
    Local $iSocket = TCPConnect($sName_To_IP, $iPort)

    If $iSocket = -1 Then
        TCPCloseSocket($iSocket)
        Return SetError(1, 0, "")
    EndIf

    Return $iSocket
EndFunc

Func _HTTPShutdown($iSocket)
    TCPCloseSocket($iSocket)
    TCPShutdown()
EndFunc
