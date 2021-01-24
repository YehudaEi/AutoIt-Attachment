#include <ButtonConstants.au3>
#include <ComboConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <GUIListBox.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#Include <GuiComboBox.au3>
#include <GuiListView.au3>
#Include <array.au3>
#Include <file.au3>

Dim $R_Values[66]
Global $tfound = 0, $tchecked = 0, $Gui_time_comb = 1, $Gui_time_list = 1, $ltimeS

$Form1 = GUICreate("Resistance Calculator", 585, 638, 208, 126)
GUISetBkColor(0xFFFFFF)
;Buttons
$B_Save = GUICtrlCreateButton("Save List", 464, 520, 89, 33, 0)
$B_Target = GUICtrlCreateButton("Calculate", 464, 464, 89, 33, 0)
$B_Qcalc = GUICtrlCreateButton("Calculate", 112, 128, 73, 33, 0)
$B_Colors = GUICtrlCreateButton("Calculate", 408, 184, 81, 33, 0)
;listview
Global $List1 = GUICtrlCreateListView('Resistors                                |Value                                     |% Tolerance', 32, 440, 425, 136)
;User Inputs
$Parallel_Input = GUICtrlCreateInput("", 72, 96, 161, 21)
$Target = GUICtrlCreateInput("", 96, 400, 81, 21)
$Tolerance = GUICtrlCreateInput("1.00", 200, 400, 81, 21)
$nResistors = GUICtrlCreateCombo("2 or 3", 304, 400, 81, 25)
GUICtrlSetData(-1, "2|3")
$Band_1 = GUICtrlCreateCombo("Black", 424, 56, 97, 25)
GUICtrlSetData(-1, "Brown|Red|Orange|Yellow|Green|Blue|Violet|Gray|White")
$Band_2 = GUICtrlCreateCombo("Black", 424, 88, 97, 25)
GUICtrlSetData(-1, "Brown|Red|Orange|Yellow|Green|Blue|Violet|Gray|White")
$Band_3 = GUICtrlCreateCombo("Black", 424, 120, 97, 25)
GUICtrlSetData(-1, "Brown|Red|Orange|Yellow|Green|Blue|Silver|Gold")
$Band_4 = GUICtrlCreateCombo("Gold", 424, 152, 97, 25)
GUICtrlSetData(-1, "Silver")
$Checkbox_allowdup = GUICtrlCreateCheckbox("Allow Duplication of Resistors", 301, 314, 201, 17)
GUICtrlSetFont(-1, 10, 400, 0, "MS Sans Serif")
$Checkbox_series = GUICtrlCreateCheckbox("Series", 48, 312, 65, 17)
GUICtrlSetFont(-1, 10, 400, 0, "MS Sans Serif")
$Checkbox_Parallel = GUICtrlCreateCheckbox("Parallel", 120, 312, 81, 17)
GUICtrlSetFont(-1, 10, 400, 0, "MS Sans Serif")
;GroupBoxes
$Group = GUICtrlCreateGroup("Resistor Connection", 32, 288, 177, 57, $BS_CENTER)
GUICtrlSetBkColor(-1, 0xFFFFE1)
GUICtrlCreateGroup("", -99, -99, 1, 1)
$Group1 = GUICtrlCreateGroup("Settings", 72, 352, 337, 81, $BS_CENTER)
GUICtrlCreateGroup("", -99, -99, 1, 1)
$Group3 = GUICtrlCreateGroup("Quick Calc", 48, 40, 209, 137, $BS_CENTER)
GUICtrlSetFont(-1, 14, 400, 0, "MS Sans Serif")
GUICtrlCreateGroup("", -99, -99, 1, 1)
$Color = GUICtrlCreateGroup("Color Calc", 352, 16, 193, 209, $BS_CENTER)
GUICtrlSetFont(-1, 14, 400, 0, "MS Sans Serif")
GUICtrlCreateGroup("", -99, -99, 1, 1)
$Group2 = GUICtrlCreateGroup("Resistor Combination Calculator ", 16, 245, 553, 369, $BS_CENTER)
GUICtrlSetFont(-1, 18, 400, 0, "MS Sans Serif")
GUICtrlCreateGroup("", -99, -99, 1, 1)
$Group4 = GUICtrlCreateGroup("Options", 288, 288, 217, 57, $BS_CENTER)
GUICtrlSetBkColor(-1, 0xFFFFE1)
GUICtrlCreateGroup("", -99, -99, 1, 1)
;Labels
$Label5 = GUICtrlCreateLabel("Ex:  10, 3.3M, 47K", 104, 72, 88, 17)
$label = GUICtrlCreateLabel("Band 1", 376, 56, 38, 17, $SS_CENTERIMAGE)
$Label7 = GUICtrlCreateLabel("Band 2", 376, 88, 38, 17, $SS_CENTERIMAGE)
$Label8 = GUICtrlCreateLabel("Band 3", 376, 120, 38, 17, $SS_CENTERIMAGE)
$Label9 = GUICtrlCreateLabel("Band 4", 376, 152, 38, 17, $SS_CENTERIMAGE)
$Label3 = GUICtrlCreateLabel("# of Resistors", 304, 376, 85, 20)
GUICtrlSetFont(-1, 10, 400, 0, "MS Sans Serif")
$Label4 = GUICtrlCreateLabel("Combinations Checked = ", 248, 584, 156, 20)
GUICtrlSetFont(-1, 10, 400, 0, "MS Sans Serif")
Global $checked = GUICtrlCreateLabel("0", 400, 584, 60, 20)
GUICtrlSetFont(-1, 10, 400, 0, "MS Sans Serif")
$Label6 = GUICtrlCreateLabel("Combinations Found = ", 32, 584, 140, 20)
GUICtrlSetFont(-1, 10, 400, 0, "MS Sans Serif")
Global $found = GUICtrlCreateLabel("0", 168, 584, 67, 20)
GUICtrlSetFont(-1, 10, 400, 0, "MS Sans Serif")
$Label1 = GUICtrlCreateLabel("Target Value", 96, 376, 82, 20)
GUICtrlSetFont(-1, 10, 400, 0, "MS Sans Serif")
$Label2 = GUICtrlCreateLabel("% Tolerance", 200, 376, 81, 20)
GUICtrlSetFont(-1, 10, 400, 0, "MS Sans Serif")
;Menu items
$MenuItem1 = GUICtrlCreateMenu("&File")
$MenuItem4 = GUICtrlCreateMenuitem("Import Values", $MenuItem1)
$MenuItem7 = GUICtrlCreateMenuitem("Load Default Values", $MenuItem1)
$MenuItem8 = GUICtrlCreateMenuitem("View Loaded Values", $MenuItem1)
$MenuItem3 = GUICtrlCreateMenuitem("Exit", $MenuItem1)
$MenuItem2 = GUICtrlCreateMenu("&Help")
$MenuItem5 = GUICtrlCreateMenuitem("How to Use", $MenuItem2)
$MenuItem6 = GUICtrlCreateMenuitem("About", $MenuItem2)

