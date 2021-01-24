#include-once

; ------------------------------------------------------------------------------
;
; AutoIt Version: 3.2.12.1
; Language:       English
; Description:    Functions that assist with mathematical calculations.
;
; ------------------------------------------------------------------------------

; #VARIABLES# ------------------------------------------------------------------
Global Const $PI = 3.1415926535897932384626433832795028841971693993751058209749445923078164062862089986280348253421170679
Global Const $E  = 2.7182818284590452353602874713526624977572470936999595749669676277240766303535475945713821785251664274

; #CURRENT# ==================================================================
; ------Misc------
;_Factorial
;_Angle
;_Heron
;_GCD
;_LCM
;_Distance
;_Log
;_Root
;_Interest
;_Triangular
;_Reference
;_Simplify
; ------Boolean Checks------
;_IsTriangular
;_IsEven
;_IsOdd
; ------Trig------
;_Versin
;_Coversin
;_Exsec
;_Excsc
;_Haversin
;_Hacoversin
;_Sin
;_Cos
;_Tan
;_Csc
;_Sec
;_Cot
; ------Inverse Trig------
;_ASin
;_ACos
;_ATan
;_ACsc
;_ASec
;_ACot
;_AVersin
;_ACoversin
;_AExsec
;_AExcsc
;_AHaversin
;_AHacoversin
; ------Hyperbolic------
;_Sinh
;_Cosh
;_Tanh
;_Coth
;_Sech
;_Csch
; ------Inverse Hyperbolic------
;_ASinh
;_ACosh
;_ATanh
;_ACoth
;_ASech
;_ACsch
; ============================================================================

;===============================================================================
;
; Function Name:    _Interest($n_Initial,$n_Rate,$n_Intervals,$n_Times_Per_Interval)
;
; Description:      Compound Interest
;
; Syntax:           _Interest($n_Initial, $n_Rate, $n_Intervals, $n_Times_Per_Interval=1)
;
; Parameter(s):     $n_Initial				- Initial Value
;                   $n_Rate					- % Rate growth rate per interest cycle
;                   $n_Intervals			- X coordinate of point 2
;                   $n_Times_Per_Interval	- Y coordinate of point 2
;
; Requirement(s):  External:   = None.
;                  Internal:   = None.
;
; Return Value(s):  Success: Value after interes has been aplied
;                   Failure: Blank String
;                   @error:  0 - No Error
;                            1 - $nInitial is not a number
;                            2 - $nRate is not a number
;                            3 - $nIntervals is not a number
;                            4 - $nTimesPerInterval is not a number
;
; Author(s):        Matthew McMullan
;
; Notes:           
;
; Example(s):
;
;===============================================================================
Func _Interest($nInitial, $nRate, $nIntervals, $nTimesPerInterval=1)
	If Not IsNumber($nInitial) Then
		SetError(1)
		Return ""
	ElseIf Not IsNumber($nRate) Then
		SetError(2)
		Return ""
	ElseIf Not IsNumber($nIntervals) Then
		SetError(3)
		Return ""
	ElseIf Not IsNumber($nTimesPerInterval) Then
		SetError(4)
		Return ""
	EndIf
	Return $nInitial*(1+$nRate/$nTimesPerInterval)^($nTimesPer_Interval*$nIntervals)
EndFunc


;=============================================================================
;
; Function Name:   _Triangular
;
; Description:     Returns the nth triangular number
;
; Syntax:          _Triangular($nNumber)
;
; Parameter(s);    $nNumber    = number (will be turned into an int)
;
; Requirement(s):  External:   = None.
;                  Internal:   = None.
;
; Return Value(s): Success: True = 1
;                           False = 0
;                  Failure: Blank String
;                  @error : 0 - No Error
;                           1 - $nNumber is not a number
;
; Author(s):       Matthew McMullan (NerdFencer)
;
; Notes:           
;
; Example(s):
;
;=============================================================================
Func _IsTriangular($nNumber)
	If Not IsNumber($nNumber) Then
		SetError(1)
		Return ""
	EndIf
	$nCheck = 0
	For $nInt=1 To Int($nNumber) Step 1
		If $nCheck==$nNumber Then
			Return 1
		EndIf
		$nCheck = $nCheck + $nInt
		If $nCheck > $nNumber Then
			Return 0
		EndIf
	Next
EndFunc

;=============================================================================
;
; Function Name:   _Triangular
;
; Description:     Returns the nth triangular number
;
; Syntax:          _Triangular($nNumber)
;
; Parameter(s);    $nNumber    = number (will be turned into an int)
;
; Requirement(s):  External:   = None.
;                  Internal:   = None.
;
; Return Value(s): Success: the nth triangular number
;                  Failure: Blank String
;                  @error : 0 - No Error
;                           1 - $nNumber is not a number
;
; Author(s):       Matthew McMullan (NerdFencer)
;
; Notes:           
;
; Example(s):
;
;=============================================================================
Func _Triangular($nNumber)
	If Not IsNumber($nNumber) Then
		SetError(1)
		Return ""
	EndIf
	$nOutput = 1
	For $nInt=2 To Int($nNumber) Step 1
		$nOutput = $nOutput + $nInt
	Next
	Return $nOutput
EndFunc

;=============================================================================
;
; Function Name:   _Root
;
; Description:     Returns the nth root of a number
;
; Syntax:          _Root($nNumber,$nTh=2)
;
; Parameter(s);    $nNumber    = number to get the root of
;                  $nTh        = Nth in "Nth root"
;
; Requirement(s):  External:   = None.
;                  Internal:   = None.
;
; Return Value(s): Success: The log in the specified base
;                  Failure: Blank String
;                  @error : 0 - No Error
;                           1 - $nNumber is not a number
;                           2 - $nTh is not a number
;
; Author(s):       Matthew McMullan (NerdFencer)
;
; Notes:           
;
; Example(s):
;
;=============================================================================
Func _Root($nNumber,$nTh=2)
	If Not IsInt($nNumber) Then
		SetError(1)
		Return ""
	ElseIf Not IsInt($nTh) Then
		SetError(2)
		Return ""
	EndIf
	Return $nNumber^(1/$nTh)
EndFunc

