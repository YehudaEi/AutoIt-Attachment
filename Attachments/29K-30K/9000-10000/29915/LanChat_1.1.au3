#cs ----------------------------------------------------------------------------

 DELmE's LanChat

#ce ----------------------------------------------------------------------------

;include files
#include <GuiConstants.au3>
#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <WindowsConstants.au3>
#include <GuiEdit.au3>

;define variables
Global $hGui, $hEdit, $hInp, $hBtn, $username, $rsock, $ssock, $recv
Global $port = 7892
Global $Broadcast = StringLeft(@IPAddress1, StringInStr(@IPAddress1, ".", 0, 3)) & "255"

;start main function
_main()
Func _main()
	;get username
	$username = InputBox("LanChat","Please enter your username.")
	If $username = "" Then
		MsgBox(16,"Error","A username must be entered.")
		Exit
	EndIf
	;create gui
	$hGui = GUICreate("LanChat",500,500)
	$hEdit = GUICtrlCreateEdit("Welcome to DELmE's LanChat",0,0,500,480,BitOR($ES_READONLY,$ES_WANTRETURN,$WS_VSCROLL,$ES_AUTOVSCROLL))
	_GUICtrlEdit_SetLimitText($hEdit,99999999999999)
	$hInp = GUICtrlCreateInput("",0,480,470,20)
	$hBtn = GUICtrlCreateButton("Send",470,480,30,20,$BS_DEFPUSHBUTTON)
	;display gui
	GUISetState()
	;start winsock for udp
	UDPStartup()
	;bind a socket to the port for listening
	$rsock = UDPBind(@IpAddress1,$port)
	If @error <> 0 Then Exit
	;send message informing of online status
	SendMsg("-"&$username&" has come online.")
	;start gui loop
	Do
		$recv = UDPRecv($rsock,1024)
		If $recv <> "" Then
			Print($recv)
		EndIf
		$msg = GUIGetMsg()
		If $msg = $hBtn Then
			$buffer = GUICtrlRead($hInp)
			If $buffer <> "" Then
				GUICtrlSetData($hInp,"")
				SendMsg("<"&$username&">: "&$buffer)
			EndIf
		EndIf
	Until $msg = $GUI_EVENT_CLOSE
	Exit
EndFunc ;==> _main

Func SendMsg($txtMsg)
        $ssock = UDPOpen($Broadcast,$port)
        If @error = 0 Then
            UDPSend($ssock,$txtMsg)
        EndIf
        UDPCloseSocket($ssock)
EndFunc ;==> SendMsg

Func Print($txtMsg)
	_GUICtrlEdit_AppendText($hEdit,@CRLF&$txtMsg)
EndFunc ;==> Print

Func OnAutoItExit()
	;send message informing of offline status
	SendMsg("-"&$username&" has gone offline.")
	UDPShutdown()
EndFunc ;==> OnAutoItExit