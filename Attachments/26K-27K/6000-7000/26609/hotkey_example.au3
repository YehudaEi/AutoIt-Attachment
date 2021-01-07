#include-once
#include <hotkeys.au3>

#cs
-----------Flags for rules:-----------
	Invalid keys: (used when need to block combination of keys)
	$HKCOMB_NONE - Unmodified keys; it is blocked nothing, it is used only for "Modifiers"
	$HKCOMB_S - SHIFT
	$HKCOMB_C - CTRL
	$HKCOMB_A - ALT
	$HKCOMB_SC - SHIFT+CTRL
	$HKCOMB_SA - SHIFT+ALT
	$HKCOMB_CA - CTRL+ALT
	$HKCOMB_SCA - SHIFT+CTRL+ALT

	Modifiers: (this modifiers are established when pressed "Invalid keys")
	$HOTKEYF_SHIFT - SHIFT
	$HOTKEYF_CONTROL - CTRL
	$HOTKEYF_ALT - ALT
	$HOTKEYF_EXT - Extra key
----------------------------------------------
#ce

Global $HotKey
$gui_Main = GUICreate('Get Hotkey', 220, 90)

$bt = GUICtrlCreateButton('See Value', 10, 50, 200, 30);
GUICtrlSetState(-1, $GUI_DEFBUTTON)

$hWnd=_GuiCtrlHotKey_Create($gui_Main,10,10,180,25,0) 								;	<= Create Hotkey
;_GuiCtrlHotKey_SetRules($hWnd,$HKCOMB_S)											;	<= Set rules for Hotkey (blocks shift-key)
;_GuiCtrlHotKey_SetRules($hWnd,$HKCOMB_C,BitOr($HOTKEYF_CONTROL,$HOTKEYF_ALT))		;	<= Set rules for Hotkey (pressing ctrl = ctrl+alt)

Send("{NUMLOCK on}")
GUISetState()

While 1
	Switch GUIGetMsg()
	Case $GUI_EVENT_CLOSE
		Exit
	Case $bt
		$hotkey_info=_GuiCtrlHotKey_GetFullInfo($hWnd)	;	<= Get Info about Hotkey
		If $hotkey_info<>-1 Then
			MsgBox(64,"Information","HotKey format: " & $hotkey_info[0] & _
							@CRLF & "Normal format: " & $hotkey_info[1] & _
							@CRLF & "HotKey value: " & $hotkey_info[2])			
			HotKeySet($hotkey) ; clear previous hotkey
			$hotkey=$hotkey_info[0]			
			HotKeySet($hotkey,"hello")
		Endif
	EndSwitch
WEnd

Func hello()
	MsgBox(64,"","Hello!")
EndFunc