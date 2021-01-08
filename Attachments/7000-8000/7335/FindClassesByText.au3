; =============================================================================
;
; Find Classes by Text
; Written by Alex Peters, 4/3/2006
;
; Lists the ClassNameNNs of a window grouped by the displayed text. Useful for
; determining the ClassNameNN of e.g. a text control when AutoIt Window Info
; cannot help (due for instance to overlapping controls on the window).
;
; =============================================================================


#Include <GUIConstants.au3>
#Include <GUITreeView.au3>
#include <Array.au3>

Opt('GUIOnEventMode', True)
Opt('MustDeclareVars', True)
Opt('WinWaitDelay', 0)

; Variables to be accessed by event-handling functions.
Global Enum $HAN_GUI, $HAN_TREE, $HAN_BTN, $HAN_BTN2, $HAN_COUNT
Global $Handles[$HAN_COUNT]
Global $CapturedTitle = '[No window has been captured]'
Global $Capturing = False

; GUI positioning constants.
Global Const $PADDING = 12
Global Const $BTN_HEIGHT = 40
Global Const $BTN2_HEIGHT = 30

; =============================================================================

PrepareGUI()

While True
	WinWaitNotActive($Handles[$HAN_GUI])
	; Another window is active. Capture it if appropriate.
	If $Capturing Then
		Beep(400, 50)
		; Grab title for display on button.
		$CapturedTitle = WinGetTitle('')
		; Get the information and build a TreeView.
		Local $TextClasses = WinGetClassesByText(WinGetHandle(''))
		BuildTree($TextClasses)
		; Return to normal operation mode.
		ExitCaptureMode()
	EndIf
	WinWaitActive($Handles[$HAN_GUI])
WEnd


; =============================================================================
; PrepareGUI():
;     Creates and shows the GUI and its base controls.
; =============================================================================

Func PrepareGUI()
	
	; Create the window.
	$Handles[$HAN_GUI] = GUICreate('Find Classes By Text', _
			@DesktopWidth / 2, @DesktopHeight / 2, Default, Default, _
			BitOR($GUI_SS_DEFAULT_GUI, $WS_SIZEBOX, $WS_MAXIMIZEBOX))
	GUISetOnEvent($GUI_EVENT_RESIZED, 'Event_GUIResize')
	GUISetOnEvent($GUI_EVENT_CLOSE, 'Event_GUIClose')
	; Create the Capture button.
	$Handles[$HAN_BTN] = GUICtrlCreateButton($CapturedTitle, _
			Default, Default, Default, Default, $BS_MULTILINE)
	; Create the Copy button.
	$Handles[$HAN_BTN2] = GUICtrlCreateButton("Copy to clipboard", _
			Default, Default, Default, Default)
	GUICtrlSetResizing($Handles[$HAN_BTN2], _
			$GUI_DOCKLEFT + $GUI_DOCKRIGHT + $GUI_DOCKBOTTOM + $GUI_DOCKHEIGHT)
	GUICtrlSetResizing($Handles[$HAN_BTN], _
			$GUI_DOCKLEFT + $GUI_DOCKRIGHT + $GUI_DOCKTOP + $GUI_DOCKHEIGHT)
	GUICtrlSetOnEvent($Handles[$HAN_BTN], 'Event_BtnCapture')
	GUICtrlSetOnEvent($Handles[$HAN_BTN2], 'CopyTreeViewItem')
	
	; Arrange everything nicely.
	RepositionControls()
	
	; Show the GUI.
	GUISetState()
	
EndFunc   ;==>PrepareGUI

; =============================================================================
; BuildTree():
;   Creates a TreeView control containing the specified text snippets and
;   associated ClassNameNNs.
; =============================================================================

