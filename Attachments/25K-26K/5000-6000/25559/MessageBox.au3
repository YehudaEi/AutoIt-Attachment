#include-once

; #INDEX# =======================================================================================================================
; Title .........: Message Box
; Description ...: An alternitive to MsgBox that does not halt execution of your program and gives greater control.
; Author ........: Matthew McMullan (NerdFencer)
; ===============================================================================================================================

; Return Value Constants
Global Const $MB_ICON = -2
Global Const $MB_OK = 1
Global Const $MB_CANCEL = 2
Global Const $MB_ABORT = 3
Global Const $MB_RETRY = 4
Global Const $MB_IGNORE = 5
Global Const $MB_YES = 6
Global Const $MB_NO = 7
Global Const $MB_TRYAGAIN = 10
Global Const $MB_CONTINUE = 11
;Button-related Flags
Global Const $MBB_OK = 0
Global Const $MBB_OK_CANCEL = 1
Global Const $MBB_ABORT_RETRY_CANCEL = 2
Global Const $MBB_YES_NO_CANCEL = 3
Global Const $MBB_YES_NO = 4
Global Const $MBB_RETRY_CANCEL = 5
Global Const $MBB_CANCEL_TRYAGAIN_CONTINUE = 6
;Icon Related Flags
Global Const $MBI_STOP = 0x10
Global Const $MBI_QUESTION = 0x20
Global Const $MBI_EXCLAMATION = 0x30
Global Const $MBI_INFORMATION = 0x40
;Default Related Flags
Global Const $MBD_FIRST = 0
Global Const $MBD_SECCOND = 0x100
Global Const $MBD_THIRD = 0x200
;Misc Flags
Global Const $MBM_SYSTEM = 0x1000
Global Const $MBM_TASK = 0x2000
Global Const $MBM_TOPMOST = 0x40000
Global Const $MBM_RIGHTJUST = 0x80000

;==============================================================================================================================
; #NO_DOC_FUNCTION# =============================================================================================================
; Not documented at this time
; ===============================================================================================================================
;_MessageBox_GetNextHandle
;_MessageBox_ProcessFlag
;_MessageBox_SetButtonTip_Internal
;_MessageBox_Update_Internal
;_MessageBox_Update_GenerateOutput
; ===============================================================================================================================
; #CURRENT# =====================================================================================================================
;_MessageBox_Create
;_MessageBox_Destroy
;_MessageBox_SetButtonText
;_MessageBox_SetButtonTip
;_MessageBox_SetTimeout
;_MessageBox_SetWindowIcon
;_MessageBox_Update
; ===============================================================================================================================
;==============================================================================================================================

Global $_MessageBox_GUI[2]
Global $_MessageBox_TYPE[2]
Global $_MessageBox_BUTTONS[2]
Global $_MessageBox_BUTTON_1[2]
Global $_MessageBox_BUTTON_2[2]
Global $_MessageBox_BUTTON_3[2]
Global $_MessageBox_ICON[2]
Global $_MessageBox_TIMEOUT[2]
Global $_MessageBox_TIMESTAMP[2]
Global $_MessageBox_HANDLES[2]

