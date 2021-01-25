#include-once
#include <Array.au3>
;#include "misc.au3"
;#include "Step 1.au3"
;#include "Step 2.au3"

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Const $equation1 = "x^2+y-19" ;First Equation, without =0 bit
Const $equation2 = "xy-12";Second Equation, without =0 bit
Const $variable = "x";Variable to eliminate
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


$d1 = _PolyDeg($equation1,$variable)
MsgBox(64,"First degree",$d1)
$d2 = _PolyDeg($equation2,$variable)
MsgBox(64,"Second degree",$d2)
$cs1 = _PolyCoeff($equation1,$variable,String($d1))
_ArrayDisplay($cs1,"Coefficients in 1")
$cs2 = _PolyCoeff($equation2,$variable,String($d2))
_ArrayDisplay($cs2,"Coefficients in 2")
$sylv = _Sylvester($cs1,$cs2)
_ArrayDisplay($sylv,"Sylvester Matrix")

MsgBox(64,"Determinant (=0)", _Det($sylv))

#region misc.au3
Func _ExpSplit($str)
	;If Not IsString($str) Then Return $str
	
	;Strip out the variables
	$r = StringRegExp($str,'[a-z]\^{0,}[0-9]{0,}',3)
	
	;If there are no variables, it is only a number
	If @error Then
		Dim $r[2]
		$r[0] = 1
		$r[1] = _C2Number($str)
		Return $r
	EndIf
	
	;Get the coefficient out from before the first variable
	$c = StringMid($str,1,StringInStr($str,$r[0])-1)
	_ArrayInsert($r,0,$c)
	
	;Sort for good measure and add in the number of parts
	_ArraySort($r)
	$iUbound = UBound($r)
	_ArrayInsert($r,0,$iUbound)
	
	Return $r
EndFunc

Func _ExpTidy($str)
	;If Not IsString($str) Then Return $str
		
	$iParts = _ExpSplit($str)
	
	;Initialize the string with the coefficient
	$tidy = $iParts[1]
	
	;Initialize the counters
	$startvar = "" ;The expression variable
	$t_power = 0   ;The power to which it is raised
	
	;For each part in turn
	For $n = 2 To $iParts[0]
		
		;Collect the variable
		$var = StringRegExp($iParts[$n],"[a-z]",1)
		$var = $var[0]
		
		Switch $var
		;If it's the same:
		Case $startvar
			;Add indices
			$i = StringSplit($iParts[$n],"^")
			If @error = 1 Then
				$power = 1
			Else
				$power = _C2Number($i[2])
			EndIf
			$t_power = _CalculateFract($t_power,$power,"+")
			
		;If it's not:
		Case Else
			;Terminate use of this variable
			If $startvar <> "" Then
				If _C2Number($t_power) = 1 Then
					$tidy = $tidy & $startvar
				Else
					$tidy = $tidy & $startvar & "^" & $t_power
				EndIf
			EndIf
			
			;Re-initialize
			$startvar = $var
			$t_power = 0
			
			$i = StringSplit($iParts[$n],"^")
			If @error = 1 Then
				$power = 1
			Else
				$power = _C2Number($i[2])
			EndIf
			$t_power = _CalculateFract($t_power,$power,"+")
		EndSwitch
	Next
	
	;Add in the last variable found
	If $startvar <> "" Then
		If _C2Number($t_power) = 1 Then
			$tidy = $tidy & $startvar
		Else
			$tidy = $tidy & $startvar & "^" & $t_power
		EndIf
	EndIf
	
	;Shove it back to the caller
	Return $tidy
EndFunc

