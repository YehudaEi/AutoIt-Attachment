; This script is called from CodeWizard.au3 (line 294) when user clicks the preview button
; It watches for when the user hovers over a button such as "OK" or "Cancel"
;   and reports the value in a tooltip...

Opt("TrayIconDebug", 1)

Opt("WinTitleMatchMode", 4) ;advanced
Opt("MouseCoordMode", 2)  ; mouseGetPos will be relative to current window

Global $title = ""
If $cmdLine[0] > 0 Then $title = $CmdLine[1]

While WinExists($title)
	If Not WinExists("Code Wizard") Then Exit
	sleep(50)
	If mouseIsOver("OK") Then
		Tooltip("1 == $IDOK")
		
	ElseIf mouseIsOver("Cancel") Then
		Tooltip("2 == $IDCANCEL")
		
	ElseIf mouseIsOver("&Abort") Then
		Tooltip("3 == $IDABORT")
		
	ElseIf mouseIsOver("&Retry") Then
		Tooltip("4 == $IDRETRY")
		
	ElseIf mouseIsOver("&Ignore") Then
		Tooltip("5 == $IDIGNORE")
		
	ElseIf mouseIsOver("&Yes") Then
		Tooltip("6 == $IDYES")
		
	ElseIf mouseIsOver("&No") Then
		Tooltip("7 == $IDNO")
	
	ElseIf mouseIsOver("&Try Again") Then
		ToolTip("10 = $IDTRYAGAIN")
	
	ElseIf mouseIsOver("&Continue") Then
		ToolTip("11 = $IDCONTINUE")
	
	Else
		Tooltip('') ;hide tooltip
	EndIf
Wend
Exit


; Returns 1 if mouse is hovering over a message box button with the provided name; 0 otherwise
Func mouseIsOver($buttonText)
	Local $p = ControlGetPos($title, "", $buttonText)
	If IsArray($p) And _mouseIsWithinRect($p[0], $p[1], $p[2], $p[3]) Then Return 1
EndFunc

; Returns 1 if mouse is within the current position specified; return 0 otherwise
Func _mouseIsWithinRect($x, $y, $width, $height)
	Local $pos = MouseGetPos()
	Local $mouseX = $pos[0], $mouseY = $pos[1]
	If $mouseX >= $x And $mouseX <= $x + $width And $mouseY >= $y And $mouseY <= $y + $height Then Return 1
EndFunc
