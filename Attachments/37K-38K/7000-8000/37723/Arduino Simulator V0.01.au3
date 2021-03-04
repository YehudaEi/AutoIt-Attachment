#cs ----------------------------------------------------------------------------

 Author:         myName

 Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------

#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include <Array.au3>
; include

Global $pin[20]
Global $pin_button[20]
Global $pin_state[20]
Global $project_running = 0
Global $virtual_coil[1]
Global $counter[1]
Global $timer[1]
Global $timer_start[1]

$main = GUICreate("Arduino Simulator V0.01", 548, 538, 190, 82) ; Create a GUI windon

$button_run = GUICtrlCreateButton ("RUN", 200, 480, 50, 25)
GUICtrlSetState(-1, $GUI_DISABLE)
$button_stop = GUICtrlCreateButton ("STOP", 290, 480, 50, 25)
GUICtrlSetState(-1, $GUI_DISABLE)

#region Create Menu
$file_menu = GUICtrlCreateMenu ("File")
$open_menu = GUICtrlCreateMenuItem ("Open...", $file_menu)
$exit_menu = GUICtrlCreateMenuItem ("Exit", $file_menu)
$help_menu = GUICtrlCreateMenu ("Help")
$about_menu = GUICtrlCreateMenuItem ("About", $help_menu)
$how_to_menu = GUICtrlCreateMenuItem ("How To...", $help_menu)
#endregion
#region Create static graphics
GUICtrlCreateGraphic(110, 48, 345, 417)
GUICtrlSetColor(-1, 0x000000)
GUICtrlSetBkColor(-1, 0xA6CAF0)
GUICtrlCreateGraphic(182, 224, 65, 209)
GUICtrlSetColor(-1, 0xFFFFFF)
GUICtrlSetBkColor(-1, 0x000000)
GUICtrlCreateGraphic(302, 8, 81, 97)
GUICtrlSetColor(-1, 0xFFFFFF)
GUICtrlSetBkColor(-1, 0x000000)
GUICtrlCreateGraphic(126, 24, 65, 89)
GUICtrlSetColor(-1, 0xFFFFFF)
GUICtrlSetBkColor(-1, 0x000000)
GUICtrlCreateGraphic(198, 80, 49, 25)
GUICtrlSetColor(-1, 0xFFFFFF)
GUICtrlSetBkColor(-1, 0x000000)
GUICtrlCreateGraphic(310, 152, 33, 33)
GUICtrlSetColor(-1, 0xFFFFFF)
GUICtrlSetBkColor(-1, 0x000000)
GUICtrlCreateGraphic(252, 128, 25, 65)
GUICtrlSetColor(-1, 0xFFFFFF)
GUICtrlSetBkColor(-1, 0x000000)
GUICtrlCreateGraphic(252, 424, 49, 33)
GUICtrlSetColor(-1, 0xFFFFFF)
GUICtrlSetBkColor(-1, 0x000000)
GUICtrlCreateGraphic(230, 152, 17, 33)
GUICtrlSetColor(-1, 0xFFFFFF)
GUICtrlSetBkColor(-1, 0x000000)
#endregion
#cs
For $i = 0 To 19
	$pin_button[$i] = _create_pin_button($i)
	$pin[$i] = _create_pin_graphic($i)
Next
#ce
#cs
#region Create the pins and the buttons to toggle the pin state
Dim $pin[20]
Dim $pin_button[20]
For $i = 0 To 7
	$pin[$i] = GUICtrlCreateGraphic(435, 432-($i*23), 17, 21)
	GUICtrlSetColor(-1, 0x000000) ; Black color
	GUICtrlSetBkColor(-1, 0xA6CAF0) ; Same color as background 
	If $i=3 Or $i=5 Or $i=6 Then ; If the pin is with PWM (P-ulse W-idth M-odulation) capability then set the apropriate options
		$a="~"
	Else
		$a=""
	EndIf
	$pin_button[$i] = GUICtrlCreateButton ($i & $a, 460, 436-(23*$i), 25, 17)
	GUICtrlSetState (-1, $GUI_DISABLE)
