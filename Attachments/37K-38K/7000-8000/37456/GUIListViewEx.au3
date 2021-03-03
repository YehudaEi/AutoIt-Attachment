#include-once

; #INDEX# ============================================================================================================
; Title .........: GUIListViewEx
; AutoIt Version : 3.3 +
; Language ......: English
; Description ...: Permits insertion, deletion, moving, dragging and sorting of items within activated ListViews
; Remarks .......: - It is important to use _GUIListViewEx_Close when a enabled ListView is deleted to free the memory used
;                    by the $aGLVEx_Data array which shadows the ListView contents.
;                  - If the script already has WM_NOTIFY, WM_MOUSEMOVE or WM_LBUTTONUP handlers then only set the
;                    unregistered messages in _GUIListViewEx_DragRegister and call the relevant _GUIListViewEx_WM_#####_Handler from
;                    within the existing handler
;                  - Uses 2 undocumented function within GUIListView UDF to set and colour insert mark (thanks rover)
; Author ........: Melba23 - credit to martin (basic drag code), Array.au3 authors (original array functions)
; Modified ......;
; ====================================================================================================================

;#AutoIt3Wrapper_Au3Check_Parameters=-d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6

; #INCLUDES# =========================================================================================================
#include <GuiListView.au3>
#include <GUIImageList.au3>

; #GLOBAL VARIABLES# =================================================================================================
; Array to hold registered ListView data
Global $aGLVEx_Data[1][7] = [[0, 0]]
; [0][0] = Count			[n][0] = ListView handle
; [0][1] = Active Index		[n][1] = Native ListView ControlID / 0
;		 					[n][2] = Content array
; 							[n][3] = [0] element is count
;                           [n][4] = Sorting array
;                           [n][5] = Drag image
; 							[n][6] = Checkbox array
; Variables for all UDF functions
Global $hGLVEx_Handle, $hGLVEx_CID, $aGLVEx_Array
; Variables for UDF dragging handlers
Global $iGLVEx_Dragging = 0, $iGLVExDragged_Index, $hGLVExDragged_Image = 0, $iGLVExInsert_Index = -1, $iGLVExLast_Y
Global $fGLVEx_Bar_Under, $fGLVEx_MultipleDrag, $aGLVExDragCheck_Array

; #CURRENT# ==========================================================================================================
; _GUIListViewEx_Init:                 Enables UDF button functions for the ListView and sets insert mark colour
; _GUIListViewEx_Close:                Disables all UDF functions for the specified ListView and clears all memory used
; _GUIListViewEx_SetActive:            Set specified ListView as active for UDF functions
; _GUIListViewEx_GetActive:            Get index number of ListView active for UDF functions
; _GUIListViewEx_Return_Array:         Returns an array reflecting the current state of the ListView
; _GUIListViewEx_Insert:               Inserts data just below selected item in active ListView
; _GUIListViewEx_Delete:               Deletes selected item in active ListView
; _GUIListViewEx_Up:                   Moves selected item in active ListView up 1 place
; _GUIListViewEx_Down                  Moves selected item in active ListView down 1 place
; _GUIListViewEx_DragRegister:         Registers Windows messages to enable item dragging for listed ListViews
; _GUIListViewEx_WM_NOTIFY_Handler:    Windows message handler for WM_NOTIFY
; _GUIListViewEx_WM_MOUSEMOVE_Handler: Windows message handler for WM_MOUSEMOVE
; _GUIListViewEx_WM_LBUTTONUP_Handler: Windows message handler for WM_LBUTTONUP
; ====================================================================================================================

; #INTERNAL_USE_ONLY#=================================================================================================
; _GUIListViewEx_HighLight:    Highlights specified ListView item and ensures it is visible
; _GUIListViewEx_Data_Change:  Resets ListView items within a defined range to the current values in the stored array
; _GUIListViewEx_Array_Add:    Adds a specified value at the end of an array
; _GUIListViewEx_Array_Insert: Adds a value at the specified index of an array
; _GUIListViewEx_Array_Delete: Deletes a specified index from an array
; _GUIListViewEx_Array_Swap:   Swaps specified elements within an array
; ====================================================================================================================

; #FUNCTION# =========================================================================================================
; Name...........: _GUIListViewEx_Init
; Description ...: Enables UDF button functions for the ListView and sets insert mark colour for drag function
; Syntax.........: _GUIListViewEx_Init($hLV, [$aArray = "", [$iStart = 0, [$iColour, [$fSort, $fImage]]]]])
; Parameters ....: $hLV     - Handle or ControlID of ListView
;                  $a Array - Name of array used to fill ListView.  "" = empty ListView
;                  $iStart  - 0 (default) = ListView data starts in [0] element of array, 1 = Count in [0] element
;                  $iColour - RGB colour for insert mark (default = black)
;                  $fSort   - True = ListView can be sorted by click on column header - (Default = False)
;                  $fImage  - True = Shadow image of dragged item when dragging
; Requirement(s).: v3.3 +
; Return values .: Index number of ListView for use in other GUIListViewEx functions
; Author ........: Melba23
; Modified ......:
; Remarks .......: - If the ListView is the only one enabled, it is automatically set as active
;                  - If no array is passed a shadow array is created automatically - if the ListView has more than
;                  1 column this array is 2D with the second dimension set to the number of columns
;                  - The shadow array has a count in element [0] added if it does not exist. However, if the $iStart
;                  parameter is set to 0 this count element will not be returned by other GUIListViewEx functions
;                  - Only first item of a multiple selection is shadow imaged when dragging (API limitation)
; Example........: Yes
;=====================================================================================================================
Func _GUIListViewEx_Init($hLV, $aArray = "", $iStart = 0, $iColour = 0, $fSort = False, $fImage = False)

	Local $iIndex = 0

	; See if there is a blank line available in the array
	For $i = 1 To $aGLVEx_Data[0][0]
		If $aGLVEx_Data[$i][0] = 0 Then
			$iIndex = $i
			ExitLoop
		EndIf
	Next
	; If no blank line found then increase array size
	If $iIndex = 0 Then
		$aGLVEx_Data[0][0] += 1
		ReDim $aGLVEx_Data[$aGLVEx_Data[0][0] + 1][7]
		$iIndex = $aGLVEx_Data[0][0]
	EndIf

	; Store ListView handle and ControlID
	If IsHWnd($hLV) Then
		$aGLVEx_Data[$iIndex][0] = $hLV
		$aGLVEx_Data[$iIndex][1] = 0
	Else
		$aGLVEx_Data[$iIndex][0] = GUICtrlGetHandle($hLV)
		$aGLVEx_Data[$iIndex][1] = $hLV
	EndIf

	; Create a shadow array if needed
	If $aArray = "" Then
		Local $iCols = _GUICtrlListView_GetColumnCount($aGLVEx_Data[$iIndex][0])
		Switch $iCols
			Case 1
				Local $aReplacement[1] = [0]
			Case Else
				Local $aReplacement[1][$iCols] = [[0]]
		EndSwitch
		$aArray = $aReplacement
	Else
		; Add count element to shadow array if required
		If $iStart = 0 Then _GUIListViewEx_Array_Insert($aArray, 0, UBound($aArray))
	EndIf
	; Store array
	$aGLVEx_Data[$iIndex][2] = $aArray

	; Store [0] = count data
	$aGLVEx_Data[$iIndex][3] = $iStart
	; If sortable, store sort array
	If $fSort Then
		Local $aLVSortState[_GUICtrlListView_GetColumnCount($hLV)]
		$aGLVEx_Data[$iIndex][4] = $aLVSortState
	Else
		$aGLVEx_Data[$iIndex][4] = 0
	EndIf
	; If image required
	If $fImage Then
		$aGLVEx_Data[$iIndex][5] = 1
	EndIf
	;  If checkbox extended style
	If BitAnd(_GUICtrlListView_GetExtendedListViewStyle($hLV), 4) Then ; $LVS_EX_CHECKBOXES
		$aGLVEx_Data[$iIndex][6] = 1
	EndIf

	; Set insert mark colour after conversion to BGR
	_GUICtrlListView_SetInsertMarkColor($hLV, BitOR(BitShift(BitAND($iColour, 0x000000FF), -16), BitAND($iColour, 0x0000FF00), BitShift(BitAND($iColour, 0x00FF0000), 16)))

	; If only 1 current ListView then activate
	Local $iListView_Count = 0
	For $i = 1 To $iIndex
		If $aGLVEx_Data[$i][0] Then $iListView_Count += 1
	Next
	If $iListView_Count = 1 Then _GUIListViewEx_SetActive($iIndex)

	; Return ListView index
	Return $iIndex

