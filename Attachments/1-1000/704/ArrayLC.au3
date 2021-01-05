;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;                           Array specific functions
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

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
Func _ArrayExchangeValues(ByRef $aWorkArray, $iSource, $iDest, $iDimension =1, $iNbElems =0)
   Local $Buffer
   ; BEWARE: No check here, it's designed to be a inner function
   If ($iSource == $iDest) Then Return
   If ($iDimension == 1) Then
      $Buffer = $aWorkArray[$iSource]
      $aWorkArray[$iSource] = $aWorkArray[$iDest]
      $aWorkArray[$iDest] = $Buffer
   Else
      Local $iIndex
      For $iIndex = 0 To $iNbElems - 1
         $Buffer = $aWorkArray[$iSource][$iIndex]
         $aWorkArray[$iSource][$iIndex] = $aWorkArray[$iDest][$iIndex]
         $aWorkArray[$iDest][$iIndex] = $Buffer
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
; Fonction:      _ArrayQuickSort
; Author:        LazyCoder
; Description:   "Quick sort" algorithm implementation to sort
;					  a multi-dimensional array
; Parameters:    $aArray - The array to sort
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
    _ArrayQuickSortInner($aArray, 0, ($iNbEntries -1), $iDimension, $iNbSubEntries, $iCriteriumPosition)

   Return
EndFunc   ;==>_ArrayQuickSort 

;===============================================================================
; Fonction:      _ArrayQuickSortInner
; Author:        LazyCoder
; Description:   "Quick sort" algorithm inner function
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
Func _ArrayQuickSortInner(ByRef $aArray, $iFirst, $iLast, $iDim = 1, $iSize = 0, $iPos = 0)
   Local $iAxis

   If ($iFirst < $iLast) Then
      $iAxis = _ArrayQuickSortCore($aArray, $iFirst, $iLast, $iDim, $iSize, $iPos)
      _ArrayQuickSortInner($aArray, $iFirst, $iAxis -1, $iDim, $iSize, $iPos)
      _ArrayQuickSortInner($aArray, $iAxis +1, $iLast, $iDim, $iSize, $iPos)
   EndIf

   Return
EndFunc   ;==>_ArrayQuickSortInner 

;===============================================================================
; Fonction:      _ArrayQuickSortCore
; Author:        LazyCoder
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
Func _ArrayQuickSortCore(ByRef $aArray, $iFirst, $iLast, $iDim, $iSize, $iPos)
   Local $iPosition, $vBuffer, $iIndex
   Local $vCandidate

   $iPosition = $iFirst
   ; Should be better to choose an other place BUT would have to read
   ; from both ends...
   If ($iDim == 1) Then
	   $vBuffer = $aArray[$iFirst]
	ElseIf ($iDim == 2) Then
		$vBuffer = $aArray[$iFirst][$iPos]
	EndIf
   For $iIndex = $iFirst +1 To $iLast
   	If ($iDim == 1) Then
		   $vCandidate = $aArray[$iIndex]
		ElseIf ($iDim == 2) Then
			$vCandidate = $aArray[$iIndex][$iPos]
		EndIf
      If ($vCandidate < $vBuffer) Then
         $iPosition = $iPosition + 1
         _ArrayExchangeValues($aArray, $iPosition, $iIndex, $iDim, $iSize)
      EndIf
   Next
   _ArrayExchangeValues($aArray, $iPosition, $iFirst, $iDim, $iSize)

   Return $iPosition
EndFunc   ;==>_ArrayQuickSortCore 

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

   For $iIndex = 0 To Int(($iEnd - $iStart)/2)
      _ArrayExchangeValues($aArray, $iStart + $iIndex, ($iEnd - $iIndex), $iDimension, $iSubElements)
   Next
EndFunc   ;==>_ArrayReverse
