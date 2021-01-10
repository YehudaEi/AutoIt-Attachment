#Include <File.au3>
#Include <Array.au3>
#Include <String.au3>
#include <GUIConstants.au3>

$sconfile = "server.ini"

If FileExists($sconfile) Then
	$port = IniRead($sconfile, "server", "port", "6969")
	$mLocation = IniRead($sconfile, "server", "media", @ScriptDir)
Else
	MsgBox(0, "Error", "Missing configuration file")
	$open = FileOpen($sconfile, 2)
	FileWrite($open, "[server]" & @CRLF)
	FileWrite($open, "port = " & @CRLF)
	FileWrite($open, "media = " & @CRLF)
	Exit
EndIf

If $port = "" Then
	$port = "6969"
EndIf

If $mLocation = "" Then
	$mLocation = @ScriptDir
EndIf


TCPStartUp()

$max = "25"
Local $cons = "0"
Dim $cSocketArray[$max]
Dim $IPsoc[$max]
$cmd = @ProgramFilesDir & '\VideoLAN\VLC\vlc.exe'


$socket = TCPListen(@IPAddress1, $port)
If $socket = -1 Then 
	MsgBox(0, "Error", "Unable to bind to port " & $port)
	Exit
EndIf

$mediaList = _FileListToArray($mLocation, "*", 1)
$mListSend = _ArrayToString($mediaList, "|", 1)
$dtNOW = @MON & "/" & @MDAY & "/" & @YEAR & " - " & @HOUR & ":" & @MIN & ":" & @SEC

GUICreate("Server started at " & @IPAddress1 & " on port " & $port, 500, 315)
GUICtrlCreateLabel("Media List:", 20, 10)
$emList = GUICtrlCreateList("", 20, 30, 220, 150)
GUICtrlSetData($emList, $mListSend, "")
GUICtrlCreateLabel("Connected IPs / Sockets:", 260, 10)
$ipsocketList = GUICtrlCreateList("", 260, 30, 220, 150, $ES_READONLY)
GUICtrlCreateLabel("Event log:", 20, 230)
$log = GUICtrlCreateEdit($dtNOW & " Server started.", 20, 250, 460, 50, $ES_AUTOVSCROLL+$WS_VSCROLL+$ES_READONLY)

$refresh = GUICtrlCreateButton("REFRESH", 75, 200, 100, 20)
$exit = GUICtrlCreateButton("EXIT", 325, 200, 100, 20)


GUISetState()
While 1

;listen for connection and send media list
$cSocket = TCPAccept($socket)
If $cSocket >= "0" AND $cons < $max Then

	Local $ssockIPData = ""
	;encrypt before sending to prevent network sniffers from see plain text list
	$smListSend = _SCRAMBLE($mListSend)
	TCPSend($cSocket, $smListSend)

	For $timer = 1 to 4
		$ssockIPData &= TCPRecv($cSocket, 500000)
		Sleep(250)
	Next

	$sockIPData = _UNSCRAMBLE($ssockIPData)

	;Disconnect sockets with inappropriate response
	If StringLen($sockIPData) < "3" Then
		TCPSend($cSocket, @CRLF & "Buh bye!")
		TCPCloseSocket($cSocket)
	Else
		$cons = $cons + 1
		_ArrayInsert($cSocketArray, $cons, $cSocket)
		ReDim $cSocketArray[$max]

		_ArrayInsert($IPsoc, $cons, $sockIPData & "-" & $cSocket)
		ReDim $IPsoc[$max]

		$newIPsoclist = _ArrayToString($IPsoc, "|")
		GUICtrlSetData($ipsocketList, "")
		GUICtrlSetData($ipsocketList, $newIPsoclist)

		$dtNOW = @MON & "/" & @MDAY & "/" & @YEAR & " - " & @HOUR & ":" & @MIN & ":" & @SEC
		$readlog = GUICtrlRead($log)
		GUICtrlSetData($log, $dtNOW & " Socket " & $cSocket & " connected. " & @CRLF & $readlog)
	EndIf

