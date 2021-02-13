;#NoTrayIcon
#include <Misc.au3>
#include <WinAPI.au3>
#include <Constants.au3>

Opt("WinWaitDelay", 0)

If @OSBuild > 6800 Then
	MsgBox(64, "Info", "You don't need to run this script. It is already a build in behavior of your Windows.")
	Exit
EndIf

#region Setting
Global $With_Preview = 1
HotKeySet("{Esc}", "_Exit")
#endregion Setting

HotKeySet("#{up}", "_up")
HotKeySet("#{down}", "_down")
HotKeySet("#{left}", "_left")
HotKeySet("#{right}", "_right")

Global $dll = DllOpen("user32.dll")
Global $hwnd, $MousePos[2], $MousePos_old[2], $aPos
Global $y = _WinAPI_GetSystemMetrics(31)
Global $VirtualDesktopWidth = _WinAPI_GetSystemMetrics(78)
Global $VirtualDesktopHeight = _WinAPI_GetSystemMetrics(79)
Global $TaskBarHeight = WinGetPos("[Class:Shell_TrayWnd]")
$TaskBarHeight = @DesktopHeight - $TaskBarHeight[1]

If $With_Preview Then
	Global $hGui = GUICreate("Preview", @DesktopWidth, @DesktopHeight - $TaskBarHeight, 0, 0, 0x80000000, 0x000800A9)
	GUISetBkColor(0xABCDEF)
	_WinAPI_SetLayeredWindowAttributes($hGui, 0xABCDEF, 255)
EndIf

While 1
	Sleep(10)
	If _IsPressed(01, $dll) Then
		$hwnd = WinActive("")
		$MousePos = MouseGetPos()
		If Not _IsSizeable($hwnd) Then
		ElseIf $MousePos[1] < $y And $MousePos_old[1] < $MousePos[1] Then ;RESTORE
			If WinGetState($hwnd) = 47 Then
				Do
					Sleep(10)
					$MousePos = MouseGetPos()
				Until $MousePos[1] > $y
				If _IsPressed(01, $dll) Then
					WinSetState($hwnd, "", @SW_RESTORE)
					$MousePos = MouseGetPos()
					$aPos = WinGetPos($hwnd)
					WinMove($hwnd, "", $MousePos[0] - $aPos[2] / 2, $MousePos[1] - $y / 2)
					MouseUp("primary")
					MouseDown("primary")
				EndIf
			EndIf
		ElseIf $MousePos[1] = 0 And $MousePos_old[1] > 0 Then ;MAXIMIZE
			If WinGetState($hwnd) = 15 Then
				If $With_Preview Then
					If $MousePos[0] > @DesktopWidth Then
						WinMove($hGui, "", @DesktopWidth, 0, $VirtualDesktopWidth - @DesktopWidth, @DesktopHeight)
					Else
						WinMove($hGui, "", 0, 0, @DesktopWidth, @DesktopHeight - $TaskBarHeight)
					EndIf
					GUISetState(@SW_SHOWNOACTIVATE, $hGui)
				EndIf
				While 1
					Sleep(10)
					$MousePos = MouseGetPos()
					If $MousePos[1] > 0 Then
						If $With_Preview Then
							GUISetState(@SW_HIDE, $hGui)
						EndIf
						ExitLoop
					ElseIf Not _IsPressed(01) Then
						WinSetState($hwnd, "", @SW_MAXIMIZE)
						If $With_Preview Then GUISetState(@SW_HIDE, $hGui)
						ExitLoop
					EndIf
				WEnd
			EndIf
		ElseIf $MousePos[0] = 0 And $MousePos_old[0] > 0 Then ;LEFT HALF
			If WinGetState($hwnd) = 15 Then
				If $With_Preview Then
					WinMove($hGui, "", 0, 0, @DesktopWidth / 2, @DesktopHeight - $TaskBarHeight)
					GUISetState(@SW_SHOWNOACTIVATE, $hGui)
				EndIf
				While 1
					Sleep(10)
					$MousePos = MouseGetPos()
					If $MousePos[0] > 0 Then
						If $With_Preview Then
							GUISetState(@SW_HIDE, $hGui)
						EndIf
						ExitLoop
					ElseIf Not _IsPressed(01) Then
						WinMove($hwnd, "", 0, 0, @DesktopWidth / 2, @DesktopHeight - $TaskBarHeight)
						If $With_Preview Then GUISetState(@SW_HIDE, $hGui)
						ExitLoop
					EndIf
				WEnd
			EndIf
		ElseIf $MousePos[0] = $VirtualDesktopWidth - 1 And $MousePos_old[0] < $VirtualDesktopWidth - 1 Then ;RIGHT HALF
			If WinGetState($hwnd) = 15 Then
				If $With_Preview Then
					WinMove($hGui, "", @DesktopWidth / 2, 0, @DesktopWidth / 2, @DesktopHeight - $TaskBarHeight)
					GUISetState(@SW_SHOWNOACTIVATE, $hGui)
				EndIf
				While 1
					Sleep(10)
					$MousePos = MouseGetPos()
					If $MousePos[0] < $VirtualDesktopWidth - 1 Then
						If $With_Preview Then
							GUISetState(@SW_HIDE, $hGui)
						EndIf
						ExitLoop
					ElseIf Not _IsPressed(01) Then
						WinMove($hwnd, "", @DesktopWidth / 2, 0, @DesktopWidth / 2, @DesktopHeight - $TaskBarHeight)
						If $With_Preview Then GUISetState(@SW_HIDE, $hGui)
						ExitLoop
					EndIf
				WEnd
			EndIf
		EndIf
		$MousePos_old = $MousePos
	EndIf
