#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Res_Fileversion=1.2
#AutoIt3Wrapper_Res_FileVersion_AutoIncrement=y
#AutoIt3Wrapper_Au3Check_Stop_OnWarning=y
#AutoIt3Wrapper_Run_Tidy=y
#Tidy_Parameters=/sfc
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#include <StaticConstants.au3>
#include <WinAPI.au3>
#include <File.au3>
#include <TCP.au3>
#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>

#cs _TCP_RegisterEvent()
	$TCP_SEND: 			When you send something.								:	Function($hSocket, $iError)
	$TCP_RECEIVE:		If something is received.								:	Function($hSocket, $sReceived, $iError)
	$TCP_CONNECT:		When you connect to the server. (Client only)			:	Function($hSocket, $iError)
	$TCP_DISCONNECT:	When a connection is closed.							:	Function($hSocket, $iError)
	$TCP_NEWCLIENT:		When a new client connects to the server. (Server only)	:	Function($hSocket, $iError)
#ce

Global Const $iPort = 8080
Global Const $sIP = @IPAddress1
Global Const $LogPath = @ScriptDir & "\Client Log.txt"
Global Const $ConnectionTimeout = 5000 ;5 seconds
Global $ConnectionStatus = 0

#Region Create Login GUI
Global $ClientSocket, $Timer, $Abort = False, $ActiveTimer = 1
Dim $IPBox[5], $Dot[3], $IPInput[4], $PortBox[5]

$PingGUI = GUICreate("Connection Settings", 244, 97, 199, 133, BitOR($WS_CAPTION, $WS_POPUPWINDOW))

;create ip address box
GUICtrlCreateLabel("IP Address:", 10, 10, 70, 21, $SS_CENTERIMAGE)
GUICtrlSetFont(-1, 9, 400, 0, "MS Sans Serif")
$IPBox[0] = GUICtrlCreateLabel("", 80, 10, 153, 1)
$IPBox[1] = GUICtrlCreateLabel("", 80, 11, 1, 19)
$IPBox[2] = GUICtrlCreateLabel("", 80, 30, 153, 1)
$IPBox[3] = GUICtrlCreateLabel("", 232, 11, 1, 19)
$IPBox[4] = GUICtrlCreateLabel("", 81, 11, 151, 19)
GUICtrlSetBkColor($IPBox[4], 0xFFFFFF)
GUICtrlSetState($IPBox[4], $GUI_DISABLE)
$IPInput[0] = GUICtrlCreateInput("", 81, 13, 36, 15, BitOR($ES_CENTER, $ES_NUMBER), 0)
GUICtrlSetState(-1, $GUI_FOCUS)
$IPInput[1] = GUICtrlCreateInput("", 120, 13, 35, 15, BitOR($ES_CENTER, $ES_NUMBER), 0)
$IPInput[2] = GUICtrlCreateInput("", 158, 13, 35, 15, BitOR($ES_CENTER, $ES_NUMBER), 0)
$IPInput[3] = GUICtrlCreateInput("", 196, 13, 36, 15, BitOR($ES_CENTER, $ES_NUMBER), 0)
$Dot[0] = GUICtrlCreateLabel(".", 117, 11, 3, 19, BitOR($SS_CENTER, $SS_CENTERIMAGE))
$Dot[1] = GUICtrlCreateLabel(".", 155, 11, 3, 19, BitOR($SS_CENTER, $SS_CENTERIMAGE))
$Dot[2] = GUICtrlCreateLabel(".", 193, 11, 3, 19, BitOR($SS_CENTER, $SS_CENTERIMAGE))

;set the state for the IP input box
For $i = 0 To 3
	GUICtrlSetBkColor($IPBox[$i], 0x7F9DB9)
	GUICtrlSetBkColor($IPInput[$i], 0xFFFFFF)
	GUICtrlSetState($IPBox[$i], $GUI_DISABLE)
	GUICtrlSetLimit($IPInput[$i], 3)
Next
For $i = 0 To 2
	GUICtrlSetBkColor($Dot[$i], 0xFFFFFF)
