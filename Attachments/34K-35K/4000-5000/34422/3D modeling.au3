;thanks to A.Percy and all others who contributed to developing Au3GlPlugin

#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include "GlPluginUtils.au3"
#include <SliderConstants.au3>
#include <ComboConstants.au3>

#include <Array.au3>

Global $main, $add_gui, $ok
Global $labels[7], $labels_text[7] = ["Start X", "Start Y", "Start Z", "Width", "Height", "Depth", "Scale"], $inputs[7]
Global $b_inputs[7], $b_labels[7]
Global $cylinder_text[4] = ["X Center", "Y Center", "Z Center", "Radius"]
Global $data[10]
Global $objects[100][16] ; 0-Object ID, 1-Shape Iidentifier, 2-X, 3-Y, 4-Z, 5-width, 6-height; 7-depth, 8-scale, 9-X_angle, 10-Y_angle, 11-Z_angle, 12-red, 13-green, 14-blue, 15-type
Global $oIndex = 0, $object_browser
Global $button_delete, $button_update
Global $temp_array[16]
Global $slider_precision = 0.1, $combo, $create_colors[3], $edit_color[3], $add_angles[3], $edit_angles[3]
Global $custom_gui = 9999, $ok_custom = 9999, $custom, $path, $c_delete = 9999
Global $custom_current_editing = False, $last_edited_custom = False
Global $c_label[2], $b_p[2]
$main = GUICreate("OpenGl", 600, 600)
$file = GUICtrlCreateMenu("File")
$save = GUICtrlCreateMenuItem("Save As", $file)
$open = GUICtrlCreateMenuItem("Open", $file)
;~ $display=GUICtrlCreateMenuItem("d",$open)
$add = GUICtrlCreateMenu("Add")
$cube = GUICtrlCreateMenuItem("Cube", $add)
$cylinder = GUICtrlCreateMenuItem("Cylinder", $add)
$cone = GUICtrlCreateMenuItem("Cone", $add)
$sphere = GUICtrlCreateMenuItem("Sphere", $add)
GUICtrlCreateMenuItem("", $add)
$custom_m = GUICtrlCreateMenuItem("Custom", $add)
EmbedGlWindow($main, 300, 300, 10, 10)
SetClearColor(0.2, 0.2, 0.2)
CreateLight(0, 300, 300, 300)
SetLightAmbient(0, 0.2, 0.2, 0.2)
SetLightDiffuse(0, 0.7, 0.7, 0.7)
SetLightSpecular(0, 1.0, 1.0, 1.0)
SetCamera(0, 60, 250, 0, 0, 0)

GUISetState()
_ObjectBrowser()
_Add()
ConsoleWrite($labels[2] & @CRLF)
Global $cylinder_labels_change[4] = [$labels[0], $labels[1], $labels[2], $labels[3]], $cylinder_disable[1] = [$inputs[5]]
Global $sphere_text[4] = ["X Center", "Y Center", "Z Center", "Radius"], $sphere_labels_change[4] = [$labels[0], $labels[1], $labels[2], $labels[3]], $sphere_disable[2] = [$inputs[4], $inputs[5]]
Global $cone_text[4] = ["X Center", "Y Center", "Z Center", "Radius"], $cone_labels_change[4] = [$labels[0], $labels[1], $labels[2], $labels[3]], $cone_disable[1] = [$inputs[5]]
Global $browser_cylinder_labels_change[4] = [$b_labels[0], $b_labels[1], $b_labels[2], $b_labels[3]], $browser_cylinder_disable[1] = [$b_inputs[5]]
Global $browser_sphere_labels_change[4] = [$b_labels[0], $b_labels[1], $b_labels[2], $b_labels[3]], $browser_sphere_disable[2] = [$b_inputs[4], $b_inputs[5]]
Global $browser_cone_labels_change[4] = [$b_labels[0], $b_labels[1], $b_labels[2], $b_labels[3]], $browser_cone_disable[1] = [$b_inputs[5]]
While 1
	SceneDraw()
