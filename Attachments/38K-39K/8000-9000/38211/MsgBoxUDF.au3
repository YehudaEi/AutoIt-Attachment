#include-once
#include <Constants.au3>
#include <WinAPI.au3>

Global Const $__MsgBox_HCBT_MOVESIZE = 0
Global Const $__MsgBox_HCBT_MINMAX = 1
Global Const $__MsgBox_HCBT_QS = 2
Global Const $__MsgBox_HCBT_CREATEWND = 3
Global Const $__MsgBox_HCBT_DESTROYWND = 4
Global Const $__MsgBox_HCBT_ACTIVATE = 5
Global Const $__MsgBox_HCBT_CLICKSKIPPED = 6
Global Const $__MsgBox_HCBT_KEYSKIPPED = 7
Global Const $__MsgBox_HCBT_SYSCOMMAND = 8
Global Const $__MsgBox_HCBT_SETFOCUS = 9

Global Enum _
	$__iMsgBox_IDOK = 1, _
	$__iMsgBox_IDCANCEL, _
	$__iMsgBox_IDABORT, _
	$__iMsgBox_IDRETRY, _
	$__iMsgBox_IDIGNORE, _
	$__iMsgBox_IDYES, _
	$__iMsgBox_IDNO, _
	$__iMsgBox_IDCLOSE, _
	$__iMsgBox_IDHELP, _
	$__iMsgBox_IDTRYAGAIN, _
	$__iMsgBox_IDCONTINUE, _
	$__iMsgBox_IDLASTITEM

Global $__aMsgBoxTextDefault[$__iMsgBox_IDLASTITEM] = [$__iMsgBox_IDLASTITEM - 1, _
	"OK", "Cancel", "&Abort", "&Retry", "&Ignore", "Yes", "No", "", "Help", _
	"&Continue", "&Try Again"]

Global $__iMsgBox_Flag = -1
Global $__fMsgBox_Move = False
Global $__hMsgBox_Parent = 0
Global $__iMsgBox_XPos = -1
Global $__iMsgBox_YPos = -1

Global $__aMsgBoxText = $__aMsgBoxTextDefault
Global $__hMsgBoxHook = 0

;===================================================================================================
;
; Function Name....:    _CBT_MsgBoxProc()
; Description......:    Message Box Callback Function
; Parameter(s).....:
;                       $i_code:  N/A
;                       $w_param:  N/A
;                       $l_param:  N/A
; Return Value(s)..:
;                       Success...: N/A
;                       Failure...: N/A
;                       Error.....: N/A
;                       Extended..: N/A
; Requirement(s)...:
; Author(s)........:    SmOke_N (Ron Nielsen)
; Modified.........:
; Comment(s).......:    Tested with AutoIt 3.3.6.1
; Example(s).......:    N/A - Internal Use Only
;
;===================================================================================================

