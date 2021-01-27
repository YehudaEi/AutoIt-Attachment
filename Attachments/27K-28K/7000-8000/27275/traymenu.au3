; ****************
; * First sample *
; ****************

#Include <Constants.au3>
#Include <memstats.au3>
#Include <String.au3>
#Include <config.au3>
#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include <CompInfo.au3>
#include <Array.au3>
#NoTrayIcon

Opt("TrayMenuMode",1)   ; Default tray menu items (Script Paused/Exit) will not be shown.
$computerInfo = TrayCreateMenu("ComputerInfo")
TrayCreateItem("")
$shortcuts = TrayCreateMenu("Directories")
TrayCreateItem("")
$tools = TrayCreateMenu("Tools")
TrayCreateItem("")
$diag = TrayCreateMenu("Diagnostics")
TrayCreateItem("")
$commonCommands = TrayCreateMenu("Common Commands")
TrayCreateItem("")
$exit   = TrayCreateItem("Exit")

;----------------------------Common Windows Commands -----------------------------------
$commandMSconfig = TrayCreateItem("MSCONFIG", $commonCommands)
TrayCreateItem("", $commonCommands)
$commandPrompt = TrayCreateItem("Command Prompt", $commonCommands)
TrayCreateItem("", $commonCommands)
$commandRegedit = TrayCreateItem("Registry Editor", $commonCommands)
TrayCreateItem("", $commonCommands)
$commandTaskManager = TrayCreateItem("Task Manager", $commonCommands)
TrayCreateItem("", $commonCommands)
$commandAddRemovePrograms = TrayCreateItem("Add/Remove Programs", $commonCommands)
TrayCreateItem("", $commonCommands)
;----------------------------Shortcut Directories---------------------------------------
$rootShortcut = TrayCreateItem($drive, $shortcuts)
TrayCreateItem("", $shortcuts)
$desktopShortcut = TrayCreateItem("Desktop", $shortcuts)
$documentsShortcut = TrayCreateItem("My Documents", $shortcuts)
$favoritesShortcut = TrayCreateItem("Favorites", $shortcuts)
$programsShortcut = TrayCreateItem("Programs", $shortcuts)
$profileShortcut = TrayCreateItem("Profile", $shortcuts)
TrayCreateItem("", $shortcuts)
$system32Shortcut = TrayCreateItem("System32", $shortcuts)
$windowsShortcut = TrayCreateItem("Windows", $shortcuts)
TrayCreateItem("", $shortcuts)
$ProgramtempDirShortcut = TrayCreateItem($name & " Temp Directory ", $shortcuts)
$tempShortcut = TrayCreateItem("Temp Directory", $shortcuts)

;----------------------------Diagnostics Menu--------------------------------------------
$memoryStats = TrayCreateItem("Memory Status", $diag)
TrayCreateItem("",$diag)
$internetTest = TrayCreateItem("Internet Connection Test", $diag)
$internetConfig = TrayCreateItem("Internet Configuration", $diag)
;----------------------------Tools Menu--------------------------------------------------
$avg = TrayCreateItem("AVG Anti-Virus", $tools)
TrayCreateItem("", $tools)
$hijackthis = TrayCreateItem("Hijackthis",$tools)
$malwarebytes = TrayCreateItem("MalwareBytes Anti-Malware", $tools)
$combofix = TrayCreateItem("Combofix", $tools)
$drwebcureit = TrayCreateItem("Dr Web Cureit", $tools)
$sdfix = TrayCreateItem("SDFix", $tools)
TrayCreateItem("", $tools)
$cleanup = TrayCreateItem("Cleanup", $tools)
$daemontools = TrayCreateItem("Deamon Tools", $tools)
$processexplorer = TrayCreateItem("Process Explorer", $tools)
TraySetState()
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
;----------------------------Computer Info----------------------------------------------
;Drive Info
$computerDrives = TrayCreateMenu("Hard Drives", $computerInfo)
	TrayCreateItem("", $shortcuts)
	Dim $Drives
	_ComputerGetDrives($Drives) ;Defaults to "FIXED"
	Dim $totalDrives
	For $totalDrives = 1 To $Drives[0][0] Step 1
		$totalDrives = $totalDrives + 1
	Next
	TrayCreateItem("", $computerDrives)
	TrayCreateItem("Total Drives Found: " & ($totalDrives - 1), $computerDrives)
	TrayCreateItem("", $computerDrives)
	For $i = 1 To $Drives[0][0] Step 1
		TrayCreateItem("-------------DRIVE #" & $i & "----------------", $computerDrives)
		TrayCreateItem("Label: " & $Drives[$i][2], $computerDrives)
		TrayCreateItem("Drive: " & $Drives[$i][0], $computerDrives)
		TrayCreateItem("FileSystem: " & $Drives[$i][1], $computerDrives)
		TrayCreateItem("SerialNumber: " & $Drives[$i][3], $computerDrives)
		TrayCreateItem("Free Space: " & Round($Drives[$i][4] / 1024, 2) & "GB", $computerDrives)
		TrayCreateItem("Total Space: " & Round($Drives[$i][5] / 1024, 2) & "GB", $computerDrives)
		TrayCreateItem("", $computerDrives)
	Next
