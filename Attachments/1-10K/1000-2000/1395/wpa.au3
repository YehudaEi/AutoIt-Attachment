#include-once

; info at http://msdn.microsoft.com/library/default.asp?url=/library/en-us/wmisdk/wmi/win32_windowsproductactivation.asp
; still needs some testing and code improvement
; currently (March,09,2005) this works only with development version of autoit
; get current beta from http://www.autoitscript.com/autoit3/files/beta/autoit/
; then get the newest build from                                                          and extract the zip file
; in the autoit folder



;===============================================================================
;
; Function Name:    _WPA_ActivationRequired()
; Description:      Checks if Windows needs to be activated
; Parameter(s):     $strComputer - the local or remote computer (name or IP)
; Requirement(s):   none
; Return Value(s):  If Yes - 1
;                   If No  - 0
; Author(s):        smiley
;
; Status:           Tested
;
;===============================================================================
;
Func _WPA_ActivationRequired($strComputer = ".")
	$oWMI = ObjGet ("winmgmts:{impersonationLevel=impersonate}!\\" & $strComputer & "\root\cimv2")
	$oWPAColl = $oWMI.ExecQuery ("Select * from Win32_WindowsProductActivation")
	For $WPAobj IN $oWPAColl
		$ret = $WPAobj.ActivationRequired
	Next
	Return ($ret)
EndFunc   ;==>_WPA_ActivationRequired

;===============================================================================
;
; Function Name:    _WPA_Caption()
; Description:
; Parameter(s):     $strComputer - the local or remote computer (name or IP)
; Requirement(s):   none
; Return Value(s):  Returns the caption
; Author(s):        smiley
;
; Status:           Untested
;
;===============================================================================
;
Func _WPA_Caption($strComputer = ".")
	$oWMI = ObjGet ("winmgmts:{impersonationLevel=impersonate}!\\" & $strComputer & "\root\cimv2")
	$oWPAColl = $oWMI.ExecQuery ("Select * from Win32_WindowsProductActivation")
	For $WPAobj IN $oWPAColl
		$ret = $WPAobj.Caption
	Next
	Return ($ret)
EndFunc   ;==>_WPA_Caption


;===============================================================================
;
; Function Name:    _WPA_Description()
; Description:
; Parameter(s):     $strComputer - the local or remote computer (name or IP)
; Requirement(s):   none
; Return Value(s):  Returns the description
; Author(s):        smiley
;
; Status:           Untested
;
;===============================================================================
;
Func _WPA_Description($strComputer = ".")
	$oWMI = ObjGet ("winmgmts:{impersonationLevel=impersonate}!\\" & $strComputer & "\root\cimv2")
	$oWPAColl = $oWMI.ExecQuery ("Select * from Win32_WindowsProductActivation")
	For $WPAobj IN $oWPAColl
		$ret = $WPAobj.Description
	Next
	Return ($ret)
EndFunc   ;==>_WPA_Description

;===============================================================================
;
; Function Name:    _WPA_IsNotificationOn()
; Description:      Checks if the WPA notification icon (Tray) is on
; Parameter(s):     $strComputer - the local or remote computer (name or IP)
; Requirement(s):   none
; Return Value(s):  If Yes - 1
;                   If No  - 0
; Author(s):        smiley
;
;===============================================================================
;
Func _WPA_IsNotificationOn($strComputer = ".")
	$oWMI = ObjGet ("winmgmts:{impersonationLevel=impersonate}!\\" & $strComputer & "\root\cimv2")
	$oWPAColl = $oWMI.ExecQuery ("Select * from Win32_WindowsProductActivation")
	For $WPAobj IN $oWPAColl
		$ret = $WPAobj.IsNotificationOn
	Next
	Return ($ret)
EndFunc   ;==>_WPA_IsNotificationOn

Func _WPA_RemainingEvaluationPeriod($strComputer = ".")
	$oWMI = ObjGet ("winmgmts:{impersonationLevel=impersonate}!\\" & $strComputer & "\root\cimv2")
	$oWPAColl = $oWMI.ExecQuery ("Select * from Win32_WindowsProductActivation")
	For $WPAobj IN $oWPAColl
		$ret = $WPAobj.RemainingEvaluationPeriod
	Next
	Return ($ret)
EndFunc   ;==>_WPA_RemainingEvaluationPeriod

Func _WPA_ProductID($strComputer = ".")
	$oWMI = ObjGet ("winmgmts:{impersonationLevel=impersonate}!\\" & $strComputer & "\root\cimv2")
	$oWPAColl = $oWMI.ExecQuery ("Select * from Win32_WindowsProductActivation")
	For $WPAobj IN $oWPAColl
		$ret = $WPAobj.ProductID
	Next
	Return ($ret)