Func _pSplit($poly)
	;If Not IsString($poly) Then Return $poly
	
	;Strip out each subsequent term
	$r = StringRegExp($poly,'[+-][0-9]*(?:\.[0-9]*)*(?:[a-z]\^{0,1}[0-9]*)*',3)
	
	;If there are no terms starting with + or -, there can only be one (+ve)
	If @error = 1 Then
		Dim $r[2]
		$r[0] = 1
		$r[1] = $poly
		Return $r
	EndIf
	
	;Add in the bit before the first +/-
	$c = StringMid($poly,1,StringInStr($poly,$r[0])-1)
	
	;However, if first term is -ve this evaluates to "" so we don't need it
	If Not $c = "" Then _ArrayInsert($r,0,$c)
	
	_ArraySort($r)
	
	;Have a nice day
	$iUbound = UBound($r)
	_ArrayInsert($r,0,$iUbound)
	Return $r
EndFunc

Func _pTidy($poly)
	;If Not IsString($poly) Then Return $poly
	$poly = StringReplace($poly,"+-","-")
	While StringMid($poly,1,1) = "+"
		$poly = StringMid($poly,2)
	WEnd
	
	;First split the coefficients from the variables
	$parts = _pSplit($poly)
	Dim $newAr[$parts[0]+1][2]
	For $i = 1 To $parts[0]
		$iexp = _ExpSplit($parts[$i])
		$newAr[$i][0] = _C2Number($iexp[1])
		$newAr[$i][1] = _ExpTidy(_ArrayToString($iexp,"",2))
	Next
	
	;So they can be sorted into matching groups
	_ArraySort($newAr,0,1,0,1)
	
	;Then add the coefficients back on
	Dim $exps[$parts[0]+1]
	$exps[0] = $parts[0]
	For $i = 1 To $parts[0]
		If _C2Number($newAr[$i][0]) = 1 Then $newAr[$i][0] = ""
		If _C2Number($newAr[$i][1]) = 1 Then $newAr[$i][1] = ""
		$exps[$i] = $newAr[$i][0] & $newAr[$i][1]
	Next	
	
	
	$newAr = "" ;Delete the 2d array for space
	
	;Initialize the counters
	$startvar = _ExpSplit($exps[1])
	$startvar = _ArrayToString($startvar,"",2)
	$t_coeff = 0
	$r = ""
	
	;For each expression
	For $i = 1 To $exps[0]
		$exps[$i] = _ExpTidy($exps[$i]) ;Tidy it up (not really needed)
		$var = _ExpSplit($exps[$i])
		$coeff = _C2Number($var[1])	;Get the coefficient
		$var = _ArrayToString($var,"",2) ;And the variable String
		
		Switch $var
		;If it's the same:
		Case $startvar
			$t_coeff = _CalculateFract($t_coeff,$coeff,"+")
		
		;If it's not:
		Case Else
			If _C2Number($t_coeff) = 1 And Not $startvar = "" Then $t_coeff = ""
			If _C2Number($t_coeff) = -1 Then $t_coeff = "-"
			$r = $r & "+" & $t_coeff & $startvar	;Append the string
			
			;re-initialize
			$t_coeff = 0
			$startvar = $var
			$t_coeff = _CalculateFract($t_coeff,$coeff,"+")
		EndSwitch
	Next
	If _C2Number($t_coeff) = 1 And Not $startvar = "" Then $t_coeff = ""
	If _C2Number($t_coeff) = -1 Then $t_coeff = "-"
	$r = $r & "+" & $t_coeff & $startvar	;Append the last string
	
	;Clean it up
	$r = StringReplace($r,"+-","-")
	While StringMid($r,1,1) = "+"
		$r = StringMid($r,2)
	WEnd
	
	;And voila!
	Return $r
EndFunc

Func _ExpMultiply($str1, $str2)
	;If Not IsString($str1) Then Return ""
	;If Not IsString($str2) Then Return ""

	;Get coefficients in each
	$c1 = _ExpSplit($str1)
	$c1_u = $c1[1]
	$c1 = _C2Number($c1_u)
	$c2 = _ExpSplit($str2)
	$c2_u = $c2[1]
	$c2 = _C2Number($c2_u)
	$cf = _CalculateFract($c1, $c2, "*")
	
	;Repair the strings to have no coefficients
	$str1 = StringMid($str1,StringLen($c1_u)+1)
	$str2 = StringMid($str2,StringLen($c2_u)+1)
	
	;Append the strings to the coefficient
	$result = $cf & $str1 & $str2
	
	;Tidy it up
	Return $result
