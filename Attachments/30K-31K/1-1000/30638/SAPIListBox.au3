#include-once
#include <IE.au3>
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#Region Header
#cs
	Title:   		SAPIListBox UDF Library for AutoIt3
	Filename:  		SAPIListBox.au3
	Description: 	A collection of functions for creating and controlling a SAPIListBox control in AutoIT
	Author:   		seangriffin
	Version:  		V0.1
	Last Update: 	21/05/10
	Requirements: 	AutoIt3 3.2 or higher,
					the Microsoft Speech API SDK v5.1
	Changelog:		
					---------21/05/10---------- v0.1
					Initial release.
					Note that a clipping problem currently exists in the VLC control.
					
#ce
#EndRegion Header
#Region Global Variables and Constants
Global $curr_speech_list_index = -1, $SpeechListBoxCtrl
#EndRegion Global Variables and Constants
#Region Core functions
; #FUNCTION# ;===============================================================================
;
; Name...........:	_GUICtrlSAPIListBox_Create()
; Description ...:	Creates a SAPI ListBox control.
; Syntax.........:	_GUICtrlSAPIListBox_Create($left, $top, $width, $height, $enable_speech = True, $enable_listbox = True, $hide_listbox = False, $items = False)
; Parameters ....:	$left				- The left side of the control.
;					$top				- The top of the control.
;					$width				- The width of the control.
;					$height				- The height of the control.
;					$enable_speech 		- A boolean value indicating whether to enable speech recognition.
;					$enable_listbox		- A boolean value indicating whether to enable the listbox.
;					$hide_listbox		- A boolean value indicating whether to hide the listbox.
;					$items				- An array of items to populate the listbox with.
; Return values .: 	On Success			- Returns the identifier (controlID) of the new control. 
;                 	On Failure			- Returns False.
; Author ........:	seangriffin
; Modified.......: 
; Remarks .......:	
; Related .......: 
; Link ..........: 
; Example .......:	Yes
;
; ;==========================================================================================
Func _GUICtrlSAPIListBox_Create($left, $top, $width, $height, $enable_speech = True, $enable_listbox = True, $hide_listbox = False, $items = False)

	Local $SpeechListBox

	$SpeechListBox = ObjCreate("SAPI51ListBox.Sample")
	
	; If the SAPIListBox is not a valid object (ie. the SAPI 5.1 SDK is not installed), then return False.
	if $SpeechListBox = 0 Then Return False
	
	$SpeechListBoxCtrl = GUICtrlCreateObj ($SpeechListBox, $left, $top, $width, $height)
	
	if $enable_speech = True Then
		
		_GUICtrlSAPIListBox_EnableSpeech($SpeechListBox, 1)
	Else
		
		_GUICtrlSAPIListBox_EnableSpeech($SpeechListBox, 0)
	EndIf
	
	_GUICtrlSAPIListBox_Enable($SpeechListBox, $enable_listbox)
	_GUICtrlSAPIListBox_Hide($SpeechListBox, $hide_listbox)

	if IsArray($items) Then _GUICtrlSAPIListBox_AddArray($SpeechListBox, $items)

	Return $SpeechListBox
EndFunc

; #FUNCTION# ;===============================================================================
;
; Name...........:	_GUICtrlSAPIListBox_EnableSpeech()
; Description ...:	Enables or disables speech recognition in a SAPI ListBox control.
; Syntax.........:	_GUICtrlSAPIListBox_EnableSpeech($SAPIListBox, $toggle)
; Parameters ....:	$SAPIListBox	- The control identifier (controlID) as returned by _GUICtrlSAPIListBox_Create.
;					$toggle			- 1 = enable
;									  0 = disable
; Return values .: 	On Success		- Returns True. 
;                 	On Failure		- Returns False.
; Author ........:	seangriffin
; Modified.......: 
; Remarks .......:	
; Related .......: 
; Link ..........: 
; Example .......:	Yes
;
; ;==========================================================================================
Func _GUICtrlSAPIListBox_EnableSpeech($SAPIListBox, $toggle)

	$SAPIListBox.SpeechEnabled = $toggle

	Return True
EndFunc

; #FUNCTION# ;===============================================================================
;
; Name...........:	_GUICtrlSAPIListBox_Enable()
; Description ...:	Enables or disables a SAPI ListBox control.
; Syntax.........:	_GUICtrlSAPIListBox_Enable($SAPIListBox, $toggle)
; Parameters ....:	$SAPIListBox	- The control identifier (controlID) as returned by _GUICtrlSAPIListBox_Create.
;					$toggle			- 1 = enable
;									  0 = disable
; Return values .: 	On Success		- Returns True. 
;                 	On Failure		- Returns False.
; Author ........:	seangriffin
; Modified.......: 
; Remarks .......:	
; Related .......: 
; Link ..........: 
; Example .......:	Yes
;
; ;==========================================================================================
Func _GUICtrlSAPIListBox_Enable($SAPIListBox, $toggle)

	$SAPIListBox.Enabled = $toggle

	Return True
