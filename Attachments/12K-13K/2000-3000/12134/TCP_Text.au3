;===============================================================================
;
;Description:	Sends data via TPC. It can be any type of non-binary data. A
;		length identifier is added to the beginning of the packet to
;		ensure all the data is present on the receiving end.
;
;Parameter(s):	$vData - Accepts any type of formated data.
; 		$iSocket - The connected socket identifier (SocketID) as returned by TCPConnect.
;
;Requirement(s):A TCP connection.
;
;Author:	Snarg  - Supa(dot)Snarg(at)gmail(dot)com
;		(I would like to give the vast majority of the credit to Larry)
;
;===============================================================================
Func _TCPSendText ($iSocket, $vData)
	
	Local $vBuffer = ""
	$vBuffer = StringLen ($vData) & "," & $vData
	TCPSend ($iSocket, $vBuffer)
	
EndFunc

;===============================================================================
;
;Description:     Recieves a data packet via TPC. It can be any type of non-binary
;                 data. A length identifier is checked at the start of the packet
;                 to ensure all the data has been recieved.
;
;Parameter(s):    $iSocket - The connected socket identifier (SocketID) as returned by TCPAccept or
;                 TCPConnect.
;
;Requirement(s):  A TCP connection.
;
;Return Value:    $vBuffer - Data recieved on the TCP connection.
;
;Author:          Snarg  - Supa(dot)Snarg(at)gmail(dot)com
;                 (I would like to give the vast majority of the credit to Larry)
;
;===============================================================================

Func _TCPReciveText ($iSocket)
	Local $vBuffer = ""
	Local $iBytes = -1
	
	While 1
		$vBuffer &= TCPRecv ($iSocket, 1024)
		If $iBytes = -1 And StringInStr ($vBuffer, ",") Then
			$iBytes = StringLeft ($vBuffer, StringInStr ($vBuffer, ",")-1)
			$vBuffer = StringTrimLeft ($vBuffer, StringInStr ($vBuffer, ","))
		Else
			If StringLen ($vBuffer) = $iBytes Then ExitLoop
		EndIf
	WEnd
	
	Return $vBuffer
EndFunc