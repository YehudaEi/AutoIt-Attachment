;=====================================================
; AComplex - 20 July 2010 by Valery Ivanov
; The sample of AutoItObject using for Complex Number Math Lib
; 20 July 2010 by Valery Ivanov
;------------------------------
#include <AutoItObject.au3>
_AutoItObject_StartUp()

;===========================
; Complex Math Lib
;===========================
;New complex is equal to negative of $oA
Func _CMin($oA)
local $oB = _ComplexCreator()
  $oB.Re = -$oA.Re
  $oB.Im = -$oA.Im
  Return $oB
EndFunc ;==>_CMin
;------------------------------
;New complex is equal to $oA + $oB
Func _CAdd($oA, $oB)
local $oC = _ComplexCreator()
  $oC.Re = $oA.Re + $oB.Re
  $oC.Im = $oA.Im + $oB.Im
  Return $oC
EndFunc ;==>_CAdd
;------------------------------
;New complex is equal to $oA - $oB
Func _CSub($oA, $oB)
local $oC = _ComplexCreator()
  $oC.Re = $oA.Re - $oB.Re
  $oC.Im = $oA.Im - $oB.Im
  Return $oC
EndFunc ;==>_CSub
;------------------------------
;New complex is equal to $oA * $oB
Func _CMul($oA, $oB)
local $oC = _ComplexCreator()
  $oC.Re = $oA.Re*$oB.Re - $oA.Im*$oB.Im
  $oC.Im = $oA.Re*$oB.Im + $oA.Im*$oB.Re
  Return $oC
EndFunc ;==>_CMul
;------------------------------
;New complex is equal to $oA / $oB
Func _CDiv($oA, $oB)
local $oC = _ComplexCreator()
  $oC.Re = ($oA.Re*$oB.Re + $oA.Im*$oB.Im)/($oB.CAbsSqr());
  $oC.Im = ($oA.Im*$oB.Re - $oA.Re * $oB.Im)/($oB.CAbsSqr());
  Return $oC
EndFunc ;==>_CDiv
;------------------------------
;New complex is equal to exp($oA)
Func _CExp($oA)
local $oB = _ComplexCreator()
  $oB.Re = Exp($oA.Re) * Cos($oA.Im)
  $oB.Im = Exp($oA.Re) * Sin($oA.Im)
  Return $oB
EndFunc ;==>_CExp
;------------------------------
;New complex is equal to natural logarithm of $oA
Func _CLog($oA)
local $oB = _ComplexCreator()
     $oB.Re = Log($oA.CAbs())
     $oB.Im = $oA.CArg()
  Return $oB
EndFunc ;==>_CLog
;------------------------------
;New complex is equal to result of raising comples to the complex power
Func _CPow($oA,$oB)
local $oC1, $oC2, $oC3
     $oC1 = _CLog($oA)
     $oC2 = _CMul($oB,$oC1)
     $oC3 = _CExp($oC2)
     $oC1 = 0
     $oC2 = 0
     return $oC3
EndFunc ;==>_CPow
;------------------------------
;New complex is equal to complex squared
Func _CSqr($oA)
local $oB
     $oB = _CMul($oA,$oA);
  Return $oB
EndFunc ;==>_CSqr
;------------------------------
;New complex is equal to logarithmic base $oA of $oB
Func _CLogB($oA,$oB)
local $oC1, $oC2, $oC3
     $oC1 = _CLog($oA);
     $oC2 = _CLog($oB);
     $oC3 = _CDiv($oC1,$oC2);
     $oC1 = 0
     $oC2 = 0
     return $oC3
EndFunc ;==>_CPow
;------------------------------
;New complex is equal to $oAth root of $oB
Func _CRt($oA,$oB)
local $oC1 = _ComplexCreator()
local $oC2, $oC3
     $oC2 = _CDiv($oC1,$oA);
     $oC3 = _CPow($oB,$oC2);
     $oC1 = 0
     $oC2 = 0
     return $oC3
EndFunc ;==>_CPow
;------------------------------
;New complex is equal to square root of $oA
Func _CSqrt($oA)
local $oC1 = _ComplexCreator(2,0)
local $oC2, $oC3
     $oC2 = _CRt($oC1,$oA);
     $oC1 = 0
     return $oC2
EndFunc ;==>_CSqrt
;------------------------------
;New complex is equal to sine of $oA
Func _CSin($oA)
local $oC1 = _ComplexCreator()
local $oC2, $oC3
     $oC2 = _CMul($oC1,$oA);
     $oC3 = _CExp($oC2)
     $oC4 = _CExp($oC2.CMin())
     $oC1 = _CSub($oC3,$oC4)
     $oC3 = 0
     $oC4 = 0
     $oC2 = 0
     $oC2 = _ComplexCreator(0,2)
     $oC3 = _CDiv($oC1,$oC2)
     $oC1 = 0
     $oC2 = 0
     return $oC3
