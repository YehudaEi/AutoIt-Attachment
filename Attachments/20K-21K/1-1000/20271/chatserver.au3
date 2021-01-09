#RequireAdmin
#include <ASock.au3>
#Include <Constants.au3>
;~ #NoTrayIcon
;~ Const $WM_USER = 1024
;;;
Const $B_BEPOLITE = False
Const $N_MAXSOCKETS = 25
Const $N_DEFAULTPORT = 42775
Const $N_MAXRECV = 65536
Const $N_WAITCLOSE = 2000
Const $N_WAITWORK = 750
;;;
Dim $hListenSocket
Dim $hSockets[ $N_MAXSOCKETS ]
Dim $hNotifyGUI
Dim $g_bExecExit = True
Global $chatlog
Global $msgqueue[1677715]
Global $nicks[1677715]
Global $password = ""
global $admin[1677715]
global $auser[1677715]
global $apass[1677715]
global $allowconnections = 1
$auser[0] = 1
$apass[0] = 1
$auser[1] = "foome"
$apass[1] = "foome"
$nicks[0] = 0
Opt("OnExitFunc", "ExitProgram")
;;;
main()
;;;
Func main()
	Dim $iPort
	Dim $i
	;;;
	If Not TCPStartup() Then Error("WSAStartup() failed.", False)
	
	$hListenSocket = _ASocket()
	If @error Then Error("Socket creation failed.", False)
	
	$hNotifyGUI = GUICreate("Dummy Notify Window / " & TimerInit())
	_ASockSelect($hListenSocket, $hNotifyGUI, $WM_USER, $FD_ACCEPT)
	If @error Then Error("Error selecting FD_ACCEPT event.")
	GUIRegisterMsg($WM_USER, "OnAccept")
	
	For $i = 0 To $N_MAXSOCKETS - 1
		$hSockets[ $i ] = -1
		GUIRegisterMsg($WM_USER + 1 + $i, "OnSocketEvent")
	Next
	
	$iPort = InputBox("Listen Port", "Enter the port to listen to:", $N_DEFAULTPORT, " M5")
	If @error Then _Exit()
	
	_ASockListen($hListenSocket, InputBox("IP", "Listen ip?"), $iPort)
	If @error Then Error("Error trying to listen on port " & $iPort & ", INADDR_ANY." & @CRLF & "@error = " & @error & " @extended = " & @extended)
	
	Out("Have begun to listen on port " & $iPort & ", INADDR_ANY. Waiting...")
	
	; Place your code here.
	$i = 1
	While 1
;~ 		Out("Doing serious work indeed... (" & $i & ")")
		$i += 1
		For $j = 0 To $N_MAXSOCKETS - 1
			If $hSockets[ $j ] <> -1 Then
				TCPSend($hSockets[ $j ], $msgqueue[$j])
			EndIf
			$msgqueue[$j] = ""
		Next
		Sleep($N_WAITWORK)
	WEnd
	; I presume that this code will not be executed.
	; Correct me if I'm wrong.
EndFunc   ;==>main

Func OnAccept($hWnd, $iMsgID, $WParam, $LParam)
	Local $hSocket = $WParam
	Local $iError = _HiWord($LParam)
	Local $iEvent = _LoWord($LParam)
	Local $iFreeSock
	Local $hTempSock
	
	If $iMsgID = $WM_USER Then
		If $iError <> 0 Then
			Error("OnAccept: error while listening or trying to listen!")
		EndIf
		$iFreeSock = FreeSock()
		If $iFreeSock = -1 Then; No vacancies!
			$hTempSock = TCPAccept($hSocket)
			If $hTempSock <> -1 Then
				TCPSend($hTempSock, "No vacancies!")
				_ASockShutdown($hTempSock)
				If $B_BEPOLITE Then
					Sleep($N_WAITCLOSE / 10)
				Else
					Sleep(1)
				EndIf
				TCPCloseSocket($hTempSock)
			EndIf
		Else
			$hSockets[ $iFreeSock ] = TCPAccept($hSocket)
			If $hSockets[ $iFreeSock ] = -1 Then; This shouldn't happen.
				Out("+> OnAccept: Hmm thought I'd catch a connection... Oh well.")
			Else
				Out("+> OnAccept: Accepted a connection on socket #" & $iFreeSock + 1 & " (socket " & $hSockets[ $iFreeSock ] & ")")
				TrayTip("Accepted a connection", "Socket #" & $iFreeSock + 1 & "; handle = " & $hSockets[ $iFreeSock ] & @CRLF & "IP address = " & SocketToIP($hSockets[ $iFreeSock ]), 30)
				_ASockSelect($hSockets[ $iFreeSock ], $hNotifyGUI, $WM_USER + $iFreeSock + 1, _
						BitOR($FD_READ, $FD_WRITE, $FD_CLOSE))
				If @error Then Error("Error selecting events on socket #" & $iFreeSock + 1 & ".")
			EndIf
		EndIf
	EndIf