WEnd

Func _Exit()
	Exit
EndFunc   ;==>_Exit

Func _Up()
	Local $WinHandle = WinActive("")
	If Not _IsSizeable($WinHandle) Then Return
	WinSetState($WinHandle, "", @SW_MAXIMIZE)
EndFunc

Func _Down()
	Local $WinHandle = WinActive("")
	If Not _IsSizeable($WinHandle) Then Return
	If WinGetState($WinHandle) = 47 Then
		WinSetState($WinHandle, "", @SW_RESTORE)
	Else
		WinSetState($WinHandle, "", @SW_MINIMIZE)
	EndIf
EndFunc

Func _Left()
	Local $WinHandle = WinActive("")
	If Not _IsSizeable($WinHandle) Then Return
	Local $WinPos = WinGetPos($WinHandle)
	If $VirtualDesktopWidth = @DesktopWidth Or $WinPos[0] + $WinPos[2]/2 < @DesktopWidth Then
		WinSetState($WinHandle, "", @SW_RESTORE)
		WinMove($WinHandle, "", 0, 0, @DesktopWidth / 2, @DesktopHeight - $TaskBarHeight)
	Else
		WinSetState($WinHandle, "", @SW_RESTORE)
		WinMove($WinHandle, "", @DesktopWidth, 0, @DesktopWidth / 2, @DesktopHeight)
	EndIf
EndFunc

Func _Right()
	Local $WinHandle = WinActive("")
	If Not _IsSizeable($WinHandle) Then Return
	Local $WinPos = WinGetPos($WinHandle)
	If $VirtualDesktopWidth = @DesktopWidth Or $WinPos[0] + $WinPos[2]/2 < @DesktopWidth Then
		WinSetState($WinHandle, "", @SW_RESTORE)
		WinMove($WinHandle, "", @DesktopWidth / 2, 0, @DesktopWidth / 2, @DesktopHeight - $TaskBarHeight)
	Else
		WinSetState($WinHandle, "", @SW_RESTORE)
		WinMove($WinHandle, "", $VirtualDesktopWidth - @DesktopWidth / 2, 0, @DesktopWidth / 2, @DesktopHeight)
	EndIf
EndFunc

Func _IsSizeable($hWnd)
	Local $Style = DllCall("user32.dll", "long", "GetWindowLong", "hwnd", $hwnd, "long", -16)	;$GWL_STYLE
	If @error Then
		Return 0
	Else
		Return BitAND($Style[0], 0x00040000) > 0
	EndIf
EndFunc
