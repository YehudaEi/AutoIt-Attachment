#cs
vi:ts=4 sw=4:
SubStruct.au3
Ejoc
Add easier support for structs within structs
#ce
#include-once

;=====================================================
;	_DllStructSubStruct(ByRef $p, $iElement, $szStruct)
;	$p			The return from DllStructCreate()
;	$iElement	The element where the sub struct is located
;	$szStruct	The String representing the Sub Struct
;	Returns a new struct for use in DllStructGet/DllStructSet
;	Sets @Error to -1 if $iElement is outside, -2 sub struct
;		would go outside the bounds of the struct
;	$p's elements are decreased as the substruct elements are removed
;
;	$RECT_STR	= "int;int;int;int"
;	$POINT_STR	= "int;int"
;	$p			= DllStructCreate("ptr;" & $RECT_STR & ";" & $POINT_STR)
;	$rect		= _DllStructSubStruct($p,2,$RECT_STR)
;	$point		= _DllStructSubStruct($p,3,$POINT_STR)
;	DllCall("some.dll","int","func","ptr",DllStructPtr($p))
;	$point_x	= DllStructGet($point,1)
;	$point_y	= DllStructGet($point,2)
;	$left		= DllStructGet($rect,1)
;	$top		= DllStructGet($rect,2)
;	$right		= DllStructGet($rect,3)
;	$bottom		= DllStructGet($rect,4)
;	DllStructFree($p)
;=====================================================
Func _DllStructSubStruct(ByRef $p,$iElement,$szStruct)
	local $array,$iSubSize,$szSplit,$i,$iSubOffset=0

	SetError(0)
	$szSplit	= StringSplit($szStruct,";");count the semicolons
	$iSubSize	= $szSplit[0]
	if StringRight($szStruct,1) = ";" Then $iSubSize -= 1;ingnore a trail ';'

	;check if it is a valid element
	if $iElement > $p[0][2] Or $iElement < 1 Then
		SetError(-1)
		return
	Endif

	;check if the substruct would go beyond the struct
	if $iElement + $iSubSize > $p[0][2] Then
		SetError(-2)
		return
	EndIf

	Dim $array[$iSubSize+1][3]
	For $i = 1 To $iSubSize
		$array[$i][0]	= $iSubOffset;new offset
		$array[$i][1]	= $p[$iElement + $i - 1][1];sizeof(datatype)
		$array[$i][2]	= $p[$iElement + $i - 1][2];flags
		If $iElement + $i <= $p[0][2] Then ;isnt the last element of the struct
			$iSubOffset		= $p[$iElement + $i][0] - $p[$iElement][0]
		Else;this is the last element of the struct
			$iSubOffset		= $p[0][1] - $p[$iElement][0]
		EndIf
	Next
	$array[0][0]	= $p[0][0] + $p[$iElement][0];ptr to the substruct
	$array[0][1]	= $iSubOffset	;substruct size in bytes
	$array[0][2]	= $iSubSize		;elements in substruct

	$p[$iElement][1]	= 1 ;set the datatype size for the sub struct to 1
	;shift the elements down
	For $i = $iElement + 1 To $p[0][2] - ($iSubSize - 1)
		$p[$i][0]	= $p[$i + $iSubSize - 1][0]
		$p[$i][1]	= $p[$i + $iSubSize - 1][1]
		$p[$i][2]	= $p[$i + $iSubSize - 1][2]
	Next
	;decrease the number of elements
	$p[0][2]	-= $iSubSize - 1

	ReDim $p[$p[0][2]+1][3]

	Return $array
EndFunc
