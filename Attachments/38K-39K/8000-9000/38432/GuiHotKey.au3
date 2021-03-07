#include-once

#include "HotKeyConstants.au3"
#include "SendMessage.au3"
#include "UDFGlobalID.au3"
#include "WinAPI.au3"

; #INDEX# =======================================================================================================================
; Title..........: HotKey
; AutoIt version.: 3.2.3++
; Language.......: English
; Description....: Functions that assist with HotKey control management. A hot key control is a window that enables the user to
;                  enter a combination of keystrokes to be used as a hot key.
;                  Minimum Operating Systems: Windows XP
; Author(s)......: Yashied
; ===============================================================================================================================

; #VARIABLES# ===================================================================================================================
Global $_ghHKLastWnd
Global $Debug_HK = False
; ===============================================================================================================================

; #CONSTANTS# ===================================================================================================================
Global Const $__HOTKEYCONSTANT_ClassName = "msctls_hotkey32"
Global Const $__HOTKEYCONSTANT_WS_TABSTOP = 0x00010000
Global Const $__HOTKEYCONSTANT_DEFAULT_GUI_FONT = 17
Global Const $__HOTKEYCONSTANT_WM_SETFONT = 0x0030
; ===============================================================================================================================

; #CURRENT# =====================================================================================================================
;_GUICtrlHotKey_Create
;_GUICtrlHotKey_Destroy
;_GUICtrlHotKey_GetHotKey
;_GUICtrlHotKey_GetKeys
;_GUICtrlHotKey_MakeKeyCode
;_GUICtrlHotKey_SetHotKey
;_GUICtrlHotKey_SetRules
; ===============================================================================================================================

; #FUNCTION# ====================================================================================================================
; Name...........: _GUICtrlHotKey_Create
; Description....: Creates a HotKey control
; Syntax.........: _GUICtrlHotKey_Create($hWnd, $iHotKey, $iX, $iY, $iWidth, $iHeight [, $iStyle = -1 [, $iExStyle = -1]] )
; Parameters.....: $hWnd     - Handle to parent or owner window
;                  $iHotKey  - The hot key combination for a HotKey control. The LOBYTE of the LOWORD is the virtual key code of the hot key ($VK_*).
;                              The HIBYTE of the LOWORD is the key modifier that indicates the keys that define a hot key combination,
;                              and can be zero or combination of the following values:
;                  |$HOTKEYF_ALT     - ALT key
;                  |$HOTKEYF_CONTROL - CONTROL key
;                  |$HOTKEYF_EXT     - Extended key
;                  |$HOTKEYF_SHIFT   - SHIFT key
;                  $iX       - Horizontal position of the control
;                  $iY       - Vertical position of the control
;                  $iWidth   - Control width
;                  $iHeight  - Control height
;                  $iStyle   - Control style, can be one or more of the following values:
;                  |Default: None
;                  |Forced: $WS_CHILD, $WS_VISIBLE, WS_TABSTOP
;                  $iExStyle - Control extended style. These correspond to the standard $WS_EX_* constants.
; Return values..: Success   - Handle to the newly created HotKey control
;                  Failure   - 0
; Author.........: Yashied
; Modified.......:
; Remarks........: Use the _GUICtrlHotKey_MakeKeyCode() to make properly the 16-bit value of a hot key combination
; Related........: _GUICtrlHotKey_Destroy
; Link...........:
; Example........: Yes
; ===============================================================================================================================

Func _GUICtrlHotKey_Create($hWnd, $iHotKey, $iX, $iY, $iWidth, $iHeight, $iStyle = -1, $iExStyle = -1)
	If Not IsHWnd($hWnd) Then
		Return SetError(1, 0, 0)
	EndIf
	If $iStyle = -1 Then
		$iStyle = BitOR($__UDFGUICONSTANT_WS_VISIBLE, $__UDFGUICONSTANT_WS_CHILD, $__HOTKEYCONSTANT_WS_TABSTOP)
	Else
		$iStyle = BitOR($__UDFGUICONSTANT_WS_VISIBLE, $__UDFGUICONSTANT_WS_CHILD, $__HOTKEYCONSTANT_WS_TABSTOP, $iStyle)
	EndIf
	If $iExStyle = -1 Then
		$iExStyle = 0
	EndIf
	Local $nCtrlID = __UDF_GetNextGlobalID($hWnd)
	If @error Then
		Return SetError(@error, @extended, 0)
	EndIf
	Local $hHotKey = _WinAPI_CreateWindowEx($iExStyle, $__HOTKEYCONSTANT_ClassName, "", $iStyle, $iX, $iY, $iWidth, $iHeight, $hWnd, $nCtrlID)
	_SendMessage($hHotKey, $__HOTKEYCONSTANT_WM_SETFONT, _WinAPI_GetStockObject($__HOTKEYCONSTANT_DEFAULT_GUI_FONT), True)
	If $iHotKey Then
		_GUICtrlHotKey_SetHotKey($hHotKey, $iHotKey)
	EndIf
	Return $hHotKey
