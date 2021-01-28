#include <GUIConstantsEx.au3>
#include <Icons.au3>
#include <WinAPI.au3>

$GUI = GUICreate("Sliding Toolbar", 601, 83, 0, -1, $WS_POPUP, BitOR($WS_EX_TOPMOST, $WS_EX_TOOLWINDOW, $WS_EX_LAYERED, $WS_EX_ACCEPTFILES))
GUISetBkColor(0x010101)

$Icon = GUICtrlCreateIcon("", 0, 24, 35, 72, 41)
$Reg = RetrieveIconPath(@ScriptDir & "\Settings.ini")
_SetCombineBkIcon($Icon, -1, @ScriptDir & "\Ring.ico", 0, 35, 35, $Reg[0], $Reg[1], 29, 29, 3, 2)
_WinAPI_SetLayeredWindowAttributes($GUI, 0x010101)
GUISetState(@SW_SHOW, $GUI)

While 1
WEnd

Func RetrieveIconPath($sPath)
	Local $Reg, $defaultBrowser, $Short
	$Reg = StringRegExp($sPath, "(?<Protocol>\w+):\/\/(?<Domain>[\w@][\w.:@]+)\/?[\w\.?=%&=\-@/$,]*", 3)
	If (IsArray($Reg) And UBound($Reg) = 2 And ($Reg[0] = "http" Or $Reg[0] = "https")) Or StringLeft($sPath, 4) = "www." Then
		$defaultBrowser = RegRead("HKEY_CLASSES_ROOT\http\shell\open\command", "")
		$defaultBrowser = StringTrimLeft($defaultBrowser, 1)
		$defaultBrowser = StringMid($defaultBrowser, 1, StringInStr($defaultBrowser, '"') - 1)
		$Reg = _GetRegDefIcon($defaultBrowser)
		Return SetError(0, 1, $Reg)
	ElseIf StringRight($sPath, 4) = ".lnk" Then
		$Short = FileGetShortcut($sPath)
		$Reg = _GetRegDefIcon($Short[0])
		Return SetError(0, 2, $Reg)
	Else
		$Reg = _GetRegDefIcon($sPath)
		Return SetError(0, 3, $Reg)
	EndIf
	Return SetError(-1, -1, -1)
EndFunc   ;==>RetrieveIconPath

Func _WinAPI_SetLayeredWindowAttributes($hWnd, $i_transcolor, $Transparency = 255, $dwFlages = 0x03, $isColorRef = False)
	; #############################################
	; You are NOT ALLOWED to remove the following lines
	; Function Name: _WinAPI_SetLayeredWindowAttributes
	; Author(s): Prog@ndy
	; #############################################
	If $dwFlages = Default Or $dwFlages = "" Or $dwFlages < 0 Then $dwFlages = 0x03

	If Not $isColorRef Then
		$i_transcolor = Hex(String($i_transcolor), 6)
		$i_transcolor = Execute('0x00' & StringMid($i_transcolor, 5, 2) & StringMid($i_transcolor, 3, 2) & StringMid($i_transcolor, 1, 2))
	EndIf
	Local $Ret = DllCall("user32.dll", "int", "SetLayeredWindowAttributes", "hwnd", $hWnd, "long", $i_transcolor, "byte", $Transparency, "long", $dwFlages)
	Select
		Case @error
			Return SetError(@error, 0, 0)
		Case $Ret[0] = 0
			Return SetError(4, _WinAPI_GetLastError(), 0)
		Case Else
			Return 1
	EndSelect
EndFunc   ;==>_WinAPI_SetLayeredWindowAttributes

#Region Button Icons
Func _GetRegDefIcon($Path)

	Const $DF_NAME = @SystemDir & '\shell32.dll'
	Const $DF_INDEX = 0

	Local $filename, $name, $Ext, $count, $curver, $defaulticon, $Ret[2] = [$DF_NAME, $DF_INDEX]

	$filename = StringTrimLeft($Path, StringInStr($Path, '\', 0, -1))
	$count = StringInStr($filename, '.', 0, -1)
	If $count > 0 Then
		$count = StringLen($filename) - $count + 1
	EndIf
	$name = StringStripWS(StringTrimRight($filename, $count), 3)
	$Ext = StringStripWS(StringRight($filename, $count - 1), 8)
	If StringLen($Ext) = 0 Then
		Return $Ret
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
		$Ret[0] = StringStripWS(StringTrimRight($defaulticon, $count + 1), 3)
		If $count > 0 Then
			$Ret[1] = StringStripWS(StringRight($defaulticon, $count), 8)
		EndIf
	Else
		$Ret[0] = StringStripWS(StringTrimRight($defaulticon, $count), 3)
	EndIf
	If StringLeft($Ret[0], 1) = '%' Then
		$count = DllCall('shell32.dll', 'int', 'ExtractIcon', 'int', 0, 'str', $Path, 'int', -1)
		If $count[0] = 0 Then
			$Ret[0] = $DF_NAME
			If StringLower($Ext) = 'exe' Then
				$Ret[1] = 2
			Else
				$Ret[1] = 0
			EndIf
		Else
			$Ret[0] = StringStripWS($Path, 3)
			$Ret[1] = 0
		EndIf
	Else
		If (StringLen($Ret[0]) > 0) And (StringInStr($Ret[0], '\', 0) = 0) Then
			$Ret[0] = @SystemDir & '\' & $Ret[0]
		EndIf
	EndIf
	If Not FileExists($Ret[0]) Then
		$Ret[0] = $DF_NAME
		$Ret[1] = $DF_INDEX
	EndIf
	;   if $ret[1] < 0 then
	;       $ret[1] = - $ret[1]
	;   else
	;       $ret[1] = - $ret[1] - 1
	;   endif
	Return $Ret
EndFunc   ;==>_GetRegDefIcon

Func _WinAPI_PrivateExtractIcon($sIcon, $iIndex, $iWidth, $iHeight)

	Local $hIcon, $tIcon = DllStructCreate('hwnd'), $tID = DllStructCreate('hwnd')
	Local $Ret

	$Ret = DllCall('user32.dll', 'int', 'PrivateExtractIcons', 'str', $sIcon, 'int', $iIndex, 'int', $iWidth, 'int', $iHeight, 'ptr', DllStructGetPtr($tIcon), 'ptr', DllStructGetPtr($tID), 'int', 1, 'int', 0)
	If (@error) Or ($Ret[0] = 0) Then
		Return SetError(1, 0, 0)
	EndIf

	$hIcon = DllStructGetData($tIcon, 1)

	If ($hIcon = Ptr(0)) Or (Not IsPtr($hIcon)) Then
		Return SetError(1, 0, 0)
	EndIf

	Return SetError(0, 0, $hIcon)
EndFunc   ;==>_WinAPI_PrivateExtractIcon
#EndRegion Button Icons
