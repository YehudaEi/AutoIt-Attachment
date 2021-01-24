#include-once
#Include <Array.au3>
#Region Header
#cs
	Title:   		SAP Automation UDF Library for AutoIt3
	Filename:  		SAP.au3
	Description: 	A collection of functions for creating, attaching to, reading from and manipulating SAP
	Author:   		seangriffin
	Version:  		V0.4
	Last Update: 	01/07/09
	Requirements: 	AutoIt3 3.2 or higher,
					SAP GUI Release 6.40,
					SAP GUI Scripting interface is enabled
						(from the SAP GUI, select the "Customize Local Layout" button on the toolbar, then "Options".  
						Go to the "Scripting" tab.
						THE MESSAGE "Scripting is installed!" MUST BE DISPLAYED FOR THIS UDF TO WORK!
						Select "Enable Scripting", and deselect "Notify when a script attaches to a running GUI" and 
						"Notify when a script opens a connection").
	Changelog:		---------24/12/08---------- v0.1
					Initial release.
					
					---------30/12/08---------- v0.2
					Function _SAPAttach changed to SAPSessAttach, and added a $sap_transaction parameter.
					Function _SAPSessionCreate changed to _SAPSessCreate.
					Function _SAPSendVKeys changed to _SAPVKeysSend.
					Function _SAPSendVKeysUntilWinExists changed to _SAPVKeysSendUntilWinExists.
					Function _SAPObjectSet changed to _SAPObjValueSet.
					Function _SAPObjectGet changed to _SAPObjValueGet.
					Function _SAPObjPropertySet added.
					Function _SAPObjPropertyGet added.
					Function _SAPWinClose added.
					
					---------31/12/08---------- v0.3
					Fixed return values for _SAPObjPropertyGet.
					Fixed description for _SAPObjPropertyGet.
					Fixed return values for _SAPObjValueGet.
					Added GuiUserArea support for _SAPObjValueGet.
					Added GuiMenubar support for _SAPObjSelect.
					Added a wait period for the window to SAPSessAttach.
					
					---------07/01/09---------- v0.4
					Added a SAP error handler
					Added GuiLabel support for _SAPObjSelect.
					Function _SAPObjDeselect added.
					Function _SAPErrorHandlerRegister added.
					Function __SAPInternalErrorHandler added.
					Function _SAPObjFindByValue added.
					Changed the default value for _SAPObjValueGet.
					Changed the default value for _SAPSessAttach.
#ce
#EndRegion Header
#Region Global Variables and Constants
Global Const $sap_vkey[100] = [ "Enter", "F1", "F2", "F3", "F4", "F5", "F6", "F7", "F8", "F9", "F10", _
								"F11", _ ; NOTE - "F11" is the same as "CTRL+S"
								"F12", _ ; NOTE - "F12" is the same as "Esc"
								"Shift+F1", "Shift+F2", "Shift+F3", "Shift+F4", "Shift+F5", "Shift+F6", "Shift+F7", "Shift+F8", "Shift+F9", _
								"Shift+Ctrl+0", "Shift+F11", "Shift+F12", _
								"Ctrl+F1", "Ctrl+F2", "Ctrl+F3", "Ctrl+F4", "Ctrl+F5", "Ctrl+F6", "Ctrl+F7", "Ctrl+F8", "Ctrl+F9", "Ctrl+F10", _
								"Ctrl+F11", "Ctrl+F12", _
								"Ctrl+Shift+F1", "Ctrl+Shift+F2", "Ctrl+Shift+F3", "Ctrl+Shift+F4", "Ctrl+Shift+F5", _
								"Ctrl+Shift+F6", "Ctrl+Shift+F7", "Ctrl+Shift+F8", "Ctrl+Shift+F9", "Ctrl+Shift+F10", "Ctrl+Shift+F11", _
								"Ctrl+Shift+F12", _
								"", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", _
								"Ctrl+E", "Ctrl+F", "Ctrl+A", "Ctrl+D", "Ctrl+N", "Ctrl+O", "Shift+D", "Ctrl+I", "Shift+I", "Alt+B", _
								"Ctrl+Page up", "Page up", "Page down", "Ctrl+Page down", "Ctrl+G", "Ctrl+R", "Ctrl+P", _
								"", "", "", "", "", "", "", "Shift+F10", "", "", "", "", "" ]
