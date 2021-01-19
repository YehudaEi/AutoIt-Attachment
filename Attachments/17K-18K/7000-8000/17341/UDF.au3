Global $save , $aVideoCardInfo, $aOSInfo, $aSoftwareInfo, $aStartupInfo, $aThreadInfo,$aDriveInfo,$aMemoryInfo,$aMotherboardInfo,$aSoundCardInfo,$aProcessorInfo,$aPrinterInfo,$aNetworkInfo,$aMouseInfo,$aMonitorInfo,$aKeyboardInfo,$aBIOSInfo

#region Mainly Hardware Info Functions
#region Global Variables and Constants ;Thanks for this to JSThePatriot, modded some functions
If Not(IsDeclared("$cI_CompName")) Then
	Global	$cI_CompName = @ComputerName
EndIf
Global Const $cI_VersionInfo		= "00.03.08"
Global Const $cI_aName				= 0, _
			 $cI_aDesc				= 4
Global	$wbemFlagReturnImmediately	= 0x10, _	;DO NOT CHANGE
$wbemFlagForwardOnly		= 0x20				;DO NOT CHANGE
Global	$ERR_NO_INFO				= "Array contains no information", _
		$ERR_NOT_OBJ				= "$colItems isnt an object"
#endregion Global Variables and Constants

Func _ComputerGetBIOS(ByRef $aBIOSInfo)
	Local $colItems, $objWMIService, $objItem
	Dim $aBIOSInfo[1][2], $i = 1
	
	$objWMIService = ObjGet("winmgmts:\\" & $cI_Compname & "\root\CIMV2")
	$colItems = $objWMIService.ExecQuery("SELECT * FROM Win32_BIOS", "WQL", $wbemFlagReturnImmediately + $wbemFlagForwardOnly)
	
	If IsObj($colItems) Then
		For $objItem In $colItems
			ReDim $aBIOSInfo[UBound($aBIOSInfo) + 1][2]
			$aBIOSInfo[$i][0]  = $objItem.Name
			$aBIOSInfo[$i][1]  = $objItem.BIOSVersion(0)
			$i += 1
		Next
		$aBIOSInfo[0][0] = UBound($aBIOSInfo) - 1
		If $aBIOSInfo[0][0] < 1 Then
			SetError(1, 1, 0)
		EndIf
	Else
		SetError(1, 2, 0)
	EndIf
EndFunc

Func _ComputerGetKeyboard(ByRef $aKeyboardInfo)
	Local $colItems, $objWMIService, $objItem
	Dim $aKeyboardInfo[1][1], $i = 1
	
	$objWMIService = ObjGet("winmgmts:\\" & $cI_Compname & "\root\CIMV2")
	$colItems = $objWMIService.ExecQuery("SELECT * FROM Win32_Keyboard", "WQL", $wbemFlagReturnImmediately + $wbemFlagForwardOnly)
	
	If IsObj($colItems) Then
		For $objItem In $colItems
			ReDim $aKeyboardInfo[UBound($aKeyboardInfo) + 1][1]
			$aKeyboardInfo[$i][0]  = $objItem.Name
			$i += 1
		Next
		$aKeyboardInfo[0][0] = UBound($aKeyboardInfo) - 1
		If $aKeyboardInfo[0][0] < 1 Then
			SetError(1, 1, 0)
		EndIf
	Else
		SetError(1, 2, 0)
	EndIf
EndFunc

Func _ComputerGetMonitors(ByRef $aMonitorInfo)
	Local $colItems, $objWMIService, $objItem
	Dim $aMonitorInfo[1][1], $i = 1

	$objWMIService = ObjGet("winmgmts:\\" & $cI_Compname & "\root\CIMV2")
	$colItems = $objWMIService.ExecQuery("SELECT * FROM Win32_DesktopMonitor", "WQL", $wbemFlagReturnImmediately + $wbemFlagForwardOnly)

	If IsObj($colItems) Then
		For $objItem In $colItems
			ReDim $aMonitorInfo[UBound($aMonitorInfo) + 1][1]
			$aMonitorInfo[$i][0]	= $objItem.Name
			$i += 1
		Next
		$aMonitorInfo[0][0] = UBound($aMonitorInfo) - 1
		If $aMonitorInfo[0][0] < 1 Then
			SetError(1, 1, 0)
		EndIf
	Else
		SetError(1, 2, 0)
	EndIf
