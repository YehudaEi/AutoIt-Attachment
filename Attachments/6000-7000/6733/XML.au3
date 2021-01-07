Func _XMLStart ($version = "1.0", $encoding="ISO-8859-1")
	Return '<?xml version="'&$version&'" encoding="'&$encoding&'"?>'&@CRLF
EndFunc

Func XMLGetVersion($s_xml)
	Return __StringParse ($s_xml, '<?xml version="', '"', 1)
EndFunc

Func _XMLSet(ByRef $s_xml, $s_ele, $s_node)
    If _XMLExists($s_xml, $s_ele) Then _XMLDel($s_xml, $s_ele)
    $s_xml = $s_xml & "<" & $s_ele & ">" & $s_node & "</" & $s_ele & ">" & @CRLF
EndFunc

Func _XMLGet($s_xml, $s_ele, $i_occurance=1)
    If not _XMLExists($s_xml, $s_ele) Then
        SetError(1)
        Return ""
    EndIf
    Return __StringParse($s_xml, "<" & $s_ele & ">", "</" & $s_ele & ">", $i_occurance)
EndFunc

Func _XMLDel(ByRef $s_xml, $s_ele)
    If not _XMLExists($s_xml, $s_ele) Then
        SetError(1)
        Return ""
    EndIf
    StringReplace("<" & $s_ele & ">" & _XMLGet($s_xml, $s_ele) & "</" & $s_ele & ">" & @CRLF, "", 0, 1)
EndFunc

Func _XMLExists($s_xml, $s_ele)
    If StringInStr($s_xml, "<" & $s_ele & ">") and StringInStr($s_xml, "</" & $s_ele & ">") Then Return 1
    Return 0
EndFunc

Func _XMLSave($s_xml, $s_file)
    FileWrite($s_file, $s_xml)
    Return not @error
EndFunc

Func _XMLLoad($s_file)
    Return __FileReadAll($s_file)
EndFunc

Func _XMLStartSection(ByRef $s_xml, $s_secname)
    $s_xml = $s_xml & "<" & $s_secname & ">" & @CRLF
EndFunc

Func _XMLEndSection(ByRef $s_xml, $s_secname)
    $s_xml = $s_xml & "</" & $s_secname & ">" & @CRLF
EndFunc

;############################
;#     Helper Functions     #
;############################

Func __FileReadAll($s_file)
    If not FileExists($s_file) Then
        SetError(1)
        Return ""
    EndIf
    Return FileRead($s_file, FileGetSize($s_file))
EndFunc

Func __Test($b_Test, $v_True = 1, $v_False = 0)
    If $b_Test Then Return $v_True
    Return $v_False
EndFunc

Func __StringNumOccur($sStr1, $sStr2)
    For $i = 1 to StringLen($sStr1)
        If not StringInStr($sStr1, $sStr2, 1, $i) Then ExitLoop
    Next
    Return $i-1
EndFunc

Func __StringParse($sz_str, $sz_before, $sz_after, $i_occurance = 0)
    Local $sz_sp1 = StringSplit($sz_str, $sz_before, 1)
    If $i_occurance < 0 or $i_occurance > $sz_sp1[0] Then
        SetError(1)
        Return ""
    EndIf
    Local $sz_sp2
    If $i_occurance = 0 Then
        $sz_sp2 = StringSplit($sz_sp1[$sz_sp1[0]], $sz_after, 1)
    Else
        $sz_sp2 = StringSplit($sz_sp1[$i_occurance + 1], $sz_after, 1)
    EndIf
    Return $sz_sp2[1]
EndFunc  ;==>_StringParse()

