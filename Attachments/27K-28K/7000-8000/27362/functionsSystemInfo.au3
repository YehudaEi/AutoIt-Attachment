Func getToolsMenu()
	$DumpFile = @TempDir & "\files.txt"
	InetGet($toolsDir&"files.txt", $DumpFile);
	$sDatabaseRaw = FileRead($DumpFile)
	$asDatabase = StringSplit($sDatabaseRaw,"^", 2)
	For $element In $asDatabase
		If $element = "" Then ContinueLoop
		$asItem = StringSplit($element,',',3)
		$toolsDirName = $asItem[0]
		$toolsDirMenu = TrayCreateMenu($toolsDirName, $tools)
		For $toolsFile In $asItem
			If $toolsFile = "" Or $toolsFile = $toolsDirName Then ContinueLoop
				$dname = $toolsFile
				$dfile = $toolsFile
				$durl = $toolsDir & $toolsDirName & "/" & $toolsFile
				TrayCreateItem($toolsFile, $toolsDirMenu)
				GUICtrlSetOnEvent($toolsFile, "DownloadingMessage")
				While 1
					If GUIGetMsg() = $toolsFile Then DownloadingMessage($dname, $dfile, $durl)
				WEnd
		Next
	Next
EndFunc
Func DownloadingMessage($dname, $dfile, $durl)
	While @InetGetActive
		$filesize = InetGetSize($durl)
		$currentsize = @InetGetBytesRead
		$percentDownloaded = Round((($currentsize / $filesize) * 100), 1) & "% Complete"
			TrayTip("Downloading " & $dname, "File: " & $dfile & " " & $percentDownloaded, 10, 16)
	Wend
	TrayTip("Download Complete", "You have successfully downloaded " & $dname,2,16)	
	ShellExecute($dfile, $tempDir, "run")
	
EndFunc
;----------------------------Computer Info---------------------------------------------
Global $colorOdd = 0xFFFFFF, $colorEven = 0xFAF371
;Get Drive Information
Func GetDriveInfo()
	$ListViewDrives = GUICtrlCreateListView("Drive# | Label | Drive | FileSystem | Serial Number | " & _
	"Free Space | Total Space ", 10, 75, 775, 600)
	GUICtrlSetBkColor($ListViewDrives, $GUI_BKCOLOR_LV_ALTERNATE)
	GUICtrlSetBkColor($ListViewDrives, $colorOdd)
	Dim $Drives
	_ComputerGetDrives($Drives) ;Defaults to "FIXED"
	For $i = 1 To $Drives[0][0] Step 1
		$sDataDrives = $i & "|"
		$sDataDrives &= $Drives[$i][2] & "|" & $Drives[$i][0] & "|" & $Drives[$i][1] & "|" & $Drives[$i][3] & "|" 
		$sDataDrives &= Round($Drives[$i][4]/1024,2) & "GB" & "|" & Round($Drives[$i][5]/1024,2) & "GB"
		GUICtrlCreateListViewItem($sDataDrives, $ListViewDrives)
		GUICtrlSetBkColor(-1, $colorEven)
	Next
	
