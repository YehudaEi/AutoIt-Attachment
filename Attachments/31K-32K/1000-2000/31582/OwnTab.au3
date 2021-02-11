#include-once
#include <GDIPlus.au3>
#include <Array.au3>
#include <Constants.au3>
#include <WindowsConstants.au3>
#Include <Timers.au3>

#cs
	Copyrights to funkey from Autoit.de
#ce

Local $HoverArray[1], $ControlID, $Global_I = 0, $__ControlID, $HoverActive = 0, $Temp_Found = 0, $szTemp_Array[2]
Local $OwnTabHoverCol[2], $OwnTabHoverHelp[1], $OwnTabHoverSwitch, $aOwnTabHoverCount, $OwnTabHoverCtrl
Local $aOwnTabAlarm[1][3], $iOwnTabAlarm, $hOwnTabGui, $hTimerAlarm, $hTimerHover, $OwnTab_Style = "1"

_GDIPlus_Startup()
OnAutoItExitRegister("_OwnTab_OnExit")

Func _OwnTab_Create($hWnd, $aTabText, $xPos, $yPos, $iWidth, $iHeight, $iItemHeight = -1, $nColNoSel = -1, $nColSel = -1, $nColBg = -1, $aIcons = "")
	Local $aSize, $aSize2[UBound($aTabText)][2], $xLast = 0, $aCtrl[UBound($aTabText) + 1][11], $iOffset = 0
	If Not IsArray($aIcons) Then
		Local $Icons[UBound($aTabText)][2]
	Else
		Local $Icons = $aIcons
	EndIf
	If Not IsArray($aTabText) Then Return SetError(1, 0, "")
	GUICtrlCreateLabel("", $xPos, $yPos + $iItemHeight, $iWidth, $iHeight, 0x411000, 1)
	GUICtrlSetState(-1, 128) ;$GUI_DISABLE
	GUICtrlSetBkColor(-1, $nColBg)
	For $i = 0 To UBound($aTabText) - 1
		If $aTabText[$i] = "" Then Return SetError(2, $i + 1, "")
		$aSize = _GetTextSize($aTabText[$i])
		$aSize[0] += Ceiling($aSize[0] / 10) ;make it 10% longer for bold text
		$aSize2[$i][0] = $aSize[0]
		$aSize2[$i][1] = $aSize[1]
		If $iItemHeight = -1 Then $iItemHeight = $aSize[1]
		If $Icons[$i][0] <> "" Then
			$iOffset = $iItemHeight
			$aTabText[$i] &= " "
		Else
			$iOffset = 0
		EndIf
		$aCtrl[$i + 1][7] = $Icons[$i][0] ;filename for icon
		$aCtrl[$i + 1][8] = $Icons[$i][1] ;index for icon
		$aCtrl[$i + 1][9] = $aSize[0] + 5 + $iOffset ;labelwidth
		$aCtrl[$i + 1][0] = Call("_OwnTab_Style" & $OwnTab_Style, $hWnd, $aTabText[$i], $xPos + $xLast + 5, $yPos + 2, $aCtrl[$i + 1][9], $iItemHeight, $Icons[$i][0])
		$aCtrl[$i + 1][10] = @extended	;hWnd of the tab (Child-Gui)
		_HoverAddCtrl($aCtrl[$i + 1][0])
		If $Icons[$i][0] <> "" Then
			$aCtrl[$i + 1][6] = GUICtrlCreateIcon($Icons[$i][0], $Icons[$i][1], 6, 4, $iItemHeight - 8, $iItemHeight - 8)
		Else
			$aCtrl[$i + 1][6] = GUICtrlCreateDummy()
		EndIf
		GUICtrlCreateLabel($aCtrl[$i + 1][7], -200, -200) ;For information
		GUICtrlCreateLabel($aCtrl[$i + 1][8], -200, -200) ;For information
		GUICtrlCreateLabel($iItemHeight - 6, -200, -200) ;For information
		GUICtrlCreateLabel($aCtrl[$i + 1][10], -200, -200) ;hWnd for information
		$aCtrl[$i + 1][2] = $nColNoSel
		$aCtrl[$i + 1][3] = $nColSel
		$xLast += $aCtrl[$i + 1][9]
	Next
	GUISwitch($hWnd)
	$xLast = 0
	For $i = 0 To UBound($aTabText) - 1
		If $Icons[$i][0] <> "" Then
			$iOffset = $iItemHeight
		Else
			$iOffset = 0
		EndIf
		$aCtrl[$i + 1][1] = GUICtrlCreateLabel("", $xPos + $xLast + 7, $yPos + $iItemHeight - 1, $aSize2[$i][0] + 1 + $iOffset, 4)
		GUICtrlSetBkColor(-1, $nColSel)
		$xLast += $aSize2[$i][0] + 5 + $iOffset
	Next
	$aCtrl[0][1] = $iItemHeight
	$aCtrl[0][2] = $nColNoSel
	$aCtrl[0][3] = $nColSel
	$aCtrl[0][9] = $yPos + 2
	$hOwnTabGui = $hWnd
	Return $aCtrl
