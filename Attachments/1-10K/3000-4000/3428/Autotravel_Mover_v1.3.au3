#comments-start
	----------------------------------------------------------------------------
	
	AutoIt Version: 3.1.1
	Author:         Stumpii
	Modified by:    CPC197C, h8no1
	
	Script Function:
	The Autotravel Move script removes some of the tedium of continually
	clicking a button to turn when using the Autotravel Addon for the World of
	Warcraft game.
	
	Revision History
	v1.3 - 27 July 05
	1) Added support for single character keys (A-Z, 0-9 etc.). Thanks h8no1.
	
	v1.2 - 22 July 05
	1) Bug fix. Thanks h8no1.
	
	v1.1 - 22 July 05
	1) Changed INI file location to save/load from the script folder. Thanks h8no1.
	2) Changed the auto execute WoW function to read the WoW exe location from the registry instead of doing a file exists test. Thanks h8no1.
	
	v1.0 - 21 July 05
	1) Saves and loads the user config from an INI file, so your custom settings are restored each time you run.
	2) The UI now allows the max and min randomised time delay limits to be configured. Thanks Cpc197c and h8no1.
	3) A checkbox on the UI now allows WoW to be started from the script automatically. Thanks Ziggyke.
	4) The mash and pause/resume keys are now configurable through drop down boxes. Thanks Cpc197c and h8no1.
	5) Messed around with the UI layout as it was getting crowded with all the added controls.
	----------------------------------------------------------------------------
#comments-end

;User variables
Dim $keybutton
Dim $trigbutton
Dim $TimeDelayLow
Dim $TimeDelayHigh
Dim $ChooseSettings
Dim $Title
Dim $StartWoW

; Other variables
$CurrentlyRunning = 0
$WoWWasRunning = 0
$WoWRunning = 0
$keys = "SPACE|ENTER|ALT|BACKSPACE|DELETE|UP|DOWN|LEFT|RIGHT|HOME|END|ESCAPE|INSERT|PGUP|PGDN|F1|F2|F3|F4|F5|F6|F7|F8|F9|F10|F11|F12|TAB|PRINTSCREEN|LWIN|RWIN|CTRLBREAK|PAUSE|NUMPAD0|NUMPAD1|NUMPAD2|NUMPAD3|NUMPAD4|NUMPAD5|NUMPAD6|NUMPAD7|NUMPAD8|NUMPAD9|NUMPADMULT|NUMPADADD|NUMPADSUB|NUMPADDIV|NUMPADDOT|NUMPADENTER|APPSKEY|LALT|RALT|LCTRL|RCTRL|LSHIFT|RSHIFT"
Dim $WoWPath

;Include constants
#include <GUIConstants.au3>

Global $GUIWidth
Global $GUIHeight

$GUIWidth = 270
$GUIHeight = 175

; Remember Controls: left, top [, width [, height]]

;Load Settings
LoadSettings()

;Create window
GUICreate("Autotravel Move", $GUIWidth, $GUIHeight)

;Labels
GUICtrlCreateLabel("Mash Key:", 10, 10, 70, 20)
GUICtrlCreateLabel("Pause/Resume Key:", 10, 35, 100, 20)
GUICtrlCreateLabel("Randomise delay from:", 10, 60)
GUICtrlCreateLabel("to", 180, 60)
GUICtrlCreateLabel("mS", 240, 60)
GUICtrlCreateLabel("WoW Window Name:", 10, 85, 120, 20)

;Dropdown for Mash key
$Edit_1 = GUICtrlCreateCombo("", 140, 10, 120, 120)
GUICtrlSetData(-1, $keys) ; Add the default list to the combo box
GUICtrlSetData(-1, $keybutton, $keybutton) ; Add the actual, in case it is a custom key

;Dropdown for Trigger
$Edit_2 = GUICtrlCreateCombo("", 140, 35, 120, 120)
GUICtrlSetData(-1, $keys) ; Add the default list to the combo box
GUICtrlSetData(-1, $trigbutton, $trigbutton) ; Add the actual, in case it is a custom key

;Time Delay inputboxs
$txtTimeDelayLow = GUICtrlCreateInput("", 140, 60, 35, 20, $ES_RIGHT)
GUICtrlSetData(-1, $TimeDelayLow)
$txtTimeDelayHigh = GUICtrlCreateInput("", 200, 60, 35, 20, $ES_RIGHT)
GUICtrlSetData(-1, $TimeDelayHigh)

;Title Name inputbox
$Edit_4 = GUICtrlCreateInput("World of Warcraft", 140, 85, 100, 20, $ES_LEFT)
GUICtrlSetData(-1, $Title)

; Automatically Start WoW
$chkStartWoW = GUICtrlCreateCheckbox("Auto Start WoW", 10, 110, 145, 25, $BS_RIGHTBUTTON)
GUICtrlSetState(-1, $StartWoW)

;Create an "Start!" button
$OK_Btn = GUICtrlCreateButton("Start!", 125, 150, 70, 25)

