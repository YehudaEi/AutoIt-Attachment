
#cs
_ArraySearchMultiDim
$avArray is the input array
$sFind is a string of what you may be looking for
$sDimension is a string of where you would like to look
	Ex: "[3][4][5]" will search in that index only
	Ex: "[2,6][4][5]" will search the 2nd-6th index of the first dimension, the 4th index of D2, and the 5th index of D3
	Ex: "[3,4][-1][1,2]" will search 3-4 of D1, all of D2, and 1-2 of D3
$bAll is boolean
	If true, all results will be returned in a 2-dimensional array
		[0][0] is the number of results
		[1][1] is the first dimension of the first result
		[1][2] is the second dimension of the first result
		[2][3] is the third dimension of the second result
	If false, either True or False will be returned, True if the string wass found
$bCaseSensitive is boolean, True requires the string to match case
#ce

Func _ArraySearchMultiDim($avArray, $sFind, $sDimension, $bAll = True, $bCaseSensitive = False)
	Local $y, $z, $between, $char
	Local $dimensions = UBound($avArray,0), $lastBreak = 1, $currentDim = 0, $testString = ""
	Local $start[$dimensions], $end[$dimensions], $i[$dimensions]
	If $bAll Then
		Local $final[1][$dimensions]
		$final[0][0] = 0
	EndIf
	For $z = 3 To StringLen($sDimension)
		$char = StringMid($sDimension,$z,1)
		If $char = "," Then
			$start[$currentDim] = StringMid($sDimension,$lastBreak+1,$z-$lastBreak-1)
			For $y = $z+1 To StringLen($sDimension)
				If StringMid($sDimension,$y,1) = "]" Then
					$end[$currentDim] = StringMid($sDimension,$z+1,$y-$z-1)
					$lastBreak = $y+1
					$currentDim += 1
					$z = $y+2
					ExitLoop
				EndIf
			Next
		ElseIf $char = "]" Then
			$between = StringMid($sDimension,$lastBreak+1,$z-$lastBreak-1)
			If $between = "-1" Then
				$start[$currentDim] = 0
				$end[$currentDim] = UBound($avArray,1)
			Else
				$start[$currentDim] = Number($between)
				$end[$currentDim] = Number($between)
			EndIf
			$lastBreak = $z+1
			$currentDim += 1
			$z += 2
		EndIf
	Next
	For $z = 0 To $dimensions - 1
		$i[$z] = $start[$z]
	Next
	While 1
		$testString = ""
		For $z = 0 To $dimensions - 1
			$testString &= "[" & $i[$z] & "]"
		Next
		If $bCaseSensitive Then
			If String(Execute("$avArray" & $testString)) == $sFind Then
				If $bAll Then
					ReDim $final[UBound($final)+1][$dimensions]
					$final[0][0] += 1
					For $z = 1 To $dimensions
						$final[UBound($final)-1][$z] = $i[$z]
					Next
				Else
					Return True
				EndIf
			EndIf
		Else
			If String(Execute("$avArray" & $testString)) = $sFind Then
				If $bAll Then
					ReDim $final[UBound($final)+1][$dimensions]
					$final[0][0] += 1
					For $z = 0 To $dimensions - 1
						$final[UBound($final,1)-1][$z] = $i[$z]
					Next
				Else
					Return True
				EndIf
			EndIf
		EndIf
		For $z = $dimensions - 1 To 0 Step -1
			$i[$z] += 1
			If $i[$z] > $end[$z] Then
				$i[$z] = $start[$z]
			Else
				ExitLoop
			EndIf
		Next
		If $z = -1 Then
			If $bAll Then
				Return $final
			Else
				Return False
			EndIf
		EndIf
	WEnd
	
EndFunc

