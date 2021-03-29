; Filename: _WSA_TCPRecv-20140703.au3
; Version.: AutoIt v3.3.8.1+
; Date....: July 03, 2014

Opt("TrayIconDebug", 1)

Global $bWSA = True

If Not TCPStartup() Then
    Exit MsgBox(8208, '', 'Error: TCPStartup' & @TAB, 5)
EndIf

Global Const $hWS2_32 = DllOpen(@WindowsDir & '\system32\ws2_32.dll')
If $hWS2_32 = -1 Then Exit

OnAutoItExitRegister('_WSA_ShutDown')

Global Const $strIP = @IPAddress1
Global Const $nPort = 8091

Global Const $Connection = TCPListen($strIP, $nPort)
If @error Then
    _TCP_Client()
Else
    _TCP_Server()
EndIf
Exit
;
Func _TCP_Client()
    Local $nSocket = _TCPConnect($strIP, $nPort)
    If @error Or ($nSocket < 1) Then Return

    _WSA_TCPSend($nSocket, 'SEND_DATA_MARY')
    If @error Then
        TCPCloseSocket($nSocket)
        Return
    EndIf

    Local $nBytes = 0, $nError = 0, $nWSAError = 0, $string = ''

    Do
        Sleep(10)

        If $bWSA Then
            $string &= _WSA_TCPRecv($nSocket, 32)
        Else
            $string &= TCPRecv($nSocket, 32)
        EndIf

        $nError = @error
        If $nError Then
            $nWSAError = @extended
        Else
            $nBytes += @extended
        EndIf
    Until $nError

    Local $sResult = ''
    $sResult &= 'AutoIt v' & @AutoItVersion & @CRLF & @CRLF
    $sResult &= '@error: ' & $nError & @CRLF
    $sResult &= 'WSAError: ' & $nWSAError & @CRLF
    $sResult &= 'Bytes Received: ' & $nBytes & @CRLF & @CRLF
    $sResult &= $string & @CRLF

    TCPCloseSocket($nSocket)
    MsgBox(0, '[Client] - Results From Server', $sResult)
EndFunc
;
Func _TCP_Server()
    Local $nSocket, $string = ''

    MsgBox(8256, 'Status', 'Server Online' & @TAB, 1)

    Do
        Sleep(100)
        $nSocket = TCPAccept($Connection)
    Until $nSocket > -1

    Do
        Sleep(10)
        If $string Then ExitLoop

        If $bWSA Then
            $string &= _WSA_TCPRecv($nSocket, 32)
        Else
            $string &= TCPRecv($nSocket, 32)
        EndIf
    Until @error

    Switch $string
        Case 'SEND_DATA_MARY'
            Local $str = 'Mary had a little lamb, whose fleece was white as snow;' & @CRLF
            $str &= 'and everywhere that Mary went, the lamb was sure to go.' & @CRLF
            _WSA_TCPSend($nSocket, $str)
        Case Else
    EndSwitch

    Sleep(100)
    TCPCloseSocket($nSocket)
    Sleep(100)
    MsgBox(8256, '[Server] - Command From Client', $string)
