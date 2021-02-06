#include <String.au3>
OnAutoItExitRegister("_TS3quit")
Global $TS3connection

; #FUNCTION# ;===============================================================================
;
; Name...........: _TS3errors
; Description ...: Server error message
; AutoIt Version : V3.3.6.0
; Syntax.........: _TS3errors($TS3error)
; Parameters ....: $TS3error - Error message
; Return values .: Success - Returns : Error message
;                  Failure - Returns 0 and Sets @Error:
;                  |0 - No error.
; Author ........: chip
;
; ;==========================================================================================
Func _TS3errors($TS3error)
	$errormessage = StringSplit($TS3error, "msg=", 1)
	$message = StringReplace($errormessage[2], "\s", " ", 0, 1)
	Return $message
EndFunc   ;==>_TS3errors



; #FUNCTION# ;===============================================================================
;
; Name...........: _TS3connect
; Description ...: TS3 Server connect
; AutoIt Version : V3.3.6.0
; Syntax.........: _TS3connect($TS3server[,  $TS3port = "10011"])
; Parameters ....: $TS3server - Server (Name or IP)
;				   $TS3port - Optional: (Default = "10011") : Queryport
; Return values .: Success - Returns : 1
;                  Failure - Returns 0 and Sets @Error:
;                  |0 - No error.
;                  |1 - Wrong IP
;			       |2 - Wrong Port
;						Windows API WSAGetError
; Author ........: chip
;
; ;==========================================================================================
Func _TS3connect($TS3server, $TS3port = "10011")
	TCPStartup()
	$host = TCPNameToIP($TS3server)
	$TS3connection = TCPConnect($host, $TS3port)
	SetError(@error)
EndFunc   ;==>_TS3connect


; #FUNCTION# ;===============================================================================
;
; Name...........: _TS3quit
; Description ...: Closes the ServerQuery connection to the TeamSpeak 3 Server instance.
; AutoIt Version : V3.3.6.0
; Syntax.........: _TS3quit()
; Parameters ....:
; Return values .: Success - Returns : 1
;                  Failure - Returns 0 and Sets @Error:
;                  |0 - No error.
; Author ........: chip
;
; ;==========================================================================================
Func _TS3quit()
	TCPSend($TS3connection, "quit" & Chr(10))
	TCPCloseSocket($TS3connection)
	TCPShutdown()
EndFunc   ;==>_TS3quit


; #FUNCTION# ;===============================================================================
;
; Name...........: _TS3login
; Description ...: Authenticates with the TeamSpeak 3 Server instance using given ServerQuery login credentials.
; AutoIt Version : V3.3.6.0
; Syntax.........: _TS3login($TS3admin, $TS3passwort)
; Parameters ....: $TS3admin - Loginname
;				   $TS3passwort - Password
; Return values .: Success - Returns : 1
;                  Failure - Returns 0 and Sets @Error:
;                  |0 - No error.
;                  |1 - Error: Set return - Error message
;			       |2 - Account banned: Set return - Still banned seconds
; Author ........: chip
;
; ;==========================================================================================
Func _TS3login($TS3admin, $TS3passwort)
	TCPSend($TS3connection, "login " & $TS3admin & " " & $TS3passwort & Chr(10))
	While 1
		$recv = TCPRecv($TS3connection, 2048)
		$recv = StringReplace($recv, @LF, @CRLF)
		$recv = StringReplace($recv, @CRLF & @CR, @CRLF)
		If StringInStr($recv, "error") Then
			$id = _StringBetween($recv, "id=", " msg")
			Switch $id[0]
				Case "0"
					Return 1
				Case "3329"
					$ban = _StringBetween($recv, "sin\s", "\sseconds")
					Return SetError(2, 0, $ban[0])
				Case Else
					Return SetError(1, 0, _TS3errors($recv))
			EndSwitch
			ExitLoop
		EndIf
	WEnd
EndFunc   ;==>_TS3login


; #FUNCTION# ;===============================================================================
;
; Name...........: _TS3logout
; Description ...: Deselects the active virtual server and logs out from the server instance.
; AutoIt Version : V3.3.6.0
; Syntax.........: _TS3logout()
; Parameters ....:
; Return values .: Success - Returns : 1
;                  Failure - Returns 0 and Sets @Error:
;                  |0 - No error.
; Author ........: chip
;
; ;==========================================================================================
Func _TS3logout()
	TCPSend($TS3connection, "logout" & Chr(10))
EndFunc   ;==>_TS3logout


; #FUNCTION# ;===============================================================================
;
; Name...........: _TS3version
; Description ...: Displays the servers version information including platform and build number.
; AutoIt Version : V3.3.6.0
; Syntax.........: _TS3version()
; Parameters ....:
; Return values .: Success - Returns : Version information
;                  Failure - Returns 0 and Sets @Error:
;                  |0 - No error.
; Author ........: chip
;
; ;==========================================================================================
Func _TS3version()
	TCPSend($TS3connection, "version" & Chr(10))
	While 1
		$recv = TCPRecv($TS3connection, 2048)
		$recv = StringReplace($recv, @LF, @CRLF)
		$recv = StringReplace($recv, @CRLF & @CR, @CRLF)
		If StringInStr($recv, "version") Then
			$recv = StringReplace($recv, "error id=0 msg=ok", "")
			Return $recv
		EndIf
	WEnd
EndFunc   ;==>_TS3version


; #FUNCTION# ;===============================================================================
;
; Name...........: _TS3hostinfo
; Description ...: Displays detailed connection information about the server instance including uptime, number of virtual servers online, traffic information, etc.
; AutoIt Version : V3.3.6.0
; Syntax.........: _TS3hostinfo()
; Parameters ....:
; Return values .: Success - Returns : Host information
;                  Failure - Returns 0 and Sets @Error:
;                  |0 - No error.
; Author ........: chip
;
; ;==========================================================================================
Func _TS3hostinfo()
	TCPSend($TS3connection, "hostinfo" & Chr(10))
	While 1
		$recv = TCPRecv($TS3connection, 2048)
		$recv = StringReplace($recv, @LF, @CRLF)
		$recv = StringReplace($recv, @CRLF & @CR, @CRLF)
		If StringInStr($recv, "instance_uptime") Then
			$recv = StringReplace($recv, "error id=0 msg=ok", "")
			Return $recv
		EndIf
	WEnd
EndFunc   ;==>_TS3hostinfo

; #FUNCTION# ;===============================================================================
;
; Name...........: _TS3instanceinfo
; Description ...: Displays the server instance configuration including database revision number, the file transfer port, default group IDs, etc.
; AutoIt Version : V3.3.6.0
; Syntax.........: _TS3instanceinfo()
; Parameters ....:
; Return values .: Success - Returns : Instance information
;                  Failure - Returns 0 and Sets @Error:
;                  |0 - No error.
; Author ........: chip
;
; ;==========================================================================================
Func _TS3instanceinfo()
	TCPSend($TS3connection, "instanceinfo" & Chr(10))
	While 1
		$recv = TCPRecv($TS3connection, 2048)
		$recv = StringReplace($recv, @LF, @CRLF)
		$recv = StringReplace($recv, @CRLF & @CR, @CRLF)
		If StringInStr($recv, "serverinstance") Then
			$recv = StringReplace($recv, "error id=0 msg=ok", "")
			Return $recv
		EndIf
	WEnd
EndFunc   ;==>_TS3instanceinfo


; #FUNCTION# ;===============================================================================
;
; Name...........: _TS3instanceedit
; Description ...: Changes the server instance configuration using given properties.
; AutoIt Version : V3.3.6.0
; Syntax.........: _TS3instanceedit($TS3properties)
; Parameters ....: $TS3properties - Instance proberties
; Return values .: Success - Returns : 1
;                  Failure - Returns 0 and Sets @Error:
;                  |0 - No error.
; Author ........: chip
;
; ;==========================================================================================
Func _TS3instanceedit($TS3properties)
	TCPSend($TS3connection, $TS3properties & Chr(10))
	While 1
		$recv = TCPRecv($TS3connection, 2048)
		$recv = StringReplace($recv, @LF, @CRLF)
		$recv = StringReplace($recv, @CRLF & @CR, @CRLF)
		If StringInStr($recv, "error") Then
			If StringInStr($recv, "error id=0 msg=ok") Then
				Return 1
			Else
				Return 0
			EndIf
		EndIf
	WEnd
EndFunc   ;==>_TS3instanceedit


; #FUNCTION# ;===============================================================================
;
; Name...........: _TS3bindinglist
; Description ...: Displays a list of IP addresses used by the server instance on multi-homed machines.
; AutoIt Version : V3.3.6.0
; Syntax.........: _TS3bindinglist()
; Parameters ....:
; Return values .: Success - Returns : IP addresses
;                  Failure - Returns 0 and Sets @Error:
;                  |0 - No error.
; Author ........: chip
;
; ;==========================================================================================
Func _TS3bindinglist()
	TCPSend($TS3connection, "bindinglist" & Chr(10))
	While 1
		$recv = TCPRecv($TS3connection, 2048)
		$recv = StringReplace($recv, @LF, @CRLF)
		$recv = StringReplace($recv, @CRLF & @CR, @CRLF)
		If StringInStr($recv, "IP") Then
			$recv = StringReplace($recv, "error id=0 msg=ok", "")
			Return $recv
		EndIf
	WEnd
EndFunc   ;==>_TS3bindinglist


; #FUNCTION# ;===============================================================================
;
; Name...........: _TS3use
; Description ...: Selects the virtual server specified with sid or port to allow further interaction.
; AutoIt Version : V3.3.6.0
; Syntax.........: _TS3use($TS3serverid)
; Parameters ....: $TS3serverid - Virtual server ID
; Return values .: Success - Returns : 1
;                  Failure - Returns 0 and Sets @Error:
;                  |0 - No error.
;				   |1 - Error: Set return - Error message
; Author ........: chip
;
; ;==========================================================================================
Func _TS3use($TS3serverid)
	TCPSend($TS3connection, "use sid=" & $TS3serverid & Chr(10))
	While 1
		$recv = TCPRecv($TS3connection, 2048)
		$recv = StringReplace($recv, @LF, @CRLF)
		$recv = StringReplace($recv, @CRLF & @CR, @CRLF)
		If StringInStr($recv, "error") Then
			$id = _StringBetween($recv, "id=", " msg")
			Switch $id[0]
				Case "0"
					Return 1
				Case Else
					Return SetError(1, 0, _TS3errors($recv))
			EndSwitch
			ExitLoop
		EndIf
	WEnd
EndFunc   ;==>_TS3use


; #FUNCTION# ;===============================================================================
;
; Name...........: _TS3serverlist
; Description ...: Displays a list of virtual servers including their ID, status, number of clients online, etc.
; AutoIt Version : V3.3.6.0
; Syntax.........: _TS3serverlist()
; Parameters ....:
; Return values .: Success - Returns : virtual servers
;                  Failure - Returns 0 and Sets @Error:
;                  |0 - No error.
; Author ........: chip
;
; ;==========================================================================================
Func _TS3serverlist()
	TCPSend($TS3connection, "serverlist" & Chr(10))
	While 1
		$recv = TCPRecv($TS3connection, 2048)
		$recv = StringReplace($recv, @LF, @CRLF)
		$recv = StringReplace($recv, @CRLF & @CR, @CRLF)
		If StringInStr($recv, "virtualserver") Then
			$recv = StringReplace($recv, "error id=0 msg=ok", "")
			Return $recv
		EndIf
	WEnd
EndFunc   ;==>_TS3serverlist


; #FUNCTION# ;===============================================================================
;
; Name...........: _TS3serveridgetbyport
; Description ...: Displays the database ID of the virtual server running on the UDP port specified by virtualserver_port.
; AutoIt Version : V3.3.6.0
; Syntax.........: _TS3serveridgetbyport($TS3port)
; Parameters ....: $TS3port - Virtual server port
; Return values .: Success - Returns : Virtual Server ID
;                  Failure - Returns 0 and Sets @Error:
;                  |0 - No error.
;                  |1 - Error: Set return - Error message
; Author ........: chip
;
; ;==========================================================================================
Func _TS3serveridgetbyport($TS3port)
	TCPSend($TS3connection, "serveridgetbyport virtualserver_port=" & $TS3port & Chr(10))
	While 1
		$recv = TCPRecv($TS3connection, 2048)
		$recv = StringReplace($recv, @LF, @CRLF)
		$recv = StringReplace($recv, @CRLF & @CR, @CRLF)
		If StringInStr($recv, "server_id") Then
			$recv = StringTrimLeft($recv, 10)
			$recv = StringReplace($recv, "error id=0 msg=ok", "")
			Return $recv
		ElseIf StringInStr($recv, "error") Then
			$id = _StringBetween($recv, "id=", " msg")
			Return SetError(1, 0, _TS3errors($recv))
			ExitLoop
		EndIf
	WEnd
EndFunc   ;==>_TS3serveridgetbyport


; #FUNCTION# ;===============================================================================
;
; Name...........: _TS3serverdelete
; Description ...: Deletes the virtual server specified with sid. Please note that only virtual servers in stopped state can be deleted.
; AutoIt Version : V3.3.6.0
; Syntax.........: _TS3serverdelete($TS3serverid)
; Parameters ....: $$TS3serverid - Virtual server id
; Return values .: Success - Returns : 1
;                  Failure - Returns 0 and Sets @Error:
;                  |0 - No error.
;                  |1 - Error: Set return - Error message
; Author ........: chip
;
; ;==========================================================================================
Func _TS3serverdelete($TS3serverid)
	TCPSend($TS3connection, "serverdelete sid=" & $TS3serverid & Chr(10))
	While 1
		$recv = TCPRecv($TS3connection, 2048)
		$recv = StringReplace($recv, @LF, @CRLF)
		$recv = StringReplace($recv, @CRLF & @CR, @CRLF)
		If StringInStr($recv, "error") Then
			$id = _StringBetween($recv, "id=", " msg")
			Switch $id[0]
				Case "0"
					Return 1
				Case Else
					Return SetError(1, 0, _TS3errors($recv))
			EndSwitch
			ExitLoop
		EndIf
	WEnd
EndFunc   ;==>_TS3serverdelete


; #FUNCTION# ;===============================================================================
;
; Name...........: _TS3servercreate
; Description ...: Deletes the virtual server specified with sid. Please note that only virtual servers in stopped state can be deleted.
; AutoIt Version : V3.3.6.0
; Syntax.........: _TS3servercreate($TS3servername[, $TS3properties = ""])
; Parameters ....: $TS3servername - Virtual server name
;				   $TS3properties - Optional: (Default = "") : Virtual server properties
; Return values .: Success - Returns : Virtual Server SID, Admintoken and Port
;                  Failure - Returns 0 and Sets @Error:
;                  |0 - No error.
;                  |1 - Error: Set return - Error message
; Author ........: chip
;
; ;==========================================================================================
Func _TS3servercreate($TS3servername, $TS3properties = "")
	TCPSend($TS3connection, "servercreate virtualserver_name=" & $TS3servername & " " & $TS3properties & Chr(10))
	While 1
		$recv = TCPRecv($TS3connection, 2048)
		$recv = StringReplace($recv, @LF, @CRLF)
		$recv = StringReplace($recv, @CRLF & @CR, @CRLF)
		If StringInStr($recv, "sid") Then
			$recv = StringReplace($recv, "error id=0 msg=ok", "")
			Return $recv
		ElseIf StringInStr($recv, "error") Then
			Return SetError(1, 0, _TS3errors($recv))
			ExitLoop
		EndIf
	WEnd
EndFunc   ;==>_TS3servercreate


; #FUNCTION# ;===============================================================================
;
; Name...........: _TS3serverstart
; Description ...: Starts the virtual server specified with sid. Depending on your permissions, you're able to start either your own virtual server only or all virtual servers in the server instance.
; AutoIt Version : V3.3.6.0
; Syntax.........: _TS3serverstart($TS3serverid)
; Parameters ....: $$TS3serverid - Virtual server id
; Return values .: Success - Returns : 1
;                  Failure - Returns 0 and Sets @Error:
;                  |0 - No error.
;                  |1 - Error: Set return - Error message
; Author ........: chip
;
; ;==========================================================================================
Func _TS3serverstart($TS3serverid)
	TCPSend($TS3connection, "serverstart sid=" & $TS3serverid & Chr(10))
	While 1
		$recv = TCPRecv($TS3connection, 2048)
		$recv = StringReplace($recv, @LF, @CRLF)
		$recv = StringReplace($recv, @CRLF & @CR, @CRLF)
		If StringInStr($recv, "error") Then
			$id = _StringBetween($recv, "id=", " msg")
			Switch $id[0]
				Case "0"
					Return 1
				Case Else
					Return SetError(1, 0, _TS3errors($recv))
			EndSwitch
			ExitLoop
		EndIf
	WEnd
EndFunc   ;==>_TS3serverstart


; #FUNCTION# ;===============================================================================
;
; Name...........: _TS3serverstop
; Description ...: Stops the virtual server specified with sid. Depending on your permissions, you're able to stop either your own virtual server only or all virtual servers in the server instance.
; AutoIt Version : V3.3.6.0
; Syntax.........: _TS3serverstop($TS3serverid)
; Parameters ....: $$TS3serverid - Virtual server id
; Return values .: Success - Returns : 1
;                  Failure - Returns 0 and Sets @Error:
;                  |0 - No error.
;                  |1 - Error: Set return - Error message
; Author ........: chip
;
; ;==========================================================================================
Func _TS3serverstop($TS3serverid)
	TCPSend($TS3connection, "serverstop sid=" & $TS3serverid & Chr(10))
	While 1
		$recv = TCPRecv($TS3connection, 2048)
		$recv = StringReplace($recv, @LF, @CRLF)
		$recv = StringReplace($recv, @CRLF & @CR, @CRLF)
		If StringInStr($recv, "error") Then
			$id = _StringBetween($recv, "id=", " msg")
			Switch $id[0]
				Case "0"
					Return 1
				Case Else
					Return SetError(1, 0, _TS3errors($recv))
			EndSwitch
			ExitLoop
		EndIf
	WEnd
EndFunc   ;==>_TS3serverstop


; #FUNCTION# ;===============================================================================
;
; Name...........: _TS3serverprocessstop
; Description ...: Stops the entire TeamSpeak 3 Server instance by shutting down the process.
; AutoIt Version : V3.3.6.0
; Syntax.........: _TS3serverprocessstop()
; Parameters ....:
; Return values .: Success - Returns : 1
;                  Failure - Returns 0 and Sets @Error:
;                  |0 - No error.
;						Windows API WSAGetError
; Author ........: chip
;
; ;==========================================================================================
Func _TS3serverprocessstop()
	$check = TCPSend($TS3connection, "serverprocessstop" & Chr(10))
	If $check = 0 Then
		SetError(@error)
	Else
		Return 1
	EndIf
EndFunc   ;==>_TS3serverprocessstop


; #FUNCTION# ;===============================================================================
;
; Name...........: _TS3serverinfo
; Description ...: Displays detailed configuration information about the selected virtual server including unique ID, number of clients online, configuration, etc.
; AutoIt Version : V3.3.6.0
; Syntax.........: _TS3serverinfo()
; Parameters ....:
; Return values .: Success - Returns : Virtual server information
;                  Failure - Returns 0 and Sets @Error:
;                  |0 - No error.
;                  |1 - Error: Set return - Error message
; Author ........: chip
;
; ;==========================================================================================
Func _TS3serverinfo()
	TCPSend($TS3connection, "serverinfo" & Chr(10))
	While 1
		$recv = TCPRecv($TS3connection, 2048)
		$recv = StringReplace($recv, @LF, @CRLF)
		$recv = StringReplace($recv, @CRLF & @CR, @CRLF)
		If StringInStr($recv, "virtualserver") Then
			$recv = StringReplace($recv, "error id=0 msg=ok", "")
			Return $recv
		ElseIf StringInStr($recv, "error") Then
			Return SetError(1, 0, _TS3errors($recv))
			ExitLoop
		EndIf
	WEnd
