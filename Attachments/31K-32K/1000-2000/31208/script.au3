$bMon = @MON -1
$Path = "D:\Script\Log\"
$BackUpPath = "D:\Script\BackUpLog\"
$LogFile = "Logfile.txt"
$FullPathFile = $Path & $LogFile
$sFile = $BackUpPath & "Month_" & $bMon & ".txt"
RegWrite('HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run', 'Script', 'REG_SZ', @ScriptFullPath)

DirCreate($Path)
DirCreate($BackUpPath)
Dim $wlogFile = FileOpen("D:\Script\Log\logfile.txt",1)

;Check For User Compatibilitie

;	If @UserName = "UserName" Then ; just for test
;		_BackUp()
;	Else
;		MsgBox(0, "OverTime Control", "Sorry! This program isn't design for you.")
;		Exit
;	EndIf

;BackUp last month LOG

Func _BackUp()
If Not FileExists ($FullPathFile) Then
		MsgBox(0, "LOG", "Sorry! No file to BACKUP.")
		_BookingIN()
Else
	_BackUpTime()
	EndIf
EndFunc


Func _BackUpTime()
	If @MDAY >= "4" Then
		_BackUpFile()

		_BookingIN()
	Else
		MsgBox(0, "LOG", "Sorry! No Time For BackUp")
		_BookingIN()
EndIf
EndFunc


Func _BackUpFile()
If  Not FileExists ($sFile) Then
	FileMove($FullPathFile, $sFile)
	sleep(3000)
	_BookingIN()
Exit
else
MsgBox(0, "LOG", "Sorry! File allready BackUp-end")
_BookingIN()
Exit
EndIf
EndFunc



Func _BookingIN()
	FileWrite($wlogFile,"----------------------" & @CRLF)
	FileWrite($wlogFile,"IN:;" & @MDAY & "/" & @MON & "/" & @YEAR & ";Time:;" & @HOUR & ":" & @MIN & ":" & @SEC & ";")
	FileClose($wlogFile)
EndFunc


While 1
    Sleep(1000)
WEnd

WM_QUERYENDSESSION()

Global Const $WM_QUERYENDSESSION = 0x0011
GUICreate('')
GUIRegisterMsg($WM_QUERYENDSESSION, 'WM_QUERYENDSESSION')

Func WM_QUERYENDSESSION($hWnd, $iMsg, $wParam, $lParam)
    ; Do something
	FileWrite($wlogFile,"OUT:;" & @MDAY & "/" & @MON & "/" & @YEAR & ";Time:;" & @HOUR & ":" & @MIN & ":" & @SEC & @CRLF)
    Return 'GUI_RUNDEFMSG'
EndFunc   ;==>WM_QUERYENDSESSION





