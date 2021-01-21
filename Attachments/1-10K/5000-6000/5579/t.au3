;===============================================================================
;
; Function Name:    _EditIniDialog()
; Description:      Opens a dialog to edit an INI file.
; Parameter(s):     $iniloc         - Path to the INI file
;                   $EIDtitle       - [optional] Title of the window. Default is "INI Editor"
;                   $DisallowSaveAs - [optional] If set to a non-zero value, it disables the save-as option (saving in
;                                     original location still allowed). (Default = 0)
;                   $DisallowEdit   - [optional] If set to a non-zero value, it disallows clicking any button except
;                                     for the Close button(save-as option still allowed unless previous option sets otherwise). (Default = 0)
; Requirement(s):   AutoIt
; Return Value(s):  Returns 1 if no error
;                   Returns 0 if there is an error
;                   @error = 1 - Unable to read section names of file (ini may not exist)
;                   @error = 2 - There was an error while reading a section (ini does exist)
;                   @error = 3 - Error while copying files (ini does exist)
; Author(s):        Alexander "TechDude" Wood (aka nfwu)   me@techdudeonline.tk
;
;===============================================================================
Func _DialogEditIni($iniloc, $EIDtitle = "INI Editor", $DisallowSaveAs = 0, $DisallowEdit = 0)
	;; Sorry for the "Magic" numbers
	$EID_GUI = GUICreate($EIDtitle, 420, 290, (@DesktopWidth - 420) / 2, (@DesktopHeight - 290) / 2, 0x04000000 + 0x00CF0000 + 0x10000000)
	$EID_Tree = GUICtrlCreateTreeView(10, 10, 250, 190, BitOR($TVS_HASBUTTONS, $TVS_HASLINES, $TVS_LINESATROOT, $TVS_DISABLEDRAGDROP, $TVS_SHOWSELALWAYS))
	$EID_EDIButton = GUICtrlCreateButton("Edit Value", 270, 120, 140, 30)
	$EID_REMButton = GUICtrlCreateButton("Remove Value", 270, 170, 140, 30)
	$EID_ADSButton = GUICtrlCreateButton("Add as Sibling", 270, 70, 140, 30)
	$EID_ADCButton = GUICtrlCreateButton("Add as Child", 270, 20, 140, 30)
	$EID_SAVButton = GUICtrlCreateButton("Save", 40, 240, 80, 30)
	$EID_SASButton = GUICtrlCreateButton("Save As...", 170, 240, 80, 30)
	$EID_CLOButton = GUICtrlCreateButton("Close", 290, 240, 90, 30)
	$EID_TOVLabel = GUICtrlCreateLabel("Type of Value:", 10, 210, 400, 20)
	$EID_secnames = IniReadSectionNames($iniloc)
	If @error Then
		SetError(2)
		GUISetState(@SW_HIDE, $EID_GUI)
		Return
	EndIf
	Dim $EID_values[$EID_secnames[0] + 1]
	$EID_values[0] = $EID_secnames[0]
	Dim $EID_treevalues[$EID_secnames[0] + 1]
	$EID_treevalues[0] = $EID_secnames[0]
	Dim $temp_array[1]
	For $i = 1 To $EID_values[0]
		$EID_values[$i] = IniReadSection($iniloc, $EID_secnames[$i])
		$EID_treevalues[$i] = _ArrayCreate (GUICtrlCreateTreeViewItem($EID_secnames[$i], $EID_Tree))
		If @error == 1 Then ;Section could not be read
			GUISetState(@SW_HIDE, $EID_GUI)
			Return
		ElseIf @error == 2 Then ;Empty section
			$EID_values[$i] = 0
			ContinueLoop
		EndIf
		$j = 1
		For $j = 1 To $EID_values[$i][0]
			_ArrayAdd($EID_treevalues[$i], GUICtrlCreateTreeViewItem($EID_values[$i][$j][0], $EID_treevalues[$i][0]))
		Next
	Next
	Dim $EID_selectedtreeitem[2]
	$EID_selectedtreeitem[0] = 0
	$EID_selectedtreeitem[1] = 0
	GUISetState(@SW_SHOW, $EID_GUI)
	While 1
		$msg = GUIGetMsg()
		Select
			Case $msg == 0
				ContinueLoop
			Case $msg == $GUI_EVENT_CLOSE
				ExitLoop
			Case $msg == $EID_EDIButton
			Case $msg == $EID_REMButton
			Case $msg == $EID_ADSButton
			Case $msg == $EID_ADCButton
			Case $msg == $EID_SAVButton
			Case $msg == $EID_SASButton
			Case $msg == $EID_CLOButton
				ExitLoop
			Case Else
				For $i = 1 To $EID_treevalues[0]
					If $msg == $EID_treevalues[$i][0] Then
						$EID_selectedtreeitem[0] = $i
						$EID_selectedtreeitem[1] = 0
						GUICtrlSetData($EID_TOVLabel, "Currently Selected Value: [Section] - " & $EID_secnames[$i] & " : [SectionID] - " $i)
						ContinueLoop 2
					EndIf
					For $j = 1 To $EID_values[$i][0][0]
						If $msg == $EID_treevalues[$i][$j] Then
							$EID_selectedtreeitem[0] = $i
							$EID_selectedtreeitem[1] = $j
							GUICtrlSetData($EID_TOVLabel, "Currently Selected Value: [K/V Pair] : [Key] - " & $EID_secnames[$i][0] & " : [Value] - " & $EID_secnames[$i][1] & " : [PairID] - " $i)
							ContinueLoop 3
						EndIf
					Next
				Next
		EndSelect
	WEnd
	GUISetState(@SW_HIDE, $EID_GUI)
EndFunc   ;==>_DialogEditIni