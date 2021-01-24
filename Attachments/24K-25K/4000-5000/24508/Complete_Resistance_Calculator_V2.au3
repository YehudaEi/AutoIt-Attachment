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
#include <Date.au3>

Dim $R_Values
Global $tfound = 0, $tchecked = 0, $Gui_time_comb = 1, $Gui_time_list = 1, $ltimeS, $current_series
$Form1 = GUICreate("Resistance Calculator", 629, 657)
GUISetBkColor(0xFFFFFF)
$B_Target = GUICtrlCreateButton("Calculate", 488, 472, 89, 33, 0)
$Target = GUICtrlCreateInput("", 80, 408, 81, 21)
$Tolerance = GUICtrlCreateInput("1.00", 184, 408, 81, 21)
$Label1 = GUICtrlCreateLabel("Target Value", 80, 384, 82, 20)
GUICtrlSetFont(-1, 10, 400, 0, "MS Sans Serif")
$Label2 = GUICtrlCreateLabel("% Tolerance", 184, 384, 81, 20)
GUICtrlSetFont(-1, 10, 400, 0, "MS Sans Serif")
$nResistors = GUICtrlCreateCombo("2", 288, 408, 81, 25)
GUICtrlSetData(-1, "3|4|5")
$Label3 = GUICtrlCreateLabel("# of Resistors", 288, 384, 85, 20)
GUICtrlSetFont(-1, 10, 400, 0, "MS Sans Serif")
$Label4 = GUICtrlCreateLabel("Combinations Checked = ", 272, 592, 156, 20)
GUICtrlSetFont(-1, 10, 400, 0, "MS Sans Serif")
$checked = GUICtrlCreateLabel("0", 427, 592, 200, 20)
GUICtrlSetFont(-1, 10, 400, 0, "MS Sans Serif")
$Label6 = GUICtrlCreateLabel("Combinations Found = ", 56, 592, 140, 20)
GUICtrlSetFont(-1, 10, 400, 0, "MS Sans Serif")
$found = GUICtrlCreateLabel("0", 197, 592, 67, 20)
GUICtrlSetFont(-1, 10, 400, 0, "MS Sans Serif")
Global $List1 = GUICtrlCreateListView('Resistors|Value|% Tolerance', 56, 448, 425, 136)
_GUICtrlListView_SetColumnWidth ($List1, 0, 190)
_GUICtrlListView_SetColumnWidth ($List1, 1, 100)
_GUICtrlListView_SetColumnWidth ($List1, 2, 130)
$Checkbox_series = GUICtrlCreateCheckbox("Series", 112, 320, 65, 17)
GUICtrlSetFont(-1, 10, 400, 0, "MS Sans Serif")
$Checkbox_Parallel = GUICtrlCreateCheckbox("Parallel", 184, 320, 81, 17)
GUICtrlSetFont(-1, 10, 400, 0, "MS Sans Serif")
$Group = GUICtrlCreateGroup("Resistor Connection", 96, 296, 177, 57, $BS_CENTER)
GUICtrlSetBkColor(-1, 0xFFFFE1)
GUICtrlCreateGroup("", -99, -99, 1, 1)
$B_Save = GUICtrlCreateButton("Save List", 488, 528, 89, 33, 0)
$Group1 = GUICtrlCreateGroup("Settings", 56, 360, 337, 81, $BS_CENTER)
GUICtrlCreateGroup("", -99, -99, 1, 1)
$Qcalc_Input = GUICtrlCreateInput("", 32, 112, 161, 21)
$Label5 = GUICtrlCreateLabel("Ex: 10k, 68, 3.3M", 64, 88, 88, 17)
$B_Qcalc = GUICtrlCreateButton("Calculate", 72, 144, 73, 33, 0)
$Group3 = GUICtrlCreateGroup("Quick Calc", 8, 56, 209, 137, $BS_CENTER)
GUICtrlSetFont(-1, 14, 400, 0, "MS Sans Serif")
GUICtrlCreateGroup("", -99, -99, 1, 1)
$Band_1_4 = GUICtrlCreateCombo("Black", 296, 56, 97, 25, $CBS_DROPDOWNLIST)
GUICtrlSetData(-1, "Brown|Red|Orange|Yellow|Green|Blue|Violet|Gray|white")
$label = GUICtrlCreateLabel("Band 1", 248, 56, 38, 17, $SS_CENTERIMAGE)
$Band_2_4 = GUICtrlCreateCombo("Black", 296, 88, 97, 25, $CBS_DROPDOWNLIST)
GUICtrlSetData(-1, "Brown|Red|Orange|Yellow|Green|Blue|Violet|Gray|white")
$Label7 = GUICtrlCreateLabel("Band 2", 248, 88, 38, 17, $SS_CENTERIMAGE)
$Band_3_4 = GUICtrlCreateCombo("Black", 296, 120, 97, 25, $CBS_DROPDOWNLIST)
GUICtrlSetData(-1, "Brown|Red|Orange|Yellow|Green|Blue|Violet|Gray|White|Gold|Silver")
$Label8 = GUICtrlCreateLabel("Band 3", 248, 120, 38, 17, $SS_CENTERIMAGE)
$Band_4_4 = GUICtrlCreateCombo("Gold", 296, 152, 97, 25, $CBS_DROPDOWNLIST)
GUICtrlSetData(-1, "Silver|Brown|Red|Green|Blue|Violet|Gray|None")
$Label9 = GUICtrlCreateLabel("Band 4", 248, 152, 38, 17, $SS_CENTERIMAGE)
$B_Colors4 = GUICtrlCreateButton("Calculate", 280, 184, 81, 33, 0)
$Color = GUICtrlCreateGroup("4 Band Calc", 224, 16, 193, 209, $BS_CENTER)
GUICtrlSetFont(-1, 14, 400, 0, "MS Sans Serif")
GUICtrlCreateGroup("", -99, -99, 1, 1)
$Group2 = GUICtrlCreateGroup("Resistor Combination Calculator ", 40, 253, 553, 369, $BS_CENTER)
GUICtrlSetFont(-1, 18, 400, 0, "MS Sans Serif")
GUICtrlCreateGroup("", -99, -99, 1, 1)
$Checkbox_allowdup = GUICtrlCreateCheckbox("Allow Duplication of Resistors", 309, 322, 201, 17)
GUICtrlSetFont(-1, 10, 400, 0, "MS Sans Serif")
$Group4 = GUICtrlCreateGroup("Options", 296, 296, 217, 57, $BS_CENTER)
GUICtrlSetBkColor(-1, 0xFFFFE1)
GUICtrlCreateGroup("", -99, -99, 1, 1)
$Group5 = GUICtrlCreateGroup("5 Band Calc", 424, 0, 193, 241, $BS_CENTER)
GUICtrlSetFont(-1, 14, 400, 0, "MS Sans Serif")
GUICtrlCreateGroup("", -99, -99, 1, 1)
$Band_1_5 = GUICtrlCreateCombo("Black", 496, 40, 97, 25, $CBS_DROPDOWNLIST)
GUICtrlSetData(-1, "Brown|Red|Orange|Yellow|Green|Blue|Violet|Gray|White")
$Label10 = GUICtrlCreateLabel("Band 1", 448, 40, 38, 17, $SS_CENTERIMAGE)
$Band_2_5 = GUICtrlCreateCombo("Black", 496, 72, 97, 25, $CBS_DROPDOWNLIST)
GUICtrlSetData(-1, "Brown|Red|Orange|Yellow|Green|Blue|Violet|Gray|White")
$Label11 = GUICtrlCreateLabel("Band 2", 448, 72, 38, 17, $SS_CENTERIMAGE)
$Band_3_5 = GUICtrlCreateCombo("Black", 496, 104, 97, 25, $CBS_DROPDOWNLIST)
GUICtrlSetData(-1, "Brown|Red|Orange|Yellow|Green|Blue|Violet|Gray|White")
$Label12 = GUICtrlCreateLabel("Band 3", 448, 104, 38, 17, $SS_CENTERIMAGE)
$Band_4_5 = GUICtrlCreateCombo("Black", 496, 136, 97, 25, $CBS_DROPDOWNLIST)
GUICtrlSetData(-1, "Brown|Red|Orange|Yellow|Green|Blue|Violet|Gray|White|Gold|Silver")
$Label13 = GUICtrlCreateLabel("Band 4", 448, 136, 38, 17, $SS_CENTERIMAGE)
$B_Colors5 = GUICtrlCreateButton("Calculate", 480, 200, 81, 33, 0)
$Band_5_5 = GUICtrlCreateCombo("Gold", 496, 168, 97, 25)
GUICtrlSetData(-1, "Silver|Brown|Red|Green|Blue|Violet|Gray|None")
$Label14 = GUICtrlCreateLabel("Band 5", 448, 168, 38, 17, $SS_CENTERIMAGE)
Global $Range_Start = GUICtrlCreateInput("", 416, 408, 49, 21)
$Range_End = GUICtrlCreateInput("", 480, 408, 49, 21)
$Label15 = GUICtrlCreateLabel("Start", 426, 384, 31, 20)
GUICtrlSetFont(-1, 10, 400, 0, "MS Sans Serif")
$Label16 = GUICtrlCreateLabel("End", 491, 384, 28, 20)
GUICtrlSetFont(-1, 10, 400, 0, "MS Sans Serif")
$Group6 = GUICtrlCreateGroup("Range", 400, 360, 145, 81, $BS_CENTER)
GUICtrlCreateGroup("", -99, -99, 1, 1)
$MenuItem1 = GUICtrlCreateMenu("&File")
$MenuItem8 = GUICtrlCreateMenuitem("View Loaded Values", $MenuItem1)
$Auto_Range = GUICtrlCreateMenuitem("Auto Range", $MenuItem1)
GUICtrlSetState(-1, $GUI_CHECKED)
$MenuItem3 = GUICtrlCreateMenuitem("Exit", $MenuItem1)
$MenuItem9 = GUICtrlCreateMenu("&Load")
$MenuItem10 = GUICtrlCreateMenuitem("E6 Series", $MenuItem9)
$MenuItem11 = GUICtrlCreateMenuitem("E12 Series", $MenuItem9)
$MenuItem12 = GUICtrlCreateMenuitem("E24 Series", $MenuItem9)
$MenuItem13 = GUICtrlCreateMenuitem("E48 Series", $MenuItem9)
$MenuItem14 = GUICtrlCreateMenuitem("E96 Series", $MenuItem9)
$MenuItem7 = GUICtrlCreateMenuitem("Default Values", $MenuItem9)
$MenuItem4 = GUICtrlCreateMenuitem("Import Custom Values", $MenuItem9)
$MenuItem2 = GUICtrlCreateMenu("&Help")
$MenuItem5 = GUICtrlCreateMenuitem("How to Use", $MenuItem2)
$MenuItem6 = GUICtrlCreateMenuitem("About", $MenuItem2)
GUISetState(@SW_SHOW)
GUICtrlSetState($Checkbox_Parallel, $GUI_CHECKED)
GUICtrlSetState($Checkbox_allowdup, $GUI_CHECKED)
GUICtrlSetState($Checkbox_series, $GUI_CHECKED)
_Load_Default_Values($R_Values)
$current_series = 'Default Values'

