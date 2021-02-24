#NoTrayIcon
#region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=images\paw.ico
#AutoIt3Wrapper_Outfile=H:\Downloads\TRHelper_x86.exe
#AutoIt3Wrapper_Outfile_x64=H:\Downloads\TRHelper\TRHelper_x64.exe
#AutoIt3Wrapper_Compile_Both=y
#AutoIt3Wrapper_Res_Description=Monitoring helper for TheRenamer
#AutoIt3Wrapper_Res_Fileversion=1.0.0.0
#AutoIt3Wrapper_Res_LegalCopyright=Freeware for personal use only.
#AutoIt3Wrapper_Res_SaveSource=y
#AutoIt3Wrapper_Res_Language=1033
#AutoIt3Wrapper_Res_Field=Made by|Saitoh183
#AutoIt3Wrapper_Res_Field=Email|saitoh183@gmail.com
#endregion ;**** Directives created by AutoIt3Wrapper_GUI ****
;#################Libraries to include####################
#include <Date.au3>
#include <ButtonConstants.au3>
#include <GUIConstantsEx.au3>
#include <ProgressConstants.au3>
#include <WindowsConstants.au3>
#include <StaticConstants.au3>
#include <Misc.au3>
#include <TabConstants.au3>
#include <EditConstants.au3>
#include <Array.au3>
#include <file.au3>
#include <progress.au3>
#include <Constants.au3>
#include <RecFileListToArray.au3>
#include <xskin.au3>
#include <__ButtonHoverTag.au3>
#include <XSkinGradient.au3>
#include <XSkinTab.au3>
#include <XSkinAnimate.au3>
#include <GuiSlider.au3>
#include <GDIPlus.au3>
;#####################Option Modes##################################
Opt("GUIOnEventMode", 1)
Opt("TrayMenuMode", 3)
Opt("TrayOnEventMode", 1)
Opt("TrayAutoPause", 0)
Opt("WinTitleMatchMode", 3)
;#########################Global Variables##################################################

; Progress Bars----------------------------------------------------------------------------------
Global $progOn, $progress, $main, $sub, $prog_gui

; Trayitems--------------------------------------------------------------------------------------
Global $tvitem, $movitem, $aniitem, $extitem, $pauseitem, $startitem, $stopitem, $unpauseitem, _
		$exititem, $opt_item, $trayline, $silentitem

; Main GUI---------------------------------------------------------------------------------------
Global $TRH_GUI = 9999, $movie_down, $movielog, $tv_down, $tvlog, $anime_down, $animes, $animelog, _
		$extra_down, $extras, $extralog, $renamerpath, $Progress1, $start, $stop, $extrab, $tvb, _
		$animeb, $movieb, $exit, $pauseme, $options, $sFile = @ScriptDir & "\images\paw.ico"

;Skins------------------------------------------------------------------------------------------
Global $skinfolder = @ScriptDir & "\images\Skin_main", _
		$XButton_Location = @ScriptDir & "\images", _
		$Icon_Folder = @ScriptDir & "\images", $XIcon, $XIcon_opt, $hImage, $hGraphic, $hGraphic2, _
		$mGraph, $mImage

;Option GUI--------------------------------------------------------------------------------------
Global $TRH_opt_GUI = 9999, $Ok = 9999, $Cancel, $saveset, $y = 0, $Tab1

;General Tab----------------------------------------------------------------------------------
Global $x86, $x64, $custom, $custompath, $win, $win64cus, $win86cus, $Brow_cus, $Brow_cus_txt, $bar, _
		$Slider1, $Trans, $Updown1, $i_perc, $perc = "100", $last_perc = $perc, $invis

; Fetching Tab-----------------------------------------------------------------------------------
Global $Anime, $ani_fetch, $Ani_arch, $extra, $ext_fetch, $ext_Arch, $TV_fet, $Mov_fet, _
		$changeMovpath, $changeTVpath, $extcontentname, $tv_txt, $mov_txt, $tv_fet_input, $mov_fet_input, _
		$Brow_ani_fet, $Brow_ani_arch, $Brow_ext_fet, $Brow_ext_arch, $ext_fet_txt, $ext_arch_txt, $ani_fet_txt, $ani_arch_txt

; Log Tab----------------------------------------------------------------------------------------
Global $TVlog_chk, $TVlogname, $TVlogpath, $Movlog_chk, $Movlogname, $Movlogpath, _
		$Anilog_chk, $Anilogname, $Anilogpath, $extlog_chk, $extlogname, $extlogpath, _
		$Brow_Tvlog, $Brow_movlog, $Brow_anilog, $Brow_extlog

; Save function----------------------------------------------------------------------------------
Global $iniTRpathinfo, $s_inianime, $s_iniextra, $allfet, $s_initv, $s_iniMov, $s_iniAni, $s_iniext, $s_bar, $s_silent, $s_iniguimode, _
		$s_invis

; Ini Variables----------------------------------------------------------------------------------
Global $TRpath = IniRead(@ScriptDir & "\TRH_settings.ini", "therenamer", "Path", "none"), _
		$_anifet = IniReadSection(@ScriptDir & "\TRH_settings.ini", "anime"), $_extfet = IniReadSection(@ScriptDir & "\TRH_settings.ini", "extra"), _
		$_active = IniReadSection(@ScriptDir & "\TRH_settings.ini", "Active_Sections"), $_logs = IniReadSection(@ScriptDir & "\TRH_settings.ini", "logs"), _
		$_tvDown = IniRead(@ScriptDir & "\TRH_settings.ini", "TV_Movie_Download", "TvPath", "none"), $_GUIMode = IniReadSection(@ScriptDir & "\TRH_settings.ini", "GUI_Mode"), _
		$_gui_pbar = IniRead(@ScriptDir & "\TRH_settings.ini", "GUI_Mode", "Pbar", "False"), $_gui_invis = IniRead(@ScriptDir & "\TRH_settings.ini", "GUI_Mode", "Trans", "0"), _
		$_ext_foldername = IniRead(@ScriptDir & "\TRH_settings.ini", "Extra", "Folder_Name", "Extra"), $_ani_act = IniRead(@ScriptDir & "\TRH_settings.ini", "Active_Sections", "Anime", "False"), _
		$_tvlog_act = IniRead(@ScriptDir & "\TRH_settings.ini", "Active_Sections", "tvlog", "False"), $_movlog_act = IniRead(@ScriptDir & "\TRH_settings.ini", "Active_Sections", "movlog", "False"), _
		$_anilog_act = IniRead(@ScriptDir & "\TRH_settings.ini", "Active_Sections", "anilog", "False"), $_movDown = IniRead(@ScriptDir & "\TRH_settings.ini", "TV_Movie_Download", "MoviePath", "none"), _
		$_Down = IniReadSection(@ScriptDir & "\TRH_settings.ini", "TV_Movie_Download")
; GUI Flags---------------------------------------------------------
Global $pausef = False
Global $Runf = False
If _Singleton("TRHelper", 1) = 0 Then
	MsgBox(16, "Error", "TRHelper is already running")
	Exit
EndIf
AdlibRegister("_check", 1)
;#############Verify if ini file exist already#######################
If Not FileExists(@ScriptDir & "\TRH_settings.ini") Then
	MsgBox(16, "First Step", "Please fill out the Options before pressing the Start button.")
	_opt()
ElseIf FileExists(@ScriptDir & "\TRH_settings.ini") Then
	If $_tvDown = "none" And $_movDown = "none" Then
		MsgBox(48, "Warning", "mandatory options are missing." & @CRLF & "Please make sure that the TV or Movie Fetcher options are configured" & _
				"according to your TheRenamer settings")
	EndIf
EndIf
;####################################################################
;=======System Tray Icon================================
If $_gui_pbar = "True" Then
	$silentitem = TrayCreateItem("Status: Running")
	$trayline = TrayCreateItem("")
EndIf

$pauseitem = TrayCreateItem("Pause")
TrayItemSetOnEvent(-1, "_Trayitems")
TrayItemSetState(-1, $tray_disable)
$unpauseitem = TrayCreateItem("Unpause")
TrayItemSetOnEvent(-1, "_Trayitems")
TrayItemSetState(-1, $tray_disable)
TrayCreateItem("")
$startitem = TrayCreateItem("Start")
TrayItemSetOnEvent(-1, "_Trayitems")
$stopitem = TrayCreateItem("Stop")
TrayItemSetOnEvent(-1, "_Trayitems")
TrayItemSetState(-1, $tray_disable)
TrayCreateItem("")
$tvitem = TrayCreateItem("Tv Logs")
TrayItemSetOnEvent(-1, "_Trayitems")
TrayItemSetState(-1, $tray_disable)
$movitem = TrayCreateItem("Movie Logs")
TrayItemSetOnEvent(-1, "_Trayitems")
TrayItemSetState(-1, $tray_disable)
$aniitem = TrayCreateItem("Anime Logs")
TrayItemSetOnEvent(-1, "_Trayitems")
TrayItemSetState(-1, $tray_disable)
$extitem = TrayCreateItem($_ext_foldername & " Logs")
TrayItemSetOnEvent(-1, "_Trayitems")
TrayItemSetState(-1, $tray_disable)
TrayCreateItem("")
$exititem = TrayCreateItem("Exit")
TrayItemSetOnEvent(-1, "_Trayitems")
TrayCreateItem("")
$opt_item = TrayCreateItem("Options")
TrayItemSetOnEvent(-1, "_opt")
TraySetIcon(@ScriptDir & "\images\paw.ico")
TraySetState()

;======End System Tray Icon===========================

TRH() ;Call Main GUI