;Bios Info
$biosMenu = TrayCreateMenu("Bios", $computerInfo)
Dim $BIOS
_ComputerGetBIOS($BIOS)
For $i = 1 To $BIOS[0][0] Step 1
	TrayCreateItem("", $biosMenu)
	TrayCreateItem("BIOS INFORMATION", $biosMenu)
	TrayCreateItem("", $biosMenu)
	;TrayCreateItem("Name: " & $BIOS[$i][0], $biosMenu)
	TrayCreateItem("Status: " & $BIOS[$i][1], $biosMenu)
	TrayCreateItem("Characteristics: " & $BIOS[$i][2], $biosMenu)
	TrayCreateItem("Version: " & $BIOS[$i][3], $biosMenu)
	;TrayCreateItem("Description: " & $BIOS[$i][4], $biosMenu)
	TrayCreateItem("Build Number: " & $BIOS[$i][5], $biosMenu)
	TrayCreateItem("Code Set: " & $BIOS[$i][6], $biosMenu)
	TrayCreateItem("ID Code: " & $BIOS[$i][8], $biosMenu)
	TrayCreateItem("Manufacturer: " & $BIOS[$i][12], $biosMenu)
	TrayCreateItem("Other Target OS: " & $BIOS[$i][13], $biosMenu)
	TrayCreateItem("Primary BIOS: " & $BIOS[$i][14], $biosMenu)
	TrayCreateItem("Release Date: " & $BIOS[$i][15], $biosMenu)
	TrayCreateItem("Serial Number: " & $BIOS[$i][16], $biosMenu)
	TrayCreateItem("SM BIOS Version: " & $BIOS[$i][17], $biosMenu)
	TrayCreateItem("SM Major Version: " & $BIOS[$i][18], $biosMenu)
	TrayCreateItem("SM Minor Version: " & $BIOS[$i][19], $biosMenu)
	TrayCreateItem("SM Present: " & $BIOS[$i][20], $biosMenu)
	;TrayCreateItem("Software Element ID: " & $BIOS[$i][21], $biosMenu)
	TrayCreateItem("Software Element State: " & $BIOS[$i][22], $biosMenu)
	TrayCreateItem("Target OS: " & $BIOS[$i][23], $biosMenu)
	TrayCreateItem("Version: " & $BIOS[$i][24], $biosMenu)
Next
; Dependant Serivices
$dependantServiceMenu = TrayCreateMenu("Dependant Services", $computerInfo)
Dim $DependantService
_ComputerGetDependantServices($DependantService)
TrayCreateItem("", $dependantServiceMenu)
TrayCreateItem("SERVICE INFORMATION", $dependantServiceMenu)
TrayCreateItem("", $dependantServiceMenu)
For $i = 1 To $DependantService[0][0] Step 1
	$dependancyName = _StringBetween($DependantService[$i][0], 'Name="', '"')
	$serviceName = _StringBetween($DependantService[$i][1], 'Name="', '"')
	TrayCreateItem("SERVICE: " & $serviceName[0] & " | DEPENDANT ON: " & $dependancyName[0], $dependantServiceMenu)
	TrayCreateItem("", $dependantServiceMenu)
