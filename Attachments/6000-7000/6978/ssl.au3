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

opt("OnExitFunc", "endscript")
opt("SendKeyDelay", 0)

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

;set server info
$SSL_Exe_loc = "C:\OpenSSL\bin\openssl.exe"
$SMTP_Server = "smtp.gmail.com"
$SMTP_Port = "465"

GUICreate("Command Trace", 660, 400)
$mylist = GUICtrlCreateEdit("", -1, -1, 660, 400)

;set temp files
$tempFileA = "C:\OpenSSL\temp.txt"
$tempFileB = "C:\OpenSSL\test.bat"

;clean up from last run
FileDelete($tempFileB)
FileDelete($tempFileA)

;write bat file
$file = FileOpen($tempFileB, 2)
FileWriteLine($file, $SSL_Exe_loc & ' s_client' & ' -crlf -connect ' & $SMTP_Server & ':' & $SMTP_Port & ' -ign_eof')
FileClose($file)

;run bat with output sent to $tempFileA
Run($tempFileB & ' 1<&2 >' & $tempFileA)

;wait for window to popup
WinWait(@SystemDir & "\cmd.exe")
Dim $aArray
$FileSized = 0

;###HIDES THE WINDOW### comment this line out to see the cmd window
WinMove(@SystemDir & "\cmd.exe", "", @DesktopWidth, @DesktopHeight)

GUISetState()

;set var's to 0
$State_R = 0
$FileLineStart = 0
$new = 0
While 1
	Sleep(50)
	While FileGetSize($tempFileA) < 200
		Sleep(100)
	WEnd
	
	_FileReadToArray($tempFileA, $aArray)
	$new = 0
	While $FileSized < UBound($aArray) - 1
		If $FileSized < 45 Then
			$FileSized = 45 ;skip the first 45 lines of the txt file
		EndIf
		If $aArray[UBound($aArray) - 2] <> "" Then
			;write to gui
			_SmtpTrace($aArray[$FileSized])
		EndIf
		$new = 1
		$FileSized = $FileSized + 1
	WEnd
	
	If $new = 1 Then
		For $i = $FileLineStart To UBound($aArray) - 1 Step + 1
			If StringInStr($aArray[$i], "220") And $State_R = 0 Then
				BlockInput(1)
				WinActivate(@SystemDir & "\cmd.exe")
				WinWaitActive(@SystemDir & "\cmd.exe")
				Send("ehlo " & @ComputerName & "{ENTER}")
				BlockInput(0)
				$State_R = 1
				$FileLineStart = $i + 1
			ElseIf StringInStr($aArray[$i], "250") And $State_R = 1 Then
				BlockInput(1)
				WinActivate(@SystemDir & "\cmd.exe")
				WinWaitActive(@SystemDir & "\cmd.exe")
				Send("AUTH LOGIN{ENTER}")
				BlockInput(0)
				$State_R = 2
				$FileLineStart = $i + 1
			ElseIf StringInStr($aArray[$i], "334") And $State_R = 2 Then
				$aaa = StringSplit($s_FromAddress, "@")
				$Base64Text = _Base64Encode (InputBox("Gmail", "Enter Username", $aaa[1]))
				BlockInput(1)
				WinActivate(@SystemDir & "\cmd.exe")
				WinWaitActive(@SystemDir & "\cmd.exe")
				Send($Base64Text & "{ENTER}")
				BlockInput(0)
				$State_R = 3
				$FileLineStart = $i + 1
			ElseIf StringInStr($aArray[$i], "334") And $State_R = 3 Then
				$Base64Text = _Base64Encode (InputBox("Gmail", "Enter Password", "", "*"))
				BlockInput(1)
				WinActivate(@SystemDir & "\cmd.exe")
				WinWaitActive(@SystemDir & "\cmd.exe")
				Send($Base64Text & "{ENTER}")
				BlockInput(0)
				$State_R = 4
				$FileLineStart = $i + 1
			ElseIf StringInStr($aArray[$i], "235") And $State_R = 4 Then
				BlockInput(1)
				WinActivate(@SystemDir & "\cmd.exe")
				WinWaitActive(@SystemDir & "\cmd.exe")
				Send("MAIL FROM: <" & $s_FromAddress & ">{ENTER}")
				BlockInput(0)
				$State_R = 5
				$FileLineStart = $i + 1
			ElseIf StringInStr($aArray[$i], "250") And $State_R = 5 Then
				BlockInput(1)
				WinActivate(@SystemDir & "\cmd.exe")
				WinWaitActive(@SystemDir & "\cmd.exe")
				Send("RCPT TO: <" & $s_ToAddress & ">{ENTER}")
				BlockInput(0)
				$State_R = 6
				$FileLineStart = $i + 1
			ElseIf StringInStr($aArray[$i], "250") And $State_R = 6 Then
				BlockInput(1)
				WinActivate(@SystemDir & "\cmd.exe")
				WinWaitActive(@SystemDir & "\cmd.exe")
				Send("DATA{ENTER}")
				BlockInput(0)
				$State_R = 7
				$FileLineStart = $i + 1
			ElseIf StringInStr($aArray[$i], "354") And $State_R = 7 Then
				BlockInput(1)
				WinActivate(@SystemDir & "\cmd.exe")
				WinWaitActive(@SystemDir & "\cmd.exe")
				Send("From:" & $s_FromName & "<" & $s_FromAddress & ">{ENTER}" & _
						"To:" & "<" & $s_ToAddress & ">{ENTER}" & _
						"Subject:" & $s_Subject & "{ENTER}" & _
						"Mime-Version: 1.0{ENTER}" & _
						"Content-Type: text/plain; charset=US-ASCII{ENTER}" & _
						"{ENTER}")
				For $i_Count = 0 To (UBound($as_Body) - 1) Step + 1
					If StringLeft($as_Body[$i_Count], 1) = "." Then $as_Body[$i_Count] = "." & $as_Body[$i_Count]
					Send($as_Body[$i_Count] & "{ENTER}")
				Next
				Send("{ENTER}.{ENTER}")
				BlockInput(0)
				$State_R = 8
				$FileLineStart = $i + 1
			ElseIf StringInStr($aArray[$i], "250") And $State_R = 8 Then
				BlockInput(1)
				WinActivate(@SystemDir & "\cmd.exe")
				WinWaitActive(@SystemDir & "\cmd.exe")
				Send("QUIT{ENTER}")
				BlockInput(0)
				$State_R = 9
				$FileLineStart = $i + 1
				MsgBox(0, "Mail", "Mail was sent!")
				ExitLoop 2
			EndIf
		Next
	EndIf
WEnd

Func _SmtpTrace($s_DisplayString)
	GUICtrlSetData($mylist, $s_DisplayString & @CRLF, 1)
EndFunc   ;==>_SmtpTrace

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