;Create a "Cancel" button
$Cancel_Btn = GUICtrlCreateButton("Cancel", 200, 150, 70, 25)

;Show window
GUISetState(@SW_SHOW)

;Loop until OK or Cancel or X:
While $ChooseSettings = 0
	;After every loop check if the user clicked something in the GUI window
	$msg = GUIGetMsg()
	
	Select
		
		;Check if user clicked on the X button
		Case $msg = $GUI_EVENT_CLOSE
			;Destroy the GUI including the controls
			GUIDelete()
			;Exit the script
			Exit
			
			;Check if user clicked on the "Start!" button
		Case $msg = $OK_Btn
			$keybutton = GUICtrlRead($Edit_1)
			$trigbutton = GUICtrlRead($Edit_2)
			$TimeDelayLow = GUICtrlRead($txtTimeDelayLow)
			$TimeDelayHigh = GUICtrlRead($txtTimeDelayHigh)
			$Title = GUICtrlRead($Edit_4)
			$StartWoW = GUICtrlRead($chkStartWoW)
			
			;Write Settings to INI file
			SaveSettings()
			
			MsgBox(64, "Keys that are used... ", $keybutton & ", " & $trigbutton)
			$ChooseSettings = 1
			
			;Check if user clicked on the "Cancel" button
		Case $msg = $Cancel_Btn
			GUIDelete()
			Exit
			
	EndSelect
	
WEnd

;Stumpii's Code, From his script but slightly modified to work with variables.

GUIDelete()
; Initial stuff
HotKeySet("{" & $trigbutton & "}", "ToggleState")

#Region --- CodeWizard generated code Start ---
;MsgBox features: Title=Yes, Text=Yes, Buttons=OK, Icon=Warning
MsgBox(48, "Autotravel Move", "Using this program may violate the TOS of the WoW game. Use at you own risk.")
#EndRegion --- CodeWizard generated code End ---

; Check if WoW running
If WinExists($Title) Then
	; Do Nothing
Else
	;Check if user wanted it to be auto started
	If $StartWoW = $GUI_CHECKED Then
		; Check where WoW is installed, from registry
		$WoWPath = RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\Blizzard Entertainment\World of Warcraft", "GamePath")
		; Check if the reg entry existed
		If $WoWPath <> "" Then
			Run($WoWPath)
		Else
			MsgBox(48, "Autotravel Move", "WoW has not been detected. If WoW is installed, please start it manually.")
		EndIf
	EndIf
EndIf

; Start the mash loop
While 1
	
	; Capture whether WoW has run this session
	If WinExists($Title) Then
		$WoWRunning = 1
	EndIf
	
	; If WoW has run at some point
	If $WoWRunning = 1 Then
		; But is not running now...
		If Not WinExists($Title) Then
			; Quit
			Exit
		EndIf
	EndIf
	
	; Send the key
	If $CurrentlyRunning = 1 Then
		If StringLen($keybutton) > 1 Then
			ControlSend($Title, "", "", "{" & $keybutton & "}")
		Else
			ControlSend($Title, "", "", $keybutton)
		EndIf
	EndIf
	
	; Random Number Generator
	Sleep(Random($TimeDelayLow, $TimeDelayHigh))
WEnd

Func ToggleState()
	$CurrentlyRunning = Not $CurrentlyRunning
EndFunc   ;==>ToggleState

Func LoadSettings()
	; Write ini file
	$keybutton = IniRead(@ScriptDir & "\Autotravel Move.ini", "General Settings", "MashKey", "DOWN")
	$trigbutton = IniRead(@ScriptDir & "\Autotravel Move.ini", "General Settings", "PauseResumeKey", "UP")
	$TimeDelayLow = IniRead(@ScriptDir & "\Autotravel Move.ini", "General Settings", "TimeDelayLow", "50")
	$TimeDelayHigh = IniRead(@ScriptDir & "\Autotravel Move.ini", "General Settings", "TimeDelayHigh", "70")
	$Title = IniRead(@ScriptDir & "\Autotravel Move.ini", "General Settings", "Title", "World of Warcraft")
	$StartWoW = IniRead(@ScriptDir & "\Autotravel Move.ini", "General Settings", "StartWoW", "4") ;4=Unchecked
EndFunc   ;==>LoadSettings

Func SaveSettings()
	; Write ini file
	IniWrite(@ScriptDir & "\Autotravel Move.ini", "General Settings", "MashKey", $keybutton)
	IniWrite(@ScriptDir & "\Autotravel Move.ini", "General Settings", "PauseResumeKey", $trigbutton)
	IniWrite(@ScriptDir & "\Autotravel Move.ini", "General Settings", "TimeDelayLow", $TimeDelayLow)
	IniWrite(@ScriptDir & "\Autotravel Move.ini", "General Settings", "TimeDelayHigh", $TimeDelayHigh)
	IniWrite(@ScriptDir & "\Autotravel Move.ini", "General Settings", "Title", $Title)
	IniWrite(@ScriptDir & "\Autotravel Move.ini", "General Settings", "StartWoW", $StartWoW)
EndFunc   ;==>SaveSettings