While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $Auto_Range
			If BitAND(GUICtrlRead($Auto_Range), $GUI_CHECKED) = $GUI_CHECKED Then
				GUICtrlSetState($Auto_Range, $GUI_UNCHECKED)
				GUICtrlSetData($Range_Start, '')
				GUICtrlSetData($Range_End, '')
			Else
				GUICtrlSetState($Auto_Range, $GUI_CHECKED)
				GUICtrlSetData($Range_End, '')
				GUICtrlSetData($Range_Start, '')
			EndIf
		Case $B_Save
			_SaveList($List1)
		Case $MenuItem7
			Dim $R_Values[66]
			_Load_Default_Values($R_Values)
			$current_series = 'Default Values'
			MsgBox(0, 'Default Values Loaded!', UBound($R_Values) & ' Values have been Loaded')
		Case $MenuItem4
			Dim $R_Values_Temp
			_Import_Custom_Values($R_Values_Temp)
			If IsArray($R_Values_Temp) = 1 Then
				$R_Values = $R_Values_Temp
				MsgBox(0, 'Custom Values Imported!', UBound($R_Values) & ' Values have been Loaded')
			Else
				ContinueLoop
			EndIf
		Case $B_Target
			If GUICtrlRead($Target) = '' Then
				MsgBox(0, 'ERROR!', 'No Value Entered')
				ContinueLoop
			EndIf
			If BitAND(GUICtrlRead($Checkbox_Parallel) = $GUI_UNCHECKED, GUICtrlRead($Checkbox_series) = $GUI_UNCHECKED) Then
				MsgBox(0, 'ERROR!', 'You must select at least one type of connection')
				ContinueLoop
			EndIf
			$vtarget = GUICtrlRead($Target)
			_Format_View2Value($vtarget)
			Dim $hour, $mins, $secs, $time
			$timeS = TimerInit()
			$ltimeS = TimerInit()
			$tfound = 0
			$tchecked = 0
			$Gui_time_comb = 1
			$Gui_time_list = 1
			_GUICtrlListView_DeleteAllItems ($List1)
			GUICtrlSetData($found, $tfound)
			GUICtrlSetData($checked, $tchecked)
			;_Calc_Total(GUICtrlRead($Checkbox_series),GUICtrlRead($Checkbox_Parallel),$vtarget, $R_Values, GUICtrlRead($nResistors))
			Select
				Case BitAND(GUICtrlRead($Checkbox_Parallel) = $GUI_CHECKED, GUICtrlRead($Checkbox_series) = $GUI_CHECKED, BitAND(GUICtrlRead($Auto_Range), $GUI_CHECKED) = $GUI_CHECKED)
					If GUICtrlRead($Checkbox_allowdup) = $GUI_CHECKED Then
						_AutoRange('Parallel', $vtarget, $R_Values)
						$Range_Rvalues = _Create_Range($R_Values, GUICtrlRead($Range_Start), GUICtrlRead($Range_End))
						_Combo_Dups($Range_Rvalues, $vtarget, GUICtrlRead($Tolerance), $GUI_UNCHECKED, $GUI_CHECKED, GUICtrlRead($nResistors))
						_AutoRange('Series', $vtarget, $R_Values)
						$Range_Rvalues = _Create_Range($R_Values, GUICtrlRead($Range_Start), GUICtrlRead($Range_End))
						_Combo_Dups($Range_Rvalues, $vtarget, GUICtrlRead($Tolerance), $GUI_CHECKED, $GUI_UNCHECKED, GUICtrlRead($nResistors))
					EndIf
					If GUICtrlRead($Checkbox_allowdup) = $GUI_UNCHECKED Then
						_AutoRange('Parallel', $vtarget, $R_Values)
						$Range_Rvalues = _Create_Range($R_Values, GUICtrlRead($Range_Start), GUICtrlRead($Range_End))
						_Combo($Range_Rvalues, $vtarget, GUICtrlRead($Tolerance), $GUI_UNCHECKED, $GUI_CHECKED, GUICtrlRead($nResistors))
						_AutoRange('Series', $vtarget, $R_Values)
						$Range_Rvalues = _Create_Range($R_Values, GUICtrlRead($Range_Start), GUICtrlRead($Range_End))
						_Combo($Range_Rvalues, $vtarget, GUICtrlRead($Tolerance), $GUI_CHECKED, $GUI_UNCHECKED, GUICtrlRead($nResistors))
					EndIf
				Case BitAND(GUICtrlRead($Checkbox_Parallel) = $GUI_CHECKED, GUICtrlRead($Checkbox_series) = $GUI_UNCHECKED, BitAND(GUICtrlRead($Auto_Range), $GUI_CHECKED) = $GUI_CHECKED)
					If GUICtrlRead($Checkbox_allowdup) = $GUI_CHECKED Then
						_AutoRange('Parallel', $vtarget, $R_Values)
						$Range_Rvalues = _Create_Range($R_Values, GUICtrlRead($Range_Start), GUICtrlRead($Range_End))
						_Combo_Dups($Range_Rvalues, $vtarget, GUICtrlRead($Tolerance), $GUI_UNCHECKED, $GUI_CHECKED, GUICtrlRead($nResistors))
					EndIf
					If GUICtrlRead($Checkbox_allowdup) = $GUI_UNCHECKED Then
						_AutoRange('Parallel', $vtarget, $R_Values)
						$Range_Rvalues = _Create_Range($R_Values, GUICtrlRead($Range_Start), GUICtrlRead($Range_End))
						_Combo($Range_Rvalues, $vtarget, GUICtrlRead($Tolerance), $GUI_UNCHECKED, $GUI_CHECKED, GUICtrlRead($nResistors))
					EndIf
				Case BitAND(GUICtrlRead($Checkbox_Parallel) = $GUI_UNCHECKED, GUICtrlRead($Checkbox_series) = $GUI_CHECKED, BitAND(GUICtrlRead($Auto_Range), $GUI_CHECKED) = $GUI_CHECKED)
					If GUICtrlRead($Checkbox_allowdup) = $GUI_CHECKED Then
						_AutoRange('Series', $vtarget, $R_Values)
						$Range_Rvalues = _Create_Range($R_Values, GUICtrlRead($Range_Start), GUICtrlRead($Range_End))
						_Combo_Dups($Range_Rvalues, $vtarget, GUICtrlRead($Tolerance), $GUI_CHECKED, $GUI_UNCHECKED, GUICtrlRead($nResistors))
					EndIf
					If GUICtrlRead($Checkbox_allowdup) = $GUI_UNCHECKED Then
						_AutoRange('Series', $vtarget, $R_Values)
						$Range_Rvalues = _Create_Range($R_Values, GUICtrlRead($Range_Start), GUICtrlRead($Range_End))
						_Combo($Range_Rvalues, $vtarget, GUICtrlRead($Tolerance), $GUI_CHECKED, $GUI_UNCHECKED, GUICtrlRead($nResistors))
					EndIf
				Case BitAND(GUICtrlRead($Auto_Range), $GUI_UNCHECKED) = $GUI_UNCHECKED
					If GUICtrlRead($Checkbox_allowdup) = $GUI_CHECKED Then
						$Range_Rvalues = _Create_Range($R_Values, GUICtrlRead($Range_Start), GUICtrlRead($Range_End))
						_Combo_Dups($Range_Rvalues, $vtarget, GUICtrlRead($Tolerance), GUICtrlRead($Checkbox_series), GUICtrlRead($Checkbox_Parallel), GUICtrlRead($nResistors))
					EndIf
					If GUICtrlRead($Checkbox_allowdup) = $GUI_UNCHECKED Then
						$Range_Rvalues = _Create_Range($R_Values, GUICtrlRead($Range_Start), GUICtrlRead($Range_End))
						_Combo($Range_Rvalues, $vtarget, GUICtrlRead($Tolerance), GUICtrlRead($Checkbox_series), GUICtrlRead($Checkbox_Parallel), GUICtrlRead($nResistors))
					EndIf
			EndSelect
			Global $B_DESCENDING[_GUICtrlListView_GetColumnCount ($List1) ]
			_GUICtrlListView_SimpleSort ($List1, $B_DESCENDING, 2)
			$dif = TimerDiff($timeS)
			If $dif < 60000 Then
				$time = Round($dif / 1000, 2) & ' Seconds'
			Else
				_TicksToTime(Int($dif), $hour, $mins, $secs)
				If $hour = 0 Then
					$time = $mins & ' Minutes and ' & $secs & ' Seconds'
				Else
					$time = $hour & 'Hours ' & $mins & 'Minutes and ' & $secs & ' Seconds'
				EndIf
			EndIf
			MsgBox(0, 'Finished!', 'Search Took ' & $time)
			If _GUICtrlListView_GetItemCount ($List1) = 0 Then MsgBox(0, 'No Matches', 'You had 0 matches so you should increase the tolerance.' & @LF & _
					'Remember for low Values you can increase the tolerance pretty high without changing value much.')
		Case $B_Colors4
			Dim $colors[4]
			$colors[0] = _GUICtrlComboBox_GetCurSel ($Band_1_4)
			$colors[1] = _GUICtrlComboBox_GetCurSel ($Band_2_4)
			$colors[2] = _GUICtrlComboBox_GetCurSel ($Band_3_4)
			$colors[3] = _GUICtrlComboBox_GetCurSel ($Band_4_4)
			$resistor_Color_Value = _Color_Value_4($colors)
			
		Case $B_Colors5
			Dim $colors[5]
			$colors[0] = _GUICtrlComboBox_GetCurSel ($Band_1_5)
			$colors[1] = _GUICtrlComboBox_GetCurSel ($Band_2_5)
			$colors[2] = _GUICtrlComboBox_GetCurSel ($Band_3_5)
			$colors[3] = _GUICtrlComboBox_GetCurSel ($Band_4_5)
			$colors[4] = _GUICtrlComboBox_GetCurSel ($Band_5_5)
			_Color_Value_5($colors)
		Case $B_Qcalc
			$F_Value = _Stringformat(GUICtrlRead($Qcalc_Input), 1)
			$RP_String = _Parallel_Value($F_Value)
			$RS_String = _Series_Value($F_Value)
			MsgBox(0, 'Resistance Value', 'Parallel Value = ' & $RP_String & ' Ohms' & @LF & _
					'Series Value = ' & $RS_String & ' Ohms')
		Case $GUI_EVENT_CLOSE
			Exit
		Case $MenuItem3
			Exit
		Case $MenuItem6
			MsgBox(0, 'About', 'Resistance Calculator' & @LF & 'Version 2' & @LF & 'Writen by Brian J Christy')
		Case $MenuItem5
			MsgBox(0, 'How to Use', "All values entered can be abbreviated with a K for thousand or M for Million." & @LF & _
					"For imported values the same rule applies.  Also the file you import" & @LF & "can only have one value per line and must be a .txt file." & @LF & @LF & _
					"Default Values are preloaded startup. These Values include all values found in " & @LF & _
					"RadioShacks Assortment Pack." & @LF & @LF & "A Comma is the character used to seperate values in the Quick calc and you can" & @LF & _
					"enter as many values as you want. The Calc will return both series and parallel values.")
		Case $MenuItem8
			Dim $Atemp = $R_Values
			For $i = 0 To UBound($Atemp) - 1
				_Format_Value2View($Atemp[$i])
			Next
			_ArrayDisplay($Atemp, $current_series)
		Case $MenuItem10
			_Load_E6_Values($R_Values)
			$current_series = 'E6 Series'
			MsgBox(0, 'E6 Series Loaded!', UBound($R_Values) & ' Values have been Loaded')
		Case $MenuItem11
			_Load_E12_Values($R_Values)
			$current_series = 'E12 Series'
			MsgBox(0, 'E12 Series Loaded!', UBound($R_Values) & ' Values have been Loaded')
		Case $MenuItem12
			_Load_E24_Values($R_Values)
			$current_series = 'E24 Series'
			MsgBox(0, 'E24 Series Loaded!', UBound($R_Values) & ' Values have been Loaded')
		Case $MenuItem13
			_Load_E48_Values($R_Values)
			$current_series = 'E48 Series'
			MsgBox(0, 'E48 Series Loaded!', UBound($R_Values) & ' Values have been Loaded')
		Case $MenuItem14
			_Load_E96_Values($R_Values)
			$current_series = 'E96 Series'
			MsgBox(0, 'E96 Series Loaded!', UBound($R_Values) & ' Values have been Loaded')
	EndSwitch
