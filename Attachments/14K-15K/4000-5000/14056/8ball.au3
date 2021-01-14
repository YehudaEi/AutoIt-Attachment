#include <IRC.au3>
#include <File.au3>
Global $ran = Random (1, 6000, 1)
Global $server = "irc.bluehell.org"
Global $port = 6667
Global $nick = "TEST_BOT"
Global $channel = "#LAWL"
Global $8BallRes = IniReadSection("8ball.ini", "Reply")
Global $Trigger = "."


TCPStartup ()
Global $sock = _IRCConnect($server, $port, $nick); Connects to IRC and Identifies its Nickname

While 1
	$recv = TCPRecv($sock, 8192); Recieve things from server
	If @error Then Exit MsgBox(1, "IRC Example", "Server has error or disconnected"); If you can't recieve then the server must have died.
	Local $sData = StringSplit($recv, @CRLF); Splits the messages, sometimes the server groups them
	For $i = 1 To $sData[0] Step 1; Does each message seperately
		Local $sTemp = StringSplit($sData[$i], " "); Splits the message by spaces
		If $sTemp[1] = "" Then ContinueLoop; If its empty, Continue!
		If $sTemp[1] = "PING" Then _IRCPing($sTemp[2]); Checks for PING replys (There smaller then usual messages so its special!
		;If $sTemp[1] = "PING" Then _IRCPing($sock,$sTemp[2])	
		If $sTemp[0] <= 2 Then ContinueLoop; Useless messages for the most part
		Switch $sTemp[2]; Splits the command msg
			Case "PRIVMSG"
				$user = StringMid($sTemp[1], 2, StringInStr($sTemp[1], "!")-2)
				$msg = StringMid($sData[$i], StringInStr($sData[$i], ":", 0, 2)+1)
				If StringLeft($msg, 1) = $Trigger Then
					_Cmd($user, $sTemp[3], $msg)
				EndIf
			Case "266"; It's what I use as an indictator to show when its done sending you info.
				_IRCJoinChannel ($sock, $channel)
				_IRCSendMessage($sock, "Hello!", $channel)
				_IRCChangeMode ($sock, "+i", $nick)
		EndSwitch
	Next
WEnd

Func _Cmd($user, $channel, $msg)
	Local $sTemp = StringSplit($msg, " ")
	$sTemp[1] = StringTrimLeft($sTemp[1], 1)
	Switch StringUpper($sTemp[1])
		Case "8BALL"
			$i = Random (0, UBound($8BallRes,1) -1)
			_IRCSendMessage($sock, $8BallRes[$i][1], $channel)
	EndSwitch
EndFunc