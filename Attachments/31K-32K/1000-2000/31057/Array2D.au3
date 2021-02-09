#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_AU3Check_Parameters=-w 1 -w 2 -w 3 -w 4 -w 5 -w 6
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#include-Once

;#include <String.au3>

; #INDEX# =======================================================================================================================
; Title .........: Array2D
; AutoIt Version : 3.2.12++
; Language ......: English
; Description ...: This module contains various functions for manipulating arrays with 1 or 2 dimensions.
; ===============================================================================================================================

; #VARIABLES# ===================================================================================================================
Global $ARRAY2D_DELIM_STRING = ""
Global $ARRAY2D_DELIM_FLAG = 0
; ===============================================================================================================================

; #NO_DOC_FUNCTION# =============================================================================================================
;_Array2D_Concatenate
;_Array2D_Create
;_Array2D_Trim
; ===============================================================================================================================

; #CURRENT# =====================================================================================================================
;_Array2D_Add
;_Array2D_BinarySearch
;_Array2D_Clear
;_Array2D_Delete
;_Array2D_Display
;_Array2D_FindAll
;_Array2D_From1D
;_Array2D_FromString
;_Array2D_Insert
;_Array2D_Max
;_Array2D_MaxIndex
;_Array2D_Min
;_Array2D_MinIndex
;_Array2D_StringOperation
;_Array2D_Pop
;_Array2D_Push
;_Array2D_PutValue
;_Array2D_RandomMix
;_Array2D_Reverse
;_Array2D_Search
;_Array2D_SetDelim
;_Array2D_Shift
;_Array2D_Sort
;_Array2D_Swap
;_Array2D_SwapByIndex
;_Array2D_ToClip
;_Array2D_ToConsole
;_Array2D_ToString
;_Array2D_Transpose
; ===============================================================================================================================

; #INTERNAL_USE_ONLY# ===========================================================================================================
;__Array2D_CreateOrder
;__Array2D_GetValue
;__Array2D_PSOOperation
;__Array2D_QuickSort1D
;__Array2D_QuickSort2Ddim1
;__Array2D_QuickSort2Ddim2
;__Min => avoid including Math.au3
;__Max => avoid including Math.au3
; ===============================================================================================================================

; #NEW ERRORS CODES# ============================================================================================================
;	0 = no error
;	1 = $avArray isn't an array
;	2 = $avArray has incorrect number of dimensions
;	3 = "$iDim" parameter isn't equal to 1 or 2
;	4 and more = other errors codes
; ===============================================================================================================================

; #FUNCTION# ====================================================================================================================
; Name...........: _Array2D_Add
; Description ...: Adds a specified value at the end of an existing array.
; Syntax.........: _Array2D_Add(ByRef $avArray, $vValue[, $iDim = 1[, $iSubItem = 0[, $iDoubleRedim = 0]]])
; Parameters ....: $avArray      - Array to modify
;                  $vValue       - Value to add
;                  $iDim         - [optional] Dimension to add to. Default : 1
;                  $iSubItem     - [optional] Index of adding in secondary dimension. Default : 0
;                  $iDoubleRedim - [optional] If set to 1 the secondary dimension can be re-dimensioned. Default : 0
; Return values .: Success - Index of last added item
;                  Failure - -1, sets @error to :
;                  |1 - $avArray is not an array
;                  |2 - $avArray has more than 2 dimensions
;                  |3 - $iDim is not equal to 1 or 2
;                  |4 - $vValue has more dimensions than $avArray
;                  |5 - $iSubItem is too large when $iDoubleRedim is equal to 0
; Author ........: Jos van der Zande <jdeb at autoitscript dot com>
; Modified.......: Ultima - code cleanup
;                  Tolf - Updated 2D, "Default" value supported
; Remarks .......:
; Related .......: _Array2D_Clear, (_Array2D_Concatenate,) _Array2D_Delete, _Array2D_Insert, _Array2D_Pop, _Array2D_PutValue, _Array2D_Push
; Link ..........;
; Example .......; Yes
; ===============================================================================================================================
Func _Array2D_Add(ByRef $avArray, $vValue, $iDim = 1, $iSubItem = 0, $iDoubleRedim = 0)
	If $iDim = Default Then $iDim = 1
	If $iSubItem = Default Then $iSubItem = 0
	If $iDoubleRedim = Default Then $iDoubleRedim = 0
	$vValue = __Array2D_GetValue($vValue)

	Local $iUbound, $iSize, $iElement
	Switch UBound($avArray, 0)
		Case 0
			If Not IsArray($vValue) Then
				Dim $avArray [1] = [$vValue]
			ElseIf UBound($vValue, 0) = 1 Or UBound($vValue, 0) = 2 Then
				$avArray = $vValue
			Else
				Return SetError(4, 0, 0)
			EndIf
			Return SetError(0, 0, 1)
		Case 1
			If Not IsArray($vValue) Then
				$iSize = 1
			ElseIf UBound($vValue, 0) = 1 Then
				$iSize = UBound($vValue)
			Else
				Return SetError(4, 0, 0)
			EndIf
			$iElement = UBound($avArray)
			ReDim $avArray [UBound($avArray) + $iSize]
		Case 2
			Local $iUbound2, $iSize2
			If $iDim <> 1 And $iDim <> 2 Then Return SetError(3, 0, 0)
			If (Not IsArray($vValue)) Or UBound($vValue, 0) = 1 Then
				$iSize = 1
			ElseIf UBound($vValue, 0) = 2 Then
				$iSize = UBound($vValue, $iDim)
			Else
				Return SetError(4, 0, 0)
			EndIf
			$iElement = UBound($avArray, $iDim)

			If Not $iDoubleRedim Then
				$iUbound2 = UBound($avArray, Mod($iDim, 2) + 1)
			Else
				If Not IsArray($vValue) Then
					$iSize2 = 0
				ElseIf UBound($vValue, 0) = 1 Then
					$iSize2 = UBound($vValue)
				Else
					$iSize2 = UBound($vValue, Mod($iDim, 2) + 1)
				EndIf
				$iUbound2 = __Max(UBound($avArray, Mod($iDim, 2) + 1), $iSubItem + $iSize2)
			EndIf
			$iUbound = UBound($avArray, $iDim) + $iSize

			If $iDim = 1 Then
				ReDim $avArray [$iUbound][$iUbound2]
			Else
				ReDim $avArray [$iUbound2][$iUbound]
			EndIf
		Case Else
			Return SetError(2, 0, 0)
	EndSwitch

	If UBound($avArray, 0) = 2 And $iDim = 2 And IsArray($vValue) Then _Array2D_Swap($iElement, $iSubItem)
	_Array2D_PutValue($avArray, $vValue, $iElement, $iDim, $iSubItem)

	Return SetError(0, 0, 1)
EndFunc   ;==>_Array2D_Add

; #FUNCTION# ====================================================================================================================
; Name...........: _Array2D_BinarySearch
; Description ...: Uses the binary search algorithm to search through an array.
; Syntax.........: _Array2D_BinarySearch(Const ByRef $avArray, $vValue[, $iStart = 0[, $iEnd = -1[, $iDim = 1[, $iSubItem = 0]]]])
; Parameters ....: $avArray  - Array to search
;                  $vValue   - Value to find
;                  $iStart   - [optional] Index of array to start searching at. Default : 0
;                  $iEnd     - [optional] Index of array to stop searching at. Default : end of the array
;                  $iDim     - [optional] Dimension to search to. Default : 1
;                  $iSubItem - [optional] Index of array to search at in secondary dimension. Default : 0
; Return values .: Success - Index that value was found at
;                  Failure - -1, sets @error to:
;                  |1 - $avArray is not an array
;                  |2 - $avArray has more than 2 dimensions
;                  |3 - $iDim is not equal to 1 or 2
;                  |4 - $iStart is greater than $iEnd
;                  |5 - $vValue outside of array's min/max values
;                  |6 - $vValue was not found in array
;                  |7 - $iSubItem is too large or negative
; Author ........: Jos van der Zande <jdeb at autoitscript dot com>
; Modified.......: Ultima - added $iEnd as parameter, code cleanup
;                  Tolf - Updated 2D, "Default" value supported
; Remarks .......: WARNING : Errors codes have been changed :
;                  |2 => 5
;                  |3 => 6
;                  |2 added
;                  |3 added
;                  |7 added
;                  When performing a binary search on an array of items, the contents MUST be sorted before the search is done.
;                  Otherwise undefined results will be returned.
; Related .......: _Array2D_FindAll, _Array2D_Search
; Link ..........;
; Example .......; Yes
; ===============================================================================================================================
Func _Array2D_BinarySearch(Const ByRef $avArray, $vValue, $iStart = 0, $iEnd = -1, $iDim = 1, $iSubItem = 0)
	If $iStart = Default Then $iStart = 0
	If $iEnd = Default Then $iEnd = -1
	If $iDim = Default Then $iDim = 1
	If $iSubItem = Default Then $iSubItem = 0

	If Not IsArray($avArray) Then Return SetError(1, 0, -1)
	If UBound($avArray, 0) <> 1 And UBound($avArray, 0) <> 2 Then Return SetError(2, 0, -1)

	If UBound($avArray, 0) = 1 Then $iDim = 1
	If $iDim <> 1 And $iDim <> 2 Then Return SetError(3, 0, -1)
	Local $iUbound = UBound($avArray, $iDim) - 1
	; Bounds checking
	If $iEnd < 0 Or $iEnd > $iUbound Then $iEnd = $iUbound
	If $iStart < 0 Then $iStart = 0
	If $iStart > $iEnd Then Return SetError(4, 0, -1)

	Local $iMid = Int(($iEnd + $iStart) / 2)

	Select
		Case UBound($avArray, 0) = 1
			If $avArray[$iStart] > $vValue Or $avArray[$iEnd] < $vValue Then Return SetError(5, 0, -1)
			; Search
			While $iStart <= $iMid And $vValue <> $avArray[$iMid]
				If $vValue < $avArray[$iMid] Then
					$iEnd = $iMid - 1
				Else
					$iStart = $iMid + 1
				EndIf
				$iMid = Int(($iEnd + $iStart) / 2)
			WEnd
		Case UBound($avArray, 0) = 2 And $iDim = 1
			If $iSubItem < 0 Or $iSubItem > UBound($avArray, 2) - 1 Then SetError(7, 0, -1)
			If $avArray[$iStart][$iSubItem] > $vValue Or $avArray[$iEnd][$iSubItem] < $vValue Then Return SetError(5, 0, -1)
			; Search
			While $iStart <= $iMid And $vValue <> $avArray[$iMid][$iSubItem]
				If $vValue < $avArray[$iMid][$iSubItem] Then
					$iEnd = $iMid - 1
				Else
					$iStart = $iMid + 1
				EndIf
				$iMid = Int(($iEnd + $iStart) / 2)
			WEnd
		Case UBound($avArray, 0) = 2 And $iDim = 2
			If $iSubItem < 0 Or $iSubItem > UBound($avArray) - 1 Then SetError(7, 0, -1)
			If $avArray[$iSubItem][$iStart] > $vValue Or $avArray[$iSubItem][$iEnd] < $vValue Then Return SetError(5, 0, -1)
			; Search
			While $iStart <= $iMid And $vValue <> $avArray[$iSubItem][$iMid]
				If $vValue < $avArray[$iSubItem][$iMid] Then
					$iEnd = $iMid - 1
				Else
					$iStart = $iMid + 1
				EndIf
				$iMid = Int(($iEnd + $iStart) / 2)
			WEnd
	EndSelect
	If $iStart > $iEnd Then Return SetError(6, 0, -1) ; Entry not found

	Return SetError(0, 0, $iMid)
EndFunc   ;==>_Array2D_BinarySearch

; #FUNCTION# ====================================================================================================================
; Name...........: _Array2D_Clear
; Description ...: Clear one or more raws in a 2D-array.
; Syntax.........: _Array2D_Clear(ByRef $avArray[, $iStart = 0[, $iEnd = -1[, $iDim = 1]]])
; Parameters ....: $avArray - Array to modify.
;                  $iStart  - [optional] Index of array to start clearing at. Default : 0
;                  $iEnd    - [optional] Index of array to stop clearing at. Default : end of array
;                  $iDim    - [optional] Dimension to clear to. Default : 1
; Return values .: Success - 1
;                  Failure - 0, sets @error to :
;                  |1 - $avArray is not an array
;                  |2 - $avArray has not 2 dimensions
;                  |3 - $iDim is not equal to 1 or 2
;                  |4 - $iStart > $iEnd
; Author ........: Tolf
; Modified.......:
; Remarks .......: Used in _Array2D_Insert, _Array2D_Push
; Related .......: _Array2D_Add, _Array2D_Delete, _Array2D_Insert, _Array2D_Push, _Array2D_PutValue, _Array2D_Shift
; Link ..........;
; Example .......; Yes
; ===============================================================================================================================
Func _Array2D_Clear(ByRef $avArray, $iStart = 0, $iEnd = -1, $iDim = 1)
	If $iStart = Default Then $iStart = 0
	If $iEnd = Default Then $iEnd = -1
	If $iDim = Default Then $iDim = 1

	If Not IsArray($avArray) Then Return SetError(1, 0, 0)
	If Not UBound($avArray, 0) = 2 Then Return SetError(2, 0, 0)

	Local $iUbound = UBound($avArray, $iDim) - 1
	If $iEnd < 0 Or $iEnd > $iUbound Then $iEnd = $iUbound
	If $iStart < 0 Then $iStart = 0
	If $iStart > $iEnd Then Return SetError(4, 0, 0)

	Local $i, $j
	Switch $iDim
		Case 1
			For $i = $iStart To $iEnd
				For $j = 0 To UBound($avArray, 2) - 1
					$avArray [$i][$j] = ""
				Next
			Next
		Case 2
			For $i = $iStart To $iEnd
				For $j = 0 To UBound($avArray) - 1
					$avArray [$j][$i] = ""
				Next
			Next
		Case Else
			Return SetError(3, 0, 0)
	EndSwitch

	Return SetError(0, 0, 1)
EndFunc   ;==>_Array2D_Clear

; #NO_DOC_FUNCTION# =============================================================================================================
; Name...........: _Array2D_Concatenate
; Description ...: Concatenate two arrays.
; Syntax.........: _Array2D_Concatenate(ByRef $avArrayTarget, Const ByRef $avArraySource)
; Parameters ....: $avArrayTarget - The array to concatenate onto
;                  $avArraySource - The array to concatenate from
; Return values .: Success - $avArrayTarget's new size
;                  Failure - 0, sets @error to:
;                  |1 - $avArrayTarget is not an array
;                  |2 - $avArraySource is not an array
; Author ........: Ultima
; Modified.......:
; Remarks .......: Use _Array2D_Add instead of _Array2D_Concatenate
; Related .......: _Array2D_Add, _Array2D_Push
; Link ..........;
; Example .......; Yes
; ===============================================================================================================================
Func _Array2D_Concatenate(ByRef $avArrayTarget, Const ByRef $avArraySource)
	If Not IsArray($avArrayTarget) Then Return SetError(1, 0, 0)
	If Not IsArray($avArraySource) Then Return SetError(2, 0, 0)

	Local $iUBoundTarget = UBound($avArrayTarget), $iUBoundSource = UBound($avArraySource)
	ReDim $avArrayTarget[$iUBoundTarget + $iUBoundSource]
	For $i = 0 To $iUBoundSource - 1
		$avArrayTarget[$iUBoundTarget + $i] = $avArraySource[$i]
	Next

	Return SetError(0, 0, $iUBoundTarget + $iUBoundSource)
