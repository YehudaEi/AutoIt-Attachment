#NoTrayIcon

;.......script written by trancexx (trancexx at yahoo dot com)

#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>

Opt("MustDeclareVars", 1)
Opt("WinWaitDelay", 0)

; Will use two dlls on this level
Global Const $hUSER32 = DllOpen("user32.dll")
Global Const $hMSVFW32 = DllOpen("msvfw32.dll") ; <- It's about this one

; MCI constants
Global Const $MCIWNDF_NOMENU = 0x000008
Global Const $MCIWNDF_NOERRORDLG = 0x004000
Global Const $MCIWNDF_NOOPEN = 0x008000
Global Const $MCIWNDF_SHOWNAME = 0x000010

Global Const $MCI_SETTIMEFORMAT = 0x04DB
Global Const $MCIWND_PLAY = 0x0806
Global Const $MCI_PLAYFROM = 0x047A
Global Const $MCIWND_STOP = 0x0808
Global Const $MCIWND_GETPOSITION = 0x04CA
Global Const $MCIWND_CAN_PLAY = 0x0490
Global Const $MCIWND_GETLENGTH = 0x0468
Global Const $MCIWND_SETVOLUME = 0x046E

; Different global variables
Global $sFile, $iVol, $iBlued, $iLength, $iCurPos, $iDone, $iIsPlayable

; Make a gui with WS_EX_TOPMOST
Global $hGUI = GUICreate("Little player", 380, 200, -1, -1, -1, 8) ; WS_EX_TOPMOST

; Initial MCI window
Global $hMCI = _MCIWndCreate(0, "", 0x00C4C018) ; WS_CAPTION|WS_SIZEBOX|MCIWNDF_NOMENU|MCIWNDF_NOERRORDLG|MCIWNDF_NOOPEN|MCIWNDF_SHOWNAME

; Get hight of MCI window if not loaded. This is needed not to show that window when playing music files
Global $iMinHight = _MCIGetMinHight($hMCI)

; Different controls
Global $hLabelDemo = GUICtrlCreateLabel("msvfw32.dll demonstration", 10, 12, 180, 20)
GUICtrlSetColor($hLabelDemo, 0x0000CC)
GUICtrlSetFont($hLabelDemo, 10, 800, 1, "Trebuchet MS")
Global $hLabelPassed = GUICtrlCreateLabel("", 150, 70, 140, 20)

Global $hLabelLength = GUICtrlCreateLabel("", 260, 30, 135, 20)

Global $hButtonPlay = GUICtrlCreateButton("&Play", 50, 90, 90)
GUICtrlSetState($hButtonPlay, $GUI_DISABLE)

Global $hButtonPause = GUICtrlCreateButton("Pa&use", 155, 90, 70)
GUICtrlSetState($hButtonPause, $GUI_DISABLE)

Global $hButtonStop = GUICtrlCreateButton("&Stop", 240, 90, 90)
GUICtrlSetState($hButtonStop, $GUI_DISABLE)

Global $hProgressPos = GUICtrlCreateProgress(10, 45, 360, 20)

Global $hVol = GUICtrlCreateSlider(7, 80, 20, 75, 3)
GUICtrlCreateLabel("VOL", 7, 155, 35, 20)

Global $hLabelLoadedWith = GUICtrlCreateLabel("", 50, 130, 100, 20)

Global $hLabelName = GUICtrlCreateLabel("", 50, 145, 305, 20)
GUICtrlSetColor($hLabelName, 0x0000CC)
GUICtrlSetFont($hLabelName, 10, 400, 1, "Trebuchet MS")

; Menu
Global $sFilemenu = GUICtrlCreateMenu("&File")
Global $sFileitem = GUICtrlCreateMenuItem("&Open", $sFilemenu)
GUICtrlSetState($sFileitem, $GUI_DEFBUTTON)
GUICtrlCreateMenuItem("", $sFilemenu)
Global $hExitItem = GUICtrlCreateMenuItem("&Exit", $sFilemenu)


; Show it
GUISetState()

