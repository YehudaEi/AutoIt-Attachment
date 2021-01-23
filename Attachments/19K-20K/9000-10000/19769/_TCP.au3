#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.2.11.1 (beta)
 Author:         myName

 Script Function:
	
	de kans is 1 op 46656 dat er twee dezelfde alias'en zijn

#ce ----------------------------------------------------------------------------

; Script Start - Add your code below here

#include <Inet.au3>

Global $Ws2_32 = DllOpen('Ws2_32.dll')

Global $Tcp_Connections[1]
		$Tcp_Connections[0] = 0



; // ==== KTP Functions

Func _KTP_Server_Recieve($cCreate)
	
	
	_TCP_Server_Update($cCreate)
	
	$Recieve = _TCP_Server_Recieve()
	$Recv_Client = $Recieve[0]
	$Recv_Text 	 = StringTrimLeft($Recieve[1],4)
	$Recv_Alias = StringLeft($Recieve[1],3)
	
	Dim $Return[3]
	
	If $Recv_Alias Then
		
		$Return[0] = $Recv_Client
		$Return[1] = $Recv_Alias
		$Return[2] = $Recv_Text
		
	EndIf
	
	Return $Return
	
EndFunc

Func _KTP_Client_Recieve($cCreate)
	
	Dim $Return[3]
	
	$Recieve = _TCP_Client_Recieve($cCreate)
	$Recv_Text 	 = StringTrimLeft($Recieve,4)
	$Recv_Alias = StringLeft($Recieve,3)
	
	If $Recv_Alias Then
		
		$Return[1] = $Recv_Alias
		$Return[2] = $Recv_Text
		
	EndIf
	
	Return $Return
	
EndFunc

Func _KTP_Client($Recv)
	Return $Recv[0]
EndFunc

Func _KTP_Alias($Recv)
	Return $Recv[1]
EndFunc

Func _KTP_Text($Recv)
	Return $Recv[2]
EndFunc

Func _KTP_Send($To, $String, $Alias=0)
	
	If not $Alias Then
		
		$Random = Random(0,1,1)
		if $Random Then
			$1 = Random(48,57,1)
		Else
			$1 = Random(97,122,1)
		EndIf
		$1 = String(Chr($1))
		
		$Random = Random(0,1,1)
		if $Random Then
			$2 = Random(48,57,1)
		Else
			$2 = Random(97,122,1)
		EndIf
		$2 = String(Chr($2))
		
		$Random = Random(0,1,1)
		if $Random Then
			$3 = Random(48,57,1)
		Else
			$3 = Random(97,122,1)
		EndIf
		$3 = String(Chr($3))
		
		$Alias = $1 & $2 & $3
		
	EndIf
	
	TCPSend($To,$Alias& ":" &$String)
	
	Return $Alias
	
EndFunc


Func _TCP_CorrectIP($Server_PublicIP, $Server_LocalIP)
	
	$PublicIP = _GetIP()
	
	$ConnectTo_IP = $Server_PublicIP
	
	If $PublicIP = $Server_PublicIP Then ; You're in the same network
		
		$ConnectTo_IP = $Server_LocalIP
		
	EndIf
	
	Return $ConnectTo_IP
	
EndFunc


func _TCP_SocketToIP($sock)
	local $sockAddr = dllStructCreate('short;ushort;uint;char[8]')
	local $aRet = dllCall($Ws2_32, 'int', 'getpeername', _
		'int', $sock, _
		'ptr', dllStructGetPtr($sockAddr), _
		'int*', dllStructGetSize($sockAddr))
	if (not @error and $aRet[0] = 0) then
		$aRet = dllCall($Ws2_32, 'str', 'inet_ntoa', _
			'int', dllStructGetData($sockAddr, 3))
		if (not @error) then
			$aRet = $aRet[0]
		endIf
	else
		$aRet = 0
	endIf
	$sockAddr = 0
	return $aRet
endFunc

Func _TCP_Client_Create($Server, $Port)
	Return TCPConnect($Server, $Port)
EndFunc

Func _TCP_Client_Recieve($cCreate)
	$Recv = TCPRecv($cCreate,1024)
	If $Recv Then Return $Recv
	Return $Recv
EndFunc

Func _TCP_Client_Send($cCreate, $SendString)
	TCPSend($cCreate,$SendString)
EndFunc

Func _TCP_Client_Destroy($cCreate)
	TCPCloseSocket($cCreate)
EndFunc

Func _TCP_Client_SendRecieve($cCreate, $SendString)
	
	_TCP_Client_Send($cCreate, $SendString)
	Do
		$cRecieved = _TCP_Client_Recieve($cCreate)
	Until $cRecieved
	
	Return $cRecieved
	
EndFunc

; // ==== Server commands

Func _TCP_Server_Send($sUpdate, $SendString)
	TCPSend($sUpdate,$SendString)
EndFunc

Func _TCP_Server_ClientList()
	
	Dim $Return[1]
		$Return[0] = 0
	
	For $i = 1 to $Tcp_Connections[0]
		If $Tcp_Connections[$i] Then
			ReDim $Return[UBound($Return)+1]
				$Return[UBound($Return)-1] = $Tcp_Connections[$i]
				$Return[0] += 1
		EndIf
	Next
	
	Return $Return
	
EndFunc

Func _TCP_Server_Recieve()
	
	dim $Return[2]
		$Return[0] = ""
		$Return[1] = ""
	
	For $i = 1 to $Tcp_Connections[0]
		If $Tcp_Connections[$i] Then
			
			$Recv = TCPRecv($Tcp_Connections[$i],1024)
			
			If $Recv then 
				$Return[0] = $Tcp_Connections[$i]
				$Return[1] = $Recv
				Return $Return
			EndIf
		EndIf
	Next
	
	Return $Return
	
EndFunc

Func _TCP_Server_Update($sCreate)
	
	$Accept = TCPAccept($sCreate)
	
	If $Accept Then
		for $i = 1 to $Tcp_Connections[0]
			If $Accept = $Tcp_Connections[$i] Then Return
		Next
		
		for $i = 1 to $Tcp_Connections[0]
			if not $Tcp_Connections[$i] Then
				
				$Tcp_Connections[$i] = $Accept
				
				Return
			EndIf
		Next
		
		ReDim $Tcp_Connections[UBound($Tcp_Connections)+1]
		$Tcp_Connections[UBound($Tcp_Connections)-1] = $Accept
		$Tcp_Connections[0] += 1
	EndIf
EndFunc

Func _TCP_Server_Create($Server, $Port, $PendingConnections=-1)
	Return TCPListen($Server,$Port, $PendingConnections)
EndFunc

Func _TCP_Server_ClientClose($sRecv)
	
	TCPCloseSocket($sRecv)
	
	for $i = 1 To $Tcp_Connections[0]
		If $Tcp_Connections[$i] = $sRecv Then
			$Tcp_Connections[$i] = ""
			ExitLoop
		EndIf
	Next
	
EndFunc

Func _TCP_Server_Close($sCreate)
	TCPCloseSocket($sCreate)
EndFunc