;=============================================================================
;
; Function Name:   _Log
;
; Description:     Returns the Log in the specified base
;
; Syntax:          _Log($nNumber,$nBase = 10)
;
; Parameter(s);    $nNumber    = number to get the log of
;                  $nBase      = the base to get the log in
;
; Requirement(s):  External:   = None.
;                  Internal:   = None.
;
; Return Value(s): Success: The log in the specified base
;                  Failure: Blank String
;                  @error : 0 - No Error
;                           1 - $nNumber is not a number
;                           2 - $nBase is not a number
;
; Author(s):       Matthew McMullan (NerdFencer)
;
; Notes:           
;
; Example(s):
;
;=============================================================================
Func _Log($nNumber,$nBase = 10)
	If Not IsInt($nNumber) Then
		SetError(1)
		Return ""
	ElseIf Not IsInt($nBase) Then
		SetError(2)
		Return ""
	EndIf
	Return Log($nNumber)/Log($nBase)
EndFunc

;=============================================================================
;
; Function Name:   _IsEven
;
; Description:     Checks to see if a number is even
;
; Syntax:          _IsEven($nNumber)
;
; Parameter(s);    $nNumber    = number to check
;
; Requirement(s):  External:   = None.
;                  Internal:   = None.
;
; Return Value(s): Success: Even = 1
;                           Odd  = 0
;                  Failure: Blank String
;                  @error : 0 - No Error
;                           1 - $nNumber is not a number
;
; Author(s):       Matthew McMullan (NerdFencer)
;
; Notes:           
;
; Example(s):
;
;=============================================================================
Func _IsEven($nNumber)
	If Not IsInt($nNumber) Then
		SetError(1)
		Return ""
	EndIf
	Return 1-Abs(Mod($nNumber,2))
EndFunc

;=============================================================================
;
; Function Name:   _IsOdd
;
; Description:     Checks to see if a number is odd
;
; Syntax:          _IsOdd($nNumber)
;
; Parameter(s);    $nNumber    = number to check
;
; Requirement(s):  External:   = None.
;                  Internal:   = None.
;
; Return Value(s): Success: Odd  = 1
;                           Even = 0
;                  Failure: Blank String
;                  @error : 0 - No Error
;                           1 - $nNumber is not a number
;
; Author(s):       Matthew McMullan (NerdFencer)
;
; Notes:           
;
; Example(s):
;
;=============================================================================
Func _IsOdd($nNumber)
	If Not IsInt($nNumber) Then
		SetError(1)
		Return ""
	EndIf
	Return Abs(Mod($nNumber,2))
EndFunc

;=============================================================================
;
; Function Name:   _Distance
;
; Description:     Returns the distance between 2 points
;
; Syntax:          _Distance($nX1,$nY1,$nX2,$nY2)
;
; Parameter(s);    $nX1, $nY1 Coordinates of point 1
;                  $nX2, $nY2 Coordinates of point 2
;
; Requirement(s):  External:   = None.
;                  Internal:   = None.
;
; Return Value(s): Success: the distance between the two points
;                  Failure: Returns empty string
;                  @error : 0 - No Error
;                           1 - $nX1 is not a number
;                           2 - $nY1 is not a number
;                           3 - $nX2 is not a number
;                           4 - $nY2 is not a number
;
; Author(s):       Matthew McMullan (NerdFencer)
;
; Notes:           
;
; Example(s):
;
;=============================================================================
Func _Distance($nX1,$nY1,$nX2,$nY2)
	If Not IsNumber($nX1) Then
		SetError(1)
		Return ""
	ElseIf Not IsNumber($nY1) Then
		SetError(2)
		Return ""
	ElseIf Not IsNumber($nX2) Then
		SetError(3)
		Return ""
	ElseIf Not IsNumber($nY2) Then
		SetError(4)
		Return ""
	EndIf
	Return Sqrt(($nX2-$nX1)^2+($nY2-$nY1)^2)
EndFunc

;=============================================================================
;
; Function Name:   _LCM
;
; Description:     Returns the least common multiple
;
; Syntax:          _LCM($nA,$nB)
;
; Parameter(s);    $nA, $nB  The two numbers
;
; Requirement(s):  External:   = None.
;                  Internal:   = None.
;
; Return Value(s): Success: the greatest common divisor
;                  Failure: Blank String
;                  @error : 0 - No Error
;                           1 - $nA is not a number
;                           2 - $nB is not a number
;
; Author(s):       Matthew McMullan (NerdFencer)
;
; Notes:           
;
; Example(s):
;
;=============================================================================
Func _LCM($nA,$nB)
	If Not IsNumber($nA) Then
		SetError(1)
		Return ""
	ElseIf Not IsNumber($nB) Then
		SetError(2)
		Return ""
	EndIf
	Local $nTmp
	Local $nProduct = $nA*$nB
	Local $nX = $nA
	Local $nY = $nB
	While $nX
        If $nX < $nY Then
            $ntmp = $nX
            $nX = $nY
            $nY = $ntmp
        EndIf
        $nX = Mod($nX,$nY)
    WEnd
    Return $nproduct/$nY
EndFunc

;=============================================================================
;
; Function Name:   _GCD
;
; Description:     Returns the greatest common divisor of the numbers
;
; Syntax:          _GCD($nA,$nB)
;
; Parameter(s);    $nA, $nB  The two numbers
;
; Requirement(s):  External:   = None.
;                  Internal:   = None.
;
; Return Value(s): Success: the greatest common divisor
;                  Failure: Blank String
;                  @error : 0 - No Error
;                           1 - $nA is not a number
;                           2 - $nB is not a number
;
; Author(s):       Matthew McMullan (NerdFencer)
;
; Notes:           
;
; Example(s):
;
;=============================================================================
Func _GCD($nA,$nB)
	If Not IsNumber($nA) Then
		SetError(1)
		Return ""
	ElseIf Not IsNumber($nB) Then
		SetError(2)
		Return ""
	EndIf
	Local $nX = $nA
	Local $nY = $nB
	Local $nMax = Abs($nA)
	If Abs($nB)>Abs($nA) Then
		$nMax = Abs($nB)
	EndIf
	For $nLoops = 0 To $nMax Step 1
		$nX = Mod($nX,$nY)
		If $nX == 0 Then
			Return $nY
		EndIf
		$nY = Mod($nY,$nX)
		If $nY == 0 Then
			Return $nX
		EndIf
	Next
	Return ""
EndFunc

