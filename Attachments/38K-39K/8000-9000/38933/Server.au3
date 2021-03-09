#region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_UseUpx=n
#AutoIt3Wrapper_Res_Comment=Multi Client Server
#AutoIt3Wrapper_Res_Fileversion=1.0.0.2
#AutoIt3Wrapper_Res_Fileversion_AutoIncrement=y
#AutoIt3Wrapper_Res_requestedExecutionLevel=requireAdministrator
#AutoIt3Wrapper_Run_Tidy=y
#endregion ;**** Directives created by AutoIt3Wrapper_GUI ****

#include <GUIConstantsEx.au3>
#include <Array.au3>
#include <WindowsConstants.au3>
#include <GuiMenu.au3>
#include <Crypt.au3>
#include <GDIPlus.au3>
#include <Base64.au3>

TCPStartup() ; Starts up TCP
_Crypt_Startup() ; Starts up Crypt
_GDIPlus_Startup() ; Starts up GDIPlus

#region ;**** Declares you can edit ****
Opt("TrayIconDebug", 1)
Global $BindIP = "0.0.0.0" ; IP Address to listen on.	0.0.0.0 = all available.
Global $BindPort = "1337" ; Port to listen on.
Global $MaxConnections = 1000 ; Maximum number of allowed connections.
Global $PacketSize = 1000 ; Maximum size to receive when packets are checked.
#endregion ;**** Declares you can edit ****

#region ;**** Declares that shouldn't be edited ****
OnAutoItExitRegister("_ServerClose")
Opt("TCPTimeout", 0)
Opt("GUIOnEventMode", 1)
Global $WS2_32 = DllOpen("Ws2_32.dll") ; Opens Ws2_32.dll to be used later.
Global $NTDLL = DllOpen("ntdll.dll") ; Opens NTDll.dll to be used later.
Global $TotalConnections = 0 ; Holds total connection number.
Global $SocketListen = -1 ; Variable for TCPListen()
Global $Connection[$MaxConnections + 1][11] ; Array to connection information.
Global $SocketListen
Global $PacketEND = "[PACKET_END]" ; Defines the end of a packet
Global $PacketMSG = "[PACKET_TYPE_0001]" ; Plain text message
Global $PacketPNG = "[PACKET_TYPE_0002]" ; Base64 of PNG binary.
Global $PacketPCI = "[PACKET_TYPE_0003]" ; UserName@PC name
#endregion ;**** Declares that shouldn't be edited ****

#region ;**** GUI ****
Global $GUI = GUICreate("Server List", 300, 400)
Global $ServerList = GUICtrlCreateListView("#|Socket|IP|User|Computer", 5, 5, 290, 360)
Global $ServerMenu = GUICtrlCreateMenu("Server")
Global $ServerStartListen = GUICtrlCreateMenuItem("On", $ServerMenu, 2, 1)
Global $ServerStopListen = GUICtrlCreateMenuItem("Off", $ServerMenu, 3, 1)
Global $ConnectionMenu = GUICtrlCreateMenu("Connection")
Global $ConnectionKill = GUICtrlCreateMenuItem("Close", $ConnectionMenu, 1)
GUICtrlCreateMenuItem("", $ConnectionMenu, 2)
Global $ConnectionKillAll = GUICtrlCreateMenuItem("Close All", $ConnectionMenu, 3)
GUISetOnEvent($GUI_EVENT_CLOSE, "_ServerClose")
GUICtrlSetOnEvent($ServerStartListen, "_ServerListenStart")
GUICtrlSetOnEvent($ServerStopListen, "_ServerListenStop")
GUICtrlSetOnEvent($ConnectionKill, "_ConnectionKill")
GUICtrlSetOnEvent($ConnectionKillAll, "_ConnectionKillAll")
GUISetState(@SW_SHOW, $GUI)
#endregion ;**** GUI ****

_Main() ; Starts the main function

Func _Main()
	While 1
		_CheckNewConnections()
		_CheckNewPackets()
		_Sleep(1000, $NTDLL)
	WEnd
EndFunc   ;==>_Main

Func _CheckNewConnections()
	Local $SocketAccept = TCPAccept($SocketListen) ; Tries to accept a new connection.
	If $SocketAccept = -1 Then ; If we found no new connections,
		Return ; skip the rest and return to _Main().
	EndIf

	If $TotalConnections >= $MaxConnections Then ; If we reached the maximum connections allowed,
		TCPSend($SocketAccept, "MAXIMUM_CONNECTIONS_REACHED") ; tell the connecting client that we cannot accept the connection,
		TCPCloseSocket($SocketAccept) ; close the socket,
		Return ; skip the rest and return to _Main().
	EndIf
	; Since we got this far, we must have a new connection.
	$TotalConnections += 1 ; Add to the total connections.
	$Connection[$TotalConnections][0] = $SocketAccept ; Save the socket number to the next empty array slot, at sub array 0.
	$Connection[$TotalConnections][1] = GUICtrlCreateListViewItem($TotalConnections & "|" & $SocketAccept & "|" & _SocketToIP($SocketAccept), $ServerList) ; Create list view item with connection information
