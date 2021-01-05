; Simulate a SysIPAddress32 control complete with bounds checking and keyboard handling....
; CyberSlug - 22 January 2005
; Limitations:  Only one instance of a SysIPAddress32 control is supported
; REQUIRED VARIABLES:  Global $ip, $prevLength, $prev = WinGetHandle(WinGetTitle(""))
; ---------------------------

#include-once

HotKeySet(".", "Dot")
HotKeySet("{Backspace}", "BS")
HotKeySet("{Left}", "Left")
HotKeySet("{Right}", "Right")

; Creates a control (actually a bunch of controls in an embedded window)
; to simulate a SysIPAddress32 control...
Func _GuiCtrlCreateIP($left, $top, $parentGui, ByRef $ip, ByRef $prevLength)
	Dim $ip[4]
	Dim $prevLength[4]
	
  Local $style = 0x56000000;WS_CHILD + WS_VISIBLE + WS_CLIPSIBLINGS + WS_CLIPCHILDREN
  Local $sysIpAddress = GuiCreate("", 125, 20, $left, $top, $style, -1, $parentGui)
  
   ; the borderless internal input controls (one per octet)
	$ip[0] = GuiCtrlCreateInput("", 2,3, 27, 15, 0x50000001, 0x0)
		GuiCtrlSetLimit(-1, 3, 1)
	$ip[1] = GuiCtrlCreateInput("",  32,3, 27, 15, 0x50000001, 0x0)
		GuiCtrlSetLimit(-1, 3, 1)
	$ip[2] = GuiCtrlCreateInput("",  62,3, 27, 15, 0x50000001, 0x0)
		GuiCtrlSetLimit(-1, 3, 1)
	$ip[3] = GuiCtrlCreateInput("",  92,3, 27, 15, 0x50000001, 0x0)
		GuiCtrlSetLimit(-1, 3, 1)
	
	; Draw a 3d border around our ip address box....
	; I probably could have used an edit control, but I figured out to handle overlapping controls
	; and focus issues with this particular label.... label styls is SS_WHITE_RECT
	GUICtrlCreateLabel("",  0,0, 125, 20, 0x6, $WS_EX_CLIENTEDGE)
	
	GuiCtrlCreateLabel(".",  29, 2, 4, 15)
		GuiCtrlSetFont(-1, 9, 8000)
		GuiCtrlSetBkColor(-1, _windowColor())
	GuiCtrlCreateLabel(".",  59, 2, 4, 15)
		GuiCtrlSetFont(-1, 9, 8000)
		GuiCtrlSetBkColor(-1, _windowColor())
	GuiCtrlCreateLabel(".",  89, 2, 4, 15)
		GuiCtrlSetFont(-1, 9, 8000)
		GuiCtrlSetBkColor(-1, _windowColor())
  
	GuiSetState()
	GuiSwitch($parentGui)
	Return $sysIpAddress
EndFunc


; This function should be called in the main GUI's main GuiGetMsg loop...
Func _GuiCtrlProcessIP()
		; If window ever loses focus, call _GuiCtrlRefreshIP when window regains focus
	If $PARENT <> WinGetHandle(WinGetTitle("")) Then
		$prev = WinGetHandle(WinGetTitle(""))
	EndIf
	If $prev <> $PARENT And $PARENT = WinGetHandle(WinGetTitle("")) Then
		_GuiCtrlRefreshIP($ip_ctrl, $PARENT) 
		$prev = WinGetHandle(WinGetTitle(""))
	EndIf
	
	For $k = 0 to 3
		sleep(5)
		If Not StringIsDigit(_GuiGtrlGetIP($ip_ctrl, $k+1)) Then
			$valid = ""
			For $i = 1 to 3
				$char = StringMid(_GuiGtrlGetIP($ip_ctrl, $k+1), $i, 1)
				If StringIsDigit($char) Then $valid = $valid & $char
			Next
			GuiCtrlSetData($ip[$k],$valid)
		ElseIf StringStripWS(_GuiGtrlGetIP($ip_ctrl, $k+1),8) <> "" And Number(_GuiGtrlGetIP($ip_ctrl, $k+1)) < 0 Or Number(_GuiGtrlGetIP($ip_ctrl, $k+1)) > 255 Then
			GuiSetState(@SW_DISABLE, $PARENT)
			MsgBox(4096,"Error", "Number must be between 0 and 255")
			GuiSetState(@SW_ENABLE, $PARENT)
			WinActivate($PARENT)
			_GuiCtrlRefreshIP($ip_ctrl, $PARENT) 
			GuiCtrlSetData($ip[$k], "255")
			GuiCtrlSendMsg($ip[$k], 0xB1, 0, 3) ;EM_SETSEL
			$prevLength[$k] = 0
		EndIf
		
		If $prevLength[$k] = 2 And StringLen(GuiCtrlRead($ip[$k])) = 3 Then
			Send(".")
		EndIf
		$prevLength[$k] = StringLen(GuiCtrlRead($ip[$k]))
	Next
EndFunc


; Returns the address in the box; can optionally specify a single octect to obtain
Func _GuiGtrlGetIP($handle, $octet = 0)
	Local $i, $output
	If $octet <= 0 Then
		For $i = 1 to 4
			$output = $output & ControlGetText($handle,"","Edit" & $i) & "."
		Next
		Return StringTrimRight($output, 1)
	ElseIf $octet >=1 And $octet <= 4 Then
		Return ControlGetText($handle,"","Edit" & $octet)
	Else
		SetError(1)
		Return -1
	EndIf
