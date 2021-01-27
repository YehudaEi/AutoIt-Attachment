#include-once
#include <IE.au3>

#cs
	Title:   Internet Explorer New Automation UDF Library for AutoIt3.3
	Filename:  IE New.au3
	Description: A collection of functions for creating, attaching to, reading from and manipulating Internet Explorer
	Author:   Yehia
	Requirements: AutoIt3 3.3 or higher, Developed/Tested on WindowsXP SP2 with Internet Explorer8 beta and Internet Explorer7
	
	Functions included :
	
	_IEElementReplaceText()
	_IEDocMoveElement()
	_IEDocInsertElement()
	_IEPopupCreate()
	_IEPopupHide()
	_IEFrameScrollTo()
	_IEElementScrollIntoView()
	_IEGetElementFromPoint()
	_IEFrameSetPos()
	_IEBodyFindText()
	_IEElementSetBKColor()
	_IEElementSetColor()
	_IEWindowExists()
	_IECheckOnline()
	_IEElementSetCursor()
#ce

Global Enum _; Error Status Types
		$_IEStatus_Success = 0, _
		$_IEStatus_GeneralError, _
		$_IEStatus_ComError, _
		$_IEStatus_InvalidDataType, _
		$_IEStatus_InvalidObjectType, _
		$_IEStatus_InvalidValue, _
		$_IEStatus_LoadWaitTimeout, _
		$_IEStatus_NoMatch, _
		$_IEStatus_AccessIsDenied, _
		$_IEStatus_ClientDisconnected

;========================================================================================================
;
; Function Name:    _IEDocMoveElement()
; Description:		Moves an existing element
; Parameter(s):     $o_object	- Object variable of a document element to move the element to
;                   $o_Element  - Object variable for an element that already exists
;                   $s_where    - Optional : String value signifying where to insert relative to $o_object
;								- BeforeBegin = before start tag of specified object
;								- AfterBegin = after start tag of specified object
;								- BeforeEnd = (Default) before end tag of specified object
;								- AfterEnd = after end tag of specified object
; Requirement(s):   AutoIt3 V3.3 or higher and IE 5
; Return Value(s):  On Success 	- Returns 1
;                   On Failure	- Returns 0 and sets @ERROR
;					@ERROR		- 0 ($_IEStatus_Success) = No Error
;								- 3 ($_IEStatus_InvalidDataType) = Invalid Data Type
;								- 4 ($_IEStatus_InvalidObjectType) = Invalid Object Type
;								- 5 ($_IEStatus_InvalidValue) = Invalid Value
;					@Extended	- Contains invalid parameter number
; Author(s):        Yehia
;
;========================================================================================================
;
Func _IEDocMoveElement(ByRef $o_object,ByRef $o_Element, $s_where = "beforeend")
	If Not IsObj($o_object) Then
		__IEErrorNotify("Error", "_IEDocMoveElement", "$_IEStatus_InvalidDataType")
		SetError($_IEStatus_InvalidDataType, 1)
		Return 0
	EndIf
	If Not __IEIsObjType($o_object, "browserdom") Or __IEIsObjType($o_object, "documentcontainer") Or __IEIsObjType($o_object, "document") Then
		__IEErrorNotify("Error", "_IEDocMoveElement", "$_IEStatus_InvalidObjectType", "Expected document element")
		SetError($_IEStatus_InvalidObjectType, 1)
		Return 0
	EndIf
	
	$s_where = StringLower($s_where)
	Select
		Case $s_where = "beforebegin"
			$o_object.insertAdjacentElement($s_where, $o_Element)
			SetError($_IEStatus_Success)
			Return 1
		Case $s_where = "afterbegin"
			$o_object.insertAdjacentElement($s_where, $o_Element)
			SetError($_IEStatus_Success)
			Return 1
		Case $s_where = "beforeend"
			$o_object.insertAdjacentElement($s_where, $o_Element)
			SetError($_IEStatus_Success)
			Return 1
		Case $s_where = "afterend"
			$o_object.insertAdjacentElement($s_where, $o_Element)
			SetError($_IEStatus_Success)
			Return 1
		Case Else
			__IEErrorNotify("Error", "_IEDocMoveElement", "$_IEStatus_InvalidValue", "Invalid where value")
			SetError($_IEStatus_InvalidValue, 3)
			Return 0
	EndSelect
EndFunc

