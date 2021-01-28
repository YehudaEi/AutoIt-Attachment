#include-once
; #INDEX# =======================================================================================================================
; Title .........: Drive Info
; AutoIt Version : 3.2.10++
; Language ......: English
; Description ...: This module contains various functions for gathering drive information.
; ===============================================================================================================================

; #CURRENT# =====================================================================================================================
;_DriveGetFloppyDrive
;_DriveGetCDROMDrive
;_DriveGetDiskDrive
;_DriveTranslateAvailability
;_DriveTranslateCapabilities
;_DriveTranslateConfigManagerErrorCode
;_DriveTranslateConfigManagerUserConfig
;_DriveTranslatePowerManagementCapabilities
;_DriveTranslateMediaLoaded
;_DriveTranslateStatusInfo
; ===============================================================================================================================

; #INTERNAL_USE_ONLY#============================================================================================================
;_DriveTranslateCapability
;_DriveTranslatePowerManagementCapability
; ===============================================================================================================================
#Region Global Variables and Constants
If Not(IsDeclared("$cI_CompName")) Then
	Global	$cI_CompName = @ComputerName
EndIf
Global	$wbemFlagReturnImmediately	= 0x10, _	;DO NOT CHANGE
$wbemFlagForwardOnly		= 0x20				;DO NOT CHANGE
#EndRegion Global Variables and Constants
#Region Drives
;===============================================================================
; Description:      collects Floppy Drive Information
; Parameter(s):     $aFloppyDrive - By Reference - Drive Information array.
; Requirement(s):   None
; Return Value(s):  On Success - Returns array of Floppy Drive Information.
;						$aFloppyDrive[$i][0]  = Availability
;						$aFloppyDrive[$i][1]  = Capabilities
;						$aFloppyDrive[$i][2]  = CapabilityDescriptions
;						$aFloppyDrive[$i][3]  = Caption
;						$aFloppyDrive[$i][4]  = CompressionMethod
;						$aFloppyDrive[$i][5]  = ConfigManagerErrorCode
;						$aFloppyDrive[$i][6]  = ConfigManagerUserConfig
;						$aFloppyDrive[$i][7]  = CreationClassName
;						$aFloppyDrive[$i][8]  = DefaultBlockSize
;						$aFloppyDrive[$i][9]  = Description
;						$aFloppyDrive[$i][10]  = DeviceID
;						$aFloppyDrive[$i][11]  = ErrorCleared
;						$aFloppyDrive[$i][12]  = ErrorDescription
;						$aFloppyDrive[$i][13]  = ErrorMethodology
;						$aFloppyDrive[$i][14]  = InstallDate
;						$aFloppyDrive[$i][15]  = LastErrorCode
;						$aFloppyDrive[$i][16]  = Manufacturer
;						$aFloppyDrive[$i][17]  = MaxBlockSize
;						$aFloppyDrive[$i][18]  = MaxMediaSize
;						$aFloppyDrive[$i][19]  = MinBlockSize
;						$aFloppyDrive[$i][20]  = Name
;						$aFloppyDrive[$i][21]  = NeedsCleaning
;						$aFloppyDrive[$i][22]  = NumberOfMediaSupported
;						$aFloppyDrive[$i][23]  = PNPDeviceID
;						$aFloppyDrive[$i][24]  = PowerManagementCapabilities
;						$aFloppyDrive[$i][25]  = PowerManagementSupported
;						$aFloppyDrive[$i][26]  = Status
;						$aFloppyDrive[$i][27]  = StatusInfo
;						$aFloppyDrive[$i][28]  = SystemCreationClassName
;						$aFloppyDrive[$i][29]  = SystemName
;                   On Failure - @error = 1 and Returns 0
;								@extended = 1 - Array contains no information
;											2 - $colItems isnt an object
; Author(s):        Matthew McMullan (NerdFencer)
; Note(s):
;===============================================================================
Func _DriveGetFloppyDrive(ByRef $aFloppyDrive)
	Local $colItems, $objWMIService, $objItem
	Dim $aFloppyDrive[1][30], $i = 1
	
	$objWMIService = ObjGet("winmgmts:\\" & $cI_Compname & "\root\CIMV2")
	$colItems = $objWMIService.ExecQuery("SELECT * FROM Win32_FloppyDrive", "WQL", $wbemFlagReturnImmediately + $wbemFlagForwardOnly)
	
	If IsObj($colItems) Then
		For $objItem In $colItems
			ReDim $aFloppyDrive[UBound($aFloppyDrive) + 1][30]
			$aFloppyDrive[$i][0]  = $objItem.Availability
			$aFloppyDrive[$i][1]  = $objItem.Capabilities
			$aFloppyDrive[$i][2]  = $objItem.CapabilityDescriptions
			$aFloppyDrive[$i][3]  = $objItem.Caption
			$aFloppyDrive[$i][4]  = $objItem.CompressionMethod
			$aFloppyDrive[$i][5]  = $objItem.ConfigManagerErrorCode
			$aFloppyDrive[$i][6]  = $objItem.ConfigManagerUserConfig
			$aFloppyDrive[$i][7]  = $objItem.CreationClassName
			$aFloppyDrive[$i][8]  = $objItem.DefaultBlockSize
			$aFloppyDrive[$i][9]  = $objItem.Description
			$aFloppyDrive[$i][10]  = $objItem.DeviceID
			$aFloppyDrive[$i][11]  = $objItem.ErrorCleared
			$aFloppyDrive[$i][12]  = $objItem.ErrorDescription
			$aFloppyDrive[$i][13]  = $objItem.ErrorMethodology
			$aFloppyDrive[$i][14]  = $objItem.InstallDate
			$aFloppyDrive[$i][15]  = $objItem.LastErrorCode
			$aFloppyDrive[$i][16]  = $objItem.Manufacturer
			$aFloppyDrive[$i][17]  = $objItem.MaxBlockSize
			$aFloppyDrive[$i][18]  = $objItem.MaxMediaSize
			$aFloppyDrive[$i][19]  = $objItem.MinBlockSize
			$aFloppyDrive[$i][20]  = $objItem.Name
			$aFloppyDrive[$i][21]  = $objItem.NeedsCleaning
			$aFloppyDrive[$i][22]  = $objItem.NumberOfMediaSupported
			$aFloppyDrive[$i][23]  = $objItem.PNPDeviceID
			$aFloppyDrive[$i][24]  = $objItem.PowerManagementCapabilities
			$aFloppyDrive[$i][25]  = $objItem.PowerManagementSupported
			$aFloppyDrive[$i][26]  = $objItem.Status
			$aFloppyDrive[$i][27]  = $objItem.StatusInfo
			$aFloppyDrive[$i][28]  = $objItem.SystemCreationClassName
			$aFloppyDrive[$i][29]  = $objItem.SystemName
			$i += 1
		Next
		$aFloppyDrive[0][0] = UBound($aFloppyDrive) - 1
		If $aFloppyDrive[0][0] < 1 Then
			SetError(1, 1, 0)
		EndIf
	Else
		SetError(1, 2, 0)
	EndIf
