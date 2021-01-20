#include-Once

; #INDEX# =======================================================================================================================
; Title .........: Array
; AutoIt Version : 3.2.10++
; Language ......: English
; Description ...: This module contains various functions for manipulating arrays.
; ===============================================================================================================================

; #CURRENT# =====================================================================================================================
;_ArrayAdd
;_ArrayBinarySearch
;_ArrayConcatenate
;_ArrayCreate
;_ArrayDelete
;_ArrayDisplay
;_ArrayFindAll
;_ArrayInsert
;_ArrayMax
;_ArrayMaxIndex
;_ArrayMin
;_ArrayMinIndex
;_ArrayPop
;_ArrayPush
;_ArrayReverse
;_ArraySearch
;_ArraySort
;_ArraySwap
;_ArrayToClip
;_ArrayToString
;_ArrayTrim
; ===============================================================================================================================

; #INTERNAL_USE_ONLY#============================================================================================================
;__ArrayQuickSort1D
;__ArrayQuickSort2D
; ===============================================================================================================================

; #FUNCTION# ====================================================================================================================
; Name...........: _ArrayAdd
; Description ...: Adds a specified value at the end of an existing array.
; Syntax.........: _ArrayAdd ( $avArray, $vValue )
; Parameters ....: $avArray - Array to modify
;                  $vValue  - Value to add
; Return values .: Success - Index of last added item
;                  Failure - -1, sets @error to 1
; Author ........: Jos van der Zande <jdeb at autoitscript dot com>
; Modified.......: Ultima - code cleanup
; Remarks .......:
; Related .......: _ArrayConcatenate, _ArrayDelete, _ArrayInsert, _ArrayPop, _ArrayPush
; Link ..........;
; Example .......; Yes
; ===============================================================================================================================
Func _ArrayAdd(ByRef $avArray, $vValue)
	If Not IsArray($avArray) Then Return SetError(1, 0, -1)

	Local $iUBound = UBound($avArray)
	ReDim $avArray[$iUBound + 1]
	$avArray[$iUBound] = $vValue
	Return $iUBound
EndFunc   ;==>_ArrayAdd

; #FUNCTION# ====================================================================================================================
; Name...........: _ArrayBinarySearch
; Description ...: Uses the binary search algorithm to search through a 1-dimensional array.
; Syntax.........: _ArrayBinarySearch ( $avArray, $vValue [, $iStart = 0 [, $iEnd = 0 ] ] )
; Parameters ....: $avArray - Array to search
;                  $vValue  - Value to find
;                  $iWidth  - [optional] Index of array to start searching at
;                  $iHeight - [optional] Index of array to stop searching at
; Return values .: Success - Index that value was found at
;                  Failure - -1, sets @error to:
;                  |1 - $avArray is not an array
;                  |2 - $vValue outside of array's min/max values
;                  |3 - $vValue was not found in array
;                  |4 - $iStart is greater than $iEnd
; Author ........: Jos van der Zande <jdeb at autoitscript dot com>
; Modified.......: Ultima - added $iEnd as parameter, code cleanup
; Remarks .......: When performing a binary search on an array of items, the contents MUST be sorted before the search is done.
;                  Otherwise undefined results will be returned.
; Related .......: _ArrayFindAll, _ArraySearch
; Link ..........;
; Example .......; Yes
; ===============================================================================================================================
Func _ArrayBinarySearch(Const ByRef $avArray, $vValue, $iStart = 0, $iEnd = 0)
	If Not IsArray($avArray) Then Return SetError(1, 0, -1)

	Local $iUBound = UBound($avArray) - 1

	; Bounds checking
	If $iEnd < 1 Or $iEnd > $iUBound Then $iEnd = $iUBound
	If $iStart < 0 Then $iStart = 0
	If $iStart > $iEnd Then Return SetError(4, 0, -1)

	Local $iMid = Int(($iEnd + $iStart) / 2)

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
EndFunc   ;==>_ArrayBinarySearch

