#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <GUIListBox.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#Region ### START Koda GUI section ### Form=
$Form1_1 = GUICreate("TCPServer", 386, 530, -1, -1)
$Group1 = GUICtrlCreateGroup(" Connected Clients ", 8, 8, 369, 297)
GUICtrlSetFont(-1, 8, 800, 0, "MS Sans Serif")
$lblNumConnections = GUICtrlCreateLabel("Num connections:", 17, 29, 122, 17)
$lstClients = GUICtrlCreateList("", 17, 69, 265, 97)
GUICtrlSetData(-1, "")
$Label2 = GUICtrlCreateLabel("Clients:", 17, 53, 38, 17)
$btnDisconnectSelected = GUICtrlCreateButton("Disconnect", 288, 104, 81, 25)
$btnDisconnectAll = GUICtrlCreateButton("Disconnect All", 288, 136, 81, 25)
$btnRefresh = GUICtrlCreateButton("Refresh", 288, 72, 81, 25)
$lblReceiveMetrics = GUICtrlCreateLabel("Received from client (bytes/packets):", 16, 176, 269, 17)
$lblSentMetrics = GUICtrlCreateLabel("Sent to client (bytes/packets):", 16, 200, 266, 17)
$lblConnectionTime = GUICtrlCreateLabel("Connection time:", 16, 224, 267, 17)
$lblClientBroadcastStatus = GUICtrlCreateLabel("Broadcast status:", 16, 272, 100, 17)
$btnClientBroadcastToggle = GUICtrlCreateButton("Toggle", 128, 272, 65, 17)
$lblLastReceiveTime = GUICtrlCreateLabel("Last packet received time:", 16, 248, 266, 17)
GUICtrlCreateGroup("", -99, -99, 1, 1)
$Group2 = GUICtrlCreateGroup(" Received (Last Packet) ", 8, 400, 369, 81)
GUICtrlSetFont(-1, 8, 800, 0, "MS Sans Serif")
$lblReceivedData = GUICtrlCreateLabel("Received:", 17, 417, 349, 17)
$lblReceivedClientElement = GUICtrlCreateLabel("Client element:", 16, 448, 123, 17)
GUICtrlCreateGroup("", -99, -99, 1, 1)
$Group3 = GUICtrlCreateGroup(" Send ", 8, 312, 369, 81)
GUICtrlSetFont(-1, 8, 800, 0, "MS Sans Serif")
$txtDataToSend = GUICtrlCreateInput("Type data here to send ...", 15, 328, 353, 21)
$btnSendSelected = GUICtrlCreateButton("Send To Selected", 135, 352, 113, 25)
$btnSendAll = GUICtrlCreateButton("Send To All", 256, 352, 113, 25)
GUICtrlCreateGroup("", -99, -99, 1, 1)
$btnClose = GUICtrlCreateButton("Close", 296, 496, 81, 25)
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###


;*** TCP INITIALIZATION AS SERVER ***
#include "Routines_TCP.au3"
$sTCPMode = "SERVER"
$sInterfaceIP = "127.0.0.1"
$iPort = 54321
$iMaxClients = 5
_TCP_Initialize($sTCPMode,$sInterfaceIP,$iPort,$iMaxClients)
_TCPServer_Listen(1)

Global $aClientComputerName[$iMaxClients],$aClientUserName[$iMaxClients]

While 1
	;check for new TCP connections, and get list of newly connected client array elements
	$aNewConnectedClientElems = _TCPServer_ConnectNewClients()
	for $iElem in $aNewConnectedClientElems
		;insert code here to act on new clients
	Next

	;process any new packets (up to 10 at a time per client)
	for $iConn = 0 to $iMaxClients - 1
		$sReceivedData = ""
		if _TCP_ConnInfo("IsConnected",$iConn) Then
			for $iPacket = 1 to 10
				$sReceivedData = _TCPServer_GetPacket($iConn)
				;process packets
				if $sReceivedData <> "" then
					GUICtrlSetData($lblReceivedData,"Received: " & $sReceivedData)
					GUICtrlSetData($lblReceivedClientElement,"Client element: " & $iConn)
					RefreshClientStats()
					$aPacketParts = StringSplit($sReceivedData,"|",2)
					for $p in $aPacketParts
						$aParsedData = _ParseValueDataPair($p)
						Switch StringUpper($aParsedData[0])
							Case "CNAME"
								$aClientComputerName[$iConn] = $aParsedData[1]
								RefreshClientList()
							Case "UNAME"
								$aClientUserName[$iConn] = $aParsedData[1]
						EndSwitch
					Next
				EndIf
				if $sReceivedData = "" then ExitLoop
			Next
		EndIf
	Next

	;disconnect stale connections (idle more than 30 seconds)
	_TCPServer_Disconnect(-1,30)

	;update client list if connections have changed
	;_TCP_ConnectionsChanged() returns 1 any time a client connects or disconnects from the server.
	;IMPORTANT: Checking _TCP_ConnectionsChanged() will cause it to reset to 0 automatically, so you should only use it once per loop
	if _TCP_ConnInfo("ConnectionsChanged") Then RefreshClientList()


	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE,$btnClose
			Exit
		Case $btnSendAll ;send to all clients
			_TCPServer_SendPacket(-1,GUICtrlRead($txtDataToSend))
			RefreshClientStats()
		Case $btnSendSelected ;send to selected client
			$sClient = GUICtrlRead($lstClients)
			if $sClient <> "" Then
				$iConn = StringLeft($sClient,StringLen($sClient) - (StringInStr($sClient," ") - 1))
				_TCPServer_SendPacket($iConn,GUICtrlRead($txtDataToSend))
				RefreshClientStats()
			EndIf
		Case $btnRefresh ;refresh list
			RefreshClientList()
		Case $btnDisconnectAll ;disconnect all clients
			_TCPServer_Disconnect()
			RefreshClientStats()
		Case $btnDisconnectSelected ;disconnect selected client
			$sClient = GUICtrlRead($lstClients)
			if $sClient <> "" Then
				$iConn = StringLeft($sClient,StringLen($sClient) - (StringInStr($sClient," ") - 1))
				_TCPServer_Disconnect($iConn)
				RefreshClientStats()
			EndIf
		Case $btnClientBroadcastToggle ;broadcast toggle
			$sClient = GUICtrlRead($lstClients)
			if $sClient <> "" Then
				$iConn = StringLeft($sClient,StringLen($sClient) - (StringInStr($sClient," ") - 1))
				_TCPServer_EnableClientBroadcast($iConn,_ToggleNum(_TCPServer_ClientBroadcastIsEnabled($iConn)))
				RefreshClientStats()
			EndIf
		Case $lstClients ;display selected client's tcp stats
			RefreshClientStats()
	EndSwitch


	Sleep(10)
