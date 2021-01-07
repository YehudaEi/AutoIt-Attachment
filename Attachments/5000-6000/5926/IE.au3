#region Header
#cs
    Title:   Internet Explorer Automation UDF Library for AutoIt3
    Filename:  IE.au3
    Description: A collection of functions for creating, attaching to, reading from and manipulating Internet Explorer
    Author:   DaleHohm
    Version:  T1.4
    Last Update: 7/24/05
    Requirements: AutoIt3 Beta with COM support (3.1.1.63 or higher), Developed/Tested on WindowsXP Pro with Internet Explorer
    Notes:
    Errors associated with incorrect objects will be common user errors.  AutoIt beta 3.1.1.63 has now added an ObjName() 
	function that will be used to trap and report most of these errors.  This version of IE.au3 makes minimal use of this function
	but future release will be enhanced to take full advantage of it.
    
    Update History:
    ===================================================
    T1.0 7/9/05
    Initial Release - error handling is pretty basic, documentation has just begun, only initial UDF standards met
    ---------------------------------------------------
    T1.1 7/9/05
    Fixed errors with _IEQuit, _IETableGetCount and _IETableGetCollection
    Added _IETableWriteToArray
    ---------------------------------------------------
    T1.2 7/11/05
    Added description text to all functions (full parameter documentation still pending)
    Removed 4 _IEAttachByXXXX functions and replaced with one _IEAttach function with a mode parameter
    Removed _IEForward() and _IEBack() and put functionality into the _IEAction() function
    Added _IEAction() that performs many simple browser functions
    Added _IEPropertyGet() that retrieves many properties of the browser
    ---------------------------------------------------
    T1.3 7/14/05
    Change _IEPropertyGet() to _IEGetProperty() (sorry, should have been that way from the beginning)
    Added _IEClickImg() that allows finding and clicking on an image by alt text, name or src
	Added _IETagNameAllGetCollection() to get a collection of all elements in the document
	Added _IETagNameGetCollection() to get a collection of all elements in a document with a specified tagname
    ---------------------------------------------------
    T1.4 7/24/05
	Fixed bug in _IEClickImg() that only allowed exact matches instead of sub-string matches
	Enhanced _IELoadWait() to work with Frame and Window objects (by drilling document readyState)
	Enhanced _IELoadWait() to add a configurable delay before checking status (to allow previous actions to start execution) - default = 0 milliseconds
	Added _IEBodyReadHTML() and _IEBodyWriteHTML() functions (read the page HTML, modify it and put it back!)
	Fixed _IEAttach() so that certain shell variants did not cause failures (using new ObjName() function in beta 3.1.1.63 -- thanks Sven!)	
    ===================================================
    
    \\\ Core Functions
    
    _IECreate()
    Create an Internet Explorer Browser Window
    
    _IENavigate()
    Directs an existing browser window to navigate to the specified URL
    
    _IEAttach()
    Attach to the first existing instance of Internet Explorer where the search string sub-string matches
    based on the mode selected.
    
    _IEDocumentGetObj()
    Given a Window object, returns an object associated with the embedded document
    
    
    \\\ Frame Functions
    
    _IEIsFrameSet()
    Chects to see if the specified Window contains a FrameSet
    
    _IEFrameGetCount()
    Find the number of Frames (standard or iFrame) in the specified document
    
    _IEFrameGetCollection()
    Get a collection object containing the frames in a FrameSet or the iFrames on a normal page
    
    _IEFrameGetObjByIndex()
    Returns an object reference to a window within the specified frame (note that frame collection is 0 based)
    This object can be used in the same manner as the InternetExplorer.Application object
    
    _IEFrameGetObjByName()
    Obtain an object reference to a frame by name
    
    _IEFrameGetNameByIndex()
    Obtain an object reference to a frame by 0-based index
    
    _IEFrameGetSrcByIndex()
    Obtain the URL references within a frame by 0-based index
    
    _IEFrameGetSrcByName()
    Obtain the URL references within a frame by name
    
    
    \\\ Link Functions
    
    _IEClickLinkByText()
    Simulate a mouse click on a link with text sub-string matching the string provided
    
    _IEClickLinkByIndex()
    Simulate a mouse click on a link by 0-based index (in source order)
    
    
    \\\ Image Functions
    
    _IEClickImg()
    Simulate a mouse click on an image.  Match by sub-string match of alt text, name or src
    
    
    \\\ Form Functions
    
    _IEFormGetCount()
    Get the count of the number of forms in the document
    
    _IEFormGetCollection()
    Obtain a collection object variable representing the frames in the document
    
    _IEFormGetObjByIndex()
    Obtain an object variable reference to a form by 0-based index
    
    _IEFormGetObjByName()
    Obtain an object variable reference to a form by name
    
    _IEFormGetNameByIndex()
    Obtain the name of a form by its 0-based index
    
    _IEFormElementGetCount()
    Obtain a count of the number of form elements within a given form
    
    _IEFormElementGetCollection()
    Obtain a collection object variable of all form elements within a given form
    
    _IEFormElementGetObjByIndex()
    Obtain a object reference to a form element within a form by 0-based index
    
    _IEFormElementGetObjByName()
    Obtain a object reference to a form element within a form by name
    
    _IEFormElementGetTypeByIndex()
    Obtain the type of a givien form element within a form by 0-based index
    (button, checkbox, fileUpload, hidden, image, password, radio, reset, submit, or text)
    
    _IEFormElementOptionGetCount()
    Get count of Options within a Select drop-down form element
    
    _IEFormElementGetValue()
    Get the value of a specifid form element
    
    _IEFormElementSetValue()
    Set the value of a specified form element
    
    _IEFormSubmit()
    Submit a specified form
    
    _IEFormReset()
    Reset a specified form
    
    
    \\\ Table Functions
    
    _IETableGetCount()
    Get count of tables within a document
    
    _IETableGetCollection()
    Obtain a collection object variable representing all the tables in a document
    
    _IETableGetObjByIndex()
    Obtain an object reference to a table in a document by 0-based index
    
    _IETableWriteToArray()
    Reads the contents of a table into an array.
    Note: Currently, if any of the cells span more than one column, the column offsets will be incorrect
	
	
    \\\ Body functions

	_IEBodyReadHTML()
	Retrieves the HTML inside the <body> tag of the document

	_IEBodyWriteHTML()
	Replaces the HTML inside the <body> tag of the document
	

	\\\ Utility Functions

	_IETagNameGetCollection()
    Returns a collection object all elements in the object with the specified tagName.
    The DOM is hierarchical, so if the object passed is the document object, all elements
    in the docuemtn are returned.  If the object passed in is an object inside the document (e.g.
    a TABLE object), then only the elements inside that object are returned.
    
    _IETagNameAllGetCollection()
    Returns a collection object all elements in the document in source order.
    
    _IELoadWait()
    Wait for a browser page load to complete before returning
    
    _IEAction()
    Perform any of a set of simple actions on the Browser
    
    _IEGetProperty()
    Retrieve a select property of the Browser
    
    _IEQuit()
    Close the browser and remove the object refernce to it
    
