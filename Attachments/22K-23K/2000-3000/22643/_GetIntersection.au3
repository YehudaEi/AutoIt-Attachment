;==================================================================================================
; Function Name:   _GetIntersection($Set1, $Set2 [, $GetAll=0 [, $Delim=Default]])
; Description::    Detect from 2 sets
;                  - Intersection (elements are contains in both sets)
;                  - Difference 1 (elements are contains only in $Set1)
;                  - Difference 2 (elements are contains only in $Set2)
; Parameter(s):    $Set1	set 1 (1D-array or delimited string)
;             	   $Set2	set 2 (1D-array or delimited string)
;      optional:   $GetAll	0 - only one occurence of every different element are shown (Default)
;             	   			1 - all elements of differences are shown
;      optional:   $Delim	Delimiter for strings (Default use the separator character set by Opt("GUIDataSeparatorChar") )
; Return Value(s): Succes	2D-array    [i][0]=Intersection
;                                       [i][1]=Difference 1
;                                       [i][2]=Difference 2
;                  Failure	-1	@error	set, that was given as array, is'nt 1D-array
; Note:            Comparison is case-sensitiv! - i.e. Number 9 is different to string '9'!
; Author(s):       BugFix (bugfix@autoit.de)
;==================================================================================================
Func _GetIntersection(ByRef $Set1, ByRef $Set2, $GetAll=0, $Delim=Default)
	Local $o1 = ObjCreate("System.Collections.ArrayList")
	Local $o2 = ObjCreate("System.Collections.ArrayList")
	Local $oUnion = ObjCreate("System.Collections.ArrayList")
	Local $oDiff1 = ObjCreate("System.Collections.ArrayList")
	Local $oDiff2 = ObjCreate("System.Collections.ArrayList")
	Local $tmp, $i
	If $GetAll <> 1 Then $GetAll = 0
	If $Delim = Default Then $Delim = Opt("GUIDataSeparatorChar")
	If Not IsArray($Set1) Then
		If Not StringInStr($Set1, $Delim) Then
			$o1.Add($Set1)
		Else
			$tmp = StringSplit($Set1, $Delim, 1)
			For $i = 1 To UBound($tmp) -1
				$o1.Add($tmp[$i])
			Next
		EndIf
	Else
		If UBound($Set1, 0) > 1 Then Return SetError(1,0,-1)
		For $i = 0 To UBound($Set1) -1
			$o1.Add($Set1[$i])
		Next
	EndIf
	If Not IsArray($Set2) Then
		If Not StringInStr($Set2, $Delim) Then
			$o2.Add($Set2)
		Else
			$tmp = StringSplit($Set2, $Delim, 1)
			For $i = 1 To UBound($tmp) -1
				$o2.Add($tmp[$i])
			Next
		EndIf
	Else
		If UBound($Set2, 0) > 1 Then Return SetError(1,0,-1)
		For $i = 0 To UBound($Set2) -1
			$o2.Add($Set2[$i])
		Next
	EndIf
	For $tmp In $o1
		If $o2.Contains($tmp) And Not $oUnion.Contains($tmp) Then $oUnion.Add($tmp)
	Next
	For $tmp In $o2
		If $o1.Contains($tmp) And Not $oUnion.Contains($tmp) Then $oUnion.Add($tmp)
	Next
	For $tmp In $o1
		If $GetAll Then
			If Not $oUnion.Contains($tmp) Then $oDiff1.Add($tmp)
		Else
			If Not $oUnion.Contains($tmp) And Not $oDiff1.Contains($tmp) Then $oDiff1.Add($tmp)
		EndIf
	Next
	For $tmp In $o2
		If $GetAll Then
			If Not $oUnion.Contains($tmp) Then $oDiff2.Add($tmp)
		Else
			If Not $oUnion.Contains($tmp) And Not $oDiff2.Contains($tmp) Then $oDiff2.Add($tmp)
		EndIf
	Next
	Local $UBound[3] = [$oDiff1.Count,$oDiff2.Count,$oUnion.Count], $max = 1
	For $i = 0 To UBound($UBound) -1
		If $UBound[$i] > $max Then $max = $UBound[$i]
	Next
	Local $aOut[$max][3]
	If $oUnion.Count > 0 Then
		$i = 0
		For $tmp In $oUnion
			$aOut[$i][0] = $tmp
			$i += 1
		Next
	EndIf
	If $oDiff1.Count > 0 Then
		$i = 0
		For $tmp In $oDiff1
			$aOut[$i][1] = $tmp
			$i += 1
		Next
	EndIf
	If $oDiff2.Count > 0 Then
		$i = 0
		For $tmp In $oDiff2
			$aOut[$i][2] = $tmp
			$i += 1
		Next
	EndIf
	Return $aOut
EndFunc  ;==>_GetIntersection