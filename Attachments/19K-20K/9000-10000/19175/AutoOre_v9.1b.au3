#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=Icons\eve1.ico
#AutoIt3Wrapper_Outfile=AutoOre v9.1b.exe
#AutoIt3Wrapper_Compression=4
#AutoIt3Wrapper_Res_Language=1033
#AutoIt3Wrapper_Res_Icon_Add=Icons\play.ico
#AutoIt3Wrapper_Res_Icon_Add=Icons\pause.ico
#AutoIt3Wrapper_Res_Icon_Add=Icons\stop.ico
#AutoIt3Wrapper_Au3Check_Stop_OnWarning=y
#AutoIt3Wrapper_Run_Tidy=y
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
;; ----------------------------------------------------------------------------
;;
;; AutoIt Version: 3.2.11.1
;; Author: SixWingedFreak
;;
;; Script Function:
;;	AutoOre v9.1b
;;	1600x900 Window mode
;;
;; ----------------------------------------------------------------------------
;; ----------------------------------------
;; Prerequisites
;; ----------------------------------------
#include <ButtonConstants.au3>
#include <ComboConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <SliderConstants.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
Opt("MouseCoordMode", 2)
Opt("PixelCoordMode", 2)
Opt("TrayAutoPause", 0)
Opt("TrayMenuMode", 1)
HotKeySet("{PAUSE}", "HotKeyPause")
HotKeySet("{END}", "HotKeyStop")
;; ----------------------------------------
;; Variables
;; ----------------------------------------
Global $Version = "9.1b"
Global $Paused
Global $FirstRun = 1
Global $CheckWait = 5
Global $EVELocation = RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\EVE", "InstallLocation") & "\"
Global $LogOn
Global $EVEPass
Global $EVEPassSave
Global $EVEWait
Global $LogOff
Global $LogOffDT
Global $LogOffHH
Global $LogOffMM
Global $MouseSpeed
Global $Lasers
Global $Targets
Global $Drones
Global $Bookmark
Global $BookmarkWait
Global $LockWait
Global $DockTime
Global $MiningCheck
Global $MiningTimer
Global $MiningTime
Global $RepeatAmount
Global $RepeatCounter
;; ----------------------------------------
;; Coordinates
;; ----------------------------------------
Global $ClientCenter[2]
Global $EnterGame[2]
Global $Undock[2]
Global $Triangle[2]
Global $PeoplePlacesOpen[2]
Global $PeoplePlacesClose[2]
Global $Bookmark0[2]
Global $Bookmark1[2]
Global $Bookmark2[2]
Global $Bookmark3[2]
Global $Bookmark4[2]
Global $Bookmark5[2]
Global $Bookmark0Dock1[2]
Global $Bookmark0Dock2[2]
Global $Bookmark1Warp[2]
Global $Bookmark2Warp[2]
Global $Bookmark3Warp[2]
Global $Bookmark4Warp[2]
Global $Bookmark5Warp[2]
Global $WarpCheck[2]
Global $DroneBay[2]
Global $DroneSpace[2]
Global $LaunchDrones[2]
Global $ReturnDrones[2]
Global $OverviewItem1[2]
Global $OverviewItem2[2]
Global $OverviewItem3[2]
Global $OverviewItem4[2]
Global $OverviewItem5[2]
Global $OverviewItem6[2]
Global $Target1[2]
Global $Target2[2]
Global $Target3[2]
Global $Target4[2]
Global $Target5[2]
Global $Target6[2]
Global $LaserIcon1[2]
Global $LaserIcon2[2]
Global $LaserIcon3[2]
Global $LaserIcon4[2]
Global $LaserIcon5[2]
Global $LaserIcon6[2]
Global $CargoBay[2]
Global $CargoBayItem1[2]
Global $StationPanel[2]
$ClientCenter[0] = 800
$ClientCenter[1] = 450
$EnterGame[0] = 1538
$EnterGame[1] = 802
$Undock[0] = 17
$Undock[1] = 868
$Triangle[0] = 51
$Triangle[1] = 42
$PeoplePlacesOpen[0] = 16
$PeoplePlacesOpen[1] = 173
$PeoplePlacesClose[0] = 527
$PeoplePlacesClose[1] = 9
$Bookmark0[0] = 82
$Bookmark0[1] = 136
$Bookmark1[0] = 82
$Bookmark1[1] = 155
$Bookmark2[0] = 82
$Bookmark2[1] = 174
$Bookmark3[0] = 82
$Bookmark3[1] = 193
$Bookmark4[0] = 82
$Bookmark4[1] = 212
$Bookmark5[0] = 82
$Bookmark5[1] = 231
$Bookmark0Dock1[0] = 106
$Bookmark0Dock1[1] = 179
$Bookmark0Dock2[0] = 106
$Bookmark0Dock2[1] = 164
$Bookmark1Warp[0] = 106
$Bookmark1Warp[1] = 165
$Bookmark2Warp[0] = 106
$Bookmark2Warp[1] = 184
$Bookmark3Warp[0] = 106
$Bookmark3Warp[1] = 203
$Bookmark4Warp[0] = 106
$Bookmark4Warp[1] = 222
$Bookmark5Warp[0] = 106
$Bookmark5Warp[1] = 241
$WarpCheck[0] = 740
$WarpCheck[1] = 663
$DroneBay[0] = 1343
$DroneBay[1] = 755
$DroneSpace[0] = 1343
$DroneSpace[1] = 774
$LaunchDrones[0] = 1367
$LaunchDrones[1] = 782
$ReturnDrones[0] = 1367
$ReturnDrones[1] = 831
$OverviewItem1[0] = 1347
$OverviewItem1[1] = 182
$OverviewItem2[0] = 1347
$OverviewItem2[1] = 201
$OverviewItem3[0] = 1347
$OverviewItem3[1] = 220
$OverviewItem4[0] = 1347
$OverviewItem4[1] = 239
$OverviewItem5[0] = 1347
$OverviewItem5[1] = 258
$OverviewItem6[0] = 1347
$OverviewItem6[1] = 277
$Target1[0] = 1231
$Target1[1] = 67
$Target2[0] = 1133
$Target2[1] = 67
$Target3[0] = 1035
$Target3[1] = 67
$Target4[0] = 937
$Target4[1] = 67
$Target5[0] = 839
$Target5[1] = 67
$Target6[0] = 741
$Target6[1] = 67
$LaserIcon1[0] = 1277
$LaserIcon1[1] = 48
$LaserIcon2[0] = 1179
$LaserIcon2[1] = 48
$LaserIcon3[0] = 1081
$LaserIcon3[1] = 48
$LaserIcon4[0] = 983
$LaserIcon4[1] = 48
$LaserIcon5[0] = 885
$LaserIcon5[1] = 48
$LaserIcon6[0] = 787
$LaserIcon6[1] = 48
$CargoBay[0] = 47
$CargoBay[1] = 427
$CargoBayItem1[0] = 87
$CargoBayItem1[1] = 468
$StationPanel[0] = 1347
$StationPanel[1] = 471
;; ----------------------------------------
;; Pixel Colors
;; ----------------------------------------
$EnterGameColor = "3F3F3F"
$UndockColor = "50DF20"
$TriangleColor = "E6E6E6"
$WarpCheckColor = "B71B00"
$DroneColor = "96F2FF"
$MiningCheckColor = "000000"
;; ----------------------------------------
;; Main GUI
;; ----------------------------------------
$GUI_EVE_Main = GUICreate("AutoOre v" & $Version, 701, 401, -1, -1)
GUISetFont(8, 400, 0, "Verdana")
$GUI_EVE_ClientSettingsGroup = GUICtrlCreateGroup("EVE Client Settings", 4, 16, 225, 365)
$GUI_EVE_LocationLabel = GUICtrlCreateLabel("Location:", 20, 36, 56, 17)
$GUI_EVE_Location = GUICtrlCreateInput("", 20, 56, 193, 21, $ES_READONLY)
$GUI_EVE_LogOn = GUICtrlCreateCheckbox("Log on", 20, 104, 61, 17)
$GUI_EVE_PassLabel = GUICtrlCreateLabel("Password:", 20, 136, 63, 17)
$GUI_EVE_Pass = GUICtrlCreateInput("", 20, 156, 113, 21, $ES_PASSWORD)
$GUI_EVE_PassSave = GUICtrlCreateCheckbox("Save password", 20, 184, 109, 17)
$GUI_EVE_WaitLabel = GUICtrlCreateLabel("Startup delay:", 20, 216, 86, 17)
$GUI_EVE_Wait = GUICtrlCreateInput("", 20, 236, 49, 21, $ES_NUMBER)
$GUI_EVE_LogOff = GUICtrlCreateCheckbox("Log off when finished", 20, 276, 145, 17)
$GUI_EVE_LogOffDT = GUICtrlCreateCheckbox("Log off at downtime", 20, 300, 137, 17)
$GUI_EVE_DowntimeLabel = GUICtrlCreateLabel("Log off at:", 20, 328, 122, 17)
$GUI_EVE_LogOffHH = GUICtrlCreateCombo("", 20, 348, 65, 25, $CBS_DROPDOWNLIST)
GUICtrlSetData(-1, "00|01|02|03|04|05|06|07|08|09|10|11|12|13|14|15|16|17|18|19|20|21|22|23|24", $LogOffHH)
$GUI_EVE_LogOffMM = GUICtrlCreateCombo("", 96, 348, 65, 25, $CBS_DROPDOWNLIST)
GUICtrlSetData(-1, "00|05|10|15|20|25|30|35|40|45|50|55", $LogOffMM)
GUICtrlCreateGroup("", -99, -99, 1, 1)
$GUI_EVE_GeneralSettingsGroup = GUICtrlCreateGroup("General Settings", 236, 16, 225, 365)
$GUI_EVE_MouseSpeedLabel = GUICtrlCreateLabel("Mouse speed:", 252, 36, 83, 17)
$GUI_EVE_MouseSpeed = GUICtrlCreateSlider(252, 56, 145, 41)
GUICtrlSetLimit(-1, 100, 0)
$GUI_EVE_MouseSpeedInput = GUICtrlCreateInput("", 400, 60, 49, 21, BitOR($ES_NUMBER, $ES_READONLY))
GUICtrlSetLimit(-1, 3)
$GUI_EVE_LasersLabel = GUICtrlCreateLabel("Lasers:", 252, 96, 46, 17)
$GUI_EVE_Lasers = GUICtrlCreateSlider(316, 96, 98, 18)
GUICtrlSetLimit(-1, 6, 1)
$GUI_EVE_LasersInput = GUICtrlCreateInput("", 420, 96, 29, 21, BitOR($ES_NUMBER, $ES_READONLY))
GUICtrlSetLimit(-1, 1)
$GUI_EVE_TargetsLabel = GUICtrlCreateLabel("Targets:", 252, 128, 52, 17)
$GUI_EVE_Targets = GUICtrlCreateSlider(316, 128, 98, 18)
GUICtrlSetLimit(-1, 6, 1)
$GUI_EVE_TargetsInput = GUICtrlCreateInput("", 420, 128, 29, 21, BitOR($ES_NUMBER, $ES_READONLY))
GUICtrlSetLimit(-1, 1)
$GUI_EVE_Drones = GUICtrlCreateCheckbox("Attack/Defense Drones", 284, 156, 165, 17, BitOR($BS_RIGHTBUTTON, $BS_RIGHT))
$GUI_EVE_BookmarkLabel = GUICtrlCreateLabel("Bookmark:", 296, 208, 68, 17)
$GUI_EVE_Bookmark = GUICtrlCreateCombo("", 364, 204, 85, 25, $CBS_DROPDOWNLIST)
GUICtrlSetData(-1, "1|2|3|4|5|Random", $Bookmark)
$GUI_EVE_BookmarkWaitLabel = GUICtrlCreateLabel("Bookmark delay:", 296, 240, 103, 17)
$GUI_EVE_BookmarkWait = GUICtrlCreateInput("", 400, 236, 49, 21, $ES_NUMBER)
$GUI_EVE_LockWaitLabel = GUICtrlCreateLabel("Lock delay:", 328, 300, 70, 17)
$GUI_EVE_LockWait = GUICtrlCreateInput("", 400, 296, 49, 21, $ES_NUMBER)
$GUI_EVE_DockTimeLabel = GUICtrlCreateLabel("Dock fix delay:", 308, 352, 91, 17)
$GUI_EVE_DockTime = GUICtrlCreateInput("", 400, 348, 49, 21, $ES_NUMBER)
GUICtrlCreateGroup("", -99, -99, 1, 1)
$GUI_EVE_MiningSettingsGroup = GUICtrlCreateGroup("Mining Settings", 468, 16, 229, 229)
$GUI_EVE_MiningCheck = GUICtrlCreateRadio("Intelligent Mining", 572, 36, 117, 17, BitOR($BS_RIGHTBUTTON, $BS_RIGHT))
$GUI_EVE_MiningTimer = GUICtrlCreateRadio("Timed Mining", 576, 60, 113, 17, BitOR($BS_RIGHTBUTTON, $BS_RIGHT))
$GUI_EVE_MiningTimeLabel = GUICtrlCreateLabel("Mining time:", 564, 88, 74, 17)
$GUI_EVE_MiningTime = GUICtrlCreateInput("", 640, 84, 49, 21, $ES_NUMBER)
$GUI_EVE_RepeatAmountLabel = GUICtrlCreateLabel("Repeat amount:", 544, 216, 96, 17)
$GUI_EVE_RepeatAmount = GUICtrlCreateInput("", 640, 212, 49, 21, $ES_NUMBER)
GUICtrlCreateGroup("", -99, -99, 1, 1)
$GUI_EVE_SaveSettingsButton = GUICtrlCreateButton("Save Settings", 468, 252, 229, 61)
$GUI_EVE_LoadSettingsButton = GUICtrlCreateButton("Load Settings", 468, 320, 229, 61)
GUICtrlCreateGroup("", -99, -99, 1, 1)
GUISetState(@SW_SHOW)
;; ----------------------------------------
;; Toolbar GUI
;; ----------------------------------------
$GUI_EVE_Toolbar = GUICreate("", 118, 38, -1, 975, BitOR($WS_BORDER, $WS_POPUP), $WS_EX_TOOLWINDOW)
GUISetFont(8, 400, 0, "Verdana")
$GUI_EVE_StartButton = GUICtrlCreateButton("", 1, 1, 36, 36, BitOR($BS_ICON, $BS_FLAT))
GUICtrlSetImage(-1, @ScriptFullPath, -4)
$GUI_EVE_PauseButton = GUICtrlCreateCheckbox("", 41, 1, 36, 36, BitOR($BS_ICON, $BS_FLAT, $BS_PUSHLIKE))
GUICtrlSetImage(-1, @ScriptFullPath, -5)
$GUI_EVE_StopButton = GUICtrlCreateButton("", 81, 1, 36, 36, BitOR($BS_ICON, $BS_FLAT))
GUICtrlSetImage(-1, @ScriptFullPath, -6)
GUISetState(@SW_SHOW)
WinSetOnTop("", "", 1)
;; ----------------------------------------
;; Tray Icon
;; ----------------------------------------
TraySetToolTip("AutoOre v" & $Version)
$TrayRunEVE = TrayCreateItem("Run EVE Online")
$TrayOptions = TrayCreateItem("Options")
TrayCreateItem("")
$TrayExit = TrayCreateItem("Exit")
TraySetState()
;; ----------------------------------------
;; Run GUI
;; ----------------------------------------
LoadSettings()
While 1
	$tMsg = TrayGetMsg()
	$gMsg = GUIGetMsg()
	Switch $tMsg
		Case $TrayRunEVE
			Run($EVELocation & "eve.exe")
		Case $TrayOptions
			WinSetState("AutoOre v" & $Version, "", @SW_RESTORE)
		Case $TrayExit
			Exit
	EndSwitch
	Switch $gMsg
		Case $GUI_EVENT_MINIMIZE
			WinSetState("AutoOre v" & $Version, "", @SW_HIDE)
		Case $GUI_EVENT_CLOSE
			Exit
		Case $GUI_EVE_LogOn
			If GUICtrlRead($GUI_EVE_LogOn) = $GUI_UNCHECKED Then
				GUICtrlSetState($GUI_EVE_Pass, $GUI_DISABLE)
				GUICtrlSetState($GUI_EVE_PassSave, $GUI_DISABLE)
				GUICtrlSetState($GUI_EVE_Wait, $GUI_DISABLE)
			ElseIf GUICtrlRead($GUI_EVE_LogOn) = $GUI_CHECKED Then
				GUICtrlSetState($GUI_EVE_Pass, $GUI_ENABLE)
				GUICtrlSetState($GUI_EVE_PassSave, $GUI_ENABLE)
				GUICtrlSetState($GUI_EVE_Wait, $GUI_ENABLE)
			EndIf
		Case $GUI_EVE_LogOffDT
			If GUICtrlRead($GUI_EVE_LogOffDT) = $GUI_UNCHECKED Then
				GUICtrlSetState($GUI_EVE_LogOffHH, $GUI_DISABLE)
				GUICtrlSetState($GUI_EVE_LogOffMM, $GUI_DISABLE)
			ElseIf GUICtrlRead($GUI_EVE_LogOffDT) = $GUI_CHECKED Then
				GUICtrlSetState($GUI_EVE_LogOffHH, $GUI_ENABLE)
				GUICtrlSetState($GUI_EVE_LogOffMM, $GUI_ENABLE)
			EndIf
		Case $GUI_EVE_MouseSpeed
			GUICtrlSetData($GUI_EVE_MouseSpeedInput, GUICtrlRead($GUI_EVE_MouseSpeed))
		Case $GUI_EVE_Lasers
			GUICtrlSetData($GUI_EVE_LasersInput, GUICtrlRead($GUI_EVE_Lasers))
		Case $GUI_EVE_Targets
			GUICtrlSetData($GUI_EVE_TargetsInput, GUICtrlRead($GUI_EVE_Targets))
		Case $GUI_EVE_MiningCheck
			GUICtrlSetState($GUI_EVE_MiningTime, $GUI_DISABLE)
		Case $GUI_EVE_MiningTimer
			GUICtrlSetState($GUI_EVE_MiningTime, $GUI_ENABLE)
		Case $GUI_EVE_SaveSettingsButton
			SaveSettings()
		Case $GUI_EVE_LoadSettingsButton
			LoadSettings()
		Case $GUI_EVE_StartButton
			WinSetState("AutoOre v" & $Version, "", @SW_HIDE)
			MainLoop()
		Case $GUI_EVE_PauseButton
			If GUICtrlRead($GUI_EVE_PauseButton) = $GUI_CHECKED Then
				$Paused = Not $Paused
				Do
					Sleep(100)
					ToolTip("Paused", 0, 0, "AutoOre v" & $Version)
				Until GUICtrlRead($GUI_EVE_PauseButton) = $GUI_UNCHECKED
				ToolTip("")
			EndIf
		Case $GUI_EVE_StopButton
			Exit
	EndSwitch
