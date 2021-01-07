;Mcky's CalEntry
;Freeware Calendar Task scheduling program
;Compatible with AutoIT V3 Beta 3.1.1.60
;Tidy the script with AutoIT3 Tidy
Dim $start_del_old, $SAVE_HTML_DOCUMENT, $html_temp1, $html_temp2, $html_temp3, $html_temp4, $html_custom, $html_css_input, $qqq
Dim $html_save_info, $css_load, $css_save, $css_clear, $backup_settings, $backup_comment, $TYPETASK, $TYPEVALUE, $DEFAULT_ALARM
Dim $ALARM_FILE, $open_label, $close_label, $reminder_task, $reminder_edit, $time_hour, $time_mins, $openapp_task
Dim $closeapp_task, $shutdown_task, $shutdown_select, $browse_open_app_button, $browse_close_app_button, $LOAD_WIN, $PRIORITY
Dim $testalarm, $startup, $del_old_check, $priority_normal, $priority_idle, $priority_high, $csv_sep, $html_title_input
Dim $load_date_ini
$ITEMS = IniReadSection($load_date_ini & ".ent", "ITEMS")
If @DesktopWidth < 800 And @DesktopHeight < 600 Then MsgBox(16, "Cannot run in the current resolution", "The minimum resolution required by this program is 800x600.")
$win_check = "cal_2x"
If WinExists($win_check) Then Exit
AutoItWinSetTitle($win_check)

;Var initialization and GUI creation
#include <GUIConstants.au3>
HotKeySet("!{BS}", "OPEN_MAIN")
$ver = 1.6
$build_date = "25 October 2005"
$ori_work = @ScriptDir & "\"
FileChangeDir($ori_work)
$start_parse = 0
$just_write = ""
$SHUTDOWNPC = 0
$backup_location = "A:\"
$open_application = ""
$close_application = ""
$csv_seperator = ","
$html_title = "Mcky's CalEntry Exported Tasks"
AutoItSetOption("TrayMenuMode", 1)
AutoItSetOption("RunErrorsFatal", 0)
AutoItSetOption("GUICloseOnESC", 0)
TraySetToolTip ("Open main configuration screen - ALT+BACKSPACE")

If FileExists("SETTINGS.INI") = 1 Then
	LOADSETNG()