EndFunc   ;==>_CheckNewConnections

Func _CheckBadConnection()
	If $TotalConnections < 1 Then Return ; If we have no connections, there is no reason to check for bad ones, so return to _Main()
	Local $NewTotalConnections = 0 ; Temporary variable to calculate the new total connections.
	For $i = 1 To $TotalConnections ; Loop through all
		TCPSend($Connection[$i][0], "CONNECTION_TEST") ; Send a test packet
		If @error Then ; If the send fails..
			TCPCloseSocket($Connection[$i][0]) ; Close the socket,
			GUICtrlDelete($Connection[$i][1]) ; Delete the item from the list view,
			$Connection[$i][0] = -"" ; Set socket to nothing,
			$Connection[$i][1] = "" ; Empty gui control,
			ContinueLoop ; and continue checking for more bad connections.
		Else
			$NewTotalConnections += 1 ; If the send succeeded, we count up, because the client is still connected.
		EndIf
	Next

	If $NewTotalConnections < $TotalConnections Then ; If we found any bad connections, then we rearrange the $Connection array.
		If $NewTotalConnections < 1 Then ; If the new total shows no connections,
			$TotalConnections = $NewTotalConnections ; Set the new connection variable,
			Return ; and Return to _Main()
		EndIf

		; This loop creates a temporary array, cycles through possible old data in the $Connection array and transfers it to the temporary array, rearranged properly.
		Local $Count = 1
		Local $TempArray[$MaxConnections + 1][11]
		For $i = 1 To $MaxConnections
			If $Connection[$i][0] = -1 Or $Connection[$i][0] = "" Then
				ContinueLoop
			EndIf
			For $j = 0 To 10
				$TempArray[$Count][$j] = $Connection[$i][$j]
			Next
			$Count += 1
		Next
		$TotalConnections = $NewTotalConnections ; Self explanitory.
		$Connection = $TempArray ; Transfer the newly arranged temporary array to our main array.

		; This loop doesn't directly affect anything with the connection, but makes the list numbered (or re-numbered, after the array was fixed.)
		For $i = 1 To $TotalConnections
			GUICtrlSetData($Connection[$i][1], $i)
		Next
	EndIf
EndFunc   ;==>_CheckBadConnection

Func _CheckNewPackets()
	If $TotalConnections < 1 Then
		Return ; If we have no connections, there is no reason to check for bad ones, so return to _Main()
	EndIf
	Local $RecvPacket
	For $i = 1 To $TotalConnections ; Loop through all connections
		$RecvPacket = TCPRecv($Connection[$i][0], $PacketSize) ; Attempt to receive data
		If @error Then ; If there was an error, the connection is probably down.
			_CheckBadConnection() ; So, we call the function to check.
		EndIf
		If $RecvPacket <> "" Then ; If we got data...
			$Connection[$i][2] &= $RecvPacket ; Add it to the packet buffer.
			ConsoleWrite(">> New Packet from " & _SocketToIP($Connection[$i][0]) & @CRLF & "+> " & $RecvPacket & @CRLF & @CRLF) ; Let us know we got a packet in scite.
		EndIf
		If StringInStr($Connection[$i][2], $PacketEND) Then ; If we received the end of a packet, then we will process it.
			Local $RawPackets = $Connection[$i][2] ; Transfer all the data we have to a new variable.
			Local $FirstPacketLength = StringInStr($RawPackets, $PacketEND) - 30 ; Get the length of the packet, and subtract the length of the prefix/suffix.
			Local $PacketType = StringLeft($RawPackets, 18) ; Copy the first 18 characters, since that is where the packet type is put.
			Local $CompletePacket = StringMid($RawPackets, 19, $FirstPacketLength + 11) ; Extract the packet.
			Local $PacketsLeftover = StringTrimLeft($RawPackets, $FirstPacketLength + 41) ; Trim what we are using, so we only have what is left over. (any incomplete packets)
			$Connection[$i][2] = $PacketsLeftover ; Transfer any leftover packets back to the buffer.
			; Writes some stuff to the console for debugging.
			ConsoleWrite(">> Full packet found!" & @CRLF)
			ConsoleWrite("+> Type: " & $PacketType & @CRLF)
			ConsoleWrite("+> Packet: " & $CompletePacket & @CRLF)
			ConsoleWrite("!> Left in buffer: " & $Connection[$i][2] & @CRLF & @CRLF)
			; Since we extracted a packet, we will send it to the processor.
			_ProcessFullPacket($CompletePacket, $PacketType, $i)
		EndIf
	Next
EndFunc   ;==>_CheckNewPackets

; I think the processor is generally easy to understand.  It was made to process any packet that is received in a very organized way, making new additions painless.
; Adding new packet types is easy. Define it at the top, and add a new Case statement in this function.  Packet types are defined as "[PACKET_TYPE_0000]"
; Length of the packet type MUST be the same.  If it's not, it will not be processed.  Thus you should only change the number, 0000-9999.
; We process the packet based on the type.