EndFunc   ;==>_OwnTab_Create

Func _OwnTab_Switch(ByRef $aOwnTab, $iIndex, $fForce = 0)
	_OwnTab_UnRegisterHover($aOwnTab, $iIndex)
	If _OwnTab_IsAlarmed($aOwnTab[$iIndex][0]) Then $aOwnTabAlarm[@extended][2] = $aOwnTabAlarm[@extended][1]
	$HoverActive = 0
	If $aOwnTab[0][0] = $iIndex And $fForce = 0 Then Return
	Local $hWnd_old
	For $s = 1 To UBound($aOwnTab, 1) - 1
		If $iIndex <> $s Then
			GUICtrlSetState($aOwnTab[$s][1], 32) ;$GUI_HIDE
			GUICtrlSetFont($aOwnTab[$s][0], -1, 400)
			If Not _OwnTab_IsAlarmed($aOwnTab[$s][0]) Then
				$hWnd_old = GUISwitch($aOwnTab[$s][10])
				GUISetBkColor($aOwnTab[$s][2])
				GUISwitch($hWnd_old)
			EndIf
			If _ArraySearch($OwnTabHoverHelp, $aOwnTab[$s][0]) = -1 Then
				_OwnTab_RegisterHover($aOwnTab, $s)
			EndIf
		Else
			GUICtrlSetFont($aOwnTab[$s][0], -1, 1000)
			If Not _OwnTab_IsAlarmed($aOwnTab[$s][0]) Then
				$hWnd_old = GUISwitch($aOwnTab[$s][10])
				GUISetBkColor($aOwnTab[$s][3])
				GUISwitch($hWnd_old)
			EndIf
			GUICtrlSetState($aOwnTab[$s][1], 16) ;$GUI_SHOW
		EndIf
	Next
	If $aOwnTab[0][0] = "" Or $fForce Then
		For $t = $aOwnTab[0][4] To $aOwnTab[UBound($aOwnTab, 1) - 1][4]
			GUICtrlSetState($t, 32) ;$GUI_HIDE
			If $t > $aOwnTab[$iIndex - 1][4] And $t < $aOwnTab[$iIndex][4] Then GUICtrlSetState($t, 16) ;$GUI_SHOW
		Next
	Else
		For $t = $aOwnTab[$aOwnTab[0][0] - 1][4] To $aOwnTab[$aOwnTab[0][0]][4]
			GUICtrlSetState($t, 32) ;$GUI_HIDE
		Next
		For $t = $aOwnTab[$iIndex - 1][4] To $aOwnTab[$iIndex][4]
			GUICtrlSetState($t, 16) ;$GUI_SHOW
		Next
	EndIf
	$aOwnTab[0][0] = $iIndex
