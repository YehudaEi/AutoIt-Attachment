#include-once
#include <GUIConstantsEx.au3>
#include <WinAPI.au3>
#include <WindowsConstants.au3>

; #CURRENT# =====================================================================================================================
;_GuiCtrlHotKey_Create
;_GuiCtrlHotKey_GetFullInfo
;_GuiCtrlHotKey_GetHotkey
;_GuiCtrlHotKey_SetHotkey
;_GuiCtrlHotKey_GetFormat
;_GuiCtrlHotKey_SetRules
; ===============================================================================================================================

Global Const $HKM_SETHOTKEY = $WM_USER + 1
Global Const $HKM_GETHOTKEY = $WM_USER + 2
Global Const $HKM_SETRULES = $WM_USER + 3

Global Const $HOTKEYF_SHIFT = 0x01
Global Const $HOTKEYF_CONTROL = 0x02
Global Const $HOTKEYF_ALT = 0x04
Global Const $HOTKEYF_EXT = 0x08; Extended(Extra) key


; invalid key combinations
Global Const $HKCOMB_NONE = 0x1; Unmodified keys
Global Const $HKCOMB_S = 0x2; SHIFT
Global Const $HKCOMB_C = 0x4; CTRL
Global Const $HKCOMB_A = 0x8; ALT
Global Const $HKCOMB_SC = 0x10; SHIFT+CTRL
Global Const $HKCOMB_SA = 0x20; SHIFT+ALT
Global Const $HKCOMB_CA = 0x40; CTRL+ALT
Global Const $HKCOMB_SCA = 0x80; SHIFT+CTRL+ALT

; #FUNCTION# ====================================================================================================================
; Name...........: _GuiCtrlHotKey_Create
; Description ...: Create a HotKey control
; Syntax.........: _GuiCtrlHotKey_Create($hWnd, $iX, $iY[, $iWidth = 150[, $iHeight = 20[, $iBold=0]]])
; Parameters ....: $hWnd    - Handle to GUI window
;                  $iX      - The left side of the control
;				   $iY      - The top of the control
;                  $iWidth  - The width of the control
;                  $iHeigth - The height of the control
;                  $iBold   - Sets bold style for the font
; Return values .: Success - Handle to the HotKey control
;                  Failure - 0
; ===============================================================================================================================

Func _GuiCtrlHotKey_Create($hWnd, $iX, $iY, $iWidth = 150, $iHeight = 20, $iBold=0)
	Local $hHotkey = _WinAPI_CreateWindowEx (0, 'msctls_hotkey32', '', BitOR($WS_CHILD, $WS_VISIBLE, $WS_TABSTOP), $iX, $iY, $iWidth, $iHeight, $hWnd)
	If NOT $iBold Then _SendMessage($hHotkey, 0x0030, 0x018A0029) ; sets normal font for hotkey control (non-bold)
	return $hHotkey
EndFunc

; #FUNCTION# ====================================================================================================================
; Name...........: _GuiCtrlHotKey_GetHotkey
; Description ...: Get number identifying pressed keys in HotKey control
; Syntax.........: _GuiCtrlHotKey_GetHotkey($hHotKey)
; Parameters ....: $hWnd    - Handle to GUI window
; Return values .: Success - Returns HotKey number
;                  Failure - 0
; ===============================================================================================================================

Func _GuiCtrlHotKey_GetHotkey($hHotKey)
	Local $hotkey=_SendMessage($hHotKey, $HKM_GETHOTKEY)
	return $hotkey
EndFunc

; #FUNCTION# ====================================================================================================================
; Name...........: _GuiCtrlHotKey_SetHotkey
; Description ...: Set Hotkey in HotKey Control
; Syntax.........: _GuiCtrlHotKey_SetHotkey($hHotKey, $value)
; Parameters ....: $hHotKey  - Handle to HotKey Control
;				   $value    - Number identifying pressed keys in HotKey control
; Return values .: Success - 1
;                  Failure - 0
; ===============================================================================================================================

