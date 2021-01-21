;CWM SERVER: VERSION 0.0.1:ALPHA

If ProcessExists("server-0.0.1-PRE-ALPHA.exe") Then ProcessClose ("server-0.0.1-PRE-ALPHA.exe")

$CWMdir = RegRead ("HKCU\Software\CWMessenger", "CWMdir")
If $CWMdir = "" Then
	MsgBox (16, "CodeWiz Messenger", "Error: Could not read CWMdir from registry HKEY_CURRENT_USER\Software\CWMessenger")
	Exit
EndIf
$Port = 44844
Global $MaxConc = 100
Global $MainSocket = TCPStartServer($Port, $MaxConc)
If @error <> 0 Then Exit MsgBox(16, "Error", "Server unable to initialize.")
MsgBox (64, "CodeWiz Messenger", "Server started successfully at "&@IPAddress1)
IniWrite ($CWMdir&"\info.ini", "connected", "connected", 1)
Global Const $MaxLength = 512
Global $ConnectedSocket[$MaxConc]
Global $CurrentSocket = 0
Local $Track = 0
Global Const $MaxConnection = ($MaxConc - 1)
For $Track = 0 To $MaxConnection Step 1
    $ConnectedSocket[$Track] = -1
Next
While 1
    $ConnectedSocket[$CurrentSocket] = TCPAccept($MainSocket)
    If $ConnectedSocket[$CurrentSocket] <> - 1 Then
        $CurrentSocket = SocketSearch()
    EndIf
    $Track = 0
    For $Track = 0 To $MaxConnection Step 1
        If $ConnectedSocket[$Track] <> - 1 Then
            $Data = TCPRecv($ConnectedSocket[$Track], $MaxLength)
			If @error Then
				IniWrite ($CWMdir&"\info.ini", "connected", "connected", 0)
				MsgBox (48, "CodeWiz Messenger", "The CWM server has been disconnected.")
				ProcessClose (@AutoItPID)
			EndIf
            If $Data <> "" Then
                CWM_msg_interp($Data, $ConnectedSocket[$Track])
            EndIf
        EndIf
    Next
WEnd

;----------------
#region functions---------------------------------------------------------------------------------------------------------------------
;----------------

Func SocketSearch()
    Local $Track = 0
    For $Track = 0 To $MaxConnection Step 1
        If $ConnectedSocket[$Track] = -1 Then
            Return $Track
        Else
        ; Socket In Use
        EndIf
    Next
EndFunc  ;==>SocketSearch
Func TCPSendMessageAll($ConnectionLimit, $Data)
    Local $Track = 0
    For $Track = 0 To $ConnectionLimit Step 1
        If $ConnectedSocket[$Track] <> - 1 Then TCPSend($ConnectedSocket[$Track], $Data)
    Next
EndFunc  ;==>TCPSendMessageAll
Func TCPStartServer($Port, $MaxConnect = 1)
    Local $Socket
    $Socket = TCPStartup()
	If $Socket = 0 Then
		SetError (@error)
		return -1
	EndIf
    Global $Socket = TCPListen(@IPAddress1, $Port, $MaxConnect)
	If $Socket = -1 Then
		SetError(@error)
		Return 0
	EndIf
    SetError(0)
    Return $Socket
EndFunc  ;==>TCPStartServer

;------------------------------------------

Func CWM_msg_interp ($inputmsg, ByRef $Track_br)
	$msg_split = StringSplit ($inputmsg, ",")
	If $msg_split[0] > 3 Then
		For $i=4 To $msg_split[0]
			$msg_split[3] &= $msg_split[$i]
		Next
	EndIf
	$IP = $msg_split[1]
	$Action = $msg_split[2]
	If $Action <> "CWM_SERVER_PING" Then $info = $msg_split[3]
	$temp_conn = TCPConnect ($IP, $Port)
	Switch $Action
		Case "CWM_ACT_REGISTER"
			;[IP],CWM_ACT_REGISTER,[username] [password]
			$register_info = StringSplit ($info, " ")
			If IniRead ( $CWMdir&"\info.ini", "registered_users", $register_info[1], "" ) <> "" Then
				TCPSend ($temp_conn, @IPAddress1 & ",CWM_REGISTER_FAILED,Registration was unsuccessfull. The specified username already exists.")
			Else
				If IniWrite ($CWMdir&"\info.ini", "registered_users", $register_info[1], $register_info[2]) = 0 Then
					TCPSend ($temp_conn, @IPAddress1 & ",CWM_REGISTER_FAILED,Registration was unsuccessfull. The server info file is mode R. please notify theguy0000@gmail.com.")
					MsgBox ( 48, "CodeWiz Messenger", $IP & " tried to register with username "&$register_info[1]&" and password "&$register_info[2]&", but was unsuccessful because the info.ini file is Read-Only.")
				EndIf
			EndIf
		Case "CWM_ACT_LOGIN"
			$input = StringSplit ($info, " ")
			$username = $input[1]
			$password = $input[2]
			$user_ini = IniRead ($CWMdir&"\info.ini", "registered_users", $username, "")
			If $user_ini = "" Then
				TCPSend ($temp_conn, @IPAddress1 & ",CWM_LOGIN_FAILED,Incorrect username/Password")
			Else
				If $user_ini = $password Then
					IniWrite ($CWMdir&"\info.ini", "logged_users", $username, $IP)
					TCPSend ($temp_conn, @IPAddress1 & ",CWM_LOGIN_CONFIRM," & $username)
				Else
					TCPSend ($temp_conn, @IPAddress1 & ",CWM_LOGIN_FAILED,Incorrect username/Password")
				EndIf
			EndIf
		Case "CWM_MSG_SEND"
			$input = StringSplit ($info, " ")
			If $input[0] > 3 Then
				For $i=4 To $input[0]
					$input[3] &= $input[$i]
				Next
			EndIf
			$to = $input[1]
			$from = $input[2]
			$message = $input[3]
			$temp_conn2 = TCPConnect(CWM_User2Ip($to), $Port)
			TCPSend ($temp_conn2, @IPAddress1 & "CWM_MSG_RECV,"&$from&" "&$message)
		Case "CWM_SERVER_PING"
			TCPSend ($temp_conn, @IPAddress1&",CWM_SERVER_PONG")
		Case "CWM_CLIENT_BYE"
			TCPCloseSocket ($Track_br)
			$Track_br = -1
			$CurrentSocket = SocketSearch()
	EndSwitch
EndFunc

Func CWM_User2Ip($user)
	Return IniRead ( $CWMdir&"\info.ini", "logged_users", $user, "")
EndFunc

Func OnAutoItExit()
	MsgBox (0, "CodeWiz Messenger", "AutoItExit requested. Click OK to disconnect.")
	TCPSendMessageAll ($MaxConnection, @IPAddress1 & ",CWM_MSG_RECV,Global_Server_Message Server has been disconnect due to server exit request.")
	TCPCloseSocket ($Socket)
EndFunc