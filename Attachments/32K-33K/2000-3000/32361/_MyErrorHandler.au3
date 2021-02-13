#NoTrayIcon
#include-once
#include <ButtonConstants.au3>
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include <Constants.au3>

$NotifyEmail = "123456@mymail.com" ; E-Mail Address to notify of Bug in Script
$FromGmailEmailAddy = "123456@mymail.com" ;Show Email From Address
$FromGmailAccount = "123456@mymail.com" ;GMail Address to send from
$FromGmailPassword = "myemailpassword" ;Gmail Password for above account
$EMailSubject = "Error with AutoIt Script "&@ScriptName&"" ;Subject of above Email
$SMTPServer = "smtp.gmail.com:587" ; smtp server with port

_AutoItErrorHandler()

Func _AutoItErrorHandler($sTitleMsg=-1, $sErrorMsgFormat=-1)
	If StringInStr($CmdLineRaw, "/AutoIt3ExecuteScript") Then
		Opt("TrayIconHide", 0)
		Return
	EndIf

	Local $sErrorMsg = ""
	Local $hErrGUI, $nMsg
	Local $sRunLine = @AutoItExe & ' /AutoIt3ExecuteScript "' & @ScriptFullPath & '"'
	Local $hErrGUI, $nMsg

	Local $iPID = Run($sRunLine, @ScriptDir)
	ProcessWait($iPID)

	Opt("WinWaitDelay", 0)

	While ProcessExists($iPID)
		Sleep(10)
		If WinExists("[CLASS:#32770;TITLE:AutoIt Error]") Then ExitLoop
	WEnd

	WinWait("[CLASS:#32770;TITLE:AutoIt Error]", "", 3)
	If Not WinExists("[CLASS:#32770;TITLE:AutoIt Error]") Then Exit

	$sErrorMsg = ControlGetText("[CLASS:#32770;TITLE:AutoIt Error]", "", "Static2")
	WinClose("[CLASS:#32770;TITLE:AutoIt Error]")

	If $sErrorMsg = "" Then Exit

	If Not IsString($sTitleMsg) Then $sTitleMsg = "Program Error"
	If Not IsString($sErrorMsgFormat) Then $sErrorMsgFormat = "The Program has been Terminated.\r\n" & _
		"Please Send a Bug Report to the author, sorry for the inconvenience!\r\n\r\n" & _
		"Program Path: %s\r\n\r\nError Description: %s"

	$hErrGUI = GUICreate($sTitleMsg, 317, 172, 290, 283)
	WinSetOnTop($hErrGUI, "", 1)

	$sScriptPath = StringRegExpReplace($sErrorMsg, '(?s)Line \d+.*\(File "(.*)"\):.*', '\1')
	$sErrDesc = StringRegExpReplace($sErrorMsg, '(?s)Line \d+.*\(File ".*"\):\s+(.*?)\s+Error: (.*)', '\2')

	$SendErrorReportButton = GUICtrlCreateButton("Send Bug Report", 0, 144, 161, 25, $WS_GROUP)
	$CloseProgramButton = GUICtrlCreateButton("Close Program", 168, 144, 147, 25, $WS_GROUP)
	$ErrorOccuredLabel = GUICtrlCreateLabel("An error occurred in the application and it needs to be Terminated.", 8, 8, 310, 17)
	$ErrorDesc = GUICtrlCreateLabel(StringFormat($sErrorMsgFormat, $sScriptPath, $sErrDesc), 8, 8, 298, 121)
	GUISetState()

	While 1
		$nMsg = GUIGetMsg()

		Switch $nMsg
			Case $GUI_EVENT_CLOSE
				Exit
			Case $SendErrorReportButton
				GUISetState(@SW_HIDE,$hErrGUI)
				TraySetState(1)
				TraySetIcon(@WindowsDir & '\explorer.exe',109)
				If Not IsDeclared("GetEmailAddyToNotify") Then Local $GetEmailAddyToNotify
				$GetEmailAddyToNotify = InputBox("Notify Email Address","If you would like to be notified of a new version of the application that fixes this bug please provide an email address below.","","","",140)
				Select
					Case @Error = 0 ;OK - The string returned is valid
						If $GetEmailAddyToNotify = "" Then $GetEmailAddyToNotify = "EMail Not Provided"
						Local $hDownload = InetGet("http://dl.dropbox.com/u/1100806/bin/sendemail.exe", @TempDir & "\sendemail.exe", 1, 1)
						Do
							Sleep(250)
							Local $nBytes = InetGetInfo($hDownload, 0)
							TrayTip("Sending Bug Report!","Please wait while the Bug Report is prepaired and sent to the Developer. You will be notified when it is sent.",60)
						Until InetGetInfo($hDownload, 2)    ; Check if the download is complete.
						Local $nBytes = InetGetInfo($hDownload, 0)
						InetClose($hDownload)   ; Close the handle to release resourcs.
						$SendemailMSG = FileOpen(@TempDir & '\sendemail.msg',2)
						FileWrite($SendemailMSG,StringFormat($sErrorMsgFormat, $sScriptPath, $sErrDesc)& @CRLF & @CRLF & "Notify Sender : " &$GetEmailAddyToNotify )
						FileClose($SendemailMSG)
						$SendEmailParams = ' -f '&$FromGmailEmailAddy&' -xu '&$FromGmailAccount&' -xp '&$FromGmailPassword&' -s '&$SMTPServer&' -o message-file="'& @TempDir & '\sendemail.msg" '&'-u '&$EMailSubject& " -t "&$NotifyEmail
						ShellExecuteWait("sendemail.exe",$SendEmailParams,@TempDir,"",@SW_HIDE)
						WinSetOnTop($hErrGUI, "", 0)
						MsgBox(1024,"Bug Report Info Sent","The Bug Report has been sent!" & @CRLF & @CRLF & "You will be notified when a new version is published that fixes this issue.")
						FileDelete(@TempDir & '\sendemail.exe')
						FileDelete(@TempDir & '\sendemail.msg')
						Exit
					Case @Error = 1 ;The Cancel button was pushed
						MsgBox(1024,"You will not be notified!","A bug report will still be sent but you will not be notified of any updates to this code.")
						Local $hDownload = InetGet("http://dl.dropbox.com/u/1100806/bin/sendemail.exe", @TempDir & "\sendemail.exe", 1, 1)
						Do
							Sleep(250)
							Local $nBytes = InetGetInfo($hDownload, 0)
							TrayTip("Sending Bug Report!","Please wait while the Bug Report is prepaired and sent to the Developer. You will be notified when it is sent.",60)
						Until InetGetInfo($hDownload, 2)    ; Check if the download is complete.
						Local $nBytes = InetGetInfo($hDownload, 0)
						InetClose($hDownload)   ; Close the handle to release resourcs.
						$SendemailMSG = FileOpen(@TempDir & '\sendemail.msg',2)
						FileWrite($SendemailMSG,StringFormat($sErrorMsgFormat, $sScriptPath, $sErrDesc))
						FileClose($SendemailMSG)
						$SendEmailParams = ' -f '&$FromGmailEmailAddy&' -xu '&$FromGmailAccount&' -xp '&$FromGmailPassword&' -s '&$SMTPServer&' -o message-file="'& @TempDir & '\sendemail.msg" '&'-u '&$EMailSubject& " -t "&$NotifyEmail
						ShellExecuteWait("sendemail.exe",$SendEmailParams,@TempDir,"",@SW_HIDE)
						WinSetOnTop($hErrGUI, "", 0)
						MsgBox(1024,"Bug Report Info Sent","The Bug Report has been sent!")
						FileDelete(@TempDir & '\sendemail.exe')
						FileDelete(@TempDir & '\sendemail.msg')
						Exit
					Case @Error = 3 ;The InputBox failed to open
						;
				EndSelect
				$sErrDesc = StringRegExpReplace($sErrorMsg, '(?s)Line \d+.*\(File ".*"\):\s+(.*?)\s+Error: (.*)', '\2')
				;$iScriptLine = StringRegExpReplace($sErrorMsg, '(?s)Line (\d+).*\(File ".*"\):.*', '\1')
				WinSetOnTop($hErrGUI, "", 0)
				MsgBox(1024,"Bug Report Info Sent","The Bug Report has been sent!")
				FileDelete(@TempDir & '\sendemail.exe')
				Exit
			Case $CloseProgramButton
				Exit
		EndSwitch
		TraySetState(2)
	WEnd
	Exit
EndFunc