EndFunc   ;==>_Array2D_Concatenate

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
; Link ..........;
; Example .......; Yes
; ===============================================================================================================================
Func _Array2D_Create($v_0, $v_1 = 0, $v_2 = 0, $v_3 = 0, $v_4 = 0, $v_5 = 0, $v_6 = 0, $v_7 = 0, $v_8 = 0, $v_9 = 0, $v_10 = 0, $v_11 = 0, $v_12 = 0, $v_13 = 0, $v_14 = 0, $v_15 = 0, $v_16 = 0, $v_17 = 0, $v_18 = 0, $v_19 = 0, $v_20 = 0)
	Local $av_Array[21] = [$v_0, $v_1, $v_2, $v_3, $v_4, $v_5, $v_6, $v_7, $v_8, $v_9, $v_10, $v_11, $v_12, $v_13, $v_14, $v_15, $v_16, $v_17, $v_18, $v_19, $v_20]
	ReDim $av_Array[@NumParams]
	Return $av_Array
EndFunc   ;==>_Array2D_Create

; #FUNCTION# ====================================================================================================================
; Name...........: _Array2D_Delete
; Description ...: Deletes the specified element from the given array.
; Syntax.........: _Array2D_Delete(ByRef $avArray, $iElement[, $iDim = 1])
; Parameters ....: $avArray  - Array to modify
;                  $iElement - Element to delete
;                  $iDim     - [optional] Dimension to delete to. Default : 1
; Return values .: Success - New size of the array
;                  Failure - 0, sets @error to:
;                  |1 - $avArray is not an array
;                  |2 - $avArray has more than 2 dimensions
;                  |3 - $iDim is not equal to 1 or 2
;                  |4 - $iElement is too large or negative
; Author ........: Cephas <cephas at clergy dot net>
; Modified.......: Jos van der Zande <jdeb at autoitscript dot com> - array passed ByRef
;                  Ultima - 2D arrays supported, reworked function (no longer needs temporary array; faster when deleting from end)
;                  Tolf - choice of the dimension for 2D arrays added, "Default" value supported
; Remarks .......: WARNING : Errors codes have been changed :
;                  |3 => 2
;                  |3 added
;                  |4 added
;                  If the array has one element left (or one row for 2D arrays), it will be set to "" after _Array2D_Delete() is used on it.
; Related .......: _Array2D_Add, _Array2D_Clear, _Array2D_Insert, _Array2D_Pop, _Array2D_Push, _Array2D_Shift
; Link ..........;
; Example .......; Yes
; ===============================================================================================================================
Func _Array2D_Delete(ByRef $avArray, $iElement, $iDim = 1)
	If $iDim = Default Then $iDim = 1

	If Not IsArray($avArray) Then Return SetError(1, 0, 0)
	; Checking errors
	If UBound($avArray, 0) > 2 Then Return SetError(2, 0, 0)
	If UBound($avArray, 0) = 1 Then $iDim = 1
	If $iDim <> 1 And $iDim <> 2 Then Return SetError(3, 0, 0)
	Local $iUbound = UBound($avArray, $iDim) - 1

	If Not $iUbound Then
		$avArray = ""
		Return SetError(0, 0, 0)
	EndIf
	; Bounds checking
	If $iElement < 0 Or $iElement > $iUbound Then Return SetError(4, 0, 0)
	; Move items after $iElement up by 1
	_Array2D_Shift($avArray, 0, $iElement, -1, $iDim)
	; ReDim
	Select
		Case UBound($avArray, 0) = 1
			ReDim $avArray[$iUbound]
		Case UBound($avArray, 0) = 2 And $iDim = 1
			ReDim $avArray[$iUbound][UBound($avArray, 2) ]
		Case UBound($avArray, 0) = 2 And $iDim = 2
			ReDim $avArray[UBound($avArray) ][$iUbound]
	EndSelect

	Return SetError(0, 0, $iUbound)
EndFunc   ;==>_Array2D_Delete

; #FUNCTION# ====================================================================================================================
; Name...........: _Array2D_Display
; Description ...: Displays given 1D or 2D array array in a listview.
; Syntax.........: _Array2D_Display(Const ByRef $avArray[, $sTitle = "Array: ListView Display"[, $avCol = ""[, $avLines = ""[, $iItemLimit = -1[, $iTranspose = 0[, $sSeparator = ""[, $sReplace = "|"]]]]]]])
; Parameters ....: $avArray    - Array to display
;                  $sTitle     - [optional] Title to use for window
;                  $avCol      - [optional] 1D-Array containing columns' names
;                  $avLines    - [optional] 1D-Array containing lines' names
;                  $iItemLimit - [optional] Maximum number of listview items (rows) to show
;                  $iTranspose - [optional] If set differently than default, will transpose the array if 2D
;                  $sSeparator - [optional] Change Opt("GUIDataSeparatorChar") on-the-fly
;                  $sReplace   - [optional] String to replace any occurrence of $sSeparator with in each array element
; Return values .: Success - 1
;                  Failure - 0, sets @error:
;                  |1 - $avArray is not an array
;                  |2 - $avArray has too many dimensions (only up to 2D supported)
; Author ........: randallc, Ultima
; Modified.......: Gary Frost (gafrost) / Ultima: modified to be self-contained (no longer depends on "GUIListView.au3")
;                  Tolf - "Default" value supported, @error = 0 when Return = 1
; Remarks .......: WARNING : The new parameters $avCol & $avLines have been placed between $sTitle and $iItemLimit
; Related .......: _Array2D_ToConsole
; Link ..........;
; Example .......; Yes
; ===============================================================================================================================
Func _Array2D_Display(Const ByRef $avArray, $sTitle = "Array: ListView Display", $avCol = "", $avLines = "", $iItemLimit = -1, $iTranspose = 0, $sSeparator = "", $sReplace = "|")
	If $sTitle = Default Then $sTitle = "Array: ListView Display"
	If $avCol = Default Then $avCol = ""
	If $avLines = Default Then $avLines = ""
	If $iItemLimit = Default Then $iItemLimit = -1
	If $iTranspose = Default Then $iTranspose = 0
	If $sSeparator = Default Then $sSeparator = ""
	If $sReplace = Default Then $sReplace = "|"
	$avCol = __Array2D_GetValue($avCol)
	$avLines = __Array2D_GetValue($avLines)

	If Not IsArray($avArray) Then Return SetError(1, 0, 0)

	; Dimension checking
	Local $iDimension = UBound($avArray, 0), $iUbound = UBound($avArray, 1) - 1, $iSubMax = UBound($avArray, 2) - 1
	If $iDimension > 2 Then Return SetError(2, 0, 0)

	; Separator handling
	If $sSeparator = "" Then $sSeparator = Chr(124)

	; Declare variables
	Local $i, $j, $vTmp, $aItem, $avArrayText, $sHeader = "Row", $iBuffer = 64
	Local $iColLimit = 250, $iLVIAddUDFThreshold = 4000, $iWidth = 640, $iHeight = 480
	Local $iOnEventMode = Opt("GUIOnEventMode", 0), $sDataSeparatorChar = Opt("GUIDataSeparatorChar", $sSeparator)
	Local $iUboundColNames, $iUboundLinesNames

	; Swap dimensions if transposing
	If $iSubMax < 0 Then $iSubMax = 0
	If $iTranspose Then
		$vTmp = $iUbound
		$iUbound = $iSubMax
		$iSubMax = $vTmp
	EndIf

	; Set limits for dimensions
	If $iSubMax > $iColLimit Then $iSubMax = $iColLimit
	If $iItemLimit = 1 Then $iItemLimit = $iLVIAddUDFThreshold
	If $iItemLimit < 1 Then $iItemLimit = $iUbound
	If $iUbound > $iItemLimit Then $iUbound = $iItemLimit
	If $iLVIAddUDFThreshold > $iUbound Then $iLVIAddUDFThreshold = $iUbound

	; Lines/col names gestion
	If UBound($avCol, 0) <> 1 Then
		$avCol = ""
		$iUboundColNames = 0
	Else
		$iUboundColNames = UBound($avCol)
	EndIf
	If UBound($avLines, 0) <> 1 Then
		$avLines = ""
		$iUboundLinesNames = 0
	Else
		$iUboundLinesNames = UBound($avLines)
	EndIf

	; Set header up
	For $i = 0 To $iSubMax
		If $i < $iUboundColNames Then
			$sHeader &= $sSeparator & StringReplace($avCol [$i], $sSeparator, $sReplace, 0, 1)
		Else
			$sHeader &= $sSeparator & "Col " & $i
		EndIf
	Next

	; Convert array into text for listview
	Local $avArrayText[$iUbound + 1]
	For $i = 0 To $iUbound
		If $i < $iUboundLinesNames Then
			$avArrayText[$i] = StringReplace($avLines [$i], $sSeparator, $sReplace, 0, 1)
		Else
			$avArrayText[$i] = "[" & $i & "]"
		EndIf
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
	Local Const $_ARRAYCONSTANT_LVM_INSERTITEMA = (0x1000 + 7)
	Local Const $_ARRAYCONSTANT_LVM_SETEXTENDEDLISTVIEWSTYLE = (0x1000 + 54)
	Local Const $_ARRAYCONSTANT_LVM_SETITEMA = (0x1000 + 6)
	Local Const $_ARRAYCONSTANT_LVS_EX_FULLROWSELECT = 0x20
	Local Const $_ARRAYCONSTANT_LVS_EX_GRIDLINES = 0x1
	Local Const $_ARRAYCONSTANT_LVS_SHOWSELALWAYS = 0x8
	Local Const $_ARRAYCONSTANT_WS_EX_CLIENTEDGE = 0x0200
	Local Const $_ARRAYCONSTANT_WS_MAXIMIZEBOX = 0x00010000
	Local Const $_ARRAYCONSTANT_WS_MINIMIZEBOX = 0x00020000
	Local Const $_ARRAYCONSTANT_WS_SIZEBOX = 0x00040000
	Local Const $_ARRAYCONSTANT_tagLVITEM = "int Mask;int Item;int SubItem;int State;int StateMask;ptr Text;int TextMax;int Image;int Param;int Indent;int GroupID;int Columns;ptr pColumns"

	Local $iAddMask = BitOR($_ARRAYCONSTANT_LVIF_TEXT, $_ARRAYCONSTANT_LVIF_PARAM)
	Local $tBuffer = DllStructCreate("char Text[" & $iBuffer & "]"), $pBuffer = DllStructGetPtr($tBuffer)
	Local $tItem = DllStructCreate($_ARRAYCONSTANT_tagLVITEM), $pItem = DllStructGetPtr($tItem)
	DllStructSetData($tItem, "Param", 0)
	DllStructSetData($tItem, "Text", $pBuffer)
	DllStructSetData($tItem, "TextMax", $iBuffer)

	; Set interface up
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
	For $i = 0 To $iLVIAddUDFThreshold
		GUICtrlCreateListViewItem($avArrayText[$i], $hListView)
	Next
	For $i = ($iLVIAddUDFThreshold + 1) To $iUbound
		$aItem = StringSplit($avArrayText[$i], $sSeparator)
		DllStructSetData($tBuffer, "Text", $aItem[1])

		; Add listview item
		DllStructSetData($tItem, "Item", $i)
		DllStructSetData($tItem, "SubItem", 0)
		DllStructSetData($tItem, "Mask", $iAddMask)
		GUICtrlSendMsg($hListView, $_ARRAYCONSTANT_LVM_INSERTITEMA, 0, $pItem)

		; Set listview subitem text
		DllStructSetData($tItem, "Mask", $_ARRAYCONSTANT_LVIF_TEXT)
		For $j = 2 To $aItem[0]
			DllStructSetData($tBuffer, "Text", $aItem[$j])
			DllStructSetData($tItem, "SubItem", $j - 1)
			GUICtrlSendMsg($hListView, $_ARRAYCONSTANT_LVM_SETITEMA, 0, $pItem)
		Next
	Next

	; ajust window width
	$iWidth = 0
	For $i = 0 To $iSubMax + 1
		$iWidth += GUICtrlSendMsg($hListView, $_ARRAYCONSTANT_LVM_GETCOLUMNWIDTH, $i, 0)
	Next
	If $iWidth < 250 Then $iWidth = 230
	WinMove($hGUI, "", Default, Default, $iWidth + 20)

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

	Return SetError(0, 0, 1)
EndFunc   ;==>_Array2D_Display

; #FUNCTION# ====================================================================================================================
; Name...........: _Array2D_FindAll
; Description ...: Find the indices of all ocurrences of a search query between two points in a 1D or 2D array using _ArraySearch().
; Syntax.........: _Array2D_FindAll(Const ByRef $avArray, $vValue[, $iStart = 0[, $iEnd = -1[, $iCase = 0[, $iPartial = 0[, $iSubItem = 0[, $iDim = 1]]]]]])
; Parameters ....: $avArray  - The array to search
;                  $vValue   - What to search $avArray for
;                  $iStart   - [optional] Index of array to start searching at. Default : 0
;                  $iEnd     - [optional] Index of array to stop searching at. Default : end of the array
;                  $iCase    - [optional] If set to 1, search is case sensitive. Default : 0
;                  $iPartial - [optional] If set to 1, executes a partial search. Default : 0
;                  $iSubItem - [optional] Sub-index to search on in 2D arrays. Default : 0
;                  $iDim     - [optional] Dimension to search to. Default : 1
; Return values .: Success - An array of all index numbers in array containing $vValue
;                  Failure - -1, sets @error (see _ArraySearch() description for error codes)
; Author ........: GEOSoft, Ultima
; Modified.......: Tolf - dimension choice added, error codes changed, "Default" value supported
; Remarks .......: WARNING : Errors codes have been changed :
;                  |7 => 2
;                  |3 added (replace a deprecated error code)
; Related .......: _Array2D_BinarySearch, _Array2D_Search
; Link ..........;
; Example .......; Yes
; ===============================================================================================================================
Func _Array2D_FindAll(Const ByRef $avArray, $vValue, $iStart = 0, $iEnd = -1, $iCase = 0, $iPartial = 0, $iSubItem = 0, $iDim = 1)
	$iStart = _Array2D_Search($avArray, $vValue, $iStart, $iEnd, $iCase, $iPartial, 1, $iSubItem, $iDim)
	If @error Then Return SetError(@error, 0, -1)

	Local $iIndex = 0, $avResult[UBound($avArray) ]
	Do
		$avResult[$iIndex] = $iStart
		$iIndex += 1
		$iStart = _Array2D_Search($avArray, $vValue, $iStart + 1, $iEnd, $iCase, $iPartial, 1, $iSubItem, $iDim)
	Until @error

	ReDim $avResult[$iIndex]
	Return SetError(0, 0, $avResult)
