;~ Author: WUS [Ben Caplins]
;~ Last Changed: 7/14/06
;~  
;~ BigInteger datatype, modeled after the Java BigInteger Class.
;~ Work In Progress!

;~ These commented include lines are only for me, since I work off a network share
;~ #include<\\Terra\bwc1$\desktop\AutoIT\beta\include\array.au3>
;~ #include<\\Terra\bwc1$\desktop\AutoIT\beta\include\string.au3>
;~ #include<\\Terra\bwc1$\desktop\AutoIT\beta\include\math.au3>

#include<array.au3>
#include<string.au3>
#include<math.au3>

MsgBox( 48, "Test of multiplication", "The multiplication is very very slow but works." & @CRLF & "I will be working on improving its efficiency." & @CRLF & "20! = " & @CRLF &	Factorial(25) )
MsgBox( 48, "Test of addition", "The addition is much more efficient that the multiplication." & @CRLF & "Fib(100) = " & @CRLF & Fib(100) )


;~ Example of how to use the bigint
Func Factorial( $n )
	Local $a = _intToBigInteger(1)
	Local $i
	For $i = 1 to $n
		Local $b = _intToBigInteger($i)
		$a = _multiplyBigIntegers( $b, $a )
	Next
	Return _bigIntegerToString( $a )
EndFunc

Func Fib ($n)
	Local $first = _intToBigInteger(0)
    Local $second = _intToBigInteger(1)
	Local $tmp
	While $n <> 0
		$temp = _addBigIntegers( $first, $second )
		$first = $second
		$second = $temp
		$n = $n-1
	WEnd
	return _bigIntegerToString( $first );
EndFunc


;~ ##########################################################################################
;~ These are the functions currently needed to work with bigints.  
;~ _intToBigInteger -> Returns the bigint representation of an integer.
;~ _bigIntegerToString -> Return the string representation of a bigint.
;~ _switchBigIntegerSign -> Changes the sign of the given bigint. (no return other than 1)
;~ _addBigIntegers -> Returns a bigint that is the sum of two given bigints.
;~ _multiplyBigIntegers -> Returns a bigint that is the product of two given bigints.
;~ ##########################################################################################


;~ Transforms an integer to a bigint
;~ Returns -1 if input is not an integer
Func _intToBigInteger( $rawInt )
	If IsInt( $rawInt ) <> 1 Then
		Return -1
	EndIf
	Local $sign
	If $rawInt < 0 Then
		$sign = "-"
	Else
		$sign = "+"
	EndIf
	$rawInt = Abs( $rawInt )
	Local $rawStr = String( $rawInt )
	Local $strArray = StringSplit( $rawStr, "" )
	Local $bigInt[$strArray[0]+1]
	$bigInt[0] = $sign
	Local $i
	For $i=1 To $strArray[0]
		$bigInt[$strArray[0]-$i+1] = $strArray[$i]
	Next
	_removeTrailingZeros($bigInt)
	Return $bigInt
EndFunc

;~ Outputs a bigint as a string
;~ Returns -1 if nonarray
;~ Returns 0 if not bigint (not 100% effective)
;~ Returns string if succeeded
Func _bigIntegerToString( $bigInt )
	If IsArray( $bigInt ) = 0 Then
		Return -1
	ElseIf $bigInt[0] <> "+" And $bigInt[0] <> "-" Then
		Return 0
	Else	
		Local $output
		$output = $bigInt[0]
		Local $i
		For $i = (UBound($bigInt)-1) To 1 Step -1
			$output = $output & $bigInt[$i]
		Next
	EndIf
	Return $output
EndFunc
		
;~ Switches the sign of the bigint, makes subraction possible through addition
;~ Returns -1 if nonarray
;~ Returns 0 if not bigint (not 100% effective)
;~ Returns 1 if succeeded
Func _switchBigIntegerSign( ByRef $bigInt1 )
	If IsArray( $bigInt1 ) = 0 Then
		Return -1		
	ElseIf $bigInt1[0] = "+" Then
		$bigInt1[0] = "-"
	ElseIf $bigInt1[0] = "-" Then
		$bigInt1[0] = "+"
	Else
		Return 0
	EndIf
	Return 1
