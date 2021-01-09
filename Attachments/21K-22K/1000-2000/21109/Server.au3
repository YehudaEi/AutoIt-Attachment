#include "TCP.au3"
#include <INet.au3>
#NoTrayIcon
local $users
_TCP_Server_Create(88, @IPAddress1); A server. Tadaa!
_TCP_RegisterEvent($TCP_RECEIVE, "Received")

While 1
    
WEnd
 
Func Received($iError, $sReceived)
	If StringLeft($sReceived, 14) = '||| CONN /ADD:' Then
		$nString = StringReplace($sReceived, '||| CONN /ADD:', '')
		_AddUser($nString)
	ElseIf StringLeft($sReceived, 13) = '||| CONN /GET' then
		$sReceived = '||| CONN /GET::'&$users
		sleep(10)
	ElseIf StringLeft($sReceived, 14) = '||| CONN /DEL:' Then
		_DelUser(StringReplace($sReceived, '||| CONN /DEL:', ''))
	EndIf
	_TCP_Server_Broadcast($sReceived)
EndFunc

Func _AddUser($username)
	if $users = '' Then
		$users = $username
	Else
		$users &= @CRLF&$username
	EndIf
EndFunc

Func _DelUser($username)
	if $users = $username then 
	    $users = ''
	Else
		$users = StringReplace($users, $username, '')
	EndIf
EndFunc

	
