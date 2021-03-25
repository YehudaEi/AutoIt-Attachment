;============================================================================
; Author: Jorj X. McKie
;============================================================================
;----------------------------------------------------------------------------
;
;----------------------------------------------------------------------------
#include <array.au3>
Func _TrendExp(ByRef $pX, ByRef $pY)

	Local $aX[UBound($pX)], $aY[UBound($pY)]
	Local $a_C[3], $i_a, $i_b, $i_r, $i_n
	$i_n = UBound($pX)

	$a_C[0] = -2

	If $i_n <> UBound($pY) Then ; input arrays have unequal size
		Return ($a_C)
	EndIf

	$aX = $pX ; local copy of x values

	$a_C[0] = -1
	; check if exponential trend is possible at all
	If _ArrayMin($pY) < 1E-10 Then ; not impossible
		Return ($a_C)
	EndIf

	For $i = 0 To $i_n - 1
		$aY[$i] = Log($pY[$i]) ; local copy of logarithm of y values
	Next

	; simply use linear trend for logarithmic scale
	$a_C = _TrendLine($aX, $aY) ; call linear trend function

	$i_a = $a_C[1]
	$i_b = $a_C[2]
	$i_r = 0

	; deviation r from TrendLine cannot be used -> recalculate
	For $i = 0 To $i_n - 1
		$i_r += Abs(Exp($aX[$i] * $i_a + $i_b) - $pY[$i]) / ($i_n * Abs($pY[$i]))
	Next

	$a_C[2] = Exp($a_C[2])
	$a_C[0] = 1-$i_r
	Return ($a_C)

EndFunc   ;==>_TrendExp

;----------------------------------------------------------------------------
Func _TrendLine(ByRef $pX, ByRef $aY)

	Local $i_n = UBound($aY)

	Local $i_x2 = 0, $i_x1 = 0, $i_xy = 0, $i_y1 = 0, $i_x0, $i_r, $i_s, $i_m
	Local $aMat[2][2], $a_C[2], $a_B[2], $aX[$i_n]

	$a_C[0] = -2
	If $i_n <> UBound($pX) Then ; sizes of input arrays unequal
		Return ($a_C)
	EndIf

	_XShift($pX, $aX, $i_m, $i_s)

	; calculate matrix coefficients
	For $i = 0 To $i_n - 1
		$i_x1 = $i_x1 + $aX[$i]
		$i_x2 = $i_x2 + $aX[$i] ^ 2
		$i_xy = $i_xy + $aX[$i] * $aY[$i]
		$i_y1 = $i_y1 + $aY[$i]
	Next
	; fill in result vector b of: A*x = b
	$a_B[0] = $i_xy ; Sum of x*y values
	$a_B[1] = $i_y1 ; Sum of y values

	; fill in coefficients for matrix A in A*x = b
	; In our case, A ($aMat) is a symmetrical matrix
	$aMat[0][0] = $i_x2 ; Sum of x^2 values (major reason for shifting x-axis)
	$aMat[0][1] = $i_x1 ; Sum of x values
	$aMat[1][0] = $i_x1 ; Sum of x values
	$aMat[1][1] = $i_n ; size of input arrays

	; call linear equation solver
	$a_C = _LINGLITER($aMat, $a_B)

	$c1 = $a_C[0]
	$c2 = $a_C[1]

	; eliminate shift of x values from result
	$a_C[0] = $c1 / $i_s
	$a_C[1] = $c2 - $c1 * $i_m / $i_s

	; calculate average deviation
	$i_r = 0
	For $i = 0 To $i_n - 1
		$i_r += Abs($a_C[0] * $pX[$i] + $a_C[1] - $aY[$i]) / ($i_n*Abs($aY[$i]))
	Next

	ReDim $a_C[3]
	; shift values in result vector
	$a_C[2] = $a_C[1]
	$a_C[1] = $a_C[0]
	$a_C[0] = 1-$i_r

	Return ($a_C)
EndFunc   ;==>_TrendLine

