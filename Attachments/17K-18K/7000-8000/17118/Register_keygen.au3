HotKeySet("{ESC}", "bye")

Func bye()
	Exit
EndFunc

Global $used = 0
Global $fileloc = FileOpen(@SCRIPTDIR & "keys.txt", 9)

; Key generator
While 1
;~ 	Obtain the individual characters inside of the input
	$first = Round(Random(0, 1))
	
	If $first Then 
		$1_1 = Round(Random(48, 57))
	Else 
		$1_1 = Round(Random(65, 90))
	EndIf
	
	If Not $first Then 
		$1_2 = Round(Random(48, 57)) 
	Else 
		$1_2 = Round(Random(65, 90))
	EndIf
	
	If Not $first Then 
		$1_3 = Round(Random(48, 57)) 
	Else 
		$1_3 = Round(Random(65, 90))
	EndIf
	
	If $first Then 
		$1_4 = Round(Random(48, 57)) 
	Else 
		$1_4 = Round(Random(65, 90))
	EndIf
	
	If Not $first Then 
		$1_5 = Round(Random(48, 57)) 
	Else 
		$1_5 = Round(Random(65, 90))
	EndIf
	
;~ 	Display the split values
	ConsoleWrite($1_1 & @CRLF & $1_2 & @CRLF & $1_3 & @CRLF & $1_4 & @CRLF & $1_5 & @CRLF)
	
;~ 	Obtain the total for each of the numeric characters
	$1_total = $1_1 + $1_2 + $1_3 + $1_4 + $1_5
	
;~ 	Display the total for the numeric characters
	ConsoleWrite($1_total & @CRLF)
	
;~ 	Obtain the remainder for the numeric characters based upon even numbers (I.E. Determine if it is even)
	$1_final = Mod($1_total, 2)
	
;~ 	Display if it is even or odd, if odd value is 1 if even value is 0
	ConsoleWrite($1_final & @CRLF)

;~ 	Obtain the individual characters inside of the input
	$second = Round(Random(0, 1))
	
	If $second Then 
		$2_1 = Round(Random(48, 57))
	Else 
		$2_1 = Round(Random(65, 90))
	EndIf
	
	If Not $second Then 
		$2_2 = Round(Random(48, 57)) 
	Else 
		$2_2 = Round(Random(65, 90))
	EndIf
	
	If Not $second Then 
		$2_3 = Round(Random(48, 57)) 
	Else 
		$2_3 = Round(Random(65, 90))
	EndIf
	
	If $second Then 
		$2_4 = Round(Random(48, 57)) 
	Else 
		$2_4 = Round(Random(65, 90))
	EndIf
	
	If Not $second Then 
		$2_5 = Round(Random(48, 57)) 
	Else 
		$2_5 = Round(Random(65, 90))
	EndIf
	
;~ 	Display the split values
	ConsoleWrite($2_1 & @CRLF & $2_2 & @CRLF & $2_3 & @CRLF & $2_4 & @CRLF & $2_5 & @CRLF)
	
;~ 	Obtain the total for each of the numeric characters
	$2_total = $2_1 + $2_2 + $2_3 + $2_4 + $2_5
	
;~ 	Display the total for the numeric characters
	ConsoleWrite($2_total & @CRLF)
	
;~ 	Obtain the remainder for the numeric characters based upon even numbers (I.E. Determine if it is even)
	$2_final = Mod($2_total, 2)
	
;~ 	Display if it is even or odd, if odd value is 1 if even value is 0
	ConsoleWrite($2_final & @CRLF)
	
;~ 	Obtain the individual characters inside of the input
	$third = Round(Random(0, 1))
	
	If $third Then 
		$3_1 = Round(Random(48, 57))
	Else 
		$3_1 = Round(Random(65, 90))
	EndIf
	
	If Not $third Then 
		$3_2 = Round(Random(48, 57)) 
	Else 
		$3_2 = Round(Random(65, 90))
	EndIf
	
	If Not $third Then 
		$3_3 = Round(Random(48, 57)) 
	Else 
		$3_3 = Round(Random(65, 90))
	EndIf
	
	If $third Then 
		$3_4 = Round(Random(48, 57)) 
	Else 
		$3_4 = Round(Random(65, 90))
	EndIf
	
	If Not $third Then 
		$3_5 = Round(Random(48, 57)) 
	Else 
		$3_5 = Round(Random(65, 90))
	EndIf
	
;~ 	Display the split values
	ConsoleWrite($3_1 & @CRLF & $3_2 & @CRLF & $3_3 & @CRLF & $3_4 & @CRLF & $3_5 & @CRLF)
	
;~ 	Obtain the total for each of the numeric characters
	$3_total = $3_1 + $3_2 + $3_3 + $3_4 + $3_5
	