#ce
#endregion
#region Core functions
;===============================================================================
;
; Function Name:    _IECreate()
; Description:      Create an Internet Explorer Browser Window
; Parameter(s):     $f_visible 		- 1 sets visible (default), 0 sets invisible
; Requirement(s):   AutoIt3 Beta with COM support (post 3.1.1)
; Return Value(s):  On Success - Returns an object variable pointing to a new InternetExplorer.Application object
;                   On Failure - 0  and sets @ERROR = 1
; Author(s):        Dale Hohm
;
;===============================================================================
;
Func _IECreate($f_visible = 1)
    $o_object = ObjCreate("InternetExplorer.Application")
    If IsObj($o_object) Then
        $o_object.visible = $f_visible
        $o_object.navigate ("about:blank")
        SetError(0)
        Return $o_object
    Else
        SetError(1)
        Return 0
    EndIf
EndFunc   ;==>_IECreate

;===============================================================================
;
; Function Name:    _IENavigate()
; Description:		Directs an existing browser window to navigate to the specified URL
; Parameter(s):		$o_object 		- InternetExplorer.Application, Window or Frame object
;					$s_Url 			- url to navigate to (e.g. "http://www.autoitscript.com")
;					$f_wait 		- 1 = wait for page load to complete before returning
;									- 0 = return immediately
; Requirement(s):   AutoIt3 Beta with COM support (post 3.1.1)
; Return Value(s):  On Success - Returns -1 (the Navigate method actually has no return value - all we know is that we tried)
;                   On Failure - 0  and sets @ERROR = 1
; Author(s):        Dale Hohm
;
;===============================================================================
;
Func _IENavigate($o_object, $s_url, $f_wait = 1)
    If IsObj($o_object) Then
        $o_object.navigate ($s_url)
        If ($f_wait = 1) Then _IELoadWait($o_object)
        SetError(0)
        Return -1
    Else
        SetError(1)
        Return 0
    EndIf
EndFunc   ;==>_IENavigate

;===============================================================================
;
; Function Name:    _IEAttach()
; Description:		Attach to the first existing instance of Internet Explorer where the search string sub-string matches
;					based on the mode selected.
; Parameter(s):		$s_string	- String to search for
;					$s_mode		- Search Mode, match substring in Title, URL, body Text or body HTML
; Requirement(s):   AutoIt3 Beta with COM support (post 3.1.1)
; Return Value(s):  On Success 	- Returns an object variable pointing to the IE Window Object
;                   On Failure 	- 0  and sets @ERROR = 1 on no match and @ERROR = 99 on invalid Mode
; Author(s):        Dale Hohm
;
;===============================================================================
;
Func _IEAttach($s_string, $s_mode = "Title")
    $s_mode = StringLower($s_mode)
    Dim $o_Shell = ObjCreate("Shell.Application")
    Dim $o_ShellWindows = $o_Shell.Windows (); collection of all ShellWindows (IE and File Explorer)
    For $o_window In $o_ShellWindows
        If (ObjName($o_window.document) = "DispHTMLDocument") Then
            Select
                Case $s_mode = "title"
                    If StringInStr($o_window.document.title, $s_string) > 0 Then
                        SetError(0)
                        Return $o_window
                    EndIf
                Case $s_mode = "url"
                    If StringInStr($o_Window.LocationURL, $s_string) > 0 Then
                        SetError(0)
                        Return $o_window
                    EndIf
                Case $s_mode = "text"
                    If StringInStr($o_window.document.body.innerText, $s_string) > 0 Then
                        SetError(0)
                        Return $o_window
                    EndIf
                Case $s_mode = "html"
                    If StringInStr($o_window.document.body.innerHTML, $s_string) > 0 Then
                        SetError(0)
                        Return $o_window
                    EndIf
                Case Else
                    ; Invalid Mode
                    SetError(99)
                    Return 0
            EndSelect
        EndIf
    Next
    SetError(1)
    Return 0
EndFunc   ;==>_IEAttach

;===============================================================================
;
; Function Name:    _IEDocumentGetObj()
; Description:		Given a Window object, returns an object associated with the embedded document
; Parameter(s):		$o_object	- Object variable of an InternetExplorer.Application, Window or Frame
; Requirement(s):   AutoIt3 Beta with COM support (post 3.1.1)
; Return Value(s):  On Success 	- Returns an object variable pointing to the Document object
;                   On Failure 	- 0  and sets @ERROR = 1
; Author(s):        Dale Hohm
;
;===============================================================================
;
Func _IEDocumentGetObj($o_object)
    If IsObj($o_object.document) Then
        Return $o_object.document
        SetError(0)
    Else
        SetError(1)
        Return 0
    EndIf
EndFunc   ;==>_IEDocumentGetObj
#endregion