; #FUNCTION# ====================================================================================================================
; Name...........: _MessageBox_Create
; Description ...: Creates a new Message Box
; Syntax.........: _MessageBox_Create($flag, $title, $text , $timeout = -1, $hwnd = -1)
; Parameters ....: All Parameters are the same as MsgBox
; Return values .: Success      - The handle of the Message Box (note, this is an internal value, not the handle to the window)
;                  Failure      - No Failure messages at this time
; Author ........: Matthew McMullan (NerdFencer)
; Modified.......:
; Remarks .......: 
; Related .......: _MessageBox_Destroy
; Link ..........;
; Example .......; No
; ===============================================================================================================================
Func _MessageBox_Create($flag, $title, $text , $timeout = -1, $hwnd = -1)
	Local $handle = _MessageBox_GetNextHandle()
	$flag = _MessageBox_ProcessFlag($flag)
	Local $width = 600, $height = 90, $temp, $buttons, $buttontext[3]
	Switch $flag[0]
		Case 0
			$buttons = 1
			$buttontext[0]="OK"
		Case 1
			$buttons = 2
			$buttontext[0]="OK"
			$buttontext[1]="Cancel"
		Case 2
			$buttons = 3
			$buttontext[0]="Abort"
			$buttontext[1]="Retry"
			$buttontext[2]="Ignore"
		Case 3
			$buttons = 3
			$buttontext[0]="Yes"
			$buttontext[1]="No"
			$buttontext[2]="Cancel"
		Case 4
			$buttons = 2
			$buttontext[0]="Yes"
			$buttontext[1]="No"
		Case 5
			$buttons = 2
			$buttontext[0]="Retry"
			$buttontext[1]="Cancel"
		Case 6
			$buttons = 3
			$buttontext[0]="Cancel"
			$buttontext[1]="Try Again"
			$buttontext[2]="Continue"
	EndSwitch
	If $flag[1]==0 Then
		If 5*StringLen($text)<590 Then
			$width = 10+5*StringLen($text)
			If $width<90*$buttons Then
				$width = 90*$buttons
				If $buttons == 3 Then $width -= 10
			EndIf
		EndIf
	Else
		If 5*StringLen($text)<553 Then
			$width = 47+5*StringLen($text)
			If $width<100 Then $width = 100
		EndIf
	EndIf
	Local $lines = 0, $textsplit = StringSplit($text,@CR)
	For $i=1 To $textsplit[0]
		If $flag[1]==0 Then
			$lines = $lines + Int((5*StringLen($text))/570) + 1
		Else
			$lines = $lines + Int((5*StringLen($text))/537) + 1
		EndIf
	Next
	$height = 15*$lines + 47
	$temp = -1
	If $flag[4]<>0 Then $temp = 0x00000008
	If IsHWnd($hwnd) Then
		$_MessageBox_GUI[$handle] = GUICreate($title,$width,$height,-1,-1,0x80C80000, $temp, $hwnd)
	Else
		$_MessageBox_GUI[$handle] = GUICreate($title,$width,$height,-1,-1,0x80C80000, $temp)
	EndIf
	If $flag[3]==0 Or $flag[3]==2 Then GUISetIcon("shell32.dll",51,$_MessageBox_GUI[$handle])
	If $flag[1] == 1 Then
		$_MessageBox_ICON[$handle] = GUICtrlCreateIcon("proquota.exe",3,5,5,32,32)
		SoundPlay(StringReplace(RegRead("HKEY_CURRENT_USER\AppEvents\Schemes\Apps\.Default\SystemHand\.Current",""),"%SystemRoot%",@WindowsDir))
	ElseIf $flag[1]==2 Then
		$_MessageBox_ICON[$handle] = GUICtrlCreateIcon("shell32.dll",24,5,5,32,32)
	ElseIf $flag[1] == 3 Then
		$_MessageBox_ICON[$handle] = GUICtrlCreateIcon("proquota.exe",2,5,5,32,32)
		SoundPlay(StringReplace(RegRead("HKEY_CURRENT_USER\AppEvents\Schemes\Apps\.Default\SystemExclamation\.Current",""),"%SystemRoot%",@WindowsDir))
	ElseIf $flag[1] == 4 Then
		$_MessageBox_ICON[$handle] = GUICtrlCreateIcon("ahui.exe",0,5,5,32,32)
		SoundPlay(StringReplace(RegRead("HKEY_CURRENT_USER\AppEvents\Schemes\Apps\.Default\SystemAsterisk\.Current",""),"%SystemRoot%",@WindowsDir))
	Else
		SoundPlay(StringReplace(RegRead("HKEY_CURRENT_USER\AppEvents\Schemes\Apps\.Default\.Default\.Current",""),"%SystemRoot%",@WindowsDir))
	EndIf
	$temp = 30
	If $flag[1]<>0 Then $temp = 57
	If $flag[5]==0 Then
		GUICtrlCreateLabel($text,15,5,$width-$temp,15 * $lines,0x0400)
	Else
		GUICtrlCreateLabel($text,42,5,$width-$temp,15 * $lines)
	EndIf
	GUICtrlSetFont(-1,8.5,400)
	Switch $buttons
		Case 1
			If $flag[2]==0 Then
				$_MessageBox_BUTTON_1[$handle] = GUICtrlCreateButton($buttontext[0],$width/2-37,$height-33,75,22,1)
			Else
				$_MessageBox_BUTTON_1[$handle] = GUICtrlCreateButton($buttontext[0],$width/2-37,$height-33,75,22)
			EndIf
		Case 2
			If $flag[2]==0 Then
				$_MessageBox_BUTTON_1[$handle] = GUICtrlCreateButton($buttontext[0],$width/2-77,$height-33,75,22,1)
			Else
				$_MessageBox_BUTTON_1[$handle] = GUICtrlCreateButton($buttontext[0],$width/2-77,$height-33,75,22)
			EndIf
			If $flag[2]==1 Then
				$_MessageBox_BUTTON_2[$handle] = GUICtrlCreateButton($buttontext[1],$width/2+3,$height-33,75,22,1)
			Else
				$_MessageBox_BUTTON_2[$handle] = GUICtrlCreateButton($buttontext[1],$width/2+3,$height-33,75,22)
			EndIf
		Case 3
			If $flag[2]==0 Then
				$_MessageBox_BUTTON_1[$handle] = GUICtrlCreateButton($buttontext[0],$width/2-116,$height-33,75,22,1)
			Else
				$_MessageBox_BUTTON_1[$handle] = GUICtrlCreateButton($buttontext[0],$width/2-116,$height-33,75,22)
			EndIf
			If $flag[2]==1 Then
				$_MessageBox_BUTTON_2[$handle] = GUICtrlCreateButton($buttontext[1],$width/2-37,$height-33,75,22,1)
			Else
				$_MessageBox_BUTTON_2[$handle] = GUICtrlCreateButton($buttontext[1],$width/2-37,$height-33,75,22)
			EndIf
			If $flag[2]==2 Then
				$_MessageBox_BUTTON_3[$handle] = GUICtrlCreateButton($buttontext[2],$width/2+41,$height-33,75,22,1)
			Else
				$_MessageBox_BUTTON_3[$handle] = GUICtrlCreateButton($buttontext[2],$width/2+41,$height-33,75,22)
			EndIf
	EndSwitch
	$_MessageBox_TIMEOUT[$handle] = $timeout*1000
	$_MessageBox_TIMESTAMP[$handle] = TimerInit()
	$_MessageBox_TYPE[$handle] = $flag[0]
	$_MessageBox_BUTTONS[$handle] = $buttons
	GUISetState(@SW_SHOW,$_MessageBox_GUI[$handle])
	Return $handle