Func TRH()
	$TRH_GUI = XskinGUICreate("TRHelper", 414, 363, $skinfolder, 1, 25, "")
	WinMove($TRH_GUI, "", IniRead(@ScriptDir & "\position.ini", "TRH_Position", "X-Pos", 192), IniRead(@ScriptDir & "\position.ini", "TRH_Position", "Y-Pos", 124))
	GUISetIcon($sFile)
	$XIcon = XSkinIcon($TRH_GUI, 2)
	$Pic2 = GUICtrlCreatePic(@ScriptDir & "\images\TRH1.jpg", 20, 40, 191, 50)
	$state = WinGetState("[active]", "")
	ConsoleWrite("Starting Script" & @CRLF); <==== Debug
	$Progress1 = _ProgressOn($progress, $main, $sub, " ", " ", 88, 128)
	$start = __HoverButton("Start", 16, 312, 65, 33, "s1_")
	$stop = __HoverButton("Stop", 96, 312, 65, 33, "s1_")
	__HoverButtonSetState($stop, $gui_disable)
	If $_ext_foldername <> "Extra" Then
		$extrab = __HoverButton($_ext_foldername & " Log", 120, 260, 97, 25, "s1_")
		TrayItemSetState($extitem, $tray_enable)
	Else
		$extrab = __HoverButton($_ext_foldername & " Log", 120, 260, 97, 25, "s1_")
		__HoverButtonSetState($extrab, $gui_disable)
	EndIf
	If $_tvlog_act = "true" Then
		$tvb = __HoverButton("Tv Log", 16, 232, 97, 25, "s1_")
		TrayItemSetState($tvitem, $tray_enable)
	Else
		$tvb = __HoverButton("Tv Log", 16, 232, 97, 25, "s1_")
		__HoverButtonSetState($tvb, $gui_disable)
	EndIf
	If $_anilog_act = "true" Then
		$animeb = __HoverButton("Anime Log", 120, 232, 97, 25, "s1_")
		TrayItemSetState($aniitem, $tray_enable)
	Else
		$animeb = __HoverButton("Anime Log", 120, 232, 97, 25, "s1_")
		__HoverButtonSetState($animeb, $gui_disable)
	EndIf
	If $_movlog_act = "true" Then
		$movieb = __HoverButton("Movie Log", 16, 260, 97, 25, "s1_")
		TrayItemSetState($movitem, $tray_enable)
	Else
		$movieb = __HoverButton("Movie Log", 16, 260, 97, 25, "s1_")
		__HoverButtonSetState($movieb, $gui_disable)
	EndIf
	$exit = __HoverButton("Exit", 295, 320, 97, 25, "s1_")
	$pauseme = __HoverButton("Pause", 176, 312, 65, 33, "s1_")
	__HoverButtonSetState($pauseme, $gui_disable)
	$options = __HoverButton("Options", 295, 290, 97, 25, "s1_")
	If $_gui_pbar = "True" Then
		$Runf = True
		_progb()
		TrayItemSetState($startitem, $tray_disable)
		TrayItemSetState($stopitem, $tray_enable)
		TrayItemSetState($pauseitem, $tray_enable)
	Else
		GUISetState(@SW_SHOW, $TRH_GUI)
		TraySetState(2)
		_GDIturnON()
		$hGraphic = _GDIPlus_GraphicsCreateFromHWND($TRH_GUI)
		_GDIPlus_GraphicsDrawImage($hGraphic, $hImage, 215, 40)
		;$mImage = _GDIPlus_ImageLoadFromFile(@ScriptDir & "\images\TRH.png")
		;_GDIPlus_GraphicsDrawImage($hGraphic, $mImage, 20, 40)
	EndIf
	If WinExists($TRH_opt_GUI) Then GUISetState(@SW_DISABLE, $TRH_GUI)

	;----------GUI Event buttons---------------------------
	GUICtrlSetOnEvent($start[0], "_actions")
	GUICtrlSetOnEvent($stop[0], "_actions")
	GUICtrlSetOnEvent($pauseme[0], "_actions")
	GUICtrlSetOnEvent($tvb[0], "_actions")
	GUICtrlSetOnEvent($animeb[0], "_actions")
	GUICtrlSetOnEvent($movieb[0], "_actions")
	GUICtrlSetOnEvent($extrab[0], "_actions")
	GUICtrlSetOnEvent($exit[0], "_exit")
	GUICtrlSetOnEvent($options[0], "_opt")
	GUICtrlSetOnEvent($XIcon[1], "_actions")
	GUICtrlSetOnEvent($XIcon[2], "_actions")
	;------------------------------------------------------
	While 1
		Sleep(10)
		; Check if the flag has been set by the OnEvent function
		If $Runf Then
			_Monitor()
		EndIf
	WEnd


EndFunc   ;==>TRH
Func _check()
	If WinActive($TRH_GUI) Then __CheckHoverAndPressed($TRH_GUI)
	If WinActive("TRHelper Options") Then __CheckHoverAndPressed($TRH_opt_GUI)
EndFunc   ;==>_check

Func _GDIturnON()
	_GDIPlus_Startup()
	$hImage = _GDIPlus_ImageLoadFromFile(@ScriptDir & "\images\paw.png")
EndFunc   ;==>_GDIturnON

Func _progb()
	$prog_gui = XSkinGUICreate("TRHelper Progress Bar", 290, 125, $skinfolder, 1, 25, 1)
	WinMove($prog_gui, "", IniRead(@ScriptDir & "\position.ini", "Progress_Position", "X-Pos", -1), IniRead(@ScriptDir & "\position.ini", "Progress_Position", "Y-Pos", -1))
	If $_GUIMode[3][1] = "True" Then
		XSkinAnimate($prog_gui, 1, 11, $_GUIMode[2][1], 1000)
	Else
		XSkinAnimate($prog_gui, 1, 11, 0, 1000)
	EndIf
	$progOn = _ProgressOn($progress, $main, $sub, "TRhelper", "", 15, 45)
	_GDIturnON()
	$hGraphic2 = _GDIPlus_GraphicsCreateFromHWND($prog_gui)
	_GDIPlus_GraphicsDrawImage($hGraphic2, $hImage, 235, 35)
	TrayItemSetText($silentitem, "Status: Running")
EndFunc   ;==>_progb

