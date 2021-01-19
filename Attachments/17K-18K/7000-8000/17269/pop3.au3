;===============================================================================
;
; Description:      Connects and logs in to the pop3 server
; Parameter(s):     $sServer  - IP address of the server to connect to
;                   $iPort    - port to connect on - usually 110
;                   $sUser    - Username to use to log in
;                   $sPass    - Password to use to log in
; Requirement(s):   TcpStartup ()
; Return Value(s):  On Success - Difference between the 2 dates
;                   On Failure - False  and Set @Error to:
;                                   1 - Timed out while waiting for server to respond
;                                   2 - Server gave error response
;                                   3 - Could not connect to server
; Author(s):        Matt Roth (theguy0000) <theguy0000 at gmail dot com>
;
;===============================================================================
Func _Pop3start ($sServer, $iPort, $sUser, $sPass)
	;connect
	$sock = TCPConnect ($sServer, $iPort)
	If @error Then Return SetError (3, @ScriptLineNumber, False)
	$iTime = TimerInit ()
	Do
		If TimerDiff ($iTime) > 15000 Then Return SetError (1, @ScriptLineNumber, False)
		$sRecv = TCPRecv($sock, 32)
	Until StringLeft($sRecv, 3) = "+OK"
	
	;auth
	TCPSend ($sock, "USER "&$sUser&@CRLF)
	$iTime = TimerInit ()
	Do
		If TimerDiff ($iTime) > 15000 Then Return SetError (1, @ScriptLineNumber, False)
		$sRecv = TCPRecv($sock, 32)
		Sleep (10)
		If StringLeft($sRecv, 4) = "-ERR" Then Return SetError (2, @ScriptLineNumber, False)
	Until StringLeft($sRecv, 3) = "+OK"
	TCPSend ($sock, "PASS "&$sPass&@CRLF)
	Do
		If TimerDiff ($iTime) > 15000 Then Return SetError (1, @ScriptLineNumber, False)
		$sRecv = TCPRecv($sock, 32)
		Sleep(10)
		If StringLeft($sRecv, 4) = "-ERR" Then Return SetError (2, @ScriptLineNumber, False)
	Until StringLeft($sRecv, 3) = "+OK"
	Return $sock
EndFunc

;===============================================================================
;
; Description:      Counts the number of messages in the mailbox
; Parameter(s):     $sock  - Socket previously returned by _pop3start ()
; Requirement(s):   None.
; Return Value(s):  On Success - Number of messages in the mailbox
;                   On Failure - False  and Set @Error to:
;                                   1 - Timed out while waiting for server to respond
;                                   2 - Server gave invalid response
; Author(s):        Matt Roth (theguy0000) <theguy0000 at gmail dot com>
;
;===============================================================================
Func _pop3count ($sock)
	TCPSend ($sock, "STAT"&@CRLF)
	$iTime = TimerInit ()
	Do
		If TimerDiff ($iTime) > 15000 Then Return SetError (1, @ScriptLineNumber, False)
		$sRecv = TCPRecv($sock, 32)
		Sleep(10)
	Until StringLeft($sRecv, 3) = "+OK"
	
	$aSplit = StringSplit ($sRecv, " ")
	If $aSplit[0] < 3 Then Return SetError (2, @ScriptLineNumber, False)
	Return $aSplit[2]
EndFunc

;===============================================================================
;
; Description:      Finds the total size of a mailbox.
; Parameter(s):     $sock  - Socket previously returned by _pop3start ()
; Requirement(s):   None.
; Return Value(s):  On Success - Size of the mailbox in octets (bytes).
;                                   1 - Timed out while waiting for server to respond
;                                   2 - Server gave invalid response
; Author(s):        Matt Roth (theguy0000) <theguy0000 at gmail dot com>
;
;===============================================================================
Func _pop3size ($sock)
	TCPSend ($sock, "STAT"&@CRLF)
	$iTime = TimerInit ()
	Do
		If TimerDiff ($iTime) > 15000 Then Return SetError (1, @ScriptLineNumber, False)
		$sRecv = TCPRecv($sock, 32)
	Until StringLeft($sRecv, 3) = "+OK"
	
	$aSplit = StringSplit ($sRecv, " ")
	If $aSplit[0] < 3 Then Return SetError (2, @ScriptLineNumber, False)
	Return $aSplit[3]
EndFunc

;===============================================================================
;
; Description:      Retrieves a message from the mailbox.
; Parameter(s):     $sock  - Socket previously returned by _pop3start ()
;                   $iNum  - the number of the message to retrieve.
; Requirement(s):   None.
; Return Value(s):  On Success - An Array containing info about the message:
;                                   [0] = Sender
;                                   [1] = Subject
;                                   [2] = the message itself
;                   On Failure - False  and Set @Error to:
;                                   1 - Timed out while waiting for server to respond
;                                   2 - Server gave error response
;                                   3 - Couldn't find some info in the message (eg boundary, sender, subject)
; Author(s):        Matt Roth (theguy0000) <theguy0000 at gmail dot com>
;
;===============================================================================
Func _pop3message ($sock, $iNum)
	TCPSend ($sock, "RETR "&$iNum&@CRLF)
	$iTime = TimerInit ()
	Do
		If TimerDiff ($iTime) > 15000 Then Return SetError (1, @ScriptLineNumber, False)
		$sRecv = TCPRecv($sock, 10000)
		If StringLeft($sRecv, 4) = "-ERR" Then Return SetError (2, @ScriptLineNumber, False)
	Until StringLeft($sRecv, 3) = "+OK"
	
	$aSplit = StringSplit ($sRecv, @CRLF, 1)
	
	$iFrom_e = _ArraySearch ($aSplit, "From: ", 0, 0, 0, True)
	If $iFrom_e = -1 Then Return SetError (3, @ScriptLineNumber, False)
	$from = StringTrimLeft($aSplit[$iFrom_e], 6)
	
	$iBoundary_e = _ArraySearch ($aSplit, "boundary=", 0, 0, 0, True)
;~ 	echo ('boundary_e-'&$iBoundary_e)
	$iBoundary_s = $aSplit[$iBoundary_e]
	$iBoundary_startpos = StringInStr ($iBoundary_s, '"')
	$iBoundary_endpos = StringInStr ($iBoundary_s, '"', 0, 2)
	$boundary = StringMid ($iBoundary_s, $iBoundary_startpos+1, $iBoundary_endpos-$iBoundary_startpos-1)
;~ 	echo ($boundary)
	$boundary1 = _ArraySearch ($aSplit, $boundary, $iBoundary_e+1, 0, 1, True)
;~ 	echo ('boundary1-'&$boundary1)
	$boundary2 = _ArraySearch ($aSplit, $boundary, $boundary1+1, 0, 1, True)
;~ 	echo ('boundary2-'&$boundary2)
	$message = ""
	For $i=$boundary1+4 To $boundary2-1
		$message = $message & $aSplit[$i]
	Next
	
	$subject_e = _ArraySearch ($aSplit, "Subject: ", 0, 0, 0, True)
	$subject = StringTrimLeft ($aSplit[$subject_e], 9)
	
	Dim $aReturn[3]
	$aReturn[0] = $from
	$aReturn[1] = $subject
	$aReturn[2] = $message
	Return $aReturn
EndFunc