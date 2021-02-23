
#region #### Includes ============================================================================================================
	#include-once
	#include <array.au3>
#endregion ======================================================================================================================

#cs
	#CURRENT# =====================================================================================================================
		_ArrayAdd_2dim
	#CURRENT# =====================================================================================================================
#ce

; #Function -  _ArrayAdd_2dim ======================================================================================================================================
; Parameters ....:	$avArray = Array to add with additional Array
;					$newARRAY = aditional Array
; Error .........:	1 = Master Array is no Array
;					2 = add. Array is no Array
;					3 = Master Array is no 2D Array
;					4 = add. Array is no 2D Array
; Return ........:	0 = All OK
; Description ...: to ad a 2dimensional Array to another 2 dimensional Arry
; ==========================================================================================================================================================================

Func _ArrayAdd_2dim(ByRef $avArray, $newARRAY)
	If Not IsArray($avArray) Then Return SetError(1, 0, -1)
	If Not IsArray($newARRAYArray) Then Return SetError(2, 0, -1)
	If UBound($avArray, 0) <> 2 Then Return SetError(3, 0, -1)
	If UBound($newARRAY, 0) <> 2 Then Return SetError(4, 0, -1)
	Local $i, $j,$jj

	;##################################################################
	;### check which Array is the Biggest
	;##################################################################

	If UBound($avArray,2) > UBound($newARRAY,2) then $newdim = UBound($avArray,2)
	If UBound($avArray,2) < UBound($newARRAY,2) then $newdim = UBound($newARRAY,2)

	;##################################################################
	;### Redim the Array Size
	;##################################################################

	ReDim $avArray[(UBound($avArray,1))+(UBound($newARRAY,1))][$newdim] ; 1 Array zeile hinzufügen

	;##################################################################
	;### add the Array
	;##################################################################

	for $i = (UBound($avArray)-1) to (UBound($avArray))-(UBound($newARRAY)) Step -1
		$j = UBound($newARRAY)-$jj-1
		for $k = 0 to (UBound($newARRAY,2)-1)
			ConsoleWrite('+$avArray['&$i&']['&$k&'] = $newARRAY['&$j&']['&$k&']'&@CRLF)
 			$avArray[$i][$k] = $newARRAY[$j][$k]
		Next
		ConsoleWrite(@CRLF)
		$jj +=1
	Next
;~ _ArrayDisplay($avArray)
	return(0)
EndFunc





