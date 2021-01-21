#Include <PadZero.au3>
Dim $Out
$B1 = 3.14
$B2 = 100.15
$B3 = 15
$B4 = 90

For $X = 1 To 4
	Assign("A" & $X, _PadZero (Eval("B" & $X), 4))
Next
For $X = 1 To 4
	$Out = $Out & @CRLF & Eval("B" & $X)
Next
MsgBox(32, "Before PZ", $Out)
$Out = ""
For $X = 1 To 4
	$Out = $Out & @CRLF & Eval("A" & $X)
Next
MsgBox(32, "After PZ", $Out)