Global $sap_connection = -1
Global $sap_session
Global $sap_window_num
Global $sap_object_id
Global $sap_object_value
Global $_SAPErrorNotify = True
Global $oSAPErrorHandler, $sSAPUserErrorHandler
#EndRegion Global Variables and Constants
#Region Core functions
; #FUNCTION# ;===============================================================================
;
; Name...........:	_SAPSessAttach()
; Description ...:	Attaches to an existing session of SAP.
; Syntax.........:	_SAPSessAttach($win_title, $sap_transaction = -1)
; Parameters ....:	$win_title			- Optional: The title of the SAP window (within the session) to attach to.
;											The window "SAP Easy Access" is used if one isn't provided.
;											This may be a substring of the full window title.
;					$sap_transaction	- Optional: a SAP transaction to run after attaching to the session.
;											A "/n" will be inserted at the beginning of the transaction
;											if one isn't provided.
; Return values .: 	On Success			- Returns True. 
;                 	On Failure			- Returns False, and:
;											sets @ERROR = 1 if unable to find an active SAP session.
;												This means the SAP GUI Scripting interface is not enabled.
;												Refer to the "Requirements" section at the top of this file.
;											sets @ERROR = 2 if unable to find the SAP window to attach to.
;							
; Author ........:	seangriffin
; Modified.......: 
; Remarks .......:	A prerequisite is that the SAP GUI Scripting interface is enabled, 
;					and the SAP user is already logged in (ie. The "SAP Easy Access" window is displayed).
;					Refer to the "Requirements" section at the top of this file for information
;					on enabling the SAP GUI Scripting interface.
;					
; Related .......: 
; Link ..........: 
; Example .......:	Yes
;
; ;==========================================================================================
func _SAPSessAttach($win_title = "SAP Easy Access", $sap_transaction = -1)
	
	if $sap_connection = -1 Then
	
		$sapgui = ObjGet("SAPGUI")
		$sapapp = $sapgui.GetScriptingEngine

		if $sapapp.Children.Count = 0 Then

			ConsoleWriteError("Unable to find an active SAP session." & @CRLF & _
							  "Make sure you are logged into SAP and have GUI Scripting enabled." & @CRLF)
			Return SetError(1, 0, False) ; unable to find a SAP session to attach to.
		EndIf

		$sap_connection = $sapapp.Children(0)
	EndIf

	; Wait 20 seconds for the window to exist (in case it is not already)
	$win_wait_start = TimerInit()
	while _SAPWinExists($win_title) = False
		
		if TimerDiff($win_wait_start) > 20000 then

			ConsoleWriteError("Unable to find the window with title """ & $win_title & """ to attach to." & @CRLF)
			Return SetError(2, 0, False) ; unable to find the SAP window to attach to.
		EndIf
	WEnd

	$sess_found = False

	; Check each session for the $sap_title
	for $sap_sess_num = 0 to ($sap_connection.Sessions.Count - 1)

		$sap_session = $sap_connection.Children($sap_sess_num)

		; Check each window in each session for the $sap_title
		for $sap_window_num_tmp = 0 to ($sap_session.Children.Count - 1)

			if StringRegExp($sap_session.findById("wnd[" & $sap_window_num_tmp & "]").Text, ".*" & $win_title & ".*") = 1 Then

				$sess_found = True
				$sap_session.findById("wnd[0]").maximize
				
				if $sap_transaction <> -1 Then
				
					if StringInStr($sap_transaction, "/n") = 0 Then
						
						$sap_transaction = "/n" & $sap_transaction
					EndIf
					
					$sap_session.findById("wnd[0]/tbar[0]/okcd").Text = $sap_transaction
					$sap_session.findById("wnd[0]").sendVKey(0)
				EndIf
				
				ExitLoop 2
			EndIf
		Next
	Next
	
	$sap_window_num = $sap_window_num_tmp
	Return $sess_found
EndFunc

; #FUNCTION# ;===============================================================================
;
; Name...........:	_SAPSessCreate()
; Description ...:	Creates a new session in SAP.
; Syntax.........:	_SAPSessCreate($sap_transaction = -1)
; Parameters ....:	$sap_transaction	- Optional: a SAP transaction to run in the new session.
; Return values .:	On Success			- Returns 1
;                 	On Failure			- Returns 0
; Author ........:	seangriffin
; Modified.......: 
; Remarks .......:	A prerequisite is that the function "_SAPSessAttach" has already been executed.
; Related .......: 
; Link ..........: 
; Example .......:	Yes
;
; ;==========================================================================================
func _SAPSessCreate($sap_transaction = -1)

	$sap_num_sess_old = $sap_connection.Sessions.Count
	$sap_session.CreateSession
	while $sap_connection.Sessions.Count = $sap_num_sess_old
	WEnd
	$sap_session = $sap_connection.Children($sap_connection.Sessions.Count - 1)

	$sap_session.findById("wnd[0]").maximize

	if $sap_transaction <> -1 Then
	
		$sap_session.findById("wnd[0]/tbar[0]/okcd").Text = $sap_transaction
		$sap_session.findById("wnd[0]").sendVKey(0)
	EndIf
	
	Return 1
EndFunc

; #FUNCTION# ;===============================================================================
;
; Name...........:	_SAPVKeysSend()
; Description ...:	Sends virtual keys to the currently attached session of SAP.
; Syntax.........:	_SAPVKeysSend($vkeys)
; Parameters ....:	$vkeys		- A comma-seperated sequence of virtual keys to send to the currently attached session of SAP.
;									Refer to the global variable "$sap_vkey" at the top of this script for a list of virtual keys.
; Return values .:	On Success	- Returns 1
;                 	On Failure	- Returns 0
; Author ........:	seangriffin
; Modified.......: 
; Remarks .......:	A prerequisite is that the function "_SAPSessAttach" has already been executed.
; Related .......: 
; Link ..........: 
; Example .......:	Yes
;
; ;==========================================================================================
Func _SAPVKeysSend($vkeys)

	$vkey = StringSplit($vkeys, ",")
	
	$first_key_part = True
	$skip_send = False
	
	for $vkey_part in $vkey

		If $first_key_part = True Then
			
			$first_key_part = False
		Else

			$vkey_id = _ArraySearch($sap_vkey, $vkey_part)
			$sap_session.findById("wnd[" & $sap_window_num & "]").sendVKey($vkey_id)
		EndIf
	Next
	
	Return 1
EndFunc

; #FUNCTION# ;===============================================================================
;
; Name...........:	_SAPVKeysSendUntilWinExists()
; Description ...:	Sends virtual keys to the currently attached session of SAP until another SAP window exists
; Syntax.........:	_SAPVKeysSendUntilWinExists($keys, $win_title)
; Parameters ....:	$keys		- The sequence of keys to repeatedly send until the $win_title appears.
;									See the function "_SAPSendVKeys" for more information.
;				  	$win_title	- The title of the SAP window to wait for.
;									This may be a substring of the full window title.
; Return values .:	On Success	- Returns 1
;                 	On Failure	- Returns 0
; Author ........:	seangriffin
; Modified.......:	
; Remarks .......:	A prerequisite is that the function "_SAPSessAttach" has already been executed.
; Related .......:	
; Link ..........: 
; Example .......:	Yes
;
; ;==========================================================================================
Func _SAPVKeysSendUntilWinExists($keys, $win_title)

	while _SAPWinExists($win_title) = False
	
		_SAPVKeysSend($keys)
	WEnd

	Return 1
EndFunc

; #FUNCTION# ;===============================================================================
;
; Name...........:	_SAPObjDeselect()
; Description ...:	Deselects an object within the currently attached session of SAP.
; Syntax.........:	_SAPObjDeselect($object_id)
; Parameters ....:	$object_id	- The short ID of the object to deselect.
;									An object's ID is determined using the SAP Scripting Wizard.
;									In SAP, select the "Customize Local Layout" button on the toolbar, 
;									then "Script Development Tools".  Select "Do a hit test on the window".
;									Move your mouse to the object you want the ID of.
;									Click "Copy Id" in the Scripting Wizard.
;									Paste this ID into this variable in your script, then remove all text
;									upto and including "wnd[n]/".
; Return values .:	On Success	- Returns 1
;                 	On Failure	- Returns 0
; Author ........:	seangriffin
; Modified.......:	
; Remarks .......:	A prerequisite is that the function "_SAPSessAttach" has already been executed.
;					This function currently supports the following SAP objects:
;						GuiCheckBox
;						GuiLabel
; Related .......:	
; Link ..........: 
; Example .......:	No
;
; ;==========================================================================================
func _SAPObjDeselect($object_id)

	$sap_object_id = $object_id

	Select

		; GuiCheckBox
		Case 	StringInStr($object_id, "/rad") > 0 Or _
				StringInStr($object_id, "/chk") > 0
	
			$sap_session.findById("wnd[" & $sap_window_num & "]/" & $object_id).selected = False

		; GuiLabel
		Case 	StringInStr($object_id, "/lbl") > 0
	
			; If the GuiLabel is not a collapsed twistie, then select it (for a GuiLabel twistie, this will collapse it)
			if StringCompare($sap_session.findById("wnd[" & $sap_window_num & "]/" & $object_id).text, "4") <> 0 Then

				$sap_session.findById("wnd[" & $sap_window_num & "]/" & $object_id).setFocus
				$sap_session.findById("wnd[" & $sap_window_num & "]/" & $object_id).caretPosition = 1
				_SAPVKeysSend("F2")
			EndIf
	EndSelect

	Return 1
EndFunc

; #FUNCTION# ;===============================================================================
;
; Name...........:	_SAPObjSelect()
; Description ...:	Selects an object within the currently attached session of SAP.
; Syntax.........:	_SAPObjSelect($object_id)
; Parameters ....:	$object_id	- The short ID of the object to select.
;									An object's ID is determined using the SAP Scripting Wizard.
;									In SAP, select the "Customize Local Layout" button on the toolbar, 
;									then "Script Development Tools".  Select "Do a hit test on the window".
;									Move your mouse to the object you want the ID of.
;									Click "Copy Id" in the Scripting Wizard.
;									Paste this ID into this variable in your script, then remove all text
;									upto and including "wnd[n]/".
; Return values .:	On Success	- Returns 1
;                 	On Failure	- Returns 0
; Author ........:	seangriffin
; Modified.......:	
; Remarks .......:	A prerequisite is that the function "_SAPSessAttach" has already been executed.
;					This function currently supports the following SAP objects:
;						GuiButton
;						GuiRadioButton
;						GuiCheckBox
;						GuiMenubar
;						GuiLabel
; Related .......:	
; Link ..........: 
; Example .......:	Yes
;
; ;==========================================================================================
func _SAPObjSelect($object_id)

	$sap_object_id = $object_id

	Select

		; GuiButtons
		Case 	StringInStr($object_id, "/btn") > 0
	
			$sap_session.findById("wnd[" & $sap_window_num & "]/" & $object_id).press

		; GuiRadioButton
		Case 	StringInStr($object_id, "/rad") > 0
	
			$sap_session.findById("wnd[" & $sap_window_num & "]/" & $object_id).select

		; GuiCheckBox
		Case 	StringInStr($object_id, "/rad") > 0 Or _
				StringInStr($object_id, "/chk") > 0
	
			$sap_session.findById("wnd[" & $sap_window_num & "]/" & $object_id).selected = True

		; GuiMenubar
		Case 	StringInStr($object_id, "mbar/") > 0
	
			$sap_session.findById("wnd[" & $sap_window_num & "]/" & $object_id).select

		; GuiLabel
		Case 	StringInStr($object_id, "/lbl") > 0
	
			; If the GuiLabel is not an expanded twistie, then select it (for a GuiLabel twistie, this will expand it)
			if StringCompare($sap_session.findById("wnd[" & $sap_window_num & "]/" & $object_id).text, "5") <> 0 Then

				$sap_session.findById("wnd[" & $sap_window_num & "]/" & $object_id).setFocus
				$sap_session.findById("wnd[" & $sap_window_num & "]/" & $object_id).caretPosition = 1
				_SAPVKeysSend("F2")
			EndIf
	EndSelect

	Return 1
EndFunc

; #FUNCTION# ;===============================================================================
;
; Name...........:	_SAPObjValueSet()
; Description ...:	Sets the value of an object within the currently attached session of SAP.
; Syntax.........:	_SAPObjValueSet($object_id, $sap_object_value)
; Parameters ....:	$object_id		- The short ID of the object to set the value of.
;										An object's ID is determined using the SAP Scripting Wizard.
;										In SAP, select the "Customize Local Layout" button on the toolbar, 
;										then "Script Development Tools".  Select "Do a hit test on the window".
;										Move your mouse to the object you want the ID of.
;										Click "Copy Id" in the Scripting Wizard.
;										Paste this ID into this variable in your script, then remove all text
;										upto and including "wnd[n]/".
;					$object_value	- The value to set the SAP object to.
; Return values .:	On Success		- Returns 1
;                 	On Failure		- Returns 0
; Author ........:	seangriffin
; Modified.......:	
; Remarks .......:	A prerequisite is that the function "_SAPSessAttach" has already been executed.
;					This function currently supports the following SAP objects:
;						GuiComboBox
;						GuiCheckBox
;						GuiCTextField
;						GuiOkCodeField
;						GuiPasswordField
;						GuiTextField
; Related .......:	
; Link ..........: 
; Example .......:	Yes
;
; ;==========================================================================================
func _SAPObjValueSet($object_id, $object_value)

	$sap_object_id = $object_id
	$sap_object_value = $object_value

	Select

		; Set the key property for GuiComboBoxes
		Case 	StringInStr($object_id, "/cmb") > 0
	
			$sap_session.findById("wnd[" & $sap_window_num & "]/" & $object_id).key = $object_value

		; Set the text property for all other Simple Visual Objects
		Case 	StringInStr($object_id, "/chk") > 0 Or _
				StringInStr($object_id, "/ctxt") > 0 Or _
				StringInStr($object_id, "/okcd") > 0 Or _
				StringInStr($object_id, "/pwd") > 0 Or _
				StringInStr($object_id, "/txt") > 0
		
			$sap_session.findById("wnd[" & $sap_window_num & "]/" & $object_id).text = $object_value
	
	EndSelect

	Return 1
EndFunc
	
; #FUNCTION# ;===============================================================================
;
; Name...........:	_SAPObjValueGet()
; Description:		Get the value of an object within the currently attached session of SAP.
; Syntax.........:	_SAPObjValueGet($object_id)
; Parameters ....:	$object_id	- Optional: The short ID of the object to get the value of.
;									The GuiUserArea ("usr") will be used if one is not provided.
;									An object's ID is determined using the SAP Scripting Wizard.
;									In SAP, select the "Customize Local Layout" button on the toolbar, 
;									then "Script Development Tools".  Select "Do a hit test on the window".
;									Move your mouse to the object you want the ID of.
;									Click "Copy Id" in the Scripting Wizard.
;									Paste this ID into this variable in your script, then remove all text
;									upto and including "wnd[n]/".
; Return values .:	On Success	- Returns the value/text of the object.
;									This is a String value for all objects except GuiUserAreas,
;									and a String Array for GuiUserAreas.
;                 	On Failure	- Returns 0
; Author ........:	seangriffin
; Modified.......:	
; Remarks .......:	A prerequisite is that the function "_SAPSessAttach" has already been executed.
;					This function currently supports the following SAP objects:
;						GuiComboBox
;						GuiButton
;						GuiCheckBox
;						GuiCTextField
;						GuiLabel
;						GuiOkCodeField
;						GuiPasswordField
;						GuiRadioButton
;						GuiStatusBar
;						GuiTextField
;						GuiUserArea
; Related .......:	
; Link ..........: 
; Example .......:	Yes
;
; ;==========================================================================================
func _SAPObjValueGet($object_id = "usr")

	$sap_object_id = $object_id

	Select

		; Get the key property for GuiComboBoxes
		Case 	StringInStr($object_id, "/cmb") > 0
	
			return $sap_session.findById("wnd[" & $sap_window_num & "]/" & $object_id).key

		; Get the text property for all other Simple Visual Objects
		Case 	StringInStr($object_id, "/btn") > 0 Or _
				StringInStr($object_id, "/chk") > 0 Or _
				StringInStr($object_id, "/ctxt") > 0 Or _
				StringInStr($object_id, "/lbl") > 0 Or _
				StringInStr($object_id, "/okcd") > 0 Or _
				StringInStr($object_id, "/pwd") > 0 Or _
				StringInStr($object_id, "/rad") > 0 Or _
				StringInStr($object_id, "/sbar") > 0 Or _
				StringInStr($object_id, "/txt") > 0
		
			return $sap_session.findById("wnd[" & $sap_window_num & "]/" & $object_id).text
			
		; Get the text property for all the children of the GuiUserArea
		Case	StringCompare($object_id, "usr") = 0
			
			$object_children = $sap_session.findById("wnd[" & $sap_window_num & "]/" & $object_id).Children

			; Get the character extents for the GuiUserArea
			$max_charleft = 0
			$max_chartop = 0

			For $object_child In $object_children


				if $object_child.CharLeft > $max_charleft Then $max_charleft = $object_child.CharLeft
				if $object_child.CharTop > $max_chartop Then $max_chartop = $object_child.CharTop
			Next

			; Create an output array based on the character extents of the GuiUserArea
			dim $child_text[$max_chartop+1][$max_charleft+1]

			; Build the output array based on character positions of all the children.
			For $object_child In $object_children

				$child_text[$object_child.CharTop][$object_child.CharLeft] = $object_child.Text
			Next

			return $child_text
	EndSelect

	Return 0

EndFunc

; #FUNCTION# ;===============================================================================
;
; Name...........:	_SAPObjFindByValue()
; Description:		Find a SAP object based on it's value.
; Syntax.........:	_SAPObjFindByValue($object_id = "usr", $object_value = "", $match_type = 0, $instance = 1, $object_offset = 0)
; Parameters ....:	$object_id		- Optional: The short ID of the object to find the object within.
;										The GuiUserArea ("usr") will be used if one is not provided.
;										An object's ID is determined using the SAP Scripting Wizard.
;										In SAP, select the "Customize Local Layout" button on the toolbar, 
;										then "Script Development Tools".  Select "Do a hit test on the window".
;										Move your mouse to the object you want the ID of.
;										Click "Copy Id" in the Scripting Wizard.
;										Paste this ID into this variable in your script, then remove all text
;										upto and including "wnd[n]/".
;					$object_value	- The value of the object to find.
;					$match_type		- Optional: How to match the value of the object to find.
;										0 = match on the full string value of the object
;										1 = match on a sub-string in the value of the object
;					$instance		- Optional: The instance to return, should there be more than one object matched.
;										The first instance will be returned if this is not provided.
;					$object_offset	- Optional: An offset to the object to return.
;										No offset will be used if this is not provided.
; Return values .:	On Success		- Returns the short ID of the object found.
;										If an $object_offset was provided, then the short ID of the offsetted object is returned instead.
;                 	On Failure		- Returns 0
; Author ........:	seangriffin
; Modified.......:	
; Remarks .......:	A prerequisite is that the function "_SAPSessAttach" has already been executed.
;					This function currently supports the following SAP objects:
;						GuiComboBox
;						GuiButton
;						GuiCheckBox
;						GuiCTextField
;						GuiLabel
;						GuiOkCodeField
;						GuiPasswordField
;						GuiRadioButton
;						GuiStatusBar
;						GuiTextField
;						GuiUserArea
; Related .......:	
; Link ..........: 
; Example .......:	No
;
; ;==========================================================================================
func _SAPObjFindByValue($object_id = "usr", $object_value = "", $match_type = 0, $instance = 1, $object_offset = 0)

	$sap_object_id = $object_id
	$sap_object_value = $object_value
			
	$object_children = $sap_session.findById("wnd[" & $sap_window_num & "]/" & $object_id).Children

	$object_found = False

	for $i = 1 to $object_children.Count
		
		if $match_type = 0 And StringCompare($object_children.item($i).text, $object_value) = 0 then $object_found = True
		if $match_type = 1 And StringInStr($object_children.item($i).text, $object_value) > 0 then $object_found = True
		if $object_found = True	then 
			
			$instance = $instance - 1
			
			if $instance > 0 Then
				
				$object_found = False
			Else
			
				ExitLoop
			EndIf
		EndIf
	Next

	if $object_found = True	then
		
		$object_id_new = $object_children.item($i + $object_offset).id
		$object_id_new = StringMid($object_id_new, StringInStr($object_id_new, "/wnd[") + 5)
		$object_id_new = StringMid($object_id_new, StringInStr($object_id_new, "/") + 1)
		
		return $object_id_new
	EndIf

	Return 0
EndFunc

; #FUNCTION# ;===============================================================================
;
; Name...........:	_SAPObjPropertySet()
; Description ...:	Sets the value of an object within the currently attached session of SAP.
; Syntax.........:	_SAPObjPropertySet($object_id, $object_property, $object_value)
; Parameters ....:	$object_id			- The short ID of the object to set the property of.
;											An object's ID is determined using the SAP Scripting Wizard.
;											In SAP, select the "Customize Local Layout" button on the toolbar, 
;											then "Script Development Tools".  Select "Do a hit test on the window".
;											Move your mouse to the object you want the ID of.
;											Click "Copy Id" in the Scripting Wizard.
;											Paste this ID into this variable in your script, then remove all text
;											upto and including "wnd[n]/".
;					$object_property	- The property to set.
;					$object_value		- The value to set the property to.
; Return values .:	On Success			- Returns 1
;                 	On Failure			- Returns 0
; Author ........:	seangriffin
; Modified.......:	
; Remarks .......:	A prerequisite is that the function "_SAPSessAttach" has already been executed.
;					This function currently supports the following SAP objects:
;						GuiComboBox
;						GuiButton
;						GuiCheckBox
;						GuiCTextField
;						GuiLabel
;						GuiOkCodeField
;						GuiPasswordField
;						GuiRadioButton
;						GuiStatusBar
;						GuiTextField
;						GuiCtrlGridView
; Related .......:	
; Link ..........: 
; Example .......:	Yes
;
; ;==========================================================================================
func _SAPObjPropertySet($object_id, $object_property, $object_value)

	$sap_object_id = $object_id
	$sap_object_value = $object_value

	Select
		
		; Properties for all GuiComponents and GuiVComponents
		Case	StringCompare($object_property, "text") = 0

			$sap_session.findById("wnd[" & $sap_window_num & "]/" & $object_id).text = $object_value

		; Properties for specific components
		Case	StringInStr($object_id, "/chk") > 0 And _
				StringCompare($object_property, "selected") = 0

			$sap_session.findById("wnd[" & $sap_window_num & "]/" & $object_id).selected = $object_value

		Case	(StringInStr($object_id, "/lbl") > 0 Or _
				StringInStr($object_id, "/txt") > 0) And _
				StringCompare($object_property, "caretPosition") = 0

			$sap_session.findById("wnd[" & $sap_window_num & "]/" & $object_id).caretPosition = $object_value

		Case	StringInStr($object_id, "/cmb") > 0 And _
				StringCompare($object_property, "key") = 0

			$sap_session.findById("wnd[" & $sap_window_num & "]/" & $object_id).key = $object_value

		Case	StringInStr($object_id, "/cmb") > 0 And _
				StringCompare($object_property, "value") = 0

			$sap_session.findById("wnd[" & $sap_window_num & "]/" & $object_id).value = $object_value
			
		Case	StringInStr($object_id, "/okcd") > 0 And _
				StringCompare($object_property, "opened") = 0

			$sap_session.findById("wnd[" & $sap_window_num & "]/" & $object_id).opened = $object_value

		Case	StringInStr($object_id, "/cntlGRID") > 0 And _
				StringCompare($object_property, "currentCellRow") = 0

			$sap_session.findById("wnd[" & $sap_window_num & "]/" & $object_id).currentCellRow = $object_value

		Case	StringInStr($object_id, "/cntlGRID") > 0 And _
				StringCompare($object_property, "currentCellColumn") = 0

			$sap_session.findById("wnd[" & $sap_window_num & "]/" & $object_id).currentCellColumn = $object_value

		Case	StringInStr($object_id, "/cntlGRID") > 0 And _
				StringCompare($object_property, "selectedColumns") = 0

			$sap_session.findById("wnd[" & $sap_window_num & "]/" & $object_id).selectedColumns = $object_value

		Case	StringInStr($object_id, "/cntlGRID") > 0 And _
				StringCompare($object_property, "selectedRows") = 0

			$sap_session.findById("wnd[" & $sap_window_num & "]/" & $object_id).selectedRows = $object_value

		Case	StringInStr($object_id, "/cntlGRID") > 0 And _
				StringCompare($object_property, "selectedCells") = 0

			$sap_session.findById("wnd[" & $sap_window_num & "]/" & $object_id).selectedCells = $object_value

		Case	StringInStr($object_id, "/cntlGRID") > 0 And _
				StringCompare($object_property, "firstVisibleRow") = 0

			$sap_session.findById("wnd[" & $sap_window_num & "]/" & $object_id).firstVisibleRow = $object_value

		Case	StringInStr($object_id, "/cntlGRID") > 0 And _
				StringCompare($object_property, "firstVisibleColumn") = 0

			$sap_session.findById("wnd[" & $sap_window_num & "]/" & $object_id).firstVisibleColumn = $object_value

		Case	StringInStr($object_id, "/cntlGRID") > 0 And _
				StringCompare($object_property, "columnOrder") = 0

			$sap_session.findById("wnd[" & $sap_window_num & "]/" & $object_id).columnOrder = $object_value

	EndSelect

	Return 1
EndFunc
	
; #FUNCTION# ;===============================================================================
;
; Name...........:	_SAPObjPropertyGet()
; Description:		Get the value of property of an object within the currently attached session of SAP.
; Syntax.........:	_SAPObjPropertyGet($object_id, $object_property)
; Parameters ....:	$object_id			- The short ID of the object to get the property of.
;											An object's ID is determined using the SAP Scripting Wizard.
;											In SAP, select the "Customize Local Layout" button on the toolbar, 
;											then "Script Development Tools".  Select "Do a hit test on the window".
;											Move your mouse to the object you want the ID of.
;											Click "Copy Id" in the Scripting Wizard.
;											Paste this ID into this variable in your script, then remove all text
;											upto and including "wnd[n]/".
;					$object_property	- The property to get.
; Return values .:	On Success			- Returns the value of the property of the object
;                 	On Failure			- Returns 0
; Author ........:	seangriffin
; Modified.......:	
; Remarks .......:	A prerequisite is that the function "_SAPSessAttach" has already been executed.
;					This function currently supports the following SAP objects:
;						GuiComboBox
;						GuiButton
;						GuiCheckBox
;						GuiCTextField
;						GuiLabel
;						GuiOkCodeField
;						GuiPasswordField
;						GuiRadioButton
;						GuiStatusBar
;						GuiTextField
;						GuiCtrlGridView
; Related .......:	
; Link ..........: 
; Example .......:	Yes
;
; ;==========================================================================================
func _SAPObjPropertyGet($object_id, $object_property)

	$sap_object_id = $object_id

	Select

		; Properties for all GuiComponents and GuiVComponents
		Case	StringCompare($object_property, "id") = 0

			return $sap_session.findById("wnd[" & $sap_window_num & "]/" & $object_id).id

		Case	StringCompare($object_property, "type") = 0

			return $sap_session.findById("wnd[" & $sap_window_num & "]/" & $object_id).type

		Case	StringCompare($object_property, "typeAsNumber") = 0

			return $sap_session.findById("wnd[" & $sap_window_num & "]/" & $object_id).typeAsNumber

		Case	StringCompare($object_property, "containerType") = 0

			return $sap_session.findById("wnd[" & $sap_window_num & "]/" & $object_id).containerType

		Case	StringCompare($object_property, "name") = 0

			return $sap_session.findById("wnd[" & $sap_window_num & "]/" & $object_id).name

		Case	StringCompare($object_property, "parent") = 0

			return $sap_session.findById("wnd[" & $sap_window_num & "]/" & $object_id).parent

		Case	StringCompare($object_property, "text") = 0

			return $sap_session.findById("wnd[" & $sap_window_num & "]/" & $object_id).text

		Case	StringCompare($object_property, "tooltip") = 0

			return $sap_session.findById("wnd[" & $sap_window_num & "]/" & $object_id).tooltip

		Case	StringCompare($object_property, "changeable") = 0

			return $sap_session.findById("wnd[" & $sap_window_num & "]/" & $object_id).changeable

		Case	StringCompare($object_property, "modified") = 0

			return $sap_session.findById("wnd[" & $sap_window_num & "]/" & $object_id).modified

		Case	StringCompare($object_property, "iconName") = 0

			return $sap_session.findById("wnd[" & $sap_window_num & "]/" & $object_id).iconName

		; Properties for specific components
		Case	(StringInStr($object_id, "/rad") > 0 Or _
				StringInStr($object_id, "/chk") > 0) And _
				StringCompare($object_property, "selected") = 0

			return $sap_session.findById("wnd[" & $sap_window_num & "]/" & $object_id).selected

		Case	(StringInStr($object_id, "/lbl") > 0 Or _
				StringInStr($object_id, "/txt") > 0) And _
				StringCompare($object_property, "maxLength") = 0

			return $sap_session.findById("wnd[" & $sap_window_num & "]/" & $object_id).maxLength

		Case	(StringInStr($object_id, "/lbl") > 0 Or _
				StringInStr($object_id, "/txt") > 0) And _
				StringCompare($object_property, "numerical") = 0

			return $sap_session.findById("wnd[" & $sap_window_num & "]/" & $object_id).numerical

		Case	(StringInStr($object_id, "/lbl") > 0 Or _
				StringInStr($object_id, "/txt") > 0) And _
				StringCompare($object_property, "caretPosition") = 0

			return $sap_session.findById("wnd[" & $sap_window_num & "]/" & $object_id).caretPosition

		Case	(StringInStr($object_id, "/lbl") > 0 Or _
				StringInStr($object_id, "/txt") > 0) And _
				StringCompare($object_property, "highlighted") = 0

			return $sap_session.findById("wnd[" & $sap_window_num & "]/" & $object_id).highlighted

		Case	StringInStr($object_id, "/txt") > 0 And _
				StringCompare($object_property, "required") = 0

			return $sap_session.findById("wnd[" & $sap_window_num & "]/" & $object_id).required

		Case	StringInStr($object_id, "/cmb") > 0 And _
				StringCompare($object_property, "entries") = 0

			return $sap_session.findById("wnd[" & $sap_window_num & "]/" & $object_id).entries

		Case	StringInStr($object_id, "/cmb") > 0 And _
				StringCompare($object_property, "key") = 0

			return $sap_session.findById("wnd[" & $sap_window_num & "]/" & $object_id).key

		Case	StringInStr($object_id, "/cmb") > 0 And _
				StringCompare($object_property, "value") = 0

			return $sap_session.findById("wnd[" & $sap_window_num & "]/" & $object_id).value
			
		Case	StringInStr($object_id, "/cmb") > 0 And _
				StringCompare($object_property, "required") = 0

			return $sap_session.findById("wnd[" & $sap_window_num & "]/" & $object_id).required
			
		Case	StringInStr($object_id, "/okcd") > 0 And _
				StringCompare($object_property, "opened") = 0

			return $sap_session.findById("wnd[" & $sap_window_num & "]/" & $object_id).opened
			
		Case	StringInStr($object_id, "/sbar") > 0 And _
				StringCompare($object_property, "messageType") = 0

			return $sap_session.findById("wnd[" & $sap_window_num & "]/" & $object_id).messageType
			
		Case	StringInStr($object_id, "/sbar") > 0 And _
				StringCompare($object_property, "messageId") = 0

			return $sap_session.findById("wnd[" & $sap_window_num & "]/" & $object_id).messageId
			
		Case	StringInStr($object_id, "/sbar") > 0 And _
				StringCompare($object_property, "messageNumber") = 0

			return $sap_session.findById("wnd[" & $sap_window_num & "]/" & $object_id).messageNumber
			
		Case	StringInStr($object_id, "/sbar") > 0 And _
				StringCompare($object_property, "messageParameter") = 0

			return $sap_session.findById("wnd[" & $sap_window_num & "]/" & $object_id).messageParameter
			
		Case	StringInStr($object_id, "/sbar") > 0 And _
				StringCompare($object_property, "messageAsPopup") = 0

			return $sap_session.findById("wnd[" & $sap_window_num & "]/" & $object_id).messageAsPopup

		Case	StringInStr($object_id, "/cntlGRID") > 0 And _
				StringCompare($object_property, "subType") = 0

			return $sap_session.findById("wnd[" & $sap_window_num & "]/" & $object_id).subType

		Case	StringInStr($object_id, "/cntlGRID") > 0 And _
				StringCompare($object_property, "currentCellRow") = 0

			return $sap_session.findById("wnd[" & $sap_window_num & "]/" & $object_id).currentCellRow

		Case	StringInStr($object_id, "/cntlGRID") > 0 And _
				StringCompare($object_property, "currentCellColumn") = 0

			return $sap_session.findById("wnd[" & $sap_window_num & "]/" & $object_id).currentCellColumn

		Case	StringInStr($object_id, "/cntlGRID") > 0 And _
				StringCompare($object_property, "selectedColumns") = 0

			return $sap_session.findById("wnd[" & $sap_window_num & "]/" & $object_id).selectedColumns

		Case	StringInStr($object_id, "/cntlGRID") > 0 And _
				StringCompare($object_property, "selectedRows") = 0

			return $sap_session.findById("wnd[" & $sap_window_num & "]/" & $object_id).selectedRows

		Case	StringInStr($object_id, "/cntlGRID") > 0 And _
				StringCompare($object_property, "selectedCells") = 0

			return $sap_session.findById("wnd[" & $sap_window_num & "]/" & $object_id).selectedCells

		Case	StringInStr($object_id, "/cntlGRID") > 0 And _
				StringCompare($object_property, "columnCount") = 0

			return $sap_session.findById("wnd[" & $sap_window_num & "]/" & $object_id).columnCount

		Case	StringInStr($object_id, "/cntlGRID") > 0 And _
				StringCompare($object_property, "rowCount") = 0

			return $sap_session.findById("wnd[" & $sap_window_num & "]/" & $object_id).rowCount

		Case	StringInStr($object_id, "/cntlGRID") > 0 And _
				StringCompare($object_property, "frozenColumnCount") = 0

			return $sap_session.findById("wnd[" & $sap_window_num & "]/" & $object_id).frozenColumnCount

		Case	StringInStr($object_id, "/cntlGRID") > 0 And _
				StringCompare($object_property, "firstVisibleRow") = 0

			return $sap_session.findById("wnd[" & $sap_window_num & "]/" & $object_id).firstVisibleRow

		Case	StringInStr($object_id, "/cntlGRID") > 0 And _
				StringCompare($object_property, "firstVisibleColumn") = 0

			return $sap_session.findById("wnd[" & $sap_window_num & "]/" & $object_id).firstVisibleColumn

		Case	StringInStr($object_id, "/cntlGRID") > 0 And _
				StringCompare($object_property, "columnOrder") = 0

			return $sap_session.findById("wnd[" & $sap_window_num & "]/" & $object_id).columnOrder

		Case	StringInStr($object_id, "/cntlGRID") > 0 And _
				StringCompare($object_property, "toolbarButtonCount") = 0

			return $sap_session.findById("wnd[" & $sap_window_num & "]/" & $object_id).toolbarButtonCount

		Case	StringInStr($object_id, "/cntlGRID") > 0 And _
				StringCompare($object_property, "selectionMode") = 0

			return $sap_session.findById("wnd[" & $sap_window_num & "]/" & $object_id).selectionMode

		Case	StringInStr($object_id, "/cntlGRID") > 0 And _
				StringCompare($object_property, "visibleRowCount") = 0

			return $sap_session.findById("wnd[" & $sap_window_num & "]/" & $object_id).visibleRowCount

	EndSelect

	Return 0

EndFunc

; #FUNCTION# ;===============================================================================
;
; Name...........:	_SAPWinExists()
; Description ...:	Checks for the existance of a SAP window.
; Syntax.........:	_SAPWinExists($win_title)
; Parameters ....:	$win_title				- The title of the SAP window to check the existance of.
;												This may be a substring of the full window title.
; Return values .:	Window exists			- Returns True
;                 	Window does not exist	- Returns False
; Author ........:	seangriffin
; Modified.......:	
; Remarks .......:	A prerequisite is that the function "_SAPSessAttach" has already been executed.
; Related .......:	
; Link ..........: 
; Example .......:	Yes
;
; ;==========================================================================================
func _SAPWinExists($win_title)

	; Check each session for the $sap_title
	for $sap_sess_num = 0 to ($sap_connection.Sessions.Count - 1)

		$sap_sess = $sap_connection.Children($sap_sess_num)

		; Check each window in each session for the $sap_title
		for $sap_window_num_tmp = 0 to ($sap_sess.Children.Count - 1)

			if StringRegExp($sap_sess.findById("wnd[" & $sap_window_num_tmp & "]").Text, ".*" & $win_title & ".*") = 1 Then

				Return True
			EndIf
		Next
	Next
	
	return False
EndFunc

; #FUNCTION# ;===============================================================================
;
; Name...........:	_SAPWinClose()
; Description ...:	Closes a SAP window.
; Syntax.........:	_SAPWinClose($win_title)
; Parameters ....:	$win_title	- The title of the SAP window to close.
;									This may be a substring of the full window title.
; Return values .:	On Success	- Returns 1
;                 	On Failure	- Returns 0
; Author ........:	seangriffin
; Modified.......:	
; Remarks .......:	A prerequisite is that the function "_SAPSessAttach" has already been executed.
; Related .......:	
; Link ..........: 
; Example .......:	Yes
;
; ;==========================================================================================
func _SAPWinClose($win_title)

	; Check each session for the $sap_title
	for $sap_sess_num = 0 to ($sap_connection.Sessions.Count - 1)

		$sap_sess = $sap_connection.Children($sap_sess_num)

		; Check each window in each session for the $sap_title
		for $sap_window_num_tmp = 0 to ($sap_sess.Children.Count - 1)

			if StringRegExp($sap_sess.findById("wnd[" & $sap_window_num_tmp & "]").Text, ".*" & $win_title & ".*") = 1 Then

				$sap_sess.findById("wnd[" & $sap_window_num_tmp & "]").close
				return True
			EndIf
		Next
	Next
	
	return False
EndFunc

; #FUNCTION# ;===============================================================================
;
; Name...........:	_SAPErrorHandlerRegister()
; Description ...:	Register and enable a SAP COM error handler.
; Syntax.........:	_SAPWinClose($win_title)
; Parameters ....:	$win_title	- The title of the SAP window to close.
;									This may be a substring of the full window title.
; Return values .:	On Success	- Returns 1
;                 	On Failure	- Returns 0
; Author ........:	seangriffin
; Modified.......:	
; Remarks .......:	A prerequisite is that the function "_SAPSessAttach" has already been executed.
; Related .......:	
; Link ..........: 
; Example .......:	No
;
; ;==========================================================================================
Func _SAPErrorHandlerRegister($s_functionName = "__SAPInternalErrorHandler")
	
	$sSAPUserErrorHandler = $s_functionName
	$oSAPErrorHandler = ""
	$oSAPErrorHandler = ObjEvent("AutoIt.Error", $s_functionName)
	
	If IsObj($oSAPErrorHandler) Then
	
		SetError(0)
		Return 1
	Else
		
		SetError(0, 1)
		Return 0
	EndIf
EndFunc

; #FUNCTION# ;===============================================================================
;
; Name...........:	__SAPInternalErrorHandler()
; Description ...:	A SAP COM error handler.
; Syntax.........:	__SAPInternalErrorHandler()
; Parameters ....:
; Return values .:	On Success	- Returns 1
;                 	On Failure	- Returns 0
; Author ........:	seangriffin
; Modified.......:	
; Remarks .......:
; Related .......:	
; Link ..........: 
; Example .......:	No
;
; ;==========================================================================================
Func __SAPInternalErrorHandler()
	$SAPComErrorScriptline = $oSAPErrorHandler.scriptline
	$SAPComErrorNumber = $oSAPErrorHandler.number
	$SAPComErrorNumberHex = Hex($oSAPErrorHandler.number, 8)
	$SAPComErrorDescription = StringStripWS($oSAPErrorHandler.description, 2)
	$SAPComErrorWinDescription = StringStripWS($oSAPErrorHandler.WinDescription, 2)
	$SAPComErrorSource = $oSAPErrorHandler.Source
	$SAPComErrorHelpFile = $oSAPErrorHandler.HelpFile
	$SAPComErrorHelpContext = $oSAPErrorHandler.HelpContext
	$SAPComErrorLastDllError = $oSAPErrorHandler.LastDllError
	$SAPComErrorOutput = ""
	$SAPComErrorOutput &= "--> COM Error Encountered in " & @ScriptName & @CRLF
	$SAPComErrorOutput &= "----> $SAPObjectID = " & $sap_object_id & @CRLF
	$SAPComErrorOutput &= "----> $SAPObjectValue = " & $sap_object_value & @CRLF
	$SAPComErrorOutput &= "----> $SAPComErrorScriptline = " & $SAPComErrorScriptline & @CRLF
	$SAPComErrorOutput &= "----> $SAPComErrorNumberHex = " & $SAPComErrorNumberHex & @CRLF
	$SAPComErrorOutput &= "----> $SAPComErrorNumber = " & $SAPComErrorNumber & @CRLF
	$SAPComErrorOutput &= "----> $SAPComErrorWinDescription = " & $SAPComErrorWinDescription & @CRLF
	$SAPComErrorOutput &= "----> $SAPComErrorDescription = " & $SAPComErrorDescription & @CRLF
	$SAPComErrorOutput &= "----> $SAPComErrorSource = " & $SAPComErrorSource & @CRLF
	$SAPComErrorOutput &= "----> $SAPComErrorHelpFile = " & $SAPComErrorHelpFile & @CRLF
	$SAPComErrorOutput &= "----> $SAPComErrorHelpContext = " & $SAPComErrorHelpContext & @CRLF
	$SAPComErrorOutput &= "----> $SAPComErrorLastDllError = " & $SAPComErrorLastDllError & @CRLF
	ConsoleWrite($SAPComErrorOutput & @CRLF)
	SetError(0)
	Return
EndFunc


