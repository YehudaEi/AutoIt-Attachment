$mozinstallfile = "Firefox Setup 1.0.4.exe"
$mozver = "1.0.4.0"
$DefHomePage = "                                                                                "
$NewHomePage = "www.google.com"

If FileGetVersion(@ProgramFilesDir & "\Mozilla Firefox\Firefox.exe") > $mozver Then Exit

FileInstall($mozinstallfile, @TempDir & "\" & $mozinstallfile)
Run(@TempDir & "\" & $mozinstallfile)
#Region Run Installation Program
WinWaitActive("Firefox Setup")
ControlSend("Firefox Setup", "Welcome", 12325, "{ENTER}")

WinWaitActive("Software License Agreement")
ControlSend("Software License Agreement", "", 1081, "{SPACE}")
ControlSend("Software License Agreement", "", 12325, "{ENTER}")

WinWaitActive("Setup Type")
ControlSend("Setup Type", "", 12325, "{ENTER}")

WinWaitActive("Select Components")
ControlSend("Select Components", "", 12325, "{ENTER}")

WinWaitActive("Install Complete")

ControlSend("Install Conplete", "", 1091, "{ENTER}")
ControlSend("Install Conplete", "", 12325, "{ENTER}")
#EndRegion (Run Installation Program)
opt("WinTitleMatchMode", "2")
WinWait("- Mozilla Firefox")
#Region Check/Fix Default Homepage
If WinExists("University of Wisconsin-Milwauke - Mozilla Firefox") = 0 Then
	While ProcessExists("firefox.exe")
		ProcessClose("firefox.exe")
	WEnd
	$test = FileFindFirstFile(@AppDataDir & "\Mozilla\Firefox\Profiles\*.default")
	$profiledir = FileFindNextFile($test)
	FileClose($test)
	$PrefsFile = @AppDataDir & "\Mozilla\Firefox\Profiles\" & $profiledir & "\prefs.js"
	;;Let's get the user preferences
	$fHandle = FileOpen($PrefsFile, "0")
	$fContents = FileRead($fHandle, FileGetSize($PrefsFile))
	FileClose($fHandle)
	;;Let's now replace the default homepage
	$fNewContents = StringReplace($fContents, $DefHomePage, $NewHomePage)
	;;Let's save these changes
	$fHandle = FileOpen($PrefsFile, "2")
	MsgBox(0, "test", $fHandle)
	FileWrite($fHandle, $fNewContents)
	FileClose($fHandle)
Else
	ProcessClose("firefox.exe")
EndIf
#EndRegion (Check/Fix Default Homepage)
While FileExists(@TempDir & "\" & $mozinstallfile)
	FileDelete(@TempDir & "\" & $mozinstallfile)
WEnd

#cs
	Func SendEmail()
	If @AutoItVersion >= "3.1.1.47" Then
	$objMessage = ObjCreate ("CDO.Message")
	With $objMessage
	.Subject = "Firefox Install Error"
	.Sender = "anonymousip@wisconsin.edu"
	.From = "anonymousip@wisconsin.edu"
	.To = "youremail@wisconsin.edu"
	.TextBody = @ComputerName & " (" & @IPAddress1 & ") did not successfully install Firefox.  It may just be the homepage setting, however."
	EndWith
	With $objMessage.Configuration.Fields
	.Item ("http://schemas.microsoft.com/cdo/configuration/sendusing") = 2
	.Item ("http://schemas.microsoft.com/cdo/configuration/smtpserver") = "mail.wisconsin.edu"
	.Item ("http://schemas.microsoft.com/cdo/configuration/smtpauthenticate") = 1;set to 0 if no auth is necessary
	.Item ("http://schemas.microsoft.com/cdo/configuration/sendusername") = "john doe"
	.Item ("http://schemas.microsoft.com/cdo/configuration/sendpassword") = "my password"
	.Item ("http://schemas.microsoft.com/cdo/configuration/smtpserverport") = 25
	.Item "http://schemas.microsoft.com/cdo/configuration/smtpconnectiontimeout") = 60
	.Update
	EndWith
	$objMessage.Send
	EndIf
	EndFunc  ;==>SendEmail
#ce