; #FUNCTION# ====================================================================================================================
; Name...........: _ArrayConcatenate
; Description ...: Concatenate two arrays.
; Syntax.........: _ArrayConcatenate ( $avArrayTarget, $avArraySource )
; Parameters ....: $avArrayTarget - The array to concatenate onto
;                  $avArraySource - The array to concatenate from
; Return values .: Success - $avArrayTarget's new size
;                  Failure - 0, sets @error to:
;                  |1 - $avArrayTarget is not an array
;                  |2 - $avArraySource is not an array
; Author ........: Ultima
; Modified.......:
; Remarks .......:
; Related .......: _ArrayAdd, _ArrayPush
; Link ..........;
; Example .......; Yes
; ===============================================================================================================================
Func _ArrayConcatenate(ByRef $avArrayTarget, Const ByRef $avArraySource)
	If Not IsArray($avArrayTarget) Then Return SetError(1, 0, 0)
	If Not IsArray($avArraySource) Then Return SetError(2, 0, 0)

	Local $iUBoundTarget = UBound($avArrayTarget), $iUBoundSource = UBound($avArraySource)
	ReDim $avArrayTarget[$iUBoundTarget + $iUBoundSource]
	For $i = 0 To $iUBoundSource - 1
		$avArrayTarget[$iUBoundTarget + $i] = $avArraySource[$i]
	Next

	Return $iUBoundTarget + $iUBoundSource
EndFunc   ;==>_ArrayConcatenate

; #FUNCTION# ====================================================================================================================
; Name...........: _ArrayCreate
; Description ...: Create a small array and quickly assign values.
; Syntax.........: _ArrayCreate ( $v_0 [,$v_1 [,... [, $v_20 ] ] ] )
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
Func _ArrayCreate($v_0, $v_1 = 0, $v_2 = 0, $v_3 = 0, $v_4 = 0, $v_5 = 0, $v_6 = 0, $v_7 = 0, $v_8 = 0, $v_9 = 0, $v_10 = 0, $v_11 = 0, $v_12 = 0, $v_13 = 0, $v_14 = 0, $v_15 = 0, $v_16 = 0, $v_17 = 0, $v_18 = 0, $v_19 = 0, $v_20 = 0)
	Local $av_Array[21] = [$v_0, $v_1, $v_2, $v_3, $v_4, $v_5, $v_6, $v_7, $v_8, $v_9, $v_10, $v_11, $v_12, $v_13, $v_14, $v_15, $v_16, $v_17, $v_18, $v_19, $v_20]
	ReDim $av_Array[@NumParams]
	Return $av_Array
EndFunc   ;==>_ArrayCreate

