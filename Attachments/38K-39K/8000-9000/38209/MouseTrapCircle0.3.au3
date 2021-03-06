#Region - TimeStamp
; 2012-07-23 16:52:11   v 0.3
#EndRegion - TimeStamp

#include-once
#Include <WindowsConstants.au3>
#Include <WinAPI.au3>

OnAutoItExitRegister('__MouseTrapCircle_ShutDown')

If Not IsDeclared('$__HC_ACTION') Then Global Const $__HC_ACTION = 0
Global $__hSTUB__MouseProcTrap, $__hMOD_TRAP, $__hHOOK_MOUSE_TRAP
Global $__iXCtr_Trap, $__iYCtr_Trap, $__iRadius_Trap, $__hWND_Trap
Global $__MouseTrapCircle_Started = False, $__Timer_Trap = -1, $__iTimeout_Trap
Global $__iTopBorder, $__iSideBorder
_SystemGetWindowBorder($__iTopBorder, $__iSideBorder)

;===============================================================================
; Function Name....: _MouseTrapCircle
; Description......: Hold the mouse trapped in a circle
; .................: Call without parameters, ends trapping.
; Parameter(s).....: $_iXCentre  x-coordinate of the circle center
; .................: $_iYCentre  y-coordinate of the circle center
; .................: $_iRadius   Radius of the circle
; ........optional.: $_iTimeout  Time in ms after trapping ends, without an function call (Default=-1, no timeout)
; ........optional.: $_hWnd      If given: $_iXCentre and $_iYCentre are used as relative to this window.
; .................:             Default: Coordinates are absolut on screen
; Return Value(s)..: Nothing
; Author(s)........: BugFix ( bugfix@autoit.de )
;===============================================================================
Func _MouseTrapCircle($_iXCentre=-1, $_iYCentre=-1, $_iRadius=-1, $_iTimeout=-1, $_hWnd=-1)
	If $_iXCentre = -1 Or $_iYCentre = -1 Or $_iRadius = -1 Then
		__MouseTrapCircle_ShutDown()
	Else
		__MouseTrapCircle_StartUp($_iXCentre, $_iYCentre, $_iRadius, $_iTimeout, $_hWnd)
	EndIf
EndFunc  ;==>_MouseTrapCircle


#region - Internal functions
;===============================================================================
; Function Name....: __MouseTrapCircle_StartUp
; Description......: Initialize functions
;===============================================================================
Func __MouseTrapCircle_StartUp($_iXCentre, $_iYCentre, $_iRadius, $_iTimeout, $_hWnd)
	$__MouseTrapCircle_Started = True
	$__iXCtr_Trap   = $_iXCentre
	$__iYCtr_Trap   = $_iYCentre
	$__iRadius_Trap = $_iRadius
	$__hWND_Trap    = $_hWnd
	If IsHWnd($__hWND_Trap) Then
		Local $aWin = WinGetPos($__hWND_Trap)
		$__iXCtr_Trap = $aWin[0] + $__iSideBorder + $__iXCtr_Trap
		$__iYCtr_Trap = $aWin[1] + $__iTopBorder + $__iYCtr_Trap
	EndIf
	If $_iTimeout > 0 Then
		$__Timer_Trap = TimerInit()
		$__iTimeout_Trap = $_iTimeout
	EndIf
	; == initialize Callback Function to analyze MOUSE-Message
	$__hSTUB__MouseProcTrap = DllCallbackRegister("__MouseProcTrap", "long", "int;wparam;lparam")
	$__hMOD_TRAP = _WinAPI_GetModuleHandle(0)
	$__hHOOK_MOUSE_TRAP = _WinAPI_SetWindowsHookEx($WH_MOUSE_LL, DllCallbackGetPtr($__hSTUB__MouseProcTrap), $__hMOD_TRAP)
EndFunc  ;==>__MouseTrapCircle_StartUp

;===============================================================================
; Function Name....: __MouseTrapCircle_ShutDown
; Description......: Close ressources
;===============================================================================
Func __MouseTrapCircle_ShutDown()
	If $__MouseTrapCircle_Started Then
		_WinAPI_UnhookWindowsHookEx($__hHOOK_MOUSE_TRAP)
		DllCallbackFree($__hSTUB__MouseProcTrap)
	EndIf
EndFunc  ;==>__MouseTrapCircle_ShutDown