; Handle things
While 1

	Switch GUIGetMsg()
		Case $GUI_EVENT_CLOSE
			ExitLoop
		Case $hButtonPlay
			If $iIsPlayable Then Play()
		Case $hButtonPause
			If $iIsPlayable Then Pause()
		Case $hButtonStop
			If $iIsPlayable Then Stop()
		Case $sFileitem
			$sFile = FileOpenDialog("Choose fle", "", "(*.wmv;*.avi;*.wma;*.mid;*.wav;*.mp3;*.rmi;*.aif;*.au;*.snd)|All files(*)", 1, "", $hGUI)
			If Not @error Then
				$iIsPlayable = LoadPlayer($sFile)
			EndIf
		Case $hExitItem
			Exit
	EndSwitch

	SetProgress()

WEnd

; THE END



; Functions:

Func Play()

	GUICtrlSetData($hLabelLoadedWith, "Playing:")
	; Play then
	_SendMCIMessage($hMCI, $MCIWND_PLAY)
	$iCurPos = 0
	$iDone = 0

EndFunc   ;==>Play


Func Pause()

	; Stop the playing
	_SendMCIMessage($hMCI, $MCIWND_STOP)

EndFunc   ;==>Pause


Func Stop()
	; Move it to the beggining
	_SendMCIMessage($hMCI, $MCI_PLAYFROM, 0, 0)
	; ...and stop it
	_SendMCIMessage($hMCI, $MCIWND_STOP)

	; Update labels
	GUICtrlSetData($hProgressPos, 0)
	GUICtrlSetData($hLabelPassed, "0.00 sec")
	GUICtrlSetData($hLabelLoadedWith, "Loaded with:")

EndFunc   ;==>Stop


Func SetProgress()

	; Get position
	Local $iGetPos = _SendMCIMessage($hMCI, $MCIWND_GETPOSITION)

	; Just for the fun
	If Mod(Int($iGetPos), 1000) < 200 And Not $iDone Then
		If $iBlued = 1 Then
			$iBlued = 0
			GUICtrlSetColor($hLabelDemo, 0xFE4010)
		EndIf
	Else
		If $iBlued = 0 Then
			$iBlued = 1
			GUICtrlSetColor($hLabelDemo, 0x0000CC)
		EndIf
	EndIf

	; Update progress control and labels every 200 ms of played
	If $iGetPos - $iCurPos > 200 Or $iGetPos = $iLength Then

		$iCurPos = $iGetPos
		Local $sPassed
		If $iGetPos < 60000 Then
			$sPassed = StringFormat('%.2f sec', $iGetPos / 1000)
		Else
			$sPassed = StringFormat('%d min %.2f sec', Floor($iGetPos / 60000), Mod($iGetPos / 1000, 60))
		EndIf
		If Not $iDone Then
			GUICtrlSetData($hLabelPassed, $sPassed)
			GUICtrlSetData($hProgressPos, $iGetPos / $iLength * 100)
		EndIf
		If $iGetPos = $iLength Then $iDone = 1
	EndIf

	; Set volume if there are changes made by user
	If $iVol <> 1000 - 10 * GUICtrlRead($hVol) Then
		$iVol = 1000 - 10 * GUICtrlRead($hVol)
		_SendMCIMessage($hMCI, $MCIWND_SETVOLUME, 0, $iVol)
		GUICtrlSetTip($hVol, $iVol / 10 & " %")
	EndIf

EndFunc   ;==>SetProgress


Func _MCIWndCreate($hWnd, $sFile, $iStyle = 0)

	; This is wery simple call. Description can be found at http://msdn.microsoft.com/en-us/library/dd757172(VS.85).aspx
	Local $aCall = DllCall($hMSVFW32, "hwnd:cdecl", "MCIWndCreateW", _
			"hwnd", $hWnd, _
			"ptr", 0, _
			"int", $iStyle, _
			"wstr", $sFile)

	If @error Or Not $aCall[0] Then
		Exit -1 ; In case of the failure either by MCIWndCreateW function or DllCall() function only logical would be to exit.
	EndIf

	Return $aCall[0]

EndFunc   ;==>_MCIWndCreate


