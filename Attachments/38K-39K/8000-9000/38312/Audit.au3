#RequireAdmin
#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_icon=..\..\Audit\audit.ico
#AutoIt3Wrapper_outfile=Audit.exe
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.6.1
 Author:         Adam Mallinson

 Script Function:
	Generate computer audit report

 Version:		 1.0.0.0

#ce ----------------------------------------------------------------------------

; ----------------------------------------------------------------------------
; Include all relevant files
; ----------------------------------------------------------------------------
#Include <String.au3>
#include <Array.au3>
#include <Math.au3>
#include <Date.au3>
#include <File.au3>
#include <FileConstants.au3>
#include <WindowsConstants.au3>
#include <GUIConstants.au3>
#include <GUIConstantsEx.au3>
#include <GuiRichEdit.au3>
#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <StaticConstants.au3>
#include <ProgressConstants.au3>
#include "CompInfo.au3"
#include <constants.au3>
; ----------------------------------------------------------------------------
; End Includes
; ----------------------------------------------------------------------------
; Begin time test
; ----------------------------------------------------------------------------
$TimerStart = TimerInit()

; ----------------------------------------------------------------------------
; Create GUI for progess bar in top right corner of screen
; ----------------------------------------------------------------------------
; Work out position for GUI
$DHeight = @DesktopHeight
$DWidth = @DesktopWidth
; Calculate position for left hand edge of box
$DWidth = $DWidth - 15 - 600
; Create GUI and position in top right
$GUI = GUICreate("Progress", 600, 110, $DWidth, 10, BitOr($WS_DLGFRAME, $WS_POPUP))
$Label = GUICtrlCreateLabel("", 10, 10, 580, 25)
GUICtrlSetFont($Label, 14, 200, 0, "Comic Sans MS")
$Progress1 = GUICtrlCreateProgress(120, 45, 430, 25, $PBS_SMOOTH)
$Progress2 = GUICtrlCreateProgress(120, 75, 430, 25, $PBS_SMOOTH)
$Percent1 = GUICtrlCreateLabel("0%", 560, 50, 30, 20, $SS_CENTER)
$Percent2 = GUICtrlCreateLabel("0%", 560, 80, 30, 20, $SS_CENTER)
GUICtrlSetData($Progress1, 0)
GUICtrlSetData($Progress2, 0)
GUICtrlCreateLabel("Current Item", 10, 50, 100, 20, $SS_RIGHT)
GUICtrlCreateLabel("Overall Progress", 10, 80, 100, 20, $SS_RIGHT)
GUISetState(@SW_SHOW, $GUI)

; ----------------------------------------------------------------------------
; Find drive letter of USB Flash Drive
; ----------------------------------------------------------------------------
GUICtrlSetData($Label, "Locating USB Flash Drive")
GUICtrlSetData($Progress1, 0)
GUICtrlSetData($Percent1, "0%")
; ----------------------------------------------------------------------------
$sDrvLetter = "C:"
$arDrvList = DriveGetDrive('REMOVABLE') ; Get list of removable Drives.
For $i = 1 To $arDrvList[0]
    If $arDrvList[$i] = 'a:' Then ContinueLoop ; except floppy Drive.
    If FileExists($arDrvList[$i] & '\find_me.txt') Then
        $sDrvLetter = $arDrvList[$i]
		$sDrvLetter = StringUpper($sDrvLetter)
    EndIf
Next
GUICtrlSetData($Progress1, 100)
GUICtrlSetData($Progress2, 4.0)
GUICtrlSetData($Percent1, "100%")
GUICtrlSetData($Percent2, "4.0%")

; ----------------------------------------------------------------------------
; Gather Information
; ----------------------------------------------------------------------------
; OS
; ----------------------------------------------------------------------------
GUICtrlSetData($Label, "Collecting Operating System Details")
GUICtrlSetData($Progress1, 0)
GUICtrlSetData($Percent1, "0%")
; ----------------------------------------------------------------------------
Dim $OSs
_ComputerGetOSs($OSs)
For $i = 1 To $OSs[0][0] Step 1
	$OSNameSplit = StringSplit($OSs[$i][0], "|")
	$OSName = $OSNameSplit[1]
	$OSBuildNumber = $OSs[$i][2]
	$OSCountryCode = $OSs[$i][6]
	$OSLocale = $OSs[$i][27]
	$OSLanguage = $OSs[$i][35]
	$OSProductSuite = $OSs[$i][36]
	$OSType = $OSs[$i][37]
	$OSRegUser = $OSs[$i][45]
	$OSSystemDrive = $OSs[$i][54]
	$OSMemory = $OSs[$i][57]
	$Date = _NowDate()
	$Time = _NowTime(4)
	$DateTime = $Date & ' ' & $Time
	ExitLoop
Next
GUICtrlSetData($Progress1, 100)
GUICtrlSetData($Progress2, 8.0)
GUICtrlSetData($Percent1, "100%")
GUICtrlSetData($Percent2, "8.0%")

; ----------------------------------------------------------------------------
; System
; ----------------------------------------------------------------------------
GUICtrlSetData($Label, "Collecting System Details")
GUICtrlSetData($Progress1, 0)
GUICtrlSetData($Percent1, "0%")
; ----------------------------------------------------------------------------
Dim $System
_ComputerGetSystem($System)
For $i = 1 To $System[0][0] Step 1
	$SYSManufacturer = $System[$i][21]
	$SYSModel = $System[$i][22]
	$SYSWorkgroup = $System[$i][13]
	$SYSDomainRoleNum = $System[$i][14]
	$SYSDomainRole = DomainRole($SYSDomainRoleNum)
	ExitLoop
Next
GUICtrlSetData($Progress1, 100)
GUICtrlSetData($Progress2, 12.0)
GUICtrlSetData($Percent1, "100%")
GUICtrlSetData($Percent2, "12.0%")

; ----------------------------------------------------------------------------
; System Enclosure
; ----------------------------------------------------------------------------
GUICtrlSetData($Label, "Collecting System Chassis Details")
GUICtrlSetData($Progress1, 0)
GUICtrlSetData($Percent1, "0%")
; ----------------------------------------------------------------------------
$SYSobjWMIService = ObjGet("winmgmts:root/CIMV2")
$SYScolItems = $SYSobjWMIService.ExecQuery("SELECT * FROM Win32_SystemEnclosure")
For $SYSobjItem in $SYScolItems
    $SYSEnclosureNumber = $SYSobjItem.ChassisTypes(0)
	$SYSEnclosure = Enclosure($SYSEnclosureNumber)
	ExitLoop
Next
GUICtrlSetData($Progress1, 100)
GUICtrlSetData($Progress2, 16.0)
GUICtrlSetData($Percent1, "100%")
GUICtrlSetData($Percent2, "16.0%")

; ----------------------------------------------------------------------------
; Processor
; ----------------------------------------------------------------------------
GUICtrlSetData($Label, "Collecting Processor Details")
GUICtrlSetData($Progress1, 0)
GUICtrlSetData($Percent1, "0%")
; ----------------------------------------------------------------------------
$PROobjWMIService = ObjGet("winmgmts:root/CIMV2")
$PROcolItems = $PROobjWMIService.ExecQuery("SELECT * FROM Win32_Processor")
$COMobjWMIService = ObjGet("winmgmts:root/CIMV2")
$COMcolItems = $COMobjWMIService.ExecQuery("SELECT * FROM Win32_ComputerSystem")
GUICtrlSetData($Progress1, 100)
GUICtrlSetData($Progress2, 20.0)
GUICtrlSetData($Percent1, "100%")
GUICtrlSetData($Percent2, "20.0%")

; ----------------------------------------------------------------------------
; Base Board (Motherboard)
; ----------------------------------------------------------------------------
GUICtrlSetData($Label, "Collecting Motherboard Details")
GUICtrlSetData($Progress1, 0)
GUICtrlSetData($Percent1, "0%")
; ----------------------------------------------------------------------------
$BBMobjWMIService = ObjGet("winmgmts:root/CIMV2")
$BBMcolItems = $BBMobjWMIService.ExecQuery("SELECT * FROM Win32_BaseBoard")
For $BBMobjItem in $BBMcolItems
	$BBMManufacturer = $BBMobjItem.Manufacturer
	$BBMProduct = $BBMobjItem.Product
	ExitLoop
