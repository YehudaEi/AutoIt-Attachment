#include <Constants.au3>
#include <SendMessage.au3>
#include <WinAPI.au3>
#include <EditConstants.au3>
#include <ButtonConstants.au3>
#include <StaticConstants.au3>
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include <GuiButton.au3>
#include <GuiImageList.au3>

Global Const $Slide_Left = 0x00040002
Global Const $Slide_Right = 0x00040001
Global Const $Anim_Hide = 0x00010000
Global Const $Ini = @ScriptDir & "\Settings.ini"

If Not FileExists($Ini) Then WriteIni()

Global $LabelNames = IniReadSection($Ini, "Labels")
Global $LaunchNames = IniReadSection($Ini, "Launch")
Global $ConfigMode = False
Global $Hide_State = False
Global $Side = "Left"
Dim $Labels[8]
Dim $Buttons[8]
Dim $Configure[8]

Opt("TrayMenuMode", 1)
Opt("TrayOnEventMode", 1)

$Tray_Exit = TrayCreateItem("Exit")
TrayItemSetOnEvent($Tray_Exit, "_Exit")

$ShowGUI = GUICreate("", 28, 83, 0, -1, -1, BitOR($WS_EX_TOPMOST, $WS_EX_TOOLWINDOW))
$Show = GUICtrlCreateButton(">", 6, 8, 16, 68, $BS_CENTER)
GUISetState(@SW_HIDE)

$Toolbar = GUICreate("Sliding Launcher", 601, 83, 0, -1, -1, BitOR($WS_EX_TOPMOST, $WS_EX_TOOLWINDOW, $WS_EX_ACCEPTFILES))

;create labels and inputs
$Left = 24
For $x = 1 To 7
	$Labels[$x] = GUICtrlCreateLabel($LabelNames[$x][1], $Left, 8, 72, 17, BitOR($SS_CENTER, $SS_SUNKEN))
	$Buttons[$x] = GUICtrlCreateButton("", $Left, 35, 72, 41, BitOR($BS_CENTER, $BS_ICON))

	;set button icons
	If $LaunchNames[$x][1] <> "" Then
		$Reg = StringRegExp($LaunchNames[$x][1], "(?<Protocol>\w+):\/\/(?<Domain>[\w@][\w.:@]+)\/?[\w\.?=%&=\-@/$,]*", 3)
		If (IsArray($Reg) And UBound($Reg) = 2 And ($Reg[0] = "http" Or $Reg[0] = "https")) Or StringLeft($LaunchNames[$x][1], 4) = "www." Then
			$defaultBrowser = RegRead("HKEY_CLASSES_ROOT\http\shell\open\command", "")
			$defaultBrowser = StringTrimLeft($defaultBrowser, 1)
			$defaultBrowser = StringMid($defaultBrowser, 1, StringInStr($defaultBrowser, '"') - 1)
			$Reg = _GetRegDefIcon($defaultBrowser)
			_SetIcon($Buttons[$x], $Reg[0], $Reg[1], 35, 35)
		ElseIf StringRight($LaunchNames[$x][1], 4) = ".lnk" Then
			$Short = FileGetShortcut($LaunchNames[$x][1])
			$Reg = _GetRegDefIcon($Short[0])
			_SetIcon($Buttons[$x], $Reg[0], $Reg[1], 35, 35)
		Else
			$Reg = _GetRegDefIcon($LaunchNames[$x][1])
			_SetIcon($Buttons[$x], $Reg[0], $Reg[1], 35, 35)
		EndIf
	Else
		GUICtrlSetImage($Buttons[$x], "shell32.dll", -50)
	EndIf

	GUICtrlSetTip(-1, $LaunchNames[$x][1])
	$Left += 80
Next
$Hide = GUICtrlCreateButton("<", 581, 8, 16, 68)

$Config = GUICtrlCreateButton("[]", 4, 8, 16, 68)
GUICtrlSetTip($Hide, "Hide Toolbar")
GUICtrlSetTip($Config, "Configure Toolbar")