EndFunc   ;==>_TS3serverinfo


; #FUNCTION# ;===============================================================================
;
; Name...........: _TS3serverrequestconnectioninfo
; Description ...: Displays detailed connection information about the selected virtual server including uptime, traffic information, etc.
; AutoIt Version : V3.3.6.0
; Syntax.........: _TS3serverrequestconnectioninfo()
; Parameters ....:
; Return values .: Success - Returns : Virtual server connection information
;                  Failure - Returns 0 and Sets @Error:
;                  |0 - No error.
;                  |1 - Error: Set return - Error message
; Author ........: chip
;
; ;==========================================================================================
Func _TS3serverrequestconnectioninfo()
	TCPSend($TS3connection, "serverrequestconnectioninfo" & Chr(10))
	While 1
		$recv = TCPRecv($TS3connection, 2048)
		$recv = StringReplace($recv, @LF, @CRLF)
		$recv = StringReplace($recv, @CRLF & @CR, @CRLF)
		If StringInStr($recv, "connection_filetransfer") Then
			$recv = StringReplace($recv, "error id=0 msg=ok", "")
			Return $recv
		ElseIf StringInStr($recv, "error") Then
			Return SetError(1, 0, _TS3errors($recv))
			ExitLoop
		EndIf
	WEnd
EndFunc   ;==>_TS3serverrequestconnectioninfo


; #FUNCTION# ;===============================================================================
;
; Name...........: _TS3serveredit
; Description ...: Changes the selected virtual servers configuration using given properties.
; AutoIt Version : V3.3.6.0
; Syntax.........: _TS3serveredit($TS3properties)
; Parameters ....: $TS3properties - Server proberties
; Return values .: Success - Returns : 1
;                  Failure - Returns 0 and Sets @Error:
;                  |0 - No error.
;                  |1 - Error: Set return - Error message
; Author ........: chip
;
; ;==========================================================================================
Func _TS3serveredit($TS3properties)
	TCPSend($TS3connection, "serveredit " & $TS3properties & Chr(10))
	While 1
		$recv = TCPRecv($TS3connection, 2048)
		$recv = StringReplace($recv, @LF, @CRLF)
		$recv = StringReplace($recv, @CRLF & @CR, @CRLF)
		If StringInStr($recv, "error") Then
			$id = _StringBetween($recv, "id=", " msg")
			Switch $id[0]
				Case "0"
					Return 1
				Case Else
					Return SetError(1, 0, _TS3errors($recv))
			EndSwitch
		EndIf
	WEnd
EndFunc   ;==>_TS3serveredit


; #FUNCTION# ;===============================================================================
;
; Name...........: _TS3servergrouplist
; Description ...: Displays a list of server groups available. Depending on your permissions, the output may also contain global ServerQuery groups and template groups.
; AutoIt Version : V3.3.6.0
; Syntax.........: _TS3servergrouplist()
; Parameters ....:
; Return values .: Success - Returns : Server groups
;                  Failure - Returns 0 and Sets @Error:
;                  |0 - No error.
;                  |1 - Error: Set return - Error message
; Author ........: chip
;
; ;==========================================================================================
Func _TS3servergrouplist()
	TCPSend($TS3connection, "servergrouplist" & Chr(10))
	While 1
		$recv = TCPRecv($TS3connection, 2048)
		$recv = StringReplace($recv, @LF, @CRLF)
		$recv = StringReplace($recv, @CRLF & @CR, @CRLF)
		If StringInStr($recv, "sgid") Then
			$recv = StringReplace($recv, "error id=0 msg=ok", "")
			Return $recv
		ElseIf StringInStr($recv, "error") Then
			Return SetError(1, 0, _TS3errors($recv))
			ExitLoop
		EndIf
	WEnd
EndFunc   ;==>_TS3servergrouplist


; #FUNCTION# ;===============================================================================
;
; Name...........: _TS3servergroupadd
; Description ...: Creates a new server group using the name specified with name and displays its ID.
; AutoIt Version : V3.3.6.0
; Syntax.........: _TS3servergroupadd($TS3name)
; Parameters ....: $TS3name - Group name
; Return values .: Success - Returns : Server group ID
;                  Failure - Returns 0 and Sets @Error:
;                  |0 - No error.
;                  |1 - Error: Set return - Error message
; Author ........: chip
;
; ;==========================================================================================
Func _TS3servergroupadd($TS3name)
	TCPSend($TS3connection, "servergroupadd name=" & $TS3name & Chr(10))
	While 1
		$recv = TCPRecv($TS3connection, 2048)
		$recv = StringReplace($recv, @LF, @CRLF)
		$recv = StringReplace($recv, @CRLF & @CR, @CRLF)
		If StringInStr($recv, "sgid") Then
			$recv = StringTrimLeft($recv, 5)
			$recv = StringReplace($recv, "error id=0 msg=ok", "")
			Return $recv
		ElseIf StringInStr($recv, "error") Then
			Return SetError(1, 0, _TS3errors($recv))
			ExitLoop
		EndIf
	WEnd
EndFunc   ;==>_TS3servergroupadd


; #FUNCTION# ;===============================================================================
;
; Name...........: _TS3servergroupdel
; Description ...: Deletes the server group specified with sgid. If force is set to 1, the server group will be deleted even if there are clients within.
; AutoIt Version : V3.3.6.0
; Syntax.........: _TS3servergroupdel($TS3groupid[, $TS3groupforce = "0"])
; Parameters ....: $TS3groupid - Group id
;				   $TS3groupforce - Optional: (Default = "0") : Force delete
; Return values .: Success - Returns : 1
;                  Failure - Returns 0 and Sets @Error:
;                  |0 - No error.
;                  |1 - Error: Set return - Error message
; Author ........: chip
;
; ;==========================================================================================
Func _TS3servergroupdel($TS3groupid, $TS3groupforce = "0")
	TCPSend($TS3connection, "servergroupdel sgid=" & $TS3groupid & " force=" & $TS3groupforce & Chr(10))
	While 1
		$recv = TCPRecv($TS3connection, 2048)
		$recv = StringReplace($recv, @LF, @CRLF)
		$recv = StringReplace($recv, @CRLF & @CR, @CRLF)
		If StringInStr($recv, "error") Then
			$id = _StringBetween($recv, "id=", " msg")
			Switch $id[0]
				Case "0"
					Return 1
				Case Else
					Return SetError(1, 0, _TS3errors($recv))
			EndSwitch
			ExitLoop
		EndIf
	WEnd
EndFunc   ;==>_TS3servergroupdel


; #FUNCTION# ;===============================================================================
;
; Name...........: _TS3servergrouprename
; Description ...: Changes the name of the server group specified with sgid.
; AutoIt Version : V3.3.6.0
; Syntax.........: _TS3servergrouprename($TS3groupid, $TS3groupname)
; Parameters ....: $TS3groupid - Group id
;                  $TS3groupname - New group name
; Return values .: Success - Returns : 1
;                  Failure - Returns 0 and Sets @Error:
;                  |0 - No error.
;                  |1 - Error: Set return - Error message
; Author ........: chip
;
; ;==========================================================================================
Func _TS3servergrouprename($TS3groupid, $TS3groupname)
	$TS3groupname = StringReplace($TS3groupname, " ", "\s")
	TCPSend($TS3connection, "servergrouprename sgid=" & $TS3groupid & " name=" & $TS3groupname & Chr(10))
	While 1
		$recv = TCPRecv($TS3connection, 2048)
		$recv = StringReplace($recv, @LF, @CRLF)
		$recv = StringReplace($recv, @CRLF & @CR, @CRLF)
		If StringInStr($recv, "error") Then
			$id = _StringBetween($recv, "id=", " msg")
			Switch $id[0]
				Case "0"
					Return 1
				Case Else
					Return SetError(1, 0, _TS3errors($recv))
			EndSwitch
			ExitLoop
		EndIf
	WEnd
EndFunc   ;==>_TS3servergrouprename


; #FUNCTION# ;===============================================================================
;
; Name...........: _TS3servergrouppermlist
; Description ...: Displays a list of permissions assigned to the server group specified with sgid.
; AutoIt Version : V3.3.6.0
; Syntax.........: _TS3servergrouppermlist($TS3groupid)
; Parameters ....: $TS3groupid - Group id
; Return values .: Success - Returns : Group permissions
;                  Failure - Returns 0 and Sets @Error:
;                  |0 - No error.
;                  |1 - Error: Set return - Error message
; Author ........: chip
;
; ;==========================================================================================
Func _TS3servergrouppermlist($TS3groupid)
	TCPSend($TS3connection, "servergrouppermlist sgid=" & $TS3groupid & Chr(10))
	While 1
		$recv = TCPRecv($TS3connection, 2048)
		$recv = StringReplace($recv, @LF, @CRLF)
		$recv = StringReplace($recv, @CRLF & @CR, @CRLF)
		If StringInStr($recv, "permid") Then
			$recv = StringReplace($recv, "error id=0 msg=ok", "")
			Return $recv
		ElseIf StringInStr($recv, "error") Then
			Return SetError(1, 0, _TS3errors($recv))
			ExitLoop
		EndIf
	WEnd
EndFunc   ;==>_TS3servergrouppermlist


; #FUNCTION# ;===============================================================================
;
; Name...........: _TS3servergroupaddperm
; Description ...: Adds a specified permissions to the server group specified with sgid.
; AutoIt Version : V3.3.6.0
; Syntax.........: _TS3servergroupaddperm($TS3groupid, $TS3permsid, $TS3permvalue[, $TS3permnegated = "0"[, $TS3permskip = "0"]])
; Parameters ....: $TS3groupid - Group id
;				   $TS3permsid - Permissions name
;				   $TS3permvalue - Permissions value
;				   $TS3permnegated - Optional: (Default = "0") : Permission negated
;				   $TS3permskip - Optional: (Default = "0") : Permission skip
; Return values .: Success - Returns : 1
;                  Failure - Returns 0 and Sets @Error:
;                  |0 - No error.
;                  |1 - Error: Set return - Error message
; Author ........: chip
;
; ;==========================================================================================
Func _TS3servergroupaddperm($TS3groupid, $TS3permsid, $TS3permvalue, $TS3permnegated = "0", $TS3permskip = "0")
	TCPSend($TS3connection, "servergroupaddperm sgid=" & $TS3groupid & " permsid=" & $TS3permsid & " permvalue=" & $TS3permvalue & " permnegated=" & $TS3permnegated & " permskip=" & $TS3permskip & Chr(10))
	While 1
		$recv = TCPRecv($TS3connection, 2048)
		$recv = StringReplace($recv, @LF, @CRLF)
		$recv = StringReplace($recv, @CRLF & @CR, @CRLF)
		If StringInStr($recv, "error") Then
			$id = _StringBetween($recv, "id=", " msg")
			Switch $id[0]
				Case "0"
					Return 1
				Case Else
					Return SetError(1, 0, _TS3errors($recv))
			EndSwitch
			ExitLoop
		EndIf
	WEnd
EndFunc   ;==>_TS3servergroupaddperm


; #FUNCTION# ;===============================================================================
;
; Name...........: _TS3servergroupdelperm
; Description ...: Removes a specified permissions from the server group specified with sgid.
; AutoIt Version : V3.3.6.0
; Syntax.........: _TS3servergroupdelperm($TS3groupid, $TS3permsid)
; Parameters ....: $TS3groupid - Group id
;				   $TS3permsid - Permissions name
; Return values .: Success - Returns : 1
;                  Failure - Returns 0 and Sets @Error:
;                  |0 - No error.
;                  |1 - Error: Set return - Error message
; Author ........: chip
;
; ;==========================================================================================
Func _TS3servergroupdelperm($TS3groupid, $TS3permsid)
	TCPSend($TS3connection, "servergroupdelperm sgid=" & $TS3groupid & " permsid=" & $TS3permsid & Chr(10))
	While 1
		$recv = TCPRecv($TS3connection, 2048)
		$recv = StringReplace($recv, @LF, @CRLF)
		$recv = StringReplace($recv, @CRLF & @CR, @CRLF)
		If StringInStr($recv, "error") Then
			$id = _StringBetween($recv, "id=", " msg")
			Switch $id[0]
				Case "0"
					Return 1
				Case Else
					Return SetError(1, 0, _TS3errors($recv))
			EndSwitch
			ExitLoop
		EndIf
	WEnd
EndFunc   ;==>_TS3servergroupdelperm


; #FUNCTION# ;===============================================================================
;
; Name...........: _TS3servergroupaddclient
; Description ...: Adds a client to the server group specified with sgid. Please note that a client cannot be added to default groups or template groups.
; AutoIt Version : V3.3.6.0
; Syntax.........: _TS3servergroupaddclient($TS3groupid, $TS3clientdbid)
; Parameters ....: $TS3groupid - Group id
;				   $TS3clientdbid - Client db ID
; Return values .: Success - Returns : 1
;                  Failure - Returns 0 and Sets @Error:
;                  |0 - No error.
;                  |1 - Error: Set return - Error message
; Author ........: chip
;
; ;==========================================================================================
Func _TS3servergroupaddclient($TS3groupid, $TS3clientdbid)
	TCPSend($TS3connection, "servergroupaddclient sgid=" & $TS3groupid & " cldbid=" & $TS3clientdbid & Chr(10))
	While 1
		$recv = TCPRecv($TS3connection, 2048)
		$recv = StringReplace($recv, @LF, @CRLF)
		$recv = StringReplace($recv, @CRLF & @CR, @CRLF)
		If StringInStr($recv, "error") Then
			$id = _StringBetween($recv, "id=", " msg")
			Switch $id[0]
				Case "0"
					Return 1
				Case Else
					Return SetError(1, 0, _TS3errors($recv))
			EndSwitch
			ExitLoop
		EndIf
	WEnd
EndFunc   ;==>_TS3servergroupaddclient


; #FUNCTION# ;===============================================================================
;
; Name...........: _TS3servergroupdelclient
; Description ...: Removes a client from the server group specified with sgid.
; AutoIt Version : V3.3.6.0
; Syntax.........: _TS3servergroupdelclient($TS3groupid, $TS3clientdbid)
; Parameters ....: $TS3groupid - Group id
;				   $TS3clientdbid - Client db ID
; Return values .: Success - Returns : 1
;                  Failure - Returns 0 and Sets @Error:
;                  |0 - No error.
;                  |1 - Error: Set return - Error message
; Author ........: chip
;
; ;==========================================================================================
Func _TS3servergroupdelclient($TS3groupid, $TS3clientdbid)
	TCPSend($TS3connection, "servergroupdelclient sgid=" & $TS3groupid & " cldbid=" & $TS3clientdbid & Chr(10))
	While 1
		$recv = TCPRecv($TS3connection, 2048)
		$recv = StringReplace($recv, @LF, @CRLF)
		$recv = StringReplace($recv, @CRLF & @CR, @CRLF)
		If StringInStr($recv, "error") Then
			$id = _StringBetween($recv, "id=", " msg")
			Switch $id[0]
				Case "0"
					Return 1
				Case Else
					Return SetError(1, 0, _TS3errors($recv))
			EndSwitch
			ExitLoop
		EndIf
	WEnd
EndFunc   ;==>_TS3servergroupdelclient


; #FUNCTION# ;===============================================================================
;
; Name...........: _TS3servergroupclientlist
; Description ...: Displays the IDs of all clients currently residing in the server group specified with sgid.
; AutoIt Version : V3.3.6.0
; Syntax.........: _TS3servergroupclientlist($TS3groupid)
; Parameters ....: $TS3groupid - Group id
; Return values .: Success - Returns : Clientlist
;                  Failure - Returns 0 and Sets @Error:
;                  |0 - No error.
;                  |1 - Error: Set return - Error message
; Author ........: chip
;
; ;==========================================================================================
Func _TS3servergroupclientlist($TS3groupid)
	TCPSend($TS3connection, "servergroupclientlist sgid=" & $TS3groupid & " -names" & Chr(10))
	While 1
		$recv = TCPRecv($TS3connection, 2048)
		$recv = StringReplace($recv, @LF, @CRLF)
		$recv = StringReplace($recv, @CRLF & @CR, @CRLF)
		If StringInStr($recv, "cldbid") Then
			$recv = StringReplace($recv, "error id=0 msg=ok", "")
			Return $recv
		ElseIf StringInStr($recv, "error") Then
			Return SetError(1, 0, _TS3errors($recv))
			ExitLoop
		EndIf
	WEnd
EndFunc   ;==>_TS3servergroupclientlist


; #FUNCTION# ;===============================================================================
;
; Name...........: _TS3servergroupsbyclientid
; Description ...: Displays the IDs of all clients currently residing in the server group specified with sgid.
; AutoIt Version : V3.3.6.0
; Syntax.........: _TS3servergroupsbyclientid($TS3clientdbid )
; Parameters ....: $TS3clientdbid - Client db id
; Return values .: Success - Returns : Client groups
;                  Failure - Returns 0 and Sets @Error:
;                  |0 - No error.
;                  |1 - Error: Set return - Error message
; Author ........: chip
;
; ;==========================================================================================
Func _TS3servergroupsbyclientid($TS3clientdbid)
	TCPSend($TS3connection, "servergroupsbyclientid cldbid=" & $TS3clientdbid & Chr(10))
	While 1
		$recv = TCPRecv($TS3connection, 2048)
		$recv = StringReplace($recv, @LF, @CRLF)
		$recv = StringReplace($recv, @CRLF & @CR, @CRLF)
		If StringInStr($recv, "name") Then
			$recv = StringReplace($recv, "error id=0 msg=ok", "")
			Return $recv
		ElseIf StringInStr($recv, "error") Then
			Return SetError(1, 0, _TS3errors($recv))
			ExitLoop
		EndIf
	WEnd
EndFunc   ;==>_TS3servergroupsbyclientid


; #FUNCTION# ;===============================================================================
;
; Name...........: _TS3serversnapshotcreate
; Description ...: Displays a snapshot of the selected virtual server containing all settings, groups and known client identities.
; AutoIt Version : V3.3.6.0
; Syntax.........: _TS3serversnapshotcreate()
; Parameters ....:
; Return values .: Success - Returns : Server snapshot
;                  Failure - Returns 0 and Sets @Error:
;                  |0 - No error.
;                  |1 - Error: Set return - Error message
; Author ........: chip
;
; ;==========================================================================================
Func _TS3serversnapshotcreate()
	TCPSend($TS3connection, "serversnapshotcreate" & Chr(10))
	While 1
		$recv = TCPRecv($TS3connection, 20000)
		$recv = StringReplace($recv, @LF, @CRLF)
		$recv = StringReplace($recv, @CRLF & @CR, @CRLF)
		If StringInStr($recv, "hash") Then
			$recv = StringReplace($recv, "error id=0 msg=ok", "")
			Return $recv
		ElseIf StringInStr($recv, "error") Then
			Return SetError(1, 0, _TS3errors($recv))
			ExitLoop
		EndIf
	WEnd
EndFunc   ;==>_TS3serversnapshotcreate


