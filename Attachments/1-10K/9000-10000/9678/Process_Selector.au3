$ProcessID = Process_Selector ()

Func Process_Selector ()
	
	Local $GUI, $Process_Box, $Cancel, $Process_List, $Combo_List, $i, $msg, $Process_Selected, $Return, $ProcessID
	
	$GUI = GUICreate("Process Selector", 200, 130, -1, -1)
	GUICtrlCreateLabel("Select the process:", 5, 5, 190, 15)
	$Process_Box = GUICtrlCreateCombo("", 5, 25, 190, 120)
	$Cancel = GUICtrlCreateButton("Cancel", 50, 80, 100, 30)
	GUISetState()
	
	$Process_List = ProcessList()
	
	For $i = 1 to $Process_List[0][0]
		$Combo_List &= "|" & $Process_List[$i][0]
	Next
	
	GUICtrlSetData($Process_Box, $Combo_List)
	
	While 1
		$msg = GUIGetMsg()
			If $msg = $Process_Box Then
				$Process_Selected = GUICtrlRead($Process_Box)
				$Return = MsgBox(4, "Process Selected", "You have selected " & $Process_Selected & ", is this the process you want to select?")
				If $Return = 6 Then
					GUIDelete($GUI)
					$ProcessID = ProcessExists($Process_Selected)
					Return $ProcessID
				Else
					ContinueLoop
				EndIf
			ElseIf $msg = $Cancel Then
				GUIDelete($GUI)
				Return 0
			EndIf
	WEnd

EndFunc