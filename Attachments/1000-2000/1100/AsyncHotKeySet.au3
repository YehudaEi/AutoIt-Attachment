#include-once
; --------------------------------------------------------------------------------
; File: AsyncHotKeySet.au3
;
; Desc: "Async" emulation of HotKeySet, inspired by the _IsPressed() code by ezzetabi
;       <http://www.autoitscript.com/forum/index.php?showuser=839> posted at
;       <http://www.autoitscript.com/forum/index.php?showtopic=5760>.
;
; Auth: Berean <http://www.autoitscript.com/forum/index.php?showuser=4581>.
; --------------------------------------------------------------------------------

; Constants
$ahks_kMaxKeys = 256
$ahks_kKeyCode = 0
$ahks_kKeyUserFunction = 1
$ahks_kKeyLastState = 2
$ahks_kMaxIndices = 3
$ahks_kMaxKeyTranslations = 0xA6

; Globals
$ahks_CurrentKeyCount = 0
Dim $ahks_keyMap[$ahks_kMaxKeys][$ahks_kMaxIndices]
Dim $ahks_vkTranslationMap[$ahks_kMaxKeyTranslations]

; Mapping of AutoIt Send()-style key descriptors to Windows Virtual Key codes.  Where
; there was not an equivalent AutoIt descriptor, I made one up and prefixed it with an
; underscore.  If the Virtual Key code is undefined, the hex value is used.
;
; Because these are keys, there are no entries for shifted values such as capital letters
; or punctuation.
$ahks_vkTranslationMap[0x00] = "0x00" ; Undefined
$ahks_vkTranslationMap[0x01] = "{_MOUSEBUTTON1}" ; Left mouse button
$ahks_vkTranslationMap[0x02] = "{_MOUSEBUTTON2}" ; Right mouse button;does not works in my system...
$ahks_vkTranslationMap[0x03] = "0x03" ; Undefined
$ahks_vkTranslationMap[0x04] = "{_MOUSEBUTTON3}" ; Middle mouse button (three-button mouse)
$ahks_vkTranslationMap[0x05] = "{_MOUSEBUTTONX1}" ; Windows 2000/XP: X1 mouse button
$ahks_vkTranslationMap[0x06] = "{_MOUSEBUTTONX2}" ; Windows 2000/XP: X2 mouse button
$ahks_vkTranslationMap[0x07] = "0x07" ; Undefined
$ahks_vkTranslationMap[0x08] = "{BACKSPACE}" ; BACKSPACE
$ahks_vkTranslationMap[0x09] = "{TAB}" ; TAB
$ahks_vkTranslationMap[0x0A] = "0x0A" ; Undefined
$ahks_vkTranslationMap[0x0B] = "0x0B" ; Undefined
$ahks_vkTranslationMap[0x0C] = "{_CLEAR}" ; CLEAR
$ahks_vkTranslationMap[0x0D] = "{ENTER}" ; ENTER
$ahks_vkTranslationMap[0x0E] = "0x0E" ; Undefined
$ahks_vkTranslationMap[0x0F] = "0x0F" ; Undefined
$ahks_vkTranslationMap[0x10] = "{_SHIFT}" ; SHIFT
$ahks_vkTranslationMap[0x11] = "{_CTRL}" ; CTRL
$ahks_vkTranslationMap[0x12] = "{_ALT}" ; ALT
$ahks_vkTranslationMap[0x13] = "{PAUSE}" ; PAUSE
$ahks_vkTranslationMap[0x14] = "{CAPSLOCK}" ; CAPS LOCK
$ahks_vkTranslationMap[0x15] = "0x15" ; Undefined
$ahks_vkTranslationMap[0x16] = "0x16" ; Undefined
$ahks_vkTranslationMap[0x17] = "0x17" ; Undefined
$ahks_vkTranslationMap[0x18] = "0x18" ; Undefined
$ahks_vkTranslationMap[0x19] = "0x19" ; Undefined
$ahks_vkTranslationMap[0x1A] = "0x1A" ; Undefined
$ahks_vkTranslationMap[0x1B] = "{ESC}" ; ESC
$ahks_vkTranslationMap[0x1C] = "0x1C" ; Undefined
$ahks_vkTranslationMap[0x1D] = "0x1D" ; Undefined
$ahks_vkTranslationMap[0x1E] = "0x1E" ; Undefined
$ahks_vkTranslationMap[0x1F] = "0x1F" ; Undefined
$ahks_vkTranslationMap[0x20] = "{SPACE}" ; SPACEBAR
$ahks_vkTranslationMap[0x21] = "{PGUP}" ; PAGE UP
$ahks_vkTranslationMap[0x22] = "{PGDN}" ; PAGE DOWN
$ahks_vkTranslationMap[0x23] = "{END}" ; END
$ahks_vkTranslationMap[0x24] = "{HOME}" ; HOME
$ahks_vkTranslationMap[0x25] = "{LEFT}" ; LEFT ARROW
$ahks_vkTranslationMap[0x26] = "{UP}" ; UP ARROW
$ahks_vkTranslationMap[0x27] = "{RIGHT}" ; RIGHT ARROW
$ahks_vkTranslationMap[0x28] = "{DOWN}" ; DOWN ARROW
$ahks_vkTranslationMap[0x29] = "{_SELECT}" ; SELECT
$ahks_vkTranslationMap[0x2A] = "{_PRINT}" ; PRINT
$ahks_vkTranslationMap[0x2B] = "{_EXECUTE}" ; EXECUTE
$ahks_vkTranslationMap[0x2C] = "{PRINTSCREEN}" ; PRINT SCREEN
$ahks_vkTranslationMap[0x2D] = "{INSERT}" ; INS
$ahks_vkTranslationMap[0x2E] = "{DELETE}" ; DEL
$ahks_vkTranslationMap[0x2F] = "0x2F" ; Undefined
$ahks_vkTranslationMap[0x30] = "0" ; 0
$ahks_vkTranslationMap[0x31] = "1" ; 1
$ahks_vkTranslationMap[0x32] = "2" ; 2
$ahks_vkTranslationMap[0x33] = "3" ; 3
$ahks_vkTranslationMap[0x34] = "4" ; 4
$ahks_vkTranslationMap[0x35] = "5" ; 5
$ahks_vkTranslationMap[0x36] = "6" ; 6
$ahks_vkTranslationMap[0x37] = "7" ; 7
$ahks_vkTranslationMap[0x38] = "8" ; 8
$ahks_vkTranslationMap[0x39] = "9" ; 9
$ahks_vkTranslationMap[0x3A] = "0x3A" ; Undefined
$ahks_vkTranslationMap[0x3B] = "0x3B" ; Undefined
$ahks_vkTranslationMap[0x3C] = "0x3C" ; Undefined
$ahks_vkTranslationMap[0x3D] = "0x3D" ; Undefined
$ahks_vkTranslationMap[0x3E] = "0x3E" ; Undefined
$ahks_vkTranslationMap[0x3F] = "0x3F" ; Undefined
$ahks_vkTranslationMap[0x40] = "0x40" ; Undefined
$ahks_vkTranslationMap[0x41] = "A" ; A
$ahks_vkTranslationMap[0x42] = "B" ; B
$ahks_vkTranslationMap[0x43] = "C" ; C
$ahks_vkTranslationMap[0x44] = "D" ; D
$ahks_vkTranslationMap[0x45] = "E" ; E
$ahks_vkTranslationMap[0x46] = "F" ; F
$ahks_vkTranslationMap[0x47] = "G" ; G
$ahks_vkTranslationMap[0x48] = "H" ; H
$ahks_vkTranslationMap[0x49] = "I" ; I
$ahks_vkTranslationMap[0x4A] = "J" ; J
$ahks_vkTranslationMap[0x4B] = "K" ; K
$ahks_vkTranslationMap[0x4C] = "L" ; L
$ahks_vkTranslationMap[0x4D] = "M" ; M
$ahks_vkTranslationMap[0x4E] = "N" ; N
$ahks_vkTranslationMap[0x4F] = "O" ; O
$ahks_vkTranslationMap[0x50] = "P" ; P
$ahks_vkTranslationMap[0x51] = "Q" ; Q
$ahks_vkTranslationMap[0x52] = "R" ; R
$ahks_vkTranslationMap[0x53] = "S" ; S
$ahks_vkTranslationMap[0x54] = "T" ; T
$ahks_vkTranslationMap[0x55] = "U" ; U
$ahks_vkTranslationMap[0x56] = "V" ; V
$ahks_vkTranslationMap[0x57] = "W" ; W
$ahks_vkTranslationMap[0x58] = "X" ; X
$ahks_vkTranslationMap[0x59] = "Y" ; Y
$ahks_vkTranslationMap[0x5A] = "Z" ; Z
$ahks_vkTranslationMap[0x5B] = "{LWIN}" ; Left Windows
$ahks_vkTranslationMap[0x5C] = "{RWIN}" ; Right Windows
$ahks_vkTranslationMap[0x5D] = "0x5D" ; Undefined
$ahks_vkTranslationMap[0x5E] = "0x5E" ; Undefined
$ahks_vkTranslationMap[0x5F] = "0x5F" ; Undefined
$ahks_vkTranslationMap[0x60] = "{NUMPAD0}" ; Numeric keypad 0
$ahks_vkTranslationMap[0x61] = "{NUMPAD1}" ; Numeric keypad 1
$ahks_vkTranslationMap[0x62] = "{NUMPAD2}" ; Numeric keypad 2
$ahks_vkTranslationMap[0x63] = "{NUMPAD3}" ; Numeric keypad 3
$ahks_vkTranslationMap[0x64] = "{NUMPAD4}" ; Numeric keypad 4
$ahks_vkTranslationMap[0x65] = "{NUMPAD5}" ; Numeric keypad 5
$ahks_vkTranslationMap[0x66] = "{NUMPAD6}" ; Numeric keypad 6
$ahks_vkTranslationMap[0x67] = "{NUMPAD7}" ; Numeric keypad 7
$ahks_vkTranslationMap[0x68] = "{NUMPAD8}" ; Numeric keypad 8
$ahks_vkTranslationMap[0x69] = "{NUMPAD9}" ; Numeric keypad 9
$ahks_vkTranslationMap[0x6A] = "{NUMPADMULT}" ; Multiply
$ahks_vkTranslationMap[0x6B] = "{NUMPADADD}" ; Add
$ahks_vkTranslationMap[0x6C] = "{_SEPARATOR}" ; Separator
$ahks_vkTranslationMap[0x6D] = "{NUMPADSUB}" ; Subtract
$ahks_vkTranslationMap[0x6E] = "{NUMPADDOT}" ; Decimal
$ahks_vkTranslationMap[0x6F] = "{NUMPADDIV}" ; Divide
$ahks_vkTranslationMap[0x70] = "{F1}" ; F1
$ahks_vkTranslationMap[0x71] = "{F2}" ; F2
$ahks_vkTranslationMap[0x72] = "{F3}" ; F3
$ahks_vkTranslationMap[0x73] = "{F4}" ; F4
$ahks_vkTranslationMap[0x74] = "{F5}" ; F5
$ahks_vkTranslationMap[0x75] = "{F6}" ; F6
$ahks_vkTranslationMap[0x76] = "{F7}" ; F7
$ahks_vkTranslationMap[0x77] = "{F8}" ; F8
$ahks_vkTranslationMap[0x78] = "{F9}" ; F9
$ahks_vkTranslationMap[0x79] = "{F10}" ; F10
$ahks_vkTranslationMap[0x7A] = "{F11}" ; F11
$ahks_vkTranslationMap[0x7B] = "{F12}" ; F12
$ahks_vkTranslationMap[0x7C] = "{F13}" ; F13
$ahks_vkTranslationMap[0x7D] = "{F14}" ; F14
$ahks_vkTranslationMap[0x7E] = "{F15}" ; F15
$ahks_vkTranslationMap[0x7F] = "{F16}" ; F16
$ahks_vkTranslationMap[0x80] = "{F17}" ; F17
$ahks_vkTranslationMap[0x81] = "{F18}" ; F18
$ahks_vkTranslationMap[0x82] = "{F19}" ; F19
$ahks_vkTranslationMap[0x83] = "{F20}" ; F20
$ahks_vkTranslationMap[0x84] = "{F21}" ; F21
$ahks_vkTranslationMap[0x85] = "{F22}" ; F22
$ahks_vkTranslationMap[0x86] = "{F23}" ; F23
$ahks_vkTranslationMap[0x87] = "{F24}" ; F24
$ahks_vkTranslationMap[0x88] = "0x88" ; Undefined
$ahks_vkTranslationMap[0x89] = "0x89" ; Undefined
$ahks_vkTranslationMap[0x8A] = "0x8A" ; Undefined
$ahks_vkTranslationMap[0x8B] = "0x8B" ; Undefined
$ahks_vkTranslationMap[0x8C] = "0x8C" ; Undefined
$ahks_vkTranslationMap[0x8D] = "0x8D" ; Undefined
$ahks_vkTranslationMap[0x8E] = "0x8E" ; Undefined
$ahks_vkTranslationMap[0x8F] = "0x8F" ; Undefined
$ahks_vkTranslationMap[0x90] = "{NUMLOCK}" ; NUM LOCK
$ahks_vkTranslationMap[0x91] = "{SCROLLLOCK}" ; SCROLL LOCK
$ahks_vkTranslationMap[0x92] = "0x92" ; Undefined
$ahks_vkTranslationMap[0x93] = "0x93" ; Undefined
$ahks_vkTranslationMap[0x94] = "0x94" ; Undefined
$ahks_vkTranslationMap[0x95] = "0x95" ; Undefined
$ahks_vkTranslationMap[0x96] = "0x96" ; Undefined
$ahks_vkTranslationMap[0x97] = "0x97" ; Undefined
$ahks_vkTranslationMap[0x98] = "0x98" ; Undefined
$ahks_vkTranslationMap[0x99] = "0x99" ; Undefined
$ahks_vkTranslationMap[0x9A] = "0x9A" ; Undefined
$ahks_vkTranslationMap[0x9B] = "0x9B" ; Undefined
$ahks_vkTranslationMap[0x9C] = "0x9C" ; Undefined
$ahks_vkTranslationMap[0x9D] = "0x9D" ; Undefined
$ahks_vkTranslationMap[0x9E] = "0x9E" ; Undefined
$ahks_vkTranslationMap[0x9F] = "0x9F" ; Undefined
$ahks_vkTranslationMap[0xA0] = "{LSHIFT}" ; Left SHIFT
$ahks_vkTranslationMap[0xA1] = "{RSHIFT}" ; Right SHIFT
$ahks_vkTranslationMap[0xA2] = "{LCTRL}" ; Left CONTROL
$ahks_vkTranslationMap[0xA3] = "{RCTRL}" ; Right CONTROL
$ahks_vkTranslationMap[0xA4] = "{_LMENU}" ; Left MENU
$ahks_vkTranslationMap[0xA5] = "{_RMENU}" ; Right MENU

