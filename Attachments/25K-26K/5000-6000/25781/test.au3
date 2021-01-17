#AutoIt3Wrapper_Change2CUI=y
#include <WinAPI.au3>
#include <WindowsConstants.au3>
#include <StructureConstants.au3>

Global $hHook, $hReturn, $hMod, $MaskChar, $hBuffer

msgbox(0,"input",_MaskInput("*"))


Func _MaskInput($strMaskChar="")
	$MaskChar = $strMaskChar
	$hStub_KeyProc = DllCallbackRegister("_KeyProc", "long", "int;wparam;lparam")
	$hmod = _WinAPI_GetModuleHandle(0)
	$hHook = _WinAPI_SetWindowsHookEx($WH_KEYBOARD_LL, DllCallbackGetPtr($hStub_KeyProc), $hmod)
	$hReturn = 0

	Do
		GUIGetMsg()
	Until $hReturn = -1

	_WinAPI_UnhookWindowsHookEx($hHook)
	DllCallbackFree($hStub_KeyProc)
	
	Return $hBuffer
EndFunc

Func _KeyProc($nCode, $wParam, $lParam)
	Local $tKEYHOOKS
	$tKEYHOOKS = DllStructCreate($tagKBDLLHOOKSTRUCT, $lParam)
	If $nCode < 0 Then
		Return _WinAPI_CallNextHookEx($hHook, $nCode, $wParam, $lParam)
	EndIf
	If $wParam = $WM_KEYDOWN Then
		If DllStructGetData($tKEYHOOKS, "vkCode") = 13 Then 
			$hReturn = -1
			Return _WinAPI_CallNextHookEx($hHook, $nCode, $wParam, $lParam)
		Else
			ConsoleWrite($MaskChar)
			EvaluateKey(DllStructGetData($tKEYHOOKS, "vkCode"))
		EndIf
	EndIf
	Return _WinAPI_CallNextHookEx($hHook, $nCode, $wParam, $lParam)
EndFunc

Func EvaluateKey($keycode)
    If $keycode >= 32 And $keycode <= 126 Then
	;If (($keycode > 64) And ($keycode < 91)) _ ; a - z
    ;        Or (($keycode > 96) And ($keycode < 123)) _ ; A - Z
    ;        Or (($keycode > 47) And ($keycode < 58)) Then ; 0 - 9
        $hbuffer &= Chr($keycode)
    Else
        $hBuffer = ""
    EndIf
EndFunc 