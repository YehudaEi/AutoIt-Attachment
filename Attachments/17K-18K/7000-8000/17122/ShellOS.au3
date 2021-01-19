#include <GUIConstants.au3>
#include <Misc.au3>
#include <Date.au3>

Opt("RunErrorsFatal", 0)
Opt("GUICloseOnESC", 0)
Global $List1, $Close, $Open, $Start, $Form1, $startmenu
Global $DoubleClicked = False
Global Const $WM_NOTIFY = 0x004E
Global $StartMenuShow = False
Global $DateMenuShow = False
Global $SystemSettings = False

$BackColor = IniRead(@ScriptDir & "\Settings.ini", "Settings", "BackColor", "0xC0C0C0") ; Reads the users Background Color from the settings ini file
WinSetState("[CLASS:Shell_TrayWnd]", "", @SW_HIDE)
#Region ### START Koda GUI section ### Form=
$Form1 = GUICreate("OS shell", 633, 430, 193, 115, BitOR($WS_POPUP, $WS_CLIPSIBLINGS))
$ContMenu = GUICtrlCreateContextMenu()
$ChangeColor = GUICtrlCreateMenuItem("Change Background Color", $ContMenu)
GUIRegisterMsg($WM_NOTIFY, "WM_NOTIFY")
GUISetBkColor($BackColor) ; Sets the color read from the ini
$Start = GUICtrlCreateButton("Start", 3, 409, 75, 17, 0)
$Open = GUICtrlCreateButton("Open", 3, 409, 75, 17, 0)
GUICtrlSetState(-1, $GUI_HIDE)
$startmenu = GUICtrlCreateListView("Applications                  ", 0, 310, 85, 97, $LVS_NOSORTHEADER)
GUICtrlSetState(-1, $GUI_HIDE)
GUICtrlCreateListViewItem("Paint", $startmenu)
GUICtrlSetImage(-1, "shell32.dll", -35)
GUICtrlCreateListViewItem("Notepad", $startmenu)
GUICtrlSetImage(-1, "shell32.dll", -71)
GUICtrlCreateListViewItem("System", $startmenu)
GUICtrlSetImage(-1, "shell32.dll", -166)
GUICtrlCreateListViewItem("Shutdown", $startmenu)
GUICtrlSetImage(-1, "shell32.dll", -113)
$date = GUICtrlCreateMonthCal("", 432, 246, 191, 161)
GUICtrlSetState(-1, $GUI_HIDE)
$Time = GUICtrlCreateButton(_NowTime(), 544, 409, 75, 17, 0)
$Paint = GUICtrlCreateButton("Paint", 8, 8, 59, 49, BitOR($BS_PUSHBOX, $BS_FLAT, $BS_ICON))
GUICtrlSetImage(-1, "shell32.dll", -35)
$Notepad = GUICtrlCreateButton("Notepad", 8, 80, 59, 49, BitOR($BS_PUSHBOX, $BS_FLAT, $BS_ICON))
GUICtrlSetImage(-1, "shell32.dll", -71)
$SystemSettings = GUICtrlCreateListView("System                          ", 0, 310, 85, 97, $LVS_NOSORTHEADER)
GUICtrlSetState(-1, $GUI_HIDE)
GUICtrlCreateListViewItem("Background Color", $SystemSettings)
GUICtrlSetImage(-1, "shell32.dll", -166)
$GenSettings = GUICtrlCreateListViewItem("General Settings", $SystemSettings)
GUICtrlSetImage(-1, "shell32.dll", -166)
$startbar = GUICtrlCreatePic(@ScriptDir & "\OSstartbar.bmp", 0, 394, 2000, 35, BitOR($SS_NOTIFY, $WS_GROUP, $WS_CLIPSIBLINGS))

GUISetState()
GUISetState(@SW_MAXIMIZE)

#EndRegion ### END Koda GUI section ###

AdlibEnable("refresh_time", 1000)

While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			WinSetState("[CLASS:Shell_TrayWnd]", "", @SW_SHOW)
			Exit
		Case $Start
			Startmenu()
		Case $Time
			If Not $DateMenuShow Then
				GUICtrlSetState($date, $GUI_SHOW)
				$DateMenuShow = True
			Else
				GUICtrlSetState($date, $GUI_HIDE)
				$DateMenuShow = False
			EndIf
		Case $Paint
			GUICtrlDelete($Paint)
			$Paint = GUICtrlCreateButton("Paint", 8, 8, 59, 49, BitOR($BS_PUSHBOX, $BS_FLAT, $BS_ICON))
			GUICtrlSetImage(-1, "shell32.dll", -35)
			Run("MSpaint")
		Case $Notepad
			GUICtrlDelete($Notepad)
			$Notepad = GUICtrlCreateButton("Notepad", 8, 64, 59, 49, BitOR($BS_PUSHBOX, $BS_FLAT, $BS_ICON))
			GUICtrlSetImage(-1, "shell32.dll", -71)
			Run("notepad")
		Case $ChangeColor
			_ChangeColor()
		Case $GenSettings
			_Settings()
	EndSwitch
	If $DoubleClicked Then
		DoubleClickFunc()
		$DoubleClicked = False
	EndIf
