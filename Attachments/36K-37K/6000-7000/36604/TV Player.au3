#include <GUIConstantsEx.au3>
#include <ListBoxConstants.au3>
#include <StaticConstants.au3>
#include <EditConstants.au3>
#include <WindowsConstants.au3>
#Include <File.au3>
#Include <Array.au3>
#include <Constants.au3>
#Include <GuiListBox.au3>
#Include <GuiToolBar.au3>
#include <WindowsConstants.au3>
#include <GuiMenu.au3>
#include <WinAPI.au3>
#Include <Misc.au3>
#Include <GuiComboBox.au3>
#include <SoundGetSetQuery.au3>
#cs
	Title:   		TV Player
	Filename:  		TV Player.au3
	Description: 	Automates the process of playing videos on an external TV / Monitor
	Author:   		seangriffin
	Version:  		V0.3
	Last Update: 	15/08/10
	Requirements: 	AutoIt3 3.2 or higher,
					Windows 95 / 98 / ME / NT4 / 2000 / XP (32-bit) / 2003 (32-bit) / Vista (32-bit) / 2008 (32-bit),
					Pidgin (or similar instant messenger)
					sdparm.exe
					igfxcfg.exe (or similar external display switcher)
					Media Player Classic Home Cinema (or similar multimedia player)
	Changelog:
					---------12/02/12---------- v0.3
					Added MP4 support.

					---------18/02/10---------- v0.2
					Added an INI file for settings.
					Added the option for other IM clients.
					Added the option for a USB standby / spindown command.
					Added the options for external display and resolution switching commands.
					Added the option for a definable multimedia player.
					Added the option for definable paths.
					Added an autosave of options on exit.
					Changed the USB standby script to now use the USB standby command.

					---------17/02/10---------- v0.1
					Initial release.
#ce

;------------------------------------------------------------------
; Constants and Variables
;------------------------------------------------------------------

Const $ini_filename = @ScriptDir & "\TV Player.ini"
Const $main_gui_width = 640, $main_gui_height = 480, $std_button_width = 70, $std_button_height = 20, $std_button_gap = 10, $std_input_width = 200
dim $msg, $main_gui, $accelerator[2][2], $video_list

;------------------------------------------------------------------
; Configure the GUIs
;------------------------------------------------------------------

; Main GUI

$main_gui = GUICreate("TV Player", $main_gui_width, $main_gui_height)
GUISetFont(16)
$list = GUICtrlCreateList("", 10, 10, $main_gui_width-20, $main_gui_height-210)
$playbutton = GUICtrlCreateButton("&Play", 10, $main_gui_height - $std_button_height - 25) ;, $std_button_width, $std_button_height)
$deletebutton = GUICtrlCreateButton("Delete &Video", 80, $main_gui_height - $std_button_height - 25)
$optionsbutton = GUICtrlCreateButton("&Options", 240, $main_gui_height - $std_button_height - 25)
$cancelbutton = GUICtrlCreateButton("&Exit", $main_gui_width - $std_button_width - $std_button_gap, $main_gui_height - $std_button_height - 25) ;, $std_button_width, $std_button_height)

; Options GUI

$options_gui = GUICreate("TV Player - Options", 500, 220, -1, -1, -1, -1, $main_gui)

$im_close_checkbox = GUICtrlCreateCheckbox("Close your &Instant Messenger on Play, restoring on Exit", 10, 10)
GUICtrlSetState($im_close_checkbox, IniRead($ini_filename, "Main", "imclose", $GUI_UNCHECKED))
$im_exe_label = GUICtrlCreateLabel("Executable to kill", 30, 30, 90, 20)
$im_exe_input = GUICtrlCreateInput(IniRead($ini_filename, "Main", "imexecutable", "msnmsgr.exe"), 120, 30, 100, 20)

if GUICtrlRead($im_close_checkbox) = $GUI_UNCHECKED Then

	GUICtrlSetState($im_exe_label, $GUI_HIDE)
	GUICtrlSetState($im_exe_input, $GUI_HIDE)
EndIf

$standbycheckbox = GUICtrlCreateCheckbox("&USB Drive to Standby mode on Exit", 10, 50)
GUICtrlSetState($standbycheckbox, IniRead($ini_filename, "Main", "standby", $GUI_CHECKED))

