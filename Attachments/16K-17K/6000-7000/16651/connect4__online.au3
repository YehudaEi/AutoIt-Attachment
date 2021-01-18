#Region converted Directives from C:\Documents and Settings\FrazerMcLean\My Documents\AutoIt\connect4\connect4 -online.au3.ini
#AutoIt3Wrapper_aut2exe=C:\Program Files\AutoIt3\beta\Aut2Exe\Aut2Exe.exe
#AutoIt3Wrapper_icon=C:\Program Files\AutoIt3\Icons\au3.ico
#AutoIt3Wrapper_outfile=E:\Documents and Settings\FrazerMcLean\My Documents\AutoIt\connect4\Connect4.exe
#AutoIt3Wrapper_Res_Description=Connect 4
#AutoIt3Wrapper_Res_Fileversion=1.0.0.0
#AutoIt3Wrapper_Res_Fileversion_AutoIncrement=n
#AutoIt3Wrapper_Res_LegalCopyright=Frazer McLean 2006
#AutoIt3Wrapper_Res_Field1Name=Thanks
#AutoIt3Wrapper_Res_Field1Value=Simucal, XxXFaNtA and everyone else who helped.
#AutoIt3Wrapper_Run_AU3Check=4
#EndRegion converted Directives from C:\Documents and Settings\FrazerMcLean\My Documents\AutoIt\connect4\connect4 -online.au3.ini
;
;===============================================================================
;
; Program Name:   Connect 4
; Description::    2 Player Connect 4 game
; Requirement(s):  AutoIt Beta
; Author(s):       RazerM
;
;===============================================================================
;
#include <GUIConstants.au3>
#include <table.au3>
#include <string.au3>
#include <inet.au3>
#include <guiedit.au3>
#include <IE.au3>
#include <array.au3>
#include <misc.au3>
#include <color.au3>
#NoTrayIcon

Global $USE_FAKE_CTRLID = 0
Global $FAKE_CTRLID
Global $red, $blue, $usr, $c_usr
Opt("GUIOnEventMode", 1)
$main = GUICreate("Connect 4", 600, 555)
$table = _GUICtrlCreateTable (10, 10, 7, 6, 50, 50)
For $y = 1 To 6
	For $x = 1 To 7
		GUICtrlSetOnEvent($table[$x][$y], "_EventHandler")
		GUICtrlSetData($table[$x][$y], "|")
	Next
Next
$stats = _GUICtrlCreateTable (465, 120, 3, 4, 40, 20)
TableSetData(2, 1, "  Red")
GUICtrlSetBkColor($stats[2][1], 0xff0000)
GUICtrlSetColor($stats[2][1], 0xffffff)
TableSetData(3, 1, "  Blue")
GUICtrlSetBkColor($stats[3][1], 0x0000ff)
GUICtrlSetColor($stats[3][1], 0xffffff)
TableMultiSetData(1, 2, 1, 4, "Wins|Losses|Draws")
TableMultiSetData(2, 2, 3, 4, 0)

$new = GUICtrlCreateButton("New Players", 465, 210, 127, 25)
GUICtrlSetOnEvent(-1, "_EventHandler")
$undobtn = GUICtrlCreateButton("Undo", 465, 240, 127, 25)
GUICtrlSetOnEvent(-1, "_EventHandler")
GUICtrlCreateLabel("Red Player:", 400, 13)
$redinput = GUICtrlCreateInput("", 470, 10, 120, -1, $ES_READONLY + $ES_CENTER)
GUICtrlSetBkColor(-1, 0xff0000)
GUICtrlSetColor($redinput, 0xffffff)
GUICtrlCreateLabel("Blue Player:", 400, 43)
$blueinput = GUICtrlCreateInput("", 470, 40, 120, -1, $ES_READONLY + $ES_CENTER)
GUICtrlSetBkColor(-1, 0x0000ff)
GUICtrlSetColor($blueinput, 0xffffff)
$turn = GUICtrlCreateInput("", 470, 70, 120, -1, $ES_READONLY + $ES_CENTER)
GUICtrlSetBkColor(-1, 0xbbffbb)
$presend = GUICtrlCreateInput("", 10, 450, 525, 20)
GUICtrlSetFont($presend, 10)
_IEErrorHandlerRegister()
$oIE = _IECreateEmbedded()
$GUI_IE = GUICtrlCreateObj($oIE, 10, 330, 525, 120)
_IENavigate($oIE, "about:blank")
_IEBodyWriteHTML($oIE, "<font color=#0000ff size=3>Welcome to Connect 4 Chat!</font><br>")
$sendbtn = GUICtrlCreateButton("Send", 540, 330, 50, 142, $BS_DEFPUSHBUTTON)
GUICtrlSetOnEvent(-1, "_EventHandler")
$boldO = GUICtrlCreateButton("Bold", 10, 490, 50, 25)
GUICtrlSetOnEvent(-1, "_EventHandler")
$boldC = GUICtrlCreateButton("/Bold", 10, 520, 50, 25)
GUICtrlSetOnEvent(-1, "_EventHandler")
$italicO = GUICtrlCreateButton("Italic", 65, 490, 50, 25)
GUICtrlSetOnEvent(-1, "_EventHandler")
$italicC = GUICtrlCreateButton("/Italic", 65, 520, 50, 25)
GUICtrlSetOnEvent(-1, "_EventHandler")
$underO = GUICtrlCreateButton("Underline", 120, 490, 60, 25)
GUICtrlSetOnEvent(-1, "_EventHandler")
$underC = GUICtrlCreateButton("/Underline", 120, 520, 60, 25)
GUICtrlSetOnEvent(-1, "_EventHandler")
$strikeO = GUICtrlCreateButton("Strikeout", 185, 490, 60, 25)
GUICtrlSetOnEvent(-1, "_EventHandler")
$strikeC = GUICtrlCreateButton("/Strikeout", 185, 520, 60, 25)
GUICtrlSetOnEvent(-1, "_EventHandler")
$colorO = GUICtrlCreateButton("Colour", 250, 490, 50, 25)
GUICtrlSetOnEvent(-1, "_EventHandler")
$colorC = GUICtrlCreateButton("/Colour", 250, 520, 50, 25)
GUICtrlSetOnEvent(-1, "_EventHandler")
$linkO = GUICtrlCreateButton("Link", 305, 490, 50, 25)
GUICtrlSetOnEvent(-1, "_EventHandler")
$linkC = GUICtrlCreateButton("/Link", 305, 520, 50, 25)
GUICtrlSetOnEvent(-1, "_EventHandler")
$marqueeO = GUICtrlCreateButton("Marquee", 360, 490, 60, 25)
GUICtrlSetOnEvent(-1, "_EventHandler")
$marqueeC = GUICtrlCreateButton("/Marquee", 360, 520, 60, 25)
GUICtrlSetOnEvent(-1, "_EventHandler")
$gradientO = GUICtrlCreateButton("Gradient", 425, 490, 60, 25)
GUICtrlSetOnEvent(-1, "_EventHandler")
$gradientC = GUICtrlCreateButton("/Gradient", 425, 520, 60, 25)
GUICtrlSetOnEvent(-1, "_EventHandler")
GUISetState()
$temp = WinGetPos("Connect 4")
$temp2 = PixelGetColor($temp[0] + 6, $temp[1] + 32)
$bkcolor = "0x" & StringTrimLeft(Hex($temp2), 2)
For $y = 1 To 6
	For $x = 1 To 7
		GUICtrlSetColor($table[$x][$y], $bkcolor)
	Next