;===============================================================================
; Function Name....: __MouseProcTrap
; Description......: Callback mouse procedure
;===============================================================================
Func __MouseProcTrap($nCode, $wParam, $lParam)
	If $__Timer_Trap <> -1 And TimerDiff($__Timer_Trap) >= $__iTimeout_Trap Then Return __MouseTrapCircle_ShutDown()
	If $nCode <> $__HC_ACTION  Then Return _WinAPI_CallNextHookEx($__hHOOK_MOUSE_TRAP, $nCode, $wParam, $lParam)
	Local Static $iXComp = -1, $iYComp = -1
	Local $iX, $iY, $iXMove, $iYMove, $oldOpt
	Local $iDirX = 0, $iDirY = 0
	Local $tMSLLHOOKSTRUCT = DllStructCreate("int X;int Y;dword mouseData;dword flags;dword time;ulong_ptr dwExtraInfo", $lParam)
	Local $tPoint = DllStructCreate('int;int')
	$iX = DllStructGetData($tMSLLHOOKSTRUCT, 1)
    $iY = DllStructGetData($tMSLLHOOKSTRUCT, 2)
	DllStructSetData($tPoint, 1, $iX)
	DllStructSetData($tPoint, 2, $iY)
	If $iXComp = -1 Then
		$iXComp = $iX
		$iYComp = $iY
	EndIf

	Switch $wParam
		Case $WM_MOUSEMOVE
			If $iX > $iXComp Then
				$iDirX = -1
			ElseIf $iX < $iXComp Then
				$iDirX = 1
			EndIf
			If $iY > $iYComp Then
				$iDirY = -1
			ElseIf $iY < $iYComp Then
				$iDirY = 1
			EndIf
			If Not _PointInCircle($iX, $iY, $__iXCtr_Trap, $__iYCtr_Trap, $__iRadius_Trap) Then
				$oldOpt = Opt('MouseCoordMode', 1)
				MouseMove($iX +($iDirX), $iY +($iDirY), 0)
				If IsHWnd($__hWND_Trap) Then
					Local $tRect = _WinAPI_GetWindowRect($__hWND_Trap)
					If Not _WinAPI_PtInRect($tRect, $tPoint) Then MouseMove($__iXCtr_Trap, $__iYCtr_Trap, 0)
				EndIf
				Opt('MouseCoordMode', $oldOpt)
				Return -1
			EndIf

	EndSwitch

	Return _WinAPI_CallNextHookEx($__hHOOK_MOUSE_TRAP, $nCode, $wParam, $lParam)
EndFunc  ;==>__MouseProcTrap

;===============================================================================
; Function Name....: __PointInCircle
; Description......: Calculates whether given position within a circle
; Author(s)........: BugFix ( bugfix@autoit.de )
;===============================================================================
Func _PointInCircle($_iXPt, $_iYPt, $_iXCircle, $_iYCircle, $_iRadius)
	Return ((Sqrt(($_iXCircle-Abs($_iXPt))^2 + ($_iYCircle-Abs($_iYPt))^2)) < $_iRadius)
EndFunc  ;==>__PointInCircle

;===============================================================================
; Function Name....: __SystemGetWindowBorder
; Description......: Calculates side and top border of window
; Author(s)........: BugFix ( bugfix@autoit.de )
;===============================================================================
Func _SystemGetWindowBorder(ByRef $_iTopBorder, ByRef $_iSideBorder)
	Local Const $SM_CYCAPTION = 4, $SM_CYEDGE = 46, $SM_CYBORDER = 6, $SM_CXBORDER = 5, $SM_CXEDGE = 45
	Local $aMetrics[5][2] = [[$SM_CYCAPTION], [$SM_CYEDGE], [$SM_CYBORDER], [$SM_CXBORDER], [$SM_CXEDGE]]
	Local $dll = DllOpen("user32.dll"), $aRet
	For $i = 0 To 4
		$aRet = DllCall($dll, "int", "GetSystemMetrics", "int", $aMetrics[$i][0])
		If IsArray($aRet) Then $aMetrics[$i][1] = $aRet[0]
	Next
	DllClose($dll)
	$_iTopBorder  = $aMetrics[0][1] + $aMetrics[1][1] + $aMetrics[2][1]
	$_iSideBorder = $aMetrics[3][1] + $aMetrics[4][1]
EndFunc  ;==>__SystemGetWindowBorder
#endregion
