#include <IE.au3>
#include <Misc.au3>
#include <GuiConstants.au3>
Global $ratingNr, $CCKEY, $oIE, $iniread_user ,$iniread_pass, $oIE2, $msg
Opt("TrayMenuMode",1)   ; Default tray menu items (Script Paused/Exit) will not be shown
Opt("WinTitleMatchMode", 2) ; use any part of the window name

Hotkeyset("!^a", "_Exit")
Hotkeyset("{insert}", "buttonhit")
Hotkeyset("!^q", "_Show")

If Not FileExists("C:\myfile.ini") Then ; Creating ini file at program startup if not exist
IniWrite("C:\myfile.ini", "KeyHitSpeed", "speed", "1000")
IniWrite("C:\myfile.ini", "cliker_info", "Right_Click", "True")
IniWrite("C:\myfile.ini", "cliker_info", "Left_Click", "FALSE")
IniWrite("C:\myfile.ini", "Login info", "Save_logininfo_checkbox", "True") 
IniWrite("C:\myfile.ini", "Preferiences_info", "Autologin_at_Startup","False")
EndIf

$iniread_speed = IniRead("C:\myfile.ini", "KeyHitSpeed", "speed", "Not_Found")
$iniread_Right_Click_Value = IniRead("C:\myfile.ini", "cliker_info", "Right_Click", "")	
$iniread_Left_Click_Value = IniRead("C:\myfile.ini", "cliker_info", "Left_Click", "")
;~ Iniread Autokliker
;~ ---------------------------------------------------------------------------------------------------------
$iniread = IniReadSection("C:\myfile.ini", "cliker_info")
$iniread_speed = IniRead("C:\myfile.ini", "KeyHitSpeed", "speed", "Not_Found")
$iniread_rightklick = IniRead("C:\myfile.ini", "cliker_info", "Right_Click", "Not_Found")
$iniread_leftklick = IniRead("C:\myfile.ini", "cliker_info", "Left_Click", "Not_Found")
$iniread_Send_Raw_key = IniRead("C:\myfile.ini", "Keyhit_Shortcuts","Send_Raw_key", "")
$iniread_Send_key_lette_etc = IniRead("C:\myfile.ini", "Keyhit_Shortcuts","Key2","")
		$iniread_Send_Raw_key_state = IniRead("C:\myfile.ini", "Keyhit_Shortcuts","Send_Raw_key_state", "")
		$iniread_Send_key_lette_etc_state = IniRead("C:\myfile.ini", "Keyhit_Shortcuts","Send_key_lette_etc_state", "")
		$iniread_left_klick_state = IniRead("C:\myfile.ini", "Keyhit_Shortcuts","left_klick_state", "")
		$iniread_right_klick_state =  IniRead("C:\myfile.ini", "Keyhit_Shortcuts","right_klick_state", "")
$iniread_user = IniRead("C:\myfile.ini", "Login info", "Username", "") 
$iniread_pass = IniRead("C:\myfile.ini", "Login info", "Password", "") 	
$iniread_Save_logininfo_checkbox = IniRead("C:\myfile.ini", "Login info", "Save_logininfo_checkbox", "") 
$iniread_Autologin_at_Startup_and_start_rating = IniRead("C:\myfile.ini", "Preferiences_info", "Autologin_at_Startup_and_START_rating", "")
$iniread_Autologin_at_Startup = IniRead("C:\myfile.ini", "Preferiences_info", "Autologin_at_Startup", "")
$iniread_minimize_to_tray = IniRead("C:\myfile.ini", "Preferiences_info", "minimize_to_tray", "")
$iniread_Check_for_updates_at_startup = IniRead("C:\myfile.ini", "Preferiences_info", "Check_for_updates_at_startup", "")
		$iniread_Checkbox1 = IniRead("C:\myfile.ini", "Main_GUI", "checkbox1","")
		$iniread_Checkbox2 = IniRead("C:\myfile.ini", "Main_GUI", "checkbox2","")
		$iniread_Checkbox3 = IniRead("C:\myfile.ini", "Main_GUI", "checkbox3","")
		$iniread_Checkbox4 = IniRead("C:\myfile.ini", "Main_GUI", "checkbox4","")
		$iniread_Checkbox5 = IniRead("C:\myfile.ini", "Main_GUI", "checkbox5","")
		$iniread_Checkbox7 = IniRead("C:\myfile.ini", "Main_GUI", "checkbox7","")
		$iniread_radio_RANDOM = IniRead("C:\myfile.ini", "Main_GUI", "checkbox_random","")

;~ GUI Autocliker 
;~ ---------------------------------------------------------------------------------------------------------
$cliker_opt_window = GUICreate("Autocliker Advanced", 300, 205)
GUICtrlCreateLabel ("Clickspeed, 1000 = 1 sec:",5,11)		;Label Clickspeed
GUICtrlCreateLabel ("Start = INSERT",135,40)				;Label START (left, top , width , height )
GUICtrlCreateLabel ("Stop = Hold PAUSE",135,60)				;Label STOP

$Input_speed = GUICtrlCreateInput($iniread_speed, 135, 10, 80, 20) ;Input_speed
$Input_Send_Raw_key = GUICtrlCreateInput($iniread_Send_Raw_key, 5, 105, 100, 20) ; Input_Keyset 1
$Input_Send_key_letter_etc = GUICtrlCreateInput($iniread_Send_key_lette_etc, 5, 135, 100, 20) ; Input_Keyset 2

; Checked/uncheckked checkboxes at prog startup
$Checkbox_send_raw_key = GUICtrlCreateCheckbox ("Send RAW 1. Key:", 110, 104 )
If $iniread_Send_Raw_key_state = "True" Then
	GuiCtrlSetState(-1, $GUI_CHECKED)
Else
	GuiCtrlSetState(-1, $GUI_UNCHECKED)
EndIf
$Checkbox_Send_key_lette_etc = GUICtrlCreateCheckbox ("Send keys letters words etc:", 110, 134)
If $iniread_Send_key_lette_etc_state = "True" Then
	GuiCtrlSetState(-1, $GUI_CHECKED)
Else
	GuiCtrlSetState(-1, $GUI_UNCHECKED)
EndIf                                                                                        
$Right_Click_checkbox = GUICtrlCreateCheckbox ("Right_click", 10, 35)
if $iniread_rightklick = "True" Then
	GuiCtrlSetState(-1, $GUI_CHECKED)
Else
	GuiCtrlSetState(-1, $GUI_UNCHECKED)
EndIf
$Left_Click_checkbox = GUICtrlCreateCheckbox ("Left_click", 10, 65)
if $iniread_leftklick = "True" Then  	 
	GuiCtrlSetState(-1, $GUI_CHECKED)
Else
	GuiCtrlSetState(-1, $GUI_UNCHECKED)
EndIf

$save_Cliker_info_button = GUICtrlCreateButton("OK", 120, 170, 60, 23)    ;Button OK (left, top , width , height )
GUISetState(@SW_HIDE)

