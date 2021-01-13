#include <GUIConstants.au3>
#include <INet.au3>



FileInstall("CratePop.wav",@ScriptDir & "\CratePop.wav")
FileInstall("Freeze.wav",@ScriptDir & "\Freeze.wav")
FileInstall("StartRound.wav",@ScriptDir & "\StartRound.wav")


$ipAddress = _GetIP ()
Global $title = "ReflectIT Multy!"
Global $version = 0.2
Global $client = "test"
Global $remoteClient= "-1"
Global $state = "0"
$port = 3031
Global $time = -1
Global $localPoint= 0
Global $remotePoint= 0
Global $finalPoint= 3
Global $STATO
Global $sound
Global $autoRefreshHostList
Global $randomYellowTime


if FileExists("ReflectIT.ini") Then
	$client = IniRead("ReflectIT.ini","data","nickname","ImAunReflect")
	$sound = IniRead("ReflectIT.ini","data","sound",1)
	$autoRefreshHostList = IniRead("ReflectIT.ini","data","autoRefreshHostList",1)
	$randomYellowTime = IniRead("ReflectIT.ini","data","randomYellowTime",1500)
Else
	
	Do
		$client = InputBox($title,"Choose your nickname")
	Until StringLen($client)>0
	IniWrite("ReflectIT.ini","data","nickname",$client)
	IniWrite("ReflectIT.ini","data","sound",1)
	IniWrite("ReflectIT.ini","data","autoRefreshHostList",1)
	IniWrite("ReflectIT.ini","data","randomYellowTime",2000)  ;******* 1000 short time, 2000 medium, up...... oooold
EndIf

_GUIbase()

Func _GUIbase()


	; == GUI generated with Koda ==
	$base = GUICreate($title, 195, 467, 346, 172)
	GUICtrlCreateGroup("HOST", 8, 24, 177, 121)
	$Radio1 = GUICtrlCreateRadio("Start with chat", 32, 96, 113, 17)
	$Radio2 = GUICtrlCreateRadio("Start with game", 32, 120, 113, 17)
	GUICtrlSetState(-1, $GUI_CHECKED)
	GUICtrlCreateGroup("", -99, -99, 1, 1)
	GUICtrlCreateGroup("JOIN", 8, 176, 177, 281)
	$REFRESH_ = GUICtrlCreateButton("REFRESH", 16, 410, 73, 33)
	GUICtrlCreateGroup("", -99, -99, 1, 1)
	$ListView1 = GUICtrlCreateList("", 32, 200, 129, 209)
	$JOIN_ = GUICtrlCreateButton("JOIN", 96, 410, 81, 33)
	$HOST_ = GUICtrlCreateButton("HOST", 32, 56, 129, 33)
	
	$HOST_LIST=_hostListGetList()
	;MsgBox(0,"",$HOST_LIST)
	GUICtrlSetData($ListView1,$HOST_LIST)
	
	if $autoRefreshHostList = 1 Then
		$refreshTime= TimerInit()
		GUICtrlCreateLabel("Autorefresh hostlist enable (30 sec)", 12, 155, 180, 17)
	EndIf
	
	GUISetState(@SW_SHOW,$base)
	
	
	While 1
		
		if $autoRefreshHostList = 1 AND TimerDiff($refreshTime) > 30000 Then
			$refreshTime= TimerInit()
			$HOST_LIST=_hostListGetList()
			if StringLen($HOST_LIST)>0 Then
				_soundAlert("newHost")
			EndIf
			GUICtrlSetData($ListView1,$HOST_LIST)
		EndIf
	
		$msg = GuiGetMsg()
		Select
			Case $msg = $JOIN_
				;$version=0.1
			;Global $socketServer = _connectToServer("5.8.179.156")
			$strSpk = GUICtrlRead($ListView1)
			if $strSpk = "" Then
				$ipHost = InputBox($title,"Manual connect " & @CRLF  & @CRLF  & "Insert IP Host")
			Else
				$ipHostArr = StringSplit($strSpk,"~")
				$ipHost=$ipHostArr[2]
			EndIf
			
			Global $socketServer = _connectToServer($ipHost)
			
			if @error OR $socketServer = 0 Then
				MsgBox(16,$title,"Host not found")
			Else
				
				
				;MsgBox(0,"",$socketServer)
				;$client = "client"
				
				Do
					$remoteVersion = TCPRecv($socketServer, 50) ;retrive version
				Until $remoteVersion <> ""
				
				TCPSend($socketServer, $version) ;send client version
				
				if $remoteVersion = $version Then			
					
					Do
						$remoteClient = TCPRecv($socketServer, 50) ;retrive host name
					Until $remoteClient <> ""
					
					TCPSend($socketServer,$client) ;send client name
					
					Do
						$chat = TCPRecv($socketServer, 50) ;retrive start mode
					Until $chat <> ""
					
					$STATO = "client"
					GUIDelete($base)
					
					if $chat = 1 Then
						_GUIfinalMessage("",$socketServer)
					Else
						_GUImainClient()
					EndIf
				Else
					
					MsgBox(16,$title,"The version of the host is " & $remoteVersion & ", yours is " & $version)
					;TcpCloseSocket($socketServer)
					;TcpShutDown()
				EndIf
			EndIf
			
		Case $msg = $HOST_
			;GUISetState(@SW_HIDE,$base)
			
			$chat = GUICtrlRead($Radio1)
			GUIDelete($base)
			
			if $ipAddress <> @IPAddress1 Then
				_GUIchooseIP($chat)
			Else
				_GUIwaitJoin($chat)
			EndIf
		Case $msg = $REFRESH_
			$HOST_LIST=_hostListGetList()
			if StringLen($HOST_LIST)>0 Then
				_soundAlert("newHost")
			EndIf
			GUICtrlSetData($ListView1,$HOST_LIST)
		Case $msg = $GUI_EVENT_CLOSE
			Exit
		Case Else
			;;;;;;;
		EndSelect
	WEnd
	Exit