GUISetState(@SW_SHOW)
GUICtrlSetState($Checkbox_Parallel, $GUI_CHECKED)
GUICtrlSetState($Checkbox_allowdup, $GUI_CHECKED)
GUICtrlSetState($Checkbox_series, $GUI_CHECKED)
_Load_Default_Values($R_Values)

While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $B_Save
			_SaveList($List1)
		Case $MenuItem7
			Dim $R_Values[66]
			_Load_Default_Values($R_Values)
			MsgBox(0, 'Default Values Imported!', UBound($R_Values) & ' Values have been Loaded')
		Case $MenuItem4
			_Import_Values($R_Values)
			MsgBox(0, 'Values Imported!', UBound($R_Values) & ' Values have been Loaded')
		Case $B_Target
			If GUICtrlRead($Target) = '' Then
				MsgBox(0, 'ERROR!', 'No Value Entered')
				ContinueLoop
			EndIf
			$timeS = TimerInit()
			$ltimeS = TimerInit()
			$tfound = 0
			$tchecked = 0
			$Gui_time_comb = 1
			$Gui_time_list = 1
			_GUICtrlListView_DeleteAllItems ($List1)
			GUICtrlSetData($found, $tfound)
			GUICtrlSetData($checked, $tchecked)
			$vtarget  = GUICtrlRead($Target)
			_Format_View2Value($vtarget)
			Select
				Case BitAND(GUICtrlRead($Checkbox_allowdup) = 1, _GUICtrlComboBox_GetCurSel ($nResistors) = 0)
					_Combo($R_Values, $vtarget, GUICtrlRead($Tolerance), GUICtrlRead($Checkbox_series), GUICtrlRead($Checkbox_Parallel), 2)
					_2Combo_dup($R_Values, $vtarget, GUICtrlRead($Tolerance), GUICtrlRead($Checkbox_series), GUICtrlRead($Checkbox_Parallel))
					_3Combo_Dups($R_Values, $vtarget, GUICtrlRead($Tolerance), GUICtrlRead($Checkbox_series), GUICtrlRead($Checkbox_Parallel))
				Case BitAND(GUICtrlRead($Checkbox_allowdup) = 4, _GUICtrlComboBox_GetCurSel ($nResistors) = 0)
					_Combo($R_Values, $vtarget, GUICtrlRead($Tolerance), GUICtrlRead($Checkbox_series), GUICtrlRead($Checkbox_Parallel), 2)
					_Combo($R_Values, $vtarget, GUICtrlRead($Tolerance), GUICtrlRead($Checkbox_series), GUICtrlRead($Checkbox_Parallel), 3)
				Case BitAND(GUICtrlRead($Checkbox_allowdup) = 1, _GUICtrlComboBox_GetCurSel ($nResistors) = 1)
					_Combo($R_Values, $vtarget, GUICtrlRead($Tolerance), GUICtrlRead($Checkbox_series), GUICtrlRead($Checkbox_Parallel), 2)
					_2Combo_dup($R_Values, $vtarget, GUICtrlRead($Tolerance), GUICtrlRead($Checkbox_series), GUICtrlRead($Checkbox_Parallel))
				Case BitAND(GUICtrlRead($Checkbox_allowdup) = 4, _GUICtrlComboBox_GetCurSel ($nResistors) = 1)
					_Combo($R_Values, $vtarget, GUICtrlRead($Tolerance), GUICtrlRead($Checkbox_series), GUICtrlRead($Checkbox_Parallel), 2)
				Case BitAND(GUICtrlRead($Checkbox_allowdup) = 1, _GUICtrlComboBox_GetCurSel ($nResistors) = 2)
					_3Combo_Dups($R_Values, $vtarget, GUICtrlRead($Tolerance), GUICtrlRead($Checkbox_series), GUICtrlRead($Checkbox_Parallel))
				Case BitAND(GUICtrlRead($Checkbox_allowdup) = 4, _GUICtrlComboBox_GetCurSel ($nResistors) = 2)
					_Combo($R_Values, $vtarget, GUICtrlRead($Tolerance), GUICtrlRead($Checkbox_series), GUICtrlRead($Checkbox_Parallel), 3)
			EndSelect
			Global $B_DESCENDING[_GUICtrlListView_GetColumnCount ($List1) ]
			_GUICtrlListView_SimpleSort ($List1, $B_DESCENDING, 2)
			$dif = TimerDiff($timeS)
			MsgBox(0, 'Finished!', 'Search Took ' & Round($dif / 1000, 2) & ' Seconds')
			If _GUICtrlListView_GetItemCount ($List1) = 0 Then MsgBox(0, 'No Matches', 'You had 0 matches so you should increase the tolerance.' & @LF & _
					'Remember for low Values you can increase the tolerance pretty high without changing value much.')
		Case $B_Colors
			Dim $colors[4]
			$colors[0] = _GUICtrlComboBox_GetCurSel ($Band_1)
			$colors[1] = _GUICtrlComboBox_GetCurSel ($Band_2)
			$colors[2] = _GUICtrlComboBox_GetCurSel ($Band_3)
			$colors[3] = _GUICtrlComboBox_GetCurSel ($Band_4)
			$resistor_Color_Value = _Color_Value($colors)
			If $colors[3] = 0 Then MsgBox(0, '', $resistor_Color_Value & ' Ohms  +/- 5%')
			If $colors[3] = 1 Then MsgBox(0, '', $resistor_Color_Value & ' Ohms  +/- 10%')
		Case $B_Qcalc
			$F_Value = _Stringformat(GUICtrlRead($Parallel_Input), 1)
			$RP_String = _Parallel_Value($F_Value)
			$RS_String = _Series_Value($F_Value)
			MsgBox(0, 'Resistance Value', 'Parallel Value = ' & $RP_String & ' Ohms' & @LF & _
					'Series Value = ' & $RS_String & ' Ohms')
		Case $GUI_EVENT_CLOSE
			Exit
		Case $MenuItem3
			Exit
		Case $MenuItem6
			MsgBox(0, 'About', 'Resistance Calculator' & @LF & 'Version 1.0' & @LF & 'Writen by Brian J Christy')
		Case $MenuItem5
			MsgBox(0, 'How to Use', "All values entered can be abbreviated with a K for thousand or M for Million." & @LF & _
		"For imported values the same rule applies.  Also the file you import" & @LF & "can only have one value per line and must be a .txt file." & @LF & @LF & _
		"Default Values are preloaded startup. These Values include all values found in " & @LF & _
		"RadioShacks Assortment Pack." & @LF & @LF & "A Comma is the character used to seperate values in the Quick calc and you can" & @LF & _
		"enter as many values as you want. The Calc will return both series and parallel values." & @LF & @LF & "For all drop-down combo boxes it is important to only select values in the" & _
		" list. Don't" & @LF & "try typing in values yourself. This will return incorrect answers.")
		Case $MenuItem8
			Dim $Atemp
			$Atemp = $R_Values
			For $i = 0 To UBound($Atemp) - 1
				_Format_Value2View($Atemp[$i])
			Next
			_ArrayDisplay($Atemp, 'Loaded Values')
	EndSwitch
