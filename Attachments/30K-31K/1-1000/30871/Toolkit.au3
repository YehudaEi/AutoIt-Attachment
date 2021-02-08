#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.2.12.0
 Author:         myName

 Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------

;#include "G:\17 - SSS - Prime Contractor - IBM\14. Base Information\QHIC Test Team\automation\Include\IE.au3"
;#include "G:\17 - SSS - Prime Contractor - IBM\14. Base Information\QHIC Test Team\automation\Include\Array.au3"
;#include "G:\17 - SSS - Prime Contractor - IBM\14. Base Information\QHIC Test Team\automation\Include\ExcelCOM_UDF.au3"
;#include "G:\17 - SSS - Prime Contractor - IBM\14. Base Information\QHIC Test Team\automation\Include\Word.au3"
;#include "G:\17 - SSS - Prime Contractor - IBM\14. Base Information\QHIC Test Team\automation\Include\ScreenCapture.au3"
;#Include "G:\17 - SSS - Prime Contractor - IBM\14. Base Information\QHIC Test Team\automation\Include\File.au3"
#include <IE.au3>
#include <Array.au3>
;#include <ExcelCOM_UDF.au3>
#include <Excel.au3>
#include <Word.au3>
#include <ScreenCapture.au3>
#Include <File.au3>

#cs ----------------------------------------------------------------------------
	Variables
#ce ----------------------------------------------------------------------------

Global $wb, $page, $page_handle, $form, $form_name_glob = "", $frame, $obj, $frame_num = -1, $sub_frame_num = -1, _ 
$window, $set_text_mode = "send keys", $image_num = 0, $base_path = "C:\Documents and Settings\Administrator\Work\Testing\Government\Centrelink\work\Test Automation", _ 
$log_file_handle, $debug_file = "", $glob_test_name, $test_corrupt = False, $tc_status, $win_title
Global $take_snapshots = True ; flag used to temporarily disable snapshots, and later re-enable them

;[Control if write the detail result to spread sheet]
global $result_detail,$record_result_detail=false,$col_result_detail,$sheet_resultDetail
#cs ----------------------------------------------------------------------------
	Test Results
#ce ----------------------------------------------------------------------------

func TestCaseLogOpen($test_name, $append = False)

	$glob_test_name = $test_name
	$test_corrupt = False

	if $log_file_handle <> "" Then

		; Close the previous Log
		;$html &= "</body>" & @CR
		;$html &= "</html>" & @CR
		FileClose($log_file_handle)
	EndIf

	$result_file = $base_path & "\Results\" & $glob_test_name & ".doc"
	$result_files_abs_path = $glob_test_name & "_files"
	$result_files_path = $base_path & "\Results\" & $result_files_abs_path

	if $append = False Then

		DirRemove($result_files_path, 1)
		DirCreate($result_files_path)
		FileDelete($result_file)
	EndIf
	
	$log_file_handle = FileOpen($result_file, 1)

	if $append = False Then

		$html = ""
		$html &= "<html>" & @CR
		$html &= "<head>" & @CR
		$html &= "<title>Untitled Document</title>" & @CR
		$html &= "</head>" & @CR
		$html &= "<body>" & @CR
		$html &= "<b><u>Test Case " & $test_name & "</u></b><br><br>" & @CR

		FileWriteLine($log_file_handle, $html)
	EndIf

	; Setup a debug log
	$debug_file = $base_path & "\Results\" & $glob_test_name & ".txt"

	if $append = False Then

		FileDelete($debug_file)
	EndIf

EndFunc

func TestCaseLogWrite($log_html)

	if $test_corrupt then return
; too much logging - 	DebugLogLogWrite("Called TestCaseLogWrite: $log_html=" & $log_html)

	; don't log anything until a test log file has been opened.
	if $log_file_handle = "" Then Return

	$log_html_processed = False