Func _ArrayDeleteMultiDim(ByRef $avArray, $iIndex, $iDimension = 1)		;doesn't work!
	Local $z, $testString = "", $testString2 = "", $dimensions = UBound($avArray,0)
	Local $i[$dimensions]
	For $z = 0 To $dimensions - 1
		If $z + 1 = $iDimension Then
			$i[$z] = $iIndex
		Else
			$i[$z] = 0
		EndIf
	Next
	While 1
		$testString = ""
		$testString2 = ""
		For $z = 0 To $dimensions - 1
			$testString &= "[" & $i[$z] & "]"
			If $z + 1 = $iDimension Then
				$testString2 &= "[" & $i[$z]+1 & "]"
			Else
				$testString2 &= "[" & $i[$z] & "]"
			EndIf
		Next
		Execute("$avArray" & $testString & " = $avArray" & $testString2) ;doesn't store, simply compares...
		For $z = $dimensions - 1 To 0 Step -1
			$i[$z] += 1
			If $z + 1 = $iDimension Then
				If $i[$z] = UBound($avArray,$z + 1) - 1 Then
					$i[$z] = $iIndex
				Else
					ExitLoop
				EndIf
			Else	
				If $i[$z] = UBound($avArray,$z + 1) Then
					$i[$z] = 0
				Else
					ExitLoop
				EndIf
			EndIf
		Next
		If $z = -1 Then Return
	WEnd
EndFunc

#cs
_ArrayMaxMultiDim
$avArray is the input array
This function returns the highest value in a 2-dimensional array
	[0][0] is the number of indeces that have the highest value
	[0][1] is the highest value
	[1][1] is the first dimension of the first answer
	[2][3] is the third dimension of the second answer
$bAll is boolean
	True will return just the highest value
	False will return the above array
#ce

Func _ArrayMaxMultiDim($avArray, $bAll = True)
	Local $z, $dimensions = UBound($avArray,0), $maxIndex = "", $final[1][2], $testString = ""
	Local $i[$dimensions]
	For $z = 0 To $dimensions -1
		$i[$z] = 0
		$maxIndex &= "[0]"
	Next
	While 1
		$testString = ""
		For $z = 0 To $dimensions - 1
			$testString &= "[" & $i[$z] & "]"
		Next
		If Execute("$avArray" & $testString) > Execute("$avArray" & $maxIndex) Then
			$maxIndex = $testString
			ReDim $final[2][$dimensions]
			$final[0][1] = Execute("$avArray" & $testString)
			$final[0][0] = 1
			For $z = 0 To $dimensions-1
				$final[1][$z] = $i[$z]
			Next
		ElseIf Execute("$avArray" & $testString) = Execute("$avArray" & $maxIndex) Then
			ReDim $final[UBound($final,1)+1][$dimensions]
			$final[0][1] = Execute("$avArray" & $testString)
			$final[0][0] += 1
			For $z = 0 To $dimensions-1
				$final[UBound($final,1)-1][$z] = $i[$z]
			Next
		EndIf
		For $z = $dimensions - 1 To 0 Step -1
			$i[$z] += 1
			If $i[$z] = UBound($avArray,$z + 1) Then
				$i[$z] = 0
			Else
				ExitLoop
			EndIf
		Next
		If $z = -1 Then
			If $bAll Then
				Return $final
			Else
				Return $final[0][1]
			EndIf
		EndIf
	WEnd
EndFunc

#cs
_ArrayMinMultiDim
$avArray is the input array
This function returns the lowest value in a 2-dimensional array
	[0][0] is the number of indeces that have the lowest value
	[0][1] is the lowest value
	[1][1] is the first dimension of the first answer
	[2][3] is the third dimension of the second answer
$bAll is boolean
	True will return just the lowest value
	False will return the above array
#ce

Func _ArrayMinMultiDim($avArray, $bAll = True)
	Local $z, $dimensions = UBound($avArray,0), $maxIndex = "", $final[1][2], $testString = ""
	Local $i[$dimensions]
	For $z = 0 To $dimensions -1
		$i[$z] = 0
		$maxIndex &= "[0]"
	Next
	While 1
		$testString = ""
		For $z = 0 To $dimensions - 1
			$testString &= "[" & $i[$z] & "]"
		Next
		If Execute("$avArray" & $testString) < Execute("$avArray" & $maxIndex) Then
			$maxIndex = $testString
			ReDim $final[2][$dimensions]
			$final[0][1] = Execute("$avArray" & $testString)
			$final[0][0] = 1
			For $z = 0 To $dimensions-1
				$final[1][$z] = $i[$z]
			Next
		ElseIf Execute("$avArray" & $testString) = Execute("$avArray" & $maxIndex) Then
			ReDim $final[UBound($final,1)+1][$dimensions]
			$final[0][1] = Execute("$avArray" & $testString)
			$final[0][0] += 1
			For $z = 0 To $dimensions-1
				$final[UBound($final,1)-1][$z] = $i[$z]
			Next
		EndIf
		For $z = $dimensions - 1 To 0 Step -1
			$i[$z] += 1
			If $i[$z] = UBound($avArray,$z + 1) Then
				$i[$z] = 0
			Else
				ExitLoop
			EndIf
		Next
		If $z = -1 Then
			If $bAll Then
				Return $final
			Else
				Return $final[0][1]
			EndIf
		EndIf
	WEnd
