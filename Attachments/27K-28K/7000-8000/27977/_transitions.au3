Global Const $PI = 3.14159265358979
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