;	if IsHWnd($log_html) and $log_html_processed = False Then
	if StringCompare($log_html, "page snapshot") = 0 and $log_html_processed = False Then
		
		if $take_snapshots = True Then

			$result_file = $base_path & "\Results\" & $glob_test_name & ".doc"
			$result_files_abs_path = $glob_test_name & "_files"
			$result_files_path = $base_path & "\Results\" & $result_files_abs_path

			; get the number of page down scrolls needed to scroll the frame or page
			if $frame <> "" Then
			
				$element_total_height = $frame.document.body.scrollHeight
				$element_visible_height = $frame.document.body.parentNode.clientHeight
	;			DebugLogLogWrite("num scrolls " & $num_scrolls & " " & $frame.document.body.scrollHeight & " " & $frame.document.body.parentNode.clientHeight)
			Else
				
				$element_total_height = $page.document.body.scrollHeight
				$element_visible_height = $page.document.body.offsetHeight
	;			DebugLogLogWrite("num scrolls " & $num_scrolls & " " & $page.document.body.scrollHeight & " " & $page.document.body.offsetHeight)
			EndIf

			if $element_visible_height = 0 Then
				
				$num_scrolls = 1
			Else
			
				$num_scrolls = $element_total_height / $element_visible_height
			EndIf

			if $num_scrolls = 0 Then
				
				$num_scrolls = 1
			EndIf

			$num_scrolls = Ceiling($num_scrolls)


	;Exit
			; for every page off-screen
			for $i = 1 to $num_scrolls

				; capture the window to a file
				$image_num = $image_num + 1
				$image_filename = StringFormat("%04s", $image_num) & ".jpg"
				WinActivate($page_handle)

				DebugLogLogWrite("Logging snapshot of URL " & $page.locationurl & " to filename " & $image_filename)

				_ScreenCapture_CaptureWnd($result_files_path & "\" & $image_filename, $page_handle)

				; reference the captured file in the results file
				FileWriteLine($log_file_handle, "<img src=""" & $result_files_abs_path & "\" & $image_filename & """ width=800><br><br>")

				; scroll down one page
				if $frame <> "" Then
				
	;									$frame.document.parentWindow.scrollBy(0,$frame.document.body.offsetHeight)
					$frame.document.parentWindow.scrollBy(0,$frame.document.body.parentNode.clientHeight)
				Else
					
					$page.document.parentWindow.scrollBy(0,$page.document.body.offsetHeight)
				EndIf
			Next
		EndIf

		$log_html_processed = True
	EndIf

	if StringCompare($log_html, "DEPENDENCIES") = 0 and $log_html_processed = False Then
		
		; do nothing
		$log_html_processed = True
	EndIf

	if StringCompare($log_html, "PREREQUISITES") = 0 and $log_html_processed = False Then
		
		; do nothing
		$log_html_processed = True
	EndIf

	if StringRegExp($log_html, "P\d+.", 0) = 1 and $log_html_processed = False Then
		
		$log_tag = StringRegExp($log_html, "P\d+.", 1)
		$log_tag_len = StringLen($log_tag[0])
		$log_tag_num = StringMid($log_html, 2, $log_tag_len-2)
		
		FileWriteLine($log_file_handle, "<b><u>Prerequisite " & $log_tag_num & "</u></b><br><br>")
		FileWriteLine($log_file_handle, StringMid($log_html, $log_tag_len+1) & "<br><br>")

		$log_html_processed = True
	EndIf

	if StringCompare($log_html, "TEST STEPS") = 0 and $log_html_processed = False Then

		; do nothing
		$log_html_processed = True
	EndIf

	if StringRegExp($log_html, "A\d+.", 0) = 1 and $log_html_processed = False Then

		$log_tag = StringRegExp($log_html, "A\d+.", 1)
		$log_tag_len = StringLen($log_tag[0])
		$log_tag_num = StringMid($log_html, 2, $log_tag_len-2)
		
		FileWriteLine($log_file_handle, "<b><u>Test Step " & $log_tag_num & "</u></b><br><br>")
		FileWriteLine($log_file_handle, "<b><u>Description (Actions)</u></b><br><br>")
		FileWriteLine($log_file_handle, StringMid($log_html, $log_tag_len+1) & "<br><br>")

		$log_html_processed = True
	EndIf

	if StringRegExp($log_html, "R\d+.", 0) = 1 and $log_html_processed = False Then

		$log_tag = StringRegExp($log_html, "R\d+.", 1)
		$log_tag_len = StringLen($log_tag[0])

		FileWriteLine($log_file_handle, "<b><u>Expected Results</u></b><br><br>")
		FileWriteLine($log_file_handle, StringMid($log_html, $log_tag_len+1) & "<br><br>")

		$log_html_processed = True
	EndIf

	if StringCompare($log_html, "POST-NAVIGATION") = 0 and $log_html_processed = False Then

		; do nothing
		$log_html_processed = True
	EndIf

	if StringRegExp($log_html, "PN\d+.", 0) = 1 and $log_html_processed = False Then
		
		$log_tag = StringRegExp($log_html, "PN\d+.", 1)
		$log_tag_len = StringLen($log_tag[0])
		$log_tag_num = StringMid($log_html, 2, $log_tag_len-2)
		
		FileWriteLine($log_file_handle, "<b><u>Post-navigation step " & $log_tag_num & "</u></b><br><br>")
		FileWriteLine($log_file_handle, StringMid($log_html, $log_tag_len+1) & "<br><br>")

		$log_html_processed = True
	EndIf

	if $log_html_processed = False Then

		; plain text
		FileWriteLine($log_file_handle, $log_html & "<br>")
	EndIf
EndFunc




func TestCaseLogResultVerify($expected, $actual)
	
	DebugLogLogWrite("Called TestCaseLogResultVerify: $expected=" & $expected & ", $actual=" & $actual)	
	
	$result_detail = ""
	
	if StringCompare($expected, $actual) = 0 Then		
		$test_result = "PASSED"
	Else
		$test_result = "FAILED"
	EndIf

	if $test_result = "FAILED" and $tc_status <> "FAILED" then $tc_status = $test_result
				
	$test_result_msg = "Verification"
	DebugLogLogWrite($test_result_msg)
	TestCaseLogWrite($test_result_msg)

	$test_result_msg = "Expected = " & $expected
	DebugLogLogWrite($test_result_msg)
	TestCaseLogWrite($test_result_msg)
	$result_detail = $result_detail & $test_result_msg & @CRLF

	$test_result_msg = "Actual = " & $actual
	DebugLogLogWrite($test_result_msg)
	TestCaseLogWrite($test_result_msg)
	$result_detail = $result_detail & $test_result_msg & @CRLF

	$test_result_msg = "Result = " & $test_result & "<br>"
	DebugLogLogWrite($test_result_msg)
	TestCaseLogWrite($test_result_msg)
	$result_detail = $result_detail & $test_result_msg & @CRLF
	;return  $test_result
	if $record_result_detail = true Then
			$col_result_detail= $col_result_detail+1
			FA_data_write($sheet_resultDetail,$tc.item("Number"),$col_result_detail,$result_detail) ;$result_detail: global variable in Toolkit
	EndIf
	
EndFunc



func DebugLogLogWrite($text)
	
	$text = $text & @CRLF
	ConsoleWrite($text)
	_FileWriteLog($debug_file, $text)

EndFunc

#cs ----------------------------------------------------------------------------
	IE Textboxes
#ce ----------------------------------------------------------------------------

func IETextSetMode ($mode)
	
	DebugLogLogWrite("Called IETextSetMode: $mode=" & $mode)

	$set_text_mode = $mode
EndFunc

func IETextBoxSet($textbox_name, $textbox_value)

	DebugLogLogWrite("Called IETextBoxSet: $textbox_name=" & $textbox_name & ", $textbox_value=" & $textbox_value)

	$tbox = _IEFormElementGetObjByName ($form,$textbox_name)

	if StringCompare($set_text_mode, "set value") = 0 Then

		$tbox.value = $textbox_value
	Else

		_IEAction($tbox, "focus")
		WinActivate($page_handle) ; ensure the page has focus before sending text
		Send("{HOME}{SHIFTDOWN}{END}{SHIFTUP}") ; clear current text
		WinActivate($page_handle) ; ensure the page has focus before sending text
		Send($textbox_value) ; send new text
	EndIf
EndFunc

func IETextBoxDefocus()
	
	DebugLogLogWrite("Called IETextBoxDefocus")

	send("{TAB}") ; send a TAB to cause the textbox to be processed
	IEWait() ; wait for the textbox processing to finish
	
	if $frame_num > -1 Then
		
		if $sub_frame_num > -1 Then
			
			IEFrameAttach($frame_num,$sub_frame_num) ; reattach to the frame as the textbox may have changed it
		EndIf
	EndIf
	
	if $form_name_glob <> "" Then
	
		IEFormAttach($form_name_glob) ; reattach to the form as the textbox may have changed it
	EndIf

EndFunc

#cs ----------------------------------------------------------------------------
	IE Frames
#ce ----------------------------------------------------------------------------

func IEFramesShow()

	DebugLogLogWrite("Called IEFramesShow.")

	$oFrames = _IEFrameGetCollection ($page)
	$iNumFrames = @extended
	For $i = 0 to ($iNumFrames - 1)
		$oFrame = _IEFrameGetCollection ($page, $i)
		MsgBox(0, "Frame Info", _IEPropertyGet ($oFrame, "locationurl"))
	Next

EndFunc

func IEFrameAttach($frame_name_num, $sub_frame_name_num = -1)
	
	$frame_num = $frame_name_num
	$sub_frame_num = $sub_frame_name_num
	
	DebugLogLogWrite("Called IEFrameAttach: $frame_name_num1=" & $frame_name_num & ", $frame_name_num2=" & $sub_frame_name_num)
	if IsNumber($frame_name_num) Then

		$frame = _IEFrameGetCollection ($page, $frame_name_num)
		ConsoleWrite("Attached to frame with locationurl: " & _IEPropertyGet ($frame, "locationurl") & @CRLF)
		
		if $sub_frame_name_num > -1 Then
			
			$frame = _IEFrameGetCollection ($frame, $sub_frame_name_num)
			ConsoleWrite("Attached to frame with locationurl: " & _IEPropertyGet ($frame, "locationurl") & @CRLF)
		EndIf
	EndIf
EndFunc

#cs ----------------------------------------------------------------------------
	IE Hyperlinks
#ce ----------------------------------------------------------------------------

func IELinkClick($link_name_num, $mode = 0, $instance = 0, $scroll_to = false, $scroll_x_offset = 0, $scroll_y_offset = 0, $link_x_offset = 0, $link_y_offset = 0)

	DebugLogLogWrite("Called IELinkClick: $link_name_num=" & $link_name_num)
	if $mode = 0 then
		if IsNumber($link_name_num) Then

			if $frame <> "" Then
				
				_IELinkClickByIndex ($frame,$link_name_num, $instance)
			Else
				
				;_IELinkClickByIndex ($form,$link_name_num)
				_IELinkClickByIndex ($page,$link_name_num, $instance)
			EndIf

		Else
		
			if $scroll_to = false Then
				
				if $frame <> "" Then
				
					_IELinkClickByText ($frame,$link_name_num, $instance)
				Else
					
					_IELinkClickByText ($form,$link_name_num, $instance)
					
				EndIf
			Else
				
				$oLink = IELinkGet($link_name_num, $instance)
				IEElementClick($oLink, $scroll_x_offset, $scroll_y_offset, $link_x_offset, $link_y_offset)
			EndIf
		EndIf
	elseif $mode = 1 Then ; works for the DBLookup where the search text is only part of the ref text. example: Infojavascript:returnValues("20166","LT_BAD241_1275",%20true);
		$oLinks = _IELinkGetCollection ($page)
		$iNumLinks = @extended
		
		For $oLink In $oLinks
			;ConsoleWrite("Link Info" & $oLink.href &  @CRLF)
			if StringInStr( $oLink.href , chr(34) & $link_name_num & chr(34)) > 0 Then				
				$oLink.click
				ExitLoop
			EndIf			
		Next
	endif
EndFunc

Func IELinkGet($s_linkText, $i_index = 0)

	Local $found = 0, $link, $linktext, $links = $form.document.links
	$i_index = Number($i_index)
	For $link In $links
		$linktext = $link.outerText & "" ; Append empty string to prevent problem with no outerText (image) links
		If $linktext = $s_linkText Then
			If ($found = $i_index) Then

				ExitLoop
			EndIf
			$found = $found + 1
		EndIf
	Next

	return $link
EndFunc


#cs ----------------------------------------------------------------------------
	IE Tags
#ce ----------------------------------------------------------------------------

func IETagClick($tagname, $innertext)

	DebugLogLogWrite("Called IETagClick: $tagname=" & $tagname & ", $innertext=" & $innertext)

	if $frame <> "" Then
	
		$oElements = _IETagNameGetCollection ($frame,$tagname)
	Else
		
		$oElements = _IETagNameGetCollection ($page,$tagname)
	EndIf

	For $oElement In $oElements
		if stringcompare(StringStripWS($oElement.innerText,3), StringStripWS($innertext,3) )= 0 Then
			
			_IEAction ($oElement, "focus") ; Focus the object first to ensure events when leaving another object are performed.
			_IEAction ($oElement, "click")
			ExitLoop
		EndIf
	Next
EndFunc

func IETagTextGet($tagname)
	
	DebugLogLogWrite("Called IETagTextGet: $tagname=" & $tagname)

	if $frame <> "" Then
	
		$oElement = _IETagNameGetCollection ($frame,$tagname, 0)
	Else
		
		$oElement = _IETagNameGetCollection ($page,$tagname, 0)
	EndIf
	
	Return $oElement.innerText
EndFunc

#cs ----------------------------------------------------------------------------
	IE Radio Buttons
#ce ----------------------------------------------------------------------------

func IERadioButtonSelect($name, $value)
	
	DebugLogLogWrite("Called IERadioButtonSelect: $name=" & $name & ", $value=" & $value)

	_IEFormElementRadioSelect ($form, $value, $name)
EndFunc


#cs ----------------------------------------------------------------------------
	IE Checkboxes
#ce ----------------------------------------------------------------------------

func IECheckBoxExists($label)
	
	DebugLogLogWrite("Called IECheckBoxExists: $label=" & $label)

	$oElements = _IETagNameAllGetCollection ($form)
	$iNumElements = @extended
	$checkbox_found = False

	For $i = 0 to $iNumElements - 1

		$oElement = _IETagNameAllGetCollection ($form, $i)

		if StringCompare($oElement.innerText, $label) = 0 Then
			
			While StringCompare($oElement.tagname, "INPUT") <> 0
				
				if StringCompare($checkbox_pos, "left") = 0 Then
				
					$i = $i - 1
				Else
					
					$i = $i + 1
				EndIf
				
				$oElement = _IETagNameAllGetCollection ($form, $i)
			WEnd
	
			$checkbox_found	= True ; checkbox found
			$i = $iNumElements - 1 ; exit the loop
		EndIf
	Next
	
	return $checkbox_found
EndFunc

func IECheckBoxCheck($label, $checkbox_pos = "blank", $mode = "space")

	DebugLogLogWrite("Called IECheckBoxCheck: $label=" & $label & ", $checkbox_pos=" & $checkbox_pos)

	if StringCompare($checkbox_pos, "blank") = 0 Then

		if StringCompare($mode, "select") = 0 Then

			_IEFormElementCheckBoxSelect($form, 0, $label, 1, "byIndex") ;temporarily removed as it does not work with popups
		Else
		
			ConsoleWrite("Focusing checkbox" & @CRLF)
			$obj = _IEFormElementGetObjByName ($form, $label)
			$hwnd = _IEPropertyGet($page, "hwnd")
			_IEAction ($obj, "focus") ; Focus the object first to ensure events when leaving another object are performed.
			ControlSend($hwnd, "", "[CLASS:Internet Explorer_Server; INSTANCE:1]", " ")
		EndIf
	Else

		$oElements = _IETagNameAllGetCollection ($form)
		$iNumElements = @extended

		For $i = 0 to $iNumElements - 1

			$oElement = _IETagNameAllGetCollection ($form, $i)

			if StringCompare($oElement.tagname, "LABEL") = 0 and StringCompare($oElement.innerText, $label) = 0 Then
				
				While StringCompare($oElement.tagname, "INPUT") <> 0
					
					if StringCompare($checkbox_pos, "left") = 0 Then
					
						$i = $i - 1
					Else
						
						$i = $i + 1
					EndIf
					
					$oElement = _IETagNameAllGetCollection ($form, $i)
				WEnd
				
				if StringCompare($mode, "select") = 0 Then
				
					_IEFormElementCheckBoxSelect ($form, $oElement.value, "", 1, "byValue") ;temporarily removed as it does not work with popups
				Else
				
					ConsoleWrite("Focusing checkbox" & @CRLF)
					$hwnd = _IEPropertyGet($page, "hwnd")
					ConsoleWrite($oElement.value)
					_IEAction ($oElement, "focus") ; Focus the object first to ensure events when leaving another object are performed.
					ControlSend($hwnd, "", "[CLASS:Internet Explorer_Server; INSTANCE:1]", " ")
				EndIf
				$i = $iNumElements - 1
			EndIf
		Next
	EndIf
EndFunc


func IECheckBoxGetValue($label,  $checkbox_pos = "")
	dim $pos,$value
	DebugLogLogWrite("Called IECheckBoxGetValue: $label=" & $label & ", $checkbox_pos=" & $checkbox_pos)
	$oElements = _IETagNameAllGetCollection ($form)
	$iNumElements = @extended
	$value = 0
	ConsoleWrite(" total Items = " &  $iNumElements  & @CRLF)
	For $i = 0 to $iNumElements - 1

		$oElement = _IETagNameAllGetCollection ($form, $i)

		if StringCompare($oElement.tagname, "LABEL") = 0 and StringCompare($oElement.innerText, $label) = 0 Then
			$pos = $i
			ConsoleWrite("FIND matching label" & @CRLF)
			While StringCompare($oElement.tagname, "INPUT") <> 0				
				
				if StringCompare($checkbox_pos, "left") = 0 Then
				
					$pos = $pos - 1
				Else
					
					$pos = $pos + 1
				EndIf
				
				$oElement = _IETagNameAllGetCollection ($form, $pos)
			WEnd
			$value = $oElement.value
				
			ExitLoop
		EndIf

	Next
	
	return $value
EndFunc



func IECheckBoxCheckByName($label)
	
	DebugLogLogWrite("Called IECheckBoxCheckByName: $label=" & $label )
	
	$obj = _IEFormElementGetObjByName ($form, $label)
	if @ERROR = 0 Then ;find the checkbox. then focus it and cgeck it . otherwise exit
		ConsoleWrite("Focusing checkbox" & @CRLF)
		$hwnd = _IEPropertyGet($page, "hwnd")
		ConsoleWrite($obj.name)
		_IEAction ($obj , "focus") ; Focus the object first to ensure events when leaving another object are performed.
		ControlSend($hwnd, "", "[CLASS:Internet Explorer_Server; INSTANCE:1]", " ")
	EndIf
		
EndFunc

func IECheckBoxUncheck($label, $checkbox_pos = "blank")

	DebugLogLogWrite("Called IECheckBoxUncheck: $label=" & $label & ", $checkbox_pos=" & $checkbox_pos)

	if StringCompare($checkbox_pos, "blank") = 0 Then

		_IEFormElementCheckBoxSelect($form, 0, $label, 0, "byIndex")
	Else

		$oElements = _IETagNameAllGetCollection ($form)
		$iNumElements = @extended

		For $i = 0 to $iNumElements - 1

			$oElement = _IETagNameAllGetCollection ($form, $i)

			if StringCompare($oElement.innerText, $label) = 0 Then
				
				While StringCompare($oElement.tagname, "INPUT") <> 0
					
					if StringCompare($checkbox_pos, "left") = 0 Then
					
						$i = $i - 1
					Else
						
						$i = $i + 1
					EndIf
					
					$oElement = _IETagNameAllGetCollection ($form, $i)
				WEnd
				
				_IEFormElementCheckBoxSelect ($form, $oElement.value, "", 0, "byValue")
				$i = $iNumElements - 1
			EndIf
		Next
	EndIf
EndFunc

func IEGetCheckbox($property, $value)
	
	DebugLogLogWrite("Called IEGetCheckbox(""" & $property & """, """ & $value & """)")
	
	$elements = _IEFormElementGetCollection($form)
	
	For $element In $elements
	
		if $element.type = "checkbox" and Execute("$element." & $property) = $value Then Return $element
	Next
	
	Return False
EndFunc

#cs ----------------------------------------------------------------------------
	IE Pages
#ce ----------------------------------------------------------------------------

func IEPageOpen($url)

	DebugLogLogWrite("Called IEPageOpen(" & $url & ")")

	$page = _IECreate ($url)
	$page_handle = _IEPropertyGet($page, "HWND")
	WinActivate($page_handle) ; bring the page to the front
EndFunc

func IEPageAttach($string, $mode, $wait = False)

	DebugLogLogWrite("Called IEPageAttach(""" & $string & """, """ & $mode & """, " & $wait & ")")
	
	$frame = "" ; clear any old frame attachment from a previous page
	$form = "" ; clear any old form attachment from a previous page
	$page = _IEAttach ($string, $mode)
	$page_handle = _IEPropertyGet($page, "HWND")
	if $wait = True Then IEWait()
	WinActivate($page_handle) ; bring the page to the front
EndFunc

func IEPageMaximise()
	
	DebugLogLogWrite("Called IEPageMaximise()")

	WinSetState($page_handle, "", @SW_MAXIMIZE)
EndFunc

func IEPageMinimise()
	
	DebugLogLogWrite("Called IEPageMinimise()")

	WinSetState($page_handle, "", @SW_MINIMIZE)
EndFunc

func IEWait($num_waits = 1, $timeout = 120000, $wait_for_status_done = False) ; timeout of 120000 is 2 mins
	
	DebugLogLogWrite("Called IEWait(" & $num_waits & ", " & $timeout & ", " & $wait_for_status_done & ") on URL " & $page.locationurl)

	if $num_waits = -1 or $num_waits = 0 then $num_waits = 1
	if $timeout = -1 or $timeout = 0 then $timeout = 120000

	if $wait_for_status_done Then
		
		Do
			
			Sleep(500)
		Until StringCompare(_IEPropertyGet($page, "statustext"), "Done") = 0 ;and $innerhtml_same = False
	EndIf

	for $i = 1 to $num_waits

		if $frame <> "" Then
		
			_IELoadWait($frame, 0, $timeout)
		Else
			
			_IELoadWait($page, 0, $timeout)
		EndIf

		Sleep(1000)
		
		ConsoleWrite("Time after wait #" & $i & " = " & @HOUR & ":" & @MIN & ":" & @SEC & @CRLF)
	Next

	if $wait_for_status_done Then
		
		Do
			
			Sleep(500)
		Until StringCompare(_IEPropertyGet($page, "statustext"), "Done") = 0
	EndIf
EndFunc	



func IEAttachAndWait($url = "", $mode = "url", $frame_name_num = -1, $sub_frame_name_num = -1, $form_name = "", $num_waits = 1, $timeout = 120000, $wait_for_status_done = False)

	DebugLogLogWrite("Called IEAttachAndWait(""" & $url & """, " & $frame_name_num & ", " & $sub_frame_name_num & ", """ & $form_name & """, " & $num_waits & ", " & $timeout & ", " & $wait_for_status_done & ")")

	; Attaching
	
	if $url <> -1 and StringCompare($url, "") <> 0 then
		
		IEPageAttach($url, $mode)
	EndIf
	
	if $frame_name_num > -1 then
		
		if $sub_frame_name_num > -1 Then
			
			IEFrameAttach($frame_name_num, $sub_frame_name_num)
		Else

			IEFrameAttach($frame_name_num)
		EndIf
	EndIf
	
	if $form_name <> -1 and StringCompare($form_name, "") <> 0 then
		
		IEFormAttach($form_name)
	EndIf
	
	; Waiting
	IEWait($num_waits, $timeout, $wait_for_status_done)
	
EndFunc

#cs ----------------------------------------------------------------------------
	IE Forms
#ce ----------------------------------------------------------------------------

func IEFormAttach($form_name)

	DebugLogLogWrite("Called IEFormAttach: $form_name=" & $form_name)

	$form_name_glob = $form_name

	if $frame <> "" Then
	
		$form = _IEFormGetObjByName ($frame,$form_name)
	Else
		
		$form = _IEFormGetObjByName ($page,$form_name)
	EndIf
EndFunc	

#cs ----------------------------------------------------------------------------
	IE Buttons
#ce ----------------------------------------------------------------------------

func IEButtonClick($button_name_num, $mode = "")
	;changed by Sean Dong.
	;by defaulm $mode ="", after the button is clicked, autoIT will attach the original page
	;if function called with $mode parameter, autoIT will not attach to page again. it handle the case where pop-up window is close after clicking button
	DebugLogLogWrite("Called IEButtonClick: $button_name_num=" & $button_name_num)

	$objs = _IEFormElementGetCollection ($form)
	$num_objs = @extended

	if IsNumber($button_name_num) Then

		$button_num = 0
		For $i = 0 to $num_objs - 1

			$obj = _IEFormElementGetCollection ($form, $i)
;msgbox(0,"yo",$obj.type)

			if $obj.type = "button" or $obj.type = "submit" Then
				
				$button_num = $button_num + 1
				if $button_num = $button_name_num Then
					
					ConsoleWrite("Focusing button" & @CRLF)
					$hwnd = _IEPropertyGet($page, "hwnd")
					_IEAction ($obj, "focus") ; Focus the object first to ensure events when leaving another object are performed.
					ControlSend($hwnd, "", "[CLASS:Internet Explorer_Server; INSTANCE:1]", "{Enter}")

					ConsoleWrite("Clicking button" & @CRLF)
;					_IEAction ($obj, "click") ; temporarily removed as it does not work with popups
;					send("{ENTER}") ; see help page on _IEAction, example 2
					ConsoleWrite("Button clicked" & @CRLF)
					if $mode = ""  then
						IEWait()
						ConsoleWrite("Called IE Wait in Button click" & @CRLF)
					EndIf
					ExitLoop
				EndIf
			EndIf
		Next
	Else
		
		$obj = _IEFormElementGetObjByName ($form, $button_name_num)
		ConsoleWrite("Focusing button" & @CRLF)
		$hwnd = _IEPropertyGet($page, "hwnd")
		_IEAction ($obj, "focus") ; Focus the object first to ensure events when leaving another object are performed.
		ControlSend($hwnd, "", "[CLASS:Internet Explorer_Server; INSTANCE:1]", "{Enter}")
		ConsoleWrite("Clicking button" & @CRLF)
;		_IEAction ($obj, "click") ; temporarily removed as it does not work with popups
		;send("{ENTER}") ; see help page on _IEAction, example 2
		ConsoleWrite("Button clicked" & @CRLF)
		if $mode = ""  then IEWait()
		
	EndIf
EndFunc


func IEFindButton($button_name)
	DebugLogLogWrite("Called IEFindButton: $button_name_num=" & $button_name)
	
	
	if _IEFormElementGetObjByName ($form, $button_name) = 0 then 
		ConsoleWrite("Button NOT found !!!!!!!!!!!!!!!!!" & @CRLF)
		return False
	Else
		ConsoleWrite("Button found !!!!!!!!!!!!!!!!!" & @CRLF)
		return True
	endif
	
EndFunc

func IEGetButton($property, $value)
	
	DebugLogLogWrite("Called IEGetButton(""" & $property & """, """ & $value & """)")
	
	$elements = _IEFormElementGetCollection($form)
	
	For $element In $elements
	
		if $element.type = "button" or $element.type = "submit" and Execute("$element." & $property) = $value Then Return $element
	Next
	
	Return False
EndFunc

#cs ----------------------------------------------------------------------------
	IE List Boxes
#ce ----------------------------------------------------------------------------

func IEListBoxSet($listbox_name, $listbox_value)

	DebugLogLogWrite("Called IEListBoxSet: $listbox_name=" & $listbox_name & ", $listbox_value=" & $listbox_value)

	$lbox = _IEFormElementGetObjByName ($form, $listbox_name)
	_IEFormElementOptionSelect ($lbox, $listbox_value, 1, "byText")
EndFunc

#cs ----------------------------------------------------------------------------
	IE Tables
#ce ----------------------------------------------------------------------------

func IETableGet($class_name,$mode = "searchByText") ; $mode = "first", return first table, $mode = "last", return last table, otherwise search by text.

	DebugLogLogWrite("Called IETableGet: $class_name=" & $class_name)

	if $frame <> "" Then
	
		$tables = _IETableGetCollection ($frame)
	Else
		
		$tables = _IETableGetCollection ($page)
	EndIf

	$iNumTables = @extended
	
	if StringCompare($mode,"first") = 0  and $iNumTables > 0 Then
		$table = _IETableGetCollection ($frame, 0)
		return $table
	elseif StringCompare($mode,"last") = 0 and $iNumTables > 0 Then
		$table = _IETableGetCollection ($frame, $iNumTables-1)
		return $table
	else
		for $table_num = 0 to $iNumTables-1

			$table = _IETableGetCollection ($frame, $table_num)

		;	ConsoleWrite($table_num & "," & $table.getAttribute("className") & @CRLF)
			;ConsoleWrite("Table =" & $table.getAttribute("className") & @CRLF)
			if StringCompare($table.getAttribute("className"), $class_name) = 0 Then
				;ConsoleWrite("FOUND")
				return $table
			EndIf
		Next
	endif

	return -1
EndFunc

func IETableGetArray($table_num)
	
	DebugLogLogWrite("Called IETableGetArray(" & $table_num & ")")

	if $frame <> "" Then
		
		$table = _IETableGetCollection ($frame, $table_num)
	Else
		
		$table = _IETableGetCollection ($page, $table_num)
	EndIf

	if $table.rows.length = 0 Then return False

	$aTableData = _IETableWriteToArray ($table, True)
;	_ArrayDisplay($aTableData)

	Return $aTableData

EndFunc

func IETableRowGet($table, $column_num, $value, $mode = 0)
	;mode 0 ,which is default mode , will comare the whole text in the table cell with the value you pass
	;mode 1 will strip the leading and ending while space from the table cell and compare the value you pass
	DebugLogLogWrite("Called IETableRowGet: $table=" & $table & ", $column_num=" & $column_num & ", $value=" & $value)

	$tabledata = _IETableWriteToArray ($table, True)
	if $mode = 0 Then
		for $row_num = 0 to ubound($tabledata)-1
			;ConsoleWrite("row " & $row_num & " = " & $tabledata[$row_num][$column_num] & @CRLF)
			if StringCompare($tabledata[$row_num][$column_num], $value) = 0 Then
				return $row_num
			EndIf
		Next
	elseif $mode = 1 Then
		for $row_num = 0 to ubound($tabledata)-1
			;ConsoleWrite("row " & $row_num & " = " & $tabledata[$row_num][$column_num] & @CRLF)
			if StringCompare(StringStripWS($tabledata[$row_num][$column_num],3), $value) = 0 Then
				return $row_num
			EndIf
		Next
	EndIf

	return -1

EndFunc



func IETableColGet($table, $row_num, $value,$mode = 0)
	;mode 0 ,which is default mode , will comare the whole text in the table cell with the value you pass
	;mode 1 will strip the leading and ending while space from the table cell and compare the value you pass
	DebugLogLogWrite("Called IETableColGet: $table=" & $table & ", $row_num=" & $row_num & ", $value=" & $value)

	$tabledata = _IETableWriteToArray ($table, True)
	if $mode = 0 Then
		
		for $column_num = 0 to ubound($tabledata,2)-1
			;ConsoleWrite("data =" & $tabledata[$row_num][$column_num] & ">>>")
			;ConsoleWrite("para =" & $value & ">>>")
			;ConsoleWrite("comp =" & StringCompare($tabledata[$row_num][$column_num], $value) & @CRLF)
			if StringCompare($tabledata[$row_num][$column_num], $value) = 0 Then

				return $column_num
			EndIf
		Next
	elseif $mode = 1 Then
		for $column_num = 0 to ubound($tabledata,2)-1
			;ConsoleWrite("data =" & $tabledata[$row_num][$column_num] & ">>>")
			;ConsoleWrite("para =" & $value & ">>>")
			;ConsoleWrite("comp =" & StringCompare($tabledata[$row_num][$column_num], $value) & @CRLF)
			if StringCompare(StringStripWS($tabledata[$row_num][$column_num],3), $value) = 0 Then

				return $column_num
			EndIf
		Next
	EndIf

	return -1

EndFunc

func IETableCellGet($table, $row_num, $column_num)

	DebugLogLogWrite("Called IETableCellGet: $table=" & $table & ", $row_num=" & $row_num & ", $column_num=" & $column_num)

	$tabledata = _IETableWriteToArray ($table, True)

	Return $tabledata[$row_num][$column_num]
EndFunc

#cs ----------------------------------------------------------------------------
	IE Images
#ce ----------------------------------------------------------------------------

func IEImageClick($image_url)

	DebugLogLogWrite("Called IEImageClick: $image_url=" & $image_url)

	$objs = _IEFormElementGetCollection ($form)
	$num_objs = @extended

	if IsNumber($image_url) Then

		$image_num = 0
	Else
		
;		_IEFormImageClick($form, $image_url)
		_IEImgClick($form, $image_url)
		IEWait()
	EndIf
EndFunc

#cs ----------------------------------------------------------------------------
	IE Miscellaneous
#ce ----------------------------------------------------------------------------

Func IEElementClick($element, $scroll_x_offset = 0, $scroll_y_offset = 0, $element_x_offset = 0, $element_y_offset = 0)

	$element_pos = IEElementMoveTo($element, $scroll_x_offset, $scroll_y_offset, $element_x_offset, $element_y_offset)
	MouseClick("left", $element_pos[0], $element_pos[1])
EndFunc

Func IEElementMoveTo($element, $scroll_x_offset = 0, $scroll_y_offset = 0, $element_x_offset = 0, $element_y_offset = 0)

	dim $element_pos[2]

	$x = _IEPropertyGet($element, "screenx") + $element_x_offset
	ConsoleWrite("$x" & $x)
	$y = _IEPropertyGet($element, "screeny") + $element_y_offset
	ConsoleWrite("$y" & $y)

	$width = _IEPropertyGet($element, "width")
	ConsoleWrite("$width" & $width)
	$height = _IEPropertyGet($element, "height")
	ConsoleWrite("$height" & $height)

	$windowleft = $frame.document.parentwindow.screenLeft
	ConsoleWrite("$windowleft" & $windowleft)
	$windowtop = $frame.document.parentwindow.screenTop
	ConsoleWrite("$windowtop" & $windowtop)
	$windowwidth = $frame.document.body.parentNode.clientWidth
	ConsoleWrite("$windowwidth" & $windowwidth)
	$windowheight = $frame.document.body.parentNode.clientHeight
	ConsoleWrite("$windowheight" & $windowheight)

	$frame.document.parentwindow.eval("self.scrollTo(0," & ($y - $windowtop + $scroll_y_offset) & ")")

	$offsetY = $frame.document.body.parentNode.scrollTop
	ConsoleWrite("$offsetY" & $offsetY)
	$offsetX = $frame.document.body.parentNode.scrollLeft
	ConsoleWrite("$offsetX" & $offsetX)
	$mousex = ($x - $offsetX)
	ConsoleWrite("$mousex" & $mousex)
	$mousey = ($y - $offsetY)
	ConsoleWrite("$mousey" & $mousey)

	MouseMove($mousex + $element_x_offset, $mousey + $element_y_offset, 0)

	$element_pos[0] = $mousex + $element_x_offset
	$element_pos[1] = $mousey + $element_y_offset
	return $element_pos

EndFunc


#cs ----------------------------------------------------------------------------
	Excel
#ce ----------------------------------------------------------------------------

func ExcelAttach($FileName)

	DebugLogLogWrite("Called ExcelAttach: $FileName=" & $FileName)

;	$wb = _ExcelBookAttach ($FileName, "FileName")
	$wb = _ExcelBookAttach ($FileName, "FileName")
EndFunc

func ExcelSelectionToClipboard() 

	$txt = "" 
	$num_selections = 0

	$sel_areas = $wb.Application.selection.areas 

	for $sel_area in $sel_areas 

		$sel_area_value = $sel_area.Value 

		if IsArray($sel_area_value) Then 

			for $sel_area_value_num = 0 to UBound($sel_area_value, 2)-1 

					$txt &= $sel_area_value[0][$sel_area_value_num] & @CRLF 
					$num_selections = $num_selections + 1
			Next 
		Else 

			$txt &= $sel_area_value & @CRLF 
			$num_selections = $num_selections + 1
		EndIf 
	Next 

;        ConsoleWrite($txt) 
	ClipPut($txt) 
	return $num_selections
EndFunc 


func ErrorHandler($error_text, $base_state_function)

	$test_corrupt = True

	; log the error
	$error_msg = "ERROR. " & $error_text & ". test terminating."
	DebugLogLogWrite($error_msg)
	FileWriteLine($log_file_handle, $error_msg & "<br><br>")
	
	; log a snapshot of the full desktop
	$result_file = $base_path & "\Results\" & $glob_test_name & ".doc"
	$result_files_abs_path = $glob_test_name & "_files"
	$result_files_path = $base_path & "\Results\" & $result_files_abs_path
	$image_num = $image_num + 1
	$image_filename = StringFormat("%04s", $image_num) & ".jpg"
	DebugLogLogWrite("Logging snapshot of full desktop to filename " & $image_filename)
	_ScreenCapture_Capture($result_files_path & "\" & $image_filename)

	; reference the captured file in the results file
	FileWriteLine($log_file_handle, "<img src=""" & $result_files_abs_path & "\" & $image_filename & """ width=800><br><br>")

	; return the application to it's base state
	call($base_state_function)
	
EndFunc

Func IEErrorHandler()
    ; Important: the error object variable MUST be named $oIEErrorHandler
    $ErrorScriptline = $oIEErrorHandler.scriptline
    $ErrorNumber = $oIEErrorHandler.number
    $ErrorNumberHex = Hex($oIEErrorHandler.number, 8)
    $ErrorDescription = StringStripWS($oIEErrorHandler.description, 2)
    $ErrorWinDescription = StringStripWS($oIEErrorHandler.WinDescription, 2)
    $ErrorSource = $oIEErrorHandler.Source
    $ErrorHelpFile = $oIEErrorHandler.HelpFile
    $ErrorHelpContext = $oIEErrorHandler.HelpContext
    $ErrorLastDllError = $oIEErrorHandler.LastDllError
    $ErrorOutput = ""
    $ErrorOutput &= "--> COM Error Encountered in " & @ScriptName & @CR
    $ErrorOutput &= "----> $ErrorScriptline = " & $ErrorScriptline & @CR
    $ErrorOutput &= "----> $ErrorNumberHex = " & $ErrorNumberHex & @CR
    $ErrorOutput &= "----> $ErrorNumber = " & $ErrorNumber & @CR
    $ErrorOutput &= "----> $ErrorWinDescription = " & $ErrorWinDescription & @CR
    $ErrorOutput &= "----> $ErrorDescription = " & $ErrorDescription & @CR
    $ErrorOutput &= "----> $ErrorSource = " & $ErrorSource & @CR
    $ErrorOutput &= "----> $ErrorHelpFile = " & $ErrorHelpFile & @CR
    $ErrorOutput &= "----> $ErrorHelpContext = " & $ErrorHelpContext & @CR
    $ErrorOutput &= "----> $ErrorLastDllError = " & $ErrorLastDllError
    SetError(1)
	ErrorHandler($ErrorOutput, "UI_base_state_from_Workbrain")
    Return
EndFunc  ;==>MyErrFunc



#cs
 Function Added by sean Dong
#ce
func IEFindLink($object_name)
	
	_IEFormElementGetCollection ( $form  )
	$objectCount = @extended
	ConsoleWrite("Total Object=" & @extended & @CRLF)
	
	for $i = 0 to  $objectCount-1
		$nextObj = _IEFormElementGetCollection ( $form, $i  )
		;ConsoleWrite(" Object[" & $i & "]= "&$obj.name & @CRLF)
		if StringCompare($nextObj.name,$object_name) = 0 Then
			
			Return true 
		endif
	next
	; Can not fnd the object if program reach this line
	ConsoleWrite("Can not found project: " & $object_name & @CRLF)
	return False
	

EndFunc


func IETreeNodeClick()

	;DebugLogLogWrite("Called IETagClick: $tagname=" & $tagname & ", $innertext=" & $innertext)


	$oElements = _IETagNameAllGetCollection ($form)
		
	$iNumElements = @extended
	For $i = 0 to $iNumElements - 1

			$oElement = _IETagNameAllGetCollection ($form, $i)
			ConsoleWrite("Name = " & $oElement.tagname & "InnerText="&$oElement.innerText & @CRLF)
#cs
			if StringCompare($oElement.tagname, "LABEL") = 0 and StringCompare($oElement.innerText, $label) = 0 Then
				
				While StringCompare($oElement.tagname, "INPUT") <> 0
					
					if StringCompare($checkbox_pos, "left") = 0 Then
					
						$i = $i - 1
					Else
						
						$i = $i + 1
					EndIf
					
					$oElement = _IETagNameAllGetCollection ($form, $i)
				WEnd
				
				if StringCompare($mode, "select") = 0 Then
				
					_IEFormElementCheckBoxSelect ($form, $oElement.value, "", 1, "byValue") ;temporarily removed as it does not work with popups
				Else
				
					ConsoleWrite("Focusing checkbox" & @CRLF)
					$hwnd = _IEPropertyGet($page, "hwnd")
					ConsoleWrite($oElement.value)
					_IEAction ($oElement, "focus") ; Focus the object first to ensure events when leaving another object are performed.
					ControlSend($hwnd, "", "[CLASS:Internet Explorer_Server; INSTANCE:1]", " ")
				EndIf
				$i = $iNumElements - 1
			EndIf
#ce
		Next
EndFunc



Func ConvertDate($dateStr,$type) 
	;ConsoleWrite("Test String = " &  $dateStr & @CRLF )
	Dim $date 
	if StringCompare(StringUpper($type), "YYYYMMDD") = 0 Then
		$date = ""
		$dateArray = StringSplit($dateStr,"/")
		for $loop = UBound($dateArray)-1 to 1 step -1
			;ConsoleWrite("Array = " &  $dateArray[$loop] & @CRLF )
			while StringLen($dateArray[$loop]) < 2 
				$dateArray[$loop] = "0" & $dateArray[$loop]
			WEnd
		next 
		$date = $dateArray[3] & "/" & $dateArray[2] & "/" & $dateArray[1] 
		;msgbox (0,"","box1,date = " & $date)
		Return $date
	EndIf
	if StringCompare(StringUpper($type) , "DDMMYYYY") = 0 Then
		$date = ""
		$dateArray = StringSplit($dateStr,"/")
		for $loop = UBound($dateArray)-1 to 1 step -1
			;ConsoleWrite("Array = " &  $dateArray[$loop] & @CRLF )
			while StringLen($dateArray[$loop]) < 2 
				$dateArray[$loop] = "0" & $dateArray[$loop]
			WEnd
		next 
		$date = $dateArray[3] & "/" & $dateArray[2] & "/" & $dateArray[1] 
		;msgbox (0,"","box2,date = " & $date)
		Return $date
	EndIf
	
	
EndFunc






#cs ----------------------------------------------------------------------------
	Windows
#ce ----------------------------------------------------------------------------

func WinAttachAndWait($win_title_tmp)
	
	$win_title = $win_title_tmp
	
	WinWait($win_title)
	SendKeepActive($win_title)
EndFunc

func WinSendKeys($text)
	
	WinWait($win_title)
	WinActivate($win_title)
	WinWait($win_title)
	Send($text)
EndFunc
