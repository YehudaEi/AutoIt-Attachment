#cs
*Script should be placed in C:\scanner
*Change Blowfish Password
*Bfish must be in SendMail main directory (C:\scanner\sendmail)
*GetMail.exe must be in GetMail main directory (C:\scanner\getmail)
#ce

$g_szVersion = 'EUMatic PDF Mailer'
If WinExists($g_szVersion) Then Exit; It's already running
AutoItWinSetTitle($g_szVersion)

Opt("RunErrorsFatal", 0)

If @Compiled Then Opt("TrayAutoPause", 0)

Global $Sender, $Recipient, $MailUser, $MailPass
If $CmdLine[0] > 0 Then
	If StringInStr($CmdLine[1], "deutschland") AND StringInStr($CmdLine[1], "polen") Then Exit
	If StringInStr($CmdLine[1], "deutschland") Then
		$Sender = 'fax_deutschland@eumatic.de'
		$Recipient = 'fax_polen@eumatic.de'
		$MailUser = '774583'
		$MailPass = 'urmituJb'
	ElseIf StringInStr($CmdLine[1], "polen") Then
		$Sender = 'fax_polen@eumatic.de'
		$Recipient = 'fax_deutschland@eumatic.de'
		$MailUser = '896215'
		$MailPass = 'VTA2XSKP'
	Else
		Exit
	EndIf
Else
	Exit
EndIf

#region Configuration Settings
Global $Enable_Encryption = False ;or True
Global $Blowfish_Password = 'tBaDOdzc9kSdBRYww8bhB888L49culhRypesaPk3yJD2zO4EK8mTJXYandEh0vsUHCwb5xAa7xsBHybPa3SwuH2nIs4J3TeJdJ8G0wvwAUJBX8M04oSKEZ9vnyzd7e7k'

Global $POP3Server = 'pop3.eumatic.de'
Global $SMTPServer = 'smtp.eumatic.de'

;SendMail Configuration
Global $SendMail = 'C:\scanner\sendmail'
Global $PDF_Dir = 'C:\scanner\sendmail\Emails'

;GetMail Configuration
Global $GetMail = 'C:\scanner\getmail'
Global $source = 'C:\scanner\getmail\Emails' ; Location of encrypted PDF files
Global $dest = 'C:\scanner\getmail\Emails\Archives' ; Location of decrypted PDF files
Global $GSPrintDir = 'C:\scanner\print\Ghostgum\gsview' ;Path to PDF Printer Program

#endregion Configuration Settings

#region Do Not Edit!!!!!

