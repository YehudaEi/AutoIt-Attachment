#include "TCP.au3"
If Not _TCP_Client_Start("127.0.0.1", 30213) Then Exit

_TCP_Client_SetOnEvent($Tcp_Client_Event_Close,'_On_Close')
_TCP_Client_SetOnEvent($Tcp_Client_Event_Recv,'_On_Recv')

$Gui = GUICreate('Test Client',600,400)
$Edit1 = GUICtrlCreateEdit('',5,5,590,355)
$Input1 = GUICtrlCreateInput('', 5, 370,540,20)
$Button1 = GUICtrlCreateButton('Send', 550, 370, 45, 20)
GUISetState()

While 1
	$msg = GUIGetMsg()
	Switch $msg
		Case -3
			Exit
		Case $Button1
			_TCP_Client_Send('Msg' & GUICtrlRead($Input1))
			GUICtrlSetData($Input1,'')
	EndSwitch
WEnd

Func _On_Close()
	MsgBox(0,'Error','Lost Connection to the server!')
	Exit
EndFunc

Func _On_Recv($s_msg)
	Switch StringLeft($s_msg,3)
		Case 'Msg'
			GUICtrlSetData($Edit1, GUICtrlRead($Edit1) & StringTrimLeft($s_msg,3) & @CRLF)
	EndSwitch
EndFunc

Func OnAutoitExit()
	_TCP_Client_Stop()
EndFunc