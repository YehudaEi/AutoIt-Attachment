; ----------------------------------------------------------------------------
;
; AutoIt Version: 3.1.1
; Author:         Mike Ratzlaff <mratzlaff@pelco.com>
;
; Script Function:
;	Functions for dealing with Nested Arrays
;
; ----------------------------------------------------------------------------

; Note: This file is a work in progress and is not released as complete


;Reads the given string, starting at the left, up to the first delimiter and returns the substring.
;Also trims the original string not to include the substring or first delimiter
Func _StringDequeue(ByRef $String, $Delim=',', $CaseSense = 0)
	Local $Pos = StringInStr($String, $Delim, $CaseSense)
	If $Pos > 0 Then
		Local $Return = StringLeft($String, $Pos - 1)
		$String = StringTrimLeft($String, $Pos)
	ElseIf IsString($String) Then
		Local $Return = $String
		$String = ''
	Else
		SetError(1)
		Local $Return = -1
	EndIf
	Return $Return
EndFunc

;$Array is an array, possibly nested with other arrays
;$Path is a string in the form 'x[,y[,...]][;z[,...]][;...]'
;$SoFar is used for tracking errors, should not be set by the user
;Function will return element z of the array nested in $Array[x][y], for example
Func _ArrayNGet(ByRef $Array, $Path, $SoFar = 'root;')
	Dim $ArrayIndex = _StringDequeue($Path, ';')
	If @error Then ;error processing $Path
		SetError(2)
		Return 'Error processing $Path'
	EndIf
	If Not IsArray($Array) Then ;Error with input $Array
		SetError(1)
		Return 'Item at "' & $SoFar & '" is not an array'
	EndIf
	Local $aPath = StringSplit($ArrayIndex, ',')
	If $aPath[0] <> UBound($Array, 0) Then ;$Path does not match array dimensions
		SetError(3)
		Return '"' & $ArrayIndex & '" does not match the dimensions of the array at "' & $SoFar & '"'
	EndIf
	Local $i
	For $i = 1 To Int($aPath[0])
		$aPath[$i] = int($aPath[$i])
		If $aPath[$i] < 0 Or $aPath[$i] >= UBound($Array, $i) Then ;$Path does not match array limits
			SetError(4)
			Return '"' & $ArrayIndex & '" excedes the boundry of dimension "' & $i & '" of the array at "' & $SoFar & '"'
		EndIf
	Next
	If $Path = '' Then ;process the current array
		Select
		Case $aPath[0] = 1
			Return $Array[$aPath[1]]
		Case $aPath[0] = 2
			Return $Array[$aPath[1]][$aPath[2]]
		Case $aPath[0] = 3
			Return $Array[$aPath[1]][$aPath[2]][$aPath[3]]
		Case $aPath[0] = 4
			Return $Array[$aPath[1]][$aPath[2]][$aPath[3]][$aPath[4]]
		Case $aPath[0] = 5
			Return $Array[$aPath[1]][$aPath[2]][$aPath[3]][$aPath[4]][$aPath[5]]
		Case $aPath[0] = 6
			Return $Array[$aPath[1]][$aPath[2]][$aPath[3]][$aPath[4]][$aPath[5]][$aPath[6]]
		Case Else
			SetError(5)
			Return 'This function only supports arrays of up to 6 dimensions'
		EndSelect
	Else ;go down another level (nested)
		Select
		Case $aPath[0] = 1
			_ArrayNGet($Array[$aPath[1]], $Path, $SoFar & $ArrayIndex & ';')
		Case $aPath[0] = 2
			_ArrayNGet($Array[$aPath[1]][$aPath[2]], $Path, $SoFar & $ArrayIndex & ';')
		Case $aPath[0] = 3
			_ArrayNGet($Array[$aPath[1]][$aPath[2]][$aPath[3]], $Path, $SoFar & $ArrayIndex & ';')
		Case $aPath[0] = 4
			_ArrayNGet($Array[$aPath[1]][$aPath[2]][$aPath[3]][$aPath[4]], $Path, $SoFar & $ArrayIndex & ';')
		Case $aPath[0] = 5
			_ArrayNGet($Array[$aPath[1]][$aPath[2]][$aPath[3]][$aPath[4]][$aPath[5]], $Path, $SoFar & $ArrayIndex & ';')
		Case $aPath[0] = 6
			_ArrayNGet($Array[$aPath[1]][$aPath[2]][$aPath[3]][$aPath[4]][$aPath[5]][$aPath[6]], $Path, $SoFar & $ArrayIndex & ';')
		Case Else
			SetError(5)
			Return 'This function only supports arrays of up to 6 dimensions'
		EndSelect
	EndIf
