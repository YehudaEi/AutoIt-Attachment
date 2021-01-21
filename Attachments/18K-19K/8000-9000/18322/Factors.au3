#cs ----------------------------------------------------------------------------
	
	AutoIt Version: 3.2.10.0
	Author:         David Nuttall
	
	Script Function:
	Factoring functions
	
#ce ----------------------------------------------------------------------------

Func Factor_Prime($nValue)
	Local $aRetVal[99], $nUsed = 0
	Local $I

	If Not IsInt($nValue) Then
		SetError(1)
		Return False
	ElseIf $nValue < 0 Then
		$aRetVal[$nUsed] = -1
		$nUsed += 1
		$nValue *= -1
	EndIf
	$I = 2
	While $I < Sqrt($nValue)
		If Round(Mod($nValue, $I)) = 0 Then
			; Need to use Round because sometimes Mod returns numbers that are not quite integer.
			If $nUsed >= UBound($aRetVal) Then ReDim $aRetVal[$nUsed + 99]
			$aRetVal[$nUsed] = $I
			$nUsed += 1
			$nValue /= $I
		Else
			$I += 1
		EndIf
	WEnd
	If $I > 1 Then
		If $nUsed >= UBound($aRetVal) Then ReDim $aRetVal[$nUsed + 1]
		$aRetVal[$nUsed] = $I
		$nUsed += 1
	EndIf
	If $nUsed < UBound($aRetVal) - 1 Then
		ReDim $aRetVal[$nUsed]
	EndIf
	Return $aRetVal
EndFunc   ;==>Factor_Prime

Func Factor_All(Const $nValue)
	Local $aRetVal[99]	; The array to be returned with all the factors.
	Local $aTemp[99]	; An array to hold the larger numbers as we go along.  It will be dumped into $aRetVal at the end.
	Local $nUsed = 0
	Local $I

	If Not IsInt($nValue) Then
		SetError(1)
		Return False
	ElseIf $nValue < 0 Then
		$aRetVal[$nUsed] = -1
		$nUsed += 1
	EndIf
	For $I = 1 To Sqrt(Abs($nValue))
		If Round(Mod(Abs($nValue), $I)) = 0 Then
			; Need to use Round because sometimes Mod returns numbers that are not quite integer.
			If $nUsed >= UBound($aRetVal) Then ReDim $aRetVal[$nUsed + 99], $aTemp[$nUsed + 99]
			$aRetVal[$nUsed] = $I
			$aTemp[$nUsed] = $nValue / $I
			$nUsed += 1
		EndIf
	Next
	; Take the temp array, which
	If $nUsed * 2 >= UBound($aRetVal) Then ReDim $aRetVal[$nUsed * 2]
	For $I = $nUsed - 1 To 0 Step - 1
		If $aRetVal[$nUsed - 1] < $aTemp[$I] Then
			$aRetVal[$nUsed] = $aTemp[$I]
			$nUsed += 1
		EndIf
	Next
	If $nUsed < UBound($aRetVal) - 1 Then
		ReDim $aRetVal[$nUsed]
	EndIf
	Return $aRetVal
EndFunc   ;==>Factor_All