; --------------------------------------------------------------------------------
; AsyncHotKeySet
; Add/remove a hotkey function.
Func AsyncHotKeySet($inSendKey,$inUserFunction)
	if $inUserFunction <> "" then
		_ahks_KeyAdd($inSendKey,$inUserFunction)
	else
		_ahks_KeyRemove($inSendKey)
	endif
EndFunc

; --------------------------------------------------------------------------------
; AsyncHotKeyPoll
; Poll for key transitions and dispatch to user functions.
Func AsyncHotKeyPoll()
	Local $index, $state, $arrayResult
	
	; Poll each key we are watching.
	for $index = 0 to $ahks_CurrentKeyCount - 1
		$arrayResult = DllCall("user32", "int", "GetAsyncKeyState", "int", $ahks_keyMap[$index][$ahks_kKeyCode])
		if @error then
			return
		endif
		$state = $arrayResult[0]
		
		; Did the key state change?
		if $state <> $ahks_keyMap[$index][$ahks_kKeyLastState] then
			$ahks_keyMap[$index][$ahks_kKeyLastState] = $state
			; Did the key transition to the down state?  If so, call the user
			; function.
			if BitAND($state, 0x8000) = 0x8000 then
				Call($ahks_keyMap[$index][$ahks_kKeyUserFunction])
			endif
		endif
	next
