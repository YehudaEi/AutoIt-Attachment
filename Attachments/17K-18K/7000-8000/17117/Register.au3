#include <GUIConstants.au3>

#Region ### START Koda GUI section ### Form=
$frmPkey = GUICreate("Please enter your product key to continue...", 367, 98, 193, 115)
$Label1 = GUICtrlCreateLabel("Please enter your product key to continue. This key should be in your email.", 0, 0, 366, 17, $SS_CENTER)
$Input5 = GUICtrlCreateInput("", 24, 32, 57, 21, BitOR($ES_CENTER,$ES_UPPERCASE,$ES_AUTOHSCROLL))
GUICtrlSetLimit(-1, 5)
$Input1 = GUICtrlCreateInput("", 88, 32, 57, 21, BitOR($ES_CENTER,$ES_UPPERCASE,$ES_AUTOHSCROLL))
GUICtrlSetLimit(-1, 5)
$Input2 = GUICtrlCreateInput("", 152, 32, 57, 21, BitOR($ES_CENTER,$ES_UPPERCASE,$ES_AUTOHSCROLL))
GUICtrlSetLimit(-1, 5)
$Input3 = GUICtrlCreateInput("", 216, 32, 57, 21, BitOR($ES_CENTER,$ES_UPPERCASE,$ES_AUTOHSCROLL))
GUICtrlSetLimit(-1, 5)
$Input4 = GUICtrlCreateInput("", 280, 32, 57, 21, BitOR($ES_CENTER,$ES_UPPERCASE,$ES_AUTOHSCROLL))
GUICtrlSetLimit(-1, 5)
$btnContinue = GUICtrlCreateButton("&Continue", 144, 64, 75, 25, 0)
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###

While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			Exit
			
		Case $btnContinue
;~ 			Read the contents of the first input
			$1 = GUICtrlRead($Input5)
			
;~ 			Obtain the individual characters inside of the input
			$1_1 = StringMid($1, 1, 1)
			$1_2 = StringMid($1, 2, 1)
			$1_3 = StringMid($1, 3, 1)
			$1_4 = StringMid($1, 4, 1)
			$1_5 = StringMid($1, 5, 1)
			
;~ 			Display the split values
			ConsoleWrite($1_1 & @CRLF & $1_2 & @CRLF & $1_3 & @CRLF & $1_4 & @CRLF & $1_5 & @CRLF)
			
;~ 			Obtain the numeric value for each of the characters
			$1_1 = Asc($1_1)
			$1_2 = Asc($1_2)
			$1_3 = Asc($1_3)
			$1_4 = Asc($1_4)
			$1_5 = Asc($1_5)
			
;~ 			Display the numeric values for the characters
			ConsoleWrite($1_1 & @CRLF & $1_2 & @CRLF & $1_3 & @CRLF & $1_4 & @CRLF & $1_5 & @CRLF)
			
;~ 			Obtain the total for each of the numeric characters
			$1_total = $1_1 + $1_2 + $1_3 + $1_4 + $1_5
			
;~ 			Display the total for the numeric characters
			ConsoleWrite($1_total & @CRLF)
			
;~ 			Obtain the remainder for the numeric characters based upon even numbers (I.E. Determine if it is even)
			$1_final = Mod($1_total, 2)
			
;~ 			Display if it is even or odd, if odd value is 1 if even value is 0
			ConsoleWrite($1_final & @CRLF)
			
;~ 			Read the contents of the second input
			$2 = GUICtrlRead($Input1)
			
;~ 			Obtain the individual characters inside of the input
			$2_1 = StringMid($2, 1, 1)
			$2_2 = StringMid($2, 2, 1)
			$2_3 = StringMid($2, 3, 1)
			$2_4 = StringMid($2, 4, 1)
			$2_5 = StringMid($2, 5, 1)
			
;~ 			Display the split values
			ConsoleWrite($2_1 & @CRLF & $2_2 & @CRLF & $2_3 & @CRLF & $2_4 & @CRLF & $2_5 & @CRLF)
			
;~ 			Obtain the numeric value for each of the characters
			$2_1 = Asc($2_1)
			$2_2 = Asc($2_2)
			$2_3 = Asc($2_3)
			$2_4 = Asc($2_4)
			$2_5 = Asc($2_5)
			
;~ 			Display the numeric values for the characters
			ConsoleWrite($2_1 & @CRLF & $2_2 & @CRLF & $2_3 & @CRLF & $2_4 & @CRLF & $2_5 & @CRLF)
			
;~ 			Obtain the total for each of the numeric characters
			$2_total = $2_1 + $2_2 + $2_3 + $2_4 + $2_5
			
;~ 			Display the total for the numeric characters
			ConsoleWrite($2_total & @CRLF)
			
;~ 			Obtain the remainder for the numeric characters based upon even numbers (I.E. Determine if it is even)
			$2_final = Mod($2_total, 2)
			
;~ 			Display if it is even or odd, if odd value is 1 if even value is 0
			ConsoleWrite($2_final & @CRLF)
			
;~ 			Read the contents of the third input
			$3 = GUICtrlRead($Input2)
			
