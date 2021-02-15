#include-once
#include <Timers.au3>
#include <SQLite.au3>
#include <SQLite.dll.au3>
#include <Array.au3>

Global Const $PI = 3.14159265358979

Global Const $LINEAR_TWEEN = "_LinearTween"
Global Const $QUAD_EASE_IN = "_QuadEaseIn"
Global Const $QUAD_EASE_OUT = "_QuadEaseOut"
Global Const $QUAD_EASE_IN_OUT = "_QuadEaseInOut"
Global Const $CUBIC_EASE_IN = "_CubicEaseIn"
Global Const $CUBIC_EASE_OUT = "_CubicEaseOut"
Global Const $CUBIC_EASE_IN_OUT = "_CubicEaseInOut"
Global Const $QUARTIC_EASE_IN = "_QuarticEaseIn"
Global Const $QUARTIC_EASE_OUT = "_QuarticEaseOut"
Global Const $QUARTIC_EASE_IN_OUT = "_QuarticEaseInOut"
Global Const $QUINTIC_EASE_IN = "_QuinticEaseIn"
Global Const $QUINTIC_EASE_OUT = "_QuinticEaseOut"
Global Const $QUINTIC_EASE_IN_OUT = "_QuinticEaseInOut"
Global Const $SINE_EASE_IN = "_SineEaseIn"
Global Const $SINE_EASE_OUT = "_SineEaseOut"
Global Const $SINE_EASE_IN_OUT = "_SineEaseInOut"
Global Const $EXPO_EASE_IN = "_ExpoEaseIn"
Global Const $EXPO_EASE_OUT = "_ExpoEaseOut"
Global Const $EXPO_EASE_IN_OUT = "_ExpoEaseInOut"
Global Const $CIRC_EASE_IN = "_CircEaseIn"
Global Const $CIRC_EASE_OUT = "_CircEaseOut"
Global Const $CIRC_EASE_IN_OUT = "_CircEaseInOUT"

Global $TRANSITIONS_GUI = GUICreate("HIDDEN GUI FOR TIMER FUNCTIONS", 0, 0)
_SQLite_Startup()
_SQLite_Open()
_SQLite_Exec(-1, "CREATE TABLE transitions (timer,timer2,fromNum,toNum,time,rate,type,function);")

; #FUNCTION# ;===============================================================================
;
; Name...........: _Transition_Create
; Description ...: Creates a transition that you can later run.
; Syntax.........: _Transition($iFrom,$iTo,$iTime,$sFunction,$sType = $LINEAR_TWEEN,$iRestThreshold = 25)
; Parameters ....: $iFrom - Start Number.
;				   $iTo - End Number.
;				   $iTime - Amount of time the transition should take.
;				   $sFunction - The function (in string form) to run whenever the transition updates over the $iTime given.
;				   $sType - The Type of transition.
;				   $iRefreshRate - The amount in milliseconds that is given between updates.
; Return values .: Success - The ID of the transition which can be used to start and stop the transition.
; Author ........: DisabledMonkey
; Modified.......:
; Remarks .......: Transitions UDF: Basic Transition
; Related .......: _Transition_Start,_Transition_Array_Start,_Transition_Stop,_Transition_Stop_All
; Related .......: _QuadEaseIn, _QuadEaseOut, _QuadEaseInOut
; Related .......: _CubicEaseIn, _CubicEaseOut, _CubicEaseInOut
; Related .......: _QuarticEaseIn, _QuarticEaseOut, _QuarticEaseInOut
; Related .......: _QuinticEaseIn, _QuinticEaseOut, _QuinticEaseInOut
; Related .......: _SineEaseIn, _SineEaseOut, _SineEaseInOut
; Related .......: _ExpoEaseIn, _ExpoEaseOut, _ExpoEaseInOut
; Related .......: _CircEaseIn, _CircEaseOut, _CircEaseInOut
; Link ..........;
; Example .......; Yes
;
; ;==========================================================================================
Func _Transition_Create($iFrom, $iTo, $iTime, $sFunction, $sType = $LINEAR_TWEEN, $iRefreshRate = 25)
	Local $aRow, $timer = _Timer_Init()
	_SQLite_Exec(-1, 'INSERT INTO transitions (timer,timer2,fromNum,toNum,time,rate,type,function) VALUES ("0","0","' & $iFrom & '","' & $iTo & '","' & $iTime & '","' & $iRefreshRate & '","' & $sType & '","' & $sFunction & '");')
	Return _SQLite_LastInsertRowID()
EndFunc   ;==>_Transition_Create

; #FUNCTION# ;===============================================================================
;
; Name...........: _Transition_Start
; Description ...: Starts a transition
; Syntax.........: _Transition_Start($id)
; Parameters ....: $id - The id of the transition you are starting Returned from _Transition.
; Return values .: null
; Author ........: DisabledMonkey
; Modified.......:
; Remarks .......: Transitions UDF: Basic Transition
; Related .......: _Transition,_Transition_Array_Start,_Transition_Stop,_Transition_Stop_All
; Related .......: _QuadEaseIn, _QuadEaseOut, _QuadEaseInOut
; Related .......: _CubicEaseIn, _CubicEaseOut, _CubicEaseInOut
; Related .......: _QuarticEaseIn, _QuarticEaseOut, _QuarticEaseInOut
; Related .......: _QuinticEaseIn, _QuinticEaseOut, _QuinticEaseInOut
; Related .......: _SineEaseIn, _SineEaseOut, _SineEaseInOut
; Related .......: _ExpoEaseIn, _ExpoEaseOut, _ExpoEaseInOut
; Related .......: _CircEaseIn, _CircEaseOut, _CircEaseInOut
; Link ..........;
; Example .......; Yes
;
; ;==========================================================================================
Func _Transition_Start($id)
	Local $aRow
	_SQLite_QuerySingleRow(-1, 'SELECT * FROM transitions WHERE ROWID="' & $id & '";', $aRow)
	_SQLite_Exec(-1, 'UPDATE transitions SET timer="' & _Timer_SetTimer($TRANSITIONS_GUI, $aRow[5], "__TransitionClick") & '",timer2="' & _Timer_Init() & '" WHERE ROWID="' & $id & '";')
EndFunc   ;==>_Transition_Start

