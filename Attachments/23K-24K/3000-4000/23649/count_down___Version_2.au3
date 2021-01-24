; Count Down - Version 2
; Author - uzi17

; added - from Version 1
; better time accuracy
; fluid and mouse moveable time information

#include <Misc.au3>

HotKeySet("{Esc}", "_Exit")

Local $x = 20
Local $y = 20

;--------------------------------------------Change time here -----------------------------------------------------
Local $countDown = 5 ;count down timer in minutes
;--------------------------------------------Change time here -----------------------------------------------------

Global $timer = ($countDown * 1000 * 60) ; converted to milli seconds 
Global $pause = 1016.666666666666666666666666666667

AdlibEnable("countDown", 1000); loads this function every X amount of milliseconds

; Loops
While $timer >= 0
	If _IsPressed("11") And _IsPressed("10") And _IsPressed(0x01) Then mouseCoor() ; ctrl + shift + mouse left click
	If _IsPressed("26") And _IsPressed("11") Then up()  ;ctrl + up   
	If _IsPressed("28") And _IsPressed("11") Then down()  ;ctrl + down
	If _IsPressed("25") And _IsPressed("11") Then left() ;ctrl + left
	If _IsPressed("27") And _IsPressed("11") Then right()  ;ctrl + right
	;If _IsPressed("11") And _IsPressed("12") Then test()  ;testing
WEnd

;Func test()
;	MouseClick( "left" , 78, 723)
;	Send( $timer )
;	Send ( "{Enter}" )
;	Sleep(10)
;EndFunc

Func up()
	$y -= 10
	Sleep(1)
	$timer = $timer + $pause
	countDown()
EndFunc

Func down()
	$y += 10
	Sleep(1)
	$timer = $timer + $pause
	countDown()
EndFunc

Func left()
	$x -= 10
	Sleep(1)
	$timer = $timer + $pause
	countDown()
EndFunc

Func right()
	$x += 10
	Sleep(1)
	$timer = $timer + $pause
	countDown()
EndFunc

Func update()
	$timer = $timer + $pause
	countDown()
EndFunc

Func mouseCoor()
	$pos = MouseGetPos()
	$x = $pos[0]
	$y = $pos[1]
	$timer = $timer + $pause
	countDown()
EndFunc

Func countDown()
    ;Ceiling Rounds up the numbers
	$timer = $timer - $pause
    $secLeft = int($timer / 1000)
    $minLeft = $secLeft / 60
    $hoursLeft = $minLeft / 60
   
    ToolTip("Press ESC to close" & @CRLF & "Time Left" & @CRLF & Round($hoursLeft, 1) & " hours left" & @CRLF & Round($minLeft, 1) & " mins left" & @CRLF & $secLeft & " secs left" , $x, $y, "Counting Down from " & $countDown & " mins", 1)
	
EndFunc   ;==>CountDown

Func _Exit()
    Exit 0
EndFunc   ;==>_Exit

MsgBox(0, "Count Down", "Done")
