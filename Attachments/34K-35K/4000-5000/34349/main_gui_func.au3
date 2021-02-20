#CS
	Functions of the actionsin the main GUI

	parent file		: main_gui.au3
	child file		:
	child function  :
	current GUI		: $main_gui
	child GUI		:
	associated GUI  : $main_gui
#CE

; exiting the GUI
Func MainGui_Close()
	_GUICtrlListView_UnRegisterSortCallBack ($lv_CPUdetails)
	;_GUICtrlListView_UnRegisterSortCallBack ($lv_MEMdetails)
	GUIDelete($main_gui)
	Exit
EndFunc
