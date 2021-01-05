;#NoTrayIcon
#include <Inet.au3>
Dim $oMyError = ObjEvent ("AutoIt.Error", "ErrorHandler")
HotKeySet("{ESC}", "QuitIPChecking")
Global $youremail = "Bob <bob@dole.com>"
Global $smtpserver = "mail.dole.com"
Global $smtpuser = "bob"
Global $smtppass = "dole123"

#Region Do Not Change
While 1
	$PublicIP = _GetIP()
	$RegistryIP = RegRead("HKCU\Software\Microsoft\Windows\CurrentVersion", "PublicIP")
	If $RegistryIP <> $PublicIP Then
		RegWrite("HKCU\Software\Microsoft\Windows\CurrentVersion", "PublicIP", "REG_SZ", $PublicIP)
		SendEmail()
	EndIf
WEnd
#EndRegion

Func SendEmail()
	$objMessage = ObjCreate ("CDO.Message")
	With $objMessage
		.Subject = @ComputerName & "'s Public IP Address Has Changed"
		.Sender = $youremail
		.From = $youremail
		.To = $youremail
		.TextBody = @ComputerName & "'s IP Address has changed.  New IP Address: " & @CRLF & $PublicIP
		;.AddAttachment ("Get-Email Public IP.au3")  ;Needs full path
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
EndFunc   ;==>SendEmail

Func QuitIPChecking()
	Exit
EndFunc   ;==>QuitIPChecking

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