EndFunc

;===============================================================================
; Description:      collects CDROM Drive Information
; Parameter(s):     $aFloppyDrive - By Reference - Drive Information array.
; Requirement(s):   None
; Return Value(s):  On Success - Returns array of CDROM Drive Information.
;						$aCDROMDrive[$i][0]  = Availability
;						$aCDROMDrive[$i][1]  = Capabilities
;						$aCDROMDrive[$i][2]  = CapabilityDescriptions
;						$aCDROMDrive[$i][3]  = Caption
;						$aCDROMDrive[$i][4]  = CompressionMethod
;						$aCDROMDrive[$i][5]  = ConfigManagerErrorCode
;						$aCDROMDrive[$i][6]  = ConfigManagerUserConfig
;						$aCDROMDrive[$i][7]  = CreationClassName
;						$aCDROMDrive[$i][8]  = DefaultBlockSize
;						$aCDROMDrive[$i][9]  = Description
;						$aCDROMDrive[$i][10]  = DeviceID
;						$aCDROMDrive[$i][11]  = Drive
;						$aCDROMDrive[$i][12]  = DriveIntegrity
;						$aCDROMDrive[$i][13]  = ErrorCleared
;						$aCDROMDrive[$i][14]  = ErrorDescription
;						$aCDROMDrive[$i][15]  = ErrorMethodology
;						$aCDROMDrive[$i][16]  = FileSystemFlags
;						$aCDROMDrive[$i][17]  = FileSystemFlagsEx
;						$aCDROMDrive[$i][18]  = Id
;						$aCDROMDrive[$i][19]  = InstallDate
;						$aCDROMDrive[$i][20]  = LastErrorCode
;						$aCDROMDrive[$i][21]  = Manufacturer
;						$aCDROMDrive[$i][22]  = MaxBlockSize
;						$aCDROMDrive[$i][23]  = MaximumComponentLength
;						$aCDROMDrive[$i][24]  = MaxMediaSize
;						$aCDROMDrive[$i][25]  = MediaLoaded
;						$aCDROMDrive[$i][26]  = MediaType
;						$aCDROMDrive[$i][27]  = MfrAssignedRevisionLevel
;						$aCDROMDrive[$i][28]  = MinBlockSize
;						$aCDROMDrive[$i][29]  = Name
;						$aCDROMDrive[$i][30]  = NeedsCleaning
;						$aCDROMDrive[$i][31]  = NumberOfMediaSupported
;						$aCDROMDrive[$i][32]  = PNPDeviceID
;						$aCDROMDrive[$i][33]  = PowerManagementCapabilities
;						$aCDROMDrive[$i][34]  = PowerManagementSupported
;						$aCDROMDrive[$i][35]  = RevisionLevel
;						$aCDROMDrive[$i][36]  = SCSIBus
;						$aCDROMDrive[$i][37]  = SCSILogicalUnit
;						$aCDROMDrive[$i][38]  = SCSIPort
;						$aCDROMDrive[$i][39]  = SCSITargetId
;						$aCDROMDrive[$i][40]  = Size
;						$aCDROMDrive[$i][41]  = Status
;						$aCDROMDrive[$i][42]  = StatusInfo
;						$aCDROMDrive[$i][43]  = SystemCreationClassName
;						$aCDROMDrive[$i][44]  = SystemName
;						$aCDROMDrive[$i][45]  = TransferRate
;						$aCDROMDrive[$i][46]  = VolumeName
;						$aCDROMDrive[$i][47]  = VolumeSerialNumber
;                   On Failure - @error = 1 and Returns 0
;								@extended = 1 - Array contains no information
;											2 - $colItems isnt an object
; Author(s):        Matthew McMullan (NerdFencer)
; Note(s):
;===============================================================================
Func _DriveGetCDROMDrive(ByRef $aCDROMDrive)
	Local $colItems, $objWMIService, $objItem
	Dim $aCDROMDrive[1][48], $i = 1
	
	$objWMIService = ObjGet("winmgmts:\\" & $cI_Compname & "\root\CIMV2")
	$colItems = $objWMIService.ExecQuery("SELECT * FROM Win32_CDROMDrive", "WQL", $wbemFlagReturnImmediately + $wbemFlagForwardOnly)
	
	If IsObj($colItems) Then
		For $objItem In $colItems
			ReDim $aCDROMDrive[UBound($aCDROMDrive) + 1][48]
			$aCDROMDrive[$i][0]  = $objItem.Availability
			$aCDROMDrive[$i][1]  = $objItem.Capabilities
			$aCDROMDrive[$i][2]  = $objItem.CapabilityDescriptions
			$aCDROMDrive[$i][3]  = $objItem.Caption
			$aCDROMDrive[$i][4]  = $objItem.CompressionMethod
			$aCDROMDrive[$i][5]  = $objItem.ConfigManagerErrorCode
			$aCDROMDrive[$i][6]  = $objItem.ConfigManagerUserConfig
			$aCDROMDrive[$i][7]  = $objItem.CreationClassName
			$aCDROMDrive[$i][8]  = $objItem.DefaultBlockSize
			$aCDROMDrive[$i][9]  = $objItem.Description
			$aCDROMDrive[$i][10]  = $objItem.DeviceID
			$aCDROMDrive[$i][11]  = $objItem.Drive
			$aCDROMDrive[$i][12]  = $objItem.DriveIntegrity
			$aCDROMDrive[$i][13]  = $objItem.ErrorCleared
			$aCDROMDrive[$i][14]  = $objItem.ErrorDescription
			$aCDROMDrive[$i][15]  = $objItem.ErrorMethodology
			$aCDROMDrive[$i][16]  = $objItem.FileSystemFlags
			$aCDROMDrive[$i][17]  = $objItem.FileSystemFlagsEx
			$aCDROMDrive[$i][18]  = $objItem.Id
			$aCDROMDrive[$i][19]  = $objItem.InstallDate
			$aCDROMDrive[$i][20]  = $objItem.LastErrorCode
			$aCDROMDrive[$i][21]  = $objItem.Manufacturer
			$aCDROMDrive[$i][22]  = $objItem.MaxBlockSize
			$aCDROMDrive[$i][23]  = $objItem.MaximumComponentLength
			$aCDROMDrive[$i][24]  = $objItem.MaxMediaSize
			$aCDROMDrive[$i][25]  = $objItem.MediaLoaded
			$aCDROMDrive[$i][26]  = $objItem.MediaType
			If @OSVersion == "WIN_2008" Or @OSVersion == "WIN_VISTA" Or @OSVersion == "WIN_2003" Or @OSVersion == "WIN_XP" Then
				$aCDROMDrive[$i][27]  = $objItem.MfrAssignedRevisionLevel
			Else
				$aCDROMDrive[$i][27]  = ""
			EndIf
			$aCDROMDrive[$i][28]  = $objItem.MinBlockSize
			$aCDROMDrive[$i][29]  = $objItem.Name
			$aCDROMDrive[$i][30]  = $objItem.NeedsCleaning
			$aCDROMDrive[$i][31]  = $objItem.NumberOfMediaSupported
			$aCDROMDrive[$i][32]  = $objItem.PNPDeviceID
			$aCDROMDrive[$i][33]  = $objItem.PowerManagementCapabilities
			$aCDROMDrive[$i][34]  = $objItem.PowerManagementSupported
			$aCDROMDrive[$i][35]  = $objItem.RevisionLevel
			$aCDROMDrive[$i][36]  = $objItem.SCSIBus
			$aCDROMDrive[$i][37]  = $objItem.SCSILogicalUnit
			$aCDROMDrive[$i][38]  = $objItem.SCSIPort
			$aCDROMDrive[$i][39]  = $objItem.SCSITargetId
			$aCDROMDrive[$i][40]  = $objItem.Size
			$aCDROMDrive[$i][41]  = $objItem.Status
			$aCDROMDrive[$i][42]  = $objItem.StatusInfo
			$aCDROMDrive[$i][43]  = $objItem.SystemCreationClassName
			$aCDROMDrive[$i][44]  = $objItem.SystemName
			$aCDROMDrive[$i][45]  = $objItem.TransferRate
			$aCDROMDrive[$i][46]  = $objItem.VolumeName
			$aCDROMDrive[$i][47]  = $objItem.VolumeSerialNumber
			$i += 1
		Next
		$aCDROMDrive[0][0] = UBound($aCDROMDrive) - 1
		If $aCDROMDrive[0][0] < 1 Then
			SetError(1, 1, 0)
		EndIf
	Else
		SetError(1, 2, 0)
	EndIf