$standby_cmd_label = GUICtrlCreateLabel("Standby Command", 30, 70, 140, 20)
$standby_cmd_input = GUICtrlCreateInput(IniRead($ini_filename, "Main", "standbycmd", "C:\Program Files\sdparm.exe"), 170, 70, 130, 20)
$standby_switches_label = GUICtrlCreateLabel("Switches", 310, 70, 50, 20)
$standby_switches_input = GUICtrlCreateInput(IniRead($ini_filename, "Main", "standbyswitches", "--command=stop PD1"), 360, 70, 130, 20)

if GUICtrlRead($standbycheckbox) = $GUI_UNCHECKED Then

	GUICtrlSetState($standby_cmd_label, $GUI_HIDE)
	GUICtrlSetState($standby_cmd_input, $GUI_HIDE)
	GUICtrlSetState($standby_switches_label, $GUI_HIDE)
	GUICtrlSetState($standby_switches_input, $GUI_HIDE)
EndIf

$rescheckbox = GUICtrlCreateCheckbox("1920 &Res with TV on Play, restoring on Exit", 10, 90)
GUICtrlSetState($rescheckbox, IniRead($ini_filename, "Main", "res", $GUI_CHECKED))

$tv_cmd_label = GUICtrlCreateLabel("TV Display Command", 30, 110, 140, 20)
$tv_cmd_input = GUICtrlCreateInput(IniRead($ini_filename, "Main", "tvcmd", "C:\windows\system32\igfxcfg.exe"), 170, 110, 130, 20)
$tv_switches_label = GUICtrlCreateLabel("Switches", 310, 110, 50, 20)
$tv_switches_input = GUICtrlCreateInput(IniRead($ini_filename, "Main", "tvswitches", "/SchemeName:TV"), 360, 110, 130, 20)

$comp_cmd_label = GUICtrlCreateLabel("Computer Display Command", 30, 130, 140, 20)
$comp_cmd_input = GUICtrlCreateInput(IniRead($ini_filename, "Main", "compcmd", "C:\windows\system32\igfxcfg.exe"), 170, 130, 130, 20)
$comp_switches_label = GUICtrlCreateLabel("Switches", 310, 130, 50, 20)
$comp_switches_input = GUICtrlCreateInput(IniRead($ini_filename, "Main", "compswitches", "/SchemeName:Notebook"), 360, 130, 130, 20)

if GUICtrlRead($rescheckbox) = $GUI_UNCHECKED Then

	GUICtrlSetState($tv_cmd_label, $GUI_HIDE)
	GUICtrlSetState($tv_cmd_input, $GUI_HIDE)
	GUICtrlSetState($tv_switches_label, $GUI_HIDE)
	GUICtrlSetState($tv_switches_input, $GUI_HIDE)
	GUICtrlSetState($comp_cmd_label, $GUI_HIDE)
	GUICtrlSetState($comp_cmd_input, $GUI_HIDE)
	GUICtrlSetState($comp_switches_label, $GUI_HIDE)
	GUICtrlSetState($comp_switches_input, $GUI_HIDE)
EndIf

$volumecheckbox = GUICtrlCreateCheckbox("Maximise &Volume on Play, muting on Exit", 10, 150)
GUICtrlSetState($volumecheckbox, IniRead($ini_filename, "Main", "volume", $GUI_CHECKED))

;$screensavercheckbox = GUICtrlCreateCheckbox("Disable &Screensaver on Play, restoring Screensaver on Exit", 10, 160)
;GUICtrlSetState($screensavercheckbox, $GUI_CHECKED)

$player_cmd_label = GUICtrlCreateLabel("Media Player Command", 10, 170, 140, 20)
$player_cmd_input = GUICtrlCreateInput(IniRead($ini_filename, "Main", "playercmd", "C:\Program Files\Media Player Classic - Home Cinema\mpc-hc.exe"), 170, 170, 130, 20)
$player_switches_label = GUICtrlCreateLabel("Switches", 310, 170, 50, 20)
$player_switches_input = GUICtrlCreateInput(IniRead($ini_filename, "Main", "playerswitches", "/fullscreen"), 360, 170, 130, 20)

