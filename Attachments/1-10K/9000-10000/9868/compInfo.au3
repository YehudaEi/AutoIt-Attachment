;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
;Program Name:	compInfo
;Description:	Gathers useful computer information for a computer
;				administrator to effectively monitor systems.
;Filename:		compInfo.au3
;Used With:		
;Created by:	Jarvis J Stubblefield (support "at" vortexrevolutions "dot" com)
;Created on:	07/05/2006
;Modified on:	
;Modified by:	
;Version:		1.0.0
;Copyright:		Copyright (C) 2006 Vortex Revolutions. All Rights Reserved.
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;---*** Preprocessor ***---
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

#include <inet.au3>

;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;---*** File Installations ***---
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;---*** Registry Information ***---
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;---*** Declare Variables ***---
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

Global $cI_Compname, $cI_LocalIP, $cI_ExternalIP
Global $cI_OSType, $cI_OSVersion, $cI_OSBuild, $cI_OSServicePack
Global $cI_DeskWidth, $cI_DeskHeight, $cI_DeskDepth, $cI_DeskRefresh
Global $cI_ProcessorArch
Global $cI_Username
Global $cI_SystemDir, $cI_WindowsDir
Global $Drives, $Applications, $Startup, $Users, $Printers, $CPUs
Global $memStats
Global $oMyError

;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;---*** Define Variables ***---
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

$cI_Compname		= @ComputerName
$cI_LocalIP			= @IPAddress1
$cI_ExternalIP		= _GetIP()
$cI_OSType			= @OSTYPE
$cI_OSVersion		= @OSVersion
$cI_OSBuild			= @OSBuild
$cI_OSServicePack	= @OSServicePack
$cI_DeskWidth		= @DesktopWidth
$cI_DeskHeight		= @DesktopHeight
$cI_DeskDepth		= @DesktopDepth
$cI_DeskRefresh		= @DesktopRefresh
$cI_Processor		= RegRead("HKEY_LOCAL_MACHINE\HARDWARE\DESCRIPTION\System\CentralProcessor\0", "ProcessorNameString")
$cI_ProcessorSpeed	= RegRead("HKEY_LOCAL_MACHINE\HARDWARE\DESCRIPTION\System\CentralProcessor\0", "~Mhz")
$cI_ProcessorArch	= @ProcessorArch
$cI_Username		= @UserName
$cI_SystemDir		= @SystemDir
$cI_WindowsDir		= @WindowsDir

;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;---*** Main Program Loop ***---
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

_ComputerGetDrives($Drives)
$memStats = MemGetStats()
_ComputerGetSoftware($Applications)
_ComputerGetStartup($Startup)
_ComputerGetUsers($Users)
;_ComputerGetPrinters($Printers)
;_ComputerGetCPUs($CPUs)

_WriteLog()
_TerminateApp()

;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;---*** Define Functions ***---
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

