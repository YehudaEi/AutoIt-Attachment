#include<Array.au3>
#include<ArrayRemoveDuplicates.au3>


; Example # 1 : using Base 0 array
Dim $avArray[10]
$avArray[0] = "JPM"
$avArray[1] = "STRING1"
$avArray[2] = "Jon"
$avArray[3] = "Larry"
$avArray[4] = "Jeremy"
$avArray[5] = "Valik"
$avArray[6] = "String1"		; this element will be deleted from the updated array
$avArray[7] = "String2"
$avArray[8] = "JdeB"
$avArray[9] = "STRING2"		; this element will be deleted from the updated array

_ArrayDisplay($avArray, "Example # 1 : Before")
_ArrayRemoveDuplicates($avArray)
_ArrayDisplay($avArray, "Example # 1 : After")


; Example # 2 : Base 1 array
Dim $avArray[11]
$avArray[0] = 10
$avArray[1] = "JPM"
$avArray[2] = "String1"
$avArray[3] = "Jon"
$avArray[4] = "Split/Split"
$avArray[5] = "Jeremy"
$avArray[6] = "Valik"
$avArray[7] = "String1"		; this element will be deleted from the updated array
$avArray[8] = "String2"
$avArray[9] = "JdeB"
$avArray[10] = "STRING2"	; this element will be deleted from the updated array

_ArrayDisplay($avArray, "Example # 2 : Before")
_ArrayRemoveDuplicates($avArray, 1)
_ArrayDisplay($avArray, "Example # 2 : After")


; Example # 3 : Base 1 array and Case Sensitive
Dim $avArray[11]
$avArray[0] = 10
$avArray[1] = "JPM"
$avArray[2] = "String1"
$avArray[3] = "Jon"
$avArray[4] = "Split/Split"
$avArray[5] = "Jeremy"
$avArray[6] = "Valik"
$avArray[7] = "String1"		; this element will be deleted from the updated array
$avArray[8] = "String2"
$avArray[9] = "JdeB"
$avArray[10] = "STRING2"	; this element will NOT be deleted from the updated array

_ArrayDisplay($avArray, "Example # 3 : Before")
_ArrayRemoveDuplicates($avArray, 1, 1)
_ArrayDisplay($avArray, "Example # 3 : After")


; Example # 4 : Base 1 array, Case Sensitive and using "/" as Delimiter
Dim $avArray[11]
$avArray[0] = 10
$avArray[1] = "JPM"
$avArray[2] = "String1"
$avArray[3] = "Jon"
$avArray[4] = "Split/Split"	; this element will become 2 elements in the updated array
$avArray[5] = "Jeremy"
$avArray[6] = "Valik"
$avArray[7] = "String1"		; this element will be deleted from the updated array
$avArray[8] = "String2"
$avArray[9] = "JdeB"
$avArray[10] = "STRING2"	; this element will NOT be deleted from the updated array

_ArrayDisplay($avArray, "Example # 4 : Before")
_ArrayRemoveDuplicates($avArray, 1, 1, "/")
_ArrayDisplay($avArray, "Example # 4 : After")