;~ 	Sleep(100)
	$msg = GUIGetMsg(1)
	Switch $msg[1]
		Case $main
			Switch $msg[0]
				Case -3
					Exit
;~ 				Case $display
;~ 					_ArrayDisplay($objects)
				Case $custom_m
					$c_path = FileOpenDialog("Custom Shape", @WorkingDir, "Custom Shape files(*.csh)", 3, "", $main)
					If Not @error Then _Custom($c_path)
				Case $save
					$save_path = FileSaveDialog("Save As", @WorkingDir, "(*.ini)", 16, "", $main)
					If Not @error Then
						_SaveAs($save_path)
						WinSetTitle($main, "", "OpenGl-" & $save_path)
					EndIf
				Case $open
					$open_path = FileOpenDialog("Open file", @WorkingDir, "(*.ini)", 16, "", $main)
					If Not @error Then
						For $i = 0 To UBound($oIndex)
							GUICtrlSendMsg($combo, $CB_DELETESTRING, $i, 0)
							ObjectDelete($objects[$i + 1][0])
						Next
						$oIndex = 0
						_Open($open_path)
						WinSetTitle($main, "", "OpenGl-" & $open_path)
					EndIf
				Case $cube
					GUISetState(@SW_DISABLE, $main)
					_Enable($inputs)
					GUISetState(@SW_SHOW, $add_gui)
					$add_what = GUICtrlRead($cube, 1)
					_LabelsSetDefaultText($labels)
				Case $cylinder
					GUISetState(@SW_DISABLE, $main)
					_Enable($inputs)
					GUISetState(@SW_SHOW, $add_gui)
					$add_what = GUICtrlRead($cylinder, 1)
					_LabelsSetText($cylinder_labels_change, $cylinder_text, $cylinder_disable)
				Case $sphere
					GUISetState(@SW_DISABLE, $main)
					_Enable($inputs)
					GUISetState(@SW_SHOW, $add_gui)
					_LabelsSetText($sphere_labels_change, $sphere_text, $sphere_disable)
					$add_what = GUICtrlRead($sphere, 1)
				Case $cone
					GUISetState(@SW_DISABLE, $main)
					_Enable($inputs)
					GUISetState(@SW_SHOW, $add_gui)
					_LabelsSetText($cone_labels_change, $cone_text, $cone_disable)
					$add_what = GUICtrlRead($cone, 1)
			EndSwitch
		Case $add_gui
			Switch $msg[0]
				Case -3
					GUISetState(@SW_HIDE, $add_gui)
					GUISetState(@SW_ENABLE, $main)
				Case $ok
					$oIndex = $oIndex + 1
					$object_ = ObjectCreate()
					GUICtrlSetData($combo, $oIndex)
					ConsoleWrite("+$object_=" & $object_ & @CRLF)
					$objects[$oIndex][0] = $object_
					For $i = 0 To UBound($inputs) - 1
						$data[$i] = GUICtrlRead($inputs[$i])
						$objects[$oIndex][$i + 2] = $data[$i]
						ConsoleWrite("$data[" & $i & "]=" & $data[$i] & @CRLF)
					Next
					$red = GUICtrlRead($create_colors[0]) * $slider_precision
					$green = GUICtrlRead($create_colors[1]) * $slider_precision
					$blue = GUICtrlRead($create_colors[2]) * $slider_precision
					$x_angle = GUICtrlRead($add_angles[0])
					$y_angle = GUICtrlRead($add_angles[1])
					$z_angle = GUICtrlRead($add_angles[2])
					$objects[$oIndex][9] = $x_angle
					$objects[$oIndex][10] = $y_angle
					$objects[$oIndex][11] = $z_angle
					$objects[$oIndex][12] = $red
					$objects[$oIndex][13] = $green
					$objects[$oIndex][14] = $blue
					$objects[$oIndex][15] = $add_what
;~ 					$colors = StringSplit(StringRight($data[6], 6), "")
					Switch $add_what
						Case "Cube"
;~ 							MsgBox(0,"","cube")
							$last = AddCube($object_, $data[3], $data[4], $data[5], $red, $green, $blue, 1.0) ;$colors[1] & $colors[2],$colors[3] & $colors[4],$colors[5] & $colors[6]
							ShapeTranslate($object_, $last, $data[0], $data[1], $data[2])
						Case "Cylinder"
