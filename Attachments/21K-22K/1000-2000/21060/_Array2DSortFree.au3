;==================================================================================================
; Function Name:   _Array2DSortFree($ARRAY, $sCOL_ASC [, $NUM=False])
; Description::    Sorts (1D)2D-Array multistage by free choice of order and direction 
;                    1D       Sorts ascending/descending
;                    2D       Sorts multistage, free choice of order and direction for columns
;                             also to sort only one column
; Parameter(s):    $ARRAY     Array to sort
;                  $sCOL_ASC  String with predefinition "Column|Direction [, Column|Direction]"
;                             "column to sort (0-Index)|direction (0-Asc, 1-Desc)"
;                             i.e.: column 2 ascending and for even values sort column 1 descending
;                             _Array2DSortFree($ar2Sort, "1|0,0|1")
;      optional    $NUM       "False" sorts alphabetically (default), "True" sorts numeric
; Return Value(s): success    0
;                  Failure    1  Set Error  1 $ARRAY isn't array
;                                           2 1D-array, but $sCOL_ASC has entry as 2D-array
;                                           3 SQLite-error
;                                           4 $sCOL_ASC with error
; Requirements:    #include <SQLite.au3>
;                  #include <SQLite.dll.au3>
;                  #include <Array.au3>
;                  Note: It's urgent required to have SQLite-includes at top of calling script.
;                        Otherwise fails initialization of SQLite.dll with _SQLite_Startup().
; Version:         3.2.12.0
; Author(s):       BugFix (bugfix@autoit.de)   
;==================================================================================================
Func _Array2DSortFree(ByRef $ARRAY, $sCOL_ASC, $NUM=False)
	If Not IsArray($ARRAY) Then Return SetError(1,0,1)
	Local $tableStr = "CREATE TABLE tblTEST ("
	Local $insertStr = '', $insertBase = "INSERT INTO tblTEST VALUES ("
	Local $sortOrder = '', $sortStr = "SELECT * FROM tblTEST ORDER BY "
	Local $hQuery, $aRow, $asc, $i, $k
	$sCOL_ASC = StringStripWS($sCOL_ASC, 8)
	Local $ub2nd = UBound($ARRAY, 2)
	If @error = 2 Then
		If (StringLen($sCOL_ASC) > 3) Or (StringLeft($sCOL_ASC, 1) <> '0') Then Return SetError(2,0,1)
		If StringRight($sCOL_ASC, 1) = 0 Then
			_ArraySort($ARRAY)
		Else
			_ArraySort($ARRAY, 1)
		EndIf
		Return 0
	Else
		Local $aOut[UBound($ARRAY)][$ub2nd]
	EndIf
	_SQLite_Startup ()
	If @error > 0 Then Return SetError(3,0,1)
	$hSQL = _SQLite_Open ()
	If @error > 0 Then 
		_SQLite_Shutdown ()
		Return SetError(3,0,1)
	EndIf
	For $i = 0 To UBound($ARRAY, 2) -1
		$tableStr &= "'field" & $i & "',"
	Next
	$tableStr = StringTrimRight($tableStr, 1) & ");"
	For $i = 0 To UBound($ARRAY) -1
		$insertStr &= $insertBase
		For $k = 0 To UBound($ARRAY, 2) -1
			$insertStr &= "'" & $ARRAY[$i][$k] & "',"
		Next
		$insertStr = StringTrimRight($insertStr, 1) & ");"
	Next
	If _SQLite_Exec ( $hSQL, $tableStr & $insertStr ) <> $SQLITE_OK Then
		_SQLite_Shutdown ()
		Return SetError(3,0,1)
	EndIf
	If StringInStr($sCOL_ASC, ',') Then 
		Local $aOrder = StringSplit($sCOL_ASC, ',')
		For $i = 1 To UBound($aOrder) -1
			If StringInStr($sCOL_ASC, '|') Then
				Local $var = StringSplit($aOrder[$i], '|')
				$asc = ' ASC'
				If $var[2] = 1 Then $asc = ' DESC'
				If $NUM Then
					$sortOrder &= 'ABS(field' & $var[1] & ')' & $asc & ','
				Else
					$sortOrder &= 'field' & $var[1] & $asc & ','
				EndIf
			Else
				_SQLite_Shutdown ()
				Return SetError(4,0,1)
			EndIf
		Next
		$sortOrder = StringTrimRight($sortOrder, 1) & ';'
	Else
		If (StringLen($sCOL_ASC) = 3) And (StringInStr($sCOL_ASC, '|')) Then
			Local $var = StringSplit($sCOL_ASC, '|')
			$asc = ' ASC'
			If $var[2] = 1 Then $asc = ' DESC'
			If $NUM Then
				$sortOrder &= 'ABS(field' & $var[1] & ')' & $asc
			Else
				$sortOrder &= 'field' & $var[1] & $asc
			EndIf
		Else
			_SQLite_Shutdown ()
			Return SetError(4,0,1)
		EndIf
	EndIf
	If _SQlite_Query (-1, $sortStr & $sortOrder, $hQuery) <> $SQLITE_OK Then
		_SQLite_Shutdown ()
		Return SetError(3,0,1)
	EndIf
	$i = 0
	While _SQLite_FetchData ($hQuery, $aRow) = $SQLITE_OK
		For $k = 0 To UBound($ARRAY,2) -1
			$ARRAY[$i][$k] = $aRow[$k]
		Next
		$i += 1
	WEnd
	_SQLite_Exec ($hSQL, "DROP TABLE tblTEST;")
	_SQLite_Close ()
	_SQLite_Shutdown ()
	Return 0
EndFunc  ;==>_Array2DSortFree
