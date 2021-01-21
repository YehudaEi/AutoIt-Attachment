


Func _OCR($Ax, $Ay, $Dx, $Dy)
	
	$width = $Dx - $Ax
	$length = $Dy - $Ay
	
	Dim $char[$width][$length]
	
	For $xwidth = 0 To $width - 1
		For $xlength = 0 To $length - 1
			$char[$xwidth][$xlength] = Hex(PixelGetColor($Ax, $Ay), 6)
			$Ay = $Ay + 1
		Next
		$Ax = $Ax + 1
		$Ay = $Ay - $length
	Next
	;scans entire area 
	

	$p = 1
	Dim $row[$width]
	For $xwidth = 0 To $width - 1
		
		For $xlength = 0 To $length - 1
			If $char[$xwidth][$xlength] = "000000" Then
				If $p = 1 Then
					$div = $xwidth
					$p += 2
				EndIf
				$x = $xwidth - $div
				$row[$x] +=1
				
			EndIf
			
		Next
	Next
	;seriales the array
	
	Dim $result
	For $xwidth = 0 To $width - 1
		
		If $row[$xwidth] = 1 And $row[$xwidth+1] = "" Then
		$result &= "."
		EndIf
	
		If $row[$xwidth] = 1 And $row[$xwidth+1] = 1 And $row[$xwidth+2] = 7 Then
			$result &= "1"
		EndIf
		
		
		If $row[$xwidth] = 2 And $row[$xwidth+1] = 3 And $row[$xwidth+2] = 3 And $row[$xwidth+3] = 3 And $row[$xwidth+4] = 3 Then
			$result &= "2"
		EndIf
			
		
		If $row[$xwidth] = 2 And $row[$xwidth+1] = 2 And $row[$xwidth+2] = 3 And $row[$xwidth+3] = 3 And $row[$xwidth+4] = 4 Then
			$result &= "3"
		EndIf
		
				
		If $row[$xwidth] = 2 And $row[$xwidth+1] = 3 And $row[$xwidth+2] = 2 And $row[$xwidth+3] = 7 And $row[$xwidth+4] = 1 Then
			$result &= "4"
		EndIf

		
		If $row[$xwidth] = 3 And $row[$xwidth+1] = 4 And $row[$xwidth+2] = 3 And $row[$xwidth+3] = 3 And $row[$xwidth+4] = 4 Then
			$result &= "5"
		EndIf
		
				
		If $row[$xwidth] = 5 And $row[$xwidth+1] = 3 And $row[$xwidth+2] = 3 And $row[$xwidth+3] = 3 And $row[$xwidth+4] = 3 Then
			$result &= "6"
		EndIf
		
				
		If $row[$xwidth] = 1 And $row[$xwidth+1] = 1 And $row[$xwidth+2] = 4 And $row[$xwidth+3] = 3 And $row[$xwidth+4] = 2 Then
			$result &= "7"
		EndIf
		
				
		If $row[$xwidth] = 4 And $row[$xwidth+1] = 3 And $row[$xwidth+2] = 3 And $row[$xwidth+3] = 3 And $row[$xwidth+4] = 4 Then
			$result &= "8"
		EndIf
		
				
		If $row[$xwidth] = 3 And $row[$xwidth+1] = 3 And $row[$xwidth+2] = 3 And $row[$xwidth+3] = 3 And $row[$xwidth+4] = 5 Then
			$result &= "9"
		EndIf
		
				
		If $row[$xwidth] = 5 And $row[$xwidth+1] = 2 And $row[$xwidth+2] = 2 And $row[$xwidth+3] = 2 And $row[$xwidth+4] = 5 Then
			$result &= "10"
		EndIf
		
		
	Next
	
	Return $result

	EndFunc 