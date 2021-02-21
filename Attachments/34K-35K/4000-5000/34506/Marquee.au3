#include-once
;===============================================================================
;
; Function Name:    _GUICtrlProgressMarqueeCreate()
; Description:      Creates a Marquee sytle progress control
; Parameter(s):     $i_Left     - The left side of the control
;                   $i_Top      - The top of the control
;                   $i_Width    - Optional: The width of the control
;                   $i_Height   - Optional: The height of the control
; Requirement(s):   AutoIt3 Beta and Windows XP or later
; Return Value(s):  On Success - Returns the identifier (controlID) of the new control
;                  On Failure - Returns 0  and sets @ERROR = 1
; Author(s):        Bob Anthony
;
;===============================================================================
;
Func _GUICtrlProgressMarqueeCreate($i_Left, $i_Top, $i_Width = Default, $i_Height = Default)

    Local Const $PBS_MARQUEE = 0x08

    Local $v_Style = $PBS_MARQUEE

    Local $h_Progress = GUICtrlCreateProgress($i_Left, $i_Top, $i_Width, $i_Height, $v_Style)
    If $h_Progress = 0 Then
        SetError(1)
        Return 0
    Else
        SetError(0)
        Return $h_Progress
    EndIf

EndFunc;==>_GUICtrlProgressMarqueeCreate

;===============================================================================
;
; Function Name:    _GUICtrlProgressSetMarquee()
; Description:      Sets Marquee sytle for a progress control
; Parameter(s):     $h_Progress - The control identifier (controlID)
;                   $f_Mode     - Optional: Indicates whether to turn the Marquee mode on or off
;                                   0 = turn Marquee mode off
;                                   1 = (Default) turn Marquee mode on
;                   $i_Time     - Optional: Time in milliseconds between Marquee animation updates
;                                   Default is 100 milliseconds
; Requirement(s):   AutoIt3 Beta and Windows XP or later
; Return Value(s):  On Success - Returns whether Marquee mode is set
;                  On Failure - Returns 0  and sets @ERROR = 1
; Author(s):        Bob Anthony
;
;===============================================================================
;
Func _GUICtrlProgressSetMarquee($h_Progress, $f_Mode = 1, $i_Time = 100)

    Local Const $WM_USER = 0x0400
    Local Const $PBM_SETMARQUEE = ($WM_USER + 10)

    Local $var = GUICtrlSendMsg($h_Progress, $PBM_SETMARQUEE, $f_Mode, Number($i_Time))
    If $var = 0 Then
        SetError(1)
        Return 0
    Else
        SetError(0)
        Return $var
    EndIf

EndFunc;==>_GUICtrlProgressSetMarquee
