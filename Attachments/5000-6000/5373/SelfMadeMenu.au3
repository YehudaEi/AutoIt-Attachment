; SelfMadeMenu V0.002 ;-) - Just for testing out something
; Written by Holger Kotsch
; Version: 3.1.1.X-Beta is needed

#include <GUIConstants.au3>

Opt("WinTitleMatchMode", 4)

Global Const $WM_NCACTIVATE			= 0x0086
Global Const $BM_SETSTATE			= 0x00F3

$hMainGui	= GUICreate("SMM V0.002", 110, 170, -1, -1, BitOr($WS_CAPTION, $DS_MODALFRAME,$WS_SYSMENU))
;GUISetBkColor(0xAACCBB)

$icon1		= GUICtrlCreateIcon("shell32.dll", 23, 25, 25, 16, 16)
GUICtrlSetStyle(-1, BitOr($SS_ICON, $SS_NOTIFY))
$btn1		= GUICtrlCreateButton("Help", 20, 20, 70, 26, $WS_CLIPSIBLINGS)
$icon2		= GUICtrlCreateIcon("shell32.dll", 21, 25, 75, 16, 16)
GUICtrlSetStyle(-1, BitOr($SS_ICON, $SS_NOTIFY))
$btn2		= GUICtrlCreateButton("     Options", 20, 70, 70, 26, $WS_CLIPSIBLINGS)
$icon3		= GUICtrlCreateIcon("mstask.dll", 3, 25, 125, 16, 16)
GUICtrlSetStyle(-1, BitOr($SS_ICON, $SS_NOTIFY))
$btn3		= GUICtrlCreateButton("  Tasks", 20, 120, 70, 26, $WS_CLIPSIBLINGS)

GUISetState()


;$hMenuGUI	= GUICreate("Menu", 74, 66, -1, -1, BitOr($WS_POPUP, $WS_BORDER), $WS_EX_TOOLWINDOW) ; Flat Menu
$hMenuGUI	= GUICreate("Menu", 90, 66, -1, -1, BitOr($WS_POPUP, $WS_DLGFRAME), $WS_EX_TOOLWINDOW)
GUISetBkColor(0xAACCBB)

GUICtrlCreatePic(@ScriptDir & "\menu.bmp", 0, -54, 20, 120)
$openhlp	= GUICtrlCreateIcon("shell32.dll", 4, 23, 2, 16, 16)
GUICtrlSetStyle(-1, BitOr($SS_ICON, $SS_NOTIFY))
$openlbl	= GUICtrlCreateLabel("        Open", 20, 0, 70, 20, BitOr($SS_CENTERIMAGE, $WS_CLIPSIBLINGS))
$savehlp	= GUICtrlCreateIcon("shell32.dll", 5, 23, 22, 16, 16)
GUICtrlSetStyle(-1, BitOr($SS_ICON, $SS_NOTIFY))
$savelbl	= GUICtrlCreateLabel("        Save", 20, 20, 70, 20, BitOr($SS_CENTERIMAGE, $WS_CLIPSIBLINGS))
GUICtrlCreateLabel("", 22, 42, 67, 2, $SS_SUNKEN)
$exithlp	= GUICtrlCreateIcon("shell32.dll", 27, 23, 48, 16, 16)
GUICtrlSetStyle(-1, BitOr($SS_ICON, $SS_NOTIFY))
$exitlbl	= GUICtrlCreateLabel("        Exit", 20, 46, 70, 20, BitOr($SS_CENTERIMAGE, $WS_CLIPSIBLINGS))

GUISwitch($hMainGui)

$hover		= 0
$rect		= DllStructCreate("int;int;int;int")
$btn1pressed = 0
$btn2pressed = 0
$btn3pressed = 0