; #FUNCTION# ====================================================================================================================
; Name...........: _ArrayDelete
; Description ...: Deletes the specified element from the given array.
; Syntax.........: _ArrayConcatenate ( $avArrayTarget, $avArraySource )
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
; Related .......: _ArrayAdd, _ArrayInsert, _ArrayPop, _ArrayPush
; Link ..........;
; Example .......; Yes
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
; Name...........: _ArrayDisplay
; Description ...: Displays given 1D or 2D array array in a listview.
; Syntax.........: _ArrayDisplay ( $avArray [, $sTitle [, $iItemLimit = -1 [, $iTranspose = 0 [, $sSeparator = "" [, $sReplace = "|" ] ] ] ] ] )
; Parameters ....: $avArray    - Array to display
;                  $sTitle     - [optional] Title to use for window
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
; Remarks .......:
; Related .......:
; Link ..........;
; Example .......; Yes
; ===============================================================================================================================
Func _ArrayDisplay(Const ByRef $avArray, $sTitle = "Array: ListView Display", $iItemLimit = -1, $iTranspose = 0, $sSeparator = "", $sReplace = "|")
	If Not IsArray($avArray) Then Return SetError(1, 0, 0)

	; Dimension checking
	Local $iDimension = UBound($avArray, 0), $iUBound = UBound($avArray, 1) - 1, $iSubMax = UBound($avArray, 2) - 1
	If $iDimension > 2 Then Return SetError(2, 0, 0)

	; Separator handling
	If $sSeparator = "" Then $sSeparator = Chr(1)

	; Declare variables
	Local $i, $j, $vTmp, $aItem, $avArrayText, $sHeader = "Row", $iBuffer = 64
	Local $iColLimit = 250, $iLVIAddUDFThreshold = 4000, $iWidth = 640, $iHeight = 480
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
	If $iItemLimit = 1 Then $iItemLimit = $iLVIAddUDFThreshold
	If $iItemLimit < 1 Then $iItemLimit = $iUBound
	If $iUBound > $iItemLimit Then $iUBound = $iItemLimit
	If $iLVIAddUDFThreshold > $iUBound Then $iLVIAddUDFThreshold = $iUBound

	; Set header up
	For $i = 0 To $iSubMax
		$sHeader &= $sSeparator & "Col " & $i
	Next

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
	For $i = ($iLVIAddUDFThreshold + 1) To $iUBound
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
			DllStructSetData($tItem, "SubItem", $j-1)
			GUICtrlSendMsg($hListView, $_ARRAYCONSTANT_LVM_SETITEMA, 0, $pItem)
		Next
	Next

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
; Syntax.........: _ArrayFindAll ( $avArray, $vValue [, $iStart = 0 [, $iEnd = 0 [, $iCase = 0 [, $iPartial = 0 [, $iSubItem = 0 ] ] ] ] ] )
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
; Link ..........;
; Example .......; Yes
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
; Syntax.........: _ArrayInsert ( $avArray, $iElement [, $vValue] )
; Parameters ....: $avArray  - Array to modify
;                  $iElement - Position to insert item at
;                  $vValue   - [optional] Value of item to insert
; Return values .: Success - New size of the array
;                  Failure - 0, sets @error to 1
; Author ........: Jos van der Zande <jdeb at autoitscript dot com>
; Modified.......: Ultima - code cleanup
; Remarks .......:
; Related .......: _ArrayAdd, _ArrayDelete, _ArrayPop, _ArrayPush
; Link ..........;
; Example .......; Yes
; ===============================================================================================================================
Func _ArrayInsert(ByRef $avArray, $iElement, $vValue = "")
	If Not IsArray($avArray) Then Return SetError(1, 0, 0)

	; Add 1 to the array
	Local $iUBound = UBound($avArray) + 1
	ReDim $avArray[$iUBound]

	; Move all entries over til the specified element
	For $i = $iUBound - 1 To $iElement + 1 Step - 1
		$avArray[$i] = $avArray[$i - 1]
	Next

	; Add the value in the specified element
	$avArray[$iElement] = $vValue
	Return $iUBound
EndFunc   ;==>_ArrayInsert

; #FUNCTION# ====================================================================================================================
; Name...........: _ArrayMax
; Description ...: Returns the highest value held in an array.
; Syntax.........: _ArrayMax ( $avArray [, $iCompNumeric = 0 [, $iStart = 0 [, $iEnd = 0 ] ] ] )
; Parameters ....: $avArray      - Array to search
;                  $iCompNumeric - [optional] Comparison method:
;                  |0 - compare alphanumerically
;                  |1 - compare numerically
;                  $iStart       - [optional] Index of array to start searching at
;                  $iEnd         - [optional] Index of array to stop searching at
; Return values .: Success - The maximum value in the array
;                  Failure - "", sets @error (see _ArrayMaxIndex() description for error codes)
; Author ........: Cephas <cephas at clergy dot net>
; Modified.......: Jos van der Zande <jdeb at autoitscript dot com> - Added $iCompNumeric and $iStart parameters and logic, Ultima - added $iEnd parameter, code cleanup
; Remarks .......:
; Related .......: _ArrayMaxIndex, _ArrayMin, _ArrayMinIndex
; Link ..........;
; Example .......; Yes
; ===============================================================================================================================
Func _ArrayMax(Const ByRef $avArray, $iCompNumeric = 0, $iStart = 0, $iEnd = 0)
	Local $iResult = _ArrayMaxIndex($avArray, $iCompNumeric, $iStart, $iEnd)
	If @error Then Return SetError(@error, 0, "")
	Return $avArray[$iResult]
EndFunc   ;==>_ArrayMax