$paths_label = GUICtrlCreateLabel("Paths to Videos (comma separated)", 10, 190, 180, 20)
$paths_input = GUICtrlCreateInput(IniRead($ini_filename, "Main", "paths", "C:\dwn,D:\Sean\dwn,D:\dwn,D:\Downloads,E:\Sean\dwn,E:\dwn,E:\Downloads"), 200, 190, 290, 20)


$curr_gui = $main_gui
GUISwitch($curr_gui)
GUISetState(@SW_SHOW)

$accelerator[0][0] = "{ENTER}"
$accelerator[0][1] = $playbutton
$accelerator[1][0] = "{DELETE}"
$accelerator[1][1] = $deletebutton
GUISetAccelerators($accelerator)

$video_list_empty = True
$video_selected = False
$msn_closed = False
$maintimer = TimerInit()

While 1

	if $video_list_empty = True and TimerDiff($maintimer) > 2000 Then

		$video_list = ""
		$video_folders = StringSplit(GUICtrlRead($paths_input), ",")

		for $each in $video_folders

			$arr = _FileListToArray($each, "*.avi")
			_ArrayDelete($arr, 0)

			$arr_tmp = _FileListToArray($each, "*.mp4")
			_ArrayDelete($arr_tmp, 0)

			_ArrayConcatenate($arr, $arr_tmp)

			for $i = 0 to (UBound($arr) - 1)

				$arr[$i] = $each & "\" & $arr[$i]

				$arr[$i] = StringFormat("%04s", int(FileGetSize($arr[$i]) / 1000000)) & "Mb " & $arr[$i]
			Next

			$tmp = _ArrayToString($arr)

			if StringLen($tmp) > 0 then

				if StringLen($video_list) > 0 Then

					$video_list = $video_list & "|"
				EndIf

				$video_list = $video_list & $tmp
			EndIf
		Next

		if $video_list = "" Then

			TrayTip("TV Player", "No videos detected." & @CRLF & "Plug in an external drive now.", 30)
		Else

			GUICtrlSetData($list, $video_list)
			$video_list_empty = False
		EndIf

		$maintimer = TimerInit()

	EndIf

	if $msg = $optionsbutton Then

		; Disable the Main GUI, and enable the Options GUI
		GUISetState(@SW_DISABLE)
		$curr_gui = $options_gui
		GUISwitch($curr_gui)
		GUISetState(@SW_SHOW)
	EndIf

	if $msg = $im_close_checkbox Then

		if GUICtrlRead($im_close_checkbox) = $GUI_UNCHECKED Then

			GUICtrlSetState($im_exe_label, $GUI_HIDE)
			GUICtrlSetState($im_exe_input, $GUI_HIDE)
		Else

			GUICtrlSetState($im_exe_label, $GUI_SHOW)
			GUICtrlSetState($im_exe_input, $GUI_SHOW)
		EndIf

	EndIf

	if $msg = $standbycheckbox Then

		if GUICtrlRead($standbycheckbox) = $GUI_UNCHECKED Then

			GUICtrlSetState($standby_cmd_label, $GUI_HIDE)
			GUICtrlSetState($standby_cmd_input, $GUI_HIDE)
			GUICtrlSetState($standby_switches_label, $GUI_HIDE)
			GUICtrlSetState($standby_switches_input, $GUI_HIDE)
		Else

			GUICtrlSetState($standby_cmd_label, $GUI_SHOW)
			GUICtrlSetState($standby_cmd_input, $GUI_SHOW)
			GUICtrlSetState($standby_switches_label, $GUI_SHOW)
			GUICtrlSetState($standby_switches_input, $GUI_SHOW)
		EndIf

	EndIf

	if $msg = $rescheckbox Then

		if GUICtrlRead($rescheckbox) = $GUI_UNCHECKED Then

			GUICtrlSetState($tv_cmd_label, $GUI_HIDE)
			GUICtrlSetState($tv_cmd_input, $GUI_HIDE)
			GUICtrlSetState($tv_switches_label, $GUI_HIDE)
			GUICtrlSetState($tv_switches_input, $GUI_HIDE)
			GUICtrlSetState($comp_cmd_label, $GUI_HIDE)
			GUICtrlSetState($comp_cmd_input, $GUI_HIDE)
			GUICtrlSetState($comp_switches_label, $GUI_HIDE)
			GUICtrlSetState($comp_switches_input, $GUI_HIDE)
		Else

			GUICtrlSetState($tv_cmd_label, $GUI_SHOW)
			GUICtrlSetState($tv_cmd_input, $GUI_SHOW)
			GUICtrlSetState($tv_switches_label, $GUI_SHOW)
			GUICtrlSetState($tv_switches_input, $GUI_SHOW)
			GUICtrlSetState($comp_cmd_label, $GUI_SHOW)
			GUICtrlSetState($comp_cmd_input, $GUI_SHOW)
			GUICtrlSetState($comp_switches_label, $GUI_SHOW)
			GUICtrlSetState($comp_switches_input, $GUI_SHOW)
		EndIf

	EndIf


	if $msg = $deletebutton Then

		$ans = MsgBox(4, "TV Player - Delete Video", "Are you sure you want to delete:" & @CRLF & StringMid(GUICtrlRead($list), 8))

		if $ans = 6 Then

			FileDelete(StringMid(GUICtrlRead($list), 8))
			_GUICtrlListBox_DeleteString($list,_GUICtrlListBox_GetCurSel($list))
		EndIf
	EndIf

	if $msg = $playbutton Then

		$video_selected = True

