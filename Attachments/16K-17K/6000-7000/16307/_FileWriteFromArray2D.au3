;==========================================================================================================================================
; Function:			_FileWriteFromArray2D($FILEPATH, $ARRAY [, $iROWstart=0 [, $iROWend=0 [, $iCOLstart=0 [, $iCOLend=0 [, $DELIM='|']]]]])
;
; Description:      Write 1D/2D array to file, 2D with delimiter between every entry
; 
; Parameter(s):     $FILEPATH	- path/filename of the file to be write
;                   $ARRAY		- array to write from
;      optional     $iROWstart	- start row-index, default 0
;      optional     $iROWend	- end row-index, default Ubound(array)-1
;      optional     $iCOLstart	- start column-index, default 0
;      optional     $iCOLend	- end column-index, default Ubound(array,2)-1
;      optional     $DELIM		- delimiter for 2D-array entries, default '|'
;
; Requirement(s):   None
;
; Return Value(s):  On Success - Returns -1
;                   On Failure - Returns 0 and sets @error = 1 (given array is'nt array); @error = 2 (unable to open filepath)
;
; Note:				If $iROWstart > $iROWend or $iCOLstart > $iCOLend the values will be swapped among
;
; Author(s):        BugFix ( bugfix@autoit.de )
;==========================================================================================================================================
Func _FileWriteFromArray2D($FILEPATH, $ARRAY, $iROWstart=0, $iROWend=0, $iCOLstart=0, $iCOLend=0, $DELIM='|')
	If Not IsArray($ARRAY) Then
		SetError(1)
		Return 0
	EndIf
	Local $Ubound = UBound($ARRAY)
	If $iROWend = 0 Then $iROWend = $Ubound-1
	Local $fh = FileOpen($FILEPATH, 2)
	If $fh = -1 Then
		SetError(2)
		Return 0
	EndIf
	Select
	Case $iROWstart < 0 Or $iROWstart > $Ubound-1
		$iROWstart = 0
		ContinueCase
	Case $iROWend < 0 Or $iROWend > $Ubound-1
		$iROWend = $Ubound-1
		ContinueCase
	Case $iROWstart > $iROWend
		$tmp = $iROWstart
		$iROWstart = $iROWend
		$iROWend = $tmp
	EndSelect
	Local $Ubound2nd = UBound($ARRAY, 2)
	If @error = 2 Then
		For $i = $iROWstart To $iROWend
			FileWriteLine($fh, $ARRAY[$i])
		Next
	Else
		If $iCOLend = 0 Then $iCOLend = $Ubound2nd-1
		Select
		Case $iCOLstart < 0 Or $iCOLstart > $Ubound2nd-1
			$iCOLstart = 0
			ContinueCase
		Case $iCOLend < 0 Or $iCOLend > $Ubound2nd-1
			$iCOLend = $Ubound2nd-1
			ContinueCase
		Case $iCOLstart > $iCOLend
			$tmp = $iCOLstart
			$iCOLstart = $iCOLend
			$iCOLend = $tmp
		EndSelect
		For $i = $iROWstart To $iROWend
			$tmp = ''
			For $k = $iCOLstart To $iCOLend
				If $k < $iCOLend Then
					$tmp &= $ARRAY[$i][$k] & $DELIM
				Else
					$tmp &= $ARRAY[$i][$k]
				EndIf
			Next
			FileWriteLine($fh, $tmp)
		Next
	EndIf
	FileClose($fh)
	Return -1
EndFunc ;==>_FileWriteFromArray2D