Func HealthCheck_P2_Back()
	GUISetState(@SW_HIDE, $HealthCheck_Page2)
	GUISetState(@SW_SHOW, $HealthCheck_Page1)
EndFunc

Func HealthCheck_P2_Next()
	GUISetState(@SW_HIDE, $HealthCheck_Page2)
	Exit
EndFunc

Func HealthCheck_P2_ServSecurity()
	If $HealthCheck_P2_ServSecurityVar = 0 Then
		GUICtrlSetImage($HealthCheck_P2_ServSecuritySlider, "./images/switchon.bmp")
		$HealthCheck_P2_ServSecurityVar = 1
	Else
		GUICtrlSetImage($HealthCheck_P2_ServSecuritySlider, "./images/switchoff.bmp")
		$HealthCheck_P2_ServSecurityVar = 0
	EndIf
EndFunc

Func HealthCheck_P2_ServDefault()
	If $HealthCheck_P2_ServDefaultVar = 0 Then
		GUICtrlSetImage($HealthCheck_P2_ServDefaultSlider, "./images/switchon.bmp")
		$HealthCheck_P2_ServDefaultVar = 1
	Else
		GUICtrlSetImage($HealthCheck_P2_ServDefaultSlider, "./images/switchoff.bmp")
		$HealthCheck_P2_ServDefaultVar = 0
	EndIf
EndFunc

Func HealthCheck_P2_CHKDSK()
	If $HealthCheck_P2_CHKDSKVar = 0 Then
		GUICtrlSetImage($HealthCheck_P2_CHKDSKSlider, "./images/switchon.bmp")
		$HealthCheck_P2_CHKDSKVar = 1
	Else
		GUICtrlSetImage($HealthCheck_P2_CHKDSKSlider, "./images/switchoff.bmp")
		$HealthCheck_P2_CHKDSKVar = 0
	EndIf
EndFunc

Func HealthCheck_P2_FlushDNS()
	If $HealthCheck_P2_FlushDNSVar = 0 Then
		GUICtrlSetImage($HealthCheck_P2_FlushDNSSlider, "./images/switchon.bmp")
		$HealthCheck_P2_FlushDNSVar = 1
	Else
		GUICtrlSetImage($HealthCheck_P2_FlushDNSSlider, "./images/switchoff.bmp")
		$HealthCheck_P2_FlushDNSVar = 0
	EndIf
EndFunc

Func HealthCheck_P2_DiskCleanup()
	If $HealthCheck_P2_DiskCleanupVar = 0 Then
		GUICtrlSetImage($HealthCheck_P2_DiskCleanupSlider, "./images/switchon.bmp")
		$HealthCheck_P2_DiskCleanupVar = 1
	Else
		GUICtrlSetImage($HealthCheck_P2_DiskCleanupSlider, "./images/switchoff.bmp")
		$HealthCheck_P2_DiskCleanupVar = 0
	EndIf
EndFunc

Func HealthCheck_P2_Processes()
	If $HealthCheck_P2_ProcessesVar = 0 Then
		GUICtrlSetImage($HealthCheck_P2_ProcessesSlider, "./images/switchon.bmp")
		$HealthCheck_P2_ProcessesVar = 1
	Else
		GUICtrlSetImage($HealthCheck_P2_ProcessesSlider, "./images/switchoff.bmp")
		$HealthCheck_P2_ProcessesVar = 0
	EndIf
EndFunc

Func HealthCheck_P2_EventLogs()
	If $HealthCheck_P2_EventLogsVar = 0 Then
		GUICtrlSetImage($HealthCheck_P2_EventLogsSlider, "./images/switchon.bmp")
		$HealthCheck_P2_EventLogsVar = 1
	Else
		GUICtrlSetImage($HealthCheck_P2_EventLogsSlider, "./images/switchoff.bmp")
		$HealthCheck_P2_EventLogsVar = 0
	EndIf
EndFunc

Func HealthCheck_P2_PrintSpool()
	If $HealthCheck_P2_PrintSpoolVar = 0 Then
		GUICtrlSetImage($HealthCheck_P2_PrintSpoolSlider, "./images/switchon.bmp")
		$HealthCheck_P2_PrintSpoolVar = 1
	Else
		GUICtrlSetImage($HealthCheck_P2_PrintSpoolSlider, "./images/switchoff.bmp")
		$HealthCheck_P2_PrintSpoolVar = 0
	EndIf
