$a = random (1, 100)
$b = DOT2COMMA($a)
msgbox (0, $a, $b)

Func DOT2COMMA($number)
	Select
	Case StringInStr ($number, ".")
		$number = StringReplace ($number, ".", ",")
		Return $number
	Case StringInStr ($number, ",")
		$number = StringReplace ($number, ",", ".")
		Return $number
	EndSelect
EndFunc