; #FUNCTION# ;===============================================================================
;
; Name...........: _Transition_Array_Start
; Description ...: Starts an array of transitions
; Syntax.........: _Transition_Array_Start($aArray,$sFunction,$iRefreshRate = 25)
; Parameters ....: $aArray - An array of transitions to start.
; 				   $sFunction - The function (in string form) to run whenever the transition updates.
;				   $iRefreshRate - The amount in milliseconds that is given between updates.
; Return values .: Success - The timer of the transition array which can be used to stop the array transition.
; Author ........: DisabledMonkey
; Modified.......:
; Remarks .......: Transitions UDF: Basic Transition
; Related .......: _Transition,_Transition_Start,_Transition_Stop,_Transition_Stop_All
; Related .......: _QuadEaseIn, _QuadEaseOut, _QuadEaseInOut
; Related .......: _CubicEaseIn, _CubicEaseOut, _CubicEaseInOut
; Related .......: _QuarticEaseIn, _QuarticEaseOut, _QuarticEaseInOut
; Related .......: _QuinticEaseIn, _QuinticEaseOut, _QuinticEaseInOut
; Related .......: _SineEaseIn, _SineEaseOut, _SineEaseInOut
; Related .......: _ExpoEaseIn, _ExpoEaseOut, _ExpoEaseInOut
; Related .......: _CircEaseIn, _CircEaseOut, _CircEaseInOut
; Link ..........;
; Example .......; Yes
;
; ;==========================================================================================
Func _Transition_Array_Start($aArray, $sFunction, $iRefreshRate = 25)
	Local $click
	$click = _Timer_SetTimer($TRANSITIONS_GUI, 10000, "__TransitionArrayClick")
	For $n = 0 To UBound($aArray) - 1
		_SQLite_Exec(-1, 'UPDATE transitions SET timer="' & $click & '",timer2="' & _Timer_Init() & '",function="' & $sFunction & '" WHERE ROWID="' & $aArray[$n] & '";')
	Next
	$click = _Timer_SetTimer($TRANSITIONS_GUI, $iRefreshRate, "__TransitionArrayClick",$click)
	Return $click
EndFunc   ;==>_Transition_Array_Start
; #FUNCTION# ;===============================================================================
;
; Name...........: _Transition_Stop
; Description ...: Stops a transition
; Syntax.........: _Transition_Stop($id)
; Parameters ....: $id - The id of the transition to stop that was Returned from _Transition.
; Return values .: null
; Author ........: DisabledMonkey
; Modified.......:
; Remarks .......: Transitions UDF: Basic Transition
; Related .......: _Transition,_Transition_Start,_Transition_Array_Start,_Transition_Stop_All
; Related .......: _QuadEaseIn, _QuadEaseOut, _QuadEaseInOut
; Related .......: _CubicEaseIn, _CubicEaseOut, _CubicEaseInOut
; Related .......: _QuarticEaseIn, _QuarticEaseOut, _QuarticEaseInOut
; Related .......: _QuinticEaseIn, _QuinticEaseOut, _QuinticEaseInOut
; Related .......: _SineEaseIn, _SineEaseOut, _SineEaseInOut
; Related .......: _ExpoEaseIn, _ExpoEaseOut, _ExpoEaseInOut
; Related .......: _CircEaseIn, _CircEaseOut, _CircEaseInOut
; Link ..........;
; Example .......; Yes
;
; ;==========================================================================================
Func _Transition_Stop($id)
	Local $aRow
	_SQLite_QuerySingleRow(-1, 'SELECT timer FROM transitions WHERE ROWID="' & $id & '";', $aRow)
	_Timer_KillTimer($TRANSITIONS_GUI, $aRow[0])
EndFunc   ;==>_Transition_Stop
; #FUNCTION# ;===============================================================================
;
; Name...........: _Transition_Array_Stop
; Description ...: Stops a transition
; Syntax.........: _Transition_Array_Stop($timer)
; Parameters ....: $timer - The timer of the transition to stop that was Returned from _Transition_Array_Start.
; Return values .: null
; Author ........: DisabledMonkey
; Modified.......:
; Remarks .......: Transitions UDF: Basic Transition
; Related .......: _Transition,_Transition_Start,_Transition_Array_Start,_Transition_Stop_All
; Related .......: _QuadEaseIn, _QuadEaseOut, _QuadEaseInOut
; Related .......: _CubicEaseIn, _CubicEaseOut, _CubicEaseInOut
; Related .......: _QuarticEaseIn, _QuarticEaseOut, _QuarticEaseInOut
; Related .......: _QuinticEaseIn, _QuinticEaseOut, _QuinticEaseInOut
; Related .......: _SineEaseIn, _SineEaseOut, _SineEaseInOut
; Related .......: _ExpoEaseIn, _ExpoEaseOut, _ExpoEaseInOut
; Related .......: _CircEaseIn, _CircEaseOut, _CircEaseInOut
; Link ..........;
; Example .......; Yes
;
; ;==========================================================================================
Func _Transition_Array_Stop($timer)
	_Timer_KillTimer($TRANSITIONS_GUI,$timer)
EndFunc   ;==>_Transition_Array_Stop
; #FUNCTION# ;===============================================================================
;
; Name...........: _Transition_Stop_All
; Description ...: Stops all transitions in progress
; Syntax.........: _Transition_Stop_All()
; Return values .: null
; Author ........: DisabledMonkey
; Modified.......:
; Remarks .......: Transitions UDF: Basic Transition
; Related .......: _Transition,_Transition_Start,_Transition_Array_Start,_Transition_Stop
; Related .......: _QuadEaseIn, _QuadEaseOut, _QuadEaseInOut
; Related .......: _CubicEaseIn, _CubicEaseOut, _CubicEaseInOut
; Related .......: _QuarticEaseIn, _QuarticEaseOut, _QuarticEaseInOut
; Related .......: _QuinticEaseIn, _QuinticEaseOut, _QuinticEaseInOut
; Related .......: _SineEaseIn, _SineEaseOut, _SineEaseInOut
; Related .......: _ExpoEaseIn, _ExpoEaseOut, _ExpoEaseInOut
; Related .......: _CircEaseIn, _CircEaseOut, _CircEaseInOut
; Link ..........;
; Example .......; Yes
;
; ;==========================================================================================
Func _Transition_Stop_All()
	_Timer_KillAllTimers($TRANSITIONS_GUI)
EndFunc   ;==>_Transition_Stop_All
; #FUNCTION# ;===============================================================================
;  Name ..........: __TransitionClick
;  Author ........: DisabledMonkey
;  Date ..........: 1.17.11
;  Remarks .......: internal use only
;  Example........: no
; ;==========================================================================================
Func __TransitionClick($hWnd, $Msg, $iIDTimer, $dwTime)
	Local $timer, $from, $to, $time, $type, $function, $currentTime, $aRow
	_SQLite_QuerySingleRow(-1, 'SELECT *,ROWID FROM transitions WHERE timer = "' & $iIDTimer & '" LIMIT 1;', $aRow)
	If UBound($aRow) = 9 Then
		$timer = $aRow[0]
		$timerTime = $aRow[1]
		$from = $aRow[2]
		$to = $aRow[3]
		$time = $aRow[4] * 1000
		$rate = $aRow[5]
		$type = $aRow[6]
		$function = $aRow[7]
		$currentTime = _Timer_Diff($timerTime)
		If $currentTime < $time Then
			$percent = Call($type, $currentTime / $time * 100000, 0, 1, 100000)
			$number = ($percent * ($to - $from)) + $from
			Call($function, $number)
		Else
			_Transition_Array_Stop($timer)
			Call($function, $to)
			;_Timer_KillTimer($TRANSITIONS_GUI, $iIDTimer)
		EndIf
	EndIf
