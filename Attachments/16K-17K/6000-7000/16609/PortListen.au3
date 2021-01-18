#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_outfile=PortListen.exe
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
; Introduction Message.....
;==============================================

#include <Date.au3>
$Msgbox=MsgBox(33,"V2.0 - Written by Grant Wilcockson August 2007", "Port Range listening program. Timeout in 10 Seconds if OK not chosen",10)
If $Msgbox = 2 Then Exit
If $Msgbox = -1 Then Exit

;SERVER!! Start Me First !!!!!!!!!!!!!!!
$g_IP = "127.0.0.1"

$min=InputBox("Make port range > 5000","Please input the begining number of the port range you would like this machine to listen on",1)
    If @error = 1 Then Exit
$max=InputBox("Make port range > 5000","Please input the ending number of the port range you would like this machine to listen on",1000)
    If @error = 1 Then Exit

$Diff=$Max-$Min
If $Diff>5000 Then
	MsgBox(0,"", "Please do not choose a range of more that 5000 Ports to listen on at one time. Please try again")
	Exit
EndIf

; Start The TCP Services
;==============================================
TCPStartUp()

; Create a Listening "SOCKET"
;==============================================
For $i =$min to $max Step 1
    $MainSocket = TCPListen($g_IP, $i)
	ProgressOn("Progress Meter", "Port listening", "port 0 now listening")
	ProgressSet( $i/$max*100, "port "&$i&" now listening")
Next
ProgressOff()

;  look for client connection
;--------------------
While 1
$ConnectedSocket = TCPAccept( $MainSocket)
$Msgbox=MsgBox(0,"This listening program was started at "&_NowTime(), "Ports "&$min&" - "&$max&" now listening on this machine! This program will automatically close in 30 min or click OK button to close program now.",1800)
If $Msgbox = 1 Then Exit
If $Msgbox = -1 Then Exit
Wend
