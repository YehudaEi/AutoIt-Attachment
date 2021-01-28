; ====================================================================================
; Function   : _GUICtrlSetBackgroundColor(background-color[, controlID[, text-color]])
; Description: Sets the background color of a control. (Transparent Label)
;            : Sets the text color of a control.
; Author     : Thunder-Man (Frank Michalski), function name change by DarkShadow6.
; Date       : 19. September 2007
; Version    : 1.20
; Example    : _GUICtrlSetBackgroundColor()                       : Transparent
;              _GUICtrlSetBackgroundColor(-1, $MyLabel)           : Transparent
;              _GUICtrlSetBackgroundColor(0x00ff00)               : Color Green
;              _GUICtrlSetBackgroundColor(0x00ff00, $MyLabel)     : Color Green
;              _GUICtrlSetBackgroundColor(-1, $MyLabel, 0x00ff00) : Text Color Green
; ====================================================================================
Func _GUICtrlSetBackgroundColor($BackColor_ = "", $GuiID_ = -1, $Textcolor_ = 0x000000)
	If $BackColor_ = "" or $BackColor_ = -1 Then
		GUICtrlSetBkColor($GuiID_, $GUI_BKCOLOR_TRANSPARENT)
		GUICtrlSetColor($GuiID_, $Textcolor_)
	Else
		GUICtrlSetBkColor($GuiID_, $BackColor_)
		GUICtrlSetColor($GuiID_, $Textcolor_)
	EndIf
EndFunc  ;==>_GUICtrlSetBackgroundColor
;=====================================================================================