EndFunc   ;==>_GUIListViewEx_Init

; #FUNCTION# =========================================================================================================
; Name...........: _GUIListViewEx_Close
; Description ...: Disables all UDF functions for the specified ListView and clears all memory used
; Syntax.........: _GUIListViewEx_Close($iIndex)
; Parameters ....: $iIndex - Index number of ListView to close as returned by _GUIListViewEx_Init
;                            0 (default) = Closes all ListViews
; Requirement(s).: v3.3 +
; Return values .: Success: 1
;                  Failure: 0 and @error set to 1 - Invalid index number
; Author ........: Melba23
; Modified ......:
; Remarks .......:
; Example........: Yes
;=====================================================================================================================
Func _GUIListViewEx_Close($iIndex = 0)

	; Check valid index
	If $iIndex < 0 Or $iIndex > $aGLVEx_Data[0][0] Then Return SetError(1, 0, 0)

	If $iIndex = 0 Then
		; Remove all ListView data
		Global $aGLVEx_Data[1][7] = [[0, 0]]
	Else
		; Reset all data for ListView
		For $i = 0 To 6
			$aGLVEx_Data[$iIndex][$i] = 0
		Next

		; Cancel active index if set to this ListView
		If $aGLVEx_Data[0][1] = $iIndex Then $aGLVEx_Data[0][1] = 0
	EndIf

	Return 1

EndFunc   ;==>_GUIListViewEx_Close

; #FUNCTION# =========================================================================================================
; Name...........: _GUIListViewEx_SetActive
; Description ...: Set specified ListView as active for UDF functions
; Syntax.........: _GUIListViewEx_SetActive($iIndex)
; Parameters ....: $iIndex - Index number of ListView as returned by _GUIListViewEx_Init
;                  An index of 0 clears any current setting
; Requirement(s).: v3.3 +
; Return values .: Success: Returns previous active index number, 0 = no previously active ListView
;                  Failure: -1 and @error set to 1 - Invalid index number
; Author ........: Melba23
; Modified ......:
; Remarks .......: ListViews can also be activated by clicking on them
; Example........: Yes
;=====================================================================================================================
Func _GUIListViewEx_SetActive($iIndex)

	; Check valid index
	If $iIndex < 0 Or $iIndex > $aGLVEx_Data[0][0] Then Return SetError(1, 0, -1)

	Local $iCurr_Index = $aGLVEx_Data[0][1]

	If $iIndex Then
		; Store index of specified ListView
		$aGLVEx_Data[0][1] = $iIndex
		; Set values for specified ListView
		$hGLVEx_Handle = $aGLVEx_Data[$iIndex][0]
		$hGLVEx_CID = $aGLVEx_Data[$iIndex][1]
	Else
		; Clear active index
		$aGLVEx_Data[0][1] = 0
	EndIf

	Return $iCurr_Index

EndFunc

; #FUNCTION# =========================================================================================================
; Name...........: _GUIListViewEx_GetActive
; Description ...: Get index number of ListView active for UDF functions
; Syntax.........: _GUIListViewEx_GetActive()
; Parameters ....: None
; Requirement(s).: v3.3 +
; Return values .: Success: Index number as returned by _GUIListViewEx_Init, 0 = no active ListView
; Author ........: Melba23
; Modified ......:
; Remarks .......:
; Example........: Yes
;=====================================================================================================================
Func _GUIListViewEx_GetActive()

	Return $aGLVEx_Data[0][1]

EndFunc

; #FUNCTION# =========================================================================================================
; Name...........: _GUIListViewEx_Return_Array
; Description ...: Returns an array reflecting the current state of the ListView
; Syntax.........: _GUIListViewEx_Return_Array($iIndex)
; Parameters ....: $iIndex - Index number of ListView as returned by _GUIListViewEx_Init
;                  $iCheck - If non-zero then the state of the checkboxes is returned (Default = 0)
; Requirement(s).: v3.3 +
; Return values .: Success: Array of current ListView - presence of count in [0] element determined by _GUIListViewEx_Init
;                  Failure: Empty array returns null string and sets @error as follows:
;                           1 = Invalid index number
;                           2 = Empty array (no items in ListView)
;                           3 = $iCheck set to True but ListView does not have checkbox style
; Author ........: Melba23
; Modified ......:
; Remarks .......: The $iStart parameter from GUIListViewEx_Init determines whether the [0] element is a count
; Example........: Yes
;=====================================================================================================================
Func _GUIListViewEx_Return_Array($iIndex, $iCheck = 0)

	; Check valid index
	If $iIndex < 1 Or $iIndex > $aGLVEx_Data[0][0] Then Return SetError(1, 0, "")

	; Copy current array
	Local $aRetArray = $aGLVEx_Data[$iIndex][2]

	; Check if checkbox array
	If $iCheck Then
		If $aGLVEx_Data[$iIndex][6] Then
			Local $aCheck_Array[UBound($aRetArray)]
			For $i = 1 To UBound($aRetArray) - 1
				$aCheck_Array[$i] = _GUICtrlListView_GetItemChecked($aGLVEx_Data[$iIndex][0], $i - 1)
			Next
			; Remove count element if required
			If $aGLVEx_Data[$iIndex][3] = 0 Then
				; Check at least one entry in 1D/2D array
				Switch UBound($aRetArray, 0)
					Case 1
						If $aRetArray[0] = 0 Then Return SetError(2, 0, "")
					Case 2
						If $aRetArray[0][0] = 0 Then Return SetError(2, 0, "")
				EndSwitch
				; Delete count element
				_GUIListViewEx_Array_Delete($aCheck_Array, 0)
			EndIf
			Return $aCheck_Array
		Else
			Return SetError(3, 0, "")
		EndIf
	EndIf

	; Remove count element of array if required
	If $aGLVEx_Data[$iIndex][3] = 0 Then
		; Check at least one entry in 1D/2D array
		Switch UBound($aRetArray, 0)
			Case 1
				If $aRetArray[0] = 0 Then Return SetError(2, 0, "")
			Case 2
				If $aRetArray[0][0] = 0 Then Return SetError(2, 0, "")
		EndSwitch
		; Delete count element
		_GUIListViewEx_Array_Delete($aRetArray, 0)
	EndIf

	; Return array
	Return $aRetArray

EndFunc   ;==>_GUIListViewEx_Return_Array