;~ GUI Preferiences
;~ ---------------------------------------------------------------------------------------------------------
$Preferiences_Opt_window = GUICreate("Preferiences", 300, 130)
;~ ---------------------------------------------------------------------------------------------------------
$save_Preferiences_OK_button = GUICtrlCreateButton("OK", 120, 95, 60, 23)    ;Button OK (left, top , width , height )
;~ ---------------------------------------------------------------------------------------------------------
$Checkbox_Autologin_at_Startup = GUICtrlCreateCheckbox ("Autologin at Startup", 10, 10,140)
if $iniread_Autologin_at_Startup = "True" Then   	 
	GuiCtrlSetState(-1, $GUI_CHECKED)
Else
	GuiCtrlSetState(-1, $GUI_UNCHECKED)
EndIf
;~ ---------------------------------------------------------------------------------------------------------
$Checkbox_Autologin_at_Startup_and_start_rating = GUICtrlCreateCheckbox ("Autologin at Startup and START rating", 10, 30,200)
if $iniread_Autologin_at_Startup_and_start_rating = "True" Then   	 
	GuiCtrlSetState(-1, $GUI_CHECKED)
Else
	GuiCtrlSetState(-1, $GUI_UNCHECKED)
EndIf
;~ ---------------------------------------------------------------------------------------------------------
$Checkbox_minimize_to_tray = GUICtrlCreateCheckbox ("Minimize to tray", 10, 50,140)
if $iniread_minimize_to_tray = "True" Then   	 
	GuiCtrlSetState(-1, $GUI_CHECKED)
Else
	GuiCtrlSetState(-1, $GUI_UNCHECKED)
EndIf
;~ ~ ---------------------------------------------------------------------------------------------------------
$Checkbox_Check_for_updates_at_startup = GUICtrlCreateCheckbox ("Silently Check for update whan program is launcehed", 10, 70,270)
if $iniread_Check_for_updates_at_startup = "True" Then   	 
	GuiCtrlSetState(-1, $GUI_CHECKED)
Else
	GuiCtrlSetState(-1, $GUI_UNCHECKED)
EndIf
GUISetState(@SW_HIDE)
;~ ********************************************************************************************************

;~ GUI Autologin
;~ ---------------------------------------------------------------------------------------------------------
$Window_aotologin_options = GUICreate("AutoLogin Options", 300, 105) ; GUI2 Window_aotologin_options
$Username_Input = GUICtrlCreateInput($iniread_user, 60, 10, 80, 20) ;Input Username
GUICtrlCreateLabel ("Username",5,11)						;		Label Username
$Pass_Input = GUICtrlCreateInput($iniread_pass, 60, 34, 80, 20)   	;Imput Pass
GUICtrlCreateLabel ("Password",5,31)								;Label password

$save_user_and_Checkbox = GUICtrlCreateCheckbox ("Remember user and pass", 150, 35, 200, 20)
if $iniread_Save_logininfo_checkbox = "True" Then    
	GuiCtrlSetState(-1, $GUI_CHECKED)
 Else
	GuiCtrlSetState(-1, $GUI_UNCHECKED)
EndIf
$save_user_and_pass__button = GUICtrlCreateButton("OK", 120, 70, 60, 23)   
$delete_user_and_pass__button = GUICtrlCreateButton("Delete", 190, 70, 60, 23)   
GUISetState(@SW_HIDE)
;~ ********************************************************************************************************

;~ Gui Mainwindow
;~ ---------------------------------------------------------------------------------------------------------
$mainwindow = GUICreate("Rate Raper Premium v1.1", 270, 195)
$OK = GUICtrlCreateButton("Start", 145, 55, 45, 23)   ;Button OK (left, top , width , height )
$Button_Log_in = GUICtrlCreateButton("Log-In", 210, 55, 45, 23)   ;Button Log in 
;~ ********************************************************************************************************
$Checkbox1 = GUICtrlCreateCheckbox ("1", 20, 10, 40, 20)
if $iniread_Checkbox1 = "True" Then   ; if Checkbox1 true 
	GuiCtrlSetState(-1, $GUI_CHECKED)
 Else
	GuiCtrlSetState(-1, $GUI_UNCHECKED)
EndIf
;~ ********************************************************************************************************
$Checkbox2 = GUICtrlCreateCheckbox ("2", 60, 10, 40, 20)
if $iniread_Checkbox2 = "True" Then   ; if Checkbox1 true 
	GuiCtrlSetState(-1, $GUI_CHECKED)
 Else
	GuiCtrlSetState(-1, $GUI_UNCHECKED)
EndIf
;~ ********************************************************************************************************
$Checkbox3 = GUICtrlCreateCheckbox ("3", 100, 10, 40, 20)
if $iniread_Checkbox3 = "True" Then   ; if Checkbox1 true 
	GuiCtrlSetState(-1, $GUI_CHECKED)
 Else
	GuiCtrlSetState(-1, $GUI_UNCHECKED)
EndIf
;~ ********************************************************************************************************
$Checkbox4 = GUICtrlCreateCheckbox ("4", 140, 10, 40, 20)
if $iniread_Checkbox4 = "True" Then   ; if Checkbox1 true 
	GuiCtrlSetState(-1, $GUI_CHECKED)
 Else
	GuiCtrlSetState(-1, $GUI_UNCHECKED)
EndIf
;~ ********************************************************************************************************
$Checkbox5 = GUICtrlCreateCheckbox ("5", 180, 10, 40, 20)
if $iniread_Checkbox5 = "True" Then   ; if Checkbox1 true 
	GuiCtrlSetState(-1, $GUI_CHECKED)
 Else
	GuiCtrlSetState(-1, $GUI_UNCHECKED)
EndIf
;~ ********************************************************************************************************
$Checkbox7 = GUICtrlCreateCheckbox ("7", 220, 10, 40, 20)
if $iniread_Checkbox7 = "True" Then   ; if Checkbox1 true 
	GuiCtrlSetState(-1, $GUI_CHECKED)
 Else
	GuiCtrlSetState(-1, $GUI_UNCHECKED)
EndIf
;~ ********************************************************************************************************
$radio_RANDOM = GUICtrlCreateCheckbox ("Random", 20, 32, 60, 20)
if $iniread_radio_RANDOM = "True" Then   ; if Checkbox1 true 
	GuiCtrlSetState(-1, $GUI_CHECKED)
 Else
	GuiCtrlSetState(-1, $GUI_UNCHECKED)
EndIf
;~ ********************************************************************************************************
$checkbox_hide_trayicom = GUICtrlCreateCheckbox ("Hide Trayicon", 20, 53, 85, 20)

$iniread_checkbox_user_comment = IniRead("C:\myfile.ini", "Main_GUI", "checkbox_user_comment","")
$checkbox_user_comment = GUICtrlCreateCheckbox ("Add comment", 20, 74, 95, 20)
if $iniread_checkbox_user_comment = "True" Then   ; if Checkbox1 true 
	GuiCtrlSetState(-1, $GUI_CHECKED)
 Else
	GuiCtrlSetState(-1, $GUI_UNCHECKED)
