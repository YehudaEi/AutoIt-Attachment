Dim $oMyError = ObjEvent("AutoIt.Error","ErrorHandler")

Dim $errorlog = "Error Report" & @CRLF & @CRLF & _
			"Computer Name: " & @ComputerName & @CRLF & _
			"Current User: " & @UserName & @CRLF  & @CRLF

Dim $lnumber = StringRight(@ComputerName, 3)

#Region Functions
Func NoAPIPA()
If RegRead("HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces\adapter_name", "IPAutoconfigurationEnabled")  = "" Then
	RegWrite("HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces\adapter_name", "IPAutoconfigurationEnabled", "REG_DWORD", 0)
	$errorlog = $errorlog & "APIPA was enabled, now disabled" & @CRLF  & @CRLF
EndIf
EndFunc ;==>NoAPIPA()

Func EnumLocal()
	$colAccounts = ObjGet("WinNT://" & @ComputerName)
	;;do a conditional statement for each type of system (laptop, desktops...etc)
	;;Dim $goodAccounts[8]
	;;Declare good accounts here

	Dim $Accounts[1]
	$Accounts[0] = "user"
	$colAccounts.Filter = $Accounts
	For $objUser In $colAccounts
		Dim $test = 0
		MsgBox(0, "test", $objUser.Name)
		;	MsgBox(0, "test", $objUser)
		If $test = 4 Then $errorlog = $errorlog & "Unauthorized User Account: " & $objUser & @CRLF
	Next
	$errorlog = $errorlog & @CRLF	
EndFunc ;==>EnumLocal()

Func ResetUserPass($user)
	$objUser = ObjGet("WinNT://" & @ComputerName & "/" & $user & ", user")
	With $objUser
		.SetPassword("testpassword")
		.SetInfo
	EndWith
EndFunc ;==>ResetUserPass()

Func CreateLocalUser($user)
	$colAccounts = ObjGet("WinNT://" & @ComputerName)
	$objUser = $colAccounts.Create("user", $user)
	With $objUser
		.SetPassword("test")
		.SetInfo
	EndWith
EndFunc ;==>CreateLocalUser()

Func DeleteLocalUser($user)
	$objComputer = ObjGet("WinNT://" & @ComputerName)
	$objComputer.Delete("user", $user)
EndFunc ;==>DeleteLocalUser()

Func DisableLocalUser($user)
	$objUser = ObjGet("WinNT://" & @ComputerName & $user)
	With $objUser
		.AccountDisabled = True
		.SetInfo
	EndWith
EndFunc ;==>DisableLocalUser()

Func SendEmail($sender, $recipient, $carbon, $blindcarbon, $body)
	$objMessage = ObjCreate("CDO.Message")
	With $ObjMessage
		.Subject = "Test Message"
		.Sender = "MSLx Fanboy <mslxfanboy@fakeemail.org>"
		.From = "Me! <your_email@email.org>"
		.To = "joe_somebody@hotmail.com"
		.Cc = "send_to_me_too@gmail.com"
		.Bcc = "keep_me_secret@righthere.com"
		.TextBody = "Hello World!"
;		.AddAttachment "sendemail.au3"
;		.HTMLBody = ""
	EndWith

	With $objMessage.Configuration.Fields
		.Item("http://schemas.microsoft.com/cdo/configuration/sendusing") = 2
		.Item("http://schemas.microsoft.com/cdo/configuration/smtpserver") = "server@address.com"
		.Item("http://schemas.microsoft.com/cdo/configuration/smtpauthenticate") = 1
		.Item("http://schemas.microsoft.com/cdo/configuration/sendusername") = "user1"
		.Item("http://schemas.microsoft.com/cdo/configuration/sendpassword") = "pass2"
		.Item("http://schemas.microsoft.com/cdo/configuration/smtpserverport") = 25
		.Item("http://schemas.microsoft.com/cdo/configuration/smtpconnectiontimeout") = 60
		.Update
	EndWith

	$objMessage.Send
EndFunc ;==>SendEmail()

Func ErrorHandler()

  $HexNumber=hex($oMyError.number,8)

  Msgbox(0,"","We intercepted a COM Error !"       & @CRLF                          & @CRLF & _
             "err.description is: "    & @TAB & $oMyError.description    & @CRLF & _
             "err.windescription:"     & @TAB & $oMyError.windescription & @CRLF & _
             "err.number is: "         & @TAB & $HexNumber              & @CRLF & _
             "err.lastdllerror is: "   & @TAB & $oMyError.lastdllerror   & @CRLF & _
             "err.scriptline is: "     & @TAB & $oMyError.scriptline     & @CRLF & _
             "err.source is: "         & @TAB & $oMyError.source         & @CRLF & _
             "err.helpfile is: "       & @TAB & $oMyError.helpfile       & @CRLF & _
             "err.helpcontext is: "    & @TAB & $oMyError.helpcontext _
            )

  SetError(1) ; to check for after this function returns
Endfunc

#endregion

EnumLocal()
MsgBox(0, "test", $errorlog)

If StringInStr(StringUpper(@ComputerName), "STC") AND $lnumber < 500 Then
	;Disable DirectX
	;Enumerate and check local accounts
	;Check cait-config password (RunAsSet())
	;Send email on any errors
Else 
	;Enable DirectX
	;Enumerate and check local accounts
	;Check cait-config password (RunAsSet())
	;Send email on any errors
EndIf

#cs
#Region Configure No Expiration Account
;;Test the $objUserFlags ObjGet() function

Const $ADS_UF_DONT_EXPIRE_PASSWD = &h10000

$objUser = ObjGet("WinNT:// " & @ComputerName & "/Administrator ")
$objUserFlags = ObjGet("",$objUser & ".UserFlags")
$objPasswordExpirationFlag = $objUserFlags OR $ADS_UF_DONT_EXPIRE_PASSWD
$objUser.Put "userFlags", $objPasswordExpirationFlag 
$objUser.SetInfo
#endregion

#Region Configure No Expiration Password
Const $ADS_UF_DONT_EXPIRE_PASSWD = &h10000
$strUser = "KenMeyer"
 
$objUser = ObjGet("WinNT://" & @LogonDomain & "/" & @ComputerName & "/" & $strUser & ",User")
 
$objUserFlags = ObjGet($objUser & ".UserFlags")
$objPasswordExpirationFlag = $objUserFlags OR $ADS_UF_DONT_EXPIRE_PASSWD
$objUser.Put "userFlags", $objPasswordExpirationFlag 
$objUser.SetInfo
#endregion
#region Force Password Change
$objUser = ObjGet("WinNT:// " & @ComputerName & "/kenmyer ")
$objUser.Put "PasswordExpired", 1
$objUser.SetInfo
#endregion
#ce