Func BuildTree(Const ByRef $TextClasses)
	
	; Delete any existing TreeView; this is the easiest way to get rid of all
	; existing window data.
	If $Handles[$HAN_TREE] <> '' Then GUICtrlDelete($Handles[$HAN_TREE])
	
	; Create a new TreeView.
	$Handles[$HAN_TREE] = GUICtrlCreateTreeView(0, 0, 0, 0, _
			$GUI_SS_DEFAULT_TREEVIEW, $WS_EX_CLIENTEDGE)
	GUICtrlSetResizing($Handles[$HAN_TREE], $GUI_DOCKBORDERS)
	
	; Keep everything nicely arranged.
	RepositionControls()
	
	; Populate with text snippets and associated ClassNameNNs.
	For $I = 1 To $TextClasses[0][0]
		Local $TextNode = GUICtrlCreateTreeViewItem( _
				"'" & $TextClasses[$I][0] & "'", $Handles[$HAN_TREE])
		Local $Classes = $TextClasses[$I][1]
		While StringInStr($Classes, @LF)
			GUICtrlCreateTreeViewItem( _
					StringLeft($Classes, StringInStr($Classes, @LF) - 1), _
					$TextNode)
			$Classes = StringTrimLeft($Classes, StringInStr($Classes, @LF))
		WEnd
		GUICtrlCreateTreeViewItem($Classes, $TextNode)
	Next
	
EndFunc   ;==>BuildTree


; =============================================================================
; RepositionControls():
;     Aligns the GUI controls nicely after a resize or after a new control is
;     created.
; =============================================================================

Func RepositionControls()
	
	Local Const $Area = WinGetClientSize($Handles[$HAN_GUI])
	Local Const $MaxWidth = $Area[0] - 2 * $PADDING
	Local Const $MaxHeight = $Area[1] - 2 * $PADDING
	
	GUICtrlSetPos($Handles[$HAN_BTN], _
			$PADDING, $PADDING, _
			$MaxWidth, $BTN_HEIGHT)
	
	GUICtrlSetPos($Handles[$HAN_BTN2], _
			$PADDING, $MaxHeight - $PADDING, _
			$MaxWidth, $BTN2_HEIGHT) 
	
	If $Handles[$HAN_TREE] <> '' Then GUICtrlSetPos($Handles[$HAN_TREE], _
			$PADDING, 2 * $PADDING + $BTN_HEIGHT, _
			$MaxWidth, $MaxHeight - $BTN_HEIGHT - $BTN2_HEIGHT - $PADDING)
	
EndFunc   ;==>RepositionControls


; =============================================================================
; Event_GUIClose():
;     Called when the GUI is asked to close (e.g. when the user clicks the X).
; =============================================================================

Func Event_GUIClose()
	
	Exit
	
EndFunc   ;==>Event_GUIClose


; =============================================================================
; Event_GUIResize():
;     Called after the user has completed a resize operation on the GUI.
; =============================================================================

Func Event_GUIResize()
	
	RepositionControls()
	
EndFunc   ;==>Event_GUIResize


; =============================================================================
; Event_BtnCapture():
;     Called when the Capture button is clicked, and enters or exits capturing
;     mode as appropriate.
; =============================================================================

Func Event_BtnCapture()
	
	If $Capturing Then
		ExitCaptureMode()
	Else
		EnterCaptureMode()
	EndIf
	
EndFunc   ;==>Event_BtnCapture


; ==============================================================================
; WinGetClassesByText():
;     Returns a text/class list in the form of a two-dimensional array. Element
;     [0][0] contains a count of following text/class pairs. Element [X][0]
;     holds the text and element [X][1] holds an @LF-delimited list of
;     ClassNameNNs sharing that text.
; ==============================================================================

Func WinGetClassesByText($Title, $Text = '')
	
	Local $Classes = WinGetControlIDs($Title, $Text)
	Local $Texts[$Classes[0] + 1][2]
	$Texts[0][0] = 0
	
	For $I = 1 To $Classes[0]
		AddClass($Texts, ControlGetText($Title, $Text, $Classes[$I]), $Classes[$I])
	Next
	
	Return $Texts
	
EndFunc   ;==>WinGetClassesByText


; ==============================================================================
; WinGetControlIDs():
;     Returns an array of ClassNameNNs for a window where element 0 is a count.
; ==============================================================================