EndFunc ;==>_CSin
;------------------------------
;New complex is equal to cosine of $oA
Func _CCos($oA)
local $oC1 = _ComplexCreator()
local $oC2, $oC3
local $oC2, $oC3
     $oC2 = _CMul($oC1,$oA);
     $oC3 = _CExp($oC2)
     $oC4 = _CExp($oC2.CMin())
     $oC1 = _CAdd($oC3,$oC4)
     $oC3 = 0
     $oC4 = 0
     $oC2 = 0
     $oC2 = _ComplexCreator(2,0)
     $oC3 = _CDiv($oC1,$oC2)
     $oC1 = 0
     $oC2 = 0
     return $oC3
EndFunc ;==>_CCos
;------------------------------
;New complex is equal to tangent of $oA
Func _CTan($oA)
local $oC1, $oC2, $oC3
     $oC1 = _CSin($oA)
     $oC2 = _CCos($oA)
     $oC3 = CDiv($oC1,$oC2)
     $oC1 = 0
     $oC2 = 0
     return $oC3
EndFunc ;==>_CTan
;------------------------------
;New complex is equal to tangent of $oA
Func _CCot($oA)
local $oC1, $oC2, $oC3
     $oC1 = _CSin($oA)
     $oC2 = _CCos($oA)
     $oC3 = CDiv($oC2,$oC1)
     $oC1 = 0
     $oC2 = 0
     return $oC3
EndFunc ;==>_CCot
;------------------------------
;New complex is equal to secant of $oA
Func _CSec($oA)
local $oC1 = _ComplexCreator(1,0)
local $oC2, $oC3
     $oC2 = _CCos($oA)
     $oC3 = CDiv($oC1,$oC2)
     $oC1 = 0
     $oC2 = 0
     return $oC3
EndFunc ;==>_CSec
;------------------------------
;New complex is equal to cosecant of $oA
Func _CCsc($oA)
local $oC1 = _ComplexCreator(1,0)
local $oC2, $oC3
     $oC2 = _CSin($oA)
     $oC3 = CDiv($oC1,$oC2)
     $oC1 = 0
     $oC2 = 0
     return $oC3
EndFunc ;==>_CCsc
;------------------------------
;New complex is equal to arcsine of $oA
Func _CASin($oA)
local $oC1 = _ComplexCreator()
local $oC2 = _ComplexCreator(1,0)
local $oC3 = _CMul($oC1,$oA)
local $oC4 = _CSqr($oA)
local $oC5 = _CSub($oC2,$oC4)
local $oC6 = _CSqrt($oC5)
local $oC7 = _CAdd($oC3,$oC6)
local $oC8 = _CLog($oC7)
local $oC9 = _CDiv($oC8,$oC1)
     $oC1 = 0
     $oC2 = 0
     $oC3 = 0
     $oC4 = 0
     $oC5 = 0
     $oC6 = 0
     $oC7 = 0
     $oC8 = 0
     return $oC9
EndFunc ;==>_CASin
;------------------------------
;New complex is equal to arccosine of $oA
Func _CACos($oA)
local $oC1 = _ComplexCreator()
local $oC2 = _ComplexCreator(1,0)
local $oC3 = _CSqr($oA)
local $oC4 = _CSub($oC3,$oC2)
local $oC5 = _CSqrt($oC4)
local $oC6 = _CAdd($oA,$oC5)
local $oC7 = _CLog($oC6)
local $oC8 = _CDiv($oC7,$oC1)
     $oC1 = 0
     $oC2 = 0
     $oC3 = 0
     $oC4 = 0
     $oC5 = 0
     $oC6 = 0
     $oC7 = 0
     return $oC8
EndFunc ;==>_CACos
;------------------------------
;New complex is equal to arctangent of $oA
Func _CATan($oA)
local $oC1 = _ComplexCreator(1,0)
local $oC2 = _ComplexCreator(0,2)
local $oC3 = _CDiv($oC1,$oC2)
     $oC2 = 0
     $oC2 = _CMin($oC1)