Next

;---------------
Opt("GUIOnEventMode", 0)
GUICreate("Game Type", 250, 100, -1, -1, $GUI_SS_DEFAULT_GUI, 0, $main)
GUICtrlCreateLabel("What type of game would you like.", 40, 10)
$timerLabel = GUICtrlCreateLabel("Closing in 5.0 seconds", 5, 85)
$gametype = _GuiCtrlCreateButtonsCentered("Local,Online", 250, 45, 80, 25)
$online = $gametype[1]
$local = $gametype[0]
GUISetState()

Global $old = ""
Global $CONNECT4_CLIENT = 0
Global $CONNECT4_HOST = 1
Global $CONNECT4_LOCAL = 2
Local $iMSLeft = 5000, $timer = TimerInit(), $time, $oldtime
While 1
	$time = TimerDiff($timer)
	$time = StringFormat("%.1f", (5000 - $time) / 1000)
	If $time <> $oldtime Then
		If $time <= 0 Then
			GUICtrlSetData($timerLabel, "Auto Selecting Local")
			Sleep(1000)
			$host = $CONNECT4_LOCAL
			ExitLoop
		Else
			GUICtrlSetData($timerLabel, "Closing in " & $time & " seconds")
			$oldtime = $time
		EndIf
	EndIf
	$msg = GUIGetMsg()
	If $msg = $online Then
		$answer = MsgBox(4, "Online Game", "Would you like to Host a game?")
		If $answer = 6 Then
			$host = $CONNECT4_HOST
			ExitLoop
		Else
			$host = $CONNECT4_CLIENT
			ExitLoop
		EndIf
	ElseIf $msg = $local Then
		$host = $CONNECT4_LOCAL
		ExitLoop
	EndIf
WEnd
GUIDelete()
GUISwitch($main)
Opt("GUIOnEventMode", 1)
If $host <> $CONNECT4_LOCAL Then GUICtrlSetState($undobtn, $GUI_DISABLE)
;---------------
$port = 33891
If $host = $CONNECT4_HOST Then
	TCPStartup()
	$listen = TCPListen(@IPAddress1, $port)
	$gametype2 = _MsgBoxChangeButtons(4, "Game Type", "What type of game is it?", "LAN", "Internet")
	If $gametype2 = 6 Then
		MsgBox(0, "Waiting Opponent", "Your ip is " & @IPAddress1 & @CRLF & "Press Ok to wait for opponent")
	Else
		MsgBox(64, "Please Note", "Connect 4 may take some time to connect to the internet," & @CRLF & "Please wait for the next message box.")
		Ping("www.google.com")
		If @error Then
			MsgBox(16, "Error", "You are not connected to the internet" & @CRLF & "Connect 4 will now close")
			Exit
		EndIf
		MsgBox(0, "Waiting Opponent", "Your ip is " & _GetIP() & @CRLF & "Press Ok to wait for opponent" & _
				@CRLF & "If you are behind a router you will need to forward port " & $port & " to " & @IPAddress1)
	EndIf
	If $listen = -1 Then
		MsgBox(0, "Error", "TCPListen Failed")
		Exit
	EndIf
	Dim $opponent = -1
	Opt("GUIOnEventMode", 0)
	GUICreate("Waiting for opponent", 200, 50)
	$waituser = _GUICtrlProgressMarqueeCreate(10, 10, 180, 30)
	_GUICtrlProgressSetMarquee($waituser)
	GUISetState()
	$exit = 0
	Do
		If GUIGetMsg() = $GUI_EVENT_CLOSE Then $exit = MsgBox(4, "Exit", "Do you want to abort multiplayer?")
		If $exit = 6 Then Exit
		$opponent = TCPAccept($listen)
	Until $opponent <> -1
	GUIDelete()
	GUISwitch($main)
	Opt("GUIOnEventMode", 1)
	Dim $oppip = SocketToIP($opponent)
	Dim $recv
EndIf
GUISetOnEvent($GUI_EVENT_CLOSE, "_EventHandler")
$color = "r"
$oldcolor = 0
$game = 0
$undo = 0
If $host = $CONNECT4_HOST Then
	$recv = TCPRecv($opponent, 2048)
	While StringLeft($recv, 3) <> "USR"
		$recv = TCPRecv($opponent, 2048)
	WEnd
	$usr = InputBox("Username", "Please enter a username, you are the red player", "", " M")
	WinSetTitle($main, "", "Connect 4 - " & $usr)
	$oppusr = StringTrimLeft($recv, 3)
	MsgBox(0, "Opponent", "The opponent (" & $oppusr & ") has connected on IP " & $oppip)
	TCPSend($opponent, "USR" & $usr)