;========================================================================================================
;
; Function Name:    _IEDocInsertElement()
; Description:		Inserts element adjacent to a specified document element or moves an existing element
; Parameter(s):     $o_object	- Object variable of a document element to insert the new element to
;                   $$s_tag     - A String that specifies the name of a new element.
;                   $s_where    - Optional : String value signifying where to insert relative to $o_object
;								- BeforeBegin = before start tag of specified object
;								- AfterBegin = after start tag of specified object
;								- BeforeEnd = (Default) before end tag of specified object
;								- AfterEnd = after end tag of specified object
; Requirement(s):   AutoIt3 V3.3 or higher and IE 5
; Return Value(s):  On Success 	- Returns 1
;                   On Failure	- Returns 0 and sets @ERROR
;					@ERROR		- 0 ($_IEStatus_Success) = No Error
;								- 3 ($_IEStatus_InvalidDataType) = Invalid Data Type
;								- 4 ($_IEStatus_InvalidObjectType) = Invalid Object Type
;								- 5 ($_IEStatus_InvalidValue) = Invalid Value
;					@Extended	- Contains invalid parameter number
; Author(s):        Yehia
;
;========================================================================================================
;
Func _IEDocInsertElement(ByRef $o_object, $s_tag, $s_where = "beforeend")
	If Not IsObj($o_object) Then
		__IEErrorNotify("Error", "_IEDocInsertElement", "$_IEStatus_InvalidDataType")
		SetError($_IEStatus_InvalidDataType, 1)
		Return 0
	EndIf
	If Not __IEIsObjType($o_object, "browserdom") Or __IEIsObjType($o_object, "documentcontainer") Or __IEIsObjType($o_object, "document") Then
		__IEErrorNotify("Error", "_IEDocInsertElement", "$_IEStatus_InvalidObjectType", "Expected document element")
		SetError($_IEStatus_InvalidObjectType, 1)
		Return 0
	EndIf
	
	$o_Doc = $o_object.document
	$o_Element = $o_Doc.createElement($s_Tag)
	$s_where = StringLower($s_where)
	Select
		Case $s_where = "beforebegin"
			$o_object.insertAdjacentElement($s_where, $o_Element)
			SetError($_IEStatus_Success)
			Return 1
		Case $s_where = "afterbegin"
			$o_object.insertAdjacentElement($s_where, $o_Element)
			SetError($_IEStatus_Success)
			Return 1
		Case $s_where = "beforeend"
			$o_object.insertAdjacentElement($s_where, $o_Element)
			SetError($_IEStatus_Success)
			Return 1
		Case $s_where = "afterend"
			$o_object.insertAdjacentElement($s_where, $o_Element)
			SetError($_IEStatus_Success)
			Return 1
		Case Else
			__IEErrorNotify("Error", "_IEDocInsertElement", "$_IEStatus_InvalidValue", "Invalid where value")
			SetError($_IEStatus_InvalidValue, 3)
			Return 0
	EndSelect
EndFunc

;========================================================================================================
;
; Function Name:    _IEElementReplaceText()
; Description:		Replaces text of an element with new text
; Parameter(s):     $o_object	    - Object variable of a document element to replace it's text with $s_replaceText
;                   $s_replaceText  - String value with the new text
;                   $s_where        - Optional : String value signifying where to insert relative to $o_object
;								    - BeforeBegin = before start tag of specified object
;								    - AfterBegin = after start tag of specified object
;								    - BeforeEnd = (Default) before end tag of specified object
;								    - AfterEnd = after end tag of specified object
; Requirement(s):   AutoIt3 V3.3 or higher and IE 5
; Return Value(s):  On Success 	    - Returns 1
;                   On Failure	    - Returns 0 and sets @ERROR
;					@ERROR		- 0 ($_IEStatus_Success) = No Error
;								- 3 ($_IEStatus_InvalidDataType) = Invalid Data Type
;								- 4 ($_IEStatus_InvalidObjectType) = Invalid Object Type
;								- 5 ($_IEStatus_InvalidValue) = Invalid Value
;					@Extended	- Contains invalid parameter number
; Author(s):        Yehia
;
;========================================================================================================
;
Func _IEElementReplaceText(ByRef $o_object,$s_replaceText, $s_where = "beforeend")
	If Not IsObj($o_object) Then
		__IEErrorNotify("Error", "_IEElementReplaceText", "$_IEStatus_InvalidDataType")
		SetError($_IEStatus_InvalidDataType, 1)
		Return 0
	EndIf
	If Not __IEIsObjType($o_object, "browserdom") Or __IEIsObjType($o_object, "documentcontainer") Or __IEIsObjType($o_object, "document") Then
		__IEErrorNotify("Error", "_IEElementReplaceText", "$_IEStatus_InvalidObjectType", "Expected document element")
		SetError($_IEStatus_InvalidObjectType, 1)
		Return 0
	EndIf
	
	$s_where = StringLower($s_where)
	Select
		Case $s_where = "beforebegin"
			$o_object.replaceAdjacentText($s_where, $s_replaceText)
			SetError($_IEStatus_Success)
			Return 1
		Case $s_where = "afterbegin"
			$o_object.replaceAdjacentText($s_where, $s_replaceText)
			SetError($_IEStatus_Success)
			Return 1
		Case $s_where = "beforeend"
			$o_object.replaceAdjacentText($s_where, $s_replaceText)
			SetError($_IEStatus_Success)
			Return 1
		Case $s_where = "afterend"
			$o_object.replaceAdjacentText($s_where, $s_replaceText)
			SetError($_IEStatus_Success)
			Return 1
		Case Else
			__IEErrorNotify("Error", "_IEElementReplaceText", "$_IEStatus_InvalidValue", "Invalid where value")
			SetError($_IEStatus_InvalidValue, 3)
			Return 0
	EndSelect
