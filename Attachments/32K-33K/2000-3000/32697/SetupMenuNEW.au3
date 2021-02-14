#RequireAdmin
#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.6.1
 Author:         Adam Mallinson
 Version:		 0.1 BETA (Working code taken from current setup menu where available)

 Script Function:
	Setup new machines for use by clients

#ce ----------------------------------------------------------------------------
Opt("GUIOnEventMode", 1)  ; Change to OnEvent mode

; ----------------------------------------------------------------------------
; Include all relevant files
; ----------------------------------------------------------------------------
#include <String.au3>
#include <Array.au3>
#include <Math.au3>
#include <Date.au3>
#include <File.au3>
#include <FileConstants.au3>
#include <WindowsConstants.au3>
#include <GUIConstants.au3>
#include <GUIConstantsEX.au3>
#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <StaticConstants.au3>
#include <ProgressConstants.au3>
; Include compinfo.au3 if required
; ----------------------------------------------------------------------------
; End Includes
; ----------------------------------------------------------------------------

; ----------------------------------------------------------------------------
; Functions - Listed below or includes if seperate files
; ----------------------------------------------------------------------------

; ----------------------------------------------------------------------------
; End Functions
; ----------------------------------------------------------------------------

; ----------------------------------------------------------------------------
; Start Script
; ----------------------------------------------------------------------------
; Create GUI
; ----------------------------------------------------------------------------
$WELCOME = GUICreate("", 500, 250, -1, -1, $WS_POPUP)
GUISetBkColor(0x313131, $WELCOME)
GUICtrlCreatePic("./bannercs.jpg", 0, 0, 500, 193)
GUICtrlCreateLabel("To setup this machine click continue", 10, 175, 480, 20, $SS_CENTER)
GUICtrlSetColor(-1, 0xFFFFFF)
GUICtrlSetBkColor(-1, 0x313131)
$WelcomeButtonContinue = GUICtrlCreatePic("./continue.jpg", 410, 210, 80, 30, $SS_NOTIFY) ; Create continue button that is 80 x 30 px
GUISetOnEvent($WelcomeButtonContinue, "WelcomeButtonContinue")
$WelcomeButtonClose = GUICtrlCreatePic("./exit.jpg", 10, 210, 80, 30, $SS_NOTIFY) ; Create exit button that is 80 x 30 px
GUISetOnEvent($WelcomeButtonClose, "WelcomeButtonExit")
GUISetState(@SW_SHOW, $WELCOME)
$SELECTTYPE = GUICreate("", 500, 270, -1, -1, $WS_POPUP)
GUISetBkColor(0x313131, $SELECTTYPE)
GUICtrlCreatePic("./bannercs.jpg", 0, 0, 500, 193)
GUICtrlCreateLabel("Please select build type below:", 10, 175, 480, 20, $SS_CENTER)
GUICtrlSetColor(-1, 0xFFFFFF)
GUICtrlSetBkColor(-1, 0x313131)
$SelectTypeDefault = GUICtrlCreatePic("./default.jpg", 210, 190, 80, 30, $SS_NOTIFY)
GUISetOnEvent($SelectTypeDefault, "SelectTypeDefault")
$SelectTypeCustom = GUICtrlCreatePic("./custom.jpg", 210, 230, 80, 30, $SS_NOTIFY)
GUISetOnEvent($SelectTypeCustom, "SelectTypeCustom")
GUISetState(@SW_HIDE, $SELECTTYPE)
GUISwitch($WELCOME)
sleep(1000)
; Enter loop for processing
While 1
	Sleep (1000)
WEnd
; Functions for menu buttons
Func WelcomeButtonContinue()
	$write = RegWrite("HKLM\SOFTWARE\Policies\Builds", "STAGE", "REG_SZ", "1")
	GUISetState(@SW_HIDE, $WELCOME)
	GUISetState(@SW_SHOW, $SELECTTYPE)
	GUISwitch($SELECTTYPE)
EndFunc

Func WelcomeButtonExit()
	Exit
EndFunc

Func SelectTypeDefault()
	; Call button2() Function
	$write = RegWrite("HKLM\SOFTWARE\Policies\Builds", "STAGE", "REG_SZ", "2")
	Exit
EndFunc

Func SelectTypeCustom()
	; Call button3() Function
	; Show GUI to select applications
	$write = RegWrite("HKLM\SOFTWARE\Policies\Builds", "STAGE", "REG_SZ", "2")
	Exit
EndFunc