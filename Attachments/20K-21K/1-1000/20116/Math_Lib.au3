; #INDEX# ======================================================================
; Title .........: Math_Lib+
; AutoIt Version: 3.2.1++
; Language:       English
; Description ...: Provides several mathmatical functions
; Author ........: Matthew McMullan (NerdFencer)
; ==============================================================================

;===============================================================================
; #VARIABLES# ==================================================================
Global $n_e=2.7182818284590452353602874713526624977572470936999595749669676277240766
;===============================================================================

;===============================================================================
; #CURRENT# ====================================================================
;_Distance
;_Interest
;_csc
;_Sec
;_cot
;_csch
;_Sech
;_coth
;_sinh
;_cosh
;_tanh
;_mrt
;===============================================================================

;===============================================================================
;
; Function Name:    _Distance($n_Xone,$n_Yone,$n_Xtwo,$n_Ytwo)
; Description:      Finds the difference between two points.
; Parameter(s):     $n_Xone     - X coordinate of point 1
;                   $n_Yone 	- Y coordinate of point 1
;                   $n_Xtwo  	- X coordinate of point 2
;                   $n_Ytwo		- Y coordinate of point 2
; Requirement(s):   none
; Return Value(s):  On Success - Returns the distance between the two points
;                   On Failure - 0  and sets @ERROR
; Author(s):        Matthew McMullan
;
;===============================================================================
Func _Distance($n_Xone,$n_Yone,$n_Xtwo=0,$n_Ytwo=0)
	Return Sqrt(($n_Xtwo-$n_Xone)^2+($n_Ytwo-$n_Yone)^2)
EndFunc

;===============================================================================
;
; Function Name:    _Interest($n_Initial,$n_Rate,$n_Intervals,$n_Times_Per_Interval)
; Description:      Compound Interest
; Parameter(s):     $n_Initial				- Initial Value
;                   $n_Rate					- % Rate growth rate per interest cycle
;                   $n_Intervals			- X coordinate of point 2
;                   $n_Times_Per_Interval	- Y coordinate of point 2
; Requirement(s):   none
; Return Value(s):  Returns the Value after interes has been aplied
; Author(s):        Matthew McMullan
;
;===============================================================================
Func _Interest($n_Initial, $n_Rate, $n_Intervals, $n_Times_Per_Interval=1)
	Return $n_Initial*(1+$n_Rate/$n_Times_Per_Interval)^($n_Times_Per_Interval*$n_Intervals)
EndFunc

;===============================================================================
;
; Function Name:    _csc($n_Angle)
; Description:      Gives the Cosecant of an angle.
; Parameter(s):     $n_Angle     - The Angle
; Requirement(s):   none
; Return Value(s):  On Success - Returns the cosecant of an angle
;                   On Failure - 0  and sets @ERROR
; Author(s):        Matthew McMullan
;
;===============================================================================
Func _csc($n_Angle)
	Return 1/Sin($n_Angle)
EndFunc

;===============================================================================
;
; Function Name:    _sec($n_Angle)
; Description:      Gives the Secant of an angle.
; Parameter(s):     $n_Angle     - The Angle
; Requirement(s):   none
; Return Value(s):  On Success - Returns the Secant of an angle
;                   On Failure - 0  and sets @ERROR
; Author(s):        Matthew McMullan
;
;===============================================================================
Func _sec($n_Angle)
	Return 1/Cos($n_Angle)
EndFunc

;===============================================================================
;
; Function Name:    _cot($n_Angle)
; Description:      Gives the Cotangent of an angle.
; Parameter(s):     $n_Angle     - The Angle
; Requirement(s):   none
; Return Value(s):  On Success - Returns the cotangent of an angle
;                   On Failure - 0  and sets @ERROR
; Author(s):        Matthew McMullan
;
;===============================================================================
Func _cot($n_Angle)
	Return 1/Tan($n_Angle)
