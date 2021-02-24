Func ListLBox_SelectString($window, $windowText, $controlID, $selectString, $fPartialOK = True)
	; Searching $selectString in the specified listbox. If found, click it and return True, else False 
	
	_DebugOut("Entering Func ListLBox_SelectString(" & $window & ", " & $windowText & ", " & $controlID & ", " & $selectString & ", " & $fPartialOK & ")")
    $returnVal=False
    $handle=ControlGetHandle($window, $windowText, $controlID)
	_DebugOut("$handle = " & $handle)
	;Find selectString and select 
	$i=0
	$listEnd=_GUICtrlListBox_GetCount($handle) - 1
	_DebugOut("$listEnd = " & $listEnd)
	_GUICtrlListBox_SetSel ($handle, 2)
	If $debugDestinationType=1 Then Sleep($msecSleepToAllowWatching)
	If $listEnd = -1 Then $listEnd = 20
	While($i<=$listEnd AND NOT $returnVal)
		$itemVal = _GUICtrlListBox_GetItemData($handle,$i)
		_DebugOut("$itemVal = " & $itemVal)
		$itemVal = _GUICtrlListBox_GetText($handle,$i)
		_DebugOut("$itemVal = " & $itemVal)
		If (((StringInStr($itemVal, $selectString)>0) AND $fPartialOK) Or((StringCompare($itemVal, $selectString)=0) AND NOT $fPartialOK))  Then
			_DebugOut("launching   _GUICtrlListBox_SetCurSel(" & $handle & ", " & $i & ")")
			_GUICtrlListBox_SetCurSel($handle,$i)
			If $debugDestinationType=1 Then Sleep($msecSleepToAllowWatching)
			_DebugOut("launching   _GUICtrlListBox_SetCurSel(" & $handle & ", " & $i & ")")
			_GUICtrlListBox_ClickItem($handle,$i)
			If $debugDestinationType=1 Then Sleep($msecSleepToAllowWatching)
			$returnVal=True
		EndIf
		$i=$i+1
	WEnd
    Return $returnVal
EndFunc ; ListLBox_SelectString()