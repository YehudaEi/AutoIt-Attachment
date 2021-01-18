#include-once
Opt( "MustDeclareVars", 1 )
#include <GUIConstants.au3>
#region Example
Const $csTtl = "Button Demonstration"
Local $iBtn, $sMsg, $sBtn1, $sBtn2, $sBtn3
$sMsg = "Do you want to Save or Restore?"
$sBtn1 = "&Save"
$sBtn2 = "&Restore"
$sBtn3 = "&Cancel"
$iBtn = Button3( $csTtl, $sMsg, $sBtn1, $sBtn2, $sBtn3, 3 )
Select
	Case ( $iBtn == 0 )		; User closed dialog.
		Exit
	Case ( $iBtn == 1 )		; User selected "Save" button.
		MsgBox( 64, $csTtl, "You pressed button " & $iBtn )
	Case ( $iBtn == 2 )		; User selected "Restore" button.
		MsgBox( 64, $csTtl, "You pressed button " & $iBtn )
	Case ( $iBtn == 3 )		; User selected "Cancel" button.
		Exit
EndSelect		
#endregion Example
;
;===============================================================================
;
; Description:      Display a dialog box with one button.
; Parameter(s):     $sTitle - title to be displayed on text box
;					$sText - text to be displayed above the button
;					$sBtn1 - text to be displayed on the button.
; Requirement(s):   IIf() and Max() functions.
; Return Value(s):  0 if cancelled, otherwise the number of the button clicked.
; Author(s):        cephasoz
; Note(s):          
;
;===============================================================================
Func Button1( $sTitle, $sText, $sBtn1 )
    Local $iBtn         ; This is the return value - the number of the button selected.
    Local $iMgn         ; The margin around the buttons.
    Local $iLft         ; Offset from left of gui for text label.
    Local $iTop         ; Offset from top of gui for text label.
    Local $iGuiHt       ; Height of gui.
    Local $iGuiWd       ; Width of gui.
    Local $iBtnHt       ; Height of buttons.
    Local $iBtnWd       ; Width of buttons.
    Local $iBtnTop      ; Position at which the top of a button is placed.
    Local $btnBtn1      ; Button object 1.
    Local $iMaxBtn      ; The maximum length of the strings on the buttons.
    Local $iMsg         ; The message returned from the gui.
    Local $bExit        ; Are we ready to exit the message loop?
    Local $iFactor      ; Factor to multiply string length to give approximate size.
    ;
    ; Calculate GUI component heights and widths.
    $iMaxBtn = StringLen( $sBtn1 )
    $iMgn = 20
    $iFactor = IIf( $iMaxBtn < 4, 15, 10 )
    $iBtnWd = $iMaxBtn * $iFactor
    $iBtnHt = 30
    $iGuiHt = ( $iMgn * 4 ) + $iBtnHt
    $iGuiWd = ( $iBtnWd * 1 ) + ( $iMgn * 2 )
    $iFactor = IIf( StringUpper( $sText ) == $sText, 11, 7 )
    $iGuiWd = Max( $iGuiWd, StringLen( $sText ) * $iFactor )
    $iBtnTop = $iGuiHt - $iBtnHt - $iMgn
    $iLft = ( $iGuiWd / 2 ) - ( ( StringLen( $sText ) / 2 ) * 5 )
    $iTop = $iMgn
    ;
    GUICreate( $sTitle, $iGuiWd, $iGuiHt )
    Opt( "GUICoordMode", 1 )        ; Absolute positioning
    ;
    $btnBtn1 = GUICtrlCreateButton( $sBtn1,  ( $iGuiWd - $iBtnWd ) / 2, $iBtnTop, $iBtnWd, $iBtnHt )
    ;
    GUICtrlSetState( $btnBtn1, $GUI_FOCUS )             ; Put the focus on the only button.
    GUICtrlCreateLabel( $sText, $iLft, $iTop )          ; Show the text.
    ; Display the gui.
    GUISetState( @SW_SHOW )
    ; Loop, checking what the user has done.
    $bExit = False
    While ( Not $bExit )
        $iMsg = GUIGetMsg()
        Select
            Case $iMsg = $GUI_EVENT_CLOSE
                ; User closed the gui without pressing a button.
                $iBtn = 0
                $bExit = True
            Case $iMsg = $btnBtn1
                ; User pressed button 1.
                $iBtn = 1
                $bExit = True
        EndSelect
    WEnd
    ; Delete the gui.
    GUIDelete()
    Return $iBtn