ElseIf $host = $CONNECT4_CLIENT Then
	TCPStartup()
	$c_oppip = InputBox("Opponents IP", "What is your opponent's Ip Address?" & @CRLF & "Please make sure the host has started the game before you click ok.", "", " M", 400, 150)
	While IsValidIP($c_oppip) = 0
		$c_oppip = InputBox("Opponents IP", "What is your opponent's Ip Address?" & @CRLF & "Please make sure the host has started the game before you click ok.", "", " M", 400, 150)
	WEnd
	$c_usr = InputBox("Username", "Please enter a username, you are the blue player", "", " M")
	WinSetTitle($main, "", "Connect 4 - " & $c_usr)
	Dim $c_opponent = -1
	$c_opponent = TCPConnect($c_oppip, $port)
	Dim $c_data
	TCPSend($c_opponent, "USR" & $c_usr)
	$c_recv = ""
	Dim $opponent = -1
	Opt("GUIOnEventMode", 0)
	GUICreate("Waiting for opponent", 200, 50)
	$waituser = _GUICtrlProgressMarqueeCreate(10, 10, 180, 30)
	_GUICtrlProgressSetMarquee($waituser)
	GUISetState()
	$exit = 0
	Do
		$c_recv = TCPRecv($c_opponent, 2048)
		If GUIGetMsg() = $GUI_EVENT_CLOSE Then $exit = MsgBox(4, "Exit", "Do you want to abort multiplayer?")
		If $exit = 6 Then Exit
	Until StringLeft($c_recv, 3) = "USR"
	GUIDelete()
	GUISwitch($main)
	Opt("GUIOnEventMode", 1)
	$c_oppusr = StringTrimLeft($c_recv, 3)
	MsgBox(0, "Opponent", "The opponent (" & $c_oppusr & ") has connected on IP " & $c_oppip)
EndIf

While 1
	If $color <> $oldcolor Then
		If $color = "b" Then GUICtrlSetData($turn, "Blue Player's Turn")
		If $color = "r" Then GUICtrlSetData($turn, "Red Player's Turn")
	EndIf
	$oldcolor = $color
	If $host = $CONNECT4_HOST Then
		$recv = TCPRecv($opponent, 2048)
		If StringLeft($recv, 4) = "MOVE" Then
			$fakemsg = StringSplit(StringTrimLeft($recv, 4), "|")
			If GUICtrlRead($table[$fakemsg[1]][$fakemsg[2]]) = "" Then
				$USE_FAKE_CTRLID = 1
				$FAKE_CTRLID = $table[$fakemsg[1]][$fakemsg[2]]
				_EventHandler()
			EndIf
		ElseIf StringLeft($recv, 4) = "EXIT" Then
			MsgBox(0, "Quit", $oppusr & " has left the game")
			Exit
		ElseIf StringLeft($recv, 4) = "CHAT" Then
			$old = _IEBodyReadHTML($oIE)
			_IEBodyWriteHTML($oIE, $old & $oppusr & ": " & StringTrimLeft($recv, 4) & "<br>")
		EndIf
		If $game = 0 Then
			GUICtrlSetData($redinput, $usr)
			GUICtrlSetData($blueinput, $oppusr)
			GUICtrlSetData($turn, "Red Player's Turn")
			$col = 0
			For $col = 1 To 6
				For $row = 1 To 7
					SetFilled($row, $col, 0x00ff00)
					Sleep(25)
				Next
			Next
			For $row = 1 To 7
				For $col = 1 To 6
					SetFilled($row, $col, $bkcolor)
					Sleep(25)
				Next
			Next
			TableMultiSetData(2, 2, 3, 4, 0)
			$game = 1
			$color = "r"
		EndIf
	ElseIf $host = $CONNECT4_CLIENT Then
		$c_recv = TCPRecv($c_opponent, 2048)
		If StringLeft($c_recv, 4) = "MOVE" Then
			$fakemsg = StringSplit(StringTrimLeft($c_recv, 4), "|")
			If GUICtrlRead($table[$fakemsg[1]][$fakemsg[2]]) = "" Then
				$USE_FAKE_CTRLID = 1
				$FAKE_CTRLID = $table[$fakemsg[1]][$fakemsg[2]]
				_EventHandler()
			EndIf
		ElseIf StringLeft($c_recv, 4) = "EXIT" Then
			MsgBox(0, "Quit", $c_oppusr & " has left the game")
			Exit
		ElseIf StringLeft($c_recv, 4) = "CHAT" Then
			$old = _IEBodyReadHTML($oIE)
			_IEBodyWriteHTML($oIE, $old & $c_oppusr & ": " & StringTrimLeft($c_recv, 4) & "<br>")
		EndIf
		If $game = 0 Then
			GUICtrlSetData($redinput, $c_oppusr)
			GUICtrlSetData($blueinput, $c_usr)
			GUICtrlSetData($turn, "Red Player's Turn")
			$col = 0
			For $col = 1 To 6
				For $row = 1 To 7
					SetFilled($row, $col, 0x00ff00)
					Sleep(25)
				Next
			Next
			For $row = 1 To 7
				For $col = 1 To 6
					SetFilled($row, $col, $bkcolor)
					Sleep(25)
				Next
			Next
			TableMultiSetData(2, 2, 3, 4, 0)
			$game = 1
			$color = "r"
		EndIf
	EndIf
	Sleep(50)
WEnd

Func IsValidIP($ipAddr)
	$split = StringSplit($ipAddr, ".")
	If $split[0] <> 4 Then Return 0
	If StringLen($split[1]) > 3 Then Return 0
	If StringLen($split[1]) < 1 Then Return 0
	If StringLen($split[2]) > 3 Then Return 0
	If StringLen($split[2]) < 1 Then Return 0
	If StringLen($split[3]) > 3 Then Return 0
	If StringLen($split[3]) < 1 Then Return 0
	If StringLen($split[4]) > 3 Then Return 0
	If StringLen($split[4]) < 1 Then Return 0
	Return 1
EndFunc   ;==>IsValidIP

Func Undo($undo)
	$coord = StringSplit($undo, ",")
	If $coord[0] = 1 Then Return 0
	AnimateUp($coord[1], $coord[2], SwapColor($color))
EndFunc   ;==>Undo

Func CheckDraw()
	$counter = 0
	For $row = 1 To 7
		For $col = 1 To 6
			If GUICtrlRead($table[$row][$col]) = "r" Then $counter += 1
			If GUICtrlRead($table[$row][$col]) = "b" Then $counter += 1
		Next
	Next
	If $counter = 42 Then Return 1
EndFunc   ;==>CheckDraw
Func AnimateUp($row, $col, $color)
	For $col2 = $col To 1 Step - 1
		If $col2 <= $col Then SetFilled($row, $col2 - 1, $color)
		SetFilled($row, $col2, $bkcolor)
		Sleep(25)
	Next
