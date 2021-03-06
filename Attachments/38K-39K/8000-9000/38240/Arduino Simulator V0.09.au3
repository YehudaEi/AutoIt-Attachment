#cs -Program Comments-
 AutoIt Version: 3.3.6.1
 Author: Liapis Nikos
 Script Name: Arduino Simulator
 Script Description: A Arduino "pseudo" simulator.
 Date: 29-7-2012
 Version: 0.09
 Version changes:	0.02) Counters increase (or dicrease) only when the triger input changes condition
					0.03) Bug fixed: Counters were not increased (or dicreased) correctly when the same counter was declared in more than one rule
					0.04) Display the type of each pin next to the pin
					0.05) Create a list view which shows the rules of the project, so that the user can check on them when testing
						  Show the name of the current project on the window title
						  Bug fixed: Delete the labels that shows the pin state when a second project is opened
						  When the project doesn't have any Rules, Display an error message
						  The How to... under the help menu is active
					0.06) Show the pin name next the pin
					0.07) Corrections made to handle the new "Compare" feature
					0.08) Show control tips when mouse hovers over them
					0.09) User can view in real time the states and values of Virtual Coils and Counters
 Corrections needed: 
#ce

#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include <Array.au3>
#Include <GuiListView.au3>
; include


Global $version = "0.09"
Global $release_date = "29-7-2012"
Global $project_name = "..."
Global $pin[20]
Global $pin_button[20]
Global $pin_state[20]
Global $pin_type_label[20]
Global $project_running = 0
Global $virtual_coil[1]
Global $counter[1]
Global $counter_changed[1]
Global $timer[1]
Global $timer_start[1]
Global $timer_diff[1]
Global $timer_mark[1]

$main = GUICreate("Arduino Simulator V" & $version & " - " & $project_name, 1100, 538, 70, 82) ; Create a GUI windon
#cs
#region Create List
$List = GUICtrlCreateListView("Rule|Input A|Is|Value|AND/OR|Input B|Is|Value|Output|Is|Value|Delay", 530, 10, 540, 460,-1, 0x00000001)
_GUICtrlListView_SetColumnWidth($list, 0, 36)
_GUICtrlListView_SetColumnWidth($list, 1, 55)
_GUICtrlListView_SetColumnWidth($list, 2, 30)
_GUICtrlListView_SetColumnWidth($list, 3, 45)
_GUICtrlListView_SetColumnWidth($list, 4, 60)
_GUICtrlListView_SetColumnWidth($list, 5, 55)
_GUICtrlListView_SetColumnWidth($list, 6, 30)
_GUICtrlListView_SetColumnWidth($list, 7, 45)
_GUICtrlListView_SetColumnWidth($list, 8, 55)
_GUICtrlListView_SetColumnWidth($list, 9, 30)
_GUICtrlListView_SetColumnWidth($list, 10, 45)
_GUICtrlListView_SetColumnWidth($list, 11, 50)
#endregion
#ce
#region Create Buttons
$button_run = GUICtrlCreateButton ("RUN", 200, 480, 50, 25)
GUICtrlSetState(-1, $GUI_DISABLE)
GUICtrlSetTip (-1, "Start Simulation")
$button_stop = GUICtrlCreateButton ("STOP", 290, 480, 50, 25)
GUICtrlSetState(-1, $GUI_DISABLE)
GUICtrlSetTip (-1, "Stop Simulation")
$button_show_rules = GUICtrlCreateButton("Show Rules", 600, 480, 110, 25)
GUICtrlSetState(-1, $GUI_DISABLE)
GUICtrlSetTip (-1, "Show The Project's Rules")
$button_show_states = GUICtrlCreateButton("Show Virtual States", 800, 480, 110, 25)
GUICtrlSetState(-1, $GUI_DISABLE)
GUICtrlSetTip (-1, "Show The State of Each Virtual Coil and Counter")
#endregion
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
GUISetState(@SW_SHOW)

$a = MouseGetPos(0)
ToolTip("Open A Project" & @LF & "And Press RUN To Execute", 90, 122, "", 0, 1)
While 1
	$b = MouseGetPos(0)
	If $a <> $b Then
		ToolTip("")
		ExitLoop
	EndIf
WEnd