;create configuration controls
$Configure[1] = GUICtrlCreateLabel("Label Name :", 20, 15, 84, 20)
GUICtrlSetFont(-1, 10, 400, 0, "MS Sans Serif")
$Configure[2] = GUICtrlCreateInput("", 106, 14, 73, 21, $ES_LEFT)
$Configure[3] = GUICtrlCreateLabel("Program to Launch :", 189, 15, 122, 20)
GUICtrlSetFont(-1, 10, 400, 0, "MS Sans Serif")
$Configure[4] = GUICtrlCreateInput("", 311, 14, 185, 21)
GUICtrlSetState(-1, $GUI_DROPACCEPTED)
$Configure[5] = GUICtrlCreateButton("Browse", 506, 13, 75, 23)
$Configure[6] = GUICtrlCreateButton("Cancel", 359, 48, 125, 23)
$Configure[7] = GUICtrlCreateButton("OK", 117, 48, 125, 23)
For $i = 1 To 7
	GUICtrlSetState($Configure[$i], $GUI_HIDE)
Next


GUISetState()
GUIRegisterMsg($WM_WINDOWPOSCHANGED, "Snap_To_Edges")

While 1
	$Msg = GUIGetMsg()
	Switch $Msg
		Case $GUI_EVENT_CLOSE
			Exit
		Case $Show
			Slide()
		Case $Hide
			If $ConfigMode Then
				WinSetTitle($Toolbar, "", "Sliding Toolbar")
				GUICtrlSetTip($Hide, "Hide Toolbar")
				$ConfigMode = False
			Else
				Slide()
			EndIf
		Case $Config
			$ConfigMode = True
			GUICtrlSetTip($Hide, "Cancel")
			Switch $Side
				Case "Left"
					WinSetTitle($Toolbar, "", "Config Mode - Please Press the Button to Configure...  Press  " & '"<"' & "  to Cancel")
				Case Else
					WinSetTitle($Toolbar, "", "Config Mode - Please Press the Button to Configure...  Press  " & '">"' & "  to Cancel")
			EndSwitch
	EndSwitch
	If Not $Hide_State Then ;from Valuater's XSkin UDF: MouseOver Function
		$MPos = GUIGetCursorInfo($Toolbar)
		If IsArray($MPos) Then
			For $i = 1 To 7
				If $MPos[4] = $Buttons[$i] Then
					$Left = 20 + (($i - 1) * 80)
					GUICtrlSetPos($Buttons[$i], $Left, 31, 80, 45)
					GUICtrlSetCursor($Buttons[$i], 0)
					GUICtrlSetColor($Labels[$i], 0xff0000)
					While IsArray($MPos) And $MPos[4] = $Buttons[$i]
						$MPos = GUIGetCursorInfo($Toolbar)
						If $MPos[2] Then
							While $MPos[2]
								$MPos = GUIGetCursorInfo($Toolbar)
								Sleep(50)
							WEnd
							If Not $ConfigMode Then
								ButtonFunctions($i)
							Else
								Settings($i)
							EndIf
						EndIf
					WEnd
					GUICtrlSetPos($Buttons[$i], $Left + 4, 35, 72, 41)
					GUICtrlSetColor($Labels[$i], 0x000000)
				EndIf
			Next
		EndIf
	EndIf
	Sleep(25)
WEnd

Func ConfigState($sState)
	Switch $sState
		Case "Show"
			For $i = 1 To 7
				GUICtrlSetState($Buttons[$i], $GUI_HIDE)
				GUICtrlSetState($Labels[$i], $GUI_HIDE)
			Next
			GUICtrlSetState($Config, $GUI_HIDE)
			GUICtrlSetState($Hide, $GUI_HIDE)

			For $i = 1 To 7
				GUICtrlSetState($Configure[$i], $GUI_SHOW)
			Next
		Case Else
			For $i = 1 To 7
				GUICtrlSetState($Buttons[$i], $GUI_SHOW)
				GUICtrlSetState($Labels[$i], $GUI_SHOW)
			Next
			GUICtrlSetState($Config, $GUI_SHOW)
			GUICtrlSetState($Hide, $GUI_SHOW)

			For $i = 1 To 7
				GUICtrlSetState($Configure[$i], $GUI_HIDE)
			Next
	EndSwitch
EndFunc   ;==>ConfigState

