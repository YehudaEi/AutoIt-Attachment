#include-once
#include <GUIConstants.au3>
#include <Misc.au3>
#include <WindowsConstants.au3>
#include <StaticConstants.au3>
#include <File.au3>
#include <EditConstants.au3>
;FileDelete(@TempDir&'\button.bmp')
;FileDelete(@TempDir&'\leave.bmp')
;FileDelete(@TempDir&'\Titlebar.bmp')
if not FileExists(@TempDir&'\Titlebar.bmp')  Then FileCopy('titlebar.bmp', @TempDir&'\Titlebar.bmp')
If not FileExists(@TempDir&'\button.bmp') then FileCopy('button.bmp', @TempDir&'\button.bmp')
If not FileExists(@TempDir&'\leave.bmp') Then FileCopy('leave.bmp', @TempDir&'\leave.bmp')
Opt("MustDeclareVars", 1)
Opt("OnExitFunc", "CallBack_Exit")

;GUICtrlSetOnHover Initialize
Global $HOVER_CONTROLS_ARRAY[1][1], $DarkLayer, $CustomBox, $Wd = 1, $Ok, $Yes, $No, $Cancel, $Abort, $Retry, $Ignore, $TryAgain, $Continue
Global $LAST_HOVERED_ELEMENT[2] = [-1, -1]
Global $LAST_HOVERED_ELEMENT_MARK = -1
Global $pTimerProc = DllCallbackRegister("CALLBACKPROC", "none", "hwnd;uint;uint;dword")
Global $uiTimer = DllCall("user32.dll", "uint", "SetTimer", "hwnd", 0, "uint", 0, "int", 10, "ptr", DllCallbackGetPtr($pTimerProc))
$uiTimer = $uiTimer[0]
;ClipPut(_ChooseColor(2))
Opt("MustDeclareVars", 0)
Func _CustomInputBox($sTitle, $sText, $sDefault='', $sPasswordChar=0, $Background=1, $x=-1, $y=-1, $TitleColor=0x000000, $TitleSize=20, $TitleWeight=800, $TitleStyle=$SS_CENTER, $TitleFont='Arial', $TextColor=0x000000, $TextSize=15, $TextWeight=800, $TextFont='Arial', $TextStyle=$SS_CENTER)
	if $Background = 1 then
		$DarkLayer = GUICreate($sTitle,@DesktopWidth,@DesktopHeight,0,0,$WS_POPUP,$WS_EX_TOPMOST)
		GUISetBkColor(0x000000)
		WinSetTrans($DarkLayer,"",100)
		GUISetState(@SW_SHOW, $DarkLayer)
	EndIf
	if $Background = 1 then
		$CustomInputBox = GUICreate($sTitle, 500, 280, $x, $y, $WS_POPUPWINDOW, 0, $DarkLayer)
	Else
		$CustomInputBox = GUICreate($sTitle, 500, 280, $x, $y, $WS_POPUPWINDOW)
	EndIf
	GUISetBkColor(0xC7ECF7)
	GUICtrlSetDefBkColor($GUI_BKCOLOR_TRANSPARENT)
	GUICtrlSetDefColor(0xC7ECF7)
	$titlePic = GUICtrlCreatePic(@TempDir&"\titlebar.bmp", 0, 0, 500, 100, $WS_CLIPSIBLINGS, $GUI_WS_EX_PARENTDRAG)
	$txt = GUICtrlCreateLabel($sText, 0, 110, 500, 23, $TextStyle) 
	GUICtrlSetFont(-1, $TextSize, $TextWeight, 0, $TextFont)
	GUICtrlSetColor(-1, $TextColor)
	if $sPasswordChar = 1 then
		$sInput = GUICtrlCreateInput($sDefault, 100, 160, 300, 30, $ES_PASSWORD)
		GUICtrlSetFont(-1, 15, 400, 0, 'Arial')
		GUICtrlSetColor(-1, 0x000000)
	Else
		$sInput = GUICtrlCreateInput($sDefault, 100, 160, 300, 30)
		GUICtrlSetFont(-1, 15, 400, 0, 'Arial')
		GUICtrlSetColor(-1, 0x000000)
	EndIf
	$title = GUICtrlCreateLabel($sTitle, 0, 35, 500, 40, $TitleStyle)
	GUICtrlSetFont(-1, $TitleSize, $TitleWeight, 0, $TitleFont)
	GUICtrlSetColor(-1, $TitleColor)
	GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
	$X = GUICtrlCreateLabel("X", 500-15, 0, 11, 17)
	GUICtrlSetFont(-1, 10, 800, 0, "Comic Sans MS")
	GUICtrlSetColor(-1, 0x000000)
	GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
	GUICtrlSetOnHover($X, '_Hover', '_Leave')
	$Ok = _GUICtrlCreateButton('Ok', 150, 220, 80, 40)
	GUICtrlSetOnHover($Ok, '_GUICtrlButtonSetHover', '_GUICtrlButtonSetLeaveHover')
	$Cancel = _GUICtrlCreateButton('Cancel', 240, 220, 80, 40)
	GUICtrlSetOnHover($Cancel, '_GUICtrlButtonSetHover', '_GUICtrlButtonSetLeaveHover')
	GUISetState()
	While 1
		$msg = GUIGetMsg()
		Switch $msg
			Case $GUI_EVENT_CLOSE
				GUIDelete($DarkLayer)
				GUIDelete($CustomInputBox)
				return 0
				
			Case $X
				GUIDelete($DarkLayer)
				GUIDelete($CustomInputBox)
				return 0
				
			Case $Ok
				$input = GUICtrlRead($sInput)
				GUIDelete($DarkLayer)
				GUIDelete($CustomInputBox)
				return $input
				
			Case $Cancel
				GUIDelete($DarkLayer)
				GUIDelete($CustomInputBox)
				return 0
				
		EndSwitch
	WEnd
