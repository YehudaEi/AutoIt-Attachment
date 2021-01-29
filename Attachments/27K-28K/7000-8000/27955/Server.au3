#include <DBIni.au3>
#include <TCP.au3>
#include <Array.au3>
#include <File.au3>

#cs _TCP_RegisterEvent()
	$TCP_SEND: 			When you send something.								:	Function($hSocket, $iError)
	$TCP_RECEIVE:		If something is received.								:	Function($hSocket, $sReceived, $iError)
	$TCP_CONNECT:		When you connect to the server. (Client only)			:	Function($hSocket, $iError)
	$TCP_DISCONNECT:	When a connection is closed.							:	Function($hSocket, $iError)
	$TCP_NEWCLIENT:		When a new client connects to the server. (Server only)	:	Function($hSocket, $iError)
#ce

Global Const $iPort = "8080"
Global Const $sIP = @IPAddress1
Global Const $LogPath = @ScriptDir & "\Server Log.txt"
Global $ClientNumber = 0
Dim $Clients[1][2] = [["Client Handle", "Client IP"]]

$ServerSocket = _TCP_Server_Create($iPort, $sIP)

_TCP_RegisterEvent($ServerSocket, $TCP_NEWCLIENT, "RegisteredEvent_NewClient")
_TCP_RegisterEvent($ServerSocket, $TCP_DISCONNECT, "RegisteredEvent_ClientDisconnected")
_TCP_RegisterEvent($ServerSocket, $TCP_RECEIVE, "RegisteredEvent_Receive")

While 1
WEnd

#Region Registered Events
Func RegisteredEvent_NewClient($hSocket, $iError)
	Local $i

	$ClientNumber += 1 ;reset the number of clients currently active
	ReDim $Clients[$ClientNumber + 1][2] ;resize the array to compensate the new client
	$Clients[$ClientNumber][0] = $hSocket ;set the newly created array index to the client handle
	_TCP_Send($Clients[$ClientNumber][0], "##CONNECTED##") ;tell the client that they have been accepted
	$Clients[$ClientNumber][1] = _TCP_Server_ClientIP($hSocket)

	__WriteLog($hSocket & " has just connected")
EndFunc   ;==>RegisteredEvent_NewClient

Func RegisteredEvent_ClientDisconnected($hSocket, $iError)
	$ClientNumber -= 1 ;reset the number of clients currently active
	Local $index = _ArraySearch($Clients, $hSocket) ;find out the index of the client that just disconnected
	_ArrayDelete($Clients, $index) ;delete the client from the array

	__WriteLog($hSocket & " has just disconnected") ;write log
EndFunc   ;==>RegisteredEvent_ClientDisconnected

Func RegisteredEvent_Receive($hSocket, $sReceived, $iError)
	Local $ReturnValue = ""
;~ 	__WriteLog("Server Received " & $sReceived & " from " & $hSocket)
	If StringLeft($sReceived, 11) == "##MESSAGE##" Then
		_TCP_Server_Broadcast($sReceived)
	ElseIf $sReceived == "##PING##" Then
		$Send = _TCP_Send($hSocket, "##PINGRECEIVED##")
		__WriteLog($hSocket & " pinged the server from ip address: " & _TCP_Server_ClientIP($hSocket))
	ElseIf StringLeft($sReceived, 20) == "##USERVERIFICATION##" Then
		;verify usernames and passwords from a database on the same computer as the server
		$LoginDB = _DBIniReadSection(@ScriptDir & "\Login.database", "Users")
		$Login = StringSplit(StringTrimLeft($sReceived, 20), @TAB, 2)
		For $i = 1 To $LoginDB[0][0]
			If $LoginDB[$i][0] = $Login[0] Then
				If $LoginDB[$i][1] == $Login[1] Then
					$ReturnValue = "1"
					ExitLoop
				Else
					$ReturnValue = "0"
					ExitLoop
				EndIf
			EndIf
		Next
		_TCP_Send($hSocket, "##USERVERIFICATION##" & $ReturnValue)
	EndIf
EndFunc   ;==>RegisteredEvent_Receive
#EndRegion Registered Events

Func __WriteLog($sMessage)
	_FileWriteLog($LogPath, $sMessage, 1)
EndFunc   ;==>__WriteLog

Func OnAutoItExit()
	_TCP_Server_Stop()
EndFunc   ;==>OnAutoItExit
