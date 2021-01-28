#include-once
; ================================================================================================
; <_AsyncHotKeySet.au3>
;
; 'Asynchronous' emulation of HotKeySet, utilizing _IsPressed() function
;   (Great workaround for programs/games that disable hotkeys and/or keyboard hooks)
;
; NOTE: The functions BEING called *must* have *ONE* parameter, which is a keystate indicator
;      (True = all keys pressed, False = all keys released)
;      These are both only called once per press/release cycle. (Keys held down do not send multiple messages)
;
; --------------------------------------------------------------------------------------
; Original Author's Description:
;    Desc: "Async" emulation of HotKeySet, inspired by the _IsPressed() code by ezzetabi
;       <http://www.autoitscript.com/forum/index.php?showuser=839> posted at
;       <http://www.autoitscript.com/forum/index.php?showtopic=5760>.
;    Auth: Berean <http://www.autoitscript.com/forum/index.php?showuser=4581>.
;   Original code @: http://www.autoitscript.com/forum/index.php?showtopic=8220
; --------------------------------------------------------------------------------------
;
; Functions:
;   AsyncHotKeySet()   ; adds a key(+optional modifiers) & function to the internal table
;   AsyncHotKeyUnSet() ; removes a key(+optional modifiers) & function from the internal table
;   AsyncHotKeyPoll()  ; Polls the state of all the keys/functions in the internal table, calls appropriate functions
;
; INTERNAL Functions:
;   __IsPressed()    ; Tests if a given key (numerical codes only!) is set/unset. Can be called externally
;   _ahks_KeyAdd()  ; Adds a key(+optional modifiers) & function to the internal table
;   _ahks_KeyRemove()  ; Removes a key(+optional modifiers) & function from the internal table
;   _ahks_MapSendKeyToVirtualKey() ; Maps the AutoIT-style string key representations (see Send()) into actual numerical codes
;   
;   Author(s): ezzetabi and Jon: Original _IsPressed() <from Misc.au3>, Berean: Original AsyncHotKeySet code
;      Ascend4nt: Rewrite of AsyncHotKeyPoll(), other modifications & cleanup, plus the addition of modifier keys
; ================================================================================================

;   ====================    CONSTANTS ====================

Global Const $ahks_kMaxKeys=256  ; maximum # of key/function combos for internal table
; Column indexes into key/function combination table:
Global Enum $ahks_kKeyCode=0, $ahks_kKeyUserFunction, $ahks_kKeyLastState, $ahks_kModifier, $ahks_kModifier2
; Bit States of key, modifer1 & modifier 2, plus indicator of whether the full hotkey was invoked previously
Global Const $ahks_MainKeyBit=1, $ahks_ModifierBit=2, $ahks_Modifier2Bit=4, $ahks_HotKeyInvokedBit=16
Global Const $ahks_kMaxIndices=5        ; # of columns in key/function combination table. Added 2 for modifier keys
Global Const $ahks_kMaxKeyTranslations=0xA6

;   ====================   GLOBALS    ====================

Global $ahks_CurrentKeyCount=0    ; count of key/function combos in internal table
Dim $ahks_keyMap[$ahks_kMaxKeys][$ahks_kMaxIndices]  ; AsyncHotKey internal table
Dim $ahks_vkTranslationMap[$ahks_kMaxKeyTranslations]   ; Key Translation Table

;   ========== KEY TRANSLATION TABLE INITIALIZATION ==========

; ---------------------------------------------------------------------------------------
; Mapping of AutoIt Send()-style key descriptors to Windows Virtual Key codes.  Where
; there was not an equivalent AutoIt descriptor, I made one up and prefixed it with an
; underscore.  If the Virtual Key code is undefined, the hex value is used.
;
; *Because these are keys, there are no entries for shifted values such as capital letters
; or punctuation.
; ---------------------------------------------------------------------------------------

$ahks_vkTranslationMap[0x00] = "0x00" ; Undefined
$ahks_vkTranslationMap[0x01] = "{_MOUSEBUTTON1}" ; Left mouse button
$ahks_vkTranslationMap[0x02] = "{_MOUSEBUTTON2}" ; Right mouse button;does not works in my system...
$ahks_vkTranslationMap[0x03] = "0x03" ; Undefined   VK_CANCEL
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