; #FUNCTION# ====================================================================================================================
; Name...........: _ArrayMaxIndex
; Description ...: Returns the index where the highest value occurs in the array.
; Syntax.........: _ArrayMaxIndex ( $avArray [, $iCompNumeric = 0 [, $iStart = 0 [, $iEnd = 0 ] ] ] )
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
; Author ........: Cephas <cephas at clergy dot net>
; Modified.......: Jos van der Zande <jdeb at autoitscript dot com> - Added $iCompNumeric and $iStart parameters and logic, Ultima - added $iEnd parameter, code cleanup, optimization
; Remarks .......:
; Related .......: _ArrayMax, _ArrayMin, _ArrayMinIndex
; Link ..........;
; Example .......; Yes
; ===============================================================================================================================
Func _ArrayMaxIndex(Const ByRef $avArray, $iCompNumeric = 0, $iStart = 0, $iEnd = 0)
	If Not IsArray($avArray) Then Return SetError(1, 0, -1)

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
; Name...........: _ArrayMin
; Description ...: Returns the lowest value held in an array.
; Syntax.........: _ArrayMin ( $avArray [, $iCompNumeric = 0 [, $iStart = 0 [, $iEnd = 0 ] ] ] )
; Parameters ....: $avArray      - Array to search
;                  $iCompNumeric - [optional] Comparison method:
;                  |0 - compare alphanumerically
;                  |1 - compare numerically
;                  $iStart       - [optional] Index of array to start searching at
;                  $iEnd         - [optional] Index of array to stop searching at
; Return values .: Success - The minimum value in the array
;                  Failure - "", sets @error (see _ArrayMinIndex() description for error codes)
; Author ........: Cephas <cephas at clergy dot net>
; Modified.......: Jos van der Zande <jdeb at autoitscript dot com> - Added $iCompNumeric and $iStart parameters and logic, Ultima - added $iEnd parameter, code cleanup
; Remarks .......:
; Related .......: _ArrayMax, _ArrayMaxIndex, _ArrayMinIndex
; Link ..........;
; Example .......; Yes
; ===============================================================================================================================
Func _ArrayMin(Const ByRef $avArray, $iCompNumeric = 0, $iStart = 0, $iEnd = 0)
	Local $iResult = _ArrayMinIndex($avArray, $iCompNumeric, $iStart, $iEnd)
	If @error Then Return SetError(@error, 0, "")
	Return $avArray[$iResult]
EndFunc   ;==>_ArrayMin

; #FUNCTION# ====================================================================================================================
; Name...........: _ArrayMinIndex
; Description ...: Returns the index where the lowest value occurs in the array.
; Syntax.........: _ArrayMinIndex ( $avArray [, $iCompNumeric = 0 [, $iStart = 0 [, $iEnd = 0 ] ] ] )
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
; Author ........: Cephas <cephas at clergy dot net>
; Modified.......: Jos van der Zande <jdeb at autoitscript dot com> - Added $iCompNumeric and $iStart parameters and logic, Ultima - added $iEnd parameter, code cleanup, optimization
; Remarks .......:
; Related .......: _ArrayMax, _ArrayMaxIndex, _ArrayMin
; Link ..........;
; Example .......; Yes
; ===============================================================================================================================
Func _ArrayMinIndex(Const ByRef $avArray, $iCompNumeric = 0, $iStart = 0, $iEnd = 0)
	If Not IsArray($avArray) Then Return SetError(1, 0, -1)

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
; Name...........: _ArrayPop
; Description ...: Returns the last element of an array, deleting that element from the array at the same time.
; Syntax.........: _ArrayPop ( $avArray )
; Parameters ....: $avArray - Array to modify
; Return values .: Success - The last element of the array
;                  Failure - "", sets @error to 1
; Author ........: Cephas <cephas at clergy dot net>
; Modified.......: Ultima - code cleanup
; Remarks .......: If the array has one element left, it will be set to "" after _ArrayPop() is used on it.
; Related .......: _ArrayAdd, _ArrayDelete, _ArrayInsert, _ArrayPush
; Link ..........;
; Example .......; Yes
; ===============================================================================================================================
Func _ArrayPop(ByRef $avArray)
	If (Not IsArray($avArray)) Then Return SetError(1, 0, "")

	Local $iUBound = UBound($avArray) - 1, $sLastVal = $avArray[$iUBound]

	; Remove last item
	If Not $iUBound Then
		$avArray = ""
	Else
		ReDim $avArray[$iUBound]
	EndIf

	; Return last item
	Return $sLastVal
EndFunc   ;==>_ArrayPop

