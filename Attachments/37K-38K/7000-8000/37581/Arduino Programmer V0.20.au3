#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#Include <GuiListView.au3>
#include <Array.au3>
; include

Global $project = "Untitled" ; Variable to hold the project name
Global $rule_count = 0
Global $list_items[1]
Global $change = 0 ; 0 -> new menu          1 -> submit
;					 0 -> open menu		    1 -> clear settings
;					 0 -> save menu			1 -> aplly
;					 0 -> save as menu

$main = GUICreate("Arduino Gui Programmer V0.20", 1159, 580, 50, 50);, $WS_SIZEBOX)

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

;GUICtrlCreateGraphic(800, 0, 1, 200)
;GUICtrlSetColor(-1, 0x000000)
;GUICtrlCreateGraphic(664, 200, 137, 1)
;GUICtrlSetColor(-1, 0x000000)


GUICtrlCreateLabel("PIN SETTINGS", 920, 5, 79, 17)
#cs
; Graphics to separate inputs
GUICtrlCreateGraphic(533, 30, 15, 1)
GUICtrlSetColor(-1, 0x000000)
GUICtrlCreateGraphic(533, 30, 1, 70)
GUICtrlSetColor(-1, 0x000000)
GUICtrlCreateGraphic(533, 100, 15, 1)
GUICtrlSetColor(-1, 0x000000)
GUICtrlCreateGraphic(533, 130, 15, 1)
GUICtrlSetColor(-1, 0x000000)
GUICtrlCreateGraphic(533, 130, 1, 70)
GUICtrlSetColor(-1, 0x000000)
GUICtrlCreateGraphic(533, 200, 15, 1)
GUICtrlSetColor(-1, 0x000000)
GUICtrlCreateGraphic(533, 230, 15, 1)
GUICtrlSetColor(-1, 0x000000)
GUICtrlCreateGraphic(533, 230, 1, 70)
GUICtrlSetColor(-1, 0x000000)
GUICtrlCreateGraphic(533, 300, 15, 1)
GUICtrlSetColor(-1, 0x000000)
GUICtrlCreateGraphic(533, 330, 15, 1)
GUICtrlSetColor(-1, 0x000000)
GUICtrlCreateGraphic(533, 330, 1, 70)
GUICtrlSetColor(-1, 0x000000)
GUICtrlCreateGraphic(533, 400, 15, 1)
GUICtrlSetColor(-1, 0x000000)
GUICtrlCreateGraphic(533, 420, 15, 1)
GUICtrlSetColor(-1, 0x000000)
GUICtrlCreateGraphic(533, 420, 1, 70)
GUICtrlSetColor(-1, 0x000000)
GUICtrlCreateGraphic(533, 490, 15, 1)
GUICtrlSetColor(-1, 0x000000)
#ce
#endregion 
; endregion Create Graphics

#region Create Menu
; Create the menu objects
$file_menu = GUICtrlCreateMenu ("File")
$new_menu = GUICtrlCreateMenuItem ("New", $file_menu)
$save_menu = GUICtrlCreateMenuItem ("Save", $file_menu)
$save_as_menu = GUICtrlCreateMenuItem ("Save As...", $file_menu)
$open_menu = GUICtrlCreateMenuItem ("Open...", $file_menu)
$exit_menu = GUICtrlCreateMenuItem ("Exit", $file_menu)
$help_menu = GUICtrlCreateMenu ("Help")
$about_menu = GUICtrlCreateMenuItem ("About", $help_menu)
$how_to_menu = GUICtrlCreateMenuItem ("How To...", $help_menu)
#endregion
; region Create Menu

#region Create Buttons
$button_clear_set = GUICtrlCreateButton("Clear Settings", 850, 400, 91, 25)
$button_submit = GUICtrlCreateButton("Submit", 971, 400, 71, 25)
$button_apply_rule = GUICtrlCreateButton("Apply Rule", 830, 464, 70, 25)
GUICtrlSetState (-1, $GUI_DISABLE)
$button_clear_rule = GUICtrlCreateButton("Clear Rule", 830, 499, 70, 25)
GUICtrlSetState (-1, $GUI_DISABLE)
$button_load_rule = GUICtrlCreateButton("Load Rule", 912, 464, 70, 25)
GUICtrlSetState (-1, $GUI_DISABLE)
$button_delete_rule = GUICtrlCreateButton("Delete Rule", 912, 499, 70, 25)
GUICtrlSetState (-1, $GUI_DISABLE)
$button_generate = GUICtrlCreateButton("Generate Code", 1044, 499, 100, 25)
GUICtrlSetState (-1, $GUI_DISABLE)
;$check_box = GUICtrlCreateCheckbox("Check Syntax", 730, 464, 85, 25, 0x0020) ; ALSO CHANGE THE CODE IN THE APPLY BUTTON CASE
;GUICtrlSetState (-1, $GUI_CHECKED)
#endregion
; #region Create Buttons

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
; region Create List

