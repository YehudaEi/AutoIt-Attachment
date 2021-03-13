
;TASKS:
;update all msgboxes to top msgboxes
;update comboboxes when new values added,
;add new database - in databases
;add new template - in templates
;display combo in templates and open chosen template
;worktime button (coming soon, after all other is done)
;hidden command run from ini config file that will be stored in computer
;smart icon for a program, moving base exe to path,
;enable execute program only from computers where I gave permisions (tie to computer achitecture, or ip adress)

#include <WindowsConstants.au3>
#include <GuiConstants.au3>
#include <GuiConstantsEx.au3>
#include <ButtonConstants.au3>
#include <StaticConstants.au3>
#include <EditConstants.au3>
#include <ComboConstants.au3>
#include <File.au3>
#include <Misc.au3>

;UDF-s
#include <GIFAnimation.au3>

#NoTrayIcon

Global $template_folder, $main_file





;starting part
Global $welcome_gui = GuiCreate("Welcome", 200, 80, -1, -1, BitOR($WS_SYSMENU, $WS_CAPTION, $WS_POPUPWINDOW, $WS_BORDER, $WS_CLIPSIBLINGS))
GuiSetBkColor(0xffffff)
GuiSetState()

Global $OK_button = GuiCtrlCreateButton("OK", 159, 40, 36, 23)
GuiCtrlSetState($OK_button, $GUI_DISABLE)

$radio1 = GuiCtrlCreateRadio("New user ", 10, 10)
$radio2 = GuiCtrlCreateRadio("Existing user ", 10, 40)


While 1
	$msg = GuiGetMsg()

		Switch $msg

				Case $radio1
					GuiCtrlSetState($OK_button, $GUI_ENABLE)


			Case $radio2
				GuiCtrlSetState($OK_button, $GUI_ENABLE)


			Case $GUI_EVENT_CLOSE
				_close()

			Case $OK_button
				_main_choice()

		EndSwitch

WEnd

Func _main_choice()
	Local $read_radio1 = GuiCtrlRead($radio1)
	If $read_radio1 = $BST_CHECKED Then _register_new()

	Local $read_radio2 = GuiCtrlRead($radio2)
	If $read_radio2 = $BST_CHECKED Then _existing_user()

EndFunc

Func _register_new()

Local $flash_disk = DriveGetDrive("REMOVABLE")
If @error Then
MsgBox(48, "Warning", "Please insert your personal pen drive and try again")

Return 0
Else

	GuiCtrlCreateLabel("Pen drive: ", 100, 14)
	GuiCtrlSetColor(-1, 0xcc0000)
Global $drive_combo = GuiCtrlCreateCombo("", 160, 14, 35, "", $CBS_DROPDOWNLIST)
	For $i = 1 To $flash_disk[0]
	GuiCtrlSetData(-1, StringUpper($flash_disk[$i]))
Next


EndIf

GuiCtrlSetState($OK_button, $GUI_DISABLE)
GuiCtrlSetState($radio2, $GUI_DISABLE)
Sleep(1500)




While 1

	$msg5 = GuiGetMsg()

			Switch $msg5


				Case $drive_combo
					_check_pen_drive()

				Case $GUI_EVENT_CLOSE
					Exit

			EndSwitch
WEnd


EndFunc

Func _check_pen_drive()




	Global $combo_state = GuiCtrlRead($drive_combo)
	If $combo_state = 0 Then
		Local $check_pendrive = MsgBox(262212, "Personal pen drive selected", "Please confirm that drive " & GuiCtrlRead($drive_combo) & " is your pen drive")
		If $check_pendrive = 6 Then
;MsgBox(48, "Warning", "Please insert your personal pen drive and try again")
;Else


		Global $filename = InputBox("Username", "Please type in your username:", "ssbokinn", "")