EndFunc   ;==>_Array2D_FindAll

; #FUNCTION# ====================================================================================================================
; Name...........: _Array2D_From1D
; Description ...: Changes a 1-dimensional array into a 2-dimensional array.
; Syntax.........: _Array2D_From1D(ByRef $avArray[, $iTranspose = 0])
; Parameters ....: $avArray    - The array to modify
;                  $iTranspose - [optional] If set to 1, transpose the array into dimension 2. Default : 0
; Return values .: Success - 1
;                  Failure - 0, sets @error to
;                  |1 - $avArray is not an array
;                  |2 - $avArray has not 1 dimension
;                  |3 - $iTranspose is not equal to 0 or 1
; Author ........: Tolf
; Modified.......:
; Remarks .......:
; Related .......: _Array2D_Transpose
; Link ..........;
; Example .......; Yes
; ===============================================================================================================================
Func _Array2D_From1D(ByRef $avArray, $iTranspose = 0)
	If $iTranspose = Default Then $iTranspose = 0

	If Not IsArray($avArray) Then Return SetError(1, 0, 0)
	If Not UBound($avArray, 0) = 1 Then Return SetError(2, 0, 0)

	Local $i
	Switch $iTranspose
		Case 0
			Local $avTransposed [UBound($avArray) ][1]
			For $i = 1 To UBound($avArray)
				$avTransposed [$i - 1][0] = $avArray [$i - 1]
			Next
		Case 1
			Local $avTransposed [1][UBound($avArray) ]
			For $i = 1 To UBound($avArray)
				$avTransposed [0][$i - 1] = $avArray [$i - 1]
			Next
		Case Else
			Return SetError(3, 0, 0)
	EndSwitch
	$avArray = $avTransposed

	Return SetError(0, 0, 1)
EndFunc   ;==>_Array2D_From1D

; #FUNCTION# ====================================================================================================================
; Name...........: _Array2D_FromString
; Description ...: Changes a string into an array which have 2 dimensions.
; Syntax.........: _Array2D_FromString($svString[, $sDelimMainDim = ""[, $sSubDelim = ""[, $iDim = 1]]])
; Parameters ....: $svString      - The string to transform into array
;                  $sDelimMainDim - [optional] The delimiters of main dimension. Default : ""
;                  $sSubDelim     - [optional] The delimiters of secondary dimension. Default : ""
;                  $iDim          - [optional] The main dimension. Default : 1
; Return values .: Success - the array which correspond to the string
;                  Failure - 0, sets @error to
;                  |1 - $s_string is an array
;                  |2 - $s_string does not contain the main delimiters
;                  |3 - $iDim is not equal to 0 or 1
; Author ........: Tolf
; Modified.......:
; Remarks .......:
; Related .......: StringSplit, _Array2D_ToString, StringSplit
; Link ..........;
; Example .......; Yes
; ===============================================================================================================================
Func _Array2D_FromString($svString, $sDelimMainDim = "", $sSubDelim = "", $iDim = 1)
	If $sDelimMainDim = Default Then $sDelimMainDim = ""
	If $sSubDelim = Default Then $sSubDelim = ""
	If $iDim = Default Then $iDim = 1

	If IsArray($svString) Then Return SetError(1, 0, 0)
	If Not ($iDim = 1 Or $iDim = 2) Then Return SetError(3, 0, 0)

	Local $avTemp = StringSplit ($svString, $sDelimMainDim, 1), $avReturn = "", $avTemp2, $i
	If @error = 1 Then Return SetError(2, 0, 0)

	For $i = 1 To UBound($avTemp)
		$avTemp2 = StringSplit ($avTemp [$i - 1], $sSubDelim, 1)
		If $iDim = 1 Then
			_Array2D_From1D($avTemp2, 1)
		Else
			_Array2D_From1D($avTemp2)
		EndIf
		_Array2D_Add($avReturn, $avTemp2, $iDim, 0, 1)
	Next

	Return SetError(0, 0, $avReturn)
EndFunc   ;==>_Array2D_FromString

; #FUNCTION# ====================================================================================================================
; Name...........: _Array2D_Insert
; Description ...: Add a new value at the specified position.
; Syntax.........: _Array2D_Insert(ByRef $avArray, $iElement[, $vValue = ""[, $iDim = 1[, $iSubItem = 0[, $iDoubleRedim = 0]]]])
; Parameters ....: $avArray      - Array to modify
;                  $iElement     - Position to insert item at
;                  $vValue       - [optional] Value of item to insert. Default : ""
;                  $iDim         - [optional] Dimension to insert to. Default : 1
;                  $iSubItem     - [optional] Position to insert item at in secondary dimension. Default : 0
;                  $iDoubleRedim - [optional] If set to 1 the secondary dimension can be re-dimensioned. Default : 0
; Return values .: Success - New size of the array
;                  Failure - 0, sets @error to :
;                  |1 - $avArray is not an array
;                  |2 - $avArray has more than 2 dimensions
;                  |3 - $iDim is not equal to 1 or 2
;                  |4 - $vValue has more dimensions than $avArray
;                  |5 - $iSubItem is too large when $iDoubleRedim is equal to 0
; Author ........: Jos van der Zande <jdeb at autoitscript dot com>
; Modified.......: Ultima - code cleanup
;                  Tolf - Updated 2D, "Default" value supported
; Remarks .......:
; Related .......: _Array2D_Add, _Array2D_Clear, _Array2D_Delete, _Array2D_Pop, _Array2D_Push, _Array2D_PutValue, _Array2D_Shift
; Link ..........;
; Example .......; Yes
; ===============================================================================================================================
Func _Array2D_Insert(ByRef $avArray, $iElement, $vValue = "", $iDim = 1, $iSubItem = 0, $iDoubleRedim = 0)
	If $vValue = Default Then $vValue = ""
	If $iDim = Default Then $iDim = 1
	If $iSubItem = Default Then $iSubItem = 0
	If $iDoubleRedim = Default Then $iDoubleRedim = 0
	$vValue = __Array2D_GetValue($vValue)

	If Not IsArray($avArray) Then Return SetError(1, 0, 0)

	Local $iUbound, $iSize
	Switch UBound($avArray, 0)
		Case 1
			If Not IsArray($vValue) Then
				$iSize = 1
			ElseIf UBound($vValue, 0) = 1 Then
				$iSize = UBound($vValue)
			Else
				Return SetError(4, 0, 0)
			EndIf
			ReDim $avArray [UBound($avArray) + $iSize]
		Case 2
			Local $iUbound2, $iSize2
			If $iDim <> 1 And $iDim <> 2 Then Return SetError(3, 0, 0)
			If (Not IsArray($vValue)) Or UBound($vValue, 0) = 1 Then
				$iSize = 1
			ElseIf UBound($vValue, 0) = 2 Then
				$iSize = UBound($vValue, $iDim)
			Else
				Return SetError(4, 0, 0)
			EndIf

			If Not $iDoubleRedim Then
				$iUbound2 = UBound($avArray, Mod($iDim, 2) + 1)
			Else
				If Not IsArray($vValue) Then
					$iSize2 = 0
				ElseIf UBound($vValue, 0) = 1 Then
					$iSize2 = UBound($vValue)
				Else
					$iSize2 = UBound($vValue, Mod($iDim, 2) + 1)
				EndIf
				$iUbound2 = __Max(UBound($avArray, Mod($iDim, 2) + 1), $iSubItem + $iSize2)
			EndIf
			$iUbound = UBound($avArray, $iDim) + $iSize
			If $iDim = 1 Then
				ReDim $avArray [$iUbound][$iUbound2]
			Else
				ReDim $avArray [$iUbound2][$iUbound]
			EndIf
		Case Else
			Return SetError(2, 0, 0)
	EndSwitch

	_Array2D_Shift($avArray, 1, $iElement, -1, $iDim, $iSize)
	If UBound($avArray, 0) = 2 Then
		_Array2D_Clear($avArray, $iElement, $iElement + $iSize - 1, $iDim)
		If $iDim = 2 Then _Array2D_Swap($iElement, $iSubItem)
	EndIf
	_Array2D_PutValue($avArray, $vValue, $iElement, $iDim, $iSubItem)

	Return SetError(0, 0, 1)
EndFunc   ;==>_Array2D_Insert

; #FUNCTION# ====================================================================================================================
; Name...........: _Array2D_Max
; Description ...: Returns the highest value held in an array.
; Syntax.........: _Array2D_Max(Const ByRef $avArray[, $iCompNumeric = 0[, $iStart = 0[, $iEnd = -1[, $iDim = 1[, $iSubItem = 0]]]]])
; Parameters ....: $avArray      - Array to search
;                  $iCompNumeric - [optional] Comparison method:
;                  |0 - compare alphanumerically (Default)
;                  |1 - compare numerically
;                  $iStart       - [optional] Index of array to start searching at. Default : 0
;                  $iEnd         - [optional] Index of array to stop searching at. Default : end of the array
;                  $iDim         - [optional] Dimension to search at. Default : 1
;                  $iSubItem     - [optional] Index of array to search at in secondary dimension. Default : 0
; Return values .: Success - The maximum value in the array
;                  Failure - "", sets @error (see _ArrayMaxIndex() description for error codes)
; Author ........: Cephas <cephas at clergy dot net>
; Modified.......: Jos van der Zande <jdeb at autoitscript dot com> - Added $iCompNumeric and $iStart parameters and logic
;                  Ultima - added $iEnd parameter, code cleanup
;                  Tolf - Updated 2D, "Default" value supported
; Remarks .......: WARNING : Errors codes have been changed :
;                  |2 => 4
;                  |2 added
;                  |3 added
;                  |5 added
; Related .......: _Array2D_MaxIndex, _Array2D_Min, _Array2D_MinIndex
; Link ..........;
; Example .......; Yes
; ===============================================================================================================================
Func _Array2D_Max(Const ByRef $avArray, $iCompNumeric = 0, $iStart = 0, $iEnd = -1, $iDim = 1, $iSubItem = 0)
	If $iCompNumeric = Default Then $iCompNumeric = 0
	If $iStart = Default Then $iStart = 0
	If $iEnd = Default Then $iEnd = -1
	If $iDim = Default Then $iDim = 1
	If $iSubItem = Default Then $iSubItem = 0

	Local $iResult = _Array2D_MaxIndex($avArray, $iCompNumeric, $iStart, $iEnd, $iDim, $iSubItem)
	If @error Then Return SetError(@error, 0, "")
	Select
		Case UBound($avArray, 0) = 1
			Return SetError(0, 0, $avArray[$iResult])
		Case UBound($avArray, 0) = 2 And $iDim = 1
			Return SetError(0, 0, $avArray[$iResult][$iSubItem])
		Case UBound($avArray, 0) = 2 And $iDim = 2
			Return SetError(0, 0, $avArray[$iSubItem][$iResult])
	EndSelect
EndFunc   ;==>_Array2D_Max

; #FUNCTION# ====================================================================================================================
; Name...........: _Array2D_MaxIndex
; Description ...: Returns the index where the highest value occurs in the array.
; Syntax.........: _Array2D_MaxIndex(Const ByRef $avArray[, $iCompNumeric = 0[, $iStart = 0[, $iEnd = -1[, $iDim = 1[, $iSubItem = 0]]]]])
; Parameters ....: $avArray      - Array to search
;                  $iCompNumeric - [optional] Comparison method:
;                  |0 - compare alphanumerically (Default)
;                  |1 - compare numerically
;                  $iStart       - [optional] Index of array to start searching at. Default : 0
;                  $iEnd         - [optional] Index of array to stop searching at. Default : end of the array
;                  $iDim         - [optional] Dimension to search at. Default : 1
;                  $iSubItem     - [optional] Index of array to search at in secondary dimension. Default : 0
; Return values .: Success - The index of the maximum value in the array
;                  Failure - -1, sets @error to:
;                  |1 - $avArray is not an array
;                  |2 - $avArray has more than 2 dimensions
;                  |3 - $iDim is not equal to 1 or 2
;                  |4 - $iStart is greater than $iEnd
;                  |5 - $iSubItem is too large or negative
; Author ........: Cephas <cephas at clergy dot net>
; Modified.......: Jos van der Zande <jdeb at autoitscript dot com> - Added $iCompNumeric and $iStart parameters and logic
;                  Ultima - added $iEnd parameter, code cleanup, optimization
;                  Tolf - Updated 2D, "Default" value supported
; Remarks .......: WARNING : Errors codes have been changed :
;                  |2 => 4
;                  |2 added
;                  |3 added
;                  |5 added
; Related .......: _Array2D_Max, _Array2D_Min, _Array2D_MinIndex
; Link ..........;
; Example .......; Yes
; ===============================================================================================================================
Func _Array2D_MaxIndex(Const ByRef $avArray, $iCompNumeric = 0, $iStart = 0, $iEnd = -1, $iDim = 1, $iSubItem = 0)
	If $iCompNumeric = Default Then $iCompNumeric = 0
	If $iStart = Default Then $iStart = 0
	If $iEnd = Default Then $iEnd = -1
	If $iDim = Default Then $iDim = 1
	If $iSubItem = Default Then $iSubItem = 0

	If Not IsArray($avArray) Then Return SetError(1, 0, -1)
	If UBound($avArray, 0) <> 1 And UBound($avArray, 0) <> 2 Then Return SetError(2, 0, -1)

	If UBound($avArray, 0) = 1 Then $iDim = 1
	If $iDim <> 1 And $iDim <> 2 Then Return SetError(3, 0, -1)
	Local $iUbound = UBound($avArray, $iDim) - 1
	; Bounds checking
	If $iEnd < 0 Or $iEnd > $iUbound Then $iEnd = $iUbound
	If $iStart < 0 Then $iStart = 0
	If $iStart > $iEnd Then Return SetError(4, 0, -1)

	Local $iMaxIndex = $iStart, $i
	; Search
	Select
		Case UBound($avArray, 0) = 1
			If $iCompNumeric Then
				For $i = $iStart To $iEnd
					If Number($avArray[$iMaxIndex]) < Number($avArray[$i]) Then $iMaxIndex = $i
				Next
			Else
				For $i = $iStart To $iEnd
					If $avArray[$iMaxIndex] < $avArray[$i] Then $iMaxIndex = $i
				Next
			EndIf
		Case UBound($avArray, 0) = 2 And $iDim = 1
			If $iSubItem < 0 Or $iSubItem > UBound($avArray, 2) - 1 Then SetError(5, 0, -1)
			If $iCompNumeric Then
				For $i = $iStart To $iEnd
					If Number($avArray[$iMaxIndex][$iSubItem]) < Number($avArray[$i][$iSubItem]) Then $iMaxIndex = $i
				Next
			Else
				For $i = $iStart To $iEnd
					If $avArray[$iMaxIndex][$iSubItem] < $avArray[$i][$iSubItem] Then $iMaxIndex = $i
				Next
			EndIf
		Case UBound($avArray, 0) = 2 And $iDim = 2
			If $iSubItem < 0 Or $iSubItem > UBound($avArray) - 1 Then SetError(5, 0, -1)
			If $iCompNumeric Then
				For $i = $iStart To $iEnd
					If Number($avArray[$iSubItem][$iMaxIndex]) < Number($avArray[$iSubItem][$i]) Then $iMaxIndex = $i
				Next
			Else
				For $i = $iStart To $iEnd
					If $avArray[$iSubItem][$iMaxIndex] < $avArray[$iSubItem][$i] Then $iMaxIndex = $i
				Next
			EndIf
	EndSelect

	Return SetError(0, 0, $iMaxIndex)
