; Auto Torrent - Version 1.3
; Author uzi17

; Added GUI

;For Gui
#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>

;For code
#include <Date.au3>
#include <Misc.au3>

HotKeySet("{Esc}", "_Exit")
HotKeySet("{Home}", "pos")
HotKeySet("{End}", "pos1")

Local $start = 0
Local $x = 20
Local $y = 20
Local $pos = 1
Local $opened = 0
Local $closed = 0


#Region ### START Koda GUI section ### Form=
GUICreate("Auto Torrent", 392, 202, 196, 152)
$openInput = GUICtrlCreateInput(_NowTime(4), 32, 40, 73, 21)
$closeInput = GUICtrlCreateInput(_NowTime(4), 32, 72, 73, 21)
$fileInput = GUICtrlCreateInput("C:\Program Files\uTorrent\utorrent.exe", 32, 104, 217, 21)
$processInput = GUICtrlCreateInput("utorrent.exe", 32, 128, 73, 21)
GUICtrlCreateLabel("Open time", 144, 40, 49, 17)
GUICtrlCreateLabel("Close time", 144, 73, 57, 23)
GUICtrlCreateLabel("File Path", 264, 105, 81, 17)
GUICtrlCreateLabel("Process Name", 144, 137, 73, 25)
$start = GUICtrlCreateButton("Start", 112, 168, 75, 25, 0)
$test = GUICtrlCreateButton("Test", 216, 168, 75, 25, 0)
GUICtrlCreateLabel("Current time: " & _NowTime(4), 32, 17, 268, 17)
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###

While 1
    $msg = GUIGetMsg()
	Select
	Case $msg = $start
			;stores values
			Local $openTime = GUICtrlRead($openInput)
			Local $closeTime = GUICtrlRead($closeInput)
			Local $file= GUICtrlRead($fileInput)
			Local $process = GUICtrlRead($processInput)
			GUIDelete()
			start()
			
		Case $msg = $test
			testProgram()
			
	EndSelect
WEnd

;---------------------------- Functions
Func test()
	MsgBox(0, "***ERROR***", "Working")
EndFunc

;--------------------------------------------------------------------------
;Functions
Func testProgram()
	
$Form1 = GUICreate("Test", 463, 137, 192, 154)
GUICtrlCreateLabel("This will open and close the program you entered to test whether the information you entered was valid, Do you wish to continue?", 16, 24, 436, 49)
$yes = GUICtrlCreateButton("Yes", 160, 96, 75, 25, 0)
$no = GUICtrlCreateButton("No", 240, 96, 75, 25, 0)
GUISetState(@SW_SHOW)

While 1
	$msg = GUIGetMsg()
	Select
	Case $msg = $yes
		GUIDelete()
		testStart()
	Case $msg = $no
		GUIDelete()
	EndSelect
WEnd
EndFunc

Func testStart()
	Local $file= GUICtrlRead($fileInput)
	Local $process = GUICtrlRead($processInput)
	Run($file)
	Sleep(2000)
	If ProcessExists($process) Then 
		ProcessClose($process)
		MsgBox(0, "Successful", "Test successful!")
		Sleep(1)
		Else 
		MsgBox(0, "ERROR", "The file path and/or process was invalid, try again")
	EndIf
EndFunc

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

Func start()
	AdlibEnable("updateDetails", 1000); loads this function every X amount of milliseconds
	While $closed == 0
		update()
		Sleep(20)
	WEnd
	If $closed == 1 Then
		_Exit()
	EndIf
EndFunc