;~ 							MsgBox(0,"","Cylinder")
							$last = AddCylinder($object_, $data[0], $data[1], $data[2], $data[3], $data[3], $data[4], 20, 20, $red, $green, $blue, 1.0)
						Case "Sphere"
							$last = AddSphere($object_, $data[0], $data[1], $data[2], $data[3], 20, 20, $red, $green, $blue, 1.0)
						Case "Cone"
							$last = AddCylinder($object_, $data[0], $data[1], $data[2], $data[3], 0, $data[4], 20, 20, $red, $green, $blue, 1.0)
					EndSwitch
;~ 					SetCamera(0, $data[1]+50, $data[2]+100, $data[0],$data[1],$data[2])
					ObjectScale($object_, $data[6], $data[6], $data[6])
					ObjectRotate($object_, $x_angle, $y_angle, $z_angle)
					SetPrint($object_)
					$objects[$oIndex][1] = $last
					_ResetValues($inputs)
					_Enable($inputs)
					GUISetState(@SW_HIDE, $add_gui)
					GUISetState(@SW_ENABLE, $main)
;~ 					_ArrayDisplay($objects)
			EndSwitch
		Case $object_browser
			Switch $msg[0]
				Case $combo
					_Enable($b_inputs)
					$combo_data = GUICtrlRead($combo)
					$type = $objects[$combo_data][15]
					ConsoleWrite($type & @CRLF)
;~ 					If $last_edited_custom = True And $type <> "Custom" Then
						For $m = $b_labels[0] To $edit_angles[2]
							GUICtrlSetState($m, $GUI_SHOW)
						Next
						For $i = 1 To UBound($c_label) - 1
							GUICtrlDelete($c_label[$i])
							GUICtrlDelete($b_p[$i])
						Next
						$last_edited_custom = False
;~ 					EndIf
;~ 						For $i = $c_label[0] To $b_p[UBound($b_p)-1]
;~ 							ConsoleWrite(">+" & $i & @CRLF)
;~ 							GUICtrlDelete($i)
;~ 						Next
;~ 						$last_edited_custom=False
;~ 					EndIf
					$last_edited_custom=False
					Switch $type
						Case "Cube"
							_LabelsSetDefaultText($b_labels)
							For $i = 0 To UBound($b_inputs) - 1
								GUICtrlSetData($b_inputs[$i], $objects[$combo_data][$i + 2])
							Next
							GUICtrlSetData($edit_color[0], $objects[$combo_data][12] / $slider_precision)
							GUICtrlSetData($edit_color[1], $objects[$combo_data][13] / $slider_precision)
							GUICtrlSetData($edit_color[2], $objects[$combo_data][14] / $slider_precision)
						Case "Cylinder"
							_LabelsSetText($browser_cylinder_labels_change, $cylinder_text, $browser_cylinder_disable)
							For $i = 0 To UBound($b_inputs) - 1
								GUICtrlSetData($b_inputs[$i], $objects[$combo_data][$i + 2])
							Next
							GUICtrlSetData($edit_color[0], $objects[$combo_data][12] / $slider_precision)
							GUICtrlSetData($edit_color[1], $objects[$combo_data][13] / $slider_precision)
							GUICtrlSetData($edit_color[2], $objects[$combo_data][14] / $slider_precision)
						Case "Sphere"
							_LabelsSetText($browser_sphere_labels_change, $sphere_text, $browser_sphere_disable)
							For $i = 0 To UBound($b_inputs) - 1
								GUICtrlSetData($b_inputs[$i], $objects[$combo_data][$i + 2])
							Next
							GUICtrlSetData($edit_color[0], $objects[$combo_data][12] / $slider_precision)
							GUICtrlSetData($edit_color[1], $objects[$combo_data][13] / $slider_precision)
							GUICtrlSetData($edit_color[2], $objects[$combo_data][14] / $slider_precision)
						Case "Cone"
							_LabelsSetText($browser_cone_labels_change, $cone_text, $browser_cone_disable)
							For $i = 0 To UBound($b_inputs) - 1
								GUICtrlSetData($b_inputs[$i], $objects[$combo_data][$i + 2])
							Next
							GUICtrlSetData($edit_color[0], $objects[$combo_data][12] / $slider_precision)
							GUICtrlSetData($edit_color[1], $objects[$combo_data][13] / $slider_precision)
							GUICtrlSetData($edit_color[2], $objects[$combo_data][14] / $slider_precision)
						Case "Custom"
							_Custom_Edit($objects[GUICtrlRead($combo)][3])
