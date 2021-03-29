;Filename: _WSA_TCPRecv-20140629.au3
;Date....: June 29, 2014

Opt("TrayIconDebug", 1)
Global $bWSA = True

#include-once
If Not TCPStartup() Then
	Exit MsgBox(8208, '', 'Error: TCPStartup' & @TAB, 5)
EndIf

Global Const $hWS2_32 = DllOpen(@WindowsDir & '\system32\ws2_32.dll')
If $hWS2_32 = -1 Then Exit

OnAutoItExitRegister('_WSA_CloseDLL')

Local Const $strIP = @IPAddress1
Local Const $nPort = 8091
;
Local Const $Connection = TCPListen($strIP, $nPort)
If @error Then
	_TCP_Client()
Else
	_TCP_Server()
EndIf
;
TCPShutdown()
Exit
;
Func _TCP_Client()
	Local $nSocket = _TCPConnect($strIP, $nPort)
	If @error Or ($nSocket < 1) Then Return

	TCPSend($nSocket, 'SEND_DATA_MARY')
	If @error Then
		TCPCloseSocket($nSocket)
		Return
	EndIf

	Local $nBytes = 0, $nError = 0, $string = ''

	Do
		Sleep(10)
		If $bWSA Then
			$string &= _WSA_TCPRecv($nSocket, 32)
		Else
			$string &= TCPRecv($nSocket, 32)
		EndIf
		$nError = @error
		$nBytes += @extended
	Until $nError

	TCPCloseSocket($nSocket)
	MsgBox(0, '[Client] - Error Return: ' & $nError & ' - Bytes Received: ' & $nBytes, $string)
EndFunc   ;==>_TCP_Client
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
			TCPSend($nSocket, $str)
		Case Else
	EndSwitch

	Sleep(100)
	TCPCloseSocket($nSocket)
	Sleep(100)
	MsgBox(8256, '[Server] - Command From Client', $string)
EndFunc   ;==>_TCP_Server

Func _WSA_CloseDLL()
	DllClose($hWS2_32)
EndFunc   ;==>_WSA_CloseDLL

Func _WSA_GetLastError()
    Local $aResult = DllCall($hWS2_32, 'int', 'WSAGetLastError')
    If @error Then
        Return SetError(-1, 0, -1); dll error
    Else
        Return SetError(0, 0, $aResult[0])
    EndIf
EndFunc
;
;======================================================================================
;#FUNCTION#...:
; Name........: _WSA_TCPRecv()
;.............:
; Dependencies: _WSA_GetLastError() and a handle to ws2_32.dll
;.............:
; @error......;  0 = no error
; ............: -1 = socket error
; ............: -2 = disconnected
; ............: -3 = dll error
;.............:
; @extended...; If @error = -1 Then @extended = WSA Error Code.
;............ : If @error = 0 Then @extended = number of bytes received.
;.............: Else @extended = 0.
;.............:
; Return......: If @error = 0 And @extended > 0 Then returns data.
;.............: Else returns blank.
;.............:
; Remarks.....: Link to WSA Error Codes:
; http://msdn.microsoft.com/en-us/library/windows/desktop/ms740668(v=vs.85).aspx
;======================================================================================
Func _WSA_TCPRecv($nSocket, $nMaxLen = 4096, $nBinaryMode = 0)
    ;[get queued bytes on socket]
    Local $aResult = DllCall($hWS2_32, 'int', 'ioctlsocket', 'int', $nSocket, 'long', 0x4004667F, 'uint*', 0); FIONREAD
    If @error Then
        Return SetError(-3, 0, ''); dll error
    ElseIf ($aResult[0] <> 0) Then
        Return SetError(-1, $aResult[0], ''); WSA Error. (@error=-1, @extended=WSAError, string='')
    ElseIf ($aResult[3] == 0) Then
        Return SetError(0, 0, ''); No data is queued on socket. (@error=0, @extended=0, string='')
    EndIf

    ;[get buffer type]
    If $nBinaryMode Then
        Local $tBuffer = DllStructCreate('byte[' & $nMaxLen & ']')
    Else
        Local $tBuffer = DllStructCreate('char buffer[' & $nMaxLen & ']')
    EndIf
    Local $pBuffer = DllStructGetPtr($tBuffer)

    ;[receive queued data]
    $aResult = DllCall($hWS2_32, 'int', 'recv', 'int', $nSocket, 'ptr', $pBuffer, 'int', $nMaxLen, 'int', 0)
    If @error Then
        $tBuffer = 0
        Return SetError(-3, 0, ''); dll error
    EndIf

    ;[check for WSA error]
    Local $nError = _WSA_GetLastError()
    If ($nError <> 0) Then
        $tBuffer = 0
        Return SetError(-1, $nError, ''); WSA Error. (@error=-1, @extended=WSAError, string='')
    EndIf

    ;[process results]
    Local $sData = ''
    Local $nBytes = $aResult[0]

    If ($nBytes <> '') And ($nBytes > -1) Then
        If $nBytes == 0 Then; disconnected (@error=-2, @extended=0, string='')
            $nError = -2
			MsgBox(262144, 'Debug line ~' & @ScriptLineNumber, 'Selection:' & @CRLF & '$nError' & @CRLF & @CRLF & 'Return:' & @CRLF & $nError & @CRLF & @CRLF & '@error:' & @CRLF & @error & @CRLF & @CRLF & '@extended:' & @CRLF & @extended & ' (0x' & Hex(@extended) & ')') ;### Debug MSGBOX
        Else; data received (@error=0, @extended=bytes, string=data)
            $sData = DllStructGetData($tBuffer, 1)
            If $nBinaryMode Then; extract binary data
                $sData = StringLeft($sData, ($nBytes * 2) + 2)
            Else; extract raw data
                $sData = StringLeft($sData, $nBytes)
            EndIf
        EndIf
    Else
        $nBytes = 0; no data received (@error=0, @extended=0, string='')
    EndIf

    $tBuffer = 0
    Return SetError($nError, $nBytes, $sData)
