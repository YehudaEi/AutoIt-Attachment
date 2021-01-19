;===============================================================================
;
; Description:      Connects you to a IRC Server, and gives your chosen Nick
; Parameter(s):     $server - IRC Server you wish to connect to
;                   $port - Port to connect to (Usually 6667)
;                   $nick - Nick you choose to use (You can change later)
; Requirement(s):   TCPStartup () to be run
; Return Value(s):  On Success - Socket identifer
;                   On Failure - It will exit on error
; Author(s):        Chip
; Note(s):          English only
;
;===============================================================================
Func _IRCConnect ($server, $port, $nick)
	Local $i = TCPConnect(TCPNameToIP($server), $port)
	If $i = -1 Then Exit MsgBox(1, "irc.au3 Error", "Server " & $server & " is not responding.")
	TCPSend($i, "NICK " & $nick & @CRLF)
	TCPSend($i, "USER " & $nick & " 0 0 " & $nick &@CRLF)
	Return $i
EndFunc

;===============================================================================
;
; Description:      Joins an IRC Channel
; Parameter(s):     $irc - Socket Identifer from _IRCConnect ()
;                   $chan - Channel you wish to join
; Requirement(s):   _IRCConnect () to be run
; Return Value(s):  On Success - 1
;                   On Failure - -1 = Server disconnected.
; Author(s):        Chip
; Note(s):          English only
;
;===============================================================================
Func _IRCJoinChannel ($irc, $chan)
	If $irc = -1 Then Return 0
	TCPSend($irc, "JOIN " & $chan & @CRLF)
	If @error Then 
		MsgBox(1, "irc.au3", "Server has disconnected.")
		Return -1
	EndIf
	Return 1
EndFunc

;===============================================================================
;
; Description:      Sends a message using IRC
; Parameter(s):     $irc - Socket Identifer from _IRCConnect ()
;					$msg - Message you want to send
;                   $chan - Channel/Nick you wish to send to
; Requirement(s):   _IRCConnect () to be run
; Return Value(s):  On Success - 1
;                   On Failure - -1 = Server disconnected.
; Author(s):        Chip
; Note(s):          English only
;
;===============================================================================
Func _IRCSendMessage ($irc, $msg, $chan="")
	If $irc = -1 Then Return 0
	If $chan = "" Then
		TCPSend($irc, $msg & @CRLF)
		If @error Then 
			MsgBox(1, "irc.au3", "Server has disconnected.")
			Return -1
		EndIf
		Return 1
	EndIf
	TCPSend($irc, "PRIVMSG " & $chan & " :" & $msg & @CRLF)
		If @error Then 
		MsgBox(1, "irc.au3", "Server has disconnected.")
		Return -1
	EndIf
	Return 1
EndFunc

;===============================================================================
;
; Description:      Changes a MODE on IRC
; Parameter(s):     $irc - Socket Identifer from _IRCConnect ()
;					$mode - Mode you wish to change
;                   $chan - Channel/Nick you wish to send to
; Requirement(s):   _IRCConnect () to be run
; Return Value(s):  On Success - 1
;                   On Failure - -1 = Server disconnected.
; Author(s):        Chip
; Note(s):          English only
;
;===============================================================================
Func _IRCChangeMode ($irc, $mode, $chan="")
	If $irc = -1 Then Return 0
	If $chan = "" Then
		TCPSend($irc, "MODE " & $mode & @CRLF)
		If @error Then 
		MsgBox(1, "irc.au3", "Server has disconnected.")
		Return -1
	EndIf
	Return 1
	EndIf
	TCPSend($irc, "MODE " & $chan & " " & $mode & @CRLF)
		If @error Then 
		MsgBox(1, "irc.au3", "Server has disconnected.")
		Return -1
	EndIf
	Return 1
EndFunc

;===============================================================================
;
; Description:      Returns a PING to Server
; Parameter(s):     $irc - Socket Identifer from _IRCConnect ()
;					$ret - The end of the PING to return
; Requirement(s):   _IRCConnect () to be run
; Return Value(s):  On Success - 1
;                   On Failure - -1 = Server disconnected.
; Author(s):        Chip
; Note(s):          English only
;
;===============================================================================
Func _IRCPing($ret)
	If $ret = "" Then Return -1
	TCPSend($irc, "PONG " & $ret & @CRLF)
		If @error Then 
		MsgBox(1, "irc.au3", "Server has disconnected.")
		Return -1
	EndIf
	Return 1
EndFunc