WEnd

Func _AutoRange($connection, $aTarget, $aArray)
	Local $i, $index
	GUICtrlSetData($Range_End, '')
	GUICtrlSetData($Range_Start, '')
	If $connection = 'Parallel' Then
		For $i = UBound($aArray) - 1 To 0 Step - 1
			If $aArray[$i] <= $aTarget Then
				$index = $i - 1
				If $index <= 0 Then
					GUICtrlSetData($Range_End, '')
					GUICtrlSetData($Range_Start, '')
					Return
				EndIf
				GUICtrlSetData($Range_Start, $index)
				Return
			EndIf
		Next
	EndIf
	If $connection = 'Series' Then
		For $i = 0 To UBound($aArray) - 1
			If $aArray[$i] = $aTarget Then
				GUICtrlSetData($Range_End, $i + 1)
				GUICtrlSetData($Range_Start, '')
				Return
			EndIf
			If $aArray[$i] > $aTarget Then
				GUICtrlSetData($Range_End, $i)
				GUICtrlSetData($Range_Start, '')
				Return
			EndIf
		Next
	EndIf
EndFunc   ;==>_AutoRange

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
	While Int($iLeft) > 0
		_Array_GetNext ($iN, $iR, $iLeft, $iTotal, $aIdx)
		For $i = 0 To $iSet - 1
			$Resistor_Set &= $avArray[$aIdx[$i]] & $sDelim
		Next
		If $sDelim <> "" Then $Resistor_Set = StringTrimRight($Resistor_Set, 1)
		If $parallel = $GUI_CHECKED Then
			$sParallelV = _Parallel_Value($Resistor_Set)
			_Tolerance_Check($sParallelV, $Target, $high, $low, 'P', $Resistor_Set)
		EndIf
		If $series = $GUI_CHECKED Then
			$sSeriesV = _Series_Value($Resistor_Set)
			_Tolerance_Check($sSeriesV, $Target, $high, $low, 'S', $Resistor_Set)
		EndIf
		$Resistor_Set = ''
	WEnd
	GUICtrlSetData($checked, $tchecked)
