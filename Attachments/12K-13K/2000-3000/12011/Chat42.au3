#include <GUIConstants.au3>
#include <String.au3>
Opt("GUIOnEventMode", 1)
Dim $pass = 0,$recv, $LSocket, $cSocket, $Attrec=0, $rSocket, $f1stp = 0, $icip='', $accskt, $begin, $nc, $keyno = ''
Dim $enkey[10] = ['qq','ww','ee','rr','tt','yy','uu','ii','oo','pp'];sample encryption key
$F1 = GUICreate("Chat42", 329, 183, @DesktopWidth-680, @DesktopHeight-587)
$lb01 = GUICtrlCreateLabel('Ip Address', 8, 7, 50, 20, -1)
$e01 = GUICtrlCreateInput("", 62, 3, 90, 20, -1, $WS_EX_CLIENTEDGE)
$b01 = GUICtrlCreateButton("Call", 171, 2, 76, 23)
$b02 = GUICtrlCreateButton("Accept", 250, 2, 76, 23)
$e03 = GUICtrlCreateEdit("", 3, 26, 323, 99, $ES_READONLY + $WS_VSCROLL + $ES_AUTOVSCROLL)
GUICtrlSetBkColor($e03,0xFFFFFF)
$e04 = GUICtrlCreateInput("", 3, 127, 323, 23, -1, $WS_EX_CLIENTEDGE)
$lb02 = GUICtrlCreateLabel('', 3, 155, 244, 23,$SS_SUNKEN )
$b03 = GUICtrlCreateButton("&Send", 249, 155, 76, 23)
GUISetOnEvent($GUI_EVENT_CLOSE, "CornerX")
GUICtrlSetOnEvent ( $b01,'makecall')
GUICtrlSetOnEvent ( $b02,'takecall')
GUICtrlSetOnEvent ( $b03,'sndmsg')
HotKeySet ( '^s', 'sndmsg' )
GUICtrlSetState($e01,$GUI_FOCUS) 
GUISetState()
	soclisten()
While 1
	If $icip <> '' And $pass <> 1 And TimerDiff($begin)> 10000 Then Ncall() ;10 sec for recipient to accept call
	If $Attrec = 1 Then
			$nc = 0
		attmsg($accskt)
	Else	
		$rSocket = TCPAccept($LSocket)
		If $rSocket >= 0 Then
			$nc = 0
			$accskt = $rSocket
			If $pass = 0 Then $f1stp = 1
			attmsg($rSocket)
		ElseIf $pass = 1 Then
			attmsg($accskt)	
		EndIf	
	EndIf
WEnd
Func takecall()
	Select 
		Case GUICtrlRead($b02) = 'Accept'
			If $icip='' Then Return
			$keyno = Random(1,9,1)
			TCPSend($accskt, @IPAddress1 & Chr(1) & $keyno )
			GUICtrlSetData($e03,'::: Session with ' & $icip & ' established. @ '&@HOUR&':'&@MIN&':'&@SEC & @CRLF,1)
			GUICtrlSetData($b02,'Hang up')
			GUICtrlSetState($b01,$GUI_DISABLE)
			$pass = 1 
			$f1stp = 0
		Case GUICtrlRead($b02) = 'Hang up'
			TCPSend($accskt,Chr(2) & @IPAddress1)
			Sleep(500)
			GUICtrlSetState($b01,$GUI_ENABLE)
			GUICtrlSetData($e03,'::: Session with ' & $icip & ' terminated. @ '&@HOUR&':'&@MIN&':'&@SEC & @CRLF,1)
			GUICtrlSetData($b02,'Accept')
			$nc = 1
	EndSelect	
EndFunc
Func makecall()
	If GUICtrlRead($e01) = '' Then Return
	TCPCloseSocket ( $LSocket )
	GUICtrlSetState($b01,$GUI_DISABLE)
	$cSocket = TCPConnect( TCPNameToIP (GUICtrlRead($e01)), 8000 )
	If $cSocket = -1 Then 
		MsgBox(0,'Error','Connection failed',2)
		GUICtrlSetState($b01,$GUI_ENABLE)
	Else	
		TCPSend($cSocket,@IPAddress1 & Chr(0))
		GUICtrlSetData($lb02,'Calling '&GUICtrlRead($e01))
		$begin = TimerInit()
		$accskt = $cSocket	
		$Attrec = 1
	EndIf	