EndFunc   ;==>_OwnTab_Switch

Func _OwnTab_SetTip(ByRef $aOwnTab, $ToolTips = "", $iIndex = "")
	If IsArray($ToolTips) Then
		For $i = 1 To UBound($aOwnTab, 1) - 1
			$aOwnTab[$i][5] = $ToolTips[$i - 1]
			GUICtrlSetTip($aOwnTab[$i][0], $ToolTips[$i - 1])
		Next
	Else
		If $iIndex = "" Then Return SetError(1)
		$aOwnTab[$iIndex][5] = $ToolTips
		GUICtrlSetTip($aOwnTab[$iIndex][0], $ToolTips)
	EndIf
EndFunc   ;==>_OwnTab_SetTip

Func _OwnTab_AlarmInit($iTime = 555)
	If Not $hTimerAlarm Then
		$hTimerAlarm = _Timer_SetTimer($hOwnTabGui, $iTime, "_OwnTab_AlarmBlink")
	Else
		$hTimerAlarm = _Timer_SetTimer($hOwnTabGui, $iTime, "", $hTimerAlarm)
	EndIf
EndFunc   ;==>_OwnTab_AlarmInit

Func _OwnTab_AlarmBlink($hWnd, $Msg, $iIDTimer, $dwTime)
	Local $AlarmColAct
	$iOwnTabAlarm = Not $iOwnTabAlarm
	For $i = 1 To UBound($aOwnTabAlarm, 1) - 1
		If $iOwnTabAlarm Then
			$AlarmColAct = $aOwnTabAlarm[$i][2]
		Else
			$AlarmColAct = $aOwnTabAlarm[$i][1]
		EndIf
		GUISetBkColor($AlarmColAct, GUICtrlRead($aOwnTabAlarm[$i][0] + 5))
	Next
EndFunc   ;==>_OwnTab_AlarmBlink

Func _OwnTab_SetAlarm(ByRef $aOwnTab, $iIndex, $nAlarmSel = 0xFF0000)
	Local $hCtrl = $aOwnTab[$iIndex][0]
	Local $iSearch = _ArraySearch($aOwnTabAlarm, $hCtrl)
	If $iSearch <> -1 Then
		$aOwnTabAlarm[$iSearch][2] = $aOwnTab[$iIndex][2]
		Return
	EndIf
	ReDim $aOwnTabAlarm[UBound($aOwnTabAlarm, 1) + 1][3]
	$aOwnTabAlarm[UBound($aOwnTabAlarm, 1) - 1][0] = $hCtrl
	$aOwnTabAlarm[UBound($aOwnTabAlarm, 1) - 1][1] = $nAlarmSel
	$aOwnTabAlarm[UBound($aOwnTabAlarm, 1) - 1][2] = $aOwnTab[$iIndex][2]
EndFunc   ;==>_OwnTab_SetAlarm

Func _OwnTab_ResetAlarm(ByRef $aOwnTab, $iIndex)
	Local $hCtrl = $aOwnTab[$iIndex][0]
	Local $iSearch = _ArraySearch($aOwnTabAlarm, $hCtrl)
	If $iSearch = -1 Then Return
	_ArrayDelete($aOwnTabAlarm, $iSearch)
	$aOwnTab[$iIndex][2] = $aOwnTab[0][2]
	$aOwnTab[$iIndex][3] = $aOwnTab[0][3]
	If $aOwnTab[0][0] <> $iIndex Then
		GUISetBkColor($aOwnTab[0][2], GUICtrlRead($aOwnTab[$iIndex][0] + 5))
	Else
		GUISetBkColor($aOwnTab[0][3], GUICtrlRead($aOwnTab[$iIndex][0] + 5))
		GUICtrlSetBkColor($aOwnTab[$iIndex][1], $aOwnTab[0][3])
	EndIf
EndFunc   ;==>_OwnTab_ResetAlarm

