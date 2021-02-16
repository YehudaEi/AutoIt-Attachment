#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <ButtonConstants.au3>
#include <VolumeMeter.au3>
$KeyList = "F1|F2|F3|F4|F5|F6|F7|F8|F9|F10|F11|F12|`|1|2|3|4|5|6|7|8|9|0|-|=|a|b|c|d|e|f|g|h|i|j|k|l|m|n|o|p|q|r|s|t|u|v|w|x|y|z|[|]|;|'|,|.|/|NUMPADDIV|NUMPADMULT|NUMPADSUB|NUMPADADD|NUMPADENTER|NUMPADDOT|NUMPAD0|NUMPAD1|NUMPAD2|NUMPAD3|NUMPAD4|NUMPAD5|NUMPAD6|NUMPAD7|NUMPAD8|NUMPAD9"

HotKeySet("!{v}", "VolumeControl") ; Hotkey: ALT+V for controlling the volume
HotKeySet("^{g}", "ShowGUI") ; Hotkey: CTRL+G for displaying GUI
HotKeySet("{ESC}", "CloseGUI")

Global $Gui, $s1, $Amount, $MuteButton, $Pos, $a, $status, $status2, $mute, $HotKeyGUIOpen, $HotKeyGUI, $HotkeyCheckBox, $WinModifierKey, $ControlModifierKey, $AltModifierKey, $ShiftModifierKey, $Modifier, $iTunesPlaynPauseHotkeyList, $iTunesNextHotkeyList, $iTunesPreviousHotkeyList,$iTunesPlaynPauseHotKey, $iTunesNextHotkey, $iTunesPreviousHotkey, $iTunesWinModifierKey, $iTunesControlModifierKey, $iTunesAltModifierKey, $iTunesShiftModifierKey ; State variables

TrayTip("Hotkey Information", "To open the hotkey selection, click the checkbox in the bottom right-hand corner.", 1, 1) ; Display tooltip

Opt("GUIOnEventMode", 1) ; Set to OnEventMode

$iTunesVolumePercent = 10 ; Set volume percent for iTunes to increase/decrease accordingly

While 1 ; Begin Idle
    Sleep(1000) ; Idle
WEnd ; End Idle

Func ShowGUI() ; Begin GUI display
	$status2 +=1
	If $status2 < 2 Then
	GuiDelete($Gui) ; Delete existing GUI's
	$pos = MouseGetPos() ; Get current mouse position for placement of GUI
	$gui = GUICreate("Volume Control", 120, 90,$Pos[0]-55,$Pos[1]-60,BitOR($WS_POPUP,$WS_BORDER)) ; Create GUI
	GUISetOnEvent($GUI_EVENT_CLOSE, "CloseGUI")
	$MuteButton = GuiCtrlCreateButton("Mute", 20, 5, 80, 100, $BS_BITMAP) ; Create mute image/button
	GUICtrlSetImage($MuteButton, "UnMuted.bmp", 1) ; Set current mute status to un-muted
	GUICtrlSetOnEvent($MuteButton, "Mute") ; Create action for mute button
	$HotkeyCheckBox = GUICtrlCreateCheckbox("HotKey CheckBox", 100, 70, -1, -1) ; Create hotkey check box
	GUICtrlSetOnEvent($HotkeyCheckBox, "Hotkeys") ; Create action for hotkey check box
	GUISetBkColor(0x000000) ; Set GUI background to black
	WinSetTrans($gui,"",60) ; Set transparency for GUI
	GUISetState() ; Display GUI
	$a = _CreateLevelMeter(0,0,False,20,5,30,0xFFFFFF,0x0000FF) ; Create volume meter
EndIf
	If $status2 >= 2 Then
		GuiSetState(@SW_HIDE, $Gui)
		$status2 = 0
	EndIf
EndFunc ; End GUI Display

