#Include <String.au3>
#include <GUIConstants.au3>

$cconfile = "client.ini"

If FileExists ($cconfile) Then
	$server = IniRead($cconfile, "client", "server", "")
	$port = IniRead($cconfile, "client", "port", "")
Else
	MsgBox(0, "Error", "Missing configuration file")
	$open = FileOpen($cconfile, 2)
	FileWrite($open, "[client]" & @CRLF)
	FileWrite($open, "server = " & @CRLF)
	FileWrite($open, "port = " & @CRLF)
	Exit
EndIf

If $server = "" OR $port = "" Then
	MsgBox(0, "Error", "Please enter server IP address and port in client.ini")
	Exit
EndIf

Local $cmProc = "0"
$cmd = @ProgramFilesDir & "\VideoLAN\VLC\vlc.exe"

$vlcPort = Random(55000, 60000, 1)

TCPStartUp()
$socket = TCPConnect($server, $port)
If $socket = -1 Then
	MsgBox(0, "Error", "Unable to connect to server " & $server & " on port " & $port & "!")
	Exit
EndIf

Local $sdata

For $timer = 1 to 2
	$sdata &= TCPRecv($socket, 500000)
	Sleep(250)
Next

$data = _UNSCRAMBLE($sdata)

$open = FileOpen(@TempDir & "\1.txt", 2)
FileWrite($open, $data)
FileClose($open)

$loginData = _SCRAMBLE(@IPAddress1 & ":" & $vlcPort)
TCPSend($socket, $loginData)
;TCPSend($socket, @IPAddress1 & ":" & $vlcPort)

GUICreate("Client", 350, 80)
$mList = GUICtrlCreateCombo("", 20, 10, 180, 20)
GUICtrlSetData($mList, $data)
$send = GUICtrlCreateButton("START", 225, 10, 50, 20)
$stop = GUICtrlCreateButton("STOP", 285, 10, 50, 20)
GUICtrlSetState($stop, $GUI_DISABLE)
$edit = GUICtrlCreateEdit("Server connected at: " & $server & ":" & $port & ". Using port " & $vlcPort, 10, 45, 330, 20, $ES_READONLY)

GUISetState()

While 1

;Server heartbeat
$sPing = TCPSend($socket, "")
If @Error Then
	MsgBox(0, "Error", "Lost connectivity to server!")
	Exit
EndIf	

;read incoming packets
$snData = TCPRecv($socket, 500000)
$check = StringLen($snData)

If $check > "0" Then

	$readHeader = StringLeft($snData, 7)
	$snewdata = StringTrimLeft($snData, 7)
	$newdata = _UNSCRAMBLE($snewdata)


	If $readHeader = "NEWLIST" Then

		FileDelete(@TempDir & "\1.txt")
		FileMove(@TempDir & "\2.txt", @TempDir & "\1.txt")	
		$open = FileOpen(@TempDir & "\2.txt", 2)
		FileWrite($open, $newdata)
		FileClose($open)
		FileChangeDir(@TempDir)
		$fcout = Run(@ComSpec & " /c fc 1.txt 2.txt", "", @SW_HIDE, $STDOUT_CHILD)

		Local $diffout = ""
		Do
			$diffout &= StdOutRead($fcout)
		Until @Error

		$checkstr = StringInStr($diffout, "no differences encountered")
		If $checkstr = "0" Then
			GUICtrlSetData($mList, "")
			GUICtrlSetData($mList, $newdata)
		EndIf

		FileChangeDir(@ScriptDir)

	ElseIf $readHeader = "NEWPROC" Then
		$mProc = $newdata
	Else
		MsgBox(0, $readHeader, $newdata)
	EndIf

EndIf

;Check if vlc is running
If $cmProc <> "0" Then
	If NOT ProcessExists($cmProc) Then
		TCPSend($socket, "MOVSTOP," & $mProc & "," & @IPAddress1 & ":" & $vlcPort & "," & $movie)
		GUICtrlSetState($send, $GUI_ENABLE)
		GUICtrlSetState($mList, $GUI_ENABLE)
		GUICtrlSetState($stop, $GUI_DISABLE)
		Local $cmProc = "0"
	EndIf
EndIf

$msg = GUIGetMsg()
Select

	Case $msg = $send
	$movie = GUICtrlRead($mList)
	If $movie <> "" Then
		$addcmd = " udp://@:" & $vlcPort & " :access-filter=timeshift :udp-caching=300"
		$fullcmd = $cmd & $addcmd
		GUICtrlSetState($send, $GUI_DISABLE)
		GUICtrlSetState($mList, $GUI_DISABLE)
		GUICtrlSetState($stop, $GUI_ENABLE)
		$cmProc = Run($fullcmd)
		$ssend = _SCRAMBLE("MOVREQ," & @IPAddress1 & ":" & $vlcPort & "," & $movie)
		TCPSend($socket, $ssend)
		;TCPSend($socket, "MOVREQ," & @IPAddress1 & ":" & $vlcPort & "," & $movie)
	Else
		MsgBox(0, "Error", "Please select a movie from the drop-down list first.")
	EndIf

	Case $msg = $stop
	If $mProc <> "" Then
		$sstop = _SCRAMBLE("MOVSTOP," & $mProc & "," & @IPAddress1 & ":" & $vlcPort & "," & $movie)
		TCPSend($socket, $sstop)
		;TCPSend($socket, "MOVSTOP," & $mProc & "," & @IPAddress1 & ":" & $vlcPort & "," & $movie)
		GUICtrlSetState($send, $GUI_ENABLE)
		GUICtrlSetState($mList, $GUI_ENABLE)
		GUICtrlSetState($stop, $GUI_DISABLE)
		ProcessClose($cmProc)
		Local $cmProc = "0"
	EndIf

	Case $msg = $GUI_EVENT_CLOSE
	If $cmProc <> "0" Then
		TCPSend($socket, "MOVSTOP," & $mProc & "," & @IPAddress1 & ":" & $vlcPort & "," & $movie)
		ProcessClose($cmProc)
	EndIf
	Exit

EndSelect
WEnd


;====================================
; encrypts input with a random string
;==================================== 

Func _SCRAMBLE($pINPUT)

$key = Random(1111111111, 9999999999, 1)
$skey1 = StringTrimRight($key, 5)
$skey2 = StringTrimLeft($key, 5)
$eSTRING = _StringEncrypt(1, $pINPUT, $key)
$newSTRING = $skey1 & $eSTRING & $skey2
Return $newSTRING

EndFunc

;==================================
; decrypts input with random string
;==================================

Func _UNSCRAMBLE($pINPUT)
$skey1 = StringLeft($pINPUT, 5)
$skey2 = StringRight($pINPUT, 5)
$key = $skey1 & $skey2

$tVAR1 = StringTrimLeft($pINPUT, 5)
$tVAR2 = StringTrimRight($tVAR1, 5)
$eSTRING = _StringEncrypt(0, $tVAR2, $key)
Return $eSTRING

EndFunc
