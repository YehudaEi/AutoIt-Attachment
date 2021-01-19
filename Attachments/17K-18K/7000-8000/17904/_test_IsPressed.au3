	;----------------------------------------------------------------------------
	; included in main script
	;----------------------------------------------------------------------------
		$culoare_orange_CT    = 0xE76C24 ; [orange] R:231 G:108 B: 36
		$culoare_green_CT     = 0x036233 ; [green]  R:  3 G: 98 B: 51
		$culoare_green_scris  = 0x88AA88
	#include <GUIConstants.au3>
		Global $_title_fer_mouse_move = "Move mouse"
		Global $_cate_fer_mouse_move_avem = 0
		Global $_pressesd_key = 0
	;----------------------------------------------------------------------------
	; test area
	;----------------------------------------------------------------------------
	#include <Misc.au3>
	_enable_all_hotkeys ( )
	$Gui = GUICreate("Test", 200, 100 , 200 , 200)
	GUISetBkColor ( 0xcccccc )
	GUISetState ( )

	$_but_1 = GUICtrlCreateButton ( "press me", 10, 10 , 70 , 21)

	While 1
		Sleep ( 10 )
		$_msg   = GUIGetMsg ( )
		Select
			Case $_msg = $_but_1
				; stuff here
				_MsgBox_move_mouse ( "message" , "for you" , 1 , "Arial Bold" , WinGetHandle ("") )
		EndSelect
		If $_msg = $GUI_EVENT_CLOSE Then ExitLoop
	WEnd
	SoundPlay ( @WindowsDir & "\media\Windows XP Error.wav", 0 )
	GUIDelete   ( $Gui )
	Exit
	;----------------------------------------------------------------------------
	;----------------------------------------------------------------------------
	Func _MsgBox_move_mouse_2 ( $_string_1_mm , $_string_2_mm , $_sound_mode_mm , $_fontbold_mm , $_fer_mm )
		Local $_fer_mouse_move
		$_cate_fer_mouse_move_avem = $_cate_fer_mouse_move_avem + 1
		WinSetTrans ( $_fer_mm , "", 225 )
		;-----------------------------
		Local $_front_col = $culoare_green_CT , $_back_col = $culoare_orange_CT
		Local $fer_latime_mm , $fer_inaltime_mm , $fer_poz_x_mm , $fer_poz_y_mm , $fer_stil_mm
		Local $_label_inaltime = 16
		Local $_label_1_y , $_label_2_y
		Local $modulo, $modulo_X, $modulo_Y
		;-----------------------------
		$fer_stil_mm  = BitOR ( $WS_SYSMENU, $WS_BORDER , $WS_POPUPWINDOW  )
		;-----------------------------
		$_lat = StringLen ( $_string_1_mm )
		If $_lat < StringLen ( $_string_2_mm ) Then $_lat = StringLen ( $_string_2_mm )
		$fer_latime_mm = 80 + 6*$_lat
		If $fer_latime_mm < 210 then $fer_latime_mm = 210
		If $_string_2_mm <> "" Then
			$fer_inaltime_mm = 90
			$_label_1_y      = ($fer_inaltime_mm-2*$_label_inaltime)/3
			$_label_2_y      = 2*$_label_1_y + $_label_inaltime
		Else
			$fer_inaltime_mm = 70
			$_label_1_y      = ($fer_inaltime_mm-$_label_inaltime)/2
		EndIf
		$fer_poz_x_mm = ( @DesktopWidth  - $fer_latime_mm   ) /2 + Random ( 10, 30, 1 )
		$fer_poz_y_mm = ( @DesktopHeight - $fer_inaltime_mm ) /2 + Random ( 10, 30, 1 )
		;-----------------------------
		$_fer_mouse_move = GUICreate ( $_title_fer_mouse_move , $fer_latime_mm , $fer_inaltime_mm , $fer_poz_x_mm , $fer_poz_y_mm , $fer_stil_mm , -1 , $_fer_mm )
			If Mod ( $_cate_fer_mouse_move_avem , 2 ) = 1 Then
				GUISetBkColor   ( $culoare_green_scris ) 
			Else
				GUISetBkColor   ( $culoare_orange_CT ) 
			EndIf
		$_label_1_mm = GUICtrlCreateLabel  ( $_string_1_mm , 2 , $_label_1_y , $fer_latime_mm-4 , $_label_inaltime , $SS_CENTER )
			GUICtrlSetColor   ( $_label_1_mm , $culoare_green_CT )
			GUICtrlSetFont    ( $_label_1_mm , -1, -1, -1, $_fontbold_mm )
		If $_string_2_mm <> "" Then
			$_label_2_mm = GUICtrlCreateLabel  ( $_string_2_mm , 2 , $_label_2_y , $fer_latime_mm-4 , $_label_inaltime , $SS_CENTER )
				GUICtrlSetColor   ( $_label_2_mm , $culoare_green_CT )
				GUICtrlSetFont    ( $_label_2_mm , -1, -1, -1, $_fontbold_mm )
		EndIf
		;-----------------------------
		GUISetState ( )
		;-----------------------------
		If $_sound_mode_mm = 1 Then
			SoundPlay ( @WindowsDir & "\media\Windows XP Notify.wav", 0 )
		Else
			;_mission_impossible ( ) ; no need
		EndIf
		;-----------------------------
		$_pos_1_mm = MouseGetPos ( )
		Sleep (100)
		While 1
			Sleep ( 10 )
			$_msg_mm   = GUIGetMsg ( )
			$_pos_2_mm = MouseGetPos ( )
			$modulo_X  = $_pos_2_mm[0] - $_pos_1_mm[0]
			$modulo_Y  = $_pos_2_mm[1] - $_pos_1_mm[1]
			If $modulo_X < 0 Then $modulo_X = - $modulo_X
			If $modulo_Y < 0 Then $modulo_Y = - $modulo_Y
			If $modulo_X > $modulo_Y Then 
				$modulo =  $modulo_X
			Else
				$modulo =  $modulo_Y
			EndIf
			If $modulo > 18 Then ExitLoop
			If $_msg_mm = $GUI_EVENT_CLOSE Then ExitLoop
			If _any_key_is_pressed ( ) Then ExitLoop
		WEnd
		GUIDelete   ( $_fer_mouse_move )
		SoundPlay   ( "" )
		;-----------------------------
		WinSetTrans ( $_fer_mm , "", 255 )
	EndFunc
	;----------------------------------------------------------------------------
	;----------------------------------------------------------------------------
	Func _MsgBox_move_mouse ( $_string_1_mm , $_string_2_mm , $_sound_mode_mm , $_fontbold_mm , $_fer_mm )
		$_pressesd_key = 0
		_disable_all_hotkeys ( )
		_MsgBox_move_mouse_2 ( $_string_1_mm , $_string_2_mm , $_sound_mode_mm , $_fontbold_mm , $_fer_mm )
		_enable_all_hotkeys ( )
		Select
			Case $_pressesd_key = 116 ; {F5}
				Send ( "{F5}" )
			;Case $_pressesd_key = 117 ; {F6}
			;	Send ( "{F6}" )
			Case Else
				;
		EndSelect
	EndFunc
	;----------------------------------------------------------------------------
	;----------------------------------------------------------------------------
	Func _my_function ( )
		HotKeySet("{F5}")
		; stuff here
		_MsgBox_move_mouse ( "another message for you" , "" , 1 , "Arial Bold" , WinGetHandle ("") )
		HotKeySet("{F5}", "_my_function")
	EndFunc
	;----------------------------------------------------------------------------
	;----------------------------------------------------------------------------
	Func _my_function_2 ( )
		HotKeySet("{F6}")
		; stuff here
		_MsgBox_move_mouse ( "third mesage" , "" , 1 , "Arial Bold" , WinGetHandle ("") )
		HotKeySet("{F6}", "_my_function_2")
	EndFunc
	;----------------------------------------------------------------------------
	;----------------------------------------------------------------------------
	Func _any_key_is_pressed ( )
		Local $_key_pressed = False
		For $i = 1 To 255
			If _IsPressed(StringFormat("%02x", $i)) Then 
				$_key_pressed = True 
				$_pressesd_key = $i ; Global variable
				ExitLoop
			EndIf
		Next    
		Return $_key_pressed
	EndFunc
	;----------------------------------------------------------------------------
	;----------------------------------------------------------------------------
	Func _enable_all_hotkeys ( )
		;-----------------------------
		HotKeySet( "{F5}" , "_my_function"  )
		HotKeySet( "{F6}" , "_my_function_2" )
		;-----------------------------
	EndFunc
	;----------------------------------------------------------------------------
	;----------------------------------------------------------------------------
	Func _disable_all_hotkeys ( )
		;-----------------------------
		HotKeySet( "{F5}" )
		HotKeySet( "{F6}" )
		;-----------------------------
	EndFunc