$settings_pin_combos = _create_settings_combos()
$rule_combos = _create_rule_combos($rule_count)

GUISetState(@SW_SHOW)

While 1
	;ToolTip ($project)
	;ToolTip ($rule_count)
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
			_write_project_to_file($settings_pin_combos, $list_items, $project, 1)
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
			$file=FileOpen($proj)
			If FileReadLine($file) = "NAG FILE V.020" Then
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
				GUICtrlSetState ($button_apply_rule, $GUI_ENABLE)
				GUICtrlSetState ($button_clear_rule, $GUI_ENABLE)
				_disable_declared_pins($settings_pin_combos) ; Disable the selected pins and write names to the empty ones
				$pin_names = _read_settings_names($settings_pin_combos) ; Get the names of the declared pins
				_delete_rule_combos($rule_combos)
				$rule_combos = _create_rule_combos($rule_count)
				_update_rule_combos_inputs($pin_names, $rule_combos) ; Set the pin options in the input combos
				$a = _read_rules_from_list($list_items)
				_update_rule_combos_virtuals($a, $rule_combos)
				#endregion
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
					$list_items[$i] = $b
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
		Case $button_submit
			$change = 1
			GUICtrlSetState ($button_apply_rule, $GUI_ENABLE)
			GUICtrlSetState ($button_clear_rule, $GUI_ENABLE)
			GUICtrlSetState ($button_generate, $GUI_ENABLE)
			_disable_declared_pins($settings_pin_combos) ; Disable the selected pins and write names to the empty ones
			$pin_names = _read_settings_names($settings_pin_combos) ; Get the names of the declared pins
			_delete_rule_combos($rule_combos)
			$rule_combos = _create_rule_combos($rule_count)
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
						$list_items[$i] = $b
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
			EndIf
		Case $button_clear_set
			$change = 1
			$clear_selec = GUICreate("Clear Settings", 580, 179, 333, 110)
			$all = GUICtrlCreateButton("Clear All", 16, 136, 75, 25)
			$unsubmited = GUICtrlCreateButton("Clear UnSubmited", 104, 136, 107, 25)
			$cancel = GUICtrlCreateButton("Cancel", 224, 136, 75, 25)
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
					Case $all
						GUISwitch($main)
						$check = MsgBox (36, "Confirm", "Are you sure you want to delete all settings combos and all rules")
						If $check = 6 Then ; Yes
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
						_disable_declared_pins($settings_pin_combos)
						GUISwitch($clear_selec)
						ExitLoop
				EndSwitch
			WEnd
			GUISwitch($main)
			GUIDelete($clear_selec)
		Case $rule_combos[1]
			_update_rule_combos_others($pin_names, $rule_combos, 1)
		Case $rule_combos[5]
			_update_rule_combos_others($pin_names, $rule_combos, 2)
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
					$in_selec = GUICtrlCreateCombo("", 24,56,145,25)
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
					$praxi = GUICtrlCreateCombo(" * Multiple", 184, 56, 85, 25)
					GUICtrlSetData(-1, " / Divide| + Add| - Remove")
					$timi = GUICtrlCreateInput("", 284, 56, 121, 21, 0x2080) ; 0x2080=0x0080($ES_AUTOHSCROLL) + 0x2000($ES_NUMBER)
					$ok_b = GUICtrlCreateButton("OK", 122, 114, 75, 25)
					$canc_b = GUICtrlCreateButton("Cancel", 223, 114, 74, 25)
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

