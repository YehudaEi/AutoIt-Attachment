#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_UseX64=n
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#include <_Transitions.au3>
$transitionOneRunning = True
$transitionTwoRunning = True

$id = _Transition_Create(1, 1000, 4, "_TransitionOne", $LINEAR_TWEEN); count 1-1000 in 4 seconds, linear
_Transition_Start($id)
While $transitionOneRunning
	sleep(100)
WEnd
ConsoleWrite("Transition 1 complete" & @CRLF)
sleep(2000)

dim $transitionArray[2]
$transitionArray[0] = _Transition_Create(1, 1000, 4, "", $LINEAR_TWEEN); count 1-1000 in 4 seconds, linear
$transitionArray[1] = _Transition_Create(1, 1000, 2, "", $LINEAR_TWEEN); count 1-1000 in 2 seconds, linear
_Transition_Array_Start($transitionArray, "_TransitionTwo")
While $transitionTwoRunning
	sleep(100)
WEnd
ConsoleWrite("Transition 2 complete" & @CRLF)

sleep(2000)

Exit

Func _TransitionOne($n)
	ConsoleWrite(Round($n) & @CRLF)
	If $n = 1000 Then
		$transitionOneRunning = False
	EndIf
EndFunc

Func _TransitionTwo($n)
	ConsoleWrite(Round($n[0]) & " - " & Round($n[1]) & @CRLF)
	If $n[0] = 1000 Then
		$transitionTwoRunning = false
	EndIf
EndFunc