EndFunc

; --------------------------------------------------------------------------------
; _ahks_KeyAdd
; Add a key/function pair to the table.
Func _ahks_KeyAdd($inSendKey,$inUserFunction)
	Local $index, $keyCode
	
	; Translate from the AutoIt Send()-style key specifier to a Windows Virtual
	; Key code.
	$keyCode = _ahks_MapSendKeyToVirtualKey($inSendKey)
	if @error then
		return
	endif
	
	; Search for a match in the existing table.
	for $index = 0 to $ahks_CurrentKeyCount - 1
		if $ahks_keyMap[$index][$ahks_kKeyCode] = $keyCode then
			ExitLoop
		endif
	next
	
	; This shouldn't happen but check just to be safe.
	if $index >= $ahks_kMaxKeys then
		SetError(-1)
		return
	endif
	
	; Add the key.
	$ahks_keyMap[$index][$ahks_kKeyCode] = $keyCode
	$ahks_keyMap[$index][$ahks_kKeyUserFunction] = $inUserFunction
	$ahks_keyMap[$index][$ahks_kKeyLastState] = 0
	
	; Bump the array count if we extended the array.
	if $index = $ahks_CurrentKeyCount then
		$ahks_CurrentKeyCount = $ahks_CurrentKeyCount + 1
	endif