;=============================================================================
;
; Function Name:   _Heron
;
; Description:     Returns the area of the triangle given the sides
;
; Syntax:          _Heron($nA,$nB,$nC)
;
; Parameter(s);    $nA, $nB, $nC  The lengths of the three sides of the triangle
;
; Requirement(s):  External:   = None.
;                  Internal:   = None.
;
; Return Value(s): Success: the area of the triangle
;                  Failure: Blank String
;                  @error : 0 - No Error
;                           1 - $nA is not a number
;                           2 - $nB is not a number
;                           3 - $nC is not a number
;
; Author(s):       Matthew McMullan (NerdFencer)
;
; Notes:           
;
; Example(s):
;
;=============================================================================
Func _Heron($nA,$nB,$nC)
	If Not IsNumber($nA) Then
		SetError(1)
		Return ""
	ElseIf Not IsNumber($nB) Then
		SetError(2)
		Return ""
	ElseIf Not IsNumber($nC) Then
		SetError(3)
		Return ""
	EndIf
	Local $nS = ($nA+$nB+$nC)/2
	Return Sqrt($nS*($nS-$nA)*($nS-$nB)*($nS-$nC))
EndFunc

;=============================================================================
;
; Function Name:   _Sinh
;
; Description:     Returns the hyperbolic sine of a number
;
; Syntax:          _Sinh($nNumber)
;
; Parameter(s);    $nNumber    = number
;
; Requirement(s):  External:   = None.
;                  Internal:   = None.
;
; Return Value(s): Success: the hyperbolic sine of the number
;                  Failure: Blank String
;                  @error : 0 - No Error
;                           1 - $nNumber is not a number
;
; Author(s):       Matthew McMullan (NerdFencer)
;
; Notes:           
;
; Example(s):
;
;=============================================================================
Func _Sinh($nNumber)
	If Not IsNumber($nNumber) Then
		SetError(1)
		Return ""
	EndIf
	Return ($E^$nNumber - $E^(-$nNumber))/2
EndFunc

;=============================================================================
;
; Function Name:   _ASinh
;
; Description:     Returns the inverse hyperbolic sine of a number
;
; Syntax:          _ASinh($nNumber)
;
; Parameter(s);    $nNumber    = number
;
; Requirement(s):  External:   = None.
;                  Internal:   = None.
;
; Return Value(s): Success: the inverse hyperbolic sine of the number
;                  Failure: Blank String
;                  @error : 0 - No Error
;                           1 - $nNumber is not a number
;
; Author(s):       Matthew McMullan (NerdFencer)
;
; Notes:           
;
; Example(s):
;
;=============================================================================
Func _ASinh($nNumber)
	If Not IsNumber($nNumber) Then
		SetError(1)
		Return ""
	EndIf
	Return Log($nNumber+Sqrt($nNumber^2+1))
EndFunc

;=============================================================================
;
; Function Name:   _Cosh
;
; Description:     Returns the hyperbolic sine of a number
;
; Syntax:          _Cosh($nNumber)
;
; Parameter(s);    $nNumber    = number
;
; Requirement(s):  External:   = None.
;                  Internal:   = None.
;
; Return Value(s): Success: the hyperbolic cosine of the number
;                  Failure: Blank String
;                  @error : 0 - No Error
;                           1 - $nNumber is not a number
;
; Author(s):       Matthew McMullan (NerdFencer)
;
; Notes:           
;
; Example(s):
;
;=============================================================================
Func _Cosh($nNumber)
	If Not IsNumber($nNumber) Then
		SetError(1)
		Return ""
	EndIf
	Return ($E^$nNumber + $E^(-$nNumber))/2
EndFunc

;=============================================================================
;
; Function Name:   _ACosh
;
; Description:     Returns the inverse hyperbolic sine of a number
;
; Syntax:          _ACosh($nNumber)
;
; Parameter(s);    $nNumber    = number
;
; Requirement(s):  External:   = None.
;                  Internal:   = None.
;
; Return Value(s): Success: the inverse hyperbolic cosine of the number
;                  Failure: Blank String
;                  @error : 0 - No Error
;                           1 - $nNumber is not a number
;
; Author(s):       Matthew McMullan (NerdFencer)
;
; Notes:           
;
; Example(s):
;
;=============================================================================
Func _ACosh($nNumber)
	If Not IsNumber($nNumber) Then
		SetError(1)
		Return ""
	EndIf
	Return Log($nNumber+Sqrt($nNumber^2-1))
EndFunc

;=============================================================================
;
; Function Name:   _Csch
;
; Description:     Returns the hyperbolic cosecant of a number
;
; Syntax:          _Sinh($nNumber)
;
; Parameter(s);    $nNumber    = number
;
; Requirement(s):  External:   = None.
;                  Internal:   = None.
;
; Return Value(s): Success: the hyperbolic cosecant of the number
;                  Failure: Blank String
;                  @error : 0 - No Error
;                           1 - $nNumber is not a number
;
; Author(s):       Matthew McMullan (NerdFencer)
;
; Notes:           
;
; Example(s):
;
;=============================================================================
Func _Csch($nNumber)
	If Not IsNumber($nNumber) Then
		SetError(1)
		Return ""
	EndIf
	Return 2/($E^$nNumber - $E^(-$nNumber))
EndFunc

;=============================================================================
;
; Function Name:   _ACsch
;
; Description:     Returns the inverse hyperbolic cosecant of a number
;
; Syntax:          _ASinh($nNumber)
;
; Parameter(s);    $nNumber    = number
;
; Requirement(s):  External:   = None.
;                  Internal:   = None.
;
; Return Value(s): Success: the inverse hyperbolic cosecant of the number
;                  Failure: Blank String
;                  @error : 0 - No Error
;                           1 - $nNumber is not a number
;
; Author(s):       Matthew McMullan (NerdFencer)
;
; Notes:           
;
; Example(s):
;
;=============================================================================
Func _ACsch($nNumber)
	If Not IsNumber($nNumber) Then
		SetError(1)
		Return ""
	EndIf
	Return Log(1/$nNumber+Sqrt($nNumber^2+1)/Abs($nNumber))
EndFunc

;=============================================================================
;
; Function Name:   _Sech
;
; Description:     Returns the hyperbolic secant of a number
;
; Syntax:          _Cosh($nNumber)
;
; Parameter(s);    $nNumber    = number
;
; Requirement(s):  External:   = None.
;                  Internal:   = None.
;
; Return Value(s): Success: the hyperbolic secant of the number
;                  Failure: Blank String
;                  @error : 0 - No Error
;                           1 - $nNumber is not a number
;
; Author(s):       Matthew McMullan (NerdFencer)
;
; Notes:           
;
; Example(s):
;
;=============================================================================
Func _Sech($nNumber)
	If Not IsNumber($nNumber) Then
		SetError(1)
		Return ""
	EndIf
	Return 2/($E^$nNumber + $E^(-$nNumber))
