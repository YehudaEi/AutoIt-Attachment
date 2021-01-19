#include-once
Opt("MustDeclareVars", 1)
Opt("OnExitFunc", "CallBack_Exit")

;GUICtrlSetOnHover Initialize
Global $HOVER_CONTROLS_ARRAY[1][1]
Global $LAST_HOVERED_ELEMENT[2] = [-1, -1]
Global $LAST_HOVERED_ELEMENT_MARK = -1
Global $pTimerProc = DllCallbackRegister("CALLBACKPROC", "none", "hwnd;uint;uint;dword")
Global $uiTimer = DllCall("user32.dll", "uint", "SetTimer", "hwnd", 0, "uint", 0, "int", 10, "ptr", DllCallbackGetPtr($pTimerProc))
$uiTimer = $uiTimer[0]

Opt("MustDeclareVars", 0)



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