EndFunc

;===============================================================================
; Description:      collects Hard Drive Information
; Parameter(s):     $aFloppyDrive - By Reference - Drive Information array.
; Requirement(s):   None
; Return Value(s):  On Success - Returns array of Hard Drive Information.
;						$aDiskDrive[$i][0]  = Availability
;						$aDiskDrive[$i][1]  = BytesPerSector
;						$aDiskDrive[$i][2]  = Capabilities
;						$aDiskDrive[$i][3]  = CapabilityDescriptions
;						$aDiskDrive[$i][4]  = Caption
;						$aDiskDrive[$i][5]  = CompressionMethod
;						$aDiskDrive[$i][6]  = ConfigManagerErrorCode
;						$aDiskDrive[$i][7]  = ConfigManagerUserConfig
;						$aDiskDrive[$i][8]  = CreationClassName
;						$aDiskDrive[$i][9]  = DefaultBlockSize
;						$aDiskDrive[$i][10]  = Description
;						$aDiskDrive[$i][11]  = DeviceID
;						$aDiskDrive[$i][12]  = ErrorCleared
;						$aDiskDrive[$i][13]  = ErrorDescription
;						$aDiskDrive[$i][14]  = ErrorMethodology
;						$aDiskDrive[$i][15]  = Index
;						$aDiskDrive[$i][16]  = InstallDate
;						$aDiskDrive[$i][17]  = InterfaceType
;						$aDiskDrive[$i][18]  = LastErrorCode
;						$aDiskDrive[$i][19]  = Manufacturer
;						$aDiskDrive[$i][20]  = MaxBlockSize
;						$aDiskDrive[$i][21]  = MaxMediaSize
;						$aDiskDrive[$i][22]  = MediaLoaded
;						$aDiskDrive[$i][23]  = MediaType
;						$aDiskDrive[$i][24]  = MinBlockSize
;						$aDiskDrive[$i][25]  = Model
;						$aDiskDrive[$i][26]  = Name
;						$aDiskDrive[$i][27]  = NeedsCleaning
;						$aDiskDrive[$i][28]  = NumberOfMediaSupported
;						$aDiskDrive[$i][29]  = Partitions
;						$aDiskDrive[$i][30]  = PNPDeviceID
;						$aDiskDrive[$i][31]  = PowerManagementCapabilities
;						$aDiskDrive[$i][32]  = PowerManagementSupported
;						$aDiskDrive[$i][33]  = SCSIBus
;						$aDiskDrive[$i][34]  = SCSILogicalUnit
;						$aDiskDrive[$i][35]  = SCSIPort
;						$aDiskDrive[$i][36]  = SCSITargetId
;						$aDiskDrive[$i][37]  = SectorsPerTrack
;						$aDiskDrive[$i][38]  = Signature
;						$aDiskDrive[$i][39]  = Size
;						$aDiskDrive[$i][40]  = Status
;						$aDiskDrive[$i][41]  = StatusInfo
;						$aDiskDrive[$i][42]  = SystemCreationClassName
;						$aDiskDrive[$i][43]  = SystemName
;						$aDiskDrive[$i][44]  = TotalCylinders
;						$aDiskDrive[$i][45]  = TotalHeads
;						$aDiskDrive[$i][46]  = TotalSectors
;						$aDiskDrive[$i][47]  = TotalTracks
;						$aDiskDrive[$i][48]  = TracksPerCylinder
;                   On Failure - @error = 1 and Returns 0
;								@extended = 1 - Array contains no information
;											2 - $colItems isnt an object
; Author(s):        Matthew McMullan (NerdFencer)
; Note(s):
;===============================================================================
Func _DriveGetDiskDrive(ByRef $aDiskDrive)
	Local $colItems, $objWMIService, $objItem
	Dim $aDiskDrive[1][49], $i = 1
	
	$objWMIService = ObjGet("winmgmts:\\" & $cI_Compname & "\root\CIMV2")
	$colItems = $objWMIService.ExecQuery("SELECT * FROM Win32_DiskDrive", "WQL", $wbemFlagReturnImmediately + $wbemFlagForwardOnly)
	
	If IsObj($colItems) Then
		For $objItem In $colItems
			ReDim $aDiskDrive[UBound($aDiskDrive) + 1][49]
			$aDiskDrive[$i][0]  = $objItem.Availability
			$aDiskDrive[$i][1]  = $objItem.BytesPerSector
			$aDiskDrive[$i][2]  = $objItem.Capabilities
			$aDiskDrive[$i][3]  = $objItem.CapabilityDescriptions
			$aDiskDrive[$i][4]  = $objItem.Caption
			$aDiskDrive[$i][5]  = $objItem.CompressionMethod
			$aDiskDrive[$i][6]  = $objItem.ConfigManagerErrorCode
			$aDiskDrive[$i][7]  = $objItem.ConfigManagerUserConfig
			$aDiskDrive[$i][8]  = $objItem.CreationClassName
			$aDiskDrive[$i][9]  = $objItem.DefaultBlockSize
			$aDiskDrive[$i][10]  = $objItem.Description
			$aDiskDrive[$i][11]  = $objItem.DeviceID
			$aDiskDrive[$i][12]  = $objItem.ErrorCleared
			$aDiskDrive[$i][13]  = $objItem.ErrorDescription
			$aDiskDrive[$i][14]  = $objItem.ErrorMethodology
			$aDiskDrive[$i][15]  = $objItem.Index
			$aDiskDrive[$i][16]  = $objItem.InstallDate
			$aDiskDrive[$i][17]  = $objItem.InterfaceType
			$aDiskDrive[$i][18]  = $objItem.LastErrorCode
			$aDiskDrive[$i][19]  = $objItem.Manufacturer
			$aDiskDrive[$i][20]  = $objItem.MaxBlockSize
			$aDiskDrive[$i][21]  = $objItem.MaxMediaSize
			$aDiskDrive[$i][22]  = $objItem.MediaLoaded
			$aDiskDrive[$i][23]  = $objItem.MediaType
			$aDiskDrive[$i][24]  = $objItem.MinBlockSize
			$aDiskDrive[$i][25]  = $objItem.Model
			$aDiskDrive[$i][26]  = $objItem.Name
			$aDiskDrive[$i][27]  = $objItem.NeedsCleaning
			$aDiskDrive[$i][28]  = $objItem.NumberOfMediaSupported
			$aDiskDrive[$i][29]  = $objItem.Partitions
			$aDiskDrive[$i][30]  = $objItem.PNPDeviceID
			$aDiskDrive[$i][31]  = $objItem.PowerManagementCapabilities
			$aDiskDrive[$i][32]  = $objItem.PowerManagementSupported
			$aDiskDrive[$i][33]  = $objItem.SCSIBus
			$aDiskDrive[$i][34]  = $objItem.SCSILogicalUnit
			$aDiskDrive[$i][35]  = $objItem.SCSIPort
			$aDiskDrive[$i][36]  = $objItem.SCSITargetId
			$aDiskDrive[$i][37]  = $objItem.SectorsPerTrack
			If @OSVersion == "WIN_2008" Or @OSVersion == "WIN_VISTA" Or @OSVersion == "WIN_2003" Or @OSVersion == "WIN_XP" Then
				$aDiskDrive[$i][38]  = $objItem.Signature
			EndIf
			$aDiskDrive[$i][39]  = $objItem.Size
			$aDiskDrive[$i][40]  = $objItem.Status
			$aDiskDrive[$i][41]  = $objItem.StatusInfo
			$aDiskDrive[$i][42]  = $objItem.SystemCreationClassName
			$aDiskDrive[$i][43]  = $objItem.SystemName
			$aDiskDrive[$i][44]  = $objItem.TotalCylinders
			$aDiskDrive[$i][45]  = $objItem.TotalHeads
			$aDiskDrive[$i][46]  = $objItem.TotalSectors
			$aDiskDrive[$i][47]  = $objItem.TotalTracks
			$aDiskDrive[$i][48]  = $objItem.TracksPerCylinder
			$i += 1
		Next
		$aDiskDrive[0][0] = UBound($aDiskDrive) - 1
		If $aDiskDrive[0][0] < 1 Then
			SetError(1, 1, 0)
		EndIf
	Else
		SetError(1, 2, 0)
	EndIf