EndFunc   ;==>_Array2D_MaxIndex

; #FUNCTION# ====================================================================================================================
; Name...........: _Array2D_Min
; Description ...: Returns the lowest value held in an array.
; Syntax.........: _Array2D_Min(Const ByRef $avArray[, $iCompNumeric = 0[, $iStart = 0[, $iEnd = -1[, $iDim = 1[, $iSubItem = 0]]]]])
; Parameters ....: $avArray      - Array to search
;                  $iCompNumeric - [optional] Comparison method:
;                  |0 - compare alphanumerically (Default)
;                  |1 - compare numerically
;                  $iStart       - [optional] Index of array to start searching at. Default : 0
;                  $iEnd         - [optional] Index of array to stop searching at. Default : end of the array
;                  $iDim         - [optional] Dimension to search at. Default : 1
;                  $iSubItem     - [optional] Index of array to search at in secondary dimension. Default : 0
; Return values .: Success - The minimum value in the array
;                  Failure - "", sets @error (see _ArrayMinIndex() description for error codes)
; Author ........: Cephas <cephas at clergy dot net>
; Modified.......: Jos van der Zande <jdeb at autoitscript dot com> - Added $iCompNumeric and $iStart parameters and logic
;                  Ultima - added $iEnd parameter, code cleanup
;                  Tolf - Updated 2D, "Default" value supported
; Remarks .......: WARNING : Errors codes have been changed :
;                  |2 => 4
;                  |2 added
;                  |3 added
;                  |5 added
; Related .......: _Array2D_Max, _Array2D_MaxIndex, _Array2D_MinIndex
; Link ..........;
; Example .......; Yes
; ===============================================================================================================================
Func _Array2D_Min(Const ByRef $avArray, $iCompNumeric = 0, $iStart = 0, $iEnd = -1, $iDim = 1, $iSubItem = 0)
	If $iCompNumeric = Default Then $iCompNumeric = 0
	If $iStart = Default Then $iStart = 0
	If $iEnd = Default Then $iEnd = -1
	If $iDim = Default Then $iDim = 1
	If $iSubItem = Default Then $iSubItem = 0

	Local $iResult = _Array2D_MinIndex($avArray, $iCompNumeric, $iStart, $iEnd, $iDim, $iSubItem)
	If @error Then Return SetError(@error, 0, "")
	Select
		Case UBound($avArray, 0) = 1
			Return SetError(0, 0, $avArray[$iResult])
		Case UBound($avArray, 0) = 2 And $iDim = 1
			Return SetError(0, 0, $avArray[$iResult][$iSubItem])
		Case UBound($avArray, 0) = 2 And $iDim = 2
			Return SetError(0, 0, $avArray[$iSubItem][$iResult])
	EndSelect
EndFunc   ;==>_Array2D_Min

; #FUNCTION# ====================================================================================================================
; Name...........: _Array2D_MinIndex
; Description ...: Returns the index where the lowest value occurs in the array.
; Syntax.........: _Array2D_MinIndex(Const ByRef $avArray[, $iCompNumeric = 0[, $iStart = 0[, $iEnd = -1[, $iDim = 1[, $iSubItem = 0]]]]])
; Parameters ....: $avArray      - Array to search
;                  $iCompNumeric - [optional] Comparison method:
;                  |0 - compare alphanumerically (Default)
;                  |1 - compare numerically
;                  $iStart       - [optional] Index of array to start searching at. Default : 0
;                  $iEnd         - [optional] Index of array to stop searching at. Default : end of the array
;                  $iDim         - [optional] Dimension to search at. Default : 1
;                  $iSubItem     - [optional] Index of array to search at in secondary dimension. Default : 0
; Return values .: Success - The index of the minimum value in the array
;                  Failure - -1, sets @error to:
;                  |1 - $avArray is not an array
;                  |2 - $avArray has more than 2 dimensions
;                  |3 - $iDim is not equal to 1 or 2
;                  |4 - $iStart is greater than $iEnd
;                  |5 - $iSubItem is too large or negative
; Author ........: Cephas <cephas at clergy dot net>
; Modified.......: Jos van der Zande <jdeb at autoitscript dot com> - Added $iCompNumeric and $iStart parameters and logic
;                  Ultima - added $iEnd parameter, code cleanup, optimization
;                  Tolf - Updated 2D, "Default" value supported
; Remarks .......: WARNING : Errors codes have been changed :
;                  |2 => 4
;                  |2 added
;                  |3 added
;                  |5 added
; Related .......: _Array2D_Max, _Array2D_MaxIndex, _Array2D_Min
; Link ..........;
; Example .......; Yes
; ===============================================================================================================================
Func _Array2D_MinIndex(Const ByRef $avArray, $iCompNumeric = 0, $iStart = 0, $iEnd = -1, $iDim = 1, $iSubItem = 0)
	If $iCompNumeric = Default Then $iCompNumeric = 0
	If $iStart = Default Then $iStart = 0
	If $iEnd = Default Then $iEnd = -1
	If $iDim = Default Then $iDim = 1
	If $iSubItem = Default Then $iSubItem = 0

	If Not IsArray($avArray) Then Return SetError(1, 0, -1)
	If UBound($avArray, 0) <> 1 And UBound($avArray, 0) <> 2 Then Return SetError(2, 0, -1)

	If UBound($avArray, 0) = 1 Then $iDim = 1
	If $iDim <> 1 And $iDim <> 2 Then Return SetError(3, 0, -1)
	Local $iUbound = UBound($avArray, $iDim) - 1
	; Bounds checking
	If $iEnd < 0 Or $iEnd > $iUbound Then $iEnd = $iUbound
	If $iStart < 0 Then $iStart = 0
	If $iStart > $iEnd Then Return SetError(4, 0, -1)

	Local $iMinIndex = $iStart, $i
	; Search
	Select
		Case UBound($avArray, 0) = 1
			If $iCompNumeric Then
				For $i = $iStart To $iEnd
					If Number($avArray[$iMinIndex]) > Number($avArray[$i]) Then $iMinIndex = $i
				Next
			Else
				For $i = $iStart To $iEnd
					If $avArray[$iMinIndex] > $avArray[$i] Then $iMinIndex = $i
				Next
			EndIf
		Case UBound($avArray, 0) = 2 And $iDim = 1
			If $iSubItem < 0 Or $iSubItem > UBound($avArray, 2) - 1 Then SetError(5, 0, -1)
			If $iCompNumeric Then
				For $i = $iStart To $iEnd
					If Number($avArray[$iMinIndex][$iSubItem]) > Number($avArray[$i][$iSubItem]) Then $iMinIndex = $i
				Next
			Else
				For $i = $iStart To $iEnd
					If $avArray[$iMinIndex][$iSubItem] > $avArray[$i][$iSubItem] Then $iMinIndex = $i
				Next
			EndIf
		Case UBound($avArray, 0) = 2 And $iDim = 2
			If $iSubItem < 0 Or $iSubItem > UBound($avArray) - 1 Then SetError(5, 0, -1)
			If $iCompNumeric Then
				For $i = $iStart To $iEnd
					If Number($avArray[$iSubItem][$iMinIndex]) > Number($avArray[$iSubItem][$i]) Then $iMinIndex = $i
				Next
			Else
				For $i = $iStart To $iEnd
					If $avArray[$iSubItem][$iMinIndex] > $avArray[$iSubItem][$i] Then $iMinIndex = $i
				Next
			EndIf
	EndSelect

	Return SetError(0, 0, $iMinIndex)
EndFunc   ;==>_Array2D_MinIndex

; #FUNCTION# ====================================================================================================================
; Name...........: _Array2D_StringOperation
; Description ...: Perform a string operation on all elements of an array
; Syntax.........: _Array2D_StringOperation(ByRef $avArray, $sOperation[, $sOperationParam = ""[, $iStart = 0[, $iEnd = -1[, $iSubStart = 0[, $iSubEnd = -1]]]]])
; Parameters ....: $avArray         - Array to modify
;                  $sOperation      - Operation to perform in the folowing list : StringLower, StringUpper, StringLeft, StringRight, StringTrimLeft, StringTrimRight, StringStripCR, StringStripWS
;                  $sOperationParam - [optional] Parameter for : StringLeft, StringRight, StringTrimLeft, StringTrimRight, StringStripWS
;                  $iStart          - [optional] First element to modify. Default : 0
;                  $iEnd            - [optional] Last element to modify. Default : end of the arry
;                  $iSubStart       - [optional] First element to modify in second dimension. Default : 0
;                  $iSubEnd         - [optional] Last element to modify in second dimension. Default : end of the arry
; Return values .: Success - 1
;                  Failure - 0, sets @error to :
;                  |1 - $avArray is not an array
;                  |2 - $avArray has more than 2 dimensions
;                  |3 - $sOperation is invalid
;                  |4 - $iStart > $iEnd (@extended = 1) OR $iSubStart > $iSubEnd (@extended = 2)
; Author ........: Tolf
; Modified.......:
; Remarks .......:
; Related .......: (_Array2D_Trim)
; Link ..........;
; Example .......; Yes
; ===============================================================================================================================
Func _Array2D_StringOperation(ByRef $avArray, $sOperation, $sOperationParam = "", $iStart = 0, $iEnd = -1, $iSubStart = 0, $iSubEnd = -1)
	If $sOperationParam = Default Then $sOperationParam = ""
	If $iStart = Default Then $iStart = 0
	If $iEnd = Default Then $iEnd = -1
	If $iSubStart = Default Then $iSubStart = 0
	If $iSubEnd = Default Then $iSubEnd = -1

	If Not IsArray($avArray) Then Return SetError(1, 0, 0)

	Local $iUbound = UBound($avArray), $i
	If $iEnd < 0 Or $iEnd > $iUbound - 1 Then $iEnd = $iUbound - 1
	If ($iStart > $iEnd) Then Return SetError(4, 1, 0)

	If Not ($sOperation = "StringLower" Or $sOperation = "StringUpper" Or $sOperation = "StringLeft" Or $sOperation = "StringRight" Or $sOperation = "StringTrimLeft" Or $sOperation = "StringTrimRight" Or $sOperation = "StringStripCR" Or $sOperation = "StringStripWS") Then Return SetError(3, 0, 0)

	Switch UBound($avArray, 0)
		Case 1
			For $i = $iStart To $iEnd
				__Array2D_PSOOperation($sOperation, $sOperationParam, $avArray[$i])
			Next
		Case 2
			Local $iUbound2 = UBound($avArray, 2), $j
			If $iSubEnd < 0 Or $iSubEnd > $iUbound2 - 1 Then $iSubEnd = $iUbound2 - 1
			If ($iSubStart > $iSubEnd) Then Return SetError(4, 2, 0)

			For $i = $iStart To $iEnd
				For $j = $iSubStart To $iSubEnd
					__Array2D_PSOOperation($sOperation, $sOperationParam, $avArray[$i][$j])
				Next
			Next
		Case Else
			Return SetError(2, 0, 0)
	EndSwitch

	Return SetError(0, 0, 1)
EndFunc   ;==>_Array2D_StringOperation
; #INTERNAL_USE_ONLY#============================================================================================================
; Name...........: __Array2D_PSOOperation
; Description ...: Helper function for performing string operation
; Syntax.........: __Array2D_PSOOperation($sOperation, $sOperationParam, ByRef $Item)
; Parameters ....: $sOperation       - Operation to perform in the folowing list : StringLower, StringUpper, StringLeft, StringRight, StringTrimLeft, StringTrimRight, StringStripCR, StringStripWS
;                  $sOperationParam - Parameter for : StringLeft, StringRight, StringTrimLeft, StringTrimRight, StringStripWS
;                  $Item            - Item to modify
; Return values .: None
; Author ........: Tolf
; Modified.......:
; Remarks .......: For Internal Use Only
; Related .......:
; Link ..........;
; Example .......;
; ===============================================================================================================================
Func __Array2D_PSOOperation($sOperation, $sOperationParam, ByRef $Item)
	Switch $sOperation
		Case "StringLower"
			$Item = StringLower($Item)
		Case "StringUpper"
			$Item = StringUpper($Item)
		Case "StringLeft"
			$Item = StringLeft($Item, $sOperationParam)
		Case "StringRight"
			$Item = StringRight($Item, $sOperationParam)
		Case "StringTrimLeft"
			$Item = StringTrimLeft($Item, $sOperationParam)
		Case "StringTrimRight"
			$Item = StringTrimRight($Item, $sOperationParam)
		Case "StringStripCR"
			$Item = StringStripCR($Item)
		Case "StringStripWS"
			$Item = StringStripWS($Item, $sOperationParam)
	EndSwitch
EndFunc   ;==>__Array2D_PSOOperation

; #FUNCTION# ====================================================================================================================
; Name...........: _Array2D_Pop
; Description ...: Returns the last element of an array, deleting that element from the array at the same time.
; Syntax.........: _Array2D_Pop(ByRef $avArray[, $iDim = 1])
; Parameters ....: $avArray - Array to modify
;                  $iDim    - [optional] Dimension to pop to. Default : 1
; Return values .: Success - The last element of the array
;                  Failure - "", sets @error to :
;                  |1 - $avArray is not an array
;                  |2 - $avArray has more than 2 dimensions
;                  |3 - $iDim is not equal to 1 or 2
; Author ........: Cephas <cephas at clergy dot net>
; Modified.......: Ultima - code cleanup
;                  Tolf - Updated 2D
; Remarks .......: If the array has one element left, it will be set to "" after _Array2D_Pop() is used on it.
; Related .......: _Array2D_Add, _Array2D_Delete, _Array2D_Insert, _Array2D_Push
; Link ..........;
; Example .......; Yes
; ===============================================================================================================================
Func _Array2D_Pop(ByRef $avArray, $iDim = 1)
	If $iDim = Default Then $iDim = 1

	If (Not IsArray($avArray)) Then Return SetError(1, 0, "")
	If UBound($avArray, 0) > 2 Then Return SetError(2, 0, "")

	If UBound($avArray, 0) = 1 Then $iDim = 1
	If $iDim <> 1 And $iDim <> 2 Then Return SetError(3, 0, "")
	Local $iUbound = UBound($avArray, $iDim) - 1, $vLastVal, $iUbound2, $i

	; Remove last item
	Select
		Case UBound($avArray, 0) = 1
			$vLastVal = $avArray [$iUbound]
			If Not $iUbound Then
				$avArray = ""
			Else
				ReDim $avArray [$iUbound]
			EndIf
		Case UBound($avArray, 0) = 2 And $iDim = 1
			$iUbound2 = UBound($avArray, 2)
			Dim $vLastVal [$iUbound2]
			For $i = 0 To $iUbound2 - 1
				$vLastVal [$i] = $avArray [$iUbound][$i]
			Next
			If Not $iUbound Then
				$avArray = ""
			Else
				ReDim $avArray [$iUbound][$iUbound2]
			EndIf
		Case UBound($avArray, 0) = 2 And $iDim = 2
			$iUbound2 = UBound($avArray)
			Dim $vLastVal [$iUbound2]
			For $i = 0 To $iUbound2 - 1
				$vLastVal [$i] = $avArray [$i][$iUbound]
			Next
			If Not $iUbound Then
				$avArray = ""
			Else
				ReDim $avArray [$iUbound2][$iUbound]
			EndIf
	EndSelect

	; Return last item
	Return SetError(0, 0, $vLastVal)