EndFunc


Func _GUIchooseIP($chat)

	#Region ### START Koda GUI section ### Form=
	$chooseIP = GUICreate("AForm1", 295, 150, 323, 249)
	$Label1 = GUICtrlCreateLabel("Choose IP address", 64, 16, 181, 27)
	GUICtrlSetFont(-1, 14, 400, 0, "Verdana")
	$Radio1 = GUICtrlCreateRadio($ipAddress, 64, 48, 113, 17,)
	GUICtrlSetState(-1, $GUI_CHECKED)
	$Radio2 = GUICtrlCreateRadio(@IPAddress1, 64, 72, 113, 17)
	$Button1 = GUICtrlCreateButton("Ok", 104, 96, 89, 25, 0)
	GUISetState(@SW_SHOW)
	#EndRegion ### END Koda GUI section ###

	While 1
		$nMsg = GUIGetMsg()
		Switch $nMsg
			case $Button1
				if GUICtrlRead($Radio2) = 1 Then
					$ipAddress = @IPAddress1
				EndIf
				_hostListAddHost($client,$ipAddress)
				GUIDelete($chooseIP)
				_GUIwaitJoin($chat)
			Case $GUI_EVENT_CLOSE
				Exit

		EndSwitch
	WEnd
EndFunc


Func _GUIwaitJoin($chat)
	$waitString ="you are waiting a join"
	
	_createServer()
	
	$STATO ="server"
	; == GUI generated with Koda ==
	$waitJoin = GUICreate($title & " - wait join", 250, 54, 285, 296)
	$string_ = GUICtrlCreateLabel($waitString, 16, 16, 240, 22)
	GUICtrlSetFont(-1, 12, 800, 0, "Verdana")
	GUISetState(@SW_SHOW,$waitJoin)
	
	$time = TimerInit()
	
	While 1
		$msg = GuiGetMsg()
		
		$dif = TimerDiff($time)
		$wait = _waitClient()
		;MsgBox(0,"",$dif)
		
		if $dif < 1000 Then
			$strData = $waitString
		Elseif $dif >= 1000 and $dif < 2000 Then
			$strData = $waitString & "."
		ElseIf $dif >= 2000 and $dif < 3000 Then
			$strData = $waitString & ".."
		ElseIf $dif >= 3000 and $dif < 4000 Then
			$strData = $waitString & "..."
		Else
			$strData = $waitString
			$time = TimerInit()
			_hostListRefreshTime($client)
		EndIf
	
		GUICtrlSetData($string_, $strData)
		Select
		Case $msg = $GUI_EVENT_CLOSE
			GUISetState(@SW_HIDE,$waitJoin)	
			GUIDelete($waitJoin)
			_hostListDelHost($client)
			_GUIbase()
		Case $wait <> -1
			global $clientSocket = $wait
			
			;$client = "server" 
			TCPSend($clientSocket,$version)  ;send host version
			
			Do
				$clientVersion = TCPRecv($clientSocket,15)
			Until $clientVersion <> ""
			
			if $clientVersion<> $version Then
				TcpCloseSocket($clientSocket)
				;TcpShutDown()
			Else				
				
				TCPSend($clientSocket,$client)
				
				if @error Then
					TcpCloseSocket($clientSocket)
					;TcpShutDown()
				Else
					Do
						$remoteClient = TCPRecv($clientSocket, 50)
						
					Until $remoteClient <> ""
					
					TCPSend($clientSocket,$chat)	
					
					GUIDelete($waitJoin)
					_soundAlert("userConnect")
					if $chat = 1 Then
						_GUIfinalMessage("",$clientSocket)
					Else
						_GUImainServer()
					EndIf
				EndIf
			EndIf
		Case Else
			;;;;;;;
		EndSelect
	WEnd
	