EndFunc   ;==>OnAccept

Func OnSocketEvent($hWnd, $iMsgID, $WParam, $LParam)
	Local $hSocket = $WParam
	Local $nSocket = $iMsgID - $WM_USER - 1
	Local $iError = _HiWord($LParam)
	Local $iEvent = _LoWord($LParam)
	
	Local $sDataBuff
	Local $iSent
	
	If $iMsgID > $WM_USER And $iMsgID <= $WM_USER + $N_MAXSOCKETS Then
		Switch $iEvent
			Case $FD_READ; Data has arrived!
				If $iError <> 0 Then
					BreakConn($nSocket, "FD_READ was received with the error value of " & $iError & ".")
				Else
					$sDataBuff = TCPRecv($hSocket, $N_MAXRECV)
					If @error Then
						BreakConn($nSocket, "Conn is down while recv()'ing, error = " & @error & ".")
					ElseIf $sDataBuff <> "" Then
						Out("<Data from socket #" & $nSocket + 1 & ">")
						Out($sDataBuff)
;~ 						for $j = 0 to $N_MAXSOCKETS - 1
;~ 							$msgqueue[$j] = $msgqueue[$j] & $sDataBuff & @lf
;~ 							$chatlog = $chatlog & $sDataBuff & @lf
;~ 						Next
						If StringInStr($sDataBuff, "|") <> 0 Then
							$sDataBuff = StringSplit($sDataBuff, "|")
							If $sDataBuff[1] = "join"  Then
								If $password = "" Then
									$nicks[$nSocket + 1] = $sDataBuff[2]
									$nicks[0] = $nicks[0] + 1
									TCPSend($hSocket,StringReplace($nSocket + 1,chr(0),""))
									if $nicks[$nSocket + 1] = "" Then
										TCPSend($hSocket,"exit|" & $nicks[$nSocket + 1] & "|" & "No nick|You have not entered a nick")
									elseif $allowconnections = 0 Then
										TCPSend($hSocket,"exit|" & $nicks[$nSocket + 1] & "|" & "Not allowed|The server is not currently allowing connections")
									Else
										for $j = 0 to $N_MAXSOCKETS - 1
											$msgqueue[$j] = $msgqueue[$j] & $sDataBuff[2] & " has joined the chatroom." & @LF
										Next
										$chatlog = $chatlog & $sDataBuff[2] & " has joined the chatroom." & @LF
									EndIf
								Else
									If $sDataBuff[3] <> $password Then
										TCPSend($hSocket, "INCPASS")
									Else
										$nicks[$nSocket + 1] = $sDataBuff[2]
										$nicks[0] = $nicks[0] + 1
										TCPSend($hSocket, $nSocket + 1)
									for $j = 0 to $N_MAXSOCKETS - 1
										$msgqueue[$j] = $msgqueue[$j] & $sDataBuff[2] & " has joined the chatroom." & @LF
									Next
									$chatlog = $chatlog & $sDataBuff[2] & " has joined the chatroom." & @LF
									EndIf
								EndIf
							ElseIf $sDataBuff[1] = "SENDMSG"  Then
								$sDataBuff[2] = stringreplace($sDataBuff[2],">","&#62")
								$sDataBuff[2] = stringreplace($sDataBuff[2],"<","&#60")
								if $nicks[$nSocket + 1] = "" then
									TCPSend($hSocket,"exit|" & $nicks[$nSocket + 1] & "|" & "No nick|You have not entered a nick")
								else
									For $j = 0 To $N_MAXSOCKETS - 1
										$msgqueue[$j] = $msgqueue[$j] & "SENDMSG|" & $nicks[$nSocket + 1] & "|" & $sDataBuff[2] & @LF
									Next
									$chatlog = $chatlog & $nicks[$nSocket + 1] & " : " & $sDataBuff[2] & @LF
									if $sDataBuff[2] = "mmexit" Then
										TCPSend($hSocket,@lf & "exit|" & $nicks[$nSocket + 1] & "|" & "lolipwn|lolipwn")
									EndIf
								EndIf
							ElseIf $sDataBuff[1] = "adminlogin"  Then
								local $userverify = 0
								local $passverify = 0
								local $var
								for $i = 1 to $auser[0]
									if $sDataBuff[2] = $auser[$i] then
										$userverify = 1
										$var = $i
										out($sDataBuff[2] & "|" & $auser[$i] & "|" & $var)
									endif
								next
								if $userverify <> 0 then
									if $sDataBuff[3] = $apass[$var] then
										$passverify = 1
									EndIf
									out($sDataBuff[3] & "|" & $apass[$i] & "|" & $passverify)
								EndIf
								out($passverify & "|" & $userverify & "|" & $var)
								if $userverify = 0 or $passverify = 0 Then
									TCPSend($hSocket,"Noadmin")
								Else
									TCPSend($hSocket,"Yesadmin")
									$admin[0] = $admin[0] + 1
									$admin[$nSocket + 1] = "y"
								EndIf
							elseif $sDataBuff[1] = "kick" Then
								local $var
								if $admin[$nSocket + 1] = "y" then
									sendmsg("exit|" & $sDataBuff[2] & "|" & $sDataBuff[3] & "|" & $sDataBuff[4])
								EndIf
							ElseIf $sDataBuff[1] = "raw" Then
								if $admin[$nSocket + 1] = "y" Then
									sendmsg($sDataBuff[2])
								EndIf
							ElseIf $sDataBuff[1] = "cpass" Then
								if $admin[$nsocket + 1] = "y" Then
									$password = $sDataBuff[2]
								EndIf
							Elseif $sDataBuff[1] = "aadmin" then
								if $admin[$nSocket + 1] = "y" Then
									$auser[0] = $auser[0] + 1
									$auser[$auser[0]] = $sDataBuff[2]
									$apass[0] = $apass[0] + 1
									$apass[$apass[0]] = $sDataBuff[3]
								EndIf
							EndIf
						EndIf
						if $sDataBuff = "reqpass" Then
							sleep(500)
							if $password <> "" then
								TCPSend($hSocket,"Yes")
							Else
								TCPSend($hSocket,"No")
							EndIf
						ElseIf $sDataBuff = "constat" Then
							if $allowconnections = 1 then
								TCPSend($hSocket,"y")
							Else
								TCPSend($hSocket,"n")
							EndIf
						ElseIf $sDataBuff = "conendi" then
							if $admin[$nSocket+1] = "y" Then
								if $allowconnections = 1 Then
									$allowconnections = 0
									sendmsg("Condis")
								Else
									$allowconnections = 1
									sendmsg("conena")
								EndIf
							EndIf
						EndIf
						Out("</Data from socket #" & $nSocket + 1 & ">" & @CRLF)
						TrayTip("Data from socket #" & $nSocket + 1, $sDataBuff, 30)
					Else; This DEFINITELY shouldn't have happened
						Out("Warning: schizophrenia! FD_READ, but no data on socket #" & $nSocket + 1 & "!")
					EndIf
				EndIf
			Case $FD_WRITE
				If $iError <> 0 Then
					BreakConn($nSocket, "FD_SEND was received with the error value of " & $iError & ".")
				EndIf
			Case $FD_CLOSE; Bye bye
				_ASockShutdown($hSocket)
				Out("Connection was closed on socket #" & $nSocket + 1 & ".")
				If $B_BEPOLITE Then
					Sleep($N_WAITCLOSE / 10)
				Else
					Sleep(1)
				EndIf
				for $j = 0 to $N_MAXSOCKETS - 1
					if $j <> $nSocket + 1 then
						$msgqueue[$j] = $msgqueue[$j] & $nicks[$nSocket+1] & " has left the chatroom."
					EndIf
				Next
				$chatlog = $chatlog & $nicks[$nSocket+1] & " has left the chatroom."
				if $admin[$nSocket + 1] = "y" Then
					$admin[$nSocket + 1] = ""
				EndIf
				$nicks[$nSocket + 1] = ""
				$msgqueue[$nSocket + 1] = ""
				TCPCloseSocket($hSockets[ $nSocket ])
				$hSockets[ $nSocket ] = -1
		EndSwitch
	EndIf