#region Frame Functions
;===============================================================================
;
; Function Name:    _IEIsFrameSet()
; Description:		Chects to see if the specified Window contains a FrameSet
; Parameter(s):     $o_object 	- InternetExplorer.Application, Window or Frame object
; Requirement(s):   AutoIt3 Beta with COM support (post 3.1.1)
; Return Value(s):  Returns 1 if the object references a FrameSet page, else 0
; Author(s):        Dale Hohm
;
;===============================================================================
;
Func _IEIsFrameSet($o_object)
    ; Note: this is more reliable test for a FrameSet than checking the
    ; number of frames (document.frames.length) because iFrames embedded on a normal
    ; page are included in the frame collection even though it is not a FrameSet
    If IsObj($o_object.document) Then
        If $o_object.document.body.tagName = "FRAMESET" Then
            SetError(0)
            Return 1
        Else
            SetError(0)
            Return 0
        EndIf
    Else
        SetError(1)
        Return 0
    EndIf
EndFunc   ;==>_IEIsFrameSet

;===============================================================================
;
; Function Name:    _IEFrameGetCount()
; Description:		Find the number of Frames (standard or iFrame) in the specified document
; Parameter(s):		$o_object 	- InternetExplorer.Application, Window or Frame object
; Requirement(s):   AutoIt3 Beta with COM support (post 3.1.1)
; Return Value(s):  On Success - Returns an integer denoting the number of Frames
;                   On Failure - 0  and sets @ERROR = 1
; Author(s):        Dale Hohm
;
;===============================================================================
;
Func _IEFrameGetCount($o_object)
    If IsObj($o_object.document) Then
        SetError(0)
        Return $o_object.document.parentwindow.frames.length
    Else
        SetError(1)
        Return 0
    EndIf
EndFunc   ;==>_IEFrameGetCount

;===============================================================================
;
; Function Name:    _IEFrameGetCollection()
; Description:		Get a collection object containing the frames in a FrameSet or the iFrames on a normal page
; Parameter(s):		$o_object 	- InternetExplorer.Application, Window or Frame object
; Requirement(s):   AutoIt3 Beta with COM support (post 3.1.1)
; Return Value(s):  On Success - Returns an object variable containing the Frames collection
;                   On Failure - 0  and sets @ERROR = 1
; Author(s):        Dale Hohm
;
;===============================================================================
;
Func _IEFrameGetCollection($o_object)
    If IsObj($o_object.document) Then
        SetError(0)
        Return $o_object.document.parentwindow.frames
    Else
        SetError(1)
        Return 0
    EndIf
EndFunc   ;==>_IEFrameGetCollection

;===============================================================================
;
; Function Name:    _IEFrameGetObjByIndex()
; Description:		Returns an object reference to a window within the specified frame (note that frame collection is 0 based)
; 					This object can be used in the same manner as the InternetExplorer.Application object
; Parameter(s):		$o_object 	- InternetExplorer.Application, Window or Frame object
;					$i_index	- 0-based index of the frame you want to match
; Requirement(s):   AutoIt3 Beta with COM support (post 3.1.1)
; Return Value(s):  On Success 	- Returns an object variable pointing to the Window object in a frame
;                   On Failure 	- 0  and sets @ERROR = 1
; Author(s):        Dale Hohm
;
;===============================================================================
;
Func _IEFrameGetObjByIndex($o_object, $i_index)
    If IsObj($o_object.document.parentwindow.frames.item ($i_index)) Then
        SetError(0)
        Return $o_object.document.parentwindow.frames.item ($i_index)
    Else
        SetError(1)
        Return 0
    EndIf
EndFunc   ;==>_IEFrameGetObjByIndex

;===============================================================================
;
; Function Name:    _IEFrameGetObjByName()
; Description:		Obtain an object reference to a frame by name
; Parameter(s):
; Requirement(s):   AutoIt3 Beta with COM support (post 3.1.1)
; Return Value(s):  On Success - Returns an object variable pointing to
;                   On Failure - 0  and sets @ERROR = 1
; Author(s):        Dale Hohm
;
;===============================================================================
Func _IEFrameGetObjByName($o_object, $s_name, $i_index = 0)
    If IsObj($o_object.document.parentwindow.frames ($s_name, $i_index)) Then
        SetError(0)
        Return $o_object.document.parentwindow.frames ($s_name, $i_index)
    Else
        SetError(1)
        Return 0
    EndIf
EndFunc   ;==>_IEFrameGetObjByName

;===============================================================================
;
; Function Name:    _IEFrameGetNameByIndex()
; Description:		Obtain an object reference to a frame by 0-based index
; Parameter(s):
; Requirement(s):   AutoIt3 Beta with COM support (post 3.1.1)
; Return Value(s):  On Success - Returns an object variable pointing to
;                   On Failure - 0  and sets @ERROR = 1
; Author(s):        Dale Hohm
;
;===============================================================================
;
Func _IEFrameGetNameByIndex($o_object, $i_index)
    If IsObj($o_object.document.parentwindow.frames.item ($i_index)) Then
        SetError(0)
        Return $o_object.document.parentwindow.frames.item ($i_index).name
    Else
        SetError(1)
        Return 0
    EndIf
EndFunc   ;==>_IEFrameGetNameByIndex

;===============================================================================
;
; Function Name:    _IEFrameGetSrcByIndex()
; Description:		Obtain the URL references within a frame by 0-based index
; Parameter(s):
; Requirement(s):   AutoIt3 Beta with COM support (post 3.1.1)
; Return Value(s):  On Success - Returns an object variable pointing to
;                   On Failure - 0  and sets @ERROR = 1
; Author(s):        Dale Hohm
;
;===============================================================================
;
Func _IEFrameGetSrcByIndex($o_object, $i_index)
    If IsObj($o_object.document.parentwindow.frames.item ($i_index)) Then
        SetError(0)
        Return $o_object.document.parentwindow.frames.item ($i_index).src
    Else
        SetError(1)
        Return 0
    EndIf
EndFunc   ;==>_IEFrameGetSrcByIndex

;===============================================================================
;
; Function Name:    _IEFrameGetSrcByName()
; Description:		Obtain the URL references within a frame by name
; Parameter(s):
; Requirement(s):   AutoIt3 Beta with COM support (post 3.1.1)
; Return Value(s):  On Success - Returns an object variable pointing to
;                   On Failure - 0  and sets @ERROR = 1
; Author(s):        Dale Hohm
;
;===============================================================================
;
Func _IEFrameGetSrcByName($o_object, $s_name, $i_index = 0)
    If IsObj($o_object.document.parentwindow.frames ($s_name, $i_index)) Then
        SetError(0)
        Return $o_object.document.parentwindow.frames ($s_name, $i_index).src
    Else
        SetError(1)
        Return 0
    EndIf
