#include <Array.au3>
#include <Misc.au3>

Dim $array1[2][2] = [["Face", "Hair"],["Lemon", "Pickle"]]
Dim $array2[3][2] = [["Cookie", "Nether"],["Toothpick", "Questions"],["Harlem", "Shake"]]
Dim $array3[2][3] = [["Impact", "Apple", "Cawdle"],["Surreptitious", "Flamboyant", "Defenestration"]]

$c = _ArrayConcatenate2D($array1, $array2) ;Default vertical concatenation
_ArrayDisplay($c)

$d = _ArrayConcatenate2D($array1, $array3, 1) ;Horizontal concatenation
_ArrayDisplay($d)

$e = _ArrayConcatenate2D($array1, $array2, 1) ;Attempted vertical concatenation, [3][2] to [2][2]
If @error Then MsgBox(0, "!! Error on $e !!", "Horizontal concatenation of [3][2] to [2][2]:" & @CRLF & @CRLF & _Iif(@error < 2, "Columns must be equal!", "Rows must be equal!"))

$f = _ArrayConcatenate2D($array1, $array3) ;Attempted horizontal concatenation, [2][3] to [2][2]
If @error Then MsgBox(0, "!! Error on $f !!", "Vertical concatenation of [2][3] to [2][2]:" & @CRLF & @CRLF & _Iif(@error < 2, "Columns must be equal!", "Rows must be equal!"))

$g = _ArrayConcatenate2D($array2, $array3) ;Attempted concatenation, [2][3] to [3][2]
If @error Then MsgBox(0, "!! Error on $g !!", "Vertical concatenation of [2][3] to [3][2]:" & @CRLF & @CRLF & _Iif(@error < 2, "Columns must be equal!", "Rows must be equal!"))

$h = _ArrayConcatenate2D($array2, $array3, 1) ;This also fails
If @error Then MsgBox(0, "!! Error on $h !!", "Horizontal concatenation of [2][3] to [3][2]:" & @CRLF & @CRLF & _Iif(@error < 2, "Columns must be equal!", "Rows must be equal!"))

; #FUNCTION# ====================================================================================================================
; Name ..........: _ArrayConcatenate2D
; Description ...: Concatenate two-dimensional arrays. For vertical concatenation,
;                  column count must be equal. For horizontal concatination, row
;                  count must be equal.
; Syntax ........: _ArrayConcatenate2D($aParent, $aVictim[, $iMode = 0])
; Parameters ....: $aParent             - The parent array.
;                  $aVictim             - The victim array. This is concatenated
;                                         to the end of the parent array.
;                  $iMode               - [optional] Use vert/horiz concatenation.
;                                         (0=v,1=h) Default is 0.
; Return values .: Success - Returns concatenated array
;                  Failure - Returns -1 and sets @error:
;                            1 - col# not equal
;                            2 - row# not equal
;                            3 - mode invalid (0 or 1)
;                            4 - general error
; Author ........: cyberbit
; Modified ......: 08.06.13
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _ArrayConcatenate2D($aParent, $aVictim, $iMode = 0)
	Local $aResultant = ""

	Switch $iMode
		Case 0 ;Vertical concatenate
			$aResultant = $aParent ;Sets result array to parent array
			If UBound($aParent, 2) <> UBound($aVictim, 2) Then Return SetError(1, 0, -1) ;col# not equal, @error=1
			For $i = 0 To UBound($aVictim, 1) - 1 ;Loops through all rows of array to be added
				ReDim $aResultant[UBound($aResultant, 1) + 1][UBound($aParent, 2)] ;Adds one row to result array
				For $j = 0 To UBound($aVictim, 2) - 1 ;Loops through all columns of victim array
					$aResultant[UBound($aResultant, 1) - 1][$j] = $aVictim[$i][$j] ;Sets each item of result array
				Next
			Next
		Case 1 ;Horizontal concatenate
			$aResultant = $aParent ;Sets result array to parent array
			If UBound($aParent, 1) <> UBound($aVictim, 1) Then Return SetError(2, 0, -1) ;row# not equal, @error=2
			For $i = 0 To UBound($aVictim, 2) - 1 ;Loops through all columns of array to be added
				ReDim $aResultant[UBound($aParent, 1)][UBound($aResultant, 2) + 1] ;Adds one column to result array
				For $j = 0 To UBound($aVictim, 1) - 1 ;Loops through all rows of victim array
					$aResultant[$j][UBound($aResultant, 2) - 1] = $aVictim[$j][$i] ;Sets each item of result array
				Next
			Next
		Case Else
			Return SetError(3, 0, -1) ;invalid mode, @error=3
	EndSwitch

	If $aResultant = "" Then Return SetError(4, 0, -1) ;wtf?? @error=4

	Return $aResultant
EndFunc   ;==>_ArrayConcatenate2D