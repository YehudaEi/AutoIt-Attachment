;client for 100client-server
;made by Marten Zimmermann

#include <guiconstants.au3>
global $connect_port = 34000

$ip = InputBox ("IP-Adress", "Gimme the IP-Adress of the Server", @IPAddress1)

tcpstartup()

$socket = tcpconnect ($ip, $connect_port)
if $socket = -1 then
	Exit
EndIf

Do
	Do
		$user = InputBox ("Connected", "Connection established please type in your desired Username")
		if @error = 1 Then
			$end = msgbox (4, "End client", "Sure you want to exit?")
			if $end = 6 Then
				Exit
			EndIf
		EndIf
	until StringLen ($user) > 2 and StringLen ($user) < 12
	tcpsend ($socket, "~~us:" & $user)

	Do
		$recv = tcprecv ($socket, 512)
		if $recv = "~~password" Then
			$pw = InputBox ("Password required", "Please type in the password for " & $user, "", "*")
			tcpsend ($socket, "~~pw:" & $pw)
		EndIf
	until $recv = "~~accepted" or $recv = "~~rejected" or @error = 1
until $recv = "~~accepted" or $recv = "~~rejected"

if $recv = "~~rejected" Then
	msgbox (0, "Failure", "Maximum number of users reached or Server currently not availible, please try again later")
	Exit
EndIf

$main = GUICreate ("Chat Client - Connection established: " & $user, 500, 200)
$input = GUICtrlCreateInput ("", 10, 10, 280)
$edit = GUICtrlCreateEdit ("", 10, 40, 280, 110, $ES_READONLY + $ES_MULTILINE + $WS_VSCROLL + $ES_AUTOVSCROLL)
$userlist = GUICtrlCreateEdit ("", 300, 10, 190, 180, $ES_READONLY + $ES_MULTILINE + $WS_VSCROLL + $ES_AUTOVSCROLL)
$send = GUICtrlCreateButton ("Send", 10, 160, 280, 20, $BS_DEFPUSHBUTTON)
GUICtrlSetState ($input, $GUI_FOCUS)
GUISetState(@SW_SHOW)

while 1
	$msg = GUIGetMsg()
	if $msg = $GUI_EVENT_CLOSE Then
		tcpsend ($socket, "~~bye")
		sleep (5000)
		tcpshutdown()
		Exit
	EndIf
	
	if $msg = $send Then
		if guictrlread ($input) <> "" Then
			tcpsend ($socket, guictrlread($input))
			GUICtrlSetData ($input, "")
		EndIf
	EndIf
	
	$recv = tcprecv ($socket, 512)
	$err = @error
	
	if $recv = "~~bye" Then
		GUICtrlSetData ($edit, "~~Connection Lost" & @CRLF & GUICtrlRead($edit))
		tcpshutdown()
		ExitLoop
	EndIf
	
	if StringInStr ($recv, "~~kick:") and stringinstr($recv, $user, 1) then
		TCPSend ($socket, "~~bye")
		GUICtrlSetData ($edit, "You have been kicked!" & @crlf & guictrlread($edit))
		sleep (2000)
		TCPShutdown()
		ExitLoop
	EndIf
	
	$priv = 0
	if StringInStr ($recv, "~~pm:") and stringinstr($recv, $user) then
		$user1 = $user & " "
		if StringInStr ($recv, $user1) Then
			$recv = StringReplace ($recv, "~~pm:", "", 1)
			$recv = StringReplace ($recv, $user & " ", "", 1)
			GUICtrlSetData ($edit, $recv & " (privat)" & @crlf & guictrlread($edit))
			$priv = 1
		EndIf
	EndIf
			
	if stringinstr ($recv, "~~accepted") then
		$recv = ""
	EndIf
	
	if $recv <> "" and $err = 0 and not StringInStr ($recv, "~~users:") and not StringInStr ($recv, "~~accepted") and not StringInStr($recv, "~~pm:") and not stringinstr($recv, "~~kick:") and $priv = 0 Then
		GUICtrlSetData ($edit, $recv & @CRLF & GUICtrlRead($edit))
	EndIf
	
	if StringInStr($recv, "~~users:") then
		$users = StringTrimLeft ($recv, 8)
		$users = StringReplace ($users, "|", @crlf)
		GUICtrlSetData ($userlist, $users)
	EndIf
	
WEnd


Func OnAutoItExit()
   TCPSend( $socket, "~~bye" )
   TCPCloseSocket( $socket )
   TCPShutDown()
EndFunc
