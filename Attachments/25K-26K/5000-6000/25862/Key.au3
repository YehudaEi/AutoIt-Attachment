
#CS

Associative Array UDF by Kip.

Function list:
	
	$kArray = _Key()										; Create a new associative array
	
	_Key_AddItem(ByRef $kArray, $vKey, $vValue)				; Add an item to the end
	_Key_DelItem(ByRef $kArray, $vKey)						; Delete am item
	_Key_Rename(ByRef $kArray, $vKey, $vNewKey)				; Set a new name for a key
	
	_Key_GetKeys(ByRef $kArray)								; Get a normal array with all the keys
	_Key_GetValues(ByRef $kArray)							; Get a normal array with all the values
	_Key_Sort(ByRef $objDict, $iSort=$KEY_Key, $iOrder=$KEY_Asc) 	; Sort an array by key or value and ascending or descending
	
	_Key_KeyExists(ByRef $kArray, $vKey)					; Check whether an item exists
	_Key_GetSize(ByRef $kArray)								; Get the number of items
	
	_Key_Empty(ByRef $kArray)								; Delete all items from the array
	
	_Key_FromArray(ByRef $aArray)							; Create an associative array from a regular one
	_Key_ToArray(ByRef $kArray)								; Create a normal array from an associative array
	
	_Key_Print(ByRef $kArray, $iReturn=0, $sTitle="Array")	; Print the keys to the output stream, or return it as a string
	
#CE


Global Const $KEY_Key  = 0
Global Const $KEY_Item = 1
Global Const $KEY_Asc = 0
Global Const $KEY_Desc = 1




Func _Key()
	
	Local $kArray = ObjCreate("Scripting.Dictionary")
	$kArray.CompareMode = 1
	Return $kArray
	
EndFunc


Func _Key_Rename(ByRef $kArray, $vKey, $vNewKey)
	$kArray.Key($vKey) = $vNewKey
	Return 1
EndFunc

Func _Key_AddItem(ByRef $kArray, $vKey, $vValue)
	Return $kArray.Add($vKey, $vValue)
EndFunc

Func _Key_GetKeys(ByRef $kArray)
	Return $kArray.Keys()
EndFunc

Func _Key_GetSize(ByRef $kArray)
	Return $kArray.Count()
EndFunc

Func _Key_GetValues(ByRef $kArray)
	Return $kArray.Items()
EndFunc

Func _Key_DelItem(ByRef $kArray, $vKey)
	Return $kArray.Remove($vKey)
EndFunc

Func _Key_Empty(ByRef $kArray)
	Return $kArray.RemoveAll()
EndFunc

Func _Key_KeyExists(ByRef $kArray, $vKey)
	
	Local $bReturn
	if $kArray.Exists($vKey) = 0 Then
		$bReturn = False
	Else
		$bReturn = True
	EndIf
	
	Return $bReturn
	
EndFunc

Func _Key_FromArray(ByRef $aArray)
	Local $kReturn = _Key()
	
	For $i = 0 to UBound($aArray)-1
		$kReturn($i) = $aArray[$i]
	Next
	
	Return $kReturn
	
EndFunc

Func _Key_ToArray(ByRef $kArray)
	Local $aReturn[1]
	
	$i = 0
	While 1
		
		if _Key_KeyExists($kArray, $i) Then
			
			ReDim $aReturn[$i+2]
			$aReturn[$i] = $kArray($i)
			
			$i+=1
			
		ElseIf _Key_KeyExists($kArray, String($i)) Then
			
			ReDim $aReturn[$i+2]
			$aReturn[$i] = $kArray(string($i))
			
			$i+=1
			
		Else
			ExitLoop
		EndIf
		
	WEnd
	
	if $i >= 1 Then
		ReDim $aReturn[$i]
	Else
		ReDim $aReturn[1]
		SetError(1)
	EndIf
	
	Return $aReturn
	
EndFunc

Func _Key_Print(ByRef $kArray, $iReturn=0, $sTitle="Array")
	
	Local $sKeys = _Key_GetKeys($kArray)
	Local $sReturn = $sTitle&"{"&@CRLF
	Local $WS
	
    For $i = 0 to UBound($sKeys)-1
		$WS = ""
		for $j = 0 to StringLen($sKeys[$i])+5
			$WS &= " "
		Next
		$sReturn &= " ["&$sKeys[$i]& "] = " &  StringReplace( $kArray($sKeys[$i]) , @CRLF , @CRLF&$WS)  & @CRLF
    Next
	
	$sReturn &= "}"&@CRLF
	
	if $iReturn = 0 Then
		ConsoleWrite($sReturn)
	Else
		Return $sReturn
	EndIf
	
EndFunc

Func _Key_Sort(ByRef $objDict, $iSort=$KEY_Key, $iOrder=$KEY_Asc)
	
	; $iSort  - $KEY_Key 	(sort the keys)
	;			$KEY_Item 	(sort the items)
	; $iOrder - $KEY_Asc	(ascending 123, ABC)
	;			$KEY_Desc	(descending 321, CBA)
	
	Dim $strDict[1][2]
	Dim $objKey
	Dim $strKey, $strItem
	Dim $X,$Y,$Z
	Local $dictItem = $KEY_Item
	Local $dictKey = $KEY_Key
	$Z = $objDict.Count()

	If $Z > 1 Then
		ReDim $strDict[$Z][2]
		$X = 0
		Dim $sKeys = _Key_GetKeys($objDict)
		
		For $i = 0 to UBound($sKeys)-1
			$objKey = $sKeys[$i]
			$strDict[$X][$dictKey]  = String($objKey)
			$strDict[$X][$dictItem] = String($objDict($objKey))
			$X = $X + 1
		Next
	
		If $iOrder = $KEY_Asc Then
		
			For $X = 0 to ($Z - 2)
				For $Y = $X to ($Z - 1)
					If StringCompare($strDict[$X][$iSort],$strDict[$Y][$iSort],1) > 0 Then
						$strKey  = $strDict[$X][$dictKey]
						$strItem = $strDict[$X][$dictItem]
						$strDict[$X][$dictKey]  = $strDict[$Y][$dictKey]
						$strDict[$X][$dictItem] = $strDict[$Y][$dictItem]
						$strDict[$Y][$dictKey]  = $strKey
						$strDict[$Y][$dictItem] = $strItem
					EndIf
				Next
			Next
		
		Else
		
			For $X = 0 to ($Z - 2)
				For $Y = $X to ($Z - 1)
					If StringCompare($strDict[$X][$iSort],$strDict[$Y][$iSort],1) < 0 Then
						$strKey  = $strDict[$X][$dictKey]
						$strItem = $strDict[$X][$dictItem]
						$strDict[$X][$dictKey]  = $strDict[$Y][$dictKey]
						$strDict[$X][$dictItem] = $strDict[$Y][$dictItem]
						$strDict[$Y][$dictKey]  = $strKey
						$strDict[$Y][$dictItem] = $strItem
					EndIf
				Next
			Next
		
		EndIf

		$objDict.RemoveAll()
		
		For $X = 0 to ($Z - 1)
			$objDict.Add($strDict[$X][$dictKey], $strDict[$X][$dictItem])
		Next
		
		Return 1
		
	EndIf
	
	Return 0
	
EndFunc