;----------------------------------------------------------------------------
Func _TrendPoly(ByRef $pX, ByRef $aY)

	Local $i_n = UBound($aY)
	Local $i_x4 = 0, $i_x3 = 0, $i_x2 = 0, $i_x1 = 0, $i_x2y = 0, $i_xy = 0, $i_y1 = 0
	Local $aMat[3][3], $a_C[3], $a_B[3], $aX[$i_n], $i_x0, $i_r, $i_s, $i_m

	$a_C[0] = -2
	If $i_n <> UBound($pX) Then ; input array sizes are unequal
		Return ($a_C)
	EndIf

	_XShift($pX, $aX, $i_m, $i_s)

	; calculate coefficients for linear equations
	For $i = 0 To $i_n - 1
		$i_x1 = $i_x1 + $aX[$i]
		$i_x2 = $i_x2 + $aX[$i] ^ 2
		$i_x3 = $i_x3 + $aX[$i] ^ 3
		$i_x4 = $i_x4 + $aX[$i] ^ 4
		$i_x2y = $i_x2y + $aX[$i] ^ 2 * $aY[$i]
		$i_xy = $i_xy + $aX[$i] * $aY[$i]
		$i_y1 = $i_y1 + $aY[$i]
	Next
	; fill result vector b in A*x = b
	$a_B[0] = $i_x2y ; sum of x*x*y values (major reason for x shift)
	$a_B[1] = $i_xy ; sum of x*y values
	$a_B[2] = $i_y1 ; sum of y values

	; Populate matrix A for A*x = b.
	; Note that A in our case is symmetric
	$aMat[0][0] = $i_x4 ; sum of x^4 values (major reason for x shift)
	$aMat[0][1] = $i_x3 ; sum of x^3 values (major reason for x shift)
	$aMat[0][2] = $i_x2 ; sum of x^2 values (major reason for x shift)
	$aMat[1][0] = $i_x3 ; sum of x^3 values (major reason for x shift)
	$aMat[1][1] = $i_x2 ; sum of x^2 values (major reason for x shift)
	$aMat[1][2] = $i_x1 ; sum of x values
	$aMat[2][0] = $i_x2 ; sum of x^2 values (major reason for x shift)
	$aMat[2][1] = $i_x1 ; sum of x values
	$aMat[2][2] = $i_n ; number of input values

	; call linear equation solver
	$a_C = _LINGLITER($aMat, $a_B)

	; take back shift of x values from result
	$c1 = $a_C[0]
	$c2 = $a_C[1]
	$c3 = $a_C[2]

	$a_C[0] = $c1 / $i_s ^ 2
	$a_C[1] = $c2 / $i_s - 2 * $c1 * $i_m / $i_s ^ 2
	$a_C[2] = $c1 * $i_m ^ 2 / $i_s ^ 2 - $c2 * $i_m / $i_s + $c3

	; calculate average deviation
	$i_r = 0
	For $i = 0 To $i_n - 1
		$i_r += Abs($a_C[0] * $pX[$i] ^ 2 + $a_C[1] * $pX[$i] + $a_C[2] - $aY[$i]) / ($i_n*Abs($aY[$i]))
	Next
	ReDim $a_C[4]
	; adjust result vector
	$a_C[3] = $a_C[2]
	$a_C[2] = $a_C[1]
	$a_C[1] = $a_C[0]
	$a_C[0] = 1-$i_r

	Return ($a_C)
EndFunc   ;==>_TrendPoly

;----------------------------------------------------------------------------
Func _LINGLITER($aMat, $aVek)
	; solves a linear symmetric, positiv definite equation system and
	; re-iterates when necessary
	Local $i_n = UBound($aVek), $i_rc
	Local $a_x0[$i_n], $a_x1[$i_n], $a_d0[$i_n], $a_r0[$i_n], $aM[$i_n][$i_n], $a_B[$i_n]

	$aM = $aMat ; local matrix copy
	$aG = $aMat ; local matrix copy (for Cholesky)
	$aGT = $aMat ; local matrix copy (for Cholesky)
	$a_B = $aVek ; local vector copy

	$i_rc = _Cholesky1($aM, $aG, $aGT) ; split $aM into triangular matrix $aG

	If $i_rc <> 0 Then
		$a_x0[0] = "*"
		Return ($a_x0)
	EndIf
	$a_x0 = _Cholesky2($aG, $aGT, $a_B) ; solve with Cholesky's method

	; prepare for iteration
	$a_r0 = _VminusV($a_B, _MVMult($aM, $a_x0)) ; calculate deviation from "ideal" result
	$Abw = _NormV($a_r0) ; if result is too far off: re-iterate

	While $Abw > 1E-10 ; re-iterate
		MsgBox(0, "Wir müssen iterieren!", $Abw)
		$a_d0 = _Cholesky2($aG, $aGT, $a_r0) ; take deviation as new result vector
		$a_x1 = _VplusV($a_x0, $a_d0) ; $a_x1 = improved result vector

		$a_r0 = _VminusV($a_B, _MVMult($aM, $a_x1)) ; new deviation vector

		If _NormV($a_r0) < $Abw Then ; if result really has improved ...
			$Abw = _NormV($a_r0) ; take it as new deviation
			$a_x0 = $a_x1 ; and go on with it as new deviation vector
		Else
			ExitLoop ; else accept what we have
		EndIf
	WEnd

	Return ($a_x0)