Next

;create port box
GUICtrlCreateLabel("Port:", 10, 36, 70, 21, $SS_CENTERIMAGE)
GUICtrlSetFont(-1, 9, 400, 0, "MS Sans Serif")
$PortBox[0] = GUICtrlCreateLabel("", 80, 56, 153, 1)
$PortBox[1] = GUICtrlCreateLabel("", 80, 37, 1, 19)
$PortBox[2] = GUICtrlCreateLabel("", 80, 36, 153, 1)
$PortBox[3] = GUICtrlCreateLabel("", 232, 37, 1, 19)
$PortBox[4] = GUICtrlCreateLabel("", 81, 37, 151, 19)
GUICtrlSetBkColor($PortBox[4], 0xFFFFFF)
GUICtrlSetState($PortBox[4], $GUI_DISABLE)
$PortInput = GUICtrlCreateInput("", 81, 39, 151, 15, BitOR($ES_CENTER, $ES_NUMBER), 0)

For $i = 0 To 3
	GUICtrlSetBkColor($PortBox[$i], 0x7F9DB9)
	GUICtrlSetState($PortBox[$i], $GUI_DISABLE)
Next

$Connect = GUICtrlCreateButton("Connect", 59, 65, 125, 23, $BS_DEFPUSHBUTTON)

GUISetState(@SW_HIDE, $PingGUI)
#EndRegion Create Login GUI

AttemptConnection() ;Login the user

;set up client
$ClientSocket = _TCP_Client_Create($sIP, $iPort) ;use $ClientSocket for _TCP_SEND function
_TCP_RegisterEvent($ClientSocket, $TCP_RECEIVE, "RegisteredEvent_Receive")

;wait for the server to confirm connection attempt
$Timer = TimerInit()
While $ConnectionStatus = 0
	If TimerDiff($Timer) > $ConnectionTimeout Then
		__WriteLog("Connection Attempt Failed")
		Exit
	EndIf
	Sleep(250)
WEnd

#Region Create Client GUI
$GUI = GUICreate("Client", 421, 356, -1, -1, BitOR($WS_POPUPWINDOW, $WS_CAPTION))
$FileMenu = GUICtrlCreateMenu("File")
$GlobalEdit = GUICtrlCreateEdit("Connected as " & $Username & @CRLF, 10, 10, 400, 250, BitOR($ES_AUTOVSCROLL, $ES_WANTRETURN, $ES_READONLY, $WS_VSCROLL))
GUICtrlSetBkColor(-1, 0xFFFFFF)
$SendButton = GUICtrlCreateButton("Send", 335, 285, 75, 25, $BS_DEFPUSHBUTTON)
$SendEdit = GUICtrlCreateEdit("", 10, 270, 315, 55, BitOR($ES_AUTOVSCROLL, $ES_WANTRETURN, $WS_VSCROLL))
GUICtrlSetState($SendEdit, $GUI_FOCUS)
GUISetState(@SW_SHOW, $GUI)
#EndRegion Create Client GUI

While 1
	$Msg = GUIGetMsg()
	Switch $Msg
		Case $GUI_EVENT_CLOSE
			__WriteLog("Connection broken")
			Exit
		Case $SendButton
			If GUICtrlRead($SendEdit) <> "" Then _TCP_Send($ClientSocket, "##MESSAGE##" & $Username & ": " & GUICtrlRead($SendEdit))
	EndSwitch
WEnd