;~ 							ConsoleWrite($objects[GUICtrlRead($combo)][3] & @CRLF)
;~ 							MsgBox(0,"",$objects[GUICtrlRead($combo)][3])
					EndSwitch
					GUICtrlSetData($edit_angles[0], $objects[$oIndex][9])
					GUICtrlSetData($edit_angles[1], $objects[$oIndex][10])
					GUICtrlSetData($edit_angles[2], $objects[$oIndex][11])
				Case $button_delete
					ObjectDelete($objects[GUICtrlRead($combo)][0])
					ConsoleWrite($objects[GUICtrlRead($combo)][0] & @CRLF)
					$objects[GUICtrlRead($combo)][15] = "Deleted"
					$selected = GUICtrlSendMsg($combo, $CB_GETCURSEL, 0, 0)
;~ 						MsgBox(0,"",$selected)
					GUICtrlSendMsg($combo, $CB_DELETESTRING, $selected, 0)
				Case $button_update
					ObjectDelete($objects[GUICtrlRead($combo)][0])
					$oIndex_1 = GUICtrlRead($combo)
					$object_ = ObjectCreate()
;~ 							GUICtrlSetData($combo, $oIndex)
					ConsoleWrite("+$object_=" & $object_ & @CRLF)
					$objects[$oIndex_1][0] = $object_
					If $objects[$oIndex_1][15] = "Custom" Then
;~ 						Global $b_p[UBound($p)]
						$param_values = ""
						For $i = 1 To UBound($p) - 1
;~ 							$b_p[$i]=$p[$i]
							$param_values = $param_values & GUICtrlRead($p[$i]) & "|"
							$p[$i] = GUICtrlRead($p[$i])
							ConsoleWrite("$p[" & $i & "]=" & $p[$i] & @CRLF)
						Next
						$param_values = StringTrimRight($param_values, 1)
						$objects[$oIndex_1][2] = $param_values
						For $j = $custom[1][1] + 2 To $custom[0][0]
							$execute = Execute($custom[$j][1])
						Next
;~ 						GUICtrlSendMsg($combo,$CB_SETCURSEL,0,0)
					Else
						#cs
							If $custom_current_editing=True Then
							For $i=1 To UBound($b_p)-1
							GUICtrlDelete($b_p[$i])
							Next
							For $m = $b_labels[0] To $edit_angles[2]
							GUICtrlSetState($m, $GUI_SHOW)
							Next
							EndIf
							$custom_current_editing=False
						#ce
						For $i = 0 To UBound($b_inputs) - 1
							$data[$i] = GUICtrlRead($b_inputs[$i])
							$objects[$oIndex_1][$i + 2] = $data[$i]
							ConsoleWrite("$data[$i]=" & $data[$i] & @CRLF)
						Next
						$custom_current_editing = True
;~ 							If $custom_current_editing = fa
						$red = GUICtrlRead($edit_color[0]) * $slider_precision
						$green = GUICtrlRead($edit_color[1]) * $slider_precision
						$blue = GUICtrlRead($edit_color[2]) * $slider_precision
						$x_angle = GUICtrlRead($edit_angles[0])
						$y_angle = GUICtrlRead($edit_angles[1])
						$z_angle = GUICtrlRead($edit_angles[2])
						ConsoleWrite(-$x_angle & @CRLF)
						ConsoleWrite(-$y_angle & @CRLF)
						ConsoleWrite(-$z_angle & @CRLF)
						$objects[$oIndex_1][9] = $x_angle
						$objects[$oIndex_1][10] = $y_angle
						$objects[$oIndex_1][11] = $z_angle
						$objects[$oIndex_1][12] = $red
						$objects[$oIndex_1][13] = $green
						$objects[$oIndex_1][14] = $blue