EndFunc

;$Array is an array, possibly nested with other arrays
;$Path is a string in the form 'x[,y[,...]][;z[,...]][;...]'
;$Value is the value to set at the given location
;$SoFar is used for tracking errors, should not be set by the user
;Function will return element z of the array nested in $Array[x][y], for example
Func _ArrayNSet(ByRef $Array, $Path, $Value, $SoFar = 'root;')
	Dim $ArrayIndex = _StringDequeue($Path, ';')
	If @error Then ;error processing $Path
		SetError(2)
		Return 'Error processing $Path'
	EndIf
	If Not IsArray($Array) Then ;Error with input $Array
		SetError(1)
		Return 'Item at "' & $SoFar & '" is not an array'
	EndIf
	Local $aPath = StringSplit($ArrayIndex, ',')
	If $aPath[0] <> UBound($Array, 0) Then ;$Path does not match array dimensions
		SetError(3)
		Return '"' & $ArrayIndex & '" does not match the dimensions of the array at "' & $SoFar & '"'
	EndIf
	Local $i
	For $i = 1 To Int($aPath[0])
		$aPath[$i] = int($aPath[$i])
		If $aPath[$i] < 0 Or $aPath[$i] >= UBound($Array, $i) Then ;$Path does not match array limits
			SetError(4)
			Return '"' & $ArrayIndex & '" excedes the boundry of dimension "' & $i & '" of the array at "' & $SoFar & '"'
		EndIf
	Next
	If $Path = '' Then ;process the current array
		Select
		Case $aPath[0] = 1
			$Array[$aPath[1]] = $Value
		Case $aPath[0] = 2
			$Array[$aPath[1]][$aPath[2]] = $Value
		Case $aPath[0] = 3
			$Array[$aPath[1]][$aPath[2]][$aPath[3]] = $Value
		Case $aPath[0] = 4
			$Array[$aPath[1]][$aPath[2]][$aPath[3]][$aPath[4]] = $Value
		Case $aPath[0] = 5
			$Array[$aPath[1]][$aPath[2]][$aPath[3]][$aPath[4]][$aPath[5]] = $Value
		Case $aPath[0] = 6
			$Array[$aPath[1]][$aPath[2]][$aPath[3]][$aPath[4]][$aPath[5]][$aPath[6]] = $Value
		Case Else
			SetError(5)
			Return 'This function only supports arrays of up to 6 dimensions'
		EndSelect
	Else ;go down another level (nested)
		Select
		Case $aPath[0] = 1
			_ArrayNSet($Array[$aPath[1]], $Path, $Value, $SoFar & $ArrayIndex & ';')
		Case $aPath[0] = 2
			_ArrayNSet($Array[$aPath[1]][$aPath[2]], $Path, $Value, $SoFar & $ArrayIndex & ';')
		Case $aPath[0] = 3
			_ArrayNSet($Array[$aPath[1]][$aPath[2]][$aPath[3]], $Path, $Value, $SoFar & $ArrayIndex & ';')
		Case $aPath[0] = 4
			_ArrayNSet($Array[$aPath[1]][$aPath[2]][$aPath[3]][$aPath[4]], $Path, $Value, $SoFar & $ArrayIndex & ';')
		Case $aPath[0] = 5
			_ArrayNSet($Array[$aPath[1]][$aPath[2]][$aPath[3]][$aPath[4]][$aPath[5]], $Path, $Value, $SoFar & $ArrayIndex & ';')
		Case $aPath[0] = 6
			_ArrayNSet($Array[$aPath[1]][$aPath[2]][$aPath[3]][$aPath[4]][$aPath[5]][$aPath[6]], $Path, $Value, $SoFar & $ArrayIndex & ';')
		Case Else
			SetError(5)
			Return 'This function only supports arrays of up to 6 dimensions'
		EndSelect
	EndIf