EndFunc

;========================================================================================================
;
; Function Name:    _IEPopupCreate()
; Description:		Creates IE popup that disappears when user clicks anywhere out
; Parameter(s):     $o_object	    - Object variable of an InternetExplorer.Application
;                   $left           - The left side of the Popup (related to the container window)
;                   $top            - The top of the Popup (related to the container window)
;                   $width          - The width of the Popup
;                   $height         - The height of the Popup
;                   $text           - The string that appears in the Popup
;                   $BColor         - Optional : Back Color of the Popup (Defult : lightyellow)
;                   $border         - Optional : Border color and size (Defult :"solid black 1px")
;
; Requirement(s):   AutoIt3 V3.3 or higher and IE 5.5
; Return Value(s):  On Success 	    - Returns The popup object
;                   On Failure	    - Returns 0 On Failure	- Returns 0 and sets @ERROR
;					@ERROR		- 0 ($_IEStatus_Success) = No Error
;								- 3 ($_IEStatus_InvalidDataType) = Invalid Data Type
;								- 4 ($_IEStatus_InvalidObjectType) = Invalid Object Type
;                               - 5 ($_IEStatus_InvalidValue) = Invalid Value
;					@Extended	- Contains invalid parameter number
; Author(s):        Yehia
;
;========================================================================================================

Func _IEPopupCreate(ByRef $o_object, $left, $top, $width, $height, $text, $BColor = "lightyellow", $border = "solid black 1px")
	If Not IsObj($o_object) Then
		__IEErrorNotify("Error", "_IEPopupCreate", "$_IEStatus_InvalidDataType")
		SetError($_IEStatus_InvalidDataType, 1)
		Return 0
	EndIf
	If Not __IEIsObjType($o_object, "documentContainer") Then
		__IEErrorNotify("Error", "_IEPopupCreate", "$_IEStatus_InvalidObjectType")
		SetError($_IEStatus_InvalidObjectType, 1)
		Return 0
	EndIf
	If Not IsInt($left) Or Not IsInt($top) Or Not IsInt($width) Or Not IsInt($height) Then
		__IEErrorNotify("Error", "_IEPopupCreate", "$_IEStatus_InvalidValue", "Invalid integer value")
		SetError($_IEStatus_InvalidValue, 3)
		Return 0
	EndIf
	$oFrame = $o_object.document.parentwindow.frames
	$oDoc = $o_object.document
	Global $oPopup = $oFrame.createPopup()
	$oPopBody = $oPopup.document.body
	$oPopBody.style.backgroundColor = $BColor
	$oPopBody.style.border = $border
	$oPopBody.innerHTML = $text
	$oPopup.show($left, $top, $width , $height , $oDoc.body)
	SetError($_IEStatus_Success)
	Return $oPopup
EndFunc

;========================================================================================================
;
; Function Name:    _IEPopupHide()
; Description:		Hides a Popup previously created with _IEPopupCreate ()
; Parameter(s):     $o_Popup	    - Object variable of an InternetExplorer.Application
;                   
; Requirement(s):   AutoIt3 V3.3 or higher and IE 5.5
; Return Value(s):  On Success 	    - Returns 1
;                   On Failure	    - Returns 0 On Failure	- Returns 0 and sets @ERROR
;					@ERROR		- 0 ($_IEStatus_Success) = No Error
;								- 3 ($_IEStatus_InvalidDataType) = Invalid Data Type
;                               - 4 ($_IEStatus_InvalidObjectType) = Invalid Object Type
;					@Extended	- Contains invalid parameter number
; Author(s):        Yehia
;
;========================================================================================================