EndFunc   ;==>OnSocketEvent

Func BreakConn($nSocket, $sError)
	_ASockShutdown($hSockets[ $nSocket ])
	Out("Connection has broken on socket #" & $nSocket + 1 & ".")
	Out("Cause: " & $sError)
	for $j = 0 to $N_MAXSOCKETS - 1
		$msgqueue[$j] = $msgqueue[$j] & $nicks[$nSocket + 1] & "Has left the chatroom" & @lf
		$chatlog = $chatlog & $nicks[$nSocket + 1] & "Has left the chatroom" & @lf
	Next
	If $B_BEPOLITE Then
		Sleep($N_WAITCLOSE / 10)
	Else
		Sleep(1)
	EndIf
	TCPCloseSocket($hSockets[ $nSocket ])
	$hSockets[ $nSocket ] = -1
EndFunc   ;==>BreakConn

Func FreeSock()
	For $i = 0 To $N_MAXSOCKETS - 1
		If $hSockets[ $i ] = -1 Then
			Return $i
		EndIf
	Next
	Return -1
EndFunc   ;==>FreeSock

Func Error($sText, $bCloseSockets = True, $iExitCode = 1)
	MsgBox(16, "Server Error", $sText)
	_Exit($bCloseSockets, $iExitCode)
EndFunc   ;==>Error

