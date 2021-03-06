#cs -Program Comments-
 AutoIt Version: 3.3.6.1
 Author: Liapis Nikos
 Script Name: Arduino Programmer
 Script Description: A GUI interface for programming Arduino
 Date: 28-7-2012
 Version: 0.35
 Version changes:	0.21) - Bug fixed: Change the $project variable when open a saved project
					0.22) - Bug fixed: Program crashed when a rule was modified (only occured at the second rule that was called for modify)
					0.23) - Adds the ability to set a Counter to a fixed value so that the user can "reset" the value of a Counter
					0.24) - Bug fixed: used to add a space infront of the Counters in inputs causing problems to simulator
						  - Fixed the _check_syntax() function to accept 0 as value when output is a counter
					0.25) - Prevent user entering a pin name containing the words "Virtual_Coil" or "Counter" because causes problems on the function _update_rule_combos_others()
						  - Adds the autocomplete choise when apllying a new rule, which automatically creates another opposite rule
								For example: if a rule is * Pin_0 = HIGH ==> Pin_5 = HIGH *
											 then the rule * Pin_0 = LOW ==> Pin_5 = LOW * will be automatically created
					0.26) - Changed the generated code regarding Counters (each Counter will increase or dicrease only on input toggle)
					0.27) - The title of the Main GUI shows the active project
					0.28) - The settings combos are disabled only if they have been used inside a Rule
					0.29) - Adds the abbility to use an Output as Input (Further testing required)
					0.30) - Bug fixed: Pin_A5 was not updated to the rule combos
						  - New feature that enables user to compare 2 analog pins
						  - Improve the generated code conserning the expression feature.
								(Use of the constrain() Arduino command to limit the values and not if...then)
						  - Improve the generated code conserning analog inputs.
								(Map the values of AI to a range of 0-255 when reading the pin and not when writing the corresponting output.
								By doing the mapping at the begining there is no need to remap when comparison of analog pins)
						  - Change the header(top line) of the saved project
								(This is done so older versions of Arduino Simulator(V0.06 and below) wont open projects with the comparison feature, because they
								can't handle the rules.)
						  - Bug fixed: Wrong project name when "save as"
					0.31) - Minor change in the order of the comparator when comparing analog pins (Division is the default selection)
						  - Show tip text associated with the controls
					0.32) - Prevent user entering a pin name containing the character "\", because it is used as delimiter at the "Boole calc" function and may create problems.
						  - Bug fixed: When the number of created rules where over 30 they didn't fit at the rule selection combo. Now a scrollbar appears if needed
						  - Three new alternative ways to create rules are added:
								1) Boolean Calculator: A calculator like GUI Window that allows the user to create Logical (Boolean) Expressions which are 
									automatically transfered to Rules.
								2) Boolean Truth Table (2 Inputs): A Truth Table ready for 2 inputs and 1 output. The entered data are automatically 
									transfered to Rules.
								3) Boolean Truth Table (custom Inputs): A generalized Truth Table able to handle more inputs (1-9)
					0.33) - Add a space option along with the "AND" and "OR" options in the rule combos
						  - Bug fixed: When the number of inputs is three and above then the opossite rules regarding Virtual Coils are also created.
						  - Bug fixed: Changed the way that counts the open and closed parentheses in the _create_output_from_bool_expression function
						  - When using Bool calculator, user can create an expression with an "Not" in the output to invert the output
						  - Bug fixed: Button 13 on Bool Calculator was not functioning. (An empty label was overlaping)
						  - Changed the symbols for "AND" , "OR" on boole calculator. Now the symbols are: AND -> "*"     OR -> "+"
						  - Remove the counters from the combos on bool functions
					0.34  - Add the "Preview Truth Table" feature on the Bool Calculator
						  - Some syntax check of the expression in the Bool Calculator
						  - In the "Boolean Truth Table (Custom Inputs)" tool all the possible states of inputs are automatically created
						  - Change the label showing the maximum number of inputs on the "Boolean Truth Table (Custom Inputs)" tool according to the daclared Digital Inputs
						  - Add the "Fill Inputs" button on the "Boolean Truth Table (Custom Inputs)" tool, which automatically sets all the possible states of the inputs
						  - Bug fixed: Program crash when rule was deleted twise
						  - Add a Clear Rules option under the Clear Settings Button
					0.35  - Use of a much better way to generate Rules when the "Boole's Calculator" or "Boole's Truth table" are used.
								The generated Rules and the Virtual Coils used are much less.
Corrections needed:  1) Correct the generated code regarding Timers
					 2) Do not disable the pin settings just change the apllied rules when a change in settings name is made, but disable the pin type
					 3) Make the window resisable
#ce

#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include <ComboConstants.au3>
#Include <GuiListView.au3>
#include <GUIScrollBars.au3>
#include <ScrollBarConstants.au3>
#include <Array.au3>
; include

Global $project = "Untitled" ; Variable to hold the project name
Global $version = "0.35"
Global $release_date = "28-7-2012"
Global $rule_count = 0
Global $list_items[1]
Global $change = 0 ; 0 -> new menu          1 -> submit
;					 0 -> open menu		    1 -> clear settings
;					 0 -> save menu			1 -> aplly
;					 0 -> save as menu

$main = GUICreate("Arduino Gui Programmer V" & $version & "-" & $project, 1159, 580, 50, 50);, $WS_SIZEBOX)

#region Create Graphics
; Graphics to simulate Arduino
GUICtrlCreateGraphic(888, 54, 89, 329)
GUICtrlSetColor(-1, 0x000000)
GUICtrlSetBkColor(-1, 0x0000FF)
GUICtrlCreateGraphic(896, 158, 25, 217)
GUICtrlSetColor(-1, 0xFFFFFF)
GUICtrlSetBkColor(-1, 0x000000)
GUICtrlCreateGraphic(896, 46, 17, 33)
GUICtrlSetColor(-1, 0xFFFFFF)
GUICtrlSetBkColor(-1, 0x000000)
GUICtrlCreateGraphic(936, 30, 33, 57)
GUICtrlSetColor(-1, 0xFFFFFF)
GUICtrlSetBkColor(-1, 0x000000)
GUICtrlCreateGraphic(714, 0, 1, 580)
GUICtrlSetColor(-1, 0x000000)
GUICtrlCreateGraphic(714, 440, 445, 1)
GUICtrlSetColor(-1, 0x000000)
GUICtrlCreateLabel("PIN SETTINGS", 920, 5, 79, 17)
GUICtrlCreateLabel("Pin Names", 730, 225, 60, 17)
GUICtrlCreateLabel("Pin Names", 1060, 40, 60, 17)
#endregion 
#region Create Menu
; Create the menu objects
$file_menu = GUICtrlCreateMenu ("File")
$new_menu = GUICtrlCreateMenuItem ("New", $file_menu)
GUICtrlSetTip(-1, "Create A New Project")
$save_menu = GUICtrlCreateMenuItem ("Save", $file_menu)
GUICtrlSetTip(-1, "Save The Current Project")
$save_as_menu = GUICtrlCreateMenuItem ("Save As...", $file_menu)
GUICtrlSetTip(-1, "Save The Current Project")
$open_menu = GUICtrlCreateMenuItem ("Open...", $file_menu)
GUICtrlSetTip(-1, "Open An Existing Project")
$exit_menu = GUICtrlCreateMenuItem ("Exit", $file_menu)
GUICtrlSetTip(-1, "Close The Program")
$tools_menu = GUICtrlCreateMenu("Tools")
$alternate_menu = GUICtrlCreateMenu("Alternate Rule Creation", $tools_menu)
$boole_calc_menu = GUICtrlCreateMenuItem("Boolean Calculator", $alternate_menu)
GUICtrlSetTip(-1, "Create Boolen Expression")
$boole_table_menu = GUICtrlCreateMenuItem("Boolean Truth Table (2 Inputs)", $alternate_menu)
GUICtrlSetTip(-1, "Fill A Boolean Truth Table")
$boole_table_im_menu = GUICtrlCreateMenuItem("Boolean Truth Table (Custom Inputs)", $alternate_menu)
GUICtrlSetTip(-1, "Fill A Boolean Truth Table")
$help_menu = GUICtrlCreateMenu ("Help")
$about_menu = GUICtrlCreateMenuItem ("About", $help_menu)
GUICtrlSetTip(-1, "Show Informations Of The Program")
$how_to_menu = GUICtrlCreateMenuItem ("How To...", $help_menu)
GUICtrlSetTip(-1, "Show A Guide Of The Program")
#endregion
#region Create Buttons
$button_submit = GUICtrlCreateButton("Submit", 971, 400, 71, 25)
GUICtrlSetTip (-1, "Register Changes In Settings")
$button_clear_set = GUICtrlCreateButton("Clear Settings", 850, 400, 91, 25)
GUICtrlSetTip (-1, "Clear-Reset Settings")
$button_apply_rule = GUICtrlCreateButton("Apply Rule", 880, 464, 70, 25)
GUICtrlSetState (-1, $GUI_DISABLE)
GUICtrlSetTip (-1, "Aplly Rule To List")
$button_clear_rule = GUICtrlCreateButton("Clear Rule", 880, 499, 70, 25)
GUICtrlSetState (-1, $GUI_DISABLE)
GUICtrlSetTip (-1, "Clear Rule Active Rule")
$button_load_rule = GUICtrlCreateButton("Load Rule", 962, 464, 70, 25)
GUICtrlSetState (-1, $GUI_DISABLE)
GUICtrlSetTip (-1, "Load Rule To Modify")
$button_delete_rule = GUICtrlCreateButton("Delete Rule", 962, 499, 70, 25)
GUICtrlSetState (-1, $GUI_DISABLE)
GUICtrlSetTip (-1, "Delete Selected Rule From List")
$button_generate = GUICtrlCreateButton("Generate Code", 1044, 499, 100, 25)
GUICtrlSetState (-1, $GUI_DISABLE)
GUICtrlSetTip (-1, "Generate Arduino Code")
$autocomplete = GUICtrlCreateCheckbox("Opposite Rule", 780, 499, 85, 20, 0x0020)
GUICtrlCreateLabel("Auto Create", 780, 485, 85, 15)
;$check_box = GUICtrlCreateCheckbox("Check Syntax", 730, 464, 85, 25, 0x0020) ; ALSO CHANGE THE CODE IN THE APPLY BUTTON CASE
;GUICtrlSetState (-1, $GUI_CHECKED)
#endregion
#region Create List
$List = GUICtrlCreateListView("Rule|Input A|Is|Value|AND/OR|Input B|Is|Value|Output|Is|Value|Delay|Comments", 10, 10, 700, 430,-1, 0x00000001)
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
_GUICtrlListView_SetColumnWidth($list, 12, 155)
#endregion
$settings_pin_combos = _create_settings_combos()
$rule_combos = _create_rule_combos($rule_count)
GUISetState(@SW_SHOW)
$a = MouseGetPos(0)
ToolTip("Set Pin Settings" & @LF & "And Press Submit", 1090, 520, "", 0, 1)
While 1
	$b = MouseGetPos(0)
	If $a <> $b Then
		ToolTip("")
		ExitLoop
	EndIf
WEnd