EndFunc

Func _pMultiply($poly1, $poly2)
	If Not $poly1 = "0" Then Return 0
	If Not $poly2 = "0" Then Return 0
	$ar1 = _pSplit($poly1)
	;_ArrayDisplay($ar1)
	$ar2 = _pSplit($poly2)
	$tot = $ar1[0] * $ar2[0]
	Dim $res[$tot+1]
	$res[0] = $tot
	For $i = 1 To $ar1[0]
		For $j = 1 To $ar2[0]
			$n = ($i-1)*$ar2[0] + $j
			$res[$n] = _ExpMultiply($ar1[$i],$ar2[$j])
		Next
	Next
	$res = _ArrayToString($res,"+",1)
	Return _pTidy($res)
EndFunc

Func _C2Number($coeff)
	;Coefficient can be a number, -a number, +, -, or nothing
	While StringMid($coeff,1,1) = "+"
		$coeff = StringMid($coeff,2)
	WEnd
	Switch $coeff
	Case ""
		Return 1
	Case "+"
		Return 1
	Case "-"
		Return -1
	Case Else
		Return $coeff
	EndSwitch
EndFunc

#region CalculateFract($f1,$f2,$op)
Func _CalculateFract($fract1,$fract2,$operand)
	If Not StringInStr($fract1,"/") Then $fract1 = $fract1 & "/1"
	If Not StringInStr($fract2,"/") Then $fract2 = $fract2 & "/1"
	$i = StringSplit($fract1,"/")
	$num1 = Number($i[1])
	$den1 = Number($i[2])
	$i = StringSplit($fract2,"/")
	$num2 = Number($i[1])
	$den2 = Number($i[2])
	Switch $operand
	Case "*"
		$numr = $num1 * $num2
		$denr = $den1 * $den2
		If IsInt($numr/$denr) Then Return $numr/$denr
		$hcf = _HighestCommonFactor($numr,$denr)
		$numr = $numr / $hcf
		$denr = $denr / $hcf
		If $numr > 0 And $denr < 0 Then
			$numr = -$numr
			$denr = -$denr
		ElseIf $numr < 0 And $denr < 0 Then
			$numr = -$numr
			$denr = -$denr
		EndIf
		Return $numr & "/" & $denr
	Case "/"
		$v = $den2
		$den2 = $num2
		$num2 = $v
		$fract2 = $num2 & "/" & $den2
		Return CalculateFract($fract1,$fract2,"*")
	Case "+"
		$lcm = _LowestCommonMultiple($den1,$den2)
		$num1 = $num1 * ($lcm/$den1)
		$num2 = $num2 * ($lcm/$den2)
		$numr = $num1 + $num2
		$denr = $lcm
		If IsInt($numr/$denr) Then Return $numr/$denr
		$hcf = _HighestCommonFactor($numr,$denr)
		$numr = $numr / $hcf
		$denr = $denr / $hcf
		If $numr > 0 And $denr < 0 Then
			$numr = -$numr
			$denr = -$denr
		ElseIf $numr < 0 And $denr < 0 Then
			$numr = -$numr
			$denr = -$denr
		EndIf
		Return $numr & "/" & $denr
	Case "-"
		$lcm = _LowestCommonMultiple($den1,$den2)
		$num1 = $num1 * ($lcm/$den1)
		$num2 = $num2 * ($lcm/$den2)
		$numr = $num1 - $num2
		$denr = $lcm
		If IsInt($numr/$denr) Then Return $numr/$denr
		$hcf = _HighestCommonFactor($numr,$denr)
		$numr = $numr / $hcf
		$denr = $denr / $hcf
		If $numr > 0 And $denr < 0 Then
			$numr = -$numr
			$denr = -$denr
		ElseIf $numr < 0 And $denr < 0 Then
			$numr = -$numr
			$denr = -$denr
		EndIf
		Return $numr & "/" & $denr
	EndSwitch
