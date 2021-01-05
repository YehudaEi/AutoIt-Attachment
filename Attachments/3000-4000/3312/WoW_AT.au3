; ----------------------------------------------------------------------------
;
; AutoIt Version: 3.1.0
; Author:         Stumpii, Modified by CPC197C
;
; Script Function:
;	The Autotravel Move script removes some of the tedium of continually
;  clicking a button to turn when using the Autotravel Addon for the World of
;  Warcraft game.
;
; ----------------------------------------------------------------------------

$keybutton = "Down"
$trigbutton = "Up"
$CurrentlyRunning = 0
$WoWWasRunning = 0
$WoWRunning = 0
$SleepTime = 700
$ChooseSettings = 0

;Include constants
#include <GUIConstants.au3>

Global $GUIWidth
Global $GUIHeight

$GUIWidth = 180
$GUIHeight = 120

;Create window
GUICreate("New GUI", $GUIWidth, $GUIHeight)

;Text box with "Down"
$Edit_1 = GUICtrlCreateEdit("Down", 10, 20, 70, 35)

;Text box with "Up"
$Edit_2 = GUICtrlCreateEdit("Up", 100, 20, 70, 35)

;Create an "Start!" button
$OK_Btn = GUICtrlCreateButton("Start!", 55, 60, 70, 25)

;Create a "Cancel" button
$Cancel_Btn = GUICtrlCreateButton("Cancel", 55, 85, 70, 25)

;Labels
GuiCtrlCreateLabel("Mash Button", 10, 0, 70, 20)
GuiCtrlCreateLabel("Trigger Button", 100, 0, 70, 20)


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
	 Msgbox(64, "nenr", $keybutton & ", " & $trigbutton)
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
	If WinExists("World of Warcraft") Then
		$WoWRunning = 1
	EndIf
	
	; If WoW has run at some point
	If $WoWRunning = 1 Then
		; But is not running now...
		If not WinExists("World of Warcraft") Then
			; Quit
			Exit
		EndIf
	Endif

	if $CurrentlyRunning = 1 Then
			ControlSend( "World of Warcraft", "", "", "{" & $Keybutton & "}")
	endif

	  ; Random Number Generator
	$Sleeptime = Random(500, 700)
	sleep($Sleeptime)
Wend

Func ToggleState()
	$CurrentlyRunning = not $CurrentlyRunning
EndFunc