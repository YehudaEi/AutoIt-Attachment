#include-once
#include <Array.au3>

Global Const $REG_X86_HKCU_DB = "HKCU\Software\Clients\StartMenuInternet"
Global Const $REG_X86_HKLM_IB = "HKLM\Software\Clients\StartMenuInternet"

Global Const $REG_X64_HKCU_DB = "HKCU64\Software\Clients\StartMenuInternet"
Global Const $REG_X64_HKLM_IB = "HKLM64\Software\Clients\StartMenuInternet"

; #FUNCTION# ====================================================================================================================
; Name ..........: _GetDefaultBrowser
; Description ...: Returns the name of the default browser.
; Syntax ........: _GetDefaultBrowser()
; Parameters ....:
; Return values .: Success: Returns the name of the default browser.
;				   Failure: Returns 0
; Author ........: PainTain @ Autoit.de (Christoph H.)
; Related .......: _GetInstalledBrowser()
; Link ..........: http://www.autoitscript.com/forum/topic/146780-defaultbrowser-udf-getregsubkeys-function/
; ===============================================================================================================================
Func _GetDefaultBrowser()
	If @CPUArch = "X86" Then
		$sUserDefaultBrowserX86 = RegRead($REG_X86_HKCU_DB,"")
		If @error Then
			Return 0
		Else
			$asInstalledBrowserX86 = _GetRegSubKeys($REG_X86_HKLM_IB)
			$iIndexOfDB = _ArraySearch($asInstalledBrowserX86,$sUserDefaultBrowserX86)
			$sFullName = RegRead($REG_X86_HKLM_IB & "\" & $asInstalledBrowserX86[$iIndexOfDB],"")
			Return $sFullName
		EndIf
	ElseIf @CPUArch = "X64" Then
		$sUserDefaultBrowserX64 = RegRead($REG_X64_HKCU_DB,"")
		If @error Then
			Return 0
		Else
			$asInstalledBrowserX64 = _GetRegSubKeys($REG_X64_HKLM_IB)
			$iIndexOfDB = _ArraySearch($asInstalledBrowserX64,$sUserDefaultBrowserX64)
			$sFullName = RegRead($REG_X64_HKLM_IB & "\" & $asInstalledBrowserX64[$iIndexOfDB],"")
			Return $sFullName
		EndIf
	Else
		Return 0
	EndIf
EndFunc


; #FUNCTION# ====================================================================================================================
; Name ..........: _GetInstalledBrowser
; Description ...: Returns an array with the names of installed browser.
; Syntax ........: _GetInstalledBrowser()
; Parameters ....: None
; Return values .: Success: Returns an array with the names of installed browsers (See remarks!).
;				   Failure: Returns 0
; Author ........: PainTain @ Autoit.de (Christoph H.)
; Remarks .......: Index 0 of the array contains the number of installed browsers.
; Related .......: _GetDefaultBrowser()
; Link ..........:
; ===============================================================================================================================
Func _GetInstalledBrowser()
	If @CPUArch = "X86" Then
		Local $aListFullX86[2]

		$aInstalledBrowserX86 = _GetRegSubKeys($REG_X86_HKLM_IB)
		_ArrayAdd($aListFullX86,$aInstalledBrowserX86[0])
		For $i = 0 To UBound($aInstalledBrowserX86) - 1
			$sReadBrowserNameX86 = RegRead($REG_X86_HKLM_IB & "\" & $aInstalledBrowserX86[$i],"")
			_ArrayAdd($aListFullX86, $sReadBrowserNameX86)
			ReDim $aListFullX86[UBound($aListFullX86)]
		Next
		_ArrayDelete($aListFullX86, 0)
		_ArrayDelete($aListFullX86, 0)
		Return $aListFullX86
	ElseIf @CPUArch = "X64" Then
		Local $aListFullX64[2]

		$aInstalledBrowserX64 = _GetRegSubKeys($REG_X64_HKLM_IB)
		_ArrayAdd($aListFullX64,$aInstalledBrowserX64[0])
		For $i = 1 To UBound($aInstalledBrowserX64) - 1
			$sReadBrowserNameX64 = RegRead($REG_X64_HKLM_IB & "\" & $aInstalledBrowserX64[$i],"")
			_ArrayAdd($aListFullX64,$sReadBrowserNameX64)
			ReDim $aListFullX64[UBound($aListFullX64)]
		Next
		_ArrayDelete($aListFullX64, 0)
		_ArrayDelete($aListFullX64, 0)
		Return $aListFullX64
	Else
		Return 0
	EndIf
EndFunc


; #FUNCTION# ====================================================================================================================
; Name ..........: _GetRegSubKeys
; Description ...: Returns an array with the sub keys of a given registry key.
; Syntax ........: _GetRegSubKeys($sHKEY)
; Parameters ....: $sHKEY               - The registry key
; Return values .: Success: Returns an array with the Subkeys (See remarks!).
;				   Failure: Returns 0.
; Author ........: PainTain @ Autoit.de (Christoph H.)
; Remarks .......: Index 0 of the array contains the number of the read keys.
; Link ..........:
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