WEnd
;; ----------------------------------------
;; MainLoop
;; ----------------------------------------
Func MainLoop()
	CheckGUI()
	LogOn()
	ActivateWindow()
	CenterCursor()
	Do
		Prepare()
		Undock()
		CenterCursor()
		Sleep($CheckWait * 1000)
		UndockCheck()
		WarpToBelt()
		CenterCursor()
		Sleep($CheckWait * 1000)
		WarpToBeltCheck()
		LaunchDrones()
		Target()
		CenterCursor()
		Sleep($LockWait * 1000)
		FireLasers()
		CenterCursor()
		Sleep($CheckWait * 1000)
		MiningCheck()
		MiningTimer()
		ReturnDrones()
		Dock()
		CenterCursor()
		Sleep($CheckWait * 1000)
		DockCheck()
		Sleep(10000)
		MoveCargo()
		CenterCursor()
		Sleep(2000)
		$RepeatCounter = $RepeatCounter + 1
		LogOffDT()
	Until $RepeatCounter = $RepeatAmount
	LogOff()
EndFunc   ;==>MainLoop
;; ----------------------------------------
;; CheckGUI
;; ----------------------------------------
Func CheckGUI()
	$EVELocation = GUICtrlRead($GUI_EVE_Location)
	$LogOn = GUICtrlRead($GUI_EVE_LogOn)
	$EVEPass = GUICtrlRead($GUI_EVE_Pass)
	$EVEPassSave = GUICtrlRead($GUI_EVE_PassSave)
	$EVEWait = GUICtrlRead($GUI_EVE_Wait)
	$LogOff = GUICtrlRead($GUI_EVE_LogOff)
	$LogOffDT = GUICtrlRead($GUI_EVE_LogOffDT)
	$LogOffHH = GUICtrlRead($GUI_EVE_LogOffHH)
	$LogOffMM = GUICtrlRead($GUI_EVE_LogOffMM)
	$MouseSpeed = GUICtrlRead($GUI_EVE_MouseSpeed)
	$Lasers = GUICtrlRead($GUI_EVE_Lasers)
	$Targets = GUICtrlRead($GUI_EVE_Targets)
	$Drones = GUICtrlRead($GUI_EVE_Drones)
	$Bookmark = GUICtrlRead($GUI_EVE_Bookmark)
	$BookmarkWait = GUICtrlRead($GUI_EVE_BookmarkWait)
	$LockWait = GUICtrlRead($GUI_EVE_LockWait)
	$DockTime = GUICtrlRead($GUI_EVE_DockTime)
	$MiningCheck = GUICtrlRead($GUI_EVE_MiningCheck)
	$MiningTimer = GUICtrlRead($GUI_EVE_MiningTimer)
	$MiningTime = GUICtrlRead($GUI_EVE_MiningTime)
	$RepeatAmount = GUICtrlRead($GUI_EVE_RepeatAmount)