EndFunc
#EndRegion Drives
#Region Drives Translation
;===============================================================================
; Description:      Translates Availability Information
; Parameter(s):     $nAvailability - Availability state from a drive
; Requirement(s):   None
; Return Value(s):  On Success - Returns a string which describes the availability state
;                   On Failure - @error = 1 and Returns $nAvailability
; Author(s):        Matthew McMullan (NerdFencer)
; Note(s):
;===============================================================================
Func _DriveTranslateAvailability($nAvailability)
	Switch $nAvailability
		Case 1
			Return "Other"
		Case 2
			Return "Unknown"
		Case 3
			Return "Running or Full Power"
		Case 4
			Return "Warning"
		Case 5
			Return "In Test"
		Case 6
			Return "Not Applicable"
		Case 7
			Return "Power Off"
		Case 8
			Return "Off Line"
		Case 9
			Return "Off Duty"
		Case 10
			Return "Degraded"
		Case 11
			Return "Not Installed"
		Case 12
			Return "Install Error"
		Case 13
			Return "Power Save - Unknown: The device is known to be in a power save mode, but its exact status is unknown."
		Case 14
			Return "Power Save - Low Power Mode: The device is in a power save state but still functioning, and may exhibit degraded performance."
		Case 15
			Return "Power Save - Standby: The device is not functioning, but could be brought to full power quickly."
		Case 16
			Return "Power Cycle"
		Case 17
			Return "Power Save - Warning: The device is in a warning state, though also in a power save mode."
	EndSwitch
	Return SetError(1,0,$nAvailability)