Func _ComputerGetCPUs(ByRef $aCPUInfo)
	Local $HKLMCentralProc = "HKLM\HARDWARE\DESCRIPTION\System\CentralProcessor"
	Local $CentralProcKey
	Dim $aCPUInfo[1][6], $i = 1
	
	While 1
		$CentralProcKey = RegEnumKey($HKLMCentralProc, $i)
		If @error <> 0 Then ExitLoop
		ReDim $aCPUInfo[UBound($aCPUInfo) + 1][6]
		$aCPUInfo[$i][1] = RegRead($HKLMCentralProc & "\" & $CentralProcKey, "~MHz") / 1000
		$aCPUInfo[$i][2] = StringStripWS(RegRead($HKLMCentralProc & "\" & $CentralProcKey, "ProcessorNameString"), 1)
		$aCPUInfo[$i][3] = RegRead($HKLMCentralProc & "\" & $CentralProcKey, "Identifier")
		$aCPUInfo[$i][4] = RegRead($HKLMCentralProc & "\" & $CentralProcKey, "VendorIdentifier")
		$aCPUInfo[$i][5] = @ProcessorArch
		$i += 1
	WEnd

	$aCPUInfo[0][0] = UBound($aCPUInfo, 1) - 1
EndFunc

Func _ComputerGetPrinters(ByRef $aPrinters)
	Local $HKLMPrinters = "HKLM\SYSTEM\ControlSet001\Control\Print\Printers"
	Local $PrinterKey
	Dim $aPrinters[1], $i = 1
	
	While 1
		$PrinterKey = RegEnumKey($HKLMPrinters, $i)
		If @error <> 0 Then ExitLoop
		ReDim $aPrinters[UBound($aPrinters) + 1]
		$aPrinters[$i] = $PrinterKey
		$i += 1
	WEnd
	
	$aPrinters[0] = UBound($aPrinters) - 1
EndFunc

;===============================================================================
; Description:      Returns the drive information based on $sDriveType in a two
;					dimensional array. First dimension is the index for each set
;					of drive information.
; Parameter(s):     $aDriveInfo - By Ref - Drive information in an array.
;					$sDriveType - 	Type of drive to return the information on.
;									Options: "ALL", "CDROM", "REMOVABLE", "FIXED",
;									"NETWORK", "RAMDISK", or "UNKNOWN"
;									Defaults to "FIXED" drives.
; Requirement(s):   None
; Return Value(s):  On Success - Returns array of drive information.
;						$aDriveInfo[0][0] = Number of Drives
;						The second dimension is as follows: ($i starts at 1)
;							[$i][0] - Drive Letter (ex. C:\)
;							[$i][1] - File System
;							[$i][2] - Label
;							[$i][3] - Serial Number
;							[$i][4] - Free Space
;							[$i][5] - Total Space
;                   On Failure - Return 0 - SetError - 1
;								SetExtended: 1 = DriveGetDrive		Error
;											 2 = DriveGetFileSystem Error
;											 3 = DriveGetLabel		Error
;											 4 = DriveGetSerial		Error
;											 5 = DriveSpaceFree		Error
;											 6 = DriveSpaceTotal	Error
; Author(s):        Jarvis Stubblefield (support "at" vortexrevolutions "dot" com)
; Note(s):
;
;===============================================================================
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
			$aDriveInfo[$i][4] = DriveSpaceFree($drive[$i])
			If @error Then SetError(1, 5, 0)
			$aDriveInfo[$i][5] = DriveSpaceTotal($drive[$i])
			If @error Then SetError(1, 6, 0)
		Next
	Else
		SetError(1, 1, 0)
	EndIf
EndFunc

Func _ComputerGetStartup(ByRef $StartupInfo)
	Local Const $HKLMRun	= "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Run"
	Local Const $HKCURun	= "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Run"
	Local $i = 1, $j = 1
	Local $search
	Dim $StartupInfo[1]
	
	While 1
		$AppKey = RegEnumVal($HKLMRun, $i)
		If @error <> 0 Then ExitLoop
		$StartupInfo[0] = UBound($StartupInfo)
		ReDim $StartupInfo[UBound($StartupInfo) + 1]
		$StartupInfo[$i] = RegRead($HKLMRun, $AppKey)
		$i += 1
	WEnd
	
	While 1
		$AppKey = RegEnumVal($HKCURun, $j)
		If @error <> 0 Then ExitLoop
		$StartupInfo[0] = UBound($StartupInfo)
		ReDim $StartupInfo[UBound($StartupInfo) + 1]
		$StartupInfo[$i] = RegRead($HKCURun, $AppKey)
		$i += 1
		$j += 1
	WEnd
	
	$search = FileFindFirstFile(@StartupCommonDir & "\*.*")
	If $search <> -1 Then
		While 1
			$file = FileFindNextFile($search)
			If @error Then ExitLoop
			If $file = "desktop.ini" Then ContinueLoop
			$StartupInfo[0] = UBound($StartupInfo)
			ReDim $StartupInfo[UBound($StartupInfo) + 1]
			$StartupInfo[$i] = $file
			$i += 1
		WEnd
	EndIf
	
	$search = FileFIndFirstFile(@StartupDir & "\*.*")
	If $search <> -1 Then
		While 1
			$file = FileFindNextFile($search)
			If @error Then ExitLoop
			If $file = "desktop.ini" Then ContinueLoop
			$StartupInfo[0] = UBound($StartupInfo)
			ReDim $StartupInfo[UBound($StartupInfo) + 1]
			$StartupInfo[$i] = $file
			$i += 1
		WEnd
	EndIf
	
	$StartupInfo[0] = UBound($StartupInfo) - 1
EndFunc

Func _ComputerGetSoftware(ByRef $AppInfo)
	Local Const $UnInstKey	= "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall"
	Local $i = 1
	Dim $AppInfo[1][3]
	
	$AppInfo[0][0] = 1
	
	While 1
		$AppKey	= RegEnumKey($UnInstKey, $i)
		If @error <> 0 Then ExitLoop
		ReDim $AppInfo[UBound($AppInfo) + 1][3]
		$AppInfo[$i][0]	= StringStripWS(StringReplace(RegRead($UnInstKey & "\" & $AppKey, "DisplayName"), " (remove only)", ""), 3)
		$AppInfo[$i][1]	= StringStripWS(RegRead($UnInstKey & "\" & $AppKey, "DisplayVersion"), 3)
		$AppInfo[$i][2] = StringStripWS(RegRead($UnInstKey & "\" & $AppKey, "Publisher"), 3)
		$i += 1
	WEnd
	
	$AppInfo[0][0] = UBound($AppInfo, 1) - 1
EndFunc

Func _ComputerGetUsers(ByRef $Usernames)
	Dim $Usernames[1]
	Local $i = 1
	$oMyError = ObjEvent("AutoIt.Error", "ComError")
	Local $objDomain = ObjGet("WinNT://" & $cI_Compname & "" )
	Dim $filter[2] = ["user"]
	$objDomain.Filter = $filter
	For $aUser In $objDomain
		ReDim $Usernames[UBound($Usernames) + 1]
		$Usernames[$i] = $aUSer.Name
		$i += 1
	Next
	
	$Usernames[0] = UBound($Usernames) - 1
EndFunc

Func _WriteLog()
	$file = FileOpen($cI_Compname & "-" & $cI_Username & ".txt", 1)
	FileWriteLine($file, "Computer Name: " & $cI_Compname)
	FileWriteLine($file, "Username Used: " & $cI_Username)
	FileWriteLine($file, "Internal IP: " & $cI_LocalIP)
	FileWriteLine($file, "External IP: " & $cI_ExternalIP)
	FileWriteLine($file, "Operating System: " & $cI_OSType & " Version: " & $cI_OSVersion & " (" & $cI_OSBuild & ") " & $cI_OSServicePack)
	FileWriteLine($file, "Desktop >> " & $cI_DeskWidth & " x " & $cI_DeskHeight & " Depth: " & $cI_DeskDepth & "bit Refresh Rate: " & $cI_DeskRefresh & "Hz")
	FileWriteLine($file, "System Directory: " & $cI_SystemDir)
	FileWriteLine($file, "Windows Directory: " & $cI_WindowsDir)
	FileWrite($file, @CRLF)
	FileWriteLine($file, "Drives Information")
	For $i = 1 To $Drives[0][0] Step 1
		FileWriteLine($file, "Drive: " & $Drives[$i][0])
		FileWriteLine($file, "File System: " & $Drives[$i][1])
		FileWriteLine($file, "Label: " & $Drives[$i][2])
		FileWriteLine($file, "Serial: " & $Drives[$i][3])
		FileWriteLine($file, "Free Space (MB): " & Round($Drives[$i][4], 2))
		FileWriteLine($file, "Total Space (MB): " & Round($Drives[$i][5], 2))
		FileWrite($file, @CRLF)
	Next
	FileWriteLine($file, "Memory Information (all in MB's)")
	FileWriteLine($file, "RAM: " & Round($memStats[1] / 1024, 2))
	FileWriteLine($file, "Page File: " & Round($memStats[3] / 1024, 2))
	FileWriteLine($file, "Vitual Memory: " & Round($memStats[5] / 1024, 2))
	FileWrite($file, @CRLF)
	FileWriteLine($file, "Processor Information")
	FileWriteLine($file, "Name: " & StringStripWS($cI_Processor, 1) & " Arch: " & $cI_ProcessorArch)
	FileWriteLine($file, "Speed: " & $cI_ProcessorSpeed / 1000 & "GHz")
	FileWrite($file, @CRLF)
	FileWriteLine($file, "All Users")
	For $i = 1 To $Users[0] Step 1
		FileWriteLine($file, $Users[$i])
	Next
	FileWrite($file, @CRLF)
	FileWriteLine($file, "Startup Items")
	For $i = 1 To $Startup[0] Step 1
		FileWriteLine($file, $Startup[$i])
	Next
	FileWrite($file, @CRLF)
	FileWriteLine($file, "Installed Software")
	For $i = 1 To $Applications[0][0] Step 1
		If StringInStr($Applications[$i][0], "Hotfix") OR StringInStr($Applications[$i][0], "Update for") OR $Applications[$i][0] = "" Then
			ContinueLoop
		EndIf
		FileWriteLine($file, StringStripWS($Applications[$i][0], 3))
	Next
	FileClose($file)
EndFunc

Func ComError()
    If IsObj($oMyError) Then
        $HexNumber = Hex($oMyError.number, 8)
        SetError($HexNumber)
    Else
        SetError(1)
    EndIf
    Return 0
EndFunc   ;==>ComError

Func _TerminateApp()	
	Exit
EndFunc