Next
;Desktop
$desktopMenu = TrayCreateMenu("Monitor Information", $computerInfo)
Dim $Desktop
_ComputerGetDesktops($Desktop)
TrayCreateItem("", $desktopMenu)
TrayCreateItem("MONITOR INFORMATION", $desktopMenu)
TrayCreateItem("", $desktopMenu)
For $i = 1 To $Desktop[0][0] Step 1
	TrayCreateItem("--------------------Monitor #" & $i & "-------------------", $desktopMenu)
	TrayCreateItem("Border Width: " & $Desktop[$i][1], $desktopMenu)
	TrayCreateItem("Cool Switch: " & $Desktop[$i][2], $desktopMenu)
	TrayCreateItem("Cursor Blink Rate: " & $Desktop[$i][3], $desktopMenu)
	TrayCreateItem("Description: " & $Desktop[$i][4], $desktopMenu)
	TrayCreateItem("Drag Full Windows: " & $Desktop[$i][5], $desktopMenu)
	TrayCreateItem("Grid Granularity: " & $Desktop[$i][6], $desktopMenu)
	TrayCreateItem("Icon Spacing: " & $Desktop[$i][7], $desktopMenu)
	TrayCreateItem("Icon Title Face Name: " & $Desktop[$i][8], $desktopMenu)
	TrayCreateItem("Icon Title Size: " & $Desktop[$i][9], $desktopMenu)
	TrayCreateItem("Icon Title Wrap: " & $Desktop[$i][10], $desktopMenu)
	TrayCreateItem("Pattern: " & $Desktop[$i][0], $desktopMenu)
	TrayCreateItem("Screen Saver Active: " & $Desktop[$i][11], $desktopMenu)
	TrayCreateItem("Screen Saver Executable: " & $Desktop[$i][12], $desktopMenu)
	TrayCreateItem("Screen Saver Secure: " & $Desktop[$i][13], $desktopMenu)
	TrayCreateItem("Screen Saver Timeout: " & $Desktop[$i][14], $desktopMenu)
	TrayCreateItem("Setting ID: " & $Desktop[$i][15], $desktopMenu)
	TrayCreateItem("Wallpaper: " & $Desktop[$i][16], $desktopMenu)
	;TrayCreateItem("Wallpaper Stretched: " & $Desktop[$i][17], $desktopMenu)
	TrayCreateItem("Wallpaper Tiled: " & $Desktop[$i][18], $desktopMenu)
	TrayCreateItem("", $desktopMenu)