EndIf



;Clean up disconnected sockets
For $i = 1 to $max - 1
	If $cSocketArray[$i] <> "" Then
		TCPSend($cSocketArray[$i], "")
		If @Error Then
			$readLog = GUICtrlRead($log)
			$dtNOW = @MON & "/" & @MDAY & "/" & @YEAR & " - " & @HOUR & ":" & @MIN & ":" & @SEC
			GUICtrlSetData($log, $dtNOW & " Socket " & $cSocketArray[$i] & " disconnected. " & @CRLF & $readlog)
			_ArrayDelete($cSocketArray, $i)
			$cons = $cons - 1
			ReDim $cSocketArray[$max]

			_ArrayDelete($IPsoc, $i)
			ReDim $IPsoc[$max]
			$newIPsoclist = _ArrayToString($IPsoc, "|")
			GUICtrlSetData($ipsocketList, "")
			GUICtrlSetData($ipsocketList, $newIPsoclist)
		EndIf
	EndIf
Next



;listen for movie request
For $i = 1 to $max - 1
	If $cSocketArray[$i] <> "" Then

		$srsData = TCPRecv($cSocketArray[$i], 500000)

		If $srsData <> "" Then
			$rsData = _UNSCRAMBLE($srsData)
			$parse = StringSplit($rsData, ",")

			If $parse[1] = "MOVREQ" Then
				$addcmd = ' -vvv "' & $mLocation & '\' & $parse[3] & '" --sout=#transcode{vcodec=mp4v,vb=1200,scale=1,acodec=mp4a,ab=128,channels=2}:duplicate{dst=std{access=udp,mux=ts,dst=' & $parse[2] & '}} vlc://quit'
				$fullcmd = $cmd & $addcmd
				$smProc = Run($fullcmd, "", @SW_MINIMIZE)
				$ssmProc = _SCRAMBLE($smProc)
				$locaSock = _ArraySearch($IPsoc, $parse[2], 0, 0, 0, True)
				$lSock = StringSplit($IPsoc[$locaSock], "-")
				TCPSend($lSock[2], "NEWPROC" & $ssmProc)
				$readlog = GUICtrlRead($log)
				$dtNOW = @MON & "/" & @MDAY & "/" & @YEAR & " - " & @HOUR & ":" & @MIN & ":" & @SEC
				GUICtrlSetData($log, $dtNOW & " Movie " & $parse[3] & " requested on " & $parse[2] & "," & $smProc & @CRLF & $readlog)

			ElseIf $parse[1] = "MOVSTOP" Then
				$readlog = GUICtrlRead($log)
				$dtNOW = @MON & "/" & @MDAY & "/" & @YEAR & " - " & @HOUR & ":" & @MIN & ":" & @SEC
				GUICtrlSetData($log, $dtNOW & " Movie " & $parse[4] & " for " & $parse[3] & " stopped," & $parse[2] & @CRLF & $readlog)
				If ProcessExists($parse[2]) Then
					ProcessClose($parse[2])
				EndIf
			Else
				MsgBox(0, "Oops", $rsData)
			EndIf
		EndIf
	EndIf
Next

$msg = GUIGetMsg()
Select

	Case $msg = $refresh
		$mediaList = _FileListToArray($mLocation, "*", 1)
		$mListSend = _ArrayToString($mediaList, "|", 1)
		$smListSend = _SCRAMBLE($mListSend)
		GUICtrlSetData($emList, "")
		GUICtrlSetData($emList, $mListSend)
		$dtNOW = @MON & "/" & @MDAY & "/" & @YEAR & " - " & @HOUR & ":" & @MIN & ":" & @SEC
		$readLog = GUICtrlRead($log)
		GUICtrlSetData($log, $dtNOW & " Refresh sent." & @CRLF & $readLog)

		For $i = 1 to $max - 1
			TCPSend($cSocketArray[$i], "NEWLIST" & $smListSend)
		Next

	Case $msg = $GUI_EVENT_CLOSE OR $msg = $exit
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