Func Settings(ByRef $iNumber)
	GUICtrlSetPos($Buttons[$iNumber], $Left + 4, 35, 68, 41)
	GUICtrlSetColor($Labels[$iNumber], 0x000000)
	Slide()
	ConfigState("Show")
	GUICtrlSetData($Configure[2], $LabelNames[$iNumber][1])
	GUICtrlSetData($Configure[4], $LaunchNames[$iNumber][1])
	Slide()

	While 1
		$Msg = GUIGetMsg()
		Switch $Msg
			Case $GUI_EVENT_CLOSE
				ExitLoop
			Case $Configure[6] ;cancel button
				ExitLoop
			Case $Configure[7] ;OK button
				IniWrite($Ini, "Labels", $iNumber, GUICtrlRead($Configure[2]))
				IniWrite($Ini, "Launch", $iNumber, GUICtrlRead($Configure[4]))
				ExitLoop
			Case $Configure[5] ;Browse button
				$File = FileOpenDialog("Select File...", @DesktopDir, "ALL (*.*)", 3, "", $Toolbar)
				If Not @error Then GUICtrlSetData($Configure[4], $File)
		EndSwitch
	WEnd
	Slide()
	$LabelNames = IniReadSection($Ini, "Labels")
	$LaunchNames = IniReadSection($Ini, "Launch")
	For $x = 1 To 7
		If $LaunchNames[$x][1] <> "" Then
			$Reg = StringRegExp($LaunchNames[$x][1], "(?<Protocol>\w+):\/\/(?<Domain>[\w@][\w.:@]+)\/?[\w\.?=%&=\-@/$,]*", 3)
			If (IsArray($Reg) And UBound($Reg) = 2 And ($Reg[0] = "http" Or $Reg[0] = "https")) Or StringLeft($LaunchNames[$x][1], 4) = "www." Then
				$defaultBrowser = RegRead("HKEY_CLASSES_ROOT\http\shell\open\command", "")
				$defaultBrowser = StringTrimLeft($defaultBrowser, 1)
				$defaultBrowser = StringMid($defaultBrowser, 1, StringInStr($defaultBrowser, '"') - 1)
				$Reg = _GetRegDefIcon($defaultBrowser)
				_SetIcon($Buttons[$x], $Reg[0], $Reg[1], 35, 35)
			ElseIf StringRight($LaunchNames[$x][1], 4) = ".lnk" Then
				$Short = FileGetShortcut($LaunchNames[$x][1])
				$Reg = _GetRegDefIcon($Short[0])
				_SetIcon($Buttons[$x], $Reg[0], $Reg[1], 35, 35)
			Else
				$Reg = _GetRegDefIcon($LaunchNames[$x][1])
				_SetIcon($Buttons[$x], $Reg[0], $Reg[1], 35, 35)
			EndIf
		Else
			GUICtrlSetImage($Buttons[$x], "shell32.dll", -50)
		EndIf

		GUICtrlSetData($Labels[$x], $LabelNames[$x][1])
		GUICtrlSetTip($Buttons[$x], $LaunchNames[$x][1])
	Next
	WinSetTitle($Toolbar, "", "Sliding Toolbar")
	ConfigState("Hide")
	$ConfigMode = False
	Slide()
EndFunc   ;==>Settings

Func ButtonFunctions(ByRef $iNumber)
	If $LaunchNames[$iNumber][1] = "" Then Return
	Slide()
	$Reg = StringRegExp($LaunchNames[$iNumber][1], "(?<Protocol>\w+):\/\/(?<Domain>[\w@][\w.:@]+)\/?[\w\.?=%&=\-@/$,]*", 3)
	If (IsArray($Reg) And UBound($Reg) = 2 And ($Reg[0] = "http" Or $Reg[0] = "https")) Or _
			FileExists($LaunchNames[$iNumber][1]) Or StringLeft($LaunchNames[$iNumber][1], 4) = "www." Then
		GUICtrlSetPos($Buttons[$i], $Left, 35, 68, 41)
		GUICtrlSetColor($Labels[$i], 0x000000)
		ShellExecute($LaunchNames[$iNumber][1])
	Else
		GUICtrlSetPos($Buttons[$iNumber], $Left + 4, 35, 68, 41)
		GUICtrlSetColor($Labels[$iNumber], 0x000000)
		MsgBox(48, "ERROR", "That file does not exist!", 0, $Toolbar)
	EndIf
EndFunc   ;==>ButtonFunctions

Func _Exit()
	Exit
EndFunc   ;==>_Exit

