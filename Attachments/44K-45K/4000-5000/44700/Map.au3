#include-once

;#include <Array.au3>

#include <Array_MapMod.au3> ; Just for testing <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<


; #INDEX# =======================================================================================================================
; Title .........: Map
; AutoIt Version : 3.3.14.0
; Language ......: English
; Description ...: Functions for manipulating maps.
; Author(s) .....: Melba23
; ===============================================================================================================================

; #CURRENT# =====================================================================================================================
; _MapConcatenate
; _MapDisplay
; _MapFindAll
; _MapMaxKey
; _MapMaxValue
; _MapMinKey
; _MapMinValue
; _MapRenameKey
; _MapSearch
; _MapToArray
; _MapToClip
; _MapToString
; ===============================================================================================================================

; #FUNCTION# ====================================================================================================================
; Author ........: Melba23
; Modified.......:
; ===============================================================================================================================
Func _MapConcatenate(ByRef $mMapTarget, Const ByRef $mMapSource, $bOverWrite = False)

	If Not IsMap($mMapTarget) Then Return SetError(1, 0, -1)
	If Not IsMap($mMapSource) Then Return SetError(2, 0, -1)

	; Iterate keys from Source
	Local $aKeys = MapKeys($mMapSource)
	For $i = 0 To UBound($aKeys) - 1
		; Check for overwrite
		If (Not $bOverWrite) And MapExists($mMapTarget, $aKeys[$i]) Then ContinueLoop
		; Add to Target
		$mMapTarget[$aKeys[$i]] = $mMapSource[$aKeys[$i]]
	Next

	Return UBound($mMapTarget, $UBOUND_ROWS)

EndFunc   ;==>_MapConcatenate

; #FUNCTION# ====================================================================================================================
; Author ........: Melba23
; Modified.......:
; ===============================================================================================================================
Func _MapDisplay(Const ByRef $mMap, $sTitle = Default, $iFlags = 0, $vUser_Separator = Default, $iMax_ColWidth = Default, $iAlt_Color = Default, $hUser_Func = Default)

	; Check valid Map
	If Not IsMap($mMap) Then
		; Check if Verbose flag set
		If BitAND($iFlags, 8) And MsgBox($MB_SYSTEMMODAL + $MB_ICONERROR + $MB_YESNO, _
				"MapDisplay Error: " & $sTitle, "No Map variable passed to function" & @CRLF & @CRLF & "Exit the script?") = $IDYES Then
			Exit
		Else
			Return SetError(1, 0, 0)
		EndIf
	EndIf

	; Default values
	If $iFlags = Default Then $iFlags = 0
	If $sTitle = Default Then $sTitle = "MapDisplay"
	If $iMax_ColWidth = Default Then $iMax_ColWidth = 350

	; Check for string highlight
	Local $bHighlight = ( (BitAnd($iFlags, 1)) ? (True) : (False) )

	; Remove invalid flags - add "No Rows" and Map flags
	$iFlags = BitOr(BitAND($iFlags, 62), 64, 1024)

	Local $aMap = _MapToArray($mMap, $bHighlight)
	; Pass 2D array to _ArrayDisplay
	_ArrayDisplay($aMap, $sTitle, Default, $iFlags, $vUser_Separator, "Key|Value", $iMax_ColWidth, $iAlt_Color, $hUser_Func)
	If @error Then
		Return SetError(2, @error, 0)
	EndIf
	Return 1

EndFunc   ;==>_MapDisplay

; #FUNCTION# ====================================================================================================================
; Author ........: Melba23
; Modified.......:
; ===============================================================================================================================
Func _MapFindAll(Const ByRef $mMap, $vSearch, $iCompare = 0)

	If Not IsMap($mMap) Then Return SetError(1, 0, -1)
	If $iCompare = Default Then $iCompare = 0

	Local $iIndex = 0, $avResult[]

	For $vKey in MapKeys($mMap)
		$vValue = $mMap[$vKey]

		If $vValue == $vSearch Then
			$avResult[$iIndex] = $vKey
			$iIndex += 1
		EndIf

	Next

	Return _MapToArray($avResult)
EndFunc   ;==>_MapFindAll

; #FUNCTION# ====================================================================================================================
; Author ........: Melba23
; Modified.......:
; ===============================================================================================================================
Func _MapMaxKey($mMap, $iCompNumeric = 0)

	If Not IsMap($mMap) Then Return SetError(1, 0, "")
	If $iCompNumeric = Default Then $iCompNumeric = 0
	If $iCompNumeric <> 1 Then $iCompNumeric = 0

	Local $aKeys = MapKeys($mMap)

	Local $vMinKey = $aKeys[0]
	Local $iMin = $mMap[$vMinKey]

	For $vKey In $aKeys
		$vValue = $mMap[$vKey]

		If ($iCompNumeric And Number($vValue) > Number($iMin)) Or _
			(Not $iCompNumeric And $vValue > $iMin) Then
			$iMin = $vValue
			$vMinKey = $vKey
		EndIf
	Next

	Return $vMinKey

EndFunc   ;==>_MapMinKey