EndFunc   ;==>_IEFrameGetSrcByName
#endregion
#region Link functions
;===============================================================================
;
; Function Name:    _IEClickLinkByText()
; Description:		Simulate a mouse click on a link with text sub-string matching the string provided
; Parameter(s):
; Requirement(s):   AutoIt3 Beta with COM support (post 3.1.1)
; Return Value(s):  On Success - Returns an object variable pointing to
;                   On Failure - 0  and sets @ERROR = 1
; Author(s):        Dale Hohm
;
;===============================================================================
;
Func _IEClickLinkByText($o_object, $s_linkText, $i_index = 0, $f_wait = 1)
    ; _IE_clickLinkText( $o_object, $s_linkText [, $i_index][, $f_wait])
    ; $o_object - Object Valiable pointing to an InternetExplorer.Application object
    ; $s_linkText - linkText, the text displayed on the web page for the desired link to click
    ; [$i_index] - if the link text occurs more than once, specify which instance you want to click
    ;		note: instance numbering starts at 0
    $doc = $o_object.document
    $links = $doc.links
    $found = 0
    For $link In $links
        $linkText = $link.outerText & "" ; Append empty string to prevent problem with no outerText (image) links
        If $linkText = $s_linkText Then
            if ($found = $i_index) Then
                $result = $link.click
                If ($f_wait = 1) Then _IELoadWait($o_object)
                SetError(0)
                Return 1
            EndIf
            $found = $found + 1
        EndIf
    Next
    SetError(1)
    Return 0
EndFunc   ;==>_IEClickLinkByText

;===============================================================================
;
; Function Name:    _IEClickLinkByIndex()
; Description:		Simulate a mouse click on a link by 0-based index (in source order)
; Parameter(s):
; Requirement(s):   AutoIt3 Beta with COM support (post 3.1.1)
; Return Value(s):  On Success - Returns an object variable pointing to
;                   On Failure - 0  and sets @ERROR = 1
; Author(s):        Dale Hohm
;
;===============================================================================
;
Func _IEClickLinkByIndex($o_object, $i_index, $f_wait = 1)
    ; _IE_clickLinkText( $_obj, $_i)
    ; $o_object - Object Valiable pointing to an InternetExplorer.Application object
    ; $i_index - 0 based index of the link number to click
    $doc = $o_object.document
    If IsObj($doc.links ($i_index)) Then
        if ($i_index >= 0) and ($i_index <= $doc.links.length - 1) Then
            $doc.links ($i_index).click
            If ($f_wait = 1) Then _IELoadWait($o_object)
            SetError(0)
            Return 1
        Else
            SetError(1)
            Return 0
        EndIf
    Else
        SetError(2)
        Return 0
    EndIf
EndFunc   ;==>_IEClickLinkByIndex
#endregion

#region Image functions
;===============================================================================
;
; Function Name:    _IEClickImg()
; Description:		Simulate a mouse click on an image.  Match by sub-string match of alt text, name or src
; Parameter(s):		$o_object	- Object Valiable pointing to an InternetExplorer.Application object
;					$s_linkText	- text to match the content of the attribute specified in $s_mode
;					$s_mode		- alt, name, src
;					$i_index	- if the link text occurs more than once, specify which 0-based instance you want to click
;					$f_wait		- 1 = wait for load to complete after click, 0 = return immediately
; Requirement(s):   AutoIt3 Beta with COM support (post 3.1.1)
; Return Value(s):  On Success - Returns an object variable pointing to
;                   On Failure - 0  and sets @ERROR = 1, @ERROR = 99 if invalid mode is specified
; Author(s):        Dale Hohm
;
;===============================================================================
;
Func _IEClickImg($o_object, $s_linkText, $s_mode = "src", $i_index = 0, $f_wait = 1)
    $doc = $o_object.document
	$imgs = $doc.images
    $found = 0
    $s_mode = StringLower($s_mode)
    For $img In $imgs
        Select
            Case $s_mode = "alt"
                $linkText = $img.alt
            Case $s_mode = "name"
                $linkText = $img.name
            Case $s_mode = "src"
                $linkText = $img.src
            Case Else
                ;; Invalid mode
                SetError(99)
                Return 0
        EndSelect
        If StringInStr($linkText, $s_linkText) Then
            if ($found = $i_index) Then
                $result = $img.click
                Sleep(500) ; Allow readystate to change before proceeding
                If ($f_wait = 1) Then _IELoadWait($o_object)
                SetError(0)
                Return 1
            EndIf
            $found = $found + 1
        EndIf
    Next
    SetError(1)
    Return 0
EndFunc   ;==>_IEClickImg
#endregion

#region Form functions
;===============================================================================
;
; Function Name:    _IEFormGetCount()
; Description:		Get the count of the number of forms in the document
; Parameter(s):
; Requirement(s):   AutoIt3 Beta with COM support (post 3.1.1)
; Return Value(s):  On Success - Returns an object variable pointing to
;                   On Failure - 0  and sets @ERROR = 1
; Author(s):        Dale Hohm
;
;===============================================================================
;
Func _IEFormGetCount($o_object)
    ; $o_object - IE object
    ; return count of Forms in document
    If IsObj($o_object.document.forms) Then
        SetError(0)
        Return $o_object.document.forms.length
    Else
        SetError(1)
        Return 0
    EndIf
EndFunc   ;==>_IEFormGetCount

;===============================================================================
;
; Function Name:    _IEFormGetCollection()
; Description:		Obtain a collection object variable representing the frames in the document
; Parameter(s):
; Requirement(s):   AutoIt3 Beta with COM support (post 3.1.1)
; Return Value(s):  On Success - Returns an object variable pointing to
;                   On Failure - 0  and sets @ERROR = 1
; Author(s):        Dale Hohm
;
;===============================================================================
;
Func _IEFormGetCollection($o_object)
    ; $o_object - IE document object
    ; return Forms collection object
    If IsObj($o_object.forms) Then
        SetError(0)
        Return $o_object.forms
    Else
        SetError(1)
        Return 0
    EndIf