EndFunc
;Get System Information
Func GetSystemInfo()
	;Left Column
	GUICtrlCreateGraphic(5, 35, 260, 340)
	GUICtrlSetBkColor(-1, 0xffffff)
    GUICtrlSetColor(-1, 0)
	GUICtrlCreateGraphic(5, 375, 260, 80)
	GUICtrlSetBkColor(-1, 0xffffff)
    GUICtrlSetColor(-1, 0)
	GUICtrlCreateGraphic(5, 455, 260, 185)
	GUICtrlSetBkColor(-1, 0xffffff)
    GUICtrlSetColor(-1, 0)
	;Right Column
	GUICtrlCreateGraphic(295, 35, 260, 100)
	GUICtrlSetBkColor(-1, 0xffffff)
    GUICtrlSetColor(-1, 0)
	GUICtrlCreateGraphic(295, 118, 260, 500)
	GUICtrlSetBkColor(-1, 0xffffff)
    GUICtrlSetColor(-1, 0)
	Dim $OSs
	_ComputerGetOSs($OSs)
	;Left = "24" Top = "40" Width = "260" Height = "17"
	For $i = 1 To $OSs[0][0] Step 1
	$osName = "Name" & $OSs[$i][0]
	$arrayOsName = _StringBetween($osName, "Name", "|");
	GUICtrlCreateLabel("--------OPERATING SYSTEM INFO------", 25, 40, 250, 20)
	GUICtrlCreateLabel("Name: " & $arrayOsName[0], 25, 60, 250, 20)
	GUICtrlCreateLabel("Manufacturer: " & $OSs[$i][28], 25, 80, 250, 20)
	GUICtrlCreateLabel("Build Number: " & $OSs[$i][2], 25, 100, 250, 20)
	GUICtrlCreateLabel("Build Type: " & $OSs[$i][3], 25, 120, 250, 20)
	GUICtrlCreateLabel("Bit Type: " & $OSs[$i][8], 25, 140, 250, 20)
	GUICtrlCreateLabel("Computer Version: " & $OSs[$i][9], 25, 160, 250, 20)
	GUICtrlCreateLabel("Computer Name: " & $OSs[$i][10], 25, 180, 250, 20)
	GUICtrlCreateLabel("Install Date: " & $OSs[$i][23], 25, 200, 250, 20)
	GUICtrlCreateLabel("Registered User: " & $OSs[$i][45], 25, 220, 250, 20)
	GUICtrlCreateLabel("Serial Number: " & $OSs[$i][46], 25, 240, 250, 20)
	GUICtrlCreateLabel("Service Pack Major Version: " & $OSs[$i][47], 25, 260, 250, 20)
	GUICtrlCreateLabel("Service Pack Minor Version: " & $OSs[$i][48], 25, 280, 250, 20)
	GUICtrlCreateLabel("Version: " & $OSs[$i][58], 25, 300, 250, 20)
	GUICtrlCreateLabel("Windows Directory: " & $OSs[$i][59], 25, 320, 250, 20)
	GUICtrlCreateLabel("Suite Mask: " & $OSs[$i][51], 25, 340, 250, 20)
	GUICtrlCreateLabel("Number Of Users: " & $OSs[$i][33], 25, 360, 250, 20)
	
	GUICtrlCreateLabel("-----------ROOT DRIVE INFO--------", 25, 380, 250, 20)
	GUICtrlCreateLabel("System Device: " & $OSs[$i][52], 25, 400, 250, 20)
	GUICtrlCreateLabel("System Directory: " & $OSs[$i][53], 25, 420, 250, 20)
	GUICtrlCreateLabel("System Drive: " & $OSs[$i][54], 25, 440, 250, 20)
	
	GUICtrlCreateLabel("-----------MEMORY STATS-----------", 25, 460, 250, 20)
	GUICtrlCreateLabel("Free Physical Memory: " & Round($OSs[$i][20]/1024,1) & "MB", 25, 480, 250, 20)
	GUICtrlCreateLabel("Free Space In Paging Files: " & Round($OSs[$i][21]/1024,1) & "MB", 25, 500, 250, 20)
	GUICtrlCreateLabel("Free Virtual Memory: " & Round($OSs[$i][22]/1024,1) & "MB", 25, 520, 250, 20)
	GUICtrlCreateLabel("Total Swap Space Size: " & Round($OSs[$i][55]/1024,1) & "MB", 25, 540, 250, 20)
	GUICtrlCreateLabel("Total Virtual Memory Size: " & Round($OSs[$i][56]/1024,1) & "MB", 25, 560, 250, 20)
	GUICtrlCreateLabel("Total Visible Memory Size: " & Round($OSs[$i][57]/1024,1) & "MB", 25, 580, 250, 20)
	GUICtrlCreateLabel("Size Stored In Paging Files: " & Round($OSs[$i][49]/1024,1) & "MB", 25, 600, 250, 20)
	GUICtrlCreateLabel("Number Of Processes: " & $OSs[$i][32], 25, 620, 250, 20)

	GUICtrlCreateLabel("-----------TIME INFORMATION-----------", 300, 40, 250, 20)
	GUICtrlCreateLabel("Last Boot Up Time: " & $OSs[$i][25], 300, 60, 250, 20)
	GUICtrlCreateLabel("Local Date Time: " & $OSs[$i][26], 300, 80, 250, 20)
	GUICtrlCreateLabel("Locale: " & $OSs[$i][27], 300, 100, 250, 20)
	
	GUICtrlCreateLabel("-----------MISC INFORMATION-----------", 300, 120, 250, 20)
	GUICtrlCreateLabel("Large System Cache: " & $OSs[$i][24], 300, 140, 250, 20)
	GUICtrlCreateLabel("Current Time Zone: " & $OSs[$i][11], 300, 160, 250, 20)
	GUICtrlCreateLabel("Data Execution Prevention_32BitApplications: " & $OSs[$i][12], 300, 180, 250, 20)
	GUICtrlCreateLabel("Data Execution Prevention_Available: " & $OSs[$i][13], 300, 200, 250, 20)
	GUICtrlCreateLabel("Data Execution Prevention_Drivers: " & $OSs[$i][14], 300, 220, 250, 20)
	GUICtrlCreateLabel("Data Execution Prevention_SupportPolicy: " & $OSs[$i][15], 300, 240, 250, 20)
	GUICtrlCreateLabel("Debug: " & $OSs[$i][16], 300, 260, 250, 20)
	GUICtrlCreateLabel("Distributed: " & $OSs[$i][17], 300, 280, 250, 20)
	GUICtrlCreateLabel("Encryption Level: " & $OSs[$i][18], 300, 300, 250, 20)
	GUICtrlCreateLabel("Foreground Application Boost: " & $OSs[$i][19], 300, 320, 250, 20)
	GUICtrlCreateLabel("Max Number Of Processes: " & $OSs[$i][29], 300, 340, 250, 20)
	GUICtrlCreateLabel("Number Of Licensed Users: " & $OSs[$i][31], 300, 360, 250, 20)
	GUICtrlCreateLabel("Organization: " & $OSs[$i][34], 300, 380, 250, 20)
	GUICtrlCreateLabel("OS Language: " & $OSs[$i][35], 300, 400, 250, 20)
	GUICtrlCreateLabel("OS Product Suite: " & $OSs[$i][36], 300, 420, 250, 20)
	GUICtrlCreateLabel("OS Type: " & $OSs[$i][37], 300, 440, 250, 20)
	GUICtrlCreateLabel("Other Type Description: " & $OSs[$i][38], 300, 460, 250, 20)
	GUICtrlCreateLabel("Plus Product ID: " & $OSs[$i][39], 300, 480, 250, 20)
	GUICtrlCreateLabel("Plus Version Number: " & $OSs[$i][40], 300, 500, 250, 20)
	GUICtrlCreateLabel("Primary: " & $OSs[$i][41], 300, 520, 250, 20)
	GUICtrlCreateLabel("Product Type: " & $OSs[$i][42], 300, 540, 250, 20)
	GUICtrlCreateLabel("Quantum Length: " & $OSs[$i][43], 300, 560, 250, 20)
	GUICtrlCreateLabel("Quantum Type: " & $OSs[$i][44], 300, 580, 250, 20)
	GUICtrlCreateLabel("Status: " & $OSs[$i][50], 300, 600, 250, 20)
	Next