;~ 					$objects[$oIndex][15] = $add_what
						Switch $objects[GUICtrlRead($combo)][15]
							Case "Cube"
								$last = AddCube($object_, $data[3], $data[4], $data[5], $red, $green, $blue, 1.0) ;$colors[1] & $colors[2],$colors[3] & $colors[4],$colors[5] & $colors[6]
								ShapeTranslate($object_, $last, $data[0], $data[1], $data[2])
							Case "Cylinder"
								$last = AddCylinder($object_, $data[0], $data[1], $data[2], $data[3], $data[3], $data[4], 20, 20, $red, $green, $blue, 1.0)
							Case "Sphere"
								$last = AddSphere($object_, $data[0], $data[1], $data[2], $data[3], 20, 20, $red, $green, $blue, 1.0)
							Case "Cone"
								$last = AddCylinder($object_, $data[0], $data[1], $data[2], $data[3], 0, $data[4], 20, 20, $red, $green, $blue, 1.0)
						EndSwitch
						ObjectScale($object_, $data[6], $data[6], $data[6])
						ObjectRotate($object_, $x_angle, $y_angle, $z_angle)
					EndIf
					SetPrint($object_)
			EndSwitch
		Case $custom_gui
			Switch $msg[0]
				Case -3
					GUIDelete($custom_gui)
					GUISetState(@SW_ENABLE, $main)
					GUISetState(@SW_SHOW, $object_browser)
				Case $ok_custom
					ConsoleWrite("> before" & $oIndex & @CRLF)
;~ 					$oIndex_last = $oIndex
					$oIndex = $oIndex + 1
					$object_ = ObjectCreate()
					$objects[$oIndex][0] = $object_
					$objects[$oIndex][1] = $custom[1][1]
					GUICtrlSetData($combo, $oIndex)
					$objects[$oIndex][15] = "Custom"
					$param_values = ""
					For $l = 1 To $custom[1][1]
						$param_values = $param_values & GUICtrlRead($p[$l]) & "|"
					Next
					$param_values = StringTrimRight($param_values, 1)
					$objects[$oIndex][2] = $param_values
					$objects[$oIndex][3] = $c_path
					For $i = 1 To UBound($p) - 1
						$p[$i] = GUICtrlRead($p[$i])
					Next
;~ 				ConsoleWrite(+$custom[1][1] & @CRLF)
;~ 				ConsoleWrite(+$custom[0][0] & @CRLF)
;~ 				MsgBox(0,"","test")
					For $j = $custom[1][1] + 2 To $custom[0][0]
						$execute = Execute($custom[$j][1])
;~ 					ConsoleWrite( $custom[$j][1] & @CRLF)
						ConsoleWrite(@error & @CRLF)
					Next
					SetPrint($object_)
					GUIDelete($custom_gui)
					GUISetState(@SW_ENABLE, $main)
					GUISetState(@SW_SHOW, $object_browser)
;~ 					$oIndex = $oIndex_last
					ConsoleWrite("> after" & $oIndex & @CRLF)
			EndSwitch
	EndSwitch
WEnd

Func _Box()
;~ 	AddCube($object, 100, 100, 100, 0.9, 0.2, 0.2, 1)
EndFunc   ;==>_Box

Func _Add()
	$add_gui = GUICreate("Add a", 200, 430, Default, Default, Default, $WS_EX_TOOLWINDOW, $main)
	For $i = 0 To UBound($labels) - 1
		$labels[$i] = GUICtrlCreateLabel($labels_text[$i], 10, 32 + $i * 25, 60)
	Next
	For $i = 0 To UBound($inputs) - 1
		$inputs[$i] = GUICtrlCreateInput("", 80, 30 + $i * 25, 100, 20)
	Next
	$create_colors = _ColorGroup()
	$add_angles = _AngleGroup()
	$ok = GUICtrlCreateButton("OK", 80, 400)