Else
	MsgBox(16, "Missing settings file", "The settings file,SETTINGS.INI is missing. The file will be recreated with the default settings.")
	IniWrite("SETTINGS.INI", "SETTINGS", "LOAD_WIN", "0")
	IniWrite("SETTINGS.INI", "SETTINGS", "DEFAULT_ALARM", "1")
	IniWrite("SETTINGS.INI", "SETTINGS", "ALARM_WAV", "")
	IniWrite("SETTINGS.INI", "SETTINGS", "PRIORITY", "Normal")
	IniWrite("SETTINGS.INI", "SETTINGS", "BACKUP_WIZARD_DEFAULT_MEDIA", "A:\")
	IniWrite("SETTINGS.INI", "SETTINGS", "AUTO_DEL_OLD_TASK", "0")
	IniWrite("SETTINGS.INI", "SETTINGS", "CSV_SEPERATOR", ",")
	IniWrite("SETTINGS.INI", "SETTINGS", "HTML_TITLE", "Mcky's CalEntry Exported Tasks")
	LOADSETNG()
EndIf
If $start_del_old = 1 Then AUTO_OLD_DEL()


;Date Manager section
$main_gui = GUICreate("Mcky's CalEntry", 800, 600, -1, -1, -1, $WS_EX_DLGMODALFRAME)
GUISetFont(9, 800, "", "Verdana")
GUICtrlCreateGroup("Date Manager", 0, 0, 280, 580)
GUICtrlCreateLabel("Please select a date to add new entries:", 2, 16)
$date = GUICtrlCreateDate("", 2, 32, 268, 24, BitOR(0x00, 0x20))
GUICtrlSetTip($date, "Select a date to execute tasks. Right click to go to today's date.")
$newtask = GUICtrlCreateButton("Create a &new task", 5, 90, 128, 96, 0x0001)
$start_stop_parse = GUICtrlCreateButton("Sta&rt", 138, 90, 128, 96)
GUICtrlSetTip($newtask, "After selecting the date above,press this button to set up a new task.")
GUICtrlSetTip($start_stop_parse, "Starts or stops the time parser. When the timing you set for today tasks is reached,the task is executed.")

$file_menu = GUICtrlCreateMenu("&File")
$file_menu_a = GUICtrlCreateMenuItem("Backup/Restore calendar data", $file_menu)
$file_menu_b = GUICtrlCreateMenuItem("Export tasks list to HTML document", $file_menu)
$file_menu_c = GUICtrlCreateMenuItem("Export tasks list to CSV format", $file_menu)
$file_menu_d = GUICtrlCreateMenuItem("Exit", $file_menu)

$options_menu = GUICtrlCreateMenu("&Configuration")
$options_menu_b = GUICtrlCreateMenuItem("Settings", $options_menu)

$about_menu = GUICtrlCreateMenu("&Help")
$about_menu_b = GUICtrlCreateMenuItem("Help", $about_menu)
$about_menu_c = GUICtrlCreateMenuItem("Data File Information", $about_menu)
$about_menu_e = GUICtrlCreateMenuItem("About...", $about_menu)


GUICtrlCreateLabel("Date with tasks assigned:", 2, 188)
$tasks_list = GUICtrlCreateList("", 2, 204, 160, 384)
$today_label = GUICtrlCreateLabel("Today's date is: " & @MON & "-" & @MDAY & "-" & @YEAR, 5, 64, 196, 32)
$today_log = @MDAY
GUICtrlSetTip($tasks_list, "This window will display all dates with tasks set.")
$button_list = GUICtrlCreateButton("Li&st date", 170, 204, 96, 32)
GUICtrlSetTip($button_list, "Click here to display the task's content on the right hand window.")
$today_list = GUICtrlCreateButton("List to&day", 170, 252, 96, 32)
GUICtrlSetTip($today_list, "Click here to display the today's tasks on the right hand window.")
$button_del = GUICtrlCreateButton("Dele&te date", 170, 300, 96, 32)
GUICtrlSetTip($button_del, "Click here to delete this date along with all its tasks.")
$button_all_del = GUICtrlCreateButton("Delete &all", 170, 348, 96, 32)
GUICtrlSetTip($button_all_del, "Click here to delete all listed dates.")
$button_old_del = GUICtrlCreateButton("De&lete old", 170, 396, 96, 32)
GUICtrlSetTip($button_old_del, "Click here to delete dates that are older than today.")
$button_backup = GUICtrlCreateButton("Backu&p data", 170, 444, 96, 32)
GUICtrlSetTip($button_backup, "Click here to backup calendar data to another location.")
$button_html = GUICtrlCreateButton("E&xport HTML", 170, 492, 96, 32)
GUICtrlSetTip($button_html, "Click here to export the tasks list to HTML document format.")
$button_csv = GUICtrlCreateButton("Export CS&V", 170, 540, 96, 32)
GUICtrlSetTip($button_csv, "Click here to export the tasks list to CSV format.")


;Tasks Manager section
GUICtrlCreateGroup("Tasks Manager", 290, 0, 500, 580)
$main_tree = GUICtrlCreateTreeView(300, 48, 480, 480)
GUICtrlSetTip($main_tree, "This window will display all tasks that are configured. Right to on the tasks's timing to delete it.")
GUICtrlSetFont($main_tree, 10, 800)
$button_del_tasks = GUICtrlCreateButton("De&lete task", 320, 540, 84, 32)
GUICtrlSetTip($button_del_tasks, "Click here to delete a task. You must highlight a task first.")
$button_edit_tasks = GUICtrlCreateButton("Ed&it task", 685, 540, 78, 32)
GUICtrlSetTip($button_edit_tasks, "Click here to edit a task. You must highlight a task first.")
GUICtrlCreateLabel("Date Selected:", 300, 24, 320, 24)
$date_label = GUICtrlCreateLabel("", 400, 24, 256, 24)
CREATE_LIST() ;get values of dates with tasks in CALDATA.DAT
GUISetState(@SW_SHOW)
If Not $CmdLine[0] = 0 Then
	If $CmdLine[1] = "-winstart" Then ControlClick("Mcky's CalEntry", "", $start_stop_parse)
EndIf


;Scanning for input
While 1
	$msg = GUIGetMsg()
	If $msg = $file_menu_b Then HTML_EXPORT()
	If $msg = $file_menu_a Then BACKUP_DATA()
	If $msg = $file_menu_c Then CSV_EXPORT()
	If $msg = $button_html Then HTML_EXPORT()
	If $msg = $button_backup Then BACKUP_DATA()
	If $msg = $button_csv Then CSV_EXPORT()
	If $msg = $start_stop_parse Then START_STOP_PARSER()
	If $msg = $tasks_list Then DATE_LIST()
	If $msg = $about_menu_b Then HELP_FILE()
	If $msg = $about_menu_e Then ABOUT()
	If $msg = $about_menu_c Then DATAFILEINFO()
	If $msg = $options_menu_b Then SETTINGS()
	If $msg = $button_list Then DATE_LIST()
	If $msg = $today_list Then TODAY_LIST_TASKS()
	If $msg = $button_del Then BUTTON_DEL()
	If $msg = $button_all_del Then BUTTON_ALL_DEL()
	If $msg = $button_old_del Then BUTTON_OLD_DEL()
	If $msg = $file_menu_d Then Exit
	If $msg = $button_del_tasks Then TASK_DEL()
	If $msg = $button_edit_tasks Then TASK_EDIT()
	If $msg = $newtask Then NEW_TASK()
	If $msg = $GUI_EVENT_CLOSE Then ExitLoop
	If $today_log <> @MDAY Then
		GUICtrlSetData($today_label, "Today's date is: " & @MON & "-" & @MDAY & "-" & @YEAR)
		$today_log = @MDAY
	EndIf
WEnd

;Main functions

Func CSV_EXPORT()
	$ori_work = @ScriptDir & "\"
	GUISetState(@SW_DISABLE)
	Global $SAVE_CSV = FileSaveDialog("Select where to export the CSV", "::{450D8FBA-AD25-11D0-98A8-0800361B1103}", "Comma Seperated Value file (*.CSV)", 18)
	FileChangeDir($ori_work)
	If $SAVE_CSV = "" Then
		GUISetState(@SW_ENABLE)
		WinActivate("Mcky's CalEntry")
		Return
	EndIf
	$POS = StringInStr($SAVE_CSV, ".csv")
	If $POS = 0 Then $SAVE_CSV = $SAVE_CSV & ".csv"
	$firstent = FileFindFirstFile("*.ent")
	If $firstent = -1 Then
		GUISetState(@SW_DISABLE)
		MsgBox(16, "No data", "No calendar data available. Please create some tasks!")
		GUISetState(@SW_ENABLE)
		WinActivate("Mcky's CalEntry")
		Return
	EndIf
	FileOpen($SAVE_CSV, 2)
	Select
		Case	$csv_seperator = "Tab"
		$csv_seperator = @TAB
		Case	$csv_seperator = "Comma"
		$csv_seperator = ","
		Case	$csv_seperator = "SemiColon"
		$csv_seperator = ";"
		Case	$csv_seperator = "Pipe"
		$csv_seperator = "|"
		Case Else
			$csv_seperator = ","
	EndSelect
	$qqq = 1
	While 1
		$data_ext = FileFindNextFile($firstent)
		If @error = 1 Then ExitLoop
		$data_order = IniReadSection($data_ext, "ITEMS")
		$qqq = 1
		While 1
			If UBound($data_order) = 0 Then ExitLoop
			If $qqq >= UBound($data_order) Then
				ExitLoop
			EndIf
			$write_date = StringReplace($data_ext, ".ent", "")
			FileWrite($SAVE_CSV, '"' & $write_date & '"' & $csv_seperator)
			FileWrite($SAVE_CSV, '"' & $data_order[$qqq][1] & '"' & $csv_seperator)
			$qqq = $qqq + 1
			If $qqq >= UBound($data_order) Then
				ExitLoop
			EndIf
			FileWrite($SAVE_CSV, '"' & $data_order[$qqq][1] & '"' & $csv_seperator)
			$qqq = $qqq + 1
			If $qqq >= UBound($data_order) Then
				ExitLoop
			EndIf
			FileWrite($SAVE_CSV, '"' & $data_order[$qqq][1] & '"')
			FileWriteLine($SAVE_CSV, "")
			$qqq = $qqq + 1
			If $qqq >= UBound($data_order) Then
				ExitLoop
			EndIf
		WEnd
	WEnd
	FileClose($SAVE_CSV)
	GUISetState(@SW_DISABLE)
	MsgBox(64, "Successfully exported CSV", "The CSV file has been successfully exported to: " & $SAVE_CSV & ". You can now open it in a database program such as Microsoft Excel or Access.")
	GUISetState(@SW_ENABLE)
	WinActivate("Mcky's CalEntry")
EndFunc   ;==>CSV_EXPORT

Func HTML_EXPORT()
	GUISetState(@SW_DISABLE)
	Global $SAVE_HTML_DOCUMENT = ""
	$html_gui = GUICreate("Export calendar data to HTML", 750, 640, -1, -1, -1, $WS_EX_TOOLWINDOW, $main_gui)
	GUISetFont(8, 800, "", "Verdana")
	GUICtrlCreateGroup("HTML Export", 5, 5, 730, 620)
	$html_save = GUICtrlCreateButton("Export", 8, 500, 84, 32)
	$html_exit = GUICtrlCreateButton("Exit", 8, 580, 84, 32, 0x0001)
	GUICtrlCreateLabel("Choose where to save the HTML file output:", 180, 100, 500, 32)
	$html_browse = GUICtrlCreateButton("Browse...", 180, 138, 84, 32)
	Global $html_save_info = GUICtrlCreateInput("", 288, 140, 400, 24, $ES_READONLY)
	GUICtrlCreateLabel("This will export all of your available date with tasks to HTML webpage format.", 180, 36, 500, 32)
	GUICtrlCreateLabel("Choose the HTML template you want to use:", 180, 192, 500, 32)
	Global $html_temp1 = GUICtrlCreateRadio("White text/Black bkg", 180, 224, 140, 32)
	Global $html_temp2 = GUICtrlCreateRadio("Red text/Yellow bkg", 340, 224, 140, 32)
	Global $html_temp3 = GUICtrlCreateRadio("Green text/Blue bkg", 500, 224, 140, 32)
	Global $html_temp4 = GUICtrlCreateRadio("Aqua text/Maroon bkg", 340, 256, 150, 32)
	Global $html_custom = GUICtrlCreateRadio("Or create your own template using HTML CSS:", 180, 320, 288, 32)
	Global $css_load = GUICtrlCreateButton("Load CalEntry Style File...", 180, 580, 160, 32)
	Global $css_save = GUICtrlCreateButton("Save CalEntry Style File...", 520, 580, 160, 32)
	Global $css_clear = GUICtrlCreateButton("Clear editor...", 384, 580, 96, 32)
	Global $html_css_input = GUICtrlCreateEdit("<!--These elements are used in the resultant HTML document : body,font,hr,h2. Please feel free to edit to your heart's content-->" & @CRLF & "<!--Please see http://www.w3schools.com/css/css_examples.asp for examples on how to use background images and other HTML enhancements.-->" & @CRLF & @CRLF & "<style>" & @CRLF & @CRLF & @CRLF & "body{background-color:black}" & @CRLF & "font{color:white}" & @CRLF & "font{font-size:large}" & @CRLF & "h2{color:gray}" & @CRLF & "hr{}" & @CRLF & @CRLF & @CRLF & "</style>", 180, 360, 500, 212)
	If FileExists(@ScriptDir & "\Res\Ex_html.jpg") = 1 Then GUICtrlCreatePic(@ScriptDir & "\Res\Ex_html.jpg", 8, 32, 164, 400)
	GUICtrlSetState($html_temp1, $GUI_CHECKED)
	GUICtrlSetState($html_css_input, $GUI_DISABLE)
	GUICtrlSetState($css_load, $GUI_DISABLE)
	GUICtrlSetState($css_save, $GUI_DISABLE)
	GUICtrlSetState($css_clear, $GUI_DISABLE)
	GUICtrlSetState($html_save_info, $GUI_DISABLE)
	GUISetState()
	While 1
		$msg = GUIGetMsg()
		If $msg = $GUI_EVENT_CLOSE Or $msg = $html_exit Then
			$msg = ''
			GUIDelete()
			GUISwitch($main_gui)
			GUISetState(@SW_ENABLE)
			WinActivate("Mcky's CalEntry")
			Return
		EndIf
		If $msg = $html_save Then SAVE_FINAL_HTML()
		If $msg = $html_custom Then SELECT_CSS()
		If $msg = $html_browse Then HTML_SELECT_SAVE()
		If $msg = $css_load Then CSF_LOADER()
		If $msg = $css_save Then CSF_SAVER()
		If $msg = $css_clear Then GUICtrlSetData($html_css_input, @CRLF & "<style>" & @CRLF & @CRLF & @CRLF & @CRLF & "</style>")
		If $msg = $html_temp1 Or $msg = $html_temp2 Or $msg = $html_temp3 Or $msg = $html_temp4 Then SELECT_DEF_TEMP()
		
	WEnd
EndFunc   ;==>HTML_EXPORT

Func SAVE_FINAL_HTML()
	GUISetState(@SW_DISABLE)
	If $SAVE_HTML_DOCUMENT = "" Then
		MsgBox(16, "Not saved", "No save location was specified.")
		GUISetState(@SW_ENABLE)
		WinActivate("Mcky's CalEntry")
		Return
	EndIf
	
	;export html code!
	$firstent = FileFindFirstFile("*.ENT")
	If $firstent = -1 Then
		GUISetState(@SW_DISABLE)
		MsgBox(16, "No data", "No calendar data available. Please create some tasks!")
		GUISetState(@SW_ENABLE)
		WinActivate("Mcky's CalEntry")
		Return
	EndIf
	FileOpen($SAVE_HTML_DOCUMENT, 2)
	$ERR = FileWriteLine($SAVE_HTML_DOCUMENT, '<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 3.2//EN">') ;write HTML file
	If $ERR = 0 Then
		GUISetState(@SW_DISABLE)
		MsgBox(16, "Write Failure", "Failed to write the HTML file.")
		GUISetState(@SW_ENABLE)
		WinActivate("Mcky's CalEntry")
		Return
	EndIf
	FileWriteLine($SAVE_HTML_DOCUMENT, "<html>")
	FileWriteLine($SAVE_HTML_DOCUMENT, "<head>")
	FileWriteLine($SAVE_HTML_DOCUMENT, '<meta http-equiv="Content-Type"')
	FileWriteLine($SAVE_HTML_DOCUMENT, 'content="text/html; charset=iso-8859-1">')
	FileWriteLine($SAVE_HTML_DOCUMENT, '<meta name="Generator"' & " " & "Content=""Mcky's CalEntry"">")
	FileWriteLine($SAVE_HTML_DOCUMENT, "<title>" & $html_title & "</title>")
	If GUICtrlRead($html_temp1) = $GUI_CHECKED Then
		FileWriteLine($SAVE_HTML_DOCUMENT, "<style>")
		FileWriteLine($SAVE_HTML_DOCUMENT, "body{background-color:black}")
		FileWriteLine($SAVE_HTML_DOCUMENT, "font{color:white}")
		FileWriteLine($SAVE_HTML_DOCUMENT, "font{font-size:large}")
		FileWriteLine($SAVE_HTML_DOCUMENT, "h2{color:gray}")
		FileWriteLine($SAVE_HTML_DOCUMENT, "hr{}")
		FileWriteLine($SAVE_HTML_DOCUMENT, "</style>")
	EndIf
	If GUICtrlRead($html_temp2) = $GUI_CHECKED Then
		FileWriteLine($SAVE_HTML_DOCUMENT, "<style>")
		FileWriteLine($SAVE_HTML_DOCUMENT, "body{background-color:yellow}")
		FileWriteLine($SAVE_HTML_DOCUMENT, "font{color:red}")
		FileWriteLine($SAVE_HTML_DOCUMENT, "font{font-size:large}")
		FileWriteLine($SAVE_HTML_DOCUMENT, "h2{color:gray}")
		FileWriteLine($SAVE_HTML_DOCUMENT, "hr{}")
		FileWriteLine($SAVE_HTML_DOCUMENT, "</style>")
	EndIf
	If GUICtrlRead($html_temp3) = $GUI_CHECKED Then
		FileWriteLine($SAVE_HTML_DOCUMENT, "<style>")
		FileWriteLine($SAVE_HTML_DOCUMENT, "body{background-color:blue}")
		FileWriteLine($SAVE_HTML_DOCUMENT, "font{color:lime}")
		FileWriteLine($SAVE_HTML_DOCUMENT, "font{font-size:large}")
		FileWriteLine($SAVE_HTML_DOCUMENT, "h2{color:gray}")
		FileWriteLine($SAVE_HTML_DOCUMENT, "hr{}")
		FileWriteLine($SAVE_HTML_DOCUMENT, "</style>")
	EndIf
	If GUICtrlRead($html_temp4) = $GUI_CHECKED Then
		FileWriteLine($SAVE_HTML_DOCUMENT, "<style>")
		FileWriteLine($SAVE_HTML_DOCUMENT, "body{background-color:maroon}")
		FileWriteLine($SAVE_HTML_DOCUMENT, "font{color:aqua}")
		FileWriteLine($SAVE_HTML_DOCUMENT, "font{font-size:large}")
		FileWriteLine($SAVE_HTML_DOCUMENT, "h2{color:gray}")
		FileWriteLine($SAVE_HTML_DOCUMENT, "hr{}")
		FileWriteLine($SAVE_HTML_DOCUMENT, "</style>")
	EndIf
	If GUICtrlRead($html_custom) = $GUI_CHECKED Then
		FileWriteLine($SAVE_HTML_DOCUMENT, GUICtrlRead($html_css_input))
	EndIf
	FileWriteLine($SAVE_HTML_DOCUMENT, "</head>")
	FileWriteLine($SAVE_HTML_DOCUMENT, "<body>")
	FileWriteLine($SAVE_HTML_DOCUMENT, '<A NAME="TOP">')
	FileWriteLine($SAVE_HTML_DOCUMENT, "<font><center><h1><u>Mcky's CalEntry Tasks</u></h1></center><font>")
	
	$qqq = 1
	While 1
		$data_ext = FileFindNextFile($firstent)
		If @error = 1 Then ExitLoop
		$data_order = IniReadSection($data_ext, "ITEMS")
		$qqq = 1
		While 1
			If UBound($data_order) = 0 Then ExitLoop
			If $qqq >= UBound($data_order) Then
				FileWriteLine($SAVE_HTML_DOCUMENT, "<br><hr>")
				ExitLoop
			EndIf
			$write_date = StringReplace($data_ext, ".ent", "")
			If $write_date <> $just_write Then FileWriteLine($SAVE_HTML_DOCUMENT, "<font><h2>Tasks for " & $write_date & ":</h2></font>")
			$just_write = $write_date
			FileWriteLine($SAVE_HTML_DOCUMENT, "<font>Time: " & $data_order[$qqq][1] & "</font><br>")
			$qqq = $qqq + 1
			If $qqq >= UBound($data_order) Then
				FileWriteLine($SAVE_HTML_DOCUMENT, "<hr>")
				ExitLoop
			EndIf
			FileWriteLine($SAVE_HTML_DOCUMENT, "<font>Task: " & $data_order[$qqq][1] & "</font><br>")
			$qqq = $qqq + 1
			If $qqq >= UBound($data_order) Then
				FileWriteLine($SAVE_HTML_DOCUMENT, "<hr>")
				ExitLoop
			EndIf
			FileWriteLine($SAVE_HTML_DOCUMENT, "<font>Parameters: " & $data_order[$qqq][1] & "</font><br><br>")
			$qqq = $qqq + 1
			If $qqq >= UBound($data_order) Then
				FileWriteLine($SAVE_HTML_DOCUMENT, "<hr>")
				ExitLoop
			EndIf
		WEnd
	WEnd
	FileWriteLine($SAVE_HTML_DOCUMENT, '<center><font><A HREF="#TOP">Go to top</A></font></center>')
	FileWriteLine($SAVE_HTML_DOCUMENT, "</body>")
	FileWriteLine($SAVE_HTML_DOCUMENT, "</html>")
	FileClose($SAVE_HTML_DOCUMENT)
	GUISetState(@SW_DISABLE)
	MsgBox(64, "Successfully exported HTML", "The HTML document has been successfully exported to: " & $SAVE_HTML_DOCUMENT)
	GUISetState(@SW_ENABLE)
	WinActivate("Mcky's CalEntry")
EndFunc   ;==>SAVE_FINAL_HTML


Func HTML_SELECT_SAVE()
	$ori_work = @ScriptDir & "\"
	GUISetState(@SW_DISABLE)
	Global $SAVE_HTML_DOCUMENT = FileSaveDialog("Select where to export the HTML file", "::{450D8FBA-AD25-11D0-98A8-0800361B1103}", "HTML Web document (*.HTML)", 18)
	FileChangeDir($ori_work)
	If $SAVE_HTML_DOCUMENT = "" Then
		$SAVE_HTML_DOCUMENT = ""
		GUISetState(@SW_ENABLE)
		WinActivate("Mcky's CalEntry")
		GUICtrlSetData($html_save_info, $SAVE_HTML_DOCUMENT)
	Else
		$POS = StringInStr($SAVE_HTML_DOCUMENT, ".html")
		If $POS = 0 Then $SAVE_HTML_DOCUMENT = $SAVE_HTML_DOCUMENT & ".html"
		GUISetState(@SW_ENABLE)
		WinActivate("Mcky's CalEntry")
		GUICtrlSetData($html_save_info, $SAVE_HTML_DOCUMENT)
	EndIf
EndFunc   ;==>HTML_SELECT_SAVE

Func CSF_LOADER()
	$ori_work = @ScriptDir & "\"
	GUISetState(@SW_DISABLE)
	Global $csf_file = FileOpenDialog("Select a CSF file to load. Max:4KB.", @ScriptDir & "\CSF", "CalEntry Style Files (*.CSF)", 1)
	FileChangeDir($ori_work)
	If $csf_file = "" Then
		GUISetState(@SW_ENABLE)
		WinActivate("Mcky's CalEntry")
	Else
		$csf_data = FileRead($csf_file, 4096)
		GUISetState(@SW_ENABLE)
		WinActivate("Mcky's CalEntry")
		GUICtrlSetData($html_css_input, $csf_data)
	EndIf
EndFunc   ;==>CSF_LOADER

Func CSF_SAVER()
	$ori_work = @ScriptDir & "\"
	GUISetState(@SW_DISABLE)
	Global $SAVE_CSF = FileSaveDialog("Save the CalEntry Style File. Max:4KB.", @ScriptDir & "\CSF", "CalEntry Style Files (*.CSF)", 18)
	FileChangeDir($ori_work)
	If $SAVE_CSF = "" Then
		GUISetState(@SW_ENABLE)
		WinActivate("Mcky's CalEntry")
	Else
		$POS = StringInStr($SAVE_CSF, ".csf")
		If $POS = 0 Then $SAVE_CSF = $SAVE_CSF & ".csf"
		FileOpen($SAVE_CSF, 2)
		FileWrite($SAVE_CSF, GUICtrlRead($html_css_input))
		FileClose($SAVE_CSF)
		GUISetState(@SW_ENABLE)
		WinActivate("Mcky's CalEntry")
	EndIf
EndFunc   ;==>CSF_SAVER

Func SELECT_CSS()
	GUICtrlSetState($html_css_input, $GUI_ENABLE)
	GUICtrlSetState($css_load, $GUI_ENABLE)
	GUICtrlSetState($css_save, $GUI_ENABLE)
	GUICtrlSetState($css_clear, $GUI_ENABLE)
EndFunc   ;==>SELECT_CSS

Func SELECT_DEF_TEMP()
	GUICtrlSetState($html_css_input, $GUI_DISABLE)
	GUICtrlSetState($css_load, $GUI_DISABLE)
	GUICtrlSetState($css_save, $GUI_DISABLE)
	GUICtrlSetState($css_clear, $GUI_DISABLE)
EndFunc   ;==>SELECT_DEF_TEMP


Func BACKUP_DATA()
	GUISetState(@SW_DISABLE)
	$backup_gui = GUICreate("Calendar data backup", 400, 400, -1, -1, -1, $WS_EX_TOOLWINDOW, $main_gui)
	GUISetFont(8, 800, "", "Verdana")
	GUICtrlCreateGroup("Backup/Restore", 5, 5, 380, 380)
	$backup_exit = GUICtrlCreateButton("Exit", 8, 348, 84, 32, 0x0001)
	$backup_start = GUICtrlCreateButton("Backup", 192, 348, 84, 32)
	$backup_restore = GUICtrlCreateButton("Restore", 284, 348, 84, 32)
	GUICtrlCreateLabel("This will help you backup or " & @CRLF & "restore your current calendar" & @CRLF & "data. You can enter a comment" & @CRLF & "for the backup too.", 180, 36, 320, 96)
	GUICtrlCreateLabel("Media location: -Can be specified" & @CRLF & "in settings- ", 180, 128, "", 46)
	GUICtrlCreateLabel($backup_location, 180, 160, 160, 24)
	Global $backup_settings = GUICtrlCreateCheckbox("Backup/Restore configuration", 180, 220, 195, 24)
	GUICtrlSetState($backup_settings, $GUI_CHECKED)
	GUICtrlCreateLabel("Comment for backup:", 180, 284)
	Global $backup_comment = GUICtrlCreateInput("", 180, 320, 160, 24)
	If FileExists(@ScriptDir & "\Res\Cal_backup.jpg") = 1 Then GUICtrlCreatePic(@ScriptDir & "\Res\Cal_backup.jpg", 8, 32, 164, 314)
	GUISetState()
	While 1
		$msg = GUIGetMsg()
		If $msg = $GUI_EVENT_CLOSE Or $msg = $backup_exit Then
			$msg = ''
			GUIDelete()
			GUISwitch($main_gui)
			GUISetState(@SW_ENABLE)
			WinActivate("Mcky's CalEntry")
			Return
		EndIf
		If $msg = $backup_start Then START_BACKUP()
		If $msg = $backup_restore Then RES_BACKUP()
	WEnd
EndFunc   ;==>BACKUP_DATA

Func START_BACKUP()
	GUISetState(@SW_DISABLE)
	If MsgBox(36, "Confirm backup?", "Confirm start the backup process? Any old calendar data files currently on the media will be lost.") = 7 Then
		GUISetState(@SW_ENABLE)
		WinActivate("Mcky's CalEntry")
		Return
	EndIf
	GUISetState(@SW_ENABLE)
	If FileExists($backup_location) = 0 Or DriveGetType($backup_location) = "CDROM" Then
		GUISetState(@SW_DISABLE)
		MsgBox(16, "Invalid backup location", "The backup location doesn't exist or cannot be written to.")
		GUISetState(@SW_ENABLE)
		WinActivate("Calendar data backup")
		Return
	EndIf
	If FileCopy(@ScriptDir & "\CALDATA.DAT", $backup_location, 1) = 0 Then
		GUISetState(@SW_DISABLE)
		MsgBox(16, "No calendar data", "Nothing to backup.")
		GUISetState(@SW_ENABLE)
		WinActivate("Calendar data backup")
		Return
	EndIf
	FileCopy(@ScriptDir & "\*.ENT", $backup_location, 1)
	If GUICtrlRead($backup_settings) = $GUI_CHECKED Then FileCopy(@ScriptDir & "\SETTINGS.INI", $backup_location, 1)
	IniWrite($backup_location & "\CALDATA.DAT", "COMMENTS", "COMMENT", GUICtrlRead($backup_comment))
	GUISetState(@SW_DISABLE)
	MsgBox(64, "Successfully performed a backup", "The backup was saved to: " & $backup_location & "." & @CRLF & "Comment: " & GUICtrlRead($backup_comment))
	GUISetState(@SW_ENABLE)
	WinActivate("Calendar data backup")
EndFunc   ;==>START_BACKUP


Func RES_BACKUP()
	GUISetState(@SW_DISABLE)
	If MsgBox(36, "Confirm restore?", "Confirm restore calendar data files from the selected media? Current calendar data will be lost.") = 7 Then
		GUISetState(@SW_ENABLE)
		WinActivate("Mcky's CalEntry")
		Return
	EndIf
	GUISetState(@SW_ENABLE)
	If FileExists($backup_location) = 0 Or DriveGetType($backup_location) = "CDROM" Then
		GUISetState(@SW_DISABLE)
		MsgBox(16, "Invalid backup location", "The backup location doesn't exist or cannot be read from.")
		GUISetState(@SW_ENABLE)
		WinActivate("Calendar data backup")
		Return
	EndIf
	If FileCopy($backup_location & "\CALDATA.DAT", @ScriptDir & "\", 1) = 0 Then
		GUISetState(@SW_DISABLE)
		MsgBox(16, "No calendar data", "Nothing to restore.")
		GUISetState(@SW_ENABLE)
		WinActivate("Calendar data backup")
		Return
	EndIf
	FileCopy($backup_location & "\*.ENT", @ScriptDir & "\", 1)
	If GUICtrlRead($backup_settings) = $GUI_CHECKED Then FileCopy($backup_location & "\SETTINGS.INI", @ScriptDir & "\", 1)
	$prev_com = IniRead(@ScriptDir & "\CALDATA.DAT", "COMMENTS", "COMMENT", "")
	GUISetState(@SW_DISABLE)
	MsgBox(64, "Successfully restored from a backup", "Successfully restored a backup from " & $backup_location & "." & @CRLF & "Previous backup comment: " & $prev_com)
	MsgBox(48, "Must restart program", "You will have to restart CalEntry in order for the changes to take effect.")
	Exit
EndFunc   ;==>RES_BACKUP



Func OPEN_MAIN()
	If $start_parse = 0 Then Return
	$start_parse = 0
EndFunc   ;==>OPEN_MAIN


Func START_STOP_PARSER()
	GUISetState(@SW_DISABLE)
	GUISetState(@SW_HIDE)
	$parse_dates = IniReadSection("CALDATA.DAT", "CALDATA")
	If @error = 1 Or @error = 2 Then
		MsgBox(16, "No data", "No calendar data available. Please create some tasks!")
		GUISetState(@SW_ENABLE)
		GUISetState(@SW_SHOW)
		Return
	EndIf
	$start_parse = 1
	$qqq = 1
	While 1
		Sleep(50)
		If $start_parse = 0 Then
			DATE_LIST()
			GUISetState(@SW_ENABLE)
			GUISetState(@SW_SHOW)
			Return
		EndIf
		$POS = 0
		$POS = StringSplit($parse_dates[$qqq][0], "-")
		If StringLen($POS[1]) = 1 Then $POS[1] = 0 & $POS[1]
		If StringLen($POS[2]) = 1 Then $POS[2] = 0 & $POS[2]
		If $POS[3] = @YEAR And $POS[1] = @MON And $POS[2] = @MDAY Then
			$rrr = 1
			While 1
				Sleep(50)
				If $start_parse = 0 Then
					DATE_LIST()
					GUISetState(@SW_ENABLE)
					GUISetState(@SW_SHOW)
					Return
				EndIf
				If $POS[3] <> @YEAR Or $POS[1] <> @MON Or $POS[2] <> @MDAY Then START_STOP_PARSER()
				$cmpre_time = IniRead($POS[1] & "-" & $POS[2] & "-" & $POS[3] & ".ENT", "ITEMS", "TIME" & $rrr, "NOTAVAIL")
				If $cmpre_time = "NOTAVAIL" Then
					$rrr = 1
				Else
					$cmpre_split = StringSplit($cmpre_time, ":")
					If $cmpre_split[1] = @HOUR And $cmpre_split[2] = @MIN Then ;THEN DELETE THE TASK.
						Global $TYPETASK = IniRead($POS[1] & "-" & $POS[2] & "-" & $POS[3] & ".ENT", "ITEMS", "TASK" & $rrr, "NOTAVAIL")
						Global $TYPEVALUE = IniRead($POS[1] & "-" & $POS[2] & "-" & $POS[3] & ".ENT", "ITEMS", "VALUE" & $rrr, "NOTAVAIL")
						PERFORM_TASK()
						If $TYPETASK = "NOTAVAIL" Or $TYPEVALUE = "NOTAVAIL" Then
						Else
							IniDelete($POS[1] & "-" & $POS[2] & "-" & $POS[3] & ".ENT", "ITEMS", "TIME" & $rrr)
							IniDelete($POS[1] & "-" & $POS[2] & "-" & $POS[3] & ".ENT", "ITEMS", "TASK" & $rrr)
							IniDelete($POS[1] & "-" & $POS[2] & "-" & $POS[3] & ".ENT", "ITEMS", "VALUE" & $rrr)
							$qqq = 1
							$rrr = 1
							$fillempty = IniReadSection($POS[1] & "-" & $POS[2] & "-" & $POS[3] & ".ENT", "ITEMS")
							IniDelete($POS[1] & "-" & $POS[2] & "-" & $POS[3] & ".ENT", "ITEMS")
							If Not UBound($fillempty) = 0 Then
								While 1 ;make all items in order from 1
									IniWrite($POS[1] & "-" & $POS[2] & "-" & $POS[3] & ".ENT", "ITEMS", "TIME" & $rrr, $fillempty[$qqq][1])
									$qqq = $qqq + 1
									If $qqq >= UBound($fillempty) Then ExitLoop
									IniWrite($POS[1] & "-" & $POS[2] & "-" & $POS[3] & ".ENT", "ITEMS", "TASK" & $rrr, $fillempty[$qqq][1])
									$qqq = $qqq + 1
									If $qqq >= UBound($fillempty) Then ExitLoop
									IniWrite($POS[1] & "-" & $POS[2] & "-" & $POS[3] & ".ENT", "ITEMS", "VALUE" & $rrr, $fillempty[$qqq][1])
									$qqq = $qqq + 1
									If $qqq >= UBound($fillempty) Then ExitLoop
									$rrr = $rrr + 1
									If $qqq >= UBound($fillempty) Or $qqq >= UBound($fillempty) Then ExitLoop
								WEnd
								
							EndIf
						EndIf
					EndIf
					If $SHUTDOWNPC = 1 Then
						Shutdown(6)
						Exit
					EndIf
					If $SHUTDOWNPC = 2 Then
						Shutdown(0)
						Exit
					EndIf
					If $SHUTDOWNPC = 3 Then
						Shutdown(13)
						Exit
					EndIf
					$rrr = $rrr + 1
				EndIf
			WEnd
		EndIf
		$qqq = $qqq + 1
		If $qqq >= UBound($parse_dates) Then $qqq = 1
	WEnd
EndFunc   ;==>START_STOP_PARSER


Func PERFORM_TASK()
	If $TYPETASK = "NOTAVAIL" Or $TYPEVALUE = "NOTAVAIL" Then Return
	If $TYPETASK = "Reminder" Then
		If $DEFAULT_ALARM = 1 Then
			If FileExists($ALARM_FILE) = 1 Then SoundPlay($ALARM_FILE)
		EndIf
		MsgBox(64, "Reminder", $TYPEVALUE)
	EndIf
	If $TYPETASK = "Open Application" Then
		If $DEFAULT_ALARM = 1 Then
			If FileExists($ALARM_FILE) = 1 Then SoundPlay($ALARM_FILE)
		EndIf
		If FileExists($TYPEVALUE) = 1 Then Run($TYPEVALUE)
	EndIf
	If $TYPETASK = "Close Application" Then
		If $DEFAULT_ALARM = 1 Then
			If FileExists($ALARM_FILE) = 1 Then SoundPlay($ALARM_FILE)
		EndIf
		$getexe = StringInStr($TYPEVALUE, "\", 0, -1)
		$exepos = StringTrimLeft($TYPEVALUE, $getexe)
		ProcessClose($exepos)
	EndIf
	If $TYPETASK = "Shutdown" Then
		If $DEFAULT_ALARM = 1 Then
			If FileExists($ALARM_FILE) = 1 Then SoundPlay($ALARM_FILE)
		EndIf
		If $TYPEVALUE = "Restart" Then  ;Log Off;Shutdown
			$SHUTDOWNPC = 1
		EndIf
		If $TYPEVALUE = "Log Off" Then  ;Log Off;Shutdown
			$SHUTDOWNPC = 2
		EndIf
		If $TYPEVALUE = "Shutdown" Then  ;Log Off;Shutdown
			$SHUTDOWNPC = 3
		EndIf
	EndIf
EndFunc   ;==>PERFORM_TASK








Func HELP_FILE()
	If FileExists(@WindowsDir & "\HH.EXE") = 1 Or FileExists(@SystemDir & "\HH.EXE") = 1 And FileExists(@ScriptDir & "\HELPME.CHM") = 1 Then
		If WinExists("Mcky's CalEntry Help") = 1 Then Return
		Run(@WindowsDir & "\HH.EXE " & @ScriptDir & "\HELPME.CHM", "", @SW_MAXIMIZE)
	Else
		GUISetState(@SW_DISABLE)
		MsgBox(16, "Help file failure", "The help file failed to open either because it is missing or the HTML help core engine is not installed.")
		GUISetState(@SW_ENABLE)
		WinActivate("Mcky's CalEntry")
	EndIf
EndFunc   ;==>HELP_FILE

Func ABOUT()
	GUISetState(@SW_DISABLE)
	GUICreate("About Mcky's CalEntry...", 419, 352, -1, -1, -1, $WS_EX_TOOLWINDOW, $main_gui)
	GUICtrlCreateGroup("", 5, 5, 412, 346)
	GUISetFont(9, 800, "", "Verdana")
	$heading = GUICtrlCreateLabel("Mcky's Cal Entry", 16, 32, 250, 64)
	GUICtrlSetFont($heading, 14, 800, "", "Verdana")
	If FileExists(@ScriptDir & "\Res\About.jpg") = 1 Then GUICtrlCreatePic(@ScriptDir & "\Res\About.jpg", 240, 32, 142, 71)
	GUICtrlCreateLabel("Version: " & $ver, 16, 72)
	GUICtrlCreateLabel("Build date: " & $build_date, 16, 96)
	$abt_exit = GUICtrlCreateButton("OK", 172, 320, 75, 23, 0x0001)
	GUICtrlCreateLabel("Mcky's CalEntry is a freeware 32-Bit task scheduling", 16, 128, 410, 16)
	GUICtrlCreateLabel("program for Windows 95,98,ME,NT,2000,XP,2003.", 16, 140, 410, 16)
	GUICtrlCreateLabel("It was created using the fantastic scripting tool,AutoIT3", 16, 184, 410, 16)
	GUICtrlCreateLabel("available at www.hiddensoft.com. AutoIT3 is freeware.", 16, 196, 410, 16)
	GUICtrlCreateLabel("Can be used for commercial or non-commercial purposes.", 16, 208, 410, 16)
	GUICtrlCreateLabel("Source script can be requested by e-mail.", 16, 220, 410, 16)
	GUICtrlCreateLabel("I shall not be liable of any damages it may cause to your", 16, 232, 410, 16)
	GUICtrlCreateLabel("computer,but I have thorughly tested it and it was working", 16, 246, 410, 16)
	GUICtrlCreateLabel("without problems. Please report your bug-reports to me by", 16, 258, 410, 16)
	GUICtrlCreateLabel("e-mail. And finally,enjoy using CalEntry.", 16, 270, 410, 16)
	$mem_left = MemGetStats()
	GUICtrlCreateLabel("Physical memory (RAM) left: " & Round($mem_left[2] / 1024) & " MB", 16, 296, 410, 16)
	GUISetState()
	While 1
		$msg = GUIGetMsg()
		If $msg = $GUI_EVENT_CLOSE Then ExitLoop
		If $msg = $abt_exit Then ExitLoop
	WEnd
	$msg = ''
	GUIDelete()
	GUISwitch($main_gui)
	GUISetState(@SW_ENABLE)
	GUISetState()
EndFunc   ;==>ABOUT


Func DATAFILEINFO()
	GUISetState(@SW_DISABLE)
	$entsize = 0
	If FileExists("CALDATA.DAT") = 1 Then
		$entsize = FileGetSize("CALDATA.DAT")
		$entcom = IniRead("CALDATA.DAT", "COMMENTS", "COMMENT", "")
		$entnum = IniReadSection("CALDATA.DAT", "CALDATA")
		$dent = UBound($entnum) - 1
		If $dent < 0 Then $dent = 0
	EndIf
	$firstent = FileFindFirstFile("*.ent")
	If $firstent = -1 Then
		GUISetState(@SW_DISABLE)
		MsgBox(16, "No data", "No calendar data available. Please create some tasks!")
		GUISetState(@SW_ENABLE)
		WinActivate("Mcky's CalEntry")
		Return
	EndIf
	While 1
		$entfilename = FileFindNextFile($firstent)
		If @error = 1 Then ExitLoop
		$entsize = $entsize + FileGetSize($entfilename)
	WEnd
	FileClose($firstent)
	MsgBox(64, "Calendar data file information", "Number of date entries: " & $dent & @CRLF & @CRLF & "Total Calendar data file size: " & Round($entsize / 1024, 2) & " KB" & @CRLF & @CRLF & "Previous backup comment: " & $entcom)
	GUISetState(@SW_ENABLE)
	WinActivate("Mcky's CalEntry")
EndFunc   ;==>DATAFILEINFO


Func CREATE_TREE()
	GUICtrlDelete($main_tree)
	$main_tree = GUICtrlCreateTreeView(300, 48, 480, 480)
	GUICtrlSetFont($main_tree, 10, 800)
EndFunc   ;==>CREATE_TREE


Func CREATE_LIST()
	CHECK_CALDATA()
	$date_tasks = IniReadSection(@ScriptDir & "\CALDATA.DAT", "CALDATA")
	If @error Then
	Else
		For $i = 1 To $date_tasks[0][0]
			GUICtrlSetData($tasks_list, $date_tasks[$i][0], $date_tasks[$i][0])
		Next
	EndIf
EndFunc   ;==>CREATE_LIST


Func DATE_LIST()
	If GUICtrlRead($tasks_list) = 0 Then Return
	CREATE_TREE()
	GUICtrlSetData($date_label, "")
	$load_date_ini = GUICtrlRead($tasks_list)
	If FileExists($load_date_ini & ".ent") = 0 Then
		GUISetState(@SW_DISABLE)
		MsgBox(16, "Entry file missing", "The entry file for this date is missing. Cannot load data.")
		GUISetState(@SW_ENABLE)
		WinActivate("Mcky's CalEntry")
		Return
	EndIf
	GUICtrlSetData($date_label, GUICtrlRead($tasks_list))
	If @error = 1 Or @error = 2 Then Return
	Global $qqq = 1
	While 1
		$start_tree = GUICtrlCreateTreeViewItem($ITEMS[$qqq][1], $main_tree)
		$sub_tree = GUICtrlCreateTreeViewItem($ITEMS[$qqq + 1][1], $start_tree)
		GUICtrlCreateTreeViewItem($ITEMS[$qqq + 2][1], $sub_tree)
		GUICtrlSetState($start_tree, $GUI_EXPAND)
		GUICtrlSetState($sub_tree, $GUI_EXPAND)
		$qqq = $qqq + 3
		If $qqq >= UBound($ITEMS) Then ExitLoop
	WEnd
EndFunc   ;==>DATE_LIST


Func TODAY_LIST_TASKS()
	If GUICtrlRead($tasks_list) = 0 Then Return
	If FileExists(@MON & "-" & @MDAY & "-" & @YEAR & ".ENT") = 1 Then
		GUICtrlSetData($tasks_list, @MON & "-" & @MDAY & "-" & @YEAR)
		DATE_LIST()
	EndIf
EndFunc   ;==>TODAY_LIST_TASKS



Func BUTTON_DEL()
	If GUICtrlRead($tasks_list) = 0 Then Return
	GUISetState(@SW_DISABLE)
	If MsgBox(292, "Really rid this date of all tasks?", "Really rid this date, " & GUICtrlRead($tasks_list) & " of all tasks? This action cannot be undone.") = 7 Then
		GUISetState(@SW_ENABLE)
		WinActivate("Mcky's CalEntry")
		Return
	EndIf
	FileDelete(@ScriptDir & "\" & GUICtrlRead($tasks_list) & ".ent")
	IniDelete(@ScriptDir & "\CALDATA.DAT", "CALDATA", GUICtrlRead($tasks_list))
	CREATE_TREE()
	GUICtrlSetData($tasks_list, "")
	CREATE_LIST()
	GUICtrlSetData($date_label, "")
	GUISetState(@SW_ENABLE)
	WinActivate("Mcky's CalEntry")
EndFunc   ;==>BUTTON_DEL



Func BUTTON_ALL_DEL()
	If GUICtrlRead($tasks_list) = 0 Then Return
	GUISetState(@SW_DISABLE)
	If MsgBox(292, "Really rid ALL dates of tasks?", "Really rid All dates of tasks? This action cannot be undone.") = 7 Then
		GUISetState(@SW_ENABLE)
		WinActivate("Mcky's CalEntry")
		Return
	EndIf
	FileDelete("*.ent")
	FileDelete("CALDATA.DAT")
	$new_dat = FileOpen("CALDATA.DAT", 2)
	FileWriteLine($new_dat, "#MASTER_DATA")
	FileWriteLine($new_dat, "[CALDATA]")
	FileClose($new_dat)
	CREATE_TREE()
	GUICtrlSetData($tasks_list, "")
	CREATE_LIST()
	GUICtrlSetData($date_label, "")
	GUISetState(@SW_ENABLE)
	WinActivate("Mcky's CalEntry")
EndFunc   ;==>BUTTON_ALL_DEL

Func BUTTON_OLD_DEL()
	If GUICtrlRead($tasks_list) = 0 Then Return
	GUISetState(@SW_DISABLE)
	If MsgBox(292, "Really rid all tasks in date which is older than today?", "Really rid all tasks in date which is older than today? This action cannot be undone.") = 7 Then
		GUISetState(@SW_ENABLE)
		WinActivate("Mcky's CalEntry")
		Return
	EndIf
	$find_old = IniReadSection("CALDATA.DAT", "CALDATA")
	If @error = 1 Or @error = 2 Then
		GUISetState(@SW_ENABLE)
		WinActivate("Mcky's CalEntry")
		Return
	EndIf
	
	$qqq = 1
	While 1
		$POS = 0
		$POS = StringSplit($find_old[$qqq][0], "-")
		If @error = 1 Then
			GUISetState(@SW_ENABLE)
			WinActivate("Mcky's CalEntry")
			Return
		EndIf
		If StringLen($POS[1]) = 1 Then $POS[1] = 0 & $POS[1]
		If StringLen($POS[2]) = 1 Then $POS[2] = 0 & $POS[2]
		If $POS[3] < @YEAR Then
			FileDelete(@ScriptDir & "\" & $find_old[$qqq][1])
			IniDelete(@ScriptDir & "\CALDATA.DAT", "CALDATA", $find_old[$qqq][0])
		EndIf
		If $POS[3] <= @YEAR And $POS[1] = @MON And $POS[2] < @MDAY Then
			FileDelete(@ScriptDir & "\" & $find_old[$qqq][1])
			IniDelete(@ScriptDir & "\CALDATA.DAT", "CALDATA", $find_old[$qqq][0])
		EndIf
		If $POS[3] <= @YEAR And $POS[1] < @MON Then ;And $pos[2] < @MDAY Then
			FileDelete(@ScriptDir & "\" & $find_old[$qqq][1])
			IniDelete(@ScriptDir & "\CALDATA.DAT", "CALDATA", $find_old[$qqq][0])
		EndIf
		If $POS[3] <= @YEAR And $POS[1] = @MON And $POS[2] < @MDAY Then
			FileDelete(@ScriptDir & "\" & $find_old[$qqq][1])
			IniDelete(@ScriptDir & "\CALDATA.DAT", "CALDATA", $find_old[$qqq][0])
		EndIf
		$qqq = $qqq + 1
		If $qqq >= UBound($find_old) Then ExitLoop
	WEnd
	MsgBox(64, "Deleted all tasks", "Deleted all tasks that are older than today.")
	CREATE_TREE()
	GUICtrlSetData($tasks_list, "")
	CREATE_LIST()
	GUICtrlSetData($date_label, "")
	GUISetState(@SW_ENABLE)
	WinActivate("Mcky's CalEntry")
EndFunc   ;==>BUTTON_OLD_DEL

Func AUTO_OLD_DEL()
	$find_old = IniReadSection("CALDATA.DAT", "CALDATA")
	If @error = 1 Or @error = 2 Then Return
	$qqq = 1
	While 1
		$POS = 0
		$POS = StringSplit($find_old[$qqq][0], "-")
		If @error = 1 Then Return
		If StringLen($POS[1]) = 1 Then $POS[1] = 0 & $POS[1]
		If StringLen($POS[2]) = 1 Then $POS[2] = 0 & $POS[2]
		If $POS[3] < @YEAR Then
			FileDelete(@ScriptDir & "\" & $find_old[$qqq][1])
			IniDelete(@ScriptDir & "\CALDATA.DAT", "CALDATA", $find_old[$qqq][0])
		EndIf
		If $POS[3] <= @YEAR And $POS[1] = @MON And $POS[2] < @MDAY Then
			FileDelete(@ScriptDir & "\" & $find_old[$qqq][1])
			IniDelete(@ScriptDir & "\CALDATA.DAT", "CALDATA", $find_old[$qqq][0])
		EndIf
		If $POS[3] <= @YEAR And $POS[1] < @MON Then
			FileDelete(@ScriptDir & "\" & $find_old[$qqq][1])
			IniDelete(@ScriptDir & "\CALDATA.DAT", "CALDATA", $find_old[$qqq][0])
		EndIf
		If $POS[3] <= @YEAR And $POS[1] = @MON And $POS[2] < @MDAY Then
			FileDelete(@ScriptDir & "\" & $find_old[$qqq][1])
			IniDelete(@ScriptDir & "\CALDATA.DAT", "CALDATA", $find_old[$qqq][0])
		EndIf
		$qqq = $qqq + 1
		If $qqq >= UBound($find_old) Then ExitLoop
	WEnd
EndFunc   ;==>AUTO_OLD_DEL






Func TASK_DEL()
	If GUICtrlRead($main_tree) = 0 Then
		GUISetState(@SW_DISABLE)
		MsgBox(32, "No tasks to delete.", "Select a date to view tasks in the Date Manager pane or you can create a new task.")
		GUISetState(@SW_ENABLE)
		WinActivate("Mcky's CalEntry")
		Return
	EndIf
	$qqq = 1
	$rrr = 1
	$adv_tree = GUICtrlRead($main_tree, 1)
	While 1
		If $adv_tree[0] = $ITEMS[$qqq][1] Then
			$result = "pass"
			ExitLoop
		EndIf
		If $qqq >= UBound($ITEMS) Then
			$result = "fail"
			ExitLoop
		EndIf
		$qqq = $qqq + 3
		$rrr = $rrr + 1
		If $qqq >= UBound($ITEMS) Then
			$result = "fail"
			ExitLoop
		EndIf
	WEnd
	If $result = "pass" Then
		GUISetState(@SW_DISABLE) ;use the code below for edit module
		If MsgBox(292, "Really delete?", "Confirm delete the selected task?") = 6 Then
			If FileExists(GUICtrlRead($tasks_list) & ".ent") = 0 Then
				MsgBox(16, "Missing tasks entry", "The file that contains information for this date is missing. You will have to delete the date on the date manager.")
				GUISetState(@SW_ENABLE)
				WinActivate("Mcky's CalEntry")
				Return
			EndIf
			$read_del_ini = IniReadSection(GUICtrlRead($tasks_list) & ".ent", "ITEMS")
			$qqq = 1
			While 1
				$read_del = IniRead(GUICtrlRead($tasks_list) & ".ent", "ITEMS", "TIME" & $qqq, "")
				If $read_del = $adv_tree[0] Then ExitLoop
				$qqq = $qqq + 1
			WEnd
			IniDelete(GUICtrlRead($tasks_list) & ".ent", "ITEMS", "TIME" & $qqq)
			IniDelete(GUICtrlRead($tasks_list) & ".ent", "ITEMS", "TASK" & $qqq)
			IniDelete(GUICtrlRead($tasks_list) & ".ent", "ITEMS", "VALUE" & $qqq)
			
			
			$qqq = 1
			$rrr = 1
			$fillempty = IniReadSection(GUICtrlRead($tasks_list) & ".ent", "ITEMS")
			IniDelete(GUICtrlRead($tasks_list) & ".ent", "ITEMS")
			If UBound($fillempty) = 0 Then
				GUICtrlDelete(GUICtrlRead($main_tree))
				GUISetState(@SW_ENABLE)
				WinActivate("Mcky's CalEntry")
				Return
			EndIf
			While 1 ;make all items in order from 1
				IniWrite(GUICtrlRead($tasks_list) & ".ent", "ITEMS", "TIME" & $rrr, $fillempty[$qqq][1])
				$qqq = $qqq + 1
				If $qqq >= UBound($fillempty) Then ExitLoop
				IniWrite(GUICtrlRead($tasks_list) & ".ent", "ITEMS", "TASK" & $rrr, $fillempty[$qqq][1])
				$qqq = $qqq + 1
				If $qqq >= UBound($fillempty) Then ExitLoop
				IniWrite(GUICtrlRead($tasks_list) & ".ent", "ITEMS", "VALUE" & $rrr, $fillempty[$qqq][1])
				$qqq = $qqq + 1
				If $qqq >= UBound($fillempty) Then ExitLoop
				$rrr = $rrr + 1
				If $qqq >= UBound($fillempty) Or $qqq >= UBound($fillempty) Then ExitLoop
			WEnd
			GUICtrlDelete(GUICtrlRead($main_tree))
		EndIf
	Else
		GUISetState(@SW_DISABLE)
		MsgBox(16, "Please click on a timing", "You must select the timing to perform editing or deleting of tasks.")
	EndIf
	GUISetState(@SW_ENABLE)
	WinActivate("Mcky's CalEntry")
EndFunc   ;==>TASK_DEL



Func TASK_EDIT()
	If GUICtrlRead($main_tree) = 0 Then
		GUISetState(@SW_DISABLE)
		MsgBox(32, "No tasks to edit.", "Select a date to view tasks in the Date Manager pane or you can create a new task.")
		GUISetState(@SW_ENABLE)
		WinActivate("Mcky's CalEntry")
		Return
	EndIf
	$qqq = 1
	$rrr = 1
	$adv_tree = GUICtrlRead($main_tree, 1)
	While 1
		If $adv_tree[0] = $ITEMS[$qqq][1] Then
			$result = "pass"
			ExitLoop
		EndIf
		If $qqq >= UBound($ITEMS) Then
			$result = "fail"
			ExitLoop
		EndIf
		$qqq = $qqq + 3
		$rrr = $rrr + 1
		If $qqq >= UBound($ITEMS) Then
			$result = "fail"
			ExitLoop
		EndIf
	WEnd
	If $result = "pass" Then
		GUISetState(@SW_DISABLE)
		$read_del_ini = IniReadSection(GUICtrlRead($tasks_list) & ".ent", "ITEMS")
		$qqq = 1
		While 1
			$read_del = IniRead(GUICtrlRead($tasks_list) & ".ent", "ITEMS", "TIME" & $qqq, "")
			If $read_del = $adv_tree[0] Then ExitLoop
			$qqq = $qqq + 1
		WEnd
		
		Global $task_num_val = $qqq
		Global $edit_time = IniRead(GUICtrlRead($tasks_list) & ".ent", "ITEMS", "TIME" & $qqq, "")
		Global $edit_task = IniRead(GUICtrlRead($tasks_list) & ".ent", "ITEMS", "TASK" & $qqq, "")
		Global $edit_value = IniRead(GUICtrlRead($tasks_list) & ".ent", "ITEMS", "VALUE" & $qqq, "")
		$edit_task = InputBox("Change task type", "Change the task type. Enter one of these values: Reminder,Open Application,Close Application,Shutdown. Invalid input will default to 'Reminder' You must use the proper case as shown.", $edit_task, " M17")
		If @error = 1 Then
			GUISetState(@SW_ENABLE)
			WinActivate("Mcky's CalEntry")
			Return
		EndIf
		If $edit_task <> "Reminder" And $edit_task <> "Open Application" And $edit_task <> "Close Application" And $edit_task <> "Shutdown" Then $edit_task = "Reminder"
		Select
			Case $edit_task = "Reminder"
				$edit_value = InputBox("Reminder task", "Change the reminder to:", "Reminder text")
				If @error = 1 Then
					GUISetState(@SW_ENABLE)
					WinActivate("Mcky's CalEntry")
					Return
				EndIf
			Case $edit_task = "Open Application"
				$ori_work = @ScriptDir & "\"
				$edit_value = FileOpenDialog("Run a program:", "::{450D8FBA-AD25-11D0-98A8-0800361B1103}", "Applications(*.exe;*.com;*.bat;*.cmd;*.pif;*.scr)", 1)
				FileChangeDir($ori_work)
				If @error = 1 Then
					GUISetState(@SW_ENABLE)
					WinActivate("Mcky's CalEntry")
					Return
				EndIf
			Case $edit_task = "Close Application"
				$ori_work = @ScriptDir & "\"
				$edit_value = FileOpenDialog("Close a running program:", "::{450D8FBA-AD25-11D0-98A8-0800361B1103}", "Applications(*.exe;*.com;*.bat;*.cmd;*.pif;*.scr)", 1)
				FileChangeDir($ori_work)
				If @error = 1 Then
					GUISetState(@SW_ENABLE)
					WinActivate("Mcky's CalEntry")
					Return
				EndIf
			Case $edit_task = "Shutdown"
				$edit_value = InputBox("Shutdown task", "Change shutdown method. Enter: Restart,Log Off,Shutdown. Values must follow the proper case shown.", "Restart")
				If @error = 1 Then
					GUISetState(@SW_ENABLE)
					WinActivate("Mcky's CalEntry")
					Return
				EndIf
				If $edit_value <> "Restart" And $edit_value <> "Log Off" And $edit_value <> "Shutdown" Then $edit_value = "Restart"
			Case Else
				$edit_value = InputBox("Reminder", "Change the reminder to:", $edit_value)
				If @error = 1 Then
					GUISetState(@SW_ENABLE)
					WinActivate("Mcky's CalEntry")
					Return
				EndIf
		EndSelect
		$edit_time_1 = InputBox("Enter the hour", "Enter the hour in 24-hr format to execute the task. Valid:0-23 Default: 0.", "0", " M2")
		If @error = 1 Then
			GUISetState(@SW_ENABLE)
			WinActivate("Mcky's CalEntry")
			Return
		EndIf
		If StringIsAlpha($edit_time_1) = 1 Then $edit_time_1 = 0
		If $edit_time_1 < 1 Or $edit_time_1 > 23 Then $edit_time_1 = 0
		If $edit_time_1 = "" Then $edit_time_1 = 0
		If StringLen($edit_time_1) = 1 Then $edit_time_1 = "0" & $edit_time_1
		$edit_time_2 = InputBox("Enter the minutes", "Enter the minutes to execute the task. Valid:00-59 Default: 00.", "00", " M2")
		If @error = 1 Then
			GUISetState(@SW_ENABLE)
			WinActivate("Mcky's CalEntry")
			Return
		EndIf
		If StringIsAlpha($edit_time_2) = 1 Then $edit_time_2 = 00
		If $edit_time_2 < 0 Or $edit_time_2 > 59 Then $edit_time_2 = 00
		If $edit_time_2 = "" Then $edit_time_2 = 00
		If StringLen($edit_time_2) = 1 Then $edit_time_2 = 0 & $edit_time_2
		$edit_time = $edit_time_1 & ":" & $edit_time_2
		$rrr = 1
		While 1
			
			
			$read_edit = IniRead(GUICtrlRead($tasks_list) & ".ent", "ITEMS", "TIME" & $rrr, "NOTAVAIL")
			If $read_edit = $edit_time Then
				If $rrr >= $qqq Then ExitLoop
				MsgBox(16, "Timings clash", "The time you select to run the task already exists. Please select a different timing.")
				GUISetState(@SW_ENABLE)
				WinActivate("Mcky's CalEntry")
				Return
			EndIf
			$rrr = $rrr + 1
			If $rrr >= $qqq Then ExitLoop
		WEnd
		
		IniWrite(GUICtrlRead($tasks_list) & ".ent", "ITEMS", "TIME" & $task_num_val, $edit_time)
		IniWrite(GUICtrlRead($tasks_list) & ".ent", "ITEMS", "TASK" & $task_num_val, $edit_task)
		IniWrite(GUICtrlRead($tasks_list) & ".ent", "ITEMS", "VALUE" & $task_num_val, $edit_value)
		MsgBox(64, "Successfully updated the task", "Successfully updated the task.")
	Else
		GUISetState(@SW_DISABLE)
		MsgBox(16, "Please click on a timing", "You must select the timing to perform editing or deleting of tasks.")
		GUISetState(@SW_ENABLE)
		WinActivate("Mcky's CalEntry")
		Return
	EndIf
	DATE_LIST()
	CREATE_LIST()
	CREATE_TREE()
	GUICtrlSetData($date_label, "")
	GUISwitch($main_gui)
	GUISetState(@SW_ENABLE)
	WinActivate("Mcky's CalEntry")
EndFunc   ;==>TASK_EDIT





Func NEW_TASK()
	GUISetState(@SW_DISABLE)
	Global $newtask_gui = GUICreate("Create new task", 640, 350, -1, -1, -1, $WS_EX_TOOLWINDOW, $main_gui)
	GUISetFont(9, 800, "", "Verdana")
	GUICtrlCreateGroup("Creating a new task", 4, 0, 634, 344)
	If FileExists(@ScriptDir & "\Res\New.jpg") = 1 Then GUICtrlCreatePic(@ScriptDir & "\Res\New.jpg", 578, 9, 48, 48)
	Global $info_new_date = GUICtrlCreateLabel("Creating new task on: " & GUICtrlRead($date), 12, 16, 480, 64)
	GUICtrlSetFont($info_new_date, 18, 800, "", "Verdana")
	GUICtrlCreateGroup("Select a task type", 8, 50, 628, 230)
	Global $reminder_task = GUICtrlCreateRadio("Reminder", 10, 64, 96, 32)
	GUICtrlSetState($reminder_task, $GUI_CHECKED)
	Global $openapp_task = GUICtrlCreateRadio("Open Application", 192, 64, 134, 32)
	Global $closeapp_task = GUICtrlCreateRadio("Close Application", 384, 64, 134, 32)
	Global $shutdown_task = GUICtrlCreateRadio("Shutdown", 540, 64, 92, 32)
	Global $reminder_edit = GUICtrlCreateInput("Reminder text", 12, 160, 160, 24)
	Global $browse_open_app_button = GUICtrlCreateButton("Browse...", 192, 160, 96, 32)
	Global $open_label = GUICtrlCreateLabel("", 192, 215, 360, 18)
	Global $close_label = GUICtrlCreateLabel("", 384, 215, 360, 18)
	Global $browse_close_app_button = GUICtrlCreateButton("Browse...", 384, 160, 96, 32)
	Global $shutdown_select = GUICtrlCreateCombo("", 535, 160, 96, 80, 0x0003)
	GUICtrlSetData($shutdown_select, "Log Off|Restart|Shutdown")
	GUICtrlSetData($shutdown_select, "Restart")
	
	
	GUICtrlCreateLabel("Select what time to execute task: (24hr format)", 12, 280, 384, 18)
	GUICtrlCreateLabel("Hour:", 12, 300, 64, 18)
	Global $time_hour = GUICtrlCreateCombo("", 12, 316, 48, 128, 0x0003)
	GUICtrlSetData($time_hour, "00|01|02|03|04|05|06|07|08|09|10|11|12|13|14|15|16|17|18|19|20|21|22|23")
	GUICtrlSetData($time_hour, "00")
	GUICtrlCreateLabel(":", 90, 320, 64, 18)
	GUICtrlCreateLabel("Minutes:", 128, 300, 64, 18)
	Global $time_mins = GUICtrlCreateCombo("", 128, 316, 48, 128, BitOR(0x0003, 0x0040))
	GUICtrlSetData($time_mins, "00|01|02|03|04|05|06|07|08|09|10|11|12|13|14|15|16|17|18|19|20|21|22|23|24|25|26|27|28|29|30|31|32|33|34|35|36|37|38|39|40|41|42|43|44|45|46|47|48|49|50|51|52|53|54|55|56|57|58|59")
	GUICtrlSetData($time_mins, "00")
	Global $set_task = GUICtrlCreateButton("Create", 360, 300, 96, 32, 0x0001)
	Global $cancel_task = GUICtrlCreateButton("Cancel", 480, 300, 96, 32)
	
	
	GUICtrlSetState($browse_open_app_button, $GUI_DISABLE)
	GUICtrlSetState($browse_close_app_button, $GUI_DISABLE)
	GUICtrlSetState($shutdown_select, $GUI_DISABLE)
	GUISetState()
	
	
	
	While 1
		$msg = GUIGetMsg()
		If $msg = $GUI_EVENT_CLOSE Or $msg = $cancel_task Then
			GUIDelete()
			GUISwitch($main_gui)
			GUISetState(@SW_ENABLE)
			WinActivate("Mcky's CalEntry")
			$msg = ''
			Return
		EndIf
		If $msg = $reminder_task Then REMIND_TASK_RADIO()
		If $msg = $openapp_task Then OPENAPP_TASK_RADIO()
		If $msg = $closeapp_task Then CLOSEAPP_TASK_RADIO()
		If $msg = $shutdown_task Then SHUTDOWN_TASK_RADIO()
		If $msg = $browse_open_app_button Then BROWSE_OPEN_APP()
		If $msg = $browse_close_app_button Then BROWSE_CLOSE_APP()
		If $msg = $set_task Then
			$check_date_is_collide = 0
			$check_date_collide = GUICtrlRead($date)
			$check_date_collide = StringReplace($check_date_collide, "/", "-")
			$POS = 0
			$POS = StringSplit($check_date_collide, "-")
			If StringLen($POS[1]) = 1 Then $POS[1] = 0 & $POS[1]
			If StringLen($POS[2]) = 1 Then $POS[2] = 0 & $POS[2]
			$qqq = 1
			$read_del_ini = IniReadSection($POS[1] & "-" & $POS[2] & "-" & $POS[3] & ".ENT", "ITEMS")
			While 1
				If $qqq > UBound($read_del_ini) Then ExitLoop
				$read_del = IniRead($POS[1] & "-" & $POS[2] & "-" & $POS[3] & ".ENT", "ITEMS", "TIME" & $qqq, "")
				If $read_del = GUICtrlRead($time_hour) & ":" & GUICtrlRead($time_mins) Then
					$check_date_is_collide = 1
					ExitLoop
				EndIf
				$qqq = $qqq + 1
			WEnd
			If $check_date_is_collide = 1 Then
				GUISetState(@SW_DISABLE)
				MsgBox(16, "Timings clash", "The time you select to run the task already exists. Please select a different timing.")
				GUISetState(@SW_ENABLE)
				WinActivate("Mcky's CalEntry")
			Else
				SET_NEW_TASK()
				ExitLoop
			EndIf
		EndIf
	WEnd
	$msg = ''
	GUIDelete()
	DATE_LIST()
	CREATE_LIST()
	CREATE_TREE()
	GUICtrlSetData($date_label, "")
	GUISwitch($main_gui)
	GUISetState(@SW_ENABLE)
	WinActivate("Mcky's CalEntry")
EndFunc   ;==>NEW_TASK



Func BROWSE_OPEN_APP()
	GUISetState(@SW_DISABLE)
	$ori_work = @ScriptDir & "\"
	$open_application = FileOpenDialog("Run a program", "::{450D8FBA-AD25-11D0-98A8-0800361B1103}", "Applications(*.exe;*.com;*.bat;*.cmd;*.pif;*.scr)", 1)
	FileChangeDir($ori_work)
	If @error = 1 Then $open_application = ""
	$cut_pos = StringInStr($open_application, "\", "0", -1)
	$label_application = StringMid($open_application, $cut_pos + 1)
	GUICtrlSetData($open_label, $label_application)
	GUISetState(@SW_ENABLE)
	WinActivate("Mcky's CalEntry")
EndFunc   ;==>BROWSE_OPEN_APP

Func BROWSE_CLOSE_APP()
	GUISetState(@SW_DISABLE)
	$ori_work = @ScriptDir & "\"
	$close_application = FileOpenDialog("Close a running program", "::{450D8FBA-AD25-11D0-98A8-0800361B1103}", "Applications(*.exe;*.com;*.bat;*.cmd;*.pif;*.scr)", 1)
	FileChangeDir($ori_work)
	If @error = 1 Then $close_application = ""
	$cut_pos = StringInStr($close_application, "\", "0", -1)
	$label_application = StringMid($close_application, $cut_pos + 1)
	GUICtrlSetData($close_label, $label_application)
	GUISetState(@SW_ENABLE)
	WinActivate("Mcky's CalEntry")
EndFunc   ;==>BROWSE_CLOSE_APP


Func SET_NEW_TASK()
	
	If GUICtrlRead($reminder_task) = $GUI_CHECKED Then
		$TASK_WRITE = "Reminder"
		$VALUE_WRITE = StringMid(GUICtrlRead($reminder_edit), 1, 254)
		$TIME_WRITE = GUICtrlRead($time_hour) & ":" & GUICtrlRead($time_mins)
	EndIf
	
	If GUICtrlRead($openapp_task) = $GUI_CHECKED Then
		$TASK_WRITE = "Open Application"
		$VALUE_WRITE = $open_application
		$TIME_WRITE = GUICtrlRead($time_hour) & ":" & GUICtrlRead($time_mins)
	EndIf
	
	If GUICtrlRead($closeapp_task) = $GUI_CHECKED Then
		$TASK_WRITE = "Close Application"
		$VALUE_WRITE = $close_application
		$TIME_WRITE = GUICtrlRead($time_hour) & ":" & GUICtrlRead($time_mins)
	EndIf
	
	If GUICtrlRead($shutdown_task) = $GUI_CHECKED Then
		$TASK_WRITE = "Shutdown"
		$VALUE_WRITE = GUICtrlRead($shutdown_select)
		$TIME_WRITE = GUICtrlRead($time_hour) & ":" & GUICtrlRead($time_mins)
	EndIf
	
	$new_task_date = GUICtrlRead($date)
	$new_task_date = StringReplace($new_task_date, "/", "-")
	$POS = 0
	$POS = StringSplit($new_task_date, "-")
	If StringLen($POS[1]) = 1 Then $POS[1] = 0 & $POS[1]
	If StringLen($POS[2]) = 1 Then $POS[2] = 0 & $POS[2]
	If FileExists($new_task_date & ".ent") = 0 Then
		CHECK_CALDATA()
		IniWrite("CALDATA.DAT", "CALDATA", $POS[1] & "-" & $POS[2] & "-" & $POS[3], $POS[1] & "-" & $POS[2] & "-" & $POS[3] & ".ENT")
		IniWrite($POS[1] & "-" & $POS[2] & "-" & $POS[3] & ".ENT", "ITEMS", "TIME1", $TIME_WRITE)
		IniWrite($POS[1] & "-" & $POS[2] & "-" & $POS[3] & ".ENT", "ITEMS", "TASK1", $TASK_WRITE)
		IniWrite($POS[1] & "-" & $POS[2] & "-" & $POS[3] & ".ENT", "ITEMS", "VALUE1", $VALUE_WRITE)
	Else
		$qqq = 1
		While 1
			If IniRead($POS[1] & "-" & $POS[2] & "-" & $POS[3] & ".ENT", "ITEMS", "TIME" & $qqq, "NOTAVAIL") = "NOTAVAIL" Then ExitLoop
			$qqq = $qqq + 1
		WEnd
		IniWrite("CALDATA.DAT", "CALDATA", $POS[1] & "-" & $POS[2] & "-" & $POS[3], $POS[1] & "-" & $POS[2] & "-" & $POS[3] & ".ENT")
		IniWrite($POS[1] & "-" & $POS[2] & "-" & $POS[3] & ".ENT", "ITEMS", "TIME" & $qqq, $TIME_WRITE)
		IniWrite($POS[1] & "-" & $POS[2] & "-" & $POS[3] & ".ENT", "ITEMS", "TASK" & $qqq, $TASK_WRITE)
		IniWrite($POS[1] & "-" & $POS[2] & "-" & $POS[3] & ".ENT", "ITEMS", "VALUE" & $qqq, $VALUE_WRITE)
	EndIf
	$msg = ''
	GUISetState(@SW_DISABLE)
	MsgBox(64, "Successfully created a new task", "Task : " & $TASK_WRITE & " was successfully created.")
	GUISetState(@SW_ENABLE)
	WinActivate("Mcky's CalEntry")
EndFunc   ;==>SET_NEW_TASK


Func OPENAPP_TASK_RADIO()
	GUICtrlSetState($reminder_edit, $GUI_DISABLE)
	GUICtrlSetState($browse_open_app_button, $GUI_ENABLE)
	GUICtrlSetState($browse_close_app_button, $GUI_DISABLE)
	GUICtrlSetState($shutdown_select, $GUI_DISABLE)
	GUICtrlSetData($close_label, "")
EndFunc   ;==>OPENAPP_TASK_RADIO

Func REMIND_TASK_RADIO()
	GUICtrlSetState($browse_open_app_button, $GUI_DISABLE)
	GUICtrlSetState($browse_close_app_button, $GUI_DISABLE)
	GUICtrlSetState($reminder_edit, $GUI_ENABLE)
	GUICtrlSetState($shutdown_select, $GUI_DISABLE)
	GUICtrlSetData($open_label, "")
	GUICtrlSetData($close_label, "")
EndFunc   ;==>REMIND_TASK_RADIO

Func CLOSEAPP_TASK_RADIO()
	GUICtrlSetState($browse_open_app_button, $GUI_DISABLE)
	GUICtrlSetState($browse_close_app_button, $GUI_ENABLE)
	GUICtrlSetState($reminder_edit, $GUI_DISABLE)
	GUICtrlSetState($shutdown_select, $GUI_DISABLE)
	GUICtrlSetData($open_label, "")
EndFunc   ;==>CLOSEAPP_TASK_RADIO


Func SHUTDOWN_TASK_RADIO()
	GUICtrlSetState($shutdown_select, $GUI_ENABLE)
	GUICtrlSetState($browse_open_app_button, $GUI_DISABLE)
	GUICtrlSetState($browse_close_app_button, $GUI_DISABLE)
	GUICtrlSetState($reminder_edit, $GUI_DISABLE)
	GUICtrlSetData($open_label, "")
	GUICtrlSetData($close_label, "")
EndFunc   ;==>SHUTDOWN_TASK_RADIO


Func CHECK_CALDATA()
	If FileExists("CALDATA.DAT") = 0 Then
		GUISetState(@SW_DISABLE)
		$new_dat = FileOpen("CALDATA.DAT", 2)
		FileWriteLine($new_dat, "#MASTER_DATA")
		FileWriteLine($new_dat, "[CALDATA]")
		FileClose($new_dat)
		GUISetState(@SW_ENABLE)
		WinActivate("Mcky's CalEntry")
	EndIf
EndFunc   ;==>CHECK_CALDATA





;Settings functions
Func SETTINGS()
	GUISetState(@SW_DISABLE)
	$set_gui = GUICreate("Program settings", 265, 440, -1, -1, -1, $WS_EX_TOOLWINDOW, $main_gui)
	GUICtrlCreateGroup("Settings", 4, 0, 260, 436)
	Global $startup = GUICtrlCreateCheckbox("Load at Windows startup (Recommended)", 8, 14)
	Global $del_old_check = GUICtrlCreateCheckbox("Auto delete dates older than today", 8, 32)
	GUICtrlCreateLabel("Use custom alarm WAV file instead of default:", 8, 54)
	Global $customalarmfile = GUICtrlCreateButton("Load WAV file...", 8, 72, -1, -1)
	Global $customalarmfile_b = GUICtrlCreateButton("Use default alarm sound...", 96, 72, -1, -1)
	Global $noalarm = GUICtrlCreateButton("Disable alarm sound...", 8, 100, -1, -1)
	Global $testalarm = GUICtrlCreateButton("Test alarm sound...", 124, 100, -1, -1)
	GUICtrlCreateLabel("CPU processing priority(Normal is recommended):", 8, 140)
	Global $priority_normal = GUICtrlCreateRadio("Normal", 80, 158, 80, -1)
	Global $priority_idle = GUICtrlCreateRadio("Idle", 80, 174, 80, -1)
	Global $priority_high = GUICtrlCreateRadio("High", 80, 190, 80, -1)
	GUICtrlCreateLabel("Browse drives/folders for default backup location:", 8, 220)
	GUICtrlCreateLabel("Export to CSV - Choose a seperator character:", 8, 268)
	Global $csv_sep = GUICtrlCreateCombo("", 8, 290, 96, 32, 0x0003)
	GUICtrlCreateLabel('Default is "Comma"', 128, 292)
	GUICtrlCreateLabel("Export to HTML - Input the title for the HTML file:", 8, 320)
	Global $html_title_input = GUICtrlCreateInput("", 8, 340, 224, 24)
	GUICtrlSetData($csv_sep, 'Comma|SemiColon|Tab|Pipe')
	GUICtrlSetData($csv_sep, 'Comma')
	Global $browse_backup = GUICtrlCreateButton("Browse...", 8, 238, 75, 23, 0x0001)
	Global $default_backup = GUICtrlCreateButton("Default location", 88, 238, 96, 23, 0x0001)
	$acceptsetchanges = GUICtrlCreateButton("OK", 8, 400, 75, 23, 0x0001)
	$cancelsetchanges = GUICtrlCreateButton("Cancel", 96, 400, 75, 23)
	$applysetchanges = GUICtrlCreateButton("Apply", 186, 400, 75, 23)
	GUISetState()
	LOADSETNG()
	GUICtrlSetData($html_title_input, $html_title)
	If $LOAD_WIN = 1 Then GUICtrlSetState($startup, $GUI_CHECKED)
	If $start_del_old = 1 Then GUICtrlSetState($del_old_check, $GUI_CHECKED)
	If $PRIORITY = "Normal" Then GUICtrlSetState($priority_normal, $GUI_CHECKED)
	If $PRIORITY = "Idle" Then GUICtrlSetState($priority_idle, $GUI_CHECKED)
	If $PRIORITY = "High" Then GUICtrlSetState($priority_high, $GUI_CHECKED)
	Select
		Case $csv_seperator = "Comma"
			GUICtrlSetData($csv_sep, 'Comma')
		Case $csv_seperator = "SemiColon"
			GUICtrlSetData($csv_sep, 'SemiColon')
		Case $csv_seperator = "Tab"
			GUICtrlSetData($csv_sep, 'Tab')
		Case $csv_seperator = "Pipe"
			GUICtrlSetData($csv_sep, 'Pipe')
		Case Else
			GUICtrlSetData($csv_sep, 'Comma')
	EndSelect
	While 1
		$msg = GUIGetMsg()
		If $msg = $GUI_EVENT_CLOSE Then ExitLoop
		If $msg = $customalarmfile Then LOAD_WAV()
		If $msg = $customalarmfile_b Then DEFAULT_ALARM()
		If $msg = $noalarm Then NO_ALARM()
		If $msg = $testalarm Then ALARM_TEST()
		If $msg = $browse_backup Then BROWSE_BACKUP()
		If $msg = $default_backup Then DEF_BACKUP()
		If $msg = $applysetchanges Then SAVESETNG()
		If $msg = $acceptsetchanges Then
			SAVESETNG()
			GUISetState(@SW_DISABLE)
			GUISetState(@SW_ENABLE)
			WinActivate("Mcky's CalEntry")
			ExitLoop
		EndIf
		If $msg = $cancelsetchanges Then ExitLoop
	WEnd
	
	;close the settings gui
	$msg = ''
	GUIDelete()
	GUISwitch($main_gui)
	GUISetState(@SW_ENABLE)
	WinActivate("Mcky's CalEntry")
EndFunc   ;==>SETTINGS

Func BROWSE_BACKUP()
	GUISetState(@SW_DISABLE)
	$folder = FileSelectFolder("Select a backup location", "", 3, "A:\")
	If $folder = "" Then
		$backup_location = "A:\"
		GUISetState(@SW_ENABLE)
		WinActivate("Mcky's CalEntry")
		Return
	EndIf
	If FileExists($folder) = 0 Then
		MsgBox(16, "Folder does not exists", "The folder you selected does not exists.")
		$backup_location = "A:\"
		GUISetState(@SW_ENABLE)
		WinActivate("Mcky's CalEntry")
		Return
	EndIf
	
	MsgBox(64, "Backup folder selected", "The calendar entries backup folder, " & $folder & " was selected.")
	$backup_location = $folder
	GUISetState(@SW_ENABLE)
	WinActivate("Mcky's CalEntry")
	
EndFunc   ;==>BROWSE_BACKUP

Func DEF_BACKUP()
	GUISetState(@SW_DISABLE)
	MsgBox(64, "Default folder selected", "The floppy disk drive A:\ was selected as the default backup media.")
	$backup_location = "A:\"
	GUISetState(@SW_ENABLE)
	WinActivate("Mcky's CalEntry")
EndFunc   ;==>DEF_BACKUP

Func DEFAULT_ALARM()
	$ALARM_FILE = @ScriptDir & "\ALARM.WAV"
	GUISetState(@SW_DISABLE)
	MsgBox(64, "Default alarm selected", "The default alarm sound is used instead.")
	GUISetState(@SW_ENABLE)
	WinActivate("Mcky's CalEntry")
EndFunc   ;==>DEFAULT_ALARM


Func NO_ALARM()
	$ALARM_FILE = "99"
	GUISetState(@SW_DISABLE)
	MsgBox(64, "No alarm selected", "Alarm sounds will be disabled.")
	GUISetState(@SW_ENABLE)
	WinActivate("Mcky's CalEntry")
EndFunc   ;==>NO_ALARM

Func ALARM_TEST()
	GUICtrlSetState($testalarm, $GUI_DISABLE)
	If FileExists($ALARM_FILE) = 1 Then SoundPlay($ALARM_FILE, 1)
	GUICtrlSetState($testalarm, $GUI_ENABLE)
EndFunc   ;==>ALARM_TEST


Func LOAD_WAV()
	$ori_work = @ScriptDir & "\"
	GUISetState(@SW_DISABLE)
	Global $ALARM_FILE = FileOpenDialog("Load a WAV sound file for alarm function", "::{450D8FBA-AD25-11D0-98A8-0800361B1103}", "Wave/MP3 Sound files (*.WAV;*.MP3)", 1)
	FileChangeDir($ori_work)
	If @error = 1 Then
		MsgBox(64, "Not loaded", "Custom WAV sound file not selected. Loading default sound file.")
		$ALARM_FILE = ""
	Else
		$test_wav = StringRight($ALARM_FILE, 4)
		If $test_wav <> ".wav" Then
			If $test_wav <> ".mp3" Then
				MsgBox(16, "Invalid WAV file", "Invalid WAV file selected.")
				GUISetState(@SW_ENABLE)
				WinActivate("Mcky's CalEntry")
				Return
			EndIf
		EndIf
		
		MsgBox(64, "Custom WAV sound file selected", "Custom WAV sound file: " & $ALARM_FILE & " ,for alarm loaded.")
	EndIf
	GUISetState(@SW_ENABLE)
	WinActivate("Mcky's CalEntry")
EndFunc   ;==>LOAD_WAV


Func SAVESETNG()
	If GUICtrlRead($startup) = $GUI_CHECKED Then
		IniWrite(@ScriptDir & "\SETTINGS.INI", "SETTINGS", "LOAD_WIN", "1")
		RegWrite("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Run", "CalEntry Tasks Manager", "REG_SZ", @ScriptFullPath & " -winstart")
	Else
		IniWrite(@ScriptDir & "\SETTINGS.INI", "SETTINGS", "LOAD_WIN", "0")
		RegDelete("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Run", "CalEntry Tasks Manager")
	EndIf
	If GUICtrlRead($del_old_check) = $GUI_CHECKED Then
		IniWrite(@ScriptDir & "\SETTINGS.INI", "SETTINGS", "AUTO_DEL_OLD_TASK", "1")
		
	Else
		IniWrite(@ScriptDir & "\SETTINGS.INI", "SETTINGS", "AUTO_DEL_OLD_TASK", "0")
	EndIf
	If $ALARM_FILE = "" Then
		IniWrite(@ScriptDir & "\SETTINGS.INI", "SETTINGS", "ALARM_WAV", "")
		IniWrite(@ScriptDir & "\SETTINGS.INI", "SETTINGS", "DEFAULT_ALARM", "0")
	Else
		IniWrite(@ScriptDir & "\SETTINGS.INI", "SETTINGS", "ALARM_WAV", $ALARM_FILE)
		IniWrite(@ScriptDir & "\SETTINGS.INI", "SETTINGS", "DEFAULT_ALARM", "1")
	EndIf
	If $ALARM_FILE = "99" Then
		IniWrite(@ScriptDir & "\SETTINGS.INI", "SETTINGS", "ALARM_WAV", "")
		IniWrite(@ScriptDir & "\SETTINGS.INI", "SETTINGS", "DEFAULT_ALARM", "99")
	EndIf
	IniWrite(@ScriptDir & "\SETTINGS.INI", "SETTINGS", "BACKUP_WIZARD_DEFAULT_MEDIA", $backup_location)
	If GUICtrlRead($priority_normal) = $GUI_CHECKED Then
		IniWrite(@ScriptDir & "\SETTINGS.INI", "SETTINGS", "PRIORITY", "Normal")
		ProcessSetPriority(@ScriptName, 2)
	EndIf
	If GUICtrlRead($priority_idle) = $GUI_CHECKED Then
		IniWrite(@ScriptDir & "\SETTINGS.INI", "SETTINGS", "PRIORITY", "Idle")
		ProcessSetPriority(@ScriptName, 0)
	EndIf
	If GUICtrlRead($priority_high) = $GUI_CHECKED Then
		IniWrite(@ScriptDir & "\SETTINGS.INI", "SETTINGS", "PRIORITY", "High")
		ProcessSetPriority(@ScriptName, 4)
	EndIf
	$csv_seperator = GUICtrlRead($csv_sep)
	$html_title = GUICtrlRead($html_title_input)
	IniWrite(@ScriptDir & "\SETTINGS.INI", "SETTINGS", "CSV_SEPERATOR", $csv_seperator)
	IniWrite(@ScriptDir & "\SETTINGS.INI", "SETTINGS", "HTML_TITLE", $html_title)
EndFunc   ;==>SAVESETNG



Func LOADSETNG()
	Global $LOAD_WIN = IniRead("SETTINGS.INI", "SETTINGS", "LOAD_WIN", "0")
	If Not $LOAD_WIN = 0 And Not $LOAD_WIN = 1 Then $LOAD_WIN = 0
	If $LOAD_WIN = 1 Then
		RegWrite("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Run", "CalEntry Tasks Manager", "REG_SZ", @ScriptFullPath & " -winstart")
	EndIf
	Global $DEFAULT_ALARM = IniRead("SETTINGS.INI", "SETTINGS", "DEFAULT_ALARM", "1")
	If Not $DEFAULT_ALARM = 0 And Not $DEFAULT_ALARM = 1 And Not $DEFAULT_ALARM = 99 Then $DEFAULT_ALARM = 1
	Global $ALARM_FILE = IniRead( "SETTINGS.INI", "SETTINGS", "ALARM_WAV", "")
	If Not FileExists($ALARM_FILE) Then
		$ALARM_FILE = ""
		$DEFAULT_ALARM = 1
	EndIf
	Global $PRIORITY = IniRead("SETTINGS.INI", "SETTINGS", "PRIORITY", "Normal")
	If $PRIORITY <> "Normal" And $PRIORITY <> "Idle" And $PRIORITY <> "High" Then $PRIORITY = "Normal"
	If $PRIORITY = "Normal" Then ProcessSetPriority(@ScriptName, 2)
	If $PRIORITY = "Idle" Then ProcessSetPriority(@ScriptName, 0)
	If $PRIORITY = "High" Then ProcessSetPriority(@ScriptName, 4)
	Global $backup_location = IniRead("SETTINGS.INI", "SETTINGS", "BACKUP_WIZARD_DEFAULT_MEDIA", "A:\")
	Global $start_del_old = IniRead("SETTINGS.INI", "SETTINGS", "AUTO_DEL_OLD_TASK", "0")
	If Not $start_del_old = 0 And Not $start_del_old = 1 Then $start_del_old = 0
	$csv_seperator = IniRead("SETTINGS.INI", "SETTINGS", "CSV_SEPERATOR", ",")
	$html_title = IniRead("SETTINGS.INI", "SETTINGS", "HTML_TITLE", "Mcky's CalEntry Exported Tasks")
EndFunc   ;==>LOADSETNG
;End of code 1651 lines 66503 bytes