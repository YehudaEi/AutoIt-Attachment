#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=favicon.ico
#AutoIt3Wrapper_Compression=4
#AutoIt3Wrapper_Res_Description=Script to install all needed software on new computers
#AutoIt3Wrapper_Res_Fileversion=0.3.0.4
#AutoIt3Wrapper_Res_FileVersion_AutoIncrement=y
#AutoIt3Wrapper_Res_SaveSource=y
#AutoIt3Wrapper_Res_Language=1033
#AutoIt3Wrapper_res_requestedExecutionLevel=requireAdministrator
#AutoIt3Wrapper_Run_Tidy=y
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

#Region Include Statements
#include <GUIConstants.au3>
#EndRegion Include Statements

#Region Variable Declarations
$programTitle = "AutoInstaller"
$iniFile = "autoinstaller.ini"
$iniSections = IniRead($iniFile, "Global", "IniSections", "3")
$serverName = "\\" & IniRead($iniFile, "Global", "ServerName", "")
$installFolder = $serverName & "\" & IniRead($iniFile, "Global", "InstallFolder", "install")
$patchesFolder = $serverName & "\" & IniRead($iniFile, "Global", "PatchesFolder", "patches")
$installDrive = IniRead($iniFile, "Global", "InstallDrive", "Z:")
$patchesDrive = IniRead($iniFile, "Global", "patchesDrive", "Y:")
$patchesSetup = IniReadSection($iniFile, "Patches")
$installSetup = IniReadSection($iniFile, "Installs")
$copyLocation = "D:\BIN"
$BaseX = 20
$BaseY = 15
$CurX = 0
$CurY = 0

Dim $driveMapErrors[6]
$driveMapErrors[0] = "Undefined or Other"
$driveMapErrors[1] = "Access to the remote share was denied"
$driveMapErrors[2] = "The device is already assigned"
$driveMapErrors[3] = "Invalid device name"
$driveMapErrors[4] = "Invalid remote share"
$driveMapErrors[5] = "Invalid password"
#EndRegion Variable Declarations

Opt("TrayIconHide", 1)

$hGUI = GUICreate($programTitle, 280, 210)
Opt("GUICoordMode", 1)

#Region Drop-Down Menu
$fileMenu = GUICtrlCreateMenu("&File")
$iniLoadMenuItem = GUICtrlCreateMenuItem("&Load Ini File", $fileMenu)
$exitProgramMenuItem = GUICtrlCreateMenuItem("E&xit", $fileMenu)
$helpMenu = GUICtrlCreateMenu("&Help")
$aboutMenuItem = GUICtrlCreateMenuItem("About...", $helpMenu)
#EndRegion Drop-Down Menu

#Region Create GUI
$CurX = $BaseX
$CurY = $BaseY

$computerTypeHomeRadio = GUICtrlCreateRadio("Home System", $CurX, $CurY)
$CurY += 25
$computerTypeWorkRadio = GUICtrlCreateRadio("Business System", $CurX, $CurY)
$CurY += 35
GUICtrlCreateLabel("Destination for BIN directory:", $CurX, $CurY)
$CurY += 20
$copyLocationInput = GUICtrlCreateInput($copyLocation, $CurX, $CurY, 150)
$CurX += 160
$browseCopyLocation = GUICtrlCreateButton("Browse...", $CurX, $CurY - 3)
$CurX = $BaseX
$CurY += 45
$executeButton = GUICtrlCreateButton("Install Software", $CurX, $CurY)
$CurX += 135
$exitButton = GUICtrlCreateButton("Exit Program", $CurX, $CurY)
#EndRegion Create GUI

