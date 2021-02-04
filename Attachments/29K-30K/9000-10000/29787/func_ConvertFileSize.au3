;==================================================================================
; AutoIt Version:	3.3.4.0
; Language:			English
; Author:			Steveiwonder
; Requirements:		None
;==================================================================================
; Function:			ConvertSize
; Description:		Converts a given number(bytes) into GB/MB/KB/B
; Parameter(s):		$FileSizeInBytes - the size of file / folder in bytes


; Return Value(s): 	Returns array
;					[0] contains the converted file/folder size in GB/MB/KB/B rounded to two decimal places.
;					[1] contains either GB/MB/KB/B
; Author(s):		Steveiwonder
;==================================================================================
Func _ConvertSize($FileSizeInBytes)
	
	Local $n[2] = [$FileSizeInBytes, ""]

		
	If $n[0] >= 1073741824 Then ; = or greater than 1GB
		$n[0] = $n[0]/(1024*1024*1024)
		$n[1]= "GB"
		
	ElseIf $n[0] >= 1048576 Then ; = or greater than 1MB
		$n[0] = $n[0]/(1024*1024)
		$n[1]= "MB"		
	
	ElseIf $n[0] >= 1024 Then ; = or greater than 1KB
		$n[0] = $n[0]/(1024)
		$n[1]= "KB"
		
	Else
		$n[0] = $n[0]
		$n[1]= "B"		
	EndIf
	
	$n[0] = Round($n[0], 2)
	
	Return $n
EndFunc