Next
;OS Info
Dim $OSs
$osMenu = TrayCreateMenu("System Information", $computerInfo)
_ComputerGetOSs($OSs)
For $i = 1 To $OSs[0][0] Step 1
	$osName = "Name" & $OSs[$i][0]
	$arrayOsName = _StringBetween($osName, "Name", "|");
	TrayCreateItem("", $osMenu)
	TrayCreateItem("--------OPERATING SYSTEM INFO------", $osMenu)
	TrayCreateItem("Name: " & $arrayOsName[0], $osMenu)
	TrayCreateItem("Manufacturer: " & $OSs[$i][28], $osMenu)
	TrayCreateItem("Build Number: " & $OSs[$i][2], $osMenu)
	TrayCreateItem("Build Type: " & $OSs[$i][3], $osMenu)
	TrayCreateItem("Bit Type: " & $OSs[$i][8], $osMenu)
	TrayCreateItem("Computer Version: " & $OSs[$i][9], $osMenu)
	TrayCreateItem("Computer Name: " & $OSs[$i][10], $osMenu)
	TrayCreateItem("Install Date: " & $OSs[$i][23], $osMenu)
	TrayCreateItem("Registered User: " & $OSs[$i][45], $osMenu)
	TrayCreateItem("Serial Number: " & $OSs[$i][46], $osMenu)
	TrayCreateItem("Service Pack Major Version: " & $OSs[$i][47], $osMenu)
	TrayCreateItem("Service Pack Minor Version: " & $OSs[$i][48], $osMenu)
	TrayCreateItem("Version: " & $OSs[$i][58], $osMenu)
	TrayCreateItem("Windows Directory: " & $OSs[$i][59], $osMenu)
	TrayCreateItem("Suite Mask: " & $OSs[$i][51], $osMenu)
	TrayCreateItem("Number Of Users: " & $OSs[$i][33], $osMenu)
	TrayCreateItem("", $osMenu)
	TrayCreateItem("-----------ROOT DRIVE INFO--------", $osMenu)
	TrayCreateItem("System Device: " & $OSs[$i][52], $osMenu)
	TrayCreateItem("System Directory: " & $OSs[$i][53], $osMenu)
	TrayCreateItem("System Drive: " & $OSs[$i][54], $osMenu)
	TrayCreateItem("", $osMenu)
	TrayCreateItem("-----------MEMORY STATS-----------", $osMenu)
	TrayCreateItem("Free Physical Memory: " & Round($OSs[$i][20]/1024,1) & "MB", $osMenu)
	TrayCreateItem("Free Space In Paging Files: " & Round($OSs[$i][21]/1024,1) & "MB", $osMenu)
	TrayCreateItem("Free Virtual Memory: " & Round($OSs[$i][22]/1024,1) & "MB", $osMenu)
	TrayCreateItem("Total Swap Space Size: " & Round($OSs[$i][55]/1024,1) & "MB", $osMenu)
	TrayCreateItem("Total Virtual Memory Size: " & Round($OSs[$i][56]/1024,1) & "MB", $osMenu)
	TrayCreateItem("Total Visible Memory Size: " & Round($OSs[$i][57]/1024,1) & "MB", $osMenu)
	TrayCreateItem("Size Stored In Paging Files: " & Round($OSs[$i][49]/1024,1) & "MB", $osMenu)
	TrayCreateItem("Number Of Processes: " & $OSs[$i][32], $osMenu)
	TrayCreateItem("", $osMenu)
	TrayCreateItem("-----------TIME INFORMATION-----------", $osMenu)
	TrayCreateItem("Last Boot Up Time: " & $OSs[$i][25], $osMenu)
	TrayCreateItem("Local Date Time: " & $OSs[$i][26], $osMenu)
	TrayCreateItem("Locale: " & $OSs[$i][27], $osMenu)
	TrayCreateItem("", $osMenu)
	;TrayCreateItem("Large System Cache: " & $OSs[$i][24], $osMenu)
	;TrayCreateItem("Current Time Zone: " & $OSs[$i][11], $osMenu)
	;TrayCreateItem("Data Execution Prevention_32BitApplications: " & $OSs[$i][12], $osMenu)
	;TrayCreateItem("Data Execution Prevention_Available: " & $OSs[$i][13], $osMenu)
	;TrayCreateItem("Data Execution Prevention_Drivers: " & $OSs[$i][14], $osMenu)
	;TrayCreateItem("Data Execution Prevention_SupportPolicy: " & $OSs[$i][15], $osMenu)
	;TrayCreateItem("Debug: " & $OSs[$i][16], $osMenu)
	;TrayCreateItem("Distributed: " & $OSs[$i][17], $osMenu)
	;TrayCreateItem("Encryption Level: " & $OSs[$i][18], $osMenu)
	;TrayCreateItem("Foreground Application Boost: " & $OSs[$i][19], $osMenu)
	;TrayCreateItem("Max Number Of Processes: " & $OSs[$i][29], $osMenu)
	;TrayCreateItem("Number Of Licensed Users: " & $OSs[$i][31], $osMenu)
	;TrayCreateItem("Organization: " & $OSs[$i][34], $osMenu)
	;TrayCreateItem("OS Language: " & $OSs[$i][35], $osMenu)
	;TrayCreateItem("OS Product Suite: " & $OSs[$i][36], $osMenu)
	;TrayCreateItem("OS Type: " & $OSs[$i][37], $osMenu)
	;TrayCreateItem("Other Type Description: " & $OSs[$i][38], $osMenu)
	;TrayCreateItem("Plus Product ID: " & $OSs[$i][39], $osMenu)
	;TrayCreateItem("Plus Version Number: " & $OSs[$i][40], $osMenu)
	;TrayCreateItem("Primary: " & $OSs[$i][41], $osMenu)
	;TrayCreateItem("Product Type: " & $OSs[$i][42], $osMenu)
	;TrayCreateItem("Quantum Length: " & $OSs[$i][43], $osMenu)
	;TrayCreateItem("Quantum Type: " & $OSs[$i][44], $osMenu)
	;TrayCreateItem("Status: " & $OSs[$i][50], $osMenu)