Func _IEPopupHide(ByRef $o_Popup)
	If Not IsObj($o_Popup) Then
		__IEErrorNotify("Error", "_IEPopupHide", "$_IEStatus_InvalidDataType")
		SetError($_IEStatus_InvalidDataType, 1)
		Return 0
	EndIf
	If Not ObjName($o_Popup) = "DispHTMLPopup" Then
		__IEErrorNotify("Error", "_IEPopupHide", "$_IEStatus_InvalidObjectType")
		SetError($_IEStatus_InvalidObjectType, 1)
		Return 0
	EndIf
	$o_Popup.hide()
	SetError($_IEStatus_Success)
	Return 1
EndFunc

;========================================================================================================
;
; Function Name:    _IEFrameScrollTo()
; Description:		Scrolls up or down a page
; Parameter(s):     $o_object	    - Object variable of an InternetExplorer.Application
;                   $iX             - Integer that specifies the horizontal scroll offset, in pixels
;                   $iY             - Integer that specifies the vertical scroll offset, in pixels
;
; Requirement(s):   AutoIt3 V3.3 or higher and IE 5
; Return Value(s):  On Success 	    - Returns 1
;                   On Failure	    - Returns 0 On Failure	- Returns 0 and sets @ERROR
;					@ERROR		- 0 ($_IEStatus_Success) = No Error
;								- 3 ($_IEStatus_InvalidDataType) = Invalid Data Type
;								- 4 ($_IEStatus_InvalidObjectType) = Invalid Object Type
;                               - 5 ($_IEStatus_InvalidValue) = Invalid Value
;					@Extended	- Contains invalid parameter number
; Author(s):        Yehia
;
;========================================================================================================

Func _IEFrameScrollTo(ByRef $o_object,$iX,$iY)
	If Not IsObj($o_object) Then
		__IEErrorNotify("Error", "_IEFrameScrollTo", "$_IEStatus_InvalidDataType")
		SetError($_IEStatus_InvalidDataType, 1)
		Return 0
	EndIf
	If Not __IEIsObjType($o_object, "documentContainer") Then
		__IEErrorNotify("Error", "_IEFrameScrollTo", "$_IEStatus_InvalidObjectType")
		SetError($_IEStatus_InvalidObjectType, 1)
		Return 0
	EndIf
	If Not IsInt($iX) Or Not IsInt($iY) Then
		__IEErrorNotify("Error", "_IEFrameScrollTo", "$_IEStatus_InvalidValue", "Invalid integer value")
		SetError($_IEStatus_InvalidValue, 3)
		Return 0
	EndIf
	$oFrame = $o_object.document.parentwindow.frames
	$oFrame.scrollTo($iX,$iY)
	SetError($_IEStatus_Success)
	Return 1
EndFunc

;========================================================================================================
;
; Function Name:    _IEElementScrollIntoView()
; Description:		Scrolls up or down a page to get an element into view
;                   $o_object	    - Object variable of an element
;                   $b_AlignToTop   - Optional : Boolean that specifies one of the following values:
;                       - true               Default: Scrolls the object so the object is visible at the top of the window
;                       - false              Scrolls the object so that object is visible at the bottom of the window
;
; Requirement(s):   AutoIt3 V3.3 or higher and IE 5
; Return Value(s):  On Success 	    - Returns 1
;                   On Failure	    - Returns 0 On Failure	- Returns 0 and sets @ERROR
;					@ERROR		- 0 ($_IEStatus_Success) = No Error
;								- 3 ($_IEStatus_InvalidDataType) = Invalid Data Type
;								- 4 ($_IEStatus_InvalidObjectType) = Invalid Object Type
;                               - 5 ($_IEStatus_InvalidValue) = Invalid Value
;					@Extended	- Contains invalid parameter number
; Author(s):        Yehia
;
;========================================================================================================

Func _IEElementScrollIntoView(ByRef $o_object, $b_AlignToTop = True)
	If Not IsObj($o_object) Then
		__IEErrorNotify("Error", "_IEElementScrollIntoView", "$_IEStatus_InvalidDataType")
		SetError($_IEStatus_InvalidDataType, 1)
		Return 0
	EndIf
	If Not __IEIsObjType($o_object, "browserdom") Or __IEIsObjType($o_object, "documentcontainer") Or __IEIsObjType($o_object, "document") Then
		__IEErrorNotify("Error", "_IEElementScrollIntoView", "$_IEStatus_InvalidObjectType", "Expected document element")
		SetError($_IEStatus_InvalidObjectType, 1)
		Return 0
	EndIf
	If Not IsBool($b_AlignToTop) Then
		__IEErrorNotify("Error", "_IEElementScrollIntoView", "$_IEStatus_InvalidValue", "Invalid Boolean value")
		SetError($_IEStatus_InvalidValue, 3)
		Return 0
	EndIf
	$o_object.scrollIntoView($b_AlignToTop)
	SetError($_IEStatus_Success)
	Return 1
