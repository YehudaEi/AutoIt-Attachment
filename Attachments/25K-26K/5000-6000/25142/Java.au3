#include-once
#Include <Array.au3>
#Include <GuiComboBox.au3>
#Include <GuiListBox.au3>
#Include <Tesseract.au3>
#Region Header
#cs
	Title:   		Java Automation UDF Library for AutoIt3
	Filename:  		Java.au3
	Description: 	A collection of functions for creating, attaching to, reading from and manipulating Java applications
	Author:   		seangriffin
	Version:  		V0.7
	Last Update: 	17/03/09
	Requirements: 	AutoIt3 3.2 or higher,
					Java Runtime Environment (JRE) 1.4 or above,
					Java Access Bridge for the Microsoft Windows Operating System,
					Microsoft Visual C++ 2008 Redistributable,
					AutoIT for Java Access dynamically linked library (DLL)
					Tesseract UDF 0.6
					Manual check and update of the Java Access Bridge
	Changelog:		---------26/01/09---------- v0.1
					Initial release.
					
					---------01/02/09---------- v0.2
					Added combo box and list box support to all functions.
					Added function "_JavaObjValuesGet".
					Added function "_JavaObjDeselect".
					
					---------17/02/09---------- v0.3
					Fixed Java listbox and combobox suuport in _JavaObjValuesGet.
					Parameters changed for _JavaObjValuesGet.
					Added a dependency on the Tesseract UDF 0.4.
					
					---------22/02/09---------- v0.4
					Fixed Java listbox and combobox suuport in _JavaObjValueSet.
					Added a dependency on the Tesseract UDF 0.5.
					
					---------23/02/09---------- v0.5
					Added function "_JavaObjPropertyGet".
					
					---------15/03/09---------- v0.6
					Added more properties to function "_JavaObjPropertyGet".
					Bug fixed in AutoITJavaAccess.dll function JavaObjSelect where
						action name of "Click" was not recognised.  Previously only
						"click" (with lowercase "c" was recognised).
					AutoITJavaAccess.dll function JavaObjValueSet enhanced to return
						more information about the success of setting text.
					Function _JavaObjValueSet improved to use the new JavaObjValueSet
						return values, and use AutoIT's ControlSend function if 
						JavaObjValueSet can set focus but not set text.
					Added WinWait to function _JavaAttachAndWait.
					Fixed AutoITJavaAccess.dll function findAccessibleContext to
						handle Java windows with more than 256 Java objects.
					Updated function "_JavaObjValueSet" to wait for the value
						to be displayed before continuing.
					Added function "_JavaObjIndexGet".  Useful as input into function
						_JavaObjValueSet.
					Added greater support to the integer form of $object_value 
						in _JavaObjValueSet.
					Added function "_JavaTableRowSelect".
					Added function "_JavaTableCellSelect".
					Added function "_JavaTableCellValueGet".
					Added function "_JavaTableCellValueSet".
					
					---------17/03/09---------- v0.7
					Modified function "_JavaAttachAndWait" to move WinWait before
						WinGetHandle.
					Changed a dependency to Tesseract UDF 0.6.
#ce
#EndRegion Header
#Region Global Variables and Constants
Global $java_hwnd
Global $cntl_hwnd
#EndRegion Global Variables and Constants
#Region Core functions
; #FUNCTION# ;===============================================================================
;
; Name...........:	_JavaAttachAndWait()
; Description ...:	Attaches to a Java window.
; Syntax.........:	_JavaAttachAndWait($win_title)
; Parameters ....:	$win_title			- The title of the Java window to attach to.
;											This may be a substring of the full window title.
; Return values .: 	On Success			- Returns True. 
;                 	On Failure			- Returns False, and:
;											sets @ERROR = 1 if unable to find the Java window.
;							
; Author ........:	seangriffin
; Modified.......: 
; Remarks .......:	
; Related .......: 
; Link ..........: 
; Example .......:	No
;
; ;==========================================================================================
func _JavaAttachAndWait($win_title)

	WinWait($win_title)

	$java_hwnd = WinGetHandle($win_title)

	Return True
EndFunc

; #FUNCTION# ;===============================================================================
;
; Name...........:	_JavaObjValueGet()
; Description:		Get the value of a Java object within the currently attached Java window.
; Syntax.........:	_JavaObjValueGet($autoit_cntl_id, $javaferret_obj_name = "", $javaferret_obj_role = "", $instance_num = 1)
; Parameters ....:	$autoit_cntl_id			- Optional: The AutoIT control ID of the object to get the value of.
;												If this is not used, then $javaferret_obj_name and/or $javaferret_obj_role must be set.
;					$javaferret_obj_name	- Optional: The JavaFerret name of the object to get the value of.
;												If this is not used, then $instance_num must be set.
;					$javaferret_obj_role	- Optional: The JavaFerret role of the object to get the value of.
;												If this is not used, then $autoit_cntl_id must be set.
;					$instance_num			- Optional: The number of the instance to get the value of.
; Return values .:	On Success	- Returns the value/text of the object.
;                 	On Failure	- Returns 0
; Author ........:	seangriffin
; Modified.......:	
; Remarks .......:	A prerequisite is that the function "_JavaAttachAndWait" has already been executed.
;					This function currently supports the following Java objects:
;						labels
;						push buttons
;						check boxes
;						text (boxes)
;						page tab lists
;						panels
;						combo boxes
;						list (boxes)
;						radio buttons
; Related .......:	
; Link ..........: 
; Example .......:	Yes
;
; ;==========================================================================================
func _JavaObjValueGet($autoit_cntl_id, $javaferret_obj_name = "", $javaferret_obj_role = "", $instance_num = 1)

	; If an AutoIT control ID is provided
	if StringCompare($autoit_cntl_id, "") <> 0 Then
		
		$cntl_hwnd = ControlGetHandle($java_hwnd, "", $autoit_cntl_id)

		; Try and get the values of the Java object using the Java Access bridge.
		$sss = DllCall("AutoITJavaAccess.dll", "str:cdecl", "JavaObjValueGet", "hwnd", $cntl_hwnd, "str", $javaferret_obj_name, "str", $javaferret_obj_role, "int", $instance_num)

		; A result of "" indicates that the Java Access Bridge was unable to get values from the Java object.
		if StringCompare($sss[0], "") = 0 Then
			
			; Combo boxes
			if StringCompare($javaferret_obj_role, "combo box") = 0 Then
		
				return _GUICtrlComboBox_GetEditText($cntl_hwnd)
			EndIf

			; List boxes
			if StringCompare($javaferret_obj_role, "list") = 0 Then
		
				Return _GUICtrlListBox_GetText($cntl_hwnd, _GUICtrlListBox_GetCurSel($cntl_hwnd))
			EndIf
		EndIf
	Else

		; A JavaFerret object is provided
		$sss = DllCall("AutoITJavaAccess.dll", "str:cdecl", "JavaObjValueGet", "hwnd", $java_hwnd, "str", $javaferret_obj_name, "str", $javaferret_obj_role, "int", $instance_num)
	EndIf

	Switch @error
		
		case 1
		
			ConsoleWrite("check AutoITJavaAccess.dll exists" & @CRLF)
			Exit
	EndSwitch

	Return $sss[0]
