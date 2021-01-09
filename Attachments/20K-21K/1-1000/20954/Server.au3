#include "TCP.au3"
If Not _TCP_Server_Start("127.0.0.1", 30213) Then Exit

_TCP_Server_SetOnEvent($Tcp_Server_Event_Open, 	"_On_Connect")
_TCP_Server_SetOnEvent($Tcp_Server_Event_Close,	"_On_Close")
_TCP_Server_SetOnEvent($Tcp_Server_Event_Recv,	"_On_Recv")

While 1
	Sleep(100)
WEnd

Func _On_Close($s_Id)
	ConsoleWrite($s_Id & '->left' & @CRLF) ;Debug, for fun :P
EndFunc

Func _On_Connect($s_Id)
	ConsoleWrite($s_Id & '->Connected' & @CRLF) ;Debug, for fun :P
EndFunc

Func _On_Recv($s_Recv, $s_Id)
	ConsoleWrite($s_Id & '->message-> '  & $s_Recv & @CRLF) ;Debug, for fun :P
	_TCP_Server_Send($s_Recv)
EndFunc

Func OnAutoitExit()
	_TCP_Server_Stop()
EndFunc