EndFunc   ;==>_IEFormGetCollection

;===============================================================================
;
; Function Name:    _IEFormGetObjByIndex()
; Description:		Obtain an object variable reference to a form by 0-based index
; Parameter(s):
; Requirement(s):   AutoIt3 Beta with COM support (post 3.1.1)
; Return Value(s):  On Success - Returns an object variable pointing to
;                   On Failure - 0  and sets @ERROR = 1
; Author(s):        Dale Hohm
;
;===============================================================================
;
Func _IEFormGetObjByIndex($o_object, $i_index)
    ; $o_object - IE object
    ; return object reference to specific form
    If IsObj($o_object.document.forms.item ($i_index)) Then
        SetError(0)
        Return $o_object.document.forms.item ($i_index)
    Else
        SetError(1)
        Return 0
    EndIf
EndFunc   ;==>_IEFormGetObjByIndex

;===============================================================================
;
; Function Name:    _IEFormGetObjByName()
; Description:		Obtain an object variable reference to a form by name
; Parameter(s):
; Requirement(s):   AutoIt3 Beta with COM support (post 3.1.1)
; Return Value(s):  On Success - Returns an object variable pointing to
;                   On Failure - 0  and sets @ERROR = 1
; Author(s):        Dale Hohm
;
;===============================================================================
;
Func _IEFormGetObjByName($o_object, $s_name, $i_index = 0)
    ; $o_object - IE object
    ; $s_name - name of form
    ; return object reference to specific form
    If IsObj($o_object.document.forms.item ($s_name, $i_index)) Then
        SetError(0)
        Return $o_object.document.forms.item ($s_name, $i_index)
    Else
        SetError(1)
        Return 0
    EndIf
EndFunc   ;==>_IEFormGetObjByName

;===============================================================================
;
; Function Name:    _IEFormGetNameByIndex()
; Description:		Obtain the name of a form by its 0-based index
; Parameter(s):
; Requirement(s):   AutoIt3 Beta with COM support (post 3.1.1)
; Return Value(s):  On Success - Returns an object variable pointing to
;                   On Failure - 0  and sets @ERROR = 1
; Author(s):        Dale Hohm
;
;===============================================================================
;
Func _IEFormGetNameByIndex($o_object, $i_index)
    ; $o_object - IE object
    ; return object reference to specific form
    If IsObj($o_object.document.forms.item ($i_index)) Then
        SetError(0)
        Return $o_object.document.forms.item ($i_index).name
    Else
        SetError(1)
        Return 0
    EndIf
EndFunc   ;==>_IEFormGetNameByIndex

;===============================================================================
;
; Function Name:    _IEFormElementGetCount()
; Description:		Obtain a count of the number of form elements within a given form
; Parameter(s):
; Requirement(s):   AutoIt3 Beta with COM support (post 3.1.1)
; Return Value(s):  On Success - Returns an object variable pointing to
;                   On Failure - 0  and sets @ERROR = 1
; Author(s):        Dale Hohm
;
;===============================================================================
;
Func _IEFormElementGetCount($o_object)
    ; $o_object - form object
    ; return count of form elements within a specific form
    If IsObj($o_object.elements) Then
        SetError(0)
        Return $o_object.elements.length
    Else
        SetError(1)
        Return 0
    EndIf
EndFunc   ;==>_IEFormElementGetCount

;===============================================================================
;
; Function Name:    _IEFormElementGetCollection()
; Description:		Obtain a collection object variable of all form elements within a given form
; Parameter(s):
; Requirement(s):   AutoIt3 Beta with COM support (post 3.1.1)
; Return Value(s):  On Success - Returns an object variable pointing to
;                   On Failure - 0  and sets @ERROR = 1
; Author(s):        Dale Hohm
;
;===============================================================================
;
Func _IEFormElementGetCollection($o_object)
    ; $o_object - IE form object
    ; return Forms Element collection object
    If IsObj($o_object.elements) Then
        SetError(0)
        Return $o_object.elements
    Else
        SetError(1)
        Return 0
    EndIf
EndFunc   ;==>_IEFormElementGetCollection

;===============================================================================
;
; Function Name:    _IEFormElementGetObjByIndex()
; Description:		Obtain a object reference to a form element within a form by 0-based index
; Parameter(s):
; Requirement(s):   AutoIt3 Beta with COM support (post 3.1.1)
; Return Value(s):  On Success - Returns an object variable pointing to
;                   On Failure - 0  and sets @ERROR = 1
; Author(s):        Dale Hohm
;
;===============================================================================
;
Func _IEFormElementGetObjByIndex($o_object, $i_index)
    ; $o_object - form object
    ; return object reference to specific form element
    If IsObj($o_object.elements ($i_index)) Then
        SetError(0)
        Return $o_object.elements ($i_index)
    Else
        SetError(1)
        Return 0
    EndIf
EndFunc   ;==>_IEFormElementGetObjByIndex

;===============================================================================
;
; Function Name:    _IEFormElementGetObjByName()
; Description:		Obtain a object reference to a form element within a form by name
; Parameter(s):
; Requirement(s):   AutoIt3 Beta with COM support (post 3.1.1)
; Return Value(s):  On Success - Returns an object variable pointing to
;                   On Failure - 0  and sets @ERROR = 1
; Author(s):        Dale Hohm
;
;===============================================================================
;
Func _IEFormElementGetObjByName($o_object, $s_name, $i_index = 0)
    ; $o_object - form object
    ; return object reference to specific form element
    If IsObj($o_object.elements.item ($s_name, $i_index)) Then
        SetError(0)
        Return $o_object.elements.item ($s_name, $i_index)
    Else
        SetError(1)
        Return 0
    EndIf
EndFunc   ;==>_IEFormElementGetObjByName