EndFunc   ;==>_LINGLITER

;----------------------------------------------------------------------------
Func _MVMult($aMat, $aVek)
	; Multiplication Matrix x Vector
	Local $a_C[UBound($aVek)]
	For $i = 0 To UBound($aVek) - 1
		$a_C[$i] = 0
		For $j = 0 To UBound($aMat) - 1
			$a_C[$i] = $a_C[$i] + $aMat[$i][$j] * $aVek[$j]
		Next
	Next
	Return ($a_C)
EndFunc   ;==>_MVMult

;----------------------------------------------------------------------------
Func _VplusV($a_A, $a_B)
	; Addition Vector + Vector
	Local $a_C[UBound($a_A)]
	For $i = 0 To UBound($a_A) - 1
		$a_C[$i] = $a_A[$i] + $a_B[$i]
	Next
	Return ($a_C)
EndFunc   ;==>_VplusV

Func _VminusV($a_A, $a_B)
	; Subtraction Vector - Vector
	Local $a_C[UBound($a_A)]
	For $i = 0 To UBound($a_A) - 1
		$a_C[$i] = $a_A[$i] - $a_B[$i]
	Next
	Return ($a_C)
EndFunc   ;==>_VminusV

;----------------------------------------------------------------------------
Func _NormV($a_A)
	; Square of the norm of a Vector
	Local $i_norm = 0
	;$i_norm= Sqrt(_ScalarP($a_A,$a_A))
	;Return($i_norm)

	For $i = 0 To UBound($a_A) - 1
		$i_norm = $i_norm + $a_A[$i] * $a_A[$i]
	Next
	Return ($i_norm)
EndFunc   ;==>_NormV

Func _ScalarP($a_A, $a_B)
	; Scalar product of 2 vectors
	Local $i_prod = 0
	For $i = 0 To UBound($a_A) - 1
		$i_prod = $i_prod + $a_A[$i] * $a_B[$i]
	Next
	Return ($i_prod)
EndFunc   ;==>_ScalarP

;----------------------------------------------------------------------------
Func MDet($aM)
	; Calculate determinant of a matrix (dim 3x3 or 2x2)

	If UBound($aM) = 3 Then
		$d = $aM[0][0] * $aM[1][1] * $aM[2][2]
		$d = $d - $aM[2][0] * $aM[1][1] * $aM[0][2]
		$d = $d + $aM[0][1] * $aM[1][2] * $aM[2][0]
		$d = $d - $aM[2][1] * $aM[1][2] * $aM[0][0]
		$d = $d + $aM[0][2] * $aM[1][0] * $aM[2][1]
		$d = $d - $aM[2][2] * $aM[1][0] * $aM[0][1]

		Return ($d)
	Else
		$d = $aM[0][0] * $aM[1][1] - $aM[1][0] * $aM[0][1]

		Return ($d)
	EndIf
EndFunc   ;==>MDet

Func _XShift(ByRef $pX, ByRef $aX, ByRef $i_m, ByRef $i_s)
	;---------------------------------------------------------------------
	; x-values are being shifted and resized such that x' = (x-m)s
	; where m is the average x-value and s an average deviation of the x.
	;---------------------------------------------------------------------

	$i_m = 0
	Local $i_n = UBound($pX)
	For $i = 0 To $i_n - 1
		$i_m = $i_m + $pX[$i] / $i_n
	Next
	; $i_m is the average x value

	$i_s = 0
	For $i = 0 To $i_n - 1
		$i_s = $i_s + Abs($pX[$i] - $i_m) / $i_n
	Next
	; $i_s is the average deviation of x values from their average

	; now define local modified x values
	For $i = 0 To $i_n - 1
		$aX[$i] = ($pX[$i] - $i_m) / $i_s
	Next
	Return (0)