EndIf
$iniread_userinputtext = IniRead("C:\myfile.ini", "comments", "comment", "")

$userinputtext = GuiCtrlCreateInput($iniread_userinputtext, 20, 108, 234, 70)
;~ ---------------------------------------------------------------------------------------------------------

;~ Update at startup check ini file & if values are True Exicute
;~ ---------------------------------------------------------------------------------------------------------
if $iniread_Check_for_updates_at_startup = "True" Then _Update()

;Autologin at startup check ini file & if values are True Exicute
;~ ---------------------------------------------------------------------------------------------------------
if $iniread_Autologin_at_Startup = "True" Then 
	GUISetState(@SW_HIDE, $mainwindow)
	_Autologin_At_startup()
ElseIf $iniread_Autologin_at_Startup_and_start_rating = "True" Then
	GUISetState(@SW_HIDE, $mainwindow)
	$msgbox = MsgBox(1, "Start Client Setup", "Click OK to Continue...CAncel to change settings")
	 If $msgbox = 2 Then
		 _rate_or_not_torate_check()
	 Else
		_Autologin_at_Startup_and_start_rating()
	 EndIf
Else
	GUISetState(@SW_SHOW, $mainwindow)
EndIf

Func _rate_or_not_torate_check()
	GUISetState(@SW_SHOW, $mainwindow)
EndFunc

;~ File Menu START
;~ ---------------------------------------------------------------------------------------------------------
$filemenu = GUICtrlCreateMenu ("&File")
$exititem = GUICtrlCreateMenuitem ("Exit",$filemenu)
$options_menu = GUICtrlCreateMenu ("Options")
$update_item= GUICtrlCreateMenuitem ("Update",$options_menu)
$Autocliker_item= GUICtrlCreateMenuitem ("Autoclicker",$options_menu)
$Autologin_options_Item= GUICtrlCreateMenuitem ("AutoLogin",$options_menu)
$preferences_menu_Item = GUICtrlCreateMenuitem ("Preferences",$options_menu)
$Faile_menu_help = GUICtrlCreateMenu ("Help")
$about_file_menu_item= GUICtrlCreateMenuitem ("About",$Faile_menu_help)
$hotkey_file_menu_item= GUICtrlCreateMenuitem ("Hotkeys",$Faile_menu_help)
;~ ********************************************************************************************************

;~ Tray MENU
;~ ---------------------------------------------------------------------------------------------------------
$Tray_Maximize_item     = TrayCreateItem("Maximize")
$Tray_about_item     = TrayCreateItem("About")
$Tray_Autocliker_item     = TrayCreateItem("Autoclicker")
$Tray_help_item     = TrayCreateItem("Help")
TrayCreateItem("")
$Tray_Pass_options_Item  = TrayCreateItem("AutoLogin")
$Tray_Preferences_item  = TrayCreateItem("Preferences")
TrayCreateItem("")
$Tray_exititem_item       = TrayCreateItem("Exit")
TraySetState(@SW_HIDE)

While 1
    $msg = GUIGetMsg()
	$msg1 = TrayGetMsg()
 Select
	 
 case $msg = $Button_Log_in
	 _Autologin_At_startup() ;execute _Autologin_At_startup() Function
	 
 Case $msg = $update_item 
	 _Update()				;execute _Update() Function
		 
	Case $msg1 = $Tray_exititem_item 
		Exit
;~ 	Will close 1 active GUI Window 
;~ ---------------------------------------------------------------------------------------------------------	
		Case $msg = $exititem Or $msg = $GUI_EVENT_CLOSE
             $Hwnd = WinGetHandle('')
		If $Hwnd = $mainwindow Then
			IniWrite("C:\myfile.ini", "comments", "comment",GUICtrlRead($userinputtext))		
			Exit
		ElseIf $Hwnd = $Window_aotologin_options Then
			GUISetState(@SW_HIDE,$Window_aotologin_options)	
		ElseIf $Hwnd = $cliker_opt_window Then      ; If closed search options window
			GUISetState(@SW_HIDE,$cliker_opt_window)
		ElseIf $Hwnd = $Preferiences_Opt_window Then      
		GUISetState(@SW_HIDE,$Preferiences_Opt_window)
	EndIf
	
Case $msg = $GUI_EVENT_MINIMIZE
	$Hwnd = WinGetHandle('')
		if $iniread_minimize_to_tray = "True" Then
			GUISetState(@SW_HIDE,$mainwindow)
			GUISetState(@SW_HIDE,$Window_aotologin_options)
			GUISetState(@SW_HIDE,$cliker_opt_window)
			GUISetState(@SW_HIDE,$Preferiences_Opt_window)
		EndIf
;~ ********************************************************************************************************
;~ ;Shouw GUI Autoklicker 			
;~ ---------------------------------------------------------------------------------------------------------
		Case $msg = $Autocliker_item or $msg1 = $Tray_Autocliker_item												
            GUISetState(@SW_SHOW, $cliker_opt_window)
			GUISetState(@SW_restore,$cliker_opt_window)
;~ ;Shouw GUI $Preferiences 			
;~ ---------------------------------------------------------------------------------------------------------
		Case $msg = $preferences_menu_Item or $msg1 = $Tray_Preferences_item												
            GUISetState(@SW_SHOW, $Preferiences_Opt_window)
			GUISetState(@SW_restore,$Preferiences_Opt_window)
;~ ;Shouw GUI Autologin 			
;~ ---------------------------------------------------------------------------------------------------------
Case $msg = $Autologin_options_Item or $msg1 = $Tray_Pass_options_Item
			$iniread_user = IniRead("C:\myfile.ini", "Login info", "Username", "") 
			$iniread_pass = IniRead("C:\myfile.ini", "Login info", "Password", "") 
			If $iniread_user Then GUICtrlSetData($Username_Input, $iniread_user)
			If $iniread_user Then GUICtrlSetData($Pass_Input, $iniread_pass)
		   GUISetState(@SW_SHOW, $Window_aotologin_options)
		   GUISetState(@SW_restore,$Window_aotologin_options)
;~ ********************************************************************************************************
;~ Button Save logininfo
;~ ---------------------------------------------------------------------------------------------------------
		Case $msg = $save_user_and_pass__button
		If GUICtrlRead($save_user_and_Checkbox) = $GUI_CHECKED Then ; If Checkbox is selected & pess ok	
			IniWrite("C:\myfile.ini", "Login info", "Username", GUICtrlRead($Username_Input))
			IniWrite("C:\myfile.ini", "Login info", "Password", GUICtrlRead($Pass_Input))
			IniWrite("C:\myfile.ini", "Login info", "Save_logininfo_checkbox", "True")
				GUISetState(@SW_HIDE,$Window_aotologin_options)	; Hide it
				MsgBox(4096, "Result", "your info saved to C:\myfile.ini",1)
				GUISetState(@SW_SHOW, $mainwindow)
				GUISetState(@SW_restore,$mainwindow)
		Else
				IniWrite("C:\myfile.ini", "Login info", "Save_logininfo_checkbox", "FALSE")
				GUISetState(@SW_HIDE,$Window_aotologin_options)	; Hide it
				GUISetState(@SW_SHOW, $mainwindow)
				GUISetState(@SW_restore,$mainwindow)
		EndIf
