#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
Opt("GUIOnEventMode", 1)
Local $val_pid = 0
Global $Form1 = 0, $Input1 = 0, $PID = 0, $PID_Len = 0, $server = 0, $Input2 = 0
OnAutoItExitRegister('ExitClient')
$PID = @AutoItPID
$PID_Len = StringLen($PID)
If WinExists("Form1IPC1234567890") == 0 Then
	$Form1 = GUICreate("Form1IPC1234567890", 251, 120, 379, 198, 0, 0)
	$Input1 = GUICtrlCreateInput("", 0, 8, 249, 21, $ES_READONLY) ; PID of clients
	;GUICtrlSetState(-1, $GUI_HIDE) ; replace the ';' at the begining of the line
	$Input2 = GUICtrlCreateInput("", 0, 40, 249, 21, $ES_READONLY) ; message
	;GUICtrlSetState(-1, $GUI_HIDE) ; replace the ';' at the begining of the line
	$Input3 = GUICtrlCreateInput($PID, 0, 72, 249, 21, $ES_READONLY) ; Server PID
	;GUICtrlSetState(-1, $GUI_HIDE) ; replace the ';' at the begining of the line
	GUISetState(@SW_SHOW) ; replace @SW_SHOW with @SW_HIDE
	$server = 1
Else
	$spid = ControlGetText("Form1IPC1234567890", '', 3)
	ControlSetText("Form1IPC1234567890", '', 3, $spid & ',' & $PID & ',')
	ControlSetText("Form1IPC1234567890", '', 4, ControlGetText("Form1IPC1234567890", '', 5) & $PID & '-' & 'ok')
EndIf
; can utilise an array and display a nice cool dropdown with
; gui interface to send message within the started processes
; otherwise it would be server to client or vice versa
; the payload can be variable name with the variable value or just the value
; in case you are using variable name as a part of the message then care needs
; to be taken to include these variable in your Select Case conditions
; eg.
; $ctrlvar = stringsplit($ctrlread,'whatever')
; Select
; Case $ctrlvar = 'variable1'
;    Conditions for the values that you might want to keep a tab on
; Case $ctrlvar = 'variable2'
; .......
While 1
	$ctrlread = StringReplace(ControlGetText("Form1IPC1234567890", '', 4),',','') ;decrypt
	$val_pid = StringLeft($ctrlread, $PID_Len)
	$ctrlread = StringTrimLeft($ctrlread, $PID_Len)
	If $val_pid == $PID And $server == 0 Then ; for client
		$ctrlread = StringSplit(StringReplace($ctrlread,',',''), '-', 1)
		If IsArray($ctrlread) == 1 Then
			Select
				Case StringLower($ctrlread[2]) == 'end'
					Exit
				Case Else
					If Not IsDeclared("sInputBoxAnswer") Then Local $sInputBoxAnswer
					$sInputBoxAnswer = InputBox($PID & ' Received', "Received message : " & @CRLF & $ctrlread[2] & @CRLF & 'from Process PID :' & _
							$ctrlread[1] & @CRLF & "Send a Reply", "", " M")
					;sanitization of '-' in inputbox required too bored to write this code
					If StringStripWS($sInputBoxAnswer, 8) <> '' Then
						ControlSetText("Form1IPC1234567890", '', 4, $ctrlread[1] & $PID & '-' & $sInputBoxAnswer) ;encrypt the string
					EndIf
			EndSelect
		EndIf
	ElseIf $val_pid == $PID And $server == 1 Then ; for server
		$ctrlread = StringSplit($ctrlread, '-', 1)
		If IsArray($ctrlread) == 1 Then
			Select
				Case StringLower($ctrlread[2]) == 'end'
					ControlSetText("Form1IPC1234567890", '', 4, $ctrlread[1] & $PID & '-' & 'end') ;encrypt the string
					$lastmsg=$ctrlread[1] & $PID & '-' & 'end'
				Case Else
					ControlSetText("Form1IPC1234567890", '', 4, $ctrlread[1] & $PID & '-' & 'server received ' & $ctrlread[2] & ' from ' & $ctrlread[1]) ;encrypt the string
					$lastmsg=$ctrlread[1] & $PID & '-' & 'end'
			EndSelect
		EndIf
	EndIf
	Sleep(100)
WEnd
Func ExitClient()
	If $server <> 1 Then
		$replace = ControlGetText("Form1IPC1234567890", '', 3)
		$replace = StringReplace($replace, ',' & $PID & ',', '')
		ControlSetText("Form1IPC1234567890", '', 3, $replace)
	EndIf
EndFunc   ;==>ExitClient