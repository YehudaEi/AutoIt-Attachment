#include-Once
;~ #AutoIt3Wrapper_Au3Check_Parameters=-d -w 1 -w 2 -w 3 -w- 4 -w 5 -w 6 -w 7
; #INDEX# =======================================================================================================================
; Title .........: Array
; AutoIt Version : 3.2.10++
; Language ......: English
; Description ...: Functions for manipulating arrays.
; Author(s) .....: JdeB, Erik Pilsits, Ultima, Dale (Klaatu) Thompson, Cephas,randallc, Gary Frost, GEOSoft,
;                  Helias Gerassimou(hgeras), Brian Keene, SolidSnake, gcriaco, LazyCoder, Tylo, David Nuttall,
;                  Adam Moore (redndahead), SmOke_N, litlmike, Valik
; ===============================================================================================================================
; #NO_DOC_FUNCTION# =============================================================================================================
; Not documented - function(s) no longer needed, will be worked out of the file at a later date
;
;_ArrayCreate
; ===============================================================================================================================
; #CURRENT# =====================================================================================================================
;_ArrayAdd *
;_ArrayBinarySearch *
;_ArrayCombinations
;_ArrayConcatenate *
;_ArrayDelete
;_ArrayDisplay *
;_ArrayFindAll
;_ArrayInsert *
;_ArrayMax *
;_ArrayMaxIndex
;_ArrayMin *
;_ArrayMinIndex
;_ArrayPermute
;_ArrayPop *
;_ArrayPush *
;_ArrayReverse *
;_ArraySearch
;_ArraySort
;_ArraySwap
;_ArrayToClip *
;_ArrayToString *
;_ArrayTrim *
;_ArrayUnique (Corrected the header information)
; * - #MODIFIED FUNCTIONS#
; ===============================================================================================================================
; #NEW FUNCTIONS ADDED# =========================================================================================================
;_ArrayAddColumns
;_ArrayDeleteColumn
;_ArrayMaxIndex2D
;_ArrayMinIndex2D
; ===============================================================================================================================
; #INTERNAL_USE_ONLY# ===========================================================================================================
;__ArrayQuickSort1D
;__ArrayQuickSort2D
;__Array_ExeterInternal
;__Array_Combinations
;__Array_GetNext
; ===============================================================================================================================
; #FUNCTION# ====================================================================================================================
; Name...........: _ArrayAdd
; Description ...: Adds a specified value at the end of an existing array. Also will add a delimited string to a 2D array.
; Syntax.........: _ArrayAdd(ByRef $avArray, $vValue)
; Parameters ....: $avArray - Array to modify
;                  $vValue  - Value to add
; Return values .: Success - Index of last added item
;                  Failure - -1, sets @error
;                  |1 - $avArray is not an array
;                  |2 - $avArray is not a 1 or 2 dimensional array
;                  |3 - $vValue has too many subitems
; Author ........: Jos van der Zande <jdeb at autoitscript dot com>
; Modified.......: Ultima - code cleanup, BrewManNH - 2D array support
; Remarks .......:
; Related .......: _ArrayConcatenate, _ArrayDelete, _ArrayInsert, _ArrayPop, _ArrayPush
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _ArrayAdd(ByRef $avArray, $vValue, $sSeparator = "|")
	Local $iUBound
	Local $iSubMax
	If Not IsArray($avArray) Then Return SetError(1, 0, -1)
	If UBound($avArray, 0) > 2 Then Return SetError(2, 0, -1)
	Local $avValue = StringSplit($vValue, $sSeparator)
	If Not @error Then
		$iSubMax = $avValue[0]
		If $iSubMax <> UBound($avArray, 2) Then Return SetError(3, 0, 0)
	EndIf
	If UBound($avArray, 0) = 1 Then
		$iUBound = UBound($avArray)
		ReDim $avArray[$iUBound + 1]
		$avArray[$iUBound] = $vValue
		Return $iUBound
	Else
		$iUBound = UBound($avArray)
		ReDim $avArray[$iUBound + 1][$iSubMax]
		For $i = 0 To $iSubMax - 1
			$avArray[$iUBound][$i] = $avValue[$i + 1]
		Next
		Return $iUBound
	EndIf
EndFunc   ;==>_ArrayAdd
; #FUNCTION# ====================================================================================================================
; Name...........: _ArrayAddColumns
; Description ...: Adds a specified number of columns to an array.
; Syntax.........: _ArrayAddColumns(ByRef $aArrayIn, $NumColCount)
; Parameters ....: $aArrayIn - Array to modify
;                  $NumColCount  - Number of columns to add (default = 1)
; Return values .: Success - New array with columns added
;                  Failure - -1, sets @error
;                  |1 - $aArrayIn is not an array
;                  |2 - $NumColCount is an invalid number
;                  |3 - Array has too many dimensions (2D array max)
; Author ........: Malkey
; Remarks .......: This will add any number of columns to a 1D or 2D array of any size and preserves
;                  the contents of the array being modified
; Related .......: _ArrayConcatenate2D, _ArrayDelete, _ArrayInsert, _ArrayPop2D, _ArrayPush
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _ArrayAddColumns(ByRef $aArr, $iNumColToAdd = 1)
	Local $aRet[1]
	If IsArray($aArr) = 0 Then Return SetError(1, 0, -1) ; Filter out non-array
	If $iNumColToAdd < 1 Then Return SetError(2, 0, -1) ; $iNumColToAdd must be greater than zero to add a column.
	If UBound($aArr, 0) > 2 Then Return SetError(3, 0, -1) ; Only allows a 1d or 2d array past this line.
	If UBound($aArr, 0) = 1 Then ; ====== For 1d array ========
		ReDim $aRet[UBound($aArr)][$iNumColToAdd + 1] ; Create new 2d array.
		For $R = 0 To UBound($aArr) - 1
			$aRet[$R][0] = $aArr[$R]
		Next
	Else ; ======= For 2d array ============
		$aRet = $aArr ; So that ByRef $aArr is not altered outside of function.
		ReDim $aRet[UBound($aRet)][UBound($aRet, 2) + $iNumColToAdd] ; ReDim 2d array only.
	EndIf
	Return $aRet
EndFunc   ;==>_ArrayAddColumns
; #FUNCTION# ====================================================================================================================
; Name...........: _ArrayBinarySearch
; Description ...: Uses the binary search algorithm to search through a 1 or 2-dimensional array.
; Syntax.........: _ArrayBinarySearch(Const ByRef $avArray, $vValue[, $iSubItem = 0[, $iStart = 0[, $iEnd = 0]]])
; Parameters ....: $avArray - Array to search
;                  $vValue  - Value to find
;                  $iSubItem - [optional] Which column to search on [Default = First (0) column]
;                  $iStart  - [optional] Index of array to start searching at [Default = start of array]
;                  $iEnd    - [optional] Index of array to stop searching at [Default = end of array]
; Return values .: Success - Index that value was found at
;                  Failure - -1, sets @error to:
;                  |1 - $avArray is not an array
;                  |2 - $vValue outside of array's min/max values
;                  |3 - $vValue was not found in array
;                  |4 - $iStart is greater than $iEnd
;  				   |5 - $iSubItem is greater than actual number of columns
;                  |6 - $avArray has too many dimensions
; Author ........: Jos van der Zande <jdeb at autoitscript dot com>
; Modified.......: Ultima - added $iEnd as parameter, code cleanup
; Modified.......: BrewManNH - added ability to search a 2D array
; Remarks .......: When performing a binary search on an array of items, the contents of the column being searched MUST be
;                  sorted before the search is done, otherwise undefined results will be returned.
; Related .......: _ArrayFindAll, _ArraySearch, _ArrayBinarySearch
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _ArrayBinarySearch(Const ByRef $avArray, $vValue, $iSubItem = 0, $iStart = 0, $iEnd = 0)
	If UBound($avArray, 0) > 2 Then Return SetError(6, 0, -1)
	Local $Is2D = False
	If UBound($avArray, 0) > 1 Then
		$Is2D = True
	EndIf
	If UBound($avArray, 2) < $iSubItem Then Return SetError(5, 0, -1)
	If Not IsArray($avArray) Then Return SetError(1, 0, -1)
	Local $iUBound = UBound($avArray) - 1
	; Bounds checking
	If $iEnd < 1 Or $iEnd > $iUBound Then $iEnd = $iUBound
	If $iStart < 0 Then $iStart = 0
	If $iStart > $iEnd Then Return SetError(4, 0, -1)
	Local $iMid = Int(($iEnd + $iStart) / 2)
	If Not $Is2D Then
		If $avArray[$iStart] > $vValue Or $avArray[$iEnd] < $vValue Then Return SetError(2, 0, -1)
		; Search
		While $iStart <= $iMid And $vValue <> $avArray[$iMid]
			If $vValue < $avArray[$iMid] Then
				$iEnd = $iMid - 1
			Else
				$iStart = $iMid + 1
			EndIf
			$iMid = Int(($iEnd + $iStart) / 2)
		WEnd
		If $iStart > $iEnd Then Return SetError(3, 0, -1) ; Entry not found
		Return $iMid
	Else
		If $avArray[$iStart][$iSubItem] > $vValue Or $avArray[$iEnd][$iSubItem] < $vValue Then Return SetError(2, 0, -1)
		; Search
		While $iStart <= $iMid And $vValue <> $avArray[$iMid][$iSubItem]
			If $vValue < $avArray[$iMid][$iSubItem] Then
				$iEnd = $iMid - 1
			Else
				$iStart = $iMid + 1
			EndIf
			$iMid = Int(($iEnd + $iStart) / 2)
		WEnd
		If $iStart > $iEnd Then Return SetError(3, 0, -1) ; Entry not found
		Return $iMid
	EndIf
EndFunc   ;==>_ArrayBinarySearch
; #FUNCTION# ====================================================================================================================
; Name...........: _ArrayCombinations
; Description ...: Returns an Array of the Combinations of a Set of Elements from a Selected Array
; Syntax.........: _ArrayCombinations(ByRef $avArray, $iSet[, $sDelim = ""])
; Parameters ....: $avArray - The Array to use
;                  $iSet - Size of the combinations set
;                  $sDelim - [optional] String result separator, default is "" for none
; Return values .: Success - Returns an Array of Combinations
;                  |Returns an array, the first element ($array[0]) contains the number of strings returned.
;                  |The remaining elements ($array[1], $array[2], etc.) contain the Combinations.
;                  Failure - Returns 0 and Sets @error:
;                  |1 - The Input Must be an Array
;                  |2 - $avArray is not a 1 dimensional array
; Author ........: Erik Pilsits
; Modified.......: 07/08/2008
; Remarks .......: The input array must be 0-based, i.e. no counter in $array[0]. Based on an algorithm by Kenneth H. Rosen.
;+
;                  http://www.merriampark.com/comb.htm
; Related .......: _ArrayPermute
; Link ..........:
; Example .......: Yes
; ==========================================================================================
Func _ArrayCombinations(ByRef $avArray, $iSet, $sDelim = "")
	If Not IsArray($avArray) Then Return SetError(1, 0, 0)
	If UBound($avArray, 0) <> 1 Then Return SetError(2, 0, 0)
	Local $iN = UBound($avArray)
	Local $iR = $iSet
	Local $aIdx[$iR]
	For $i = 0 To $iR - 1
		$aIdx[$i] = $i
	Next
	Local $iTotal = __Array_Combinations($iN, $iR)
	Local $iLeft = $iTotal
	Local $aResult[$iTotal + 1]
	$aResult[0] = $iTotal
	Local $iCount = 1
	While $iLeft > 0
		__Array_GetNext($iN, $iR, $iLeft, $iTotal, $aIdx)
		For $i = 0 To $iSet - 1
			$aResult[$iCount] &= $avArray[$aIdx[$i]] & $sDelim
		Next
		If $sDelim <> "" Then $aResult[$iCount] = StringTrimRight($aResult[$iCount], 1)
		$iCount += 1
	WEnd
	Return $aResult