EndFunc

;=============================================================================
;
; Function Name:   _ASech
;
; Description:     Returns the inverse hyperbolic secant of a number
;
; Syntax:          _Cosh($nNumber)
;
; Parameter(s);    $nNumber    = number
;
; Requirement(s):  External:   = None.
;                  Internal:   = None.
;
; Return Value(s): Success: the inverse hyperbolic secant of the number
;                  Failure: Blank String
;                  @error : 0 - No Error
;                           1 - $nNumber is not a number
;
; Author(s):       Matthew McMullan (NerdFencer)
;
; Notes:           
;
; Example(s):
;
;=============================================================================
Func _ASech($nNumber)
	If Not IsNumber($nNumber) Then
		SetError(1)
		Return ""
	EndIf
	Return Log((1+Sqrt(1-$nNumber^2))/$nNumber)
EndFunc

;=============================================================================
;
; Function Name:   _Tanh
;
; Description:     Returns the hyperbolic tangent of a number
;
; Syntax:          _Cosh($nNumber)
;
; Parameter(s);    $nNumber    = number
;
; Requirement(s):  External:   = None.
;                  Internal:   = None.
;
; Return Value(s): Success: the hyperbolic tangent of the number
;                  Failure: Blank String
;                  @error : 0 - No Error
;                           1 - $nNumber is not a number
;
; Author(s):       Matthew McMullan (NerdFencer)
;
; Notes:           
;
; Example(s):
;
;=============================================================================
Func _Tanh($nNumber)
	If Not IsNumber($nNumber) Then
		SetError(1)
		Return ""
	EndIf
	Return ($E^(2*$nNumber)-1)/($E^(2*$nNumber)+1)
EndFunc

;=============================================================================
;
; Function Name:   _ATanh
;
; Description:     Returns the inverse hyperbolic tangent of a number
;
; Syntax:          _Cosh($nNumber)
;
; Parameter(s);    $nNumber    = number
;
; Requirement(s):  External:   = None.
;                  Internal:   = None.
;
; Return Value(s): Success: the inverse hyperbolic tangent of the number
;                  Failure: Blank String
;                  @error : 0 - No Error
;                           1 - $nNumber is not a number
;
; Author(s):       Matthew McMullan (NerdFencer)
;
; Notes:           
;
; Example(s):
;
;=============================================================================
Func _ATanh($nNumber)
	If Not IsNumber($nNumber) Then
		SetError(1)
		Return ""
	EndIf
	Return .5*Log((1+$nNumber)/(1-$nNumber))
EndFunc

;=============================================================================
;
; Function Name:   _Coth
;
; Description:     Returns the hyperbolic cotangent of a number
;
; Syntax:          _Coth($nNumber)
;
; Parameter(s);    $nNumber    = number
;
; Requirement(s):  External:   = None.
;                  Internal:   = None.
;
; Return Value(s): Success: the hyperbolic cotangent of the number
;                  Failure: Blank String
;                  @error : 0 - No Error
;                           1 - $nNumber is not a number
;
; Author(s):       Matthew McMullan (NerdFencer)
;
; Notes:           
;
; Example(s):
;
;=============================================================================
Func _Coth($nNumber)
	If Not IsNumber($nNumber) Then
		SetError(1)
		Return ""
	EndIf
	Return ($E^(2*$nNumber)+1)/($E^(2*$nNumber)-1)
EndFunc

;=============================================================================
;
; Function Name:   _ACoth
;
; Description:     Returns the inverse hyperbolic cotangent of a number
;
; Syntax:          _Coth($nNumber)
;
; Parameter(s);    $nNumber    = number
;
; Requirement(s):  External:   = None.
;                  Internal:   = None.
;
; Return Value(s): Success: the inverse hyperbolic cotangent of the number
;                  Failure: Blank String
;                  @error : 0 - No Error
;                           1 - $nNumber is not a number
;
; Author(s):       Matthew McMullan (NerdFencer)
;
; Notes:           
;
; Example(s):
;
;=============================================================================
Func _ACoth($nNumber)
	If Not IsNumber($nNumber) Then
		SetError(1)
		Return ""
	EndIf
	Return .5*Log(($nNumber+1)/($nNumber-1))
EndFunc

;=============================================================================
;
; Function Name:   _Factorial
;
; Description:     Returns the factorial of a number
;
; Syntax:          _Factorial($nNumber)
;
; Parameter(s);    $nNumber    = number (will be turned into an int)
;
; Requirement(s):  External:   = None.
;                  Internal:   = None.
;
; Return Value(s): Success: the factorial of the number
;                  Failure: Blank String
;                  @error : 0 - No Error
;                           1 - $nNumber is not a number
;
; Author(s):       Matthew McMullan (NerdFencer)
;
; Notes:           
;
; Example(s):
;
;=============================================================================
Func _Factorial($nNumber)
	If Not IsNumber($nNumber) Then
		SetError(1)
		Return ""
	EndIf
	$nOutput = 1
	For $nInt=2 To Int($nNumber) Step 1
		$nOutput = $nOutput + $nInt
	Next
	Return $nOutput
EndFunc

;=============================================================================
;
; Function Name:   _Angle
;
; Description:     Converts an angle to the specified format
;
; Syntax:          _Angle($sCurrent, $sTarget, $nAngle)
;
; Parameter(s);    $sCurrnt    = current angle format (see notes)
;                  $sTarget    = target angle format (see notes)
;                  $nAngle     = the angle
;
; Requirement(s):  External:   = None.
;                  Internal:   = VARIABLE-$PI.
;
; Return Value(s): Success: Returns the angle in the target format
;                  Failure: Blank String
;                  @error : 0 - No Error
;                           1 - $nAngle is not a number
;
; Author(s):       Matthew McMullan (NerdFencer)
;
; Notes:           the angle formats are as follows... (not case sensitive)
;                  Degree or Deg - degrees
;                  Radian or Rad - radians
;                  Gradian or Grad - gradians
;                  Anything other than what is above will be assumed to be degrees
;
; Example(s):
;
;=============================================================================
Func _Angle($sCurrent, $sTarget, $nAngle)
	If Not IsNumber($nAngle) Then
		SetError(1)
		Return ""
	EndIf
	If $sCurrent==$sTarget Then
		Return $nAngle
	EndIf
	$nOutput = $nAngle
	If (StringLower($sCurrent) == "radian") Or (StringLower($sCurrent) == "rad") Then
		$nOutput = ($nAngle*180)/$PI
	ElseIf (StringLower($sCurrent) == "gradian") Or (StringLower($sCurrent) == "grad") Then
		$nOutput = ($nAngle*10)/9
	EndIf
	If (StringLower($sTarget) == "radian") Or (StringLower($sTarget) == "rad") Then
		$nOutput = ($nAngle*$PI)/180
	ElseIf (StringLower($sTarget) == "gradian") Or (StringLower($sTarget) == "grad") Then
		$nOutput = ($nAngle*9)/10
	EndIf
	Return $nOutput