If $filename = true then
Global $main_directory = DirCreate(GuiCtrlRead($drive_combo) & "\SSBPanel\") ;SOMEHOW INDICATE GLOBAL PATH / done with this?
_FileCreate(GuiCtrlRead($drive_combo) & "\SSBPanel\" & $filename & "_conf.ini") ;SOMEHOW INDICATE GLOBAL PATH / done with this?
Global $main_file = (GuiCtrlRead($drive_combo) & "\SSBPanel\" & $filename & "_conf.ini")



;Protection note-
IniWrite(GuiCtrlRead($drive_combo) & "\SSBPanel\" & $filename & "_conf.ini", "Worktime", "null", "valid")
FileWriteLine(GuiCtrlRead($drive_combo) & "\SSBPanel\" & $filename & "_conf.ini", "")
FileWriteLine(GuiCtrlRead($drive_combo) & "\SSBPanel\" & $filename & "_conf.ini", "")
FileWriteLine(GuiCtrlRead($drive_combo) & "\SSBPanel\" & $filename & "_conf.ini", "")

;here code databases
IniWriteSection(GuiCtrlRead($drive_combo) & "\SSBPanel\" & $filename & "_conf.ini", "Databases", "")
FileWriteLine(GuiCtrlRead($drive_combo) & "\SSBPanel\" & $filename & "_conf.ini", "")


;here code folders /
FileWriteLine(GuiCtrlRead($drive_combo) & "\SSBPanel\" & $filename & "_conf.ini", "")
FileWriteLine(GuiCtrlRead($drive_combo) & "\SSBPanel\" & $filename & "_conf.ini", "")

IniWriteSection(GuiCtrlRead($drive_combo) & "\SSBPanel\" & $filename & "_conf.ini", "Folders", "")
IniWrite(GuiCtrlRead($drive_combo) & "\SSBPanel\" & $filename & "_conf.ini", "Folders", "1", "")
FileWriteLine(GuiCtrlRead($drive_combo) & "\SSBPanel\" & $filename & "_conf.ini", "")


;here code templates /
FileWriteLine(GuiCtrlRead($drive_combo) & "\SSBPanel\" & $filename & "_conf.ini", "")
FileWriteLine(GuiCtrlRead($drive_combo) & "\SSBPanel\" & $filename & "_conf.ini", "")

IniWriteSection(GuiCtrlRead($drive_combo) & "\SSBPanel\" & $filename & "_conf.ini", "Templates", "")
FileWriteLine(GuiCtrlRead($drive_combo) & "\SSBPanel\" & $filename & "_conf.ini", "")

;here code for db_select
FileWriteLine(GuiCtrlRead($drive_combo) & "\SSBPanel\" & $filename & "_conf.ini", "")
FileWriteLine(GuiCtrlRead($drive_combo) & "\SSBPanel\" & $filename & "_conf.ini", "")

IniWriteSection(GuiCtrlRead($drive_combo) & "\SSBPanel\" & $filename & "_conf.ini", "db_select", "")
FileWriteLine(GuiCtrlRead($drive_combo) & "\SSBPanel\" & $filename & "_conf.ini", "")


;here code templates /


_registration()

GuiDelete($welcome_gui)

Elseif $filename = 0 Then

	MsgBox(262144, "", "New user not created.")
	Exit
EndIf

ElseIf $check_pendrive = 7 Then
	Return 0
EndIf
EndIf






EndFunc


Func _existing_user()
	Global $instruction = FileOpenDialog("Choose your instruction file", @HomeDrive, "Instructon file: (*.ini)", 1)

	If $instruction = True then
		_start_main()
	Else
		Return 0
	EndIf
EndFunc

GuiSetState()

Func _start_main()
	Global $drive_combo
	Global $check_genuine = IniRead($instruction, "Worktime", "null", "")


		If $check_genuine = String("valid") Then

		GuiDelete($welcome_gui)
		_main_panel()
	Else
		MsgBox(16, "Error", "Wrong instruction file!")
	EndIf
EndFunc

;temporary



Func _registration()
	GuiDelete($welcome_gui)
	Global $reg_panel = GuiCreate("New user registration", 400, 400, -1, -1, BitOR($WS_SYSMENU, $WS_CAPTION, $WS_POPUPWINDOW, $WS_BORDER, $WS_CLIPSIBLINGS))
	GuiSetBkColor(0xffffff)
GuiSetState()



GuiCtrlCreateLabel($filename &  ", to avoid unathorized access," & @CRLF & "keep this window hidden from others", 200, 10)

GuiCtrlCreateLabel("Databases:", 30, 40)


Global $PDP_check = GuiCtrlCreateCheckbox("PDP", 30, 75)
Global $IIIS_check = GuiCtrlCreateCheckbox("IIIS", 30, 95)
Global $CSDD_check = GuiCtrlCreateCheckbox("CSDD", 30, 115)
Global $PADIS_check = GuiCtrlCreateCheckbox("PADIS", 30, 135)
Global $Mustangs_check = GuiCtrlCreateCheckbox("Mustangs", 30, 155)
Global $NVIS_check = GuiCtrlCreateCheckbox("NVIS", 30, 175)
Global $SYS_check = GuiCtrlCreateCheckbox("SYSII", 30, 195)
Global $NSYST_check = GuiCtrlCreateCheckbox("NSYST", 30, 215)

GuiCtrlCreateLabel("Template folder:", 30, 255)
Global $template_button = GuiCtrlCreateButton("...", 130, 255, 25, 20)

Global $pGIF = "vp2.gif"
Global $hGIF = _GUICtrlCreateGIF("vp2.gif", "", 20, 320, $pGIF)

Global $save_to_ini = GuiCtrlCreateButton("Register", 315, 365, 80)
GuiCtrlSetState($save_to_ini, $GUI_DISABLE)

While 1
	Global $msg2 = GuiGetMsg()

		Switch $msg2

			Case $GUI_EVENT_CLOSE
				_close()

			Case $PDP_check
				_PDP_check()

			Case $IIIS_check
				_IIIS_check()

			Case $CSDD_check
				_CSDD_check()

			Case $PADIS_check
				_PADIS_check()

			Case $Mustangs_check
				_Mustangs_check()

			Case $NVIS_check
				_NVIS_check()

			Case $SYS_check
				_SYS_check()

			Case $NSYST_check
				_NSYST_check()

			Case $template_button
				_template_folder()

			Case $save_to_ini
				_save_to_ini()



	EndSwitch



WEnd





EndFunc

Func _checkboxes()
	$checkboxes_totally = GuiCtrlRead($PDP_check) + GuiCtrlRead($IIIS_check) + GuiCtrlRead($CSDD_check) + GuiCtrlRead($PADIS_check) + GuiCtrlRead($Mustangs_check) + GuiCtrlRead($NVIS_check) + GuiCtrlRead($SYS_check) + GuiCtrlRead($NSYST_check)
	If $checkboxes_totally >= 32 Then GuiCtrlSetState($save_to_ini, $GUI_DISABLE)
	If $checkboxes_totally < 32 Then GuiCtrlSetState($save_to_ini, $GUI_ENABLE)
EndFunc


Func _template_folder()
	Global $template_folder = FileSelectFolder("Template folder:", @HomeDrive)
	If $template_folder > "" Then
		GuiCtrlDelete($template_button)
		GuiCtrlCreateEdit($template_folder, 120, 254, 270, 60, $ES_MULTILINE + $ES_READONLY)

	Else
		MsgBox(0, "", "Template storage not selected")
		Return
	EndIf
EndFunc





Func _PDP_check()
	Global $PDP_state = GuiCtrlRead($PDP_check)
	If $PDP_state = $GUI_CHECKED Then
		Global $PDP_login = GuiCtrlCreateInput("login", 120, 78, 80, 16)
		Global $PDP_passw = GuiCtrlCreateInput("password", 210, 78, 80, 16)
		IniWrite($main_file, "db_select", "PDP", "true")
		GuiCtrlSetState($save_to_ini, $GUI_ENABLE)
		;Global $PDP_ok = GuiCtrlCreateButton("OK", 300, 77, 40, 18)
	ElseIf $PDP_state = $GUI_UNCHECKED Then

		GuiCtrlDelete($PDP_login)
		GuiCtrlDelete($PDP_passw)
		_checkboxes()
		;GuiCtrlDelete($PDP_ok)



	EndIf


EndFunc



Func _IIIS_check()
	Global $IIIS_state = GuiCtrlRead($IIIS_check)
	If $IIIS_state = $GUI_CHECKED Then
		Global $IIIS_login = GuiCtrlCreateInput("login", 120, 98, 80, 16)
		Global $IIIS_passw = GuiCtrlCreateInput("password", 210, 98, 80, 16)
		IniWrite($main_file, "db_select", "IIIS", "true")
		GuiCtrlSetState($save_to_ini, $GUI_ENABLE)
		;Global $IIIS_ok = GuiCtrlCreateButton("OK", 300, 97, 40, 18)
	ElseIf $IIIS_state = $GUI_UNCHECKED Then

		GuiCtrlDelete($IIIS_login)
		GuiCtrlDelete($IIIS_passw)
		_checkboxes()
		;GuiCtrlDelete($IIIS_ok)
	EndIf
EndFunc

Func _CSDD_check()
	Global $CSDD_state = GuiCtrlRead($CSDD_check)
	If $CSDD_state = $GUI_CHECKED Then
		Global $CSDD_login = GuiCtrlCreateInput("login", 120, 118, 80, 16)
		Global $CSDD_passw = GuiCtrlCreateInput("password", 210, 118, 80, 16)
		IniWrite($main_file, "db_select", "CSDD", "true")
		GuiCtrlSetState($save_to_ini, $GUI_ENABLE)
		;Global $CSDD_ok = GuiCtrlCreateButton("OK", 300, 117, 40, 18)
	ElseIf $CSDD_state = $GUI_UNCHECKED Then

		GuiCtrlDelete($CSDD_login)
		GuiCtrlDelete($CSDD_passw)
		_checkboxes()
		;GuiCtrlDelete($CSDD_ok)
	EndIf
EndFunc

Func _PADIS_check()
	Global $PADIS_state = GuiCtrlRead($PADIS_check)
	If $PADIS_state = $GUI_CHECKED Then
		Global $PADIS_login = GuiCtrlCreateInput("login", 120, 138, 80, 16)
		Global $PADIS_passw = GuiCtrlCreateInput("password", 210, 138, 80, 16)
		IniWrite($main_file, "db_select", "PADIS", "true")
		GuiCtrlSetState($save_to_ini, $GUI_ENABLE)
		;Global $PADIS_ok = GuiCtrlCreateButton("OK", 300, 137, 40, 18)
	ElseIf $PADIS_state = $GUI_UNCHECKED Then

		GuiCtrlDelete($PADIS_login)
		GuiCtrlDelete($PADIS_passw)
		_checkboxes()
		;GuiCtrlDelete($PADIS_ok)
	EndIf
EndFunc


Func _Mustangs_check()
	Global $Mustangs_state = GuiCtrlRead($Mustangs_check)
	If $Mustangs_state = $GUI_CHECKED Then
		Global $Mustangs_login = GuiCtrlCreateInput("login", 120, 158, 80, 16)
		Global $Mustangs_passw = GuiCtrlCreateInput("password", 210, 158, 80, 16)
		IniWrite($main_file, "db_select", "Mustangs", "true")
		GuiCtrlSetState($save_to_ini, $GUI_ENABLE)
		;Global $Mustangs_ok = GuiCtrlCreateButton("OK", 300, 157, 40, 18)
	ElseIf $Mustangs_state = $GUI_UNCHECKED Then

		GuiCtrlDelete($Mustangs_login)
		GuiCtrlDelete($Mustangs_passw)
		_checkboxes()
		;GuiCtrlDelete($Mustangs_ok)
	EndIf
EndFunc


Func _NVIS_check()
	Global $NVIS_state = GuiCtrlRead($NVIS_check)
	If $NVIS_state = $GUI_CHECKED Then
		Global $NVIS_login = GuiCtrlCreateInput("login", 120, 178, 80, 16)
		Global $NVIS_passw = GuiCtrlCreateInput("password", 210, 178, 80, 16)
		IniWrite($main_file, "db_select", "NVIS", "true")
		GuiCtrlSetState($save_to_ini, $GUI_ENABLE)
		;Global $NVIS_ok = GuiCtrlCreateButton("OK", 300, 177, 40, 18)
	ElseIf $NVIS_state = $GUI_UNCHECKED Then

		GuiCtrlDelete($NVIS_login)
		GuiCtrlDelete($NVIS_passw)
		_checkboxes()
		;GuiCtrlDelete($NVIS_ok)
	EndIf
EndFunc

Func _SYS_check()
	Global $SYS_state = GuiCtrlRead($SYS_check)
	If $SYS_state = $GUI_CHECKED Then
		Global $SYS_login = GuiCtrlCreateInput("login", 120, 198, 80, 16)
		Global $SYS_passw = GuiCtrlCreateInput("password", 210, 198, 80, 16)
		IniWrite($main_file, "db_select", "SYS2", "true")
		GuiCtrlSetState($save_to_ini, $GUI_ENABLE)
		;Global $SYS_ok = GuiCtrlCreateButton("OK", 300, 197, 40, 18)
	ElseIf $SYS_state = $GUI_UNCHECKED Then

		GuiCtrlDelete($SYS_login)
		GuiCtrlDelete($SYS_passw)
		_checkboxes()
		;GuiCtrlDelete($SYS_ok)
	EndIf
EndFunc

Func _NSYST_check()
	Global $NSYST_state = GuiCtrlRead($NSYST_check)
	If $NSYST_state = $GUI_CHECKED Then
		Global $NSYST_login = GuiCtrlCreateInput("login", 120, 218, 80, 16)
		Global $NSYST_passw = GuiCtrlCreateInput("password", 210, 218, 80, 16)
		IniWrite($main_file, "db_select", "NSYST", "true")
		GuiCtrlSetState($save_to_ini, $GUI_ENABLE)
		;Global $NSYST_ok = GuiCtrlCreateButton("OK", 300, 217, 40, 18)
	ElseIf $NSYST_state = $GUI_UNCHECKED Then

		GuiCtrlDelete($NSYST_login)
		GuiCtrlDelete($NSYST_passw)
		_checkboxes()
		;GuiCtrlDelete($NSYST_ok)
	EndIf
EndFunc




Func _main_panel()


Local $hGui, $OptionsBtn, $OptionsDummy, $OptionsContext, $msg
Local $OptionsExit, $HelpBtn, $HelpDummy, $HelpContext, $HelpAbout

$main_panel = GuiCreate("Version 2.0", 150, 300, "", "", BitOR($WS_SYSMENU, $WS_CAPTION, $WS_POPUPWINDOW, $WS_BORDER, $WS_CLIPSIBLINGS))
GuiSetBkColor(0xffffff)
GuiSetState()






GuiCtrlCreateLabel("Worktime v. 2a", 10, 10)



;main part


$label1 = GuiCtrlCreateLabel("Database:", 10, 50)
Global $combo1 = GuiCtrlCreateCombo("", 10, 80, 100, "", $CBS_DROPDOWNLIST)




Local $var = IniReadSection($instruction, "db_select")
If @error Then
    MsgBox(4096, "", "INI file probably corrupted.")
Else
    For $i = 1 To $var[0][0]
       GuiCtrlSetData(-1, $var[$i][0])
    Next
EndIf



Global $db_btn = GuiCtrlCreateButton(">", 120, 79, 25, 23, $BS_FLAT)
GuiCtrlSetState($db_btn, $GUI_DISABLE)
Local $db_btn_dummy = GuiCtrlCreateDummy()
Local $db_btn_context = GUICtrlCreateContextMenu($db_btn_dummy)
Global $db_open = GuiCtrlCreateMenuItem("Open", $db_btn_context)
Global $db_copy_login = GuiCtrlCreateMenuItem("Copy login", $db_btn_context)
Global $db_copy_passw = GuiCtrlCreateMenuItem("Copy password", $db_btn_context)
GuiCtrlCreateMenuItem("", $db_btn_context)
Global $db_edit_login = GuiCtrlCreateMenuItem("Edit login", $db_btn_context)
Global $db_edit_passw = GuiCtrlCreateMenuItem("Edit password", $db_btn_context)
GuiCtrlCreateMenuItem("", $db_btn_context)
Global $add_db = GuiCtrlCreateMenuItem("Add new DB", $db_btn_context)
Global $edit_db_link = GuiCtrlCreateMenuItem("Edit DB address", $db_btn_context)




$label2 = GuiCtrlCreateLabel("Template:", 10, 110)
$combo2 = GuiCtrlCreateCombo("", 10, 140, 100, "", $CBS_DROPDOWNLIST)
Global $template_btn = GuiCtrlCreateButton(">", 120, 139, 25, 23, $BS_FLAT)
$template_btn_dummy = GuiCtrlCreateDummy()
$template_btn_context = GUICtrlCreateContextMenu($template_btn_dummy)
Global $open_template = GuiCtrlCreateMenuItem("Open", $template_btn_context)
Global $delete_template = GuiCtrlCreateMenuItem("Delete", $template_btn_context)
GuiCtrlCreateMenuItem("", $template_btn_context)
Global $open_folder = GuiCtrlCreateMenuItem("All templates", $template_btn_context)


$label3 = GuiCtrlCreateLabel("Folders:", 10, 170)
Global $combo3 = GuiCtrlCreateCombo("", 10, 200, 100, "", $CBS_DROPDOWNLIST)


Local $var3 = IniReadSection($instruction, "Folders")
If @error Then
    MsgBox(4096, "", "INI file probably corrupted.")
Else


    For $i = 1 To $var3[0][0]
		Global $sFullPath = $var3[$i][1]
		Global $sLastFolder = StringRegExpReplace($sFullPath, "(.+?\\)*(.+?)(\\.*?(?!\\))", "$4")
		GuiCtrlSetData(-1, $sLastFolder)


    Next
EndIf

Global $folders_btn = GuiCtrlCreateButton(">", 120, 199, 25, 23, $BS_FLAT)
$folders_btn_dummy = GuiCtrlCreateDummy()
$folders_btn_context = GUICtrlCreateContextMenu($folders_btn_dummy)
Global $open_personal_folder = GuiCtrlCreateMenuItem("Open", $folders_btn_context)
GuiCtrlCreateMenuItem("", $folders_btn_context)
Global $add_personal_folder = GuiCtrlCreateMenuItem("Add folder", $folders_btn_context)


$worktime_btn = GuiCtrlCreateButton("Worktime", 20, 260, 80)


While 1
		$msg = GUIGetMsg()

		Switch $msg

			Case $GUI_EVENT_CLOSE
				_close()

			Case $combo1
				_db_buttonMenu()

			Case $db_btn
				ShowMenu($main_panel, $msg, $db_btn_context)

			Case $template_btn
				ShowMenu($main_panel, $msg, $template_btn_context)

			Case $folders_btn
				ShowMenu($main_panel, $msg, $folders_btn_context)

			Case $worktime_btn
				OpenWorktime()




			Case $db_open
				_open_db()

			Case $db_copy_login
				_copy_login()

			Case $db_copy_passw
				_copy_passw()

			Case $db_edit_login
				_edit_login()

			Case $db_edit_passw
				_edit_passw()

			Case $edit_db_link()
				_edit_db_link()




			Case $open_folder
				_open_template_folder()








			Case $add_personal_folder
				_add_personal_folder()

			Case $open_personal_folder
				_open_personal_folder()

		EndSwitch

WEnd


EndFunc


Func _db_buttonMenu()

	If $combo1 = "" Then
		GuiCtrlSetState($db_btn, $GUI_DISABLE) ; I am uncertain if second part is really needed.
	Else
		GuiCtrlSetState($db_btn, $GUI_ENABLE)
	EndIf

EndFunc


Func _open_db()
	ShellExecute(IniRead($instruction, "Databases", GuiCtrlRead($combo1) & "_web", ""))
EndFunc


Func _edit_db_link()
	$db_link_inputbox = InputBox("Edit DB address:", "Please enter full database web address, in format http://www.address.com:", IniRead($instruction, "Databases", GuiCtrlRead($combo1) & "_web", ""))
	If $db_link_inputbox > "" Then IniWrite($instruction, "Databases", GuiCtrlRead($combo1) & "_web", $db_link_inputbox)
	If $db_link_inputbox <= " " Then MsgBox(48, "Null address!", "You didnt specified new database web address")


EndFunc

Func _copy_login()


	 ClipPut(IniRead($instruction, "Databases", GuiCtrlRead($combo1) & "_login", ""))

EndFunc

Func _copy_passw()

	 ClipPut(IniRead($instruction, "Databases", GuiCtrlRead($combo1) & "_password", ""))

EndFunc

Func _edit_login()
	Local $inputbox_login = InputBox("Change login", "Type new login for " & GuiCtrlRead($combo1), IniRead($instruction, "Databases", GuiCtrlRead($combo1) & "_login", ""))
	IniWrite($instruction, "Databases", GuiCtrlRead($combo1) & "_login", $inputbox_login)
EndFunc

Func _edit_passw()
	Local $inputbox_passw = InputBox("Change password", "Type new password for " & GuiCtrlRead($combo1), IniRead($instruction, "Databases", GuiCtrlRead($combo1) & "_password", ""))
	IniWrite($instruction, "Databases", GuiCtrlRead($combo1) & "_password", $inputbox_passw)
EndFunc


Func _add_personal_folder()
	$personal_folder = FileSelectFolder("Choose your folder. Please do not move or rename it later." & @CRLF & "Otherwise, the folder could become inaccessible for this program.", @DesktopDir, 1)

	Local $var2 = IniReadSection($instruction, "Folders")

If @error Then
    MsgBox(4096, "", "INI file probably corrupted.")
Else
For $i = $var2[0][0] to $var2[0][0]
	If $var2[$i][0] = 1 And $var2[$i][1] <= "" Then IniWrite($instruction, "Folders", $var2[$i][0], $personal_folder)
	If $var2[$i][0] >= 1 And $var2[$i][1] > "" Then IniWrite($instruction, "Folders", $var2[$i][0]+1, $personal_folder)


Next


EndIf
EndFunc







Func _open_template_folder()

	ShellExecute(IniRead($instruction, "Templates", "folder", ""))


EndFunc


Func _open_personal_folder()
	MsgBox(0, "",  FileGetLongName(GuiCtrlRead($combo3)))
EndFunc





Func _save_to_ini()


	Global $PDP_state = GuiCtrlRead($PDP_check)
	If  $PDP_state = $GUI_CHECKED Then
		IniWrite($main_file, "Databases", "PDP_login", GuiCtrlRead($PDP_login))
		IniWrite($main_file, "Databases", "PDP_password", GuiCtrlRead($PDP_passw))
		IniWrite($main_file, "Databases", "PDP_web", "http://www.pdp.com")

	EndIf

	If $PDP_state = $GUI_UNCHECKED Then Sleep(10)


	Global $IIIS_state = GuiCtrlRead($IIIS_check)
	If $IIIS_state = $GUI_CHECKED Then
		IniWrite($main_file, "Databases", "IIIS_login", GuiCtrlRead($IIIS_login))
		IniWrite($main_file, "Databases", "IIIS_password", GuiCtrlRead($IIIS_passw))
		IniWrite($main_file, "Databases", "IIIS_web", "http://www.iiis.com")
	EndIf

	If $IIIS_state = $GUI_UNCHECKED Then Sleep(10)


	Global $CSDD_state = GuiCtrlRead($CSDD_check)
	If $CSDD_state = $GUI_CHECKED Then
		IniWrite($main_file, "Databases", "CSDD_login", GuiCtrlRead($CSDD_login))
		IniWrite($main_file, "Databases", "CSDD_password", GuiCtrlRead($CSDD_passw))
		IniWrite($main_file, "Databases", "CSDD_web", "http://www.csdd.com")
	EndIf

	If $CSDD_state = $GUI_UNCHECKED Then Sleep(10)



	Global $PADIS_state = GuiCtrlRead($PADIS_check)
	If $PADIS_state = $GUI_CHECKED Then
		IniWrite($main_file, "Databases", "PADIS_login", GuiCtrlRead($PADIS_login))
		IniWrite($main_file, "Databases", "PADIS_password", GuiCtrlRead($PADIS_passw))
		IniWrite($main_file, "Databases", "PADIS_web", "http://www.padis.com")
	EndIf

	If $PADIS_state = $GUI_UNCHECKED Then Sleep(10)



	Global $Mustangs_state = GuiCtrlRead($Mustangs_check)
	If $Mustangs_state = $GUI_CHECKED Then
		IniWrite($main_file, "Databases", "Mustangs_login", GuiCtrlRead($Mustangs_login))
		IniWrite($main_file, "Databases", "Mustangs_password", GuiCtrlRead($Mustangs_passw))
		IniWrite($main_file, "Databases", "Mustangs_web", "http://www.mustangs.com")
	EndIf

	If $Mustangs_state = $GUI_UNCHECKED Then Sleep(10)


	Global $NVIS_state = GuiCtrlRead($NVIS_check)
	If $NVIS_state = $GUI_CHECKED Then
		IniWrite($main_file, "Databases", "NVIS_login", GuiCtrlRead($NVIS_login))
		IniWrite($main_file, "Databases", "NVIS_password", GuiCtrlRead($NVIS_passw))
		IniWrite($main_file, "Databases", "NVIS_web", "http://www.nvis.com")
	EndIf

	If $NVIS_state = $GUI_UNCHECKED Then Sleep(10)


	Global $SYS_state = GUICtrlRead($SYS_check)
	If $SYS_state = $GUI_CHECKED Then
		IniWrite($main_file, "Databases", "SYS2_login", GuiCtrlRead($SYS_login))
		IniWrite($main_file, "Databases", "SYS2_password", GuiCtrlRead($SYS_passw))
		IniWrite($main_file, "Databases", "SYS2_web", "http://www.sys2.com")
	EndIf

	If $SYS_state = $GUI_UNCHECKED Then Sleep(10)


	Global $NSYST_state = GuiCtrlRead($NSYST_check)
	If $NSYST_state = $GUI_CHECKED Then
		IniWrite($main_file, "Databases", "NSYST_login", GuiCtrlRead($NSYST_login))
		IniWrite($main_file, "Databases", "NSYST_password", GuiCtrlRead($NSYST_passw))
		IniWrite($main_file, "Databases", "NSYST_web", "http://www.nsyst.com")
	EndIf

	If $NSYST_state = $GUI_UNCHECKED Then Sleep(10)





	IniWrite($main_file, "Templates", "folder", $template_folder)


GuiDelete($reg_panel)
MsgBox(0, "", "Registration completed, please restart program.")
Exit














EndFunc

Func ShowMenu($hWnd, $CtrlID, $nContextID)
	Local $arPos, $x, $y
	Local $hMenu = GUICtrlGetHandle($nContextID)

	$arPos = ControlGetPos($hWnd, "", $CtrlID)

	$x = $arPos[0]
	$y = $arPos[1] + $arPos[3]

	ClientToScreen($hWnd, $x, $y)
	TrackPopupMenu($hWnd, $hMenu, $x, $y)
EndFunc   ;==>ShowMenu


; Convert the client (GUI) coordinates to screen (desktop) coordinates
Func ClientToScreen($hWnd, ByRef $x, ByRef $y)
	Local $stPoint = DllStructCreate("int;int")

	DllStructSetData($stPoint, 1, $x)
	DllStructSetData($stPoint, 2, $y)

	DllCall("user32.dll", "int", "ClientToScreen", "hwnd", $hWnd, "ptr", DllStructGetPtr($stPoint))

	$x = DllStructGetData($stPoint, 1)
	$y = DllStructGetData($stPoint, 2)
	; release Struct not really needed as it is a local
	$stPoint = 0
EndFunc   ;==>ClientToScreen


; Show at the given coordinates (x, y) the popup menu (hMenu) which belongs to a given GUI window (hWnd)
Func TrackPopupMenu($hWnd, $hMenu, $x, $y)
	DllCall("user32.dll", "int", "TrackPopupMenuEx", "hwnd", $hMenu, "int", 0, "int", $x, "int", $y, "hwnd", $hWnd, "ptr", 0)
EndFunc   ;==>TrackPopupMenu


Func OpenWorktime()
	MsgBox(0, "", "still nothing")
EndFunc

Func _close()
	Exit
EndFunc





While 1

Sleep(10)
WEnd