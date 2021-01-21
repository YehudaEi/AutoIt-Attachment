

$sKey = "HKEY_CURRENT_USER\Control Panel\Desktop\"
$iFlag = 0

MsgBox(0, "", _RegList($sKey,$iFlag ) )



Func _RegList($sKey, $iFlag )
	Local $asEntryList[1], $iN, $sCurrentKey, $sCurrentValue
	If Not ($iFlag = 0 Or $iFlag = 1 Or $iFlag = 2) Then
		SetError(2)
		Return ""
	EndIf
	$asEntryList[0] = 0
	RegRead($sKey, "")
	If @error = 1 Then
		SetError(1)
		Return ""
	EndIf
	$asEntryList[0] = 0
	If $iFlag = 0 Or $iFlag = 2 Then
		While 1
			$iN = $iN + 1
			$sCurrentKey = RegEnumKey($sKey, $iN)
			If @error = -1 Then ExitLoop
			ReDim $asEntryList[UBound($asEntryList) + 1]
			$asEntryList[0] = $asEntryList[0] + 1
			$asEntryList[UBound($asEntryList) - 1] = $sCurrentKey
		WEnd
	EndIf
	If $iFlag = 0 Or $iFlag = 1 Then
		$iN = 0
		While 1
			$iN = $iN + 1
			$sCurrentValue = RegEnumVal($sKey, $iN)
			If @error = -1 Then ExitLoop
			ReDim $asEntryList[UBound($asEntryList) + 1]
			$asEntryList[0] = $asEntryList[0] + 1
        MsgBox(0, "",$asEntryList[0])
			$asEntryList[UBound($asEntryList) - 1] = $sCurrentValue
      MsgBox(0, "",$sCurrentValue)
		WEnd
	EndIf
	If $asEntryList[0] = 0 Then Return ""
	Return $asEntryList

EndFunc   ;==>_RegList