While 1
	$msg = GUIGetMsg()
	Switch $msg
		Case $GUI_EVENT_CLOSE
			Exit
		Case $how_to_menu
			ShellExecute("http://codikia.blogspot.gr/2012/06/tutorial-for-arduino-simulator.html")
		Case $exit_menu
			Exit
		Case $open_menu
			$project = FileOpenDialog ("Open Project", @ScriptDir & "\", "NAG Projects (*.nag)", 3)
			$project_full_name = StringSplit($project, "\")
			$project_name = $project_full_name[$project_full_name[0]]
			WinSetTitle("Arduino Simulator", "", "Arduino Simulator V" & $version & " - " & $project_name)
			If $project <> "" Then
				$file = FileOpen($project, 0)
				$header = FileReadLine($file)
				If $header = "NAG FILE V.020" Or $header = "NAG FILE V.030" Then
					$b = _read_settings_from_file($project)
					For $i = 0 To 19
						_delete_pin($pin, $pin_button, $pin_type_label, $i)
						$pin_button[$i] = _create_pin_button($i)
						$pin[$i] = _create_pin_graphic($i)
						$pin_state[$i] = _set_pin($pin, $pin_button, $i, $b[$i][0], "LOW")
						If $i < 14 Then
							$pin_type_label[$i] = _create_pin_type_label($i, $b[$i][1] & ". " & $b[$i][0])
						Else
							$pin_type_label[$i] = _create_pin_type_label($i, $b[$i][0] & ". " & $b[$i][1])
						EndIf
					Next
					$c = _read_rules_from_file($project)
					If UBound($c) = 1 And $c[0] = "" Then
						MsgBox(16, "ERROR", "The Project Doesn't Have Any Rules")
					Else
						GUICtrlSetState($button_run, $GUI_ENABLE)
						GUICtrlSetState($button_show_rules, $GUI_ENABLE)
						GUICtrlSetState($button_show_states, $GUI_ENABLE)
					EndIf
					#cs
					GUICtrlDelete($list)
					#region Create List
					$List = GUICtrlCreateListView("Rule|Input A|Is|Value|AND/OR|Input B|Is|Value|Output|Is|Value|Delay", 530, 10, 540, 460,-1, 0x00000001)
					_GUICtrlListView_SetColumnWidth($list, 0, 36)
					_GUICtrlListView_SetColumnWidth($list, 1, 55)
					_GUICtrlListView_SetColumnWidth($list, 2, 30)
					_GUICtrlListView_SetColumnWidth($list, 3, 45)
					_GUICtrlListView_SetColumnWidth($list, 4, 60)
					_GUICtrlListView_SetColumnWidth($list, 5, 55)
					_GUICtrlListView_SetColumnWidth($list, 6, 30)
					_GUICtrlListView_SetColumnWidth($list, 7, 45)
					_GUICtrlListView_SetColumnWidth($list, 8, 55)
					_GUICtrlListView_SetColumnWidth($list, 9, 30)
					_GUICtrlListView_SetColumnWidth($list, 10, 45)
					_GUICtrlListView_SetColumnWidth($list, 11, 50)
					#endregion
					For $i=0 To UBound($c)-2
						GUICtrlCreateListViewItem($c[$i], $list)
					Next
					#ce
				Else
					MsgBox (16, "ERROR", "File Not Compatible")
				EndIf
			EndIf
		Case $button_show_rules
			If IsDeclared("list_states") <> 0 Then GUICtrlDelete($list_states)
			#region Create List
			$List = GUICtrlCreateListView("Rule|Input A|Is|Value|AND/OR|Input B|Is|Value|Output|Is|Value|Delay", 530, 10, 540, 460,-1, 0x00000001)
			_GUICtrlListView_SetColumnWidth($list, 0, 36)
			_GUICtrlListView_SetColumnWidth($list, 1, 55)
			_GUICtrlListView_SetColumnWidth($list, 2, 30)
			_GUICtrlListView_SetColumnWidth($list, 3, 45)
			_GUICtrlListView_SetColumnWidth($list, 4, 60)
			_GUICtrlListView_SetColumnWidth($list, 5, 55)
			_GUICtrlListView_SetColumnWidth($list, 6, 30)
			_GUICtrlListView_SetColumnWidth($list, 7, 45)
			_GUICtrlListView_SetColumnWidth($list, 8, 55)
			_GUICtrlListView_SetColumnWidth($list, 9, 30)
			_GUICtrlListView_SetColumnWidth($list, 10, 45)
			_GUICtrlListView_SetColumnWidth($list, 11, 50)
			#endregion
			For $i=0 To UBound($c)-2
				GUICtrlCreateListViewItem($c[$i], $list)
			Next
		Case $button_show_states
			If IsDeclared("list") <> 0 Then GUICtrlDelete($list)
			$list_states = GUICtrlCreateListView("Virtual Coil|State| |Counter|Value", 530, 10, 540, 460,-1, 0x00000001)
			_GUICtrlListView_SetColumnWidth($list_states, 0, 120)
			_GUICtrlListView_SetColumnWidth($list_states, 1, 60)
			_GUICtrlListView_SetColumnWidth($list_states, 2, 150)
			_GUICtrlListView_SetColumnWidth($list_states, 3, 120)
			_GUICtrlListView_SetColumnWidth($list_states, 4, 60)
			$amount_virtuals = _find_max_virt_coil($c)
			$amount_counters = _find_max_counter($c)
			$list_states_items = _create_list_states($amount_virtuals, $amount_counters)
		Case $button_run
			$project_running = 1
			GUICtrlSetState($button_stop, $GUI_ENABLE)
			GUICtrlSetState($button_run, $GUI_DISABLE)
			GUICtrlSetState($button_show_rules, $GUI_DISABLE)
			GUICtrlSetState($button_show_states, $GUI_DISABLE)
			$running = GUICtrlCreateLabel("Running", 100, 480, 50,25) ; Create a label showing that the simulator is running
			;$c = _read_rules_from_file($project)
			ReDim $virtual_coil[_find_max_virt_coil($c)+1]
			ReDim $counter[_find_max_counter($c)+1]
			ReDim $counter_changed[UBound($counter)]
			For $i=0 To UBound($counter_changed)-1
				$counter_changed[$i] = "First_value"
			Next
			ReDim $timer[UBound($c)-1]
			For $i=0 To UBound($timer)-1
				$timer[$i] = "ON"
			Next
			ReDim $timer_start[UBound($c)-1]
			ReDim $timer_diff[UBound($c)-1]
			ReDim $timer_mark[UBound($c)-1]
			For $i=0 To UBound($timer_mark)-1
				$timer_mark[$i] = 0
			Next
			While $msg <> $button_stop
				$msg = GUIGetMsg()
				#region Limit the analog inputs
				If $project_running = 1 Then
					For $i=0 To 19
						If $b[$i][0] = "AI" Then
							If GUICtrlRead($pin_state[$i]) > 1024 Then
								GUICtrlSetData($pin_state[$i], 1024)
							ElseIf GUICtrlRead($pin_state[$i]) < 0 Then
								GUICtrlSetData($pin_state[$i], 0)
							EndIf
						EndIf
					Next
				EndIf
				#endregion
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
				For $i=0 To UBound($c)-2 ; Loop over the loops
					$check_first = _check_rule_input($b, $c, $pin_state, $virtual_coil, $counter, $i, 1)
					$check_second = _check_rule_input($b, $c, $pin_state, $virtual_coil, $counter, $i, 2)
					$x = StringSplit($c[$i], "|", 2)
					If $check_first <> "GOOD" Or $check_second <> "GOOD" Then
						$timer_mark[$i] = 0
						If $i = $counter_changed[StringMid($x[8], 9)]Then
							$counter_changed[StringMid($x[8], 9)] = "whatever"
						EndIf
					EndIf
					If $x[4] = "OR" Then
						If $check_first = "GOOD" Or $check_second = "GOOD" Then
							#region Execute the rule output
							If $timer_mark[$i] = 0 Then
								If $timer[$i] = "ON"Then
									$timer_start[$i] = TimerInit()
									$timer[$i] = "OFF"
								EndIf
							EndIf
							$a=StringSplit($c[$i], "|", 2)
							$timer_diff[$i] = TimerDiff($timer_start[$i])
							If $timer_diff[$i] >= $a[11] Then
								$timer[$i] = "ON"
								$timer_diff[$i] = 0
								$timer_mark[$i] = 1
								If StringInStr($a[8], "Virtual_Coil") <> 0 Then ; Case output is a Virtual coil
									$virtual_coil[StringMid($a[8], 14)] = $a[10]
									If IsDeclared("list_states_items") <> 0 Then _update_list_states_item(StringMid($a[8], 14)-1, "virtual_type", $a[10], $list_states_items)
								ElseIf StringInStr($a[8], "Counter") <> 0 Then ; Case output is a Counter
									If $a[9] = "+" And $counter_changed[StringMid($a[8], 9)] <> String($i) Then
										$counter[StringMid($a[8], 9)] += $a[10]
										If IsDeclared("list_states_items") <> 0 Then _update_list_states_item(StringMid($a[8], 9)-1, "counter_type", $counter[StringMid($a[8], 9)], $list_states_items)
										$counter_changed[StringMid($a[8], 9)] = $i
									ElseIf $a[9] = "-" And $counter_changed[StringMid($a[8], 9)] <> String($i) Then
										$counter[StringMid($a[8], 9)] -= $a[10]
										If IsDeclared("list_states_items") <> 0 Then _update_list_states_item(StringMid($a[8], 9)-1, "counter_type", $counter[StringMid($a[8], 9)], $list_states_items)
										$counter_changed[StringMid($a[8], 9)] = $i
									ElseIf $a[9] = "=" And $counter_changed[StringMid($a[8], 9)] <> String($i) Then
										$counter[StringMid($a[8], 9)] = $a[10]
										If IsDeclared("list_states_items") <> 0 Then _update_list_states_item(StringMid($a[8], 9)-1, "counter_type", $counter[StringMid($a[8], 9)], $list_states_items)
										$counter_changed[StringMid($a[8], 9)] = $i
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
											If $value > 255 Then $value = 255
											If $value < 0 Then $value = 0
											If GUICtrlRead($pin_state[$x]) <> $value Then
												$pin_state[$x] = _set_pin($pin, $pin_button, $x, $b[$x][0], $value)
											EndIf
										ElseIf $func[2] = "/" Then
											$value = Number(GUICtrlRead($pin_state[$func_pin]) / $func[3])
											$value = Int($value*255/1024) ; map the value from the range of 0-1024 to a range of 0-255
											If $value > 255 Then $value = 255
											If $value < 0 Then $value = 0
											If GUICtrlRead($pin_state[$x]) <> $value Then
												$pin_state[$x] = _set_pin($pin, $pin_button, $x, $b[$x][0], $value)
											EndIf
										ElseIf $func[2] = "+" Then
											$value = Number(GUICtrlRead($pin_state[$func_pin]) + $func[3])
											$value = Int($value*255/1024) ; map the value from the range of 0-1024 to a range of 0-255
											If $value > 255 Then $value = 255
											If $value < 0 Then $value = 0
											If GUICtrlRead($pin_state[$x]) <> $value Then
												$pin_state[$x] = _set_pin($pin, $pin_button, $x, $b[$x][0], $value)
											EndIf
										ElseIf $func[2] = "-" Then
											$value = Number(GUICtrlRead($pin_state[$func_pin]) - $func[3])
											$value = Int($value*255/1024) ; map the value from the range of 0-1024 to a range of 0-255
											If $value > 255 Then $value = 255
											If $value < 0 Then $value = 0
											If GUICtrlRead($pin_state[$x]) <> $value Then
												$pin_state[$x] = _set_pin($pin, $pin_button, $x, $b[$x][0], $value)
											EndIf
										EndIf
									EndIf
								EndIf
							EndIf
							#endregion
						EndIf
					Else
						If $check_first = "GOOD" And $check_second = "GOOD" Then
							#region Execute the rule output
							If $timer_mark[$i] = 0 Then
								If $timer[$i] = "ON"Then
									$timer_start[$i] = TimerInit()
									$timer[$i] = "OFF"
								EndIf
							EndIf
							$a=StringSplit($c[$i], "|", 2)
							$timer_diff[$i] = TimerDiff($timer_start[$i])
							If $timer_diff[$i] >= $a[11] Then
								$timer[$i] = "ON"
								$timer_diff[$i] = 0
								$timer_mark[$i] = 1
								If StringInStr($a[8], "Virtual_Coil") <> 0 Then ; Case output is a Virtual coil
									$virtual_coil[StringMid($a[8], 14)] = $a[10]
									If IsDeclared("list_states_items") <> 0 Then _update_list_states_item(StringMid($a[8], 14)-1, "virtual_type", $a[10], $list_states_items)
								ElseIf StringInStr($a[8], "Counter") <> 0 Then ; Case output is a Counter
									If $a[9] = "+" And $counter_changed[StringMid($a[8], 9)] <> String($i) Then
										$counter[StringMid($a[8], 9)] += $a[10]
										If IsDeclared("list_states_items") <> 0 Then _update_list_states_item(StringMid($a[8], 9)-1, "counter_type", $counter[StringMid($a[8], 9)], $list_states_items)
										$counter_changed[StringMid($a[8], 9)] = $i
									ElseIf $a[9] = "-" And $counter_changed[StringMid($a[8], 9)] <> String($i) Then
										$counter[StringMid($a[8], 9)] -= $a[10]
										If IsDeclared("list_states_items") <> 0 Then _update_list_states_item(StringMid($a[8], 9)-1, "counter_type", $counter[StringMid($a[8], 9)], $list_states_items)
										$counter_changed[StringMid($a[8], 9)] = $i
									ElseIf $a[9] = "=" And $counter_changed[StringMid($a[8], 9)] <> String($i) Then
										$counter[StringMid($a[8], 9)] = $a[10]
										If IsDeclared("list_states_items") <> 0 Then _update_list_states_item(StringMid($a[8], 9)-1, "counter_type", $counter[StringMid($a[8], 9)], $list_states_items)
										$counter_changed[StringMid($a[8], 9)] = $i
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
											If $value > 255 Then $value = 255
											If $value < 0 Then $value = 0
											If GUICtrlRead($pin_state[$x]) <> $value Then
												$pin_state[$x] = _set_pin($pin, $pin_button, $x, $b[$x][0], $value)
											EndIf
										ElseIf $func[2] = "/" Then
											$value = Number(GUICtrlRead($pin_state[$func_pin]) / $func[3])
											$value = Int($value*255/1024) ; map the value from the range of 0-1024 to a range of 0-255
											If $value > 255 Then $value = 255
											If $value < 0 Then $value = 0
											If GUICtrlRead($pin_state[$x]) <> $value Then
												$pin_state[$x] = _set_pin($pin, $pin_button, $x, $b[$x][0], $value)
											EndIf
										ElseIf $func[2] = "+" Then
											$value = Number(GUICtrlRead($pin_state[$func_pin]) + $func[3])
											$value = Int($value*255/1024) ; map the value from the range of 0-1024 to a range of 0-255
											If $value > 255 Then $value = 255
											If $value < 0 Then $value = 0
											If GUICtrlRead($pin_state[$x]) <> $value Then
												$pin_state[$x] = _set_pin($pin, $pin_button, $x, $b[$x][0], $value)
											EndIf
										ElseIf $func[2] = "-" Then
											$value = Number(GUICtrlRead($pin_state[$func_pin]) - $func[3])
											$value = Int($value*255/1024) ; map the value from the range of 0-1024 to a range of 0-255
											If $value > 255 Then $value = 255
											If $value < 0 Then $value = 0
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
			GUICtrlSetState($button_show_rules, $GUI_ENABLE)
			GUICtrlSetState($button_show_states, $GUI_ENABLE)
		Case $about_menu
			$about_win = GUICreate("About", 400, 250, 298, 120)
			GUICtrlCreateLabel("--- ARDUINO SIMULATOR ----" & @LF & @LF & @LF & "Version : V" & $version & @LF & @LF & "Date : " & $release_date & @LF _
			& @LF & "Created By : Liapis Nikos" & @LF & @LF & "Special Thanks To : Martin, Melba23 and the Autoit community "& @LF & @LF & "Updates Available on :", 5, 5, 361, 160)
			$button_link_autoit = GUICtrlCreateButton("http://www.autoitscript.com/forum/topic/138727-arduino-gui-programmer/", 5, 165, 380, 25)
			GUICtrlSetColor(-1, 0x0000FF)
			$button_link_codikia = GUICtrlCreateButton("http://codikia.blogspot.com/2012/03/simple-arduino-gui-programmer.html", 5, 205, 380, 25)
			GUICtrlSetColor(-1, 0x0000FF)
			GUISetState(@SW_SHOW)
			While 1
				$nMsg = GUIGetMsg()
				Switch $nMsg
					Case $GUI_EVENT_CLOSE
						ExitLoop
					Case $button_link_autoit
						ShellExecute ("http://www.autoitscript.com/forum/topic/138727-arduino-gui-programmer/")
					Case $button_link_codikia
						ShellExecute ("http://codikia.blogspot.com/2012/03/simple-arduino-gui-programmer.html")
				EndSwitch
			WEnd
			GUIDelete ($about_win)
	EndSwitch
WEnd

; #FUNCTION#
; Name...........: 	_update_list_states_item
; Description ...: 	Update the state of a Virtual Coil or the value of a counter in in the ListView
; Parameters ....: 	$item: The number of item to be updated
;					$type: The type of Virtual to be updated (Virtual Coil or Counter)
;					$state: The state or value to be updated at
;					$items: An array containing the controlIDs fo the ListViewItems
; Return values .: 	The controlID of the changed item
; ============================================================================================================================================
Func _update_list_states_item($item, $type, $state, $items)
	If $type = "virtual_type" Then
		$hall=GUICtrlRead($items[$item])
		$part = StringSplit($hall, "|", 2)
		If $part[1] <> $state Then
			$part[1] = $state
			$write_item = _ArrayToString($part, "|")
			GUICtrlSetData($items[$item], $write_item)
		EndIf
		Return $items[$item]
	ElseIf $type = "counter_type" Then
		$hall=GUICtrlRead($items[$item])
		$part = StringSplit($hall, "|", 2)
		If $part[4] <> $state Then
			$part[4] = $state
			$write_item = _ArrayToString($part, "|")
			GUICtrlSetData($items[$item], $write_item)
		EndIf
		Return $items[$item]
	EndIf
EndFunc

; #FUNCTION#
; Name...........: 	_create_list_states
; Description ...: 	Creates a listView that will show in real time the state and value of Virtual Coils and Counters
; Parameters ....: 	$virtual_amount: The amount of Virtual Coils used
;					$counter_amount: The amount of Counters used
; Return values .: 	Creates the ListView and returns an array containing the ControlIDs of the ListViewItems created
; ============================================================================================================================================
Func _create_list_states($virtual_amount, $counter_amount)
	If $virtual_amount >= $counter_amount Then
		$max = $virtual_amount
	Else
		$max = $counter_amount
	EndIf
	Local $list_items[$max]
	For $i=0 To UBound($list_items) - 1
		$write_virt = " "
		$write_virt_state = " "
		$write_count = " "
		$write_count_value = " "
		If $i <= $virtual_amount And $virtual_amount > 0 Then
			$write_virt = "Virtual_Coil_" & $i+1
			$write_virt_state = "Low"
		EndIf
		If $i <= $counter_amount And $counter_amount > 0 Then
			$write_count = "Counter_" & $i+1
			$write_count_value = "0"
		EndIf
		$list_items[$i] = GUICtrlCreateListViewItem($write_virt & "|" & $write_virt_state & "| |" & $write_count & "|" & $write_count_value, $list_states)
	Next
	Return $list_items
EndFunc

; #FUNCTION#
; Name...........: 	_create_pin_type_label
; Description ...: 	Create a label showing the state of a pin
; Parameters ....: 	$pin : The pin to create the label To
;					$type : The type of pin to create
; Return values .: 	The number of counters used in the rules. If no counter used then returns 0
; ============================================================================================================================================
Func _create_pin_type_label($pin, $type)
	If $pin <= 7 Then
		$pin_label = GUICtrlCreateLabel($type, 285, 437-($pin*23), 145)
		GUICtrlSetColor(-1, 0xff0000)
		GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
		GUICtrlSetStyle(-1, 0x0002)
		GUICtrlSetFont(-1, 10)
	ElseIf $pin >= 8 And $pin < 14 Then
		$pin_label = GUICtrlCreateLabel($type, 285, 241-(($pin-8)*23), 145)
		GUICtrlSetColor(-1, 0xff0000)
		GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
		GUICtrlSetStyle(-1, 0x0002)
		GUICtrlSetFont(-1, 10)
	ElseIf $pin >= 14 Then
		$pin_label = GUICtrlCreateLabel($type, 137, 323+(($pin-14)*23), 145)
		GUICtrlSetColor(-1, 0xff0000)
		GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
		GUICtrlSetFont(-1, 10)
	EndIf
	Return $pin_label
EndFunc

; #FUNCTION#
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

; #FUNCTION#
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
		Return _ArrayMax($temp, 1)
	Else
		Return 0
	EndIf
EndFunc

; #FUNCTION#
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
		ElseIf $in[1] = "<<>>" Then ; Prepei na kano map tis times otan sygkrinontai input me output
			;_ArrayDisplay($settings_array)
			$comp_expr=StringSplit($in[2], "\", 2)
			For $i=0 To 19
				If $comp_expr[1] = $settings_array[$i][1] Then
					$comp_pin_1 = $i
					ExitLoop
				EndIf
			Next 
			For $i=0 To 19
				If $comp_expr[3] = $settings_array[$i][1] Then
					$comp_pin_2 = $i
					ExitLoop
				EndIf
			Next
			If $comp_expr[4] = "=" Then
				If $comp_expr[2] = "-" Then
					$comp_1_val = GUICtrlRead($states[$comp_pin_1])
					$comp_2_val = GUICtrlRead($states[$comp_pin_2])
					If $settings_array[$comp_pin_1][0] = "AO" Then $comp_1_val = (1024*$comp_1_val)/255 ; If output then map the value to a 0-1024 range
					If $settings_array[$comp_pin_2][0] = "AO" Then $comp_2_val = (1024*$comp_2_val)/255
					If $comp_1_val - $comp_2_val = $comp_expr[5] Then $result = "GOOD"
				ElseIf $comp_expr[2] = "+" Then
					$comp_1_val = GUICtrlRead($states[$comp_pin_1])
					$comp_2_val = GUICtrlRead($states[$comp_pin_2])
					If $settings_array[$comp_pin_1][0] = "AO" Then $comp_1_val = (1024*$comp_1_val)/255 ; If output then map the value to a 0-1024 range
					If $settings_array[$comp_pin_2][0] = "AO" Then $comp_2_val = (1024*$comp_2_val)/255
					If $comp_1_val + $comp_2_val = $comp_expr[5] Then $result = "GOOD"
				ElseIf $comp_expr[2] = "/" Then
					$comp_1_val = GUICtrlRead($states[$comp_pin_1])
					$comp_2_val = GUICtrlRead($states[$comp_pin_2])
					If $settings_array[$comp_pin_1][0] = "AO" Then $comp_1_val = (1024*$comp_1_val)/255 ; If output then map the value to a 0-1024 range
					If $settings_array[$comp_pin_2][0] = "AO" Then $comp_2_val = (1024*$comp_2_val)/255
					If $comp_1_val / $comp_2_val = $comp_expr[5] Then $result = "GOOD"
				ElseIf $comp_expr[2] = "*" Then
					$comp_1_val = GUICtrlRead($states[$comp_pin_1])
					$comp_2_val = GUICtrlRead($states[$comp_pin_2])
					If $settings_array[$comp_pin_1][0] = "AO" Then $comp_1_val = (1024*$comp_1_val)/255 ; If output then map the value to a 0-1024 range
					If $settings_array[$comp_pin_2][0] = "AO" Then $comp_2_val = (1024*$comp_2_val)/255
					If $comp_1_val * $comp_2_val = $comp_expr[5] Then $result = "GOOD"
				EndIf
			ElseIf $comp_expr[4] = ">" Then
				If $comp_expr[2] = "-" Then
					$comp_1_val = GUICtrlRead($states[$comp_pin_1])
					$comp_2_val = GUICtrlRead($states[$comp_pin_2])
					If $settings_array[$comp_pin_1][0] = "AO" Then $comp_1_val = (1024*$comp_1_val)/255 ; If output then map the value to a 0-1024 range
					If $settings_array[$comp_pin_2][0] = "AO" Then $comp_2_val = (1024*$comp_2_val)/255
					If $comp_1_val - $comp_2_val > $comp_expr[5] Then $result = "GOOD"
				ElseIf $comp_expr[2] = "+" Then
					$comp_1_val = GUICtrlRead($states[$comp_pin_1])
					$comp_2_val = GUICtrlRead($states[$comp_pin_2])
					If $settings_array[$comp_pin_1][0] = "AO" Then $comp_1_val = (1024*$comp_1_val)/255 ; If output then map the value to a 0-1024 range
					If $settings_array[$comp_pin_2][0] = "AO" Then $comp_2_val = (1024*$comp_2_val)/255
					If $comp_1_val + $comp_2_val > $comp_expr[5] Then $result = "GOOD"
				ElseIf $comp_expr[2] = "/" Then
					$comp_1_val = GUICtrlRead($states[$comp_pin_1])
					$comp_2_val = GUICtrlRead($states[$comp_pin_2])
					If $settings_array[$comp_pin_1][0] = "AO" Then $comp_1_val = (1024*$comp_1_val)/255 ; If output then map the value to a 0-1024 range
					If $settings_array[$comp_pin_2][0] = "AO" Then $comp_2_val = (1024*$comp_2_val)/255
					If $comp_1_val / $comp_2_val > $comp_expr[5] Then $result = "GOOD"
				ElseIf $comp_expr[2] = "*" Then
					$comp_1_val = GUICtrlRead($states[$comp_pin_1])
					$comp_2_val = GUICtrlRead($states[$comp_pin_2])
					If $settings_array[$comp_pin_1][0] = "AO" Then $comp_1_val = (1024*$comp_1_val)/255 ; If output then map the value to a 0-1024 range
					If $settings_array[$comp_pin_2][0] = "AO" Then $comp_2_val = (1024*$comp_2_val)/255
					If $comp_1_val * $comp_2_val > $comp_expr[5] Then $result = "GOOD"
				EndIf
			ElseIf $comp_expr[4] = "<" Then
				If $comp_expr[2] = "-" Then
					$comp_1_val = GUICtrlRead($states[$comp_pin_1])
					$comp_2_val = GUICtrlRead($states[$comp_pin_2])
					If $settings_array[$comp_pin_1][0] = "AO" Then $comp_1_val = (1024*$comp_1_val)/255 ; If output then map the value to a 0-1024 range
					If $settings_array[$comp_pin_2][0] = "AO" Then $comp_2_val = (1024*$comp_2_val)/255
					If $comp_1_val - $comp_2_val < $comp_expr[5] Then $result = "GOOD"
				ElseIf $comp_expr[2] = "+" Then
					$comp_1_val = GUICtrlRead($states[$comp_pin_1])
					$comp_2_val = GUICtrlRead($states[$comp_pin_2])
					If $settings_array[$comp_pin_1][0] = "AO" Then $comp_1_val = (1024*$comp_1_val)/255 ; If output then map the value to a 0-1024 range
					If $settings_array[$comp_pin_2][0] = "AO" Then $comp_2_val = (1024*$comp_2_val)/255
					If $comp_1_val + $comp_2_val < $comp_expr[5] Then $result = "GOOD"
				ElseIf $comp_expr[2] = "/" Then
					$comp_1_val = GUICtrlRead($states[$comp_pin_1])
					$comp_2_val = GUICtrlRead($states[$comp_pin_2])
					If $settings_array[$comp_pin_1][0] = "AO" Then $comp_1_val = (1024*$comp_1_val)/255 ; If output then map the value to a 0-1024 range
					If $settings_array[$comp_pin_2][0] = "AO" Then $comp_2_val = (1024*$comp_2_val)/255
					If $comp_1_val / $comp_2_val < $comp_expr[5] Then $result = "GOOD"
				ElseIf $comp_expr[2] = "*" Then
					$comp_1_val = GUICtrlRead($states[$comp_pin_1])
					$comp_2_val = GUICtrlRead($states[$comp_pin_2])
					If $settings_array[$comp_pin_1][0] = "AO" Then $comp_1_val = (1024*$comp_1_val)/255 ; If output then map the value to a 0-1024 range
					If $settings_array[$comp_pin_2][0] = "AO" Then $comp_2_val = (1024*$comp_2_val)/255
					If $comp_1_val * $comp_2_val < $comp_expr[5] Then $result = "GOOD"
				EndIf
			ElseIf $comp_expr[4] = ">=" Then
				If $comp_expr[2] = "-" Then
					$comp_1_val = GUICtrlRead($states[$comp_pin_1])
					$comp_2_val = GUICtrlRead($states[$comp_pin_2])
					If $settings_array[$comp_pin_1][0] = "AO" Then $comp_1_val = (1024*$comp_1_val)/255 ; If output then map the value to a 0-1024 range
					If $settings_array[$comp_pin_2][0] = "AO" Then $comp_2_val = (1024*$comp_2_val)/255
					If $comp_1_val - $comp_2_val >= $comp_expr[5] Then $result = "GOOD"
				ElseIf $comp_expr[2] = "+" Then
					$comp_1_val = GUICtrlRead($states[$comp_pin_1])
					$comp_2_val = GUICtrlRead($states[$comp_pin_2])
					If $settings_array[$comp_pin_1][0] = "AO" Then $comp_1_val = (1024*$comp_1_val)/255 ; If output then map the value to a 0-1024 range
					If $settings_array[$comp_pin_2][0] = "AO" Then $comp_2_val = (1024*$comp_2_val)/255
					If $comp_1_val + $comp_2_val >= $comp_expr[5] Then $result = "GOOD"
				ElseIf $comp_expr[2] = "/" Then
					$comp_1_val = GUICtrlRead($states[$comp_pin_1])
					$comp_2_val = GUICtrlRead($states[$comp_pin_2])
					If $settings_array[$comp_pin_1][0] = "AO" Then $comp_1_val = (1024*$comp_1_val)/255 ; If output then map the value to a 0-1024 range
					If $settings_array[$comp_pin_2][0] = "AO" Then $comp_2_val = (1024*$comp_2_val)/255
					If $comp_1_val / $comp_2_val >= $comp_expr[5] Then $result = "GOOD"
				ElseIf $comp_expr[2] = "*" Then
					$comp_1_val = GUICtrlRead($states[$comp_pin_1])
					$comp_2_val = GUICtrlRead($states[$comp_pin_2])
					If $settings_array[$comp_pin_1][0] = "AO" Then $comp_1_val = (1024*$comp_1_val)/255 ; If output then map the value to a 0-1024 range
					If $settings_array[$comp_pin_2][0] = "AO" Then $comp_2_val = (1024*$comp_2_val)/255
					If $comp_1_val * $comp_2_val >= $comp_expr[5] Then $result = "GOOD"
				EndIf
			ElseIf $comp_expr[4] = "<=" Then
				If $comp_expr[2] = "-" Then
					$comp_1_val = GUICtrlRead($states[$comp_pin_1])
					$comp_2_val = GUICtrlRead($states[$comp_pin_2])
					If $settings_array[$comp_pin_1][0] = "AO" Then $comp_1_val = (1024*$comp_1_val)/255 ; If output then map the value to a 0-1024 range
					If $settings_array[$comp_pin_2][0] = "AO" Then $comp_2_val = (1024*$comp_2_val)/255
					If $comp_1_val - $comp_2_val <= $comp_expr[5] Then $result = "GOOD"
				ElseIf $comp_expr[2] = "+" Then
					$comp_1_val = GUICtrlRead($states[$comp_pin_1])
					$comp_2_val = GUICtrlRead($states[$comp_pin_2])
					If $settings_array[$comp_pin_1][0] = "AO" Then $comp_1_val = (1024*$comp_1_val)/255 ; If output then map the value to a 0-1024 range
					If $settings_array[$comp_pin_2][0] = "AO" Then $comp_2_val = (1024*$comp_2_val)/255
					If $comp_1_val + $comp_2_val <= $comp_expr[5] Then $result = "GOOD"
				ElseIf $comp_expr[2] = "/" Then
					$comp_1_val = GUICtrlRead($states[$comp_pin_1])
					$comp_2_val = GUICtrlRead($states[$comp_pin_2])
					If $settings_array[$comp_pin_1][0] = "AO" Then $comp_1_val = (1024*$comp_1_val)/255 ; If output then map the value to a 0-1024 range
					If $settings_array[$comp_pin_2][0] = "AO" Then $comp_2_val = (1024*$comp_2_val)/255
					If $comp_1_val / $comp_2_val <= $comp_expr[5] Then $result = "GOOD"
				ElseIf $comp_expr[2] = "*" Then
					$comp_1_val = GUICtrlRead($states[$comp_pin_1])
					$comp_2_val = GUICtrlRead($states[$comp_pin_2])
					If $settings_array[$comp_pin_1][0] = "AO" Then $comp_1_val = (1024*$comp_1_val)/255 ; If output then map the value to a 0-1024 range
					If $settings_array[$comp_pin_2][0] = "AO" Then $comp_2_val = (1024*$comp_2_val)/255
					If $comp_1_val * $comp_2_val <= $comp_expr[5] Then $result = "GOOD"
				EndIf
			ElseIf $comp_expr[4] = "<>" Then
				If $comp_expr[2] = "-" Then
					$comp_1_val = GUICtrlRead($states[$comp_pin_1])
					$comp_2_val = GUICtrlRead($states[$comp_pin_2])
					If $settings_array[$comp_pin_1][0] = "AO" Then $comp_1_val = (1024*$comp_1_val)/255 ; If output then map the value to a 0-1024 range
					If $settings_array[$comp_pin_2][0] = "AO" Then $comp_2_val = (1024*$comp_2_val)/255
					If $comp_1_val - $comp_2_val <> $comp_expr[5] Then $result = "GOOD"
				ElseIf $comp_expr[2] = "+" Then
					$comp_1_val = GUICtrlRead($states[$comp_pin_1])
					$comp_2_val = GUICtrlRead($states[$comp_pin_2])
					If $settings_array[$comp_pin_1][0] = "AO" Then $comp_1_val = (1024*$comp_1_val)/255 ; If output then map the value to a 0-1024 range
					If $settings_array[$comp_pin_2][0] = "AO" Then $comp_2_val = (1024*$comp_2_val)/255
					If $comp_1_val + $comp_2_val <> $comp_expr[5] Then $result = "GOOD"
				ElseIf $comp_expr[2] = "/" Then
					$comp_1_val = GUICtrlRead($states[$comp_pin_1])
					$comp_2_val = GUICtrlRead($states[$comp_pin_2])
					If $settings_array[$comp_pin_1][0] = "AO" Then $comp_1_val = (1024*$comp_1_val)/255 ; If output then map the value to a 0-1024 range
					If $settings_array[$comp_pin_2][0] = "AO" Then $comp_2_val = (1024*$comp_2_val)/255
					If $comp_1_val / $comp_2_val <> $comp_expr[5] Then $result = "GOOD"
				ElseIf $comp_expr[2] = "*" Then
					$comp_1_val = GUICtrlRead($states[$comp_pin_1])
					$comp_2_val = GUICtrlRead($states[$comp_pin_2])
					If $settings_array[$comp_pin_1][0] = "AO" Then $comp_1_val = (1024*$comp_1_val)/255 ; If output then map the value to a 0-1024 range
					If $settings_array[$comp_pin_2][0] = "AO" Then $comp_2_val = (1024*$comp_2_val)/255
					If $comp_1_val * $comp_2_val <> $comp_expr[5] Then $result = "GOOD"
				EndIf
			EndIf
		EndIf
	EndIf
	Return $result
EndFunc

; #FUNCTION#
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

; #FUNCTION#
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

; #FUNCTION#
; Name...........: 	_delete_pin
; Description ...: 	Deletes the pin and the button
; Parameters ....: 	$pins :	Array containing the ControlID's of the graphics representing each pin
;					$buttons : Array containing the ControlID's of the buttons representing each pin
;					$pin_number : The number of pin to delete
; Return values .: 	An array containing the ControlID's of the labels or the input boxes created
; ============================================================================================================================================
Func _delete_pin($pins, $buttons, $labels, $pin_number)
	GUICtrlDelete($pins[$pin_number])
	GUICtrlDelete($buttons[$pin_number])
	GUICtrlDelete($labels[$pin_number])
EndFunc

; #FUNCTION#
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
			$pin_label = GUICtrlCreateLabel("-", 490, 437-($pin_number*23), 30, 21)
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
			$pin_label = GUICtrlCreateLabel("-", 490, 241-(($pin_number-8)*23), 30, 21)
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
			$pin_label = GUICtrlCreateLabel("                 -", 17, 323+(($pin_number-14)*23), 60, 21)
		EndIf
	EndIf
	Return ($pin_label)
EndFunc

; #FUNCTION#
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

; #FUNCTION#
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
