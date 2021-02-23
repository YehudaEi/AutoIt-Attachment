Opt("GUIOnEventMode", 1)  ; Change to OnEvent mode
; ----------------------------------------------------------------------------
; START INCLUDING ALL NECESSARY AUTOIT FILES TO RUN
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
#include <GuiRichEdit.au3>
#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <StaticConstants.au3>
#include <ProgressConstants.au3>
#Include <GuiToolBar.au3>
; ----------------------------------------------------------------------------
; END INCLUDES
; ----------------------------------------------------------------------------
$HealthCheck_Page1 = GUICreate("", 500, 495, -1, -1, $WS_POPUP)
GUISetBkColor(0x313131, $HealthCheck_Page1)
; ** Set Background **
;GUICtrlCreatePic("./images/menubackground.jpg", 0, 0, 500, 500, $WS_CLIPSIBLINGS)
; ** Create Header image **
;GUICtrlCreatePic("./images/bannerhealthchecks.jpg", 0, 0, 500, 193)
; ** Create Input Fields **
GUICtrlCreateLabel("Customer Name: ", 10, 198, 140, 30)
GUICtrlSetFont(-1, 14, 400, 0, "Comic Sans MS")
GUICtrlSetBkColor(-1, 0x313131)
GUICtrlSetColor(-1, 0xb8b8b8)
$HealthCheck_P1_Customer = GUICtrlCreateInput("", 160, 198, 330, 30, "", $WS_EX_TRANSPARENT)
GUICtrlSetFont(-1, 14, 400, 0, "Comic Sans MS")
GUICtrlSetBkColor(-1, 0x414141)
GUICtrlSetColor(-1, 0xb8b8b8)
GUICtrlCreateLabel("Machine ID: ", 10, 238, 140, 30)
GUICtrlSetFont(-1, 14, 400, 0, "Comic Sans MS")
GUICtrlSetBkColor(-1, 0x313131)
GUICtrlSetColor(-1, 0xb8b8b8)
$HealthCheck_P1_MachineID = GUICtrlCreateInput("", 160, 238, 330, 30, "", $WS_EX_TRANSPARENT)
GUICtrlSetFont(-1, 14, 400, 0, "Comic Sans MS")
GUICtrlSetBkColor(-1, 0x414141)
GUICtrlSetColor(-1, 0xb8b8b8)
; ** Create Checkboxes **
GUICtrlCreateLabel("Create a restore point first: ", 10, 281, 300, 30)
GUICtrlSetFont(-1, 14, 400, 0, "Comic Sans MS")
GUICtrlSetBkColor(-1, 0x313131)
GUICtrlSetColor(-1, 0xb8b8b8)
$HealthCheck_P1_RestorePointSlide = GUICtrlCreatePic("./switchoff.bmp", 305, 278, 60, 30, $SS_NOTIFY)
GUICtrlSetOnEvent($HealthCheck_P1_RestorePointSlide, "HealthCheck_P1_Restore")
$HealthCheck_P1_RestorePointSlideVar = 0
GUICtrlCreateLabel("Backup registry first: ", 10, 321, 300, 30)
GUICtrlSetFont(-1, 14, 400, 0, "Comic Sans MS")
GUICtrlSetBkColor(-1, 0x313131)
GUICtrlSetColor(-1, 0xb8b8b8)
$HealthCheck_P1_RegistrySlide = GUICtrlCreatePic("./switchoff.bmp", 305, 318, 60, 30, $SS_NOTIFY)
GUICtrlSetOnEvent($HealthCheck_P1_RegistrySlide, "HealthCheck_P1_Registry")
$HealthCheck_P1_RegistrySlideVar = 0
GUICtrlCreateLabel("Produce report for this machine: ", 10, 361, 300, 30)
GUICtrlSetFont(-1, 14, 400, 0, "Comic Sans MS")
GUICtrlSetBkColor(-1, 0x313131)
GUICtrlSetColor(-1, 0xb8b8b8)
$HealthCheck_P1_ReportSlide = GUICtrlCreatePic("./switchoff.bmp", 305, 358, 60, 30, $SS_NOTIFY)
GUICtrlSetOnEvent($HealthCheck_P1_ReportSlide, "HealthCheck_P1_Report")
$HealthCheck_P1_ReportSlideVar = 0
GUICtrlCreateLabel("Reboot machine when completed: ", 10, 401, 300, 30)
GUICtrlSetFont(-1, 14, 400, 0, "Comic Sans MS")
GUICtrlSetBkColor(-1, 0x313131)
GUICtrlSetColor(-1, 0xb8b8b8)
$HealthCheck_P1_RebootSlide = GUICtrlCreatePic("./switchoff.bmp", 305, 398, 60, 30, $SS_NOTIFY)
GUICtrlSetOnEvent($HealthCheck_P1_RebootSlide, "HealthCheck_P1_Reboot")
$HealthCheck_P1_RebootSlideVar = 0
; ** Navigation Buttons **
$HealthCheck_P1_BackBtn = GUICtrlCreatePic("./exit.bmp", 10, 448, 106, 37, $SS_NOTIFY)
GUICtrlSetOnEvent($HealthCheck_P1_BackBtn, "HealthCheck_P1_Back")
$HealthCheck_P1_NextBtn = GUICtrlCreatePic("./exit.bmp", 384, 448, 106, 37, $SS_NOTIFY)
GUICtrlSetOnEvent($HealthCheck_P1_NextBtn, "HealthCheck_P1_Next")
GUISetState(@SW_SHOW, $HealthCheck_Page1)
While 1
  Sleep(500)   ; Just idle around
