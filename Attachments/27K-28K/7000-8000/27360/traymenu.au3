#include <GUIConstantsEx.au3>
#include <Constants.au3>
#include <WindowsConstants.au3>
#include <ListViewConstants.au3>
#include <String.au3>
#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <Array.au3>
#include <GUIListBox.au3>
#include <TabConstants.au3>
#include <CompInfo.au3>
#include <config.au3>
#include <memstats.au3>
#include <functionsSystemInfo.au3>
#NoTrayIcon

Opt("TrayMenuMode",1)   ; Default tray menu items (Script Paused/Exit) will not be shown.
$sysInfo = TrayCreateItem("System Information")
TrayCreateItem("")
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
$DumpFile = @TempDir & "\files.txt"
InetGet($toolsDir&"files.txt", $DumpFile);
$sDatabaseRaw = FileRead($DumpFile)
$asDatabase = StringSplit($sDatabaseRaw,"^",3)
For $element In $asDatabase
	If $element = "" Then ContinueLoop
	$asItem = StringSplit($element,',',3)
	$toolsDirName = $asItem[0]
	$toolsDirMenu = TrayCreateMenu($toolsDirName, $tools)
	For $toolsFile In $asItem
		If $toolsFile = "" Or $toolsFile = $toolsDirName Then ContinueLoop
			
			TrayCreateItem($toolsFile, $toolsDirMenu)
	Next
Next
;$avg = TrayCreateItem("AVG Anti-Virus", $tools)
;TrayCreateItem("", $tools)
;$hijackthis = TrayCreateItem("Hijackthis",$tools)
;$malwarebytes = TrayCreateItem("MalwareBytes Anti-Malware", $tools)
;$combofix = TrayCreateItem("Combofix", $tools)
;$drwebcureit = TrayCreateItem("Dr Web Cureit", $tools)
;$sdfix = TrayCreateItem("SDFix", $tools)
;TrayCreateItem("", $tools)
;$cleanup = TrayCreateItem("Cleanup", $tools)
;$daemontools = TrayCreateItem("Deamon Tools", $tools)
;$processexplorer = TrayCreateItem("Process Explorer", $tools)
;$lspfix = TrayCreateItem("LSPFix", $tools)
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
While 1
    $msg = TrayGetMsg()
    Select
        Case $msg = 0
            ContinueLoop
		Case $msg = $sysInfo
			#Region ### START Koda GUI section ### Form=
			$frmSysInfo = GUICreate("System Information", 800, 700)
			GUICtrlCreateTab(10,10,850,20)
			;Create System Tabs
			$driveTab = GUICtrlCreateTabItem("Hard Drives")
			GetDriveInfo()
			$biosTab = GUICtrlCreateTabItem("Bios")
			;getBios()
			$serviceTab = GUICtrlCreateTabItem("Services")
			;getServices()
			$processTab = GUICtrlCreateTabItem("Running Processes")
			getRunningProcesses()
			$displayTab = GUICtrlCreateTabItem("Display")
			getDisplay()
			$systemTab = GUICtrlCreateTabItem("System")
			GetSystemInfo()
			$printTab = GUICtrlCreateTabItem("Print")
			GetPrintJobs()
			GUISetState(@SW_SHOW, $frmSysInfo)
			#EndRegion ### END Koda GUI section ###
			While 1
				If GUIGetMsg() = -3 Then 
					ExitLoop
				EndIf
			WEnd
			GuiSetState(@SW_HIDE, $frmSysInfo)
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
			MemStats()
				;TrayItemSetOnEvent( $memoryStats, MemStats())
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
		Case $msg = TrayCreateItem($toolsFile)
			$dfile = $toolsFile
			$durl = $toolsDir & $toolsDirName & "/" & $dfile
			$dname = $toolsFile
			InetGet ($toolsDir & $dfile, $dfile, 1, 1)
			DownloadingMessage($dname, $dfile, $durl)
;		Case $msg = $hijackthis
;				$dfile = "hijackthis.exe"
;				$durl = $toolsDir & $dfile
;				$dname = "HijackThis"
;				InetGet ($toolsDir & $dfile, $dfile, 1, 1)
;				DownloadingMessage($dname, $dfile, $durl)
;		Case $msg = $malwarebytes
;				$dfile = "mbamsetup.exe"
;				$durl = $toolsDir & $dfile
;				$dname = "MalwareBytes Anti-Malware"
;				InetGet ($toolsDir & $dfile, $dfile, 1, 1)
;				DownloadingMessage($dname, $dfile, $durl)
;		Case $msg = $lspfix
;				$dfile = "lspfix.exe"
;				$durl = $toolsDir & $dfile
;				$dname = "LSPFix"
;				InetGet ($toolsDir & $dfile, $dfile, 1, 1)
;				DownloadingMessage($dname, $dfile, $durl)
;		Case $msg = $combofix
;				$dfile = "combofix.exe"
;				$durl = $toolsDir & $dfile
;				$dname = "Combo Fix"
;				InetGet ($toolsDir & $dfile, $dfile, 1, 1)
;				DownloadingMessage($dname, $dfile, $durl)
;		Case $msg = $avg
;				$dfile = "avg.exe"
;				$durl = $toolsDir & $dfile
;				$dname = "AVG Anti-Virus"
;				InetGet ($toolsDir & $dfile, $dfile, 1, 1)
;				DownloadingMessage($dname, $dfile, $durl)
;		Case $msg = $cleanup
;				$dfile = "cleanup.exe"
;				$durl = $toolsDir & $dfile
;				$dname = "Cleanup"
;				InetGet ($toolsDir & $dfile, $dfile, 1, 1)
;				DownloadingMessage($dname, $dfile, $durl)
;		Case $msg = $daemontools
;				$dfile = "daemontools.exe"
;				$durl = $toolsDir & $dfile
;				$dname = "Daemon Tools"
;				InetGet ($toolsDir & $dfile, $dfile, 1, 1)
;				DownloadingMessage($dname, $dfile, $durl)
;		Case $msg = $drwebcureit
;				$dfile = "drwebcureit.exe"
;				$durl = $toolsDir & $dfile
;				$dname = "Dr. Web CureIt"
;				InetGet ($toolsDir & $dfile, $dfile, 1, 1)
;				DownloadingMessage($dname, $dfile, $durl)
;		Case $msg = $processexplorer
;				$dfile = "procexplorer.exe"
;				$durl = $toolsDir & $dfile
;				$dname = "Process Explorer"
;				InetGet ($toolsDir & $dfile, $dfile, 1, 1)
;				DownloadingMessage($dname, $dfile, $durl)
;		Case $msg = $sdfix
;				$dfile = "sdfix.exe"
;				$durl = $toolsDir & $dfile
;				$dname = "SDFix"
;				InetGet ($toolsDir & $dfile, $dfile, 1, 1)
;				DownloadingMessage($dname, $dfile, $durl)
		Case $msg = $exit
       ExitLoop
   EndSelect
WEnd
Exit
