;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;                           Array specific functions
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;===============================================================================
; Fonction:      _ArrayExchangeValues
; Author:        LazyCoder
; Description:   Additional function to exchange to values inside an array
; Parameters:    $aArray       - The array to work on
;					  $iSource      - The first value position
;					  $iDestination - The second value position
;					  $iDimension   - The array dimesion (1 or 2 by now...)
;					  $iNbElems     - Nb elements in the 2nd dimension
; Requirements:  Any parameter check must have been done by the calling function
; Return Values: None
;
; Note:          The array is passed ByRef
;===============================================================================
Func _ArrayExchangeValues(ByRef $aWorkArray, $iSource, $iDest, $iDimension = 1, $iNbElems = 0)
   Local $vBuffer
   ; BEWARE: No check here, it's designed to be a inner function
   If ($iSource == $iDest) Then Return
   If ($iDimension == 1) Then
      $vBuffer = $aWorkArray[$iSource]
      $aWorkArray[$iSource] = $aWorkArray[$iDest]
      $aWorkArray[$iDest] = $vBuffer
   Else
      Local $iIndex
      For $iIndex = 0 To $iNbElems - 1
         $vBuffer = $aWorkArray[$iSource][$iIndex]
         $aWorkArray[$iSource][$iIndex] = $aWorkArray[$iDest][$iIndex]
         $aWorkArray[$iDest][$iIndex] = $vBuffer
      Next
   EndIf
   Return
EndFunc   ;==>_ArrayExchangeValues

;===============================================================================
;
; Function Name:    _ArrayShellSort()
; Description:      Sort a multi dimentional Array on a specific index using
;                   the shell sort algorithm
; Parameter(s):     $a_Array      - Array
;                   $i_Descending - Sort Descending when 1
;                   $i_Base       - Start sorting at this Array entry.
;                   $I_Ubound     - End sorting at this Array entry
;                   $i_SortIndex  - The Index to consider (for multi-dimensional
;                                   arrays only)
; Requirement(s):   None
; Return Value(s):  On Success - 1 and the sorted array is set
;                   On Failure - 0 and sets @ERROR = 1
; Author(s):        Jos van der Zande <jdeb@autoitscript.com>
;						  Modified by LazyCoder
;
;===============================================================================
;
Func _ArrayShellSort(ByRef $a_Array, $i_Decending = 0, $i_Base = 0, $i_Ubound = 0, $i_SortIndex = 0)
   Local $A_Size, $Gap, $Count, $Temp
   Local $b_ExchangeValues = 0
   Local $IsChanged = 0
   Local $i_NbElem = UBound($a_Array)
   Local $i_Dim = UBound($a_Array, 0)
   Local $i_NbSubElems = 0
   
   If $i_NbElem < $i_Ubound Or Not IsNumber($i_Ubound) Then
      SetError(1)
      Return 0
   EndIf
   ; Set to ubound when not specified
   If $i_Ubound < 1 Then $i_Ubound = $i_NbElem - 1
   If ($i_Dim == 2) Then $i_NbSubElems = UBound($a_Array, 2)
   ; Shell sort array
   $A_Size = $i_Ubound
   $b_ExchangeValues = 0
   $IsChanged = 0
   
   $Gap = 0
   While ($Gap < $A_Size)
      $Gap = 3 * $Gap + 1
   Wend
   $Gap = Int($Gap / 3)
   
   ;
   While $Gap <> 0
      $IsChanged = 0
      For $Count = $i_Base To ($A_Size - $Gap)
         $b_ExchangeValues = 0
         If $i_Dim = 1 Then
            If $i_Decending <> 1 Then ; sort array Ascending
               If $a_Array[$Count] > $a_Array[$Count + $Gap] Then
                  $b_ExchangeValues = 1
               EndIf
            Else   ; sort array Descending
               If $a_Array[$Count] < $a_Array[$Count + $Gap] Then
                  $b_ExchangeValues = 1
               EndIf
            EndIf
         Else
            If $i_Decending <> 1 Then ; sort array Ascending
               If $a_Array[$Count][$i_SortIndex] > $a_Array[$Count + $Gap][$i_SortIndex] Then
                  $b_ExchangeValues = 1
               EndIf
            Else   ; sort array Descending
               If $a_Array[$Count][$i_SortIndex] < $a_Array[$Count + $Gap][$i_SortIndex] Then
                  $b_ExchangeValues = 1
               EndIf
            EndIf
         EndIf
         If ($b_ExchangeValues) Then
            _ArrayExchangeValues($a_Array, $Count, ($Count + $Gap), $i_Dim, $i_NbSubElems)
            $IsChanged = 1
         EndIf
      Next
      ; If no changes were made to array, decrease $gap size
      If (Not $IsChanged) Then
         $Gap = Int($Gap / 3)
      EndIf
   Wend
   Return 1