EndFunc

Func _MessageBox_GetNextHandle()
	For $i=0 To UBound($_MessageBox_HANDLES)-1
		If Not(IsBool($_MessageBox_HANDLES[$i])) Then
			$_MessageBox_HANDLES[$i] = True
			Return $i
		EndIf
	Next
	Local $top = UBound($_MessageBox_HANDLES) + 1
	ReDim $_MessageBox_GUI[$top]
	ReDim $_MessageBox_TYPE[$top]
	ReDim $_MessageBox_BUTTONS[$top]
	ReDim $_MessageBox_BUTTON_1[$top]
	ReDim $_MessageBox_BUTTON_2[$top]
	ReDim $_MessageBox_BUTTON_3[$top]
	ReDim $_MessageBox_ICON[$top]
	ReDim $_MessageBox_TIMEOUT[$top]
	ReDim $_MessageBox_TIMESTAMP[$top]
	ReDim $_MessageBox_HANDLES[$top]
	Return $top-1
EndFunc

Func _MessageBox_ProcessFlag($flag)
	Local $flags[6]
	For $i=0 To 5
		$flags[$i]=0
	Next
	If $flag>=524288 Then
		$flags[5] = 1
		$flag -= 524288
	EndIf
	If $flag>=262144 Then
		$flags[4] = 1
		$flag -= 262144
	EndIf
	If $flag>=8192 Then
		$flags[3] = 2
		$flag -= 8192
	EndIf
	If $flag>=4096 Then
		$flags[3] += 1
		$flag -= 4096
	EndIf
	If $flag>=512 Then
		$flags[2] = 2
		$flag -= 512
	EndIf
	If $flag>=256 Then
		$flags[2] = 1
		$flag -= 256
	EndIf
	If $flag>=64 Then
		$flags[1] = 4
		$flag -= 64
	EndIf
	If $flag>=48 Then
		$flags[1] = 3
		$flag -= 48
	EndIf
	If $flag>=32 Then
		$flags[1] = 2
		$flag -= 32
	EndIf
	If $flag>=16 Then
		$flags[1] = 1
		$flag -= 16
	EndIf
	$flags[0] = $flag
	Return $flags
EndFunc

