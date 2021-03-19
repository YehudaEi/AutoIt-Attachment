#NoTrayIcon
#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=icon.ico
#AutoIt3Wrapper_Res_Comment=Freeware, If you paid for this software you should get your money back!
#AutoIt3Wrapper_Res_Description=Computer Stats
#AutoIt3Wrapper_Res_Fileversion=2.0.1.9
#AutoIt3Wrapper_Res_LegalCopyright=GNU FreeSoftware
#AutoIt3Wrapper_Res_Language=1033
#AutoIt3Wrapper_Res_requestedExecutionLevel=None
#AutoIt3Wrapper_UseX64=N
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#cs ----------------------------------------------------------------------------

	AutoIt Version: 3.3.8.1

	Author :       Rogue5099

	Credits:       JSThePatriot, Melba23, Beege, ApudAngelorum, AZJIO, EXIT
					JFX, bcording

	And thanks to anyone else and the AutoIt Team
	that has helped and I have forgotten.

	Script Function: Gather System Information and display it easily.

#ce ----------------------------------------------------------------------------
#region - Includes -
#include <GuiConstantsEx.au3>
#include <EditConstants.au3>
#include <GuiListView.au3>
#include <Date.au3>
#include <WindowsConstants.au3>
#include <WinAPI.au3>
#include <SendMessage.au3>
#include <IE.au3>
#endregion - Includes -
Global Const $Buisness = "Computer Stats", $Ver = "2.0.1.9"
Global Const $Phone = "555-555-5555"
#region - Globals -
Opt('GUICloseOnESC', 0)
Global Const $MIB_IF_TYPE_OTHER = 1
Global Const $MIB_IF_TYPE_ETHERNET_CSMACD = 6
Global Const $MIB_IF_TYPE_ISO88025_TOKENRING = 9
Global Const $MIB_IF_TYPE_PPP = 23
Global Const $MIB_IF_TYPE_SOFTWARE_LOOPBACK = 24
Global Const $MIB_IF_TYPE_ATM = 37
Global Const $MIB_IF_TYPE_IEEE80211 = 71
Global Const $MIB_IF_TYPE_TUNNEL = 131
Global Const $MIB_IF_TYPE_IEEE1394 = 144
Global Const $wbemFlagReturnImmediately = 0x10
Global Const $wbemFlagForwardOnly = 0x20
Global Const $tagMIB_IFROW = 'wchar Name[256];dword Index;dword Type;dword Mtu;dword Speed;dword PhysAddrLen;byte PhysAddr[8];dword AdminStatus;dword OperStatus;' & _
		'dword LastChange;dword InOctets;dword InUcastPkts;dword InNUcastPkts;dword InDiscards;dword InErrors;dword InUnknownProtos;dword OutOctets;dword OutUcastPkts;' & _
		'dword OutNUcastPkts;dword OutDiscards;dword OutErrors;dword OutQLen;dword DescrLen;char Descr[256]'
Global $iMarquee_Loop = 0
Global $sMarquee_Move = "scroll"
Global $sMarquee_Direction = "left"
Global $iMarquee_Scroll = 6
Global $iMarquee_Delay = 85
Global $iMarquee_Border = 0
Global $vMarquee_TxtCol = Default
Global $sMarquee_BkCol = Default
Global $sMarquee_FontFamily = "Tahoma"
Global $iMarquee_FontSize = 12
Global $Date, $Time, $AvgCPU, $Collected, $CPUTotal, $RAMCollected, $RAMTotal
Global $oDict, $ProcessList2, $l = 0
Global $colItems, $strReserved, $strVendorSpecific, $strVendorSpecific4, $Output
Global $DriveInfo, $DriveInfoLoad, $DriveLabel, $DriveInfoType, $DriveFileSystem, $DriveSize, $DriveSerial, $DriveTemp, $DriveProgress, $DriveLetter, $DriveStatus, $Memory
Global $ip = "localhost"
Global $RAMUsage = MemGetStats()
Global $RefreshTimerA = TimerInit()
Global $RefreshTimerB = TimerInit()
Global $aDrive = DriveGetDrive("ALL")
Global $MSDNLink = "http://msdn.microsoft.com/en-us/library/windows/desktop/aa394084(v=vs.85).aspx"
Global $BIOS, $aSystemInfo, $DriveTypeLabel[100], $DriveFreePos[100], $DriveFree[100], $DriveType[100]
Global $hUpdate, $aStart_Values
Global $sBmpFilePath = @TempDir & '\bg.bmp'
#endregion - Globals -
#region - Loading GUI with Infomation
If @OSVersion = @OSVersion = "WIN_8" Or @OSVersion = "WIN_7" Or "WIN_VISTA" Or  @OSVersion = "WIN_XP"Then
	FileDelete(@TempDir & "\cpu.csv")
	Run('typeperf "\Processor(_Total)\% Processor Time" -y -si 00:00:00 -o ' & @TempDir & '\cpu.csv', "", @SW_HIDE)
EndIf
If @OSServicePack = "" Then $OSServicePack = "Original Version"
If Not @OSServicePack = "" Then $OSServicePack = @OSServicePack
Switch @OSVersion
	Case "WIN_8"
		$OSVersion = "Windows 8"
	Case "WIN_7"
		$OSVersion = "Windows 7"
	Case "WIN_VISTA"
		$OSVersion = "Windows Vista"
	Case "WIN_2008R2"
		$OSVersion = "Windows 2008 R2"
	Case "WIN_2008"
		$OSVersion = "Windows 2008"
	Case "WIN_XP"
		$OSVersion = "Windows XP"
	Case "WIN_2003"
		$OSVersion = "Windows 2003"
	Case "WIN_2000"
		$OSVersion = "Windows 2000"
	Case Else
		$OSVersion = "Unknown"
EndSwitch
$Language = _GLI()
$CPUInfo = _CPURegistryInfo()
$IPDetail = _IPDetails()
_ComputerGetSystem($aSystemInfo)
_ComputerGetBIOS($BIOS)
DateTime()
DriveInfo()
_ComputerGetMemory($Memory)
Switch $Memory[1][12]
	Case 11
		$MemoryType = "Flash"
	Case 16
		$MemoryType = "3DRAM"
	Case 17
		$MemoryType = "SDRAM"
	Case 20
		$MemoryType = "DDR"
	Case 21
		$MemoryType = "DDR2"
	Case Else
		$MemoryType = "DDR3"
