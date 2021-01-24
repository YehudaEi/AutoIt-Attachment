; Reaction
; Author - Uzi17

#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>

HotKeySet("{Esc}", "_Exit")

Func _Exit()
    Exit 0
EndFunc   ;==>_Exit

Local $xsize, $ysize, $defused, $randomTime, $timer, $time, $number
$randomTime = Random( 200, 500, 1)
$xsize = 800
$ysize = 600

start()

Func start()
$gui = GUICreate("Screen", 209, 127, 425, 275)
GUICtrlCreateLabel("Defuse", 80, 8, 44, 17)
$start = GUICtrlCreateButton("Start", 64, 88, 75, 25, 0)
$time = GUICtrlCreateInput("15", 80, 64, 49, 21)
GUICtrlCreateLabel("Time to play (seconds)", 48, 40, 108, 17)
GUISetState(@SW_SHOW)

;values to reset
$timer = GUICtrlRead($time) * 1000


While 1
	$msg = GUIGetMsg()
	Select
	Case $msg = $start
		$time = GUICtrlRead($time)
		GUIDelete()
		play()
		ExitLoop
	EndSelect
WEnd

EndFunc

Func test()
		MsgBox(0, "working", "works")
EndFunc

Func timer()
	$timer -= 200
EndFunc

Func createMore()
		$xval = Random(15 , $xsize - 110, 1)
		$yval = Random(60 , $ysize - 50, 1)
		GUICtrlCreateButton("Epic Bomb", $xval, $yval, 75, 25, 0); <============================================== HERE
		GUICtrlCreateLabel("Bombs Defused: " & $defused &  " Time Left: " & $timer/1000 & " seconds", 0,0,300, 30, -1)
EndFunc

Func create()
	GUICtrlCreateLabel("Bombs Defused: " & $defused & " Time Left: " & $timer/1000 & " seconds", 0,0,100, 30, -1)
		while $timer > 0
			createMore()
			Sleep(200)
			timer()
		WEnd
		;code here when button is clicked		; <============================================== HERE
		$defused += 1
	end()
EndFunc

Func play()
	$number = 0
	$defused = 0
	$timer = $time * 1000
	$click = GUICreate("Click (ESC to close)", $xsize - 20, $ysize)
	$gameArea = GUICtrlCreateGroup("Area", 10, 40, $xsize - 40, $ysize - 60, -1)
	GUISetState(@SW_SHOW)
	create()
EndFunc

Func end()
	AdlibDisable()
	GUIDelete()
	GUICreate("Results", 208, 107, 425, 275)
	$exit = GUICtrlCreateButton("Exit", 112, 56, 75, 25)
	GUICtrlCreateLabel("You defused " & $defused & " bombs", 48, 16, 108, 17)
	$again = GUICtrlCreateButton("Play Again?", 24, 56, 75, 25)
	GUISetState(@SW_SHOW)
	
	While 1
		$msg = GUIGetMsg()
		Select
		Case $msg = $again
			GUIDelete()
			start()
			ExitLoop
			
		Case $msg = $exit
			GUIDelete()
			_Exit()
			ExitLoop
	EndSelect
	WEnd
EndFunc



While 1
	$msg = GUIGetMsg()
	Select
	Case $msg = $start
		$time = GUICtrlRead($time)
		GUIDelete()
		play()
		ExitLoop
	EndSelect
WEnd