WEnd

Func _ToggleNum($iNum)
	if $iNum = 0 then Return 1
	if $iNum = 1 then Return 0
EndFunc

Func RefreshClientList()
		;display number of connected clients
		GUICtrlSetData($lblNumConnections,"Num connections: " & _TCP_ConnInfo("NumConnected"))

		;update client list
		GUICtrlSetData($lstClients,"") ;clear list
		for $iConn = 0 to $iMaxClients - 1
			if _TCP_ConnInfo("IsConnected",$iConn) Then
				$s = $iConn & " / " ;client element
				$s = $s & _TCP_ConnInfo("Socket",$iConn) & " / " ;socket number
				$s = $s & _TCP_ConnInfo("IPAddress",$iConn) & " / " ;ip address
				$s = $s & StringLeft(_TCP_ConnInfo("ComputerName",$iConn),StringInStr(_TCP_ConnInfo("ComputerName",$iConn),".") - 1) & " / " ;computer name
				$s = $s & $aClientUserName[$iConn] ;user name, as received from client
				GUICtrlSetData($lstClients,$s)
			EndIf
		Next

		RefreshClientStats()
	EndFunc

Func RefreshClientStats()
	$sClient = GUICtrlRead($lstClients)
	if $sClient <> "" Then
		$iConn = StringLeft($sClient,StringLen($sClient) - (StringInStr($sClient," ") - 1))
		GUICtrlSetData($lblReceiveMetrics,"Received from client (bytes/packets): " & _TCP_ConnInfo("BYTESPROCESSED",$iConn) & " / " & _TCP_ConnInfo("PACKETSPROCESSED",$iConn))
		GUICtrlSetData($lblSentMetrics,"Sent to client (bytes/packets): " & _TCP_ConnInfo("BYTESSENT",$iConn) & " / " & _TCP_ConnInfo("PACKETSSENT",$iConn))
		GUICtrlSetData($lblConnectionTime,"Connection time: " & _TCP_ConnInfo("CONNTIME",$iConn) & " / " & _TCP_ConnInfo("CONNTIMEELAPSED",$iConn) & "s")
		GUICtrlSetData($lblLastReceiveTime,"Last packet received time: " & _TCP_ConnInfo("LASTPACKETRECEIVETIME",$iConn))
		GUICtrlSetData($lblClientBroadcastStatus,"Broadcast status: " & _TCPServer_ClientBroadcastIsEnabled($iConn))
	Else
		GUICtrlSetData($lblReceiveMetrics,"Received from client (bytes/packets):")
		GUICtrlSetData($lblSentMetrics,"Sent to client (bytes/packets):")
		GUICtrlSetData($lblConnectionTime,"Connection time:")
		GUICtrlSetData($lblLastReceiveTime,"Last packet received time:")
		GUICtrlSetData($lblClientBroadcastStatus,"Broadcast status:")
	EndIf
EndFunc

;-------------------------------------------------------------------------------------------
;-- FUNCTION: _ParseValueDataPair - Updated 20140128 ---------------------------------------
;-------------------------------------------------------------------------------------------
Func _ParseValueDataPair($sStringToParse)
	;takes a valuename/data pair and returns parsed info via array, including any array values, if provided.
	;e.g. MyVal=MyData or MyVal(1D)=MyData or MyVal(1D,2D)=MyData
	;Returned array is in following format:
	;[0] - value name
	;[1] - value data
	;[2] - 1D value
	;[3] - 2D value

	Local $sValueName = "",$sValueData = ""
	Local $1DElem = -1,$2DElem = -1

	;split value name and data
	Local $aStringParts = StringSplit($sStringToParse,"=",2)
	$sValueName = StringStripWS($aStringParts[0],3)
	if UBound($aStringParts) > 1 then $sValueData = StringStripWS($aStringParts[1],3)
	;does value name appear to have array element values (number(s) surrounded by parens)?
	if StringInStr($sValueName,"(") > 0 and StringInStr($sValueName,")") > 0 Then ;appears to contain array elements
		Local $aValueNameParts = StringSplit($sValueName,"(",2)
		Local $sValueElements = StringReplace($aValueNameParts[1],")","")
		$sValueName = StringStripWS($aValueNameParts[0],3)
		Local $aValueElementParts = StringSplit($sValueElements,",",2)
		$1DElem = Int($aValueElementParts[0])
		if UBound($aValueElementParts) > 1 Then $2DElem = Int($aValueElementParts[1])
	EndIf

	Local $aRetData[4]
	$aRetData[0] = $sValueName
	$aRetData[1] = $sValueData
	$aRetData[2] = $1DElem
	$aRetData[3] = $2DElem

	Return $aRetData
EndFunc
