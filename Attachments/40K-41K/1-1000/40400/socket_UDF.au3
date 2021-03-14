#include-once
; Some socket functions
; funkey 2013.03.12

Global Const $tagIN_ADDR = "ulong S_addr;"
Global Const $tagSockAddr = "USHORT sa_family;char sa_data[14]"
Global Const $tagSockAddr_In = "short sin_family;USHORT sin_port;ULONG sin_addr;char sin_zero[8]"
Global Const $tagTimeVal = "long tv_sec;long tv_usec"
Global Const $tagAddrInfo = "int ai_flags;int ai_family;int ai_socktype;int ai_protocol;uint ai_addrlen;ptr ai_canonname;ptr ai_addr;ptr ai_next"

Global Const $AF_UNSPEC = 0
Global Const $AF_UNIX = 1
Global Const $AF_INET = 2
Global Const $AF_IMPLINK = 3
Global Const $AF_PUP = 4
Global Const $AF_CHAOS = 5
Global Const $AF_IPX = 6
Global Const $AF_NS = 6
Global Const $AF_ISO = 7
Global Const $AF_OSI = $AF_ISO
Global Const $AF_ECMA = 8
Global Const $AF_DATAKIT = 9
Global Const $AF_CCITT = 10
Global Const $AF_SNA = 11
Global Const $AF_DECnet = 12
Global Const $AF_DLI = 13
Global Const $AF_LAT = 14
Global Const $AF_HYLINK = 15
Global Const $AF_APPLETALK = 16
Global Const $AF_NETBIOS = 17
Global Const $AF_VOICEVIEW = 18
Global Const $AF_FIREFOX = 19
Global Const $AF_UNKNOWN1 = 20
Global Const $AF_BAN = 21
Global Const $AF_ATM = 22
Global Const $AF_INET6 = 23

Global Const $SOCKET_ERROR = -1

Global Const $SOCK_STREAM = 1
Global Const $SOCK_DGRAM = 2
Global Const $SOCK_RAW = 3
Global Const $SOCK_RDM = 4
Global Const $SOCK_SEQPACKET = 5

Global Const $IPPROTO_IP = 0
Global Const $IPPROTO_ICMP = 1
Global Const $IPPROTO_IGMP = 2
Global Const $IPPROTO_GGP = 3
Global Const $IPPROTO_TCP = 6
Global Const $IPPROTO_PUP = 12
Global Const $IPPROTO_UDP = 17
Global Const $IPPROTO_IDP = 22
Global Const $IPPROTO_ND = 77
Global Const $IPPROTO_RAW = 255

Global Const $SOL_SOCKET = 0xFFFF

;SOL_SOCKET Socket Options
;http://msdn.microsoft.com/en-us/library/windows/desktop/ms740532(v=vs.85).aspx
Global Const $IP_OPTIONS = 1
Global Const $SO_DEBUG = 1
Global Const $SO_ACCEPTCONN = 2
Global Const $SO_REUSEADDR = 4
Global Const $SO_KEEPALIVE = 8
Global Const $SO_DONTROUTE = 16
Global Const $SO_BROADCAST = 32
Global Const $SO_USELOOPBACK = 64
Global Const $SO_LINGER = 128
Global Const $SO_OOBINLINE = 256
;~ Global Const $SO_DONTLINGER	(u_int)(~SO_LINGER)
Global Const $SO_SNDBUF = 0x1001
Global Const $SO_RCVBUF = 0x1002
Global Const $SO_SNDLOWAT = 0x1003
Global Const $SO_RCVLOWAT = 0x1004
Global Const $SO_SNDTIMEO = 0x1005
Global Const $SO_RCVTIMEO = 0x1006
Global Const $SO_ERROR = 0x1007
Global Const $SO_TYPE = 0x1008