EndFunc
;
;======================================================================================
;#FUNCTION#....:
; Name.........: _WSA_TCPRecv()
;..............:
; Version......: AutoIt v3.3.8.1+
;..............:
; Dependencies.: _WSA_GetLastError() and a handle to ws2_32.dll
;..............:
; @error.......;  0 no error.
;..............: -1 socket error.
;..............: -2 disconnected.
;..............: -3 dll error.
;..............:
; @extended....; If @error Then returns a WSA Error Code.
;............. : Else returns number of bytes received.
;..............:
; Return Value.: If Not @error And @extended > 0 Then returns data.
;..............: Else returns blank.
;..............:
; Remarks......: Link to WSA Error Codes:
; http://msdn.microsoft.com/en-us/library/windows/desktop/ms740668(v=vs.85).aspx
;======================================================================================
Func _WSA_TCPRecv(ByRef $nSocket, $nMaxLen = 4096, $nBinaryMode = 0)
    ;[set non-blocking mode]
    Local $aResult = DllCall($hWS2_32, 'int', 'ioctlsocket', 'int', $nSocket, 'long', 0x8004667E, 'ulong*', 1)
    If @error Then
        Return SetError(-3, 0, ''); dll error
    ElseIf ($aResult[0] <> 0) Then
        Return SetError(-1, _WSA_GetLastError(), ''); socket error
    EndIf; WSAGetLastError will return socket errors with this statement (example: 10038-invalid socket).

    ;[get buffer type]
    If $nBinaryMode Then
        Local $tBuffer = DllStructCreate('byte[' & $nMaxLen & ']')
    Else
        Local $tBuffer = DllStructCreate('char buffer[' & $nMaxLen & ']')
    EndIf

    ;[receive data]
    $aResult = DllCall($hWS2_32, 'int', 'recv', 'int', $nSocket, 'struct*', $tBuffer, 'int', $nMaxLen, 'int', 0)
    If @error Then
        Return SetError(-3, _WSA_GetLastError(), ''); dll error
    EndIf

    ;[check WSA error]
    Local $nError = _WSA_GetLastError()
    If ($nError <> 0) And ($nError <> 10035) Then; <- WSAEWOULDBLOCK (non-blocking socket (non-fatal error))
        Return SetError(-1, $nError, ''); socket error
    EndIf

    Local $nBytes = $aResult[0]

    ;[set blocking mode]
    $aResult = DllCall($hWS2_32, 'int', 'ioctlsocket', 'int', $nSocket, 'long', 0x8004667E, 'ulong*', 0)
    If @error Then
        Return SetError(-3, 0, ''); dll error
    ElseIf ($aResult[0] <> 0) Then
        Return SetError(-1, _WSA_GetLastError(), ''); socket error
    EndIf

    Local $sData = ''
    $nError = 0

    ;[process results]
    If ($nBytes > 0) Then; data received
        $sData = DllStructGetData($tBuffer, 1)
        If $nBinaryMode Then; extract binary data
            $sData = StringLeft($sData, ($nBytes * 2) + 2)
        Else; extract raw data
            $sData = StringLeft($sData, $nBytes)
        EndIf
    ElseIf ($nBytes == 0) Then; disconnected
        $nError = -2
    Else
        $nBytes = 0; no data received
    EndIf

    Return SetError($nError, $nBytes, $sData)
EndFunc
;
;======================================================================================
;#FUNCTION#....:
; Name.........: _WSA_TCPSend()
;..............:
; Version......: AutoIt v3.3.8.1+
;..............:
; Dependencies.: _WSA_GetLastError() and a handle to ws2_32.dll
;..............:
; @error.......;  0 no error.
;..............: -1 socket error.
;..............: -2 disconnected.
;..............: -3 dll error.
;..............:
; @extended....; If @error Then @extended returns a WSA Error Code.
;............. : Else returns 0.
;..............:
; Return Value.: If Not @error Then returns number of bytes sent.
;..............: Else returns 0.
;..............:
; Remarks......: Link to WSA Error Codes:
; http://msdn.microsoft.com/en-us/library/windows/desktop/ms740668(v=vs.85).aspx
;======================================================================================
Func _WSA_TCPSend(ByRef $nSocket, $sData)
    ;[set non-blocking mode]
    Local $aResult = DllCall($hWS2_32, 'int', 'ioctlsocket', 'int', $nSocket, 'long', 0x8004667E, 'ulong*', 1)
    If @error Then
        Return SetError(-3, 0, 0); dll error
    ElseIf ($aResult[0] <> 0) Then
        Return SetError(-1, _WSA_GetLastError(), 0); socket error
    EndIf; WSAGetLastError will return socket errors with this statement (ie: 10038-invalid socket).

    Local $nBytes = StringLen($sData)
    Local $tBuffer = DllStructCreate('char buffer[' & $nBytes & ']')
    DllStructSetData($tBuffer, 1, $sData)

    ;[send data]
    $aResult = DllCall($hWS2_32, 'int', 'send', 'int', $nSocket, 'struct*', $tBuffer, 'int', $nBytes, 'int', 0)
    If @error Then
        Return SetError(-3, 0, 0); dll error
    EndIf

    ;[check WSA error]
    Local $nError = _WSA_GetLastError()
    If ($nError <> 0) And ($nError <> 10035) Then; <- WSAEWOULDBLOCK (non-blocking socket (non-fatal error))
        Return SetError(-1, $nError, 0); socket error
    EndIf

    $nBytes = $aResult[0]

    ;[set blocking mode]
    $aResult = DllCall($hWS2_32, 'int', 'ioctlsocket', 'int', $nSocket, 'long', 0x8004667E, 'ulong*', 0)
    If @error Then
        Return SetError(-3, 0, 0); dll error
    ElseIf ($aResult[0] <> 0) Then
        Return SetError(-1, _WSA_GetLastError(), 0); socket error
    EndIf

    $nError = 0

    ;[process results]
    If ($nBytes > 0) Then; bytes sent
        ; pass through
    ElseIf ($nBytes == 0) Then; disconnected
        $nError = -2
    Else
        $nBytes = 0; no bytes sent
    EndIf

    Return SetError($nError, 0, $nBytes)
