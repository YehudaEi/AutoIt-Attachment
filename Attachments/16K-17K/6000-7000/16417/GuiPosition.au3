#include-once

;globals
;===============================================================================
Global $w_Title,$w_Text,$w_PosX,$w_PosY,$w_Info
;===============================================================================

; function list
;===============================================================================
; _GuiDockToScreenSide
; _GuiImmobilize
; _GuiGetLastPos
; _GuiSetLastPos
;===============================================================================

;functions
;===============================================================================
;
; Description:		_GuiDockToScreenSide
; Parameter(s):		$w_Title - Window Title
;					$w_Text - Window Text
; Requirement:		None
; Return Value(s):	None
; User CallTip:		Call within the gui loop.
; Author(s):		Jared Epstein (maqleod)
; Note(s):			Docks the gui window to any side of screen it is let go of past.
;					
;===============================================================================
Func _GuiDockToScreenSide($w_Title,$w_Text = "")
	$hPos = WinGetPos($w_Title,$w_Text)
		if $hPos[0] + $hPos[2] > @DesktopWidth then
			WinMove($w_Title,$w_Text,@DesktopWidth - $hPos[2],$hPos[1])
		endif
		if $hPos[1] + $hPos[3] > @DesktopHeight then
			WinMove($w_Title,$w_Text,$hPos[0],@DesktopHeight - $hPos[3])
		endif
		if $hPos[0] < 1 then
			WinMove($w_Title,$w_Text,1,$hPos[1])
		endif
		if $hPos[1] < 1 then
			WinMove($w_Title,$w_Text,$hPos[0],1)
		endif
EndFunc
;===============================================================================
;
; Description:		_GuiImmobilize
; Parameter(s):		$w_Title - Window Title
;					$w_Text - Window Text
;					$hPosX - X position of Gui, -1 is default, leave if you do not set specific coords for your gui
;					$hPosY - Y position of Gui, -1 is default, leave if you do not set specific coords for your gui
; Requirement:		None
; Return Value(s):	None
; User CallTip:		Call within the gui loop.
; Author(s):		Jared Epstein (maqleod) (adapted from Monamo's work on forum)
; Note(s):			Makes Gui immovable.
;					
;===============================================================================	
Func _GuiImmobilize($w_Title,$w_Text = "",$w_PosX = -1,$w_PosY = -1)
    $m_Pos=WinGetPos($w_Title)
    If $m_Pos[0] <> $w_PosX Or $m_Pos[1] <> $w_PosY Then
        WinMove($w_Title,$w_Text,$w_PosX,$w_PosY)
    EndIf
EndFunc
;===============================================================================
;
; Description:		_GuiGetLastPos
; Parameter(s):		$w_Title - Window Title
;					$w_Text - Window Text
;					$w_Info - use setting from _GuiSetLastPos, 0 (default) or 1
; Requirement:		_GuiSetLastPos
; Return Value(s):	X and Y position as recorded by _GuiSetLastPos in an array $w_Title[0] is x, $w_Title[1] is y
; User CallTip:		Call during init.
; Author(s):		Jared Epstein (maqleod)
; Note(s):			Retrieves info recorded by _GuiSetLastPos. If there was a problem recording or was first time running, will set coords to center.
;					
;===============================================================================
Func _GuiGetLastPos($w_Title,$w_Text = "",$w_Info = 0)
	Local $l_Pos[2]
	if $w_Info = 0 then
		$x_Pos = IniRead($w_Title & ".ini",$w_Title,"Xpos",-1)
		$y_Pos = IniRead($w_Title & ".ini",$w_Title,"Ypos",-1)
	elseif $w_Info = 1 then
		$x_Pos = RegRead("HKEY_CURRENT_USER\SOFTWARE\" & $w_Title,"Xpos")
		if $x_Pos = 1 OR $x_Pos = -32000 then
			RegWrite("HKEY_CURRENT_USER\SOFTWARE\" & $w_Title,"Xpos","REG_SZ",-1)
			$x_Pos = RegRead("HKEY_CURRENT_USER\SOFTWARE\" & $w_Title,"Xpos")
		endif
		$y_Pos = RegRead("HKEY_CURRENT_USER\SOFTWARE\" & $w_Title, "Ypos")
		if $y_Pos = 1 OR $y_Pos = -32000 then
			RegWrite("HKEY_CURRENT_USER\SOFTWARE\" & $w_Title,"Ypos","REG_SZ",-1)
			$y_Pos = RegRead("HKEY_CURRENT_USER\SOFTWARE\" & $w_Title, "Ypos")
		endif
	endif
	$l_Pos[0] = $x_Pos
	$l_Pos[1] = $y_Pos
	Return $l_Pos
EndFunc
;===============================================================================
;
; Description:		_GuiSetLastPos
; Parameter(s):		$w_Title - Window Title
;					$w_Text - Window Text, optional
;					$w_Info - 0 or 1, 0 (default) indicates to save to .ini file, 1 indicates to save to registry
; Requirement:		None
; Return Value(s):	None
; User CallTip:		Call before GuiDelete().
; Author(s):		Jared Epstein (maqleod)
; Note(s):			Records last position of Gui window to be retrieved by _GuiGetLastPos.
;					
;===============================================================================
Func _GuiSetLastPos($w_Title,$w_Text = "",$w_Info = 0)
	$n_Pos = WinGetPos($w_Title,$w_Text)
	if $w_Info = 0 then
		IniWrite($w_Title & ".ini",$w_Title,"Xpos",$n_Pos[0])
		IniWrite($w_Title & ".ini",$w_Title,"Ypos",$n_Pos[1])
	elseif $w_Info = 1 then
		RegWrite("HKEY_CURRENT_USER\SOFTWARE\" & $w_Title,"Xpos","REG_SZ",$n_Pos[0])
		RegWrite("HKEY_CURRENT_USER\SOFTWARE\" & $w_Title,"Ypos","REG_SZ",$n_Pos[1])
	endif
EndFunc