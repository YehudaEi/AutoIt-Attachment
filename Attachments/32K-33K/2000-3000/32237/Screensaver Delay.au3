; Author:  Jonathan King
; Version  1.5
; Date:    11/02/2010
; Purpose: To allow an end-user to delay the onset of the locking screensaver
; Method:  Allow user to choose 30,40,50 minute delay. Read the current GP setting and wake-up every GP-1 minute to check if more time is needed


#include <Timers.au3>
#include <Constants.au3>

;Opt("TrayIconDebug",1)
Opt("TrayOnEventMode", 0)
Opt("TrayAutoPause", 0)
Opt("TrayMenuMode", 1+2) ; Default tray menu items (Script Paused/Exit) will not be shown.

; Set the hotkey for quitting the application
HotKeySet("^!q", "_ExitLoop")

; Get the current screensaver timeout value from group policy settings (in seconds)
Global $sTimeOut = RegRead("HKCU\Software\Policies\Microsoft\Windows\Control Panel\Desktop", "ScreenSaveTimeOut")
Global $minTimeOut = $sTimeOut / 60 ; timeout in minutes
Global $msTimeOut = $sTimeOut * 1000 ; timeout in ms

Global $stopped = True ; System is stopped
Global $running = False ; System is running
Global $oldRemaining = 0 ;

Global $minTime = 0 ; value of the current requested delay, used for IPC
Global $startTime = _Timer_Init() ; the time a user made a selection
Global $curTime = -1 ; the current delay value
Global $msDelay = -1 ; The delay requested in ms

Global $a = 1 ; value used to move the y-coord of the cursor
Global $timeItemDefaultText = "Time Remaining: Choose time from list"

; Setup the Tray Menu
$aboutItem = TrayCreateItem("About")
TrayCreateItem("")

$noItem = TrayCreateItem("No delay (Cancel)", -1, -1, 1)
$2Item = TrayCreateItem("Delay 2 Minutes (Testing Only)", -1, -1, 1)
$5Item = TrayCreateItem("Delay 5 Minutes (Testing Only)", -1, -1, 1)
$30Item = TrayCreateItem("Delay 30 Minutes", -1, -1, 1)
$45Item = TrayCreateItem("Delay 45 Minutes", -1, -1, 1)
$60Item = TrayCreateItem("Delay 60 Minutes", -1, -1, 1)
$75Item = TrayCreateItem("Delay 75 Minutes", -1, -1, 1)

TrayCreateItem("")
$minTimeItem = TrayCreateItem("Screensaver activation delay: " & $minTimeOut & " minutes")
$timeItem = TrayCreateItem($timeItemDefaultText)
TrayCreateItem("")
$exitItem = TrayCreateItem("Exit <CTRL-ALT-q>")

TraySetIcon("shell32.dll", 251)
TraySetState(1) ; Show the icon

; Set the default configuration
resetVars()
resetTray()

; Enter into an infinite loop, polling the Tray and checking to see if mouse activity is needed
; Exit if the user selects the hotkey or menu item
While 1
	$msg = TrayGetMsg()
	Select
		Case $msg = 0
			ContinueLoop
		Case $msg = $noItem
			resetVars()
			resetTray()
		Case $msg = $2Item
			config(2)
		Case $msg = $5Item
			config(5)
		Case $msg = $30Item
			config(30)
		Case $msg = $45Item
			config(45)
		Case $msg = $60Item
			config(60)
		Case $msg = $75Item
			config(75)
		Case $msg = $aboutItem
			DoAbout()
		Case $msg = $exitItem
			DoExit()
	EndSelect

	; Update only if the timer is still counting down
	If (_Timer_Diff($startTime) < $msDelay) Then

		$mRemaining = Round(($msDelay - _Timer_Diff($startTime)) / 1000 / 60, 0)

		; Create the correct string for output in menu and tooltip, but only if it has changed from the last loop
		If $mRemaining <> $oldRemaining Then
			If $mRemaining = 1 Then
				$str = "Time remaining: " & Round($mRemaining, 0) & " minute"
			Else
				$str = "Time remaining: " & Round($mRemaining, 0) & " minutes"
			EndIf

			TraySetToolTip($str)
			TrayItemSetText($timeItem, $str)
			$oldRemaining = $mRemaining
		EndIf

		; Set the icon based on the percentage time elapsed
		SetIcon(1 - (_Timer_Diff($startTime) / $msDelay))

		; Get the current idle time of the computer (ms)
		$msIdleTime = _Timer_GetIdleTime()

		; move the cursor if we are more than msTimeOut from the deadline and the idletime is within 2 min
		If ($msDelay - _Timer_Diff($startTime) > $msTimeOut And $msIdleTime + 120000 > $msTimeOut) Then
			MoveCursor()
		EndIf

		; check for Lock/Screensaver activation

	Else ; we have either finished our countdown, or not started yet
		resetTray()
	EndIf

