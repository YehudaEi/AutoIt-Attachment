Dim $combos
For $pens=0 to 20
	for $notebooks=0 to 20
		For $pencils=0 to 20
			if ($pens*1.00)+($notebooks*1.50)+($pencils*.50)=20.00 Then
				$combos = $combos & "pens:" & $pens & " notebooks:" & $notebooks & "pencils:" & $pencils & @CRLF
			EndIf
		Next
	Next
Next
MsgBox(2,"",$combos)