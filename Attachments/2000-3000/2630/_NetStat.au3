Func _NetStat()
	
	Local $v_NETSTAT
	
	$v_NETSTAT = Run(@SystemDir & '\netstat.exe', @SystemDir, @SW_HIDE, 2)
	$v_NETSTAT = StdoutRead ($v_NETSTAT)
	
	$v_NETSTAT = StringTrimLeft($v_NETSTAT, StringInStr($v_NETSTAT, @LF, 0, 4))
	$v_NETSTAT = StringLeft($v_NETSTAT, StringInStr($v_NETSTAT, @LF, 0, -1) - 1)
	
	$v_NETSTAT = StringSplit($v_NETSTAT, @LF)
	
	Local $as_Temp, $as_RET[$v_NETSTAT[0]][4]
	
	For $i = 1 To $v_NETSTAT[0]
		$v_NETSTAT[$i] = StringReplace($v_NETSTAT[$i], @CR, '')
		$v_NETSTAT[$i] = StringStripWS($v_NETSTAT[$i], 1 + 2 + 4)
		$as_Temp = StringSplit($v_NETSTAT[$i], ' ')
		$as_RET[$i - 1][0] = $as_Temp[1]
		$as_RET[$i - 1][1] = $as_Temp[2]
		$as_RET[$i - 1][2] = $as_Temp[3]
		$as_RET[$i - 1][3] = $as_Temp[4]
	Next
	
	Return $as_RET
	
EndFunc   ;==>_NetStat


; example
; dim $v_lol = _NetStat()
;
; For $i = 0 To UBound($v_lol) - 1
;	For $x = 0 To 3
;		ConsoleWrite('-' & $v_lol[$i][$x] & @LF)
;	Next
;	ConsoleWrite(@LF)
; Next