EndFunc

;$Array is an array, possibly nested with other arrays
;$Path is a string in the form 'x[,y[,...]][;z[,...]][;...]'
;$Dimension is the dimension number to return.  Same as 'x' in UBound($a, x)
;$SoFar is used for tracking errors, should not be set by the user
;Function will return element z of the array nested in $Array[x][y], for example
Func _ArrayNUBound(ByRef $Array, $Path, $Dimension, $SoFar = 'root;')
	Dim $ArrayIndex = _StringDequeue($Path, ';')
	If @error Then ;error processing $Path
		SetError(2)
		Return 'Error processing $Path'
	EndIf
	If $ArrayIndex = '' Then ;process the current array
		$Dimension = int($Dimension)
		Return UBound($Array, $Dimension)
	Else ;go down another level (nested)
		Local $aPath = StringSplit($ArrayIndex, ',')
		If Not IsArray($Array) Then ;Error with input $Array
			SetError(1)
			Return 'Item at "' & $SoFar & '" is not an array'
		EndIf
		If $aPath[0] <> UBound($Array, 0) Then ;$Path does not match array dimensions
			SetError(3)
			Return '"' & $ArrayIndex & '" does not match the dimensions of the array at "' & $SoFar & '"'
		EndIf
		Local $i
		For $i = 1 To Int($aPath[0])
			$aPath[$i] = int($aPath[$i])
			If $aPath[$i] < 0 Or $aPath[$i] >= UBound($Array, $i) Then ;$Path does not match array limits
				SetError(4)
				Return '"' & $ArrayIndex & '" excedes the boundry of dimension "' & $i & '" of the array at "' & $SoFar & '"'
			EndIf
		Next
		Select
		Case $aPath[0] = 1
			_ArrayNUBound($Array[$aPath[1]], $Path, $Dimension, $SoFar & $ArrayIndex & ';')
		Case $aPath[0] = 2
			_ArrayNUBound($Array[$aPath[1]][$aPath[2]], $Path, $Dimension, $SoFar & $ArrayIndex & ';')
		Case $aPath[0] = 3
			_ArrayNUBound($Array[$aPath[1]][$aPath[2]][$aPath[3]], $Path, $Dimension, $SoFar & $ArrayIndex & ';')
		Case $aPath[0] = 4
			_ArrayNUBound($Array[$aPath[1]][$aPath[2]][$aPath[3]][$aPath[4]], $Path, $Dimension, $SoFar & $ArrayIndex & ';')
		Case $aPath[0] = 5
			_ArrayNUBound($Array[$aPath[1]][$aPath[2]][$aPath[3]][$aPath[4]][$aPath[5]], $Path, $Dimension, $SoFar & $ArrayIndex & ';')
		Case $aPath[0] = 6
			_ArrayNUBound($Array[$aPath[1]][$aPath[2]][$aPath[3]][$aPath[4]][$aPath[5]][$aPath[6]], $Path, $Dimension, $SoFar & $ArrayIndex & ';')
		Case Else
			SetError(5)
			Return 'This function only supports arrays of up to 6 dimensions'
		EndSelect
	EndIf
EndFunc