EndFunc   ;==>_XShift

;==========================================================================
; Löst das Gleichungssystem $aMat * x = $aVek für die symmetrische,
; positiv definite Matrix $aMat und den Ergebnis-Vektor $aVek.
; _Cholesky1:	Zunächst wird mit dem Cholesky-Algorithmus $aMat in die
;				Dreiecks-Matrix
;				$aG ("links unten") und ihre Transponierte $aGT umgeformt.
;				Damit gilt dann $aMat = $aG * $aGT.
;
; Danach wird die Gleichung in zwei Teilschritten gelöst:
; _Cholesky2:	Löse die Gleichung $aG * $a_Y = $aVek
; _Cholesky2:	Löse die Gleichung $aGT * $a_X = $a_Y
; Der Lösungvektor $a_X im 2. Schritt ist gesuchte Lösung.
;==========================================================================

Func _Cholesky1(ByRef $aMat, ByRef $aG, ByRef $aGT)
	;==========================================================================
	; Formt eine symmetrische und positiv definite Matrix $aMat mit Hilfe
	; des Cholesky-Algorithmus um in eine untere Dreiecks-Matrix $aG, so dass
	; für sie und ihre transponierte Matrix gilt $aG * $aGT = $aMat.
	; Bei Erfolg werden $aG und $aGT errechnet und der Return-Kode ist 0.
	; Wenn $aMat nicht positiv definit ist, wird 1 zurückgegeben.
	;==========================================================================
	Local $i_n = UBound($aMat), $i_sum

	For $i = 0 To $i_n - 1
		For $j = 0 To $i
			$i_sum = $aG[$i][$j]
			For $k = 0 To $j - 1
				$i_sum = $i_sum - $aG[$i][$k] * $aG[$j][$k]
			Next
			If $i > $j Then
				$aG[$i][$j] = $i_sum / $aG[$j][$j]
			Else
				If $i_sum > 0 Then
					$aG[$i][$i] = Sqrt($i_sum)
				Else
					Return (1)
				EndIf
			EndIf
		Next
	Next

	; Matrix G oben rechts löschen
	For $i = 0 To $i_n - 1
		For $j = $i + 1 To $i_n - 1
			$aG[$i][$j] = 0
		Next
	Next

	; Matrix G nach GT transponieren
	For $i = 0 To $i_n - 1
		For $j = $i To $i_n - 1
			$aGT[$i][$j] = $aG[$j][$i]
		Next
	Next

	; Transponierte Matrix unten links löschen
	For $j = 0 To $i_n - 1
		For $i = $j + 1 To $i_n - 1
			$aGT[$i][$j] = 0
		Next
	Next

	Return (0)

EndFunc   ;==>_Cholesky1

Func _Cholesky2(ByRef $aG, ByRef $aGT, ByRef $aVek)
	;==========================================================================
	; Löst die Gleichung $aMat * $a_X = $aVek für eine positiv definite,
	; symmetrische Matrix, nachdem diese zuvor zerlegt wurde in
	; $aMat = $aG * $aGT, wobei $aG eine untere Dreiecksmatrix ist, und $aGT
	; ihre Transponierte.
	; Zurückgegeben wird der Lösungsvektor $a_X
	;==========================================================================
	$i_n = UBound($aG) ; Anzahl Zeilen / Spalten
	Local $a_X[$i_n], $a_Y[$i_n] ; Lösungsvektor, Hilfsvektor
	; Gleichungssystem G*y = b lösen
	For $i = 0 To $i_n - 1
		$a_Y[$i] = $aVek[$i]
		For $j = 0 To $i - 1
			$a_Y[$i] = $a_Y[$i] - $aG[$i][$j] * $a_Y[$j]
		Next
		$a_Y[$i] = $a_Y[$i] / $aG[$i][$i]
	Next

	; jetzt Gleichungsystem GT*x = y lösen - dieses "x" wollen wir!
	For $i = $i_n - 1 To 0 Step -1
		$a_X[$i] = 0
		For $j = $i_n - 1 To $i + 1 Step -1
			$a_X[$i] = $a_X[$i] + $aGT[$i][$j] * $a_X[$j]
		Next
		$a_X[$i] = ($a_Y[$i] - $a_X[$i]) / $aGT[$i][$i]
	Next

	Return ($a_X)
EndFunc   ;==>_Cholesky2