;##################Options Section####################################
Func _opt()
	$Runf = False
	If WinExists($TRH_GUI) Then GUISetState(@SW_DISABLE, $TRH_GUI)
	TraySetState(2)
	;Global Options Menu================================================
	$TRH_opt_GUI = XskinGUICreate("TRHelper Options", 615, 438, $skinfolder)
	$XIcon_opt = XSkinIcon($TRH_opt_GUI, 2)
	GUISetIcon($sFile)
	WinMove($TRH_opt_GUI, "", IniRead(@ScriptDir & "\position.ini", "TRH_Options_Position", "X-Pos", 1044), IniRead(@ScriptDir & "\position.ini", "TRH_Options_Position", "Y-Pos", 160))
	GUICtrlCreateTab(50, 50, 510, 330)
	$Ok = __HoverButton("OK", 104, 392, 81, 25, "s1_")
	$Cancel = __HoverButton("Cancel", 408, 392, 81, 25, "s1_")
	;General TAB====================================================
	GUICtrlCreateTabItem("General")
	GUICtrlSetState(-1, $GUI_SHOW)
	GUICtrlCreateGroup("TheRenamer", 55, 90, 497, 193)
	$x86 = GUICtrlCreateCheckbox("Windows 32bit", 60, 110, 89, 17)
	GUICtrlSetTip(-1,'C:\Program Files\theRenamer\theRenamer.exe')
	$x64 = GUICtrlCreateCheckbox("Windows 64bit", 60, 160, 89, 17)
	GUICtrlSetTip(-1,'C:\Program Files (x86)\theRenamer\theRenamer.exe')
	$custom = GUICtrlCreateCheckbox("Custom path", 60, 210, 81, 17)
	$custompath = GUICtrlCreateInput("", 60, 230, 393, 21)
	GUICtrlSetState(-1, $gui_disable)
	$Brow_cus = __HoverButton("Browse", 460, 230, 81, 25, "s1_")
	__HoverButtonSetState($Brow_cus, $gui_disable)
	GUICtrlCreateGroup("", -99, -99, 1, 1)
	$win = GUICtrlRead($x86) Or GUICtrlRead($x64)
	$win64cus = GUICtrlRead($custom) Or GUICtrlRead($x64)
	$win86cus = GUICtrlRead($custom) Or GUICtrlRead($x86)
	GUICtrlCreateGroup("Progress Bar", 55, 295, 497, 81)
	$bar = GUICtrlCreateCheckbox("Progress Bar on/off", 59, 320, 121, 17)
	GUICtrlSetTip(-1, "Progress bar only instead of main GUI")
	$invis = GUICtrlCreateCheckbox("Transparency", 59, 342, 113, 17)
	GUICtrlSetState(-1, $gui_disable)
	$Slider1 = GUICtrlCreateSlider(272, 320, 170, 20, BitOR($TBS_TOOLTIPS, $TBS_AUTOTICKS, $TBS_ENABLESELRANGE, $TBS_top))
	GUICtrlSetState(-1, $gui_disable)
	GUICtrlSetLimit(-1, 100, 1)
	$Trans = GUICtrlCreateLabel("Transperency :", 183, 320, 100, 18)
	$slid_text = GUICtrlCreateInput("<==invis                    semi-trans==>", 272, 344, 170, 22, BitOR($GUI_SS_DEFAULT_INPUT, $ES_READONLY), 0)
	$i_perc = GUICtrlCreateInput("0", 480, 320, 49, 22, $ES_NUMBER)
	GUICtrlSetState(-1, $gui_disable)
	GUICtrlSetLimit($i_perc, 3, 1)
	$Updown1 = GUICtrlCreateUpdown($i_perc)
	GUICtrlSetState(-1, $gui_disable)
	GUICtrlSetLimit($Updown1, 100, 1)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	;Fetching Extra TAB==============================================================================
	GUICtrlCreateTabItem("Fetching / Extras")
	;GUICtrlSetTip(-1, "")
	$Anime = GUICtrlCreateCheckbox("  Anime", 60, 90, 81, 17)
	GUICtrlCreateLabel("Anime Fetch Folder :", 60, 110, 101, 17)
	$ani_fetch = GUICtrlCreateInput("", 60, 125, 197, 21, BitOR($GUI_SS_DEFAULT_INPUT, $ES_READONLY))
	GUICtrlSetState(-1, $gui_disable)
	$Brow_ani_fet = __HoverButton("...", 195, 108, 25, 17, "s1_")
	__HoverButtonSetState($Brow_ani_fet, $gui_disable)
	GUICtrlSetTip(-1, "Folder that will contain the non-process files")
	GUICtrlCreateLabel("Anime Archive Folder :", 330, 110, 110, 17)
	$Ani_arch = GUICtrlCreateInput("", 330, 125, 197, 21, BitOR($GUI_SS_DEFAULT_INPUT, $ES_READONLY))
	GUICtrlSetState(-1, $gui_disable)
	$Brow_ani_arch = __HoverButton("...", 465, 108, 25, 17, "s1_")
	__HoverButtonSetState($Brow_ani_arch, $gui_disable)
	GUICtrlSetTip(-1, "Folder where you store your anime")
	$extra = GUICtrlCreateCheckbox("  Extra", 60, 155, 81, 17)
	GUICtrlCreateLabel("Extra Fetch Folder :", 60, 175, 96, 17)
	$Brow_ext_fet = __HoverButton("...", 195, 173, 25, 17, "s1_")
	GUICtrlSetTip(-1, "Folder that will contain the non-process files")
	__HoverButtonSetState($Brow_ext_fet, $gui_disable)
	$ext_fetch = GUICtrlCreateInput("", 60, 190, 197, 21, BitOR($GUI_SS_DEFAULT_INPUT, $ES_READONLY))
	GUICtrlSetState(-1, $gui_disable)
	GUICtrlCreateLabel("Extra  Archive Folder :", 330, 175, 108, 17)
	$Brow_ext_arch = __HoverButton("...", 465, 173, 25, 17, "s1_")
	__HoverButtonSetState($Brow_ext_arch, $gui_disable)
	$ext_Arch = GUICtrlCreateInput("", 330, 190, 197, 21, BitOR($GUI_SS_DEFAULT_INPUT, $ES_READONLY))
	GUICtrlSetState(-1, $gui_disable)
	$extcontentname = GUICtrlCreateInput("Name of your Extra folder", 60, 215, 129, 21)
	GUICtrlSetTip(-1, 'For example: "HDMovies"' & @CRLF & 'It cannot be named "Extra"')
	GUICtrlSetState(-1, $gui_disable)
	$TV_fet = GUICtrlCreateCheckbox("TV Fetcher", 60, 270, 81, 17)
	GUICtrlSetTip(-1, "If TV Settings are activated in TheRename, check this box")
	$changeTVpath = __HoverButton("...", 164, 270, 25, 17, "s1_")
	__HoverButtonSetState($changeTVpath, $gui_disable)
	$tv_fet_input = GUICtrlCreateInput("", 195, 270, 241, 21, BitOR($GUI_SS_DEFAULT_INPUT, $ES_READONLY))
	$Mov_fet = GUICtrlCreateCheckbox("Movie Fetcher", 60, 300, 89, 17)
	GUICtrlSetTip(-1, "If Movie Settings are activated in TheRename, check this box")
	$changeMovpath = __HoverButton("...", 164, 300, 25, 17, "s1_")
	__HoverButtonSetState($changeMovpath, $gui_disable)
	$mov_fet_input = GUICtrlCreateInput("", 195, 300, 241, 21, BitOR($GUI_SS_DEFAULT_INPUT, $ES_READONLY))
	GUICtrlCreateLabel("If you have TVshow or Movies configured in The Renamer ," & _
			"these boxes must be checked", 60, 320, 431, 17)
	GUICtrlSetFont(-1, 8, 400, 0, "Tahoma")
	GUICtrlSetColor(-1, 0xFF0000)

	;LOG TAB============================================================================================
	GUICtrlCreateTabItem("Log Settings")
	$TVlog_chk = GUICtrlCreateCheckbox("TV Log Path", 60, 101, 79, 17)
	$TVlogpath = GUICtrlCreateInput("", 60, 121, 393, 21, BitOR($GUI_SS_DEFAULT_INPUT, $ES_READONLY))
	GUICtrlSetState(-1, $gui_disable)
	$Brow_Tvlog = __HoverButton("...", 460, 121, 25, 17, "s1_")
	__HoverButtonSetState($Brow_Tvlog, $gui_disable)
	$Movlog_chk = GUICtrlCreateCheckbox("Movie Log Path", 60, 173, 95, 17)
	$Movlogpath = GUICtrlCreateInput("", 60, 193, 393, 21, BitOR($GUI_SS_DEFAULT_INPUT, $ES_READONLY))
	GUICtrlSetState(-1, $gui_disable)
	$Brow_movlog = __HoverButton("...", 460, 193, 25, 17, "s1_")
	__HoverButtonSetState($Brow_movlog, $gui_disable)
	$Anilog_chk = GUICtrlCreateCheckbox("Anime Log Path", 60, 245, 95, 17)
	$Anilogpath = GUICtrlCreateInput("", 60, 265, 393, 21, BitOR($GUI_SS_DEFAULT_INPUT, $ES_READONLY))
	GUICtrlSetState(-1, $gui_disable)
	$Brow_anilog = __HoverButton("...", 461, 265, 25, 17, "s1_")
	__HoverButtonSetState($Brow_anilog, $gui_disable)
	$extlog_chk = GUICtrlCreateCheckbox("Extra Log Path", 60, 308, 95, 17)
	$extlogpath = GUICtrlCreateInput("", 60, 328, 393, 21, BitOR($GUI_SS_DEFAULT_INPUT, $ES_READONLY))
	GUICtrlSetState(-1, $gui_disable)
	$Brow_extlog = __HoverButton("...", 461, 328, 25, 17, "s1_")
	__HoverButtonSetState($Brow_extlog, $gui_disable)
	GUICtrlCreateLabel("* If Log is enabled, Log path must be added." & _
			"Log path must have this form (c:\myfolder\mylog.(log or txt)", 60, 350, 550, 49)
	GUICtrlSetFont(-1, 8, 400, 0, "Tahoma")
	GUICtrlSetColor(-1, 0xFF0000)
	GUICtrlCreateLabel("*", 155, 308, 8, 17)
	GUICtrlSetFont(-1, 10, 400, 0, "Tahoma")
	GUICtrlSetColor(-1, 0xFF0000)
	GUICtrlCreateLabel("*", 155, 245, 8, 17)
	GUICtrlSetFont(-1, 10, 400, 0, "Tahoma")
	GUICtrlSetColor(-1, 0xFF0000)
	GUICtrlCreateLabel("*", 155, 173, 8, 17)
	GUICtrlSetFont(-1, 10, 400, 0, "Tahoma")
	GUICtrlSetColor(-1, 0xFF0000)
	GUICtrlCreateLabel("*", 155, 101, 8, 17)
	GUICtrlSetFont(-1, 10, 400, 0, "Tahoma")
	GUICtrlSetColor(-1, 0xFF0000)
	;If __HoverWaitButtonUp($TRH_opt_GUI) Then Return
	;=============Load Settings that are configured=========================================
	If FileExists(@ScriptDir & "\TRH_settings.ini") Then settings()
	;=================End Load Settings======================
	GUISetState(@SW_SHOW)
	;XSkinGradient($TRH_opt_GUI, $bkg_color, $btn_color)
	;================GUI Event buttons=======================
	GUICtrlSetOnEvent($custom, "_actions")
	GUICtrlSetOnEvent($x86, "_actions")
	GUICtrlSetOnEvent($x64, "_actions")
	GUICtrlSetOnEvent($Anime, "_actions")
	GUICtrlSetOnEvent($extra, "_actions")
	GUICtrlSetOnEvent($TVlog_chk, "_actions")
	GUICtrlSetOnEvent($Movlog_chk, "_actions")
	GUICtrlSetOnEvent($Anilog_chk, "_actions")
	GUICtrlSetOnEvent($extlog_chk, "_actions")
	GUICtrlSetOnEvent($Ok[0], "_actions")
	GUICtrlSetOnEvent($Cancel[0], "_actions")
	GUICtrlSetOnEvent($TV_fet, "_actions")
	GUICtrlSetOnEvent($Mov_fet, "_actions")
	GUICtrlSetOnEvent($changeTVpath[0], "_actions")
	GUICtrlSetOnEvent($changeMovpath[0], "_actions")
	GUICtrlSetOnEvent($Brow_cus[0], "_actions")
	GUICtrlSetOnEvent($Brow_ani_arch[0], "_actions")
	GUICtrlSetOnEvent($Brow_ani_fet[0], "_actions")
	GUICtrlSetOnEvent($Brow_ext_arch[0], "_actions")
	GUICtrlSetOnEvent($Brow_ext_fet[0], "_actions")
	GUICtrlSetOnEvent($Brow_Tvlog[0], "_actions")
	GUICtrlSetOnEvent($Brow_movlog[0], "_actions")
	GUICtrlSetOnEvent($Brow_anilog[0], "_actions")
	GUICtrlSetOnEvent($Brow_extlog[0], "_actions")
	GUICtrlSetOnEvent($bar, "_actions")
	GUICtrlSetOnEvent($XIcon_opt[1], "_actions")
	GUICtrlSetOnEvent($XIcon_opt[2], "_actions")
	GUICtrlSetOnEvent($Slider1, "_actions")
	GUICtrlSetOnEvent($i_perc, "_actions")
	GUICtrlSetOnEvent($Updown1, "_actions")
	GUICtrlSetOnEvent($invis, "_actions")