local $oC4 = _CMul($oC1,$oA)
local $oC5 = _CSub($oC2,$oC4)
local $oC6 = _CSub($oC4,$oC1)
local $oC7 = _CDiv($oC5,$oC6)
local $oC8 = _CLn($oC7)
local $oC9 = _CMul($oC3,$oC8)
     $oC1 = 0
     $oC2 = 0
     $oC3 = 0
     $oC4 = 0
     $oC5 = 0
     $oC6 = 0
     $oC7 = 0
     $oC8 = 0
     return $oC9
EndFunc ;==>_CATan
;------------------------------
;New complex is equal to arccotangent of $oA
Func _CACot($oA)
local $oC1 = _ComplexCreator(1,0)
local $oC2 = _CDiv($oC1,$oA)
local $oC3 = _CATan($oC2)
     $oC1 = 0
     $oC2 = 0
     return $oC3
EndFunc ;==>_CACot
;------------------------------
;New complex is equal to arcsecant of $oA
Func _CASec($oA)
local $oC1 = _ComplexCreator(1,0)
local $oC2 = _CDiv($oC1,$oA)
local $oC3 = _CACos($oC2)
     $oC1 = 0
     $oC2 = 0
     return $oC3
EndFunc ;==>_CASec
;------------------------------
;New complex is equal to arccosecant of $oA
Func _CACsc($oA)
local $oC1 = _ComplexCreator(1,0)
local $oC2 = _CDiv($oC1,$oA)
local $oC3 = _CASin($oC2)
     $oC1 = 0
     $oC2 = 0
     return $oC3
EndFunc ;==>_CACsc
;------------------------------
;New complex is equal to hyperbolic sine of $oA
Func _CSinh($oA)
local $oC1 = _CMin($oA)
local $oC2 = _CExp($oA)
local $oC3 = _CExp($oC1)
local $oC4 = _CSub($oC2,$oC3)
local $oC5 = _ComplexCreator(2,0)
local $oC6 = _CDiv($oC4,$oC5)
     $oC1 = 0
     $oC2 = 0
     $oC3 = 0
     $oC4 = 0
     $oC5 = 0
     return $oC6
EndFunc ;==>_CSinh
;------------------------------
;New complex is equal to hyperbolic cosine of $oA
Func _CCosh($oA)
local $oC1 = _CMin($oA)
local $oC2 = _CExp($oA)
local $oC3 = _CExp($oC1)
local $oC4 = _CAdd($oC2,$oC3)
local $oC5 = _ComplexCreator(2,0)
local $oC6 = _CDiv($oC4,$oC5)
     $oC1 = 0
     $oC2 = 0
     $oC3 = 0
     $oC4 = 0
     $oC5 = 0
     return $oC6
EndFunc ;==>_CCosh
;------------------------------
;New complex is equal to hyperbolic tangent of $oA
Func _CTanh($oA)
local $oC1 = _CSinh($oA)
local $oC2 = _CCosh($oA)
local $oC3 = _CDiv($oC1,$oC2)
     $oC1 = 0
     $oC2 = 0
     return $oC3
EndFunc ;==>_CTanh
;------------------------------
;New complex is equal to hyperbolic cotangent of $oA
Func _CCoth($oA)
local $oC1 = _CSinh($oA)
local $oC2 = _CCosh($oA)
local $oC3 = _CDiv($oC2,$oC1)
     $oC1 = 0
     $oC2 = 0
     return $oC3
EndFunc ;==>_CCoth
;------------------------------
;New complex is equal to hyperbolic secant of $oA
Func _CSech($oA)
local $oC1 = _ComplexCreator(1,0)
local $oC2 = _CCosh($oA)
local $oC3 = _CDiv($oC1,$oC2)
     $oC1 = 0
     $oC2 = 0
     return $oC3
EndFunc ;==>_CCoth
;------------------------------
;New complex is equal to hyperbolic cosecant of $oA
Func _CCSch($oA)
local $oC1 = _ComplexCreator(1,0)
local $oC2 = _CSinh($oA)
local $oC3 = _CDiv($oC1,$oC2)
     $oC1 = 0
     $oC2 = 0
     return $oC3
EndFunc ;==>_CCSch
;------------------------------
;New complex is equal to arcsine hyperbolic of $oA
Func _CASinh($oA)
local $oC1 = _ComplexCreator(1,0)
local $oC2 = _CSqr($oA)
local $oC3 = _CAdd($oC2,$oC1)
local $oC4 = _CSqrt($oC3)
local $oC5 = _CAdd($oA,$oC4)
local $oC6 = _CLog($oC5)
     $oC1 = 0
     $oC2 = 0
     $oC3 = 0
     $oC4 = 0
     $oC5 = 0
     return $oC6