Func _OwnTab_Add(ByRef $aOwnTab)
	Local $i = 0
	While 1
		If $aOwnTab[$i][4] = "" Then ExitLoop
		$i += 1
	WEnd
	$aOwnTab[$i][4] = GUICtrlCreateDummy()
EndFunc   ;==>_OwnTab_Add

Func _OwnTab_End(ByRef $aOwnTab, $iIndex = 1)
	$aOwnTab[UBound($aOwnTab, 1) - 1][4] = GUICtrlCreateDummy()
	_OwnTab_Switch($aOwnTab, $iIndex)
EndFunc   ;==>_OwnTab_End

Func _OwnTab_Hover($aOwnTab, $nColHover, $fSwitch = 0, $iTime = 50)
	$OwnTabHoverCol[0] = $nColHover
	$OwnTabHoverCol[1] = $aOwnTab[0][2]
	$OwnTabHoverSwitch = $fSwitch
	If Not $hTimerHover Then
		$hTimerHover = _Timer_SetTimer($hOwnTabGui, $iTime, "_ProcessHover")
	Else
		$hTimerHover = _Timer_SetTimer($hOwnTabGui, $iTime, "", $hTimerHover)
	EndIf
EndFunc   ;==>_OwnTab_Hover

Func _OwnTab_RegisterHover($aOwnTab, $iIndex)
	If _ArraySearch($HoverArray, $aOwnTab[$iIndex][0]) = -1 Then _HoverAddCtrl($aOwnTab[$iIndex][0])
EndFunc   ;==>_OwnTab_RegisterHover

Func _OwnTab_UnRegisterHover($aOwnTab, $iIndex)
	Local $iSearch = _ArraySearch($HoverArray, $aOwnTab[$iIndex][0])
	If $iSearch <> -1 Then _ArrayDelete($HoverArray, $iSearch)
EndFunc   ;==>_OwnTab_UnRegisterHover

#Region Disable and Enable Tab-Register
Func _OwnTab_Disable($aOwnTab, $iIndex)
	GUICtrlSetState($aOwnTab[$iIndex][0], 128)
	_OwnTab_UnRegisterHover($aOwnTab, $iIndex)
	Local $iSearch = _ArraySearch($OwnTabHoverHelp, $aOwnTab[$iIndex][0])
	If $iSearch = -1 Then _ArrayAdd($OwnTabHoverHelp, $aOwnTab[$iIndex][0])
EndFunc   ;==>_OwnTab_Disable

Func _OwnTab_Enable($aOwnTab, $iIndex)
	GUICtrlSetState($aOwnTab[$iIndex][0], 64)
	_OwnTab_RegisterHover($aOwnTab, $iIndex)
	Local $iSearch = _ArraySearch($OwnTabHoverHelp, $aOwnTab[$iIndex][0])
	If $iSearch <> -1 Then _ArrayDelete($OwnTabHoverHelp, $iSearch)
EndFunc   ;==>_OwnTab_Enable
#EndRegion Disable and Enable Tab-Register

Func _OwnTab_Hide(ByRef $aOwnTab, $iIndex)
	If $iIndex = 0 Or $iIndex > UBound($aOwnTab, 1) - 1 Then Return SetError(1)
	Local $HWnd = HWnd(GUICtrlRead($aOwnTab[$iIndex][0] + 5))
	If Not BitAND(WinGetState($HWnd), 2) Then Return
	GUISetState(@SW_HIDE, $HWnd)
	GUICtrlSetState($aOwnTab[$iIndex][1], 32) ;$GUI_HIDE

	Local $Offset = 3
	For $o = 0 To $iIndex - 1
		$Offset += $aOwnTab[$o][9] - 0
	Next

	For $o = $iIndex + 1 To UBound($aOwnTab, 1) - 1
		WinMove(HWnd(GUICtrlRead($aOwnTab[$o][0] + 5)), "", $Offset, $aOwnTab[0][9])
		GUICtrlSetPos($aOwnTab[$o][1], $Offset + 2, $aOwnTab[0][9] + $aOwnTab[0][1] - 3)
		$Offset += $aOwnTab[$o][9]
	Next
	If $iIndex = $aOwnTab[0][0] Then
		If $iIndex = 1 Then
			_OwnTab_Switch($aOwnTab, 2)
		Else
			_OwnTab_Switch($aOwnTab, $iIndex - 1)
		EndIf
	EndIf