WEnd

Func Startmenu()
	If Not $StartMenuShow Then
		GUICtrlSetState($SystemSettings, $GUI_HIDE)
		GUICtrlSetState($startmenu, $GUI_SHOW)
		$StartMenuShow = True
	Else
		GUICtrlSetState($SystemSettings, $GUI_HIDE)
		GUICtrlSetState($startmenu, $GUI_HIDE)
		$StartMenuShow = False
	EndIf
EndFunc   ;==>Startmenu

Func refresh_time()
	GUICtrlSetData($Time, _NowTime())
EndFunc   ;==>refresh_time

Func WM_NOTIFY($hWnd, $MsgID, $wParam, $lParam)
	Local $tagNMHDR, $event, $hwndFrom, $code
	$tagNMHDR = DllStructCreate("int;int;int", $lParam)
	If @error Then Return 0
	$code = DllStructGetData($tagNMHDR, 3)
	If $wParam = $startmenu And $code = -3 Then $DoubleClicked = True
	Return $GUI_RUNDEFMSG
EndFunc   ;==>WM_NOTIFY

Func DoubleClickFunc()
	$App = GUICtrlRead(GUICtrlRead($startmenu))
	Switch $App
		Case "Notepad"
			Run("notepad")
		Case "Paint"
			Run("mspaint")
		Case "Shutdown"
			$GetState = IniRead(@ScriptDir & "\Settings.ini", "System", "ConfShudown", "0") ; Reads the settings saved previously/default
			If $GetState = 1 Then ; reads whether it should confirm the shutdown
				If Not IsDeclared("iMsgBoxAnswer") Then Local $iMsgBoxAnswer
				$iMsgBoxAnswer = MsgBox(36, "OS Shell", "Are you sure you would like to shutdown?")
				Select
					Case $iMsgBoxAnswer = 6 ;Yes
						WinSetState("[CLASS:Shell_TrayWnd]", "", @SW_SHOW)
						Exit
					Case $iMsgBoxAnswer = 7 ;No
				EndSelect
			Else
				WinSetState("[CLASS:Shell_TrayWnd]", "", @SW_SHOW)
				Exit
			EndIf
		Case "System"
			GUICtrlSetState($startmenu, $GUI_HIDE)
			GUICtrlSetState($SystemSettings, $GUI_SHOW)
		Case "Background Color"
			_ChangeColor()
		Case "General Settings"
			_Settings()
	EndSwitch
EndFunc   ;==>DoubleClickFunc

Func _ChangeColor()
	$bkColor = _ChooseColor(2)
	If Not @error Then
		GUISetBkColor($bkColor)
	EndIf
	IniWrite(@ScriptDir & "\Settings.ini", "Settings", "BackColor", $bkColor) ; Saves the color
EndFunc   ;==>_ChangeColor

Func _Settings()
	$ConfSettings = IniRead(@ScriptDir & "\Settings.ini", "System", "ConfShudown", "0") ; Reads the previously saved settings
	$Settings = GUICreate("General Settigs", 320, 69)
	$ConfirmShutdown = GUICtrlCreateCheckbox("Confirm on shutdown?", 16, 16, 281, 17)
	If $ConfSettings = 1 Then ; Checks the saved settings 
		GUICtrlSetState($ConfirmShutdown, $GUI_CHECKED) ; Sets the check box to checked if it = 1
	Else
		GUICtrlSetState($ConfirmShutdown, $GUI_UNCHECKED) ;  Sets the check box to unchecked if it = 0
	EndIf
	$Save = GUICtrlCreateButton("Save", 160, 40)
	GUISetState(@SW_SHOW)

	While 2
		$msg2 = GUIGetMsg()
		Select
			Case $msg2 = $GUI_EVENT_CLOSE
				ExitLoop
			Case $msg2 = $Save
				If GUICtrlRead($ConfirmShutdown) = 1 Then
					IniWrite(@ScriptDir & "\Settings.ini", "System", "ConfShudown", "1") ; Saves if the users wants a confirmation on shutdown
				Else
					IniWrite(@ScriptDir & "\Settings.ini", "System", "ConfShudown", "0") ; Saves if the users wants a confirmation on shutdown
				EndIf
				MsgBox(0, "OS Shell", "Saved Settings!")
		EndSelect
	WEnd
	GUIDelete($Settings)
EndFunc   ;==>_Settings