Func _GuiCtrlHotKey_SetHotkey($hHotKey,$value)
	Local $result=_SendMessage($hHotKey, $HKM_SETHOTKEY,$value)
	return $result
EndFunc

; #FUNCTION# ====================================================================================================================
; Name...........: _GuiCtrlHotKey_GetFormat
; Description ...: Get Normal and HotKey format from unique HotKey number
; Syntax.........: _GuiCtrlHotKey_GetFormat($i_HotKeyFull)
; Parameters ....: $i_HotKeyFull  - Number identifying pressed keys in HotKey control
; Return values .: Success - Array with the following format:
;				   		     [0] - HotKey format
;                  			 [1] - Normal format
;                  Failure - -1
; ===============================================================================================================================

Func _GuiCtrlHotKey_GetFormat($i_HotKeyFull)
	Local $n_Flag = BitShift($i_HotKeyFull, 8); high byte
	Local $i_HotKeyReal = BitAND($i_HotKeyFull, 0xFF); low byte
	Local $normal_format,$hotkey_format,$chr_hotkey,$chr_normal,$i_HotKeyCut
	
	If BitAnd($n_Flag, $HOTKEYF_CONTROL) Then 
		$hotkey_format&= "^"
		$normal_format&="Ctrl+"
	Endif    
    	If BitAnd($n_Flag, $HOTKEYF_SHIFT) Then 
		$hotkey_format&="+"
		$normal_format&="Shift+"
	Endif
	If BitAnd($n_Flag, $HOTKEYF_ALT) Then
		$hotkey_format&="!"
		$normal_format&="Alt+"
	Endif

	If BitAnd($n_Flag, $HOTKEYF_EXT) Then
		$chr_hotkey=""
		Switch $i_HotKeyReal
			Case 33 
				$chr_hotkey="PGUP"
				$chr_normal="Page Up"
			Case 34 
				$chr_hotkey="PGDN"
				$chr_normal="Page Down"
			Case 35 
				$chr_hotkey="End"
				$chr_normal="End"
			Case 36 
				$chr_hotkey="Home"
				$chr_normal="Home"
			Case 37 
				$chr_hotkey="Left"
				$chr_normal="Left"
			Case 38 
				$chr_hotkey="Up"
				$chr_normal="Up"
			Case 39 
				$chr_hotkey="Right"
				$chr_normal="Right"
			Case 40 
				$chr_hotkey="Down"
				$chr_normal="Down"
			Case 45 
				$chr_hotkey="Ins"
				$chr_normal="Insert"
			Case 111 
				$chr_hotkey="NUMPADDIV"
				$chr_normal="Num /"
			Case 144 
				$chr_hotkey="NumLock"
				$chr_normal="Num Lock"
		EndSwitch
		If $chr_hotkey="" Then return -1
		$hotkey_format&="{" & $chr_hotkey & "}"
		$normal_format&=$chr_normal
	Else
		$i_HotKeyCut=$i_HotKeyReal
		If StringRegExp($i_HotKeyCut,"\b(45|35|40|34|37|12|39|36|38|33)\b") Then return -1    ;Remove Numpad 0-9 hotkeys when NumLock is off.
		Switch $i_HotKeyReal
			Case 186
				$i_HotKeyCut-=127
			Case 187
				$i_HotKeyCut-=126
			Case 128 to 191
				$i_HotKeyCut-=144
			Case 192
				$i_HotKeyCut-=96
			Case 222
				$i_HotKeyCut-=183
			Case 193 to 255
				$i_HotKeyCut-=128
		EndSwitch

		Switch $i_HotKeyReal
			Case 112 to 123
				$chr_hotkey="F" & ($i_HotKeyReal-111)
				$chr_normal=$chr_hotkey
			Case 96 to 105
				$chr_hotkey="NUMPAD" & ($i_HotKeyReal-96)
				$chr_normal="Num " & $i_HotKeyReal-96
			Case 106
				$chr_hotkey="NUMPADMULT"
				$chr_normal="Num *"
			Case 107
				$chr_hotkey="NUMPADADD"
				$chr_normal="Num +"
			Case 109
				$chr_hotkey="NUMPADSUB"
				$chr_normal="Num /"
			Case 110
				$chr_hotkey="NUMPADDOT"
				$chr_normal="Num ."
			Case 145
				$chr_hotkey="SCROLLLOCK"
				$chr_normal="Scroll Lock"
			Case 20
				$chr_hotkey="CAPSLOCK"
				$chr_normal="Caps Lock"
			Case Else
				$chr_hotkey=Chr($i_HotKeyCut)
				$chr_normal=$chr_hotkey
		EndSwitch	
		$hotkey_format&="{" & StringLower($chr_hotkey) & "}"
		$normal_format&=$chr_normal
	Endif

	If $i_HotKeyReal>0 Then
		Local $ret_format[3]
		$ret_format[0]=$hotkey_format
		$ret_format[1]=$normal_format
		return $ret_format
	Else
		return -1
	Endif