;===============================================================================
;
; Function Name:    _IEFormElementGetTypeByIndex()
; Description:		Obtain the type of a givien form element within a form by 0-based index
;					(button, checkbox, fileUpload, hidden, image, password, radio, reset, submit, or text)
; Parameter(s):		$o_object 	- form object
;					$i_index	- 0-based index of form element within form
; Requirement(s):   AutoIt3 Beta with COM support (post 3.1.1)
; Return Value(s):  On Success - Returns an object variable pointing to
;                   On Failure - 0  and sets @ERROR = 1
; Author(s):        Dale Hohm
;
;===============================================================================
;
Func _IEFormElementGetTypeByIndex($o_object, $i_index)
    If IsObj($o_object.elements.item ($i_index)) Then
        SetError(0)
        Return $o_object.elements.item ($i_index).type
    Else
        SetError(1)
        Return 0
    EndIf
EndFunc   ;==>_IEFormElementGetTypeByIndex

;===============================================================================
;
; Function Name:    _IEFormElementOptionGetCount()
; Description:		Get count of Options within a Select drop-down form element
; Parameter(s):		$o_object 	- Select Element object
; Requirement(s):   AutoIt3 Beta with COM support (post 3.1.1)
; Return Value(s):  On Success - Returns an object variable pointing to
;                   On Failure - 0  and sets @ERROR = 1
; Author(s):        Dale Hohm
;
;===============================================================================
;
Func _IEFormElementOptionGetCount($o_object)
    If IsObj($o_object.options) Then
        SetError(0)
        Return $o_object.options.length
    Else
        SetError(1)
        Return 0
    EndIf
EndFunc   ;==>_IEFormElementOptionGetCount

;===============================================================================
;
; Function Name:    _IEFormElementGetValue()
; Description:		Get the value of a specifid form element
; Parameter(s):
; Requirement(s):   AutoIt3 Beta with COM support (post 3.1.1)
; Return Value(s):  On Success - Returns an object variable pointing to
;                   On Failure - 0  and sets @ERROR = 1
; Author(s):        Dale Hohm
;
;===============================================================================
;
Func _IEFormElementGetValue($o_object)
    ; $o_object - Select Element object
    ; return count of options in a specific option drop-down form element
    If IsObj($o_object) Then
        SetError(0)
        Return $o_object.value
    Else
        SetError(1)
        Return 0
    EndIf
EndFunc   ;==>_IEFormElementGetValue

;===============================================================================
;
; Function Name:    _IEFormElementSetValue()
; Description:		Set the value of a specified form element
; Parameter(s):
; Requirement(s):   AutoIt3 Beta with COM support (post 3.1.1)
; Return Value(s):  On Success - Returns an object variable pointing to
;                   On Failure - 0  and sets @ERROR = 1
; Author(s):        Dale Hohm
;
;===============================================================================
;
Func _IEFormElementSetValue($o_object, $s_newvalue)
    ; $o_object - Form Element object
    If IsObj($o_object) Then
        $o_object.value = $s_newvalue
        SetError(0)
        Return 1
    Else
        SetError(1)
        Return 0
    EndIf
EndFunc   ;==>_IEFormElementSetValue

;===============================================================================
;
; Function Name:    _IEFormSubmit()
; Description:		Submit a specified form
; Parameter(s):
; Requirement(s):   AutoIt3 Beta with COM support (post 3.1.1)
; Return Value(s):  On Success - Returns 1
;                   On Failure - 0  and sets @ERROR = 1
; Author(s):        Dale Hohm
;
;===============================================================================
;
Func _IEFormSubmit($o_object)
    ; $o_object - IE form object
    ; return 1 always
    If IsObj($o_object) Then
        SetError(0)
        $o_object.submit
        Return 1
    Else
        SetError(1)
        Return 0
    EndIf
EndFunc   ;==>_IEFormSubmit

;===============================================================================
;
; Function Name:   _IEFormReset()
; Description:		Reset a specified form
; Parameter(s):
; Requirement(s):   AutoIt3 Beta with COM support (post 3.1.1)
; Return Value(s):  On Success - Returns 1
;                   On Failure - 0  and sets @ERROR = 1
; Author(s):        Dale Hohm
;
;===============================================================================
;
Func _IEFormReset($o_object)
    ; $o_object - IE form object
    ; return 1 always
    If IsObj($o_object) Then
        SetError(0)
        $o_object.reset
        Return 1
    Else
        SetError(1)
        Return 0
    EndIf
EndFunc   ;==>_IEFormReset
#endregion

#region Table functions
;===============================================================================
;
; Function Name:    _IETableGetCount()
; Description:		Get count of tables within a document
; Parameter(s):
; Requirement(s):   AutoIt3 Beta with COM support (post 3.1.1)
; Return Value(s):  On Success - Returns the count of Tables in the document
;                   On Failure - 0  and sets @ERROR = 1
; Author(s):        Dale Hohm
;
;===============================================================================
;
Func _IETableGetCount($o_object)
    ; $o_object - InternetExplorer.Application object
    ; Returns the number of tables
    If IsObj($o_object.document.GetElementsByTagName ("table")) Then
        SetError(0)
        Return $o_object.document.GetElementsByTagName ("table").length
    Else
        SetError(1)
        Return 0
    EndIf
EndFunc   ;==>_IETableGetCount

;===============================================================================
;
; Function Name:    _IETableGetCollection()
; Description:		Obtain a collection object variable representing all the tables in a document
; Parameter(s):
; Requirement(s):   AutoIt3 Beta with COM support (post 3.1.1)
; Return Value(s):  On Success - Returns an object variable pointing to
;                   On Failure - 0  and sets @ERROR = 1
; Author(s):        Dale Hohm
;
;===============================================================================
;
Func _IETableGetCollection($o_object)
    ; $o_object - InternetExplorer.Application object
    ; Returns the collection object containing the tables in the document
    If IsObj($o_object.document.GetElementsByTagName ("table")) Then
        SetError(0)
        Return $o_object.document.GetElementsByTagName ("table")
    Else
        SetError(1)
        Return 0
    EndIf
EndFunc   ;==>_IETableGetCollection