Func _CBT_MsgBoxProc($i_code, $w_param, $l_param)
	#forceref $l_param

	Local $h_msgbox = HWnd($w_param)
	Local $t_rect_msg = 0, $t_rect_hwnd
	Local $i_hwnd_left, $i_hwnd_top, $i_hwnd_right, $i_hwnd_bottom
	Local $i_msg_left, $i_msg_top, $i_msg_right, $i_msg_bottom
	#forceref $h_msgbox, $t_rect_msg, $t_rect_hwnd
	#forceref $i_hwnd_left, $i_hwnd_top, $i_hwnd_right, $i_hwnd_bottom
	#forceref $i_msg_left, $i_msg_top, $i_msg_right, $i_msg_bottom

	Switch $i_code
		Case $__MsgBox_HCBT_ACTIVATE

			If $__fMsgBox_Move Then

				If $__iMsgBox_XPos = -1 Or $__iMsgBox_YPos = -1 Then
					If $__hMsgBox_Parent Then
						$t_rect_hwnd = _WinAPI_GetWindowRect($__hMsgBox_Parent)
					Else
						$t_rect_hwnd = _WinAPI_GetWindowRect(_WinAPI_GetDesktopWindow())
					EndIf
					$i_hwnd_left = DllStructGetData($t_rect_hwnd, "left")
					$i_hwnd_top = DllStructGetData($t_rect_hwnd, "top")
					$i_hwnd_right = DllStructGetData($t_rect_hwnd, "right")
					$i_hwnd_bottom = DllStructGetData($t_rect_hwnd, "bottom")

					$t_rect_msg = _WinAPI_GetWindowRect($h_msgbox)
					$i_msg_left = DllStructGetData($t_rect_msg, "left")
					$i_msg_top = DllStructGetData($t_rect_msg, "top")
					$i_msg_right = DllStructGetData($t_rect_msg, "right")
					$i_msg_bottom = DllStructGetData($t_rect_msg, "bottom")
				EndIf

				If $__iMsgBox_XPos = -1 Then
					$__iMsgBox_XPos = ($i_hwnd_left + ($i_hwnd_right - $i_hwnd_left) / 2) - _
						(($i_msg_right - $i_msg_left) / 2)
				EndIf

				If $__iMsgBox_YPos = -1 Then
					$__iMsgBox_YPos = ($i_hwnd_top + ($i_hwnd_bottom - $i_hwnd_top) / 2) - _
						(($i_msg_bottom - $i_msg_top) / 2)
				EndIf

				_WinAPI_SetWindowPos($h_msgbox, 0, $__iMsgBox_XPos, $__iMsgBox_YPos, _
					-1, -1, BitOR($SWP_NOSIZE, $SWP_NOZORDER, $SWP_NOACTIVATE))

			EndIf

			If $__iMsgBox_Flag <> -1 Then
				For $iid = $__iMsgBox_IDOK To $__iMsgBox_IDLASTITEM - 1

					If $iid = $__iMsgBox_IDCLOSE Then ContinueLoop

					If _WinAPI_GetDlgItem($h_msgbox, $iid) Then
						DllCall("User32.dll", "int", "SetDlgItemText", "hwnd", $h_msgbox, _
							"int", $iid, "str", $__aMsgBoxText[$iid])
					EndIf
				Next
			EndIf

			_WinAPI_UnhookWindowsHookEx($__hMsgBoxHook)
			$__hMsgBoxHook = 0

			Return 0
	EndSwitch

	Return _WinAPI_CallNextHookEx($__hMsgBoxHook, $i_code, $w_param, $l_param)
EndFunc   ;==>_CBT_MsgBoxProc

;===================================================================================================
;
; Function Name....:    _MsgBox()
; Description......:    Message box
; Parameter(s).....:
;                       $i_flag:  Button(s) flag
;                       $s_title:  Text of title
;                       $s_text:  Text of body
;                       $i_timeout:  ( Optional -1 or Default ) Timeout of message box
;                       $h_wnd:  ( Optional -1 or Default ) Parent Window
; Return Value(s)..:
;                       Success...: Button code that was selected
;                       Failure...: N/A
;                       Error.....: N/A
;                       Extended..: N/A
; Requirement(s)...:
; Author(s)........:    SmOke_N (Ron Nielsen)
; Modified.........:
; Comment(s).......:    Tested with AutoIt 3.3.6.1
; Example(s).......:    _MsgBox(64 + 4 + 262144, "Title", "Body Of Text")
;
;===================================================================================================

Func _MsgBox($i_flag, $s_title, $s_text, $i_timeout = 0, $h_wnd = 0)

	If Not $__fMsgBox_Move Then

		; If everything is default we don't need the flag
		If $__iMsgBox_Flag = -1 Then Return MsgBox($i_flag, $s_title, $s_text, $i_timeout, $h_wnd)

		; If flags are different than just set off normal msgbox rather than work through possible conflicts
		If Not (BitAND($i_flag, $__iMsgBox_Flag) = $__iMsgBox_Flag) Then _MsgBox_SetButtonText(-1)
	EndIf

	Local $h_cb = DllCallbackRegister("_CBT_MsgBoxProc", "lresult", "int;wparam;lparam")
	Local $p_cb = DllCallbackGetPtr($h_cb)

	$__hMsgBoxHook = _WinAPI_SetWindowsHookEx($WH_CBT, $p_cb, 0, _WinAPI_GetCurrentThreadId())

	Local $i_ret = MsgBox($i_flag, $s_title, $s_text, $i_timeout, $h_wnd)

	If $__hMsgBoxHook Then _WinAPI_UnhookWindowsHookEx($__hMsgBoxHook)
	DllCallbackFree($h_cb)
	$__hMsgBoxHook = 0

	; Reset Globals
	_MsgBox_SetButtonText(-1)
	_MsgBox_SetWindowPos()

	Return $i_ret
EndFunc   ;==>_MsgBox

