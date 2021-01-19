#cs ----------------------------------------------------------------------------
	
	AutoIt Version: 3.2.8.1
	Author:         Chris Lambert
	
	Script Function:
	Template AutoIt script.
	
#ce ----------------------------------------------------------------------------
#include-once

;===============================================================================
;
; Function Name:    _ArraySearch2d()
; Description:      Finds an entry within a Two-dimensional array.
; Syntax:           _ArraySearch2d($avArray, $vWhat2Find, $i_RowStart = 0, $i_RowEnd = 0, $i_ColumnStart = -1, $i_ColumnEnd = -1, $iCaseSense = 0, $fPartialSearch = False)
;
; Parameter(s):     $avArray                   = The array to search
;                   $vWhatToFind               = What to search $avArray for
;                   $i_RowStart (Optional)     = Start array index for search, normally set to 0 or 1. If omitted it is set to 0
;                   $i_RowEnd  (Optional)      = End array index for search. If omitted or set to 0 it is set to Ubound($avArray)-
;                   $i_ColumnStart (Optional)  = First Column to start the search from Default value is -1 start at 0 column
;                   $i_ColumnEnd (Optional)    = Last Column to allow in the search Default value is -1 search all columns
;					$iCaseSense (Optional)     = If set to 1 then search is case sensitive
;					$fPartialSearch (Optional) = If set to True then executes a partial search. If omitted it is set to False
; Requirement(s):   None
;
; Return Value(s):  On Success - Returns an array of the positions of the item in a 2darray. $ret[0] = the Row number $ret[1] = the Column number
;                   On Failure - Returns -1 and sets @Error on Errors.
;                        @Error=1 $avArray is not an array
;                        @Error=2 $avArray is a 1dimensional not a 2d array
;                        @Error=3 $i_RowEnd is greater than UBound($avArray)-1
;                        @Error=4 $i_RowEnd is less than 0
;                        @Error=5 $i_ColumnStart is greater than UBound($avArray,2)-1 (the amount of columns)
;                        @Error=6 $i_ColumnStart is less than 0 (columns)
;                        @Error=7 User $i_RowStart value is greater than the $i_RowEnd value
;                        @Error=8 User $i_ColumnStart value is greater than the $i_ColumnEnd value
;                        @Error=9 User specified $i_ColumnStart value is greater than UBound($avArray,2)-1 (the amount of columns)
;                        @Error=10 $iCaseSense was invalid. (Must be 0 or 1)
;                        @Error=11 $vWhatToFind was not found in $avArray
;
; Author(s):        Chris Lambert (ChrisL)
; Note(s):          Based on the work in _ArraySearch()
;===============================================================================
Func _ArraySearch2d(Const ByRef $avArray, $vWhatToFind, $i_RowStart = 0, $i_RowEnd = 0, $i_ColumnStart = -1, $i_ColumnEnd = -1, $iCaseSense = 0, $fPartialSearch = False)
	
	If Not IsArray($avArray) Then
		;$avArray is not an array
		SetError(1)
		Return -1
	EndIf
	
	Local $y_Ubound, $x_Ubound, $ret[2], $x, $y
	
	$y_Ubound = UBound($avArray, 2) - 1 ;Get columns
	
	If $y_Ubound = -1 Then
		;$avArray is a 1dimensional not a 2d array
		SetError(2)
		Return -1
	EndIf

	$x_Ubound = UBound($avArray) - 1; Get Rows
	
	If $i_RowEnd = 0 Then
		
		$i_RowEnd = $x_Ubound
		
	ElseIf $i_RowEnd > $x_Ubound Then
		;$i_RowEnd is greater than UBound($avArray)-1
		SetError(3)
		Return -1
		
	ElseIf $i_RowEnd < 0 Then
		;$i_RowEnd is less than 0
		SetError(4)
		Return -1
	EndIf
	
	If $i_ColumnEnd = -1 Then
		$i_ColumnEnd = $y_Ubound
		
	ElseIf $i_ColumnEnd > $y_Ubound Then
		;$i_ColumnStart is greater than UBound($avArray,2)-1 (the amount of columns)
		SetError(5)
		Return -1
		
	ElseIf $i_ColumnEnd < 0 Then
		;$i_ColumnStart is less than 0 (columns)
		SetError(6)
		Return -1
	EndIf
	
	If $i_RowStart > $i_RowEnd Then
		;User $i_RowStart value is greater than the $i_RowEnd value
		SetError(7)
		Return -1
	EndIf
	
	If $i_ColumnStart = -1 Then
		
		$i_ColumnStart = 0
		
	ElseIf $i_ColumnStart > $i_ColumnEnd Then
		;User $i_ColumnStart value is greater than the $i_ColumnEnd value
		SetError(8)
		Return -1
	ElseIf $i_ColumnStart > $y_Ubound Then
		;User specified $i_ColumnStart value is greater than UBound($avArray,2)-1 (the amount of columns)
		SetError(9)
		Return -1
	EndIf
	
	If Not ($iCaseSense = 0 Or $iCaseSense = 1) Then
		;$iCaseSense was invalid. (Must be 0 or 1)
		SetError(10)
		Return -1
	EndIf
	
	

	
	
	ConsoleWrite("********************* _arraySearch2D params Debug *********************" & @CRLF & _
			"Find = " & $vWhatToFind & @CRLF & _
			"x_Start = " & $i_RowStart & @CRLF & _
			"x_End = " & $i_RowEnd & @CRLF & _
			"y_Start = " & $i_ColumnStart & @CRLF & _
			"y_End = " & $i_ColumnEnd & @CRLF & _
			"CaseSensative = " & $iCaseSense & @CRLF & _
			"Partial Search = " & $fPartialSearch & @CRLF & _
			"********************* _arraySearch2D params End *********************" & @CRLF)
	

	For $y = $i_ColumnStart To $i_ColumnEnd
		For $x = $i_RowStart To $i_RowEnd
			Select
				Case $iCaseSense = 0
					If $fPartialSearch = False Then
						If $avArray[$x][$y] = $vWhatToFind Then
							SetError(0)
							$ret[0] = $x
							$ret[1] = $y
							Return $ret
						EndIf
					Else
						$iResult = StringInStr($avArray[$x][$y], $vWhatToFind, $iCaseSense)
						If $iResult > 0 Then
							SetError(0)
							$ret[0] = $x
							$ret[1] = $y
							Return $ret
						EndIf
					EndIf
				Case $iCaseSense = 1
					If $fPartialSearch = False Then
						If $avArray[$x][$y] == $vWhatToFind Then
							SetError(0)
							$ret[0] = $x
							$ret[1] = $y
							Return $ret
						EndIf
					Else
						$iResult = StringInStr($avArray[$x][$y], $vWhatToFind, $iCaseSense)
						If $iResult > 0 Then
							SetError(0)
							$ret[0] = $x
							$ret[1] = $y
							Return $ret
						EndIf
					EndIf
					
			EndSelect
		Next
	Next
	
	SetError(11)
	Return -1
	
EndFunc   ;==>_ArraySearch2d