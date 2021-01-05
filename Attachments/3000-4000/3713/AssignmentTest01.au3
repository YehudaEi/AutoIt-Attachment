Global $TestTime_ms = 5000

Func NoAss()
	Local $variable
	$variable = "a"
EndFunc   ;==>NoAss

Func YesAss()
	Local $variable = "a"
	$variable = "a"
EndFunc   ;==>YesAss


$Done = 0
$NoAssReps = 0
$TimeStart = TimerInit()
While Not $Done
	NoAss()
	$NoAssReps = $NoAssReps + 1
	If TimerDiff($TimeStart) >= $TestTime_ms Then
		$Done = 1
	EndIf
WEnd

$Done = 0
$YesAssReps = 0
$TimeStart = TimerInit()
While Not $Done
	YesAss()
	$YesAssReps = $YesAssReps + 1
	If TimerDiff($TimeStart) >= $TestTime_ms Then
		$Done = 1
	EndIf
WEnd

MsgBox(0, "Results of Comparison", "Without assignment " & String($NoAssReps) & " reps were made in " & String($TestTime_ms / 1000) &_
" seconds.  With assignment " & String($YesAssReps) & " reps were made in the same amount of time.")