EndFunc   ;==>_opt
;#####################End of Options GUI#################################
Func _save(); Save Button==========================================================
	;General Tab Options------------------------------------
	If GUICtrlRead($x86) = $Gui_checked Then
		$iniTRpathinfo = 'C:\Program Files\theRenamer\theRenamer.exe'
	ElseIf GUICtrlRead($x64) = $Gui_checked Then
		$iniTRpathinfo = 'C:\Program Files (x86)\theRenamer\theRenamer.exe'
	ElseIf GUICtrlRead($custom) = $Gui_checked Then
		$iniTRpathinfo = GUICtrlRead($custompath)
	EndIf
	$s_bar = BitAND(GUICtrlRead($bar), $Gui_checked) = $Gui_checked
	$s_invis = BitAND(GUICtrlRead($invis), $Gui_checked) = $Gui_checked
	$s_iniguimode = "Pbar=" & $s_bar & @LF & "Trans%=" & GUICtrlRead($Slider1) & @LF & "Trans=" & $s_invis
	;Fetching Tab Options---------------------------------------
	If GUICtrlRead($Anime) = $Gui_checked Then
		$inianime1 = GUICtrlRead($ani_fetch)
		$inianime2 = GUICtrlRead($Ani_arch)
		$s_inianime = "Fetch=" & $inianime1 & @LF & "Archive=" & $inianime2
		If $inianime1 = "" Or $inianime2 = "" Then
			MsgBox(64, "Error", "You forgot to enter the path of the Anime Fetch or Archive Folder.")
			Return
		Else
			$y = $y + 1
		EndIf
	Else
		$y = $y + 1
		$s_inianime = 'Fetch=' & @LF & 'Archive='
	EndIf
	If GUICtrlRead($extra) = $Gui_checked Then
		$iniextra1 = GUICtrlRead($ext_fetch)
		$iniextra2 = GUICtrlRead($ext_Arch)
		$iniextra3 = GUICtrlRead($extcontentname)
		$s_iniextra = "Fetch=" & $iniextra1 & @LF & "Archive=" & $iniextra2 & @LF & "Folder_Name=" & $iniextra3
		If $iniextra1 = "" Or $iniextra2 = "" Or $iniextra3 = "Name of your Extra folder" Then
			MsgBox(64, "Error", "You forgot to enter the path of the Extra Fetch or Archive Folder or the Extra folder name.")
			Return
		Else
			$y = $y + 1
		EndIf
	Else
		$y = $y + 1
		$s_iniextra = 'Fetch=' & @LF & 'Archive=' & @LF & 'Folder_Name='
	EndIf
	$tvfet = BitAND(GUICtrlRead($TV_fet), $Gui_checked) = $Gui_checked
	$movfet = BitAND(GUICtrlRead($Mov_fet), $Gui_checked) = $Gui_checked
	$anifet = BitAND(GUICtrlRead($Anime), $Gui_checked) = $Gui_checked
	$extfet = BitAND(GUICtrlRead($extra), $Gui_checked) = $Gui_checked
	If $tvfet = False And $movfet = False Then
		MsgBox(64, "Error", "Either TV or Movie Fetcher must be configured")
		Return
	Else
		$y = $y + 1
	EndIf
	$tv_verif = BitAND(GUICtrlRead($TVlog_chk), $Gui_checked) = $Gui_checked
	$mov_verif = BitAND(GUICtrlRead($Movlog_chk), $Gui_checked) = $Gui_checked
	$ani_verif = BitAND(GUICtrlRead($Anilog_chk), $Gui_checked) = $Gui_checked
	$ext_verif = BitAND(GUICtrlRead($extlog_chk), $Gui_checked) = $Gui_checked
	$allfet = "TV=" & $tvfet & @LF & "Movies=" & $movfet & @LF & "Anime=" & $anifet & @LF & "Extra=" & $extfet & _
			@LF & "Tvlog=" & $tv_verif & @LF & "Movlog=" & $mov_verif & @LF & "anilog=" & $ani_verif
	If $tv_verif <> $tvfet Then
		MsgBox(64, "Error", "If TV Fetcher is enabled, then TV log must be configured or vice versa.")
		Return
	Else
		$y = $y + 1
	EndIf
	If $mov_verif <> $movfet Then
		MsgBox(64, "Error", "If Movie Fetcher is enabled, then Movie log must be configured or vice versa.")
		Return
	Else
		$y = $y + 1
	EndIf
	If $ani_verif <> $anifet Then
		MsgBox(64, "Error", "If Anime Fetcher is enabled, then Anime log must be configured or vice versa.")
		Return
	Else
		$y = $y + 1
	EndIf
	If $ext_verif <> $extfet Then
		MsgBox(64, "Error", "If Extra Fetcher is enabled, then Extra log must be configured or vice versa.")
		Return
	Else
		$y = $y + 1
	EndIf
	;Log Tab Options--------------------------------------------------------
	If GUICtrlRead($TVlog_chk) = $Gui_checked Then
		$initv2 = GUICtrlRead($TVlogpath)
		$s_initv = "tvlog_path=" & $initv2
		If $initv2 = "" Then
			MsgBox(64, "Error", "TV Log file information missing")
			Return
		Else
			$y = $y + 1
		EndIf
	Else
		$y = $y + 1
		$s_initv = 'tvlog_path='
	EndIf
	If GUICtrlRead($Movlog_chk) = $Gui_checked Then
		$iniMov2 = GUICtrlRead($Movlogpath)
		$s_iniMov = "Movlog_path=" & $iniMov2
		If $iniMov2 = "" Then
			MsgBox(64, "Error", "Movie Log file information missing")
			Return
		Else
			$y = $y + 1
		EndIf
	Else
		$y = $y + 1
		$s_iniMov = 'Movlog_path='
	EndIf
	If GUICtrlRead($Anilog_chk) = $Gui_checked Then
		$iniAni2 = GUICtrlRead($Anilogpath)
		$s_iniAni = "Anilog_path=" & $iniAni2
		If $iniAni2 = "" Then
			MsgBox(64, "Error", "Anime Log file information missing")
			Return
		Else
			$y = $y + 1
		EndIf
	Else
		$y = $y + 1
		$s_iniAni = 'Anilog_path='
	EndIf
	If GUICtrlRead($extlog_chk) = $Gui_checked Then
		$iniext2 = GUICtrlRead($extlogpath)
		$s_iniext = "extlog_path=" & $iniext2
		If $iniext2 = "" Then
			MsgBox(64, "Error", "Extra Log file information missing")
			Return
		Else
			$y = $y + 1
		EndIf
	Else
		$y = $y + 1
		$s_iniext = 'extlog_path='
	EndIf
	GUICtrlSetState($start, $gui_enable)
	TrayItemSetState($startitem, $tray_enable)
	GUICtrlSetState($pauseme, $gui_disable)
	TrayItemSetState($pauseitem, $tray_disable)
EndFunc   ;==>_save


Func _inisave() ; ini Settings Save==========================================================================
	IniWrite(@ScriptDir & "\TRH_settings.ini", "therenamer", "Path", $iniTRpathinfo)
	IniWriteSection(@ScriptDir & "\TRH_settings.ini", "GUI_Mode", $s_iniguimode)
	IniWriteSection(@ScriptDir & "\TRH_settings.ini", "Anime", $s_inianime)
	IniWriteSection(@ScriptDir & "\TRH_settings.ini", "Extra", $s_iniextra)
	IniWriteSection(@ScriptDir & "\TRH_settings.ini", "Active_Sections", $allfet)
	IniWriteSection(@ScriptDir & "\TRH_settings.ini", "Logs", $s_initv & @LF & $s_iniMov & @LF & $s_iniAni & @LF & $s_iniext)
	IniWrite(@ScriptDir & "\TRH_settings.ini", "TV_Movie_Download", "TVPath", GUICtrlRead($tv_fet_input))
	IniWrite(@ScriptDir & "\TRH_settings.ini", "TV_Movie_Download", "MoviePath", GUICtrlRead($mov_fet_input))
	$_GUIMode = IniReadSection(@ScriptDir & "\TRH_settings.ini", "GUI_Mode")
	$_tvDown = IniRead(@ScriptDir & "\TRH_settings.ini", "TV_Movie_Download", "TvPath", "none")
	$_movDown = IniRead(@ScriptDir & "\TRH_settings.ini", "TV_Movie_Download", "MoviePath", "none")
	$TRpath = IniRead(@ScriptDir & "\TRH_settings.ini", "therenamer", "Path", "none")
	$_anifet = IniReadSection(@ScriptDir & "\TRH_settings.ini", "anime")
	$_extfet = IniReadSection(@ScriptDir & "\TRH_settings.ini", "extra")
	$_active = IniReadSection(@ScriptDir & "\TRH_settings.ini", "Active_Sections")
	$_logs = IniReadSection(@ScriptDir & "\TRH_settings.ini", "logs")
	$_Down = IniReadSection(@ScriptDir & "\TRH_settings.ini", "TV_Movie_Download")
	$_gui_pbar = IniRead(@ScriptDir & "\TRH_settings.ini", "GUI_Mode", "Pbar", "False")
EndFunc   ;==>_inisave

Func settings()
	If $TRpath = 'C:\Program Files\theRenamer\theRenamer.exe' Then
		GUICtrlSetState($x86, $Gui_checked + $gui_disable)
	ElseIf $TRpath = 'C:\Program Files (x86)\theRenamer\theRenamer.exe' Then
		GUICtrlSetState($x64, $Gui_checked + $gui_disable)
	ElseIf $TRpath <> "" Then
		GUICtrlSetState($custom, $Gui_checked + $gui_disable)
		GUICtrlSetState($custompath, $gui_enable)
		GUICtrlSetData($custompath, IniRead("TRH_settings.ini", "therenamer", "Path", ""))
		__HoverButtonSetState($Brow_cus, $gui_enable)
	EndIf
	If $_GUIMode[1][1] = "True" Then
		GUICtrlSetState($bar, $Gui_checked)
		GUICtrlSetState($invis, $gui_enable)
	EndIf
	If $_GUIMode[3][1] = "True" Then
		GUICtrlSetState($invis, $Gui_checked)
		GUICtrlSetState($Slider1, $gui_enable)
		GUICtrlSetState($i_perc, $gui_enable)
		GUICtrlSetState($Updown1, $gui_enable)
		GUICtrlSetData($Slider1, $_GUIMode[2][1])
		GUICtrlSetData($i_perc, $_GUIMode[2][1])
	Else
		GUICtrlSetData($Slider1, $_GUIMode[2][1])
		GUICtrlSetData($i_perc, $_GUIMode[2][1])
	EndIf
	If $_active[3][1] = "True" Then
		GUICtrlSetState($Anime, $Gui_checked)
		GUICtrlSetState($ani_fetch, $gui_enable)
		GUICtrlSetState($Ani_arch, $gui_enable)
		GUICtrlSetData($ani_fetch, $_anifet[1][1])
		GUICtrlSetData($Ani_arch, $_anifet[2][1])
		__HoverButtonSetState($Brow_ani_arch, $gui_enable)
		__HoverButtonSetState($Brow_ani_fet, $gui_enable)
	EndIf
	If $_active[4][1] = "True" Then
		GUICtrlSetState($extra, $Gui_checked)
		GUICtrlSetState($ext_fetch, $gui_enable)
		GUICtrlSetState($ext_Arch, $gui_enable)
		GUICtrlSetState($extcontentname, $gui_enable)
		GUICtrlSetData($ext_fetch, $_extfet[1][1])
		GUICtrlSetData($ext_Arch, $_extfet[2][1])
		GUICtrlSetData($extcontentname, $_extfet[3][1])
		__HoverButtonSetState($Brow_ext_arch, $gui_enable)
		__HoverButtonSetState($Brow_ext_fet, $gui_enable)
	EndIf
	If $_active[1][1] = "True" Then
		GUICtrlSetState($TV_fet, $Gui_checked)
		__HoverButtonSetState($changeTVpath, $gui_enable)
		GUICtrlSetData($tv_fet_input, $_tvDown)
	EndIf
	If $_active[2][1] = "True" Then
		GUICtrlSetState($Mov_fet, $Gui_checked)
		__HoverButtonSetState($changeMovpath, $gui_enable)
		GUICtrlSetData($mov_fet_input, $_movDown)
	EndIf
	If $_logs[1][1] <> "" Then
		GUICtrlSetState($TVlogpath, $gui_enable)
		GUICtrlSetState($TVlog_chk, $Gui_checked)
		GUICtrlSetData($TVlogpath, $_logs[1][1])
		__HoverButtonSetState($Brow_Tvlog, $gui_enable)
		GUICtrlSetState($tvb, $gui_enable)
		TrayItemSetState($tvitem, $tray_enable)
	EndIf
	If $_logs[2][1] <> "" Then
		GUICtrlSetState($Movlogpath, $gui_enable)
		GUICtrlSetState($Movlog_chk, $Gui_checked)
		GUICtrlSetData($Movlogpath, $_logs[2][1])
		__HoverButtonSetState($Brow_movlog, $gui_enable)
		GUICtrlSetState($movieb, $gui_enable)
		TrayItemSetState($movitem, $tray_enable)
	EndIf
	If $_logs[3][1] <> "" Then
		GUICtrlSetState($Anilogpath, $gui_enable)
		GUICtrlSetState($Anilog_chk, $Gui_checked)
		GUICtrlSetData($Anilogpath, $_logs[3][1])
		__HoverButtonSetState($Brow_anilog, $gui_enable)
		GUICtrlSetState($animeb, $gui_enable)
		TrayItemSetState($aniitem, $tray_enable)
	EndIf
	If $_logs[4][1] <> "" Then
		GUICtrlSetState($extlogpath, $gui_enable)
		GUICtrlSetState($extlog_chk, $Gui_checked)
		GUICtrlSetData($extlogpath, $_logs[4][1])
		__HoverButtonSetState($Brow_extlog, $gui_enable)
		GUICtrlSetState($extrab, $gui_enable)
		TrayItemSetState($extitem, $tray_enable)
	EndIf