;~ ********************************************************************************************************
;~ Deletes Username & password
;~ ---------------------------------------------------------------------------------------------------------
		case  $msg = $delete_user_and_pass__button
				If IniDelete("C:\myfile.ini", "Login info", "Username") Then GUICtrlSetData($Username_Input, '')
                If IniDelete("C:\myfile.ini", "Login info", "Password") Then GUICtrlSetData($Pass_Input, '')   
				MsgBox(4096, "Result", "Data deleted!",1)
				GUISetState(@SW_HIDE,$Window_aotologin_options)	; Hide it
				GUISetState(@SW_SHOW, $mainwindow)
				GUISetState(@SW_restore,$mainwindow)
;~ ********************************************************************************************************
	Case $msg1 = $Tray_Maximize_item
		GUISetState(@SW_SHOW,$mainwindow)
		GUISetState(@SW_RESTORE,$mainwindow)
	Case $msg = $about_file_menu_item or $msg1 = $Tray_about_item
		Msgbox(64,"About:","Not For sell, Rent or auction,This is Freeware. All right reserverd!"& @CRLF & "If you have downloaded this file from anywhere else than                                         it may be as good as anything, we advide you to get the file from original site "& @CRLF & @CRLF &" Written by the “Hands of God of iternal justice” or something like that....")		
	Case $msg = $hotkey_file_menu_item or $msg1 = $Tray_help_item
		Msgbox(64,"Info:","EXIT program == LeftCTRL+ALTF+a"& @CRLF & "Show Program == LeftCRTL+ALT+q"& @CRLF & "Start Autoklikker == INSERT"& @CRLF & "Stop Autoklikker,RATING == HOLD PAuse/BREAK")	
	Case $msg = $GUI_EVENT_CLOSE or $msg =  $exititem or $msg1 =  $Tray_exititem_item
		IniWrite("C:\myfile.ini", "comments", "comment",GUICtrlRead($userinputtext))
		Exit
;~ ---------------------------------------------------------------------------------------------------------
;~ Hide unhide tray icon
	Case $msg = $checkbox_hide_trayicom And BitAND(GUICtrlRead($checkbox_hide_trayicom), $GUI_CHECKED) = $GUI_CHECKED
		Opt("TrayIconHide", 1) ;un-hide the icon
	Case $msg = $checkbox_hide_trayicom And BitAND(GUICtrlRead($checkbox_hide_trayicom), $GUI_UNCHECKED) = $GUI_UNCHECKED
		Opt("TrayIconHide", 0) ;un-hide the icon

