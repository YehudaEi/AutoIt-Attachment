#include-once
#include <WindowsConstants.au3>
;

If Not IsDeclared("WH_MOUSE_LL") 		Then Assign("WH_MOUSE_LL", 			14, 2)

If Not IsDeclared("WM_MOUSEMOVE") 		Then Assign("WM_MOUSEMOVE", 		0x200, 2) ;512
If Not IsDeclared("WM_LBUTTONDOWN") 	Then Assign("WM_LBUTTONDOWN", 		0x201, 2) ;513
If Not IsDeclared("WM_LBUTTONUP") 		Then Assign("WM_LBUTTONUP", 		0x202, 2) ;514
If Not IsDeclared("WM_LBUTTONDBLCLK") 	Then Assign("WM_LBUTTONDBLCLK", 	0x203, 2) ;515
If Not IsDeclared("WM_RBUTTONDOWN") 	Then Assign("WM_RBUTTONDOWN", 		0x204, 2) ;516
If Not IsDeclared("WM_RBUTTONUP") 		Then Assign("WM_RBUTTONUP", 		0x205, 2) ;517
If Not IsDeclared("WM_RBUTTONDBLCLK") 	Then Assign("WM_RBUTTONDBLCLK", 	0x206, 2) ;518
If Not IsDeclared("WM_MBUTTONDOWN") 	Then Assign("WM_MBUTTONDOWN", 		0x207, 2) ;519
If Not IsDeclared("WM_MBUTTONUP") 		Then Assign("WM_MBUTTONUP", 		0x208, 2) ;520
If Not IsDeclared("WM_MBUTTONDBLCLK") 	Then Assign("WM_MBUTTONDBLCLK", 	0x209, 2) ;521
If Not IsDeclared("WM_MOUSEWHEEL") 		Then Assign("WM_MOUSEWHEEL", 		0x20A, 2) ;522
If Not IsDeclared("WM_XBUTTONDOWN") 	Then Assign("WM_XBUTTONDOWN", 		0x20B, 2) ;523
If Not IsDeclared("WM_XBUTTONUP") 		Then Assign("WM_XBUTTONUP", 		0x20C, 2) ;524
If Not IsDeclared("WM_XBUTTONDBLCLK") 	Then Assign("WM_XBUTTONDBLCLK", 	0x20D, 2) ;525

Global Const $MOUSE_MOVE_EVENT				= 0x200 ;512
Global Const $MOUSE_PRIMARYDOWN_EVENT		= 0x201 ;513
Global Const $MOUSE_PRIMARYUP_EVENT			= 0x202 ;514
Global Const $MOUSE_PRIMARYDBLCLK_EVENT		= 0x203 ;515
Global Const $MOUSE_SECONDARYDOWN_EVENT		= 0x204 ;516
Global Const $MOUSE_SECONDARYUP_EVENT		= 0x205 ;517
Global Const $MOUSE_SECONDARYDBLCLK_EVENT	= 0x206 ;518
Global Const $MOUSE_WHEELDOWN_EVENT			= 0x207 ;519
Global Const $MOUSE_WHEELUP_EVENT			= 0x208 ;520
Global Const $MOUSE_WHEELDBLCLK_EVENT		= 0x209 ;521
Global Const $MOUSE_WHEELSCROLL_EVENT		= 0x20A ;522
Global Const $MOUSE_EXTRABUTTONDOWN_EVENT	= 0x20B ;523
Global Const $MOUSE_EXTRABUTTONUP_EVENT		= 0x20C ;524
Global Const $MOUSE_EXTRABUTTONDBLCLK_EVENT	= 0x20D ;525

Global $__MouseSetOnEvent_aEvents[1][1]
Global $__MouseSetOnEvent_hMouseProc 		= -1
Global $__MouseSetOnEvent_hMouseHook 		= -1

