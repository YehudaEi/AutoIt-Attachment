; ----------------------------------------------------------------------------
;
; AutoIt Version: 3.1.0
; Author:         A.N.Other <myemail@nowhere.com>
;
; Script Function:
;	Template AutoIt script.
;
; ----------------------------------------------------------------------------

; Script Start - Add your code below here
#include <file.au3>
#include <Array.au3>
#include "_Base64.au3"
#include <Constants.au3>

opt("OnExitFunc", "endscript")
opt("SendKeyDelay", 0)
Opt("TrayIconDebug", 1)

;kill previous run
While ProcessExists("openssl.exe")
	ProcessClose("cmd.exe")
	ProcessClose("openssl.exe")
WEnd

;###FILL IN THIS INFO###
;set message info
$s_FromAddress = "@gmail.com"
$s_ToAddress = "@usc.edu"
$s_FromName = "User"
$s_Subject = "UDF Test"
Dim $as_Body[2]
$as_Body[0] = "Testing the new email udf"
$as_Body[1] = "Second Line"

;build body of email
$BodyString = ""
For $i = 0 To UBound($as_Body)-1 Step +1
	$BodyString = $BodyString & $as_Body[$i] & @CRLF
Next

;set server info
$SSL_Exe_loc = "C:\OpenSSL\bin\openssl.exe"
$SMTP_Server = "smtp.gmail.com"
$SMTP_Port = "465"


;###START_COMMANDS### 
Local $as_Send[1] ;command sent to smtp sever
Local $as_ReplyCode[1] ;Return code from SMTP server indicating success 250 334 ect...

_ArrayAdd ( $as_ReplyCode, "220 ")
_ArrayAdd ( $as_Send, "ehlo " & @ComputerName)
_ArrayAdd ( $as_ReplyCode, "250 ")

_ArrayAdd ( $as_Send, "AUTH LOGIN" & @CRLF)
_ArrayAdd ( $as_ReplyCode, "334 ")

$aaa = StringSplit($s_FromAddress, "@")
$s_UserName = _Base64Encode (InputBox("Gmail", "Enter Username", $aaa[1]))
_ArrayAdd ( $as_Send, $s_UserName & @CRLF)
_ArrayAdd ( $as_ReplyCode, "334 ")

$s_Password = _Base64Encode (InputBox("Gmail", "Enter Password", "", "*"))
_ArrayAdd ( $as_Send, $s_Password & @CRLF)
_ArrayAdd ( $as_ReplyCode, "235 ")

_ArrayAdd ( $as_Send, "MAIL FROM: <" & $s_FromAddress & ">" & @CRLF)
_ArrayAdd ( $as_ReplyCode, "250 ")

_ArrayAdd ( $as_Send, "RCPT TO: <" & $s_ToAddress & ">" & @CRLF)
_ArrayAdd ( $as_ReplyCode, "250 ")

_ArrayAdd ( $as_Send, "DATA" & @CRLF)
_ArrayAdd ( $as_ReplyCode, "354 ")

_ArrayAdd ( $as_Send, "From:" & $s_FromName & "<" & $s_FromAddress & ">" & @CRLF & _
	"To:" & "<" & $s_ToAddress & ">" & @CRLF & _
	"Subject:" & $s_Subject & @CRLF & _
	"Mime-Version: 1.0" & @CRLF & _
	"Content-Type: text/plain; charset=US-ASCII" & @CRLF & _
	@CRLF & $BodyString & _
	@CRLF & @CRLF & "." & @CRLF)
_ArrayAdd ( $as_ReplyCode, "250 ")

_ArrayAdd ( $as_Send, "QUIT" & @CRLF)
;###END_COMMANDS### 

GUICreate("Command Trace", 660, 400)
$mylist = GUICtrlCreateEdit("", -1, -1, 660, 400)

$RunPID = Run(@ComSpec & " /c " & $SSL_Exe_loc & " s_client -crlf -ign_eof -connect " & $SMTP_Server & ":" & $SMTP_Port, "", @SW_HIDE, $STDOUT_CHILD + $STDIN_CHILD)
WinWait(@SystemDir & "\cmd.exe")
WinMove(@SystemDir & "\cmd.exe", "", @DesktopWidth, @DesktopHeight)
WinSetState(@SystemDir & "\cmd.exe", "", @SW_HIDE)
GUISetState()
;set var's to 0
$State_R = 1
$FileLineStart = 0
$new = 0
$LastLoop = 0

;The Brains
While 1
	$InBufferSize = StdoutRead($RunPID, "", True)
	If $InBufferSize <> $LastLoop Then
		$LastLoop = $InBufferSize
		$Counter = 0
		While 1
			$temp = StdoutRead($RunPID, StdoutRead($RunPID, "", True), True)
			If $Counter > 50 Then ;its been 5 seconds, no reply display error
				MsgBox(0, "ERROR!", "Got This:" & $temp & @CRLF & "Was Looking For This:" & $as_ReplyCode[$State_R] & @CRLF & @CRLF & "State:" & $State_R)
			EndIf
			If $State_R = 1 Then ;Bug fix, it wont take the first command. it needs it from the keyboard.
				$Read = StdoutRead($RunPID) ;flush buffer
				_TraceRun("<RECV> " & $Read )
				StdinWrite($RunPID, $as_Send[$State_R] & @CRLF)
				_TraceRun("<SEND> " & $as_Send[$State_R] & @CRLF)
				$State_R = $State_R + 1
				WinSetState(@SystemDir & "\cmd.exe", "", @SW_SHOW)
				BlockInput(1)
				WinActivate(@SystemDir & "\cmd.exe")
				WinWaitActive(@SystemDir & "\cmd.exe")
				;Sleep(250)
				Send($as_Send[$State_R] & "{ENTER}")
				BlockInput(0)
				WinSetState(@SystemDir & "\cmd.exe", "", @SW_HIDE)
				ExitLoop
			ElseIf StringInStr($temp, $as_ReplyCode[$State_R]) Then
				$Read = StdoutRead($RunPID) ;flush buffer
				_TraceRun("<RECV> " & $Read )
				StdinWrite($RunPID, $as_Send[$State_R])
				_TraceRun("<SEND> " & $as_Send[$State_R])
				$State_R = $State_R + 1
				ExitLoop
			Else
				;StdinWrite($RunPID, @LF & "ehlo" & @LF)
				;_TraceRun("<SEND> " & "ehlo" & @CRLF)
				Sleep(100)
			EndIf
			$Counter = $Counter + 1
		WEnd
	EndIf
	
	If $State_R = UBound($as_ReplyCode) Then
		ExitLoop
	EndIf
	Sleep(50)
WEnd

Func _TraceRun($s_DisplayString)
	GUICtrlSetData($mylist, $s_DisplayString, 1)
EndFunc   ;==>_TraceRun

MsgBox(0, "", "DONE!" & @CRLF & "Program Closing")

Func endscript()
	If ProcessExists("openssl.exe") Then
		$s = MsgBox(4, "Kill Child Processes?", "Do you want to kill the command prompt and openssl?")
		If $s = 6 Then
			ProcessClose("cmd.exe")
			ProcessExists("openssl.exe")
			While ProcessExists("openssl.exe")
				ProcessClose("cmd.exe")
				ProcessClose("openssl.exe")
			WEnd
		EndIf
	EndIf
EndFunc   ;==>endscript