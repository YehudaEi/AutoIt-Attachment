;~ Based on old AutoIt Forum post I think this
;~ http://www.autoitscript.com/forum/index.php?s=&showtopic=13129&view=findpost&p=89599
Func Mail($NAME,$FROM,$TO,$SUBJECT,$BODY="",$CONTENT_TYPE="text/plain",$FILE_NAME="",$DESCRIPTION="",$CONTENT_ENCODE="",$CONTENT_ID="<mail_test@yahoo.com>",$SMTP="a.mx.mail.yahoo.com")
Local $OUT = True
TCPStartup()
$SERVER = TCPConnect(TCPNameToIP($SMTP),25)
If $SERVER <> -1 Then
TCPSend($SERVER,'HELO ' & $NAME & @CRLF)
If @error Then $OUT = False
Sleep(100)
TCPSend($SERVER,'MAIL FROM: <' & $FROM & '>' & @CRLF)
If @error Then $OUT = False
Sleep(100)
TCPSend($SERVER,'RCPT TO: <' & $TO & '>'& @CRLF)
If @error Then $OUT = False
Sleep(100)
TCPSend($SERVER,'DATA' & @CRLF)
If @error Then $OUT = False
Sleep(100)
TCPSend($SERVER,'From:' & $NAME & '<' & $FROM & '>' & @CRLF)
If @error Then $OUT = False
Sleep(100)
TCPSend($SERVER,'To:' & $TO & @CRLF)
If @error Then $OUT = False
Sleep(100)
TCPSend($SERVER,'Subject:' & $SUBJECT & @CRLF)
If @error Then $OUT = False
Sleep(100)
TCPSend($SERVER,'Sender: Microsoft Outlook Express 6.00.2800.1158' & @CRLF)
If @error Then $OUT = False
Sleep(100)
TCPSend($SERVER,'Mime-Version: 1.0' & @CRLF)
If @error Then $OUT = False
Sleep(100)
If $CONTENT_TYPE = Default And $FILE_NAME = "" Then
TCPSend($SERVER,'Content-Type: ' & $CONTENT_TYPE & @CRLF)
If @error Then $OUT = False
ElseIf $CONTENT_TYPE <> Default And $FILE_NAME <> "" Then
TCPSend($SERVER,'Content-Type: ' & $CONTENT_TYPE & '; name="' & $FILE_NAME & '"' & @CRLF)
If @error Then $OUT = False
Local $FNAME = StringRight($FILE_NAME,StringLen($FILE_NAME)-StringInStr($FILE_NAME,"\",0,-1))
TCPSend($SERVER,'Content-Disposition: attachment; filename=' & $FNAME & @CRLF) 
If @error Then $OUT = False
ElseIf $CONTENT_TYPE = Default And $FILE_NAME <> "" Then
TCPSend($SERVER,'Content-Type: ' & $CONTENT_TYPE & '; name="' & $FILE_NAME & '"' & @CRLF)
If @error Then $OUT = False
Local $FNAME = StringRight($FILE_NAME,StringLen($FILE_NAME)-StringInStr($FILE_NAME,"\",0,-1))
TCPSend($SERVER,'Content-Disposition: attachment; filename=' & $FNAME & @CRLF)  
If @error Then $OUT = False
ElseIf $CONTENT_TYPE <> Default And $FILE_NAME = "" Then
TCPSend($SERVER,'Content-Type: ' & $CONTENT_TYPE & @CRLF)
If @error Then $OUT = False
EndIf
Sleep(100)
If $DESCRIPTION <> "" Then
TCPSend($SERVER,'Content-Description: ' & $DESCRIPTION & @CRLF)
If @error Then $OUT = False
Sleep(100)
EndIf
If $CONTENT_ENCODE <> "" Then
TCPSend($SERVER,'Content-Transfer-Encoding: ' & $CONTENT_ENCODE & @CRLF)
If @error Then $OUT = False
Sleep(100)
EndIf
If $CONTENT_ID <> "" Then
TCPSend($SERVER,'Content-ID: ' & $CONTENT_ID & @CRLF)
If @error Then $OUT = False
Sleep(100)
EndIf
TCPSend($SERVER,@CRLF)
If @error Then $OUT = False
Sleep(100)
If $BODY <> "" Then
TCPSend($SERVER,$BODY & @CRLF)
If @error Then $OUT = False
Sleep(100)
EndIf
TCPSend($SERVER,@CRLF)
If @error Then $OUT = False
Sleep(100)
TCPSend($SERVER,"." & @CRLF)
If @error Then $OUT = False
Sleep(300)
Else
$OUT = False
SetError(False,-1,-1)
EndIf
TCPShutdown()
Return $OUT
EndFunc