EndFunc


Func _GUImainServer()
	$remotePoint = 0
	$localPoint = 0
	$mainServer = GUICreate($title, 519, 270, 285, 353)
	GUICtrlCreateGroup($client & " - " & $remoteClient, 16, 72, 137, 89)
	;GUICtrlCreateLabel($client & " - " & $remoteClient, 72, 120, 30, 17)
	GUICtrlCreateGroup("", -99, -99, 1, 1)
	$hit = GUICtrlCreateButton("HIT!", 192, 72, 217, 161)
	GUICtrlSetState($hit, $GUI_DISABLE)
	$ponits_ = GUICtrlCreateLabel("0 - 0", 40, 96, 93, 20)   ;POINTS
	GUICtrlSetFont(-1, 10, 400, 0, "Verdana")
	GUICtrlSetColor(-1, 0x000080)
	$start = GUICtrlCreateButton("Start", 32, 176, 105, 33)

	Global $Icon1 = GUICtrlCreateGraphic(280, 16, 32, 32)

	GUICtrlSetGraphic($Icon1, $GUI_GR_COLOR, 0x00ee00, 0x00ff00)
	GUICtrlSetGraphic($Icon1, $GUI_GR_ELLIPSE, 0, 0, 32, 32)

	GUISetState(@SW_SHOW)
	$xi = 0
	$state = "0"
	While 1
		$msg = GUIGetMsg()
		
		if $state = "waintRed" Then
			$recv = TCPRecv($clientSocket,10)

			If $recv <> "" And $recv = "hit!" Then
				$state ="hit!"
				;	TCPSend($socketServer,$state)
				$timeX = TimerInit()
				_iconRed()
				
			EndIf	
		EndIf		
		
		if $state = "hitten!" Then
			TCPSend($clientSocket,"!~" & $timeDif)
			
			$recv = TCPRecv($clientSocket,30)
			;MsgBox(0,"","avversario: " & $remoteClient & " " & $recv)
			If $recv <> "" And StringLeft($recv,1) = "!" Then
				$recvArray = StringSplit($recv,"~")
				
				$timeDif= Round($timeDif / 1000, 2)
				$recvArray[2] = Round($recvArray[2] / 1000, 2)
				
				if $recvArray[2] > $timeDif Then
					MsgBox(0,$title,"you SUCCESS!!!" & @CRLF & $timeDif & "sec VS " & $recvArray[2] & "sec")
					$localPoint = $localPoint + 1 
					GUICtrlSetData($ponits_,$localPoint & " - " & $remotePoint)
					if $localPoint >= $finalPoint Then
						MsgBox(0,$title,"You are the winner!",4)
						GUIDelete($mainServer)
						_GUIfinalMessage("win", $clientSocket)
					EndIf
				ElseIf $recvArray[2] = $timeDif Then
					MsgBox(0,$title,"PAIR!" & @CRLF & $timeDif & "sec VS " & $recvArray[2] & "sec")
				Else
					MsgBox(16, $title, "you LOSE!" & @CRLF & $timeDif & "sec VS " & $recvArray[2] & "sec")
					$remotePoint = $remotePoint + 1 
					GUICtrlSetData($ponits_,$localPoint & " - " & $remotePoint)
					if $remotePoint >= $finalPoint Then
						MsgBox(0,$title,"You are the loser!",4)
						GUIDelete($mainServer)
						_GUIfinalMessage("lose",$clientSocket)
					EndIf
				EndIf				
				
				GUICtrlSetData($start,"Start")
				GUICtrlSetState($start, $GUI_ENABLE)
				GUICtrlSetState($hit, $GUI_DISABLE)
				$state = "0"
			EndIf	
			_iconGreen()
			
		EndIf	
		
		
		if $state = "start" Then
			$recv = TCPRecv($clientSocket,10)

			If $recv <> "" And $recv = "countDown" Then
				
				GUICtrlSetData($start,"Start")
				GUICtrlSetState($start, $GUI_DISABLE)
				GUICtrlSetData($start, "3")
				Sleep(1000)
				GUICtrlSetData($start, "2")
				Sleep(1000)
				GUICtrlSetData($start, "1")
				Sleep(1000)
				GUICtrlSetData($start, "Start")
				GUICtrlSetState($hit, $GUI_ENABLE)
				_iconYellow()
				;$state = 1
				;$tent = 0
				$state = "waintRed"
			EndIf
		EndIf
		
		
		Select
			Case $msg = $hit
				if $state ="hit!" Then
					$timeDif = TimerDiff($timeX)
					;MsgBox(0,"Server",$timeDif)
					$state ="hitten!"
				Else
					MsgBox(16, $title, "Fail! Wait red icon")
				EndIf
			Case $msg = $start
				GUICtrlSetState($start, $GUI_DISABLE)
				GUICtrlSetData($start,"Wait...")
				$state = "start"
				TCPSend($clientSocket,$state)
			Case $msg = $GUI_EVENT_CLOSE
				GUIDelete($mainServer)
				MsgBox(16,$title,"The connection is broken")
				TcpCloseSocket($clientSocket)
				TcpShutDown()
				_GUIbase()
			Case Else
			;;;;;;;
		EndSelect
	WEnd
	Exit
	