; #FUNCTION# =================================================================================================================================
; Name...........: 	_generate_code
; Description ...: 	Creates the Arduino code
; Parameters ....: 	Array containing the controlID's of the list items which contain the rules
;					Array containing the controlID's of the Settings combos
;					The file name of the generated file
; Return values .: 	No return just create the file with the arduino code
; ============================================================================================================================================
Func _generate_code($items, $settings, $file_name = $project)
	$names = _read_settings_names($settings)
	$pins = _read_settings_combos($settings)
	If StringRight($file_name, 4) <> ".nag" Then
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
		For $i = 1 To _ArrayMax($coun, 1)
			$a &= "0,"
		Next
		FileWriteLine($file, "int counter[] = {" & StringTrimRight($a, 1) & "};")
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
		FileWriteLine($file, "int temp = 0;")
	EndIf
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
		FileWriteLine ($file, "  }")
	EndIf
	; THIS IS WERE THE MAGIC BEGINS
	For $i=0 To ($rule_count-1)
		$rul=StringSplit(GUICtrlRead($items[$i]), "|", 2)
		$delay_index = 0
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
				EndIf
			Next
		EndIf
		If $names[0][3] > 0 Then ; AO
			For $j=1 To $names[0][3]
				If $rul[8] = $names[$j][3] Then
					$out_pin_to_write = "an_out[" & $j-1 & "]"
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
			$output[0] = "delay (delay_val[" & $delay_index & "]);"
			$delay_index += 1
		EndIf
		If StringInStr($out_pin_to_write, "dig_out") <> 0 Then
			$output[3] = "digitalWrite(" & $out_pin_to_write & ", " & $out_val_to_write & ");"
		ElseIf StringInStr($out_pin_to_write, "an_out") <> 0 Then
			If StringInStr($rul[9], "f(x)") <> 0 Then
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
				$output[1] = "temp = " & $b & $a[2] & $a[3] & ";"
				If StringInStr($b, "an_in") <> 0 Then
					$output[2] = "exp_val = map(temp, 0, 1024, 0, 255);"
				Else
					$output[2] = "exp_val = temp;"
				EndIf
			EndIf
			$output[3] = "analogWrite(" & $out_pin_to_write & ", " & $out_val_to_write & ");"
		ElseIf StringInStr($out_pin_to_write, "virtual_coil") <> 0 Then
			$output[3] = $out_pin_to_write & " = " & $out_val_to_write & ";"
		ElseIf StringInStr($out_pin_to_write, "counter") <> 0 Then
			$output[3] = $out_pin_to_write & " " & $rul[9] & "= " & $out_val_to_write & ";"
		EndIf
		#endregion
		#region Create the first input of the rule (e.g. " if (dig_in_state[0] == HIGH) { ")
		; Create the value
		$input_1 = ""
		If $rul[3] = "High" Then
			$in_1_val_to_write = "HIGH"
		ElseIf $rul[3] = "Low" Then
			$in_1_val_to_write = "LOW"
		Else
			$in_1_val_to_write = $rul[3]
		EndIf
		; Create the comparator
		If $rul[2] = "=" Then
			$in_1_comp_to_write = "=="
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
		If StringInStr($rul[1], "Virtual_Coil") <> 0 Then ; Virtual Coil
			$in_1_pin_to_write = "virtual_coil[" & StringMid($rul[1], 14)-1 & "]"
		EndIf
		If StringInStr($rul[1], "Counter") <> 0 Then ; Counter
			$in_1_pin_to_write = "counter[" & StringMid($rul[1], 10)-1 & "]"
		EndIf
		; Combine the Pin, the comparator and the value
		If $rul[1] <> "" Then
			$input_1 = $in_1_pin_to_write & " " & $in_1_comp_to_write & " " & $in_1_val_to_write
		EndIf
		#endregion
		#region Create the second input of the rule (e.g. " && dig_in_state[1] == HIGH) { ")
		$input_2 = ""
		; Create the logical
		If $rul[4] = "AND" Then
			$logical_to_write = "&&"
		ElseIf $rul[4] = "OR" Then
			$logical_to_write = "||"
		EndIf
		; Create the value
		If $rul[7] = "High" Then
			$in_2_val_to_write = "HIGH"
		ElseIf $rul[7] = "Low" Then
			$in_2_val_to_write = "LOW"
		Else
			$in_2_val_to_write = $rul[7]
		EndIf
		; Create the comparator
		If $rul[6] = "=" Then
			$in_2_comp_to_write = "=="
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
		If StringInStr($rul[5], "Virtual_Coil") <> 0 Then ; Virtual Coil
			$in_2_pin_to_write = "virtual_coil[" & StringMid($rul[5], 14)-1 & "]"
		EndIf
		If StringInStr($rul[5], "Counter") <> 0 Then ; Counter
			$in_2_pin_to_write = "counter[" & StringMid($rul[5], 9)-1 & "]"
		EndIf
		; Combine the Pin, the comparator and the value
		If $rul[5] <> "" Then
			$input_2 = $in_2_pin_to_write & " " & $in_2_comp_to_write & " " & $in_2_val_to_write
		EndIf
		#endregion
		#region Combine The Inputs And The Outputs To Create The Rule
		If $rul[1] = "" And $rul[5] = "" Then ; Case inputs are empty
			$out = ""
			If $output[0] <> "" Then ; Delay
				$out &= "  " & $output[0] & " //*** Rule_" & $i & " ***" & @LF
			EndIf
			If $output[1] <> "" Then ; temp variable
				$out &= "  " & $output[1] & "  //*** Rule_" & $i & " ***" & @LF
			EndIf
			If $output[2] <> "" Then ; exp_val variable
				$out &= "  " & $output[2] & "  //*** Rule_" & $i & " ***" & @LF
				$out &= "  " & "if (exp_val >= 255) {" & "  //*** Rule_" & $i & " ***" & @LF
				$out &= "    " & "exp_val = 255" & "  //*** Rule_" & $i & " ***" & @LF
				$out &= "  }" & "  //*** Rule_" & $i & " ***" & @LF
				$out &= "  " & "if (exp_val < 0) {" & "  //*** Rule_" & $i & " ***" & @LF
				$out &= "    " & "exp_val = 0" & "  //*** Rule_" & $i & " ***" & @LF
				$out &= "  }" & "  //*** Rule_" & $i & " ***" & @LF
			EndIf
			If $output[3] <> "" Then ; pin
				$out &= "  " & $output[3] & "  //*** Rule_" & $i & " ***" & @LF
			EndIf
			FileWriteLine($file, $out)
		ElseIf $rul[1] <> "" And $rul[5] = "" Then ; Case input 1
			$out = ""
			If $output[0] <> "" Then
				$out &= "    " & $output[0] & " //*** Rule_" & $i & " ***" & @LF
			EndIf
			If $output[1] <> "" Then
				$out &= "    " & $output[1] & "  //*** Rule_" & $i & " ***" & @LF
			EndIf
			If $output[2] <> "" Then
				$out &= "    " & $output[2] & "  //*** Rule_" & $i & " ***" & @LF
				$out &= "    " & "if (exp_val >= 255) {" & "  //*** Rule_" & $i & " ***" & @LF
				$out &= "      " & "exp_val = 255" & "  //*** Rule_" & $i & " ***" & @LF
				$out &= "    }" & "  //*** Rule_" & $i & " ***" & @LF
				$out &= "    " & "if (exp_val < 0) {" & "  //*** Rule_" & $i & " ***" & @LF
				$out &= "      " & "exp_val = 0" & "  //*** Rule_" & $i & " ***" & @LF
				$out &= "    }" & "  //*** Rule_" & $i & " ***" & @LF
			EndIf
			If $output[3] <> "" Then
				$out &= "    " & $output[3] & "  //*** Rule_" & $i & " ***" & @LF
			EndIf
			FileWriteLine($file, "  if (" & $input_1 & ") {" & " //*** Rule_" & $i & " ***")
			FileWriteLine($file, $out)
			FileWriteLine($file, "  } //*** Rule_" & $i & " ***")
		ElseIf $rul[1] = "" And $rul[5] <> "" Then ; Case input 2
			$out = ""
			If $output[0] <> "" Then
				$out &= "    " & $output[0] & " //*** Rule_" & $i & " ***" & @LF
			EndIf
			If $output[1] <> "" Then
				$out &= "    " & $output[1] & "  //*** Rule_" & $i & " ***" & @LF
			EndIf
			If $output[2] <> "" Then
				$out &= "    " & $output[2] & "  //*** Rule_" & $i & " ***" & @LF
				$out &= "    " & "if (exp_val >= 255) {" & "  //*** Rule_" & $i & " ***" & @LF
				$out &= "      " & "exp_val = 255" & "  //*** Rule_" & $i & " ***" & @LF
				$out &= "    }" & "  //*** Rule_" & $i & " ***" & @LF
				$out &= "    " & "if (exp_val < 0) {" & "  //*** Rule_" & $i & " ***" & @LF
				$out &= "      " & "exp_val = 0" & "  //*** Rule_" & $i & " ***" & @LF
				$out &= "    }" & "  //*** Rule_" & $i & " ***" & @LF
			EndIf
			If $output[3] <> "" Then
				$out &= "    " & $output[3] & "  //*** Rule_" & $i & " ***" & @LF
			EndIf
			FileWriteLine($file, "  if (" & $input_2 & ") {" & " //*** Rule_" & $i & " ***")
			FileWriteLine($file, $out)
			FileWriteLine($file, "  } //*** Rule_" & $i & " ***")
		ElseIf $rul[1] <> "" And $rul[5] <> "" Then ; Case Both Inputs
			$out = ""
			If $output[0] <> "" Then
				$out &= "    " & $output[0] & " //*** Rule_" & $i & " ***" & @LF
			EndIf
			If $output[1] <> "" Then
				$out &= "    " & $output[1] & "  //*** Rule_" & $i & " ***" & @LF
			EndIf
			If $output[2] <> "" Then
				$out &= "    " & $output[2] & "  //*** Rule_" & $i & " ***" & @LF
				$out &= "    " & "if (exp_val >= 255) {" & "  //*** Rule_" & $i & " ***" & @LF
				$out &= "      " & "exp_val = 255" & "  //*** Rule_" & $i & " ***" & @LF
				$out &= "    }" & "  //*** Rule_" & $i & " ***" & @LF
				$out &= "    " & "if (exp_val < 0) {" & "  //*** Rule_" & $i & " ***" & @LF
				$out &= "      " & "exp_val = 0" & "  //*** Rule_" & $i & " ***" & @LF
				$out &= "    }" & "  //*** Rule_" & $i & " ***" & @LF
			EndIf
			If $output[3] <> "" Then
				$out &= "    " & $output[3] & "  //*** Rule_" & $i & " ***" & @LF
			EndIf
			FileWriteLine($file, "  if (" & $input_1 & " " & $logical_to_write & " " & $input_2 & ") {" & " //*** Rule_" & $i & " ***")
			FileWriteLine($file, $out)
			FileWriteLine($file, "  } //*** Rule_" & $i & " ***")
		EndIf
		#endregion
	Next
	FileWriteLine($file, "}")
	#endregion void loop()
	FileClose ($file)
	ShellExecute (@ScriptDir & "/" & $file_name & ".txt")