;~ 	GUISetState()
EndFunc   ;==>_Add

Func _LabelsSetDefaultText(ByRef $IDs)
	For $i = 0 To UBound($IDs) - 1
		GUICtrlSetState($IDs[$i], $GUI_ENABLE)
		GUICtrlSetData($IDs[$i], $labels_text[$i])
	Next
EndFunc   ;==>_LabelsSetDefaultText

Func _LabelsSetText(ByRef $IDs_array, ByRef $new_text, ByRef $IDs_disable)
	For $i = 0 To UBound($IDs_array) - 1
		GUICtrlSetData($IDs_array[$i], $new_text[$i])
	Next
	For $i = 0 To UBound($IDs_disable) - 1
		GUICtrlSetState($IDs_disable[$i], $GUI_DISABLE)
	Next
EndFunc   ;==>_LabelsSetText

Func _ObjectBrowser()
	Global $object_browser = GUICreate("Object Browser", 200, 430, 320, 10, $WS_CHILD, BitOR($WS_EX_CLIENTEDGE, $WS_EX_TOOLWINDOW), $main)
	Global $combo = GUICtrlCreateCombo("", 10, 10, 100)
	For $i = 0 To UBound($labels) - 1
		$b_labels[$i] = GUICtrlCreateLabel($labels_text[$i], 10, 40 + $i * 25, 60)
	Next
	For $i = 0 To UBound($inputs) - 1
		$b_inputs[$i] = GUICtrlCreateInput("", 80, 38 + $i * 25, 100, 20)
	Next
	$edit_color = _ColorGroup()
	$edit_angles = _AngleGroup()
	$button_delete = GUICtrlCreateButton("Delete", 10, 400)
	$button_update = GUICtrlCreateButton("Update", 50, 400)
	GUISetState()
EndFunc   ;==>_ObjectBrowser

Func _ColorGroup()
	Global $color_sliders[3]
	GUICtrlCreateGroup("Color", 5, 208, 180, 85)
	GUICtrlCreateLabel("Red", 10, 220)
	GUICtrlCreateLabel("Green", 10, 243)
	GUICtrlCreateLabel("Blue", 10, 268)
	$color_sliders[0] = GUICtrlCreateSlider(80, 220, 100)
	$color_sliders[1] = GUICtrlCreateSlider(80, 243, 100)
	$color_sliders[2] = GUICtrlCreateSlider(80, 268, 100)
	For $i = 0 To UBound($color_sliders) - 1
		GUICtrlSetLimit($color_sliders[$i], 100 * $slider_precision, 0)
;~ 		GUICtrlSendMsg($color_sliders[$i],$TBM_SETLINESIZE,0,0.1)
	Next
	Return $color_sliders
EndFunc   ;==>_ColorGroup

Func _ResetValues(ByRef $IDs, $value = Default)
	If IsArray($value) Then
		For $i = 0 To UBound($IDs) - 1
			GUICtrlSetData($IDs[$i], $value[$i])
		Next
	ElseIf $value = Default Then
		For $i = 0 To UBound($IDs) - 1
			GUICtrlSetData($IDs[$i], "")
		Next
	EndIf
EndFunc   ;==>_ResetValues

Func _Enable(ByRef $IDs)
	For $i = 0 To UBound($IDs) - 1
		GUICtrlSetState($IDs[$i], $GUI_ENABLE)
	Next
EndFunc   ;==>_Enable

Func _SaveAs($path)
	For $i = 1 To $oIndex
		MsgBox(0, "", $objects[$i][15])
		Switch $objects[$i][15]
			Case "Deleted"
			Case Else
				$data2 = $objects[$i][2] & "," & $objects[$i][3] & "," & $objects[$i][4] & "," & $objects[$i][5] & "," & $objects[$i][6] & "," & $objects[$i][7] & ","
				$data2 = $data2 & $objects[$i][8] & "," & $objects[$i][9] & "," & $objects[$i][10] & "," & $objects[$i][11] & "," & $objects[$i][12] & "," & $objects[$i][13] & ","
				$data2 = $data2 & $objects[$i][14] & "," & $objects[$i][15]
				IniWrite($path, "Shapes", $i, $data2)
		EndSwitch
	Next