EndFunc

; --------------------------------------------------------------------------------
; _ahks_KeyRemove
; Remove a key/function pair from the table.
Func _ahks_KeyRemove($inSendKey)
	Local $index, $index2, $keyCode
	
	; Translate from the AutoIt Send()-style key specifier to a Windows Virtual
	; Key code.
	$keyCode = _ahks_MapSendKeyToVirtualKey($inSendKey)
	if @error then
		return
	endif
	
	; Search for a match in the existing table.
	for $index = 0 to $ahks_CurrentKeyCount - 1
		if $ahks_keyMap[$index][$ahks_kKeyCode] = $keyCode then
			ExitLoop
		endif
	next
	
	; Not found?
	if $index = $ahks_CurrentKeyCount then
		return
	endif
	
	; Remove the key and shift the remaining keys back in the array.
	for $index2 = $index to $ahks_CurrentKeyCount - 1
		$ahks_keyMap[$index2][$ahks_kKeyCode] = $ahks_keyMap[$index2 + 1][$ahks_kKeyCode]
		$ahks_keyMap[$index2][$ahks_kKeyUserFunction] = $ahks_keyMap[$index2 + 1][$ahks_kKeyUserFunction]
		$ahks_keyMap[$index2][$ahks_kKeyLastState] = $ahks_keyMap[$index2 + 1][$ahks_kKeyLastState]
	next
	
	; Decrement key count.
	if $ahks_CurrentKeyCount > 0 then
		$ahks_CurrentKeyCount = $ahks_CurrentKeyCount - 1
	endif
EndFunc

; --------------------------------------------------------------------------------
; _ahks_MapSendKeyToVirtualKey
; Translate the AutoIt Send()-style key specifier to a Windows Virtual Key code.
Func _ahks_MapSendKeyToVirtualKey($inSendKey)
	Local $virtualKey
	
	; Find the matching key code.
	$inSendKey = StringUpper($inSendKey)
	for $virtualKey = 0 to $ahks_kMaxKeyTranslations - 1
		if $ahks_vkTranslationMap[$virtualKey] = $inSendKey then
			return $virtualKey
		endif
	next
	
	; Not found.
	MsgBox(0,"Virtual Key", "Key " & $inSendKey & " not found." )
	SetError(-1)
	return
EndFunc