#Region Login Functions
Func AttemptConnection()
	GUISetState(@SW_SHOW, $PingGUI)
	GUIRegisterMsg($WM_COMMAND, "WM_COMMAND")

	;Main Loop
	While 1
		$Msg = GUIGetMsg()
		Switch $Msg
			Case $GUI_EVENT_CLOSE
				Exit
			Case $Connect
				;174.101.217.234:8080
				$IPAddress = GUICtrlRead($IPInput[0]) & "." & GUICtrlRead($IPInput[1]) & "." & GUICtrlRead($IPInput[2]) & "." & GUICtrlRead($IPInput[3])
				$Port = GUICtrlRead($PortInput)
				;make sure the ip address follows the correct format
				If StringRegExp($IPAddress, "(?<First>2[0-4]\d|25[0-5]|[01]?\d\d?)\.(?<Second>2[0-4]\d|25[0-5]|[01]?\d\d?)\.(?<Third>2[0-4]\d|25[0-5]|[01]?\d\d?)\.(?<Fourth>2[0-4]\d|25[0-5]|[01]?\d\d?)") = 1 Then
					PingServer() ;see if server is running and tell server this is just a ping, not a login
					GUISetState(@SW_HIDE, $PingGUI)
					$Login = LoginWindow() ;ask user for username and password ;send username and password to server to see if they are valid
					If IsArray($Login) Then
						$Abort = False
						_TCP_Send($ClientSocket, "##USERVERIFICATION##" & $Login[0] & @TAB & $Login[1]) ;send username and password to server for verification
						While $Abort = False
						WEnd

						Global Const $Username = $Login[0]

						Return 1
					Else
						_TCP_Client_Stop($ClientSocket)
						Exit
					EndIf
				EndIf
		EndSwitch
	WEnd
EndFunc   ;==>AttemptConnection

Func LoginWindow()
	Local $GUI, $Input1, $Input2, $OK, $Cancel, $Msg, $Username, $Password, $Return[2]

	$GUI = GUICreate("Password Verification", 249, 129, -1, -1, BitOR($WS_CAPTION, $WS_POPUPWINDOW))
	GUICtrlCreateLabel("Enter your login information", 5, 5, 238, 30)
	GUICtrlCreateLabel("Username:", 5, 40, 65, 21, $SS_CENTERIMAGE)
	GUICtrlSetFont(-1, 8, 800, 0, "MS Sans Serif")
	GUICtrlCreateLabel("Password:", 5, 66, 65, 21)
	GUICtrlSetFont(-1, 8, 800, 0, "MS Sans Serif")
	$Input1 = GUICtrlCreateInput("", 76, 40, 167, 21)
	GUICtrlSetLimit(-1, 25)
	$Input2 = GUICtrlCreateInput("", 76, 66, 167, 21, $ES_PASSWORD)
	GUICtrlSetLimit(-1, 20)
	$OK = GUICtrlCreateButton("OK", 39, 96, 75, 25, $BS_DEFPUSHBUTTON)
	$Cancel = GUICtrlCreateButton("Cancel", 134, 96, 75, 25)
	GUISetState(@SW_SHOW, $GUI)

	While 1
		$Msg = GUIGetMsg()
		Switch $Msg
			Case $GUI_EVENT_CLOSE
				GUIDelete($GUI)
				Return SetError(1, 0, "GUI Close")
			Case $Cancel
				GUIDelete($GUI)
				Return SetError(1, 0, "Cancel")
			Case $OK
				$Username = GUICtrlRead($Input1)
				$Password = GUICtrlRead($Input2)
				If $Username = "" And $Password = "" Then
					MsgBox(262192, "ERROR", "You can't leave the username or password blank!")
					GUICtrlSetState($Input1, $GUI_FOCUS)
				ElseIf $Username = "" Then
					MsgBox(262192, "ERROR", "You can't leave the username blank!")
					GUICtrlSetState($Input1, $GUI_FOCUS)
				ElseIf $Password = "" Then
					MsgBox(262192, "ERROR", "You can't leave the password blank!")
					GUICtrlSetState($Input2, $GUI_FOCUS)
				Else
					$Return[0] = $Username
					$Return[1] = $Password
					GUIDelete($GUI)
					Return $Return
				EndIf
		EndSwitch
	WEnd
EndFunc   ;==>LoginWindow