EndFunc

;=============================================================================
;
; Function Name:   _Reference
;
; Description:     Gets the reference angle
;
; Syntax:          _Reference($nAngle, $sFormat="rad")
;
; Parameter(s);    $nAngle     = the angle
;                  $nFormat    = the format of the angle (see Notes)
;
; Requirement(s):  External:   = None.
;                  Internal:   = _Angle,_Simplify.
;
; Return Value(s): Success: Returns the reference angle
;                  Failure: Blank String
;                  @error : 0 - No Error
;                           1 - $nAngle is not a number
;
; Author(s):       Matthew McMullan (NerdFencer)
;
; Notes:           the angle formats are as follows... (not case sensitive)
;                  Degree or Deg - degrees
;                  Radian or Rad - radians
;                  Gradian or Grad - gradians
;                  Anything other than what is above will be assumed to be degrees
;
; Example(s):
;
;=============================================================================
Func _Reference($nAngle, $sFormat="rad")
	If Not IsNumber($nAngle) Then
		SetError(1)
		Return ""
	EndIf
	$nTempAngle = _Angle($sFormat,"deg",_Simplify($nAngle,$sFormat))
	If $nTempAngle>=270 Then
		Return _Angle("deg",$sFormat,360-$nTempAngle)
	ElseIf $nTempAngle>=180 Then
		Return _Angle("deg",$sFormat,$nTempAngle-180)
	ElseIf $nTempAngle>=90 Then
		Return _Angle("deg",$sFormat,180-$nTempAngle)
	EndIf
	Return _Angle("deg",$sFormat,$nTempAngle)
EndFunc

;=============================================================================
;
; Function Name:   _Simplify
;
; Description:     Gets the most simple version of an angle
;
; Syntax:          _Simplify($nAngle, $sFormat="rad")
;
; Parameter(s);    $nAngle     = the angle
;                  $nFormat    = the format of the angle (see Notes)
;
; Requirement(s):  External:   = None.
;                  Internal:   = _Angle.
;
; Return Value(s): Success: Returns the most simple version of the angle
;                  Failure: Blank String
;                  @error : 0 - No Error
;                           1 - $nAngle is not a number
;
; Author(s):       Matthew McMullan (NerdFencer)
;
; Notes:           the angle formats are as follows... (not case sensitive)
;                  Degree or Deg - degrees
;                  Radian or Rad - radians
;                  Gradian or Grad - gradians
;                  Anything other than what is above will be assumed to be degrees
;
; Example(s):
;
;=============================================================================
Func _Simplify($nAngle, $sFormat="rad")
	If Not IsNumber($nAngle) Then
		SetError(1)
		Return ""
	EndIf
	$nTempAngle = _Angle($sFormat,"deg",$nAngle)
	$nTempAngle = Mod($nTempAngle,360)
	If $nTempAngle<0 Then
		$nTempAngle = $nTempAngle + 360
	EndIf
	Return _Angle("deg",$sFormat,$nTempAngle)
EndFunc

;=============================================================================
;
; Function Name:   _Versin
;
; Description:     Returns the versin of an angle
;
; Syntax:          _Versin($nAngle)
;
; Parameter(s);    $nAngle     = Angle
;                  $sFormat    = Format of the angle ("deg","rad","grad")
;
; Requirement(s):  External:   = None.
;                  Internal:   = _Angle.
;
; Return Value(s): Success: the versin of an angle
;                  Failure: Blank String
;                  @error : 0 - No Error
;                           1 - $nAngle is not a number
;
; Author(s):       Matthew McMullan (NerdFencer)
;
; Notes:           
;
; Example(s):      
;
;=============================================================================
Func _Versin($nAngle, $sFormat="rad")
	If Not IsNumber($nAngle) Then
		SetError(1)
		Return ""
	EndIf
	Return 1-Cos(_Angle($sFormat,"rad",$nAngle))
EndFunc

;=============================================================================
;
; Function Name:   _Coversin
;
; Description:     Returns the coversin of an angle
;
; Syntax:          _Coversin($nAngle)
;
; Parameter(s);    $nAngle     = Angle in Radians
;                  $sFormat    = Format of the angle ("deg","rad","grad")
;
; Requirement(s):  External:   = None.
;                  Internal:   = _Angle.
;
; Return Value(s): Success: the coversin of an angle
;                  Failure: Blank String
;                  @error : 0 - No Error
;                           1 - $nAngle is not a number
;
; Author(s):       Matthew McMullan (NerdFencer)
;
; Notes:           
;
; Example(s):      
;
;=============================================================================
Func _Coversin($nAngle,$sFormat="rad")
	If Not IsNumber($nAngle) Then
		SetError(1)
		Return ""
	EndIf
	Return 1-Sin(_Angle($sFormat,"rad",$nAngle))
EndFunc

;=============================================================================
;
; Function Name:   _Exsec
;
; Description:     Returns the exsecant of an angle
;
; Syntax:          _Exsec($nAngle)
;
; Parameter(s);    $nAngle     = Angle
;                  $sFormat    = Format of the angle ("deg","rad","grad")
;
; Requirement(s):  External:   = None.
;                  Internal:   = _Angle.
;
; Return Value(s): Success: the exsecant of an angle
;                  Failure: Blank String
;                  @error : 0 - No Error
;                           1 - $nAngle is not a number
;
; Author(s):       Matthew McMullan (NerdFencer)
;
; Notes:           
;
; Example(s):      
;
;=============================================================================
Func _Exsec($nAngle,$sFormat="rad")
	If Not IsNumber($nAngle) Then
		SetError(1)
		Return ""
	EndIf
	Return (1/Cos(_Angle($sFormat,"rad",$nAngle)))-1