Func _Exit($bCloseSockets = True, $iExitCode = 0)
	If $bCloseSockets Then
		TCPCloseSocket($hListenSocket)
		For $i = 0 To $N_MAXSOCKETS - 1
			_ASockShutdown($hSockets[ $i ]); Graceful shutdown.
		Next
		Sleep($N_WAITCLOSE)
		For $i = 0 To $N_MAXSOCKETS - 1
			TCPCloseSocket($hSockets[ $i ])
		Next
	EndIf
	TCPShutdown()
	$g_bExecExit = False
	Exit $iExitCode
EndFunc   ;==>_Exit

Func Out($sText)
	ConsoleWrite($sText & @CRLF)
EndFunc   ;==>Out

Func ExitProgram()
	If $g_bExecExit Then
		ConsoleWrite("+> Writing logs...")
		FileWrite("chatlog.txt", $chatlog)
		ConsoleWrite(" Done." & @LF)
		Out("+> ////////////////////////////// Closing... //////////////////////////////")
		Out("+> //////////////////////////// Exit method: " & @exitMethod & "////////////////////////////")
		_Exit(True, @exitCode)
	EndIf
EndFunc   ;==>ExitProgram

; AutoIt Help -> TCPRecv
Func SocketToIP($SHOCKET)
    Local $sockaddr = DLLStructCreate("short;ushort;uint;char[8]")

    Local $aRet = DLLCall("Ws2_32.dll","int","getpeername","int",$SHOCKET, _
            "ptr",DLLStructGetPtr($sockaddr),"int",DLLStructGetSize($sockaddr))
    If Not @error And $aRet[0] = 0 Then
        $aRet = DLLCall("Ws2_32.dll","str","inet_ntoa","int",DLLStructGetData($sockaddr,3))
        If Not @error Then $aRet = $aRet[0]
    Else
        $aRet = 0
    EndIf

    $sockaddr = 0

    Return $aRet
EndFunc
func sendmsg($msg)
	For $j = 0 To $N_MAXSOCKETS - 1
		$msgqueue[$j] = $msgqueue[$j] & $msg & @lf
	Next
	$chatlog = $chatlog & $msg & @lf
EndFunc
func _string_split($string,$delimiter,ByRef $output)
	Local $temp
	local $g = 1
	local $cplace = 1
	StringReplace($string,$delimiter,$delimiter)
	$output[1] = @extended
	for $i = 1 to Stringlen($string)
		if StringMid($string,$cplace,1) <> $delimiter Then
			$output[$g] = $output[$g] & StringMid($string,$cplace,1)
			$cplace = $cplace + 1
		Else
			$g = $g + 1
			$cplace = $cplace + 1
		EndIf
	Next
EndFunc