#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_icon=Images\icon.ico
#AutoIt3Wrapper_outfile=IK-Chat Client.exe
#AutoIt3Wrapper_Compression=4
#AutoIt3Wrapper_Run_Tidy=y
#Tidy_Parameters=/rel /sf /sfc
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#include <guiconstants.au3>
Global $connect_port = 34000
$ip = ("Server ip here.")
TCPStartup()
$socket = TCPConnect($ip, $connect_port)
If $socket = -1 Then
	Exit
EndIf
Do
	Do
		$user = InputBox("Connected", "Connection established please type in your desired Username")
		If @error = 1 Then
			$end = MsgBox(4, "End client", "Sure you want to exit?")
			If $end = 6 Then
				Exit
			EndIf
		EndIf
	Until StringLen($user) > 3 And StringLen($user) < 12
	TCPSend($socket, "us:" & $user)
	Do
		$recv = TCPRecv($socket, 512)
		If $recv = "password"  Then
			$pw = InputBox("Password required", "Please type in the password for " & $user, "", "*")
			TCPSend($socket, "pw:" & $pw)
		EndIf
	Until $recv = "accepted"  Or $recv = "rejected"  Or @error = 1
Until $recv = "accepted"  Or $recv = "rejected" 
If $recv = "rejected"  Then
	MsgBox(0, "Failure", "Maximum number of users reached or Server currently not availible, please try again later")
	Exit
EndIf
$main = GUICreate("Chronos Chat @ " & $user, 450, 200, -1, -1, BitOR($WS_OVERLAPPEDWINDOW, $WS_CLIPSIBLINGS))
$input = GUICtrlCreateInput("", 20, 170, 280, 20)
$edit = GUICtrlCreateEdit("", 20, 30, 270, 120, $ES_READONLY + $ES_MULTILINE + $WS_VSCROLL + $ES_AUTOVSCROLL)
$userlist = GUICtrlCreateEdit("", 330, 30, 100, 120, $ES_READONLY + $ES_MULTILINE + $WS_VSCROLL + $ES_AUTOVSCROLL)
$send = GUICtrlCreateButton("Send", 320, 170, 120, 20, $BS_DEFPUSHBUTTON)
$chatgroup = GUICtrlCreateGroup("Chat", 10, 10, 290, 150)
$usergroup = GUICtrlCreateGroup("Users", 320, 10, 120, 150)
GUICtrlSetState($input, $GUI_FOCUS)
GUISetState()
While 1
	$msg = GUIGetMsg()
	If $msg = $GUI_EVENT_CLOSE Then
		TCPSend($socket, "bye")
		Sleep(5000)
		TCPShutdown()
		Exit
	EndIf
	If $msg = $send Then
		If GUICtrlRead($input) <> "" Then
			TCPSend($socket, GUICtrlRead($input))
			GUICtrlSetData($input, "")
		EndIf
	EndIf
	$recv = TCPRecv($socket, 512)
	$err = @error
	If $recv = "bye"  Then
		GUICtrlSetData($edit, "Connection Lost" & @CRLF & GUICtrlRead($edit))
		TCPShutdown()
		ExitLoop
	EndIf
	If $recv <> "" And $err = 0 And Not StringInStr($recv, "users:") Then
		GUICtrlSetData($edit, $recv & @CRLF & GUICtrlRead($edit))
	EndIf
	If StringInStr($recv, "users:") Then
		$users = StringTrimLeft($recv, 8)
		$users = StringReplace($users, "|", @CRLF)
		GUICtrlSetData($userlist, $users)
	EndIf
WEnd
Func OnAutoItExit()
	TCPSend($socket, "bye")
	TCPCloseSocket($socket)
	TCPShutdown()
EndFunc   ;==>OnAutoItExit