#include <ASock.au3>
#include <file.au3>
#include "APITailRW.au3"
Const $WM_USER = 1024
;;;
Const $B_BEPOLITE    = False
Const $N_SOCKETS     = 20
Const $N_MAXRECV     = 65536
Const $N_WAITCLOSE   = 2000
Const $N_WAITWORK    = 50
;;;
Dim $hSockets[ $N_SOCKETS ]
Dim $fhandles[ $N_SOCKETS ]
Dim $reqests[ $N_SOCKETS ]
Dim $shandle[ $N_SOCKETS ]
Dim $filepointer[ $N_SOCKETS ]
Dim $handleids[ $N_SOCKETS ]
Dim $gotheader[ $N_SOCKETS ]
Dim $sizes[ $N_SOCKETS ]
Dim $hNotifyGUI
Dim $g_bExecExit = True
For $i = 0 To $N_SOCKETS - 1
	$hSockets[ $i ] = -1
Next

Opt( "OnExitFunc", "ExitProgram" )

If Not TCPStartup( ) Then Error( "WSAStartup() failed.", False )

$hNotifyGUI = GUICreate( "Dummy Notify Window / " & TimerInit( ) )

; ex: cTCP("62.75.221.136",80)
func createTCP($IP,$PORT)
	local $i= FreeSock( )
	$hSockets[ $i ] = _ASocket( )
	If @error Then Error( "Socket creation failed." )
	_ASockSelect( $hSockets[ $i ], $hNotifyGUI, $WM_USER + $i, BitOR( $FD_READ, $FD_WRITE, $FD_CONNECT, $FD_CLOSE ) )
	GUIRegisterMsg( $WM_USER + $i, "OnSocketEvent" )
	_ASockConnect( $hSockets[ $i ], $IP, $PORT )
	If @extended Then Out( "(This is interesting) connected immediately on socket #" & $i + 1 )
	return $i
EndFunc
;MsgBox(4096, "Stock Change", $bla)
;MsgBox(4096, "Stock Change", getsize("http://files.ingame.de/wow/misc/Helden04.rar"))
addstream("http://www.autoitscript.com/images/userbars/userbar.png")
; loop
While 1
	sleep( $N_WAITWORK )
WEnd

func addstream($link) 
	local $size=getsize($link)
	local $mresult= StringSplit($link, "/", 1)
	local $packets=Ceiling ( $size/512)
	local $streams=0
	if not FileExists ($mresult[$mresult[0]]) then 
		local $handleid=getfreehandle()
		$streams=1
		_FileCreate($mresult[$mresult[0]])
		$fhandles[$handleid] = _FileOpenAPI($mresult[$mresult[0]]&".txt")
		;_FileWriteAPI($fhandles[$handleid], "FastAsHell Download File", 0)
		;_FileWriteAPI($fhandles[$handleid], $size, 32)
		;_FileWriteAPI($fhandles[$handleid], $packets, 64)
		;_FileWriteAPI($fhandles[$handleid], "1", 96)
		;_FileWriteAPI($fhandles[$handleid], " ", $size)
		$handleids[$handleid]=$mresult[$mresult[0]]
		;_FileCountLines($sFilePath)
	else 
		local $handleid=gethandleid($mresult[$mresult[0]])
		For $i=1 to $N_SOCKETS 
			if $shandle[$i]==$handleid then 
				$streams++
				ExitLoop
			EndIf
			
		Next
		$streams++
	EndIf
	
	local $datalink=StringTrimLeft ( $link, 7 +StringLen ( $mresult[3] ))
	
	$sockid=createTCP(TCPNameToIP($mresult[3]),80)
	
	$shandle[$sockid]=$handleid
	$sizes[$sockid]=$size
	
	local $ergebniss=500
	For $i=0 to 7
		$ergebniss= $streams/(2 ^ $i)
		if $ergebniss<=1 then exitloop
	next
	$hoch=2^$i
	$startbyte=($hoch-(1+($hoch-$streams)*2))*(1/$hoch)
	
	$req="GET "&$datalink&" HTTP/1.1"&@CRLF
	$req&="Host: "&$mresult[3]&@CRLF
	$req&="Range: bytes="&$startbyte&"-"&@CRLF
	$req&="User-Agent: FastAsHell V0.1"&@CRLF
	$req&="Accept: */*"&@CRLF
	$req&="Referer: "&$link&@CRLF
	$req&="Connection: Close"&$link&@CRLF
	$req&="Accept-Encoding: "&@CRLF&@CRLF
	$gotheader[$sockid]=0
	$filepointer[$sockid]=$startbyte
	$reqests[$sockid]=$req
	
	
