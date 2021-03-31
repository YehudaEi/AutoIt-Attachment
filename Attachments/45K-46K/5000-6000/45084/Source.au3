#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=Images\Icon2.ico
#AutoIt3Wrapper_Compression=0
#AutoIt3Wrapper_Res_Fileversion=1.1.0.0
#AutoIt3Wrapper_Res_LegalCopyright=R.S.S.
#AutoIt3Wrapper_Res_requestedExecutionLevel=asInvoker
#AutoIt3Wrapper_Add_Constants=n
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
; *** Start added by AutoIt3Wrapper ***
#include <TrayConstants.au3>
; *** End added by AutoIt3Wrapper ***

#include <Array.au3>
#include <GUIConstantsEx.au3>
#include <ButtonConstants.au3>
#include <Constants.au3>
#include "ControllerModule.au3"
#include ".\Skins\Cosmo.au3"
#include ".\Skins\_UskinLibrary.au3"

Opt("GUIOnEventMode", 1)
Opt("TrayOnEventMode", 1)
Opt("TrayMenuMode", 1)

_Uskin_LoadDLL()
_USkin_Init(_Cosmo(True))

Global $joy, $coor, $h, $s, $msg, $Tabbed = 0, $LetterCount = 0, $DeviceType = 0, $Gui, $Time, $Timer = 5000
Global $UseAsGamePad, $UseAsInput, $ActiveGui, $MapKeysGui, $SetKeysGui, $Action, $Shortcut, $ProfileList
Global $ActionSelector, $ShortcutButton, $KeyToMap, $ActionOrShortcut, $ShortcutToSave, $ShortcutInfo
Global $KeyMaps, $StripWhiteSpaces, $MouseSpeedSetting

$Time = TimerInit()
Global $Profile = IniRead(@ScriptDir & "/Data/Config.ini", "Profile", "Profile", "NA")
Global $Websites = IniReadSection(@ScriptDir & "/Data/Config.ini", "Websites")


$ModeMenu = TrayCreateMenu("Mode")
$GameModeItem = TrayCreateItem("Game Mode", $ModeMenu)
TrayItemSetOnEvent(-1, "_GameMode")
$PeripheralModeItem = TrayCreateItem("Peripheral Mode", $ModeMenu)
TrayItemSetOnEvent(-1, "_PeripheralMode")
$ShowGuiItem = TrayCreateItem("Show GUI")
TrayItemSetOnEvent(-1, "_ShowGui")
TrayCreateItem("")
TrayCreateItem("")
$ExitItem = TrayCreateItem("Exit")
TrayItemSetOnEvent(-1, "_Exit")
TraySetState()

$joy = _JoyInit()

Global $Letters = IniReadSection(@ScriptDir & "\Data\Config.ini", "Letters")

_GUI()

Func _GUI()
	$ActiveGui = "MainGui"
	$Gui = GUICreate("Controller To Peripheral", 410, 100)
	GUISetOnEvent($GUI_EVENT_CLOSE, "_Exit")
	$UseAsGamePad = GUICtrlCreateCheckbox("Enable game mode", 140, 30)
	GUICtrlSetOnEvent(-1, "_GameMode")
	$UseAsInput = GUICtrlCreateCheckbox("Enable peripheral device", 130, 60)
	GUICtrlSetOnEvent(-1, "_PeripheralMode")
	GUICtrlCreateLabel("Profile Selection", 300, 20)
	$ProfileList = GUICtrlCreateCombo("", 260, 40, 150, 20)
	GUICtrlSetData(-1, "Profile #1 - Keyboard/Mouse|Profile #2 - Browser")
	$ProfileLoadButton = GUICtrlCreateButton("Apply Profile", 295, 70, 80, 30)
	GUICtrlSetOnEvent(-1, "_SelectProfile")
	GUICtrlCreateLabel("Mouse Speed", 30, 25)
	$MouseSpeedButton = GUICtrlCreateButton("Apply Speed", 25, 70, 80, 30)
	GUICtrlSetOnEvent(-1, "_SelectSpeed")
	$MouseSpeedSetting = GUICtrlCreateSlider(5, 45, 120, 20)
		GUICtrlSetLimit(-1, 20, 1)
	GUICtrlCreateLabel("An R.S.S. Product", 150, 10, 100, 20)
	GUICtrlSetColor(-1, 0x66a3e0)
	GUICtrlCreateLabel("Version 1.1", 165, 85)
	GUICtrlSetColor(-1, 0x66a3e0)
	GUISetState()
