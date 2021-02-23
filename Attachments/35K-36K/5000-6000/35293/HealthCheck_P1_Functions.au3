Func HealthCheck_P1_Back()
	GUISetState(@SW_HIDE, $HealthCheck_Page1)
	GUISetState(@SW_SHOW, $Menu)
EndFunc

Func HealthCheck_P1_Next()
	GUISetState(@SW_HIDE, $HealthCheck_Page1)
	GUISetState(@SW_SHOW, $HealthCheck_Page2)
EndFunc

Func HealthCheck_P1_Reboot()
	If $HealthCheck_P1_RebootSlideVar = 0 Then
		GUICtrlSetImage($HealthCheck_P1_RebootSlide, "./images/switchon.bmp")
		$HealthCheck_P1_RebootSlideVar = 1
	Else
		GUICtrlSetImage($HealthCheck_P1_RebootSlide, "./images/switchoff.bmp")
		$HealthCheck_P1_RebootSlideVar = 0
	EndIf
EndFunc

Func HealthCheck_P1_Report()
	If $HealthCheck_P1_ReportSlideVar = 0 Then
		GUICtrlSetImage($HealthCheck_P1_ReportSlide, "./images/switchon.bmp")
		$HealthCheck_P1_ReportSlideVar = 1
	Else
		GUICtrlSetImage($HealthCheck_P1_ReportSlide, "./images/switchoff.bmp")
		$HealthCheck_P1_ReportSlideVar = 0
	EndIf
EndFunc

Func HealthCheck_P1_Registry()
	If $HealthCheck_P1_RegistrySlideVar = 0 Then
		GUICtrlSetImage($HealthCheck_P1_RegistrySlide, "./images/switchon.bmp")
		$HealthCheck_P1_RegistrySlideVar = 1
	Else
		GUICtrlSetImage($HealthCheck_P1_RegistrySlide, "./images/switchoff.bmp")
		$HealthCheck_P1_RegistrySlideVar = 0
	EndIf
EndFunc

Func HealthCheck_P1_Restore()
	If $HealthCheck_P1_RestorePointSlideVar = 0 Then
		GUICtrlSetImage($HealthCheck_P1_RestorePointSlide, "./images/switchon.bmp")
		$HealthCheck_P1_RestorePointSlideVar = 1
	Else
		GUICtrlSetImage($HealthCheck_P1_RestorePointSlide, "./images/switchoff.bmp")
		$HealthCheck_P1_RestorePointSlideVar = 0
	EndIf
EndFunc