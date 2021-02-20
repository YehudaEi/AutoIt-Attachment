
#cs
	CREATION OF THE MENU BAR
#ce

$m_File = GUICtrlCreateMenu("&File")
		$m_Save = GUICtrlCreateMenu("Save", $m_File)
				$m_Save_CPUdetails = GUICtrlCreateMenuItem("CPU details", $m_Save)
				$b_Save_MEMdetails = GUICtrlCreateMenuItem("Memory details", $m_Save)
				$m_Save_HDDdetails = GUICtrlCreateMenuItem("HDD details", $m_Save)
				$m_Save_All = GUICtrlCreateMenuItem("All", $m_Save)
		GUICtrlCreateMenuItem("", $m_File)
		$m_Close = GUICtrlCreateMenuItem("Close", $m_File)

$m_Edit = GUICtrlCreateMenu("&Edit")

$m_Display = GUICtrlCreateMenu("&Display")

$m_Help = GUICtrlCreateMenu("&Help")
		$m_About = GUICtrlCreateMenuItem("About", $m_Help)