EndFunc

; #FUNCTION# ;===============================================================================
;
; Name...........:	_GUICtrlSAPIListBox_Hide()
; Description ...:	Hides or shows a SAPI ListBox control.
; Syntax.........:	_GUICtrlSAPIListBox_Hide($SAPIListBox, $toggle)
; Parameters ....:	$SAPIListBox	- The control identifier (controlID) as returned by _GUICtrlSAPIListBox_Create.
;					$toggle			- 1 = hide
;									  0 = show
; Return values .: 	On Success		- Returns True.
;                 	On Failure		- Returns False.
; Author ........:	seangriffin
; Modified.......: 
; Remarks .......:	
; Related .......: 
; Link ..........: 
; Example .......:	Yes
;
; ;==========================================================================================
Func _GUICtrlSAPIListBox_Hide($SAPIListBox, $toggle)

	if $toggle = 1 Then
	
		GUICtrlSetState($SpeechListBoxCtrl, $GUI_HIDE)
	Else

		GUICtrlSetState($SpeechListBoxCtrl, $GUI_SHOW)
	EndIf

	Return True
EndFunc

; #FUNCTION# ;===============================================================================
;
; Name...........:	_GUICtrlSAPIListBox_AddString()
; Description ...:	Adds a string to the end of a SAPI ListBox control.
; Syntax.........:	_GUICtrlSAPIListBox_AddString($SAPIListBox, $text)
; Parameters ....:	$SAPIListBox	- The control identifier (controlID) as returned by _GUICtrlSAPIListBox_Create.
;					$text			- String that is to be added.
; Return values .: 	On Success		- Returns True. 
;                 	On Failure		- Returns False.
; Author ........:	seangriffin
; Modified.......: 
; Remarks .......:	
; Related .......: 
; Link ..........: 
; Example .......:	Yes
;
; ;==========================================================================================
Func _GUICtrlSAPIListBox_AddString($SAPIListBox, $text)

	$SAPIListBox.AddItem ($text)

	Return True
EndFunc

; #FUNCTION# ;===============================================================================
;
; Name...........:	_GUICtrlSAPIListBox_DeleteString()
; Description ...:	Deletes a string from the SAPI ListBox control.
; Syntax.........:	_GUICtrlSAPIListBox_DeleteString($SAPIListBox, $index)
; Parameters ....:	$SAPIListBox	- The control identifier (controlID) as returned by _GUICtrlSAPIListBox_Create.
;					$index			- Zero-based index of the string to be deleted.
; Return values .: 	On Success		- Returns True. 
;                 	On Failure		- Returns False.
; Author ........:	seangriffin
; Modified.......: 
; Remarks .......:	
; Related .......: 
; Link ..........: 
; Example .......:	Yes
;
; ;==========================================================================================
Func _GUICtrlSAPIListBox_DeleteString($SAPIListBox, $index)

	$SAPIListBox.RemoveItem ($index)

	Return True
EndFunc

; #FUNCTION# ;===============================================================================
;
; Name...........:	_GUICtrlSAPIListBox_GetSel()
; Description ...:	Returns the selection status of an item.
; Syntax.........:	_GUICtrlSAPIListBox_GetSel($SAPIListBox, $index)
; Parameters ....:	$SAPIListBox	- The control identifier (controlID) as returned by _GUICtrlSAPIListBox_Create.
;					$index			- Zero-based index of the index to get the selection status for.
; Return values .: 	On Success		- Returns the selection status of an item. 
;                 	On Failure		- Returns False.
; Author ........:	seangriffin
; Modified.......: 
; Remarks .......:	
; Related .......: 
; Link ..........: 
; Example .......:	Yes
;
; ;==========================================================================================
Func _GUICtrlSAPIListBox_GetSel($SAPIListBox, $index)

	Return $SAPIListBox.Selected ($index)
EndFunc

; #FUNCTION# ;===============================================================================
;
; Name...........:	_GUICtrlSAPIListBox_InsertString()
; Description ...:	Inserts a string into a SAPI ListBox control.
; Syntax.........:	_GUICtrlSAPIListBox_InsertString($SAPIListBox, $text, $index)
; Parameters ....:	$SAPIListBox	- The control identifier (controlID) as returned by _GUICtrlSAPIListBox_Create.
;					$text			- String that is to be added.
;					$index			- Specifies the zero based index of the position at which to insert the string.
; Return values .: 	On Success		- Returns True.
;                 	On Failure		- Returns False.
; Author ........:	seangriffin
; Modified.......: 
; Remarks .......:	
; Related .......: 
; Link ..........: 
; Example .......:	Yes
;
; ;==========================================================================================
Func _GUICtrlSAPIListBox_InsertString($SAPIListBox, $text, $index)

	$SAPIListBox.AddItem ($text, $index)

	Return True