EndFunc
;
;===============================================================================
;
; Description:      Display a dialog box with two buttons.
; Parameter(s):     $sTitle - title to be displayed on text box
;					$sText - text to be displayed above the buttons
;					$sBtn1 - text to be displayed on button 1.
;					$sBtn2 - text to be displayed on button 2.
;					$iDefault - which button is the default button (1-2, default 1)
; Requirement(s):   IIf() and Max() functions.
; Return Value(s):  0 if cancelled, otherwise the number of the button clicked.
; Author(s):        cephasoz
; Note(s):          
;
;===============================================================================
Func Button2( $sTitle, $sText, $sBtn1, $sBtn2, $iDefault = 1 )
    Local $iBtn         ; This is the return value - the number of the button selected.
    Local $iMgn         ; The margin around the buttons.
    Local $iLft         ; Offset from left of gui for text label.
    Local $iTop         ; Offset from top of gui for text label.
    Local $iGuiHt       ; Height of gui.
    Local $iGuiWd       ; Width of gui.
    Local $iBtnHt       ; Height of buttons.
    Local $iBtnWd       ; Width of buttons.
    Local $iBtnTop      ; Position at which the top of a button is placed.
    Local $btnBtn1      ; Button object 1.
    Local $btnBtn2      ; Button object 2.
    Local $iMaxBtn      ; The maximum length of the strings on the buttons.
    Local $iMsg         ; The message returned from the gui.
    Local $bExit        ; Are we ready to exit the message loop?
    ;
    ; Calculate GUI component heights and widths.
    $iMaxBtn = Max( StringLen( $sBtn1 ), StringLen( $sBtn2 ) )
    $iMgn = 20
    $iBtnWd = $iMaxBtn * IIf( $iMaxBtn < 4, 15, 10 )
    $iBtnHt = 30
    $iGuiHt = ( $iMgn * 4 ) + $iBtnHt
    $iGuiWd = ( $iBtnWd * 2 ) + ( $iMgn * 3 )
    $iGuiWd = Max( $iGuiWd, StringLen( $sText ) * 6 )
    $iBtnTop = $iGuiHt - $iBtnHt - $iMgn
    $iLft = ( $iGuiWd / 2 ) - ( ( StringLen( $sText ) / 2 ) * 5 )
    $iTop = $iMgn
	If ( $iDefault < 1 ) Then $iDefault = 1
	If ( $iDefault > 2 ) Then $iDefault = 2
    ;
    GUICreate( $sTitle, $iGuiWd, $iGuiHt )
    Opt( "GUICoordMode", 1 )        ; Absolute positioning
    ;
    $btnBtn1 = GUICtrlCreateButton( $sBtn1,  $iMgn, $iBtnTop, $iBtnWd, $iBtnHt )
    $btnBtn2 = GUICtrlCreateButton( $sBtn2,  $iGuiWd - $iBtnWd - $iMgn, $iBtnTop, $iBtnWd, $iBtnHt )
    ;
	; Set focus to selected button.
	Select
		Case ( $iDefault = 1 )
			GUICtrlSetState( $btnBtn1, $GUI_FOCUS )
		Case ( $iDefault = 2 )
			GUICtrlSetState( $btnBtn2, $GUI_FOCUS )
	EndSelect
	;
    GUICtrlCreateLabel( $sText, $iLft, $iTop )          ; Show the text.
    ; Display the gui.
    GUISetState( @SW_SHOW )
    ; Loop, checking what the user has done.
    $bExit = False
    While ( Not $bExit )
        $iMsg = GUIGetMsg()
        Select
            Case $iMsg = $GUI_EVENT_CLOSE
                ; User closed the gui without pressing a button.
                $iBtn = 0
                $bExit = True
            Case $iMsg = $btnBtn1
                ; User pressed button 1.
                $iBtn = 1
                $bExit = True
            Case $iMsg = $btnBtn2
                ; User pressed button 2.
                $iBtn = 2
                $bExit = True
        EndSelect
    WEnd
    ; Delete the gui.
    GUIDelete()
    Return $iBtn