EndFunc   ;==>AnimateUp

Func AnimateDown($row, $col, $color)
	For $col2 = 1 To $col
		If $col2 >= 1 Then SetFilled($row, $col2 - 1, $bkcolor)
		SetFilled($row, $col2, $color)
		Sleep(25)
	Next
EndFunc   ;==>AnimateDown

Func CheckFour($row, $col, $color)
	Dim $filled = 0, $ignore = 0, $colors
	;horizontal
	For $row2 = $row - 3 To $row + 3
		$ignore = 0
		If $row2 > 7 Then $ignore = 1
		If $row2 < 1 Then $ignore = 1
		If $ignore = 0 Then
			$colors &= GUICtrlRead($table[$row2][$col])
		EndIf
	Next
	If StringInStr($colors, _StringRepeat($color, 4)) <> 0 Then Return 1
	$colors = ""
	
	;vertical
	For $col2 = $col - 3 To $col + 3
		$ignore = 0
		If $col2 > 6 Then $ignore = 1
		If $col2 < 1 Then $ignore = 1
		If $ignore = 0 Then
			$colors &= GUICtrlRead($table[$row][$col2])
		EndIf
	Next
	If StringInStr($colors, _StringRepeat($color, 4)) <> 0 Then Return 1
	$colors = ""
	
	;diagonal top right
	$row2 = $row - 3
	For $col2 = $col + 3 To $col - 3 Step - 1
		$ignore = 0
		If $col2 > 6 Then $ignore = 1
		If $col2 < 1 Then $ignore = 1
		If $row2 > 7 Then $ignore = 1
		If $row2 < 1 Then $ignore = 1
		If $ignore = 0 Then
			$colors &= GUICtrlRead($table[$row2][$col2])
		EndIf
		If $row2 = $row + 3 Then ExitLoop
		$row2 += 1
	Next
	If StringInStr($colors, _StringRepeat($color, 4)) <> 0 Then Return 1
	$colors = ""
	
	;diagonal top left
	$row2 = $row + 3
	For $col2 = $col + 3 To $col - 3 Step - 1
		$ignore = 0
		If $col2 > 6 Then $ignore = 1
		If $col2 < 1 Then $ignore = 1
		If $row2 > 7 Then $ignore = 1
		If $row2 < 1 Then $ignore = 1
		If $ignore = 0 Then
			$colors &= GUICtrlRead($table[$row2][$col2])
		EndIf
		If $row2 = $row - 3 Then ExitLoop
		$row2 -= 1
	Next
	If StringInStr($colors, _StringRepeat($color, 4)) <> 0 Then Return 1
	$colors = ""
EndFunc   ;==>CheckFour


Func SetFilled($row, $col, $color)
	If StringLen($color) = 1 Then
		GUICtrlSetColor($table[$row][$col], GetColour($color))
		GUICtrlSetBkColor($table[$row][$col], GetColour($color))
	Else
		GUICtrlSetColor($table[$row][$col], $color)
		GUICtrlSetBkColor($table[$row][$col], $color)
	EndIf
	GUICtrlSetData($table[$row][$col], $color)
	If StringLen($color) > 1 Then GUICtrlSetData($table[$row][$col], "")
EndFunc   ;==>SetFilled

Func SwapColor($color)
	If $color = "r" Then
		$color = "b"
	Else
		$color = "r"
	EndIf
	Return $color
EndFunc   ;==>SwapColor

Func ShrtColour($string)
	Return StringTrimLeft(StringTrimRight($string, 5), 2)
EndFunc   ;==>ShrtColour

Func GetColour($string)
	If $string = "r" Then Return 0xff0000
	If $string = "b" Then Return 0x0000ff
EndFunc   ;==>GetColour

Func NumOfOccurences($string, $substring)
	StringReplace($string, $substring, "")
	Return @extended
EndFunc   ;==>NumOfOccurences

Func TableSetData($row, $col, $data)
	GUICtrlSetData($stats[$row][$col], $data)
EndFunc   ;==>TableSetData

Func TableReset()
	For $row = 1 To 7
		For $col = 1 To 6
			SetFilled($row, $col, $bkcolor)
			GUICtrlSetData($table[$row][$col], "|")
		Next
	Next
EndFunc   ;==>TableReset

Func TableMultiSetData($row, $col, $endrow, $endcol, $data)
	If StringInStr($data, "|") <> 0 Then
		$sData = StringSplit($data, "|")
		$numdata = 1
		For $row2 = $row To $endrow
			For $col2 = $col To $endcol
				GUICtrlSetData($stats[$row2][$col2], $sData[$numdata])
				$numdata += 1
			Next
		Next
	Else
		For $row2 = $row To $endrow
			For $col2 = $col To $endcol
				GUICtrlSetData($stats[$row2][$col2], $data)
			Next
		Next
	EndIf
EndFunc   ;==>TableMultiSetData

Func AddWin($type)
	If $type = "r" Then
		$oldwin = GUICtrlRead($stats[2][2])
		GUICtrlSetData($stats[2][2], $oldwin + 1)
		GUICtrlSetData($stats[3][3], $oldwin + 1)
	Else
		$oldwin = GUICtrlRead($stats[2][3])
		GUICtrlSetData($stats[2][3], $oldwin + 1)
		GUICtrlSetData($stats[3][2], $oldwin + 1)
	EndIf
EndFunc   ;==>AddWin

Func AddDraw()
	$olddraw = GUICtrlRead($stats[2][4])
	GUICtrlSetData($stats[2][4], $olddraw + 1)
	GUICtrlSetData($stats[3][4], $olddraw + 1)
EndFunc   ;==>AddDraw

Func _GuiCtrlCreateButtonsCentered($text, $guiwidth, $top, $width, $height, $gap = 5, $delim = ",")
	$btntext = StringSplit($text, $delim)
	$totalwidth = ($width * $btntext[0]) + ($gap * ($btntext[0] - 1))
	Dim $buttons[$btntext[0] + 1]
	For $i = 1 To $btntext[0]
		$buttons[$i - 1] = GUICtrlCreateButton($btntext[$i], ($guiwidth / 2) - ($totalwidth / 2) + ($width * ($i - 1)) + ($gap * ($i - 1)), $top, $width, $height)
	Next
	Return $buttons
EndFunc   ;==>_GuiCtrlCreateButtonsCentered