; #FUNCTION# =========================================================================================================
; Name...........: _GUIListViewEx_Insert
; Description ...: Inserts data just below selected item in active ListView
;                  If no selection, data added at end
; Syntax.........: _GUIListViewEx_Insert($vData)
; Parameters ....: $vData - Data to insert, can be in array or delimited string format
; Requirement(s).: v3.3 +
; Return values .: Success: Array of current ListView with count in [0] element
;                  Failure: If no ListView active then returns "" and sets @error to 1
; Author ........: Melba23
; Modified ......:
; Remarks .......: - New data is inserted after the selected item.  If no item is selected then the datat is added at
;                  the end of the ListView.  If multiple items are selected, the data is inserted after the first
;                  - $vData can be passed in string or array format - it is automatically transformed if required
; Example........: Yes
;=====================================================================================================================
Func _GUIListViewEx_Insert($vData)

	Local $vInsert

	; Set data for active ListView
	Local $iArray_Index = $aGLVEx_Data[0][1]
	; If no ListView active then return
	If $iArray_Index = 0 Then Return SetError(1, 0, "")

	; Load active ListView details
	$hGLVEx_Handle = $aGLVEx_Data[$iArray_Index][0]
	$hGLVEx_CID = $aGLVEx_Data[$iArray_Index][1]

	; Get selected item in ListView
	Local $iIndex = _GUICtrlListView_GetSelectedIndices($hGLVEx_Handle)
	Local $iInsert_Index = $iIndex
	; If no selection
	If $iIndex = "" Then $iInsert_Index = -1
	; Check for multiple selections
	If StringInStr($iIndex, "|") Then
		Local $aIndex = StringSplit($iIndex, "|")
		; Use first selection
		$iIndex = $aIndex[1]
		; Cancel all other selections
		For $i = 2 To $aIndex[0]
			_GUICtrlListView_SetItemSelected($hGLVEx_Handle, $aIndex[$i], False)
		Next
	EndIf

	; Copy array for manipulation
	$aGLVEx_Array = $aGLVEx_Data[$iArray_Index][2]

	; Create Local array for checkboxes if required
	If $aGLVEx_Data[$iArray_Index][6] Then
		Local $aCheck_Array[UBound($aGLVEx_Array)]
		For $i = 1 To UBound($aCheck_Array) - 1
			$aCheck_Array[$i] = _GUICtrlListView_GetItemChecked($hGLVEx_Handle, $i - 1)
		Next
	EndIf

	; Check if 1D/2D array
	Switch UBound($aGLVEx_Array, 0)
		Case 1
			; If empty array insert at 0
			If $aGLVEx_Array[0] = 0 Then $iInsert_Index = 0
			; Get data into string format for insert
			If IsArray($vData) Then
				$vInsert = ""
				For $i = 0 To UBound($vData) - 1
					$vInsert &= $vData[$i] & "|"
				Next
				$vInsert = StringTrimRight($vInsert, 1)
			Else
				$vInsert = $vData
			EndIf
			; Increase count
			$aGLVEx_Array[0] += 1
		Case 2
			; If empty array insert at 0
			If $aGLVEx_Array[0][0] = 0 Then $iInsert_Index = 0
			; Get data into array format for insert
			If IsArray($vData) Then
				$vInsert = $vData
			Else
				Local $aData = StringSplit($vData, "|")
				Switch $aData[0]
					Case 1
						$vInsert = $aData[1]
					Case Else
						Local $vInsert[$aData[0]]
						For $i = 0 To $aData[0] - 1
							$vInsert[$i] = $aData[$i]
						Next
				EndSwitch
			EndIf
			; Increase count
			$aGLVEx_Array[0][0] += 1
	EndSwitch

	; Insert data into array
	If $iIndex = "" Then
		_GUIListViewEx_Array_Add($aGLVEx_Array, $vInsert)
	Else
		_GUIListViewEx_Array_Insert($aGLVEx_Array, $iInsert_Index + 2, $vInsert)
		If $aGLVEx_Data[$iArray_Index][6] Then
			_GUIListViewEx_Array_Insert($aCheck_Array, $iInsert_Index + 2, False)
			; Reset all checkboxes
			For $i = 1 To UBound($aCheck_Array) - 1
				_GUICtrlListView_SetItemChecked($hGLVEx_Handle, $i - 1, $aCheck_Array[$i])
			Next
		EndIf
	EndIf

	; Check if Native or UDF
	If $hGLVEx_CID Then
		; Add new item at ListView end
		GUICtrlCreateListViewItem($vInsert, $hGLVEx_CID)
	Else
		; Add new item at ListView end
		Local $iNewItem
		If IsArray($vInsert) Then
			$iNewItem = _GUICtrlListView_AddItem($hGLVEx_Handle, $vInsert[0])
			; Add new subitems
			For $i = 1 To UBound($vInsert) - 1
				_GUICtrlListView_AddSubItem($hGLVEx_Handle, $iNewItem, $vInsert[$i], $i)
			Next
		Else
			$iNewItem = _GUICtrlListView_AddItem($hGLVEx_Handle, $vInsert)
		EndIf
	EndIf
	; Check where item was to be inserted
	If $iIndex = "" Then
		_GUIListViewEx_Data_Change($iInsert_Index, $iInsert_Index)
		; No moves required so set highlight
		_GUIListViewEx_Highlight(_GUICtrlListView_GetItemCount($hGLVEx_Handle) - 1)
	Else
		; Reset item contents below insert position
		_GUIListViewEx_Data_Change($iInsert_Index, _GUICtrlListView_GetItemCount($hGLVEx_Handle) - 1)
		; Set highlight
		_GUIListViewEx_Highlight($iInsert_Index + 1, $iInsert_Index)
	EndIf

	; Store amended array
	$aGLVEx_Data[$iArray_Index][2] = $aGLVEx_Array
	; Delete copied array
	$aGLVEx_Array = 0
	; Return amended array
	Return _GUIListViewEx_Return_Array($iArray_Index)

EndFunc   ;==>_GUIListViewEx_Insert