EndFunc   ;==>__TransitionClick
; #FUNCTION# ;===============================================================================
;  Name ..........: __TransitionArrayClick
;  Author ........: DisabledMonkey
;  Date ..........: 1.17.11
;  Remarks .......: internal use only
;  Example........: no
; ;==========================================================================================
Func __TransitionArrayClick($hWnd, $Msg, $iIDTimer, $dwTime)
	Local $timer, $from, $to, $time, $type, $function, $currentTime, $aRow, $resultArray[1], $n, $hQuery
	_SQLite_Query(-1, 'SELECT * FROM transitions WHERE timer = "' & $iIDTimer & '";', $hQuery) ; the query
	;msgbox(-1,"got","here")
	local $completed = 0
	local $n = 0
	While _SQLite_FetchData($hQuery, $aRow) = $SQLITE_OK
		$n += 1
		If UBound($aRow) = 8 Then
			$timer = $aRow[0]
			$timerTime = $aRow[1]
			$from = $aRow[2]
			$to = $aRow[3]
			$time = $aRow[4] * 1000
			$rate = $aRow[5]
			$type = $aRow[6]
			$function = $aRow[7]
			$currentTime = _Timer_Diff($timerTime)
			If $currentTime < $time Then
				$percent = Call($type, $currentTime / $time * 100000, 0, 1, 100000)
				$number = ($percent * ($to - $from)) + $from
				;msgbox(-1,"number",$number)
				_ArrayAdd($resultArray, $number)
			Else
				_ArrayAdd($resultArray, $to)
				$completed += 1
				;_SQLite_Exec(-1,'DELETE FROM transitions WHERE timer = "' & $iIDTimer & '";')
				;_Timer_KillTimer($TRANSITIONS_GUI, _Timer_GetTimerID($iIDTimer))
			EndIf
		EndIf
	WEnd
	For $n = 0 To UBound($resultArray) - 2
		$resultArray[$n] = $resultArray[$n + 1];cycle array down one step to fix missing 0 index
	Next
	If $n = $completed Then
		_Transition_Array_Stop($timer)
	EndIf
	Call($function, $resultArray)
EndFunc   ;==>__TransitionArrayClick

; #FUNCTION# ;===============================================================================
;
; Name...........: _LinearTween
; Description ...: Returns a linear interval between start and end points, no acceleration or easing
; Syntax.........: _LinearTween($iFrame, $iStartValue, $iInterval, $iEndValue)
; Parameters ....: $iFrame - Current frame, or point.
;				   $iStartValue - Beginning point
;				   $iInterval - Change in value
;				   $iEndValue - Number of frames
; Return values .: Success - Returns the point of an interval between $iStartValue and $iEndValue.
;                  Failure - Returns 0
; Author ........: Josh Rowe
; Modified.......:
; Remarks .......: Transitions UDF: Basic Transition
; Related .......: _QuadEaseIn, _QuadEaseOut, _QuadEaseInOut
; Related .......: _CubicEaseIn, _CubicEaseOut, _CubicEaseInOut
; Related .......: _QuarticEaseIn, _QuarticEaseOut, _QuarticEaseInOut
; Related .......: _QuinticEaseIn, _QuinticEaseOut, _QuinticEaseInOut
; Related .......: _SineEaseIn, _SineEaseOut, _SineEaseInOut
; Related .......: _ExpoEaseIn, _ExpoEaseOut, _ExpoEaseInOut
; Related .......: _CircEaseIn, _CircEaseOut, _CircEaseInOut
; Link ..........;
; Example .......; Yes
;
; ;==========================================================================================
Func _LinearTween($iFrame, $iStartValue, $iInterval, $iEndValue)
	Return $iInterval * ($iFrame / $iEndValue) + $iStartValue
EndFunc   ;==>_LinearTween

; #FUNCTION# ;===============================================================================
;
; Name...........: _QuadEaseIn
; Description ...: Returns a linear interval between start and end points, acclerating from 0 velocity
; Syntax.........: _QuadEaseIn($iFrame, $iStartValue, $iInterval, $iEndValue)
; Parameters ....: $iFrame - Current frame, or point.
;				   $iStartValue - Beginning point
;				   $iInterval - Change in value
;				   $iEndValue - Number of frames
; Return values .: Success - Returns the point of an interval between $iStartValue and $iEndValue.
;                  Failure - Returns 0
; Author ........: Josh Rowe
; Modified.......:
; Remarks .......: Transitions UDF: Advanced Transition
; Related .......: _QuadEaseIn, _QuadEaseOut, _QuadEaseInOut
; Related .......: _CubicEaseIn, _CubicEaseOut, _CubicEaseInOut
; Related .......: _QuarticEaseIn, _QuarticEaseOut, _QuarticEaseInOut
; Related .......: _QuinticEaseIn, _QuinticEaseOut, _QuinticEaseInOut
; Related .......: _SineEaseIn, _SineEaseOut, _SineEaseInOut
; Related .......: _ExpoEaseIn, _ExpoEaseOut, _ExpoEaseInOut
; Related .......: _CircEaseIn, _CircEaseOut, _CircEaseInOut
; Link ..........;
; Example .......; Yes
;
; ;==========================================================================================
Func _QuadEaseIn($iFrame, $iStartValue, $iInterval, $iEndValue)
	$iFrame = $iFrame / $iEndValue
	Return $iInterval * $iFrame * $iFrame + $iStartValue
EndFunc   ;==>_QuadEaseIn

; #FUNCTION# ;===============================================================================
;
; Name...........: _QuadEaseOut
; Description ...: Returns a linear interval between start and end points, acclerating from 0 velocity
; Syntax.........: _QuadEaseOut($iFrame, $iStartValue, $iInterval, $iEndValue)
; Parameters ....: $iFrame - Current frame, or point.
;				   $iStartValue - Beginning point
;				   $iInterval - Change in value
;				   $iEndValue - Number of frames
; Return values .: Success - Returns the point of an interval between $iStartValue and $iEndValue.
;                  Failure - Returns 0
; Author ........: Josh Rowe
; Modified.......:
; Remarks .......: Transitions UDF: Advanced Transition
; Related .......: _QuadEaseIn, _QuadEaseOut, _QuadEaseInOut
; Related .......: _CubicEaseIn, _CubicEaseOut, _CubicEaseInOut
; Related .......: _QuarticEaseIn, _QuarticEaseOut, _QuarticEaseInOut
; Related .......: _QuinticEaseIn, _QuinticEaseOut, _QuinticEaseInOut
; Related .......: _SineEaseIn, _SineEaseOut, _SineEaseInOut
; Related .......: _ExpoEaseIn, _ExpoEaseOut, _ExpoEaseInOut
; Related .......: _CircEaseIn, _CircEaseOut, _CircEaseInOut
; Link ..........;
; Example .......; Yes
;
; ;==========================================================================================
Func _QuadEaseOut($iFrame, $iStartValue, $iInterval, $iEndValue)
	$iFrame = $iFrame / $iEndValue
	Return -$iInterval * $iFrame * ($iFrame - 2) + $iStartValue
