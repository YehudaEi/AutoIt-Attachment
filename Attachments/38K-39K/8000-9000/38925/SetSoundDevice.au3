#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=ssd_logo.ico
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#include <Winapi.au3>
#include <GuiListBox.au3>
#include <GuiListView.au3>
#include <WindowsConstants.au3>
#include <Misc.au3>

Global $hWnd_Sound, $iPID_Sound, $timer_timeout

$sDefaultDevice = ""
$sSpeakerConfig = ""

If $CmdLine[0] > 1 Then
	$sDefaultDevice = $CmdLine[1]
	$sSpeakerConfig = $CmdLine[2]
Else
	;No command line parameters
	_Exit()
EndIf

;No valid parameters were passed
If StringLen($sDefaultDevice) = 0 Or StringLen($sSpeakerConfig) = 0 Then _Exit()

;Only one instance allowed
If _Singleton("SetSoundDevice", 1) = 0 Then
    MsgBox(0, "Warning", "An occurence of the script is already running")
    Exit
EndIf

;Open Sound control panel applet
$iPID_Sound = Run("rundll32.exe shell32.dll,Control_RunDLL mmsys.cpl,,0", @SystemDir)

$timer_timeout = TimerInit()
While Not IsHWnd($hWnd_Sound)
	$hWnd_Sound = _Detect_Sound_dialog_hWnd($iPID_Sound)
	If TimerDiff($timer_timeout) > 10000 Or Not ProcessExists($iPID_Sound) Then ;modified to 10 second timeout
		_Exit()
	EndIf
WEnd

;Set listview selection
If Set_SysListView32_Selection($sDefaultDevice) Then
	;success
	If WinExists($hWnd_Sound) Then ControlClick($hWnd_Sound, "", "Button2")
	Sleep(200)
Else
	;failure
	MsgBox(0, "", 'Unable to properly select the Default device, error#:' & @error)
	;check @error value for details
	_Exit_Error()
EndIf

;Configure the speakers
;Start the speaker setup wizard, click the 'Configure' button
If Set_SysListView32_Selection("Speakers") Then
	;success
	If WinExists($hWnd_Sound) Then ControlClick($hWnd_Sound, "", "Button1")
	Sleep(300)
Else
	;failure
	MsgBox(0, "", 'Unable to properly select the "Speakers" device, error#:' & @error)
	;check @error value for details
	_Exit_Error()
EndIf

$hWnd_SpeakerConfig = WinGetHandle("Speaker Setup")
If @error Then _Exit_Error()

;Configure audio channels
If Set_Speaker_Config($hWnd_SpeakerConfig, $sSpeakerConfig) Then
	;success
	Sleep(200)
	If WinExists($hWnd_SpeakerConfig) Then
		While 1
			If ControlCommand($hWnd_SpeakerConfig, "", "Button2", "IsVisible", "") Then
				ControlClick($hWnd_SpeakerConfig, "", "Button2")
				ExitLoop
			Else
				ControlClick($hWnd_SpeakerConfig, "", "Button1")
			EndIf
			Sleep(200)
		WEnd
	EndIf
	Sleep(500)
Else
	;failure
	MsgBox(0, "", "Unable to properly select the audio channels, error#:" & @error)
	;check @error value for details
EndIf

;Click OK to close Sound applet
If WinExists($hWnd_Sound) Then ControlClick($hWnd_Sound, "", "Button4")

Exit


Func Set_Speaker_Config($hWnd, $sAudioChannels)
	Local $iItemCount = 0, $aWindows, $hWnd_ListBox, $sText = ""

	;Enumerate the main listview
	$aWindows = _WinAPI_EnumWindows(1, $hWnd)
	If @error Then Return SetError(1)
	For $x = 1 To $aWindows[0][0]
		If $aWindows[$x][1] = "ListBox" Then
			$hWnd_ListBox = $aWindows[$x][0]
			ExitLoop
		EndIf
	Next
	If Not IsHWnd($hWnd_ListBox) Then Return SetError(2)

	;Get count of listview items
	$iItemCount = _GUICtrlListBox_GetCount($hWnd_ListBox)
	If Not $iItemCount > 0 Then Return SetError(3)

	;Loop through items, set selection, set as default device
	For $x = 0 To $iItemCount-1
		$sText = ""
		$sText = _GUICtrlListBox_GetText($hWnd_ListBox, $x)
		If $sText = $sAudioChannels Then
;~ 			If _GUICtrlListBox_SetCurSel($hWnd_ListBox, $x) Then ;not working
			If _GUICtrlListBox_ClickItem($hWnd_ListBox, $x) Then
				;success
				Return 1
			Else
				;failure
				Return SetError(@error)
			EndIf
		EndIf
	Next
EndFunc

Func Set_SysListView32_Selection($sSelection_Text)
	Local $iItemCount = 0, $aWindows, $hWnd_ListView, $sText = ""

	;Enumerate the main listview
	$aWindows = _WinAPI_EnumWindows(1, $hWnd_Sound)
	If @error Then Return SetError(1)
	For $x = 1 To $aWindows[0][0]
		If $aWindows[$x][1] = "SysListView32" Then
			$hWnd_ListView = $aWindows[$x][0]
			ExitLoop
		EndIf
	Next
	If Not IsHWnd($hWnd_ListView) Then Return SetError(2)

	;Get count of listview items
	$iItemCount = _GUICtrlListView_GetItemCount($hWnd_ListView)
	If Not $iItemCount > 0 Then Return SetError(3)

	;Loop through items, set selection, set as default device
	For $x = 0 To $iItemCount-1
		$sText = ""
		$sText = _GUICtrlListView_GetItemText($hWnd_ListView, $x)
		If $sText = $sSelection_Text Then
			If _GUICtrlListView_SetItemSelected($hWnd_ListView, $x) Then
				;success
				Return 1
			Else
				;failure
				Return SetError(@error)
			EndIf
		EndIf
	Next
EndFunc

Func _Exit()
	$timer_timeout = TimerInit()
	While ProcessExists($iPID_Sound)
		ProcessClose($iPID_Sound)
		If TimerDiff($timer_timeout) > 5000 Then
			_Exit_Error()
		EndIf
		Sleep(250)
	WEnd
	Exit
EndFunc   ;==>_Exit

Func _Exit_Error()
	If Not ProcessExists($iPID_Sound) Then
		If ProcessExists("rundll32.exe") Then $iPID_Sound = ProcessExists("rundll32.exe")
	EndIf
	If ProcessExists($iPID_Sound) Then MsgBox(16 + 262144, "Error", "The process rundll32.exe with the PID " & $iPID_Sound & "could not be closed by SSD." & @CRLF & @CRLF & "SSD will exit now, close the process via Taskmanager.")
	Exit
EndFunc   ;==>_Exit_Error

Func _Detect_Sound_dialog_hWnd($iPID)
	Local $hWnds = WinList("[CLASS:#32770;]", "")
	For $i = 1 To $hWnds[0][0]
		If BitAND(WinGetState($hWnds[$i][1], ''), 2) Then
			If WinGetProcess(_WinAPI_GetAncestor($hWnds[$i][1], $GA_ROOTOWNER)) = ProcessExists($iPID) Then
				Return $hWnds[$i][1]
			EndIf
		EndIf
	Next
	Return 0
EndFunc   ;==>_Detect_Sound_dialog_hWnd