Func WinGetControlIDs($sTitle, $sText = '')
	
	Local $avClasses[1], $iCounter, $sClasses, $sClassStub, $sClassStubList
	
	; Request an unnumbered class list.
	$sClassStubList = WinGetClassList($sTitle, $sText)
	
	; Return an empty response if no controls exist.
	; Additionally set @Error if the specified window was not found.
	If $sClassStubList = '' Then
		If @error Then SetError(1)
		$avClasses[0] = 0
		Return $avClasses
	EndIf
	
	; Prepare an array to hold the numbered classes.
	ReDim $avClasses[StringLen($sClassStubList) - _
			StringLen(StringReplace($sClassStubList, @LF, '')) + 1]
	
	; The first element will contain a count.
	$avClasses[0] = 0
	
	; Count each unique class, enumerate them in the array and remove them from
	; the string.
	Do
		$sClassStub = _
				StringLeft($sClassStubList, StringInStr($sClassStubList, @LF))
		$iCounter = 0
		While StringInStr($sClassStubList, $sClassStub)
			$avClasses[0] += 1
			$iCounter += 1
			$avClasses[$avClasses[0]] = _
					StringTrimRight($sClassStub, 1) & $iCounter
			$sClassStubList = _
					StringReplace($sClassStubList, $sClassStub, '', 1)
		WEnd
	Until $sClassStubList = ''
	
	Return $avClasses
	
EndFunc   ;==>WinGetControlIDs


; ==============================================================================
; AddClass():
;     Adds a class to a text entry in the given text/class list. If the given
;     text is not already contained then a new element is created.
; ==============================================================================

Func AddClass(ByRef $Texts, $Text, $Class)
	
	For $I = 1 To $Texts[0][0]
		If $Text == $Texts[$I][0] Then
			$Texts[$I][1] &= @LF & $Class
			Return
		EndIf
	Next
	
	; This point is reached if the text doesn't already exist in the list.
	$Texts[0][0] += 1
	$Texts[$Texts[0][0]][0] = $Text
	$Texts[$Texts[0][0]][1] = $Class
	
EndFunc   ;==>AddClass

; ==============================================================================
; EnterCaptureMode():
;     Performs whatever is necessary when a capture is initiated.
; ==============================================================================

Func EnterCaptureMode()
	
	$Capturing = True
	GUICtrlSetData($Handles[$HAN_BTN], _
			'[Activate window to be captured or click to cancel]')
	
EndFunc   ;==>EnterCaptureMode


; ==============================================================================
; ExitCaptureMode():
;     Performs whatever is necessary when a capture is cancelled or completed.
; ==============================================================================

Func ExitCaptureMode()
	
	$Capturing = False
	GUICtrlSetData($Handles[$HAN_BTN], $CapturedTitle)
	
EndFunc   ;==>ExitCaptureMode


; ==============================================================================
; CopyTreeViewItem():
;     Copies the selected TreeViewItem to the clipboard.
; ==============================================================================

Func CopyTreeViewItem()
	
	Local $a_Item = GUICtrlRead($Handles[$HAN_TREE], 1)
	Local $a_NextItem
	Local $a_FirstChild
	Local $a_Child
	Local $a_Check
	Dim $avArray[1]
	If Not @error Then
		; Check to see if it is a parent item
		If StringInStr($a_Item[0], "'") <> 0 Then
			; Get first child of selected TreeViewItem
			$a_FirstChild = GUICtrlSendMsg($Handles[$HAN_TREE], $TVM_GETNEXTITEM, _
			$TVGN_CHILD, GUICtrlGetHandle($a_Item[1])) 
			; Select the first child item
			GUICtrlSendMsg($Handles[$HAN_TREE], $TVM_SELECTITEM, $TVGN_CARET, _
			$a_FirstChild) 
			While 1
				; Read selected item
				$a_Child = GUICtrlRead($Handles[$HAN_TREE], 1)
				; This is ugly, please help me revise!
				If $a_Check == 0 Then ExitLoop
				; Insert selected child text into array
				$avArray[UBound($avArray) - 1] = $a_Child[0]
				ReDim $avArray[UBound($avArray) + 1]
				; Get the control id of the next child
				$a_NextItem = GUICtrlSendMsg($Handles[$HAN_TREE], $TVM_GETNEXTITEM, _
				$TVGN_NEXT, GUICtrlGetHandle($a_Child[1]))
				; Select the next child
				GUICtrlSendMsg($Handles[$HAN_TREE], $TVM_SELECTITEM, $TVGN_CARET, _
				$a_NextItem)
				; This is also ugly!
				$a_Check = $a_NextItem
			WEnd
			_ArrayToClip($avArray)
		Else
			ClipPut($a_Item[0])
		EndIf
	EndIf
	
EndFunc   ;==>CopyTreeViewItem