EndFunc

; #FUNCTION# ====================================================================================================================
; Name...........: _GuiCtrlHotKey_GetFullInfo
; Description ...: Get Normal and HotKey format and also HotKey number from HotKey Control
; Syntax.........: _GuiCtrlHotKey_GetFullInfo($hHotkey)
; Parameters ....: $hHotkey  - Handle to HotKey Control
; Return values .: Success - Array with the following format:
;				   		     [0] - HotKey format
;                  			 [1] - Normal format
;                  			 [2] - Hotkey number
;                  Failure - -1
; ===============================================================================================================================

Func _GuiCtrlHotKey_GetFullInfo($hHotkey)
	Local $hotkey=_GuiCtrlHotKey_GetHotkey($hHotkey)
	Local $hotkey_format=_GuiCtrlHotKey_GetFormat($hotkey)
	If $hotkey_format=-1 Then
		_SendMessage($hWnd, $HKM_SETHOTKEY)
		return -1
	Else
		Local $info[3]
		$info[0]=$hotkey_format[0]
		$info[1]=$hotkey_format[1]
		$info[2]=$hotkey
		return $info
	Endif
EndFunc

; #FUNCTION# ====================================================================================================================
; Name...........: _GuiCtrlHotKey_SetRules
; Description ...: Set rules for HotKey control
; Syntax.........: _GuiCtrlHotKey_SetRules($hHotkey, $invalid_combination[, $modifiers=0])
; Parameters ....: $hHotkey              - Handle to HotKey Control
; 				   $invalid_combination  - this combination will block
; 				   $modifiers  			 - this modifiers are established when pressed $invalid_combination
#cs
-----------Flags for rules:-----------
	$invalid_combination:
	$HKCOMB_NONE - Unmodified keys; it is blocked nothing, it is used only for "Modifiers"
	$HKCOMB_S - SHIFT
	$HKCOMB_C - CTRL
	$HKCOMB_A - ALT
	$HKCOMB_SC - SHIFT+CTRL
	$HKCOMB_SA - SHIFT+ALT
	$HKCOMB_CA - CTRL+ALT
	$HKCOMB_SCA - SHIFT+CTRL+ALT

	$modifiers:
	$HOTKEYF_SHIFT - SHIFT
	$HOTKEYF_CONTROL - CTRL
	$HOTKEYF_ALT - ALT
	$HOTKEYF_EXT - Extra key
----------------------------------------------
#ce
; Return values .: Success - 1
;                  Failure - 0
; ===============================================================================================================================

Func _GuiCtrlHotKey_SetRules($hHotkey,$invalid_combination,$modifiers=0)
	_SendMessage($hWnd, $HKM_SETRULES,$invalid_combination,$modifiers)
EndFunc