Next
;Printing Jobs
$printMenu = TrayCreateMenu("Printing Jobs", $computerInfo)
Dim $PrintJob
_ComputerGetPrintJobs($PrintJob)
TrayCreateItem("----------------------PRINT JOBS---------------------", $printMenu)
TrayCreateItem("", $printMenu)
For $i = 1 To $PrintJob[0][0] Step 1
	TrayCreateItem("Name: " & $PrintJob[$i][0], $printMenu)
	TrayCreateItem("DataType: " & $PrintJob[$i][1], $printMenu)
	TrayCreateItem("Document: " & $PrintJob[$i][2], $printMenu)
	TrayCreateItem("DriverName: " & $PrintJob[$i][3], $printMenu)
	TrayCreateItem("Description: " & $PrintJob[$i][4], $printMenu)
	TrayCreateItem("ElapsedTime: " & $PrintJob[$i][5], $printMenu)
	TrayCreateItem("HostPrintQueue: " & $PrintJob[$i][6], $printMenu)
	TrayCreateItem("JobId: " & $PrintJob[$i][7], $printMenu)
	TrayCreateItem("JobStatus: " & $PrintJob[$i][8], $printMenu)
	TrayCreateItem("Name: " & $PrintJob[$i][9], $printMenu)
	TrayCreateItem("Notify: " & $PrintJob[$i][10], $printMenu)
	TrayCreateItem("Owner: " & $PrintJob[$i][11], $printMenu)
	TrayCreateItem("PagesPrinted: " & $PrintJob[$i][12], $printMenu)
	TrayCreateItem("Parameters: " & $PrintJob[$i][13], $printMenu)
	TrayCreateItem("PrintProcessor: " & $PrintJob[$i][14], $printMenu)
	TrayCreateItem("Priority: " & $PrintJob[$i][15], $printMenu)
	TrayCreateItem("Size: " & $PrintJob[$i][16], $printMenu)
	TrayCreateItem("StartTime: " & $PrintJob[$i][17], $printMenu)
	TrayCreateItem("Status: " & $PrintJob[$i][18], $printMenu)
	TrayCreateItem("StatusMask: " & $PrintJob[$i][19], $printMenu)
	TrayCreateItem("TimeSubmitted: " & $PrintJob[$i][20], $printMenu)
	TrayCreateItem("TotalPages: " & $PrintJob[$i][21], $printMenu)
	TrayCreateItem("UntilTime: " & $PrintJob[$i][22], $printMenu)
	TrayCreateItem("", $printMenu)