EndFunc

#cs
_ArraySplitMultiDim
$avArray is the input array
This function simply takes the entire array and puts it into a new 1-dimensional array
The order would go as follows on $avArray[2][3][2]
	[0][0][0],[0][0][1],[0][1][0],[0][1][1],[0][2][0],[0][2][1],[1][0][0],etc.
#ce

Func _ArraySplitMultiDim($avArray)
	Local $totalIndeces = 1, $dimensions = UBound($avArray,0)
	Local $i[$dimensions]
	For $z = 1 To $dimensions
		$totalIndeces *= UBound($avArray,$z)
	Next
	Local $final[$totalIndeces]
	For $z = 0 To $dimensions - 1
		$i[$z] = 0
	Next
	For $y = 0 To $totalIndeces - 1
		$testString = ""
		For $z = 0 To $dimensions - 1
			$testString &= "[" & $i[$z] & "]"
		Next
		$final[$y] = Execute("$avArray" & $testString)
		For $z = $dimensions - 1 To 0 Step -1
			$i[$z] += 1
			If $i[$z] = UBound($avArray,$z + 1) Then
				$i[$z] = 0
			Else
				ExitLoop
			EndIf
		Next
	Next
	Return $final
EndFunc

Func _ArraySortMultiDim($avArray, $iDirection)	;haven't written, same problem as _ArrayDeleteMultiDim()
EndFunc

Func _ArraySwapMultiDim($avArray, $sFirstDimension, $sSecondDimension)	;haven't written, same problem as _ArrayDeleteMultiDim()
EndFunc

#cs
_ArrayShowMultiDim
$avArray is the input array
This function simply puts all of the elements into a ListView
There are also input boxes given, one for each dimension
	input an index into each one and the result will be given.
#ce

Func _ArrayShowMultiDim($avArray,$sTitle = "Array Show Multi Dimensions")
	Local $totalIndeces = 1, $dimensions = UBound($avArray,0),$height = 35+$dimensions*30
	Local $i[$dimensions]
	If $height < 200 Then $height = 200
	Local $gui = GUICreate($sTitle,400,$height)
	Local $guiList = GUICtrlCreateList("",10,10,320,$height-20,0x200000)
	GUICtrlSetFont(-2,10,500,0,"Courier New")
	Local $guiInput[$dimensions]
	Local $guiLabel = GUICtrlCreateLabel("",330,30*$dimensions+10,70,15,1)
	For $z = 1 To $dimensions
		$totalIndeces *= UBound($avArray,$z)
		$guiInput[$z - 1] = GUICtrlCreateInput("0",340,30*$z-20,50,20,0x2000)
	Next
	Local $final[$totalIndeces]
	For $z = 0 To $dimensions - 1
		$i[$z] = 0
	Next
	For $y = 0 To $totalIndeces - 1
		$testString = ""
		For $z = 0 To $dimensions - 1
			$testString &= "[" & $i[$z] & "]"
		Next
		GUICtrlSetData($guiList,$testString & " = " & Execute("$avArray" & $testString))
		For $z = $dimensions - 1 To 0 Step -1
			$i[$z] += 1
			If $i[$z] = UBound($avArray,$z + 1) Then
				$i[$z] = 0
			Else
				ExitLoop
			EndIf
		Next
	Next
	GUISetState()
	While 1
		If GUIGetMsg() = -3 Then
			GUIDelete($gui)
			Return
		EndIf
		$testString = ""
		For $z = 0 To $dimensions - 1
			If GUICtrlRead($guiInput[$z]) = "" Then ExitLoop
			$testString &= "[" & GUICtrlRead($guiInput[$z]) & "]"
		Next
		$testString = String(Execute("$avArray" & $testString))
		If $testString <> GUICtrlRead($guiLabel) Then GUICtrlSetData($guiLabel,$testString)
	WEnd
EndFunc