#include <GUIConstantsEx.au3>
#include <GDIPlus.au3>
#include <Constants.au3>
#include <SendMessage.au3>
#include <StaticConstants.au3>
#include <StructureConstants.au3>
#include <WinAPI.au3>
#include <WindowsConstants.au3>

Opt("OnExitFunc", "OnAutoItExit")
HotKeySet('{ESC}', '_EXIT')

Global Const $STM_SETIMAGE = 0x0172
Global Const $WM_MOUSEWHEEL = 0x020A
Global Const $WM_LBUTTONDOWN = 0x201
Global Const $WM_MBUTTONDOWN = 0x0207
Global Const $WM_RBUTTONDOWN = 0x0204
Global Const $DF_NAME = @SystemDir & '\shell32.dll'
Global Const $DF_INDEX = 0
Global Const $tagMSLLHOOKSTRUCT = $tagPOINT & ';dword mouseData;dword flags;dword time;ulong_ptr dwExtraInfo'
Global Const $wrad = 250, $Width = 60, $Outer_Items = 6, $Rotation_Increment = 10
Global Const $Padding = 20, $cx = $wrad + $Padding + $Width / 2, $cy = $wrad + $Padding + $Width / 2
Global Const $Size = 2 * $wrad + $Width + 2 * $Padding
Global $hBitmap, $ImageHeight, $ImageWidth, $Image_Style
Global $Icons = 0
Dim $GUI[$Outer_Items + 1]
Dim $Angle[$Outer_Items + 1]
Dim $Icon[$Outer_Items + 1]

#cs Notes
	cx is the x value of the center of the circle and the parent gui
	cy is the y value of the center of the circle and the parent gui
	wrad is the radius of the circle
	width is the width of the child guis
	items is the number of items in the circle
	rotation_increment is the speed at which the gui rotates
#ce

If Not FileExists(@ScriptDir & "\Settings.ini") Then
	For $x = 1 To $Outer_Items
		IniWrite(@ScriptDir & "\Settings.ini", "Run", $x, "")
		IniWrite(@ScriptDir & "\Settings.ini", "Icon", $x, "")
	Next
	IniWrite(@ScriptDir & "\Settings.ini", "Options", "Hide Key", "WM_MBUTTONDOWN")
	IniWrite(@ScriptDir & "\Settings.ini", "Options", "Background", "")
EndIf

$hFunc = DllCallbackRegister("Mouse_LL", "long", "int;wparam;lparam")
$hHook = _WinAPI_SetWindowsHookEx($WH_MOUSE_LL, DllCallbackGetPtr($hFunc), _WinAPI_GetModuleHandle(0))

$GUI[0] = GUICreate("", 2 * $wrad + $Width + 2 * $Padding, 2 * $wrad + $Width + 2 * $Padding, -1, -1, $WS_POPUP)

$ContextMenu = GUICtrlCreateContextMenu()
$Item1 = GUICtrlCreateMenuItem("Item 1", $ContextMenu)
$Item2 = GUICtrlCreateMenuItem("Item 2", $ContextMenu)
$Context_Quit = GUICtrlCreateMenuItem("Quit", $ContextMenu)

$Client = WinGetClientSize($GUI[0])
$Pic = GUICtrlCreatePic("", ($Client[0] - ($Size - ($Size / 3 + $Padding))) / 2, _
		($Client[1] - ($Size - ($Size / 3 + $Padding))) / 2, $Size - ($Size / 3 + $Padding), $Size - ($Size / 3 + $Padding), -1, $GUI_WS_EX_PARENTDRAG)
_ImageResize(@ScriptDir & "\Icons\Windows Vista Logo.png", @ScriptDir & "\Icons\Current Logo.png", _
		$Size - ($Size / 3 + $Padding), $Size - ($Size / 3 + $Padding))
_SetImage($Pic, @ScriptDir & "\Icons\Current Logo.png")

;Set Background Color
$Background = PixelGetColor(($Client[0] - ($Size - ($Size / 3 + $Padding))) / 2, ($Client[0] - ($Size - ($Size / 3 + $Padding))) / 2, $GUI[0])
$Background = Hex($Background, 6)
GUISetBkColor($Background, $GUI[0])

;create outer rim
$a = _CreateRoundRectRgn(0, 0, $Size, $Size, $Size, $Size)

;create gap between circles
$b = _CreateRoundRectRgn($Size / 6 + $Padding / 2, $Size / 6 + $Padding / 2, $Size - ($Size / 3 + $Padding), _
		$Size - ($Size / 3 + $Padding), $Size - $Size / 6 + $Padding / 2, $Size - $Size / 6 + $Padding / 2)

;create inside circle
$c = _CreateRoundRectRgn($Size / 6, $Size / 6, $Size - $Size / 3, $Size - $Size / 3, $Size - $Size / 6, $Size - $Size / 6)

_CombineRgn($a, $b)
_CombineRgn($a, $c)
_SetWindowRgn($GUI[0], $a)

GUISetState()