WEnd

Func _Combo(ByRef $avArray, $Target, $Tolerance, $series, $parallel, $iSet, $sDelim = ",")
	Local $i, $aIdx[1], $Resistor_Set, $iN = 0, $iR = 0, $iLeft = 0, $iTotal = 0
	Local $sParallelV, $sSeriesV, $high, $low, $Resistor_Set
	$high = $Target+ ($Target* ($Tolerance / 100))
	$low = $Target- ($Target* ($Tolerance / 100))
	$iN = UBound($avArray)
	$iR = $iSet
	Dim $aIdx[$iR]
	For $i = 0 To $iR - 1
		$aIdx[$i] = $i
	Next
	$iTotal = New_Array_Combinations($iN, $iR)
	$iLeft = $iTotal
	
	While $iLeft > 0
		_Array_GetNext ($iN, $iR, $iLeft, $iTotal, $aIdx)
		For $i = 0 To $iSet - 1
			$Resistor_Set &= $avArray[$aIdx[$i]] & $sDelim
		Next
		If $sDelim <> "" Then $Resistor_Set = StringTrimRight($Resistor_Set, 1)
		If $parallel = 1 Then
			$sParallelV = _Parallel_Value($Resistor_Set)
			_Tolerance_Check($sParallelV, $Target, $high, $low, 'P', $Resistor_Set)
		EndIf
		If $series = 1 Then
			$sSeriesV = _Series_Value($Resistor_Set)
			_Tolerance_Check($sSeriesV, $Target, $high, $low, 'S', $Resistor_Set)
		EndIf
		$Resistor_Set = ''
	WEnd
	GUICtrlSetData($checked, $tchecked)