EndFunc

;=============================================================================
;
; Function Name:   _Excsc
;
; Description:     Returns the excosecant of an angle
;
; Syntax:          _Excsc($nAngle)
;
; Parameter(s);    $nAngle     = Angle
;                  $sFormat    = Format of the angle ("deg","rad","grad")
;
; Requirement(s):  External:   = None.
;                  Internal:   = _Angle.
;
; Return Value(s): Success: the excosecant of an angle
;                  Failure: Blank String
;                  @error : 0 - No Error
;                           1 - $nAngle is not a number
;
; Author(s):       Matthew McMullan (NerdFencer)
;
; Notes:           
;
; Example(s):      
;
;=============================================================================
Func _Excsc($nAngle,$sFormat="rad")
	If Not IsNumber($nAngle) Then
		SetError(1)
		Return ""
	EndIf
	Return (1/Sin(_Angle($sFormat,"rad",$nAngle)))-1
EndFunc

;=============================================================================
;
; Function Name:   _Haversin
;
; Description:     Returns the haversin of an angle
;
; Syntax:          _Haversin($nAngle)
;
; Parameter(s);    $nAngle     = Angle
;                  $sFormat    = Format of the angle ("deg","rad","grad")
;
; Requirement(s):  External:   = None.
;                  Internal:   = _Angle.
;
; Return Value(s): Success: the haversin of an angle
;                  Failure: Blank String
;                  @error : 0 - No Error
;                           1 - $nAngle is not a number
;
; Author(s):       Matthew McMullan (NerdFencer)
;
; Notes:           
;
; Example(s):      
;
;=============================================================================
Func _Haversin($nAngle,$sFormat="rad")
	If Not IsNumber($nAngle) Then
		SetError(1)
		Return ""
	EndIf
	Return (1-Cos(_Angle($sFormat,"rad",$nAngle)))/2
EndFunc

;=============================================================================
;
; Function Name:   _Hacoversin
;
; Description:     Returns the hacoversin of an angle
;
; Syntax:          _Hacoversin($nAngle)
;
; Parameter(s);    $nAngle     = Angle
;                  $sFormat    = Format of the angle ("deg","rad","grad")
;
; Requirement(s):  External:   = None.
;                  Internal:   = _Angle.
;
; Return Value(s): Success: the hacoversin of an angle
;                  Failure: Blank String
;                  @error : 0 - No Error
;                           1 - $nAngle is not a number
;
; Author(s):       Matthew McMullan (NerdFencer)
;
; Notes:           
;
; Example(s):      
;
;=============================================================================
Func _Hacoversin($nAngle,$sFormat="rad")
	If Not IsNumber($nAngle) Then
		SetError(1)
		Return ""
	EndIf
	Return (1-Sin(_Angle($sFormat,"rad",$nAngle)))/2
EndFunc

;=============================================================================
;
; Function Name:   _Sin
;
; Description:     Returns the sin of an angle
;
; Syntax:          _Sin($nAngle)
;
; Parameter(s);    $nAngle     = Angle
;                  $sFormat    = Format of the angle ("deg","rad","grad")
;
; Requirement(s):  External:   = None.
;                  Internal:   = _Angle.
;
; Return Value(s): Success: the sine of an angle
;                  Failure: Blank String
;                  @error : 0 - No Error
;                           1 - $nAngle is not a number
;
; Author(s):       Matthew McMullan (NerdFencer)
;
; Notes:           
;
; Example(s):      
;
;=============================================================================
Func _Sin($nAngle,$sFormat="rad")
	If Not IsNumber($nAngle) Then
		SetError(1)
		Return ""
	EndIf
	Return Sin(_Angle($sFormat,"rad",$nAngle))
EndFunc

;=============================================================================
;
; Function Name:   _Cos
;
; Description:     Returns the sin of an angle
;
; Syntax:          _Cos($nAngle)
;
; Parameter(s);    $nAngle     = Angle
;                  $sFormat    = Format of the angle ("deg","rad","grad")
;
; Requirement(s):  External:   = None.
;                  Internal:   = _Angle.
;
; Return Value(s): Success: the cosine of an angle
;                  Failure: Blank String
;                  @error : 0 - No Error
;                           1 - $nAngle is not a number
;
; Author(s):       Matthew McMullan (NerdFencer)
;
; Notes:           
;
; Example(s):      
;
;=============================================================================
Func _Cos($nAngle,$sFormat="rad")
	If Not IsNumber($nAngle) Then
		SetError(1)
		Return ""
	EndIf
	Return Cos(_Angle($sFormat,"rad",$nAngle))
EndFunc

;=============================================================================
;
; Function Name:   _Tan
;
; Description:     Returns the sin of an angle
;
; Syntax:          _Tan($nAngle)
;
; Parameter(s);    $nAngle     = Angle
;                  $sFormat    = Format of the angle ("deg","rad","grad")
;
; Requirement(s):  External:   = None.
;                  Internal:   = _Angle.
;
; Return Value(s): Success: the tangent of an angle
;                  Failure: Blank String
;                  @error : 0 - No Error
;                           1 - $nAngle is not a number
;
; Author(s):       Matthew McMullan (NerdFencer)
;
; Notes:           
;
; Example(s):      
;
;=============================================================================
Func _Tan($nAngle,$sFormat="rad")
	If Not IsNumber($nAngle) Then
		SetError(1)
		Return ""
	EndIf
	Return Tan(_Angle($sFormat,"rad",$nAngle))
EndFunc

;=============================================================================
;
; Function Name:   _Csc
;
; Description:     Returns the cosecant of an angle
;
; Syntax:          _Csc($nAngle)
;
; Parameter(s);    $nAngle     = Angle
;                  $sFormat    = Format of the angle ("deg","rad","grad")
;
; Requirement(s):  External:   = None.
;                  Internal:   = _Angle.
;
; Return Value(s): Success: the cosecant of an angle
;                  Failure: Blank String
;                  @error : 0 - No Error
;                           1 - $nAngle is not a number
;
; Author(s):       Matthew McMullan (NerdFencer)
;
; Notes:           
;
; Example(s):      
;
;=============================================================================
Func _Csc($nAngle,$sFormat="rad")
	If Not IsNumber($nAngle) Then
		SetError(1)
		Return ""
	EndIf
	Return 1/Sin(_Angle($sFormat,"rad",$nAngle))
EndFunc