; #FUNCTION# =========================================================================================================
; Name...........: _GUIListViewEx_Delete
; Description ...: Deletes selected item in active ListView
; Syntax.........: _GUIListViewEx_Delete()
; Parameters ....: None
; Requirement(s).: v3.3 +
; Return values .: Success: Array of active ListView with count in [0] element
;                  Failure: Returns "" and sets @error as follows:
;                      1 = No ListView active
;                      2 = No item selected
;                      3 = No items to delete
; Author ........: Melba23
; Modified ......:
; Remarks .......: If multiple items are selected, all are deleted
; Example........: Yes
;=====================================================================================================================
Func _GUIListViewEx_Delete()

	; Set data for active ListView
	Local $iArray_Index = $aGLVEx_Data[0][1]
	; If no ListView active then return
	If $iArray_Index = 0 Then Return SetError(1, 0, "")

	; Load active ListView details
	$hGLVEx_Handle = $aGLVEx_Data[$iArray_Index][0]
	$hGLVEx_CID = $aGLVEx_Data[$iArray_Index][1]

	; Check for selected items
	Local $iIndex = _GUICtrlListView_GetSelectedIndices($hGLVEx_Handle)
	If $iIndex = "" Then Return SetError(2, 0, "")

	; Copy array for manipulation
	$aGLVEx_Array = $aGLVEx_Data[$iArray_Index][2]

	; Determine final item
	Local $iLast = UBound($aGLVEx_Array) - 2

	; Check if item is part of a multiple selection
	If StringInStr($iIndex, "|") Then
		; Extract all selected items
		Local $aIndex = StringSplit($iIndex, "|")
		For $i = 1 To $aIndex[0]
			; Remove highlighting from items
			_GUICtrlListView_SetItemSelected($hGLVEx_Handle, $i, False)
		Next

		; Check if 1D/2D array
		Switch UBound($aGLVEx_Array, 0)
			Case 1
				; Decrease count
				$aGLVEx_Array[0] -= $aIndex[0]
			Case 2
				; Decrease count
				$aGLVEx_Array[0][0] -= $aIndex[0]
		EndSwitch

		; Delete elements from array - start from bottom
		For $i = $aIndex[0] To 1 Step -1
			_GUIListViewEx_Array_Delete($aGLVEx_Array, $aIndex[$i] + 1)
		Next

		; Delete items from ListView - again start from bottom
		For $i = $aIndex[0] To 1 Step -1
			_GUICtrlListView_DeleteItem($hGLVEx_Handle, $aIndex[$i])
		Next

	Else
		; Check if 1D/2D array
		Switch UBound($aGLVEx_Array, 0)
			Case 1
				; Decrease count
				$aGLVEx_Array[0] -= 1
			Case 2
				; Decrease count
				$aGLVEx_Array[0][0] -= 1
		EndSwitch
		; Delete element from array
		_GUIListViewEx_Array_Delete($aGLVEx_Array, $iIndex + 1)

		; Delete item from ListView
		_GUICtrlListView_DeleteItem($hGLVEx_Handle, $iIndex)
		; Set highlight - up one if bottom deleted
		If $iIndex = $iLast Then
			_GUIListViewEx_Highlight($iIndex - 1)
		Else
			_GUIListViewEx_Highlight($iIndex)
		EndIf
	EndIf

	; Store amended array
	$aGLVEx_Data[$iArray_Index][2] = $aGLVEx_Array
	; Delete copied array
	$aGLVEx_Array = 0
	; Return amended array
	Return _GUIListViewEx_Return_Array($iArray_Index)

EndFunc   ;==>_GUIListViewEx_Delete

; #FUNCTION# =========================================================================================================
; Name...........: _GUIListViewEx_Up
; Description ...: Moves selected item in active ListView up 1 place
; Syntax.........: _GUIListViewEx_Up()
; Parameters ....: None
; Requirement(s).: v3.3 +
; Return values .: Success: Array of active ListView with count in [0] element
;                  Failure: Returns "" and sets @error as follows:
;                      1 = No ListView active
;                      2 = No item selected
;                      3 = Item already at top
; Author ........: Melba23
; Modified ......:
; Remarks .......: If multiple items are selected, only the first is moved
; Example........: Yes
;=====================================================================================================================
Func _GUIListViewEx_Up()

	; Set data for active ListView
	Local $iArray_Index = $aGLVEx_Data[0][1]
	; If no ListView active then return
	If $iArray_Index = 0 Then Return SetError(1, 0, 0)

	; Load active ListView details
	$hGLVEx_Handle = $aGLVEx_Data[$iArray_Index][0]
	$hGLVEx_CID = $aGLVEx_Data[$iArray_Index][1]

	; Get selected item in ListView
	Local $iIndex = _GUICtrlListView_GetSelectedIndices($hGLVEx_Handle)
	If $iIndex = "" Then Return SetError(2, 0, "")
	; Check for multiple selections
	If StringInStr($iIndex, "|") Then
		Local $aIndex = StringSplit($iIndex, "|")
		; Use first selection
		$iIndex = $aIndex[1]
		; Cancel all other selections
		For $i = 2 To $aIndex[0]
			_GUICtrlListView_SetItemSelected($hGLVEx_Handle, $aIndex[$i], False)
		Next
	EndIf

	; Check not top item
	If $iIndex = "0" Then Return SetError(3, 0, "")

	; Copy array for manipulation
	$aGLVEx_Array = $aGLVEx_Data[$iArray_Index][2]

	; Swap array elements
	_GUIListViewEx_Array_Swap($aGLVEx_Array, $iIndex, $iIndex + 1)

	; Swap checkboxes if required
	If $aGLVEx_Data[$iArray_Index][6] Then
		Local $fTemp = _GUICtrlListView_GetItemChecked($hGLVEx_Handle, $iIndex)
		_GUICtrlListView_SetItemChecked($hGLVEx_Handle, $iIndex, _GUICtrlListView_GetItemChecked($hGLVEx_Handle, $iIndex - 1))
		_GUICtrlListView_SetItemChecked($hGLVEx_Handle, $iIndex - 1, $fTemp)
	EndIf

	; Change data in affected items
	_GUIListViewEx_Data_Change($iIndex - 1, $iIndex);, $aGLVEx_Array)
	; Set highlight and cancel existing one (needed for multiple selection ListViews)
	_GUIListViewEx_Highlight($iIndex - 1, $iIndex)

	; Store amended array
	$aGLVEx_Data[$iArray_Index][2] = $aGLVEx_Array
	; Delete copied array
	$aGLVEx_Array = 0
	; Return amended array
	Return _GUIListViewEx_Return_Array($iArray_Index)

EndFunc   ;==>_GUIListViewEx_Up

; #FUNCTION# =========================================================================================================
; Name...........: _GUIListViewEx_Down
; Description ...: Moves selected item in active ListView down 1 place
; Syntax.........: _GUIListViewEx_Down()
; Parameters ....: None
; Requirement(s).: v3.3 +
; Return values .: Success: Array of active ListView with count in [0] element
;                  Failure: Returns "" and sets @error as follows:
;                      1 = No ListView active
;                      2 = No item selected
;                      3 = Item already at bottom
; Author ........: Melba23
; Modified ......:
; Remarks .......: If multiple items are selected, only the first is moved
; Example........: Yes
;=====================================================================================================================
Func _GUIListViewEx_Down()

	; Set data for active ListView
	Local $iArray_Index = $aGLVEx_Data[0][1]
	; If no ListView active then return
	If $iArray_Index = 0 Then Return SetError(1, 0, 0)

	; Load active ListView details
	$hGLVEx_Handle = $aGLVEx_Data[$iArray_Index][0]
	$hGLVEx_CID = $aGLVEx_Data[$iArray_Index][1]

	; Get selected item in ListView
	Local $iIndex = _GUICtrlListView_GetSelectedIndices($hGLVEx_Handle)
	If $iIndex = "" Then Return SetError(2, 0, "")
	; Check for multiple selections
	If StringInStr($iIndex, "|") Then
		Local $aIndex = StringSplit($iIndex, "|")
		; Use first selection
		$iIndex = $aIndex[1]
		; Cancel all other selections
		For $i = 2 To $aIndex[0]
			_GUICtrlListView_SetItemSelected($hGLVEx_Handle, $aIndex[$i], False)
		Next
	EndIf

	; Check not last item
	If $iIndex = _GUICtrlListView_GetItemCount($hGLVEx_Handle) - 1 Then
		_GUIListViewEx_Highlight($iIndex)
		Return
	EndIf

	; Copy array for manipulation
	$aGLVEx_Array = $aGLVEx_Data[$iArray_Index][2]

	; Swap array elements
	_GUIListViewEx_Array_Swap($aGLVEx_Array, $iIndex + 1, $iIndex + 2)

	; Swap checkboxes if required
	If $aGLVEx_Data[$iArray_Index][6] Then
		Local $fTemp = _GUICtrlListView_GetItemChecked($hGLVEx_Handle, $iIndex)
		_GUICtrlListView_SetItemChecked($hGLVEx_Handle, $iIndex, _GUICtrlListView_GetItemChecked($hGLVEx_Handle, $iIndex + 1))
		_GUICtrlListView_SetItemChecked($hGLVEx_Handle, $iIndex + 1, $fTemp)
	EndIf

	; Change data in affected items
	_GUIListViewEx_Data_Change($iIndex, $iIndex + 1)
	; Set highlight and cancel existing one (needed for multiple selection ListViews)
	_GUIListViewEx_Highlight($iIndex + 1, $iIndex)

	; Store amended array
	$aGLVEx_Data[$iArray_Index][2] = $aGLVEx_Array
	; Delete copied array
	$aGLVEx_Array = 0
	; Return amended array
	Return _GUIListViewEx_Return_Array($iArray_Index)

