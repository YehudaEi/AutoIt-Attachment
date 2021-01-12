#include <GUIConstants.au3>

$Form1 = GUICreate("AForm1", 146, 98, 448, 296)
$Button1 = GUICtrlCreateButton("AButton1", 8, 64, 129, 25, 0)
$Label1 = GUICtrlCreateLabel("", 8, 8, 129, 49, BitOR($SS_CENTER,$SS_SUNKEN))
GUICtrlSetFont(-1, 24, 800, 0, "Comic Sans MS")
GUISetState(@SW_SHOW)

While 1
    $nMsg = GUIGetMsg()
    Switch $nMsg
        Case $GUI_EVENT_CLOSE
            Exit
        Case $Button1
            $Pressed = 0
            GUICtrlSetState($Button1, $GUI_DISABLE)
            HotKeySet("{SPACE}", "_TrackKey")
            For $i = 5 To 0 Step -1
                GUICtrlSetData($Label1, $i)
                Sleep(1000)
            Next
            HotKeySet("{SPACE}")
            message("", "Pressed Space " & $Pressed & " Times.", $Form1 )
            ;MsgBox(0, "", "Pressed Space " & $Pressed & " Times.")
            GUICtrlSetState($Button1, $GUI_ENABLE)
    EndSwitch
WEnd

Func _TrackKey()
    HotKeySet("{SPACE}")
    $Pressed = $Pressed + 1
    HotKeySet("{SPACE}", "_TrackKey")
EndFunc

