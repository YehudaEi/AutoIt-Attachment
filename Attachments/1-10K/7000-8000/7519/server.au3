;SERVER!! Start Me First !!!!!!!!!!!!!!!
#include <G:\Programs\autoit-v3_beta\include\GUIConstants.au3>

$g_IP = @IPAddress1
$g_PORT = "3333"

; Create a Listening "SOCKET"
;==============================================
$MainSocket = _TCPCreateMainListeningSocket($g_IP, $g_PORT, 5)
If @ERROR Or $MainSocket = -1 Then Exit

; Initialize a variable to represent a connection
;==============================================
Dim $ConnectedSocket = -1
Global $CSock[1]
$CSock[0] = 0
Global $Nicks[1]

; GUI Message Loop
;==============================================
While 1
    $ConnectedSocket = TCPAccept($MainSocket)
    If @ERROR = 0 And $ConnectedSocket > -1 Then
        AddSocket($ConnectedSocket)
    EndIf

    If $CSock[0] > 0 Then
        $br = ""
        For $n = 1 to $CSock[0]
            $ret = TCPRecv($CSock[$n], 1024)
            If @error <> 0 Then
                $br = $br & $n & @LF
            ElseIf $ret <> "" Then
                Process($ret, $n)
				;Broadcast($ret)
            EndIf
        Next
        If $br <> "" Then
            $br = StringSplit(StringTrimRight($br,1),@LF)
            For $n = 1 to $br[0]
                RemoveSocket(Int($br[$n]))
            Next
        EndIf
    EndIf
    Sleep(20)
WEnd

Func RemoveSocket($instance)
	
	Broadcast("#BROADCAST" & chr(2) & $Nicks[$instance] & " left the chat.")
	
    Dim $aTemp[$CSock[0]]
	Dim $aNicksTemp[$CSock[0]]
	
    $aTemp[0] = $CSock[0] - 1
    $RS_i = 1
    If $aTemp[0] > 0 Then
        For $RS_n = 1 to $CSock[0]
            If $RS_n <> $instance Then
				$aNicksTemp[$RS_i] = $Nicks[$RS_n]
                $aTemp[$RS_i] = $CSock[$RS_n]
                $RS_i = $RS_i + 1
            EndIf
        Next
    EndIf
    $CSock = $aTemp
	$Nicks = $aNicksTemp
EndFunc

Func Broadcast($szData)
    For $B_n = 1 to $CSock[0]
        ;TCPSend($CSock[$B_n],$CSock[0] & "-" & $szData)
        TCPSend($CSock[$B_n],$szData)
    Next
EndFunc

Func OnAutoItExit()
    For $n = 1 to $CSock[0]
        TCPCloseSocket($CSock[$n])
    Next
   TCPCloseSocket($MainSocket )
   TCPShutDown()
EndFunc

Func AddSocket($AS_sock)
    $AS_n = $CSock[0] + 1
    ReDim $CSock[$AS_n + 1]
	ReDim $Nicks[$AS_n + 1]
    $CSock[0] = $AS_n
    $CSock[$AS_n] = $AS_sock
	TCPSend($CSock[$AS_n],"#ACKCONNECTION" & chr(2) & $AS_n)
EndFunc

Func _TCPCreateMainListeningSocket($szIP, $szPort, $szNumConnect)
    TCPStartup()
    $TCMLS_MainSocket = TCPListen($szIP, $szPORT, $szNumConnect)
    If @ERROR Or $TCMLS_MainSocket = -1 Then Return -1
    Return $TCMLS_MainSocket
EndFunc

Func Process($data, $sockNbr)
	$dataArray = StringSplit($data,chr(2),1)
	$dataHeader = $dataArray[1]
	Select 
	Case $dataHeader = "#CHATSAY"
		Broadcast("#CHATSAY" & chr(2) & $Nicks[$sockNbr] & chr(2) &  $dataArray[2])
	Case $dataHeader = "#ACKCONNECTION"
		$Nicks[$sockNbr] = $dataArray[2]
		Broadcast("#BROADCAST" & chr(2) & $Nicks[$sockNbr] & " joined the chat.")
	Case $dataHeader = "#SLASHCMD_RANDOM"
		$rndNbr = Random(0,999,1)
		Broadcast("#RANDOM" & chr(2) & $Nicks[$sockNbr] & chr(2) & $rndNbr)
	EndSelect
EndFunc
