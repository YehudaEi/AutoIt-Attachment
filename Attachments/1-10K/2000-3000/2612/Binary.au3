Func StringToBin($string)
	local $split, $ret, $i
	$split = stringsplit($string, "")
	$ret = ""
	for $i = 1 to $split[0]
		$ret = $ret & bin(asc($split[$i]))
	next
	return $ret
EndFunc

Func Bin($D)
	$P = -1
	Do
		$P = $P + 1
	Until 2 ^ $P > $D
	$P = $P - 1
	Dim $ret[$P + 1]
	Do
		If 2 ^ $P <= $D then
			$ret[$P] = 1
			$D = $D - (2 ^ $P)
		Else
			$ret[$P] = 0
		EndIf
		$P = $P - 1
	Until $p < 0
	$sz_ret = ""
	For $i = (UBound($ret) - 1) to 0 step -1
		$sz_ret = $sz_ret & string($ret[$i])
	Next
	Return $sz_ret
EndFunc