#include <array.au3>
func _dstorefindindex($dstore,$nameofsection)
	dim $index = -1
	if StringInStr($dstore,@crlf) <> 0 Then
		$dstore = StringSplit($dstore,@crlf)
	ElseIf StringInStr($dstore,@lf) <> 0 Then
		$dstore = StringSplit($dstore,@lf)
	Else
		$dstore = StringSplit($dstore,@cr)
	EndIf
	dim $todelete[10000]
	$todelete[0] = 0
	for $i = 1 to $dstore[0]
		if $dstore[$i] = "" Then
			$todelete[0] = $todelete[0] + 1
			$todelete[$todelete[0]] = $i
		EndIf
	Next
;~ 	MsgBox(0,"dsdebug " & UBound($dstore),$index & " " & $section)
	for $i = 1 to $todelete[0]
		_ArrayDelete($dstore,$todelete[$i]-($i-1))
		$dstore[0] = $dstore[0] - 1
	Next
	for $i = 1 to $dstore[0]
		if StringInStr($dstore[$i],$nameofsection & "|") <> 0 Then
			$index = $i
			ExitLoop
		EndIf
	Next
	Return $index
EndFunc
func _dstorestorevalue($dstore,$section,$value)
	$index = _dstorefindindex($dstore,$section)
	if StringInStr($dstore,@crlf) <> 0 Then
		$dstore = StringSplit($dstore,@crlf)
	ElseIf  StringInStr($dstore,@lf) <> 0 Then
		$dstore = StringSplit($dstore,@lf)
	Else
		$dstore = StringSplit($dstore,@cr)
	EndIf
	dim $todelete[10000]
	$todelete[0] = 0
;~ 	_ArrayDisplay($dstore,"p1st")
	for $i = 1 to $dstore[0]
		if $dstore[$i] = "" Then
			$todelete[0] = $todelete[0] + 1
			$todelete[$todelete[0]] = $i
		EndIf
	Next
;~ 	MsgBox(0,"dsdebug " & UBound($dstore),$index & " " & $section)
	for $i = 1 to $todelete[0]
		_ArrayDelete($dstore,$todelete[$i]-($i-1))
		$dstore[0] = $dstore[0] - 1
	Next
;~ 	_ArrayDisplay($dstore,"1st")
;~ 	MsgBox(0,"debug 1st",$section & "|" & $value)
	if $index <> -1 and UBound($dstore) >= $index Then
;~ 		MsgBox(0,"dsdebug1 " & UBound($dstore),$index & " " & $section & @lf & $value)
		$dstore[$index] = $section & "|" & $value
;~ 		MsgBox(0,"dsdebug1.1",$dstore[$index])
	Else
;~ 		MsgBox(0,"dsdebug2 " & UBound($dstore),$index & " " & $section)
		_ArrayAdd($dstore,$section & "|" & $value)
		$dstore[0] = $dstore[0] + 1
;~ 		_ArrayDisplay($dstore,"2nd")
	EndIf
;~ 	_ArrayDisplay($dstore,"2nd")
	dim $dt
	for $i = 1 to $dstore[0]
		$dt = $dt & $dstore[$i] & @CRLF
;~ 		MsgBox(0,$i & "\" & $dstore[0],$dt & " dstore[$i] " & $dstore[$i])
	Next
;~ 	MsgBox(0,"dsdebugdt",$dt)
	Return $dt
EndFunc
func _dstoregetvalue($dstore,$section)
	$index = _dstorefindindex($dstore,$section)
	if $index = -1 Then
		return -1
	EndIf
	if StringInStr($dstore,@crlf) <> 0 Then
		$dstore = StringSplit($dstore,@crlf)
	ElseIf  StringInStr($dstore,@lf) <> 0 Then
		$dstore = StringSplit($dstore,@lf)
	Else
		$dstore = StringSplit($dstore,@cr)
	EndIf
	dim $todelete[10000]
	$todelete[0] = 0
	for $i = 1 to $dstore[0]
		if $dstore[$i] = "" Then
			$todelete[0] = $todelete[0] + 1
			$todelete[$todelete[0]] = $i
		EndIf
	Next
;~ 	MsgBox(0,"dsdebug " & UBound($dstore),$index & " " & $section)
	for $i = 1 to $todelete[0]
		_ArrayDelete($dstore,$todelete[$i]-($i-1))
		$dstore[0] = $dstore[0] - 1
	Next
	$temp1 = $dstore[$index]
	$temp1 = StringSplit($temp1,"|")
	dim $temp
	if $temp1[0] = 2 Then
		$temp = $temp1[2]
	Else
		for $i = 2 to $temp1[0]
			if $i <> $temp1[0] then
				$temp = $temp & $temp1[$i] & "|"
			Else
				$temp = $temp & $temp1[$i]
			EndIf
		Next
	EndIf
	return $temp
EndFunc