EndFunc

;~ Adds two bigints
Func _addBigIntegers( $bigInt1, $bigInt2 )
	_equalizeArrayLengths( $bigInt1, $bigInt2 )
	Local $i
	Local $bigIntSum[UBound($bigInt1)+1]
	_initializeBigInteger( $bigIntSum )
	If $bigInt1[0]=$bigInt2[0] Then
		If $bigInt1[0] = "+" Then
			$bigIntSum[0] = "+"
		Else
			$bigIntSum[0] = "-"
		EndIf
		For $i=1 To (UBound($bigInt1)-1)
			$bigIntSum[$i] = $bigInt1[$i] + $bigInt2[$i] + $bigIntSum[$i]
			If $bigIntSum[$i] > 9 Then 
				$bigIntSum[$i+1] = 1
				$bigIntSum[$i] = $bigIntSum[$i]-10
			EndIf
		Next
	Else
		Local $temp1 = _absMax( $bigInt1, $bigInt2 )
		Local $temp2 = _absMin( $bigInt1, $bigInt2 )
		$bigInt1 = $temp1
		$bigInt2 = $temp2
		_equalizeArrayLengths( $bigInt1, $bigInt2 )
		If $bigInt1[0] = "+" Then
			$bigIntSum[0] = "+"
		Else
			$bigIntSum[0] = "-"
		EndIf
		For $i=1 To (UBound($bigInt1)-1)
			$bigIntSum[$i] = $bigIntSum[$i] + $bigInt1[$i] - $bigInt2[$i]
			If $bigIntSum[$i] < 0 Then
				$bigIntSum[$i+1] = -1
				$bigIntSum[$i] = $bigIntSum+10
			EndIf
		Next
	EndIf
	_removeTrailingZeros( $bigIntSum )
	Return $bigIntSum
EndFunc

;~ Multiplies two bigints
Func _multiplyBigIntegers( $bigInt1, $bigInt2 )
	Local $temp = _absMax( $bigInt1, $bigInt2 )
	Local $sign
	Local $bigIntProduct[UBound($temp)*2]
	_initializeBigInteger( $bigIntProduct )
	If $bigInt1[0] = $bigInt2[0] Then
		$sign = "+"
	ElseIf $bigInt1[0] <> $bigInt2[0] Then
		$sign = "-"
	EndIf
	Local $i
	Local $j
	Local $total = _intToBigInteger(0)
	For $i = 1 To (UBound($bigInt1)-1)
		For $j = 1 To (UBound($bigInt2)-1)
;~ 			_ArrayDisplay( $bigIntProduct, "test")
			$bigIntProduct[$i+$j-1] = Mod($bigInt1[$i]*$bigInt2[$j],10)
;~ 			_ArrayDisplay( $bigIntProduct, "test")
			$bigIntProduct[$i+$j] = _Div( $bigInt1[$i]*$bigInt2[$j], 10 )
;~ 			_ArrayDisplay( $bigIntProduct, "test")
			$total = _addBigIntegers($bigIntProduct, $total)
			$bigIntProduct = _intToBigInteger(0)
			Redim $bigIntProduct[UBound($temp)*2]
			_initializeBigInteger($bigIntProduct)
			
		Next
	Next
	$total[0] = $sign
	_removeTrailingZeros( $total )
	Return $total
EndFunc


;~ ##########################################################################################
;~ All functions below this point are helper functions, needed but not to be normally used.
;~ ##########################################################################################

;~ Returns an integral after division, complement to Mod func in Math.au3
;~ Not tested for negative numbers, currently only for positive ones
Func _Div( $x, $y )
	Local $z = ($x/$y)
	$z = Floor($z)
	Return $z
EndFunc

