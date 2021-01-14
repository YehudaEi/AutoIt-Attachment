#include-once
Opt("GuiOnEventMode", 1)

Global $GUIHWND, $TITLE_LABEL

Func _GuiDragableCreate($Title="", $Width=300, $Height=200, $Left=-1, $Top=-1, $Style=-1, $exStyle=-1, $Parent=0)
	Local $SetStyle = $WS_POPUPWINDOW+$Style, $SetExStyle = $WS_EX_DLGMODALFRAME+$exStyle
	If $Style = -1 Then $SetStyle = $WS_POPUPWINDOW
	If $exStyle = -1 Then $SetExStyle = $WS_EX_DLGMODALFRAME
	Local $hWnd = GUICreate($Title, $Width, $Height, $Left, $Top, $SetStyle, $SetexStyle, $Parent)
	GUISetOnEvent($GUI_EVENT_PRIMARYDOWN, "DragEvent")

	$Title_Label = GUICtrlCreateLabel($Title, 0, 0, 300, 17, $SS_CENTER)
	GUICtrlSetState(-1, $GUI_DISABLE)
	GUICtrlSetResizing(-1, 512)
	GUICtrlSetFont(-1, 12, 700, 0, "Courier New")
	GUICtrlSetBkColor(-1, 0xCCCCCC)

	Local $X_Button = GUICtrlCreateButton("X", 280, 0, 16, 16)
	GUICtrlSetFont(-1, 10, 700, 0, "Tahoma")
	GUICtrlSetOnEvent(-1, "Quit")

	Local $Mim_Button = GUICtrlCreateButton("-", 240, 0, 16, 16)
	GUICtrlSetFont(-1, 13, 700, 0, "Arial Black")
	GUICtrlSetOnEvent(-1, "MimimizeGui")

	Local $Max_Button = GUICtrlCreateButton(CHR(152), 260, 0, 16, 16)
	GUICtrlSetFont(-1, 9, 700, 0, "Tahoma")
	GUICtrlSetOnEvent(-1, "MaximizeGui")
	
	If Not BitAND($SetStyle, $WS_MAXIMIZEBOX) Then GUICtrlSetState(-1, $GUI_DISABLE)
	Return $hWnd
EndFunc

Func DragEvent()
	DragWindow($GuihWnd)
EndFunc

Func DragWindow($hWnd)
	Local $MousePos = MouseGetPos()
	Local $hWndPos = WinGetPos($hWnd)
	Local $WinPos[2], $IsPressed[1], $OpenDll, $GuiCurInfo[5]
	$WinPos[0] = $MousePos[0]-$hWndPos[0]
	$WinPos[1] = $MousePos[1]-$hWndPos[1]
	$OpenDll = DllOpen("user32.dll")
	$GuiCurInfo = GUIGetCursorInfo($hWnd)
	If $OpenDll <> -1 And ($GuiCurInfo[4] = 0 Or $GuiCurInfo[4] = $Title_Label) Then
		Do
			$hWndPos = MouseGetPos()
			WinMove($hWnd, '', $hWndPos[0]-$WinPos[0], $hWndPos[1]-$WinPos[1])
			Sleep(20)
			$IsPressed = DllCall($OpenDll, "int", "GetAsyncKeyState", "int", '0x01')
		Until @error Or BitAND($IsPressed[0], 0x8000) <> 0x8000
	EndIf
	DllClose($OpenDll)
EndFunc

Func MaximizeGui()
	If BitAND(WinGetState($GuihWnd), 32) Then
		GUISetState(@SW_RESTORE, $GuihWnd)
	Else
		GUISetState(@SW_MAXIMIZE, $GuihWnd)
	EndIf
EndFunc

Func MimimizeGui()
	GUISetState(@SW_MINIMIZE, $GuihWnd)
EndFunc

Func Quit()
	DllCall("User32.dll", "long", "AnimateWindow", "hwnd", $GuihWnd, "long", 300, "long", 0x10+0x10000)
	Exit
EndFunc