;===================================================================================================
;
; Function Name....:    _MsgBoxEx()
; Description......:    Executes all the Move/Set Text/Message Box functions
; Parameter(s).....:
;                       $i_flag:  Flag for button(s) ( See helpfile )
;                       $s_title:  Text of title
;                       $s_text:  Text of body
;                       $i_timeout:  ( Optional -1 or Default ) Timeout of message box
;                       $h_wnd:  ( Optional -1 or Default ) Parent Window ( used also for center )
;                       $s_button1:  ( Optional -1 or Default ) Text for first button
;                       $s_button2:  ( Optional -1 or Default ) Text for second button
;                       $s_button3:  ( Optional -1 or Default ) Text for third button
;                       $i_x: ( Optional -1 or Default ) X position of messagebox
;                                   ( reverts to default (center) if $h_parent param is used )
;                       $i_y: ( Optional -1 or Default ) Y position of messagebox
;                                   ( reverts to default (center) if $h_parent param is used )
; Return Value(s)..:
;                       Success...:
;                       Failure...:
;                       Error.....:
;                       Extended..:
; Requirement(s)...:
; Author(s)........:    SmOke_N (Ron Nielsen)
; Modified.........:
; Comment(s).......:    This can be used to fire all events; Tested with AutoIt 3.3.6.1
; Example(s).......:    _MsgBoxEx(0, "title", "body", -1, 0, "Button1", -1, -1, 0, 0)
;
;===================================================================================================

Func _MsgBoxEx($i_flag, $s_title, $s_text, $i_timeout = -1, $h_wnd = -1, _
		$s_button1 = -1, $s_button2 = -1, $s_button3 = -1, $i_x = -1, $i_y = -1)

	If $h_wnd = -1 Or $h_wnd = Default Then $h_wnd = 0
	If $i_timeout = -1 Or $i_timeout = Default Then $i_timeout = 0

	_MsgBox_SetWindowPos($i_x, $i_y, $h_wnd)

	Local $i_button_flag = 0
	For $iflag = 1 To 6
		If BitAND($i_flag, $iflag) = $iflag Then
			$i_button_flag = $iflag
			ExitLoop
		EndIf
	Next

	_MsgBox_SetButtonText($i_button_flag, $s_button1, $s_button2, $s_button3)

	Return _MsgBox($i_flag, $s_title, $s_text, $i_timeout, $h_wnd)
EndFunc   ;==>_MsgBoxEx

;===================================================================================================
;
; Function Name....:    _MsgBox_SetWindowPos()
; Description......:    Move the window to a specific position or center to a window
; Parameter(s).....:
;                       $i_pos_x: ( Optional -1 or Default ) X position of messagebox
;                                   ( reverts to default (center) if $h_parent param is used )
;                       $i_pos_y: ( Optional -1 or Default ) Y position of messagebox
;                                   ( reverts to default (center) if $h_parent param is used )
;                       $h_parent: ( Optional -1 or Default ) Window to center messagbox on
; Return Value(s)..:
;                       Success...: N/A
;                       Failure...: N/A
;                       Error.....: N/A
;                       Extended..: N/A
; Requirement(s)...:
; Author(s)........:    SmOke_N (Ron Nielsen)
; Modified.........:
; Comment(s).......:    This must be called before _MsgBox(); Tested with AutoIt 3.3.6.1
; Example(s).......:    _MsgBox_SetWindowPos(100, 200)
;
;===================================================================================================

Func _MsgBox_SetWindowPos($i_pos_x = -1, $i_pos_y = -1, $h_parent = -1)

	If $h_parent = Default Or $h_parent = -1 Then $h_parent = 0
	If $i_pos_x = Default Or $h_parent Then $i_pos_x = -1
	If $i_pos_y = Default Or $h_parent Then $i_pos_y = -1

	$__iMsgBox_XPos = $i_pos_x
	$__iMsgBox_YPos = $i_pos_y
	$__hMsgBox_Parent = $h_parent

	If $i_pos_x = -1 And $i_pos_y = -1 And $h_parent = 0 Then
		$__fMsgBox_Move = False
		Return
	EndIf

	$__fMsgBox_Move = True
	Return
EndFunc   ;==>_MsgBox_SetWindowPos

;===================================================================================================
;
; Function Name....:    _MsgBox_SetButtonText()
; Description......:    Change the text of buttons
; Parameter(s).....:
;                       $i_flag:  Flag for button(s) ( See helpfile )
;                       $s_button1:  ( Optional -1 or Default ) Text for first button
;                       $s_button2:  ( Optional -1 or Default ) Text for second button
;                       $s_button3:  ( Optional -1 or Default ) Text for third button
; Return Value(s)..:
;                       Success...: N/A
;                       Failure...: N/A
;                       Error.....: N/A
;                       Extended..: N/A
; Requirement(s)...:
; Author(s)........:    SmOke_N (Ron Nielsen)
; Modified.........:
; Comment(s).......:    This must be called before _MsgBox(); Tested with AutoIt 3.3.6.1
; Example(s).......:    _MsgBox_SetButtonText(4, "Button 1", "Button 2")
;
;===================================================================================================