EndFunc   ;==>_ArrayCombinations
; #FUNCTION# ====================================================================================================================
; Name...........: _ArrayConcatenate
; Description ...: Concatenate two arrays.
; Syntax.........: _ArrayConcatenate(ByRef $avArrayTarget, Const ByRef $avArraySource, $iStart = 0)
; Parameters ....: $avArrayTarget - The array to concatenate onto
;                  $avArraySource - The array to concatenate from
;                  $iStart - index of the first Source Array entry
; Return values .: Success - $avArrayTarget's new size
;                  Failure - 0, sets @error to:
;                  |1 - $avArrayTarget is not an array
;                  |2 - $avArraySource is not an array
;                  |3 - $avArrayTarget is not a 1 or 2 dimensional array
;                  |4 - $avArraySource is not a 1 or 2 dimensional array
;                  |5 - $avArrayTarget and $avArraySource is not a 1 or 2 dimensional array
;                  |6 - Arrays have different number of subitems
;                  |7 - Arrays have different number of dimensions
; Author ........: Ultima
; Modified.......: Partypooper - added target start index
; Remarks .......:
; Related .......: _ArrayAdd, _ArrayPush
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _ArrayConcatenate(ByRef $avArrayTarget, Const ByRef $avArraySource, $iStart = 0)
	If Not IsArray($avArrayTarget) Then Return SetError(1, 0, 0)
	If Not IsArray($avArraySource) Then Return SetError(2, 0, 0)
	If UBound($avArraySource, 0) <> UBound($avArrayTarget, 0) Then Return SetError(7, 0, 0)
	If UBound($avArrayTarget, 0) > 2 Then
		If UBound($avArraySource, 0) > 2 Then Return SetError(5, 0, 0)
		Return SetError(3, 0, 0)
	EndIf
	If UBound($avArraySource, 0) > 2 Then Return SetError(4, 0, 0)
	If UBound($avArrayTarget, 2) <> UBound($avArraySource, 2) Then Return SetError(6, 0, 0)
	Local $iUBoundTarget = UBound($avArrayTarget) - $iStart, $iUBoundSource = UBound($avArraySource)
	If UBound($avArraySource, 0) = 1 Then
;~ 		Local $iUBoundTarget = UBound($avArrayTarget) - $iStart, $iUBoundSource = UBound($avArraySource)
		ReDim $avArrayTarget[$iUBoundTarget + $iUBoundSource]
		For $i = $iStart To $iUBoundSource - 1
			$avArrayTarget[$iUBoundTarget + $i] = $avArraySource[$i]
		Next
		Return $iUBoundTarget + $iUBoundSource
	Else
		Local  $iSubItems = UBound($avArrayTarget, 2)
		ReDim $avArrayTarget[$iUBoundTarget + $iUBoundSource][$iSubItems]
		For $i = $iStart To $iUBoundSource - 1
			For $x = 0 To $iSubItems - 1
				$avArrayTarget[$iUBoundTarget + $i][$x] = $avArraySource[$i][$x]
			Next
		Next
		Return $iUBoundTarget + $iUBoundSource
	EndIf
EndFunc   ;==>_ArrayConcatenate
; #NO_DOC_FUNCTION# =============================================================================================================
; Name...........: _ArrayCreate
; Description ...: Create a small array and quickly assign values.
; Syntax.........: _ArrayCreate ($v_0 [,$v_1 [,... [, $v_20 ]]])
; Parameters ....: $v_0  - The first element of the array
;                  $v_1  - [optional] The second element of the array
;                  ...
;                  $v_20 - [optional] The twenty-first element of the array
; Return values .: Success - The array with values
; Author ........: Dale (Klaatu) Thompson, Jos van der Zande <jdeb at autoitscript dot com> - rewritten to avoid Eval() errors in Obsufcator
; Modified.......: Ultima
; Remarks .......: Arrays of up to 21 elements in size can be created with this function.
; Related .......:
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _ArrayCreate($v_0, $v_1 = 0, $v_2 = 0, $v_3 = 0, $v_4 = 0, $v_5 = 0, $v_6 = 0, $v_7 = 0, $v_8 = 0, $v_9 = 0, $v_10 = 0, $v_11 = 0, $v_12 = 0, $v_13 = 0, $v_14 = 0, $v_15 = 0, $v_16 = 0, $v_17 = 0, $v_18 = 0, $v_19 = 0, $v_20 = 0)
	Local $av_Array[21] = [$v_0, $v_1, $v_2, $v_3, $v_4, $v_5, $v_6, $v_7, $v_8, $v_9, $v_10, $v_11, $v_12, $v_13, $v_14, $v_15, $v_16, $v_17, $v_18, $v_19, $v_20]
	ReDim $av_Array[@NumParams]
	Return $av_Array
EndFunc   ;==>_ArrayCreate
; #FUNCTION# ====================================================================================================================
; Name...........: _ArrayDelete
; Description ...: Deletes the specified element from the given array.
; Syntax.........: _ArrayDelete(ByRef $avArray, $iElement)
; Parameters ....: $avArray  - Array to modify
;                  $iElement - Element to delete
; Return values .: Success - New size of the array
;                  Failure - 0, sets @error to:
;                  |1 - $avArray is not an array
;                  |3 - $avArray has too many dimensions (only up to 2D supported)
;                  |(2 - Deprecated error code)
; Author ........: Cephas <cephas at clergy dot net>
; Modified.......: Jos van der Zande <jdeb at autoitscript dot com> - array passed ByRef, Ultima - 2D arrays supported, reworked function (no longer needs temporary array; faster when deleting from end)
; Remarks .......: If the array has one element left (or one row for 2D arrays), it will be set to "" after _ArrayDelete() is used on it.
;+
;                  If the $ilement is greater than the array size then the last element is destroyed.
; Related .......: _ArrayAdd, _ArrayInsert, _ArrayPop, _ArrayPush
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _ArrayDelete(ByRef $avArray, $iElement)
	If Not IsArray($avArray) Then Return SetError(1, 0, 0)
	Local $iUBound = UBound($avArray, 1) - 1
	If Not $iUBound Then
		$avArray = ""
		Return 0
	EndIf
	; Bounds checking
	If $iElement < 0 Then $iElement = 0
	If $iElement > $iUBound Then $iElement = $iUBound
	; Move items after $iElement up by 1
	Switch UBound($avArray, 0)
		Case 1
			For $i = $iElement To $iUBound - 1
				$avArray[$i] = $avArray[$i + 1]
			Next
			ReDim $avArray[$iUBound]
		Case 2
			Local $iSubMax = UBound($avArray, 2) - 1
			For $i = $iElement To $iUBound - 1
				For $j = 0 To $iSubMax
					$avArray[$i][$j] = $avArray[$i + 1][$j]
				Next
			Next
			ReDim $avArray[$iUBound][$iSubMax + 1]
		Case Else
			Return SetError(3, 0, 0)
	EndSwitch
	Return $iUBound
EndFunc   ;==>_ArrayDelete
; #FUNCTION# ====================================================================================================================
; Name...........: _ArrayDeleteColumn
; Description ...: Deletes a specified column from a 2D array.
; Syntax.........: _ArrayDeleteColumn(ByRef $aArrayIn, $iSubItem)
; Parameters ....: $aArrayIn - Array to modify
;                  $iSubItem  - The column to delete
; Return values .: Success - New array with column deleted
;                  Failure - -1, sets @error
;                  |1 - $aArrayIn is not an array
;                  |2 - Array is not a 2D array
;                  |3 - $iSubItem is an invalid number
; Author ........: PsaltyDS
; Remarks .......: This will delete a column from a 2D array of any size and preserves the contents of the
;                  array being modified
; Notes .........: This will NOT create a 1D array from a 2D array even if your final array contains only 1 column
;                  this is because the final array will be dimensioned as a 2D array with the second subitem dimensioned
;                  to zero.
; Related .......: _ArrayConcatenate2D, _ArrayDelete, _ArrayInsert, _ArrayPop2D, _ArrayPush, _ArrayAddColumn
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _ArrayDeleteColumn(ByRef $aArrayIn, $iSubItem)
	If Not IsArray($aArrayIn) Then Return SetError(1, 0, -1); Not an array
	If UBound($aArrayIn, 0) <> 2 Then Return SetError(2, 0, -1); Not a 2D array
	If ($iSubItem < 0) Or ($iSubItem > (UBound($aArrayIn, 2) - 1)) Then Return SetError(3, 0, -1); $iSubItem out of range
	If $iSubItem < UBound($aArrayIn, 2) - 1 Then
		For $c = $iSubItem To UBound($aArrayIn, 2) - 2
			For $R = 0 To UBound($aArrayIn) - 1
				$aArrayIn[$R][$c] = $aArrayIn[$R][$c + 1]
			Next
		Next
	EndIf
	ReDim $aArrayIn[UBound($aArrayIn)][UBound($aArrayIn, 2) - 1]
	Return 1
EndFunc   ;==>_ArrayDeleteColumn
; #FUNCTION# ====================================================================================================================
; Name...........: _ArrayDisplay
; Description ...: Displays given 1D or 2D array array in a listview.
; Syntax.........: _ArrayDisplay(Const ByRef $avArray[, $sTitle = "Array: ListView Display"[, $iItemLimit = -1[, $iTranspose = 0[, $sSeparator = ""[, $sReplace = "|"[, $sHeader = ""]]]]]])
; Parameters ....: $avArray    - Array to display
;                  $sTitle     - [optional] Title to use for window
;                  $iItemLimit - [optional] Maximum number of listview items (rows) to show
;                  $iTranspose - [optional] If set differently than default, will transpose the array if 2D
;                  $sSeparator - [optional] Change Opt("GUIDataSeparatorChar") on-the-fly
;                  $sReplace   - [optional] String to replace any occurrence of $sSeparator with in each array element
;                  $sheader     - [optional] Header column names
; Return values .: Success - 1
;                  Failure - 0, sets @error:
;                  |1 - $avArray is not an array
;                  |2 - $avArray has too many dimensions (only up to 2D supported)
; Author ........: randallc, Ultima
; Modified.......: Gary Frost (gafrost), Ultima, Zedna, jpm, BrewManNH
; Remarks .......: This will now autosize the GUI Window and autosize the column widths to match the longest items
; Related .......:
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _ArrayDisplay(Const ByRef $avArray, $sTitle = "Array: ListView Display", $iItemLimit = -1, $iTranspose = 0, $sSeparator = "", $sReplace = "|", $sHeader = "")
	If Not IsArray($avArray) Then Return SetError(1, 0, 0)
	; Dimension checking
	Local $iDimension = UBound($avArray, 0), $iUBound = UBound($avArray, 1) - 1, $iSubMax = UBound($avArray, 2) - 1
	If $iDimension > 2 Then Return SetError(2, 0, 0)
	; Separator handling
