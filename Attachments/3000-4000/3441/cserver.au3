Dim $ClientSock[2]
Dim $UserName[2]
Dim $recv
Dim $cn
Dim $socket
Dim $Active
Dim $loopcount
Dim $c
Dim $d
Dim $e
Dim $f
Dim $r

$cn = 0
$Active = 0
$loopcount = 0

TCPStartup()

$socket = TCPListen(@IPAddress1, 33000)

While 1
	Call("Connect")
	Call("Recieve")
	Call("SocketStatus")
	$loopcount = $loopcount + 1
WEnd
	
Func Connect()
	$connect = TCPAccept($socket)
	If $connect >= 0 Then
		$cn = $cn + 1
		If $cn > 1 Then ReDim $ClientSock[$cn + 1]
		If $cn > 1 Then ReDim $UserName[$cn + 1]
		$ClientSock[$cn] = $connect
	EndIf
EndFunc

Func Recieve()
For $c = 0 to $cn Step 1
	$recv = TCPRecv($ClientSock[$c], 512)
	$r = $c
	If $recv <> "" Then 
		Call("Process")
	EndIf
Next
EndFunc

Func Process()
	If StringLeft($recv, 12) = "@*USERNAME*@" Then Call("Username")
	For $d = 0 to $cn Step 1
		If StringLeft($recv, 2) = "@*" Then ExitLoop
		TCPSend($ClientSock[$d], $UserName[$r] & $recv)
	Next
EndFunc

Func Username()
	$UserName[$r] = (StringTrimLeft($recv, 12) & ": ")
	$f = 0
	For $e = 0 to $cn Step 1
		If $Username[$e] = $Username[$r] Then $f = $f + 1
	Next
	If $f > 1 Then 
		TCPSend($ClientSock[$r], "@*INUSE*@")
		$UserName[$r] = "@*NULL*@"
	EndIf
EndFunc

Func SocketStatus()
If $loopcount > 100 Then
	For $c = 0 to $cn Step 1	
		$SendStat = TCPSend($ClientSock[$c], "@*PING*@")
		If $SendStat = 0 Then
			TCPCloseSocket($ClientSock[$c])
			$UserName[$c] = "@*NULL*@"
		EndIf
	Next
	$loopcount = 0
EndIf
EndFunc