;=============================================================================
;
; Function Name:   _Sec
;
; Description:     Returns the Secant of an angle
;
; Syntax:          _Sec($nAngle)
;
; Parameter(s);    $nAngle     = Angle
;                  $sFormat    = Format of the angle ("deg","rad","grad")
;
; Requirement(s):  External:   = None.
;                  Internal:   = _Angle.
;
; Return Value(s): Secant: the cosecant of an angle
;                  Failure: Blank String
;                  @error : 0 - No Error
;                           1 - $nAngle is not a number
;
; Author(s):       Matthew McMullan (NerdFencer)
;
; Notes:           
;
; Example(s):      
;
;=============================================================================
Func _Sec($nAngle,$sFormat="rad")
	If Not IsNumber($nAngle) Then
		SetError(1)
		Return ""
	EndIf
	Return 1/Cos(_Angle($sFormat,"rad",$nAngle))
EndFunc

;=============================================================================
;
; Function Name:   _Cot
;
; Description:     Returns the cotangent of an angle
;
; Syntax:          _cot($nAngle)
;
; Parameter(s);    $nAngle     = Angle
;                  $sFormat    = Format of the angle ("deg","rad","grad")
;
; Requirement(s):  External:   = None.
;                  Internal:   = _Angle.
;
; Return Value(s): Success: the cotangent of an angle
;                  Failure: Blank String
;                  @error : 0 - No Error
;                           1 - $nAngle is not a number
;
; Author(s):       Matthew McMullan (NerdFencer)
;
; Notes:           
;
; Example(s):      
;
;=============================================================================
Func _Cot($nAngle,$sFormat="rad")
	If Not IsNumber($nAngle) Then
		SetError(1)
		Return ""
	EndIf
	Return 1/Tan(_Angle($sFormat,"rad",$nAngle))
EndFunc

;=============================================================================
;
; Function Name:   _ASin
;
; Description:     Calculates the arcSine of a number
;
; Syntax:          _ASin( $nNumber )
;
; Parameter(s);    $nNumber    = The Sine of the angle in question
;                  $sFormat    = Format of the angle to retun ("deg","rad","grad")
;
; Requirement(s):  External:   = None.
;                  Internal:   = None.
;
; Return Value(s): Success: The angle
;                  Failure: Blank String
;                  @error : 0 - No Error
;                           1 - $nNumber is not a number
;
; Author(s):       Matthew McMullan (NerdFencer)
;
; Notes:           
;
; Example(s):      
;
;=============================================================================
Func _ASin($nNumber,$sFormat="rad")
	If Not IsNumber($nNumber) Then
		SetError(1)
		Return ""
	EndIf
	Return _Angle("rad",$sFormat,ASin($nNumber))
EndFunc

;=============================================================================
;
; Function Name:   _ACos
;
; Description:     Calculates the arcCosine of a number
;
; Syntax:          _ACos( $nNumber )
;
; Parameter(s);    $nNumber    = The Cosine of the angle in question
;                  $sFormat    = Format of the angle to retun ("deg","rad","grad")
;
; Requirement(s):  External:   = None.
;                  Internal:   = None.
;
; Return Value(s): Success: The angle
;                  Failure: Blank String
;                  @error : 0 - No Error
;                           1 - $nNumber is not a number
;
; Author(s):       Matthew McMullan (NerdFencer)
;
; Notes:           
;
; Example(s):      
;
;=============================================================================
Func _ACos($nNumber,$sFormat="rad")
	If Not IsNumber($nNumber) Then
		SetError(1)
		Return ""
	EndIf
	Return _Angle("rad",$sFormat,ACos($nNumber))
EndFunc

;=============================================================================
;
; Function Name:   _ATan
;
; Description:     Calculates the arcTangent of a number
;
; Syntax:          _ATan( $nNumber )
;
; Parameter(s);    $nNumber    = The Tangent of the angle in question
;                  $sFormat    = Format of the angle to retun ("deg","rad","grad")
;
; Requirement(s):  External:   = None.
;                  Internal:   = None.
;
; Return Value(s): Success: The angle
;                  Failure: Blank String
;                  @error : 0 - No Error
;                           1 - $nNumber is not a number
;
; Author(s):       Matthew McMullan (NerdFencer)
;
; Notes:           
;
; Example(s):      
;
;=============================================================================
Func _ATan($nNumber,$sFormat="rad")
	If Not IsNumber($nNumber) Then
		SetError(1)
		Return ""
	EndIf
	Return _Angle("rad",$sFormat,ATan($nNumber))
EndFunc

;=============================================================================
;
; Function Name:   _ASec
;
; Description:     Calculates the arcSecant of a number
;
; Syntax:          _ASec( $nNumber )
;
; Parameter(s);    $nNumber    = The Secant of the angle in question
;                  $sFormat    = Format of the angle to retun ("deg","rad","grad")
;
; Requirement(s):  External:   = None.
;                  Internal:   = None.
;
; Return Value(s): Success: The angle
;                  Failure: Blank String
;                  @error : 0 - No Error
;                           1 - $nNumber is not a number
;
; Author(s):       Matthew McMullan (NerdFencer)
;
; Notes:           
;
; Example(s):      
;
;=============================================================================
Func _ASec($nNumber,$sFormat="rad")
	If Not IsNumber($nNumber) Then
		SetError(1)
		Return ""
	EndIf
	Return _Angle("rad",$sFormat,ACos(1/$nNumber))
EndFunc

;=============================================================================
;
; Function Name:   _ACsc
;
; Description:     Calculates the arcCosecant of a number
;
; Syntax:          _ACsc( $nNumber )
;
; Parameter(s);    $nNumber    = The Cosecant of the angle in question
;                  $sFormat    = Format of the angle to retun ("deg","rad","grad")
;
; Requirement(s):  External:   = None.
;                  Internal:   = _Angle.
;
; Return Value(s): Success: The angle
;                  Failure: Blank String
;                  @error : 0 - No Error
;                           1 - $nNumber is not a number
;
; Author(s):       Matthew McMullan (NerdFencer)
;
; Notes:           
;
; Example(s):      
;
;=============================================================================
Func _ACsc($nNumber,$sFormat="rad")
	If Not IsNumber($nNumber) Then
		SetError(1)
		Return ""
	EndIf
	Return _Angle("rad",$sFormat,ASin(1/$nNumber))
EndFunc