EndFunc

; #FUNCTION# ;===============================================================================
;
; Name...........:	_JavaObjValuesGet()
; Description:		Get multiple values from a Java object within the currently attached Java window.
; Syntax.........:	_JavaObjValueGet($autoit_cntl_id, $javaferret_obj_name = "", $javaferret_obj_role = "", $instance_num = 1)
; Parameters ....:	$autoit_cntl_id			- Optional: The AutoIT control ID of the object to get the values of.
;												If this is not used, then $javaferret_obj_name and/or $javaferret_obj_role must be set.
;					$javaferret_obj_name	- Optional: The JavaFerret name of the object to get the values of.
;												If this is not used, then $instance_num must be set.
;					$javaferret_obj_role	- Optional: The JavaFerret role of the object to get the values of.
;												If this is not used, then $autoit_cntl_id must be set.
;					$instance_num			- Optional: The number of the instance to get the values of.
;
;					Note:- The following parameters apply to Java list boxes and combo boxes that have an
;							$autoit_cntl_id supplied.  They should be ignored for all other objects.
;
;					$get_last_capture		- Optional: Retrieve the values of the object last time this function was called.
;												0 = do not retrieve the last set of values (default)
;												1 = retrieve the last set of values
;					$delimiter				- Optional: The string that delimits values in the object.
;												A string of text will be returned if this isn't provided.
;												An array of delimited values will be returned if this is provided.
;												Eg. Use @CRLF to return the items of a listbox as an array.
;					$expand					- Optional: Expand the control before getting values from it?
;												0 = do not expand the control
;												1 = expand the control (default)
;					$scrolling				- Optional: Scroll the control to get all it's values?
;												0 = do not scroll the control
;												1 = scroll the control (default)
;					$cleanup				- Optional: Remove invalid text in the values recognised
;												0 = do not remove invalid text
;												1 = remove invalid text (default)
;					$max_scroll_times		- Optional: The maximum number of scrolls to get the values in a control
;												If a control has a very long scroll bar, the
;												process will take too long.  Use this value to restrict
;												the number of values to get in a long control.
;					$scale					- Optional: The scaling factor to use in recognising the values to get.
;												Increase this number to improve accuracy.
;												The default is 2.
;					$left_indent			- Optional: A number of pixels to indent from the left of the object
;												to improve recognition of the values in the object.
;					$top_indent				- Optional: A number of pixels to indent from the top of the object
;												to improve recognition of the values in the object.
;					$right_indent			- Optional: A number of pixels to indent from the right of the object
;												to improve recognition of the values in the object.
;					$bottom_indent			- Optional: A number of pixels to indent from the bottom of the object
;												to improve recognition of the values in the object.
;					$show_capture			- Optional: Display a screenshot of the object and the values
;												captured (for debugging purposes).
;												0 = do not display the screenshot of the object (default)
;												1 = display the screenshot of the object
; Return values .:	On Success	- Returns the value/text of the object.
;                 	On Failure	- Returns 0
; Author ........:	seangriffin
; Modified.......:	
; Remarks .......:	A prerequisite is that the function "_JavaAttachAndWait" has already been executed.
;					This function currently supports the following Java objects:
;						combo boxes
;						list (boxes)
; Related .......:	
; Link ..........: 
; Example .......:	Yes
;
; ;==========================================================================================
func _JavaObjValuesGet($autoit_cntl_id, $javaferret_obj_name = "", $javaferret_obj_role = "", $instance_num = 1, $get_last_capture = 0, $delimiter = "", $expand = 1, $scrolling = 1, $cleanup = 1, $max_scroll_times = 5, $scale = 2, $left_indent = 0, $top_indent = 0, $right_indent = 0, $bottom_indent = 0, $show_capture = 0)

	; If an AutoIT control ID is provided
	if StringCompare($autoit_cntl_id, "") <> 0 Then
		
		$cntl_hwnd = ControlGetHandle($java_hwnd, "", $autoit_cntl_id)

		; Try and get the values of the Java object using the Java Access bridge.
		$sss = DllCall("AutoITJavaAccess.dll", "str:cdecl", "JavaObjValuesGet", "hwnd", $cntl_hwnd, "str", $javaferret_obj_name, "str", $javaferret_obj_role, "int", $instance_num)

		; A result of "", or an AutoIT control ID that is a listbox or combobox, indicates that the Java Access Bridge was unable to get values from the Java object.
		if StringCompare($sss[0], "") = 0 or (StringCompare($autoit_cntl_id, "") <> 0 and (StringCompare($javaferret_obj_role, "combo box") = 0 or StringCompare($javaferret_obj_role, "list") = 0)) Then
			
			; Combo boxes
			if StringCompare($javaferret_obj_role, "combo box") = 0 Then

				return _TesseractControlCapture($java_hwnd, "", $autoit_cntl_id, $get_last_capture, $delimiter, $expand, $scrolling, $cleanup, $max_scroll_times, $scale, $left_indent, $top_indent, $right_indent, $bottom_indent, $show_capture)
			EndIf

			; List boxes
			if StringCompare($javaferret_obj_role, "list") = 0 Then

				return _TesseractControlCapture($java_hwnd, "", $autoit_cntl_id, $get_last_capture, $delimiter, $expand, $scrolling, $cleanup, $max_scroll_times, $scale, $left_indent, $top_indent, $right_indent, $bottom_indent, $show_capture)
			EndIf
		EndIf
	Else

		; A JavaFerret object is provided
		$sss = DllCall("AutoITJavaAccess.dll", "str:cdecl", "JavaObjValuesGet", "hwnd", $java_hwnd, "str", $javaferret_obj_name, "str", $javaferret_obj_role, "int", $instance_num)
		$new = StringSplit($sss[0], @CRLF, 1)
		Return $new
	EndIf

	Switch @error
		
		case 1
		
			ConsoleWrite("check AutoITJavaAccess.dll exists" & @CRLF)
			Exit
	EndSwitch

	Return $sss[0]
EndFunc