EndFunc

;===============================================================================
; Description:      Translates Capabilities Information
; Parameter(s):     $nCapabilities - Capabilities state from a drive
;                   $sSeperator - The string to seperate each Capability item with
; Requirement(s):   None
; Return Value(s):  On Success - Returns a string which describes the Capabilities state
;                   On Failure - @error = 1 and Returns $nCapabilities
; Author(s):        Matthew McMullan (NerdFencer)
; Note(s):
;===============================================================================
Func _DriveTranslateCapabilities($nCapabilities, $sSeperator = ", ")
	Local $sCapabilities = ""
	For $i = 0 To UBound($nCapabilities)-1
		$sCapabilities = $sCapabilities & $sSeperator & _DriveTranslateCapability($nCapabilities[$i])
	Next
	Return StringTrimLeft($sCapabilities,StringLen($sSeperator))
EndFunc

;===============================================================================
; Description:      Translates Capability Information
; Parameter(s):     $nCapabilities - Capability state from a drive (one, not the aray)
; Requirement(s):   None
; Return Value(s):  On Success - Returns a string which describes the Capability state
;                   On Failure - @error = 1 and Returns $nCapability
; Author(s):        Matthew McMullan (NerdFencer)
; Note(s):
;===============================================================================
Func _DriveTranslateCapability($nCapability)
	Switch $nCapability
		Case 0
			Return "Unknown"
		Case 1
			Return "Other"
		Case 2
			Return "Sequential Access"
		Case 3
			Return "Random Access"
		Case 4
			Return "Supports Writing"
		Case 5
			Return "Encryption"
		Case 6
			Return "Compression"
		Case 7
			Return "Supports Removable Media"
		Case 8
			Return "Manual Cleaning"
		Case 9
			Return "Automatic Cleaning"
		Case 10
			Return "SMART Notification"
		Case 11
			Return "Supports Dual-Sided Media"
		Case 12
			Return "Ejection Prior to Drive Dismount Not Required"
	EndSwitch
	Return SetError(1,0,$nCapability)
