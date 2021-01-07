;Set display properties for ASPIA VB13
;Required: 1280 x 1024 on monitor 1 and 2, 75 Hz, monitor 2 extends windows desktop

;This script works correctly only if display settings are the same as the initial settings
;before executing this script the first time!

;-- Init -----------
;tell user "hands off"
$SplashText = "DON'T TOUCH THE KEYBOARD Or THE MOUSE" & @LF & "While the script is running!"
SplashTextOn('Aspia Installer', $SplashText, 350, 80)

;configure AutoIt
AutoItSetOption("WinWaitDelay", 1000)
AutoItSetOption("WinTitleMatchMode", 2);set match mode less restrictive!
Dim $GraphicAdapter = ""
Dim $__msgbox = 0
Dim $Monitor = 1

;-- Let's GO --------
;open Display Properties dialog and activate "settings" tabcard
Run('rundll32.exe shell32.dll,Control_RunDLL desk.cpl,,3')
Sleep(1000)
Do
	WinActivate('Display Properties')
Until WinActive('Display Properties', '')
;---------------------------------------------------------------------------------------------------------
;-- LOOP to set display properties for the two monitors --------------------------------------------------
;---------------------------------------------------------------------------------------------------------
For $loop = 1 To 2
	If Not WinActive('Display Properties', '') Then WinActivate('Display Properties')
	
	While Not WinActive('Display Properties', 'Settings')
		Send('^{TAB}')
	WEnd        ; SelectTabCardSettings loop end
	
	; SelectMonitor
	Send('!d')
	Send($Monitor)
	Send('!s')
	Send('{LEFT 10}')
	
	While Not WinActive('Display Properties', '1280 by 1024 pixels')
		SplashTextOn('ASPIA Installer', $SplashText & @LF & @LF & 'Screen resolution for monitor ' & $Monitor & '.' & @LF, 350, 125)
		Send('!s')
		Send('{RIGHT}')
	WEnd        ; ScreenResolution loop end
	
	; ApplyScreenResolution
	;-----------------------------------------------------------------------------------------------------
	;extend Windows desktop to monitor 2
	;unfortunately no possibility to check the state of the checkbox at the moment
	;must be done here, if not, the screen resolution will be reset to 640x480 after pressing "Apply".
	;Why? Don't know.
	If @UserName <> "meduser" Then
		If $Monitor = 2 Then
			If ControlCommand("Display Properties", "", "Button4", "IsEnabled", "") Then
				If ControlCommand("Display Properties", "", "Button4", "IsChecked", "") = 0 Then ControlClick("Display Properties", "", "Button4")
			EndIf
		EndIf
	EndIf
	Send('!a')
	Sleep(1000)
	If WinActive('Monitor Settings', 'Your desktop has been reconfigured') Then Send('!y')
	Sleep(2000)
	
	; SetColorQuality
	SplashTextOn('ASPIA Installer', $SplashText & @LF & @LF & 'Color quality for monitor ' & $Monitor & '.' & @LF, 350, 125)
	If Not WinActive('Display Properties', '') Then WinActivate('Display Properties')
	Send('!c')
	Send('h')
	_AdvancedDisplaySettings()
	Sleep(1000)
	If Not WinActive('Display Properties', '') Then WinActivate('Display Properties')
	SplashTextOn('ASPIA Installer', $SplashText & @LF & @LF & 'Display Settings of Monitor ' & $Monitor & ' finished!' & @LF, 350, 125)
	$Monitor += 1
Next

;---------------------------------------------------------------------------------------------------------
; set screen saver to "none" and power off monitor to "never"
;---------------------------------------------------------------------------------------------------------

While Not WinActive('Display Properties', 'Screen Saver')    ; SelectTabCardScreenSaver loop
	Send('^+{TAB}')
	Sleep(1000)
WEnd        ; SelectTabCardScreenSaver

