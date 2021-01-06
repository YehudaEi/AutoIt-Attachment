#include-once

; version 2005/10/13
;===============================================================================
;
; Description:      Very fast string repeating routine (like _StringRepeat, but MUCH faster).
; Parameter(s):     $str    - String to repeat.
;					$cnt    - Number of times to repeat.
; Requirement(s):   None
; Return Value(s):  On Success - Returns repeated string (or "" if $cnt<= 0 or $str="")
;                   On Failure - ""  and sets @ERROR = 1
; Author(s):        Will Mooar
; Note(s):          None
;
;===============================================================================
Func _StringRepeatFast($str, $cnt)
	;Check parameters
	If StringLen($str) = 0 Then Return ""
	If $cnt < 1 Then Return ""
	
	Local $final_size = StringLen($str) * $cnt
	Local $ret = $str	;x1
	
	If $cnt >= 16 Then
		;surprisingly this speeds things up a lot
		;(you wouldn't think the simple loop below would be so slow)
		$ret &= $ret	;x2
		$ret &= $ret	;x4
		$ret &= $ret	;x8
		$ret &= $ret	;x16
	EndIf
	
	;keep doubling string size until we have built at least half of the final string
	Local $cur_size = StringLen($ret)
	while ($cur_size + $cur_size) <= $final_size
		$ret &= $ret
		$cur_size += $cur_size
	WEnd
	
	;add the rest by taking a copy of as much of the first half as we need
	If $cur_size < $final_size Then
		$ret &= StringLeft($ret, $final_size - $cur_size)
	EndIf
	
	return ($ret)
EndFunc   ;==>_StringRepeatFast