EndFunc   ;==>_CalculateFract

Func _HighestCommonFactor($a, $b = "")
    If $b = "" And Not IsArray($a) Then
        Return SetError(1, 0, 0)
    ElseIf IsNumber($a) And IsNumber($b) Then
        Local $c
        While Not $b = 0
            $c = $b
            $b = Mod($a, $b)
            $a = $c
        WEnd
        Return $a
    ElseIf $b = "" And IsArray($a) Then
        Local $c, $aArr = $a
        $a = 0
        $b = 0
        For $i = 0 To UBound($aArr) - 3
            $a = $aArr[$i]
            $b = $aArr[$i + 1]
            $c = _HighestCommonFactor($a, $b)
            $d = _HighestCommonFactor($c, $aArr[$i + 2])
        Next
        Return $d
    Else
        Return SetError(1, 0, 0)
    EndIf
EndFunc   ;==>_HighestCommonFactor

Func _LowestCommonMultiple($a, $b = "")
    If $b = "" And Not IsArray($a) Then
        Return SetError(1, 0, 0)
    ElseIf IsNumber($a) And IsNumber($b) Then
        Return ($a / _HighestCommonFactor($a, $b)) * $b
    ElseIf $b = "" And IsArray($a) Then
        Local $iMax = _ArrayMax($a, 1), $iMultiple = $iMax, $iTest = 0
        While 1
            $iTest = 0
            For $i = 0 To UBound($a) - 1
                If Mod($iMultiple, $a[$i]) > 0 Then $iTest += 1
            Next
            If $iTest = 0 Then Return $iMultiple
            $iMultiple += $iMax
        WEnd
    Else
        Return SetError(1, 0, 0)
    EndIf
EndFunc   ;==>_LowestCommonMultiple

Func _FindFract($fract)
	If Not StringInStr($fract,"/") Then $fract = $fract & "/1"
	$i = StringSplit($fract,"/")
	$num1 = Number($i[1])
	$den1 = Number($i[2])
	Return $num1 / $den1
EndFunc   ;==>FindFract

Func _LowestCommonFract($fract1,$fract2)
	If Not StringInStr($fract1,"/") Then $fract1 = $fract1 & "/1"
	If Not StringInStr($fract2,"/") Then $fract2 = $fract2 & "/1"
	$i = StringSplit($fract1,"/")
	$num1 = Number($i[1])
	$den1 = Number($i[2])
	$i = StringSplit($fract2,"/")
	$num2 = Number($i[1])
	$den2 = Number($i[2])
	
	$numr = _LowestCommonMultiple($num1,$num2)
	$denr = _LowestCommonMultiple($den1,$den2)
	
	If IsInt($numr/$denr) Then Return $numr/$denr
	$hcf = _HighestCommonFactor($numr,$denr)
	$numr = $numr / $hcf
	$denr = $denr / $hcf
	If $numr > 0 And $denr < 0 Then
		$numr = -$numr
		$denr = -$denr
	ElseIf $numr < 0 And $denr < 0 Then
		$numr = -$numr
		$denr = -$denr
	EndIf
	If $denr = 1 Then
		$res = $numr
	Else
		$res = $numr & "/" & $denr
	EndIf
	Return $res
EndFunc   ;==>_LowestCommonFract
#EndRegion
#EndRegion
;~~
#region Step 1.au3
Func _PolyDeg($poly, $wrt_v)
	$poly = _pMultiply($poly,"1")
	$terms = _pSplit($poly)
	$degree = 0
	For $i = 1 To $terms[0]
		$pt = _ExpSplit($terms[$i])
		For $j = 1 To $pt[0]
			If StringInStr($pt[$j],$wrt_v) Then
				$d = StringSplit($pt[$j],"^")
				If @error = 1 Then
					$d = 1
				Else
					$d = $d[2]
				EndIf
				If $d > $degree Then $degree = $d
			EndIf
		Next
	Next
	Return $degree
