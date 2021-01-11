; ===============================================================================
;
; UDF Name:  		RestrictControlRegExp.au3
; Description:   	This UDF can restrict the text typed into input controls live
;					while typing based on a given Regular Expression.
; Requirement:  	AutoIt 3.2.0.1 or higher
; Author:  			peethebee (peethebee@gmx.de, http://www.autoit.de)
; Notice:			based on a script by gafrost in this thread:
; 					http://www.autoitscript.com/forum/index.php?showtopic=31556&hl=guiregistermsg
;
; ===============================================================================



#include <GuiConstants.au3>

Global Const $WM_COMMAND = 0x0111
Global Const $EN_CHANGE = 0x300

Global $array__RegEx_RestrictControl[1][4]
Global $array__RegEx_RestrictControl_id_count = 0



;===============================================================================
;
; Function Name:   	_RegEx_RestrictControl_setup
; Description:		Sets up the features of this UDF.
; Parameter(s):    	$_re_rc_max_controls (opotional, default 10)
;						defines how many controls gan be controlled at maximum
; Requirement(s):  	This UDF included
; Return Value(s): 	None.
; Author(s):       	peethebee
;
;===============================================================================
Func _RegEx_RestrictControl_setup($_re_rc_max_controls = 10)
	GUIRegisterMsg($WM_COMMAND, "_RegEx_RestrictControl_check")
	ReDim $array__RegEx_RestrictControl[$_re_rc_max_controls][4]
	$array__RegEx_RestrictControl_id_count = 0
EndFunc   ;==>_RegEx_RestrictControl_setup


;===============================================================================
;
; Function Name:   	_RegEx_RestrictControl_add
; Description:		Sets up the controlling for a control.
; Parameter(s):    	$_re_rc_ctrlid
;						ID of the control to be monitored
;					$_re_rc_regex_pattern
;						RegExp which has to be fullfilled or fullfillable
;					$_re_rc_valid_string (optional, default "")
;						Valid string for testing if RegExp can still be fullfilled.
; Requirement(s):  	This UDF included
; Return Value(s): 	None.
; Author(s):       	peethebee
;
;===============================================================================
Func _RegEx_RestrictControl_add($_re_rc_ctrlid, $_re_rc_regex_pattern, $_re_rc_valid_string = "")
	$array__RegEx_RestrictControl[$array__RegEx_RestrictControl_id_count][0] = $_re_rc_ctrlid
	$array__RegEx_RestrictControl[$array__RegEx_RestrictControl_id_count][1] = $_re_rc_regex_pattern
	$array__RegEx_RestrictControl[$array__RegEx_RestrictControl_id_count][2] = $_re_rc_valid_string
	$array__RegEx_RestrictControl[$array__RegEx_RestrictControl_id_count][3] = ""
	$array__RegEx_RestrictControl_id_count += 1
EndFunc   ;==>_RegEx_RestrictControl_add


;===============================================================================
;
; Function Name:   	_RegEx_RestrictControl_check
; Description:		Internal processing function - not to be called from outside!
; Parameter(s):    	[...]
; Requirement(s):  	This UDF included
; Return Value(s): 	None.
; Author(s):       	peethebee (using gafrost's work as a basis)
;
;===============================================================================
Func _RegEx_RestrictControl_check($hWnd, $msg, $wParam, $lParam)
	Local $nNotifyCode = _HiWord($wParam)
	Local $nID = _LoWord($wParam)
	Local $hCtrl = $lParam

;~ 	MsgBox(0, "", UBound($array__RegEx_RestrictControl, 1))
	For $_re_rc_i = 0 To UBound($array__RegEx_RestrictControl, 1) - 1
		If $nID = $array__RegEx_RestrictControl[$_re_rc_i][0] Then
			If $nNotifyCode = $EN_CHANGE Then
				; Check RegEx and set text
				For $_re_rc_j = 0 To StringLen($array__RegEx_RestrictControl[$_re_rc_i][2])
					$_re_rc_regex_res = 1
;~ 					MsgBox(0, "regexp string", GUICtrlRead($array__RegEx_RestrictControl[$_re_rc_i][0]) & StringTrimLeft($array__RegEx_RestrictControl[$_re_rc_i][2], $_re_rc_j))
					If StringRegExp (GUICtrlRead($array__RegEx_RestrictControl[$_re_rc_i][0]) & StringTrimLeft($array__RegEx_RestrictControl[$_re_rc_i][2], $_re_rc_j), $array__RegEx_RestrictControl[$_re_rc_i][1]) Then ExitLoop
					$_re_rc_regex_res = 0
				Next
				If $_re_rc_regex_res = 1 Then
					; save string as "good" value for later resettability
					$array__RegEx_RestrictControl[$_re_rc_i][3] = GUICtrlRead($array__RegEx_RestrictControl[$_re_rc_i][0])
				Else
					; reset Text to last known good value
					GUICtrlSetData($array__RegEx_RestrictControl[$_re_rc_i][0], $array__RegEx_RestrictControl[$_re_rc_i][3])
				EndIf
			EndIf
		EndIf
	Next
	; Proceed the default Autoit3 internal message commands.
	; You also can complete let the line out.
	; !!! But only 'Return' (without any value) will not proceed
	; the default Autoit3-message in the future !!!
	Return $GUI_RUNDEFMSG
EndFunc   ;==>_RegEx_RestrictControl_check

; helping function by gafrost
Func _HiWord($x)
	Return BitShift($x, 16)
EndFunc   ;==>_HiWord

; helping function by gafrost
Func _LoWord($x)
	Return BitAND($x, 0xFFFF)
EndFunc   ;==>_LoWord