EndFunc


Func _GUImainClient()
	$remotePoint = 0
	$localPoint = 0
	$mainClient = GUICreate($title, 519, 270, 285, 353)
	GUICtrlCreateGroup($client & " - " & $remoteClient, 16, 72, 137, 89)
	;GUICtrlCreateLabel($client & " - " & $remoteClient, 72, 120, 30, 17)
	GUICtrlCreateGroup("", -99, -99, 1, 1)
	$hit = GUICtrlCreateButton("HIT!", 192, 72, 217, 161)
	GUICtrlSetState($hit, $GUI_DISABLE)
	$ponits_ = GUICtrlCreateLabel("0 - 0", 40, 96, 93, 20)   ;POINTS
	GUICtrlSetFont(-1, 10, 400, 0, "Verdana")
	GUICtrlSetColor(-1, 0x000080)
	$start = GUICtrlCreateButton("Wait...", 32, 176, 105, 33)
	GUICtrlSetState($start, $GUI_DISABLE)

	global $Icon1 = GUICtrlCreateGraphic(280, 16, 32, 32)

	GUICtrlSetGraphic($Icon1, $GUI_GR_COLOR, 0x00ee00, 0x00ff00)
	GUICtrlSetGraphic($Icon1, $GUI_GR_ELLIPSE, 0, 0, 32, 32)

	GUISetState(@SW_SHOW)
	$xi = 0
	$state = "waitStart"
	While 1
		$msg = GUIGetMsg()
	
		if $state = "waitStart" Then
			$recv = TCPRecv($socketServer,10)
			If $recv <> "" And $recv = "start" Then
				GUICtrlSetData($start,"Start")
				GUICtrlSetState($start, $GUI_ENABLE)
			EndIf	
		EndIf
	
	
		if $state = "waintRed" Then
			if _reflex() = 1 Then
				$state ="hit!"
				TCPSend($socketServer,$state)
				$timeX = TimerInit()
				;MsgBox(0,"","")
				_iconRed()
			EndIf
		EndIf	
		
		if $state = "hitten!" Then
			TCPSend($socketServer,"!~" & $timeDif)
			
			$recv = TCPRecv($socketServer,30)
			;MsgBox(0,"","Client: " & $recv)
			If $recv <> "" And StringLeft($recv,1) = "!" Then
				$recvArray = StringSplit($recv,"~")
				$timeDif= Round($timeDif / 1000,2)
				$recvArray[2] = Round($recvArray[2] / 1000,2)
				
				if $recvArray[2] > $timeDif Then
					MsgBox(0,$title,"you SUCCESS!!!" & @CRLF & $timeDif & "sec VS " & $recvArray[2] & "sec")
					$localPoint = $localPoint +1
					GUICtrlSetData($ponits_,$localPoint & " - " & $remotePoint)
					if $localPoint >= $finalPoint Then
						MsgBox(0,$title,"You are the winner!",4)
						GUIDelete($mainClient)
						_GUIfinalMessage("win", $socketServer)
					EndIf
				ElseIf $recvArray[2] = $timeDif Then
					MsgBox(0,$title,"PAIR!" & @CRLF & $timeDif & "sec VS " & $recvArray[2] & "sec")
				Else
					MsgBox(16, $title, "you LOSE!" & @CRLF & $timeDif & "sec VS " & $recvArray[2] & "sec")
					$remotePoint = $remotePoint + 1 
					GUICtrlSetData($ponits_,$localPoint & " - " & $remotePoint)
					if $remotePoint >= $finalPoint Then
						MsgBox(0,$title,"You are the loser!",4)
						GUIDelete($mainClient)
						_GUIfinalMessage("lose",$socketServer)
					EndIf
				EndIf				
				
				GUICtrlSetData($start,"Start")
				GUICtrlSetState($start, $GUI_DISABLE)
				GUICtrlSetState($hit, $GUI_DISABLE)
				$state = "waitStart"
			EndIf	
			_iconGreen()
			
		EndIf	
				
		
			
		Select
		
		Case $msg = $hit
			if $state ="hit!" Then
				$timeDif = TimerDiff($timeX)
				;MsgBox(0,"Client",$timeDif)
				$state ="hitten!"
			Else
				MsgBox(16, $title, "Fail! Wait red icon")
			EndIf
			
		Case $msg = $start
				$state ="countDown"
				TCPSend($socketServer,$state)
				GUICtrlSetState($start, $GUI_DISABLE)
				GUICtrlSetData($start, "3")
				Sleep(1000)
				GUICtrlSetData($start, "2")
				Sleep(1000)
				GUICtrlSetData($start, "1")
				Sleep(1000)
				GUICtrlSetData($start, "Start")
				GUICtrlSetState($hit, $GUI_ENABLE)
				_iconYellow()
				$state = "waintRed"
				Global $tent = 0
			;Sleep(1000)
			Case $msg = $GUI_EVENT_CLOSE
				GUIDelete($mainClient)
				MsgBox(16,$title,"The connection is broken")
				TcpCloseSocket($socketServer)
				TcpShutDown()
				_GUIbase()
			Case Else
			;;;;;;;
		EndSelect
	WEnd
	Exit
	