Func Snap_To_Edges()
	If $Hide_State Then
		$Pos = WinGetPos($ShowGUI)
		If $Pos[0] < @DesktopWidth / 2 And $Pos[0] <> 0 Then
			If $Side = "Right" Then Side_Switch()

			GUICtrlSetData($Config, "[]")
			GUICtrlSetData($Hide, "<")
			GUICtrlSetData($Show, ">")
			WinMove($ShowGUI, "", 0, Default)
		ElseIf $Pos[0] > @DesktopWidth / 2 And $Pos[0] <> @DesktopWidth - $Pos[2] Then
			If $Side = "Left" Then Side_Switch()

			GUICtrlSetData($Config, "[]")
			GUICtrlSetData($Hide, ">")
			GUICtrlSetData($Show, "<")
			WinMove($ShowGUI, "", @DesktopWidth - $Pos[2], Default)
		EndIf
	Else
		$Pos = WinGetPos($Toolbar)
		If $Pos[0] < @DesktopWidth / 4 And $Pos[0] <> 0 Then
			If $Side = "Right" Then Side_Switch()

			GUICtrlSetData($Config, "[]")
			GUICtrlSetData($Hide, "<")
			GUICtrlSetData($Show, ">")
			WinMove($Toolbar, "", 0, Default)
		ElseIf $Pos[0] > @DesktopWidth / 4 And $Pos[0] <> @DesktopWidth - $Pos[2] Then
			If $Side = "Left" Then Side_Switch()

			GUICtrlSetData($Config, "[]")
			GUICtrlSetData($Hide, ">")
			GUICtrlSetData($Show, "<")
			WinMove($Toolbar, "", @DesktopWidth - $Pos[2], Default)
		EndIf
	EndIf
EndFunc   ;==>Snap_To_Edges

Func Side_Switch()
	Switch $Side
		Case "Right"
			$Side = "Left"
			$Temp = $Config
			$Config = $Hide
			$Hide = $Temp
		Case Else
			$Side = "Right"
			$Temp = $Config
			$Config = $Hide
			$Hide = $Temp
	EndSwitch
EndFunc   ;==>Side_Switch

Func WriteIni()
	For $x = 1 To 7
		IniWrite($Ini, "Launch", $x, "")
		IniWrite($Ini, "Labels", $x, "")
	Next
EndFunc   ;==>WriteIni

Func Slide()
	GUIRegisterMsg($WM_WINDOWPOSCHANGED, "")
	If $Hide_State Then
		$Pos = WinGetPos($ShowGUI)
		GUISetState(@SW_HIDE, $ShowGUI)
		Switch $Side
			Case "Left"
				WinMove($Toolbar, "", 0, $Pos[1])
				DllCall("user32.dll", "int", "AnimateWindow", "hwnd", $Toolbar, "int", 900, "long", $Slide_Right)
			Case Else
				WinMove($Toolbar, "", @DesktopWidth - 607, $Pos[1])
				DllCall("user32.dll", "int", "AnimateWindow", "hwnd", $Toolbar, "int", 900, "long", $Slide_Left)
		EndSwitch
		GUISwitch($Toolbar)
	Else
		$Pos = WinGetPos($Toolbar)
		Switch $Side
			Case "Right"
				WinMove($ShowGUI, "", @DesktopWidth - 32, $Pos[1])
				DllCall("user32.dll", "int", "AnimateWindow", "hwnd", $Toolbar, "int", 900, "long", BitOR($Slide_Right, $Anim_Hide))
			Case Else
				WinMove($ShowGUI, "", 0, $Pos[1])
				DllCall("user32.dll", "int", "AnimateWindow", "hwnd", $Toolbar, "int", 900, "long", BitOR($Slide_Left, $Anim_Hide))
		EndSwitch
		If Not $ConfigMode Then
			GUISetState(@SW_SHOW, $ShowGUI)
			GUISwitch($ShowGUI)
		EndIf
	EndIf
	$Hide_State = Not $Hide_State
	GUIRegisterMsg($WM_WINDOWPOSCHANGED, "Snap_To_Edges")
EndFunc   ;==>Slide