EndFunc   ;==>_ArrayShellSort

;===============================================================================
; Fonction:      _ArrayInsertSort
; Author:        LazyCoder
; Description:   "Insert sort" algorithm implementation to sort
;					  a multi-dimensional array
; Parameters:    $aArray - The array to sort
;					  $iCriteriumPosition - The position in sub-list (for 2D arrays)
;													of the sort criterium element
; Requirements:  The array is used ByRef
; Return Values: None
;
; Note:          None
;===============================================================================
Func _ArrayInsertSort(ByRef $aArray, $iCriteriumPosition = 0)
	; TODO: Check IsArray, its dimension, $iCriteriumPosition limits
	;       + Error management...
	Local $iDimension = UBound($aArray, 0)
	Local $iNbEntries = UBound($aArray)
	Local $iNbSubEntries = 0

	If ($iDimension == 2) Then $iNbSubEntries = UBound($aArray, 2)
    _ArrayInsertSortCore($aArray, 0, ($iNbEntries -1), $iDimension, $iNbSubEntries, $iCriteriumPosition)

   Return
EndFunc   ;==>_ArrayInsertSort 

;===============================================================================
; Fonction:      _ArrayInsertSortCore
; Author:        LazyCoder
; Description:   Insert Sort algorithm core mechanism
; Parameters:    $aArray - The array to sort
;					  $iFirst - First element of the partition
;					  $iLast  - Last element of the partition
;					  $iDim   - Number of dimension of the array (1 or 2 by now...)
;					  $iSize  - Number of element in the 2nd dimension if 2D array
;					  $iPos   - Index of the sort criteirum (2-D array)
; Requirements:  The array is used ByRef
; Return Values: None
;
; Note:          None
;===============================================================================
Func _ArrayInsertSortCore (ByRef $aArray, $iFirst = 0, $iLast = -1, $iDim = 1, $iSize = 0, $iPos = 0)
   Local $iIndex, $jIndex, $vBuffer

   If ($iLast = -1) Then $iLast = UBound($aArray) - 1
	If ($iFirst > $iLast) Then Return ; We should warn user somehow...
   If ($iDim == 1) Then
      For $iIndex = $iFirst + 1 To $iLast
	      $vBuffer = $aArray[$iIndex]
         $jIndex = $iIndex
         While ($aArray[$jIndex - 1] > $vBuffer)
         	_ArrayExchangeValues($aArray, $jIndex - 1, $jIndex, $iDim, $iSize)
            $jIndex = $jIndex - 1
            If ($jIndex <= $iFirst) Then ExitLoop
         Wend
         $aArray[$jIndex] = $vBuffer
      Next
   ElseIf($iDim == 2) Then
      For $iIndex = $iFirst + 1 To $iLast
      	Local $aTmp[$iSize]
			Local $kIndex
      	For $jIndex = 0 To $iSize - 1
      		$aTmp[$jIndex] = $aArray[$iIndex][$jIndex]
      	Next
	      $vBuffer = $aArray[$iIndex][$iPos]
	      
         $jIndex = $iIndex
         While ($aArray[$jIndex - 1][$iPos] > $vBuffer)
         	_ArrayExchangeValues($aArray, $jIndex - 1, $jIndex, $iDim, $iSize)
            $jIndex = $jIndex - 1
            If ($jIndex <= $iFirst) Then ExitLoop
         Wend
         For $kIndex = 0 To $iSize - 1
      		$aArray[$jIndex][$kIndex] = $aTmp[$kIndex]
      	Next
      Next
	EndIf
EndFunc   ;==>_ArrayInsertSort

;===============================================================================
; Fonction:      _ArrayQuickSort
; Author:        LazyCoder
; Description:   "Quick sort" algorithm implementation to sort
;					  a multi-dimensional array
; Parameters:    $aArray - The array to sort
;					  $iCriteriumPosition - The position in sub-list (for 2D arrays)
;													of the sort criterium element
; Requirements:  The array is used ByRef
; Return Values: None
;
; Note:          None
;===============================================================================
Func _ArrayQuickSort(ByRef $aArray, $iCriteriumPosition = 0)
   ; TODO: Check IsArray, its dimension, $iCriteriumPosition limits
   ;       + Error management...
   Local $iDimension = UBound($aArray, 0)
   Local $iNbEntries = UBound($aArray)
   Local $iNbSubEntries = 0
   
   If ($iDimension == 2) Then $iNbSubEntries = UBound($aArray, 2)
   _ArrayQuickSortCore($aArray, 0, ($iNbEntries - 1), $iDimension, $iNbSubEntries, $iCriteriumPosition)
   
   Return