EndFunc
;Running Processes
Func getRunningProcesses()
	$ListViewProcess = GUICtrlCreateListView("# | Name | Command Line | Creation Class Name | Creation Date | Description | " & _
	"CS Creation Class Name | CS Name | Executable Path | Executable State | Handle | Handle Count | Kernel Mode Time | " & _
	"Max Working Set Size | Min Working Set Size | Other Operation Count | " & _
	"Other Transfer Count | Page Faults | Page File Usage | Parent Process ID | Peak Page File Usage | Peak Virtual Size | " & _
	"Peak Working Set Size | Priority | Private Page Count | Process ID | Quota Non Paged Pool Usage | " & _
	"Quota Peak Non Paged Pool Usage | Quota Peak Paged Pool Usage | Read Operation Count | Read Transfer Count | " & _
	"Session ID | Status | Thread Count | Windows Version | Working Set Size | " & _
	"Write Operation Count | Write Transfer Count " , 10, 75, 775, 600)
	GUICtrlSetBkColor($ListViewProcess, $GUI_BKCOLOR_LV_ALTERNATE)
	GUICtrlSetBkColor($ListViewProcess, $colorOdd)
	Dim $runProcesses
	_ComputerGetProcesses($runProcesses)
For $i = 1 To $runProcesses[0][0] Step 1
	$sDataProcesses = $i & "|" ;Process Number
	$sDataProcesses &= $runProcesses[$i][0]& "|" ; Name
	$sDataProcesses &= $runProcesses[$i][1]& "|" ; Command Line
	$sDataProcesses &= $runProcesses[$i][2]& "|" ; Creation Class Name
	$sDataProcesses &= $runProcesses[$i][3]& "|" ;Creation Date
	$sDataProcesses &= $runProcesses[$i][4]& "|" ;Description
	$sDataProcesses &= $runProcesses[$i][5]& "|" ;CS Creation Class Name
	$sDataProcesses &= $runProcesses[$i][6]& "|" ;CS Name
	$sDataProcesses &= $runProcesses[$i][7]& "|" ;Executable Path
	$sDataProcesses &= $runProcesses[$i][8]& "|" ;Execution State
	$sDataProcesses &= $runProcesses[$i][9]& "|" ;Handle
	$sDataProcesses &= $runProcesses[$i][10]& "|" ;Handle Count
	$sDataProcesses &= $runProcesses[$i][11]& "|" ;Kernel Mode Time
	$sDataProcesses &= $runProcesses[$i][12]& "|" ;Maximum Working Set Size
	$sDataProcesses &= $runProcesses[$i][13]& "|" ;Minimum Working Set Size
	;$sDataProcesses &= $runProcesses[$i][14]& "|" ;OS Creation Class Name
	;$sDataProcesses &= $runProcesses[$i][15]& "|" ;OS Name
	$sDataProcesses &= $runProcesses[$i][16]& "|" ;Other Operation Count
	$sDataProcesses &= $runProcesses[$i][17]& "|" ;Other Transfer Count
	$sDataProcesses &= $runProcesses[$i][18]& "|" ;Page Faults
	$sDataProcesses &= $runProcesses[$i][19]& "|" ;Page File Usage
	$sDataProcesses &= $runProcesses[$i][20]& "|" ;Parent Process ID
	$sDataProcesses &= $runProcesses[$i][21]& "|" ;Peak Page File Usage
	$sDataProcesses &= $runProcesses[$i][22]& "|" ;Peak Virtual Size
	$sDataProcesses &= $runProcesses[$i][23]& "|" ;Peak Working Set Size
	$sDataProcesses &= $runProcesses[$i][24]& "|" ;Priority
	$sDataProcesses &= $runProcesses[$i][25]& "|" ;Private Page Count
	$sDataProcesses &= $runProcesses[$i][26]& "|" ;Process ID
	$sDataProcesses &= $runProcesses[$i][27]& "|" ;Quota Non Paged Pool Usage
	$sDataProcesses &= $runProcesses[$i][28]& "|" ;Quota Paged Pool Usage
	$sDataProcesses &= $runProcesses[$i][29]& "|" ;Quota Peak Non Paged Pool Usage
	$sDataProcesses &= $runProcesses[$i][30]& "|" ;Quota Peak Paged Pool Usage
	$sDataProcesses &= $runProcesses[$i][31]& "|" ;Read Operation Count
	$sDataProcesses &= $runProcesses[$i][32]& "|" ;Read Transfer Count
	$sDataProcesses &= $runProcesses[$i][33]& "|" ;Session ID
	$sDataProcesses &= $runProcesses[$i][34]& "|" ;Status
	$sDataProcesses &= $runProcesses[$i][35]& "|" ;Thread Count
	;$sDataProcesses &= $runProcesses[$i][36]& "|" ;User Mode Time
	;$sDataProcesses &= $runProcesses[$i][37]& "|" ;Virtual Size
	$sDataProcesses &= $runProcesses[$i][38]& "|" ;Windows Version
	$sDataProcesses &= $runProcesses[$i][39]& "|" ;Working Set Size
	$sDataProcesses &= $runProcesses[$i][40]& "|" ;Write Operation Count
	$sDataProcesses &= $runProcesses[$i][41]& "|" ;Write Transfer Count
	GUICtrlCreateListViewItem($sDataProcesses, $ListViewProcess)
	GUICtrlSetBkColor(-1, $colorEven)