; #FUNCTION# ;===============================================================================
;
; Name...........:	_JavaObjIndexGet()
; Description:		Get the index of the selection of a Java object within the currently attached Java window.
; Syntax.........:	_JavaObjIndexGet($autoit_cntl_id, $javaferret_obj_name = "", $javaferret_obj_role = "", $instance_num = 1)
; Parameters ....:	$autoit_cntl_id			- Optional: The AutoIT control ID of the object to get the index of.
;												If this is not used, then $javaferret_obj_name and/or $javaferret_obj_role must be set.
;					$javaferret_obj_name	- Optional: The JavaFerret name of the object to get the index of.
;												If this is not used, then $instance_num must be set.
;					$javaferret_obj_role	- Optional: The JavaFerret role of the object to get the index of.
;												If this is not used, then $autoit_cntl_id must be set.
;					$instance_num			- Optional: The number of the instance to get the index of.
; Return values .:	On Success	- Returns the 0-based index of the selection of the object.
;                 	On Failure	- Returns 0
; Author ........:	seangriffin
; Modified.......:	
; Remarks .......:	A prerequisite is that the function "_JavaAttachAndWait" has already been executed.
;					This function currently supports the following Java objects:
;						combo boxes
;						list (boxes)
;					The output of this function is useful as input to the function "_JavaObjValueSet"
;						in the parameter "$object_value".
; Related .......:	
; Link ..........: 
; Example .......:	No
;
; ;==========================================================================================
func _JavaObjIndexGet($autoit_cntl_id, $javaferret_obj_name = "", $javaferret_obj_role = "", $instance_num = 1)

	; If an AutoIT control ID is provided
	if StringCompare($autoit_cntl_id, "") <> 0 Then
		
		$cntl_hwnd = ControlGetHandle($java_hwnd, "", $autoit_cntl_id)

		; Try and get the values of the Java object using the Java Access bridge.
		$sss = DllCall("AutoITJavaAccess.dll", "int:cdecl", "JavaObjIndexGet", "hwnd", $java_hwnd, "str", $javaferret_obj_name, "str", $javaferret_obj_role, "int", $instance_num)

		; A result of "" indicates that the Java Access Bridge was unable to get values from the Java object.
		if StringCompare($sss[0], "") = 0 Then
			
			; Combo boxes
			if StringCompare($javaferret_obj_role, "combo box") = 0 Then
		
				return _GUICtrlComboBox_GetEditText($cntl_hwnd)
			EndIf

			; List boxes
			if StringCompare($javaferret_obj_role, "list") = 0 Then
		
				Return _GUICtrlListBox_GetText($cntl_hwnd, _GUICtrlListBox_GetCurSel($cntl_hwnd))
			EndIf
		EndIf
	Else

		; A JavaFerret object is provided
		$sss = DllCall("AutoITJavaAccess.dll", "int:cdecl", "JavaObjIndexGet", "hwnd", $java_hwnd, "str", $javaferret_obj_name, "str", $javaferret_obj_role, "int", $instance_num)
	EndIf

	Switch @error
		
		case 1
		
			ConsoleWrite("check AutoITJavaAccess.dll exists" & @CRLF)
			Exit
	EndSwitch

	Return $sss[0]
EndFunc

; #FUNCTION# ;===============================================================================
;
; Name...........:	_JavaObjValueSet()
; Description:		Set the value of a Java object within the currently attached Java window.
; Syntax.........:	_JavaObjValueSet($autoit_cntl_id, $javaferret_obj_name, $javaferret_obj_role, $object_value, $instance_num = 1, $partial = 1, $get_last_capture = 0, $delimiter = "", $expand = 1, $scrolling = 1, $cleanup = 1, $max_scroll_times = 5, $scale = 2, $left_indent = 0, $top_indent = 0, $right_indent = 0, $bottom_indent = 0, $show_capture = 0)
; Parameters ....:	$autoit_cntl_id			- Optional: The AutoIT control ID of the object to set the value for.
;												If this is not used, then $javaferret_obj_name and/or $javaferret_obj_role must be set.
;					$javaferret_obj_name	- Optional: The JavaFerret name of the object to set the value for.
;												If this is not used, then $instance_num must be set.
;					$javaferret_obj_role	- Optional: The JavaFerret role of the object to set the value for.
;												If this is not used, then $autoit_cntl_id must be set.
;					$object_value			- The value to set the object to.
;												If this is a number, and $javaferret_obj_role is a "combo box" or "list",
;													then this is the index of the item to select.
;												If this is a string, and $javaferret_obj_role is a "combo box" or "list",
;													then this is the text of the item to select.
;					$instance_num			- Optional: The number of the instance to set the value for.
;					$wait_for_value			- Optional: A value to wait for the existence of in the Java object
;												before continuing.  This is useful in cases where this function ends
;												to quickly, and the Java Virtual Machine has not had time to 
;												place $object_value in the Java object.
;
;					Note:- The following parameters apply to Java list boxes and combo boxes with a non-numeric
;							$object_value supplied.  They should be ignored for all other objects.
;
;					$partial				- Optional: Find the value on a partial match?
;												0 = select the value based on a full text match
;												1 = select the value based on a partial text match
;					$get_last_capture		- Optional: Retrieve the values of the object last time this function was called.
;												0 = do not retrieve the last set of values (default)
;												1 = retrieve the last set of values
;					$delimiter				- Optional: The string that delimits values in the object.
;												A string of text will be returned if this isn't provided.
;												An array of delimited values will be returned if this is provided.
;												Eg. Use @CRLF to return the items of a listbox as an array.
;					$expand					- Optional: Expand the control before setting it's value?
;												0 = do not expand the control
;												1 = expand the control (default)
;					$scrolling				- Optional: Scroll the control to set it's value?
;												0 = do not scroll the control
;												1 = scroll the control (default)
;					$cleanup				- Optional: Remove invalid text in the values recognised
;												0 = do not remove invalid text
;												1 = remove invalid text (default)
;					$max_scroll_times		- Optional: The maximum number of scrolls to get the values in a control
;												If a control has a very long scroll bar, the
;												process will take too long.  Use this value to restrict
;												the number of values to get in a long control.
;					$scale					- Optional: The scaling factor to use in recognising the values.
;												Increase this number to improve accuracy.
;												The default is 2.
;					$left_indent			- Optional: A number of pixels to indent from the left of the object
;												to improve recognition of the values in the object.
;					$top_indent				- Optional: A number of pixels to indent from the top of the object
;												to improve recognition of the values in the object.
;					$right_indent			- Optional: A number of pixels to indent from the right of the object
;												to improve recognition of the values in the object.
;					$bottom_indent			- Optional: A number of pixels to indent from the bottom of the object
;												to improve recognition of the values in the object.
;					$show_capture			- Optional: Display a screenshot of the object and the values
;												captured (for debugging purposes).
;												0 = do not display the screenshot of the object (default)
;												1 = display the screenshot of the object
; Return values .:	On Success				- Returns 1
;                 	On Failure				- Returns 0
; Author ........:	seangriffin
; Modified.......:	
; Remarks .......:	A prerequisite is that the function "_JavaAttachAndWait" has already been executed.
;					This function currently supports the following Java objects:
;						text (boxes)
;						combo boxes
;						list (boxes)
;					The output of function "_JavaObjIndexGet" can be used as input into the parameter "$object_value".
; Related .......:	
; Link ..........: 
; Example .......:	Yes
;
; ;==========================================================================================
func _JavaObjValueSet($autoit_cntl_id, $javaferret_obj_name, $javaferret_obj_role, $object_value = "", $instance_num = 1, $wait_for_value = "", $partial = 1, $get_last_capture = 0, $delimiter = "", $expand = 1, $scrolling = 1, $cleanup = 1, $max_scroll_times = 5, $scale = 2, $left_indent = 0, $top_indent = 0, $right_indent = 0, $bottom_indent = 0, $show_capture = 0)

	; If an AutoIT control ID is provided
	if StringCompare($autoit_cntl_id, "") <> 0 Then
		
		$cntl_hwnd = ControlGetHandle($java_hwnd, "", $autoit_cntl_id)

		; Try and set the value of the Java object using the Java Access bridge.
		$sss = DllCall("AutoITJavaAccess.dll", "int:cdecl", "JavaObjValueSet", "hwnd", $cntl_hwnd, "str", $javaferret_obj_name, "str", $javaferret_obj_role, "str", $object_value, "int", $instance_num)

		; A result of 0 indicates that the Java Access Bridge was unable to set the value of the Java object.
		if $sss[0] = 0 Then

			; Combo boxes
			if StringCompare($javaferret_obj_role, "combo box") = 0 Then
		
				if IsInt($object_value) Then

					_GUICtrlComboBox_SetCurSel($cntl_hwnd, ($object_value-1))
					return 1
				Else
					
					$object_index = _TesseractControlFind($java_hwnd, "", $autoit_cntl_id, $object_value, $partial, $get_last_capture, $delimiter, $expand, $scrolling, $cleanup, $max_scroll_times, $scale, $left_indent, $top_indent, $right_indent, $bottom_indent, $show_capture)
					_GUICtrlComboBox_SetCurSel($cntl_hwnd, $object_index)
					Return 1
				EndIf
			EndIf
			
			; List (boxes)
			if StringCompare($javaferret_obj_role, "list") = 0 Then
		
				if IsInt($object_value) Then
				
					_GUICtrlListBox_SetCurSel($cntl_hwnd, ($object_value-1))
					Return 1
				Else
					
					$object_index = _TesseractControlFind($java_hwnd, "", $autoit_cntl_id, $object_value, $partial, $get_last_capture, $delimiter, $expand, $scrolling, $cleanup, $max_scroll_times, $scale, $left_indent, $top_indent, $right_indent, $bottom_indent, $show_capture)
					_GUICtrlListBox_SetCurSel($cntl_hwnd, $object_index)
					Return 1
				EndIf
			EndIf
			
			; Other Java Objects
			ControlSetText($java_hwnd, "", $cntl_hwnd, $object_value)
		EndIf
	Else

		; A JavaFerret object is provided

		if IsInt($object_value) Then

			$sss = DllCall("AutoITJavaAccess.dll", "int:cdecl", "JavaObjValueSet2", "hwnd", $java_hwnd, "str", $javaferret_obj_name, "str", $javaferret_obj_role, "int", $object_value, "int", $instance_num)
		Else
			
			$sss = DllCall("AutoITJavaAccess.dll", "int:cdecl", "JavaObjValueSet", "hwnd", $java_hwnd, "str", $javaferret_obj_name, "str", $javaferret_obj_role, "str", $object_value, "int", $instance_num)
		EndIf
		
		; JavaObjValueSet return values
		; 0 = no error
		; 1 = request focus failed
		; 2 = set text failed
		; 3 = request focus & set text failed
		
		; if set text failed, however request focus passed
		if $sss[0] = 2 Then
			
			ControlSend($java_hwnd, "", "", "{HOME}{SHIFTDOWN}{END}{SHIFTUP}" & $object_value)

			; For slow user interfaces.
			;	Wait until the java object displays the value before continuing.
			if StringCompare($wait_for_value, "") <> 0 Then
			
				$JavaObjValueGet_timer = TimerInit()
				while StringCompare(_JavaObjValueGet($autoit_cntl_id, $javaferret_obj_name, $javaferret_obj_role, $instance_num), $wait_for_value) <> 0 and TimerDiff($JavaObjValueGet_timer) < 20000
					
					sleep(500)
				WEnd
			EndIf
		EndIf
		