Func SocketToIP($SHOCKET)
	Local $sockaddr = DllStructCreate("short;ushort;uint;char[8]")

	Local $aRet = DllCall("Ws2_32.dll", "int", "getpeername", "int", $SHOCKET, _
			"ptr", DllStructGetPtr($sockaddr), "int_ptr", DllStructGetSize($sockaddr))
	If Not @error And $aRet[0] = 0 Then
		$aRet = DllCall("Ws2_32.dll", "str", "inet_ntoa", "int", DllStructGetData($sockaddr, 3))
		If Not @error Then $aRet = $aRet[0]
	Else
		$aRet = 0
	EndIf

	$sockaddr = 0

	Return $aRet
EndFunc   ;==>SocketToIP

Func _MsgBoxChangeButtons($iMBFlag, $MBTitle, $MBText, $MBButton1, $MBButton2 = '', $MBButton3 = '', $iMBTimeOut = 0)
	Local $MBFile = FileOpen(@TempDir & '\MiscMBCB.au3', 2)
	Local $MBLine1 = 'Opt("WinWaitDelay", 0)'
	Local $MBLine2 = 'WinWait("' & $MBTitle & '")'
	Local $MBLine3 = 'ControlSetText("' & $MBTitle & '", "", "Button1", "' & $MBButton1 & '")'
	Local $MBLine4 = 'ControlSetText("' & $MBTitle & '", "", "Button2", "' & $MBButton2 & '")'
	Local $MBLine5 = 'ControlSetText("' & $MBTitle & '", "", "Button3", "' & $MBButton3 & '")'
	If $MBButton2 = '' Then
		FileWrite(@TempDir & '\MiscMBCB.au3', $MBLine1 & @CRLF & $MBLine2 & @CRLF & $MBLine3)
	ElseIf $MBButton2 <> '' And $MBButton3 = '' Then
		FileWrite(@TempDir & '\MiscMBCB.au3', $MBLine1 & @CRLF & $MBLine2 & _
				@CRLF & $MBLine3 & @CRLF & $MBLine4)
	ElseIf $MBButton2 <> '' And $MBButton3 <> '' Then
		FileWrite(@TempDir & '\MiscMBCB.au3', $MBLine1 & @CRLF & $MBLine2 & @CRLF & _
				$MBLine3 & @CRLF & $MBLine4 & @CRLF & $MBLine5)
	EndIf
	$MBPID1 = Run('"' & @AutoItExe & '" /AutoIt3ExecuteScript ' & @TempDir & '\MiscMBCB.au3')
	$MBBox = MsgBox($iMBFlag, $MBTitle, $MBText, $iMBTimeOut)
	FileClose($MBFile)
	Do
		FileDelete(@TempDir & '\MiscMBCB.au3')
	Until Not FileExists(@TempDir & '\MiscMBCB.au3')
	Return $MBBox
EndFunc   ;==>_MsgBoxChangeButtons

;===============================================================================
;
; Function Name:    _GUICtrlProgressMarqueeCreate()
; Description:    Creates a marquee sytle progress control
; Parameter(s):  $i_Left    - The left side of the control
;               $i_Top  - The top of the control
;               $i_Width   - Optional: The width of the control
;               $i_Height  - Optional: The height of the control
; Requirement(s):   AutoIt3 Beta and Windows XP or later
; Return Value(s):  On Success - Returns the identifier (controlID) of the new control
;               On Failure - Returns 0  and sets @ERROR = 1
; Author(s):        Bob Anthony
;
;===============================================================================
;
Func _GUICtrlProgressMarqueeCreate($i_Left, $i_Top, $i_Width = Default, $i_Height = Default)

	Local Const $PBS_MARQUEE = 0x08

	Local $v_Style = $PBS_MARQUEE

	Local $h_Progress = GUICtrlCreateProgress($i_Left, $i_Top, $i_Width, $i_Height, $v_Style)
	If $h_Progress = 0 Then
		SetError(1)
		Return 0
	Else
		SetError(0)
		Return $h_Progress
	EndIf

EndFunc   ;==>_GUICtrlProgressMarqueeCreate

;===============================================================================
;
; Function Name:    _GUICtrlProgressSetMarquee()
; Description:    Sets marquee sytle for a progress control
; Parameter(s):  $h_Progress  - The control identifier (controlID)
;               $f_Mode        - Optional: Indicates whether to turn the marquee mode on or off
;                           0 = turn marquee mode off
;                           1 = (Default) turn marquee mode on
;               $i_Time        - Optional: Time in milliseconds between marquee animation updates
;                           Default is 100 milliseconds
; Requirement(s):   AutoIt3 Beta and Windows XP or later
; Return Value(s):  On Success - Returns whether marquee mode is set
;               On Failure - Returns 0  and sets @ERROR = 1
; Author(s):        Bob Anthony
;
;===============================================================================
;
Func _GUICtrlProgressSetMarquee($h_Progress, $f_Mode = 1, $i_Time = 100)

	Local Const $WM_USER = 0x0400
	Local Const $PBM_SETMARQUEE = ($WM_USER + 10)

	Local $var = GUICtrlSendMsg($h_Progress, $PBM_SETMARQUEE, $f_Mode, Number($i_Time))
	If $var = 0 Then
		SetError(1)
		Return 0
	Else
		SetError(0)
		Return $var
	EndIf
EndFunc   ;==>_GUICtrlProgressSetMarquee