EndFunc

Func _CustomBox($sTitle, $sText, $Opt=0, $Background=1, $x=-1, $y=-1, $sButton1='', $sButton2='', $sButton3='', $TitleColor=0x000000, $TitleSize=20, $TitleWeight=800, $TitleStyle=$SS_CENTER, $TitleFont='Arial', $TextColor=0x000000, $TextSize=15, $TextWeight=800, $TextFont='Arial', $TextStyle=$SS_CENTER)
	if $Background = 1 then
		$DarkLayer = GUICreate($sTitle,@DesktopWidth,@DesktopHeight,0,0,$WS_POPUP,$WS_EX_TOPMOST)
		GUISetBkColor(0x000000)
		WinSetTrans($DarkLayer,"",100)
		GUISetState(@SW_SHOW, $DarkLayer)
	EndIf
	if $Background = 1 then
		$CustomBox = GUICreate($sTitle, 500, 280, $x, $y, $WS_POPUPWINDOW, 0, $DarkLayer)
	Else
		$CustomBox = GUICreate($sTitle, 500, 280, $x, $y, $WS_POPUPWINDOW)
	EndIf
	GUISetBkColor(0xC7ECF7)
	GUICtrlSetDefBkColor($GUI_BKCOLOR_TRANSPARENT)
	GUICtrlSetDefColor(0xC7ECF7)
	$titlePic = GUICtrlCreatePic(@TempDir&"\titlebar.bmp", 0, 0, 500, 100, $WS_CLIPSIBLINGS, $GUI_WS_EX_PARENTDRAG)
	$txt = GUICtrlCreateLabel($sText, 0, 110, 500, 110, $TextStyle) 
	GUICtrlSetFont(-1, $TextSize, $TextWeight, 0, $TextFont)
	GUICtrlSetColor(-1, $TextColor)
	$title = GUICtrlCreateLabel($sTitle, 0, 35, 500, 40, $TitleStyle)
	GUICtrlSetFont(-1, $TitleSize, $TitleWeight, 0, $TitleFont)
	GUICtrlSetColor(-1, $TitleColor)
	GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
	$X = GUICtrlCreateLabel("X", 500-15, 0, 11, 17)
	GUICtrlSetFont(-1, 10, 800, 0, "Comic Sans MS")
	GUICtrlSetColor(-1, 0x000000)
	GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
	GUICtrlSetOnHover($X, '_Hover', '_Leave')
	if $Opt = 0 then
		if $sButton1 <> '' then
			$Ok = _GUICtrlCreateButton($sButton1, 205, 220, 80, 40)
		Else
			$Ok = _GUICtrlCreateButton('Ok', 205, 220, 80, 40)
		EndIf
		GUICtrlSetOnHover($Ok, '_GUICtrlButtonSetHover', '_GUICtrlButtonSetLeaveHover')
	ElseIf $Opt = 1 Then
		if $sButton1 <> '' then
			$Ok = _GUICtrlCreateButton($sButton1, 150, 220, 80, 40)
		Else
			$Ok = _GUICtrlCreateButton('Ok', 150, 220, 80, 40)
		EndIf
		GUICtrlSetOnHover($Ok, '_GUICtrlButtonSetHover', '_GUICtrlButtonSetLeaveHover')
		if $sButton2 <> '' then
			$Cancel = _GUICtrlCreateButton($sButton2, 240, 220, 80, 40)
		Else
			$Cancel = _GUICtrlCreateButton('Cancel', 240, 220, 80, 40)
		EndIf
		GUICtrlSetOnHover($Cancel, '_GUICtrlButtonSetHover', '_GUICtrlButtonSetLeaveHover')
	ElseIf $Opt = 2 Then
		if $sButton1 <> '' then
			$Abort = _GUICtrlCreateButton($sButton1, 120, 220, 80, 40)
		Else
			$Abort = _GUICtrlCreateButton('Abort', 120, 220, 80, 40)
		EndIf
		GUICtrlSetOnHover($Abort, '_GUICtrlButtonSetHover', '_GUICtrlButtonSetLeaveHover')
		if $sButton2 <> '' then
			$Retry = _GUICtrlCreateButton($sButton2, 210, 220, 80, 40)
		Else
			$Retry = _GUICtrlCreateButton('Retry', 210, 220, 80, 40)
		EndIf
		GUICtrlSetOnHover($Retry, '_GUICtrlButtonSetHover', '_GUICtrlButtonSetLeaveHover')
		if $sButton3 <> '' then
			$Ignore = _GUICtrlCreateButton($sButton3, 300, 220, 80, 40)
		Else
			$Ignore = _GUICtrlCreateButton('Ignore', 300, 220, 80, 40)
		EndIf
		GUICtrlSetOnHover($Ignore, '_GUICtrlButtonSetHover', '_GUICtrlButtonSetLeaveHover')
	ElseIf $Opt = 3 Then
		if $sButton1 <> '' then
			$Yes = _GUICtrlCreateButton($sButton1, 120, 220, 80, 40)
		Else
			$Yes = _GUICtrlCreateButton('Yes', 120, 220, 80, 40)
		EndIf
		GUICtrlSetOnHover($Yes, '_GUICtrlButtonSetHover', '_GUICtrlButtonSetLeaveHover')
		if $sButton2 <> '' then
			$No = _GUICtrlCreateButton($sButton2, 210, 220, 80, 40)
		Else
			$No = _GUICtrlCreateButton('No', 210, 220, 80, 40)
		EndIf
		GUICtrlSetOnHover($No, '_GUICtrlButtonSetHover', '_GUICtrlButtonSetLeaveHover')
		if $sButton3 <> '' then
			$Cancel = _GUICtrlCreateButton($sButton3, 300, 220, 80, 40)
		Else
			$Cancel = _GUICtrlCreateButton('Cancel', 300, 220, 80, 40)
		EndIf
		GUICtrlSetOnHover($Cancel, '_GUICtrlButtonSetHover', '_GUICtrlButtonSetLeaveHover')
	ElseIf $Opt = 4 Then
		if $sButton1 <> '' then
			$Yes = _GUICtrlCreateButton($sButton1, 150, 220, 80, 40)
		Else
			$Yes = _GUICtrlCreateButton('Yes', 150, 220, 80, 40)
		EndIf
		GUICtrlSetOnHover($Yes, '_GUICtrlButtonSetHover', '_GUICtrlButtonSetLeaveHover')
		if $sButton2 <> '' then
			$No = _GUICtrlCreateButton($sButton2, 240, 220, 80, 40)
		Else
			$No = _GUICtrlCreateButton('No', 240, 220, 80, 40)
		EndIf
		GUICtrlSetOnHover($No, '_GUICtrlButtonSetHover', '_GUICtrlButtonSetLeaveHover')
	ElseIf $Opt = 5 Then
		if $sButton1 <> '' then
			$Retry = _GUICtrlCreateButton($sButton1, 150, 220, 80, 40)
		Else
			$Retry = _GUICtrlCreateButton('Retry', 150, 220, 80, 40)
		EndIf
		GUICtrlSetOnHover($Retry, '_GUICtrlButtonSetHover', '_GUICtrlButtonSetLeaveHover')
		if $sButton2 <> '' then
			$Cancel = _GUICtrlCreateButton($sButton2, 240, 220, 80, 40)
		Else
			$Cancel = _GUICtrlCreateButton('Cancel', 240, 220, 80, 40)
		EndIf
		GUICtrlSetOnHover($Cancel, '_GUICtrlButtonSetHover', '_GUICtrlButtonSetLeaveHover')
	ElseIf $Opt = 6 Then
		if $sButton1 <> '' then
			$Cancel = _GUICtrlCreateButton($sButton1, 120, 220, 80, 40)
		Else
			$Cancel = _GUICtrlCreateButton('Cancel', 120, 220, 80, 40)
		EndIf
		GUICtrlSetOnHover($Cancel, '_GUICtrlButtonSetHover', '_GUICtrlButtonSetLeaveHover')
		if $sButton2 <> '' then
			$TryAgain = _GUICtrlCreateButton($sButton2, 210, 220, 80, 40)
		Else
			$TryAgain = _GUICtrlCreateButton('Try Again', 210, 220, 80, 40)
		EndIf
		GUICtrlSetOnHover($TryAgain, '_GUICtrlButtonSetHover', '_GUICtrlButtonSetLeaveHover')
		if $sButton3 <> '' then
			$Continue = _GUICtrlCreateButton('Continue', 300, 220, 80, 40)
		Else
			$Continue = _GUICtrlCreateButton('Continue', 300, 220, 80, 40)
		EndIf
		GUICtrlSetOnHover($Continue, '_GUICtrlButtonSetHover', '_GUICtrlButtonSetLeaveHover')
	EndIf
	GUISetState(@SW_SHOW, $CustomBox)
	While 1
		$msg = GUIGetMsg()
		Switch $msg
			Case $GUI_EVENT_CLOSE
				GUIDelete($DarkLayer)
				GUIDelete($CustomBox)
				return 0
				
			Case $X
				GUIDelete($DarkLayer)
				GUIDelete($CustomBox)
				return 0
				
			Case $Ok
				if $Opt = 0 or $Opt = 1 then
					GUIDelete($DarkLayer)
					GUIDelete($CustomBox)
					return 1
				EndIf
				
			Case $Yes
				if $Opt = 3 or $Opt = 4 Then
					GUIDelete($DarkLayer)
					GUIDelete($CustomBox)
					return 6
				EndIf
				
			Case $No
				if $Opt = 3 or $Opt = 4 Then
					GUIDelete($DarkLayer)
					GUIDelete($CustomBox)
					return 7
				EndIf
				
			Case $Cancel
				if $Opt = 1 or $Opt = 3 or $Opt = 5 or $Opt = 6 Then
					GUIDelete($DarkLayer)
					GUIDelete($CustomBox)
					return 2
				EndIf
				
			Case $Abort
				if $Opt = 2 then
					GUIDelete($DarkLayer)
					GUIDelete($CustomBox)
					return 3
				EndIf
				
			Case $Retry
				if $Opt = 2 or $Opt = 5 then
					GUIDelete($DarkLayer)
					GUIDelete($CustomBox)
					return 4
				EndIf
			
			Case $Ignore
				if $Opt = 2 then
					GUIDelete($DarkLayer)
					GUIDelete($CustomBox)
					return 5
				EndIf
				
			Case $TryAgain
				if $Opt = 6 then
					GUIDelete($DarkLayer)
					GUIDelete($CustomBox)
					return 10
				EndIf
				
			Case $Continue
				if $Opt = 6 then
					GUIDelete($DarkLayer)
					GUIDelete($CustomBox)
					return 11
				EndIf
				
		EndSwitch
	WEnd