EndFunc   ;==>CheckGUI
;; ----------------------------------------
;; SaveSettings
;; ----------------------------------------
Func SaveSettings()
	IniWrite("Settings.ini", "Settings", "EVELocation", GUICtrlRead($GUI_EVE_Location))
	IniWrite("Settings.ini", "Settings", "LogOn", GUICtrlRead($GUI_EVE_LogOn))
	If GUICtrlRead($GUI_EVE_PassSave) = $GUI_CHECKED Then
		IniWrite("Settings.ini", "Settings", "EVEPass", GUICtrlRead($GUI_EVE_Pass))
	ElseIf GUICtrlRead($GUI_EVE_PassSave) = $GUI_UNCHECKED Then
		IniWrite("Settings.ini", "Settings", "EVEPass", "")
	EndIf
	IniWrite("Settings.ini", "Settings", "EVEPassSave", GUICtrlRead($GUI_EVE_PassSave))
	IniWrite("Settings.ini", "Settings", "EVEWait", GUICtrlRead($GUI_EVE_Wait))
	IniWrite("Settings.ini", "Settings", "LogOff", GUICtrlRead($GUI_EVE_LogOff))
	IniWrite("Settings.ini", "Settings", "LogOffDT", GUICtrlRead($GUI_EVE_LogOffDT))
	IniWrite("Settings.ini", "Settings", "LogOffHH", GUICtrlRead($GUI_EVE_LogOffHH))
	IniWrite("Settings.ini", "Settings", "LogOffMM", GUICtrlRead($GUI_EVE_LogOffMM))
	IniWrite("Settings.ini", "Settings", "MouseSpeed", GUICtrlRead($GUI_EVE_MouseSpeed))
	IniWrite("Settings.ini", "Settings", "Lasers", GUICtrlRead($GUI_EVE_Lasers))
	IniWrite("Settings.ini", "Settings", "Targets", GUICtrlRead($GUI_EVE_Targets))
	IniWrite("Settings.ini", "Settings", "Drones", GUICtrlRead($GUI_EVE_Drones))
	IniWrite("Settings.ini", "Settings", "Bookmark", GUICtrlRead($GUI_EVE_Bookmark))
	IniWrite("Settings.ini", "Settings", "BookmarkWait", GUICtrlRead($GUI_EVE_BookmarkWait))
	IniWrite("Settings.ini", "Settings", "LockWait", GUICtrlRead($GUI_EVE_LockWait))
	IniWrite("Settings.ini", "Settings", "DockTime", GUICtrlRead($GUI_EVE_DockTime))
	IniWrite("Settings.ini", "Settings", "MiningCheck", GUICtrlRead($GUI_EVE_MiningCheck))
	IniWrite("Settings.ini", "Settings", "MiningTimer", GUICtrlRead($GUI_EVE_MiningTimer))
	IniWrite("Settings.ini", "Settings", "MiningTime", GUICtrlRead($GUI_EVE_MiningTime))
	IniWrite("Settings.ini", "Settings", "RepeatAmount", GUICtrlRead($GUI_EVE_RepeatAmount))