Global Const $FIONBIO = 0x8004667E
Global Const $FIONREAD = 0x4004667F
Global Const $FIOASYNC = 0x8004667D
Global Const $SIOCSHIWAT = 0x80047300
Global Const $SIOCGHIWAT = 0x80047301
Global Const $SIOCSLOWAT = 0x80047302
Global Const $SIOCGLOWAT = 0x80047303
Global Const $SIOCATMARK = 0x40047307


Global $hDLL_WS2_32 = 0

Func _WSAStartup()
	If $hDLL_WS2_32 = 0 Then
		$hDLL_WS2_32 = DllOpen("ws2_32.dll")
		If $hDLL_WS2_32 = -1 Then
			$hDLL_WS2_32 = 0
			Return 0
		EndIf
		If TCPStartup() = 0 Then ;TCPStartup() is equal to WSAStartup function
			DllClose($hDLL_WS2_32)
			$hDLL_WS2_32 = 0
			Return 0
		EndIf
	EndIf
	Return 1
EndFunc   ;==>_WSAStartup

Func _WSACleanup()
	If $hDLL_WS2_32 <> 0 Then
		TCPShutdown() ;TCPShutdown() is equal to WSACleanup function
		DllClose($hDLL_WS2_32)
		$hDLL_WS2_32 = 0
	EndIf
	Return 1
EndFunc   ;==>_WSACleanup


Func _setsockopt($iSocket, $iLevel, $iOptName, $tOptVal)
	Local $iOptLen = DllStructGetSize($tOptVal)
	Local $aRet = DllCall($hDLL_WS2_32, "int", "setsockopt", "uint", $iSocket, "int", $iLevel, "int", $iOptName, "struct*", $tOptVal, "int", $iOptLen)
	Return $aRet[0]
EndFunc   ;==>_setsockopt

Func _getsockopt($iSocket, $iLevel, $iOptName, ByRef $tOptVal)
	Local $iOptLen = DllStructGetSize($tOptVal)
	Local $aRet = DllCall($hDLL_WS2_32, "int", "setsockopt", "uint", $iSocket, "int", $iLevel, "int", $iOptName, "struct*", $tOptVal, "int", $iOptLen)
	Return $aRet[0]
EndFunc   ;==>_getsockopt

Func _socket($AF, $SocketType, $Protocol) ; AF_INET, SOCK_STREAM, IPPROTO_TCP
	Local $aRet = DllCall($hDLL_WS2_32, "int", "socket", "int", $AF, "int", $SocketType, "int", $Protocol)
	Return $aRet[0]
EndFunc   ;==>_socket

Func _closesocket($iSocket)
	Local $aRet = DllCall($hDLL_WS2_32, "int", "closesocket", "UINT", $iSocket)
	Return $aRet[0]
EndFunc   ;==>_closesocket

Func _bind($iSocket, $sIP, $iPort)
	Local $tSockAddr_In = DllStructCreate($tagSockAddr_In)
	Local $pSockAddr_In = DllStructGetPtr($tSockAddr_In)
	Local $iSizeSockAddr_In = DllStructGetSize($tSockAddr_In)

	DllStructSetData($tSockAddr_In, "sin_family", $AF_INET)
	DllStructSetData($tSockAddr_In, "sin_port", _htons($iPort))
	DllStructSetData($tSockAddr_In, "sin_addr", _inet_addr($sIP))

	Local $aRet = DllCall($hDLL_WS2_32, "int", "bind", "UINT", $iSocket, "struct*", $pSockAddr_In, "int", $iSizeSockAddr_In)
	Return $aRet[0]
EndFunc   ;==>_bind

Func _connect($iSocket, $sIP, $iPort)
	Local $tSockAddr_In = DllStructCreate($tagSockAddr_In)
	Local $iSizeSockAddr_In = DllStructGetSize($tSockAddr_In)

	DllStructSetData($tSockAddr_In, "sin_family", $AF_INET)
	DllStructSetData($tSockAddr_In, "sin_port", _htons($iPort))
	DllStructSetData($tSockAddr_In, "sin_addr", _inet_addr($sIP))

	Local $aRet = DllCall($hDLL_WS2_32, "int", "connect", "UINT", $iSocket, "struct*", $tSockAddr_In, "int", $iSizeSockAddr_In)
	Return $aRet[0]