EndFunc   ;==>_GUICtrlHotKey_Create

; #FUNCTION# ====================================================================================================================
; Name...........: _GUICtrlHotKey_Destroy
; Description....: Deletes a HotKey control
; Syntax.........: _GUICtrlHotKey_Destroy ( ByRef $hWnd )
; Parameters.....: $hWnd   - Handle to the HotKey control
; Return values..: Success - True, handle is set to 0
;                  Failure - False
; Author.........: Yashied
; Modified.......:
; Remarks........:
; Related........: _GUICtrlHotKey_Create
; Link...........:
; Example........: Yes
; ===============================================================================================================================

Func _GUICtrlHotKey_Destroy(ByRef $hWnd)
	If $Debug_HK Then
		__UDF_ValidateClassName($hWnd, $__HOTKEYCONSTANT_ClassName)
	EndIf
	If Not _WinAPI_IsClassName($hWnd, $__HOTKEYCONSTANT_ClassName) Then
		Return SetError(2, 2, False)
	EndIf
	Local $Result = 0
	If _WinAPI_InProcess($hWnd, $_ghHKLastWnd) Then
		Local $nCtrlID = _WinAPI_GetDlgCtrlID($hWnd)
		Local $hParent = _WinAPI_GetParent($hWnd)
		$Result = _WinAPI_DestroyWindow($hWnd)
		If Not __UDF_FreeGlobalID($hParent, $nCtrlID) Then
			; Can check for errors, for debug
		EndIf
	Else
		Return SetError(1, 1, False)
	EndIf
	If $Result Then
		$hWnd = 0
	EndIf
	Return $Result <> 0
EndFunc   ;==>_GUICtrlHotKey_Destroy

; #FUNCTION# ====================================================================================================================
; Name...........: _GUICtrlHotKey_GetHotKey
; Description....: Retrieves the hot key combination from a HotKey control
; Syntax.........: _GUICtrlHotKey_GetHotKey ( $hWnd )
; Parameters.....: $hWnd   - Handle to the HotKey control
; Return values..: Success - The 16-bit value that specifies the hot key
;                  Failure - False
; Author.........: Yashied
; Modified.......:
; Remarks........:
; Related........: _GUICtrlHotKey_SetHotKey
; Link...........:
; Example........: Yes
; ===============================================================================================================================

Func _GUICtrlHotKey_GetHotKey($hWnd)
	If $Debug_HK Then
		__UDF_ValidateClassName($hWnd, $__HOTKEYCONSTANT_ClassName)
	EndIf
	Return _SendMessage($hWnd, $HKM_GETHOTKEY)
EndFunc   ;==>_GUICtrlHotKey_GetHotKey

; #FUNCTION# ====================================================================================================================
; Name...........: _GUICtrlHotKey_GetKeys
; Description....: Retrieves the virtual key code and modifier flags for the specified hot key combination
; Syntax.........: _GUICtrlHotKey_GetKeys ( $iHotKey, ByRef $iHK, ByRef $iVK )
; Parameters.....: $iHotKey - The 16-bit value that specifies the hot key
;                  $iHK     - The key modifier flags for the hot key, it can be zero or combination of the $HOTKEYF_* values
;                  $iVK     - The virtual key code ($VK_*)
; Return values..: None
; Author.........: Yashied
; Modified.......:
; Remarks........:
; Related........: _GUICtrlHotKey_MakeKeyCode
; Link...........:
; Example........: Yes
; ===============================================================================================================================

Func _GUICtrlHotKey_GetKeys($iHotKey, ByRef $iHK, ByRef $iVK)
	$iHK = BitAND(BitShift($iHotKey, 8), 0xFF)
	$iVK = BitAND($iHotKey, 0xFF)
EndFunc   ;==>_GUICtrlHotKey_GetKeys