; $PacketMSG Messages pop up in a message box.
; $PacketPNG PNG gets saved/ran.
; $PacketPCI PC info updates the list view with username and computer name.

Func _ProcessFullPacket($CompletePacket, $PacketType, $ArraySlotNumber)
	Switch $PacketType
		Case $PacketMSG
			TrayTip("New message from " & _SocketToIP($Connection[$ArraySlotNumber][0]), $CompletePacket, 5, 1)
			;MsgBox(0, "New Message", "Message From " & _SocketToIP($Connection[$ArraySlotNumber][0]) & @CRLF & @CRLF & $CompletePacket)
		Case $PacketPNG
			If StringLen($CompletePacket) > 1 Then ; This check must be added because _Base64Decode() will crash the script if it gets empty input.
				Local $Base64DecodedToPNGBinary = _Base64Decode($CompletePacket)
				Local $DateTime = "[" & @MON & "-" & @MDAY & "-" & @YEAR & "] [" & @HOUR & "-" & @MIN & "-" & @SEC & "]"
				Local $File = @ScriptDir & "\" & $DateTime & ".png"
				Local $FileOpen = FileOpen($File, 2)
				FileWrite($FileOpen, $Base64DecodedToPNGBinary)
				FileClose($FileOpen)
				ShellExecute($File)
			Else
				MsgBox(16, "Error", "Received empty PNG packet.")
			EndIf
		Case $PacketPCI
			Local $PacketPCISplit = StringSplit($CompletePacket, "@", 1)
			Local $UserName = $PacketPCISplit[1]
			Local $CompName = $PacketPCISplit[2]
			GUICtrlSetData($Connection[$ArraySlotNumber][1], "|||" & $UserName & "|" & $CompName)
	EndSwitch
EndFunc   ;==>_ProcessFullPacket

Func _ServerListenStart() ; Starts listening.
	If $SocketListen <> -1 Then
		MsgBox(16, "Error", "Socket already open.")
		Return
	Else
		$SocketListen = TCPListen($BindIP, $BindPort, $MaxConnections) ; Starts listening.
		If $SocketListen = -1 Then
			MsgBox(16, "Error", "Unable to open socket.")
		EndIf
	EndIf
EndFunc   ;==>_ServerListenStart

Func _ServerListenStop() ; Stops listening.
	If $SocketListen = -1 Then
		MsgBox(16, "Error", "Socket already closed.")
		Return
	EndIf
	TCPCloseSocket($SocketListen)
	$SocketListen = -1
EndFunc   ;==>_ServerListenStop

Func _ServerClose() ; Exits properly.
	If $TotalConnections >= 1 Then
		For $i = 1 To $TotalConnections
			TCPSend($Connection[$i][0], "SERVER_SHUTDOWN")
			TCPCloseSocket($Connection[$i][0])
		Next
	EndIf
	TCPShutdown()
	_GDIPlus_Shutdown()
	_Crypt_Shutdown()
	DllClose($NTDLL)
	DllClose($WS2_32)
	GUIDelete($GUI)
	Exit
EndFunc   ;==>_ServerClose

Func _SocketToIP($SHOCKET) ; IP of the connecting client.
	Local $sockaddr = DllStructCreate("short;ushort;uint;char[8]")
	Local $aRet = DllCall($WS2_32, "int", "getpeername", "int", $SHOCKET, "ptr", DllStructGetPtr($sockaddr), "int*", DllStructGetSize($sockaddr))
	If Not @error And $aRet[0] = 0 Then
		$aRet = DllCall($WS2_32, "str", "inet_ntoa", "int", DllStructGetData($sockaddr, 3))
		If Not @error Then $aRet = $aRet[0]
	Else
		$aRet = 0
	EndIf
	$sockaddr = 0
	Return $aRet
EndFunc   ;==>_SocketToIP

Func _Sleep($MicroSeconds, $NTDLL = "ntdll.dll") ; Faster sleep than Sleep().
	Local $DllStruct
	$DllStruct = DllStructCreate("int64 time;")
	DllStructSetData($DllStruct, "time", -1 * ($MicroSeconds * 10))
	DllCall($NTDLL, "dword", "ZwDelayExecution", "int", 0, "ptr", DllStructGetPtr($DllStruct))
EndFunc   ;==>_Sleep

Func _ConnectionKill()
	Local $selected = GUICtrlRead(GUICtrlRead($ServerList))
	If Not $selected <> "" Then
		MsgBox(16, "Error", "Please select a connection first.")
		Return
	EndIf
	Local $StringSplit = StringSplit($selected, "|", 1)
	TCPCloseSocket($Connection[$StringSplit[1]][0])
EndFunc   ;==>_ConnectionKill

Func _ConnectionKillAll()
	If $TotalConnections >= 1 Then
		For $i = 1 To $MaxConnections
			If $Connection[$i][0] > 0 Then
				TCPSend($Connection[$i][0], "SERVER_SHUTDOWN")
				TCPCloseSocket($Connection[$i][0])
			EndIf
		Next
	EndIf
EndFunc   ;==>_ConnectionKillAll