EndFunc   ;==>_Combo

Func _Combo_Dups(ByRef $array, $Target, $Tolerance, $series, $parallel, $iSet)
	Local $i, $done, $iSet2[1]
	Local $sParallelV, $sSeriesV, $high, $low, $Resistor_Set
	$high = $Target+ ($Target* ($Tolerance / 100))
	$low = $Target- ($Target* ($Tolerance / 100))
	For $i = 0 To $iSet - 1
		_ArrayAdd($iSet2, '0')
	Next
	_ArrayDelete($iSet2, 0)
	Do
		$Resistor_Set = ''
		For $i = 0 To UBound($iSet2) - 1
			$Resistor_Set &= $array[$iSet2[$i]] & ','
		Next
		$Resistor_Set = StringTrimRight($Resistor_Set, 1)
		If $parallel = $GUI_CHECKED Then
			$sParallelV = _Parallel_Value($Resistor_Set)
			_Tolerance_Check($sParallelV, $Target, $high, $low, 'P', $Resistor_Set)
		EndIf
		If $series = $GUI_CHECKED Then
			$sSeriesV = _Series_Value($Resistor_Set)
			_Tolerance_Check($sSeriesV, $Target, $high, $low, 'S', $Resistor_Set)
		EndIf
		_Shift($array, $iSet2, $done)
	Until $done = 1
	GUICtrlSetData($checked, $tchecked)