;		ConsoleWrite($sss[0])
;		Exit
		
	EndIf

	Switch @error
		
		case 1
		
			ConsoleWrite("check AutoITJavaAccess.dll exists" & @CRLF)
			Exit
	EndSwitch

	Return 1;
EndFunc

; #FUNCTION# ;===============================================================================
;
; Name...........:	_JavaObjSelect()
; Description:		Selects a Java object within the currently attached Java window.
; Syntax.........:	_JavaObjSelect($autoit_cntl_id, $javaferret_obj_name = "", $javaferret_obj_role = "", $instance_num = 1)
; Parameters ....:	$autoit_cntl_id			- Optional: The AutoIT control ID of the object to select.
;												If this is not used, then $javaferret_obj_name and/or $javaferret_obj_role must be set.
;					$javaferret_obj_name	- Optional: The JavaFerret name of the object to select.
;												If this is not used, then $instance_num must be set.
;					$javaferret_obj_role	- Optional: The JavaFerret role of the object to select.
;												If this is not used, then $autoit_cntl_id must be set.
;					$instance_num			- Optional: The number of the instance to select.
; Return values .:	On Success				- Returns 1.
;                 	On Failure				- Returns 0.
; Author ........:	seangriffin
; Modified.......:	
; Remarks .......:	A prerequisite is that the function "_JavaAttachAndWait" has already been executed.
;					This function currently supports the following Java objects:
;						push buttons
;						check boxes
;						radio buttons
;						combo boxes
;						menu
;						menu item
;
;					For Java applets in Internet Explorer, the ControlCommand function "Check" and 
;						"Uncheck" functions does not produce any noticable result with checkboxes (even with prior 
;						WinActivate or ControlFocus calls issued).
; Related .......:	
; Link ..........: 
; Example .......:	No
;
; ;==========================================================================================
func _JavaObjSelect($autoit_cntl_id, $javaferret_obj_name = "", $javaferret_obj_role = "", $instance_num = 1)

	; If an AutoIT control ID is provided
	if StringCompare($autoit_cntl_id, "") <> 0 Then
		
		$cntl_hwnd = ControlGetHandle($java_hwnd, "", $autoit_cntl_id)

		; Try and select the Java object using the Java Access bridge.
		$sss = DllCall("AutoITJavaAccess.dll", "int:cdecl", "JavaObjSelect", "hwnd", $cntl_hwnd, "str", $javaferret_obj_name, "str", $javaferret_obj_role, "int", $instance_num)
		
		; A result of 0 indicates that the Java Access Bridge was unable to select the Java object.
		if $sss[0] = 0 Then

			; Combo boxes
			if StringCompare($javaferret_obj_role, "combo box") = 0 Then
		
				ControlCommand($java_hwnd, "", $cntl_hwnd, "ShowDropDown", "")
			EndIf

			; Check boxes
			if StringCompare($javaferret_obj_role, "check box") = 0 Then

				; Loop until the Java Access Bridge reports that the checkbox in unchecked.
				; Note that ControlCommand "IsChecked" does not seem to work with Java applets.
				while StringCompare(_JavaObjValueGet($autoit_cntl_id), "unchecked") = 0

					; All the following three commands are the only way I am able to toggle applet checkboxes.
					; I cannot find a Java Access Bridge function to toggle applet checkboxes.
					WinActivate($java_hwnd)
					ControlFocus($java_hwnd, "", $cntl_hwnd)
					ControlSend($java_hwnd, "", $cntl_hwnd, " ")
					WinWait($java_hwnd)
				WEnd
			EndIf
		EndIf
	Else

		$sss = DllCall("AutoITJavaAccess.dll", "int:cdecl", "JavaObjSelect", "hwnd", $java_hwnd, "str", $javaferret_obj_name, "str", $javaferret_obj_role, "int", $instance_num)
	EndIf

	Switch @error
		
		case 1
		
			ConsoleWrite("check AutoITJavaAccess.dll exists" & @CRLF)

		case 2
		
			ConsoleWrite("check AutoITJavaAccess.dll exists" & @CRLF)

		case 3
		
			ConsoleWrite("Function ""JavaObjSelect"" not found in ""AutoITJavaAccess.dll""" & @CRLF)

	EndSwitch


	Return 1;