;===============================================================================
;
; Function Name:    _IETableGetObjByIndex()
; Description:		Obtain an object reference to a table in a document by 0-based index
; Parameter(s):
; Requirement(s):   AutoIt3 Beta with COM support (post 3.1.1)
; Return Value(s):  On Success - Returns an object variable pointing to
;                   On Failure - 0  and sets @ERROR = 1
; Author(s):        Dale Hohm
;
;===============================================================================
;
Func _IETableGetObjByIndex($o_object, $i_index)
    ; $o_object - InternetExplorer.Application object
    ; Returns the collection object containing the tables in the document
    If IsObj($o_object.document.GetElementsByTagName ("table").item ($i_index)) Then
        SetError(0)
        Return $o_object.document.GetElementsByTagName ("table").item ($i_index)
    Else
        SetError(1)
        Return 0
    EndIf
EndFunc   ;==>_IETableGetObjByIndex

;===============================================================================
;
; Function Name:    _IETableWriteToArray()
; Description:		Reads the contents of a table into an array.
;					Note: Currently, if any of the cells span more than one column, the column offsets will be incorrect
; Parameter(s):		$o_object - a Table object
; Requirement(s):   AutoIt3 Beta with COM support (post 3.1.1)
; Return Value(s):  On Success - A 2-dimensional array containing the contents of the table
;                   On Failure - 0  and sets @ERROR = 1
; Author(s):        Dale Hohm
;
;===============================================================================
;
Func _IETableWriteToArray($o_object)
    If IsObj($o_object) Then
        $i_cols = 0
        $trs = $o_object.rows
        For $tr In $trs
            $tds = $tr.GetElementsByTagName ("td")
            $i_col = 0
            For $td In $tds
                $i_col = $i_col + 1
            Next
            If $i_col > $i_cols Then $i_cols = $i_col
        Next
        $i_rows = $trs.length
        Dim $a_TableCells[$i_cols][$i_rows]
        $row = 0
        For $tr In $trs
            $tds = $tr.GetElementsByTagName ("td")
            $col = 0
            For $td In $tds
                $a_TableCells[$col][$row] = $td.innerText
                $col = $col + 1
            Next
            $row = $row + 1
        Next
        SetError(0)
        Return $a_TableCells
    Else
        SetError(1)
        Return 0
    EndIf
EndFunc   ;==>_IETableWriteToArray
#endregion

#region Body functions
;===============================================================================
;
; Function Name:    _IEBodyReadHTML()
; Description:		Retrieves the HTML inside the <body> tag of the document
; Parameter(s):     $o_object 	- InternetExplorer.Application, Window or Frame object
; Requirement(s):   AutoIt3 Beta with COM support (post 3.1.1)
; Return Value(s):  Success - HTML included in the <body> of the docuement
;					Failure - 0 and sets @ERROR to 1
; Author(s):        Dale Hohm
;
;===============================================================================
;
Func _IEBodyReadHTML($o_object)
    If IsObj($o_object.document) Then
        SetError(0)
        Return $o_object.document.body.innerHTML
    Else
        SetError(1)
        Return 0
    EndIf
EndFunc

;===============================================================================
;
; Function Name:    _IEBodyWriteHTML()
; Description:		Replaces the HTML inside the <body> tag of the document
; Parameter(s):     $o_object 	- InternetExplorer.Application, Window or Frame object
;					$s_html		- the HTML string to write to the document
; Requirement(s):   AutoIt3 Beta with COM support (post 3.1.1)
; Return Value(s):  Success - HTML included in the <body> of the docuement
;					Failure - 0 and sets @ERROR to 1
; Author(s):        Dale Hohm
;
;===============================================================================
;
Func _IEBodyWriteHTML($o_object, $s_html)
    If IsObj($o_object.document) Then
        $o_object.document.body.innerHTML = $s_html
		SetError(0)
		Return 1
    Else
        SetError(1)
        Return 0
    EndIf
EndFunc
#endregion
#region Information functions
#endregion
#region Utility functions
;===============================================================================
;
; Function Name:    _IETagNameGetCollection()
; Description:		Returns a collection object all elements in the object with the specified tagName.
;					The DOM is hierarchical, so if the object passed is the document object, all elements
;					in the docuemtn are returned.  If the object passed in is an object inside the document (e.g.
;					a TABLE object), then only the elements inside that object are returned.
; Parameter(s):		$o_object	- A document object (or an object of any element within the document)
;					$s_TagName	- TagName of collection to return (e.g. IMG, TR etc.)
; Requirement(s):   AutoIt3 Beta with COM support (post 3.1.1)
; Return Value(s):  On Success - Returns an object variable pointing to
;                   On Failure - 0  and sets @ERROR = 1
; Author(s):        Dale Hohm
;
;===============================================================================
;
Func _IETagNameGetCollection($o_object, $s_TagName)
    If IsObj($o_object) Then
        SetError(0)
        Return $o_object.GetElementsByTagName ($s_TagName)
    Else
        SetError(1)
        Return 0
    EndIf
EndFunc   ;==>_IETagNameGetCollection

;===============================================================================
;
; Function Name:    _IETagNameAllGetCollection()
; Description:		Returns a collection object all elements in the document in source order.
; Parameter(s):		$o_object	- object variable for a InternetExplorer.Application, Window or Frame
; Requirement(s):   AutoIt3 Beta with COM support (post 3.1.1)
; Return Value(s):  On Success - Returns an object variable pointing to
;                   On Failure - 0  and sets @ERROR = 1
; Author(s):        Dale Hohm
;
;===============================================================================
;
Func _IETagNameAllGetCollection($o_object)
    If IsObj($o_object) Then
        SetError(0)
        Return $o_object.document.all
    Else
        SetError(1)
        Return 0
    EndIf
EndFunc   ;==>_IETagNameAllGetCollection

;===============================================================================
;
; Function Name:    _IELoadWait()
; Description:		Wait for a browser page load to complete before returning
; Parameter(s):		$o_object 	- InternetExplorer.Application object
;					$i_delay	- wait this many milliseconds before checking status
; Requirement(s):   AutoIt3 Beta with COM support (post 3.1.1)
; Return Value(s):  On Success 	- Returns an object variable pointing to
;                   On Failure 	- 0  and sets @ERROR = 1
; Author(s):        Dale Hohm
;
;===============================================================================
;
Func _IELoadWait($o_object, $i_delay = 0)
    If IsObj($o_object) Then
		$s_oname = ObjName($o_object)
		Sleep($i_delay)
        While ($o_object.document.readyState <> "complete") and ($o_object.document.readyState <> 4)
            Sleep(100)
        WEnd
        SetError(0)
        Return 1
    Else
        SetError(1)
        Return 0
    EndIf