EndFunc   ;==>_OwnTab_Hide

Func _OwnTab_Show(ByRef $aOwnTab, $iIndex, $iActivate = 0)
	If $iIndex = 0 Or $iIndex > UBound($aOwnTab, 1) + 1 Then Return SetError(1)
	Local $HWnd = HWnd(GUICtrlRead($aOwnTab[$iIndex][0] + 5))
	If BitAND(WinGetState($HWnd), 2) Then Return

	Local $Offset = 3
	For $o = 0 To UBound($aOwnTab, 1) - 2
		$Offset += $aOwnTab[$o][9] - 0
	Next

	For $o = UBound($aOwnTab, 1) - 1 To $iIndex + 1 Step -1
		WinMove(HWnd(GUICtrlRead($aOwnTab[$o][0] + 5)), "", $Offset, $aOwnTab[0][9])
		GUICtrlSetPos($aOwnTab[$o][1], $Offset + 2, $aOwnTab[0][9] + $aOwnTab[0][1] - 3)
		$Offset -= $aOwnTab[$o - 1][9]
	Next
	GUISetState(@SW_SHOW, $HWnd)
	If $iActivate Then
		_OwnTab_Switch($aOwnTab, $iIndex)
	EndIf
EndFunc   ;==>_OwnTab_Show

Func _OwnTab_SetFontCol($aOwnTab, $nColor, $iIndex = "")
	If $iIndex = "" Then
		For $i = 1 To UBound($aOwnTab, 1) - 1
			GUICtrlSetColor($aOwnTab[$i][0], $nColor)
		Next
	Else
		If $iIndex < 1 Or $iIndex >= UBound($aOwnTab, 1) Then Return SetError(1)
		GUICtrlSetColor($aOwnTab[$iIndex][0], $nColor)
	EndIf
EndFunc   ;==>_OwnTab_SetFontCol

Func _OwnTab_SetOnEvent($aOwnTab, $sFunc = "", $iIndex = "")
	If $sFunc = "" Then $sFunc = "_OwnTab_OnEvent"
	If $iIndex = "" Then
		For $f = 1 To UBound($aOwnTab, 1) -1
			GUICtrlSetOnEvent($aOwnTab[$f][0], $sFunc)
		Next
	Else
		If $iIndex < 1 Or $iIndex >= UBound($aOwnTab, 1) Then Return SetError(1)
		GUICtrlSetOnEvent($aOwnTab[$iIndex][0], $sFunc)
	EndIf
EndFunc

Func _OwnTab_OnEvent()	;for example
;~ 	For $a = 1 To UBound($aCtrlTab, 1) -1
;~ 		If @GUI_CtrlId = $aCtrlTab[$a][0] Then ExitLoop
;~ 	Next
;~ 	If $a < UBound($aCtrlTab, 1) Then _OwnTab_Switch($aCtrlTab, $a)
EndFunc