EndFunc

Func _GUIfinalMessage($position, $socket)
	$text=0
	$requestState = "null"
	; == GUI generated with Koda ==
	$finalMessage = GUICreate($title & " - " & $position, 442, 293, 364, 285)
	$Edit1 = GUICtrlCreateEdit("", 24, 16, 385, 193, $ES_READONLY, $WS_EX_CLIENTEDGE)
	$send_ = GUICtrlCreateButton("Send", 160, 256, 113, 25,$BS_DEFPUSHBUTTON)
	$another_ = GUICtrlCreateButton("Start game", 352, 256, 65, 25)
	$Input1 = GUICtrlCreateInput("", 24, 224, 385, 21)
	GUISetState(@SW_SHOW)
	GUICtrlSetState($Input1,$GUI_FOCUS)
	While 1
		
		$rec = TCPRecv($socket, 256)
		if @error then 
			MsgBox(16,$title,"The connection is broken",4)
			GUIDelete($finalMessage)
			TcpCloseSocket($socket)
			TcpShutDown()
			_GUIbase()
		EndIf
			
			
		if $rec <> "" Then
			
				if $rec = "!~" Then
					$rec = "                                        --" & $remoteClient & " request a game" & "--"
					GUICtrlSetData($another_,"Accept")
				EndIf
			;MsgBox(0,"",$rec & @CRLF & $STATO)
			if StringInStr($rec,"!~") = 0 Then
				;MsgBox(0,"",$rec & @CRLF & $STATO)

				
				if $rec = "!!" Then
					;MsgBox(0,"","xxx")
					GUIDelete($finalMessage)
					
					if $STATO = "server" Then
						_GUImainServer()
					else
						_GUImainClient()
					EndIf
				EndIf
				
				$rec = $rec & @CRLF & GUICtrlRead($Edit1)
				GUICtrlSetData($Edit1,$rec)
				$text = $text+1 
			EndIf
		EndIf
		
		$msg = GuiGetMsg()
		Select
		Case $msg = $another_
			if GUICtrlRead($another_) = "Start game" Then
				TCPSend($socket,"!~")
				GUICtrlSetState($Input1,$GUI_FOCUS)
				GUICtrlSetState($another_,$GUI_DISABLE)
			Else
				TCPSend($socket,"!!")
				GUIDelete($finalMessage)
				;MsgBox(0,"","rik")
				if $STATO = "server" Then
					_GUImainServer()
				else
					_GUImainClient()
				EndIf
			EndIf
		Case $msg = $send_
			$rec = $client & ": " & GUICtrlRead($Input1)  & @CRLF &  GUICtrlRead($Edit1)
			GUICtrlSetData($Edit1,$rec)
			TCPSend($socket, $client & ": " & GUICtrlRead($Input1))
			GUICtrlSetData($Input1,"")
			GUICtrlSetState($Input1,$GUI_FOCUS)
		Case $msg = $GUI_EVENT_CLOSE
			GUIDelete($finalMessage)
			;MsgBox(16,$title,"The connection is broken")
			TcpCloseSocket($socket)
			TcpShutDown()
			_GUIbase()
		Case Else
			;;;;;;;
		EndSelect
	WEnd
	Exit