EndFunc   ;==>_ArrayQuickSort

;===============================================================================
; Fonction:      _ArrayQuickSortCore
; Author:        LazyCoder
;					  Anyway, I happened to find the same as Larry... :o)
; Description:   "Quick sort" algorithm core mechanism
; Parameters:    $aArray - The array to sort
;					  $iFirst - First element of the partition
;					  $iLast  - Last element of the partition
;					  $iDim   - Number of dimension of the array (1 or 2 by now...)
;					  $iSize  - Number of element in the 2nd dimension if 2D array
;					  $iPos   - Index of the sort criteirum (2-D array)
; Requirements:  The array is used ByRef
; Return Values: None
;
; Note:          None
;===============================================================================
Func _ArrayQuickSortCore(ByRef $aArray, $iFirst = 0, $iLast = -1, $iDim = 1, $iSize = 0, $iPos = 0)
   Local $vBuffer, $iIndex
   Local $vCandidate

   If ($iLast == -1) Then $iLast = UBound($aArray) - 1
  	If ($iLast <= $iFirst) Then Return

   If ($iLast - $iFirst <= 10) Then
     _ArrayInsertSortCore($aArray, $iFirst, $iLast, $iDim, $iSize, $iPos)
   Else
		Local $iLeft, $iRight
  		$iLeft = $iFirst
		$iRight = $iLast
		If ($iDim == 1) Then
			$vBuffer = $aArray[($iFirst + $iLast) / 2]
	   	Do
				While ($aArray[$iLeft] < $vBuffer)
					$iLeft = $iLeft + 1
				WEnd
				While ($aArray[$iRight] > $vBuffer)
					$iRight = $iRight - 1
				WEnd
				If ($iLeft <= $iRight) Then
					_ArrayExchangeValues($aArray, $iLeft, $iRight, $iDim, $iSize)
					$iLeft = $iLeft + 1
					$iRight = $iRight - 1
				EndIf
			Until ($iLeft > $iRight)
		ElseIf ($iDim == 2) Then
			$vBuffer = $aArray[($iFirst + $iLast) / 2][$iPos]
			Do
				While ($aArray[$iLeft][$iPos] < $vBuffer)
					$iLeft = $iLeft + 1
				WEnd
				While ($aArray[$iRight][$iPos] > $vBuffer)
					$iRight = $iRight - 1
				WEnd
				If ($iLeft <= $iRight) Then
					_ArrayExchangeValues($aArray, $iLeft, $iRight, $iDim, $iSize)
					$iLeft = $iLeft + 1
					$iRight = $iRight - 1
				EndIf
			Until ($iLeft > $iRight)
		EndIf
		_ArrayExchangeValues($aArray, $iLeft, $iLast, $iDim, $iSize)
		If ($iFirst < $iRight) Then _
			_ArrayQuickSortCore($aArray, $iFirst, $iRight, $iDim, $iSize, $iPos)
		If ($iLeft < $iLast) Then _
			_ArrayQuickSortCore($aArray, $iLeft, $iLast, $iDim, $iSize, $iPos)
	EndIf
EndFunc

;===============================================================================
;
; Function Name:  _ArrayReverse()
; Description:    Takes the given array and reverses the order in which the
;                 elements appear in the array.
; Author(s):      Rewritten by LazyCoder
;						For the original version, thanks to:
;							Brian Keene <brian_keene@yahoo.com>
;                  & Jos van der Zande
;===============================================================================
Func _ArrayReverse(ByRef $aArray, $iStart = 0, $iEnd = 0)
   ; No checking: must have been done before!
   Local $iIndex
   Local $iDimension = UBound($aArray, 0)
   Local $iSubElements = 0
   
   If ($iEnd == 0) Then $iEnd = UBound($aArray) - 1
   If ($iDimension == 2) Then $iSubElements = UBound($aArray, 2)

   For $iIndex = 0 To Int( ($iEnd - $iStart) / 2)
      _ArrayExchangeValues($aArray, $iStart + $iIndex, ($iEnd - $iIndex), $iDimension, $iSubElements)
   Next
EndFunc   ;==>_ArrayReverse