EndFunc
;
;
;======================================================================================
;#FUNCTION#
; Name........: _TCPConnect()
;
; This is a rewrite of the original code - all credits go to ProgAndy and JScript.
; Purpose: format is easier to debug and maintain.
;
; Original Link:
; http://www.autoitscript.com/forum/topic/127415-tcpconnect-sipaddr-iport-itimeout/
;..............:
; Description..: Attempts a socket connection with a timeout.
;..............:
; Dependencies.: _WSA_GetLastError() and a handle to ws2_32.dll
;..............:
; @error.......;  0 = no error - socket is returned in blocking mode
 ; ............: -1 = could not create socket
; .............: -2 = ip incorrect
; .............: -3 = could not get port
; .............: -4 = could not set blocking or non-blocking mode
; .............: -5 = could not connect
; .............: -6 = timed out
; .............: -7 = dll error
; .............:
; @extended....; WSA Error Code
; .............:
; Remarks......: Link to WSA Error Codes:
; http://msdn.microsoft.com/en-us/library/windows/desktop/ms740668(v=vs.85).aspx
;======================================================================================
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

    ;[set the socket to non-blocking mode for timeout]
    Local $aResult = DllCall($hWS2_32, 'int', 'ioctlsocket', 'int', $hSock, 'long', 0x8004667E, 'uint*', 1); FIONBIO, NON-BLOCKING
    If @error Then
        TCPCloseSocket($hSock)
        Return SetError(-7, 0, -1); dll error
    ElseIf ($aResult[0] <> 0) Then
        TCPCloseSocket($hSock)
        Return SetError(-4, _WSA_GetLastError(), -1); could not set non-blocking mode
    EndIf

    ;[set binding]
    Local $tSockAddr = DllStructCreate('short sin_family;ushort sin_port;ulong sin_addr;char sin_zero[8];')
    DllStructSetData($tSockAddr, 1, 2)
    DllStructSetData($tSockAddr, 2, $aPort[0])
    DllStructSetData($tSockAddr, 3, $aIP[0])
    Local $p1 = DllStructGetPtr($tSockAddr)
    Local $p2 = DllStructGetSize($tSockAddr)

    ;[attempt connect]
    $aResult = DllCall($hWS2_32, 'int', 'connect', 'int', $hSock, 'ptr', $p1, 'int', $p2)
    If @error Then
        TCPCloseSocket($hSock)
        Return SetError(-7, 0, -1); dll error
    ElseIf ($aResult[0] <> 0) And (_WSA_GetLastError() <> 10035) Then; (10035 = non-blocking mode (non-fatal error))
        TCPCloseSocket($hSock)
        Return SetError(-5, _WSA_GetLastError(), -1); could not connect
    EndIf

    ;[set timeout]
    Local $t1 = DllStructCreate('uint;int')
    DllStructSetData($t1, 1, 1)
    DllStructSetData($t1, 2, $hSock)
    $p1 = DllStructGetPtr($t1)

    Local $t2 = DllStructCreate('long;long')
    DllStructSetData($t2, 1, Floor($iTimeOut / 1000))
    DllStructSetData($t2, 2, Mod($iTimeOut, 1000))
    $p2 = DllStructGetPtr($t2)

    ;[init timeout]
    $aResult = DllCall($hWS2_32, 'int', 'select', 'int', $hSock, 'ptr', $p1, 'ptr', $p1, 'ptr', 0, 'ptr', $p2)
    If @error Then
        TCPCloseSocket($hSock)
        Return SetError(-7, 0, -1); dll error
    ElseIf ($aResult[0] == 0) Then
        TCPCloseSocket($hSock)
        Return SetError(-6, _WSA_GetLastError(), -1); timed out
    EndIf

    ;[set the socket to blocking mode]
    Local $aResult = DllCall($hWS2_32, 'int', 'ioctlsocket', 'int', $hSock, 'long', 0x8004667E, 'uint*', 0); FIONBIO, BLOCKING
    If @error Then
        TCPCloseSocket($hSock)
        Return SetError(-7, 0, -1); dll error
    ElseIf ($aResult[0] <> 0) Then
        TCPCloseSocket($hSock)
        Return SetError(-4, _WSA_GetLastError(), -1); could not set blocking mode
    EndIf

    Return SetError(0, 0, $hSock)
EndFunc
;
;
;==============================
;
;       example function
;
;==============================
Func _TCPRecv_Example($nSocket)
    Local $nExtended, $nError, $sRecv
    Local $nTotalBytes = 0, $sData = ''

    For $i = 1 To 100; <-- serves as a timeout scheme and will exit loop if it reaches 100. (approximately 1500 ms)
        $sRecv = _WSA_TCPRecv($nSocket, 16384); the majority of web server sends is 8192 bytes, but we'll double it for a little extra.
        $nError = @error
        $nExtended = @extended

        If $nError Then
            ExitLoop
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

    TCPCloseSocket($nSocket); close socket

    If $nError Then; do something with error
        Return SetError($nError, $nExtended, '')
    ElseIf $nTotalBytes Then; do something with total bytes and resulting data
        Return SetError(0, $nTotalBytes, $sData)
    Else; timed out completely
        Return SetError(-100, 0, '')
    EndIf
EndFunc
;