EndFunc   ;==>_Combo

Func _2Combo_dup($array, $Target, $Tolerance, $series, $parallel)
	Local $sParallelV, $sSeriesV, $high, $low, $Resistor_Set
	$high = $Target+ ($Target* ($Tolerance / 100))
	$low = $Target- ($Target* ($Tolerance / 100))
	For $i = 0 To UBound($array) - 1
		$Resistor_Set = $array[$i] & ',' & $array[$i]
		If $parallel = 1 Then
			$sParallelV = _Parallel_Value($Resistor_Set)
			_Tolerance_Check($sParallelV, $Target, $high, $low, 'P', $Resistor_Set)
		EndIf
		If $series = 1 Then
			$sSeriesV = _Series_Value($Resistor_Set)
			_Tolerance_Check($sSeriesV, $Target, $high, $low, 'S', $Resistor_Set)
		EndIf
	Next
	GUICtrlSetData($checked, $tchecked)
EndFunc   ;==>_2Combo_dup

Func _3Combo_Dups($array, $Target, $Tolerance, $series, $parallel)
	Local $min = 0, $mid = 0, $max = 0, $list[1]
	Local $sParallelV, $sSeriesV, $high, $low, $Resistor_Set
	$high = $Target+ ($Target* ($Tolerance / 100))
	$low = $Target- ($Target* ($Tolerance / 100))
	Do
		$Resistor_Set = $array[$min] & ',' & $array[$mid] & ',' & $array[$max]
		If $parallel = 1 Then
			$sParallelV = _Parallel_Value($Resistor_Set)
			_Tolerance_Check($sParallelV, $Target, $high, $low, 'P', $Resistor_Set)
		EndIf
		If $series = 1 Then
			$sSeriesV = _Series_Value($Resistor_Set)
			_Tolerance_Check($sSeriesV, $Target, $high, $low, 'S', $Resistor_Set)
		EndIf
		$max += 1
		If $max = UBound($array) Then
			$mid += 1
			$max = $mid
		EndIf
		If $mid = UBound($array) Then
			$min += 1
			$mid = $min
			$max = $mid
		EndIf
	Until BitAND($min = UBound($array), $mid = UBound($array), $max = UBound($array))
	GUICtrlSetData($checked, $tchecked)
