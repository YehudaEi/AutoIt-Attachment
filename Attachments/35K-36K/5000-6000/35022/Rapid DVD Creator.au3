#include <GUIConstants.au3>
#include <SliderConstants.au3>
#include <GuiConstantsEx.au3>
#include <WindowsConstants.au3>
#Include <GuiSlider.au3>
#Include <File.au3>
#Include <Array.au3>
#Include <GuiListView.au3>
#include <ListviewConstants.au3>
#Include <GuiToolBar.au3>
#include <GuiSlider.au3>

Const $ini_filename = @ScriptDir & "\Rapid DVD Creator.ini"
Dim $msg, $state = 0

Global $position_slider_drag = False, $vlc1, $position_slider, $user_stop = False, $main_gui, $video_path_input, $target_filenames_to_burn = "", $source_filename, $num_unconverted_files

; Setup Main GUI
$main_gui = GUICreate("Rapid DVD Creator", 800, 450, -1, -1)

GUICtrlCreateLabel("Source Folder (containing videos)", 10, 10, 200, 20)
$source_folder_input = GUICtrlCreateInput(IniRead($ini_filename, "Main", "sourcefolder", ""), 220, 10, 450, 20)
$source_folder_button = GUICtrlCreateButton("Select", 700, 10, 80, 20)

GUICtrlCreateLabel("Target Folder (for converted videos)", 10, 30, 200, 20)
$target_folder_input = GUICtrlCreateInput(IniRead($ini_filename, "Main", "targetfolder", ""), 220, 30, 450, 20)
$target_folder_button = GUICtrlCreateButton("Select", 700, 30, 80, 20)

GUICtrlCreateLabel("Disc Title", 10, 50, 200, 20)
$disc_title_input = GUICtrlCreateInput(IniRead($ini_filename, "Main", "disctitle", "Disc Title"), 220, 50, 450, 20)

GUICtrlCreateGroup("", 10, 75, 450, 125)
$source_folder_files_button = GUICtrlCreateButton("Source Folder Files", 20, 90, 140, 20)
$source_folder_files_details_button = GUICtrlCreateRadio("Details", 360, 90, 50, 20)
GUICtrlSetState($source_folder_files_details_button, $GUI_CHECKED)
$convert_folder_button = GUICtrlCreateButton("1. Convert Source Folder", 20, 110, 140, 20)
$convert_folder_label = GUICtrlCreateLabel("", 170, 110, 180, 20)
$convert_folder_details_button = GUICtrlCreateRadio("Details", 360, 110, 50, 20)
$author_burn_button = GUICtrlCreateButton("2. Author and Burn to DVD", 20, 130, 140, 20)
$author_burn_label = GUICtrlCreateLabel("", 170, 130, 150, 20)
$author_burn_details_button = GUICtrlCreateRadio("Details", 360, 130, 50, 20)
$all_the_above_button = GUICtrlCreateButton("All", 20, 150, 140, 20)
GUICtrlSetState($all_the_above_button, $GUI_DISABLE)
$close_button = GUICtrlCreateButton("Close (Esc)", 20, 170, 140, 20)

GUICtrlCreateGroup("Quantizer", 515, 80, 140, 45)
$quantizer_auto_checkbox = GUICtrlCreateCheckbox("Auto", 520, 100)
GUICtrlSetState($quantizer_auto_checkbox, IniRead($ini_filename, "Main", "quantizerauto", $GUI_CHECKED))
$constant_quantizer = GUICtrlCreateSlider(570, 100, 60)
GUICtrlSetLimit($constant_quantizer, 12, 1)
_GUICtrlSlider_SetTicFreq($constant_quantizer, 1)
GUICtrlSetData($constant_quantizer, IniRead($ini_filename, "Main", "constantquantizer", 4))
$constant_quantizer_input = GUICtrlCreateInput(IniRead($ini_filename, "Main", "constantquantizer", 4), 630, 100, 20, 20)
GUICtrlCreateGroup("", -99, -99, 1, 1)

