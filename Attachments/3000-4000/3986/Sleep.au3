HotKeySet("{F2}", "Up")
HotKeySet("{F9}", "Progress")
HotKeySet("{ESC}", "Terminate")
MsgBox(0, "Info", "This script/program works like a TV sleep function.  When the timer runs out the PC will shutdown." & @CRLF & "Press F2 to set the timer longer than 30 mins." & @CRLF & "Also press F9 to see how much longer is left." & @CRLF & @CRLF & "ESC stops this script/program.")
$tooltip = 0
$timer = TimerInit()
$sleep = 30
ToolTip("Set at " & $sleep & "min.", 10, 10)
$tooltip = TimerInit()
While 1
	$time = TimerDiff($timer)
	$timeleft = $time * - 1 + $sleep * 60000
	If $timeleft <= ($sleep - 15) * 60000 Then $sleep = $sleep - 15
	If $timeleft <= 0 Then
		Shutdown(9)
		Exit
	EndIf
	If $tooltip Then
		If TimerDiff($tooltip) >= 7500 Then
			ToolTip("")
		EndIf
	EndIf
	If Int($timeleft / 60000 + 1) = 1 Then
		ToolTip(Int($timeleft / 1000 + 1) & " seconds left till shutdown." & @CRLF & "Press ESC to cancel!", 10, 10);note:dont let it refreash so often: fix this
	EndIf
	Sleep(250)
WEnd

Func Up()
	If $time >= 60000 Then
		$timer = TimerInit()
	ElseIf $sleep >= 120 Then
		HotKeySet("{F2}")
		$sleep = InputBox("Time?", "How long till shutdown?", $sleep)
		If @error = 1 Then Exit
		$timer = TimerInit()
	Else
		$timer = TimerInit()
		$sleep = $sleep + 15
	EndIf
	ToolTip("Set at " & $sleep & "min.", 10, 10)
	$tooltip = TimerInit()
EndFunc   ;==>Up

Func Progress()
	ToolTip(Int($timeleft / 60000 + 1) & " mins left.", 10, 10)
	$tooltip = TimerInit()
EndFunc   ;==>Progress

Func Terminate()
	Exit
EndFunc   ;==>Terminate