Func Mute() ; Begin mute function
		If $Mute = 1 Then ; Detect if volume is muted, if it is, unmute.
		GUICtrlSetImage($MuteButton, "UnMuted.bmp", 1) ; Display un-muted volume image
		$Mute = 0 ; Set mute to 0
	ElseIf $Mute = 0 Then ; Detect if volume is muted, if it isn't, mute.
		GUICtrlSetImage($MuteButton, "MuteImage.bmp", 1) ; Display muted volume image
		$Mute = 1 ; Set mute to 1
	EndIf ; End mute detection
	Send("{VOLUME_MUTE}") ; Toggle mute/un-mute
EndFunc ; End mute function

Func VolumeControl() ; Begin volume control
	If $status >= 2 Then ; Detect if volume control has been enabled.
		$status = 0 ; If it has, reset it to allow for stop/go
		EndIf ; End If
	$status += 1 ; Set status to 1 to ackknowledge volume control is being used
While $Status < 2 ; Begin volume meter tracking
		$WatchMousePos = MouseGetPos() ; Get current mouse pos to compare to previous mouse pos.
		If $Amount < 3 Then ; Detect if meter is at its lowest point to assure it doesn't exceed its array
			$Amount += 1.6 ; If it is at lowest, keep at a functionable level
		EndIf ; End If for lowest point
		If $Amount > 98 Then ; Detect if meter is at its highest point to assure it doesn't exceed its array 
			$Amount -= 2.5 ; If it is at highest, keep at a functionable level
			EndIf ; End If for highest point
	If $WatchMousePos[1] > $Pos[1] Then ; Detect movement for controlling volume down
		$Pos[1] = $WatchMousePos[1] ; Set WatchMousePos[1] to pre-existing y for next movement detection
		$Amount -= 1.4 ; Lower the amount in order to display correct meter adjustments
		$s1=$Amount ; Adjust meter
		_ShowLevelMeter($s1,$a) ; Display meter
		Send("{VOLUME_DOWN}") ; Lower volume accordingly
	EndIf ; End If for mouse down movemenet
	If $WatchMousePos[1] < $Pos[1] Then ; Detect movement for controlling volume up
		$Pos[1] = $WatchMousePos[1] ; Set WatchMousePos[1] to pre-existing y for next movement detection
		$Amount += 1.8 ; Raise the amount in order to display correct meter adjustments
		$s1=$Amount ; Adjust meter
		_ShowLevelMeter($s1,$a) ; Display meter
		Send("{VOLUME_UP}") ; Raise volume accordingly
	EndIf ; End If for mouse up movemenet
WEnd ; End while for active volume control
EndFunc ; End VolumeControl function

Func HotKeys()
	$iTunesApp = ObjCreate("iTunes.Application")
	GUICtrlSetState ($HotkeyCheckBox, $GUI_UNCHECKED)
	$HotKeyGUIOpen = 1
	$HotKeyGUI = GUICreate("Hotkeys", 200, 230,$Pos[0]-55,$Pos[1]-60,BitOR($WS_POPUP,$WS_BORDER))
	$CreateTab = GUICtrlCreateTab(10, 10, 180, 210)
	$iTunesTab = GUICtrlCreateTabItem("iTunes")
	GuiCtrlCreateLabel("Modifier keys:", 60, 34)
	$iTunesWinModifierKey = GUICtrlCreateCheckbox("Win", 15, 48, -1, -1)
	$iTunesControlModifierKey = GUICtrlCreateCheckbox("Ctrl", 58, 48, -1, -1)
	$iTunesAltModifierKey = GUICtrlCreateCheckbox("Alt", 100, 48, -1, -1)
	$iTunesShiftModifierKey = GUICtrlCreateCheckbox("Shift", 140, 48, -1, -1)
	$iTunesPlaynPauseHotkeyList = GUICtrlCreateCombo("Play/Pause HotKey", 18, 78, 160,10)
	GUICtrlSetData(-1, $KeyList) 
	$iTunesNextHotkeyList = GUICtrlCreateCombo("Next Song HotKey", 18, 105, 160,10)
	GUICtrlSetData(-1, $KeyList) 
	$iTunesPreviousHotkeyList = GUICtrlCreateCombo("Previous Song HotKey", 18, 133, 160,10)
	GUICtrlSetData(-1, $KeyList)
	$AcceptiTunesHotKeysButton = GuiCtrlCreateButton("Submit", 75,160)
	GUICtrlSetOnEvent($AcceptiTunesHotKeysButton, "SubmitiTunesHotKeyInfo")
	GuiSetState()
