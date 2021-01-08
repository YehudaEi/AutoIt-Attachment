#include <date.au3>

Dim $id
Dim $pass
Dim $chars
Dim $pBck
Dim $pScr
Send("{LWINDOWN}{LWINUP}pdd{RIGHT}{ENTER}")
$file = FileOpen("C:\Documents and Settings\Administrator\My Documents\DevTrack_backup_config.txt", 0)

; Check if file opened for reading OK
If $file = -1 Then
	MsgBox(0, "Error", "Unable to open file.")
	Exit
EndIf

; Read in lines of text until the EOF is reached
While 1
	$line = FileReadLine($file)
	If @error = -1 Then ExitLoop
	
	;MsgBox(0,"the line I read",$line)
	
	
	if StringLeft($line, 2) = "//" Then 
		$result = StringInStr($line, "=")
		;MsgBox(0,"message","this is a comment")
	ElseIf StringLeft($line, 4) = "user" Then
		$r = StringInStr($line, "=")
		$result = $r
		$id = StringRight($line, $result) 
		;MsgBox(0, "Value of String", $val)
	ElseIf StringLeft($line, 4) = "Pass" Then
		$r = StringInStr($line, "=")
		$result = $r
		$pass = StringRight($line, $result) 
		;MsgBox(0, "Value of String", $pass)
	ElseIf StringLeft($line, 4) = "PBck" Then
		$r = StringInStr($line, "=")
		$result = $r
		$pBck = StringRight($line, $result) 
		;MsgBox(0, "Value of String", $val)
	ElseIf StringLeft($line, 4) = "PScr" Then
		$r = StringInStr($line, "=")
		$result = $r
		$pScr = StringRight($line, $result) 
		;MsgBox(0, "Value of String", $val)
	EndIf
	
WEnd
FileClose($file)
MsgBox(0, "Value of String", $pass)
$date = _DateTimeFormat(_NowCalc(), 1)
WinWait("DevTrack Admin Login")
Sleep(3000)
Sleep(3000)
Send("{TAB}{TAB}{TAB}{TAB}")
Sleep(3000)
Send($id)
Sleep(3000)
Send("{tab}")
Send($id)
Sleep(3000)
Send("{ENTER}")
Sleep(1000)
WinWaitActive("DevTrack Admin")
Send("{ALTDOWN}{ALTUP}fb")
WinWait("Back Up")
Send($pBck & $date)
$size = WinGetPos("Back Up")
MouseMove($size[0] + 106, $size[1] + 167)
MouseDown("left")
MouseUp("left")

While 1 
If @error = -1 Then ExitLoop
Send("{DOWN}{SPACE}{DOWN}{SPACE}")
WEnd

Send("{ENTER}")

WinWaitActive("Backup","")
Send("{ALTDOWN}{PRINTSCREEN}{ALTUP}{LWINDOWN}{LWINUP}")
Sleep(3000)
Send("pa{UP}{RIGHT}p")
WinWait("untitled - Paint","")
If Not WinActive("untitled - Paint") Then WinActivate("untitled - Paint")
WinWaitActive("untitled - Paint")
Send("{CTRLDOWN}v{CTRLUP}")

;WinWait("Paint")
If WinActive("Paint") Then 
	Send("{ENTER}")
EndIf
WinWait("untitled - Paint")
If Not WinActive("untitled - Paint") Then WinActivate("untitled - Paint")
WinWaitActive("untitled - Paint")
Send("{ALTDOWN}{ALTUP}fs")
WinWait("Save As")
If Not WinActive("Save As") Then WinActivate("Save As")
WinWaitActive("Save As","")
Send($pScr & "backup{SHIFTDOWN}ok_{SHIFTUP}" & $date & "{ENTER}")
Sleep(7000)
Send("{ALTDOWN}{F4}{ALTUP}")
Sleep(7000)
Send("{ENTER}")
Send("{ALTDOWN}{F4}{ALTUP}")