;=============================================================================
;
; Function Name:   _ACot
;
; Description:     Calculates the arcCosecant of a number
;
; Syntax:          _ACot( $nNumber )
;
; Parameter(s);    $nNumber    = The Cotangent of the angle in question
;                  $sFormat    = Format of the angle to retun ("deg","rad","grad")
;
; Requirement(s):  External:   = None.
;                  Internal:   = _Angle.
;
; Return Value(s): Success: The angle
;                  Failure: Blank String
;                  @error : 0 - No Error
;                           1 - $nNumber is not a number
;
; Author(s):       Matthew McMullan (NerdFencer)
;
; Notes:           
;
; Example(s):      
;
;=============================================================================
Func _ACot($nNumber,$sFormat="rad")
	If Not IsNumber($nNumber) Then
		SetError(1)
		Return ""
	EndIf
	Return _Angle("rad",$sFormat,ATan(1/$nNumber))
EndFunc

;=============================================================================
;
; Function Name:   _Aversin
;
; Description:     Returns the arcVersin of an angle
;
; Syntax:          _AVersin($nNumber)
;
; Parameter(s);    $nNumber    = The Versin of the angle in question
;                  $sFormat    = Format of the angle to retun ("deg","rad","grad")
;
; Requirement(s):  External:   = None.
;                  Internal:   = _Angle.
;
; Return Value(s): Success: the angle
;                  Failure: Blank String
;                  @error : 0 - No Error
;                           1 - $nNumber is not a number
;
; Author(s):       Matthew McMullan (NerdFencer)
;
; Notes:           
;
; Example(s):      
;
;=============================================================================
Func _Aversin($nNumber,$sFormat="rad")
	If Not IsNumber($nNumber) Then
		SetError(1)
		Return ""
	EndIf
	Return _Angle("rad",$sFormat,ACos(-($nNumber-1)))
EndFunc

;=============================================================================
;
; Function Name:   _Acoversin
;
; Description:     Returns the arcCoversin of an angle
;
; Syntax:          _ACoversin($nAngle)
;
; Parameter(s);    $nNumber    = The Coversin of the angle in question
;                  $sFormat    = Format of the angle to retun ("deg","rad","grad")
;
; Requirement(s):  External:   = None.
;                  Internal:   = _Angle.
;
; Return Value(s): Success: the angle
;                  Failure: Blank String
;                  @error : 0 - No Error
;                           1 - $nNumber is not a number
;
; Author(s):       Matthew McMullan (NerdFencer)
;
; Notes:           
;
; Example(s):      
;
;=============================================================================
Func _ACoversin($nNumber,$sFormat="rad")
	If Not IsNumber($nNumber) Then
		SetError(1)
		Return ""
	EndIf
	Return _Angle("rad",$sFormat,ASin(-($nNumber-1)))
EndFunc

;=============================================================================
;
; Function Name:   _AExsec
;
; Description:     Returns the arcExsecant of an angle
;
; Syntax:          _AExsec($nAngle)
;
; Parameter(s);    $nNumber    = Exsec of the angle in question
;                  $sFormat    = Format of the angle to retun ("deg","rad","grad")
;
; Requirement(s):  External:   = None.
;                  Internal:   = _Angle.
;
; Return Value(s): Success: the angle
;                  Failure: Blank String
;                  @error : 0 - No Error
;                           1 - $nNumber is not a number
;
; Author(s):       Matthew McMullan (NerdFencer)
;
; Notes:           
;
; Example(s):      
;
;=============================================================================
Func _AExsec($nNumber,$sFormat="rad")
	If Not IsNumber($nNumber) Then
		SetError(1)
		Return ""
	EndIf
	Return _Angle("rad",$sFormat,ACos(1/(1+$nNumber)))
EndFunc

;=============================================================================
;
; Function Name:   _AExcsc
;
; Description:     Returns the arcExcosecant of an angle
;
; Syntax:          _AExcsc($nAngle)
;
; Parameter(s);    $nNumber    = the excsc of the angle in question
;                  $sFormat    = Format of the angle to retun ("deg","rad","grad")
;
; Requirement(s):  External:   = None.
;                  Internal:   = _Angle.
;
; Return Value(s): Success: the angle
;                  Failure: Blank String
;                  @error : 0 - No Error
;                           1 - $nNumber is not a number
;
; Author(s):       Matthew McMullan (NerdFencer)
;
; Notes:           
;
; Example(s):      
;
;=============================================================================
Func _AExcsc($nNumber,$sFormat="rad")
	If Not IsNumber($nNumber) Then
		SetError(1)
		Return ""
	EndIf
	Return _Angle("rad",$sFormat,ASin(1/($nNumber+1)))
EndFunc

;=============================================================================
;
; Function Name:   _AHaversin
;
; Description:     Returns the arcHaversin of an angle
;
; Syntax:          _AHaversin($nAngle)
;
; Parameter(s);    $nNumber     = the Haversin of the angle in question
;                  $sFormat    = Format of the angle to retun ("deg","rad","grad")
;
; Requirement(s):  External:   = None.
;                  Internal:   = _Angle.
;
; Return Value(s): Success: the angle
;                  Failure: Blank String
;                  @error : 0 - No Error
;                           1 - $nNumber is not a number
;
; Author(s):       Matthew McMullan (NerdFencer)
;
; Notes:           
;
; Example(s):      
;
;=============================================================================
Func _AHaversin($nNumber,$sFormat="rad")
	If Not IsNumber($nNumber) Then
		SetError(1)
		Return ""
	EndIf
	Return _Angle("rad",$sFormat,Cos(($nNumber*2)+1))
EndFunc

;=============================================================================
;
; Function Name:   _AHacoversin
;
; Description:     Returns the AHacoversin of an angle
;
; Syntax:          _AHacoversin($nAngle)
;
; Parameter(s);    $nNumber    = the Hacoversin of the angle in question
;                  $sFormat    = Format of the angle to retun ("deg","rad","grad")
;
; Requirement(s):  External:   = None.
;                  Internal:   = _Angle.
;
; Return Value(s): Success: the angle
;                  Failure: Blank String
;                  @error : 0 - No Error
;                           1 - $nNumber is not a number
;
; Author(s):       Matthew McMullan (NerdFencer)
;
; Notes:           
;
; Example(s):      
;
;=============================================================================
Func _AHacoversin($nNumber,$sFormat="rad")
	If Not IsNumber($nNumber) Then
		SetError(1)
		Return ""
	EndIf
	Return _Angle("rad",$sFormat,Sin(($nAngle*2)+1))
EndFunc