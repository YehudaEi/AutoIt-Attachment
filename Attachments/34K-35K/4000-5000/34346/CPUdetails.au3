
#cs
	TAB of CPU details
#ce

$CPU = GUICtrlCreateTabItem("CPU")
		$g_CPUinfo = GUICtrlCreateGroup("Global Information", 48, 51, 830, 80)
				GUICtrlCreateGroup("", -99, -99, 1, 1)
				GUICtrlCreateLabel("Processor : ", 64, 81, 60, 17)
				$l_CPUinfoResponse = GUICtrlCreateLabel("Piece of information about the Processor Unit", 128, 81, 262, 17)
				GUICtrlSetFont(-1, 8, 800, 0, "MS Sans Serif")

		$l_CPUmessage = GUICtrlCreateLabel("", 49, 152, 830, 17, $SS_CENTER)
				GUICtrlSetFont ($l_CPUmessage, 8, 800, 0, "MS Sans Serif")
				GUICtrlSetState ($l_CPUmessage, $GUI_DISABLE)

		$lv_CPUdetails =  GUICtrlCreateListView ("Name|Command Line|Description|Username|%|Handles|Threads", 50, 186, 830, 500, -1, $i_ExWindowStyle)
				_GUICtrlListView_SetExtendedListViewStyle ($lv_CPUdetails, $i_ExListViewStyle)

				GUICtrlSendMsg ($lv_CPUdetails, $LVM_SETCOLUMNWIDTH, 0, 150)
				GUICtrlSendMsg ($lv_CPUdetails, $LVM_SETCOLUMNWIDTH, 1, 180)
				GUICtrlSendMsg ($lv_CPUdetails, $LVM_SETCOLUMNWIDTH, 2, 210)
				GUICtrlSendMsg ($lv_CPUdetails, $LVM_SETCOLUMNWIDTH, 3, 120)
				GUICtrlSendMsg ($lv_CPUdetails, $LVM_SETCOLUMNWIDTH, 4, 30)
				GUICtrlSendMsg ($lv_CPUdetails, $LVM_SETCOLUMNWIDTH, 5, 50)
				GUICtrlSendMsg ($lv_CPUdetails, $LVM_SETCOLUMNWIDTH, 6, 50)
				GUICtrlSetState($lv_CPUdetails, $GUI_ENABLE)
				GUICtrlSetCursor ($lv_CPUdetails, 3)

		$b_CPUsave = GUICtrlCreateButton ("Save", 458, 711, 75, 25)
				GUICtrlSetCursor ($b_CPUsave, 2)

		$b_CPUrefresh = GUICtrlCreateButton ("Refresh", 768, 711, 75, 25)
				GUICtrlSetCursor ($b_CPUrefresh, 2)

		; updating the CPU listview
		updateCPUListViewItems ($lv_CPUdetails, $a_ProcessDetails)
		sortItemsInCPUListView ()