EndFunc

Func _ComputerGetMouse(ByRef $aMouseInfo)
	Local $colItems, $objWMIService, $objItem
	Dim $aMouseInfo[1][1], $i = 1
	
	$objWMIService = ObjGet("winmgmts:\\" & $cI_Compname & "\root\CIMV2")
	$colItems = $objWMIService.ExecQuery("SELECT * FROM Win32_PointingDevice", "WQL", $wbemFlagReturnImmediately + $wbemFlagForwardOnly)
	
	If IsObj($colItems) Then
		For $objItem In $colItems
			ReDim $aMouseInfo[UBound($aMouseInfo) + 1][1]
			$aMouseInfo[$i][0]  = $objItem.Name
			$i += 1
		Next
		$aMouseInfo[0][0] = UBound($aMouseInfo) - 1
		If $aMouseInfo[0][0] < 1 Then
			SetError(1, 1, 0)
		EndIf
	Else
		SetError(1, 2, 0)
	EndIf
EndFunc

Func _ComputerGetNetworkCards(ByRef $aNetworkInfo)
	Local $colItems, $objWMIService, $objItem
	Dim $aNetworkInfo[1][1], $i = 1
	
	$objWMIService = ObjGet("winmgmts:\\" & $cI_Compname & "\root\CIMV2")
	$colItems = $objWMIService.ExecQuery("SELECT * FROM Win32_NetworkAdapter", "WQL", $wbemFlagReturnImmediately + $wbemFlagForwardOnly)
	
	If IsObj($colItems) Then
		For $objItem In $colItems
			ReDim $aNetworkInfo[UBound($aNetworkInfo) + 1][1]
			$aNetworkInfo[$i][0]  = $objItem.Name
			$i += 1
		Next
		$aNetworkInfo[0][0] = UBound($aNetworkInfo) - 1
		If $aNetworkInfo[0][0] < 1 Then
			SetError(1, 1, 0)
		EndIf
	Else
		SetError(1, 2, 0)
	EndIf
EndFunc

Func _ComputerGetPrinters(ByRef $aPrinterInfo)
	Local $colItems, $objWMIService, $objItem
	Dim $aPrinterInfo[1][1], $i = 1
	
	$objWMIService = ObjGet("winmgmts:\\" & $cI_Compname & "\root\CIMV2")
	$colItems = $objWMIService.ExecQuery("SELECT * FROM Win32_Printer", "WQL", $wbemFlagReturnImmediately + $wbemFlagForwardOnly)
	
	If IsObj($colItems) Then
		For $objItem In $colItems
			ReDim $aPrinterInfo[UBound($aPrinterInfo) + 1][1]
			$aPrinterInfo[$i][0]  = $objItem.Name
			$i += 1
		Next
		$aPrinterInfo[0][0] = UBound($aPrinterInfo) - 1
		If $aPrinterInfo[0][0] < 1 Then
			SetError(1, 1, 0)
		EndIf
	Else
		SetError(1, 2, 0)
	EndIf
EndFunc

Func _ComputerGetProcessors(ByRef $aProcessorInfo)
	Local $colItems, $objWMIService, $objItem
	Dim $aProcessorInfo[1][4], $i = 1
	
	$objWMIService = ObjGet("winmgmts:\\" & $cI_Compname & "\root\CIMV2")
	$colItems = $objWMIService.ExecQuery("SELECT * FROM Win32_Processor", "WQL", $wbemFlagReturnImmediately + $wbemFlagForwardOnly)
	
	If IsObj($colItems) Then
		For $objItem In $colItems
			ReDim $aProcessorInfo[UBound($aProcessorInfo) + 1][4]
			$aProcessorInfo[$i][0]  = StringStripWS($objItem.Name, 1)
			$aProcessorInfo[$i][1] = $objItem.ExtClock
			$aProcessorInfo[$i][2] = $objItem.L2CacheSize
			$aProcessorInfo[$i][3] = $objItem.SocketDesignation
			$i += 1
		Next
		$aProcessorInfo[0][0] = UBound($aProcessorInfo) - 1
		If $aProcessorInfo[0][0] < 1 Then
			SetError(1, 1, 0)
		EndIf
	Else
		SetError(1, 2, 0)
	EndIf