EndFunc   ;==>_Array2D_Pop

; #FUNCTION# ====================================================================================================================
; Name...........: _Array2D_Push
; Description ...: Add new values without increasing array size by inserting at the end the new value and deleting the first one or vice versa.
; Syntax.........: _Array2D_Push(ByRef $avArray, $vValue[, $iDirection = 0[, $iDim = 1[, $iSubItem = 0[, $iSynchronize = 1]]]])
; Parameters ....: $avArray      - Array to modify
;                  $vValue       - Value(s) to add (can be in an array)
;                  $iDirection   - [optional] Direction to push existing array elements:
;                  |0 = Slide left (adding at the end) (Default)
;                  |1 = Slide right (adding at the start)
;                  $iDim         - [optional] Dimension to push to. Default : 1
;                  $iSynchronize - [optional] If set to 1 push all the 2D-array, otherwise, just push $iSubItem. Default : 1
;                  $iSubItem     - [optional] Element to push to in  secondary dimension. Default : 0
; Return values .: Success - 1
;                  Failure - 0, sets @error:
;                  |1 - $avArray is not an array
;                  |2 - $avArray has more than 2 dimensions
;                  |3 - $iDim is not equal to 1 or 2
;                  |4 - $vValue has more dimensions than $avArray
;                  |5 - $vValue is an array larger than $avArray (so it can't fit)
; Author ........: Helias Gerassimou(hgeras)
;                  Ultima - code cleanup/rewrite (major optimization), fixed support for $vValue as an array
; Modified.......: Tolf - Updated 2D, "Default" value supported
; Remarks .......: WARNING : Errors codes have been changed :
;                  |2 => 5
;                  |2 added
;                  |3 added
;                  |4 added
;                  This function is used for continuous updates of data in array, where in other cases a vast size of array would be created.
;                  It keeps all values inside the array (something like History), minus the first one or the last one depending on direction chosen.
;                  It is similar to the push command in assembly.
; Related .......: _Array2D_Add, _Array2D_Clear, _Array2D_Concatenate, _Array2D_Delete, _Array2D_Insert, _Array2D_Pop, _Array2D_PutValue, _Array2D_Shift
; Link ..........;
; Example .......; Yes
; ===============================================================================================================================
Func _Array2D_Push(ByRef $avArray, $vValue, $iDirection = 0, $iDim = 1, $iSynchronize = 1, $iSubItem = 0)
	If $iDirection = Default Then $iDirection = 0
	If $iDim = Default Then $iDim = 1
	If $iSynchronize = Default Then $iSynchronize = 1
	If $iSubItem = Default Then $iSubItem = 0
	$vValue = __Array2D_GetValue($vValue)

	If Not IsArray($avArray) Then Return SetError(1, 0, 0)
	If $iDim <> 1 And $iDim <> 2 Then Return SetError(3, 0, 0)

	Local $iSize, $iElement
	Switch UBound($avArray, 0)
		Case 1
			If Not IsArray($vValue) Then
				$iSize = 1
			ElseIf UBound($vValue, 0) = 1 Then
				$iSize = UBound($vValue)
			EndIf
		Case 2
			If $iDim <> 1 And $iDim <> 2 Then Return SetError(3, 0, 0)
			If (Not IsArray($vValue)) Or UBound($vValue, 0) = 1 Then
				$iSize = 1
			ElseIf UBound($vValue, 0) = 2 Then
				$iSize = UBound($vValue, $iDim)
			EndIf
		Case Else
			Return SetError(2, 0, 0)
	EndSwitch
	If $iSize = "" Then Return SetError(4, 0, 0)
	If UBound($avArray, 0) = 1 Then $iDim = 1
	If $iSize >= UBound($avArray, $iDim) Then Return SetError(5, 0, 0)

	_Array2D_Shift($avArray, $iDirection, 0, -1, $iDim, $iSize)
	If $iDirection = 0 Then
		$iElement = UBound($avArray, $iDim) - $iSize
	Else
		$iElement = 0
	EndIf
	If UBound($avArray, 0) = 2 Then _Array2D_Clear($avArray, $iElement, $iElement + $iSize - 1, $iDim)
	_Array2D_PutValue($avArray, $vValue, $iElement, $iDim, $iSubItem)

	Return SetError(0, 0, 1)
EndFunc   ;==>_Array2D_Push

; #FUNCTION# ====================================================================================================================
; Name...........: _Array2D_PutValue
; Description ...: Put a value in an array.
; Syntax.........: _Array2D_PutValue(ByRef $avArray, $vValue , $iElement[, $iDim = 1[, $iSubItem = 0]])
; Parameters ....: $avArray  - Array to modify.
;                  $vValue   - Value of item to insert.
;                  $iElement - Value of item to insert.
;                  $iDim     - [optional] Dimension to put value to. Default : 1
;                  $iSubItem - [optional] Sub-Index to put value to. Default : 0
; Return values .: Success - 1
;                  Failure - 0, sets @error to :
;                  |1 - $avArray is not an array
;                  |2 - $avArray has more than 2 dimensions
;                  |3 - $iDim is not equal to 1 or 2
;                  |4 - $vValue has too many dimensions
; Author ........: Tolf
; Modified.......:
; Remarks .......: Used in _Array2D_Add, _Array2D_Insert, _Array2D_Push
; Related .......: _Array2D_Add, _Array2D_Clear, _Array2D_Insert, _Array2D_Push, _Array2D_Shift
; Link ..........;
; Example .......; Yes
; ===============================================================================================================================
Func _Array2D_PutValue(ByRef $avArray, $vValue, $iElement = 0, $iDim = 1, $iSubItem = 0)
	If $iElement = Default Then $iElement = 0
	If $iDim = Default Then $iDim = 1
	If $iSubItem = Default Then $iSubItem = 0
	$vValue = __Array2D_GetValue($vValue)

	If Not IsArray($avArray) Then Return SetError(1, 0, 0)
	If UBound($avArray, 0) = 1 Then $iDim = 1
	If $iDim <> 1 And $iDim <> 2 Then Return SetError(3, 0, 0)
	If $iElement < 0 Then $iElement = 0

	Local $i, $j
	Local $iUbound = UBound($avArray) - 1
	Switch UBound($avArray, 0)
		Case 1
			If UBound($vValue, 0) > 1 Then Return SetError(4, 0, 0)
			If Not IsArray($vValue) Then
				If $iElement < UBound($avArray) Then $avArray [$iElement] = $vValue
			ElseIf UBound($vValue, 0) = 1 Then
				For $i = $iElement To __Min($iElement + UBound($vValue) - 1, $iUbound)
					$avArray [$i] = $vValue [$i - $iElement]
				Next
			EndIf
		Case 2
			If UBound($vValue, 0) > 2 Then Return SetError(4, 0, 0)
			Local $iUbound2 = UBound($avArray, 2) - 1
			If $iSubItem < 0 Then $iSubItem = 0
			Switch $iDim
				Case 1
					If Not IsArray($vValue) Then
						If $iElement < UBound($avArray) And $iSubItem < UBound($avArray, 2) Then $avArray [$iElement][$iSubItem] = $vValue
					ElseIf UBound($vValue, 0) = 1 Then
						For $i = $iSubItem To __Min($iSubItem + UBound($vValue) - 1, $iUbound2)
							$avArray [$iElement][$i] = $vValue [$i - $iSubItem]
						Next
					ElseIf UBound($vValue, 0) = 2 Then
						For $i = $iElement To __Min($iElement + UBound($vValue) - 1, $iUbound)
							For $j = $iSubItem To __Min($iSubItem + UBound($vValue, 2) - 1, $iUbound2)
								$avArray [$i][$j] = $vValue [$i - $iElement][$j - $iSubItem]
							Next
						Next
					EndIf
				Case 2
					If Not IsArray($vValue) Then
						If $iElement < UBound($avArray, 2) And $iSubItem < UBound($avArray) Then $avArray [$iSubItem][$iElement] = $vValue
					ElseIf UBound($vValue, 0) = 1 Then
						For $i = $iElement To __Min($iElement + UBound($vValue) - 1, $iUbound)
							$avArray [$i][$iSubItem] = $vValue [$i - $iElement]
						Next
					ElseIf UBound($vValue, 0) = 2 Then
						For $i = $iElement To __Min($iElement + UBound($vValue) - 1, $iUbound)
							For $j = $iSubItem To __Min($iSubItem + UBound($vValue, 2) - 1, $iUbound2)
								$avArray [$i][$j] = $vValue [$i - $iElement][$j - $iSubItem]
							Next
						Next
					EndIf
			EndSwitch
		Case Else
			Return SetError(2, 0, 0)
	EndSwitch

	Return SetError(0, 0, 1)
EndFunc   ;==>_Array2D_PutValue

; #FUNCTION# ====================================================================================================================
; Name...........: _Array2D_RandomMix
; Description ...: Mixes an array at random.
; Syntax.........: _Array2D_RandomMix(ByRef $avArray[, $iStart = 0[, $iEnd = 0[, $iDim = 1[, $iSynchronize = 1[, $iSubItem = 0]]]]])
; Parameters ....: $avArray      - The array to modify
;                  $iStart       - [optional] The first item to mix. Default : 0
;                  $iEnd         - [optional] The last item to mix. Default : end of the array
;                  $iDim         - [optional] The dimension to mix to. Default : 1
;                  $iSynchronize - [optional] If set to 1, synchronyze mixing in all raws, otherwise mixes only $iSubItem. Default : 1
;                  $iSubItem     - [optional] The element to mix in main dimension. Default : 0
; Return values .: Success - 1
;                  Failure - 0, sets @error to
;                  |1 - $avArray is not an array
;                  |2 - $avArray has more than 2 dimensions
;                  |3 - $iDim is not equal to 1 or 2
;                  |4 - $iStart > $iEnd
;                  |5 - $iSubItem is too large or negative
; Author ........: Tolf
; Modified.......:
; Remarks .......:
; Related .......: _Array2D_Sort
; Link ..........;
; Example .......; Yes
; ===============================================================================================================================
Func _Array2D_RandomMix(ByRef $avArray, $iStart = 0, $iEnd = -1, $iDim = 1, $iSynchronize = 1, $iSubItem = 0)
	If $iStart = Default Then $iStart = 0
	If $iEnd = Default Then $iEnd = -1
	If $iDim = Default Then $iDim = 1
	If $iSynchronize = Default Then $iSynchronize = 1
	If $iSubItem = Default Then $iSubItem = 0

	If Not IsArray($avArray) Then Return SetError(1, 0, 0)

	Local $iUbound, $i, $avOrder
	Switch UBound($avArray, 0)
		Case 1
			$iUbound = UBound($avArray)
			If $iEnd < 0 Or $iEnd > $iUbound - 1 Then $iEnd = $iUbound - 1
			If ($iStart > $iEnd) Then Return SetError(4, 0, 0)

			Local $avNewArray [$iUbound]
			$avOrder = __Array2D_CreateOrder($iEnd + 1 - $iStart)

			For $i = 0 To $iUbound - 1
				If $i >= $iStart And $i <= $iEnd Then
					$avNewArray [$i] = $avArray [$iStart + $avOrder [$i - $iStart] - 1]
				Else
					$avNewArray [$i] = $avArray [$i]
				EndIf
			Next
		Case 2
			If $iDim <> 1 And $iDim <> 2 Then Return SetError(3, 0, 0)
			If $iEnd < 0 Or $iEnd > UBound($avArray, $iDim) - 1 Then $iEnd = UBound($avArray, $iDim) - 1
			If ($iStart > $iEnd) Then Return SetError(4, 0, 0)
			If $iSubItem < 0 Or $iSubItem > UBound($avArray, Mod($iDim, 2) + 1) - 1 Then Return SetError(5, 0, 0)

			$iUbound = UBound($avArray)
			Local $iUbound2 = UBound($avArray, 2), $j, $avNewArray [$iUbound][$iUbound2]
			$avOrder = __Array2D_CreateOrder($iEnd + 1 - $iStart)

			Switch $iDim
				Case 1
					For $i = 0 To $iUbound - 1
						If $i >= $iStart And $i <= $iEnd Then
							For $j = 0 To $iUbound2 - 1
								If Not ($iSynchronize) And $j <> $iSubItem Then
									$avNewArray [$i][$j] = $avArray [$i][$j]
								Else
									$avNewArray [$i][$j] = $avArray [$iStart + $avOrder [$i - $iStart] - 1][$j]
								EndIf
							Next
						Else
							For $j = 0 To $iUbound2 - 1
								$avNewArray [$i][$j] = $avArray [$i][$j]
							Next
						EndIf
					Next
				Case 2
					For $j = 0 To $iUbound2 - 1
						If $j >= $iStart And $j <= $iEnd Then
							For $i = 0 To $iUbound - 1
								If Not ($iSynchronize) And $i <> $iSubItem Then
									$avNewArray [$i][$j] = $avArray [$i][$j]
								Else
									$avNewArray [$i][$j] = $avArray [$i][$iStart + $avOrder [$j - $iStart] - 1]
								EndIf
							Next
						Else
							For $i = 0 To $iUbound - 1
								$avNewArray [$i][$j] = $avArray [$i][$j]
							Next
						EndIf
					Next
			EndSwitch
		Case Else
			Return SetError(2, 0, 0)
	EndSwitch

	$avArray = $avNewArray
	Return SetError(0, 0, 1)
EndFunc   ;==>_Array2D_RandomMix
; #INTERNAL_USE_ONLY#============================================================================================================
; Name...........: __Array2D_CreateOrder
; Description ...: Creates a random order
; Syntax.........: __Array2D_CreateOrder($OrderLength)
; Parameters ....: $order_length - size of order to create
; Return values .: a 1D-array with consecutive numbers from 1 to $order_length mixed at random
; Author ........: Tolf
; Modified.......:
; Remarks .......: For Internal Use Only
; Related .......:
; Link ..........;
; Example .......;
; ===============================================================================================================================
Func __Array2D_CreateOrder($OrderLength)
	Local $avOrder [$OrderLength], $random, $i
	For $i = 1 To $OrderLength
		Do
			$random = Random(1, $OrderLength, 1)
		Until $avOrder [$random - 1] = ""
		$avOrder [$random - 1] = $i
	Next
	Return $avOrder
EndFunc   ;==>__Array2D_CreateOrder

; #FUNCTION# ====================================================================================================================
; Name...........: _Array2D_Reverse
; Description ...: Takes the given array and reverses the order in which the elements appear in the array.
; Syntax.........: _Array2D_Reverse(ByRef $avArray[, $iStart = 0[, $iEnd = -1[, $iDim = 1]]])
; Parameters ....: $avArray - Array to modify
;                  $iStart  - [optional] Index of array to start modifying at. Default : 0
;                  $iEnd    - [optional] Index of array to stop modifying at. Default : end of the array
;                  $iDim    - [optional] Dimension to modify to. Default : 1
; Return values .: Success - 1
;                  Failure - 0, sets @error:
;                  |1 - $avArray is not an array
;                  |2 - $avArray has more than 2 dimensions
;                  |3 - $iDim is not equal to 1 or 2
;                  |4 - $iStart is greater than $iEnd
; Author ........: Brian Keene
; Modified.......: Jos van der Zande <jdeb at autoitscript dot com> -  added $iStart parameter and logic
;                  Tylo - added $iEnd parameter and rewrote it for speed
;                  Ultima - code cleanup, minor optimization
;                  Tolf - Updated 2D, rewrote using _Array2D_SwapByIndex, "Default" value supported
; Remarks .......: WARNING : Errors codes have been changed :
;                  |2 => 4
;                  |2 added
;                  |3 added
; Related .......: _Array2D_Swap, _Array2D_SwapByIndex, _Array2D_Transpose
; Link ..........;
; Example .......; Yes
; ===============================================================================================================================
Func _Array2D_Reverse(ByRef $avArray, $iStart = 0, $iEnd = -1, $iDim = 1)
	If $iStart = Default Then $iStart = 0
	If $iEnd = Default Then $iEnd = -1
	If $iDim = Default Then $iDim = 1

	If Not IsArray($avArray) Then Return SetError(1, 0, 0)

	If UBound($avArray, 0) = 1 Then $iDim = 1
	Local $iUbound = UBound($avArray, $iDim) - 1, $i
	; checking
	If $iEnd < 0 Or $iEnd > $iUbound Then $iEnd = $iUbound
	If $iStart < 0 Then $iStart = 0
	If $iStart > $iEnd Then Return SetError(4, 0, 0)
	If UBound($avArray, 0) > 2 Then Return SetError(2, 0, 0)
	If $iDim <> 1 And $iDim <> 2 Then Return SetError(3, 0, 0)
	; reverse
	For $i = $iStart To Int(($iStart + $iEnd - 1) / 2)
		_Array2D_SwapByIndex($avArray, $i, $iEnd, $iDim)
		$iEnd -= 1
	Next

	Return SetError(0, 0, 1)
EndFunc   ;==>_Array2D_Reverse

; #FUNCTION# ====================================================================================================================
; Name...........: _Array2D_Search
; Description ...: Finds an entry within a 1D or 2D array. Similar to _Array2D_BinarySearch(), except that the array does not need to be sorted.
; Syntax.........: _Array2D_Search(Const ByRef $avArray, $vValue[, $iStart = 0[, $iEnd = -1[, $iCase = 0[, $iPartial = 0[, $iForward = 1[, $iSubItem = 0[, $iDim = 1]]]]]]])
; Parameters ....: $avArray  - The array to search
;                  $vValue   - What to search $avArray for
;                  $iStart   - [optional] Index of array to start searching at. Default : 0
;                  $iEnd     - [optional] Index of array to stop searching at. Default : end of the array
;                  $iCase    - [optional] If set to 1, search is case sensitive. Default : 0
;                  $iPartial - [optional] If set to 1, executes a partial search. Default : 0
;                  $iForward - [optional] If set to 0, searches the array from end to beginning (instead of beginning to end). Default : 1
;                  $iSubItem - [optional] Sub-index to search on in 2D arrays. Default : 0
;                  $iDim     - [optional] Dimension to search to. Default : 1
; Return values .: Success - The index that $vValue was found at
;                  Failure - -1, sets @error:
;                  |1 - $avArray is not an array
;                  |2 - $avArray has more than 2 dimensions
;                  |3 - $iDim is not equal to 1 or 2
;                  |4 - $iStart is greater than $iEnd
;                  |6 - $vValue was not found in array
; Author ........: SolidSnake <MetalGX91 at GMail dot com>
; Modified.......: gcriaco <gcriaco at gmail dot com>
;                  Ultima - 2D arrays supported, directional search, code cleanup, optimization
;                  Tolf - dimension choice added, error codes changed, "Default" value supported
; Remarks .......: WARNING : Errors codes have been changed :
;                  |7 => 2
;                  |3 added (replace a deprecated error code)
;                  This function might be slower than _Array2D_BinarySearch() but is useful when the array's order can't be altered.
; Related .......: _Array2D_BinarySearch, _Array2D_FindAll
; Link ..........;
; Example .......; Yes
; ===============================================================================================================================
Func _Array2D_Search(Const ByRef $avArray, $vValue, $iStart = 0, $iEnd = -1, $iCase = 0, $iPartial = 0, $iForward = 1, $iSubItem = 0, $iDim = 1)
	If $iStart = Default Then $iStart = 0
	If $iEnd = Default Then $iEnd = -1
	If $iCase = Default Then $iCase = 0
	If $iPartial = Default Then $iPartial = 0
	If $iForward = Default Then $iForward = 1
	If $iSubItem = Default Then $iSubItem = 0
	If $iDim = Default Then $iDim = 1

	If Not IsArray($avArray) Then Return SetError(1, 0, -1)

	Local $iUbound = UBound($avArray) - 1

	; Bounds checking
	If $iEnd < 0 Or $iEnd > $iUbound Then $iEnd = $iUbound
	If $iStart < 0 Then $iStart = 0
	If $iStart > $iEnd Then Return SetError(4, 0, -1)

	; Direction (flip if $iForward = 0)
	Local $iStep = 1, $i
	If Not $iForward Then
		_Array2D_Swap($iStart, $iEnd)
		$iStep = -1
	EndIf

	; Search
	Switch UBound($avArray, 0)
		Case 1 ; 1D array search
			If Not $iPartial Then
				If Not $iCase Then
					For $i = $iStart To $iEnd Step $iStep
						If $avArray[$i] = $vValue Then Return SetError(0, 0, $i)
					Next
				Else
					For $i = $iStart To $iEnd Step $iStep
						If $avArray[$i] == $vValue Then Return SetError(0, 0, $i)
					Next
				EndIf
			Else
				For $i = $iStart To $iEnd Step $iStep
					If StringInStr($avArray[$i], $vValue, $iCase) > 0 Then Return SetError(0, 0, $i)
				Next
			EndIf
		Case 2 ; 2D array search
			If $iDim <> 1 And $iDim <> 2 Then Return SetError(3, 0, -1)
			Local $iUBoundSub = UBound($avArray, Mod($iDim, 2) + 1) - 1
			If $iSubItem < 0 Then $iSubItem = 0
			If $iSubItem > $iUBoundSub Then $iSubItem = $iUBoundSub
			Switch $iDim
				Case 1
					If Not $iPartial Then
						If Not $iCase Then
							For $i = $iStart To $iEnd Step $iStep
								If $avArray[$i][$iSubItem] = $vValue Then Return SetError(0, 0, $i)
							Next
						Else
							For $i = $iStart To $iEnd Step $iStep
								If $avArray[$i][$iSubItem] == $vValue Then Return SetError(0, 0, $i)
							Next
						EndIf
					Else
						For $i = $iStart To $iEnd Step $iStep
							If StringInStr($avArray[$i][$iSubItem], $vValue, $iCase) > 0 Then Return SetError(0, 0, $i)
						Next
					EndIf
				Case 2
					If Not $iPartial Then
						If Not $iCase Then
							For $i = $iStart To $iEnd Step $iStep
								If $avArray[$iSubItem][$i] = $vValue Then Return SetError(0, 0, $i)
							Next
						Else
							For $i = $iStart To $iEnd Step $iStep
								If $avArray[$iSubItem][$i] == $vValue Then Return SetError(0, 0, $i)
							Next
						EndIf
					Else
						For $i = $iStart To $iEnd Step $iStep
							If StringInStr($avArray[$iSubItem][$i], $vValue, $iCase) > 0 Then Return SetError(0, 0, $i)
						Next
					EndIf
			EndSwitch
		Case Else
			Return SetError(2, 0, -1)
	EndSwitch

	Return SetError(6, 0, -1)
EndFunc   ;==>_Array2D_Search

; #FUNCTION# ====================================================================================================================
; Name...........: _Array2D_SetDelim
; Description ...: Set the delimiter string to use in the Array2D functions.
; Syntax.........: _Array2D_SetDelim($sDelim = "", $iSplitFlag = 0)
; Parameters ....: $sDelim     - The delimiter string to use to split "$vValue" parameters. Default : don't split "$vValue"
;                  $iSplitFlag - If flag is 0 (the default), then each character in the delimiter string will mark where to split the string.
; Return values .: Success - 1
;                  Failure - 0, sets @error to:
;                  |1 - $sDelim is not a string
;                  |2 - $iSplitFlag is not equal to 0 or 1
; Author ........: Tolf
; Modified.......:
; Remarks .......: _Array2D_SetDelim affect the following functions : _Array2D_Add, _Array2D_Display (for $avCol and $avLines), _Array2D_Insert, _Array2D_Push and _Array2D_PutValue
;                  If you set $sDelim to "", then "$vValue" will not be splited if it is a string
; Related .......: _Array2D_Add, _Array2D_Display, _Array2D_Insert, _Array2D_Push, _Array2D_PutValue
; Link ..........;
; Example .......; Yes
; ===============================================================================================================================
Func _Array2D_SetDelim($sDelim = "", $iSplitFlag = 0)
	If $sDelim = Default Then $sDelim = ""
	If $iSplitFlag = Default Then $iSplitFlag = 0

	If Not IsString($sDelim) Then Return SetError(1, 0, 0)
	If $iSplitFlag <> 0 And $iSplitFlag <> 1 Then Return SetError(2, 0, 0)

	$ARRAY2D_DELIM_STRING = $sDelim
	$ARRAY2D_DELIM_FLAG = $iSplitFlag
	Return SetError(0, 0, 1)
EndFunc   ;==>_Array2D_SetDelim

; #FUNCTION# ====================================================================================================================
; Name...........: _Array2D_Shift
; Description ...: Shift elements in an array.
; Syntax.........: _Array2D_Shift(ByRef $avArray[, $iDirection = 1[, $iStart = 0[, $i_End = -1[, $iDim = 1[, $iSize = 1]]]]])
; Parameters ....: $avArray    - The array to modify
;                  $iDirection - [optional] Direction to shift existing array elements:
;                  |0 = Slide left (shifting from the end to the start)
;                  |1 = Slide right (shifting from the start to the end)
;                  $iStart     - [optional] Index of array to start shifting at. Default : 0
;                  $iEnd       - [optional] Index of array to stop shifting at. Default : end of the array
;                  $iDim       - [optional] Dimension to shift to. Default : 1
;                  $iSize      - [optional] Size of the shifting step. Default : 1
; Return values .: Success - 1
;                  Failure - 0, sets @error to:
;                  |1 - $avArray is not an array
;                  |2 - $avArray has more than 2 dimensions
;                  |3 - $iDim is not equal to 1 or 2
;                  |4 - $iStart > $iEnd
;                  |5 - $iDirection is not equal to 0 or 1
;                  |6 - $iSize > $iEnd - $iStart
; Author ........: Tolf
; Modified.......:
; Remarks .......: Used in _Array2D_Delete, _Array2D_Insert,_Array2D_Push
; Related .......: _Array2D_Clear, _Array2D_Delete, _Array2D_Insert, _Array2D_Push, _Array2D_PutValue
; Link ..........;
; Example .......; Yes
; ===============================================================================================================================
Func _Array2D_Shift(ByRef $avArray, $iDirection = 1, $iStart = 0, $iEnd = -1, $iDim = 1, $iSize = 1)
	If $iDirection = Default Then $iDirection = 1
	If $iStart = Default Then $iStart = 0
	If $iEnd = Default Then $iEnd = -1
	If $iDim = Default Then $iDim = 1
	If $iSize = Default Then $iSize = 1

	If Not IsArray($avArray) Then Return SetError(1, 0, 0)
	Local $iStep, $i, $j, $iUbound

	If UBound($avArray, 0) = 1 Then $iDim = 1
	$iUbound = UBound($avArray, $iDim) - 1
	If $iEnd < 0 Or $iEnd > $iUbound Then $iEnd = $iUbound
	If $iStart < 0 Then $iStart = 0
	If $iStart > $iEnd Then Return SetError(4, 0, 0)

	If $iDirection = 0 Then
		$iStep = 1
	ElseIf $iDirection = 1 Then
		_Array2D_Swap($iStart, $iEnd)
		$iStep = -1
	Else
		Return SetError(5, 0, 0)
	EndIf

	If $iSize < 1 Then $iSize = 1
	If $iSize > ($iEnd - $iStart) * $iStep Then Return SetError(6, 0, 0)

	Local $iUbound2
	Switch UBound($avArray, 0)
		Case 1
			For $i = $iStart To $iEnd - $iSize * $iStep Step $iStep
				$avArray[$i] = $avArray[$i + $iSize * $iStep]
			Next
		Case 2
			Switch $iDim
				Case 1
					$iUbound2 = UBound($avArray, 2) - 1
					For $i = $iStart To $iEnd - $iSize * $iStep Step $iStep
						For $j = 0 To $iUbound2
							$avArray[$i][$j] = $avArray[$i + $iSize * $iStep][$j]
						Next
					Next
				Case 2
					$iUbound2 = UBound($avArray, 1) - 1
					For $i = $iStart To $iEnd - $iSize * $iStep Step $iStep
						For $j = 0 To $iUbound2
							$avArray[$j][$i] = $avArray[$j][$i + $iSize * $iStep]
						Next
					Next
				Case Else
					Return SetError(3, 0, 0)
			EndSwitch
		Case Else
			Return SetError(2, 0, 0)
	EndSwitch

	Return SetError(0, 0, 1)
EndFunc   ;==>_Array2D_Shift

; #FUNCTION# ====================================================================================================================
; Name...........: _ArraySort
; Description ...: Sort a 1D or 2D array on a specific index using the quicksort/insertionsort algorithms.
; Syntax.........: _ArraySort(ByRef $avArray[, $iDescending = 0[, $iStart = 0[, $iEnd = -1[, $iSubItem = 0[, $iDim = 1[, $iSynchronize = 1]]]]]])
; Parameters ....: $avArray      - Array to sort
;                  $iDescending  - [optional] If set to 1, sort descendingly. Default : 0
;                  $iStart       - [optional] Index of array to start sorting at. Default : 0
;                  $iEnd         - [optional] Index of array to stop sorting at. Default : end of the array
;                  $iSubItem     - [optional] Sub-index to sort on in 2D arrays. Default : 0
;                  $iDim         - [optional] Dimension to sort to in 2D arrays. Default : 1
;                  $iSynchronize - [optional] If set to 1, sort all the array, otherwise, just sort $iSubItem. Default : 1
; Return values .: Success - 1
;                  Failure - 0, sets @error:
;                  |1 - $avArray is not an array
;                  |2 - $avArray has more than 2 dimensions
;                  |3 - $iDim is not equal to 1 or 2
;                  |4 - $iStart is greater than $iEnd
;                  |5 - $iSubItem is too large or negative
; Author ........: Jos van der Zande <jdeb at autoitscript dot com>
; Modified.......: LazyCoder - added $iSubItem option
;                  Tylo - implemented stable QuickSort algo
;                  Jos van der Zande - changed logic to correctly Sort arrays with mixed Values and Strings
;                  Ultima - major optimization, code cleanup, removed $i_Dim parameter
;                  Tolf - added $iDim and $iSynchronize_in_all options, error codes changed, modification on __ArrayQuickSort1D and __ArrayQuickSort2D, "Default" value supported
; Remarks .......: WARNING : Errors codes have been changed :
;                  |2 => 4
;                  |3 => 5
;                  |4 => 2
;                  |3 added
; Related .......: _Array2D_RandomMix
; Link ..........;
; Example .......; Yes
; ===============================================================================================================================
Func _Array2D_Sort(ByRef $avArray, $iDescending = 0, $iStart = 0, $iEnd = -1, $iSubItem = 0, $iDim = 1, $iSynchronize = 1)
	If $iDescending = Default Then $iDescending = 0
	If $iStart = Default Then $iStart = 0
	If $iEnd = Default Then $iEnd = -1
	If $iSubItem = Default Then $iSubItem = 0
	If $iDim = Default Then $iDim = 1
	If $iSynchronize = Default Then $iSynchronize = 1

	If Not IsArray($avArray) Then Return SetError(1, 0, 0)

	Local $iUbound = UBound($avArray) - 1
	; Bounds checking
	If $iEnd < 0 Or $iEnd > $iUbound Then $iEnd = $iUbound
	If $iStart < 0 Then $iStart = 0
	If $iStart > $iEnd Then Return SetError(4, 0, 0)
	; Sort
	Switch UBound($avArray, 0)
		Case 1
			__Array2D_QuickSort1D($avArray, $iStart, $iEnd)
			If $iDescending Then _Array2D_Reverse($avArray, $iStart, $iEnd)
		Case 2
			If $iDim <> 1 And $iDim <> 2 Then Return SetError(3, 0, 0)
			Local $iSubMax = UBound($avArray, Mod($iDim, 2) + 1) - 1
			If $iSubItem < 0 Or $iSubItem > $iSubMax Then Return SetError(5, 0, 0)

			If $iDescending Then
				$iDescending = -1
			Else
				$iDescending = 1
			EndIf

			Switch $iDim
				Case 1
					__Array2D_QuickSort2Ddim1($avArray, $iDescending, $iStart, $iEnd, $iSubItem, $iSubMax, $iSynchronize)
				Case 2
					__Array2D_QuickSort2Ddim2($avArray, $iDescending, $iStart, $iEnd, $iSubItem, $iSubMax, $iSynchronize)
			EndSwitch
		Case Else
			Return SetError(2, 0, 0)
	EndSwitch

	Return SetError(0, 0, 1)
EndFunc   ;==>_Array2D_Sort
; #INTERNAL_USE_ONLY#============================================================================================================
; Name...........: __ArrayQuickSort1D
; Description ...: Helper function for sorting 1D arrays
; Syntax.........: __ArrayQuickSort1D(ByRef $avArray, ByRef $iStart, ByRef $iEnd)
; Parameters ....: $avArray - Array to sort
;                  $iStart  - Index of array to start sorting at
;                  $iEnd    - Index of array to stop sorting at
; Return values .: None
; Author ........: Jos van der Zande, LazyCoder, Tylo, Ultima
; Modified.......: Tolf - swap now uses _Array2D_Swap
; Remarks .......: For Internal Use Only
; Related .......:
; Link ..........;
; Example .......;
; ===============================================================================================================================
Func __Array2D_QuickSort1D(ByRef $avArray, ByRef $iStart, ByRef $iEnd)
	If $iEnd <= $iStart Then Return

	Local $vTmp

	; InsertionSort (faster for smaller segments)
	If ($iEnd - $iStart) < 15 Then
		Local $i, $j, $vCur
		For $i = $iStart + 1 To $iEnd
			$vTmp = $avArray[$i]

			If IsNumber($vTmp) Then
				For $j = $i - 1 To $iStart Step - 1
					$vCur = $avArray[$j]
					; If $vTmp >= $vCur Then ExitLoop
					If ($vTmp >= $vCur And IsNumber($vCur)) Or (Not IsNumber($vCur) And StringCompare($vTmp, $vCur) >= 0) Then ExitLoop
					$avArray[$j + 1] = $vCur
				Next
			Else
				For $j = $i - 1 To $iStart Step - 1
					If (StringCompare($vTmp, $avArray[$j]) >= 0) Then ExitLoop
					$avArray[$j + 1] = $avArray[$j]
				Next
			EndIf

			$avArray[$j + 1] = $vTmp
		Next
		Return
	EndIf

	; QuickSort
	Local $L = $iStart, $R = $iEnd, $vPivot = $avArray[Int(($iStart + $iEnd) / 2) ], $fNum = IsNumber($vPivot)
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
			_Array2D_Swap($avArray[$L], $avArray[$R])
			$L += 1
			$R -= 1
		EndIf
	Until $L > $R

	__Array2D_QuickSort1D($avArray, $iStart, $R)
	__Array2D_QuickSort1D($avArray, $L, $iEnd)
EndFunc   ;==>__Array2D_QuickSort1D
; #INTERNAL_USE_ONLY#============================================================================================================
; Name...........: __ArrayQuickSort2Ddim1
; Description ...: Helper function for sorting 2D arrays
; Syntax.........: __ArrayQuickSort2Ddim1(ByRef $avArray, ByRef $iStep, ByRef $iStart, ByRef $iEnd, ByRef $iSubItem, ByRef $iSubMax, ByRef $iSynchronize)
; Parameters ....: $avArray     - Array to sort
;                  $iStep       - Step size (should be 1 to sort ascending, -1 to sort descending!)
;                  $iStart      - Index of array to start sorting at
;                  $iEnd        - Index of array to stop sorting at
;                  $iSubItem    - Sub-index to sort on in 2D arrays
;                  $iSubMax     - Maximum sub-index that array has
;                  $iSynchronize - If set to 1, sort all the array, otherwise, just sort $iSubItem.
; Return values .: None
; Author ........: Jos van der Zande, LazyCoder, Tylo, Ultima
; Modified.......: Tolf - swap now uses _Array2D_Swap, $iSynchronize_in_all added
; Remarks .......: For Internal Use Only
; Related .......:
; Link ..........;
; Example .......;
; ===============================================================================================================================
Func __Array2D_QuickSort2Ddim1(ByRef $avArray, ByRef $iStep, ByRef $iStart, ByRef $iEnd, ByRef $iSubItem, ByRef $iSubMax, ByRef $iSynchronize)
	If $iEnd <= $iStart Then Return

	; QuickSort
;~ 	Local $i, $vTmp, $L = $iStart, $R = $iEnd, $vPivot = $avArray[Int(($iStart + $iEnd) / 2)][$iSubItem], $fNum = IsNumber($vPivot)
	Local $i, $L = $iStart, $R = $iEnd, $vPivot = $avArray[Int(($iStart + $iEnd) / 2) ][$iSubItem], $fNum = IsNumber($vPivot)
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
			If $iSynchronize Then
				For $i = 0 To $iSubMax
					_Array2D_Swap($avArray[$L][$i], $avArray[$R][$i])
				Next
			Else
				_Array2D_Swap($avArray[$L][$iSubItem], $avArray[$R][$iSubItem])
			EndIf
			$L += 1
			$R -= 1
		EndIf
	Until $L > $R

	__Array2D_QuickSort2Ddim1($avArray, $iStep, $iStart, $R, $iSubItem, $iSubMax, $iSynchronize)
	__Array2D_QuickSort2Ddim1($avArray, $iStep, $L, $iEnd, $iSubItem, $iSubMax, $iSynchronize)
EndFunc   ;==>__Array2D_QuickSort2Ddim1
; #INTERNAL_USE_ONLY#============================================================================================================
; Name...........: __ArrayQuickSort2Ddim2
; Description ...: Helper function for sorting 2D arrays
; Syntax.........: __ArrayQuickSort2Ddim2(ByRef $avArray, ByRef $iStep, ByRef $iStart, ByRef $iEnd, ByRef $iSubItem, ByRef $iSubMax, ByRef $iSynchronize_in_all)
; Parameters ....: $avArray     - Array to sort
;                  $iStep       - Step size (should be 1 to sort ascending, -1 to sort descending!)
;                  $iStart      - Index of array to start sorting at
;                  $iEnd        - Index of array to stop sorting at
;                  $iSubItem    - Sub-index to sort on in 2D arrays
;                  $iSubMax     - Maximum sub-index that array has
;                  $iSynchronize - If set to 1, sort all the array, otherwise, just sort $iSubItem.
; Return values .: None
; Author ........: Jos van der Zande, LazyCoder, Tylo, Ultima
; Modified.......: Tolf - swap now uses _Array2D_Swap, $iSynchronize_in_all added
; Remarks .......: For Internal Use Only
; Related .......:
; Link ..........;
; Example .......;
; ===============================================================================================================================
Func __Array2D_QuickSort2Ddim2(ByRef $avArray, ByRef $iStep, ByRef $iStart, ByRef $iEnd, ByRef $iSubItem, ByRef $iSubMax, ByRef $iSynchronize)
	If $iEnd <= $iStart Then Return

	; QuickSort
;~ 	Local $i, $vTmp, $L = $iStart, $R = $iEnd, $vPivot = $avArray[$iSubItem][Int(($iStart + $iEnd) / 2)], $fNum = IsNumber($vPivot)
	Local $i, $L = $iStart, $R = $iEnd, $vPivot = $avArray[$iSubItem][Int(($iStart + $iEnd) / 2) ], $fNum = IsNumber($vPivot)
	Do
		If $fNum Then
			; While $avArray[$iSubItem][$L] < $vPivot
			While ($iStep * ($avArray[$iSubItem][$L] - $vPivot) < 0 And IsNumber($avArray[$iSubItem][$L])) Or (Not IsNumber($avArray[$iSubItem][$L]) And $iStep * StringCompare($avArray[$iSubItem][$L], $vPivot) < 0)
				$L += 1
			WEnd
			; While $avArray[$iSubItem][$R] > $vPivot
			While ($iStep * ($avArray[$iSubItem][$R] - $vPivot) > 0 And IsNumber($avArray[$iSubItem][$R])) Or (Not IsNumber($avArray[$iSubItem][$R]) And $iStep * StringCompare($avArray[$iSubItem][$R], $vPivot) > 0)
				$R -= 1
			WEnd
		Else
			While ($iStep * StringCompare($avArray[$iSubItem][$L], $vPivot) < 0)
				$L += 1
			WEnd
			While ($iStep * StringCompare($avArray[$iSubItem][$R], $vPivot) > 0)
				$R -= 1
			WEnd
		EndIf

		; Swap
		If $L <= $R Then
			If $iSynchronize Then
				For $i = 0 To $iSubMax
					_Array2D_Swap($avArray[$i][$L], $avArray[$i][$R])
				Next
			Else
				_Array2D_Swap($avArray[$iSubItem][$L], $avArray[$iSubItem][$R])
			EndIf
			$L += 1
			$R -= 1
		EndIf
	Until $L > $R

	__Array2D_QuickSort2Ddim2($avArray, $iStep, $iStart, $R, $iSubItem, $iSubMax, $iSynchronize)
	__Array2D_QuickSort2Ddim2($avArray, $iStep, $L, $iEnd, $iSubItem, $iSubMax, $iSynchronize)
EndFunc   ;==>__Array2D_QuickSort2Ddim2

; #FUNCTION# ====================================================================================================================
; Name...........: _Array2D_Swap
; Description ...: Swaps two items.
; Syntax.........: _Array2D_Swap(ByRef $vItem1, ByRef $vItem2)
; Parameters ....: $vItem1 - First item to swap
;                  $vItem2 - Second item to swap
; Return values .: None.
; Author ........: David Nuttall <danuttall at rocketmail dot com>
; Modified.......: Ultima - minor optimization
; Remarks .......: This function swaps the two items in place, since they're passed by reference. Regular, non-array variables can also be swapped by this function.
; Related .......: _Array2D_SwapByIndex, _Array2D_Reverse
; Link ..........;
; Example .......; Yes
; ===============================================================================================================================
Func _Array2D_Swap(ByRef $vItem1, ByRef $vItem2)
	Local $vTmp = $vItem1
	$vItem1 = $vItem2
	$vItem2 = $vTmp
EndFunc   ;==>_Array2D_Swap

; #FUNCTION# ====================================================================================================================
; Name...........: _Array2D_SwapByIndex
; Description ...: Swaps two lines or columns of an array, using index.
; Syntax.........: _Array2D_SwapByIndex(ByRef $avArray, $iItem1, $iItem2, $dim = 1)
; Parameters ....: $avArray - Array to change
;                  $iItem1  - Index of first raw to swap
;                  $iItem2  - Index of second raw to swap
;                  $iDim    - [optional] Dimension to swap to. Default : 1
; Return values .: Success - 1
;                  Failure - 0, sets @error to :
;                  |1 - $avArray is not an array
;                  |2 - $avArray has more than 2 dimensions
;                  |3 - $iDim is not equal to 1 or 2
; Author ........: Tolf
; Modified.......:
; Remarks .......:
; Related .......: _Array2D_Swap, _Array2D_Reverse
; Link ..........;
; Example .......; Yes
; ===============================================================================================================================
Func _Array2D_SwapByIndex(ByRef $avArray, $iItem1, $iItem2, $iDim = 1)
	If $iDim = Default Then $iDim = 1

	If Not IsArray($avArray) Then Return SetError(1, 0, 0)

	Switch UBound($avArray, 0)
		Case 1
			_Array2D_Swap($avArray [$iItem1], $avArray [$iItem2])
		Case 2
			Local $i
			Switch $iDim
				Case 1
					For $i = 0 To UBound($avArray, 2) - 1
						_Array2D_Swap($avArray [$iItem1][$i], $avArray [$iItem2][$i])
					Next
				Case 2
					For $i = 0 To UBound($avArray) - 1
						_Array2D_Swap($avArray [$i][$iItem1], $avArray [$i][$iItem2])
					Next
				Case Else
					Return SetError(3, 0, 0)
			EndSwitch
		Case Else
			Return SetError(2, 0, 0)
	EndSwitch

	Return SetError(0, 0, 1)
EndFunc   ;==>_Array2D_SwapByIndex

; #FUNCTION# ====================================================================================================================
; Name...........: _Array2D_ToClip
; Description ...: Sends the contents of an array to the clipboard
; Syntax.........: _Array2D_ToClip(Const ByRef $avArray[, $sDelim = @CR[, $iStart = 0[, $iEnd = -1[, $iDim = 1[, $sSubDelim = @TAB[, $iSubStart = 0[, $iSubEnd = -1]]]]]]])
; Parameters ....: $avArray   - Array to copy to clipboard
;                  $sDelim    - [optional] Delimiter for copied string. Default : @CR
;                  $iStart    - [optional] Index of array to start copying at. Default : 0
;                  $iEnd      - [optional] Index of array to stop copying at. Default : end of the array
;                  $iDim      - [optional] The main dimension. Default : 1
;                  $sSubDelim - [optional] Delimiter for copied string in secondary dimension. Default : @TAB
;                  $iSubStart - [optional] Index of array to start copying at in secondary dimension. Default : 0
;                  $iSubEnd   - [optional] Index of array to stop copying at in secondary dimension. Default : end of the array
; Return values .: Success - 1
;                  Failure - 0, sets @error to :
;                  |-1 - ClipPut() failed
;                  |1  - $avArray is not an array
;                  |2  - $avArray has more than 2 dimensions
;                  |3  - $iDim is not equal to 1 or 2
;                  |4  - $iStart is greater than $iEnd (@extended = 1) OR $iSubStart is greater than $iSubEnd (@extended = 2)
; Author ........: Cephas <cephas at clergy dot net>
; Modified.......: Jos van der Zande <jdeb at autoitscript dot com> - added $iStart parameter and logic
;                  Ultima - added $iEnd parameter, make use of _ArrayToString() instead of duplicating efforts
;                  Tolf - Updated 2D, added $sDelim parameter, "Default" value supported
; Remarks .......: WARNING : Parameters order has been changed :
;                  |$sDelim insered between $avArray and $iStart
;                  WARNING : Errors codes have been changed :
;                  |2 => 4
;                  |2 added
;                  |3 added
; Related .......: _Array2D_ToConsole, _ArrayToString
; Link ..........;
; Example .......; Yes
; ===============================================================================================================================
Func _Array2D_ToClip(Const ByRef $avArray, $sDelim = @CR, $iStart = 0, $iEnd = -1, $iDim = 1, $sSubDelim = @TAB, $iSubStart = 0, $iSubEnd = -1)
	If $sDelim = Default Then $sDelim = @CR
	If $iStart = Default Then $iStart = 0
	If $iEnd = Default Then $iEnd = -1
	If $iDim = Default Then $iDim = 1
	If $sSubDelim = Default Then $sSubDelim = @TAB
	If $iSubStart = Default Then $iSubStart = 0
	If $iSubEnd = Default Then $iSubEnd = -1

	Local $sText

	$sText = _Array2D_ToString($avArray, $sDelim, $iStart, $iEnd, $iDim, $sSubDelim, $iSubStart, $iSubEnd)
	If @error <> 0 Then Return SetError(@error, @extended, 0)

	Return SetError(ClipPut($sText) - 1, 0, 1)
EndFunc   ;==>_Array2D_ToClip

; #FUNCTION# ====================================================================================================================
; Name...........: _Array2D_ToConsole
; Description ...: Write the contents of an array on the console.
; Syntax.........: _Array2D_ToConsole(Const ByRef $avArray[, $sDelim = @CR[, $iStart = 0[, $iEnd = -1[, $iDim = 1[, $sSubDelim = @TAB[, $iStart_secondary_dim = 0[, $iEnd_secondary_dim = 0]]]]]]])
; Parameters ....: $avArray   - The array to write on console
;                  $sDelim    - [optional] Delimiter for combined string. Default : "|"
;                  $iStart    - [optional] Index of array to start combining at. Default : 0
;                  $iEnd      - [optional] Index of array to stop combining at. Default : end of the array
;                  $iDim      - [optional] The main dimension. Default : 1
;                  $sSubDelim - [optional] Delimiter for combined string in secondary dimension. Default : ""
;                  $iSubStart - [optional] Index of array to start combining at in secondary dimension. Default : 0
;                  $iSubEnd   - [optional] Index of array to stop combining at in secondary dimension. Default : end of the array
; Return values .: Success - 1
;                  Failure - 0, sets @error to :
;                  |1 - $avArray is not an array
;                  |2 - $avArray has more than 2 dimensions
;                  |3 - $iDim is not equal to 1 or 2
;                  |4 - $iStart is greater than $iEnd (@extended = 1) OR $iSubStart is greater than $iSubEnd (@extended = 2)
; Author ........: Tolf
; Modified.......:
; Remarks .......:
; Related .......: _Array2D_ToString, _Array2D_ToClip, _Array2D_Display
; Link ..........;
; Example .......; Yes
; ===============================================================================================================================
Func _Array2D_ToConsole(Const ByRef $avArray, $sDelim = @LF, $iStart = 0, $iEnd = -1, $iDim = 1, $sSubDelim = @TAB, $iSubStart = 0, $iSubEnd = -1)
	If $sDelim = Default Then $sDelim = @LF
	If $iStart = Default Then $iStart = 0
	If $iEnd = Default Then $iEnd = -1
	If $iDim = Default Then $iDim = 1
	If $sSubDelim = Default Then $sSubDelim = @TAB
	If $iSubStart = Default Then $iSubStart = 0
	If $iSubEnd = Default Then $iSubEnd = -1

	Local $sText

	$sText = _Array2D_ToString($avArray, $sDelim, $iStart, $iEnd, $iDim, $sSubDelim, $iSubStart, $iSubEnd)
	If @error <> 0 Then Return SetError(@error, @extended, 0)
	ConsoleWrite($sText)

	Return SetError(0, 0, 1)
EndFunc   ;==>_Array2D_ToConsole

; #FUNCTION# ====================================================================================================================
; Name...........: _Array2D_ToString
; Description ...: Places the elements of a 2d-array into a single string, separated by the specified delimiters.
; Syntax.........: _Array2D_ToString(Const ByRef $avArray[, $sDelim = "|"[, $iStart = 0[, $iEnd = -1[, $iDim = 1[, $sSubDelim = ""[, $iSubStart = 0[, $iSubEnd = -1]]]]]]])
; Parameters ....: $avArray   - Array to combine
;                  $sDelim    - [optional] Delimiter for combined string. Default : "|"
;                  $iStart    - [optional] Index of array to start combining at. Default : 0
;                  $iEnd      - [optional] Index of array to stop combining at. Default : end of the array
;                  $iDim      - [optional] The main dimension. Default : 1
;                  $sSubDelim - [optional] Delimiter for combined string in secondary dimension. Default : ""
;                  $iSubStart - [optional] Index of array to start combining at in secondary dimension. Default : 0
;                  $iSubEnd   - [optional] Index of array to stop combining at in secondary dimension. Default : end of the array
; Return values .: Success - 1
;                  Failure - 0, sets @error to :
;                  |1 - $avArray is not an array
;                  |2 - $avArray has more than 2 dimensions
;                  |3 - $iDim is not equal to 1 or 2
;                  |4 - $iStart is greater than $iEnd(@extended = 1) OR $iSubStart is greater than $iSubEnd(@extended = 2)
; Author ........: Brian Keene <brian_keene at yahoo dot com>
;                  Valik - rewritten
; Modified.......: Ultima - code cleanup
;                  Tolf - Updated 2D, "Default" value supported
; Remarks .......: WARNING : Errors codes have been changed :
;                  |2 => 4
;                  |2 added
;                  |3 added
; Related .......: StringSplit, _Array2D_FromString, _Array2D_ToClip, _Array2D_ToConsole
; Link ..........;
; Example .......; Yes
; ===============================================================================================================================
Func _Array2D_ToString(Const ByRef $avArray, $sDelim = "|", $iStart = 0, $iEnd = -1, $iDim = 1, $sSubDelim = "", $iSubStart = 0, $iSubEnd = -1)
	If $sDelim = Default Then $sDelim = "|"
	If $iStart = Default Then $iStart = 0
	If $iEnd = Default Then $iEnd = -1
	If $iDim = Default Then $iDim = 1
	If $sSubDelim = Default Then $sSubDelim = ""
	If $iSubStart = Default Then $iSubStart = 0
	If $iSubEnd = Default Then $iSubEnd = -1

	; Validate the array
	If Not IsArray($avArray) Then Return SetError(1, 0, 0)

	Local $sResult, $iUbound, $i
	Switch UBound($avArray, 0)
		Case 1
			$iUbound = UBound($avArray) - 1
			If $iStart < 0 Then $iStart = 0
			If $iEnd < 0 Or $iEnd > $iUbound Then $iEnd = $iUbound
			If $iStart > $iEnd Then Return SetError(4, 1, 0)
			For $i = $iStart To $iEnd
				$sResult &= $avArray [$i] & $sDelim
			Next
		Case 2
			$iUbound = UBound($avArray, $iDim)
			Local $iUbound2 = UBound($avArray, Mod($iDim, 2) + 1), $j
			If $iStart < 0 Then $iStart = 0
			If $iEnd < 0 Or $iEnd > $iUbound - 1 Then $iEnd = $iUbound - 1
			If $iSubStart < 0 Then $iSubStart = 0
			If $iSubEnd < 0 Or $iSubEnd > $iUbound2 - 1 Then $iSubEnd = $iUbound2 - 1
			If $iStart > $iEnd Then Return SetError(4, 1, 0)
			If $iSubStart > $iSubEnd Then Return SetError(4, 2, 0)
			; Combine the elements into the string.
			Switch $iDim
				Case 1
					For $i = $iStart To $iEnd
						For $j = $iSubStart To $iSubEnd
							$sResult &= $avArray [$i][$j] & $sSubDelim
						Next
						$sResult = StringTrimRight($sResult, StringLen($sSubDelim))
						$sResult &= $sDelim
					Next
				Case 2
					For $j = $iStart To $iEnd
						For $i = $iSubStart To $iSubEnd
							$sResult &= $avArray [$i][$j] & $sSubDelim
						Next
						$sResult = StringTrimRight($sResult, StringLen($sSubDelim))
						$sResult &= $sDelim
					Next
				Case Else
					Return SetError(3, 0, 0)
			EndSwitch
		Case Else
			Return SetError(2, 0, 0)
	EndSwitch

	Return SetError(0, 0, StringTrimRight($sResult, StringLen($sDelim)))
EndFunc   ;==>_Array2D_ToString

; #FUNCTION# ====================================================================================================================
; Name...........: _Array2D_Transpose
; Description ...: Transposes dimensions in a 2-dimensional array.
; Syntax.........: _Array2D_Transpose(ByRef $avArray)
; Parameters ....: $avArray - Array to transpose
; Return values .: Success - 1
;                  Failure - 0, sets @error:
;                  |1 - $avArray is not an array
;                  |2 - $avArray has not 2 dimensions
; Author ........: Tolf
; Modified.......:
; Remarks .......:
; Related .......: _Array2D_Reverse
; Link ..........;
; Example .......; Yes
; ===============================================================================================================================
Func _Array2D_Transpose(ByRef $avArray)
	If Not IsArray($avArray) Then Return SetError(1, 0, 0)
	If Not UBound($avArray, 0) = 2 Then Return SetError(2, 0, 0)

	Local $avTransposedArray [UBound($avArray, 2) ][UBound($avArray) ], $i, $j
	For $i = 0 To UBound($avArray) - 1
		For $j = 0 To UBound($avArray, 2) - 1
			$avTransposedArray [$j][$i] = $avArray [$i][$j]
		Next
	Next
	$avArray = $avTransposedArray

	Return SetError(0, 0, 1)
EndFunc   ;==>_Array2D_Transpose

; #NO_DOC_FUNCTION# =============================================================================================================
; Name...........: _Array2D_Trim
; Description ...: Trims a certain number of characters from all elements in an array.
; Syntax.........: _Array2D_Trim(ByRef $avArray, $iTrimNum[, $iDirection = 0[, $iStart = 0[, $iEnd = 0]]])
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
;                  |5 - $iStart is greater than $iEnd
;                  |(2-4 - Deprecated error codes)
; Author ........: Adam Moore (redndahead)
; Modified.......: Ultima - code cleanup, optimization
; Remarks .......: Use _Array2D_StringOperation instead of _Array2D_Trim
; Related .......:
; Link ..........;
; Example .......; Yes
; ===============================================================================================================================
Func _Array2D_Trim(ByRef $avArray, $iTrimNum, $iDirection = 0, $iStart = 0, $iEnd = 0)
	If Not IsArray($avArray) Then Return SetError(1, 0, 0)

	Local $iUbound = UBound($avArray) - 1

	; Bounds checking
	If $iEnd < 1 Or $iEnd > $iUbound Then $iEnd = $iUbound
	If $iStart < 0 Then $iStart = 0
	If $iStart > $iEnd Then Return SetError(5, 0, 0)

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

	Return SetError(0, 0, 1)
EndFunc   ;==>_Array2D_Trim

; #INTERNAL_USE_ONLY#============================================================================================================
Func __Max($nNum1, $nNum2)
	If $nNum1 > $nNum2 Then Return $nNum1
	Return $nNum2
EndFunc   ;==>__Max

; #INTERNAL_USE_ONLY#============================================================================================================
Func __Min($nNum1, $nNum2)
	If $nNum1 < $nNum2 Then Return $nNum1
	Return $nNum2
EndFunc   ;==>__Min

; #INTERNAL_USE_ONLY#============================================================================================================
; Name...........: __Array2D_GetValue
; Description ...: Function which split a value according to the delimiter string set by _Array2D_SetDelim
; Syntax.........: __Array2D_GetValue($vValue)
; Parameters ....: $vValue - The value to get
; Return values .: Value eventually splited
; Author ........: Tolf
; Modified.......:
; Remarks .......: For Internal Use Only
; Related .......:
; Link ..........;
; Example .......;
; ===============================================================================================================================
Func __Array2D_GetValue($vValue)
	If IsString($vValue) And $ARRAY2D_DELIM_STRING <> "" And $vValue <> "" Then Return StringSplit ($vValue, $ARRAY2D_DELIM_STRING, $ARRAY2D_DELIM_FLAG)
	Return $vValue
EndFunc   ;==>__Array2D_GetValue