;~ 			Obtain the individual characters inside of the input
			$3_1 = StringMid($3, 1, 1)
			$3_2 = StringMid($3, 2, 1)
			$3_3 = StringMid($3, 3, 1)
			$3_4 = StringMid($3, 4, 1)
			$3_5 = StringMid($3, 5, 1)
			
;~ 			Display the split values
			ConsoleWrite($3_1 & @CRLF & $3_2 & @CRLF & $3_3 & @CRLF & $3_4 & @CRLF & $3_5 & @CRLF)
			
;~ 			Obtain the numeric value for each of the characters
			$3_1 = Asc($3_1)
			$3_2 = Asc($3_2)
			$3_3 = Asc($3_3)
			$3_4 = Asc($3_4)
			$3_5 = Asc($3_5)
			
;~ 			Display the numeric values for the characters
			ConsoleWrite($3_1 & @CRLF & $3_2 & @CRLF & $3_3 & @CRLF & $3_4 & @CRLF & $3_5 & @CRLF)
			
;~ 			Obtain the total for each of the numeric characters
			$3_total = $3_1 + $3_2 + $3_3 + $3_4 + $3_5
			
;~ 			Display the total for the numeric characters
			ConsoleWrite($3_total & @CRLF)
			
;~ 			Obtain the remainder for the numeric characters based upon even numbers (I.E. Determine if it is even)
			$3_final = Mod($3_total, 2)
			
;~ 			Display if it is even or odd, if odd value is 1 if even value is 0
			ConsoleWrite($3_final & @CRLF)
			
;~ 			Read the contents of the fourth input
			$4 = GUICtrlRead($Input3)
			
;~ 			Obtain the individual characters inside of the input
			$4_1 = StringMid($4, 1, 1)
			$4_2 = StringMid($4, 2, 1)
			$4_3 = StringMid($4, 3, 1)
			$4_4 = StringMid($4, 4, 1)
			$4_5 = StringMid($4, 5, 1)
			
;~ 			Display the split values
			ConsoleWrite($4_1 & @CRLF & $4_2 & @CRLF & $4_3 & @CRLF & $4_4 & @CRLF & $4_5 & @CRLF)
			
;~ 			Obtain the numeric value for each of the characters
			$4_1 = Asc($4_1)
			$4_2 = Asc($4_2)
			$4_3 = Asc($4_3)
			$4_4 = Asc($4_4)
			$4_5 = Asc($4_5)
			
;~ 			Display the numeric values for the characters
			ConsoleWrite($4_1 & @CRLF & $4_2 & @CRLF & $4_3 & @CRLF & $4_4 & @CRLF & $4_5 & @CRLF)
			
;~ 			Obtain the total for each of the numeric characters
			$4_total = $4_1 + $4_2 + $4_3 + $4_4 + $4_5
			
;~ 			Display the total for the numeric characters
			ConsoleWrite($4_total & @CRLF)
			
;~ 			Obtain the remainder for the numeric characters based upon even numbers (I.E. Determine if it is even)
			$4_final = Mod($4_total, 2)
			
;~ 			Display if it is even or odd, if odd value is 1 if even value is 0
			ConsoleWrite($4_final & @CRLF)
			
;~ 			Read the contents of the fifth input
			$5 = GUICtrlRead($Input4)
			
;~ 			Obtain the individual characters inside of the input
			$5_1 = StringMid($5, 1, 1)
			$5_2 = StringMid($5, 2, 1)
			$5_3 = StringMid($5, 3, 1)
			$5_4 = StringMid($5, 4, 1)
			$5_5 = StringMid($5, 5, 1)
			
;~ 			Display the split values
			ConsoleWrite($5_1 & @CRLF & $5_2 & @CRLF & $5_3 & @CRLF & $5_4 & @CRLF & $5_5 & @CRLF)
			
;~ 			Obtain the numeric value for each of the characters
			$5_1 = Asc($5_1)
			$5_2 = Asc($5_2)
			$5_3 = Asc($5_3)
			$5_4 = Asc($5_4)
			$5_5 = Asc($5_5)
			
;~ 			Display the numeric values for the characters
			ConsoleWrite($5_1 & @CRLF & $5_2 & @CRLF & $5_3 & @CRLF & $5_4 & @CRLF & $5_5 & @CRLF)
			
;~ 			Obtain the total for each of the numeric characters
			$5_total = $5_1 + $5_2 + $5_3 + $5_4 + $5_5
			
;~ 			Display the total for the numeric characters
			ConsoleWrite($5_total & @CRLF)
			
;~ 			Obtain the remainder for the numeric characters based upon even numbers (I.E. Determine if it is even)
			$5_final = Mod($5_total, 2)
			
;~ 			Display if it is even or odd, if odd value is 1 if even value is 0
			ConsoleWrite($5_final & @CRLF)
			
;~ 			Ok, add up all the final values to create a final value
			$final = $1_final + $2_final + $3_final + $4_final + $5_final
			
;~ 			Display the final total
			ConsoleWrite($final & @CRLF)
			
;~ 			If the final remainders of all of the parts put together is 3, it is a valid key
			If $final <= 1 Then
				MsgBox(64, "Valid Key", "Your key has been registered. Thank you for your support!")
			Else
				MsgBox(16, "Error", "Invalid key. You tried to cheat me :(")
			EndIf
	EndSwitch
WEnd