Func _OwnTab_Style1($hWnd, $sText, $iX, $iY, $iWidth, $iHeight, $sIcon = "")
	Local $rgn, $rgn2, $rel = $iHeight/5
	Local $hGui = GUICreate("OwnTab", $iWidth, $iHeight, $iX, $iY, 0x40000000, 0, $hWnd)
	$rgn = _WinAPI_CreateRectRgn(0, $rel, $iX + $iWidth, $iY + $iHeight)
	For $i = 0 To $rel - 1
		$rgn2 = _WinAPI_CreateRectRgn($rel - $i, $i, $iWidth - $rel + $i + 1, $i + 1)
		_WinAPI_CombineRgn($rgn, $rgn, $rgn2, $RGN_OR)
		_WinAPI_DeleteObject($rgn2)
	Next
	_WinAPI_SetWindowRgn($hGui, $rgn)
	Local $Label = GUICtrlCreateLabel($sText, 0, 0, $iWidth, $iHeight, 0x201 + ($sIcon <> ""), 1)
	GUICtrlSetBkColor(-1, -2)
	GUISetState()
	Return SetExtended($hGui, $Label)
EndFunc   ;==>_OwnTabCreateTab

Func _OwnTab_Style2($hWnd, $sText, $iX, $iY, $iWidth, $iHeight, $sIcon = "")
	Local $rgn, $rgn2, $rel = $iHeight/5
	Local $hGui = GUICreate("OwnTab", $iWidth, $iHeight, $iX, $iY, 0x40000000, 0, $hWnd)
	Local $Label = GUICtrlCreateLabel($sText, 0, 0, $iWidth, $iHeight, 0x201 + ($sIcon <> ""), 1)
	GUICtrlSetBkColor(-1, -2)
	GUISetState()
	Return SetExtended($hGui, $Label)
EndFunc   ;==>_OwnTabCreateTab

Func _OwnTab_OnExit()
	_GDIPlus_Shutdown()
	If $hTimerAlarm Then _Timer_KillTimer($hOwnTabGui, $hTimerAlarm)
	If $hTimerHover Then _Timer_KillTimer($hOwnTabGui, $hTimerHover)
EndFunc   ;==>_OwnTab_Exit

Func _GetTextSize($nText, $sFont = 'Microsoft Sans Serif', $iFontSize = 8.5, $iFontAttributes = 0)
	;Author: Bugfix
	;Modified: funkey
	If $nText = '' Then Return
;~ 	_GDIPlus_Startup()
	Local $hFormat = _GDIPlus_StringFormatCreate(0)
	Local $hFamily = _GDIPlus_FontFamilyCreate($sFont)
	Local $hFont = _GDIPlus_FontCreate($hFamily, $iFontSize, $iFontAttributes, 3)
	Local $tLayout = _GDIPlus_RectFCreate(15, 171, 0, 0)
	Local $hGraphic = _GDIPlus_GraphicsCreateFromHWND(0)
	Local $aInfo = _GDIPlus_GraphicsMeasureString($hGraphic, $nText, $hFont, $tLayout, $hFormat)
	Local $iWidth = Ceiling(DllStructGetData($aInfo[0], "Width"))
	Local $iHeight = Ceiling(DllStructGetData($aInfo[0], "Height"))
	_GDIPlus_StringFormatDispose($hFormat)
	_GDIPlus_FontDispose($hFont)
	_GDIPlus_FontFamilyDispose($hFamily)
	_GDIPlus_GraphicsDispose($hGraphic)
;~ 	_GDIPlus_Shutdown()
	Local $aSize[2] = [$iWidth, $iHeight]
	Return $aSize
EndFunc   ;==>_GetTextSize

Func _ProcessHover($hWnd, $Msg, $iIDTimer, $dwTime)
	If $OwnTabHoverSwitch > 1 And $OwnTabHoverCtrl <> "" Then
		If $aOwnTabHoverCount < $OwnTabHoverSwitch Then $aOwnTabHoverCount += 1
		If $aOwnTabHoverCount >= $OwnTabHoverSwitch Then
			ControlClick($hOwnTabGui, "", $OwnTabHoverCtrl)
			$aOwnTabHoverCount = 0
			$OwnTabHoverCtrl = ""
		EndIf
	EndIf
	$ControlID = _HoverCheck()
	If IsArray($ControlID) Then
		If $ControlID[0] = "AcquiredHover" Then
			$OwnTabHoverCtrl = $ControlID[1]
			$aOwnTabHoverCount = 0
			If $OwnTabHoverSwitch = "1" Then
				Return ControlClick($hOwnTabGui, "", $OwnTabHoverCtrl)
			Else
				_HoverFound($ControlID[1])
			EndIf
		Else
			If $ControlID[1] <> "" Then
				_HoverLost($ControlID[1])
				$OwnTabHoverCtrl = ""
			EndIf
		EndIf
	EndIf