;~  Button save autoclikker info, see if checkboxes are checkked & do someting if press save
;~ ---------------------------------------------------------------------------------------------------------
	case $msg = $save_Cliker_info_button
		IniWrite("C:\myfile.ini", "KeyHitSpeed", "speed", GUICtrlRead($Input_speed))
		IniWrite("C:\myfile.ini", "Keyhit_Shortcuts","Send_Raw_key",GUICtrlRead($Input_Send_Raw_key))
		IniWrite("C:\myfile.ini", "Keyhit_Shortcuts","Key2",GUICtrlRead($Input_Send_key_letter_etc))
		GUISetState(@SW_HIDE,$cliker_opt_window)
		If GUICtrlRead($Right_Click_checkbox) = $GUI_CHECKED Then
			IniWrite("C:\myfile.ini", "cliker_info", "Right_Click", "True")	
		ElseIf GUICtrlRead($Right_Click_checkbox) = $GUI_UNCHECKED Then
			IniWrite("C:\myfile.ini", "cliker_info", "Right_Click", "FALSE")
		EndIf	
		If GUICtrlRead($Left_Click_checkbox) = $GUI_CHECKED Then
			IniWrite("C:\myfile.ini", "cliker_info", "Left_Click", "True")	
		ElseIf GUICtrlRead($Left_Click_checkbox) = $GUI_UNCHECKED Then
			IniWrite("C:\myfile.ini", "cliker_info", "Left_Click", "FALSE")
		EndIf
		If GUICtrlRead($Left_Click_checkbox) = $GUI_CHECKED and GUICtrlRead($Right_Click_checkbox) = $GUI_CHECKED  Then
			IniWrite("C:\myfile.ini", "cliker_info", "Right_Click", "True")	
			IniWrite("C:\myfile.ini", "cliker_info", "Left_Click", "True")		
		ElseIf GUICtrlRead($Left_Click_checkbox) = $GUI_UNCHECKED and GUICtrlRead($Right_Click_checkbox) = $GUI_UNCHECKED  Then
			IniWrite("C:\myfile.ini", "cliker_info", "Right_Click", "FALSE")	
			IniWrite("C:\myfile.ini", "cliker_info", "Left_Click", "FALSE")	
		EndIf
		If GUICtrlRead($Checkbox_send_raw_key) = $GUI_CHECKED Then
			IniWrite("C:\myfile.ini", "Keyhit_Shortcuts","Send_Raw_key_state", "True")
			IniWrite("C:\myfile.ini", "Keyhit_Shortcuts","Send_key_lette_etc_state", "FALSE")
		ElseIf GUICtrlRead($Checkbox_Send_key_lette_etc) = $GUI_CHECKED Then
			IniWrite("C:\myfile.ini", "Keyhit_Shortcuts","Send_key_lette_etc_state", "True")
			IniWrite("C:\myfile.ini", "Keyhit_Shortcuts","Send_Raw_key_state", "FALSE")
		EndIf
		If GUICtrlRead($Checkbox_send_raw_key) = $GUI_UNCHECKED and GUICtrlRead($Checkbox_send_raw_key) = $GUI_UNCHECKED  Then
			IniWrite("C:\myfile.ini", "Keyhit_Shortcuts","Send_Raw_key_state", "FALSE")
		EndIf
		If GUICtrlRead($Checkbox_Send_key_lette_etc) = $GUI_UNCHECKED and GUICtrlRead($Checkbox_Send_key_lette_etc) = $GUI_UNCHECKED  Then
			IniWrite("C:\myfile.ini", "Keyhit_Shortcuts","Send_key_lette_etc_state", "FALSE")	
		EndIf		
		
	Case $msg = $Checkbox_send_raw_key And BitAND(GUICtrlRead($Checkbox_send_raw_key), $GUI_CHECKED) = $GUI_CHECKED
	GuiCtrlSetState($Checkbox_Send_key_lette_etc, $GUI_UNCHECKED)
	GuiCtrlSetState($Checkbox_Send_key_lette_etc, $GUI_DISABLE)
	
	GuiCtrlSetState($Right_Click_checkbox, $GUI_UNCHECKED)
	GuiCtrlSetState($Right_Click_checkbox, $GUI_DISABLE)
	
	GuiCtrlSetState($Left_Click_checkbox, $GUI_UNCHECKED)
	GuiCtrlSetState($Left_Click_checkbox, $GUI_DISABLE)
	
	Case $msg = $Checkbox_Send_key_lette_etc And BitAND(GUICtrlRead($Checkbox_Send_key_lette_etc), $GUI_CHECKED) = $GUI_CHECKED
	GuiCtrlSetState($Checkbox_send_raw_key, $GUI_UNCHECKED)
	GuiCtrlSetState($Checkbox_send_raw_key, $GUI_DISABLE)
	
	GuiCtrlSetState($Right_Click_checkbox, $GUI_UNCHECKED)
	GuiCtrlSetState($Right_Click_checkbox, $GUI_DISABLE)
	
	GuiCtrlSetState($Left_Click_checkbox, $GUI_UNCHECKED)
	GuiCtrlSetState($Left_Click_checkbox, $GUI_DISABLE)
	
	Case $msg = $Checkbox_send_raw_key And BitAND(GUICtrlRead($Checkbox_send_raw_key), $GUI_UNCHECKED) = $GUI_UNCHECKED
	GuiCtrlSetState($Checkbox_Send_key_lette_etc, $GUI_ENABLE)
	GuiCtrlSetState($Right_Click_checkbox, $GUI_ENABLE)
	GuiCtrlSetState($Left_Click_checkbox, $GUI_ENABLE)
	
	Case $msg = $Checkbox_Send_key_lette_etc And BitAND(GUICtrlRead($Checkbox_Send_key_lette_etc), $GUI_UNCHECKED) = $GUI_UNCHECKED
	GuiCtrlSetState($Checkbox_send_raw_key, $GUI_ENABLE)
	GuiCtrlSetState($Right_Click_checkbox, $GUI_ENABLE)
	GuiCtrlSetState($Left_Click_checkbox, $GUI_ENABLE)

	Case $msg = $Left_Click_checkbox And BitAND(GUICtrlRead($Left_Click_checkbox), $GUI_CHECKED) = $GUI_CHECKED
		GuiCtrlSetState($Checkbox_send_raw_key, $GUI_UNCHECKED)
		GuiCtrlSetState($Checkbox_send_raw_key, $GUI_DISABLE)
		GuiCtrlSetState($Checkbox_Send_key_lette_etc, $GUI_UNCHECKED)
		GuiCtrlSetState($Checkbox_Send_key_lette_etc, $GUI_DISABLE)
	
	Case $msg = $Right_Click_checkbox And BitAND(GUICtrlRead($Right_Click_checkbox), $GUI_CHECKED) = $GUI_CHECKED
		GuiCtrlSetState($Checkbox_send_raw_key, $GUI_UNCHECKED)
		GuiCtrlSetState($Checkbox_send_raw_key, $GUI_DISABLE)
		GuiCtrlSetState($Checkbox_Send_key_lette_etc, $GUI_UNCHECKED)
		GuiCtrlSetState($Checkbox_Send_key_lette_etc, $GUI_DISABLE)
	
	Case $msg = $Left_Click_checkbox And BitAND(GUICtrlRead($Left_Click_checkbox), $GUI_UNCHECKED) = $GUI_UNCHECKED 
		GuiCtrlSetState($Checkbox_send_raw_key, $GUI_UNCHECKED)
		GuiCtrlSetState($Checkbox_send_raw_key, $GUI_ENABLE)
		GuiCtrlSetState($Checkbox_Send_key_lette_etc, $GUI_UNCHECKED)
		GuiCtrlSetState($Checkbox_Send_key_lette_etc, $GUI_ENABLE)
		
	Case $msg = $Right_Click_checkbox And BitAND(GUICtrlRead($Left_Click_checkbox), $GUI_UNCHECKED) = $GUI_UNCHECKED 
		GuiCtrlSetState($Checkbox_send_raw_key, $GUI_UNCHECKED)
		GuiCtrlSetState($Checkbox_send_raw_key, $GUI_ENABLE)
		GuiCtrlSetState($Checkbox_Send_key_lette_etc, $GUI_UNCHECKED)
		GuiCtrlSetState($Checkbox_Send_key_lette_etc, $GUI_ENABLE)		

;~  1-7 checkboxes
;~ ---------------------------------------------------------------------------------------------------------
	Case $msg = $Checkbox1 And BitAND(GUICtrlRead($Checkbox1), $GUI_CHECKED) = $GUI_CHECKED
		IniWrite("C:\myfile.ini", "Main_GUI", "checkbox1","True")
	Case $msg = $Checkbox2 And BitAND(GUICtrlRead($Checkbox2), $GUI_CHECKED) = $GUI_CHECKED
		IniWrite("C:\myfile.ini", "Main_GUI", "checkbox2","True")
	Case $msg = $Checkbox3 And BitAND(GUICtrlRead($Checkbox3), $GUI_CHECKED) = $GUI_CHECKED
		IniWrite("C:\myfile.ini", "Main_GUI", "checkbox3","True")
	Case $msg = $Checkbox4 And BitAND(GUICtrlRead($Checkbox4), $GUI_CHECKED) = $GUI_CHECKED
		IniWrite("C:\myfile.ini", "Main_GUI", "checkbox4","True")
	Case $msg = $Checkbox5 And BitAND(GUICtrlRead($Checkbox5), $GUI_CHECKED) = $GUI_CHECKED
		IniWrite("C:\myfile.ini", "Main_GUI", "checkbox5","True")
	Case $msg = $Checkbox7 And BitAND(GUICtrlRead($Checkbox7), $GUI_CHECKED) = $GUI_CHECKED
		IniWrite("C:\myfile.ini", "Main_GUI", "checkbox7","True")
	Case $msg = $radio_RANDOM And BitAND(GUICtrlRead($radio_RANDOM), $GUI_CHECKED) = $GUI_CHECKED
		IniWrite("C:\myfile.ini", "Main_GUI", "checkbox_random","True")
	Case $msg = $checkbox_user_comment And BitAND(GUICtrlRead($checkbox_user_comment), $GUI_CHECKED) = $GUI_CHECKED
		IniWrite("C:\myfile.ini", "Main_GUI", "checkbox_user_comment","True")
