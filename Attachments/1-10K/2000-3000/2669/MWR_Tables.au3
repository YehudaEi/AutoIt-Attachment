; ----------------------------------------------------------------------------
;
; AutoIt Version: 3.1.0
; Author:         Mike Ratzlaff <mike@ratzlaff.org>
;
; Script Function:
;	Library for using "tables" - 2D arrays
;
; Script revision version:
;	20050604A
;
; ----------------------------------------------------------------------------

; Table: Definition:
; A table is an array of 2-dimensions.  The second dimension is normally 2, but may be larger.
; The values in the 1st dimension of the array are index keys, and must be unique.
; The value at [0][0] is an integer indicating the number of valid entries in the table.
; This is necessary because the table may be larger than the data, and there may be blank/invalid data at the end.
; A null string is not a valid index key - this is reserved for entries flagged for removal.

$_TableDefaultLength=20
$_TableDefaultIncrease=20

Func _TableCreate(ByRef $Table, $Length = -1, $Width = 2)
	$Length=int($Length)
	$Width=int($Width)
	If $Length<1 Then $Length=$_TableDefaultLength
	If $Width<2 Then $Width=2
	Dim $Table[$Length][$Width]
	$Table[0][0]=0
	Return -1
EndFunc

Func _TableIsValid($Table)
	Dim $Return=-1
	If $Return and UBound($Table,0)<>2 Then $Return=0
	If $Return and UBound($Table,2)<2 Then $Return=0
	If $Return and int($Table[0][0])<>$Table[0][0] Then $Return=0
	If $Return and UBound($Table,1)<=$Table[0][0] Then $Return=0
	Return $Return
EndFunc

Func _TableGetSize($Table)
	If _TableIsValid($Table) Then
		Return $Table[0][0]
	Else ;Error
		Return -1
	EndIf
EndFunc

Func _TableSetValue(ByRef $Table, $Key, $Value)
	If _TableIsValid($Table) Then
		$KeyU=StringUpper($Key)
		Dim $i=1,$Done=0
		;First try to set the value to an existing key
		While $i<=$Table[0][0] and not $Done
			If $Table[$i][0]<>'' And StringUpper($Table[$i][0])=$KeyU Then
				$Table[$i][1]=$Value
				$Done=-1
			Else
				$i=$i+1
			EndIf
		WEnd
		;If key is not found, look for a blank key to insert at
		If not $Done Then
			$i=1
			While $i<=$Table[0][0] and not $Done
				If $Table[$i][0]='' Then
					dim $k
					For $k=0 To UBound($Table,2)-1
						$Table[$i][$k]=''
					Next
					$Table[$i][0]=$Key
					$Table[$i][1]=$Value
					$Done=-1
				Else
					$i=$i+1
				EndIf
			WEnd
		EndIf
		;If key is not found, add a new one at the end
		If not $Done Then
			;Resize the table if needed
			If $i>=UBound($Table,1) Then 
				$_TableDefaultIncrease=int($_TableDefaultIncrease)
				If $_TableDefaultIncrease<1 Then $_TableDefaultIncrease=1
				ReDim $Table[UBound($Table)+$_TableDefaultIncrease][UBound($Table)]
			EndIf
			;Set the new key at the end
			$Table[$i][0]=$Key
			$Table[$i][1]=$Value
			$Table[0][0]=$Table[0][0] + 1
			$Done=-1
		EndIf
	EndIf ;Table Is Valid
EndFunc

Func _TableGetIndex($Table, $Key)
	If _TableIsValid($Table) Then
		Dim $i
		$Key=StringUpper($Key)
		For $i=1 To $Table[0][0]
			If $Table[$i][0]<>'' And StringUpper($Table[$i][0])=$Key Then Return $i
		Next
		Return 0
	Else ;Error
		Return -1
	EndIf
EndFunc

Func _TableGetValue($Table, $Key, $Column=1, $Default='')
	Dim $i=_TableGetIndex($Table,$Key)
	If $i>0 Then
		$Column=int($Column)
		If $Column<1 Then $Column = 1
		If $Column>=UBound($Table,2) Then $Column = 1
		Return $Table[$i][$Column]
	Else ;not found or error
		Return $Default
	EndIf
EndFunc

Func _TablePrint($Table, $Delim=',', $EOL=@CRLF)
	If _TableIsValid($Table) Then
		Dim $out, $i, $j
		For $i=1 to $Table[0][0]
			$out=$out & $Table[$i][0] & $Delim & $Table[$i][1]
			For $j=2 to UBound($Table,2)-1
				$Out=$Out & $Delim & $Table[$i][$j]
			Next
			if $i<>$Table[0][0] Then $out=$out & $EOL
		Next
		Return $Out
	Else ;Error
		Return ''
	EndIf
EndFunc

Func _TableGetKeys($Table)
	If _TableIsValid($Table) Then
		Dim $i, $j
		Dim $Return[$Table[0][0]+1]
		$j=1
		For $i=1 to $Table[0][0]
			If $Table[$i][0]<>'' Then
				$Return[$j]=$Table[$i][0]
				$j=$j+1
			EndIf
		Next
		$Return[0]=$j-1
		Redim $Return[$j]
		Return $Return
	Else ;Error
		Return ''
	EndIf
EndFunc