; ================================================================================================
; Func AsyncHotKeySet($inSendKey,$inModifierKey1,$inModifierKey2,$inUserFunction)
;
; Add/remove a hotkey(+optional modifiers) & function to/from the internal table.
;
; $inSendKey = main keystroke (in AutoIT Send()-style string format)
; $inModifierKey1 = 1st (optional) modifier key (Shift,Ctrl,Alt), (in AutoIT Send()-style string format)
; $inModifierKey2 = 2nd (optional) modifier key (Shift,Ctrl,Alt), (in AutoIT Send()-style string format)
; $inUserFunction = User Function to call when the entire key combination is pressed
;      (the function will be called only from the AsyncHotKeyPoll() function)
; NOTE: The functions to call must have *ONE* parameter, which is a keystate indicator ($bAllKeysPressed)
;      (True = all keys pressed, False = all keys released)
;      These are both only called once per press/release cycle. (Keys held down do not send multiple messages)
;
; Returns:
;   Success: True, @error = 0
;   Failure: False, @error set:
;      @error = 1 = invalid key
;      @error = 2 = could not locate key mapping combination in internal table (remove only)
;      @error = 4 = key mapping combination already mapped to another function in internal table (add only)
;      @error = -1 = Maximum # of key/function combinations has been reached, can't add more (add only)
;
; Author(s): Berean (original code), Ascend4nt: addition of modifier keys, True/False + @error returns
; ================================================================================================

Func AsyncHotKeySet($inSendKey,$inModifierKey1,$inModifierKey2,$inUserFunction)
    Local $vRet
    ; Function passed?
    If $inUserFunction<>"" Then
        $vRet=_ahks_KeyAdd($inSendKey,$inModifierKey1,$inModifierKey2,$inUserFunction)
    Else
        ; "" passed, meaning 'Remove' HotKey
        $vRet=_ahks_KeyRemove($inSendKey,$inModifierKey1,$inModifierKey2)
    Endif
    Return SetError(@error,0,$vRet)
EndFunc

; ================================================================================================
; Func AsyncHotKeyUnSet($inSendKey,$inModifierKey1,$inModifierKey2)
;
; Removes a hotkey(+optional modifiers) & its function from internal table.
;   Same information/return as AsyncHotKeySet().
;   This function exists solely for the purpose of clarity
;
;   Success: True, @error = 0
;   Failure: False, @error set:
;      @error = 1 = invalid key
;      @error = 2 = could not locate key mapping combination in internal table (remove only)
;
; Author: Ascend4nt
; ================================================================================================

Func AsyncHotKeyUnSet($inSendKey,$inModifierKey1,$inModifierKey2)
    Local $vRet=AsyncHotKeySet($inSendKey,$inModifierKey1,$inModifierKey2,"")
    Return SetError(@error,0,$vRet)
EndFunc