EndFunc

func dorequest($socketid) 
	TCPSend($hSockets[ $socketid ],$reqests[$socketid])	
EndFunc

func getfreehandle() 
	For $i=1 to $N_SOCKETS 
		if $fhandles[$i]==0 or $fhandles[$i]=="" Then
			return $i
			exitloop
		EndIf
	Next
EndFunc

func gethandleid($handle) 
	$handleids[ $N_SOCKETS ]
	For $i=1 to $N_SOCKETS 
		if $handleids[$i]==$handle Then
			return $i
			exitloop
		EndIf
	Next
	
EndFunc


func getsize($link) 
	local $sizesocket=-1
	local $req=""
	local $received=""
	local $mresult
	local $i
	local $mresult= StringSplit($link, "/", 1)
	local $datalink=StringTrimLeft ( $link, 7 +StringLen ( $mresult[3] ))
	$req="GET "&$datalink&" HTTP/1.1"&@CRLF
	$req&="Host: "&$mresult[3]&@CRLF
	$req&="Range: bytes=0-"&@CRLF
	$req&="User-Agent: FastAsHell V0.1"&@CRLF
	$req&="Accept: */*"&@CRLF
	$req&="Referer: "&$link&@CRLF
	$req&="Accept-Encoding: "&@CRLF&@CRLF
	
	$sizesocket=TCPConnect(TCPNameToIP ($mresult[3]),80)
	TCPSend($sizesocket,$req)
	while 1
		$received&=BinaryToString (TCPRecv( $sizesocket, 2048 ))
		If @error Then ExitLoop
		$mresult= StringSplit($received, @CRLF, 1)
		For $i=1 to $mresult[0]
			local $var=StringSplit($mresult[$i], " ", 1)
			if $var[1]=="Content-Length:" then
				TCPCloseSocket( $sizesocket )
				return $var[2]
				exitloop(2)
			EndIf
			if $var[1]=="" and $i<>1 then
				;MsgBox(4096, "Stock Change", $i)
				TCPCloseSocket( $sizesocket )	
				return "0"
				exitloop
			EndIf

		Next
	WEnd

EndFunc


func gotdata($data,$id) 
	if isbinary($data) then 
		$data=BinaryToString($data,1)
		Out("is binary")
	EndIf
	
	if $gotheader[$id]==0 Then
		local $mresult= StringSplit($data, @CRLF, 1)
		For $i=1 to $mresult[0]
			if $mresult[$i]=="" Then
				$gotheader[$id]=1
				local $strlen=stringlen(@CRLF)*$i
				
				For $a=1 to $i
					$strlen+=stringlen($mresult[$a])
				next
				$data=stringtrimleft($data,$strlen)
				ExitLoop
			EndIf
			
		Next
		
		
	EndIf
	_FileWriteAPI($fhandles[$shandle[$id]], $data, $filepointer[$id])
	Out("end writing")
	$filepointer[$id]+=StringLen ( $data ) 
	if $filepointer[$id]==$sizes[$id] Then
		_FileCloseAPI($fhandles[$shandle[$id]])
		BreakConn( $id )
		Out("FILE COMPLETE")
		EXIT
	EndIf
	
EndFunc


