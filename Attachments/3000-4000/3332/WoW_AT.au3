; ----------------------------------------------------------------------------
;
; AutoIt Version: 3.1.1
; Author:         Stumpii
; Modified by:    CPC197C
;                 h8no1
;
; Script Function:
;	The Autotravel Move script removes some of the tedium of continually
;  clicking a button to turn when using the Autotravel Addon for the World of
;  Warcraft game.
;
; ----------------------------------------------------------------------------

$keybutton = "DOWN"
$trigbutton = "UP"
$CurrentlyRunning = 0
$WoWWasRunning = 0
$WoWRunning = 0
$SleepTime = 100
$ChooseSettings = 0
$Title = "World of Warcraft"

$keys = "SPACE|ENTER|ALT|BACKSPACE|DELETE|UP|DOWN|LEFT|RIGHT|HOME|END|ESCAPE|INSERT|PGUP|PGDN|F1|F2|F3|F4|F5|F6|F7|F8|F9|F10|F11|F12|TAB|PRINTSCREEN|LWIN|RWIN|CTRLBREAK|PAUSE|NUMPAD0|NUMPAD1|NUMPAD2|NUMPAD3|NUMPAD4|NUMPAD5|NUMPAD6|NUMPAD7|NUMPAD8|NUMPAD9|NUMPADMULT|NUMPADADD|NUMPADSUB|NUMPADDIV|NUMPADDOT|NUMPADENTER|APPSKEY|LALT|RALT|LCTRL|RCTRL|LSHIFT|RSHIFT"


;Include constants
#include <GUIConstants.au3>

Global $GUIWidth
Global $GUIHeight

$GUIWidth = 270
$GUIHeight = 120

;Create window
GUICreate("WoW Masher", $GUIWidth, $GUIHeight)

;Labels
GuiCtrlCreateLabel("Mash Button", 10, 0, 70, 20)
GuiCtrlCreateLabel("Trigger Button", 140, 0, 70, 20)
GuiCtrlCreateLabel("Sleep Time", 10, 40, 70, 20)
GuiCtrlCreateLabel("Title Name", 10, 80, 70, 20)

;Dropdown for Mash key
$Edit_1 = GUICtrlCreateCombo("", 10, 15, 120, 20)
GUICtrlSetData(-1,$keys,"DOWN")

;Dropdown for Trigger
$Edit_2 = GUICtrlCreateCombo("", 140, 15, 120, 20)
GUICtrlSetData(-1,$keys,"UP")

;Sleep Time inputbox
$Edit_3 = GUICtrlCreateInput("50", 10, 55, 70, 20, $ES_RIGHT)

;Title Name inputbox
$Edit_4 = GUICtrlCreateInput("World of Warcraft", 10, 95, 100, 20, $ES_LEFT)

;Create an "Start!" button
$OK_Btn = GUICtrlCreateButton("Start!", 150, 60, 70, 25)

;Create a "Cancel" button
$Cancel_Btn = GUICtrlCreateButton("Cancel", 150, 85, 70, 25)

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
	 $Trigbutton = GUICtrlRead($Edit_2)
	 $SleepTime = GUICtrlRead($Edit_3)
	 $Title = GUICtrlRead($Edit_4)
	 Msgbox(64, "Keys that are used... ", $keybutton & ", " & $trigbutton)
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
HotKeySet("{" & $Trigbutton & "}", "ToggleState")

#Region --- CodeWizard generated code Start ---
;MsgBox features: Title=Yes, Text=Yes, Buttons=OK, Icon=Warning
MsgBox(48,"Autotravel Move","Using this program may violate the TOS of the WoW game. Use at you own risk.")
#EndRegion --- CodeWizard generated code End ---

while 1
	
	; Capture whether WoW has run this session
	If WinExists($Title) Then
		$WoWRunning = 1
	EndIf
	
	; If WoW has run at some point
	If $WoWRunning = 1 Then
		; But is not running now...
		If not WinExists($Title) Then
			; Quit
			Exit
		EndIf
	Endif

	if $CurrentlyRunning = 1 Then
			ControlSend($Title, "", "", "{" & $Keybutton & "}")
	endif

	; Random Number Generator
	sleep(Random($Sleeptime, $Sleeptime*2))
Wend

Func ToggleState()
	$CurrentlyRunning = not $CurrentlyRunning
EndFunc
