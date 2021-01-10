#include <guiconstants.au3>
#include <file.au3>
Global $i, $rcount, $time, $main, $acc, $data, $send, $123, $recv, $file, $string

$ruser = InputBox("Username", "Input Usernme") ;input your username
$rpass = InputBox("Password", "Input password", "", "*") ;input your password
$ucount = StringLen($ruser);how long the string is
$pcount = StringLen($rpass);how long the string is
;create the gui
GUICreate("telnet", 400, 200)
$edit = GUICtrlCreateEdit("", 10, 50, 190, 150)
$user = GUICtrlCreateInput("", 300, 10, 90, 30)
$pass = GUICtrlCreateInput("", 300, 50, 90, 30)
$command = GUICtrlCreateInput("", 300, 90, 90, 30)
GUICtrlCreateLabel("username used", 210, 10, 90, 30)
GUICtrlCreateLabel("password used", 210, 50, 90, 30)
GUICtrlCreateLabel("last command", 210, 90, 90, 30)
GUICtrlCreateLabel("Command log", 10, 10, 90, 30)
GUISetState()
;gets the ip and port
$ip = @IPAddress1
$port = 23
If $ip = "127.0.0.1" Then
	$ip = @IPAddress2
EndIf
;main connection
connect()
Func connect()
	TCPStartup()
	$main = TCPListen($ip, $port, 1000)
	Sleep(400)
	Do
		$acc = TCPAccept($main)
	Until $acc > -1
	$rcount = 0;rcount = wrong trys you only get 3
	$time = 0;my servers connection times out every 10 min after you connected
	;set user and passboxes to defalt
	GUICtrlSetData($user, "")
	GUICtrlSetData($pass, "")
	;sends welcome message
	$send = TCPSend($acc, "            ******************************************" & @CRLF)
	$send = TCPSend($acc, "            **     This server is my test server    **" & @CRLF)
	$send = TCPSend($acc, "            ******************************************" & @CRLF)
	$recv = TCPRecv($acc, 100)
	user()
EndFunc   ;==>connect

;for the user name
Func user()
	$send = TCPSend($acc, "Username:")
	Do
		$recv = TCPRecv($acc, 100)
		GUICtrlSetData($user, GUICtrlRead($user) & $recv);sends the recved data to the user box
	Until $recv = @CRLF
	$string = StringLeft(GUICtrlRead($user), $ucount)
	;the reson iv used this way of checking the username is correct is becouse i could not strip the @crlf away from th string
	If $string = $ruser Then
		$rcount = 0
		pass()
	EndIf
	$rcount = $rcount + 1;if password is wrong then this adds to the wrong counter once it gets to 3 connection is cut
	If $rcount >= 3 Then
		TCPCloseSocket($main)
		TCPShutdown()
		connect()
	EndIf
	$send = TCPSend($acc, "username wrong" & @CRLF)
	GUICtrlSetData($user, "")
	user()
EndFunc   ;==>user
;for the password
Func pass()
	$send = TCPSend($acc, "please type password for user" & @CRLF)
	$send = TCPSend($acc, "password:")
	Do
		$recv = TCPRecv($acc, 10000)
		GUICtrlSetData($pass, GUICtrlRead($pass) & $recv)
	Until $recv = @CRLF
	$string = StringLeft(GUICtrlRead($pass), $pcount)
	If $string = $rpass Then
		$rcount = 0
		TCPSend($acc, "connected..." & @CRLF)
		
		TCPSend($acc, @CRLF)
		TCPSend($acc, "**************************************************************************************************************" & @CRLF)
		TCPSend($acc, "*   help shows commands                                                                                      *" & @CRLF)
		TCPSend($acc, "*   process list shows process list                                                                          *" & @CRLF)
		TCPSend($acc, "*   exit just exits                                                                                          *" & @CRLF)
		TCPSend($acc, "*   read reads an txt/au3 file u must putit like this: read au3.au3 :dont forget the spaceat the end         *" & @CRLF)
		TCPSend($acc, "*   new wrights a new file au3 or txt it is the same as above: new au3.au3 :dont forget the space at the end *" & @CRLF)
		TCPSend($acc, "**************************************************************************************************************" & @CRLF)
		
		TCPSend($acc, @ScriptDir & ">")
		connected()
	EndIf
	$rcount = $rcount + 1
	If $rcount >= 3 Then
		TCPCloseSocket($main)
		TCPShutdown()
		connect()
	EndIf
	TCPSend($acc, "pass wrong" & @CRLF)
	GUICtrlSetData($pass, "")
	pass()