Next
;RunningProcesses
$runProcMenu = TrayCreateMenu("Running Processes", $computerInfo)
Dim $runProcesses
_ComputerGetProcesses($runProcesses)
TrayCreateItem("----------------------RUNNING PROCESSES---------------------", $runProcMenu)
TrayCreateItem("", $runProcMenu)
For $i = 1 To $runProcesses[0][0] Step 1
	TrayCreateItem("Name: " & $runProcesses[$i][0], $runProcMenu)
	TrayCreateItem("Command Line: " & $runProcesses[$i][1], $runProcMenu)
	TrayCreateItem("Creation Class Name: " & $runProcesses[$i][2], $runProcMenu)
	TrayCreateItem("Creation Date: " & $runProcesses[$i][3], $runProcMenu)
	TrayCreateItem("Description: " & $runProcesses[$i][4], $runProcMenu)
	TrayCreateItem("CS Creation Class Name: " & $runProcesses[$i][5], $runProcMenu)
	TrayCreateItem("CS Name: " & $runProcesses[$i][6], $runProcMenu)
	TrayCreateItem("Executable Path: " & $runProcesses[$i][7], $runProcMenu)
	TrayCreateItem("Execution State: " & $runProcesses[$i][8], $runProcMenu)
	TrayCreateItem("Handle: " & $runProcesses[$i][9], $runProcMenu)
	TrayCreateItem("Handle Count: " & $runProcesses[$i][10], $runProcMenu)
	TrayCreateItem("Kernel Mode Time: " & $runProcesses[$i][11], $runProcMenu)
	TrayCreateItem("Maximum Working Set Size: " & $runProcesses[$i][12], $runProcMenu)
	TrayCreateItem("Minimum Working Set Size: " & $runProcesses[$i][13], $runProcMenu)
	TrayCreateItem("OS Creation Class Name: " & $runProcesses[$i][14], $runProcMenu)
	TrayCreateItem("OS Name: " & $runProcesses[$i][15], $runProcMenu)
	TrayCreateItem("Other Operation Count: " & $runProcesses[$i][16], $runProcMenu)
	TrayCreateItem("Other Transfer Count: " & $runProcesses[$i][17], $runProcMenu)
	TrayCreateItem("Page Faults: " & $runProcesses[$i][18], $runProcMenu)
	TrayCreateItem("Page File Usage: " & $runProcesses[$i][19], $runProcMenu)
	TrayCreateItem("Parent Process ID: " & $runProcesses[$i][20], $runProcMenu)
	TrayCreateItem("Peak Page File Usage: " & $runProcesses[$i][21], $runProcMenu)
	TrayCreateItem("Peak Virtual Size: " & $runProcesses[$i][22], $runProcMenu)
	TrayCreateItem("Peak Working Set Size: " & $runProcesses[$i][23], $runProcMenu)
	TrayCreateItem("Priority: " & $runProcesses[$i][24], $runProcMenu)
	TrayCreateItem("Private Page Count: " & $runProcesses[$i][25], $runProcMenu)
	TrayCreateItem("Process ID: " & $runProcesses[$i][26], $runProcMenu)
	TrayCreateItem("Quota Non Paged Pool Usage: " & $runProcesses[$i][27], $runProcMenu)
	TrayCreateItem("Quota Paged Pool Usage: " & $runProcesses[$i][28], $runProcMenu)
	TrayCreateItem("Quota Peak Non Paged Pool Usage: " & $runProcesses[$i][29], $runProcMenu)
	TrayCreateItem("Quota Peak Paged Pool Usage: " & $runProcesses[$i][30], $runProcMenu)
	TrayCreateItem("Read Operation Count: " & $runProcesses[$i][31], $runProcMenu)
	TrayCreateItem("Read Transfer Count: " & $runProcesses[$i][32], $runProcMenu)
	TrayCreateItem("Session ID: " & $runProcesses[$i][33], $runProcMenu)
	TrayCreateItem("Status: " & $runProcesses[$i][34], $runProcMenu)
	TrayCreateItem("Thread Count: " & $runProcesses[$i][35], $runProcMenu)
	TrayCreateItem("User Mode Time: " & $runProcesses[$i][36], $runProcMenu)
	TrayCreateItem("Virtual Size: " & $runProcesses[$i][37], $runProcMenu)
	TrayCreateItem("Windows Version: " & $runProcesses[$i][38], $runProcMenu)
	TrayCreateItem("Working Set Size: " & $runProcesses[$i][39], $runProcMenu)
	TrayCreateItem("Write Operation Count: " & $runProcesses[$i][40], $runProcMenu)
	TrayCreateItem("Write Transfer Count: " & $runProcesses[$i][41], $runProcMenu)