EndFunc

;===============================================================================
; Description:      Translates Config Manager Error Code Information
; Parameter(s):     $nCode - ConfigManagerErrorCode state from a drive
; Requirement(s):   None
; Return Value(s):  On Success - Returns a string which describes the ConfigManagerErrorCode
;                   On Failure - @error = 1 and Returns $nCode
; Author(s):        Matthew McMullan (NerdFencer)
; Note(s):
;===============================================================================
Func _DriveTranslateConfigManagerErrorCode($nCode)
	Switch $nCode
		Case 0
			Return "Device is working properly."
		Case 1
			Return "Device is not configured correctly."
		Case 2
			Return "Windows cannot load the driver for this device."
		Case 3
			Return "Driver for this device might be corrupted, or the system may be low on memory or other resources."
		Case 4
			Return "Device is not working properly. One of its drivers or the registry might be corrupted."
		Case 5
			Return "Driver for the device requires a resource that Windows cannot manage."
		Case 6
			Return "Boot configuration for the device conflicts with other devices."
		Case 7
			Return "Cannot filter."
		Case 8
			Return "Driver loader for the device is missing."
		Case 9
			Return "Device is not working properly. The controlling firmware is incorrectly reporting the resources for the device."
		Case 10
			Return "Device cannot start."
		Case 11
			Return "Device failed."
		Case 12
			Return "Device cannot find enough free resources to use."
		Case 13
			Return "Windows cannot verify the device's resources."
		Case 14
			Return "Device cannot work properly until the computer is restarted."
		Case 15
			Return "Device is not working properly due to a possible re-enumeration problem."
		Case 16
			Return "Windows cannot identify all of the resources that the device uses."
		Case 17
			Return "Device is requesting an unknown resource type."
		Case 18
			Return "Device drivers must be reinstalled."
		Case 19
			Return "Failure using the VxD loader."
		Case 20
			Return "Registry might be corrupted."
		Case 21
			Return "System failure. If changing the device driver is ineffective, see the hardware documentation. Windows is removing the device."
		Case 22
			Return "Device is disabled."
		Case 23
			Return "System failure. If changing the device driver is ineffective, see the hardware documentation."
		Case 24
			Return "Device is not present, not working properly, or does not have all of its drivers installed."
		Case 25
			Return "Windows is still setting up the device."
		Case 26
			Return "Windows is still setting up the device."
		Case 27
			Return "Device does not have valid log configuration."
		Case 28
			Return "Device drivers are not installed."
		Case 29
			Return "Device is disabled. The device firmware did not provide the required resources."
		Case 30
			Return "Device is using an IRQ resource that another device is using."
		Case 31
			Return "Device is not working properly. Windows cannot load the required device drivers."
	EndSwitch
	Return SetError(1,0,$nCode)
