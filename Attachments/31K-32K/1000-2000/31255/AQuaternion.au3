;=====================================================
; AQuaternion - 20 July 2010 by Valery Ivanov
; See about Quaternion on 
;  http://en.wikipedia.org/wiki/Quaternion
; The sample of AutoItObject using for Quaternion Math Lib
; 20 July 2010 by Valery Ivanov
;------------------------------
#include <AutoItObject.au3>
_AutoItObject_StartUp()

;===========================
; Quaternion Math Lib
;===========================
;New quaternion is equal to opposite quaternion of $oA
Func _HOpp($oA)
local $oH = _QuaternionCreator()
  $oH.x = - $oA.x
  $oH.y = - $oA.y
  $oH.z = - $oA.z
  $oH.w = - $oA.w
  Return $oH
EndFunc ;==>_HOpp
;------------------------------
;New quaternion is equal to reciprocal quaternion of $oA
Func _HRec($oA)
local $oH = _QuaternionCreator()
local $T = 1/$oA.HAbsSqr()
  $oH.x = - $T*$oA.x
  $oH.y = - $T*$oA.y
  $oH.z = - $T*$oA.z
  $oH.w = - $T*$oA.w
  Return $oH
EndFunc ;==>_HRec
;------------------------------
;New quaternion is equal to $oA + $oB
Func _HAdd($oA, $oB)
local $oH = _QuaternionCreator()
  $oH.x = $oA.x + $oB.x
  $oH.y = $oA.y + $oB.y
  $oH.z = $oA.z + $oB.z
  $oH.w = $oA.w + $oB.w
  Return $oH
EndFunc ;==>_HAdd
;------------------------------
;New quaternion is equal to $oA - $oB
Func _HSub($oA, $oB)
local $oH = _QuaternionCreator()
  $oH.x = $oA.x - $oB.x
  $oH.y = $oA.y - $oB.y
  $oH.z = $oA.z - $oB.z
  $oH.w = $oA.w - $oB.w
  Return $oH
EndFunc ;==>_HSub
;------------------------------
;New quaternion is equal to $oA * $oB
Func _HMul($oA, $oB)
local $oH = _QuaternionCreator()
  $oH.x = + $oA.x*$oB.w + $oA.y*$oB.z - $oA.z*$oB.y + $oA.w*$oB.x
  $oH.y = - $oA.x*$oB.z + $oA.y*$oB.w + $oA.z*$oB.x + $oA.w*$oB.y 
  $oH.z = + $oA.x*$oB.y - $oA.y*$oB.x + $oA.z*$oB.w + $oA.w*$oB.z
  $oH.w = - $oA.x*$oB.x - $oA.y*$oB.y - $oA.z*$oB.z + $oA.w*$oB.w
  Return $oH
EndFunc ;==>_HMul
;------------------------------
;New quaternion is equal to quaternion squared
Func _HSqr($oA)
local $oH = _HMul($oA,$oA);
  Return $oH
EndFunc ;==>_HSqr
;------------------------------
;New quaternion is equal to $oA / $oB
;It is equal to product of $oA  and reciprocal $oB
Func _HDiv($oA, $oB)
local $oR = _HRec($oB)
local $oH = _HMul($oA, $oR)
  $oR = 0
  Return $oH
EndFunc ;==>_HDiv

;===========================
; Quaternion Class 
;===========================
;The sum of two elements of H is defined to be their sum as elements of R4. 
;The product of an element of H by a real number is defined to be the same as the product in R4. 
;To define the product of two elements in H requires a choice of basis for R4. 
;The elements of this basis are customarily denoted as 1, i, j, and k. 
;Every element of H can be uniquely written as a linear combination of these basis elements, 
;that is, as xi + yj + zk + w, where x, y, z, and w are real numbers. 
;Hamilton called pure imaginary quaternion right quaternion 
;and real number (quaternion with zero vector part) scalar quaternion.
Func _QuaternionCreator($x = -1, $y = -1, $z = -1, $w = 0)
Local $oComplexObject = _AutoItObject_Class()
    $oQuaternionObject.Create()
    $oQuaternionObject.AddProperty("x", $ELSCOPE_PUBLIC, $x)
    $oQuaternionObject.AddProperty("y", $ELSCOPE_PUBLIC, $y)
    $oQuaternionObject.AddProperty("x", $ELSCOPE_PUBLIC, $z)
    $oQuaternionObject.AddProperty("w", $ELSCOPE_PUBLIC, $w)

    $oQuaternionObject.AddMethod("HAbs", "_HAbs")
    $oQuaternionObject.AddMethod("HAbsSqr", "_HAbsSqr")
    $oQuaternionObject.AddMethod("HConj", "_HConj")

    Return $oQuaternionObject.Object
EndFunc ;==> _QuaternionCreator

;===========================
;Value of quaternion norm 
Func _HAbs($oSelf)
local $x, $y, $z, $w
  $x = $oSelf.x
  $y = $oSelf.y
  $z = $oSelf.z
  $w = $oSelf.w
  Return Sqrt($x^2 + $y^2 + $z^2 + $w^2)
EndFunc ;==>_HAbs

;===========================
;Absolute value of quaternion squared
Func _HAbsSqr($oSelf)
local $x, $y, $z, $w
  $x = $oSelf.x
  $y = $oSelf.y
  $z = $oSelf.z
  $w = $oSelf.w
  Return ($x^2 + $y^2 + $z^2 + $w^2)
EndFunc ;==>_HAbsSqr

;===========================
;Conjugation of quaternion 
Func _HConj($oSelf)
local $x, $y, $z
  $x = $oSelf.x
  $y = $oSelf.y
  $z = $oSelf.z
  $oSelf.x = -$x
  $oSelf.y = -$y
  $oSelf.z = -$z
EndFunc ;==>_HAbsSqr