EndFunc   ;==>pass
;when your connected
Func connected()
	
	Do
		
		$time = $time + 100
		$recv = TCPRecv($acc, 10000)
		If $recv > "" Then
			$data = ""
			GUICtrlSetData($edit, GUICtrlRead($edit) & $recv)
			GUICtrlSetData($command, GUICtrlRead($command) & $recv)
			$data = GUICtrlRead($command)
			cmds()
		EndIf
		If $recv = @CRLF Then
			cmds()
			TCPSend($acc, @ScriptDir & ">")
			GUICtrlSetData($command, $data)
			GUICtrlSetData($command, "")
		EndIf
		ToolTip($time, 0, 0)
		Sleep(100)
		If $time = 600000 Then
			TCPCloseSocket($main)
			TCPShutdown()
			connect()
		EndIf

	Until 1 = 2
EndFunc   ;==>connected

Func cmds()
	If $data = "exit" & @CRLF Then
		
		$123 = 1
		TCPSend($acc, @CRLF)
		Do
			$str = StringSplit(" ok bye bye", "")
			$123 = $123 + 1
			TCPSend($acc, $str[$123])
			Sleep(400)
		Until $123 >= $str[0]
		Sleep(100)
		TCPCloseSocket($main)
		TCPShutdown()
		connect()
		$time = 0
	EndIf
	If $data = "help" & @CRLF Then

		TCPSend($acc, @CRLF)
		TCPSend($acc, "**************************************************************************************************************" & @CRLF)
		TCPSend($acc, "*   help shows commands                                                                                      *" & @CRLF)
		TCPSend($acc, "*   process list shows process list                                                                          *" & @CRLF)
		TCPSend($acc, "*   exit just exits                                                                                          *" & @CRLF)
		TCPSend($acc, "*   read reads an txt/au3 file u must putit like this: read au3.au3 :dont forget the spaceat the end         *" & @CRLF)
		TCPSend($acc, "*   new wrights a new file au3 or txt it is the same as above: new au3.au3 :dont forget the space at the end *" & @CRLF)
		TCPSend($acc, "**************************************************************************************************************" & @CRLF)
		
		GUICtrlSetData($command, "")
		$data = ""
		$time = 0
	EndIf
	
	If $data = "process list" & @CRLF Then
		$time = 0
		TCPSend($acc, @CRLF)
		$list = ProcessList()
		
		For $i = 1 To $list[0][0]
			TCPSend($acc, $list[$i][0] & @CRLF)
			If $i = $list[0][0] Then
				$data = ""
				TCPSend($acc, @ScriptDir & ">")
				GUICtrlSetData($command, "")
				connected()
			EndIf
		Next
	EndIf
	$string = StringSplit($data, " ")
	If $string[0] = 3 Then
		If $string[1] = "read" Then
			$time = 0
			TCPSend($acc, @CRLF)
			_FileReadToArray(@ScriptDir & "/" & $string[2], $file)
			For $i = 1 To $file[0]
				
				
				TCPSend($acc, $file[$i] & @CRLF)
			Next
			TCPSend($acc, @CRLF)
			$data = ""
			TCPSend($acc, @ScriptDir & ">")
			GUICtrlSetData($command, "")
			
		EndIf
	EndIf
	If $string[0] = 3 Then
		If $string[1] = "new" Then

			$time = 0
			TCPSend($acc, @CRLF & "press enter to begin and press ; to finsh")
			GUICtrlSetData($command, "")
			While 1
				$recv = TCPRecv($acc, 10000)
				GUICtrlSetData($command, GUICtrlRead($command) & $recv)
				
				$data = GUICtrlRead($command)


				If $recv = @CRLF Then
					FileWriteLine($string[2], $data)
					GUICtrlSetData($command, "")
				EndIf
				ToolTip("hi")
				If $data = ";" & @CRLF Then
					ExitLoop
				EndIf
			WEnd
		EndIf
	EndIf
EndFunc   ;==>cmds