; #FUNCTION# ;===============================================================================
;
; Name...........: _TS3serversnapshotdeploy
; Description ...: Restores the selected virtual servers configuration using the data from a previously created server snapshot.
; AutoIt Version : V3.3.6.0
; Syntax.........: _TS3serversnapshotdeploy($TS3snapshot)
; Parameters ....: $TS3snapshot - Client db id
; Return values .: Success - Returns : 1
;                  Failure - Returns 0 and Sets @Error:
;                  |0 - No error.
;                  |1 - Error: Set return - Error message
; Author ........: chip
;
; ;==========================================================================================
Func _TS3serversnapshotdeploy($TS3snapshot)
	TCPSend($TS3connection, "serversnapshotdeploy " & $TS3snapshot & Chr(10))
	While 1
		$recv = TCPRecv($TS3connection, 2048)
		$recv = StringReplace($recv, @LF, @CRLF)
		$recv = StringReplace($recv, @CRLF & @CR, @CRLF)
		If StringInStr($recv, "hash") Then
			Return 1
		ElseIf StringInStr($recv, "error") Then
			Return SetError(1, 0, _TS3errors($recv))
			ExitLoop
		EndIf
	WEnd
EndFunc   ;==>_TS3serversnapshotdeploy


; #FUNCTION# ;===============================================================================
;
; Name...........: _TS3servernotifyregister
; Description ...: Registers for a specified category of events on a virtual server to receive notification messages. The event source is declared by the event parameter while id can be used to limit the notifications to a specific channel.
; AutoIt Version : V3.3.6.0
; Syntax.........: _TS3servernotifyregister($TS3event[, $TS3channelid = ""])
; Parameters ....: $TS3event - Eventvalue: server|channel|textserver|textchannel|textprivate
;				   $TS3channelid - Optional: (Default = "") : ChannelID
; Return values .: Success - Returns : 1
;                  Failure - Returns 0 and Sets @Error:
;                  |0 - No error.
;                  |1 - Error: Set return - Error message
; Author ........: chip
;
; ;==========================================================================================
Func _TS3servernotifyregister($TS3event, $TS3channelid = "")
	If $TS3channelid <> "" Then
		$TS3event = $TS3event & " id=" & $TS3channelid
	EndIf
	TCPSend($TS3connection, "servernotifyregister event=" & $TS3event & Chr(10))
	While 1
		$recv = TCPRecv($TS3connection, 2048)
		$recv = StringReplace($recv, @LF, @CRLF)
		$recv = StringReplace($recv, @CRLF & @CR, @CRLF)
		If StringInStr($recv, "error") Then
			$id = _StringBetween($recv, "id=", " msg")
			Switch $id[0]
				Case "0"
					Return 1
				Case Else
					Return SetError(1, 0, _TS3errors($recv))
			EndSwitch
			ExitLoop
		EndIf
	WEnd
EndFunc   ;==>_TS3servernotifyregister


; #FUNCTION# ;===============================================================================
;
; Name...........: _TS3servernotifyunregister
; Description ...: Unregisters all events previously registered with servernotifyregister so you will no longer receive notification messages.
; AutoIt Version : V3.3.6.0
; Syntax.........: _TS3servernotifyunregister()
; Parameters ....:
; Return values .: Success - Returns : 1
;                  Failure - Returns 0 and Sets @Error:
;                  |0 - No error.
;                  |1 - Error: Set return - Error message
; Author ........: chip
;
; ;==========================================================================================
Func _TS3servernotifyunregister()
	TCPSend($TS3connection, "servernotifyunregister" & Chr(10))
	While 1
		$recv = TCPRecv($TS3connection, 2048)
		$recv = StringReplace($recv, @LF, @CRLF)
		$recv = StringReplace($recv, @CRLF & @CR, @CRLF)
		If StringInStr($recv, "error") Then
			$id = _StringBetween($recv, "id=", " msg")
			Switch $id[0]
				Case "0"
					Return 1
				Case Else
					Return SetError(1, 0, _TS3errors($recv))
			EndSwitch
			ExitLoop
		EndIf
	WEnd
EndFunc   ;==>_TS3servernotifyunregister


; #FUNCTION# ;===============================================================================
;
; Name...........: _TS3gm
; Description ...: Sends a text message to all clients on all virtual servers in the TeamSpeak 3 Server instance.
; AutoIt Version : V3.3.6.0
; Syntax.........: _TS3gm($TS3msg)
; Parameters ....: $TS3msg - Messagetext
; Return values .: Success - Returns : 1
;                  Failure - Returns 0 and Sets @Error:
;                  |0 - No error.
; Author ........: chip
;
; ;==========================================================================================
Func _TS3gm($TS3msg)
	$TS3msg = StringReplace($TS3msg, " ", "\s")
	TCPSend($TS3connection, "gm msg=" & $TS3msg & Chr(10))
	While 1
		$recv = TCPRecv($TS3connection, 2048)
		$recv = StringReplace($recv, @LF, @CRLF)
		$recv = StringReplace($recv, @CRLF & @CR, @CRLF)
		If StringInStr($recv, "error") Then
			$id = _StringBetween($recv, "id=", " msg")
			Switch $id[0]
				Case "0"
					Return 1
			EndSwitch
		EndIf
	WEnd
EndFunc   ;==>_TS3gm


; #FUNCTION# ;===============================================================================
;
; Name...........: _TS3sendtextmessage
; Description ...: Sends a text message a specified target. The type of the target is determined by targetmode while target specifies the ID of the recipient, whether it be a virtual server, a channel or a client.
; AutoIt Version : V3.3.6.0
; Syntax.........: _TS3sendtextmessage($TS3targetmode, $TS3target, $TS3msg)
; Parameters ....: $TS3targetmode - Targettyp (1-3)
;				   $TS3target - TargetID (serverID|channelID|clientID)
;				   $TS3msg - Messagetext
; Return values .: Success - Returns : 1
;                  Failure - Returns 0 and Sets @Error:
;                  |0 - No error.
;                  |1 - Error: Set return - Error message
; Author ........: chip
;
; ;==========================================================================================
Func _TS3sendtextmessage($TS3targetmode, $TS3target, $TS3msg)
	$TS3msg = StringReplace($TS3msg, " ", "\s")
	TCPSend($TS3connection, "sendtextmessage targetmode=" & $TS3targetmode & " target=" & $TS3target & " msg=" & $TS3msg & Chr(10))
	While 1
		$recv = TCPRecv($TS3connection, 2048)
		$recv = StringReplace($recv, @LF, @CRLF)
		$recv = StringReplace($recv, @CRLF & @CR, @CRLF)
		If StringInStr($recv, "error") Then
			$id = _StringBetween($recv, "id=", " msg")
			Switch $id[0]
				Case "0"
					Return 1
				Case Else
					Return SetError(1, 0, _TS3errors($recv))
			EndSwitch
		EndIf
	WEnd
EndFunc   ;==>_TS3sendtextmessage


; #FUNCTION# ;===============================================================================
;
; Name...........: _TS3logview
; Description ...: Displays a specified number of entries from the servers log.
; AutoIt Version : V3.3.6.0
; Syntax.........: _TS3logview($TS3limitcount[, $TS3comparator="="[, $TS3timestamp = ""]])
; Parameters ....: $TS3limitcount - Count results
; 				   $TS3limitcount -  Optional: (Default = "=") : Comparator (<|>|=)
;				   $TS3limitcount -  Optional: (Default = "") : Log-Timestamp
; Return values .: Success - Returns : 1
;                  Failure - Returns 0 and Sets @Error:
;                  |0 - No error.
;                  |1 - Error: Set return - Error message
; Author ........: chip
;
; ;==========================================================================================
Func _TS3logview($TS3limitcount, $TS3comparator = "=", $TS3timestamp = "")
	If $TS3timestamp <> "" Then
		$TS3limitcount = $TS3limitcount & " comparator=" & $TS3comparator & " timestamp=" & $TS3timestamp
	EndIf
	TCPSend($TS3connection, "logview limitcount=" & $TS3limitcount & Chr(10))
	While 1
		$recv = TCPRecv($TS3connection, 2048)
		$recv = StringReplace($recv, @LF, @CRLF)
		$recv = StringReplace($recv, @CRLF & @CR, @CRLF)
		If StringInStr($recv, "timestamp=") Then
			$recv = StringReplace($recv, "error id=0 msg=ok", "")
			Return $recv
		ElseIf StringInStr($recv, "error") Then
			Return SetError(1, 0, _TS3errors($recv))
			ExitLoop
		EndIf
	WEnd
EndFunc   ;==>_TS3logview



; #FUNCTION# ;===============================================================================
;
; Name...........: _TS3logadd
; Description ...: Writes a custom entry into the servers log. Depending on your permissions, you'll be able to add entries into the server instance log and/or your virtual servers log. The loglevel parameter specifies the type of the entry.
; AutoIt Version : V3.3.6.0
; Syntax.........: _TS3logadd($TS3loglevel, $TS3msg)
; Parameters ....: $TS3loglevel - Loglevel (1-4)
;				   $TS3msg - Messagetext
; Return values .: Success - Returns : 1
;                  Failure - Returns 0 and Sets @Error:
;                  |0 - No error.
;                  |1 - Error: Set return - Error message
; Author ........: chip
;
; ;==========================================================================================
Func _TS3logadd($TS3loglevel, $TS3msg)
	$TS3msg = StringReplace($TS3msg, " ", "\s")
	TCPSend($TS3connection, "logadd loglevel=" & $TS3loglevel & " logmsg=" & $TS3msg & Chr(10))
	While 1
		$recv = TCPRecv($TS3connection, 2048)
		$recv = StringReplace($recv, @LF, @CRLF)
		$recv = StringReplace($recv, @CRLF & @CR, @CRLF)
		If StringInStr($recv, "error") Then
			$id = _StringBetween($recv, "id=", " msg")
			Switch $id[0]
				Case "0"
					Return 1
				Case Else
					Return SetError(1, 0, _TS3errors($recv))
			EndSwitch
		EndIf
	WEnd
EndFunc   ;==>_TS3logadd


; #FUNCTION# ;===============================================================================
;
; Name...........: _TS3channellist
; Description ...: Displays a list of channels created on a virtual server including their ID, order, name, etc. The output can be modified using several command options.
; AutoIt Version : V3.3.6.0
; Syntax.........: _TS3channellist([$TS3topic = false[, $TS3flags = false[, $TS3voice = false[, $TS3limits = false]]]])
; Parameters ....: $TS3topic -  Optional: (Default = false) : Channel topic
; 				   $TS3flags -  Optional: (Default = false) : Channel flags
; 				   $TS3voice -  Optional: (Default = false) : Channel voice
; 				   $TS3limits -  Optional: (Default = false) : Channel limits
; Return values .: Success - Returns : Server snapshot
;                  Failure - Returns 0 and Sets @Error:
;                  |0 - No error.
;                  |1 - Error: Set return - Error message
; Author ........: chip
;
; ;==========================================================================================
Func _TS3channellist($TS3topic = False, $TS3flags = False, $TS3voice = False, $TS3limits = False)
	$send = "channellist"
	If $TS3topic = True Then
		$send = $send & " -topic"
	EndIf
	If $TS3flags = True Then
		$send = $send & " -flags"
	EndIf
	If $TS3voice = True Then
		$send = $send & " -voice"
	EndIf
	If $TS3limits = True Then
		$send = $send & " -limits"
	EndIf
	TCPSend($TS3connection, $send & Chr(10))
	While 1
		$recv = TCPRecv($TS3connection, 2048)
		$recv = StringReplace($recv, @LF, @CRLF)
		$recv = StringReplace($recv, @CRLF & @CR, @CRLF)
		If StringInStr($recv, "cid") Then
			$recv = StringReplace($recv, "error id=0 msg=ok", "")
			Return $recv
		ElseIf StringInStr($recv, "error") Then
			Return SetError(1, 0, _TS3errors($recv))
			ExitLoop
		EndIf
	WEnd
EndFunc   ;==>_TS3channellist


; #FUNCTION# ;===============================================================================
;
; Name...........: _TS3channelinfo
; Description ...: Displays detailed configuration information about a channel including ID, topic, description, etc.
; AutoIt Version : V3.3.6.0
; Syntax.........: _TS3channelinfo($TS3channelid)
; Parameters ....: $TS3channelid - Channel ID
; Return values .: Success - Returns : Channel information
;                  Failure - Returns 0 and Sets @Error:
;                  |0 - No error.
;                  |1 - Error: Set return - Error message
; Author ........: chip
;
; ;==========================================================================================
Func _TS3channelinfo($TS3channelid)
	TCPSend($TS3connection, "channelinfo cid=" & $TS3channelid & Chr(10))
	While 1
		$recv = TCPRecv($TS3connection, 2048)
		$recv = StringReplace($recv, @LF, @CRLF)
		$recv = StringReplace($recv, @CRLF & @CR, @CRLF)
		If StringInStr($recv, "channel_name") Then
			$recv = StringReplace($recv, "error id=0 msg=ok", "")
			Return $recv
		ElseIf StringInStr($recv, "error") Then
			Return SetError(1, 0, _TS3errors($recv))
			ExitLoop
		EndIf
	WEnd
EndFunc   ;==>_TS3channelinfo


; #FUNCTION# ;===============================================================================
;
; Name...........: _TS3channelfind
; Description ...: Displays a list of channels matching a given name pattern.
; AutoIt Version : V3.3.6.0
; Syntax.........: _TS3channelfind($TS3pattern)
; Parameters ....: $TS3pattern - Name pattern
; Return values .: Success - Returns : Channel cid and name
;                  Failure - Returns 0 and Sets @Error:
;                  |0 - No error.
;                  |1 - Error: Set return - Error message
; Author ........: chip
;
; ;==========================================================================================
Func _TS3channelfind($TS3pattern)
	TCPSend($TS3connection, "channelfind pattern=" & $TS3pattern & Chr(10))
	While 1
		$recv = TCPRecv($TS3connection, 2048)
		$recv = StringReplace($recv, @LF, @CRLF)
		$recv = StringReplace($recv, @CRLF & @CR, @CRLF)
		If StringInStr($recv, "cid") Then
			$recv = StringReplace($recv, "error id=0 msg=ok", "")
			Return $recv
		ElseIf StringInStr($recv, "error") Then
			Return SetError(1, 0, _TS3errors($recv))
			ExitLoop
		EndIf
	WEnd
EndFunc   ;==>_TS3channelfind


; #FUNCTION# ;===============================================================================
;
; Name...........: _TS3channelmove
; Description ...: Moves a channel to a new parent channel with the ID cpid. If order is specified, the channel will be sorted right under the channel with the specified ID. If order is set to 0, the channel will be sorted right below the new parent.
; AutoIt Version : V3.3.6.0
; Syntax.........: _TS3channelmove($TS3channelid, $TS3channelparentid[, $TS3order = "0"])
; Parameters ....: $TS3channelid - Channel ID
;				   $TS3channelparentid - Channel parent ID
;				   $TS3order -  Optional: (Default = "0") : Channel order
; Return values .: Success - Returns : 1
;                  Failure - Returns 0 and Sets @Error:
;                  |0 - No error.
;                  |1 - Error: Set return - Error message
; Author ........: chip
;
; ;==========================================================================================
Func _TS3channelmove($TS3channelid, $TS3channelparentid, $TS3order = "0")
	TCPSend($TS3connection, "channelmove cid=" & $TS3channelid & " cpid=" & $TS3channelparentid & " order=" & $TS3order & Chr(10))
	While 1
		$recv = TCPRecv($TS3connection, 2048)
		$recv = StringReplace($recv, @LF, @CRLF)
		$recv = StringReplace($recv, @CRLF & @CR, @CRLF)
		If StringInStr($recv, "error") Then
			$id = _StringBetween($recv, "id=", " msg")
			Switch $id[0]
				Case "0"
					Return 1
				Case Else
					Return SetError(1, 0, _TS3errors($recv))
			EndSwitch
		EndIf
	WEnd
EndFunc   ;==>_TS3channelmove


; #FUNCTION# ;===============================================================================
;
; Name...........: _TS3channelcreate
; Description ...: Creates a new channel using the given properties and displays its ID.
; AutoIt Version : V3.3.6.0
; Syntax.........: _TS3channelcreate($TS3channelname[, $TS3properties = ""])
; Parameters ....: $TS3channelname - Channel name
; 				   $TS3properties - Optional: (Default = "") : Channel properties
; Return values .: Success - Returns : Channel cid
;                  Failure - Returns 0 and Sets @Error:
;                  |0 - No error.
;                  |1 - Error: Set return - Error message
; Author ........: chip
;
; ;==========================================================================================
Func _TS3channelcreate($TS3channelname, $TS3properties = "")
	$TS3channelname = StringReplace($TS3channelname, " ", "\s")
	If $TS3properties <> "" Then
		$TS3channelname = $TS3channelname & " " & $TS3properties
	EndIf
	TCPSend($TS3connection, "channelcreate channel_name=" & $TS3channelname & Chr(10))
	While 1
		$recv = TCPRecv($TS3connection, 2048)
		$recv = StringReplace($recv, @LF, @CRLF)
		$recv = StringReplace($recv, @CRLF & @CR, @CRLF)
		If StringInStr($recv, "cid") Then
			$recv = StringReplace($recv, "error id=0 msg=ok", "")
			$recv = StringTrimLeft($recv, 4)
			Return $recv
		ElseIf StringInStr($recv, "error") Then
			Return SetError(1, 0, _TS3errors($recv))
			ExitLoop
		EndIf
	WEnd
EndFunc   ;==>_TS3channelcreate


; #FUNCTION# ;===============================================================================
;
; Name...........: _TS3channeledit
; Description ...: Changes a channels configuration using given properties.
; AutoIt Version : V3.3.6.0
; Syntax.........: _TS3channeledit($TS3channelid, $TS3properties)
; Parameters ....: $TS3channelid - Channel ID
; 				   $TS3properties - Channel properties
; Return values .: Success - Returns : 1
;                  Failure - Returns 0 and Sets @Error:
;                  |0 - No error.
;                  |1 - Error: Set return - Error message
; Author ........: chip
;
; ;==========================================================================================
Func _TS3channeledit($TS3channelid, $TS3properties)
	TCPSend($TS3connection, "channeledit cid=" & $TS3channelid & " " & $TS3properties & Chr(10))
	While 1
		$recv = TCPRecv($TS3connection, 2048)
		$recv = StringReplace($recv, @LF, @CRLF)
		$recv = StringReplace($recv, @CRLF & @CR, @CRLF)
		If StringInStr($recv, "error") Then
			$id = _StringBetween($recv, "id=", " msg")
			Switch $id[0]
				Case "0"
					Return 1
				Case Else
					Return SetError(1, 0, _TS3errors($recv))
			EndSwitch
		EndIf
	WEnd
EndFunc   ;==>_TS3channeledit


; #FUNCTION# ;===============================================================================
;
; Name...........: _TS3channeldelete
; Description ...: Deletes an existing channel by ID. If force is set to 1, the channel will be deleted even if there are clients within.
; AutoIt Version : V3.3.6.0
; Syntax.........: _TS3channeldelete($TS3channelid[, $TS3force = "0"])
; Parameters ....: $TS3channelid - Channel ID
; 				   $TS3force -  Optional: (Default = "0") : Force delete
; Return values .: Success - Returns : 1
;                  Failure - Returns 0 and Sets @Error:
;                  |0 - No error.
;                  |1 - Error: Set return - Error message
; Author ........: chip
;
; ;==========================================================================================
Func _TS3channeldelete($TS3channelid, $TS3force = "0")
	TCPSend($TS3connection, "channeldelete cid=" & $TS3channelid & " force=" & $TS3force & Chr(10))
	While 1
		$recv = TCPRecv($TS3connection, 2048)
		$recv = StringReplace($recv, @LF, @CRLF)
		$recv = StringReplace($recv, @CRLF & @CR, @CRLF)
		If StringInStr($recv, "error") Then
			$id = _StringBetween($recv, "id=", " msg")
			Switch $id[0]
				Case "0"
					Return 1
				Case Else
					Return SetError(1, 0, _TS3errors($recv))
			EndSwitch
		EndIf
	WEnd
EndFunc   ;==>_TS3channeldelete