EndFunc

; #FUNCTION# =================================================================================================================================
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
					If $rule[10] <= 0 Then
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
		If $rule[4] <> "AND" And $rule[4] <> "OR" Then
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

; #FUNCTION# =================================================================================================================================
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
		FileWriteLine ($project_file, "NAG FILE V.020")
		FileWriteLine($project_file, "Settings_START")
		For $i=0 To 19
			FileWriteLine($project_file, $i & ":" & GUICtrlRead($combos[$i][0]) & ":" & GUICtrlRead($combos[$i][1]))
		Next
		FileWriteLine($project_file, "Settings_END")
		FileWriteLine($project_file, "Rules_START")
		$a = _read_rules_from_list($list)
		;_ArrayDisplay($a)
		If StringInStr($a[0], "|") <> 0 Then ;Check if at least one rule has been created
			For $i=0 To UBound($a)-1
				FileWriteLine($project_file, $a[$i])
			Next
		EndIf
		FileWriteLine($project_file, "Rules_END")
		FileClose($project_file)
	EndIf
EndFunc

; #FUNCTION# =================================================================================================================================
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
		$in_1_coil = " "
		$in_2_coil = " "
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

; #FUNCTION# =================================================================================================================================
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

; #FUNCTION# =================================================================================================================================
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
	$rule_item = GUICtrlCreateListViewItem ($rule_item, $list)
	Return $rule_item