EndFunc   ;==>_GUIListViewEx_Down

; #FUNCTION# =========================================================================================================
; Name...........: _GUIListViewEx_DragRegister
; Description ...: Registers Windows messages needed for the UDF
; Syntax.........: _GUIListViewEx_DragRegister([$fNOTIFY = True, [$fMOUSEMOVE = True, [$fLBUTTONUP = True]]])
; Parameters ....: $fNOTIFY    - True = Register WM_NOTIFY message
;                  $fMOUSEMOVE - True = Register WM_MOUSEMOVE message
;                  $fLBUTTONUP - True = Register WM_LBUTTONUP message
; Requirement(s).: v3.3 +
; Return values .: None
; Author ........: Melba23
; Modified ......:
; Remarks .......: If other handlers already registered, then call the relevant handler function from within that handler
;                  If no dragging is required, only the WM_NOTIFY handler needs to be registered
; Example........: Yes
;=====================================================================================================================
Func _GUIListViewEx_DragRegister($fNOTIFY = True, $fMOUSEMOVE = True, $fLBUTTONUP = True)

	; Register required messages
	If $fNOTIFY    Then GUIRegisterMsg(0x004E, "_GUIListViewEx_WM_NOTIFY_Handler")    ; $WM_NOTIFY
	If $fMOUSEMOVE Then GUIRegisterMsg(0x0200, "_GUIListViewEx_WM_MOUSEMOVE_Handler") ; $WM_MOUSEMOVE
	If $fLBUTTONUP Then GUIRegisterMsg(0x0202, "_GUIListViewEx_WM_LBUTTONUP_Handler") ; $WM_LBUTTONUP

EndFunc   ;==>_GUIListViewEx_DragRegister

; #FUNCTION# =========================================================================================================
; Name...........: _GUIListViewEx_WM_NOTIFY_Handler
; Description ...: Windows message handler for WM_NOTIFY
; Syntax.........: _GUIListViewEx_WM_NOTIFY_Handler
; Requirement(s).: v3.3 +
; Return values .: None
; Author ........: Melba23
; Modified ......:
; Remarks .......: If a WM_NOTIFY handler already registered, then call this function from within that handler
; Example........: Yes
;=====================================================================================================================
Func _GUIListViewEx_WM_NOTIFY_Handler($hWnd, $iMsg, $wParam, $lParam)

	#forceref $hWnd, $iMsg, $wParam

	; Struct = $tagNMHDR and "int Item;int SubItem" from $tagNMLISTVIEW
	Local $tStruct = DllStructCreate("hwnd;uint_ptr;int_ptr;int;int", $lParam)
	If @error Then Return

	Local $iCode = BitAND(DllStructGetData($tStruct, 3), 0xFFFFFFFF)

	Switch $iCode
		Case $LVN_COLUMNCLICK, -2 ; $NM_CLICK
			; Check if enabled ListView
			For $i = 1 To $aGLVEx_Data[0][0]
				If DllStructGetData($tStruct, 1) = $aGLVEx_Data[$i][0] Then
					ExitLoop
				EndIf
			Next
			If $i > $aGLVEx_Data[0][0] Then Return ; Not enabled

			; Set values for active ListView
			$aGLVEx_Data[0][1] = $i
			$hGLVEx_Handle = $aGLVEx_Data[$i][0]
			$hGLVEx_CID = $aGLVEx_Data[$i][1]
			$aGLVEx_Array = $aGLVEx_Data[$i][2]

			; Sort if a column header was clicked and ListView is sortable
			If $iCode = $LVN_COLUMNCLICK And IsArray($aGLVEx_Data[$i][4]) Then
				; Load current ListView sort state array
				Local $aLVSortState = $aGLVEx_Data[$aGLVEx_Data[0][0]][4]
				; Sort column - get column from from struct
				_GUICtrlListView_SimpleSort($hGLVEx_Handle, $aLVSortState, DllStructGetData($tStruct, 5))
				; Store new ListView sort state array
				$aGLVEx_Data[$aGLVEx_Data[0][0]][4] = $aLVSortState
				; Reread listview items into array
				Switch UBound($aGLVEx_Array, 0) ; Check array format
					Case 1
						For $j = 1 To $aGLVEx_Array[0]
							$aGLVEx_Array[$j] = _GUICtrlListView_GetItemTextString($hGLVEx_Handle, $j - 1)
						Next
					Case 2
						Local $iDim2 = UBound($aGLVEx_Array, 2) - 1
						For $j = 1 To $aGLVEx_Array[0][0]
							For $k = 0 To $iDim2
								$aGLVEx_Array[$j][$k] = _GUICtrlListView_GetItemText($hGLVEx_Handle, $j - 1, $k)
							Next
						Next
				EndSwitch
				; Store amended array
				$aGLVEx_Data[$i][2] = $aGLVEx_Array
			EndIf

		Case $LVN_BEGINDRAG
			; Check if enabled ListView
			For $i = 1 To $aGLVEx_Data[0][0]
				If DllStructGetData($tStruct, 1) = $aGLVEx_Data[$i][0] Then
					ExitLoop
				EndIf
			Next
			If $i > $aGLVEx_Data[0][0] Then Return ; Not registered

			; Set values for this ListView
			$aGLVEx_Data[0][1] = $i
			$hGLVEx_Handle = $aGLVEx_Data[$i][0]
			$hGLVEx_CID = $aGLVEx_Data[$i][1]
			Local $fImage = $aGLVEx_Data[$i][5]
			Local $fCheck = $aGLVEx_Data[$i][6]
			; Copy array for manipulation
			$aGLVEx_Array = $aGLVEx_Data[$i][2]

			; Check if Native or UDF and set focus
			If $hGLVEx_CID Then
				GUICtrlSetState($hGLVEx_CID, 256) ; $GUI_FOCUS
			Else
				_WinAPI_SetFocus($hGLVEx_Handle)
			EndIf

			; Get dragged item index
			$iGLVExDragged_Index = DllStructGetData($tStruct, 4) ; Item
			; Set dragged item count
			$iGLVEx_Dragging = 1

			; Check for selected items
			Local $iIndex = _GUICtrlListView_GetSelectedIndices($hGLVEx_Handle)
			; Check if item is part of a multiple selection
			If StringInStr($iIndex, $iGLVExDragged_Index) And StringInStr($iIndex, "|") Then
				; Extract all selected items
				Local $aIndex = StringSplit($iIndex, "|")
				For $i = 1 To $aIndex[0]
					If $aIndex[$i] = $iGLVExDragged_Index Then ExitLoop
				Next
				; Now check for consecutive items
				If $i <> 1 Then ; Up
					For $j = $i - 1 To 1 Step -1
						; Consecutive?
						If $aIndex[$j] <> $aIndex[$j + 1] - 1 Then ExitLoop
						; Adjust dragged index to this item
						$iGLVExDragged_Index -= 1
						; Increase number to drag
						$iGLVEx_Dragging += 1
					Next
				EndIf
				If $i <> $aIndex[0] Then ; Down
					For $j = $i + 1 To $aIndex[0]
						; Consecutive
						If $aIndex[$j] <> $aIndex[$j - 1] + 1 Then ExitLoop
						; Increase number to drag
						$iGLVEx_Dragging += 1
					Next
				EndIf
			Else ; Either no selection or only a single
				; Set flag
				$iGLVEx_Dragging = 1
			EndIf

			; Remove all highlighting
			_GUICtrlListView_SetItemSelected($hGLVEx_Handle, -1, False)

			; Create drag image
			If $fImage Then
				Local $aImageData = _GUICtrlListView_CreateDragImage($hGLVEx_Handle, $iGLVExDragged_Index)
				$hGLVExDragged_Image = $aImageData[0]
				_GUIImageList_BeginDrag($hGLVExDragged_Image, 0, 0, 0)
			EndIf

			; Create Global array for checkboxes if required
			If $fCheck Then
				Global $aGLVExDragCheck_Array[UBound($aGLVEx_Array)]
				For $i = 1 To UBound($aGLVExDragCheck_Array) - 1
					$aGLVExDragCheck_Array[$i] = _GUICtrlListView_GetItemChecked($hGLVEx_Handle, $i - 1)
				Next
			EndIf

	EndSwitch

