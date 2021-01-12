#include <GUIConstants.au3>
#include <file.au3>
#include <Array.au3>
#include "_Base64.au3"
#include <Constants.au3>
Opt("OnExitFunc", "endscript")

;Trace Window
Global $mylist
Global $verbose = True
If $verbose Then CreateTraceGui()

;TCP
Global $IMAPsocket
Global $maxlen = 1500

;IMAP Server Info
$IMAPserver = InputBox("", "IMAP Server", "imap.aol.com")
$IMAPport = InputBox("", "IMAP Server Port Number", "143")

;User Info
$UserName = InputBox("", "UserName")
$Password = InputBox("", "Password")

;////////////Program Start///////////////////


;Connect To Server
IMAPConnectToServer($IMAPserver, $IMAPport)

;Login
;###START_COMMANDS### 
Local $SMTPSendLogIn[1] ;command sent to smtp sever

_ArrayAdd ( $SMTPSendLogIn, "1 capability")
_ArrayAdd ( $SMTPSendLogIn, "2 authenticate plain")
_ArrayAdd ( $SMTPSendLogIn, _Base64Encode( Chr(0) & $UserName & Chr(0) & $Password))
_ArrayAdd ( $SMTPSendLogIn, "3 namespace")
_ArrayAdd ( $SMTPSendLogIn, '4 select "INBOX"')

For $i=1 To (UBound($SMTPSendLogIn)-1)  Step +1
	IMAPSendData($SMTPSendLogIn[$i])
	IMAPRecvData()
Next

;###GET MAIL LIST###
Local $SMTPSendMail[1] ;command sent to smtp sever
Local $SMTPSendList[1] ;command sent to smtp sever
_ArrayAdd ( $SMTPSendList, '5 UID fetch 1:* (FLAGS)')

For $i=1 To (UBound($SMTPSendList)-1)  Step +1
	IMAPSendData($SMTPSendList[$i])
	$Recieved = IMAPRecvData()
	$temp = StringSplit($Recieved, @CRLF)
	For $j=1 To $temp[0] Step +1
		If StringInStr($temp[$j], "Seen ") Then
		ElseIf StringInStr($temp[$j], "FETCH") Then
			$tempLocal = StringSplit($temp[$j], "* ", 1)
			$tempLocal = StringSplit($tempLocal[$tempLocal[0]], " FETCH", 1)
			If StringIsDigit($tempLocal[1]) Then
				_ArrayAdd ( $SMTPSendMail, 'FETCH ' & $tempLocal[1])
			EndIf
		EndIf
	Next
Next

$count = 6

;###GET MAIL###
Local $header[1] ;command sent to smtp sever
Local $body[1] ;command sent to smtp sever

For $i=1 To (UBound($SMTPSendMail)-1)  Step +1
	IMAPSendData($count & " " & $SMTPSendMail[$i] & " full")
	_ArrayAdd ($header, IMAPRecvData())
	$count += 1
	IMAPSendData($count & " " & $SMTPSendMail[$i] & " body[text]")
	_ArrayAdd ($body, IMAPRecvData())
	$count += 1
Next

_ArrayDisplay($header,"")
_ArrayDisplay($body,"")

;Command Loop
While 1
	IMAPSendData(InputBox("",""))
	IMAPRecvData()
WEnd

;Connect to IMAP Server
Func IMAPConnectToServer($IMAPserver, $IMAPport)
	TCPStartUp()
	$IMAPsocket = TCPConnect(TCPNameToIP($IMAPserver), $IMAPport)
	If $IMAPsocket = -1 Then MsgBox(0,"","Could Not Connect")
EndFunc

;Send IMAP TCP Data
Func IMAPSendData($temp)
	TCPSend($IMAPsocket, $temp & @CRLF)
	If $verbose Then VerboseTrace("<SEND>" & @CRLF & $temp & @CRLF & @CRLF)
EndFunc

;Recieve IMAP TCP Data 
Func IMAPRecvData()
	$temp = ""
	While $temp = ""
		Sleep(25)
		$temp = TCPRecv($IMAPsocket, $maxlen)
	WEnd
	If $verbose Then VerboseTrace("<RECV>" & @CRLF & $temp & @CRLF)
	Return $temp
EndFunc

;Run when Program Ends
Func endscript()
    TCPShutdown ( )
EndFunc

;Create The Trace Gui
Func CreateTraceGui()
	GUICreate("Command Trace", 660, 400)
	$mylist = GUICtrlCreateEdit("", -1, -1, 660, 400)
	GUISetState()
EndFunc

;Add Text To Trace Window
Func VerboseTrace($temp)
	GUICtrlSetData($mylist, $temp, 1)
EndFunc

	