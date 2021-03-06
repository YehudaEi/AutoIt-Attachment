;; ----------------------------------------------------------------------------
;;
;; AutoIt Version: 3.2.11.1
;; Author: SixWingedFreak
;;
;; Script Function:
;;	AutoOre v9.0b
;;	1600x900 Window mode
;;
;; ----------------------------------------------------------------------------
;; ----------------------------------------------------------------------------
;; Tray Icon
;; ----------------------------------------------------------------------------
Opt("TrayAutoPause", 0)
Opt("TrayMenuMode", 1)
TraySetToolTip("AutoOre v" & $Version)
$TrayRunEVE = TrayCreateItem("Run EVE Online")
$TrayOptions = TrayCreateItem("Options")
TrayCreateItem("")
$TrayExit = TrayCreateItem("Exit")
TraySetState()
;; ----------------------------------------------------------------------------
;; Main GUI
;; ----------------------------------------------------------------------------
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
;; ----------------------------------------------------------------------------
;; Toolbar GUI
;; ----------------------------------------------------------------------------
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