EndFunc
;
;====================================================================================
;#FUNCTION#
; Name........: _TCPConnect()
;
; This is a rewrite of the original code - all credits go to ProgAndy and JScript.
; Purpose: format is easier to debug and maintain.
;
; Original Link:
; http://www.autoitscript.com/forum/topic/127415-tcpconnect-sipaddr-iport-itimeout/
;..............:
; Version......: AutoIt v3.3.8.1+
;..............:
; Description..: Attempts a socket connection with a timeout.
;..............:
; Dependencies.: _WSA_GetLastError() and a handle to ws2_32.dll
;..............:
; @error.......;  0 no error - socket is returned in blocking mode.
;..............: -1 could not create socket.
;..............: -2 ip incorrect.
;..............: -3 could not get port.
;..............: -4 could not set blocking or non-blocking mode.
;..............: -5 could not connect.
;..............: -6 timed out.
;..............: -7 dll error.
; .............:
; @extended....; If @error Then returns a WSA Error Code.
;..............: Else returns 0.
;..............:
; Return Value.: If @error Then returns -1.
;..............: Else returns socket.
;..............:
; Remarks......: Link to WSA Error Codes:
; http://msdn.microsoft.com/en-us/library/windows/desktop/ms740668(v=vs.85).aspx
;====================================================================================
Func _TCPConnect($sIPAddr, $iPort, $iTimeOut = 3000); <- default: 3 seconds
    ;[create socket]
    Local $hSock = DllCall($hWS2_32, 'uint', 'socket', 'int', 2, 'int', 1, 'int', 6); AF_INET, SOCK_STREAM, IPPROTO_TCP
    If @error Then
        Return SetError(-7, 0, -1); dll error
    ElseIf ($hSock[0] == -1) Or ($hSock[0] == 4294967295) Then; 4294967295 = 0xFFFFFFFF
        Return SetError(-1, _WSA_GetLastError(), -1); could not create socket
    EndIf
    $hSock = $hSock[0]

    ;[get ip handle]
    Local $aIP = DllCall($hWS2_32, 'ulong', 'inet_addr', 'str', $sIPAddr)
    If @error Then
        TCPCloseSocket($hSock)
        Return SetError(-7, 0, -1); dll error
    ElseIf ($aIP[0] == -1) Or ($aIP[0] == 4294967295) Then
        TCPCloseSocket($hSock)
        Return SetError(-2, _WSA_GetLastError(), -1); ip incorrect
    EndIf

    ;[get port handle]
    Local $aPort = DllCall($hWS2_32, 'ushort', 'htons', 'ushort', $iPort)
    If @error Then
        TCPCloseSocket($hSock)
        Return SetError(-7, 0, -1); dll error
    ElseIf ($aPort[0] < 1) Then
        TCPCloseSocket($hSock)
        Return SetError(-3, _WSA_GetLastError(), -1); could not get port
    EndIf

    ;[set socket to non-blocking mode for timeout]
    Local $aResult = DllCall($hWS2_32, 'int', 'ioctlsocket', 'int', $hSock, 'long', 0x8004667E, 'ulong*', 1); FIONBIO, NON-BLOCKING
    If @error Then
        TCPCloseSocket($hSock)
        Return SetError(-7, 0, -1); dll error
    ElseIf ($aResult[0] <> 0) Then
        TCPCloseSocket($hSock)
        Return SetError(-4, _WSA_GetLastError(), -1); socket error (could not set non-blocking mode)
    EndIf

    ;[set binding]
    Local $tSockAddr = DllStructCreate('short sin_family;ushort sin_port;ulong sin_addr;char sin_zero[8];')
    DllStructSetData($tSockAddr, 1, 2)
    DllStructSetData($tSockAddr, 2, $aPort[0])
    DllStructSetData($tSockAddr, 3, $aIP[0])

    ;[attempt connect]
    $aResult = DllCall($hWS2_32, 'int', 'connect', 'int', $hSock, 'struct*', $tSockAddr, 'int', DllStructGetSize($tSockAddr))
    If @error Then
        TCPCloseSocket($hSock)
        Return SetError(-7, 0, -1); dll error
    ElseIf ($aResult[0] <> 0) And (_WSA_GetLastError() <> 10035) Then; <- WSAEWOULDBLOCK - non-blocking socket (no data queued on socket - non-fatal error)
        TCPCloseSocket($hSock)
        Return SetError(-5, _WSA_GetLastError(), -1); could not connect
    EndIf

    ;[set timeout]
    Local $t1 = DllStructCreate('uint;int')
    DllStructSetData($t1, 1, 1)
    DllStructSetData($t1, 2, $hSock)

    Local $t2 = DllStructCreate('long;long')
    DllStructSetData($t2, 1, Floor($iTimeOut / 1000))
    DllStructSetData($t2, 2, Mod($iTimeOut, 1000))

    ;[init timeout]
    $aResult = DllCall($hWS2_32, 'int', 'select', 'int', $hSock, 'struct*', $t1, 'struct*', $t1, 'ptr', 0, 'struct*', $t2)
    If @error Then
        TCPCloseSocket($hSock)
        Return SetError(-7, 0, -1); dll error
    ElseIf ($aResult[0] == 0) Then
        TCPCloseSocket($hSock)
        Return SetError(-6, _WSA_GetLastError(), -1); timed out
    EndIf

    ;[set socket to blocking mode again]
    Local $aResult = DllCall($hWS2_32, 'int', 'ioctlsocket', 'int', $hSock, 'long', 0x8004667E, 'ulong*', 0); FIONBIO, BLOCKING
    If @error Then
        TCPCloseSocket($hSock)
        Return SetError(-7, 0, -1); dll error
    ElseIf ($aResult[0] <> 0) Then
        TCPCloseSocket($hSock)
        Return SetError(-4, _WSA_GetLastError(), -1); socket error (could not set blocking mode)
    EndIf

    Return SetError(0, 0, $hSock)