EndFunc

;========================================================================================================
;
; Function Name:    _IEGetElementFromPoint
; Description:		Returns the element for the specified iX coordinate and the specified iY coordinate
;                   $o_object	    - Object variable of an InternetExplorer.Application
;                   $iX             - Integer that specifies the X-offset, in pixels
;                   $iY             - Integer that specifies the Y-offset, in pixels
;
; Requirement(s):   AutoIt3 V3.3 or higher and IE 5
; Return Value(s):  On Success 	    - Object of the element
;                   On Failure	    - Returns 0 On Failure	- Returns 0 and sets @ERROR
;					@ERROR		- 0 ($_IEStatus_Success) = No Error
;								- 3 ($_IEStatus_InvalidDataType) = Invalid Data Type
;								- 4 ($_IEStatus_InvalidObjectType) = Invalid Object Type
;                               - 5 ($_IEStatus_InvalidValue) = Invalid Value
;					@Extended	- Contains invalid parameter number
; Author(s):        Yehia
;
;========================================================================================================

Func _IEGetElementFromPoint(ByRef $o_object, $iX, $iY)
	If Not IsObj($o_object) Then
		__IEErrorNotify("Error", "_IEGetElementFromPoint", "$_IEStatus_InvalidDataType")
		SetError($_IEStatus_InvalidDataType, 1)
		Return 0
	EndIf
	If Not __IEIsObjType($o_object, "documentContainer") Then
		__IEErrorNotify("Error", "_IEGetElementFromPoint", "$_IEStatus_InvalidObjectType")
		SetError($_IEStatus_InvalidObjectType, 1)
		Return 0
	EndIf
	If Not IsInt($iX) Or Not IsInt($iY) Then
		__IEErrorNotify("Error", "_IEGetElementFromPoint", "$_IEStatus_InvalidValue", "Invalid integer value")
		SetError($_IEStatus_InvalidValue, 3)
		Return 0
	EndIf
	$oDoc = $o_object.document
	$o_Element = $oDoc.elementFromPoint( $iX, $iY)
	SetError($_IEStatus_Success)
	Return $o_Element
EndFunc

;========================================================================================================
;
; Function Name:    _IEFrameSetPos()
; Description:		Moves and Resizes the screen to iX and iY position, $iWidth and $iHeight sizes, This CAN NOT set an embedded IE object position
;                   $o_object	    - Object variable of an InternetExplorer.Application
;                   $iX             - Integer that specifies the horizontal scroll offset in pixels
;                   $iY             - Integer that specifies the vertical scroll offset in pixels
;                   $iWidth         - Integer that specifies the width of the window in pixels
;                   $iHeight        - Integer that specifies the height of the window in pixels
;
; Requirement(s):   AutoIt3 V3.3 or higher and IE 5
; Return Value(s):  On Success 	    - Returns 1
;                   On Failure	    - Returns 0 On Failure	- Returns 0 and sets @ERROR
;					@ERROR		- 0 ($_IEStatus_Success) = No Error
;								- 3 ($_IEStatus_InvalidDataType) = Invalid Data Type
;								- 4 ($_IEStatus_InvalidObjectType) = Invalid Object Type
;                               - 5 ($_IEStatus_InvalidValue) = Invalid Value
;					@Extended	- Contains invalid parameter number
; Author(s):        Yehia
;
;========================================================================================================

Func _IEFrameSetPos(ByRef $o_object, $iX, $iY, $iWidth, $iHeight)
	If Not IsObj($o_object) Then
		__IEErrorNotify("Error", "_IEFrameSetPos", "$_IEStatus_InvalidDataType")
		SetError($_IEStatus_InvalidDataType, 1)
		Return 0
	EndIf
	If Not __IEIsObjType($o_object, "documentContainer") Then
		__IEErrorNotify("Error", "_IEFrameSetPos", "$_IEStatus_InvalidObjectType")
		SetError($_IEStatus_InvalidObjectType, 1)
		Return 0
	EndIf
	If Not IsInt($iX) Or Not IsInt($iY) Or Not IsInt($iWidth) Or Not IsInt($iHeight) Then
		__IEErrorNotify("Error", "_IEFrameSetPos", "$_IEStatus_InvalidValue", "Invalid integer value")
		SetError($_IEStatus_InvalidValue, 3)
		Return 0
	EndIf
	$oFrame = $o_object.document.parentwindow.frames
	$oFrame.resizeTo( $iWidth, $iHeight)
	$oFrame.moveTo( $iX, $iY)
	SetError($_IEStatus_Success)
	Return 1