EndFunc   ;==>_Combo_Dups

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

Func _Color_Value_4($color_Array)
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
			$value = ($color_Array[0] & $color_Array[1]) * 10000000
		Case $color_Array[2] = 8
			$value = ($color_Array[0] & $color_Array[1]) * 100000000
		Case $color_Array[2] = 9
			$value = ($color_Array[0] & $color_Array[1]) * 1000000000
		Case $color_Array[2] = 10
			$value = ($color_Array[0] & $color_Array[1]) * .1
		Case $color_Array[2] = 11
			$value = ($color_Array[0] & $color_Array[1]) * .01
	EndSelect
	If StringLeft($value, 1) = 0 Then $value = StringTrimLeft($value, 1)
	_Format_Value2View($value)
	If $color_Array[3] = 0 Then MsgBox(0, '4 Band Value', $value & ' Ohms  +/- 5% ')
	If $color_Array[3] = 1 Then MsgBox(0, '4 Band Value', $value & ' Ohms  +/- 10% ')
	If $color_Array[3] = 2 Then MsgBox(0, '4 Band Value', $value & ' Ohms  +/- 1% ')
	If $color_Array[3] = 3 Then MsgBox(0, '4 Band Value', $value & ' Ohms  +/- 2% ')
	If $color_Array[3] = 4 Then MsgBox(0, '4 Band Value', $value & ' Ohms  +/- 0.5% ')
	If $color_Array[3] = 5 Then MsgBox(0, '4 Band Value', $value & ' Ohms  +/- 0.25% ')
	If $color_Array[3] = 6 Then MsgBox(0, '4 Band Value', $value & ' Ohms  +/- 0.1% ')
	If $color_Array[3] = 7 Then MsgBox(0, '4 Band Value', $value & ' Ohms  +/- 0.05% ')
	If $color_Array[3] = 8 Then MsgBox(0, '4 Band Value', $value & ' Ohms  +/- 20%')
