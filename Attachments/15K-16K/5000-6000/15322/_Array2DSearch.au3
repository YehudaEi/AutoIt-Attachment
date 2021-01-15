;----------------------------------------------------------------------------------------------------------------------
;
;	Function		_Array2DSearch($avArray, $vWhat2Find [, $iDim=-1 [, $iStart=0 [, $iEnd=0 [, $iCaseSense=0 [, $fPartialSearch=False]]]]])
;
;	Description		Finds all Entry's like $vWhat2Find in an 1D/2D Array 
;					Works with all occurences in 2nd Dimension
;					Search in all occurences or only in a given column
;					To set numeric values for default, you can use -1
;
;	Parameter		$avArray		The array to search
;					$vWhat2Find		What to search $avArray for
;		optional	$iDim			Index of Dimension to search; default -1 (all)
;		optional	$iStart			Start array index for search; default 0
;		optional	$iEnd			End array index for search; default 0
;		optional	$iCaseSense		If set to 1 then search is case sensitive; default 0
;		optional	$fPartialSearch	If set to True then executes a partial search. default False
;
;	Return			Succes			Array with Index of matches, Array[0] includes the count of matches
;									In an 2D Array you got for every match [iRow|iCol]
;									Array[0] = 0 if no element found
;					Failure			0 and set @error
;									@error = 1	given array is not array
;									@error = 2	given dim is out of range
;									@error = 4	$iStart is out of range
;									@error = 8  $iEnd is out of range
;
;	Author			BugFix  (bugfix@autoit.de)
;----------------------------------------------------------------------------------------------------------------------
Func _Array2DSearch($avArray, $vWhat2Find, $iDim=-1, $iStart=0, $iEnd=0, $iCaseSense=0, $fPartialSearch=False)
	Local $error = 0, $1D, $arFound[1]=[0]
	If ( Not IsArray($avArray) ) Then
		SetError(1)
		Return 0
	EndIf
	Local $UBound2nd = UBound($avArray,2)
	If @error = 2 Then $1D = True
	If ( $iEnd = 0 ) Or ( $iEnd = -1 ) Then $iEnd = UBound($avArray)-1
	If $iStart = -1 Then $iStart = 0
	If $iCaseSense = -1 Then $iCaseSense = 0
	If $iCaseSense <> 0 Then $iCaseSense = 1
	Select
		Case ( $iDim > $UBound2nd ) Or ( $iDim < -1 )
			$error += 2
		Case ( $iStart < 0 ) Or ( $iStart > UBound($avArray)-1 )
			$error += 4
		Case ( $iEnd < $iStart ) Or ( $iEnd > UBound($avArray)-1 )
			$error += 8
	EndSelect
	If $error <> 0 Then
		SetError($error)
		Return 0
	EndIf
	If $fPartialSearch <> True Then $fPartialSearch = False
	If $1D Then
		For $i = $iStart To $iEnd
			Select
				Case $iCaseSense = 0 And (Not $fPartialSearch)
					If $avArray[$i] = $vWhat2Find Then
						ReDim $arFound[UBound($arFound)+1]
						$arFound[UBound($arFound)-1] = $i
						$arFound[0] += 1
					EndIf
				Case $iCaseSense = 1 And (Not $fPartialSearch)
					If $avArray[$i] == $vWhat2Find Then
						ReDim $arFound[UBound($arFound)+1]
						$arFound[UBound($arFound)-1] = $i
						$arFound[0] += 1
					EndIf
				Case $iCaseSense = 0 And $fPartialSearch
					If StringInStr($avArray[$i], $vWhat2Find) Then
						ReDim $arFound[UBound($arFound)+1]
						$arFound[UBound($arFound)-1] = $i
						$arFound[0] += 1
					EndIf
				Case $iCaseSense = 1 And $fPartialSearch
					If StringInStr($avArray[$i], $vWhat2Find, 1) Then
						ReDim $arFound[UBound($arFound)+1]
						$arFound[UBound($arFound)-1] = $i
						$arFound[0] += 1
					EndIf
			EndSelect
		Next
	Else
		For $i = $iStart To $iEnd
			If $iDim = -1 Then
				Select
					Case $iCaseSense = 0 And (Not $fPartialSearch)
						For $k = 0 To $UBound2nd-1
							If $avArray[$i][$k] = $vWhat2Find Then
								ReDim $arFound[UBound($arFound)+1]
								$arFound[UBound($arFound)-1] = $i & '|' & $k
								$arFound[0] += 1
							EndIf
						Next
					Case $iCaseSense = 1 And (Not $fPartialSearch)
						For $k = 0 To $UBound2nd-1
							If $avArray[$i][$k] == $vWhat2Find Then
								ReDim $arFound[UBound($arFound)+1]
								$arFound[UBound($arFound)-1] = $i & '|' & $k
								$arFound[0] += 1
							EndIf
						Next
					Case $iCaseSense = 0 And $fPartialSearch
						For $k = 0 To $UBound2nd-1
							If StringInStr($avArray[$i][$k], $vWhat2Find) Then
								ReDim $arFound[UBound($arFound)+1]
								$arFound[UBound($arFound)-1] = $i & '|' & $k
								$arFound[0] += 1
							EndIf
						Next
					Case $iCaseSense = 1 And $fPartialSearch
						For $k = 0 To $UBound2nd-1
							If StringInStr($avArray[$i][$k], $vWhat2Find, 1) Then
								ReDim $arFound[UBound($arFound)+1]
								$arFound[UBound($arFound)-1] = $i & '|' & $k
								$arFound[0] += 1
							EndIf
						Next
				EndSelect
			Else
				Select
					Case $iCaseSense = 0 And (Not $fPartialSearch)
						If $avArray[$i][$iDim] = $vWhat2Find Then
							ReDim $arFound[UBound($arFound)+1]
							$arFound[UBound($arFound)-1] = $i & '|' & $iDim
							$arFound[0] += 1
						EndIf
					Case $iCaseSense = 1 And (Not $fPartialSearch)
						If $avArray[$i][$iDim] == $vWhat2Find Then
							ReDim $arFound[UBound($arFound)+1]
							$arFound[UBound($arFound)-1] = $i & '|' & $iDim
							$arFound[0] += 1
						EndIf
					Case $iCaseSense = 0 And $fPartialSearch
						If StringInStr($avArray[$i][$iDim], $vWhat2Find) Then
							ReDim $arFound[UBound($arFound)+1]
							$arFound[UBound($arFound)-1] = $i & '|' & $iDim
							$arFound[0] += 1
						EndIf
					Case $iCaseSense = 1 And $fPartialSearch
						If StringInStr($avArray[$i][$iDim], $vWhat2Find, 1) Then
							ReDim $arFound[UBound($arFound)+1]
							$arFound[UBound($arFound)-1] = $i & '|' & $iDim
							$arFound[0] += 1
						EndIf
				EndSelect
			EndIf
		Next
	EndIf
	Return $arFound
EndFunc ;==>_Array2DSearch