Next
GUICtrlSetData($Progress1, 100)
GUICtrlSetData($Progress2, 24.0)
GUICtrlSetData($Percent1, "100%")
GUICtrlSetData($Percent2, "24.0%")

; ----------------------------------------------------------------------------
; BIOS
; ----------------------------------------------------------------------------
GUICtrlSetData($Label, "Collecting BIOS Details")
GUICtrlSetData($Progress1, 0)
GUICtrlSetData($Percent1, "0%")
; ----------------------------------------------------------------------------
$BIOobjWMIService = ObjGet("winmgmts:root/CIMV2")
$BIOcolItems = $BIOobjWMIService.ExecQuery("SELECT * FROM Win32_BIOS")
For $BIOobjItem in $BIOcolItems
	$BIOManufacturer = $BIOobjItem.Manufacturer
	$BIOVersion = $BIOobjItem.SMBIOSBIOSVersion
	$BIOReleaseDate = $BIOobjItem.ReleaseDate
	; Process release date
	$BIORelYear = StringLeft($BIOReleaseDate, 4)
	$BIOReleaseDate = StringTrimLeft($BIOReleaseDate, 4)
	$BIORelMonth = StringLeft($BIOReleaseDate, 2)
	$BIOReleaseDate = StringTrimLeft($BIOReleaseDate, 2)
	$BIORelDay = StringLeft($BIOReleaseDate, 2)
	ExitLoop
Next
GUICtrlSetData($Progress1, 100)
GUICtrlSetData($Progress2, 28.0)
GUICtrlSetData($Percent1, "100%")
GUICtrlSetData($Percent2, "28.0%")

; ----------------------------------------------------------------------------
; Drives
; ----------------------------------------------------------------------------
GUICtrlSetData($Label, "Collecting Drive Details")
GUICtrlSetData($Progress1, 0)
GUICtrlSetData($Percent1, "0%")
; ----------------------------------------------------------------------------
$OPTobjWMIService = ObjGet("winmgmts:root/CIMV2")
$OPTcolItems = $OPTobjWMIService.ExecQuery("SELECT * FROM Win32_CDROMDrive")
$DIDobjWMIService = ObjGet("winmgmts:root/CIMV2")
$DIDcolItems = $DIDobjWMIService.ExecQuery("SELECT * FROM Win32_DiskDrive")
$LDPobjWMIService = ObjGet("winmgmts:root/CIMV2")
$LDPcolItems = $LDPobjWMIService.ExecQuery("SELECT * FROM Win32_LogicalDiskToPartition")
$LDDobjWMIService = ObjGet("winmgmts:root/CIMV2")
$LDDcolItems = $LDDobjWMIService.ExecQuery("SELECT * FROM Win32_LogicalDisk")
$MLDobjWMIService = ObjGet("winmgmts:root/CIMV2")
$MLDcolItems = $MLDobjWMIService.ExecQuery("SELECT * FROM Win32_MappedLogicalDisk")
GUICtrlSetData($Progress1, 100)
GUICtrlSetData($Progress2, 32.0)
GUICtrlSetData($Percent1, "100%")
GUICtrlSetData($Percent2, "32.0%")

; ----------------------------------------------------------------------------
; Memory
; ----------------------------------------------------------------------------
GUICtrlSetData($Label, "Collecting Memory Details")
GUICtrlSetData($Progress1, 0)
GUICtrlSetData($Percent1, "0%")
; ----------------------------------------------------------------------------
$MEMobjWMIService = ObjGet("winmgmts:root/CIMV2")
$MEMcolItems = $MEMobjWMIService.ExecQuery("SELECT * FROM Win32_PhysicalMemory")
GUICtrlSetData($Progress1, 100)
GUICtrlSetData($Progress2, 36.0)
GUICtrlSetData($Percent1, "100%")
GUICtrlSetData($Percent2, "36.0%")

; ----------------------------------------------------------------------------
; Users
; ----------------------------------------------------------------------------
GUICtrlSetData($Label, "Collecting User Details")
GUICtrlSetData($Progress1, 0)
GUICtrlSetData($Percent1, "0%")
; ----------------------------------------------------------------------------
$USEobjWMIService = ObjGet("winmgmts:root/CIMV2")
$USEcolItems = $USEobjWMIService.ExecQuery("SELECT * FROM Win32_UserAccount WHERE LocalAccount = True")
GUICtrlSetData($Progress1, 100)
GUICtrlSetData($Progress2, 40.0)
GUICtrlSetData($Percent1, "100%")
GUICtrlSetData($Percent2, "40.0%")

; ----------------------------------------------------------------------------
; Printers
; ----------------------------------------------------------------------------
GUICtrlSetData($Label, "Collecting Printer Details")
GUICtrlSetData($Progress1, 0)
GUICtrlSetData($Percent1, "0%")
; ----------------------------------------------------------------------------
$PRIobjWMIService = ObjGet("winmgmts:root/CIMV2")
$PRIcolItems = $PRIobjWMIService.ExecQuery("SELECT * FROM Win32_Printer")
GUICtrlSetData($Progress1, 100)
GUICtrlSetData($Progress2, 44.0)
GUICtrlSetData($Percent1, "100%")
GUICtrlSetData($Percent2, "44.0%")

; ----------------------------------------------------------------------------
; Display Adapters
; ----------------------------------------------------------------------------
GUICtrlSetData($Label, "Collecting Display Details")
GUICtrlSetData($Progress1, 0)
GUICtrlSetData($Percent1, "0%")
; ----------------------------------------------------------------------------
$VIDobjWMIService = ObjGet("winmgmts:root/CIMV2")
$VIDcolItems = $VIDobjWMIService.ExecQuery("SELECT * FROM Win32_VideoController")
GUICtrlSetData($Progress1, 100)
GUICtrlSetData($Progress2, 45.0)
GUICtrlSetData($Percent1, "100%")
GUICtrlSetData($Percent2, "45.0%")

; ----------------------------------------------------------------------------
; Network Adapters
; ----------------------------------------------------------------------------
GUICtrlSetData($Label, "Collecting Network Adapter Details")
GUICtrlSetData($Progress1, 0)
GUICtrlSetData($Percent1, "0%")
; ----------------------------------------------------------------------------
$NETobjWMIService = ObjGet("winmgmts:root/CIMV2")
$NETcolItems = $NETobjWMIService.ExecQuery("SELECT * FROM Win32_NetworkAdapter")
$NACobjWMIService = ObjGet("winmgmts:root/CIMV2")
$NACcolItems = $NACobjWMIService.ExecQuery("SELECT * FROM Win32_NetworkAdapterConfiguration")
GUICtrlSetData($Progress1, 100)
GUICtrlSetData($Progress2, 46.0)
GUICtrlSetData($Percent1, "100%")
GUICtrlSetData($Percent2, "46.0%")

; ----------------------------------------------------------------------------
; Start Script
; ----------------------------------------------------------------------------
; Prompt for customer details using text input boxes
; ----------------------------------------------------------------------------
GUICtrlSetData($Label, "Collecting Customer Details")
GUICtrlSetData($Progress1, 0)
GUICtrlSetData($Percent1, "0%")
; ----------------------------------------------------------------------------
$ClientName = @ComputerName
GUICtrlSetData($Progress1, 100)
GUICtrlSetData($Progress2, 48.0)
GUICtrlSetData($Percent1, "100%")
GUICtrlSetData($Percent2, "48.0%")

; ----------------------------------------------------------------------------
; Open file for writing
; ----------------------------------------------------------------------------
GUICtrlSetData($Label, "Creating file for report")
GUICtrlSetData($Progress1, 0)
GUICtrlSetData($Percent1, "0%")
; ----------------------------------------------------------------------------
If $sDrvLetter = "" Then
	; USB Not found, fall back to System Drive
	$sDrvLetter = $OSSystemDrive
	MsgBox(64, "USB Not found", "USB Drive not found, defaulting save location to system drive", 3)
