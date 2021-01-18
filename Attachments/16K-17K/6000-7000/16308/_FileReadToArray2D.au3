;==========================================================================================================================================
; Function:			_FileReadToArray2D($FILEPATH, $ARRAY [, $DELIM=-1])
;
; Description:      Read 1D/2D array from file, if $DELIM is given (<> -1) 2D array will created
; 
; Parameter(s):     $FILEPATH	- path/filename of the file to read in an array
;                   $ARRAY		- array variable to hold readed data
;      optional     $DELIM		- delimiter for 2D-array entries, default -1 (none 2D-array)
;
; Requirement(s):   None
;
; Return Value(s):  On Success - Returns -1
;                   On Failure - Returns 0 and sets @error = 1 	(given file are not seperated with given delimiter or count of delimiters 
;								 are not equal); @error = 2 (unable to open filepath)
;
; Note:				If given file is delimited to create 2D-array ALL lines need the same count of delimiters, otherwise an error occurs!
;
; Author(s):        BugFix ( bugfix@autoit.de )
;==========================================================================================================================================
Func _FileReadToArray2D($FILEPATH, ByRef $ARRAY, $DELIM=-1)
	Local $fh = FileOpen($FILEPATH, 0), $line, $var, $n = 1
	If $fh = -1 Then
		SetError(2)
		Return 0
	EndIf
	If $DELIM <> -1 Then
		$line = FileReadLine($fh, 1)
		$var = StringSplit($line, $DELIM)
		If IsArray($var) Then
			$Ubound2nd = $var[0]
			Local $AR[1][$Ubound2nd]
			$AR[0][0] = 0
		Else
			SetError(1)
			Return 0
		EndIf
		While 1
			$line = FileReadLine($fh, $n)
			If @error = -1 Then ExitLoop
			$var = StringSplit($line, $DELIM)
			If IsArray($var) Then
				ReDim $AR[UBound($AR)+1][$Ubound2nd]
				For $i = 0 To $Ubound2nd-1
					$AR[UBound($AR)-1][$i] = $var[$i+1]
				Next
				$AR[0][0] += 1
			Else
				SetError(1)
				Return 0
			EndIf
			$n += 1
		Wend
	Else
		Local $AR[1]
		$AR[0] = 0
		While 1
			$line = FileReadLine($fh, $n)
			If @error = -1 Then ExitLoop
			ReDim $AR[UBound($AR)+1]
			$AR[UBound($AR)-1] = $line
			$AR[0] += 1
			$n += 1
		WEnd
	EndIf
	FileClose($fh)
	$ARRAY = $AR
	Return -1
EndFunc ;==>_FileReadToArray2D