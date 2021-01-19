Func _InitDictionary()
	Local $s = Chr(0x1B)
	Local $a[1] = [0]
	Local $h[2] = [$s,$a]
	Return $h
EndFunc

Func _AddItem(ByRef $h, $sKey, $vValue)
	Local $s = $h[0], $a = $h[1]
	If Not StringInStr($s,Chr(0x1B) & $sKey & Chr(0x1B),1) Then
		ReDim $a[UBound($a)+1]
		$a[0] += 1
		$a[UBound($a)-1] = $vValue
		$s &= $sKey & Chr(0x1B)
	Else
		Return SetError(1,1,-1)
	EndIf
	$h[0] = $s
	$h[1] = $a
EndFunc

Func _ItemExists($h, $sKey)
	Local $s = $h[0], $a = $h[1]
	Local $n = StringInStr($s,Chr(0x1B) & $sKey & Chr(0x1B),1) 
	If $n = 0 Then Return 0 
	Return 1
EndFunc

Func _Item($h, $sKey)
	Local $s = $h[0], $a = $h[1]
	Local $n = StringInStr($s,Chr(0x1B) & $sKey & Chr(0x1B),1)
	StringReplace(StringLeft($s,$n),Chr(0x1B),'')
	Local $i = @extended
	If $n = 0 Then Return SetError(1,0,0)
;~ 	While StringInStr($s,Chr(0x1B),1,$i) <> $n
;~ 		$i += 1
;~ 	WEnd
	Return $a[$i]
EndFunc

Func _ChangeItem(ByRef $h, $sKey, $vValue)
	Local $s = $h[0], $a = $h[1]
	If StringInStr($s,Chr(0x1B) & $sKey & Chr(0x1B),1) Then
		$n = StringInStr($s,Chr(0x1B) & $sKey & Chr(0x1B),1)
		StringReplace(StringLeft($s,$n),Chr(0x1B),'')
		Local $i = @extended
;~ 		While StringInStr($s,Chr(0x1B),1,$i) <> $n
;~ 			$i += 1
;~ 		WEnd
		$a[$i] = $vValue
	EndIf
	$h[0] = $s
	$h[1] = $a
EndFunc

Func _ChangeKey(ByRef $h, $sKey, $sNewKey)
	Local $s = $h[0], $a = $h[1]
	StringReplace($s,Chr(0x1B) & $sKey & Chr(0x1B),Chr(0x1B) & $sNewKey & Chr(0x1B))
	$h[0] = $s
	$h[1] = $a
EndFunc

Func _ItemRemove(ByRef $h, $sKey)
	Local $s = $h[0], $a = $h[1]
	Local $b[UBound($a)-1]
	Local $n = StringInStr($s,Chr(0x1B) & $sKey & Chr(0x1B),1), $j, $k=1
	StringReplace(StringLeft($s,$n),Chr(0x1B),'')
	Local $i = @extended
	If $n = 0 Then Return SetError(1,1,-1)
;~ 	While StringInStr($s,Chr(0x1B),1,$i) <> $n
;~ 		$i += 1
;~ 	WEnd
	For $j = 1 To $a[0]
		If $j <> $i Then
			$b[$k] = $a[$j]
			$k += 1
		EndIf
	Next
	$s = StringReplace($s,Chr(0x1B) & $sKey & Chr(0x1B), Chr(0x1B))
	$b[0] = $a[0] - 1
	$h[0] = $s
	$h[1] = $b
EndFunc

Func _ItemCount($h)
	Local $s = $h[0], $a = $h[1]
	Return $a[0]
EndFunc

Func _GetItems($h)
	Local $s = $h[0], $a = $h[1]
	Return $a
EndFunc

Func _GetKeys($h)
	Local $s = $h[0], $a = $h[1]
	Return StringSplit(StringTrimLeft(StringTrimRight($s,1),1),Chr(0x1B))
EndFunc