EndFunc   ;==>_IELoadWait

;===============================================================================
;
; Function Name:    _IEAction()
; Description:      Perform any of a set of simply actions on the Browser
; Parameter(s):     $o_object	- an InternetExplorer.Application object
;					$s_action	- Action selection
; Requirement(s):   AutoIt3 Beta with COM support (post 3.1.1)
; Return Value(s):  On Success - 1
;                   On Failure - 0  and sets @ERROR = 1
; Author(s):        Dale Hohm
;
;===============================================================================
;
Func _IEAction($o_object, $s_action)
    If IsObj($o_object) Then
        $s_action = StringLower($s_action)
        Select
            Case $s_action = "back"
                $o_object.GoBack ()
                _IELoadWait($o_object)
                SetError(0)
                Return 1
            Case $s_action = "blur"
                $o_object.Blur ()
                _IELoadWait($o_object)
                SetError(0)
                Return 1
            Case $s_action = "copy"
                $o_object.document.execCommand ("Copy")
                SetError(0)
                Return 1
            Case $s_action = "focus"
                $o_object.Focus ()
                _IELoadWait($o_object)
                SetError(0)
                Return 1
            Case $s_action = "forward"
                $o_object.GoForward ()
                _IELoadWait($o_object)
                SetError(0)
                Return 1
            Case $s_action = "home"
                $o_object.GoHome ()
                _IELoadWait($o_object)
                SetError(0)
                Return 1
            Case $s_action = "invisible"
                $o_object.visible = 0
                SetError(0)
                Return 1
            Case $s_action = "print"
                $o_object.document.parentwindow.Print ()
                SetError(0)
                Return 1
            Case $s_action = "search"
                $o_object.GoSearch ()
                _IELoadWait($o_object)
                SetError(0)
                Return 1
            Case $s_action = "stop"
                $o_object.Stop ()
                _IELoadWait($o_object)
                SetError(0)
                Return 1
            Case $s_action = "quit"
                $o_object.Quit ()
                $o_object = 0
                SetError(0)
                Return 1
            Case $s_action = "refresh"
                $o_object.document.execCommand ("Refresh")
                _IELoadWait($o_object)
                SetError(0)
                Return 1
            Case $s_action = "selectall"
                $o_object.document.execCommand ("SelectAll")
                SetError(0)
                Return 1
            Case $s_action = "unselect"
                $o_object.document.execCommand ("Unselect")
                SetError(0)
                Return 1
            Case $s_action = "visible"
                $o_object.visible = 1
                SetError(0)
                Return 1
            Case Else
                ; Unsupported Action
                SetError(99)
                Return 0
        EndSelect
    Else
        SetError(1)
        Return 0
    EndIf
EndFunc   ;==>_IEAction

;===============================================================================
;
; Function Name:    _IEGetProperty()
; Description:      Retrieve a select property of the Browser
;					See http://msdn.microsoft.com/library/default.asp?url=/workshop/browser/webbrowser/reference/objects/internetexplorer.asp
; Parameter(s):     $o_object	- an InternetExplorer.Application object
;					$s_property	- Property selection
; Requirement(s):   AutoIt3 Beta with COM support (post 3.1.1)
; Return Value(s):  On Success - Value of selected Property
;                   On Failure - 0  and sets @ERROR = 1
; Author(s):        Dale Hohm
;
;===============================================================================
;
Func _IEGetProperty($o_object, $s_property)
    If IsObj($o_object) Then
        $s_property = StringLower($s_property)
        Select
            Case $s_property = "addressbar"
                SetError(0)
                Return $o_object.AddressBar ()
            Case $s_property = "busy"
                SetError(0)
                Return $o_object.Busy ()
            Case $s_property = "height"
                SetError(0)
                Return $o_object.Height ()
            Case $s_property = "hwnd"
                SetError(0)
                Return $o_object.HWND ()
            Case $s_property = "left"
                SetError(0)
                Return $o_object.Left ()
            Case $s_property = "locationname"
                SetError(0)
                Return $o_object.LocationName ()
            Case $s_property = "locationurl"
                SetError(0)
                Return $o_object.LocationURL ()
            Case $s_property = "menubar"
                SetError(0)
                Return $o_object.MenuBar ()
            Case $s_property = "offline"
                SetError(0)
                Return $o_object.OffLine ()
            Case $s_property = "readystate"
                SetError(0)
                Return $o_object.ReadyState ()
            Case $s_property = "resizeable"
                SetError(0)
                Return $o_object.Resizeable ()
            Case $s_property = "statusbar"
                SetError(0)
                Return $o_object.StatusBar ()
            Case $s_property = "statustext"
                SetError(0)
                Return $o_object.StatusText ()
            Case $s_property = "top"
                SetError(0)
                Return $o_object.Top ()
            Case $s_property = "visible"
                SetError(0)
                Return $o_object.Visible ()
            Case $s_property = "width"
                SetError(0)
                Return $o_object.Width ()
            Case Else
                ; Unsupported Property
                SetError(99)
                Return 0
        EndSelect
    Else
        SetError(1)
        Return 0
    EndIf
EndFunc   ;==>_IEPropertyGet

;===============================================================================
;
; Function Name:   _IEQuit()
; Description:		Close the browser and remove the object refernce to it
; Parameter(s):		$o_object 	- InternetExplorer.Application object
; Requirement(s):   AutoIt3 Beta with COM support (post 3.1.1)
; Return Value(s):  On Success - Returns 1
;                   On Failure - 0  and sets @ERROR = 1
; Author(s):        Dale Hohm
;
;===============================================================================
;
Func _IEQuit($o_object)
    If IsObj($o_object) Then
        SetError(0)
        $o_object.quit ()
        $o_object = 0
        Return 1
    Else
        SetError(1)
        Return 0
    EndIf
EndFunc   ;==>_IEQuit