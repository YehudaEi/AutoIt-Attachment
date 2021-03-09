#include-once

; #UDF# =======================================================================================================================
; Title .........: Reads\Search the name of a Key\Subkey\Value
; AutoIt Version : 3.3.8.1
; Language ......: English
; Description ...: Lists all Keys\Subkeys\Values in a specified registry key
; Author(s) .....: DXRW4E
; Notes .........:
; ===============================================================================================================================

; #CURRENT# =====================================================================================================================
;~ _RegEnumKeyEx
;~ _RegEnumValEx
; ===============================================================================================================================

#Region ;**** Global constants and vars ****
Global Const $sValueTypes[12] = ["REG_NONE","REG_SZ","REG_EXPAND_SZ","REG_BINARY","REG_DWORD","REG_DWORD_BIG_ENDIAN","REG_LINK","REG_MULTI_SZ","REG_RESOURCE_LIST","REG_FULL_RESOURCE_DESCRIPTOR","REG_RESOURCE_REQUIREMENTS_LIST","REG_QWORD"]
#EndRegion ;**** Global constants and vars ****

; #FUNCTION# ========================================================================================================================
; Name...........: _RegEnumKeyEx
; Description ...: Lists all subkeys in a specified registry key
; Syntax.........: _RegEnumKeyEx($KeyName[, $iFlag = 0[, $sFilter = "*"]])
; Parameters ....: $KeyName - The registry key to read.
;                  $iFlag   - Optional specifies Recursion (add the flags together for multiple operations):
;                  |$iFlag = 0 (Default) All Key-SubKeys Recursive Mod
;                  |$iFlag = 1 All SubKeys Not Recursive Mod
;                  |$iFlag = 2 Include in ArrayList in the first element $KeyName
;                  |$iFlag = 16 $sFilter do Case-Sensitive matching (By Default $sFilter do Case-Insensitive matching)
;                  |$iFlag = 32 Disable the return the count in the first element - effectively makes the array 0-based (must use UBound() to get the size in this case).
;                    By Default the first element ($array[0]) contains the number of strings returned, the remaining elements ($array[1], $array[2], etc.)
;                  |$iFlag = 64 $sFilter is REGEXP Mod, See Pattern Parameters in StringRegExp
;                  |$iFlag = 128 Enum value's name (_RegEnumKeyEx Return a 2D array, maximum Array Size limit is 3999744 Key\Value)
;                  |$iFlag = 256 Reads a value data, this flag will be ignored if the $iFlag = 128 is not set
;                  $sFilter - Optional the filter to use, default is *. (Multiple filter groups such as "All "*.XXx|*.YYY|*.ZZZ")
;                   Search the Autoit3 helpfile for the word "WildCards" For details.
;                  $vFilter - Optional the filter to use for ValueName, $vFilter will be ignored if the $iFlag = 128 is not set
;                   default is *. (Multiple filter groups such as "All "*.XXx|*.YYY|*.ZZZ") Search the Autoit3 helpfile for the word "WildCards" For details.
;                  $iValueTypes - Optional, set Value Types to search (Default $iValueTypes = 0 Read All), $iValueTypes will be ignored if the $iFlag = 128 is not set
;                    (add the flags together for multiple operations):
;                    1 = REG_SZ
;                    2 = REG_EXPAND_SZ
;                    3 = REG_BINARY
;                    4 = REG_DWORD
;                    5 = REG_DWORD_BIG_ENDIAN
;                    6 = REG_LINK
;                    7 = REG_MULTI_SZ
;                    8 = REG_RESOURCE_LIST
;                    9 = REG_FULL_RESOURCE_DESCRIPTOR
;                    10 = REG_RESOURCE_REQUIREMENTS_LIST
;                    11 = REG_QWORD
; Return values .: Success  - Return Array List (See Remarks)
;                  Failure - @Error
;                  |1 = Invalid $sFilter
;                  |2 = No Key-SubKey(s) Found
;                  |3 = Invalid $vFilter
;                  |4 = No Value-Name(s) Found
; Author ........: DXRW4E
; Modified.......:
; Remarks .......: The array returned is one-dimensional and is made up as follows:
;                                $array[0] = Number of Key-SubKeys returned
;                                $array[1] = 1st Key\SubKeys
;                                $array[2] = 2nd Key\SubKeys
;                                $array[3] = 3rd Key\SubKeys
;                                $array[n] = nth Key\SubKeys
;
;                  If is set the $iFlag = 128 The array returned is 2D array and is made up as follows:
;                                $array[0][0] = Number of Key-SubKeys returned
;                                $array[1][0] = 1st Key\SubKeys
;                                $array[1][1] = 1st Value name
;                                $array[1][2] = 1st Value Type (REG_NONE or REG_SZ or REG_EXPAND_SZ ect ect)
;                                $array[1][3] = 1st Value Data (If is set $iFlag = 256 Else Value Data = "")
;                                $array[2][0] = 2nd Key\SubKeys
;                                $array[2][1] = 2nd Value name
;                                $array[2][2] = 2nd Value Type (REG_NONE or REG_SZ or REG_EXPAND_SZ ect ect)
;                                $array[2][3] = 2nd Value Data (If is set $iFlag = 256 Else Value Data = "")
;                                $array[n][0] = nth Key\SubKeys
; Related .......: _RegEnumValEx()
; Link ..........:
; Example .......: _RegEnumKeyEx("HKEY_CURRENT_USER\Software\AutoIt v3")
; Note ..........:
; ===================================================================================================================================
Func _RegEnumKeyEx($KeyName, $iFlag = 0, $sFilter = "*", $vFilter = "*", $iValueTypes = 0)
	If StringRegExp($sFilter, StringReplace("^\s*$|\v|\\|^\||\|\||\|$", Chr(BitAND($iFlag, 64) + 28) & "\|^\||\|\||\|$", "\\\\")) Then Return SetError(1, 0, "")
	Local $IndexSubKey[101] = [100], $SubKeyName, $BS = "\", $sKeyList, $I = 1, $sKeyFlag = BitAND($iFlag, 1), $sKeyFilter = StringReplace($sFilter, "*", "")
	If BitAND($iFlag, 2) Then $sKeyList = @LF & $KeyName
	If Not BitAND($iFlag, 64) Then $sFilter = StringRegExpReplace(BitAND($iFlag, 16) & "(?i)(", "16\(\?\i\)|\d+", "") & StringRegExpReplace(StringRegExpReplace(StringRegExpReplace(StringRegExpReplace($sFilter, "[^*?|]+", "\\Q$0\\E"), "\\E(?=\||$)", "$0\$"), "(?<=^|\|)\\Q", "^$0"), "\*+", ".*") & ")"
	While $I
		$IndexSubKey[$I] += 1
		$SubKeyName = RegEnumKey($KeyName, $IndexSubKey[$I])
		If @error Then
			$IndexSubKey[$I] = 0
			$I -= 1
			$KeyName = StringLeft($KeyName, StringInStr($KeyName, "\", 1, -1) - 1)
			ContinueLoop
		EndIf
		If $sKeyFilter Then
			If StringRegExp($SubKeyName, $sFilter) Then $sKeyList &= @LF & $KeyName & $BS & $SubKeyName
		Else
			$sKeyList &= @LF & $KeyName & $BS & $SubKeyName
		EndIf
		If $sKeyFlag Then ContinueLoop
		$I += 1
		If $I > $IndexSubKey[0] Then
			$IndexSubKey[0] += 100
			ReDim $IndexSubKey[$IndexSubKey[0] + 1]
		EndIf
		$KeyName &= $BS & $SubKeyName
	WEnd
	If Not $sKeyList Then Return SetError(2, 0, "")
	If BitAND($iFlag, 128) <> 128 Then Return StringSplit(StringTrimLeft($sKeyList, 1), @LF, StringReplace(BitAND($iFlag, 32), "32", 2))
	$sKeyList = _RegEnumValEx(StringSplit(StringTrimLeft($sKeyList, 1), @LF), $iFlag, $vFilter, $iValueTypes)
	Return SetError(@Error, 0, $sKeyList)
EndFunc


; #FUNCTION# ========================================================================================================================
; Name...........: _RegEnumValEx
; Description ...: Lists all values in a specified registry key
; Syntax.........: _RegEnumValEx($KeyName[, $iFlag = 0[, $sFilter = "*"]])
; Parameters ....: $KeyName - The registry key to read Or one-dimensional array RegKeyList
;                    use _RegEnumKeyEx() to get $RegKeyList (example $RegKeyList = [3, 1st Key\SubKeys, 2st Key\SubKeys, nth Key\SubKeys])
;                  |$iFlag = 16 $sFilter do Case-Sensitive matching (By Default $sFilter do Case-Insensitive matching)
;                  |$iFlag = 32 Disable the return the count in the first element - effectively makes the array 0-based (must use UBound() to get the size in this case).
;                    By Default the first element ($array[0]) contains the number of strings returned, the remaining elements ($array[1], $array[2], etc.)
;                  |$iFlag = 64 $sFilter is REGEXP Mod, See Pattern Parameters in StringRegExp
;                  |$iFlag = 256 Reads a value data
;                  $sFilter - Optional the filter to use, default is *. (Multiple filter groups such as "All "*.XXx|*.YYY|*.ZZZ")
;                   Search the Autoit3 helpfile for the word "WildCards" For details.
;                  $iValueTypes - Optional, set Value Types to search (Default $iValueTypes = 0 Read All)
;                    (add the flags together for multiple operations):
;                    1 = REG_SZ
;                    2 = REG_EXPAND_SZ
;                    3 = REG_BINARY
;                    4 = REG_DWORD
;                    5 = REG_DWORD_BIG_ENDIAN
;                    6 = REG_LINK
;                    7 = REG_MULTI_SZ
;                    8 = REG_RESOURCE_LIST
;                    9 = REG_FULL_RESOURCE_DESCRIPTOR
;                    10 = REG_RESOURCE_REQUIREMENTS_LIST
;                    11 = REG_QWORD
; Return values .: Success  - Return Array List (See Remarks)
;                  Failure - @Error
;                  |3 = Invalid $sFilter
;                  |4 = No Value-Name(s) Found
; Author ........: DXRW4E
; Modified.......:
; Remarks .......: The array returned is 2D array and is made up as follows:
;                                $array[0][0] = Number of Key-SubKeys returned
;                                $array[1][0] = 1st Key\SubKeys
;                                $array[1][1] = 1st Value name
;                                $array[1][2] = 1st Value Type (REG_NONE or REG_SZ or REG_EXPAND_SZ ect ect)
;                                $array[1][3] = 1st Value Data (If is set $iFlag = 256 Else Value Data = "")
;                                $array[2][0] = 2nd Key\SubKeys
;                                $array[2][1] = 2nd Value name
;                                $array[2][2] = 2nd Value Type (REG_NONE or REG_SZ or REG_EXPAND_SZ ect ect)
;                                $array[2][3] = 2nd Value Data (If is set $iFlag = 256 Else Value Data = "")
;                                $array[n][0] = nth Key\SubKeys
; Related .......: _RegEnumKeyEx()
; Link ..........:
; Example .......: _RegEnumValEx("HKEY_CURRENT_USER\Software\AutoIt v3")
; Note ..........:
; ===================================================================================================================================
Func _RegEnumValEx($aKeyList, $iFlag = 0, $sFilter = "*", $iValueTypes = 0)
	If StringRegExp($sFilter, "\v") Then Return SetError(3, 0, "")
	If Not IsArray($aKeyList) Then $aKeyList = StringSplit($aKeyList, @LF)
	Local $aKeyValList[1954][4], $iKeyVal = Int(BitAND($iFlag, 32) = 0), $sKeyVal = 1953, $sRegEnumVal, $iRegEnumVal, $RegRead = BitAND($iFlag, 256), $vFilter = StringReplace($sFilter, "*", "")
	If Not BitAND($iFlag, 64) Then $sFilter = StringRegExpReplace(BitAND($iFlag, 16) & "(?i)(", "16\(\?\i\)|\d+", "") & StringRegExpReplace(StringRegExpReplace(StringRegExpReplace(StringRegExpReplace($sFilter, "[^*?|]+", "\\Q$0\\E"), "\\E(?=\||$)", "$0\$"), "(?<=^|\|)\\Q", "^$0"), "\*+", ".*") & ")"
	For $i = 1 To $aKeyList[0]
		$iRegEnumVal = 0
		While 1
			If $iKeyVal = $sKeyVal Then
				If $sKeyVal = 3999744 Then ExitLoop
				$sKeyVal *= 2
				ReDim $aKeyValList[$sKeyVal + 1][4]
			EndIf
			$aKeyValList[$iKeyVal][0] = $aKeyList[$i]
			$iRegEnumVal += 1
			$sRegEnumVal = RegEnumVal($aKeyList[$i], $iRegEnumVal)
			If @Error <> 0 Then
				If $iRegEnumVal = 1 And $vFilter = "" Then $iKeyVal += 1
				ExitLoop
			EndIf
			$aKeyValList[$iKeyVal][2] = $sValueTypes[@Extended]
			If BitAND(@Extended, $iValueTypes) <> $iValueTypes Then ContinueLoop
			If $vFilter And Not StringRegExp($sRegEnumVal, $sFilter) Then ContinueLoop
			$aKeyValList[$iKeyVal][1] = $sRegEnumVal
			If $RegRead Then $aKeyValList[$iKeyVal][3] = RegRead($aKeyList[$i], $sRegEnumVal)
			$iKeyVal += 1
		WEnd
	Next
	$sRegEnumVal = $iKeyVal - Int(BitAND($iFlag, 32) = 0)
	If Not $sRegEnumVal Or ($sRegEnumVal = 1 And $vFilter = "" And $aKeyValList[$iKeyVal - $sRegEnumVal][2] = "") Then Return SetError(4, 0, "")
	ReDim $aKeyValList[$iKeyVal][4]
	If Not BitAND($iFlag, 32) Then $aKeyValList[0][0] = $iKeyVal - 1
	Return $aKeyValList
EndFunc