EndFunc   ;==>_connect


Func _send($iSocket, ByRef $tBuffer, $iFlags = 0)
	Local $tSize = DllStructGetSize($tBuffer)

	Local $aRet = DllCall($hDLL_WS2_32, "int", "send", "int", $iSocket, "struct*", $tBuffer, "int", $tSize, "int", $iFlags)
	Return $aRet[0]
EndFunc   ;==>_send

Func _recv($iSocket, ByRef $tBuffer, $iFlags = 0)
	Local $tSize = DllStructGetSize($tBuffer)

	Local $aRet = DllCall($hDLL_WS2_32, "int", "recv", "uint", $iSocket, "struct*", $tBuffer, "int", $tSize, "int", $iFlags)
	Return $aRet[0]
EndFunc   ;==>_recv

Func _inet_addr($sIP)
	Local $aRet = DllCall($hDLL_WS2_32, "ULONG", "inet_addr", "str", $sIP)
	Return $aRet[0]
EndFunc   ;==>_inet_addr

Func _inet_ntoa($pIn_Addr)
	Local $aRet = DllCall($hDLL_WS2_32, "str", "inet_ntoa", "ptr", $pIn_Addr)
	Return $aRet[0]
EndFunc   ;==>_inet_ntoa

;host byte order to network byte order
Func _htons($iPort)
	Local $aRet = DllCall($hDLL_WS2_32, "USHORT", "htons", "USHORT", $iPort)
	Return $aRet[0]
EndFunc   ;==>_htons

;network byte order to host byte order
Func _ntohs($iNetShort)
	Local $aRet = DllCall($hDLL_WS2_32, "USHORT", "ntohs", "USHORT", $iNetShort)
	Return $aRet[0]
EndFunc   ;==>_ntohs

Func _WSAGetLastError()
	Local $aRet = DllCall($hDLL_WS2_32, "int", "WSAGetLastError")
	Return $aRet[0]
EndFunc   ;==>_WSAGetLastError


Func _GetLocalPort($iSocket)
	;funkey
	Local $tagIN_ADDR = "ulong S_addr;"
	Local $tagSockAddr_In = "short sin_family;ushort sin_port;ptr sin_addr;char sin_zero[8];"
	Local $tIn_Addr = DllStructCreate($tagIN_ADDR)
	Local $tName = DllStructCreate($tagSockAddr_In)
	DllStructSetData($tName, "sin_addr", DllStructGetPtr($tIn_Addr))

	Local $aRes = DllCall($hDLL_WS2_32, "int", "getsockname", "uint", $iSocket, "struct*", $tName, "int*", 512)
	Local $aRes2 = DllCall($hDLL_WS2_32, "ushort", "ntohs", "ushort", DllStructGetData($tName, 2))
	Return $aRes2[0]
EndFunc   ;==>_GetLocalPort

Func _getsockname($iSocket)
	Local $tIn_Addr = DllStructCreate($tagIN_ADDR)
	Local $tName = DllStructCreate($tagSockAddr_In)
	DllStructSetData($tName, "sin_addr", DllStructGetPtr($tIn_Addr))
	Local $aRes[2]
	Local $aRet = DllCall($hDLL_WS2_32, "int", "getsockname", "uint", $iSocket, "struct*", $tName, "int*", 512)
	If Not @error And $aRet[0] = 0 Then
		$aRes[0] = _inet_ntoa(DllStructGetData($tName, "sin_addr")) ;IP address
		$aRes[1] = _ntohs(DllStructGetData($tName, "sin_port")) ;IP port
;~ 		$aRes[2] = DllStructGetData($tName, "sin_family") ; always AF_INET !?
		Return $aRes
	EndIf
	Return SetError(1, 0, 0)