;~     If $sSeparator = "" Then $sSeparator = Chr(1)
	If $sSeparator = "" Then $sSeparator = Chr(124)
	;  Check the separator to make sure it's not used literally in the array
	If _ArraySearch($avArray, $sSeparator, 0, 0, 0, 1) <> -1 Then
		For $x = 1 To 255
			If $x >= 32 And $x <= 127 Then ContinueLoop
			Local $sFind = _ArraySearch($avArray, Chr($x), 0, 0, 0, 1)
			If $sFind = -1 Then
				$sSeparator = Chr($x)
				ExitLoop
			EndIf
		Next
	EndIf
	; Declare variables
	Local $vTmp, $iBuffer = 64
	Local $iColLimit = 250
	Local $iOnEventMode = Opt("GUIOnEventMode", 0), $sDataSeparatorChar = Opt("GUIDataSeparatorChar", $sSeparator)
	; Swap dimensions if transposing
	If $iSubMax < 0 Then $iSubMax = 0
	If $iTranspose Then
		$vTmp = $iUBound
		$iUBound = $iSubMax
		$iSubMax = $vTmp
	EndIf
	; Set limits for dimensions
	If $iSubMax > $iColLimit Then $iSubMax = $iColLimit
	If $iItemLimit < 1 Then $iItemLimit = $iUBound
	If $iUBound > $iItemLimit Then $iUBound = $iItemLimit
	; Set header up
	If $sHeader = "" Then
		$sHeader = "Row  " ; blanks added to adjust column size for big number of rows
		For $i = 0 To $iSubMax
			$sHeader &= $sSeparator & "Col " & $i
		Next
	EndIf
	; Convert array into text for listview
	Local $avArrayText[$iUBound + 1]
	For $i = 0 To $iUBound
		$avArrayText[$i] = "[" & $i & "]"
		For $j = 0 To $iSubMax
			; Get current item
			If $iDimension = 1 Then
				If $iTranspose Then
					$vTmp = $avArray[$j]
				Else
					$vTmp = $avArray[$i]
				EndIf
			Else
				If $iTranspose Then
					$vTmp = $avArray[$j][$i]
				Else
					$vTmp = $avArray[$i][$j]
				EndIf
			EndIf
			; Add to text array
			$vTmp = StringReplace($vTmp, $sSeparator, $sReplace, 0, 1)
			$avArrayText[$i] &= $sSeparator & $vTmp
			; Set max buffer size
			$vTmp = StringLen($vTmp)
			If $vTmp > $iBuffer Then $iBuffer = $vTmp
		Next
	Next
	$iBuffer += 1
	; GUI Constants
	Local Const $_ARRAYCONSTANT_GUI_DOCKBORDERS = 0x66
	Local Const $_ARRAYCONSTANT_GUI_DOCKBOTTOM = 0x40
	Local Const $_ARRAYCONSTANT_GUI_DOCKHEIGHT = 0x0200
	Local Const $_ARRAYCONSTANT_GUI_DOCKLEFT = 0x2
	Local Const $_ARRAYCONSTANT_GUI_DOCKRIGHT = 0x4
	Local Const $_ARRAYCONSTANT_GUI_EVENT_CLOSE = -3
	Local Const $_ARRAYCONSTANT_LVIF_PARAM = 0x4
	Local Const $_ARRAYCONSTANT_LVIF_TEXT = 0x1
	Local Const $_ARRAYCONSTANT_LVM_GETCOLUMNWIDTH = (0x1000 + 29)
	Local Const $_ARRAYCONSTANT_LVM_GETITEMCOUNT = (0x1000 + 4)
	Local Const $_ARRAYCONSTANT_LVM_GETITEMSTATE = (0x1000 + 44)
	Local Const $_ARRAYCONSTANT_LVM_INSERTITEMW = (0x1000 + 77)
	Local Const $_ARRAYCONSTANT_LVM_SETEXTENDEDLISTVIEWSTYLE = (0x1000 + 54)
	Local Const $_ARRAYCONSTANT_LVM_SETITEMW = (0x1000 + 76)
	Local Const $_ARRAYCONSTANT_LVS_EX_FULLROWSELECT = 0x20
	Local Const $_ARRAYCONSTANT_LVS_EX_GRIDLINES = 0x1
	Local Const $_ARRAYCONSTANT_LVS_SHOWSELALWAYS = 0x8
	Local Const $_ARRAYCONSTANT_WS_EX_CLIENTEDGE = 0x0200
	Local Const $_ARRAYCONSTANT_WS_MAXIMIZEBOX = 0x00010000
	Local Const $_ARRAYCONSTANT_WS_MINIMIZEBOX = 0x00020000
	Local Const $_ARRAYCONSTANT_WS_SIZEBOX = 0x00040000
	Local Const $_ARRAYCONSTANT_tagLVITEM = "int Mask;int Item;int SubItem;int State;int StateMask;ptr Text;int TextMax;int Image;int Param;int Indent;int GroupID;int Columns;ptr pColumns"
	Local $iAddMask = BitOR($_ARRAYCONSTANT_LVIF_TEXT, $_ARRAYCONSTANT_LVIF_PARAM)
	Local $tBuffer = DllStructCreate("wchar Text[" & $iBuffer & "]"), $pBuffer = DllStructGetPtr($tBuffer)
	Local $tItem = DllStructCreate($_ARRAYCONSTANT_tagLVITEM), $pItem = DllStructGetPtr($tItem)
	DllStructSetData($tItem, "Param", 0)
	DllStructSetData($tItem, "Text", $pBuffer)
	DllStructSetData($tItem, "TextMax", $iBuffer)
	; Set interface up
	Local $iWidth = 640, $iHeight = 480
	Local $hGUI = GUICreate($sTitle, $iWidth, $iHeight, Default, Default, BitOR($_ARRAYCONSTANT_WS_SIZEBOX, $_ARRAYCONSTANT_WS_MINIMIZEBOX, $_ARRAYCONSTANT_WS_MAXIMIZEBOX))
	Local $aiGUISize = WinGetClientSize($hGUI)
	Local $hListView = GUICtrlCreateListView($sHeader, 0, 0, $aiGUISize[0], $aiGUISize[1] - 26, $_ARRAYCONSTANT_LVS_SHOWSELALWAYS)
	Local $hCopy = GUICtrlCreateButton("Copy Selected", 3, $aiGUISize[1] - 23, $aiGUISize[0] - 6, 20)
	GUICtrlSetResizing($hListView, $_ARRAYCONSTANT_GUI_DOCKBORDERS)
	GUICtrlSetResizing($hCopy, $_ARRAYCONSTANT_GUI_DOCKLEFT + $_ARRAYCONSTANT_GUI_DOCKRIGHT + $_ARRAYCONSTANT_GUI_DOCKBOTTOM + $_ARRAYCONSTANT_GUI_DOCKHEIGHT)
	GUICtrlSendMsg($hListView, $_ARRAYCONSTANT_LVM_SETEXTENDEDLISTVIEWSTYLE, $_ARRAYCONSTANT_LVS_EX_GRIDLINES, $_ARRAYCONSTANT_LVS_EX_GRIDLINES)
	GUICtrlSendMsg($hListView, $_ARRAYCONSTANT_LVM_SETEXTENDEDLISTVIEWSTYLE, $_ARRAYCONSTANT_LVS_EX_FULLROWSELECT, $_ARRAYCONSTANT_LVS_EX_FULLROWSELECT)
	GUICtrlSendMsg($hListView, $_ARRAYCONSTANT_LVM_SETEXTENDEDLISTVIEWSTYLE, $_ARRAYCONSTANT_WS_EX_CLIENTEDGE, $_ARRAYCONSTANT_WS_EX_CLIENTEDGE)
	; Fill listview
	Local $aItem
	For $i = 0 To $iUBound
		If GUICtrlCreateListViewItem($avArrayText[$i], $hListView) = 0 Then
			; use GUICtrlSendMsg() to overcome AutoIt limitation
			$aItem = StringSplit($avArrayText[$i], $sSeparator)
			DllStructSetData($tBuffer, "Text", $aItem[1])
			; Add listview item
			DllStructSetData($tItem, "Item", $i)
			DllStructSetData($tItem, "SubItem", 0)
			DllStructSetData($tItem, "Mask", $iAddMask)
			GUICtrlSendMsg($hListView, $_ARRAYCONSTANT_LVM_INSERTITEMW, 0, $pItem)
			; Set listview subitem text
			DllStructSetData($tItem, "Mask", $_ARRAYCONSTANT_LVIF_TEXT)
			For $j = 2 To $aItem[0]
				DllStructSetData($tBuffer, "Text", $aItem[$j])
				DllStructSetData($tItem, "SubItem", $j - 1)
				GUICtrlSendMsg($hListView, $_ARRAYCONSTANT_LVM_SETITEMW, 0, $pItem)
			Next
		EndIf
	Next
;~  <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< added lines in this section
;~
	; adjust column size to match longest item in the list
	GUICtrlSendMsg($hListView, 4126, 1, -1)
	If $iDimension = 2 Then
		For $i = 2 To UBound($avArray, 2)
			GUICtrlSendMsg($hListView, 4126, $i, -1)
		Next
	EndIf
;~  <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< added lines in this section
;~
	; adjust window width
	$iWidth = 0
	For $i = 0 To $iSubMax + 1
		$iWidth += GUICtrlSendMsg($hListView, $_ARRAYCONSTANT_LVM_GETCOLUMNWIDTH, $i, 0)
	Next
	If $iWidth < 250 Then $iWidth = 230
	$iWidth += 40 ;~ <<<<<<<<<<<<<<<<<<<<<< Changed this value from 20 to 40
	If $iWidth > @DesktopWidth Then $iWidth = @DesktopWidth - 100
	WinMove($hGUI, "", (@DesktopWidth - $iWidth) / 2, Default, $iWidth)
	; Show dialog
	GUISetState(@SW_SHOW, $hGUI)
	While 1
		Switch GUIGetMsg()
			Case $_ARRAYCONSTANT_GUI_EVENT_CLOSE
				ExitLoop
			Case $hCopy
				Local $sClip = ""
				; Get selected indices [ _GUICtrlListView_GetSelectedIndices($hListView, True) ]
				Local $aiCurItems[1] = [0]
				For $i = 0 To GUICtrlSendMsg($hListView, $_ARRAYCONSTANT_LVM_GETITEMCOUNT, 0, 0)
					If GUICtrlSendMsg($hListView, $_ARRAYCONSTANT_LVM_GETITEMSTATE, $i, 0x2) Then
						$aiCurItems[0] += 1
						ReDim $aiCurItems[$aiCurItems[0] + 1]
						$aiCurItems[$aiCurItems[0]] = $i
					EndIf
				Next
				; Generate clipboard text
				If Not $aiCurItems[0] Then
					For $sItem In $avArrayText
						$sClip &= $sItem & @CRLF
					Next
				Else
					For $i = 1 To UBound($aiCurItems) - 1
						$sClip &= $avArrayText[$aiCurItems[$i]] & @CRLF
					Next
				EndIf
				ClipPut($sClip)
		EndSwitch
	WEnd
	GUIDelete($hGUI)
	Opt("GUIOnEventMode", $iOnEventMode)
	Opt("GUIDataSeparatorChar", $sDataSeparatorChar)
	Return 1