Func LoadPlayer($sFile)

	; Close previous window
	_SendMCIMessage($hMCI, $WM_CLOSE)

	; Create new one
	$hMCI = _MCIWndCreate(0, $sFile, 0x00C4C018) ; WS_CAPTION|WS_SIZEBOX|MCIWNDF_NOMENU|MCIWNDF_NOERRORDLG|MCIWNDF_NOOPEN|MCIWNDF_SHOWNAME

	; Set time format to 'miliseconds' for convenience
	Local $tFormat = DllStructCreate("wchar[3]")
	DllStructSetData($tFormat, 1, "ms")
	_SendMCIMessage($hMCI, $MCI_SETTIMEFORMAT, 0, DllStructGetPtr($tFormat))

	; Adjust position of MCI window
	Local $aSize = WinGetClientSize($hMCI)
	Local $aPos = WinGetPos($hGUI)

	WinMove($hMCI, 0, $aPos[0] + 160, $aPos[1] + 137)
	If $aSize[0] And $aSize[1] > $iMinHight Then
		WinSetState($hMCI, 0, @SW_SHOW)
		WinSetTrans($hGUI, 0, 215) ; not to cover MCI window
	Else
		WinSetTrans($hGUI, 0, 255)
	EndIf

	; Check to see if loaded file can be played at all
	If _SendMCIMessage($hMCI, $MCIWND_CAN_PLAY) Then
		; Get length and update that label
		$iLength = _SendMCIMessage($hMCI, $MCIWND_GETLENGTH)
		_SendMCIMessage($hMCI, $MCIWND_SETVOLUME, 0, $iVol)
		GUICtrlSetData($hLabelLength, StringFormat('%d min %.2f sec total', Floor($iLength / 60000), Mod($iLength / 1000, 60)))
		; Few more things
		GUICtrlSetData($hLabelLoadedWith, "Loaded with:")
		Local $sFileName = StringRegExpReplace($sFile, ".*\\", "")
		GUICtrlSetData($hLabelName, $sFileName)
		GUICtrlSetTip($hLabelName, $sFileName)
		GUICtrlSetState($hButtonPlay, $GUI_ENABLE)
		GUICtrlSetState($hButtonPause, $GUI_ENABLE)
		GUICtrlSetState($hButtonStop, $GUI_ENABLE)
		GUICtrlSetData($hProgressPos, 0)
		GUICtrlSetData($hLabelPassed, "0.00 sec")
		GUICtrlSetData($hLabelLoadedWith, "Loaded with:")
	Else ; if not then notify and return error
		MsgBox(48, "Error", "Player cannot play this file", 0, $hGUI)
		GUICtrlSetData($hLabelLoadedWith, "")
		GUICtrlSetData($hLabelLength, "")
		GUICtrlSetData($hLabelName, "")
		GUICtrlSetTip($hLabelName, "")
		GUICtrlSetData($hProgressPos, 0)
		GUICtrlSetData($hLabelPassed, "0.00 sec")
		GUICtrlSetState($hButtonPlay, $GUI_DISABLE)
		GUICtrlSetState($hButtonPause, $GUI_DISABLE)
		GUICtrlSetState($hButtonStop, $GUI_DISABLE)
		Return SetError(1, 0, 0)
	EndIf

	Return 1 ; All OK!

EndFunc   ;==>LoadPlayer


Func _MCIGetMinHight($hMCI)

	Local $aSize = WinGetClientSize($hMCI)

	If @error Then Return 0

	Return $aSize[1]

EndFunc   ;==>_MCIGetMinHight


Func _SendMCIMessage($hWnd, $iMsg, $wParam = 0, $lParam = 0)

	; Call SendMessageW from user32.dll
	Local $aCall = DllCall($hUSER32, "lresult", "SendMessageW", _
			"hwnd", $hWnd, _
			"dword", $iMsg, _
			"wparam", $wParam, _
			"lparam", $lParam)

	If @error Then
		Return SetError(1, 0, 0)
	EndIf

	Return $aCall[0]

EndFunc   ;==>_SendMCIMessage