EndFunc

; #FUNCTION# =================================================================================================================================
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
		EndIf
	Next
	Return $rule
EndFunc

; #FUNCTION# =================================================================================================================================
; Name...........: 	_update_rule_combos_others
; Description ...: 	Updates the options logic combos on the rule combos
; Parameters ....: 	The array containing the names of the Inputs and Outputs previously created by the _read_settings_names() function
;					, the array containing the ControlID's of the rule combos and the input/output combo to update: 1 for Input A
;																													2 for Input B
;																													3 for Output
;					Default value for the combarator combo and the default value for the value combo
; Return values .: 	No value returned just updates the data in the combos
; ============================================================================================================================================
Func _update_rule_combos_others($array_names, $combos, $x, $default_1="", $default_2="")
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
			GUICtrlSetData(-1, "+  Increase By|-  Decrease By") ; Set the appropriate options
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
		If _ArraySearch($array_names, $a, 0, 0, 0, 0, 1, 2) > 0 Then ; If an Analog input pin is selected
			GUICtrlDelete($combos[2])
			$combos[2] = GUICtrlCreateCombo($default_1, 66, 481, 100, 25, 0x0003)
			GUICtrlSetData(-1, "=  Equal To|>  Greater Than|<  Less Than|>=  Greater / Equal|<=  Less / Equal")
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
		If _ArraySearch($array_names, $a, 0, 0, 0, 0, 1, 2) > 0 Then ; If an Analog input pin is selected
			GUICtrlDelete($combos[6])
			$combos[6] = GUICtrlCreateCombo($default_1, 240, 481, 100, 25, 0x0003)
			GUICtrlSetData(-1, "=  Equal To|>  Greater Than|<  Less Than|>=  Greater / Equal|<=  Less / Equal")
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