EndFunc

; #FUNCTION# ;===============================================================================
;
; Name...........:	_JavaObjDeselect()
; Description:		Deselects a Java object within the currently attached Java window.
; Syntax.........:	_JavaObjSelect($autoit_cntl_id, $javaferret_obj_name = "", $javaferret_obj_role = "", $instance_num = 1)
; Parameters ....:	$autoit_cntl_id			- Optional: The AutoIT control ID of the object to deselect.
;												If this is not used, then $javaferret_obj_name and/or $javaferret_obj_role must be set.
;					$javaferret_obj_name	- Optional: The JavaFerret name of the object to deselect.
;												If this is not used, then $instance_num must be set.
;					$javaferret_obj_role	- Optional: The JavaFerret role of the object to deselect.
;												If this is not used, then $autoit_cntl_id must be set.
;					$instance_num			- Optional: The number of the instance to deselect.
; Return values .:	On Success				- Returns 1.
;                 	On Failure				- Returns 0.
; Author ........:	seangriffin
; Modified.......:	
; Remarks .......:	A prerequisite is that the function "_JavaAttachAndWait" has already been executed.
;					This function currently supports the following Java objects:
;						push buttons
;						check boxes
;						radio buttons
;						combo boxes
;
;					For Java applets in Internet Explorer, the ControlCommand function "Check" and 
;						"Uncheck" functions does not produce any noticable result with checkboxes (even with prior 
;						WinActivate or ControlFocus calls issued).
; Related .......:	
; Link ..........: 
; Example .......:	No
;
; ;==========================================================================================
func _JavaObjDeselect($autoit_cntl_id, $javaferret_obj_name = "", $javaferret_obj_role = "", $instance_num = 1)

	; If an AutoIT control ID is provided
	if StringCompare($autoit_cntl_id, "") <> 0 Then
		
		$cntl_hwnd = ControlGetHandle($java_hwnd, "", $autoit_cntl_id)

		; Try and select the Java object using the Java Access bridge.
		$sss = DllCall("AutoITJavaAccess.dll", "int:cdecl", "JavaObjDeselect", "hwnd", $cntl_hwnd, "str", $javaferret_obj_name, "str", $javaferret_obj_role, "int", $instance_num)
		
		; A result of 0 indicates that the Java Access Bridge was unable to deselect the Java object.
		if $sss[0] = 0 Then

			; Combo boxes
			if StringCompare($javaferret_obj_role, "combo box") = 0 Then
		
				ControlCommand($java_hwnd, "", $cntl_hwnd, "HideDropDown", "")
			EndIf

			; Check boxes
			if StringCompare($javaferret_obj_role, "check box") = 0 Then

				; Loop until the Java Access Bridge reports that the checkbox in unchecked.
				; Note that ControlCommand "IsChecked" does not seem to work with Java applets.
				while StringCompare(_JavaObjValueGet($autoit_cntl_id), "unchecked") = 0

					; All the following three commands are the only way I am able to toggle applet checkboxes.
					; I cannot find a Java Access Bridge function to toggle applet checkboxes.
					WinActivate($java_hwnd)
					ControlFocus($java_hwnd, "", $cntl_hwnd)
					ControlSend($java_hwnd, "", $cntl_hwnd, " ")
					WinWait($java_hwnd)
				WEnd
			EndIf
		EndIf

;			$sss = DllCall("AutoITJavaAccess.dll", "int:cdecl", "JavaObjValueSet", "hwnd", $cntl_hwnd, "str", "", "str", "", "str", $object_value, "int", $instance_num)
	Else

		$sss = DllCall("AutoITJavaAccess.dll", "int:cdecl", "JavaObjDeselect", "hwnd", $java_hwnd, "str", $javaferret_obj_name, "str", $javaferret_obj_role, "int", $instance_num)
	EndIf

	Switch @error
		
		case 1
		
			ConsoleWrite("check AutoITJavaAccess.dll exists" & @CRLF)

		case 2
		
			ConsoleWrite("check AutoITJavaAccess.dll exists" & @CRLF)

		case 3
		
			ConsoleWrite("Function ""JavaObjSelect"" not found in ""AutoITJavaAccess.dll""" & @CRLF)

	EndSwitch


	Return 1;

EndFunc

; #FUNCTION# ;===============================================================================
;
; Name...........:	_JavaObjPropertyGet()
; Description:		Get the value of a property in a Java object within the currently attached Java window.
; Syntax.........:	_JavaObjPropertyGet($autoit_cntl_id, $javaferret_obj_name = "", $javaferret_obj_role = "", $instance_num = 1, $property_name = "")
; Parameters ....:	$autoit_cntl_id			- Optional: The AutoIT control ID of the object to get the property value of.
;												If this is not used, then $javaferret_obj_name and/or $javaferret_obj_role must be set.
;					$javaferret_obj_name	- Optional: The JavaFerret name of the object to get the property value of.
;												If this is not used, then $instance_num must be set.
;					$javaferret_obj_role	- Optional: The JavaFerret role of the object to get the property value of.
;												If this is not used, then $autoit_cntl_id must be set.
;					$instance_num			- Optional: The number of the instance to get the property value of.
;					$property_name			- The name of the property to get the value of.
;												See the "Remarks" section below for valid property names.
; Return values .:	On Success	- Returns the value/text of the property.
;                 	On Failure	- Returns 0
; Author ........:	seangriffin
; Modified.......:	
; Remarks .......:	A prerequisite is that the function "_JavaAttachAndWait" has already been executed.
;					This function currently supports the following properties:
;						Name
;						Description
;						Role
;						Role in en_US locale
;						States
;						States in en_US locale
;						Index in parent
;						Children count
;						Bounding rectangle
;						Top-level window name
;						Top-level window role
;						Parent name
;						Parent role
;						Visible descendents count
;						Number of actions
;						Action <n> name
;						Mouse point at text index
;						Caret at text index
;						Char count
;						Selection start index
;						Selection end index
;						Selected text
;						Character bounding rectangle
;						Line bounds
;						Character
;						Word
;						Sentence
;						Core attributes
;						Background color
;						Foreground color
;						Font family
;						Font size
;						First line indent
;						Left indent
;						Right indent
;						Line spacing
;						Space above
;						Space below
;						Full attribute string
;						Attribute run
; Related .......:	
; Link ..........: 
; Example .......:	Yes
;
; ;==========================================================================================
func _JavaObjPropertyGet($autoit_cntl_id, $javaferret_obj_name = "", $javaferret_obj_role = "", $instance_num = 1, $property_name = "")

	; If an AutoIT control ID is provided
	if StringCompare($autoit_cntl_id, "") <> 0 Then
		
		$cntl_hwnd = ControlGetHandle($java_hwnd, "", $autoit_cntl_id)

		; Try and get the property of the Java object using the Java Access bridge.
		$sss = DllCall("AutoITJavaAccess.dll", "str:cdecl", "JavaObjPropertyGet", "hwnd", $java_hwnd, "str", $javaferret_obj_name, "str", $javaferret_obj_role, "int", $instance_num, "str", $property_name)

		; A result of "" indicates that the Java Access Bridge was unable to get values from the Java object.
		if StringCompare($sss[0], "") = 0 Then

			if StringCompare($property_name, "Bounding rectangle") = 0 Then
			
				$cntl_pos = ControlGetPos($java_hwnd, "", $autoit_cntl_id)
				$sss[0] = _ArrayToString($cntl_pos, ",")
			EndIf

			; Combo boxes
			if StringCompare($javaferret_obj_role, "combo box") = 0 Then
		
				return _GUICtrlComboBox_GetEditText($cntl_hwnd)
			EndIf

			; List boxes
			if StringCompare($javaferret_obj_role, "list") = 0 Then
		
				Return _GUICtrlListBox_GetText($cntl_hwnd, _GUICtrlListBox_GetCurSel($cntl_hwnd))
			EndIf
		EndIf
	Else

		; A JavaFerret object is provided
		$sss = DllCall("AutoITJavaAccess.dll", "str:cdecl", "JavaObjPropertyGet", "hwnd", $java_hwnd, "str", $javaferret_obj_name, "str", $javaferret_obj_role, "int", $instance_num, "str", $property_name)
	EndIf

	Switch @error
		
		case 1
		
			ConsoleWrite("check AutoITJavaAccess.dll exists" & @CRLF)
			Exit
	EndSwitch

	Return $sss[0]