EndFunc   ;==>SaveSettings
;; ----------------------------------------
;; LoadSettings
;; ----------------------------------------
Func LoadSettings()
	GUICtrlSetData($GUI_EVE_Location, IniRead("Settings.ini", "Settings", "EVELocation", $EVELocation))
	GUICtrlSetState($GUI_EVE_LogOn, IniRead("Settings.ini", "Settings", "LogOn", "0"))
	GUICtrlSetData($GUI_EVE_Pass, IniRead("Settings.ini", "Settings", "EVEPass", ""))
	GUICtrlSetState($GUI_EVE_PassSave, IniRead("Settings.ini", "Settings", "EVEPassSave", "0"))
	GUICtrlSetData($GUI_EVE_Wait, IniRead("Settings.ini", "Settings", "EVEWait", "10"))
	GUICtrlSetState($GUI_EVE_LogOff, IniRead("Settings.ini", "Settings", "LogOff", "1"))
	GUICtrlSetState($GUI_EVE_LogOffDT, IniRead("Settings.ini", "Settings", "LogOffDT", "1"))
	GUICtrlSetData($GUI_EVE_LogOffHH, IniRead("Settings.ini", "Settings", "LogOffHH", "11"))
	GUICtrlSetData($GUI_EVE_LogOffMM, IniRead("Settings.ini", "Settings", "LogOffMM", "00"))
	GUICtrlSetData($GUI_EVE_MouseSpeed, IniRead("Settings.ini", "Settings", "MouseSpeed", "50"))
	GUICtrlSetData($GUI_EVE_MouseSpeedInput, IniRead("Settings.ini", "Settings", "MouseSpeed", "50"))
	GUICtrlSetData($GUI_EVE_Lasers, IniRead("Settings.ini", "Settings", "Lasers", "1"))
	GUICtrlSetData($GUI_EVE_LasersInput, IniRead("Settings.ini", "Settings", "Lasers", "1"))
	GUICtrlSetData($GUI_EVE_Targets, IniRead("Settings.ini", "Settings", "Targets", "1"))
	GUICtrlSetData($GUI_EVE_TargetsInput, IniRead("Settings.ini", "Settings", "Targets", "1"))
	GUICtrlSetState($GUI_EVE_Drones, IniRead("Settings.ini", "Settings", "Drones", "0"))
	GUICtrlSetData($GUI_EVE_Bookmark, IniRead("Settings.ini", "Settings", "Bookmark", "Random"))
	GUICtrlSetData($GUI_EVE_BookmarkWait, IniRead("Settings.ini", "Settings", "BookmarkWait", "1"))
	GUICtrlSetData($GUI_EVE_LockWait, IniRead("Settings.ini", "Settings", "LockWait", "5"))
	GUICtrlSetData($GUI_EVE_DockTime, IniRead("Settings.ini", "Settings", "DockTime", "5"))
	GUICtrlSetState($GUI_EVE_MiningCheck, IniRead("Settings.ini", "Settings", "MiningCheck", "1"))
	GUICtrlSetState($GUI_EVE_MiningTimer, IniRead("Settings.ini", "Settings", "MiningTimer", "0"))
	GUICtrlSetData($GUI_EVE_MiningTime, IniRead("Settings.ini", "Settings", "MiningTime", "0"))
	GUICtrlSetData($GUI_EVE_RepeatAmount, IniRead("Settings.ini", "Settings", "RepeatAmount", "100"))
	If GUICtrlRead($GUI_EVE_LogOn) = $GUI_UNCHECKED Then
		GUICtrlSetState($GUI_EVE_Pass, $GUI_DISABLE)
		GUICtrlSetState($GUI_EVE_PassSave, $GUI_DISABLE)
		GUICtrlSetState($GUI_EVE_Wait, $GUI_DISABLE)
	ElseIf GUICtrlRead($GUI_EVE_LogOn) = $GUI_CHECKED Then
		GUICtrlSetState($GUI_EVE_Pass, $GUI_ENABLE)
		GUICtrlSetState($GUI_EVE_PassSave, $GUI_ENABLE)
		GUICtrlSetState($GUI_EVE_Wait, $GUI_ENABLE)
	EndIf
	If GUICtrlRead($GUI_EVE_LogOffDT) = $GUI_UNCHECKED Then
		GUICtrlSetState($GUI_EVE_LogOffHH, $GUI_DISABLE)
		GUICtrlSetState($GUI_EVE_LogOffMM, $GUI_DISABLE)
	ElseIf GUICtrlRead($GUI_EVE_LogOffDT) = $GUI_CHECKED Then
		GUICtrlSetState($GUI_EVE_LogOffHH, $GUI_ENABLE)
		GUICtrlSetState($GUI_EVE_LogOffMM, $GUI_ENABLE)
	EndIf
	If GUICtrlRead($GUI_EVE_MiningCheck) = $GUI_CHECKED Then
		GUICtrlSetState($GUI_EVE_MiningTime, $GUI_DISABLE)
	ElseIf GUICtrlRead($GUI_EVE_MiningTimer) = $GUI_CHECKED Then
		GUICtrlSetState($GUI_EVE_MiningTime, $GUI_ENABLE)
	EndIf
