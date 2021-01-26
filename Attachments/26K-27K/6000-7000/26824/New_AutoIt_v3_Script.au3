#include <Constants.au3>
#include <SendMessage.au3>
#include <StaticConstants.au3>
#include <StructureConstants.au3>
#include <WinAPI.au3>
#include <WindowsConstants.au3>

HotKeySet('{ESC}', '_EXIT')

Global Const $WM_MOUSEWHEEL = 0x020A
Global Const $WM_LBUTTONDOWN = 0x201
Global Const $tagMSLLHOOKSTRUCT = $tagPOINT & ';dword mouseData;dword flags;dword time;ulong_ptr dwExtraInfo'
Global Const $wrad = 250, $Width = 50, $Items = 4, $Rotation_Increment = 10, $PI = 3.14159265358979
Global Const $Padding = 20, $cx = $wrad + $Padding + $Width / 2, $cy = $wrad + $Padding + $Width / 2
Global $Icons = 0
#cs Notes
	cx is the x value of the center of the circle and the parent gui
	cy is the y value of the center of the circle and the parent gui
	wrad is the radius of the circle
	width is the width of the child guis
	items is the number of items in the circle
	rotation_increment is the speed at which the gui rotates
#ce

For $x = 1 To $Items
	Assign($x & "Angle", -(($x - 1) * 360 / $Items))
Next

$hFunc = DllCallbackRegister("Mouse_LL", "long", "int;wparam;lparam")
$hHook = _WinAPI_SetWindowsHookEx($WH_MOUSE_LL, DllCallbackGetPtr($hFunc), _WinAPI_GetModuleHandle(0))

$GUI0 = GUICreate("", 2 * $wrad + $Width + 2 * $Padding, 2 * $wrad + $Width + 2 * $Padding, -1, -1, $WS_POPUP)
$Button = GUICtrlCreateButton("Add", $cx, $cy, 75, 23)
GUISetState()
_GuiRoundCorners($GUI0, 0, 0, 2 * $wrad + $Width + 2 * $Padding, 2 * $wrad + $Width + 2 * $Padding)

$GUI1 = GUICreate("Top", $Width, $Width, $cx - ($Width / 2), $cy - ($Width / 2) - $wrad, $WS_CHILD, $WS_EX_LAYERED, $GUI0)
$Icon1 = GUICtrlCreateIcon("", -1, 0, 0, $Width, $Width)
GUISetBkColor(0x00FF00)
GUISetState()

$GUI2 = GUICreate("Right", $Width, $Width, $cx - ($Width / 2) + $wrad, $cy - ($Width / 2), $WS_CHILD, -1, $GUI0)
$Icon2 = GUICtrlCreateIcon("", -1, 0, 0, $Width, $Width)
GUISetBkColor(0x00FF00)
GUISetState()

$GUI3 = GUICreate("Bottom", $Width, $Width, $cx - ($Width / 2), $cy - ($Width / 2) + $wrad, $WS_CHILD, -1, $GUI0)
$Icon3 = GUICtrlCreateIcon("", -1, 0, 0, $Width, $Width)
GUISetBkColor(0x00FF00)
GUISetState()

$GUI4 = GUICreate("Left", $Width, $Width, $cx - ($Width / 2) - $wrad, $cy - ($Width / 2), $WS_CHILD, -1, $GUI0)
$Icon4 = GUICtrlCreateIcon("", -1, 0, 0, $Width, $Width)
GUISetBkColor(0x00FF00)
GUISetState()

GUIRegisterMsg($WM_LBUTTONDOWN, "_Drag")

While 1
	$Msg = GUIGetMsg()
	Switch $Msg
		Case $Button
			If Add(Eval("Icon" & ($Icons + 1))) = 1 Then $Icons += 1
	EndSwitch
WEnd

Func _EXIT()
	Exit
EndFunc   ;==>_EXIT

