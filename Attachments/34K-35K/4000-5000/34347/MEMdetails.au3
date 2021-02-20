
#cs
	TAB of MEMORY details
#ce

$MEMORY = GUICtrlCreateTabItem ("MEMORY")
		$g_MEMinfo = GUICtrlCreateGroup("Global Information", 48, 51, 830, 120)
				GUICtrlCreateGroup("", -99, -99, 1, 1)
				GUICtrlCreateLabel("Physical RAM", 64, 81, 70, 17)
						$l_PhyRAMused = GUICtrlCreateLabel("Used : MB ( %)", 148, 98, 74, 17)
						$l_PhyRAMfree = GUICtrlCreateLabel("Free : MB", 148, 115, 50, 17)
						$l_PhyRAMtotal = GUICtrlCreateLabel("Total : MB", 148, 136, 53, 17)
				GUICtrlCreateLabel("Virtual RAM", 480, 81, 60, 17)
						$l_VirtualRAMused = GUICtrlCreateLabel("Used : MB ( %)", 554, 98, 74, 17)
						$l_VirtualRAMfree = GUICtrlCreateLabel("Free : MB", 554, 115, 50, 17)
						$l_VirtualRAMtotal = GUICtrlCreateLabel("Total : MB", 554, 136, 53, 17)

		$l_MEMmessage = GUICtrlCreateLabel("", 46, 192, 830, 17, $SS_CENTER)
				GUICtrlSetFont ($l_CPUmessage, 8, 800, 0, "MS Sans Serif")
				GUICtrlSetState ($l_CPUmessage, $GUI_DISABLE)

		$lv_MEMdetails = GUICtrlCreateListView("Name|Command Line|Description|Username|%|Volume|Handles|Threads", 50, 226, 830, 460,  -1, $i_ExWindowStyle)
				_GUICtrlListView_SetExtendedListViewStyle ($lv_CPUdetails, $i_ExListViewStyle)

				GUICtrlSendMsg ($lv_MEMdetails, $LVM_SETCOLUMNWIDTH, 0, 90)
				GUICtrlSendMsg ($lv_MEMdetails, $LVM_SETCOLUMNWIDTH, 1, 120)
				GUICtrlSendMsg ($lv_MEMdetails, $LVM_SETCOLUMNWIDTH, 2, 180)
				GUICtrlSendMsg ($lv_MEMdetails, $LVM_SETCOLUMNWIDTH, 3, 80)
				GUICtrlSendMsg ($lv_MEMdetails, $LVM_SETCOLUMNWIDTH, 4, 50)
				GUICtrlSendMsg ($lv_MEMdetails, $LVM_SETCOLUMNWIDTH, 5, 75)
				GUICtrlSendMsg ($lv_MEMdetails, $LVM_SETCOLUMNWIDTH, 6, 60)
				GUICtrlSendMsg ($lv_MEMdetails, $LVM_SETCOLUMNWIDTH, 7, 100)
				GUICtrlSetState($lv_MEMdetails, $GUI_ENABLE)
				GUICtrlSetCursor ($lv_MEMdetails, 3)

		$b_MEMsave = GUICtrlCreateButton("Save", 458, 711, 75, 25)
				GUICtrlSetCursor ($b_MEMsave, 2)

		$b_MEMrefresh = GUICtrlCreateButton("Refresh", 768, 711, 75, 25)
				GUICtrlSetCursor ($b_MEMrefresh, 2)

		; updating the CPU listview
		updateMEMListViewItems ($lv_MEMdetails, $a_ProcessDetails)
		sortItemsInMEMListView ()