; #FUNCTION# ;===============================================================================
;
; Name...........: _TS3channelpermlist
; Description ...: Displays a list of permissions defined for a channel.
; AutoIt Version : V3.3.6.0
; Syntax.........: _TS3channelpermlist($TS3channelid)
; Parameters ....: $TS3channelid - Channel ID
; Return values .: Success - Returns : Permissions list
;                  Failure - Returns 0 and Sets @Error:
;                  |0 - No error.
;                  |1 - Error: Set return - Error message
; Author ........: chip
;
; ;==========================================================================================
Func _TS3channelpermlist($TS3channelid)
	TCPSend($TS3connection, "channelpermlist cid=" & $TS3channelid & Chr(10))
	While 1
		$recv = TCPRecv($TS3connection, 2048)
		$recv = StringReplace($recv, @LF, @CRLF)
		$recv = StringReplace($recv, @CRLF & @CR, @CRLF)
		If StringInStr($recv, "cid") Then
			$recv = StringReplace($recv, "error id=0 msg=ok", "")
			Return $recv
		ElseIf StringInStr($recv, "error") Then
			Return SetError(1, 0, _TS3errors($recv))
			ExitLoop
		EndIf
	WEnd
EndFunc   ;==>_TS3channelpermlist


; #FUNCTION# ;===============================================================================
;
; Name...........: _TS3channeladdperm
; Description ...: Adds a specified permissions to a channel.
; AutoIt Version : V3.3.6.0
; Syntax.........: _TS3channeladdperm($TS3channelid, $TS3permname, $TS3permvalue)
; Parameters ....: $TS3channelid - Channel ID
;				   $TS3permname - Permission name
;				   $TS3permvalue - Permission value
; Return values .: Success - Returns : 1
;                  Failure - Returns 0 and Sets @Error:
;                  |0 - No error.
;                  |1 - Error: Set return - Error message
; Author ........: chip
;
; ;==========================================================================================
Func _TS3channeladdperm($TS3channelid, $TS3permname, $TS3permvalue)
	TCPSend($TS3connection, "channeladdperm cid=" & $TS3channelid & " permsid=" & $TS3permname & " permvalue=" & $TS3permvalue & Chr(10))
	While 1
		$recv = TCPRecv($TS3connection, 2048)
		$recv = StringReplace($recv, @LF, @CRLF)
		$recv = StringReplace($recv, @CRLF & @CR, @CRLF)
		If StringInStr($recv, "error") Then
			$id = _StringBetween($recv, "id=", " msg")
			Switch $id[0]
				Case "0"
					Return 1
				Case Else
					Return SetError(1, 0, _TS3errors($recv))
			EndSwitch
		EndIf
	WEnd
EndFunc   ;==>_TS3channeladdperm


; #FUNCTION# ;===============================================================================
;
; Name...........: _TS3channeldelperm
; Description ...: Removes a specified permissions from a channel.
; AutoIt Version : V3.3.6.0
; Syntax.........: _TS3channeldelperm($TS3channelid, $TS3permname)
; Parameters ....: $TS3channelid - Channel ID
;				   $TS3permname - Permission name
; Return values .: Success - Returns : 1
;                  Failure - Returns 0 and Sets @Error:
;                  |0 - No error.
;                  |1 - Error: Set return - Error message
; Author ........: chip
;
; ;==========================================================================================
Func _TS3channeldelperm($TS3channelid, $TS3permname)
	TCPSend($TS3connection, "channeldelperm cid=" & $TS3channelid & " permsid=" & $TS3permname & Chr(10))
	While 1
		$recv = TCPRecv($TS3connection, 2048)
		$recv = StringReplace($recv, @LF, @CRLF)
		$recv = StringReplace($recv, @CRLF & @CR, @CRLF)
		If StringInStr($recv, "error") Then
			$id = _StringBetween($recv, "id=", " msg")
			Switch $id[0]
				Case "0"
					Return 1
				Case Else
					Return SetError(1, 0, _TS3errors($recv))
			EndSwitch
		EndIf
	WEnd
EndFunc   ;==>_TS3channeldelperm


; #FUNCTION# ;===============================================================================
;
; Name...........: _TS3channelgrouplist
; Description ...: Displays a list of channel groups available on the selected virtual server.
; AutoIt Version : V3.3.6.0
; Syntax.........: _TS3channelgrouplist()
; Parameters ....:
; Return values .: Success - Returns : Group list
;                  Failure - Returns 0 and Sets @Error:
;                  |0 - No error.
;                  |1 - Error: Set return - Error message
; Author ........: chip
;
; ;==========================================================================================
Func _TS3channelgrouplist()
	TCPSend($TS3connection, "channelgrouplist" & Chr(10))
	While 1
		$recv = TCPRecv($TS3connection, 2048)
		$recv = StringReplace($recv, @LF, @CRLF)
		$recv = StringReplace($recv, @CRLF & @CR, @CRLF)
		If StringInStr($recv, "cgid") Then
			$recv = StringReplace($recv, "error id=0 msg=ok", "")
			Return $recv
		ElseIf StringInStr($recv, "error") Then
			Return SetError(1, 0, _TS3errors($recv))
			ExitLoop
		EndIf
	WEnd
EndFunc   ;==>_TS3channelgrouplist


; #FUNCTION# ;===============================================================================
;
; Name...........: _TS3channelgroupadd
; Description ...: Creates a new channel group using a given name and displays its ID.
; AutoIt Version : V3.3.6.0
; Syntax.........: _TS3channelgroupadd($TS3name)
; Parameters ....: $TS3name - Group name
; Return values .: Success - Returns : Group cgid
;                  Failure - Returns 0 and Sets @Error:
;                  |0 - No error.
;                  |1 - Error: Set return - Error message
; Author ........: chip
;
; ;==========================================================================================
Func _TS3channelgroupadd($TS3name)
	$TS3name = StringReplace($TS3name, " ", "\s")
	TCPSend($TS3connection, "channelgroupadd name=" & $TS3name & Chr(10))
	While 1
		$recv = TCPRecv($TS3connection, 2048)
		$recv = StringReplace($recv, @LF, @CRLF)
		$recv = StringReplace($recv, @CRLF & @CR, @CRLF)
		If StringInStr($recv, "cgid") Then
			$recv = StringReplace($recv, "error id=0 msg=ok", "")
			$recv = StringTrimLeft($recv, 5)
			Return $recv
		ElseIf StringInStr($recv, "error") Then
			Return SetError(1, 0, _TS3errors($recv))
			ExitLoop
		EndIf
	WEnd
EndFunc   ;==>_TS3channelgroupadd


; #FUNCTION# ;===============================================================================
;
; Name...........: _TS3channelgroupdel
; Description ...: Deletes a channel group by ID. If force is set to 1, the channel group will be deleted even if there are clients within.
; AutoIt Version : V3.3.6.0
; Syntax.........: _TS3channelgroupdel($TS3groupid[, $TS3force = "0"])
; Parameters ....: $TS3groupid - Group ID
; 				   $TS3force -  Optional: (Default = "0") : Force delete
; Return values .: Success - Returns : 1
;                  Failure - Returns 0 and Sets @Error:
;                  |0 - No error.
;                  |1 - Error: Set return - Error message
; Author ........: chip
;
; ;==========================================================================================
Func _TS3channelgroupdel($TS3groupid, $TS3force = "0")
	TCPSend($TS3connection, "channelgroupdel cgid=" & $TS3groupid & " force=" & $TS3force & Chr(10))
	While 1
		$recv = TCPRecv($TS3connection, 2048)
		$recv = StringReplace($recv, @LF, @CRLF)
		$recv = StringReplace($recv, @CRLF & @CR, @CRLF)
		If StringInStr($recv, "error") Then
			$id = _StringBetween($recv, "id=", " msg")
			Switch $id[0]
				Case "0"
					Return 1
				Case Else
					Return SetError(1, 0, _TS3errors($recv))
			EndSwitch
		EndIf
	WEnd
EndFunc   ;==>_TS3channelgroupdel


; #FUNCTION# ;===============================================================================
;
; Name...........: _TS3channelgrouprename
; Description ...: Changes the name of a specified channel group.
; AutoIt Version : V3.3.6.0
; Syntax.........: _TS3channelgrouprename($TS3groupid, $TS3name)
; Parameters ....: $TS3groupid - Group ID
; 				   $TS3name -  New group name
; Return values .: Success - Returns : 1
;                  Failure - Returns 0 and Sets @Error:
;                  |0 - No error.
;                  |1 - Error: Set return - Error message
; Author ........: chip
;
; ;==========================================================================================
Func _TS3channelgrouprename($TS3groupid, $TS3name)
	$TS3name = StringReplace($TS3name, " ", "\s")
	TCPSend($TS3connection, "channelgrouprename cgid=" & $TS3groupid & " name=" & $TS3name & Chr(10))
	While 1
		$recv = TCPRecv($TS3connection, 2048)
		$recv = StringReplace($recv, @LF, @CRLF)
		$recv = StringReplace($recv, @CRLF & @CR, @CRLF)
		If StringInStr($recv, "error") Then
			$id = _StringBetween($recv, "id=", " msg")
			Switch $id[0]
				Case "0"
					Return 1
				Case Else
					Return SetError(1, 0, _TS3errors($recv))
			EndSwitch
		EndIf
	WEnd
EndFunc   ;==>_TS3channelgrouprename


; #FUNCTION# ;===============================================================================
;
; Name...........: _TS3channelgroupaddperm
; Description ...: Adds a specified permissions to the server group specified with sgid
; AutoIt Version : V3.3.6.0
; Syntax.........: _TS3channelgroupaddperm($TS3groupid, $TS3permsid, $TS3permvalue)
; Parameters ....: $TS3groupid - Group id
;				   $TS3permsid - Permissions name
;				   $TS3permvalue - Permissions value
; Return values .: Success - Returns : 1
;                  Failure - Returns 0 and Sets @Error:
;                  |0 - No error.
;                  |1 - Error: Set return - Error message
; Author ........: chip
;
; ;==========================================================================================
Func _TS3channelgroupaddperm($TS3groupid, $TS3permsid, $TS3permvalue)
	TCPSend($TS3connection, "channelgroupaddperm cgid=" & $TS3groupid & " permsid=" & $TS3permsid & " permvalue=" & $TS3permvalue & Chr(10))
	While 1
		$recv = TCPRecv($TS3connection, 2048)
		$recv = StringReplace($recv, @LF, @CRLF)
		$recv = StringReplace($recv, @CRLF & @CR, @CRLF)
		If StringInStr($recv, "error") Then
			$id = _StringBetween($recv, "id=", " msg")
			Switch $id[0]
				Case "0"
					Return 1
				Case Else
					Return SetError(1, 0, _TS3errors($recv))
			EndSwitch
			ExitLoop
		EndIf
	WEnd
EndFunc   ;==>_TS3channelgroupaddperm


; #FUNCTION# ;===============================================================================
;
; Name...........: _TS3channelgroupdelperm
; Description ...: Removes a specified permissions from the server group specified with sgid.
; AutoIt Version : V3.3.6.0
; Syntax.........: _TS3channelgroupdelperm($TS3groupid, $TS3permsid)
; Parameters ....: $TS3groupid - Group id
;				   $TS3permsid - Permissions name
; Return values .: Success - Returns : 1
;                  Failure - Returns 0 and Sets @Error:
;                  |0 - No error.
;                  |1 - Error: Set return - Error message
; Author ........: chip
;
; ;==========================================================================================
Func _TS3channelgroupdelperm($TS3groupid, $TS3permsid)
	TCPSend($TS3connection, "channelgroupdelperm cgid=" & $TS3groupid & " permsid=" & $TS3permsid & Chr(10))
	While 1
		$recv = TCPRecv($TS3connection, 2048)
		$recv = StringReplace($recv, @LF, @CRLF)
		$recv = StringReplace($recv, @CRLF & @CR, @CRLF)
		If StringInStr($recv, "error") Then
			$id = _StringBetween($recv, "id=", " msg")
			Switch $id[0]
				Case "0"
					Return 1
				Case Else
					Return SetError(1, 0, _TS3errors($recv))
			EndSwitch
			ExitLoop
		EndIf
	WEnd
EndFunc   ;==>_TS3channelgroupdelperm


; #FUNCTION# ;===============================================================================
;
; Name...........: _TS3channelgrouppermlist
; Description ...: Displays a list of permissions assigned to the channel group specified with cgid.
; AutoIt Version : V3.3.6.0
; Syntax.........: _TS3channelgrouppermlist($TS3groupid)
; Parameters ....: $TS3groupid - Group id
; Return values .: Success - Returns : Group permissions
;                  Failure - Returns 0 and Sets @Error:
;                  |0 - No error.
;                  |1 - Error: Set return - Error message
; Author ........: chip
;
; ;==========================================================================================
Func _TS3channelgrouppermlist($TS3groupid)
	TCPSend($TS3connection, "servergrouppermlist cgid=" & $TS3groupid & Chr(10))
	While 1
		$recv = TCPRecv($TS3connection, 2048)
		$recv = StringReplace($recv, @LF, @CRLF)
		$recv = StringReplace($recv, @CRLF & @CR, @CRLF)
		If StringInStr($recv, "permid") Then
			$recv = StringReplace($recv, "error id=0 msg=ok", "")
			Return $recv
		ElseIf StringInStr($recv, "error") Then
			Return SetError(1, 0, _TS3errors($recv))
			ExitLoop
		EndIf
	WEnd
EndFunc   ;==>_TS3channelgrouppermlist


; #FUNCTION# ;===============================================================================
;
; Name...........: _TS3channelgroupclientlist
; Description ...: Displays all the client and/or channel IDs currently assigned to channel groups. All three parameters are optional so you're free to choose the most suitable combination for your requirements.
; AutoIt Version : V3.3.6.0
; Syntax.........: _TS3channelgroupclientlist([$TS3channelid = ""[, $TS3clientdbid = ""[, TS3groupid = ""]]])
; Parameters ....: $TS3channelid -  Optional: (Default = "") : Channel id
; 				   $TS3clientdbid-  Optional: (Default = "") : Client dbid
; 				   $TS3groupid -  Optional: (Default = "") : Group id
; Return values .: Success - Returns : Clientlist
;                  Failure - Returns 0 and Sets @Error:
;                  |0 - No error.
;                  |1 - Error: Set return - Error message
; Author ........: chip
;
; ;==========================================================================================
Func _TS3channelgroupclientlist($TS3channelid = "", $TS3clientdbid = "", $TS3groupid = "")
	$TS3listwert = "channelgroupclientlist"
	If $TS3channelid <> "" Then
		$TS3listwert = $TS3listwert & " cid=" & $TS3channelid
	EndIf
	If $TS3clientdbid <> "" Then
		$TS3listwert = $TS3listwert & " cldbid=" & $TS3clientdbid
	EndIf
	If $TS3groupid <> "" Then
		$TS3listwert = $TS3listwert & " cgid=" & $TS3groupid
	EndIf
	TCPSend($TS3connection, $TS3listwert & Chr(10))
	While 1
		$recv = TCPRecv($TS3connection, 2048)
		$recv = StringReplace($recv, @LF, @CRLF)
		$recv = StringReplace($recv, @CRLF & @CR, @CRLF)
		If StringInStr($recv, "cid") Then
			$recv = StringReplace($recv, "error id=0 msg=ok", "")
			Return $recv
		ElseIf StringInStr($recv, "error") Then
			Return SetError(1, 0, _TS3errors($recv))
			ExitLoop
		EndIf
	WEnd
EndFunc   ;==>_TS3channelgroupclientlist


; #FUNCTION# ;===============================================================================
;
; Name...........: _TS3setclientchannelgroup
; Description ...: Sets the channel group of a client to the ID specified with cgid.
; AutoIt Version : V3.3.6.0
; Syntax.........: _TS3setclientchannelgroup($TS3groupid, $TS3channelid, $TS3clientdbid)
; Parameters ....: $TS3groupid - Group id
;				   $TS3channelid - Channel ID
;				   $TS3clientdbid - Client db ID
; Return values .: Success - Returns : 1
;                  Failure - Returns 0 and Sets @Error:
;                  |0 - No error.
;                  |1 - Error: Set return - Error message
; Author ........: chip
;
; ;==========================================================================================
Func _TS3setclientchannelgroup($TS3groupid, $TS3channelid, $TS3clientdbid)
	TCPSend($TS3connection, "setclientchannelgroup cgid=" & $TS3groupid & " cid=" & $TS3channelid & " cldbid=" & $TS3clientdbid & Chr(10))
	While 1
		$recv = TCPRecv($TS3connection, 2048)
		$recv = StringReplace($recv, @LF, @CRLF)
		$recv = StringReplace($recv, @CRLF & @CR, @CRLF)
		If StringInStr($recv, "error") Then
			$id = _StringBetween($recv, "id=", " msg")
			Switch $id[0]
				Case "0"
					Return 1
				Case Else
					Return SetError(1, 0, _TS3errors($recv))
			EndSwitch
			ExitLoop
		EndIf
	WEnd
EndFunc   ;==>_TS3setclientchannelgroup


; #FUNCTION# ;===============================================================================
;
; Name...........: _TS3clientlist
; Description ...: Displays a list of clients online on a virtual server including their ID, nickname, status flags, etc. The output can be modified using several command options. Please note that the output will only contain clients which are currently in channels you're able to subscribe to.
; AutoIt Version : V3.3.6.0
; Syntax.........: _TS3clientlist([$TS3uid = "0"[, $TS3away = "0"[, $TS3voice = "0"[, $TS3times = "0"[, $TS3groups = "0"]]]]])
; Parameters ....: $TS3uid  -  Optional: (Default = "0") : UID
; 				   $TS3away-  Optional: (Default = "0") : Away
; 				   $TS3voice -  Optional: (Default = "0") : Voice
; 				   $TS3times-  Optional: (Default = "0") : Times
; 				   $TS3groups -  Optional: (Default = "0") : Groups
; Return values .: Success - Returns : Online Clients
;                  Failure - Returns 0 and Sets @Error:
;                  |0 - No error.
;                  |1 - Error: Set return - Error message
; Author ........: chip
;
; ;==========================================================================================
Func _TS3clientlist($TS3uid = "0", $TS3away = "0", $TS3voice = "0", $TS3times = "0", $TS3groups = "0")
	$TS3listwert = "clientlist"
	If $TS3uid <> "0" Then
		$TS3listwert = $TS3listwert & " -uid"
	EndIf
	If $TS3away <> "0" Then
		$TS3listwert = $TS3listwert & " -away"
	EndIf
	If $TS3voice <> "0" Then
		$TS3listwert = $TS3listwert & " -voice"
	EndIf
	If $TS3times <> "0" Then
		$TS3listwert = $TS3listwert & " -times"
	EndIf
	If $TS3groups <> "0" Then
		$TS3listwert = $TS3listwert & " -groups"
	EndIf
	TCPSend($TS3connection, $TS3listwert & Chr(10))
	While 1
		$recv = TCPRecv($TS3connection, 2048)
		$recv = StringReplace($recv, @LF, @CRLF)
		$recv = StringReplace($recv, @CRLF & @CR, @CRLF)
		If StringInStr($recv, "clid") Then
			$recv = StringReplace($recv, "error id=0 msg=ok", "")
			Return $recv
		ElseIf StringInStr($recv, "error") Then
			Return SetError(1, 0, _TS3errors($recv))
			ExitLoop
		EndIf
	WEnd
EndFunc   ;==>_TS3clientlist