EndFunc ;==>_CASinh
;------------------------------
;New complex is equal to arccosine hyperbolic of $oA
Func _CACosh($oA)
local $oC1 = _ComplexCreator(1,0)
local $oC2 = _CSqr($oA)
local $oC3 = _CSub($oC2,$oC1)
local $oC4 = _CSqrt($oC3)
local $oC5 = _CAdd($oA,$oC4)
local $oC6 = _CLog($oC5)
     $oC1 = 0
     $oC2 = 0
     $oC3 = 0
     $oC4 = 0
     $oC5 = 0
     return $oC6
EndFunc ;==>_CACosh
;------------------------------
;New complex is equal to arctangent hyperbolic of $oA
Func _CATanh($oA)
local $oC1 = _ComplexCreator(1,0)
local $oC2 = _CMin($oA)
local $oC3 = _CSub($oC2,$oC1)
local $oC4 = _CSub($oA,$oC1)
local $oC5 = _CDiv($oC3,$oC4)
local $oC6 = _CLog($oC5)
local $oC7 = _ComplexCreator(2,0)
local $oC8 = _CDiv($oC6,$oC7)
     $oC1 = 0
     $oC2 = 0
     $oC3 = 0
     $oC4 = 0
     $oC5 = 0
     $oC6 = 0
     $oC7 = 0
     return $oC8
EndFunc ;==>_CATanh
;------------------------------
;New complex is equal to arccotangent hyperbolic of $oA
Func _CACoth($oA)
local $oC1 = _ComplexCreator(1,0)
local $oC2 = _CDiv($oC1,$oA)
local $oC3 = _CATanh($oC2)
     $oC1 = 0
     $oC2 = 0
     return $oC3
EndFunc ;==>_CACoth
;------------------------------
;New complex is equal to arcsecant hyperbolic of $oA
Func _CASech($oA)
local $oC1 = _ComplexCreator(1,0)
local $oC2 = _CDiv($oC1,$oA)
local $oC3 = _CACosh($oC2)
     $oC1 = 0
     $oC2 = 0
     return $oC3
EndFunc ;==>_CASech
;------------------------------
;New complex is equal to arcsecant hyperbolic of $oA
Func _CACsch($oA)
local $oC1 = _ComplexCreator(1,0)
local $oC2 = _CDiv($oC1,$oA)
local $oC3 = _CASinh($oC2)
     $oC1 = 0
     $oC2 = 0
     return $oC3
EndFunc ;==>_CACsch

;===========================
; Complex Number Class 
;===========================
Func _ComplexCreator($Re = 0, $Im = -1)
Local $oComplexObject = _AutoItObject_Class()
    $oComplexObject.Create()
    $oComplexObject.AddProperty("Re", $ELSCOPE_PUBLIC, $Re)
    $oComplexObject.AddProperty("Im", $ELSCOPE_PUBLIC, $Im)

    $oComplexObject.AddMethod("CAbs", "_CAbs")
    $oComplexObject.AddMethod("CAbsSqr", "_CAbsSqr")
    $oComplexObject.AddMethod("CArg", "_CArg")
    $oComplexObject.AddMethod("CConj", "_CConj")

    Return $oComplexObject.Object
EndFunc ;==> _ComplexCreator

;===========================
;Absolute value of complex
Func _CAbs($oSelf)
local $Re, $Im
  $Re = $oSelf.Re
  $Im = $oSelf.Im
  Return Sqrt($Re^2 + $Im^2)
EndFunc ;==>_CAbs

;===========================
;Absolute value of complex squared
Func _CAbsSqr($oSelf)
local $Re, $Im
  $Re = $oSelf.Re
  $Im = $oSelf.Im
  Return ($Re^2 + $Im^2)
EndFunc ;==>_CAbsSqr

;===========================
;Argument of complex
Func _CArg($oSelf)
local $Pi = 3.14159
local $Re, $Im
  $Re = $oSelf.Re
  $Im = $oSelf.Im
  if $Re > 0 then
    if $Im <> 0 then return ATan($Im/$Re)
    return 0
  endif 
  if $Re < 0 then
    if $Im > 0 then return ATan($Im/$Re) + $Pi;
    if $Im < 0 then return ATan($Im/$Re) - $Pi;
    return $Pi
  endif 
  if $Im > 0 then return $Pi/2;
  if $Im < 0 then return -$Pi/2;
  return SetError(2) ;indeterminate form 0/0
EndFunc ;==>_CArg

;===========================
;Complex conjugate of complex
Func _CConj($oSelf)
local $Im
  $Im = $oSelf.Im
  $oSelf.Im = -$Im
EndFunc ;==>_CAbsSqr



