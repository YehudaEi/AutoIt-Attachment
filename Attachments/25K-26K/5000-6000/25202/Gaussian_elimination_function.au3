#include <Array.au3>

; #FUNCTION# ====================================================================================================================
; Name...........: _SolveLinearSystem
; Description ...: Solves a system of linear equations
; Syntax.........: _SolveLinearSystem ($input_matrix)
; Parameters ....: $input_matrix: Augmented matrix containing coefficients and constants. Column 0 and row 0 are blank. Example:
;				   In the system 2x + 3y = 7 and 6x + 4y = 3, the 3 x 4 matrix would be
;				   [["", "", "", ""], ["", 2, 3, 7], ["", 6, 4, 3]]
; Return values .: Returns a one-dimensional array with solutions for each variable, starting with element 1
;				   for the solution to variable 1, etc.
;				   Returns -1 if the solution is an empty set or there are an infinite number of solutions.
;				   Returns -2 if the $input_matrix does not have the right dimensions (see Remarks)
; Author ........: Diego Hernandez < d dot hernandez 09 at g mail dot com >
; Modified.......: 
; Remarks .......: This version only works on systems with square coefficient matrices, i.e. only functions that have 
;				   two variables and two equations, three variables and three equations, etc. can be used.
; ===============================================================================================================================
Func _SolveLinearSystem ($input_matrix)
	If Ubound ($input_matrix, 2) <> Ubound ($input_matrix, 1) + 1 Then Return (-2)
	Global $Matrix = $input_matrix
	$stat = GaussianEliminationRecursive ()
	If $stat = -1 Then Return (-1)
	$return_matrix = GaussJordanRecursive ()
	$Matrix = 0
	Return ($return_matrix)
EndFunc


