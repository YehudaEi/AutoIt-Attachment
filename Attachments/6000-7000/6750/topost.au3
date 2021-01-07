#include <GUIConstants.au3>
Global $port = 9999
Global $localhost = @IPAddress1
Global $ipto,$sendtext,$consock,$hostsendtext,$osocket,$session,$messageGUI,$hostmessageGUI,$hostsendtext,$hostsession
Opt("GUIoneventmode", 1)
$maingui = GUICreate("Messenger", 350, 350)
$filemen = GUICtrlCreateMenu("File")
$connectmen = GUICtrlCreateMenuItem("Connect directly", $filemen)
GUISetOnEvent($GUI_EVENT_CLOSE, "anexit")
GUICtrlSetOnEvent($connectmen, "Connect")
GUISetState(@SW_SHOW)
TCPStartup()
$lissock = TCPListen ($localhost, $port)

While 1
	$osocket = TCPAccept($lissock)
	If $osocket <> -1 Then
		While 1
			$cleintIp = TCPRecv($osocket, 512)
			If $cleintIp <> "" Then ExitLoop
		WEnd
		$hostmessageGUI = GUICreate("Session with " & $cleintIp, 350, 250)
		GUICtrlSetOnEvent(GUICtrlCreateButton("Host Send", 265, 190), "hostsendtext")
		$hostsession = GUICtrlCreateInput("Session History", 1, 1, 225, 185)
		$hostsendtext = GUICtrlCreateInput("enter text here", 1, 190, 225, 35)
		GUISetState(@SW_SHOW)
			While 1
				$incomming = TCPRecv($osocket, 512)
				If $incomming <> "" Then GUICtrlSetData($hostsession, GUICtrlRead($hostsession) & $cleintIp & ":" & $incomming)
			WEnd
	EndIf
WEnd

Func hostsendtext()
	TCPSend($osocket, GUICtrlRead($hostsendtext))
	GUICtrlSetData($hostsession, GUICtrlRead($hostsession) & $localhost & ":" & GUICtrlRead($hostsendtext))
	GUICtrlSetData($hostsendtext,"")
EndFunc

Func connect()
	$ipto = InputBox("Connect to who?", "Enter Ip Adress")
	If @error = 1 Then Return
	$consock = TCPConnect($ipto, $port)
	If $consock = -1 Then
		MsgBox(0, "Error: " & @error, "Could not connect to server")
		Return
	EndIf
	TCPSend($consock, $localhost)
	$messageGUI = GUICreate("Session with " & $ipto, 350, 250)
;Problem starts here++++++++++	
	GUICtrlSetOnEvent(GUICtrlCreateButton("Client Send", 265, 190), "testok") ;trying to call 'clientsend' but the point is it doesn't call any function
; the send buton is made...
	$session = GUICtrlCreateInput("Seesion History", 1, 1, 225, 185)
	$sendtext = GUICtrlCreateInput("enter text here", 1, 190, 225, 35)
	GUISetState(@SW_SHOW)
	While 1 ;;;while in this loop the send button is pressed...
		$rec = TCPRecv($consock, 512)
		If $rec <> "" Then GUICtrlSetData($session, GUICtrlRead($session) & $ipto & ":" & $rec)
	WEnd
	
EndFunc
;This function is not called....
Func testok()
	MsgBox(0,"OK","called")
	Return
EndFunc

Func clientsend()
	TCPSend($consock, GUICtrlRead($sendtext))
	GUICtrlSetData($session, GUICtrlRead($session) & $localhost & ":" & GUICtrlRead($sendtext))
	GUICtrlSetData($sendtext,"")
EndFunc

Func anexit()
	Exit
EndFunc