EndFunc   ;==>_SaveAs

Func _AngleGroup()
	Local $angle_sliders[3]
	GUICtrlCreateGroup("Angles", 5, 208 + 85, 180, 85)
	GUICtrlCreateLabel("X", 10, 220 + 85)
	GUICtrlCreateLabel("Y", 10, 243 + 85)
	GUICtrlCreateLabel("Z", 10, 268 + 85)
	$angle_sliders[0] = GUICtrlCreateSlider(80, 220 + 85, 100)
	$angle_sliders[1] = GUICtrlCreateSlider(80, 243 + 85, 100)
	$angle_sliders[2] = GUICtrlCreateSlider(80, 268 + 85, 100)
	For $i = 0 To UBound($angle_sliders) - 1
		GUICtrlSetLimit($angle_sliders[$i], 360, 0)
		GUICtrlSetStyle($angle_sliders[$i], $TBS_NOTICKS)
	Next
	Return $angle_sliders
EndFunc   ;==>_AngleGroup

Func _Open($path)
	$all = IniReadSection($path, "Shapes")
	For $j = 1 To $all[0][0]
		$oIndex = $oIndex + 1
		$object_ = ObjectCreate()
		GUICtrlSetData($combo, $oIndex)
		ConsoleWrite("+$object_=" & $object_ & @CRLF)
		$objects[$oIndex][0] = $object_
		$data_3 = StringSplit($all[$j][1], ",", 2)
;~ 		_ArrayDisplay($data_3)
		If $data_3[13] = "Custom" Then
			Global $custom = IniReadSection($data_3[1], "Shapes")
			$p = StringSplit($data_3[0], "|")
;~ 			_ArrayDisplay($p)
			$objects[$oIndex][1] = $data_3[2]
			For $n = $custom[1][1] + 2 To $custom[0][0]
				ConsoleWrite($custom[$n][1] & @CRLF)
				Execute($custom[$n][1])
				ConsoleWrite("open " & @error & @CRLF)
			Next
			$objects[$oIndex][1]=$p[0]
			$objects[$oIndex][2]=$data_3[0]
			$objects[$oIndex][3]=$data_3[1]
			$objects[$oIndex][15]="Custom"
;~ 			_ArrayDisplay($objects)
;~ 			SetPrint($object_1)
		Else
;~ 		_ArrayDisplay($data_3)
;~ 		MsgBox(0,"",UBound($data_3))

			For $i = 0 To UBound($data_3) - 1
				$objects[$oIndex][$i + 2] = $data_3[$i]
				ConsoleWrite("$data[" & $i & "]=" & $data_3[$i] & @CRLF)
			Next
			Switch $data_3[13]
				Case "Cube"
					$last = AddCube($object_, $data_3[3], $data_3[4], $data_3[5], $data_3[10], $data_3[11], $data_3[12], 1.0) ;$colors[1] & $colors[2],$colors[3] & $colors[4],$colors[5] & $colors[6]
					ShapeTranslate($object_, $last, $data_3[0], $data_3[1], $data_3[2])
				Case "Cylinder"
					$last = AddCylinder($object_, $data_3[0], $data_3[1], $data_3[2], $data_3[3], $data_3[3], $data_3[4], 20, 20, $data_3[10], $data_3[11], $data_3[12], 1.0)
				Case "Sphere"
					$last = AddSphere($object_, $data_3[0], $data_3[1], $data_3[2], $data_3[3], 20, 20, $data_3[10], $data_3[11], $data_3[12], 1.0)
				Case "Cone"
					$last = AddCylinder($object_, $data_3[0], $data_3[1], $data_3[2], $data_3[3], 0, $data_3[4], 20, 20, $data_3[10], $data_3[11], $data_3[12], 1.0)
			EndSwitch
			ObjectScale($object_, $data_3[6], $data_3[6], $data_3[6])
			ObjectRotate($object_, $data_3[7], $data_3[8], $data_3[9])
			$objects[$oIndex][1] = $last
		EndIf
		SetPrint($object_)
	Next
