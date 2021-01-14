#Include-once
#include <GUIConstants.au3>

Opt("GUIOnEventMode", 1) 

Local Const $DebugIt = 1 ;Used for the double click
Local Const $STN_DBLCLK = 1 ;Used for the double click
Local $toolbar_Speed ;The speed at which the GUI hides and shows
Local $toolbar_Snap ;The distance between the edge and the window before the window snaps to the side
Local $toolbar_Window ;The handle of the window (I think handle is the right term
Local $toolbar_Hide = False
Local $toolbar_Snapped = False
Local $toolbar_MousePos
Local $toolbar_OldMousePos[2] = [-1, -1]
Local $toolbar_DragControls[1]

Local $toolbar_Moving[2] = [False, False]

;Func _Setup_Toolbar - By Piano_Man
;	$windowHandle = The handle of the window 
;	$speed = The speed at which the window hides/shows 
;	$snap = The snap distance
Func _Setup_ToolBar($windowHandle, $speed = 500, $snap = 0)
	$toolbar_Window = $windowHandle
	$toolbar_Speed = $speed
	$toolbar_Snap = $snap
	GUIRegisterMsg(0x0111, 'MY_WM_COMMAND')
EndFunc 

Func _Add_Control($ctrl) 
	ReDim $toolbar_DragControls[UBound($toolbar_DragControls) + 1]
	$toolbar_DragControls[UBound($toolbar_DragControls) - 1] = $ctrl
EndFunc 

Func _Toolbar_Handler() 
	If $toolbar_Hide = False then 	
		If $toolbar_Moving[0] = True then
			AdLibDisable()
		Else
			Opt('MouseCoordMode', 0)
			$toolbar_MousePos = MouseGetPos()
			Opt('MouseCoordMode', 1)
			AdLibEnable('_WinTrapWithSnap', 20)
		EndIf
		$toolbar_Moving[0]= Not $toolbar_Moving[0]
	Else
		If $toolbar_Moving[1] = True then 
			AdLibDisable() 
		Else 
			Opt('MouseCoordMode', 0)
			$toolbar_MousePos = MouseGetPos()
			Opt('MouseCoordMode', 1)
			AdLibEnable('_MoveSideWindow', 20)
		EndIf 
		$toolbar_Moving[1]= Not $toolbar_Moving[1]
	EndIf
EndFunc 

Func MY_WM_COMMAND($hWnd, $msg, $wParam, $lParam)
	Local $nNotifyCode = BitShift($wParam, 16)
	Local $nID = BitAND($wParam, 0xFFFF)
    Local $hCtrl = $lParam

	If $toolbar_Snapped > 0 Then
		$pass = False
		For $a = 1 to UBound($toolbar_DragControls) - 1 
			If $nID = $toolbar_DragControls[$a] then 
				$pass = True
			EndIf
		Next 
		If $pass = False then 
			Return
		Else
			If $nNotifyCode = $STN_DBLCLK then 
				AdLibDisable()
				If $toolbar_Hide = True then 
					_ShowToolbar() 
					$toolbar_Moving[1] = False
				Else 
					_HideToolbar()
					$toolbar_Moving[0] = False
				EndIf
				$toolbar_Hide = Not $toolbar_Hide
				Return
			EndIf 
		EndIf
	EndIf

    Return $GUI_RUNDEFMSG
EndFunc

Func _WinTrapWithSnap()
    $pos = MouseGetPos()
	If $pos[0] = $toolbar_OldMousePos[0] and $pos[1] = $toolbar_OldMousePos[1] then Return
	
	$winPos = WinGetPos($toolbar_Window)
	$toolbar_Snapped = 0
	If @Error = 1 then Return
	
    If $pos[0] - $toolbar_MousePos[0] < $toolbar_Snap Then
        $x = 0
		$toolbar_Snapped += 1
    ElseIf $winPos[2] - $toolbar_MousePos[0] + $pos[0] > @DesktopWidth - $toolbar_Snap Then
        $x = @DesktopWidth - $winPos[2]
		$toolbar_Snapped += 3
    Else
        $x = $pos[0] - $toolbar_MousePos[0]
    EndIf

    If $pos[1] - $toolbar_MousePos[1] < $toolbar_Snap Then
        $y = 0
		$toolbar_Snapped += 10
    ElseIf $winPos[3] - $toolbar_MousePos[1] + $pos[1] > @DesktopHeight - $toolbar_Snap Then
        $y = @DesktopHeight - $winPos[3]
		$toolbar_Snapped += 15
    Else
        $y = $pos[1] - $toolbar_MousePos[1]
    EndIf

	If $toolbar_Snapped = 1 or $toolbar_Snapped = 11 or $toolbar_Snapped = 16 then $toolbar_Snapped = 1 
	If $toolbar_Snapped = 3 or $toolbar_Snapped = 13 or $toolbar_Snapped = 18 then $toolbar_Snapped = 3
	
	If $toolbar_Snapped = 10 then $toolbar_Snapped = 2
	If $toolbar_Snapped = 15 then $toolbar_Snapped = 4
	
    WinMove($toolbar_Window, '', $x, $y)
	$toolbar_OldMousePos = $pos

EndFunc

Func _MoveSideWindow()
    $pos = MouseGetPos()
	If $pos[0] = $toolbar_OldMousePos[0] and $pos[1] = $toolbar_OldMousePos[1] then Return
	
    $winPos = WinGetPos($toolbar_Window)
	If @Error = 1 then Return
		
	If $toolbar_Snapped = 2 or $toolbar_Snapped = 4 then 
		If $pos[0] - $toolbar_MousePos[0] < 0 then 
			$x = 0
		ElseIf $pos[0] - $toolbar_MousePos[0] > @DesktopWidth - $winPos[2] then 
			$x = @DesktopWidth - $winPos[2] 
		Else
			$x = $pos[0] - $toolbar_MousePos[0]
		EndIf
		WinMove($toolbar_Window, '', $x, $winPos[1])
	Else	
		If $pos[1] - $toolbar_MousePos[1] < 0 then 
			$y = 0
		ElseIf $pos[1] - $toolbar_MousePos[1] > @Desktopheight - $winPos[3] then 
			$y = @DesktopHeight - $winPos[3] 
		Else 
			$y = $pos[1] - $toolbar_MousePos[1]
		EndIf 
		WinMove($toolbar_Window, '', $winPos[0], $y)
	EndIf 

	$toolbar_OldMousePos = $pos
EndFunc

Func _ShowToolbar()
	$position = WinGetPos($toolbar_Window)
	Switch $toolbar_Snapped
		Case 1
			DllCall("user32.dll", "int", "AnimateWindow", "hwnd", $toolbar_Window, "int", $toolbar_Speed, "long", 0x00050002);slide out to left
			WinMove($toolbar_Window, '', $position[0] + $position[2] - 6 , $position[1])
			DllCall("user32.dll", "int", "AnimateWindow", "hwnd", $toolbar_Window, "int", $toolbar_Speed, "long", 0x00040001);slide in from left
		Case 2
			DllCall("user32.dll", "int", "AnimateWindow", "hwnd", $toolbar_Window, "int", $toolbar_Speed , "long", 0x00050008);slide-out to top
			WinMove($toolbar_Window, '', $position[0], $position[1] + $position[3] - 6)
			DllCall("user32.dll", "int", "AnimateWindow", "hwnd", $toolbar_Window, "int", $toolbar_Speed, "long", 0x00040004);slide-in from top
		Case 3
			DllCall("user32.dll", "int", "AnimateWindow", "hwnd", $toolbar_Window, "int", $toolbar_Speed, "long", 0x00050001);slide out to right
			WinMove($toolbar_Window, '', @DesktopWidth - $position[2], $position[1])
			DllCall("user32.dll", "int", "AnimateWindow", "hwnd", $toolbar_Window, "int", $toolbar_Speed, "long", 0x00040002);slide in from right
		Case 4
			DllCall("user32.dll", "int", "AnimateWindow", "hwnd", $toolbar_Window, "int", $toolbar_Speed, "long", 0x00050004);slide-out to bottom
			WinMove($toolbar_Window, '', $position[0], @DesktopHeight - $position[3])
			DllCall("user32.dll", "int", "AnimateWindow", "hwnd", $toolbar_Window, "int", $toolbar_Speed, "long", 0x00040008);slide-in from bottom
	EndSwitch	
EndFunc 

Func _HideToolbar() 
	$position = WinGetPos($toolbar_Window)
	Switch $toolbar_Snapped
		Case 1
			DllCall("user32.dll", "int", "AnimateWindow", "hwnd", $toolbar_Window, "int", $toolbar_Speed, "long", 0x00050002);slide out to left
			WinMove($toolbar_Window, '', 6 - $position[2] , $position[1])
			DllCall("user32.dll", "int", "AnimateWindow", "hwnd", $toolbar_Window, "int", $toolbar_Speed, "long", 0x00040001);slide in from left
		Case 2
			DllCall("user32.dll", "int", "AnimateWindow", "hwnd", $toolbar_Window, "int", $toolbar_Speed, "long", 0x00050008);slide-out to top
			WinMove($toolbar_Window, '', $position[0], 6 - $position[3])
			DllCall("user32.dll", "int", "AnimateWindow", "hwnd", $toolbar_Window, "int", $toolbar_Speed, "long", 0x00040004);slide-in from top
		Case 3
			DllCall("user32.dll", "int", "AnimateWindow", "hwnd", $toolbar_Window, "int", $toolbar_Speed, "long", 0x00050001);slide out to right
			WinMove($toolbar_Window, '', @DesktopWidth - 6, $position[1])
			DllCall("user32.dll", "int", "AnimateWindow", "hwnd", $toolbar_Window, "int", $toolbar_Speed, "long", 0x00040002);slide in from right
		Case 4
			DllCall("user32.dll", "int", "AnimateWindow", "hwnd", $toolbar_Window, "int", $toolbar_Speed, "long", 0x00050004);slide-out to bottom
			WinMove($toolbar_Window, '', $position[0], @DesktopHeight - 6)
			DllCall("user32.dll", "int", "AnimateWindow", "hwnd", $toolbar_Window, "int", $toolbar_Speed, "long", 0x00040008);slide-in from bottom
	EndSwitch	
EndFunc