EndFunc

;===============================================================================
;
; Function Name:    _cosh($n_Angle)
; Description:      Gives the hyperbolic cosine of an angle.
; Parameter(s):     $n_Angle     - The Angle
; Requirement(s):   none
; Return Value(s):  On Success - Returns the hyperbolic cosine of an angle
;                   On Failure - 0  and sets @ERROR
; Author(s):        Matthew McMullan
;
;===============================================================================
Func _cosh($n_Angle)
	Return ($n_e^$n_Angle+$n_e^(-$n_e))/2
EndFunc

;===============================================================================
;
; Function Name:    _sinh($n_Angle)
; Description:      Gives the hyperbolic sine of an angle.
; Parameter(s):     $n_Angle     - The Angle
; Requirement(s):   none
; Return Value(s):  On Success - Returns the hyperbolic sine of an angle
;                   On Failure - 0  and sets @ERROR
; Author(s):        Matthew McMullan
;
;===============================================================================
Func _sinh($n_Angle)
	Return ($n_e^$n_Angle-$n_e^(-$n_e))/2
EndFunc

;===============================================================================
;
; Function Name:    _tanh($n_Angle)
; Description:      Gives the hyperbolic cosine of an angle.
; Parameter(s):     $n_Angle     - The Angle
; Requirement(s):   none
; Return Value(s):  On Success - Returns the hyperbolic tangent of an angle
;                   On Failure - 0  and sets @ERROR
; Author(s):        Matthew McMullan
;
;===============================================================================
Func _tanh($n_Angle)
	Return ($n_e^$n_Angle-$n_e^(-$n_e))/($n_e^$n_Angle+$n_e^(-$n_e))
EndFunc

;===============================================================================
;
; Function Name:    _sech($n_Angle)
; Description:      Gives the hyperbolic secant of an angle.
; Parameter(s):     $n_Angle     - The Angle
; Requirement(s):   none
; Return Value(s):  On Success - Returns the hyperbolic secant of an angle
;                   On Failure - 0  and sets @ERROR
; Author(s):        Matthew McMullan
;
;===============================================================================
Func _sech($n_Angle)
	Return 2/($n_e^$n_Angle+$n_e^(-$n_e))
EndFunc

;===============================================================================
;
; Function Name:    _csch($n_Angle)
; Description:      Gives the hyperbolic cosecant of an angle.
; Parameter(s):     $n_Angle     - The Angle
; Requirement(s):   none
; Return Value(s):  On Success - Returns the hyperbolic cosecant of an angle
;                   On Failure - 0  and sets @ERROR
; Author(s):        Matthew McMullan
;
;===============================================================================
Func _csch($n_Angle)
	Return 2/($n_e^$n_Angle-$n_e^(-$n_e))
EndFunc

;===============================================================================
;
; Function Name:    _coth($n_Angle)
; Description:      Gives the hyperbolic cosine of an angle.
; Parameter(s):     $n_Angle     - The Angle
; Requirement(s):   none
; Return Value(s):  On Success - Returns the hyperbolic tangent of an angle
;                   On Failure - 0  and sets @ERROR
; Author(s):        Matthew McMullan
;
;===============================================================================
Func _coth($n_Angle)
	Return ($n_e^$n_Angle+$n_e^(-$n_e))/($n_e^$n_Angle-$n_e^(-$n_e))
EndFunc

;===============================================================================
;
; Function Name:    _mrt($n_Number,$n_M)
; Description:      Gives the m root of a Nummber.
; Parameter(s):     $n_Number   - The Number
;					$n_M		- The root
; Requirement(s):   none
; Return Value(s):  On Success - Returns the m root of a Number
;                   On Failure - 0  and sets @ERROR
; Author(s):        Matthew McMullan
;
;===============================================================================
Func _mrt($n_Number, $n_M=2)
	Return $n_Number^(1/$n_M)
EndFunc