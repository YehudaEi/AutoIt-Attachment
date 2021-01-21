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
;set Login info
$User = InputBox("Gmail", "Enter Username", "")
$Pass = InputBox("Gmail", "Enter Password", "", "*")

;set server info
$SSL_Exe_loc = "C:\OpenSSL\bin\openssl.exe"
$SMTP_Server = "pop.gmail.com"
$SMTP_Port = "995"

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
			If StringInStr($aArray[$i], "+OK") And $State_R = 0 Then
				BlockInput(1)
				WinActivate(@SystemDir & "\cmd.exe")
				WinWaitActive(@SystemDir & "\cmd.exe")
				Send("USER " & $User & "{ENTER}")
				BlockInput(0)
				$State_R = 1
				$FileLineStart = $i + 1
			ElseIf StringInStr($aArray[$i], "+OK") And $State_R = 1 Then
				BlockInput(1)
				WinActivate(@SystemDir & "\cmd.exe")
				WinWaitActive(@SystemDir & "\cmd.exe")
				Send("PASS " & $Pass & "{ENTER}")
				BlockInput(0)
				$State_R = 2
				$FileLineStart = $i + 1
			ElseIf StringInStr($aArray[$i], "+OK") And $State_R = 2 Then
				BlockInput(1)
				WinActivate(@SystemDir & "\cmd.exe")
				WinWaitActive(@SystemDir & "\cmd.exe")
				Send("STAT{ENTER}")
				BlockInput(0)
				$State_R = 3
				$FileLineStart = $i + 1
			ElseIf StringInStr($aArray[$i], "+OK") And $State_R = 3 Then
				BlockInput(1)
				WinActivate(@SystemDir & "\cmd.exe")
				WinWaitActive(@SystemDir & "\cmd.exe")
				Send("LIST{ENTER}")
				BlockInput(0)
				$State_R = 4
				$FileLineStart = $i + 1
			
			ElseIf StringInStr($aArray[$i], ".") And $State_R = 4 Then
				BlockInput(1)
				WinActivate(@SystemDir & "\cmd.exe")
				WinWaitActive(@SystemDir & "\cmd.exe")
				Send("RETR 1{ENTER}")
				BlockInput(0)
				$State_R = 5
				$FileLineStart = $i + 1
			ElseIf StringInStr($aArray[$i], ".") And $State_R = 5 Then ;I need better Dection Here
				Sleep(250)
				BlockInput(1)
				WinActivate(@SystemDir & "\cmd.exe")
				WinWaitActive(@SystemDir & "\cmd.exe")
				Send("QUIT{ENTER}")
				BlockInput(0)
				$State_R = 6
				$FileLineStart = $i + 1
			ElseIf StringInStr($aArray[$i], "+OK") And $State_R = 6 Then
				$State_R = 7
				$FileLineStart = $i + 1
				MsgBox(0, "Mail", "Mail Checked!" & @CRLF & "Program Closing...")
				FileDelete($tempFileB)
				FileDelete($tempFileA)
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