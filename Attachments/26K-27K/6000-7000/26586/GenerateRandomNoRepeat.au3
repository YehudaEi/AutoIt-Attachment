#include-once

; EXAMPLE
; Just enable the bottom to see example

;~ Local $RandomArray
;~ $RandomArray  = _GenerateRandomNoRepeat(12, 4, 100)
;~ $RandomString = _GenerateRandomNoRepeat(12, 4, 100, True)

;~ MsgBox(0, "Value of $RandomArray[5]", "$RandomArray[5] = "&$RandomArray[5])
;~ MsgBox(0, "String of 12 random numbers", $RandomString)


; #FUNCTION# ================================================================================
; Name..........:	_GenerateRandomNoRepeat
; Description...:   Creates an array or string of random numbers without repeating the numbers
; Syntax........:	_GenerateRandomNoRepeat([$size=7[, $min=1[, $max=36[, $string=False]]]])
; Parameters....:   $size	- [optional] Number of numbers. Default=7
;					$min  	- [optional] The smallest number to be generated. Default=1
;					$max  	- [optional] The largest number to be generated. Default=36
;					$string	- [optional] False=show as an array | True=show as a string
; Requirements..:  	No requirements
; Return Values.:	Success	- If $string=False an array of non-repeated random numbers
;							- If $string=True a string of non-repeated random numbers
;					Failure	- 0
;					|0 - $size is not a number
;					|1 - $min is not a number
;					|2 - $max is not a number
;					|3 - $size either 0 or a negative
;					|4 - will generate repeats and can not continue
; Author........:	Unknown
; Modified......:	billthecreator - Code cleanup, addons, and name change
; Example.......:	Yes
; ===========================================================================================
;
Func _GenerateRandomNoRepeat($size=7, $min=1, $max=36, $string=False)
    Local $array[$size], $sResult
	
	;	ERRORS
	If Not IsNumber($size) Then
		SetError(0)
		Return 0
	ElseIf Not IsNumber($min) Then
		SetError(1)
		Return 0
	ElseIf Not IsNumber($max) Then
		SetError(2)
		Return 0
	ElseIf Not $size > 1 Then
		SetError(3)
		Return 0
	ElseIf $size > ($max-$min)+1 Then
		SetError(4)
		Return 0
	EndIf
	
	If $string <> False Then $string = True
	
	;	STARTING NUMBER
    $array[0]=Random($min,$max,1)
	
    For $i=0 To $size-1
	;	GENERATOR
        While True
            $tempf=Random($min,$max,1)
            For $j=0 To $i-1
				;IF NUMBER ALREADY EXISTS, RELOOP AND FIND ANOTHER
                If $array[$j]=$tempf Then ContinueLoop 2
            Next
            ExitLoop
        WEnd
	;	SET NUMBER TO ARRAY SECTION
        $array[$i]=$tempf
		
    Next
	
	;	RETURN NUMBERS IN A STRING
	If $string Then
		For $i = 0 To UBound($array) - 1
			$sResult &= $array[$i] & "|"
		Next

		Return StringTrimRight($sResult, StringLen("|"))
	EndIf
	
	;	RETURN NUMBERS IN AN ARRAY
    Return $array
EndFunc