;~ Returns the bigint that is smaller in absolute value
Func _absMax( $bigInt1, $bigInt2, $mode="max" )
	Local $ret
	_removeTrailingZeros( $bigInt1 )
	_removeTrailingZeros( $bigInt2 )
	Local $isEqual = _isBigIntegerEqual( $bigInt1, $bigInt2 )
	If $isEqual = 1 Then
		$ret = $bigInt1
	ElseIf UBound( $bigInt1 ) > UBound( $bigInt2 ) Then
		$ret = $bigInt1
	ElseIf UBound( $bigInt1 ) < UBound( $bigInt2 ) Then
		$ret = $bigInt2		
	Else
		For $i = (UBound($bigInt1)-1) To 1 Step -1
			If $bigInt1[$i] > $bigInt2[$i] Then
				If $mode="max" Then
					$ret = $bigInt1
				ElseIf $mode="min" Then
					$ret = $bigInt2
				EndIf
				ExitLoop
			ElseIf $bigInt1[$i] < $bigInt2[$i] Then
				If $mode="max" Then
					$ret = $bigInt2
				ElseIf $mode="min" Then
					$ret = $bigInt1
				EndIf
				ExitLoop
			EndIf
		Next
	EndIf
	Return $ret	
EndFunc

;~ Complementary min function
;~ Returns the bigint that is smaller in absolute value
Func _absMin( $bigInt1, $bigInt2 )
	Return _absMax( $bigInt1, $bigInt2, "min" )
EndFunc

;~ Tests to see if two bigints are equal
;~ Returns -1 if nonarrays
;~ Returns 0 if not equal
;~ Returns 1 if equal
Func _isBigIntegerEqual( $bigInt1, $bigInt2 )
	If IsArray( $bigInt1 ) = 0 Or IsArray( $bigInt2 ) = 0 Then
		return -1
	Else
		_removeTrailingZeros( $bigInt1 )
		_removeTrailingZeros( $bigInt2 )
		Local $isEqual = 1
		Local $bigL1 = UBound( $bigInt1 )
		Local $bigL2 = UBound( $bigInt2 )
		If $bigL1 <> $bigL2 Then
			$isEqual = 0
		ElseIf $bigL1 = 2 And $bigL2 = 2 And $bigInt1[1] = 0 And $bigInt2[1] = 0 Then
			$isEqual = 1
		Else
			Local $i
			For $i = 0 To (UBound( $bigInt1 )-1)
				If $bigInt1[$i] = $bigInt2[$i] Then
					$i = $i+1
				Else
					$isEqual = 0
					ExitLoop
				EndIf
			Next
		EndIf
	EndIf
	Return $isEqual
EndFunc

;~ removes trailing zeros from the end of a bigint
;~ Returns -1 for nonarrays
;~ Returns 1 for success
Func _removeTrailingZeros( ByRef $bigInt1 )
	If IsArray( $bigInt1 ) = 0 Then
		return -1
	Else
		Local $i = UBound($bigInt1)-1
		While $bigInt1[$i]=0 AND $i<>1
			$i -= 1
		WEnd
		ReDim $bigint1[$i+1]
	EndIf
	Return 1
EndFunc

;~ Initialize the array that holds the output of the expression
;~ Returns -1 for nonarrays
;~ Returns 1 if it succeeded
Func _initializeBigInteger( ByRef $bigInt1, $val = 0 )
	If IsArray( $bigInt1 ) = 0 Then
		return -1
	Else
		$bigInt1[0]="+"
		Local $i
		For $i = 1 To (UBound( $bigInt1 )-1)
			$bigInt1[$i] = 0
		Next
	EndIf	
	Return 1
EndFunc

;~ Equalize the lengths of two arrays so that out of bounds errors do no occur
;~ Returns -1 for nonrays
;~ Return 0 for they are already equal
;~ Return 1 if it succeeded

Func _equalizeArrayLengths( ByRef $bigInt1, ByRef $bigInt2 )
	If IsArray( $bigInt1 ) = 0 Or IsArray( $bigInt2 ) = 0 Then
		Return -1
	Else
		Local $arrayL1 = UBound( $bigInt1 )
		Local $arrayL2 = UBound( $bigInt2 )
		If $arrayL1 < $arrayL2 Then
			ReDim $bigInt1[$arrayL2]
		ElseIf $arrayL1 > $arrayL2 Then
			ReDim $bigInt2[$arrayL1]
		Else 
			Return 0
		EndIf
	EndIf
	Return 1
EndFunc	