; #FUNCTION# ====================================================================================================
; Name...........:	_MouseSetOnEvent
; Description....:	Set an events handler (a hook) for Mouse device.
; Syntax.........:	_MouseSetOnEvent($iEvent, $sFuncName="", $sParam1="", $sParam2="", $hTargetWnd=0, $iBlockDefProc=1)
; Parameters.....:	$iEvent 		- The event to set, here is the list of allowed events:
;										$MOUSE_MOVE_EVENT - Mouse moving.
;										$MOUSE_PRIMARYDOWN_EVENT - Primary mouse button down.
;										$MOUSE_PRIMARYUP_EVENT - Primary mouse button up.
;										$MOUSE_PRIMARYDBLCLK_EVENT - Primary mouse button double click.
;										$MOUSE_SECONDARYDOWN_EVENT - Secondary mouse button down.
;										$MOUSE_SECONDARYUP_EVENT - Secondary mouse button up.
;										$MOUSE_SECONDARYDBLCLK_EVENT - Secondary mouse button double click.
;										$MOUSE_WHEELDOWN_EVENT - Wheel mouse button pressed down.
;										$MOUSE_WHEELUP_EVENT - Wheel mouse button up.
;										$MOUSE_WHEELDBLCLK_EVENT - Wheel mouse button double click.
;										$MOUSE_WHEELSCROLL_EVENT - Wheel mouse scroll.
;										$MOUSE_EXTRABUTTONDOWN_EVENT - Side mouse button down (usualy navigating next/back buttons).
;										$MOUSE_EXTRABUTTONUP_EVENT - Side mouse button up.
;										$MOUSE_EXTRABUTTONDBLCLK_EVENT - Side mouse button double click.
;
;					$sFuncName 		- [Optional] Function name to call when the event is triggered.
;										If this parameter is empty string (""), the function will *unset* the $iEvent.
;					$sParam1 		- [Optional] First parameter to pass to the event function ($sFuncName).
;					$sParam2 		- [Optional] Second parameter to pass to the event function ($sFuncName).
;					$hTargetWnd 	- [Optional] Window handle to set the event for, e.g the event is set only for this window.
;					$iBlockDefProc 	- [Optional] Defines if the event should be blocked (actualy block the mouse action).
;					
; Return values..:	Success 		- Returns 1.
;					Failure 		- Returns 0 on UnSet event mode and when there is no set events yet.
; Author.........:	G.Sandler ((Mr)CreatoR, CreatoR's Lab -                           ,                        )
; Modified.......:	
; Remarks........:	The original events-messages (such as $WM_MOUSEMOVE) can be used as well.
; Related........:	
; Link...........:	http://www.autoitscript.com/forum/index.php?showtopic=64738
; Example........:	Yes.
; ===============================================================================================================
Func _MouseSetOnEvent($iEvent, $sFuncName="", $sParam1="", $sParam2="", $hTargetWnd=0, $iBlockDefProc=1)
	If $sFuncName = "" Then ;Unset Event
		If $__MouseSetOnEvent_aEvents[0][0] < 1 Then Return 0
		Local $aTmp_Mouse_Events[1][1]
		
		For $i = 1 To $__MouseSetOnEvent_aEvents[0][0]
			If $__MouseSetOnEvent_aEvents[$i][0] <> $iEvent Then
				$aTmp_Mouse_Events[0][0] += 1
				ReDim $aTmp_Mouse_Events[$aTmp_Mouse_Events[0][0]+1][6]
				$aTmp_Mouse_Events[$aTmp_Mouse_Events[0][0]][0] = $__MouseSetOnEvent_aEvents[$i][0]
				$aTmp_Mouse_Events[$aTmp_Mouse_Events[0][0]][1] = $__MouseSetOnEvent_aEvents[$i][1]
				$aTmp_Mouse_Events[$aTmp_Mouse_Events[0][0]][2] = $__MouseSetOnEvent_aEvents[$i][2]
				$aTmp_Mouse_Events[$aTmp_Mouse_Events[0][0]][3] = $__MouseSetOnEvent_aEvents[$i][3]
				$aTmp_Mouse_Events[$aTmp_Mouse_Events[0][0]][4] = $__MouseSetOnEvent_aEvents[$i][4]
				$aTmp_Mouse_Events[$aTmp_Mouse_Events[0][0]][5] = $__MouseSetOnEvent_aEvents[$i][5]
			EndIf
		Next
		
		$__MouseSetOnEvent_aEvents = $aTmp_Mouse_Events
		
		If $__MouseSetOnEvent_aEvents[0][0] < 1 Then OnAutoItExit()
		
		Return 1
	EndIf
	
	If $__MouseSetOnEvent_aEvents[0][0] < 1 Then
		$__MouseSetOnEvent_hMouseProc = DllCallbackRegister("__MouseSetOnEvent_MainHandler", "int", "int;ptr;ptr")
		
		Local $hM_Module = DllCall("kernel32.dll", "hwnd", "GetModuleHandle", "ptr", 0)
		
		$__MouseSetOnEvent_hMouseHook = DllCall("user32.dll", "hwnd", "SetWindowsHookEx", "int", Eval("WH_MOUSE_LL"), _
			"ptr", DllCallbackGetPtr($__MouseSetOnEvent_hMouseProc), "hwnd", $hM_Module[0], "dword", 0)
	EndIf
	
	$__MouseSetOnEvent_aEvents[0][0] += 1
	ReDim $__MouseSetOnEvent_aEvents[$__MouseSetOnEvent_aEvents[0][0]+1][6]
	
	$__MouseSetOnEvent_aEvents[$__MouseSetOnEvent_aEvents[0][0]][0] = $iEvent
	$__MouseSetOnEvent_aEvents[$__MouseSetOnEvent_aEvents[0][0]][1] = $sFuncName
	$__MouseSetOnEvent_aEvents[$__MouseSetOnEvent_aEvents[0][0]][2] = $sParam1
	$__MouseSetOnEvent_aEvents[$__MouseSetOnEvent_aEvents[0][0]][3] = $sParam2
	$__MouseSetOnEvent_aEvents[$__MouseSetOnEvent_aEvents[0][0]][4] = $hTargetWnd
	$__MouseSetOnEvent_aEvents[$__MouseSetOnEvent_aEvents[0][0]][5] = $iBlockDefProc
	
	Return 1
EndFunc

Func __MouseSetOnEvent_MainHandler($nCode, $wParam, $lParam)
	Local $iEvent = BitAND($wParam, 0xFFFF)
	Local $iRet
	
	If $__MouseSetOnEvent_aEvents[0][0] < 1 Then
		OnAutoItExit()
		Return 0
	EndIf
	
	For $i = 1 To $__MouseSetOnEvent_aEvents[0][0]
		If $__MouseSetOnEvent_aEvents[$i][0] = $iEvent Then
			If $__MouseSetOnEvent_aEvents[$i][4] <> 0 And _
				Not __MouseSetOnEvent_IsHoveredWnd($__MouseSetOnEvent_aEvents[$i][4]) Then Return 0 ;Allow default processing
			
			$iRet = Call($__MouseSetOnEvent_aEvents[$i][1], $__MouseSetOnEvent_aEvents[$i][2], $__MouseSetOnEvent_aEvents[$i][3])
			If @error Then $iRet = Call($__MouseSetOnEvent_aEvents[$i][1], $__MouseSetOnEvent_aEvents[$i][2])
			If @error Then $iRet = Call($__MouseSetOnEvent_aEvents[$i][1])
			
			If $__MouseSetOnEvent_aEvents[$i][5] = -1 Then Return $iRet
			Return $__MouseSetOnEvent_aEvents[$i][5] ;Block default processing (or not :))
		EndIf
	Next