EndFunc   ;==>_GUIListViewEx_WM_NOTIFY_Handler

; #FUNCTION# =========================================================================================================
; Name...........: _GUIListViewEx_WM_MOUSEMOVE_Handler
; Description ...: Windows message handler for WM_NOTIFY
; Syntax.........: _GUIListViewEx_WM_MOUSEMOVE_Handler
; Requirement(s).: v3.3 +
; Return values .: None
; Author ........: Melba23
; Modified ......:
; Remarks .......: If a WM_MOUSEMOVE handler already registered, then call this function from within that handler
; Example........: Yes
;=====================================================================================================================
Func _GUIListViewEx_WM_MOUSEMOVE_Handler($hWnd, $iMsg, $wParam, $lParam)

	#forceref $iMsg, $wParam

	If Not $iGLVEx_Dragging Then Return "GUI_RUNDEFMSG"

	Local $aLV_Pos, $tLVHITTESTINFO, $iCurr_Index

	; Get current mouse Y coord
	Local $iCurr_Y = BitShift($lParam, 16)

	; Set insert mark to correct side of items depending on sense of movement when cursor within range
	If $iGLVExInsert_Index <> -1 Then
		If $iGLVExLast_Y = $iCurr_Y Then
			Return "GUI_RUNDEFMSG"
		ElseIf $iGLVExLast_Y > $iCurr_Y Then
			$fGLVEx_Bar_Under = False
			_GUICtrlListView_SetInsertMark($hGLVEx_Handle, $iGLVExInsert_Index, False)
		Else
			$fGLVEx_Bar_Under = True
			_GUICtrlListView_SetInsertMark($hGLVEx_Handle, $iGLVExInsert_Index, True)
		EndIf
	EndIf
	; Store current Y coord
	$iGLVExLast_Y = $iCurr_Y

	; Get ListView item under mouse - depends on ListView type
	If $hGLVEx_CID Then
		$aLV_Pos = ControlGetPos($hWnd, "", $hGLVEx_CID)
		$tLVHITTESTINFO = DllStructCreate("int;int;uint;int;int;int")
		; Force response even if off side of GUI - normal X coord = BitAND($lParam, 0xFFFF) - $aLV_Pos[0]
		DllStructSetData($tLVHITTESTINFO, 1, 1)
		DllStructSetData($tLVHITTESTINFO, 2, $iCurr_Y - $aLV_Pos[1])
		; Get item under mouse
		$iCurr_Index = GUICtrlSendMsg($hGLVEx_CID, $LVM_HITTEST, 0, DllStructGetPtr($tLVHITTESTINFO))
	Else
		; Get coords of client area
		Local $tPoint = DllStructCreate("int X;int Y")
		DllStructSetData($tPoint, "X", 0)
		DllStructSetData($tPoint, "Y", 0)
		Local $pPoint = DllStructGetPtr($tPoint)
		DllCall("user32.dll", "bool", "ClientToScreen", "hwnd", $hWnd, "ptr", $pPoint)
		; Get coords of ListView
		$aLV_Pos = WinGetPos($hGLVEx_Handle)
		Local $iY = $iCurr_Y - $aLV_Pos[1] + DllStructGetData($tPoint, "Y")
		$tLVHITTESTINFO = DllStructCreate("int;int;uint;int;int;int")
		; Force response even if off side of GUI - normal X coord = BitAND($lParam, 0xFFFF) - $aLV_Pos[0] + DllStructGetData($tPoint, "X")
		DllStructSetData($tLVHITTESTINFO, 1, 1)
		DllStructSetData($tLVHITTESTINFO, 2, $iY)
		Local $pLVHITTESTINFO = DllStructGetPtr($tLVHITTESTINFO)
		; Get item under mouse
		Local $aRet = DllCall("user32.dll", "lresult", "SendMessageW", "hwnd", $hGLVEx_Handle, "uint", $LVM_HITTEST, "wparam", 0, "lparam", $pLVHITTESTINFO)
		$iCurr_Index = $aRet[0]
	EndIf

	; If mouse is above or below ListView then scroll ListView
	If $iCurr_Index = -1 Then
		If $fGLVEx_Bar_Under Then
			_GUICtrlListView_Scroll($hGLVEx_Handle, 0, 10)
		Else
			_GUICtrlListView_Scroll($hGLVEx_Handle, 0, -10)
		EndIf
		Sleep(100)
	EndIf

	; Check if over same item
	If $iGLVExInsert_Index = $iCurr_Index Then Return "GUI_RUNDEFMSG"

	; Show insert mark on current item
	_GUICtrlListView_SetInsertMark($hGLVEx_Handle, $iCurr_Index, $fGLVEx_Bar_Under)
	; Store current item
	$iGLVExInsert_Index = $iCurr_Index

EndFunc   ;==>_GUIListViewEx_WM_MOUSEMOVE_Handler