Func FormatChat(ByRef $sText)
	$sText = StringReplace($sText, "<", "&lt;") ;no user tags
	$sText = StringReplace($sText, ">", "&gt;")
	
	$sText = StringReplace($sText, @CRLF, "<br>")
	$sText = StringRegExpReplace($sText, "\[i\](.+?)\[/i\]", "<i>\1</i>")
	$sText = StringRegExpReplace($sText, "\[b\](.+?)\[/b\]", "<b>\1</b>")
	$sText = StringRegExpReplace($sText, "\[u\](.+?)\[/u\]", "<u>\1</u>")
	$sText = StringRegExpReplace($sText, "\[s\](.+?)\[/s\]", "<s>\1</s>")
	;lets parse gradient text :D
	While 1
		If StringRegExp($sText, "\[c=#[0-9a-fA-F]{6}\](.+)\[/c=#[0-9a-fA-F]{6}\]", 0) Then
			Local $asText = StringSplit($sText, "")
			Local $iPos = StringInStr($sText, "[c=#")
			$iPos += 4 ;beginning of six digit hex colour
			Local $iStartColor = "0x", $sGradientText = "", $asGradientText = ""
			Local $aGradient = "", $iEndColor = "0x", $skip = False, $sFormatted = ""
			Local $iRed, $iGreen, $iBlue
			If $asText[$iPos + 6] = "]" Then
				For $i = $iPos To $iPos + 5
					$iStartColor &= $asText[$i]
				Next
				$iPos = $i + 1 ;skip ]
				
				While Not __ArrayCharMatch($asText, $iPos, "[/c=#")
					If @error Then
						$skip = True
						ExitLoop
					EndIf
					$sGradientText &= $asText[$iPos]
					$iPos += 1
				WEnd
				$asGradientText = StringSplit($sGradientText, "")
				If $asText[$iPos + 4] = "#" And $asText[$iPos + 11] = "]" And $skip = False Then
					$iPos += 5
					For $i = $iPos To $iPos + 5
						$iEndColor &= $asText[$i]
					Next
					$aGradient = __ColorGradient($iStartColor, $iEndColor, $asGradientText[0])
					For $i = 1 To $asGradientText[0]
						$iRed = Hex(_ColorGetRed($aGradient[$i - 1]), 2)
						$iGreen = Hex(_ColorGetGreen($aGradient[$i - 1]), 2)
						$iBlue = Hex(_ColorGetBlue($aGradient[$i - 1]), 2)
						$aGradient[$i - 1] = $iRed & $iGreen & $iBlue
						$sFormatted &= '<font color="' & $aGradient[$i - 1] & '">' & $asGradientText[$i] & '</font>'
					Next
					$sText = StringReplace($sText, "[c=#" & StringTrimLeft($iStartColor, 2) & "]" & $sGradientText & "[/c=#" & StringTrimLeft($iEndColor, 2) & "]", $sFormatted, 1)
				EndIf
			EndIf
		Else
			ExitLoop
		EndIf
	WEnd
	$sText = StringRegExpReplace($sText, "\[c=(.+?)\](.+?)\[/c\]", '<font color="\1">\2</font>')
	$sText = StringRegExpReplace($sText, "\[l=(.+?)\](.+?)\[/l\]", '<a target="_blank" href="\1">\2</a>')
	$sText = StringRegExpReplace($sText, "\[m\](.+)\[/m\]", "<marquee width=100% height=30>\1</marquee>")
EndFunc   ;==>FormatChat

Func __ArrayCharMatch($avArray, $iCounter, $svMatch)
	Local $sText
	For $i = $iCounter To $iCounter + StringLen($svMatch) - 1
		If $i >= UBound($avArray) - 1 Then Return SetError(1, 0, 0)
		$sText &= $avArray[$i]
	Next
	If $sText = $svMatch Then Return 1
EndFunc   ;==>__ArrayCharMatch

;CoePSX - Thanks!
Func __ColorGradient($hInitialColor, $hFinalColor, $iReturnSize)
	$hInitialColor = Hex($hInitialColor, 6)
	$hFinalColor = Hex($hFinalColor, 6)

	Local $iRed1 = Dec(StringLeft($hInitialColor, 2))
	Local $iGreen1 = Dec(StringMid($hInitialColor, 3, 2))
	Local $iBlue1 = Dec(StringMid($hInitialColor, 5, 2))

	Local $iRed2 = Dec(StringLeft($hFinalColor, 2))
	Local $iGreen2 = Dec(StringMid($hFinalColor, 3, 2))
	Local $iBlue2 = Dec(StringMid($hFinalColor, 5, 2))

	Local $iPlusRed = ($iRed2 - $iRed1) / ($iReturnSize - 1)
	Local $iPlusBlue = ($iBlue2 - $iBlue1) / ($iReturnSize - 1)
	Local $iPlusGreen = ($iGreen2 - $iGreen1) / ($iReturnSize - 1)

	Dim $iColorArray[$iReturnSize]
	For $i = 0 To $iReturnSize - 1
		$iNowRed = Floor($iRed1 + ($iPlusRed * $i))
		$iNowBlue = Floor($iBlue1 + ($iPlusBlue * $i))
		$iNowGreen = Floor($iGreen1 + ($iPlusGreen * $i))
		$iColorArray[$i] = Dec(Hex($iNowRed, 2) & Hex($iNowGreen, 2) & Hex($iNowBlue, 2))
	Next
	Return $iColorArray
EndFunc   ;==>__ColorGradient