EndFunc   ;==>_getsockname

;More than TCPNameToIP(), returns an array of IP addresses
Func _getaddrinfo($sNodeName)
	Local $pResult, $tAddrInfo, $sIP
	Local $aRet = DllCall($hDLL_WS2_32, "int", "getaddrinfo", "str", $sNodeName, "ptr", 0, "ptr", 0, "ptr*", 0)
	$pResult = $aRet[4]
	Do
		$tAddrInfo = DllStructCreate($tagAddrInfo, $pResult)
		Local $tName = DllStructCreate($tagSockAddr_In, DllStructGetData($tAddrInfo, "ai_addr"))
		$sIP &= _inet_ntoa(DllStructGetData($tName, "sin_addr")) & ";"
		$pResult = DllStructGetData($tAddrInfo, "ai_next")
	Until $pResult = 0
	_freeaddrinfo($aRet[4])
	Return StringSplit(StringTrimRight($sIP, 1), ";", 2)
EndFunc   ;==>_getaddrinfo

Func _freeaddrinfo($pAddrInfo)
	DllCall($hDLL_WS2_32, "none", "freeaddrinfo", "ptr", $pAddrInfo)
EndFunc   ;==>_freeaddrinfo

Func _ioctlsocket($iSocket, $iCmd, $iArg)
	Local $aRet = DllCall($hDLL_WS2_32, "int", "ioctlsocket", "uint", $iSocket, "long", $iCmd, "ULONG*", $iArg)
	Return $aRet[0]
EndFunc

Func _TCPConnectEx($sIP, $iRemPort, $iRcvTimeOut = 0, $iSendTimeOut = 0, $iLocPort = -1)

	Local $tTimeVal, $iSockError, $iBind, $iConnect, $aIP[1]

	Local $iSock = _socket($AF_INET, $SOCK_STREAM, $IPPROTO_TCP)
	If $iRcvTimeOut > 0 Then
		$tTimeVal = DllStructCreate("DWORD timeout")
		DllStructSetData($tTimeVal, "timeout", $iRcvTimeOut)
		$iSockError = _setsockopt($iSock, $SOL_SOCKET, $SO_RCVTIMEO, $tTimeVal)
		If $iSockError Then
			_closesocket($iSock)
			Return SetError(1, _WSAGetLastError(), 0)
		EndIf
	EndIf

	If $iSendTimeOut > 0 Then
		$tTimeVal = DllStructCreate("DWORD timeout")
		DllStructSetData($tTimeVal, "timeout", $iSendTimeOut)
		$iSockError = _setsockopt($iSock, $SOL_SOCKET, $SO_SNDTIMEO, $tTimeVal)
		If $iSockError Then
			_closesocket($iSock)
			Return SetError(2, _WSAGetLastError(), 0)
		EndIf
	EndIf

	If $iLocPort >= 0 Then
		$iBind = _bind($iSock, @IPAddress1, $iLocPort)
		If $iBind Then
			_closesocket($iSock)
			Return SetError(3, _WSAGetLastError(), 0)
		EndIf
	EndIf

	If _IsValidIP($sIP) Then
		$aIP[0] = $sIP
	Else
		$aIP = _getaddrinfo($sIP)
	EndIf
	$iConnect = _connect($iSock, $aIP[0], $iRemPort)
	If $iConnect Then
		_closesocket($iSock)
		Return SetError(4, _WSAGetLastError(), 0)
	EndIf
	Return $iSock
EndFunc   ;==>_TCPConnectEx


Func _IsValidIP($sIP)
	Local $aIP = StringSplit($sIP, ".")
	If $aIP[0] <> 4 Then Return SetError(1, 0, 0)
	For $X = 1 To $aIP[0]
		If $aIP[$X] < 0 Or $aIP[$X] > 255 Then Return SetError(2, 0, 0)
	Next
	Return 1
EndFunc   ;==>_IsValidIP
