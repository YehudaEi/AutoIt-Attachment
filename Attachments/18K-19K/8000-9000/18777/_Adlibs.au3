#include-once
Global $sAdLibList

Func _Adlibs()
	Local $sAdLibFuncs, $aAdLibFuncs, $sFuncName, $iFunc

	If Not $sAdLibList = "" Then
		$sAdLibFuncs = StringReplace($sAdLibList, Chr(01) & Chr(01), Chr(01))
		If StringLeft($sAdLibFuncs, 1) = Chr(01) Then $sAdLibFuncs = StringTrimLeft($sAdLibFuncs, 1)
		If StringRight($sAdLibFuncs, 1) = Chr(01) Then $sAdLibFuncs = StringTrimRight($sAdLibFuncs, 1)

		$aAdLibFuncs = StringSplit($sAdLibFuncs, Chr(01))

		For $iFunc = 1 To $aAdLibFuncs[0]
			$sFuncName = StringStripWS($aAdLibFuncs[$iFunc], 3)
			If $sFuncName <> "" Then
				Call($sFuncName)
			EndIf
		Next

	Else
		;The AdLib List is Empty
	EndIf

EndFunc   ;==>_Adlibs

Func _AdLibEnable($sFuncName)
	$sFuncName = StringStripWS($sFuncName, 3)
	If Not StringInStr($sAdLibList, Chr(01) & $sFuncName & Chr(01)) Then
		$sAdLibList &= Chr(01) & $sFuncName & Chr(01)
	EndIf
EndFunc   ;==>_AdLibEnable

Func _AdLibDisable($sFuncName)
	$sFuncName = StringStripWS($sFuncName, 3)
	If StringInStr($sAdLibList, Chr(01) & $sFuncName & Chr(01)) Then
		$sAdLibList = StringReplace($sAdLibList, Chr(01) & $sFuncName & Chr(01), "")
	EndIf
EndFunc   ;==>_AdLibDisable