Next
EndFunc
Func getPrintJobs()
	$ListViewPrint = GUICtrlCreateListView("Name | DataType | Document | Drive Name | Description | " & _
	"Elapsed Time | Print Queue | Job ID | Status | Job Name | Notify | Owner | " & _
	"Pages Printed | Parameters | Print Processor | Priority | Size | Start Time | Status | " & _
	"Status Mask | Time Submitted | Total Pages | Until Time ", 10, 75, 775, 600)
	GUICtrlSetBkColor($ListViewPrint, $GUI_BKCOLOR_LV_ALTERNATE)
	GUICtrlSetBkColor($ListViewPrint, $colorOdd)
	Dim $PrintJob
	_ComputerGetPrintJobs($PrintJob)
For $i = 1 To $PrintJob[0][0] Step 1
	$sDataPrint = $PrintJob[$i][0] & "|" ;Name
	$sDataPrint &= $PrintJob[$i][1] & "|" ;DataType
	$sDataPrint &= $PrintJob[$i][2] & "|" ;Document
	$sDataPrint &= $PrintJob[$i][3] & "|" ;DriverName
	$sDataPrint &= $PrintJob[$i][4] & "|" ;Description
	$sDataPrint &= $PrintJob[$i][5] & "|" ;ElapsedTime
	$sDataPrint &= $PrintJob[$i][6] & "|" ;HostPrintQueue
	$sDataPrint &= $PrintJob[$i][7] & "|" ;JobId
	$sDataPrint &= $PrintJob[$i][8] & "|" ;JobStatus
	$sDataPrint &= $PrintJob[$i][9] & "|" ;Name
	$sDataPrint &= $PrintJob[$i][10] & "|" ;Notify
	$sDataPrint &= $PrintJob[$i][11] & "|" ;Owner
	$sDataPrint &= $PrintJob[$i][12] & "|" ;PagesPrinted
	$sDataPrint &= $PrintJob[$i][13] & "|" ;Parameters
	$sDataPrint &= $PrintJob[$i][14] & "|" ;PrintProcessor
	$sDataPrint &= $PrintJob[$i][15] & "|" ;Priority
	$sDataPrint &= $PrintJob[$i][16] & "|" ;Size
	$sDataPrint &= $PrintJob[$i][17] & "|" ;StartTime
	$sDataPrint &= $PrintJob[$i][18] & "|" ;Status
	$sDataPrint &= $PrintJob[$i][19] & "|" ;StatusMask
	$sDataPrint &= $PrintJob[$i][20] & "|" ;TimeSubmitted
	$sDataPrint &= $PrintJob[$i][21] & "|" ;TotalPages
	$sDataPrint &= $PrintJob[$i][22] & "|" ;UntilTime
	GUICtrlCreateListViewItem($sDataPrint, $ListViewPrint)
	GUICtrlSetBkColor(-1, $colorEven)
	