EndFunc

;===============================================================================
; Description:      Translates Config Manager User Config Information
; Parameter(s):     $nConfigManagerUserConfig - ConfigManagerUserConfig state from a drive
; Requirement(s):   None
; Return Value(s):  On Success - Returns a string which describes the ConfigManagerUserConfig
;                   On Failure - @error = 1 and Returns $nConfigManagerUserConfig
; Author(s):        Matthew McMullan (NerdFencer)
; Note(s):
;===============================================================================
Func _DriveTranslateConfigManagerUserConfig($bConfigManagerUserConfig)
	If $bConfigManagerUserConfig == True Then
		Return "The device is using a user-defined configuration"
	EndIf
	Return "The device is not using a user-defined configuration"
EndFunc

;===============================================================================
; Description:      Translates Power Management Capabilities Information
; Parameter(s):     $nPowerManagementCapabilities - PowerManagementCapabilities state from a drive
; Requirement(s):   None
; Return Value(s):  On Success - Returns a string which describes the PowerManagementCapabilities
;                   On Failure - @error = 1 and Returns $nPowerManagementCapabilities
; Author(s):        Matthew McMullan (NerdFencer)
; Note(s):
;===============================================================================
Func _DriveTranslatePowerManagementCapabilities($aPowerManagementCapabilities, $sSeperator = ", ")
	Local $sReadable = ""
	If UBound($aPowerManagementCapabilities)<>0 Then
		For $i = 0 To UBound($aPowerManagementCapabilities)-1
			$sReadable = $sReadable & $sSeperator & _DriveTranslatePowerManagementCapability($aPowerManagementCapabilities[$i])
		Next
		Return StringTrimLeft($sReadable,StringLen($sSeperator))
	Else
		Return _DriveTranslatePowerManagementCapability($aPowerManagementCapabilities)
	EndIf