EndFunc   ;==>settings

Func _Monitor()
	; Movie Variables-------------------------------------------------------------------------
	$movie_down = $_Down[2][1]
	$movielog = $_logs[2][1]
	; TV Variables-------------------------------------------------------------------------
	$tv_down = $_Down[1][1]
	$tvlog = $_logs[1][1]

	; Anime Variables-------------------------------------------------------------------------
	$anime_down = $_anifet[1][1]
	$animes = $_anifet[2][1]
	$animelog = $_logs[3][1]

	; Extra Variables-------------------------------------------------------------------------
	$extra_down = $_extfet[1][1]
	$extras = $_extfet[2][1]
	$extralog = $_logs[4][1]

	; TheRenamer-------------------------------------------------------------------------
	$renamerpath = $TRpath
	$renamerlog = @MyDocumentsDir & "\theRenamer\log.txt"
	If @MDAY >= 01 And @MDAY <= 09 Then
		$historylog = @MyDocumentsDir & "\theRenamer\History\" & _DateToMonth(@MON, 1) & "." & StringRight(@MDAY, 1) & ".log"
	Else
		$historylog = @MyDocumentsDir & "\theRenamer\History\" & _DateToMonth(@MON, 1) & "." & @MDAY & ".log"
	EndIf
	$fetchTV = $renamerpath & " -fetch"
	$fetchmovie = $renamerpath & " -fetchmovie"
	$fetchanime = $renamerpath & " -fetch -ff=" & '"' & $anime_down & '"' & " -af=" & '"' & $animes & '"'
	$fetchextra = $renamerpath & " -fetch -ff=" & '"' & $extra_down & '"' & " -af=" & '"' & $extras & '"'
	If $_extfet[3][1] = "" Then
		GUICtrlSetData($extrab, "Extra Log")
	Else
		GUICtrlSetData($extrab, $_extfet[3][1] & " Log")
	EndIf