Func __StringStripPunct (ByRef $string)
	$string = StringReplace ( $string, ".", "" )
	$string = StringReplace ( $string, "!", "" )
	$string = StringReplace ( $string, "?", "" )
	$string = StringReplace ( $string, ",", "" )
	$string = StringReplace ( $string, ";", "" )
	$string = StringReplace ( $string, ":", "" )
	$string = StringReplace ( $string, "'", "" )
	$string = StringReplace ( $string, '"', "" )
	$string = StringReplace ( $string, "|", "" )
	$string = StringReplace ( $string, "/", "" )
	$string = StringReplace ( $string, "\", "" )
	$string = StringReplace ( $string, "@", "" )
	$string = StringReplace ( $string, "#", "" )
	$string = StringReplace ( $string, "$", "" )
	$string = StringReplace ( $string, "^", "" )
	$string = StringReplace ( $string, "&", "" )
	$string = StringReplace ( $string, "(", "" )
	$string = StringReplace ( $string, ")", "" )
	$string = StringReplace ( $string, "[", "" )
	$string = StringReplace ( $string, "]", "" )
	$string = StringReplace ( $string, "{", "" )
	$string = StringReplace ( $string, "~", "" )
	$string = StringReplace ( $string, "}", "" )
	$string = StringReplace ( $string, "+", "" )
	$string = StringReplace ( $string, "=", "" )
EndFunc


;returns -1 if string not found, -2 if $array is not an array, or -3 if there is more than one wildcard
Func __ArraySearchWithWildcards ($array, $searchstring)
	If Not IsArray ($array) Then Return -2
	$string_split = StringSplit ($searchstring, "*")
	For $i = 0 To UBound ($array) - 1;_ArrayMaxIndex ($array)
		If $string_split[0] = 0 Then
			Return _ArraySearch($array, $searchstring)
		ElseIf $string_split[0] = 1 Then
			If StringInStr ($array[$i], $string_split[1]) Then Return $i
		ElseIf $string_split[0] = 2 Then
			If StringInStr ($array[$i], $string_split[1]) And StringInStr ($array[$i], $string_split[2]) Then
				If StringInStr ($array[$i], $string_split[1]) < StringInStr ($array[$i], $string_split[2]) Then
					Return $i
				EndIf
			EndIf
		Else
			Return -3
		EndIf
	Next
	Return -1
EndFunc

; ------------------------------------------------------------------------------
;
; AutoIt Version: 3.0
; Language:       English
; Description:    Functions that assist with array management.
;
; Apr 28, 2005 - Fixed _ArrayTrim(): $iTrimDirection test.
; ------------------------------------------------------------------------------




;===============================================================================
;
; Function Name:  _ArrayAdd()
; Description:    Adds a specified value at the end of an array, returning the
;                 adjusted array.
; Author(s):      Jos van der Zande <jdeb@autoitscript.com>
;
;===============================================================================
Func _ArrayAdd(ByRef $avArray, $sValue)
	If IsArray($avArray) Then
		ReDim $avArray[UBound($avArray) + 1]
		$avArray[UBound($avArray) - 1] = $sValue
		SetError(0)
		Return 1
	Else
		SetError(1)
		Return 0
	EndIf
EndFunc   ;==>_ArrayAdd


;===============================================================================
;
; Function Name:  _ArrayBinarySearch()
; Description:    Uses the binary search algorithm to search through a
;                 1-dimensional array.
; Author(s):      Jos van der Zande <jdeb@autoitscript.com>
;
;===============================================================================
Func _ArrayBinarySearch(ByRef $avArray, $sKey, $i_Base = 0)
	Local $iLwrLimit = $i_Base
	Local $iUprLimit
	Local $iMidElement
	
	If (Not IsArray($avArray)) Then
		SetError(1)
		Return ""
	EndIf
	$iUprLimit = UBound($avArray) - 1
	If $iUprLimit < 1 then  
		SetError(1)
		Return ""
	EndIf
	$iMidElement = Int( ($iUprLimit + $iLwrLimit) / 2)
	; sKey is smaller than the first entry
	If $avArray[$iLwrLimit] > $sKey Or $avArray[$iUprLimit] < $sKey Then
		SetError(2)
		Return ""
	EndIf
	
	While $iLwrLimit <= $iMidElement And $sKey <> $avArray[$iMidElement]
		If $sKey < $avArray[$iMidElement] Then
			$iUprLimit = $iMidElement - 1
		Else
			$iLwrLimit = $iMidElement + 1
		EndIf
		$iMidElement = Int( ($iUprLimit + $iLwrLimit) / 2)
	WEnd
	If $iLwrLimit > $iUprLimit Then
		; Entry not found
		SetError(3)
		Return ""
	Else
		;Entry found , return the index
		SetError(0)
		Return $iMidElement
	EndIf
EndFunc   ;==>_ArrayBinarySearch

;===============================================================================
;
; Function Name:    _ArrayCreate()
; Description:      Create a small array and quickly assign values.
; Parameter(s):     $v_0  - The first element of the array.
;                   $v_1  - The second element of the array (optional).
;                   ...
;                   $v_20 - The twentyfirst element of the array (optional).
; Requirement(s):   None.
; Return Value(s):  The array with values.
; Author(s):        Dale (Klaatu) Thompson
; Note(s):          None.
;
;===============================================================================
Func _ArrayCreate($v_0, $v_1 = 0, $v_2 = 0, $v_3 = 0, $v_4 = 0, $v_5 = 0, $v_6 = 0, $v_7 = 0, $v_8 = 0, $v_9 = 0, $v_10 = 0, $v_11 = 0, $v_12 = 0, $v_13 = 0, $v_14 = 0, $v_15 = 0, $v_16 = 0, $v_17 = 0, $v_18 = 0, $v_19 = 0, $v_20 = 0)
	
	Local $i_UBound = @NumParams
	Local $av_Array[$i_UBound]
	Local $i_Index

	For $i_Index = 0 To ($i_UBound - 1)
		$av_Array[$i_Index] = Eval("v_" & String($i_Index))
	Next
	Return $av_Array
	; Create fake usage for the variables to suppress Au3Check -w 6
	$v_0 = $v_0 = $v_1 = $v_2 = $v_3 = $v_4 = $v_5 = $v_6 = $v_7 = $v_8 = $v_9 = $v_10
    $v_11 = $v_11 = $v_12 = $v_13 = $v_14 = $v_15 = $v_16 = $v_17 = $v_18 = $v_19 = $v_20
EndFunc   ;==>_ArrayCreate


;===============================================================================
;
; Function Name:  _ArrayDelete()
; Description:    Deletes the specified element from the given array, returning
;                 the adjusted array.
; Author(s)       Cephas <cephas@clergy.net>
; Modifications   Array is passed via Byref  - Jos van der zande
;===============================================================================
Func _ArrayDelete(ByRef $avArray, $iElement)
	Local $iCntr = 0, $iUpper = 0
	
	If (Not IsArray($avArray)) Then
		SetError(1)
		Return ""
	EndIf
	
	; We have to define this here so that we're sure that $avArray is an array
	; before we get it's size.
	$iUpper = UBound($avArray)    ; Size of original array
	
	; If the array is only 1 element in size then we can't delete the 1 element.
	If $iUpper = 1 Then
		SetError(2)
		Return ""
	EndIf
	
	Local $avNewArray[$iUpper - 1]
	If $iElement < 0 Then
		$iElement = 0
	EndIf
	If $iElement > ($iUpper - 1) Then
		$iElement = ($iUpper - 1)
	EndIf
	If $iElement > 0 Then
		For $iCntr = 0 To $iElement - 1
			$avNewArray[$iCntr] = $avArray[$iCntr]
		Next
	EndIf
	If $iElement < ($iUpper - 1) Then
		For $iCntr = ($iElement + 1) To ($iUpper - 1)
			$avNewArray[$iCntr - 1] = $avArray[$iCntr]
		Next
	EndIf
	$avArray = $avNewArray
	SetError(0)
	Return 1
EndFunc   ;==>_ArrayDelete


;===============================================================================
;
; Function Name:  _ArrayDisplay()
; Description:    Displays a 1-dimensional array in a message box.
; Author(s):      Brian Keene <brian_keene@yahoo.com>
;
;===============================================================================
Func _ArrayDisplay(Const ByRef $avArray, $sTitle)
	Local $iCounter = 0, $sMsg = ""
	
	If (Not IsArray($avArray)) Then
		SetError(1)
		Return 0
	EndIf
	
	For $iCounter = 0 To UBound($avArray) - 1
		$sMsg = $sMsg & "[" & $iCounter & "]    = " & StringStripCR($avArray[$iCounter]) & @CR
	Next
	
	MsgBox(4096, $sTitle, $sMsg)
	SetError(0)
	Return 1
EndFunc   ;==>_ArrayDisplay


;===============================================================================
;
; Function Name:  _ArrayInsert()
; Description:    Add a new value at the specified position.
;
; Author(s):      Jos van der Zande <jdeb@autoitscript.com>
;
;===============================================================================
Func _ArrayInsert(ByRef $avArray, $iElement, $sValue = "")
	Local $iCntr = 0
	
	If Not IsArray($avArray) Then
		SetError(1)
		Return 0
	EndIf
	; Add 1 to the Array
	ReDim $avArray[UBound($avArray) + 1]
	; Move all entries one up till the specified Element
	For $iCntr = UBound($avArray) - 1 To $iElement + 1 Step - 1
		$avArray[$iCntr] = $avArray[$iCntr - 1]
	Next
	; add the value in the specified element
	$avArray[$iCntr] = $sValue
	Return 1
EndFunc   ;==>_ArrayInsert


;===============================================================================
;
; Function Name:  _ArrayMax()
; Description:    Returns the highest value held in an array.
; Author(s):      Cephas <cephas@clergy.net>
;
;                 Jos van der Zande
; Modified:       Added $iCompNumeric and $i_Base parameters and logic
;===============================================================================
Func _ArrayMax(Const Byref $avArray, $iCompNumeric = 0, $i_Base = 0)
	If IsArray($avArray) Then
		Return $avArray[_ArrayMaxIndex($avArray, $iCompNumeric, $i_Base) ]
	Else
		SetError(1)
		Return ""
	EndIf
EndFunc   ;==>_ArrayMax


;===============================================================================
;
; Function Name:  _ArrayMaxIndex()
; Description:    Returns the index where the highest value occurs in the array.
; Author(s):      Cephas <cephas@clergy.net>
;
;                 Jos van der Zande
; Modified:       Added $iCompNumeric and $i_Base parameters and logic
;===============================================================================
Func _ArrayMaxIndex(Const ByRef $avArray, $iCompNumeric = 0, $i_Base = 0)
	Local $iCntr, $iMaxIndex = $i_Base
	
	If Not IsArray($avArray) Then
		SetError(1)
		Return ""
	EndIf
	
	Local $iUpper = UBound($avArray)
	For $iCntr = $i_Base To ($iUpper - 1)
		If $iCompNumeric = 1 Then
			If Number($avArray[$iMaxIndex]) < Number($avArray[$iCntr]) Then
				$iMaxIndex = $iCntr
			EndIf
		Else
			If $avArray[$iMaxIndex] < $avArray[$iCntr] Then
				$iMaxIndex = $iCntr
			EndIf
		EndIf
	Next
	SetError(0)
	Return $iMaxIndex
EndFunc   ;==>_ArrayMaxIndex


;===============================================================================
;
; Function Name:  _ArrayMin()
; Description:    Returns the lowest value held in an array.
; Author(s):      Cephas <cephas@clergy.net>
;
;                 Jos van der Zande
; Modified:       Added $iCompNumeric and $i_Base parameters and logic
;===============================================================================
Func _ArrayMin(Const ByRef $avArray, $iCompNumeric = 0, $i_Base = 0)
	If IsArray($avArray) Then
		Return $avArray[_ArrayMinIndex($avArray, $iCompNumeric, $i_Base) ]
	Else
		SetError(1)
		Return ""
	EndIf
EndFunc   ;==>_ArrayMin


;===============================================================================
;
; Function Name:  _ArrayMinIndex()
; Description:    Returns the index where the lowest value occurs in the array.
; Author(s):      Cephas <cephas@clergy.net>
;
;                 Jos van der Zande
; Modified:       Added $iCompNumeric and $i_Base parameters and logic
;===============================================================================
Func _ArrayMinIndex(Const ByRef $avArray, $iCompNumeric = 0, $i_Base = 0)
	Local $iCntr = 0, $iMinIndex = $i_Base
	
	If Not IsArray($avArray) Then
		SetError(1)
		Return ""
	EndIf
	
	Local $iUpper = UBound($avArray)
	For $iCntr = $i_Base To ($iUpper - 1)
		If $iCompNumeric = 1 Then
			If Number($avArray[$iMinIndex]) > Number($avArray[$iCntr]) Then
				$iMinIndex = $iCntr
			EndIf
		Else
			If $avArray[$iMinIndex] > $avArray[$iCntr] Then
				$iMinIndex = $iCntr
			EndIf
		EndIf
	Next
	SetError(0)
	Return $iMinIndex
EndFunc   ;==>_ArrayMinIndex


;===============================================================================
;
; Function Name:  _ArrayPop()
; Description:    Returns the last element of an array, deleting that element
;                 from the array at the same time.
; Author(s):      Cephas <cephas@clergy.net>
; Modified:       Use Redim to remove last entry.
;===============================================================================
Func _ArrayPop(ByRef $avArray)
	Local $sLastVal
	If (Not IsArray($avArray)) Then
		SetError(1)
		Return ""
	EndIf
	$sLastVal = $avArray[UBound($avArray) - 1]
	; remove the last value
	If UBound($avArray) = 1 Then
		$avArray = ""
	Else
		ReDim $avArray[UBound($avArray) - 1]
	EndIf
	; return last value
	Return $sLastVal
EndFunc   ;==>_ArrayPop

;=====================================================================================
;
; Function Name:    _ArrayPush
; Description:      Add new values without increasing array size.Either by inserting
;                   at the end the new value and deleting the first one or vice versa.
; Parameter(s):     $avArray      - Array
;                   $sValue       - The new value.It can be an array too.
;                   $i_Direction  - 0 = Leftwise slide (adding at the end) (default)
;                                   1 = Rightwise slide (adding at the start)
; Requirement(s):   None
; Return Value(s):  On Success -  Returns 1
;                   On Failure -  0 if $avArray is not an array.
;								 -1 if $sValue array size is greater than $avArray size.
;								 In both cases @error is set to 1.
; Author(s):        Helias Gerassimou(hgeras)
;
;======================================================================================
Func _ArrayPush(ByRef $avArray, $sValue, $i_Direction = 0)
	Local $i, $j
	
	If (Not IsArray($avArray)) Then
		SetError(1)
		Return 0
	EndIf
;	
	If (Not IsArray($sValue)) Then
		If $i_Direction = 1 Then
			For $i = (UBound($avArray) - 1) To 1 Step -1
				$avArray[$i] = $avArray[$i - 1]
			Next
			$avArray[0] = $sValue
		Else
			For $i = 0 To (UBound($avArray) - 2)
				$avArray[$i] = $avArray[$i + 1]
			Next
			$i = (UBound($avArray) - 1)
			$avArray[$i] = $sValue
		EndIf
		;
		SetError(0)
		Return 1
	Else
		If UBound($sValue) > UBound($avArray) Then
			SetError(1)
			Return -1
		Else
			For $j = 0 to (UBound($sValue) - 1)
				If $i_Direction = 1 Then
					For $i = (UBound($avArray) - 1) To 1
						$avArray[$i] = $avArray[$i - 1]
					Next
					$avArray[$j] = $sValue[$j]
				Else
					For $i = 0 To (UBound($avArray) - 2)
						$avArray[$i] = $avArray[$i + 1]
					Next
					$i = (UBound($avArray) - 1)
					$avArray[$i] = $sValue[$j]
				EndIf
			Next
		EndIf
	EndIf
	;	
	SetError(0)
	Return 1
;
EndFunc   ;==>_ArrayPush

;===============================================================================
;
; Function Name:  _ArrayReverse()
; Description:    Takes the given array and reverses the order in which the
;                 elements appear in the array.
; Author(s):      Brian Keene <brian_keene@yahoo.com>
;                 
; Modified:       Added $i_Base parameter and logic (Jos van der Zande)
;                 Added $i_UBound parameter and rewrote it for speed. (Tylo)
;===============================================================================

Func _ArrayReverse(ByRef $avArray, $i_Base = 0, $i_UBound = 0)
    If Not IsArray($avArray) Then
        SetError(1)
        Return 0
    EndIf
    Local $tmp, $last = UBound($avArray) - 1
    If $i_UBound < 1 Or $i_UBound > $last Then $i_UBound = $last
    For $i = $i_Base To $i_Base + Int(($i_UBound - $i_Base - 1) / 2)
        $tmp = $avArray[$i]
        $avArray[$i] = $avArray[$i_UBound]
        $avArray[$i_UBound] = $tmp
        $i_UBound = $i_UBound - 1
    Next
    Return 1
EndFunc  ;==>_ArrayReverse

;===============================================================================
;
; Description:      Finds an entry within a one-dimensional array. (Similar to _ArrayBinarySearch() except the array does not need to be sorted.)
; Syntax:           _ArraySearch($avArray, $vWhat2Find, $iStart = 0, $iEnd = 0,$iCaseSense=0)
;
; Parameter(s):      $avArray           = The array to search
;                    $vWhat2Find        = What to search $avArray for
;                    $iStart (Optional) = Start array index for search, normally set to 0 or 1. If omitted it is set to 0
;                    $iEnd  (Optional)  = End array index for search. If omitted or set to 0 it is set to Ubound($AvArray)-
;					 $iCaseSense (Optional) = If set to 1 then search is case sensitive
; Requirement(s):   None
;
; Return Value(s):  On Success - Returns the position of an item in an array.
;                   On Failure - Returns an -1 if $vWhat2Find is not found
;                        @Error=1 $avArray is not an array
;                        @Error=2 $iStart is greater than UBound($AvArray)-1
;                        @Error=3 $iEnd is greater than UBound($AvArray)-1
;                        @Error=4 $iStart is greater than $iEnd
;						 @Error=5 $iCaseSense was invalid. (Must be 0 or 1)
;						 @Error=6 $vWhat2Find was not found in $avArray
;
; Author(s):        SolidSnake <MetalGearX91@Hotmail.com>
; Note(s):          This might be slower than _ArrayBinarySearch() but is useful when the array's order can't be altered.
;===============================================================================
Func _ArraySearch(Const ByRef $avArray, $vWhat2Find, $iStart = 0, $iEnd = 0, $iCaseSense = 0)
	Local $iCurrentPos, $iUBound
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
	For $iCurrentPos = $iStart To $iEnd
		Select
			Case $iCaseSense = 0
				If $avArray[$iCurrentPos] = $vWhat2Find Then
					SetError(0)
					Return $iCurrentPos
				EndIf
			Case $iCaseSense = 1
				If $avArray[$iCurrentPos] == $vWhat2Find Then
					SetError(0)
					Return $iCurrentPos
				EndIf
		EndSelect
	Next
	SetError(6)
	Return -1
EndFunc   ;==>_ArraySearch

;===============================================================================
;
; Function Name:    _ArraySort()
; Description:      Sort an 1 or 2 dimensional Array on a specific index
;                   using the quicksort/insertsort algorithms.
; Parameter(s):     $a_Array      - Array
;                   $i_Descending - Sort Descending when 1
;                   $i_Base       - Start sorting at this Array entry.
;                   $I_Ubound     - End sorting at this Array entry.
;                                   Default UBound($a_Array) - 1
;                   $i_Dim        - Elements to sort in second dimension
;                   $i_SortIndex  - The Index to Sort the Array on.
;                                   (for 2-dimensional arrays only)
; Requirement(s):   None
; Return Value(s):  On Success - 1 and the sorted array is set
;                   On Failure - 0 and sets @ERROR = 1
; Author(s):        Jos van der Zande <jdeb@autoitscript.com>
;                   LazyCoder - added $i_SortIndex option
;                   Tylo - implemented stable QuickSort algo
;                   Jos - Changed logic to correctly Sort arrays with mixed Values and Strings
;
;===============================================================================
;
Func _ArraySort(ByRef $a_Array, $i_Decending = 0, $i_Base = 0, $i_UBound = 0, $i_Dim = 1, $i_SortIndex = 0)
  ; Set to ubound when not specified
    If Not IsArray($a_Array) Then
       SetError(1)
       Return 0
    EndIf
    Local $last = UBound($a_Array) - 1
    If $i_UBound < 1 Or $i_UBound > $last Then $i_UBound = $last
    
    If $i_Dim = 1 Then
        __ArrayQSort1($a_Array, $i_Base, $i_UBound)
        If $i_Decending Then _ArrayReverse($a_Array, $i_Base, $i_UBound)
    Else
        __ArrayQSort2($a_Array, $i_Base, $i_UBound, $i_Dim, $i_SortIndex, $i_Decending)
    EndIf
    Return 1
EndFunc;==>_ArraySort

; Private
Func __ArrayQSort1(ByRef $array, ByRef $left, ByRef $right)
    If $right - $left < 10 Then
      ; InsertSort - fastest on small segments (= 25% total speedup)
        Local $i, $j, $t
        For $i = $left + 1 To $right
            $t = $array[$i]
            $j = $i
			While $j > $left _  
				And (    (IsNumber($array[$j - 1]) = IsNumber($t) And $array[$j - 1] > $t) _
				      Or (IsNumber($array[$j - 1]) <> IsNumber($t) And String($array[$j - 1]) > String($t)))
                $array[$j] = $array[$j - 1]
                $j = $j - 1
            Wend
            $array[$j] = $t
        Next
        Return
    EndIf

  ; QuickSort - fastest on large segments
    Local $pivot = $array[Int(($left + $right)/2)]
    Local $L = $left
    Local $R = $right
    Do
		While ((IsNumber($array[$L]) = IsNumber($pivot) And $array[$L] < $pivot) _
				Or (IsNumber($array[$L]) <> IsNumber($pivot) And String($array[$L]) < String($pivot)))
			;While $array[$L] < $pivot
            $L = $L + 1
        Wend
		While ((IsNumber($array[$R]) = IsNumber($pivot) And $array[$R] > $pivot) _
				Or (IsNumber($array[$R]) <> IsNumber($pivot) And String($array[$R]) > String($pivot)))
			;	While $array[$R] > $pivot
            $R = $R - 1
        Wend
      ; Swap
        If $L <= $R Then
            $t = $array[$L]
            $array[$L] = $array[$R]
            $array[$R] = $t
            $L = $L + 1
            $R = $R - 1
        EndIf
    Until $L > $R
        
    __ArrayQSort1($array, $left, $R)
    __ArrayQSort1($array, $L, $right)
EndFunc

; Private
Func __ArrayQSort2(ByRef $array, ByRef $left, ByRef $right, ByRef $dim2, ByRef $sortIdx, ByRef $decend)
    If $left >= $right Then Return
    Local $t, $d2 = $dim2 - 1
    Local $pivot = $array[Int(($left + $right)/2)][$sortIdx]
    Local $L = $left
    Local $R = $right
    Do
        If $decend Then
			While ((IsNumber($array[$L][$sortIdx]) = IsNumber($pivot) And $array[$L][$sortIdx] > $pivot) _
				Or (IsNumber($array[$L][$sortIdx]) <> IsNumber($pivot) And String($array[$L][$sortIdx]) > String($pivot)))
				;While $array[$L][$sortIdx] > $pivot
                $L = $L + 1
            Wend
			While ((IsNumber($array[$R][$sortIdx]) = IsNumber($pivot) And $array[$R][$sortIdx] < $pivot) _
				Or (IsNumber($array[$R][$sortIdx]) <> IsNumber($pivot) And String($array[$R][$sortIdx]) < String($pivot)))
				;While $array[$R][$sortIdx] < $pivot
                $R = $R - 1
            Wend
        Else
			While ((IsNumber($array[$L][$sortIdx]) = IsNumber($pivot) And $array[$L][$sortIdx] < $pivot) _
				Or (IsNumber($array[$L][$sortIdx]) <> IsNumber($pivot) And String($array[$L][$sortIdx]) < String($pivot)))
				;While $array[$L][$sortIdx] < $pivot
                $L = $L + 1
            Wend
			While ((IsNumber($array[$R][$sortIdx]) = IsNumber($pivot) And $array[$R][$sortIdx] > $pivot) _
				Or (IsNumber($array[$R][$sortIdx]) <> IsNumber($pivot) And String($array[$R][$sortIdx]) > String($pivot)))
				;While $array[$R][$sortIdx] > $pivot
                $R = $R - 1
            Wend
        EndIf
        If $L <= $R Then
            For $x = 0 To $d2
                $t = $array[$L][$x]
                $array[$L][$x] = $array[$R][$x]
                $array[$R][$x] = $t
            Next        
            $L = $L + 1
            $R = $R - 1
        EndIf
    Until $L > $R
        
    __ArrayQSort2($array, $left, $R, $dim2, $sortIdx, $decend)
    __ArrayQSort2($array, $L, $right, $dim2, $sortIdx, $decend)
EndFunc



;===============================================================================
;
; Function Name:  _ArraySwap()
; Description:    Swaps two elements of an array.
; Author(s):      David Nuttall <danuttall@rocketmail.com>
;
;===============================================================================
Func _ArraySwap(ByRef $svector1, ByRef $svector2)
	Local $sTemp = $svector1
	
	$svector1 = $svector2
	$svector2 = $sTemp
	
	SetError(0)
EndFunc   ;==>_ArraySwap


;===============================================================================
;
; Function Name:  _ArrayToClip()
; Description:    Sends the contents of an array to the clipboard.
; Author(s):      Cephas <cephas@clergy.net>
;
;                 Jos van der Zande
; Modified:       Added $i_Base parameter and logic
;===============================================================================
Func _ArrayToClip(const ByRef $avArray, $i_Base = 0)
	Local $iCntr, $iRetVal = 0, $sCr = "", $sText = ""
	
	If (IsArray($avArray)) Then
		For $iCntr = $i_Base To (UBound($avArray) - 1)
			$iRetVal = 1
			If $iCntr > $i_Base Then
				$sCr = @CR
			EndIf
			$sText = $sText & $sCr & $avArray[$iCntr]
		Next
	EndIf
	ClipPut($sText)
	Return $iRetVal
EndFunc   ;==>_ArrayToClip


;===============================================================================
;
; Function Name:  _ArrayToString()
; Description:    Places the elements of an array into a single string,
;                 separated by the specified delimiter.
; Author(s):      Brian Keene <brian_keene@yahoo.com>
;
;===============================================================================
Func _ArrayToString(Const ByRef $avArray, $sDelim, $iStart = 0, $iEnd = 0)
	; Declare local variables.
	Local $iCntr = 0, $iUBound = 0, $sResult = ""
	
	; If $avArray is an array then set var for efficiency sake.
	If (IsArray($avArray)) Then
		$iUBound = UBound($avArray) - 1
	EndIf
	If $iEnd = 0 Then $iEnd = $iUBound
	; Check for parameter validity.
	Select
		Case (Not IsArray($avArray))
			SetError(1)
			Return ""
		Case( ($iUBound + 1) < 2 Or UBound($avArray, 0) > 1)
			SetError(2)
			Return ""
		Case (Not IsInt($iStart))
			SetError(3)
			Return ""
		Case (Not IsInt($iEnd))
			SetError(5)
			Return ""
		Case (Not IsString($sDelim))
			SetError(7)
			Return ""
		Case ($sDelim = "")
			SetError(8)
			Return ""
		Case (StringLen($sDelim) > 1)
			SetError(9)
			Return ""
		Case ($iStart = -1 And $iEnd = -1)
			$iStart = 0
			$iEnd = $iUBound
		Case ($iStart < 0)
			SetError(4)
			Return ""
		Case ($iEnd < 0)
			SetError(6)
			Return ""
	EndSelect
	
	; Make sure that $iEnd <= to the size of the array.
	If ($iEnd > $iUBound) Then
		$iEnd = $iUBound
	EndIf
	
	; Combine the elements into the string.
	For $iCntr = $iStart To $iEnd
		$sResult = $sResult & $avArray[$iCntr]
		If ($iCntr < $iEnd) Then
			$sResult = $sResult & $sDelim
		EndIf
	Next
	
	SetError(0)
	Return $sResult
EndFunc   ;==>_ArrayToString

;===============================================================================
;
; FunctionName:     _ArrayTrim()
; Description:      Trims all elements in an array a certain number of characters.
; Syntax:           _ArrayTrim( $aArray, $iTrimNum , [$iTrimDirection] , [$iBase] , [$iUbound] )
; Parameter(s):     $aArray              - The array to trim the items of
;                   $iTrimNum            - The amount of characters to trim
;                    $iTrimDirection     - 0 to trim left, 1 to trim right
;                                            [Optional] : Default = 0
;                   $iBase               - Start trimming at this element in the array
;                                            [Optional] : Default = 0
;                   $iUbound             - End trimming at this element in the array
;                                            [Optional] : Default = Full Array
; Requirement(s):   None
; Return Value(s):  1 - If invalid array
;                   2 - Invalid base boundry parameter
;                   3 - Invalid end boundry parameter
;                   4 - If $iTrimDirection is not a zero or a one
;                    Otherwise it returns the new trimmed array
; Author(s):        Adam Moore (redndahead)
; Note(s):          None
;
;===============================================================================
Func _ArrayTrim($aArray, $iTrimNum, $iTrimDirection = 0, $iBase = 0, $iUBound = 0)
	Local $i
	
	;Validate array and options given
	If UBound($aArray) = 0 Then
		SetError(1)
		Return $aArray
	EndIf
	
	If $iBase < 0 Or Not IsNumber($iBase) Then
		SetError(2)
		Return $aArray
	EndIf
	
	If UBound($aArray) <= $iUBound Or Not IsNumber($iUBound) Then
		SetError(3)
		Return $aArray
	EndIf
	
	; Set to ubound when not specified
	If $iUBound < 1 Then $iUBound = UBound($aArray) - 1
	
	If $iTrimDirection < 0 Or $iTrimDirection > 1 Then
		SetError(4)
		Return
	EndIf
	;Trim it off
	For $i = $iBase To $iUBound
		If $iTrimDirection = 0 Then
			$aArray[$i] = StringTrimLeft($aArray[$i], $iTrimNum)
		Else
			$aArray[$i] = StringTrimRight($aArray[$i], $iTrimNum)
		EndIf
	Next
	Return $aArray
EndFunc   ;==>_ArrayTrim