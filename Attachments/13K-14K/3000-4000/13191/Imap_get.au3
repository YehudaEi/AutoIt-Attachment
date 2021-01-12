#include <GUIConstants.au3>
#include <file.au3>
#include <Array.au3>
#include "_Base64.au3"
#include <Constants.au3>
#Include <String.au3>
Opt("OnExitFunc", "endscript")

;Trace Window
Global $mylist
Global $verbose = True
If $verbose Then CreateTraceGui()

;TCP
Global $IMAPsocket
Global $maxlen = 64
Global $SendCounter = 0

;IMAP Server Info
$IMAPserver = InputBox("", "IMAP Server", "imap.aol.com")
$IMAPport = InputBox("", "IMAP Server Port Number", "143")

;User Info
$UserName = InputBox("", "UserName", "")
$Password = InputBox("", "Password", "")

;Mailbox
$MailBox = '"INBOX"'
$GetType = 'Recent' ;Recent or Seen  ;*Select the opposite*

;////////////Program Start///////////////////

;Connect To Server
IMAPConnectToServer($IMAPserver, $IMAPport)


IMAPLogin()


IMAPSendData('select ' & $MailBox)
IMAPRecvData($SendCounter & ' OK')

;###GET MAIL LIST###
Local $SMTPSendMail[1] ;command sent to smtp sever
Local $SMTPSendList[1] ;command sent to smtp sever
_ArrayAdd($SMTPSendList, 'fetch 1:* (FLAGS)')

For $i = 1 To (UBound($SMTPSendList) - 1) Step + 1
	IMAPSendData($SMTPSendList[$i])
	$Recieved = IMAPRecvData()
	$temp = StringSplit($Recieved, @CRLF)
	For $j = 1 To $temp[0] Step + 1
		If StringInStr($temp[$j], $GetType & " ") Then
		ElseIf StringInStr($temp[$j], "FETCH") Then
			$tempLocal = StringSplit($temp[$j], "* ", 1)
			$tempLocal = StringSplit($tempLocal[$tempLocal[0]], " FETCH", 1)
			If StringIsDigit($tempLocal[1]) Then
				_ArrayAdd($SMTPSendMail, 'FETCH ' & $tempLocal[1])
			EndIf
		EndIf
	Next
Next

;###GET MAIL###
Local $body[1] ;Email Body & Headers

For $i = 1 To (UBound($SMTPSendMail) - 1) Step + 1
	$verbose = True
	IMAPSendData($SMTPSendMail[$i] & " body[]")
	VerboseTrace("<RECV>" & @CRLF & "*******************************" & @CRLF & "Downloading Email Body" & @CRLF & "*******************************" & @CRLF & @CRLF)
	$verbose = False
	Sleep(10)
	$temp = IMAPRecvData(@CRLF & $SendCounter & " OK FETCH completed")
	$tempLocal = StringSplit($temp, @CRLF, 1)
	$temp = ""
	;strip server reply info
	For $k = 2 To ($tempLocal[0] - 3) Step + 1
		$temp = $temp & $tempLocal[$k] & @CRLF
	Next

	_ArrayAdd($body, $temp & @CRLF & @CRLF & @CRLF & @CRLF & @CRLF & @CRLF)
	$verbose = True
Next


IMAPWriteFile()


;Logout
IMAPSendData('logout')
IMAPRecvData()
MsgBox(0, "", "Closing This closes the trace window!" & @CRLF & "Emails Located in this file" & @CRLF & @ScriptDir & "\Body.txt")



;///////////////////Start Of Functions///////////////////////

;Login
Func IMAPLogin()
	;###START_COMMANDS###
	IMAPSendData('capability')
	$temp = IMAPRecvData($SendCounter & ' OK CAPABILITY', 64)
	If @error Then
		MsgBox(0, "", "Not IMAP Server")
		Exit
	EndIf
	
	If StringInStr($temp, "AUTH=PLAIN") Then
		IMAPSendData('authenticate plain')
		IMAPRecvData('+', 64)
		If @error Then
			MsgBox(0, "", "Can Not Authenticate")
			Exit
		EndIf
		IMAPSendData(_Base64Encode (Chr(0) & $UserName & Chr(0) & $Password), 1)
		IMAPRecvData('OK AUTHENTICATE', 64)
		If @error Then
			MsgBox(0, "", "Bad UserName/Password")
			Exit
		EndIf
	Else
		IMAPSendData('login "' & $UserName & '" "' & $Password & '"')
		IMAPRecvData('OK LOGIN', 64)
	EndIf
EndFunc   ;==>IMAPLogin

;Write To File
Func IMAPWriteFile()
	FileDelete("Body.txt")
	_FileWriteFromArray("Body.txt", $body)
EndFunc   ;==>IMAPWriteFile


;Connect to IMAP Server
Func IMAPConnectToServer($IMAPserver, $IMAPport)
	TCPStartup()
	$IMAPsocket = TCPConnect(TCPNameToIP($IMAPserver), $IMAPport)
	If $IMAPsocket = -1 Then MsgBox(0, "", "Could Not Connect")
	IMAPRecvData() ;clear input buffer
EndFunc   ;==>IMAPConnectToServer


;Send IMAP TCP Data
Func IMAPSendData($temp, $RemoveCounter = "")
	If $RemoveCounter = "" Then
		$SendCounter += 1
		$temp = $SendCounter & " " & $temp & @CRLF
	Else
		$temp = $temp & @CRLF
	EndIf
	
	TCPSend($IMAPsocket, $temp)
	If $verbose Then VerboseTrace("<SEND>" & @CRLF & $temp & @CRLF)
EndFunc   ;==>IMAPSendData



;Recieve IMAP TCP Data
;$matchString = Look for a string in the data recieved.
;$matchStringNum = How far from the end should it look forward.
Func IMAPRecvData($matchString = "", $matchStringNum = "")
	$temp = ""
	$count = 0
	
	For $k = 0 To 3 Step + 1
		While $count <= 10
			$tempLocal = TCPRecv($IMAPsocket, $maxlen)
			
			$temp = $temp & $tempLocal
			ToolTip("Bytes: " & StringLen($temp))
			
			;make sure recieved buffer isn't at max and that data was recieved
			If StringLen($tempLocal) = $maxlen Then
				If StringInStr(StringRight($temp, 64), $matchString, 1, 1) Then ExitLoop
				ContinueLoop
			ElseIf $tempLocal = "" Then
				Sleep(250)
				$count += 1
				ContinueLoop
			Else
				ExitLoop
			EndIf
		WEnd
	Next
	
	;If $count >= 10 Then VerboseTrace("<RECV>" & @CRLF & "*************************************************************************************************Timed Out" & @CRLF)
	If $matchStringNum = "" Then $matchStringNum = StringLen($temp)
	If $verbose Then VerboseTrace("<RECV>" & @CRLF & $temp & @CRLF)
	If $matchString <> "" And $matchStringNum < (StringLen($temp) - StringInStr($temp, $matchString, 0, 1)) Then SetError(1)

	Return $temp
EndFunc   ;==>IMAPRecvData


;Run when Program Ends
Func endscript()
	TCPShutdown()
EndFunc   ;==>endscript

;Create The Trace Gui
Func CreateTraceGui()
	GUICreate("Command Trace", 660, 400)
	$mylist = GUICtrlCreateEdit("", -1, -1, 660, 400)
	GUISetState()
EndFunc   ;==>CreateTraceGui

;Add Text To Trace Window
Func VerboseTrace($temp)
	GUICtrlSetData($mylist, $temp, 1)
EndFunc   ;==>VerboseTrace