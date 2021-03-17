#include <Array.au3>
#include <Misc.au3>

Dim $a2by2[2][2] = [["Face", "Hair"],["Lemon", "Pickle"]]
Dim $a3by2[3][2] = [["Cookie", "Nether"],["Toothpick", "Questions"],["Harlem", "Shake"]]
Dim $a2by3[2][3] = [["Impact", "Apple", "Cawdle"],["Surreptitious", "Flamboyant", "Defenestration"]]

Local $a10 = $a2by2, $a11 = $a2by2, $a12 = $a2by2, $a13 = $a2by2
Local $a2s = $a3by2, $a20 = $a3by2, $a21 = $a3by2
Local $a3s = $a2by3

_ArrayConcatenate2D($a10, $a2s) ;Default vertical concatenation
_ArrayDisplay($a10)

_ArrayConcatenate2D($a11, $a3s, 1) ;Horizontal concatenation
_ArrayDisplay($a11)

_ArrayConcatenate2D($a12, $a2s, 1) ;Attempted vertical concatenation, [3][2] to [2][2]
If @error Then MsgBox(0, "!! Error on $a2by2 !!", "Horizontal concatenation of [3][2] to [2][2]:" & @CRLF & @CRLF & _Iif(@error < 2, "Columns must be equal!", "Rows must be equal!"))

_ArrayConcatenate2D($a13, $a3s) ;Attempted horizontal concatenation, [2][3] to [2][2]
If @error Then MsgBox(0, "!! Error on $a2by2 !!", "Vertical concatenation of [2][3] to [2][2]:" & @CRLF & @CRLF & _Iif(@error < 2, "Columns must be equal!", "Rows must be equal!"))

_ArrayConcatenate2D($a20, $a3s) ;Attempted concatenation, [2][3] to [3][2]
If @error Then MsgBox(0, "!! Error on $a3by2 !!", "Vertical concatenation of [2][3] to [3][2]:" & @CRLF & @CRLF & _Iif(@error < 2, "Columns must be equal!", "Rows must be equal!"))

_ArrayConcatenate2D($a21, $a3s, 1) ;This also fails
If @error Then MsgBox(0, "!! Error on $a3by2 !!", "Horizontal concatenation of [2][3] to [3][2]:" & @CRLF & @CRLF & _Iif(@error < 2, "Columns must be equal!", "Rows must be equal!"))

; #FUNCTION# ====================================================================================================================
; Name ..........: _ArrayConcatenate2D
; Description ...: Concatenate two-dimensional arrays. For vertical concatenation,
;                  column count must be equal. For horizontal concatination, row
;                  count must be equal.
; Syntax ........: _ArrayConcatenate2D(Byref $aParent, Const Byref $aVictim[, $iMode = 0])
; Parameters ....: $aParent             - [in/out] The parent array.
;                  $aVictim             - [in/out and const] The victim array. This is concatenated
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
; Remarks .......: Can be made faster by ReDim out of loop
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _ArrayConcatenate2D(ByRef $aParent, Const ByRef $aVictim, $iMode = 0)
	Switch $iMode
		Case 0 ;Vertical concatenate
			If UBound($aParent, 2) <> UBound($aVictim, 2) Then Return SetError(1, 0, -1) ;col# not equal, @error=1
			For $i = 0 To UBound($aVictim, 1) - 1 ;Loops through all rows of array to be added
				ReDim $aParent[UBound($aParent, 1) + 1][UBound($aParent, 2)] ;Adds one row to parent array
				For $j = 0 To UBound($aVictim, 2) - 1 ;Loops through all columns of victim array
					$aParent[UBound($aParent, 1) - 1][$j] = $aVictim[$i][$j] ;Sets each new item of parent array
				Next
			Next
		Case 1 ;Horizontal concatenate
			If UBound($aParent, 1) <> UBound($aVictim, 1) Then Return SetError(2, 0, -1) ;row# not equal, @error=2
			For $i = 0 To UBound($aVictim, 2) - 1 ;Loops through all columns of array to be added
				ReDim $aParent[UBound($aParent, 1)][UBound($aParent, 2) + 1] ;Adds one column to parent array
				For $j = 0 To UBound($aVictim, 1) - 1 ;Loops through all rows of victim array
					$aParent[$j][UBound($aParent, 2) - 1] = $aVictim[$j][$i] ;Sets each new item of parent array
				Next
			Next
		Case Else
			Return SetError(3, 0, -1) ;invalid mode, @error=3
	EndSwitch

	If $aParent = "" Then Return SetError(4, 0, -1) ;wtf?? @error=4

	Return $aParent
EndFunc   ;==>_ArrayConcatenate2D