EndFunc

Func _Hover($CtrlID)
	GUICtrlSetColor($CtrlID, 0xF4BE1C)
EndFunc

Func _Leave($CtrlID)
	GUICtrlSetColor($CtrlID, 0x000000)
EndFunc

Func _GUICtrlCreateButton($text, $x, $y, $width, $height)
	$ret = GUICtrlCreatePic(@TempDir&'\Leave.bmp', $x, $y, $width+10, $height+10)
	GUICtrlCreateLabel($text, $x+6, $y+15, $width, $height, $SS_CENTER)
	GUICtrlSetFont(-1, 12, 800)
	GUICtrlSetColor(-1, 0x000000)
	return $ret
EndFunc

Func _GUICtrlButtonSetHover($CtrlID)
	GUICtrlSetImage($CtrlID, @TempDir&'\Button.bmp')
EndFunc

Func _GUICtrlButtonSetLeaveHover($CtrlID)
	GUICtrlSetImage($CtrlID, @TempDir&'\leave.bmp')
EndFunc

;===============================================================================
;
; Function Name:    GUICtrlSetOnHover()
; Description:      Set function(s) to call when hovering/leave hovering GUI elements.
; Parameter(s):     $CtrlID - The Ctrl ID to set hovering for (can be a -1 as indication to the last item created).
;                   $HoverFuncName - Function to call when the mouse is hovering the control.
;                   $LeaveHoverFuncName - [Optional] Function to call when the mouse is leaving hovering the control
;                       (-1 no function used).
;
; Return Value(s):  Always returns 1 regardless of success.
; Requirement(s):   AutoIt 3.2.10.0
; Note(s):          1) TreeView/ListView Items can not be set :(.
;                   2) When the window is not active, the hover/leave hover functions will still called,
;                      but not when the window is disabled.
;                   3) The hover/leave hover functions will be called even if the script is paused by such functions as MsgBox().
; Author(s):        G.Sandler (a.k.a CreatoR).
;
;===============================================================================
Func GUICtrlSetOnHover($CtrlID, $HoverFuncName, $LeaveHoverFuncName=-1)
	Local $Ubound = UBound($HOVER_CONTROLS_ARRAY)
	ReDim $HOVER_CONTROLS_ARRAY[$Ubound+1][3]
	$HOVER_CONTROLS_ARRAY[$Ubound][0] = GUICtrlGetHandle($CtrlID)
	$HOVER_CONTROLS_ARRAY[$Ubound][1] = $HoverFuncName
	$HOVER_CONTROLS_ARRAY[$Ubound][2] = $LeaveHoverFuncName
	$HOVER_CONTROLS_ARRAY[0][0] = $Ubound