EndFunc   ;==>LoadSettings
;; ----------------------------------------
;; ActivateWindow
;; ----------------------------------------
Func ActivateWindow()
	WinWait("EVE")
	WinActivate("EVE")
	WinWaitActive("EVE")
EndFunc   ;==>ActivateWindow
;; ----------------------------------------
;; CenterCursor
;; ----------------------------------------
Func CenterCursor()
	MouseMove($ClientCenter[0], $ClientCenter[1], $MouseSpeed)
EndFunc   ;==>CenterCursor
;; ----------------------------------------
;; Prepare
;; ----------------------------------------
Func Prepare()
	Do
		Sleep(100)
	Until PixelGetColor($Undock[0], $Undock[1]) >= Dec($UndockColor)
	If $FirstRun = 1 Then
		MouseClick("left", $ClientCenter[0], $ClientCenter[1], 2, $MouseSpeed)
		MouseClick("left", $PeoplePlacesOpen[0], $PeoplePlacesOpen[1], 1, $MouseSpeed)
		Sleep(5000)
		MouseClick("left", $PeoplePlacesClose[0], $PeoplePlacesClose[1], 1, $MouseSpeed)
		$FirstRun = 0
	EndIf
EndFunc   ;==>Prepare
;; ----------------------------------------
;; Undock
;; ----------------------------------------
Func Undock()
	MouseClick("left", $Undock[0], $Undock[1], 1, $MouseSpeed)