EndFunc

;========================================================================================================
;
; Function Name:    _IEBodyFindText()
; Description:		Searches for text in the document
; Parameter(s):     $o_object	    - Object variable of an InternetExplorer.Application
;                   $s_text         - String that specifies the text to find
;                   $i_SearchScope  - Optional : Integer specifies number of characters to search from the starting of range
;                   $i_Flags        - Integer that specifies one or more of the following flags :
;                         - 0           - Default. Match partial words.
;                         - 1           - Match in reverse.
;                         - 2           - Match whole words only.
;                         - 4           - Match case.
;                         - 0x20000     - Match bytes.
;                         - 0x20000000  - Match diacritical marks.
;                         - 0x40000000  - Match Kashida character.
;                         - 0x80000000  - Match AlefHamza character.
;                   
; Requirement(s):   AutoIt3 V3.3 or higher and IE 5
; Return Value(s):  On Success 	    - Returns 1
;                   On Failure	    - Returns 0 On Failure	- Returns 0 and sets @ERROR
;					@ERROR		- 0 ($_IEStatus_Success) = No Error
;								- 3 ($_IEStatus_InvalidDataType) = Invalid Data Type
;								- 4 ($_IEStatus_InvalidObjectType) = Invalid Object Type
;                               - 5 ($_IEStatus_InvalidValue) = Invalid Value
;					@Extended	- Contains invalid parameter number
; Author(s):        Yehia
;
;========================================================================================================

Func _IEBodyFindText(ByRef $o_object, $s_text, $i_SearchScope = 0, $i_Flags = 0)
	If Not IsObj($o_object) Then
		__IEErrorNotify("Error", "_IEBodyFindText", "$_IEStatus_InvalidDataType")
		SetError($_IEStatus_InvalidDataType, 1)
		Return 0
	EndIf
	If Not __IEIsObjType($o_object, "documentContainer") Then
		__IEErrorNotify("Error", "_IEBodyFindText", "$_IEStatus_InvalidObjectType")
		SetError($_IEStatus_InvalidObjectType, 1)
		Return 0
	EndIf
	If Not IsInt($i_SearchScope) Or IsInt($i_Flags) Then
		__IEErrorNotify("Error", "_IEBodyFindText", "$_IEStatus_InvalidValue", "Invalid integer value")
		SetError($_IEStatus_InvalidValue, 3)
		Return 0
	EndIf
	$oDoc = $o_object.document
	$oTextRange = $oDoc.body.createTextRange()
	$found = $oTextRange.findText($s_text,$i_SearchScope,$i_Flags)
	If $found = -1 Then
		SetError($_IEStatus_Success)
		Return 1
	EndIf
EndFunc

;========================================================================================================
;
; Function Name:    _IEElementSetColor()
; Description:		Sets the color of the text of the object
; Parameter(s):     $o_object	    - Object variable of an element
;                   $s_Color        - String or Integer that specifies or receives one of the color names
;                   
; Requirement(s):   AutoIt3 V3.3 or higher and IE 5
; Return Value(s):  On Success 	    - Returns 1
;                   On Failure	    - Returns 0 On Failure	- Returns 0 and sets @ERROR
;					@ERROR		- 0 ($_IEStatus_Success) = No Error
;								- 3 ($_IEStatus_InvalidDataType) = Invalid Data Type
;								- 4 ($_IEStatus_InvalidObjectType) = Invalid Object Type
;					@Extended	- Contains invalid parameter number
; Author(s):        Yehia
;
;========================================================================================================

Func _IEElementSetColor(ByRef $o_object, $s_Color)
	If Not IsObj($o_object) Then
		__IEErrorNotify("Error", "_IEElementSetColor", "$_IEStatus_InvalidDataType")
		SetError($_IEStatus_InvalidDataType, 1)
		Return 0
	EndIf
	If Not __IEIsObjType($o_object, "browserdom") Or __IEIsObjType($o_object, "documentcontainer") Or __IEIsObjType($o_object, "document") Then
		__IEErrorNotify("Error", "_IEElementSetColor", "$_IEStatus_InvalidObjectType", "Expected document element")
		SetError($_IEStatus_InvalidObjectType, 1)
		Return 0
	EndIf
	$oSubmit.style.Color = $s_Color
	SetError($_IEStatus_Success)
	Return 1
