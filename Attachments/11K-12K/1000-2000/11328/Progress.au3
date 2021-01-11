;===============================================================================
;
; Function Name:   _ProgressOn
; Description::    Creates a 'ProgressOn like' progress bar in a gui
; Syntax:		   Dim $progress, $main, $sub ;make sure you dim the first three variables. they are the controlId's
;				   _ProgressOn($progress, $main, $sub, "This is the main text", "This is the sub-text", 150, 10)
; Parameter(s):    $s_mainlabel($main-text var), $s_sublabel($sub-text var),
;				   $s_control($progress var), $s_main(Main text), $s_sub(Sub Text), $x(Position), $y(Position), $fSmooth(1 for smooth, 0 for not smooth)
; Requirement(s):  AutoIt, #include <file.au3>
; Return Value(s): Success - Returns array
;				   $array[0] - $progress id
;				   $array[1] - Main Label
;				   $array[2] - Sub label
;				   $array[3] - x pos
;				   $array[4] - y pos
;				   Failure - 0 and sets @error to 1
; Author(s):       RazerM
;
;===============================================================================
;
Func _ProgressOn(ByRef $s_mainlabel, ByRef $s_sublabel, ByRef $s_control, $s_main, $s_sub, $x, $y, $fSmooth = 0)
	$s_mainlabel = GUICtrlCreateLabel($s_main, $x, $y, StringLen($s_main) * 10)
	If $s_mainlabel = 0 Then
		SetError(1)
		Return 0
	EndIf
	GUICtrlSetFont($s_mainlabel, 14)
	If StringInStr(@OSTYPE, "WIN32_NT") And $fSmooth = 1 Then
		$prev = DllCall("uxtheme.dll", "int", "GetThemeAppProperties");, "int", 0)
		DllCall("uxtheme.dll", "none", "SetThemeAppProperties", "int", 0)
	EndIf
	$s_control = GUICtrlCreateProgress($x, $y + 30, 260, 20, $PBS_SMOOTH)
	If StringInStr(@OSTYPE, "WIN32_NT") And $fSmooth = 1 Then
		DllCall("uxtheme.dll", "none", "SetThemeAppProperties", "int", $prev[0])
	EndIf
	If $s_control = 0 Then
		SetError(1)
		Return 0
	EndIf
	$s_sublabel = GUICtrlCreateLabel($s_sub, $x, $y + 55)
	If $s_sublabel = 0 Then
		SetError(1)
		Return 0
	EndIf
	Dim $a_info[5]
	$a_info[0] = $s_control
	$a_info[1] = $s_mainlabel
	$a_info[2] = $s_sublabel
	$a_info[3] = $x
	$a_info[4] = $y
	Return $a_info
EndFunc   ;==>_ProgressOn
;===============================================================================
;
; Function Name:   _ProgressSet
; Description::    Sets a progressbar created with _ProgressOn
; Parameter(s):    $a_info(Progress Id returned by _ProgressOn), $i_per(Percent), $s_sub(Sub text)[optional], $s_main(main text)[optional]
; Requirement(s):  AutoIt, #include <file.au3>
; Return Value(s): Success - 1, Failure - 0 and sets @error to 1
; Author(s):       RazerM
;
;===============================================================================
;
Func _ProgressSet($a_info, $i_per, $s_sub = "", $s_main = "")
	If $s_main = "" Then $s_main = GUICtrlRead($a_info[1])
	If $s_sub = "" Then $s_sub = GUICtrlRead($a_info[2])
	$set1 = GUICtrlSetData($a_info[0], $i_per)
	$set2 = GUICtrlSetData($a_info[1], $s_main)
	$set3 = GUICtrlSetData($a_info[2], $s_sub)
	GUICtrlSetPos($a_info[2], $a_info[3], $a_info[4]+55, StringLen($s_sub)*6)
	GUICtrlSetPos($a_info[1], $a_info[3], $a_info[4], StringLen($s_main)*10)
	If ($set1 = 0) Or ($set2 = 0) Or ($set3 = 0) Then
		SetError(1)
		Return 0
	EndIf
	If ($set1 = -1) Or ($set2 = -1) Or ($set3 = -1) Then
		SetError(1)
		Return 0
	EndIf
	Return 1
EndFunc

;===============================================================================
;
; Function Name:   _ProgressOff()
; Description::    Deletes a progress bar created with _ProgressOn()
; Parameter(s):    $a_info(Progress Id returned by _ProgressOn)
; Requirement(s):  AutoIt, #include <file.au3>
; Return Value(s): Success - 1, Failure - 0 and sets @error to 1
; Author(s):       RazerM
;
;===============================================================================
;

Func _ProgressOff($a_info)
	$del1 = GUICtrlDelete($a_info[1])
	$del2 = GUICtrlDelete($a_info[2])
	$del3 = GUICtrlDelete($a_info[0])
	If ($del1 = 0) Or ($del2 = 0) Or ($del3 = 0) Then
		SetError(1)
		Return 0
	EndIf
EndFunc