EndFunc   ;==>_3Combo_Dups

Func _Tolerance_Check($value, $Target, $high, $low, $connection, $Resistor_Set)
	If BitAND(($value <= $high) , ($value >= $low)) Then
		Select
			Case $value > $Target
				$vTolerance = Round((($value - $Target) / $Target) * 100, 4)
			Case $value < $Target
				$vTolerance = Round((($Target - $value) / $Target) * 100, 4)
			Case $value = $Target
				$vTolerance = 0
		EndSelect
		$format_set = _Stringformat($Resistor_Set, 0)
		;MsgBox(0,'',$format_set)
		GUICtrlCreateListViewItem($connection & ' - ' & $format_set & '|' & $value & '|' & $vTolerance, $List1)
		$tfound += 1
		GUICtrlSetData($found, $tfound)
		If BitAND(TimerDiff($ltimeS) > $Gui_time_list, $tfound < 50) Then
			Global $B_DESCENDING[_GUICtrlListView_GetColumnCount ($List1) ]
			_GUICtrlListView_SimpleSort ($List1, $B_DESCENDING, 2)
			$Gui_time_list += 1000
		EndIf
	EndIf
	$tchecked += 1
	If TimerDiff($ltimeS) > $Gui_time_comb Then
		GUICtrlSetData($checked, $tchecked)
		$Gui_time_comb += 200
	EndIf
EndFunc   ;==>_Tolerance_Check

