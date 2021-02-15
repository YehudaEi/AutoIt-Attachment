; Authors: Manadar, GarryFrost
; Contributor: WideBoyDixon

#include <WinAPI.au3>
#include <WindowsConstants.au3>
#include <Array.au3>

#include-once

Local $hStub_KeyProc = DllCallbackRegister("_HotString_KeyProc", "long", "int;wparam;lparam")
Local $hmod = _WinAPI_GetModuleHandle(0)
Local $hHook = _WinAPI_SetWindowsHookEx($WH_KEYBOARD_LL, DllCallbackGetPtr($hStub_KeyProc), $hmod)
Local $buffer = ""
Local $hotstrings[1]
Local $hotfuncs[1]
Local $hotargs[1]
Local $hWnd = GUICreate("")
GUIRegisterMsg($WM_KEYDOWN, "_HotString_GUIKeyProc")
OnAutoItExitRegister("_HotString_OnAutoItExit")

Func _HotStringSet($hotstring, $func, $args)
    _ArrayAdd($hotstrings, $hotstring)
    _ArrayAdd($hotfuncs, $func)
    _ArrayAdd($hotargs,$args)
EndFunc

Func _HotString_EvaluateKey($keycode)
    If (($keycode > 64) And ($keycode < 91)) _ ; A - Z
            Or (($keycode > 47) And ($keycode < 58)) Then ; 0 - 9
        $buffer &= Chr($keycode)
        $a = _ArraySearch($hotstrings, $buffer)
		If ( $a >= 0 ) Then
			Call($hotfuncs[$a], $hotargs[$a])
		EndIf
    ElseIf ($keycode > 159) And ($keycode < 164) Then
        Return
    Else
        $buffer = ""
    EndIf
EndFunc   ;==>EvaluateKey

Func _HotString_GUIKeyProc($hWnd, $Msg, $wParam, $lParam)
	_HotString_EvaluateKey(Number($wParam))
EndFunc

Func _HotString_KeyProc($nCode, $wParam, $lParam)
    Local $tKEYHOOKS
    $tKEYHOOKS = DllStructCreate($tagKBDLLHOOKSTRUCT, $lParam)
    If $nCode < 0 Then
        Return _WinAPI_CallNextHookEx($hHook, $nCode, $wParam, $lParam)
    EndIf
    If $wParam = $WM_KEYDOWN Then
		$vkKey = DllStructGetData($tKEYHOOKS, "vkCode")
		_WinAPI_PostMessage($hWnd, $WM_KEYDOWN, $vkKey, 0)
    EndIf
    Return _WinAPI_CallNextHookEx($hHook, $nCode, $wParam, $lParam)
EndFunc   ;==>_KeyProc

Func _HotString_OnAutoItExit()
    _WinAPI_UnhookWindowsHookEx($hHook)
    DllCallbackFree($hStub_KeyProc)
EndFunc   ;==>OnAutoItExit