EndFunc
Func _ComputerGetSoundCards(ByRef $aSoundCardInfo)
	Local $colItems, $objWMIService, $objItem
	Dim $aSoundCardInfo[1][1], $i = 1
	
	$objWMIService = ObjGet("winmgmts:\\" & $cI_Compname & "\root\CIMV2")
	$colItems = $objWMIService.ExecQuery("SELECT * FROM Win32_SoundDevice", "WQL", $wbemFlagReturnImmediately + $wbemFlagForwardOnly)
	
	If IsObj($colItems) Then
		For $objItem In $colItems
			ReDim $aSoundCardInfo[UBound($aSoundCardInfo) + 1][1]
			$aSoundCardInfo[$i][0]  = $objItem.Name
			$i += 1
		Next
		$aSoundCardInfo[0][0] = UBound($aSoundCardInfo) - 1
		If $aSoundCardInfo[0][0] < 1 Then
			SetError(1, 1, 0)
		EndIf
	Else
		SetError(1, 2, 0)
	EndIf
EndFunc

Func _ComputerGetMotherboard(ByRef $aMotherboardInfo)
	Local $colItems, $objWMIService, $objItem
	Dim $aMotherboardInfo[1][1], $i = 1

	$objWMIService = ObjGet("winmgmts:\\" & $cI_Compname & "\root\CIMV2")
	$colItems = $objWMIService.ExecQuery("SELECT * FROM Win32_MotherboardDevice", "WQL", $wbemFlagReturnImmediately + $wbemFlagForwardOnly)

	If IsObj($colItems) Then
		For $objItem In $colItems
			ReDim $aMotherboardInfo[UBound($aMotherboardInfo) + 1][1]
			$aMotherboardInfo[$i][0]	= $objItem.Name
			$i += 1
		Next
		$aMotherboardInfo[0][0] = UBound($aMotherboardInfo) - 1
		If $aMotherboardInfo[0][0] < 1 Then
			SetError(1, 1, 0)
		EndIf
	Else
		SetError(1, 2, 0)
	EndIf
EndFunc

Func _ComputerGetMemory(ByRef $aMemoryInfo)
	Local $colItems, $objWMIService, $objItem
	Dim $aMemoryInfo[1][4], $i = 1

	$objWMIService = ObjGet("winmgmts:\\" & $cI_Compname & "\root\CIMV2")
	$colItems = $objWMIService.ExecQuery("SELECT * FROM Win32_PhysicalMemory", "WQL", $wbemFlagReturnImmediately + $wbemFlagForwardOnly)

	If IsObj($colItems) Then
		For $objItem In $colItems
			ReDim $aMemoryInfo[UBound($aMemoryInfo) + 1][4]
			$aMemoryInfo[$i][0]	= $objItem.Name
			$aMemoryInfo[$i][1]	= $objItem.DeviceLocator
			$aMemoryInfo[$i][2] = $objItem.FormFactor
			$aMemoryInfo[$i][3]	= $objItem.Speed
			$i += 1
		Next
		$aMemoryInfo[0][0] = UBound($aMemoryInfo) - 1
		If $aMemoryInfo[0][0] < 1 Then
			SetError(1, 1, 0)
		EndIf
	Else
		SetError(1, 2, 0)
	EndIf
EndFunc