Func _SaveList(ByRef $list)
	Local $count, $iArray, $tArray[1], $tString, $location
	$count = _GUICtrlListView_GetItemCount ($list)
	If $count = 0 Then
		MsgBox(0, 'ERROR', 'You have no values in your list!')
		Return
	EndIf
	For $i = 0 To $count - 1
		$iArray = _GUICtrlListView_GetItemTextArray ($list, $i)
		$tString = 'Resistor = ' & $iArray[1] & ' --- Value = ' & $iArray[2] & ' --- Tolerance = ' & $iArray[3] & '%'
		_ArrayAdd($tArray, $tString)
	Next
	$location = FileSaveDialog( "Choose a Filename and Location.", @ScriptDir, "Text files (*.txt)", 2)
	If StringRight($location, 4) <> '.txt' Then $location &= '.txt'
	_FileWriteFromArray($location, $tArray, 0)
EndFunc   ;==>_SaveList

Func _Color_Value($color_Array)
	Local $value
	Select
		Case $color_Array[2] = 0
			$value = ($color_Array[0] & $color_Array[1])
		Case $color_Array[2] = 1
			$value = ($color_Array[0] & $color_Array[1]) * 10
		Case $color_Array[2] = 2
			$value = ($color_Array[0] & $color_Array[1]) * 100
		Case $color_Array[2] = 3
			$value = ($color_Array[0] & $color_Array[1]) * 1000
		Case $color_Array[2] = 4
			$value = ($color_Array[0] & $color_Array[1]) * 10000
		Case $color_Array[2] = 5
			$value = ($color_Array[0] & $color_Array[1]) * 100000
		Case $color_Array[2] = 6
			$value = ($color_Array[0] & $color_Array[1]) * 1000000
		Case $color_Array[2] = 7
			$value = ($color_Array[0] & $color_Array[1]) / 100
		Case $color_Array[2] = 8
			$value = ($color_Array[0] & $color_Array[1]) / 10
	EndSelect
	If StringLeft($value, 1) = 0 Then $value = StringTrimLeft($value, 1)
	Return $value
EndFunc   ;==>_Color_Value

Func _Series_Value($Resistors)
	Local $string, $array
	$Resistors = StringReplace($Resistors, ' ', '')
	$array = StringSplit($Resistors, ',')
	For $i = 1 To $array[0]
		$string += $array[$i]
	Next
	Return $string
EndFunc   ;==>_Series_Value

Func _Parallel_Value($Resistors)
	Local $string, $test1, $test2
	$Resistors = StringReplace($Resistors, ' ', '')
	$array = StringSplit($Resistors, ',')
	For $i = 1 To $array[0]
		$string += (1 / $array[$i])
		If $i = $array[0] Then $string = 1 / $string
	Next
	If $string < 5 Then
		$string = Round($string, 4)
	Else
		$string = Round($string, 2)
	EndIf
	Return $string
EndFunc   ;==>_Parallel_Value