EndSwitch
$MainGUI = GUICreate($Buisness & " Utility - Version " & $Ver, 400, 455, -1, -1, 0x00CA0080, $WS_EX_ACCEPTFILES)
GUISetFont(8, 400, 0, "Lucida Console")
$ToolsMenu = GUICtrlCreateMenu("Tools")
$PixalFinder = GUICtrlCreateMenuItem("Pixel Finder", $ToolsMenu)
$RecycleItem = GUICtrlCreateMenuItem("Clean Temp Files", $ToolsMenu)
$DriveInfoItem = GUICtrlCreateMenuItem("Details on Drive...", $ToolsMenu)
$RemoteRepair = GUICtrlCreateMenuItem("Remote Repair (Team Viewer)", $ToolsMenu)
GUICtrlCreateMenuItem("", $ToolsMenu)
$RefreshNet = GUICtrlCreateMenuItem("Refresh Connection", $ToolsMenu)
$ClearIEHistory = GUICtrlCreateMenuItem("Delete IE History", $ToolsMenu)
$ResetIE = GUICtrlCreateMenuItem("Reset IE to Default Settings", $ToolsMenu)
GUICtrlCreateMenuItem("", $ToolsMenu)
$Filters = GUICtrlCreateMenuItem("CD Drive Read/Write FIX", $ToolsMenu)
$SFC = GUICtrlCreateMenuItem("System File FIX", $ToolsMenu)
$USBHijack = GUICtrlCreateMenuItem("Remove USB Hijack Risks", $ToolsMenu)
$HardwareMenu = GUICtrlCreateMenu("Information")
$AboutCPU = GUICtrlCreateMenuItem("Processor", $HardwareMenu)
$AboutRAM = GUICtrlCreateMenuItem("RAM (Memory)", $HardwareMenu)
$AboutHDD = GUICtrlCreateMenuItem("Hard Drive", $HardwareMenu)
$AboutMotherboard = GUICtrlCreateMenuItem("Motherboard", $HardwareMenu)
$AboutGraphics = GUICtrlCreateMenuItem("Graphics Card", $HardwareMenu)
$AboutSoundCard = GUICtrlCreateMenuItem("Sound Card", $HardwareMenu)
$AboutNetwork = GUICtrlCreateMenuItem("Network", $HardwareMenu)
GUICtrlCreateMenuItem("", $HardwareMenu)
$AboutOS = GUICtrlCreateMenuItem("Operating System", $HardwareMenu)
$AboutBios = GUICtrlCreateMenuItem("BIOS", $HardwareMenu)
$AboutSystem = GUICtrlCreateMenuItem("System", $HardwareMenu)
GUICtrlCreateMenuItem("", $HardwareMenu)
$AboutBattery = GUICtrlCreateMenuItem("Battery", $HardwareMenu)
$AboutMonitor = GUICtrlCreateMenuItem("Monitor", $HardwareMenu)
$AboutKeyboard = GUICtrlCreateMenuItem("Keyboard", $HardwareMenu)
$AboutMouse = GUICtrlCreateMenuItem("Mouse", $HardwareMenu)
$AccessMenu = GUICtrlCreateMenu("System")
$TaskMGR = GUICtrlCreateMenuItem("Task Manager", $AccessMenu)
$DeviceManager = GUICtrlCreateMenuItem("Device Manager", $AccessMenu)
$Services = GUICtrlCreateMenuItem("Services", $AccessMenu)
GUICtrlCreateMenuItem("", $AccessMenu)
$SystemProperties = GUICtrlCreateMenuItem("System Properties", $AccessMenu)
$FolderProperties = GUICtrlCreateMenuItem("Folder Properties", $AccessMenu)
GUICtrlCreateMenuItem("", $AccessMenu)
$InternetOptions = GUICtrlCreateMenuItem("IE Internet Options", $AccessMenu)
GUICtrlCreateMenuItem("", $AccessMenu)
$Registry = GUICtrlCreateMenuItem("Open Registry", $AccessMenu)
GUICtrlCreateMenuItem("", $AccessMenu)
$FindProductKeys = GUICtrlCreateMenuItem("Product Keys", $AccessMenu)
$GetMenu = GUICtrlCreateMenu("Downloads")
$Adobe = GUICtrlCreateMenuItem("Adobe Flash/Reader", $GetMenu)
$Java = GUICtrlCreateMenuItem("Java", $GetMenu)
GUICtrlCreateMenuItem("", $GetMenu)
$CCleaner = GUICtrlCreateMenuItem("Piriform Tools", $GetMenu)
$HelpMenu = GUICtrlCreateMenu("About")
$CreditsItem = GUICtrlCreateMenuItem("Credits", $HelpMenu)
$Website = GUICtrlCreateMenuItem("Website", $HelpMenu)
GUICtrlCreateLabel($Buisness & " Info Tool", 0, 420, 350, 15, 0x1000)
$TimeLabel = GUICtrlCreateLabel($Date & "  " & $Time, 250, 420, 150, 15, 0x1001)
GUICtrlCreateTab(0, 0, 400, 419, 0x0148)
$MainTab = GUICtrlCreateTabItem("Main")
GUICtrlCreateLabel("User Name:", 10, 25, 250, 25)
GUICtrlCreateInput(@UserName, 175, 25, 215, 20, 0x0801)
GUICtrlCreateLabel("Computer Name:", 10, 50, -1, -1)
GUICtrlCreateInput(@ComputerName, 175, 50, 215, 20, 0x0801)
GUICtrlCreateLabel("OS Language:", 10, 75, -1, -1)
GUICtrlCreateInput($Language, 175, 75, 215, 20, 0x0801)
GUICtrlCreateLabel("Current OS:", 10, 100, -1, -1)
GUICtrlCreateInput($OSVersion & " " & @OSArch, 175, 100, 215, 20, 0x0801)
GUICtrlCreateLabel("Service Pack:", 10, 125, -1, -1)
GUICtrlCreateInput($OSServicePack, 175, 125, 215, 20, 0x0801)
GUICtrlCreateLabel("Manufacturer:", 10, 150, -1, -1)
GUICtrlCreateInput(StringStripWS($aSystemInfo[1][21], 3), 175, 150, 215, 20, 0x0801)
GUICtrlCreateLabel("Model:", 10, 175, -1, -1)
GUICtrlCreateInput(StringStripWS($aSystemInfo[1][22], 3), 175, 175, 215, 20, 0x0801)
GUICtrlCreateLabel("Serial Number:", 10, 200, -1, -1)
GUICtrlCreateInput(StringStripWS($BIOS[1][16], 3), 175, 200, 215, 20, 0x0801)
GUICtrlCreateLabel("Memory Type:", 10, 225, -1, -1)
GUICtrlCreateInput($MemoryType, 175, 225, 215, 20, 0x0801)
GUICtrlCreateLabel("Total Physical Memory:", 10, 250, -1, -1)
GUICtrlCreateInput(Round($aSystemInfo[1][48] / 1073741824, 2) & " GB", 175, 250, 215, 20, 0x0801)
GUICtrlCreateLabel("CPU Speed:", 10, 275, -1, -1)
GUICtrlCreateInput(StringFormat('%.2f', ($CPUInfo[1] / 1000)) & " GHz", 175, 275, 215, 20, 0x0801)
GUICtrlCreateLabel("Display WxH @ Refresh:", 10, 300, -1, -1)
$DisplaysLabel = GUICtrlCreateInput(@DesktopWidth & " x " & @DesktopHeight & " @ " & @DesktopRefresh & " Hz", 175, 300, 215, 20, 0x0801)
GUICtrlCreateLabel("Display Depth:", 10, 325, -1, -1)
$DisplayDLabel = GUICtrlCreateInput(@DesktopDepth & " Bits", 175, 325, 215, 20, 0x0801)
GUICtrlCreateLabel("OS Install Path:", 10, 350, -1, -1)
$DisplayDLabel = GUICtrlCreateInput(@WindowsDir & "\", 175, 350, 215, 20, 0x0801)
GUICtrlCreateTab(-1, -1, 400, 419)
GUICtrlCreateTabItem("Drives")
For $i = 1 To $aDrive[0]
	If Not $DriveType[$i] = "" Then
		GUICtrlCreateLabel(StringUpper($aDrive[$i]) & "\", 10, 25 + ($l * 15))
		$DriveTypeLabel[$i] = GUICtrlCreateLabel($DriveType[$i], 75, 25 + ($l * 15), 75, 15, 0x1201)
		$DriveFreePos[$i] = GUICtrlCreateProgress(180, 25 + ($l * 15), 180, 15, 0x01)
		If Not $DriveType[$i] = "" Then GUICtrlSetData($DriveFreePos[$i], $DriveFree[$i])
		If ($DriveType[$i] = "Fixed" Or $DriveType[$i] = "Removable") And ($DriveFree[$i] > 0) Then GUICtrlCreateLabel($DriveFree[$i] & "%", 155, 30 + ($l * 15))
		$l += 1
	EndIf
Next
GUICtrlCreateTab(-1, -1, 400, 419)
GUICtrlCreateTabItem("CPU and RAM")
GUICtrlCreateLabel("CPU Usage:", 10, 25, 265, 15)
$CPU = GUICtrlCreateProgress(120, 25, 245, -1, 0x01)
GUICtrlCreateLabel("Avg. CPU Usage:", 10, 50, 265, 15)
$AvgCPUBar = GUICtrlCreateProgress(120, 50, 245, -1, 0x01)
GUICtrlCreateLabel("RAM Usage:", 10, 75, 270, 15)
$RAM = GUICtrlCreateProgress(120, 75, 245, -1, 0x01)
GUICtrlCreateLabel("Avg. RAM Usage:", 10, 100, 270, 15)
$AvgRAMBar = GUICtrlCreateProgress(120, 100, 245, -1, 0x01)
GUICtrlCreateLabel("CPU Arch:", 10, 200, 270, 15)
GUICtrlCreateInput(@CPUArch, 105, 200, 290, 20, 0x0801)
GUICtrlCreateLabel("Total RAM:", 10, 125, 270, 15)
GUICtrlCreateInput(Round($RAMUsage[1] / 1048576, 2) & " GB", 105, 125, 290, 20, 0x0801)
GUICtrlCreateLabel("Memory Type:", 10, 150, 270, 15)
GUICtrlCreateInput($MemoryType, 105, 150, 290, 20, 0x0801)
GUICtrlCreateLabel("Total Virtual:", 10, 175, 270, 15)
GUICtrlCreateInput(Round($RAMUsage[3] / 1048576, 2) & " GB", 105, 175, 290, 20, 0x0801)
$CPULabel = GUICtrlCreateLabel("", 370, 30, 30, 15)
$RAMLabel = GUICtrlCreateLabel("", 370, 80, 30, 15)
GUICtrlCreateLabel("CPU Name:", 10, 225, -1, -1)
GUICtrlCreateInput(StringStripWS($CPUInfo[2], 7), 105, 225, 290, 20, 0x0801)
GUICtrlCreateLabel("Vendor:", 10, 250, -1, -1)
GUICtrlCreateInput($CPUInfo[4], 105, 250, 290, 20, 0x0801)
GUICtrlCreateLabel("Cores:", 10, 275, -1, -1)
GUICtrlCreateInput($CPUInfo[0], 105, 275, 290, 20, 0x0801)
GUICtrlCreateLabel("Speed:", 10, 300, -1, -1)
GUICtrlCreateInput(StringFormat('%.2f', ($CPUInfo[1] / 1000)) & " GHz", 105, 300, 290, 20, 0x0801)
GUICtrlCreateLabel("Identifier:", 10, 325, -1, -1)
GUICtrlCreateInput($CPUInfo[3], 105, 325, 290, 20, 0x0801)
GUICtrlCreateTab(-1, -1, 400, 419)
GUICtrlCreateTabItem("Network")
If $CmdLine[0] > 0 Then $ip = $CmdLine[1]
$objWMIService = ObjGet("winmgmts:{impersonationLevel = impersonate}!\\" & $ip & "\root\cimv2")
GUICtrlCreateLabel("Public IP:", 10, 25, -1, -1)
GUICtrlCreateLabel("Local IP 1:", 10, 50, -1, -1)
GUICtrlCreateLabel("Local IP 2:", 10, 75, -1, -1)
GUICtrlCreateLabel("Local IP 3:", 10, 100, -1, -1)
GUICtrlCreateLabel("Local IP 4:", 10, 125, -1, -1)
GUICtrlCreateLabel("MAC Address:", 10, 150, -1, -1)
GUICtrlCreateLabel("Default Gateway:", 10, 175, -1, -1)
GUICtrlCreateLabel("DNS Domain:", 10, 200, -1, -1)
GUICtrlCreateLabel("Domain:", 10, 225, -1, -1)
GUICtrlCreateLabel("Server:", 10, 250, -1, -1)
GUICtrlCreateLabel("Network Adapter:", 10, 275, -1, -1)
GUICtrlCreateLabel("Network Activity:", 10, 300, -1, -1)
GUICtrlCreateLabel("Network Speed:", 10, 325, -1, -1)
$PublicIP = _GetPublicIP()
If $PublicIP = -1 Then $PublicIP = "Not Connected Online"
GUICtrlCreateInput($PublicIP, 145, 25, 250, 20, 0x0801)
$IP1 = GUICtrlCreateInput(@IPAddress1, 145, 50, 250, 20, 0x0801)
$IP2 = GUICtrlCreateInput(@IPAddress2, 145, 75, 250, 20, 0x0801)
$IP3 = GUICtrlCreateInput(@IPAddress3, 145, 100, 250, 20, 0x0801)
$IP4 = GUICtrlCreateInput(@IPAddress4, 145, 125, 250, 20, 0x0801)
GUICtrlCreateInput($IPDetail[1], 145, 150, 250, 20, 0x0801)
GUICtrlCreateInput($IPDetail[2], 145, 175, 250, 20, 0x0801)
$DNSDomain = GUICtrlCreateInput(@LogonDNSDomain, 145, 200, 250, 20, 0x0801)
$Domain = GUICtrlCreateInput(@LogonDomain, 145, 225, 250, 20, 0x0801)
$Server = GUICtrlCreateInput(@LogonServer, 145, 250, 250, 20, 0x0801)
$Adaptor = GUICtrlCreateInput(GetWMI($ip), 145, 275, 250, 20, 0x0801)
$NetSpeed = GUICtrlCreateInput("DL: 0 kB/sec  UL: 0 kB/sec", 145, 300, 250, 20, 0x0801)
$NetTest = GUICtrlCreateInput("DL: 0 Mbps  UL: 0 Mbps", 145, 325, 200, 20, 0x0801)
$TestNetSpeed = GUICtrlCreateButton("Test", 345, 325, 50, 20)
GUICtrlCreateTab(-1, -1, 400, 419)
GUICtrlCreateTabItem("Etc")
GUICtrlCreateLabel("Run:", 10, 25)
$RUN = GUICtrlCreateInput("", 90, 25, 200, 20, 0x1080)
GUICtrlSetState(-1, $GUI_DROPACCEPTED)
$Browse = GUICtrlCreateButton("...", 295, 25, 50, 20)
$Submit = GUICtrlCreateButton("Run", 345, 25, 50, 20)
GUICtrlCreateLabel("Edit:", 10, 50)
$Edit = GUICtrlCreateInput("", 90, 50, 200, 20, 0x1080)
GUICtrlSetState(-1, $GUI_DROPACCEPTED)
$EditBrowse = GUICtrlCreateButton("...", 295, 50, 50, 20)
$EditSubmit = GUICtrlCreateButton("Edit", 345, 50, 50, 20)
GUICtrlCreateLabel("Kill PID:", 10, 75)
$KillPID = GUICtrlCreateInput("", 90, 75, 250, 20, 0x3000)
GUICtrlSetLimit($KillPID, 4)
$ExecKillPID = GUICtrlCreateButton("Kill", 345, 75, 50, 20)
GUICtrlCreateLabel("Kill Task:", 10, 100)
$Kill = GUICtrlCreateInput("", 90, 100, 250, 20, 0x1080)
$ExecKill = GUICtrlCreateButton("Kill", 345, 100, 50, 20)
GUICtrlCreateLabel("Delete File:", 10, 125)
$Delete = GUICtrlCreateInput("", 90, 125, 200, 20, 0x1080)
GUICtrlSetState(-1, $GUI_DROPACCEPTED)
$DeleteBrowse = GUICtrlCreateButton("...", 295, 125, 50, 20)
$DeleteSubmit = GUICtrlCreateButton("Delete", 345, 125, 50, 20)
$ProcessList = GUICtrlCreateButton("List Processes", 155, 385, 100, 20)
GUICtrlSetState($MainTab, $GUI_FOCUS)
GUICtrlSetState($MainTab, $GUI_DEFBUTTON)
GUICtrlSetState($MainTab, $GUI_ENABLE)
GUICtrlSetState($MainTab, $GUI_SHOW)
$RAMUsage = MemGetStats()
$RAMCollected = $RAMCollected + 1
$RAMTotal = Round($RAMUsage[0] + $RAMTotal)
$AvgRAM = Round($RAMTotal / $RAMCollected)
GUICtrlSetData($AvgRAMBar, $AvgRAM)
GUICtrlSetData($RAM, Round($RAMUsage[0], 0))
GUICtrlSetData($RAMLabel, Round($RAMUsage[0], 0) & "%")
$CPUUsage = Round(StringTrimRight(StringTrimLeft(FileReadLine(@TempDir & "\cpu.csv", -1), 27), 1), 0)
$Collected = $Collected + 1
$CPUTotal = Round($CPUUsage + $CPUTotal)
$AvgCPU = Round($CPUTotal / $Collected)
GUICtrlSetData($CPU, $CPUUsage)
GUICtrlSetData($CPULabel, $CPUUsage & "%")
GUICtrlSetData($AvgCPUBar, $AvgCPU)
GUICtrlCreateTab(-1, -1, 400, 419)
Global $IPHlpApi_Dll = DllOpen('IPHlpApi.dll')
Global $sLast_Label
Global $Global_IF_Count = _GetNumberofInterfaces()
Global $Table_Data = _WinAPI_GetIfTable()
If IsArray($Table_Data) Then
	$hUpdate = DllCallbackRegister('_UpdateStats', 'none', '')
	DllCall('user32.dll', 'int', 'SetTimer', 'hwnd', 0, 'int', 0, 'int', 1000, 'ptr', DllCallbackGetPtr($hUpdate))
	$aStart_Values = _GetAllTraffic()
Else
	GUICtrlSetData($NetSpeed, "Error reading Adapters")
EndIf
GUISetState(@SW_SHOW)
#endregion - Loading GUI with Infomation

#region - Main Loop -
While 1
	$iMsg = GUIGetMsg()
	Switch $iMsg
		Case $GUI_EVENT_CLOSE
			$TypePerfPID = ProcessExists("typeperf.exe")
			ProcessClose($TypePerfPID)
			Sleep(500)
			FileDelete(@TempDir & "\cpu.csv")
			Exit
		Case $PixalFinder
			PixelColor()
		Case $CreditsItem
			GUISetState(@SW_HIDE, $MainGUI)
			_Bgbmp ( "bg.bmp", @TempDir & "\", 1 )
			$Credits = '<b><center>About:<br>' & $Buisness & ' Utility<br><br>Creator: rogue5099<br>' & _
					'<br>Phone: ' & $Phone & '<br><br>' & _
					'<a href="http://www.google.com/"  target="_blank">Google</a><br><br>' & _
					'<a href="http://www.autoitscript.com/forum/topic/29404-computer-info-udfs/page__view__findpost__p__209498"  target="_blank">CompInfo UDF: JSThePatriot</a><br>' & _
					'<a href="http://www.autoitscript.com/forum/topic/103904-info-bar-like-tickertape/page__p__735769#entry735769"  target="_blank">Marquee UDF: Melba23</a><br>' & _
					'<a href="http://www.autoitscript.com/forum/topic/105319-uploaddownload-meter/page__view__findpost__p__744592"  target="_blank">Network Meter: Beege</a><br>' & _
					'<a href="http://www.autoitscript.com/forum/topic/148126-get-month-and-day-names-in-national-language-get-lcid-informations/?p=1052001" target="_blank">Language UDF: EXIT</a><br>' & _
					'<a href="http://www.autoitscript.com/forum/topic/154510-computer-stats/?p=1116005" target="_blank">Language Function: AZJIO</a><br>' & _
					'<a href="http://www.autoitscript.com/forum/topic/131797-windows-and-office-key/?p=917840" target="_blank">Product Keys: JFX/bcording</a><br>' & _
					'TakeOwn UDF: ApudAngelorum<br>' & _
					'<a href="http://www.autoitscript.com/"  target="_blank">Other UDFs: AutoIt Team</a></center>'
			$Credit = GUICreate("Credits", 280, 280, -1, -1, BitOR($WS_BORDER, $WS_POPUP))
			GUISetBkColor(0xFFFFFF, $Credit)
			_GUICtrlMarquee_SetScroll(0, Default, "up", 3)
			_GUICtrlMarquee_SetDisplay(0, Default, Default, 14, "times new roman")
			_GUICtrlMarquee_Create($Credits, 0, 16, 280, 264)
			$Close = GUICtrlCreateButton("X", 260, 0, 16, 16)
			GUISetState()

			While 1
				If GUIGetMsg() = $Close Then
					GUIDelete($Credit)
					GUISetState(@SW_SHOW, $MainGUI)
					ExitLoop
				EndIf
			WEnd
			FileDelete(@TempDir & "\bg.bmp")
		Case $Website
			ShellExecute("http://www.autoitscript.com")
		Case $RemoteRepair
			$FileSize = InetGetSize("http://www.teamviewer.com/download/TeamViewerQS_en.exe")
			If $FileSize > 0 Then
				ProgressOn($Buisness, "Downloading: Remote Repair", "0%")
				$hInet = InetGet("http://www.teamviewer.com/download/TeamViewerQS_en.exe", @TempDir & "\TeamViewerQS_en.exe", 1, 1)

				While Not InetGetInfo($hInet, 2)
					Sleep(500)
					$BytesReceived = InetGetInfo($hInet, 0)
					$Pct = Int($BytesReceived / $FileSize * 100)
					ProgressSet($Pct, $Pct & "%")
				WEnd
				ProgressOff()
				Run(@TempDir & "\TeamViewerQS_en.exe")
				MsgBox(0, "Loading", "Loading Program...", 5)
				If WinWaitActive("TeamViewer", "", 20) = 0 Then
					MsgBox(16, "Error", "Failed to load program.  Try re-downloading!")
				Else
					MsgBox(64, $Buisness, 'You must give the "Your ID" and "Password" from this window to a Technician so you can be connected to.' & @CRLF & @CRLF & 'Contact Info: ' & $Phone)
				EndIf
			Else
				MsgBox(16, "Error", "Failed to download!")
			EndIf
		Case $DriveInfoItem
			DriveInfoGUI()
		Case $USBHijack
			For $i = 65 To 90
				$Exists = FileExists(Chr($i) & ":\autorun.inf")
				If $Exists = 1 Then FileSetAttrib(Chr($i) & ":\*Autorun.inf*", "-RASH")
				If $Exists = 1 Then $Del = MsgBox(0x40024, "!", "Delete Virus" & @CRLF & @CRLF & "AR.INF.RISK on " & Chr($i) & ":\ ?")
				If $Exists = 1 And $Del = 6 Then FileDelete(Chr($i) & ":\*Autorun.inf*")
			Next
		Case $RefreshNet
			ShellExecuteWait("ipconfig", "/release")
			ShellExecuteWait("ipconfig", "/flushdns")
			ShellExecute("ipconfig", "/renew")
		Case $SFC
			Send("#r")
			WinWaitActive("Run")
			Send("sfc /scannow{Enter}")
		Case $RecycleItem
			Recycle()
		Case $AboutCPU To $AboutMouse
			HardwareGUI(GUICtrlRead($iMsg, 1))
		Case $SystemProperties
			ShellExecute("sysdm.cpl")
		Case $InternetOptions
			ShellExecute("inetcpl.cpl")
		Case $Registry
			ShellExecute("regedit.exe")
		Case $TaskMGR
			ShellExecute("taskmgr.exe")
		Case $DeviceManager
			ShellExecute("devmgmt.msc")
		Case $Services
			ShellExecute("services.msc")
		Case $FolderProperties
			Send("#r")
			WinWaitActive("Run")
			Send("control folders{Enter}")
		Case $FindProductKeys
			MsgBox(0, "Product Keys", "- - - - - - - - - - - - -  W   I   N   D   O   W   S  - - - - - - - - - - - - -" & @CRLF & _
					"Windows Key : " & @TAB & _DecodeProductKey("Windows") & @CRLF & _
					"Windows Key 4 : " & @TAB & _DecodeProductKey("Windows_DPid4") & @CRLF & _
					"Windows Default : " & @TAB & _DecodeProductKey("Windows_Def") & @CRLF & _
					"Windows Default 4 : " & @TAB & _DecodeProductKey("Windows_Def_DPid4") & @CRLF & @CRLF & _
					"- - - - - - - - - - - - - - -  O   F   F   I   C   E  - - - - - - - - - - - - - - -" & @CRLF & _
			"Office XP Key : " & @TAB & _DecodeProductKey("Office XP") & @CRLF & _
					"Office 2003 Key : " & @TAB & _DecodeProductKey("Office 2003") & @CRLF & _
					"Office 2007 Key : " & @TAB & _DecodeProductKey("Office 2007") & @CRLF & _
					"Office 2010 x86 Key: " & @TAB & _DecodeProductKey("Office 2010 x86") & @CRLF & _
					"Office 2010 x64 Key: " & @TAB & _DecodeProductKey("Office 2010 x64") & @CRLF & _
					"Office 2013 x86 Key: " & @TAB & _DecodeProductKey("Office 2013 x86") & @CRLF & _
					"Office 2013 x64 Key: " & @TAB & _DecodeProductKey("Office 2013 x64"))
		Case $Filters
			If MsgBox(4, "Upper/Lower Filter Fix", "This will remove Registry Entries!" & @CRLF & @CRLF & "Continue?") = 6 Then
				If RegDelete("HKLM\SYSTEM\CurrentControlSet\Control\Class\{4D36E965-E325-11CE-BFC1-08002BE10318}", "UpperFilters") = 2 Then MsgBox(48, "Error", "Error Deleting Upper Filter!")
				If RegDelete("HKLM\SYSTEM\CurrentControlSet\Control\Class\{4D36E965-E325-11CE-BFC1-08002BE10318}", "LowerFilters") = 2 Then MsgBox(48, "Error", "Error Deleting Lower Filter!")
				If MsgBox(4, "Upper/Lower Filter Fix", "Computer must be restarted to finish fix." & @CRLF & "Make sure to save any documents!" & @CRLF & @CRLF & "Restart now?") = 6 Then Shutdown(6)
			EndIf
		Case $Adobe
			ShellExecute("http://www.adobe.com/downloads/")
		Case $Java
			ShellExecute("http://www.java.com/en/download/index.jsp")
		Case $CCleaner
			ShellExecute("                                ")
		Case $TestNetSpeed
			$oIE = _IECreate("                           ", 0, 0, 1)
			$oBegin = _IEGetObjById($oIE, "scanstart")
			_IEAction($oBegin, "click")
			$CountDown = 30
			Do
				SplashTextOn("Splash", "Testing Please wait..." & @CRLF & $CountDown, 400, 115, -1, -1, 35, -1, 14, 600)
				$CountDown -= 1
				$oDown = _IEGetObjById($oIE, "scandmbit")
				$sDown = _IEPropertyGet($oDown, "innerText")
				$oUp = _IEGetObjById($oIE, "scanumbit")
				$sUp = _IEPropertyGet($oUp, "innerText")
				GUICtrlSetData($NetTest, "DL: " & $sDown & " Mbps  UL: " & $sUp & " Mbps")
				Sleep(1000)
				SplashOff()
			Until $CountDown = 0
			$oDown = _IEGetObjById($oIE, "scandmbit")
			$sDown = _IEPropertyGet($oDown, "innerText")
			$oUp = _IEGetObjById($oIE, "scanumbit")
			$sUp = _IEPropertyGet($oUp, "innerText")
			GUICtrlSetData($NetTest, "DL: " & $sDown & " Mbps  UL: " & $sUp & " Mbps")
			_IEQuit($oIE)
		Case $ExecKill
			ProcessClose(GUICtrlRead($Kill))
			GUICtrlSetData($Kill, "Atempting to Kill " & GUICtrlRead($Kill) & "...")
			Sleep(250)
			GUICtrlSetData($Kill, "")
		Case $ExecKillPID
			ProcessClose(GUICtrlRead($KillPID))
			GUICtrlSetData($KillPID, "Atempting to Kill " & GUICtrlRead($KillPID) & "...")
			Sleep(250)
			GUICtrlSetData($KillPID, "")
		Case $ProcessList
			$PList = ProcessList()
			_ArrayDisplay($PList, "Running Processes", -1, 0, "", "|", "#|Process|ID")
		Case $Submit
			ShellExecute(_WinAPI_ExpandEnvironmentStrings(GUICtrlRead($RUN)), "", "", "open")
			GUICtrlSetData($RUN, "Starting " & GUICtrlRead($RUN) & "...")
			Sleep(250)
			GUICtrlSetData($RUN, "")
		Case $EditSubmit
			ShellExecute(_WinAPI_ExpandEnvironmentStrings(GUICtrlRead($Edit)), "", "", "edit")
			GUICtrlSetData($Edit, "")
		Case $Browse
			$BrowseFile = FileOpenDialog("Choose Program to Run", @ScriptDir, "Program (*.exe;*.bat;*.com;*.pif)", 1)
			If Not @error Then Run($BrowseFile)
		Case $EditBrowse
			$EditFile = FileOpenDialog("Choose File to Edit", @ScriptDir, "All Files (*.*)|Autoit Script (*.au3)|Batch File (*.bat)|Settings File (*.ini;*inf;*reg)|Text File (*.txt;*rtf;*.log)|Web Page (*.html;*.htm;*.php)|Word File (*.doc)", 1)
			If Not @error Then ShellExecute($EditFile, "", "", "edit")
		Case $DeleteBrowse
			$DeleteFile = FileOpenDialog("Choose File to Edit", @ScriptDir, "All Files (*.*)|Autoit Script (*.au3)|Batch File (*.bat)|Settings File (*.ini;*inf;*reg)|Text File (*.txt;*rtf;*.log)|Web Page (*.html;*.htm;*.php)|Word File (*.doc)", 1)
			If Not @error Then GUICtrlSetData($Delete, $DeleteFile)
		Case $DeleteSubmit
			$File = GUICtrlRead($Delete)
			If FileExists($File) Then
				If StringRight($File, 4) = ".exe" Then
					$nCount = StringInStr($File, "\", 0, -1)
					$sFile = StringTrimLeft($File, $nCount)
					Do
						ProcessClose($sFile)
					Until Not ProcessExists($sFile)
				EndIf
				If Not AdjustPrivilege(8) Then MsgBox(0, "", "Error!")
				If Not AdjustPrivilege(9) Then MsgBox(0, "", "Error!")
				If Not AdjustPrivilege(20) Then MsgBox(0, "", "Error!")
				$hADVAPI32 = DllOpen("advapi32.dll")
				$hKERNEL32 = DllOpen("kernel32.dll")
				TakeOwn($File, 1)
				FileDelete($File)
				DllClose($hADVAPI32)
				DllClose($hKERNEL32)
				If FileExists($File) Then MsgBox(48, "Error", "Could not delete file!")
			Else
				MsgBox(48, "Error", "Could not find file/folder!")
			EndIf
			GUICtrlSetData($Delete, "")
		Case $ResetIE
			Run("rundll32.exe inetcpl.cpl ResetIEtoDefaults")
			WinWait("Reset Internet Explorer Settings")
			ControlClick("Reset Internet Explorer Settings", "", 1, "left", 1, 51, 12)
			WinWait("Reset Internet Explorer Settings", "&Close")
			Sleep(1000)
			While WinExists("Reset Internet Explorer Settings", "&Close")
				ControlClick("Reset Internet Explorer Settings", "", 6608, "left", 1, 36, 11)
			WEnd
			ShellExecute("iexplore.exe")

		Case $ClearIEHistory
			RunWait("RunDll32.exe inetcpl.cpl,ClearMyTracksByProcess 3")
	EndSwitch
	If TimerDiff($RefreshTimerA) >= 1000 Then
		$RefreshTimerA = TimerInit()
		DateTime()
		$RAMUsage = MemGetStats()
		$RAMCollected = $RAMCollected + 1
		$RAMTotal = Round($RAMUsage[0] + $RAMTotal)
		$AvgRAM = Round($RAMTotal / $RAMCollected)
		GUICtrlSetData($AvgRAMBar, $AvgRAM)
		GUICtrlSetData($RAM, Round($RAMUsage[0], 0))
		GUICtrlSetData($RAMLabel, Round($RAMUsage[0], 0) & "%")
		If ProcessExists("typeperf.exe") Then
			$CPUUsage = Round(StringTrimRight(StringTrimLeft(FileReadLine(@TempDir & "\cpu.csv", -1), 27), 1), 0)
			$Collected = $Collected + 1
			$CPUTotal = Round($CPUUsage + $CPUTotal)
			$AvgCPU = Round($CPUTotal / $Collected)
			GUICtrlSetData($CPU, $CPUUsage)
			GUICtrlSetData($AvgCPUBar, $AvgCPU)
			GUICtrlSetData($CPULabel, $CPUUsage & "%")
		EndIf
		GUICtrlSetData($TimeLabel, $Date & "  " & $Time)
	EndIf
WEnd
#endregion - Main Loop -
#region - Language -
Func _GLI()
	Local $LCID = 0
	$sText = __GLI_Get($LCID, 92)
	If $sText = "" Then $sText = __GLI_Get($LCID, 89) & "-" & __GLI_Get($LCID, 90)
	$sText &= '  |  ' & __GLI_Get($LCID, 2)
	Return $sText
EndFunc   ;==>_GLI by AZJIO

Func __GLI_Get($iLCID_Dec, $iIndex)
    Local $aTemp = DllCall('kernel32.dll', 'int', 'GetLocaleInfoW', 'ulong', $iLCID_Dec, 'dword', $iIndex, 'wstr', '', 'int', 2048)
    Return $aTemp[3]
EndFunc   ;==>__GLI_Get by EXIT
#endregion - Language -
#region - Drive Info -
Func DriveInfo()
	 For $i = 1 To $aDrive[0]
		$DriveType[$i] = DriveGetType(StringUpper($aDrive[$i]) & "\")
		$DriveFree[$i] = Round((DriveSpaceTotal(StringUpper($aDrive[$i]) & "\") - DriveSpaceFree(StringUpper($aDrive[$i]) & "\")) / DriveSpaceTotal(StringUpper($aDrive[$i]) & "\") * 100, 0)
		GUICtrlSetData($DriveFreePos[$i], $DriveFree[$i])
		GUICtrlSetData($DriveTypeLabel[$i], $DriveType[$i])
	Next
EndFunc   ;==>DriveInfo

Func DriveInfoGUI()
	Opt("GUIOnEventMode", 1)
	GUISetState(@SW_HIDE, $MainGUI)
	$DriveInfoGUI = GUICreate("Drive Info", 300, 275, -1, -1)
	GUISetOnEvent($GUI_EVENT_CLOSE, "CloseDriveGUI")
	GUICtrlCreateLabel("Select a Drive's Drive Letter for Its Info:", 10, 10, 200, 20)
	$DriveLetter = GUICtrlCreateCombo("", 220, 10, 70, 20, 0x0003)
	GUICtrlSetOnEvent(-1, "DriveInfoLoad")
	For $i = 1 To $aDrive[0]
        GUICtrlSetData($DriveLetter, StringUpper($aDrive[$i]) & "\")
    Next
	GUICtrlCreateLabel("Label:", 10, 40, 80, 20)
	$DriveLabel = GUICtrlCreateLabel("", 100, 40, 100, 20, 0x1C01)
	GUICtrlCreateLabel("Status:", 10, 70, 80, 20)
	$DriveStatus = GUICtrlCreateLabel("", 100, 70, 100, 20, 0x1C01)
	GUICtrlCreateLabel("File System:", 10, 100, 80, 20)
	$DriveFileSystem = GUICtrlCreateLabel("", 100, 100, 100, 20, 0x1C01)
	GUICtrlCreateLabel("Type:", 10, 130, 80, 20)
	$DriveInfoType = GUICtrlCreateLabel("", 100, 130, 100, 20, 0x1C01)
	GUICtrlCreateLabel("Size:", 10, 160, 80, 20)
	$DriveSize = GUICtrlCreateLabel("", 100, 160, 100, 20, 0x1C01)
	GUICtrlCreateLabel("Serial Number:", 10, 190, 80, 20)
	$DriveSerial = GUICtrlCreateInput("", 100, 190, 100, 20, 0x0801)
	GUICtrlCreateLabel("Temperature:", 10, 220, 80, 20)
	$DriveTemp = GUICtrlCreateLabel("", 100, 220, 100, 20, 0x1C01)
	$DriveProgress = GUICtrlCreateProgress(10, 250, 280, 20)
	GUISetState(@SW_SHOW)
	While WinExists($DriveInfoGUI)
		Sleep(10)
	WEnd
EndFunc   ;==>DriveInfoGUI

Func DriveInfoLoad()
	$DriveInfoLoad = GUICtrlRead($DriveLetter)
	GUICtrlSetData($DriveProgress, Round((DriveSpaceTotal($DriveInfoLoad) - DriveSpaceFree($DriveInfoLoad)) / DriveSpaceTotal($DriveInfoLoad) * 100, 0))
	GUICtrlSetData($DriveLabel, DriveGetLabel($DriveInfoLoad))
	If DriveGetLabel($DriveInfoLoad) = "" Then GUICtrlSetData($DriveLabel, "No Label Set")
	GUICtrlSetData($DriveInfoType, DriveGetType($DriveInfoLoad) & " Device")
	GUICtrlSetData($DriveFileSystem, DriveGetFileSystem($DriveInfoLoad))
	GUICtrlSetData($DriveStatus, DriveStatus($DriveInfoLoad))
	$HDDSize = Round(DriveSpaceTotal($DriveInfoLoad), 0)
	If $HDDSize < 1024 Then
		GUICtrlSetData($DriveSize, "< 1 GB")
	Else
		GUICtrlSetData($DriveSize, Round($HDDSize / 1024) & " GB")
	EndIf
	GUICtrlSetData($DriveSerial, DriveGetSerial($DriveInfoLoad))
	If GUICtrlRead($DriveInfoType) = "Fixed Device" Then
		$tmp = _WMI_DriveTemperature()
		GUICtrlSetData($DriveTemp, $tmp & ' °C')
		If $tmp >= 40 Then GUICtrlSetBkColor($DriveTemp, 0xff0000)
		If $tmp < 40 Then GUICtrlSetBkColor($DriveTemp, 0x00ff00)
	Else
		GUICtrlSetData($DriveTemp, 'N/A')
		GUICtrlSetBkColor($DriveTemp, 0xf0f0f0)
	EndIf
	If DriveStatus($DriveInfoLoad) = "INVALID" Or $DriveInfoLoad = "" Then
		GUICtrlSetData($DriveLabel, "N/A")
		GUICtrlSetData($DriveInfoType, "N/A")
		GUICtrlSetData($DriveFileSystem, "N/A")
		GUICtrlSetData($DriveSize, "N/A")
		GUICtrlSetData($DriveSerial, "N/A")
		GUICtrlSetData($DriveProgress, 0)
	EndIf
EndFunc   ;==>DriveInfoLoad

Func CloseDriveGUI()
	GUIDelete($DriveInfo)
	GUISetState(@SW_SHOW, $MainGUI)
	Opt("GUIOnEventMode", 0)
EndFunc   ;==>CloseDriveGUI
#endregion - Drive Info -
#region - IP -
Func _IPDetails()
	Local $oWMIService = ObjGet("winmgmts:{impersonationLevel = impersonate}!\\" & "." & "\root\cimv2")
	Local $oColItems = $oWMIService.ExecQuery("Select * From Win32_NetworkAdapterConfiguration Where IPEnabled = True", "WQL", 0x30), $aReturn[5] = [4]
	If IsObj($oColItems) Then
		For $oObjectItem In $oColItems
			If $oObjectItem.IPAddress(0) == @IPAddress1 Then
				$aReturn[1] = $oObjectItem.MACAddress
				$aReturn[2] = $oObjectItem.DefaultIPGateway(0)
			EndIf
		Next
		Return $aReturn
	EndIf
	Return SetError(1, 0, $aReturn)
EndFunc   ;==>_IPDetails

Func _GetPublicIP()
	Local $aReturn, $bRead, $sRead
	$bRead = InetRead("http://checkip.dyndns.org/")
	$sRead = BinaryToString($bRead)
	$aReturn = StringRegExp($sRead, '(?s)(?i)<body>Current IP Address: (.*?)</body>', 3)
	If @error = 0 Then
		Return $aReturn[0]
	EndIf

	$bRead = InetRead("                                              ") ; http://forum.whatismyip.com/f14/our-automation-rules-t241/
	$sRead = BinaryToString($bRead)
	If @error Then
		Return SetError(1, 0, -1)
	EndIf
	Return $sRead
EndFunc   ;==>_GetPublicIP
#endregion - IP -
#region - Computer Get -
Func HardwareGUI($Equip)
	Dim $Battery, $BIOS, $Keyboard, $HDDInfo, $Memory, $Monitor, $Motherboard, $Mouse, $NetworkCards, $SoundCards, $Processors, $System, $VideoCards, $OSs
	GUISetState(@SW_HIDE, $MainGUI)
	$HardwareGUI = GUICreate($Equip & " Info", 300, 295, -1, -1, BitOR($WS_BORDER, $WS_POPUP), $WS_EX_TOPMOST)
	$Close = GUICtrlCreateButton("X", 280, 0, 20, 20)
	GUICtrlSetFont(-1, 12, 800)
	$HardwareLabel = GUICtrlCreateLabel($Equip & " Info", 0, 0, 280, 20, 0x01)
	GUICtrlSetFont(-1, 12, 600)
	$AboutEditbox = GUICtrlCreateEdit("", 0, 20, 300, 255, BitOR($ES_WANTRETURN, $WS_VSCROLL, $ES_AUTOVSCROLL, $ES_READONLY))
	GUISetState(@SW_SHOW)
	GUICtrlSetState($AboutEditbox, @SW_DISABLE)

	Switch $Equip
		Case "Battery"
			_ComputerGetBattery($Battery)
			For $i = 1 To $Battery[0][0] Step 1
				GUICtrlSetData($AboutEditbox, "Name: " & $Battery[$i][0] & @CRLF & _
						"Availability: " & $Battery[$i][1] & @CRLF & _
						"BatteryRechargeTime: " & $Battery[$i][2] & @CRLF & _
						"BatteryStatus: " & $Battery[$i][3] & @CRLF & _
						"Description: " & $Battery[$i][4] & @CRLF & _
						"Chemistry: " & $Battery[$i][5] & @CRLF & _
						"ConfigManagerErrorCode: " & $Battery[$i][6] & @CRLF & _
						"ConfigManagerUserConfig: " & $Battery[$i][7] & @CRLF & _
						"CreationClassName: " & $Battery[$i][8] & @CRLF & _
						"DesignCapacity: " & $Battery[$i][9] & @CRLF & _
						"DesignVoltage: " & $Battery[$i][10] & @CRLF & _
						"DeviceID: " & $Battery[$i][11] & @CRLF & _
						"ErrorCleared: " & $Battery[$i][12] & @CRLF & _
						"ErrorDescription: " & $Battery[$i][13] & @CRLF & _
						"EstimatedChargeRemaining: " & $Battery[$i][14] & @CRLF & _
						"EstimatedRunTime: " & $Battery[$i][15] & @CRLF & _
						"ExpectedBatteryLife: " & $Battery[$i][16] & @CRLF & _
						"ExpectedLife: " & $Battery[$i][17] & @CRLF & _
						"FullChargeCapacity: " & $Battery[$i][18] & @CRLF & _
						"LastErrorCode: " & $Battery[$i][19] & @CRLF & _
						"MaxRechargeTime: " & $Battery[$i][20] & @CRLF & _
						"PNPDeviceID: " & $Battery[$i][21] & @CRLF & _
						"PowerManagementCapabilities: " & $Battery[$i][22] & @CRLF & _
						"PowerManagementSupported: " & $Battery[$i][23] & @CRLF & _
						"SmartBatteryVersion: " & $Battery[$i][24] & @CRLF & _
						"Status: " & $Battery[$i][25] & @CRLF & _
						"StatusInfo: " & $Battery[$i][26] & @CRLF & _
						"SystemCreationClassName: " & $Battery[$i][27] & @CRLF & _
						"SystemName: " & $Battery[$i][28] & @CRLF & _
						"TimeOnBattery: " & $Battery[$i][29] & @CRLF & _
						"TimeToFullCharge: " & $Battery[$i][30] & @CRLF & @CRLF, 1)
			Next
		Case "BIOS"
			_ComputerGetBIOS($BIOS)
			For $i = 1 To $BIOS[0][0] Step 1
				GUICtrlSetData($AboutEditbox, "Name: " & $BIOS[$i][0] & @CRLF & _
						"Status: " & $BIOS[$i][1] & @CRLF & _
						"BIOS Characteristics: " & $BIOS[$i][2] & @CRLF & _
						"BIOS Version: " & $BIOS[$i][3] & @CRLF & _
						"Description: " & $BIOS[$i][4] & @CRLF & _
						"Build Number: " & $BIOS[$i][5] & @CRLF & _
						"Code Set: " & $BIOS[$i][6] & @CRLF & _
						"Current Language: " & $BIOS[$i][7] & @CRLF & _
						"Identification Code: " & $BIOS[$i][8] & @CRLF & _
						"Installable Languages: " & $BIOS[$i][9] & @CRLF & _
						"Language Edition: " & $BIOS[$i][10] & @CRLF & _
						"List of Languages: " & $BIOS[$i][11] & @CRLF & _
						"Manufacturer: " & $BIOS[$i][12] & @CRLF & _
						"Other Target OS: " & $BIOS[$i][13] & @CRLF & _
						"Primary BIOS: " & $BIOS[$i][14] & @CRLF & _
						"Release Date: " & $BIOS[$i][15] & @CRLF & _
						"Serial Number: " & $BIOS[$i][16] & @CRLF & _
						"SM BIOS BIOS Version: " & $BIOS[$i][17] & @CRLF & _
						"SM BIOS Major Version: " & $BIOS[$i][18] & @CRLF & _
						"SM BIOS Minor Version: " & $BIOS[$i][19] & @CRLF & _
						"SM BIOS Present: " & $BIOS[$i][20] & @CRLF & _
						"Software Element ID: " & $BIOS[$i][21] & @CRLF & _
						"Software Element State: " & $BIOS[$i][22] & @CRLF & _
						"Target Operating System: " & $BIOS[$i][23] & @CRLF & _
						"Version: " & $BIOS[$i][24] & @CRLF & @CRLF, 1)
			Next
		Case "Hard Drive"
			_ComputerGetHDD($HDDInfo)
			For $i = 1 To $HDDInfo[0][0] Step 1
				GUICtrlSetData($AboutEditbox, "Name: " & $HDDInfo[$i][0] & @CRLF & _
						"Availability: " & $HDDInfo[$i][1] & @CRLF & _
						"BytesPerSector: " & $HDDInfo[$i][2] & @CRLF & _
						"Capabilities: " & $HDDInfo[$i][3] & @CRLF & _
						"CapabilityDescriptions: " & $HDDInfo[$i][4] & @CRLF & _
						"Caption: " & $HDDInfo[$i][5] & @CRLF & _
						"CompressionMethod: " & $HDDInfo[$i][6] & @CRLF & _
						"ConfigManagerErrorCode: " & $HDDInfo[$i][7] & @CRLF & _
						"ConfigManagerUserConfig: " & $HDDInfo[$i][8] & @CRLF & _
						"CreationClassName: " & $HDDInfo[$i][9] & @CRLF & _
						"DefaultBlockSize: " & $HDDInfo[$i][10] & @CRLF & _
						"Description: " & $HDDInfo[$i][11] & @CRLF & _
						"DeviceID: " & $HDDInfo[$i][12] & @CRLF & _
						"ErrorCleared: " & $HDDInfo[$i][13] & @CRLF & _
						"ErrorDescription: " & $HDDInfo[$i][14] & @CRLF & _
						"ErrorMethodology: " & $HDDInfo[$i][15] & @CRLF & _
						"FirmwareRevision: " & $HDDInfo[$i][16] & @CRLF & _
						"Index: " & $HDDInfo[$i][17] & @CRLF & _
						"InstallDate: " & $HDDInfo[$i][18] & @CRLF & _
						"InterfaceType: " & $HDDInfo[$i][19] & @CRLF & _
						"LastErrorCode: " & $HDDInfo[$i][20] & @CRLF & _
						"Manufacturer: " & $HDDInfo[$i][21] & @CRLF & _
						"MaxBlockSize: " & $HDDInfo[$i][22] & @CRLF & _
						"MaxMediaSize: " & $HDDInfo[$i][23] & @CRLF & _
						"MediaLoaded: " & $HDDInfo[$i][24] & @CRLF & _
						"MediaType: " & $HDDInfo[$i][25] & @CRLF & _
						"MinBlockSize: " & $HDDInfo[$i][26] & @CRLF & _
						"Model: " & $HDDInfo[$i][27] & @CRLF & _
						"NeedsCleaning: " & $HDDInfo[$i][28] & @CRLF & _
						"NumberOfMediaSupported: " & $HDDInfo[$i][29] & @CRLF & _
						"Partitions: " & $HDDInfo[$i][30] & @CRLF & _
						"PNPDeviceID: " & $HDDInfo[$i][31] & @CRLF & _
						"PowerManagementCapabilities: " & $HDDInfo[$i][32] & @CRLF & _
						"PowerManagementSupported: " & $HDDInfo[$i][33] & @CRLF & _
						"SCSIBus: " & $HDDInfo[$i][34] & @CRLF & _
						"SCSILogicalUnit: " & $HDDInfo[$i][35] & @CRLF & _
						"SCSIPort: " & $HDDInfo[$i][36] & @CRLF & _
						"SCSITargetId: " & $HDDInfo[$i][37] & @CRLF & _
						"SectorsPerTrack: " & $HDDInfo[$i][38] & @CRLF & _
						"SerialNumber: " & $HDDInfo[$i][39] & @CRLF & _
						"Signature: " & $HDDInfo[$i][40] & @CRLF & _
						"Size: " & $HDDInfo[$i][41] & @CRLF & _
						"Status: " & $HDDInfo[$i][42] & @CRLF & _
						"StatusInfo: " & $HDDInfo[$i][43] & @CRLF & _
						"SystemCreationClassName: " & $HDDInfo[$i][44] & @CRLF & _
						"SystemName: " & $HDDInfo[$i][45] & @CRLF & _
						"TotalCylinders: " & $HDDInfo[$i][46] & @CRLF & _
						"TotalHeads: " & $HDDInfo[$i][47] & @CRLF & _
						"TotalSectors: " & $HDDInfo[$i][48] & @CRLF & _
						"TotalTracks: " & $HDDInfo[$i][49] & @CRLF & _
						"TracksPerCylinder: " & $HDDInfo[$i][50] & @CRLF & @CRLF, 1)
			Next
		Case "Keyboard"
			_ComputerGetKeyboard($Keyboard)
			For $i = 1 To $Keyboard[0][0] Step 1
				GUICtrlSetData($AboutEditbox, "Name: " & $Keyboard[$i][0] & @CRLF & _
						"Availability: " & $Keyboard[$i][1] & @CRLF & _
						"Config Manager Error Code: " & $Keyboard[$i][2] & @CRLF & _
						"Config Manager User Config: " & $Keyboard[$i][3] & @CRLF & _
						"Description: " & $Keyboard[$i][4] & @CRLF & _
						"Creation Class Name: " & $Keyboard[$i][5] & @CRLF & _
						"Device ID: " & $Keyboard[$i][6] & @CRLF & _
						"Error Cleared: " & $Keyboard[$i][7] & @CRLF & _
						"Error Description: " & $Keyboard[$i][8] & @CRLF & _
						"Is Locked: " & $Keyboard[$i][9] & @CRLF & _
						"Last Error Code: " & $Keyboard[$i][10] & @CRLF & _
						"Layout: " & $Keyboard[$i][11] & @CRLF & _
						"Number of Function Keys: " & $Keyboard[$i][12] & @CRLF & _
						"Password: " & $Keyboard[$i][13] & @CRLF & _
						"PNP Device ID: " & $Keyboard[$i][14] & @CRLF & _
						"Power Management Capabilities: " & $Keyboard[$i][15] & @CRLF & _
						"Power Management Supported: " & $Keyboard[$i][16] & @CRLF & _
						"Status: " & $Keyboard[$i][17] & @CRLF & _
						"Status Info: " & $Keyboard[$i][18] & @CRLF & _
						"System Creation Class Name: " & $Keyboard[$i][19] & @CRLF & _
						"System Name: " & $Keyboard[$i][20] & @CRLF & @CRLF, 1)
			Next
		Case "RAM (Memory)"
			_ComputerGetMemory($Memory)
			For $i = 1 To $Memory[0][0] Step 1
				GUICtrlSetData($AboutEditbox, "Name: " & $Memory[$i][0] & @CRLF & _
						"BankLabel: " & $Memory[$i][1] & @CRLF & _
						"Capacity: " & $Memory[$i][2] & @CRLF & _
						"CreationClassName: " & $Memory[$i][3] & @CRLF & _
						"Description: " & $Memory[$i][4] & @CRLF & _
						"DataWidth: " & $Memory[$i][5] & @CRLF & _
						"DeviceLocator: " & $Memory[$i][6] & @CRLF & _
						"FormFactor: " & $Memory[$i][7] & @CRLF & _
						"HotSwappable: " & $Memory[$i][8] & @CRLF & _
						"InterleaveDataDepth: " & $Memory[$i][9] & @CRLF & _
						"InterleavePosition: " & $Memory[$i][10] & @CRLF & _
						"Manufacturer: " & $Memory[$i][11] & @CRLF & _
						"MemoryType: " & $Memory[$i][12] & @CRLF & _
						"Model: " & $Memory[$i][13] & @CRLF & _
						"OtherIdentifyingInfo: " & $Memory[$i][14] & @CRLF & _
						"PartNumber: " & $Memory[$i][15] & @CRLF & _
						"PositionInRow: " & $Memory[$i][16] & @CRLF & _
						"PoweredOn: " & $Memory[$i][17] & @CRLF & _
						"Removable: " & $Memory[$i][18] & @CRLF & _
						"Replaceable: " & $Memory[$i][19] & @CRLF & _
						"SerialNumber: " & $Memory[$i][20] & @CRLF & _
						"SKU: " & $Memory[$i][21] & @CRLF & _
						"Speed: " & $Memory[$i][22] & @CRLF & _
						"Status: " & $Memory[$i][23] & @CRLF & _
						"Tag: " & $Memory[$i][24] & @CRLF & _
						"TotalWidth: " & $Memory[$i][25] & @CRLF & _
						"TypeDetail: " & $Memory[$i][26] & @CRLF & _
						"Version: " & $Memory[$i][27] & @CRLF & @CRLF, 1)
			Next
		Case "Monitor"
			_ComputerGetMonitors($Monitor)
			For $i = 1 To $Monitor[0][0] Step 1
				GUICtrlSetData($AboutEditbox, "Name: " & $Monitor[$i][0] & @CRLF & _
						"Availability: " & $Monitor[$i][1] & @CRLF & _
						"Bandwidth: " & $Monitor[$i][2] & @CRLF & _
						"ConfigManagerErrorCode: " & $Monitor[$i][3] & @CRLF & _
						"Description: " & $Monitor[$i][4] & @CRLF & _
						"ConfigManagerUserConfig: " & $Monitor[$i][5] & @CRLF & _
						"CreationClassName: " & $Monitor[$i][6] & @CRLF & _
						"DeviceID: " & $Monitor[$i][7] & @CRLF & _
						"DisplayType: " & $Monitor[$i][8] & @CRLF & _
						"ErrorCleared: " & $Monitor[$i][9] & @CRLF & _
						"ErrorDescription: " & $Monitor[$i][10] & @CRLF & _
						"IsLocked: " & $Monitor[$i][11] & @CRLF & _
						"LastErrorCode: " & $Monitor[$i][12] & @CRLF & _
						"MonitorManufacturer: " & $Monitor[$i][13] & @CRLF & _
						"MonitorType: " & $Monitor[$i][14] & @CRLF & _
						"PixelsPerXLogicalInch: " & $Monitor[$i][15] & @CRLF & _
						"PixelsPerYLogicalInch: " & $Monitor[$i][16] & @CRLF & _
						"PNPDeviceID: " & $Monitor[$i][17] & @CRLF & _
						"PowerManagementCapabilities: " & $Monitor[$i][18] & @CRLF & _
						"PowerManagementSupported: " & $Monitor[$i][19] & @CRLF & _
						"ScreenHeight: " & $Monitor[$i][20] & @CRLF & _
						"ScreenWidth: " & $Monitor[$i][21] & @CRLF & _
						"Status: " & $Monitor[$i][22] & @CRLF & _
						"StatusInfo: " & $Monitor[$i][23] & @CRLF & _
						"SystemCreationClassName: " & $Monitor[$i][24] & @CRLF & _
						"SystemName: " & $Monitor[$i][25] & @CRLF & @CRLF, 1)
			Next
		Case "Motherboard"
			_ComputerGetMotherboard($Motherboard)
			For $i = 1 To $Motherboard[0][0] Step 1
				GUICtrlSetData($AboutEditbox, "Name: " & $Motherboard[$i][0] & @CRLF & _
						"Availability: " & $Motherboard[$i][1] & @CRLF & _
						"ConfigManagerErrorCode: " & $Motherboard[$i][2] & @CRLF & _
						"ConfigManagerUserConfig: " & $Motherboard[$i][3] & @CRLF & _
						"Description: " & $Motherboard[$i][4] & @CRLF & _
						"CreationClassName: " & $Motherboard[$i][5] & @CRLF & _
						"DeviceID: " & $Motherboard[$i][6] & @CRLF & _
						"ErrorCleared: " & $Motherboard[$i][7] & @CRLF & _
						"ErrorDescription: " & $Motherboard[$i][8] & @CRLF & _
						"LastErrorCode: " & $Motherboard[$i][9] & @CRLF & _
						"PNPDeviceID: " & $Motherboard[$i][10] & @CRLF & _
						"PowerManagementCapabilities: " & $Motherboard[$i][11] & @CRLF & _
						"PowerManagementSupported: " & $Motherboard[$i][12] & @CRLF & _
						"PrimaryBusType: " & $Motherboard[$i][13] & @CRLF & _
						"RevisionNumber: " & $Motherboard[$i][14] & @CRLF & _
						"SecondaryBusType: " & $Motherboard[$i][15] & @CRLF & _
						"Status: " & $Motherboard[$i][16] & @CRLF & _
						"StatusInfo: " & $Motherboard[$i][17] & @CRLF & _
						"SystemCreationClassName: " & $Motherboard[$i][18] & @CRLF & _
						"SystemName: " & $Motherboard[$i][19] & @CRLF & @CRLF, 1)
			Next
		Case "Mouse"
			_ComputerGetMouse($Mouse)
			For $i = 1 To $Mouse[0][0] Step 1
				GUICtrlSetData($AboutEditbox, "Name: " & $Mouse[$i][0] & @CRLF & _
						"Availability: " & $Mouse[$i][1] & @CRLF & _
						"Config Manager Error Code: " & $Mouse[$i][2] & @CRLF & _
						"Config Manager User Config: " & $Mouse[$i][3] & @CRLF & _
						"Description: " & $Mouse[$i][4] & @CRLF & _
						"Creation Class Name: " & $Mouse[$i][5] & @CRLF & _
						"Device ID: " & $Mouse[$i][6] & @CRLF & _
						"Device Interface: " & $Mouse[$i][7] & @CRLF & _
						"Double Speed Threshold: " & $Mouse[$i][8] & @CRLF & _
						"Error Cleared: " & $Mouse[$i][9] & @CRLF & _
						"Error Description: " & $Mouse[$i][10] & @CRLF & _
						"Handedness: " & $Mouse[$i][11] & @CRLF & _
						"Hardware Type: " & $Mouse[$i][12] & @CRLF & _
						"Inf File Name: " & $Mouse[$i][13] & @CRLF & _
						"Inf Section: " & $Mouse[$i][14] & @CRLF & _
						"Is Locked: " & $Mouse[$i][15] & @CRLF & _
						"Last Error Code: " & $Mouse[$i][16] & @CRLF & _
						"Manufacturer: " & $Mouse[$i][17] & @CRLF & _
						"Number Of Buttons: " & $Mouse[$i][18] & @CRLF & _
						"PNP Device ID: " & $Mouse[$i][19] & @CRLF & _
						"Pointing Type: " & $Mouse[$i][20] & @CRLF & _
						"Power Management Capabilities: " & $Mouse[$i][21] & @CRLF & _
						"Power Management Supported: " & $Mouse[$i][22] & @CRLF & _
						"Quad Speed Threshold: " & $Mouse[$i][23] & @CRLF & _
						"Resolution: " & $Mouse[$i][24] & @CRLF & _
						"Sample Rate: " & $Mouse[$i][25] & @CRLF & _
						"Status: " & $Mouse[$i][26] & @CRLF & _
						"Status Info: " & $Mouse[$i][27] & @CRLF & _
						"Synch: " & $Mouse[$i][28] & @CRLF & _
						"System Creation Class Name: " & $Mouse[$i][29] & @CRLF & _
						"System Name: " & $Mouse[$i][30] & @CRLF & @CRLF, 1)
			Next
		Case "Network"
			_ComputerGetNetworkCards($NetworkCards)
			For $i = 1 To $NetworkCards[0][0] Step 1
				GUICtrlSetData($AboutEditbox, "Name: " & $NetworkCards[$i][0] & @CRLF & _
						"Adapter Type: " & $NetworkCards[$i][1] & @CRLF & _
						"Adapter Type ID: " & $NetworkCards[$i][2] & @CRLF & _
						"Auto Sense: " & $NetworkCards[$i][3] & @CRLF & _
						"Description: " & $NetworkCards[$i][4] & @CRLF & _
						"Availability: " & $NetworkCards[$i][5] & @CRLF & _
						"Config Manager Error Code: " & $NetworkCards[$i][6] & @CRLF & _
						"Config Manager User Config: " & $NetworkCards[$i][7] & @CRLF & _
						"Creation Class Name: " & $NetworkCards[$i][8] & @CRLF & _
						"Device ID: " & $NetworkCards[$i][9] & @CRLF & _
						"Error Cleared: " & $NetworkCards[$i][10] & @CRLF & _
						"Error Description: " & $NetworkCards[$i][11] & @CRLF & _
						"Index: " & $NetworkCards[$i][12] & @CRLF & _
						"Installed: " & $NetworkCards[$i][13] & @CRLF & _
						"Last Error Code: " & $NetworkCards[$i][14] & @CRLF & _
						"MAC Address: " & $NetworkCards[$i][15] & @CRLF & _
						"Manufacturer: " & $NetworkCards[$i][16] & @CRLF & _
						"Max Number Controlled: " & $NetworkCards[$i][17] & @CRLF & _
						"Max Speed: " & $NetworkCards[$i][18] & @CRLF & _
						"Net Connection ID: " & $NetworkCards[$i][19] & @CRLF & _
						"Net Connection Status: " & $NetworkCards[$i][20] & @CRLF & _
						"Network Addresses: " & $NetworkCards[$i][21] & @CRLF & _
						"Permanent Address: " & $NetworkCards[$i][22] & @CRLF & _
						"PNP Device ID: " & $NetworkCards[$i][23] & @CRLF & _
						"Power Management Capabilities: " & $NetworkCards[$i][24] & @CRLF & _
						"Power Management Supported: " & $NetworkCards[$i][25] & @CRLF & _
						"Product Name: " & $NetworkCards[$i][26] & @CRLF & _
						"Service Name: " & $NetworkCards[$i][27] & @CRLF & _
						"Speed: " & $NetworkCards[$i][28] & @CRLF & _
						"Status: " & $NetworkCards[$i][29] & @CRLF & _
						"Status Info: " & $NetworkCards[$i][30] & @CRLF & _
						"System Creation Class Name: " & $NetworkCards[$i][31] & @CRLF & _
						"System Name: " & $NetworkCards[$i][32] & @CRLF & _
						"Time Of Last Reset: " & $NetworkCards[$i][33] & @CRLF & @CRLF, 1)
			Next
		Case "System"
			_ComputerGetSystem($System)
			For $i = 1 To $System[0][0] Step 1
				GUICtrlSetData($AboutEditbox, "Name: " & $System[$i][0] & @CRLF & _
						"Admin Password Status: " & $System[$i][1] & @CRLF & _
						"Automatic Reset Boot Option: " & $System[$i][2] & @CRLF & _
						"Automatic Reset Capability: " & $System[$i][3] & @CRLF & _
						"Description: " & $System[$i][4] & @CRLF & _
						"Boot Option On Limit: " & $System[$i][5] & @CRLF & _
						"Boot Option On WatchDog: " & $System[$i][6] & @CRLF & _
						"Boot ROM Supported: " & $System[$i][7] & @CRLF & _
						"Bootup State: " & $System[$i][8] & @CRLF & _
						"Last Load Info: " & $System[$i][20] & @CRLF & _
						"Manufacturer: " & $System[$i][21] & @CRLF & _
						"Model: " & $System[$i][22] & @CRLF & _
						"Name Format: " & $System[$i][23] & @CRLF & _
						"Network Server Mode Enabled: " & $System[$i][24] & @CRLF & _
						"Number Of Processors: " & $System[$i][25] & @CRLF & _
						"OEM Logo Bitmap: " & $System[$i][26] & @CRLF & _
						"OEM String Array: " & $System[$i][27] & @CRLF & _
						"Part Of Domain: " & $System[$i][28] & @CRLF & _
						"Pause After Reset: " & $System[$i][29] & @CRLF & _
						"Power Management Capabilities: " & $System[$i][30] & @CRLF & _
						"Power Management Supported: " & $System[$i][31] & @CRLF & _
						"Power On Password Status: " & $System[$i][32] & @CRLF & _
						"Power State: " & $System[$i][33] & @CRLF & _
						"Power Supply State: " & $System[$i][34] & @CRLF & _
						"Primary Owner Contact: " & $System[$i][35] & @CRLF & _
						"Primary Owner Name: " & $System[$i][36] & @CRLF & _
						"Reset Capability: " & $System[$i][37] & @CRLF & _
						"Reset Count: " & $System[$i][38] & @CRLF & _
						"Reset Limit: " & $System[$i][39] & @CRLF & _
						"Roles: " & $System[$i][40] & @CRLF & _
						"Status: " & $System[$i][41] & @CRLF & _
						"Support Contact Description: " & $System[$i][42] & @CRLF & _
						"System Startup Delay: " & $System[$i][43] & @CRLF & _
						"System Startup Options: " & $System[$i][44] & @CRLF & _
						"System Startup Setting: " & $System[$i][45] & @CRLF & _
						"System Type: " & $System[$i][46] & @CRLF & _
						"Thermal State: " & $System[$i][47] & @CRLF & _
						"Total Physical Memory: " & Round($System[$i][48] / 1024 / 1024 / 1024, 3) & @CRLF & _
						"User Name: " & $System[$i][49] & @CRLF & _
						"Wake Up Type: " & $System[$i][50] & @CRLF & _
						"Workgroup: " & $System[$i][51] & @CRLF & @CRLF, 1)
			Next
		Case "Processor"
			_ComputerGetProcessors($Processors)
			For $i = 1 To $Processors[0][0] Step 1
				GUICtrlSetData($AboutEditbox, "Name: " & $Processors[$i][0] & @CRLF & _
						"Address Width: " & $Processors[$i][1] & @CRLF & _
						"Architecture: " & $Processors[$i][2] & @CRLF & _
						"Availability: " & $Processors[$i][3] & @CRLF & _
						"Description: " & $Processors[$i][4] & @CRLF & _
						"Config Manager Error Code: " & $Processors[$i][5] & @CRLF & _
						"Config Manager User Config: " & $Processors[$i][6] & @CRLF & _
						"CPU Status: " & $Processors[$i][7] & @CRLF & _
						"Creation Class Name: " & $Processors[$i][8] & @CRLF & _
						"Current Clock Speed: " & $Processors[$i][9] & @CRLF & _
						"Current Voltage: " & $Processors[$i][10] & @CRLF & _
						"Data Width: " & $Processors[$i][11] & @CRLF & _
						"Device ID: " & $Processors[$i][12] & @CRLF & _
						"Error Cleared: " & $Processors[$i][13] & @CRLF & _
						"Error Description: " & $Processors[$i][14] & @CRLF & _
						"Ext Clock: " & $Processors[$i][15] & @CRLF & _
						"Family: " & $Processors[$i][16] & @CRLF & _
						"L2 Cache Size: " & $Processors[$i][17] & @CRLF & _
						"L2 Cache Speed: " & $Processors[$i][18] & @CRLF & _
						"Last Error Code: " & $Processors[$i][19] & @CRLF & _
						"Level: " & $Processors[$i][20] & @CRLF & _
						"Load Percentage: " & $Processors[$i][21] & @CRLF & _
						"Manufacturer: " & $Processors[$i][22] & @CRLF & _
						"Max Clock Speed: " & $Processors[$i][23] & @CRLF & _
						"Other Family Description: " & $Processors[$i][24] & @CRLF & _
						"PNP Device ID: " & $Processors[$i][25] & @CRLF & _
						"Power Management Capabilities: " & $Processors[$i][26] & @CRLF & _
						"Power Management Supported: " & $Processors[$i][27] & @CRLF & _
						"Processor ID: " & $Processors[$i][28] & @CRLF & _
						"Processor Type: " & $Processors[$i][29] & @CRLF & _
						"Revision: " & $Processors[$i][30] & @CRLF & _
						"Role: " & $Processors[$i][31] & @CRLF & _
						"Socket Designation: " & $Processors[$i][32] & @CRLF & _
						"Status: " & $Processors[$i][33] & @CRLF & _
						"Status Info: " & $Processors[$i][34] & @CRLF & _
						"Stepping: " & $Processors[$i][35] & @CRLF & _
						"System Creation Class Name: " & $Processors[$i][36] & @CRLF & _
						"System Name: " & $Processors[$i][37] & @CRLF & _
						"Unique ID: " & $Processors[$i][38] & @CRLF & _
						"Upgrade Method: " & $Processors[$i][39] & @CRLF & _
						"Version: " & $Processors[$i][40] & @CRLF & _
						"Voltage Caps: " & $Processors[$i][41] & @CRLF & @CRLF, 1)
			Next
		Case "Sound Card"
			_ComputerGetSoundCards($SoundCards)
			For $i = 1 To $SoundCards[0][0] Step 1
				GUICtrlSetData($AboutEditbox, "Name: " & $SoundCards[$i][0] & @CRLF & _
						"Availability: " & $SoundCards[$i][1] & @CRLF & _
						"Config Manager Error Code: " & $SoundCards[$i][2] & @CRLF & _
						"Config Manager User Config: " & $SoundCards[$i][3] & @CRLF & _
						"Description: " & $SoundCards[$i][4] & @CRLF & _
						"Creation Class Name: " & $SoundCards[$i][5] & @CRLF & _
						"Device ID: " & $SoundCards[$i][6] & @CRLF & _
						"DMA Buffer Size: " & $SoundCards[$i][7] & @CRLF & _
						"Error Cleared: " & $SoundCards[$i][8] & @CRLF & _
						"Error Description: " & $SoundCards[$i][9] & @CRLF & _
						"Last Error Code: " & $SoundCards[$i][10] & @CRLF & _
						"Manufacturer: " & $SoundCards[$i][11] & @CRLF & _
						"MPU 401 Address: " & $SoundCards[$i][12] & @CRLF & _
						"PNP Device ID: " & $SoundCards[$i][13] & @CRLF & _
						"Power Management Capabilities: " & $SoundCards[$i][14] & @CRLF & _
						"Power Management Supported: " & $SoundCards[$i][15] & @CRLF & _
						"Product Name: " & $SoundCards[$i][16] & @CRLF & _
						"Status: " & $SoundCards[$i][17] & @CRLF & _
						"Status Info: " & $SoundCards[$i][18] & @CRLF & _
						"System Creation Class Name: " & $SoundCards[$i][19] & @CRLF & _
						"System Name: " & $SoundCards[$i][20] & @CRLF & @CRLF, 1)
			Next
		Case "Graphics Card"
			_ComputerGetVideoCards($VideoCards)
			For $i = 1 To $VideoCards[0][0] Step 1
				GUICtrlSetData($AboutEditbox, "Name: " & $VideoCards[$i][0] & @CRLF & _
						"Accelerator Capabilities: " & $VideoCards[$i][1] & @CRLF & _
						"Adapter Compatibility: " & $VideoCards[$i][2] & @CRLF & _
						"Adapter DAC Type: " & $VideoCards[$i][3] & @CRLF & _
						"Description: " & $VideoCards[$i][4] & @CRLF & _
						"Adapter RAM: " & $VideoCards[$i][5] & @CRLF & _
						"Availability: " & $VideoCards[$i][6] & @CRLF & _
						"Capability Descriptions: " & $VideoCards[$i][7] & @CRLF & _
						"Color Table Entries: " & $VideoCards[$i][8] & @CRLF & _
						"Config Manager Error Code: " & $VideoCards[$i][9] & @CRLF & _
						"Config Manager User Config: " & $VideoCards[$i][10] & @CRLF & _
						"Creation Class Name: " & $VideoCards[$i][11] & @CRLF & _
						"Current Bits Per Pixel: " & $VideoCards[$i][12] & @CRLF & _
						"Current Horizontal Resolution: " & $VideoCards[$i][13] & @CRLF & _
						"Current Number Of Colors: " & $VideoCards[$i][14] & @CRLF & _
						"Current Number Of Columns: " & $VideoCards[$i][15] & @CRLF & _
						"Current Number Of Rows: " & $VideoCards[$i][16] & @CRLF & _
						"Current Refresh Rate: " & $VideoCards[$i][17] & @CRLF & _
						"Current Scan Mode: " & $VideoCards[$i][18] & @CRLF & _
						"Current Vertical Resolution: " & $VideoCards[$i][19] & @CRLF & _
						"Device ID: " & $VideoCards[$i][20] & @CRLF & _
						"Device Specific Pens: " & $VideoCards[$i][21] & @CRLF & _
						"Dither Type: " & $VideoCards[$i][22] & @CRLF & _
						"Driver Date: " & $VideoCards[$i][23] & @CRLF & _
						"Driver Version: " & $VideoCards[$i][24] & @CRLF & _
						"Error Cleared: " & $VideoCards[$i][25] & @CRLF & _
						"Error Description: " & $VideoCards[$i][26] & @CRLF & _
						"ICM Intent: " & $VideoCards[$i][27] & @CRLF & _
						"ICM Method: " & $VideoCards[$i][28] & @CRLF & _
						"Inf Filename: " & $VideoCards[$i][29] & @CRLF & _
						"Inf Section: " & $VideoCards[$i][30] & @CRLF & _
						"Installed Display Drivers: " & $VideoCards[$i][31] & @CRLF & _
						"Last Error Code: " & $VideoCards[$i][32] & @CRLF & _
						"Max Memory Supported: " & $VideoCards[$i][33] & @CRLF & _
						"Max Number Controlled: " & $VideoCards[$i][34] & @CRLF & _
						"Max Refresh Rate: " & $VideoCards[$i][35] & @CRLF & _
						"Min Refresh Rate: " & $VideoCards[$i][36] & @CRLF & _
						"Monochrome: " & $VideoCards[$i][37] & @CRLF & _
						"Number Of Color Planes: " & $VideoCards[$i][38] & @CRLF & _
						"Number Of Video Pages: " & $VideoCards[$i][39] & @CRLF & _
						"PNP Device ID: " & $VideoCards[$i][40] & @CRLF & _
						"Power Management Capabilities: " & $VideoCards[$i][41] & @CRLF & _
						"Power Management Supported: " & $VideoCards[$i][42] & @CRLF & _
						"Protocol Supported: " & $VideoCards[$i][43] & @CRLF & _
						"Reserved System Palette Entries: " & $VideoCards[$i][44] & @CRLF & _
						"Specification Version: " & $VideoCards[$i][45] & @CRLF & _
						"Status: " & $VideoCards[$i][46] & @CRLF & _
						"Status Info: " & $VideoCards[$i][47] & @CRLF & _
						"System Creation Class Name: " & $VideoCards[$i][48] & @CRLF & _
						"System Name: " & $VideoCards[$i][49] & @CRLF & _
						"System Palette Entries: " & $VideoCards[$i][50] & @CRLF & _
						"Time Of Last Reset: " & $VideoCards[$i][51] & @CRLF & _
						"Video Architecture: " & $VideoCards[$i][52] & @CRLF & _
						"Video Memory Type: " & $VideoCards[$i][53] & @CRLF & _
						"Video Mode: " & $VideoCards[$i][54] & @CRLF & _
						"Video Mode Description: " & $VideoCards[$i][55] & @CRLF & _
						"Video Processor: " & $VideoCards[$i][56] & @CRLF & @CRLF, 1)
			Next
		Case "Operating System"
			_ComputerGetOSs($OSs)
			For $i = 1 To $OSs[0][0] Step 1
				GUICtrlSetData($AboutEditbox, "Name: " & $OSs[$i][0] & @CRLF & _
						"Boot Device: " & $OSs[$i][1] & @CRLF & _
						"Build Number: " & $OSs[$i][2] & @CRLF & _
						"Build Type: " & $OSs[$i][3] & @CRLF & _
						"Description: " & $OSs[$i][4] & @CRLF & _
						"Code Set: " & $OSs[$i][5] & @CRLF & _
						"Country Code: " & $OSs[$i][6] & @CRLF & _
						"Creation Class Name: " & $OSs[$i][7] & @CRLF & _
						"CSCreation Class Name: " & $OSs[$i][8] & @CRLF & _
						"CSD Version: " & $OSs[$i][9] & @CRLF & _
						"CS Name: " & $OSs[$i][10] & @CRLF & _
						"Current Time Zone: " & $OSs[$i][11] & @CRLF & _
						"Data Execution Prevention_32BitApplications: " & $OSs[$i][12] & @CRLF & _
						"Data Execution Prevention_Available: " & $OSs[$i][13] & @CRLF & _
						"Data Execution Prevention_Drivers: " & $OSs[$i][14] & @CRLF & _
						"Data Execution Prevention_SupportPolicy: " & $OSs[$i][15] & @CRLF & _
						"Debug: " & $OSs[$i][16] & @CRLF & _
						"Distributed: " & $OSs[$i][17] & @CRLF & _
						"Encryption Level: " & $OSs[$i][18] & @CRLF & _
						"Foreground Application Boost: " & $OSs[$i][19] & @CRLF & _
						"Free Physical Memory: " & $OSs[$i][20] & @CRLF & _
						"Free Space In Paging Files: " & $OSs[$i][21] & @CRLF & _
						"Free Virtual Memory: " & $OSs[$i][22] & @CRLF & _
						"Install Date: " & $OSs[$i][23] & @CRLF & _
						"Large System Cache: " & $OSs[$i][24] & @CRLF & _
						"Last Boot Up Time: " & $OSs[$i][25] & @CRLF & _
						"Local Date Time: " & $OSs[$i][26] & @CRLF & _
						"Locale: " & $OSs[$i][27] & @CRLF & _
						"Manufacturer: " & $OSs[$i][28] & @CRLF & _
						"Max Number Of Processes: " & $OSs[$i][29] & @CRLF & _
						"Max Process Memory Size: " & $OSs[$i][30] & @CRLF & _
						"Number Of Licensed Users: " & $OSs[$i][31] & @CRLF & _
						"Number Of Processes: " & $OSs[$i][32] & @CRLF & _
						"Number Of Users: " & $OSs[$i][33] & @CRLF & _
						"Organization: " & $OSs[$i][34] & @CRLF & _
						"OS Language: " & $OSs[$i][35] & @CRLF & _
						"OS Product Suite: " & $OSs[$i][36] & @CRLF & _
						"OS Type: " & $OSs[$i][37] & @CRLF & _
						"Other Type Description: " & $OSs[$i][38] & @CRLF & _
						"Plus Product ID: " & $OSs[$i][39] & @CRLF & _
						"Plus Version Number: " & $OSs[$i][40] & @CRLF & _
						"Primary: " & $OSs[$i][41] & @CRLF & _
						"Product Type: " & $OSs[$i][42] & @CRLF & _
						"Quantum Length: " & $OSs[$i][43] & @CRLF & _
						"Quantum Type: " & $OSs[$i][44] & @CRLF & _
						"Registered User: " & $OSs[$i][45] & @CRLF & _
						"Serial Number: " & $OSs[$i][46] & @CRLF & _
						"Service Pack Major Version: " & $OSs[$i][47] & @CRLF & _
						"Service Pack Minor Version: " & $OSs[$i][48] & @CRLF & _
						"Size Stored In Paging Files: " & $OSs[$i][49] & @CRLF & _
						"Status: " & $OSs[$i][50] & @CRLF & _
						"Suite Mask: " & $OSs[$i][51] & @CRLF & _
						"System Device: " & $OSs[$i][52] & @CRLF & _
						"System Directory: " & $OSs[$i][53] & @CRLF & _
						"System Drive: " & $OSs[$i][54] & @CRLF & _
						"Total Swap Space Size: " & $OSs[$i][55] & @CRLF & _
						"Total Virtual Memory Size: " & $OSs[$i][56] & @CRLF & _
						"Total Visible Memory Size: " & $OSs[$i][57] & @CRLF & _
						"Version: " & $OSs[$i][58] & @CRLF & _
						"Windows Directory: " & $OSs[$i][59] & @CRLF & @CRLF, 1)
			Next
	EndSwitch

	$oShell = ObjCreate("Shell.Explorer.2")
	$iCtrlID = GUICtrlCreateObj($oShell, 0, 275, 300, 20)

	$oShell.navigate("about:blank")
	While $oShell.busy
		Sleep(100)
	WEnd

	With $oShell.document
		.write('<header><center><a href="'& $MSDNLink &'"  target="_blank">What does this information mean?</a></center></header>')
		.body.scroll = "no"
		.body.topmargin = 0
		.body.leftmargin = 0
		.body.bgcolor = 0xF0F0F0
		.body.style.color = 0x000000
		.body.style.fontSize = 16
	EndWith

	While 1
		Switch GUIGetMsg()
			Case $GUI_EVENT_CLOSE
				GUIDelete($HardwareGUI)
				GUISetState(@SW_SHOW, $MainGUI)
				WinActivate($MainGUI)
				ExitLoop
			Case $Close
				GUIDelete($HardwareGUI)
				GUISetState(@SW_SHOW, $MainGUI)
				WinActivate($MainGUI)
				ExitLoop
			Case $GUI_EVENT_PRIMARYDOWN
				On_Drag($HardwareGUI, $HardwareLabel)
		 EndSwitch
	WEnd

EndFunc   ;==>HardwareGUI
Func _ComputerGetBattery(ByRef $aBatteryInfo)
	Local $colItems, $objWMIService, $objItem
	Dim $aBatteryInfo[1][31], $i = 1

	$objWMIService = ObjGet("winmgmts:\\" & @ComputerName & "\root\CIMV2")
	$colItems = $objWMIService.ExecQuery("SELECT * FROM Win32_Battery", "WQL", $wbemFlagReturnImmediately + $wbemFlagForwardOnly)
	$MSDNLink = "http://msdn.microsoft.com/en-us/library/windows/desktop/aa394074(v=vs.85).aspx"

	If IsObj($colItems) Then
		For $objItem In $colItems
			ReDim $aBatteryInfo[UBound($aBatteryInfo) + 1][31]
			$aBatteryInfo[$i][0] = $objItem.Name
			$aBatteryInfo[$i][1] = $objItem.Availability
			$aBatteryInfo[$i][2] = $objItem.BatteryRechargeTime
			$aBatteryInfo[$i][3] = $objItem.BatteryStatus
			$aBatteryInfo[$i][4] = $objItem.Description
			$aBatteryInfo[$i][5] = $objItem.Chemistry
			$aBatteryInfo[$i][6] = $objItem.ConfigManagerErrorCode
			$aBatteryInfo[$i][7] = $objItem.ConfigManagerUserConfig
			$aBatteryInfo[$i][8] = $objItem.CreationClassName
			$aBatteryInfo[$i][9] = $objItem.DesignCapacity
			$aBatteryInfo[$i][10] = $objItem.DesignVoltage
			$aBatteryInfo[$i][11] = $objItem.DeviceID
			$aBatteryInfo[$i][12] = $objItem.ErrorCleared
			$aBatteryInfo[$i][13] = $objItem.ErrorDescription
			$aBatteryInfo[$i][14] = $objItem.EstimatedChargeRemaining
			$aBatteryInfo[$i][15] = $objItem.EstimatedRunTime
			$aBatteryInfo[$i][16] = $objItem.ExpectedBatteryLife
			$aBatteryInfo[$i][17] = $objItem.ExpectedLife
			$aBatteryInfo[$i][18] = $objItem.FullChargeCapacity
			$aBatteryInfo[$i][19] = $objItem.LastErrorCode
			$aBatteryInfo[$i][20] = $objItem.MaxRechargeTime
			$aBatteryInfo[$i][21] = $objItem.PNPDeviceID
			$aBatteryInfo[$i][22] = $objItem.PowerManagementCapabilities(0)
			$aBatteryInfo[$i][23] = $objItem.PowerManagementSupported
			$aBatteryInfo[$i][24] = $objItem.SmartBatteryVersion
			$aBatteryInfo[$i][25] = $objItem.Status
			$aBatteryInfo[$i][26] = $objItem.StatusInfo
			$aBatteryInfo[$i][27] = $objItem.SystemCreationClassName
			$aBatteryInfo[$i][28] = $objItem.SystemName
			$aBatteryInfo[$i][29] = $objItem.TimeOnBattery
			$aBatteryInfo[$i][30] = $objItem.TimeToFullCharge
			$i += 1
		Next
		$aBatteryInfo[0][0] = UBound($aBatteryInfo) - 1
		If $aBatteryInfo[0][0] < 1 Then
			SetError(1, 1, 0)
		EndIf
	Else
		SetError(1, 2, 0)
	EndIf
EndFunc   ;==>_ComputerGetBattery

Func _ComputerGetHDD(ByRef $aHDDInfo)
	Local $colItems, $objWMIService, $objItem
	Dim $aHDDInfo[1][51], $i = 1

	$objWMIService = ObjGet("winmgmts:\\" & @ComputerName & "\root\CIMV2")
	$colItems = $objWMIService.ExecQuery("SELECT * FROM Win32_DiskDrive", "WQL", $wbemFlagReturnImmediately + $wbemFlagForwardOnly)
	$MSDNLink = "http://msdn.microsoft.com/en-us/library/windows/desktop/aa394132(v=vs.85).aspx"

	If IsObj($colItems) Then
		For $objItem In $colItems
			ReDim $aHDDInfo[UBound($aHDDInfo) + 1][51]
			$aHDDInfo[$i][0] = $objItem.Name
			$aHDDInfo[$i][1] = $objItem.Availability
			$aHDDInfo[$i][2] = $objItem.BytesPerSector
			$aHDDInfo[$i][3] = $objItem.Capabilities(0)
			$aHDDInfo[$i][4] = $objItem.CapabilityDescriptions(0)
			$aHDDInfo[$i][5] = $objItem.Caption
			$aHDDInfo[$i][6] = $objItem.CompressionMethod
			$aHDDInfo[$i][7] = $objItem.ConfigManagerErrorCode
			$aHDDInfo[$i][8] = $objItem.ConfigManagerUserConfig
			$aHDDInfo[$i][9] = $objItem.CreationClassName
			$aHDDInfo[$i][10] = $objItem.DefaultBlockSize
			$aHDDInfo[$i][11] = $objItem.Description
			$aHDDInfo[$i][12] = $objItem.DeviceID
			$aHDDInfo[$i][13] = $objItem.ErrorCleared
			$aHDDInfo[$i][14] = $objItem.ErrorDescription
			$aHDDInfo[$i][15] = $objItem.ErrorMethodology
			$aHDDInfo[$i][16] = $objItem.FirmwareRevision
			$aHDDInfo[$i][17] = $objItem.Index
			$aHDDInfo[$i][18] = __StringToDate($objItem.InstallDate)
			$aHDDInfo[$i][19] = $objItem.InterfaceType
			$aHDDInfo[$i][20] = $objItem.LastErrorCode
			$aHDDInfo[$i][21] = $objItem.Manufacturer
			$aHDDInfo[$i][22] = $objItem.MaxBlockSize
			$aHDDInfo[$i][23] = $objItem.MaxMediaSize
			$aHDDInfo[$i][24] = $objItem.MediaLoaded
			$aHDDInfo[$i][25] = $objItem.MediaType
			$aHDDInfo[$i][26] = $objItem.MinBlockSize
			$aHDDInfo[$i][27] = $objItem.Model
			$aHDDInfo[$i][28] = $objItem.NeedsCleaning
			$aHDDInfo[$i][29] = $objItem.NumberOfMediaSupported
			$aHDDInfo[$i][30] = $objItem.Partitions
			$aHDDInfo[$i][31] = $objItem.PNPDeviceID
			$aHDDInfo[$i][32] = $objItem.PowerManagementCapabilities
			$aHDDInfo[$i][33] = $objItem.PowerManagementSupported
			$aHDDInfo[$i][34] = $objItem.SCSIBus
			$aHDDInfo[$i][35] = $objItem.SCSILogicalUnit
			$aHDDInfo[$i][36] = $objItem.SCSIPort
			$aHDDInfo[$i][37] = $objItem.SCSITargetId
			$aHDDInfo[$i][38] = $objItem.SectorsPerTrack
			$aHDDInfo[$i][39] = $objItem.SerialNumber
			$aHDDInfo[$i][40] = $objItem.Signature
			$aHDDInfo[$i][41] = $objItem.Size
			$aHDDInfo[$i][42] = $objItem.Status
			$aHDDInfo[$i][43] = $objItem.StatusInfo
			$aHDDInfo[$i][44] = $objItem.SystemCreationClassName
			$aHDDInfo[$i][45] = $objItem.SystemName
			$aHDDInfo[$i][46] = $objItem.TotalCylinders
			$aHDDInfo[$i][47] = $objItem.TotalHeads
			$aHDDInfo[$i][48] = $objItem.TotalSectors
			$aHDDInfo[$i][49] = $objItem.TotalTracks
			$aHDDInfo[$i][50] = $objItem.TracksPerCylinder

			$i += 1
		Next
		$aHDDInfo[0][0] = UBound($aHDDInfo) - 1
		If $aHDDInfo[0][0] < 1 Then
			SetError(1, 1, 0)
		EndIf
	Else
		SetError(1, 2, 0)
	EndIf
EndFunc   ;==>_ComputerGetHDD

Func _ComputerGetKeyboard(ByRef $aKeyboardInfo)
	Local $colItems, $objWMIService, $objItem
	Dim $aKeyboardInfo[1][21], $i = 1

	$objWMIService = ObjGet("winmgmts:\\" & @ComputerName & "\root\CIMV2")
	$colItems = $objWMIService.ExecQuery("SELECT * FROM Win32_Keyboard", "WQL", $wbemFlagReturnImmediately + $wbemFlagForwardOnly)
	$MSDNLink = "http://msdn.microsoft.com/en-us/library/windows/desktop/aa394166(v=vs.85).aspx"

	If IsObj($colItems) Then
		For $objItem In $colItems
			ReDim $aKeyboardInfo[UBound($aKeyboardInfo) + 1][21]
			$aKeyboardInfo[$i][0] = $objItem.Name
			$aKeyboardInfo[$i][1] = $objItem.Availability
			$aKeyboardInfo[$i][2] = $objItem.ConfigManagerErrorCode
			$aKeyboardInfo[$i][3] = $objItem.ConfigManagerUserConfig
			$aKeyboardInfo[$i][4] = $objItem.Description
			$aKeyboardInfo[$i][5] = $objItem.CreationClassName
			$aKeyboardInfo[$i][6] = $objItem.DeviceID
			$aKeyboardInfo[$i][7] = $objItem.ErrorCleared
			$aKeyboardInfo[$i][8] = $objItem.ErrorDescription
			$aKeyboardInfo[$i][9] = $objItem.IsLocked
			$aKeyboardInfo[$i][10] = $objItem.LastErrorCode
			$aKeyboardInfo[$i][11] = $objItem.Layout
			$aKeyboardInfo[$i][12] = $objItem.NumberOfFunctionKeys
			$aKeyboardInfo[$i][13] = $objItem.Password
			$aKeyboardInfo[$i][14] = $objItem.PNPDeviceID
			$aKeyboardInfo[$i][15] = $objItem.PowerManagementCapabilities(0)
			$aKeyboardInfo[$i][16] = $objItem.PowerManagementSupported
			$aKeyboardInfo[$i][17] = $objItem.Status
			$aKeyboardInfo[$i][18] = $objItem.StatusInfo
			$aKeyboardInfo[$i][19] = $objItem.SystemCreationClassName
			$aKeyboardInfo[$i][20] = $objItem.SystemName
			$i += 1
		Next
		$aKeyboardInfo[0][0] = UBound($aKeyboardInfo) - 1
		If $aKeyboardInfo[0][0] < 1 Then
			SetError(1, 1, 0)
		EndIf
	Else
		SetError(1, 2, 0)
	EndIf
EndFunc   ;==>_ComputerGetKeyboard

Func _ComputerGetMemory(ByRef $aMemoryInfo)
	Local $colItems, $objWMIService, $objItem
	Dim $aMemoryInfo[1][28], $i = 1

	$objWMIService = ObjGet("winmgmts:\\" & @ComputerName & "\root\CIMV2")
	$colItems = $objWMIService.ExecQuery("SELECT * FROM Win32_PhysicalMemory", "WQL", $wbemFlagReturnImmediately + $wbemFlagForwardOnly)
	$MSDNLink = "http://msdn.microsoft.com/en-us/library/windows/desktop/aa394347(v=vs.85).aspx"

	If IsObj($colItems) Then
		For $objItem In $colItems
			ReDim $aMemoryInfo[UBound($aMemoryInfo) + 1][28]
			$aMemoryInfo[$i][0] = $objItem.Name
			$aMemoryInfo[$i][1] = $objItem.BankLabel
			$aMemoryInfo[$i][2] = $objItem.Capacity
			$aMemoryInfo[$i][3] = $objItem.CreationClassName
			$aMemoryInfo[$i][4] = $objItem.Description
			$aMemoryInfo[$i][5] = $objItem.DataWidth
			$aMemoryInfo[$i][6] = $objItem.DeviceLocator
			$aMemoryInfo[$i][7] = $objItem.FormFactor
			$aMemoryInfo[$i][8] = $objItem.HotSwappable
			$aMemoryInfo[$i][9] = $objItem.InterleaveDataDepth
			$aMemoryInfo[$i][10] = $objItem.InterleavePosition
			$aMemoryInfo[$i][11] = $objItem.Manufacturer
			$aMemoryInfo[$i][12] = $objItem.MemoryType
			$aMemoryInfo[$i][13] = $objItem.Model
			$aMemoryInfo[$i][14] = $objItem.OtherIdentifyingInfo
			$aMemoryInfo[$i][15] = $objItem.PartNumber
			$aMemoryInfo[$i][16] = $objItem.PositionInRow
			$aMemoryInfo[$i][17] = $objItem.PoweredOn
			$aMemoryInfo[$i][18] = $objItem.Removable
			$aMemoryInfo[$i][19] = $objItem.Replaceable
			$aMemoryInfo[$i][20] = $objItem.SerialNumber
			$aMemoryInfo[$i][21] = $objItem.SKU
			$aMemoryInfo[$i][22] = $objItem.Speed
			$aMemoryInfo[$i][23] = $objItem.Status
			$aMemoryInfo[$i][24] = $objItem.Tag
			$aMemoryInfo[$i][25] = $objItem.TotalWidth
			$aMemoryInfo[$i][26] = $objItem.TypeDetail
			$aMemoryInfo[$i][27] = $objItem.Version
			$i += 1
		Next
		$aMemoryInfo[0][0] = UBound($aMemoryInfo) - 1
		If $aMemoryInfo[0][0] < 1 Then
			SetError(1, 1, 0)
		EndIf
	Else
		SetError(1, 2, 0)
	EndIf
EndFunc   ;==>_ComputerGetMemory

Func _ComputerGetMonitors(ByRef $aMonitorInfo)
	Local $colItems, $objWMIService, $objItem
	Dim $aMonitorInfo[1][26], $i = 1

	$objWMIService = ObjGet("winmgmts:\\" & @ComputerName & "\root\CIMV2")
	$colItems = $objWMIService.ExecQuery("SELECT * FROM Win32_DesktopMonitor", "WQL", $wbemFlagReturnImmediately + $wbemFlagForwardOnly)
	$MSDNLink = "http://msdn.microsoft.com/en-us/library/windows/desktop/aa394122(v=vs.85).aspx"

	If IsObj($colItems) Then
		For $objItem In $colItems
			ReDim $aMonitorInfo[UBound($aMonitorInfo) + 1][26]
			$aMonitorInfo[$i][0] = $objItem.Name
			$aMonitorInfo[$i][1] = $objItem.Availability
			$aMonitorInfo[$i][2] = $objItem.Bandwidth
			$aMonitorInfo[$i][3] = $objItem.ConfigManagerErrorCode
			$aMonitorInfo[$i][4] = $objItem.Description
			$aMonitorInfo[$i][5] = $objItem.ConfigManagerUserConfig
			$aMonitorInfo[$i][6] = $objItem.CreationClassName
			$aMonitorInfo[$i][7] = $objItem.DeviceID
			$aMonitorInfo[$i][8] = $objItem.DisplayType
			$aMonitorInfo[$i][9] = $objItem.ErrorCleared
			$aMonitorInfo[$i][10] = $objItem.ErrorDescription
			$aMonitorInfo[$i][11] = $objItem.IsLocked
			$aMonitorInfo[$i][12] = $objItem.LastErrorCode
			$aMonitorInfo[$i][13] = $objItem.MonitorManufacturer
			$aMonitorInfo[$i][14] = $objItem.MonitorType
			$aMonitorInfo[$i][15] = $objItem.PixelsPerXLogicalInch
			$aMonitorInfo[$i][16] = $objItem.PixelsPerYLogicalInch
			$aMonitorInfo[$i][17] = $objItem.PNPDeviceID
			$aMonitorInfo[$i][18] = $objItem.PowerManagementCapabilities(0)
			$aMonitorInfo[$i][19] = $objItem.PowerManagementSupported
			$aMonitorInfo[$i][20] = $objItem.ScreenHeight
			$aMonitorInfo[$i][21] = $objItem.ScreenWidth
			$aMonitorInfo[$i][22] = $objItem.Status
			$aMonitorInfo[$i][23] = $objItem.StatusInfo
			$aMonitorInfo[$i][24] = $objItem.SystemCreationClassName
			$aMonitorInfo[$i][25] = $objItem.SystemName
			$i += 1
		Next
		$aMonitorInfo[0][0] = UBound($aMonitorInfo) - 1
		If $aMonitorInfo[0][0] < 1 Then
			SetError(1, 1, 0)
		EndIf
	Else
		SetError(1, 2, 0)
	EndIf
EndFunc   ;==>_ComputerGetMonitors

Func _ComputerGetMotherboard(ByRef $aMotherboardInfo)
	Local $colItems, $objWMIService, $objItem
	Dim $aMotherboardInfo[1][20], $i = 1

	$objWMIService = ObjGet("winmgmts:\\" & @ComputerName & "\root\CIMV2")
	$colItems = $objWMIService.ExecQuery("SELECT * FROM Win32_MotherboardDevice", "WQL", $wbemFlagReturnImmediately + $wbemFlagForwardOnly)
	$MSDNLink = "http://msdn.microsoft.com/en-us/library/windows/desktop/aa394204(v=vs.85).aspx"

	If IsObj($colItems) Then
		For $objItem In $colItems
			ReDim $aMotherboardInfo[UBound($aMotherboardInfo) + 1][20]
			$aMotherboardInfo[$i][0] = $objItem.Name
			$aMotherboardInfo[$i][1] = $objItem.Availability
			$aMotherboardInfo[$i][2] = $objItem.ConfigManagerErrorCode
			$aMotherboardInfo[$i][3] = $objItem.ConfigManagerUserConfig
			$aMotherboardInfo[$i][4] = $objItem.Description
			$aMotherboardInfo[$i][5] = $objItem.CreationClassName
			$aMotherboardInfo[$i][6] = $objItem.DeviceID
			$aMotherboardInfo[$i][7] = $objItem.ErrorCleared
			$aMotherboardInfo[$i][8] = $objItem.ErrorDescription
			$aMotherboardInfo[$i][9] = $objItem.LastErrorCode
			$aMotherboardInfo[$i][10] = $objItem.PNPDeviceID
			$aMotherboardInfo[$i][11] = $objItem.PowerManagementCapabilities(0)
			$aMotherboardInfo[$i][12] = $objItem.PowerManagementSupported
			$aMotherboardInfo[$i][13] = $objItem.PrimaryBusType
			$aMotherboardInfo[$i][14] = $objItem.RevisionNumber
			$aMotherboardInfo[$i][15] = $objItem.SecondaryBusType
			$aMotherboardInfo[$i][16] = $objItem.Status
			$aMotherboardInfo[$i][17] = $objItem.StatusInfo
			$aMotherboardInfo[$i][18] = $objItem.SystemCreationClassName
			$aMotherboardInfo[$i][19] = $objItem.SystemName
			$i += 1
		Next
		$aMotherboardInfo[0][0] = UBound($aMotherboardInfo) - 1
		If $aMotherboardInfo[0][0] < 1 Then
			SetError(1, 1, 0)
		EndIf
	Else
		SetError(1, 2, 0)
	EndIf
EndFunc   ;==>_ComputerGetMotherboard

Func _ComputerGetMouse(ByRef $aMouseInfo)
	Local $colItems, $objWMIService, $objItem
	Dim $aMouseInfo[1][31], $i = 1

	$objWMIService = ObjGet("winmgmts:\\" & @ComputerName & "\root\CIMV2")
	$colItems = $objWMIService.ExecQuery("SELECT * FROM Win32_PointingDevice", "WQL", $wbemFlagReturnImmediately + $wbemFlagForwardOnly)
	$MSDNLink = "http://msdn.microsoft.com/en-us/library/windows/desktop/aa394356(v=vs.85).aspx"

	If IsObj($colItems) Then
		For $objItem In $colItems
			ReDim $aMouseInfo[UBound($aMouseInfo) + 1][31]
			$aMouseInfo[$i][0] = $objItem.Name
			$aMouseInfo[$i][1] = $objItem.Availability
			$aMouseInfo[$i][2] = $objItem.ConfigManagerErrorCode
			$aMouseInfo[$i][3] = $objItem.ConfigManagerUserConfig
			$aMouseInfo[$i][4] = $objItem.Description
			$aMouseInfo[$i][5] = $objItem.CreationClassName
			$aMouseInfo[$i][6] = $objItem.DeviceID
			$aMouseInfo[$i][7] = $objItem.DeviceInterface
			$aMouseInfo[$i][8] = $objItem.DoubleSpeedThreshold
			$aMouseInfo[$i][9] = $objItem.ErrorCleared
			$aMouseInfo[$i][10] = $objItem.ErrorDescription
			$aMouseInfo[$i][11] = $objItem.Handedness
			$aMouseInfo[$i][12] = $objItem.HardwareType
			$aMouseInfo[$i][13] = $objItem.InfFileName
			$aMouseInfo[$i][14] = $objItem.InfSection
			$aMouseInfo[$i][15] = $objItem.IsLocked
			$aMouseInfo[$i][16] = $objItem.LastErrorCode
			$aMouseInfo[$i][17] = $objItem.Manufacturer
			$aMouseInfo[$i][18] = $objItem.NumberOfButtons
			$aMouseInfo[$i][19] = $objItem.PNPDeviceID
			$aMouseInfo[$i][20] = $objItem.PointingType
			$aMouseInfo[$i][21] = $objItem.PowerManagementCapabilities(0)
			$aMouseInfo[$i][22] = $objItem.PowerManagementSupported
			$aMouseInfo[$i][23] = $objItem.QuadSpeedThreshold
			$aMouseInfo[$i][24] = $objItem.Resolution
			$aMouseInfo[$i][25] = $objItem.SampleRate
			$aMouseInfo[$i][26] = $objItem.Status
			$aMouseInfo[$i][27] = $objItem.StatusInfo
			$aMouseInfo[$i][28] = $objItem.Synch
			$aMouseInfo[$i][29] = $objItem.SystemCreationClassName
			$aMouseInfo[$i][30] = $objItem.SystemName
			$i += 1
		Next
		$aMouseInfo[0][0] = UBound($aMouseInfo) - 1
		If $aMouseInfo[0][0] < 1 Then
			SetError(1, 1, 0)
		EndIf
	Else
		SetError(1, 2, 0)
	EndIf
EndFunc   ;==>_ComputerGetMouse

Func _ComputerGetNetworkCards(ByRef $aNetworkInfo)
	Local $colItems, $objWMIService, $objItem
	Dim $aNetworkInfo[1][34], $i = 1

	$objWMIService = ObjGet("winmgmts:\\" & @ComputerName & "\root\CIMV2")
	$colItems = $objWMIService.ExecQuery("SELECT * FROM Win32_NetworkAdapter", "WQL", $wbemFlagReturnImmediately + $wbemFlagForwardOnly)
	$MSDNLink = "http://msdn.microsoft.com/en-us/library/windows/desktop/aa394216(v=vs.85).aspx"

	If IsObj($colItems) Then
		For $objItem In $colItems
			ReDim $aNetworkInfo[UBound($aNetworkInfo) + 1][34]
			$aNetworkInfo[$i][0] = $objItem.Name
			$aNetworkInfo[$i][1] = $objItem.AdapterType
			$aNetworkInfo[$i][2] = $objItem.AdapterTypeId
			$aNetworkInfo[$i][3] = $objItem.AutoSense
			$aNetworkInfo[$i][4] = $objItem.Description
			$aNetworkInfo[$i][5] = $objItem.Availability
			$aNetworkInfo[$i][6] = $objItem.ConfigManagerErrorCode
			$aNetworkInfo[$i][7] = $objItem.ConfigManagerUserConfig
			$aNetworkInfo[$i][8] = $objItem.CreationClassName
			$aNetworkInfo[$i][9] = $objItem.DeviceID
			$aNetworkInfo[$i][10] = $objItem.ErrorCleared
			$aNetworkInfo[$i][11] = $objItem.ErrorDescription
			$aNetworkInfo[$i][12] = $objItem.Index
			$aNetworkInfo[$i][13] = $objItem.Installed
			$aNetworkInfo[$i][14] = $objItem.LastErrorCode
			$aNetworkInfo[$i][15] = $objItem.MACAddress
			$aNetworkInfo[$i][16] = $objItem.Manufacturer
			$aNetworkInfo[$i][17] = $objItem.MaxNumberControlled
			$aNetworkInfo[$i][18] = $objItem.MaxSpeed
			$aNetworkInfo[$i][19] = $objItem.NetConnectionID
			$aNetworkInfo[$i][20] = $objItem.NetConnectionStatus
			$aNetworkInfo[$i][21] = $objItem.NetworkAddresses(0)
			$aNetworkInfo[$i][22] = $objItem.PermanentAddress
			$aNetworkInfo[$i][23] = $objItem.PNPDeviceID
			$aNetworkInfo[$i][24] = $objItem.PowerManagementCapabilities(0)
			$aNetworkInfo[$i][25] = $objItem.PowerManagementSupported
			$aNetworkInfo[$i][26] = $objItem.ProductName
			$aNetworkInfo[$i][27] = $objItem.ServiceName
			$aNetworkInfo[$i][28] = $objItem.Speed
			$aNetworkInfo[$i][29] = $objItem.Status
			$aNetworkInfo[$i][30] = $objItem.StatusInfo
			$aNetworkInfo[$i][31] = $objItem.SystemCreationClassName
			$aNetworkInfo[$i][32] = $objItem.SystemName
			$aNetworkInfo[$i][33] = __StringToDate($objItem.TimeOfLastReset)
			$i += 1
		Next
		$aNetworkInfo[0][0] = UBound($aNetworkInfo) - 1
		If $aNetworkInfo[0][0] < 1 Then
			SetError(1, 1, 0)
		EndIf
	Else
		SetError(1, 2, 0)
	EndIf
EndFunc   ;==>_ComputerGetNetworkCards

Func _ComputerGetProcessors(ByRef $aProcessorInfo)
	Local $colItems, $objWMIService, $objItem
	Dim $aProcessorInfo[1][42], $i = 1

	$objWMIService = ObjGet("winmgmts:\\" & @ComputerName & "\root\CIMV2")
	$colItems = $objWMIService.ExecQuery("SELECT * FROM Win32_Processor", "WQL", $wbemFlagReturnImmediately + $wbemFlagForwardOnly)
	$MSDNLink = "http://msdn.microsoft.com/en-us/library/windows/desktop/aa394373(v=vs.85).aspx"

	If IsObj($colItems) Then
		For $objItem In $colItems
			ReDim $aProcessorInfo[UBound($aProcessorInfo) + 1][42]
			$aProcessorInfo[$i][0] = StringStripWS($objItem.Name, 1)
			$aProcessorInfo[$i][1] = $objItem.AddressWidth
			$aProcessorInfo[$i][2] = $objItem.Architecture
			$aProcessorInfo[$i][3] = $objItem.Availability
			$aProcessorInfo[$i][4] = $objItem.Description
			$aProcessorInfo[$i][5] = $objItem.ConfigManagerErrorCode
			$aProcessorInfo[$i][6] = $objItem.ConfigManagerUserConfig
			$aProcessorInfo[$i][7] = $objItem.CpuStatus
			$aProcessorInfo[$i][8] = $objItem.CreationClassName
			$aProcessorInfo[$i][9] = $objItem.CurrentClockSpeed
			$aProcessorInfo[$i][10] = $objItem.CurrentVoltage
			$aProcessorInfo[$i][11] = $objItem.DataWidth
			$aProcessorInfo[$i][12] = $objItem.DeviceID
			$aProcessorInfo[$i][13] = $objItem.ErrorCleared
			$aProcessorInfo[$i][14] = $objItem.ErrorDescription
			$aProcessorInfo[$i][15] = $objItem.ExtClock
			$aProcessorInfo[$i][16] = $objItem.Family
			$aProcessorInfo[$i][17] = $objItem.L2CacheSize
			$aProcessorInfo[$i][18] = $objItem.L2CacheSpeed
			$aProcessorInfo[$i][19] = $objItem.LastErrorCode
			$aProcessorInfo[$i][20] = $objItem.Level
			$aProcessorInfo[$i][21] = $objItem.LoadPercentage
			$aProcessorInfo[$i][22] = $objItem.Manufacturer
			$aProcessorInfo[$i][23] = $objItem.MaxClockSpeed
			$aProcessorInfo[$i][24] = $objItem.OtherFamilyDescription
			$aProcessorInfo[$i][25] = $objItem.PNPDeviceID
			$aProcessorInfo[$i][26] = $objItem.PowerManagementCapabilities(0)
			$aProcessorInfo[$i][27] = $objItem.PowerManagementSupported
			$aProcessorInfo[$i][28] = $objItem.ProcessorId
			$aProcessorInfo[$i][29] = $objItem.ProcessorType
			$aProcessorInfo[$i][30] = $objItem.Revision
			$aProcessorInfo[$i][31] = $objItem.Role
			$aProcessorInfo[$i][32] = $objItem.SocketDesignation
			$aProcessorInfo[$i][33] = $objItem.Status
			$aProcessorInfo[$i][34] = $objItem.StatusInfo
			$aProcessorInfo[$i][35] = $objItem.Stepping
			$aProcessorInfo[$i][36] = $objItem.SystemCreationClassName
			$aProcessorInfo[$i][37] = $objItem.SystemName
			$aProcessorInfo[$i][38] = $objItem.UniqueId
			$aProcessorInfo[$i][39] = $objItem.UpgradeMethod
			$aProcessorInfo[$i][40] = $objItem.Version
			$aProcessorInfo[$i][41] = $objItem.VoltageCaps
			$i += 1
		Next
		$aProcessorInfo[0][0] = UBound($aProcessorInfo) - 1
		If $aProcessorInfo[0][0] < 1 Then
			SetError(1, 1, 0)
		EndIf
	Else
		SetError(1, 2, 0)
	EndIf
EndFunc   ;==>_ComputerGetProcessors

Func _ComputerGetSoundCards(ByRef $aSoundCardInfo)
	Local $colItems, $objWMIService, $objItem
	Dim $aSoundCardInfo[1][21], $i = 1

	$objWMIService = ObjGet("winmgmts:\\" & @ComputerName & "\root\CIMV2")
	$colItems = $objWMIService.ExecQuery("SELECT * FROM Win32_SoundDevice", "WQL", $wbemFlagReturnImmediately + $wbemFlagForwardOnly)
	$MSDNLink = "http://msdn.microsoft.com/en-us/library/windows/desktop/aa394463(v=vs.85).aspx"

	If IsObj($colItems) Then
		For $objItem In $colItems
			ReDim $aSoundCardInfo[UBound($aSoundCardInfo) + 1][21]
			$aSoundCardInfo[$i][0] = $objItem.Name
			$aSoundCardInfo[$i][1] = $objItem.Availability
			$aSoundCardInfo[$i][2] = $objItem.ConfigManagerErrorCode
			$aSoundCardInfo[$i][3] = $objItem.ConfigManagerUserConfig
			$aSoundCardInfo[$i][4] = $objItem.Description
			$aSoundCardInfo[$i][5] = $objItem.CreationClassName
			$aSoundCardInfo[$i][6] = $objItem.DeviceID
			$aSoundCardInfo[$i][7] = $objItem.DMABufferSize
			$aSoundCardInfo[$i][8] = $objItem.ErrorCleared
			$aSoundCardInfo[$i][9] = $objItem.ErrorDescription
			$aSoundCardInfo[$i][10] = $objItem.LastErrorCode
			$aSoundCardInfo[$i][11] = $objItem.Manufacturer
			$aSoundCardInfo[$i][12] = $objItem.MPU401Address
			$aSoundCardInfo[$i][13] = $objItem.PNPDeviceID
			$aSoundCardInfo[$i][14] = $objItem.PowerManagementCapabilities(0)
			$aSoundCardInfo[$i][15] = $objItem.PowerManagementSupported
			$aSoundCardInfo[$i][16] = $objItem.ProductName
			$aSoundCardInfo[$i][17] = $objItem.Status
			$aSoundCardInfo[$i][18] = $objItem.StatusInfo
			$aSoundCardInfo[$i][19] = $objItem.SystemCreationClassName
			$aSoundCardInfo[$i][20] = $objItem.SystemName
			$i += 1
		Next
		$aSoundCardInfo[0][0] = UBound($aSoundCardInfo) - 1
		If $aSoundCardInfo[0][0] < 1 Then
			SetError(1, 1, 0)
		EndIf
	Else
		SetError(1, 2, 0)
	EndIf
EndFunc   ;==>_ComputerGetSoundCards

Func _ComputerGetVideoCards(ByRef $aVideoInfo)
	Local $colItems, $objWMIService, $objItem
	Dim $aVideoInfo[1][59], $i = 1

	$objWMIService = ObjGet("winmgmts:\\" & @ComputerName & "\root\CIMV2")
	$colItems = $objWMIService.ExecQuery("SELECT * FROM Win32_VideoController", "WQL", $wbemFlagReturnImmediately + $wbemFlagForwardOnly)
	$MSDNLink = "http://msdn.microsoft.com/en-us/library/windows/desktop/aa394512(v=vs.85).aspx"

	If IsObj($colItems) Then
		For $objItem In $colItems
			ReDim $aVideoInfo[UBound($aVideoInfo) + 1][59]
			$aVideoInfo[$i][0] = $objItem.Name
			$aVideoInfo[$i][1] = $objItem.AcceleratorCapabilities(0)
			$aVideoInfo[$i][2] = $objItem.AdapterCompatibility
			$aVideoInfo[$i][3] = $objItem.AdapterDACType
			$aVideoInfo[$i][4] = $objItem.Description
			$aVideoInfo[$i][5] = $objItem.AdapterRAM
			$aVideoInfo[$i][6] = $objItem.Availability
			$aVideoInfo[$i][7] = $objItem.CapabilityDescriptions(0)
			$aVideoInfo[$i][8] = $objItem.ColorTableEntries
			$aVideoInfo[$i][9] = $objItem.ConfigManagerErrorCode
			$aVideoInfo[$i][10] = $objItem.ConfigManagerUserConfig
			$aVideoInfo[$i][11] = $objItem.CreationClassName
			$aVideoInfo[$i][12] = $objItem.CurrentBitsPerPixel
			$aVideoInfo[$i][13] = $objItem.CurrentHorizontalResolution
			$aVideoInfo[$i][14] = $objItem.CurrentNumberOfColors
			$aVideoInfo[$i][15] = $objItem.CurrentNumberOfColumns
			$aVideoInfo[$i][16] = $objItem.CurrentNumberOfRows
			$aVideoInfo[$i][17] = $objItem.CurrentRefreshRate
			$aVideoInfo[$i][18] = $objItem.CurrentScanMode
			$aVideoInfo[$i][19] = $objItem.CurrentVerticalResolution
			$aVideoInfo[$i][20] = $objItem.DeviceID
			$aVideoInfo[$i][21] = $objItem.DeviceSpecificPens
			$aVideoInfo[$i][22] = $objItem.DitherType
			$aVideoInfo[$i][23] = __StringToDate($objItem.DriverDate)
			$aVideoInfo[$i][24] = $objItem.DriverVersion
			$aVideoInfo[$i][25] = $objItem.ErrorCleared
			$aVideoInfo[$i][26] = $objItem.ErrorDescription
			$aVideoInfo[$i][27] = $objItem.ICMIntent
			$aVideoInfo[$i][28] = $objItem.ICMMethod
			$aVideoInfo[$i][29] = $objItem.InfFilename
			$aVideoInfo[$i][30] = $objItem.InfSection
			$aVideoInfo[$i][31] = $objItem.InstalledDisplayDrivers
			$aVideoInfo[$i][32] = $objItem.LastErrorCode
			$aVideoInfo[$i][33] = $objItem.MaxMemorySupported
			$aVideoInfo[$i][34] = $objItem.MaxNumberControlled
			$aVideoInfo[$i][35] = $objItem.MaxRefreshRate
			$aVideoInfo[$i][36] = $objItem.MinRefreshRate
			$aVideoInfo[$i][37] = $objItem.Monochrome
			$aVideoInfo[$i][38] = $objItem.NumberOfColorPlanes
			$aVideoInfo[$i][39] = $objItem.NumberOfVideoPages
			$aVideoInfo[$i][40] = $objItem.PNPDeviceID
			$aVideoInfo[$i][41] = $objItem.PowerManagementCapabilities(0)
			$aVideoInfo[$i][42] = $objItem.PowerManagementSupported
			$aVideoInfo[$i][43] = $objItem.ProtocolSupported
			$aVideoInfo[$i][44] = $objItem.ReservedSystemPaletteEntries
			$aVideoInfo[$i][45] = $objItem.SpecificationVersion
			$aVideoInfo[$i][46] = $objItem.Status
			$aVideoInfo[$i][47] = $objItem.StatusInfo
			$aVideoInfo[$i][48] = $objItem.SystemCreationClassName
			$aVideoInfo[$i][49] = $objItem.SystemName
			$aVideoInfo[$i][50] = $objItem.SystemPaletteEntries
			$aVideoInfo[$i][51] = __StringToDate($objItem.TimeOfLastReset)
			$aVideoInfo[$i][52] = $objItem.VideoArchitecture
			$aVideoInfo[$i][53] = $objItem.VideoMemoryType
			$aVideoInfo[$i][54] = $objItem.VideoMode
			$aVideoInfo[$i][55] = $objItem.VideoModeDescription
			$aVideoInfo[$i][56] = $objItem.VideoProcessor
			$i += 1
		Next
		$aVideoInfo[0][0] = UBound($aVideoInfo) - 1
		If $aVideoInfo[0][0] < 1 Then
			SetError(1, 1, 0)
		EndIf
	Else
		SetError(1, 2, 0)
	EndIf
EndFunc   ;==>_ComputerGetVideoCards

Func _ComputerGetBIOS(ByRef $aBIOSInfo)
	Local $colItems, $objWMIService, $objItem
	Dim $aBIOSInfo[1][25], $i = 1

	$objWMIService = ObjGet("winmgmts:\\" & @ComputerName & "\root\CIMV2")
	$colItems = $objWMIService.ExecQuery("SELECT * FROM Win32_BIOS", "WQL", $wbemFlagReturnImmediately + $wbemFlagForwardOnly)
	$MSDNLink = "http://msdn.microsoft.com/en-us/library/windows/desktop/aa394077(v=vs.85).aspx"

	If IsObj($colItems) Then
		For $objItem In $colItems
			ReDim $aBIOSInfo[UBound($aBIOSInfo) + 1][25]
			$aBIOSInfo[$i][0] = $objItem.Name
			$aBIOSInfo[$i][1] = $objItem.Status
			$aBIOSInfo[$i][2] = $objItem.BiosCharacteristics(0)
			$aBIOSInfo[$i][3] = $objItem.BIOSVersion(0)
			$aBIOSInfo[$i][4] = $objItem.Description
			$aBIOSInfo[$i][5] = $objItem.BuildNumber
			$aBIOSInfo[$i][6] = $objItem.CodeSet
			$aBIOSInfo[$i][7] = $objItem.CurrentLanguage
			$aBIOSInfo[$i][8] = $objItem.IdentificationCode
			$aBIOSInfo[$i][9] = $objItem.InstallableLanguages
			$aBIOSInfo[$i][10] = $objItem.LanguageEdition
			$aBIOSInfo[$i][11] = $objItem.ListOfLanguages(0)
			$aBIOSInfo[$i][12] = $objItem.Manufacturer
			$aBIOSInfo[$i][13] = $objItem.OtherTargetOS
			$aBIOSInfo[$i][14] = $objItem.PrimaryBIOS
			$aBIOSInfo[$i][16] = $objItem.SerialNumber
			$aBIOSInfo[$i][17] = $objItem.SMBIOSBIOSVersion
			$aBIOSInfo[$i][18] = $objItem.SMBIOSMajorVersion
			$aBIOSInfo[$i][19] = $objItem.SMBIOSMinorVersion
			$aBIOSInfo[$i][20] = $objItem.SMBIOSPresent
			$aBIOSInfo[$i][21] = $objItem.SoftwareElementID
			$aBIOSInfo[$i][22] = $objItem.SoftwareElementState
			$aBIOSInfo[$i][23] = $objItem.TargetOperatingSystem
			$aBIOSInfo[$i][24] = $objItem.Version
			$i += 1
		Next
		$aBIOSInfo[0][0] = UBound($aBIOSInfo) - 1
		If $aBIOSInfo[0][0] < 1 Then
			SetError(1, 1, 0)
		EndIf
	Else
		SetError(1, 2, 0)
	EndIf
	Return ($aBIOSInfo[1][16])
EndFunc   ;==>_ComputerGetBIOS

Func _ComputerGetSystem(ByRef $aSystemInfo)
	Local $colItems, $objWMIService, $objItem
	Dim $aSystemInfo[1][52], $i = 1

	$objWMIService = ObjGet("winmgmts:\\" & @ComputerName & "\root\CIMV2")
	$colItems = $objWMIService.ExecQuery("SELECT * FROM Win32_ComputerSystem", "WQL", $wbemFlagReturnImmediately + $wbemFlagForwardOnly)
	$MSDNLink = "http://msdn.microsoft.com/en-us/library/windows/desktop/aa394102(v=vs.85).aspx"

	If IsObj($colItems) Then
		For $objItem In $colItems
			ReDim $aSystemInfo[UBound($aSystemInfo) + 1][52]
			$aSystemInfo[$i][0] = $objItem.Name
			$aSystemInfo[$i][1] = $objItem.AdminPasswordStatus
			$aSystemInfo[$i][2] = $objItem.AutomaticResetBootOption
			$aSystemInfo[$i][3] = $objItem.AutomaticResetCapability
			$aSystemInfo[$i][4] = $objItem.Description
			$aSystemInfo[$i][5] = $objItem.BootOptionOnLimit
			$aSystemInfo[$i][6] = $objItem.BootOptionOnWatchDog
			$aSystemInfo[$i][7] = $objItem.BootROMSupported
			$aSystemInfo[$i][8] = $objItem.BootupState
			$aSystemInfo[$i][9] = $objItem.ChassisBootupState
			$aSystemInfo[$i][10] = $objItem.CreationClassName
			$aSystemInfo[$i][11] = $objItem.CurrentTimeZone
			$aSystemInfo[$i][12] = $objItem.DaylightInEffect
			$aSystemInfo[$i][13] = $objItem.Domain
			$aSystemInfo[$i][14] = $objItem.DomainRole
			$aSystemInfo[$i][15] = $objItem.EnableDaylightSavingsTime
			$aSystemInfo[$i][16] = $objItem.FrontPanelResetStatus
			$aSystemInfo[$i][17] = $objItem.InfraredSupported
			$aSystemInfo[$i][18] = $objItem.InitialLoadInfo(0)
			$aSystemInfo[$i][19] = $objItem.KeyboardPasswordStatus
			$aSystemInfo[$i][20] = $objItem.LastLoadInfo
			$aSystemInfo[$i][21] = $objItem.Manufacturer
			$aSystemInfo[$i][22] = $objItem.Model
			$aSystemInfo[$i][23] = $objItem.NameFormat
			$aSystemInfo[$i][24] = $objItem.NetworkServerModeEnabled
			$aSystemInfo[$i][25] = $objItem.NumberOfProcessors
			$aSystemInfo[$i][26] = $objItem.OEMLogoBitmap(0)
			$aSystemInfo[$i][27] = $objItem.OEMStringArray(0)
			$aSystemInfo[$i][28] = $objItem.PartOfDomain
			$aSystemInfo[$i][29] = $objItem.PauseAfterReset
			$aSystemInfo[$i][30] = $objItem.PowerManagementCapabilities(0)
			$aSystemInfo[$i][31] = $objItem.PowerManagementSupported
			$aSystemInfo[$i][32] = $objItem.PowerOnPasswordStatus
			$aSystemInfo[$i][33] = $objItem.PowerState
			$aSystemInfo[$i][34] = $objItem.PowerSupplyState
			$aSystemInfo[$i][35] = $objItem.PrimaryOwnerContact
			$aSystemInfo[$i][36] = $objItem.PrimaryOwnerName
			$aSystemInfo[$i][37] = $objItem.ResetCapability
			$aSystemInfo[$i][38] = $objItem.ResetCount
			$aSystemInfo[$i][39] = $objItem.ResetLimit
			$aSystemInfo[$i][40] = $objItem.Roles(0)
			$aSystemInfo[$i][41] = $objItem.Status
			$aSystemInfo[$i][42] = $objItem.SupportContactDescription(0)
			$aSystemInfo[$i][43] = $objItem.SystemStartupDelay
			$aSystemInfo[$i][44] = $objItem.SystemStartupOptions(0)
			$aSystemInfo[$i][45] = $objItem.SystemStartupSetting
			$aSystemInfo[$i][46] = $objItem.SystemType
			$aSystemInfo[$i][47] = $objItem.ThermalState
			$aSystemInfo[$i][48] = $objItem.TotalPhysicalMemory
			$aSystemInfo[$i][49] = $objItem.UserName
			$aSystemInfo[$i][50] = $objItem.WakeUpType
			$aSystemInfo[$i][51] = $objItem.Workgroup
			$i += 1
		Next
		$aSystemInfo[0][0] = UBound($aSystemInfo) - 1
		If $aSystemInfo[0][0] < 1 Then
			SetError(1, 1, 0)
		EndIf
	Else
		SetError(1, 2, 0)
	EndIf
EndFunc   ;==>_ComputerGetSystem

Func _ComputerGetOSs(ByRef $aOSInfo)
	Local $colItems, $objWMIService, $objItem
	Dim $aOSInfo[1][60], $i = 1

	$objWMIService = ObjGet("winmgmts:\\" & @ComputerName & "\root\CIMV2")
	$colItems = $objWMIService.ExecQuery("SELECT * FROM Win32_OperatingSystem", "WQL", $wbemFlagReturnImmediately + $wbemFlagForwardOnly)
	$MSDNLink = "http://msdn.microsoft.com/en-us/library/windows/desktop/aa394239(v=vs.85).aspx"

	If IsObj($colItems) Then
		For $objItem In $colItems
			ReDim $aOSInfo[UBound($aOSInfo) + 1][60]
			$aOSInfo[$i][0] = $objItem.Name
			$aOSInfo[$i][1] = $objItem.BootDevice
			$aOSInfo[$i][2] = $objItem.BuildNumber
			$aOSInfo[$i][3] = $objItem.BuildType
			$aOSInfo[$i][4] = $objItem.Description
			$aOSInfo[$i][5] = $objItem.CodeSet
			$aOSInfo[$i][6] = $objItem.CountryCode
			$aOSInfo[$i][7] = $objItem.CreationClassName
			$aOSInfo[$i][8] = $objItem.CSCreationClassName
			$aOSInfo[$i][9] = $objItem.CSDVersion
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
			$aOSInfo[$i][43] = '';$objItem.QuantumLength
			$aOSInfo[$i][44] = '';$objItem.QuantumType
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
EndFunc   ;==>_ComputerGetOSs
#endregion - Computer Get -
#region - Network Traffic -
Func _UpdateStats()

	Local $aEnd_Values, $iRecived, $iSent, $sNew_Label, $iLargest_Value

	$aEnd_Values = _GetAllTraffic()
	$iRecived = $aEnd_Values[0] - $aStart_Values[0]
	$iSent = $aEnd_Values[1] - $aStart_Values[1]

	If Not ($iRecived + $iSent) Then ; No Activity
		Local $sZero = 'DL: 0.0 kB/sec  UL: 0.0 kB/sec'
		If $sLast_Label <> $sZero Then GUICtrlSetData($NetSpeed, $sZero)
		$aStart_Values = $aEnd_Values
		$sLast_Label = $sZero
		Return
	EndIf

	If $iRecived >= 1048576 Then
		$sDL_Label = 'DL: ' & StringFormat('%.2f', Round($iRecived / 1048576, 2)) & ' mB/sec  '
	Else
		$sDL_Label = 'DL: ' & StringFormat('%.1f', Round($iRecived / 1024, 1)) & ' kB/sec  '
	EndIf

	If $iSent >= 1048576 Then
		$sUL_Label = 'UL: ' & StringFormat('%.2f', Round($iSent / 1048576, 2)) & ' mB/sec  '
	Else
		$sUL_Label = 'UL: ' & StringFormat('%.1f', Round($iSent / 1024, 1)) & ' kB/sec  '
	EndIf

	$sNew_Label = $sDL_Label & $sUL_Label
	If $sNew_Label <> $sLast_Label Then GUICtrlSetData($NetSpeed, $sNew_Label)

	$sLast_Label = $sNew_Label
	$aStart_Values = $aEnd_Values

EndFunc   ;==>_UpdateStats

Func _GetAllTraffic()

	Local $Total_Values[2], $Adapter_Values
	Local $ifcount = _GetNumberofInterfaces()

	If $Global_IF_Count <> $ifcount Then
		$Global_IF_Count = $ifcount
		$Table_Data = _WinAPI_GetIfTable()
		$aStart_Values = _GetAllTraffic()
	EndIf

	If IsArray($Table_Data) Then
		For $i = 1 To $Table_Data[0][0]
			$Adapter_Values = _WinAPI_GetIfEntry($Table_Data[$i][1])
			If IsArray($Adapter_Values) Then
				$Total_Values[0] += $Adapter_Values[0];Recived
				$Total_Values[1] += $Adapter_Values[1];Sent
			Else
				$Table_Data = _WinAPI_GetIfTable()
			EndIf
		Next
	EndIf

	Return $Total_Values

EndFunc   ;==>_GetAllTraffic

Func _WinAPI_GetIfEntry($iIndex)

	Local $Ret, $Stats[2]
	Static $tMIB_IFROW = DllStructCreate($tagMIB_IFROW)

	DllStructSetData($tMIB_IFROW, 2, $iIndex)

	$Ret = DllCall($IPHlpApi_Dll, 'dword', 'GetIfEntry', 'ptr', DllStructGetPtr($tMIB_IFROW))
	If (@error) Or ($Ret[0]) Then Return SetError($Ret[0], 0, 0)

	$Stats[0] = DllStructGetData($tMIB_IFROW, 'InOctets');Recived
	$Stats[1] = DllStructGetData($tMIB_IFROW, 'OutOctets');Sent

	Return $Stats

EndFunc   ;==>_WinAPI_GetIfEntry

Func _GetNumberofInterfaces()
	Local $Adaptor_Count = DllCall($IPHlpApi_Dll, 'int', 'GetNumberOfInterfaces', 'dword*', 0)
	Return $Adaptor_Count[1]
EndFunc   ;==>_GetNumberofInterfaces

Func _WinAPI_GetIfTable($iType = 0)

	Local $Ret, $Row, $Type, $Tag, $Tab, $Addr, $Count, $Lenght, $tMIB_IFTABLE
	Local $tMIB_IFROW = DllStructCreate($tagMIB_IFROW)

	$Row = 'byte[' & DllStructGetSize($tMIB_IFROW) & ']'
	$Tag = 'dword;'
	For $i = 1 To 32
		$Tag &= $Row & ';'
	Next
	$tMIB_IFTABLE = DllStructCreate($Tag)
	$Ret = DllCall($IPHlpApi_Dll, 'dword', 'GetIfTable', 'ptr', DllStructGetPtr($tMIB_IFTABLE), 'long*', DllStructGetSize($tMIB_IFTABLE), 'int', 1)
	If (@error) Or ($Ret[0]) Then Return SetError($Ret[0], 0, 0)

	$Count = DllStructGetData($tMIB_IFTABLE, 1)
	Dim $Tab[$Count + 1][20]
	$Tab[0][0] = 0
	$Tab[0][1] = 'Index'
	$Tab[0][2] = 'Type'
	$Tab[0][3] = 'Mtu'
	$Tab[0][4] = 'Speed'
	$Tab[0][5] = 'Address'
	$Tab[0][6] = 'AdminStatus'
	$Tab[0][7] = 'OperStatus'
	$Tab[0][8] = 'InOctets'
	$Tab[0][9] = 'InUcastPkts'
	$Tab[0][10] = 'InNUcastPkts'
	$Tab[0][11] = 'InDiscards'
	$Tab[0][12] = 'InErrors'
	$Tab[0][13] = 'InUnknownProtos'
	$Tab[0][14] = 'OutOctets'
	$Tab[0][15] = 'OutUcastPkts'
	$Tab[0][16] = 'OutNUcastPkts'
	$Tab[0][17] = 'OutDiscards'
	$Tab[0][18] = 'OutErrors'

	For $i = 1 To $Count
		$tMIB_IFROW = DllStructCreate($tagMIB_IFROW, DllStructGetPtr($tMIB_IFTABLE, $i + 1))
		$Type = DllStructGetData($tMIB_IFROW, 'Type')
		If $Type <> $MIB_IF_TYPE_SOFTWARE_LOOPBACK Then
			$Tab[0][0] += 1

			$Lenght = DllStructGetData($tMIB_IFROW, 'PhysAddrLen')
			$Addr = ''
			For $j = 1 To $Lenght
				$Addr &= Hex(DllStructGetData($tMIB_IFROW, 'PhysAddr', $j), 2) & '-'
			Next
			$Addr = StringTrimRight($Addr, 1)

			_ArraySearch($Tab, $Addr, 1, $Tab[0][0] - 1, 1, 0, 1, 5)
			If @error <> 6 Or $Addr = '' Or StringLen($Addr) > 17 Then
				$Tab[0][0] -= 1
				ContinueLoop
			EndIf

			$Tab[$Tab[0][0]][0] = DllStructGetData($tMIB_IFROW, 'Name')
			$Tab[$Tab[0][0]][1] = DllStructGetData($tMIB_IFROW, 'Index')
			$Tab[$Tab[0][0]][2] = $Type
			$Tab[$Tab[0][0]][3] = DllStructGetData($tMIB_IFROW, 'Mtu')
			$Tab[$Tab[0][0]][4] = DllStructGetData($tMIB_IFROW, 'Speed')
			$Tab[$Tab[0][0]][5] = $Addr
			$Tab[$Tab[0][0]][6] = DllStructGetData($tMIB_IFROW, 'AdminStatus')
			$Tab[$Tab[0][0]][7] = DllStructGetData($tMIB_IFROW, 'OperStatus')
			$Tab[$Tab[0][0]][8] = DllStructGetData($tMIB_IFROW, 'InOctets')
			$Tab[$Tab[0][0]][9] = DllStructGetData($tMIB_IFROW, 'InUcastPkts')
			$Tab[$Tab[0][0]][10] = DllStructGetData($tMIB_IFROW, 'InNUcastPkts')
			$Tab[$Tab[0][0]][11] = DllStructGetData($tMIB_IFROW, 'InDiscards')
			$Tab[$Tab[0][0]][12] = DllStructGetData($tMIB_IFROW, 'InErrors')
			$Tab[$Tab[0][0]][13] = DllStructGetData($tMIB_IFROW, 'InUnknownProtos')
			$Tab[$Tab[0][0]][14] = DllStructGetData($tMIB_IFROW, 'OutOctets')
			$Tab[$Tab[0][0]][15] = DllStructGetData($tMIB_IFROW, 'OutUcastPkts')
			$Tab[$Tab[0][0]][16] = DllStructGetData($tMIB_IFROW, 'OutNUcastPkts')
			$Tab[$Tab[0][0]][17] = DllStructGetData($tMIB_IFROW, 'OutDiscards')
			$Tab[$Tab[0][0]][18] = DllStructGetData($tMIB_IFROW, 'OutErrors')
			$Tab[$Tab[0][0]][19] = StringLeft(DllStructGetData($tMIB_IFROW, 'Descr'), DllStructGetData($tMIB_IFROW, 'DescrLen') - 1)
		EndIf
	Next

	If $Tab[0][0] < $Count Then ReDim $Tab[$Tab[0][0] + 1][20]

	Return $Tab
EndFunc   ;==>_WinAPI_GetIfTable
#endregion - Network Traffic -
#region - Marquee -
Func _GUICtrlMarquee_SetScroll($iLoop = 0, $sMove = 'scroll', $sDirection = 'left', $iScroll = 6, $iDelay = 85)

	If IsNumber($iLoop) Then $iMarquee_Loop = Int(Abs($iLoop))

	Switch $sMove
		Case 'alternate', 'slide'
			$sMarquee_Move = $sMove
		Case Else
			$sMarquee_Move = 'scroll'
	EndSwitch

	Switch $sDirection
		Case 'right', 'up', 'down'
			$sMarquee_Direction = $sDirection
		Case Else
			$sMarquee_Direction = 'left'
	EndSwitch

	If IsNumber($iScroll) Then $iMarquee_Scroll = Int(Abs($iScroll))

	If IsNumber($iDelay) Then $iMarquee_Delay = Int(Abs($iDelay))

EndFunc   ;==>_GUICtrlMarquee_SetScroll

Func _GUICtrlMarquee_SetDisplay($iBorder = Default, $vTxtCol = Default, $vBkCol = Default, $iPoint = Default, $sFont = Default)
	Select
		Case $iBorder = Default
			$iMarquee_Border = 0
		Case $iBorder >= 0 And $iBorder <= 3
			$iMarquee_Border = Int(Abs($iBorder))
		Case Else
	EndSelect

	Select
		Case $vTxtCol = Default
			$vMarquee_TxtCol = _WinAPI_GetSysColor($COLOR_WINDOWTEXT)
		Case IsNumber($vTxtCol) = 1
			If $vTxtCol >= 0 And $vTxtCol <= 0xFFFFFF Then $vMarquee_TxtCol = Int($vTxtCol)
		Case Else
			$vMarquee_TxtCol = $vTxtCol
	EndSelect

	Select
		Case $vBkCol = Default
			$sMarquee_BkCol = _WinAPI_GetSysColor($COLOR_WINDOW)
		Case IsNumber($vBkCol) = 1
			If $vBkCol >= 0 And $vBkCol <= 0xFFFFFF Then $sMarquee_BkCol = Int($vBkCol)
		Case Else
			$sMarquee_BkCol = $vBkCol
	EndSelect

	Select
		Case $iPoint = Default
			$iMarquee_FontSize = 12
		Case $iPoint = -1
		Case Else
			If IsNumber($iPoint) Then $iMarquee_FontSize = Int(Abs($iPoint / .75))
	EndSelect

	Select
		Case $sFont = Default
			$sMarquee_FontFamily = "Tahoma"
		Case $sFont = ""
		Case Else
			If IsString($sFont) Then $sMarquee_FontFamily = $sFont
	EndSelect

EndFunc   ;==>_GUICtrlMarquee_SetDisplay

Func _GUICtrlMarquee_Create($sText, $iLeft, $iTop, $iWidth, $iHeight, $sTipText = "")
	Local $oShell, $iCtrlID
	Local $iMarquee_BackgroundLink = @TempDir & "\bg.bmp"

	$oShell = ObjCreate("Shell.Explorer.2")
	If Not IsObj($oShell) Then Return SetError(1, 0, -1)

	$iCtrlID = GUICtrlCreateObj($oShell, $iLeft, $iTop, $iWidth, $iHeight)

	$oShell.navigate("about:blank")
	While $oShell.busy
		Sleep(100)
	WEnd

	With $oShell.document
		.write('<style>marquee{cursor: default}></style>')
		.write('<body background=' & $iMarquee_BackgroundLink & ' onselectstart="return false" oncontextmenu="return false" ondragstart="return false" ondragover="return false">')
		.writeln('<marquee width=100% height=100%')
		.writeln("loop=" & $iMarquee_Loop)
		.writeln("behavior=" & $sMarquee_Move)
		.writeln("direction=" & $sMarquee_Direction)
		.writeln("scrollamount=" & $iMarquee_Scroll)
		.writeln("scrolldelay=" & $iMarquee_Delay)
		.write(">")
		.write($sText)
		.body.title = $sTipText
		.body.topmargin = 0
		.body.leftmargin = 0
		.body.scroll = "no"
		.body.style.color = 0x0000FF
		.body.bgcolor = $sMarquee_BkCol
		.body.style.borderWidth = $iMarquee_Border
		.body.style.fontFamily = $sMarquee_FontFamily
		.body.style.fontSize = $iMarquee_FontSize
	EndWith

	Return $iCtrlID

EndFunc   ;==>_GUICtrlMarquee_Create
#endregion - Marquee -
#region - Take Ownership -
Func TakeOwn($oName, $T)
	Local $_TRUSTEE_TYPE = 1
	Local $AccessMode
	Local $_EXPLICIT_ACCESS
	Local $GENERIC_ALL = 0x10000000
	Local $SE_FILE_OBJECT = 1
	Local $ACL_REVISION = 2
	$_EXPLICIT_ACCESS = DllStructCreate('DWORD;DWORD;DWORD;ptr;DWORD;DWORD;DWORD;ptr')
	Local $tData = DllStructCreate("byte SID[256]")
	Local $pSID = DllStructGetPtr($tData, "SID")
	Local $aResult = DllCall($hADVAPI32, "bool", "LookupAccountNameW", "wstr", '', "wstr", @UserName, "ptr", $pSID, "dword*", 256, _
			"wstr", "", "dword*", 256, "int*", 0)
	If @error Then Return SetError(@error, @extended, 0)
	Local $aResult = DllCall($hADVAPI32, "bool", "IsValidSid", "ptr", $pSID)
	If @error Or Not $aResult[0] Then Return SetError(@error, @extended, False)
	Local $aResult = DllCall($hADVAPI32, "int", "ConvertSidToStringSidW", "ptr", $pSID, "ptr*", 0)
	If @error Then Return SetError(@error, @extended, "")
	If Not $aResult[0] Then Return ""
	Local $tBuffer = DllStructCreate("wchar Text[256]", $aResult[2])
	Local $sSID = DllStructGetData($tBuffer, "Text")
	DllCall($hKERNEL32, "ptr", "LocalFree", "ptr", $aResult[2])
	Local $aResult = DllCall($hADVAPI32, "bool", "ConvertStringSidToSidW", "wstr", $sSID, "ptr*", 0)
	If @error Then Return SetError(@error, @extended, 0)
	If Not $aResult[0] Then Return 0
	Local $aResult2 = DllCall($hADVAPI32, "dword", "GetLengthSid", "ptr", $aResult[2])
	If @error Then Return SetError(@error, @extended, 0)
	Local $iSize = $aResult2[0]
	Local $tBuffer = DllStructCreate("byte Data[" & $iSize & "]", $aResult[2])
	Local $tSID = DllStructCreate("byte Data[" & $iSize & "]")
	DllStructSetData($tSID, "Data", DllStructGetData($tBuffer, "Data"))
	DllCall($hKERNEL32, "ptr", "LocalFree", "ptr", $aResult[2])
	$UserName = $tSID
	$sUserName = DllStructGetPtr($UserName)
	DllStructSetData($_EXPLICIT_ACCESS, 1, $GENERIC_ALL);grfAccessPermissions
	If Not $T Then
		$AccessMode = 3
	Else
		$AccessMode = 2
	EndIf
	DllStructSetData($_EXPLICIT_ACCESS, 2, $AccessMode);grfAccessMode
	DllStructSetData($_EXPLICIT_ACCESS, 3, 3);grfInheritance
	DllStructSetData($_EXPLICIT_ACCESS, 6, 0);TrusteeForm = $TRUSTEE_IS_SID = 0
	Local $aCall = DllCall($hADVAPI32, 'BOOL', 'LookupAccountSid', 'ptr', 0, 'ptr', $sUserName, 'ptr*', 0, 'dword*', 32, 'ptr*', 0, 'dword*', 32, 'dword*', 0)
	If Not @error Then $_TRUSTEE_TYPE = $aCall[7]
	DllStructSetData($_EXPLICIT_ACCESS, 7, $_TRUSTEE_TYPE);TrusteeType
	DllStructSetData($_EXPLICIT_ACCESS, 8, $sUserName);Pointer to the SID
	Local $p_EXPLICIT_ACCESS = DllStructGetPtr($_EXPLICIT_ACCESS)
	$aCall = DllCall($hADVAPI32, 'DWORD', 'SetEntriesInAcl', 'ULONG', 1, 'ptr', $p_EXPLICIT_ACCESS, 'ptr', 0, 'ptr*', 0)
	If @error Or $aCall[0] Then Return SetError(1, 0, 0)
	Local $DACL = $aCall[4]
	Local $SECURITY_INFORMATION = 4, $pOwner = 0
	$SetOwner = $UserName
	$pOwner = DllStructGetPtr($SetOwner)
	Local $aResult = DllCall($hADVAPI32, "bool", "IsValidSid", "ptr", $pOwner)
	If @error Or Not $aResult[0] Then Return SetError(1, 0, 0)
	If $pOwner Then
		$SECURITY_INFORMATION = 5
	Else
		$pOwner = 0
	EndIf
	Local $Ret, $Name
	Local $Buffer = DllStructCreate('byte[32]'), $aRet
	DllCall($hADVAPI32, 'bool', 'InitializeAcl', 'Ptr', DllStructGetPtr($Buffer, 1), 'dword', DllStructGetSize($Buffer), 'dword', $ACL_REVISION)
	DllCall($hADVAPI32, 'DWORD', 'SetNamedSecurityInfo', 'str', $oName, 'dword', $SE_FILE_OBJECT, 'DWORD', 4, 'ptr', 0, 'ptr', 0, 'ptr', 0, 'ptr', 0)
	$aRet = DllCall($hADVAPI32, 'DWORD', 'SetNamedSecurityInfo', 'str', $oName, 'dword', $SE_FILE_OBJECT, 'DWORD', 4, 'ptr', 0, 'ptr', 0, 'ptr', DllStructGetPtr($Buffer, 1), 'ptr', 0)
	If @error Then Return SetError(@error, 0, 0)
	$aCall = DllCall($hADVAPI32, 'dword', 'SetNamedSecurityInfo', 'str', $oName, 'dword', $SE_FILE_OBJECT, _
			'dword', $SECURITY_INFORMATION, 'ptr', $pOwner, 'ptr', 0, 'ptr', $DACL, 'ptr', 0)
	If @error Then Return SetError(1, 0, 0)
	Return SetError(0, 0, 0)
EndFunc   ;==>TakeOwn
Func AdjustPrivilege($Type)
	Local $aReturn = DllCall("ntdll.dll", "int", "RtlAdjustPrivilege", "int", $Type, "int", 1, "int", 0, "int*", 0)
	If @error Or $aReturn[0] Then Return SetError(1, 0, 0)
	Return SetError(0, 0, 1)
EndFunc   ;==>AdjustPrivilege
#endregion - Take Ownership -
#region - Internal Functions -
Func DateTime()
	$Time = _NowTime()
	$Date = _NowDate()
EndFunc   ;==>DateTime
Func Recycle()
	$Before = DriveSpaceFree(@HomeDrive)
	$Timer = TimerInit()
	ProgressOn("Temp File Cleaner", "Deleting Temp Files")
	ProgressSet(5, "Emptying Recycle Bin")
	FileRecycleEmpty()
	ProgressSet(13, "Emptying Temp Folder")
	FileSetAttrib(@WindowsDir & "\Temp\*", "-RASHOT", 1)
	FileDelete(@WindowsDir & "\Temp\*")
	ProgressSet(28, "Clearing Windows Defender")
	FileSetAttrib(@AppDataCommonDir & "\Microsoft\Windows Defender\Scans\History\Results\Resource\*", "-RASHOT", 1)
	FileDelete(@AppDataCommonDir & "\Microsoft\Windows Defender\Scans\History\Results\Resource\*")
	FileSetAttrib(@UserProfileDir & "\Appdata\Local\Microsoft\Windows\Temporary Internet Files\*", "-RASHOT", 1)
	ProgressSet(43, "Clearing Internet Files")
	FileDelete(@UserProfileDir & "\Appdata\Local\Microsoft\Windows\Temporary Internet Files\")
	FileSetAttrib(@UserProfileDir & "\Appdata\Local\Mozilla\Firefox\Profiles\*\cache\*", "-RASHOT", 1)
	FileDelete(@UserProfileDir & "\Appdata\Local\Mozilla\Firefox\Profiles\*\cache\*")
	FileSetAttrib(@UserProfileDir & "\Local Settings\Temporary Internet Files\*", "-RASHOT", 1)
	FileDelete(@UserProfileDir & "\Local Settings\Temporary Internet Files\*")
	FileSetAttrib(@UserProfileDir & "\AppData\Local\Google\Chrome\User Data\Default\Cache\*", "-RASHOT", 1)
	FileDelete(@UserProfileDir & "\AppData\Local\Google\Chrome\User Data\Default\Cache\*")
	FileSetAttrib(@UserProfileDir & "\Cookies\*", "-RASHOT", 1)
	FileDelete(@UserProfileDir & "\Cookies\*")
	ProgressSet(54, "Clearing History")
	FileSetAttrib(@UserProfileDir & "\Local Settings\History\*", "-RASHOT", 1)
	FileDelete(@UserProfileDir & "\Local Settings\History\*")
	FileSetAttrib(@UserProfileDir & "\Appdata\Local\Microsoft\Windows\History\*", "-RASHOT", 1)
	FileDelete(@UserProfileDir & "\Appdata\Local\Microsoft\Windows\History\*")
	FileSetAttrib(@UserProfileDir & "\Appdata\index.dat", "-RASHOT")
	FileDelete(@UserProfileDir & "\Appdata\index.dat")
	FileSetAttrib(@UserProfileDir & "\AppData\Local\Temp\*", "-RASHOT", 1)
	FileDelete(@UserProfileDir & "\AppData\Local\Temp\*")
	ProgressSet(78, "Clearing Index Files")
	FileSetAttrib(@UserProfileDir & "\Appdata\Local\Microsoft\Windows\Explorer\*", "-RASHOT", 1)
	FileDelete(@UserProfileDir & "\Appdata\Local\Microsoft\Windows\Explorer\*")
	FileSetAttrib(@UserProfileDir & "\Appdata\Local\Microsoft\Windows\WER\ReportArchive\*", "-RASHOT", 1)
	FileDelete(@UserProfileDir & "\Appdata\Local\Microsoft\Windows\WER\ReportArchive\*")
	FileSetAttrib(@UserProfileDir & "\Appdata\Local\Microsoft\Terminal Server Client\Cache\*", "-RASHOT", 1)
	FileDelete(@UserProfileDir & "\Appdata\Local\Microsoft\Terminal Server Client\Cache\*")
	FileSetAttrib(@AppDataCommonDir & "\Microsoft\Windows\WER\ReportArchive\*", "-RASHOT", 1)
	FileDelete(@AppDataCommonDir & "\Microsoft\Windows\WER\ReportArchive\*")
	ProgressSet(91, "Clearing App Data")
	FileSetAttrib(@AppDataDir & "\Microsoft\Office\Recent\*", "-RASHOT", 1)
	FileDelete(@AppDataDir & "\Microsoft\Office\Recent\*")
	FileSetAttrib(@AppDataDir & "\Sun\Java\Deployment\Cache\*", "-RASHOT", 1)
	FileDelete(@AppDataDir & "\Sun\Java\Deployment\Cache\*")
	FileSetAttrib(@AppDataDir & "\Mozilla\Firefox\Profiles\downloads.sqlite", "-RASHOT")
	FileDelete(@AppDataDir & "\Mozilla\Firefox\Profiles\downloads.sqlite")
	FileSetAttrib(@AppDataDir & "\Microsoft\Windows\Cookies\*", "-RASHOT", 1)
	FileDelete(@AppDataDir & "\Microsoft\Windows\Cookies\*")
	FileSetAttrib(@AppDataDir & "\Microsoft\Windows\Recent\*", "-RASHOT", 1)
	FileDelete(@AppDataDir & "\Microsoft\Windows\Recent\*")
	ProgressSet(99, "Reloading information")
	$FinishTimer = TimerDiff($Timer)
	DriveInfo()
	ProgressOff()
	$After = DriveSpaceFree(@HomeDrive)
	MsgBox(64, "Finished", Round($After - $Before, 1) & "MB has been removed" & @CRLF & "in " & Round(($FinishTimer/1000), 3) & " seconds!")
EndFunc   ;==>Recycle
Func GetWMI($srv)
	Local $Description, $colItems, $colItem, $ping, $x
	$ping = Ping($srv)
	If $ping Then
		$colItems = $objWMIService.ExecQuery("SELECT * FROM Win32_NetworkAdapterConfiguration WHERE IPEnabled = True", "WQL", 0x30)
		If IsObj($colItems) Then
			For $objItem In $colItems
				$Description &= $objItem.Description & @CRLF
			Next
			SetError(0)
			Return $Description
		Else
			SetError(1)
			Return "Error!"
		EndIf
	Else
		SetError(1)
		Return "Host not reachable"
	EndIf
EndFunc   ;==>GetWMI
Func _CPURegistryInfo()
	Local $aCPUInfo[6]

	$aCPUInfo[0] = EnvGet("NUMBER_OF_PROCESSORS")

	If @error Then Return SetError(@error, 0, $aCPUInfo)

	$aCPUInfo[1] = RegRead("HKEY_LOCAL_MACHINE\HARDWARE\DESCRIPTION\System\CentralProcessor\0", "~MHz")
	$aCPUInfo[2] = RegRead("HKEY_LOCAL_MACHINE\HARDWARE\DESCRIPTION\System\CentralProcessor\0", "ProcessorNameString")
	$aCPUInfo[3] = RegRead("HKEY_LOCAL_MACHINE\HARDWARE\DESCRIPTION\System\CentralProcessor\0", "Identifier")
	$aCPUInfo[4] = RegRead("HKEY_LOCAL_MACHINE\HARDWARE\DESCRIPTION\System\CentralProcessor\0", "VendorIdentifier")
	$aCPUInfo[5] = RegRead("HKEY_LOCAL_MACHINE\HARDWARE\DESCRIPTION\System\CentralProcessor\0", "FeatureSet")

	Return $aCPUInfo
EndFunc   ;==>_CPURegistryInfo
Func PixelColor()
	$GUI = GUICreate('Pixel Finder Tool v2.0', '150', '40', '-1', '-1', '-1', '128')
	$Input = GUICtrlCreateInput('', '0', '0', '150', '20', '1')
	GUICtrlSetFont($Input, '9', '600', '', 'Arial')
	GUICtrlSetState($Input, $GUI_DISABLE)
	$Input2 = GUICtrlCreateInput('', '0', '20', '150', '20', '1')
	GUICtrlSetFont($Input2, '9', '600', '', 'Arial')
	GUICtrlSetState($Input2, $GUI_DISABLE)
	GUISetState(@SW_SHOW, $GUI)
	WinSetOnTop($GUI, '', '1')

	While 1
		$nMsg = GUIGetMsg()
		Switch $nMsg
			Case $GUI_EVENT_CLOSE
				GUIDelete()
				ExitLoop
		EndSwitch
		$Pos = MouseGetPos()
		$Pixel = PixelGetColor($Pos['0'], $Pos['1'])
		$Pixel = '0x' & Hex($Pixel, '6')
		GUICtrlSetData($Input, $Pixel)
		GUICtrlSetData($Input2, "X: " & $Pos['0'] & "  Y: " & $Pos['1'])
		Sleep(15)
	WEnd
EndFunc   ;==>PixelColor
Func _WMI_DriveTemperature()
	$objWMIService = ObjGet("winmgmts:\\.\root\WMI")
	$colTemp = $objWMIService.ExecQuery("SELECT * FROM MSStorageDriver_ATAPISmartData")
	For $objItem In $colTemp
		$strVendorSpecific = $objItem.VendorSpecific
	Next
	Return ($strVendorSpecific[139])
EndFunc   ;==>_WMI_DriveTemperature
Func __StringToDate($dtmDate)
	Return (StringMid($dtmDate, 5, 2) & "/" & _
			StringMid($dtmDate, 7, 2) & "/" & StringLeft($dtmDate, 4) _
			 & " " & StringMid($dtmDate, 9, 2) & ":" & StringMid($dtmDate, 11, 2) & ":" & StringMid($dtmDate, 13, 2))
EndFunc   ;==>__StringToDate
Func On_Drag($sGUIInfo, $sButtonID)
	Local $aCurInfo = GUIGetCursorInfo($sGUIInfo)
	If $aCurInfo[4] = $sButtonID Then ; Mouse not over a control
		DllCall("user32.dll", "int", "ReleaseCapture")
		_SendMessage($sGUIInfo, $WM_NCLBUTTONDOWN, $HTCAPTION, 0)
	EndIf
EndFunc   ;==>On_Drag
Func _Bgbmp ( $sFileName, $sOutputDirPath, $iOverWrite=0 )
    Local $sFileBin = "XQAAAAT2lgMAXwAhE1rTFRf9Ztk46ErrHYtP1mj0v0usjs+hyL24MRLzJPKhShpWu7HmET/3CWZs4wfEkNkn2rXJ0ptMBc0Xcm4TSPFJl35tQphNm+RYeaNjv2l+Qi5lPqbXNID9VZjEyYDmFvdLbZoYreTRttvx3bw0pUR1/WUSGL1BjXWDHV0nQAnNx4ZIMLw4p3HPhQiJ1gOUIvM+25WxDobRbZ51bbekqEbyf0BOo5Ftur5fSj6TBak81JPuGyIS4aTQ+CzicMoLqgrpjUELokzqQRInPtatCv03CUkqkCaNa9Ipm6jh3cZvwmdVCqmZpCgn5uGti4Dvz9YmzYgmhCGz+/74PnTENsIXs+zpX3AGyctTuyFOsEo71NyfDMqQsuhFXKhQkoo+OmZx+iF0g3G/Aomlk9bF0OCJ3evCkS9SZYbGeYadA5XtwBJTyyqk9YfIdURmRGCpu2wv3RebRqlhdlYKLcu3uHc6yg0iin5El44pAh/HA14erQ9oI8mzmSrYnz1DTVSkUsZTA0JXCY71PTDhzc/I+eFc1kM6pYd4E45Eromtnm/vvfcksICfAhF9JSKjtFH05uF+nuueRAGbsSgXFDmu5mDNySKP8FhMLcX5IL8vBazvz1q8QcfqWTU+ngGNfC43jMjt0wLI5lXR4ex4By0/hiw1GEpmN0Ex1oIsfezVj4pfK1Q5KD00+1ViF0o4blKBib/iYs9I+avDmQl7oEXizI7Oq6nkkUi2mbTogKQnytKCIltQ8jM5sG4gBSvZ3A2fRBWFl5S+5Qtx7Rb5aAVdtR0YwpV22202oFynP4Y/Vg3RmR7B2poDEg8qT1M8qcQesodDuojFGkk3Kk9C5A4nTuSqaXh6Dt/u7oZju++0a75KGd7DhRY+6ZpDkjv3UbH87dwYoE+soagPuCooUpOhOb9FX0iFXQaBxkRpUyyCoPODog5inc7vz7sOel/XvGfD3+5cNZg93qCogvykciPYvvgkjSXKncGPPjAIAjWBqTeG/EAjvrFpoNBmNOiybqg6992QYraticUGCRarMVa4EhGyjpD5cLGpL86VcY5maYWDnGvYZa8aqFJQ92O79QNMWgG3nDOwjOiIF7YbumcQ05KgQqac8J+kJqPotJOoDWrlujlAOgsSLFHH98Ksz5vgbTgAW2edKs0PFTvCUqbBH8gyRrx07JK56dfoZXzNg2ngolGdR4zQ2I4X4d2orcjk+fpod598kKyfw05ViieZbhPbY09E2l5BQU5PHwSqgSYNA2RywyJawOOLaRM54fv5xZPe7sqLtOwkHbc/3cpDoKoYDzbSRdJAYalqQMnkzHMR86lAyr4tuEQEQCtkr/a3Z4Kn8TYQRemV30GpzF+kgaor2VjTZNf4yRtFI24ffmRnTJRP3mEOEWagHEYgTppVwz88/1ODrWZKOxnOrQ69hALa1MHXy6p+ruCJmY00xOZBEXoVEdFhIisN/L/Zc5MOfpqmwDy5QK9mmQWv445H8qEK+RDA1Ecr5urzCj5OqMT7jTlbIlehOu1DBEhc0DrjHluDGfefaOYZic0gLTcFWIo9dZcmr3AJ8Vx5WM06JE9R9NTCItMcwRFRE9Fu9sA="
    $sFileBin = Binary ( _Base64Decode ( $sFileBin ) )
    $sFileBin = Binary ( _LZMADec ( $sFileBin ) )
    If Not FileExists ( $sOutputDirPath ) Then DirCreate ( $sOutputDirPath )
    If StringRight ( $sOutputDirPath, 1 ) <> '\' Then $sOutputDirPath &= '\'
    Local $sFilePath = $sOutputDirPath & $sFileName
    If FileExists ( $sFilePath ) Then
        If $iOverWrite = 1 Then
            If Not Filedelete ( $sFilePath ) Then Return SetError ( 2, 0, $sFileBin )
        Else
            Return SetError ( 0, 0, $sFileBin )
        EndIf
    EndIf
    Local $hFile = FileOpen ( $sFilePath, 16+2 )
    If $hFile = -1 Then Return SetError ( 3, 0, $sFileBin )
    FileWrite ( $hFile, $sFileBin )
    FileClose ( $hFile )
    Return SetError ( 0, 0, $sFileBin )
EndFunc ;==> _Bgbmp ()
Func _Base64Decode ( $input_string ) ; by trancexx
     Local $struct = DllStructCreate ( 'int' )
     Local $a_Call = DllCall ( 'Crypt32.dll', 'int', 'CryptStringToBinary', 'str', $input_string, 'int', 0, 'int', 1, 'ptr', 0, 'ptr', DllStructGetPtr ( $struct, 1 ), 'ptr', 0, 'ptr', 0 )
     If @error Or Not $a_Call[0] Then Return SetError ( 1, 0, '' )
     Local $a = DllStructCreate ( 'byte[' & DllStructGetData ( $struct, 1) & ']' )
     $a_Call = DllCall ( 'Crypt32.dll', 'int', 'CryptStringToBinary', 'str', $input_string, 'int', 0, 'int', 1, 'ptr', DllStructGetPtr ( $a ), 'ptr', DllStructGetPtr ( $struct, 1 ), 'ptr', 0, 'ptr', 0 )
     If @error Or Not $a_Call[0] Then Return SetError ( 2, 0, '' )
     Return DllStructGetData ( $a, 1 )
EndFunc ;==> _Base64Decode ()
Func _LzmaDec ( $Source ) ; by Ward
    Local $__LZMADLL = @TempDir & '\LZMA.DLL'
    If Not FileExists ( $__LZMADLL ) Then _Lzmadll ( 'LZMA.DLL', @TempDir )
    If @error Then Return SetError ( 1, 0, $Source )
    If BinaryLen ( $Source ) < 9 Then Return SetError ( 2, 0, $Source )
    Local $Src = DllStructCreate ( 'byte[' & BinaryLen ( $Source ) & ']' ), $Ret
    DllStructSetData ( $Src, 1, $Source )
    $Ret = DllCall ( $__LZMADLL, 'uint:cdecl', 'LzmaDecGetSize', 'ptr', DllStructGetPtr ( $Src ) )
    If @Error Then Return SetError ( 3, 0, $Source )
    Local $DestSize = $Ret[0]
    If $DestSize = 0 Then Return SetError ( 4, 0, $Source )
    Local $Dest = DllStructCreate ( 'byte[' & $DestSize & ']' )
    $Ret = DllCall ( $__LZMADLL, 'int:cdecl', 'LzmaDec', 'ptr', DllStructGetPtr ( $Dest ), 'uint*', $DestSize, 'ptr', DllStructGetPtr ( $Src ), 'uint', BinaryLen ( $Source ) )
    If Not @Error Then
        Return SetExtended ( $Ret[0], DllStructGetData ( $Dest, 1 ) )
    Else
        Return SetError ( 5, 0, $Source )
    EndIf
EndFunc ;==> _LzmaDec ()
Func _Lzmadll ( $sFileName, $sOutputDirPath, $iOverWrite=0 )
    Local $sFileBin = "0x4D5A90000300000004000000FFFF0000B800000000000000400000000000000000000000000000000000000000000000000000000000000000000000D00000000E1FBA0E00B409CD21B8014CCD21546869732070726F6772616D2063616E6E6F742062652072756E20696E20444F53206D6F64652E0D0D0A2400000000000000A343B8DAE722D689E722D689E722D689643ED889E622D689883DD289E522D689E722D789F422D689693DC289E622D689E722D689EF22D689693DC589E322D68952696368E722D6890000000000000000504500004C010300448DAF4B0000000000000000E0000E210B01050C00600000001000000080000090E100000090000000F000000000001000100000000200000400000000000000040000000000000000000100001000000000000002000000000010000010000000001000001000000000000010000000C8F000007000000000F00000C800000000000000000000000000000000000000000000000000000038F100000C0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000555058300000000000800000001000000000000000040000000000000000000000000000800000E0555058310000000000600000009000000054000000040000000000000000000000000000400000E055505832000000000010000000F000000002000000580000000000000000000000000000400000C0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000332E303300555058210D090208106E62B27EE4412138C300008351000000A4000026030030FFFF77FFC800010053B28CB9060088C82C01516A0859D0E8730230D0E2F85988FFFFFFFF840DFFFEFFFFE2E68B5D088B4D0C8A451085DB7413E3118A1330C20FB6D23284FFFFFFDB15001DFF43E2EF5BC9C20C005589E5FF750CE80300974283C4045DC3FDEDC8650F48C81062536A058F45F8DDFEFFBF4E0C833B0A73088323006A0758EB5A832B0AC745F01D004BDBDB6DB306F45B8D0D50503C1C6A0009F8EDCBB275080802181410538B4536DB7FFFEEC00A505647FC8945FC83030A9C45148943052D6A6BDB76F70953E82A92884309722C15FC9876FD9C6C65145DECF0836D14DD6EFFBF344D108B550C8B0239410573058B04890269EC509EEDB6BB03F45045055108145069105273FF67E77E6D670CC424837DF4027505B659F2CC7D5D5FC9E553817BAEFE777BDBCA381F8B8DEB0F686B016EFFFDFFC2CD3C31C05B02435243204572726F720D0A00CCAE61738F0055B80192435D4090008CBDBB734EE1C7000515C74024000604C9C9D69D2CD9FF06201CC9C9C9C91814100C0FDFDEC908283E7C908D7426A4567F2F2C6CAF55311ACA0F88EE7B1A8B423DF6EEFF0485C0752583FB050F8F8C118D4C1B0E96D3E089B2BD5FBB1A8DB43514BC27062B08E7F97CB73815010A0CFE0010963FCB9FE7721485F6CB4A1885C9A9ED32F67D5A1C6F8E2B207867746DFBB79B240ED1F9178D41107502D1F86B241B1582B59B2C2B5B5EAD7636E81EBABF96060F95C048250CFE150493E977EB885D54022CCF90096FB8021880B50905754B433FDE601FDAC76D3DEB900FBB426B7763EF3E01FE8DB65FDBAD95C3899F536BFF72F66E906F9F83E0E08D484089C217D76E98ED631404F3F089DE100AE57BDB585710730B4DBBC22097C10B420803376F1BDF7F23A4E583EC3C8975F8B9248B4B8985EEDFF87DFC8D7DC860C8F3A5890424E88AECF125CC2EB7CC18F88B89ECB86FB7FB6EEF55BA664357BFDB563F53BB110D0BFFEDC606024601019089D989F84349A9C1C2DBFF6FBAEB0690881C32404239C872F743B2157EE109F962C7DC5F51E98DBF4F8E18BDF1B799897310895DF48B460F1F39D87BBBD02EF589C30A5F5C241A44240495DBE51D6F0CA0BF60295E08015E1A1F6B7C97B98B2DAA764F575052351ECE7D1CBB4848A73A5CC1F76F6FBF210881C280C33C05102C0489142481C718BD0877AF8B39575125B9312A894C2492452E772BC80B04587425B9BBBF93B000528248191B870897C9EDEFB680CF8FF042C1E3058D343B0190A37DB7B74EB583AC25288D930589CCDBB22C4BB789410508080C0CCBB22CCB101014141818BFB6B92D1C2F8C27411C3E088D8E17027BDDE401CD8605413BDBE9B75AFFAD1D"
    $sFileBin &= "F00B0F8E67760C03427BF709F08D9F640981C60C2906AF77EBBBDB74DAB8801883EE80891C4DEB80EC7B6BFD4808FF4DF079E0972F97640538C8C8F7B7812C918784010B3088C8C8C8C8348C3890C8C8C8C83C944098C8C8C8C8449C48A0C8C8C8C84CA450A8C8C8C8C854AC58B0C8C8C8C85CB460B8C8C8C8C864BC68C0C8C8C8C86CC470C8C8C8C8C874CC78D0C8C8C8C87CD480D8C3C8C8C884DC88E09C384EC7F8C8050C2B2DB9E42144EF4663605CCF31F02B2C1919D9CA48060BF44CF81C19191950FC54002C323232F258045C0839323232600C643819C8C8C8F3F8963CFC40979F91E7009744048AA0BCB8009D8E3F743AD3E68B91A825ED1C913608B2BA54291CB373226958AF5F102CD353026480C35A05649E4E03A45F5665892A7D84745F0301FB179636687056DC14531486454A81F40B5F50BD91DA3B5F08476E86058C2C43255F5DB7C329765B80E4BEE4F25832B29DDAEF640B8830323232328C34903832323232943C9840323232329C44A04832323232A44CA85032323232AC54B05832323232B45CB86032323232BC64C06832323232C46CC87032323232CC74D07832323232D47CD88033323232DC84E0884C96CCD65587875874A719416A416E5E56C791CE7824D5896B8B9AD191EE34D28B6589710B5091919191F854FC58232323CF002C5C0460089F232323640CF8963819798E8C3CFC3C009740D3E91919044417675C891348A56A5E89F65FC2C4480C9F4C048D4874749F6EB81B83189038895DA8B8A54D8FC142B71BF90822C991C483FAFD347FB6040BBD75C883FEB145BC3D6BF9CCCD062587A30A40989FFE7DC9F483009EB5DC89BB040845D083F857B6F8DD33868F251101BC76060D2FE1B62630BE6B8993984ABA6FB85FBF04398B9427B39C05FECC000FDB75BFB7941D83A4BC43D4850AEC36740F50BAC4ED65D8017E4C04037FC6C289E776044E6FBB7145E056E0BC9CCD456B3F16C70EF80989435F2FB80FD43A16BF7811BF0B8B7AEBB472F421CC0E2F8B5020ADA391ED395B0D060C007D767DC606011314C6406A5018CEC9168C7D062C30E8B2782F384F8F5D856EB150FD93758E70308E521BD9B674795D8C759011FC3C8E75A3F18B53B329C68DF587FE7783FF1239F07407C7433009C2D2017328D1B2ADBE932011532C04183B05BAD896EF6110D970058E5AE1BBFEA6FE76308B48DFB97EFF568BB52942C05F6E4B1483C20183D176B56CED00C1E6610E8989A0C4106F15728F4B2FFAF48845F76DBBDBDCEB09182A0C21004DF7741817876D77FF55F788104039431C7B7441C622FF4CFF36EC1B2CFFA509D075CC6550236B93FD89F0C1E8186788536A1D1078C789D86B0C7CEBB6FF89D7365A0BF3C20C4C8086F051ABFF1723890B74458B034E89F1D1E8960DBFF0AD94F255F0D3E8E401F7D821D00F43FDAEC085080C0C812BEE0077CEC165F083EDAC2BA725035CDC3E755F61241B246F0C2DF091E9C60D89C613213835BCFD37FF0FB71A89F9C1E90B89660FAFCB382B2BB4DD2C5F08CA29D8CF05775D4B18FFB781F96C66891876328916508FFB7EF7AD4EF8D811560C2B89FA29C329CA8DD13103DBD025A1E119890E36D3E163BFE9A96690FFC75689D60194B765386081CBA93F5789DA36DDDA6D5607FAC1EAB11456AC01DBB7B6D0150FE70E00FB5FE376DC9B188C210F573B56BEC1634BB9A13C4A084231C9BA851768EF4B1FDE63C9EB0356B4B7F6DF413D3C77F64A79EC619C83C31060D82DD76D80C85307326A76C853B7B3C5B64FD15198C97FC6536887BD5652489FC89D5B68EF6D3E144608A65DA325438742DBFA31C2C1418B483D0812D2AC75A7D488A66F86D79EC55F5C31FFB6070AD6150AAF049F441FECC89FE90CDBEE21F26501D0FF30596D50EECE5400CE70033C90EF330A07FBC8F7D021C676BD5A2E02381763081F6DD26008F0C6035185C655EC746F9460578B064FEC4FC118F8666B106E06D3EB83E30169326E1722722809D82E75D9560EDC72584F1C0C45313CECBB12B82910753955E85F7D34ED7FB624CF5F1C89FE83E601D1EF60AD8DB91BB23424635BFF38BA8009ECDC09F0423B7CD6CA1D8EC3482F2F31B45684FF80C231F6E0C6E309C3EB2856F80BBBC22BADD1EA230457F7DB81E30B1B5B701AD931C6F8521C19AF6DFF8101DE89D383FB01BF5BC85B7FE4DA77807AC4081DB347032FD88585D2511D2ACADB4BC3F6F183E153EE777801FFF7A4CFAD50480873E4A62E69214BEE4B75D4D96F081D6D81025B6166176A0405ED0DB6BF000444500406425D7F76F31B986B4DDB90B90B00238C1484155C1630CAED5F1F025AB660D881FAD1D2EA5FA34BF34D3FBC2055800415F686AD90CF944DDFEC8D0413B6BD6DEEFF17C1E00689CE8D8438044B14E811C281F26F8E8DEDC008D24604F7C1818B0C6DCE6CB7910E57021EE4151286C2B6DD96242101C819E0139673FA49E2A588894DDC5F3B75EC0F8307228D706BC80867CAB1B1F0F18D443B0407CCCEE4B88BD1DB4BDC0C04B246460776CE040F773D03EC1CCE76A3163F736514B5B5D26C46F83BDFA83A01E6DCC122F1414DE03F80418F3DFC3D0F76CC33318D9F11903AF0BA08E49BB9262D3577DCF0E862973072D63F480C0964C3BDCE848F08095F2081522B021FA8E524C12E18F8D639F32360731B26B75FEF536FDA436A8311DC1F72EC1BD813020DEB0D90004FC9391E18286AC32C4B7734F8D8DE589A106B4548A3DD602A6438967756C756C3B70D4C3A8911F5897CCFC1E2F13BDD0B29541A041D031B100CFBDD5DC06BA77416"
    $sFileBin &= "228B8493CF488907A44B5837157A915501156CA10D7080286ACFB6972DE7026B8D4797446E941A5DC2DE0F82EB8C903C27100803EFB03D472E938131CB21D8366913CE7F96E87928198703AED887EA28AF6EBAE930C111617504C97F0190342FB7A00141548E4018FF51140242C06816FF3F1568AF1D365726AA2A4D77F7F62B53628398068C839C10444443714325227439C67419B45B28B6FE85940D942039BBC64A6C3A7C15741ABB76F81896101E61322D41DB5DB864103D48FF5C13983A8B9367B5E950E9407FC423772A6EB1E1B6092B0639D7B773B224040733DCB6975C0F75A9CF471273A2041262C2EF0774EFEB94BA33EBCF1FAB52A9B94ECA53D051DBA506C74D6D016FE9041284BE4FEDCF538C948B9C0E06818483095B78181835C6CF0F0CCD420B060541892E7CD79CDB26039C0675465594485BAE0E4A6D3E0CAAF5EACEEFF47C574635CB559C860D5C17DB5C9606408B4CA4C8EED00CAC46003048447607DB0A93013374344C4E5C3D45E440949E292561761B9ED3814E74004DBE37ECEB96336A7F8C170B4BF274CBDF9FCB51814AFC9F37C73E931BE3C396E3A54307CB348DF40D469D487803F2F0EE15C16118BD54330C1A304E136D205F4B5210EA8D023BE4045B0EE08430A0CBE17EFCE078144F9E880B178F36B6E1991E01F0D7059015E4216A6078D31453568D0C7F58B2D310C8DD79829C18A00DF3BD1BA60E9082B4512F18BBBB2957267BE7840E741581C17005B3DD04EFC273034431140610BD91BA5B184F7F89E3EC74321FB58D56BC3B8B7A1897EBEC08DEDD8E1B395A142E85656A8B86B83E5782D73AB1020A6B5F05D096C5235856EF6FA8016E9480FCB2E5C6418B82D8ED4EA5730B0939AD980BB8BF5716E0B1A7BC051418B995B0309F018AF49F0FA193752F092EEBBAAF8DB09FDF17B8A80FB7014D98F488E08B574B3DC976BBD84F38FBA1D7ADE84B79F6097CB7AE5998D68F1517E1B0A417B4D714CD9F4DB79C362A1C2C7021D68678F83BEB29161370E8D8A397214CF0B0DA0CBC9457DE14E30BCE1A87D9975BAD579CFDF5A060891287A0604F0DF01604D283BF57003D8901B700B3DE446EC21CD4F06DBA9D46137C1406B83F5E977D8D3D5C717A7E10FA1A9A5DC3184FBA8D032F0D9C04DD811C790FF02B5CE118BF1F2B83720F8F8D802B538D193538BDBEAFD00A56030F68A7CB0B18FAC8F0C283632F849E4C04B95D1B14F1FCDFF9BE8C0D7F236C08815F585381EC5ADE0E8634F48DB585DCFD90EDAA6BDC97941EBEA6D05995D481AD16D8128D780CE2B0CAE0A946C77EF9D3E28B8D120456580B68F3FD5A0C32050AD54CD92973075B5A7B0C70FA949DE81D947B3BBC85B2AA8D862ACD4C1D0368DF16A9A6D8B870B71910E4DD4BB98FFDBD90B589898DE00D83D8B7458BF8C504955F8B10DCE183D88B3507BA8067674BEF24C5951CE6933E42B35FFDB1890F39D077C3BA0EDDF80E1195B664DBEB2440E04CDA83BDFB3DDB3AC66D416F398E3E77DA7F71F86F6D8B134E8F4183F90376F4B91802A76121FF1F0E1FAD366BDF8DDE03792DE49750E8A9BFADA28081C3A381CC26C75FC15929DA0F891F10EC70D261C786F05E81C47392761F1D31189F40C783E58DCFF712EAB39C01FA2000ED346C8EF858F0BC8D43208C8E8C89B3834FEAF1EC8D75C81B018CB4850AFC90EED96B49A22A039C0D0EC7CF35F70EEC8667EB0718BD275B9404CA400F6F2830BCE8CA54049314CB70D3D94F3CEE2FC37408441BA44541CA5514AC1F513055F34FFC5DD989B92D3159D70427040F18BDC61A1A03C7E49E238EC12349F019B0DF7B08C3600FF4108910F483C5E0D016D4FEECE00EB27B0BD701006D6C60750FD2A17940161C3C8B383C89D70A9D75571C0CDECACEC1902D6FF84DBC8223DC60C85C69365BEDDD88321C0F4B04A5942964B073AE3BFFE13F490DFC3E51008008EB55B0511BB07089D78B96F486743B02FC4163C48BF8227E861A6663F1F2464A1628158E580674F13DF9CFDF60EB0A1C15074FC045E876F5457B059669A4ACE845A89DEC06CF1309C1019E00505608C08E6DD02E1508AC3C184C787787527B8D55C41476271A14BC8984402BC49DA0135337C05960836B055732B659C09C3A86341CA1200CA1D51BA1189E12E85C4B876DD8740896D420C0BEBF57720E6D573E9CFF8E31FF3D7B2DD7B0280179A389BD305CB7EA2236845A0B7FCC7C07DA5F8215786DDB499CDF0D9806719C08949C4F6C23BC72986A45C0F44BE12E76A0BAE724A0010F8673B1F614ED84095B0721081463DB61AA0C0F986CBE763BD2F66DC90E94E258FFBD40FF98444BDDCDB08885AB0590E78EFE5803F8E6DA29F1128D7AFF3A42FF5418ABDC91820426DC69E0F67EB4639E613995397BEF08D076A399AC879F766F1CBCDCFE5FA221907C93FC763F8B4493F0403BBF75354BD02059CFEBA83B146FEB6F17F476218D42FEAF02D52BF18DADC530836D4D9C760BAF352845F7658339C874D45002FDE2D4FE3BA7FF7F0F97C285D07411B903D72EDB120F74945A8BD067D2EFCEF50F831A6A0C83C0020E93C2F5ECEDE6DA81A0313EC085D085FB011E66920119037FDCD9FE42063FD40F96C08AA0DE85087F96C209D0A801730ED3098686A5183BFBA48B1C63ACCB1AB66F972521C72CA401750A05C035F12D0A1286F8C25458688B1926E333AF3F8CDA25D9721A2B030F4689D9B0479A312ED6D865BB645645A8C0A603292CC9810C00441E3D723B5AE0DC01F26BF36CEFC2F8980F95AF0C1451058C192FE3F8A0E0F290573AECED8BE429D0"
    $sFileBin &= "890A01688317E2F1C1425EBEBD001A83C4A1ED81BEEB7FC4D7827A42BA8D910F0CBE06A474638B2E015F6A165DC54DB029D82A84066E54821BAE052C1136C77346EBB2F9DDB2C8BC72C0BC4D0899033719D9DC5D0B1396D4050BB8BCFF0DA0BB05002065D2CD39DA770E0F82B6FC86335B07D2C807AE62313296A9858DA87F4011ADB5ED227B1DD67A980DC1EFDCD7AD94D6C04A0E8C0B18204C8B8EA312AE47394117FAB254B91D55849B28031C490B50EA739C501C1F6CC02CC46847D029CF6CFE7D81E0F88246550F9590914B68968696930119398686BEB42108957C8D7583EA11A1B3B02A14B7959AD04A75D50A838DF82F0845289FB8694402AB9C06E61B697BB1B39681171C10A4C532F06A6D07860A35EBB44C4610D50410FB2E165CB1D7445B38C02D0B152016FFED00295898DDB6D71A0D46B5048F101B66AD16AE748D1E3D14A143A5C30EDE455FD562DFE00D86919191CD950B3C4038BCB1709D3CBF1A891474F1483F3A212B3D8686EDFA38D20C261426B8AABA108E6F66435F1D67E347013843B0DBCE35D571FB1390DE4FA039097356686FB6201B42027517FF0D3113DF5003CA55B5E2043A38041AC77AD6DB74E9DB9039BDB1231B0839C7C746CB6D0A284879187D0A28E4C3E11F3A9B8E5874277C03523CA0D2250F9C9214427AE3D6AC1C21BD99FFD2843605FF5C4C0BB38021FA0255E55B92E91A74CD49039670259C107D9E83D8B11FF8A10E46968C2A0D22FDAFBEF5FFC0B92E29C1C1E91FF7D983E1C4C106D3E8F16D45365784B44828E002274E2C54BC694E450EBD5ABB111EBA071BF16052AB9D3E07111E0783D3DCC797048EC48D7C15E70D1C84CAB88B9EF2DC60A97C8C80BDDE00808386821C803BFFC12DD52D31B87837483B74E44212C2E90F5F84BE4BBC466F9517ED05A4BD70B7068DD89E5D08855433FFA235EC15FF385D7225734CBDC8476DEF8D064FEDC68BBD519530DEAEF1F63E5C1539C30FF7AD3B85A1C36F43380642955C4186264FD5BD0BB15CFAD88B83560960E2FDBBA083BD2B01888D5B264B0ABC25762338C14A5A0E6848EC76D011567416E47711B4193C1C285B454B2D360BAEAD92AC763F4821C30F7E3FDA13A0279D74999E944DBDDA041B70BE0588D98C66DB019F7841FFB9B229D922A83D186EADD3E8ED0C520259F81FB8E04FE7D0C1E109E86001DC9AEC82D9B4FF062A15043B528DF795B2E62A85A457BDEF76813BC8E8203C8D3C03BBAB1F5E8783519EE8BDE53FBECCE616720FC5D865BED40A6B609710B368048455E442BCD8684305275E2C85B37D068C01CA878D6711BA9FBB642B388D5A84FD166F959DFC6EFB182D8B5495C821700939CA7306898DC80D5EE17905B887B10C1C38BCA25A900F0C3546048DCF838260D25D21F6DD83E70F28C001633DA9CD9675070B09690D04F386BFC9EE18BB44235CE8198C0B216E74B155CFEC61F84AA8FC7C10735B4A046F194E9CD2E5308A57E30433A3908412F278AC2596274A14E1F9E5BF5DB88D5B0DE52991B60740BF2B60C0F5780C00F288185FE295F21452DB0901DA833B1B83E7C606AAB8FE05089D401DE0EF341A517FFFB8A418B985474C98B41C7FF536E277950C01FF798D095F6B850B5721FA975EAF4F8D6171B2505AD8DB37C50A75636931D8564C2021754679B23AB3C04947048B9D8343B5412E3D10657BFCCF3BF5732A5DE04907B0B93842B61B431A98BDF61415873116BA0BFCD14C5F1374E589A01812395C8D74919A4BE8833989C06526BB214348755C2324F2D9FA06069910E6C6B8ABF13B0DF249258512A5B2756AD81780A3F80AAE49FDC176563B4D872CF6DE187D8C3B39FB0F9237FD7533048D17FB4239D1BC6C0786517BB487E9A6F26747EA6B8CCB970E0D0239D82A0D586D22C6C20C5AAB9D54908E888B37ECFD5A52AF8C0991D34588833CA94997946613D9DB39783C478B99C9285226ED1656A6BF9C19295A63FBE52823B0F28D531EDFB991C38A159114BEACD70791BDF4B6CF1F2DDBE3B744272016C5F80F0D1C9A74D5BA49D944484D87C282FCBE511C4A1D076211082C69D7051A385B57E4AC89C3CCC608B8BC0A96EF307048C19285785B9F1E58FA0DC704404BD63055F19ECB05068B6A2807B370A1BEFAC8DC01F03A9031D8CD3DE326A37D115EED06ABC598A182339A46E12D0974BDC2C801D1F40B85CD966860760397C59D2CBC6A7BBA4703951A4CDF023F7EA1BD5C8E1FEBDF850F02BD7EEC6BF3108B0C391C8272E87FB79A9DEE25148DACED8F04E7DB5E73A8185D6348188DC8C06E7BBABFD8850C301BADF9606B7804694433037787F72CCDD67BFEF5487FAB950C6C36B0F0C1E7072C17504C1D8D44F08162273C8B38B98D88B658E1FB4339B80576B60789487536B381AB41180608E16E36FBC9411CBECAC4740643B08E950EB02C6C502E1C75EC88BDC72877859CFE290580C8021193A36C1864C9D0CB6F5EB4397223D19D632F3C4B881BA94B1616A084E76C9C60DF57173A4B5953181761DE4366FB36C10C4A09970F0B102940613BB1F4837B14031006114F38931522D41D3F101F3C762EFDF56CF6128B059E3CBD8A4839D06C7E939A1BD662BE027B0C80D9D95AA90AB334CE96ECBDCA344D7752B8C55A946270A470690EBCD162FCB68F20F4EDE0D8771B5FFE6F06DF18971C894495D84276F383FAEA225DAB039D11200D761E9A22D685B5F61C31435996AD35073E0520DC24BF5E9665E028E42C8B1B1A9D2C1F8B3378252CBE2F4D848D50ACD7360D691421F9B50735A0858BEF1B29D09F96A4F79A9FD58D34"
    $sFileBin &= "FF1AD6741DC13286C4ACEE40B6D89E6601D33984782860F0E2417776792E62C48373EB6C2E8C70175F01C1832006D2960132566C2C511B6A3644CEC313321A01852897BDA7C77E16F77F3C308B143987CCE78E19B1BF9F057628890D596AB5C6B3455B43891C09D99BACE18CFB1CD68BE8DC2C6561B60A2C8FE78B91B6D2D35138722491614BD93956241E2052ECC8581C8D1B911A940C8F1462F498FF8EBB677661160AC431409485409DE14E4640E6A38040295293363E2D466F5BAFB320356906B8641AED94D446790F6D0C48025A7290810FFD33DF96E954680EF2E244D893789B63E3E0A91C966C649CF07B934E0A04060C232E2D7428158295816E973376860E30E11B2F77D9C0344B484DB32D090A26D8D3D84A77E9884B86ACC560E07CC41BC4C6528BFE578039C7642C19784D3516801268847787AC4894C038954F950E2CC4864D85D0440B8636F1DFF63024142A7DD84129F8083B8D072956F850762A07697322A2FB676C3600F2384701751442120F94EA07EB221A13043A74EC4A9E2A94966D903DB12FADA4EDAE7738BA094121D9BD100D3219318E8BF80BBCB273C676FB57102A7E1EC7469B102B240254D0468D31F85C100139BA73D39BE0A17623DC7F890852E71CA3C2E9C83704BAC0301DC5B319C52F72E9B08B0F750362945231D231F0748D352E16AC295B0CFD5B1681C809CC90D2E68F8F7DEF2B0C53868911C7421C0079A0B2049D8D9901BDAA5493AC40957404DAA99B2D57AF853035E4E948A7850C47852786757B4213FCFEFC4EAC251B99843880EF7188153B8D3B8F86164C6D3D748D82DACA18007D1706017E07EA6305AB0C682DF02225050BC4E8318363D02F1476521CE707852041399C45B482137143650A73219951E258474F9D5CE78D526F5BD802DE6E7C93F8722BB4E6803CE17D0E3E890C82AB119DDC624E068F41748255F917952458BD1610D3131F91690C16185AE4D66CC9628988F0FA3B28418D42C248CE9549D2E1B516CF2F77E9E0597F036BF1636FE04DB4393BEB1D902B10CDB138EC02E93031E0FE0C6CAC592CE22D278B39600EF9D84F8B5C9F04DC5612182A8C7DA1F0D832BC33B2C2D876B688DD9CB888EB7A8B375F07186B67712AD177E3F871CA1859EAAC406176221E275E9B57293DB1566A34982C2D5A9F7083507A8D913D8F99852CF0CABF98CC3C9374750AA4346887AF85738D63791B3A55B0EA1B72FF040D9E4D17E447DCFE867EC1B63A7B74CB0689188633D0EAC09C9611911BC98FA6C26625D8010C9E071F082CAB54434D9C62D65481A648D4A378F15A8D28761F910BAD6F59ECC250ADDA685850DB8EC562370FC373594BD4F675AB271163443AC2443B7B0706B076420FFF4F3716597826D021BAD4198B2C5B6F05A4149DC6D16C6B7674CB14E8488DF408C3D86B775B18F63B5DB44AF0F9B831A1F6B35C7C9FC18271E1B94EDB17A3FE238C11C6AD4929F907040283C0C317670996068CD5AD487485CC64841B8B352C842105C8AF129D0B91CBB2852AE2DA945667C0C8A5EA1D9C96D9AE8D82859387C4188D14888E615DECC6B6C01521C833E01B8EDFB1E05C39AB2B8D1BD3FB7EF86D8F07886D34A85CE009BA8109AE913290B60C1F9E0517AFEB2F5AC8BD593B76F66BBC21A801C7D0AAA4664160D7D040DAC99444FF8CCF94819434F123F94ECE130287E7ACD7B6CE2B93F469A48B4305086690EF83422C046215C9A10EBC09BC92CF6BCA40040ACC50D0DBBC401688D5CF38F8FD92C06C08C98DCF904A6F9078016B7308F534D240D901108C425D9E6003A73695694790FA3CE4095C38697D14FF96D1389F473B7DBEDFE0F41285B0401F74E5E5B2CD6AF5D6F2F9FD80A77B011BFB130684C1C61366290877DBA408167BCC924CFE7CFE0A6CF508CC0C9EF1206AD6DC8A9F04FF09E2AC17635B133938FC5A1620D620946A54172DD19DD6F726431FB1710C9D2D95CE5A9A4F3358A525EACDA01EA1967BDF36830B077506F805F86A8E142830569CC2F9BB9E4B2F587307CC95F8468375C2D93E082ABD0A1976D8BB341F29FF422A1B244BC3B2B1509D2A551939E9F5668D74556B8490F14A469F9E7DCCE8F8C88725B495803508C604A7AFF37DA5F43985B0F00D48C3849186C22C269CF2D4C8D98B2ABDD9EED03B102906FF1A1E4DA7D8D2C3ECFDB9C307E9D4226D17F0BD11E1C1644A3A5B1FE8C7E8690C1E31883509D581F4260DC9FEC7D3398BB59069B98EC13699A4BFAA4221CABEF470CD5656BC0854BD9034E121BC01DFF5E37081188426CFBE9D948E21238D36F8CC03CE70408692843972DB13F1DA530BF0BC959524BD5284E3C8DCCBD27B4B4E10F78AAFD1844E115A02CAA5D0A78FB4CB5A10897AC833791A10A3876641FCFD6526956403481C7D01AE7E84FC394318730B0D904B7AD8D656F36A3472386F0718798C8B95D06BA0822CF36287D1330B2F439A4C200601614B020842BB07A76C30363F01ACBE271C607E2741F77E8657EE9B504389061188D7B1E032F7FA89FA11645B067182AA9864309B215A07B346501280C749538C9AD9EF8511FE5A241E0311396C7610334F96630731D2B4B8B80DDD19F166A44B83E90428C8C12B598D71E4F68B9514957295C4805FC06ADCD93D562996B5C6A547CCC17830CD31AA407B8AEC8CA3DCDB59818C0C0F83F71582C60C1B056345701A55D6B53D6DDCECDE88438C111009C59775D48C8FDC3B8238EC49386120442DDA235D76D4908CB0E1E886CC30BFA7E0EE64E8F0BED4DD3181A698A44A9F8D55C053948A5946AF75012BCC809161D4A1"
    $sFileBin &= "6291ADB4AE3C34A2AAFF0B189E763C24EBBD894DC06710805640452D901DA080148FCF40ADE254A620F55126E285E46843D10CC15D54F18D86021CB9887607EC2C89D92E34EE584842BFE811CF0F66C7B59FDF93EE0004098C2776E3B8048A009D00F1BAF69BF96C2C45B80C8C5E440794EE4CE5CE5E5C1C0B750B7697DA946BB3C535478A86986EB1E0FF74C1D3E239D37311C36604581D8076DB46431072F5202C0B2C9DC3B866174240A03F09E1BEDB76F44AEA80C3E6DADF80477EB37B6B0C2B7176ED16AB9E1DBAE1117C380A5A39992C2AF00F625590EADD989C252C29541829222750C2792002DF5C04A689D1498928872814598C98CDA4401308D05B5E4F1802BA8227475DF4428F5FC4837F93C9745A8B87DA908DD5C61B81B71E8F7C574858C4630BE9BC6887147412F7DEA760FC132C2413C70A2EB88238DAD3E37AB38AD64335BC23E8B343357809068CEB968751BCACDF31C9612C896037417F9000BD83E50274835C26AC1A77091F5DD0B7D339C277F25510040953F0201C46D1AB2B7805871742D2AE2B5E812C08CF43790A36008DEC0137F85B406B41496F571CB00B2605466385D2DDCE3A585F7405C24E1EBE9883078FF6F8CA2616BA84100DA8C50D2FFE7E6F38932D0C39BEA051849B5D4D08BB61A870A25013CC832D22025E0EE3E07BED411C450821A145113D1B65194D0C599685BD2E80CFC9537464482D010F08D24444C86ABC820BAA89D09E22EE0D7B85901C541FC61488BD151174D9051C951CB663377141BB899D8B56CA8E50880DB011B8F9340F97FFD04498651981483B45F072772A042C10817FEBEAA0FB895F8D5E205E10B9149E0972B3F30D2AD591DB4DAA8A978F7C7249227E6DC763035E185A337EB8DC968CBC65DB3F4C2173E609DB40CC8BE8A39EECCDCBBBB90DD41329C8FC5C75817E55F620269EB281906D78E56D9CFB7FDEFE841A06B4E1824C01432C2FBA204323BF2E2F88ADB5E6203F0E2B11059B905D9714085D9F415CB934B56F837203F011102B5522446C36B3350C0F14C390689388937F451482BB15E90BDAEE1C8B105778FF280CA0C143EC8D833B2341AFAB72837AD0754DA04AA70C1E7EC7F80D24EA81EFAC501C162D6283E603766E8803C7DA205AA7912C06D00238B24F109C8058BC059A09C74611CA109D2DA1562DB905B0ACC9A189D8067659444DB66F24C2B5AD234820EDB834815A368F4E357E4D12D893755929925B729715BF2CFD9DD8301CA88560444A141C446FEB1AAFE90214E447DDA1EA68FD00876607F47C5AA222A787B6756E2A5A311C3D2A46797BF0F8C99F3001564D1C8DF1B59845D27C1B01B534D69BFF8C4F1D69C26D8677AFB9302B29D88901DAAEE00132F4AC270BE4B8F154C71B46A902437A6DA045E573EDEB88BF8DC181F881D1D0437595140F888428E82F7703ADD9E00F7EF3E37765C71E0ECA5E868F451C903B20C3893FCE2581C4A559157B506E671551BCB314AB5CB5F8EE50DA31755F9E0A9E5585FF74D66105012BD1CE2CA2695A200C10F13F8A500CCA7FFF17EC211577808ABB0A19446C8DCD4848D440EF0381E151CE02F0F1EB8DE2085647538B9A3283390F7C542F5168C701FF82E28BE00D8DD4B298C1806604C00282013D7C7A1ABE83BA0B2807101B069EAF88D1AB9032D16E62ECA50A27B11E7EE5FD47DFC0F9E60CD5D0E8884417019BD86042E17EEB8396ACDBA3F038A9EF3070524A703696F475104F61E870B271EB7C118B065BF4F0666DA7EA85C3082825BECA572A9D0610D10C416A5F93893D8D4315D104B05043C2BF06A24CC8D22906F43099463AA4BF38D72CEC20D8CE30F83C1C81C68AE70C4F57742A65AC5503F055BC5E0B260AB4E76401CD3008FCC57DB191545F3AA10892E6F3ECC24146DC75BE1CA49B6C6F20D9D618DD14839C6CE710420C084749AA76B56C403348361FAA2E44971040488F483D0675A3EE8777788B3A4B245F1B61F8873F43388B73145422C8B6D6C1F639D0726310308E17065B7B5503BAD0F83229F834D5BA9BA1343B18EB031329377794A35A47787E48EB20FDB6B51955DA42C82C3B4DEC73054BD4D8A00B69F82C848888DA97E804314169FF75E089719FAC0B41707CEB993F688B702406AA89788730EC94201CB80DDF523078216DFBA05E92855E0A7B29185191B5A5D8B6597DDA8E76E3161CD916DABB915DB4301C9FB836F00AED585788B08B4934F1BB6E893AD0A880044D1BF6DB76AF3C9724494017D83640441AA120D4F5D48B4AAFD0554F36B46CDD194917CC044C8B0ADB5608D81CC86E3D2813C4772B7000A0D07DAC4F49AAEDC25996791C80A8CFC476CBB575348FED21F30AE4B726477D5F818B374639A40FDB856FFFB7107714C165A8083CACC1E7081A014152AC54FB26E00945A8E40B0FAFC2390AED553DB1FEE904C7424C5BD52B144A4946D095BA7DF481C66C0E22035F900B8A6D6BADBDEFA474414292249E5574DEDAB6F675C021DABC59B80FBC518D44330C259A5B070D089183CD54DB098F19C4998C42BF4D82028992837DE0060FD7F68D858BBDFDBB75EBD38388B5C6C7AC7875BD00A5EA5B72044A01C910856AB675585C68A4D3D1B2ED64B04ECE7506E475CEEDD7DD1E72B4290429C734894F29C24C047AD66E358D4C7A4E76B11F7189AE0D6CBDC0721A426D6BBBEE6B0C555BE0FFEC49B85E015A087629A1604439BBE219D55A1508178586D30261E603925DE5C0B0BDB9059A897B1C51B0141C85F6044373181447FCAD5158004953E8120B354C868E34F3395C1A18BC6DDBB2202CD01A3C0E"
    $sFileBin &= "400B44720348558372FED872D443F5E348BC407224C37F7AB606779A7A183BF90B7E4297A5705167D2A52E3D122DB17510A90A4BF0A74822046BE90B0468F51DA1150C111AE61D5A5C1668C030E690E02F56964A701765918031687784606CEEFE0458C90C3BBF029ADE1648813FA705D6D1863D3160DE8E115619503900CA05111786F1B259E3041CCB1304657A006C63022B7966636123BA1F8242B049367ED35101CBB0395DB0734F42B09241AE9271B1B073AF5DE0713D3601294E1E0471331B5BDE98CCB03386D38AC1B747C40CF80376058653CD5AE4E4CB711DB2A1746299600D5A5A6203037330015C1BD3D239C281BEF95B620311B003205D70E082064DC307C114E2A7047301F695C9CFA604195D4A0343895D9B90964CA7AF724A1900B9AC5D9573401420AF00D90561E329E4720583EE40F303EF04D0E263A899F27A56F9ADA2148CCE0283FA0DD468C73AC6DAB89401F8E4D31D03DCADB5813644055E17627F807DD30BEB1DD16594AA5A01DB497493B10F8451D9587713AD4591C03244B3EA06D4E182A43AA75833CCB7BEFB8D5C1B016509D64975AF69D48D5E01960C38D8F4DC73C913D4725B9BD8F6D8F25DDCC9119A8B3B5ED94FB408CD1319C0D7C9540962FD6740DAD5ADBE71B002A4B83975E8F5F204F0128D582BF81239C3766E57CB5599CED729C1070DBE09032B7D45BC01C1018B2DA8356DF2191E3B0D3075B7AD18AAFBCE7EC0019FB82CABAD2D0B1A2133C67FE212F0466F1688022975F5B675CDED3F52AC247258DC6689E2652A07B75F73065C5B54838EB0C9B95746140D42F817D1E59C2A55A0EB244C6D02FF61C9AB03F7D621759CEF85DBB6D0A219690DA0479C5C9CF82D362CA06E21DE2601C88D1C424C254C5865136E6A99B0DB83814E6613EB14DD22B295F7913E0B558332BD521EFCEF16EE2A299862F53E2C5B024DBCBECC0EF04E430517CBC1315511456E954DBA5858E0BB57168ADBAE013D29D654C1EEF1168632D2196054E0B86A74948706DFC05D25C0A1A1A34C0FE800DD88CB47DB6162410B1707890D1AC7B230CBFE0B7F1331094709320025129FE2252263F7C34BA68DE0615C724D11E05102212307C00CAB0008456CAE1C8CC8554286C140D8554D2690D70148071183D5B05264CAE07372CDB0407938DCCC750275D80E0BFD64577E30E8680AED4CCE608F4F37B210D0BBA7F9E83355B7F081C1D5A92B6402D9FD15582CB4499FB0A66402E4C83BC8D839DA46D48AD86F655397617D66C8ABE017A043E95D916E3B912555D0EBBFBAE2C6269703A611410D1646801C2DD5446ABCF8D8B841D03DDBC14BE7FA453A94B96E2475BADBB23B7165AC70541B4E6D6C23E3154F99411B71850C64874E370378272E794EB8BEB01DAD0A7C919A1C221001889421D782EF3635A432217D0CC648FB6690CA55FA87426BBE2990D1EF297DA8ABB7B619F7541FF6697001218DDE82055A0D83CB15C1E60421070B0E12FE44F30E0029F7398993460FA12F96031953E4B90E49383708EA83431530023900724BE300ECC0C0D47682484A2D01D8A9737D4691524B8C909372FF711AA306E635F98FCA6D820362357159CFE30E6109735D8704E64BE4C076079F2256C61E02D3E432A67F05B9CBC877163628015390413403EC921C081A570F90317BEA694148F643F0430A890F1819CF6F3430B14075506D70A2207540894D004B081079436D22684B74531B8259B050DC0057D53C4B2C3982C6AE418821CA088D3C74061C40658B9A4B0C388142B42BAB7BEC6118695939F028EAF05A41B0CFA06500F009C78678361EA14662C139C74410C6804BD002E76C81C22D157061DA04FEC2A7DE0C8A1FBF4B04637DC00560037F0BBF43249E60096E9C4DC49903BD14B441800D1848DA2B17B8E50702D8DC837DE46B4BD0D4E1533EEB109F82C60A168E4405775424DC9A87FD9DF1C553771EBEE5045D5FE61E491CBFB872BB8D6785168554F7348648767B0B4BA8B79F0AE06C5717CA213C770F19556D731244A31A048A22C10E2A607F95C43404D34B425F565160840FF07357FB8C58804663013D3758E12E32D85CC62FD860653A7902E3DCDCC84E080F0B7721A1738ADE70C8C836598FCCDCE1B0DD115B5C020412D0674C051E260CCF4F3B970F63B0C3734243F51D089B039003612548C2C68781DD4172BEEBF0CC88C2109586B9034F5E896A941EE8AD48BDDA443527958410BB6D6BEDCCE0870D7E82253F234A5E209C40D113033B84DF1BBA848CEBB4295D3AA695B9665D5C4E3A58369423C2598AAF996B90FDA201712C5D587589D63E4B374B39C205404B28D2C056D1688DA516AA66569A70D0182208C7BDA5DE363A189008D4C1F7D2210F6A0CCEE8817DD41FB9C0D8049B30517E2B3121DA09933D2AC8D5D9486195E022793902A0C3E5D8C4EBDB6177EB9725E198CD885966523CBC91FDE266957725FF8C160F4C642DC4F965729835D78E2A4DE826EC55DD908CECB950E05C070F3DA0216B462839EE3A3C3CD76A12A1625C3CEF61AFE9CF5BDCB2594B02A88B0C33613AB3D6A21CC8C8A901089C4C1E48CF765A07795B75D919B05FF37676ED8229B21793BDEBE943A293CE41C6991F7779E3D08C9AC40CB9B6DA420E19DFFBB588D3FB47D8901D5D0075A9295CEFC2F782440CED8601EB87372A4C5F588283EA407101A600D70F42E18A8ED1D248588E3A88D9745094DED683C80270A0E8499A010B68414B8D60980D9D0B83FDFAB141C6603D5077197A8BAD381B4DD2C186BBAFCCA8E12C45F734D0FEC39266DBC1AD5A0E96FB5DE5"
    $sFileBin &= "A164AFE02D135D057B57A0DD5ED1EED2621F4821F0418B37B750FAC9B940639000FB24824FC36D4D5E24EFEDFD48B52F85C9C7404CD4068C88CFC84800587415AA55AAB32524505D2C82605B46070D8F8782070425742605B8082259BB3002BE289154B289E251705EECB6CF562253255FFD609C81E0B9F15FE23C8A1B1A2976759D1C817E5588CE66492001A03A824F7C7690CB484CD99C2BE256C696F00A6702912D24E0725058773C0FF1835017F675E5108844165C1405F702F08946587D5AC0E7D94A103B9F5676D3FBF76E2F59807A5C6B855A14840883C65C3C5E60E97656010346024F18A01009C2B04164EB0B030808344191118E45E6414C4441BB5FB46A1A7A7531F6D739507A1325FA24722C89C19BD60B8B7920667BAC236241601885F60A26BBD3354155DDEBBE758B595A823680508C5BA6106B100F14A0DC49ED9D6854F786970536070E4AA7882DE0D08C4F9F516EEE02252E9072F5378644014E4ECE4640063C383477B02ACEA25052425877CAF048C08A467DF0132B091C408DAF11FD36E806501409DA5AECAA0FB1DA21599E478956FBFD286705D4E3495C3F2E01B209E0823B7D20CF4118677033DC62069D1029CE63817A869F638BC32544CC25412005957B17800950C7069440E2102A4E16F6316C5BA18DFD13BB87C0933BB00434A0DFB72A9C0158C04BE10346872F340537EF43473688D383FB13DC26EA7DB1C0297A75E0C9C1B9CAC5136B7F5D8C84EB00BE59588D715C886116073BDB462F71C534C3756EB98D6A1F5570B9F703C452DBEE36A37FA412013E01D4295A1AADC7F769976158C3512D34AD3AB4D7CEFD04C8A0EC8FA8A37E1E83909CF2E05BB72DD557CCA56ACD0283857B748B90B9B584702B0202F7F1C35C430DFDCA6C317C857A9042D8756CFC5424968CDD7889A1EB8A6C02AE7DB3114504990D14B009373828DC623B4D272A83C05CDE90280CAFFDBCB6B5179E761C01580130458E033D7BA6574A6F966D6046000329E2750F6D816233FF38180D12839B196A0255C90B2E0A9F11B163D85FD089D34772D4DD178539F87206688D1C3EFECE51A5ADCB8DAAD70A8E6010B80C83612267EA0815525F6C946060A3B58D36011E843EEC26E06F0FB7AD582429F301D6FEB8DFE9DC29DF36320CCF015D4B084A9B7676E80149753F32ED53406BEEFF04977525298DB7B17A430624492839D6867CA559A75DAB9F9CB64CC3260B2805B0E80A8B602001AF0A930057EF5D773D736350B4D2FF52F90C4014A65AD8815B0F2F8B432D39B0142B140F118C248AFFC40720217CD6641CF690001793D1EBA396776372816FB804990456925B9FE25753DD8692D942029A4ACBF7EA9E01C10C03AC080418BD89A5289D0FEC6F894E0CD0D8FEEE422E1A80FBE0775B6608D3F62CD48003B4063C01DE622B2AC088089688C8C0B6AD7DD70D1DD100C828C306E2062695E2063079012889C2FA25778374C0EA7663460888D0C05CB4759BA1D02873C10E04FE848623D8ECB986BA1FACD305B1AF18D9A91E4244F18B328C786D347101F1794B2BB0E548C37F2984053973547427897C111CA01D613B3C2478365617891C95023EA41F107402E5C89545D056D0DF28334270F28D5DE8443F1C49089ABE57AC790A3BD743221EA16D656C22E14C7454E3AE068AD934B76CCEA3EE05F40C33E8B1322414BF386F02BB8CA0D8681475B50612C5F4FF2AD064CEDF7976E27F637FC119B4270A5E28741989FA1B64BB66708F4C252B04201D29899191672BA1D8DCE011869D91E4F4614C201CA49334B8EB667E9F72EF7B7C81ECB862B914AF9F8886446772C23EAD0CC58B589989925BAC42F1D91306763501189CED04F0288DAC0F88219F8D01BF1CFD18891485A4A0E665DC104FB38876B23D08894DF621010FD645A0223C893E1D304940D720100C210896F58E059B8D853AF2BEE904B45569BB24833A03749625FBBAC49CCB02A38EBF33F73A5AD8898F8CBBD6EBCDC09DBBB090008B2DB70333C0B58DE24D7F683CFF152310117B6427107CC31F8B4CFD89C8D09A8CD4055AFD8BB57651520301341A1C508901ECC93AD87B682C0DC35F6AFF5021275D617614C30F765F06508C2DBB7C2E8C04C38F13CCD63DD09A13F9068212446DC25F77183B07203C5EC3A99A860E2C6B09CF8FA9D84D446B149629C050519FC9205B371C1A049F02045BBEBB2D5E4C186A015119FC0C4DDB7D832DBF0091693408C32F37394A2E005CEFB6646C6C08518120EC4C2FC20A996C1F2425C5DC48481F0FEF590239CC73E8284F64ECBF770C1F33508B0251507900BFF796AD2FEFD3EF6A1CD9F91C20016A4CAF4BC0C647558BEC0E6816808FF4877704977064A1C15064892587EC085349140BF1565789651BFC7C141EB9B39F2C1096D58D7FB652332C0D5F5E5B8BE5D6C55E2C18A633220F8041B29425AFCF8D9841C74C5406C2D088250706DC3061108D316F5DB27FA338B429A60C5DB4AF8A30112B844DC13650F4FE29C83FA42985152CDB500802040CCFBAADE3B28F38D96089680659B6BF6E0D343F53043F0329D1093053DB680B5043FCD050FF169B8B7845F874395D11348463130AD7F819AF391FE6DAD66D6DF8D71E330C2E4215077E89AD1EC1083B434476B4CF8423D566D5E242EBF10F278813312F14A2EED5DA53406439827AD07BDBC92F374330720A408C16B19DEC6C034766EF4A30F23C29476F0B370A3D3B4244EE04E16BB397FF1F1BDC0D15C119DC0E392173065F5D002D017E306BACCF9E6C119E6DC7468606202C2023B70344B01B48044C1C817827"
    $sFileBin &= "5406CFDAB94049C04015FFFEFF02B076E2644AF7D281E22083B8ED31C24979EB96A58017339E6C43D300CE2F524227D51FEFE2203990202008B42F5C790374B8F6F084C06C915DED6D3C198B2C01E86780E61C908F1DBC8F1CC9D38186D0186337C452817F78F9D1E9128023C3036D0F2F98146F454194EDADF0C58D8C087A08DE5D68AD8838A38C01F21B53448D34C2AF231ABD4CD70D41733CC82DD68AF8488D7701B63FBDE04BC5915CF9026D74328D576C835CBD2B47B80206EEF7E5E40408D1EA81CA3781FA83E9EEFE96010B515328423D7607814904A149F3EC030B00010418A5D61C819E097C7BB12D50A97B8FFD603860B811B4A1B904735006020140ABD8BAD764AB02F5048E9A3A2755F1DCC1019AEA71F291C716F11EC1B73D8D0CB5B583E0BB01DDC8A639DA96008A205B28E696B8595B363B825314019A6B2493246F099BCA05D6C96DCDA6D90F3D8817773C741C5BE81D0C878622AF10016EAF237C89247FC6FE00B1EC97C5D06D6C31C95B82BBC2EF5FFA740723616E51BA37D929E6CF098E4CC212302E8C8AFF0C212816C045AD9904E8AD36E5BF4FF3F75BC239DA04DD78A9A7D38B790E414444B7412C4DF2CD0BE2094DB66123A102201D1C22DA96C00C8E10F91E78C29D61605E8B56E3667A48C5A31F014B60E132963A731AB120DFC730D4854854D14077F348D17698C62309681CF06B89CE38AD18394304DAB9229E30AC5A1ED76F8CC409D1C8EF1F100389762F855339F275731D2F4FB7CDFD049139D8770E9508421F72EF6E2979A870BFD80DEBF096FF18DA58DAD1D483786D7440466DBF5DCE2D465E042B394644742F0C183D723CB407145FF84F9F96D5599A8EFB14568F2650CC166172FE818EB5451BC2EBBCFF58588B5660F0B316167C647A4BE681E300FC5E562FD9F74620706CB46B8C25D483EC5070C02CEBB19F01682C22AF08E170D8000D5E3C8205A276D45F494E29F9828490DE535CEAAC4DE68387280C29DD5E60098FCB0F8D1487181476CC06BBD64118930C8B3A33248F5D468A4C2475B70E023803F70D76C675AD18135F452502221EB5B7FF06423B55F075EE393073898904536EB476A839073B0141FFA339FA8F26F083C204397310EE0B16D07361FF20C14F900986359F55450DE843D9724F808256FCE9B76DD18D58049EA08D98D07B0673247FE30D1AD375DFF3837DFD746E3B5D2073FB5670A66945CBBA0C1C8D3CC2D8EE9A6BB04D201B090757E429D91C758BD8A8E8E076034B77A65E2217B60C329BC73238C16DEBA8DB7465037349C775634F6CE5DCAEDC4DECE2077F04676DC8B9932DB80C6D759224D4B20D12CC07C728D114D6B5F7600F6131B27D02366CAAF6338B07B9FB726C2B0874C20BAD1D3A79883D0A74453785A5CAF62C73512E2C4B432CE0D6B9ED1683C67C06042889127449F175BB86405DA40C02351A44BFBFDD73CEBFB740474475BB5675EB9E6D10764A72B59F5D35751AC2042DF6233584C856DFD6D0A18F47620113FDAF513C2B064F4D101E4C90E35923AC7A506A51C150378A131B06638CBADC614F0629F1C78E8556C57E6A607365598E051CCB55C8546EC25741C3E1965DD809746E3BCE0E4B1B3B7BB619578845DADD9A80DB7A3806746C04733F0DB70005646B4FA64139C25D808D7D7604756A91A83DAC666975960F7BD03262C276377A02D7ED8043C05B75E8E416C7ED3D0E3BE473EE8FC66B787BA51CED751D4187AFDC49D837AC0BAA01AB02441B7691916D74E4A01C5D44743CB6A2A6846FC29640D6E2522BFDD304407AA33D8BD6E04204693E5770AC4B07F2153F387715FE61C027E80177168C74EC4E5775036A674F206427D78136031314C0D52A62D40CA9085B966E1BD9BF2420152C061C18C91F60691814CB4724895C49D107B83526F023BB7BD73D723CFF27C341FF0729C321C1FB02B74280966547470F704BE8E6DEA2C315EBE81F68854C60CF02A917BBB551025302CCD8CDA290DB6087D6CAE51000201376E7DF02141F1A63FF4C4B4610E6E0E34F40E80F86E5E83E0EC18BC834DB07C4578673103F0C71E1FF74CA4702D44D206A90C6EC310CF1776FFD56282104202B1C8A8B8C82B7B1B716B9B9A02DE4899C0F76BCDF05561C828B4E18BBF87176122E754B1CAB66C26638E7848E586A6A1EEF5C5D890C839A0F261A45F58AEFF21CC920CBC98B46467C4670885FB863135DE8E81176CBF3F5467D062229FBF5C846599646461DF44C72115AD4668BC5102D1F040B64BD70DA059468674F3B51D16F4DC3681C0F173BA9750743EBDC73BB421975F1FFCAC5AF4812DE26F7B4891A1008E30E774EBB6C72F2C5B0BE100CB7F740B8E846DF94E4B67158736673BC13B4AC0A5A16EC8B234BB29910CDD2B0045FBF7D4703B1B69A23F5011708E075282C978512C2415C97D813978D23947FC25DD8A551E208D8721B9731B7F2D7DC23A34FD32CDC584244AE89CED00557C2DB87CB57349AC675F0172BB49AC811B1ED21CF04448C06118ADBCB38A9225DE436500582DF8CB22531F63D0FA99ABA6239576BB581741BCF43ECA539C076168B9CFA015DE8A2184596D1BFA29DA0417725E72259784368A2037FCF820B4BFCE52EEE041E5CB0F862854E4EC67A212414100C0F001F742EE07447B55C1B0975251320432CB6601882EDE365786FE7607A84393629CA79AA07314696C835F0C4EC080DAF44480E09ADBE9A388C6F3C7929836E7705BB03CE4D8397C8EACBB1C1AABA1E3DAC57C8C475E4C067062CE7A4AAC775221903560990C71BD12717C66B95CFF8DC0907C50C7C"
    $sFileBin &= "9087E45AA9C46D4863B2046DC3DD12E0C3FAB04CFAF0EBB56FC8858C115F3CCB32944C059333170F915C9D7567FF931C87860E2A57D1E4AEDEC864343836971F39E99531AB857F3CC33D989047C9577B891C13198F1109B22FDA4D8E17932C4C552B35A3E102C9716CA43835C983900B3C7BAC0A89B32B8F7C132F6A16FA9696178B5F20E64800AEB5152C7BAC5485AF12EDC483317034F32EA38473C88B1C0E25B420B807050D9E096104B20807FFD283EDCC1C3BEB0AC64E74750ECBC1363101CC76EBC342010A086CE62261B3A3D8032CC7118975978B0CAA133C4E75900FDF63C860239F0E89AD3CDF6181B6A302E79C2797D050E002645CD957654B70BC67B3839223EC248090AF2CA29D01B9B1EC96949066E97E0252872C0C75B0530FAE0254795BBCAAE75794B26A8121912D27F081C9F5D100B96C4CC9ECCC362C1617CD0D5E04B285A40FDF2C3AB31C72D103E8C21138DA062498C2EE2822671B904F9B55F0CAEEECC39148129D9B21D8B42B532436F28386ED3A6BEF32B68C93F8550C932A1512E40A84581F05E8C09B900B3F380D6D8EB0203FFF0CEB7FB26C9B0A5FDF7728E81040BD9535CD4CC80FE7DF7021C9B6EBDAE220D50421F8101BBBE8B481E29406D59499D3916847E614811F3934906C129FBEDD17B44042B017D123FF724BC4A58A287F1027798DD81D66BD851575EA6116064D58E3D41FA45E99CBBF4C9FD252276D8F438915743BF2D56F60A60E3491CF918F0B98A77B8E8C1F1205B04047326088EED80DB04093BF45B850E5701A311600BE6B59059BADD9080880060C50757E506D2868077AE02F811097823E292F8B52482E741839566805A60421788023C79C19805F1275107D44478E95E00F76C07F30411503827F5FC9C9D9907B1006141881CEC9C91C2024DFA8C8570B5E10FB150DEAD96E4B495E1809EA9C6C6F0422060C08F2CDE24FBF69AC8D461CF80A1459BECD0D8C1D383015CC24C5D99E3D6A7C3397545A2CE622552F8D8D65F89F2D1D62EED70E5AFF781946202669010CC0CE3D6C48501D80907F9616006E27E07EDC5E489D74E5B6AAA5F4041D6DCF7425800F13562CA35D20C161CB0C7E6BD5CCB0A27EBB5D433B9174298D7E24EF9E2D3B1B3C898B332875E52A21C5D957040FD9649BB0FF46EC04E32DB04DBCC19A841DBFB614DBCE353E46108214B854094DB667DD28067D8269DC4D18C9205CF20A1C20388C482B6B718CC48C557136778AC786BC08604F168E0375349510689C0764B9ECD8BC7C7483C24E2821E9C106CF968CEBC2AFE06A5950BF71A22BC0CB9058F94E11C23F96B9A7930F4330BE0CFC217BD65D9C24178284AC2CBAC318E1C743286F437D7CBAD3409601D90E18C41C0EB03968B56F1220DEA2C569CE16EC9EF5A10DD876391C24188563D367B3C01472B823109D119427685C730308D98FE02672859BFF8480D88932466F180474B07C1C7585F875A3F1EB2EB489CF6280569789433BC641C72B9A8037F72B3C905138B475CD1140C70A7F4E930D56BC799775D0A3664F0CCDD1B33C4D5D40CA319EF80F9420BF0133148789DF8E4161BB131786EC43905C142161B0618D0CECBEFB5FDE480EE404485D6CEE1FC45826418B04874D680514D09682202B52EBDA12DD570783C74089091E4367B294141CB6588FCF6CD902B94971D8316400E410B58F5F35240F3C95080552C4224CC481C257AF6EC63A13A2164010DC83C25C0931762B75055810E45F10CCEA80B71436AF5E41C0A00C36C283805BC17A08B4858D3CDB3DA8E50C85D66FB078459AA321D19AB2598C86E8F547E239ECA4C548F4DC0D0A7E4CDDB013353AC37B11A029B0DE7705DD291A299A18516399C3C65A1742140DF0106C089E8C84734C65F402AE8020C8A5622AEE3A1B8E8C093DFFDF44CD229A70994E746B512D8F5EA4058AF814A96FFFF6E707C1E70F7701CFC707F7DFB6686B0C3248DB4F138D5B0181C06B00E0FBFE1FF5BB06135F6D2D2514386C138D728D18790869285C904713C251B46BBB019B1BDC068A1DFF9074011F586DA95CF4EE1EA3CDF70CDA746C65887C4F5E58B1E801B144299A588D076FD6BDA05C40505D92766E16BD60C9653E894316800F39108A424811C085A4EFB0238C595BBF93F06C40BE04285B830187871B9B8370C48B0A2ED085124B0BE00D7983FC425D24000A1A0300177AE5EF8993088D5002173881045246C36C1B04F47F40538029DF1D4060300238CAB786B5F619F1A9C301C0291F11B45534E23FC20539CB5EAB6A773E61AF7D67407432FC3D867C39BEBD6FA108ECAAA9964AC6D88BBE14D1A2D771D6964A93ABF8ADC0BB48FB8B8E1C014F4AC018F1770397895EDEE66E85221A73031F4E203F2C59EBA8F3D4161585B6A02F1AE6F9E4F7FF4E76F3DC6ED90018EB2090150E0102DC6BC39C684AA25D19A219B8DB7C0986280D34454D485E24F3016FFB07201124264ED4AAB3353E7C4C481708DCB3456CE1F947721055F0BD08B61F8B2B0C90B7406C0A42BCE26CD29FA2B2D55699EDC1BD01E0BA919A92862A13C240C361667ACCBC100F824A1AA22148803B3C8B9E30AB4F106DED843EF84946F03D8A98DBEEDC399D28E987ADCB44A02755AA964E8133B709205465FEEBAC05235C9C0A8164B64EBAA54AEB9E808A90BEC2E157C418B901F8F2FB555C88303B2872FBFD028F5A3063618B10575D9D1D888B4C41914A18D9B316DB9575DE772081D08C3F2F407504606F16BEEE377DF402470F3E3083E33FC1E31098A2D70ED201C3648A9C6AB1A29ADDB641BF87775E2B86A243C2492F"
    $sFileBin &= "580F59685991B747EBA89366C266861F5A00753D2161492989D36DC097553322D8029F292037A8083F2F8D63EA5B26487F7B408D5F2C17A66A3B3C474405288FE021874004B6ECEB2A81461385FAFC32881598C5522CEA46E1DD96ACD6AC17892908F7CF01EB8750E973488D8726E0B02D8BEC7E568F0F472B580F1F5116B19533FAAC5783C32C78822212AFAB1920E90ADF09C1BB8C9F833086205601227B80328A0987876F6F3BB4ACE7080CB74390A2DAA159674E1B08921D10F2EB943FAA428F3D8825881CC9172EA20D8C8F0E4143C133456B6F5F430E966478FE368DFC4BC01B087FC1188700EF5BAC7889A45720BA05CFA20D16782440026F3F0086D736846920D3566DD98A32366D20C603825CC48311460B442457E157FFF7050F0E7C6904C9E6706B3859577422ADBA078F30151C5E9D90BEBCC50061F86CFE857437B56C20279397441C8A3FD8007774D6A6E347398FB9F2DD7014A2A7BB40505C8DE0C5BE6450554F36008784046F2F1D8EC1E16190198BB3004E01C4C0172D3B24F192FA06088E6FFCECCE02B680792096402313502A0596E0138DC041D8B951EDD4458D89AC830E08195946961C0C481004D946B6671406101814081C0365641918202C67503029809E03DA63E12FC52C7EB3EF842209C40FE3F1501D5A7E28682039D3C1546BF081A74859C1E3A08A3FC42692F1ED793C43746696260A5A363F0EFBF44D14825C30817B10FEBF243ED110F70C345308316958C15BFC770A59661C839871A45B913CEF8F0E8260296F06125BA968587F405A6F31D8B35A4B917C159057865506BFBBB51B811CB9254932502F8DB65F7D308B5818C75024360E96DC101D9746048A8625388B0C83D0880D6E8E833BD872175DFD12B07BCA6E29DA380416EFF8132A352429EF3F17A92E531A904823232480993928254F6CCFB972148F89988948B354B76D11789140891E20561E550A5C9890234A80213EA9FC149925083D3B294C4388BC063C990EDCCDD5FB39FEBC720DAE50182AD3DB29F9AC0E7449AFF5F625CC5482B52455D1216A80CCFA37102102BA43105A2BF096EAAA6A6AC710022B0451E0005810F3FDCF41D797D01848C79B38440E0274199DDBDC8B3BFC693E086C4172A15850899003B899728D2CFA08EB84EF4A1A86165D518B57EF292A01B0F025F18B31FF4F6FC17B296A6F25320189173B178B010FCDED169A7F040309C3040C095E7829700771E5FF47C6F0FF07A126A400BF0C3F6D0168DB02574401132AB889566E4C44101147D6754F1B0FD58D398D42CD478E0F660DAB60414A84E46A84A17E8B1D1B45A22A1F94E2C6B7FD9873291D2A29C65BC1FE8FF031F2B987B9AE3453043734D0C24B081DC2CFB549FB172BB8064B0907EE0275E795102CEB74EBA29F5DA5B67DC9D733EB1BFF4B5C43498B5AA02EB4FFFB1B01CA114EA44B4B44649F3B5975E0027A81B537272F2A75D5C0215E412F175F58962D259F705D463791A569038856050F47579C0AC056105E08055D17C45B8D13FF4610D4062C8B7E03BAC53C82CB404BBC742F3B460C0AD4842E315658B4C85CF71658B6294C04342E7A76487175D18D34BEEBC427CD944DFF8F554657273D014D0B880AD1055641051C9310A502D98A469BAD21F2B68801B20C99AD0CC8612F25CF02982EAD0A12C95A9FCC95EE3855B3DCFE9080C71555D100B8069220FD5DA266FBD091F0060CE06B74342068D0AE0B98942097DB881DDCCE4954AB87B0C70508210CB0C07283250AA3B86C5D3FD0291495E0D00BB23BC49B2286901B591238F694E04C93D04F3965B625DF4028E0445064EC56F1FFFF88A050054C64646464480C0804766C2C7640CC000B3405380000005B5104031162A62007322403C80A00082403C8400B00ADB24032093FD334CD950B010203042FB0254D0506330203419EB3ED0405060207000A0040A0BB99FF056AF103F7540564290811A00A1905FEFF97675CA00152656C6561736553656D6170686F7265DBF67F5B4C0F7665437269746963616C1763076FEBA6E4B76E15456E746572443D742C00DAB62B47144C5474F66DBB3DF20D57611E460853696E672DDAB737F74F626A2514436C6F7548616E64126D6BDBE60C776146457664413D96EC8B95530A9C730B236E6E976CA727496E7675697AF634DBC880DE694866296BDBB6B95F336C6E630770274AB1FFE76C661E345F6578636570745F6888EEAEDDDC72332A606D6F711A6265672D673CD6BA6876642518637079B28F6FDBFFFF0757076DF09A17F03505F0F902F06901F0D402050B7204196DEDFFFF35F0B90261BBF00705D1F0D302ECF0B101C2181C193DFDFFFFB61F6228FE03F0B31C3522453982204733730528F08B170709FDF6DFDD011B070C05F0340D65F03F06070A0D0D090D070F4BFF63BF0210050D0D06000C06F00C0A040050453D4CCDFF43FE010300448DAF4BE0000E210B01050C0098081B699A27801110B0100B6E166C19020433070CC0CEDC92D01E341007CB66E9D906A0B3D66E8CB15040B21C24C0F01706B26EA7581E2EF9787436B0C176077C979098C40267DBF87220602E726424611B0E7317D27DFB06279C40022763939B636510B32A01FCA2CDED376527421B34B2103EC1B7000000700400240000FF00000000000000000000000000807C2408010F85B901000060BE009000108DBE0080FFFF57EB109090909090908A064688074701DB75078B1E83EEFC11DB72EDB80100000001DB75078B1E83EEFC11DB11C001DB73EF75098B1E83EEFC11DB73E431C983E803720DC1E0088A"
    $sFileBin &= "064683F0FF747489C501DB75078B1E83EEFC11DB11C901DB75078B1E83EEFC11DB11C975204101DB75078B1E83EEFC11DB11C901DB73EF75098B1E83EEFC11DB73E483C10281FD00F3FFFF83D1018D142F83FDFC760F8A02428807474975F7E963FFFFFF908B0283C204890783C70483E90477F101CFE94CFFFFFF5E89F7B9D40100008A07472CE83C0177F7803F0375F28B078A5F0466C1E808C1C01086C429F880EBE801F0890783C70588D8E2D98DBE00C000008B0709C0743C8B5F048D843000E0000001F35083C708FF963CE00000958A074708C074DC89F95748F2AE55FF9640E0000009C07407890383C304EBE16131C0C20C0083C7048D5EFC31C08A074709C074223CEF771101C38B0386C4C1C01086C401F08903EBE2240FC1E010668B0783C702EBE28BAE44E000008DBE00F0FFFFBB0010000050546A045357FFD58D87EF01000080207F8060287F585054505357FFD558618D4424806A0039C475FA83EC80E9272EFFFF00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000005CF000003CF0000000000000000000000000000069F0000054F00000000000000000000000000000000000000000000074F0000082F0000092F00000A2F00000B0F0000000000000BEF00000000000004B45524E454C33322E444C4C006D73766372742E646C6C0000004C6F61644C69627261727941000047657450726F634164647265737300005669727475616C50726F7465637400005669727475616C416C6C6F6300005669727475616C46726565000000667265650000000000000000448DAF4B000000000EF10000010000000300000003000000F0F00000FCF0000008F10000E2100000411100006B10000017F100001FF100002EF100000000010002006C7A6D612E646C6C004C7A6D61446563004C7A6D6144656347657453697A65004C7A6D61456E6300000000E000000C0000009D3100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
    If Not FileExists ( $sOutputDirPath ) Then DirCreate ( $sOutputDirPath )
    If StringRight ( $sOutputDirPath, 1 ) <> '\' Then $sOutputDirPath &= '\'
    Local $sFilePath = $sOutputDirPath & $sFileName
    If FileExists ( $sFilePath ) Then
        If $iOverWrite = 1 Then
            If Not Filedelete ( $sFilePath ) Then Return SetError ( 1, 0, $sFileBin )
        Else
            Return SetError ( 0, 0, $sFileBin )
        EndIf
    EndIf
    Local $hFile = FileOpen ( $sFilePath, 16+2 )
    If $hFile = -1 Then Return SetError ( 2, 0, $sFileBin )
    FileWrite ( $hFile, $sFileBin )
    FileClose ( $hFile )
    Return SetError ( 0, 0, $sFileBin )
EndFunc ;==> _Lzmadll ()
Func _DecodeProductKey($Product, $Offset = 0)
	Local $sKey[29], $Value = 0, $hi = 0, $n = 0, $i = 0, $dlen = 29, $slen = 15, $Result, $bKey, $iKeyOffset = 52, $RegKey
	Switch $Product
		Case "Windows"
			$bKey = RegRead("HKLM64\SOFTWARE\Microsoft\Windows NT\CurrentVersion", "DigitalProductId")
		Case "Windows_DPid4"
			$bKey = RegRead("HKLM64\SOFTWARE\Microsoft\Windows NT\CurrentVersion", "DigitalProductId4")
			$iKeyOffset = 0x328
		Case "Windows_Def"
			$bKey = RegRead("HKLM64\SOFTWARE\Microsoft\Windows NT\CurrentVersion\DefaultProductKey", "DigitalProductId")
		Case "Windows_Def_DPid4"
			$bKey = RegRead("HKLM64\SOFTWARE\Microsoft\Windows NT\CurrentVersion\DefaultProductKey", "DigitalProductId4")
			$iKeyOffset = 0x328
		Case "Office XP"
			$RegKey = 'HKLM\SOFTWARE\Microsoft\Office\10.0\Registration'
			If @OSArch = 'x64' Then $RegKey = 'HKLM64\SOFTWARE\Wow6432Node\Microsoft\Office\10.0\Registration'
			For $i = 1 To 100
				$var = RegEnumKey($RegKey, $i)
				If @error <> 0 Then ExitLoop
				$bKey = RegRead($RegKey & '\' & $var, 'DigitalProductId')
				If Not @error Then ExitLoop
			Next
		Case "Office 2003"
			$RegKey = 'HKLM\SOFTWARE\Microsoft\Office\11.0\Registration'
			If @OSArch = 'x64' Then $RegKey = 'HKLM64\SOFTWARE\Wow6432Node\Microsoft\Office\11.0\Registration'
			For $i = 1 To 100
				$var = RegEnumKey($RegKey, $i)
				If @error <> 0 Then ExitLoop
				$bKey = RegRead($RegKey & '\' & $var, 'DigitalProductId')
				If Not @error Then ExitLoop
			Next
		Case "Office 2007"
			$RegKey = 'HKLM\SOFTWARE\Microsoft\Office\12.0\Registration'
			If @OSArch = 'x64' Then $RegKey = 'HKLM64\SOFTWARE\Wow6432Node\Microsoft\Office\12.0\Registration'
			For $i = 1 To 100
				$var = RegEnumKey($RegKey, $i)
				If @error <> 0 Then ExitLoop
				$bKey = RegRead($RegKey & '\' & $var, 'DigitalProductId')
				If Not @error Then ExitLoop
			Next
		Case "Office 2010 x86"
			$RegKey = 'HKLM\SOFTWARE\Microsoft\Office\14.0\Registration'
			If @OSArch = 'x64' Then $RegKey = 'HKLM64\SOFTWARE\Wow6432Node\Microsoft\Office\14.0\Registration'
			For $i = 1 To 100
				$var = RegEnumKey($RegKey, $i)
				If @error <> 0 Then ExitLoop
				$bKey = RegRead($RegKey & '\' & $var, 'DigitalProductId')
				If Not @error Then ExitLoop
			Next
			$iKeyOffset = 0x328
		Case "Office 2010 x64"
			If @OSArch <> 'x64' Then SetError(1, 0, "Product not found")
			$RegKey = 'HKLM64\SOFTWARE\Microsoft\Office\14.0\Registration'
			For $i = 1 To 100
				$var = RegEnumKey($RegKey, $i)
				If @error <> 0 Then ExitLoop
				$bKey = RegRead($RegKey & '\' & $var, 'DigitalProductId')
				If Not @error Then ExitLoop
			Next
			$iKeyOffset = 0x328
		Case "Office 2013 x86"
			$RegKey = 'HKLM\SOFTWARE\Microsoft\Office\15.0\Registration'
			If @OSArch = 'x64' Then $RegKey = "HKLM64\SOFTWARE\Wow6432Node\Microsoft\Office\15.0\Registration"
			For $i = 1 To 250
				$var = RegEnumKey($RegKey, $i)
				If @error <> 0 Then ExitLoop
				$bKey = RegRead($RegKey & '\' & $var, 'DigitalProductID')
				If Not @error Then ExitLoop
			Next
			$iKeyOffset = 0x328
		Case "Office 2013 x64"
			If @OSArch <> 'x64' Then SetError(1, 0, "Product not found")
			$RegKey = 'HKLM64\SOFTWARE\Microsoft\Office\15.0\Registration'
			For $i = 1 To 250
				$var = RegEnumKey($RegKey, $i)
				If @error <> 0 Then ExitLoop
				$bKey = RegRead($RegKey & '\' & $var, 'DigitalProductID')
				If Not @error Then ExitLoop
			Next
			$iKeyOffset = 0x328
		Case Else
			Return SetError(1, 0, "Product not supported")
	EndSwitch
	If Not BinaryLen($bKey) Then Return ""
	Local $aKeys[BinaryLen($bKey)]
	For $i = 0 To UBound($aKeys) - 1
		$aKeys[$i] = Int(BinaryMid($bKey, $i + 1, 1))
	Next
	Local Const $isWin8 = BitAND(Int($aKeys[66]) / 6, 1)
	$aKeys[66] = BitOR(BitAND($aKeys[66], 0xF7), BitAND($isWin8, 2) * 4)
	$i = 24
	Local $sChars = "BCDFGHJKMPQRTVWXY2346789", $iCur, $iX, $sKeyOutput, $iLast
	While $i > -1
		$iCur = 0
		$iX = 14
		While $iX > -1
			$iCur *= 256
			$iCur = $aKeys[$iX + $iKeyOffset] + $iCur
			$aKeys[$iX + $iKeyOffset] = Int($iCur / 24)
			$iCur = Mod($iCur, 24)
			$iX -= 1
		WEnd
		$i -= 1
		$sKeyOutput = StringMid($sChars, $iCur + 1, 1) & $sKeyOutput
		$iLast = $iCur
	WEnd
	If $isWin8 Then
		$sKeyOutput = StringMid($sKeyOutput, 2, $iLast) & "N" & StringTrimLeft($sKeyOutput, $iLast + 1)
	EndIf
	Return StringRegExpReplace($sKeyOutput, '(\w{5})(\w{5})(\w{5})(\w{5})(\w{5})', '\1-\2-\3-\4-\5')
EndFunc   ;==>_DecodeProductKey
#endregion - Internal Functions -