; ================================================================================================
; Func __IsPressed($iKey,$hDLL='user32.dll')
;
; Checks if a key has been pressed.
; Taken from <Misc.au3>, modified to work on numbers instead of strings
;
; $iKey = numerical key code of key to check
; $hDLL = handle to user32.dll (optional)
;
; Returns:
;   Success: @error is clear, and either True (key is pressed) or False (key is not pressed)
;   Failure: @error is set to one of DllCall()'s errors, False is returned
;
; Author(s): ezzetabi and Jon: Original _IsPressed() function <Misc.au3>,
;   Ascend4nt (modified function to work on #'s instead of strings, + returns True/False now)
; ================================================================================================

Func __IsPressed($iKey,$hDLL='user32.dll')
    ; _Is_Key_Pressed will return 0 if the key is not pressed, 1 if it is.
    Local $a_R = DllCall($hDLL, "int", "GetAsyncKeyState", "int", $iKey)
    If Not @error And BitAND($a_R[0], 0x8000) = 0x8000 Then Return True
    Return False
EndFunc

; ================================================================================================
; Func AsyncHotKeyPoll($hDLL)
;
; Check if required keys are set for the list of functions to call, and calls the function when those keys are pressed.
;
; $hDLL = handle to user32.dll, returned from a call to DLLOpen('user32.dll').
;   NOTE: It is HIGHLY recommended the DLLOpen be performed before all polling takes place, as otherwise
;    it will slow down the function/processing.
;
; Returns:
;   Nothing.
;
; Author: Ascend4nt: Complete rewrite of Berean's code, addition of modifier keys, & Berean (original code)
; ================================================================================================

Func AsyncHotKeyPoll($hDLL)
    If $hDLL=-1 Then $hDLL='user32.dll'
    Local $index,$iKeyLastState,$iAllHotKeyBits
   
    ; Poll each key we are watching.
    For $index=0 To $ahks_CurrentKeyCount-1
        ; Get the last key-state(s) from array
        $iKeyLastState=$ahks_keyMap[$index][$ahks_kKeyLastState]

        ; Main key code pressed?
        If __IsPressed($ahks_keyMap[$index][$ahks_kKeyCode],$hDLL) Then
            ; Find out what the full 'ON' number would be for all-keys-pressed. (additions below)
            $iAllHotKeyBits=$ahks_MainKeyBit
       
            ; Ensure Last State reflects that the Main Key is pressed.
            $iKeyLastState=BitOR($iKeyLastState,$ahks_MainKeyBit)
                       
            ; At least 1 Modifier Key present? Add to full 'ON' number, then check pressed-state
            If $ahks_keyMap[$index][$ahks_kModifier]<>"" Then
                $iAllHotKeyBits+=$ahks_ModifierBit
                ; Is the modifier Key pressed? Ensure the Last State reflects this.
                If __IsPressed($ahks_keyMap[$index][$ahks_kModifier],$hDLL) Then $iKeyLastState=BitOR($iKeyLastState,$ahks_ModifierBit)    
            EndIf
           
            ; A 2nd Modifier Key present? Add to full 'ON' number, then check pressed-state
            If $ahks_keyMap[$index][$ahks_kModifier2]<>"" Then
                $iAllHotKeyBits+=$ahks_Modifier2Bit
                ; Is the modifier Key pressed? Ensure the Last State reflects this.
                If __IsPressed($ahks_keyMap[$index][$ahks_kModifier2],$hDLL) Then $iKeyLastState=BitOR($iKeyLastState,$ahks_Modifier2Bit)            
            EndIf
           
            ; Are ALL keys set? (And $ahks_HotKeyInvokedBit not set?) Make the call!. [$ahks_HotKeyInvokedBit prevents continuous calls]
            If $iKeyLastState=$iAllHotKeyBits Then
                ; Make a call to the proc with an 'all-keys-pressed' message
                Call($ahks_keyMap[$index][$ahks_kKeyUserFunction],True)
                ; Make certain continuous calls aren't made while the keys are held down, & also allow notification when all released
                $iKeyLastState+=$ahks_HotKeyInvokedBit
            EndIf

        Else
        ; Main Key *not* pressed if got here
           
            ; Is the Main Key last-state 'ON'? Clear/Reset it to OFF.
            If BitAND($iKeyLastState,$ahks_MainKeyBit) Then $iKeyLastState=BitXOR($iKeyLastState,$ahks_MainKeyBit)
           
            ; Modifier 1 Bit set, and no longer pressed? (which means there's obviously a modifier 1 key) Clear 'pressed' bit.
            If BitAND($iKeyLastState,$ahks_ModifierBit) And Not __IsPressed($ahks_keyMap[$index][$ahks_kModifier],$hDLL) Then
                $iKeyLastState=BitXOR($iKeyLastState,$ahks_ModifierBit)
            EndIf
           
            ; Modifier 2 Bit set, and no longer pressed? (which means there's obviously a modifier 2 key) Clear 'pressed' bit.
            If BitAND($iKeyLastState,$ahks_Modifier2Bit) And Not __IsPressed($ahks_keyMap[$index][$ahks_kModifier2],$hDLL) Then
                $iKeyLastState=BitXOR($iKeyLastState,$ahks_Modifier2Bit)
            EndIf
           
            ; ALL keys switched off? (and were they previously all pressed?)
            If $iKeyLastState=$ahks_HotKeyInvokedBit Then
                ; Make a call to the proc with an 'all-keys-released' message
                Call($ahks_keyMap[$index][$ahks_kKeyUserFunction],False)
                ; Completely reset state
                $iKeyLastState=0
            EndIf         
        EndIf
        ; Assign state back to array
        $ahks_keyMap[$index][$ahks_kKeyLastState]=$iKeyLastState
    Next
    Return
EndFunc

; ================================================================================================
; Func _ahks_KeyAdd($inSendKey,$inModifierKey1,$inModifierKey2,$inUserFunction)
;
; Add a hotkey(+optional modifiers) & function to the internal table.
;
; $inSendKey = main keystroke (in AutoIT Send()-style string format)
; $inModifierKey1 = 1st (optional) modifier key (Shift,Ctrl,Alt), (in AutoIT Send()-style string format)
; $inModifierKey2 = 2nd (optional) modifier key (Shift,Ctrl,Alt), (in AutoIT Send()-style string format)
; $inUserFunction = User Function to call when the entire key combination is pressed
;      (the function will be called only from the AsyncHotKeyPoll() function)
;
; Returns:
;   Success: True, @error = 0
;   Failure: False, @error set:
;      @error = 1 = invalid key
;      @error = 4 = key mapping combination already mapped to another function in internal table
;      @error = -1 = Maximum # of key/function combinations has been reached, can't add more
;
; Author: Berean (original code), Ascend4nt: addition of modifier keys, cleanup, True/False + @error returns
; ================================================================================================

Func _ahks_KeyAdd($inSendKey,$inModifierKey1,$inModifierKey2,$inUserFunction)
    Local $index, $keyCode,$modifier1keyCode="",$modifier2keyCode=""

    ; Passed a second modifier but not a first? Put 2nd in 1st spot
    If $inModifierKey1="" And $inModifierKey2<>"" Then $inModifierKey1=$inModifierKey2
    ; Both modifiers the same? Get rid of 2nd modifier
    If $inModifierKey1=$inModifierKey2 Then $inModifierKey2=""
   
    ; We don't test if $inSendKey is the same as one of the modifiers
    ;   it would return a True result anyway when tested twice
   
    ; Translate from the AutoIt Send()-style key specifier to a Windows Virtual Key code.
    $keyCode=_ahks_MapSendKeyToVirtualKey($inSendKey)
    If @error Then Return SetError(@error,0,False)
   
    ; Translate modifier 1 key
    If $inModifierKey1<>"" Then
        $modifier1keyCode=_ahks_MapSendKeyToVirtualKey($inModifierKey1)
        If @error Then Return SetError(@error,0,False)
    EndIf
    ; .. and modifier 2 key
    If $inModifierKey2<>"" Then
        $modifier2keyCode=_ahks_MapSendKeyToVirtualKey($inModifierKey2)
        If @error Then Return SetError(@error,0,False)
    EndIf
   
    ; Search for a match in the existing table.
    For $index=0 To $ahks_CurrentKeyCount-1
        If $ahks_keyMap[$index][$ahks_kKeyCode]=$keyCode And _
            $ahks_keyMap[$index][$ahks_kModifier]=$modifier1keyCode And _
            $ahks_keyMap[$index][$ahks_kModifier2]=$modifier2keyCode Then
                ; Found a match. Is it already assigned to same function?
                If $ahks_keyMap[$index][$ahks_kKeyUserFunction]=$inUserFunction Then Return True
                ; The key combination is assigned to another function. BADDD
                Return SetError(4,0,False)
        EndIf         
    Next
   
    ; Have we reached the limit of maximum # of key/function combinations?
    If $index>=$ahks_kMaxKeys Then Return SetError(-1,@extended,False)
   
    ; Add the key. & modifiers
    $ahks_keyMap[$index][$ahks_kKeyCode] = $keyCode
    $ahks_keyMap[$index][$ahks_kModifier] = $modifier1keyCode
    $ahks_keyMap[$index][$ahks_kModifier2] = $modifier2keyCode
    $ahks_keyMap[$index][$ahks_kKeyUserFunction] = $inUserFunction
    $ahks_keyMap[$index][$ahks_kKeyLastState] = 0
   
    ; Bump the array count if we extended the array.
    If $index=$ahks_CurrentKeyCount Then $ahks_CurrentKeyCount+=1
    Return True
EndFunc

; ================================================================================================
; Func _ahks_KeyRemove($inSendKey,$inModifierKey1,$inModifierKey2)
;
; Removes a hotkey(+optional modifiers) & its function from internal table.
;
; Returns:
;   Success: True, @error = 0
;   Failure: False, @error set:
;      @error = 1 = invalid key
;      @error = 2 = could not locate key mapping combination in internal table
;
; Author: Berean (original code), Ascend4nt: addition of modifier keys, cleanup, True/False + @error returns
; ================================================================================================

Func _ahks_KeyRemove($inSendKey,$inModifierKey1,$inModifierKey2)
    Local $index, $index2, $keyCode,$modifier1keyCode="",$modifier2keyCode=""

    ; Passed a second modifier but not a first? Put 2nd in 1st spot
    If $inModifierKey1="" And $inModifierKey2<>"" Then $inModifierKey1=$inModifierKey2
    ; Both modifiers the same? Get rid of 2nd modifier
    If $inModifierKey1=$inModifierKey2 Then $inModifierKey2=""
   
    ; We don't test if $inSendKey is the same as one of the modifiers (same as _ahks_KeyAdd())
   
    ; Translate from the AutoIt Send()-style key specifier to a Windows Virtual Key code.
    $keyCode = _ahks_MapSendKeyToVirtualKey($inSendKey)
    If @error Then Return SetError(@error,0,False)
   
    ; Translate modifier 1 key
    If $inModifierKey1<>"" Then
        $modifier1keyCode=_ahks_MapSendKeyToVirtualKey($inModifierKey1)
        If @error Then Return SetError(@error,0,False)
    EndIf
    ; .. and modifier 2 key
    If $inModifierKey2<>"" Then
        $modifier2keyCode=_ahks_MapSendKeyToVirtualKey($inModifierKey2)
        If @error Then Return SetError(@error,0,False)
    EndIf
   
    ; Search for a match in the existing table.
    For $index=0 To $ahks_CurrentKeyCount-1
        If $ahks_keyMap[$index][$ahks_kKeyCode]=$keyCode And _
            $ahks_keyMap[$index][$ahks_kModifier]=$modifier1keyCode And _
            $ahks_keyMap[$index][$ahks_kModifier2]=$modifier2keyCode Then ExitLoop
    Next
   
    ; Not found?
    If $index=$ahks_CurrentKeyCount Then Return SetError(2,0,False)
   
    ; Remove the key and shift the remaining keys back in the array.
    For $index2=$index To $ahks_CurrentKeyCount-1
        $ahks_keyMap[$index2][$ahks_kKeyCode] = $ahks_keyMap[$index2 + 1][$ahks_kKeyCode]
        $ahks_keyMap[$index2][$ahks_kKeyUserFunction] = $ahks_keyMap[$index2 + 1][$ahks_kKeyUserFunction]
        $ahks_keyMap[$index2][$ahks_kKeyLastState] = $ahks_keyMap[$index2 + 1][$ahks_kKeyLastState]
        $ahks_keyMap[$index2][$ahks_kModifier]=$ahks_keyMap[$index2+1][$ahks_kModifier]
        $ahks_keyMap[$index2][$ahks_kModifier2]=$ahks_keyMap[$index2+1][$ahks_kModifier2]
    Next
   
    ; Decrement key count.
    If $ahks_CurrentKeyCount>0 Then $ahks_CurrentKeyCount-=1
   
    Return True
EndFunc

; ================================================================================================
; Func _ahks_MapSendKeyToVirtualKey($inSendKey)
;
; Translate the AutoIt Send()-style string-based key specifier to a Windows Virtual numeric Key code.
;
; $inSendKey = key (in AutoIT Send()-style string format)
;
; Returns:
;   Success: Number representing the Windows Virtual numeric Key code, @error=0
;   Failure: (Key not found): -1, with @error = 1 (invalid param)
;
; Author: Berean (original code), Ascend4nt: cleanup, removal of MsgBox() on error, returns @error codes now
; ================================================================================================

Func _ahks_MapSendKeyToVirtualKey($inSendKey)
    Local $virtualKey
   
    ; Find the matching key code.
    $inSendKey=StringUpper($inSendKey)
   
    For $virtualKey=0 To $ahks_kMaxKeyTranslations-1
        If $ahks_vkTranslationMap[$virtualKey]=$inSendKey Then Return $virtualKey
    Next
   
    ; Not found!
    ConsoleWriteError("Virtual Key " & $inSendKey & " not found."&@CRLF)
   
    Return SetError(1,0,-1)
EndFunc