; #FUNCTION# =================================================================================================================================
; Name...........: 	_update_rule_combos_inputs
; Description ...: 	Updates the options at the pin selection combos on the rule combos
; Parameters ....: 	The array containing the names of the Inputs and Outputs previously created by the _read_settings_names() function
;					and the array containing the ControlID's of the rule combos 
; Return values .: 	No value returned just updates the data in the combos
; ============================================================================================================================================
Func _update_rule_combos_inputs($array_names, $combos)
	; Update the inputs
	$a=""
	For $i = 1 To $array_names[0][0] ; Loop over the DI pins
		$a = $a & $array_names[$i][0] & "|"
	Next
	For $i = 1 To $array_names[0][2] ; Loop over the AI pins
		$a = $a & $array_names[$i][2] & "|"
	Next
	#cs
	For $i = 1 To $array_names[0][1] ; Loop over the DO pins
		$a = $a & $array_names[$i][1] & "|"
	Next
	For $i = 1 To $array_names[0][3] ; Loop over the AO pins
		$a = $a & $array_names[$i][3] & "|"
	Next
	#ce
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

; #FUNCTION# =================================================================================================================================
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
	$rule_combos[0] = GUICtrlCreateCombo($p[0], 8, 481, 50, 25, 0x0003) ; Rule count
	GUICtrlSetData (-1, $a)
	$rule_combos[1] = GUICtrlCreateCombo($p[1], 66, 454, 100, 25, 0x0003) ; Input A
	$rule_combos[2] = GUICtrlCreateCombo($p[2], 66, 481, 100, 25, 0x0003)
	$rule_combos[3] = GUICtrlCreateCombo($p[3], 66, 509, 100, 25, 0x0003)
	$rule_combos[4] = GUICtrlCreateCombo($p[4], 178, 481, 50, 25, 0x0003) ; AND OR option
	If $p[4] = "AND" Then
		GUICtrlSetData(-1, "OR")
	ElseIf $p[4] = "OR" Then
		GUICtrlSetData(-1, "AND")
	Else
		GUICtrlSetData(-1, "AND|OR")
	EndIf
	$rule_combos[5] = GUICtrlCreateCombo($p[5], 240, 454, 100, 25, 0x0003) ; Input B
	$rule_combos[6] = GUICtrlCreateCombo($p[6], 240, 481, 100, 25, 0x0003)
	$rule_combos[7] = GUICtrlCreateCombo($p[7], 240, 509, 100, 25, 0x0003)
	GUICtrlCreateLabel("==>", 353, 483, 20, 25)
	$rule_combos[8] = GUICtrlCreateCombo($p[8], 386, 454, 100, 25, 0x0003) ; Output
	$rule_combos[9] = GUICtrlCreateCombo($p[9], 386, 481, 100, 25, 0x0003)
	$rule_combos[10] = GUICtrlCreateCombo($p[10], 386, 509, 100, 25, 0x0003)
	GUICtrlCreateLabel("Delay  (ms)",  605,  478)
	$rule_combos[11] = GUICtrlCreateInput($p[11], 498, 475, 100, 25, 0x2000) ; Delay
	GUICtrlCreateUpdown(-1, BitOR(0x20, 0x80))
	$rule_combos[12] = GUICtrlCreateInput($p[12], 498, 504, 115, 25)
	
	Return $rule_combos
