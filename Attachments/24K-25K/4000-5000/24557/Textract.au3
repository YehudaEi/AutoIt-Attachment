#include-once
#Include <Array.au3>
#Include <GuiComboBox.au3>
#Include <GuiListBox.au3>
#Region Header
#cs
	Title:   		Textract UDF Library for AutoIt3
	Filename:  		Textract.au3
	Description: 	A collection of functions for capturing text in applications.
	Author:   		seangriffin
	Version:  		V0.2
	Last Update: 	12/02/09
	Requirements: 	AutoIt3 3.2 or higher,
					Textract 2.9.
	Changelog:		---------12/02/09---------- v0.1
					Initial release.
					
					---------12/02/09---------- v0.2
					Renamed _TextractCaptureToArray to _TextractCapture and made the return type dependant on $delimiter.
					Updated _TextractCapture to make a selection in listboxes to improve text recognition.
					Added function _TextractFind.
#ce
#EndRegion Header
#Region Global Variables and Constants
#EndRegion Global Variables and Constants
#Region Core functions
; #FUNCTION# ;===============================================================================
;
; Name...........:	_Textract_Capture()
; Description ...:	Captures text from a window or control.
; Syntax.........:	_TextractCapture($win_title, $win_text = "", $ctrl_id = "", $delimiter = @CRLF, $expand = 1, $scrolling = 1, $cleanup = 1)
; Parameters ....:	$win_title	- The title of the window to capture text from.
;					$win_text	- Optional: The text of the window to capture text from.
;					$ctrl_id	- Optional: The ID of the control to capture text from.
;									The text of the window will be returned if one isn't provided.
;					$delimiter	- Optional: The string that delimits elements in the text.
;									A string of text will be returned if this isn't provided.
;									An array of delimited text will be returned if this is provided.
;									Eg. Use @CRLF to return the items of a listbox as an array.
;					$expand		- Optional: Expand the control before capturing text from it?
;									0 = do not expand the control
;									1 = expand the control (default)
;					$scrolling	- Optional: Scroll the control to capture all it's text?
;									0 = do not scroll the control
;									1 = scroll the control (default)
;					$cleanup	- Optional: Remove invalid text recognised
;									0 = do not remove invalid text
;									1 = remove invalid text (default)
; Return values .: 	On Success	- Returns an array of text that was captured. 
;                 	On Failure	- Returns an empty array.
; Author ........:	seangriffin
; Modified.......: 
; Remarks .......:	
; Related .......: 
; Link ..........: 
; Example .......:	No
;
; ;==========================================================================================
func _TextractCapture($win_title, $win_text = "", $ctrl_id = "", $delimiter = "", $expand = 1, $scrolling = 1, $cleanup = 1)

	Local $tInfo

	; if a control ID is specified, then get it's HWND
	if StringCompare($ctrl_id, "") <> 0 Then

		$hwnd = ControlGetHandle($win_title, $win_text, $ctrl_id)

		; if expansion of the control is required.
		if $expand = 1 and StringCompare($delimiter, "") <> 0 Then

			$hwnd2 = $hwnd

			If _GUICtrlComboBox_GetComboBoxInfo($hwnd, $tInfo) Then

				$hwnd = DllStructGetData($tInfo, "hList")
			EndIf
		
			; Expand the control.
			_GUICtrlComboBox_ShowDropDown($hwnd2, True)
		EndIf
	EndIf

	; Text recognition improves alot if the item with the focus rectangle is selected.
	;	The following code will make a selection if one doesn't exist.
	;	After text recognition the selection is removed.
	$sel_index = _GUICtrlListBox_GetCurSel($hwnd)
	
	; If the control doesn't have a selection yet
	if $sel_index = -1 Then
		
		; Temporarily make a selection
		_GUICtrlListBox_SetCurSel($hwnd, 0)
	EndIf

	$TextractOCX = ObjCreate("TxtrCtl.TxtrCtl")
	$TextractOCX.Init
	$TextractOCX.Dest = ""
	$TextractOCX.TextType = 0
	$TextractOCX.Flags = 0
	
	; Scrolling
	if $scrolling = 1 then
		
		$TextractOCX.Scrolling = True
	Else

		$TextractOCX.Scrolling = False
	EndIf

	WinActivate($win_title, $win_text)
	$TextractOCX.ReadWindow(Number($hwnd))
	
	$recognised_str = $TextractOCX.Text
	$TextractOCX.Term

	$caret_index = _GUICtrlListBox_GetCaretIndex($hwnd)
	
	; If the control didn't have a selection before capturing the text
	if $sel_index = -1 Then
		
		; Remove the current selection
		_GUICtrlListBox_SetCurSel($hwnd, -1)
	EndIf

	; If no delimiting is required, return the recognised text as a string.
	if StringCompare($delimiter, "") = 0 Then
		
		return $recognised_str
	EndIf

	; Split the captured text into an array.
	$recognised_array = StringSplit($recognised_str, $delimiter, 1)

	; Cleanup
	if $cleanup = 1 Then

		; Cleanup the items
		for $recognised_array_num = 1 to (UBound($recognised_array)-1)

			; Remove erroneous characters like "^_|
			$recognised_array[$recognised_array_num] = StringReplace($recognised_array[$recognised_array_num], """", "")
			$recognised_array[$recognised_array_num] = StringReplace($recognised_array[$recognised_array_num], "^", "")
			$recognised_array[$recognised_array_num] = StringReplace($recognised_array[$recognised_array_num], "_|", "")
			$recognised_array[$recognised_array_num] = StringStripWS($recognised_array[$recognised_array_num], 3)
		Next

		; Remove duplicate and blank items
		for $each in $recognised_array
		
			$found_item = _ArrayFindAll($recognised_array, $each)
			
			; Remove blank items
			if IsArray($found_item) Then
				if StringCompare($recognised_array[$found_item[0]], "") = 0 Then
					
					_ArrayDelete($recognised_array, $found_item[0])
				EndIf
			EndIf

			; Remove duplicate items
			for $found_item_num = 2 to UBound($found_item)
				
				_ArrayDelete($recognised_array, $found_item[$found_item_num-1])
			Next
		Next
	EndIf

	Return $recognised_array
EndFunc

; #FUNCTION# ;===============================================================================
;
; Name...........:	_TextractFind()
; Description ...:	Finds the location of a string within text captured from a window or control.
; Syntax.........:	_TextractFind($win_title, $win_text = "", $ctrl_id = "", $find_str = "", $partial = 1, $delimiter = "", $expand = 1, $scrolling = 1, $cleanup = 1)
; Parameters ....:	$win_title	- The title of the window to find text in.
;					$win_text	- Optional: The text of the window to find text in.
;					$ctrl_id	- Optional: The ID of the control to find text in.
;									The text of the window will be used if one isn't provided.
;					$find_str	- The string to find.
;					$partial	- Optional: Match against all text or partial text.
;									0 = Find on full text
;									1 = Find on partial text
;					$delimiter	- Optional: The string that delimits elements in the text.
;									A string of text will be searched if this isn't provided.
;									An array of delimited text will be searched if this is provided.
;									Eg. Use @CRLF to search the items of a listbox as an array.
;					$expand		- Optional: Expand the control before searching within it?
;									0 = do not expand the control
;									1 = expand the control (default)
;					$scrolling	- Optional: Scroll the control to search all it's text?
;									0 = do not scroll the control
;									1 = scroll the control (default)
;					$cleanup	- Optional: Remove invalid text recognised
;									0 = do not remove invalid text
;									1 = remove invalid text (default)
; Return values .: 	On Success	- Returns the location of the text that was found.
;									If $delimiter is "", then the character position of the text found
;										is returned.
;									If $delimiter is not "", then the element of the array where the
;										text was found is returned.
;                 	On Failure	- Returns an empty array.
; Author ........:	seangriffin
; Modified.......: 
; Remarks .......:	
; Related .......: 
; Link ..........: 
; Example .......:	No
;
; ;==========================================================================================
func _TextractFind($win_title, $win_text = "", $ctrl_id = "", $find_str = "", $partial = 1, $delimiter = "", $expand = 1, $scrolling = 1, $cleanup = 1)

	; Get all the text from the window / control
	$recognised_text = _TextractCapture($win_title, $win_text, $ctrl_id, $delimiter, $expand, $scrolling, $cleanup)

	if IsArray($recognised_text) Then
		
		$element_found = _ArraySearch($recognised_text, $find_str, 0, 0, 0, $partial)
	EndIf

	Return $element_found
EndFunc