EndFunc
;
Func _WSA_GetLastError()
    Local $aResult = DllCall($hWS2_32, 'int', 'WSAGetLastError')
    If @error Then
        Return SetError(-1, 0, -1); dll error
    Else
        Return SetError(0, 0, $aResult[0])
    EndIf
EndFunc
;
Func _WSA_ShutDown()
    DllClose($hWS2_32)
    TCPShutdown()
    Exit
EndFunc
;
;==============================
;
;    recv example function
;
;==============================
Func _TCPRecv_Example(ByRef $nSocket)
    Local $nExtended, $nError, $sRecv
    Local $nTotalBytes = 0, $sData = ''

    For $i = 1 To 100; <-- serves as a timeout scheme and will exit loop if it reaches 100. (approximately ~1500 ms)
        $sRecv = _WSA_TCPRecv($nSocket, 16384); the majority of web server sends is 8192 bytes, but we'll double it for a little extra.
        $nError = @error
        $nExtended = @extended

        If $nError Then
            Return SetError($nError, $nExtended, '')
        ElseIf $nExtended Then; do something with data
            $nTotalBytes += $nExtended; add received bytes to total bytes
            $sData &= $sRecv; gather incoming data
            $i = 0; reset timeout
        Else; no data received
            If ($i > 30) And $nTotalBytes Then; accelerate the timeout when no further data is received
                ExitLoop
            EndIf
        EndIf

        Sleep(10); part cpu breather and part timeout scheme
    Next

    If $nTotalBytes Then; do something with total bytes and resulting data
        Return SetError(0, $nTotalBytes, $sData)
    Else
        Return SetError(1, 0, ''); timed out
    EndIf
EndFunc
;
;==============================
;
;    send example function
;
;==============================
Func _TCPSend_Example(ByRef $nSocket, $sData)
    Local $nTotalBytes = StringLen($sData)
    Local $nExtended, $nError, $nBytes

    For $i = 1 To 100; <-- serves as a timeout scheme and will exit loop if it reaches 100. (approximately ~1500 ms)
        $nBytes = _WSA_TCPSend($nSocket, $sData)
        $nError = @error
        $nExtended = @extended

        If $nError Then
            Return SetError($nError, $nExtended, 0)
        ElseIf ($nBytes == $nTotalBytes) Then
            Return SetError(0, 0, 1); success
        ElseIf ($nBytes > 0) Then
            Return SetError(2, 0, 0); failed to send total byte count. (partial send)
        Else
            ; pass through till timeout or bytes sent.
        EndIf

        Sleep(10); part cpu breather and part timeout scheme
    Next

    Return SetError(1, 0, 0); timed out
EndFunc
;