While 1
	$msg = GUIGetMsg(1)
	
	If $msg[1] = $hMainGui Then
		GUISetState(@SW_HIDE, $hMenuGui)
		GUISwitch($hMainGui)
	EndIf
	
	If $msg[1] = $hMenuGui Then
		$info = GUIGetCursorInfo()
		
		$ctrl = $info[4]
		If $ctrl <> $hover Then
			GUICtrlSetColor($hover, -1)
			GUICtrlSetBkColor($hover, 0xAACCBB)
		EndIf

		Switch $hover
			Case $openhlp
				$hover = $openlbl
			Case $savehlp
				$hover = $savelbl
			Case $exithlp
				$hover = $exitlbl
		EndSwitch
		
		If $hover > 0 Then
			GUICtrlSetColor($hover, -1)
			GUICtrlSetBkColor($hover, 0xAACCBB)
		EndIf
		
		GUICtrlSetColor($ctrl, 0xFFFFFF)
		GUICtrlSetBkColor($ctrl, 0x663344)
		If $ctrl = $openhlp Then
			GUICtrlSetColor($openlbl, 0xFFFFFF)
			GUICtrlSetBkColor($openlbl, 0x663344)
		ElseIf $ctrl = $savehlp Then
			GUICtrlSetColor($savelbl, 0xFFFFFF)
			GUICtrlSetBkColor($savelbl, 0x663344)
		ElseIf $ctrl = $exithlp Then
			GUICtrlSetColor($exitlbl, 0xFFFFFF)
			GUICtrlSetBkColor($exitlbl, 0x663344)
		EndIf
		
		$height	= 18
		$top	= 1
		
		Switch $ctrl
			Case $openlbl, $openhlp
				$top = 1
			Case $savelbl, $savehlp
				$top = 21
			Case $exitlbl, $exithlp
				$top = 47
		EndSwitch
		
		Switch $ctrl
			Case $openlbl, $openhlp, $savelbl, $savehlp, $exitlbl, $exithlp
				$hdc = DllCall("user32.dll", "hwnd", "GetDC", "hwnd", $hMenuGui)
				$hdc = $hdc[0]
			
				DllStructSetData($rect, 1, 22)				; Left
				DllStructSetData($rect, 2, $top)			; Top
				DllStructSetData($rect, 3, 40)				; Right
				DllStructSetData($rect, 4, $top + $height)	; Bottom
			
				DllCall("user32.dll", "int", "DrawEdge", "hwnd", $hdc, "ptr", DllStructGetPtr($rect), "int", 0x0004, "int", 0x000F)
				DllCall("user32.dll", "hwnd", "ReleaseDC", "hwnd", $hMenuGui, "hwnd", $hdc)
		EndSwitch
		
		$hover = $ctrl
	EndIf
	
	$x = 90
	
	$info = GUIGetCursorInfo()
	If Not $info[2] Then
		If $btn1pressed Then
			GUICtrlSendMsg($btn1, $BM_SETSTATE, 0, 0)
			$btn1pressed = 0
		EndIf
		If $btn2pressed Then
			GUICtrlSendMsg($btn2, $BM_SETSTATE, 0, 0)
			$btn2pressed = 0
		EndIf
		If $btn3pressed Then
			GUICtrlSendMsg($btn3, $BM_SETSTATE, 0, 0)
			$btn3pressed = 0
		EndIf
	EndIf
			
	Switch $msg[0]
		Case $GUI_EVENT_CLOSE
			ExitLoop
		
			
		Case $btn1, $icon1
			If $msg[0] = $icon1 And $btn1pressed = 0 Then
				GUICtrlSendMsg($btn1, $BM_SETSTATE, 1, 0)
				$btn1pressed = 1
			EndIf			
			GUICtrlSetState($btn1, $GUI_FOCUS)
    		$y = 20
			
		Case $btn2, $icon2
			If $msg[0] = $icon2 And $btn2pressed = 0 Then
				GUICtrlSendMsg($btn2, $BM_SETSTATE, 1, 0)
				$btn2pressed = 1
			EndIf
			GUICtrlSetState($btn2, $GUI_FOCUS)
    		$y = 70

		Case $btn3, $icon3
			If $msg[0] = $icon3 And $btn3pressed = 0 Then
				GUICtrlSendMsg($btn3, $BM_SETSTATE, 1, 0)
				$btn3pressed = 1
			EndIf
			GUICtrlSetState($btn3, $GUI_FOCUS)
			$y = 120
			ConvertCoords($x, $y)
			WinMove($hMenuGUI, "", $x, $y)
			GUISetState(@SW_SHOW, $hMenuGUI)
			DllCall("user32.dll", "int", "SendMessage", "hwnd", $hMainGui, "int", $WM_NCACTIVATE, "int", 1, "int", 0)
		
		Case $openlbl, $savelbl, $exitlbl, $openhlp, $savehlp, $exithlp
			GUISetState(@SW_HIDE, $hMenuGUI)
			Switch $msg[0]
				Case $openlbl, $openhlp
					FileOpenDialog("Choose files", @WindowsDir, "All Files (*.*)")
				Case $savelbl, $savehlp
				
				Case $exitlbl, $exithlp
					ExitLoop
			EndSwitch
				
	EndSwitch

WEnd

DllStructDelete($rect)

Exit

Func ConvertCoords(ByRef $x, ByRef $y)
	$point = DllStructCreate("int;int")
	DllStructSetData($point, 1, $x)
	DllStructSetData($point, 2, $y)
	DllCall("user32.dll", "int", "ClientToScreen", "hwnd", $hMainGui, "ptr", DllStructGetPtr($point))
	$x = DllStructGetData($point, 1)
	$y = DllStructGetData($point, 2)
	DllStructDelete($point)
EndFunc