EndIf
; ----------------------------------------------------------------------------
$Report = FileOpen($sDrvLetter & "\" & @ComputerName & ".html", 10)
GUICtrlSetData($Progress1, 100)
GUICtrlSetData($Progress2, 52.0)
GUICtrlSetData($Percent1, "100%")
GUICtrlSetData($Percent2, "52.0%")

; ----------------------------------------------------------------------------
; Write header information
; ----------------------------------------------------------------------------
GUICtrlSetData($Label, "Writing HTML headers to report")
GUICtrlSetData($Progress1, 0)
GUICtrlSetData($Percent1, "0%")
; ----------------------------------------------------------------------------
FileWrite($Report, '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">' & @CRLF)
FileWrite($Report, '<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">' & @CRLF)
FileWrite($Report, '<head>' & @CRLF)
FileWrite($Report, '<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>' & @CRLF)
FileWrite($Report, '<title>Audit report for ' & @ComputerName & '</title>' & @CRLF)
FileWrite($Report, '<link rel="stylesheet" href="./Audit/css/global.css" type="text/css" />' & @CRLF)
FileWrite($Report, '</head>' & @CRLF)
FileWrite($Report, '<body>' & @CRLF)
FileWrite($Report, '<div id="wrapper">' & @CRLF)
FileWrite($Report, '<div id="headline">' & @CRLF)
;FileWrite($Report, '<h1>DOT-COMmunications Audit Report</h1>' & @CRLF)
FileWrite($Report, '</div>' & @CRLF)
FileWrite($Report, '<div id="byline">' & @CRLF)
FileWrite($Report, '<h2>Computer Name: ' & @ComputerName &  '<br />'& @CRLF)
FileWrite($Report, '</div>' & @CRLF)
GUICtrlSetData($Progress1, 100)
GUICtrlSetData($Progress2, 56.0)
GUICtrlSetData($Percent1, "100%")
GUICtrlSetData($Percent2, "56.0%")

; ----------------------------------------------------------------------------
; File prepared - Now begin writing report
; ----------------------------------------------------------------------------

; ----------------------------------------------------------------------------
; Left side - Operating System Details
; ----------------------------------------------------------------------------
GUICtrlSetData($Label, "Writing OS Details to report")
GUICtrlSetData($Progress1, 0)
GUICtrlSetData($Percent1, "0%")
; ----------------------------------------------------------------------------
FileWrite($Report, '<div class="twobobs">' & @CRLF)
FileWrite($Report, '<div class="twobobsleft">' & @CRLF)
GUICtrlSetData($Progress1, 50)
GUICtrlSetData($Progress2, 58.0)
GUICtrlSetData($Percent1, "50%")
GUICtrlSetData($Percent2, "58.0%")
FileWrite($Report, 'OS: ' & $OSName & ' (Build ' & $OSBuildNumber & ') <br />' & @CRLF)
FileWrite($Report, '</div>' & @CRLF)
GUICtrlSetData($Progress1, 100)
GUICtrlSetData($Progress2, 60.0)
GUICtrlSetData($Percent1, "100%")
GUICtrlSetData($Percent2, "60.0%")

; ----------------------------------------------------------------------------
; Right side - System Model Details
; ----------------------------------------------------------------------------
GUICtrlSetData($Label, "Writing System Details to report")
GUICtrlSetData($Progress1, 0)
GUICtrlSetData($Percent1, "0%")
; ----------------------------------------------------------------------------
;FileWrite($Report, '<div class="twobobsright">' & @CRLF)
GUICtrlSetData($Progress1, 50)
GUICtrlSetData($Progress2, 62.0)
GUICtrlSetData($Percent1, "50%")
GUICtrlSetData($Percent2, "62.0%")
FileWrite($Report, 'Model: ' & $SYSManufacturer & ' ' & $SYSModel & '<br />' & @CRLF)
FileWrite($Report, '</div>' & @CRLF)
FileWrite($Report, '</div>' & @CRLF)
GUICtrlSetData($Progress1, 100)
GUICtrlSetData($Progress2, 64.0)
GUICtrlSetData($Percent1, "100%")
GUICtrlSetData($Percent2, "64.0%")

; ----------------------------------------------------------------------------
; Left side - Processor Details
; ----------------------------------------------------------------------------
GUICtrlSetData($Label, "Writing Processor Details to report")
GUICtrlSetData($Progress1, 0)
GUICtrlSetData($Percent1, "0%")
; ----------------------------------------------------------------------------
;
; NEED TO PUT A NOTE SOMEWHERE ON SYSTEM IF HOTFIX IS INSTALLED AND REBOOTED
; SO THAT IT DOES NOT SKIP THE PROCESSOR DETAILS
;
; ----------------------------------------------------------------------------
FileWrite($Report, '<div class="twobobs">' & @CRLF)
FileWrite($Report, '<div class="twobobsleft">' & @CRLF)
$PROCount = 1
For $PROobjItem in $PROcolItems
	$PROCurrentSpeed = $PROobjItem.CurrentClockSpeed
	$PROSecondaryMemCache = $PROobjItem.L2CacheSize
	$PROName = $PROobjItem.Name
	$PROName = StringReplace($PROName, "(R)", " ")
	$PROName = StringReplace($PROName, "(TM)", " ")
	$PROName = StringStripWS($PROName, 7)
	GUICtrlSetData($Progress1, 33)
	GUICtrlSetData($Progress2, 65.0)
	GUICtrlSetData($Percent1, "33%")
	GUICtrlSetData($Percent2, "65.0%")
	FileWrite($Report, '<span style="float: left; height: 115px; display: block;">' & @CRLF)
	FileWrite($Report, 'CPU: ' & CPUDetection($PROName) & '<br />' & @CRLF)
	FileWrite($Report, '</span>' & @CRLF & '<span style="display: block;">' & @CRLF)
	$PROSocket = $PROobjItem.SocketDesignation
	GUICtrlSetData($Progress1, 66)
	GUICtrlSetData($Progress2, 66.5)
	GUICtrlSetData($Percent1, "66%")
	GUICtrlSetData($Percent2, "66.5%")
	FileWrite($Report, $PROName & '<br />' & @CRLF)
	If StringInStr($OSName, "2003") Then
		$var = RegEnumKey("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Updates\Windows Server 2003\SP3\KB932370-v3", 1)
		If $var <> "Filelist" Then
			$PROHotfix = MsgBox(36, "Missing Hotfix", "To obtain detailed processor information on Windows Server 2003 an OPTIONAL hotifx is required, would you like to install this now?" & @CRLF & @CRLF & "NOTE: A REBOOT WILL BE REQUIRED FOR THIS TO TAKE EFFECT")
			If $PROHotfix = 6 Then
				If @CPUArch = "X64" Then
					RunWait($sDrvLetter & "\Audit\WindowsServer2003x64.exe")
				Else
					RunWait($sDrvLetter & "\Audit\WindowsServer2003x86.exe")
				EndIf
			Else
				; Skip hotfix
				FileWrite($Report, "<i>Processor core count not available on Windows Server 2003 due to missing hotfix</i><br />" & @CRLF)
			EndIf
		Else
			For $COMobjItem in $COMcolItems
				$PROLogProc = $PROobjItem.NumberOfLogicalProcessors
				$PROCores = $PROobjItem.NumberOfCores
				ExitLoop
			Next
			If $PROCores > 1 Then
				$PROCoreNotes = "Multi-Core (" & $PROCores & " Total)"
			Else
				$PROCoreNotes = "Single-Core"
			EndIf
			FileWrite($Report, $PROCoreNotes & '<br />' & @CRLF)
			If $PROLogProc > $PROCores Then
				$PROLogProcNotes = "Hyper Threaded (" & $PROLogProc & " Logical Cores Total)"
			Else
				$PROLogProcNotes = "Non-Hyper Threaded (" & $PROLogProc & " Logical Cores Total)"
			EndIf
			EndIf
	Else
		For $COMobjItem in $COMcolItems
			$PROLogProc = $PROobjItem.NumberOfLogicalProcessors
			$PROCores = $PROobjItem.NumberOfCores
			ExitLoop
		Next
		If $PROCores > 1 Then
			$PROCoreNotes = "Multi-Core (" & $PROCores & " Total)"
		Else
			$PROCoreNotes = "Single-Core"
		EndIf
		;FileWrite($Report, $PROCoreNotes & '<br />' & @CRLF)
		If $PROLogProc > $PROCores Then
			$PROLogProcNotes = "Hyper Threaded (" & $PROLogProc & " Logical Cores Total)"
		Else
			$PROLogProcNotes = "Non-Hyper Threaded (" & $PROLogProc & " Logical Cores Total)"
		EndIf
		EndIf
	$PROCount = $PROCount + 1
	FileWrite($Report, '</span>' & @CRLF)
Next
FileWrite($Report, '</div>' & @CRLF)
GUICtrlSetData($Progress1, 100)
GUICtrlSetData($Progress2, 68.0)
GUICtrlSetData($Percent1, "100%")
GUICtrlSetData($Percent2, "68.0%")

; ----------------------------------------------------------------------------
; Right side - Main Circuit Board
; ----------------------------------------------------------------------------
GUICtrlSetData($Label, "Writing Motherboard Details to report")
GUICtrlSetData($Progress1, 0)
GUICtrlSetData($Percent1, "0%")
; ----------------------------------------------------------------------------
;FileWrite($Report, '<div class="twobobsright">' & @CRLF)
;FileWrite($Report, '<span class="secheader">Main Circuit Board</span><br />' & @CRLF)
GUICtrlSetData($Progress1, 500)
GUICtrlSetData($Progress2, 70.0)
GUICtrlSetData($Percent1, "50%")
GUICtrlSetData($Percent2, "70.0%")
FileWrite($Report, 'Board: ' & $BBMManufacturer & ' ' & $BBMProduct & '<br />' & @CRLF)
;FileWrite($Report, 'BIOS: ' & $BIOManufacturer & ' ' & $BIOVersion & ' ' & $BIORelDay & '/' & $BIORelMonth & '/' & $BIORelYear & '<br />' & @CRLF)
;FileWrite($Report, '</div>' & @CRLF)
FileWrite($Report, '</div>' & @CRLF)
GUICtrlSetData($Progress1, 100)
GUICtrlSetData($Progress2, 72.0)
GUICtrlSetData($Percent1, "100%")
GUICtrlSetData($Percent2, "72.0%")

; ----------------------------------------------------------------------------
; Left side - Drive Details
; ----------------------------------------------------------------------------
GUICtrlSetData($Label, "Writing Drive Details to report")
GUICtrlSetData($Progress1, 0)
GUICtrlSetData($Percent1, "0%")
; ----------------------------------------------------------------------------
FileWrite($Report, '<div class="twobobs">' & @CRLF)
FileWrite($Report, '<div class="twobobsleft">' & @CRLF)
; Optical Drives
For $OPTobjItem in $OPTcolItems
	$OPTName = $OPTobjItem.Name
	$OPTDrive = $OPTobjItem.Drive
	$OPTType = $OPTobjItem.MediaType
Next
GUICtrlSetData($Progress1, 33)
GUICtrlSetData($Progress2, 73.5)
GUICtrlSetData($Percent1, "33%")
GUICtrlSetData($Percent2, "73.5%")
;FileWrite($Report, '<br /><span class="secheader">Local Drives</span><br />' & @CRLF)
; Disk Drives including USB
For $DIDobjItem in $DIDcolItems
	$DIDModel = $DIDobjItem.Model
	$DIDInterface = $DIDobjItem.InterfaceType
	$DIDSize = $DIDobjItem.Size
	$DIDIndex = $DIDobjItem.Index
	If $DIDInterface = "USB" Then
		$DIDIntType = "USB Drive"
	Else
		$DIDIntType = "Hard Drive"
	EndIf
	; Calculate Size in readable format
	If $DIDSize > 1073741823 Then
		$DIDCapacity = Round($DIDSize / 1000 / 1000 / 1000, 2) & ' GB'
	Else
		$DIDCapacity = Round($DIDSize / 1000 / 1000, 2) & ' MB'
	EndIf
	FileWrite($Report, 'Disk: ' & $DIDModel & ' [' & $DIDIntType & '] ' & '(' & $DIDCapacity & ') -- Drive ' & $DIDIndex & '<br />' & @CRLF)
Next
GUICtrlSetData($Progress1, 66)
GUICtrlSetData($Progress2, 75.5)
GUICtrlSetData($Percent1, "66%")
GUICtrlSetData($Percent2, "75.0%")
; Partitions on drives
For $LDPobjItem in $LDPcolItems
	$LDPAnt = $LDPobjItem.Antecedent
	$LDPAntExplode1 = StringSplit($LDPAnt, "#")
	$LDPAntExplode2 = StringSplit($LDPAntExplode1[2], ",")
	$LDPAntFinal = $LDPAntExplode2[1]
	$LDPDep = $LDPobjItem.Dependent
	$LDPDepExplode1 = StringSplit($LDPDep, '"')
	$LDPDepFinal = $LDPDepExplode1[2]
	For $LDDobjItem in $LDDcolItems
		$LDDFileSystem = $LDDobjItem.FileSystem
		$LDDFreeSpace = $LDDobjItem.FreeSpace
		If $LDDFreeSpace > 1073741823 Then
		$LDDFreeCapacity = Round($LDDFreeSpace / 1000 / 1000 / 1000, 2) & ' GB'
		Else
		$LDDFreeCapacity = Round($LDDFreeSpace / 1000 / 1000, 2) & ' MB'
		EndIf
		$LDDSize = $LDDobjItem.Size
		If $LDDSize > 1073741823 Then
		$LDDCapacity = Round($LDDSize / 1000 / 1000 / 1000, 2) & ' GB'
		Else
		$LDDCapacity = Round($LDDSize / 1000 / 1000, 2) & ' MB'
		EndIf
		$LDDDep = $LDDobjItem.DeviceID
		While $LDPDepFinal = $LDDDep
	;		FileWrite($Report, '<span style="display: inline-block; width: 200px;">' & $LDPDepFinal & ' (' & $LDDFileSystem & ' on drive ' & $LDPAntFinal & ')</span><span style="display: inline-block; width: 100px; margin-left: 20px;">' & $LDDCapacity & '</span><span style="display: inline-block; width: 100px; margin-left: 20px;">' & $LDDFreeCapacity & ' free</span><br />' & @CRLF)
			ExitLoop
		WEnd
	Next
Next
GUICtrlSetData($Progress1, 100)
GUICtrlSetData($Progress2, 76.0)
GUICtrlSetData($Percent1, "100%")
GUICtrlSetData($Percent2, "76.0%")

; ----------------------------------------------------------------------------
; Right side - Memory Details
; ----------------------------------------------------------------------------
GUICtrlSetData($Label, "Writing Memory Details to report")
GUICtrlSetData($Progress1, 0)
GUICtrlSetData($Percent1, "0%")
; ----------------------------------------------------------------------------
FileWrite($Report, '<div class="twobobsright">' & @CRLF)
;FileWrite($Report, '<span class="secheader">Memory Modules</span><br />' & @CRLF)
GUICtrlSetData($Progress1, 50)
GUICtrlSetData($Progress2, 78.0)
GUICtrlSetData($Percent1, "50%")
GUICtrlSetData($Percent2, "78.0%")
; Process Memory Total
If $OSMemory > 1073741823 Then
	$MemoryTotal = Ceiling($OSMemory / 1024 / 1024)
Else
	$MemoryTotal = Ceiling($OSMemory / 1024)
EndIf
FileWrite($Report, 'RAM: ' & $MemoryTotal & ' Megabytes<br /><br />' & @CRLF)
For $MEMobjItem in $MEMcolItems
	$MEMCapacity = $MEMobjItem.Capacity
	; Process Capacity
	$MEMCapacity = $MEMCapacity / 1024 / 1024 & ' Megabyte'
	$MEMFormFactor = FormFactor($MEMobjItem.FormFactor)
	$MEMType = MemoryType($MEMobjItem.MemoryType)
	$MEMSpeed = $MEMobjItem.Speed
	$MEMBank = $MEMobjItem.BankLabel
	If $MEMBank =  "" Then
		$MEMBank = $MEMobjItem.DeviceLocator
	Else
		; Do nothing
	EndIf
	; Check if bank label contains work bank and remove if it does
	If StringInStr($MEMBank, "Bank") Then
		$MEMBank = StringReplace($MEMBank, "Bank", "")
	Else
		; Do nothing
	EndIf
	If $MEMFormFactor = "DIMM" Then
		;FileWrite($Report, 'Bank ' & $MEMBank & ' contains a ' & $MEMCapacity & ' ' & $MEMFormFactor & ' running at ' & $MEMSpeed & ' Mhz<br />' & @CRLF)
	ElseIf $MEMFormFactor = "SODIMM" Then
		;FileWrite($Report, 'Bank ' & $MEMBank & ' contains a ' & $MEMCapacity & ' ' & $MEMFormFactor & ' running at ' & $MEMSpeed & ' Mhz<br />' & @CRLF)
	ElseIf $MEMFormFactor = "SIMM" Then
		;FileWrite($Report, 'Bank ' & $MEMBank & ' contains a ' & $MEMCapacity & ' ' & $MEMFormFactor & ' running at ' & $MEMSpeed & ' Mhz<br />' & @CRLF)
	Else
		; Check Type
		If $MEMType = "DDR" Then
		;	FileWrite($Report, 'Bank ' & $MEMBank & ' contains a ' & $MEMCapacity & ' ' & $MEMType & ' running at ' & $MEMSpeed & ' Mhz<br />' & @CRLF)
		ElseIf $MEMType = "DDR-2" Then
		;	FileWrite($Report, 'Bank ' & $MEMBank & ' contains a ' & $MEMCapacity & ' ' & $MEMType & ' running at ' & $MEMSpeed & ' Mhz<br />' & @CRLF)
		ElseIf $MEMType = "SDRAM" Then
		;	FileWrite($Report, 'Bank ' & $MEMBank & ' contains a ' & $MEMCapacity & ' ' & $MEMType & ' running at ' & $MEMSpeed & ' Mhz<br />' & @CRLF)
		Else
			; Do nothing
		EndIf
	EndIf
Next
FileWrite($Report, '</div>' & @CRLF)
FileWrite($Report, '</div>' & @CRLF)
GUICtrlSetData($Progress1, 100)
GUICtrlSetData($Progress2, 80.0)
GUICtrlSetData($Percent1, "100%")
GUICtrlSetData($Percent2, "80.0%")

; ----------------------------------------------------------------------------
; Left side - User Details
; ----------------------------------------------------------------------------
GUICtrlSetData($Label, "Writing User Account details to report")
GUICtrlSetData($Progress1, 0)
GUICtrlSetData($Percent1, "0%")
; ----------------------------------------------------------------------------
GUICtrlSetData($Progress1, 50)
GUICtrlSetData($Progress2, 82.0)
GUICtrlSetData($Percent1, "50%")
GUICtrlSetData($Percent2, "82.0%")
;If StringInStr($SYSDomainRole, "Domain Controller") Then
;	FileWrite($Report, "<i>Local user account details are not available on Domain Controllers</i><br />" & @CRLF)
;Else
;	For $USEobjItem in $USEcolItems
;		$USECaption = $USEobjItem.Caption
;		$USEDisabled = $USEobjItem.Disabled
;		$USEName = $USEobjItem.Name
;		$String2 = @ComputerName
;		$String2Len = StringLen($String2)
;		$String2Len = $String2Len + 1
;		$USEAccountName = StringTrimLeft($USECaption, $String2Len)
;		If $USEDisabled = "True" Then
;			FileWrite($Report, '<img src="./Audit/X.jpg"><span style="display: inline-block; width: 200px; margin-left: 10px;">' & $USEAccountName & '</span><br />' & @CRLF)
;		Else
;			FileWrite($Report, '<span style="display: inline-block; width: 200px;">' & $USEAccountName & '</span><br />' & @CRLF)
;		EndIf
;	Next
;EndIf
FileWrite($Report, '</div>' & @CRLF)
GUICtrlSetData($Progress1, 100)
GUICtrlSetData($Progress2, 84.0)
GUICtrlSetData($Percent1, "100%")
GUICtrlSetData($Percent2, "84.0%")

; ----------------------------------------------------------------------------
; Right side - Mapped Network Drives
; ----------------------------------------------------------------------------
GUICtrlSetData($Label, "Writing Network Drive Details to report")
GUICtrlSetData($Progress1, 0)
GUICtrlSetData($Percent1, "0%")
; ----------------------------------------------------------------------------
;FileWrite($Report, '<div class="twobobsright">' & @CRLF)
;FileWrite($Report, '<span class="secheader">Network Drives</span><br />' & @CRLF)
;GUICtrlSetData($Progress1, 50)
;GUICtrlSetData($Progress2, 86.0)
;GUICtrlSetData($Percent1, "50%")
;GUICtrlSetData($Percent2, "86.0%")
;For $MLDobjItem in $MLDcolItems
;	$MLDDrive = $MLDobjItem.DeviceID
;	$MLDProvider = $MLDobjItem.ProviderName
;	$MLDFreeSpace = $MLDobjItem.FreeSpace
;	If $MLDFreeSpace > 1073741823 Then
;		$MLDFreeCapacity = Round($MLDFreeSpace / 1000 / 1000 / 1000, 2) & ' GB'
;	Else
;		$MLDFreeCapacity = Round($MLDFreeSpace / 1000 / 1000, 2) & ' MB'
;	EndIf
;	$MLDSize = $MLDobjItem.Size
;	If $MLDSize > 1073741823 Then
;		$MLDCapacity = Round($MLDSize / 1000 / 1000 / 1000, 2) & ' GB'
;	Else
;		$MLDCapacity = Round($MLDSize / 1000 / 1000, 2) & ' MB'
;	EndIf
;	FileWrite($Report, '<span style="display: inline-block; width: 15px;">' & $MLDDrive & '</span><span style="display: inline-block; width: 200px; margin-left: 10px;">' & $MLDProvider & '</span><span style="display: inline-block; width: 100px; margin-left: 10px;">' & $MLDCapacity & '</span><span style="display: inline-block; width: 120px; margin-left: 10px;">' & $MLDFreeCapacity & ' free</span><br />' & @CRLF)
;Next
;FileWrite($Report, '</div>' & @CRLF)
;FileWrite($Report, '</div>' & @CRLF)
GUICtrlSetData($Progress1, 100)
GUICtrlSetData($Progress2, 88.0)
GUICtrlSetData($Percent1, "100%")
GUICtrlSetData($Percent2, "88.0%")

; ----------------------------------------------------------------------------
; Left side - Printer Details
; ----------------------------------------------------------------------------
;GUICtrlSetData($Label, "Writing Printer Details to report")
;GUICtrlSetData($Progress1, 0)
;GUICtrlSetData($Percent1, "0%")
; ----------------------------------------------------------------------------
;FileWrite($Report, '<div class="twobobs">' & @CRLF)
;FileWrite($Report, '<div class="twobobsleft">' & @CRLF)
;FileWrite($Report, '<span class="secheader">Printers</span><br />' & @CRLF)
GUICtrlSetData($Progress1, 50)
GUICtrlSetData($Progress2, 90.0)
GUICtrlSetData($Percent1, "50%")
GUICtrlSetData($Percent2, "90.0%")
;For $PRIobjItem in $PRIcolItems
;	$PRIName = $PRIobjItem.DriverName
;	$PRIPort = $PRIobjItem.PortName
;	FileWrite($Report, '<span style="display: inline-block; width: 220px;">' & $PRIName & '</span><span style="display: inline-block; width: 220px; margin-left: 20px;"> on ' & $PRIPort & '</span><br />' & @CRLF)
;Next
;FileWrite($Report, '</div>' & @CRLF)
GUICtrlSetData($Progress1, 100)
GUICtrlSetData($Progress2, 92.0)
GUICtrlSetData($Percent1, "100%")
GUICtrlSetData($Percent2, "92.0%")

; ----------------------------------------------------------------------------
; Right side - Display Details
; ----------------------------------------------------------------------------
GUICtrlSetData($Label, "Writing Display Details to report")
GUICtrlSetData($Progress1, 0)
GUICtrlSetData($Percent1, "0%")
; ----------------------------------------------------------------------------
;FileWrite($Report, '<div class="twobobsright">' & @CRLF)
;FileWrite($Report, '<span class="secheader">Display</span><br />' & @CRLF)
GUICtrlSetData($Progress1, 50)
GUICtrlSetData($Progress2, 93.0)
GUICtrlSetData($Percent1, "50%")
GUICtrlSetData($Percent2, "93.0%")
;For $VIDobjItem in $VIDcolItems
;	$VIDName = $VIDobjItem.Name
;	$VIDType = "[Display Adapter]"
;	FileWrite($Report, '<span style="display: inline-block; width: 300px;">' & $VIDName & '</span><span style="display: inline-block; width: 150px; margin-left: 10px;">' & $VIDType & '</span><br />' & @CRLF)
;Next
;FileWrite($Report, '</div>' & @CRLF)
GUICtrlSetData($Progress1, 100)
GUICtrlSetData($Progress2, 94.0)
GUICtrlSetData($Percent1, "100%")
GUICtrlSetData($Percent2, "94.0%")

; --------------------------------------------------------------------------------
; Left side - Anti-Virus Details
; --------------------------------------------------------------------------------
GUICtrlSetData($Label, "Collect and Write Anti-Virus information to report")
GUICtrlSetData($Progress1, 0)
GUICtrlSetData($Percent1, "0%")
;FileWrite($Report, '<div class="twobobs">' & @CRLF)
;FileWrite($Report, '<div class="twobobsleft">' & @CRLF)
;FileWrite($Report, '<span class="secheader">Virus Protection</span><br />' & @CRLF)
; --------------------------------------------------------------------------------
;$sName = ""
;$sWMIService = "winmgmts:root/SecurityCenter2"
;$objWMIService = ObjGet($sWMIService)
;If IsObj($objWMIService) Then
;    $colItems = $objWMIService.ExecQuery("SELECT * FROM AntiVirusProduct")
;    If IsObj($colItems) Then
;        For $oItem In $colItems
;            $sName = $oItem.displayName
;			$sVersion = $oItem.productState
;			FileWrite($Report, "Anti-Virus Name: " & $sName & "<br />")
;			If $sVersion = 266240 Then
;				$state = "Up to date & On-Access Scanning Enabled"
;			ElseIf $sVersion = 262144 Then
;				$state = "Up to date but On-Access Scanning is disabled"
;			Else
;				$state = InputBox("Anti-Virus Status", "Anti-Virus state could not be determined automatically, please check the program and Windows Security Centre and record the state in the box below: ")
;			EndIf
;			FileWrite($Report, "Anti-Virus State: " & $state & "<br />")
 ;       Next
 ;   Else
  ;      MsgBox(16, "Error", "Failed to get Win32_BaseBoard collection.")
 ;   EndIf
;Else
;	$sWMIService = "winmgmts:root/SecurityCenter"
;	$objWMIService = ObjGet($sWMIService)
;	If IsObj($objWMIService) Then
;		$colItems = $objWMIService.ExecQuery("SELECT * FROM AntiVirusProduct")
;		If IsObj($colItems) Then
;			For $oItem In $colItems
;				$sName = $oItem.displayName
;				$sVersion = $oItem.versionNumber
;				$sUpToDate = $oItem.productUptoDate
;				FileWrite($Report, "Anti-Virus Name: " & $sName & " " & $sVersion & "<br />")
;				If $sUpToDate = "True" Then
;					$state = "Up to date, please manually check if on-access scanning is enabled"
;				Else
;					$state = "Out of date, please update and manually check if on-access scanning is enabled"
;				EndIf
;				FileWrite($Report, "Anti-Virus State: " & $state & "<br />")
;			Next
;		Else
;			MsgBox(16, "Error", "Failed to get Win32_BaseBoard collection.")
;		EndIf
;	Else
;		FileWrite($Report, "<i>Anti-Virus information cannot be automatically determined due to operating system configuration</i><br />" & @CRLF)
;		$sName = "1"
;	EndIf
;EndIf
;If $sName = "" Then
;	FileWrite($Report, '<i>No details available</i><br />' & @CRLF)
;EndIf
;FileWrite($Report, '</div>' & @CRLF)

; ----------------------------------------------------------------------------
; Right side - Communications Details
; ----------------------------------------------------------------------------
GUICtrlSetData($Label, "Writing Communications Details to report")
GUICtrlSetData($Progress1, 0)
GUICtrlSetData($Percent1, "0%")
; ----------------------------------------------------------------------------
FileWrite($Report, '<div class="twobobsright">' & @CRLF)
;FileWrite($Report, '<span class="secheader">Communications</span>' & @CRLF)
For $NETobjItem in $NETcolItems
	$NETConnection = $NETobjItem.NetConnectionID
	If $NETConnection = "" Then
		; Do nothing with this result
	Else
		$NETName = $NETobjItem.Name
		$NETDeviceID = $NETobjItem.DeviceID
		FileWrite($Report, '<br />' & 'NIC: ' & $NETName & '<br />' & @CRLF)
		For $NACobjItem in $NACcolItems
			$NACIndex = $NACobjItem.Index
			While $NACIndex = $NETDeviceID
				Global $NACGateway[1]
				Global $NACIPAddress[1]
				Global $NACIPSubnet[1]
				Global $NACDNSServer[1]
				$NACIPAddress = $NACobjItem.IPAddress
				$NACIPSubnet = $NACobjItem.IPSubnet
				$NACGateway = $NACobjItem.DefaultIPGateway
				$NACMACAddress = $NACobjItem.MACAddress
				$NACDNSServer = $NACobjItem.DNSServerSearchOrder
				$NACConnected = $NACobjItem.IPEnabled
				If $NACConnected = "True" Then
					If $NACIPAddress[0] = "" Then
						; Do Nothing
					Else
						FileWrite($Report, '<span style="display: inline-block; margin-left: 20px; width: 100px;">IP Address:</span><span style="display: inline-block; margin-left: 20px; width: 300px;">' & $NACIPAddress[0] & '</span><br />' & @CRLF)
					EndIf
					If $NACIPSubnet[0] = "" Then
						; Do Nothing
					Else
						;FileWrite($Report, '<span style="display: inline-block; margin-left: 20px; width: 100px;">Subnet:</span><span style="display: inline-block; margin-left: 20px; width: 300px;">' & $NACIPSubnet[0] & '</span><br />' & @CRLF)
					EndIf
					If $NACGateway = "" Then
						;FileWrite($Report, '<span style="display: inline-block; margin-left: 20px; width: 100px;">Gateway:</span><span style="display: inline-block; margin-left: 20px; width: 300px;">Machine is gateway</span><br />' & @CRLF)
					Else
						;FileWrite($Report, '<span style="display: inline-block; margin-left: 20px; width: 100px;">Gateway:</span><span style="display: inline-block; margin-left: 20px; width: 300px;">' & $NACGateway[0] & '</span><br />' & @CRLF)
					EndIf
					FileWrite($Report, '<span style="display: inline-block; margin-left: 20px; width: 100px;">MAC Address:</span><span style="display: inline-block; margin-left: 20px; width: 300px;">' & $NACMACAddress & '</span><br />' & @CRLF)
					If UBound($NACDNSServer) > 0 Then
						If $NACDNSServer[0] = "" Then
							; Do Nothing
						Else
						;	FileWrite($Report, '<span style="display: inline-block; margin-left: 20px; width: 100px;">DNS Server 1:</span><span style="display: inline-block; margin-left: 20px; width: 300px;">' & $NACDNSServer[0] & '</span><br />')
							If $NACDNSServer[1] = "" Then
						;		FileWrite($Report, '<br />' & @CRLF)
							Else
						;		FileWrite($Report, @CRLF & '<span style="display: inline-block; margin-left: 20px; width: 100px;">DNS Server 2:</span><span style="display: inline-block; margin-left: 20px; width: 300px;">' & $NACDNSServer[1] & '</span><br />' & @CRLF)
							EndIf
						EndIf
					EndIf
				Else
					;FileWrite($Report, '<span style="display: inline-block; margin-left: 20px; width: 300px;">Not currently connected</span>' & @CRLF)
				EndIf
			ExitLoop
		WEnd
	Next
	EndIf
Next

; Add blank space between boxes
FileWrite($Report, '</div></div>' & @CRLF)
FileWrite($Report, '<div class="space"></div>' & @CRLF)

Local $console = Run(@ComSpec & " /c wmic bios get serialnumber", @ScriptDir, @SW_HIDE, $STDOUT_CHILD)
Local $line, $Result = ""
While 1
    Sleep(100)
    $line = StdOutRead($console)
    If @error Then ExitLoop
    $Result = $line
Wend
$Result = StringTrimLeft($Result, 17)
FileWrite($Report, 'SN: ' & $Result & '<br />' & @CRLF)

; ----------------------------------------------------------------------------
; Central - Available Updates
; ----------------------------------------------------------------------------
;FileWrite($Report, '<div id="availableupdates">' & @CRLF)
;FileWrite($Report, '<span class="secheader">Available Updates</span><br />' & @CRLF)
;$WUInstallPath = $sDrvLetter & "\Audit\WUInstall.exe /search"
;$pid = Run($WUInstallPath, "", @SW_HIDE, 2); Stdout
; ----------------------------------------------------------------------------
GUICtrlSetData($Label, "Collecting Available Update details")
GUICtrlSetData($Progress1, 0)
GUICtrlSetData($Percent1, "0%")
; ----------------------------------------------------------------------------
;Global $data
;Do
;    $data &= StdOutRead($pid)
;Until @error
GUICtrlSetData($Progress1, 100)
GUICtrlSetData($Progress2, 95.0)
GUICtrlSetData($Percent1, "100%")
GUICtrlSetData($Percent2, "95.0%")
; ----------------------------------------------------------------------------
GUICtrlSetData($Label, "Writing Available Update details to report")
GUICtrlSetData($Progress1, 0)
GUICtrlSetData($Percent1, "0%")
; ----------------------------------------------------------------------------
;If StringInStr($data, "Succeeded") Then
;	$DataArray1 = StringSplit($data, "Succeeded", 1)
;	$DataArray2 = StringTrimLeft($DataArray1[2], 4)
;	$DataArray3 = StringSplit($DataArray2, "only /search", 1)
;	$DataFinal = $DataArray3[1]
;	$DataFinal = StringTrimRight($DataFinal, 2)
;	$DataFinal = StringReplace($DataFinal, "found", "available", 1)
;	$DataFinal = StringReplace($DataFinal, @CR, "<br />")
;	FileWrite($Report, $DataFinal & @CRLF)
;Else
;	FileWrite($Report, '<i>No details available</i><br />' & @CRLF)
;EndIf
GUICtrlSetData($Progress1, 100)
GUICtrlSetData($Progress2, 96.0)
GUICtrlSetData($Percent1, "100%")
GUICtrlSetData($Percent2, "96.0%")
FileWrite($Report, '</div>' & @CRLF)

; Add blank space between boxes
FileWrite($Report, '<div class="space"></div>' & @CRLF)

; ----------------------------------------------------------------------------
; Central - Installed Updates
; ----------------------------------------------------------------------------
;FileWrite($Report, '<div id="installedsoftware">' & @CRLF)
;FileWrite($Report, '<span class="secheader">Installed Software</span><br />' & @CRLF)
;FileWrite($Report, '<span style="display: inline-block; width: 210px; text-align: center; text-decoration: underline; font-weight: bold;">Publisher</span><span style="display: inline-block; width: 510px; margin-left: 11px; text-align: center; text-decoration: underline; font-weight: bold;">Package Name</span><span style="display: inline-block; width: 210px; margin-left: 11px; text-align: center; text-decoration: underline; font-weight: bold;">Version</span><br /><br />' & @CRLF)
;Dim $Software
;_ComputerGetSoftware($Software)
;For $i = 1 To $Software[0][0] Step 1
;	If $Software[$i][0] = "" Then
;		; Ignore this result and move on to the next
;;	Else
	;	If StringInStr($Software[$i][0], "Security Update for") Then
	;		; Ignore this result and move on to the next
	;	ElseIf StringInStr($Software[$i][0], "Critical Update for") Then
	;		; Ignore this result and move on to the next
	;	ElseIf StringInStr($Software[$i][0], "Definition Update for") Then
	;		; Ignore this result and move on to the next
	;	ElseIf StringInStr($Software[$i][0], "Update for") Then
	;		; Ignore this result and move on to the next
	;	ElseIf StringInStr($Software[$i][0], "Hotfix for") Then
	;		; Ignore this result and move on to the next
	;	ElseIf StringInStr($Software[$i][0], "Microsoft Office 2007 Service Pack 2 (SP2)") Then
			; Ignore this result and move on to the next
	;	Else
			; Result is okay and wanted so write details to report
;			FileWrite($Report, '<span style="display: inline-block; width: 210px;">')
;			If $Software[$i][2] = "" Then
				; Do nothing
;				FileWrite($Report, '&nbsp;</span><span style="display: inline-block; width: 510px; margin-left: 11px;">')
;			Else
				; Write details and setup span for next bit
;				FileWrite($Report, $Software[$i][2])
;				FileWrite($Report, '</span><span style="display: inline-block; width: 510px; margin-left: 11px;">')
;			EndIf
;			If $Software[$i][0] = "" Then
				; Do nothing
;				FileWrite($Report, '&nbsp;</span><span style="display: inline-block; width: 210px; margin-left: 11px;">')
;			Else
				; Write details and setup span for next bit
;				FileWrite($Report, $Software[$i][0])
;				FileWrite($Report, '</span><span style="display: inline-block; width: 210px; margin-left: 11px;">')
;			EndIf
;			If $Software[$i][1] = "" Then
				; Do nothing
;				FileWrite($Report, '&nbsp;</span>')
;			Else
				; Write details and setup span for next bit
;				FileWrite($Report, $Software[$i][1])
;				FileWrite($Report, '</span>')
;			EndIf
;			FileWrite($Report, '<br />' & @CRLF)
;		EndIf
;	EndIf
;Next
;FileWrite($Report, '</div>' & @CRLF)

; ----------------------------------------------------------------------------
; Close report and display time taken
; ----------------------------------------------------------------------------
GUICtrlSetData($Label, "Closing Report File")
GUICtrlSetData($Progress1, 0)
GUICtrlSetData($Percent1, "0%")
; ----------------------------------------------------------------------------
FileWrite($Report, '<div class="space"></div></div>' & @CRLF)
FileClose($Report)
GUICtrlSetData($Progress1, 100)
GUICtrlSetData($Progress2, 96.0)
GUICtrlSetData($Percent1, "100%")
GUICtrlSetData($Percent2, "96.0%")

; End Time Test
$TimeDiff = TimerDiff($TimerStart)
; Process time to seconds and/or minutes
If $TimeDiff > "60000" Then
	$ExecTime = Round($TimeDiff / 60000, 0) & " Minutes"
Else
	$ExecTime = Round($TimeDiff / 1000, 0) & " Seconds"
EndIf
; ----------------------------------------------------------------------------
; Display time taken
; ----------------------------------------------------------------------------
GUICtrlSetData($Label, "Displaying time taken")
GUICtrlSetData($Progress1, 0)
GUICtrlSetData($Percent1, "0%")
; ----------------------------------------------------------------------------
;MsgBox(64, "Time", $ExecTime)
GUICtrlSetData($Progress1, 100)
GUICtrlSetData($Progress2, 100)
GUICtrlSetData($Percent1, "100%")
GUICtrlSetData($Percent2, "100%")
sleep(3000)
Exit

; ----------------------------------------------------------------------------
; Additional Functions - Placed here to keep code clean above
; ----------------------------------------------------------------------------
; Function Enclosure - Accepts 1 parameter and sets this as $EncNum
; Purpose: To convert enclosure type number to an enclosure type string
; ----------------------------------------------------------------------------



Func Enclosure($EncNum = "")
	Select
		Case $EncNum = "1"
			Return "Other"
		Case $EncNum = "2"
			Return "Unknown"
		Case $EncNum = "3"
			Return "Desktop"
		Case $EncNum = "4"
			Return "Low Profile Desktop"
		Case $EncNum = "5"
			Return "Pizza Box"
		Case $EncNum = "6"
			Return "Mini Tower"
		Case $EncNum = "7"
			Return "Tower"
		Case $EncNum = "8"
			Return "Portable"
		Case $EncNum = "9"
			Return "Laptop"
		Case $EncNum = "10"
			Return "Notebook"
		Case $EncNum = "11"
			Return "Hand Held"
		Case $EncNum = "12"
			Return "Docking Station"
		Case $EncNum = "13"
			Return "All in One"
		Case $EncNum = "14"
			Return "Sub Notebook"
		Case $EncNum = "15"
			Return "Space-Saving"
		Case $EncNum = "16"
			Return "Lunch Box"
		Case $EncNum = "17"
			Return "Main System Chassis"
		Case $EncNum = "18"
			Return "Expansion Chassis"
		Case $EncNum = "19"
			Return "SubChassis"
		Case $EncNum = "20"
			Return "Bus Expansion Chassis"
		Case $EncNum = "21"
			Return "Peripheral Chassis"
		Case $EncNum = "22"
			Return "Storage Chassis"
		Case $EncNum = "23"
			Return "Rack Mount Chassis"
		Case $EncNum = "24"
			Return "Sealed-Case PC"
	EndSelect
EndFunc

Func DomainRole($DomainString)
	Select
		Case $DomainString = "0"
			Return "Standalone Workstation"
		Case $DomainString = "1"
			Return "Workstation"
		Case $DomainString = "2"
			Return "Standalone Server"
		Case $DomainString = "3"
			Return "Member Server"
		Case $DomainString = "4"
			Return "Backup Domain Controller"
		Case $DomainString = "5"
			Return "Primary Domain Controller"
	EndSelect
EndFunc

Func FormFactor($FFString)
	Select
		Case $FFString = "1"
			Return "Other"
		Case $FFString = "2"
			Return "SIP"
		Case $FFString = "3"
			Return "DIP"
		Case $FFString = "4"
			Return "ZIP"
		Case $FFString = "5"
			Return "SOJ"
		Case $FFString = "6"
			Return "Proprietary"
		Case $FFString = "7"
			Return "SIMM"
		Case $FFString = "8"
			Return "DIMM"
		Case $FFString = "9"
			Return "TSOP"
		Case $FFString = "10"
			Return "PGA"
		Case $FFString = "11"
			Return "RIMM"
		Case $FFString = "12"
			Return "SODIMM"
		Case $FFString = "13"
			Return "SRIMM"
		Case $FFString = "14"
			Return "SMD"
		Case $FFString = "15"
			Return "SSMP"
		Case $FFString = "16"
			Return "QFP"
		Case $FFString = "17"
			Return "TQFP"
		Case $FFString = "18"
			Return "SOIC"
		Case $FFString = "19"
			Return "LCC"
		Case $FFString = "20"
			Return "PLCC"
		Case $FFString = "21"
			Return "BGA"
		Case $FFString = "22"
			Return "FPBGA"
		Case $FFString = "23"
			Return "LGA"
		Case Else
			Return "Unknown"
	EndSelect
EndFunc

Func MemoryType($MTString)
	Select
		Case $MTString = "1"
			Return "Other"
		Case $MTString = "2"
			Return "DRAM"
		Case $MTString = "3"
			Return "Synchronous DRAM"
		Case $MTString = "4"
			Return "Cache DRAM"
		Case $MTString = "5"
			Return "EDO"
		Case $MTString = "6"
			Return "EDRAM"
		Case $MTString = "7"
			Return "VRAM"
		Case $MTString = "8"
			Return "SRAM"
		Case $MTString = "9"
			Return "RAM"
		Case $MTString = "10"
			Return "ROM"
		Case $MTString = "11"
			Return "Flash"
		Case $MTString = "12"
			Return "EEPROM"
		Case $MTString = "13"
			Return "FEPROM"
		Case $MTString = "14"
			Return "EPROM"
		Case $MTString = "15"
			Return "CDRAM"
		Case $MTString = "16"
			Return "3DRAM"
		Case $MTString = "17"
			Return "SDRAM"
		Case $MTString = "18"
			Return "SGRAM"
		Case $MTString = "19"
			Return "RDRAM"
		Case $MTString = "20"
			Return "DDR"
		Case $MTString = "21"
			Return "DDR-2"
		Case Else
			Return "Unknown"
	EndSelect
EndFunc

Func TypeDetail($TDString)
	Select
		Case $TDString = "1"
			Return "Reserved"
		Case $TDString = "2"
			Return "Other"
		Case $TDString = "4"
			Return "Unknown"
		Case $TDString = "8"
			Return "Fast-paged"
		Case $TDString = "16"
			Return "Static column"
		Case $TDString = "32"
			Return "Pseudo-static"
		Case $TDString = "64"
			Return "RAMBUS"
		Case $TDString = "128"
			Return "Synchronous"
		Case $TDString = "256"
			Return "CMOS"
		Case $TDString = "512"
			Return "EDO"
		Case $TDString = "1024"
			Return "Window DRAM"
		Case $TDString = "2048"
			Return "Cache DRAM"
		Case $TDString = "4096"
			Return "Non-volatile"
		Case Else
			Return "Unknown"
	EndSelect
EndFunc

Func CPUDetection($CPUString)
	If StringInStr($CPUString, "Intel") Then
		Select
			Case StringInStr($CPUString, "Atom")
				Return '<img src="./Audit/cpu/intel/atom.png" style="padding-right: 5px;">'
			Case StringInStr($CPUString, "Celeron")
				Return '<img src="./Audit/cpu/intel/celeron.png" style="padding-right: 5px;">'
			Case StringInStr($CPUString, "Xeon")
				Return '<img src="./Audit/cpu/intel/xeon.png" style="padding-right: 5px;">'
			Case StringInStr($CPUString, "Core i7")
				Return '<img src="./Audit/cpu/intel/corei7.png" style="padding-right: 5px;">'
			Case StringInStr($CPUString, "Core i5")
				Return '<img src="./Audit/cpu/intel/corei5.png" style="padding-right: 5px;">'
			Case StringInStr($CPUString, "Core i3")
				Return '<img src="./Audit/cpu/intel/corei3.png" style="padding-right: 5px;">'
			Case StringInStr($CPUString, "Core 2 Quad")
				Return '<img src="./Audit/cpu/intel/core2quad.png" style="padding-right: 5px;">'
			Case StringInStr($CPUString, "Core 2 Extreme")
				Return '<img src="./Audit/cpu/intel/core2extreme.png" style="padding-right: 5px;">'
			Case StringInStr($CPUString, "Core 2 Duo")
				Return '<img src="./Audit/cpu/intel/core2duo.png" style="padding-right: 5px;">'
			Case StringInStr($CPUString, "Pentium D")
				Return '<img src="./Audit/cpu/intel/pentiumD.png" style="padding-right: 5px;">'
			Case StringInStr($CPUString, "Pentium")
				Return '<img src="./Audit/cpu/intel/pentium.png" style="padding-right: 5px;">'
			Case StringInStr($CPUString, "Intel")
				Return '<img src="./Audit/cpu/intel/unknownintel.png" style="padding-right: 5px;">'
		EndSelect
	ElseIf StringInStr($CPUString, "AMD") Then
		Select
			Case StringInStr($CPUString, "Athlon 64 X2")
				Return '<img src="./Audit/cpu/amd/athlonx264.png" style="padding-right: 5px;">'
			Case StringInStr($CPUString, "Athlon 64")
				Return '<img src="./Audit/cpu/amd/athlon64.png" style="padding-right: 5px;">'
			Case StringInStr($CPUString, "Athlon II X2")
				Return '<img src="./Audit/cpu/amd/athlonIIx2.png" style="padding-right: 5px;">'
			Case StringInStr($CPUString, "Athlon XP")
				Return '<img src="./Audit/cpu/amd/athlonxp.png" style="padding-right: 5px;">'
			Case StringInStr($CPUString, "Opteron")
				Return '<img src="./Audit/cpu/amd/opteron64.png" style="padding-right: 5px;">'
			Case StringInStr($CPUString, "Sempron")
				Return '<img src="./Audit/cpu/amd/sempron.png" style="padding-right: 5px;">'
			Case StringInStr($CPUString, "Turlon 64 X2")
				Return '<img src="./Audit/cpu/amd/turlonx264.png" style="padding-right: 5px;">'
			Case StringInStr($CPUString, "Phenom 64 X4")
				Return '<img src="./Audit/cpu/amd/phenomx464.png" style="padding-right: 5px;">'
			Case StringInStr($CPUString, "Phenom 64 X3")
				Return '<img src="./Audit/cpu/amd/phenomx364.png" style="padding-right: 5px;">'
			Case StringInStr($CPUString, "Phenom II X6")
				Return '<img src="./Audit/cpu/amd/phenomIIx6.png" style="padding-right: 5px;">'
			Case StringInStr($CPUString, "Phenom II X4")
				Return '<img src="./Audit/cpu/amd/phenomIIx4.png" style="padding-right: 5px;">'
			Case StringInStr($CPUString, "Phenom II X3")
				Return '<img src="./Audit/cpu/amd/phenomIIx3.png" style="padding-right: 5px;">'
			Case StringInStr($CPUString, "AMD")
				Return '<img src="./Audit/cpu/amd/unknownamd.png" style="padding-right: 5px;">'
		EndSelect
	Else
		MsgBox(64, "CPU", "Unknown CPU")
	EndIf
EndFunc
Exit