Func Add($Icon)
	Local $File, $Split, $Reg
	$File = FileOpenDialog("Test", @DesktopDir, "All (*.*)")
	$Split = StringSplit($File, ".", 2)

	If $Split[UBound($Split) - 1] = "exe" Or $Split[UBound($Split) - 1] = "lnk" Or $Split[UBound($Split) - 1] = "ani" Then
		GUICtrlSetImage($Icon, $File)
	Else
		$Reg = _GetRegDefIcon("." & $Split[UBound($Split) - 1])
		_SetIcon($Icon, $Reg[0], $Reg[1], 48, 48)
	EndIf
	If Not @error Then Return 1
	Return 0
EndFunc   ;==>Add

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
	;      $ret[1] = - $ret[1]
	;   else
	;      $ret[1] = - $ret[1] - 1
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
		_WinAPI_SetWindowLong($hWnd, $GWL_STYLE, BitOR($Style, Hex($SS_ICON)))
		If @error Then
			$Error = 1
		Else
			_WinAPI_DeleteObject(_SendMessage($hWnd, $STM_SETIMAGE, $IMAGE_ICON, 0))
			_SendMessage($hWnd, $STM_SETIMAGE, $IMAGE_ICON, _WinAPI_CopyIcon($hIcon))
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

Func _Drag($h_gui)
	If $h_gui = $GUI0 Then DllCall("user32.dll", "int", "SendMessage", "hWnd", $h_gui, "int", 0xA1, "int", 2, "int", 0)
EndFunc   ;==>_Drag

Func OnAutoItExit()
	_WinAPI_UnhookWindowsHookEx($hHook)
	DllCallbackFree($hFunc)
EndFunc   ;==>OnAutoItExit

Func Mouse_LL($iCode, $iwParam, $ilParam)
	Local $tMSLLHOOKSTRUCT = DllStructCreate($tagMSLLHOOKSTRUCT, $ilParam)

	If $iCode < 0 Then
		Return _WinAPI_CallNextHookEx($hHook, $iCode, $iwParam, $ilParam)
	EndIf

	If $iwParam = $WM_MOUSEWHEEL Then
		Local $iValue = DllStructGetData($tMSLLHOOKSTRUCT, 'mouseData') / 2 ^ 16
		If BitAND($iValue, 0x8000) Then $iValue = BitOR($iValue, 0xFFFF0000)
		If Abs($iValue) = $iValue Then ;ivalue is positive
			For $x = 1 To $Items
				Assign($x & "Angle", Eval($x & "Angle") + $Rotation_Increment)
				If Eval($x & "Angle") >= 0 Then Assign($x & "Angle", Eval($x & "Angle") - 360)
				WinMove(Eval("GUI" & $x), "", $cx + $wrad * Sin(Eval($x & "Angle") * ATan(1) / 45) - ($Width / 2), $cy - $wrad * Cos(Eval($x & "Angle") * ATan(1) / 45) - ($Width / 2))
			Next
		Else
			For $x = 1 To $Items
				Assign($x & "Angle", Eval($x & "Angle") - $Rotation_Increment)
				If Eval($x & "Angle") >= 0 Then Assign($x & "Angle", Eval($x & "Angle") - 360)
				WinMove(Eval("GUI" & $x), "", $cx + $wrad * Sin(Eval($x & "Angle") * ATan(1) / 45) - ($Width / 2), $cy - $wrad * Cos(Eval($x & "Angle") * ATan(1) / 45) - ($Width / 2))
			Next
		EndIf
	EndIf

	Return _WinAPI_CallNextHookEx($hHook, $iCode, $iwParam, $ilParam)
EndFunc   ;==>Mouse_LL

Func _GuiRoundCorners($hWnd, $nLeftRect, $nTopRect, $nWidthEllipse, $nHeightEllipse)
	Dim $pos, $ret, $ret2
	$pos = WinGetPos($hWnd)
	$ret = DllCall("gdi32.dll", "long", "CreateRoundRectRgn", "long", $nLeftRect, "long", $nTopRect, "long", _
			$pos[2], "long", $pos[3], "long", $nWidthEllipse, "long", $nHeightEllipse)
	If $ret[0] Then
		$ret2 = DllCall("user32.dll", "long", "SetWindowRgn", "hwnd", $hWnd, "long", $ret[0], "int", 1)
		If $ret2[0] Then Return 1
	EndIf
	Return 0
EndFunc   ;==>_GuiRoundCorners