EndFunc   ;==>_Open

Func _Custom($path)
	GUISetState(@SW_DISABLE, $main)
	Global $custom = IniReadSection($path, "Shapes")
	Global $p[$custom[1][1] + 1];, $param_values[$custom[1][1]+1]
	$gui_height = $custom[1][1] * 25 + 20
	$custom_gui = GUICreate("Custom", 300, $gui_height, Default, Default, Default, $WS_EX_TOOLWINDOW, $main)
	For $i = 2 To $custom[1][1] + 1
		$split = StringSplit($custom[$i][1], ",")
		GUICtrlCreateLabel($split[2], 10, ($i - 1) * 22, 85)
		Switch $split[1]
			Case "Input"
				$p[$i - 1] = GUICtrlCreateInput("", 100, ($i - 1) * 23)
;~ 				Assign($custom[$i][0],$last_2)
;~ 				ConsoleWrite("+" & Eval($custom[$i][0]) & @CRLF)
;~ 				MsgBox(0,"",GUICtrlRead($last_2))
		EndSwitch
	Next
	Global $c_path = $path
;~   MsgBox(0,"",$p[$i])
	$ok_custom = GUICtrlCreateButton("OK", 200, $gui_height / 2)
	GUISetState()
EndFunc   ;==>_Custom
#cs
	Func _Custom_Edit($path)
	GUISetState(@SW_HIDE, $object_browser)
	Global $custom = IniReadSection($path, "Shapes")
	$split_1=StringSplit($objects[GUICtrlRead($combo)][2],"|")
	Global $p[$custom[1][1] + 1];, $param_values[$custom[1][1]+1]
	$gui_height = $custom[1][1] * 25 + 20
	$custom_gui = GUICreate("Custom", 250, $gui_height, 320, 10, $WS_CHILD, BitOR($WS_EX_CLIENTEDGE, $WS_EX_TOOLWINDOW), $main)
	For $i = 2 To $custom[1][1] + 1
	$split = StringSplit($custom[$i][1], ",")
	GUICtrlCreateLabel($split[2], 10, ($i - 1) * 22, 85)
	Switch $split[1]
	Case "Input"
	$p[$i - 1] = GUICtrlCreateInput($split_1[$i-1], 100, ($i - 1) * 23)
	EndSwitch
	Next
	$ok_custom = GUICtrlCreateButton("OK", 200, $gui_height / 2)
	;$c_delete=GUICtrlCreateButton("Delete",200,$gui_height/2+30)
	GUISetState(@SW_SHOW, $custom_gui)
	EndFunc   ;==>_Custom_Edit
#ce
Func _Custom_Edit($path)
	GUISwitch($object_browser)
	$custom_current_editing = True
	$last_edited_custom = True
	For $m = $b_labels[0] To $edit_angles[2]
		GUICtrlSetState($m, $GUI_HIDE)
	Next
	Global $custom = IniReadSection($path, "Shapes")
	$split_1 = StringSplit($objects[GUICtrlRead($combo)][2], "|")
;~ 	_ArrayDisplay($split_1)
	Global $p[$custom[1][1] + 1], $b_p[$custom[1][1] + 1], $c_label[$custom[1][1] + 1];, $param_values[$custom[1][1]+1]
	For $i = 2 To $custom[1][1] + 1
		GUISwitch($object_browser)
		$split = StringSplit($custom[$i][1], ",")
		$c_label[$i - 1] = GUICtrlCreateLabel($split[2], 10, 40 + ($i - 1) * 25, 85)
		Switch $split[1]
			Case "Input"
;~ 				ConsoleWrite("$b_p[" & $i-1 & "]=" & $b_p[$i-1] & @CRLF)
				$p[$i - 1] = GUICtrlCreateInput($split_1[$i - 1], 100, 38 + ($i - 1) * 25)
				$b_p[$i - 1] = $p[$i - 1]
		EndSwitch
	Next
EndFunc   ;==>_Custom_Edit