; #FUNCTION# ;===============================================================================
;
; Name...........: _TS3clientinfo
; Description ...: Displays a list of permissions assigned to the channel group specified with cgid.
; AutoIt Version : V3.3.6.0
; Syntax.........: _TS3clientinfo($TS3clientid)
; Parameters ....: $TS3clientid - Client id
; Return values .: Success - Returns : Group permissions
;                  Failure - Returns 0 and Sets @Error:
;                  |0 - No error.
;                  |1 - Error: Set return - Error message
; Author ........: chip
;
; ;==========================================================================================
Func _TS3clientinfo($TS3clientid)
	TCPSend($TS3connection, "clientinfo clid=" & $TS3clientid & Chr(10))
	While 1
		$recv = TCPRecv($TS3connection, 2048)
		$recv = StringReplace($recv, @LF, @CRLF)
		$recv = StringReplace($recv, @CRLF & @CR, @CRLF)
		If StringInStr($recv, "client_unique_identifier") Then
			$recv = StringReplace($recv, "error id=0 msg=ok", "")
			Return $recv
		ElseIf StringInStr($recv, "error") Then
			Return SetError(1, 0, _TS3errors($recv))
			ExitLoop
		EndIf
	WEnd
EndFunc   ;==>_TS3clientinfo


; #FUNCTION# ;===============================================================================
;
; Name...........: _TS3clientfind
; Description ...: Displays a list of clients matching a given name pattern.
; AutoIt Version : V3.3.6.0
; Syntax.........: _TS3clientfind($TS3pattern)
; Parameters ....: $TS3pattern - Name pattern
; Return values .: Success - Returns : Channel cid and name
;                  Failure - Returns 0 and Sets @Error:
;                  |0 - No error.
;                  |1 - Error: Set return - Error message
; Author ........: chip
;
; ;==========================================================================================
Func _TS3clientfind($TS3pattern)
	TCPSend($TS3connection, "clientfind pattern=" & $TS3pattern & Chr(10))
	While 1
		$recv = TCPRecv($TS3connection, 2048)
		$recv = StringReplace($recv, @LF, @CRLF)
		$recv = StringReplace($recv, @CRLF & @CR, @CRLF)
		If StringInStr($recv, "clid") Then
			$recv = StringReplace($recv, "error id=0 msg=ok", "")
			Return $recv
		ElseIf StringInStr($recv, "error") Then
			Return SetError(1, 0, _TS3errors($recv))
			ExitLoop
		EndIf
	WEnd
EndFunc   ;==>_TS3clientfind


; #FUNCTION# ;===============================================================================
;
; Name...........: _TS3clientedit
; Description ...: Changes a channels configuration using given properties.
; AutoIt Version : V3.3.6.0
; Syntax.........: _TS3clientedit($TS3clientid, $TS3properties)
; Parameters ....: $TS3clientid - Client ID
; 				   $TS3properties - Channel properties
; Return values .: Success - Returns : 1
;                  Failure - Returns 0 and Sets @Error:
;                  |0 - No error.
;                  |1 - Error: Set return - Error message
; Author ........: chip
;
; ;==========================================================================================
Func _TS3clientedit($TS3clientid, $TS3properties)
	TCPSend($TS3connection, "clientedit clid=" & $TS3clientid & " " & $TS3properties & Chr(10))
	While 1
		$recv = TCPRecv($TS3connection, 2048)
		$recv = StringReplace($recv, @LF, @CRLF)
		$recv = StringReplace($recv, @CRLF & @CR, @CRLF)
		If StringInStr($recv, "error") Then
			$id = _StringBetween($recv, "id=", " msg")
			Switch $id[0]
				Case "0"
					Return 1
				Case Else
					Return SetError(1, 0, _TS3errors($recv))
			EndSwitch
		EndIf
	WEnd
EndFunc   ;==>_TS3clientedit


; #FUNCTION# ;===============================================================================
;
; Name...........: _TS3clientdblist
; Description ...: Displays a list of client identities known by the server including their database ID, last nickname, etc.
; AutoIt Version : V3.3.6.0
; Syntax.........: _TS3clientdblist()
; Parameters ....:
; Return values .: Success - Returns : Client list
;                  Failure - Returns 0 and Sets @Error:
;                  |0 - No error.
;                  |1 - Error: Set return - Error message
; Author ........: chip
;
; ;==========================================================================================
Func _TS3clientdblist()
	TCPSend($TS3connection, "clientdblist" & Chr(10))
	While 1
		$recv = TCPRecv($TS3connection, 2048)
		$recv = StringReplace($recv, @LF, @CRLF)
		$recv = StringReplace($recv, @CRLF & @CR, @CRLF)
		If StringInStr($recv, "cldbid") Then
			$recv = StringReplace($recv, "error id=0 msg=ok", "")
			Return $recv
		ElseIf StringInStr($recv, "error") Then
			Return SetError(1, 0, _TS3errors($recv))
			ExitLoop
		EndIf
	WEnd
EndFunc   ;==>_TS3clientdblist


; #FUNCTION# ;===============================================================================
;
; Name...........: _TS3clientdbfind
; Description ...: Displays a list of clients matching a given name pattern.
; AutoIt Version : V3.3.6.0
; Syntax.........: _TS3clientdbfind($TS3pattern[, $TS3uid = "0"])
; Parameters ....: $TS3pattern - Name/UID pattern
; 				   $TS3uid -  Optional: (Default = "0") : Pattern UID set to 1
; Return values .: Success - Returns : Client list
;                  Failure - Returns 0 and Sets @Error:
;                  |0 - No error.
;                  |1 - Error: Set return - Error message
; Author ........: chip
;
; ;==========================================================================================
Func _TS3clientdbfind($TS3pattern, $TS3uid = "0")
	If $TS3uid <> "0" Then
		$TS3pattern = $TS3pattern & " -uid"
	EndIf
	TCPSend($TS3connection, "clientfind pattern=" & $TS3pattern & Chr(10))
	While 1
		$recv = TCPRecv($TS3connection, 2048)
		$recv = StringReplace($recv, @LF, @CRLF)
		$recv = StringReplace($recv, @CRLF & @CR, @CRLF)
		If StringInStr($recv, "clid") Then
			$recv = StringReplace($recv, "error id=0 msg=ok", "")
			Return $recv
		ElseIf StringInStr($recv, "error") Then
			Return SetError(1, 0, _TS3errors($recv))
			ExitLoop
		EndIf
	WEnd
EndFunc   ;==>_TS3clientdbfind


; #FUNCTION# ;===============================================================================
;
; Name...........: _TS3clientdbedit
; Description ...: Changes a clients settings using given properties.
; AutoIt Version : V3.3.6.0
; Syntax.........: _TS3clientdbedit($TS3clientdbid, $TS3properties)
; Parameters ....: $TS3clientdbid - Client dbid
; 				   $TS3properties - Channel properties
; Return values .: Success - Returns : 1
;                  Failure - Returns 0 and Sets @Error:
;                  |0 - No error.
;                  |1 - Error: Set return - Error message
; Author ........: chip
;
; ;==========================================================================================
Func _TS3clientdbedit($TS3clientdbid, $TS3properties)
	TCPSend($TS3connection, "clientdbedit cldbid=" & $TS3clientdbid & " " & $TS3properties & Chr(10))
	While 1
		$recv = TCPRecv($TS3connection, 2048)
		$recv = StringReplace($recv, @LF, @CRLF)
		$recv = StringReplace($recv, @CRLF & @CR, @CRLF)
		If StringInStr($recv, "error") Then
			$id = _StringBetween($recv, "id=", " msg")
			Switch $id[0]
				Case "0"
					Return 1
				Case Else
					Return SetError(1, 0, _TS3errors($recv))
			EndSwitch
		EndIf
	WEnd
EndFunc   ;==>_TS3clientdbedit


; #FUNCTION# ;===============================================================================
;
; Name...........: _TS3clientdbdelete
; Description ...: Deletes a clients properties from the database.
; AutoIt Version : V3.3.6.0
; Syntax.........: _TS3clientdbdelete($TS3clientdbid)
; Parameters ....: $TS3clientdbid - Client dbid
; Return values .: Success - Returns : 1
;                  Failure - Returns 0 and Sets @Error:
;                  |0 - No error.
;                  |1 - Error: Set return - Error message
; Author ........: chip
;
; ;==========================================================================================
Func _TS3clientdbdelete($TS3clientdbid)
	TCPSend($TS3connection, "clientdbdelete cldbid=" & $TS3clientdbid & Chr(10))
	While 1
		$recv = TCPRecv($TS3connection, 2048)
		$recv = StringReplace($recv, @LF, @CRLF)
		$recv = StringReplace($recv, @CRLF & @CR, @CRLF)
		If StringInStr($recv, "error") Then
			$id = _StringBetween($recv, "id=", " msg")
			Switch $id[0]
				Case "0"
					Return 1
				Case Else
					Return SetError(1, 0, _TS3errors($recv))
			EndSwitch
		EndIf
	WEnd
EndFunc   ;==>_TS3clientdbdelete


; #FUNCTION# ;===============================================================================
;
; Name...........: _TS3clientgetids
; Description ...: Displays all client IDs matching the unique identifier specified by cluid.
; AutoIt Version : V3.3.6.0
; Syntax.........: _TS3clientgetids($TS3clientuid)
; Parameters ....: $TS3clientuid - Client uid
; Return values .: Success - Returns : Client data
;                  Failure - Returns 0 and Sets @Error:
;                  |0 - No error.
;                  |1 - Error: Set return - Error message
; Author ........: chip
;
; ;==========================================================================================
Func _TS3clientgetids($TS3clientuid)
	TCPSend($TS3connection, "clientgetids cluid=" & $TS3clientuid & Chr(10))
	While 1
		$recv = TCPRecv($TS3connection, 2048)
		$recv = StringReplace($recv, @LF, @CRLF)
		$recv = StringReplace($recv, @CRLF & @CR, @CRLF)
		If StringInStr($recv, "cluid") Then
			$recv = StringReplace($recv, "error id=0 msg=ok", "")
			Return $recv
		ElseIf StringInStr($recv, "error") Then
			Return SetError(1, 0, _TS3errors($recv))
			ExitLoop
		EndIf
	WEnd
EndFunc   ;==>_TS3clientgetids


; #FUNCTION# ;===============================================================================
;
; Name...........: _TS3clientgetdbidfromuid
; Description ...: Displays the database ID matching the unique identifier specified by cluid.
; AutoIt Version : V3.3.6.0
; Syntax.........: _TS3clientgetdbidfromuid($TS3clientuid)
; Parameters ....: $TS3clientuid - Client uid
; Return values .: Success - Returns : Client data
;                  Failure - Returns 0 and Sets @Error:
;                  |0 - No error.
;                  |1 - Error: Set return - Error message
; Author ........: chip
;
; ;==========================================================================================
Func _TS3clientgetdbidfromuid($TS3clientuid)
	TCPSend($TS3connection, "clientgetdbidfromuid cluid=" & $TS3clientuid & Chr(10))
	While 1
		$recv = TCPRecv($TS3connection, 2048)
		$recv = StringReplace($recv, @LF, @CRLF)
		$recv = StringReplace($recv, @CRLF & @CR, @CRLF)
		If StringInStr($recv, "cluid") Then
			$recv = StringReplace($recv, "error id=0 msg=ok", "")
			Return $recv
		ElseIf StringInStr($recv, "error") Then
			Return SetError(1, 0, _TS3errors($recv))
			ExitLoop
		EndIf
	WEnd
EndFunc   ;==>_TS3clientgetdbidfromuid


; #FUNCTION# ;===============================================================================
;
; Name...........: _TS3clientgetnamefromuid
; Description ...: Displays the database ID and nickname matching the unique identifier specified by cluid.
; AutoIt Version : V3.3.6.0
; Syntax.........: _TS3clientgetnamefromuid($TS3clientuid)
; Parameters ....: $TS3clientuid - Client uid
; Return values .: Success - Returns : Client data
;                  Failure - Returns 0 and Sets @Error:
;                  |0 - No error.
;                  |1 - Error: Set return - Error message
; Author ........: chip
;
; ;==========================================================================================
Func _TS3clientgetnamefromuid($TS3clientuid)
	TCPSend($TS3connection, "clientgetnamefromuid cluid=" & $TS3clientuid & Chr(10))
	While 1
		$recv = TCPRecv($TS3connection, 2048)
		$recv = StringReplace($recv, @LF, @CRLF)
		$recv = StringReplace($recv, @CRLF & @CR, @CRLF)
		If StringInStr($recv, "cluid") Then
			$recv = StringReplace($recv, "error id=0 msg=ok", "")
			Return $recv
		ElseIf StringInStr($recv, "error") Then
			Return SetError(1, 0, _TS3errors($recv))
			ExitLoop
		EndIf
	WEnd
EndFunc   ;==>_TS3clientgetnamefromuid


; #FUNCTION# ;===============================================================================
;
; Name...........: _TS3clientgetnamefromdbid
; Description ...: Displays the unique identifier and nickname matching the database ID specified by cldbid.
; AutoIt Version : V3.3.6.0
; Syntax.........: _TS3clientgetnamefromdbid($TS3clientdbid)
; Parameters ....: $TS3clientdbid - Client dbid
; Return values .: Success - Returns : Client data
;                  Failure - Returns 0 and Sets @Error:
;                  |0 - No error.
;                  |1 - Error: Set return - Error message
; Author ........: chip
;
; ;==========================================================================================
Func _TS3clientgetnamefromdbid($TS3clientdbid)
	TCPSend($TS3connection, "clientgetnamefromdbid cldbid=" & $TS3clientdbid & Chr(10))
	While 1
		$recv = TCPRecv($TS3connection, 2048)
		$recv = StringReplace($recv, @LF, @CRLF)
		$recv = StringReplace($recv, @CRLF & @CR, @CRLF)
		If StringInStr($recv, "cluid") Then
			$recv = StringReplace($recv, "error id=0 msg=ok", "")
			Return $recv
		ElseIf StringInStr($recv, "error") Then
			Return SetError(1, 0, _TS3errors($recv))
			ExitLoop
		EndIf
	WEnd
EndFunc   ;==>_TS3clientgetnamefromdbid


; #FUNCTION# ;===============================================================================
;
; Name...........: _TS3clientsetserverquerylogin
; Description ...: Updates your own ServerQuery login credentials using a specified username. The password will be auto-generated.
; AutoIt Version : V3.3.6.0
; Syntax.........: _TS3clientsetserverquerylogin($TS3username)
; Parameters ....: $TS3username - Username
; Return values .: Success - Returns : ServerQuery password
;                  Failure - Returns 0 and Sets @Error:
;                  |0 - No error.
;                  |1 - Error: Set return - Error message
; Author ........: chip
;
; ;==========================================================================================
Func _TS3clientsetserverquerylogin($TS3username)
	TCPSend($TS3connection, "clientsetserverquerylogin client_login_name=" & $TS3username & Chr(10))
	While 1
		$recv = TCPRecv($TS3connection, 2048)
		$recv = StringReplace($recv, @LF, @CRLF)
		$recv = StringReplace($recv, @CRLF & @CR, @CRLF)
		If StringInStr($recv, "cluid") Then
			$recv = StringReplace($recv, "error id=0 msg=ok", "")
			$recv = StringTrimLeft($recv, 22)
			Return $recv
		ElseIf StringInStr($recv, "error") Then
			Return SetError(1, 0, _TS3errors($recv))
			ExitLoop
		EndIf
	WEnd
EndFunc   ;==>_TS3clientsetserverquerylogin


; #FUNCTION# ;===============================================================================
;
; Name...........: _TS3clientupdate
; Description ...: Change your ServerQuery clients settings using given properties.
; AutoIt Version : V3.3.6.0
; Syntax.........: _TS3clientupdate($TS3properties)
; Parameters ....: $TS3properties - List of Client properties
; Return values .: Success - Returns : 1
;                  Failure - Returns 0 and Sets @Error:
;                  |0 - No error.
;                  |1 - Error: Set return - Error message
; Author ........: chip
;
; ;==========================================================================================
Func _TS3clientupdate($TS3properties)
	TCPSend($TS3connection, "clientupdate " & $TS3properties & Chr(10))
	While 1
		$recv = TCPRecv($TS3connection, 2048)
		$recv = StringReplace($recv, @LF, @CRLF)
		$recv = StringReplace($recv, @CRLF & @CR, @CRLF)
		If StringInStr($recv, "error") Then
			$id = _StringBetween($recv, "id=", " msg")
			Switch $id[0]
				Case "0"
					Return 1
				Case Else
					Return SetError(1, 0, _TS3errors($recv))
			EndSwitch
			ExitLoop
		EndIf
	WEnd
EndFunc   ;==>_TS3clientupdate


; #FUNCTION# ;===============================================================================
;
; Name...........: _TS3clientmove
; Description ...: Moves one clients specified with clid to the channel with ID cid. If the target channel has a password, it needs to be specified with cpw. If the channel has no password, the parameter can be omitted.
; AutoIt Version : V3.3.6.0
; Syntax.........: _TS3clientmove($TS3clientid, $TS3channelid[, $TS3cpw = ""])
; Parameters ....: $TS3clientid - Client id
;				   $TS3channelid - Channel id
; 				   $TS3cpw - Optional: (Default = "") : Channel password
; Return values .: Success - Returns : 1
;                  Failure - Returns 0 and Sets @Error:
;                  |0 - No error.
;                  |1 - Error: Set return - Error message
; Author ........: chip
;
; ;==========================================================================================
Func _TS3clientmove($TS3clientid, $TS3channelid, $TS3cpw = "")
	TCPSend($TS3connection, "clientmove clid=" & $TS3clientid & " cid=" & $TS3channelid & " cpw=" & $TS3cpw & Chr(10))
	While 1
		$recv = TCPRecv($TS3connection, 2048)
		$recv = StringReplace($recv, @LF, @CRLF)
		$recv = StringReplace($recv, @CRLF & @CR, @CRLF)
		If StringInStr($recv, "error") Then
			$id = _StringBetween($recv, "id=", " msg")
			Switch $id[0]
				Case "0"
					Return 1
				Case Else
					Return SetError(1, 0, _TS3errors($recv))
			EndSwitch
			ExitLoop
		EndIf
	WEnd
EndFunc   ;==>_TS3clientmove


; #FUNCTION# ;===============================================================================
;
; Name...........: _TS3clientkick
; Description ...: Kicks one clients specified with clid from their currently joined channel or from the server, depending on reasonid. The reasonmsg parameter specifies a text message sent to the kicked clients.
; AutoIt Version : V3.3.6.0
; Syntax.........: _TS3clientkick($TS3clientid, $TS3reasonid[, $TS3reasonmsg = ""])
; Parameters ....: $TS3clientid - Client id
;				   $TS3reasonid - Reason id (4=kick Channel, 5=kick Server)
; 				   $TS3reasonmsg - Optional: (Default = "") : Kick Message
; Return values .: Success - Returns : 1
;                  Failure - Returns 0 and Sets @Error:
;                  |0 - No error.
;                  |1 - Error: Set return - Error message
; Author ........: chip
;
; ;==========================================================================================
Func _TS3clientkick($TS3clientid, $TS3reasonid, $TS3reasonmsg = "")
	TCPSend($TS3connection, "clientkick clid=" & $TS3clientid & " reasonid=" & $TS3reasonid & " reasonmsg=" & $TS3reasonmsg & Chr(10))
	While 1
		$recv = TCPRecv($TS3connection, 2048)
		$recv = StringReplace($recv, @LF, @CRLF)
		$recv = StringReplace($recv, @CRLF & @CR, @CRLF)
		If StringInStr($recv, "error") Then
			$id = _StringBetween($recv, "id=", " msg")
			Switch $id[0]
				Case "0"
					Return 1
				Case Else
					Return SetError(1, 0, _TS3errors($recv))
			EndSwitch
			ExitLoop
		EndIf
	WEnd
EndFunc   ;==>_TS3clientkick



