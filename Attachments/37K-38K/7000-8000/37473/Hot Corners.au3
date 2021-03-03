#NoTrayIcon
; 2010-08-21 Corrections/additions by D.Uber (compiler automatically moves #NoTrayIcon from line 8 to line 1)
; line 9-11 add includes to set undeclared vars, line 262, 287 use HKEY_CURRENT_USER\ instead of HKEY_USERS\.DEFAULT\
; lines 264, 289 spelling correction "your" instead of "you". Line 373 Added D.U. in About.
; 2012-05-05 lines 262, 287 ignore case if screensaver is not set for current user.

#include <GUIConstants.au3>
#include <Constants.au3>
#include <ComboConstants.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>

Opt("TrayMenuMode",1)
Opt("TrayOnEventMode",1)
Opt("GUIOnEventMode",1)

If FileExists(@TempDir & "\tmp.scf") Then
Else
	FileWriteLine(@TempDir & "\tmp.scf","[Shell]")
	FileWriteLine(@TempDir & "\tmp.scf","Command=2")
	FileWriteLine(@TempDir & "\tmp.scf","IconFile=explorer.exe,3")
	FileWriteLine(@TempDir & "\tmp.scf","[Taskbar]")
	FileWriteLine(@TempDir & "\tmp.scf","Command=ToggleDesktop")
EndIf

TraySetIcon(@ScriptDir & "\Resources\Cursor.ico")
TraySetClick(8)
$conf_tray = TrayCreateItem("Configure")
TrayItemSetState(-1,$TRAY_DEFAULT)
TrayItemSetOnEvent(-1,"Gui")
TrayCreateItem("")
$disable_subtray = TrayCreateMenu("Disable")
$both_disable = TrayCreateItem("Both",$disable_subtray)
TrayItemSetOnEvent(-1,"Both_Tray")
TrayCreateItem("",$disable_subtray)
$hot_disable = TrayCreateItem("Hot Corners",$disable_subtray)
TrayItemSetOnEvent(-1,"Hot_Tray")
$move_disable = TrayCreateItem("Mouse Move",$disable_subtray)
TrayItemSetOnEvent(-1,"Move_Tray")
$about_tray = TrayCreateItem("About")
TrayItemSetOnEvent(-1,"About")
TrayCreateItem("")
$exit_tray = TrayCreateItem("Exit")
TrayItemSetOnEvent(-1,"ExitApp")
TraySetState()
TraySetToolTip("Hot Corners 2")

Dim $gui,$run_gui,$ctrl,$run_path,$gui_active,$tl_combo,$tr_combo,$bl_combo,$br_combo,$up_combo,$lf_combo,$dn_combo,$rt_combo,$section,$mic,$hc_delay,$mm_delay,$settings_gui,$hc_slide,$mm_slide,$startup_settings
$move_state = 2
$hot_state = 2
$both_state = 2

HotKeySet("#x","MM")

If IniRead(@ScriptDir & "\config.ini","Options","FirstRun",0) = 1 Then
	IniWrite(@ScriptDir & "\config.ini","Options","FirstRun",0)
	Gui()
EndIf

While 1
	Sleep(50)
	HC()
WEnd

Func Gui()
	If $gui_active = 1 Then
		WinActivate($gui)
	Else
		$gui = GUICreate("Hot Corners", 441, 383, 275, 185)
		GUISetOnEvent($GUI_EVENT_CLOSE,"GUI_Close")
		GUISetIcon(@ScriptDir & "\Resources\Cursor.ico")
		$file_menu = GUICtrlCreateMenu("&File")
		$close_file = GUICtrlCreateMenuItem("Close", $file_menu)
		GUICtrlSetOnEvent(-1,"GUI_Close")
		$quit_file = GUICtrlCreateMenuItem("Quit", $file_menu)
		GUICtrlSetOnEvent(-1,"ExitApp")
		$options_menu = GUICtrlCreateMenu("&Options")
		$settings_options = GUICtrlCreateMenuItem("Settings...", $options_menu)
		GUICtrlSetOnEvent(-1,"GUI_Settings")
		$bug_options = GUICtrlCreateMenuItem("Bug Report...", $options_menu)
		GUICtrlSetOnEvent(-1,"Bug")
		$help_menu = GUICtrlCreateMenu("&Help")
		$about_help = GUICtrlCreateMenuItem("About...", $help_menu)
		GUICtrlSetOnEvent(-1,"About")
		$help_help = GUICtrlCreateMenuItem("Help...", $help_menu)
		GUICtrlSetOnEvent(-1,"GUI_Help")
		$ok_button = GUICtrlCreateButton("&OK", 174, 328, 75, 25, 0)
		GUICtrlSetOnEvent(-1,"GUI_Ok")
		$cancel_button = GUICtrlCreateButton("&Cancel", 254, 328, 75, 25, 0)
		GUICtrlSetOnEvent(-1,"GUI_Close")
		$about_button = GUICtrlCreateButton("&About", 336, 328, 75, 25, 0)
		GUICtrlSetOnEvent(-1,"About")
		$tab_gui = GUICtrlCreateTab(16, 0, 409, 318)
		$hot_tab = GUICtrlCreateTabItem("Hot Corners")
		$tl_group = GUICtrlCreateGroup("Top Left", 48, 48, 145, 105)
		$tl_icon = GUICtrlCreateIcon(@ScriptDir & "\Resources\TL.ico", 0, 104, 72, 32, 32, BitOR($SS_NOTIFY,$WS_GROUP))
		$tl_combo = GUICtrlCreateCombo("", 64, 120, 113, 25, BitOR($CBS_DROPDOWNLIST,$CBS_AUTOHSCROLL,$CBS_SORT))
		GUICtrlSetOnEvent(-1,"GUI_Combo")
		GUICtrlSetData(-1, "Control Panel|My Documents|Nothing|Run...|Screen Saver|Search Google|Show Desktop|Stand By|Lock",IniRead(@ScriptDir & "\config.ini","Corners","TL","Nothing"))
		$tr_group = GUICtrlCreateGroup("Top Right", 248, 48, 145, 105)
		$tr_icon = GUICtrlCreateIcon(@ScriptDir & "\Resources\TR.ico", 0, 304, 72, 32, 32, BitOR($SS_NOTIFY,$WS_GROUP))
		$tr_combo = GUICtrlCreateCombo("", 264, 120, 113, 25, BitOR($CBS_DROPDOWNLIST,$CBS_AUTOHSCROLL,$CBS_SORT))
		GUICtrlSetOnEvent(-1,"GUI_Combo")
		GUICtrlSetData(-1, "Control Panel|My Documents|Nothing|Run...|Screen Saver|Search Google|Show Desktop|Stand By|Lock",IniRead(@ScriptDir & "\config.ini","Corners","TR","Nothing"))
		$bl_group = GUICtrlCreateGroup("Bottom Left", 48, 176, 145, 105)
		$bl_icon = GUICtrlCreateIcon(@ScriptDir & "\Resources\BL.ico", 0, 104, 200, 32, 32, BitOR($SS_NOTIFY,$WS_GROUP))
		$bl_combo = GUICtrlCreateCombo("", 64, 248, 113, 25, BitOR($CBS_DROPDOWNLIST,$CBS_AUTOHSCROLL,$CBS_SORT))
		GUICtrlSetOnEvent(-1,"GUI_Combo")
		GUICtrlSetData(-1, "Control Panel|My Documents|Nothing|Run...|Screen Saver|Search Google|Show Desktop|Stand By|Lock",IniRead(@ScriptDir & "\config.ini","Corners","BL","Nothing"))
		$br_group = GUICtrlCreateGroup("Bottom Right", 248, 176, 145, 105)
		$br_icon = GUICtrlCreateIcon(@ScriptDir & "\Resources\BR.ico", 0, 304, 200, 32, 32, BitOR($SS_NOTIFY,$WS_GROUP))
		$br_combo = GUICtrlCreateCombo("", 264, 246, 113, 25, BitOR($CBS_DROPDOWNLIST,$CBS_AUTOHSCROLL,$CBS_SORT))
		GUICtrlSetOnEvent(-1,"GUI_Combo")
		GUICtrlSetData(-1, "Control Panel|My Documents|Nothing|Run...|Screen Saver|Search Google|Show Desktop|Stand By|Lock",IniRead(@ScriptDir & "\config.ini","Corners","BR","Nothing"))
		$move_tab = GUICtrlCreateTabItem("Mouse Move")
		$up_group = GUICtrlCreateGroup("Up", 160, 40, 121, 105)
		$up_icon = GUICtrlCreateIcon(@ScriptDir & "\Resources\UP.ico", 0, 200, 64, 32, 32, BitOR($SS_NOTIFY,$WS_GROUP))
		$up_combo = GUICtrlCreateCombo("", 172, 111, 97, 25, BitOR($CBS_DROPDOWNLIST,$CBS_AUTOHSCROLL,$CBS_SORT))
		GUICtrlSetOnEvent(-1,"GUI_Combo")
		GUICtrlSetData(-1, "Control Panel|My Documents|Nothing|Run...|Screen Saver|Search Google|Show Desktop|Stand By|Lock",IniRead(@ScriptDir & "\config.ini","Directions","UP","Nothing"))
		$lf_group = GUICtrlCreateGroup("Left", 32, 104, 121, 105)
		$lf_icon = GUICtrlCreateIcon(@ScriptDir & "\Resources\LF.ico", 0, 72, 128, 32, 32, BitOR($SS_NOTIFY,$WS_GROUP))
		$lf_combo = GUICtrlCreateCombo("", 44, 175, 97, 25, BitOR($CBS_DROPDOWNLIST,$CBS_AUTOHSCROLL,$CBS_SORT))
		GUICtrlSetOnEvent(-1,"GUI_Combo")
		GUICtrlSetData(-1, "Control Panel|My Documents|Nothing|Run...|Screen Saver|Search Google|Show Desktop|Stand By|Lock",IniRead(@ScriptDir & "\config.ini","Directions","LF","Nothing"))
		$dn_group = GUICtrlCreateGroup("Down", 160, 184, 121, 105)
		$dn_icon = GUICtrlCreateIcon(@ScriptDir & "\Resources\DN.ico", 0, 200, 208, 32, 32, BitOR($SS_NOTIFY,$WS_GROUP))
		$dn_combo = GUICtrlCreateCombo("", 172, 255, 97, 25, BitOR($CBS_DROPDOWNLIST,$CBS_AUTOHSCROLL,$CBS_SORT))
		GUICtrlSetOnEvent(-1,"GUI_Combo")
		GUICtrlSetData(-1, "Control Panel|My Documents|Nothing|Run...|Screen Saver|Search Google|Show Desktop|Stand By|Lock",IniRead(@ScriptDir & "\config.ini","Directions","DN","Nothing"))
		$rt_group = GUICtrlCreateGroup("Right", 288, 104, 121, 105)
		$rt_icon = GUICtrlCreateIcon(@ScriptDir & "\Resources\RT.ico", 0, 328, 128, 32, 32, BitOR($SS_NOTIFY,$WS_GROUP))
		$rt_combo = GUICtrlCreateCombo("", 300, 175, 97, 25, BitOR($CBS_DROPDOWNLIST,$CBS_AUTOHSCROLL,$CBS_SORT))
		GUICtrlSetOnEvent(-1,"GUI_Combo")
		GUICtrlSetData(-1, "Control Panel|My Documents|Nothing|Run...|Screen Saver|Search Google|Show Desktop|Stand By|Lock",IniRead(@ScriptDir & "\config.ini","Directions","RT","Nothing"))
		GUISetState(@SW_SHOW)
		$gui_active = 1
	EndIf
EndFunc

Func GUI_Help()
	ShellExecute(@ScriptDir & "\HotCorners.hlp")
EndFunc

Func GUI_Settings()
	GUISetState(@SW_DISABLE,$gui)
	$settings_gui = GUICreate("Settings", 308, 241, 350, 250,$GUI_SS_DEFAULT_GUI,-1,$gui)
	$ok_settings = GUICtrlCreateButton("&OK", 142, 203, 75, 25, 0)
	GUICtrlSetOnEvent(-1,"Settings_OK")
	$cancel_settings = GUICtrlCreateButton("&Cancel", 221, 204, 75, 25, 0)
	GUICtrlSetOnEvent(-1,"Settings_Close")
	GUICtrlCreateLabel("Hot Corners Delay (100-500MS)", 8, 16, 154, 17)
	$hc_slide = GUICtrlCreateSlider(16, 40, 270, 45)
	GUICtrlSetLimit(-1, 500, 100)
	GUICtrlSetData(-1, 100)
	GUICtrlSetData(-1,IniRead(@ScriptDir & "\config.ini","Options","HCD","100"))
	GUICtrlCreateLabel("Mouse Move Sensitivity (100-500MS)", 8, 91, 180, 17)
	$mm_slide = GUICtrlCreateSlider(16, 115, 270, 45)
	GUICtrlSetLimit(-1, 500, 100)
	GUICtrlSetData(-1, 100)
	GUICtrlSetData(-1,IniRead(@ScriptDir & "\config.ini","Options","MMD","100"))
	$startup_settings = GUICtrlCreateCheckbox("Run on Start-Up", 24, 168, 105, 17)
	GUICtrlSetState(-1,IniRead(@ScriptDir & "\config.ini","Options","StartUp",0))
	GUISetOnEvent($GUI_EVENT_CLOSE,"Settings_Close")
	GUISetState(@SW_SHOW)
EndFunc

Func Settings_OK()
	IniWrite(@ScriptDir & "\config.ini","Options","HCD",GUICtrlRead($hc_slide))
	IniWrite(@ScriptDir & "\config.ini","Options","MMD",GUICtrlRead($mm_slide))
	IniWrite(@ScriptDir & "\config.ini","Options","StartUp",GUICtrlRead($startup_settings))
	If GUICtrlRead($startup_settings) = 1 Then
		FileCreateShortcut(@ScriptFullPath,@StartupDir & "\Hot Corners.lnk",@ScriptDir)
	Else
		FileDelete(@StartupDir & "\Hot Corners.lnk")
	EndIf
	Settings_Close()
EndFunc

Func Settings_Close()
	GUIDelete($settings_gui)
	GUISetState(@SW_ENABLE,$gui)
	WinActivate($gui)
EndFunc

Func HC()
	If $hot_state = 0 Or $hot_state = 2 Then
		$pos = MouseGetPos()
		$xres = @DesktopWidth -1
		$yres = @DesktopHeight -1
		If $pos[0] = 0 And $pos[1] = 0 Then
			Sleep(IniRead(@ScriptDir & "\config.ini","Options","HCD",0))
			$pos = MouseGetPos()
			If $pos[0] = 0 And $pos[1] = 0 Then
				Event_HandlerH("TL")
			EndIf
		ElseIf $pos[0] = $xres And $pos[1] = 0 Then
			Sleep(IniRead(@ScriptDir & "\config.ini","Options","HCD",0))
			$pos = MouseGetPos()
			If $pos[0] = $xres And $pos[1] = 0 Then
				Event_HandlerH("TR")
			EndIf
		ElseIf $pos[0] = 0 And $pos[1] = $yres Then
			Sleep(IniRead(@ScriptDir & "\config.ini","Options","HCD",0))
			$pos = MouseGetPos()
			If $pos[0] = 0 And $pos[1] = $yres Then
				Event_HandlerH("BL")
			EndIf
		ElseIf $pos[0] = $xres And $pos[1] = $yres Then
			Sleep(IniRead(@ScriptDir & "\config.ini","Options","HCD",0))
			$pos = MouseGetPos()
			If $pos[0] = $xres And $pos[1] = $yres Then
				Event_HandlerH("BR")
			EndIf
		Else
			$mic = False
		EndIf
	EndIf
EndFunc

Func MM()
	If $move_state = 0 Or $move_state = 2 Then
		MouseMove(@DesktopWidth/2,@DesktopHeight/2,0)
		While 1
			$mpos = MouseGetPos()
			If $mpos[0] = @DesktopWidth / 2 And $mpos[1] = @DesktopHeight / 2 Then
				Sleep(10)
				ContinueLoop
			EndIf
			Sleep(IniRead(@ScriptDir & "\config.ini","Options","MMD",0))
			$mpos = MouseGetPos()
			$mpos[0] = $mpos[0] - @DesktopWidth / 2
			$mpos[1] = $mpos[1] - @DesktopHeight / 2
			If Abs($mpos[0]) > Abs($mpos[1]) Then
				If Abs($mpos[0]) = $mpos[0] Then
					Event_HandlerM("RT")
				Else
					Event_HandlerM("LF")
				EndIf
			ElseIf Abs($mpos[0]) < Abs($mpos[1]) Then
				If Abs($mpos[1]) = $mpos[1] Then
					Event_HandlerM("DN")
				Else
					Event_HandlerM("UP")
				EndIf
			EndIf
			ExitLoop
		WEnd
	EndIf
EndFunc

Func Event_HandlerH($action)
	If $mic = False Then
	Switch IniRead(@ScriptDir & "\config.ini","Corners",$action,"Nothing")
		Case "Control Panel"
			ShellExecute("control.exe")
		Case "My Documents"
			ShellExecute(@MyDocumentsDir)
		Case "Run..."
			ShellExecute(IniRead(@ScriptDir & "\config.ini","Paths",$action,""))
		Case "Screen Saver"
			if RegRead("HKEY_CURRENT_USER\Control Panel\Desktop","SCRNSAVE.EXE") <> "" then ShellExecute(RegRead("HKEY_CURRENT_USER\Control Panel\Desktop","SCRNSAVE.EXE"))
		Case "Search Google"
			$search = InputBox("Search Google","Enter your search:")
			If @error = 0 Then ShellExecute("http://www.google.com/search?q=" & $search)
		Case "Show Desktop"
			ShellExecute(@TempDir & "\tmp.scf")
		Case "Stand By"
			Shutdown(32)
		Case "Lock"
			DllCall("user32.dll","none","LockWorkStation")
	EndSwitch
	$mic = True
	EndIf
EndFunc

Func Event_HandlerM($action)
	If $mic = False Then
	Switch IniRead(@ScriptDir & "\config.ini","Directions",$action,"Nothing")
		Case "Control Panel"
			ShellExecute("control.exe")
		Case "My Documents"
			ShellExecute(@MyDocumentsDir)
		Case "Run..."
			ShellExecute(IniRead(@ScriptDir & "\config.ini","Paths",$action,""))
		Case "Screen Saver"
			if RegRead("HKEY_CURRENT_USER\Control Panel\Desktop","SCRNSAVE.EXE") <> "" then ShellExecute(RegRead("HKEY_CURRENT_USER\Control Panel\Desktop","SCRNSAVE.EXE"))
		Case "Search Google"
			ShellExecute("http://www.google.com/search?q=" & InputBox("Search Google","Enter your search:"))
		Case "Show Desktop"
			ShellExecute(@TempDir & "\tmp.scf")
		Case "Stand By"
			Shutdown(32)
		Case "Lock"
			DllCall("user32.dll","none","LockWorkStation")
	EndSwitch
	EndIf
EndFunc

Func Hot_Tray()
	Toggle($hot_state)
	If $hot_state = 2 Then
		TrayItemSetState($hot_disable,$TRAY_ENABLE + $TRAY_CHECKED)
		$hot_state = 1
	EndIf
EndFunc

Func Move_Tray()
	Toggle($move_state)
	If $move_state = 2 Then
		TrayItemSetState($move_disable,$TRAY_ENABLE + $TRAY_CHECKED)
		$move_state = 1
	EndIf
EndFunc

Func Both_Tray()
	Toggle($both_state)
	If $both_state = 1 Then
		TrayItemSetState($move_disable,$TRAY_DISABLE + $TRAY_CHECKED)
		TrayItemSetState($hot_disable,$TRAY_DISABLE + $TRAY_CHECKED)
		If $move_state = 2 Then $move_state = 3
		If $move_state = 0 Then $move_state = 1
		If $hot_state = 2 Then $hot_state = 3
		If $hot_state = 0 Then $hot_state = 1
	ElseIf $both_state = 0 Then
		TrayItemSetState($move_disable,$TRAY_ENABLE + $TRAY_UNCHECKED)
		TrayItemSetState($hot_disable,$TRAY_ENABLE + $TRAY_UNCHECKED)
		$move_state = 2
		$hot_state = 2
	ElseIf $both_state = 2 Then
		TrayItemSetState($both_disable,$TRAY_ENABLE + $TRAY_CHECKED)
		$both_state = 1
		TrayItemSetState($move_disable,$TRAY_DISABLE + $TRAY_CHECKED)
		TrayItemSetState($hot_disable,$TRAY_DISABLE + $TRAY_CHECKED)
		If $move_state = 2 Then $move_state = 3
		If $move_state = 0 Then $move_state = 1
		If $hot_state = 2 Then $hot_state = 3
		If $hot_state = 0 Then $hot_state = 1
	EndIf
EndFunc

Func Toggle(ByRef $toggle)
	If $toggle = 1 Then
		$toggle = 0
	ElseIf $toggle = 0 Then
		$toggle = 1
	EndIf
EndFunc

Func IniSave()
	IniWrite(@ScriptDir & "\config.ini","Corners","TL",GUICtrlRead($tl_combo))
	IniWrite(@ScriptDir & "\config.ini","Corners","TR",GUICtrlRead($tr_combo))
	IniWrite(@ScriptDir & "\config.ini","Corners","BL",GUICtrlRead($bl_combo))
	IniWrite(@ScriptDir & "\config.ini","Corners","BR",GUICtrlRead($br_combo))
	IniWrite(@ScriptDir & "\config.ini","Directions","UP",GUICtrlRead($up_combo))
	IniWrite(@ScriptDir & "\config.ini","Directions","LF",GUICtrlRead($lf_combo))
	IniWrite(@ScriptDir & "\config.ini","Directions","DN",GUICtrlRead($dn_combo))
	IniWrite(@ScriptDir & "\config.ini","Directions","RT",GUICtrlRead($rt_combo))
EndFunc

Func ExitApp()
	Exit
EndFunc
Func Bug()
	GUISetState(@SW_DISABLE)
	MsgBox(0,"Bug Report","Please send an email about the bug to:" & @LF & "programsforpeers@gmail.com" & @LF & "With 'HC2-Bug Report' as the subject")
	GUISetState(@SW_ENABLE)
	WinActivate($gui)
EndFunc

Func About()
	GUISetState(@SW_DISABLE)
	MsgBox(0,"About","Hot Corners 2" & @LF & "Made by Lekrem Yelsew" & @LF & "From P4P (Programs For Peers)" & @LF & "Corrections/additions by D.U.")
	GUISetState(@SW_ENABLE)
	WinActivate($gui)
EndFunc

Func GUI_Close()
	GUIDelete()
	$gui_active = 0
EndFunc

Func GUI_Combo()
	If GUICtrlRead(@GUI_CtrlId) = "Run..." Then
		$ctrl = @GUI_CtrlId
		GUISetState(@SW_DISABLE,$gui)
		$run_gui = GUICreate("Run...", 372, 101, 306, 237,$GUI_SS_DEFAULT_GUI,-1,$gui)
		$run_ok = GUICtrlCreateButton("&OK", 206, 64, 75, 25, 0)
		GUICtrlSetOnEvent(-1,"Run_OK")
		$run_cancel = GUICtrlCreateButton("&Cancel", 287, 64, 75, 25, 0)
		GUICtrlSetOnEvent(-1,"Run_Close")
		$run_label = GUICtrlCreateLabel("Enter a path of a file or a folder:", 8, 12, 152, 17)
		$run_path = GUICtrlCreateInput(IniRead(@ScriptDir & "\config.ini","Paths",Find_Ini($ctrl),""), 8, 32, 313, 21)
		$run_folder = GUICtrlCreateButton("Browse For Folder...", 8, 64, 105, 25, 0)
		GUICtrlSetOnEvent(-1,"Run_Folder")
		$run_browse = GUICtrlCreateButton("...", 328, 32, 33, 25, 0)
		GUICtrlSetOnEvent(-1,"Run_Browse")
		GUISetOnEvent($GUI_EVENT_CLOSE,"Run_Close")
		GUISetState(@SW_SHOW)
	EndIf
EndFunc

Func Run_OK()
	If FileExists(GUICtrlRead($run_path)) Then
		IniWrite(@ScriptDir & "\config.ini","Paths",Find_Ini($ctrl),GUICtrlRead($run_path))
		GUIDelete($run_gui)
		GUISetState(@SW_ENABLE,$gui)
		WinActivate($gui)
	Else
		GUISetState(@SW_DISABLE)
		MsgBox(16,"ERROR","The file does not exist")
		GUISetState(@SW_ENABLE)
		WinActivate($run_gui)
	EndIf
EndFunc

Func Run_Browse()
	GUISetState(@SW_DISABLE,$run_gui)
	$file = FileOpenDialog("Choose a File","C:\","All (*.*)",1)
	If @error <> 1 Then
		GUICtrlSetData($run_path,$file)
	EndIf
	GUISetState(@SW_ENABLE,$run_gui)
	WinActivate($run_gui)
EndFunc

Func Run_Folder()
	GUISetState(@SW_DISABLE,$run_gui)
	$folder = FileSelectFolder("Choose a Folder","C:\")
	If @error <> 1 Then
		GUICtrlSetData($run_path,$folder)
	EndIf
	GUISetState(@SW_ENABLE,$run_gui)
	WinActivate($run_gui)
EndFunc

Func Run_Close()
	GUIDelete($run_gui)
	GUICtrlSetData($ctrl,"Nothing")
	GUISetState(@SW_ENABLE,$gui)
	WinActivate($gui)
EndFunc

Func GUI_Ok()
	IniSave()
	GUIDelete()
	$gui_active = 0
EndFunc

Func Find_Ini($ctrl)
	If $ctrl = $tl_combo Then
		Return "TL"
	ElseIf $ctrl = $tr_combo Then
		Return "TR"
	ElseIf $ctrl = $bl_combo Then
		Return "BL"
	ElseIf $ctrl = $br_combo Then
		Return "BR"
	ElseIf $ctrl = $up_combo Then
		Return "UP"
	ElseIf $ctrl = $lf_combo Then
		Return "LF"
	ElseIf $ctrl = $rt_combo Then
		Return "RT"
	ElseIf $ctrl = $dn_combo Then
		Return "DN"
	EndIf
EndFunc