if GUICtrlRead($quantizer_auto_checkbox) = $GUI_CHECKED Then

	GUICtrlSetState($constant_quantizer, $GUI_HIDE)
	GUICtrlSetState($constant_quantizer_input, $GUI_HIDE)
Else

	GUICtrlSetState($constant_quantizer, $GUI_SHOW)
	GUICtrlSetState($constant_quantizer_input, $GUI_SHOW)
EndIf

GUICtrlCreateGroup("Threads", 515, 125, 140, 40)
$threads_auto_checkbox = GUICtrlCreateCheckbox("Auto", 520, 140)
GUICtrlSetState($threads_auto_checkbox, IniRead($ini_filename, "Main", "threadsauto", $GUI_CHECKED))
$threads_slider = GUICtrlCreateSlider(570, 140, 60)
GUICtrlSetLimit($threads_slider, 4, 2)
_GUICtrlSlider_SetTicFreq($threads_slider, 1)
GUICtrlSetData($threads_slider, IniRead($ini_filename, "Main", "threads", 4))
$threads_input = GUICtrlCreateInput(IniRead($ini_filename, "Main", "threads", 4), 630, 140, 20, 20)
GUICtrlCreateGroup("", -99, -99, 1, 1)

if GUICtrlRead($threads_auto_checkbox) = $GUI_CHECKED Then

	GUICtrlSetState($threads_slider, $GUI_HIDE)
	GUICtrlSetState($threads_input, $GUI_HIDE)
Else

	GUICtrlSetState($threads_slider, $GUI_SHOW)
	GUICtrlSetState($threads_input, $GUI_SHOW)
EndIf

GUICtrlCreateGroup("Aspect", 665, 80, 100, 45)
$aspect_43_radio = GUICtrlCreateRadio("4:3", 670, 100, 40)
GUICtrlSetState($aspect_43_radio, IniRead($ini_filename, "Main", "43", $GUI_CHECKED))
$aspect_169_radio = GUICtrlCreateRadio("16:9", 710, 100, 50)
GUICtrlSetState($aspect_169_radio, IniRead($ini_filename, "Main", "169", $GUI_UNCHECKED))
GUICtrlCreateGroup("", -99, -99, 1, 1)

GUICtrlCreateGroup("Target", 665, 125, 100, 40)
$target_pal_radio = GUICtrlCreateRadio("PAL", 670, 140, 40)
GUICtrlSetState($target_pal_radio, IniRead($ini_filename, "Main", "pal", $GUI_CHECKED))
$target_ntsc_radio = GUICtrlCreateRadio("NTSC", 710, 140, 50)
GUICtrlSetState($target_ntsc_radio, IniRead($ini_filename, "Main", "ntsc", $GUI_UNCHECKED))
GUICtrlCreateGroup("", -99, -99, 1, 1)

$refresh_button = GUICtrlCreateButton("Refresh (F5)", 520, 180, 80, 20)

$source_folder_files_details_label = GUICtrlCreateLabel("Details - Source Folder Files", 10, 210, 250, 20)
$source_folder_files_details_listview = GUICtrlCreateListView("Filename|Size|Date", 10, 230, 750, 200, BitOr($LVS_EDITLABELS, $LVS_SINGLESEL))
_GUICtrlListView_SetColumnWidth($source_folder_files_details_listview, 0, 300)
_GUICtrlListView_SetColumnWidth($source_folder_files_details_listview, 1, 80)
_GUICtrlListView_SetColumnWidth($source_folder_files_details_listview, 2, 120)

$convert_folder_details_label = GUICtrlCreateLabel("Details - Source Folder Files to convert", 10, 210, 250, 20)
$convert_folder_details_listview = GUICtrlCreateListView("Filename", 10, 230, 750, 200, BitOr($LVS_EDITLABELS, $LVS_SINGLESEL))
_GUICtrlListView_SetColumnWidth($convert_folder_details_listview, 0, 300)
GUICtrlSetState($convert_folder_details_label, $GUI_HIDE)
GUICtrlSetState($convert_folder_details_listview, $GUI_HIDE)

