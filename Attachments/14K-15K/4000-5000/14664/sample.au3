; ModernMenu2003 Gradient Example
; Syntax:
;	_SetMenuIconGradBkColor(0x??????) ;where ? is a hexadecimal digit
; To prevent gradient, use this code:
;	_SetMenuIconGradBkColor($nMenuIconBkClr)

#include <GUIConstants.au3>
#include 'ModernMenu.au3'

Global Const $WM_CONTEXTMENU = 0x7B

$hMainGUI		= GUICreate('Sample Menu')

; Set default color values - BGR-values!
SetDefaultMenuColors()

; File-Menu
$FileMenu		= GUICtrlCreateMenu('&File')
$OpenItem		= _GUICtrlCreateODMenuItem('Open', $FileMenu, 'shell32.dll', 4)
$SaveItem		= _GUICtrlCreateODMenuItem('Save', $FileMenu, 'shell32.dll', 6)
_GUICtrlCreateODMenuItem('', $FileMenu) ; Separator
$RecentMenu		= _GUICtrlCreateODMenu('Recent Files', $FileMenu)
_GUICtrlCreateODMenuItem('', $FileMenu) ; Separator
$ExitItem		= _GUICtrlCreateODMenuItem('Exit', $FileMenu, 'shell32.dll', 27)

; Tools-Menu
$ToolsMenu		= GUICtrlCreateMenu('&Tools')
$CalcItem		= _GUICtrlCreateODMenuItem('Calculator', $ToolsMenu, 'calc.exe', 0)
$CmdItem		= _GUICtrlCreateODMenuItem('CMD', $ToolsMenu, 'cmd.exe', 0)
$EditorItem		= _GUICtrlCreateODMenuItem('Editor', $ToolsMenu, 'notepad.exe', 0)
$RegeditItem	= _GUICtrlCreateODMenuItem('Regedit', $ToolsMenu, 'regedit.exe', 0)

; View-Menu
$ViewMenu		= GUICtrlCreateMenu('&View')
$ViewColorMenu	= _GUICtrlCreateODMenu('Menu Colors', $ViewMenu, 'mspaint.exe', 0)
$SetDefClrItem	= _GUICtrlCreateODMenuItem('Default', $ViewColorMenu, '', 0, 1)
_GUICtrlCreateODMenuItem('', $ViewColorMenu) ; Separator
$SetRedClrItem	= _GUICtrlCreateODMenuItem('Red', $ViewColorMenu, '', 0, 1)
$SetGrnClrItem	= _GUICtrlCreateODMenuItem('Green', $ViewColorMenu, '', 0, 1)
GUICtrlSetState(-1, $GUI_CHECKED)
$SetBlueClrItem	= _GUICtrlCreateODMenuItem('Blue', $ViewColorMenu, '', 0, 1)
$ViewStateItem	= _GUICtrlCreateODMenuItem('Enable Config', $ViewMenu)
GUICtrlSetState(-1, $GUI_CHECKED)

; Help-Menu
$HelpMenu		= GUICtrlCreateMenu('&?')
$HelpItem		= _GUICtrlCreateODMenuItem('Help Topics', $HelpMenu, 'shell32.dll', 23)
_GUICtrlCreateODMenuItem('', $HelpMenu) ; Separator
$AboutItem		= _GUICtrlCreateODMenuItem('About...', $HelpMenu, '', 0)

; You can also the same things on context menus
$GUIContextMenu	= GUICtrlCreateContextMenu(-1)
$ConAboutItem	= _GUICtrlCreateODMenuItem('About...', $GUIContextMenu, 'explorer.exe', 7)
_GUICtrlCreateODMenuItem('', $GUIContextMenu) ; Separator
$ConExitItem	= _GUICtrlCreateODMenuItem('Exit', $GUIContextMenu, 'shell32.dll', 27)

; My_WM_MeasureItem and My_WM_DrawItem are registered in 
; 'ModernMenu.au3' so they don't need to registered here
; Also OnAutoItExit() is in 'ModernMenu.au3' to cleanup the
; menu imagelist and special font

