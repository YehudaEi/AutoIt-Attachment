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
getToolsMenu()
TraySetState()
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
			getBios()
			$serviceTab = GUICtrlCreateTabItem("Services")
			getServices()
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
		Case $msg = $exit
       ExitLoop
   EndSelect
WEnd
Exit