; #FUNCTION# =========================================================================================================
; Name...........: _GUIListViewEx_WM_LBUTTONUP_Handler
; Description ...: Windows message handler for WM_NOTIFY
; Syntax.........: _GUIListViewEx_WM_LBUTTONUP_Handler
; Requirement(s).: v3.3 +
; Return values .: None
; Author ........: Melba23
; Modified ......:
; Remarks .......: If a WM_LBUTTONUP handler already registered, then call this function from within that handler
; Example........: Yes
;=====================================================================================================================
Func _GUIListViewEx_WM_LBUTTONUP_Handler($hWnd, $iMsg, $wParam, $lParam)

	#forceref $hWnd, $iMsg, $wParam, $lParam

	If Not $iGLVEx_Dragging Then Return "GUI_RUNDEFMSG"

	; Get item count
	Local $iMultipleItems = $iGLVEx_Dragging - 1

	; Reset flag
	$iGLVEx_Dragging = 0

	; Check mouse within ListView
	If $iGLVExInsert_Index = -1 Then
		; Clear insert mark
		_GUICtrlListView_SetInsertMark($hGLVEx_Handle, -1, True)
		; Reset highlight to original items
		For $i = 0 To $iMultipleItems
			_GUIListViewEx_HighLight($iGLVExDragged_Index + $i)
		Next
		Return
	EndIf

	; Determine position to insert
	If $fGLVEx_Bar_Under Then
		If $iGLVExDragged_Index > $iGLVExInsert_Index Then $iGLVExInsert_Index += 1
	Else
		If $iGLVExDragged_Index < $iGLVExInsert_Index Then $iGLVExInsert_Index -= 1
	EndIf

	; Clear insert mark
	_GUICtrlListView_SetInsertMark($hGLVEx_Handle, -1, True)

	; Clear drag image
	If $hGLVExDragged_Image Then
		_GUIImageList_DragLeave($hGLVEx_Handle)
		_GUIImageList_EndDrag()
		_GUIImageList_Destroy($hGLVExDragged_Image)
		$hGLVExDragged_Image = 0
	EndIf

	; Check not dropping on dragged item(s)
	Switch $iGLVExInsert_Index
		Case $iGLVExDragged_Index To $iGLVExDragged_Index + $iMultipleItems
			; Reset highlight to original items
			For $i = 0 To $iMultipleItems
				_GUIListViewEx_HighLight($iGLVExDragged_Index + $i)
			Next
			Return
	EndSwitch

	; Amend array
	; Get data from dragged element(s)
	If $iMultipleItems Then
		; Multiple dragged elements
		Switch UBound($aGLVEx_Array, 0) ; Check array format
			Case 1
				Local $aInsertData[$iMultipleItems + 1]
				For $i = 0 To $iMultipleItems
					$aInsertData[$i] = $aGLVEx_Array[$iGLVExDragged_Index + 1 + $i]
				Next
			Case 2
				Local $aInsertData[$iMultipleItems + 1]
				For $i = 0 To $iMultipleItems
					Local $aItemData[UBound($aGLVEx_Array, 2)]
					For $j = 0 To UBound($aGLVEx_Array, 2) - 1
						$aItemData[$j] = $aGLVEx_Array[$iGLVExDragged_Index + 1][$j]
					Next
					$aInsertData[$i] = $aItemData
				Next
		EndSwitch
	Else
		; Single dragged element
		Switch UBound($aGLVEx_Array, 0) ; Check array format
			Case 1
				Local $aInsertData[1]
				$aInsertData[0] = $aGLVEx_Array[$iGLVExDragged_Index + 1]
			Case 2
				Local $aInsertData[1]
				Local $aItemData[UBound($aGLVEx_Array, 2)]
				For $i = 0 To UBound($aGLVEx_Array, 2) - 1
					$aItemData[$i] = $aGLVEx_Array[$iGLVExDragged_Index + 1][$i]
				Next
				$aInsertData[0] = $aItemData
		EndSwitch
	EndIf

	; Copy checkbox data from dragged elements
	If IsArray($aGLVExDragCheck_Array) Then
		If $iMultipleItems Then
			Local $aDragged_Data[$iMultipleItems + 1]
			For $i = 0 To $iMultipleItems
				$aDragged_Data[$i] = _GUICtrlListView_GetItemChecked($hGLVEx_Handle, $iGLVExDragged_Index + $i)
			Next
		Else
			Local $aDragged_Data[1]
			$aDragged_Data[0] = _GUICtrlListView_GetItemChecked($hGLVEx_Handle, $iGLVExDragged_Index)
		EndIf
	EndIf

	; Delete dragged element(s) from arrays
	For $i = 0 To $iMultipleItems
		_GUIListViewEx_Array_Delete($aGLVEx_Array, $iGLVExDragged_Index + 1)
		If IsArray($aGLVExDragCheck_Array) Then
			_GUIListViewEx_Array_Delete($aGLVExDragCheck_Array, $iGLVExDragged_Index + 1)
		EndIf
	Next

	; Amend insert positon for multiple items deleted above
	If $iGLVExDragged_Index < $iGLVExInsert_Index Then
		$iGLVExInsert_Index -= $iMultipleItems
	EndIf
	; Re-insert dragged element(s) into array
	For $i = $iMultipleItems To 0 Step -1
		_GUIListViewEx_Array_Insert($aGLVEx_Array, $iGLVExInsert_Index + 1, $aInsertData[$i])
		If IsArray($aGLVExDragCheck_Array) Then
			_GUIListViewEx_Array_Insert($aGLVExDragCheck_Array, $iGLVExInsert_Index + 1, $aDragged_Data[$i])
		EndIf
	Next

	; Amend ListView to match array
	If $iGLVExDragged_Index > $iGLVExInsert_Index Then
		_GUIListViewEx_Data_Change($iGLVExInsert_Index, $iGLVExDragged_Index + $iMultipleItems)
	Else
		_GUIListViewEx_Data_Change($iGLVExDragged_Index, $iGLVExInsert_Index + $iMultipleItems)
	EndIf

	; Reset checkbox data
	If IsArray($aGLVExDragCheck_Array) Then
		For $i = 1 To UBound($aGLVExDragCheck_Array) - 1
			_GUICtrlListView_SetItemChecked($hGLVEx_Handle, $i - 1, $aGLVExDragCheck_Array[$i])
		Next
		; Clear array
		$aGLVExDragCheck_Array = 0
	EndIf

	; Set highlight to inserted item(s)
	For $i = 0 To $iMultipleItems
		_GUIListViewEx_HighLight($iGLVExInsert_Index + $i)
	Next

	; Store amended array
	$aGLVEx_Data[$aGLVEx_Data[0][1]][2] = $aGLVEx_Array
	; Delete copied array
	$aGLVEx_Array = 0

EndFunc   ;==>_GUIListViewEx_WM_LBUTTONUP_Handler

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name...........: _GUIListViewEx_HighLight($iIndexA, $iIndexB)
; Description ...: Highlights first item and ensures visible while removing hightlight from second in multiple selection ListViews
; Author ........: Melba23
; Remarks .......:
; ===============================================================================================================================
Func _GUIListViewEx_Highlight($iIndexA, $iIndexB = -1)

	; Check if Native or UDF and set focus
	If $hGLVEx_CID Then
		GUICtrlSetState($hGLVEx_CID, 256) ; $GUI_FOCUS
	Else
		_WinAPI_SetFocus($hGLVEx_Handle)
	EndIf
	; Cancel highlight on other item - needed for multisel listviews
	If $iIndexB <> -1 Then _GUICtrlListView_SetItemSelected($hGLVEx_Handle, $iIndexB, False)
	; Set highlight to inserted item and ensure in view
	_GUICtrlListView_SetItemState($hGLVEx_Handle, $iIndexA, $LVIS_SELECTED, $LVIS_SELECTED)
	_GUICtrlListView_EnsureVisible($hGLVEx_Handle, $iIndexA)

