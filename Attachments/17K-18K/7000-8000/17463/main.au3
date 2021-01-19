#include <irc.au3>

Global $server = "irc.epiknet.org"
Global $port = 6667
Global $nick = "ZopiBot"
Global $channel = "#zopieux"

TCPStartup ()
Global $sock = _IRCConnect($server, $port, $nick); Connects to IRC and Identifies its Nickname

While 1
	$recv = TCPRecv($sock, 8192); Recieve things from server
	If @error Then Exit MsgBox(1, "IRC Example", "Server has errored or disconnected"); If you can't recieve then the server must have died.
	Local $sData = StringSplit($recv, @CRLF); Splits the messages, sometimes the server groups them
	For $i = 1 To $sData[0] Step 1; Does each message seperately
		Local $sTemp = StringSplit($sData[$i], " "); Splits the message by spaces
		If $sTemp[1] = "" Then ContinueLoop; If its empty, Continue!
		If $sTemp[1] = "PING" Then _IRCPing($sTemp[2]); Checks for PING replys (There smaller then usual messages so its special!
		If $sTemp[0] <= 2 Then ContinueLoop; Useless messages for the most part
		Switch $sTemp[2]; Splits the command msg
			Case "266"; It's what I use as an indictator to show when its done sending you info.
				_IRCJoinChannel ($sock, $channel)
				_IRCSendMessage($sock, "Hello!", $channel)
				_IRCChangeMode ($sock, "+i", $nick)
		EndSwitch
	Next
WEnd
		
#cs
Common recieves:
Nick = User who the message is from
Name = Settable by user, set in the USER command
host = ISP host

~~~~PRIVMSG~~~~
You recieve this when someone has sent a message in a channel, 
gives you there Nick, host, the channel it was said in and the message.

SYNTAX:
:Nick!Name@host PRIVMSG #Channel :Message

EXAMPLE:
:Chip!Chip@OMN-8243F63D.dsl.bell.ca PRIVMSG #Chip :Hey guy's
Would be a message from Chip to say 'Hey guy's' in the channel #Chip

:Chip!Chip@OMN-8243F63D.dsl.bell.ca PRIVMSG Bob :Hey Bob!
Would be a Personal Message from Chip to Bob saying 'Hey Bob!'
~~~~~~~~~

~~~~MODE~~~~
You recieve this when a mode is changed, a mode can give/take access change certain
things like who can join a channel etc..

SYNTAX:
:Nick!Name@host MODE #Channel +/- MODE (USER)

EXAMPLES:
:ChanServ!services@host MODE #Chip +o Chip
This says ChanServ (usually a service bot) has given Chip Operator access in the channel #Chip

:ChanServ!services@host MODE #Chip +i
This makes #Chip invite only, so only OPs can invite users in the channel.

:Chip!Chip@OMN-8243F63D.dsl.bell.ca MODE Chip +i
This will make Chip invisible to WHOIS. These are usermodes.
~~~~~~~~~

~~~~PING~~~~
You recieves these at random to make sure your still online and
not disconnected. 

SYNTAX:
PING :Randomletters

Usually a PING has random letters that you have to respond with.

EXAMPLE:
PING :29809dj0d

You would respond with
PONG 29809dj0d
~~~~~~~~~~~

~~~~JOIN~~~~
You recieve this when someone joins a channel.

SYNTAX:
:Nick!Name@Host JOIN :#Channel

EXAMPLE:
:Chip!Chip@OMN-8243F63D.dsl.bell.ca JOIN :#Chip
This would be sent to everybody in #Chip to show that Chip has joined the channel #Chip
~~~~~~~~~~~~~

~~~~KICK~~~~
You recieve this when someone gets kicked (Including yourself!)

SYNTAX:
:Nick!Name@Host KICK #Channel User :Reason

EXAMPLE:
:Chip!Name@Host KICK #Chip Bob :Talk in private
Would kick Bob from #Chip and say 'Talk in private' in the reason
~~~~~~~~~~~~~~

~~~~QUIT~~~~
You recieve this when someone disconnects from IRC.

SYNTAX:
:Nick!Name@Host QUIT :Reason

EXAMPLE:
:Chip!Chip@OMN-8243F63D.dsl.bell.ca QUIT :I'm bored
Would be sent to everyone in the channels Chip was in to say that he left IRC because He was bored.
~~~~~~~~~~~~~~

#ce