; #FUNCTION# ;===============================================================================
;
; Name...........: _TS3clientpoke
; Description ...: Sends a poke message to the client specified with clid.
; AutoIt Version : V3.3.6.0
; Syntax.........: _TS3clientpoke($TS3clientid[, $TS3msg = ""])
; Parameters ....: $TS3clientid - Client id
; 				   $TSmsg - Optional: (Default = "") : Poke message
; Return values .: Success - Returns : 1
;                  Failure - Returns 0 and Sets @Error:
;                  |0 - No error.
;                  |1 - Error: Set return - Error message
; Author ........: chip
;
; ;==========================================================================================
Func _TS3clientpoke($TS3clientid, $TS3msg = "")
	$TS3msg = StringReplace($TS3msg, " ", "\s")
	TCPSend($TS3connection, "clientpoke clid=" & $TS3clientid & " msg=" & $TS3msg & Chr(10))
	While 1
		$recv = TCPRecv($TS3connection, 2048)
		$recv = StringReplace($recv, @LF, @CRLF)
		$recv = StringReplace($recv, @CRLF & @CR, @CRLF)
		If StringInStr($recv, "error") Then
			$id = _StringBetween($recv, "id=", " msg")
			Switch $id[0]
				Case "0"
					Return 1
				Case Else
					Return SetError(1, 0, _TS3errors($recv))
			EndSwitch
		EndIf
	WEnd
EndFunc   ;==>_TS3clientpoke


; #FUNCTION# ;===============================================================================
;
; Name...........: _TS3clientpermlist
; Description ...: Displays a list of permissions defined for a channel.
; AutoIt Version : V3.3.6.0
; Syntax.........: _TS3clientpermlist($TS3clientdbid)
; Parameters ....: $TS3clientdbid - Client dbid
; Return values .: Success - Returns : Client permissions list
;                  Failure - Returns 0 and Sets @Error:
;                  |0 - No error.
;                  |1 - Error: Set return - Error message
; Author ........: chip
;
; ;==========================================================================================
Func _TS3clientpermlist($TS3clientdbid)
	TCPSend($TS3connection, "clientpermlist cldbid=" & $TS3clientdbid & Chr(10))
	While 1
		$recv = TCPRecv($TS3connection, 2048)
		$recv = StringReplace($recv, @LF, @CRLF)
		$recv = StringReplace($recv, @CRLF & @CR, @CRLF)
		If StringInStr($recv, "permid") Then
			$recv = StringReplace($recv, "error id=0 msg=ok", "")
			Return $recv
		ElseIf StringInStr($recv, "error") Then
			Return SetError(1, 0, _TS3errors($recv))
			ExitLoop
		EndIf
	WEnd
EndFunc   ;==>_TS3clientpermlist



; #FUNCTION# ;===============================================================================
;
; Name...........: _TS3clientaddperm
; Description ...: Adds a set of specified permissions to a client.
; AutoIt Version : V3.3.6.0
; Syntax.........: _TS3clientaddperm($TS3clientdbid, $TS3permsid, $TS3permvalue[, $TS3permskip = "0"])
; Parameters ....: $TS3clientdbid - Client dbid
;				   $TS3permsid - Permissions name
;				   $TS3permvalue - Permissions value
;				   $TS3permskip - Optional: (Default = "0") : Permission skip
; Return values .: Success - Returns : 1
;                  Failure - Returns 0 and Sets @Error:
;                  |0 - No error.
;                  |1 - Error: Set return - Error message
; Author ........: chip
;
; ;==========================================================================================
Func _TS3clientaddperm($TS3clientdbid, $TS3permsid, $TS3permvalue, $TS3permskip = "0")
	TCPSend($TS3connection, "clientaddperm cldbid=" & $TS3clientdbid & " permsid=" & $TS3permsid & " permvalue=" & $TS3permvalue & " permskip=" & $TS3permskip & Chr(10))
	While 1
		$recv = TCPRecv($TS3connection, 2048)
		$recv = StringReplace($recv, @LF, @CRLF)
		$recv = StringReplace($recv, @CRLF & @CR, @CRLF)
		If StringInStr($recv, "error") Then
			$id = _StringBetween($recv, "id=", " msg")
			Switch $id[0]
				Case "0"
					Return 1
				Case Else
					Return SetError(1, 0, _TS3errors($recv))
			EndSwitch
			ExitLoop
		EndIf
	WEnd
EndFunc   ;==>_TS3clientaddperm


; #FUNCTION# ;===============================================================================
;
; Name...........: _TS3clientdelperm
; Description ...: Removes a set of specified permissions from a client.
; AutoIt Version : V3.3.6.0
; Syntax.........: _TS3clientdelperm($TS3channelid, $TS3permname)
; Parameters ....: $TS3clientdbid - Client dbid
;				   $TS3permname - Permission name
; Return values .: Success - Returns : 1
;                  Failure - Returns 0 and Sets @Error:
;                  |0 - No error.
;                  |1 - Error: Set return - Error message
; Author ........: chip
;
; ;==========================================================================================
Func _TS3clientdelperm($TS3clientdbid, $TS3permname)
	TCPSend($TS3connection, "clientdelperm cldbid=" & $TS3clientdbid & " permsid=" & $TS3permname & Chr(10))
	While 1
		$recv = TCPRecv($TS3connection, 2048)
		$recv = StringReplace($recv, @LF, @CRLF)
		$recv = StringReplace($recv, @CRLF & @CR, @CRLF)
		If StringInStr($recv, "error") Then
			$id = _StringBetween($recv, "id=", " msg")
			Switch $id[0]
				Case "0"
					Return 1
				Case Else
					Return SetError(1, 0, _TS3errors($recv))
			EndSwitch
		EndIf
	WEnd
EndFunc   ;==>_TS3clientdelperm


; #FUNCTION# ;===============================================================================
;
; Name...........: _TS3channelclientpermlist
; Description ...: Displays a list of permissions defined for a client in a specific channel.
; AutoIt Version : V3.3.6.0
; Syntax.........: _TS3channelclientpermlist($TS3channelid, $TS3clientdbid)
; Parameters ....: $TS3channelid - Channel id
; 		           $TS3clientdbid - Client dbid
; Return values .: Success - Returns : Client permissions list
;                  Failure - Returns 0 and Sets @Error:
;                  |0 - No error.
;                  |1 - Error: Set return - Error message
; Author ........: chip
;
; ;==========================================================================================
Func _TS3channelclientpermlist($TS3channelid, $TS3clientdbid)
	TCPSend($TS3connection, "channelclientpermlist cid=" & $TS3channelid & " cldbid=" & $TS3clientdbid & Chr(10))
	While 1
		$recv = TCPRecv($TS3connection, 2048)
		$recv = StringReplace($recv, @LF, @CRLF)
		$recv = StringReplace($recv, @CRLF & @CR, @CRLF)
		If StringInStr($recv, "permid") Then
			$recv = StringReplace($recv, "error id=0 msg=ok", "")
			Return $recv
		ElseIf StringInStr($recv, "error") Then
			Return SetError(1, 0, _TS3errors($recv))
			ExitLoop
		EndIf
	WEnd
EndFunc   ;==>_TS3channelclientpermlist


; #FUNCTION# ;===============================================================================
;
; Name...........: _TS3channelclientaddperm
; Description ...: Adds a set of specified permissions to a client in a specific channel.
; AutoIt Version : V3.3.6.0
; Syntax.........: _TS3channelclientaddperm($TS3channelid, $TS3clientdbid, $TS3permsid, $TS3permvalue)
; Parameters ....: $TS3channelid - Channel id
;			       $TS3clientdbid - Client dbid
;				   $TS3permsid - Permissions name
;				   $TS3permvalue - Permissions value
; Return values .: Success - Returns : 1
;                  Failure - Returns 0 and Sets @Error:
;                  |0 - No error.
;                  |1 - Error: Set return - Error message
; Author ........: chip
;
; ;==========================================================================================
Func _TS3channelclientaddperm($TS3channelid, $TS3clientdbid, $TS3permsid, $TS3permvalue)
	TCPSend($TS3connection, "channelclientaddperm cid=" & $TS3channelid & " cldbid=" & $TS3clientdbid & " permsid=" & $TS3permsid & " permvalue=" & $TS3permvalue & Chr(10))
	While 1
		$recv = TCPRecv($TS3connection, 2048)
		$recv = StringReplace($recv, @LF, @CRLF)
		$recv = StringReplace($recv, @CRLF & @CR, @CRLF)
		If StringInStr($recv, "error") Then
			$id = _StringBetween($recv, "id=", " msg")
			Switch $id[0]
				Case "0"
					Return 1
				Case Else
					Return SetError(1, 0, _TS3errors($recv))
			EndSwitch
			ExitLoop
		EndIf
	WEnd
EndFunc   ;==>_TS3channelclientaddperm


; #FUNCTION# ;===============================================================================
;
; Name...........: _TS3channelclientdelperm
; Description ...: Removes a set of specified permissions from a client in a specific channel.
; AutoIt Version : V3.3.6.0
; Syntax.........: _TS3channelclientdelperm($TS3channelid, $TS3clientdbid, $TS3permname)
; Parameters ....: $TS3channelid - Channelid
;				   $TS3clientdbid - Client dbid
;				   $TS3permname - Permission name
; Return values .: Success - Returns : 1
;                  Failure - Returns 0 and Sets @Error:
;                  |0 - No error.
;                  |1 - Error: Set return - Error message
; Author ........: chip
;
; ;==========================================================================================
Func _TS3channelclientdelperm($TS3channelid, $TS3clientdbid, $TS3permname)
	TCPSend($TS3connection, "channelclientdelperm cid=" & $TS3channelid & " cldbid=" & $TS3clientdbid & " permsid=" & $TS3permname & Chr(10))
	While 1
		$recv = TCPRecv($TS3connection, 2048)
		$recv = StringReplace($recv, @LF, @CRLF)
		$recv = StringReplace($recv, @CRLF & @CR, @CRLF)
		If StringInStr($recv, "error") Then
			$id = _StringBetween($recv, "id=", " msg")
			Switch $id[0]
				Case "0"
					Return 1
				Case Else
					Return SetError(1, 0, _TS3errors($recv))
			EndSwitch
		EndIf
	WEnd
EndFunc   ;==>_TS3channelclientdelperm


; #FUNCTION# ;===============================================================================
;
; Name...........: _TS3permissionlist
; Description ...: Displays a list of permissions available on the server instance including ID, name and description.
; AutoIt Version : V3.3.6.0
; Syntax.........: _TS3permissionlist()
; Parameters ....:
; Return values .: Success - Returns : Permissions list
;                  Failure - Returns 0 and Sets @Error:
;                  |0 - No error.
;                  |1 - Error: Set return - Error message
; Author ........: chip
;
; ;==========================================================================================
Func _TS3permissionlist()
	TCPSend($TS3connection, "permissionlist" & Chr(10))
	While 1
		$recv = TCPRecv($TS3connection, 2048)
		$recv = StringReplace($recv, @LF, @CRLF)
		$recv = StringReplace($recv, @CRLF & @CR, @CRLF)
		If StringInStr($recv, "permid") Then
			$recv = StringReplace($recv, "error id=0 msg=ok", "")
			Return $recv
		ElseIf StringInStr($recv, "error") Then
			Return SetError(1, 0, _TS3errors($recv))
			ExitLoop
		EndIf
	WEnd
EndFunc   ;==>_TS3permissionlist


; #FUNCTION# ;===============================================================================
;
; Name...........: _TS3permidgetbyname
; Description ...: Displays the database ID of one or more permissions specified by permsid.
; AutoIt Version : V3.3.6.0
; Syntax.........: _TS3permidgetbyname($TS3permname)
; Parameters ....:  $TS3permname - Permission name
; Return values .: Success - Returns : Permission
;                  Failure - Returns 0 and Sets @Error:
;                  |0 - No error.
;                  |1 - Error: Set return - Error message
; Author ........: chip
;
; ;==========================================================================================
Func _TS3permidgetbyname($TS3permname)
	TCPSend($TS3connection, "permidgetbyname permsid=" & $TS3permname & Chr(10))
	While 1
		$recv = TCPRecv($TS3connection, 2048)
		$recv = StringReplace($recv, @LF, @CRLF)
		$recv = StringReplace($recv, @CRLF & @CR, @CRLF)
		If StringInStr($recv, "permid") Then
			$recv = StringReplace($recv, "error id=0 msg=ok", "")
			Return $recv
		ElseIf StringInStr($recv, "error") Then
			Return SetError(1, 0, _TS3errors($recv))
			ExitLoop
		EndIf
	WEnd
EndFunc   ;==>_TS3permidgetbyname


; #FUNCTION# ;===============================================================================
;
; Name...........: _TS3permoverview
; Description ...: Displays all permissions assigned to a client for the channel specified with cid.
; AutoIt Version : V3.3.6.0
; Syntax.........: _TS3permoverview($TS3channelid, $TS3clientdbid, $TS3permname)
; Parameters ....: $TS3channelid - Channelid
;				   $TS3clientdbid - Client dbid
;				   $TS3permname - Permission name
; Return values .: Success - Returns : Permission assigned to client
;                  Failure - Returns 0 and Sets @Error:
;                  |0 - No error.
;                  |1 - Error: Set return - Error message
; Author ........: chip
;
; ;==========================================================================================
Func _TS3permoverview($TS3channelid, $TS3clientdbid, $TS3permname)
	TCPSend($TS3connection, "permoverview cid=" & $TS3channelid & " cldbid=" & $TS3clientdbid & " permsid=" & $TS3permname & Chr(10))
	While 1
		$recv = TCPRecv($TS3connection, 2048)
		$recv = StringReplace($recv, @LF, @CRLF)
		$recv = StringReplace($recv, @CRLF & @CR, @CRLF)
		If StringInStr($recv, "t=") Then
			$recv = StringReplace($recv, "error id=0 msg=ok", "")
			Return $recv
		ElseIf StringInStr($recv, "error") Then
			Return SetError(1, 0, _TS3errors($recv))
			ExitLoop
		EndIf
	WEnd
EndFunc   ;==>_TS3permoverview


; #FUNCTION# ;===============================================================================
;
; Name...........: _TS3permfind
; Description ...: Displays detailed information about all assignments of the permission specified with permsid.
; AutoIt Version : V3.3.6.0
; Syntax.........: _TS3permfind($TS3permname)
; Parameters ....: $TS3permid - Permission id
; Return values .: Success - Returns : Permission
;                  Failure - Returns 0 and Sets @Error:
;                  |0 - No error.
;                  |1 - Error: Set return - Error message
; Author ........: chip
;
; ;==========================================================================================
Func _TS3permfind($TS3permid)
	TCPSend($TS3connection, "permoverview permid=" & $TS3permid & Chr(10))
	While 1
		$recv = TCPRecv($TS3connection, 2048)
		$recv = StringReplace($recv, @LF, @CRLF)
		$recv = StringReplace($recv, @CRLF & @CR, @CRLF)
		If StringInStr($recv, "t=") Then
			$recv = StringReplace($recv, "error id=0 msg=ok", "")
			Return $recv
		ElseIf StringInStr($recv, "error") Then
			Return SetError(1, 0, _TS3errors($recv))
			ExitLoop
		EndIf
	WEnd
EndFunc   ;==>_TS3permfind


; #FUNCTION# ;===============================================================================
;
; Name...........: _TS3permreset
; Description ...: Restores the default permission settings on the selected virtual server and creates a new initial administrator token.
; AutoIt Version : V3.3.6.0
; Syntax.........: _TS3permreset()
; Parameters ....:
; Return values .: Success - Returns : 1
;                  Failure - Returns 0 and Sets @Error:
;                  |0 - No error.
;                  |1 - Error: Set return - Error message
; Author ........: chip
;
; ;==========================================================================================
Func _TS3permreset()
	TCPSend($TS3connection, "permreset" & Chr(10))
	While 1
		$recv = TCPRecv($TS3connection, 2048)
		$recv = StringReplace($recv, @LF, @CRLF)
		$recv = StringReplace($recv, @CRLF & @CR, @CRLF)
		If StringInStr($recv, "error") Then
			$id = _StringBetween($recv, "id=", " msg")
			Switch $id[0]
				Case "0"
					Return 1
				Case Else
					Return SetError(1, 0, _TS3errors($recv))
			EndSwitch
		EndIf
	WEnd
EndFunc   ;==>_TS3permreset


; #FUNCTION# ;===============================================================================
;
; Name...........: _TS3tokenlist
; Description ...: Displays a list of tokens available including their type and group IDs.
; AutoIt Version : V3.3.6.0
; Syntax.........: _TS3tokenlist()
; Parameters ....:
; Return values .: Success - Returns : Tokenlist
;                  Failure - Returns 0 and Sets @Error:
;                  |0 - No error.
;                  |1 - Error: Set return - Error message
; Author ........: chip
;
; ;==========================================================================================
Func _TS3tokenlist()
	TCPSend($TS3connection, "tokenlist" & Chr(10))
	While 1
		$recv = TCPRecv($TS3connection, 2048)
		$recv = StringReplace($recv, @LF, @CRLF)
		$recv = StringReplace($recv, @CRLF & @CR, @CRLF)
		If StringInStr($recv, "token=") Then
			$recv = StringReplace($recv, "error id=0 msg=ok", "")
			Return $recv
		ElseIf StringInStr($recv, "error") Then
			Return SetError(1, 0, _TS3errors($recv))
			ExitLoop
		EndIf
	WEnd
EndFunc   ;==>_TS3tokenlist


; #FUNCTION# ;===============================================================================
;
; Name...........: _TS3tokenadd
; Description ...: Create a new token. If tokentype is set to 0, the ID specified with tokenid1 will be a server group ID. Otherwise, tokenid1 is used as a channel group ID and you need to provide a valid channel ID using tokenid2.
; AutoIt Version : V3.3.6.0
; Syntax.........: _TS3tokenadd($TS3tokentype, $TS3groupid, $TS3channelid[, $TS3tokendescription = ""[, $TS3tokencustumset = ""]])
; Parameters ....: $TS3tokentype - The Type of the Token
; 			       $TS3groupid - Group id
; 				   $TS3channelid - Channel id
; 				   $TS3tokendescription - Optional: (Default = "") : Description
; 				   $TS3tokencustumset - Optional: (Default = "") : Custom properties
; Return values .: Success - Returns : Tokenkey
;                  Failure - Returns 0 and Sets @Error:
;                  |0 - No error.
;                  |1 - Error: Set return - Error message
; Author ........: chip
;
; ;==========================================================================================
Func _TS3tokenadd($TS3tokentype, $TS3groupid, $TS3channelid, $TS3tokendescription = "", $TS3tokencustumset = "")
	TCPSend($TS3connection, "tokenadd tokentyp=" & $TS3tokentype & " tokenid1=" & $TS3groupid & " tokenid2=" & $TS3channelid & " tokendescription=" & $TS3tokendescription & " tokencustomset=" & $TS3tokencustumset & Chr(10))
	While 1
		$recv = TCPRecv($TS3connection, 2048)
		$recv = StringReplace($recv, @LF, @CRLF)
		$recv = StringReplace($recv, @CRLF & @CR, @CRLF)
		If StringInStr($recv, "token=") Then
			$recv = StringReplace($recv, "error id=0 msg=ok", "")
			Return $recv
		ElseIf StringInStr($recv, "error") Then
			Return SetError(1, 0, _TS3errors($recv))
			ExitLoop
		EndIf
	WEnd
EndFunc   ;==>_TS3tokenadd


