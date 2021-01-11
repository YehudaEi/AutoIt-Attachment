;===============================================================================
;
; Description:      Finds an entry within a single or multi-dimensional array. (Similar to _ArrayBinarySearch() except the array does not need to be sorted and it includes multi-dimensional array support and more advanced search features)
; Syntax:           _ArraySearch($avArray, $vWhat2Find, $iStart = 0, $iEnd = 0,$iCaseSense=0,$sDimString )
;
; Parameter(s):      $avArray               = The array to search
;                    $vWhat2Find            = What to search $avArray for
;                    $iStart (Optional)     = Start array index for search, normally set to 0 or 1. If omitted it is set to 0
;                    $iEnd  (Optional)      = End array index for search. If omitted or set to 0 it is set to Ubound($AvArray)-1
;               	 $iCaseSense (Optional) = If set to 1 then search is case sensitive
;                	 $iFlag (Optional)      = How to match the search string.
;					 $sDimString            = A speically formated string that allows multidimensional seacrhing 
;                  Possible Values:
;                    0 - (Default) Exact match
;                    1 - match at beginning of element
;                    2 - match at end of element
;                    3 - anywhere in element
;                    4 - Regular Expression (if used, $iCaseSense is ignored)
; Requirement(s):   None
;
; Return Value(s):  On Success - Returns the position of an item in an array.
;                   On Failure - Returns an -1 if $vWhat2Find is not found
;                   @Error=1 $avArray is not an array
;                   @Error=2 $iStart is greater than UBound($AvArray)-1
;                   @Error=3 $iEnd is greater than UBound($AvArray)-1
;                   @Error=4 $iStart is greater than $iEnd
;                   @Error=5 $iCaseSense was invalid. (Must be 0 or 1)
;                   @Error=6 $vWhat2Find was not found in $avArray
;                   @Error=7 Invalid $iFlag parameter
;					@Error=8 Invalid $sDimString
;
; Author(s):        SolidSnake <metalgx91 at gmail dot com>
;					TheGuy0000 <theguy0000 at gmail dot com>
; Note(s):          This might be slower than _ArrayBinarySearch() but is useful when the array's order can't be altered and or you need advanced features 
;                   $sDimString should look something like this,"[0][X]","X" is used to tell the function to search thorugh the array at that dimension.
;===============================================================================
Func _ArraySearchPlus(Const ByRef $avArray, $vWhat2Find, $iStart = 0, $iEnd = 0, $iCaseSense = 0, $iFlag = 0,$sDimString = "[x]")
	Local $iCurrentPos, $iUBound
	$iLen = StringLen($sDimString)
	If $sDimString <> "[x]" Then
		If Not IsInt($iLen / 3) Then
			SetError(8)
			Return -1
		EndIf
		For $iCounter = 1 To $iLen Step 3
			$sPart = StringMid($sDimString, $iCounter, 3)
			If StringMid($sPart, 1, 1) <> "[" Then
				SetError(8)
				Return -1
			EndIf
			If Not (StringMid($sPart, 2, 1) = "x" Or StringIsInt(StringMid($sPart, 2, 1))) Then
				SetError(8)
				Return -1
			EndIf
			If StringMid($sPart, 3, 1) <> "]" Then
				SetError(8)
				Return -1
			EndIf
			StringReplace($sDimString, "x", "")
			If @extended <> 1 Then
				SetError(8)
				Return -1
			EndIf
			$iPos = StringInStr($sDimString, "x")
			$iSub= ($iPos + 1) / 3
		Next
	EndIf
	If Not IsArray($avArray) Then
		SetError(1)
		Return -1
	EndIf
	$iUBound = UBound($avArray) - 1
	If $iEnd = 0 Then $iEnd = $iUBound
	If $iStart > $iUBound Then
		SetError(2)
		Return -1
	EndIf
	If $iEnd > $iUBound Then
		SetError(3)
		Return -1
	EndIf
	If $iStart > $iEnd Then
		SetError(4)
		Return -1
	EndIf
	If Not ($iCaseSense = 0 Or $iCaseSense = 1) Then
		SetError(5)
		Return -1
	EndIf
	If $iFlag < 0 Or $iFlag > 4 Then
		SetError (7)
		Return -1
	EndIf
	For $iCurrentPos = $iStart To $iEnd
		$sDimString2 = StringReplace($sDimString, "x", $iCurrentPos)
		Select
			Case $iCaseSense = 0
				Switch $iFlag
					Case 0
						If Execute("$avArray" & $sDimString2) = $vWhat2Find Then
							SetError(0)
							Return $iCurrentPos
						EndIf
					Case 1
						If StringLeft (Execute("$avArray" & $sDimString2), StringLen($vWhat2Find)) = $vWhat2Find Then
							SetError (0)
							Return $iCurrentPos
						EndIf
					Case 2
						If StringRight (Execute("$avArray" & $sDimString2), StringLen($vWhat2Find)) = $vWhat2Find Then
							SetError (0)
							Return $iCurrentPos
						EndIf
					Case 3
						If StringInStr (Execute("$avArray" & $sDimString2), $vWhat2Find) Then
							SetError (0)
							Return $iCurrentPos
						EndIf
					Case 4
						If StringRegExp (Execute("$avArray" & $sDimString2), $vWhat2Find) Then
							SetError (0)
							Return $iCurrentPos
						EndIf
				EndSwitch
			Case $iCaseSense = 1
				Switch $iFlag
					Case 0
						If $avArray[$iCurrentPos] == $vWhat2Find Then
							SetError(0)
							Return $iCurrentPos
						EndIf
					Case 1
						If StringLeft (Execute("$avArray" & $sDimString2), StringLen($vWhat2Find)) == $vWhat2Find Then
							SetError (0)
							Return $iCurrentPos
						EndIf
					Case 2
						If StringRight (Execute("$avArray" & $sDimString2), StringLen($vWhat2Find)) == $vWhat2Find Then
							SetError (0)
							Return $iCurrentPos
						EndIf
					Case 3
						If StringInStr (Execute("$avArray" & $sDimString2), $vWhat2Find, 1) Then
							SetError (0)
							Return $iCurrentPos
						EndIf
					Case 4
						If StringRegExp (Execute("$avArray" & $sDimString2), $vWhat2Find) Then
							SetError (0)
							Return $iCurrentPos
						EndIf
				EndSwitch
		EndSelect
	Next
	SetError(6)
	Return -1
EndFunc   ;==>_ArraySearch