Func _Import_Values(ByRef $array)
	Local $R_V_Check
	$file = FileOpenDialog("Select File to Import", @ScriptDir & "\", "Text files (*.txt)", 1)
	If $file = '' Then Return
	_FileReadToArray($file, $R_V_Check)
	_ArrayDelete($R_V_Check, 0)
	_ArrayDeleteBlanks($R_V_Check)
	For $i = 0 To UBound($R_V_Check) - 1
		$R_V_Check[$i] = _Format_View2Value($R_V_Check[$i])
	Next
	$array = $R_V_Check
EndFunc   ;==>_Import_Values

Func _Format_View2Value(ByRef $value)
	If StringInStr($value, 'k') <> 0 Then
		$value = StringReplace($value, 'k', '')
		$value *= 1000
	EndIf
	If StringInStr($value, 'm') <> 0 Then
		$value = StringReplace($value, 'm', '')
		$value *= 1000000
	EndIf
	Return $value
EndFunc   ;==>_Format_View2Value

Func _Format_Value2View(ByRef $value)
	Local $count
	$count = StringLen($value)
	If $count > 6 Then
		$value = ($value / 1000000) & 'M'
		Return
	EndIf
	If $count > 3 Then $value = ($value / 1000) & 'K'
EndFunc   ;==>_Format_Value2View

Func _Stringformat($string, $type)
	Local $Atemp, $newString
	$string = StringReplace($string, ' ', '')
	$Atemp = StringSplit($string, ',')
	If $type = 0 Then
		For $i = 1 To $Atemp[0]
			_Format_Value2View($Atemp[$i])
			$newString &= $Atemp[$i] & ','
		Next
		$newString = StringTrimRight($newString, 1)
		Return $newString
	EndIf
	If $type = 1 Then
		For $i = 1 To $Atemp[0]
			_Format_View2Value($Atemp[$i])
			$newString &= $Atemp[$i] & ','
		Next
		$newString = StringTrimRight($newString, 1)
		Return $newString
	EndIf
EndFunc   ;==>_Stringformat

Func _Load_Default_Values(ByRef $Default_Values)
	$Default_Values[1] = 1
	$Default_Values[2] = 2.2
	$Default_Values[3] = 10
	$Default_Values[4] = 15
	$Default_Values[5] = 22
	$Default_Values[6] = 33
	$Default_Values[7] = 39
	$Default_Values[8] = 47
	$Default_Values[9] = 51
	$Default_Values[10] = 68
	$Default_Values[11] = 82
	$Default_Values[12] = 100
	$Default_Values[13] = 120
	$Default_Values[14] = 150
	$Default_Values[15] = 180
	$Default_Values[16] = 220
	$Default_Values[17] = 270
	$Default_Values[18] = 300
	$Default_Values[19] = 330
	$Default_Values[20] = 390
	$Default_Values[21] = 470
	$Default_Values[22] = 510
	$Default_Values[23] = 560
	$Default_Values[24] = 680
	$Default_Values[25] = 820
	$Default_Values[26] = 1000
	$Default_Values[27] = 1200
	$Default_Values[28] = 1500
	$Default_Values[29] = 1800
	$Default_Values[30] = 2200
	$Default_Values[31] = 2700
	$Default_Values[32] = 3000
	$Default_Values[33] = 3300
	$Default_Values[34] = 3900
	$Default_Values[35] = 4700
	$Default_Values[36] = 5100
	$Default_Values[37] = 5600
	$Default_Values[38] = 6800
	$Default_Values[39] = 8200
	$Default_Values[40] = 10000
	$Default_Values[41] = 12000
	$Default_Values[42] = 15000
	$Default_Values[43] = 18000
	$Default_Values[44] = 22000
	$Default_Values[45] = 27000
	$Default_Values[46] = 33000
	$Default_Values[47] = 39000
	$Default_Values[48] = 47000
	$Default_Values[49] = 51000
	$Default_Values[50] = 56000
	$Default_Values[51] = 68000
	$Default_Values[52] = 82000
	$Default_Values[53] = 100000
	$Default_Values[54] = 120000
	$Default_Values[55] = 150000
	$Default_Values[56] = 180000
	$Default_Values[57] = 220000
	$Default_Values[58] = 270000
	$Default_Values[59] = 330000
	$Default_Values[60] = 1000000
	$Default_Values[61] = 1500000
	$Default_Values[62] = 2200000
	$Default_Values[63] = 3300000
	$Default_Values[64] = 4700000
	$Default_Values[65] = 10000000
	_ArrayDelete($Default_Values, 0)
EndFunc   ;==>_Load_Default_Values

Func _ArrayDeleteBlanks(ByRef $array)
	$i = 0
	Do
		If $array[$i] = '' Then
			_ArrayDelete($array, $i)
			$i -= 1
		EndIf
		$i += 1
	Until $i = UBound($array)
EndFunc   ;==>_ArrayDeleteBlanks

Func New_Array_Combinations($n, $r)
	Local $total = 1
	For $i = $r To 1 Step - 1
		$total *= ($n / $i)
		$n -= 1
	Next
	Return $total
EndFunc   ;==>New_Array_Combinations