EndFunc

;========================================================================================================
;
; Function Name:    _IEElementSetBKColor()
; Description:		Sets the back color behind the content of the object 
; Parameter(s):     $o_object	    - Object variable of an element
;                   $s_Color        - String or Integer that specifies one of the color names also string transparent for transparent element
;                   
; Requirement(s):   AutoIt3 V3.3 or higher and IE 5
; Return Value(s):  On Success 	    - Returns 1
;                   On Failure	    - Returns 0 On Failure	- Returns 0 and sets @ERROR
;					@ERROR		- 0 ($_IEStatus_Success) = No Error
;								- 3 ($_IEStatus_InvalidDataType) = Invalid Data Type
;								- 4 ($_IEStatus_InvalidObjectType) = Invalid Object Type
;                               - 5 ($_IEStatus_InvalidValue) = Invalid Value
;					@Extended	- Contains invalid parameter number
; Author(s):        Yehia
;
;========================================================================================================

Func _IEElementSetBKColor(ByRef $o_object, $s_Color)
	If Not IsObj($o_object) Then
		__IEErrorNotify("Error", "_IEElementSetBKColor", "$_IEStatus_InvalidDataType")
		SetError($_IEStatus_InvalidDataType, 1)
		Return 0
	EndIf
	If Not __IEIsObjType($o_object, "browserdom") Or __IEIsObjType($o_object, "documentcontainer") Or __IEIsObjType($o_object, "document") Then
		__IEErrorNotify("Error", "_IEElementSetBKColor", "$_IEStatus_InvalidObjectType", "Expected document element")
		SetError($_IEStatus_InvalidObjectType, 1)
		Return 0
	EndIf
	If Not IsInt($s_Color) And Not IsString($s_Color) Then
		__IEErrorNotify("Error", "_IEBodyFindText", "$_IEStatus_InvalidValue", "Invalid integer or string value")
		SetError($_IEStatus_InvalidValue, 3)
		Return 0
	EndIf
	$oSubmit.style.backgroundColor = $s_Color
	SetError($_IEStatus_Success)
	Return 1
EndFunc

;========================================================================================================
;
; Function Name:    _IEWindowExists()
; Description:		Checks if a previously created IE window still exists
; Parameter(s):     $o_object	    - Object variable of an InternetExplorer.Application
;                   
; Requirement(s):   AutoIt3 V3.3 or higher and IE 5
; Return Value(s):  On Success 	    - Returns 1 window exists
;                   On Failure	    - Returns 0 On Failure	- Returns 0 and sets @ERROR
;					@ERROR		- 0 ($_IEStatus_Success) = No Error
;								- 3 ($_IEStatus_InvalidDataType) = Invalid Data Type
;								- 4 ($_IEStatus_InvalidObjectType) = Invalid Object Type
;					@Extended	- Contains invalid parameter number
; Author(s):        Yehia
;
;========================================================================================================

Func _IEWindowExists(ByRef $o_object)
	If Not IsObj($o_object) Then
		__IEErrorNotify("Error", "_IEWindowExists", "$_IEStatus_InvalidDataType")
		SetError($_IEStatus_InvalidDataType, 1)
		Return 0
	EndIf
	If Not __IEIsObjType($o_object, "documentContainer") Then
		__IEErrorNotify("Error", "_IEWindowExists", "$_IEStatus_InvalidObjectType")
		SetError($_IEStatus_InvalidObjectType, 1)
		Return 0
	EndIf
	$oFrame = $o_object.document.parentwindow.frames
	If $oFrame.closed = False Then
		SetError($_IEStatus_Success)
		Return 1
	Else
		SetError($_IEStatus_Success)
		Return 2
	EndIf
EndFunc

;========================================================================================================
;
; Function Name:    _IEOnlineCheck()
; Description:		Retrieves a value indicating whether the system is online
; Parameter(s):     $o_object	    - Object variable of an InternetExplorer.Application
;                   
; Requirement(s):   AutoIt3 V3.3 or higher and IE 5
; Return Value(s):  On Success 	    - Returns 1
;                   On Failure	    - Returns 0 On Failure	- Returns 0 and sets @ERROR
;					@ERROR		- 0 ($_IEStatus_Success) = No Error
;								- 3 ($_IEStatus_InvalidDataType) = Invalid Data Type
;								- 4 ($_IEStatus_InvalidObjectType) = Invalid Object Type
;                               - 6 ($_IEStatus_LoadWaitTimeout) = Load Wait Timeout
;					@Extended	- Contains invalid parameter number
; Author(s):        Yehia
;
;========================================================================================================