;~ 	Display the total for the numeric characters
	ConsoleWrite($3_total & @CRLF)
	
;~ 	Obtain the remainder for the numeric characters based upon even numbers (I.E. Determine if it is even)
	$3_final = Mod($3_total, 2)
	
;~ 	Display if it is even or odd, if odd value is 1 if even value is 0
	ConsoleWrite($3_final & @CRLF)
	
;~ 	Obtain the individual characters inside of the input
	$fourth = Round(Random(0, 1))
	
	If $fourth Then 
		$4_1 = Round(Random(48, 57))
	Else 
		$4_1 = Round(Random(65, 90))
	EndIf
	
	If Not $fourth Then 
		$4_2 = Round(Random(48, 57)) 
	Else 
		$4_2 = Round(Random(65, 90))
	EndIf
	
	If Not $fourth Then 
		$4_3 = Round(Random(48, 57)) 
	Else 
		$4_3 = Round(Random(65, 90))
	EndIf
	
	If $fourth Then 
		$4_4 = Round(Random(48, 57)) 
	Else 
		$4_4 = Round(Random(65, 90))
	EndIf
	
	If Not $fourth Then 
		$4_5 = Round(Random(48, 57)) 
	Else 
		$4_5 = Round(Random(65, 90))
	EndIf
	
;~ 	Display the split values
	ConsoleWrite($4_1 & @CRLF & $4_2 & @CRLF & $4_3 & @CRLF & $4_4 & @CRLF & $4_5 & @CRLF)

;~ 	Obtain the total for each of the numeric characters
	$4_total = $4_1 + $4_2 + $4_3 + $4_4 + $4_5
	
;~ 	Display the total for the numeric characters
	ConsoleWrite($4_total & @CRLF)
	
;~ 	Obtain the remainder for the numeric characters based upon even numbers (I.E. Determine if it is even)
	$4_final = Mod($4_total, 2)
	
;~ 	Display if it is even or odd, if odd value is 1 if even value is 0
	ConsoleWrite($4_final & @CRLF)
	
;~ 	Obtain the individual characters inside of the input
	$fifth = Round(Random(0, 1))
	
	If $fifth Then 
		$5_1 = Round(Random(48, 57))
	Else 
		$5_1 = Round(Random(65, 90))
	EndIf
	
	If Not $fifth Then 
		$5_2 = Round(Random(48, 57)) 
	Else 
		$5_2 = Round(Random(65, 90))
	EndIf
	
	If Not $fifth Then 
		$5_3 = Round(Random(48, 57)) 
	Else 
		$5_3 = Round(Random(65, 90))
	EndIf
	
	If $fifth Then 
		$5_4 = Round(Random(48, 57)) 
	Else 
		$5_4 = Round(Random(65, 90))
	EndIf
	
	If Not $fifth Then 
		$5_5 = Round(Random(48, 57)) 
	Else 
		$5_5 = Round(Random(65, 90))
	EndIf
	
;~ 	Display the split values
	ConsoleWrite($5_1 & @CRLF & $5_2 & @CRLF & $5_3 & @CRLF & $5_4 & @CRLF & $5_5 & @CRLF)
	
;~ 	Obtain the total for each of the numeric characters
	$5_total = $5_1 + $5_2 + $5_3 + $5_4 + $5_5
	
;~ 	Display the total for the numeric characters
	ConsoleWrite($5_total & @CRLF)
	
;~ 	Obtain the remainder for the numeric characters based upon even numbers (I.E. Determine if it is even)
	$5_final = Mod($5_total, 2)
	
;~ 	Display if it is even or odd, if odd value is 1 if even value is 0
	ConsoleWrite($5_final & @CRLF)
	
;~ 	Ok, add up all the final values to create a final value
	$final = $1_final + $2_final + $3_final + $4_final + $5_final
	
;~ 	Display the final total
	ConsoleWrite($final & @CRLF)
	
;~ 	If the final remainders of all of the parts put together is 3, it is a valid key
	If $final <= 1 Then
		$final_key = Chr($1_1) & Chr($1_2) & Chr($1_3) & Chr($1_4) & Chr($1_5)
		$final_key &= "-" & Chr($2_1) & Chr($2_2) & Chr($2_3) & Chr($2_4) & Chr($2_5)
		$final_key &= "-" & Chr($3_1) & Chr($3_2) & Chr($3_3) & Chr($3_4) & Chr($3_5)
		$final_key &= "-" & Chr($4_1) & Chr($4_2) & Chr($4_3) & Chr($4_4) & Chr($4_5)
		$final_key &= "-" & Chr($5_1) & Chr($5_2) & Chr($5_3) & Chr($5_4) & Chr($5_5)
		
		MsgBox(32, "Found Key", "Found key: " & $final_key)
		
		ExitLoop
	Else
		ContinueLoop
	EndIf
WEnd