EndFunc   ;==>_Color_Value_4

Func _Color_Value_5($color_Array)
	Local $value
	Select
		Case $color_Array[3] = 0
			$value = ($color_Array[0] & $color_Array[1] & $color_Array[2])
		Case $color_Array[3] = 1
			$value = ($color_Array[0] & $color_Array[1] & $color_Array[2]) * 10
		Case $color_Array[3] = 2
			$value = ($color_Array[0] & $color_Array[1] & $color_Array[2]) * 100
		Case $color_Array[3] = 3
			$value = ($color_Array[0] & $color_Array[1] & $color_Array[2]) * 1000
		Case $color_Array[3] = 4
			$value = ($color_Array[0] & $color_Array[1] & $color_Array[2]) * 10000
		Case $color_Array[3] = 5
			$value = ($color_Array[0] & $color_Array[1] & $color_Array[2]) * 100000
		Case $color_Array[3] = 6
			$value = ($color_Array[0] & $color_Array[1] & $color_Array[2]) * 1000000
		Case $color_Array[3] = 7
			$value = ($color_Array[0] & $color_Array[1] & $color_Array[2]) * 10000000
		Case $color_Array[3] = 8
			$value = ($color_Array[0] & $color_Array[1] & $color_Array[2]) * 100000000
		Case $color_Array[3] = 9
			$value = ($color_Array[0] & $color_Array[1] & $color_Array[2]) * 1000000000
		Case $color_Array[3] = 10
			$value = ($color_Array[0] & $color_Array[1] & $color_Array[2]) * .1
		Case $color_Array[3] = 11
			$value = ($color_Array[0] & $color_Array[1] & $color_Array[2]) * .01
	EndSelect
	If StringLeft($value, 1) = 0 Then $value = StringTrimLeft($value, 1)
	_Format_Value2View($value)
	If $color_Array[4] = 0 Then MsgBox(0, '5 Band Value', $value & ' Ohms  +/- 5%')
	If $color_Array[4] = 1 Then MsgBox(0, '5 Band Value', $value & ' Ohms  +/- 10%')
	If $color_Array[4] = 2 Then MsgBox(0, '5 Band Value', $value & ' Ohms  +/- 1%')
	If $color_Array[4] = 3 Then MsgBox(0, '5 Band Value', $value & ' Ohms  +/- 2%')
	If $color_Array[4] = 4 Then MsgBox(0, '5 Band Value', $value & ' Ohms  +/- 0.5% ')
	If $color_Array[4] = 5 Then MsgBox(0, '5 Band Value', $value & ' Ohms  +/- 0.25% ')
	If $color_Array[4] = 6 Then MsgBox(0, '5 Band Value', $value & ' Ohms  +/- 0.1% ')
	If $color_Array[4] = 7 Then MsgBox(0, '5 Band Value', $value & ' Ohms  +/- 0.05% ')
	If $color_Array[4] = 8 Then MsgBox(0, '5 Band Value', $value & ' Ohms  +/- 20%')
	;Return $value