EndFunc   ;==>_ProcessHover

Func _HoverLost($ControlID)
	If _OwnTab_IsAlarmed($ControlID) Then Return
	GUISetBkColor($OwnTabHoverCol[1], GUICtrlRead($ControlID + 5))
EndFunc   ;==>_HoverLost

Func _HoverFound($ControlID)
	If _OwnTab_IsAlarmed($ControlID) Then Return
	GUISetBkColor($OwnTabHoverCol[0], GUICtrlRead($ControlID + 5))
EndFunc   ;==>_HoverFound

Func _OwnTab_IsAlarmed($hCtrl)
	Local $iSearch = _ArraySearch($aOwnTabAlarm, $hCtrl)
	If $iSearch = -1 Then Return 0
	Return SetExtended($iSearch, 1)
EndFunc

#Region _MouseHover.au3
;====================================================================================================================================
;	UDF Name: _MouseHover.au3
;
;	Author: marfdaman (Marvin)
;
;	Contributions: RazerM (adding SetText parameter to _HoverFound and _HoverUndo).
;
;	email: marfdaman at gmail dot com
;
;	Use: Enable hover events for controls
;
;	Note(s): If you want to use this i.c.w. an AdlibEnable in your current script, make your Adlib call "_HoverCheck()" as well.
;	In this case, _HoverOn must NOT be called.
;====================================================================================================================================


;===============================================================================
; Description:			_HoverAddCtrl
; Parameter(s):		$___ControlID -> Control ID of control to be hoverchecked
;
; Requirement:			Array.au3
; Return Value(s):	None
;===============================================================================
Func _HoverAddCtrl($___ControlID)
	_ArrayAdd($HoverArray, $___ControlID)
EndFunc   ;==>_HoverAddCtrl


;===============================================================================
; Description:			Checks whether the mousecursor is hovering over any of the defined controls.
; Parameter(s):		None
; Requirement:			None
; Return Value(s):	If a control has matched, an array will be returned, with $array[1] being either
;					"AcquiredHover" or "LostHover". $array[2] will contain the control ID.
;					It is recommended that you put this function in an AdlibEnable, since it's EXTREMELY
;					resource friendly.
;===============================================================================
Func _HoverCheck()
	$HoverData = GUIGetCursorInfo($hOwnTabGui)	;modified by funkey for use with OwnTab-UDF
	If Not IsArray($HoverData) Then Return
	$Temp_Found = 0
	For $i = 1 To UBound($HoverArray) - 1
		If $HoverData[4] = $HoverArray[$i] Or $HoverData[4] = $HoverArray[$i] + 1 Then
			$Temp_Found = $i
		EndIf
	Next
	Select
		Case $Temp_Found = 0 And $HoverActive = 1 Or $Temp_Found <> 0 And $Temp_Found <> $Global_I And $HoverActive = 1
			$HoverActive = 0
			$Temp_Found = 0
			$szTemp_Array[0] = "LostHover"
			$szTemp_Array[1] = $HoverArray[$Global_I]
			Return $szTemp_Array
		Case $Temp_Found > 0 And $HoverActive = 0
			$Global_I = $Temp_Found
			$HoverActive = 1
			$Temp_Found = 0
			$szTemp_Array[0] = "AcquiredHover"
			$szTemp_Array[1] = $HoverArray[$Global_I]
			Return $szTemp_Array
	EndSelect
EndFunc   ;==>_HoverCheck
#EndRegion _MouseHover.au3