EndFunc   ;==>_ArrayDisplay
; #FUNCTION# ====================================================================================================================
; Name...........: _ArrayFindAll
; Description ...: Find the indices of all ocurrences of a search query between two points in a 1D or 2D array using _ArraySearch().
; Syntax.........: _ArrayFindAll(Const ByRef $avArray, $vValue[, $iStart = 0[, $iEnd = 0[, $iCase = 0[, $iPartial = 0[, $iSubItem = 0]]]]])
; Parameters ....: $avArray  - The array to search
;                  $vValue   - What to search $avArray for
;                  $iStart   - [optional] Index of array to start searching at
;                  $iEnd     - [optional] Index of array to stop searching at
;                  $iCase    - [optional] If set to 1, search is case sensitive
;                  $iPartial - [optional] If set to 1, executes a partial search
;                  $iSubItem - [optional] Sub-index to search on in 2D arrays
; Return values .: Success - An array of all index numbers in array containing $vValue
;                  Failure - -1, sets @error (see _ArraySearch() description for error codes)
; Author ........: GEOSoft, Ultima
; Modified.......:
; Remarks .......:
; Related .......: _ArrayBinarySearch, _ArraySearch
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _ArrayFindAll(Const ByRef $avArray, $vValue, $iStart = 0, $iEnd = 0, $iCase = 0, $iPartial = 0, $iSubItem = 0)
	$iStart = _ArraySearch($avArray, $vValue, $iStart, $iEnd, $iCase, $iPartial, 1, $iSubItem)
	If @error Then Return SetError(@error, 0, -1)
	Local $iIndex = 0, $avResult[UBound($avArray)]
	Do
		$avResult[$iIndex] = $iStart
		$iIndex += 1
		$iStart = _ArraySearch($avArray, $vValue, $iStart + 1, $iEnd, $iCase, $iPartial, 1, $iSubItem)
	Until @error
	ReDim $avResult[$iIndex]
	Return $avResult
EndFunc   ;==>_ArrayFindAll
; #FUNCTION# ====================================================================================================================
; Name...........: _ArrayInsert
; Description ...: Add a new value at the specified position.
; Syntax.........: _ArrayInsert(ByRef $avArray, $iElement[, $vValue = ""[, $sDelim = "|"]])
; Parameters ....: $avArray  - Array to modify
;                  $iElement - Position to insert item at:
;                                If $iElement <= 0 then item will be inserted at the start of the array
;                                If $iElement > than the size of the array, the item will be added to the end of the array.
;                  $vValue   - [optional] Value of item to insert
;                  $sDelim	 - [optional] Delimiter character to split incoming string on, default is | character
; Return values .: Success - New size of the array
;                  Failure - 0, sets @error
;                  |1 - $avArray is not an array
;                  |2 - $avArray is not a 1 or 2 dimensional array
;                  |3 - $vValue has different number of subitems than $avArray, when using a 2D array.
; Author ........: Jos van der Zande <jdeb at autoitscript dot com>
; Modified.......: Ultima - code cleanup
; Modified.......: BrewManNH - Added 2D array support
; Remarks .......:
; Related .......: _ArrayAdd, _ArrayDelete, _ArrayPop, _ArrayPush
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _ArrayInsert(ByRef $avArray, $iElement, $vValue = "", $sDelim = "|")
	If Not IsArray($avArray) Then Return SetError(1, 0, 0)
	If UBound($avArray, 0) > 2 Then Return SetError(2, 0, 0)
	If $iElement > UBound($avArray) Then $iElement = UBound($avArray)
	If $iElement < 0 Then $iElement = 0
	; Add 1 to the array
	Local $iUBound = UBound($avArray) + 1, $iMaxSubItems = UBound($avArray, 2), $iDimension = UBound($avArray, 0)
	If $iDimension = 1 Then
		ReDim $avArray[$iUBound]
		; Move all entries over til the specified element
		For $i = $iUBound - 1 To $iElement + 1 Step -1
			$avArray[$i] = $avArray[$i - 1]
		Next
		; Add the value in the specified element
		$avArray[$iElement] = $vValue
		Return $iUBound
	Else
		ReDim $avArray[$iUBound][$iMaxSubItems]
		Local $avValue = StringSplit($vValue, $sDelim, 2)
		If UBound($avValue) <> $iMaxSubItems Then Return SetError(3, 0, 0)
		For $i = $iUBound - 1 To $iElement + 1 Step -1
			For $j = 0 To $iMaxSubItems - 1
				$avArray[$i][$j] = $avArray[$i - 1][$j]
			Next
		Next
		; Add the value in the specified element
		For $j = 0 To $iMaxSubItems - 1
			$avArray[$iElement][$j] = $avValue[$j]
		Next
		Return $iUBound
	EndIf
EndFunc   ;==>_ArrayInsert
; #FUNCTION# ====================================================================================================================
; Name...........: _ArrayMax
; Description ...: Returns the highest value held in an array.
; Syntax.........: _ArrayMax(Const ByRef $avArray[, $iCompNumeric = 0[, $iStart = 0[, $iEnd = 0[, $iSubItem = 0]]]])
; Parameters ....: $avArray      - Array to search
;                  $iCompNumeric - [optional] Comparison method:
;                  |0 - compare alphanumerically
;                  |1 - compare numerically
;                  $iStart       - [optional] Index of array to start searching at
;                  $iEnd         - [optional] Index of array to stop searching at
;                  $iSubItem     - [optional] Subitem to search (first subitem is 0)
; Return values .: Success - The maximum value in the array
;                  Failure - "", sets @error (see _ArrayMaxIndex() description for error codes)
; Author ........: Cephas <cephas at clergy dot net>
; Modified.......: Jos van der Zande <jdeb at autoitscript dot com> - Added $iCompNumeric and $iStart parameters and logic, Ultima - added $iEnd parameter, code cleanup
; Modified.......: BrewManNH - Added 2D array support
; Remarks .......:
; Related .......: _ArrayMaxIndex, _ArrayMin, _ArrayMinIndex, _ArrayUnique
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _ArrayMax(Const ByRef $avArray, $iCompNumeric = 0, $iStart = 0, $iEnd = 0, $iSubItem = 0)
	Local $iResult
	If $iSubItem > UBound($avArray, 2) - 1 Then $iSubItem = UBound($avArray, 2) - 1
	If $iSubItem < 1 Then $iSubItem = 0
	If UBound($avArray, 0) = 1 Then
		$iResult  = _ArrayMaxIndex($avArray, $iCompNumeric, $iStart, $iEnd)
		If @error Then Return SetError(@error, 0, "")
		Return $avArray[$iResult]
	Else
		$iResult = _ArrayMaxIndex2D($avArray, $iCompNumeric, $iStart, $iEnd, $iSubItem)
		If @error Then Return SetError(@error, 0, "")
		Return $avArray[$iResult][$iSubItem]
	EndIf
EndFunc   ;==>_ArrayMax
; #FUNCTION# ====================================================================================================================
; Name...........: _ArrayMaxIndex
; Description ...: Returns the index where the highest value occurs in the array.
; Syntax.........: _ArrayMaxIndex(Const ByRef $avArray[, $iCompNumeric = 0[, $iStart = 0[, $iEnd = 0]]])
; Parameters ....: $avArray      - Array to search
;                  $iCompNumeric - [optional] Comparison method:
;                  |0 - compare alphanumerically
;                  |1 - compare numerically
;                  $iStart       - [optional] Index of array to start searching at
;                  $iEnd         - [optional] Index of array to stop searching at
; Return values .: Success - The index of the maximum value in the array
;                  Failure - -1, sets @error to:
;                  |1 - $avArray is not an array
;                  |2 - $iStart is greater than $iEnd
;                  |3 - $avArray is not a 1 dimensional array
; Author ........: Cephas <cephas at clergy dot net>
; Modified.......: Jos van der Zande <jdeb at autoitscript dot com> - Added $iCompNumeric and $iStart parameters and logic, Ultima - added $iEnd parameter, code cleanup, optimization
; Remarks .......:
; Related .......: _ArrayMax, _ArrayMin, _ArrayMinIndex
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _ArrayMaxIndex(Const ByRef $avArray, $iCompNumeric = 0, $iStart = 0, $iEnd = 0)
	If Not IsArray($avArray) Or UBound($avArray, 0) <> 1 Then Return SetError(1, 0, -1)
	If UBound($avArray, 0) <> 1 Then Return SetError(3, 0, -1)
	Local $iUBound = UBound($avArray) - 1
	; Bounds checking
	If $iEnd < 1 Or $iEnd > $iUBound Then $iEnd = $iUBound
	If $iStart < 0 Then $iStart = 0
	If $iStart > $iEnd Then Return SetError(2, 0, -1)
	Local $iMaxIndex = $iStart
	; Search
	If $iCompNumeric Then
		For $i = $iStart To $iEnd
			If Number($avArray[$iMaxIndex]) < Number($avArray[$i]) Then $iMaxIndex = $i
		Next
	Else
		For $i = $iStart To $iEnd
			If $avArray[$iMaxIndex] < $avArray[$i] Then $iMaxIndex = $i
		Next
	EndIf
	Return $iMaxIndex
EndFunc   ;==>_ArrayMaxIndex
; #FUNCTION# ====================================================================================================================
; Name...........: _ArrayMaxIndex2D
; Description ...: Returns the index where the highest value occurs in the array.
; Syntax.........: _ArrayMax2DIndex(Const ByRef $avArray[, $iCompNumeric = 0[, $iStart = 0[, $iEnd = 0[, $iSubItem = ]]]])
; Parameters ....: $avArray      - Array to search
;                  $iCompNumeric - [optional] Comparison method:
;                  |0 - compare alphanumerically
;                  |1 - compare numerically
;                  $iStart       - [optional] Index of array to start searching at
;                  $iEnd         - [optional] Index of array to stop searching at
;                  $iSubItem     - [optional] Subitem to search
; Return values .: Success - The index of the maximum value in the array
;                  Failure - -1, sets @error to:
;                  |1 - $avArray is not an array
;                  |2 - $iStart is greater than $iEnd
;                  |3 - $avArray is not a 2 dimensional array
; Author ........: Cephas <cephas at clergy dot net>
; Modified.......: Jos van der Zande <jdeb at autoitscript dot com> - Added $iCompNumeric and $iStart parameters and logic, Ultima - added $iEnd parameter, code cleanup, optimization
; Modified.......: BrewManNH - Added 2D array support
; Remarks .......: This a modified version of _ArrayMaxIndex which adds support for 2D arrays.
; Related .......: _ArrayMax, _ArrayMin, _ArrayMaxIndex
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _ArrayMaxIndex2D(Const ByRef $avArray, $iCompNumeric = 0, $iStart = 0, $iEnd = 0, $iSubItem = 0)
	If Not IsArray($avArray) Or UBound($avArray, 0) <> 2 Then Return SetError(1, 0, -1)
	If UBound($avArray, 0) <> 2 Then Return SetError(3, 0, -1)
	Local $iUBound = UBound($avArray) - 1
	; Bounds checking
	If $iEnd < 1 Or $iEnd > $iUBound Then $iEnd = $iUBound
	If $iSubItem > UBound($avArray, 2) - 1 Then $iSubItem = UBound($avArray, 2) - 1
	If $iSubItem < 1 Then $iSubItem = 0
	If $iStart < 0 Then $iStart = 0
	If $iStart > $iEnd Then Return SetError(2, 0, -1)
	Local $iMaxIndex = $iStart
	; Search
	If $iCompNumeric Then
		For $i = $iStart To $iEnd
			If Number($avArray[$iMaxIndex][$iSubItem]) < Number($avArray[$i][$iSubItem]) Then $iMaxIndex = $i
		Next
	Else
		For $i = $iStart To $iEnd
			If $avArray[$iMaxIndex][$iSubItem] < $avArray[$i][$iSubItem] Then $iMaxIndex = $i
		Next
	EndIf
	Return $iMaxIndex
