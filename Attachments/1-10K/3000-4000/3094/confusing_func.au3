Func _ArrayNCreate($nBound)
	Local $aBound = StringSplit($nBound, ";")

;	$aBound[0] = 3
;	$aBound[1] = 0
;	$aBound[2] = 1
;	$aBound[3] = 2

;	Local $3[2 + 1], $2[1 + 1], $1[0 + 1]
	For $a = 1 to $aBound[0]
		Local $aTemp[$aBound[$a] + 1]
		Assign('i' & $a, $aTemp, 1)
		$aTemp = ''
	Next

;	Local $3 = _ArrayFill($3), $2 = ArrayFill($2, $3), $1 = _ArrayFill($1, $2)
	Assign('i' & $aBound[0], _ArrayFill(Eval('i' & $aBound[0])), 1)
	For $b = $aBound[0] - 1 to 1
		Assign('i' & $b, '', 1)
		Assign('i' & $b, _ArrayFill(Eval('i' & $b), Eval('i' & ($b+1))), 1)
	Next
	
	Return $i1
EndFunc

$a = _ArrayNCreate("0;1;2")
$d = _ArrayNGet($a, "0;1;2")
MsgBox(0, "$a[0[1[2]]] = ''", $d)