EndFunc

; #FUNCTION# ;===============================================================================
;
; Name...........:	_GUICtrlSAPIListBox_SetToolTip()
; Description ...:	Sets the tooltip for the SAPI ListBox control.
; Syntax.........:	_GUICtrlSAPIListBox_SetToolTip($SAPIListBox, $text)
; Parameters ....:	$SAPIListBox	- The control identifier (controlID) as returned by _GUICtrlSAPIListBox_Create.
;					$text			- String that is to be added as a tooltip.
; Return values .: 	On Success		- Returns True.
;                 	On Failure		- Returns False.
; Author ........:	seangriffin
; Modified.......: 
; Remarks .......:	
; Related .......: 
; Link ..........: 
; Example .......:	Yes
;
; ;==========================================================================================
Func _GUICtrlSAPIListBox_SetToolTip($SAPIListBox, $text)

	$SAPIListBox.ToolTipText = $text

	Return True
EndFunc

; #FUNCTION# ;===============================================================================
;
; Name...........:	_GUICtrlSAPIListBox_AddArray()
; Description ...:	Adds an array of strings to the end of a SAPI ListBox control.
; Syntax.........:	_GUICtrlSAPIListBox_AddString($SAPIListBox, $array)
; Parameters ....:	$SAPIListBox	- The control identifier (controlID) as returned by _GUICtrlSAPIListBox_Create.
;					$array			- A one-dimensional array containing a list of string to be added.
; Return values .: 	On Success		- Returns True. 
;                 	On Failure		- Returns False.
; Author ........:	seangriffin
; Modified.......: 
; Remarks .......:	
; Related .......: 
; Link ..........: 
; Example .......:	Yes
;
; ;==========================================================================================
Func _GUICtrlSAPIListBox_AddArray($SAPIListBox, $array)

	for $each in $array

		$SAPIListBox.AddItem ($each)
	Next

	Return True
EndFunc

; #FUNCTION# ;===============================================================================
;
; Name...........:	_GUICtrlSAPIListBox_GetCurSel()
; Description ...:	Retrieve the index of the currently selected item.
; Syntax.........:	_GUICtrlSAPIListBox_GetCurSel($SAPIListBox)
; Parameters ....:	$SAPIListBox	- The control identifier (controlID) as returned by _GUICtrlSAPIListBox_Create.
; Return values .: 	On Success		- Returns a zero based index of the currently selected item. 
;                 	On Failure		- Returns False.
; Author ........:	seangriffin
; Modified.......: 
; Remarks .......:	
; Related .......: 
; Link ..........: 
; Example .......:	Yes
;
; ;==========================================================================================
Func _GUICtrlSAPIListBox_GetCurSel($SAPIListBox)

	Return $SAPIListBox.ListIndex
EndFunc

; #FUNCTION# ;===============================================================================
;
; Name...........:	_GUICtrlSAPIListBox_GetCount()
; Description ...:	Retrieves the number of items.
; Syntax.........:	_GUICtrlSAPIListBox_GetCount($SAPIListBox)
; Parameters ....:	$SAPIListBox	- The control identifier (controlID) as returned by _GUICtrlSAPIListBox_Create.
; Return values .: 	On Success		- Returns the number of items in the list box.
;                 	On Failure		- Returns False.
; Author ........:	seangriffin
; Modified.......: 
; Remarks .......:	
; Related .......: 
; Link ..........: 
; Example .......:	Yes
;
; ;==========================================================================================
Func _GUICtrlSAPIListBox_GetCount($SAPIListBox)

	Return $SAPIListBox.ListCount
EndFunc

; #FUNCTION# ;===============================================================================
;
; Name...........:	_GUICtrlSAPIListBox_GetText()
; Description ...:	Returns the currently selected item (string), or the item (string) at the specified index
; Syntax.........:	_GUICtrlSAPIListBox_GetText($SAPIListBox, $index = -1)
; Parameters ....:	$SAPIListBox	- The control identifier (controlID) as returned by _GUICtrlSAPIListBox_Create.
;					$index			- Specifies the zero-based index of the string to retrieve
;									  -1 (default) = return text for the currently selected item.
; Return values .: 	On Success		- Returns the text of the index provided (current selection if -1). 
;                 	On Failure		- Returns False.
; Author ........:	seangriffin
; Modified.......: 
; Remarks .......:	
; Related .......: 
; Link ..........: 
; Example .......:	Yes
;
; ;==========================================================================================
Func _GUICtrlSAPIListBox_GetText($SAPIListBox, $index = -1)

	if $index = -1 Then
		
		Return $SAPIListBox.text
	Else
		
		Return $SAPIListBox.List($index)
	EndIf
	
	Return False