#Region Button Icons
Func _GetRegDefIcon($Path)

	Const $DF_NAME = @SystemDir & '\shell32.dll'
	Const $DF_INDEX = 0

	Local $filename, $name, $Ext, $count, $curver, $defaulticon, $ret[2] = [$DF_NAME, $DF_INDEX]

	$filename = StringTrimLeft($Path, StringInStr($Path, '\', 0, -1))
	$count = StringInStr($filename, '.', 0, -1)
	If $count > 0 Then
		$count = StringLen($filename) - $count + 1
	EndIf
	$name = StringStripWS(StringTrimRight($filename, $count), 3)
	$Ext = StringStripWS(StringRight($filename, $count - 1), 8)
	If StringLen($Ext) = 0 Then
		Return $ret
	EndIf
	$curver = StringStripWS(RegRead('HKCR\' & RegRead('HKCR\' & '.' & $Ext, '') & '\CurVer', ''), 3)
	If (@error) Or (StringLen($curver) = 0) Then
		$defaulticon = _WinAPI_ExpandEnvironmentStrings(StringReplace(RegRead('HKCR\' & RegRead('HKCR\' & '.' & $Ext, '') & '\DefaultIcon', ''), '''', ''))
	Else
		$defaulticon = _WinAPI_ExpandEnvironmentStrings(StringReplace(RegRead('HKCR\' & $curver & '\DefaultIcon', ''), '''', ''))
	EndIf
	$count = StringInStr($defaulticon, ',', 0, -1)
	If $count > 0 Then
		$count = StringLen($defaulticon) - $count
		$ret[0] = StringStripWS(StringTrimRight($defaulticon, $count + 1), 3)
		If $count > 0 Then
			$ret[1] = StringStripWS(StringRight($defaulticon, $count), 8)
		EndIf
	Else
		$ret[0] = StringStripWS(StringTrimRight($defaulticon, $count), 3)
	EndIf
	If StringLeft($ret[0], 1) = '%' Then
		$count = DllCall('shell32.dll', 'int', 'ExtractIcon', 'int', 0, 'str', $Path, 'int', -1)
		If $count[0] = 0 Then
			$ret[0] = $DF_NAME
			If StringLower($Ext) = 'exe' Then
				$ret[1] = 2
			Else
				$ret[1] = 0
			EndIf
		Else
			$ret[0] = StringStripWS($Path, 3)
			$ret[1] = 0
		EndIf
	Else
		If (StringLen($ret[0]) > 0) And (StringInStr($ret[0], '\', 0) = 0) Then
			$ret[0] = @SystemDir & '\' & $ret[0]
		EndIf
	EndIf
	If Not FileExists($ret[0]) Then
		$ret[0] = $DF_NAME
		$ret[1] = $DF_INDEX
	EndIf
	;   if $ret[1] < 0 then
	;       $ret[1] = - $ret[1]
	;   else
	;       $ret[1] = - $ret[1] - 1
	;   endif
	Return $ret
EndFunc   ;==>_GetRegDefIcon

Func _SetIcon($controlID, $sIcon, $iIndex, $iWidth, $iHeight)

	Const $STM_SETIMAGE = 0x0172

	Local $hWnd, $hIcon, $Style, $Error = False

	$hWnd = GUICtrlGetHandle($controlID)
	If $hWnd = 0 Then
		Return SetError(1, 0, 0)
	EndIf

	$hIcon = _WinAPI_PrivateExtractIcon($sIcon, $iIndex, $iWidth, $iHeight)
	If @error Then
		Return SetError(1, 0, 0)
	EndIf

	$Style = _WinAPI_GetWindowLong($hWnd, $GWL_STYLE)
	If @error Then
		$Error = 1
	Else
		_WinAPI_SetWindowLong($hWnd, $GWL_STYLE, BitOR($Style, $BS_ICON))
		If @error Then
			$Error = 1
		Else
			_WinAPI_DeleteObject(_SendMessage($hWnd, $BM_SETIMAGE, $IMAGE_ICON, 0))
			_SendMessage($hWnd, $BM_SETIMAGE, $IMAGE_ICON, _WinAPI_CopyIcon($hIcon))
			If @error Then
				$Error = 1
			EndIf
		EndIf
	EndIf

	_WinAPI_DeleteObject($hIcon)

	Return SetError($Error, 0, Not $Error)
EndFunc   ;==>_SetIcon

Func _WinAPI_PrivateExtractIcon($sIcon, $iIndex, $iWidth, $iHeight)

	Local $hIcon, $tIcon = DllStructCreate('hwnd'), $tID = DllStructCreate('hwnd')
	Local $ret

	$ret = DllCall('user32.dll', 'int', 'PrivateExtractIcons', 'str', $sIcon, 'int', $iIndex, 'int', $iWidth, 'int', $iHeight, 'ptr', DllStructGetPtr($tIcon), 'ptr', DllStructGetPtr($tID), 'int', 1, 'int', 0)
	If (@error) Or ($ret[0] = 0) Then
		Return SetError(1, 0, 0)
	EndIf

	$hIcon = DllStructGetData($tIcon, 1)

	If ($hIcon = Ptr(0)) Or (Not IsPtr($hIcon)) Then
		Return SetError(1, 0, 0)
	EndIf

	Return SetError(0, 0, $hIcon)
EndFunc   ;==>_WinAPI_PrivateExtractIcon
#EndRegion Button Icons