EndFunc

; #FUNCTION# ;===============================================================================
;
; Name...........:	_JavaTableRowSelect()
; Description:		Selects a row within a Java table within the currently attached Java window.
; Syntax.........:	_JavaTableRowSelect($autoit_cntl_id, $javaferret_obj_name = "", $instance_num = 1, $javaferret_panel_name = "", $panel_instance_num = 1, $col_names = "", $col_values = "")
; Parameters ....:	$autoit_cntl_id			- Optional: The AutoIT control ID of the table to select the row within.
;												If this is not used, then $javaferret_obj_name and/or $javaferret_obj_role must be set.
;					$javaferret_obj_name	- Optional: The JavaFerret name of the table to select the row within.
;												If this is not used, then $instance_num must be set.
;					$instance_num			- Optional: The instance of the table to select the row within.
;					$javaferret_panel_name	- The JavaFerret panel name containing the table headings.
;					$panel_instance_num		- Optional: The instance of the panel that contains the
;												table headings.
;					$col_names				- A comma seperated list of column names used to find the row to select.
;					$col_values				- A comma seperated list of cell values (for the column names provided
;												in $col_names) used to find the row to select.
; Return values .:	On Success				- Returns 1.
;                 	On Failure				- Returns 0.
; Author ........:	seangriffin
; Modified.......:	
; Remarks .......:	A prerequisite is that the function "_JavaAttachAndWait" has already been executed.
; Related .......:	
; Link ..........: 
; Example .......:	No
;
; ;==========================================================================================
func _JavaTableRowSelect($autoit_cntl_id, $javaferret_obj_name = "", $instance_num = 1, $javaferret_panel_name = "", $panel_instance_num = 1, $col_names = "", $col_values = "")

	; If an AutoIT control ID is provided
	if StringCompare($autoit_cntl_id, "") <> 0 Then
		
		$cntl_hwnd = ControlGetHandle($java_hwnd, "", $autoit_cntl_id)

		; Try and select the Java object using the Java Access bridge.
		$sss = DllCall("AutoITJavaAccess.dll", "int:cdecl", "JavaTableRowGet", "hwnd", $cntl_hwnd, "str", $javaferret_obj_name, "int", $instance_num)
		
		; A result of 0 indicates that the Java Access Bridge was unable to select the Java object.
		if $sss[0] = 0 Then

			; Combo boxes
			if StringCompare($javaferret_obj_role, "combo box") = 0 Then
		
				ControlCommand($java_hwnd, "", $cntl_hwnd, "ShowDropDown", "")
			EndIf

			; Check boxes
			if StringCompare($javaferret_obj_role, "check box") = 0 Then

				; Loop until the Java Access Bridge reports that the checkbox in unchecked.
				; Note that ControlCommand "IsChecked" does not seem to work with Java applets.
				while StringCompare(_JavaObjValueGet($autoit_cntl_id), "unchecked") = 0

					; All the following three commands are the only way I am able to toggle applet checkboxes.
					; I cannot find a Java Access Bridge function to toggle applet checkboxes.
					WinActivate($java_hwnd)
					ControlFocus($java_hwnd, "", $cntl_hwnd)
					ControlSend($java_hwnd, "", $cntl_hwnd, " ")
					WinWait($java_hwnd)
				WEnd
			EndIf
		EndIf
	Else

		$sss = DllCall("AutoITJavaAccess.dll", "int:cdecl", "JavaTableRowGet", "hwnd", $java_hwnd, "str", $javaferret_obj_name, "int", $instance_num, "str", $javaferret_panel_name, "int", $panel_instance_num, "str", $col_names, "str", $col_values)
		ConsoleWrite("r" & $sss[0])

		; Press the DOWN key the correct number of times to reach the row.
		if $sss[0] > 0 Then
			
			WinActivate($java_hwnd)
			ControlFocus($java_hwnd, "", "")
			ControlSend($java_hwnd, "", "", "{DOWN " & $sss[0] & "}")
		EndIf
	EndIf

	Switch @error
		
		case 1
		
			ConsoleWrite("check AutoITJavaAccess.dll exists" & @CRLF)

		case 2
		
			ConsoleWrite("check AutoITJavaAccess.dll exists" & @CRLF)

		case 3
		
			ConsoleWrite("Function ""JavaObjSelect"" not found in ""AutoITJavaAccess.dll""" & @CRLF)

	EndSwitch


	Return 1;

EndFunc

