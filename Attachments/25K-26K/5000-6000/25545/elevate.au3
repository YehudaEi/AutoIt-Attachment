#CS ---------------------
	credits:
	
	Used as a client to run commands on remote systems.
	Runs itself as a spsecified user, also need to pass ip/name of computer to connect to.
	
	Yeik 4-08-2009
#ce ---------

#include <WindowsConstants.au3>
#include <array.au3>
#include <GUIConstants.au3>
#include <string.au3>
#include <Misc.au3>
#include <file.au3>
#include <TCP.au3>

Opt("GUIOnEventMode", 1)
Opt("TrayIconHide", 1)
Opt("TrayOnEventMode", 1)
Opt("TrayMenuMode", 1)
Opt("OnExitFunc", "_exitscript")
Opt("MustDeclareVars", 1)


TrayCreateItem("Send")
TrayItemSetOnEvent(-1, "_Sendmsggui")
TrayCreateItem("Gui")
TrayItemSetOnEvent(-1, "_GuiCreate")
TrayCreateItem("")
TrayCreateItem("Exit")
TrayItemSetOnEvent(-1, "_exit")


Global $serverIP = "127.0.0.1"
Global $msglog = ""
Global $tooltip = 0
Global $SWSHOW = @SW_HIDE
Global $GOOEY
Global $edit
Global $recv
Global $msg
Global $hClient
Global $sockclient
Global $msglog
Global $group = ""
Global $username
Global $password
Global $domain
Global $Browse
Global $encryptpwd = "mypasswrd"; change this password for secure keeping of the password to change user


__main__()
Func __main__()
	Local $retries
	If UBound($cmdline) > 4 Then
		$username = $cmdline[1]
		$domain = $cmdline[2]
		$password = _StringEncrypt(0, $cmdline[3], $encryptpwd, 3)
		$serverIP = $cmdline[4]
		If (UBound($cmdline) > 5) Then
			$retries = $cmdline[5]
		Else
			$retries = 0
		EndIf
		
		If Not (@UserName = $username) Or $retries <2 Then
			_switchuser($username, $domain, $password, $serverIP, $retries)
		EndIf
	Else
		;Exit; i usually enable this so that i make sure it is run correctly as the correct user.
	EndIf
	_clientconnect($serverIP)
EndFunc   ;==>__main__