;~ 	EndIf
	$state = WinGetState($TRH_GUI, "")
	ConsoleWrite($state & @CRLF) ;<=== Debug
	;##################Main Operations#####################################
	Do
		ConsoleWrite("Start monitoring" & @CRLF & "Mode : " & $_GUIMode[1][1] & @CRLF) ; <==== Debug
		;Delete History log if it Exsist
		If FileExists($historylog) Then FileDelete($historylog)

		;Check log sizes and delete if logs is 50MB or more
		Local $max[5][2] = [["$tvlog", FileGetSize($tvlog)],["$movlog", FileGetSize($movielog)],["$animelog", FileGetSize($animelog)], _
				["$extralog", FileGetSize($extralog)],["", 52428800]]
		Local $s

		For $s = 0 To 4 - 1
			If $max[$s][1] >= $max[4][1] Then
				FileDelete($max[$s][0])
			EndIf
		Next
		If $Runf = False Then ExitLoop
		If $pausef = True Then _pause()
		If $state = "5" Or $state = "0" Or $state = "0" Then
			If $_GUIMode[1][1] = "True" Then
				_ProgressSet($progOn, Round(1 / 9 * 100, 0), "", "Checking log size done")
				Sleep(1000)
			Else
				Sleep(1000)
			EndIf
		Else
			_ProgressSet($Progress1, Round(1 / 9 * 100, 0), Round(1 / 9 * 100, 0) & ' percent', "Checking log size done")
			Sleep(1000)
		EndIf
		;===Fetching==============================

		;TVshow Fetching-------------------------------------------------------
		If $_active[1][1] = "True" Then
			$Hasfiles = _RecFileListToArray($tv_down, "*.avi;*.mp4;*.mkv", 1, 1, 0, 0)
			$state = WinGetState($TRH_GUI, "")
			If IsArray($Hasfiles) And StringRegExp($Hasfiles[1], ".*(\.avi|\.mkv|\.mp4)\z") = 1 Then
				If $state = "5" Or $state = "0" Or $state = "0" Then
					If $_GUIMode[1][1] = "True" Then _ProgressSet($progOn, Round(1 / 9 * 100, 0), "", "Running TheRenamer TV")
				Else
					_ProgressSet($Progress1, Round(1 / 9 * 100, 0), Round(1 / 9 * 100, 0) & ' percent', "Running TheRenamer TV")
				EndIf
				RunWait($fetchTV)
				If $state = "5" Or $state = "0" Or $state = "0" Then
					If $_GUIMode[1][1] = "True" Then
						_ProgressSet($progOn, Round(2 / 9 * 100, 0), "", "Finish TheRenamer TV")
						Sleep(1000)
					Else
						Sleep(1000)
					EndIf
				Else
					_ProgressSet($Progress1, Round(2 / 9 * 100, 0), Round(2 / 9 * 100, 0) & ' percent', "Finish TheRenamer TV")
					Sleep(1000)
				EndIf
				If $Runf = False Then ExitLoop
				If $pausef = True Then _pause()
				If $state = "5" Or $state = "0" Or $state = "0" Then
					If $_GUIMode[1][1] = "True" Then
						_ProgressSet($progOn, Round(2 / 9 * 100, 0), "", "Updating TV Logs")
						Sleep(1000)
					Else
						Sleep(1000)
					EndIf
				Else
					_ProgressSet($Progress1, Round(2 / 9 * 100, 0), Round(2 / 9 * 100, 0) & ' percent', "Updating TV Logs")
					Sleep(1000)
				EndIf
				$file1 = FileRead($renamerlog)
				$file2 = FileOpen($tvlog, 1)
				$file3 = FileRead($historylog)
				;URL for following expression: http://www.autoitscript.com/forum/topic/133363-remove-blank-lines-in-a-file/
				$sRtn = StringReplace(StringRegExpReplace(StringRegExpReplace($file3, "(\v)+", @CRLF), "(^\v*)|(\v*\Z)", ""), "######################## END Session", "")
				FileWriteLine($file2, "############ " & @MDAY & "/" & @MON & "/" & @YEAR & "############ " & @CRLF)
				FileWriteLine($file2, "############ " & @HOUR & "h:" & @MIN & "############ " & @CRLF)
				FileWriteLine($file2, $sRtn)
				FileWriteLine($file2, $file1)
				FileClose($file2)
				FileDelete($historylog)
				If $state = "5" Or $state = "0" Or $state = "0" Then
					If $_GUIMode[1][1] = "True" Then
						_ProgressSet($progOn, Round(3 / 9 * 100, 0), "", "Finish Updating TV Logs")
						Sleep(1000)
					Else
						Sleep(1000)
					EndIf
				Else
					_ProgressSet($Progress1, Round(3 / 9 * 100, 0), Round(3 / 9 * 100, 0) & ' percent', "Finish Updating TV Logs")
					Sleep(1000)
				EndIf
				If $Runf = False Then ExitLoop
				If $pausef = True Then _pause()
			Else
				If $state = "5" Or $state = "0" Then
					If $_GUIMode[1][1] = "True" Then
						_ProgressSet($progOn, Round(3 / 9 * 100, 0), "", "No TV Shows Added")
						Sleep(1000)
					Else
						Sleep(1000)
					EndIf
				Else
					_ProgressSet($Progress1, Round(3 / 9 * 100, 0), Round(3 / 9 * 100, 0) & ' percent', "No TV Shows Added")
					Sleep(1000)
				EndIf
				If $Runf = False Then ExitLoop
				If $pausef = True Then _pause()
			EndIf
		Else
			If $state = "5" Or $state = "0" Then
				If $_GUIMode[1][1] = "True" Then
					_ProgressSet($progOn, Round(3 / 9 * 100, 0), "")
					Sleep(1000)
				Else
					Sleep(1000)
				EndIf
			Else
				_ProgressSet($Progress1, Round(3 / 9 * 100, 0), Round(3 / 9 * 100, 0) & ' percent')
				Sleep(1000)
			EndIf
		EndIf

		;Movie Fetching-----------------------------------------------------------------
		If $_active[2][1] = "True" Then
			$Hasfiles = _RecFileListToArray($movie_down, "*.avi;*.mp4;*.mkv", 1, 1, 0, 0)
			If IsArray($Hasfiles) And StringRegExp($Hasfiles[1], ".*(\.avi|\.mkv|\.mp4)\z") = 1 Then
				If $state = "5" Or $state = "0" Then
					If $_GUIMode[1][1] = "True" Then _ProgressSet($progOn, "", "Running TheRenamer Movie")
				Else
					_ProgressSet($Progress1, Round(3 / 9 * 100, 0), Round(3 / 9 * 100, 0) & ' percent', "Running TheRenamer Movie")
				EndIf
				RunWait($fetchmovie)
				If $state = "5" Or $state = "0" Then
					If $_GUIMode[1][1] = "True" Then
						_ProgressSet($progOn, Round(4 / 9 * 100, 0), "", "Finish TheRenamer Movie")
						Sleep(1000)
					Else
						Sleep(1000)
					EndIf
				Else
					_ProgressSet($Progress1, Round(4 / 9 * 100, 0), Round(4 / 9 * 100, 0) & ' percent', "Finish TheRenamer Movie")
					Sleep(1000)
				EndIf
				If $Runf = False Then ExitLoop
				If $pausef = True Then _pause()
				If $state = "5" Or $state = "0" Then
					If $_GUIMode[1][1] = "True" Then
						_ProgressSet($progOn, Round(4 / 9 * 100, 0), "", "Updating Movie Logs")
						Sleep(1000)
					Else
						Sleep(1000)
					EndIf
				Else
					_ProgressSet($Progress1, Round(4 / 9 * 100, 0), Round(4 / 9 * 100, 0) & ' percent', "Updating Movie Logs")
					Sleep(1000)
				EndIf
				$file1 = FileRead($renamerlog)
				$file2 = FileOpen($movielog, 1)
				$file3 = FileRead($historylog)
				;URL for following expression: http://www.autoitscript.com/forum/topic/133363-remove-blank-lines-in-a-file/
				$sRtn = StringReplace(StringRegExpReplace(StringRegExpReplace($file3, "(\v)+", @CRLF), "(^\v*)|(\v*\Z)", ""), "######################## END Session", "")
				FileWriteLine($file2, "############ " & @MDAY & "/" & @MON & "/" & @YEAR & "############ " & @CRLF)
				FileWriteLine($file2, "############ " & @HOUR & "h:" & @MIN & "############ " & @CRLF)
				FileWriteLine($file2, $sRtn)
				FileWriteLine($file2, $file1)
				FileClose($file2)
				FileDelete($historylog)
				If $state = "5" Or $state = "0" Then
					If $_GUIMode[1][1] = "True" Then
						_ProgressSet($progOn, Round(5 / 9 * 100, 0), "", "Finish Updating Movie Logs")
						Sleep(1000)
					Else
						Sleep(1000)
					EndIf
				Else
					_ProgressSet($Progress1, Round(5 / 9 * 100, 0), Round(5 / 9 * 100, 0) & ' percent', "Finish Updating Movie Logs")
					Sleep(1000)
				EndIf
				If $Runf = False Then ExitLoop
				If $pausef = True Then _pause()
			Else
				If $state = "5" Or $state = "0" Then
					If $_GUIMode[1][1] = "True" Then
						_ProgressSet($progOn, Round(5 / 9 * 100, 0), "", "No Movies Added")
						Sleep(1000)
					Else
						Sleep(1000)
					EndIf
				Else
					_ProgressSet($Progress1, Round(5 / 9 * 100, 0), Round(5 / 9 * 100, 0) & ' percent', "No Movies Added")
					Sleep(1000)
				EndIf
				If $Runf = False Then ExitLoop
				If $pausef = True Then _pause()
			EndIf
		Else
			If $state = "5" Or $state = "0" Then
				If $_GUIMode[1][1] = "True" Then
					_ProgressSet($progOn, Round(5 / 9 * 100, 0), "")
					Sleep(1000)
				Else
					Sleep(1000)
				EndIf
			Else
				_ProgressSet($Progress1, Round(5 / 9 * 100, 0), Round(5 / 9 * 100, 0) & ' percent')
				Sleep(1000)
			EndIf
		EndIf

		;Anime Fetching----------------------------------------------------------------
		If $_active[3][1] = "True" Then
			$Hasfiles = _RecFileListToArray($anime_down, "*.avi;*.mp4;*.mkv", 1, 1, 0, 0)
			If IsArray($Hasfiles) And StringRegExp($Hasfiles[1], ".*(\.avi|\.mkv|\.mp4)\z") = 1 Then
				If $state = "5" Or $state = "0" Then
					If $_GUIMode[1][1] = "True" Then _ProgressSet($progOn, Round(5 / 9 * 100, 0), "", "Running TheRenamer Anime")
				Else
					_ProgressSet($Progress1, Round(5 / 9 * 100, 0), Round(5 / 9 * 100, 0) & ' percent', "Running TheRenamer Anime")
				EndIf
				RunWait($fetchanime)
				If $state = "5" Or $state = "0" Then
					If $_GUIMode[1][1] = "True" Then
						_ProgressSet($progOn, Round(6 / 9 * 100, 0), "", "Finish TheRenamer Anime")
						Sleep(1000)
					Else
						Sleep(1000)
					EndIf
				Else
					_ProgressSet($Progress1, Round(6 / 9 * 100, 0), Round(6 / 9 * 100, 0) & ' percent', "Finish TheRenamer Anime")
					Sleep(1000)
				EndIf
				If $Runf = False Then ExitLoop
				If $pausef = True Then _pause()
				If $state = "5" Or $state = "0" Then
					If $_GUIMode[1][1] = "True" Then
						_ProgressSet($progOn, Round(6 / 9 * 100, 0), "", "Updating Anime Logs")
						Sleep(1000)
					Else
						Sleep(1000)
					EndIf
				Else
					_ProgressSet($Progress1, Round(6 / 9 * 100, 0), Round(6 / 9 * 100, 0) & ' percent', "Updating Anime Logs")
					Sleep(1000)
				EndIf
				$file1 = FileRead($renamerlog)
				$file2 = FileOpen($animelog, 1)
				$file3 = FileRead($historylog)
				;URL for following expression: http://www.autoitscript.com/forum/topic/133363-remove-blank-lines-in-a-file/
				$sRtn = StringReplace(StringRegExpReplace(StringRegExpReplace($file3, "(\v)+", @CRLF), "(^\v*)|(\v*\Z)", ""), "######################## END Session", "")
				FileWriteLine($file2, "############ " & @MDAY & "/" & @MON & "/" & @YEAR & "############ " & @CRLF)
				FileWriteLine($file2, "############ " & @HOUR & "h:" & @MIN & "############ " & @CRLF)
				FileWriteLine($file2, $sRtn)
				FileWriteLine($file2, $file1)
				FileClose($file2)
				FileDelete($historylog)
				If $state = "5" Or $state = "0" Then
					If $_GUIMode[1][1] = "True" Then
						_ProgressSet($progOn, Round(7 / 9 * 100, 0), "", "Finish Updating Anime Logs")
						Sleep(1000)
					Else
						Sleep(1000)
					EndIf
				Else
					_ProgressSet($Progress1, Round(7 / 9 * 100, 0), Round(7 / 9 * 100, 0) & ' percent', "Finish Updating Anime Logs")
					Sleep(1000)
				EndIf
				If $Runf = False Then ExitLoop
				If $pausef = True Then _pause()
			Else
				If $state = "5" Or $state = "0" Then
					If $_GUIMode[1][1] = "True" Then
						_ProgressSet($progOn, Round(7 / 9 * 100, 0), "", "No Anime Added")
						Sleep(1000)
					Else
						Sleep(1000)
					EndIf
				Else
					_ProgressSet($Progress1, Round(7 / 9 * 100, 0), Round(7 / 9 * 100, 0) & ' percent', "No Anime Added")
					Sleep(1000)
				EndIf
				If $Runf = False Then ExitLoop
				If $pausef = True Then _pause()
			EndIf
		Else
			If $state = "5" Or $state = "0" Then
				If $_GUIMode[1][1] = "True" Then
					_ProgressSet($progOn, Round(7 / 9 * 100, 0), "")
					Sleep(1000)
				Else
					Sleep(1000)
				EndIf
			Else
				_ProgressSet($Progress1, Round(7 / 9 * 100, 0), Round(7 / 9 * 100, 0) & ' percent')
				Sleep(1000)
			EndIf
		EndIf

		;Extra Fetching-------------------------------------------------------------
		If $_active[4][1] = "True" Then
			$Hasfiles = _RecFileListToArray($extra_down, "*.avi;*.mp4;*.mkv", 1, 1, 0, 0)
			If IsArray($Hasfiles) And StringRegExp($Hasfiles[1], ".*(\.avi|\.mkv|\.mp4)\z") = 1 Then
				If $state = "5" Or $state = "0" Then
					If $_GUIMode[1][1] = "True" Then _ProgressSet($progOn, Round(7 / 9 * 100, 0), "", "Running TheRenamer " & $_extfet[3][1])
				Else
					_ProgressSet($Progress1, Round(7 / 9 * 100, 0), Round(7 / 9 * 100, 0) & ' percent', "Running TheRenamer " & $_extfet[3][1])
				EndIf
				RunWait($fetchextra)
				If $state = "5" Or $state = "0" Then
					If $_GUIMode[1][1] = "True" Then
						_ProgressSet($progOn, Round(8 / 9 * 100, 0), "", "Finish TheRenamer " & $_extfet[3][1])
						Sleep(1000)
					Else
						Sleep(1000)
					EndIf
				Else
					_ProgressSet($Progress1, Round(8 / 9 * 100, 0), Round(8 / 9 * 100, 0) & ' percent', "Finish TheRenamer " & $_extfet[3][1])
					Sleep(1000)
				EndIf
				If $Runf = False Then ExitLoop
				If $pausef = True Then _pause()
				If $state = "5" Or $state = "0" Then
					If $_GUIMode[1][1] = "True" Then
						_ProgressSet($progOn, Round(8 / 9 * 100, 0), "", "Updating " & $_extfet[3][1] & " Logs")
						Sleep(1000)
					Else
						Sleep(1000)
					EndIf
				Else
					_ProgressSet($Progress1, Round(8 / 9 * 100, 0), Round(8 / 9 * 100, 0) & ' percent', "Updating " & $_extfet[3][1] & " Logs")
					Sleep(1000)
				EndIf
				$file1 = FileRead($renamerlog)
				$file2 = FileOpen($extralog, 1)
				$file3 = FileRead($historylog)
				;URL for following expression: http://www.autoitscript.com/forum/topic/133363-remove-blank-lines-in-a-file/
				$sRtn = StringReplace(StringRegExpReplace(StringRegExpReplace($file3, "(\v)+", @CRLF), "(^\v*)|(\v*\Z)", ""), "######################## END Session", "")
				FileWriteLine($file2, "############ " & @MDAY & "/" & @MON & "/" & @YEAR & "############ " & @CRLF)
				FileWriteLine($file2, "############ " & @HOUR & "h:" & @MIN & "############ " & @CRLF)
				FileWriteLine($file2, $sRtn)
				FileWriteLine($file2, $file1)
				FileClose($file2)
				FileDelete($historylog)
				If $state = "5" Or $state = "0" Then
					If $_GUIMode[1][1] = "True" Then
						_ProgressSet($progOn, Round(9 / 9 * 100, 0), "", "Finish Updating " & $_extfet[3][1] & " Logs")
						Sleep(1000)
					Else
						Sleep(1000)
					EndIf
				Else
					_ProgressSet($Progress1, Round(9 / 9 * 100, 0), Round(9 / 9 * 100, 0) & ' percent', "Finish Updating " & $_extfet[3][1] & " Logs")
					Sleep(1000)
				EndIf
				If $Runf = False Then ExitLoop
				If $pausef = True Then _pause()
			Else
				If $state = "5" Or $state = "0" Then
					If $_GUIMode[1][1] = "True" Then
						_ProgressSet($progOn, Round(9 / 9 * 100, 0), "", "No " & $_extfet[3][1] & " Added")
						Sleep(1000)
					Else
						Sleep(1000)
					EndIf
				Else
					_ProgressSet($Progress1, Round(9 / 9 * 100, 0), Round(9 / 9 * 100, 0) & ' percent', "No " & $_extfet[3][1] & " Added")
					Sleep(1000)
				EndIf
				If $Runf = False Then ExitLoop
				If $pausef = True Then _pause()
			EndIf
		Else
			If $state = "5" Or $state = "0" Then
				If $_GUIMode[1][1] = "True" Then
					_ProgressSet($progOn, Round(9 / 9 * 100, 0), "")
					Sleep(1000)
				Else
					Sleep(1000)
				EndIf
			Else
				_ProgressSet($Progress1, Round(9 / 9 * 100, 0), Round(9 / 9 * 100, 0) & ' percent')
				Sleep(1000)
			EndIf
		EndIf
		;===End of Fetching==================================================

		;===Kill Therenamer if its still running=================
		$PID = ProcessExists("theRenamer.exe")
		If $PID Then ProcessClose($PID)
		;========================================================
		If $Runf = False Then ExitLoop
		If $pausef = True Then _pause()
	Until $Runf = False