GUISetState()


; Main GUI Loop

While 1
	$Msg = GUIGetMsg()
	
	Switch $Msg
		Case $GUI_EVENT_CLOSE, $ExitItem, $ConExitItem
			ExitLoop
		
		Case $AboutItem, $ConAboutItem
			Msgbox(64, 'About', 'Menu color sample by Holger Kotsch')
			
		Case $ViewStateItem
			If BitAnd(GUICtrlRead($ViewStateItem), $GUI_CHECKED) Then
				GUICtrlSetState($ViewStateItem, $GUI_UNCHECKED)
				GUICtrlSetState($ViewColorMenu, $GUI_DISABLE)
			Else
				GUICtrlSetState($ViewStateItem, $GUI_CHECKED)
				GUICtrlSetState($ViewColorMenu, $GUI_ENABLE)
			EndIf
			
		Case $SetDefClrItem
			SetCheckedItem($SetDefClrItem)
			SetDefaultMenuColors()
			
		Case $SetRedClrItem
			SetCheckedItem($SetRedClrItem)
			SetRedMenuColors()
			
		Case $SetGrnClrItem
			SetCheckedItem($SetGrnClrItem)
			SetGreenMenuColors()
			
		Case $SetBlueClrItem
			SetCheckedItem($SetBlueClrItem)
			SetBlueMenuColors()
							
	EndSwitch
WEnd

Exit


Func SetCheckedItem($DefaultItem)
	GUICtrlSetState($SetDefClrItem, $GUI_UNCHECKED)
	GUICtrlSetState($SetRedClrItem, $GUI_UNCHECKED)
	GUICtrlSetState($SetGrnClrItem, $GUI_UNCHECKED)
	GUICtrlSetState($SetBlueClrItem, $GUI_UNCHECKED)
	
	GUICtrlSetState($DefaultItem, $GUI_CHECKED)
EndFunc


Func SetDefaultMenuColors()
	_SetMenuBkColor(0xFFFFFF)
	_SetMenuIconBkColor(0xCACACA)
	_SetMenuIconGradBkColor(0xEFEFEF) ;;;
	_SetMenuSelectBkColor(0xE5A2A0)
	_SetMenuSelectRectColor(0x854240)
	_SetMenuSelectTextColor(0x000000)
	_SetMenuTextColor(0x000000)
EndFunc


Func SetRedMenuColors()
	_SetMenuBkColor(0xAADDFF)
	_SetMenuIconBkColor(0x5566BB)
	_SetMenuIconGradBkColor(0x99CCEE) ;;;
	_SetMenuSelectBkColor(0x70A0C0)
	_SetMenuSelectRectColor(0x854240)
	_SetMenuSelectTextColor(0x000000)
	_SetMenuTextColor(0x000000)
EndFunc


Func SetGreenMenuColors()
	_SetMenuBkColor(0xAAFFAA)
	_SetMenuIconBkColor(0x66BB66)
	_SetMenuIconGradBkColor(0x99EE99) ;;;
	_SetMenuSelectBkColor(0xBBCC88)
	_SetMenuSelectRectColor(0x222277)
	_SetMenuSelectTextColor(0x770000)
	_SetMenuTextColor(0x000000)
EndFunc


Func SetBlueMenuColors()
	_SetMenuBkColor(0xFFB8B8)
	_SetMenuIconBkColor(0xBB8877)
	_SetMenuIconGradBkColor(0xEEA7A7) ;;;
	_SetMenuSelectBkColor(0x662222)
	_SetMenuSelectRectColor(0x4477AA)
	_SetMenuSelectTextColor(0x66FFFF)
	_SetMenuTextColor(0x000000)
EndFunc

Func _HiWord($x)
   Return BitShift($x, 16)
EndFunc   ;==>_HiWord

Func _LoWord($x)
   Return BitAND($x, 0xFFFF)
EndFunc   ;==>_LoWord