Func _EventHandler()
	If $USE_FAKE_CTRLID = 1 Then
		$msg = $FAKE_CTRLID
	Else
		$msg = @GUI_CtrlId
	EndIf
	Switch $msg
		Case $GUI_EVENT_CLOSE
			If $host = $CONNECT4_CLIENT Then
				TCPSend($c_opponent, "EXIT")
			ElseIf $host = $CONNECT4_HOST Then
				TCPSend($opponent, "EXIT")
			EndIf
			TCPShutdown()
			Exit
		Case $new
			$red = InputBox("Red Player", "What is your name?", "", " M")
			$blue = InputBox("Blue Player", "What is your name?", "", " M")
			GUICtrlSetData($redinput, $red)
			GUICtrlSetData($blueinput, $blue)
			GUICtrlSetData($turn, "Red Player's Turn")
			$col = 0
			For $col = 1 To 6
				For $row = 1 To 7
					SetFilled($row, $col, 0x00ff00)
					Sleep(15)
				Next
			Next
			For $row = 1 To 7
				For $col = 1 To 6
					SetFilled($row, $col, $bkcolor)
					Sleep(15)
				Next
			Next
			TableMultiSetData(2, 2, 3, 4, 0)
			$game = 1
			$color = "r"
		Case $undobtn
			Undo($undo)
			$color = SwapColor($color)
			If $color = "b" Then GUICtrlSetData($turn, "Blue Player's Turn")
			If $color = "r" Then GUICtrlSetData($turn, "Red Player's Turn")
			GUICtrlSetState($undobtn, $GUI_DISABLE)
		Case $sendbtn
			If $host = $CONNECT4_HOST Then
				$tosend = GUICtrlRead($presend)
				$old = _IEBodyReadHTML($oIE)
				FormatChat($tosend)
				TCPSend($opponent, "CHAT" & $tosend)
				_IEBodyWriteHTML($oIE, $old & $usr & ": " & $tosend & "<br>")
				$iDocHeight = $oIE.document.body.scrollHeight
				$oIE.document.parentWindow.scrollTo (0, $iDocHeight)
				GUICtrlSetData($presend, "")
			ElseIf $host = $CONNECT4_CLIENT Then
				$tosend = GUICtrlRead($presend)
				$old = _IEBodyReadHTML($oIE)
				FormatChat($tosend)
				TCPSend($c_opponent, "CHAT" & $tosend)
				_IEBodyWriteHTML($oIE, $old & $c_usr & ": " & $tosend & "<br>")
				$iDocHeight = $oIE.document.body.scrollHeight
				$oIE.document.parentWindow.scrollTo (0, $iDocHeight)
				GUICtrlSetData($presend, "")
			Else
				$tosend = GUICtrlRead($presend)
				$old = _IEBodyReadHTML($oIE)
				FormatChat($tosend)
				_IEBodyWriteHTML($oIE, $old & "User" & ": " & $tosend & "<br>")
				$iDocHeight = $oIE.document.body.scrollHeight
				$oIE.document.parentWindow.scrollTo (0, $iDocHeight)
				GUICtrlSetData($presend, "")
			EndIf
		Case $boldO
			$sel = _GUICtrlEditGetSel($presend)
			$oldtxt = GUICtrlRead($presend)
			If $sel[1] = $sel[2] Then ;no selection
				_GUICtrlEditReplaceSel($presend, True, "[b]")
			Else ;selection
				_GUICtrlEditReplaceSel($presend, True, "[b]" & StringMid($oldtxt, $sel[1] + 1, $sel[2] - $sel[1]) & "[/b]")
			EndIf
		Case $boldC
			$sel = _GUICtrlEditGetSel($presend)
			$oldtxt = GUICtrlRead($presend)
			If $sel[1] = $sel[2] Then ;no selection
				_GUICtrlEditReplaceSel($presend, True, "[/b]")
			Else ;selection
				_GUICtrlEditReplaceSel($presend, True, "[b]" & StringMid($oldtxt, $sel[1] + 1, $sel[2] - $sel[1]) & "[/b]")
			EndIf
		Case $italicO
			$sel = _GUICtrlEditGetSel($presend)
			$oldtxt = GUICtrlRead($presend)
			If $sel[1] = $sel[2] Then ;no selection
				_GUICtrlEditReplaceSel($presend, True, "[i]")
			Else ;selection
				_GUICtrlEditReplaceSel($presend, True, "[i]" & StringMid($oldtxt, $sel[1] + 1, $sel[2] - $sel[1]) & "[/i]")
			EndIf
		Case $italicC
			$sel = _GUICtrlEditGetSel($presend)
			$oldtxt = GUICtrlRead($presend)
			If $sel[1] = $sel[2] Then ;no selection
				_GUICtrlEditReplaceSel($presend, True, "[/i]")
			Else ;selection
				_GUICtrlEditReplaceSel($presend, True, "[i]" & StringMid($oldtxt, $sel[1] + 1, $sel[2] - $sel[1]) & "[/i]")
			EndIf
		Case $underO
			$sel = _GUICtrlEditGetSel($presend)
			$oldtxt = GUICtrlRead($presend)
			If $sel[1] = $sel[2] Then ;no selection
				_GUICtrlEditReplaceSel($presend, True, "[u]")
			Else ;selection
				_GUICtrlEditReplaceSel($presend, True, "[u]" & StringMid($oldtxt, $sel[1] + 1, $sel[2] - $sel[1]) & "[/u]")
			EndIf
		Case $underC
			$sel = _GUICtrlEditGetSel($presend)
			$oldtxt = GUICtrlRead($presend)
			If $sel[1] = $sel[2] Then ;no selection
				_GUICtrlEditReplaceSel($presend, True, "[/u]")
			Else ;selection
				_GUICtrlEditReplaceSel($presend, True, "[u]" & StringMid($oldtxt, $sel[1] + 1, $sel[2] - $sel[1]) & "[/u]")
			EndIf
		Case $strikeO
			$sel = _GUICtrlEditGetSel($presend)
			$oldtxt = GUICtrlRead($presend)
			If $sel[1] = $sel[2] Then ;no selection
				_GUICtrlEditReplaceSel($presend, True, "[s]")
			Else ;selection
				_GUICtrlEditReplaceSel($presend, True, "[s]" & StringMid($oldtxt, $sel[1] + 1, $sel[2] - $sel[1]) & "[/s]")
			EndIf
		Case $strikeC
			$sel = _GUICtrlEditGetSel($presend)
			$oldtxt = GUICtrlRead($presend)
			If $sel[1] = $sel[2] Then ;no selection
				_GUICtrlEditReplaceSel($presend, True, "[/s]")
			Else ;selection
				_GUICtrlEditReplaceSel($presend, True, "[s]" & StringMid($oldtxt, $sel[1] + 1, $sel[2] - $sel[1]) & "[/s]")
			EndIf
		Case $linkO
			$sel = _GUICtrlEditGetSel($presend)
			$oldtxt = GUICtrlRead($presend)
			$link = InputBox("Link", "Please enter the URL below", "http://")
			If $sel[1] = $sel[2] Then ;no selection
				_GUICtrlEditReplaceSel($presend, True, "[l=" & $link & "]")
			Else ;selection
				_GUICtrlEditReplaceSel($presend, True, "[l=" & $link & "]" & StringMid($oldtxt, $sel[1] + 1, $sel[2] - $sel[1]) & "[/l]")
			EndIf
		Case $linkC
			$sel = _GUICtrlEditGetSel($presend)
			$oldtxt = GUICtrlRead($presend)
			
			If $sel[1] = $sel[2] Then ;no selection
				_GUICtrlEditReplaceSel($presend, True, "[/l]")
			Else ;selection
				$link = InputBox("Link", "Please enter the URL below", "http://")
				_GUICtrlEditReplaceSel($presend, True, "[l=" & $link & "]" & StringMid($oldtxt, $sel[1] + 1, $sel[2] - $sel[1]) & "[/l]")
			EndIf
		Case $colorO
			$sel = _GUICtrlEditGetSel($presend)
			$oldtxt = GUICtrlRead($presend)
			$chosencolor = "#" & StringTrimLeft(_ChooseColor(2, 8355711), 2)
			If $sel[1] = $sel[2] Then ;no selection
				_GUICtrlEditReplaceSel($presend, True, "[c=" & $chosencolor & "]")
			Else ;selection
				_GUICtrlEditReplaceSel($presend, True, "[c=" & $chosencolor & "]" & StringMid($oldtxt, $sel[1] + 1, $sel[2] - $sel[1]) & "[/c]")
			EndIf
		Case $colorC
			$sel = _GUICtrlEditGetSel($presend)
			$oldtxt = GUICtrlRead($presend)
			If $sel[1] = $sel[2] Then ;no selection
				_GUICtrlEditReplaceSel($presend, True, "[/c]")
			Else ;selection
				$chosencolor = "#" & StringTrimLeft(_ChooseColor(2, 8355711), 2)
				_GUICtrlEditReplaceSel($presend, True, "[c=" & $chosencolor & "]" & StringMid($oldtxt, $sel[1] + 1, $sel[2] - $sel[1]) & "[/c]")
			EndIf
		Case $marqueeO
			$sel = _GUICtrlEditGetSel($presend)
			$oldtxt = GUICtrlRead($presend)
			If $sel[1] = $sel[2] Then ;no selection
				_GUICtrlEditReplaceSel($presend, True, "[m]")
			Else ;selection
				_GUICtrlEditReplaceSel($presend, True, "[m]" & StringMid($oldtxt, $sel[1] + 1, $sel[2] - $sel[1]) & "[/m]")
			EndIf
		Case $marqueeC
			$sel = _GUICtrlEditGetSel($presend)
			$oldtxt = GUICtrlRead($presend)
			If $sel[1] = $sel[2] Then ;no selection
				_GUICtrlEditReplaceSel($presend, True, "[/m]")
			Else ;selection
				_GUICtrlEditReplaceSel($presend, True, "[m]" & StringMid($oldtxt, $sel[1] + 1, $sel[2] - $sel[1]) & "[/m]")
			EndIf
		Case $gradientO
			$sel = _GUICtrlEditGetSel($presend)
			$oldtxt = GUICtrlRead($presend)
			MsgBox(262144, "Gradient", "Please choose the starting colour in the following dialog box")
			$chosencolor = "#" & StringTrimLeft(_ChooseColor(2, 8355711), 2)
			If $sel[1] = $sel[2] Then ;no selection
				_GUICtrlEditReplaceSel($presend, True, "[c=" & $chosencolor & "]")
			Else ;selection
				MsgBox(262144, "Gradient", "Please choose the ending colour in the following dialog box")
				$chosencolor2 = "#" & StringTrimLeft(_ChooseColor(2, 8355711), 2)
				_GUICtrlEditReplaceSel($presend, True, "[c=" & $chosencolor & "]" & StringMid($oldtxt, $sel[1] + 1, $sel[2] - $sel[1]) & "[/c=" & $chosencolor2 & "]")
			EndIf
		Case $gradientC
			$sel = _GUICtrlEditGetSel($presend)
			$oldtxt = GUICtrlRead($presend)
			If $sel[1] = $sel[2] Then ;no selection
				MsgBox(262144, "Gradient", "Please choose the ending colour in the following dialog box")
				$chosencolor = "#" & StringTrimLeft(_ChooseColor(2, 8355711), 2)
				_GUICtrlEditReplaceSel($presend, True, "[/c=" & $chosencolor & "]")
			Else ;selection
				MsgBox(262144, "Gradient", "Please choose the starting colour in the following dialog box")
				$chosencolor = "#" & StringTrimLeft(_ChooseColor(2, 8355711), 2)
				MsgBox(262144, "Gradient", "Please choose the ending colour in the following dialog box")
				$chosencolor2 = "#" & StringTrimLeft(_ChooseColor(2, 8355711), 2)
				_GUICtrlEditReplaceSel($presend, True, "[c=" & $chosencolor & "]" & StringMid($oldtxt, $sel[1] + 1, $sel[2] - $sel[1]) & "[/c=" & $chosencolor2 & "]")
			EndIf
		Case Else
			For $row = 7 To 1 Step - 1
				For $col = 6 To 1 Step - 1
					If $msg = $table[$row][$col] Then
						If $game = 1 Then
							For $col2 = 6 To 1 Step - 1
								If GUICtrlRead($table[$row][$col2]) <> "r" And GUICtrlRead($table[$row][$col2]) <> "b" Then
									If $host = $CONNECT4_HOST Then
										TCPSend($opponent, "MOVE" & $row & "|" & $col2)
									ElseIf $host = $CONNECT4_CLIENT Then
										TCPSend($c_opponent, "MOVE" & $row & "|" & $col2)
									EndIf
									If $host = $CONNECT4_LOCAL Then GUICtrlSetState($undobtn, $GUI_ENABLE)
									AnimateDown($row, $col2, $color)
									$undo = $row & "," & $col2
									If CheckDraw() = 1 Then
										AddDraw()
										TableReset()
										ExitLoop 3
									EndIf
									If CheckFour($row, $col2, $color) = 1 Then
										If $color = "r" Then
											If $host = $CONNECT4_LOCAL Then
												MsgBox(0, "Win", $red & " got four in a row!")
											ElseIf $host = $CONNECT4_HOST Then
												MsgBox(0, "Win", $usr & " got four in a row!")
											ElseIf $host = $CONNECT4_CLIENT Then
												MsgBox(0, "Win", $c_oppusr & " got four in a row!")
											EndIf
											AddWin("r")
										Else
											If $host = $CONNECT4_LOCAL Then
												MsgBox(0, "Win", $blue & " got four in a row!")
											ElseIf $host = $CONNECT4_CLIENT Then
												MsgBox(0, "Win", $c_usr & " got four in a row!")
											ElseIf $host = $CONNECT4_HOST Then
												MsgBox(0, "Win", $oppusr & " got four in a row!")
											EndIf
											AddWin("b")
										EndIf
										TableReset()
									EndIf
									$color = SwapColor($color) ;set to other player
									ExitLoop 3
								EndIf
							Next
						EndIf
					EndIf
				Next
			Next
	EndSwitch
	If $USE_FAKE_CTRLID = 1 Then $USE_FAKE_CTRLID = 0
EndFunc   ;==>_EventHandler