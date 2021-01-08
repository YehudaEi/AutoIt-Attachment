
#include <GUIConstants.au3>
Global $hide_state = 0, $btn_state = 0, $side = "left"
Global $Button_[8], $Label_[8]

$hwnd = GUICreate("Sliding Toolbar", 613, 85, -598, -1, -1, BitOR($WS_EX_TOPMOST, $WS_EX_TOOLWINDOW))
$Show = GUICtrlCreateButton(">", 595, 8, 17, 70, BitOR($BS_CENTER, $BS_FLAT))
$author = GUICtrlCreateLabel(" By...   Simucal  &&  Valuater", 120, 25, 400, 40)
GUICtrlSetFont(-1, 20, 700)
GUISetState(@SW_HIDE, $hwnd)

$hwnd2 = GUICreate("Sliding Toolbar", 613, 85, 0, -1, -1, BitOR($WS_EX_TOPMOST, $WS_EX_TOOLWINDOW))
$Button_[1] = GUICtrlCreateButton("Btn 1", 30, 35, 73, 41)
$Label_[1] = GUICtrlCreateLabel("Button 1", 49, 6, 60, 17)
$Button_[2] = GUICtrlCreateButton("Btn 2", 110, 35, 73, 41)
$Label_[2] = GUICtrlCreateLabel("Button 2", 128, 6, 60, 17)
$Button_[3] = GUICtrlCreateButton("Btn 3", 190, 35, 73, 41)
$Label_[3] = GUICtrlCreateLabel("Button 3", 207, 6, 43, 17)
$Button_[4] = GUICtrlCreateButton("Btn 4", 270, 35, 73, 41)
$Label_[4] = GUICtrlCreateLabel("Button 4", 287, 6, 75, 17)
$Button_[5] = GUICtrlCreateButton("Btn 5", 350, 35, 73, 41)
$Label_[5] = GUICtrlCreateLabel("Button 5", 368, 6, 75, 17)
$Button_[6] = GUICtrlCreateButton("Btn 6", 430, 35, 73, 41)
$Label_[6] = GUICtrlCreateLabel("Button 6", 447, 6, 40, 17)
$Button_[7] = GUICtrlCreateButton("Btn 7", 510, 35, 73, 41)
$Label_[7] = GUICtrlCreateLabel("Button 7", 526, 6, 60, 17)
$Hide = GUICtrlCreateButton("<", 595, 8, 17, 70, BitOR($BS_CENTER, $BS_FLAT, $BS_MULTILINE))
For $i = 1 To 7
	GUICtrlSetCursor($Button_[$i], 0)
Next
DllCall("user32.dll", "int", "AnimateWindow", "hwnd", $hwnd2, "int", 500, "long", 0x00040001);slide in from left
GUISetState()

