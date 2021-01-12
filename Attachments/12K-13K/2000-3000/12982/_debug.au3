#include-once
;
; print s debug text in CONSOLE view of scite..
;
Func _DebugPrint($s_text)
	$s_text = StringReplace($s_text, @LF, @LF & "-->")

	;    ConsoleWrite("!===========================================================" & @LF & _
	;           "+===========================================================" & @LF & _
	;           "-->" & $s_text & @LF & _
	;           "+===========================================================" & @LF)

	ConsoleWrite($s_text & @LF & _
			"+===========================================================" & @LF)

EndFunc   ;==>_DebugPrint