;$Array is an array, possibly nested with other arrays
;$Path is a string in the form 'x[,y[,...]][;z[,...]][;...]'
;$Dimensions is the dimensions to set to the array at the given location.  It is a string in the format 'x[,y[,..]]'
;$SoFar is used for tracking errors, should not be set by the user
;Function will return element z of the array nested in $Array[x][y], for example
Func _ArrayNReDim(ByRef $Array, $Path, $Dimensions, $SoFar = 'root;')
	Dim $ArrayIndex = _StringDequeue($Path, ';')
	If @error Then ;error processing $Path
		SetError(2)
		Return 'Error processing $Path'
	EndIf
	If $ArrayIndex = '' Then ;process the current array
		If Not IsString($Dimensions) Then
			SetError(6)
			Return 'Bad dimensions given - "' & $Dimensions & '" - split'
		EndIf
		Local $aPath = StringSplit($Dimensions, ',')
		Local $i
		For $i = 1 To Int($aPath[0])
			$aPath[$i] = int($aPath[$i])
			If $aPath[$i] < 1 Then
				SetError(6)
				Return 'Bad dimensions given - "' & $Dimensions & '"'
			EndIf
		Next
		If Not IsArray($Array) Then Dim $Array[1]
		Select
		Case $aPath[0] = 1
			ReDim $Array[$aPath[1]]
		Case $aPath[0] = 2
			ReDim $Array[$aPath[1]][$aPath[2]]
		Case $aPath[0] = 3
			ReDim $Array[$aPath[1]][$aPath[2]][$aPath[3]]
		Case $aPath[0] = 4
			ReDim $Array[$aPath[1]][$aPath[2]][$aPath[3]][$aPath[4]]
		Case $aPath[0] = 5
			ReDim $Array[$aPath[1]][$aPath[2]][$aPath[3]][$aPath[4]][$aPath[5]]
		Case $aPath[0] = 6
			ReDim $Array[$aPath[1]][$aPath[2]][$aPath[3]][$aPath[4]][$aPath[5]][$aPath[6]]
		Case Else
			SetError(5)
			Return 'This function only supports arrays of up to 6 dimensions'
		EndSelect
	Else ;go down another level (nested)
		Local $aPath = StringSplit($ArrayIndex, ',')
		If Not IsArray($Array) Then ;Error with input $Array
			SetError(1)
			Return 'Item at "' & $SoFar & '" is not an array'
		EndIf
		If $aPath[0] <> UBound($Array, 0) Then ;$Path does not match array dimensions
			SetError(3)
			Return '"' & $ArrayIndex & '" does not match the dimensions of the array at "' & $SoFar & '"'
		EndIf
		Local $i
		For $i = 1 To Int($aPath[0])
			$aPath[$i] = int($aPath[$i])
			If $aPath[$i] < 0 Or $aPath[$i] >= UBound($Array, $i) Then ;$Path does not match array limits
				SetError(4)
				Return '"' & $ArrayIndex & '" excedes the boundry of dimension "' & $i & '" of the array at "' & $SoFar & '"'
			EndIf
		Next
		Select
		Case $aPath[0] = 1
			_ArrayNReDim($Array[$aPath[1]], $Path, $Dimensions, $SoFar & $ArrayIndex & ';')
		Case $aPath[0] = 2
			_ArrayNReDim($Array[$aPath[1]][$aPath[2]], $Path, $Dimensions, $SoFar & $ArrayIndex & ';')
		Case $aPath[0] = 3
			_ArrayNReDim($Array[$aPath[1]][$aPath[2]][$aPath[3]], $Path, $Dimensions, $SoFar & $ArrayIndex & ';')
		Case $aPath[0] = 4
			_ArrayNReDim($Array[$aPath[1]][$aPath[2]][$aPath[3]][$aPath[4]], $Path, $Dimensions, $SoFar & $ArrayIndex & ';')
		Case $aPath[0] = 5
			_ArrayNReDim($Array[$aPath[1]][$aPath[2]][$aPath[3]][$aPath[4]][$aPath[5]], $Path, $Dimensions, $SoFar & $ArrayIndex & ';')
		Case $aPath[0] = 6
			_ArrayNReDim($Array[$aPath[1]][$aPath[2]][$aPath[3]][$aPath[4]][$aPath[5]][$aPath[6]], $Path, $Dimensions, $SoFar & $ArrayIndex & ';')
		Case Else
			SetError(5)
			Return 'This function only supports arrays of up to 6 dimensions'
		EndSelect
	EndIf
EndFunc
