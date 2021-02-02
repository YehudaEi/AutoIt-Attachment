#include-once
#include<Array.au3>
TCPStartup()
Global Const $TCP_EX_DEFAULT_MSGID=BinaryMid(Binary(0),1,2)
Global $TCP_EX_RECV_BUFFER=ObjCreate("Scripting.Dictionary"),$TCP_EX_MSGIDS=ObjCreate("Scripting.Dictionary")
Global $__SOCKETS[1000],$__BUFFERS[1000],$TCP_REGISTER_FUNCTION="_TCP_EX_",$TCP_UNKOWN_MSGID_FUNCTION="__not_defined"
$TCP_EX_RECV_BUFFER.CompareMode=0
Func TCPSendEx($TCP_EX_SOCKET,$TCP_EX_PACKET,$TCP_EX_MSGID=$TCP_EX_DEFAULT_MSGID)
	Local $__send[3],$_send=Binary("")
	If Not IsBinary($TCP_EX_MSGID) Then $TCP_EX_MSGID=Num2Bin($TCP_EX_MSGID)
	If Not IsBinary($TCP_EX_PACKET) Then $TCP_EX_PACKET=Binary($TCP_EX_PACKET)
	$TCP_EX_MSGID=BinaryMid($TCP_EX_MSGID,1,2)
	$__send[0]=Num2Bin(BinaryLen($TCP_EX_PACKET))
	$__send[1]=$TCP_EX_MSGID
	$__send[2]=$TCP_EX_PACKET
	$_send=$__send[0]&$__send[1]&$__send[2]
	Return TCPSend($TCP_EX_SOCKET,$_send)
EndFunc
Func TCPRecvEX($TCP_EX_SOCKET)
	Local $__recv=$__BUFFERS[$TCP_EX_RECV_BUFFER($TCP_EX_SOCKET)]
	$__recv&=TCPRecv($TCP_EX_SOCKET,2^8,1)
	If @error Then Return SetError(@error,0,"")
	If $__recv="" Then Return ""
	If BinaryLen($__recv)<6 Then ; didn't get the header
		$__BUFFERS[$TCP_EX_RECV_BUFFER($TCP_EX_SOCKET)]=$__recv
		Return
	EndIf
	Local $__packet_len=Bin2Num(BinaryMid($__recv,1,4))
	Local $__msg_id=Bin2Num(BinaryMid(Bin2Num(BinaryMid($__recv,5,2)),1,2))
	If BinaryLen($__recv)<$__packet_len+6 Then
		$__BUFFERS[$TCP_EX_RECV_BUFFER($TCP_EX_SOCKET)]=$__recv
		Return
	EndIf
	If BinaryLen($__recv) > $__packet_len+6 Then
		$__BUFFERS[$TCP_EX_RECV_BUFFER($TCP_EX_SOCKET)]=BinaryMid($__recv,7+$__packet_len)
		$__recv=BinaryMid($__recv,1,$__packet_len+6)
	Else
		$__BUFFERS[$TCP_EX_RECV_BUFFER($TCP_EX_SOCKET)]=Binary("")
	EndIf
	Return SetExtended(Int($__msg_id),BinaryMid($__recv,7))
EndFunc
Func _TCPRecvEX($TCP_EX_SOCKET)
	$recv=TCPRecvEX($TCP_EX_SOCKET)
	$msgid=@extended ; the message id of the packet
	If @error Then Return SetError(1,0,0*MsgBox(0 , "recv" , @error,1)) ; if an error occurs bail
	If $recv Then ;i have some data
		If Not IsObj($TCP_EX_MSGIDS) Or Not $TCP_EX_MSGIDS.exists($msgid) Then
			Call($TCP_REGISTER_FUNCTION&$TCP_UNKOWN_MSGID_FUNCTION,$msgid,$recv)
		Else
			Call($TCP_REGISTER_FUNCTION&$TCP_EX_MSGIDS($msgid),$recv)
		EndIf
	EndIf
EndFunc
Func _TCP_EX___not_defined($packet,$recv)
	ConsoleWrite("msgid not function!:" &$packet & @CRLF)
EndFunc
Func TCPListenEx($TCP_EX_IPADDR=@IPAddress1,$TCP_EX_PORT=8081)
	Local $__sock=TCPListen($TCP_EX_IPADDR,$TCP_EX_PORT)
	If @error Then Return SetError(@error,0,0)
	$TCP_EX_RECV_BUFFER($__sock)=__get_free_socket($__sock)
	If @error Then Return SetError(@error,0,0)
	Return $__sock
EndFunc
Func TCPConnectEx($TCP_EX_IPADDR=@IPAddress1,$TCP_EX_PORT=8081)
	Local $__sock=TCPConnect($TCP_EX_IPADDR,$TCP_EX_PORT)
	If @error Then Return SetError(@error,0,0)
	$TCP_EX_RECV_BUFFER($__sock)=__get_free_socket($__sock)
	If @error Then Return SetError(@error,0,0)
	Return $__sock
EndFunc
Func TCPCloseSocketEx($TCP_EX_SOCKET)
	Local $__close_sock=TCPCloseSocket($TCP_EX_SOCKET)
	If @error Then Return SetError(@error,0,0)
	If Not $TCP_EX_RECV_BUFFER.exists($TCP_EX_SOCKET) Then Return SetError(1,0,0)
	$__SOCKETS[$TCP_EX_RECV_BUFFER($TCP_EX_SOCKET)]=0
	$TCP_EX_RECV_BUFFER.remove($TCP_EX_SOCKET)
EndFunc
Func TCPAcceptEx($TCP_EX_SOCKET)
	Local $__accept = TCPAccept($TCP_EX_SOCKET)
	If @error Or $__accept = -1 Then Return SetError(1,0,0)
	$TCP_EX_RECV_BUFFER($__accept)=__get_free_socket($__accept)
	If @error Then Return SetError(2,0,0)
	Return $__accept
EndFunc
Func __get_free_socket($_socket)
	For $i=1 To 1000
		If $__SOCKETS[$i]=0 Then
			$__SOCKETS[$i]=$_socket
			Return $i
		EndIf
	Next
	Return SetError(1,0,0)
EndFunc
Func _TCP_EX_REGISTER_FUNC($func)
	$TCP_REGISTER_FUNCTION=$func
EndFunc
Func _TCP_EX_REGISTER_ID($id,$func)
	$TCP_EX_MSGIDS($id)=$func
EndFunc
Func _TCP_EX_REGISTER_UNKOWN($func)
	$TCP_UNKOWN_MSGID_FUNCTION=$func
EndFunc
Func Num2Bin($bin,$diff=0)
	$len=4+$diff
    $binar = DllStructCreate("byte["&$len&"]")
    $intreg = DllStructCreate("int", DllStructGetPtr($binar))
    DllStructSetData($intreg,1,$bin)
    Return DllStructGetData($binar, 1)
EndFunc
Func Bin2Num($bin)
    $integ = DllStructCreate("int")
    $binar = DllStructCreate("byte[4]", DllStructGetPtr($integ))
    DllStructSetData($binar,1,$bin)
    Return DllStructGetData($integ, 1)
EndFunc