EndFunc   ;==>_GUI

Func _SelectProfile()
	$GetProfile = GUICtrlRead($ProfileList, 1)
	If $GetProfile > "" Then
		$SplitProfile = StringSplit($GetProfile, "#")
		$SplitProfile2 = StringSplit($SplitProfile[2], "-")
		$StripWhiteSpaces = StringStripWS($SplitProfile2[1], 8)
		$ProfileSelection = $StripWhiteSpaces
		IniWrite(@ScriptDir & "/Data/Config.ini", "Profile", "Profile", $ProfileSelection)
		$Profile = $ProfileSelection
		$GetProfile = ""
		MsgBox(0, "", "Profile selection complete!")
	Else
		MsgBox(64, "", "Error, no profile selected")
	EndIf
EndFunc   ;==>_SelectProfile

Func _SelectSpeed()
	$GetSpeed = GuiCtrlRead($MouseSpeedSetting, 1)
	If $Profile = 1 Then
		IniWrite(@ScriptDir & "/Data/Config.ini", "KeyMaps1", "Speed1", $GetSpeed)
	EndIf
	If $Profile = 2 Then
		IniWrite(@ScriptDir & "/Data/Config.ini", "KeyMaps2", "Speed", $GetSpeed)
	EndIf
	If $Profile = 3 Then
		IniWrite(@ScriptDir & "/Data/Config.ini", "KeyMaps3", "Speed", $GetSpeed)
	EndIf
	If $Profile = 4 Then
		IniWrite(@ScriptDir & "/Data/Config.ini", "KeyMaps4", "Speed", $GetSpeed)
	EndIf
EndFunc

Func _ShowGui()
	_GUI()
	TrayItemSetState($ShowGuiItem, $TRAY_UNCHECKED)
EndFunc   ;==>_ShowGui

Func _GameMode()
	SoundPlay(@ScriptDir & "/Sounds/Default.wav")
	$DeviceType = 0
	GUICtrlSetColor($UseAsGamePad, 0x00FF00)
	GUICtrlSetColor($UseAsInput, 0xFFFFFF)
	GUICtrlSetState($UseAsGamePad, $GUI_CHECKED)
	GUICtrlSetState($UseAsInput, $GUI_UNCHECKED)
	TrayItemSetState($GameModeItem, $TRAY_CHECKED)
	TrayItemSetState($PeripheralModeItem, $TRAY_UNCHECKED)
EndFunc   ;==>_GameMode

Func _PeripheralMode()
	SoundPlay(@ScriptDir & "/Sounds/Default.wav")
	$DeviceType = 1
	GUICtrlSetColor($UseAsGamePad, 0xFFFFFF)
	GUICtrlSetColor($UseAsInput, 0x00FF00)
	GUICtrlSetState($UseAsGamePad, $GUI_UNCHECKED)
	GUICtrlSetState($UseAsInput, $GUI_CHECKED)
	TrayItemSetState($GameModeItem, $TRAY_UNCHECKED)
	TrayItemSetState($PeripheralModeItem, $TRAY_CHECKED)
EndFunc   ;==>_PeripheralMode

Func _Exit()
	TrayItemSetState($ExitItem, $TRAY_UNCHECKED)
	If $ActiveGui = "MainGui" Then
		GuiDelete($Gui)
		$ActiveGui = ""
	Else
	Exit
	EndIf
EndFunc   ;==>_Exit

Func _ChangeMode()
	If $DeviceType = 1 Then
		$Timer = 5000
		$Time = TimerInit()
		$DeviceType = 3
		_GameMode()
	Else
		$Timer = 5000
		$Time = TimerInit()
		_PeripheralMode()
	EndIf
EndFunc   ;==>_ChangeMode



