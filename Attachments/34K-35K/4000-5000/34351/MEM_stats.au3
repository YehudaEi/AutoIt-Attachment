#cs

#ce
Func updateMEMListView ()
	; emptying the listview
	GUICtrlSetState ($l_MEMmessage, $GUI_ENABLE)
	GUICtrlSetData ($l_MEMmessage, "refreshing the CPU details ...")
	_GUICtrlListView_DeleteAllItems($lv_MEMdetails)

	; getting the new CPU details
	$a_ProcessDetails = ProcessListing ()

	; updating the listview with the new CPU details
	; and sorting it by percentage of use
	updateMEMListViewItems ($lv_MEMdetails, $a_ProcessDetails)
	sortItemsInMEMListView ()

	GUICtrlSetState ($l_MEMmessage, $GUI_DISABLE)
	GUICtrlSetData ($l_MEMmessage, "")
EndFunc



#cs
	update of the CPU or MEM listview
#ce
Func updateMEMListViewItems ($listView, $a_details)
	_GUICtrlListView_DeleteAllItems ($listView)
	Local $numberOfProcesses = UBound ($a_details, 1)
	$numberOfProcesses = $numberOfProcesses - 1
	Local $entry

	; adding of items in the listview : 1 line per process
	For $i = 1 to $numberOfProcesses
		$entry = _GUICtrlListView_AddItem ($listView, $a_details[$i][0], $i)
								_GUICtrlListView_AddSubItem ($listView, $entry, $a_details[$i][9], 1)
								_GUICtrlListView_AddSubItem ($listView, $entry, $a_details[$i][10], 2)
								_GUICtrlListView_AddSubItem ($listView, $entry, $a_details[$i][3], 3)
								_GUICtrlListView_AddSubItem ($listView, $entry, $a_details[$i][6], 4)
								_GUICtrlListView_AddSubItem ($listView, $entry, $a_details[$i][0], 5)
								_GUICtrlListView_AddSubItem ($listView, $entry, $a_details[$i][11], 6)
								_GUICtrlListView_AddSubItem ($listView, $entry, $a_details[$i][12], 7)
	Next

EndFunc



Func sortItemsInMEMListView ()
	_GUICtrlListView_SortItems ($lv_MEMdetails, GUICtrlGetState($lv_MEMdetails))
	;Local $tInfo = DllStructCreate($tagNMLISTVIEW);, $ilParam)
	;_GUICtrlListView_SimpleSort (GUICtrlGetHandle($listView), $B_DESCENDING, DllStructGetData($tInfo, "SubItem"))
EndFunc
