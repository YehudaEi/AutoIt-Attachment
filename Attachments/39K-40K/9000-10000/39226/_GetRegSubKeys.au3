#include-once
#include <Array.au3>

; #FUNCTION# ====================================================================================================================
; Name ..........: _GetRegSubKeys
; Description ...: Returns an array with the sub keys of a given registry key.
; Syntax ........: _GetRegSubKeys($sHKEY)
; Parameters ....: $sHKEY               - The registry key
; Return values .: Success: Returns an array with the Subkeys (See remarks!).
;				   Failure: Returns 0.
; Author ........: PainTain @ Autoit.de (Christoph H.)
; Remarks .......: Index 0 of the array contains the number of the read keys.
; Link ..........: http://www.autoitscript.com/forum/topic/146780-defaultbrowser-udf-getregsubkeys-function/
; ===============================================================================================================================
Func _GetRegSubKeys($sHKEY)
	Local $i = 1
	Local $aSubKeys[$i]

	Do
		$sSubKey = RegEnumKey($sHKEY,$i)
		If @error Then Return 0
		ReDim $aSubKeys[UBound($aSubKeys)]
		_ArrayAdd($aSubKeys,$sSubKey)
		$i += 1
	Until RegEnumKey($sHKEY, $i) = "" And @error = "-1"
	_ArrayInsert($aSubKeys, 0, UBound($aSubKeys) - 1)
	_ArrayDelete($aSubKeys, 1)
	Return $aSubKeys
EndFunc