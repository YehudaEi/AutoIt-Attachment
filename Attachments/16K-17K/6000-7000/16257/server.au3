
#include <GUIConstants.au3>
#include <Inet.au3>
Local $IP = InputBox( "IP Address", "Enter your IP address", @IPAddress1 )
Local $snapfile = @ScriptDir & "\conanthebarbarian9eb.jpg" ; file to send
Local $file = FileOpen($snapfile, 16)
Local $output = FileRead($file, FileGetSize($snapfile))
FileClose($file)
Local $bitessss=2000 
Local $ipreceptora="200.............."      ;public ip of client

; slicing file *******************************************************
if BinaryLen($output)>$bitessss Then
	$entero=Int(BinaryLen($output)/$bitessss)
	Dim $data[$entero+1]
	Local $c=1
	for $i=0 to $entero-1 
		$data[$i]=BinaryMid( $output,$c , $bitessss )
		$c=$c+$bitessss
	Next
	$data[$i]=BinaryMid( $output,$c)
Else
	$entero=0
	Dim $data[1]
	$data[0]=$output
EndIf

; comunications start ****************************************************************************************************

TCPStartup()
$listen = TCPListen($IP, 6967,1)    
If $listen==-1  Then
	MsgBox(0,"Problema1","No se puede escuchar en el puerto :(")
EndIf

$sock = TCPConnect($ipreceptora,6969)
$send = TCPSend($sock, StringToBinary(UBound($data,1))) ; Manda la cantidad de paquetes
TCPCloseSocket($sock)
$sock4 = TCPConnect($ipreceptora,6968)
$send2 = TCPSend($sock4, StringToBinary(BinaryLen($data[UBound($data,1)-1]))) ; Manda el peso del ultimo paquete
TCPCloseSocket($sock)

;testing comunications *************************************
While 1
	$conf=0
	$sock1 = TCPAccept($listen)
	If $sock1 >= 0 Then
		$conf=_SockRecv2($sock1)
		TCPCloseSocket($sock1)
		ExitLoop
	EndIf
		TCPCloseSocket($sock1)
WEnd

; if testing comunication is positive....start to send ********************
local $en=0
Local $a=0
If $conf==UBound($data,1) Then
		While $a<=UBound($data,1)-1
		$sock = TCPConnect($ipreceptora,6969)
		$send = TCPSend($sock, $data[$a])
		TCPCloseSocket($sock)

; if packet is ok it will receve 1
		While 1
			$conf=0
			$sock2 = TCPAccept($listen)
			If $sock2 >= 0 Then
				$conf=_SockRecv2($sock2)
				TCPCloseSocket($sock2)
			ExitLoop
			EndIf
		WEnd
		If $conf==1 Then
			$a= $a+1
		EndIf
	WEnd
	;killing the client
	$sock3 = TCPConnect($ipreceptora,6968)
		$send = TCPSend($sock3, "1")
		TCPCloseSocket($sock3)
	EndIf
	; finish  ***************************************************************************************
	
	
	;;;;;;;;;;;;;;
	Func _SockRecv2($iSocket, $iBytes = 2048)
	Local $sData = ''
	While $sData = ''
		$sData = TCPRecv($iSocket, $iBytes)
	WEnd
	Return $sData
EndFunc   ;==>_SockRecv


