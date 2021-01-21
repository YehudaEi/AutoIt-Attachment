#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_icon=Icons\eve1.ico
#AutoIt3Wrapper_outfile=AutoOre v9.0b.exe
#AutoIt3Wrapper_Compression=4
#AutoIt3Wrapper_Res_Language=1033
#AutoIt3Wrapper_Res_Icon_Add=Icons\play.ico
#AutoIt3Wrapper_Res_Icon_Add=Icons\pause.ico
#AutoIt3Wrapper_Res_Icon_Add=Icons\stop.ico
#AutoIt3Wrapper_AU3Check_Stop_OnWarning=y
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
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
#include <vars.au3>
#include <gui.au3>
Opt("MouseCoordMode", 2)
Opt("PixelCoordMode", 2)
HotKeySet("{PAUSE}", "HotKeyPause")
HotKeySet("{END}", "HotKeyStop")
;; ----------------------------------------
;; MainLoop
;; ----------------------------------------
LoadSettings()
RunGUI()
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
;; GUI
;; ----------------------------------------
Func RunGUI()
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
EndFunc   ;==>RunGUI
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
	EndIf
	If $Bookmark = "2" Then
		MouseClick("right", $Bookmark2[0], $Bookmark2[1], 1, $MouseSpeed)
		MouseClick("left", $Bookmark2Warp[0], $Bookmark2Warp[1], 1, $MouseSpeed)
	EndIf
	If $Bookmark = "3" Then
		MouseClick("right", $Bookmark3[0], $Bookmark3[1], 1, $MouseSpeed)
		MouseClick("left", $Bookmark3Warp[0], $Bookmark3Warp[1], 1, $MouseSpeed)
	EndIf
	If $Bookmark = "4" Then
		MouseClick("right", $Bookmark4[0], $Bookmark4[1], 1, $MouseSpeed)
		MouseClick("left", $Bookmark4Warp[0], $Bookmark4Warp[1], 1, $MouseSpeed)
	EndIf
	If $Bookmark = "5" Then
		MouseClick("right", $Bookmark5[0], $Bookmark5[1], 1, $MouseSpeed)
		MouseClick("left", $Bookmark5Warp[0], $Bookmark5Warp[1], 1, $MouseSpeed)
	EndIf
	If $Bookmark = "Random" Then
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
	EndIf
	If $Targets = 2 Then
		Send("{CTRLDOWN}")
		MouseClick("left", $OverviewItem1[0], $OverviewItem1[1], 1, $MouseSpeed)
		MouseClick("left", $OverviewItem2[0], $OverviewItem2[1], 1, $MouseSpeed)
		Sleep(500)
		Send("{CTRLUP}")
	EndIf
	If $Targets = 3 Then
		Send("{CTRLDOWN}")
		MouseClick("left", $OverviewItem1[0], $OverviewItem1[1], 1, $MouseSpeed)
		MouseClick("left", $OverviewItem2[0], $OverviewItem2[1], 1, $MouseSpeed)
		MouseClick("left", $OverviewItem3[0], $OverviewItem3[1], 1, $MouseSpeed)
		Sleep(500)
		Send("{CTRLUP}")
	EndIf
	If $Targets = 4 Then
		Send("{CTRLDOWN}")
		MouseClick("left", $OverviewItem1[0], $OverviewItem1[1], 1, $MouseSpeed)
		MouseClick("left", $OverviewItem2[0], $OverviewItem2[1], 1, $MouseSpeed)
		MouseClick("left", $OverviewItem3[0], $OverviewItem3[1], 1, $MouseSpeed)
		MouseClick("left", $OverviewItem4[0], $OverviewItem4[1], 1, $MouseSpeed)
		Sleep(500)
		Send("{CTRLUP}")
	EndIf
	If $Targets = 5 Then
		Send("{CTRLDOWN}")
		MouseClick("left", $OverviewItem1[0], $OverviewItem1[1], 1, $MouseSpeed)
		MouseClick("left", $OverviewItem2[0], $OverviewItem2[1], 1, $MouseSpeed)
		MouseClick("left", $OverviewItem3[0], $OverviewItem3[1], 1, $MouseSpeed)
		MouseClick("left", $OverviewItem4[0], $OverviewItem4[1], 1, $MouseSpeed)
		MouseClick("left", $OverviewItem5[0], $OverviewItem5[1], 1, $MouseSpeed)
		Sleep(500)
		Send("{CTRLUP}")
	EndIf
	If $Targets = 6 Then
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
	EndIf
	If $Lasers = 2 Then
		MouseClick("left", $Target2[0], $Target2[1], 1, $MouseSpeed)
		Send("{F1}")
		MouseClick("left", $Target1[0], $Target1[1], 1, $MouseSpeed)
		Send("{F2}")
	EndIf
	If $Lasers = 3 Then
		MouseClick("left", $Target3[0], $Target3[1], 1, $MouseSpeed)
		Send("{F1}")
		MouseClick("left", $Target2[0], $Target2[1], 1, $MouseSpeed)
		Send("{F2}")
		MouseClick("left", $Target1[0], $Target1[1], 1, $MouseSpeed)
		Send("{F3}")
	EndIf
	If $Lasers = 4 Then
		MouseClick("left", $Target4[0], $Target4[1], 1, $MouseSpeed)
		Send("{F1}")
		MouseClick("left", $Target3[0], $Target3[1], 1, $MouseSpeed)
		Send("{F2}")
		MouseClick("left", $Target2[0], $Target2[1], 1, $MouseSpeed)
		Send("{F3}")
		MouseClick("left", $Target1[0], $Target1[1], 1, $MouseSpeed)
		Send("{F4}")
	EndIf
	If $Lasers = 5 Then
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
	EndIf
	If $Lasers = 6 Then
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
		$MiningDone = 0
		If $Lasers = 1 Then
			Do
				If PixelGetColor($LaserIcon1[0], $LaserIcon1[1]) = Dec($MiningCheckColor) Then
					$MiningDone = 1
				EndIf
				Sleep(100)
			Until $MiningDone = 1
		EndIf
		If $Lasers = 2 Then
			Do
				If PixelGetColor($LaserIcon2[0], $LaserIcon2[1]) = Dec($MiningCheckColor) And PixelGetColor($LaserIcon1[0], $LaserIcon1[1]) = Dec($MiningCheckColor) Then
					$MiningDone = 1
				EndIf
				Sleep(100)
			Until $MiningDone = 1
		EndIf
		If $Lasers = 3 Then
			Do
				If PixelGetColor($LaserIcon3[0], $LaserIcon3[1]) = Dec($MiningCheckColor) And PixelGetColor($LaserIcon2[0], $LaserIcon2[1]) = Dec($MiningCheckColor) And PixelGetColor($LaserIcon1[0], $LaserIcon1[1]) = Dec($MiningCheckColor) Then
					$MiningDone = 1
				EndIf
				Sleep(100)
			Until $MiningDone = 1
		EndIf
		If $Lasers = 4 Then
			Do
				If PixelGetColor($LaserIcon4[0], $LaserIcon4[1]) = Dec($MiningCheckColor) And PixelGetColor($LaserIcon3[0], $LaserIcon3[1]) = Dec($MiningCheckColor) And PixelGetColor($LaserIcon2[0], $LaserIcon2[1]) = Dec($MiningCheckColor) And PixelGetColor($LaserIcon1[0], $LaserIcon1[1]) = Dec($MiningCheckColor) Then
					$MiningDone = 1
				EndIf
				Sleep(100)
			Until $MiningDone = 1
		EndIf
		If $Lasers = 5 Then
			Do
				If PixelGetColor($LaserIcon5[0], $LaserIcon5[1]) = Dec($MiningCheckColor) And PixelGetColor($LaserIcon4[0], $LaserIcon4[1]) = Dec($MiningCheckColor) And PixelGetColor($LaserIcon3[0], $LaserIcon3[1]) = Dec($MiningCheckColor) And PixelGetColor($LaserIcon2[0], $LaserIcon2[1]) = Dec($MiningCheckColor) And PixelGetColor($LaserIcon1[0], $LaserIcon1[1]) = Dec($MiningCheckColor) Then
					$MiningDone = 1
				EndIf
				Sleep(100)
			Until $MiningDone = 1
		EndIf
		If $Lasers = 6 Then
			Do
				If PixelGetColor($LaserIcon6[0], $LaserIcon6[1]) = Dec($MiningCheckColor) And PixelGetColor($LaserIcon5[0], $LaserIcon5[1]) = Dec($MiningCheckColor) And PixelGetColor($LaserIcon4[0], $LaserIcon4[1]) = Dec($MiningCheckColor) And PixelGetColor($LaserIcon3[0], $LaserIcon3[1]) = Dec($MiningCheckColor) And PixelGetColor($LaserIcon2[0], $LaserIcon2[1]) = Dec($MiningCheckColor) And PixelGetColor($LaserIcon1[0], $LaserIcon1[1]) = Dec($MiningCheckColor) Then
					$MiningDone = 1
				EndIf
				Sleep(100)
			Until $MiningDone = 1
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
		EndIf
		If $Lasers = 2 Then
			Send("{F1}{F2}")
		EndIf
		If $Lasers = 3 Then
			Send("{F1}{F2}{F3}")
		EndIf
		If $Lasers = 4 Then
			Send("{F1}{F2}{F3}{F4}")
		EndIf
		If $Lasers = 5 Then
			Send("{F1}{F2}{F3}{F4}{F5}")
		EndIf
		If $Lasers = 6 Then
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