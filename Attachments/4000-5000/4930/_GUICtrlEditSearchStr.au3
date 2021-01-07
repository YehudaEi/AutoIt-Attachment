#include-once
#include <GUIEdit.au3>
#include <GUIConstants.au3>
; ----------------------------------------------------------------------------
;
; AutoIt Version: 3.1.1.84 Beta
; Author:         poisonkiller
;
; Script Function: Searches string from edit
;
; Last Update: 7/14/05
; Requirements: AutoIt3 Beta - tested on Win98 SE, #include <GUIEdit.au3>
; Notes: Searches only one string
; ----------------------------------------------------------------------------

Func _GUICtrlEditSearchStr($edit, $string)
$count = 0
$Save_String = $string
$Save_Edit = $edit
Do
	$trim_right = StringTrimRight($string, 1)
	$count = $count + 1
	$string = $trim_right
Until $trim_right = ""
$new_count = 0
Global $edit1 = GUICtrlRead($edit)
Do
	$r_count = 0
	$right = StringLeft($edit1, $count)
	If $right = $Save_String Then
		$new_count = $new_count
		$new_count2 = $new_count + $count
		GUICtrlSetState($edit,$GUI_FOCUS)
		_GUICtrlEditSetSel($edit, $new_count, $new_count2)
	$r_count = 1
	Else
		$edit1 = StringTrimLeft($edit1, 1)
		$new_count = $new_count + 1
	EndIf
Until $r_count = 1
EndFunc; ==> _GUICtrlEditSearchStr