; #FUNCTION# ;===============================================================================
;
; Name...........: _TS3tokendelete
; Description ...: Deletes an existing token matching the token key specified with token.
; AutoIt Version : V3.3.6.0
; Syntax.........: _TS3tokendelete($TS3tokenkey)
; Parameters ....: $TS3tokenkey - TokenKey
; Return values .: Success - Returns : 1
;                  Failure - Returns 0 and Sets @Error:
;                  |0 - No error.
;                  |1 - Error: Set return - Error message
; Author ........: chip
;
; ;==========================================================================================
Func _TS3tokendelete($TS3tokenkey)
	TCPSend($TS3connection, "tokendelete token=" & $TS3tokenkey & Chr(10))
	While 1
		$recv = TCPRecv($TS3connection, 2048)
		$recv = StringReplace($recv, @LF, @CRLF)
		$recv = StringReplace($recv, @CRLF & @CR, @CRLF)
		If StringInStr($recv, "error") Then
			$id = _StringBetween($recv, "id=", " msg")
			Switch $id[0]
				Case "0"
					Return 1
				Case Else
					Return SetError(1, 0, _TS3errors($recv))
			EndSwitch
		EndIf
	WEnd
EndFunc   ;==>_TS3tokendelete


; #FUNCTION# ;===============================================================================
;
; Name...........: _TS3tokenuse
; Description ...: Use a token key gain access to a server or channel group. Please note that the server will automatically delete the token after it has been used.
; AutoIt Version : V3.3.6.0
; Syntax.........: _TS3tokenuse($TS3tokenkey)
; Parameters ....: $TS3tokenkey - TokenKey
; Return values .: Success - Returns : 1
;                  Failure - Returns 0 and Sets @Error:
;                  |0 - No error.
;                  |1 - Error: Set return - Error message
; Author ........: chip
;
; ;==========================================================================================
Func _TS3tokenuse($TS3tokenkey)
	TCPSend($TS3connection, "tokenuse token=" & $TS3tokenkey & Chr(10))
	While 1
		$recv = TCPRecv($TS3connection, 2048)
		$recv = StringReplace($recv, @LF, @CRLF)
		$recv = StringReplace($recv, @CRLF & @CR, @CRLF)
		If StringInStr($recv, "error") Then
			$id = _StringBetween($recv, "id=", " msg")
			Switch $id[0]
				Case "0"
					Return 1
				Case Else
					Return SetError(1, 0, _TS3errors($recv))
			EndSwitch
		EndIf
	WEnd
EndFunc   ;==>_TS3tokenuse


; #FUNCTION# ;===============================================================================
;
; Name...........: _TS3messagelist
; Description ...: Displays a list of offline messages you've received. The output contains the senders unique identifier, the messages subject, etc.
; AutoIt Version : V3.3.6.0
; Syntax.........: _TS3messagelist()
; Parameters ....:
; Return values .: Success - Returns : Messages
;                  Failure - Returns 0 and Sets @Error:
;                  |0 - No error.
;                  |1 - Error: Set return - Error message
; Author ........: chip
;
; ;==========================================================================================
Func _TS3messagelist()
	TCPSend($TS3connection, "messagelist" & Chr(10))
	While 1
		$recv = TCPRecv($TS3connection, 2048)
		$recv = StringReplace($recv, @LF, @CRLF)
		$recv = StringReplace($recv, @CRLF & @CR, @CRLF)
		If StringInStr($recv, "msgid=") Then
			$recv = StringReplace($recv, "error id=0 msg=ok", "")
			Return $recv
		ElseIf StringInStr($recv, "error") Then
			Return SetError(1, 0, _TS3errors($recv))
			ExitLoop
		EndIf
	WEnd
EndFunc   ;==>_TS3messagelist


; #FUNCTION# ;===============================================================================
;
; Name...........: _TS3messageadd
; Description ...: Sends an offline message to the client specified by cluid.
; AutoIt Version : V3.3.6.0
; Syntax.........: _TS3messageadd($TS3clientuid, $TS3subject, $TS3text)
; Parameters ....: $TS3clientuid - Client UID
; 				   $TS3subject - Subject
; 				   $TS3text - Text
; Return values .: Success - Returns : 1
;                  Failure - Returns 0 and Sets @Error:
;                  |0 - No error.
;                  |1 - Error: Set return - Error message
; Author ........: chip
;
; ;==========================================================================================
Func _TS3messageadd($TS3clientuid, $TS3subject, $TS3text)
	$TS3subject = StringReplace($TS3subject, " ", "\s")
	$TS3text = StringReplace($TS3text, " ", "\s")
	TCPSend($TS3connection, "messageadd cluid=" & $TS3clientuid & " subject=" & $TS3subject & " message=" & $TS3text & Chr(10))
	While 1
		$recv = TCPRecv($TS3connection, 2048)
		$recv = StringReplace($recv, @LF, @CRLF)
		$recv = StringReplace($recv, @CRLF & @CR, @CRLF)
		If StringInStr($recv, "error") Then
			$id = _StringBetween($recv, "id=", " msg")
			Switch $id[0]
				Case "0"
					Return 1
				Case Else
					Return SetError(1, 0, _TS3errors($recv))
			EndSwitch
		EndIf
	WEnd
EndFunc   ;==>_TS3messageadd


; #FUNCTION# ;===============================================================================
;
; Name...........: _TS3messageget
; Description ...: Displays an existing offline message with ID msgid from your inbox. Please note that this does not automatically set the flag_read property of the message.
; AutoIt Version : V3.3.6.0
; Syntax.........: _TS3messageget($TS3messageid)
; Parameters ....: $TS3messageid - Message id
; Return values .: Success - Returns : Messages
;                  Failure - Returns 0 and Sets @Error:
;                  |0 - No error.
;                  |1 - Error: Set return - Error message
; Author ........: chip
;
; ;==========================================================================================
Func _TS3messageget($TS3messageid)
	TCPSend($TS3connection, "messageget msgid=" & $TS3messageid & Chr(10))
	While 1
		$recv = TCPRecv($TS3connection, 2048)
		$recv = StringReplace($recv, @LF, @CRLF)
		$recv = StringReplace($recv, @CRLF & @CR, @CRLF)
		If StringInStr($recv, "msgid=") Then
			$recv = StringReplace($recv, "error id=0 msg=ok", "")
			Return $recv
		ElseIf StringInStr($recv, "error") Then
			Return SetError(1, 0, _TS3errors($recv))
			ExitLoop
		EndIf
	WEnd
EndFunc   ;==>_TS3messageget


; #FUNCTION# ;===============================================================================
;
; Name...........: _TS3messageupdateflag
; Description ...: Updates the flag_read property of the offline message specified with msgid. If flag is set to 1, the message will be marked as read.
; AutoIt Version : V3.3.6.0
; Syntax.........: _TS3messageupdateflag($TS3messageid, $TS3flag)
; Parameters ....: $TS3messageid - Message id
; 				   $TS3flag - Flag
; Return values .: Success - Returns : 1
;                  Failure - Returns 0 and Sets @Error:
;                  |0 - No error.
;                  |1 - Error: Set return - Error message
; Author ........: chip
;
; ;==========================================================================================
Func _TS3messageupdateflag($TS3messageid, $TS3flag)
	TCPSend($TS3connection, "messageupdateflag msgid=" & $TS3messageid & " flag=" & $TS3flag & Chr(10))
	While 1
		$recv = TCPRecv($TS3connection, 2048)
		$recv = StringReplace($recv, @LF, @CRLF)
		$recv = StringReplace($recv, @CRLF & @CR, @CRLF)
		If StringInStr($recv, "error") Then
			$id = _StringBetween($recv, "id=", " msg")
			Switch $id[0]
				Case "0"
					Return 1
				Case Else
					Return SetError(1, 0, _TS3errors($recv))
			EndSwitch
		EndIf
	WEnd
EndFunc   ;==>_TS3messageupdateflag


; #FUNCTION# ;===============================================================================
;
; Name...........: _TS3messagedel
; Description ...: Deletes an existing offline message with ID msgid from your inbox.
; AutoIt Version : V3.3.6.0
; Syntax.........: _TS3messagedel($TS3messageid)
; Parameters ....: $TS3messageid - Message id
; Return values .: Success - Returns : 1
;                  Failure - Returns 0 and Sets @Error:
;                  |0 - No error.
;                  |1 - Error: Set return - Error message
; Author ........: chip
;
; ;==========================================================================================
Func _TS3messagedel($TS3messageid)
	TCPSend($TS3connection, "messagedel msgid=" & $TS3messageid & Chr(10))
	While 1
		$recv = TCPRecv($TS3connection, 2048)
		$recv = StringReplace($recv, @LF, @CRLF)
		$recv = StringReplace($recv, @CRLF & @CR, @CRLF)
		If StringInStr($recv, "error") Then
			$id = _StringBetween($recv, "id=", " msg")
			Switch $id[0]
				Case "0"
					Return 1
				Case Else
					Return SetError(1, 0, _TS3errors($recv))
			EndSwitch
		EndIf
	WEnd
EndFunc   ;==>_TS3messagedel


; #FUNCTION# ;===============================================================================
;
; Name...........: _TS3complainlist
; Description ...: Displays a list of complaints on the selected virtual server. If $TS3clientdbid is specified, only complaints about the targeted client will be shown.
; AutoIt Version : V3.3.6.0
; Syntax.........: _TS3complainlist([$TS3clientdbid = ""])
; Parameters ....: $TS3clientdbid - Client dbid
; Return values .: Success - Returns : Messages
;                  Failure - Returns 0 and Sets @Error:
;                  |0 - No error.
;                  |1 - Error: Set return - Error message
; Author ........: chip
;
; ;==========================================================================================
Func _TS3complainlist($TS3clientdbid = "")
	If $TS3clientdbid <> "" Then
		$TS3clientdbid = " tcldbid=" & $TS3clientdbid
	EndIf
	TCPSend($TS3connection, "complainlist" & $TS3clientdbid & Chr(10))
	While 1
		$recv = TCPRecv($TS3connection, 2048)
		$recv = StringReplace($recv, @LF, @CRLF)
		$recv = StringReplace($recv, @CRLF & @CR, @CRLF)
		If StringInStr($recv, "tcldbid=") Then
			$recv = StringReplace($recv, "error id=0 msg=ok", "")
			Return $recv
		ElseIf StringInStr($recv, "error") Then
			Return SetError(1, 0, _TS3errors($recv))
			ExitLoop
		EndIf
	WEnd
EndFunc   ;==>_TS3complainlist


; #FUNCTION# ;===============================================================================
;
; Name...........: _TS3complainadd
; Description ...: Submits a complaint about the client with database ID tcldbid to the server.
; AutoIt Version : V3.3.6.0
; Syntax.........: _TS3complainadd($TS3clientdbid, $TS3test)
; Parameters ....: $TS3clientdbid - Client dbid
;				   $TS3test - Text
; Return values .: Success - Returns : 1
;                  Failure - Returns 0 and Sets @Error:
;                  |0 - No error.
;                  |1 - Error: Set return - Error message
; Author ........: chip
;
; ;==========================================================================================
Func _TS3complainadd($TS3clientdbid, $TS3test)
	TCPSend($TS3connection, "complainadd tcldbid=" & $TS3clientdbid & " message=" & $TS3test & Chr(10))
	While 1
		$recv = TCPRecv($TS3connection, 2048)
		$recv = StringReplace($recv, @LF, @CRLF)
		$recv = StringReplace($recv, @CRLF & @CR, @CRLF)
		If StringInStr($recv, "error") Then
			$id = _StringBetween($recv, "id=", " msg")
			Switch $id[0]
				Case "0"
					Return 1
				Case Else
					Return SetError(1, 0, _TS3errors($recv))
			EndSwitch
		EndIf
	WEnd
EndFunc   ;==>_TS3complainadd


; #FUNCTION# ;===============================================================================
;
; Name...........: _TS3complaindel
; Description ...: Deletes the complaint about the client with ID tcldbid submitted by the client with ID fcldbid from the server.
; AutoIt Version : V3.3.6.0
; Syntax.........: _TS3complaindel($TS3clientdbid, $TS3fromdbid)
; Parameters ....: $TS3clientdbid - Client dbid
;				   $TS3fromdbid - From client dbid
; Return values .: Success - Returns : 1
;                  Failure - Returns 0 and Sets @Error:
;                  |0 - No error.
;                  |1 - Error: Set return - Error message
; Author ........: chip
;
; ;==========================================================================================
Func _TS3complaindel($TS3clientdbid, $TS3fromdbid)
	TCPSend($TS3connection, "complainadd tcldbid=" & $TS3clientdbid & " fcldbid=" & $TS3fromdbid & Chr(10))
	While 1
		$recv = TCPRecv($TS3connection, 2048)
		$recv = StringReplace($recv, @LF, @CRLF)
		$recv = StringReplace($recv, @CRLF & @CR, @CRLF)
		If StringInStr($recv, "error") Then
			$id = _StringBetween($recv, "id=", " msg")
			Switch $id[0]
				Case "0"
					Return 1
				Case Else
					Return SetError(1, 0, _TS3errors($recv))
			EndSwitch
		EndIf
	WEnd
EndFunc   ;==>_TS3complaindel


; #FUNCTION# ;===============================================================================
;
; Name...........: _TS3complaindelall
; Description ...: Deletes all complaints about the client with database ID tcldbid from the server.
; AutoIt Version : V3.3.6.0
; Syntax.........: _TS3complaindelall($TS3clientdbid)
; Parameters ....: $TS3clientdbid - Client dbid
; Return values .: Success - Returns : 1
;                  Failure - Returns 0 and Sets @Error:
;                  |0 - No error.
;                  |1 - Error: Set return - Error message
; Author ........: chip
;
; ;==========================================================================================
Func _TS3complaindelall($TS3clientdbid)
	TCPSend($TS3connection, "complaindelall tcldbid=" & $TS3clientdbid & Chr(10))
	While 1
		$recv = TCPRecv($TS3connection, 2048)
		$recv = StringReplace($recv, @LF, @CRLF)
		$recv = StringReplace($recv, @CRLF & @CR, @CRLF)
		If StringInStr($recv, "error") Then
			$id = _StringBetween($recv, "id=", " msg")
			Switch $id[0]
				Case "0"
					Return 1
				Case Else
					Return SetError(1, 0, _TS3errors($recv))
			EndSwitch
		EndIf
	WEnd
EndFunc   ;==>_TS3complaindelall


; #FUNCTION# ;===============================================================================
;
; Name...........: _TS3banclient
; Description ...: Bans the client specified with ID clid from the server.
; AutoIt Version : V3.3.6.0
; Syntax.........: _TS3banclient($TS3clientid[, $TS3time = ""[, $TS3reason = ""]])
; Parameters ....: $TS3clientid - Client id
;				   $TS3time - Optional: (Default = "") : Banntime in seconds
;				   $TS3reason - Optional: (Default = "") : Bannreason
; Return values .: Success - Returns : Bann id
;                  Failure - Returns 0 and Sets @Error:
;                  |0 - No error.
;                  |1 - Error: Set return - Error message
; Author ........: chip
;
; ;==========================================================================================
Func _TS3banclient($TS3clientid, $TS3time = "", $TS3reason = "")
	If $TS3time <> "" Then
		$TS3clientid = $TS3clientid & " time=" & $TS3time
	EndIf
	If $TS3reason <> "" Then
		$TS3clientid = $TS3clientid & " banreason=" & $TS3reason
	EndIf
	TCPSend($TS3connection, "banclient clid=" & $TS3clientid & Chr(10))
	While 1
		$recv = TCPRecv($TS3connection, 2048)
		$recv = StringReplace($recv, @LF, @CRLF)
		$recv = StringReplace($recv, @CRLF & @CR, @CRLF)
		If StringInStr($recv, "banid=") Then
			$recv = StringReplace($recv, "error id=0 msg=ok", "")
			Return $recv
		ElseIf StringInStr($recv, "error") Then
			Return SetError(1, 0, _TS3errors($recv))
			ExitLoop
		EndIf
	WEnd
EndFunc   ;==>_TS3banclient


; #FUNCTION# ;===============================================================================
;
; Name...........: _TS3banlist
; Description ...: Displays a list of active bans on the selected virtual server.
; AutoIt Version : V3.3.6.0
; Syntax.........: _TS3banlist()
; Parameters ....:
; Return values .: Success - Returns : Banlist
;                  Failure - Returns 0 and Sets @Error:
;                  |0 - No error.
;                  |1 - Error: Set return - Error message
; Author ........: chip
;
; ;==========================================================================================
Func _TS3banlist()
	TCPSend($TS3connection, "banlist" & Chr(10))
	While 1
		$recv = TCPRecv($TS3connection, 2048)
		$recv = StringReplace($recv, @LF, @CRLF)
		$recv = StringReplace($recv, @CRLF & @CR, @CRLF)
		If StringInStr($recv, "banid=") Then
			$recv = StringReplace($recv, "error id=0 msg=ok", "")
			Return $recv
		ElseIf StringInStr($recv, "error") Then
			Return SetError(1, 0, _TS3errors($recv))
			ExitLoop
		EndIf
	WEnd
EndFunc   ;==>_TS3banlist


; #FUNCTION# ;===============================================================================
;
; Name...........: _TS3banadd
; Description ...: Adds a new ban rule on the selected virtual server. All parameters are optional but at least one of the following must be set: ip, name, or uid.
; AutoIt Version : V3.3.6.0
; Syntax.........: _TS3banadd([$TS3ip = ""[, $TS3name = ""[, $TS3clientuid = ""[, $TS3time = ""[, $TS3reason = ""]]]]])
; Parameters ....: $TS3ip - Optional: (Default = "") : Client IP
;				   $TS3name - Optional: (Default = "") : Client name
;				   $TS3clientuid - Optional: (Default = "") : Client UID
;				   $TS3time - Optional: (Default = "") : Banntime in seconds
;				   $TS3reason - Optional: (Default = "") : Bannreason
; Return values .: Success - Returns : Bann id
;                  Failure - Returns 0 and Sets @Error:
;                  |0 - No error.
;                  |1 - Error: Set return - Error message
; Author ........: chip
;
; ;==========================================================================================
Func _TS3banadd($TS3ip = "", $TS3name = "", $TS3clientuid = "", $TS3time = "", $TS3reason = "")
	$TS3wert = ""
	If $TS3ip <> "" Then
		$TS3wert = $TS3wert & " ip=" & $TS3ip
	EndIf
	If $TS3name <> "" Then
		$TS3wert = $TS3wert & " name=" & $TS3name
	EndIf
	If $TS3clientuid <> "" Then
		$TS3wert = $TS3wert & " uid=" & $TS3clientuid
	EndIf
	If $TS3time <> "" Then
		$TS3wert = $TS3wert & " time=" & $TS3time
	EndIf
	If $TS3reason <> "" Then
		$TS3wert = $TS3wert & " banreason=" & $TS3reason
	EndIf
	TCPSend($TS3connection, "banadd" & $TS3wert & Chr(10))
	While 1
		$recv = TCPRecv($TS3connection, 2048)
		$recv = StringReplace($recv, @LF, @CRLF)
		$recv = StringReplace($recv, @CRLF & @CR, @CRLF)
		If StringInStr($recv, "banid=") Then
			$recv = StringReplace($recv, "error id=0 msg=ok", "")
			Return $recv
		ElseIf StringInStr($recv, "error") Then
			Return SetError(1, 0, _TS3errors($recv))
			ExitLoop
		EndIf
	WEnd
EndFunc   ;==>_TS3banadd