EndFunc   ;==>_QuadEaseOut

; #FUNCTION# ;===============================================================================
;
; Name...........: _QuadEaseInOut
; Description ...: Returns a linear interval between start and end points, acclerating from 0 velocity
; Syntax.........: _QuadEaseInOut($iFrame, $iStartValue, $iInterval, $iEndValue)
; Parameters ....: $iFrame - Current frame, or point.
;				   $iStartValue - Beginning point
;				   $iInterval - Change in value
;				   $iEndValue - Number of frames
; Return values .: Success - Returns the point of an interval between $iStartValue and $iEndValue.
;                  Failure - Returns 0
; Author ........: Josh Rowe
; Modified.......:
; Remarks .......: Transitions UDF: Advanced Transition
; Related .......: _QuadEaseIn, _QuadEaseOut, _QuadEaseInOut
; Related .......: _CubicEaseIn, _CubicEaseOut, _CubicEaseInOut
; Related .......: _QuarticEaseIn, _QuarticEaseOut, _QuarticEaseInOut
; Related .......: _QuinticEaseIn, _QuinticEaseOut, _QuinticEaseInOut
; Related .......: _SineEaseIn, _SineEaseOut, _SineEaseInOut
; Related .......: _ExpoEaseIn, _ExpoEaseOut, _ExpoEaseInOut
; Related .......: _CircEaseIn, _CircEaseOut, _CircEaseInOut
; Link ..........;
; Example .......; Yes
;
; ;==========================================================================================
Func _QuadEaseInOut($iFrame, $iStartValue, $iInterval, $iEndValue)
	$iFrame = $iFrame / ($iEndValue / 2)
	If $iFrame < 1 Then
		Return ($iInterval / 2) * $iFrame * $iFrame + $iStartValue
	EndIf
	$iFrame = $iFrame - 1
	Return -($iInterval / 2) * ($iFrame * ($iFrame - 2) - 1) + $iStartValue
EndFunc   ;==>_QuadEaseInOut

; #FUNCTION# ;===============================================================================
;
; Name...........: _CubicEaseIn
; Description ...: Returns a linear interval between start and end points, acclerating from 0 velocity
; Syntax.........: _CubicEaseIn($iFrame, $iStartValue, $iInterval, $iEndValue)
; Parameters ....: $iFrame - Current frame, or point.
;				   $iStartValue - Beginning point
;				   $iInterval - Change in value
;				   $iEndValue - Number of frames
; Return values .: Success - Returns the point of an interval between $iStartValue and $iEndValue.
;                  Failure - Returns 0
; Author ........: Josh Rowe
; Modified.......:
; Remarks .......: Transitions UDF: Advanced Transition
; Related .......: _QuadEaseIn, _QuadEaseOut, _QuadEaseInOut
; Related .......: _CubicEaseIn, _CubicEaseOut, _CubicEaseInOut
; Related .......: _QuarticEaseIn, _QuarticEaseOut, _QuarticEaseInOut
; Related .......: _QuinticEaseIn, _QuinticEaseOut, _QuinticEaseInOut
; Related .......: _SineEaseIn, _SineEaseOut, _SineEaseInOut
; Related .......: _ExpoEaseIn, _ExpoEaseOut, _ExpoEaseInOut
; Related .......: _CircEaseIn, _CircEaseOut, _CircEaseInOut
; Link ..........;
; Example .......; Yes
;
; ;==========================================================================================
Func _CubicEaseIn($iFrame, $iStartValue, $iInterval, $iEndValue)
	$iFrame = $iFrame / $iEndValue;
	Return $iInterval * $iFrame * $iFrame * $iFrame + $iStartValue

EndFunc   ;==>_CubicEaseIn

; #FUNCTION# ;===============================================================================
;
; Name...........: _CubicEaseOut
; Description ...: Returns a linear interval between start and end points, acclerating from 0 velocity
; Syntax.........: _CubicEaseOut($iFrame, $iStartValue, $iInterval, $iEndValue)
; Parameters ....: $iFrame - Current frame, or point.
;				   $iStartValue - Beginning point
;				   $iInterval - Change in value
;				   $iEndValue - Number of frames
; Return values .: Success - Returns the point of an interval between $iStartValue and $iEndValue.
;                  Failure - Returns 0
; Author ........: Josh Rowe
; Modified.......:
; Remarks .......: Transitions UDF: Advanced Transition
; Related .......: _QuadEaseIn, _QuadEaseOut, _QuadEaseInOut
; Related .......: _CubicEaseIn, _CubicEaseOut, _CubicEaseInOut
; Related .......: _QuarticEaseIn, _QuarticEaseOut, _QuarticEaseInOut
; Related .......: _QuinticEaseIn, _QuinticEaseOut, _QuinticEaseInOut
; Related .......: _SineEaseIn, _SineEaseOut, _SineEaseInOut
; Related .......: _ExpoEaseIn, _ExpoEaseOut, _ExpoEaseInOut
; Related .......: _CircEaseIn, _CircEaseOut, _CircEaseInOut
; Link ..........;
; Example .......; Yes
;
; ;==========================================================================================
Func _CubicEaseOut($iFrame, $iStartValue, $iInterval, $iEndValue)
	$iFrame = $iFrame / $iEndValue
	$iFrame = $iFrame - 1
	Return $iInterval * ($iFrame * $iFrame * $iFrame + 1) + $iStartValue;
EndFunc   ;==>_CubicEaseOut

; #FUNCTION# ;===============================================================================
;
; Name...........: _CubicEaseInOut
; Description ...: Returns a linear interval between start and end points, acclerating from 0 velocity
; Syntax.........: _CubicEaseInOut($iFrame, $iStartValue, $iInterval, $iEndValue)
; Parameters ....: $iFrame - Current frame, or point.
;				   $iStartValue - Beginning point
;				   $iInterval - Change in value
;				   $iEndValue - Number of frames
; Return values .: Success - Returns the point of an interval between $iStartValue and $iEndValue.
;                  Failure - Returns 0
; Author ........: Josh Rowe
; Modified.......:
; Remarks .......: Transitions UDF: Advanced Transition
; Related .......: _QuadEaseIn, _QuadEaseOut, _QuadEaseInOut
; Related .......: _CubicEaseIn, _CubicEaseOut, _CubicEaseInOut
; Related .......: _QuarticEaseIn, _QuarticEaseOut, _QuarticEaseInOut
; Related .......: _QuinticEaseIn, _QuinticEaseOut, _QuinticEaseInOut
; Related .......: _SineEaseIn, _SineEaseOut, _SineEaseInOut
; Related .......: _ExpoEaseIn, _ExpoEaseOut, _ExpoEaseInOut
; Related .......: _CircEaseIn, _CircEaseOut, _CircEaseInOut
; Link ..........;
; Example .......; Yes
;
; ;==========================================================================================
Func _CubicEaseInOut($iFrame, $iStartValue, $iInterval, $iEndValue)
	$iFrame = $iFrame / ($iEndValue / 2)
	If $iFrame < 1 Then
		Return $iInterval / 2 * $iFrame * $iFrame * $iFrame + $iStartValue
	EndIf
	$iFrame = $iFrame - 2
	Return $iInterval / 2 * ($iFrame * $iFrame * $iFrame + 2) + $iStartValue

