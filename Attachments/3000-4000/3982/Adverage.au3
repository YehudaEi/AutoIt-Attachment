Global $d, $added

While 1
	
	$num = InputBox("Amount?", "Please enter an amount.")
	
	If @error = 1 Then
		Exit
	EndIf
	
	$num = Number($num)
	$d = $d + 1
	$added = $added + $num
	$average = $added / $d
	ToolTip($average, 10, 10)
	
WEnd

Sleep(15000)