;~ ---------------------------------------------------------------------------------------------------------
	Case $msg = $Checkbox1 And BitAND(GUICtrlRead($Checkbox1), $GUI_UNCHECKED) = $GUI_UNCHECKED
		IniWrite("C:\myfile.ini", "Main_GUI", "checkbox1","False")
	Case $msg = $Checkbox2 And BitAND(GUICtrlRead($Checkbox2), $GUI_UNCHECKED) = $GUI_UNCHECKED
		IniWrite("C:\myfile.ini", "Main_GUI", "checkbox2","False")
	Case $msg = $Checkbox3 And BitAND(GUICtrlRead($Checkbox3), $GUI_UNCHECKED) = $GUI_UNCHECKED
		IniWrite("C:\myfile.ini", "Main_GUI", "checkbox3","False")
	Case $msg = $Checkbox4 And BitAND(GUICtrlRead($Checkbox4), $GUI_UNCHECKED) = $GUI_UNCHECKED
		IniWrite("C:\myfile.ini", "Main_GUI", "checkbox4","False")
	Case $msg = $Checkbox5 And BitAND(GUICtrlRead($Checkbox5), $GUI_UNCHECKED) = $GUI_UNCHECKED
		IniWrite("C:\myfile.ini", "Main_GUI", "checkbox5","False")
	Case $msg = $Checkbox7 And BitAND(GUICtrlRead($Checkbox7), $GUI_UNCHECKED) = $GUI_UNCHECKED
		IniWrite("C:\myfile.ini", "Main_GUI", "checkbox7","False")
	Case $msg = $radio_RANDOM And BitAND(GUICtrlRead($radio_RANDOM), $GUI_UNCHECKED) = $GUI_UNCHECKED
		IniWrite("C:\myfile.ini", "Main_GUI", "checkbox_random","False")
		Case $msg = $checkbox_user_comment And BitAND(GUICtrlRead($checkbox_user_comment), $GUI_UNCHECKED) = $GUI_UNCHECKED
		IniWrite("C:\myfile.ini", "Main_GUI", "checkbox_user_comment","False")

;~ button Save Preferiences
;~ ---------------------------------------------------------------------------------------------------------
	case $msg = $save_Preferiences_OK_button 
;~ ---------------------------------------------------------------------------------------------------------
	If GUICtrlRead($Checkbox_Autologin_at_Startup) = $GUI_CHECKED then 
		IniWrite("C:\myfile.ini", "Preferiences_info", "Autologin_at_Startup", "True")
		IniWrite("C:\myfile.ini", "Preferiences_info", "Autologin_at_Startup_and_START_rating", "False")
	ElseIf GUICtrlRead($Checkbox_Autologin_at_Startup_and_start_rating) = $GUI_CHECKED Then
		IniWrite("C:\myfile.ini", "Preferiences_info", "Autologin_at_Startup_and_START_rating", "True")
		IniWrite("C:\myfile.ini", "Preferiences_info", "Autologin_at_Startup", "False")
	ElseIf GUICtrlRead($Checkbox_minimize_to_tray) = $GUI_CHECKED Then
		IniWrite("C:\myfile.ini", "Preferiences_info", "minimize_to_tray", "True")
	ElseIf GUICtrlRead($Checkbox_minimize_to_tray) = $GUI_UNCHECKED Then	
		IniWrite("C:\myfile.ini", "Preferiences_info", "minimize_to_tray", "False")
	Else 
		IniWrite("C:\myfile.ini", "Preferiences_info", "Autologin_at_Startup_and_START_rating", "False")
		IniWrite("C:\myfile.ini", "Preferiences_info", "Autologin_at_Startup", "False")
	EndIf	
	If GUICtrlRead($Checkbox_Check_for_updates_at_startup) = $GUI_CHECKED Then IniWrite("C:\myfile.ini", "Preferiences_info", "Check_for_updates_at_startup", "True")	
	If GUICtrlRead($Checkbox_Check_for_updates_at_startup) = $GUI_UNCHECKED Then IniWrite("C:\myfile.ini", "Preferiences_info", "Check_for_updates_at_startup", "False")
	If GUICtrlRead($Checkbox_Autologin_at_Startup_and_start_rating) = $GUI_UNCHECKED Then IniWrite("C:\myfile.ini", "Preferiences_info", "Autologin_at_Startup_and_START_rating", "False")
	If GUICtrlRead($Checkbox_Autologin_at_Startup) = $GUI_UNCHECKED Then IniWrite("C:\myfile.ini", "Preferiences_info", "Autologin_at_Startup", "False")	

	GUISetState(@SW_HIDE,$Preferiences_Opt_window)
	
	Case $msg = $Checkbox_Autologin_at_Startup And BitAND(GUICtrlRead($Checkbox_Autologin_at_Startup), $GUI_CHECKED) = $GUI_CHECKED
	GuiCtrlSetState($Checkbox_Autologin_at_Startup_and_start_rating, $GUI_UNCHECKED)

	Case $msg = $Checkbox_Autologin_at_Startup And BitAND(GUICtrlRead($Checkbox_Autologin_at_Startup), $GUI_UNCHECKED) = $GUI_UNCHECKED
	GuiCtrlSetState($Checkbox_Autologin_at_Startup_and_start_rating, $GUI_UNCHECKED)
	
	
	Case $msg = $Checkbox_Autologin_at_Startup_and_start_rating And BitAND(GUICtrlRead($Checkbox_Autologin_at_Startup_and_start_rating), $GUI_CHECKED) = $GUI_CHECKED
	GuiCtrlSetState($Checkbox_Autologin_at_Startup, $GUI_UNCHECKED)

	case $msg = $OK ;start button on main GUI
		_Startrating() ;will start rating, but you must be logged in first
EndSelect
WEnd

;~ Func Start rating
;~ ---------------------------------------------------------------
Func _Startrating()
		GUISetState(@SW_HIDE)
		MsgBox(64, 'Info:', 'Hiding to background',1)
		$oIE = _IECreate("                           ",0,0)
		_IELoadWait($oIE)

while 1 ; Loop 1 Begins
	If Not _Sleep_IsPressed($Input_speed, '13') Then 
		GUISetState(@SW_SHOW,$mainwindow)
		ExitLoop
	EndIf
	
;Collect info about the page & rate the image	
while 1 ; Loop 2 Begins
	If Not _Sleep_IsPressed($Input_speed, '13') Then ExitLoop
	sleep(200)
$oBOdy = _IEBodyReadText($oIE)
	sleep(200)
 if StringInStr($oBody, "lokeerinud") Then ;search page & see if user has blokked you
		_IENavigate ($oIE, "                           ");if found wordpeace User has blokked you "keerinud"
      _IELoadWait($oIE)
	  if @error <> 0 then ExitLoop
	  EndIf
	  
;if add comment box is checkked add a comment
If GUICtrlRead($checkbox_user_comment) = $GUI_CHECKED Then
		$oForm = _IEFormGetCollection($oIE,2) ; find the form hir its form 2
		if @error <> 0 then ExitLoop
			sleep(200)
		$Kommenteeri = _IEFormElementGetObjByName($oForm,"text") ; text input area name
		if @error <> 0 then ExitLoop
			sleep(200)
		_IEFormElementSetValue($Kommenteeri,GUICtrlRead($userinputtext)) ;set text in text area
		if @error <> 0 then ExitLoop
			sleep(200)
		_IEFormSubmit($oForm) ;submit form
		if @error <> 0 then ExitLoop
			sleep(200)
		_IELoadWait ($oIE)
		if @error <> 0 then ExitLoop
		EndIf
	EndIf
	
