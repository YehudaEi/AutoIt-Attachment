;chat with 30000 clients
;made by Marten Zimmermann

#include <guiconstants.au3>
global $g_port = 34000
Global $g_IP = @IPADDRESS1
Global $MainSocket
dim $maxconnect = 30
$max = $maxconnect + 1
dim $ConnectedSocket[$max]
dim $recv[$max]
dim $user[$max]
dim $pw[$max]
for $i = 1 to $maxconnect step 1
	$ConnectedSocket[$i] = -1
Next


tcpstartup()

$MainSocket = TCPListen($g_IP, $g_port,  $maxconnect )
If $MainSocket = -1 Then Exit
$RogueSocket = -1

$main = GUICreate ("Chat Server", 500, 200)
$input = GUICtrlCreateInput ("", 10, 10, 280)
$edit = GUICtrlCreateEdit ("", 10, 40, 280, 110, $ES_READONLY + $ES_MULTILINE + $WS_VSCROLL + $ES_AUTOVSCROLL)
$userlist = GUICtrlCreateEdit ("Server", 300, 10, 190, 180, $ES_READONLY + $ES_MULTILINE + $WS_VSCROLL + $ES_AUTOVSCROLL + $ES_WANTRETURN)
$send = GUICtrlCreateButton ("Send", 10, 160, 280, 20, $BS_DEFPUSHBUTTON)
GUICtrlSetState ($input, $GUI_FOCUS)
GUISetState()

$users = "Server" & @CRLF
$users1 = "Server" & "|"

while 1
	$msg = GUIGetMsg()
	if $msg = $GUI_EVENT_CLOSE Then
		for $i = 1 to $maxconnect step 1
			if $ConnectedSocket[$i] <> -1 Then
				tcpsend ($ConnectedSocket[$i], "~~bye")
			EndIf
		Next
		tcpshutdown()
		Exit
	EndIf
	
	if $msg = $send Then
		if GUICtrlRead ($input) <> "" Then
			for $i = 1 to $maxconnect step 1
				if $ConnectedSocket[$i] <> -1 Then
					tcpsend ($ConnectedSocket[$i], "Server: " & guictrlread ($input))
				EndIf
			Next
			GUICtrlSetData ($edit, guictrlread($input) & @crlf & guictrlread ($edit))
			GUICtrlSetData ($input, "")
		EndIf
	EndIf
	
	for $i = 1 to $maxconnect step 1
		if $ConnectedSocket[$i] <> -1 Then
			$recv[$i] = tcprecv($ConnectedSocket[$i], 512)
			$err = @error
			if $recv[$i] = "~~bye" Then
				$ConnectedSocket[$i] = -1
				tcpclosesocket($ConnectedSocket[$i])
				$test = $user[$i] & @CRLF
				$users = StringReplace ($users, $test, "")
				GUICtrlSetData ($userlist, $users)
				if StringReplace ($users1, "|", @crlf) <> $users Then
					$users1 = StringReplace ($users, @crlf, "|")
					for $j = 1 to $maxconnect
						if $ConnectedSocket[$i] <> -1 Then
							tcpsend($ConnectedSocket[$i], "~~users:" & $users1)
						EndIf
					Next
				EndIf
			EndIf
			
			if $user[$i] <> "" Then	
				tcpsend($ConnectedSocket[$i], "~~accepted")
			EndIf
						
			if StringInStr ($recv[$i], "~~us:") Then
				$user[$i] = stringtrimleft ($recv[$i], 5)
				$test = $user[$i] & @CRLF
				if not StringInStr ($users, $test) Then
					if iniread ("chat.ini", "Users", $user[$i], "") <> "" Then
						tcpsend ($ConnectedSocket[$i], "~~password")
					Else
						tcpsend ($ConnectedSocket[$i], "~~accepted")
						USERLIST()
					EndIf
				EndIf
			EndIf
			
			if StringInStr ($recv[$i], "~~pw:") Then
				$pw[$i] = StringTrimLeft ($recv[$i], 5)
				if iniread ("chat.ini", "Users", $user[$i], "") = $pw[$i] then
					tcpsend($ConnectedSocket[$i], "~~accepted")
					USERLIST()
				Else
					tcpsend ($ConnectedSocket[$i], "~~password")
				EndIf
			EndIf
			
			if StringInStr ($recv[$i], "~~pm:") and stringinstr($recv, "Server") then
				$recv[$i] = StringReplace ($recv, "~~pm:", "", 1)
				$recv[$i] = StringReplace ($recv, "Server", "", 1)
				GUICtrlSetData ($edit, $recv[$i] & " (privat)" & @crlf & guictrlread($edit))
			EndIf
			
			if $user[$i] <> "" Then
				tcpsend($ConnectedSocket[$i], "~~users:" & $users1)
			EndIf
			
			if $recv[$i] <> "" and $err = 0 and $recv[$i] <> "~~bye" and not StringInStr($recv[$i], "~~kick:") and not StringInStr($recv[$i], "~~us:") and not StringInStr($recv[$i], "~~pw:") Then
				for $j = 1 to $maxconnect step 1
					if $ConnectedSocket[$j] <> -1 Then
						tcpsend($ConnectedSocket[$j], $user[$i] & ": " & $recv[$i])
					EndIf
				Next
				GUICtrlSetData ($edit, $user[$i] & ": " & $recv[$i] & @crlf & guictrlread($edit))
			EndIf
			
		Else
			$ConnectedSocket[$i] = tcpaccept($MainSocket)
		EndIf
	Next
WEnd

func USERLIST()
	for $i = 1 to $maxconnect step 1
		if $ConnectedSocket[$i] <> -1 Then
			$test = $user[$i] & @CRLF
			if not stringinstr ($users, $test) Then
				$users = $users & $user[$i] & @CRLF
			EndIf
		Elseif $ConnectedSocket[$i] = -1 Then
			;$users = stringreplace ($users, $user[$i], "")
		EndIf		
	Next
	
	$users1 = StringReplace ($users, @CRLF , "|")
	for $i = 1 to $maxconnect step 1
		if $ConnectedSocket[$i] <> -1 Then
			tcpsend ($ConnectedSocket[$i], "~~users:" & $users1)
		EndIf
	Next
	
	GUICtrlSetData ($userlist, $users)
EndFunc