Func PingServer()
	$ClientSocket = _TCP_Client_Create(@IPAddress1, 8080)
	_TCP_RegisterEvent($ClientSocket, $TCP_RECEIVE, "Received")

	$Timer1 = TimerInit()
	While $Abort = False
		If TimerDiff($Timer1) > 5000 And $ActiveTimer = 1 Then ;wait for server to accept connection
			ToolTip("Server Ping Failed." & @CRLF & "Are you sure the server is running?", 10, 10)
			Sleep(3000)
			Exit
		ElseIf TimerDiff($Timer1) > 5000 And $ActiveTimer = 2 Then ;wait for server to reply to ping
			ToolTip("Server Ping Failed." & @CRLF & "Connection lost.", 10, 10)
			Sleep(3000)
			Exit
		EndIf
		Sleep(100)
	WEnd
EndFunc   ;==>PingServer

Func WM_COMMAND($hWnd, $iMsg, $iwParam, $ilParam)
	$iIDFrom = _WinAPI_LoWord($iwParam)
	$iCode = _WinAPI_HiWord($iwParam)

	If $iIDFrom <> ($IPInput[0] Or $IPInput[1] Or $IPInput[2] Or $IPInput[3]) Then Return $GUI_RUNDEFMSG

	For $i = 0 To 2
		If $iIDFrom = $IPInput[$i] Then
			If $iCode = $EN_CHANGE Then
				If StringLen(GUICtrlRead($iIDFrom)) = 3 Then GUICtrlSetState($IPInput[$i + 1], $GUI_FOCUS)
			EndIf
		EndIf
	Next

	Return $GUI_RUNDEFMSG
EndFunc   ;==>WM_COMMAND

Func Received($hSocket, $sReceived, $iError); And we also registered this! Our homemade do-it-yourself function gets called when something is received.
	If $sReceived == "##CONNECTED##" Then
		GUIRegisterMsg($WM_COMMAND, "")

		$ActiveTimer = 2
		$Timer1 = TimerInit()
		_TCP_Send($hSocket, "##PING##")
	ElseIf $sReceived == "##PINGRECEIVED##" Then
		$ActiveTimer = 3
		ToolTip("SUCCESS!", 10, 10)
		$Abort = True
	ElseIf StringLeft($sReceived, 20) == "##USERVERIFICATION##" Then
		Switch StringTrimLeft($sReceived, 20)
			Case ""
				MsgBox(262192, "FAILURE", "The server cannot be reached for unknown reasons.")
				_TCP_Client_Stop($ClientSocket)
				Exit
			Case "0"
				MsgBox(262192, "FAILURE", "The credentials you entered are incorrect. Connection will now be closed.", 10)
				_TCP_Client_Stop($ClientSocket)
				Exit
			Case "1"
				MsgBox(262192, "SUCCESS", "The credentials you submitted have been accepted!")
				$Abort = True
			Case "2" ;for banned users
			Case Else
				MsgBox(262192, "FAILURE", "Something is going very wrong with the server!")
				_TCP_Client_Stop($ClientSocket)
				Exit
		EndSwitch
	Else
		ConsoleWrite($sReceived & @CRLF)
	EndIf
EndFunc   ;==>Received
#EndRegion Login Functions

Func __WriteLog($sMessage)
	_FileWriteLog($LogPath, $sMessage, 1)
EndFunc   ;==>__WriteLog

Func RegisteredEvent_Receive($hSocket, $sReceived, $iError)
	If $sReceived == "##CONNECTED##" Then
		$ConnectionStatus = 1
		__WriteLog("The server has accepted your connection!")
	ElseIf StringLeft($sReceived, 11) == "##MESSAGE##" Then
		If StringLeft($sReceived, StringInStr($sReceived, ":") - 1) = "##MESSAGE##" & $Username Then
			GUICtrlSetData($GlobalEdit, GUICtrlRead($GlobalEdit) & StringTrimLeft($sReceived, 11) & @CRLF)
		Else
			GUICtrlSetData($GlobalEdit, GUICtrlRead($GlobalEdit) & @TAB & StringTrimLeft($sReceived, 11) & @CRLF)
		EndIf
	EndIf
EndFunc   ;==>RegisteredEvent_Receive