EndFunc

Func __MouseSetOnEvent_IsHoveredWnd($hWnd)
	Local $iRet = False
	
	Local $aWin_Pos = WinGetPos($hWnd)
	Local $aMouse_Pos = MouseGetPos()
	
	If $aMouse_Pos[0] >= $aWin_Pos[0] And $aMouse_Pos[0] <= ($aWin_Pos[0] + $aWin_Pos[2]) And _
		$aMouse_Pos[1] >= $aWin_Pos[1] And $aMouse_Pos[1] <= ($aWin_Pos[1] + $aWin_Pos[3]) Then $iRet = True
	
	Local $aRet = DllCall("User32.dll", "int", "WindowFromPoint", _
		"long", $aMouse_Pos[0], _
		"long", $aMouse_Pos[1])
	
	;If WinActive($hWnd) Or (HWnd($aRet[0]) <> $hWnd And Not $iRet) Then $iRet = False
	If HWnd($aRet[0]) <> $hWnd And Not $iRet Then $iRet = False
	
	Return $iRet
EndFunc

Func OnAutoItExit()
	If IsArray($__MouseSetOnEvent_hMouseHook) And $__MouseSetOnEvent_hMouseHook[0] > 0 Then
		DllCall("User32.dll", "int", "UnhookWindowsHookEx", "hwnd", $__MouseSetOnEvent_hMouseHook[0])
		$__MouseSetOnEvent_hMouseHook[0] = 0
	EndIf
	
	If IsPtr($__MouseSetOnEvent_hMouseProc) Then
		DllCallbackFree($__MouseSetOnEvent_hMouseProc)
		$__MouseSetOnEvent_hMouseProc = 0
	EndIf
EndFunc