While 1
	$msg1 = GUIGetMsg()
	If $msg1 = $GUI_EVENT_CLOSE Then Exit
	If $msg1 = $Hide Then Slide_out()
	If $msg1 = $Show Then Slide_in()
	$a_pos = WinGetPos($hwnd2)
	$a_pos2 = WinGetPos($hwnd)
	If $side = "left" Then
		If $a_pos[0]+306 < (@DesktopWidth / 2) Then
			If $a_pos[0] <> 0 And $hide_state = 0 And $a_pos[0] Then
				WinMove($hwnd2, "", 0, $a_pos[1])
				WinMove($hwnd, "", -598, $a_pos[1])
			EndIf
			If $a_pos2[0] <> - 598 And $hide_state = 1 Then
				WinMove($hwnd, "", -598, $a_pos2[1])
				WinMove($hwnd2, "", 0, $a_pos2[1])
			EndIf
		Else
			SideSwitch()
		EndIf
	EndIf
	If $side = "right" Then
		If $a_pos[0]+306 > (@DesktopWidth / 2) Then
			If $a_pos[0] <> @DesktopWidth-613 And $hide_state = 0 Then
				WinMove($hwnd2, "", (@DesktopWidth-613), $a_pos[1])
				WinMove($hwnd, "", (@DesktopWidth-18), $a_pos[1]) ; should be -15
			EndIf
			If $a_pos2[0] <> (@DesktopWidth-18) And $hide_state = 1 Then ; should be -15
				WinMove($hwnd, "", (@DesktopWidth-18), $a_pos2[1]) ; should be -15
				WinMove($hwnd2, "", (@DesktopWidth-613), $a_pos2[1])
			EndIf
		Else
		SideSwitch()
		EndIf
	EndIf
	If $hide_state = 0 Then
		$a_mpos = GUIGetCursorInfo($hwnd2)
		If IsArray($a_mpos) = 1 Then
			For $b = 1 To 7
				If $a_mpos[4] = $Button_[$b] Then
					If $b = 1 Then $left = 25
					If $b > 1 Then $left = (($b - 1) * 80) + 25
					GUICtrlSetPos($Button_[$b], $left, 30, 83, 46)
					GUICtrlSetColor($Label_[$b], 0xff0000)
					GUICtrlSetFont($Button_[$b], 8, 400, 4, "MS Sans Serif")
					While $a_mpos[4] = $Button_[$b]
						$msg = GUIGetMsg()
						If $msg = $Button_[$b] Then
							Call("Function" & $b)
							ExitLoop
						EndIf
						$a_mpos = GUIGetCursorInfo($hwnd2)
						If IsArray($a_mpos) <> 1 Then ExitLoop
					WEnd
					$left = $left + 5
					GUICtrlSetPos($Button_[$b], $left, 35, 73, 41)
					GUICtrlSetColor($Label_[$b], 0x000000)
					GUICtrlSetFont($Button_[$b], 8, 400, -1, "MS Sans Serif")
				EndIf
			Next
		EndIf
	EndIf
WEnd

Func Slide_in()
	$hide_state = 0
	;Btn_reset()
	GUISetState(@SW_HIDE, $hwnd)
	If $side = "left" Then DllCall("user32.dll", "int", "AnimateWindow", "hwnd", $hwnd2, "int", 500, "long", 0x00040001);slide in from left
	If $side = "right" Then DllCall("user32.dll", "int", "AnimateWindow", "hwnd", $hwnd2, "int", 500, "long", 0x00040002);slide in from right
	WinActivate($hwnd2)
	WinWaitActive($hwnd2)
EndFunc   ;==>Slide_in

Func Slide_out()
	$hide_state = 1
	;Btn_reset()
	If $side = "left" Then DllCall("user32.dll", "int", "AnimateWindow", "hwnd", $hwnd2, "int", 500, "long", 0x00050002);slide out to left
	If $side = "right" Then DllCall("user32.dll", "int", "AnimateWindow", "hwnd", $hwnd2, "int", 500, "long", 0x00050001);slide out to right
	GUISetState(@SW_SHOW, $hwnd)
	WinActivate($hwnd)
	WinWaitActive($hwnd)
EndFunc   ;==>Slide_out

Func SideSwitch()
	If $side = "left" Then
		$side = "right"
		GuiCtrlSetPos($Hide,1,8)
		GuiCtrlSetData($Hide, ">")
		GuiCtrlSetPos($Show,1,8)
		GuiCtrlSetData($Show, "<")
	Else
		$side = "left"
		GuiCtrlSetPos($Hide,595, 8)
		GuiCtrlSetData($Hide, "<")
		GuiCtrlSetPos($Show,595, 8)
		GuiCtrlSetData($Show, ">")
	EndIf
EndFunc
		


Func Function1()
	Slide_out()
	; do stuff
EndFunc   ;==>Function1
Func Function2()
	Slide_out()
	; do stuff
EndFunc   ;==>Function2
Func Function3()
	Slide_out()
	; do stuff
EndFunc   ;==>Function3
Func Function4()
	Slide_out()
	; do stuff
EndFunc   ;==>Function4
Func Function5()
	Slide_out()
	; do stuff
EndFunc   ;==>Function5
Func Function6()
	Slide_out()
	; do stuff
EndFunc   ;==>Function6
Func Function7()
	Slide_out()
	; do stuff
EndFunc   ;==>Function7