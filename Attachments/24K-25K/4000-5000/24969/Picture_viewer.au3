#include <IsPressed_UDF.au3> ; #Include <Misc.au3>
;If you dont have my UDF, download it or use the Misc include

HotKeySet('{NUMPADADD}', '_UP') ; Multiply the picture size x2
HotKeySet('{NUMPADSUB}', '_DOWN') ;Divide the picture size x2
Opt('GUIOnEventMode', 1)

#Region Browse
$path = FileOpenDialog('Select picture to view', '', 'BMP (*.bmp)|JPG (*.jpg)|GIF (*.gif)', 1 + 2)
If @error Then Exit ConsoleWrite('!> FileOpenDialog error !' & @CRLF)
$Width = StringTrimRight(_GetExtProperty($path, 27), 7)
$Height = StringTrimRight(_GetExtProperty($path, 28), 7)
ConsoleWrite('+> ' & $path & ' -> ' & $Width & 'x' & $Height & @CRLF)
#EndRegion Browse

#Region GUI
$GUI = GUICreate('Picture viewer', @DesktopWidth, @DesktopHeight, 0, 0); ,0x80000000 + 0x00800000 + 0x00040000)
;~ GUISetOnEvent(-12, '_RESIZE')
GUISetOnEvent(-7, '_DRAG') ;Left Click drag for move the window
GUISetOnEvent(-3, '_Exit') ;ESC key will exit the picture viewer
$pic = GUICtrlCreatePic($path, 0, 0, $Width, $Height, 128)
GUISetState(@SW_SHOW, $GUI)

WinMove($GUI, '', (@DesktopWidth / 2) - ($Width / 2), (@DesktopHeight / 2) - ($Height / 2), $Width, $Height) ;Center the picture on screen
#EndRegion GUI
;

While 1
	Sleep(250)
WEnd


#Region Func
Func _UP()
	$wgc = WinGetPos($GUI)
	WinMove($GUI, '', $wgc[0] - ($wgc[3] / 2), $wgc[1] - ($wgc[1] / 2), $wgc[2] + ($wgc[2] / 2), $wgc[3] + ($wgc[3] / 2))
	GUICtrlSetPos($pic, 0, 0, $wgc[2] + ($wgc[2] / 2), $wgc[3] + ($wgc[3] / 2))
EndFunc   ;==>_UP

Func _DOWN()
	$wgc = WinGetPos($GUI)
	WinMove($GUI, '', $wgc[0] + ($wgc[0] / 2), $wgc[1] + ($wgc[1] / 2), $wgc[2] - ($wgc[2] / 2), $wgc[3] - ($wgc[3] / 2))
	GUICtrlSetPos($pic, 0, 0, $wgc[2] - ($wgc[2] / 2), $wgc[3] - ($wgc[3] / 2))
EndFunc   ;==>_DOWN

Func _DRAG()
	GUISetCursor(9, 1, $GUI)
	$wgp = WinGetPos($GUI)
	$mgp = MouseGetPos()
	While _IsPressed('01')
		$mgp1 = MouseGetPos()
		WinMove($GUI, '', $wgp[0] - ($mgp[0] - $mgp1[0]), $wgp[1] - ($mgp[1] - $mgp1[1]))
	WEnd
	GUISetCursor(-1, 1, $GUI)
EndFunc   ;==>_DRAG

Func _RESIZE()
	$wgc = WinGetPos($GUI)
	GUICtrlSetPos($pic, 0, 0, $wgc[2], $wgc[3])
EndFunc   ;==>_RESIZE

Func _Exit()
	Exit
EndFunc   ;==>_Exit

;===============================================================================
; Function Name: _GetExtProperty
; Author(s): Simucal
;===============================================================================
Func _GetExtProperty($sPath, $iProp)
	Local $iExist, $sFile, $sDir, $oShellApp, $oDir, $oFile, $aProperty, $sProperty
	$sFile = StringTrimLeft($sPath, StringInStr($sPath, "\", 0, -1))
	$sDir = StringTrimRight($sPath, (StringLen($sPath) - StringInStr($sPath, "\", 0, -1)))
	$oShellApp = ObjCreate("shell.application")
	$oDir = $oShellApp.NameSpace($sDir)
	$oFile = $oDir.Parsename($sFile)
	If $iProp = -1 Then
		Local $aProperty[35]
		For $i = 0 To 34
			$aProperty[$i] = $oDir.GetDetailsOf($oFile, $i)
		Next
		Return $aProperty
	Else
		$sProperty = $oDir.GetDetailsOf($oFile, $iProp)
		If $sProperty = '' Then
			Return 'None'
		Else
			Return $sProperty
		EndIf
	EndIf
EndFunc   ;==>_GetExtProperty
#EndRegion Func