GUISetState()
GUICtrlSetState($computerTypeHomeRadio, $GUI_DISABLE)
GUICtrlSetState($computerTypeWorkRadio, $GUI_DISABLE)
; Run the GUI until the dialog is closed
Do
	$msg = GUIGetMsg()

	Switch $msg
		Case $aboutMenuItem
			MsgBox(0, "AutoInstaller", "Version: " & FileGetVersion("AutoInstaller.exe"))

		Case $exitProgramMenuItem
			$msg = $GUI_EVENT_CLOSE

		Case $exitButton
			$msg = $GUI_EVENT_CLOSE

		Case $iniLoadMenuItem
			$iniFile = FileOpenDialog("Select config file", @ScriptDir, "INI files (*.ini)", 1)
			If $iniFile Then
				LoadINIFile()
			EndIf

		Case $browseCopyLocation
			$copyLocation = browseFolder()
			If StringCompare($copyLocation, "") <> 0 Then
				GUICtrlSetData($copyLocationInput, $copyLocation)
			Else
				$copyLocation = GUICtrlRead($copyLocationInput)
			EndIf

		Case $executeButton
			modCallingWindow("AutoInstaller.exe", @SW_MINIMIZE)
			ProgressOn("Installing patches and software...", "Mapping Network Drives...")
			$temp = MapDrives()
			If $temp = 1 Then
				ProgressSet(10, "", "Installing Windows patches...")
				For $i = 1 To $patchesSetup[0][0]
					;MsgBox(0, "", $patchesFolder & '\' & $patchesSetup[$i][1] & @LF & $patchesSetup[$i][0])
					ProgressSet($i, "Installing " & $patchesSetup[$i][0])
					$PID = Run($patchesFolder & '\' & $patchesSetup[$i][1], $patchesFolder)
					ProcessWaitClose($PID)
				Next
				ProgressSet(33, "Copying install folder to " & $copyLocation)
				;MsgBox(0, "", "Copy from " & $installFolder & " to " & $copyLocation)
				DirCopy($installFolder, $copyLocation, 1)
				ProgressSet(66, "Installing Software...")
				For $i = 1 To $installSetup[0][0]
					;MsgBox(0, "", $installFolder & '\' & $installSetup[$i][1] & @LF & $installSetup[$i][0])
					ProgressSet(33 + $i, "Installing " & $installSetup[$i][0])
					$PID = Run($installFolder & '\' & $installSetup[$i][1], $installFolder)
					ProcessWaitClose($PID)
				Next
				ProgressSet(100, "Done", "Completed!")
				Sleep(3000)
				ProgressOff()
				modCallingWindow("AutoInstaller.exe", @SW_RESTORE)
				MsgBox(64, "Completed Installation", "Successfully completed installation and copying procedures...")
			Else
				MsgBox(48, "Failed Networking!", "Networking drives to install directories failed...")
			EndIf

	EndSwitch
Until $msg = $GUI_EVENT_CLOSE

DriveMapDel($installDrive)
DriveMapDel($patchesDrive)
GUIDelete()

#Region General Functions
Func browseFolder()
	Local $tempFolder = ""
	$tempFolder = FileSelectFolder("Select Location for BIN Directory:", "")
	Return $tempFolder
EndFunc   ;==>browseFolder

Func LoadINIFile()
	;determine whether the sections with in the ini file are correct for this particular ini load
	$iniSectionList = IniReadSectionNames($iniFile)
	If $iniSectionList[0] = $iniSections And $iniSectionList[1] = "Global" Then
		$loadINI = MsgBox(1, "Loading INI File...", "This will change all initialized data (including networking data)", 3)
		$serverName = "\\" & IniRead($iniFile, "Global", "ServerName", "")
		$installFolder = $serverName & IniRead($iniFile, "Global", "InstallFolder", "")
		$patchesFolder = $serverName & IniRead($iniFile, "Global", "PatchesFolder", "")
		$installDrive = IniRead($iniFile, "Global", "InstallDrive", "Z:\")
		$patchesDrive = IniRead($iniFile, "Global", "patchesDrive", "Y:\")
		$patchesSetup = IniReadSection($iniFile, "Patches")
		$installSetup = IniReadSection($iniFile, "Installs")
	Else
		MsgBox(48, "Invalid Program INI File", "The file you selected does not contain the proper formatting for loading as an INI file")
	EndIf
EndFunc   ;==>LoadINIFile

Func IsVisible($handle)
	If BitAND(WinGetState($handle), 2) Then
		Return 1
	Else
		Return 0
	EndIf
EndFunc   ;==>IsVisible

Func modCallingWindow($title, $state)
	Local $activeWindowList = WinList()
	Local $windowNumber = 0
	For $i = 1 To $activeWindowList[0][0]
		If $activeWindowList[$i][0] <> "" And IsVisible($activeWindowList[$i][1]) Then
			Local $windowTitle = StringTrimLeft($activeWindowList[$i][0], StringLen($activeWindowList[$i][0]) - StringLen($title))
			If $windowTitle = $title Then
				$windowNumber = $i
				WinSetState($activeWindowList[$i][0], "", $state)
			EndIf
		EndIf
	Next
EndFunc   ;==>modCallingWindow
#EndRegion General Functions

#Region Networking Functions
Func MapDrives()
	DriveMapDel($installDrive)
	DriveMapDel($patchesDrive)
	$res = DriveMapAdd($installDrive, $installFolder)
	If $res <> 1 Then
		SplashOff()
		MsgBox(16, "Drive Mapping", "Error mapping drive!" & @LF & "Error Code: " & $driveMapErrors[@error])
		Return $res
	EndIf
	$res = DriveMapAdd($patchesDrive, $patchesFolder)
	If $res <> 1 Then
		SplashOff()
		MsgBox(16, "Drive Mapping", "Error mapping drive!" & @LF & "Error Code: " & $driveMapErrors[@error])
		Return $res
	EndIf
	Return $res
EndFunc   ;==>MapDrives
#EndRegion Networking Functions
