#include <date.au3>

Global $start_time

Func Timer_Start()

	$start_time = TimerInit()

EndFunc   ;==>Timer_Start

Func Timer_Stop()

	Local $iHours, $iMinutes, $iSeconds, $msg_normal = 262144

	_TicksToTime(Int(TimerDiff($start_time)), $iHours, $iMinutes, $iSeconds)

	If StringLen($iHours) = 1 Then
		If $iHours = "0" Then
			$Hours = "00"
		Else
			$Hours = "0" & $iHours
		EndIf
	Else
		$Hours = $iHours
	EndIf

	If StringLen($iMinutes) = 1 Then
		If $iMinutes = "0" Then
			$Minutes = "00"
		Else
			$Minutes = "0" & $iMinutes
		EndIf
	Else
		$Minutes = $iMinutes
	EndIf

	If StringLen($iSeconds) = 1 Then
		If $iSeconds = "0" Then
			$Seconds = "00"
		Else
			$Seconds = "0" & $iSeconds
		EndIf
	Else
		$Seconds = $iSeconds
	EndIf

	$time_elapsed = $Hours & ":" & $Minutes & ":" & $Seconds

	Return $time_elapsed

EndFunc   ;==>Timer_Stop