EndFunc   ;==>Undock
;; ----------------------------------------
;; UndockCheck
;; ----------------------------------------
Func UndockCheck()
	Do
		Sleep(100)
	Until PixelGetColor($Triangle[0], $Triangle[1]) = Dec($TriangleColor)
EndFunc   ;==>UndockCheck
;; ----------------------------------------
;; WarpToBelt
;; ----------------------------------------
Func WarpToBelt()
	MouseClick("left", $PeoplePlacesOpen[0], $PeoplePlacesOpen[1], 1, $MouseSpeed)
	Sleep($BookmarkWait * 1000)
	If $Bookmark = "1" Then
		MouseClick("right", $Bookmark1[0], $Bookmark1[1], 1, $MouseSpeed)
		MouseClick("left", $Bookmark1Warp[0], $Bookmark1Warp[1], 1, $MouseSpeed)
	ElseIf $Bookmark = "2" Then
		MouseClick("right", $Bookmark2[0], $Bookmark2[1], 1, $MouseSpeed)
		MouseClick("left", $Bookmark2Warp[0], $Bookmark2Warp[1], 1, $MouseSpeed)
	ElseIf $Bookmark = "3" Then
		MouseClick("right", $Bookmark3[0], $Bookmark3[1], 1, $MouseSpeed)
		MouseClick("left", $Bookmark3Warp[0], $Bookmark3Warp[1], 1, $MouseSpeed)
	ElseIf $Bookmark = "4" Then
		MouseClick("right", $Bookmark4[0], $Bookmark4[1], 1, $MouseSpeed)
		MouseClick("left", $Bookmark4Warp[0], $Bookmark4Warp[1], 1, $MouseSpeed)
	ElseIf $Bookmark = "5" Then
		MouseClick("right", $Bookmark5[0], $Bookmark5[1], 1, $MouseSpeed)
		MouseClick("left", $Bookmark5Warp[0], $Bookmark5Warp[1], 1, $MouseSpeed)
	ElseIf $Bookmark = "Random" Then
		Local $Bookmark = Random(1, 5, 1)
		Select
			Case $Bookmark = "1"
				MouseClick("right", $Bookmark1[0], $Bookmark1[1], 1, $MouseSpeed)
				MouseClick("left", $Bookmark1Warp[0], $Bookmark1Warp[1], 1, $MouseSpeed)
			Case $Bookmark = "2"
				MouseClick("right", $Bookmark2[0], $Bookmark2[1], 1, $MouseSpeed)
				MouseClick("left", $Bookmark2Warp[0], $Bookmark2Warp[1], 1, $MouseSpeed)
			Case $Bookmark = "3"
				MouseClick("right", $Bookmark3[0], $Bookmark3[1], 1, $MouseSpeed)
				MouseClick("left", $Bookmark3Warp[0], $Bookmark3Warp[1], 1, $MouseSpeed)
			Case $Bookmark = "4"
				MouseClick("right", $Bookmark4[0], $Bookmark4[1], 1, $MouseSpeed)
				MouseClick("left", $Bookmark4Warp[0], $Bookmark4Warp[1], 1, $MouseSpeed)
			Case $Bookmark = "5"
				MouseClick("right", $Bookmark5[0], $Bookmark5[1], 1, $MouseSpeed)
				MouseClick("left", $Bookmark5Warp[0], $Bookmark5Warp[1], 1, $MouseSpeed)
		EndSelect
	EndIf
	MouseClick("left", $PeoplePlacesClose[0], $PeoplePlacesClose[1], 1, $MouseSpeed)
EndFunc   ;==>WarpToBelt
;; ----------------------------------------
;; WarpToBeltCheck
;; ----------------------------------------
Func WarpToBeltCheck()
	Do
		Sleep(100)
	Until PixelGetColor($WarpCheck[0], $WarpCheck[1]) <= Dec($WarpCheckColor)
EndFunc   ;==>WarpToBeltCheck
;; ----------------------------------------
;; LaunchDrones
;; ----------------------------------------
Func LaunchDrones()
	If $Drones = 1 Then
		If PixelGetColor($DroneBay[0], $DroneBay[1]) = Dec($DroneColor) Then
			MouseClick("right", $DroneBay[0], $DroneBay[1], 1, $MouseSpeed)
			MouseClick("left", $LaunchDrones[0], $LaunchDrones[1], 1, $MouseSpeed)
		EndIf
	EndIf
EndFunc   ;==>LaunchDrones
;; ----------------------------------------
;; Target
;; ----------------------------------------
Func Target()
	If $Targets = 1 Then
		Send("{CTRLDOWN}")
		MouseClick("left", $OverviewItem1[0], $OverviewItem1[1], 1, $MouseSpeed)
		Sleep(500)
		Send("{CTRLUP}")
	ElseIf $Targets = 2 Then
		Send("{CTRLDOWN}")
		MouseClick("left", $OverviewItem1[0], $OverviewItem1[1], 1, $MouseSpeed)
		MouseClick("left", $OverviewItem2[0], $OverviewItem2[1], 1, $MouseSpeed)
		Sleep(500)
		Send("{CTRLUP}")
	ElseIf $Targets = 3 Then
		Send("{CTRLDOWN}")
		MouseClick("left", $OverviewItem1[0], $OverviewItem1[1], 1, $MouseSpeed)
		MouseClick("left", $OverviewItem2[0], $OverviewItem2[1], 1, $MouseSpeed)
		MouseClick("left", $OverviewItem3[0], $OverviewItem3[1], 1, $MouseSpeed)
		Sleep(500)
		Send("{CTRLUP}")
	ElseIf $Targets = 4 Then
		Send("{CTRLDOWN}")
		MouseClick("left", $OverviewItem1[0], $OverviewItem1[1], 1, $MouseSpeed)
		MouseClick("left", $OverviewItem2[0], $OverviewItem2[1], 1, $MouseSpeed)
		MouseClick("left", $OverviewItem3[0], $OverviewItem3[1], 1, $MouseSpeed)
		MouseClick("left", $OverviewItem4[0], $OverviewItem4[1], 1, $MouseSpeed)
		Sleep(500)
		Send("{CTRLUP}")
	ElseIf $Targets = 5 Then
		Send("{CTRLDOWN}")
		MouseClick("left", $OverviewItem1[0], $OverviewItem1[1], 1, $MouseSpeed)
		MouseClick("left", $OverviewItem2[0], $OverviewItem2[1], 1, $MouseSpeed)
		MouseClick("left", $OverviewItem3[0], $OverviewItem3[1], 1, $MouseSpeed)
		MouseClick("left", $OverviewItem4[0], $OverviewItem4[1], 1, $MouseSpeed)
		MouseClick("left", $OverviewItem5[0], $OverviewItem5[1], 1, $MouseSpeed)
		Sleep(500)
		Send("{CTRLUP}")
	ElseIf $Targets = 6 Then
		Send("{CTRLDOWN}")
		MouseClick("left", $OverviewItem1[0], $OverviewItem1[1], 1, $MouseSpeed)
		MouseClick("left", $OverviewItem2[0], $OverviewItem2[1], 1, $MouseSpeed)
		MouseClick("left", $OverviewItem3[0], $OverviewItem3[1], 1, $MouseSpeed)
		MouseClick("left", $OverviewItem4[0], $OverviewItem4[1], 1, $MouseSpeed)
		MouseClick("left", $OverviewItem5[0], $OverviewItem5[1], 1, $MouseSpeed)
		MouseClick("left", $OverviewItem6[0], $OverviewItem6[1], 1, $MouseSpeed)
		Sleep(500)
		Send("{CTRLUP}")
	EndIf