While 1
	;ToolTip ($project)
	WinSetTitle("Arduino Gui Programmer", "", "Arduino Gui Programmer V" & $version & " - " & $project)
	$msg = GUIGetMsg()
	For $i=0 To 19 ; Enable the input boxes to hold the names of the setting pins
		If $msg = $settings_pin_combos[$i][0] Then
			GUICtrlSetState ($settings_pin_combos[$i][1], $GUI_ENABLE)
		EndIf
	Next
	Switch $msg
		Case $GUI_EVENT_CLOSE
			If $change = 1 Then
				$conf = MsgBox (35, "Save project", "Do you want to save project before Exiting ?")
				If $conf = 6 Then ; Yes
					If $project = "Untitled" Then
						$project = FileSaveDialog ("Save Project", @ScriptDir, "NAG Project (*.nag)", 2, $project)
						_write_project_to_file($settings_pin_combos, $list_items, $project, 1)
					Else
						_write_project_to_file($settings_pin_combos, $list_items, $project, 0)
					EndIf
					Exit
				ElseIf $conf = 7 Then ; No
					Exit
				EndIf
			Else
				Exit
			EndIf
		Case $about_menu
			$about_win = GUICreate("About", 400, 250, 298, 120)
			GUICtrlCreateLabel("--- ARDUINO GUI PROGRAMMER ----" & @LF & @LF & @LF & "Version : " & $version & @LF & @LF & "Date : " & $release_date & @LF _
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
		Case $how_to_menu
			ShellExecute("http://codikia.blogspot.gr/2012/06/tutorial-for-arduino-gui-programmer.html")
		Case $button_generate
			_generate_code($list_items, $settings_pin_combos)
		Case $exit_menu
			If $change = 1 Then
				$conf = MsgBox (35, "Save project", "Do you want to save project before Exiting ?")
				If $conf = 6 Then ; Yes
					If $project = "Untitled" Then
						$project = FileSaveDialog ("Save Project", @ScriptDir, "NAG Project (*.nag)", 2, $project)
						_write_project_to_file($settings_pin_combos, $list_items, $project, 1)
					Else
						_write_project_to_file($settings_pin_combos, $list_items, $project, 0)
					EndIf
					Exit
				ElseIf $conf = 7 Then ; No
					Exit
				EndIf
			Else
				Exit
			EndIf
		Case $new_menu
			If $change = 1 Then
				$conf = MsgBox (35, "Save project", "Do you want to save project before opening a new one ?")
				If $conf = 6 Then ; Yes
					If $project = "Untitled" Then
						$project = FileSaveDialog ("Save Project", @ScriptDir, "NAG Project (*.nag)", 2, $project)
						_write_project_to_file($settings_pin_combos, $list_items, $project, 1)
					Else
						_write_project_to_file($settings_pin_combos, $list_items, $project, 0)
					EndIf
				ElseIf $conf <> 2 Then ; Cancel not selected
					_delete_settings_combos($settings_pin_combos)
					_delete_rule_combos($rule_combos)
					GUICtrlDelete($List)
					GUICtrlSetState ($button_apply_rule, $GUI_DISABLE)
					GUICtrlSetState ($button_clear_rule, $GUI_DISABLE)
					GUICtrlSetState($button_load_rule, $GUI_DISABLE)
					GUICtrlSetState($button_delete_rule, $GUI_DISABLE)
					#region Create ListView
					$List = GUICtrlCreateListView("Rule|Input A|Is|Value|AND/OR|Input B|Is|Value|Output|Is|Value|Delay|Comments", 10, 10, 700, 430,-1, 0x00000001)
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
					_GUICtrlListView_SetColumnWidth($list, 12, 155)
					#endregion
					; region Create ListView
					$rule_count = 0
					$settings_pin_combos = _create_settings_combos()
					$rule_combos = _create_rule_combos($rule_count)
					$project = "Untitled"
					$change = 0
				EndIf
			Else
				_delete_settings_combos($settings_pin_combos)
				_delete_rule_combos($rule_combos)
				GUICtrlDelete($List)
				GUICtrlSetState ($button_apply_rule, $GUI_DISABLE)
				GUICtrlSetState ($button_clear_rule, $GUI_DISABLE)
				GUICtrlSetState($button_load_rule, $GUI_DISABLE)
				GUICtrlSetState($button_delete_rule, $GUI_DISABLE)
				#region Create ListView
				$List = GUICtrlCreateListView("Rule|Input A|Is|Value|AND/OR|Input B|Is|Value|Output|Is|Value|Delay|Comments", 10, 10, 700, 430,-1, 0x00000001)
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
				_GUICtrlListView_SetColumnWidth($list, 12, 155)
				#endregion
				; region Create ListView
				$rule_count = 0
				$settings_pin_combos = _create_settings_combos()
				$rule_combos = _create_rule_combos($rule_count)
				$project = "Untitled"
			EndIf
		Case $save_menu
			_write_project_to_file($settings_pin_combos, $list_items, $project, 0)
			$change = 0
		Case $save_as_menu
			$project = FileSaveDialog ("Save Project", @ScriptDir, "NAG Project (*.nag)", 2, $project)
			$temp = StringSplit($project, "\")
			_write_project_to_file($settings_pin_combos, $list_items, $project, 1)
			$project = $temp[$temp[0]]
			$change = 0
		Case $open_menu
			GUICtrlSetState ($button_generate, $GUI_ENABLE)
			If $change = 1 Then
				$conf = MsgBox (35, "Save project", "Do you want to save project before opening a new one ?")
				If $conf = 6 Then ; Yes
					If $project = "Untitled" Then
						$project = FileSaveDialog ("Save Project", @ScriptDir, "NAG Project (*.nag)", 2, $project)
						_write_project_to_file($settings_pin_combos, $list_items, $project, 1)
					Else
						_write_project_to_file($settings_pin_combos, $list_items, $project, 0)
					EndIf
				EndIf
			EndIf
			$change = 0
			$proj = FileOpenDialog ("Open Project", @ScriptDir & "\", "NAG Projects (*.nag)", 3)
			$file=FileOpen($proj, 0)
			$header = FileReadLine($file)
			If $header = "NAG FILE V.020" Or $header = "NAG FILE V.030" Then
				$a = _read_settings_from_file($proj)
				$b = _read_rules_from_file($proj)
				_delete_settings_combos($settings_pin_combos)
				$settings_pin_combos = _create_settings_combos($a[0][0], $a[1][0], $a[2][0], $a[3][0], $a[4][0], $a[5][0], $a[6][0], $a[7][0], $a[8][0], $a[9][0], $a[10][0], $a[11][0], $a[12][0], $a[13][0], $a[14][0], $a[15][0], $a[16][0], $a[17][0], $a[18][0], $a[19][0], _
								$a[0][1], $a[1][1], $a[2][1], $a[3][1], $a[4][1], $a[5][1], $a[6][1], $a[7][1], $a[8][1], $a[9][1], $a[10][1], $a[11][1], $a[12][1], $a[13][1], $a[14][1], $a[15][1], $a[16][1], $a[17][1], $a[18][1], $a[19][1])
				GUICtrlDelete($List)
				#region Create ListView
				$List = GUICtrlCreateListView("Rule|Input A|Is|Value|AND/OR|Input B|Is|Value|Output|Is|Value|Delay|Comments", 10, 10, 700, 430,-1, 0x00000001)
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
				_GUICtrlListView_SetColumnWidth($list, 12, 155)
				#endregion
				; region Create ListView
				For $i=0 To UBound($b)-2
					$c=StringSplit($b[$i], "|", 2)
					$d = _write_rule_to_list ($c) ; Write rule to list
					$list_items[$i] = $d ; Store rule to $list_items
					ReDim $list_items[$i + 2]
					$rule_count = $i+1
				Next
				#region Button Submit
				$change = 1
				GUICtrlSetState ($button_apply_rule, $GUI_ENABLE)
				GUICtrlSetState ($button_clear_rule, $GUI_ENABLE)
				GUICtrlSetState ($button_generate, $GUI_ENABLE)
				$a = _read_rules_from_list($list_items)
				$check = _disable_declared_pins($settings_pin_combos, $a) ; Disable the selected pins and write names to the empty ones
				If $check = "OK" Then
					$pin_names = _read_settings_names($settings_pin_combos) ; Get the names of the declared pins
					_delete_rule_combos($rule_combos)
					$rule_combos = _create_rule_combos($rule_count)
					_update_rule_combos_inputs($pin_names, $rule_combos) ; Set the pin options in the input combos
					$a = _read_rules_from_list($list_items)
					_update_rule_combos_virtuals($a, $rule_combos)
				EndIf
				#endregion
				; Rename the project
				$x = StringSplit($proj, "\")
				$project = StringTrimRight($x[$x[0]], 4)
			Else
				MsgBox (16, "ERROR", "File Not Compatible")
			EndIf
		Case $button_delete_rule
			GUICtrlSetState($button_delete_rule, $GUI_DISABLE)
			GUICtrlSetState($button_load_rule, $GUI_DISABLE)
			GUICtrlSetState($button_apply_rule, $GUI_ENABLE)
			GUICtrlSetState($button_clear_rule, $GUI_ENABLE)
			$c = _read_rules_from_list($list_items, GUICtrlRead($rule_combos[0])+1)
			For $i = GUICtrlRead($rule_combos[0]) To $rule_count
				GUICtrlDelete($list_items[$i])
				$list_items[$i] = ""
			Next
			If StringInStr($c[0], "|") <> 0 Then ; Check if the rule for deleting is not the last rule in listview
				$e = 0
				For $i = 0 To UBound($c) - 1
					$d = StringSplit($c[$e], "|", 2)
					$d[0] = $d[0]-1
					$b = _write_rule_to_list ($d)
					$list_items[GUICtrlRead($rule_combos[0])+$e] = $b
					$e += 1
				Next
			EndIf
			$rule_count -= 1
			_delete_rule_combos($rule_combos) ; Empty the rule combos
			$rule_combos = _create_rule_combos($rule_count)
			_update_rule_combos_inputs($pin_names, $rule_combos)
			$a = _read_rules_from_list($list_items)
			_update_rule_combos_virtuals($a, $rule_combos)
		Case $button_load_rule
			GUICtrlSetState($button_load_rule, $GUI_DISABLE)
			GUICtrlSetState($button_delete_rule, $GUI_DISABLE)
			GUICtrlSetState($button_apply_rule, $GUI_ENABLE)
			GUICtrlSetState($button_clear_rule, $GUI_ENABLE)
			$a = _read_rules_from_list($list_items, GUICtrlRead($rule_combos[0]), GUICtrlRead($rule_combos[0]))
			_delete_rule_combos($rule_combos)
			$b = StringSplit($a[0], "|", 2)
			$rule_combos = _create_rule_combos($b[0], $b[1], $b[2], $b[3], $b[4], $b[5], $b[6], $b[7], $b[8], $b[9], $b[10], $b[11], $b[12])
			_update_rule_combos_inputs($pin_names, $rule_combos) ; Set the pin options in the input combos
			$a = _read_rules_from_list($list_items)
			$c = StringSplit($a[GUICtrlRead($rule_combos[0])], "|", 2)
			_update_rule_combos_virtuals($a, $rule_combos)
			_update_rule_combos_others($pin_names, $rule_combos, 1, $c[2], $c[3])
			_update_rule_combos_others($pin_names, $rule_combos, 2, $c[6], $c[7])
			_update_rule_combos_others($pin_names, $rule_combos, 3, $c[9], $c[10])
		Case $button_clear_rule
			$r = GUICtrlRead($rule_combos[0])
			_delete_rule_combos($rule_combos)
			$rule_combos = _create_rule_combos($r)
			_update_rule_combos_inputs($pin_names, $rule_combos) ; Set the pin options in the input combos
			$a = _read_rules_from_list($list_items)
			_update_rule_combos_virtuals($a, $rule_combos)
		Case $button_apply_rule
			$change = 1
			$ok = 1
			;If GUICtrlRead($check_box) = 1 Then
				If _check_syntax($rule_combos, $settings_pin_combos) <> "OK" Then
					$ok = 0
				EndIf
			;EndIf
			If $ok = 1 Then
				If GUICtrlRead($rule_combos[0]) = $rule_count Then ; Case a new rule is applied
					$a =_read_rule_combos($rule_combos) ; Read rule from combos
					$b = _write_rule_to_list ($a) ; Write rule to list
					$list_items[$rule_count] = $b ; Store rule to $list_items
					ReDim $list_items[$rule_count + 2]
					$rule_count += 1
					#region Create opposite rule
					If GUICtrlRead($autocomplete) = 1 And StringInStr($a[8], "Counter") = 0 Then ; If output is a counter don't create opposite rule
						If $a[1] <> "" Or $a[5] <> "" Then ; If both inputs are empty don't create opposite rule
							If StringIsDigit($a[3]) <> 1 Or $a[2] <> "=" Then ; If input_1 is analog input and comparator is "= equal" don't create opposite rule
								If StringIsDigit($a[7]) <> 1 Or $a[6] <> "=" Then ; If input_2 is analog input and comparator is "= equal" don't create opposite rule
									$c = _create_opposite_rule($a)
									$b = _write_rule_to_list ($c) ; Write rule to list
									$list_items[$rule_count] = $b ; Store rule to $list_items
									ReDim $list_items[$rule_count + 2]
									$rule_count += 1
								EndIf
							EndIf
						EndIf	
					EndIf
					#endregion
				ElseIf GUICtrlRead($rule_combos[0]) < $rule_count-1 Then ; Case a rule is modified and is not the last one applied
					$c = _read_rules_from_list($list_items, GUICtrlRead($rule_combos[0])+1)
					$a =_read_rule_combos($rule_combos)
					For $i = GUICtrlRead($rule_combos[0]) To $rule_count
						GUICtrlDelete($list_items[$i])
						$list_items[$i] = ""
					Next
					$b = _write_rule_to_list ($a)
					$list_items[GUICtrlRead($rule_combos[0])] = $b
					$e = 0
					For $i = 0 To UBound($c) - 1
						$d = StringSplit($c[$e], "|", 2)
						$b = _write_rule_to_list ($d)
						$list_items[GUICtrlRead($rule_combos[0])+1+$e] = $b
						$e += 1
					Next
				ElseIf GUICtrlRead($rule_combos[0]) = $rule_count-1 Then ; Case a rule is modified and is the last one applied
					GUICtrlDelete($list_items[GUICtrlRead($rule_combos[0])])
					$list_items[GUICtrlRead($rule_combos[0])] = ""
					$a =_read_rule_combos($rule_combos)
					$b = _write_rule_to_list ($a)
					$list_items[GUICtrlRead($rule_combos[0])] = $b
				EndIf
				_delete_rule_combos($rule_combos) ; Empty the rule combos
				$rule_combos = _create_rule_combos($rule_count)
				_update_rule_combos_inputs($pin_names, $rule_combos)
				$a = _read_rules_from_list($list_items)
				_update_rule_combos_virtuals($a, $rule_combos)
				_disable_declared_pins($settings_pin_combos, $a)
			EndIf
		Case $button_clear_set
			$change = 1
			$clear_selec = GUICreate("Clear Settings", 580, 179, 333, 110)
			$all = GUICtrlCreateButton("Clear All", 16, 136, 75, 25)
			$unsubmited = GUICtrlCreateButton("Clear UnSubmited", 204, 136, 107, 25)
			$c_rules=GUICtrlCreateButton("Clear Rules", 104, 136, 85, 25)
			$cancel = GUICtrlCreateButton("Cancel", 324, 136, 75, 25)
			GUICtrlCreateLabel("Clear All - Clears all the settings submited or not. Also clears all the applied rules", 12, 28, 500, 17)
			GUICtrlSetFont(-1, 10, 400, 0, "MS Sans Serif")
			GUICtrlCreateLabel("Clear UnSubmited - Clears all the unsubmited settings, leaving the submited pins and rules", 12, 60, 550, 17)
			GUICtrlSetFont(-1, 10, 400, 0, "MS Sans Serif")
			GUICtrlCreateLabel("Cancel - Do nothing", 12, 94, 136, 17)
			GUICtrlSetFont(-1, 10, 400, 0, "MS Sans Serif")
			GUISetState(@SW_SHOW)
			While 1
				$nMsg = GUIGetMsg()
				Switch $nMsg
					Case $GUI_EVENT_CLOSE
						ExitLoop
					Case $cancel
						ExitLoop
					Case $c_rules
						GUISwitch($main)
						_delete_rule_combos($rule_combos)
						GUICtrlDelete($List)
						GUICtrlSetState ($button_apply_rule, $GUI_DISABLE)
						GUICtrlSetState ($button_clear_rule, $GUI_DISABLE)
						GUICtrlSetState($button_load_rule, $GUI_DISABLE)
						GUICtrlSetState($button_delete_rule, $GUI_DISABLE)
						#region Create ListView
						$List = GUICtrlCreateListView("Rule|Input A|Is|Value|AND/OR|Input B|Is|Value|Output|Is|Value|Delay|Comments", 10, 10, 700, 430,-1, 0x00000001)
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
						_GUICtrlListView_SetColumnWidth($list, 12, 155)
						#endregion
						; region Create ListView
						$rule_count = 0
						$rule_combos = _create_rule_combos($rule_count)
						#region Submit Button
						$change = 1
						GUICtrlSetState ($button_apply_rule, $GUI_ENABLE)
						GUICtrlSetState ($button_clear_rule, $GUI_ENABLE)
						GUICtrlSetState ($button_generate, $GUI_ENABLE)
						$a = _read_rules_from_list($list_items)
						$check = _disable_declared_pins($settings_pin_combos, $a) ; Disable the selected pins and write names to the empty ones
						If $check = "OK" Then
							$pin_names = _read_settings_names($settings_pin_combos) ; Get the names of the declared pins
							_delete_rule_combos($rule_combos)
							$rule_combos = _create_rule_combos($rule_count)
							_update_rule_combos_inputs($pin_names, $rule_combos) ; Set the pin options in the input combos
							$a = _read_rules_from_list($list_items)
							_update_rule_combos_virtuals($a, $rule_combos)
						EndIf
						#EndRegion
						GUISwitch($clear_selec)
						ExitLoop
					Case $all
						GUISwitch($main)
						$check = MsgBox (36, "Confirm", "Are you sure you want to delete all settings combos and all rules")
						If $check = 6 Then ; Yes
							$change = 0
							_delete_settings_combos($settings_pin_combos)
							_delete_rule_combos($rule_combos)
							GUICtrlDelete($List)
							GUICtrlSetState ($button_apply_rule, $GUI_DISABLE)
							GUICtrlSetState ($button_clear_rule, $GUI_DISABLE)
							GUICtrlSetState($button_load_rule, $GUI_DISABLE)
							GUICtrlSetState($button_delete_rule, $GUI_DISABLE)
							#region Create ListView
							$List = GUICtrlCreateListView("Rule|Input A|Is|Value|AND/OR|Input B|Is|Value|Output|Is|Value|Delay|Comments", 10, 10, 700, 430,-1, 0x00000001)
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
							_GUICtrlListView_SetColumnWidth($list, 12, 155)
							#endregion
							; region Create ListView
							$rule_count = 0
							$settings_pin_combos = _create_settings_combos()
							$rule_combos = _create_rule_combos($rule_count)
							GUISwitch($clear_selec)
						EndIf
						ExitLoop
					Case $unsubmited
						GUISwitch($main)
						Dim $p[20]
						Dim $n[20]
						For $i=0 To 19
							$p[$i] = GUICtrlGetState($settings_pin_combos[$i][0])
							If $p[$i] = 144 Then
								$p[$i] = GUICtrlRead($settings_pin_combos[$i][0])
								$n[$i] = GUICtrlRead($settings_pin_combos[$i][1])
							Else
								$p[$i] = ""
								$n[$i] = ""
							EndIf
						Next
						_delete_settings_combos($settings_pin_combos)
						$settings_pin_combos = _create_settings_combos($p[0], $p[1], $p[2], $p[3], $p[4], $p[5], $p[6], $p[7], $p[8], $p[9], $p[10], $p[11], $p[12], $p[13], $p[14], $p[15], $p[16], $p[17], $p[18], $p[19], _
																	   $n[0], $n[1], $n[2], $n[3], $n[4], $n[5], $n[6], $n[7], $n[8], $n[9], $n[10], $n[11], $n[12], $n[13], $n[14], $n[15], $n[16], $n[17], $n[18], $n[19])
						$a = _read_rules_from_list($list_items)
						_disable_declared_pins($settings_pin_combos, $a)
						GUISwitch($clear_selec)
						ExitLoop
				EndSwitch
			WEnd
			GUISwitch($main)
			GUIDelete($clear_selec)
		Case $button_submit
			$change = 1
			GUICtrlSetState ($button_apply_rule, $GUI_ENABLE)
			GUICtrlSetState ($button_clear_rule, $GUI_ENABLE)
			GUICtrlSetState ($button_generate, $GUI_ENABLE)
			$a = _read_rules_from_list($list_items)
			$check = _disable_declared_pins($settings_pin_combos, $a) ; Disable the selected pins and write names to the empty ones
			If $check = "OK" Then
				$pin_names = _read_settings_names($settings_pin_combos) ; Get the names of the declared pins
				_delete_rule_combos($rule_combos)
				$rule_combos = _create_rule_combos($rule_count)
				_update_rule_combos_inputs($pin_names, $rule_combos) ; Set the pin options in the input combos
				$a = _read_rules_from_list($list_items)
				_update_rule_combos_virtuals($a, $rule_combos)
			EndIf
		Case $boole_calc_menu
			If IsDeclared("pin_names") 	= 0 Then
				MsgBox(48, "ERROR", "Click the Submit Button Before Use")
			Else
				$a = _read_rules_from_list($list_items)
				$rule_count = _boole_calc($settings_pin_combos, $a)
				_delete_rule_combos($rule_combos) ; Empty the rule combos
				$rule_combos = _create_rule_combos($rule_count)
				_update_rule_combos_inputs($pin_names, $rule_combos)
				$a = _read_rules_from_list($list_items)
				_update_rule_combos_virtuals($a, $rule_combos)
				_disable_declared_pins($settings_pin_combos, $a)
			EndIf
		Case $boole_table_menu
			If IsDeclared("pin_names") 	= 0 Then
				MsgBox(48, "ERROR", "Click the Submit Button Before Use")
			Else
				$a = _read_rules_from_list($list_items)
				$c = _boole_panel($settings_pin_combos, $a) ; Create the boole truth table window
				If $c <> "False" Then
					Dim $d[13]
					For $i=0 To UBound($c, 2)-1
						For $l=0 To 12
							$d[$l] = $c[$l][$i]
						Next
						$b = _write_rule_to_list ($d) ; Write rule to list
						$list_items[$rule_count] = $b ; Store rule to $list_items
						ReDim $list_items[$rule_count + 2]
						$rule_count += 1
					Next
					_delete_rule_combos($rule_combos) ; Empty the rule combos
					$rule_combos = _create_rule_combos($rule_count)
					_update_rule_combos_inputs($pin_names, $rule_combos)
					$a = _read_rules_from_list($list_items)
					_update_rule_combos_virtuals($a, $rule_combos)
					_disable_declared_pins($settings_pin_combos, $a)
				EndIf
			EndIf
		Case $boole_table_im_menu
			If IsDeclared("pin_names") 	= 0 Then
				MsgBox(48, "ERROR", "Click the Submit Button Before Use")
			Else
				$a = _read_rules_from_list($list_items)
				$rule_count = _boole_table_im($settings_pin_combos, $a)
				_delete_rule_combos($rule_combos) ; Empty the rule combos
				$rule_combos = _create_rule_combos($rule_count)
				_update_rule_combos_inputs($pin_names, $rule_combos)
				$a = _read_rules_from_list($list_items)
				_update_rule_combos_virtuals($a, $rule_combos)
				_disable_declared_pins($settings_pin_combos, $a)
			EndIf
		Case $rule_combos[1]
			_update_rule_combos_others($pin_names, $rule_combos, 1)
		Case $rule_combos[2] ; If Comparison is selected
			If StringInStr(GUICtrlRead($rule_combos[2]), "<<>>") <> 0 Then
				If $pin_names[0][2] <= 1 And $pin_names[0][3] = 0 Then
					MsgBox(16, "ERROR", "The Selected Input Is The " & @LF & "Only Analog Pin Declared. " & @LF & @LF & "Comparison Not Possible.")
				Else
					$comp_data = _comparison_select(GUICtrlRead($rule_combos[1]), $pin_names)
					If $comp_data <> "0" Then GUICtrlSetData($rule_combos[3], $comp_data)
				EndIf
			EndIf
		Case $rule_combos[5]
			_update_rule_combos_others($pin_names, $rule_combos, 2)
		Case $rule_combos[6] ; If Comparison is selected
			If StringInStr(GUICtrlRead($rule_combos[6]), "<<>>") <> 0 Then
				If $pin_names[0][2] <= 1 And $pin_names[0][3] = 0 Then
					MsgBox(16, "ERROR", "The Selected Input Is The " & @LF & "Only Analog Pin Declared. " & @LF & @LF & "Comparison Not Possible.")
				Else
					$comp_data = _comparison_select(GUICtrlRead($rule_combos[5]), $pin_names)
					If $comp_data <> "0" Then GUICtrlSetData($rule_combos[7], $comp_data)
				EndIf
			EndIf
		Case $rule_combos[8]
			_update_rule_combos_others($pin_names, $rule_combos, 3)
		Case $rule_combos[9] ; If Expression is selected
			If StringInStr(GUICtrlRead($rule_combos[9]), "f(x)") <> 0 Then
				If $pin_names[0][2] = 0 And $pin_names[0][3] <= 1 Then
					MsgBox(16, "ERROR", "The Selected Output Is The " & @LF & "Only Analog Pin Declared. " & @LF & @LF & "Expression Not Possible.")
				Else
					$expr_gui = GUICreate("Create Output Expression", 432, 154, 211, 189)
					GUICtrlCreateLabel("Set Output ", 24, 16, 58, 17)
					GUICtrlCreateInput(GUICtrlRead($rule_combos[8]), 92, 13, 110, 20, 0x0880) ; 0x0880=0x0080($ES_AUTOHSCROLL) + 0x0800($ES_READONLY)
					GUICtrlCreateLabel("Equal To :", 216, 16, 47, 17)
					$in_selec = GUICtrlCreateCombo("", 24,56,145,25, 0x0003)
					If $pin_names[0][2] > 0 Or $pin_names[0][3] > 0 Then ; Set the options in the input selection (only analog inputs and outputs can be selected)
						$a=""
						If $pin_names[0][2] > 0 Then
							For $i=1 To $pin_names[0][2]
								$a &= $pin_names[$i][2] & "|"
							Next
						EndIf
						If $pin_names[0][3] > 0 Then
							For $i=1 To $pin_names[0][3]
								If $pin_names[$i][3] <> GUICtrlRead($rule_combos[8]) Then ; Avoid declaring the output in function of it's self
									$a &= $pin_names[$i][3] & "|"
								EndIf
							Next
						EndIf
						GUICtrlSetData(-1, StringTrimRight($a, 1))
					EndIf
					$praxi = GUICtrlCreateCombo(" * Multiple", 184, 56, 85, 25, 0x0003)
					GUICtrlSetData(-1, " / Divide| + Add| - Remove")
					$timi = GUICtrlCreateInput("", 284, 56, 121, 21, 0x2080) ; 0x2080=0x0080($ES_AUTOHSCROLL) + 0x2000($ES_NUMBER)
					$ok_b = GUICtrlCreateButton("OK", 122, 114, 75, 25)
					$canc_b = GUICtrlCreateButton("Cancel", 223, 114, 75, 25)
					GUISetState(@SW_SHOW)
					While 1
						$nMsg = GUIGetMsg()
						Switch $nMsg
							Case $GUI_EVENT_CLOSE
								ExitLoop
							Case $canc_b
								ExitLoop
							Case $ok_b
								If GUICtrlRead($in_selec) <> "" And GUICtrlRead($praxi) <> "" And GUICtrlRead($timi) <> 0 Then
									$expression = "f(x) = " & "\" & GUICtrlRead($in_selec) & "\" & StringTrimLeft(StringLeft(GUICtrlRead($praxi), 2), 1) & "\" & GUICtrlRead($timi)
									GUISwitch($main)
									GUICtrlDelete($rule_combos[10])
									$rule_combos[10] = GUICtrlCreateInput($expression, 386, 509, 100, 25, 0x0880) ; 0x0880=0x0080($ES_AUTOHSCROLL) + 0x0800($ES_READONLY)
									ExitLoop
								Else
									MsgBox (16, "ERROR", "Missing Value In Expression")
								EndIf
						EndSwitch
					WEnd
					GUIDelete($expr_gui)
				EndIf
			EndIf			
		Case $rule_combos[0] ; If a Rule is selected for loading
			If GUICtrlRead($rule_combos[0]) < $rule_count Then
				GUICtrlSetState($button_load_rule, $GUI_ENABLE)
				GUICtrlSetState($button_apply_rule, $GUI_DISABLE)
				GUICtrlSetState($button_delete_rule, $GUI_ENABLE)
				GUICtrlSetState($button_clear_rule, $GUI_DISABLE)
			Else
				GUICtrlSetState($button_load_rule, $GUI_DISABLE)
				GUICtrlSetState($button_apply_rule, $GUI_ENABLE)
				GUICtrlSetState($button_delete_rule, $GUI_DISABLE)
				GUICtrlSetState($button_clear_rule, $GUI_ENABLE)
			EndIf
	EndSwitch
WEnd

; #FUNCTION# (Internal Use)
; Name...........: 	_create_rules_from_table
; Description ...: 	Creates the Rules based on a truth table showing the state of inputs and output
; Parameters ....: 	$table_inputs: An array containing the states of the inputs
;					$table_output: Array containing the states of the output
;					$inputs: Array holding the names of the inputs
;					$output: Variable holding the name of the output
;					$max_virtual: Variable holding the max Virtual Coil previously used
;					$rule_number: The current rule count
; Return values .:	Returns the current rule_count after the creation of the rules
; Remarks........:	The function is for internal use inside the "_boole_table_im" function
;					The number of inputs that the function can handle is from 1 to 9 and 1 output
;					Only Digital Inputs and Outputs are available in the truth table
; ============================================================================================================================================
Func _create_rules_from_table($table_inputs, $table_output, $inputs, $output, $max_virtual, $rule_number)
	Local $rule[13]
	For $i=0 To UBound($table_inputs, 1) - 1 Step 4
		For $j=$i To $i+3
			$rule[0] = $rule_number
			$rule[1] = $inputs[UBound($inputs)-2]
			$rule[2] = "="
			If $table_inputs[$j][UBound($inputs)-2] = "1" Then $rule[3] = "High"
			If $table_inputs[$j][UBound($inputs)-2] = "0" Then $rule[3] = "Low"
			$rule[4] = "AND"
			$rule[5] = $inputs[UBound($inputs)-1]
			$rule[6] = "="
			If $table_inputs[$j][UBound($inputs)-1] = "1" Then $rule[7] = "High"
			If $table_inputs[$j][UBound($inputs)-1] = "0" Then $rule[7] = "Low"
			$rule[8] = "Virtual_Coil_" & $max_virtual+Int($i/4)+1
			$rule[9] = "="
			If $table_output[$j] = "1" Then $rule[10] = "High"
			If $table_output[$j] = "0" Then $rule[10] = "Low"
			;$virtual_max += 1
			$b = _write_rule_to_list ($rule)
			$list_items[$rule_number] = $b ; Using a Global Array ($list_items)
			ReDim $list_items[$rule_number + 2]
			$rule_number += 1
		Next
	Next
	For $i=UBound($table_inputs, 2) - 3 To 0 Step -1
		Local $list_temp[UBound($list_items)]
		For $j=0 To UBound($list_items)-1
			$list_temp[$j] = GUICtrlRead($list_items[$j]) ; Global Variable used
		Next	
		$virt = _find_max_virt_coil($list_temp)
		For $j=1 To 2^$i*2
			For $h=0 To 1
				$rule[0] = $rule_number
				$rule[1] = $inputs[$i]
				$rule[2] = "="
				If Mod($j, 2) <> 0 Then $rule[3] = "Low"
				If Mod($j, 2) = 0 Then $rule[3] = "High"
				$rule[4] = "AND"
				$rule[5] = "Virtual_Coil_" & $virt-(2^$i*2)+$j
				$rule[6] = "="
				If $h = 0 Then $rule[7] = "Low"
				If $h = 1 Then $rule[7] = "High"
				If $i=0 Then
					$rule[8] = $output
				Else 
					$rule[8] = "Virtual_Coil_" & $virt+Int(($j+1)/2)
				EndIf
				$rule[9] = "="
				If $h = 0 Then $rule[10] = "Low"
				If $h = 1 Then $rule[10] = "High"
				$b = _write_rule_to_list ($rule)
				$list_items[$rule_number] = $b ; Using a Global Array ($list_items)
				ReDim $list_items[$rule_number + 2]
				$rule_number += 1
			Next
		Next
	Next
	Return $rule_number
EndFunc

; #FUNCTION#
; Name...........: 	_boole_table_im
; Description ...: 	Create a Boolean truth table GUI Window, whichs allows the user to create rules using a more scientific way
; Parameters ....: 	$settings: Array containing the controlID's of the settings combos
;					$rules: Array containing each rule allready created.(used for calculating the virtual coils)
;					$rule_number: Variable holding the number of rules allready created
; Return values .:	Creates and writes all the rules needed according to the truth table created by the user
;					Returns the current rule_count after the creation of the rules
; Remarks........:	The function is a generalized version of the _boole_panel function which accepts more than 2 inputs
;					The function can handle only 1 output and inputs from min:2 to max:9 inputs
;					Only Digital Inputs and Outputs are available in the truth table
; ============================================================================================================================================
Func _boole_table_im($settings, $rules, $rule_number=$rule_count)
	$names = _read_settings_names($settings)
	$pins = _read_settings_combos($settings)
	$panel_win = GUICreate("BOOLE TRUTH TABLE", 578, 484, 218, 127)
	$input_amount_combo = GUICtrlCreateInput("", 8, 24, 113, 21, 0x2000)
	If $pins[0][0] <= 9 Then
		$max_inputs = $pins[0][0]
	Else
		$max_inputs = 9
	EndIf
	GUICtrlCreateLabel("Enter Amount Of Inputs (min=1 max=" & $max_inputs & ")", 8, 9, 197, 13)
	$button_ok = GUICtrlCreateButton("OK", 152, 26, 43, 19)
	$button_create = GUICtrlCreateButton("Create Table", 128, 396, 75, 25)
	GUICtrlSetState(-1, $GUI_DISABLE)
	$button_cancel = GUICtrlCreateButton("Cancel", 40, 396, 75, 25)
	$button_pass = GUICtrlCreateButton("Create Rules", 128, 446, 75, 25)
	GUICtrlSetState(-1, $GUI_DISABLE)
	$button_fill_inputs = GUICtrlCreateButton("Fill Inputs", 510, 14, 60, 20)
	GUICtrlSetState(-1, $GUI_DISABLE)
	GUICtrlCreateGraphic(219, 0, 1, 483)
	GUICtrlSetBkColor(-1, 0x000000)
	GUISetState(@SW_SHOW)
	$child = GUICreate ("", 345, 424, 225, 40, $WS_CHILD, $WS_EX_CLIENTEDGE, $panel_win) ; Create a "child" GUI for scrolling use
	GUISetState(@SW_SHOW)
	GUISwitch($panel_win)
	While 1
		$eMsg = GUIGetMsg()
		; toggle buttons data
		If IsDeclared("amount") <> 0 And IsDeclared("buttons_in") <> 0 And IsDeclared("buttons_out") <> 0 Then
			For $i=0 To 2^$amount-1
				For $j=0 To $amount-1
					If $eMsg = $buttons_in[$i][$j] Then
						If GUICtrlRead($buttons_in[$i][$j]) = "0" Then
							GUICtrlSetData($buttons_in[$i][$j], "1")
						ElseIf GUICtrlRead($buttons_in[$i][$j]) = "1" Then
							GUICtrlSetData($buttons_in[$i][$j], "0")
						EndIf
					EndIf
				Next
				If $eMsg = $buttons_out[$i] Then
					If GUICtrlRead($buttons_out[$i]) = "0" Then
						GUICtrlSetData($buttons_out[$i], "1")
					ElseIf GUICtrlRead($buttons_out[$i]) = "1" Then
						GUICtrlSetData($buttons_out[$i], "0")
					EndIf
				EndIf
			Next
		EndIf
		Switch $eMsg
			Case $GUI_EVENT_CLOSE
				ExitLoop
			Case $button_cancel
				ExitLoop
			Case $button_ok
				If GUICtrlRead($input_amount_combo) > $max_inputs Or GUICtrlRead($input_amount_combo) < 1 Then
					MsgBox (48, "ERROR", "Amount Of Inputs Not Compatible")
				Else
					$output_pin_combo = GUICtrlCreateCombo("", 8, 70, 145, 25, BitOr($CBS_DROPDOWNLIST, $WS_VSCROLL))
					GUICtrlCreateLabel(" Select Output Pin", 8, 54, 90, 15)
					$amount = GUICtrlRead($input_amount_combo)
					Local $input_combos[$amount]
					For $i=0 To $amount-1
						$input_combos[$i] = GUICtrlCreateCombo("", 64, 126+$i*24, 145, 25, BitOr($CBS_DROPDOWNLIST, $WS_VSCROLL))
						GUICtrlCreateLabel("Input_" & $i+1, 12, 130+$i*24)
					Next
					#region Update the combos with inputs
					$a=""
					For $i = 1 To $names[0][0] ; Loop over the DI pins
						$a = $a & $names[$i][0] & "|"
					Next
					For $i = 1 To $names[0][1] ; Loop over the DO pins
						$a = $a & $names[$i][1] & "|"
					Next
					If $a <> "" Then
						For $i=0 To $amount-1
							GUICtrlSetData($input_combos[$i], $a)
						Next
					EndIf
					; Update the output
					$a=""
					For $i = 1 To $names[0][1] ; Loop over the DO pins
						$a = $a & $names[$i][1] & "|"
					Next
					If $a <> "" Then
						GUICtrlSetData($output_pin_combo, $a)
					EndIf
					#endregion
					#region Update the combos with virtuals
					Local $temp[UBound($rules)]
					Local $temp_c[UBound($rules)]
					Local $a[13] = ["", "", "", "", "", "", "", "", "", "", "", "", ""]
					Local $a_c[13] = ["", "", "", "", "", "", "", "", "", "", "", "", ""]
					; Update the Virtuals Coils
					For $i=0 To UBound($rules)-1
						If StringInStr($rules[$i], "|") > 0 Then ; If the rule being processed is not empty
							$a=StringSplit($rules[$i], "|", 2)
						EndIf
						If StringInStr($a[8], "Virtual_Coil") > 0 Then
							$temp[$i] = StringMid ($a[8], 14)
						EndIf
					Next
					If _ArrayMax($temp, 1) >= 1 Then
						$b=""
						For $j=1 To _ArrayMax($temp, 1)
							$b=$b & "Virtual_Coil_" & $j & "|"
						Next
						; Update the inputs
						$in_1_coil = $b
						;$in_2_coil = $b
						;Update the outputs
						$b=$b & "Virtual_Coil_" & (_ArrayMax($temp, 1) + 1) & "|"
						$out_coil = $b
					Else
						$in_1_coil = ""
						;$in_2_coil = ""
						$out_coil = "Virtual_Coil_1|"
					EndIf
					For $i=0 To $amount-1
						GUICtrlSetData($input_combos[$i], $in_1_coil & " ")
					Next
					GUICtrlSetData($output_pin_combo, $out_coil)
					#endregion
					GUICtrlSetState($button_create, $GUI_ENABLE)
				EndIf
			Case $button_create
				$check_completion = 0
				If GUICtrlRead($output_pin_combo) = "" Then $check_completion = 1
				For $i=0 To $amount-1
					If GUICtrlRead($input_combos[$i]) = "" then $check_completion = 2
				Next
				If $check_completion = 1 Then
					MsgBox(16, "ERROR", "Output Not Declared")
				ElseIf $check_completion = 2 Then
					MsgBox(16, "ERROR", "Inputs Not Declared")
				Else
					GUICtrlSetState($button_pass, $GUI_ENABLE)
					GUICtrlSetState($button_create, $GUI_DISABLE)
					$fScroll = False
					For $i=1 To $amount
						GUICtrlCreateLabel($i, 260+($i-1)*25, 17)
					Next
					GUICtrlCreateLabel("Out", 258+($i-1)*25, 17)
					Local $buttons_in[2^$amount][$amount]
					Local $buttons_out[2^$amount]
					GUISwitch($child)
					; Manual correction of position of buttons when the scrollbars are needed
					If (2^$amount*25) > 420 Then
						$cor = 1
					Else
						$cor = 0
					EndIf
					; Create the buttons
					For $i=0 To 2^$amount-1
						For $j=0 To $amount-1
							$buttons_in[$i][$j] = GUICtrlCreateButton("0", 30+$j*(25+$cor), 2+$i*25, 20, 20) ; Input buttons
						Next
						GUICtrlCreateLabel($i+1 & ")", 2, 5+$i*25)
						$buttons_out[$i] = GUICtrlCreateButton("0", 30+$j*(25+$cor), 2+$i*25, 20, 20) ; Output buttons
					Next
					GUICtrlCreateGraphic(27+$j*(25+$cor), 0, 1, 2+$i*25)
					GUICtrlSetBkColor(-1, 0x000000)
					; Creation of the scrollbar
					If (2^$amount*25) > 420 Then ; If buttons don't fit to window
						$aRet = _GUIScrollbars_Size(0, 2^$amount*25, 0, 420) ; Calculate new scrolling page and max values
						If $fScroll = False Then ; If the scrollbar has not been created before then create it
							GUIRegisterMsg($WM_VSCROLL, "_Scrollbars_WM_VSCROLL")
							_GUIScrollBars_Init($child)
							_GUIScrollBars_ShowScrollBar($child, $SB_VERT, True)
							_GUIScrollBars_ShowScrollBar($child, $SB_HORZ, False)
							_GUIScrollBars_SetScrollInfoPage($child, $SB_VERT, $aRet[2])
							_GUIScrollBars_SetScrollInfoMax($child, $SB_VERT, $aRet[3])
							_GUIScrollBars_SetScrollInfoPos($child, $SB_VERT, $aRet[3])
							$fScroll = True
						Else ; If the scrollbar has been created before then adjust it
							_GUIScrollBars_SetScrollInfoPage($child, $SB_VERT, $aRet[2])
							_GUIScrollBars_SetScrollInfoMax($child, $SB_VERT, $aRet[3])
							_GUIScrollBars_SetScrollInfoPos($child, $SB_VERT, $aRet[3])
						EndIf
					EndIf
					GUISwitch($panel_win)
					GUICtrlSetState($button_fill_inputs, $GUI_ENABLE)
				EndIf
			Case $button_fill_inputs
				$possible_truth_table = _create_possible_truth_table($amount) ; This is for creating the buttons with all the possible states as default
				For $i=0 To 2^$amount-1
					For $j=0 To $amount-1
						GUICtrlSetData($buttons_in[$i][$j], $possible_truth_table[$i][$j])
					Next
				Next
			Case $button_pass
				If $amount > 2 Then
					Local $input_states[2^$amount][$amount]
					Local $output_states[2^$amount]
					For $i=0 To 2^$amount - 1
						For $j=0 To $amount - 1
							$input_states[$i][$j] = GUICtrlRead($buttons_in[$i][$j])
						Next
						$output_states[$i] = GUICtrlRead($buttons_out[$i])
					Next
					Local $input_names[$amount]
					For $i=0 To $amount-1
						$input_names[$i] = GUICtrlRead($input_combos[$i])
					Next
					$output_name = GUICtrlRead($output_pin_combo)
					Local $temp_list[UBound($list_items)]
					For $j=0 To UBound($list_items)-1
						$temp_list[$j] = GUICtrlRead($list_items[$j]) ; Global Variable used
					Next	
					$max_virt = _find_max_virt_coil($temp_list)
					; Increase the max Virtual Coil by 1 to prevent duplication when a Virtual Coil is set as output
					If StringInStr($output_name, "Virtual_Coil") <> 0 Then $max_virt += 1	
					$rule_number = _create_rules_from_table($input_states, $output_states, $input_names, $output_name, $max_virt, $rule_number)
				Else
					Local $check [2^$amount]
					For $i=0 To 2^$amount-1
						For $j=0 To $amount-1
							$check[$i] &= GUICtrlRead($buttons_in[$i][$j])
						Next
						$check[$i] &= GUICtrlRead($buttons_out[$i])
					Next
					$check_u = _ArrayUnique($check)
					Local $input_names[$amount]
					For $i=0 To $amount-1
						$input_names[$i] = GUICtrlRead($input_combos[$i])
					Next
					$output_name = GUICtrlRead($output_pin_combo)
					For $i = 1 To $check_u[0]
						Local $temp_list[UBound($list_items)]
						For $j=0 To UBound($list_items)-1
							$temp_list[$j] = GUICtrlRead($list_items[$j]) ; Global Variable used
						Next
						$max_virt = _find_max_virt_coil($temp_list)
						; Increase the max Virtual Coil by 1 to prevent duplication when a Virtual Coil is set as output
						If StringInStr(GUICtrlRead($output_pin_combo), "Virtual_Coil") <> 0 Then $max_virt += 1
						$rule_number = _create_rules_from_string($check_u[$i], $input_names, $output_name, $max_virt, $rule_number)
					Next
				EndIf
				ExitLoop
		EndSwitch
	WEnd
	GUIDelete()
	Return $rule_number
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

; #FUNCTION# (Internal Use)
; Name...........: 	_create_rules_from_string
; Description ...: 	Creates the Rules based on a string showing the state of inputs and output
; Parameters ....: 	$string: The string containing the data showing the state of inputs and output
;							 eq. $string = "11001". The last digit represents the state of the Output and all the previous ones represent the state of the inputs
;					$inputs: Array containing the names of the inputs
;					$output: Variable holding the name of the output
;					$max_virtual: Variable holding the max Virtual Coil previously used
;					$rule_number: The current rule count
; Return values .:	Returns the current rule_count after the creation of the rules
; Remarks........:	The function is for internal use inside the "_boole_table_im" function
;					The number of inputs that the function can handle is from 1 to 9 and 1 output
;					Only Digital Inputs and Outputs are available in the truth table
; ============================================================================================================================================
Func _create_rules_from_string($string, $inputs, $output, $max_virtual, $rule_number)
	$number_of_inputs = StringLen($string) - 1
	If $number_of_inputs > 9 Then Return $rule_number
	$string_array = StringSplit($string, "")
	Local $rule[13]
	If $number_of_inputs > 2 Then
		; 1st Pass Containing the first 2 inputs
		$rule[0] = $rule_number
		$rule[1] = $inputs[0]
		$rule[2] = "="
		If $string_array[1] = "1" Then $rule[3] = "High"
		If $string_array[1] = "0" Then $rule[3] = "Low"
		$rule[4] = "AND"
		$rule[5] = $inputs[1]
		$rule[6] = "="
		If $string_array[2] = "1" Then $rule[7] = "High"
		If $string_array[2] = "0" Then $rule[7] = "Low"
		$rule[8] = "Virtual_Coil_" & $max_virtual+1
		$rule[9] = "="
		$rule[10] = "High"
		$b = _write_rule_to_list ($rule)
		$list_items[$rule_number] = $b ; Using a Global Array ($list_items)
		ReDim $list_items[$rule_number + 2]
		$rule_number += 1
		#region Create opposite rule
		If $rule[1] <> "" Or $rule[5] <> "" Then ; If both inputs are empty don't create opposite rule
			$c = _create_opposite_rule($rule)
			$b = _write_rule_to_list ($c) ; Write rule to list
			$list_items[$rule_number] = $b ; Store rule to $list_items
			ReDim $list_items[$rule_number + 2]
			$rule_number += 1
		EndIf	
		#endregion
		; The midle Passes containing the produced Virtual Coil and the next input in line 
		For $i=0 To $number_of_inputs-4
			$rule[0] = $rule_number
			$rule[1] = $rule[8]
			$rule[2] = "="
			$rule[3] = $rule[10]
			$rule[4] = "AND"
			$rule[5] = $inputs[$i+2]
			$rule[6] = "="
			If $string_array[$i+3] = "1" Then $rule[7] = "High"
			If $string_array[$i+3] = "0" Then $rule[7] = "Low"
			$rule[8] = StringMid($rule[8], 1, 13) & Number(StringMid($rule[8], 14)) + 1
			$rule[9] = "="
			$rule[10] = "High"
			$b = _write_rule_to_list ($rule)
			$list_items[$rule_number] = $b ; Using a Global Array ($list_items)
			ReDim $list_items[$rule_number + 2]
			$rule_number += 1
			#region Create opposite rule
			If $rule[1] <> "" Or $rule[5] <> "" Then ; If both inputs are empty don't create opposite rule
				$c = _create_opposite_rule($rule)
				$b = _write_rule_to_list ($c) ; Write rule to list
				$list_items[$rule_number] = $b ; Store rule to $list_items
				ReDim $list_items[$rule_number + 2]
				$rule_number += 1
			EndIf	
			#endregion
		Next
		;final Pass containing the produced Virtual Coil and the output
		$rule[0] = $rule_number
		$rule[1] = $rule[8]
		$rule[2] = "="
		$rule[3] = $rule[10]
		$rule[4] = "AND"
		$rule[5] = $inputs[$number_of_inputs - 1] ; The last input
		$rule[6] = "="
		If $string_array[$number_of_inputs] = "1" Then $rule[7] = "High" ; Check the last input
		If $string_array[$number_of_inputs] = "0" Then $rule[7] = "Low" ; Check the last input
		$rule[8] = $output
		$rule[9] = "="
		If $string_array[$number_of_inputs + 1] = "1" Then $rule[10] = "High" ; Check the output
		If $string_array[$number_of_inputs + 1] = "0" Then $rule[10] = "Low" ; Check the output
		$b = _write_rule_to_list ($rule)
		$list_items[$rule_number] = $b ; Using a Global Array ($list_items)
		ReDim $list_items[$rule_number + 2]
		$rule_number += 1
		Return $rule_number
	ElseIf $number_of_inputs = 2 Then
		$rule[0] = $rule_number
		$rule[1] = $inputs[0]
		$rule[2] = "="
		If $string_array[1] = "1" Then $rule[3] = "High"
		If $string_array[1] = "0" Then $rule[3] = "Low"
		$rule[4] = "AND"
		$rule[5] = $inputs[1]
		$rule[6] = "="
		If $string_array[2] = "1" Then $rule[7] = "High"
		If $string_array[2] = "0" Then $rule[7] = "Low"
		$rule[8] = $output
		$rule[9] = "="
		If $string_array[$number_of_inputs + 1] = "1" Then $rule[10] = "High" ; Check the output
		If $string_array[$number_of_inputs + 1] = "0" Then $rule[10] = "Low" ; Check the output
		$b = _write_rule_to_list ($rule)
		$list_items[$rule_number] = $b ; Using a Global Array ($list_items)
		ReDim $list_items[$rule_number + 2]
		$rule_number += 1
		Return $rule_number
	ElseIf $number_of_inputs = 1 Then
		$rule[0] = $rule_number
		$rule[1] = $inputs[0]
		$rule[2] = "="
		If $string_array[1] = "1" Then $rule[3] = "High"
		If $string_array[1] = "0" Then $rule[3] = "Low"
		$rule[8] = $output
		$rule[9] = "="
		If $string_array[$number_of_inputs + 1] = "1" Then $rule[10] = "High" ; Check the output
		If $string_array[$number_of_inputs + 1] = "0" Then $rule[10] = "Low" ; Check the output
		$b = _write_rule_to_list ($rule)
		$list_items[$rule_number] = $b ; Using a Global Array ($list_items)
		ReDim $list_items[$rule_number + 2]
		$rule_number += 1
		Return $rule_number
	EndIf
EndFunc

; #FUNCTION#
; Name...........: 	_boole_panel
; Description ...: 	Create a Boolean truth table GUI Window, whichs allows the user to create rules using a more scientific way
; Parameters ....: 	$settings: Array containing the controlID's of the settings combos
;					$rules: Array containing each rule allready created.(used for calculating the virtual coils)
;					$rule_number: Variable holding the number of rules allready created
; Return values .:	Success: A 2D array containing the data of the rules to be created
;					Failure: "False"
; Remarks........:	The function can handle only 2 inputs and 1 output
;					Only Digital Inputs and Outputs are available in the truth table
; ============================================================================================================================================
Func _boole_panel($settings, $rules, $rule_number=$rule_count)
	$names = _read_settings_names($settings)
	$pins = _read_settings_combos($settings)
	$panel_win = GUICreate("BOOLE TRUTH TABLE", 229, 346, 325, 163)
	Local $buttons[12]
	For $j=0 To 8 Step 4
		For $i=0 To 3
			$buttons[$j+$i] = GUICtrlCreateButton("0", 69+$j*9.5, 152+$i*32, 25, 25)
			If $j=8 Then GUICtrlSetFont(-1, 8, 800, 0, "MS Sans Serif")
		Next
	Next
	$combo_a = GUICtrlCreateCombo("", 64, 24, 145, 25, BitOr($CBS_DROPDOWNLIST, $WS_VSCROLL))
	$combo_b = GUICtrlCreateCombo("", 64, 56, 145, 25, BitOr($CBS_DROPDOWNLIST, $WS_VSCROLL))
	$combo_o = GUICtrlCreateCombo("", 64, 88, 145, 25, BitOr($CBS_DROPDOWNLIST, $WS_VSCROLL))
	GUICtrlCreateLabel("A", 78, 128, 11, 12)
	GUICtrlCreateLabel("B", 111, 128, 11, 12)
	GUICtrlCreateLabel("O", 150, 128, 12, 12)
	GUICtrlCreateLabel("Input A", 20, 24, 38, 17)
	GUICtrlCreateLabel("Input B", 20, 56, 38, 17)
	GUICtrlCreateLabel("Output", 20, 88, 36, 17)
	$button_ok = GUICtrlCreateButton("OK", 125, 296, 75, 25)
	$button_cancel = GUICtrlCreateButton("Cancel", 29, 296, 75, 25)
	#region Graphics
	GUICtrlCreateGraphic(64, 144, 112, 1)
	GUICtrlSetColor(-1, 0x000000)
	GUICtrlCreateGraphic(64, 121, 1, 158)
	GUICtrlSetColor(-1, 0x000000)
	GUICtrlCreateGraphic(64, 278, 112, 1)
	GUICtrlSetColor(-1, 0x000000)
	GUICtrlCreateGraphic(64, 121, 112, 1)
	GUICtrlSetColor(-1, 0x000000)
	GUICtrlCreateGraphic(176, 121, 1, 158)
	GUICtrlSetColor(-1, 0x000000)
	GUICtrlCreateGraphic(138, 121, 1, 158)
	GUICtrlSetColor(-1, 0x000000)
	GUICtrlCreateGraphic(99, 121, 1, 158)
	GUICtrlSetColor(-1, 0x000000)
	#endregion
	#region Update the combos with inputs
	$a=""
	For $i = 1 To $names[0][0] ; Loop over the DI pins
		$a = $a & $names[$i][0] & "|"
	Next
	For $i = 1 To $names[0][1] ; Loop over the DO pins
		$a = $a & $names[$i][1] & "|"
	Next
	If $a <> "" Then
		GUICtrlSetData($combo_a, $a)
		GUICtrlSetData($combo_b, $a)
	EndIf
	; Update the outputs
	$a=""
	For $i = 1 To $names[0][1] ; Loop over the DO pins
		$a = $a & $names[$i][1] & "|"
	Next
	If $a <> "" Then
		GUICtrlSetData($combo_o, $a)
	EndIf
	#endregion
	#region Update the combos with virtuals
	Local $temp[UBound($rules)]
	Local $temp_c[UBound($rules)]
	Local $a[13] = ["", "", "", "", "", "", "", "", "", "", "", "", ""]
	Local $a_c[13] = ["", "", "", "", "", "", "", "", "", "", "", "", ""]
	; Update the Virtuals Coils
	For $i=0 To UBound($rules)-1
		If StringInStr($rules[$i], "|") > 0 Then ; If the rule being processed is not empty
			$a=StringSplit($rules[$i], "|", 2)
		EndIf
		If StringInStr($a[8], "Virtual_Coil") > 0 Then
			$temp[$i] = StringMid ($a[8], 14)
		EndIf
	Next
	If _ArrayMax($temp, 1) >= 1 Then
		$b=""
		For $j=1 To _ArrayMax($temp, 1)
			$b=$b & "Virtual_Coil_" & $j & "|"
		Next
		; Update the inputs
		$in_1_coil = $b
		$in_2_coil = $b
		;Update the outputs
		$b=$b & "Virtual_Coil_" & (_ArrayMax($temp, 1) + 1) & "|"
		$out_coil = $b
	Else
		$in_1_coil = ""
		$in_2_coil = ""
		$out_coil = "Virtual_Coil_1|"
	EndIf
	GUICtrlSetData($combo_a, $in_1_coil & " ")
	GUICtrlSetData($combo_b, $in_2_coil & " ")
	GUICtrlSetData($combo_o, $out_coil)
	#endregion
	GUISetState(@SW_SHOw)
	While 1
		$cMsg = GUIGetMsg()
		; Toggle the buttons
		For $j=0 To 8 Step 4
			For $i=0 To 3
				If $cMsg = $buttons[$j+$i] Then
					If GUICtrlRead($buttons[$j+$i]) = "0" Then
						GUICtrlSetData($buttons[$j+$i], "1")
					ElseIf GUICtrlRead($buttons[$j+$i]) = "1" Then
						GUICtrlSetData($buttons[$j+$i], "0")
					EndIf
				EndIf
			Next
		Next
		Switch $cMsg
			Case $GUI_EVENT_CLOSE
				$rule = "False"
				ExitLoop
			Case $button_cancel
				$rule = "False"
				ExitLoop
			Case $button_ok
				If GUICtrlRead($combo_o) = "" Then
					MsgBox(16, "ERROR", "No Output Has Been Declared")
					$rule = "False"
				ElseIf GUICtrlRead($combo_a) = "" Or GUICtrlRead($combo_b) = "" Then
					MsgBox(16, "ERROR", "No Input Has Been Declared")
					$rule = "False"
				ElseIf GUICtrlRead($combo_a) = GUICtrlRead($combo_b) Then
					MsgBox(16, "ERROR", "Input A Is The Same With Input B")
					$rule = "False"
				Else
					Local $check[4]
					For $i=0 To 3
						$check[$i] = GUICtrlRead($buttons[0+$i]) & GUICtrlRead($buttons[4+$i]) & GUICtrlRead($buttons[8+$i])
					Next
					$check = _ArrayUnique($check)
					Local $rule[13][$check[0]]
					For $i=1 To $check[0]
						$a=StringSplit($check[$i], "", 2)
						$rule[0][$i-1] = $rule_number
						$rule[1][$i-1] = GUICtrlRead($combo_a)
						$rule[2][$i-1] = "="
						If $a[0] = "1" Then $rule[3][$i-1] = "High"
						If $a[0] = "0" Then $rule[3][$i-1] = "Low"
						$rule[4][$i-1] = "AND"
						$rule[5][$i-1] = GUICtrlRead($combo_b)
						$rule[6][$i-1] = "="
						If $a[1] = "1" Then $rule[7][$i-1] = "High"
						If $a[1] = "0" Then $rule[7][$i-1] = "Low"
						$rule[8][$i-1] = GUICtrlRead($combo_o)
						$rule[9][$i-1] = "="
						If $a[2] = "1" Then $rule[10][$i-1] = "High"
						If $a[2] = "0" Then $rule[10][$i-1] = "Low"
						$rule_number += 1
					Next
					ExitLoop
				EndIf
		EndSwitch
	WEnd
	GUIDelete()
	Return $rule
EndFunc

; #FUNCTION#
; Name...........: 	_boole_calc
; Description ...: 	Create a calculator like GUI Window, whichs allows the user to create rules using Boolean expressions
; Parameters ....: 	$settings: Array containing the controlID's of the settings combos
;					$rules: Array containing each rule allready created.(used for calculating the virtual coils)
;					$rule_number: Variable holding the number of rules allready created
; Return values .:	Creates and writes all the rules needed according to the Boolean expression created by the user
;					Returns the current rule_count after the creation of the rules
; Remarks........:	The function can handle only 1 output and inputs from min:2 to max:9 inputs
;					Only Digital Inputs and Outputs are available in the truth table
; ============================================================================================================================================
Func _boole_calc($settings, $rules, $rule_number=$rule_count)
	$array_names = _read_settings_names($settings)
	$array_pins = _read_settings_combos($settings)
	$calc_win = GUICreate("BOOLE CALCULATOR", 471, 445, 297, 139)
	$boole_expr_input = GUICtrlCreateInput("", 16, 8, 441, 21, 0x0880)
	GUICtrlSetFont(-1, 8, 800, 0, "MS Sans Serif")
	;$label_expr = GUICtrlCreateLabel("", 16, 50, 300, 21)
	$button_and = GUICtrlCreateButton("AND", 352, 235, 45, 45)
	$button_or = GUICtrlCreateButton("OR", 352, 286, 45, 45)
	$button_not = GUICtrlCreateButton("NOT", 352, 337, 45, 45)
	$button_equal = GUICtrlCreateButton("=", 408, 286, 45, 96)
	GUICtrlSetState(-1, $GUI_DISABLE)
	$button_par_open = GUICtrlCreateButton("(", 408, 235, 20, 45)
	$button_par_close = GUICtrlCreateButton(")", 433, 235, 20, 45)
	$button_bs = GUICtrlCreateButton("<-   Bs", 352, 133, 101, 45)
	$button_clear = GUICtrlCreateButton("Clear", 352, 184, 101, 45)
	$virtuals_combo = GUICtrlCreateCombo("", 17, 190, 147, 21, BitOr($CBS_DROPDOWNLIST, $WS_VSCROLL))
	GUICtrlCreateLabel("Select Virtual", 17, 168)
	#region Update the combo with virtuals
	Local $temp[UBound($rules)]
	Local $temp_c[UBound($rules)]
	Local $a[13] = ["", "", "", "", "", "", "", "", "", "", "", "", ""]
	Local $a_c[13] = ["", "", "", "", "", "", "", "", "", "", "", "", ""]
	; Update the Virtuals Coils
	For $i=0 To UBound($rules)-1
		If StringInStr($rules[$i], "|") > 0 Then ; If the rule being processed is not empty
			$a=StringSplit($rules[$i], "|", 2)
		EndIf
		If StringInStr($a[8], "Virtual_Coil") > 0 Then
			$temp[$i] = StringMid ($a[8], 14)
		EndIf
	Next
	If _ArrayMax($temp, 1) >= 1 Then
		$b=""
		For $j=1 To _ArrayMax($temp, 1)
			$b=$b & "Virtual_Coil_" & $j & "|"
		Next
		; Update the inputs
		;$in_1_coil = $b
		;$in_2_coil = $b
		;Update the outputs
		$b=$b & "Virtual_Coil_" & (_ArrayMax($temp, 1) + 1) & "|"
		$out_coil = $b
	Else
		;$in_1_coil = ""
		;$in_2_coil = ""
		$out_coil = "Virtual_Coil_1|"
	EndIf
	GUICtrlSetData($virtuals_combo, $out_coil); & $out_count)
	#endregion
	Local $button_pins[20]
	Local $button_names[20]
	For $i = 0 To 13
		$button_pins[$i] = GUICtrlCreateButton("Pin_" & $i, 190, 360-$i*24, 45, 22)
		GUICtrlSetState(-1, $GUI_DISABLE)
		$button_names[$i] = GUICtrlCreateInput("", 248, 360-$i*24, 90, 21)
		GUICtrlSetState(-1, $GUI_DISABLE)
		For $j=1 To $array_pins[0][0] ; loop over the DI pins
			If $i = $array_pins[$j][0] Then ; If $i is a DI Pin
				GUICtrlSetState($button_pins[$i], $GUI_ENABLE)
				GUICtrlSetData($button_names[$i], $array_names[$j][0])
			EndIf
		Next
		For $j=1 To $array_pins[0][1] ; loop over the DO pins
			If $i = $array_pins[$j][1] Then ; If $i is a DO Pin
				GUICtrlSetState($button_pins[$i], $GUI_ENABLE)
				GUICtrlSetData($button_names[$i], $array_names[$j][1])
			EndIf
		Next
	Next
	For $i = 14 To 19
		$button_pins[$i] = GUICtrlCreateButton("Pin_A" & $i-14, 17, 237+($i-14)*24, 45, 22)
		GUICtrlSetState(-1, $GUI_DISABLE)
		$button_names[$i] = GUICtrlCreateInput("", 74, 237+($i-14)*24, 90, 21)
		GUICtrlSetState(-1, $GUI_DISABLE)
		For $j=1 To $array_pins[0][0] ; loop over the DI pins
			If $i = $array_pins[$j][0] Then ; If $i is a DI Pin
				GUICtrlSetState($button_pins[$i], $GUI_ENABLE)
				GUICtrlSetData($button_names[$i], $array_names[$j][0])
			EndIf
		Next
		For $j=1 To $array_pins[0][1] ; loop over the DO pins
			If $i = $array_pins[$j][1] Then ; If $i is a DO Pin
				GUICtrlSetState($button_pins[$i], $GUI_ENABLE)
				GUICtrlSetData($button_names[$i], $array_names[$j][1])
			EndIf
		Next
	Next
	$button_ok = GUICtrlCreateButton("OK", 246, 400, 75, 30)
	$button_cancel = GUICtrlCreateButton("Cancel", 150, 400, 75, 30)
	GUISetState(@SW_SHOW)
	$expr=""
	$work_expr = ""
	$button_group_pressed = 2 ; 1 for inputs and 2 for actions
	While 1
		If $expr <> GUICtrlRead($boole_expr_input) Then
			GUICtrlSetData($boole_expr_input, $expr)
			;GUICtrlSetData($label_expr, $work_expr)
		EndIf
		$bMsg = GUIGetMsg()
		For $i=0 To 19
			If $bMsg = $button_pins[$i] Then
				If $button_group_pressed = 1 Then
					MsgBox(16, "ERROR", "Syntax Error, Waiting For Action")
				Else
					$expr &= GUICtrlRead($button_names[$i])
					$work_expr &= GUICtrlRead($button_names[$i]) & "\"
					$button_group_pressed = 1
				EndIf
			EndIf
		Next
		; Enable and disable the " = " button so that the output will always be at the end of the expression
		If StringInStr($work_expr, "= \") <> 0 Then
			If GUICtrlGetState($button_equal) = 80 Then GUICtrlSetState($button_equal, $GUI_DISABLE)
		EndIf
		If StringInStr($work_expr, "= \") = 0 Then
			If StringInStr($work_expr, "+ \") <> 0 Or StringInStr($work_expr, "* \") <> 0 Then
				If GUICtrlGetState($button_equal) = 144 Then GUICtrlSetState($button_equal, $GUI_ENABLE)
			Else
				If GUICtrlGetState($button_equal) = 80 Then GUICtrlSetState($button_equal, $GUI_DISABLE)
			EndIf
		EndIf
		Switch $bMsg
			Case $GUI_EVENT_CLOSE
				ExitLoop
			Case $button_cancel
				ExitLoop
			Case $virtuals_combo
				If $button_group_pressed = 1 Then
					MsgBox(16, "ERROR", "Waiting For Action, Input Not Compatible")
				Else
					$expr &= GUICtrlRead($virtuals_combo)
					$work_expr &= GUICtrlRead($virtuals_combo) & "\"
					$button_group_pressed = 1
				EndIf
			Case $button_and
				If $button_group_pressed = 2 Then
					MsgBox(16, "ERROR", "Syntax Error, Waiting For Input")
				Else
					$expr &= " * "
					$work_expr &= " * \"
					$button_group_pressed = 2
				EndIf
			Case $button_or
				If $button_group_pressed = 2 Then
					MsgBox(16, "ERROR", "Syntax Error, Waiting For Input")
				Else
					$expr &= " + "
					$work_expr &= " + \"
					$button_group_pressed = 2
				EndIf
			Case $button_not
				If $button_group_pressed = 2 Then
					MsgBox(16, "ERROR", "Syntax Error, Cannot Invert An Action Only Inputs")
				Else
					$expr &= "'"
					$work_expr &= "'\"
					$button_group_pressed = 1
				EndIf
			Case $button_equal
				If $button_group_pressed = 2 Then
					MsgBox(16, "ERROR", "Syntax Error, Waiting For Input")
				Else
					$expr &= " = "
					$work_expr &= " = \"
					$button_group_pressed = 2
				EndIf
			Case $button_par_open
				If $button_group_pressed = 1 Then
					MsgBox(16, "ERROR", "Syntax Error, Waiting For Action")
				Else
					$expr &= "("
					$work_expr &= "(\"
					$button_group_pressed = 2
				EndIf
			Case $button_par_close
				If $button_group_pressed = 2 Then
					MsgBox(16, "ERROR", "Syntax Error, Waiting For Input")
				Else
					$expr &= ")"
					$work_expr &= ")\"
					$button_group_pressed = 1
				EndIf
			Case $button_bs
				; Delete last entry
				$a=StringSplit($work_expr, "\")
				$b=""
				For $i=1 To $a[0]-2
					$b &= $a[$i] & "\"
				Next
				$work_expr = $b
				$expr = StringReplace($b, "\", "")
				; Manage the group tag
				If $a[$a[0]-1] = " + " Or $a[$a[0]-1] = " * " Or $a[$a[0]-1] = "'" Or $a[$a[0]-1] = ")" Then
					$button_group_pressed = 1
				Else
					$button_group_pressed = 2
				EndIf
				If $a[$a[0]-1] = " = " Then 
					$button_group_pressed = 1
				EndIf
			Case $button_clear
				$expr = ""
				$work_expr = ""
				$button_group_pressed = 2
			Case $button_ok
				$create_rules=0
				If StringInStr($work_expr, "= \") = 0 Then
					MsgBox(16, "ERROR", "No Output Has Been Set.") ; Syntax Check
				Else
					$temp = StringSplit($work_expr, "=", 2)
					$inputs_used = _bool_calc_find_number_of_inputs($work_expr)
					If UBound(StringSplit($work_expr, "(")) - 2 <> UBound(StringSplit($work_expr, ")")) - 2 Then ; Syntax Check
						MsgBox(16, "ERROR", "Missing Parentheses.")
					ElseIf StringInStr($temp[1], "+ \") <> 0 Or StringInStr($temp[1], "* \") <> 0 Then ; Syntax Check
						MsgBox(16, "ERROR", "No Actions Allowed After The Equal (=).")
					ElseIf $inputs_used[0] > 9 Then
						MsgBox(16, "ERROR", "The Amount Of Inputs In The Expression Exceed The " & @LF & _
												"Maximum Allowed. (Max = 9)")
					Else
						If $inputs_used[0] >= 6 Then
							$continue = MsgBox(36, "WARNING", "The Amount Of Inputs In The Expression Is To Great." & @LF & _
																"Creating The Rules Will Use Many Of The System Resources " & @LF & _
																"And May Take Quite Some Time. Are You Sure You Want To Continue ?")
							If $continue = 6 Then $create_rules=1
						Else
							$create_rules=1
						EndIf
						If $create_rules = 1 Then
							$output_used = _bool_calc_find_output($work_expr)
							$possible_inputs = _create_possible_truth_table($inputs_used[0])
							_ArrayDelete($inputs_used, 0)
							Local $inputs_array[UBound($possible_inputs, 2)]
							$preview_choise = MsgBox(36, "Choose", "Do You Want To Preview The Expression's " & @LF & _
																		"Truth Table Before Creating The Rules ?")
							If $preview_choise = 6 Then
								Local $preview_truth_table[UBound($possible_inputs)]
								For $i=0 To UBound($possible_inputs, 1) - 1
									For $j=0 To UBound($possible_inputs, 2) - 1
										$inputs_array[$j] = $possible_inputs[$i][$j]
									Next
									$output_result = _create_output_from_bool_expression($inputs_array, $work_expr, $inputs_used)
									If StringInStr($temp[1], "'\") <> 0 Then $output_result = Not $output_result ; Invert output in case if the output was declared as "Not"
									If $output_result = True Then $output_result = "1"
									If $output_result = False Then $output_result = "0"
									$string_to_write = _ArrayToString($inputs_array, " ") & " => " & $output_result
									$preview_truth_table[$i] = $string_to_write
								Next
								$preview_gui = GUICreate("Truth Table Preview", 201, 449, 192, 124)
								$preview_list = GUICtrlCreateListView("INPUTS|OUTPUT", 8, 8, 184, 390, -1, 0x00000001)
								_GUICtrlListView_SetColumnWidth($preview_list, 0, 100)
								_GUICtrlListView_SetColumnWidth($preview_list, 1, 60)
								$preview_button_cancel = GUICtrlCreateButton("Cancel", 14, 408, 75, 25)
								$preview_button_continue = GUICtrlCreateButton("Continue", 110, 408, 75, 25)
								For $i=0 To UBound($preview_truth_table) - 1
									$a=StringSplit($preview_truth_table[$i], "=>", 3)
									GUICtrlCreateListViewItem($a[0] & "|" & $a[1], $preview_list)
								Next
								GUISetState(@SW_SHOW)
								While 1
									$pMsg = GUIGetMsg()
									Switch $pMsg
										Case $GUI_EVENT_CLOSE
											$create_rules = 0
											ExitLoop
										Case $preview_button_cancel
											$create_rules = 0
											ExitLoop
										Case $preview_button_continue
											$create_rules = 1
											ExitLoop
									EndSwitch	
								WEnd
								GUIDelete($preview_gui)
							EndIf
							If $create_rules=1 Then
								If UBound($possible_inputs, 2) > 2 Then
									Local $output_table[UBound($possible_inputs)]
									For $i=0 To UBound($possible_inputs, 1) - 1
										For $j=0 To UBound($possible_inputs, 2) - 1
											$inputs_array[$j] = $possible_inputs[$i][$j]
										Next
										$output_table[$i] = _create_output_from_bool_expression($inputs_array, $work_expr, $inputs_used)
										If StringInStr($temp[1], "'\") <> 0 Then $output_table[$i] = Not $output_table[$i] ; Invert output in case if the output was declared as "Not"
										If $output_table[$i] = True Then $output_table[$i] = "1"
										If $output_table[$i] = False Then $output_table[$i] = "0"
									Next
									Local $temp_list[UBound($list_items)]
									For $j=0 To UBound($list_items)-1
										$temp_list[$j] = GUICtrlRead($list_items[$j]) ; Global Variable used
									Next	
									$max_virt = _find_max_virt_coil($temp_list)
									; Increase the max Virtual Coil by 1 to prevent duplication when a Virtual Coil is set as output
									If StringInStr($output_used, "Virtual_Coil") <> 0 Then $max_virt += 1	
									$rule_number = _create_rules_from_table($possible_inputs, $output_table, $inputs_used, $output_used, $max_virt, $rule_number)
								Else
									For $i=0 To (UBound($possible_inputs, 1) - 1)
										For $j=0 To UBound($possible_inputs, 2) - 1
											$inputs_array[$j] = $possible_inputs[$i][$j]
										Next
										$output_result = _create_output_from_bool_expression($inputs_array, $work_expr, $inputs_used)
										If StringInStr($temp[1], "'\") <> 0 Then $output_result = Not $output_result ; Invert output in case if the output was declared as "Not"
										If $output_result = True Then $output_result = "1"
										If $output_result = False Then $output_result = "0"
										$string_to_write = _ArrayToString($inputs_array, "") & $output_result
										$output_used = _bool_calc_find_output($work_expr)
										Local $temp_list[UBound($list_items)]
										For $j=0 To UBound($list_items)-1
											$temp_list[$j] = GUICtrlRead($list_items[$j]) ; Global Variable used
										Next
										$max_virt = _find_max_virt_coil($temp_list)
										; Increase the max Virtual Coil by 1 to prevent duplication when a Virtual Coil is set as output
										If StringInStr($output_used, "Virtual_Coil") <> 0 Then $max_virt += 1
										$rule_number = _create_rules_from_string($string_to_write, $inputs_used, $output_used, $max_virt, $rule_number)
									Next
								EndIf
								ExitLoop
							EndIf
						EndIf
					EndIf
				EndIf
		EndSwitch
	WEnd
	GUIDelete($calc_win)
	Return $rule_number
EndFunc

; #FUNCTION# (Internal Use)
; Name...........: 	_create_output_from_bool_expression
; Description ...: 	Calculates the output based on a boolean expression and state of inputs
; Parameters ....: 	$string_array: Array holding the state of inputs
;					$expr_string: The boolean expression
;					$inputs: Array holding the names of inputs
; Return values .:  Returns "1" if the output is True and "0" if the output is False
; ============================================================================================================================================
Func _create_output_from_bool_expression($string_array, $expr_string, $inputs)
	; Create the expression
	$temp = StringSplit($expr_string, "=", 2)
	$expr_inputs = $temp[0]
	$expr_output = $temp[1]
	$array_inputs = StringSplit($expr_inputs, "\")
	For $i=1 To $array_inputs[0]
		If $array_inputs[$i] = " * " Then
			$array_inputs[$i] = "AND"
		ElseIf $array_inputs[$i] = " + " Then
			$array_inputs[$i] = "OR"
		ElseIf $array_inputs[$i] = "'" Then
			$array_inputs[$i] = ""
			If $array_inputs[$i-1] = ")" Then
				$count = 0
				For $j=$i To 0 Step -1
					If $array_inputs[$j] = ")" Then $count += 1
					If $array_inputs[$j] = "(" Then ExitLoop
				Next
				$count_2 = 0
				For $j=$i To 0 Step -1
					If $array_inputs[$j] = "(" Then $count_2 += 1
					If $count_2 > 0 And $array_inputs[$j] = ")" Then $count_2 -= 1 ; When two 1st class parentheses are inside one 2nd class --> ((A+B)*(C+D))'
					If $count_2 = $count Then
						$array_inputs[$j] = "NOT ("
						ExitLoop
					EndIf
				Next
			Else
				$array_inputs[$i-1] = "NOT " & $array_inputs[$i-1]
			EndIf
		EndIf
	Next
	_ArrayDelete($array_inputs, 0)
	$result_expr = _ArrayToString($array_inputs, " ")
	; Calculate the output
	Local $inputs_states[UBound($inputs)][2]
	For $i=0 To UBound($string_array) - 1
		$inputs_states[$i][0] = $inputs[$i]
		If $string_array[$i] = "1" Then $inputs_states[$i][1] = True
		If $string_array[$i] = "0" Then $inputs_states[$i][1] = False
	Next
	For $i=0 To UBound($inputs_states, 1) - 1
		$result_expr = StringReplace($result_expr, $inputs_states[$i][0], $inputs_states[$i][1])
	Next
	$result_output = Execute($result_expr)
	Return $result_output
EndFunc

; #FUNCTION# (Internal Use)
; Name...........: 	_create_possible_truth_table																| 0 0 |
; Description ...: 	Creates all the possible states regarding the number of states								| 0 1 |
; Parameters ....: 	$number_of_inputs: The amount of inputs														| 1 0 |
; Return values .:  A 2D Array holding all the possible states. eq. for 2 inputs the returned array will be => 	| 1 1 |
; ============================================================================================================================================
Func _create_possible_truth_table($number_of_inputs)
	Local $truth_table[2^$number_of_inputs][$number_of_inputs]
	For $i=0 To 2^$number_of_inputs-1
		$z = _number_to_binary($i)
		$x=$z
		For $h=1 To $number_of_inputs - StringLen($z)
			$x = "0" & $x
		Next
		$y = StringSplit($x, "", 2)
		For $j=0 To $number_of_inputs-1
			$truth_table[$i][$j] = $y[$j]
		Next
	Next
	Return $truth_table
EndFunc

; #FUNCTION# (Internal Use)
; Name...........: 	_number_to_binary
; Description ...: 	Converts a decimal number to binary
; Parameters ....: 	$number: The decimal number to convert
; Return values .:  The number in binary form
; ============================================================================================================================================
Func _number_to_binary($number)
	$bin = ""
	While 1
		$int = Floor($number/2)
		$mod = Mod($number,2)
		$bin = $mod & $bin
		$number = $int
		If $number = 0 Then ExitLoop
	WEnd
	Return $bin
EndFunc

; #FUNCTION# (Internal Use)
; Name...........: 	_bool_calc_find_output
; Description ...: 	Extracts the output name used in a boolean expression created by the _boole_calc function
; Parameters ....: 	$expression: The boolean expression to evaluate
; Return values .:  The name of the output
; Remarks........:	The function is for internal use inside the "_boole_calc" function
; ============================================================================================================================================
Func _bool_calc_find_output($expression)
	$temp = StringSplit($expression, "=", 2)
	$out = StringSplit($temp[1], "\")
	Return $out[2]
EndFunc

; #FUNCTION# (Internal Use)
; Name...........: 	_bool_calc_find_number_of_inputs
; Description ...: 	Extracts the number of inputs and the input names used in a boolean expression created by the _boole_calc function
; Parameters ....: 	$expression: The boolean expression to evaluate
; Return values .:  An array where in the first element ($array[0]) contains the number of inputs used and on the remaining elements are the
;						names of the inputs used
; Remarks........:	The function is for internal use inside the "_boole_calc" function
; ============================================================================================================================================
Func _bool_calc_find_number_of_inputs($expression)
	$temp = StringSplit($expression, "=", 2)
	$in_array = StringSplit($temp[0], "\")
	_ArraySort($in_array)
	For $i=0 To UBound($in_array)-1
		If $in_array[$i] = UBound($in_array)-1 Then $mark = $i
	Next
	For $i=0 To $mark
		_ArrayDelete($in_array, 0) ; Delete the 0 element because all the other elements shift up after a delete
	Next
	$in_array = _ArrayUnique($in_array)
	Return $in_array
EndFunc

; #FUNCTION#
; Name...........: 	_comparison_select
; Description ...: 	Create a GUI window which allows the user to compare the selected analog input with another analog pin
; Parameters ....: 	$pin_to_compare: The Analog pin to compare
;					$names_pins: Array holding the names of each declared pin
; Return values .:  The "comparison Rule"
; ============================================================================================================================================
Func _comparison_select($pin_to_compare, $names_pins)
	$comp_check = 0
	$comp_gui = GUICreate("Comparison Select",  674, 176, 192, 124)
	$comp_1 = GUICtrlCreateInput($pin_to_compare, 25, 48, 121, 21, 0x0880) ; 0x0880=0x0080($ES_AUTOHSCROLL) + 0x0800($ES_READONLY)
	$comp_praxi = GUICtrlCreateCombo(" / Divide", 161, 48, 85, 25, 0x0003)
	GUICtrlSetData(-1, " - Remove| + Add| * Multiple")
	$comp_2 = GUICtrlCreateCombo("", 257, 48, 145, 25, 0x0003)
	If $names_pins[0][2] > 0 Or $names_pins[0][3] > 0 Then ; Set the options in the input selection (only analog inputs and outputs can be selected)
		$a=""
		If $names_pins[0][2] > 0 Then
			For $i=1 To $names_pins[0][2]
				If $pin_to_compare <> $names_pins[$i][2] Then $a &= $names_pins[$i][2] & "|"
			Next
		EndIf
		If $names_pins[0][3] > 0 Then
			For $i=1 To $names_pins[0][3]
				$a &= $names_pins[$i][3] & "|"
			Next
		EndIf
		GUICtrlSetData(-1, StringTrimRight($a, 1))
	EndIf
	$comparator = GUICtrlCreateCombo("=  Equal To", 417, 48, 100, 25, 0x0003)
	GUICtrlSetData(-1, ">  Greater Than|<  Less Than|>=  Greater / Equal|<=  Less / Equal|<>  Not Egual")
	$comp_result = GUICtrlCreateInput("", 531, 48, 121, 21, 0x2080) ; 0x0080($ES_AUTOHSCROLL) + 0x2000($ES_NUMBER)
	$button_comp_ok = GUICtrlCreateButton("OK", 243, 112, 75, 25)
	$button_comp_cancel = GUICtrlCreateButton("Cancel", 355, 112, 75, 25)
	GUISetState(@SW_SHOW)
	While 1
		$cMsg = GUIGetMsg()
		Switch $cMsg
			Case $GUI_EVENT_CLOSE
				ExitLoop
			Case $button_comp_cancel
				ExitLoop
			Case $button_comp_ok
				If GUICtrlRead($comp_2) <> "" And GUICtrlRead($comp_result) <> "" Then
					If GUICtrlRead($comparator) = "=  Equal To" Then
						$cmp = "="
					ElseIf GUICtrlRead($comparator) = ">  Greater Than" Then
						$cmp = ">"
					ElseIf GUICtrlRead($comparator) = "<  Less Than" Then
						$cmp = "<"
					ElseIf GUICtrlRead($comparator) = ">=  Greater / Equal" Then
						$cmp = ">="
					ElseIf GUICtrlRead($comparator) = "<=  Less / Equal" Then
						$cmp = "<="
					ElseIf GUICtrlRead($comparator) = "<>  Not Egual" Then
						$cmp = "<>"
					EndIf
					$comparation = "<<>>: \" & GUICtrlRead($comp_1) & "\" & StringLeft(StringTrimLeft(GUICtrlRead($comp_praxi), 1), 1) & _
					"\" & GUICtrlRead($comp_2) & "\" & $cmp & "\" & GUICtrlRead($comp_result)
					$comp_check = 1
					ExitLoop
				Else
					MsgBox (16, "ERROR", "Missing Value In Expression")
				EndIf
		EndSwitch
	WEnd
	GUIDelete($comp_gui)
	If $comp_check = 1 Then
		Return $comparation
	Else
		Return "0"
	EndIf
EndFunc

; #FUNCTION#
; Name...........: 	_create_opposite_rule
; Description ...: 	Automatically create the "opposite" rules of an aplied rule (e.g. Pin_0=High => Pin_1=High  ==Auto=> Pin_1=Low => Pin_1=Low)
; Parameters ....: 	$array: Array containing the rule created by the user
; Return values .: 	Array containing the "opposite" rule
; Remarks .......:  Function doesn't support the case where the output is a Counter
;					and the case that in one of the inputs an analog input or counter is checked with the "= equal" comparator
; <<>>		<<>>: \Pin_14\-\Pin_15\>=\23		==>
; <<>>		<<>>: \Pin_14\-\Pin_15\<\23 
; ============================================================================================================================================
Func _create_opposite_rule($array)
	Local $opposite[13]
	$opposite[0] = $array[0] + 1 ; increase the number of rule
	$opposite[12] = $array[12] ; create the same comment
	For $i = 1 To 10
		$opposite[$i] = $array[$i]
		If $array[$i] = "High" Then
			$opposite[$i] = "Low"
		ElseIf $array[$i] = "Low" Then
			$opposite[$i] = "High"
		EndIf
		If $array[$i] = "AND" Then
			$opposite[$i] = "OR"
		ElseIf $array[$i] = "OR" Then
			$opposite[$i] = "AND"
		EndIf
		If StringIsDigit($array[$i]) = 1 Then
			If $i >= 8 And StringInStr($array[8], "Counter") = 0 Then
				$opposite[$i] = 0
			EndIf
		EndIf
		If $array[$i] = "<" Then
			$opposite[$i] = ">="
		ElseIf $array[$i] = ">" Then
			$opposite[$i] = "<="
		ElseIf $array[$i] = ">=" Then
			$opposite[$i] = "<"
		ElseIf $array[$i] = "<" Then
			$opposite[$i] = ">="
		EndIf
	Next
	If $array[9] = "f(x)" Then ; Manage Expression
		$opposite[9] = "="
		$opposite[10] = 0
	EndIf
	Local $temp[2] = [2, 6]
	For $i In $temp ; Manage Comparison Rules
		$a=""
		If StringInStr($array[$i], "<<>>") <> 0 Then
			$cmp=StringSplit($array[$i+1], "\")
			For $j=1 To $cmp[0]
				If $cmp[$j] = "=" Then
					$cmp[$j] = "<>"
				ElseIf $cmp[$j] = ">" Then
					$cmp[$j] = "<="
				ElseIf $cmp[$j] = "<" Then
					$cmp[$j] = ">="
				ElseIf $cmp[$j] = ">=" Then
					$cmp[$j] = "<"
				ElseIf $cmp[$j] = "<=" Then
					$cmp[$j] = ">"
				ElseIf $cmp[$j] = "<>" Then
					$cmp[$j] = "="
				EndIf
				$a &= $cmp[$j] & "\"
			Next
			$opposite[$i+1] = StringTrimRight($a, 1)
		EndIf
	Next
	Return $opposite
EndFunc

; #FUNCTION#
; Name...........: 	_generate_code
; Description ...: 	Creates the Arduino code
; Parameters ....: 	Array containing the controlID's of the listView items which contain the rules
;					Array containing the controlID's of the Settings combos
;					The file name of the generated file
; Return values .: 	No return just create the file with the arduino code
; ============================================================================================================================================
Func _generate_code($items, $settings, $file_name = $project) ; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
	$names = _read_settings_names($settings)
	$pins = _read_settings_combos($settings)
	If StringRight($file_name, 4) <> ".nag" Then ; Open the file
		$file = FileOpen (@ScriptDir & "/" & $file_name & ".txt", 2)
	Else
		$file = FileOpen (@ScriptDir & "/" & StringTrimRight($file_name, 4) & ".txt", 2)
	EndIf
	
	FileWriteLine ($file, "// Code created by **Arduino Programmer**, a Liapis Nikos Project")
	FileWriteLine ($file, "//===============================================================")
	FileWriteLine ($file, "")
	#region Declare Variables
	; Declare digital inputs
	If $pins[0][0] > 0 Then
		$a=""
		$b=""
		For $i=1 To $pins[0][0]
			$a &= $pins[$i][0]
			$a &= ","
			$b &= "0,"
		Next
		FileWriteLine ($file, "int dig_in[] = {" & StringTrimRight($a, 1) & "};")
		FileWriteLine ($file, "int dig_in_state[] = {" & StringTrimRight($b, 1) & "};")
	EndIf
	; Declare digital outputs
	If $pins[0][1] > 0 Then
		$a=""
		$b=""
		For $i=1 To $pins[0][1]
			$a &= $pins[$i][1]
			$a &= ","
			$b &= "0,"
		Next
		FileWriteLine ($file, "int dig_out[] = {" & StringTrimRight($a, 1) & "};")
		FileWriteLine ($file, "int dig_out_state[] = {" & StringTrimRight($b, 1) & "};")
	EndIf
	; Declare analog inputs
	If $pins[0][2] > 0 Then
		$a=""
		$b=""
		For $i=1 To $pins[0][2]
			$a &= "A"
			$a &= $pins[$i][2]-14
			$a &= ","
			$b &= "0,"
		Next
		FileWriteLine ($file, "int an_in[] = {" & StringTrimRight($a, 1) & "};")
		FileWriteLine ($file, "int an_in_state[] = {" & StringTrimRight($b, 1) & "};")
	EndIf
	; Declare analog outputs
	If $pins[0][3] > 0 Then
		$a=""
		$b=""
		For $i=1 To $pins[0][3]
			$a &= $pins[$i][3]
			$a &= ","
			$b &= "0,"
		Next
		FileWriteLine ($file, "int an_out[] = {" & StringTrimRight($a, 1) & "};")
		FileWriteLine ($file, "int an_out_state[] = {" & StringTrimRight($b, 1) & "};")
	EndIf
	; Declare Virtual Coil Variables
	$virt=0
	For $i=0 To UBound($items)-1
		If StringInStr(GUICtrlRead($items[$i]), "Virtual_Coil") <> 0 Then
			$virt=1
		EndIf
	Next
	If $virt=1 Then ; Check if at least one virtual coil is applied
		Local $temp[UBound ($items)]
		For $i=0 To UBound($items)-2 ; Find the max virtual coil used
			$a=StringSplit(GUICtrlRead($items[$i]), "|", 2)
			If StringInStr($a[8], "Virtual_Coil") <> 0 Then
				$temp[$i] = StringMid($a[8], 14)
			EndIf
		Next
		$a=""
		For $i = 1 To _ArrayMax($temp, 1)
			$a &= "0,"
		Next
		FileWriteLine($file, "int virtual_coil[] = {" & StringTrimRight($a, 1) & "};")
	EndIf
	; Declare Counter Variables
	$count=0
	For $i=0 To UBound($items)-1
		If StringInStr(GUICtrlRead($items[$i]), "Counter") <> 0 Then
			$count=1
		EndIf
	Next
	If $count=1 Then ; Check if at least one Counter is applied
		Local $coun[UBound ($items)]
		For $i=0 To UBound($items)-2 ; Find the max counter used
			$b=StringSplit(GUICtrlRead($items[$i]), "|", 2)
			If StringInStr($b[8], "Counter") <> 0 Then
				$coun[$i] = StringMid($b[8], 9)
			EndIf
		Next
		$a=""
		$ch=""
		For $i = 1 To _ArrayMax($coun, 1)
			$a &= "0,"
			$ch &= Chr(34) & "un_ch" & Chr(34) & ","
		Next
		FileWriteLine($file, "int counter[] = {" & StringTrimRight($a, 1) & "};")
		FileWriteLine($file, "int counter_ch[] = {" & StringTrimRight($ch, 1) & "};")
	EndIf
	; Declare Timers
	$tim=""
	For $i=0 To UBound($items)-2
		$a=StringSplit(GUICtrlRead($items[$i]), "|", 2)
		If $a[11] > 0 Then
			$tim &= $a[11]
			$tim &= ","
		EndIf
	Next
	If $tim <> "" Then
		FileWriteLine($file, "int delay_val[] = {" & StringTrimRight($tim, 1) & "};")
	EndIf
	; Declare the expression Variable
	$exp=0
	For $i=0 To UBound($items)-1
		If StringInStr(GUICtrlRead($items[$i]), "f(x)") <> 0 Then
			$exp=1
		EndIf
	Next
	If $exp = 1 Then ; Check if at least one expression is applied
		FileWriteLine($file, "int exp_val = 0;")
		;FileWriteLine($file, "int temp = 0;")
	EndIf
	; Declare a variable monitoring the rule Number
	FileWriteLine ($file, "int rule = " & Chr(34) & "rl_num" & Chr(34) & ";")
	FileWriteLine($file, "")
	#endregion Declare Variables
	#region void setup()
	FileWriteLine($file, "void setup() {")
	; Declare digital inputs
	If $pins[0][0] > 0 Then
		FileWriteLine ($file, "  for (int i=0; i<" & $pins[0][0] & "; i++) {")
		FileWriteLine ($file, "    pinMode(dig_in[i], INPUT);")
		FileWriteLine ($file, "  }")
	EndIf
	; Declare digital outputs
	If $pins[0][1] > 0 Then
		FileWriteLine ($file, "  for (int i=0; i<" & $pins[0][1] & "; i++) {")
		FileWriteLine ($file, "    pinMode(dig_out[i], OUTPUT);")
		FileWriteLine ($file, "    digitalWrite(dig_out[i], LOW);")
		FileWriteLine ($file, "  }")
	EndIf
	; Declare analog outputs
	If $pins[0][3] > 0 Then
		FileWriteLine ($file, "  for (int i=0; i<" & $pins[0][2] & "; i++) {")
		FileWriteLine ($file, "    pinMode(an_out[i], OUTPUT);")
		FileWriteLine ($file, "    analogWrite(an_out[i], 0);")
		FileWriteLine ($file, "  }")
	EndIf
	; Analog Inputs doesn't need to be declared
	FileWriteLine($file, "}")
	FileWriteLine($file, "")
	#endregion void setup()
	#region void loop()
	FileWriteLine($file, "void loop() {")
	; Read inputs
	If $pins[0][0] > 0 Then
		FileWriteLine($file, "  for (int i=0; i<" & $pins[0][0] & "; i++) {")
		FileWriteLine($file, "    dig_in_state[i] = digitalRead(dig_in[i]);")
		FileWriteLine($file, "  }")
	EndIf
	If $pins[0][2] > 0 Then
		FileWriteLine ($file, "  for (int i=0; i<" & $pins[0][2] & "; i++) {")
		FileWriteLine ($file, "    an_in_state[i] = analogRead(an_in[i]);")
		FileWriteLine ($file, "    an_in_state[i] = map(an_in_state[i], 0, 1024, 0, 255);")
		FileWriteLine ($file, "  }")
	EndIf
	; THIS IS WERE THE MAGIC BEGINS
	For $i=0 To ($rule_count-1)
		$rul=StringSplit(GUICtrlRead($items[$i]), "|", 2)
		;$delay_index = 0
		$counter_changed_check = ""
		#region Create the output of the rule (e.g. " digitalWrite(dig_out[0], HIGH); " )
		Local $output[4] = ["", "", "", ""]
		; Create the value
		If $rul[10] = "High" Then
			$out_val_to_write = "HIGH"
		ElseIf $rul[10] = "Low" Then
			$out_val_to_write = "LOW"
		ElseIf StringIsDigit($rul[10]) = 1 Then
			$out_val_to_write = $rul[10]
		ElseIf StringInStr($rul[10], "f(x)") <> 0 Then
			$out_val_to_write = "exp_val"
		EndIf
		; Create the pin
		If $names[0][1] > 0 Then ; DO
			For $j=1 To $names[0][1] 
				If $rul[8] = $names[$j][1] Then
					$out_pin_to_write = "dig_out[" & $j-1 & "]"
					$out_pin_state_to_write = "dig_out_state[" & $j-1 & "]"  ; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
				EndIf
			Next
		EndIf
		If $names[0][3] > 0 Then ; AO
			For $j=1 To $names[0][3]
				If $rul[8] = $names[$j][3] Then
					$out_pin_to_write = "an_out[" & $j-1 & "]"
					$out_pin_state_to_write = "an_out_state[" & $j-1 & "]" ; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
				EndIf
			Next
		EndIf
		If StringInStr($rul[8], "Virtual_Coil") <> 0 Then ; Virtual Coil
			$out_pin_to_write = "virtual_coil[" & StringMid($rul[8], 14)-1 & "]"
		EndIf
		If StringInStr($rul[8], "Counter") <> 0 Then ; Counter
			$out_pin_to_write = "counter[" & StringMid($rul[8], 9)-1 & "]"
		EndIf
		; Combine the pin and the value. Also insert the delay value
		If $rul[11] > 0 Then
			$output[0] = "delay (" & $rul[11] &  ");"
			;$output[0] = "delay (delay_val[" & $delay_index & "]);"
			;$delay_index += 1
		EndIf
		If StringInStr($out_pin_to_write, "dig_out") <> 0 Then ; DO
			$output[3] = "digitalWrite(" & $out_pin_to_write & ", " & $out_val_to_write & ");"
		ElseIf StringInStr($out_pin_to_write, "an_out") <> 0 Then ; AO
			If StringInStr($rul[9], "f(x)") <> 0 Then ; Expression
				If $names[0][3] > 0 Then ; AO
					$a=StringSplit($rul[10], "\", 2)
					For $x=1 To $names[0][3]
						If $a[1] = $names[$x][3] Then
							$b = "an_out_state[" & $x-1 & "]"
						EndIf
					Next
				EndIf
				If $names[0][2] > 0 Then ; AI
					$a=StringSplit($rul[10], "\", 2)
					For $x=1 To $names[0][2]
						If $a[1] = $names[$x][2] Then
							$b = "an_in_state[" & $x-1 & "]"
						EndIf
					Next
				EndIf
				$output[1] = "exp_val = " & $b & $a[2] & $a[3] & ";"
				;If StringInStr($b, "an_in") <> 0 Then
				;	$output[2] = "exp_val = map(temp, 0, 1024, 0, 255);"
				;Else
				;	$output[2] = "exp_val = temp;"
				;EndIf
			EndIf
			$output[3] = "analogWrite(" & $out_pin_to_write & ", " & $out_val_to_write & ");"
		ElseIf StringInStr($out_pin_to_write, "virtual_coil") <> 0 Then ; Virtual_Coil
			$output[3] = $out_pin_to_write & " = " & $out_val_to_write & ";"
		ElseIf StringInStr($out_pin_to_write, "counter") <> 0 Then ; Counter
			If $rul[9] = "=" Then
				$output[3] = $out_pin_to_write & " " & $rul[9] & " " & $out_val_to_write & ";"
			Else
				$output[3] = $out_pin_to_write & " " & $rul[9] & "= " & $out_val_to_write & ";" 
			EndIf
		EndIf
		#endregion
		#region Create the first input of the rule (e.g. " if (dig_in_state[0] == HIGH) { ")
		; Create the value
		$input_1 = ""
		If $rul[3] = "High" Then ; Digital
			$in_1_val_to_write = "HIGH"
		ElseIf $rul[3] = "Low" Then ; Digital
			$in_1_val_to_write = "LOW"
		ElseIf StringInStr($rul[3], "<<>>") <> 0 Then ; Comparison
			$comp_expr = StringSplit($rul[3], "\", 2)
			$in_1_val_to_write = $comp_expr[5]
		Else ; Analog value
			$in_1_val_to_write = $rul[3]
		EndIf
		; Create the comparator
		If $rul[2] = "=" Then
			$in_1_comp_to_write = "=="
		ElseIf $rul[2] = "<<>>" Then
			If $comp_expr[4] = "=" Then
				$in_1_comp_to_write = "=="
			Else
				$in_1_comp_to_write = $comp_expr[4]
			EndIf
		Else
			$in_1_comp_to_write = $rul[2]
		EndIf
		; Create the Pin
		If $names[0][0] > 0 Then ; DI
			For $j=1 To $names[0][0]
				If $rul[1] = $names[$j][0] Then
					$in_1_pin_to_write = "dig_in_state[" & $j-1 & "]"
				EndIf
			Next
		EndIf
		If $names[0][2] > 0 Then ; AI
			For $j=1 To $names[0][2]
				If $rul[1] = $names[$j][2] Then
					$in_1_pin_to_write = "an_in_state[" & $j-1 & "]"
				EndIf
			Next
		EndIf
		If $names[0][1] > 0 Then ; DO ; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
			For $j=1 To $names[0][1] ; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
				If $rul[1] = $names[$j][1] Then ; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
					$in_1_pin_to_write = "dig_out_state[" & $j-1 & "]" ; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
				EndIf ; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
			Next ; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
		EndIf ; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
		If $names[0][3] > 0 Then ; AO ; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
			For $j=1 To $names[0][3] ; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
				If $rul[1] = $names[$j][3] Then ; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
					$in_1_pin_to_write = "an_out_state[" & $j-1 & "]" ; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
				EndIf ; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
			Next ; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
		EndIf ; ; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
		If StringInStr($rul[3], "<<>>") <> 0 Then
			For $j=1 To $names[0][2] ; 1st AI
				If $comp_expr[1] = $names[$j][2] Then
					$in_1_pin_to_write = "(an_in_state[" & $j-1 & "]"
				EndIf
			Next
			For $j=1 To $names[0][3] ; 1st AO
				If $comp_expr[1] = $names[$j][3] Then
					$in_1_pin_to_write = "(an_out_state[" & $j-1 & "]"
				EndIf
			Next
			$in_1_pin_to_write &= " " & $comp_expr[2] & " "
			For $j=1 To $names[0][2] ; 2nd AI
				If $comp_expr[3] = $names[$j][2] Then
					$in_1_pin_to_write &= "an_in_state[" & $j-1 & "])"
				EndIf
			Next
			For $j=1 To $names[0][3] ; 2nd AO
				If $comp_expr[3] = $names[$j][3] Then
					$in_1_pin_to_write &= "an_out_state[" & $j-1 & "])"
				EndIf
			Next
		EndIf
		If StringInStr($rul[1], "Virtual_Coil") <> 0 Then ; Virtual Coil
			$in_1_pin_to_write = "virtual_coil[" & StringMid($rul[1], 14)-1 & "]"
		EndIf
		If StringInStr($rul[1], "Counter") <> 0 Then ; Counter
			$in_1_pin_to_write = "counter[" & StringMid($rul[1], 9)-1 & "]"
		EndIf
		If StringInStr($rul[8], "Counter") <> 0 Then ; If the output is a Counter then add another check
			$counter_changed_check = "&& counter_ch[" & StringMid($rul[8], 9)-1 & "] != rule"
		EndIf
		; Combine the Pin, the comparator and the value
		If $rul[1] <> "" Then
			$input_1 = $in_1_pin_to_write & " " & $in_1_comp_to_write & " " & $in_1_val_to_write & " " & $counter_changed_check
		EndIf
		#endregion
		; Create the logical
		If $rul[4] = "AND" Then
			$logical_to_write = "&&"
		ElseIf $rul[4] = "OR" Then
			$logical_to_write = "||"
		EndIf
		#region Create the second input of the rule (e.g. " && dig_in_state[1] == HIGH) { ")
		$input_2 = ""
		; Create the value
		If $rul[7] = "High" Then
			$in_2_val_to_write = "HIGH"
		ElseIf $rul[7] = "Low" Then
			$in_2_val_to_write = "LOW"
		ElseIf StringInStr($rul[7], "<<>>") <> 0 Then ; Comparison
			$comp_expr = StringSplit($rul[7], "\", 2)
			$in_2_val_to_write = $comp_expr[5]
		Else ; Analog value
			$in_2_val_to_write = $rul[7]
		EndIf
		; Create the comparator
		If $rul[6] = "=" Then
			$in_2_comp_to_write = "=="
		ElseIf $rul[6] = "<<>>" Then
			If $comp_expr[4] = "=" Then
				$in_2_comp_to_write = "=="
			Else
				$in_2_comp_to_write = $comp_expr[4]
			EndIf
		Else
			$in_2_comp_to_write = $rul[6]
		EndIf
		; Create the Pin
		If $names[0][0] > 0 Then ; DI
			For $j=1 To $names[0][0]
				If $rul[5] = $names[$j][0] Then
					$in_2_pin_to_write = "dig_in_state[" & $j-1 & "]"
				EndIf
			Next
		EndIf
		If $names[0][2] > 0 Then ; AI
			For $j=1 To $names[0][2]
				If $rul[5] = $names[$j][2] Then
					$in_2_pin_to_write = "an_in_state[" & $j-1 & "]"
				EndIf
			Next
		EndIf
		If $names[0][1] > 0 Then ; DO ; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
			For $j=1 To $names[0][1] ; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
				If $rul[5] = $names[$j][1] Then ; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
					$in_2_pin_to_write = "dig_out_state[" & $j-1 & "]" ; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
				EndIf ; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
			Next ; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
		EndIf ; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
		If $names[0][3] > 0 Then ; AO ; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
			For $j=1 To $names[0][3] ; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
				If $rul[5] = $names[$j][3] Then ; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
					$in_2_pin_to_write = "an_out_state[" & $j-1 & "]" ; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
				EndIf ; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
			Next ; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
		EndIf ; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
		If StringInStr($rul[7], "<<>>") <> 0 Then
			For $j=1 To $names[0][2] ; 1st AI
				If $comp_expr[1] = $names[$j][2] Then
					$in_2_pin_to_write = "(an_in_state[" & $j-1 & "]"
				EndIf
			Next
			For $j=1 To $names[0][3] ; 1st AO
				If $comp_expr[1] = $names[$j][3] Then
					$in_2_pin_to_write = "(an_out_state[" & $j-1 & "]"
				EndIf
			Next
			$in_2_pin_to_write &= " " & $comp_expr[2] & " "
			For $j=1 To $names[0][2] ; 2nd AI
				If $comp_expr[3] = $names[$j][2] Then
					$in_2_pin_to_write &= "an_in_state[" & $j-1 & "])"
				EndIf
			Next
			For $j=1 To $names[0][3] ; 2nd AO
				If $comp_expr[3] = $names[$j][3] Then
					$in_2_pin_to_write &= "an_out_state[" & $j-1 & "])"
				EndIf
			Next
		EndIf
		If StringInStr($rul[5], "Virtual_Coil") <> 0 Then ; Virtual Coil
			$in_2_pin_to_write = "virtual_coil[" & StringMid($rul[5], 14)-1 & "]"
		EndIf
		If StringInStr($rul[5], "Counter") <> 0 Then ; Counter
			$in_2_pin_to_write = "counter[" & StringMid($rul[5], 9)-1 & "]"
		EndIf
		If StringInStr($rul[8], "Counter") <> 0 Then ; If the output is a Counter then add another check
			$counter_changed_check = "&& counter_ch[" & StringMid($rul[8], 9)-1 & "] != rule"
		EndIf
		; Combine the Pin, the comparator and the value
		If $rul[5] <> "" Then
			$input_2 = $in_2_pin_to_write & " " & $in_2_comp_to_write & " " & $in_2_val_to_write & " " & $counter_changed_check
		EndIf
		#endregion
		#region Combine The Inputs And The Outputs To Create The Rule
		FileWriteLine($file, "// --------------------------------------------------")
		FileWriteLine($file, "  rule = " & $i & ";" & " //*** Rule_" & $i & " ***") ; update the variable which monitors the rule number
		If $rul[1] = "" And $rul[5] = "" Then ; Case inputs are empty
			$out = ""
			If $output[0] <> "" Then ; Delay
				$out &= "  " & $output[0] & " //*** Rule_" & $i & " ***" & @LF
			EndIf
			If $output[1] <> "" Then ; temp variable
				$out &= "  " & $output[1] & "  //*** Rule_" & $i & " ***" & @LF
			;EndIf
			;If $output[2] <> "" Then ; exp_val variable
				;$out &= "  " & $output[2] & "  //*** Rule_" & $i & " ***" & @LF
				$out &= "  exp_val = constrain(exp_val, 0, 255);" & "  //*** Rule_" & $i & " ***" & @LF
				;$out &= "  " & "if (exp_val >= 255) {" & "  //*** Rule_" & $i & " ***" & @LF
				;$out &= "    " & "exp_val = 255" & "  //*** Rule_" & $i & " ***" & @LF
				;$out &= "  }" & "  //*** Rule_" & $i & " ***" & @LF
				;$out &= "  " & "if (exp_val < 0) {" & "  //*** Rule_" & $i & " ***" & @LF
				;$out &= "    " & "exp_val = 0" & "  //*** Rule_" & $i & " ***" & @LF
				;$out &= "  }" & "  //*** Rule_" & $i & " ***" & @LF
			EndIf
			If $output[3] <> "" Then ; pin
				$out &= "  " & $output[3] & "  //*** Rule_" & $i & " ***" & @LF
				If StringInStr($output[3], "Counter") = 0 And StringInStr($output[3], "Virtual_Coil") = 0 Then; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
					$out &= "  " & $out_pin_state_to_write & " = " & $out_val_to_write & ";" & "  //*** Rule_" & $i & " ***"; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
				EndIf; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
			EndIf
			FileWriteLine($file, $out)
			If StringInStr($output[3], "Counter") <> 0 Then
				FileWriteLine($file, "  counter_ch[" & StringMid($rul[8], 9)-1 & "] = rule;  //*** Rule " & $i & " ***" & @LF)
			EndIf
		ElseIf $rul[1] <> "" And $rul[5] = "" Then ; Case input 1
			$out = ""
			If $output[0] <> "" Then
				$out &= "    " & $output[0] & " //*** Rule_" & $i & " ***" & @LF
			EndIf
			If $output[1] <> "" Then
				$out &= "    " & $output[1] & "  //*** Rule_" & $i & " ***" & @LF
			;EndIf
			;If $output[2] <> "" Then
			;	$out &= "    " & $output[2] & "  //*** Rule_" & $i & " ***" & @LF
				$out &= "    exp_val = constrain(exp_val, 0, 255);" & "  //*** Rule_" & $i & " ***" & @LF
				;$out &= "    " & "if (exp_val >= 255) {" & "  //*** Rule_" & $i & " ***" & @LF
				;$out &= "      " & "exp_val = 255" & "  //*** Rule_" & $i & " ***" & @LF
				;$out &= "    }" & "  //*** Rule_" & $i & " ***" & @LF
				;$out &= "    " & "if (exp_val < 0) {" & "  //*** Rule_" & $i & " ***" & @LF
				;$out &= "      " & "exp_val = 0" & "  //*** Rule_" & $i & " ***" & @LF
				;$out &= "    }" & "  //*** Rule_" & $i & " ***" & @LF
			EndIf
			If $output[3] <> "" Then
				$out &= "    " & $output[3] & "  //*** Rule_" & $i & " ***" & @LF
				If StringInStr($output[3], "Counter") = 0 And StringInStr($output[3], "Virtual_Coil") = 0 Then; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
					$out &= "    " & $out_pin_state_to_write & " = " & $out_val_to_write & ";" & "  //*** Rule_" & $i & " ***"; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
				EndIf; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
			EndIf
			FileWriteLine($file, "  if (" & $input_1 & ") {" & " //*** Rule_" & $i & " ***")
			FileWriteLine($file, $out)
			If StringInStr($output[3], "Counter") <> 0 Then
				FileWriteLine($file, "    counter_ch[" & StringMid($rul[8], 9)-1 & "] = rule;  //*** Rule " & $i & " ***" & @LF)
				#region Create an opposite input 
				; Create the value
				$input_1_opposite = ""
				If $rul[3] = "High" Then
					$in_1_val_to_write_opposite = "HIGH"
				ElseIf $rul[3] = "Low" Then
					$in_1_val_to_write_opposite = "LOW"
				Else
					$in_1_val_to_write_opposite = $rul[3]
				EndIf
				; Create the comparator
				If $rul[2] = "=" Then
					$in_1_comp_to_write_opposite = "!="
				ElseIf $rul[2] = ">" Then
					$in_1_comp_to_write_opposite = "<="
				ElseIf $rul[2] = "<" Then
					$in_1_comp_to_write_opposite = ">="
				ElseIf $rul[2] = ">=" Then
					$in_1_comp_to_write_opposite = "<"
				ElseIf $rul[2] = "<=" Then
					$in_1_comp_to_write_opposite = ">"
				EndIf
				; Create the Pin
				If $names[0][0] > 0 Then ; DI
					For $j=1 To $names[0][0]
						If $rul[1] = $names[$j][0] Then
							$in_1_pin_to_write_opposite = "dig_in_state[" & $j-1 & "]"
						EndIf
					Next
				EndIf
				If $names[0][2] > 0 Then ; AI
					For $j=1 To $names[0][2]
						If $rul[1] = $names[$j][2] Then
							$in_1_pin_to_write_opposite = "an_in_state[" & $j-1 & "]"
						EndIf
					Next
				EndIf
				If StringInStr($rul[1], "Virtual_Coil") <> 0 Then ; Virtual Coil
					$in_1_pin_to_write_opposite = "virtual_coil[" & StringMid($rul[1], 14)-1 & "]"
				EndIf
				If StringInStr($rul[1], "Counter") <> 0 Then ; Counter
					$in_1_pin_to_write_opposite = "counter[" & StringMid($rul[1], 9)-1 & "]"
				EndIf
				; Combine the Pin, the comparator and the value
				If $rul[1] <> "" Then
					$input_1_opposite = $in_1_pin_to_write_opposite & " " & $in_1_comp_to_write_opposite & " " & $in_1_val_to_write_opposite
				EndIf
				#endregion
			EndIf
			FileWriteLine($file, "  } //*** Rule_" & $i & " ***")
			; Write the opposite input
			If StringInStr($output[3], "Counter") <> 0 Then
				FileWriteLine($file, "  if (" & $input_1_opposite & ") {" & " //*** Rule_" & $i & " ***")
				FileWriteLine($file, "    counter_ch[" & StringMid($rul[8], 9)-1 & "] = " & Chr(34) & "un_ch" & Chr(34) & ";  //*** Rule " & $i & " ***" & @LF)
				FileWriteLine($file, "  }  //*** Rule " & $i & " ***" & @LF)
			EndIf
		ElseIf $rul[1] = "" And $rul[5] <> "" Then ; Case input 2
			$out = ""
			If $output[0] <> "" Then
				$out &= "    " & $output[0] & " //*** Rule_" & $i & " ***" & @LF
			EndIf
			If $output[1] <> "" Then
				$out &= "    " & $output[1] & "  //*** Rule_" & $i & " ***" & @LF
			;EndIf
			;If $output[2] <> "" Then
			;	$out &= "    " & $output[2] & "  //*** Rule_" & $i & " ***" & @LF
				$out &= "    exp_val = constrain(exp_val, 0, 255);" & "  //*** Rule_" & $i & " ***" & @LF
				;$out &= "    " & "if (exp_val >= 255) {" & "  //*** Rule_" & $i & " ***" & @LF
				;$out &= "      " & "exp_val = 255" & "  //*** Rule_" & $i & " ***" & @LF
				;$out &= "    }" & "  //*** Rule_" & $i & " ***" & @LF
				;$out &= "    " & "if (exp_val < 0) {" & "  //*** Rule_" & $i & " ***" & @LF
				;$out &= "      " & "exp_val = 0" & "  //*** Rule_" & $i & " ***" & @LF
				;$out &= "    }" & "  //*** Rule_" & $i & " ***" & @LF
			EndIf
			If $output[3] <> "" Then
				$out &= "    " & $output[3] & "  //*** Rule_" & $i & " ***" & @LF
				If StringInStr($output[3], "Counter") = 0 And StringInStr($output[3], "Virtual_Coil") = 0 Then; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
					$out &= "    " & $out_pin_state_to_write & " = " & $out_val_to_write & ";" & "  //*** Rule_" & $i & " ***"; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
				EndIf; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
			EndIf
			FileWriteLine($file, "  if (" & $input_2 & ") {" & " //*** Rule_" & $i & " ***")
			FileWriteLine($file, $out)
			If StringInStr($output[3], "Counter") <> 0 Then
				FileWriteLine($file, "    counter_ch[" & StringMid($rul[8], 9)-1 & "] = rule;  //*** Rule " & $i & " ***" & @LF)
				#region Create an opposite input
				; Create the value
				$input_2_opposite = ""
				If $rul[7] = "High" Then
					$in_2_val_to_write_opposite = "HIGH"
				ElseIf $rul[7] = "Low" Then
					$in_2_val_to_write_opposite = "LOW"
				Else
					$in_2_val_to_write_opposite = $rul[3]
				EndIf
				; Create the comparator
				If $rul[6] = "=" Then
					$in_2_comp_to_write_opposite = "!="
				ElseIf $rul[6] = ">" Then
					$in_2_comp_to_write_opposite = "<="
				ElseIf $rul[6] = "<" Then
					$in_2_comp_to_write_opposite = ">="
				ElseIf $rul[6] = ">=" Then
					$in_2_comp_to_write_opposite = "<"
				ElseIf $rul[6] = "<=" Then
					$in_2_comp_to_write_opposite = ">"
				EndIf
				; Create the Pin
				If $names[0][0] > 0 Then ; DI
					For $j=1 To $names[0][0]
						If $rul[5] = $names[$j][0] Then
							$in_2_pin_to_write_opposite = "dig_in_state[" & $j-1 & "]"
						EndIf
					Next
				EndIf
				If $names[0][2] > 0 Then ; AI
					For $j=1 To $names[0][2]
						If $rul[5] = $names[$j][2] Then
							$in_2_pin_to_write_opposite = "an_in_state[" & $j-1 & "]"
						EndIf
					Next
				EndIf
				If StringInStr($rul[5], "Virtual_Coil") <> 0 Then ; Virtual Coil
					$in_2_pin_to_write_opposite = "virtual_coil[" & StringMid($rul[1], 14)-1 & "]"
				EndIf
				If StringInStr($rul[5], "Counter") <> 0 Then ; Counter
					$in_2_pin_to_write_opposite = "counter[" & StringMid($rul[1], 9)-1 & "]"
				EndIf
				If $rul[5] <> "" Then
					$input_2_opposite = $in_2_pin_to_write_opposite & " " & $in_2_comp_to_write_opposite & " " & $in_2_val_to_write_opposite
				EndIf
				#endregion
			EndIf
			FileWriteLine($file, "  } //*** Rule_" & $i & " ***")
			; Write the opposite input
			If StringInStr($output[3], "Counter") <> 0 Then
				FileWriteLine($file, "  if (" & $input_2_opposite & ") {" & " //*** Rule_" & $i & " ***")
				FileWriteLine($file, "    counter_ch[" & StringMid($rul[8], 9)-1 & "] = " & Chr(34) & "un_ch" & Chr(34) & ";  //*** Rule " & $i & " ***" & @LF)
				FileWriteLine($file, "  }  //*** Rule " & $i & " ***" & @LF)
			EndIf
		ElseIf $rul[1] <> "" And $rul[5] <> "" Then ; Case Both Inputs
			$out = ""
			If $output[0] <> "" Then
				$out &= "    " & $output[0] & " //*** Rule_" & $i & " ***" & @LF
			EndIf
			If $output[1] <> "" Then
				$out &= "    " & $output[1] & "  //*** Rule_" & $i & " ***" & @LF
			;EndIf
			;If $output[2] <> "" Then
			;	$out &= "    " & $output[2] & "  //*** Rule_" & $i & " ***" & @LF
				$out &= "    exp_val = constrain(exp_val, 0, 255);" & "  //*** Rule_" & $i & " ***" & @LF
				;$out &= "    " & "if (exp_val >= 255) {" & "  //*** Rule_" & $i & " ***" & @LF
				;$out &= "      " & "exp_val = 255" & "  //*** Rule_" & $i & " ***" & @LF
				;$out &= "    }" & "  //*** Rule_" & $i & " ***" & @LF
				;$out &= "    " & "if (exp_val < 0) {" & "  //*** Rule_" & $i & " ***" & @LF
				;$out &= "      " & "exp_val = 0" & "  //*** Rule_" & $i & " ***" & @LF
				;$out &= "    }" & "  //*** Rule_" & $i & " ***" & @LF
			EndIf
			If $output[3] <> "" Then
				$out &= "    " & $output[3] & "  //*** Rule_" & $i & " ***" & @LF
				If StringInStr($output[3], "Counter") = 0 And StringInStr($output[3], "Virtual_Coil") = 0 Then; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
					$out &= "    " & $out_pin_state_to_write & " = " & $out_val_to_write & ";" & "  //*** Rule_" & $i & " ***"; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
				EndIf; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
			EndIf
			FileWriteLine($file, "  if (" & $input_1 & " " & $logical_to_write & " " & $input_2 & ") {" & " //*** Rule_" & $i & " ***")
			FileWriteLine($file, $out)
			If StringInStr($output[3], "Counter") <> 0 Then
				FileWriteLine($file, "    counter_ch[" & StringMid($rul[8], 9)-1 & "] = rule;  //*** Rule " & $i & " ***" & @LF)
				#region Create an opposite input_1 
				; Create the value
				$input_1_opposite = ""
				If $rul[3] = "High" Then
					$in_1_val_to_write_opposite = "HIGH"
				ElseIf $rul[3] = "Low" Then
					$in_1_val_to_write_opposite = "LOW"
				Else
					$in_1_val_to_write_opposite = $rul[3]
				EndIf
				; Create the comparator
				If $rul[2] = "=" Then
					$in_1_comp_to_write_opposite = "!="
				ElseIf $rul[2] = ">" Then
					$in_1_comp_to_write_opposite = "<="
				ElseIf $rul[2] = "<" Then
					$in_1_comp_to_write_opposite = ">="
				ElseIf $rul[2] = ">=" Then
					$in_1_comp_to_write_opposite = "<"
				ElseIf $rul[2] = "<=" Then
					$in_1_comp_to_write_opposite = ">"
				EndIf
				; Create the Pin
				If $names[0][0] > 0 Then ; DI
					For $j=1 To $names[0][0]
						If $rul[1] = $names[$j][0] Then
							$in_1_pin_to_write_opposite = "dig_in_state[" & $j-1 & "]"
						EndIf
					Next
				EndIf
				If $names[0][2] > 0 Then ; AI
					For $j=1 To $names[0][2]
						If $rul[1] = $names[$j][2] Then
							$in_1_pin_to_write_opposite = "an_in_state[" & $j-1 & "]"
						EndIf
					Next
				EndIf
				If StringInStr($rul[1], "Virtual_Coil") <> 0 Then ; Virtual Coil
					$in_1_pin_to_write_opposite = "virtual_coil[" & StringMid($rul[1], 14)-1 & "]"
				EndIf
				If StringInStr($rul[1], "Counter") <> 0 Then ; Counter
					$in_1_pin_to_write_opposite = "counter[" & StringMid($rul[1], 9)-1 & "]"
				EndIf
				; Combine the Pin, the comparator and the value
				If $rul[1] <> "" Then
					$input_1_opposite = $in_1_pin_to_write_opposite & " " & $in_1_comp_to_write_opposite & " " & $in_1_val_to_write_opposite
				EndIf
				#endregion
				#region Create an opposite input_2
				; Create the value
				$input_2_opposite = ""
				If $rul[7] = "High" Then
					$in_2_val_to_write_opposite = "HIGH"
				ElseIf $rul[7] = "Low" Then
					$in_2_val_to_write_opposite = "LOW"
				Else
					$in_2_val_to_write_opposite = $rul[3]
				EndIf
				; Create the comparator
				If $rul[6] = "=" Then
					$in_2_comp_to_write_opposite = "!="
				ElseIf $rul[6] = ">" Then
					$in_2_comp_to_write_opposite = "<="
				ElseIf $rul[6] = "<" Then
					$in_2_comp_to_write_opposite = ">="
				ElseIf $rul[6] = ">=" Then
					$in_2_comp_to_write_opposite = "<"
				ElseIf $rul[6] = "<=" Then
					$in_2_comp_to_write_opposite = ">"
				EndIf
				; Create the Pin
				If $names[0][0] > 0 Then ; DI
					For $j=1 To $names[0][0]
						If $rul[5] = $names[$j][0] Then
							$in_2_pin_to_write_opposite = "dig_in_state[" & $j-1 & "]"
						EndIf
					Next
				EndIf
				If $names[0][2] > 0 Then ; AI
					For $j=1 To $names[0][2]
						If $rul[5] = $names[$j][2] Then
							$in_2_pin_to_write_opposite = "an_in_state[" & $j-1 & "]"
						EndIf
					Next
				EndIf
				If StringInStr($rul[5], "Virtual_Coil") <> 0 Then ; Virtual Coil
					$in_2_pin_to_write_opposite = "virtual_coil[" & StringMid($rul[1], 14)-1 & "]"
				EndIf
				If StringInStr($rul[5], "Counter") <> 0 Then ; Counter
					$in_2_pin_to_write_opposite = "counter[" & StringMid($rul[1], 9)-1 & "]"
				EndIf
				If $rul[5] <> "" Then
					$input_2_opposite = $in_2_pin_to_write_opposite & " " & $in_2_comp_to_write_opposite & " " & $in_2_val_to_write_opposite
				EndIf
				#endregion
			EndIf
			FileWriteLine($file, "  } //*** Rule_" & $i & " ***")
			; Write the opposite inputs
			If StringInStr($output[3], "Counter") <> 0 Then
				If $rul[4] = "AND" Then
					$opposite_comp = "||"
				ElseIf $rul[4] = "OR" Then
					$opposite_comp = "&&"
				EndIf
				FileWriteLine($file, "  if (" & $input_1_opposite & " " & $opposite_comp & " " & $input_2_opposite & ") {" & " //*** Rule_" & $i & " ***")
				FileWriteLine($file, "    counter_ch[" & StringMid($rul[8], 9)-1 & "] = " & Chr(34) & "un_ch" & Chr(34) & ";  //*** Rule " & $i & " ***" & @LF)
				FileWriteLine($file, "  }  //*** Rule " & $i & " ***" & @LF)
			EndIf
		EndIf
		#endregion
	Next
	FileWriteLine($file, "}")
	#endregion void loop()
	FileClose ($file)
	ShellExecute (@ScriptDir & "/" & $file_name & ".txt")
EndFunc

; #FUNCTION#
; Name...........: 	_check_syntax
; Description ...: 	Checks the syntax of the rule about to be applied
; Parameters ....: 	Array containing the controlID's of the Rule combos
;					Array containing the controlID's of the Settings combos
; Return values .: 	Returns "OK" if syntax is correct
;					Returns "ERROR" if syntax is false
; ============================================================================================================================================
Func _check_syntax($combos, $settings)
	$names = _read_settings_names($settings)
	$rule = _read_rule_combos($combos)
	$check_out = 1
	$check_in_1 = 1
	$check_in_2 = 1
	#region Check Output
	If $rule[8] = "" Then
		MsgBox (16, "OUTPUT-ERROR", "Output Has Not Been Set. Fix and Continue")
		$check_out = 0
	Else
		If _ArraySearch($names, $rule[8], 1, $names[0][1], 0, 0, 1, 1) <> -1 Then ; If output is a digital output
			If $rule[9] = "" Then
				MsgBox (16, "OUTPUT-ERROR", "Output Comparator Has Not Been Set. Fix and Continue")
				$check_out = 0
			Else
				If $rule[10] = "" Then
					MsgBox (16, "OUTPUT-ERROR", "Output Value Has Not Been Set. Fix and Continue")
					$check_out = 0
				EndIf
			EndIf
		EndIf
		If _ArraySearch($names, $rule[8], 1, $names[0][3], 0, 0, 1, 3) <> -1 Then ; If output is an analog output
			If $rule[9] = "" Then
				MsgBox (16, "OUTPUT-ERROR", "Output Comparator Has Not Been Set. Fix and Continue")
				$check_out = 0
			Else
				If $rule[10] = "" Then
					MsgBox (16, "OUTPUT-ERROR", "Output Value Has Not Been Set. Fix and Continue")
					$check_out = 0
				Else
					If $rule[10] < 0 Or $rule[10] > 254 Then
						MsgBox (16, "OUTPUT-ERROR", "Output Value Is Not Between 0 and 254. Fix and Continue")
						$check_out = 0
					EndIf
				EndIf
			EndIf
		EndIf
		If StringInStr($rule[8], "Virtual_Coil") <> 0 Then ; If output is a Virtual Coil
			If $rule[9] = "" Then
				MsgBox (16, "OUTPUT-ERROR", "Output Comparator Has Not Been Set. Fix and Continue")
				$check_out = 0
			Else
				If $rule[10] = "" Then
					MsgBox (16, "OUTPUT-ERROR", "Output Value Has Not Been Set. Fix and Continue")
					$check_out = 0
				EndIf
			EndIf
		EndIf
		If StringInStr($rule[8], "Counter") <> 0 Then ; If output is a Counter
			If $rule[9] = "" Then
				MsgBox (16, "OUTPUT-ERROR", "Output Comparator Has Not Been Set. Fix and Continue")
				$check_out = 0
			Else
				If $rule[10] = "" Then
					MsgBox (16, "OUTPUT-ERROR", "Output Value Has Not Been Set. Fix and Continue")
					$check_out = 0
				Else
					If $rule[10] < 0 Then
						MsgBox (16, "OUTPUT-ERROR", "Output Value Must Be Greater Than 0. Fix and Continue")
						$check_out = 0
					EndIf
				EndIf
			EndIf
		EndIf
	EndIf
	#endregion
	#region Check Input 1
	If $rule[1] <> "" Then
		If _ArraySearch($names, $rule[1], 1, $names[0][0], 0, 0, 1, 0) <> -1 Then ; If input is a digital input
			If $rule[2] = "" Then
				MsgBox(16, "INPUT-ERROR", "Input_A Comparator Has Not Been Set. Fix and Continue")
				$check_in_1 = 0
			Else
				If $rule[3] = "" Then
					MsgBox(16, "INPUT-ERROR", "Input_A Value Has Not Been Set. Fix and Continue")
					$check_in_1 = 0
				EndIf
			EndIf
		EndIf
		If _ArraySearch($names, $rule[1], 1, $names[0][2], 0, 0, 1, 2) <> -1 Then ; If input is an analog input
			If $rule[2] = "" Then
				MsgBox(16, "INPUT-ERROR", "Input_A Comparator Has Not Been Set. Fix and Continue")
				$check_in_1 = 0
			Else
				If $rule[3] = "" Then
					MsgBox(16, "INPUT-ERROR", "Input_A Value Has Not Been Set. Fix and Continue")
					$check_in_1 = 0
				Else
					If $rule[3] < 0 Or $rule[3] > 1024 Then
						MsgBox(16, "INPUT-ERROR", "INPUT_A Value Is Not Between 0 and 1024. Fix and Continue")
						$check_in_1 = 0
					EndIf
				EndIf
			EndIf
		EndIf
		If StringInStr($rule[1], "Virtual_Coil") <> 0 Then
			If $rule[2] = "" Then
				MsgBox(16, "INPUT-ERROR", "Input_A Comparator Has Not Been Set. Fix and Continue")
				$check_in_1 = 0
			Else
				If $rule[3] = "" Then
					MsgBox(16, "INPUT-ERROR", "Input_A Value Has Not Been Set. Fix and Continue")
					$check_in_1 = 0
				EndIf
			EndIf
		EndIf
		If StringInStr($rule[1], "Counter") <> 0 Then
			If $rule[2] = "" Then
				MsgBox(16, "INPUT-ERROR", "Input_A Comparator Has Not Been Set. Fix and Continue")
				$check_in_1 = 0
			Else
				If $rule[3] = "" Then
					MsgBox(16, "INPUT-ERROR", "Input_A Value Has Not Been Set. Fix and Continue")
					$check_in_1 = 0
				Else
					If $rule[3] <= 0 Then
						MsgBox(16, "INPUT-ERROR", "INPUT_A Value Must Be Greater Than 0. Fix and Continue")
						$check_in_1 = 0
					EndIf
				EndIf
			EndIf
		EndIf
	EndIf
	#endregion Check Input 1
	#region Check Input 2
	If $rule[5] <> "" Then
		If _ArraySearch($names, $rule[5], 1, $names[0][0], 0, 0, 1, 0) <> -1 Then ; If input is a digital input
			If $rule[6] = "" Then
				MsgBox(16, "INPUT-ERROR", "Input_B Comparator Has Not Been Set. Fix and Continue")
				$check_in_2 = 0
			Else
				If $rule[7] = "" Then
					MsgBox(16, "INPUT-ERROR", "Input_B Value Has Not Been Set. Fix and Continue")
					$check_in_2 = 0
				EndIf
			EndIf
		EndIf
		If _ArraySearch($names, $rule[5], 1, $names[0][2], 0, 0, 1, 2) <> -1 Then ; If input is an analog input
			If $rule[6] = "" Then
				MsgBox(16, "INPUT-ERROR", "Input_B Comparator Has Not Been Set. Fix and Continue")
				$check_in_2 = 0
			Else
				If $rule[7] = "" Then
					MsgBox(16, "INPUT-ERROR", "Input_B Value Has Not Been Set. Fix and Continue")
					$check_in_2 = 0
				Else
					If $rule[7] < 0 Or $rule[7] > 1024 Then
						MsgBox(16, "INPUT-ERROR", "Input_B Value Is Not Between 0 and 1024. Fix and Continue")
						$check_in_2 = 0
					EndIf
				EndIf
			EndIf
		EndIf
		If StringInStr($rule[5], "Virtual_Coil") <> 0 Then
			If $rule[6] = "" Then
				MsgBox(16, "INPUT-ERROR", "Input_B Comparator Has Not Been Set. Fix and Continue")
				$check_in_2 = 0
			Else
				If $rule[7] = "" Then
					MsgBox(16, "INPUT-ERROR", "Input_B Value Has Not Been Set. Fix and Continue")
					$check_in_2 = 0
				EndIf
			EndIf
		EndIf
		If StringInStr($rule[5], "Counter") <> 0 Then
			If $rule[6] = "" Then
				MsgBox(16, "INPUT-ERROR", "Input_B Comparator Has Not Been Set. Fix and Continue")
				$check_in_2 = 0
			Else
				If $rule[7] = "" Then
					MsgBox(16, "INPUT-ERROR", "Input_B Value Has Not Been Set. Fix and Continue")
					$check_in_2 = 0
				Else
					If $rule[7] <= 0 Then
						MsgBox(16, "INPUT-ERROR", "Input_B Value Must Be Greater Than 0. Fix and Continue")
						$check_in_2 = 0
					EndIf
				EndIf
			EndIf
		EndIf
		If $rule[4] <> "AND" And $rule[4] <> "OR" And $rule[1] <> "" Then
			MsgBox(16, "INPUT-ERROR", "Logical Action Must Not Be Empty. Fix and Continue")
			$check_in_2 = 0
		EndIf
	EndIf
	#endregion Check Input 2
	
	If ($check_out + $check_in_1 + $check_in_2) = 3 Then
		Return "OK"
	Else
		Return "ERROR"
	EndIf
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

; #FUNCTION#
; Name...........: 	_write_project_to_file
; Description ...: 	Reads the Settings and Rules and writes them in a file
; Parameters ....: 	Array containing the controlID's of the settings combos
;					Array containing the controlID's of the list items in the list view
;					Default name for the file
;					Variable to set if the function should check for file existance or not (0=don't check   1=check)
; Return values .: 	No value returned just creates the file
; ============================================================================================================================================
Func _write_project_to_file($combos, $list, $name="", $check=0)
	$project_name = $name
	$ok_to_write = 1
	If $check = 1 Then
		While 1
			If FileExists($project_name) = 1 Then ; If file exists ask for overwrite
				$conf=MsgBox (262435, "File Save Error", "The specified file allready exists, Overwrite?")
				If $conf=6 Then ; Yes
					$ok_to_write = 1
					ExitLoop
				ElseIf $conf=7 Then ; No
					$project_name = FileSaveDialog ("Save Project", @ScriptDir, "NAG Project (*.nag)", 2, $name)
					$ok_to_write = 1
				Else ; Cancel
					$ok_to_write = 0
					ExitLoop
				EndIf
			Else
				ExitLoop
			EndIf
		WEnd
	EndIf
	If $ok_to_write = 1 Then
		If StringRight($project_name, 4) <> ".nag" Then ; If the specified name doesn't have the ".nag" extension
			$project_name = $project_name & ".nag"
		EndIf
		$project_file = FileOpen($project_name, 10)
		FileWriteLine ($project_file, "NAG FILE V.030")
		FileWriteLine($project_file, "Settings_START")
		For $i=0 To 19
			FileWriteLine($project_file, $i & ":" & GUICtrlRead($combos[$i][0]) & ":" & GUICtrlRead($combos[$i][1]))
		Next
		FileWriteLine($project_file, "Settings_END")
		FileWriteLine($project_file, "Rules_START")
		$a = _read_rules_from_list($list)
		If StringInStr($a[0], "|") <> 0 Then ;Check if at least one rule has been created
			For $i=0 To UBound($a)-1
				FileWriteLine($project_file, $a[$i])
			Next
		EndIf
		FileWriteLine($project_file, "Rules_END")
		FileClose($project_file)
	EndIf
EndFunc

; #FUNCTION#
; Name...........: 	_update_rule_combos_virtuals
; Description ...: 	Updates the options on the rule combos regarding the virtual coils and the counters
; Parameters ....: 	Array containing the data in the list view previously generated from the _read_rules_from_list() function
;					Array containing the controlID's of the rule combos
; Return values .: 	No value returned just updates the options in the rule combos
; ============================================================================================================================================
Func _update_rule_combos_virtuals($rules, $combos)
	Local $temp[UBound($rules)]
	Local $temp_c[UBound($rules)]
	Local $a[13] = ["", "", "", "", "", "", "", "", "", "", "", "", ""]
	Local $a_c[13] = ["", "", "", "", "", "", "", "", "", "", "", "", ""]
	
	; Update the Virtuals Coils
	For $i=0 To UBound($rules)-1
		If StringInStr($rules[$i], "|") > 0 Then ; If the rule being processed is not empty
			$a=StringSplit($rules[$i], "|", 2)
		EndIf
		If StringInStr($a[8], "Virtual_Coil") > 0 Then
			$temp[$i] = StringMid ($a[8], 14)
		EndIf
	Next
	If _ArrayMax($temp, 1) >= 1 Then
		$b=""
		For $j=1 To _ArrayMax($temp, 1)
			$b=$b & "Virtual_Coil_" & $j & "|"
		Next
		; Update the inputs
		$in_1_coil = $b
		$in_2_coil = $b
		;Update the outputs
		$b=$b & "Virtual_Coil_" & (_ArrayMax($temp, 1) + 1) & "|"
		$out_coil = $b
	Else
		$in_1_coil = ""
		$in_2_coil = ""
		$out_coil = "Virtual_Coil_1|"
	EndIf
	; Update the Counters
	For $i=0 To UBound($rules)-1
		If StringInStr($rules[$i], "|") > 0 Then ; If the rule being processed is not empty
			$a_c=StringSplit($rules[$i], "|", 2)
		EndIf
		If StringInStr($a_c[8], "Counter") > 0 Then
			$temp_c[$i] = StringMid ($a_c[8], 9)
		EndIf
	Next
	If _ArrayMax($temp_c, 1) >= 1 Then
		$c=""
		For $j=1 To _ArrayMax($temp_c, 1)
			$c=$c & "Counter_" & $j & "|"
		Next
		; Update the inputs
		$in_1_count = $c
		$in_2_count = $c
		;Update the outputs
		$c=$c & "Counter_" & (_ArrayMax($temp_c, 1) + 1) & "|"
		$out_count = $c
	Else
		$in_1_count = " "
		$in_2_count = " "
		$out_count = "Counter_1"
	EndIf
	GUICtrlSetData($combos[1], $in_1_coil & $in_1_count)
	GUICtrlSetData($combos[5], $in_2_coil & $in_2_count)
	GUICtrlSetData($combos[8], $out_coil & $out_count)
EndFunc

; #FUNCTION#
; Name...........: 	_read_rules_from_list
; Description ...: 	Reads the data from the list view and stores them in an array
; Parameters ....: 	Array containing the controlID's of the list view items to read, Begining of reading, End of reading
; Return values .: 	Array containing the data from list view
; ============================================================================================================================================
Func _read_rules_from_list($list, $start=0, $end=$rule_count)
	If $end > $start Then
		Local $rules[$end-$start]
		$a=0
		For $i = $start To $end - 1
			$rules[$a] = GUICtrlRead($list[$i])
			$a += 1
		Next
	Else
		Local $rules[1]
		$rules[0] = GUICtrlRead($list[$start])
	EndIf
	Return $rules
EndFunc

; #FUNCTION#
; Name...........: 	_write_rule_to_list
; Description ...: 	Writes data to the list view creating a list view item
; Parameters ....: 	The array containing the data to write in the list view previously generated from the _read_rule_combos() function
; Return values .: 	variable containing the controlID of the item writen in list view
; ============================================================================================================================================
Func _write_rule_to_list ($array)
	$rule_item = ""
	;_ArrayDisplay($array)
	If $array[12] = "Comments" Then
		$array[12] = ""
	EndIf
	For $i=0 To 12
		$rule_item = $rule_item & $array[$i] & "|"
	Next
	$rule_item = GUICtrlCreateListViewItem ($rule_item, $list) ; Global variable used
	Return $rule_item
EndFunc

; #FUNCTION#
; Name...........: 	_read_rule_combos
; Description ...: 	Reads the rule combos and stores the data in an array
; Parameters ....: 	The array containing the ControlID's of the rule combos
; Return values .: 	The array containing the data in the rule combos
; ============================================================================================================================================
Func _read_rule_combos($combos)
	Local $rule[13]
	For $i=0 To 12
		$rule[$i] = GUICtrlRead ($combos[$i])
		If $rule[$i] = "=  Equal To" Then
			$rule[$i] = "="
		ElseIf $rule[$i] = ">  Greater Than" Then
			$rule[$i] = ">"
		ElseIf $rule[$i] = "<  Less Than" Then
			$rule[$i] = "<"
		ElseIf $rule[$i] = ">=  Greater / Equal" Then
			$rule[$i] = ">="
		ElseIf $rule[$i] = "<=  Less / Equal" Then
			$rule[$i] = "<="
		ElseIf $rule[$i] = "f(x)  Expression" Then
			$rule[$i] = "f(x)"
		ElseIf $rule[$i] = "+  Increase By" Then
			$rule[$i] = "+"
		ElseIf $rule[$i] = "-  Decrease By" Then
			$rule[$i] = "-"
		ElseIf $rule[$i] = "=  Set To" Then
			$rule[$i] = "="
		ElseIf $rule[$i] = "<<>>  Compare" Then
			$rule[$i] = "<<>>"
		EndIf
	Next
	Return $rule
EndFunc

; #FUNCTION#
; Name...........: 	_update_rule_combos_others
; Description ...: 	Updates the options logic combos on the rule combos
; Parameters ....: 	The array containing the names of the Inputs and Outputs previously created by the _read_settings_names() function
;					, the array containing the ControlID's of the rule combos and the input/output combo to update: 1 for Input A
;																													2 for Input B
;																													3 for Output
;					Default value for the combarator combo and the default value for the value combo
; Return values .: 	No value returned just updates the data in the combos
; ============================================================================================================================================
Func _update_rule_combos_others($array_names, $combos, $x, $default_1="", $default_2="") ; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
	If $x = 3 Then
		$a=GUICtrlRead($combos[8]) ; Read the output
		If _ArraySearch($array_names, $a, 0, 0, 0, 0, 1, 3) > 0 Then ; If an Analog output pin is selected
			GUICtrlDelete($combos[9]) ; Delete the output comparator combo
			$combos[9] = GUICtrlCreateCombo($default_1, 386, 481, 100, 25, 0x0003) ; Create again the output combarator combo
			GUICtrlSetData(-1, "=  Equal To|f(x)  Expression") ; Set the appropriate options
			GUICtrlDelete ($combos[10]) ; Delete the output value combo
			$combos[10] = GUICtrlCreateInput($default_2, 386, 509, 100, 25, 0x2000) ; Create an input box replacing the combo
		ElseIf StringInStr($a, "Counter") > 0 Then ; If the output is a counter
			GUICtrlDelete($combos[9]) ; Delete the output comparator combo
			$combos[9] = GUICtrlCreateCombo($default_1, 386, 481, 100, 25, 0x0003) ; Create again the output combarator combo
			GUICtrlSetData(-1, "+  Increase By|-  Decrease By|=  Set To") ; Set the appropriate options
			GUICtrlDelete ($combos[10]) ; Delete the output value combo
			$combos[10] = GUICtrlCreateInput($default_2, 386, 509, 100, 25, 0x2000) ; Create an input box replacing the combo
		Else ; If a digital output pin or Virtual Coil is selected
			GUICtrlDelete($combos[9]) ; Delete the output comparator combo
			$combos[9] = GUICtrlCreateCombo($default_1, 386, 481, 100, 25, 0x0003) ; Create again the output combarator combo
			GUICtrlSetData(-1, "=  Equal To") ; Set the appropriate options
			GUICtrlDelete ($combos[10]) ; Delete the output value combo
			$combos[10] = GUICtrlCreateCombo($default_2, 386, 509, 100, 25, 0x0003) ; Create again the value combo
			GUICtrlSetData (-1, "High|Low") ; Set the appropriate options
		EndIf
	Elseif $x = 1 Then
		$a=GUICtrlRead($combos[1]) ; Read the input A
		;_ArrayDisplay($array_names)
		If _ArraySearch($array_names, $a, 0, 0, 0, 0, 1, 2) > 0 Or _ArraySearch($array_names, $a, 0, 0, 0, 0, 1, 3) > 0 Then ; If an Analog input pin or an analog output pin is selected
			GUICtrlDelete($combos[2])
			$combos[2] = GUICtrlCreateCombo($default_1, 66, 481, 100, 25, 0x0003)
			GUICtrlSetData(-1, "=  Equal To|>  Greater Than|<  Less Than|>=  Greater / Equal|<=  Less / Equal|<<>>  Compare")
			GUICtrlDelete ($combos[3])
			$combos[3] = GUICtrlCreateInput($default_2, 66, 509, 100, 25, 0x2000)
		ElseIf StringInStr($a, "Counter") > 0 Then ; If the input is a counter
			GUICtrlDelete($combos[2]) ; Delete the output comparator combo
			$combos[2] = GUICtrlCreateCombo($default_1, 66, 481, 100, 25, 0x0003)
			GUICtrlSetData(-1, "=  Equal To|>  Greater Than|<  Less Than|>=  Greater / Equal|<=  Less / Equal")
			GUICtrlDelete ($combos[3]) ; Delete the output value combo
			$combos[3] = GUICtrlCreateInput($default_2, 66, 509, 100, 25, 0x2000)
		Else ; If a Digital input pin or Virtual Coil is selected
			GUICtrlDelete($combos[2])
			$combos[2] = GUICtrlCreateCombo($default_1, 66, 481, 100, 25, 0x0003)
			GUICtrlSetData(-1, "=  Equal To")
			GUICtrlDelete ($combos[3])
			$combos[3] = GUICtrlCreateCombo($default_2, 66, 509, 100, 25, 0x0003)
			GUICtrlSetData (-1, "High|Low")
		EndIf
	ElseIf $x = 2 Then
		$a=GUICtrlRead($combos[5]) ; Read the input A
		If _ArraySearch($array_names, $a, 0, 0, 0, 0, 1, 2) > 0 Or _ArraySearch($array_names, $a, 0, 0, 0, 0, 1, 3) > 0 Then ; If an Analog input pin or an analog output pin is selected
			GUICtrlDelete($combos[6])
			$combos[6] = GUICtrlCreateCombo($default_1, 240, 481, 100, 25, 0x0003)
			GUICtrlSetData(-1, "=  Equal To|>  Greater Than|<  Less Than|>=  Greater / Equal|<=  Less / Equal|<<>>  Compare")
			GUICtrlDelete ($combos[7])
			$combos[7] = GUICtrlCreateInput($default_2, 240, 509, 100, 25, 0x2000)
		ElseIf StringInStr($a, "Counter") > 0 Then ; If the input is a counter
			GUICtrlDelete($combos[6]) ; Delete the output comparator combo
			$combos[6] = GUICtrlCreateCombo($default_1, 240, 481, 100, 25, 0x0003)
			GUICtrlSetData(-1, "=  Equal To|>  Greater Than|<  Less Than|>=  Greater / Equal|<=  Less / Equal")
			GUICtrlDelete ($combos[7]) ; Delete the output value combo
			$combos[7] = GUICtrlCreateInput($default_2, 240, 509, 100, 25, 0x2000)
		Else ; If a Digital input pin or Virtual Coil is selected
			GUICtrlDelete($combos[6])
			$combos[6] = GUICtrlCreateCombo($default_1, 240, 481, 100, 25, 0x0003)
			GUICtrlSetData(-1, "=  Equal To")
			GUICtrlDelete ($combos[7])
			$combos[7] = GUICtrlCreateCombo($default_2, 240, 509, 100, 25, 0x0003)
			GUICtrlSetData (-1, "High|Low")
		EndIf
	EndIf
EndFunc

; #FUNCTION#
; Name...........: 	_update_rule_combos_inputs
; Description ...: 	Updates the options at the pin selection combos on the rule combos
; Parameters ....: 	The array containing the names of the Inputs and Outputs previously created by the _read_settings_names() function
;					and the array containing the ControlID's of the rule combos 
; Return values .: 	No value returned just updates the data in the combos
; ============================================================================================================================================
Func _update_rule_combos_inputs($array_names, $combos) ; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
	; Update the inputs
	$a=""
	For $i = 1 To $array_names[0][0] ; Loop over the DI pins
		$a = $a & $array_names[$i][0] & "|"
	Next
	For $i = 1 To $array_names[0][2] ; Loop over the AI pins
		$a = $a & $array_names[$i][2] & "|"
	Next
	For $i = 1 To $array_names[0][1] ; Loop over the DO pins ; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
		$a = $a & $array_names[$i][1] & "|" ; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
	Next ; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
	For $i = 1 To $array_names[0][3] ; Loop over the AO pins ; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
		$a = $a & $array_names[$i][3] & "|" ; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
	Next ; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
	If $a <> "" Then
		GUICtrlSetData($combos[1], $a)
		GUICtrlSetData($combos[5], $a)
	EndIf
	; Update the outputs
	$a=""
	For $i = 1 To $array_names[0][1] ; Loop over the DO pins
		$a = $a & $array_names[$i][1] & "|"
	Next
	For $i = 1 To $array_names[0][3] ; Loop over the AO pins
		$a = $a & $array_names[$i][3] & "|"
	Next
	If $a <> "" Then
		GUICtrlSetData($combos[8], $a)
	EndIf
EndFunc

; #FUNCTION#
; Name...........: 	_create_rule_combos
; Description ...: 	Create the combo boxes for the user to create the rule
; Parameters ....: 	Only optional parameters to display as default selections in the combos
; Return values .: 	An array containing the controlID's of the rule combos
; ============================================================================================================================================
Func _create_rule_combos($p_0=$rule_count, $p_1="", $p_2="", $p_3="", $p_4="", $p_5="", $p_6="", $p_7="", $p_8="", $p_9="", $p_10="", $p_11="", $p_12="Comments")
	Local $p[20] = [$p_0, $p_1, $p_2, $p_3, $p_4, $p_5, $p_6, $p_7, $p_8, $p_9, $p_10, $p_11, $p_12]
	Local $rule_combos[13]
	$a=""
	If $p[0] = 0 Then
		$a="0|"
	Else	
		For $i=0 To $p[0] - 1
			$a=$a & $i & "|"
		Next
	EndIf
	$rule_combos[0] = GUICtrlCreateCombo($p[0], 8, 481, 50, 25, BitOr($CBS_DROPDOWNLIST, $WS_VSCROLL)) ; Rule count
	GUICtrlSetData (-1, $a)
	GUICtrlSetTip (-1, "Rule Number")
	$rule_combos[1] = GUICtrlCreateCombo($p[1], 66, 454, 100, 25, BitOr($CBS_DROPDOWNLIST, $WS_VSCROLL)) ; Input A
	GUICtrlSetTip (-1, "Select Input_A Pin")
	$rule_combos[2] = GUICtrlCreateCombo($p[2], 66, 481, 100, 25, BitOr($CBS_DROPDOWNLIST, $WS_VSCROLL))
	GUICtrlSetTip (-1, "Select Input_A Comparator")
	$rule_combos[3] = GUICtrlCreateCombo($p[3], 66, 509, 100, 25, BitOr($CBS_DROPDOWNLIST, $WS_VSCROLL))
	GUICtrlSetTip (-1, "Select Input_A Value")
	$rule_combos[4] = GUICtrlCreateCombo($p[4], 178, 481, 50, 25, BitOr($CBS_DROPDOWNLIST, $WS_VSCROLL)) ; AND OR option
	GUICtrlSetTip (-1, "Select Logical Action")
	If $p[4] = "AND" Then
		GUICtrlSetData(-1, "OR| ")
	ElseIf $p[4] = "OR" Then
		GUICtrlSetData(-1, "AND| ")
	Else
		GUICtrlSetData(-1, "AND|OR| ")
	EndIf
	$rule_combos[5] = GUICtrlCreateCombo($p[5], 240, 454, 100, 25, BitOr($CBS_DROPDOWNLIST, $WS_VSCROLL)) ; Input B
	GUICtrlSetTip (-1, "Select Input_B Pin")
	$rule_combos[6] = GUICtrlCreateCombo($p[6], 240, 481, 100, 25, BitOr($CBS_DROPDOWNLIST, $WS_VSCROLL))
	GUICtrlSetTip (-1, "Select Input_B Comparator")
	$rule_combos[7] = GUICtrlCreateCombo($p[7], 240, 509, 100, 25, BitOr($CBS_DROPDOWNLIST, $WS_VSCROLL))
	GUICtrlSetTip (-1, "Select Input_B Value")
	GUICtrlCreateLabel("==>", 353, 483, 20, 25)
	$rule_combos[8] = GUICtrlCreateCombo($p[8], 386, 454, 100, 25, BitOr($CBS_DROPDOWNLIST, $WS_VSCROLL)) ; Output
	GUICtrlSetTip (-1, "Select Output Pin")
	$rule_combos[9] = GUICtrlCreateCombo($p[9], 386, 481, 100, 25, BitOr($CBS_DROPDOWNLIST, $WS_VSCROLL))
	GUICtrlSetTip (-1, "Select Output Comparator")
	$rule_combos[10] = GUICtrlCreateCombo($p[10], 386, 509, 100, 25, BitOr($CBS_DROPDOWNLIST, $WS_VSCROLL))
	GUICtrlSetTip (-1, "Select Output Value")
	GUICtrlCreateLabel("Delay  (ms)",  498,  454)
	$rule_combos[11] = GUICtrlCreateInput($p[11], 498, 475, 100, 25, 0x2000) ; Delay
	GUICtrlSetTip (-1, "Select Time Delay")
	GUICtrlCreateUpdown(-1, BitOR(0x20, 0x80))
	$rule_combos[12] = GUICtrlCreateInput($p[12], 498, 504, 115, 25)
	GUICtrlSetTip (-1, "Enter Rule Comments")
	Return $rule_combos
EndFunc

; #FUNCTION#
; Name...........: 	_disable_declared_pins
; Description ...: 	Disable (grey out) any setting combo and name input that has allready been declared and used for inside a Rule. 
;					In case of an empty name writes the pin number
; Parameters ....: 	$array: The array containing the controlID's of the settings combos
;					$rules_array: Array containing the rules previously created from the _read_rules_from_list() function
; Return values .: 	"ERROR" if pin name contains the words "Counter" or "Virtual_Coil"
;					"OK" if pin name is valid
; ============================================================================================================================================
Func _disable_declared_pins($array, $rules_array)
	For $i=0 To 19
		If StringInStr(GUICtrlRead($array[$i][1]), "Virtual_Coil") <> 0 Or StringInStr(GUICtrlRead($array[$i][1]), "Counter") <> 0 Or StringInStr(GUICtrlRead($array[$i][1]), "\") <> 0 Then
			MsgBox (16, "ERROR", "Pin name must not contain the words " & Chr(34) & "Counter" & Chr(34) & " and " & Chr(34) & "Virtual_Coil" & Chr(34) & " ." & @LF _
								  & "Also Character " & Chr(34) & "\" & Chr(34) & " Is not Allowed." & @LF & "Fix and continue")
			$check = "ERROR"
			ExitLoop
		Else
			If GUICtrlRead($array[$i][0]) <> "" Then
				If GUICtrlRead($array[$i][1]) = "" Then
					GUICtrlSetData($array[$i][1], "Pin_" & $i) ; If the name input box is empty then write the pin number before disabling
				EndIf
				For $j=0 To UBound($rules_array)-1
					If StringInStr($rules_array[$j], GUICtrlRead($array[$i][1])) <> 0 Then
						GUICtrlSetState($array[$i][1], $GUI_DISABLE)
						GUICtrlSetState ($array[$i][0], $GUI_DISABLE)
					EndIf
				Next
			EndIf
			$check = "OK"
		EndIf	
	Next
	Return $check
EndFunc

; #FUNCTION#
; Name...........: 	_read_settings_names															| Row | Col_0 | Col_1 | Col_2 | Col_3 |
; Description ...: 	Read the settings name input boxes previously created by the					|-------------|-----------------------|
;					"_create_settings_combos()" function											| [0] |       |       |       |       |
;					and "separates" the pins by type												| [1] |       |       |       |       |
; Parameters ....: 	The array containing the controlID's of the settings combos						| [2] |       |       |       |       |
; Return values .: 	A 2D Array where in Col_0 is the names of the pins declared as DI				| [3] |       |       |       |       |
;						in Col_1 is the names of the pins declared as DO							| [4] |       |       |       |       |
;						in Col_2 is the names of the pins declared as AI							| [5] |       |       |       |       |
;						in Col_3 is the names of the pins declared as AO							| [6] |       |       |       |       |
;																									|-------------------------------------|
; ============================================================================================================================================
Func _read_settings_names($array)
	Local $set_p[1][4]
	; Read and store the Digital Inputs at the Col_0 of the $set_p array 
	$count=0
	For $i=0 To 19
		If GUICtrlRead($array[$i][0]) = "DI" Then
			$count += 1
			ReDim $set_p[$count+1][4]
			If GUICtrlRead($array[$i][1]) <> "" Then
				$set_p[$count][0]=GUICtrlRead($array[$i][1])
			Else
				$set_p[$count][0]="Pin_" & $i
			EndIf
		EndIf
		$set_p[0][0]=$count
	Next
	; Read and store the Digital Outputs at the Col_1 of the $set_p array 
	$count=0
	For $i=0 To 19
		If GUICtrlRead($array[$i][0]) = "DO" Then
			$count += 1
			If $count >= UBound ($set_p, 1) Then ; Check if the DO's are more of the DI's to increase the $set_p array
				ReDim $set_p[$count+1][4]
			EndIf
			If GUICtrlRead($array[$i][1]) <> "" Then
				$set_p[$count][1]=GUICtrlRead($array[$i][1])
			Else
				$set_p[$count][1]="Pin_" & $i
			EndIf
		EndIf
		$set_p[0][1]=$count
	Next
	; Read and store the Analog Inputs at the Col_2 of the $set_p array 
	$count=0
	For $i=0 To 19
		If GUICtrlRead($array[$i][0]) = "AI" Then
			$count += 1
			If $count >= UBound ($set_p, 1) Then
				ReDim $set_p[$count+1][4]
			EndIf
			If GUICtrlRead($array[$i][1]) <> "" Then
				$set_p[$count][2]=GUICtrlRead($array[$i][1])
			Else
				$set_p[$count][2]="Pin_" & $i
			EndIf
		EndIf
		$set_p[0][2]=$count
	Next
	; Read and store the Analog Outputs at the Col_3 of the $set_p array 
	$count=0
	For $i=0 To 19
		If GUICtrlRead($array[$i][0]) = "AO" Then
			$count += 1
			If $count >= UBound ($set_p, 1) Then
				ReDim $set_p[$count+1][4]
			EndIf
			If GUICtrlRead($array[$i][1]) <> "" Then
				$set_p[$count][3]=GUICtrlRead($array[$i][1])
			Else
				$set_p[$count][3]="Pin_" & $i
			EndIf
		EndIf
		$set_p[0][3]=$count
	Next
	Return $set_p
EndFunc

; #FUNCTION#
; Name...........: 	_read_settings_combos															| Row | Col_0 | Col_1 | Col_2 | Col_3 |
; Description ...: 	Read the settings combo boxes previously created by the							|-------------|-----------------------|
;					"_create_settings_combos()" function											| [0] |   6   |   2   |   1   |   3   |
;					and "separates" the pins by type												| [1] |   3   |   0   |  17   |   9   |
; Parameters ....: 	The array containing the controlID's of the settings combos						| [2] |  11   |   6   |       |  10   |
; Return values .: 	A 2D Array where in Col_0 is the pins declared as DI							| [3] |  13   |       |       |  11   |
;						in Col_1 is the pins declared as DO											| [4] |  15   |       |       |       |
;						in Col_2 is the pins declared as AI											| [5] |  18   |       |       |       |
;						in Col_3 is the pins declared as AO											| [6] |  19   |       |       |       |
;					Also in Row_0 of each column is the amount of pins stored in this column		|-------------------------------------|
; ============================================================================================================================================
Func _read_settings_combos($array)
	Local $set_p[1][4]
	; Read and store the Digital Inputs at the Col_0 of the $set_p array 
	$count=0
	For $i=0 To 19
		If GUICtrlRead($array[$i][0]) = "DI" Then
			$count += 1
			ReDim $set_p[$count+1][4]
			$set_p[$count][0]=$i
		EndIf
		$set_p[0][0] = $count
	Next
	; Read and store the Digital Outputs at the Col_1 of the $set_p array 
	$count=0
	For $i=0 To 19
		If GUICtrlRead($array[$i][0]) = "DO" Then
			$count += 1
			If $count >= UBound ($set_p, 1) Then ; Check if the DO's are more of the DI's to increase the $set_p array
				ReDim $set_p[$count+1][4]
			EndIf
			$set_p[$count][1]=$i
		EndIf
		$set_p[0][1] = $count
	Next
	; Read and store the Analog Inputs at the Col_2 of the $set_p array 
	$count=0
	For $i=0 To 19
		If GUICtrlRead($array[$i][0]) = "AI" Then
			$count += 1
			If $count >= UBound ($set_p, 1) Then
				ReDim $set_p[$count+1][4]
			EndIf
			$set_p[$count][2]=$i
		EndIf
		$set_p[0][2] = $count
	Next
	; Read and store the Analog Outputs at the Col_3 of the $set_p array 
	$count=0
	For $i=0 To 19
		If GUICtrlRead($array[$i][0]) = "AO" Then
			$count += 1
			If $count >= UBound ($set_p, 1) Then
				ReDim $set_p[$count+1][4]
			EndIf
			$set_p[$count][3]=$i
		EndIf
		$set_p[0][3] = $count
	Next
	Return $set_p
EndFunc

; #FUNCTION#
; Name...........: 	_create_settings_combos
; Description ...: 	Create a combo box representing each Arduino Pin, for the user to declare it as input or output
;					Also create an input box next to each combo for the user to name the pin
; Parameters ....: 	The default value of each pin:
;						DI for digital Input
;						DO for digital Output
;						AI for analog Input
;						AO for Analog Output
; Return values .: 	Array with the controlID's of the created combos in Col_0 and names of pins in Col_1
; ===============================================================================================================================
Func _create_settings_combos($p_0="", $p_1="", $p_2="", $p_3="", $p_4="", $p_5="", $p_6="", $p_7="", $p_8="", $p_9="", $p_10="", $p_11="", $p_12="", $p_13="", $p_14="", $p_15="", $p_16="", $p_17="", $p_18="", $p_19="", _
							 $n_0="", $n_1="", $n_2="", $n_3="", $n_4="", $n_5="", $n_6="", $n_7="", $n_8="", $n_9="", $n_10="", $n_11="", $n_12="", $n_13="", $n_14="", $n_15="", $n_16="", $n_17="", $n_18="", $n_19="")
	Local $p[20] = [$p_0, $p_1, $p_2, $p_3, $p_4, $p_5, $p_6, $p_7, $p_8, $p_9, $p_10, $p_11, $p_12, $p_13, $p_14, $p_15, $p_16, $p_17, $p_18, $p_19]
	Local $n[20] = [$n_0, $n_1, $n_2, $n_3, $n_4, $n_5, $n_6, $n_7, $n_8, $n_9, $n_10, $n_11, $n_12, $n_13, $n_14, $n_15, $n_16, $n_17, $n_18, $n_19]
	Local $set_com_p[20][2]
	; Create the combos
	For $i=0 To 13
		$set_com_p[$i][0] = GUICtrlCreateCombo($p[$i], 1011, 358-(23*$i), 41, 21, 0x0003) ; Only select from dropdown 
		If $i=3 Or $i=5 Or $i=6 Or $i=9 Or $i=10 Or $i=11 Then ; PWM pins
			$a="~"
			GUICtrlSetData (-1, "DI|DO|AO||") ; Empty option added in order to clear an accidental selection
		Else
			$a=""
			GUICtrlSetData (-1, "DI|DO||")
		EndIf
		$set_com_p[$i][1] = GUICtrlCreateInput($n[$i], 1056, 358-(23*$i), 90, 21)
		GUICtrlSetState (-1, $GUI_DISABLE)
		GUICtrlCreateLabel ($i & $a, 987, 360-(23*$i), 19, 17)
	Next
	For $i=14 To 19
		$set_com_p[$i][0] = GUICtrlCreateCombo ($p[$i], 818, 243+(23*($i-14)), 41, 21, 0x0003)
		GUICtrlSetData (-1, "AI|DI|DO||")
		$set_com_p[$i][1] = GUICtrlCreateInput($n[$i], 720, 243+(23*($i-14)), 90, 21)
		GUICtrlSetState (-1, $GUI_DISABLE)
		GUICtrlCreateLabel ("A" & ($i-14), 865, 245+(23*($i-14)), 17, 17)
	Next
	
	Return $set_com_p
EndFunc

; #FUNCTION#
; Name...........: 	_delete_rule_combos
; Description ...: 	Delete the rule combos previously created from _create_rule_combos() function
; Parameters ....: 	An array containing the controlID's of the rule combos
; Return values .: 	
; ===============================================================================================================================
Func _delete_rule_combos($array)
	For $i=0 To 12
		GUICtrlDelete($array[$i])
	Next
EndFunc

; #FUNCTION#
; Name...........: 	_delete_settings_combos
; Description ...: 	Delete the settings combos previously created from _create_settings_combos() function
; Parameters ....: 	An array containing the controlID's of the settings combos
; Return values .: 	
; ===============================================================================================================================
Func _delete_settings_combos($array)
	For $i=0 To 19
		GUICtrlDelete($array[$i][0])
		GUICtrlDelete($array[$i][1])
	Next
EndFunc

#region **Functions** Scroll Bars functions (NOT CREATED BY ME) ====================================================================================================================
Func _Scrollbars_WM_VSCROLL($hWnd, $Msg, $wParam, $lParam)

    #forceref $Msg, $wParam, $lParam
    Local $nScrollCode = BitAND($wParam, 0x0000FFFF)
    Local $iIndex = -1, $yChar, $yPos
    Local $Min, $Max, $Page, $Pos, $TrackPos

    For $x = 0 To UBound($aSB_WindowInfo) - 1
        If $aSB_WindowInfo[$x][0] = $hWnd Then
            $iIndex = $x
            $yChar = $aSB_WindowInfo[$iIndex][3]
            ExitLoop
        EndIf
    Next
    If $iIndex = -1 Then Return 0

    Local $tSCROLLINFO = _GUIScrollBars_GetScrollInfoEx($hWnd, $SB_VERT)
    $Min = DllStructGetData($tSCROLLINFO, "nMin")
    $Max = DllStructGetData($tSCROLLINFO, "nMax")
    $Page = DllStructGetData($tSCROLLINFO, "nPage")
    $yPos = DllStructGetData($tSCROLLINFO, "nPos")
    $Pos = $yPos
    $TrackPos = DllStructGetData($tSCROLLINFO, "nTrackPos")

    Switch $nScrollCode
        Case $SB_TOP
            DllStructSetData($tSCROLLINFO, "nPos", $Min)
        Case $SB_BOTTOM
            DllStructSetData($tSCROLLINFO, "nPos", $Max)
        Case $SB_LINEUP
            DllStructSetData($tSCROLLINFO, "nPos", $Pos - 1)
        Case $SB_LINEDOWN
            DllStructSetData($tSCROLLINFO, "nPos", $Pos + 1)
        Case $SB_PAGEUP
            DllStructSetData($tSCROLLINFO, "nPos", $Pos - $Page)
        Case $SB_PAGEDOWN
            DllStructSetData($tSCROLLINFO, "nPos", $Pos + $Page)
        Case $SB_THUMBTRACK
            DllStructSetData($tSCROLLINFO, "nPos", $TrackPos)
    EndSwitch

    DllStructSetData($tSCROLLINFO, "fMask", $SIF_POS)
    _GUIScrollBars_SetScrollInfo($hWnd, $SB_VERT, $tSCROLLINFO)
    _GUIScrollBars_GetScrollInfo($hWnd, $SB_VERT, $tSCROLLINFO)

    $Pos = DllStructGetData($tSCROLLINFO, "nPos")
    If ($Pos <> $yPos) Then
        _GUIScrollBars_ScrollWindow($hWnd, 0, $yChar * ($yPos - $Pos))
        $yPos = $Pos
    EndIf

    Return $GUI_RUNDEFMSG

EndFunc   ;==>_Scrollbars_WM_VSCROLL

; #FUNCTION# =========================================================================================================
; Name...........: _GUIScrollbars_Size
; Description ...: Calculates scrollbar page and max values with proportional thumb sizes
; Syntax.........: _GUIScrollbars_Size ($iH_Scroll, $iV_Scroll, $hAperture, [$iH_Aperture = 0])
; Parameters ....: $iH_Scroll   -> Width in pixels of area to be scrolled, must be >= aperture width
;                  $iV_Scroll   -> Height in pixels of area to be scrolled, must be >= aperture height
;                  $hAperture   -> GUI handle / Width of aperture GUI to contain scrollbars
;                  $iH_Aperture -> Height of aperture GUI to contain scrollbars - only needed if $hAperture is width
; Requirement(s).: v3.3.6.0 or higher
; Return values .: Success - Returns a 6-element array:
;                            [0] = Horizontal page size ; [1] = Horizontal max size
;                            [2] = Vertical page size   ; [3] = Vertical max size
;                            [4] = Horizontal position correction factor ; [5] = Vertical position correction factor
;                  Failure - Returns 0 and sets @error as follows:
;                            1 - Scroll area smaller than aperture GUI
;                            Returns negative integer indicating API error:
;                            -1 - GetDC failure
;                            -2 - GetTextMetricsW failure
;                            -3 - GetClientRect failure
;                            with @error and @extended as set by API return
; Remarks .......; If controls have been created BEFORE the scrollbars are displayed, the correction factors must be
;                  applied to the coordinates of any subsequent controls to get positional alignment.  The factors
;                  need not be applied if the control use the $GUI_DOCKALL resizing parameter.
; Author ........: Melba23 - with some code from WinAPI, GUIScrollBars and StructureConstants includes
; Example........; Yes
;=====================================================================================================================
Func _GUIScrollbars_Size($iH_Scroll = 0, $iV_Scroll = 0, $hAperture = 0, $iV_Aperture = 0)

	; Declare variables
	Local $fH_Scroll = True, $fV_Scroll = True
	Local $iX_Client, $iY_Client, $iX_Client_Bar, $iY_Client_Bar, $iX_Char, $iY_Char
	Local $aRet, $iError, $iExtended
	Local $tRect = DllStructCreate("long Left;long Top;long Right;long Bottom")

	; If passed GUI handle
	If IsHWnd($hAperture) Then
		; Determine GUI client area
		DllCall("user32.dll", "bool", "GetClientRect", "hwnd", $hAperture, "ptr", DllStructGetPtr($tRect))
		If @error Then Return SetError(@error, @extended, -3)
		Local $iX_Client_GUI = DllStructGetData($tRect, "Right") - DllStructGetData($tRect, "Left")
		Local $iY_Client_GUI = DllStructGetData($tRect, "Bottom") - DllStructGetData($tRect, "Top")
		; Check valid scroll size parameters
		If $iH_Scroll < $iX_Client_GUI And $iH_Scroll <> 0 Then Return SetError(1, 0, 0)
		If $iV_Scroll < $iY_Client_GUI And $iV_Scroll <> 0 Then Return SetError(1, 0, 0)

		; Determine horizontal scrollbar state and set GUI sizes
		Local $aH_SB = _GSB_Size_SB($hAperture, 0xFFFFFFFA) ; $OBJID_HSCROLL
		$iError = @error
		$iExtended = @extended
		If Not IsArray($aH_SB) Then
			Return SetError($iError, $iExtended, -4)
		Else
			If Abs($aH_SB[0]) > @DesktopWidth Then
				; No H scrollbar so unset scrollbar flag
				$fH_Scroll = False
				; Set GUI sizes
				$iY_Client = $iY_Client_GUI
				$iY_Client_Bar = $iY_Client_GUI
			Else
				; Set GUI sizes
				$iY_Client = $iY_Client_GUI + ($aH_SB[3] - $aH_SB[1])
				$iY_Client_Bar = $iY_Client_GUI
			EndIf
		EndIf

		; Determine vertical scrollbar state and set GUI sizes
		Local $aV_SB = _GSB_Size_SB($hAperture, 0xFFFFFFFB) ; $OBJID_VSCROLL
		$iError = @error
		$iExtended = @extended
		If Not IsArray($aH_SB) Then
			Return SetError($iError, $iExtended, -4)
		Else
			If Abs($aV_SB[0]) > @DesktopWidth Then
				; No V scrollbar so unset scrollbar flags
				$fV_Scroll = False
				; Set GUI sizes
				$iX_Client = $iX_Client_GUI
				$iX_Client_Bar = $iX_Client_GUI
			Else
				; Set GUI sizes
				$iX_Client = $iX_Client_GUI + ($aV_SB[2] - $aV_SB[0])
				$iX_Client_Bar = $iX_Client_GUI
			EndIf
		EndIf

		; Determine GUI text size
		$aRet = _GSB_Size_Text($hAperture)
		$iError = @error
		$iExtended = @extended
		If Not IsArray($aRet) Then
			Return SetError($iError, $iExtended, $aRet)
		Else
			$iX_Char = $aRet[0]
			$iY_Char = $aRet[1]
		EndIf

	; If passed GUI size
	Else

		; Check valid scroll size parameters
		If $iH_Scroll < $hAperture   And $iH_Scroll <> 0 Then Return SetError(1, 0, 0)
		If $iV_Scroll < $iV_Aperture And $iV_Scroll <> 0 Then Return SetError(1, 0, 0)

		Local $hWnd = GUICreate("", $hAperture, $iV_Aperture, @DesktopWidth + 10, 0)
		GUISetState()

		; Set client size without bars
		$iX_Client = $hAperture
		$iY_Client = $iV_Aperture

		; Ensure both scrollbars hidden
		DllCall("user32.dll", "bool", "ShowScrollBar", "hwnd", $hWnd, "int", 3, "bool", False)
		If @error Then Return SetError(@error, @extended, -4)
		; Show scrollbars if required
		If $iH_Scroll Then DllCall("user32.dll", "bool", "ShowScrollBar", "hwnd", $hWnd, "int", 0, "bool", True)
		If @error Then Return SetError(@error, @extended, -4)
		If $iV_Scroll Then DllCall("user32.dll", "bool", "ShowScrollBar", "hwnd", $hWnd, "int", 1, "bool", True)
		If @error Then Return SetError(@error, @extended, -4)

		; Get client size with scrollbars
		DllCall("user32.dll", "bool", "GetClientRect", "hwnd", $hWnd, "ptr", DllStructGetPtr($tRect))
		If @error Then Return SetError(@error, @extended, -3)
		$iX_Client_Bar = DllStructGetData($tRect, "Right") - DllStructGetData($tRect, "Left")
		$iY_Client_Bar = DllStructGetData($tRect, "Bottom") - DllStructGetData($tRect, "Top")

		; Determine GUI text size
		$aRet = _GSB_Size_Text($hWnd)
		$iError = @error
		$iExtended = @extended
		If Not IsArray($aRet) Then
			Return SetError($iError, $iExtended, $aRet)
		Else
			$iX_Char = $aRet[0]
			$iY_Char = $aRet[1]
		EndIf

		; Delete test GUI
		GUIDelete($hWnd)

		; Increase scroll limit values to match resized client area
		$iH_Scroll /= $iX_Client_Bar / $iX_Client
		$iV_Scroll /= $iY_Client_Bar / $iY_Client

		; Unset scrollbar flags if required
		If Not $iH_Scroll Then $fH_Scroll = False
		If Not $iV_Scroll Then $fV_Scroll = False

	EndIf

	; If horizontal scrollbar is required
	Local $iH_Page, $iH_Max
	If $fH_Scroll Then
		; Use reduced aperture width if other scrollbar exists
		If $fV_Scroll Then
			; Determine page size (aperture width / text width)
			$iH_Page = Floor($iX_Client_Bar / $iX_Char)
			; Determine max size (scroll width / text width * correction factor for vertical scrollbar)
			$iH_Max = Floor($iH_Scroll / $iX_Char * $iX_Client_Bar / $iX_Client)
		Else
			; Determine page size (aperture width / text width)
			$iH_Page = Floor($iX_Client / $iX_Char)
			; Determine max size (scroll width / text width)
			$iH_Max = Floor($iH_Scroll / $iX_Char)
		EndIf
	Else
		$iH_Page = 0
		$iH_Max = 0
	EndIf

	; If vertical scrollbar required
	Local $iV_Page, $iV_Max
	If $fV_Scroll Then
		; Use reduced aperture width if other scrollbar exists
		If $fH_Scroll Then
			; Determine page size (aperture width / text width)
			$iV_Page = Floor($iY_Client_Bar / $iY_Char)
			; Determine max size (scroll width / text width * correction factor for horizontal scrollbar)
			$iV_Max = Floor($iV_Scroll / $iY_Char * $iY_Client_Bar / $iY_Client)
		Else
			; Determine page size (aperture width / text width)
			$iV_Page = Floor($iY_Client / $iY_Char)
			; Determine max size (scroll width / text width)
			$iV_Max = Floor($iV_Scroll / $iY_Char)
		EndIf
	Else
		$iV_Page = 0
		$iV_Max = 0
	EndIf

	; Create return array
	Local $aRet[6] = [$iH_Page, $iH_Max, $iV_Page, $iV_Max, $iX_Client_Bar / $iX_Client, $iY_Client_Bar / $iY_Client]

	Return $aRet

EndFunc   ;==>_GUIScrollbars_Size

; #FUNCTION# =========================================================================================================
; Name...........: _GUIScrollbars_Restore
; Description ...: Resets scrollbar positions after a minimize/restore cycle
; Syntax.........: _GUIScrollbars_Restore($hWnd[, $fVert = True[, $fHorz = True]])
; Parameters ....: $hWnd  -> GUI containing scrollbars
;                  $fVert -> True (default) = vertical scrollbar visible; False = vertical scrollbar not visible
;                  $fHorz -> True (default) = horizontal scrollbar visible; False = horzontal scrollbar not visible
; Requirement(s).: v3.3.6.0 or higher
; Return values .: None
; Remarks .......;
; Author ........: Melba23 - based on code from rover and czardas
; Example........; Yes
;=====================================================================================================================
Func _GUIScrollbars_Restore($hWnd, $fVert = True, $fHorz = True)

	Local $nV_Pos, $nH_Pos

	_GUIScrollBars_ShowScrollBar($hWnd, $SB_BOTH, True)
	$nV_Pos = _GUIScrollBars_GetScrollPos($hWnd, $SB_VERT) ; Get current position
	_GUIScrollBars_SetScrollInfoPos($hWnd, $SB_VERT, 0) ; Set the scroll to zero
	$nH_Pos = _GUIScrollBars_GetScrollPos($hWnd, $SB_HORZ) ; Get current position
	_GUIScrollBars_SetScrollInfoPos($hWnd, $SB_HORZ, 0) ; Set the scroll to zero
	If Not $fVert Then
		_GUIScrollBars_ShowScrollBar($hWnd,  $SB_VERT, False)
	EndIf
	If Not $fHorz Then
		_GUIScrollBars_ShowScrollBar($hWnd,  $SB_HORZ, False)
	EndIf
	If $fVert Then
		_GUIScrollBars_SetScrollInfoPos($hWnd, $SB_VERT, $nV_Pos)
	EndIf
	If $fHorz Then
		_GUIScrollBars_SetScrollInfoPos($hWnd, $SB_HORZ, $nH_Pos)
	EndIf

EndFunc

; #INTERNAL_USE_ONLY#============================================================================================================
; Name...........: _GSB_Size_Text
; Description ...: Sizes GUI text to set scroll units
; Syntax ........: _GSB_Size_Text($hWnd)
; Return values .: Array holding average text width and absolute text height
; Author ........: Melba23
; Remarks .......: This function is used internally by _Scrollbars_Size
; ===============================================================================================================================
Func _GSB_Size_Text($hWnd)

	Local $tagTEXTMETRIC = "long tmHeight;long tmAscent;long tmDescent;long tmInternalLeading;long tmExternalLeading;" & _
			"long tmAveCharWidth;long tmMaxCharWidth;long tmWeight;long tmOverhang;long tmDigitizedAspectX;long tmDigitizedAspectY;" & _
			"wchar tmFirstChar;wchar tmLastChar;wchar tmDefaultChar;wchar tmBreakChar;byte tmItalic;byte tmUnderlined;byte tmStruckOut;" & _
			"byte tmPitchAndFamily;byte tmCharSet"
	Local $tTEXTMETRIC = DllStructCreate($tagTEXTMETRIC)

	Local $hDC = DllCall("user32.dll", "handle", "GetDC", "hwnd", $hWnd)
	If Not @error Then
		$hDC = $hDC[0]
		DllCall("gdi32.dll", "bool", "GetTextMetricsW", "handle", $hDC, "ptr", DllStructGetPtr($tTEXTMETRIC))
		If @error Then
			Local $iError = @error
			Local $iExtended = @extended
			DllCall("user32.dll", "int", "ReleaseDC", "hwnd", $hWnd, "handle", $hDC)
			Return SetError($iError, $iExtended, -2)
		EndIf
		DllCall("user32.dll", "int", "ReleaseDC", "hwnd", $hWnd, "handle", $hDC)
	Else
		Return SetError(@error, @extended, -1)
	EndIf

	Local $aRet[2] = [ _
			DllStructGetData($tTEXTMETRIC, "tmAveCharWidth"), _
			DllStructGetData($tTEXTMETRIC, "tmHeight") + DllStructGetData($tTEXTMETRIC, "tmExternalLeading")]
	Return $aRet

EndFunc   ;==>_GSB_Size_Text

; #INTERNAL_USE_ONLY#============================================================================================================
; Name...........: _GSB_Size_SB
; Description ...: Sizes scrollbars to fit required GUI size
; Syntax ........: _GSB_Size_SB($hWnd, $idObj)
; Return values .: Array holding size of scrollable GUI
; Author ........: Melba23
; Remarks .......: This function is used internally by _Scrollbars_Size
; ===============================================================================================================================
Func _GSB_Size_SB($hWnd, $idObj)

	Local $tagSCROLLBARINFO = "dword cbSize;long Left;long Top;long Right;long Bottom;int dxyLineButton;int xyThumbTop;" & _
			"int xyThumbBottom;int reserved;dword rgstate[6]"
	Local $tSCROLLBARINFO = DllStructCreate($tagSCROLLBARINFO)
	DllStructSetData($tSCROLLBARINFO, "cbSize", DllStructGetSize($tSCROLLBARINFO))

	DllCall("user32.dll", "bool", "GetScrollBarInfo", "hwnd", $hWnd, "long", $idObj, "ptr", DllStructGetPtr($tSCROLLBARINFO))
	If @error Then Return SetError(@error, @extended, -4)

	Local $aRect[4] = [ _
			DllStructGetData($tSCROLLBARINFO, "Left"), _
			DllStructGetData($tSCROLLBARINFO, "Top"), _
			DllStructGetData($tSCROLLBARINFO, "Right"), _
			DllStructGetData($tSCROLLBARINFO, "Bottom")]
	Return $aRect

EndFunc   ;==>_GSB_Size_SB
#endregion
; region **Functions** Scroll Bars functions =======================================================================================================================================
