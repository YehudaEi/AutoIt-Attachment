; _APIFileOpen( <FileName> )
;
; Returns a "REAL" file handle for reading and writing.
; The return value comes directly from "CreateFile" api.
Func _APIFileOpen( $szFile )
	Local $GENERIC_READ = 0x80000000, $GENERIC_WRITE = 0x40000000
	Local $OPEN_ALWAYS = 4, $FILE_ATTRIBUTE_NORMAL = 0x00000080
	Local $AFO_h
	$AFO_h = DllCall( "kernel32.dll", "hwnd", "CreateFile", _
						"str", $szFile, _
						"long", BitOR($GENERIC_READ,$GENERIC_WRITE), _
						"long", 0, _
						"ptr", 0, _
						"long", $OPEN_ALWAYS, _
						"long", $FILE_ATTRIBUTE_NORMAL, _
						"long", 0 )
	Return $AFO_h[0]
EndFunc


; _APIFileClose( <FileHandle> )
;
; The return value comes directly from "CloseHandle" api.
Func _APIFileClose( $hFile )
	Local $AFC_r
	$AFC_r = DllCall( "kernel32.dll", "int", "CloseHandle", _
						"hwnd", $hFile )
	Return $AFC_r[0]
EndFunc


; _APIFileSetPos( <FileHandle>, <Position in the file to read/write to/from> )
;
; The return value comes directly from "SetFilePointer" api.
Func _APIFileSetPos( $hFile, $nPos )
	Local $FILE_BEGIN = 0 
	Local $AFSP_r
	$AFSP_r = DllCall( "kernel32.dll", "long", "SetFilePointer", _
						"hwnd",$hFile, _
						"long",$nPos, _
						"long_ptr",0, _
						"long",$FILE_BEGIN )
	Return $AFSP_r[0]		
EndFunc


; _APIFileRead( <FileHandle>, <Number of Bytes to read>, <Option 0=String, 1=Binary(hex)> )
;
; Returns the data read. (Binary is comma delimited Hex values)
; Sets @error to the return from ReadFile api.
Func _APIFileRead( $hFile, $nBytes, $Option=0 )
	Local $AFR_r, $AFR_n
	Local $AFR_str, $AFR_ret = ""

	If $Option = 0 Then
		$AFR_str = DllStructCreate("char[" & $nBytes & "]")
	Else
		$AFR_str = DllStructCreate("byte[" & $nBytes & "]")
	EndIf
	
	$AFR_r = DllCall( "kernel32.dll", "int", "ReadFile", _
						"hwnd", $hFile, _
						"ptr",DllStructGetPtr($AFR_str), _
						"long",$nBytes, _
						"long_ptr",0, _
						"ptr",0 )

	If $Option = 0 Then
		$AFR_ret = StringLeft(DllStructGetData($AFR_str,1),$AFR_r[4])
	Else
		For $AFR_n = 1 to $AFR_r[4]
			$AFR_ret = $AFR_ret & Hex(DllStructGetData($AFR_str,1,$AFR_n),2) & ","
		Next
		$AFR_ret = StringTrimRight($AFR_ret,1)
	EndIf
	
	SetError($AFR_r[0])
	Return $AFR_ret
EndFunc


; _APIFileWrite( <FileHandle>, <Data to Write>, <Option 0=String, 1=Binary(hex)> )
;
; Returns # of Bytes written. 
; Sets @error to the return from WriteFile api.
; For binary <Data to Write> must be comma delimited hex values
Func _APIFileWrite( $hFile, $szData, $Option=0 )
	Local $AFW_r, $AFW_n, $AFW_i
	Local $AFW_ptr

	If $Option = 0 Then
		$AFW_n = StringLen($szData)
		$AFW_ptr = DllStructCreate("char[" & $AFW_n & "]")
		DllStructSetData($AFW_ptr,1,String($szData))
	Else
		$szData = StringSplit($szData,",")
		$AFW_n = $szData[0]
		$AFW_ptr = DllStructCreate("byte[" & $AFW_n & "]")
		For $AFW_i = 1 to $AFW_n
			DllStructSetData($AFW_ptr,1,Dec($szData[$AFW_i]),$AFW_i)
		Next
	EndIf

	$AFW_r = DllCall( "kernel32.dll", "int", "WriteFile", _
						"hwnd", $hFile, _
						"ptr",DllStructGetPtr($AFW_ptr), _
						"long",$AFW_n, _
						"long_ptr",0, _
						"ptr",0 )

	SetError($AFW_r[0])
	Return $AFW_r[4]
EndFunc

; _APIFileSetEnd( <FileHandle> )
;
; function moves the end-of-file (EOF) to the current position of the file pointer
; The return value comes directly from "SetEndOfFile" api.
; If the function succeeds, the return value is nonzero. If it fail, return zero.
Func _APIFileSetEnd( $hFile )
	Local $AFSP_r
	$AFSP_r = DllCall( "kernel32.dll", "int", "SetEndOfFile", _
						"hwnd",$hFile )
	Return $AFSP_r[0]		
EndFunc