$author_burn_details_label = GUICtrlCreateLabel("Details - Target Files to burn", 10, 210, 250, 20)
$author_burn_details_listview = GUICtrlCreateListView("Filename|Size (Mb)|Date", 10, 230, 750, 200, BitOr($LVS_EDITLABELS, $LVS_SINGLESEL))
_GUICtrlListView_SetColumnWidth($author_burn_details_listview, 0, 300)
_GUICtrlListView_SetColumnWidth($author_burn_details_listview, 1, 80)
_GUICtrlListView_SetColumnWidth($author_burn_details_listview, 2, 120)
GUICtrlSetState($author_burn_details_label, $GUI_HIDE)
GUICtrlSetState($author_burn_details_listview, $GUI_HIDE)

dim $main_gui_accel[1][2]=[["{F5}", $refresh_button]]

; Show Main GUI
GUISetState(@SW_SHOW)
GUISetAccelerators($main_gui_accel)

GUIRegisterMsg($WM_NOTIFY, "WM_NOTIFY")

refresh()


; Main Loop
while 1

	if $msg = $refresh_button Then

		refresh()
	EndIf

	if $msg = $source_folder_button Then

		$source_folder = FileSelectFolder("Rapid DVD Creator - Select Source Folder", "")
		if StringLen($source_folder) > 0 Then

			GUICtrlSetData($source_folder_input, $source_folder)
			refresh()
		EndIf
	EndIf

	if $msg = $target_folder_button Then

		$target_folder = FileSelectFolder("Rapid DVD Creator - Select Target Folder", "")
		if StringLen($target_folder) > 0 Then

			GUICtrlSetData($target_folder_input, $target_folder)
			refresh()
		EndIf
	EndIf

	if $msg = $source_folder_files_button Then

		GUICtrlSetState($source_folder_files_details_button, $GUI_CHECKED)
		GUICtrlSetState($convert_folder_details_button, $GUI_UNCHECKED)
		GUICtrlSetState($author_burn_details_button, $GUI_UNCHECKED)
 		$msg = $source_folder_files_details_button
	EndIf

	if $msg = $convert_folder_button Then

		dim $i = 1

		for $each in $source_filename

			$source_filepath = GUICtrlRead($source_folder_input) & "\" & $each
			$target_filename = StringLeft($each, StringLen($each)-3) & "mpg"
			$target_filepath = GUICtrlRead($target_folder_input) & "\" & $target_filename

			if FileExists($target_filepath) = False Then

				$cmd_args = "-i """ & $source_filepath & """"

				if GUICtrlRead($aspect_43_radio) = $GUI_CHECKED Then

					$cmd_args = $cmd_args & " -aspect 4:3"
				Else

					$cmd_args = $cmd_args & " -aspect 16:9"
				EndIf

				if GUICtrlRead($target_pal_radio) = $GUI_CHECKED Then

					$cmd_args = $cmd_args & " -target pal-dvd"
				Else

					$cmd_args = $cmd_args & " -target ntsc-dvd"
				EndIf

				if GUICtrlRead($threads_auto_checkbox) = $GUI_UNCHECKED Then

					$cmd_args = $cmd_args & " -threads " & GUICtrlRead($threads_input)
				EndIf

				if GUICtrlRead($quantizer_auto_checkbox) = $GUI_UNCHECKED Then

					$cmd_args = $cmd_args & " -qscale " & GUICtrlRead($constant_quantizer_input)
				EndIf

				$cmd_args = $cmd_args & " """ & $target_filepath & """"
				ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $cmd_args = ' & $cmd_args & @crlf) ;### Debug Console
;				Exit

				TrayTip("Rapid DVD Creator", "Converting " & $i & " of " & $num_unconverted_files & " (" & $each & ")", 30)

				ShellExecuteWait(@ScriptDir & "\ffmpeg.exe", $cmd_args)

				$i = $i + 1
			EndIf
		Next



	EndIf

	if $msg = $author_burn_button Then

		if WinExists("DVDStyler") Then

;			WinKill("DVDStyler")
			ProcessClose("DVDStyler.exe")
			ProcessWaitClose("DVDStyler.exe")
		EndIf

;		FileChangeDir(GUICtrlRead($target_folder_input))

		Run("C:\Program Files\DVDStyler\bin\DVDStyler.exe")

		WinWait("Welcome")
		ControlClick("Welcome", "", 5100)
		WinWait("Select template for DVD menus")
		ControlClick("Select template for DVD menus", "", 5100)
		WinWait("DVDStyler")
		_GUICtrlToolbar_ClickButton(ControlGetHandle("DVDStyler", "", "[CLASS:ToolbarWindow32; INSTANCE:2]"), 2110)
		WinWait("Choose a file")
		ControlSetText("Choose a file", "", 1148, GUICtrlRead($target_folder_input))
		ControlClick("Choose a file", "", "[CLASS:Button; INSTANCE:2]")
		WinWait("Choose a file")
		ControlSetText("Choose a file", "", 1148, $target_filenames_to_burn)
		;Exit
;		ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $target_filenames_to_burn = ' & $target_filenames_to_burn & @crlf & '>Error code: ' & @error & @crlf) ;### Debug Console
		ControlClick("Choose a file", "", "[CLASS:Button; INSTANCE:2]")

		; Save the project temporarily

		FileRecycle("c:\temp\RDC.dvds")
		WinWait("DVDStyler")
		_GUICtrlToolbar_ClickButton(ControlGetHandle("DVDStyler", "", "[CLASS:ToolbarWindow32; INSTANCE:2]"), 5003)
		WinWait("Save a DVDStyler project file")
		ControlSetText("Save a DVDStyler project file", "", 1148, "c:\temp\RDC.dvds")
		ControlClick("Save a DVDStyler project file", "", "[CLASS:Button; INSTANCE:2]")

		While FileExists("c:\temp\RDC.dvds") = False

			Sleep(500)
		WEnd

		; Update the project with the disc title and set all titles to play all

		$rdctemp = FileRead("c:\temp\RDC.dvds")
		$rdctemp = StringReplace($rdctemp, "Disc Title", GUICtrlRead($disc_title_input))
		$rdctemp = StringReplace($rdctemp, "<action pgci=", "<action playAll=""true"" pgci=")
		FileRecycle("c:\temp\RDC.dvds")
		FileWrite("c:\temp\RDC.dvds", $rdctemp)

		; Load the same project back into DVDStyler

		WinWait("DVDStyler")
		_GUICtrlToolbar_ClickButton(ControlGetHandle("DVDStyler", "", "[CLASS:ToolbarWindow32; INSTANCE:2]"), 5000)
		WinWait("Open a DVDStyler project file")
		ControlSetText("Open a DVDStyler project file", "", 1148, "c:\temp\RDC.dvds")
		ControlClick("Open a DVDStyler project file", "", "[CLASS:Button; INSTANCE:2]")

		WinWait("DVDStyler")
		_GUICtrlToolbar_ClickButton(ControlGetHandle("DVDStyler", "", "[CLASS:ToolbarWindow32; INSTANCE:2]"), 2105)
		WinWait("Burn")
;		ControlClick("Burn", "", 5100)
	EndIf

	if $msg = $all_the_above_button Then

	EndIf

	if $msg = $source_folder_files_details_button Then

		GUICtrlSetState($source_folder_files_details_label, $GUI_SHOW)
		GUICtrlSetState($source_folder_files_details_listview, $GUI_SHOW)
		GUICtrlSetState($convert_folder_details_label, $GUI_HIDE)
		GUICtrlSetState($convert_folder_details_listview, $GUI_HIDE)
		GUICtrlSetState($author_burn_details_label, $GUI_HIDE)
		GUICtrlSetState($author_burn_details_listview, $GUI_HIDE)
	EndIf

	if $msg = $convert_folder_details_button Then

		GUICtrlSetState($source_folder_files_details_label, $GUI_HIDE)
		GUICtrlSetState($source_folder_files_details_listview, $GUI_HIDE)
		GUICtrlSetState($convert_folder_details_label, $GUI_SHOW)
		GUICtrlSetState($convert_folder_details_listview, $GUI_SHOW)
		GUICtrlSetState($author_burn_details_label, $GUI_HIDE)
		GUICtrlSetState($author_burn_details_listview, $GUI_HIDE)

	EndIf

	if $msg = $author_burn_details_button Then

		GUICtrlSetState($source_folder_files_details_label, $GUI_HIDE)
		GUICtrlSetState($source_folder_files_details_listview, $GUI_HIDE)
		GUICtrlSetState($convert_folder_details_label, $GUI_HIDE)
		GUICtrlSetState($convert_folder_details_listview, $GUI_HIDE)
		GUICtrlSetState($author_burn_details_label, $GUI_SHOW)
		GUICtrlSetState($author_burn_details_listview, $GUI_SHOW)
	EndIf

	if $msg = $quantizer_auto_checkbox Then

		if GUICtrlRead($quantizer_auto_checkbox) = $GUI_CHECKED Then

			GUICtrlSetState($constant_quantizer, $GUI_HIDE)
			GUICtrlSetState($constant_quantizer_input, $GUI_HIDE)
		Else

			GUICtrlSetState($constant_quantizer, $GUI_SHOW)
			GUICtrlSetState($constant_quantizer_input, $GUI_SHOW)
		EndIf
	EndIf

	if $msg = $threads_auto_checkbox Then

		if GUICtrlRead($threads_auto_checkbox) = $GUI_CHECKED Then

			GUICtrlSetState($threads_slider, $GUI_HIDE)
			GUICtrlSetState($threads_input, $GUI_HIDE)
		Else

			GUICtrlSetState($threads_slider, $GUI_SHOW)
			GUICtrlSetState($threads_input, $GUI_SHOW)
		EndIf
	EndIf

	if $msg = $constant_quantizer Then

		GUICtrlSetData($constant_quantizer_input, GUICtrlRead($constant_quantizer))
	EndIf

	if $msg = $threads_slider Then

		GUICtrlSetData($threads_input, GUICtrlRead($threads_slider))
	EndIf



	If $msg = $GUI_EVENT_CLOSE or $msg = $close_button Then

		IniWrite($ini_filename, "Main", "sourcefolder", GUICtrlRead($source_folder_input))
		IniWrite($ini_filename, "Main", "targetfolder", GUICtrlRead($target_folder_input))
		IniWrite($ini_filename, "Main", "disctitle", GUICtrlRead($disc_title_input))
		IniWrite($ini_filename, "Main", "quantizerauto", GUICtrlRead($quantizer_auto_checkbox))
		IniWrite($ini_filename, "Main", "constantquantizer", GUICtrlRead($constant_quantizer))
		IniWrite($ini_filename, "Main", "threadsauto", GUICtrlRead($threads_auto_checkbox))
		IniWrite($ini_filename, "Main", "threads", GUICtrlRead($threads_slider))
		IniWrite($ini_filename, "Main", "pal", GUICtrlRead($target_pal_radio))
		IniWrite($ini_filename, "Main", "ntsc", GUICtrlRead($target_ntsc_radio))
		IniWrite($ini_filename, "Main", "43", GUICtrlRead($aspect_43_radio))
		IniWrite($ini_filename, "Main", "169", GUICtrlRead($aspect_169_radio))
		ExitLoop
	EndIf

	$msg = GUIGetMsg()
WEnd

Func WM_NOTIFY($hWnd, $iMsg, $iwParam, $ilParam)
	#forceref $hWnd, $iMsg, $iwParam
	Local $hWndFrom, $iIDFrom, $iCode, $tNMHDR, $hWndSlider
	$hWndSlider = $position_slider
	If Not IsHWnd($position_slider) Then $hWndSlider = GUICtrlGetHandle($position_slider)

	$tNMHDR = DllStructCreate($tagNMHDR, $ilParam)
	$hWndFrom = HWnd(DllStructGetData($tNMHDR, "hWndFrom"))
	$iIDFrom = DllStructGetData($tNMHDR, "IDFrom")
	$iCode = DllStructGetData($tNMHDR, "Code")
	Switch $hWndFrom
		Case $hWndSlider

			Switch $iCode

				case $NM_CUSTOMDRAW

					$position_slider_drag = True

				Case $NM_RELEASEDCAPTURE

					_GUICtrlVLC_SeekAbsolute($vlc1, (GUICtrlRead($position_slider) * 1000))
					$position_slider_drag = False
			EndSwitch
	EndSwitch
	Return $GUI_RUNDEFMSG
EndFunc

Func refresh()

	; get an array of files in the source folder

;	dim $source_filename = _FileListToArray(GUICtrlRead($source_folder_input), "*.flv")
	$source_filename = _FileListToArray(GUICtrlRead($source_folder_input), "*.*", 1)

	if @error < 1 Then


		_ArrayDelete($source_filename,0)
		;_ArrayDisplay($source_file)

		dim $num_source_files = UBound($source_filename)

		_GUICtrlListView_BeginUpdate($source_folder_files_details_listview)
		_GUICtrlListView_DeleteAllItems($source_folder_files_details_listview)

		for $each in $source_filename

			GUICtrlCreateListViewItem($each & "| | ", $source_folder_files_details_listview)
		Next

		_GUICtrlListView_EndUpdate($source_folder_files_details_listview)

		; count how many source folder files have been converted already

		$num_unconverted_files = $num_source_files

		_GUICtrlListView_BeginUpdate($convert_folder_details_listview)
		_GUICtrlListView_DeleteAllItems($convert_folder_details_listview)

		for $each in $source_filename

			dim $target_filename = StringLeft($each, StringLen($each)-3) & "mpg"
			dim $target_filepath = GUICtrlRead($target_folder_input) & "\" & $target_filename

			if FileExists($target_filepath) Then

		;		ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $target_filepath = ' & $target_filepath & @crlf) ;### Debug Console
				$num_unconverted_files = $num_unconverted_files - 1
			Else

				GUICtrlCreateListViewItem($each, $convert_folder_details_listview)
			EndIf
		Next

		_GUICtrlListView_EndUpdate($convert_folder_details_listview)

		; get an array of files in the target folder

		dim $target_filename = _FileListToArray(GUICtrlRead($target_folder_input), "*.mpg")
		_ArrayDelete($target_filename,0)
		;_ArrayDisplay($target_filename)
		;Exit

		dim $num_target_files = UBound($target_filename)

		GUICtrlSetData($convert_folder_label, $num_unconverted_files & " files (out of " & $num_source_files & ") will be converted")

		; get an array of converted files (mpg) in the target folder (to author and burn)

		dim $total_bytes = 0
		$target_filenames_to_burn = ""

		if $num_target_files > 0 Then

			_GUICtrlListView_BeginUpdate($author_burn_details_listview)
			_GUICtrlListView_DeleteAllItems($author_burn_details_listview)

			for $each in $target_filename

				dim $each_bytes = FileGetSize(GUICtrlRead($target_folder_input) & "\" & $each)
				dim $each_filesize = int($each_bytes / 1048576)
				$total_bytes = $total_bytes + $each_bytes

				GUICtrlCreateListViewItem($each & "|" & $each_filesize & "| ", $author_burn_details_listview)

				if StringLen($target_filenames_to_burn) > 0 Then

					$target_filenames_to_burn = $target_filenames_to_burn & " "
				EndIf

				$target_filenames_to_burn = $target_filenames_to_burn & """" & $each & """"
			Next

			_GUICtrlListView_EndUpdate($author_burn_details_listview)

		EndIf

		dim $total_gigabytes = Round($total_bytes / 1073741824, 1)
		GUICtrlSetData($author_burn_label, $num_target_files & " files will be burned (" & $total_gigabytes & " Gb)")

	EndIf

EndFunc