; ScreenSaverSettings
Send('!s')
Send('(')
; Monitor Power Management
Send('!o')
Sleep(1000)
If Not WinActive('Power Options Properties', '') Then WinActivate('Power Options Properties')
Send('!m')
Send('n')
;press "Apply" followed by "OK"
Send('!a')
Sleep(1000)
SplashTextOn('ASPIA Installer', $SplashText & @LF & @LF & 'Display Settings finished!' & @LF, 350, 125)
If WinActive('Monitor Settings', 'Your desktop has been reconfigured') Then Send('!y')
WinWaitActive('Power Options Properties')
Send('+{TAB 3}')
Send('{ENTER}')
;back at "Display Properties" dialog, press "Apply"
Sleep(1000)
If Not WinActive('Display Properties', '') Then WinWaitActive('Display Properties')
Send('!a')
Sleep(1000)
If WinActive('Monitor Settings', 'Your desktop has been reconfigured') Then Send('!y') ;if a window pops up asking you to keep the settings, press Yes
Sleep(1000)
If Not WinActive('Display Properties', '') Then WinWaitActive('Display Properties')
Send('{TAB 2}')
Send('{ENTER}')

Exit; End Script

;################################################ FUNCTION _AdvancedDisplaySettings() ################################################
Func _AdvancedDisplaySettings()
	While 1
		SplashTextOn('ASPIA Installer', $SplashText & @LF & @LF & 'Advanced display settings for monitor ' & $Monitor & '.' & @LF, 350, 125)
		If Not WinActive('Display Properties', '') Then WinActivate('Display Properties')
		Send('!v')
		Sleep(2000)
		
		If Not WinActive('NVIDIA Quadro', '') Then WinActivate('NVIDIA Quadro')
		If WinActive('NVIDIA Quadro FX 1400 Properties', '') Then $GraphicAdapter = 'NVIDIA Quadro FX 1400'
		If WinActive('NVIDIA Quadro4 980 XGL Properties', '') Then $GraphicAdapter = 'NVIDIA Quadro4 980 XGL'
		If $GraphicAdapter = "NVIDIA Quadro FX 1400" Or $GraphicAdapter = "NVIDIA Quadro4 980 XGL" Or $__msgbox = 5 Then
			; SetRefreshRate Force extra clausing
			SplashTextOn('ASPIA Installer', $SplashText & @LF & @LF & 'Refresh rate for monitor ' & $Monitor & '.' & @LF, 350, 125)
			If Not WinActive('NVIDIA Quadro', '') Then WinActivate('NVIDIA Quadro')
			Send('^{TAB 2}')
			Send('!s')
			Send(7)
			Send(5)
			Send('!a')
			Sleep(1000)
			;if a window pops up asking you to keep the settings, press Yes
			If WinActive('Monitor Settings', 'Your desktop has been reconfigured') Then Send('!y')
			Sleep(1000)
			
			; ApplyPredefinedNVIDIAProfile
			If Not WinActive('NVIDIA Quadro', '') Then WinActivate('NVIDIA Quadro')
			Send('^+{TAB 3}')
			Sleep(1000)
			Send('+{TAB}')
			If Not WinActive('NVIDIA Properties', '') Then WinActivate('NVIDIA Properties')
			Send('{UP 12}')
			Send('{DOWN 2}')
			Send('{TAB}')
			Sleep(1000)
			Send('!t')
			Send('ASPIA')
			Send('!a')
			Sleep(1000)
			Send('{ENTER}')
			ExitLoop
		Else
			Send('{ENTER}'); close properties window
			;open a message box ABORT+RETRY+IGNORE+MB_ICONHAND+MB_SYSTEMMODAL
			$__msgbox = MsgBox(4114, 'ASPIA Installer', 'Invalid graphics adapter! Only NVIDIA Quadro4 980 XGL and NVIDIA Quadro FX 1400 are allowed!')
			If $__msgbox = 3 Then ExitLoop ;abort
			If $__msgbox = 4 Then 
				;ContinueLoop
			EndIf
			If $__msgbox = 5 Then ;ignore, reopen propeties window
				;ContinueLoop
			EndIf
		EndIf
	WEnd
EndFunc   ;==>_AdvancedDisplaySettings