Func message($P_title, $P_Text, $P_parent, $P_flag = 0, $P_dis = 1, $P_timeOut = 0)
	;##This will create a MSGBOX with or withOut input using GUICREATE with a parent windows
	;## flags: 0 for OK button only
	;##        4 for Yes and NO will return 7 for NO and 6 for yes
	;########  10 for INPUT BOX will return "INPUT" for OK and -1 for Cancel
	GUISetState(@SW_SHOW, $P_parent)
	GUISetState(@SW_RESTORE, $P_parent);;restoring the GUI.
	$L_mode_backup = Opt("GUIOnEventMode", 0)
	Local Const $L_char_width = 5, $L_button_width = 70, $L_button_hight = 23, $L_char_hight = 15
	Local $L_get_win_pos, $L_MSG_BAD = -123, $L_input = -124, $L_temp_read, $L_input_Width, $L_line_count, $L_TEMP_char_perLine
	Local $L_lable_width, $L_lable_hight, $L_temp, $L_get_win_pos, $L_temp_time, $L_first_button_left, $L_second_button_left
	$L_line_count = StringSplit($P_Text, @LF, 1)
	Dim $L_char_perLine[$L_line_count[0] + 1]
	If $P_dis = 1 Then
		GUISetState(@SW_DISABLE, $P_parent)
	ElseIf $P_dis = 2 Then
		GUISetState(@SW_DISABLE, $P_parent)
		GUISetState(@SW_HIDE, $P_parent)
	EndIf
	
	Select
		Case $L_line_count[0] > 1
			$L_char_perLine[0] = $L_line_count[0]
			For $L_a = 1 To $L_line_count[0]
				$L_TEMP_char_perLine = StringSplit($L_line_count[$L_a], '')
				$L_char_perLine[$L_a] = $L_TEMP_char_perLine[0]
			Next
		Case $L_line_count[0] = 1
			$L_char_perLine = StringSplit($P_Text, "")
			$L_char_perLine[1] = $L_char_perLine[0]
			$L_char_perLine[0] = 1
	EndSelect
	
	;;Calculating the lable width...and Lable hight..
	Select
		Case $L_char_perLine[0] = 1
			$L_lable_hight = $L_char_hight
			$L_lable_width = ($L_char_perLine[1] * $L_char_width)
		Case $L_char_perLine[0] > 1
			$L_temp = $L_char_perLine[1]
			For $L_a = 2 To $L_char_perLine[0]
				If $L_temp < $L_char_perLine[$L_a] Then
					$L_temp = $L_char_perLine[$L_a]
				EndIf
			Next
			;setting the width
			$L_lable_width = ($L_temp * $L_char_width)
			;setting the hight
			$L_lable_hight = ($L_char_hight * $L_char_perLine[0])
	EndSelect
	;;Calculating the GUI width...
	Select
		Case $P_flag = 0 ; The OK button and the LABLE
			$L_GUI_Width = $L_lable_width + 30
			$L_GUI_hight = $L_lable_hight + 85
			
		Case $P_flag = 4  ; TWO BUTTONS and the LABLE
			$L_GUI_hight = $L_lable_hight + 85
			$L_GUI_Width = $L_lable_width + 30
			
		Case $P_flag = 10 ; TWO BUTTONS , INPUT and the LABLE
			$L_GUI_Width = $L_lable_width + 30
			$L_GUI_hight = $L_lable_hight + 85 + 30
	EndSelect
	
	;;Calculating buffer space between yes and no buttons
	$L_first_button_left = (($L_GUI_Width / 4) - ($L_button_width / 2)) + ($L_GUI_Width / 10)
	If $L_first_button_left < 5 Then
		$L_first_button_left = 5
	EndIf
	
	$L_second_button_left = ((($L_GUI_Width / 4) * 3) - ($L_button_width / 2)) - ($L_GUI_Width / 10)
	If ($L_second_button_left) < ($L_first_button_left + $L_button_width + 4) Then
		$L_second_button_left = ($L_first_button_left + $L_button_width + 4)
	EndIf
	
	If ($L_second_button_left - $L_first_button_left) > 150 Then
		$L_buf_adjus = ($L_second_button_left - $L_first_button_left) / 4
		$L_first_button_left = $L_first_button_left + $L_buf_adjus
		$L_second_button_left = $L_second_button_left - $L_buf_adjus
	EndIf
	
	If $L_second_button_left + $L_button_width + 5 > $L_GUI_Width Then
		$L_GUI_Width = $L_second_button_left + $L_button_width + 10
	EndIf
	
	$L_get_win_pos = WinGetPos($P_parent)
	$L_MSG_GUI = GUICreate($P_title, $L_GUI_Width, $L_GUI_hight , ($L_get_win_pos[0] + ($L_get_win_pos[2] / 2)) - ($L_GUI_Width / 2) , ($L_get_win_pos[1] + ($L_get_win_pos[3] / 2)) - ($L_GUI_hight / 2), 0x00000001, -1, $P_parent)
	$L_MSG_lable = GUICtrlCreateLabel($P_Text, 10, 10, $L_lable_width + 10, $L_lable_hight)
	;GUICtrlSetBkColor( -1 , 0x00ff00 )
	Select
		Case $P_flag = 0
			$L_MSG_GOOD = GUICtrlCreateButton( "  OK   " , (($L_GUI_Width / 2)) - ($L_button_width / 2) , ($L_GUI_hight - 30) - ($L_button_hight + 10), $L_button_width, $L_button_hight)
		Case $P_flag = 4
			$L_MSG_GOOD = GUICtrlCreateButton( "  Yes   ", $L_first_button_left , ($L_GUI_hight - 30) - ($L_button_hight + 10), $L_button_width, $L_button_hight)
			$L_MSG_BAD = GUICtrlCreateButton( "  No   ", $L_second_button_left , ($L_GUI_hight - 30) - ($L_button_hight + 10), $L_button_width, $L_button_hight)
		Case $P_flag = 10
			$L_MSG_GOOD = GUICtrlCreateButton( "  OK   ", $L_first_button_left, ($L_GUI_hight - 30) - ($L_button_hight + 10), $L_button_width, $L_button_hight)
			$L_MSG_BAD = GUICtrlCreateButton( "  Cancel   ", $L_second_button_left , ($L_GUI_hight - 30) - ($L_button_hight + 10), $L_button_width, $L_button_hight)
	EndSelect
	If $P_flag = 10 Then
		If $L_GUI_Width > 400 Then
			$L_input_Width = 340
		Else
			$L_input_Width = $L_GUI_Width - 50
		EndIf
		
		$L_input = GUICtrlCreateInput("" , (($L_GUI_Width / 2) - ($L_input_Width / 2)) , ($L_GUI_hight - ($L_button_hight + 10 + 60)), $L_input_Width, 20)
	EndIf
	
	GUISetState(@SW_SHOW, $L_MSG_GUI)
	If $P_timeOut <> 0 Then
		$L_temp_time = TimerInit()
	EndIf
	While 1
		If $P_timeOut <> 0 Then
			If (TimerDiff($L_temp_time) = $P_timeOut) or (TimerDiff($L_temp_time) > $P_timeOut) Then
				GUIDelete($L_MSG_GUI)
				If $P_dis = 2 Then
					GUISetState(@SW_SHOW, $P_parent)
					GUISetState(@SW_ENABLE, $P_parent)
				ElseIf $P_dis = 1 Then
					GUISetState(@SW_ENABLE, $P_parent)
				EndIf
				GUISetState(@SW_RESTORE, $P_parent)
				Opt("GUIOnEventMode", $L_mode_backup)
				Return -1
			EndIf
		EndIf
		
		$L_MSG_MSG = GUIGetMsg(1)
		Select
			Case ($L_MSG_MSG[0] = $L_MSG_GOOD) And ($L_MSG_MSG[1] == $L_MSG_GUI) And ($P_flag <> 10)
				GUIDelete($L_MSG_GUI)
				If $P_dis = 2 Then
					GUISetState(@SW_SHOW, $P_parent)
					GUISetState(@SW_ENABLE, $P_parent)
				ElseIf $P_dis = 1 Then
					GUISetState(@SW_ENABLE, $P_parent)
				EndIf
				GUISetState(@SW_RESTORE, $P_parent)
				Opt("GUIOnEventMode", $L_mode_backup)
				If $P_flag = 0 Then Return 0
				If $P_flag = 4 Then Return 6
				
			Case ($L_MSG_MSG[0] = $L_MSG_BAD) And ($L_MSG_MSG[1] == $L_MSG_GUI) And ($P_flag <> 0)
				GUIDelete($L_MSG_GUI)
				If $P_dis = 2 Then
					GUISetState(@SW_SHOW, $P_parent)
					GUISetState(@SW_ENABLE, $P_parent)
				ElseIf $P_dis = 1 Then
					GUISetState(@SW_ENABLE, $P_parent)
				EndIf
				GUISetState(@SW_RESTORE, $P_parent)
				Opt("GUIOnEventMode", $L_mode_backup)
				SetError(1)
				Return 7
				
			Case ($L_MSG_MSG[0] = $L_MSG_GOOD) And ($L_MSG_MSG[1] == $L_MSG_GUI) And ($P_flag = 10)
				$L_temp_read = GUICtrlRead($L_input)
				GUIDelete($L_MSG_GUI)
				If $P_dis = 2 Then
					GUISetState(@SW_SHOW, $P_parent)
					GUISetState(@SW_ENABLE, $P_parent)
				ElseIf $P_dis = 1 Then
					GUISetState(@SW_ENABLE, $P_parent)
				EndIf
				GUISetState(@SW_RESTORE, $P_parent)
				Opt("GUIOnEventMode", $L_mode_backup)
				Return $L_temp_read
		EndSelect
	WEnd
	GUISetState(@SW_ENABLE, $P_parent)
	GUISetState(@SW_RESTORE, $P_parent)
	Opt("GUIOnEventMode", $L_mode_backup)
EndFunc   ;==>message