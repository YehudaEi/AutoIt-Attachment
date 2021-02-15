#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_UseX64=n
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#include <ButtonConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <_Transitions.au3>

$Form2 = GUICreate("Transitions", 672, 587, 225, 108)
GUISetBkColor(0x000000)
$_LinearTween = GUICtrlCreateLabel("", 114, 2, 12, 12)
GUICtrlSetColor(-1, 0xFFFFFF)
GUICtrlSetBkColor(-1, 0x80FF80)
$_LinearTweenSlowRate = GUICtrlCreateLabel("", 114, 14, 12, 12)
GUICtrlSetColor(-1, 0xFFFFFF)
GUICtrlSetBkColor(-1, 0x80FF80)
$_QuadEaseIn = GUICtrlCreateLabel("", 114, 28, 12, 12)
GUICtrlSetColor(-1, 0xFFFFFF)
GUICtrlSetBkColor(-1, 0x80FFFF)
$_QuadEaseOut = GUICtrlCreateLabel("", 114, 53, 12, 12)
GUICtrlSetColor(-1, 0xFFFFFF)
GUICtrlSetBkColor(-1, 0x0080FF)
$_QuadEaseInOut = GUICtrlCreateLabel("", 114, 79, 12, 12)
GUICtrlSetColor(-1, 0xFFFFFF)
GUICtrlSetBkColor(-1, 0xFF0000)
$_QuarticEaseIn = GUICtrlCreateLabel("", 114, 181, 12, 12)
GUICtrlSetColor(-1, 0xFFFFFF)
GUICtrlSetBkColor(-1, 0x800040)
$_CubicEaseInOut = GUICtrlCreateLabel("", 114, 155, 12, 12)
GUICtrlSetColor(-1, 0xFFFFFF)
GUICtrlSetBkColor(-1, 0xFF8000)
$_CubicEaseOut = GUICtrlCreateLabel("", 114, 130, 12, 12)
GUICtrlSetColor(-1, 0xFFFFFF)
GUICtrlSetBkColor(-1, 0x004080)
$_CubicEaseIn = GUICtrlCreateLabel("", 114, 104, 12, 12)
GUICtrlSetColor(-1, 0xFFFFFF)
GUICtrlSetBkColor(-1, 0xFFFF00)
$_SineEaseInOut = GUICtrlCreateLabel("", 114, 386, 12, 12)
GUICtrlSetColor(-1, 0xFFFFFF)
GUICtrlSetBkColor(-1, 0x808080)
$_SineEaseOut = GUICtrlCreateLabel("", 114, 360, 12, 12)
GUICtrlSetColor(-1, 0xFFFFFF)
GUICtrlSetBkColor(-1, 0x800080)
$_SineEaseIn = GUICtrlCreateLabel("", 114, 335, 12, 12)
GUICtrlSetColor(-1, 0xFFFFFF)
GUICtrlSetBkColor(-1, 0xFFFFFF)
$_QuinticEaseInOut = GUICtrlCreateLabel("", 114, 309, 12, 12)
GUICtrlSetColor(-1, 0xFFFFFF)
GUICtrlSetBkColor(-1, 0x808040)
$_QuinticEaseOut = GUICtrlCreateLabel("", 114, 283, 12, 12)
GUICtrlSetColor(-1, 0xFFFFFF)
GUICtrlSetBkColor(-1, 0x808080)
$_QuinticEaseIn = GUICtrlCreateLabel("", 114, 258, 12, 12)
GUICtrlSetColor(-1, 0xFFFFFF)
GUICtrlSetBkColor(-1, 0x804000)
$_QuarticEaseInOut = GUICtrlCreateLabel("", 114, 232, 12, 12)
GUICtrlSetColor(-1, 0xFFFFFF)
GUICtrlSetBkColor(-1, 0xFF0080)
$_QuarticEaseOut = GUICtrlCreateLabel("", 114, 207, 12, 12)
GUICtrlSetColor(-1, 0xFFFFFF)
GUICtrlSetBkColor(-1, 0x0080C0)
$_CircEaseIn = GUICtrlCreateLabel("", 114, 488, 12, 12)
GUICtrlSetColor(-1, 0xFFFFFF)
GUICtrlSetBkColor(-1, 0x8080FF)
$_ExpoEaseInOut = GUICtrlCreateLabel("", 114, 462, 12, 12)
GUICtrlSetColor(-1, 0xFFFFFF)
GUICtrlSetBkColor(-1, 0xFF8080)
$_ExpoEaseOut = GUICtrlCreateLabel("", 114, 437, 12, 12)
GUICtrlSetColor(-1, 0xFFFFFF)
GUICtrlSetBkColor(-1, 0x008080)
$_ExpoEaseIn = GUICtrlCreateLabel("", 114, 411, 12, 12)
GUICtrlSetColor(-1, 0xFFFFFF)
GUICtrlSetBkColor(-1, 0xFF80FF)
$_CircEaseIn = GUICtrlCreateLabel("", 114, 488, 12, 12)
GUICtrlSetColor(-1, 0xFFFFFF)
GUICtrlSetBkColor(-1, 0x8080FF)
$_CircEaseOut = GUICtrlCreateLabel("", 114, 512, 12, 12)
GUICtrlSetColor(-1, 0x000000)
GUICtrlSetBkColor(-1, 0x00FF00)
$_CircEaseInOut = GUICtrlCreateLabel("", 114, 536, 12, 12)
GUICtrlSetColor(-1, 0xFFFFFF)
GUICtrlSetBkColor(-1, 0xFF8000)