EndFunc   ;==>_ArrayMaxIndex2D
; #FUNCTION# ====================================================================================================================
; Name...........: _ArrayMin
; Description ...: Returns the lowest value held in an array.
; Syntax.........: _ArrayMin(Const ByRef $avArray[, $iCompNumeric = 0[, $iStart = 0[, $iEnd = 0[, $iSubItem = 0]]]])
; Parameters ....: $avArray      - Array to search
;                  $iCompNumeric - [optional] Comparison method:
;                  |0 - compare alphanumerically
;                  |1 - compare numerically
;                  $iStart       - [optional] Index of array to start searching at
;                  $iEnd         - [optional] Index of array to stop searching at
;                  $iSubItem     - [optional] Subitem to search
; Return values .: Success - The minimum value in the array
;                  Failure - "", sets @error (see _ArrayMinIndex2D() description for error codes)
; Author ........: Cephas <cephas at clergy dot net>
; Modified.......: Jos van der Zande <jdeb at autoitscript dot com> - Added $iCompNumeric and $iStart parameters and logic, Ultima - added $iEnd parameter, code cleanup
; Modified.......: BrewManNH - Added 2D array support
; Remarks .......:
; Related .......: _ArrayMax2D, _ArrayMax2DIndex, _ArrayMinIndex2D, _ArrayUnique
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _ArrayMin(Const ByRef $avArray, $iCompNumeric = 0, $iStart = 0, $iEnd = 0, $iSubItem = 0)
	Local $iResult
	If $iSubItem > UBound($avArray, 2) - 1 Then $iSubItem = UBound($avArray, 2) - 1
	If $iSubItem < 1 Then $iSubItem = 0
	If UBound($avArray, 0) = 1 Then
		$iResult = _ArrayMinIndex($avArray, $iCompNumeric, $iStart, $iEnd)
		If @error Then Return SetError(@error, 0, "")
		Return $avArray[$iResult]
	Else
		$iResult  = _ArrayMinIndex2D($avArray, $iCompNumeric, $iStart, $iEnd, $iSubItem)
		If @error Then Return SetError(@error, 0, "")
		Return $avArray[$iResult][$iSubItem]
	EndIf
EndFunc   ;==>_ArrayMin
; #FUNCTION# ====================================================================================================================
; Name...........: _ArrayMinIndex
; Description ...: Returns the index where the lowest value occurs in the array.
; Syntax.........: _ArrayMinIndex(Const ByRef $avArray[, $iCompNumeric = 0[, $iStart = 0[, $iEnd = 0]]])
; Parameters ....: $avArray      - Array to search
;                  $iCompNumeric - [optional] Comparison method:
;                  |0 - compare alphanumerically
;                  |1 - compare numerically
;                  $iStart       - [optional] Index of array to start searching at
;                  $iEnd         - [optional] Index of array to stop searching at
; Return values .: Success - The index of the minimum value in the array
;                  Failure - -1, sets @error to:
;                  |1 - $avArray is not an array
;                  |2 - $iStart is greater than $iEnd
;                  |3 - $avArray is not a 1 dimensional array
; Author ........: Cephas <cephas at clergy dot net>
; Modified.......: Jos van der Zande <jdeb at autoitscript dot com> - Added $iCompNumeric and $iStart parameters and logic, Ultima - added $iEnd parameter, code cleanup, optimization
; Remarks .......:
; Related .......: _ArrayMax, _ArrayMaxIndex, _ArrayMin
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _ArrayMinIndex(Const ByRef $avArray, $iCompNumeric = 0, $iStart = 0, $iEnd = 0)
	If Not IsArray($avArray) Then Return SetError(1, 0, -1)
	If UBound($avArray, 0) <> 1 Then Return SetError(3, 0, -1)
	Local $iUBound = UBound($avArray) - 1
	; Bounds checking
	If $iEnd < 1 Or $iEnd > $iUBound Then $iEnd = $iUBound
	If $iStart < 0 Then $iStart = 0
	If $iStart > $iEnd Then Return SetError(2, 0, -1)
	Local $iMinIndex = $iStart
	; Search
	If $iCompNumeric Then
		For $i = $iStart To $iEnd
			If Number($avArray[$iMinIndex]) > Number($avArray[$i]) Then $iMinIndex = $i
		Next
	Else
		For $i = $iStart To $iEnd
			If $avArray[$iMinIndex] > $avArray[$i] Then $iMinIndex = $i
		Next
	EndIf
	Return $iMinIndex
EndFunc   ;==>_ArrayMinIndex
; #FUNCTION# ====================================================================================================================
; Name...........: _ArrayMinIndex2D
; Description ...: Returns the index where the lowest value occurs in the array.
; Syntax.........: _ArrayMinIndex2D(Const ByRef $avArray[, $iCompNumeric = 0[, $iStart = 0[, $iEnd = 0[, $iSubItem = 0]]]])
; Parameters ....: $avArray      - Array to search
;                  $iCompNumeric - [optional] Comparison method:
;                  |0 - compare alphanumerically
;                  |1 - compare numerically
;                  $iStart       - [optional] Index of array to start searching at
;                  $iEnd         - [optional] Index of array to stop searching at
;                  $iSubItem     - [optional] Subitem to search
; Return values .: Success - The index of the minimum value in the array
;                  Failure - -1, sets @error to:
;                  |1 - $avArray is not an array
;                  |2 - $iStart is greater than $iEnd
;                  |3 - $avArray is not a 2 dimensional array
; Author ........: Cephas <cephas at clergy dot net>
; Modified.......: Jos van der Zande <jdeb at autoitscript dot com> - Added $iCompNumeric and $iStart parameters and logic, Ultima - added $iEnd parameter, code cleanup, optimization
; Modified.......: BrewManNH - Added 2D array support
; Remarks .......: This a modified version of _ArrayMinIndex which adds support for 2D arrays.
; Related .......: _ArrayMax2D, _ArrayMaxIndex, _ArrayMin2D
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _ArrayMinIndex2D(Const ByRef $avArray, $iCompNumeric = 0, $iStart = 0, $iEnd = 0, $iSubItem = 0)
	If Not IsArray($avArray) Then Return SetError(1, 0, -1)
	If UBound($avArray, 0) <> 2 Then Return SetError(3, 0, -1)
	Local $iUBound = UBound($avArray) - 1
	; Bounds checking
	If $iEnd < 1 Or $iEnd > $iUBound Then $iEnd = $iUBound
	If $iSubItem > UBound($avArray, 2) - 1 Then $iSubItem = UBound($avArray, 2) - 1
	If $iSubItem < 1 Then $iSubItem = 0
	If $iStart < 0 Then $iStart = 0
	If $iStart > $iEnd Then Return SetError(2, 0, -1)
	Local $iMinIndex = $iStart
	; Search
	If $iCompNumeric Then
		For $i = $iStart To $iEnd
			If Number($avArray[$iMinIndex][$iSubItem]) > Number($avArray[$i][$iSubItem]) Then $iMinIndex = $i
		Next
	Else
		For $i = $iStart To $iEnd
			If $avArray[$iMinIndex][$iSubItem] > $avArray[$i][$iSubItem] Then $iMinIndex = $i
		Next
	EndIf
	Return $iMinIndex
EndFunc   ;==>_ArrayMinIndex2D
; #FUNCTION# ====================================================================================================================
; Name...........: _ArrayPermute
; Description ...: Returns an Array of the Permutations of all Elements in an Array
; Syntax.........: _ArrayPermute(ByRef $avArray[, $sDelim = ""])
; Parameters ....: $avArray - The Array to get Permutations
;                  $sDelim - [optional] String result separator, default is "" for none
; Return values .: Success - Returns an Array of Permutations
;                  |$array[0] contains the number of strings returned.
;                  |The remaining elements ($array[1], $array[2] ... $array[n]) contain the Permutations.
;                  |Failure - Returns 0 and Sets @error:
;                  |1 - The Input Must be an Array
;                  |2 - $avArray is not a 1 dimensional array
; Author ........: Erik Pilsits
; Modified.......: 07/08/2008
; Remarks .......: The input array must be 0-based, i.e. no counter in $array[0].  Based on the algorithm by Alexander Bogomolny.
;+
;                  http://www.bearcave.com/random_hacks/permute.html
; Related .......: _ArrayCombinations
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _ArrayPermute(ByRef $avArray, $sDelim = "")
	If Not IsArray($avArray) Then Return SetError(1, 0, 0)
	If UBound($avArray, 0) <> 1 Then Return SetError(2, 0, 0)
	Local $iSize = UBound($avArray), $iFactorial = 1, $aIdx[$iSize], $aResult[1], $iCount = 1
	For $i = 0 To $iSize - 1
		$aIdx[$i] = $i
	Next
	For $i = $iSize To 1 Step -1
		$iFactorial *= $i
	Next
	ReDim $aResult[$iFactorial + 1]
	$aResult[0] = $iFactorial
	__Array_ExeterInternal($avArray, 0, $iSize, $sDelim, $aIdx, $aResult, $iCount)
	Return $aResult
EndFunc   ;==>_ArrayPermute
; #FUNCTION# ====================================================================================================================
; Name...........: _ArrayPop
; Description ...: Returns the last element of an array, deleting that element from the array at the same time.
; Syntax.........: _ArrayPop(ByRef $avArray[, $cDelim = "|"])
; Parameters ....: $avArray - Array to modify
;                  $cDelim - [optional] For 2D arrays, the delimiter to insert between elements in the returned string.
; Return values .: Success - The last element of the array, or for 2D arrays, the last "row" of the array in a delimited string
;                  Failure - "", sets @error
;                  |1 - The Input Must be an Array
;                  |2 - $avArray is not a 1 or 2 dimensional array
; Author ........: Cephas <cephas at clergy dot net>
; Modified.......: Ultima - code cleanup
; Modified.......: BrewManNH - Added 2D array support
; Remarks .......: If the array has one element left, it will be set to "" after _ArrayPop() is used on it.
; Related .......: _ArrayAdd, _ArrayDelete, _ArrayInsert, _ArrayPush
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _ArrayPop(ByRef $avArray, $cDelim = "|")
	Local $iUBound, $sLastVal
	If (Not IsArray($avArray)) Then Return SetError(1, 0, "")
	If UBound($avArray, 0) > 2 Then Return SetError(2, 0, "")
	If UBound($avArray, 0) = 1 Then
		$iUBound  = UBound($avArray) - 1
		$sLastVal = $avArray[$iUBound]
		; Remove last item
		If Not $iUBound Then
			$avArray = ""
		Else
			ReDim $avArray[$iUBound]
		EndIf
		; Return last item
		Return $sLastVal
	Else
		$iUBound = UBound($avArray) - 1
		Local $iSubItems = UBound($avArray, 2)
		$sLastVal = $avArray[$iUBound][0] & $cDelim
		For $j = 1 To $iSubItems - 1
			$sLastVal &= $avArray[$iUBound][$j] & $cDelim
		Next
		; Remove last item
		If Not $iUBound Then
			$avArray = ""
		Else
			ReDim $avArray[$iUBound][$iSubItems]
		EndIf
		; Return last item
		Return StringTrimRight($sLastVal, StringLen($cDelim))
	EndIf