Next
For $i = 8 To 13
	$pin[$i] = GUICtrlCreateGraphic(435, 236-(($i-8)*23), 17, 21)
	GUICtrlSetColor(-1, 0x000000)
	GUICtrlSetBkColor(-1, 0xA6CAF0)
	If $i=9 Or $i=10 Or $i=11 Then
		$a="~"
	Else
		$a=""
	EndIf
	$pin_button[$i] = GUICtrlCreateButton ($i & $a, 460, 240-(23*($i-8)), 25, 17)
	GUICtrlSetState (-1, $GUI_DISABLE)
Next
For $i = 14 To 19
	$pin[$i] = GUICtrlCreateGraphic(117, 321+(($i-14)*23), 17, 21)
	GUICtrlSetColor(-1, 0x000000)
	GUICtrlSetBkColor(-1, 0xA6CAF0)
	$pin_button[$i] = GUICtrlCreateButton ("A" & ($i-14), 80, 321+(23*($i-14)), 25, 17)
	GUICtrlSetState (-1, $GUI_DISABLE)
Next
#endregion
#ce

GUISetState(@SW_SHOW)

While 1
	$msg = GUIGetMsg()
	
	Switch $msg
		Case $GUI_EVENT_CLOSE
			Exit
		Case $exit_menu
			Exit
		Case $open_menu
			GUICtrlSetState($button_run, $GUI_ENABLE)
			$project = FileOpenDialog ("Open Project", @ScriptDir & "\", "NAG Projects (*.nag)", 3)
			If Not @error Then
				$b = _read_settings_from_file($project)
				For $i = 0 To 19
					_delete_pin($pin, $pin_button, $i)
					$pin_button[$i] = _create_pin_button($i)
					$pin[$i] = _create_pin_graphic($i)
					$pin_state[$i] = _set_pin($pin, $pin_button, $i, $b[$i][0], "LOW")
				Next
			EndIf
		Case $button_run
			$project_running = 1
			GUICtrlSetState($button_stop, $GUI_ENABLE)
			GUICtrlSetState($button_run, $GUI_DISABLE)
			$running = GUICtrlCreateLabel("Running", 100, 480, 50,25) ; Create a label showing that the simulator is running
			$c = _read_rules_from_file($project)
			ReDim $virtual_coil[_find_max_virt_coil($c)+1]
			ReDim $counter[_find_max_counter($c)+1]
			ReDim $timer[UBound($c)-1]
			For $i=0 To UBound($timer)-1
				$timer[$i] = "ON"
			Next
			ReDim $timer_start[UBound($c)-1]
			While $msg <> $button_stop
				$msg = GUIGetMsg()
				#region Toggle DI Buttons
				If $project_running = 1 Then
					For $i=0 To 19
						If $msg = $pin_button[$i] Then
							If GUICtrlRead($pin_state[$i]) = "LOW" Then
								$pin_state[$i] = _set_pin($pin, $pin_button, $i, "DI", "HIGH")
							ElseIf GUICtrlRead($pin_state[$i]) = "HIGH" Then
								$pin_state[$i] = _set_pin($pin, $pin_button, $i, "DI", "LOW")
							EndIf
						EndIf
					Next
				EndIf
				#endregion
				For $i=0 To UBound($c)-2
					$check_first = _check_rule_input($b, $c, $pin_state, $virtual_coil, $counter, $i, 1)
					$check_second = _check_rule_input($b, $c, $pin_state, $virtual_coil, $counter, $i, 2)
					$x = StringSplit($c[$i], "|", 2)
					If $timer[$i] = "ON" Then
						$timer_start[$i] = TimerInit()
						$timer[$i] = "OFF"
					EndIf
					If $x[4] = "OR" Then
						If $check_first = "GOOD" Or $check_second = "GOOD" Then
							#region Execute the rule output
						
						
							#endregion
						EndIf
					Else
						If $check_first = "GOOD" And $check_second = "GOOD" Then
							#region Execute the rule output
							$a=StringSplit($c[$i], "|", 2)
							If TimerDiff($timer_start[$i]) >= $a[11] Then
								$timer[$i] = "ON" ; If command executed then reset the timer
								If StringInStr($a[8], "Virtual_Coil") <> 0 Then ; Case output is a Virtual coil
									$virtual_coil[StringMid($a[8], 14)] = $a[10]
								ElseIf StringInStr($a[8], "Counter") <> 0 Then ; Case output is a Counter
									If $a[9] = "+" Then
										$counter[StringMid($a[8], 9)] += $a[10]
									ElseIf $a[9] = "-" Then
										$counter[StringMid($a[8], 9)] -= $a[10]
									EndIf
								Else ; case output is a Pin
									For $j=0 To 19
										If $a[8] = $b[$j][1] Then
											$x = $j
											ExitLoop
										EndIf
									Next
									If $a[9] = "=" Then
										If GUICtrlRead($pin_state[$x]) <> $a[10] Then
											$pin_state[$x] = _set_pin($pin, $pin_button, $x, $b[$x][0], $a[10])
										EndIf
									ElseIf $a[9] = "f(x)" Then
										$func = StringSplit($a[10], "\", 2)
										For $h=0 To 19 ; Find the pin number
											If $func[1] = $b[$h][1] Then
												$func_pin = $h
												ExitLoop
											EndIf
										Next
										If $func[2] = "*" Then
											$value = Number(GUICtrlRead($pin_state[$func_pin]) * $func[3])
											$value = Int($value*255/1024) ; map the value from the range of 0-1024 to a range of 0-255
											If GUICtrlRead($pin_state[$x]) <> $value Then
												$pin_state[$x] = _set_pin($pin, $pin_button, $x, $b[$x][0], $value)
											EndIf
										ElseIf $func[2] = "/" Then
											$value = Number(GUICtrlRead($pin_state[$func_pin]) / $func[3])
											$value = Int($value*255/1024) ; map the value from the range of 0-1024 to a range of 0-255
											If GUICtrlRead($pin_state[$x]) <> $value Then
												$pin_state[$x] = _set_pin($pin, $pin_button, $x, $b[$x][0], $value)
											EndIf
										ElseIf $func[2] = "+" Then
											$value = Number(GUICtrlRead($pin_state[$func_pin]) + $func[3])
											$value = Int($value*255/1024) ; map the value from the range of 0-1024 to a range of 0-255
											If GUICtrlRead($pin_state[$x]) <> $value Then
												$pin_state[$x] = _set_pin($pin, $pin_button, $x, $b[$x][0], $value)
											EndIf
										ElseIf $func[2] = "-" Then
											$value = Number(GUICtrlRead($pin_state[$func_pin]) - $func[3])
											$value = Int($value*255/1024) ; map the value from the range of 0-1024 to a range of 0-255
											If GUICtrlRead($pin_state[$x]) <> $value Then
												$pin_state[$x] = _set_pin($pin, $pin_button, $x, $b[$x][0], $value)
											EndIf
										EndIf
									EndIf
								EndIf
							EndIf
							#endregion
						EndIf
					EndIf
				Next
			WEnd
			$project_running = 0
			GUICtrlSetState($button_stop, $GUI_DISABLE)
			GUICtrlSetState($button_run, $GUI_ENABLE)
			GUICtrlDelete($running)
	EndSwitch
WEnd

#cs
Func _execute_rule_output($pins, $buttons, $states, $virtuals, $counters, $settings_array, $rules_array, $rule, $type_of_pin)
	Local $out[3]
	$y = 0
	$a=StringSplit($rules_array[$rule], "|", 2)
	$out[0] = $a[8]
	$out[1] = $a[9]
	$out[2] = $a[10]
	;_ArrayDisplay($out)
	If StringInStr($out[0], "Virtual_Coil") <> 0 Then ; Case output is a Virtual Coil
		$virtuals[StringMid($out[0], 14)] = $out[2]
		
	ElseIf StringInStr($out[0], "Counter") <> 0 Then ; Case output is a Counter
		If $out[1] = "+" Then
			$counters[StringMid($out[0], 9)] += $out[2]
		ElseIf $out[1] = "-" Then
			$counters[StringMid($out[0], 9)] -= $out[2]
		EndIf
	Else ; Case output is a Pin
		For $i=0 To 19 ; Find the pin number
			If $out[0] = $settings_array[$i][1] Then
				$out_pin = $i
				ExitLoop
			EndIf
		Next
		If $out[1] = "=" Then
			;ConsoleWrite(GUICtrlRead($states[$out_pin]) & " " & $out[2] & @LF)
			If GUICtrlRead($states[$out_pin]) <> $out[2] Then
				$states[$out_pin] = _set_pin($pins, $buttons, $out_pin, $settings_array[$out_pin][0], $out[2])
			EndIf
		ElseIf $out[1] = "f(x)" Then
			$func = StringSplit($out[2], "\", 2)
			For $i=0 To 19 ; Find the pin number
				If $func[1] = $settings_array[$i][1] Then
					$func_pin = $i
					ExitLoop
				EndIf
			Next
			If $func[2] = "*" Then
				$value = Number(GUICtrlRead($states[$func_pin]) * $func[3])
				;ConsoleWrite($value & @LF)
				;MsgBox (0,"", $out_pin)
				_set_pin($pins, $buttons, $out_pin, $settings_array[$out_pin][0], $value)
			ElseIf $func[2] = "/" Then
				$value = Number(GUICtrlRead($states[$func_pin]) / $func[3])
				_set_pin($pins, $buttons, $out_pin, $settings_array[$out_pin][0], $value)
			ElseIf $func[2] = "+" Then
				$value = Number(GUICtrlRead($states[$func_pin]) + $func[3])
				_set_pin($pins, $buttons, $out_pin, $settings_array[$out_pin][0], $value)
			ElseIf $func[2] = "-" Then
				$value = Number(GUICtrlRead($states[$func_pin]) - $func[3])
				_set_pin($pins, $buttons, $out_pin, $settings_array[$out_pin][0], $value)
			EndIf
		EndIf
	EndIf
	Return $states[$out_pin]
EndFunc
#ce

; #FUNCTION# =================================================================================================================================
; Name...........: 	_find_max_counter
; Description ...: 	Extracts the number of counters used at the project rules
; Parameters ....: 	$rules_array : Array containing the rules of the project
; Return values .: 	The number of counters used in the rules. If no counter used then returns 0
; ============================================================================================================================================
Func _find_max_counter($rules_array)
	$virt=0
	For $i=0 To UBound($rules_array)-1
		If StringInStr($rules_array[$i], "Counter") <> 0 Then
			$virt=1
		EndIf
	Next
	If $virt = 1 Then
		Local $temp[UBound($rules_array)-1]
		For $i=0 To UBound($temp)-1
			$a=StringSplit($rules_array[$i], "|", 2)
			If StringInStr($a[8], "Counter") <> 0 Then
				$temp[$i] = StringMid($a[8], 9)
			EndIf
		Next
		Return _ArrayMax($temp)
	Else
		Return 0
	EndIf
EndFunc

; #FUNCTION# =================================================================================================================================
; Name...........: 	_find_max_virt_coil
; Description ...: 	Extracts the number of virtual coils used at the project rules
; Parameters ....: 	$rules_array : Array containing the rules of the project
; Return values .: 	The number of virtual coils used in the rules. If no virtual coil used then returns 0
; ============================================================================================================================================
Func _find_max_virt_coil($rules_array)
	$virt=0
	For $i=0 To UBound($rules_array)-1
		If StringInStr($rules_array[$i], "Virtual_Coil") <> 0 Then
			$virt=1
		EndIf
	Next
	If $virt = 1 Then
		Local $temp[UBound($rules_array)-1]
		For $i=0 To UBound($temp)-1
			$a=StringSplit($rules_array[$i], "|", 2)
			If StringInStr($a[8], "Virtual_Coil") <> 0 Then
				$temp[$i] = StringMid($a[8], 14)
			EndIf
		Next
		Return _ArrayMax($temp)
	Else
		Return 0
	EndIf
EndFunc

; #FUNCTION# =================================================================================================================================
; Name...........: 	_check_rule_input
; Description ...: 	Checks a specific input (first or second) in a specific rule to see if they match
; Parameters ....: 	$settings_array : Array containing the pin settings and names (created from the _read_settings_from_file() function)
;					$rules_array : Array containing the rules (created from the _read_rules_from_file() function)
;					$states : Array containing the controlID's of the labels or input boxes next to the pin (created from the _set_pin() function)
;					$virtuals : Array containing the states of virtual coils
;					$counters : Array containing the values of counters
;					$rule : The number of the rule to match the inputs
;					$input : The input to check (first or second)
; Return values .: 	"GOOD" if the input matches with the rule or if the rule is empty in that input
;					"BAD" if the input doesn't match with the rule
; ============================================================================================================================================
Func _check_rule_input($settings_array, $rules_array, $states, $virtuals, $counters, $rule, $input)
	Local $in[3]
	Local $in_pin
	$result = "BAD"
	If $input = 1 Then
		$a=StringSplit($rules_array[$rule], "|", 2)
		$in[0] = $a[1]
		$in[1] = $a[2]
		$in[2] = $a[3]
	ElseIf $input = 2 Then
		$a=StringSplit($rules_array[$rule], "|", 2)
		$in[0] = $a[5]
		$in[1] = $a[6]
		$in[2] = $a[7]
	EndIf
	If $in[0] = "" Then
		$result = "GOOD"
	EndIf
	For $i=0 To 19
		If $in[0] = $settings_array[$i][1] Then
			$in_pin = $i
			ExitLoop
		EndIf
	Next
	If StringInStr($in[0], "Virtual_Coil") <> 0 Then ; Case input is a Virtual Coil
		If $in[1] = "=" Then
			If $virtuals[StringMid($in[0], 14)] = $in[2] Then
				$result = "GOOD"
			EndIf
		EndIf
	ElseIf StringInStr($in[0], "Counter") <> 0 Then ; Case input is a Counter
		If $in[1] = "=" Then
			If $counters[StringMid($in[0], 9)] = $in[2] Then
				$result = "GOOD"
			EndIf
		ElseIf $in[1] = ">" Then
			If $counters[StringMid($in[0], 9)] > $in[2] Then
				$result = "GOOD"
			EndIf
		ElseIf $in[1] = "<" Then
			If $counters[StringMid($in[0], 9)] < $in[2] Then
				$result = "GOOD"
			EndIf
		ElseIf $in[1] = ">=" Then
			If $counters[StringMid($in[0], 9)] >= $in[2] Then
				$result = "GOOD"
			EndIf
		ElseIf $in[1] = "<=" Then
			If $counters[StringMid($in[0], 9)] <= $in[2] Then
				$result = "GOOD"
			EndIf
		EndIf
	Else ; Case input is a Pin
		If $in[1] = "=" Then
			If GUICtrlRead($states[$in_pin]) = $in[2] Then
			$result = "GOOD"
			EndIf
		ElseIf $in[1] = ">" Then
			If GUICtrlRead($states[$in_pin]) > Number($in[2]) Then
			$result = "GOOD"
			EndIf
		ElseIf $in[1] = "<" Then
			If GUICtrlRead($states[$in_pin]) < Number($in[2]) Then
			$result = "GOOD"
			EndIf
		ElseIf $in[1] = ">=" Then
			If GUICtrlRead($states[$in_pin]) >= Number($in[2]) Then
			$result = "GOOD"
			EndIf
		ElseIf $in[1] = "<=" Then
			If GUICtrlRead($states[$in_pin]) <= Number($in[2]) Then
			$result = "GOOD"
			EndIf
		EndIf
	EndIf
	;If $rule = 9 then
	;	ConsoleWrite ($rule & ": " & $in[0] & "_" & GUICtrlRead($states[$in_pin]) & " " & $result & @LF)
	;endif
	Return $result
EndFunc

; #FUNCTION# =================================================================================================================================
; Name...........: 	_create_pin_button
; Description ...: 	Creates the button representing the created pin
; Parameters ....: 	$pin_number : The number of the pin to create
; Return values .: 	ControlID of the created button
; ============================================================================================================================================
Func _create_pin_button($pin_number)
	If $pin_number <= 7 Then
		If $pin_number=3 Or $pin_number=5 Or $pin_number=6 Then ; If the pin is with PWM (P-ulse W-idth M-odulation) capability then set the apropriate options
			$a="~"
		Else
			$a=""
		EndIf
		$button = GUICtrlCreateButton ($pin_number & $a, 460, 436-(23*$pin_number), 25, 17)
		GUICtrlSetState (-1, $GUI_DISABLE)
	ElseIf $pin_number >= 8 And $pin_number < 14 Then
		If $pin_number=9 Or $pin_number=10 Or $pin_number=11 Then
			$a="~"
		Else
			$a=""
		EndIf
		$button = GUICtrlCreateButton ($pin_number & $a, 460, 240-(23*($pin_number-8)), 25, 17)
		GUICtrlSetState (-1, $GUI_DISABLE)
	ElseIf $pin_number >= 14 Then
		$button = GUICtrlCreateButton ("A" & ($pin_number-14), 80, 321+(23*($pin_number-14)), 25, 17)
		GUICtrlSetState (-1, $GUI_DISABLE)
	EndIf
	Return $button
EndFunc

; #FUNCTION# =================================================================================================================================
; Name...........: 	_create_pin_graphic
; Description ...: 	Creates the graphic representing the created pin
; Parameters ....: 	$pin_number : 
; Return values .: 	ControlID of the created graphic
; ============================================================================================================================================
Func _create_pin_graphic($pin_number)
	If $pin_number <= 7 Then
		$pin_graphic = GUICtrlCreateGraphic(435, 432-($pin_number*23), 17, 21)
		GUICtrlSetColor(-1, 0x000000) ; Black color
		GUICtrlSetBkColor(-1, 0xA6CAF0) ; Same color as background 
	ElseIf $pin_number >= 8 And $pin_number < 14 Then
		$pin_graphic = GUICtrlCreateGraphic(435, 236-(($pin_number-8)*23), 17, 21)
		GUICtrlSetColor(-1, 0x000000)
		GUICtrlSetBkColor(-1, 0xA6CAF0)
	ElseIf $pin_number >= 14 Then
		$pin_graphic = GUICtrlCreateGraphic(117, 321+(($pin_number-14)*23), 17, 21)
		GUICtrlSetColor(-1, 0x000000)
		GUICtrlSetBkColor(-1, 0xA6CAF0)
	EndIf
	Return $pin_graphic
EndFunc

; #FUNCTION# =================================================================================================================================
; Name...........: 	_delete_pin
; Description ...: 	Deletes the pin and the button
; Parameters ....: 	$pins :	Array containing the ControlID's of the graphics representing each pin
;					$buttons : Array containing the ControlID's of the buttons representing each pin
;					$pin_number : The number of pin to delete
; Return values .: 	An array containing the ControlID's of the labels or the input boxes created
; ============================================================================================================================================
Func _delete_pin($pins, $buttons, $pin_number)
	GUICtrlDelete($pins[$pin_number])
	GUICtrlDelete($buttons[$pin_number])
EndFunc

; #FUNCTION# =================================================================================================================================
; Name...........: 	_set_pin($pins, $buttons, $pin_number, $pin_type, $pin_state, $pin_value = 0)
; Description ...: 	Sets the given pin according to its parameters
; Parameters ....: 	$pins :	Array containing the ControlID's of the graphics representing each pin
;					$buttons : Array containing the ControlID's of the buttons representing each pin
;					$pin_number : The number of pin to set
;					$pin_type : DI or DO or AI or AO
;					$pin_state : HIGH or LOW
; 					$pin_value : The value of the pin (Only in case of an analog pin)
; Return values .: 	ControlID of the label or the input boxe created
; ============================================================================================================================================
Func _set_pin($pins, $buttons, $pin_number, $pin_type, $pin_state);, $pin_value = 0)
	$pin_label = ""
	If $pin_number < 8 Then
		If $pin_type = "DI" Then
			GUICtrlSetState($buttons[$pin_number], $GUI_ENABLE)
			If $pin_state = "LOW" Then
				GUICtrlSetBkColor($pins[$pin_number], 0xFF0000) ; Red
				$pin_label = GUICtrlCreateLabel("LOW", 490, 437-($pin_number*23), 30, 21)
			ElseIf $pin_state = "HIGH" Then
				GUICtrlSetBkColor($pins[$pin_number], 0x00FF00) ; Green
				$pin_label = GUICtrlCreateLabel("HIGH", 490, 437-($pin_number*23), 30, 21)
			EndIf
		ElseIf $pin_type = "DO" Then
			If $pin_state = "LOW" Then
				GUICtrlSetBkColor($pins[$pin_number], 0xFF0000) ; Red
				$pin_label = GUICtrlCreateLabel("LOW", 490, 437-($pin_number*23), 30, 21)
			ElseIf $pin_state = "HIGH" Then
				GUICtrlSetBkColor($pins[$pin_number], 0x00FF00) ; Green
				$pin_label = GUICtrlCreateLabel("HIGH", 490, 437-($pin_number*23), 30, 21)
			EndIf
		ElseIf $pin_type = "AO" Then
			GUICtrlSetBkColor($pins[$pin_number], 0x0000FF) ; Blue
			$pin_label = GUICtrlCreateInput($pin_state, 490, 437-($pin_number*23), 30, 21, 0x0880);;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		Else
			$pin_label = GUICtrlCreateLabel("-", 490, 437-($pin_number*23), 5, 21)
		EndIf
	ElseIf $pin_number >=8 And $pin_number < 14 Then
		If $pin_type = "DI" Then
			GUICtrlSetState($buttons[$pin_number], $GUI_ENABLE)
			If $pin_state = "LOW" Then
				GUICtrlSetBkColor($pins[$pin_number], 0xFF0000) ; Red
				$pin_label = GUICtrlCreateLabel("LOW", 490, 241-(($pin_number-8)*23), 30, 21)
			ElseIf $pin_state = "HIGH" Then
				GUICtrlSetBkColor($pins[$pin_number], 0x00FF00) ; Green
				$pin_label = GUICtrlCreateLabel("HIGH", 490, 241-(($pin_number-8)*23), 30, 21)
			EndIf
		ElseIf $pin_type = "DO" Then
			If $pin_state = "LOW" Then
				GUICtrlSetBkColor($pins[$pin_number], 0xFF0000) ; Red
				$pin_label = GUICtrlCreateLabel("LOW", 490, 241-(($pin_number-8)*23), 30, 21)
			ElseIf $pin_state = "HIGH" Then
				GUICtrlSetBkColor($pins[$pin_number], 0x00FF00) ; Green
				$pin_label = GUICtrlCreateLabel("HIGH", 490, 241-(($pin_number-8)*23), 30, 21)
			EndIf
		ElseIf $pin_type = "AO" Then
			GUICtrlSetBkColor($pins[$pin_number], 0x0000FF) ; Blue
			$pin_label = GUICtrlCreateInput($pin_state, 490, 241-(($pin_number-8)*23), 30, 21, 0x0880);;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		Else
			$pin_label = GUICtrlCreateLabel("-", 490, 241-(($pin_number-8)*23), 5, 21)
		EndIf
	ElseIf $pin_number >= 14 Then
		If $pin_type = "DI" Then
			GUICtrlSetState($buttons[$pin_number], $GUI_ENABLE)
			If $pin_state = "LOW" Then
				GUICtrlSetBkColor($pins[$pin_number], 0xFF0000) ; Red
				$pin_label = GUICtrlCreateLabel("LOW", 47, 323+(($pin_number-14)*23), 30, 21)
			ElseIf $pin_state = "HIGH" Then
				GUICtrlSetBkColor($pins[$pin_number], 0x00FF00) ; Green
				$pin_label = GUICtrlCreateLabel("HIGH", 47, 323+(($pin_number-14)*23), 30, 21)
			EndIf
		ElseIf $pin_type = "DO" Then
			If $pin_state = "LOW" Then
				GUICtrlSetBkColor($pins[$pin_number], 0xFF0000) ; Red
				$pin_label = GUICtrlCreateLabel("LOW", 47, 323+(($pin_number-14)*23), 30, 21)
			ElseIf $pin_state = "HIGH" Then
				GUICtrlSetBkColor($pins[$pin_number], 0x00FF00) ; Green
				$pin_label = GUICtrlCreateLabel("HIGH", 47, 323+(($pin_number-14)*23), 30, 21)
			EndIf
		ElseIf $pin_type = "AI" Then
			GUICtrlSetBkColor($pins[$pin_number], 0x0000FF) ; Blue
			$pin_label = GUICtrlCreateInput("", 17, 323+(($pin_number-14)*23), 60, 21, 0x0080)
			GUICtrlCreateUpdown(-1, 0xA0)
		Else
			$pin_label = GUICtrlCreateLabel("-", 67, 323+(($pin_number-14)*23), 5, 21)
		EndIf
	EndIf
	Return ($pin_label)
EndFunc

; #FUNCTION# =================================================================================================================================
; Name...........: 	_read_rules_from_file
; Description ...: 	Reads the rules from a file previously created from the _write_project_to_file() function
; Parameters ....: 	The full name of the file to read from
; Return values .: 	An array containing the read rules
; ============================================================================================================================================
Func _read_rules_from_file($file_name="")
	If $file_name="" Then
		$project_name = FileOpenDialog ("Open Project", @ScriptDir & "\", "NAG Projects (*.nag)", 3)
	Else
		$project_name = $file_name
	EndIf
	Local $rules[1]
	$file=FileOpen($project_name, 0)
	While 1	
		$line = FileReadLine($file)
		If StringInStr($line, "Rules_START") <> 0 Then
			$x=0
			While StringInStr($line, "Rules_END") = 0
				$line = FileReadLine($file)
				If StringInStr($line, "|") <> 0 Then
					$rules[$x] = $line
					ReDim $rules[$x+2]
					$x += 1
				EndIf
			WEnd
			ExitLoop
		EndIf
	WEnd
	Return $rules
EndFunc

; #FUNCTION# =================================================================================================================================
; Name...........: 	_read_settings_from_file
; Description ...: 	Reads the pin settings from a file previously created from the _write_project_to_file() function
; Parameters ....: 	The full name of the file to read from
; Return values .: 	An array containing the pin settings and names
; ============================================================================================================================================
Func _read_settings_from_file($file_name="")
	If $file_name="" Then
		$project_name = FileOpenDialog ("Open Project", @ScriptDir & "\", "NAG Projects (*.nag)", 3)
	Else
		$project_name = $file_name
	EndIf
	Local $settings[20][2]
	$file=FileOpen($project_name, 0)
	While 1
		$line = FileReadLine($file)
		If StringInStr($line, "Settings_START") <> 0 Then
			$x=0
			While StringInStr($line, "Settings_END") = 0
				$line = FileReadLine($file)
				If StringInStr($line, ":") <> 0 Then ; without this check script crash
					$a=StringSplit($line, ":", 2)
					$settings[$x][0] = $a[1]
					$settings[$x][1] = $a[2]
					$x += 1
				EndIf
			WEnd
			ExitLoop
		EndIf
	WEnd
	Return $settings
EndFunc