While 1
	If TimerDiff($Time) > $Timer Then
		$coord = _GetJoy($joy, 0)
				If $coord[0] < 32767 OR $coord[0] > 32767 OR $coord[1] < 32767 OR $coord[1] > 32767  OR $coord[2] < 32767 OR $coord[2] > 32767 OR $coord[3] < 32767 OR $coord[3] > 32767 OR $coord[4] > 0 OR $coord[5] > 0 OR $coord[6] < 65535 OR $coord[7] > 0 Then
			Global $Profile = IniReadSection(@ScriptDir & "/Data/Config.ini", "Profile")
			If $Profile[1][1] = "1" Then
				Global $KeyMaps = IniReadSection(@ScriptDir & "\Data\Config.ini", "KeyMaps1")
				$Profile = 1
			ElseIf $Profile[1][1] = "2" Then
				Global $KeyMaps = IniReadSection(@ScriptDir & "\Data\Config.ini", "KeyMaps2")
				$Profile = 2
			ElseIf $Profile[1][1] = "3" Then
				Global $KeyMaps = IniReadSection(@ScriptDir & "\Data\Config.ini", "KeyMaps3")
				$Profile = 3
			ElseIf $Profile[1][1] = "4" Then
				Global $KeyMaps = IniReadSection(@ScriptDir & "\Data\Config.ini", "KeyMaps4")
				$Profile = 4
			EndIf
			If $coord[7] = 768 Then
				_ChangeMode()
			ElseIf $coord[7] = 1 Then
				_Triangle()
			ElseIf $coord[7] = 2 Then
				_Circle()
			ElseIf $coord[7] = 4 Then
				_X()
			ElseIf $coord[7] = 8 Then
				_Square()
			ElseIf $coord[7] = 16 Then
				_L1()
			ElseIf $coord[7] = 64 Then
				_L2()
			ElseIf $coord[7] = 32 Then
				_R1()
			ElseIf $coord[7] = 128 Then
				_R2()
			ElseIf $coord[6] = 27000 Then
				_DPadLeft()
			ElseIf $coord[6] = 0 Then
				_DPadUp()
			ElseIf $coord[6] = 9000 Then
				_DPadRight()
			ElseIf $coord[6] = 18000 Then
				_DPadDown()
			ElseIf $coord[1] = 0 Then
				_LeftAnalogUp()
			ElseIf $coord[0] > 50000 Then
				_LeftAnalogRight()
			ElseIf $coord[1] = 65535 Then
				_LeftAnalogDown()
			ElseIf $coord[0] = 0 Then
				_LeftAnalogLeft()
			ElseIf $coord[3] = 0 Then
				_RightAnalogUp()
			ElseIf $coord[2] = 65535 Then
				_RightAnalogRight()
			ElseIf $coord[3] = 65535 Then
				_RightAnalogDown()
			ElseIf $coord[2] = 0 Then
				_RightAnalogLeft()
			EndIf
		EndIf
	EndIf
WEnd

$lpJoy = 0 ; Joyclose


;======================================
;   _JoyInit()
;======================================
Func _JoyInit()
	Local $joy
	Global $JOYINFOEX_struct = "dword[13]"
	$joy = DllStructCreate($JOYINFOEX_struct)
	If @error Then Return 0
	DllStructSetData($joy, 1, DllStructGetSize($joy), 1);dwSize = sizeof(struct)
	DllStructSetData($joy, 1, 255, 2) ;dwFlags = GetAll
	Return $joy
EndFunc   ;==>_JoyInit

Func _GetJoy($lpJoy, $iJoy)
	Local $coor, $ret
	Dim $coor[8]
	DllCall("Winmm.dll", "int", "joyGetPosEx", _
			"int", $iJoy, _
			"ptr", DllStructGetPtr($lpJoy))
	If Not @error Then
		$coor[0] = DllStructGetData($lpJoy, 1, 3)
		$coor[1] = DllStructGetData($lpJoy, 1, 4)
		$coor[2] = DllStructGetData($lpJoy, 1, 5)
		$coor[3] = DllStructGetData($lpJoy, 1, 6)
		$coor[4] = DllStructGetData($lpJoy, 1, 7)
		$coor[5] = DllStructGetData($lpJoy, 1, 8)
		$coor[6] = DllStructGetData($lpJoy, 1, 11)
		$coor[7] = DllStructGetData($lpJoy, 1, 9)
	EndIf
	Return $coor
EndFunc   ;==>_GetJoy