; #FUNCTION# ;===============================================================================
;
; Name...........:	_JavaTableCellSelect()
; Description:		Selects a cell within a Java table within the currently attached Java window.
; Syntax.........:	_JavaTableCellSelect($autoit_cntl_id, $javaferret_obj_name = "", $instance_num = 1, $javaferret_panel_name = "", $panel_instance_num = 1, $col_names = "", $col_values = "", $col_name_select = "")
; Parameters ....:	$autoit_cntl_id			- Optional: The AutoIT control ID of the table to select the cell within.
;												If this is not used, then $javaferret_obj_name and/or $javaferret_obj_role must be set.
;					$javaferret_obj_name	- Optional: The JavaFerret name of the table to select the cell within.
;												If this is not used, then $instance_num must be set.
;					$instance_num			- Optional: The instance of the table to select the cell within.
;					$javaferret_panel_name	- The JavaFerret panel name containing the table headings.
;					$panel_instance_num		- Optional: The instance of the panel that contains the
;												table headings.
;					$col_names				- A comma seperated list of column names used to find the row to select the cell within.
;					$col_values				- A comma seperated list of cell values (for the column names provided
;												in $col_names) used to find the row to select the cell within.
;					$col_name_select		- The column name of the cell to select.
; Return values .:	On Success				- Returns 1.
;                 	On Failure				- Returns 0.
; Author ........:	seangriffin
; Modified.......:	
; Remarks .......:	A prerequisite is that the function "_JavaAttachAndWait" has already been executed.
; Related .......:	
; Link ..........: 
; Example .......:	No
;
; ;==========================================================================================
func _JavaTableCellSelect($autoit_cntl_id, $javaferret_obj_name = "", $instance_num = 1, $javaferret_panel_name = "", $panel_instance_num = 1, $col_names = "", $col_values = "", $col_name_select = "")

	; If an AutoIT control ID is provided
	if StringCompare($autoit_cntl_id, "") <> 0 Then
		
		$cntl_hwnd = ControlGetHandle($java_hwnd, "", $autoit_cntl_id)

		; Try and select the Java object using the Java Access bridge.
		$sss = DllCall("AutoITJavaAccess.dll", "int:cdecl", "JavaObjSelect", "hwnd", $cntl_hwnd, "str", "", "str", "", "int", $instance_num)
		
		; A result of 0 indicates that the Java Access Bridge was unable to select the Java object.
		if $sss[0] = 0 Then

			; Combo boxes
			if StringCompare($javaferret_obj_role, "combo box") = 0 Then
		
				ControlCommand($java_hwnd, "", $cntl_hwnd, "ShowDropDown", "")
			EndIf

			; Check boxes
			if StringCompare($javaferret_obj_role, "check box") = 0 Then

				; Loop until the Java Access Bridge reports that the checkbox in unchecked.
				; Note that ControlCommand "IsChecked" does not seem to work with Java applets.
				while StringCompare(_JavaObjValueGet($autoit_cntl_id), "unchecked") = 0

					; All the following three commands are the only way I am able to toggle applet checkboxes.
					; I cannot find a Java Access Bridge function to toggle applet checkboxes.
					WinActivate($java_hwnd)
					ControlFocus($java_hwnd, "", $cntl_hwnd)
					ControlSend($java_hwnd, "", $cntl_hwnd, " ")
					WinWait($java_hwnd)
				WEnd
			EndIf
		EndIf
	Else

		$sss = DllCall("AutoITJavaAccess.dll", "int:cdecl", "JavaTableRowGet", "hwnd", $java_hwnd, "str", $javaferret_obj_name, "int", $instance_num, "str", $javaferret_panel_name, "int", $panel_instance_num, "str", $col_names, "str", $col_values)
		$sss2 = DllCall("AutoITJavaAccess.dll", "int:cdecl", "JavaTableColGet", "hwnd", $java_hwnd, "str", $javaferret_panel_name, "int", $panel_instance_num, "str", $col_name_select)

		; Press the DOWN key the correct number of times to reach the row.
		WinActivate($java_hwnd)
		ControlFocus($java_hwnd, "", "")
		ControlSend($java_hwnd, "", "", "{DOWN " & $sss[0] & "}")
		ControlSend($java_hwnd, "", "", "{RIGHT " & $sss2[0] & "}")
	EndIf

	Switch @error
		
		case 1
		
			ConsoleWrite("check AutoITJavaAccess.dll exists" & @CRLF)

		case 2
		
			ConsoleWrite("check AutoITJavaAccess.dll exists" & @CRLF)

		case 3
		
			ConsoleWrite("Function ""JavaObjSelect"" not found in ""AutoITJavaAccess.dll""" & @CRLF)

	EndSwitch


	Return 1;

EndFunc

; #FUNCTION# ;===============================================================================
;
; Name...........:	_JavaTableCellValueGet()
; Description:		Gets the value of a cell within a Java table within the currently attached Java window.
; Syntax.........:	_JavaTableCellValueGet($autoit_cntl_id, $javaferret_obj_name = "", $instance_num = 1, $javaferret_panel_name = "", $panel_instance_num = 1, $col_names = "", $col_values = "", $col_name_select = "")
; Parameters ....:	$autoit_cntl_id			- Optional: The AutoIT control ID of the table to get the value from.
;												If this is not used, then $javaferret_obj_name and/or $javaferret_obj_role must be set.
;					$javaferret_obj_name	- Optional: The JavaFerret name of the table to get the value from.
;												If this is not used, then $instance_num must be set.
;					$instance_num			- Optional: The instance of the table to get the value from.
;					$javaferret_panel_name	- The JavaFerret panel name containing the table headings.
;					$panel_instance_num		- Optional: The instance of the panel that contains the
;												table headings.
;					$col_names				- A comma seperated list of column names used to find the row to get the value from.
;					$col_values				- A comma seperated list of cell values (for the column names provided
;												in $col_names) used to find the row to get the value from.
;					$col_name_select		- The column name of the cell to get the value from.
; Return values .:	On Success				- The value of the cell.
;                 	On Failure				- Returns "".
; Author ........:	seangriffin
; Modified.......:	
; Remarks .......:	A prerequisite is that the function "_JavaAttachAndWait" has already been executed.
; Related .......:	
; Link ..........: 
; Example .......:	No
;
; ;==========================================================================================
func _JavaTableCellValueGet($autoit_cntl_id, $javaferret_obj_name = "", $instance_num = 1, $javaferret_panel_name = "", $panel_instance_num = 1, $col_names = "", $col_values = "", $col_name_select = "")

	; If an AutoIT control ID is provided
	if StringCompare($autoit_cntl_id, "") <> 0 Then
		
		$cntl_hwnd = ControlGetHandle($java_hwnd, "", $autoit_cntl_id)

		; Try and select the Java object using the Java Access bridge.
		$sss = DllCall("AutoITJavaAccess.dll", "int:cdecl", "JavaObjSelect", "hwnd", $cntl_hwnd, "str", "", "str", "", "int", $instance_num)
		
		; A result of 0 indicates that the Java Access Bridge was unable to select the Java object.
		if $sss[0] = 0 Then

			; Combo boxes
			if StringCompare($javaferret_obj_role, "combo box") = 0 Then
		
				ControlCommand($java_hwnd, "", $cntl_hwnd, "ShowDropDown", "")
			EndIf

			; Check boxes
			if StringCompare($javaferret_obj_role, "check box") = 0 Then

				; Loop until the Java Access Bridge reports that the checkbox in unchecked.
				; Note that ControlCommand "IsChecked" does not seem to work with Java applets.
				while StringCompare(_JavaObjValueGet($autoit_cntl_id), "unchecked") = 0

					; All the following three commands are the only way I am able to toggle applet checkboxes.
					; I cannot find a Java Access Bridge function to toggle applet checkboxes.
					WinActivate($java_hwnd)
					ControlFocus($java_hwnd, "", $cntl_hwnd)
					ControlSend($java_hwnd, "", $cntl_hwnd, " ")
					WinWait($java_hwnd)
				WEnd
			EndIf
		EndIf
	Else

		$sss = DllCall("AutoITJavaAccess.dll", "str:cdecl", "JavaTableCellGet", "hwnd", $java_hwnd, "str", $javaferret_obj_name, "int", $instance_num, "str", $javaferret_panel_name, "int", $panel_instance_num, "str", $col_names, "str", $col_values, "str", $col_name_select)
		
		; Some Java apps return the "Column Name" and "Value" in the cell name.
		;	Strip off these labels.
		if StringCompare(StringLeft($sss[0], 12), "Column Name ") = 0 Then
			
			$sss[0] = StringMid($sss[0], StringInStr($sss[0], " Value ") + StringLen(" Value "))
		EndIf
	EndIf

	Switch @error
		
		case 1
		
			ConsoleWrite("check AutoITJavaAccess.dll exists" & @CRLF)

		case 2
		
			ConsoleWrite("check AutoITJavaAccess.dll exists" & @CRLF)

		case 3
		
			ConsoleWrite("Function ""JavaObjSelect"" not found in ""AutoITJavaAccess.dll""" & @CRLF)

	EndSwitch


	Return $sss[0];