;		if GUICtrlRead($screensavercheckbox) = $GUI_CHECKED Then

;			ShellExecute("rundll32.exe","shell32.dll,Control_RunDLL desk.cpl,,1 ",@SystemDir,"",@SW_HIDE)
;			WinWait("Display Properties")
;			$screensaver_handle = ControlGetHandle("Display Properties","",1300)
;			$screensaver_index = _GUICtrlComboBox_GetCurSel($screensaver_handle)
;			_GUICtrlComboBox_SetCurSel($screensaver_handle,0)
;			ControlClick("Display Properties","",1) ;OK
;		EndIf

		if GUICtrlRead($im_close_checkbox) = $GUI_CHECKED Then

			if ProcessExists(GUICtrlRead($im_exe_input)) Then

				$msn_closed = True
			EndIf

			while ProcessExists(GUICtrlRead($im_exe_input))

				ProcessClose(GUICtrlRead($im_exe_input))
				Sleep(500)
			WEnd
		EndIf


		if GUICtrlRead($rescheckbox) = $GUI_CHECKED Then

			if @DesktopWidth <> 1920 Then

				ShellExecute(GUICtrlRead($tv_cmd_input), GUICtrlRead($tv_switches_input))
				Sleep(5000)
			EndIf
		EndIf


		if GUICtrlRead($volumecheckbox) = $GUI_CHECKED Then

			_SoundSetWaveVolume(100)
			_SoundSetMasterVolume(100)
			_SoundSetMasterMute(0)
		EndIf