; #INTERNAL_USE_ONLY#============================================================================================================
; Name...........: GaussianEliminationRecursive
; Description ...: Performs Gaussian elimination to the global $Matrix to reduce it to triangular form.
; Syntax.........: GaussianEliminationRecursive ()
; Parameters ....: None
; Return values .: None (Success)
;				   -1 (System's solution is empty set or has infinitely many solutions)
; Author ........: Diego Hernandez < d dot hernandez 09 at g mail dot com >
; Modified.......:
; Remarks .......: For internal use only
; ===============================================================================================================================
Func GaussianEliminationRecursive ()
	$highest_var = Ubound ($matrix, 2) - 2 ; in a system of three equations - three variables, it's 3 (for the variable z)
	$stat = ClearMainDiagonalRecursive ()
	If $stat = -1 Then Return (-1)
	;_ArrayDisplay ($Matrix, "Matrix")
	For $x = 1 To $highest_var - 1
		For $y = $x + 1 To $highest_var
			Eliminate ($x, $y, $x)
			;_ArrayDisplay ($Matrix, $x & ", " & $y & ", " & $x)
		Next
	Next
	;_ArrayDisplay ($Matrix, "Echelon form")
EndFunc

; #INTERNAL_USE_ONLY#============================================================================================================
; Name...........: GaussJordanRecursive
; Description ...: Performs Gauss-Jordan elimination to reduce $Matrix from row echelon form to reduced row echelon form
; Syntax.........: GaussJordanRecursive ()
; Parameters ....: None
; Return values .: A one-dimensional array containing the solution for each variable. Element 1 contains the solution to variable
;				   1, element 2 contains the solution to variable 2, etc.
; Author ........: Diego Hernandez < d dot hernandez 09 at g mail dot com >
; Modified.......:
; Remarks .......: For internal use only
; ===============================================================================================================================
Func GaussJordanRecursive ()
	
$constant_pos = Ubound ($matrix, 2) - 1
$highest_var = Ubound ($matrix, 2) - 2 ; in a system of three equations - three variables, it's 3 (for the variable z)
Global $solutions_matrix[$highest_var+1]

MultiplyWholeRow ($highest_var, (1/$matrix[$highest_var][$highest_var]))
$solutions_matrix[$highest_var] = $matrix[$highest_var][$constant_pos]

For $m = 1 To $highest_var - 1 ; in three equations - three variables, it's 2
	For $n = 0 To $m - 1
		BackSubstituteAndSimplify ($highest_var - $m, $highest_var - $n, $solutions_matrix[$highest_var-$n])
	Next
	MultiplyWholeRow ($highest_var - $m, 1/($matrix[$highest_var-$m][$highest_var-$m]))
	$solutions_matrix[$highest_var-$m] = $matrix[$highest_var-$m][$constant_pos]
Next

;_ArrayDisplay ($Matrix)
;_ArrayDisplay ($solutions_matrix, "Final answer")

Return ($solutions_matrix)

EndFunc

; #INTERNAL_USE_ONLY#============================================================================================================
; Name...........: BackSubstituteAndSimplify
; Description ...: Performs back substitution on $Matrix with a known variable and simplifies. Part of Gauss-Jordan elimination.
; Syntax.........: BackSubstituteAndSimplify ($row, $variable, $variable)
; Parameters ....: $row = the row to substitute the variable in
;				   $variable = the variable to substitute (1 for the first variable, 2 for the second, etc)
;				   $variable_value = the value of the variable that is to be substituted
; Return values .: None
; Author ........: Diego Hernandez < d dot hernandez 09 at g mail dot com >
; Modified.......:
; Remarks .......: For internal use only
; ===============================================================================================================================
Func BackSubstituteAndSimplify ($row, $variable, $variable_value) ;$variable is 1, 2, 3, etc
	$constant_pos = Ubound ($matrix, 2) - 1
	$matrix[$row][$constant_pos] = $matrix[$row][$constant_pos] - ($variable_value * $matrix[$row][$variable])
	$matrix[$row][$variable] = 0
EndFunc

; #INTERNAL_USE_ONLY#============================================================================================================
; Name...........: MultiplyWholeRow
; Description ...: Multiplies a row of $Matrix by a scalar. Used in Gauss-Jordan elimination.
; Syntax.........: MultiplyWholeRow ($row, $factor)
; Parameters ....: $row = the $Matrix row that is to be multiplied
;				   $factor - the scalar to multiply the row
; Return values .: None
; Author ........: Diego Hernandez < d dot hernandez 09 at g mail dot com >
; Modified.......:
; Remarks .......: For internal use only
; ===============================================================================================================================
Func MultiplyWholeRow ($row, $factor)
	$constant_pos = Ubound ($matrix, 2) - 1
	For $count = 1 To $constant_pos
		If $matrix[$row][$count]<>0 Then $matrix[$row][$count] = $factor * $matrix[$row][$count]
	Next
EndFunc

; #INTERNAL_USE_ONLY#============================================================================================================
; Name...........: ClearMainDiagonalRecursive
; Description ...: Switches rows in $Matrix, if necessary, so that elements in the main diagonal of the coefficient matrix
;				   of $Matrix (an augmented matrix) are nonzero. This allows Gaussian elimination to be performed on the matrix.
; Syntax.........: ClearMainDiagonalRecursive ()
; Parameters ....: None
; Return values .: None (Success)
;				   -1 (System's solution is empty set or has infinitely many solutions)
; Author ........: Diego Hernandez < d dot hernandez 09 at g mail dot com >
; Modified.......:
; Remarks .......: For internal use only
; ===============================================================================================================================
Func ClearMainDiagonalRecursive ()
	$highest_var = Ubound ($matrix, 2) - 2
	For $x = 1 To $highest_var
		If $matrix[$x][$x] = 0 Then
			$y = 1
			ToolTip ($y)
			While 1
				If $y <> $x and $matrix[$y][$x] <> 0 Then ; useless to switch with yourself!
					SwitchValuesRow ($x, $y)
					ExitLoop
				Else
					$y = $y + 1
					If $y > $highest_var Then Return (-1) ; Infinite or nonexistent solution.
				EndIf
			WEnd
		EndIf
	Next
EndFunc	

; #INTERNAL_USE_ONLY#============================================================================================================
; Name...........: SwitchValuesRow
; Description ...: Switches the values of two rows in $Matrix.
; Syntax.........: SwitchValuesRow ($a, $b)
; Parameters ....: $a and $b = the rows in $Matrix to switch
; Return values .: None
; Author ........: Diego Hernandez < d dot hernandez 09 at g mail dot com >
; Modified.......:
; Remarks .......: For internal use only
; ===============================================================================================================================
Func SwitchValuesRow ($a, $b)
	$constant_pos = Ubound ($matrix, 2) - 1
	For $count = 1 To $constant_pos
		$x = $matrix[$a][$count]
		$y = $matrix[$b][$count]
		$matrix[$a][$count] = $y
		$matrix[$b][$count] = $x
	Next
EndFunc

; #INTERNAL_USE_ONLY#============================================================================================================
; Name...........: Eliminate
; Description ...: Eliminates a variable by multiplying a row by a scalar and subtracting it from the
;				   row in which the variable is to be eliminated. A recurring step in Gaussian elimination.
; Syntax.........: Eliminate ($line_from, $line_to, $variable)
; Parameters ....: $line_from = the line in $Matrix to be multiplied by a scalar and subtracted from line number $line_to
;				   $line_to = the line that contains the variable to be eliminated
;				   $variable = the number of the variable tp be eliminated (1 for the first variable, 2 for the second, etc)
; Return values .: None
; Author ........: Diego Hernandez < d dot hernandez 09 at g mail dot com >
; Modified.......:
; Remarks .......: For internal use only
; ===============================================================================================================================
Func Eliminate ($line_from, $line_to, $variable) ;$variable: 1 for x, 2 for y, 3 for z, etc
	$constant_pos = Ubound ($matrix, 2) - 1
	$factor = -1 * $matrix[$line_to][$variable] / $matrix[$line_from][$variable]
	For $a = 1 To $constant_pos
		$matrix[$line_to][$a] = ($factor * $matrix[$line_from][$a]) + $matrix[$line_to][$a]
	Next
EndFunc