Func _ComputerGetDrives(ByRef $aDriveInfo, $sDriveType = "FIXED")
	Local $drive
	$drive = DriveGetDrive($sDriveType)
	If NOT @error Then
		Dim $aDriveInfo[UBound($drive)][6]
		$aDriveInfo[0][0] = $drive[0]
		For $i = 1 To $aDriveInfo[0][0] Step 1
			$aDriveInfo[$i][0] = StringUpper($drive[$i] & "\")
			$aDriveInfo[$i][1] = DriveGetFileSystem($drive[$i])
			If @error Then SetError(1, 2, 0)
			$aDriveInfo[$i][2] = DriveGetLabel($drive[$i])
			If @error Then SetError(1, 3, 0)
			$aDriveInfo[$i][3] = DriveGetSerial($drive[$i])
			If @error Then SetError(1, 4, 0)
			$aDriveInfo[$i][4] = Round(DriveSpaceFree($drive[$i]))
			If @error Then SetError(1, 5, 0)
			$aDriveInfo[$i][5] = Round(DriveSpaceTotal($drive[$i]))
			If @error Then SetError(1, 6, 0)
		Next
	Else
		SetError(1, 1, 0)
	EndIf
EndFunc

Func __StringVersion() ;Thanks for this to JSThePatriot
	Return $cI_VersionInfo
EndFunc ;_StringVersion

Func __StringToDate($dtmDate) ;Thanks for this to JSThePatriot
	Return (StringMid($dtmDate, 5, 2) & "/" & _
			StringMid($dtmDate, 7, 2) & "/" & StringLeft($dtmDate, 4) _
			& " " & StringMid($dtmDate, 9, 2) & ":" & StringMid($dtmDate, 11, 2) & ":" & StringMid($dtmDate,13, 2))
		EndFunc
		
Func _ComputerGetThreads(ByRef $aThreadInfo) ;Thanks for this to JSThePatriot
	Local $colItems, $objWMIService, $objItem
	Dim $aThreadInfo[1][20], $i = 1
	
	$objWMIService = ObjGet("winmgmts:\\" & $cI_Compname & "\root\CIMV2")
	$colItems = $objWMIService.ExecQuery("SELECT * FROM Win32_Thread", "WQL", $wbemFlagReturnImmediately + $wbemFlagForwardOnly)
	
	If IsObj($colItems) Then
		For $objItem In $colItems
			ReDim $aThreadInfo[UBound($aThreadInfo) + 1][20]
			$aThreadInfo[$i][0]  = $objItem.Name
			$aThreadInfo[$i][1]  = $objItem.CreationClassName
			$aThreadInfo[$i][2]  = $objItem.CSCreationClassName
			$aThreadInfo[$i][3]  = $objItem.CSName
			$aThreadInfo[$i][4]  = $objItem.Description
			$aThreadInfo[$i][5]  = $objItem.ElapsedTime
			$aThreadInfo[$i][6]  = $objItem.ExecutionState
			$aThreadInfo[$i][7]  = $objItem.Handle
			$aThreadInfo[$i][8]  = $objItem.KernelModeTime
			$aThreadInfo[$i][9]  = $objItem.OSCreationClassName
			$aThreadInfo[$i][10] = $objItem.OSName
			$aThreadInfo[$i][11] = $objItem.Priority
			$aThreadInfo[$i][12] = $objItem.PriorityBase
			$aThreadInfo[$i][13] = $objItem.ProcessCreationClassName
			$aThreadInfo[$i][14] = $objItem.ProcessHandle
			$aThreadInfo[$i][15] = $objItem.StartAddress
			$aThreadInfo[$i][16] = $objItem.Status
			$aThreadInfo[$i][17] = $objItem.ThreadState
			$aThreadInfo[$i][18] = $objItem.ThreadWaitReason
			$aThreadInfo[$i][19] = $objItem.UserModeTime
			$i += 1
		Next
		$aThreadInfo[0][0] = UBound($aThreadInfo) - 1
		If $aThreadInfo[0][0] < 1 Then
			SetError(1, 1, 0)
		EndIf
	Else
		SetError(1, 2, 0)
	EndIf
EndFunc
		
Func _ComputerGetSoftware(ByRef $aSoftwareInfo) ;Thanks for this to JSThePatriot
	Local Const $UnInstKey	= "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall"
	Local $i = 1
	Dim $aSoftwareInfo[1][4]
	
	While 1
		$AppKey	= RegEnumKey($UnInstKey, $i)
		If @error <> 0 Then ExitLoop
		ReDim $aSoftwareInfo[UBound($aSoftwareInfo) + 1][4]
		$aSoftwareInfo[$i][0]	= StringStripWS(StringReplace(RegRead($UnInstKey & "\" & $AppKey, "DisplayName"), " (remove only)", ""), 3)
		$aSoftwareInfo[$i][1]	= StringStripWS(RegRead($UnInstKey & "\" & $AppKey, "DisplayVersion"), 3)
		$aSoftwareInfo[$i][2]	= StringStripWS(RegRead($UnInstKey & "\" & $AppKey, "Publisher"), 3)
		$aSoftwareInfo[$i][3]	= StringStripWS(RegRead($UnInstKey & "\" & $AppKey, "UninstallString"), 3)
		$i += 1
	WEnd
	
	$aSoftwareInfo[0][0] = UBound($aSoftwareInfo, 1) - 1
	If $aSoftwareInfo[0][0] < 1 Then
		SetError(1, 1, 0)
	EndIf
EndFunc

Func _ComputerGetStartup(ByRef $aStartupInfo) ;Thanks for this to JSThePatriot
	Local $colItems, $objWMIService, $objItem
	Dim $aStartupInfo[1][6], $i = 1
	
	$objWMIService = ObjGet("winmgmts:\\" & $cI_Compname & "\root\CIMV2")
	$colItems = $objWMIService.ExecQuery("SELECT * FROM Win32_StartupCommand", "WQL", $wbemFlagReturnImmediately + $wbemFlagForwardOnly)
	
	If IsObj($colItems) Then
		For $objItem In $colItems
			ReDim $aStartupInfo[UBound($aStartupInfo) + 1][6]
			$aStartupInfo[$i][0] = $objItem.Name
			$aStartupInfo[$i][1] = $objItem.User
			$aStartupInfo[$i][2] = $objItem.Location
			$aStartupInfo[$i][3] = $objItem.Command
			$aStartupInfo[$i][4] = $objItem.Description
			$aStartupInfo[$i][5] = $objItem.SettingID
			$i += 1
		Next
		$aStartupInfo[0][0] = UBound($aStartupInfo) - 1
		If $aStartupInfo[0][0] < 1 Then
			SetError(1, 1, 0)
		EndIf
	Else
		SetError(1, 2, 0)
	EndIf
EndFunc

Func _ComputerGetVideoCards(ByRef $aVideoInfo) ;Thanks for this to JSThePatriot
	Local $colItems, $objWMIService, $objItem
	Dim $aVideoInfo[1][59], $i = 1
	
	$objWMIService = ObjGet("winmgmts:\\" & $cI_Compname & "\root\CIMV2")
	$colItems = $objWMIService.ExecQuery("SELECT * FROM Win32_VideoController", "WQL", $wbemFlagReturnImmediately + $wbemFlagForwardOnly)
	
	If IsObj($colItems) Then
		For $objItem In $colItems
			ReDim $aVideoInfo[UBound($aVideoInfo) + 1][59]
			$aVideoInfo[$i][0]  = $objItem.Name
			$aVideoInfo[$i][1]  = $objItem.AdapterDACType
			$aVideoInfo[$i][2] = $objItem.DriverVersion
			$aVideoInfo[$i][3] = $objItem.VideoProcessor
			$aVideoInfo[$i][4]  = $objItem.AdapterRAM
			$i += 1
		Next
		$aVideoInfo[0][0] = UBound($aVideoInfo) - 1
		If $aVideoInfo[0][0] < 1 Then
			SetError(1, 1, 0)
		EndIf
	Else
		SetError(1, 2, 0)
	EndIf
EndFunc

Func _ComputerGetOSs(ByRef $aOSInfo) ;Thanks for this to JSThePatriot
	Local $colItems, $objWMIService, $objItem
	Dim $aOSInfo[1][60], $i = 1
	
	$objWMIService = ObjGet("winmgmts:\\" & $cI_Compname & "\root\CIMV2")
	$colItems = $objWMIService.ExecQuery("SELECT * FROM Win32_OperatingSystem", "WQL", $wbemFlagReturnImmediately + $wbemFlagForwardOnly)
	
	If IsObj($colItems) Then
		For $objItem In $colItems
			ReDim $aOSInfo[UBound($aOSInfo) + 1][60]
			$aOSInfo[$i][0]  = $objItem.Name
			$aOSInfo[$i][1]  = $objItem.BootDevice
			$aOSInfo[$i][2]  = $objItem.BuildNumber
			$aOSInfo[$i][3]  = $objItem.BuildType
			$aOSInfo[$i][4]  = $objItem.Description
			$aOSInfo[$i][5]  = $objItem.CodeSet
			$aOSInfo[$i][6]  = $objItem.CountryCode
			$aOSInfo[$i][7]  = $objItem.CreationClassName
			$aOSInfo[$i][8]  = $objItem.CSCreationClassName
			$aOSInfo[$i][9]  = $objItem.CSDVersion
			$aOSInfo[$i][10] = $objItem.CSName
			$aOSInfo[$i][11] = $objItem.CurrentTimeZone
			$aOSInfo[$i][12] = $objItem.DataExecutionPrevention_32BitApplications
			$aOSInfo[$i][13] = $objItem.DataExecutionPrevention_Available
			$aOSInfo[$i][14] = $objItem.DataExecutionPrevention_Drivers
			$aOSInfo[$i][15] = $objItem.DataExecutionPrevention_SupportPolicy
			$aOSInfo[$i][16] = $objItem.Debug
			$aOSInfo[$i][17] = $objItem.Distributed
			$aOSInfo[$i][18] = $objItem.EncryptionLevel
			$aOSInfo[$i][19] = $objItem.ForegroundApplicationBoost
			$aOSInfo[$i][20] = $objItem.FreePhysicalMemory
			$aOSInfo[$i][21] = $objItem.FreeSpaceInPagingFiles
			$aOSInfo[$i][22] = $objItem.FreeVirtualMemory
			$aOSInfo[$i][23] = __StringToDate($objItem.InstallDate)
			$aOSInfo[$i][24] = $objItem.LargeSystemCache
			$aOSInfo[$i][25] = __StringToDate($objItem.LastBootUpTime)
			$aOSInfo[$i][26] = __StringToDate($objItem.LocalDateTime)
			$aOSInfo[$i][27] = $objItem.Locale
			$aOSInfo[$i][28] = $objItem.Manufacturer
			$aOSInfo[$i][29] = $objItem.MaxNumberOfProcesses
			$aOSInfo[$i][30] = $objItem.MaxProcessMemorySize
			$aOSInfo[$i][31] = $objItem.NumberOfLicensedUsers
			$aOSInfo[$i][32] = $objItem.NumberOfProcesses
			$aOSInfo[$i][33] = $objItem.NumberOfUsers
			$aOSInfo[$i][34] = $objItem.Organization
			$aOSInfo[$i][35] = $objItem.OSLanguage
			$aOSInfo[$i][36] = $objItem.OSProductSuite
			$aOSInfo[$i][37] = $objItem.OSType
			$aOSInfo[$i][38] = $objItem.OtherTypeDescription
			$aOSInfo[$i][39] = $objItem.PlusProductID
			$aOSInfo[$i][40] = $objItem.PlusVersionNumber
			$aOSInfo[$i][41] = $objItem.Primary
			$aOSInfo[$i][42] = $objItem.ProductType
			$aOSInfo[$i][43] = $objItem.QuantumLength
			$aOSInfo[$i][44] = $objItem.QuantumType
			$aOSInfo[$i][45] = $objItem.RegisteredUser
			$aOSInfo[$i][46] = $objItem.SerialNumber
			$aOSInfo[$i][47] = $objItem.ServicePackMajorVersion
			$aOSInfo[$i][48] = $objItem.ServicePackMinorVersion
			$aOSInfo[$i][49] = $objItem.SizeStoredInPagingFiles
			$aOSInfo[$i][50] = $objItem.Status
			$aOSInfo[$i][51] = $objItem.SuiteMask
			$aOSInfo[$i][52] = $objItem.SystemDevice
			$aOSInfo[$i][53] = $objItem.SystemDirectory
			$aOSInfo[$i][54] = $objItem.SystemDrive
			$aOSInfo[$i][55] = $objItem.TotalSwapSpaceSize
			$aOSInfo[$i][56] = $objItem.TotalVirtualMemorySize
			$aOSInfo[$i][57] = $objItem.TotalVisibleMemorySize
			$aOSInfo[$i][58] = $objItem.Version
			$aOSInfo[$i][59] = $objItem.WindowsDirectory
			$i += 1
		Next
		$aOSInfo[0][0] = UBound($aOSInfo) - 1
		If $aOSInfo[0][0] < 1 Then
			SetError(1, 1, 0)
		EndIf
	Else
		SetError(1, 2, 0)
	EndIf
EndFunc
#endregion Thanks for this to JSThePatriot