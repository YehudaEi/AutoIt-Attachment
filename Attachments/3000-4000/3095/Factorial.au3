Func _MathFactorial($mfFactor)
	If Not (StringIsInt($mfFactor)) OR (Int($mfFactor) < 0) Then
		;Invalid text entered into parameters exit with error
		SetError(1)
		Return 0
	Else
		;Make the parameter a number (was a string)
		$mfFactor = Int($mfFactor)
	EndIf
	;0! is 1
	If $mfFactor = 0 Then Return 1
	
	Dim $return = 1
	;$mfFactor * ($mfFactor - 1) * ($mfFactor - 2) * ... * 3 * 2 * 1
    For $i = $mfFactor to 1 Step - 1
        $return *= $i
    Next
	Return $return
EndFunc

Func _MathPermutation($mpN, $mpR)
	If (Not StringIsInt($mpN)) OR (Int($mpN) < 0) Then
		;Invalid parameters, or N is less than R (not allowed)
		SetError(1)
		Return 0
	Else
		;Make the parameters into numbers (was a string)
		$mpN = Int($mpN)
	EndIf
	
	If (Not StringIsInt($mpR)) OR (Int($mpR) < 0) Then
		SetError(1)
		Return 0
	Else
		$mpR = Int($mpR)
	EndIf
	
	If ($mpN < $mpR) Then
		SetError(1)
		Return 0
	EndIf
	
	Select
		Case $mpR = 0
			Return 1
		Case $mpR = 1
			Return $mpN
		Case $mpN = $mpR
			Return _MathFactorial($mpN)
		Case Else
			Return _MathFactorial($mpN)/_MathFactorial($mpN-$mpR)
		EndSelect
EndFunc