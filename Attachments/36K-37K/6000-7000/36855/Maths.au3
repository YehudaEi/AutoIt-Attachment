$1 = InputBox("Maths", "Number:", "")
$operation = InputBox("Maths", "+, -, *:", "")
$2 = InputBox("Maths", "plus Number:", "")

$plus = $1 + $2
$minus = $1 - $2
$times = $1 * $2
If $operation = "+" Then
	MsgBox("", "Maths", "= " & $plus)
EndIf
If $operation = "-" Then
	MsgBox("", "Maths", "= " & $minus)
EndIf
If $operation = "*" Then
	MsgBox("", "Maths", "= " & $times)
EndIf
