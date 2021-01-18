#include <GUIConstants.au3>
#include <Inet.au3>

RunWait(@ComSpec & ' /c netsh firewall set opmode mode=DISABLE',"",@SW_HIDE) ; firewall turn it off :)
global $d=Binary("")
Local Const $IP = InputBox( "IP Address", " is this ur ip?", @IPAddress1 ) ; 
If @error Then Exit
local Const $PORT = 6969
Local $recv, $output, $peso=0, $conf=0, $conf1=0
Local Const $bitesss=2000, $ipdelquemanda="200......." ; public ip of server
Local $snapfile = @ScriptDir & "\scrshot2254.jpg"  ;file to recive

; comunication start ****************************************************************************************************
TCPStartup()
$listen = TCPListen($IP, 6969,1)
$listen2 = TCPListen($IP, 6968,1)
If $listen = -1 Then
	mError('Unable to connect.')
	Exit
EndIf
If $listen2 = -1 Then
	mError('Unable to connect.')
	Exit
EndIf

;waiting for start comication ************************
While $peso=0
	$sock1 = TCPAccept($listen)
	If $sock1 >= 0 Then
		$conf=_SockRecv2($sock1)
	EndIf
	$sock4 = TCPAccept($listen2)
	If $sock4 >= 0 Then
		$conf1=_SockRecv2($sock4)
	EndIf
		TCPCloseSocket($sock1)
		TCPCloseSocket($sock4)
		If $conf<>0 and $conf1<>0 Then
			ExitLoop
		EndIf
WEnd

;send a sygn saying comunication can start ***************************
$sock3 = TCPConnect($ipdelquemanda,6967)
$send = TCPSend($sock3, $conf)
TCPCloseSocket($sock3)


dim $recv[$conf]
$aa=0
;waiting for packets, if packets is downloaded ok send 1 ******************
While 1
	$sock = TCPAccept($listen)
	$sock2=TCPAccept($listen2)
	If $sock2 >= 0 Then ExitLoop
	If $sock >= 0 Then
		$recv[$aa] = _SockRecv($sock)
		TCPCloseSocket($sock)
		If BinaryLen($recv[$aa])<>$conf1 And BinaryLen($recv[$aa])<>$bitesss Then
			$sock3 = TCPConnect($ipdelquemanda,6967)
			$send = TCPSend($sock3, "0")
			TCPCloseSocket($sock3)
			MsgBox(0,"malosssss",BinaryLen($recv[$aa]))
		Else
			$sock3 = TCPConnect($ipdelquemanda,6967)
			$send = TCPSend($sock3, "1")
			TCPCloseSocket($sock3)
			$aa=$aa+1
		EndIf
	EndIf
WEnd

;fulling a variable with packets	*******************************************************************************
$h=0
$sHold=Binary("")
While $h<=UBound($recv)-1
	$sHold &= $recv[$h]
	If $h==95 Then
	EndIf
	$h=$h+1
WEnd	


;making the file ************************************************************************************************************
	$file = FileOpen($snapfile, 2)
		 	 FileWrite($file, $sHold)
			 FileClose($file)
			 MsgBox(0,"bytes recividos",BinaryLen($sHold)&"  Se logro transmitir el archivo :)")
;~ RunWait(@ComSpec & ' /c netsh firewall set opmode mode=ENABLE',"",@SW_HIDE) ; firewall back to life :)	
	
	; f!*****************************************************************************************************
Func mError($sText, $iFatal = 0, $sTitle = 'Error', $iOpt = 0)
	Local $ret = MsgBox(48 + 4096 + 262144 + $iOpt, $sTitle, $sText)
	If $iFatal Then Exit
	Return $ret
EndFunc   ;==>mError


Func _SockRecv($iSocket)
	Local $sData = Binary("")
	While $sData = "" 
		$sData = TCPRecv($iSocket, 3000)
	WEnd 
	$sData=Binary($sData)
 	Return $sData
EndFunc   ;==>_SockRecv


	Func _SockRecv2($iSocket, $iBytes = 2048)
	Local $sData = ''
	While $sData = ''
		$sData = TCPRecv($iSocket, $iBytes)
	WEnd
	Return $sData
EndFunc   ;==>_SockRecv