If GUICtrlRead($radio_RANDOM) = $GUI_CHECKED Then ;Randomly rate the image if checkbox is checkked
		Dim $CCKEY[7],$ratingNr
		If GUICtrlRead($Checkbox1) = $GUI_CHECKED Then $CCKEY[1] = 6
		If GUICtrlRead($Checkbox2) = $GUI_CHECKED Then $CCKEY[2] = 7
		If GUICtrlRead($Checkbox3) = $GUI_CHECKED Then $CCKEY[3] = 8
		If GUICtrlRead($Checkbox4) = $GUI_CHECKED Then $CCKEY[4] = 9
		If GUICtrlRead($Checkbox5) = $GUI_CHECKED Then $CCKEY[5] = 10
		If GUICtrlRead($Checkbox7) = $GUI_CHECKED Then $CCKEY[6] = 11
		$ratingNr=$CCKEY[Random(1,7)]
Else
	_random_NOT() 
EndIf		
		sleep(200)
	$oForm = _IEFormGetCollection($oIE,0)
	if @error <> 0 then ExitLoop
		sleep(200)
	$oRate = _IEFormElementGetCollection($oForm,$ratingNr) ; select radiobox
	if @error <> 0 then ExitLoop
		sleep(200)
	_IEAction($oRate, "click") ; klik the radiobox
	if @error <> 0 then ExitLoop
		sleep(200)
   _IELoadWait($oIE)
   if @error <> 0 then ExitLoop
	   sleep(200)
WEnd ; Loop 2 Ends

;If any kind of error happened in loop 2, refresh the page
while 1 ; Loop 3 Begins
	_IENavigate($oIE,"                           ")
	_IELoadWait($oIE)
	
; if no error happened go to loop 1 beginning & continue rating.
If @error = 0 then ExitLoop	
WEnd ; Loop 3 Ends
WEnd ; Loop 1 Ends
EndFunc

;~ func not random
;~ ---------------------------------------------------------------
func _random_NOT()
If GUICtrlRead($Checkbox1) = $GUI_CHECKED Then	
	$ratingNr = 6
ElseIf GUICtrlRead($Checkbox2) = $GUI_CHECKED Then
	$ratingNr = 7
ElseIf GUICtrlRead($Checkbox3) = $GUI_CHECKED Then
	$ratingNr = 8
ElseIf GUICtrlRead($Checkbox4) = $GUI_CHECKED Then
	$ratingNr = 9 
ElseIf GUICtrlRead($Checkbox5) = $GUI_CHECKED Then
	$ratingNr = 10 
ElseIf GUICtrlRead($Checkbox7) = $GUI_CHECKED Then
	$ratingNr = 11
EndIf
EndFunc

;~ Func autoklikker
;~ --------------------------------------------------------------------------------------------------------------------------
Func buttonhit()
If GUICtrlRead($Left_Click_checkbox) = $GUI_CHECKED and GUICtrlRead($Right_Click_checkbox) = $GUI_CHECKED Then
	$iniread_speed = IniRead("C:\myfile.ini", "KeyHitSpeed", "speed", "Not_Found")
	while 1
		If Not _Sleep_IsPressed($iniread_speed, '13') Then ExitLoop		; if pause/break is pressed exit loop
		MouseClick("Right")
		Opt("MouseClickDelay", GUICtrlRead($Input_speed))
	If Not _Sleep_IsPressed($iniread_speed, '13') Then ExitLoop
		MouseClick("Left")
		Opt("MouseClickDelay", GUICtrlRead($Input_speed))
	WEnd
MsgBox(0, " ", "Stopping",1)
	ElseIf GUICtrlRead($Right_Click_checkbox) = $GUI_CHECKED Then ; If Checkbox is selected 
		$iniread_speed = IniRead("C:\myfile.ini", "KeyHitSpeed", "speed", "Not_Found")
	while 1
		If Not _Sleep_IsPressed($Input_speed, '13') Then ExitLoop
		MouseClick("Right")
		Opt("MouseClickDelay", GUICtrlRead($Input_speed))
	WEnd
MsgBox(0, " ", "Stopping",1)		
	ElseIf GUICtrlRead($Left_Click_checkbox) = $GUI_CHECKED Then 
		$iniread_speed = IniRead("C:\myfile.ini", "KeyHitSpeed", "speed", "Not_Found")
	while 1
		If Not _Sleep_IsPressed($iniread_speed, '13') Then ExitLoop
		MouseClick("Left")
		Opt("MouseClickDelay", GUICtrlRead($Input_speed))
	WEnd		
MsgBox(0, " ", "Stopping",1)
;~ --------------------------------------------------------------------------------------------------------------------------
	ElseIf GUICtrlRead($Checkbox_send_raw_key) = $GUI_CHECKED Then
	$iniread_speed = IniRead("C:\myfile.ini", "KeyHitSpeed", "speed","Not_Found")
while 1
	If Not _Sleep_IsPressed($iniread_speed, '13') Then ExitLoop
		Send('{' & GUICtrlRead($Input_Send_Raw_key) & '}')
WEnd
MsgBox(0, " ", "Stopping",1)
;~ --------------------------------------------------------------------------------------------------------------------------
	ElseIf GUICtrlRead($Checkbox_Send_key_lette_etc) = $GUI_CHECKED Then
	$iniread_speed = IniRead("C:\myfile.ini", "KeyHitSpeed", "speed", "Not_Found")
while 1
	If Not _Sleep_IsPressed($iniread_speed, '13') Then ExitLoop
	Send(GUICtrlRead($Input_Send_key_letter_etc))
WEnd
MsgBox(0, " ", "Stopping",1)
;~ --------------------------------------------------------------------------------------------------------------------------
EndIf
EndFunc

;~ Func _IsPressed
;~ --------------------------------------------------------------------------------------------------------------------------
Func _Sleep_IsPressed($nSleep, $sIsPressed, $iDefault = 20)
    Local $iAdd, $nExitLoop = Int($nSleep) / Int($iDefault)
    Do
        Sleep($iDefault)
        $iAdd += 1
    Until $iAdd >= $nExitLoop Or _IsPressed($sIsPressed)
    If _IsPressed($sIsPressed) Then Return SetError(1, 0, 0)
    Return 1
EndFunc

;~ Func Autologin At startup
;~ --------------------------------------------------------------------------------------------------------------------------
Func _Autologin_At_startup()
    ;Logging in
  if $iniread_Autologin_at_Startup = "True" or $msg = $Button_Log_in Then 
	$oIE3 = _IECreate("                   ",1,1)
	_IELoadWait($oIE)
	sleep(200)
    $o_form = _IEFormGetObjByName ($oIE3, "loginform")
	sleep(200)
	$o_user = _IEFormElementGetObjByName ($o_form, "username")
	sleep(200)
	$o_password = _IEFormElementGetObjByName ($o_form, "password")
	sleep(200)
	
