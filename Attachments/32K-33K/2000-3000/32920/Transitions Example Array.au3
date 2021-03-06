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

Global $tID[23]
$tID[0] = _Transition_Create(114, 640, 5, "_TransitionLinearTween", $LINEAR_TWEEN)
$tID[1] = _Transition_Create(114, 640, 5, "_TransitionQuadEaseIn", $QUAD_EASE_IN)
$tID[2] = _Transition_Create(114, 640, 5, "_TransitionQuadEaseOut", $QUAD_EASE_OUT)
$tID[3] = _Transition_Create(114, 640, 5, "_TransitionQuadEaseInOut", $QUAD_EASE_IN_OUT)
$tID[4] = _Transition_Create(114, 640, 5, "_TransitionCubicEaseIn", $CUBIC_EASE_IN)
$tID[5] = _Transition_Create(114, 640, 5, "_TransitionCubicEaseOut", $CUBIC_EASE_OUT)
$tID[6] = _Transition_Create(114, 640, 5, "_TransitionCubicEaseInOut", $CUBIC_EASE_IN_OUT)
$tID[7] = _Transition_Create(114, 640, 5, "_TransitionQuarticEaseIn", $QUARTIC_EASE_IN)
$tID[8] = _Transition_Create(114, 640, 5, "_TransitionQuarticEaseOut", $QUARTIC_EASE_OUT)
$tID[9] = _Transition_Create(114, 640, 5, "_TransitionQuarticEaseInOut", $QUARTIC_EASE_IN_OUT)
$tID[10] = _Transition_Create(114, 640, 5, "_TransitionQuinticEaseIn", $QUINTIC_EASE_IN)
$tID[11] = _Transition_Create(114, 640, 5, "_TransitionQuinticEaseOut", $QUINTIC_EASE_OUT)
$tID[12] = _Transition_Create(114, 640, 5, "_TransitionQuinticEaseInOut", $QUINTIC_EASE_IN_OUT)
$tID[13] = _Transition_Create(114, 640, 5, "_TransitionSineEaseIn", $SINE_EASE_IN)
$tID[14] = _Transition_Create(114, 640, 5, "_TransitionSineEaseOut", $SINE_EASE_OUT)
$tID[15] = _Transition_Create(114, 640, 5, "_TransitionSineEaseInOut", $SINE_EASE_IN_OUT)
$tID[16] = _Transition_Create(114, 640, 5, "_TransitionExpoEaseIn", $EXPO_EASE_IN)
$tID[17] = _Transition_Create(114, 640, 5, "_TransitionExpoEaseOut", $EXPO_EASE_OUT)
$tID[18] = _Transition_Create(114, 640, 5, "_TransitionExpoEaseInOut", $EXPO_EASE_IN_OUT)
$tID[19] = _Transition_Create(114, 640, 5, "_TransitionCircEaseIn", $CIRC_EASE_IN)
$tID[20] = _Transition_Create(114, 640, 5, "_TransitionCircEaseOut", $CIRC_EASE_OUT)
$tID[21] = _Transition_Create(114, 640, 5, "_TransitionCircEaseInOut", $CIRC_EASE_IN_OUT)

While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			Exit
		Case $Button2
			MsgBox(-1, "Non Blocking", "Non Blocking")
		Case $Button1
			_Transition_Stop_All()
			Global $transitionID = _Transition_Array_Start($tID, "_TransitionTween")
	EndSwitch
WEnd

Func _TransitionTween($n)
	;If $n[0] > 500 Then
	;	_Transition_Array_Stop($transitionID)
	;EndIf
	GUICtrlSetPos($_LinearTween, $n[0], 2)
	GUICtrlSetPos($_QuadEaseIn, $n[1], 28)
	GUICtrlSetPos($_QuadEaseOut, $n[2], 53)
	GUICtrlSetPos($_QuadEaseInOut, $n[3], 79)
	GUICtrlSetPos($_CubicEaseIn, $n[4], 104)
	GUICtrlSetPos($_CubicEaseOut, $n[5], 130)
	GUICtrlSetPos($_CubicEaseInOut, $n[6], 155)
	GUICtrlSetPos($_QuarticEaseIn, $n[7], 181)
	GUICtrlSetPos($_QuarticEaseOut, $n[8], 207)
	GUICtrlSetPos($_QuarticEaseInOut, $n[9], 232)
	GUICtrlSetPos($_QuinticEaseIn, $n[10], 258)
	GUICtrlSetPos($_QuinticEaseOut, $n[11], 283)
	GUICtrlSetPos($_QuinticEaseInOut, $n[12], 309)
	GUICtrlSetPos($_SineEaseIn, $n[13], 335)
	GUICtrlSetPos($_SineEaseOut, $n[14], 360)
	GUICtrlSetPos($_SineEaseInOut, $n[15], 386)
	GUICtrlSetPos($_ExpoEaseIn, $n[16], 411)
	GUICtrlSetPos($_ExpoEaseOut, $n[17], 437)
	GUICtrlSetPos($_ExpoEaseInOut, $n[18], 462)
	GUICtrlSetPos($_CircEaseIn, $n[19], 488)
	GUICtrlSetPos($_CircEaseOut, $n[20], 512)
	GUICtrlSetPos($_CircEaseInOut, $n[21], 536)
EndFunc   ;==>_TransitionTween