EndFunc

Func _TCPRecv($socket, $dim)
	TCPRecv($socket, $dim)
	if @error Then
		MsgBox(16,$title,"The connection is broken")
	EndIf
EndFunc

Func _reflex($s = 1)
    If $s = 1 Then
        $rand = Random(1, $randomYellowTime, 1)
        
    ;MsgBox(0,"",$rand)
        If $rand = 1 Or $tent >= 3000 Then
        ;Return 1
            $state = 2
            Return 1
        Else
            $tent = $tent + 1
        ;ToolTip($tent)
            Return 0
        EndIf
    EndIf
EndFunc  ;==>_reflex



Func _createServer()
	TcpStartUp()
	Global $ImainSocket= TcpListen($ipAddress,$port)
EndFunc

Func _waitClient()
	$socket = -1
	$socket= TCPAccept($ImainSocket)
	;MsgBox(0,$title,$socket & " connesso")

	if $socket <> -1 Then
		$remoteClient = SocketToIP($socket)
		Return $socket
	Else
		Return -1
	EndIf
EndFunc


Func _connectToServer($ip)
	TcpStartUp()
	$socketServer = -1
	$socketServer = TCPConnect($ip,$port)
	if @error Then Return 0
		
	if $socketServer <> -1 Then
		Return $socketServer
	EndIf
	
EndFunc
if @error Then
	
	$ImainSocket= TcpListen($ipAddress,3031)

	$socket = -1
	do
		$socket= TCPAccept($ImainSocket)
		
	Until $socket <> -1
	MsgBox(0,$title,$socket & " connesso")

	$ip = SocketToIP($socket)
Else
	TCPSend($socket,0)
EndIf