Func _MsgBox_SetButtonText($i_flag, $s_button1 = -1, $s_button2 = -1, $s_button3 = -1)

	If ((IsInt($i_flag) And ($i_flag < 0 Or $i_flag > 6)) Or _
		Not StringIsInt($i_flag) Or $i_flag = Default) Then
		$__aMsgBoxText = $__aMsgBoxTextDefault
		$__iMsgBox_Flag = -1
		Return
	EndIf

	$__iMsgBox_Flag = Int($i_flag)

	Switch $__iMsgBox_Flag
		Case 0
			If (IsInt($s_button1) And $s_button1 = -1) Or $s_button1 = Default Then $s_button1 = "OK"
			$__aMsgBoxText[$__iMsgBox_IDOK] = $s_button1
		Case 1
			If (IsInt($s_button1) And $s_button1 = -1) Or $s_button1 = Default Then $s_button1 = "OK"
			If (IsInt($s_button2) And $s_button2 = -1) Or $s_button2 = Default Then $s_button2 = "Cancel"
			$__aMsgBoxText[$__iMsgBox_IDOK] = $s_button1
			$__aMsgBoxText[$__iMsgBox_IDCANCEL] = $s_button2
		Case 2
			If (IsInt($s_button1) And $s_button1 = -1) Or $s_button1 = Default Then $s_button1 = "&Abort"
			If (IsInt($s_button2) And $s_button2 = -1) Or $s_button2 = Default Then $s_button2 = "&Retry"
			If (IsInt($s_button3) And $s_button3 = -1) Or $s_button3 = Default Then $s_button3 = "&Ignore"
			$__aMsgBoxText[$__iMsgBox_IDABORT] = $s_button1
			$__aMsgBoxText[$__iMsgBox_IDRETRY] = $s_button2
			$__aMsgBoxText[$__iMsgBox_IDIGNORE] = $s_button3
		Case 3
			If (IsInt($s_button1) And $s_button1 = -1) Or $s_button1 = Default Then $s_button1 = "Yes"
			If (IsInt($s_button2) And $s_button2 = -1) Or $s_button2 = Default Then $s_button2 = "No"
			If (IsInt($s_button3) And $s_button3 = -1) Or $s_button3 = Default Then $s_button3 = "Cancel"
			$__aMsgBoxText[$__iMsgBox_IDYES] = $s_button1
			$__aMsgBoxText[$__iMsgBox_IDNO] = $s_button2
			$__aMsgBoxText[$__iMsgBox_IDCANCEL] = $s_button3
		Case 4
			If (IsInt($s_button1) And $s_button1 = -1) Or $s_button1 = Default Then $s_button1 = "Yes"
			If (IsInt($s_button2) And $s_button2 = -1) Or $s_button2 = Default Then $s_button2 = "No"
			$__aMsgBoxText[$__iMsgBox_IDYES] = $s_button1
			$__aMsgBoxText[$__iMsgBox_IDNO] = $s_button2
		Case 5
			If (IsInt($s_button1) And $s_button1 = -1) Or $s_button1 = Default Then $s_button1 = "&Retry"
			If (IsInt($s_button2) And $s_button2 = -1) Or $s_button2 = Default Then $s_button2 = "Cancel"
			$__aMsgBoxText[$__iMsgBox_IDRETRY] = $s_button1
			$__aMsgBoxText[$__iMsgBox_IDCANCEL] = $s_button2
		Case 6
			If (IsInt($s_button1) And $s_button1 = -1) Or $s_button1 = Default Then $s_button1 = "Cancel"
			If (IsInt($s_button2) And $s_button2 = -1) Or $s_button2 = Default Then $s_button2 = "&Try Again"
			If (IsInt($s_button3) And $s_button3 = -1) Or $s_button3 = Default Then $s_button3 = "&Continue"
			$__aMsgBoxText[$__iMsgBox_IDCANCEL] = $s_button1
			$__aMsgBoxText[$__iMsgBox_IDTRYAGAIN] = $s_button2
			$__aMsgBoxText[$__iMsgBox_IDCONTINUE] = $s_button3
	EndSwitch

	Return
EndFunc   ;==>_MsgBox_SetButtonText