Func _IEOnlineCheck(ByRef $o_object)
	If Not IsObj($o_object) Then
		__IEErrorNotify("Error", "_IEOnlineCheck", "$_IEStatus_InvalidDataType")
		SetError($_IEStatus_InvalidDataType, 1)
		Return 0
	EndIf
	If Not __IEIsObjType($o_object, "documentContainer") Then
		__IEErrorNotify("Error", "_IEOnlineCheck", "$_IEStatus_InvalidObjectType")
		SetError($_IEStatus_InvalidObjectType, 1)
		Return 0
	EndIf
	$o_object.navigate("about:blank")
	$beg = TimerInit()
	Do
	Until $o_object.document.readyState = "complete" Or $o_object.document.readyState = 4 Or TimerDiff($beg) >= 10000
	If TimerDiff($beg) >= 10000 Then
		__IEErrorNotify("Warning", "_IEOnlineCheck", "$_IEStatus_LoadWaitTimeout")
		SetError($_IEStatus_LoadWaitTimeout, 3)
		Return 0
	EndIf
	$oFrame = $o_object.document.parentwindow.frames
	If $oFrame.clientInformation.onLine = True Then
		SetError($_IEStatus_Success)
		Return 1
	Else
		SetError($_IEStatus_Success)
		Return 0
	EndIf
EndFunc

;========================================================================================================
;
; Function Name:    _IEElementSetCursor()
; Description:		Sets the type of cursor to display as the mouse pointer moves over the object
; Parameter(s):     $o_object	    - Object variable of an element
;                   $s_Cursor       - String receives one or more of the following possible values :
;                        - all-scroll    Arrows pointing up, down, left, and right with a dot in the middle
;                        - auto :   Default. Browser determines which cursor to display based on the current context.
;                        - col-resize :   Arrows pointing left and right with a vertical bar separating them
;                        - crosshair :   Simple cross hair.
;                        - default :   Platform-dependent default cursor; usually an arrow.
;                        - hand :   Hand with the first finger pointing up,
;                        - help :   Arrow with question mark, indicating help is available.
;                        - move :   Crossed arrows, indicating something is to be moved.
;                        - no-drop :   Hand with a small circle with a line through it
;                        - not-allowed :   Circle with a line through it
;                        - pointer :   Hand with the first finger pointing up
;                        - progress :   Arrow with an hourglass next to it
;                        - row-resize :   Arrows pointing up and down with a horizontal bar separating them
;                        - text :   Editable text; usually an I-bar.
;                        - url(uri) :   Cursor is defined by the author, using a custom Uniform Resource Identifier (URI)
;                        - vertical-text :   Editable vertical text
;                        - wait :   Hourglass or watch, indicating that the program is busy and the user should wait.
;                        - *-resize :   Arrows, indicating an edge is to be moved; the asterisk (*) can be N, NE, NW, S, SE, SW, E, or W?each representing a compass direction.
;                   
; Requirement(s):   AutoIt3 V3.3 or higher and IE 6
; Return Value(s):  On Success 	    - Returns 1
;                   On Failure	    - Returns 0 On Failure	- Returns 0 and sets @ERROR
;					@ERROR		- 0 ($_IEStatus_Success) = No Error
;								- 3 ($_IEStatus_InvalidDataType) = Invalid Data Type
;								- 4 ($_IEStatus_InvalidObjectType) = Invalid Object Type
;                               - 5 ($_IEStatus_InvalidValue) = Invalid Value
;					@Extended	- Contains invalid parameter number
; Author(s):        Yehia
;
;========================================================================================================

Func _IEElementSetCursor(ByRef $o_object, $s_Cursor)
	If Not IsObj($o_object) Then
		__IEErrorNotify("Error", "_IEElementSetCursor", "$_IEStatus_InvalidDataType")
		SetError($_IEStatus_InvalidDataType, 1)
		Return 0
	EndIf
	If Not __IEIsObjType($o_object, "documentContainer") Then
		__IEErrorNotify("Error", "_IEElementSetCursor", "$_IEStatus_InvalidObjectType")
		SetError($_IEStatus_InvalidObjectType, 1)
		Return 0
	EndIf
	If Not IsString($s_Cursor) Then
		__IEErrorNotify("Error", "_IEElementSetCursor", "$_IEStatus_InvalidValue", "Invalid string value")
		SetError($_IEStatus_InvalidValue, 3)
		Return 0
	EndIf
	$o_object.style.cursor = $s_Cursor
	SetError($_IEStatus_Success)
	Return 1
EndFunc