EndFunc

;===============================================================================
; Description:      Translates Power Management Capability Information
; Parameter(s):     $nPowerManagementCapability - PowerManagementCapability state from a drive (one, not the aray)
; Requirement(s):   None
; Return Value(s):  On Success - Returns a string which describes the PowerManagementCapability
;                   On Failure - @error = 1 and Returns $nPowerManagementCapability
; Author(s):        Matthew McMullan (NerdFencer)
; Note(s):
;===============================================================================
Func _DriveTranslatePowerManagementCapability($nPowerManagementCapability)
	Switch $nPowerManagementCapability
		Case 0
			Return "Unknown"
		Case 1
			Return "Not Supported"
		Case 2
			Return "Disabled"
		Case 3
			Return "Enabled: The power management features are currently enabled but the exact feature set is unknown or the information is unavailable."
		Case 4
			Return "Power Saving Modes Entered Automatically: The device can change its power state based on usage or other criteria."
		Case 5
			Return "Power State Settable: The SetPowerState method is supported. This method is found on the parent CIM_LogicalDevice class and can be implemented."
		Case 6
			Return "Power Cycling Supported: The SetPowerState method can be invoked with the PowerState parameter set to 5 (Power Cycle)."
		Case 7
			Return "Timed Power-On Supported: The SetPowerState method can be invoked with the PowerState parameter set to 5 (Power Cycle) and Time set to a specific date and time, or interval, for power-on."
	EndSwitch
	Return SetError(1,0,$nPowerManagementCapability)
EndFunc

;===============================================================================
; Description:      Translates Media Loaded Information
; Parameter(s):     $nMediaLoaded - MediaLoaded state from a drive
; Requirement(s):   None
; Return Value(s):  On Success - Returns a string which describes the state of Media for the drive
;                   On Failure - @error = 1 and Returns $nMediaLoaded
; Author(s):        Matthew McMullan (NerdFencer)
; Note(s):
;===============================================================================
Func _DriveTranslateMediaLoaded($bMediaLoaded)
	If $bMediaLoaded == False Then
		Return "The device does not have a readable file system or is not accessible."
	EndIf
	Return "The device has a readable file system or is accessible."
EndFunc

;===============================================================================
; Description:      Translates Status Info
; Parameter(s):     $nStatusInfo- StatusInfo state from a drive
; Requirement(s):   None
; Return Value(s):  On Success - Returns a string which describes the StatusInfo of the drive
;                   On Failure - @error = 1 and Returns $nStatusInfo
; Author(s):        Matthew McMullan (NerdFencer)
; Note(s):
;===============================================================================
Func _DriveTranslateStatusInfo($nStatusInfo)
	Switch $nStatusInfo
		Case 1
			Return "Other"
		Case 2
			Return "Unknown"
		Case 3
			Return "Enabled"
		Case 4
			Return "Disabled"
		Case 5
			Return "Not Applicable"
	EndSwitch
	Return SetError(1,0,$nStatusInfo)
EndFunc
#EndRegion Drives Translation