EndFunc   ;==>_Color_Value_5

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
	Local $string, $array
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
	Select
		Case $count > 6
			$value = ($value / 1000000) & 'M'
			Return
		Case $count > 3
			If StringInStr($value, '.') <> 0 Then Return
			$value = ($value / 1000) & 'K'
			Return
	EndSelect
EndFunc   ;==>_Format_Value2View

Func _Stringformat($string, $type)
	Local $Atemp, $newString
	$string = StringReplace($string, ' ', '')
	$Atemp = StringSplit($string, ',')
	If $type = 0 Then
		For $i = 1 To $Atemp[0]
			_Format_Value2View($Atemp[$i])
			$newString &= $Atemp[$i] & ',  '
		Next
		$newString = StringTrimRight($newString, 3)
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

Func _Import_Custom_Values(ByRef $Custom)
	Local $R_V_Check, $file
	$file = FileOpenDialog("Select File to Import", @ScriptDir & "\", "Text files (*.txt)", 1)
	If $file = '' Then Return
	_FileReadToArray($file, $R_V_Check)
	_ArrayDelete($R_V_Check, 0)
	_ArrayDeleteBlanks($R_V_Check)
	For $i = 0 To UBound($R_V_Check) - 1
		$R_V_Check[$i] = Number(_Format_View2Value($R_V_Check[$i]))
	Next
	_ArraySort($R_V_Check, 0)
	$Custom = $R_V_Check
EndFunc   ;==>_Import_Custom_Values

Func _Load_E6_Values(ByRef $E6_Values)
	Local $E6[6] = [1, 1.5, 2.2, 3.3, 4.7, 6.8]
	_Expand_Series($E6)
	$E6_Values = $E6
EndFunc   ;==>_Load_E6_Values

Func _Load_E12_Values(ByRef $E12_Values)
	Local $E12[12] = [1, 1.2, 1.5, 1.8, 2.2, 2.7, 3.3, 3.9, 4.7, 5.6, 6.8, 8.2]
	_Expand_Series($E12)
	$E12_Values = $E12
EndFunc   ;==>_Load_E12_Values

Func _Load_E24_Values(ByRef $E24_Values)
	Local $value, $E24[24] = [1, 1.1, 1.2, 1.3, 1.5, 1.6, 1.8, 2, 2.2, 2.4, 2.7, 3, 3.3, 3.6, _
			3.9, 4.3, 4.7, 5.1, 5.6, 6.2, 6.8, 7.5, 8.2, 9.1]
	_Expand_Series($E24)
	$E24_Values = $E24
EndFunc   ;==>_Load_E24_Values

Func _Load_E48_Values(ByRef $E48_Values)
	Local $value, $E48[48] = [1, 1.05, 1.1, 1.15, 1.21, 1.27, 1.33, 1.4, 1.47, 1.54, 1.62, 1.69, 1.78, 1.87, _
			1.96, 2.05, 2.15, 2.26, 2.37, 2.49, 2.61, 2.74, 2.87, 3.01, 3.16, 3.32, 3.48, 3.65, 3.83, 4.02, 4.22, _
			4.42, 4.64, 4.87, 5.11, 5.36, 5.62, 5.9, 6.19, 6.49, 6.81, 7.15, 7.5, 7.87, 8.25, 8.66, 9.09, 9.53]
	_Expand_Series($E48)
	$E48_Values = $E48
EndFunc   ;==>_Load_E48_Values

Func _Load_E96_Values(ByRef $E96_Values)
	Local $value, $E96[96] = [1, 1.02, 1.05, 1.07, 1.1, 1.13, 1.15, 1.18, 1.21, 1.24, 1.27, 1.3, 1.33, 1.37, 1.4, 1.43, 1.47, 1.5, _
			1.54, 1.58, 1.62, 1.65, 1.69, 1.74, 1.78, 1.82, 1.87, 1.91, 1.96, 2, 2.05, 2.1, 2.15, 2.21, 2.26, 2.32, 2.37, 2.43, 2.49, 2.55, 2.61, _
			2.67, 2.74, 2.8, 2.87, 2.94, 3.01, 3.09, 3.16, 3.24, 3.23, 3.4, 3.48, 3.57, 3.65, 3.74, 3.83, 3.92, 4.02, 4.12, 4.22, 4.32, 4.42, _
			4.53, 4.64, 4.75, 4.87, 4.99, 5.11, 5.23, 5.36, 5.49, 5.62, 5.76, 5.9, 6.04, 6.19, 6.34, 6.49, 6.65, 6.81, 6.98, 7.15, 7.32, _
			7.5, 7.68, 7.87, 8.06, 8.25, 8.45, 8.66, 8.87, 9.09, 9.31, 9.53, 9.76]
	_Expand_Series($E96)
	$E96_Values = $E96
EndFunc   ;==>_Load_E96_Values

Func _Load_Default_Values(ByRef $RadioShack)
	Local $T_RadioShack[65] = [1, 2.2, 10, 15, 22, 33, 39, 47, 51, 68, 82, 100, 120, 150, 180, 220, 270, 300, 330, _
			390, 470, 510, 560, 680, 820, 1000, 1200, 1500, 1800, 2200, 2700, 3000, 3300, 3900, 4700, 5100, 5600, _
			6800, 8200, 10000, 12000, 15000, 18000, 22000, 27000, 33000, 39000, 47000, 51000, 56000, 68000, 82000, _
			100000, 120000, 150000, 180000, 220000, 270000, 330000, 1000000, 1500000, 2200000, 3300000, 4700000, 10000000]
	$RadioShack = $T_RadioShack
EndFunc   ;==>_Load_Default_Values

Func _Expand_Series(ByRef $Eseries)
	Local $value
	For $i = 0 To UBound($Eseries) - 1
		$value = $Eseries[$i] * 10
		_ArrayAdd($Eseries, $value)
		$value = $Eseries[$i] * 100
		_ArrayAdd($Eseries, $value)
		$value = $Eseries[$i] * 1000
		_ArrayAdd($Eseries, $value)
		$value = $Eseries[$i] * 10000
		_ArrayAdd($Eseries, $value)
		$value = $Eseries[$i] * 100000
		_ArrayAdd($Eseries, $value)
		$value = $Eseries[$i] * 1000000
		_ArrayAdd($Eseries, $value)
	Next
	_ArrayAdd($Eseries, 10000000)
	_ArraySort($Eseries, 0)
EndFunc   ;==>_Expand_Series

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

Func _Create_Range(ByRef $rR_Values, $start, $end)
	Local $R_Range
	If BitAND($start = '', $end = '') Then
		$R_Range = $rR_Values
		Return $R_Range
	EndIf
	If $start = '' Then $start = 0
	If $end = '' Then
		$end = UBound($rR_Values)
	Else
		$end += 1
	EndIf
	$total = $end - $start
	Local $R_Range[$total]
	For $i = 0 To $total - 1
		$R_Range[$i] = $rR_Values[$start + $i]
	Next
	Return $R_Range
EndFunc   ;==>_Create_Range

Func _Shift(ByRef $array, ByRef $iSet, ByRef $done)
	Local $l
	If $iSet[0] = UBound($array) - 1 Then
		$done = 1
		Return
	EndIf
	$x = UBound($iSet) - 1
	While $x <> 0
		If $iSet[$x] <> UBound($array) - 1 Then
			$iSet[$x] += 1
			Return
		EndIf
		$x -= 1
		If $iSet[$x] <> UBound($array) - 1 Then
			$iSet[$x] += 1
			$l = $x
			Do
				$iSet[$l + 1] = $iSet[$x]
				$l += 1
			Until $l = UBound($iSet) - 1
			Return
		EndIf
	WEnd
EndFunc   ;==>_Shift

Func _Calc_Total($series, $parallel, $aTarget, $aArray, $resistorsN)
	Local $i, $index, $parallel_start = 0, $parallel_end = 0, $series_Start = 0, $series_end = 0, $totalp = 0, $totals = 0, $total
	If $parallel = $GUI_CHECKED Then
		For $i = UBound($aArray) - 1 To 0 Step - 1
			If $aArray[$i] <= $aTarget Then
				$index = $i - 1
				If $index <= 0 Then
					$parallel_start = 0
					$parallel_end = UBound($aArray) - 1
					ExitLoop
				EndIf
				$parallel_start = $index
				$parallel_end = UBound($aArray) - 1
				ExitLoop
			EndIf
		Next
	EndIf
	$totalp = $parallel_end - $parallel_start + 1
	$totalp = New_Array_Combinations($totalp, $resistorsN)
	If $series = $GUI_CHECKED Then
		For $i = 0 To UBound($aArray) - 1
			If $aArray[$i] = $aTarget Then
				$series_end = $i + 1
				If $series_end > UBound($aArray) - 1 Then $series_end = UBound($aArray) - 1
				$series_Start = 0
				ExitLoop
			EndIf
			If $aArray[$i] > $aTarget Then
				$series_end = $i
				$series_Start = 0
				ExitLoop
			EndIf
		Next
	EndIf
	$totals += $series_end - $series_Start + 1
	$totals = New_Array_Combinations($totals, $resistorsN)
	$total += $totalp + $totals
	MsgBox(0, 'final', $total)
EndFunc   ;==>_Calc_Total