;Cheking ini to see, if field are empty
$iniread_user = IniRead("C:\myfile.ini", "Login info", "Username", "") 
$iniread_pass = IniRead("C:\myfile.ini", "Login info", "Password", "") 	
If $iniread_user = '' Or $iniread_pass = '' Then
	  MsgBox(0, "Result", "Please fill the Loginform before using this option....Exiting")
	  Exit
	Else
	$username = $iniread_user
	$password = $iniread_pass
EndIf

	_IEFormElementSetValue ($o_user, $username)
	sleep(100)
    _IEFormElementSetValue ($o_password, $password)
	sleep(100)
    _IEFormSubmit($o_form)
    _IELoadWait($oIE3)
	_IENavigate($oIE3,"                           ")
;Checking if page was loaded sucessfully after login, if not, then Refresh page until it Sucessfuly loads
while 1 
If @error = 0 then
    ExitLoop
Else
    _IENavigate($oIE3,"                   ")
    _IELoadWait($oIE3)
EndIf
WEnd

EndIf
;~ ---------------------------------------------------------------------------------------------------------
EndFunc  


;~ Func Autologin At startup and start rating
;~ ----------------------------------------------------------------------------------------------------------
Func _Autologin_at_Startup_and_start_rating()
	$oIE = _IECreate("                  ",0,0)
	_IELoadWait($oIE)
	$o_form = _IEFormGetObjByName ($oIE, "loginform")
	sleep(200)
	$o_user = _IEFormElementGetObjByName ($o_form, "username")
	sleep(200)
	$o_password = _IEFormElementGetObjByName ($o_form, "password")

$iniread_user = IniRead("C:\myfile.ini", "Login info", "Username", "") 
$iniread_pass = IniRead("C:\myfile.ini", "Login info", "Password", "") 	
If $iniread_user = '' Or $iniread_pass = '' Then
	  MsgBox(0, "Result", "Please fill the Loginform before using this option....Exiting")
	  Exit
	Else
	$username = $iniread_user
	$password = $iniread_pass
EndIf

	_IEFormElementSetValue ($o_user, $username)
	sleep(100)
    _IEFormElementSetValue ($o_password, $password)
	sleep(100)
    _IEFormSubmit($o_form)
    _IELoadWait($oIE)
	_IENavigate($oIE,"                           ")
    _IELoadWait($oIE)
;Checking if page was loaded sucessfully after login, if not, then Refresh page until it Sucessfuly loads
while 1 
If @error = 0 then
    ExitLoop
Else
    _IENavigate($oIE,"                           ")
    _IELoadWait($oIE)
EndIf
WEnd

;~ Begin rating
;~ ---------------------------------------------------------------------------------------------------------
while 1 ; Loop 1 Begins
	If Not _Sleep_IsPressed($Input_speed, '13') Then 
		GUISetState(@SW_SHOW,$mainwindow)
		ExitLoop
	EndIf
;Collect info about the page & rate the image with 5	
while 1 ; Loop 2 Begins
	If Not _Sleep_IsPressed($Input_speed, '13') Then ExitLoop
	
$oBOdy = _IEBodyReadText($oIE)
 if StringInStr($oBody, "lokeerinud") Then 
	  _IENavigate ($oIE, "                           ");if found wordpeace User has blokked you "keerinud"
      _IELoadWait($oIE)
	  if @error <> 0 then ExitLoop
 EndIf
	
If GUICtrlRead($radio_RANDOM) = $GUI_CHECKED Then ; randon radiobox select
		Dim $CCKEY[7],$ratingNr
		If GUICtrlRead($Checkbox1) = $GUI_CHECKED Then $CCKEY[1] = 6
		If GUICtrlRead($Checkbox2) = $GUI_CHECKED Then $CCKEY[2] = 7
		If GUICtrlRead($Checkbox3) = $GUI_CHECKED Then $CCKEY[3] = 8
		If GUICtrlRead($Checkbox4) = $GUI_CHECKED Then $CCKEY[4] = 9
		If GUICtrlRead($Checkbox5) = $GUI_CHECKED Then $CCKEY[5] = 10
		If GUICtrlRead($Checkbox7) = $GUI_CHECKED Then $CCKEY[6] = 11
		$ratingNr=$CCKEY[Random(1,7)]
Else
	_random_NOT()
EndIf		

	$oForm = _IEFormGetCollection($oIE,0)
	if @error <> 0 then ExitLoop
		sleep(200)
	$oRate = _IEFormElementGetCollection($oForm,$ratingNr) ; select radiobox 5
	if @error <> 0 then ExitLoop
		sleep(200)	
	_IEAction($oRate, "click")
	if @error <> 0 then ExitLoop
		sleep(200)
   _IELoadWait($oIE)
   if @error <> 0 then ExitLoop
WEnd ; Loop 2 Ends

;If any kind of error happened in loop 2, refresh the page
while 1 ; Loop 3 Begins
	_IENavigate($oIE,"                           ")
	_IELoadWait($oIE)
	
; if no error happened go to loop 1 beginning & continue rating.
If @error = 0 then ExitLoop	
WEnd ; Loop 3 Ends
WEnd ; Loop 1 Ends
	
EndFunc
;~ *************************************************************************************************

;~ Func Show mainwindow if Pause/break is pressed
;~ ----------------------------------------------------------------------------------------------------------
Func _Show()
    GUISetState(@SW_SHOW, $mainwindow)
	GUISetState(@SW_restore,$mainwindow)
EndFunc   

;~ Func Update open invisible page, search for teext & if found display msgbox & close page
;~ ----------------------------------------------------------------------------------------------------------
Func _Update()
	if $iniread_Check_for_updates_at_startup = "False" Then 
	MsgBox(0, "Update", "Connecting please wait...It may taka a while, depending on your connecton speed!",4)
	EndIf
	$oIE2 = _IECreate ("                              ",0,0)
	_IELoadWait($oIE2)
	$oBOdy = _IEBodyReadText($oIE2)
	if Not	StringInStr($oBody, "Rateraper_Premium_v1.1") Then 
		   $msgbox = MsgBox(1, "Update", "Update is avalible. Go to website?")
		If $msgbox = 2 Then
			_IEQuit($oIE2)
			_Show()	
		Else
			_IEQuit($oIE2)
			_IECreate ("                              ",0,1)
		EndIf
	Else
		if $iniread_Check_for_updates_at_startup = "False" Then
		MsgBox(0, "Update", "You have the latest version avalible!")
		EndIf
		_IEQuit($oIE2)
		 _Show()
	EndIf	
EndFunc

Func _Exit()
	_IEQuit($oIE)
	_IEQuit($oIE2)
    Exit
EndFunc   ;==>_Exit