EndFunc
Func attmsg($socket)
	$recv = ''
	While 1
		If $nc = 1 Then 
			Ncall()
			GUICtrlSetState($b01,$GUI_ENABLE)
			Dim $accskt=0, $cSocket=0
			ExitLoop
		EndIf	
		If $socket > 0 Then $recv = TCPRecv( $socket, 2048 )
		If $recv <> "" Then 
			If StringRight($recv,1)<>Chr(0) And $f1stp = 1 Then ;recipient security feature
				Ncall()
			ElseIf StringRight($recv,1)=Chr(0) And $f1stp = 1 Then ;4 recipient
				$icip = StringTrimRight($recv,1)
				GUICtrlSetData($e03,'::: Incoming call from ' & $icip & ', click "Accept" to take call.' & @CRLF,1)
				SoundPlay('C:\WINDOWS\Media\ding.wav')
				Sleep(1500)
				SoundPlay('C:\WINDOWS\Media\ding.wav')
				Sleep(750)
				SoundPlay('C:\WINDOWS\Media\ding.wav')
				$begin = TimerInit()
				ExitLoop
			ElseIf StringLeft(StringRight($recv,2),1)=Chr(1) And StringTrimRight($recv,2) = TCPNameToIP (GUICtrlRead($e01)) Then ;4 caller
				$icip = StringTrimRight($recv,2)
				GUICtrlSetData($e03,'::: Session with ' & $icip & ' established. @ '&@HOUR&':'&@MIN&':'&@SEC & @CRLF,1)
				GUICtrlSetData($lb02,'')
				$keyno = StringRight($recv,1)
				GUICtrlSetData($b02,'Hang up')
				$pass = 1
			ElseIf StringLeft($recv,1)=Chr(2) Then ;4 both cause counterpart to chg button text
				GUICtrlSetData($e03,'::: Session with ' & StringTrimLeft($recv,1) & ' terminated. @ '&@HOUR&':'&@MIN&':'&@SEC & @CRLF,1)
					If GUICtrlRead($b02)='Hang up' Then GUICtrlSetData($b02,'Accept')
				GUICtrlSetState($b01,$GUI_ENABLE)
				$nc = 1
				$Attrec = 0
			ElseIf $pass = 1 Or $Attrec = 1 Then	
				GUICtrlSetData($e03,'>' & _StringEncrypt (0,$recv,$enkey[$keyno]) & @CRLF,1)
			EndIf	
			$f1stp = 0
		EndIf	
	If $Attrec = 1 And $pass <> 1 And TimerDiff($begin)>10000 And TimerDiff($begin)<10400 Then $nc = 1
	WEnd
EndFunc
Func Ncall()
	Dim $pass = 0,$recv, $LSocket, $cSocket, $Attrec=0, $rSocket, $f1stp = 0, $icip='', $accskt, $begin=0
	GUICtrlSetData($lb02,'')
	TCPShutdown()
	soclisten()
	$nc = 1
EndFunc	
Func soclisten()
	TCPStartUp()
	$LSocket = TCPListen(@IPAddress1, 8000)
	If $LSocket = -1 Then MsgBox(0,'Network Failure','Unable to make connection.',2)
EndFunc	
Func sndmsg()
	If GUICtrlRead($e04) = '' Or $pass <> 1 Then Return
	TCPSend($accskt,_StringEncrypt (1,GUICtrlRead($e04),$enkey[$keyno]))
	GUICtrlSetData($e03,'<' & GUICtrlRead($e04) & @CRLF,1)
	GUICtrlSetData($e04,'')
	GUICtrlSetState($e04,$GUI_FOCUS) 
EndFunc
Func CornerX()
	Exit
EndFunc