EndFunc   ;==>_WPA_ProductID

Func _WPA_RemainingGracePeriod($strComputer = ".")
	$oWMI = ObjGet ("winmgmts:{impersonationLevel=impersonate}!\\" & $strComputer & "\root\cimv2")
	$oWPAColl = $oWMI.ExecQuery ("Select * from Win32_WindowsProductActivation")
	For $WPAobj IN $oWPAColl
		$ret = $WPAobj.RemainingGracePeriod
	Next
	Return ($ret)
EndFunc   ;==>_WPA_RemainingGracePeriod

Func _WPA_ServerName($strComputer = ".")
	$oWMI = ObjGet ("winmgmts:{impersonationLevel=impersonate}!\\" & $strComputer & "\root\cimv2")
	$oWPAColl = $oWMI.ExecQuery ("Select * from Win32_WindowsProductActivation")
	For $WPAobj IN $oWPAColl
		$ret = $WPAobj.ServerName
	Next
	Return ($ret)
EndFunc   ;==>_WPA_ServerName

Func _WPA_SettingID($strComputer = ".")
	$oWMI = ObjGet ("winmgmts:{impersonationLevel=impersonate}!\\" & $strComputer & "\root\cimv2")
	$oWPAColl = $oWMI.ExecQuery ("Select * from Win32_WindowsProductActivation")
	For $WPAobj IN $oWPAColl
		$ret = $WPAobj.SettingID
	Next
	Return ($ret)
EndFunc   ;==>_WPA_SettingID

Func _WPA_ActivateOffline($ConfirmID, $strComputer = ".")
	$oWMI = ObjGet ("winmgmts:{impersonationLevel=impersonate}!\\" & $strComputer & "\root\cimv2")
	$oWPAColl = $oWMI.ExecQuery ("Select * from Win32_WindowsProductActivation")
	For $WPAobj IN $oWPAColl
		$ret = $WPAobj.ActivateOffline ($ConfirmID)
	Next
	Return ($ret)
EndFunc   ;==>_WPA_ActivateOffline

Func _WPA_ActivateOnline($strComputer = ".")
	$oWMI = ObjGet ("winmgmts:{impersonationLevel=impersonate}!\\" & $strComputer & "\root\cimv2")
	$oWPAColl = $oWMI.ExecQuery ("Select * from Win32_WindowsProductActivation")
	For $WPAobj IN $oWPAColl
		$ret = $WPAobj.ActivateOnline ()
	Next
	Return ($ret)
EndFunc   ;==>_WPA_ActivateOnline

Func _WPA_GetInstallationID($strComputer = ".")
	$oWMI = ObjGet ("winmgmts:{impersonationLevel=impersonate}!\\" & $strComputer & "\root\cimv2")
	$oWPAColl = $oWMI.ExecQuery ("Select * from Win32_WindowsProductActivation")
	For $WPAobj IN $oWPAColl
		$ret = $WPAobj.GetInstallationID ()
	Next
	Return ($ret)
EndFunc   ;==>_WPA_GetInstallationID

;===============================================================================
;
; Function Name:    _WPA_SetNotification()
; Description:      sets the state (on/off) of the WPA icon in the tray
;                   (only works if windows is not already activated)
; Parameter(s):     $enable (1/0)- switch the notification icon on or off
;                   $strComputer - the local or remote computer (name or IP)
; Requirement(s):   none
; Return Value(s):  returns the result of the SetNotification($enable) WMI/COM function
; Author(s):        smiley
;
;===============================================================================
;
Func _WPA_SetNotification($enable = "1", $strComputer = ".")
	$oWMI = ObjGet ("winmgmts:{impersonationLevel=impersonate}!\\" & $strComputer & "\root\cimv2")
	$oWPAColl = $oWMI.ExecQuery ("Select * from Win32_WindowsProductActivation")
	For $WPAobj IN $oWPAColl
		$ret = $WPAobj.SetNotification ($enable)
	Next
	Return ($ret)
EndFunc   ;==>_WPA_SetNotification

;===============================================================================
;
; Function Name:    _WPA_SetProductKey()
; Description:      replaces the current Windows key with a new key
; Parameter(s):     $newkey      - the windows key (must be a vaild key for your windows version)
;                   $strComputer - the local or remote computer (name or IP)
; Requirement(s):   none
; Return Value(s):  returns the result of the SetProductKey($newkey) WMI/COM function
; Author(s):        smiley
;
;===============================================================================
;
Func _WPA_SetProductKey($newkey, $strComputer = ".")
	$oWMI = ObjGet ("winmgmts:{impersonationLevel=impersonate}!\\" & $strComputer & "\root\cimv2")
	$oWPAColl = $oWMI.ExecQuery ("Select * from Win32_WindowsProductActivation")
	For $WPAobj IN $oWPAColl
		$ret = $WPAobj.SetProductKey ($newkey)
	Next
	Return ($ret)