EndFunc   ;==>Target
;; ----------------------------------------
;; FireLasers
;; ----------------------------------------
Func FireLasers()
	If $Lasers = 1 Then
		MouseClick("left", $Target1[0], $Target1[1], 1, $MouseSpeed)
		Send("{F1}")
	ElseIf $Lasers = 2 Then
		MouseClick("left", $Target2[0], $Target2[1], 1, $MouseSpeed)
		Send("{F1}")
		MouseClick("left", $Target1[0], $Target1[1], 1, $MouseSpeed)
		Send("{F2}")
	ElseIf $Lasers = 3 Then
		MouseClick("left", $Target3[0], $Target3[1], 1, $MouseSpeed)
		Send("{F1}")
		MouseClick("left", $Target2[0], $Target2[1], 1, $MouseSpeed)
		Send("{F2}")
		MouseClick("left", $Target1[0], $Target1[1], 1, $MouseSpeed)
		Send("{F3}")
	ElseIf $Lasers = 4 Then
		MouseClick("left", $Target4[0], $Target4[1], 1, $MouseSpeed)
		Send("{F1}")
		MouseClick("left", $Target3[0], $Target3[1], 1, $MouseSpeed)
		Send("{F2}")
		MouseClick("left", $Target2[0], $Target2[1], 1, $MouseSpeed)
		Send("{F3}")
		MouseClick("left", $Target1[0], $Target1[1], 1, $MouseSpeed)
		Send("{F4}")
	ElseIf $Lasers = 5 Then
		MouseClick("left", $Target5[0], $Target5[1], 1, $MouseSpeed)
		Send("{F1}")
		MouseClick("left", $Target4[0], $Target4[1], 1, $MouseSpeed)
		Send("{F2}")
		MouseClick("left", $Target3[0], $Target3[1], 1, $MouseSpeed)
		Send("{F3}")
		MouseClick("left", $Target2[0], $Target2[1], 1, $MouseSpeed)
		Send("{F4}")
		MouseClick("left", $Target1[0], $Target1[1], 1, $MouseSpeed)
		Send("{F5}")
	ElseIf $Lasers = 6 Then
		MouseClick("left", $Target6[0], $Target6[1], 1, $MouseSpeed)
		Send("{F1}")
		MouseClick("left", $Target5[0], $Target5[1], 1, $MouseSpeed)
		Send("{F2}")
		MouseClick("left", $Target4[0], $Target4[1], 1, $MouseSpeed)
		Send("{F3}")
		MouseClick("left", $Target3[0], $Target3[1], 1, $MouseSpeed)
		Send("{F4}")
		MouseClick("left", $Target2[0], $Target2[1], 1, $MouseSpeed)
		Send("{F5}")
		MouseClick("left", $Target1[0], $Target1[1], 1, $MouseSpeed)
		Send("{F6}")
	EndIf
EndFunc   ;==>FireLasers
;; ----------------------------------------
;; MiningCheck
;; ----------------------------------------
Func MiningCheck()
	If $MiningCheck = 1 Then
		If $Lasers = 1 Then
			Do
				Sleep(100)
			Until PixelGetColor($LaserIcon1[0], $LaserIcon1[1]) = Dec($MiningCheckColor)
		ElseIf $Lasers = 2 Then
			Do
				Sleep(100)
			Until PixelGetColor($LaserIcon2[0], $LaserIcon2[1]) = Dec($MiningCheckColor) And _
					PixelGetColor($LaserIcon1[0], $LaserIcon1[1]) = Dec($MiningCheckColor)
		ElseIf $Lasers = 3 Then
			Do
				Sleep(100)
			Until PixelGetColor($LaserIcon3[0], $LaserIcon3[1]) = Dec($MiningCheckColor) And _
					PixelGetColor($LaserIcon2[0], $LaserIcon2[1]) = Dec($MiningCheckColor) And _
					PixelGetColor($LaserIcon1[0], $LaserIcon1[1]) = Dec($MiningCheckColor)
		ElseIf $Lasers = 4 Then
			Do
				Sleep(100)
			Until PixelGetColor($LaserIcon4[0], $LaserIcon4[1]) = Dec($MiningCheckColor) And _
					PixelGetColor($LaserIcon3[0], $LaserIcon3[1]) = Dec($MiningCheckColor) And _
					PixelGetColor($LaserIcon2[0], $LaserIcon2[1]) = Dec($MiningCheckColor) And _
					PixelGetColor($LaserIcon1[0], $LaserIcon1[1]) = Dec($MiningCheckColor)
		ElseIf $Lasers = 5 Then
			Do
				Sleep(100)
			Until PixelGetColor($LaserIcon5[0], $LaserIcon5[1]) = Dec($MiningCheckColor) And _
					PixelGetColor($LaserIcon3[0], $LaserIcon3[1]) = Dec($MiningCheckColor) And _
					PixelGetColor($LaserIcon4[0], $LaserIcon4[1]) = Dec($MiningCheckColor) And _
					PixelGetColor($LaserIcon2[0], $LaserIcon2[1]) = Dec($MiningCheckColor) And _
					PixelGetColor($LaserIcon1[0], $LaserIcon1[1]) = Dec($MiningCheckColor)
		ElseIf $Lasers = 6 Then
			Do
				Sleep(100)
			Until PixelGetColor($LaserIcon6[0], $LaserIcon6[1]) = Dec($MiningCheckColor) And _
					PixelGetColor($LaserIcon5[0], $LaserIcon5[1]) = Dec($MiningCheckColor) And _
					PixelGetColor($LaserIcon4[0], $LaserIcon4[1]) = Dec($MiningCheckColor) And _
					PixelGetColor($LaserIcon3[0], $LaserIcon3[1]) = Dec($MiningCheckColor) And _
					PixelGetColor($LaserIcon2[0], $LaserIcon2[1]) = Dec($MiningCheckColor) And _
					PixelGetColor($LaserIcon1[0], $LaserIcon1[1]) = Dec($MiningCheckColor)
		EndIf
	EndIf
