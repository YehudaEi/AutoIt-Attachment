#include-Once
#include <array.au3>
Global $aHOTKEYEXKEYS[1], $aHOTKEYEXFUNCS[1]

; #FUNCTION# ====================================================================================================================
; Name...........: _HotKeySetEx
; Description ...: Sets a hotkey that calls a user function with the ability to pass parameters
; Syntax.........: _HotKeySetEx($s_Key[, $s_Func])
; Parameters ....: $s_Key		- The key combination to use as the hotkey. Same format as Send().
;				   $s_Func		- Optional: The function to call when the key is pressed. Not specifying this parameter will unset a previous hotkey.
;								  The function name has to include opening and closing brackets at the end, even if no parameters are specified.
;
; Return values .: On Success	- Returns a return code
;								|1 - The new hotkey was created
;								|2 - The new function was bound to an existing hotkey
;								|3 - The hotkey was un-set
;                  On Failure	- Returns 0 and sets @ERROR
;
; Author ........: Tom
; ===============================================================================================================================
Func _HotKeySetEx($s_Key,$s_Func = "")
	For $i = 1 To UBound($aHOTKEYEXKEYS) -1
		If $aHOTKEYEXKEYS[$i] = $s_Key Then
			If Not $s_Func Then
				_ArrayDelete($aHOTKEYEXKEYS,$i)
				_ArrayDelete($aHOTKEYEXFUNCS,$i)
				HotKeySet($s_Key)
				Return 3
			EndIf
			$aHOTKEYEXFUNCS[$i] = $s_Func
			Return 2
		EndIf
	Next
	If HotKeySet($s_Key,"__HKExecute") Then
		_ArrayAdd($aHOTKEYEXKEYS,$s_Key) ;For some reason storing the return in $aHOTKEYEXKEYS[0] results in a crash sometimes, weird.
		_ArrayAdd($aHOTKEYEXFUNCS,$s_Func)
		Return 1
	EndIf
	Return SetError(1)
EndFunc

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name...........: __HKExecute()
; Description ...: Helper function for executing the right function for a hotkey set with _HotKeySetEx()
; Syntax.........: __HKExecute()
; Parameters ....: none
; Return values .: None
; Author ........: Tom
; Remarks .......: For Internal Use Only
; Related .......: _HotKeySetEx
; ===============================================================================================================================
Func __HKExecute()
	For $i = 1 To UBound($aHOTKEYEXKEYS) -1
		If $aHOTKEYEXKEYS[$i] = @HotKeyPressed Then
			Execute($aHOTKEYEXFUNCS[$i])
			Return
		EndIf
	Next
	ConsoleWrite("Hotkey not found!" & @CRLF)
EndFunc