EndFunc   ;==>_WPA_SetProductKey


;===============================================================================
;
; Function Name:    _WPA_getBinaryDPID_VS2003()
; Description:      gets the Visual Studio 2003 DigitalProductID from the registry
; Parameter(s):     none
; Requirement(s):   none
; Return Value(s):  Returns the binary Visual Studio 2003 DigitalProductID as stored in the registry
; Author(s):        smiley
;
;===============================================================================
; TBD: Error checking and SetError
Func _WPA_getBinaryDPID_VS2003()
	return (RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Office\10.0\Registration\{E05F0409-0E9A-48A1-AC04-E35E3033604A}", "DigitalProductID"))
EndFunc   ;==>_WPA_getBinaryDPID_VS2003

;===============================================================================
;
; Function Name:    _WPA_getBinaryDPID_WINDOWS()
; Description:      gets the Windows DigitalProductID from the registry
; Parameter(s):     none
; Requirement(s):   none
; Return Value(s):  Returns the binary Windows DigitalProductID as stored in the registry
; Author(s):        smiley
;
;===============================================================================
; TBD: Error checking and SetError
Func _WPA_getBinaryDPID_WINDOWS()
	return (RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion", "DigitalProductID"))
EndFunc   ;==>_WPA_getBinaryDPID_WINDOWS

;===============================================================================
;
; Function Name:    _WPA_getBinaryDPID_OFFICE2K3()
; Description:      gets the Office 2003 DigitalProductID from the registry
; Parameter(s):     none
; Requirement(s):   none
; Return Value(s):  Returns the binary 2003 Office DigitalProductID as stored in the registry
; Author(s):        smiley
;
;===============================================================================
; TBD: Error checking and SetError
Func _WPA_getBinaryDPID_OFFICE2K3()
	return (RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Office\11.0\Registration\{90110407-6000-11D3-8CFE-0150048383C9}", "DigitalProductID"))
EndFunc   ;==>_WPA_getBinaryDPID_OFFICE2K3


;===============================================================================
;
; Function Name:    _WPA_getBinaryDPID_OFFICEXP()
; Description:      gets the OfficeXP DigitalProductID from the registry
; Parameter(s):     none
; Requirement(s):   none
; Return Value(s):  Returns the binary OfficeXP DigitalProductID as stored in the registry
; Author(s):        smiley
;
;===============================================================================
; TBD: Error checking and SetError
Func _WPA_getBinaryDPID_OFFICEXP()
	return (RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Office\10.0\Registration\{90280409-6000-11D3-8CFE-0050048383C9}", "DigitalProductID"))
EndFunc   ;==>_WPA_getBinaryDPID_OFFICEXP

;===============================================================================
;
; Function Name:    _WPA_DecodeProductKey()
; Description:      decodes the PID to get the product key
; Parameter(s):     $BinaryDPID - the PID as stored in registry
; Requirement(s):   none
; Return Value(s):  Returns the decoded Windows/Office/Visual studio/etc. product key
; Author(s):        found this in the Forum, who made it?!
;
;===============================================================================
; TBD: Error checking and SetError
Func _WPA_DecodeProductKey($BinaryDPID)
	Local $bKey[15]
	Local $sKey[29]
	Local $Digits[24]
	Local $Value = 0
	Local $hi = 0
	Local $n = 0
	Local $i = 0
	Local $dlen = 29
	Local $slen = 15
	Local $Result
	
	$Digits = StringSplit("BCDFGHJKMPQRTVWXY2346789", "")
	
	$binaryDPID = StringMid($binaryDPID, 105, 30)
	
	For $i = 1 To 29 Step 2
		$bKey[Int($i / 2) ] = Dec(StringMid($binaryDPID, $i, 2))
	Next
	
	For $i = $dlen - 1 To 0 Step - 1
		If Mod(($i + 1), 6) = 0 Then
			$sKey[$i] = "-" 
		Else
			$hi = 0
			For $n = $slen - 1 To 0 Step - 1
				$Value = BitOR(BitShift($hi, -8), $bKey[$n])
				$bKey[$n] = Int($Value / 24)
				$hi = Mod($Value, 24)
			Next
			$sKey[$i] = $Digits[$hi + 1]
		EndIf
		
	Next
	For $i = 0 To 28
		$Result = $Result & $sKey[$i]
	Next
	
	Return $Result
EndFunc   ;==>_WPA_DecodeProductKey

