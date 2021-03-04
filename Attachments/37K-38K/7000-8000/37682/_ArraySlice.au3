#include-once
#AutoIt3Wrapper_Au3Check_Parameters=-q -d -w 1 -w 2 -w 3 -w- 4 -w 5 -w 6 -w- 7
; #FUNCTION# ====================================================================================================================
; Name...........: _ArraySlice
; Description ...: Returns the specified elements as a zero based array.
; Syntax.........: _ArraySlice(Const ByRef $avArray[, $iStart = 0[, $iEnd = 0[, $iStep = 1]]])
; Parameters ....: $avArray - Array to Slice
;                  $iStart  - [optional] Index of array to start slicing
;                  $iEnd    - [optional] Index of array to stop slicing
;                  $iStep    - [optional] Increment can be negative
; Return values .: Success - Array containing the specified portion or slices of the original.
;                  Failure - "", sets @error:
;                  |1 - $avArray is not an array
;                  |2 - $iStart is greater than $iEnd when increment is positive
;                  |3 - $avArray is not an 1 dimensional array
;                  |4 - $iStep is greater than the array
; Author ........: Decipher
; Modified.......:
; Remarks .......:
; Related .......: StringSplit, _ArrayToClip, _ArrayToString
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================

#include <Array.au3>

Example()

Func Example()
   Local $MyArray[10]
   $MyArray[0] = 9
   $MyArray[1] = "One"
   $MyArray[2] = "Two"
   $MyArray[3] = "Three"
   $MyArray[4] = "Four"
   $MyArray[5] = "Five"
   $MyArray[6] = "Six"
   $MyArray[7] = "Seven"
   $MyArray[8] = "Eight"
   $MyArray[9] = "Nine"

   Local $MyNewArray = _ArraySlice($MyArray, 9, 0, -2)

  _ArrayDisplay($MyNewArray)

   $MyNewArray = _ArraySlice($MyArray, 1)

  _ArrayDisplay($MyNewArray)

   $MyNewArray = _ArraySlice($MyArray, 1, 5)

  _ArrayDisplay($MyNewArray)

   $MyNewArray = _ArraySlice($MyArray, 5, 0)

  _ArrayDisplay($MyNewArray)

   $MyNewArray = _ArraySlice($MyArray, 1, 3, 1)

  _ArrayDisplay($MyNewArray)
EndFunc   ;==>Example

Func _ArraySlice(Const ByRef $avArray, $iStart = 0, $iEnd = 0, $iStep = 1)
   If Not IsArray($avArray) Then Return SetError(1, 0, 0)
   If UBound($avArray, 0) <> 1 Then Return SetError(3, 0, "")

   Local $iNew = 0, $iUBound = UBound($avArray) - 1

   ; Bounds checking
   If $iStep > $iUBound Then Return SetError(4, 0, "")
   If $iEnd < 0 Or $iEnd > $iUBound Or $iEnd <= 0 And $iStep > 0 Then $iEnd = $iUBound
   If $iStart < 0 Then $iStart = 0
   If $iStart > $iEnd And $iStep >= 1 Then Return SetError(2, 0, "")

   Local $aNewArray[$iUBound]

   For $i = $iStart To $iEnd Step $iStep ; Create a new zero based array
	  $aNewArray[$iNew] = $avArray[$i]
	  $iNew +=1
   Next

   ReDim $aNewArray[$iNew]

   Return $aNewArray
EndFunc   ;==>_ArraySlice#include <Array.au3>