EndFunc


; Sets the address in the box; can optionally specify a single octet to change
Func _GuiCtrlSetIP($handle, $value, $octet = 0)
	Local $i, $output
	Local $split = StringSplit($value, ".")
	If $octet <= 0 And UBound($split) = 5 Then
		For $i = 1 to 4
			GuiCtrlSetData($ip[$i-1], $split[$i])
		Next
		Return StringTrimRight($output, 1)
	ElseIf $octet >=1 And $octet <= 4 Then
		GuiCtrlSetData($ip[$octet-1],$value)
	EndIf	
EndFunc


; Gives the box focus
Func _GuiCtrlFocusIP($handle)
	ControlFocus($handle,"","Edit1")
EndFunc


; Repaint the control; it tends to need redrawn when GUI window loses focus...
Func _GuiCtrlRefreshIP($handle, $parentGui)
	Local $i, $focus = ControlGetFocus($parentGui)
	For $i = 0 to 3
		GuiCtrlSetState($ip[$i], $GUI_FOCUS)
	Next
	ControlFocus($parentGui,"",$focus)
EndFunc

; Fancy hotkey handling of the period character
Func Dot()
	HotKeySet(".")
	If WinActive($PARENT) And ControlGetFocus($ip_ctrl) <> "Edit4" And StringLen(ControlGetText($ip_ctrl,"",ControlGetFocus($ip_ctrl))) <> 0 Then
		ControlFocus($ip_ctrl,"", "Edit" & 1+Number(StringRight(ControlGetFocus($ip_ctrl),1)))
	Else
		Send(".")
	EndIf
	HotKeySet(".", "Dot")
EndFunc

; Fancy hotkey handling of the backspace key
Func BS()
	HotKeySet("{Backspace}")
	If WinActive($PARENT) And ControlGetFocus($ip_ctrl) <> "Edit1" And StringLen(ControlGetText($ip_ctrl,"",ControlGetFocus($ip_ctrl))) = 0 Then
		ControlFocus($ip_ctrl,"", "Edit" & Number(StringRight(ControlGetFocus($ip_ctrl),1))-1)
		GuiCtrlSendMsg($ip[StringRight(ControlGetFocus($ip_ctrl),1)-1], 0xB1, 4, 4) ;EM_SETSEL
	Else
		Send("{Backspace}")
	EndIf
	HotKeySet("{Backspace}", "BS")
EndFunc

;Allow left arrow key to move to previous octects
Func Left()
	HotKeySet("{Left}")
	If WinActive($PARENT) And ControlGetFocus($ip_ctrl) <> "Edit1" And ControlCommand($ip_ctrl,"",ControlGetFocus($ip_ctrl),"GetCurrentCol") = 1 Then
		ControlFocus($ip_ctrl,"", "Edit" & Number(StringRight(ControlGetFocus($ip_ctrl),1))-1)
		;groups tend to highlighting when you move the cursor after typing in a number > 255
		GuiCtrlSendMsg($ip[0], 0xB1, 4, 4) ;EM_SETSEL
		GuiCtrlSendMsg($ip[1], 0xB1, 4, 4) ;EM_SETSEL
		GuiCtrlSendMsg($ip[2], 0xB1, 4, 4) ;EM_SETSEL
		GuiCtrlSendMsg($ip[3], 0xB1, 4, 4) ;EM_SETSEL
	Else
		Send("{Left}")
	EndIf
	HotKeySet("{Left}", "Left")
EndFunc

;Allow right arrow key to move to subsequent octects
Func Right()
	HotKeySet("{Right}")
	If WinActive($PARENT) And ControlGetFocus($ip_ctrl) <> "Edit4" And ControlCommand($ip_ctrl,"",ControlGetFocus($ip_ctrl),"GetCurrentCol") > StringLen(ControlGetText($ip_ctrl,"",ControlGetFocus($ip_ctrl))) Then
		ControlFocus($ip_ctrl,"", "Edit" & Number(StringRight(ControlGetFocus($ip_ctrl),1))+1)
		;groups tend to highlighting when you move the cursor after typing in a number > 255
		GuiCtrlSendMsg($ip[0], 0xB1, 0, 0) ;EM_SETSEL
		GuiCtrlSendMsg($ip[1], 0xB1, 0, 0) ;EM_SETSEL
		GuiCtrlSendMsg($ip[2], 0xB1, 0, 0) ;EM_SETSEL
		GuiCtrlSendMsg($ip[3], 0xB1, 0, 0) ;EM_SETSEL
	Else
		Send("{Right}")
	EndIf
	HotKeySet("{Right}", "Right")
EndFunc


; Retrieve the default hex color for window (edit control) backgrounds
; This is so that I can display a label that looks like an edit control
;   edit controls do not like click events so I substitute a label
;   However, the background color style setting that you would normally
;   use overwrites the text of the label.  Since I want both text and
;   the background color set, I must use a hard-coded color value......
Func _windowColor()
	$tuple = RegRead("HKEY_CURRENT_USER\Control Panel\Colors", "Window")
	If @error Then Return 0xFFFFFF  ;fail-safe value is white....
	; For example, registry key is '255 255 255' if white
	Local $t = StringSplit($tuple, ' ')
	Return Dec( Hex($t[1],2) & Hex($t[2],2) & Hex($t[3],2) )
EndFunc