Next
EndFunc
Func getDisplay()
	$ListViewDesktop = GUICtrlCreateListView("Monitor # | Border Width | Cool Switch | Cursor Blink Rate | Description | " & _
	"Drag Full Windows | Gid Granularity | Icon Spacing | Icon Title Face Name | Icon Title Size | Icon Title Wrap | Pattern | " & _
	"Screen Saver Active | Screen Saver Exe | Screen Saver Secure | Screen Saver Timeout | Setting ID | Wallpapter | " & _
	"Wallpaper Stretched | Wallpaper Tiled", 10, 75, 775, 600)
	GUICtrlSetBkColor($ListViewDesktop, $GUI_BKCOLOR_LV_ALTERNATE)
	GUICtrlSetBkColor($ListViewDesktop, $colorOdd)
	Dim $Desktop
	_ComputerGetDesktops($Desktop)
For $i = 1 To $Desktop[0][0] Step 1
	$sDataDesktop = $i & "|" ;Monitor #
	$sDataDesktop &= $Desktop[$i][1] & "|" ;Border Width
	$sDataDesktop &= $Desktop[$i][2] & "|" ;Cool Switch
	$sDataDesktop &= $Desktop[$i][3] & "|" ;Cursor Blink Rate
	$sDataDesktop &= $Desktop[$i][4] & "|" ;Description
	$sDataDesktop &= $Desktop[$i][5] & "|" ;Drag Full Windows
	$sDataDesktop &= $Desktop[$i][6] & "|" ;Grid Granularity
	$sDataDesktop &= $Desktop[$i][7] & "|" ;Icon Spacing
	$sDataDesktop &= $Desktop[$i][8] & "|" ;Icon Title Face Name
	$sDataDesktop &= $Desktop[$i][9] & "|" ;Icon Title Size
	$sDataDesktop &= $Desktop[$i][10] & "|" ;Icon Title Wrap
	$sDataDesktop &= $Desktop[$i][0] & "|" ;Pattern
	$sDataDesktop &= $Desktop[$i][11] & "|" ;Screen Saver Active
	$sDataDesktop &= $Desktop[$i][12] & "|" ;Screen Saver Executable
	$sDataDesktop &= $Desktop[$i][13] & "|" ;Screen Saver Secure
	$sDataDesktop &= $Desktop[$i][14] & "|" ;Screen Saver Timeout
	$sDataDesktop &= $Desktop[$i][15] & "|" ;Setting ID
	$sDataDesktop &= $Desktop[$i][16] & "|" ;Wallpaper
	$sDataDesktop &= $Desktop[$i][17] & "|" ;Wallpaper Stretched
	$sDataDesktop &= $Desktop[$i][18] & "|" ;Wallpaper Tiled
	GUICtrlCreateListViewItem($sDataDesktop, $ListViewDesktop)
	GUICtrlSetBkColor(-1, $colorEven)