EndFunc

; #FUNCTION# =================================================================================================================================
; Name...........: 	_disable_declared_pins
; Description ...: 	Disable (grey out) any setting combo and name input that has allready been declared. In case of an empty name writes the pin number
; Parameters ....: 	The array containing the controlID's of the settings combos
; Return values .: 	
; ============================================================================================================================================
Func _disable_declared_pins($array)
	For $i=0 To 19
		If GUICtrlRead($array[$i][0]) <> "" Then
			GUICtrlSetState ($array[$i][0], $GUI_DISABLE)
			If GUICtrlRead($array[$i][1]) <> "" Then
				GUICtrlSetState($array[$i][1], $GUI_DISABLE)
			Else
				GUICtrlSetData($array[$i][1], "Pin_" & $i) ; If the name input box is empty then write the pin number before disabling
				GUICtrlSetState($array[$i][1], $GUI_DISABLE)
			EndIf
		EndIf
	Next
EndFunc ; _disable_declared_pins

; #FUNCTION# =================================================================================================================================
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
		$set_p[0][0]=$count
		If GUICtrlRead($array[$i][0]) = "DI" Then
			$count += 1
			ReDim $set_p[$count+1][4]
			If GUICtrlRead($array[$i][1]) <> "" Then
				$set_p[$count][0]=GUICtrlRead($array[$i][1])
			Else
				$set_p[$count][0]="Pin_" & $i
			EndIf
		EndIf
	Next
	; Read and store the Digital Outputs at the Col_1 of the $set_p array 
	$count=0
	For $i=0 To 19
		$set_p[0][1]=$count
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
	Next
	; Read and store the Analog Inputs at the Col_2 of the $set_p array 
	$count=0
	For $i=0 To 19
		$set_p[0][2]=$count
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
	Next
	; Read and store the Analog Outputs at the Col_3 of the $set_p array 
	$count=0
	For $i=0 To 19
		$set_p[0][3]=$count
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
	Next
	Return $set_p
EndFunc ; _read_settings_names()

; #FUNCTION# =================================================================================================================================
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
		$set_p[0][0] = $count
		If GUICtrlRead($array[$i][0]) = "DI" Then
			$count += 1
			ReDim $set_p[$count+1][4]
			$set_p[$count][0]=$i
		EndIf
	Next
	; Read and store the Digital Outputs at the Col_1 of the $set_p array 
	$count=0
	For $i=0 To 19
		$set_p[0][1] = $count
		If GUICtrlRead($array[$i][0]) = "DO" Then
			$count += 1
			If $count >= UBound ($set_p, 1) Then ; Check if the DO's are more of the DI's to increase the $set_p array
				ReDim $set_p[$count+1][4]
			EndIf
			$set_p[$count][1]=$i
		EndIf
	Next
	; Read and store the Analog Inputs at the Col_2 of the $set_p array 
	$count=0
	For $i=0 To 19
		$set_p[0][2] = $count
		If GUICtrlRead($array[$i][0]) = "AI" Then
			$count += 1
			If $count >= UBound ($set_p, 1) Then
				ReDim $set_p[$count+1][4]
			EndIf
			$set_p[$count][2]=$i
		EndIf
	Next
	; Read and store the Analog Outputs at the Col_3 of the $set_p array 
	$count=0
	For $i=0 To 19
		$set_p[0][3] = $count
		If GUICtrlRead($array[$i][0]) = "AO" Then
			$count += 1
			If $count >= UBound ($set_p, 1) Then
				ReDim $set_p[$count+1][4]
			EndIf
			$set_p[$count][3]=$i
		EndIf
	Next
	Return $set_p
EndFunc ; _read_settings_combos()

; #FUNCTION# ====================================================================================================================
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
EndFunc ; _create_settings_combos()

; #FUNCTION# ====================================================================================================================
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

; #FUNCTION# ====================================================================================================================
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
