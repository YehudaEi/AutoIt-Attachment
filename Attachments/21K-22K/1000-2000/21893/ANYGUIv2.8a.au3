#include-once

#include <WindowsConstants.au3>
#include <Constants.au3>
#include <GuiListBox.au3>

; #INDEX# =======================================================================================================================
; Title .........: ANYGUI
; AutoIt Version: 3.2.3++
; Language:       English
; Description:    Functions that assist with manipulating program windows.
; ===============================================================================================================================

#region Version and Author(s)...And CREDITS!!
#cs -------Version and Author Data------------------------------------------------------------------
	; ***************************************************
	; ****ANYGUI.au3 v 2.8a  21 AUG 2008**************************
	; ************Author: Quaizywabbit*******************
	; *Credits: Many thanks to Valik(especially!) and Larry!!!!!!!!!!*
	;          _TargetSetStyle courtesy of Xenogis!!
	; ***************************************************
	;Changes in this version: all func's (except _EndTarget)
	;have basic error handling(return 0 and set @error)
	**18 July 2005 added MonthCal and Obj(embedded ActiveX) to the lineup
	*NOTE: Beta-Only Functions  (Graphic, MonthCal, and Obj) are commented for ease of use with the production release!!!!
	**3 AUG 2005 fixed _TargetSetStyle "Remove" to operate properly
	**7 AUG 2005 Renamed _TargetSetStyle() to _TargetStyle()
	when called with no params, returns the current Styles and Exstyles
	changed "Action" verbs to "set", "unset", and "replace"
	**8 AUG 2005 fixed _TargetStyle Select/Case Logic (messed it up from v2.2_____ooops!)
	**10 AUG 2005 added "toggle" to _TargetStyle()
	**12 AUG 2005 added _AnyGUI_GetMenuHandle() and _AnyGUI_SetMenuState()
	**22 FEB 2007 added _TargetAddDraglist() with associated auxiliary functions, and uncommented previous Beta functions
	**05 MAR 2007 modified _GuiTarget() to allow passing coord array in place of ControlId(for .net controls that don't play nice)
	
	----------------Unofficial Updates-----------------------
	**21 AUG 2008 updated to support AutoIt 3.2.12.x with the following changes..
		- Errors are debugged to console instead of a msgbox()
		- Reformated for consistency with the new UDF scheme (Older scripts will need to be updated)
			Older ........................... Newer
			----------------------------------------------------------
			; _GuiTarget   --> _AnyGUI_Create
			; _EndTarget   --> _AnyGUI_Destroy
			; _TargetaddChild(   --> _AnyGUI_AddChild
			; _TargetaddAvi   --> _AnyGUI_AddAvi
			; _TargetaddButton   --> _AnyGUI_AddButton
			; _TargetaddCheckbox   --> _AnyGUI_AddCheckbox
			; _TargetaddCombo   --> _AnyGUI_AddCombo
			; _TargetaddDate   --> _AnyGUI_AddDate
			; _TargetaddEdit   --> _AnyGUI_AddEdit
			; _TargetaddGraphic   --> _AnyGUI_AddGraphic
			; _TargetaddGroup   --> _AnyGUI_AddGroup
			; _TargetaddIcon   --> _AnyGUI_AddIcon
			; _TargetaddInput   --> _AnyGUI_AddInput
			; _TargetaddLabel   --> _AnyGUI_AddLabel
			; _TargetaddList   --> _AnyGUI_AddList
			; _TargetaddDragList   --> _AnyGUI_AddDragList
			; _TargetaddListview   --> _AnyGUI_AddListview
			; _TargetaddMonthCal   --> _AnyGUI_AddMonthCal
			; _TargetaddObj   --> _AnyGUI_AddObj
			; _TargetaddPic   --> _AnyGUI_AddPic
			; _TargetaddProgress   --> _AnyGUI_AddProgress
			; _TargetaddSlider   --> _AnyGUI_AddSlider
			; _TargetaddTab   --> _AnyGUI_AddTab
			; _TargetaddTreeview   --> _AnyGUI_AddTreeview
			; _TargetStyle   --> _AnyGUI_SetStyle
			; _WinMenuGetHandle   --> _AnyGUI_GetMenuHandle
			; _WinMenuSetState   --> _AnyGUI_SetMenuState
		
#ce
#endregion

;==============================================================================================================================
; ===============================================================================================================================
; depricated functions will no longer work
; ===============================================================================================================================
; #OLD_FUNCTIONS#================================================================================================================
; Old Function/Name                      ; --> New Function/Name/Replacement(s)
; ===============================================================================================================================
; _GuiTarget   							;--> _AnyGUI_Create
; _EndTarget   							;--> _AnyGUI_Destroy
; _TargetaddChild(   					;--> _AnyGUI_AddChild
; _TargetaddAvi   						;--> _AnyGUI_AddAvi
; _TargetaddButton   					;--> _AnyGUI_AddButton
; _TargetaddCheckbox   					;--> _AnyGUI_AddCheckbox
; _TargetaddCombo   					;--> _AnyGUI_AddCombo
; _TargetaddDate   						;--> _AnyGUI_AddDate
; _TargetaddEdit   						;--> _AnyGUI_AddEdit
; _TargetaddGraphic   					;--> _AnyGUI_AddGraphic
; _TargetaddGroup   					;--> _AnyGUI_AddGroup
; _TargetaddIcon   						;--> _AnyGUI_AddIcon
; _TargetaddInput   					;--> _AnyGUI_AddInput
; _TargetaddLabel   					;--> _AnyGUI_AddLabel
; _TargetaddList   						;--> _AnyGUI_AddList
; _TargetaddDragList   					;--> _AnyGUI_AddDragList
; _TargetaddListview   					;--> _AnyGUI_AddListview
; _TargetaddMonthCal   					;--> _AnyGUI_AddMonthCal
; _TargetaddObj  						;--> _AnyGUI_AddObj
; _TargetaddPic   						;--> _AnyGUI_AddPic
; _TargetaddProgress   					;--> _AnyGUI_AddProgress
; _TargetaddSlider  					;--> _AnyGUI_AddSlider
; _TargetaddTab   						;--> _AnyGUI_AddTab
; _TargetaddTreeview   					;--> _AnyGUI_AddTreeview
; _TargetStyle   						;--> _AnyGUI_SetStyle
; _WinMenuGetHandle   					;--> _AnyGUI_GetMenuHandle
; _WinMenuSetState   					;--> _AnyGUI_SetMenuState
; ===============================================================================================================================

; #VARIABLES# ===================================================================================================================
Global $_Debug_AG = False

; #CURRENT# =====================================================================================================================
; _AnyGUI_Create
; _AnyGUI_Destroy
; _AnyGUI_AddChild
; _AnyGUI_AddAvi
; _AnyGUI_AddButton
; _AnyGUI_AddCheckbox
; _AnyGUI_AddCombo
; _AnyGUI_AddDate
; _AnyGUI_AddEdit
; _AnyGUI_AddGraphic
; _AnyGUI_AddGroup
; _AnyGUI_AddIcon
; _AnyGUI_AddInput
; _AnyGUI_AddLabel
; _AnyGUI_AddList
; _AnyGUI_AddDragList
; _AnyGUI_AddListview
; _AnyGUI_AddMonthCal
; _AnyGUI_AddObj
; _AnyGUI_AddPic
; _AnyGUI_AddProgress
; _AnyGUI_AddSlider
; _AnyGUI_AddTab
; _AnyGUI_AddTreeview
; _AnyGUI_SetStyle
; _AnyGUI_GetMenuHandle
; _AnyGUI_SetMenuState
; ===============================================================================================================================

; #INTERNAL_USE_ONLY#============================================================================================================
; _AnyGUI_Debug
;___Makedraglist
;___DrawInsert
;___LBItemFromPt
;___Refresh
;___DraglistHandler
;===============================================================================================================================

; #FUNCTION# ====================================================================================================================
; Function Name:    _AnyGUI_Create()
; Description:      Targets any existing Window/Control for Control/Child window additions
; Parameter(s):     $wintitle               - Window Title
;                   $mode      [optional]     1 = "Single Window";
;                                [Default]==> all else = "Multiple"
;                   $wintext   [optional]   - Text in "Target" window
;                   $controlid [optional]   - "Targeted" Control in window **OR** array containing x and y coords
; Requirement(s):   #include <guiconstants.au3>
; Return Value(s):  On Success - Mode = 1: Global hWnd to window or control
;                              - Mode = "", or any value that isn't 1: Local hWnd to _
;                                           window or control.
;                   On Failure: returns 0 and @error set to 1
; Author(s):        Quaizywabbit
; ===============================================================================================================================
Func _AnyGUI_Create($wintitle, $mode = 0, $wintext = 0, $controlid = 0)
    Local $hWnd
    WinWait($wintitle)
    $hWnd = WinGetHandle($wintitle)
    If Not ($controlid = 0) Then
        Select
            Case IsArray($controlid)
                $ctlhwnd = DllCall("user32.dll", "hwnd", "ChildWindowFromPoint", "hwnd", $hWnd, "int", $controlid[0], "int", $controlid[1])
                If IsHWnd($ctlhwnd[0]) And $ctlhwnd[0] <> 0x00000000 And $ctlhwnd[0] <> $hWnd Then;checks for valid control hwnd
                    $ID = DllCall("User32.dll", "int", "GetDlgCtrlID", "hwnd", $ctlhwnd[0])
                    ConsoleWrite("ControlId = " & $ID[0] & @CRLF)
                    $hWnd = $ctlhwnd[0]
                Else
                    _AnyGUI_Debug("Invalid coordinates" & "(" & $controlid[0] & " ," & $controlid[1] & ")" & @CRLF)
                    Return SetError(1, 0, 0) ; invalid coords
                EndIf
            Case Else
                $hWnd = ControlGetHandle($wintitle, $wintext, $controlid)
        EndSelect
    EndIf
    If Not IsHWnd($hWnd) Then SetError(1)
    Select
        Case @error = 1
            _AnyGUI_Debug("Could not get hwnd" & @CRLF)
            _AnyGUI_Destroy()
            Return SetError(2, 0, 0)
        Case $mode = 1
            Global $TargethWnd = $hWnd
            Return $TargethWnd
        Case Else
            Local $LocTargethWnd = $hWnd
            Return $LocTargethWnd
    EndSelect
EndFunc  ;==>_AnyGUI_Create

; #FUNCTION# ====================================================================================================================
; Function Name:    _AnyGUI_Destroy()
; Description:      Resets _AnyGUI_Create GLOBAL variable value to 0 (when used with Mode 1)
; Parameter(s):     None
; Requirement(s):   #include <guiconstants.au3>
; Return Value(s):  None
; Author(s):        Quaizywabbit
; ===============================================================================================================================
Func _AnyGUI_Destroy()
    Global $TargethWnd = 0
    Return $TargethWnd
EndFunc  ;==>_AnyGUI_Destroy

; #FUNCTION# ====================================================================================================================
; Function Name:    _AnyGUI_AddChild()
; Description:      Adds a Child window to the "Targeted" existing control/window
; Parameter(s):     $text                     - Child window title text
;                   $PosX                     - 'X' horiz. position coordinate
;                   $PosY                     - 'Y' vert.  position coordinate
;                   $SizeX                    - 'X' horiz. Size value
;                   $SizeY                    - 'Y' vert.  Size value
;                   $LocTargethWnd [optional] - 'Local' _AnyGUI_Create assigned variable
; Requirement(s):   #include <guiconstants.au3>
; Return Value(s):  On Success - Returns hWnd of Child window
;                   On Failure - Returns 0 and @error set to 1
; Author(s):        Quaizywabbit
;=================================================================================================================================
Func _AnyGUI_AddChild($text, $PosX, $PosY, $SizeX, $SizeY, $LocTargethWnd = 0);
    If Not ($LocTargethWnd = 0) Then
        $TargethWnd = $LocTargethWnd
    Else
        _AnyGUI_Debug("Invalid or nonexisting target hwnd" & @CRLF)
        Return 0
    EndIf
    
    If IsHWnd($TargethWnd) Then
        Local $a = GUICreate($text, $SizeX, $SizeY, $PosX, $PosY, $WS_CHILD, -1, $TargethWnd)
    Else
        _AnyGUI_Debug("Invalid or nonexisting target hwnd" & @CRLF)
    EndIf
    If $a = 0 Then SetError(1)
    Return $a
EndFunc  ;==>_AnyGUI_AddChild

; #FUNCTION# ====================================================================================================================
; Function Name:    _AnyGUI_AddAvi()
; Description:      Add Avi to existing control/window
; Parameter(s):     $filename     - The filename of the video. Only .avi files are supported.
;                   $subfileid    - id of the subfile to be used. If the file only contains one video then use -1.
;                   $PosX         - 'X' horiz. position coordinate
;                   $PosY         - 'Y' vert.  position coordinate
;                   $SizeX        - 'X' horiz. Size value
;                   $SizeY        - 'Y' vert.  Size value
;                   $style [optional] - 'style' of Avi control
;                   $exstyle[optional]- 'exstyle' of Avi control
;                    $LocTargethWnd [optional] - 'Local' _AnyGUI_Create assigned variable
; Requirement(s):   #include <guiconstants.au3>
; Return Value(s):  On Success - Returns 3 element array:
;                   $a[0] = ControlId of Avi control
;                   $a[1] = hWnd of Avi control
;                   $a[2] = hWnd of Avi controls Child window
;                   On Failure -  returns 0, @error set to 1
; Author(s):        Quaizywabbit
;================================================================================================================================
Func _AnyGUI_AddAvi($filename, $subfileid, $PosX, $PosY, $SizeX, $SizeY, $style = -1, $exstyle = -1, $LocTargethWnd = 0)
    If Not ($LocTargethWnd = 0) Then $TargethWnd = $LocTargethWnd
    Local $text = $filename
    Local $a[3]
    $a[2] = _AnyGUI_AddChild($text, $PosX, $PosY, $SizeX, $SizeY, $TargethWnd)
    $a[0] = GUICtrlCreateAvi($filename, $subfileid, 0, 0, $SizeX, $SizeY, $style, $exstyle)
    $a[1] = ControlGetHandle($a[2], "", $a[0])
    If $a[2] = 0 Or $a[0] = 0 Or $a[1] = "" Then
        SetError(1)
        Return 0
    Else
        Return $a
    EndIf
EndFunc  ;==>_AnyGUI_AddAvi

; #FUNCTION# ====================================================================================================================
; Function Name:    _AnyGUI_AddButton()
; Description:      Add Button to existing control/window
; Parameter(s):     $text     - text to display on button
;                   $PosX     - 'X' horiz. position coordinate
;                   $PosY     - 'Y' vert.  position coordinate
;                   $SizeX    - 'X' horiz. Size value
;                   $SizeY    - 'Y' vert.  Size value
;                   $style [optional]    - 'style' of Button control
;                   $exstyle [optional]  - 'exstyle' of Button control
;                   $LocTargethWnd [optional] - 'Local' _AnyGUI_Create assigned variable
; Requirement(s):   #include <guiconstants.au3>
; Return Value(s):  On Success - Returns 3 element array:
;                   $a[0] = ControlId of Button control
;                   $a[1] = hWnd of Button control
;                   $a[2] = hWnd of Button controls Child window
;                   On Failure -  returns 0, @error set to 1
; Author(s):        Quaizywabbit
;================================================================================================================================
Func _AnyGUI_AddButton($text, $PosX, $PosY, $SizeX, $SizeY, $style = -1, $exstyle = -1, $LocTargethWnd = 0)
    If Not ($LocTargethWnd = 0) Then $TargethWnd = $LocTargethWnd
    Local $a[3]
    $a[2] = _AnyGUI_AddChild($text, $PosX, $PosY, $SizeX, $SizeY, $TargethWnd)
    $a[0] = GUICtrlCreateButton($text, 0, 0, $SizeX, $SizeY, $style, $exstyle)
    $a[1] = ControlGetHandle($a[2], "", $a[0])
    If $a[2] = 0 Or $a[0] = 0 Or $a[1] = "" Then
        SetError(1)
        Return 0
    Else
        Return $a
    EndIf
EndFunc  ;==>_AnyGUI_AddButton

; #FUNCTION# ====================================================================================================================
; Function Name:    _AnyGUI_AddCheckbox()
; Description:      Add Checkbox to existing control/window
; Parameter(s):     $text      - Checkbox label text
;                   $PosX      - 'X' horiz. position coordinate
;                   $PosY      - 'Y' vert.  position coordinate
;                   $SizeX     - 'X' horiz. Size value
;                   $SizeY     - 'Y' vert.  Size value
;                   $style [optional]    - 'style' of Checkbox control
;                   $exstyle [optional]  - 'exstyle' of Checkbox control
;                   $LocTargethWnd [optional] - 'Local' _AnyGUI_Create assigned variable
; Requirement(s):   #include <guiconstants.au3>
; Return Value(s):  On Success - Returns 3 element array:
;                   $a[0] = ControlId of Checkbox control
;                   $a[1] = hWnd of Checkbox control
;                   $a[2] = hWnd of Checkbox controls Child window
;                   On Failure -  returns 0, @error set to 1
; Author(s):        Quaizywabbit
;================================================================================================================================
Func _AnyGUI_AddCheckbox($text, $PosX, $PosY, $SizeX, $SizeY, $style = -1, $exstyle = -1, $LocTargethWnd = 0)
    If Not ($LocTargethWnd = 0) Then $TargethWnd = $LocTargethWnd
    Local $a[3]
    $a[2] = _AnyGUI_AddChild($text, $PosX, $PosY, $SizeX, $SizeY, $TargethWnd)
    $a[0] = GUICtrlCreateCheckbox($text, 0, 0, $SizeX, $SizeY, $style, $exstyle)
    $a[1] = ControlGetHandle($a[2], "", $a[0])
    If $a[2] = 0 Or $a[0] = 0 Or $a[1] = "" Then
        SetError(1)
        Return 0
    Else
        Return $a
    EndIf
EndFunc  ;==>_AnyGUI_AddCheckbox


; #FUNCTION# ====================================================================================================================
; Function Name:    _AnyGUI_AddCombo()
; Description:      Add Combo to existing control/window
; Parameter(s):     $text         - text which will appear in the combo control
;                   $PosX         - 'X' horiz. position coordinate
;                   $PosY         - 'Y' vert.  position coordinate
;                   $SizeX        - 'X' horiz. Size value
;                   $SizeY        - 'Y' vert.  Size value
;                   $style [optional]    - 'style' of Combo control
;                   $exstyle [optional]  - 'exstyle' of Combo control
;                   $LocTargethWnd [optional] - 'Local' _AnyGUI_Create assigned variable
; Requirement(s):   #include <guiconstants.au3>
; Return Value(s):  On Success - Returns 3 element array:
;                   $a[0] = ControlId of Combo control
;                   $a[1] = hWnd of Combo control
;                   $a[2] = hWnd of Combo controls Child window
;                   On Failure -  returns 0, @error set to 1
; Author(s):        Quaizywabbit
;================================================================================================================================
Func _AnyGUI_AddCombo($text, $PosX, $PosY, $SizeX, $SizeY, $style = -1, $exstyle = -1, $LocTargethWnd = 0)
    If Not ($LocTargethWnd = 0) Then $TargethWnd = $LocTargethWnd
    Local $a[3]
    $a[2] = _AnyGUI_AddChild($text, $PosX, $PosY, $SizeX, $SizeY, $TargethWnd)
    $a[0] = GUICtrlCreateCombo($text, 0, 0, $SizeX, $SizeY, $style, $exstyle)
    $a[1] = ControlGetHandle($a[2], "", $a[0])
    If $a[2] = 0 Or $a[0] = 0 Or $a[1] = "" Then
        SetError(1)
        Return 0
    Else
        Return $a
    EndIf
EndFunc  ;==>_AnyGUI_AddCombo

; #FUNCTION# ====================================================================================================================
; Function Name:    _AnyGUI_AddDate()
; Description:      Add Date control to existing control/window
; Parameter(s):     $text         - the preselected date
;                   $PosX         - 'X' horiz. position coordinate
;                   $PosY         - 'Y' vert.  position coordinate
;                   $SizeX        - 'X' horiz. Size value
;                   $SizeY        - 'Y' vert.  Size value
;                   $style [optional]    - 'style' of Date control
;                   $exstyle [optional]  - 'exstyle' of Date control
;                   $LocTargethWnd [optional] - 'Local' _AnyGUI_Create assigned variable
; Requirement(s):   #include <guiconstants.au3>
; Return Value(s):  On Success - Returns 3 element array:
;                   $a[0] = ControlId of Date control
;                   $a[1] = hWnd of Date control
;                   $a[2] = hWnd of Date controls Child window
;                   On Failure -  returns 0, @error set to 1
; Author(s):        Quaizywabbit
;================================================================================================================================
Func _AnyGUI_AddDate($text, $PosX, $PosY, $SizeX, $SizeY, $style = -1, $exstyle = -1, $LocTargethWnd = 0)
    If Not ($LocTargethWnd = 0) Then $TargethWnd = $LocTargethWnd
    Local $a[3]
    $a[2] = _AnyGUI_AddChild($text, $PosX, $PosY, $SizeX, $SizeY, $TargethWnd)
    $a[0] = GUICtrlCreateDate($text, 0, 0, $SizeX, $SizeY, $style, $exstyle)
    $a[1] = ControlGetHandle($a[2], "", $a[0])
    If $a[2] = 0 Or $a[0] = 0 Or $a[1] = "" Then
        SetError(1)
        Return 0
    Else
        Return $a
    EndIf
EndFunc  ;==>_AnyGUI_AddDate

; #FUNCTION# ====================================================================================================================
; Function Name:    _AnyGUI_AddEdit()
; Description:      Add Edit control to existing control/window
; Parameter(s):     $text         - the text of the control
;                   $PosX         - 'X' horiz. position coordinate
;                   $PosY         - 'Y' vert.  position coordinate
;                   $SizeX        - 'X' horiz. Size value
;                   $SizeY        - 'Y' vert.  Size value
;                   $style [optional]    - 'style' of Edit control
;                   $exstyle [optional]  - 'exstyle' of Edit control
;                   $LocTargethWnd [optional] - 'Local' _AnyGUI_Create assigned variable
; Requirement(s):   #include <guiconstants.au3>
; Return Value(s):  On Success - Returns 3 element array:
;                   $a[0] = ControlId of Edit control
;                   $a[1] = hWnd of Edit control
;                   $a[2] = hWnd of Edit controls Child window
;                   On Failure -  returns 0, @error set to 1
; Author(s):        Quaizywabbit
;=================================================================================================================================
Func _AnyGUI_AddEdit($text, $PosX, $PosY, $SizeX, $SizeY, $style = -1, $exstyle = -1, $LocTargethWnd = 0)
    If Not ($LocTargethWnd = 0) Then $TargethWnd = $LocTargethWnd
    Local $a[3]
    $a[2] = _AnyGUI_AddChild($text, $PosX, $PosY, $SizeX, $SizeY, $TargethWnd)
    $a[0] = GUICtrlCreateEdit($text, 0, 0, $SizeX, $SizeY, $style, $exstyle)
    $a[1] = ControlGetHandle($a[2], "", $a[0])
    If $a[2] = 0 Or $a[0] = 0 Or $a[1] = "" Then
        SetError(1)
        Return 0
    Else
        Return $a
    EndIf
EndFunc  ;==>_AnyGUI_AddEdit

; #FUNCTION# ====================================================================================================================
; Function Name:    _AnyGUI_AddGraphic()
; Description:      Add Graphic to existing control/window
; Parameter(s):     $PosX         - 'X' horiz. position coordinate
;                   $PosY         - 'Y' vert.  position coordinate
;                   $SizeX        - 'X' horiz. Size value
;                   $SizeY        - 'Y' vert.  Size value
;                   $style [optional]    - 'style' of Graphic control
;                   $LocTargethWnd [optional] - 'Local' _AnyGUI_Create assigned variable
; Requirement(s):   #include <guiconstants.au3>
; Return Value(s):  On Success - Returns 3 element array:
;                   $a[0] = ControlId of Graphic control
;                   $a[1] = hWnd of Graphic control
;                   $a[2] = hWnd of Graphic controls Child window
;                   On Failure -  returns 0, @error set to 1
; Author(s):        Quaizywabbit
;=================================================================================================================================
Func _AnyGUI_AddGraphic($PosX, $PosY, $SizeX, $SizeY, $style = -1, $LocTargethWnd = 0)
    If Not ($LocTargethWnd = 0) Then $TargethWnd = $LocTargethWnd
    Local $a[3]
    $a[2] = _AnyGUI_AddChild("", $PosX, $PosY, $SizeX, $SizeY, $TargethWnd)
    $a[0] = GUICtrlCreateGraphic($PosX, $PosY, $SizeX, $SizeY, $style)
    $a[1] = ControlGetHandle($a[2], "", $a[0])
    If $a[2] = 0 Or $a[0] = 0 Or $a[1] = "" Then
        SetError(1)
        Return 0
    Else
        Return $a
    EndIf
EndFunc  ;==>_AnyGUI_AddGraphic

; #FUNCTION# ====================================================================================================================
; Function Name:    _AnyGUI_AddGroup()
; Description:      Add Group control to existing control/window
; Parameter(s):     $text         - Group label text
;                   $PosX         - 'X' horiz. position coordinate
;                   $PosY         - 'Y' vert.  position coordinate
;                   $SizeX        - 'X' horiz. Size value
;                   $SizeY        - 'Y' vert.  Size value
;                   $style [optional]    - 'style' of Group control
;                   $exstyle [optional]  - 'exstyle' of Group control
;                   $LocTargethWnd [optional] - 'Local' _AnyGUI_Create assigned variable
; Requirement(s):   #include <guiconstants.au3>
; Return Value(s):  On Success - Returns 3 element array:
;                   $a[0] = ControlId of Group control
;                   $a[1] = hWnd of Group control
;                   $a[2] = hWnd of Group controls Child window
;                   On Failure -  returns 0, @error set to 1
; Author(s):        Quaizywabbit
;=================================================================================================================================
Func _AnyGUI_AddGroup($text, $PosX, $PosY, $SizeX, $SizeY, $style = -1, $exstyle = -1, $LocTargethWnd = 0)
    If Not ($LocTargethWnd = 0) Then $TargethWnd = $LocTargethWnd
    Local $a[3]
    $a[2] = _AnyGUI_AddChild($text, $PosX, $PosY, $SizeX, $SizeY, $TargethWnd)
    $a[0] = GUICtrlCreateGroup($text, 0, 0, $SizeX, $SizeY, $style, $exstyle)
    $a[1] = ControlGetHandle($a[2], "", $a[0])
    If $a[2] = 0 Or $a[0] = 0 Or $a[1] = "" Then
        SetError(1)
        Return 0
    Else
        Return $a
    EndIf
EndFunc  ;==>_AnyGUI_AddGroup

; #FUNCTION# ====================================================================================================================
; Function Name:    _AnyGUI_AddIcon()
; Description:      Add Icon to existing control/window
; Parameter(s):     $filename      - filename of the icon to be loaded
;                   $iconID        - Icon identifier if the file contain multiple icon. Otherwise -1.
;                   $PosX         - 'X' horiz. position coordinate
;                   $PosY         - 'Y' vert.  position coordinate
;                   $SizeX        - 'X' horiz. Size value
;                   $SizeY        - 'Y' vert.  Size value
;                   $style [optional]    - 'style' of Icon control
;                   $exstyle [optional]  - 'exstyle' of Icon control
;                   $LocTargethWnd [optional] - 'Local' _AnyGUI_Create assigned variable
; Requirement(s):   #include <guiconstants.au3>
; Return Value(s):  On Success - Returns 3 element array:
;                   $a[0] = ControlId of Icon control
;                   $a[1] = hWnd of Icon control
;                   $a[2] = hWnd of Icon controls Child window
;                   On Failure -  returns 0, @error set to 1
; Author(s):        Quaizywabbit
;=================================================================================================================================
Func _AnyGUI_AddIcon($filename, $iconID, $PosX, $PosY, $SizeX, $SizeY, $style = -1, $exstyle = -1, $LocTargethWnd = 0)
    If Not ($LocTargethWnd = 0) Then $TargethWnd = $LocTargethWnd
    Local $a[3]
    $a[2] = _AnyGUI_AddChild("", $PosX, $PosY, $SizeX, $SizeY, $TargethWnd)
    $a[0] = GUICtrlCreateIcon($filename, $iconID, 0, 0, $SizeX, $SizeY, $style, $exstyle)
    $a[1] = ControlGetHandle($a[2], "", $a[0])
    If $a[2] = 0 Or $a[0] = 0 Or $a[1] = "" Then
        SetError(1)
        Return 0
    Else
        Return $a
    EndIf
EndFunc  ;==>_AnyGUI_AddIcon

; #FUNCTION# ====================================================================================================================
; Function Name:    _AnyGUI_AddInput()
; Description:      Add Input control to existing control/window
; Parameter(s):     $text         - The text of the control
;                   $PosX         - 'X' horiz. position coordinate
;                   $PosY         - 'Y' vert.  position coordinate
;                   $SizeX        - 'X' horiz. Size value
;                   $SizeY        - 'Y' vert.  Size value
;                   $style [optional]    - 'style' of Input control
;                   $exstyle [optional]  - 'exstyle' of Input control
;                   $LocTargethWnd [optional] - 'Local' _AnyGUI_Create assigned variable
; Requirement(s):   #include <guiconstants.au3>
; Return Value(s):  On Success - Returns 3 element array:
;                   $a[0] = ControlId of Input control
;                   $a[1] = hWnd of Input control
;                   $a[2] = hWnd of Input controls Child window
;                   On Failure -  returns 0, @error set to 1
; Author(s):        Quaizywabbit
;=================================================================================================================================
Func _AnyGUI_AddInput($text, $PosX, $PosY, $SizeX, $SizeY, $style = -1, $exstyle = -1, $LocTargethWnd = 0)
    If Not ($LocTargethWnd = 0) Then $TargethWnd = $LocTargethWnd
    Local $a[3]
    $a[2] = _AnyGUI_AddChild($text, $PosX, $PosY, $SizeX, $SizeY, $TargethWnd)
    $a[0] = GUICtrlCreateInput($text, 0, 0, $SizeX, $SizeY, $style, $exstyle)
    $a[1] = ControlGetHandle($a[2], "", $a[0])
    If $a[2] = 0 Or $a[0] = 0 Or $a[1] = "" Then
        SetError(1)
        Return 0
    Else
        Return $a
    EndIf
EndFunc  ;==>_AnyGUI_AddInput

; #FUNCTION# ====================================================================================================================
; Function Name:    _AnyGUI_AddLabel()
; Description:      Add Label to existing control/window
; Parameter(s):     $text         - The text of the control.
;                   $PosX         - 'X' horiz. position coordinate
;                   $PosY         - 'Y' vert.  position coordinate
;                   $SizeX        - 'X' horiz. Size value
;                   $SizeY        - 'Y' vert.  Size value
;                   $style [optional]    - 'style' of Label control
;                   $exstyle [optional]  - 'exstyle' of Label control
;                   $LocTargethWnd [optional] - 'Local' _AnyGUI_Create assigned variable
; Requirement(s):   #include <guiconstants.au3>
; Return Value(s):  On Success - Returns 3 element array:
;                   $a[0] = ControlId of Label control
;                   $a[1] = hWnd of Label control
;                   $a[2] = hWnd of Label controls Child window
;                   On Failure -  returns 0, @error set to 1
; Author(s):        Quaizywabbit
;=================================================================================================================================
Func _AnyGUI_AddLabel($text, $PosX, $PosY, $SizeX, $SizeY, $style = -1, $exstyle = -1, $LocTargethWnd = 0)
    If Not ($LocTargethWnd = 0) Then $TargethWnd = $LocTargethWnd
    Local $a[3]
    $a[2] = _AnyGUI_AddChild($text, $PosX, $PosY, $SizeX, $SizeY, $TargethWnd)
    $a[0] = GUICtrlCreateLabel($text, 0, 0, $SizeX, $SizeY, $style, $exstyle)
    $a[1] = ControlGetHandle($a[2], "", $a[0])
    If $a[2] = 0 Or $a[0] = 0 Or $a[1] = "" Then
        SetError(1)
        Return 0
    Else
        Return $a
    EndIf
EndFunc  ;==>_AnyGUI_AddLabel

; #FUNCTION# ====================================================================================================================
; Function Name:    _AnyGUI_AddList()
; Description:      Add List control to existing control/window
; Parameter(s):     $text         - The text of the control.
;                   $PosX         - 'X' horiz. position coordinate
;                   $PosY         - 'Y' vert.  position coordinate
;                   $SizeX        - 'X' horiz. Size value
;                   $SizeY        - 'Y' vert.  Size value
;                   $style [optional]    - 'style' of List control
;                   $exstyle [optional]  - 'exstyle' of List control
;                   $LocTargethWnd [optional] - 'Local' _AnyGUI_Create assigned variable
; Requirement(s):   #include <guiconstants.au3>
; Return Value(s):  On Success - Returns 3 element array:
;                   $a[0] = ControlId of List control
;                   $a[1] = hWnd of List control
;                   $a[2] = hWnd of List controls Child window
;                   On Failure -  returns 0, @error set to 1
; Author(s):        Quaizywabbit
;=================================================================================================================================
Func _AnyGUI_AddList($text, $PosX, $PosY, $SizeX, $SizeY, $style = -1, $exstyle = -1, $LocTargethWnd = 0)
    If Not ($LocTargethWnd = 0) Then $TargethWnd = $LocTargethWnd
    Local $a[3]
    $a[2] = _AnyGUI_AddChild($text, $PosX, $PosY, $SizeX, $SizeY, $TargethWnd)
    $a[0] = GUICtrlCreateList($text, 0, 0, $SizeX, $SizeY, $style, $exstyle)
    $a[1] = ControlGetHandle($a[2], "", $a[0])
    If $a[2] = 0 Or $a[0] = 0 Or $a[1] = "" Then
        SetError(1)
        Return 0
    Else
        Return $a
    EndIf
EndFunc  ;==>_AnyGUI_AddList

; #FUNCTION# ====================================================================================================================
; Function Name:    _AnyGUI_AddDragList()
; Description:      Adds DragList control to existing control/window
; Parameter(s):     $text         - The text of the control.
;                   $PosX         - 'X' horiz. position coordinate
;                   $PosY         - 'Y' vert.  position coordinate
;                   $SizeX        - 'X' horiz. Size value
;                   $SizeY        - 'Y' vert.  Size value
;                   $style [optional]    - 'style' of List control
;                   $exstyle [optional]  - 'exstyle' of List control
;                   $LocTargethWnd [optional] - 'Local' _AnyGUI_Create assigned variable
; Requirement(s):   #include <guiconstants.au3> and <guilist.au3>
; Return Value(s):  On Success - Returns 3 element array:
;                   $a[0] = ControlId of List control
;                   $a[1] = hWnd of List control
;                   $a[2] = hWnd of List controls Child window
;                   On Failure -  returns 0, @error set to 1
; Author(s):        Quaizywabbit
;=================================================================================================================================
Func _AnyGUI_AddDragList($text, $PosX, $PosY, $SizeX, $SizeY, $style = -1, $exstyle = -1, $LocTargethWnd = 0)
    If Not ($LocTargethWnd = 0) Then $TargethWnd = $LocTargethWnd
    Local $a[3]
    $a[2] = _AnyGUI_AddChild($text, $PosX, $PosY, $SizeX, $SizeY, $TargethWnd)
    $a[0] = GUICtrlCreateList($text, 15, 2, $SizeX - 15, $SizeY - 2, $style, $exstyle)
    $a[1] = ControlGetHandle($a[2], "", $a[0])
    ___Makedraglist($a[1])
    If $a[2] = 0 Or $a[0] = 0 Or $a[1] = "" Then
        SetError(1)
        Return 0
    Else
        Return $a
    EndIf
EndFunc  ;==>_AnyGUI_AddDragList

; #FUNCTION# ====================================================================================================================
; Function Name:    _AnyGUI_AddListview()
; Description:      Add Listview control to existing control/window
; Parameter(s):     $text         - definition of column heading.
;                   $PosX         - 'X' horiz. position coordinate
;                   $PosY         - 'Y' vert.  position coordinate
;                   $SizeX        - 'X' horiz. Size value
;                   $SizeY        - 'Y' vert.  Size value
;                   $style [optional]    - 'style' of Listview control
;                   $exstyle [optional]  - 'exstyle' of Listview control
;                   $LocTargethWnd [optional] - 'Local' _AnyGUI_Create assigned variable
; Requirement(s):   #include <guiconstants.au3>
; Return Value(s):  On Success - Returns 3 element array:
;                   $a[0] = ControlId of Listview control
;                   $a[1] = hWnd of Listview control
;                   $a[2] = hWnd of Listview controls Child window
;                   On Failure -  returns 0, @error set to 1
; Author(s):        Quaizywabbit
;=================================================================================================================================
Func _AnyGUI_AddListview($text, $PosX, $PosY, $SizeX, $SizeY, $style = -1, $exstyle = -1, $LocTargethWnd = 0)
    If Not ($LocTargethWnd = 0) Then $TargethWnd = $LocTargethWnd
    Local $a[3]
    $a[2] = _AnyGUI_AddChild($text, $PosX, $PosY, $SizeX, $SizeY, $TargethWnd)
    $a[0] = GUICtrlCreateListView($text, 0, 0, $SizeX, $SizeY, $style, $exstyle)
    $a[1] = ControlGetHandle($a[2], "", $a[0])
    If $a[2] = 0 Or $a[0] = 0 Or $a[1] = "" Then
        SetError(1)
        Return 0
    Else
        Return $a
    EndIf
EndFunc  ;==>_AnyGUI_AddListview

; #FUNCTION# ====================================================================================================================
; Function Name:    _AnyGUI_AddMonthCal()
; Description:      Adds MonthCal control to existing control/window
; Parameter(s):     $text         - The text of the control.
;                   $PosX         - 'X' horiz. position coordinate
;                   $PosY         - 'Y' vert.  position coordinate
;                   $SizeX        - 'X' horiz. Size value
;                   $SizeY        - 'Y' vert.  Size value
;                   $style [optional]    - 'style' of MonthCal control
;                   $exstyle [optional]  - 'exstyle' of MonthCal control
;                   $LocTargethWnd [optional] - 'Local' _AnyGUI_Create assigned variable
; Requirement(s):   #include <guiconstants.au3>
; Return Value(s):  On Success - Returns 3 element array:
;                   $a[0] = ControlId of MonthCal control
;                   $a[1] = hWnd of MonthCal control
;                   $a[2] = hWnd of MonthCal controls Child window
;                   On Failure -  returns 0, @error set to 1
; Author(s):        Quaizywabbit
;=================================================================================================================================
Func _AnyGUI_AddMonthCal($text, $PosX, $PosY, $SizeX, $SizeY, $style = -1, $exstyle = -1, $LocTargethWnd = 0)
    If Not ($LocTargethWnd = 0) Then $TargethWnd = $LocTargethWnd
    Local $a[3]
    $a[2] = _AnyGUI_AddChild($text, $PosX, $PosY, $SizeX, $SizeY, $TargethWnd)
    $a[0] = GUICtrlCreateMonthCal($text, 0, 0, $SizeX, $SizeY, $style, $exstyle)
    $a[1] = ControlGetHandle($a[2], "", $a[0])
    If $a[2] = 0 Or $a[0] = 0 Or $a[1] = "" Then
        SetError(1)
        Return 0
    Else
        Return $a
    EndIf
EndFunc  ;==>_AnyGUI_AddMonthCal

; #FUNCTION# ====================================================================================================================
; Function Name:    _AnyGUI_AddObj()
; Description:      Adds ActiveX Object control to existing control/window
; Parameter(s):     $ObjVar       - A variable pointing to a previously opened object
;                   $PosX         - 'X' horiz. position coordinate
;                   $PosY         - 'Y' vert.  position coordinate
;                   $SizeX        - 'X' horiz. Size value
;                   $SizeY        - 'Y' vert.  Size value
;                   $LocTargethWnd [optional] - 'Local' _AnyGUI_Create assigned variable
; Requirement(s):   #include <guiconstants.au3>
; Return Value(s):  On Success - Returns 3 element array:
;                   $a[0] = ControlId of ActiveX Object control
;                   $a[1] = hWnd of ActiveX Object control
;                   $a[2] = hWnd of ActiveX Object controls Child window
;                   On Failure -  returns 0, @error set to 1
; Author(s):        Quaizywabbit
;=================================================================================================================================
Func _AnyGUI_AddObj($ObjVar, $PosX, $PosY, $SizeX, $SizeY, $LocTargethWnd = 0)
    If Not ($LocTargethWnd = 0) Then $TargethWnd = $LocTargethWnd
    Local $a[3]
    $a[2] = _AnyGUI_AddChild("ActiveXObj", $PosX, $PosY, $SizeX, $SizeY, $TargethWnd)
    $a[0] = GUICtrlCreateObj($ObjVar, 0, 0, $SizeX, $SizeY)
    $a[1] = ControlGetHandle($a[2], "", $a[0])
    If $a[2] = 0 Or $a[0] = 0 Or $a[1] = "" Then
        SetError(1)
        Return 0
    Else
        Return $a
    EndIf
EndFunc  ;==>_AnyGUI_AddObj

; #FUNCTION# ====================================================================================================================
; Function Name:    _AnyGUI_AddPic()
; Description:      Add Pic to existing control/window
; Parameter(s):     $filename     - filename of the icon to be loaded.
;                   $PosX         - 'X' horiz. position coordinate
;                   $PosY         - 'Y' vert.  position coordinate
;                   $SizeX        - 'X' horiz. Size value
;                   $SizeY        - 'Y' vert.  Size value
;                   $style [optional]    - 'style' of Pic control
;                   $exstyle [optional]  - 'exstyle' of Pic control
;                   $LocTargethWnd [optional] - 'Local' _AnyGUI_Create assigned variable
; Requirement(s):   #include <guiconstants.au3>
; Return Value(s):  On Success - Returns 3 element array:
;                   $a[0] = ControlId of Pic control
;                   $a[1] = hWnd of Pic control
;                   $a[2] = hWnd of Pic controls Child window
;                   On Failure -  returns 0, @error set to 1
; Author(s):        Quaizywabbit
;=================================================================================================================================
Func _AnyGUI_AddPic($filename, $PosX, $PosY, $SizeX, $SizeY, $style = -1, $exstyle = -1, $LocTargethWnd = 0)
    If Not ($LocTargethWnd = 0) Then $TargethWnd = $LocTargethWnd
    Local $a[3]
    $a[2] = _AnyGUI_AddChild("", $PosX, $PosY, $SizeX, $SizeY, $TargethWnd)
    $a[0] = GUICtrlCreatePic($filename, 0, 0, $SizeX, $SizeY, $style, $exstyle)
    $a[1] = ControlGetHandle($a[2], "", $a[0])
    If $a[2] = 0 Or $a[0] = 0 Or $a[1] = "" Then
        SetError(1)
        Return 0
    Else
        Return $a
    EndIf
EndFunc  ;==>_AnyGUI_AddPic

; #FUNCTION# ====================================================================================================================
; Function Name:    _AnyGUI_AddProgress()
; Description:      Add Progress control to existing control/window
; Parameter(s):     $PosX         - 'X' horiz. position coordinate
;                   $PosY         - 'Y' vert.  position coordinate
;                   $SizeX        - 'X' horiz. Size value
;                   $SizeY        - 'Y' vert.  Size value
;                   $style [optional]    - 'style' of Progress control
;                   $exstyle [optional]  - 'exstyle' of Progress control
;                   $LocTargethWnd [optional] - 'Local' _AnyGUI_Create assigned variable
; Requirement(s):   #include <guiconstants.au3>
; Return Value(s):  On Success - Returns 3 element array:
;                   $a[0] = ControlId of Progress control
;                   $a[1] = hWnd of Progress control
;                   $a[2] = hWnd of Progress controls Child window
;                   On Failure -  returns 0, @error set to 1
; Author(s):        Quaizywabbit
;=================================================================================================================================
Func _AnyGUI_AddProgress($PosX, $PosY, $SizeX, $SizeY, $style = -1, $exstyle = -1, $LocTargethWnd = 0)
    If Not ($LocTargethWnd = 0) Then $TargethWnd = $LocTargethWnd
    Local $a[3]
    $a[2] = _AnyGUI_AddChild("", $PosX, $PosY, $SizeX, $SizeY, $TargethWnd)
    $a[0] = GUICtrlCreateProgress($PosX, $PosY, $SizeX, $SizeY, $style, $exstyle)
    $a[1] = ControlGetHandle($a[2], "", $a[0])
    If $a[2] = 0 Or $a[0] = 0 Or $a[1] = "" Then
        SetError(1)
        Return 0
    Else
        Return $a
    EndIf
EndFunc  ;==>_AnyGUI_AddProgress

; #FUNCTION# ====================================================================================================================
; Function Name:    _AnyGUI_AddSlider()
; Description:      Add Slider to existing control/window
; Parameter(s):     $PosX         - 'X' horiz. position coordinate
;                   $PosY         - 'Y' vert.  position coordinate
;                   $SizeX        - 'X' horiz. Size value
;                   $SizeY        - 'Y' vert.  Size value
;                   $style [optional]    - 'style' of Slider control
;                   $exstyle [optional]  - 'exstyle' of Slider control
;                   $LocTargethWnd [optional] - 'Local' _AnyGUI_Create assigned variable
; Requirement(s):   #include <guiconstants.au3>
; Return Value(s):  On Success - Returns 3 element array:
;                   $a[0] = ControlId of Slider control
;                   $a[1] = hWnd of Slider control
;                   $a[2] = hWnd of Slider controls Child window
;                   On Failure -  returns 0, @error set to 1
; Author(s):        Quaizywabbit
;=================================================================================================================================
Func _AnyGUI_AddSlider($PosX, $PosY, $SizeX, $SizeY, $style = -1, $exstyle = -1, $LocTargethWnd = 0)
    If Not ($LocTargethWnd = 0) Then $TargethWnd = $LocTargethWnd
    Local $a[3]
    $a[2] = _AnyGUI_AddChild("", $PosX, $PosY, $SizeX, $SizeY, $TargethWnd)
    $a[0] = GUICtrlCreateSlider(0, 0, $SizeX, $SizeY, $style, $exstyle)
    $a[1] = ControlGetHandle($a[2], "", $a[0])
    If $a[2] = 0 Or $a[0] = 0 Or $a[1] = "" Then
        SetError(1)
        Return 0
    Else
        Return $a
    EndIf
EndFunc  ;==>_AnyGUI_AddSlider

; #FUNCTION# ====================================================================================================================
; Function Name:    _AnyGUI_AddTab()
; Description:      Add Tab control to existing control/window
; Parameter(s):     $PosX         - 'X' horiz. position coordinate
;                   $PosY         - 'Y' vert.  position coordinate
;                   $SizeX        - 'X' horiz. Size value
;                   $SizeY        - 'Y' vert.  Size value
;                   $style [optional]    - 'style' of Tab control
;                   $exstyle [optional]  - 'exstyle' of Tab control
;                   $LocTargethWnd [optional] - 'Local' _AnyGUI_Create assigned variable
; Requirement(s):   #include <guiconstants.au3>
; Return Value(s):  On Success - Returns 3 element array:
;                   $a[0] = ControlId of Tab control
;                   $a[1] = hWnd of Tab control
;                   $a[2] = hWnd of Tab controls Child window
;                   On Failure -  returns 0, @error set to 1
; Author(s):        Quaizywabbit
;=================================================================================================================================
Func _AnyGUI_AddTab($PosX, $PosY, $SizeX, $SizeY, $style = -1, $exstyle = -1, $LocTargethWnd = 0)
    If Not ($LocTargethWnd = 0) Then $TargethWnd = $LocTargethWnd
    Local $a[3]
    $a[2] = _AnyGUI_AddChild("", $PosX, $PosY, $SizeX, $SizeY, $TargethWnd)
    $a[0] = GUICtrlCreateTab(0, 0, $SizeX, $SizeY, $style, $exstyle)
    $a[1] = ControlGetHandle($a[2], "", $a[0])
    If $a[2] = 0 Or $a[0] = 0 Or $a[1] = "" Then
        SetError(1)
        Return 0
    Else
        Return $a
    EndIf
EndFunc  ;==>_AnyGUI_AddTab

; #FUNCTION# ====================================================================================================================
; Function Name:    _AnyGUI_AddTreeview()
; Description:      Add Treeview control to existing control/window
; Parameter(s):     $PosX         - 'X' horiz. position coordinate
;                   $PosY         - 'Y' vert.  position coordinate
;                   $SizeX        - 'X' horiz. Size value
;                   $SizeY        - 'Y' vert.  Size value
;                   $style [optional]    - 'style' of Treeview control
;                   $exstyle [optional]  - 'exstyle' of Treeview control
;                   $LocTargethWnd [optional] - 'Local' _AnyGUI_Create assigned variable
; Requirement(s):   #include <guiconstants.au3>
; Return Value(s):  On Success - Returns 3 element array:
;                   $a[0] = ControlId of Treeview control
;                   $a[1] = hWnd of Treeview control
;                   $a[2] = hWnd of Treeview controls Child window
;                   On Failure -  returns 0, @error set to 1
; Author(s):        Quaizywabbit
;=================================================================================================================================
Func _AnyGUI_AddTreeview($PosX, $PosY, $SizeX, $SizeY, $style = -1, $exstyle = -1, $LocTargethWnd = 0)
    If Not ($LocTargethWnd = 0) Then $TargethWnd = $LocTargethWnd
    Local $a[3]
    $a[2] = _AnyGUI_AddChild("", $PosX, $PosY, $SizeX, $SizeY, $TargethWnd)
    $a[0] = GUICtrlCreateTreeView(0, 0, $SizeX, $SizeY, $style, $exstyle)
    $a[1] = ControlGetHandle($a[2], "", $a[0])
    If $a[2] = 0 Or $a[0] = 0 Or $a[1] = "" Then
        SetError(1)
        Return 0
    Else
        Return $a
    EndIf
EndFunc  ;==>_AnyGUI_AddTreeview

; #FUNCTION# ====================================================================================================================
; Function Name:    _AnyGUI_SetStyle()
; Description:      Retrieves/Sets/Unsets/Replaces Styles and/or Exstyles of 'targeted' control/window
;                   When called with no parameters returns the current Styles/Exstyles for the window/control
; Parameter(s):     $action[optional]     - "set", "unset", "toggle", and "replace"
;                   $Bool[optional]       - 1 to Update window/control when finished
;                   $Style[optional]      - New window style (multiple styles can be BitOr'd)
;                    $ExStyle[optional]      - New window exstyle (multiple styles can be BitOr'd)
;                   $LocTargethWnd[optional] - 'Local' _AnyGUI_Create assigned variable
; Requirement(s):   #include <guiconstants.au3>
; Return Value(s):  On success: $action left blank-returns an array with $array[0] as the current Style and $array[1] as the current Exstyle
;                   otherwise it returns previous style and exstyle
;                    If style and exstyle are changed the function will return an array
;                   with $Array[0] as the previous style and
;                    $Array[1] as the previous exstyle
;                   On Error:affected array element returns 0, error flag set to 1 if Style, 2 if ExStyle.
;                   MsgBox displayed for either.
;                   Msgbox displayed for incorrect 'action' verb, returns 0 and sets error
; Author(s):        Chase/Xenogis- - -Modified by Quaizywabbit
;                   3 AUG 2005: corrected "Remove" to operate properly(Thanks Valik and Nutster!)
;                   7 AUG 2005: changed 'action' verbs to "set", "unset", and "replace"
;                   8 AUG 2005 fixed _AnyGUI_SetStyle() Select/Case logic (messed it up from v2.2___ooops!!)
;                   10 AUG 2005 added "toggle"
; Comments:         can only do a single 'verb' during each call, so required Style/Exstyle combinations may require
;                   additional _AnyGUI_SetStyle() calls with the last call setting $Bool to 1 to update the 'target'
;=================================================================================================================================
Func _AnyGUI_SetStyle($action = 0, $Bool = 0, $style = -1, $exstyle = -1, $LocTargethWnd = 0)
    If Not ($LocTargethWnd = 0) Then $TargethWnd = $LocTargethWnd
    Local $ostyle = DllCall("user32.dll", "long", "GetWindowLong", "hwnd", $TargethWnd, "int", -16);get existing Style
    Local $oexstyle = DllCall("user32.dll", "long", "GetWindowLong", "hwnd", $TargethWnd, "int", -20);get existing ExStyle
    Select
        Case $action = "set"
            If $style <> -1 Then Local $scall = DllCall("user32.dll", "long", "SetWindowLong", "hwnd", $TargethWnd, "int", -16, "long", BitOR($ostyle[0], $style));add Style to old style
            If $exstyle <> -1 Then Local $exscall = DllCall("user32.dll", "long", "SetWindowLong", "hwnd", $TargethWnd, "int", -20, "long", BitOR($oexstyle[0], $exstyle));add Exstyle to old exstyle
        Case $action = "unset"
            If $style <> -1 Then Local $scall = DllCall("user32.dll", "long", "SetWindowLong", "hwnd", $TargethWnd, "int", -16, "long", BitAND($ostyle[0], BitNOT($style)));remove Style from old style
            If $exstyle <> -1 Then Local $exscall = DllCall("user32.dll", "long", "SetWindowLong", "hwnd", $TargethWnd, "int", -20, "long", BitAND($oexstyle[0], BitNOT($exstyle)));remove Exstyle from old exstyle
        Case $action = "toggle"
            If $style <> -1 Then Local $scall = DllCall("user32.dll", "long", "SetWindowLong", "hwnd", $TargethWnd, "int", -16, "long", BitXOR($ostyle[0], $style));Toggle Style(s) on or off
            If $exstyle <> -1 Then Local $exscall = DllCall("user32.dll", "long", "SetWindowLong", "hwnd", $TargethWnd, "int", -20, "long", BitXOR($oexstyle[0], $exstyle));Toggle ExStyle(s) on or off
        Case $action = "replace"
            If $style <> -1 Then Local $scall = DllCall("user32.dll", "long", "SetWindowLong", "hwnd", $TargethWnd, "int", -16, "long", $style);replace Style
            If $exstyle <> -1 Then Local $exscall = DllCall("user32.dll", "long", "SetWindowLong", "hwnd", $TargethWnd, "int", -20, "long", $exstyle);replace Exstyle
        Case Else
            Dim $ret[2]
            $ret[0] = $ostyle[0]
            $ret[1] = $oexstyle[0]
            Return $ret
    EndSelect
    Dim $return[2]
    If $style <> -1 And $scall[0] <> $ostyle[0] Then
        SetError(1)
        $return[0] = 0
		_AnyGUI_Debug("Error setting Style: Please check your Style settings and try again")
    ElseIf $exstyle <> -1 And $exscall[0] <> $oexstyle[0] Then
        SetError(2)
        $return[1] = 0
		_AnyGUI_Debug("Error setting ExStyle: Please check your ExStyle settings and try again")
    Else
        If $style <> -1 Then
            $return[0] = $scall[0]
        Else
            $return[0] = $ostyle[0]
        EndIf
        If $exstyle <> -1 Then
            $return[1] = $exscall[0]
        Else
            $return[1] = $oexstyle[0]
        EndIf
    EndIf
    If $Bool = 1 Then ___Refresh($TargethWnd)

    Return $return
EndFunc  ;==>_AnyGUI_SetStyle

; #FUNCTION# ====================================================================================================================
; Function Name:    _AnyGUI_GetMenuHandle()
; Description:      Retrieves handle to a Window Menu
; Parameter(s):     $hwnd    - Window handle
; Requirement(s):   none
; Return Value(s):  On Success - $ret[0] = Window handle
;                                $ret[1] = Menu handle
;                   On Failure: returns 0 and @error set to 1
;                               MsgBox shown explaining possible reasons for failure
; Author(s):        Quaizywabbit
; Comments:         Child windows cannot have menu's. Not all Non-Child windows have menu's.
;=================================================================================================================================
Func _AnyGUI_GetMenuHandle($window)
    Local $menu = DllCall("user32.dll", "hwnd", "GetMenu", "hwnd", $window)
    Local $test = DllCall("user32.dll", "int", "IsMenu", "hwnd", $menu[0])
    If $test[0] <> 0 Then
        Dim $ret[2]
        $ret[0] = $window
        $ret[1] = $menu[0]
        Return $ret
    Else
		_AnyGUI_Debug("Error-_AnyGUI_GetMenuHandle: Could not retrieve Menu handle:window is child, or has no menu")
        Return SetError(1, 0, 0)
    EndIf
EndFunc  ;==>_AnyGUI_GetMenuHandle

; #FUNCTION# ====================================================================================================================
; Function Name:    _AnyGUI_SetMenuState()
; Description:      'shows' or 'hides' a Window Menu's visibility
; Parameter(s):     $window    -     initial call = Non-Child Window handle(that has a Menu)
;                                subsequent calls = returned array variable from initial call
;                   $state     - "show" [default]
;                                "hide"
; Requirement(s):    _AnyGUI_GetMenuHandle()
; Return Value(s):  On Success(initial call only) - $ret[0] = Window handle
;                                                   $ret[1] = Menu handle
;                   On Failure: returns 0 and @error set to 1
;                               MsgBox shown explaining possible reasons for failure
; Author(s):        Quaizywabbit
; Comments:         Must "hide" before "show", when "show"ing use the initial "hide" call variable
;                   Child windows cannot have menu's("show" won't work). Not all Non-Child windows have menu's.
;=================================================================================================================================
Func _AnyGUI_SetMenuState($window, $state = "show");
;is this the initial call?
    If IsArray($window) Then; 'old call
        Local $windowhwnd = $window[0]
        Local $menuhwnd = $window[1]
    Else
        Local $get = _AnyGUI_GetMenuHandle($window); 'new call
        $windowhwnd = $get[0]
        $menuhwnd = $get[1]
    EndIf
    Select
        Case $state = "hide"
            Local $menu = 0
            Local $menusetsucceed_fail = DllCall("user32.dll", "int", "SetMenu", "hwnd", $windowhwnd, "hwnd", $menu)
            If $menusetsucceed_fail[0] = 0 Then
                SetError(1)
				_AnyGUI_Debug("Error!: 'hide' update failed!")
                Return 0
            EndIf

        Case $state = "show"
            Local $menusetsucceed_fail = DllCall("user32.dll", "int", "SetMenu", "hwnd", $window[0], "hwnd", $window[1])
            If $menusetsucceed_fail[0] = 0 Then
                SetError(1)
				_AnyGUI_Debug("Error!: 'show' update failed!")
                Return 0
            EndIf
    EndSelect
    If Not IsArray($window) Then;( Return only on initial call)
        Dim $ret[2]
        $ret[0] = $windowhwnd
        $ret[1] = $menuhwnd
        Return $ret
    EndIf
EndFunc  ;==>_AnyGUI_SetMenuState

; #INTERNAL_USE_ONLY#============================================================================================================
Func _AnyGUI_Debug($String)
	If $_Debug_AG Then
		ConsoleWrite( StringFormat($String) &@LF )
	EndIf
EndFunc

;=================================================================================================================================
;                 AUXILIARY FUNCTIONS 
;=================================================================================================================================
;Const $SWP_NOMOVE = 0x0002, $SWP_NOSIZE = 0x0001, $SWP_NOZORDER = 0x0004, $SWP_FRAMECHANGED = 0x0020
Const $DRAGLISTMSGSTRING = "commctrl_DragListMsg"
Const $DL_BEGINDRAG = ($WM_USER + 133)
Const $DL_DRAGGING = ($WM_USER + 134)
Const $DL_DROPPED = ($WM_USER + 135)
Const $DL_CANCELDRAG = ($WM_USER + 136)
Dim $dragIdx, $dragIdto, $dragging, $sztext, $cursor_old = MouseGetCursor()

Func ___Makedraglist($window, $text = 0, $controlid = 0)
    Local $hWnd
    If Not ($controlid = 0) Then
        $hWnd = ControlGetHandle($window, $text, $controlid)
    Else
        $hWnd = $window
    EndIf
    Local $r = DllCall("comctl32.dll", "int", "MakeDragList", "hwnd", $hWnd)
    $draglistmessage = DllCall("user32.dll", "int", "RegisterWindowMessage", "str", $DRAGLISTMSGSTRING)
    $x = GUIRegisterMsg(($draglistmessage[0]), "___DraglistHandler")
    Return $r[0]
EndFunc  ;==>___Makedraglist
Func ___DrawInsert($hWnd, $Hlb, $nItem)
    $r = DllCall("comctl32.dll", "int", "DrawInsert", "hwnd", $hWnd, "hwnd", $Hlb, "int", $nItem)
    Return $r[0]
EndFunc  ;==>___DrawInsert
Func ___LBItemFromPt($Hlb, $Point, $autoscroll = 1)
    $x = DllStructGetData($Point, 1)
    $y = DllStructGetData($Point, 2)
    $r = DllCall("comctl32.dll", "int", "LBItemFromPt", "hwnd", $Hlb, "int", $x, "int", $y, "int", $autoscroll)
    Return $r[0]
EndFunc  ;==>___LBItemFromPt
Func ___Refresh($TargethWnd)
    $r = DllCall("user32.dll", "long", "SetWindowPos", "hwnd", $TargethWnd, "hwnd", $TargethWnd, _
            "int", 0, "int", 0, "int", 0, "int", 0, _
            "long", BitOR($SWP_NOMOVE, $SWP_NOSIZE, $SWP_NOZORDER, $SWP_FRAMECHANGED))
    Return $r[0]
EndFunc  ;==>___Refresh
Func ___DraglistHandler($hWnd, $msg, $wParam, $lParam)


    $nID = BitAND($wParam, 0x0000FFFF)
    Local $DraglistInfo = DllStructCreate("uint;hwnd;int;int", $lParam)
    $nNotifyCode = (DllStructGetData($DraglistInfo, 1))
    $Hlb = "0x" & Hex(DllStructGetData($DraglistInfo, 2))
    $Point = DllStructCreate("int;int")
    DllStructSetData($Point, 1, DllStructGetData($DraglistInfo, 3))
    DllStructSetData($Point, 2, DllStructGetData($DraglistInfo, 4))

    Select
        Case $nNotifyCode = $DL_BEGINDRAG
            $dragIdx = ___LBItemFromPt($Hlb, $Point)
            ___Refresh($Hlb)
            GUICtrlSetCursor($nID, 0);hand cursor
            $dragging = False
            Return True; use conditional statements returning true to allow item drag for some items, or false to disallow.
        Case $nNotifyCode = $DL_CANCELDRAG
            ___Refresh($Hlb)
            ___DrawInsert($hWnd, $Hlb, -1)
            GUICtrlSetCursor($nID, $cursor_old); back to arrow
            $dragging = False
        Case $nNotifyCode = $DL_DRAGGING
            $dragIdto = ___LBItemFromPt($Hlb, $Point)
            ___DrawInsert($hWnd, $Hlb, $dragIdto)
            $dragging = True
        Case $nNotifyCode = $DL_DROPPED
            $dragIdto = ___LBItemFromPt($Hlb, $Point)
            If $dragging = True And $dragIdto <> -1 Then
                $sztext = _GUICtrlListBox_GetText($nID, $dragIdx)
                _GUICtrlListBox_DeleteString($nID, $dragIdx)
                _GUICtrlListBox_InsertString($nID, $sztext, $dragIdto)
                _GUICtrlListBox_SetCurSel($nID, $dragIdto)
                ___DrawInsert($hWnd, $Hlb, -1)
            EndIf
            GUICtrlSetCursor($nID, $cursor_old); back to arrow
        Case Else
            Return $GUI_RUNDEFMSG
    EndSelect



EndFunc  ;==>___DraglistHandler

#region  User Call Tips; Copy and paste these to your "User CallTips"
#cs;User call tip entries:
    _AnyGUI_Create("title"[,Mode- enter 1 for single window mode [,"text"[,ControlId]]])
    _AnyGUI_Destroy()
    _AnyGUI_AddChild( "title", PosX, PosY, SizeX, SizeY[, hWnd})
    _AnyGUI_AddAvi( filename, subfileid, PosX, PosY, SizeX, SizeY[, style [,exstyle[, hWnd]]])
    _AnyGUI_AddButton( "text",PosX,PosY,SizeX,SizeY[,style[,exstyle[, hWnd]]])
    _AnyGUI_AddCheckbox( "text", PosX, PosY, SizeX, SizeY[, style[, exstyle[, hWnd]]])
    _AnyGUI_AddCombo( "text", PosX, PosY, SizeX, SizeY[, style[, exstyle[, hWnd]]])
    _AnyGUI_AddDate( "text", PosX, PosY, SizeX, SizeY[, style[, exstyle[, hWnd]]])
    _AnyGUI_AddEdit("text", PosX, PosY, SizeX, SizeY[, style[, exstyle[, hWnd]]])
    _AnyGUI_AddGraphic( PosX, PosY, SizeX, SizeY[, style[, hWnd]])
    _AnyGUI_AddGroup( "text", PosX, PosY, SizeX, SizeY[, style[, exstyle[, hWnd]]])
    _AnyGUI_AddIcon( filename, iconID, PosX, PosY, SizeX, SizeY[, style[, exstyle[, hWnd]]])
    _AnyGUI_AddInput( "text", PosX, PosY, SizeX, SizeY[, style[, exstyle[, hWnd]]])
    _AnyGUI_AddLabel( "text", PosX, PosY, SizeX, SizeY[, style[, exstyle[, hWnd]]])
    _AnyGUI_AddList( "text", PosX, PosY, SizeX, SizeY[, style[, exstyle[, hWnd]]])
    _AnyGUI_AddDragList( "text", PosX, PosY, SizeX, SizeY[, style[, exstyle[, hWnd]]])
    _AnyGUI_AddListview( "text", PosX, PosY, SizeX, SizeY[, style[, exstyle[, hWnd]]])
    _AnyGUI_AddMonthCal( "text", PosX, PosY, SizeX, SizeY[, style[, exstyle[, hWnd]]])
    _AnyGUI_AddObj( "Object Variable", PosX, PosY, SizeX, SizeY[, hWnd])
    _AnyGUI_AddPic( filename, PosX, PosY, SizeX, SizeY[, style[, exstyle[, hWnd]]])
    _AnyGUI_AddProgress(PosX, PosY, SizeX, SizeY[, style[, exstyle[, hWnd]]])
    _AnyGUI_AddSlider(PosX, PosY, SizeX, SizeY[, style[, exstyle[, hWnd]]])
    _AnyGUI_AddTab(PosX, PosY, SizeX, SizeY[, style[, exstyle[, hWnd]]])
    _AnyGUI_AddTreeview(PosX, PosY, SizeX, SizeY[, style[, exstyle[, hWnd]]])
    _AnyGUI_SetStyle([action "set|unset|toggle|replace"[,Update"1 = yes 0 = no"[,Style[, ExStyle[, hWnd]]]]])
    _AnyGUI_GetMenuHandle(WindowHwnd)
    _AnyGUI_SetMenuState($windowhwnd_or_Previous_call$Variable[, $state = "show|hide"])
#ce
#endregion