EndFunc   ;==>_Monitor
;##########End Of Main Operation#############################

Func _actions()
	If WinActive($TRH_GUI) Then
		If __HoverWaitButtonUp($TRH_GUI) Then Return
	EndIf
	If WinActive($TRH_opt_GUI) Then
		If __HoverWaitButtonUp($TRH_opt_GUI) Then Return
	EndIf
	Switch @GUI_CtrlId
		;Main GUI----------
		Case $start[0]
			If $_tvDown = "none" And $_movDown = "none" Then
				$Runf = False
			Else
				$Runf = True
				__HoverButtonSetState($start, $gui_disable)
				__HoverButtonSetState($stop, $gui_enable)
				TrayItemSetState($stopitem, $tray_enable)
				TrayItemSetState($startitem, $tray_disable)
				__HoverButtonSetState($pauseme, $gui_enable)
				TrayItemSetState($pauseitem, $tray_enable)
			EndIf
		Case $stop[0]
			$Runf = False
			__HoverButtonSetState($start, $gui_enable)
			__HoverButtonSetState($stop, $gui_disable)
			TrayItemSetState($stopitem, $tray_disable)
			TrayItemSetState($startitem, $tray_enable)
			__HoverButtonSetState($pauseme, $gui_disable)
			TrayItemSetState($pauseitem, $tray_disable)
		Case $pauseme[0]
			If $Runf = True Then
				$pausef = True
				__HoverButtonSetState($stop, $gui_disable)
				TrayItemSetState($stopitem, $tray_disable)
				TrayItemSetState($pauseitem, $tray_disable)
				TrayItemSetState($unpauseitem, $tray_enable)
			EndIf
		Case $tvb[0]
			ShellExecute($tvlog)
		Case $movieb[0]
			ShellExecute($movielog)
		Case $animeb[0]
			ShellExecute($animelog)
		Case $extrab[0]
			ShellExecute($extralog)
		;End of Main GUI------------
		Case $XIcon[1]
			XSkinAnimate($TRH_GUI, 1, 12)
			Exit
		Case $XIcon_opt[1]
			If Not FileExists(@ScriptDir & "\TRH_settings.ini") Then
				GUISetState(@SW_ENABLE, $TRH_GUI)
				GUIDelete($TRH_opt_GUI)
			Else
				_exit()
			EndIf
		Case $XIcon[2]
			GUISetState(@SW_MINIMIZE, $TRH_GUI)
		Case $XIcon_opt[2]
			GUISetState(@SW_MINIMIZE, $TRH_opt_GUI)
		;General Tab options-------------------------------
		Case $custom
			If $win = $Gui_checked Then
				GUICtrlSetState($x86, $GUI_UNCHECKED + $gui_enable)
				GUICtrlSetState($x64, $GUI_UNCHECKED + $gui_enable)
				GUICtrlSetState($custom, $gui_disable)
				GUICtrlSetState($custompath, $gui_enable)
				__HoverButtonSetState($Brow_cus, $gui_enable)
			EndIf
		Case $Brow_cus[0] ; Button (Browse)
			$txt = FileOpenDialog("TheRenamer.exe Location", @HomeDrive, "Executable Files (TheRenamer.exe)")
			GUICtrlSetData($custompath, $txt)
		Case $x86
			If $win64cus = $Gui_checked Then
				GUICtrlSetState($custom, $GUI_UNCHECKED + $gui_enable)
				GUICtrlSetState($x64, $GUI_UNCHECKED + $gui_enable)
				GUICtrlSetState($custompath, $gui_disable)
				__HoverButtonSetState($Brow_cus, $gui_disable)
				GUICtrlSetState($x86, $gui_disable)
			EndIf
		Case $x64
			If $win86cus = $Gui_checked Then
				GUICtrlSetState($custom, $GUI_UNCHECKED + $gui_enable)
				GUICtrlSetState($x86, $GUI_UNCHECKED + $gui_enable)
				GUICtrlSetState($custompath, $gui_disable)
				__HoverButtonSetState($Brow_cus, $gui_disable)
				GUICtrlSetState($x64, $gui_disable)
			EndIf
		Case $bar
			If GUICtrlRead($bar) = $Gui_checked Then
				GUICtrlSetState($invis, $gui_enable)
			ElseIf GUICtrlRead($bar) = $GUI_UNCHECKED Then
				GUICtrlSetState($invis, $gui_disable)
				GUICtrlSetState($Slider1, $gui_disable)
				GUICtrlSetState($i_perc, $gui_disable)
				GUICtrlSetState($Updown1, $gui_disable)
			EndIf
		Case $invis
			If GUICtrlRead($invis) = $Gui_checked Then
				GUICtrlSetState($Slider1, $gui_enable)
				GUICtrlSetState($i_perc, $gui_enable)
				GUICtrlSetState($Updown1, $gui_enable)
			ElseIf GUICtrlRead($invis) = $GUI_UNCHECKED Then
				GUICtrlSetState($Slider1, $gui_disable)
				GUICtrlSetState($i_perc, $gui_disable)
				GUICtrlSetState($Updown1, $gui_disable)
			EndIf
		Case $i_perc, $Updown1
			GUICtrlSetData($Slider1, GUICtrlRead($i_perc))
		Case GUICtrlRead($Slider1) <> $last_perc
			$perc = GUICtrlRead($Slider1)
			$last_perc = $perc
			GUICtrlSetData($i_perc, $perc)
		;End General Tab options-------------------------------

		;Fetchching Tab-------------------------------------
		Case $Anime
			If GUICtrlRead($Anime) = $Gui_checked Then
				GUICtrlSetState($ani_fetch, $gui_enable)
				GUICtrlSetState($Ani_arch, $gui_enable)
				__HoverButtonSetState($Brow_ani_arch, $gui_enable)
				__HoverButtonSetState($Brow_ani_fet, $gui_enable)
			Else
				GUICtrlSetState($ani_fetch, $gui_disable)
				GUICtrlSetData($ani_fetch, "")
				GUICtrlSetState($Ani_arch, $gui_disable)
				GUICtrlSetData($Ani_arch, "")
				__HoverButtonSetState($Brow_ani_arch, $gui_disable)
				__HoverButtonSetState($Brow_ani_fet, $gui_disable)
			EndIf
		Case $Brow_ani_arch[0] ; Button (...)
			$txt = FileSelectFolder("Select Anime Archive folder", "", 4)
			GUICtrlSetData($Ani_arch, $txt)
		Case $Brow_ani_fet[0] ; Button (...)
			$txt = FileSelectFolder("Select Anime Fetch folder", "", 4)
			GUICtrlSetData($ani_fetch, $txt)
		Case $extra
			If GUICtrlRead($extra) = $Gui_checked Then
				GUICtrlSetState($ext_fetch, $gui_enable)
				GUICtrlSetState($ext_Arch, $gui_enable)
				GUICtrlSetState($extcontentname, $gui_enable)
				__HoverButtonSetState($Brow_ext_arch, $gui_enable)
				__HoverButtonSetState($Brow_ext_fet, $gui_enable)
			Else
				GUICtrlSetState($ext_fetch, $gui_disable)
				GUICtrlSetData($ext_fetch, "")
				GUICtrlSetState($ext_Arch, $gui_disable)
				GUICtrlSetData($ext_Arch, "")
				GUICtrlSetState($extcontentname, $gui_disable)
				GUICtrlSetData($extcontentname, "Name of your Extra folder")
				__HoverButtonSetState($Brow_ext_arch, $gui_disable)
				__HoverButtonSetState($Brow_ext_fet, $gui_disable)
			EndIf
		Case $Brow_ext_arch[0] ; Button (...)
			$txt = FileSelectFolder("Select Extra Archive folder", "", 4)
			GUICtrlSetData($ext_Arch, $txt)
		Case $Brow_ext_fet[0] ; Button (...)
			$txt = FileSelectFolder("Select Extra Fetch folder", "", 4)
			GUICtrlSetData($ext_fetch, $txt)
		Case $TV_fet
			If GUICtrlRead($TV_fet) = $Gui_checked Then
				__HoverButtonSetState($changeTVpath, $gui_enable)
			Else
				__HoverButtonSetState($changeTVpath, $gui_disable)
				GUICtrlSetData($tv_fet_input, "")
			EndIf
		Case $changeTVpath[0] ; Button (...)
			$tv_txt = FileSelectFolder("TV Fetch Folder", "", 4)
			GUICtrlSetData($tv_fet_input, $tv_txt)
		Case $Mov_fet
			If GUICtrlRead($Mov_fet) = $Gui_checked Then
				__HoverButtonSetState($changeMovpath, $gui_enable)
			Else
				__HoverButtonSetState($changeMovpath, $gui_disable)
				GUICtrlSetData($mov_fet_input, "")
			EndIf
		Case $changeMovpath[0] ; Button (...)
			$mov_txt = FileSelectFolder("Movie Fetch Folder", "", 4)
			GUICtrlSetData($mov_fet_input, $mov_txt)
		;End Fetchching Tab-------------------------------------

		;Log Tab----------------------------------------------
		Case $TVlog_chk
			If GUICtrlRead($TVlog_chk) = $Gui_checked Then
				GUICtrlSetState($TVlogpath, $gui_enable)
				__HoverButtonSetState($Brow_Tvlog, $gui_enable)
				GUICtrlSetState($tvb, $gui_enable)
				TrayItemSetState($tvitem, $tray_enable)
			Else
				GUICtrlSetState($TVlogpath, $gui_disable)
				GUICtrlSetData($TVlogpath, "")
				__HoverButtonSetState($Brow_Tvlog, $gui_disable)
				GUICtrlSetState($tvb, $gui_disable)
				TrayItemSetState($tvitem, $tray_disable)
			EndIf
		Case $Brow_Tvlog[0] ; Button (...)
			$txt = FileOpenDialog("Log Location", @HomeDrive, "Both types (*.txt;*.log)|Log File (*.log)|Text File (*.txt)")
			GUICtrlSetData($TVlogpath, $txt)
		Case $Movlog_chk
			If GUICtrlRead($Movlog_chk) = $Gui_checked Then
				GUICtrlSetState($Movlogpath, $gui_enable)
				__HoverButtonSetState($Brow_movlog, $gui_enable)
				GUICtrlSetState($movieb, $gui_enable)
				TrayItemSetState($movitem, $tray_enable)
			Else
				GUICtrlSetState($Movlogpath, $gui_disable)
				GUICtrlSetData($Movlogpath, "")
				__HoverButtonSetState($Brow_movlog, $gui_disable)
				GUICtrlSetState($movieb, $gui_disable)
				TrayItemSetState($movitem, $tray_disable)
			EndIf
		Case $Brow_movlog[0] ; Button (...)
			$txt = FileOpenDialog("Log Location", @HomeDrive, "Both types (*.txt;*.log)|Log File (*.log)|Text File (*.txt)")
			GUICtrlSetData($Movlogpath, $txt)
		Case $Anilog_chk
			If GUICtrlRead($Anilog_chk) = $Gui_checked Then
				GUICtrlSetState($Anilogpath, $gui_enable)
				__HoverButtonSetState($Brow_anilog, $gui_enable)
				GUICtrlSetState($animeb, $gui_enable)
				TrayItemSetState($aniitem, $tray_enable)
			Else
				GUICtrlSetState($Anilogpath, $gui_disable)
				GUICtrlSetData($Anilogpath, "")
				__HoverButtonSetState($Brow_anilog, $gui_disable)
				GUICtrlSetState($animeb, $gui_disable)
				TrayItemSetState($aniitem, $tray_enable)
			EndIf
		Case $Brow_anilog[0] ; Button (...)
			$txt = FileOpenDialog("Log Location", @HomeDrive, "Both types (*.txt;*.log)|Log File (*.log)|Text File (*.txt)")
			GUICtrlSetData($Anilogpath, $txt)
		Case $extlog_chk
			If GUICtrlRead($extlog_chk) = $Gui_checked Then
				GUICtrlSetState($extlogpath, $gui_enable)
				__HoverButtonSetState($Brow_extlog, $gui_enable)
				GUICtrlSetState($extrab, $gui_enable)
				TrayItemSetState($extitem, $tray_enable)
			Else
				GUICtrlSetState($extlogpath, $gui_disable)
				GUICtrlSetData($extlogpath, "")
				__HoverButtonSetState($Brow_extlog, $gui_disable)
				GUICtrlSetState($extrab, $gui_disable)
				TrayItemSetState($extitem, $tray_disable)
			EndIf
		Case $Brow_extlog[0] ; Button (...)
			$extlog_txt = FileOpenDialog("Log Location", @HomeDrive, "Both types (*.txt;*.log)|Log File (*.log)|Text File (*.txt)")
			GUICtrlSetData($extlogpath, $extlog_txt)
		;End Log Tab----------------------------------------------

		;Option Menu button actions--------------
		Case $Ok[0]
			_save()
			If $y = 11 Then
				_inisave()
				$y = 0
				_exit()
			Else
				$y = 0
			EndIf
		Case $Cancel[0]
			$y = 0
			If Not FileExists(@ScriptDir & "\TRH_settings.ini") Then
				GUISetState(@SW_ENABLE, $TRH_GUI)
				GUIDelete($TRH_opt_GUI)
			Else
				_exit()
			EndIf
		;End Option Menu button actions--------------
	EndSwitch