Next
While 1
    $msg = TrayGetMsg()
    Select
        Case $msg = 0
            ContinueLoop
		Case $msg = $commandMSconfig
			If @OSVersion = "WIN_VISTA" Then
				$path = @SystemDir & "\msconfig.exe"
			EndIf
			If @OSVersion = "WIN_XP" Then
				$path = @WindowsDir & "\PCHEALTH\HELPCTR\Binaries\msconfig"
			EndIf
			Run($path)
		Case $msg = $commandAddRemovePrograms
			Run("appwiz.cpl")
		Case $msg = $commandPrompt
			Run (@SystemDir & "\cmd.exe")
		Case $msg = $commandRegedit
			Run (@SystemDir & "\regedt32.exe")
		Case $msg = $commandTaskManager
			Run (@SystemDir & "\taskmgr.exe")
		Case $msg = $ProgramTempDirShortcut
			Run("explorer.exe /n,/e,," & $tempDir)
		Case $msg = $desktopShortcut
			Run("explorer.exe /n,/e,," & @DesktopDir)
		Case $msg = $documentsShortcut
			Run("explorer.exe /n,/e,," & @MyDocumentsDir)
		Case $msg = $tempShortcut
			Run("explorer.exe /n,/e,," & @TempDir)
		Case $msg = $favoritesShortcut
			Run("explorer.exe /n,/e,," & @FavoritesDir)
		Case $msg = $programsShortcut
			Run("explorer.exe /n,/e,," & @ProgramFilesDir)
		Case $msg = $profileShortcut
			Run("explorer.exe /n,/e,," & @UserProfileDir)
		Case $msg = $system32Shortcut
			Run("explorer.exe /n,/e,," & @SystemDir)
		Case $msg = $windowsShortcut
			Run("explorer.exe /n,/e,," & @WindowsDir)
		Case $msg = $rootShortcut
			Run("explorer.exe /n,/e,," & $drive)
		Case $msg = $memoryStats
				TrayItemSetOnEvent( $memoryStats, MemStats())
		Case $msg = $internetTest
			dim $var
			$var = ping("google.com", 2000)
			if $var > '1' Then
				msgbox(0, "Internet Connection Test", "You Are Connected to the Internet")
			Else
				msgBox(0, "Internet Connection Test", "No Connection to the Internet")
			EndIf
		Case $msg = $InternetConfig
				$IP = TCPNameToIP("checkIp.dyndns.org")
				$hCon = TCPConnect($IP, 80)
				TCPSEND($hCon, "GET / HTTP/1.1" & @CRLF & "HOST: checkip.dyndns.org" & @CRLF & @CRLF)
				Do
					$sRecv = TCPRecv($hCon, 1024)
				Until $sRecv <> ''
				$externalIP = _StringBetween($sRecv, "Address:", "</body>") 
				msgBox(0, "IP Information", "External IP Address: " & $externalIP[0])
			Case $msg = $hijackthis
				$dfile = "hijackthis.exe"
				$durl = $toolsDir & $dfile
				$dname = "HijackThis"
				InetGet ($toolsDir & $dfile, $dfile, 1, 1)
				DownloadingMessage($dname, $dfile, $durl)
			Case $msg = $malwarebytes
				$dfile = "mbamsetup.exe"
				$durl = $toolsDir & $dfile
				$dname = "MalwareBytes Anti-Malware"
				InetGet ($toolsDir & $dfile, $dfile, 1, 1)
				DownloadingMessage($dname, $dfile, $durl)
		Case $msg = $combofix
				$dfile = "combofix.exe"
				$durl = $toolsDir & $dfile
				$dname = "Combo Fix"
				InetGet ($toolsDir & $dfile, $dfile, 1, 1)
				DownloadingMessage($dname, $dfile, $durl)
		Case $msg = $avg
				$dfile = "avg.exe"
				$durl = $toolsDir & $dfile
				$dname = "AVG Anti-Virus"
				InetGet ($toolsDir & $dfile, $dfile, 1, 1)
				DownloadingMessage($dname, $dfile, $durl)
		Case $msg = $cleanup
				$dfile = "cleanup.exe"
				$durl = $toolsDir & $dfile
				$dname = "Cleanup"
				InetGet ($toolsDir & $dfile, $dfile, 1, 1)
				DownloadingMessage($dname, $dfile, $durl)
		Case $msg = $daemontools
				$dfile = "daemontools.exe"
				$durl = $toolsDir & $dfile
				$dname = "Daemon Tools"
				InetGet ($toolsDir & $dfile, $dfile, 1, 1)
				DownloadingMessage($dname, $dfile, $durl)
		Case $msg = $drwebcureit
				$dfile = "drwebcureit.exe"
				$durl = $toolsDir & $dfile
				$dname = "Dr. Web CureIt"
				InetGet ($toolsDir & $dfile, $dfile, 1, 1)
				DownloadingMessage($dname, $dfile, $durl)
		Case $msg = $processexplorer
				$dfile = "procexplorer.exe"
				$durl = $toolsDir & $dfile
				$dname = "Process Explorer"
				InetGet ($toolsDir & $dfile, $dfile, 1, 1)
				DownloadingMessage($dname, $dfile, $durl)
		Case $msg = $sdfix
				$dfile = "sdfix.exe"
				$durl = $toolsDir & $dfile
				$dname = "SDFix"
				InetGet ($toolsDir & $dfile, $dfile, 1, 1)
				DownloadingMessage($dname, $dfile, $durl)
		Case $msg = $exit
       ExitLoop
   EndSelect
WEnd

Exit