Func OnSocketEvent( $hWnd, $iMsgID, $WParam, $LParam )
	Local $hSocket = $WParam
	Local $nSocket = $iMsgID - $WM_USER
	Local $iError = _HiWord( $LParam )
	Local $iEvent = _LoWord( $LParam )
	
	Local $sDataBuff
	Local $iSent
	
	If $iMsgID >= $WM_USER And $iMsgID < $WM_USER + $N_SOCKETS Then		
		Switch $iEvent
			Case $FD_READ; Data has arrived!
				If $iError <> 0 Then
					BreakConn( $nSocket, "FD_READ was received with the error value of " & $iError & "." )
					Out( "clozed2")
				Else
					Local $sDataBuff = Binary("")
					$sDataBuff = TCPRecv( $hSocket, $N_MAXRECV,1)
					$sDataBuff=Binary($sDataBuff)
					If @error Then
						BreakConn( $nSocket, "Conn is down while recv()'ing, error = " & @error & "." )
						Out( "clozed")
					ElseIf $sDataBuff <> "" Then
						Out( "got data ")
						gotdata($sDataBuff,$nSocket)
					Else; This DEFINITELY shouldn't have happened
						Out( "Warning: schizophrenia! FD_READ, but no data on socket #" & $nSocket + 1 & "!" )
					EndIf
				EndIf
			Case $FD_WRITE
				If $iError <> 0 Then
					BreakConn( $nSocket, "FD_SEND was received with the error value of " & $iError & "." )
				EndIf
			Case $FD_CLOSE; Bye bye
				BreakConn($nSocket)
				Out( "clozed by server" )
			Case $FD_CONNECT
				If $iError <> 0 Then
					BreakConn( $nSocket, "Error connecting on socket #" & $nSocket + 1 & "... :(" )
				Else; Yay, connected!
					dorequest($nSocket) 
					Out( "+> Connected on socket #" & $nSocket + 1 & " (socket " & $hSockets[ $nSocket ] & ")" )
				EndIf
		EndSwitch
	EndIf
EndFunc

Func BreakConn( $nSocket, $sError="" )
	_ASockShutdown( $hSockets[ $nSocket ] )
	Sleep( 1 )
	TCPCloseSocket( $hSockets[ $nSocket ] )
	$hSockets[ $nSocket ] = -1
	Out( "breaking connection" )
EndFunc

Func FreeSock( )
	For $i = 0 To $N_SOCKETS - 1
		If $hSockets[ $i ] = -1 Then
			Return $i
		EndIf
	Next
	Return -1
EndFunc

Func Error( $sText, $bCloseSockets = True, $iExitCode = 1 )
	MsgBox( 16, "Server Error", $sText )
	_Exit( $bCloseSockets, $iExitCode )
EndFunc

Func _Exit( $bCloseSockets = True, $iExitCode = 0 )
	If $bCloseSockets Then
		For $i = 0 To $N_SOCKETS - 1
			_ASockShutdown( $hSockets[ $i ] ); Graceful shutdown.
		Next
		Sleep( $N_WAITCLOSE )
		For $i = 0 To $N_SOCKETS - 1
			TCPCloseSocket( $hSockets[ $i ] )
		Next
	EndIf
	TCPShutdown( )
	$g_bExecExit = False
	Exit $iExitCode
EndFunc

Func Out( $sText )
	ConsoleWrite( $sText & @CRLF )
EndFunc

Func ExitProgram( )
	If $g_bExecExit Then
		Out( "+> ////////////////////////////// Closing... //////////////////////////////" )
		Out( "+> //////////////////////////// Exit method: " & @exitMethod & "////////////////////////////" )
		_Exit( True, @exitCode )
	EndIf
EndFunc

; AutoIt Help -> TCPRecv
Func SocketToIP($SHOCKET)
    Local $sockaddr = DLLStructCreate("short;ushort;uint;char[8]")

    Local $aRet = DLLCall("Ws2_32.dll","int","getpeername","int",$SHOCKET, _
            "ptr",DLLStructGetPtr($sockaddr),"int_ptr",DLLStructGetSize($sockaddr))
    If Not @error And $aRet[0] = 0 Then
        $aRet = DLLCall("Ws2_32.dll","str","inet_ntoa","int",DLLStructGetData($sockaddr,3))
        If Not @error Then $aRet = $aRet[0]
    Else
        $aRet = "(Could not resolve)"
    EndIf

    $sockaddr = 0

    Return $aRet
EndFunc