For $x = 1 To $Outer_Items
	$Angle[$x] = -(($x - 1) * 360 / $Outer_Items)
	$GUI[$x] = GUICreate("Top", $Width, $Width, $cx + $wrad * Sin($Angle[$x] * ATan(1) / 45) - ($Width / 2), _
			$cy - $wrad * Cos($Angle[$x] * ATan(1) / 45) - ($Width / 2), $WS_CHILD, -1, $GUI[0])
	$Icon[$x] = GUICtrlCreateIcon("", -1, 0, 0, $Width, $Width)
	If IniRead(@ScriptDir & "\Settings.ini", "Icon", $x, "") <> "" And IniRead(@ScriptDir & "\Settings.ini", "Run", $x, "") <> "" Then
		$String = IniRead(@ScriptDir & "\Settings.ini", "Icon", $x, "")
		If StringInStr($String, "\") Then
			GUICtrlSetImage($Icon[$x], IniRead(@ScriptDir & "\Settings.ini", "Icon", $x, ""))
		Else
			$Reg = _GetRegDefIcon("." & $String)
			_SetIcon($Icon[$x], $Reg[0], $Reg[1], 48, 48)
		EndIf
		$Icons += 1
		GUICtrlSetTip($Icon[$x], IniRead(@ScriptDir & "\Settings.ini", "Icon", $x, ""))
	EndIf
	GUISetBkColor(0x00FF00, $GUI[$x])
	GUISetState(@SW_SHOW, $GUI[$x])
	$iFlags = BitOR($SWP_SHOWWINDOW, $SWP_NOSIZE, $SWP_NOMOVE)
	_WinAPI_SetWindowPos($GUI[$x], $HWND_TOP, 0, 0, 0, 0, $iFlags)
Next

GUISetState(@SW_SHOW, $GUI[0])

;~ GUIRegisterMsg($WM_LBUTTONDOWN, "_Drag")

Sleep(6000)

While 1
	$Msg = GUIGetMsg()
	Switch $Msg
		Case $Item1
			If Add($Icon[$Icons + 1]) = 1 Then $Icons += 1
;~ 			If Add(Eval("Icon" & ($Icons + 1))) = 1 Then $Icons += 1
		Case $Item2
			AddDockFolder()
		Case $Context_Quit
			Exit
	EndSwitch


	For $x = 1 To $Outer_Items
		If $Msg = $Icon[$x] Then ShellExecute(IniRead(@ScriptDir & "\Settings.ini", "Run", $x, ""))
;~ 		If $Msg = Eval("Icon" & $x) Then ShellExecute(IniRead(@ScriptDir & "\Settings.ini", "Run", $x, ""))
	Next
WEnd

Func _ImageResize($sInImage, $sOutImage, $iW, $iH) ;by Achilles
	Local $hWnd, $hDC, $hBMP, $hImage1, $hImage2, $hGraphic, $CLSID, $i = 0
	Local $sOF = StringMid($sOutImage, StringInStr($sOutImage, "\", 0, -1) + 1)
	Local $Ext = StringUpper(StringMid($sOutImage, StringInStr($sOutImage, ".", 0, -1) + 1))
	$hWnd = _WinAPI_GetDesktopWindow()
	$hDC = _WinAPI_GetDC($hWnd)
	$hBMP = _WinAPI_CreateCompatibleBitmap($hDC, $iW, $iH)
	_WinAPI_ReleaseDC($hWnd, $hDC)
	_GDIPlus_Startup()
	$hImage1 = _GDIPlus_BitmapCreateFromHBITMAP($hBMP)
	$hImage2 = _GDIPlus_ImageLoadFromFile($sInImage)
	$hGraphic = _GDIPlus_ImageGetGraphicsContext($hImage1)
	_GDIPlus_GraphicsDrawImageRect($hGraphic, $hImage2, 0, 0, $iW, $iH)
	$CLSID = _GDIPlus_EncodersGetCLSID($Ext)
	_GDIPlus_ImageSaveToFileEx($hImage1, $sOutImage, $CLSID)
	_GDIPlus_ImageDispose($hImage1)
	_GDIPlus_ImageDispose($hImage2)
	_GDIPlus_GraphicsDispose($hGraphic)
	_WinAPI_DeleteObject($hBMP)
	_GDIPlus_Shutdown()
EndFunc   ;==>_ImageResize

Func _SetImage($hWnd, $sImage) ;made by Yashied in Icons.au3
	Local $hImage, $hBitmap, $Style, $Error = False
	If Not IsHWnd($hWnd) Then
		$hWnd = GUICtrlGetHandle($hWnd)
		If $hWnd = 0 Then
			Return SetError(1, 0, 0)
		EndIf
	EndIf
	_GDIPlus_Startup()

	$hImage = _GDIPlus_BitmapCreateFromFile($sImage)
	$hBitmap = _GDIPlus_BitmapCreateHBITMAPFromBitmap($hImage)
	If $hBitmap = 0 Then
		Return SetError(1, 0, 0)
	EndIf
	$Style = _WinAPI_GetWindowLong($hWnd, $GWL_STYLE)
	If @error Then
		$Error = 1
	Else
		_WinAPI_SetWindowLong($hWnd, $GWL_STYLE, BitOR($Style, Hex($SS_BITMAP)))
		If @error Then
			$Error = 1
		Else
			_WinAPI_DeleteObject(_SendMessage($hWnd, $STM_SETIMAGE, $IMAGE_BITMAP, 0))
			_SendMessage($hWnd, $STM_SETIMAGE, $IMAGE_BITMAP, $hBitmap)
			If @error Then
				$Error = 1
			EndIf
		EndIf
	EndIf

	If $Error Then
		_WinAPI_DeleteObject($hBitmap)
	EndIf
	_GDIPlus_BitmapDispose($hImage)
	_GDIPlus_Shutdown()

	Return SetError($Error, 0, Not $Error)
EndFunc   ;==>_SetImage

Func _EXIT()
	Exit
EndFunc   ;==>_EXIT

Func AddDockFolder()

EndFunc   ;==>AddDockFolder

Func _CreateRoundRectRgn($l, $t, $w, $h, $e1, $e2)
	$ret = DllCall("gdi32.dll", "long", "CreateRoundRectRgn", "long", $l, "long", $t, "long", $l + $w, "long", $t + $h, "long", $e1, "long", $e2)
	Return $ret[0]
EndFunc   ;==>_CreateRoundRectRgn

Func _CombineRgn(ByRef $rgn1, ByRef $rgn2)
	DllCall("gdi32.dll", "long", "CombineRgn", "long", $rgn1, "long", $rgn1, "long", $rgn2, "int", 3)
EndFunc   ;==>_CombineRgn

Func _SetWindowRgn($h_win, $rgn)
	DllCall("user32.dll", "long", "SetWindowRgn", "hwnd", $h_win, "long", $rgn, "int", 1)
EndFunc   ;==>_SetWindowRgn

Func Add($Icon)
	#cs Errors
		1 - no file selected
		2 - can't split file by .
		3 - other error
	#ce

	Local $File, $Split, $Reg
	$File = FileOpenDialog("Test", @DesktopDir, "All (*.*)")
	If @error Then Return SetError(1, 0, -1)
	$Split = StringSplit($File, ".", 2)
	If @error Then Return SetError(2, 0, -1)

	If $Split[UBound($Split) - 1] = "exe" Or $Split[UBound($Split) - 1] = "lnk" Or $Split[UBound($Split) - 1] = "ani" Then
		GUICtrlSetImage($Icon, $File)
		IniWrite(@ScriptDir & "\Settings.ini", "Icon", StringRight($Icon, 1), $File)
	Else
		$Reg = _GetRegDefIcon("." & $Split[UBound($Split) - 1])
		_SetIcon($Icon, $Reg[0], $Reg[1], 48, 48)
		IniWrite(@ScriptDir & "\Settings.ini", "Icon", StringRight($Icon, 1), $Reg[0])
	EndIf
	If @error Then Return SetError(3, 0, -1)
	IniWrite(@ScriptDir & "\Settings.ini", "Run", StringRight($Icon, 1), $File)
	Return 1
EndFunc   ;==>Add

Func _GetRegDefIcon($Path)

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
	Return $ret
EndFunc   ;==>_GetRegDefIcon

Func _SetIcon($controlID, $sIcon, $iIndex, $iWidth, $iHeight)

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
		_WinAPI_SetWindowLong($hWnd, $GWL_STYLE, BitOR($Style, $SS_ICON))
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
	If $h_gui = $GUI[0] Then DllCall("user32.dll", "int", "SendMessage", "hWnd", $h_gui, "int", 0xA1, "int", 2, "int", 0)
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
			For $x = 1 To $Outer_Items
				$Angle[$x] += $Rotation_Increment
				If $Angle[$x] >= 0 Then $Angle[$x] -= 360
				WinMove($GUI[$x], "", $cx + $wrad * Sin($Angle[$x] * ATan(1) / 45) - ($Width / 2), $cy - $wrad * Cos($Angle[$x] * ATan(1) / 45) - ($Width / 2))
			Next
		Else
			For $x = 1 To $Outer_Items
				$Angle[$x] -= $Rotation_Increment
				If $Angle[$x] >= 0 Then $Angle[$x] -= 360
				WinMove($GUI[$x], "", $cx + $wrad * Sin($Angle[$x] * ATan(1) / 45) - ($Width / 2), $cy - $wrad * Cos($Angle[$x] * ATan(1) / 45) - ($Width / 2))
			Next
		EndIf
	ElseIf $iwParam = Eval(IniRead(@ScriptDir & "\Settings.ini", "Options", "Hide Key", "WM_MBUTTONDOWN")) Then
		If BitAND(WinGetState($GUI[0]), 2) Then
			WinSetState($GUI[0], "", @SW_HIDE)
		Else
			WinSetState($GUI[0], "", @SW_SHOW)
		EndIf
	EndIf

	Return _WinAPI_CallNextHookEx($hHook, $iCode, $iwParam, $ilParam)
EndFunc   ;==>Mouse_LL