EndFunc   ;==>_CubicEaseInOut

; #FUNCTION# ;===============================================================================
;
; Name...........: _QuarticEaseIn
; Description ...: Returns a linear interval between start and end points, acclerating from 0 velocity
; Syntax.........: _QuarticEaseIn($iFrame, $iStartValue, $iInterval, $iEndValue)
; Parameters ....: $iFrame - Current frame, or point.
;				   $iStartValue - Beginning point
;				   $iInterval - Change in value
;				   $iEndValue - Number of frames
; Return values .: Success - Returns the point of an interval between $iStartValue and $iEndValue.
;                  Failure - Returns 0
; Author ........: Josh Rowe
; Modified.......:
; Remarks .......: Transitions UDF: Advanced Transition
; Related .......: _QuadEaseIn, _QuadEaseOut, _QuadEaseInOut
; Related .......: _CubicEaseIn, _CubicEaseOut, _CubicEaseInOut
; Related .......: _QuarticEaseIn, _QuarticEaseOut, _QuarticEaseInOut
; Related .......: _QuinticEaseIn, _QuinticEaseOut, _QuinticEaseInOut
; Related .......: _SineEaseIn, _SineEaseOut, _SineEaseInOut
; Related .......: _ExpoEaseIn, _ExpoEaseOut, _ExpoEaseInOut
; Related .......: _CircEaseIn, _CircEaseOut, _CircEaseInOut
; Link ..........;
; Example .......; Yes
;
; ;==========================================================================================
Func _QuarticEaseIn($iFrame, $iStartValue, $iInterval, $iEndValue)
	$iFrame = $iFrame / $iEndValue;
	Return $iInterval * $iFrame * $iFrame * $iFrame * $iFrame + $iStartValue
EndFunc   ;==>_QuarticEaseIn

; #FUNCTION# ;===============================================================================
;
; Name...........: _QuarticEaseOut
; Description ...: Returns a linear interval between start and end points, acclerating from 0 velocity
; Syntax.........: _QuarticEaseOut($iFrame, $iStartValue, $iInterval, $iEndValue)
; Parameters ....: $iFrame - Current frame, or point.
;				   $iStartValue - Beginning point
;				   $iInterval - Change in value
;				   $iEndValue - Number of frames
; Return values .: Success - Returns the point of an interval between $iStartValue and $iEndValue.
;                  Failure - Returns 0
; Author ........: Josh Rowe
; Modified.......:
; Remarks .......: Transitions UDF: Advanced Transition
; Related .......: _QuadEaseIn, _QuadEaseOut, _QuadEaseInOut
; Related .......: _CubicEaseIn, _CubicEaseOut, _CubicEaseInOut
; Related .......: _QuarticEaseIn, _QuarticEaseOut, _QuarticEaseInOut
; Related .......: _QuinticEaseIn, _QuinticEaseOut, _QuinticEaseInOut
; Related .......: _SineEaseIn, _SineEaseOut, _SineEaseInOut
; Related .......: _ExpoEaseIn, _ExpoEaseOut, _ExpoEaseInOut
; Related .......: _CircEaseIn, _CircEaseOut, _CircEaseInOut
; Link ..........;
; Example .......; Yes
;
; ;==========================================================================================
Func _QuarticEaseOut($iFrame, $iStartValue, $iInterval, $iEndValue)
	$iFrame = $iFrame / $iEndValue
	$iFrame = $iFrame - 1
	Return -$iInterval * ($iFrame * $iFrame * $iFrame * $iFrame - 1) + $iStartValue
EndFunc   ;==>_QuarticEaseOut

; #FUNCTION# ;===============================================================================
;
; Name...........: _QuarticEaseInOut
; Description ...: Returns a linear interval between start and end points, acclerating from 0 velocity
; Syntax.........: _QuarticEaseInOut($iFrame, $iStartValue, $iInterval, $iEndValue)
; Parameters ....: $iFrame - Current frame, or point.
;				   $iStartValue - Beginning point
;				   $iInterval - Change in value
;				   $iEndValue - Number of frames
; Return values .: Success - Returns the point of an interval between $iStartValue and $iEndValue.
;                  Failure - Returns 0
; Author ........: Josh Rowe
; Modified.......:
; Remarks .......: Transitions UDF: Advanced Transition
; Related .......: _QuadEaseIn, _QuadEaseOut, _QuadEaseInOut
; Related .......: _CubicEaseIn, _CubicEaseOut, _CubicEaseInOut
; Related .......: _QuarticEaseIn, _QuarticEaseOut, _QuarticEaseInOut
; Related .......: _QuinticEaseIn, _QuinticEaseOut, _QuinticEaseInOut
; Related .......: _SineEaseIn, _SineEaseOut, _SineEaseInOut
; Related .......: _ExpoEaseIn, _ExpoEaseOut, _ExpoEaseInOut
; Related .......: _CircEaseIn, _CircEaseOut, _CircEaseInOut
; Link ..........;
; Example .......; Yes
;
; ;==========================================================================================
Func _QuarticEaseInOut($iFrame, $iStartValue, $iInterval, $iEndValue)
	$iFrame = $iFrame / ($iEndValue / 2)
	If $iFrame < 1 Then
		Return $iInterval / 2 * $iFrame * $iFrame * $iFrame * $iFrame + $iStartValue
	EndIf
	$iFrame = $iFrame - 2
	Return -$iInterval / 2 * ($iFrame * $iFrame * $iFrame * $iFrame - 2) + $iStartValue
EndFunc   ;==>_QuarticEaseInOut