; #FUNCTION# ====================================================================================================================
; Name...........: _ArrayPush
; Description ...: Add new values without increasing array size by inserting at the end the new value and deleting the first one or vice versa.
; Syntax.........: _ArrayPush ( avArray, $vValue [, $iDirection = 0 ] )
; Parameters ....: $avArray    - Array to modify
;                  $vValue     - Value(s) to add (can be in an array)
;                  $iDirection - [optional] Direction to push existing array elements:
;                  |0 = Slide left (adding at the end)
;                  |1 = Slide right (adding at the start)
; Return values .: Success - 1
;                  Failure - 0, sets @error:
;                  |1 - $avArray is not an array
;                  |2 - $vValue is an array larger than $avArray (so it can't fit)
; Author ........: Helias Gerassimou(hgeras), Ultima - code cleanup/rewrite (major optimization), fixed support for $vValue as an array
; Modified.......:
; Remarks .......: This function is used for continuous updates of data in array, where in other cases a vast size of array would be created.
;                  It keeps all values inside the array (something like History), minus the first one or the last one depending on direction chosen.
;                  It is similar to the push command in assembly.
; Related .......: _ArrayAdd, _ArrayConcatenate, _ArrayDelete, _ArrayInsert, _ArrayPop
; Link ..........;
; Example .......; Yes
; ===============================================================================================================================
Func _ArrayPush(ByRef $avArray, $vValue, $iDirection = 0)
	If (Not IsArray($avArray)) Then Return SetError(1, 0, 0)
	Local $iUBound = UBound($avArray) - 1

	If IsArray($vValue) Then ; $vValue is an array
		Local $iUBoundS = UBound($vValue)
		If ($iUBoundS - 1) > $iUBound Then Return SetError(2, 0, 0)

		; $vValue is an array smaller than $avArray
		If $iDirection Then ; slide right, add to front
			For $i = $iUBound To $iUBoundS Step - 1
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
			For $i = $iUBound To 1 Step - 1
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
; Syntax.........: _ArrayReverse ( $avArray [, $iStart = 0 [, $iEnd = 0 ] ] )
; Parameters ....: $avArray - Array to modify
;                  $iStart  - [optional] Index of array to start modifying at
;                  $iEnd    - [optional] Index of array to stop modifying at
; Return values .: Success - 1
;                  Failure - 0, sets @error:
;                  |1 - $avArray is not an array
;                  |2 - $iStart is greater than $iEnd
; Author ........: Brian Keene
; Modified.......: Jos van der Zande <jdeb at autoitscript dot com> -  added $iStart parameter and logic, Tylo - added $iEnd parameter and rewrote it for speed, Ultima - code cleanup, minor optimization
; Remarks .......:
; Related .......: _ArraySwap
; Link ..........;
; Example .......; Yes
; ===============================================================================================================================
Func _ArrayReverse(ByRef $avArray, $iStart = 0, $iEnd = 0)
	If Not IsArray($avArray) Then Return SetError(1, 0, 0)

	Local $vTmp, $iUBound = UBound($avArray) - 1

	; Bounds checking
	If $iEnd < 1 Or $iEnd > $iUBound Then $iEnd = $iUBound
	If $iStart < 0 Then $iStart = 0
	If $iStart > $iEnd Then Return SetError(2, 0, 0)

	; Reverse
	For $i = $iStart To Int(($iStart + $iEnd - 1) / 2)
		$vTmp = $avArray[$i]
		$avArray[$i] = $avArray[$iEnd]
		$avArray[$iEnd] = $vTmp
		$iEnd -= 1
	Next

	Return 1
EndFunc   ;==>_ArrayReverse

; #FUNCTION# ====================================================================================================================
; Name...........: _ArraySearch
; Description ...: Finds an entry within a 1D or 2D array. Similar to _ArrayBinarySearch(), except that the array does not need to be sorted.
; Syntax.........: _ArraySearch ( $avArray, $vValue [, $iStart = 0 [, $iEnd = 0 [, $iCase = 0 [, $iPartial = 0 [, $iForward = 1 [, $iSubItem = 0 ] ] ] ] ] ] )
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
;                  |4 - $iStart is greater than $iEnd
;                  |6 - $vValue was not found in array
;                  |7 - $avArray has too many dimensions
;                  |(2, 3, 5 - Deprecated error codes)
; Author ........: SolidSnake <MetalGX91 at GMail dot com>
; Modified.......: gcriaco <gcriaco at gmail dot com>, Ultima - 2D arrays supported, directional search, code cleanup, optimization
; Remarks .......: This function might be slower than _ArrayBinarySearch() but is useful when the array's order can't be altered.
; Related .......: _ArrayBinarySearch, _ArrayFindAll
; Link ..........;
; Example .......; Yes
; ===============================================================================================================================
Func _ArraySearch(Const ByRef $avArray, $vValue, $iStart = 0, $iEnd = 0, $iCase = 0, $iPartial = 0, $iForward = 1, $iSubItem = 0)
	If Not IsArray($avArray) Then Return SetError(1, 0, -1)

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
			If $iSubItem < 0 Then $iSubItem = 0
			If $iSubItem > $iUBoundSub Then $iSubItem = $iUBoundSub

			If Not $iPartial Then
				If Not $iCase Then
					For $i = $iStart To $iEnd Step $iStep
						If $avArray[$i][$iSubItem] = $vValue Then Return $i
					Next
				Else
					For $i = $iStart To $iEnd Step $iStep
						If $avArray[$i][$iSubItem] == $vValue Then Return $i
					Next
				EndIf
			Else
				For $i = $iStart To $iEnd Step $iStep
					If StringInStr($avArray[$i][$iSubItem], $vValue, $iCase) > 0 Then Return $i
				Next
			EndIf
		Case Else
			Return SetError(7, 0, -1)
	EndSwitch

	Return SetError(6, 0, -1)
EndFunc   ;==>_ArraySearch

; #FUNCTION# ====================================================================================================================
; Name...........: _ArraySort
; Description ...: Sort a 1D or 2D array on a specific index using the quicksort/insertionsort algorithms.
; Syntax.........: _ArraySort ( $avArray [, $iDescending = 0 [, $iStart = 0 [, $iEnd = 0 [, $iSubItem = 0 ] ] ] ] )
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
; Link ..........;
; Example .......; Yes
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

EndFunc   ;==>_ArraySort

; #INTERNAL_USE_ONLY#============================================================================================================
; Name...........: __ArrayQuickSort1D
; Description ...: Helper function for sorting 1D arrays
; Syntax.........: __ArrayQuickSort1D( ByRef $avArray, ByRef $iStart, ByRef $iEnd )
; Parameters ....: $avArray - Array to sort
;                  $iStart  - Index of array to start sorting at
;                  $iEnd    - Index of array to stop sorting at
; Return values .: None
; Author ........: Jos van der Zande, LazyCoder, Tylo, Ultima
; Modified.......:
; Remarks .......: For Internal Use Only
; Related .......:
; Link ..........;
; Example .......;
; ===============================================================================================================================
Func __ArrayQuickSort1D(ByRef $avArray, ByRef $iStart, ByRef $iEnd)
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

; #INTERNAL_USE_ONLY#============================================================================================================
; Name...........: __ArrayQuickSort2D
; Description ...: Helper function for sorting 2D arrays
; Syntax.........: __ArrayQuickSort2D( ByRef $avArray, ByRef $iStep, ByRef $iStart, ByRef $iEnd, ByRef $iSubItem, ByRef $iSubMax )
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
; Link ..........;
; Example .......;
; ===============================================================================================================================
Func __ArrayQuickSort2D(ByRef $avArray, ByRef $iStep, ByRef $iStart, ByRef $iEnd, ByRef $iSubItem, ByRef $iSubMax)
	If $iEnd <= $iStart Then Return

	; QuickSort
	Local $i, $vTmp, $L = $iStart, $R = $iEnd, $vPivot = $avArray[Int(($iStart + $iEnd) / 2)][$iSubItem], $fNum = IsNumber($vPivot)
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

; #FUNCTION# ====================================================================================================================
; Name...........: _ArraySwap
; Description ...: Swaps two items.
; Syntax.........: _ArraySwap ( $vItem1, $vItem2 )
; Parameters ....: $vItem1 - First item to swap
;                  $vItem2 - Second item to swap
; Return values .: None.
; Author ........: David Nuttall <danuttall at rocketmail dot com>
; Modified.......: Ultima - minor optimization
; Remarks .......: This function swaps the two items in place, since they're passed by reference. Regular, non-array variables can also be swapped by this function.
; Related .......: _ArrayReverse
; Link ..........;
; Example .......; Yes
; ===============================================================================================================================
Func _ArraySwap(ByRef $vItem1, ByRef $vItem2)
	Local $vTmp = $vItem1
	$vItem1 = $vItem2
	$vItem2 = $vTmp
EndFunc   ;==>_ArraySwap

; #FUNCTION# ====================================================================================================================
; Name...........: _ArrayToClip
; Description ...: Sends the contents of an array to the clipboard, each element delimited by a carriage return.
; Syntax.........: _ArrayToClip ( $avArray [, $iStart = 0 [, $iEnd = 0 ] ] )
; Parameters ....: $avArray - Array to copy to clipboard
;                  $iStart  - [optional] Index of array to start copying at
;                  $iEnd    - [optional] Index of array to stop copying at
; Return values .: Success - 1
;                  Failure - 0, sets @error:
;                  |-1 - ClipPut() failed
;                  |Other - See _ArrayToString() description for error codes
; Author ........: Cephas <cephas at clergy dot net>
; Modified.......: Jos van der Zande <jdeb at autoitscript dot com> - added $iStart parameter and logic, Ultima - added $iEnd parameter, make use of _ArrayToString() instead of duplicating efforts
; Remarks .......:
; Related .......: _ArrayToString
; Link ..........;
; Example .......; Yes
; ===============================================================================================================================
Func _ArrayToClip(Const ByRef $avArray, $iStart = 0, $iEnd = 0)
	Local $sResult = _ArrayToString($avArray, @CR, $iStart, $iEnd)
	If @error Then Return SetError(@error, 0, 0)
	Return -1 * ClipPut($sResult)
EndFunc   ;==>_ArrayToClip

; #FUNCTION# ====================================================================================================================
; Name...........: _ArrayToString
; Description ...: Places the elements of an array into a single string, separated by the specified delimiter.
; Syntax.........: _ArrayToString ( $avArray [, $sDelim = "|" [, $iStart = 0 [, $iEnd = 0 ] ] ] )
; Parameters ....: $avArray - Array to combine
;                  $sDelim  - [optional] Delimiter for combined string
;                  $iStart  - [optional] Index of array to start combining at
;                  $iEnd    - [optional] Index of array to stop combining at
; Return values .: Success - 1
;                  Failure - "", sets @error:
;                  |1 - $avArray is not an array
;                  |2 - $iStart is greater than $iEnd
; Author ........: Brian Keene <brian_keene at yahoo dot com>, Valik - rewritten
; Modified.......: Ultima - code cleanup
; Remarks .......:
; Related .......: StringSplit, _ArrayToClip
; Link ..........;
; Example .......; Yes
; ===============================================================================================================================
Func _ArrayToString(Const ByRef $avArray, $sDelim = "|", $iStart = 0, $iEnd = 0)
	If Not IsArray($avArray) Then Return SetError(1, 0, "")

	Local $sResult, $iUBound = UBound($avArray) - 1

	; Bounds checking
	If $iEnd < 1 Or $iEnd > $iUBound Then $iEnd = $iUBound
	If $iStart < 0 Then $iStart = 0
	If $iStart > $iEnd Then Return SetError(2, 0, "")

	; Combine
	For $i = $iStart To $iEnd
		$sResult &= $avArray[$i] & $sDelim
	Next

	Return StringTrimRight($sResult, StringLen($sDelim))
EndFunc   ;==>_ArrayToString

; #FUNCTION# ====================================================================================================================
; Name...........: _ArrayTrim
; Description ...: Trims a certain number of characters from all elements in an array.
; Syntax.........: _ArrayTrim ( $avArray, $iTrimNum [, $iDirection = 0 [, $iStart = 0 [, $iEnd = 0 ] ] ] )
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
; Remarks .......:
; Related .......:
; Link ..........;
; Example .......; Yes
; ===============================================================================================================================
Func _ArrayTrim(ByRef $avArray, $iTrimNum, $iDirection = 0, $iStart = 0, $iEnd = 0)
	If Not IsArray($avArray) Then Return SetError(1, 0, 0)

	Local $iUBound = UBound($avArray) - 1

	; Bounds checking
	If $iEnd < 1 Or $iEnd > $iUBound Then $iEnd = $iUBound
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

	Return 1
EndFunc   ;==>_ArrayTrim