EndFunc   ;==>_ArrayPop
; #FUNCTION# ====================================================================================================================
; Name...........: _ArrayPush
; Description ...: Add new values without increasing array size by inserting at the end the new value and deleting the first one or vice versa.
; Syntax.........: _ArrayPush(ByRef $avArray, $vValue[, $iDirection = 0])
; Parameters ....: $avArray    - Array to modify
;                  $vValue     - Value(s) to add (can be in an array)
;                  $iDirection - [optional] Direction to push existing array elements:
;                  |0 = Slide left (adding at the end)
;                  |1 = Slide right (adding at the start)
; Return values .: Success - 1
;                  Failure - 0, sets @error:
;                  |1 - $avArray is not an array
;                  |2 - $vValue is an array larger than $avArray (so it can't fit)
;                  |3 - $avArray is not a 1 dimensional array
; Author ........: Helias Gerassimou(hgeras), Ultima - code cleanup/rewrite (major optimization), fixed support for $vValue as an array
; Modified.......:
; Remarks .......: This function is used for continuous updates of data in array, where in other cases a vast size of array would be created.
;                  It keeps all values inside the array (something like History), minus the first one or the last one depending on direction chosen.
;                  It is similar to the push command in assembly.
; Related .......: _ArrayAdd, _ArrayConcatenate, _ArrayDelete, _ArrayInsert, _ArrayPop
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _ArrayPush(ByRef $avArray, $vValue, $iDirection = 0)
	If (Not IsArray($avArray)) Then Return SetError(1, 0, 0)
	If UBound($avArray, 0) <> 1 Then Return SetError(3, 0, 0)
	Local $iUBound = UBound($avArray) - 1
	If IsArray($vValue) Then ; $vValue is an array
		Local $iUBoundS = UBound($vValue)
		If ($iUBoundS - 1) > $iUBound Then Return SetError(2, 0, 0)
		; $vValue is an array smaller than $avArray
		If $iDirection Then ; slide right, add to front
			For $i = $iUBound To $iUBoundS Step -1
				$avArray[$i] = $avArray[$i - $iUBoundS]
			Next
			For $i = 0 To $iUBoundS - 1
				$avArray[$i] = $vValue[$i]
			Next
		Else ; slide left, add to end
			For $i = 0 To $iUBound - $iUBoundS
				$avArray[$i] = $avArray[$i + $iUBoundS]
			Next
			For $i = 0 To $iUBoundS - 1
				$avArray[$i + $iUBound - $iUBoundS + 1] = $vValue[$i]
			Next
		EndIf
	Else
		If $iDirection Then ; slide right, add to front
			For $i = $iUBound To 1 Step -1
				$avArray[$i] = $avArray[$i - 1]
			Next
			$avArray[0] = $vValue
		Else ; slide left, add to end
			For $i = 0 To $iUBound - 1
				$avArray[$i] = $avArray[$i + 1]
			Next
			$avArray[$iUBound] = $vValue
		EndIf
	EndIf
	Return 1
EndFunc   ;==>_ArrayPush
; #FUNCTION# ====================================================================================================================
; Name...........: _ArrayReverse
; Description ...: Takes the given array and reverses the order in which the elements appear in the array.
; Syntax.........: _ArrayReverse(ByRef $avArray[, $iStart = 0[, $iEnd = 0]])
; Parameters ....: $avArray - Array to modify
;                  $iStart  - [optional] Index of array to start modifying at
;                  $iEnd    - [optional] Index of array to stop modifying at
; Return values .: Success - 1
;                  Failure - 0, sets @error:
;                  |1 - $avArray is not an array
;                  |2 - $iStart is greater than $iEnd
;                  |3 - $avArray is not a 1 or 2 dimensional array
; Author ........: Brian Keene
; Modified.......: Jos van der Zande <jdeb at autoitscript dot com> -  added $iStart parameter and logic, Tylo - added $iEnd parameter and rewrote it for speed, Ultima - code cleanup, minor optimization
; Modified.......: BrewManNH - Added 2D array support
; Remarks .......:
; Related .......: _ArraySwap
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _ArrayReverse(ByRef $avArray, $iStart = 0, $iEnd = 0)
	If Not IsArray($avArray) Then Return SetError(1, 0, 0)
	If UBound($avArray, 0) > 2 Then Return SetError(3, 0, 0)
	Local $vTmp, $iUBound = UBound($avArray) - 1
	; Bounds checking
	If $iEnd < 1 Or $iEnd > $iUBound Then $iEnd = $iUBound
	If $iStart < 0 Then $iStart = 0
	If $iStart > $iEnd Then Return SetError(2, 0, 0)
	If UBound($avArray, 0) = 1 Then
		; Reverse
		For $i = $iStart To Int(($iStart + $iEnd - 1) / 2)
			$vTmp = $avArray[$i]
			$avArray[$i] = $avArray[$iEnd]
			$avArray[$iEnd] = $vTmp
			$iEnd -= 1
		Next
		Return 1
	Else
		; Reverse
		For $i = $iStart To Int(($iStart + $iEnd - 1) / 2)
			For $j = 0 To UBound($avArray, 2) - 1
				$vTmp = $avArray[$i][$j]
				$avArray[$i][$j] = $avArray[$iEnd][$j]
				$avArray[$iEnd][$j] = $vTmp
			Next
			$iEnd -= 1
		Next
		Return 1
	EndIf
EndFunc   ;==>_ArrayReverse
; #FUNCTION# ====================================================================================================================
; Name...........: _ArraySearch
; Description ...: Finds an entry within a 1D or 2D array. Similar to _ArrayBinarySearch(), except that the array does not need to be sorted.
; Syntax.........: _ArraySearch(Const ByRef $avArray, $vValue[, $iStart = 0[, $iEnd = 0[, $iCase = 0[, $iPartial = 0[, $iForward = 1[, $iSubItem = -1]]]]]])
; Parameters ....: $avArray  - The array to search
;                  $vValue   - What to search $avArray for
;                  $iStart   - [optional] Index of array to start searching at
;                  $iEnd     - [optional] Index of array to stop searching at
;                  $iCase    - [optional] If set to 1, search is case sensitive
;                  $iPartial - [optional] If set to 1, executes a partial search
;                  $iForward - [optional] If set to 0, searches the array from end to beginning (instead of beginning to end)
;                  $iSubItem - [optional] Sub-index to search on in 2D arrays
; Return values .: Success - The index that $vValue was found at
;                  Failure - -1, sets @error:
;                  |1 - $avArray is not an array
;                  |2 - $avArray is not a 1 or 2 dimensional array
;                  |4 - $iStart is greater than $iEnd
;                  |6 - $vValue was not found in array
;                  |7 - $avArray has too many dimensions
;                  |(3, 5 - Deprecated error codes)
; Author ........: SolidSnake <MetalGX91 at GMail dot com>
; Modified.......: gcriaco <gcriaco at gmail dot com>, Ultima - 2D arrays supported, directional search, code cleanup, optimization
; Remarks .......: This function might be slower than _ArrayBinarySearch() but is useful when the array's order can't be altered.
; Related .......: _ArrayBinarySearch, _ArrayFindAll
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _ArraySearch(Const ByRef $avArray, $vValue, $iStart = 0, $iEnd = 0, $iCase = 0, $iPartial = 0, $iForward = 1, $iSubItem = -1)
	If Not IsArray($avArray) Then Return SetError(1, 0, -1)
	If UBound($avArray, 0) > 2 Or UBound($avArray, 0) < 1 Then Return SetError(2, 0, -1)
	Local $iUBound = UBound($avArray) - 1
	; Bounds checking
	If $iEnd < 1 Or $iEnd > $iUBound Then $iEnd = $iUBound
	If $iStart < 0 Then $iStart = 0
	If $iStart > $iEnd Then Return SetError(4, 0, -1)
	; Direction (flip if $iForward = 0)
	Local $iStep = 1
	If Not $iForward Then
		Local $iTmp = $iStart
		$iStart = $iEnd
		$iEnd = $iTmp
		$iStep = -1
	EndIf
	; Search
	Switch UBound($avArray, 0)
		Case 1 ; 1D array search
			If Not $iPartial Then
				If Not $iCase Then
					For $i = $iStart To $iEnd Step $iStep
						If $avArray[$i] = $vValue Then Return $i
					Next
				Else
					For $i = $iStart To $iEnd Step $iStep
						If $avArray[$i] == $vValue Then Return $i
					Next
				EndIf
			Else
				For $i = $iStart To $iEnd Step $iStep
					If StringInStr($avArray[$i], $vValue, $iCase) > 0 Then Return $i
				Next
			EndIf
		Case 2 ; 2D array search
			Local $iUBoundSub = UBound($avArray, 2) - 1
			If $iSubItem > $iUBoundSub Then $iSubItem = $iUBoundSub
			If $iSubItem < 0 Then
				; will search for all Col
				$iSubItem = 0
			Else
				$iUBoundSub = $iSubItem
			EndIf
			For $j = $iSubItem To $iUBoundSub
				If Not $iPartial Then
					If Not $iCase Then
						For $i = $iStart To $iEnd Step $iStep
							If $avArray[$i][$j] = $vValue Then Return $i
						Next
					Else
						For $i = $iStart To $iEnd Step $iStep
							If $avArray[$i][$j] == $vValue Then Return $i
						Next
					EndIf
				Else
					For $i = $iStart To $iEnd Step $iStep
						If StringInStr($avArray[$i][$j], $vValue, $iCase) > 0 Then Return $i
					Next
				EndIf
			Next
		Case Else
			Return SetError(7, 0, -1)
	EndSwitch
	Return SetError(6, 0, -1)
EndFunc   ;==>_ArraySearch
; #FUNCTION# ====================================================================================================================
; Name...........: _ArraySort
; Description ...: Sort a 1D or 2D array on a specific index using the quicksort/insertionsort algorithms.
; Syntax.........: _ArraySort(ByRef $avArray[, $iDescending = 0[, $iStart = 0[, $iEnd = 0[, $iSubItem = 0]]]])
; Parameters ....: $avArray     - Array to sort
;                  $iDescending - [optional] If set to 1, sort descendingly
;                  $iStart      - [optional] Index of array to start sorting at
;                  $iEnd        - [optional] Index of array to stop sorting at
;                  $iSubItem    - [optional] Sub-index to sort on in 2D arrays
; Return values .: Success - 1
;                  Failure - 0, sets @error:
;                  |1 - $avArray is not an array
;                  |2 - $iStart is greater than $iEnd
;                  |3 - $iSubItem is greater than subitem count
;                  |4 - $avArray has too many dimensions
; Author ........: Jos van der Zande <jdeb at autoitscript dot com>
; Modified.......: LazyCoder - added $iSubItem option, Tylo - implemented stable QuickSort algo, Jos van der Zande - changed logic to correctly Sort arrays with mixed Values and Strings, Ultima - major optimization, code cleanup, removed $i_Dim parameter
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _ArraySort(ByRef $avArray, $iDescending = 0, $iStart = 0, $iEnd = 0, $iSubItem = 0)
	If Not IsArray($avArray) Then Return SetError(1, 0, 0)
	Local $iUBound = UBound($avArray) - 1
	; Bounds checking
	If $iEnd < 1 Or $iEnd > $iUBound Then $iEnd = $iUBound
	If $iStart < 0 Then $iStart = 0
	If $iStart > $iEnd Then Return SetError(2, 0, 0)
	; Sort
	Switch UBound($avArray, 0)
		Case 1
			__ArrayQuickSort1D($avArray, $iStart, $iEnd)
			If $iDescending Then _ArrayReverse($avArray, $iStart, $iEnd)
		Case 2
			Local $iSubMax = UBound($avArray, 2) - 1
			If $iSubItem > $iSubMax Then Return SetError(3, 0, 0)
			If $iDescending Then
				$iDescending = -1
			Else
				$iDescending = 1
			EndIf
			__ArrayQuickSort2D($avArray, $iDescending, $iStart, $iEnd, $iSubItem, $iSubMax)
		Case Else
			Return SetError(4, 0, 0)
	EndSwitch
	Return 1
EndFunc   ;==>_ArraySort
; #FUNCTION# ====================================================================================================================
; Name...........: _ArraySwap
; Description ...: Swaps two items.
; Syntax.........: _ArraySwap(ByRef $vItem1, ByRef $vItem2)
; Parameters ....: $vItem1 - First item to swap
;                  $vItem2 - Second item to swap
; Return values .: None.
; Author ........: David Nuttall <danuttall at rocketmail dot com>
; Modified.......: Ultima - minor optimization
; Remarks .......: This function swaps the two items in place, since they're passed by reference. Regular, non-array variables can also be swapped by this function.
; Related .......: _ArrayReverse
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _ArraySwap(ByRef $vItem1, ByRef $vItem2)
	Local $vTmp = $vItem1
	$vItem1 = $vItem2
	$vItem2 = $vTmp
EndFunc   ;==>_ArraySwap
; #FUNCTION# ====================================================================================================================
; Name...........: _ArrayToClip
; Description ...: Sends the contents of an array to the clipboard, each element delimited by a carriage return.
; Syntax.........: _ArrayToClip(Const ByRef $avArray[, $iStart = 0[, $iEnd = 0[, $iSubItem = 0]]])
; Parameters ....: $avArray - Array to copy to clipboard
;                  $iStart  - [optional] Index of array to start copying at
;                  $iEnd    - [optional] Index of array to stop copying at
;                  $iSubItem- [optional] Dimension of array to copy
; Return values .: Success - 1
;                  Failure - 0, sets @error:
;                  |-1 - ClipPut() failed
;                  |Other - See _ArrayToString() description for error codes
; Author ........: Cephas <cephas at clergy dot net>
; Modified.......: Jos van der Zande <jdeb at autoitscript dot com> - added $iStart parameter and logic, Ultima - added $iEnd parameter, make use of _ArrayToString() instead of duplicating efforts
; Remarks .......:
; Related .......: _ArrayToString
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _ArrayToClip(Const ByRef $avArray, $iStart = 0, $iEnd = 0, $iSubItem = 0)
	Local $sResult
	If UBound($avArray, 0) = 1 Then
		$sResult= _ArrayToString($avArray, @CR, $iStart, $iEnd)
		If @error Then Return SetError(@error, 0, 0)
		Return ClipPut($sResult)
	Else
		If $iSubItem > UBound($avArray, 2) - 1 Then $iSubItem = UBound($avArray, 2) - 1
		If $iSubItem < 1 Then $iSubItem = 0
		$sResult = _ArrayToString($avArray, @CR, $iStart, $iEnd, $iSubItem)
		If @error Then Return SetError(@error, 0, 0)
		Return ClipPut($sResult)
	EndIf
EndFunc   ;==>_ArrayToClip
; #FUNCTION# ====================================================================================================================
; Name...........: _ArrayToString
; Description ...: Places the elements of an array into a single string, separated by the specified delimiter.
; Syntax.........: _ArrayToString(Const ByRef $avArray[, $sDelim = "|"[, $iStart = 0[, $iEnd = 0]]])
; Parameters ....: $avArray - Array to combine
;                  $sDelim  - [optional] Delimiter for combined string
;                  $iStart  - [optional] Index of array to start combining at
;                  $iEnd    - [optional] Index of array to stop combining at
;                  $iSubItem- [optional] Subitem to copy
; Return values .: Success - string which combined selected elements separated by the delimiter string.
;                  Failure - "", sets @error:
;                  |1 - $avArray is not an array
;                  |2 - $iStart is greater than $iEnd
;                  |3 - $avArray is not an 1 or 2 dimensional array
; Author ........: Brian Keene <brian_keene at yahoo dot com>, Valik - rewritten
; Modified.......: Ultima - code cleanup
; Modified.......: BrewManNH - Added 2D array support
; Remarks .......:
; Related .......: StringSplit, _ArrayToClip
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _ArrayToString(Const ByRef $avArray, $sDelim = "|", $iStart = 0, $iEnd = 0, $iSubItem = 0)
	If Not IsArray($avArray) Then Return SetError(1, 0, "")
	If UBound($avArray, 0) > 2 Then Return SetError(3, 0, "")
	Local $sResult, $iUBound = UBound($avArray) - 1
	; Bounds checking
	If $iEnd < 1 Or $iEnd > $iUBound Then $iEnd = $iUBound
	If $iStart < 0 Then $iStart = 0
	If $iStart > $iEnd Then Return SetError(2, 0, "")
	If UBound($avArray, 0) = 1 Then
		; Combine
		For $i = $iStart To $iEnd
			$sResult &= $avArray[$i] & $sDelim
		Next
		Return StringTrimRight($sResult, StringLen($sDelim))
	Else
		If $iSubItem > UBound($avArray, 2) - 1 Then $iSubItem = UBound($avArray, 2) - 1
		If $iSubItem < 1 Then $iSubItem = 0
		; Combine
		For $i = $iStart To $iEnd
			$sResult &= $avArray[$i][$iSubItem] & $sDelim
		Next
		Return StringTrimRight($sResult, StringLen($sDelim))
	EndIf
EndFunc   ;==>_ArrayToString
; #FUNCTION# ====================================================================================================================
; Name...........: _ArrayTrim
; Description ...: Trims a certain number of characters from all elements in an array.
; Syntax.........: _ArrayTrim(ByRef $avArray, $iTrimNum[, $iDirection = 0[, $iStart = 0[, $iEnd = 0]]])
; Parameters ....: $avArray    - Array to modify
;                  $iTrimNum   - Number of characters to remove
;                  $iDirection - [optional] Direction to trim:
;                  |0 - trim left
;                  |1 - trim right
;                  $iStart     - [optional] Index of array to start trimming at
;                  $iEnd       - [optional] Index of array to stop trimming at
; Return values .: Success - 1
;                  Failure - 0, sets @error:
;                  |1 - $avArray is not an array
;                  |2 - $avArray is not an 1 or 2 dimensional array
;                  |5 - $iStart is greater than $iEnd
;                  |(3-4 - Deprecated error codes)
; Author ........: Adam Moore (redndahead)
; Modified.......: Ultima - code cleanup, optimization
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _ArrayTrim(ByRef $avArray, $iTrimNum, $iDirection = 0, $iStart = 0, $iEnd = 0)
	If Not IsArray($avArray) Then Return SetError(1, 0, 0)
	If UBound($avArray, 0) > 2 Then Return SetError(2, 0, 0)
	Local $iUBound = UBound($avArray) - 1
	; Bounds checking
	If $iEnd < 1 Or $iEnd > $iUBound Then $iEnd = $iUBound
	If $iStart < 0 Then $iStart = 0
	If $iStart > $iEnd Then Return SetError(5, 0, 0)
	If UBound($avArray, 0) = 1 Then
		; Trim
		If $iDirection Then
			For $i = $iStart To $iEnd
				$avArray[$i] = StringTrimRight($avArray[$i], $iTrimNum)
			Next
		Else
			For $i = $iStart To $iEnd
				$avArray[$i] = StringTrimLeft($avArray[$i], $iTrimNum)
			Next
		EndIf
		Return 1
	Else
		; Trim
		If $iDirection Then
			For $i = $iStart To $iEnd
				For $j = 0 To UBound($avArray, 2) - 1
					$avArray[$i][$j] = StringTrimRight($avArray[$i][$j], $iTrimNum)
				Next
			Next
		Else
			For $i = $iStart To $iEnd
				For $j = 0 To UBound($avArray, 2) - 1
					$avArray[$i][$j] = StringTrimLeft($avArray[$i][$j], $iTrimNum)
				Next
			Next
		EndIf
		Return 1
	EndIf
EndFunc   ;==>_ArrayTrim
; #FUNCTION# ====================================================================================================================
; Name...........: _ArrayUnique
; Description ...: Returns the Elements of a 1 or 2-dimensional array deleting all duplicate items
; Syntax.........: _ArrayUnique($aArray[, $iDimension = 1[, $iBase = 0[, $iCase = 0[, $vDelim = "|"]]]])
; Parameters ....: $aArray - The Array to use
;                  $iDimension  - [optional] The Dimension of the Array to use
;                  $iBase  - [optional] Is the Array 0-base or 1-base index.  0-base by default
;                  $iCase  - [optional] Flag to indicate if the operations should be case sensitive.
;                  0 = not case sensitive, using the user's locale (default)
;                  1 = case sensitive
;                  2 = not case sensitive, using a basic/faster comparison
;                  $vDelim  - [optional] One or more characters to use as delimiters.  However, cannot forsee its usefullness
; Return values .: Success - Returns a 1-dimensional array containing only the unique elements of that Dimension
;                  Failure - Returns 0 and Sets @Error:
;                  0 - No error.
;                  1 - Returns 0 if parameter is not an array.
;                  2 - _ArrayUnique failed for some other reason
;                  3 - Array dimension is invalid, should be an integer greater than 0
; Author ........: SmOke_N
; Modified.......: litlmike
; Remarks .......: Returns an array, the first element ($array[0]) contains the number of strings returned, the remaining elements ($array[1], $array[2], etc.) contain the unique strings.
; Related .......: _ArrayMax, _ArrayMin
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func _ArrayUnique($aArray, $iDimension = 1, $iBase = 0, $iCase = 0, $vDelim = "|")
	Local $iUboundDim
	;$aArray used to be ByRef, but litlmike altered it to allow for the choosing of 1 Array Dimension, without altering the original array
	If $vDelim = "|" Then $vDelim = Chr(01) ; by SmOke_N, modified by litlmike
	If Not IsArray($aArray) Then Return SetError(1, 0, 0) ;Check to see if it is valid array
	;Checks that the given Dimension is Valid
	If Not $iDimension > 0 Then
		Return SetError(3, 0, 0) ;Check to see if it is valid array dimension, Should be greater than 0
	Else
		;If Dimension Exists, then get the number of "Rows"
		$iUboundDim = UBound($aArray, 1) ;Get Number of "Rows"
		If @error Then Return SetError(3, 0, 0) ;2 = Array dimension is invalid.
		;If $iDimension Exists, And the number of "Rows" is Valid:
		If $iDimension > 1 Then ;Makes sure the Array dimension desired is more than 1-dimensional
			Local $aArrayTmp[1] ;Declare blank array, which will hold the dimension declared by user
			For $i = 0 To $iUboundDim - 1 ;Loop through "Rows"
				_ArrayAdd($aArrayTmp, $aArray[$i][$iDimension - 1]) ;$iDimension-1 to match Dimension
			Next
			_ArrayDelete($aArrayTmp, 0) ;Get rid of 1st-element which is blank
		Else ;Makes sure the Array dimension desired is 1-dimensional
			;If Dimension Exists, And the number of "Rows" is Valid, and the Dimension desired is not > 1, then:
			;For the Case that the array is 1-Dimensional
			If UBound($aArray, 0) = 1 Then ;Makes sure the Array is only 1-Dimensional
				Dim $aArrayTmp[1] ;Declare blank array, which will hold the dimension declared by user
				For $i = 0 To $iUboundDim - 1
					_ArrayAdd($aArrayTmp, $aArray[$i])
				Next
				_ArrayDelete($aArrayTmp, 0) ;Get rid of 1st-element which is blank
			Else ;For the Case that the array is 2-Dimensional
				Dim $aArrayTmp[1] ;Declare blank array, which will hold the dimension declared by user
				For $i = 0 To $iUboundDim - 1
					_ArrayAdd($aArrayTmp, $aArray[$i][$iDimension - 1]) ;$iDimension-1 to match Dimension
				Next
				_ArrayDelete($aArrayTmp, 0) ;Get rid of 1st-element which is blank
			EndIf
		EndIf
	EndIf
	Local $sHold ;String that holds the Unique array info
	For $iCC = $iBase To UBound($aArrayTmp) - 1 ;Loop Through array
		;If Not the case that the element is already in $sHold, then add it
		If Not StringInStr($vDelim & $sHold, $vDelim & $aArrayTmp[$iCC] & $vDelim, $iCase) Then _
				$sHold &= $aArrayTmp[$iCC] & $vDelim
	Next
	If $sHold Then
		$aArrayTmp = StringSplit(StringTrimRight($sHold, StringLen($vDelim)), $vDelim, 1) ;Split the string into an array
		Return $aArrayTmp ;SmOke_N's version used to Return SetError(0, 0, 0)
	EndIf
	Return SetError(2, 0, 0) ;If the script gets this far, it has failed
EndFunc   ;==>_ArrayUnique
; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name...........: __Array_Combinations
; Description ...: Creates Combination
; Syntax.........: __Array_Combinations($iN, $iR)
; Parameters ....: $iN - Value passed on from UBound($avArray)
;                  $iR - Size of the combinations set
; Return values .: Integer value of the number of combinations
; Author ........: Erik Pilsits
; Modified.......: 07/08/2008
; Remarks .......: This function is used internally. PBased on an algorithm by Kenneth H. Rosen.
;+
;                   http://www.bearcave.com/random_hacks/permute.html
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func __Array_Combinations($iN, $iR)
	Local $i_Total = 1
	For $i = $iR To 1 Step -1
		$i_Total *= ($iN / $i)
		$iN -= 1
	Next
	Return Round($i_Total)
EndFunc   ;==>__Array_Combinations
; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name...........: __Array_ExeterInternal
; Description ...: Permute Function based on an algorithm from Exeter University.
; Syntax.........: __Array_ExeterInternal(ByRef $avArray, $iStart, $iSize, $sDelim, ByRef $aIdx, ByRef $aResult)
; Parameters ....: $avArray - The Array to get Permutations
;                  $iStart - Starting Point for Loop
;                  $iSize - End Point for Loop
;                  $sDelim - String result separator
;                  $aIdx - Array Used in Rotations
;                  $aResult - Resulting Array
; Return values .: Success      - Computer name
; Author ........: Erik Pilsits
; Modified.......: 07/08/2008
; Remarks .......: This function is used internally. Permute Function based on an algorithm from Exeter University.
;+
;                   http://www.bearcave.com/random_hacks/permute.html
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func __Array_ExeterInternal(ByRef $avArray, $iStart, $iSize, $sDelim, ByRef $aIdx, ByRef $aResult, ByRef $iCount)
	If $iStart == $iSize - 1 Then
		For $i = 0 To $iSize - 1
			$aResult[$iCount] &= $avArray[$aIdx[$i]] & $sDelim
		Next
		If $sDelim <> "" Then $aResult[$iCount] = StringTrimRight($aResult[$iCount], 1)
		$iCount += 1
	Else
		Local $iTemp
		For $i = $iStart To $iSize - 1
			$iTemp = $aIdx[$i]
			$aIdx[$i] = $aIdx[$iStart]
			$aIdx[$iStart] = $iTemp
			__Array_ExeterInternal($avArray, $iStart + 1, $iSize, $sDelim, $aIdx, $aResult, $iCount)
			$aIdx[$iStart] = $aIdx[$i]
			$aIdx[$i] = $iTemp
		Next
	EndIf
EndFunc   ;==>__Array_ExeterInternal
; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name...........: __Array_GetNext
; Description ...: Creates Combination
; Syntax.........: __Array_GetNext($iN, $iR, ByRef $iLeft, $iTotal, ByRef $aIdx)
; Parameters ....: $iN - Value passed on from UBound($avArray)
;                  $iR - Size of the combinations set
;                  $iLeft - Remaining number of combinations
;                  $iTotal - Total number of combinations
;                  $aIdx - Array containing combinations
; Return values .: Function only changes values ByRef
; Author ........: Erik Pilsits
; Modified.......: 07/08/2008
; Remarks .......: This function is used internally. PBased on an algorithm by Kenneth H. Rosen.
;+
;                   http://www.bearcave.com/random_hacks/permute.html
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func __Array_GetNext($iN, $iR, ByRef $iLeft, $iTotal, ByRef $aIdx)
	If $iLeft == $iTotal Then
		$iLeft -= 1
		Return
	EndIf
	Local $i = $iR - 1
	While $aIdx[$i] == $iN - $iR + $i
		$i -= 1
	WEnd
	$aIdx[$i] += 1
	For $j = $i + 1 To $iR - 1
		$aIdx[$j] = $aIdx[$i] + $j - $i
	Next
	$iLeft -= 1
EndFunc   ;==>__Array_GetNext
; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name...........: __ArrayQuickSort1D
; Description ...: Helper function for sorting 1D arrays
; Syntax.........: __ArrayQuickSort1D(ByRef $avArray, ByRef $iStart, ByRef $iEnd)
; Parameters ....: $avArray - Array to sort
;                  $iStart  - Index of array to start sorting at
;                  $iEnd    - Index of array to stop sorting at
; Return values .: None
; Author ........: Jos van der Zande, LazyCoder, Tylo, Ultima
; Modified.......:
; Remarks .......: For Internal Use Only
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func __ArrayQuickSort1D(ByRef $avArray, ByRef $iStart, ByRef $iEnd)
	If $iEnd <= $iStart Then Return
	Local $vTmp
	; InsertionSort (faster for smaller segments)
	If ($iEnd - $iStart) < 15 Then
		Local $vCur
		For $i = $iStart + 1 To $iEnd
			$vTmp = $avArray[$i]
			If IsNumber($vTmp) Then
				For $j = $i - 1 To $iStart Step -1
					$vCur = $avArray[$j]
					; If $vTmp >= $vCur Then ExitLoop
					If ($vTmp >= $vCur And IsNumber($vCur)) Or (Not IsNumber($vCur) And StringCompare($vTmp, $vCur) >= 0) Then ExitLoop
					$avArray[$j + 1] = $vCur
				Next
			Else
				For $j = $i - 1 To $iStart Step -1
					If (StringCompare($vTmp, $avArray[$j]) >= 0) Then ExitLoop
					$avArray[$j + 1] = $avArray[$j]
				Next
			EndIf
			$avArray[$j + 1] = $vTmp
		Next
		Return
	EndIf
	; QuickSort
	Local $L = $iStart, $R = $iEnd, $vPivot = $avArray[Int(($iStart + $iEnd) / 2)], $fNum = IsNumber($vPivot)
	Do
		If $fNum Then
			; While $avArray[$L] < $vPivot
			While ($avArray[$L] < $vPivot And IsNumber($avArray[$L])) Or (Not IsNumber($avArray[$L]) And StringCompare($avArray[$L], $vPivot) < 0)
				$L += 1
			WEnd
			; While $avArray[$R] > $vPivot
			While ($avArray[$R] > $vPivot And IsNumber($avArray[$R])) Or (Not IsNumber($avArray[$R]) And StringCompare($avArray[$R], $vPivot) > 0)
				$R -= 1
			WEnd
		Else
			While (StringCompare($avArray[$L], $vPivot) < 0)
				$L += 1
			WEnd
			While (StringCompare($avArray[$R], $vPivot) > 0)
				$R -= 1
			WEnd
		EndIf
		; Swap
		If $L <= $R Then
			$vTmp = $avArray[$L]
			$avArray[$L] = $avArray[$R]
			$avArray[$R] = $vTmp
			$L += 1
			$R -= 1
		EndIf
	Until $L > $R
	__ArrayQuickSort1D($avArray, $iStart, $R)
	__ArrayQuickSort1D($avArray, $L, $iEnd)
EndFunc   ;==>__ArrayQuickSort1D
; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name...........: __ArrayQuickSort2D
; Description ...: Helper function for sorting 2D arrays
; Syntax.........: __ArrayQuickSort2D(ByRef $avArray, ByRef $iStep, ByRef $iStart, ByRef $iEnd, ByRef $iSubItem, ByRef $iSubMax)
; Parameters ....: $avArray  - Array to sort
;                  $iStep    - Step size (should be 1 to sort ascending, -1 to sort descending!)
;                  $iStart   - Index of array to start sorting at
;                  $iEnd     - Index of array to stop sorting at
;                  $iSubItem - Sub-index to sort on in 2D arrays
;                  $iSubMax  - Maximum sub-index that array has
; Return values .: None
; Author ........: Jos van der Zande, LazyCoder, Tylo, Ultima
; Modified.......:
; Remarks .......: For Internal Use Only
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func __ArrayQuickSort2D(ByRef $avArray, ByRef $iStep, ByRef $iStart, ByRef $iEnd, ByRef $iSubItem, ByRef $iSubMax)
	If $iEnd <= $iStart Then Return
	; QuickSort
	Local $vTmp, $L = $iStart, $R = $iEnd, $vPivot = $avArray[Int(($iStart + $iEnd) / 2)][$iSubItem], $fNum = IsNumber($vPivot)
	Do
		If $fNum Then
			; While $avArray[$L][$iSubItem] < $vPivot
			While ($iStep * ($avArray[$L][$iSubItem] - $vPivot) < 0 And IsNumber($avArray[$L][$iSubItem])) Or (Not IsNumber($avArray[$L][$iSubItem]) And $iStep * StringCompare($avArray[$L][$iSubItem], $vPivot) < 0)
				$L += 1
			WEnd
			; While $avArray[$R][$iSubItem] > $vPivot
			While ($iStep * ($avArray[$R][$iSubItem] - $vPivot) > 0 And IsNumber($avArray[$R][$iSubItem])) Or (Not IsNumber($avArray[$R][$iSubItem]) And $iStep * StringCompare($avArray[$R][$iSubItem], $vPivot) > 0)
				$R -= 1
			WEnd
		Else
			While ($iStep * StringCompare($avArray[$L][$iSubItem], $vPivot) < 0)
				$L += 1
			WEnd
			While ($iStep * StringCompare($avArray[$R][$iSubItem], $vPivot) > 0)
				$R -= 1
			WEnd
		EndIf
		; Swap
		If $L <= $R Then
			For $i = 0 To $iSubMax
				$vTmp = $avArray[$L][$i]
				$avArray[$L][$i] = $avArray[$R][$i]
				$avArray[$R][$i] = $vTmp
			Next
			$L += 1
			$R -= 1
		EndIf
	Until $L > $R
	__ArrayQuickSort2D($avArray, $iStep, $iStart, $R, $iSubItem, $iSubMax)
	__ArrayQuickSort2D($avArray, $iStep, $L, $iEnd, $iSubItem, $iSubMax)
EndFunc   ;==>__ArrayQuickSort2D