EndFunc

Func HealthCheck_P2_Updates()
	If $HealthCheck_P2_UpdatesVar = 0 Then
		GUICtrlSetImage($HealthCheck_P2_UpdatesSlider, "./images/switchon.bmp")
		$HealthCheck_P2_UpdatesVar = 1
	Else
		GUICtrlSetImage($HealthCheck_P2_UpdatesSlider, "./images/switchoff.bmp")
		$HealthCheck_P2_UpdatesVar = 0
	EndIf
EndFunc

Func HealthCheck_P2_Firewall()
	If $HealthCheck_P2_FirewallVar = 0 Then
		GUICtrlSetImage($HealthCheck_P2_FirewallSlider, "./images/switchon.bmp")
		$HealthCheck_P2_FirewallVar = 1
	Else
		GUICtrlSetImage($HealthCheck_P2_FirewallSlider, "./images/switchoff.bmp")
		$HealthCheck_P2_FirewallVar = 0
	EndIf
EndFunc

Func HealthCheck_P2_MalwareBytesQ()
	If $HealthCheck_P2_MalwareBytesQVar = 0 Then
		GUICtrlSetImage($HealthCheck_P2_MalwareBytesQSlider, "./images/switchon.bmp")
		$HealthCheck_P2_MalwareBytesQVar = 1
	Else
		GUICtrlSetImage($HealthCheck_P2_MalwareBytesQSlider, "./images/switchoff.bmp")
		$HealthCheck_P2_MalwareBytesQVar = 0
	EndIf
EndFunc

Func HealthCheck_P2_MalwareBytesF()
	If $HealthCheck_P2_MalwareBytesFVar = 0 Then
		GUICtrlSetImage($HealthCheck_P2_MalwareBytesFSlider, "./images/switchon.bmp")
		$HealthCheck_P2_MalwareBytesFVar = 1
	Else
		GUICtrlSetImage($HealthCheck_P2_MalwareBytesFSlider, "./images/switchoff.bmp")
		$HealthCheck_P2_MalwareBytesFVar = 0
	EndIf
EndFunc

Func HealthCheck_P2_MalwareBytesI()
	If $HealthCheck_P2_MalwareBytesIVar = 0 Then
		GUICtrlSetImage($HealthCheck_P2_MalwareBytesISlider, "./images/switchon.bmp")
		$HealthCheck_P2_MalwareBytesIVar = 1
	Else
		GUICtrlSetImage($HealthCheck_P2_MalwareBytesISlider, "./images/switchoff.bmp")
		$HealthCheck_P2_MalwareBytesIVar = 0
	EndIf
EndFunc

Func HealthCheck_P2_PCCleaner()
	If $HealthCheck_P2_PCCleanerVar = 0 Then
		GUICtrlSetImage($HealthCheck_P2_PCCleanerSlider, "./images/switchon.bmp")
		$HealthCheck_P2_PCCleanerVar = 1
	Else
		GUICtrlSetImage($HealthCheck_P2_PCCleanerSlider, "./images/switchoff.bmp")
		$HealthCheck_P2_PCCleanerVar = 0
	EndIf
EndFunc

Func HealthCheck_P2_CCleanerM()
	If $HealthCheck_P2_CCleanerMVar = 0 Then
		GUICtrlSetImage($HealthCheck_P2_CCleanerMSlider, "./images/switchon.bmp")
		$HealthCheck_P2_CCleanerMVar = 1
	Else
		GUICtrlSetImage($HealthCheck_P2_CCleanerMSlider, "./images/switchoff.bmp")
		$HealthCheck_P2_CCleanerMVar = 0
	EndIf
EndFunc

Func HealthCheck_P2_CCleanerA()
	If $HealthCheck_P2_CCleanerAVar = 0 Then
		GUICtrlSetImage($HealthCheck_P2_CCleanerASlider, "./images/switchon.bmp")
		$HealthCheck_P2_CCleanerAVar = 1
	Else
		GUICtrlSetImage($HealthCheck_P2_CCleanerASlider, "./images/switchoff.bmp")
		$HealthCheck_P2_CCleanerAVar = 0
	EndIf
EndFunc