#cs

#ce
Func updateCPUListView ()
	; emptying the listview
	GUICtrlSetState ($l_CPUmessage, $GUI_ENABLE)
	GUICtrlSetData ($l_CPUmessage, "refreshing the CPU details ...")
	_GUICtrlListView_DeleteAllItems($lv_CPUdetails)

	; getting the new CPU details
	$a_ProcessDetails = ProcessListing ()

	; updating the listview with the new CPU details
	; and sorting it by percentage of use
	updateCPUListViewItems ($lv_CPUdetails, $a_ProcessDetails)
	sortItemsInCPUListView ()

	GUICtrlSetState ($l_CPUmessage, $GUI_DISABLE)
	GUICtrlSetData ($l_CPUmessage, "")
EndFunc



#cs
	update of the CPU or MEM listview
#ce
Func updateCPUListViewItems ($listView, $a_details)
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
								_GUICtrlListView_AddSubItem ($listView, $entry, $a_details[$i][11], 5)
								_GUICtrlListView_AddSubItem ($listView, $entry, $a_details[$i][12], 6)
	Next

EndFunc



Func sortItemsInCPUListView ()
	_GUICtrlListView_SortItems ($lv_CPUdetails, GUICtrlGetState($lv_CPUdetails))
	; Local $tInfo = DllStructCreate($tagNMLISTVIEW);, $ilParam)
	; _GUICtrlListView_SimpleSort (GUICtrlGetHandle($lv_CPUdetails), $B_CPU_DESCENDING, DllStructGetData($tInfo, "SubItem"))
EndFunc