EndFunc   ;==>_GUIListViewEx_HighLight

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name...........: _GUIListViewEx_Data_Change($iStart, $iEnd)
; Description ...: Resets ListView items within a defined range to the current values in the stored array
; Author ........: Melba23
; Remarks .......:
; ===============================================================================================================================
Func _GUIListViewEx_Data_Change($iStart, $iEnd)

	Local $sBlanker, $aInsert, $iDim2

	; Check if Native or UDF
	If $hGLVEx_CID Then
		; Native ListView
		For $i = $iStart To $iEnd
			; Get CID of the item
			Local $iCID = _GUICtrlListView_GetItemParam($hGLVEx_Handle, $i)
			; Check array type
			Switch UBound($aGLVEx_Array, 0)
				Case 1
					$aInsert = StringSplit($aGLVEx_Array[$i + 1], "|", 2)
				Case 2
					$iDim2 = UBound($aGLVEx_Array, 2)
					Local $aInsert[$iDim2]
					For $j = 0 To $iDim2 - 1
						$aInsert[$j] = $aGLVEx_Array[$i + 1][$j]
					Next
			EndSwitch
			; Insert new data into each column in turn
			$sBlanker = ""
			For $j = 0 To UBound($aInsert) - 1
				GUICtrlSetData($iCID, $sBlanker & $aInsert[$j])
				$sBlanker &= "|"
			Next
		Next
	Else
		; UDF ListView
		For $i = $iStart To $iEnd
			; Check if multicolumn
			$iDim2 = UBound($aGLVEx_Array, 2)
			If @error Then
				_GUICtrlListView_SetItemText($hGLVEx_Handle, $i, $aGLVEx_Array[$i + 1])
			Else
				; For each column - or just once if not multicolumn
				For $j = 0 To $iDim2 - 1
					; Set data
					_GUICtrlListView_SetItemText($hGLVEx_Handle, $i, $aGLVEx_Array[$i + 1][$j], $j)
				Next
			EndIf
		Next
	EndIf

EndFunc   ;==>_GUIListViewEx_Data_Change

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name...........: _GUIListViewEx_Array_Add
; Description ...: Adds a specified value at the end of an existing 1D or 2D array.
; Author ........: Melba23
; Remarks .......:
; ===============================================================================================================================
Func _GUIListViewEx_Array_Add(ByRef $avArray, $vAdd = "", $iStart = 0)

	; Get size of the Array to modify
	Local $iIndex_Max = UBound($avArray)

	; Get type of array
	Switch UBound($avArray, 0)
		Case 1

			ReDim $avArray[$iIndex_Max + 1]
			$avArray[$iIndex_Max] = $vAdd

		Case 2

		; Get size of second dimension
		Local $iDim2 = UBound($avArray, 2)

		; Redim the Array
		ReDim $avArray[$iIndex_Max + 1][$iDim2]

		; Add new elements
		If IsArray($vAdd) Then
			; Get size of Insert array
			Local $vAdd_Max = UBound($vAdd)
			For $j = 0 To $iDim2 - 1
				; If Insert array is too small to fill Array then continue with blanks
				If $j > $vAdd_Max - 1 - $iStart Then
					$avArray[$iIndex_Max][$j] = ""
				Else
					$avArray[$iIndex_Max][$j] = $vAdd[$j + $iStart]
				EndIf
			Next
		Else
			; Fill Array with variable
			For $j = 0 To $iDim2 - 1
				$avArray[$iIndex_Max][$j] = $vAdd
			Next
		EndIf

	EndSwitch

	Return $iIndex_Max

EndFunc   ;==>_GUIListViewEx_Array_Add

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name...........: _GUIListViewEx_Array_Insert
; Description ...: Adds a value at the specified index of a 1D or 2D array.
; Author ........: Melba23
; Remarks .......:
; ===============================================================================================================================

Func _GUIListViewEx_Array_Insert(ByRef $avArray, $iIndex, $vInsert)

	; Get size of the Array to modify
	Local $iIndex_Max = UBound($avArray)

	; Get type of array
	Switch UBound($avArray, 0)
		Case 1

			; Resize array
			ReDim $avArray[$iIndex_Max + 1]

			; Move down all elements below the new index
			For $i = $iIndex_Max To $iIndex + 1 Step -1
				$avArray[$i] = $avArray[$i - 1]
			Next

			; Add the value in the specified element
			$avArray[$iIndex] = $vInsert
			Return $iIndex_Max

		Case 2

			; If at end of array
			If $iIndex > $iIndex_Max - 1 Then Return $iIndex_Max = _GUIListViewEx_Array_Add($avArray, $vInsert)

			; Get size of second dimension
			Local $iDim2 = UBound($avArray, 2)

			; Redim the Array
			ReDim $avArray[$iIndex_Max + 1][$iDim2]

			; Move down all elements below the new index
			For $i = $iIndex_Max To $iIndex + 1 Step -1
				For $j = 0 To $iDim2 - 1
					$avArray[$i][$j] = $avArray[$i - 1][$j]
				Next
			Next

			; Insert new elements
			If IsArray($vInsert) Then
				; Get size of Insert array
				Local $vInsert_Max = UBound($vInsert)
				For $j = 0 To $iDim2 - 1
					; If Insert array is too small to fill Array then continue with blanks
					If $j > $vInsert_Max - 1 Then
						$avArray[$iIndex][$j] = ""
					Else
						$avArray[$iIndex][$j] = $vInsert[$j]
					EndIf
				Next
			Else
				; Fill Array with variable
				For $j = 0 To $iDim2 - 1
					$avArray[$iIndex][$j] = $vInsert
				Next
			EndIf

	EndSwitch

	Return $iIndex_Max + 1

EndFunc   ;==>_GUIListViewEx_Array_Insert

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name...........: _GUIListViewEx_Array_Delete
; Description ...: Deletes a specified index from an existing 1D or 2D array.
; Author ........: Melba23
; Remarks .......:
; ===============================================================================================================================

Func _GUIListViewEx_Array_Delete(ByRef $avArray, $iIndex)

	; Get size of the Array to modify
	Local $iIndex_Max = UBound($avArray)

	; Get type of array
	Switch UBound($avArray, 0)
		Case 1

			; Move up all elements below the new index
			For $i = $iIndex To $iIndex_Max - 2
				$avArray[$i] = $avArray[$i + 1]
			Next

			; Redim the Array
			ReDim $avArray[$iIndex_Max - 1]

		Case 2

			; Get size of second dimension
			Local $iDim2 = UBound($avArray, 2)

			; Move up all elements below the new index
			For $i = $iIndex To $iIndex_Max - 2
				For $j = 0 To $iDim2 - 1
					$avArray[$i][$j] = $avArray[$i + 1][$j]
				Next
			Next

			; Redim the Array
			ReDim $avArray[$iIndex_Max - 1][$iDim2]

	EndSwitch

	Return $iIndex_Max - 1

EndFunc   ;==>_GUIListViewEx_Array_Delete

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name...........: _GUIListViewEx_Array_Swap
; Description ...: Swaps specified elements within a 1D or 2D array
; Author ........: Melba23
; Remarks .......:
; ===============================================================================================================================

Func _GUIListViewEx_Array_Swap(ByRef $avArray, $iIndex1, $iIndex2)

	Local $vTemp

	; Get type of array
	Switch UBound($avArray, 0)
		Case 1
			; Swap the elements via a temp variable
			$vTemp = $avArray[$iIndex1]
			$avArray[$iIndex1] = $avArray[$iIndex2]
			$avArray[$iIndex2] = $vTemp

		Case 2

			; Get size of second dimension
			Local $iDim2 = UBound($avArray, 2)
			; Swap the elements via a temp variable
			For $i = 0 To $iDim2 - 1
				$vTemp = $avArray[$iIndex1][$i]
				$avArray[$iIndex1][$i] = $avArray[$iIndex2][$i]
				$avArray[$iIndex2][$i] = $vTemp
			Next
	EndSwitch

	Return 0

EndFunc   ;==>_GUIListViewEx_Array_Swap