Next
EndFunc

Func getBios()
	GUICtrlCreateGraphic(5, 35, 600, 600)
	GUICtrlSetBkColor(-1, 0xffffff)
    GUICtrlSetColor(-1, 0)
	Dim $BIOS
	_ComputerGetBIOS($BIOS)
For $i = 1 To $BIOS[0][0] Step 1
	GUICtrlCreateLabel("--------BIOS INFORMATION--------", 25, 40, 600, 20)
	GUICtrlCreateLabel($BIOS[$i][0], 25, 60, 250, 20)
	GUICtrlCreateLabel("Status: " & $BIOS[$i][1], 25, 80, 600, 20)
	GUICtrlCreateLabel("Characteristics: " & $BIOS[$i][2], 25, 100, 600, 20)
	GUICtrlCreateLabel("Version: " & $BIOS[$i][3], 25, 120, 600, 20)
	GUICtrlCreateLabel("Description: " & $BIOS[$i][4], 25, 140, 600, 20)
	GUICtrlCreateLabel("Build Number: " & $BIOS[$i][5], 25, 160, 600, 20)
	GUICtrlCreateLabel("Code Set: " & $BIOS[$i][6], 25, 180, 600, 20)
	GUICtrlCreateLabel("ID Code: " & $BIOS[$i][8], 25, 200, 600, 20)
	GUICtrlCreateLabel("Manufacturer: " & $BIOS[$i][12], 25, 220, 600, 20)
	GUICtrlCreateLabel("Other Target OS: " & $BIOS[$i][13], 25, 240, 600, 20)
	GUICtrlCreateLabel("Primary BIOS: " & $BIOS[$i][14], 25, 260, 600, 20)
	GUICtrlCreateLabel("Release Date: " & $BIOS[$i][15], 25, 280, 600, 20)
	GUICtrlCreateLabel("Serial Number: " & $BIOS[$i][16], 25, 300, 600, 20)
	GUICtrlCreateLabel("SM BIOS Version: " & $BIOS[$i][17], 25, 320, 600, 20)
	GUICtrlCreateLabel("SM Major Version: " & $BIOS[$i][18], 25, 340, 600, 20)
	GUICtrlCreateLabel("SM Minor Version: " & $BIOS[$i][19], 25, 360, 600, 20)
	GUICtrlCreateLabel("SM Present: " & $BIOS[$i][20], 25, 380, 600, 20)
	GUICtrlCreateLabel("Software Element ID: " & $BIOS[$i][21], 25, 400, 600, 20)
	GUICtrlCreateLabel("Software Element State: " & $BIOS[$i][22], 25, 420, 600, 20)
	GUICtrlCreateLabel("Target OS: " & $BIOS[$i][23], 25, 440, 600, 20)
	GUICtrlCreateLabel("Version: " & $BIOS[$i][24], 25, 460, 600, 20)
Next
EndFunc
Func GetServices()
	$ListViewServices = GUICtrlCreateListView("# | SERVICE | DEPENDANT ON", 10, 75, 775, 600)
	GUICtrlSetBkColor($ListViewServices, $GUI_BKCOLOR_LV_ALTERNATE)
	GUICtrlSetBkColor($ListViewServices, $colorOdd)
	Dim $DependantService
	_ComputerGetDependantServices($DependantService)
For $i = 1 To $DependantService[0][0] Step 1
	$dependancyName = _StringBetween($DependantService[$i][0], 'Name="', '"')
	$serviceName = _StringBetween($DependantService[$i][1], 'Name="', '"')
	$sDataService = $i & "|" ;Service #
	$sDataService &= $serviceName[0] & "|" ;Service Name
	$sDataService &= $dependancyName[0] & "|" ;Dependancy Name
	GUICtrlCreateListViewItem($sDataService, $ListViewServices)
	GUICtrlSetBkColor(-1, $colorEven)
Next
EndFunc