;		ShellExecute("C:\Program Files\VideoLAN\VLC\vlc.exe", "-f --volume=1024 """ & StringMid(GUICtrlRead($list), 8) & """")
		ShellExecute("C:\Program Files\Media Player Classic - Home Cinema\mpc-hc.exe", "/fullscreen """ & StringMid(GUICtrlRead($list), 8) & """")

	EndIf


	If $msg = $GUI_EVENT_CLOSE or $msg = $cancelbutton Then

		; If the Main GUI was closed
		if $curr_gui = $main_gui Then

			if $video_selected = False Then

				IniWrite($ini_filename, "Main", "imclose", GUICtrlRead($im_close_checkbox))
				IniWrite($ini_filename, "Main", "imexecutable", GUICtrlRead($im_exe_input))
				IniWrite($ini_filename, "Main", "standby", GUICtrlRead($standbycheckbox))
				IniWrite($ini_filename, "Main", "res", GUICtrlRead($rescheckbox))
				IniWrite($ini_filename, "Main", "standbycmd", GUICtrlRead($standby_cmd_input))
				IniWrite($ini_filename, "Main", "standbyswitches", GUICtrlRead($standby_switches_input))
				IniWrite($ini_filename, "Main", "tvcmd", GUICtrlRead($tv_cmd_input))
				IniWrite($ini_filename, "Main", "tvswitches", GUICtrlRead($tv_switches_input))
				IniWrite($ini_filename, "Main", "compcmd", GUICtrlRead($comp_cmd_input))
				IniWrite($ini_filename, "Main", "compswitches", GUICtrlRead($comp_switches_input))
				IniWrite($ini_filename, "Main", "volume", GUICtrlRead($volumecheckbox))
				IniWrite($ini_filename, "Main", "playercmd", GUICtrlRead($player_cmd_input))
				IniWrite($ini_filename, "Main", "playerswitches", GUICtrlRead($player_switches_input))
				IniWrite($ini_filename, "Main", "paths", GUICtrlRead($paths_input))
				ExitLoop
			Else

;				if GUICtrlRead($screensavercheckbox) = $GUI_CHECKED Then

;					ShellExecute("rundll32.exe","shell32.dll,Control_RunDLL desk.cpl,,1 ",@SystemDir,"",@SW_HIDE)
;					WinWait("Display Properties")
;					$screensaver_handle = ControlGetHandle("Display Properties","",1300)
;					_GUICtrlComboBox_SetCurSel($screensaver_handle,$screensaver_index)
;					ControlClick("Display Properties","",1) ;OK
;				EndIf

				if GUICtrlRead($volumecheckbox) = $GUI_CHECKED Then

					_SoundSetMasterVolume(0)
					_SoundSetMasterMute(1)
				EndIf

				if GUICtrlRead($rescheckbox) = $GUI_CHECKED Then

					ShellExecute(GUICtrlRead($comp_cmd_input), GUICtrlRead($comp_switches_input))
				EndIf

				if $msn_closed = True Then

					ShellExecute("msnmsgr.exe")
				EndIf

				if GUICtrlRead($standbycheckbox) = $GUI_CHECKED Then

					SplashTextOn("TV Player - Info", "Unplug the external drive" & @crlf & "once the motor stops." & @crlf & " ", -1, -1, -1, -1, 32, "", 24)

					dim $first_drive_check = True

					Do

						if $first_drive_check = False Then

							for $secs_to_update = 10 to 1 step -1

								Sleep(1000)
								ControlSetText("TV Player - Info", "", "Static1", "Unplug the external drive" & @crlf & "once the motor stops." & @crlf & "Next update in " & $secs_to_update & " secs.")
							Next
						EndIf

						ControlSetText("TV Player - Info", "", "Static1", "Unplug the external drive" & @crlf & "once the motor stops." & @crlf & "Updating ...")

						ShellExecute("C:\Program Files\sdparm.exe", "--command=stop PD1")
						Sleep(1000)
						$first_drive_check = False

						Local $foo = Run(@ComSpec & " /c ""C:\Program Files\sdparm.exe"" -a PD1", @SystemDir, @SW_HIDE, $STDERR_CHILD + $STDOUT_CHILD)

						While 1
							StdoutRead($foo)
							If @error Then ExitLoop
						Wend

					Until StringLen(StderrRead($foo)) > 0

					SplashOff()

				EndIf

				ExitLoop
			EndIf
		Else

			; Other GUIs are disabled, and the Main GUI enabled.
			GUISetState(@SW_HIDE)
			$curr_gui = $main_gui
			GUISwitch($curr_gui)
			GUISetState(@SW_ENABLE)
			GUISetState(@SW_RESTORE)
		EndIf
	EndIf

	$msg = GUIGetMsg()

WEnd
GUIDelete()
Exit

Func _ScreenSaverActive($bBoolean)
    Local Const $SPI_SETSCREENSAVEACTIVE = 17
    Local $lActiveFlag

    Dim $lActiveFlag
    Dim $retvaL

    If $bBoolean Then
        $lActiveFlag = 1
    Else
        $lActiveFlag = 0
    EndIf

    $dll = DllOpen("user32.dll")
    $retvaL = DllCall($dll, "long", "SystemParametersInfo", "long", $SPI_SETSCREENSAVEACTIVE, "long", $lActiveFlag, "long", 0, "long", 0)
    DllClose($dll)
EndFunc  ;==>_ScreenSaverActive