; #FUNCTION# ;===============================================================================
;
; Name...........: _QuinticEaseIn
; Description ...: Returns a linear interval between start and end points, acclerating from 0 velocity
; Syntax.........: _QuinticEaseIn($iFrame, $iStartValue, $iInterval, $iEndValue)
; Parameters ....: $iFrame - Current frame, or point.
;				   $iStartValue - Beginning point
;				   $iInterval - Change in value
;				   $iEndValue - Number of frames
; Return values .: Success - Returns the point of an interval between $iStartValue and $iEndValue.
;                  Failure - Returns 0
; Author ........: Josh Rowe
; Modified.......:
; Remarks .......: Transitions UDF: Advanced Transition
; Related .......: _QuadEaseIn, _QuadEaseOut, _QuadEaseInOut
; Related .......: _CubicEaseIn, _CubicEaseOut, _CubicEaseInOut
; Related .......: _QuarticEaseIn, _QuarticEaseOut, _QuarticEaseInOut
; Related .......: _QuinticEaseIn, _QuinticEaseOut, _QuinticEaseInOut
; Related .......: _SineEaseIn, _SineEaseOut, _SineEaseInOut
; Related .......: _ExpoEaseIn, _ExpoEaseOut, _ExpoEaseInOut
; Related .......: _CircEaseIn, _CircEaseOut, _CircEaseInOut
; Link ..........;
; Example .......; Yes
;
; ;==========================================================================================
Func _QuinticEaseIn($iFrame, $iStartValue, $iInterval, $iEndValue)
	$iFrame = $iFrame / $iEndValue
	Return $iInterval * $iFrame * $iFrame * $iFrame * $iFrame * $iFrame + $iStartValue
EndFunc   ;==>_QuinticEaseIn

; #FUNCTION# ;===============================================================================
;
; Name...........: _QuinticEaseOut
; Description ...: Returns a linear interval between start and end points, acclerating from 0 velocity
; Syntax.........: _QuinticEaseOut($iFrame, $iStartValue, $iInterval, $iEndValue)
; Parameters ....: $iFrame - Current frame, or point.
;				   $iStartValue - Beginning point
;				   $iInterval - Change in value
;				   $iEndValue - Number of frames
; Return values .: Success - Returns the point of an interval between $iStartValue and $iEndValue.
;                  Failure - Returns 0
; Author ........: Josh Rowe
; Modified.......:
; Remarks .......: Transitions UDF: Advanced Transition
; Related .......: _QuadEaseIn, _QuadEaseOut, _QuadEaseInOut
; Related .......: _CubicEaseIn, _CubicEaseOut, _CubicEaseInOut
; Related .......: _QuarticEaseIn, _QuarticEaseOut, _QuarticEaseInOut
; Related .......: _QuinticEaseIn, _QuinticEaseOut, _QuinticEaseInOut
; Related .......: _SineEaseIn, _SineEaseOut, _SineEaseInOut
; Related .......: _ExpoEaseIn, _ExpoEaseOut, _ExpoEaseInOut
; Related .......: _CircEaseIn, _CircEaseOut, _CircEaseInOut
; Link ..........;
; Example .......; Yes
;
; ;==========================================================================================
Func _QuinticEaseOut($iFrame, $iStartValue, $iInterval, $iEndValue)
	$iFrame = $iFrame / $iEndValue
	$iFrame = $iFrame - 1
	Return $iInterval * ($iFrame * $iFrame * $iFrame * $iFrame * $iFrame + 1) + $iStartValue
EndFunc   ;==>_QuinticEaseOut

; #FUNCTION# ;===============================================================================
;
; Name...........: _QuinticEaseInOut
; Description ...: Returns a linear interval between start and end points, acclerating from 0 velocity
; Syntax.........: _QuinticEaseInOut($iFrame, $iStartValue, $iInterval, $iEndValue)
; Parameters ....: $iFrame - Current frame, or point.
;				   $iStartValue - Beginning point
;				   $iInterval - Change in value
;				   $iEndValue - Number of frames
; Return values .: Success - Returns the point of an interval between $iStartValue and $iEndValue.
;                  Failure - Returns 0
; Author ........: Josh Rowe
; Modified.......:
; Remarks .......: Transitions UDF: Advanced Transition
; Related .......: _QuadEaseIn, _QuadEaseOut, _QuadEaseInOut
; Related .......: _CubicEaseIn, _CubicEaseOut, _CubicEaseInOut
; Related .......: _QuarticEaseIn, _QuarticEaseOut, _QuarticEaseInOut
; Related .......: _QuinticEaseIn, _QuinticEaseOut, _QuinticEaseInOut
; Related .......: _SineEaseIn, _SineEaseOut, _SineEaseInOut
; Related .......: _ExpoEaseIn, _ExpoEaseOut, _ExpoEaseInOut
; Related .......: _CircEaseIn, _CircEaseOut, _CircEaseInOut
; Link ..........;
; Example .......; Yes
;
; ;==========================================================================================
Func _QuinticEaseInOut($iFrame, $iStartValue, $iInterval, $iEndValue)
	$iFrame = $iFrame / ($iEndValue / 2)
	If $iFrame < 1 Then
		Return $iInterval / 2 * $iFrame * $iFrame * $iFrame * $iFrame * $iFrame + $iStartValue
	EndIf
	$iFrame = $iFrame - 2
	Return $iInterval / 2 * ($iFrame * $iFrame * $iFrame * $iFrame * $iFrame + 2) + $iStartValue
EndFunc   ;==>_QuinticEaseInOut

; #FUNCTION# ;===============================================================================
;
; Name...........: _SineEaseIn
; Description ...: Returns a linear interval between start and end points, acclerating from 0 velocity
; Syntax.........: _SineEaseIn($iFrame, $iStartValue, $iInterval, $iEndValue)
; Parameters ....: $iFrame - Current frame, or point.
;				   $iStartValue - Beginning point
;				   $iInterval - Change in value
;				   $iEndValue - Number of frames
; Return values .: Success - Returns the point of an interval between $iStartValue and $iEndValue.
;                  Failure - Returns 0
; Author ........: Josh Rowe
; Modified.......:
; Remarks .......: Transitions UDF: Advanced Transition
; Related .......: _QuadEaseIn, _QuadEaseOut, _QuadEaseInOut
; Related .......: _CubicEaseIn, _CubicEaseOut, _CubicEaseInOut
; Related .......: _QuarticEaseIn, _QuarticEaseOut, _QuarticEaseInOut
; Related .......: _QuinticEaseIn, _QuinticEaseOut, _QuinticEaseInOut
; Related .......: _SineEaseIn, _SineEaseOut, _SineEaseInOut
; Related .......: _ExpoEaseIn, _ExpoEaseOut, _ExpoEaseInOut
; Related .......: _CircEaseIn, _CircEaseOut, _CircEaseInOut
; Link ..........;
; Example .......; Yes
;
; ;==========================================================================================
Func _SineEaseIn($iFrame, $iStartValue, $iInterval, $iEndValue)
	Return -$iInterval * Cos($iFrame / $iEndValue * ($PI / 2)) + $iInterval + $iStartValue
EndFunc   ;==>_SineEaseIn