EndFunc

; #FUNCTION# ;===============================================================================
;
; Name...........:	_JavaTableCellValueSet()
; Description:		Sets the value of a cell within a Java table within the currently attached Java window.
; Syntax.........:	_JavaTableCellValueSet($autoit_cntl_id, $javaferret_obj_name = "", $instance_num = 1, $javaferret_panel_name = "", $panel_instance_num = 1, $col_names = "", $col_values = "", $col_name_select = "", $object_value = "")
; Parameters ....:	$autoit_cntl_id			- Optional: The AutoIT control ID of the table to set the value within.
;												If this is not used, then $javaferret_obj_name and/or $javaferret_obj_role must be set.
;					$javaferret_obj_name	- Optional: The JavaFerret name of the table to set the value within.
;												If this is not used, then $instance_num must be set.
;					$instance_num			- Optional: The instance of the table to set the value within.
;					$javaferret_panel_name	- The JavaFerret panel name containing the table headings.
;					$panel_instance_num		- Optional: The instance of the panel that contains the
;												table headings.
;					$col_names				- A comma seperated list of column names used to find the row to get the value from.
;					$col_values				- A comma seperated list of cell values (for the column names provided
;												in $col_names) used to find the row to set the value within.
;					$col_name_select		- The column name of the cell to set the value of.
; Return values .:	On Success				- Returns 1.
;                 	On Failure				- Returns 0.
; Author ........:	seangriffin
; Modified.......:	
; Remarks .......:	A prerequisite is that the function "_JavaAttachAndWait" has already been executed.
; Related .......:	
; Link ..........: 
; Example .......:	No
;
; ;==========================================================================================
func _JavaTableCellValueSet($autoit_cntl_id, $javaferret_obj_name = "", $instance_num = 1, $javaferret_panel_name = "", $panel_instance_num = 1, $col_names = "", $col_values = "", $col_name_select = "", $object_value = "")

	; If an AutoIT control ID is provided
	if StringCompare($autoit_cntl_id, "") <> 0 Then
		
		$cntl_hwnd = ControlGetHandle($java_hwnd, "", $autoit_cntl_id)

		; Try and select the Java object using the Java Access bridge.
		$sss = DllCall("AutoITJavaAccess.dll", "int:cdecl", "JavaObjSelect", "hwnd", $cntl_hwnd, "str", "", "str", "", "int", $instance_num)
		
		; A result of 0 indicates that the Java Access Bridge was unable to select the Java object.
		if $sss[0] = 0 Then

			; Combo boxes
			if StringCompare($javaferret_obj_role, "combo box") = 0 Then
		
				ControlCommand($java_hwnd, "", $cntl_hwnd, "ShowDropDown", "")
			EndIf

			; Check boxes
			if StringCompare($javaferret_obj_role, "check box") = 0 Then

				; Loop until the Java Access Bridge reports that the checkbox in unchecked.
				; Note that ControlCommand "IsChecked" does not seem to work with Java applets.
				while StringCompare(_JavaObjValueGet($autoit_cntl_id), "unchecked") = 0

					; All the following three commands are the only way I am able to toggle applet checkboxes.
					; I cannot find a Java Access Bridge function to toggle applet checkboxes.
					WinActivate($java_hwnd)
					ControlFocus($java_hwnd, "", $cntl_hwnd)
					ControlSend($java_hwnd, "", $cntl_hwnd, " ")
					WinWait($java_hwnd)
				WEnd
			EndIf
		EndIf
	Else

		; if the column names to search are numerical (indexes)
		if StringRegExp($col_names, "[a-zA-Z]") = 0 Then
			
			$sss = DllCall("AutoITJavaAccess.dll", "int:cdecl", "JavaTableRowGet2", "hwnd", $java_hwnd, "str", $javaferret_obj_name, "int", $instance_num, "str", $col_names, "str", $col_values)
		Else

			$sss = DllCall("AutoITJavaAccess.dll", "int:cdecl", "JavaTableRowGet", "hwnd", $java_hwnd, "str", $javaferret_obj_name, "int", $instance_num, "str", $javaferret_panel_name, "int", $panel_instance_num, "str", $col_names, "str", $col_values)
		EndIf

		$row_num_set = $sss[0]
;		ConsoleWrite("r" & $row_num_set)

		; if the column name to set is numerical (an index)
		if StringIsDigit($col_name_select) = 1 Then
			
			$col_num_set = $col_name_select
		Else
			
			$sss2 = DllCall("AutoITJavaAccess.dll", "int:cdecl", "JavaTableColGet", "hwnd", $java_hwnd, "str", $javaferret_panel_name, "int", $panel_instance_num, "str", $col_name_select)
			$col_num_set = $sss2[0]
		EndIf

;		ConsoleWrite("t" & $col_num_set)

		; Press the DOWN key the correct number of times to reach the row.
		WinActivate($java_hwnd)
		ControlFocus($java_hwnd, "", "")
		
		if $row_num_set > 0 Then
		
			ControlSend($java_hwnd, "", "", "{DOWN " & $row_num_set & "}")
		EndIf
			
		if $col_num_set > 0 Then
			
			ControlSend($java_hwnd, "", "", "{RIGHT " & $col_num_set & "}")
		EndIf
		
		ControlSend($java_hwnd, "", "", $object_value)
	EndIf

	Switch @error
		
		case 1
		
			ConsoleWrite("check AutoITJavaAccess.dll exists" & @CRLF)

		case 2
		
			ConsoleWrite("check AutoITJavaAccess.dll exists" & @CRLF)

		case 3
		
			ConsoleWrite("Function ""JavaObjSelect"" not found in ""AutoITJavaAccess.dll""" & @CRLF)

	EndSwitch


	Return $sss[0];

EndFunc