; #FUNCTION# ====================================================================================================================
; Name...........: _MessageBox_SetTimeout
; Description ...: Modifies the timeout of a Message Box
; Syntax.........: _MessageBox_SetTimeout($handle,$timeout,$fromnow = True)
; Parameters ....: $handle      - The Handle of the Message Box
;                  $timeout     - The new timeout in milisecconds
;                  $fromnow     - True - Time is relitive to current time False - Time is relitive to creation time
; Return values .: Success      - True
;                  Failure      - False
; Author ........: Matthew McMullan (NerdFencer)
; Modified.......:
; Remarks .......: 
; Related .......: 
; Link ..........;
; Example .......; No
; ===============================================================================================================================
Func _MessageBox_SetTimeout($handle,$timeout,$fromnow = True)
	If $handle < UBound($_MessageBox_TIMEOUT) Then
		$_MessageBox_TIMEOUT[$handle] = $timeout
		If $fromnow Then $_MessageBox_TIMESTAMP[$handle] = TimerInit()
		Return True
	EndIf
	Return False
EndFunc

; #FUNCTION# ====================================================================================================================
; Name...........: _MessageBox_SetButtonTip
; Description ...: Gives a Button a Tooltip
; Syntax.........: _MessageBox_SetButtonTip($handle,$button,$text,$title=False,$icon=False,$options=False)
; Parameters ....: $handle      - The Handle of the Message Box
;                  $button      - The index of the button (1-3 left-right)
;                  Others       - Values to pass to GuiCtrlSetTip
; Return values .: Success      - True
;                  Failure      - False
; Author ........: Matthew McMullan (NerdFencer)
; Modified.......:
; Remarks .......: 
; Related .......: 
; Link ..........;
; Example .......; No
; ===============================================================================================================================
Func _MessageBox_SetButtonTip($handle,$button,$text,$title=False,$icon=False,$options=False)
	If $handle < UBound($_MessageBox_BUTTONS) And $_MessageBox_BUTTONS[$handle]>=$button Then
		Switch $button
			Case 1
				Return _MessageBox_SetButtonTip_Internal($_MessageBox_BUTTON_1[$handle],$text,$title,$icon,$options)
			Case 2
				Return _MessageBox_SetButtonTip_Internal($_MessageBox_BUTTON_2[$handle],$text,$title,$icon,$options)
			Case 3
				Return _MessageBox_SetButtonTip_Internal($_MessageBox_BUTTON_3[$handle],$text,$title,$icon,$options)
		EndSwitch
	EndIf
	Return False
EndFunc

Func _MessageBox_SetButtonTip_Internal($button,$text,$title=False,$icon=False,$options=False)
	If IsBool($title) Then
		Return GUICtrlSetTip($button,$text)
	ElseIf IsBool($icon) Then
		Return GUICtrlSetTip($button,$text,$title)
	ElseIf IsBool($options) Then
		Return GUICtrlSetTip($button,$text,$title,$icon)
	EndIf
	Return GUICtrlSetTip($button,$text,$title,$options)
EndFunc

; #FUNCTION# ====================================================================================================================
; Name...........: _MessageBox_SetButtonText
; Description ...: Changes the text of a Button
; Syntax.........: _MessageBox_SetButtonText($handle,$button,$text)
; Parameters ....: $handle      - The Handle of the Message Box
;                  $button      - The index of the button (1-3 left-right)
;                  $text        - The new text for the button
; Return values .: Success      - True
;                  Failure      - False
; Author ........: Matthew McMullan (NerdFencer)
; Modified.......:
; Remarks .......: 
; Related .......: 
; Link ..........;
; Example .......; No
; ===============================================================================================================================
Func _MessageBox_SetButtonText($handle,$button,$text)
	If $handle < UBound($_MessageBox_BUTTONS) And $_MessageBox_BUTTONS[$handle]>=$button Then
		Switch $button
			Case 1
				Return GUICtrlSetData($_MessageBox_BUTTON_1[$handle],$text)
			Case 2
				Return GUICtrlSetData($_MessageBox_BUTTON_2[$handle],$text)
			Case 3
				Return GUICtrlSetData($_MessageBox_BUTTON_3[$handle],$text)
		EndSwitch
	EndIf
	Return False
EndFunc

; #FUNCTION# ====================================================================================================================
; Name...........: _MessageBox_SetWindowIcon
; Description ...: Sets the Window Icon
; Syntax.........: _MessageBox_SetWindowIcon($handle,$icon,$iconID=-1)
; Parameters ....: $handle      - The Handle of the Message Box
;                  $icon        - The file that the icon is in
;                  $iconID      - The index of the icon
; Return values .: Success      - True
;                  Failure      - False
; Author ........: Matthew McMullan (NerdFencer)
; Modified.......:
; Remarks .......: 
; Related .......: 
; Link ..........;
; Example .......; No
; ===============================================================================================================================
Func _MessageBox_SetWindowIcon($handle,$icon,$iconID=-1)
	If $handle < UBound($_MessageBox_GUI) And FileExists($icon) Then
		Return GUISetIcon($icon,$iconID,$_MessageBox_GUI[$handle])
	EndIf
	Return False