; #FUNCTION# ;===============================================================================
;
; Name...........: _TS3bandel
; Description ...: Deletes the ban rule with ID banid from the server.
; AutoIt Version : V3.3.6.0
; Syntax.........: _TS3bandel($TS3banid)
; Parameters ....: $TS3banid - Ban id
; Return values .: Success - Returns : 1
;                  Failure - Returns 0 and Sets @Error:
;                  |0 - No error.
;                  |1 - Error: Set return - Error message
; Author ........: chip
;
; ;==========================================================================================
Func _TS3bandel($TS3banid)
	TCPSend($TS3connection, "bandel banid=" & $TS3banid & Chr(10))
	While 1
		$recv = TCPRecv($TS3connection, 2048)
		$recv = StringReplace($recv, @LF, @CRLF)
		$recv = StringReplace($recv, @CRLF & @CR, @CRLF)
		If StringInStr($recv, "error") Then
			$id = _StringBetween($recv, "id=", " msg")
			Switch $id[0]
				Case "0"
					Return 1
				Case Else
					Return SetError(1, 0, _TS3errors($recv))
			EndSwitch
		EndIf
	WEnd
EndFunc   ;==>_TS3bandel


; #FUNCTION# ;===============================================================================
;
; Name...........: _TS3bandelall
; Description ...: Deletes all active ban rules from the server.
; AutoIt Version : V3.3.6.0
; Syntax.........: _TS3bandelall()
; Parameters ....:
; Return values .: Success - Returns : 1
;                  Failure - Returns 0 and Sets @Error:
;                  |0 - No error.
;                  |1 - Error: Set return - Error message
; Author ........: chip
;
; ;==========================================================================================
Func _TS3bandelall()
	TCPSend($TS3connection, "bandelall" & Chr(10))
	While 1
		$recv = TCPRecv($TS3connection, 2048)
		$recv = StringReplace($recv, @LF, @CRLF)
		$recv = StringReplace($recv, @CRLF & @CR, @CRLF)
		If StringInStr($recv, "error") Then
			$id = _StringBetween($recv, "id=", " msg")
			Switch $id[0]
				Case "0"
					Return 1
				Case Else
					Return SetError(1, 0, _TS3errors($recv))
			EndSwitch
		EndIf
	WEnd
EndFunc   ;==>_TS3bandelall


; #FUNCTION# ;===============================================================================
;
; Name...........: _TS3ftinitupload
; Description ...: Initializes a file transfer upload. clientftfid is an arbitrary ID to identify the file transfer on client-side.
; AutoIt Version : V3.3.6.0
; Syntax.........: _TS3ftinitupload($TS3clientftfid, $TS3path, $TS3channelid, $TS3channelpw, $TS3filesize, $TS3overwrite, $TS3resume)
; Parameters ....: $TS3clientftfid - Client file transfer id
;			       $TS3path - File path
;			       $TS3channelid - Channel Id
;			       $TS3channelpw -Channel password
;			       $TS3filesize - File size
;			       $TS3overwrite - File overwrite
;			       $TS3resume - resume
; Return values .: Success - Returns : File info
;                  Failure - Returns 0 and Sets @Error:
;                  |0 - No error.
;                  |1 - Error: Set return - Error message
; Author ........: chip
;
; ;==========================================================================================
Func _TS3ftinitupload($TS3clientftfid, $TS3path, $TS3channelid, $TS3channelpw, $TS3filesize, $TS3overwrite, $TS3resume)
	TCPSend($TS3connection, "ftinitupload clientftfid=" & $TS3clientftfid & " name=" & $TS3path & " cid=" & $TS3channelid & " cpw=" & $TS3channelpw & " size=" & $TS3filesize & " overwrite=" & $TS3overwrite & " resume=" & $TS3resume & Chr(10))
	While 1
		$recv = TCPRecv($TS3connection, 2048)
		$recv = StringReplace($recv, @LF, @CRLF)
		$recv = StringReplace($recv, @CRLF & @CR, @CRLF)
		If StringInStr($recv, "clientftfid=") Then
			$recv = StringReplace($recv, "error id=0 msg=ok", "")
			Return $recv
		ElseIf StringInStr($recv, "error") Then
			Return SetError(1, 0, _TS3errors($recv))
			ExitLoop
		EndIf
	WEnd
EndFunc   ;==>_TS3ftinitupload


; #FUNCTION# ;===============================================================================
;
; Name...........: _TS3ftinitdownload
; Description ...: Initializes a file transfer download.
; AutoIt Version : V3.3.6.0
; Syntax.........: _TS3ftinitdownload($TS3clientftfid, $TS3path, $TS3channelid, $TS3channelpw, $TS3seek)
; Parameters ....: $TS3clientftfid - Client file transfer id
;			       $TS3path - File path
;			       $TS3channelid - Channel Id
;			       $TS3channelpw -Channel password
;			       $TS3seek - Seek position
; Return values .: Success - Returns : File info
;                  Failure - Returns 0 and Sets @Error:
;                  |0 - No error.
;                  |1 - Error: Set return - Error message
; Author ........: chip
;
; ;==========================================================================================
Func _TS3ftinitdownload($TS3clientftfid, $TS3path, $TS3channelid, $TS3channelpw, $TS3seek)
	TCPSend($TS3connection, "ftinitdownload clientftfid=" & $TS3clientftfid & " name=" & $TS3path & " cid=" & $TS3channelid & " cpw=" & $TS3channelpw & " seekpos=" & $TS3seek & Chr(10))
	While 1
		$recv = TCPRecv($TS3connection, 2048)
		$recv = StringReplace($recv, @LF, @CRLF)
		$recv = StringReplace($recv, @CRLF & @CR, @CRLF)
		If StringInStr($recv, "clientftfid=") Then
			$recv = StringReplace($recv, "error id=0 msg=ok", "")
			Return $recv
		ElseIf StringInStr($recv, "error") Then
			Return SetError(1, 0, _TS3errors($recv))
			ExitLoop
		EndIf
	WEnd
EndFunc   ;==>_TS3ftinitdownload


; #FUNCTION# ;===============================================================================
;
; Name...........: _TS3ftlist
; Description ...: Displays a list of running file transfers on the selected virtual server.
; AutoIt Version : V3.3.6.0
; Syntax.........: _TS3ftlist()
; Parameters ....:
; Return values .: Success - Returns : File list
;                  Failure - Returns 0 and Sets @Error:
;                  |0 - No error.
;                  |1 - Error: Set return - Error message
; Author ........: chip
;
; ;==========================================================================================
Func _TS3ftlist()
	TCPSend($TS3connection, "ftlist" & Chr(10))
	While 1
		$recv = TCPRecv($TS3connection, 2048)
		$recv = StringReplace($recv, @LF, @CRLF)
		$recv = StringReplace($recv, @CRLF & @CR, @CRLF)
		If StringInStr($recv, "clid=") Then
			$recv = StringReplace($recv, "error id=0 msg=ok", "")
			Return $recv
		ElseIf StringInStr($recv, "error") Then
			Return SetError(1, 0, _TS3errors($recv))
			ExitLoop
		EndIf
	WEnd
EndFunc   ;==>_TS3ftlist


; #FUNCTION# ;===============================================================================
;
; Name...........: _TS3ftgetfilelist
; Description ...: Displays a list of files and directories stored in the specified channels file repository.
; AutoIt Version : V3.3.6.0
; Syntax.........: _TS3ftgetfilelist($TS3channelid, $TS3channelpw, $TS3path)
; Parameters ....: $TS3channelid - Channel id
;				   $TS3channelpw - Channel password
;				   $TS3path - File path
; Return values .: Success - Returns : File list
;                  Failure - Returns 0 and Sets @Error:
;                  |0 - No error.
;                  |1 - Error: Set return - Error message
; Author ........: chip
;
; ;==========================================================================================
Func _TS3ftgetfilelist($TS3channelid, $TS3channelpw, $TS3path)
	TCPSend($TS3connection, "ftgetfilelist cid=" & $TS3channelid & " cpw=" & $TS3channelpw & " path=" & $TS3path & Chr(10))
	While 1
		$recv = TCPRecv($TS3connection, 2048)
		$recv = StringReplace($recv, @LF, @CRLF)
		$recv = StringReplace($recv, @CRLF & @CR, @CRLF)
		If StringInStr($recv, "cid=") Then
			$recv = StringReplace($recv, "error id=0 msg=ok", "")
			Return $recv
		ElseIf StringInStr($recv, "error") Then
			Return SetError(1, 0, _TS3errors($recv))
			ExitLoop
		EndIf
	WEnd
EndFunc   ;==>_TS3ftgetfilelist


; #FUNCTION# ;===============================================================================
;
; Name...........: _TS3ftgetfileinfo
; Description ...: Displays detailed information about one specified file stored in a channels file repository.
; AutoIt Version : V3.3.6.0
; Syntax.........: _TS3ftgetfileinfo($TS3channelid, $TS3channelpw, $TS3path)
; Parameters ....: $TS3channelid - Channel id
;				   $TS3channelpw - Channel password
;				   $TS3path - File path and Filename
; Return values .: Success - Returns : File info
;                  Failure - Returns 0 and Sets @Error:
;                  |0 - No error.
;                  |1 - Error: Set return - Error message
; Author ........: chip
;
; ;==========================================================================================
Func _TS3ftgetfileinfo($TS3channelid, $TS3channelpw, $TS3path)
	TCPSend($TS3connection, "ftgetfileinfo cid=" & $TS3channelid & " cpw=" & $TS3channelpw & " path=" & $TS3path & Chr(10))
	While 1
		$recv = TCPRecv($TS3connection, 2048)
		$recv = StringReplace($recv, @LF, @CRLF)
		$recv = StringReplace($recv, @CRLF & @CR, @CRLF)
		If StringInStr($recv, "cid=") Then
			$recv = StringReplace($recv, "error id=0 msg=ok", "")
			Return $recv
		ElseIf StringInStr($recv, "error") Then
			Return SetError(1, 0, _TS3errors($recv))
			ExitLoop
		EndIf
	WEnd
EndFunc   ;==>_TS3ftgetfileinfo


; #FUNCTION# ;===============================================================================
;
; Name...........: _TS3ftstop
; Description ...: Deletes all active ban rules from the server.
; AutoIt Version : V3.3.6.0
; Syntax.........: _TS3ftstop($TS3serverftfid, $TS3delete)
; Parameters ....: $TS3serverftfid - Server file transfer id
;				   $TS3delete - Delete file
; Return values .: Success - Returns : 1
;                  Failure - Returns 0 and Sets @Error:
;                  |0 - No error.
;                  |1 - Error: Set return - Error message
; Author ........: chip
;
; ;==========================================================================================
Func _TS3ftstop($TS3serverftfid, $TS3delete)
	TCPSend($TS3connection, "ftstop serverftfid=" & $TS3serverftfid & " delete=" & $TS3delete & Chr(10))
	While 1
		$recv = TCPRecv($TS3connection, 2048)
		$recv = StringReplace($recv, @LF, @CRLF)
		$recv = StringReplace($recv, @CRLF & @CR, @CRLF)
		If StringInStr($recv, "error") Then
			$id = _StringBetween($recv, "id=", " msg")
			Switch $id[0]
				Case "0"
					Return 1
				Case Else
					Return SetError(1, 0, _TS3errors($recv))
			EndSwitch
		EndIf
	WEnd
EndFunc   ;==>_TS3ftstop


; #FUNCTION# ;===============================================================================
;
; Name...........: _TS3ftdeletefile
; Description ...: Deletes one file stored in a channels file repository.
; AutoIt Version : V3.3.6.0
; Syntax.........: _TS3ftdeletefile($TS3channelid, $TS3channelpw, $TS3path)
; Parameters ....: $TS3channelid - Channel id
;				   $TS3channelpw - Channel password
;				   $TS3path - File path and Filename
; Return values .: Success - Returns : 1
;                  Failure - Returns 0 and Sets @Error:
;                  |0 - No error.
;                  |1 - Error: Set return - Error message
; Author ........: chip
;
; ;==========================================================================================
Func _TS3ftdeletefile($TS3channelid, $TS3channelpw, $TS3path)
	TCPSend($TS3connection, "ftdeletefile cid=" & $TS3channelid & " cpw=" & $TS3channelpw & " path=" & $TS3path & Chr(10))
	While 1
		$recv = TCPRecv($TS3connection, 2048)
		$recv = StringReplace($recv, @LF, @CRLF)
		$recv = StringReplace($recv, @CRLF & @CR, @CRLF)
		If StringInStr($recv, "error") Then
			$id = _StringBetween($recv, "id=", " msg")
			Switch $id[0]
				Case "0"
					Return 1
				Case Else
					Return SetError(1, 0, _TS3errors($recv))
			EndSwitch
		EndIf
	WEnd
EndFunc   ;==>_TS3ftdeletefile


; #FUNCTION# ;===============================================================================
;
; Name...........: _TS3ftcreatedir
; Description ...: Deletes one file stored in a channels file repository.
; AutoIt Version : V3.3.6.0
; Syntax.........: _TS3ftcreatedir($TS3channelid, $TS3channelpw, $TS3path)
; Parameters ....: $TS3channelid - Channel id
;				   $TS3channelpw - Channel password
;				   $TS3path - File path and Dirname
; Return values .: Success - Returns : 1
;                  Failure - Returns 0 and Sets @Error:
;                  |0 - No error.
;                  |1 - Error: Set return - Error message
; Author ........: chip
;
; ;==========================================================================================
Func _TS3ftcreatedir($TS3channelid, $TS3channelpw, $TS3path)
	TCPSend($TS3connection, "ftcreatedir cid=" & $TS3channelid & " cpw=" & $TS3channelpw & " dirpath=" & $TS3path & Chr(10))
	While 1
		$recv = TCPRecv($TS3connection, 2048)
		$recv = StringReplace($recv, @LF, @CRLF)
		$recv = StringReplace($recv, @CRLF & @CR, @CRLF)
		If StringInStr($recv, "error") Then
			$id = _StringBetween($recv, "id=", " msg")
			Switch $id[0]
				Case "0"
					Return 1
				Case Else
					Return SetError(1, 0, _TS3errors($recv))
			EndSwitch
		EndIf
	WEnd
EndFunc   ;==>_TS3ftcreatedir


; #FUNCTION# ;===============================================================================
;
; Name...........: _TS3ftrenamefile
; Description ...: Renames a file in a channels file repository. If the two parameters tcid and tcpw are specified, the file will be moved into another channels file repository.
; AutoIt Version : V3.3.6.0
; Syntax.........: _TS3ftrenamefile($TS3channelid, $TS3channelpw, $TS3oldname, $TS3newname[, $TS3targetchannelid = ""[, $TS3targetchannelpw = ""]])
; Parameters ....: $TS3channelid - Channel Id
; 				   $TS3channelpw - Channel password
; 				   $TS3oldname - Old filename
; 				   $TS3newname - New filename
;				   $TS3targetchannelid - Optional: (Default = "") : Target channel Id
;				   $TS3targetchannelpw - Optional: (Default = "") : Target channel password
; Return values .: Success - Returns : 1
;                  Failure - Returns 0 and Sets @Error:
;                  |0 - No error.
;                  |1 - Error: Set return - Error message
; Author ........: chip
;
; ;==========================================================================================
Func _TS3ftrenamefile($TS3channelid, $TS3channelpw, $TS3oldname, $TS3newname, $TS3targetchannelid = "", $TS3targetchannelpw = "")
	If $TS3targetchannelid <> "" Then
		$TS3newname = $TS3newname & " tcid=" & $TS3targetchannelid
	EndIf
	If $TS3targetchannelpw <> "" Then
		$TS3newname = $TS3newname & " tcpw=" & $TS3targetchannelid
	EndIf
	TCPSend($TS3connection, "ftrenamefile cid=" & $TS3channelid & " cpw=" & $TS3channelpw & " oldname=" & $TS3oldname & " newname=" & $TS3newname & Chr(10))
	While 1
		$recv = TCPRecv($TS3connection, 2048)
		$recv = StringReplace($recv, @LF, @CRLF)
		$recv = StringReplace($recv, @CRLF & @CR, @CRLF)
		If StringInStr($recv, "error") Then
			$id = _StringBetween($recv, "id=", " msg")
			Switch $id[0]
				Case "0"
					Return 1
				Case Else
					Return SetError(1, 0, _TS3errors($recv))
			EndSwitch
		EndIf
	WEnd
EndFunc   ;==>_TS3ftrenamefile


; #FUNCTION# ;===============================================================================
;
; Name...........: _TS3customsearch
; Description ...: Searches for custom client properties specified by ident and value. The value parameter can include regular characters and SQL wildcard characters (e.g. %).
; AutoIt Version : V3.3.6.0
; Syntax.........: _TS3customsearch($TS3ident, $TS3pattern)
; Parameters ....: $TS3ident - Ident
;				   $TS3pattern - Pattern
; Return values .: Success - Returns : Sreach result
;                  Failure - Returns 0 and Sets @Error:
;                  |0 - No error.
;                  |1 - Error: Set return - Error message
; Author ........: chip
;
; ;==========================================================================================
Func _TS3customsearch($TS3ident, $TS3pattern)
	TCPSend($TS3connection, "customsearch ident=" & $TS3ident & " pattern=" & $TS3pattern & Chr(10))
	While 1
		$recv = TCPRecv($TS3connection, 2048)
		$recv = StringReplace($recv, @LF, @CRLF)
		$recv = StringReplace($recv, @CRLF & @CR, @CRLF)
		If Not StringInStr($recv, "error") Then
			$recv = StringReplace($recv, "error id=0 msg=ok", "")
			Return $recv
		ElseIf StringInStr($recv, "error") Then
			Return SetError(1, 0, _TS3errors($recv))
			ExitLoop
		EndIf
	WEnd
EndFunc   ;==>_TS3customsearch


; #FUNCTION# ;===============================================================================
;
; Name...........: _TS3custominfo
; Description ...: Displays a list of custom properties for the client specified with cldbid.
; AutoIt Version : V3.3.6.0
; Syntax.........: _TS3custominfo($TS3clientdbid)
; Parameters ....: $TS3clientdbid - clientdbid
; Return values .: Success - Returns : Sreach result
;                  Failure - Returns 0 and Sets @Error:
;                  |0 - No error.
;                  |1 - Error: Set return - Error message
; Author ........: chip
;
; ;==========================================================================================
Func _TS3custominfo($TS3clientdbid)
	TCPSend($TS3connection, "custominfo cldbid=" & $TS3clientdbid & Chr(10))
	While 1
		$recv = TCPRecv($TS3connection, 2048)
		$recv = StringReplace($recv, @LF, @CRLF)
		$recv = StringReplace($recv, @CRLF & @CR, @CRLF)
		If StringInStr($recv, "cldbid=") Then
			$recv = StringReplace($recv, "error id=0 msg=ok", "")
			Return $recv
		ElseIf StringInStr($recv, "error") Then
			Return SetError(1, 0, _TS3errors($recv))
			ExitLoop
		EndIf
	WEnd
EndFunc   ;==>_TS3custominfo


; #FUNCTION# ;===============================================================================
;
; Name...........: _TS3whoami
; Description ...: Displays information about your current ServerQuery connection including the ID of the selected virtual server, your loginname, etc.
; AutoIt Version : V3.3.6.0
; Syntax.........: _TS3whoami()
; Parameters ....:
; Return values .: Success - Returns : Information
;                  Failure - Returns 0 and Sets @Error:
;                  |0 - No error.
;                  |1 - Error: Set return - Error message
; Author ........: chip
;
; ;==========================================================================================
Func _TS3whoami()
	TCPSend($TS3connection, "whoami" & Chr(10))
	While 1
		$recv = TCPRecv($TS3connection, 2048)
		$recv = StringReplace($recv, @LF, @CRLF)
		$recv = StringReplace($recv, @CRLF & @CR, @CRLF)
		If StringInStr($recv, "virtualserver_status=") Then
			$recv = StringReplace($recv, "error id=0 msg=ok", "")
			Return $recv
		ElseIf StringInStr($recv, "error") Then
			Return SetError(1, 0, _TS3errors($recv))
			ExitLoop
		EndIf
	WEnd
EndFunc   ;==>_TS3whoami