$Button1 = GUICtrlCreateButton("Go!", 288, 552, 75, 25)
$Button2 = GUICtrlCreateButton("Don't Block", 388, 552, 75, 25)

$Label22 = GUICtrlCreateLabel("_LinearTween", 16, 0, 72, 17)
GUICtrlSetColor(-1, 0xFFFFFF)
$Label23 = GUICtrlCreateLabel("_QuadEaseIn", 16, 24, 69, 17)
GUICtrlSetColor(-1, 0xFFFFFF)
$Label24 = GUICtrlCreateLabel("_QuadEaseOut", 16, 53, 77, 17)
GUICtrlSetColor(-1, 0xFFFFFF)
$Label25 = GUICtrlCreateLabel("_QuadEaseInOut", 16, 79, 86, 17)
GUICtrlSetColor(-1, 0xFFFFFF)
$Label26 = GUICtrlCreateLabel("_CubicEaseIn", 16, 104, 70, 17)
GUICtrlSetColor(-1, 0xFFFFFF)
$Label27 = GUICtrlCreateLabel("_CubicEaseOut", 16, 130, 78, 17)
GUICtrlSetColor(-1, 0xFFFFFF)
$Label28 = GUICtrlCreateLabel("_CubicEaseInOut", 16, 155, 87, 17)
GUICtrlSetColor(-1, 0xFFFFFF)
$Label29 = GUICtrlCreateLabel("_QuarticEaseIn", 16, 181, 77, 17)
GUICtrlSetColor(-1, 0xFFFFFF)
$Label30 = GUICtrlCreateLabel("_QuarticEaseOut", 16, 207, 85, 17)
GUICtrlSetColor(-1, 0xFFFFFF)
$Label31 = GUICtrlCreateLabel("_QuarticEaseInOut", 16, 232, 94, 17)
GUICtrlSetColor(-1, 0xFFFFFF)
$Label32 = GUICtrlCreateLabel("_QuinticEaseIn", 16, 258, 76, 17)
GUICtrlSetColor(-1, 0xFFFFFF)
$Label33 = GUICtrlCreateLabel("_QuinticEaseOut", 16, 283, 84, 17)
GUICtrlSetColor(-1, 0xFFFFFF)
$Label34 = GUICtrlCreateLabel("_QuinticEaseInOut", 16, 309, 93, 17)
GUICtrlSetColor(-1, 0xFFFFFF)
$Label35 = GUICtrlCreateLabel("_SineEaseIn", 16, 335, 64, 17)
GUICtrlSetColor(-1, 0xFFFFFF)
$Label36 = GUICtrlCreateLabel("_SineEaseOut", 16, 360, 72, 17)
GUICtrlSetColor(-1, 0xFFFFFF)
$Label37 = GUICtrlCreateLabel("_SineEaseInOut", 16, 386, 81, 17)
GUICtrlSetColor(-1, 0xFFFFFF)
$Label38 = GUICtrlCreateLabel("_ExpoEaseIn", 16, 411, 67, 17)
GUICtrlSetColor(-1, 0xFFFFFF)
$Label39 = GUICtrlCreateLabel("_ExpoEaseOut", 16, 437, 75, 17)
GUICtrlSetColor(-1, 0xFFFFFF)
$Label40 = GUICtrlCreateLabel("_ExpoEaseInOut", 16, 462, 84, 17)
GUICtrlSetColor(-1, 0xFFFFFF)
$Label41 = GUICtrlCreateLabel("_CircEaseIn", 16, 488, 61, 17)
GUICtrlSetColor(-1, 0xFFFFFF)
$Label42 = GUICtrlCreateLabel("_CircEaseIn", 16, 512, 61, 17)
GUICtrlSetColor(-1, 0xFFFFFF)
$Label2 = GUICtrlCreateLabel("_CircEaseInOut", 16, 536, 78, 17)
GUICtrlSetColor(-1, 0xFFFFFF)
GUISetState(@SW_SHOW)