EndFunc

; #FUNCTION# ====================================================================================================================
; Name...........: _MessageBox_Update
; Description ...: Updates the Message Box
; Syntax.........: _MessageBox_Update($handle, $msg, $legacy = False)
; Parameters ....: $handle      - The Handle of the Message Box
;                  $msg         - The return value from GUIGetMsg, either normal or advanvced output will work
;                  $legacy      - Use the same return values as MsgBox, or use button index
; Return values .: Success      - Dependant on Legacy option, button index, -1 for timeout, number return code from msgbox
;                  Failure      - 0 (nothing was pressed)
; Author ........: Matthew McMullan (NerdFencer)
; Modified.......:
; Remarks .......: 
; Related .......: 
; Link ..........;
; Example .......; No
; ===============================================================================================================================
Func _MessageBox_Update($handle, $msg, $legacy = False)
	If $_MessageBox_TIMEOUT[$handle]>0 And TimerDiff($_MessageBox_TIMESTAMP[$handle])>$_MessageBox_TIMEOUT[$handle] Then
		_MessageBox_Destroy($handle)
		Return -1
	EndIf
	If UBound($msg) == 5 Then
		If $msg[1] == $_MessageBox_GUI[$handle] And $msg[0]<>0 Then
			Return _MessageBox_Update_Internal($handle, $msg[0], $legacy)
		EndIf
	ElseIf UBound($msg)==0 And $msg<>0 Then
		Return _MessageBox_Update_Internal($handle, $msg, $legacy)
	EndIf
	Return 0
EndFunc

Func _MessageBox_Update_Internal($handle, $msg, $legacy = False)
	If $msg == $_MessageBox_BUTTON_1[$handle] Then
		_MessageBox_Destroy($handle)
		Return _MessageBox_Update_GenerateOutput($_MessageBox_TYPE[$handle], 1, $legacy)
	EndIf
	If $_MessageBox_BUTTONS[$handle]>=2 Then
		If $msg == $_MessageBox_BUTTON_2[$handle] Then
			_MessageBox_Destroy($handle)
			Return _MessageBox_Update_GenerateOutput($_MessageBox_TYPE[$handle], 2, $legacy)
		EndIf
		If $_MessageBox_BUTTONS[$handle]>=3 Then
			If $msg == $_MessageBox_BUTTON_3[$handle] Then
				_MessageBox_Destroy($handle)
				Return _MessageBox_Update_GenerateOutput($_MessageBox_TYPE[$handle], 3, $legacy)
			EndIf
		EndIf
	EndIf
	If $msg == $_MessageBox_ICON[$handle] Then Return -2
	Return 0
EndFunc

Func _MessageBox_Update_GenerateOutput($type, $button, $legacy)
	If $legacy==True Then
		Switch $button
			Case 1
				Switch $type
					Case 2
						Return 3
					Case 3
						Return 6
					Case 4
						Return 6
					Case 5
						Return 4
					Case 6
						Return 2
				EndSwitch
				Return 1
			Case 2
				Switch $type
					Case 1
						Return 2
					Case 2
						Return 4
					Case 5
						Return 2
					Case 6
						Return 10
				EndSwitch
				Return 7
		EndSwitch
		Switch $type
			Case 2
				Return 5
			Case 3
				Return 2
		EndSwitch
		Return 6
	EndIf
	Return $button
EndFunc

; #FUNCTION# ====================================================================================================================
; Name...........: _MessageBox_Destroy
; Description ...: Destroy a Message Box
; Syntax.........: _MessageBox_Destroy($handle)
; Parameters ....: $handle      - The Handle of the Message Box
; Return values .: Success      - True
;                  Failure      - False
; Author ........: Matthew McMullan (NerdFencer)
; Modified.......:
; Remarks .......: 
; Related .......: 
; Link ..........;
; Example .......; No
; ===============================================================================================================================
Func _MessageBox_Destroy($handle)
	Local $success = GUIDelete($_MessageBox_GUI[$handle])
	If $success Then
		$_MessageBox_HANDLES[$handle] = -1
		$_MessageBox_ICON[$handle] = -50
	EndIf
	Return $success
EndFunc