EndFunc ;==>_PolyDeg()

Func _PolyCoeff($poly, $wrt_v, $degree)
	$poly = _pTidy($poly)
	Dim $coeff[$degree+1]
	$pts = _pSplit($poly)
	For $i = 1 To $pts[0]
		$pow = _PolyDeg($pts[$i],$wrt_v)
		If $pow = 1 Then
			$search = $wrt_v
		Else
			$search = $wrt_v & "^" & $pow
		EndIf
		$pts[$i] = StringReplace(_pTidy($pts[$i]),$search,"")
		$coeff[$pow] = _pTidy($coeff[$pow] & "+" & $pts[$i])
	Next
	Return $coeff
EndFunc ;==>_PolyCoeff
#EndRegion

;~~
#region Step 2.au3
Func _Sylvester($varray1, $varray2)
	$size = UBound($varray1) + UBound($varray2) -2
	Dim $sylvester[$size][$size]
	
	For $i1 = 1 To $size - (UBound($varray1)-1) ;Number of times 1st equation is input
		$starti = $i1-1
		
		For $c = 0 To $starti-1
			$sylvester[$i1-1][$c] = 0
		Next
		
		For $c = UBound($varray1)-1 To 0 Step -1
			If $varray1[$c] = "" Then $varray1[$c] = 0
			$sylvester[$i1-1][$starti+ UBound($varray1)-1 - $c] = $varray1[$c]			
		Next
		
		For $c = $starti+ UBound($varray1) - $c -1 To $size-1
			$sylvester[$i1-1][$c] = 0
		Next
	Next

	$shift = $i1-1

	For $i2 = 1 To $size - (UBound($varray2)-1);Number of times 2nd equation is input
		$starti = $i2-1
		
		For $c = 0 To $starti-1
			$sylvester[$i2-1+$shift][$c] = 0
		Next
		
		For $c = UBound($varray2)-1 To 0 Step -1
			If $varray2[$c] = "" Then $varray2[$c] = 0
			$sylvester[$i2-1+$shift][$starti+ UBound($varray2)-1 - $c] = $varray2[$c]			
		Next
		
		For $c = $starti+ UBound($varray2) - $c -1 To $size-1
			$sylvester[$i2-1+$shift][$c] = 0
		Next
	Next
	
	Return $sylvester
EndFunc

Func _Det($2dArray)
	If UBound($2dArray) = 1 Then Return $2dArray[0][0]
	$d2 = 0
	$determinant = ""
	For $d1 = 0 To UBound($2dArray,1)-1 ;For each row, i.e. moving down first column
		If IsFloat(($d1+$d2)/2) Then
			$coeffactor = -1
		Else
			$coeffactor = 1
		EndIf
		;Determinant is equal to the determinant + coeffactor * the value in that place * the determinant of the
		;																					matrix with the row and column removed
		
		
		$co_val = _pMultiply($2dArray[$d1][$d2], $coeffactor)
		$newAR = $2dArray
		_ArrayDeleteCol($newAr,$d2)
		_ArrayDelete($newAR,$d1)
		$determinant = _pTidy($determinant & "+" & _pMultiply($co_val, _Det($newAR)))
	Next
	Return $determinant
EndFunc

Func _ArrayDeleteCol(ByRef $avArray, $iCol)	
	For $c = $iCol To UBound($avArray, 2) - 2 
		For $r = 0 To UBound($avArray) - 1
			$avArray[$r][$c] = $avArray[$r][$c + 1]
		Next
	Next
	$i = UBound($avArray,1)
	$j = UBound($avArray,2) - 1
    ReDim $avArray[$i][$j]
    Return 1
EndFunc
#EndRegion