while 1
	$str = TCPRecv($socket,2024)
	if @error then ExitLoop
	
	if $str <> "" Then
		MsgBox(0,$title,$str)
		;$se= InputBox($title,"")
		$se = $str + 1
		TCPSend($socket,$se)
	EndIf
WEnd

TcpCloseSocket($socket)
TcpShutDown()




Func _iconGreen()
	GUICtrlSetGraphic($Icon1, $GUI_GR_COLOR, 0x00ee00, 0x00ff00)
	GUICtrlSetGraphic($Icon1, $GUI_GR_ELLIPSE, 0, 0, 32, 32)
	GUICtrlSetGraphic($Icon1, $GUI_GR_REFRESH)
EndFunc

Func _iconRed()
	GUICtrlSetGraphic($Icon1, $GUI_GR_COLOR, 0xee0000, 0xff0000)
	GUICtrlSetGraphic($Icon1, $GUI_GR_ELLIPSE, 0, 0, 32, 32)
	GUICtrlSetGraphic($Icon1, $GUI_GR_REFRESH)
EndFunc

Func _iconYellow()
	GUICtrlSetGraphic($Icon1, $GUI_GR_COLOR, 0xeeee00, 0xffff00)
	GUICtrlSetGraphic($Icon1, $GUI_GR_ELLIPSE, 0, 0, 32, 32)
	GUICtrlSetGraphic($Icon1, $GUI_GR_REFRESH)
EndFunc

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



;****************************************************   HOST LIST FUNCTIONS **************************************************
#cs
Func _hostListGetList()
	;*
	;* RETRIVE SERVER ZONE
	;*
	
	$fileHostList = FileOpen("F:\AutoIT" & "\ReflectIT_hostList.txt",0)
	$bigStr= ""

	while 1
		
		$Host = FileReadLine($fileHostList)
		if @error then ExitLoop
		
		$bigStr = $Host
		
	WEnd
	
	;$bigStr=StringMid($bigStr,2)
	MsgBox(0,"",$bigStr)
	$tempArray = StringSplit($bigStr,"|")
	Dim $hostList[$tempArray[0]+1][2]
	$hostList[0][0]= $tempArray[0]
	for $i=1 to $tempArray[0]
		$temp= StringSplit($tempArray[$i],"~")
		MsgBox(0,"",$tempArray[$i])
		$hostList[$i][0] = $temp[1]
		$hostList[$i][1] = $temp[2]
	Next
	
	Return $hostList
EndFunc
#ce

Func _hostListDelHost($host)
	$retDown = InetGet("                                                                        " & $host,@ScriptDir & "\temp_hostListReturn.txt",1)
	if $retDown = 1 Then
		Return 1
	Else
		Return 0
	EndIf
EndFunc

Func _hostListRefreshTime($host)
	$retDown = InetGet("                                                                                " & $host,@ScriptDir & "\temp_hostListReturn.txt",1)
	if $retDown = 1 Then
		Return 1
	Else
		Return 0
	EndIf
EndFunc

Func _hostListAddHost($host, $ip)
	$retDown = InetGet("                                                                           " & $host & "&ip=" & $ip,@ScriptDir & "\temp_hostListReturn.txt",1)
	if $retDown = 1 Then
		Return 1
	Else
		Return 0
	EndIf
EndFunc

Func _hostListGetList()
	;*
	;* RETRIVE SERVER ZONE
	;*
	$retDown = InetGet("                                                                  ",@ScriptDir & "\ReflectIT_hostList.txt",1)
	
	
	if $retDown = 1 Then
		$fileHostList = FileOpen(@ScriptDir & "\ReflectIT_hostList.txt",0)
		$bigStr= ""


			$Host = FileReadLine($fileHostList)
				

		;MsgBox(0,"",$Host)
		$Host = FileReadLine($fileHostList)
		Return $Host
	Else
		Return ""
	EndIf
EndFunc


Func _soundAlert($tipo)
	if $sound = 1 Then
		Switch $tipo
			Case "newHost"
				SoundPlay("Freeze.wav")
			Case "userConnect"
				SoundPlay("CratePop.wav")
			Case "startRound"
				SoundPlay("StartRound.wav")
		EndSwitch
	EndIf
EndFunc