EndFunc
;
;===============================================================================
;
; Description:      Display a dialog box with three buttons.
; Parameter(s):     $sTitle - title to be displayed on text box
;					$sText - text to be displayed above the buttons
;					$sBtn1 - text to be displayed on button 1.
;					$sBtn2 - text to be displayed on button 2.
;					$sBtn3 - text to be displayed on button 3.
;					$iDefault - which button is the default button (1-3, default 1)
; Requirement(s):   IIf() and Max() functions.
; Return Value(s):  0 if cancelled, otherwise the number of the button clicked.
; Author(s):        cephasoz
; Note(s):          
;
;===============================================================================
Func Button3( $sTitle, $sText, $sBtn1, $sBtn2, $sBtn3, $iDefault = 1 )
    Local $iBtn         ; This is the return value - the number of the button selected.
    Local $iMgn         ; The margin around the buttons.
    Local $iLft         ; Offset from left of gui for text label.
    Local $iTop         ; Offset from top of gui for text label.
    Local $iGuiHt       ; Height of gui.
    Local $iGuiWd       ; Width of gui.
    Local $iBtnHt       ; Height of buttons.
    Local $iBtnWd       ; Width of buttons.
    Local $iBtnTop      ; Position at which the top of a button is placed.
    Local $btnBtn1      ; Button object 1.
    Local $btnBtn2      ; Button object 2.
    Local $btnBtn3      ; Button object 3.
    Local $iMaxBtn      ; The maximum length of the strings on the buttons.
    Local $iMsg         ; The message returned from the gui.
    Local $bExit        ; Are we ready to exit the message loop?
    ;
    ; Calculate GUI component heights and widths.
    $iMaxBtn = Max( StringLen( $sBtn1 ), StringLen( $sBtn2 ) )
    $iMaxBtn = Max( $iMaxBtn, StringLen( $sBtn3 ) )
    $iMgn = 20
    $iBtnWd = $iMaxBtn * IIf( $iMaxBtn < 4, 15, 10 )
    $iBtnHt = 30
    $iGuiHt = ( $iMgn * 4 ) + $iBtnHt
    $iGuiWd = ( $iBtnWd * 3 ) + ( $iMgn * 4 )
    $iBtnTop = $iGuiHt - $iBtnHt - $iMgn
    $iLft = ( $iGuiWd / 2 ) - ( ( StringLen( $sText ) / 2 ) * 5 )
    $iTop = $iMgn
	If ( $iDefault < 1 ) Then $iDefault = 1
	If ( $iDefault > 3 ) Then $iDefault = 3
    ;
    GUICreate( $sTitle, $iGuiWd, $iGuiHt )
    Opt( "GUICoordMode", 1 )        ; Absolute positioning
    ;
    $btnBtn1 = GUICtrlCreateButton( $sBtn1,  $iMgn, $iBtnTop, $iBtnWd, $iBtnHt )
    $btnBtn2 = GUICtrlCreateButton( $sBtn2,  ( $iGuiWd - $iBtnWd ) / 2, $iBtnTop, $iBtnWd, $iBtnHt )
    $btnBtn3 = GUICtrlCreateButton( $sBtn3,  $iGuiWd - $iBtnWd - $iMgn, $iBtnTop, $iBtnWd, $iBtnHt )
    ;
	; Set focus to selected button.
	Select
		Case ( $iDefault = 1 )
			GUICtrlSetState( $btnBtn1, $GUI_FOCUS )
		Case ( $iDefault = 2 )
			GUICtrlSetState( $btnBtn2, $GUI_FOCUS )
		Case ( $iDefault = 3 )
			GUICtrlSetState( $btnBtn3, $GUI_FOCUS )
	EndSelect
	;
    GUICtrlCreateLabel( $sText, $iLft, $iTop )          ; Show the text.
    ; Display the gui.
    GUISetState( @SW_SHOW )
    ; Loop, checking what the user has done.
    $bExit = False
    While ( Not $bExit )
        $iMsg = GUIGetMsg()
        Select
            Case $iMsg = $GUI_EVENT_CLOSE
                ; User closed the gui without pressing a button.
                $iBtn = 0
                $bExit = True
            Case $iMsg = $btnBtn1
                ; User pressed button 1.
                $iBtn = 1
                $bExit = True
            Case $iMsg = $btnBtn2
                ; User pressed button 2.
                $iBtn = 2
                $bExit = True
            Case $iMsg = $btnBtn3
                ; User pressed button 3.
                $iBtn = 3
                $bExit = True
        EndSelect
    WEnd
    ; Delete the gui.
    GUIDelete()
    Return $iBtn
EndFunc
;
; Standard IIf function.
Func IIf( $bTest, $xVal1, $xVal2 )
	If $bTest Then
		Return $xVal1
	Else
		Return $xVal2
	EndIf
EndFunc
;
; Standard Max function.
Func Max( $xVal1, $xVal2 )
	If ( $xVal1 > $xVal2 ) Then
		Return $xVal1
	Else
		Return $xVal2
	EndIf
EndFunc