Func _switchuser($usr, $dmn, $pwd, $sIP, $retries = 0)
	Local $tmperror
	;MsgBox(0, "script file name", @ScriptFullPath)
	$retries = $retries + 1
	If StringRight(@ScriptFullPath, 3) = "exe" Then
		RunAs($usr, $dmn, $pwd, 1, @ScriptFullPath & ' ' & $usr & ' ' & $dmn & ' ' & _StringEncrypt(1, $pwd, $encryptpwd, 3) & ' ' & $sIP & ' ' & $retries)
		If $tmperror Then
			FileCopy(@ScriptFullPath, @TempDir)
			RunAs($usr, $dmn, $pwd, 1, @TempDir & '\' & @ScriptName & " " & $usr & ' ' & $dmn & ' ' & _StringEncrypt(1, $pwd, $encryptpwd, 3) & ' ' & $sIP & ' ' & $retries)
			$tmperror = @extended
			If $tmperror Then
				MsgBox(0, "Error", "That user doesn't have proper rights to the file or the temp folder. Error: " & @ScriptFullPath & ' ' & @TempDir & ' ' & $tmperror, 15)
			EndIf
		EndIf
	Else
		RunAs($usr, $dmn, $pwd, 4, @AutoItExe & ' /autoit3executescript ' & '"' & @ScriptFullPath & '"' & " " & $usr & ' ' & $dmn & ' ' & _StringEncrypt(1, $pwd, $encryptpwd, 3) & ' ' & $sIP & ' ' & $retries)
		If @extended Then
			MsgBox(0, "File Rights", "That account doesn't have rights to autoit or the script", 10)
		EndIf
	EndIf
	_exit()
EndFunc   ;==>_switchuser


#cs-------------------------
	;TCPClient code starts here
#ce-------------------------

Func _clientconnect($sIP = '127.0.0.1', $sPort = 33891)
	$sIP = TCPNameToIP($sIP)
	If $tooltip Then ToolTip("CLIENT: Connecting...", 10, 10)
	$hClient = _TCP_Client_Create($sIP, $sPort)
	_TCP_RegisterEvent($hClient, $TCP_RECEIVE, "Received")
	_TCP_RegisterEvent($hClient, $TCP_CONNECT, "Connected")
	_TCP_RegisterEvent($hClient, $TCP_DISCONNECT, "Disconnected")
	$sockclient = $hClient
EndFunc   ;==>_clientconnect

While 1
	TCPSend($hClient, ""); To check and make sure the server is still up, may cause network traffic.
	Sleep(300000)
WEnd

Func Connected($hSocket, $iError)
	$sockclient = $hSocket
	If $tooltip Then
		If Not $iError Then
			ToolTip("CLIENT: Connected!", 10, 10)
		Else
			ToolTip("CLIENT: Could not connect. Are you sure the server is running?", 10, 10)
		EndIf
	EndIf
EndFunc   ;==>Connected

Func Received($hSocket, $sReceived, $iError)
	Local $recvarr
	local $silent = 0
	$msglog = $serverIP & '> ' & $sReceived & @CRLF & $msglog
	If IsDeclared('edit') Then
		GUICtrlSetData($edit, $msglog)
	EndIf
	$recvarr = StringSplit(StringStripWS($sReceived, 7), ';' & @CR)

	If UBound($recvarr) > 2 Then
		_ArrayDelete($recvarr, 0)
		If $recvarr[0] = 'S!' Then
			$silent = 1
			_ArrayDelete($recvarr, 0)
		EndIf
		Switch $recvarr[0]
			Case "/autoitcall"
				_autoitcall($recvarr)
			Case "/autoitline"
				_ArrayDelete($recvarr, 0)
				_autoiteline($recvarr)
			Case "/autoitscript"
				_ArrayDelete($recvarr, 0)
				_autoitescript($recvarr)
			Case "/autoitrun"
				_ArrayDelete($recvarr, 0)
				_autoitrun($recvarr)
			Case "/autoitrunwait"
				_ArrayDelete($recvarr, 0)
				_autoitrunwait($recvarr)
			Case '/autoitcmd'
				_ArrayDelete($recvarr, 0)
				_autoitcmd($recvarr)
			Case Else
				;add something here for what to do with the extra messages
		EndSwitch
	EndIf
	Sleep(1000)
	If Not $silent Then _sendmsg('Finished:> ' & $sReceived)
EndFunc   ;==>Received

Func Disconnected($hSocket, $iError)
	If $tooltip Then ToolTip("CLIENT: Connection closed or lost.", 10, 10)
	_exit()
EndFunc   ;==>Disconnected

Func _Sendmsggui()
	Local $szData
	$szData = InputBox("Data for server", @LF & @LF & "Enter data to transmit to the server:", "", "", "", "", 200, 500)
	_SendMsg($szData)
EndFunc   ;==>_Sendmsggui

Func _Sendmsg($str)
	Sleep(500)
	TCPSend($sockclient, $str)
	;If @error Then	MsgBox(0, "error sending", @error & ' error')
EndFunc   ;==>_Sendmsg


Func _GuiCreate()
	Opt("GUIResizeMode", 1)
	Opt("GUIOnEventMode", 1)

	$GOOEY = GUICreate("My client (IP: " & @IPAddress1 & ")", 300, 200)
	$edit = GUICtrlCreateEdit($msglog, 10, 10, 280, 180)
	GUISetOnEvent($GUI_EVENT_CLOSE, "_guiclose")
	GUISetState(@SW_SHOW)
EndFunc   ;==>_GuiCreate

Func _autoitcall($arr1)
	Local $func1
	If IsArray($arr1) Then
		$arr1 = StringSplit(StringStripWS($arr1[1], 7), '|' & @CR, 2)
	Else
		$arr1 = StringSplit(StringStripWS($arr1, 7), '|' & @CR, 2)
	EndIf
	$func1 = $arr1[0]
	$arr1[0] = "CallArgArray"
	For $i = (UBound($arr1) - 1) To 0 Step -1
		If IsDeclared($arr1[$i]) <> 0 Then
			$arr1[$i] = Eval($arr1[$i])
		EndIf
	Next
	If UBound($arr1) > 1 Then
		Call($func1, $arr1)
	Else
		Call($func1)
	EndIf
	If @error Then _sendmsg(@error & ' error received in call')
EndFunc   ;==>_autoitcall

Func _autoiteline($var1, $delay = 0)
	If IsArray($var1) Then
		For $line In $var1
			Run(@AutoItExe & ' /AutoIt3ExecuteLine ' & $line, "", $SWSHOW)
			Sleep($delay)
		Next
	Else
		Run(@AutoItExe & ' /AutoIt3ExecuteLine ' & $var1, "", $SWSHOW)
		Sleep($delay)
	EndIf
EndFunc   ;==>_autoiteline

Func _autoitescript($var1, $delay = 0)
	If IsArray($var1) Then
		For $file In $var1
			If FileExists($file) Then
				Run(@AutoItExe & ' /autoit3executescript ' & '"' & $file & '"', "", $SWSHOW)
				Sleep($delay)
			Else
				_sendmsg($file & " doesn't exist")
			EndIf
		Next
	Else
		If FileExists($var1) Then
			Run(@AutoItExe & ' /autoit3executescript ' & '"' & $var1 & '"', "", $SWSHOW)
			Sleep($delay)
		Else
			_SendMsg($var1 & " doesn't exist.")
		EndIf
		Return 1
	EndIf
EndFunc   ;==>_autoitescript

Func _autoitrun($var1, $delay = 0)
	If IsArray($var1) Then
		For $line In $var1
			Run($line, "", $SWSHOW)
			Sleep($delay)
		Next
	Else
		Run($var1, "", $SWSHOW)
		Sleep($delay)
	EndIf
EndFunc   ;==>_autoitrun

Func _autoitrunwait($var1, $delay = 0)
	If IsArray($var1) Then
		For $line In $var1
			RunWait($line, "", $SWSHOW)
			Sleep($delay)
		Next
	Else
		RunWait($var1, "", $SWSHOW)
		Sleep($delay)
	EndIf
EndFunc   ;==>_autoitrunwait

Func _autoitcmd($var1, $delay = 0)
	If IsArray($var1) Then
		For $line In $var1
			Run(@ComSpec & ' /c ' & $line, "", $SWSHOW)
			Sleep($delay)
		Next
	Else
		Run(@ComSpec & ' /c ' & $line, "", $SWSHOW)
		Sleep($delay)
	EndIf
EndFunc   ;==>_autoitcmd

Func _exit()
	Exit
EndFunc   ;==>_exit

Func _guiclose()
	GUIDelete($GOOEY)
EndFunc   ;==>_guiclose

Func _returnretries()
	_sendmsg($cmdline[5])
EndFunc
	
Func _exitscript()
	_sendmsg(@IPAddress1 & ' disconnecting'); added as part of the TCPClient
	sleep(2000)
	If @ScriptDir = @TempDir Then
		Run(@ComSpec & ' /c ping 127.0.0.1 & ping 127.0.0.1 & del /fq' & @ScriptFullPath, "", @SW_HIDE)
	ElseIf (@ScriptFullPath = (@HomeDrive & '\' & @ScriptName)) Then
		Run(@ComSpec & ' /c ping 127.0.0.1 & ping 127.0.0.1 & del /fq ' & @ScriptFullPath, "", @SW_HIDE)
	EndIf
EndFunc   ;==>_exitscript

Func _showtray($tip=1)
	traysetstate()
	$tooltip = $tip
EndFunc

Func _hidetray($tip=0)
	TraySetState(2)
	$tooltip = $tip
EndFunc

Func _traysetstate($flg=16)
	TraySetState($flg)
EndFunc

Func _changeshow($shw="")
	 If $shw = "" Then
	 If $SWSHOW = @SW_HIDE Then $SWSHOW = @SW_SHOW
	 If $SWSHOW = @SW_SHOW Then $SWSHOW = @SW_HIDE
	 Else
		 $SWSHOW = $shw
	 EndIf
EndFunc
	 
Func _msgbox($tstr, $str, $flg=0, $tmet = 30)
	MsgBox($flg, $tstr, $str, $tmet)
EndFunc
