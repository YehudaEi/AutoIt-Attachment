; Auto Torrent - Version 3
; Author uzi17

; Making code more smooth

#include <Misc.au3>
#include <Date.au3>

HotKeySet("{Esc}", "_Exit")
HotKeySet("{Home}", "pos")
HotKeySet("{End}", "pos1")

Local $x = 20
Local $y = 20
Local $pos = 1
Local $opened = 0
Local $closed = 0
$currentTime = _NowTime(4)

;-------------------------------------------- Prompts -----------------------------------------------------
Local $openTime = InputBox("File Open Time", "Enter the time to start in 24-hour time" & @CRLF & "Current time is: " & _NowTime(4),_NowTime(4))
Local $closeTime = InputBox("File Close Time", "Enter the time to close in 24-hour time" & @CRLF & "Current time is: " & _NowTime(4), $openTime)
Local $file = InputBox("File Path", "Enter the path of file to open", "C:\Program Files\uTorrent\utorrent.exe")
Local $process = InputBox("Process Name", "Enter the name of process to close", "utorrent.exe")
;-------------------------------------------- Prompts -----------------------------------------------------

AdlibEnable("updateDetails", 1000); loads this function every X amount of milliseconds

;Functions

Func pos1()
		$pos = 1
EndFunc

Func pos()
	$pos = 0
	while $pos == 0
		If _IsPressed("26") And _IsPressed("11") Then up()  ;ctrl + up   
		If _IsPressed("28") And _IsPressed("11") Then down()  ;ctrl + down
		If _IsPressed("25") And _IsPressed("11") Then left() ;ctrl + left
		If _IsPressed("27") And _IsPressed("11") Then right()  ;ctrl + right
		Sleep(10)
	WEnd
EndFunc

Func updateDetails()
	If $pos == 0 Then
		ToolTip("Press END to switch to normal mode" & @CRLF & "Position change ACTIVATED", $x, $y, "Auto torrent", 1)
	Else
		ToolTip("Press ESC to close" & @CRLF & "Press HOME for position mode" & @CRLF & @CRLF & "Current Time: " & _NowTime(5) & @CRLF & "Open time: " & $openTime & @CRLF & "Close time: " & $closeTime & @CRLF & "Open file path: " & $file & @CRLF & "Process to close: " & $process, $x, $y, "Auto torrent", 1)
	EndIf
	
EndFunc

;Checks the current time with open and start times
Func update()
	If $closed == 0 Then
		$currentTime = _NowTime(4)
		If $currentTime == $openTime Then
			If $opened == 0 Then
				Run($file)
				$opened = 1
			EndIf
		
			Sleep(2000)
	
		If ProcessExists($process) Then 
			Sleep(1)
			Else 
			errorProcess()
		EndIf
	EndIf
	
	If $currentTime == $closeTime Then
		ProcessClose($process)
		MsgBox(0, "Done", "The program closed at: " & $currentTime)
		$closed = 1
		EndIf	
	EndIf
	
EndFunc


Func _Exit()
    Exit 0
EndFunc   ;==>_Exit

Func errorProcess()
	MsgBox(0, "***ERROR***", "The Process name could not be found, program will now close")
	_Exit()
EndFunc ;==> errorProcess

;checks if openTime and closeTime are valid inputs
Func timeCheck()
	If $currentTime <= $openTime Then
		Sleep(1)
	Else
		MsgBox(0, "***ERROR***", "The time(s) entered are invalid")
		_Exit()
	EndIf		
EndFunc ;==> timeCheck
	
;------------------------------- CODE to move the ToolTip information section ----------------------
;---------------------------------------- START ToolTip code ----------------------------------------
Func up()
	$y -= 10
	Sleep(1)
	updateDetails()
EndFunc

Func down()
	$y += 10
	Sleep(1)
	updateDetails()
EndFunc

Func left()
	$x -= 10
	Sleep(1)
	updateDetails()
EndFunc

Func right()
	$x += 10
	Sleep(1)
	updateDetails()
EndFunc

;---------------------------------------- END ToolTip code ----------------------------------------

;Program

timeCheck()
While $closed == 0
	update()
	Sleep(20)
WEnd

	