WEnd

Exit 0
; End of main code. Functions defined below


; Set the global variables to default values
Func resetVars()
	Global $stopped = True ; System is stopped
	Global $running = False ; System is running
	Global $oldRemaining = 0 ;

	Global $minTime = 0 ; value of the current requested delay, used for IPC
	Global $startTime = _Timer_Init() ; the time a user made a selection
	Global $curTime = -1 ; the current delay value
	Global $msDelay = -1 ; The delay requested in ms
EndFunc   ;==>resetVars

; Set the Tray back to default settings
Func resetTray()
	TraySetToolTip($timeItemDefaultText)
	TrayItemSetText($timeItem, $timeItemDefaultText)
	TrayItemSetState($noItem, $TRAY_CHECKED) ; set this as the default, checked, item
	TrayItemSetState($minTimeItem, $TRAY_DISABLE + $TRAY_UNCHECKED)
	TrayItemSetState($timeItem, $TRAY_DISABLE + $TRAY_UNCHECKED)
	TraySetIcon("shell32.dll", 251)
EndFunc   ;==>resetTray

; Configure a new running timer
Func config($newTime)
	Global $minTime
	Global $msDelay
	Global $startTime
	Global $running = True
	; set the new time
	$minTime = $newTime
	; The delay requested in ms
	$msDelay = $minTime * 60 * 1000
	; Get the time that the user made a selection
	$startTime = _Timer_Init()

	; uncheck the No Delay item since we've selected a new delay value
	TrayItemSetState($noItem, $TRAY_UNCHECKED) ; set this as the default, checked, item
EndFunc   ;==>config


; Set the icon based on the percentage ($i) of time elapsed
Func SetIcon($i)
	If ($i >= 0.75) Then
		TraySetIcon("wpdshext.dll", 714) ; full
	ElseIf ($i >= 0.50) Then
		TraySetIcon("wpdshext.dll", 713) ; 75%
	ElseIf ($i >= 0.25) Then
		TraySetIcon("wpdshext.dll", 712) ; 50%
	ElseIf ($i >= 0.05) Then
		TraySetIcon("wpdshext.dll", 711) ; 25% Warning
	Else ; ($i >= 0.00)
		TraySetIcon("wpdshext.dll", 710) ; 5% Big Warning
	EndIf
EndFunc   ;==>SetIcon

Func MoveCursor()
	$a = $a * - 1; Change from -1 to 1 and 1 to -1 so the cursor doesn't move far
	$x = MouseGetPos(0)
	$y = MouseGetPos(1)
	; MsgBox ( 0, "MSG", "MousePos: "&amp;amp;amp;amp; $x &amp;amp;amp;amp;", " &amp;amp;amp;amp; $y , 1 )
	MouseMove($x, $y + $a, 1)
EndFunc   ;==>MoveCursor

Func DoAbout()
	MsgBox(64, "About:", "Screensaver Delay 1.0, by Jonathan King")
EndFunc   ;==>DoAbout

Func DoExit()
	Exit (0)
EndFunc   ;==>DoExit

Func _ExitLoop()
	Exit (0)
EndFunc   ;==>_ExitLoop