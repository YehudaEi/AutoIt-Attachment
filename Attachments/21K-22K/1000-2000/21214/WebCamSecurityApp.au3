#include <ButtonConstants.au3>
#include <GUIConstantsEx.au3>
#include <SliderConstants.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#Include <ScreenCapture.au3>
Global $roll =0
Global $count =0
Global $avg = 0
Global $sus =0
Global $sensitivity=0
Global $ndsEvents=0
Opt("GUIOnEventMode", 1)
#Region ### START Koda GUI section ### Form=C:\Documents and Settings\Luser1\Desktop\Kids Games\WebCamSecurity.kxf
$Form2 = GUICreate("Nigels WebCam Security Program V1.2     30-6-08", 367, 147, 411, 377)
GUISetOnEvent($GUI_EVENT_CLOSE, "Form2Close")
GUISetOnEvent($GUI_EVENT_MINIMIZE, "Form2Minimize")
GUISetOnEvent($GUI_EVENT_MAXIMIZE, "Form2Maximize")
GUISetOnEvent($GUI_EVENT_RESTORE, "Form2Restore")
$Button1 = GUICtrlCreateButton("Start", 8, 8, 75, 25, 0)
GUICtrlSetOnEvent(-1, "Button1Click")
$Button2 = GUICtrlCreateButton("STOP", 96, 8, 75, 25, 0)
GUICtrlSetOnEvent(-1, "Button2Click")
$Slider1 = GUICtrlCreateSlider(8, 72, 345, 25)
GUICtrlSetOnEvent(-1, "Slider1Change")
$Label1 = GUICtrlCreateLabel("Sensitivity Sider", 136, 48, 78, 17)
GUICtrlSetOnEvent(-1, "Label1Click")
$Label2 = GUICtrlCreateLabel("Events Detected", 16, 120, 84, 17)
GUICtrlSetOnEvent(-1, "Label2Click")
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###

While 1
	Sleep(200)
WEnd

Func ScanAMCAP()
	$roll=0
	For $y = 50 to 320 step 10
		for $x = 10 to 350 step 10
			$pval = PixelGetColor($x,$y)
			$roll = $roll + $pval
			$count = $count+ 1
		Next
	Next
	Return $roll & $count
EndFunc

Func Button1Click(); the start button 
	Run("C:\Program Files\USB PC Cam Plus\Amcap.exe")
	TrayTip("AMCAP is running","Please wait for the camera to stablise!",10)
	Sleep(5000)
	WinMove("AMCAP","",0,0)
	Sleep(250)
	$ndsi = 0
	while $ndsi <> 9
		Sleep(200)
		ScanAMCAP(); perform the scan
		$Aavg = $roll/$count ; 
		$ndsx = Round($Aavg,-1)
		if $ndsx >= $sensitivity*10000 Then
			$ndsEvents = $ndsEvents + 1
			GUICtrlCreateLabel($ndsEvents, 110, 120, 84, 17)
			endif
	WEnd
EndFunc

Func Button2Click()

EndFunc
Func Form2Close()
	Exit
EndFunc
Func Form2Maximize()

EndFunc
Func Form2Minimize()

EndFunc
Func Form2Restore()

EndFunc
Func Label1Click()

EndFunc
Func Label2Click()

EndFunc
Func Slider1Change()
 $ndsSen = GuiCtrlRead($Slider1)
 $Label3 = GUICtrlCreateLabel($ndsSen&"%", 220, 48, 78, 17)
 $sensitivity = $ndsSen
EndFunc