EndFunc

Func SubmitiTunesHotKeyInfo()
	HotKeySet($Modifier & $iTunesPlaynPauseHotKey)
	HotKeySet($Modifier & $iTunesNextHotkey)
	HotKeySet($Modifier & $iTunesPreviousHotkey)
	$Modifier = ""
	$iTunesWinModifier = GUICtrlRead($iTunesWinModifierKey)
	If $iTunesWinModifier = $GUI_UNCHECKED Then
		Sleep(10)
	ElseIf $iTunesWinModifier = $GUI_CHECKED Then
		$Modifier = "#"
		EndIf
	$iTunesControlModifier = GUICtrlRead($iTunesControlModifierKey)
	If $iTunesControlModifier = $GUI_UNCHECKED Then
		Sleep(10)
	ElseIf $iTunesControlModifier = $GUI_CHECKED Then
		$Modifier = "^"
		EndIf
	$iTunesAltModifier = GUICtrlRead($iTunesAltModifierKey)
	If $iTunesAltModifier = $GUI_UNCHECKED Then
		Sleep(10)
	ElseIf $iTunesAltModifier = $GUI_CHECKED Then
		$Modifier = "!"
	EndIf
	$iTunesShiftModifier = GUICtrlRead($iTunesShiftModifierKey)
	If $iTunesShiftModifier = $GUI_UNCHECKED Then
		Sleep(10)
	ElseIf $iTunesShiftModifier = $GUI_CHECKED Then
		$Modifier = "+"
		EndIf
	$iTunesPlaynPauseHotKey = GUICtrlRead($iTunesPlaynPauseHotkeyList)
	$iTunesNextHotkey = GUICtrlRead($iTunesNextHotkeyList)
	$iTunesPreviousHotkey = GUICtrlRead($iTunesPreviousHotkeyList)
	$iTunesPlaynPauseHotKey = "{" & $iTunesPlaynPauseHotKey & "}"
	$iTunesNextHotkey = "{" & $iTunesNextHotkey & "}"
	$iTunesPreviousHotkey = "{" & $iTunesPreviousHotkey & "}"
	HotKeySet($Modifier & $iTunesPlaynPauseHotKey, "iTunesPlaynPause")
	HotKeySet($Modifier & $iTunesNextHotkey, "iTunesNext")
	HotKeySet($Modifier & $iTunesPreviousHotkey, "iTunesPrevious")
	MsgBox(0, "Test", "iTunes Hotkeys submitted..")
	MsgBox(0, "Test", $Modifier & $iTunesPlaynPauseHotKey)
	GuiDelete($HotKeyGUI)
	GuiCtrlSetState($iTunesWinModifier, $GUI_UNCHECKED)
	GuiCtrlSetState($iTunesControlModifier, $GUI_UNCHECKED)
	GuiCtrlSetState($iTunesAltModifier, $GUI_UNCHECKED)
	GuiCtrlSetState($iTunesShiftModifier, $GUI_UNCHECKED)
EndFunc

Func iTunesPlaynPause()
	$iTunesApp.PlayPause
EndFunc

Func iTunesNext()
	$iTunesApp.NextTrack
EndFunc

Func iTunesPrevious()
	$iTunesApp.PreviousTrack
EndFunc

Func CloseGUI()
	  If $HotKeyGUIOpen = 0 Then
    Exit
	EndIf
If $HotKeyGUIOpen = 1 Then
	$HotKeyGUIOpen = 0
	GuiDelete($HotKeyGUI)
  EndIf 
EndFunc