WEnd
; ----------------------------------------------------------------------------
; START FUNCTIONS FOR PAGE
; ----------------------------------------------------------------------------
Func HealthCheck_P1_Back()
	Exit
EndFunc

Func HealthCheck_P1_Next()
	Exit
EndFunc

Func HealthCheck_P1_Reboot()
	If $HealthCheck_P1_RebootSlideVar = 0 Then
		GUICtrlSetImage($HealthCheck_P1_RebootSlide, "./switchon.bmp")
		$HealthCheck_P1_RebootSlideVar = 1
	Else
		GUICtrlSetImage($HealthCheck_P1_RebootSlide, "./switchoff.bmp")
		$HealthCheck_P1_RebootSlideVar = 0
	EndIf
EndFunc

Func HealthCheck_P1_Report()
	If $HealthCheck_P1_ReportSlideVar = 0 Then
		GUICtrlSetImage($HealthCheck_P1_ReportSlide, "./switchon.bmp")
		$HealthCheck_P1_ReportSlideVar = 1
	Else
		GUICtrlSetImage($HealthCheck_P1_ReportSlide, "./switchoff.bmp")
		$HealthCheck_P1_ReportSlideVar = 0
	EndIf
EndFunc

Func HealthCheck_P1_Registry()
	If $HealthCheck_P1_RegistrySlideVar = 0 Then
		GUICtrlSetImage($HealthCheck_P1_RegistrySlide, "./switchon.bmp")
		$HealthCheck_P1_RegistrySlideVar = 1
	Else
		GUICtrlSetImage($HealthCheck_P1_RegistrySlide, "./switchoff.bmp")
		$HealthCheck_P1_RegistrySlideVar = 0
	EndIf
EndFunc

Func HealthCheck_P1_Restore()
	If $HealthCheck_P1_RestorePointSlideVar = 0 Then
		GUICtrlSetImage($HealthCheck_P1_RestorePointSlide, "./switchon.bmp")
		$HealthCheck_P1_RestorePointSlideVar = 1
	Else
		GUICtrlSetImage($HealthCheck_P1_RestorePointSlide, "./switchoff.bmp")
		$HealthCheck_P1_RestorePointSlideVar = 0
	EndIf
EndFunc
; ----------------------------------------------------------------------------
; END FUNCTIONS
; ----------------------------------------------------------------------------