EndFunc

;CallBack function to handle the hovering process
Func CALLBACKPROC($hWnd, $uiMsg, $idEvent, $dwTime)
	If UBound($HOVER_CONTROLS_ARRAY)-1 < 1 Then Return
	Local $ControlGetHovered = _ControlGetHovered()
	Local $sCheck_LHE = $LAST_HOVERED_ELEMENT[1]
	
	If $ControlGetHovered = 0 Or ($sCheck_LHE <> -1 And $ControlGetHovered <> $sCheck_LHE) Then
		If $LAST_HOVERED_ELEMENT_MARK = -1 Then Return
		If $LAST_HOVERED_ELEMENT[0] <> -1 Then Call($LAST_HOVERED_ELEMENT[0], $LAST_HOVERED_ELEMENT[1])
		$LAST_HOVERED_ELEMENT[0] = -1
		$LAST_HOVERED_ELEMENT[1] = -1
		$LAST_HOVERED_ELEMENT_MARK = -1
	Else
		For $i = 1 To $HOVER_CONTROLS_ARRAY[0][0]
			If $HOVER_CONTROLS_ARRAY[$i][0] = GUICtrlGetHandle($ControlGetHovered) Then
				If $LAST_HOVERED_ELEMENT_MARK = $HOVER_CONTROLS_ARRAY[$i][0] Then ExitLoop
				$LAST_HOVERED_ELEMENT_MARK = $HOVER_CONTROLS_ARRAY[$i][0]
				Call($HOVER_CONTROLS_ARRAY[$i][1], $ControlGetHovered)
				If $HOVER_CONTROLS_ARRAY[$i][2] <> -1 Then
					$LAST_HOVERED_ELEMENT[0] = $HOVER_CONTROLS_ARRAY[$i][2]
					$LAST_HOVERED_ELEMENT[1] = $ControlGetHovered
				EndIf
				ExitLoop
			EndIf
		Next
	EndIf
EndFunc

;Thanks to amel27 for that one!!!
Func _ControlGetHovered()
	Local $Old_Opt_MCM = Opt("MouseCoordMode", 1)
	Local $iRet = DllCall("user32.dll", "int", "WindowFromPoint", _
		"long", MouseGetPos(0), _
		"long", MouseGetPos(1))
	$iRet = DllCall("user32.dll", "int", "GetDlgCtrlID", "hwnd", $iRet[0])
	Opt("MouseCoordMode", $Old_Opt_MCM)
	Return $iRet[0]
EndFunc

;Release the CallBack resources
Func CallBack_Exit()
	DllCallbackFree($pTimerProc)
	DllCall("user32.dll", "int", "KillTimer", "hwnd", 0, "uint", $uiTimer)
EndFunc