#region GetMail Functions
Func GetMail()
	If Not FileExists($source) Then DirCreate($source)
	If Not FileExists($dest) Then DirCreate($dest)
	FileChangeDir($GetMail)
	
	RunWait('getmail.exe -u ' & $MailUser & ' -pw ' & $MailPass & ' -s ' & $POP3Server & ' -xtract -port 110 -delete', '', @SW_HIDE)
	FileDelete('*.txt')
	FileDelete('*.out')
	FileMove('*.pdf', $source & '\*.pdf', 1)
	Sleep(1000)

	$file = FileFindFirstFile($source & '\*.pdf')
	If $file = -1 Then Return 0
	While 1
		$pdffile = FileFindNextFile($file)
		If @error Then ExitLoop
		If $Enable_Encryption = True Then
			RunWait('bfish.exe /I:"' & $source & '\' & $pdffile & '" /O:"' & $dest & '\' & $pdffile & '" /P:"' & $Blowfish_Password & '" /D /Q', "", @SW_HIDE)
			If FileExists($dest & '\' & $pdffile) Then
				;File successfully decrypted, print it!
				Local $WorkingDir = @WorkingDir
				FileChangeDir($GSPrintDir)
				RunWait('gsprint.exe "' & $dest & '\' & $pdffile & '"', $GSPrintDir, @SW_HIDE)
				FileChangeDir($WorkingDir)
			EndIf
		Else
			FileMove($source & '*.pdf', $dest & '\')
			Local $WorkingDir = @WorkingDir
			FileChangeDir($GSPrintDir)
			RunWait('gsprint.exe "' & $dest & '\' & $pdffile & '"', $GSPrintDir, @SW_HIDE)
			FileChangeDir($WorkingDir)
		EndIf
		While FileExists($source & '\' & $pdffile)
			FileDelete($source & '\' & $pdffile) ;delete the encrypted version
		WEnd
	WEnd
	FileClose($file)
	Return 1
EndFunc   ;==>GetMail
#endregion

#region SendMail Functions
Func SendMail()
	If Not FileExists($PDF_Dir) Then DirCreate($PDF_Dir)
	If Not FileExists($PDF_Dir & '\Encrypted\') Then DirCreate($PDF_Dir & '\Encrypted\')
	If Not FileExists($PDF_Dir & '\Archives\') Then DirCreate($PDF_Dir & '\Archives\')
	If Not FileExists($PDF_Dir & '\*.pdf') Then Return 0

	Dim $PDFfiles[1]
	FileChangeDir($SendMail)
	$PDFHandle = FileFindFirstFile($PDF_Dir & '\*.pdf')
	While 1
		$file = FileFindNextFile($PDFHandle)
		If $file <> '' Then
			ReDim $PDFfiles[ (UBound($PDFfiles) + 1) ]
			$PDFfiles[0] += 1
			$PDFfiles[ (UBound($PDFfiles) - 1) ] = $file
		Else
			ExitLoop
		EndIf
	WEnd
	FileClose($PDFHandle)

	For $x = 1 To $PDFfiles[0]
		If $Enable_Encryption = True Then
			RunWait('bfish.exe /I:"' & $PDF_Dir & '\' & $PDFfiles[$x] & '" /O:"' & $PDF_Dir & '\Encrypted\' & $PDFfiles[$x] & '" /P:"' & $Blowfish_Password & '" /E /Q', "", @SW_HIDE)
			FileSend($PDFfiles[$x], $PDF_Dir & '\Encrypted\' & $PDFfiles[$x])
		Else
			FileSend($PDFfiles[$x], $PDF_Dir & '\' & $PDFfiles[$x])
		EndIf
			FileMove($PDF_Dir & '\' & $PDFfiles[$x], $PDF_Dir & '\Archives\' & $PDFfiles[$x])
	Next
	Return 1
EndFunc   ;==>SendMail

Func FileSend($FileName, $Attachment)

	$objMessage = ObjCreate('CDO.Message')
	With $objMessage
		.Subject = $FileName
		.Sender = $Sender
		.From = $Sender
		.To = $Recipient
		.TextBody = $FileName & ' is attached and encrypted.'
		.AddAttachment ($Attachment)
	EndWith

	With $objMessage.Configuration.Fields
		.Item ("http://schemas.microsoft.com/cdo/configuration/sendusing") = 2
		.Item ("http://schemas.microsoft.com/cdo/configuration/smtpserver") = $SMTPServer
		.Item ("http://schemas.microsoft.com/cdo/configuration/smtpauthenticate") = 1
		.Item ("http://schemas.microsoft.com/cdo/configuration/sendusername") = $MailUser
		.Item ("http://schemas.microsoft.com/cdo/configuration/sendpassword") = $MailPass
		.Item ("http://schemas.microsoft.com/cdo/configuration/smtpserverport") = 25
		.Item ("http://schemas.microsoft.com/cdo/configuration/smtpconnectiontimeout") = 60
		.Update
	EndWith
	$objMessage.Send
	Return 1
EndFunc   ;==>FileSend
#endregion

Func _ReduceMemoryUsage()
	Local $ai_GetCurrentProcessId = DllCall('kernel32.dll', 'int', 'GetCurrentProcessId')
	Local $ai_Handle = DllCall("kernel32.dll", 'int', 'OpenProcess', 'int', 0x1f0fff, 'int', False, 'int', $ai_GetCurrentProcessId[0])
	Local $ai_Return = DllCall("psapi.dll", 'int', 'EmptyWorkingSet', 'long', $ai_Handle[0])
	DllCall('kernel32.dll', 'int', 'CloseHandle', 'int', $ai_Handle[0])
	Return $ai_Return[0]
EndFunc
#endregion Do Not Edit

While 1
	GetMail()
	_ReduceMemoryUsage()
	Sleep(1000 * 5)
	SendMail()
	_ReduceMemoryUsage()
WEnd