; #FUNCTION# ====================================================================================================================
; Name...........: _GUICtrlHotKey_MakeKeyCode
; Description....: Makes the hot key combination using a specified key modifier flags and virtual key code
; Syntax.........: _GUICtrlHotKey_MakeKeyCode ( $iHK, $iVK )
; Parameters.....: $iHK - The key modifier flags for the hot key, it can be zero or combination of the following values:
;                  |$HOTKEYF_ALT     - ALT key
;                  |$HOTKEYF_CONTROL - CONTROL key
;                  |$HOTKEYF_EXT     - Extended key
;                  |$HOTKEYF_SHIFT   - SHIFT key
;                  $iVK - The virtual key code, it must be one of the $VK_* constants
; Return values..: The 16-bit value that specifies the hot key
; Author.........: Yashied
; Modified.......:
; Remarks........: A key modifier values can BitOR'ed together as for example BitOR($HOTKEYF_ALT, $HOTKEYF_CONTROL)
; Related........: _GUICtrlHotKey_GetKeys
; Link...........:
; Example........: Yes
; ===============================================================================================================================

Func _GUICtrlHotKey_MakeKeyCode($iHK, $iVK)
	Return BitOR(BitShift(BitAND($iHK, 0xFF), -8), BitAND($iVK, 0xFF))
EndFunc   ;==>_GUICtrlHotKey_MakeKeyCode

; #FUNCTION# ====================================================================================================================
; Name...........: _GUICtrlHotKey_SetHotKey
; Description....: Sets the hot key combination for a HotKey control
; Syntax.........: _GUICtrlHotKey_SetHotKey ( $hWnd, $iHotKey )
; Parameters.....: $hWnd    - Handle to the HotKey control
;                  $iHotKey - The 16-bit value that specifies the hot key. The LOBYTE is the virtual key code of the hot key, and must be
;                             one of the $VK_* constants. The HIBYTE is the key modifier that indicates the keys that define a hot key
;                             combination, and can be zero or combination of the following values:
;                  |$HOTKEYF_ALT     - ALT key
;                  |$HOTKEYF_CONTROL - CONTROL key
;                  |$HOTKEYF_EXT     - Extended key
;                  |$HOTKEYF_SHIFT   - SHIFT key
; Return values..: None
; Author.........: Yashied
; Modified.......:
; Remarks........: Use the _GUICtrlHotKey_MakeKeyCode() to make properly the 16-bit value of a hot key combination
; Related........: _GUICtrlHotKey_GetHotKey
; Link...........:
; Example........: Yes
; ===============================================================================================================================

Func _GUICtrlHotKey_SetHotKey($hWnd, $iHotKey)
	If $Debug_HK Then
		__UDF_ValidateClassName($hWnd, $__HOTKEYCONSTANT_ClassName)
	EndIf
	Return _SendMessage($hWnd, $HKM_SETHOTKEY, $iHotKey)
EndFunc   ;==>_GUICtrlHotKey_SetHotKey

; #FUNCTION# ====================================================================================================================
; Name...........: _GUICtrlHotKey_SetRules
; Description....: Defines the invalid combinations and the default modifier combination for a HotKey control
; Syntax.........: _GUICtrlHotKey_SetRules ( $hWnd, $iInvalid, $iReplacement )
; Parameters.....: $hWnd         - Handle to the HotKey control
;                  $iInvalid     - The invalid key combinations, it can be a combination of the following values:
;                  |$HKCOMB_A        - ALT
;                  |$HKCOMB_C        - CTRL
;                  |$HKCOMB_CA       - CTRL+ALT
;                  |$HKCOMB_NONE     - Unmodified keys
;                  |$HKCOMB_S        - SHIFT
;                  |$HKCOMB_SA       - SHIFT+ALT
;                  |$HKCOMB_SC       - SHIFT+CTRL
;                  |$HKCOMB_SCA      - SHIFT+CTRL+ALT
;                  $iReplacement - The key combination to use when the user enters an invalid combination:
;                  |$HOTKEYF_ALT     - ALT key
;                  |$HOTKEYF_CONTROL - CONTROL key
;                  |$HOTKEYF_EXT     - Extended key
;                  |$HOTKEYF_SHIFT   - SHIFT key
; Return values..: None
; Author.........: Yashied
; Modified.......:
; Remarks........: When a user enters an invalid key combination, as defined by $iInvalid, the system converts into a string and then
;                  displays the keys defined by $iReplacement
; Related........:
; Link...........:
; Example........: Yes
; ===============================================================================================================================

Func _GUICtrlHotKey_SetRules($hWnd, $iInvalid, $iReplacement)
	If $Debug_HK Then
		__UDF_ValidateClassName($hWnd, $__HOTKEYCONSTANT_ClassName)
	EndIf
	Return _SendMessage($hWnd, $HKM_SETRULES, $iInvalid, $iReplacement)
EndFunc   ;==>_GUICtrlHotKey_SetRules