EndFunc   ;==>_actions

Func _Trayitems(); Tray Commands-----------------------------------
	Switch @TRAY_ID
		Case $startitem
			If $_Down[1][1] = "" And $_Down[2][1] = "" Then
				$Runf = False
				GUICtrlSetState($stop, $gui_disable)
			Else
				$Runf = True
				GUICtrlSetState($start, $gui_disable)
				GUICtrlSetState($stop, $gui_enable)
				TrayItemSetState($stopitem, $tray_enable)
				TrayItemSetState($startitem, $tray_disable)
				GUICtrlSetState($pauseme, $gui_enable)
				TrayItemSetState($pauseitem, $tray_enable)
				If $_GUIMode[1][1] = "True" Then TrayItemSetText($silentitem, "Status: Running")
			EndIf
		Case $stopitem
			$Runf = False
			GUICtrlSetState($start, $gui_enable)
			GUICtrlSetState($stop, $gui_disable)
			TrayItemSetState($stopitem, $tray_disable)
			TrayItemSetState($startitem, $tray_enable)
			GUICtrlSetState($pauseme, $gui_disable)
			TrayItemSetState($pauseitem, $tray_disable)
			If $_GUIMode[1][1] = "True" Then TrayItemSetText($silentitem, "Status: Stopped")
		Case $pauseitem
			If $Runf = True Then
				$pausef = True
				GUICtrlSetState($stop, $gui_disable)
				TrayItemSetState($stopitem, $tray_disable)
				TrayItemSetState($pauseitem, $tray_disable)
				TrayItemSetState($unpauseitem, $tray_enable)
				If $_GUIMode[1][1] = "True" Then TrayItemSetText($silentitem, "Status: Paused")
			EndIf
		Case $tvitem
			ShellExecute($tvlog)
		Case $movitem
			ShellExecute($movielog)
		Case $aniitem
			ShellExecute($animelog)
		Case $extitem
			ShellExecute($extralog)
		Case $exititem
			$barpos = WinGetPos($prog_gui)
			IniWrite(@ScriptDir & "\Position.ini", "Progress_Position", "X-Pos", $barpos[0])
			IniWrite(@ScriptDir & "\Position.ini", "Progress_Position", "Y-Pos", $barpos[1])
			XSkinAnimate($prog_gui, 1, 6)
			_GDIPlus_GraphicsDispose($hGraphic2)
			_GDIPlus_GraphicsDispose($hGraphic)
			_GDIPlus_ImageDispose($hImage)
			_GDIPlus_Shutdown()
			Exit
	EndSwitch
EndFunc   ;==>_Trayitems

; ====Pause Mode==============================
Func _pause()
	AdlibUnRegister("_check")
	If __HoverWaitButtonUp($TRH_GUI) Then Return
	Opt("GUIOnEventMode", 0)
	Opt("TrayOnEventMode", 0)
	GUICtrlSetData($pauseme[1], "Resume")
	While 1
		__CheckHoverAndPressed($TRH_GUI)
		$msg = GUIGetMsg()
		$msg1 = TrayGetMsg()
		Select
			Case $msg = $exit[0] Or $msg = $GUI_EVENT_CLOSE
				Exit
			Case $msg = $pauseme[0] Or $msg1 = $unpauseitem
				__HoverButtonSetState($stop, $gui_enable)
				TrayItemSetState($unpauseitem, $tray_disable)
				TrayItemSetState($pauseitem, $tray_enable)
				TrayItemSetState($stopitem, $tray_enable)
				If $_GUIMode[1][1] = "True" Then TrayItemSetText($silentitem, "Status: Running")
				ExitLoop
			Case $msg = $options[0]
				_opt()
				ExitLoop
			Case $msg = $tvb[0] Or $msg1 = $tvitem
				ShellExecute($tvlog)
			Case $msg = $movieb[0] Or $msg1 = $movitem
				ShellExecute($movielog)
			Case $msg = $animeb[0] Or $msg1 = $aniitem
				ShellExecute($animelog)
			Case $msg = $extrab[0] Or $msg1 = $extitem
				ShellExecute($extralog)
		EndSelect
	WEnd
	Opt("GUIOnEventMode", 1)
	Opt("TrayOnEventMode", 1)
	Global $pausef = False
	GUICtrlSetData($pauseme[1], "Pause")
	AdlibRegister("_check", 5)
EndFunc   ;==>_pause

;====exit from program===============================
Func _exit()
	Switch @GUI_WinHandle
		Case $TRH_GUI
			$TRH_P = WinGetPos("[ACTIVE]")
			IniWrite(@ScriptDir & "\Position.ini", "TRH_Position", "X-Pos", $TRH_P[0])
			IniWrite(@ScriptDir & "\Position.ini", "TRH_Position", "Y-Pos", $TRH_P[1])
			XSkinAnimate($TRH_GUI, 1, 10)
			_GDIPlus_GraphicsDispose($hGraphic)
			_GDIPlus_GraphicsDispose($hGraphic2)
			_GDIPlus_ImageDispose($hImage)
			_GDIPlus_Shutdown()
			Exit
		Case $TRH_opt_GUI
			$TRH_opt_P = WinGetPos("[ACTIVE]")
			IniWrite(@ScriptDir & "\Position.ini", "TRH_Options_Position", "X-Pos", $TRH_opt_P[0])
			IniWrite(@ScriptDir & "\Position.ini", "TRH_Options_Position", "Y-Pos", $TRH_opt_P[1])
			If WinExists($TRH_GUI) Then GUISetState(@SW_ENABLE, $TRH_GUI)
			Local $state = WinGetState($TRH_GUI, "")
			If $_gui_pbar = "False" Then
				ConsoleWrite("Progressoff" & @CRLF); <=== Debug
				ConsoleWrite("State: " & $state & @CRLF) ;<=== Debug
				GUISetState(@SW_SHOW, $TRH_GUI)
				If WinExists("TRHelper Progress Bar") Then
					GUIDelete($prog_gui)
					ConsoleWrite("inside prog loop" & @CRLF)
				EndIf
				__HoverButtonSetState($start, $gui_enable)
				__HoverButtonSetState($pauseme, $gui_disable)
				__HoverButtonSetState($stop, $gui_disable)
				$hGraphic = _GDIPlus_GraphicsCreateFromHWND($TRH_GUI)
				_GDIPlus_GraphicsDrawImage($hGraphic, $hImage, 215, 40)
				TraySetState(2)
			ElseIf $_gui_pbar = "True" Then
				$Runf = True
				If WinExists("TRHelper Progress Bar") Then GUIDelete($prog_gui)
				TrayItemSetState($startitem, $tray_disable)
				TrayItemSetState($stopitem, $tray_enable)
				TrayItemSetState($pauseitem, $tray_enable)
				TrayItemDelete($silentitem)
				TrayItemDelete($trayline)
				$silentitem = TrayCreateItem("Status: Running", -1, 0)
				$trayline = TrayCreateItem("", -1, 1)
				GUISetState(@SW_HIDE, $TRH_GUI)
				TraySetState()
				_progb()
			EndIf
			GUIDelete($TRH_opt_GUI)
	EndSwitch
EndFunc   ;==>_exit
