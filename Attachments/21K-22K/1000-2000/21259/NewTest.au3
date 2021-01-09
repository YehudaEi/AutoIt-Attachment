;*********************************************************************************
; Created  Date 	: 06/06/2008 
; Created By 		:
; Tester Version	: 1.0
; Project			: 
; Description		: 
;*********************************************************************************
; Running Test On  : 
;*********************************************************************************

;=========#DEFINES and '#INCLUDES File 
#include <GuiConstants.au3>	; Gui File Export
#RequireAdmin		   		; Check the User login is req Admin privilabe 	
#NoTrayIcon
;*********************************************************************************

; global variable declarations

; local Variables 
Opt("TrayMenuMode",1) 		; Default tray menu items (Script Paused/Exit) will not be shown.
opt("WinTitleMatchMode", 3) ; Title Match ;1=start, 2=subStr, 3=exact, 4=advanced, -1 to -4=Nocase
HotKeySet("{ESC}", "_Exit")
HotKeySet("^!p", "go")
HotKeySet("^!t", "_Exit")

GuiCreate("PixiHex", 200, 200)
GuiSetIcon(@SystemDir & "\mspaint.exe", 0)

$xy=MouseGetPos()
$color=PixelGetColor( $xy[0] , $xy[1])

GUICtrlCreateLabel("The color of the pixel" & @CRLF & "beneath the cursor is" & @CRLF & "displayed on the right:", 13, 20)
GUICtrlCreateLabel("The Hex value of this color is: ", 13, 65)
$SC1 = GUICtrlCreateLabel (Hex($color, 6), 13, 80)
GUICtrlCreateLabel("The Decimal value of this color is: " , 14, 105)
$SC2 = GUICtrlCreateLabel( $color, 13, 120)
$SC3 = GuiCtrlCreateLabel("", 135, 15, 50, 50)
GuiCtrlSetBkColor(-1, 0x & $color)
GUICtrlCreateCheckbox("Set as Always On Top", 13, 160)
GUICtrlSetState(-1, $GUI_CHECKED)
WinSetOnTop("PixiHex", "", 1)

; GUI MESSAGE LOOP
GuiSetState()

While GuiGetMsg() <> $GUI_EVENT_CLOSE	
	$checkbox=GUICtrlRead(7)
	Select
;	Case $tray = $aboutitem
;		Msgbox(262144, "About:", "PixiHex was created by Me using the" & @CRLF & "AutoItv3 scripting language. Copyright 2008.")
;	Case $tray = $exititem
;		Exit
	Case $checkbox = $GUI_CHECKED
		WinSetOnTop("PixiHex", "", 1)
	Case $checkbox = $GUI_UNCHECKED
		WinSetOnTop("PixiHex", "", 0)
	EndSelect
WEnd

Func go()
	$xy=MouseGetPos()
	$color=PixelGetColor( $xy[0] , $xy[1])
	GuiCtrlSetBkColor($SC3,0x & $color)
	GUICtrlSetData($SC2,$color)
	GUICtrlSetData($SC1,Hex($color, 6))
EndFunc ;==>_Exit

Func _Exit()
	Exit
EndFunc ;==>_Exit