; #FUNCTION# ;===============================================================================
;
; Name...........: _SineEaseOut
; Description ...: Returns a linear interval between start and end points, acclerating from 0 velocity
; Syntax.........: _SineEaseOut($iFrame, $iStartValue, $iInterval, $iEndValue)
; Parameters ....: $iFrame - Current frame, or point.
;				   $iStartValue - Beginning point
;				   $iInterval - Change in value
;				   $iEndValue - Number of frames
; Return values .: Success - Returns the point of an interval between $iStartValue and $iEndValue.
;                  Failure - Returns 0
; Author ........: Josh Rowe
; Modified.......:
; Remarks .......: Transitions UDF: Advanced Transition
; Related .......: _QuadEaseIn, _QuadEaseOut, _QuadEaseInOut
; Related .......: _CubicEaseIn, _CubicEaseOut, _CubicEaseInOut
; Related .......: _QuarticEaseIn, _QuarticEaseOut, _QuarticEaseInOut
; Related .......: _QuinticEaseIn, _QuinticEaseOut, _QuinticEaseInOut
; Related .......: _SineEaseIn, _SineEaseOut, _SineEaseInOut
; Related .......: _ExpoEaseIn, _ExpoEaseOut, _ExpoEaseInOut
; Related .......: _CircEaseIn, _CircEaseOut, _CircEaseInOut
; Link ..........;
; Example .......; Yes
;
; ;==========================================================================================
Func _SineEaseOut($iFrame, $iStartValue, $iInterval, $iEndValue)
	Return $iInterval * Sin($iFrame / $iEndValue * ($PI / 2)) + $iStartValue
EndFunc   ;==>_SineEaseOut

; #FUNCTION# ;===============================================================================
;
; Name...........: _SineEaseInOut
; Description ...: Returns a linear interval between start and end points, acclerating from 0 velocity
; Syntax.........: _SineEaseInOut($iFrame, $iStartValue, $iInterval, $iEndValue)
; Parameters ....: $iFrame - Current frame, or point.
;				   $iStartValue - Beginning point
;				   $iInterval - Change in value
;				   $iEndValue - Number of frames
; Return values .: Success - Returns the point of an interval between $iStartValue and $iEndValue.
;                  Failure - Returns 0
; Author ........: Josh Rowe
; Modified.......:
; Remarks .......: Transitions UDF: Advanced Transition
; Related .......: _QuadEaseIn, _QuadEaseOut, _QuadEaseInOut
; Related .......: _CubicEaseIn, _CubicEaseOut, _CubicEaseInOut
; Related .......: _QuarticEaseIn, _QuarticEaseOut, _QuarticEaseInOut
; Related .......: _QuinticEaseIn, _QuinticEaseOut, _QuinticEaseInOut
; Related .......: _SineEaseIn, _SineEaseOut, _SineEaseInOut
; Related .......: _ExpoEaseIn, _ExpoEaseOut, _ExpoEaseInOut
; Related .......: _CircEaseIn, _CircEaseOut, _CircEaseInOut
; Link ..........;
; Example .......; Yes
;
; ;==========================================================================================
Func _SineEaseInOut($iFrame, $iStartValue, $iInterval, $iEndValue)
	Return -$iInterval / 2 * (Cos($PI * $iFrame / $iEndValue) - 1) + $iStartValue
EndFunc   ;==>_SineEaseInOut

; #FUNCTION# ;===============================================================================
;
; Name...........: _ExpoEaseIn
; Description ...: Returns a linear interval between start and end points, acclerating from 0 velocity
; Syntax.........: _ExpoEaseIn($iFrame, $iStartValue, $iInterval, $iEndValue)
; Parameters ....: $iFrame - Current frame, or point.
;				   $iStartValue - Beginning point
;				   $iInterval - Change in value
;				   $iEndValue - Number of frames
; Return values .: Success - Returns the point of an interval between $iStartValue and $iEndValue.
;                  Failure - Returns 0
; Author ........: Josh Rowe
; Modified.......:
; Remarks .......: Transitions UDF: Advanced Transition
; Related .......: _QuadEaseIn, _QuadEaseOut, _QuadEaseInOut
; Related .......: _CubicEaseIn, _CubicEaseOut, _CubicEaseInOut
; Related .......: _QuarticEaseIn, _QuarticEaseOut, _QuarticEaseInOut
; Related .......: _QuinticEaseIn, _QuinticEaseOut, _QuinticEaseInOut
; Related .......: _SineEaseIn, _SineEaseOut, _SineEaseInOut
; Related .......: _ExpoEaseIn, _ExpoEaseOut, _ExpoEaseInOut
; Related .......: _CircEaseIn, _CircEaseOut, _CircEaseInOut
; Link ..........;
; Example .......; Yes
;
; ;==========================================================================================
Func _ExpoEaseIn($iFrame, $iStartValue, $iInterval, $iEndValue)
	Return $iInterval * (2 ^ (10 * ($iFrame / $iEndValue - 1))) + $iStartValue
EndFunc   ;==>_ExpoEaseIn

; #FUNCTION# ;===============================================================================
;
; Name...........: _ExpoEaseOut
; Description ...: Returns a linear interval between start and end points, acclerating from 0 velocity
; Syntax.........: _ExpoEaseOut($iFrame, $iStartValue, $iInterval, $iEndValue)
; Parameters ....: $iFrame - Current frame, or point.
;				   $iStartValue - Beginning point
;				   $iInterval - Change in value
;				   $iEndValue - Number of frames
; Return values .: Success - Returns the point of an interval between $iStartValue and $iEndValue.
;                  Failure - Returns 0
; Author ........: Josh Rowe
; Modified.......:
; Remarks .......: Transitions UDF: Advanced Transition
; Related .......: _QuadEaseIn, _QuadEaseOut, _QuadEaseInOut
; Related .......: _CubicEaseIn, _CubicEaseOut, _CubicEaseInOut
; Related .......: _QuarticEaseIn, _QuarticEaseOut, _QuarticEaseInOut
; Related .......: _QuinticEaseIn, _QuinticEaseOut, _QuinticEaseInOut
; Related .......: _SineEaseIn, _SineEaseOut, _SineEaseInOut
; Related .......: _ExpoEaseIn, _ExpoEaseOut, _ExpoEaseInOut
; Related .......: _CircEaseIn, _CircEaseOut, _CircEaseInOut
; Link ..........;
; Example .......; Yes
;
; ;==========================================================================================
Func _ExpoEaseOut($iFrame, $iStartValue, $iInterval, $iEndValue)
	;return c * ( -Math.pow( 2, -10 * t/d ) + 1 )
	Return $iInterval * (-(2 ^ (-10 * $iFrame / $iEndValue)) + 1) + $iStartValue
EndFunc   ;==>_ExpoEaseOut