Global $tID[24]
$tID[0] = _Transition_Create(114, 640, 5, "_TransitionLinearTween", $LINEAR_TWEEN)
$tID[1] = _Transition_Create(114, 640, 5, "_TransitionLinearTweenSlowRate", $LINEAR_TWEEN, 250)
$tID[2] = _Transition_Create(114, 640, 5, "_TransitionQuadEaseIn", $QUAD_EASE_IN)
$tID[3] = _Transition_Create(114, 640, 5, "_TransitionQuadEaseOut", $QUAD_EASE_OUT)
$tID[4] = _Transition_Create(114, 640, 5, "_TransitionQuadEaseInOut", $QUAD_EASE_IN_OUT)
$tID[5] = _Transition_Create(255,0,2.5,"_trans",$LINEAR_TWEEN)
$tID[6] = _Transition_Create(114, 640, 5, "_TransitionCubicEaseIn", $CUBIC_EASE_IN)
$tID[7] = _Transition_Create(114, 640, 5, "_TransitionCubicEaseOut", $CUBIC_EASE_OUT)
$tID[8] = _Transition_Create(114, 640, 5, "_TransitionCubicEaseInOut", $CUBIC_EASE_IN_OUT)
$tID[9] = _Transition_Create(114, 640, 5, "_TransitionQuarticEaseIn", $QUARTIC_EASE_IN)
$tID[10] = _Transition_Create(114, 640, 5, "_TransitionQuarticEaseOut", $QUARTIC_EASE_OUT)
$tID[11] = _Transition_Create(114, 640, 5, "_TransitionQuarticEaseInOut", $QUARTIC_EASE_IN_OUT)
$tID[12] = _Transition_Create(114, 640, 5, "_TransitionQuinticEaseIn", $QUINTIC_EASE_IN)
$tID[13] = _Transition_Create(114, 640, 5, "_TransitionQuinticEaseOut", $QUINTIC_EASE_OUT)
$tID[14] = _Transition_Create(114, 640, 5, "_TransitionQuinticEaseInOut", $QUINTIC_EASE_IN_OUT)
$tID[15] = _Transition_Create(114, 640, 5, "_TransitionSineEaseIn", $SINE_EASE_IN)
$tID[16] = _Transition_Create(114, 640, 5, "_TransitionSineEaseOut", $SINE_EASE_OUT)
$tID[17] = _Transition_Create(114, 640, 5, "_TransitionSineEaseInOut", $SINE_EASE_IN_OUT)
$tID[18] = _Transition_Create(114, 640, 5, "_TransitionExpoEaseIn", $EXPO_EASE_IN)
$tID[19] = _Transition_Create(114, 640, 5, "_TransitionExpoEaseOut", $EXPO_EASE_OUT)
$tID[20] = _Transition_Create(114, 640, 5, "_TransitionExpoEaseInOut", $EXPO_EASE_IN_OUT)
$tID[21] = _Transition_Create(114, 640, 5, "_TransitionCircEaseIn", $CIRC_EASE_IN)
$tID[22] = _Transition_Create(114, 640, 5, "_TransitionCircEaseOut", $CIRC_EASE_OUT)
$tID[23] = _Transition_Create(114, 640, 5, "_TransitionCircEaseInOut", $CIRC_EASE_IN_OUT)

$transTransition = _Transition_Create(0,255,2.5,"_trans",$LINEAR_TWEEN)

While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			Exit
		Case $Button2
			MsgBox(-1, "Non Blocking", "Non Blocking")
		Case $Button1
			_Transition_Stop_All()
			For $n = 0 To 5
				_Transition_Start($tID[$n])
			Next
	EndSwitch
WEnd

Func _trans($n)
	WinSetTrans("Transitions","",$n)
	If $n = 0 Then
		_Transition_Stop($tID[5])
		_Transition_Start($transTransition)
	EndIf
