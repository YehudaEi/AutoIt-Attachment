;=============================================================
; Global Settings
$smtpserver = "" ;smtp server address (i.e. mail.server.com)
$smtpuser = "" ;smtp username (i.e. john_doe)
$smtppass = "" ;smtp password (i.e. my_s3cret_P@$$)
;
;=============================================================

Func SendEmail($e_Sender, $e_Recipient, $e_Subject, $e_Text)
	$objMessage = ObjCreate ("CDO.Message")
	With $objMessage
		.Subject = $e_Subject
		.Sender = $e_Sender
		.From = $e_Sender
		.To = $e_Recipient
		.TextBody = $e_text
		;.AddAttachment ("")  ;Needs FULL path!!!
	EndWith
	With $objMessage.Configuration.Fields
		.Item ("http://schemas.microsoft.com/cdo/configuration/sendusing") = 2
		.Item ("http://schemas.microsoft.com/cdo/configuration/smtpserver") = $smtpserver
		.Item ("http://schemas.microsoft.com/cdo/configuration/smtpauthenticate") = 1
		.Item ("http://schemas.microsoft.com/cdo/configuration/sendusername") = $smtpuser
		.Item ("http://schemas.microsoft.com/cdo/configuration/sendpassword") = $smtppass
		.Item ("http://schemas.microsoft.com/cdo/configuration/smtpserverport") = 25
		.Item ("http://schemas.microsoft.com/cdo/configuration/smtpconnectiontimeout") = 60
		.Update
	EndWith
	$objMessage.Send
	Return
EndFunc   ;==>SendEmail


;;Error handler functions in case there was an error with email
Dim $oMyError = ObjEvent ("AutoIt.Error", "ErrorHandler")
Func ErrorHandler()
	
	$HexNumber = Hex($oMyError.number, 8)
	
	MsgBox(0, "", "We intercepted a COM Error !" & @CRLF & @CRLF & _
			"err.description is: " & @TAB & $oMyError.description & @CRLF & _
			"err.windescription:" & @TAB & $oMyError.windescription & @CRLF & _
			"err.number is: " & @TAB & $HexNumber & @CRLF & _
			"err.lastdllerror is: " & @TAB & $oMyError.lastdllerror & @CRLF & _
			"err.scriptline is: " & @TAB & $oMyError.scriptline & @CRLF & _
			"err.source is: " & @TAB & $oMyError.source & @CRLF & _
			"err.helpfile is: " & @TAB & $oMyError.helpfile & @CRLF & _
			"err.helpcontext is: " & @TAB & $oMyError.helpcontext _
			)
	
	SetError(1) ; to check for after this function returns
	Exit
EndFunc   ;==>ErrorHandler