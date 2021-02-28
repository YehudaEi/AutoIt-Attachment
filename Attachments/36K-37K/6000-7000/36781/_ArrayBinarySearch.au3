; 2/5/11 This is the example for _ArrayBinarySearch with examples added for my additional features.  Remove the include of myarray.au3 and change "MyArrayBinarySearch to _ArrayBinarySearch and it should work if my binary search were substituted for the regular _ArrayBinarySearch.
#include <Array.au3>
#Include "MyArray.au3"

;===============================================================================
; Example 1 (using a manually-defined array)
;===============================================================================
Local $avArray[10]

$avArray[0] = "JPM"
$avArray[1] = "Holger"
$avArray[2] = "Jon"
$avArray[3] = "Larry"
$avArray[4] = "Jeremy"
$avArray[5] = "Valik"
$avArray[6] = "Cyberslug"
$avArray[7] = "Nutster"
$avArray[8] = "JdeB"
$avArray[9] = "Tylo"

; sort the array to be able to do a binary search
_ArraySort($avArray)

; display sorted array
_ArrayDisplay($avArray, "$avArray AFTER _ArraySort()")

; lookup existing entry
$iKeyIndex = MyArrayBinarySearch($avArray, "Jon")
If Not @error Then
   MsgBox(0,'Entry found',' Index: ' & $iKeyIndex)
Else
   MsgBox(0,'Entry Not found',' Error: ' & @error)
EndIf

; lookup non-existing entry
$iKeyIndex = MyArrayBinarySearch($avArray, "Unknown")
If Not @error Then
   MsgBox(0,'Entry found',' Index: ' & $iKeyIndex)
Else
   MsgBox(0,'Entry Not found',' Error: ' & @error)
EndIf


;===============================================================================
; Example 2 (using an array returned by StringSplit())
;===============================================================================
$avArray = StringSplit("a,b,d,c,e,f,g,h,i", ",")

; sort the array to be able to do a binary search
_ArraySort($avArray, 0, 1) ; start at index 1 to skip $avArray[0]

; display sorted array
_ArrayDisplay($avArray, "$avArray AFTER _ArraySort()")

 ; start at index 1 to skip $avArray[0]
$iKeyIndex = MyArrayBinarySearch($avArray, "c", 1)
If Not @error Then
   Msgbox(0,'Entry found',' Index: ' & $iKeyIndex)
Else
   Msgbox(0,'Entry Not found',' Error: ' & @error)
EndIf

;===============================================================================
; Example 3 (Example 1 but with $fReturnMid)
;===============================================================================
Local $avArray[10]

$avArray[0] = "JPM"
$avArray[1] = "Holger"
$avArray[2] = "Jon"
$avArray[3] = "Larry"
$avArray[4] = "Jeremy"
$avArray[5] = "Valik"
$avArray[6] = "Cyberslug"
$avArray[7] = "Nutster"
$avArray[8] = "JdeB"
$avArray[9] = "Tylo"

; sort the array to be able to do a binary search
_ArraySort($avArray)

; display sorted array
_ArrayDisplay($avArray, "$avArray AFTER _ArraySort()")

; lookup non-existing entry and get index where it should be inserted
$iKeyIndex = MyArrayBinarySearch($avArray, "Unknown", 0, 0, True)
If Not @error Then
   MsgBox(0,'Entry found',' Index: ' & $iKeyIndex)
Else
   MsgBox(0,'Entry Not found',' Error: ' & @error & ", insert at " & $iKeyIndex)
EndIf

;===============================================================================
; Example 4 (Example 3 but with 2 dimensions)
;===============================================================================
Local $avArray[10][2] = [ _ 
[1, "JPM"], _ 
[2, "Holger"], _ 
[3, "Jon"], _ 
[4, "Larry"], _ 
[5, "Jeremy"], _ 
[6, "Valik"], _ 
[7, "Cyberslug"], _ 
[8, "Nutster"], _ 
[9, "JdeB"], _ 
[10, "Tylo"] _ 
]

; sort the array to be able to do a binary search
_ArraySort($avArray, 0, 0, 0, 1) ; sort 2nd column

; display sorted array
_ArrayDisplay($avArray, "$avArray AFTER _ArraySort()")

; lookup non-existing entry and get index where it should be inserted
$iKeyIndex = MyArrayBinarySearch($avArray, "Unknown", 0, 0, True, 1)
If Not @error Then
   MsgBox(0,'Entry found',' Index: ' & $iKeyIndex)
Else
   MsgBox(0,'Entry Not found',' Error: ' & @error & ", insert at " & $iKeyIndex)
EndIf



