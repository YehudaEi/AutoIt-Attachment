Func _FileSizeConvert($bytes,$rounding = 2, $outputstring = True)

	Local $array[3]
	
	Select
		Case $bytes < 2^10 ;bytes
			$array[0] = $bytes
			$array[1] = "bytes"
			$array[2] = "bytes"
		Case $bytes >= 2^10 and $bytes < 2^20 ;kilobytes
			$array[0] = Round($bytes/2^10,$rounding)
			$array[1] = "kilobytes"
			$array[2] = "KB"
		Case $bytes >= 2^20 and $bytes < 2^30 ;megabytes
			$array[0] = Round($bytes/2^20,$rounding)
			$array[1] = "megabytes"
			$array[2] = "MB"
		Case $bytes >= 2^30 and $bytes < 2^40 ;gigabytes
			$array[0] = Round($bytes/2^30,$rounding)
			$array[1] = "gigabytes"
			$array[2] = "GB"
		Case $bytes >= 2^40 and $bytes < 2^50 ;terabytes
			$array[0] = Round($bytes/2^40,$rounding)
			$array[1] = "terabytes"
			$array[2] = "TB"
		Case $bytes >= 2^50 and $bytes < 2^60 ;petabytes
			$array[0] = Round($bytes/2^50,$rounding)
			$array[1] = "petabytes"
			$array[2] = "PB"
		Case $bytes >= 2^60 and $bytes < 2^70 ;exabytes
			$array[0] = Round($bytes/2^60,$rounding)
			$array[1] = "exabytes"
			$array[2] = "EB"
		Case $bytes >= 2^70 and $bytes < 2^80 ;zettabytes
			$array[0] = Round($bytes/ 2^70,$rounding)
			$array[1] = "zettabytes"
			$array[2] = "ZB"
		Case $bytes >= 2^80 ;yottabytes
			$array[0] = Round($bytes/ 2^80,$rounding)
			$array[1] = "yottabytes"
			$array[2] = "YB"
	EndSelect
	
	If $outputstring then 
		Return $array[0] & " " & $array[2]
	Else
		Return $array
	EndIf
	
EndFunc