; #FUNCTION# ;===============================================================================
;
; Name...........: _ExpoEaseInOut
; Description ...: Returns a linear interval between start and end points, acclerating from 0 velocity
; Syntax.........: _ExpoEaseInOut($iFrame, $iStartValue, $iInterval, $iEndValue)
; Parameters ....: $iFrame - Current frame, or point.
;				   $iStartValue - Beginning point
;				   $iInterval - Change in value
;				   $iEndValue - Number of frames
; Return values .: Success - Returns the point of an interval between $iStartValue and $iEndValue.
;                  Failure - Returns 0
; Author ........: Josh Rowe
; Modified.......:
; Remarks .......: Transitions UDF: Advanced Transition
; Related .......: _QuadEaseIn, _QuadEaseOut, _QuadEaseInOut
; Related .......: _CubicEaseIn, _CubicEaseOut, _CubicEaseInOut
; Related .......: _QuarticEaseIn, _QuarticEaseOut, _QuarticEaseInOut
; Related .......: _QuinticEaseIn, _QuinticEaseOut, _QuinticEaseInOut
; Related .......: _SineEaseIn, _SineEaseOut, _SineEaseInOut
; Related .......: _ExpoEaseIn, _ExpoEaseOut, _ExpoEaseInOut
; Related .......: _CircEaseIn, _CircEaseOut, _CircEaseInOut
; Link ..........;
; Example .......; Yes
;
; ;==========================================================================================
Func _ExpoEaseInOut($iFrame, $iStartValue, $iInterval, $iEndValue)
	$iFrame = $iFrame / ($iEndValue / 2)
	If $iFrame < 1 Then
		Return $iInterval / 2 * (2 ^ (10 * ($iFrame - 1))) + $iStartValue
	EndIf

	$iFrame = $iFrame - 1
	Return $iInterval / 2 * (-(2 ^ (-10 * $iFrame)) + 2) + $iStartValue
EndFunc   ;==>_ExpoEaseInOut

; #FUNCTION# ;===============================================================================
;
; Name...........: _CircEaseIn
; Description ...: Returns a linear interval between start and end points, acclerating from 0 velocity
; Syntax.........: _CircEaseIn($iFrame, $iStartValue, $iInterval, $iEndValue)
; Parameters ....: $iFrame - Current frame, or point.
;				   $iStartValue - Beginning point
;				   $iInterval - Change in value
;				   $iEndValue - Number of frames
; Return values .: Success - Returns the point of an interval between $iStartValue and $iEndValue.
;                  Failure - Returns 0
; Author ........: Josh Rowe
; Modified.......:
; Remarks .......: Transitions UDF: Advanced Transition
; Related .......: _QuadEaseIn, _QuadEaseOut, _QuadEaseInOut
; Related .......: _CubicEaseIn, _CubicEaseOut, _CubicEaseInOut
; Related .......: _QuarticEaseIn, _QuarticEaseOut, _QuarticEaseInOut
; Related .......: _QuinticEaseIn, _QuinticEaseOut, _QuinticEaseInOut
; Related .......: _SineEaseIn, _SineEaseOut, _SineEaseInOut
; Related .......: _ExpoEaseIn, _ExpoEaseOut, _ExpoEaseInOut
; Related .......: _CircEaseIn, _CircEaseOut, _CircEaseInOut
; Link ..........;
; Example .......; Yes
;
; ;==========================================================================================
Func _CircEaseIn($iFrame, $iStartValue, $iInterval, $iEndValue)
	$iFrame = $iFrame / $iEndValue
	Return -$iInterval * (Sqrt(1 - ($iFrame * $iFrame)) - 1) + $iStartValue
EndFunc   ;==>_CircEaseIn

; #FUNCTION# ;===============================================================================
;
; Name...........: _CircEaseOut
; Description ...: Returns a linear interval between start and end points, acclerating from 0 velocity
; Syntax.........: _CircEaseOut($iFrame, $iStartValue, $iInterval, $iEndValue)
; Parameters ....: $iFrame - Current frame, or point.
;				   $iStartValue - Beginning point
;				   $iInterval - Change in value
;				   $iEndValue - Number of frames
; Return values .: Success - Returns the point of an interval between $iStartValue and $iEndValue.
;                  Failure - Returns 0
; Author ........: Josh Rowe
; Modified.......:
; Remarks .......: Transitions UDF: Advanced Transition
; Related .......: _QuadEaseIn, _QuadEaseOut, _QuadEaseInOut
; Related .......: _CubicEaseIn, _CubicEaseOut, _CubicEaseInOut
; Related .......: _QuarticEaseIn, _QuarticEaseOut, _QuarticEaseInOut
; Related .......: _QuinticEaseIn, _QuinticEaseOut, _QuinticEaseInOut
; Related .......: _SineEaseIn, _SineEaseOut, _SineEaseInOut
; Related .......: _ExpoEaseIn, _ExpoEaseOut, _ExpoEaseInOut
; Related .......: _CircEaseIn, _CircEaseOut, _CircEaseInOut
; Link ..........;
; Example .......; Yes
;
; ;==========================================================================================
Func _CircEaseOut($iFrame, $iStartValue, $iInterval, $iEndValue)
	$iFrame = $iFrame / $iEndValue
	$iFrame = $iFrame - 1
	Return $iInterval * Sqrt(1 - $iFrame * $iFrame) + $iStartValue
EndFunc   ;==>_CircEaseOut

; #FUNCTION# ;===============================================================================
;
; Name...........: _CircEaseInOut
; Description ...: Returns a linear interval between start and end points, acclerating from 0 velocity
; Syntax.........: _CircEaseInOut($iFrame, $iStartValue, $iInterval, $iEndValue)
; Parameters ....: $iFrame - Current frame, or point.
;				   $iStartValue - Beginning point
;				   $iInterval - Change in value
;				   $iEndValue - Number of frames
; Return values .: Success - Returns the point of an interval between $iStartValue and $iEndValue.
;                  Failure - Returns 0
; Author ........: Josh Rowe
; Modified.......:
; Remarks .......: Transitions UDF: Advanced Transition
; Related .......: _QuadEaseIn, _QuadEaseOut, _QuadEaseInOut
; Related .......: _CubicEaseIn, _CubicEaseOut, _CubicEaseInOut
; Related .......: _QuarticEaseIn, _QuarticEaseOut, _QuarticEaseInOut
; Related .......: _QuinticEaseIn, _QuinticEaseOut, _QuinticEaseInOut
; Related .......: _SineEaseIn, _SineEaseOut, _SineEaseInOut
; Related .......: _ExpoEaseIn, _ExpoEaseOut, _ExpoEaseInOut
; Related .......: _CircEaseIn, _CircEaseOut, _CircEaseInOut
; Link ..........;
; Example .......; Yes
;
; ;==========================================================================================
Func _CircEaseInOut($iFrame, $iStartValue, $iInterval, $iEndValue)
	$iFrame = $iFrame / ($iEndValue / 2)
	If $iFrame < 1 Then
		Return -$iInterval / 2 * (Sqrt(1 - $iFrame * $iFrame) - 1) + $iStartValue
	EndIf
	$iFrame = $iFrame - 2
	Return $iInterval / 2 * (Sqrt(1 - $iFrame * $iFrame) + 1) + $iStartValue
EndFunc   ;==>_CircEaseInOut