EndFunc

Func _TransitionLinearTween($n)
	GUICtrlSetPos($_LinearTween, $n, 2)
	If $n > 400 Then
		_Transition_Stop($tID[0])
	EndIf
EndFunc   ;==>_TransitionLinearTween

Func _TransitionLinearTweenSlowRate($n)
	GUICtrlSetPos($_LinearTweenSlowRate, $n, 14)
EndFunc   ;==>_TransitionLinearTweenSlowRate

Func _TransitionQuadEaseIn($n)
	GUICtrlSetPos($_QuadEaseIn, $n, 28)
EndFunc   ;==>_TransitionQuadEaseIn

Func _TransitionQuadEaseOut($n)
	GUICtrlSetPos($_QuadEaseOut, $n, 53)
EndFunc   ;==>_TransitionQuadEaseOut

Func _TransitionQuadEaseInOut($n)
	GUICtrlSetBkColor($_QuadEaseInOut, $n)
	GUICtrlSetPos($_QuadEaseInOut, $n, 79)
EndFunc   ;==>_TransitionQuadEaseInOut

Func _TransitionCubicEaseIn($n)
	GUICtrlSetPos($_CubicEaseIn, $n, 104)
EndFunc   ;==>_TransitionCubicEaseIn

Func _TransitionCubicEaseOut($n)
	GUICtrlSetPos($_CubicEaseOut, $n, 130)
EndFunc   ;==>_TransitionCubicEaseOut

Func _TransitionCubicEaseInOut($n)
	GUICtrlSetPos($_CubicEaseInOut, $n, 155)
EndFunc   ;==>_TransitionCubicEaseInOut

Func _TransitionQuarticEaseIn($n)
	GUICtrlSetPos($_QuarticEaseIn, $n, 181)
EndFunc   ;==>_TransitionQuarticEaseIn

Func _TransitionQuarticEaseOut($n)
	GUICtrlSetPos($_QuarticEaseOut, $n, 207)
EndFunc   ;==>_TransitionQuarticEaseOut

Func _TransitionQuarticEaseInOut($n)
	GUICtrlSetPos($_QuarticEaseInOut, $n, 232)
EndFunc   ;==>_TransitionQuarticEaseInOut

Func _TransitionQuinticEaseIn($n)
	GUICtrlSetPos($_QuinticEaseIn, $n, 258)
EndFunc   ;==>_TransitionQuinticEaseIn

Func _TransitionQuinticEaseOut($n)
	GUICtrlSetPos($_QuinticEaseOut, $n, 283)
EndFunc   ;==>_TransitionQuinticEaseOut

Func _TransitionQuinticEaseInOut($n)
	GUICtrlSetPos($_QuinticEaseInOut, $n, 309)
EndFunc   ;==>_TransitionQuinticEaseInOut

Func _TransitionSineEaseIn($n)
	GUICtrlSetPos($_SineEaseIn, $n, 335)
EndFunc   ;==>_TransitionSineEaseIn

Func _TransitionSineEaseOut($n)
	GUICtrlSetPos($_SineEaseOut, $n, 360)
EndFunc   ;==>_TransitionSineEaseOut

Func _TransitionSineEaseInOut($n)
	GUICtrlSetPos($_SineEaseInOut, $n, 386)
EndFunc   ;==>_TransitionSineEaseInOut

Func _TransitionExpoEaseIn($n)
	GUICtrlSetPos($_ExpoEaseIn, $n, 411)
EndFunc   ;==>_TransitionExpoEaseIn

Func _TransitionExpoEaseOut($n)
	GUICtrlSetPos($_ExpoEaseOut, $n, 437)
EndFunc   ;==>_TransitionExpoEaseOut

Func _TransitionExpoEaseInOut($n)
	GUICtrlSetPos($_ExpoEaseInOut, $n, 462)
EndFunc   ;==>_TransitionExpoEaseInOut

Func _TransitionCircEaseIn($n)
	GUICtrlSetPos($_CircEaseIn, $n, 488)
EndFunc   ;==>_TransitionCircEaseIn

Func _TransitionCircEaseOut($n)
	GUICtrlSetPos($_CircEaseOut, $n, 512)
EndFunc   ;==>_TransitionCircEaseOut

Func _TransitionCircEaseInOut($n)
	GUICtrlSetPos($_CircEaseInOut, $n, 536)
EndFunc   ;==>_TransitionCircEaseInOut