; #FUNCTION# ====================================================================================================================
; Author ........: Melba23
; Modified.......:
; ===============================================================================================================================
Func _MapMaxValue($mMap, $iCompNumeric = 0)

	Local $vKey = _MapMaxKey($mMap, $iCompNumeric)
	If @error Then Return SetError(@error, @extended, "")
	Return $mMap[$vKey]

EndFunc   ;==>_MapMaxValue

; #FUNCTION# ====================================================================================================================
; Author ........: Melba23
; Modified.......:
; ===============================================================================================================================
Func _MapMinKey($mMap, $iCompNumeric = 0)

	If Not IsMap($mMap) Then Return SetError(1, 0, "")
	If $iCompNumeric = Default Then $iCompNumeric = 0
	If $iCompNumeric <> 1 Then $iCompNumeric = 0

	Local $aKeys = MapKeys($mMap)

	Local $vMinKey = $aKeys[0]
	Local $iMin = $mMap[$vMinKey]

	For $vKey In $aKeys
		$vValue = $mMap[$vKey]

		If ($iCompNumeric And Number($vValue) < Number($iMin)) Or _
			(Not $iCompNumeric And $vValue < $iMin) Then
			$iMin = $vValue
			$vMinKey = $vKey
		EndIf
	Next

	Return $vMinKey

EndFunc   ;==>_MapMinKey

; #FUNCTION# ====================================================================================================================
; Author ........: Melba23
; Modified.......:
; ===============================================================================================================================
Func _MapMinValue($mMap, $iCompNumeric = 0)

	Local $vKey = _MapMinKey($mMap, $iCompNumeric)
	If @error Then Return SetError(@error, @extended, "")
	Return $mMap[$vKey]

EndFunc   ;==>_MapMinValue

; #FUNCTION# ====================================================================================================================
; Author ........: Melba23
; Modified.......:
; ===============================================================================================================================
Func _MapRenameKey(ByRef $mMap, $vKey, $vNewKey)

	If Not IsMap($mMap) Then Return SetError(1, 0, 0)

	Local $vValue = $mMap[$vKey]
	MapRemove($mMap, $vKey)
	If @error Then Return SetError(2, 0, 0)
	$mMap[$vNewKey] = $vValue
	Return 1

EndFunc   ;==>_MapRenameKey

; #FUNCTION# ====================================================================================================================
; Author ........: Melba23
; Modified.......:
; ===============================================================================================================================
Func _MapSearch(Const ByRef $mMap, $vSearch, $iCompare = 0)

	If Not IsMap($mMap) Then Return SetError(1, 0, -1)
	If $iCompare = Default Then $iCompare = 0

	For $vKey In MapKeys($mMap)
		$vValue = $mMap[$vKey]

		If $vValue == $vSearch Then
			Return $vKey
		EndIf
	Next
EndFunc   ;==>_MapSearch

; #FUNCTION# ====================================================================================================================
; Author ........: Melba23
; Modified.......:
; ===============================================================================================================================
Func _MapToArray(Const ByRef $mMap, $bString = False)

	If Not IsMap($mMap) Then Return SetError(1, 0, "")

	Local $i = 0, $aMap[UBound($mMap)][2]
	For $vKey In MapKeys($mMap)
		If $bString And IsString($vKey) Then
			$aMap[$i][0] = '"' & $vKey & '"'
		Else
			$aMap[$i][0] = $vKey
		EndIf
		$aMap[$i][1] = $mMap[$vKey]

		$i += 1
	Next
	Return $aMap

EndFunc   ;==>_MapToArray

; #FUNCTION# ====================================================================================================================
; Author ........: Melba23
; Modified.......:
; ===============================================================================================================================
Func _MapToClip(Const ByRef $mMap, $sDelim_Item = "|", $sDelim_Row = @CRLF)

	Local $sResult = _MapToString($mMap, $sDelim_Item, $sDelim_Row)
	If @error Then Return SetError(@error, 0, 0)
	If ClipPut($sResult) Then Return 1
	Return SetError(2, 0, 0)

EndFunc   ;==>_MapToClip

; #FUNCTION# ====================================================================================================================
; Author ........: Melba23
; Modified.......:
; ===============================================================================================================================
Func _MapToString(Const ByRef $mMap, $sDelim_Item = "|", $sDelim_Row = @CRLF)

	If $sDelim_Item = Default Then $sDelim_Item = "|"
	If $sDelim_Row = Default Then $sDelim_Row = @CRLF
	If Not IsMap($mMap) Then Return SetError(1, 0, -1)

	Local $sRet = ""

	For $vKey In MapKeys($mMap)
		$vValue = $mMap[$vKey]

		__MapToString_Print($sRet, $vKey)
		$sRet &= $sDelim_Item
		__MapToString_Print($sRet, $vValue)
		$sRet &= @CRLF
	Next

	Return $sRet

EndFunc   ;==>_MapToString

Func __MapToString_Print(ByRef $sOutput, ByRef $vValue)
	Switch VarGetType($vValue)
		Case "Array"
			$sOutput &= "{Array}"
		Case "Map"
			$sOutput &= "{Map}"
	EndSwitch
EndFunc