EndFunc

; #FUNCTION# ;===============================================================================
;
; Name...........:	_GUICtrlSAPIListBox_GetNewIndex()
; Description ...:	Returns the index of the most recently added item.
; Syntax.........:	_GUICtrlSAPIListBox_GetNewIndex($SAPIListBox)
; Parameters ....:	$SAPIListBox	- The control identifier (controlID) as returned by _GUICtrlSAPIListBox_Create.
; Return values .: 	On Success		- Returns the index of the most recently added item. 
;                 	On Failure		- Returns False.
; Author ........:	seangriffin
; Modified.......: 
; Remarks .......:	
; Related .......: 
; Link ..........: 
; Example .......:	Yes
;
; ;==========================================================================================
Func _GUICtrlSAPIListBox_GetNewIndex($SAPIListBox)

	Return $SAPIListBox.NewIndex
EndFunc

; #FUNCTION# ;===============================================================================
;
; Name...........:	_GUICtrlSAPIListBox_Refresh()
; Description ...:	Forces a repaint of the listbox.
; Syntax.........:	_GUICtrlSAPIListBox_Refresh($SAPIListBox)
; Parameters ....:	$SAPIListBox	- The control identifier (controlID) as returned by _GUICtrlSAPIListBox_Create.
; Return values .: 	On Success		- Returns True. 
;                 	On Failure		- Returns False.
; Author ........:	seangriffin
; Modified.......: 
; Remarks .......:	
; Related .......: 
; Link ..........: 
; Example .......:	Yes
;
; ;==========================================================================================
Func _GUICtrlSAPIListBox_Refresh($SAPIListBox)

	Return $SAPIListBox.Refresh()
EndFunc

; #FUNCTION# ;===============================================================================
;
; Name...........:	_GUICtrlSAPIListBox_ResetContent()
; Description ...:	Removes all items from the SAPI list box
; Syntax.........:	_GUICtrlSAPIListBox_ResetContent($SAPIListBox)
; Parameters ....:	$SAPIListBox	- The control identifier (controlID) as returned by _GUICtrlSAPIListBox_Create.
; Return values .: 	On Success		- Returns True. 
;                 	On Failure		- Returns False.
; Author ........:	seangriffin
; Modified.......: 
; Remarks .......:	
; Related .......: 
; Link ..........: 
; Example .......:	Yes
;
; ;==========================================================================================
Func _GUICtrlSAPIListBox_ResetContent($SAPIListBox)

	$SAPIListBox.Clear()
	
	Return False
EndFunc

; #FUNCTION# ;===============================================================================
;
; Name...........:	_GUICtrlSAPIListBox_CurSelChanged()
; Description ...:	Returns an indication as to whether the current selection in the listbox has changed (since the last time function was run).
; Syntax.........:	_GUICtrlSAPIListBox_CurSelChanged($SAPIListBox)
; Parameters ....:	$SAPIListBox	- The control identifier (controlID) as returned by _GUICtrlSAPIListBox_Create.
; Return values .: 	On Success		- Returns a zero based index of the currently selected item. 
;                 	On Failure		- Returns False.
; Author ........:	seangriffin
; Modified.......: 
; Remarks .......:	I didn't want to write this function, but I currently don't know of any other 
;					way in AutoIT to detect if a SAPIlistbox has changed.  Traditional methods,
;					such as using a "WM_COMMAND" function or a "if $msg = $SAPIListBox then" 
;					check in the main message loop of the GUI, don't get triggered.
; Related .......: 
; Link ..........: 
; Example .......:	Yes
;
; ;==========================================================================================
Func _GUICtrlSAPIListBox_CurSelChanged($SAPIListBox)

	if $curr_speech_list_index <> $SAPIListBox.ListIndex() Then
		
		$curr_speech_list_index = $SAPIListBox.ListIndex()
		Return True
	EndIf
	
	Return False
EndFunc

; #FUNCTION# ;===============================================================================
;
; Name...........:	_SAPI_SpeechProperties()
; Description ...:	Opens the SAPI Speech Properties control panel applet.
; Syntax.........:	SAPI_SpeechProperties()
; Parameters ....:	
; Return values .: 	On Success			- Returns True. 
;                 	On Failure			- Returns False.
; Author ........:	seangriffin
; Modified.......: 
; Remarks .......:	
; Related .......: 
; Link ..........: 
; Example .......:	Yes
;
; ;==========================================================================================
Func _SAPI_SpeechProperties()

	Run("cmd.exe /c control.exe """ & @CommonFilesDir & "\Microsoft Shared\Speech\sapi.cpl""", @SystemDir, @SW_HIDE)
	
	Return True
EndFunc