EndFunc   ;==>MiningCheck
;; ----------------------------------------
;; MiningTimer
;; ----------------------------------------
Func MiningTimer()
	If $MiningTimer = 1 Then
		Sleep($MiningTime * 1000)
		If $Lasers = 1 Then
			Send("{F1}")
		ElseIf $Lasers = 2 Then
			Send("{F1}{F2}")
		ElseIf $Lasers = 3 Then
			Send("{F1}{F2}{F3}")
		ElseIf $Lasers = 4 Then
			Send("{F1}{F2}{F3}{F4}")
		ElseIf $Lasers = 5 Then
			Send("{F1}{F2}{F3}{F4}{F5}")
		ElseIf $Lasers = 6 Then
			Send("{F1}{F2}{F3}{F4}{F5}{F6}")
		EndIf
	EndIf
EndFunc   ;==>MiningTimer
;; ----------------------------------------
;; ReturnDrones
;; ----------------------------------------
Func ReturnDrones()
	If $Drones = 1 Then
		If PixelGetColor($DroneSpace[0], $DroneSpace[1]) = Dec($DroneColor) Then
			MouseClick("right", $DroneSpace[0], $DroneSpace[1], 1, $MouseSpeed)
			MouseClick("left", $ReturnDrones[0], $ReturnDrones[1], 1, $MouseSpeed)
		EndIf
	EndIf
EndFunc   ;==>ReturnDrones
;; ----------------------------------------
;; Dock
;; ----------------------------------------
Func Dock()
	MouseClick("left", $PeoplePlacesOpen[0], $PeoplePlacesOpen[1], 1, $MouseSpeed)
	Sleep($BookmarkWait * 1000)
	MouseClick("right", $Bookmark0[0], $Bookmark0[1], 1, $MouseSpeed)
	MouseClick("left", $Bookmark0Dock1[0], $Bookmark0Dock1[1], 1, $MouseSpeed)
	MouseClick("left", $PeoplePlacesClose[0], $PeoplePlacesClose[1], 1, $MouseSpeed)
EndFunc   ;==>Dock
;; ----------------------------------------
;; DockCheck
;; ----------------------------------------
Func DockCheck()
	$DockTimestamp = TimerInit()
	Do
		Sleep(100)
		If (TimerDiff($DockTimestamp) / 1000) / 60 >= $DockTime Then
			MouseClick("left", $PeoplePlacesOpen[0], $PeoplePlacesOpen[1], 1, $MouseSpeed)
			Sleep($BookmarkWait * 1000)
			MouseClick("right", $Bookmark0[0], $Bookmark0[1], 1, $MouseSpeed)
			MouseClick("left", $Bookmark0Dock2[0], $Bookmark0Dock2[1], 1, $MouseSpeed)
			MouseClick("left", $PeoplePlacesClose[0], $PeoplePlacesClose[1], 1, $MouseSpeed)
			CenterCursor()
			DockCheck()
		EndIf
	Until PixelGetColor($Undock[0], $Undock[1]) >= Dec($UndockColor)
EndFunc   ;==>DockCheck
;; ----------------------------------------
;; MoveCargo
;; ----------------------------------------
Func MoveCargo()
	MouseClick("left", $CargoBay[0], $CargoBay[1], 1, $MouseSpeed)
	Send("{CTRLDOWN}")
	Send("a")
	Sleep(500)
	Send("{CTRLUP}")
	MouseClickDrag("left", $CargoBayItem1[0], $CargoBayItem1[1], $StationPanel[0], $StationPanel[1], $MouseSpeed)
EndFunc   ;==>MoveCargo
;; ----------------------------------------
;; LogOn
;; ----------------------------------------
Func LogOn()
	If $LogOn = 1 Then
		If Not WinExists("EVE", "") Then
			Run($EVELocation & "eve.exe")
			Sleep($EVEWait * 1000)
		EndIf
		ActivateWindow()
		CenterCursor()
		Send($EVEPass)
		Sleep(500)
		Send("{ENTER}")
		Do
			Sleep(100)
		Until PixelGetColor($EnterGame[0], $EnterGame[1]) = Dec($EnterGameColor)
		MouseClick("left", $EnterGame[0], $EnterGame[1], 1, $MouseSpeed)
	EndIf
EndFunc   ;==>LogOn
;; ----------------------------------------
;; LogOff
;; ----------------------------------------
Func LogOff()
	If $LogOff = 1 Then
		Send("{CTRLDOWN}")
		Send("q")
		Sleep(500)
		Send("{CTRLUP}")
		Exit
	EndIf
EndFunc   ;==>LogOff
;; ----------------------------------------
;; LogOffDT
;; ----------------------------------------
Func LogOffDT()
	If $LogOffDT = 1 Then
		If @HOUR = $LogOffHH And @MIN >= $LogOffMM Then
			Send("{CTRLDOWN}")
			Send("q")
			Sleep(500)
			Send("{CTRLUP}")
			Exit
		EndIf
	EndIf
EndFunc   ;==>LogOffDT
;; ----------------------------------------
;; HotKeyPause
;; ----------------------------------------
Func HotKeyPause()
	$Paused = Not $Paused
	While $Paused
		Sleep(100)
		ToolTip("Paused", 0, 0, "AutoOre v" & $Version)
	WEnd
	ToolTip("")
EndFunc   ;==>HotKeyPause
;; ----------------------------------------
;; HotKeyStop
;; ----------------------------------------
Func HotKeyStop()
	Exit
EndFunc   ;==>HotKeyStop