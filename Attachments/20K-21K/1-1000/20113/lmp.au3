#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_icon=lmp.ico
#AutoIt3Wrapper_outfile=lmp.exe
#AutoIt3Wrapper_Compression=4
#AutoIt3Wrapper_Res_Comment=Thx too all that helped creating this app ...
#AutoIt3Wrapper_Res_Description=L|M|TER Media Player
#AutoIt3Wrapper_Res_Fileversion=3.4.6.0
#AutoIt3Wrapper_Res_LegalCopyright=© 2008 - L|M|TER
#AutoIt3Wrapper_Res_Language=1033
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#include <GUIConstants.au3>
#include <GuiStatusBar.au3>
#include <ExtProp.au3>
#include <File.au3>
#include <GUIEnhance.au3>
#include <IE.au3>
#include <Constants.au3>
#include <Date.au3>
#include <Misc.au3>
#include <GDIPlus.au3>
#include <WinAPI.au3>
#include "Recursive.au3"
#include "Audio.au3"
#include "WMP.au3"
#include "hover.au3"
#include "ModernMenuRaw.au3"
$cver = "3.4.6"
$vver = "1.2"
Opt("TrayMenuMode", 1)
Opt("TrayOnEventMode", 1)
Opt("GUIOnEventMode", 1)
TraySetClick(8)
TraySetToolTip("L|M|TER Media Player v." & $cver)
Global $lang[100]

;Check command line parameters
$debug = 0
$noeffect = 0
$cmdplay = 0
If $CmdLine[0] > 0 Then
	If $CmdLine[1] = "/debug" Then
		$debuglog = @ScriptDir & "\LMP-Debug.log"
		_FileCreate($debuglog)
		$filed = FileOpen($debuglog, 1)
		FileWrite($filed, "L|M|TER Media Player " & "( v." & $cver & " )" & " Debug Log" & @CRLF)
		FileWrite($filed, "Log started at : " & @HOUR & ":" & @MIN & ":" & @SEC & " - " & @MDAY & "/" & @MON & "/" & @YEAR & @CRLF)
		FileWrite($filed, "OS : " & @OSVersion & " " & @OSServicePack & @CRLF)
		FileWrite($filed, "------------------------------------------------------------------" & @CRLF)
		FileClose($filed)
		$debug = 1
	EndIf
	If $CmdLine[1] = "/noeffects" Then
		$noeffect = 1
	EndIf
	If $CmdLine[1] = "/reset" Then
		$inipath = @AppDataDir & "\LMP\lmp.ini"
		FileDelete($inipath)
		IniWriteSection($inipath, "Auto-Update", "Enabled=1")
		IniWriteSection($inipath, "Minimize To Tray", "Enabled=1")
		IniWriteSection($inipath, "Playlist-Hide", "Enabled=1")
		IniWriteSection($inipath, "Random", "Enabled=1")
		IniWriteSection($inipath, "Playlist-Save", "Enabled=1")
		IniWriteSection($inipath, "Playlist-Open", "Enabled=1")
		IniWriteSection($inipath, "Language", "Lang=ENG")
		IniWriteSection($inipath, "Theme", "Blue")
		IniWriteSection($inipath, "Demo Song", "Enabled=1")
		MsgBox(32, "L|M|TER Media Player", "Settings reseted to default values !")
		Exit
	EndIf
	If $CmdLine[1] = "/play" Then
		$playsong = $CmdLine[2]
		$cmdplay = 1
	EndIf
EndIf

;Multiple instances check
$inipath = @AppDataDir & "\LMP\lmp.ini"
If _Singleton("L|M|TER Media Player", 1) = 0 Then
	MsgBox(32, "L|M|TER Media Player", "LMP is already running !" & @CRLF & "You cannot run multiple instances of LMP.")
	Exit
EndIf

;Creating ini
$inipath = @AppDataDir & "\LMP\lmp.ini"
If FileExists($inipath) = 0 Then
	DirCreate(@AppDataDir & "\LMP\")
	IniWriteSection($inipath, "Auto-Update", "Enabled=1")
	IniWriteSection($inipath, "Minimize To Tray", "Enabled=1")
	IniWriteSection($inipath, "Playlist-Hide", "Enabled=1")
	IniWriteSection($inipath, "Random", "Enabled=1")
	IniWriteSection($inipath, "Playlist-Save", "Enabled=1")
	IniWriteSection($inipath, "Playlist-Open", "Enabled=1")
	IniWriteSection($inipath, "Language", "Lang=ENG")
	IniWriteSection($inipath, "Theme", "Blue")
	IniWriteSection($inipath, "Demo Song", "Enabled=1")
EndIf

;Install language
FileInstall("Lang\ENG.ini", @AppDataDir & "\LMP\ENG.ini", 1)
FileInstall("Lang\PL.ini", @AppDataDir & "\LMP\PL.ini", 1)
$lng = IniRead($inipath, "Language", "Lang", "ENG")
For $i = 0 To 88
	$lang[$i] = IniRead(@AppDataDir & "\LMP\" & $lng & ".ini", $lng, $i, "Lang File Error !")
Next

;~ Check theme
$theme = FileReadLine($inipath,16)

;Install images and icons
If $theme = "Black" Then
$loimg = @TempDir & "\lmplogo.bmp"
FileInstall("Pictures\lmplogo-new-black.bmp", $loimg, 1)
Else
$loimg = @TempDir & "\lmplogo.bmp"
FileInstall("Pictures\lmplogo-new.bmp", $loimg, 1)
EndIf
$paimg = @TempDir & "\pauseb.bmp"
FileInstall("Pictures\pause-new.bmp", $paimg, 1)
$plimg = @TempDir & "\playb.bmp"
FileInstall("Pictures\play-new.bmp", $plimg, 1)
$stimg = @TempDir & "\stopb.bmp"
FileInstall("Pictures\stop-new.bmp", $stimg, 1)
$brimg = @TempDir & "\browseb.bmp"
FileInstall("Pictures\browse-new.bmp", $brimg, 1)
$paimgo = @TempDir & "\pauseb-o.bmp"
FileInstall("Pictures\pause-new-over.bmp", $paimgo, 1)
$plimgo = @TempDir & "\playb-o.bmp"
FileInstall("Pictures\play-new-over.bmp", $plimgo, 1)
$stimgo = @TempDir & "\stopb-o.bmp"
FileInstall("Pictures\stop-new-over.bmp", $stimgo, 1)
$brimgo = @TempDir & "\browseb-o.bmp"
FileInstall("Pictures\browse-new-over.bmp", $brimgo, 1)
$paimgov = @TempDir & "\pauseb-ov.bmp"
FileInstall("Pictures\pause-new-over-v.bmp", $paimgov, 1)
$plimgov = @TempDir & "\playb-ov.bmp"
FileInstall("Pictures\play-new-over-v.bmp", $plimgov, 1)
$stimgov = @TempDir & "\stopb-ov.bmp"
FileInstall("Pictures\stop-new-over-v.bmp", $stimgov, 1)
$paimgv = @TempDir & "\pausebv.bmp"
FileInstall("Pictures\pause-new-v.bmp", $paimgv, 1)
$plimgv = @TempDir & "\playbv.bmp"
FileInstall("Pictures\play-new-v.bmp", $plimgv, 1)
$stimgv = @TempDir & "\stopbv.bmp"
FileInstall("Pictures\stop-new-v.bmp", $stimgv, 1)
$spimg = @TempDir & "lmp-splash.png"
FileInstall("Pictures\splash.png", $spimg, 1)

If $theme = "Black" Then
$brimgv = @TempDir & "\browseb-v.bmp"
FileInstall("Pictures\browse-new-v.bmp", $brimgv, 1)
$brimgov = @TempDir & "\browseb-ov.bmp"
FileInstall("Pictures\browse-new-over-v.bmp", $brimgov, 1)
EndIf

$mdir = @TempDir & "\lmp-ofolder.ico"
FileInstall("Icons\lmp-ofolder.ico", $mdir, 1)
$mfile = @TempDir & "\lmp-ofile.ico"
FileInstall("Icons\lmp-ofile.ico", $mfile, 1)
$mexit = @TempDir & "\lmp-exit.ico"
FileInstall("Icons\lmp-exit.ico", $mexit, 1)
$mset = @TempDir & "\lmp-settings.ico"
FileInstall("Icons\lmp-settings.ico", $mset, 1)
$mhelp = @TempDir & "\lmp-help.ico"
FileInstall("Icons\lmp-help.ico", $mhelp, 1)
$mupd = @TempDir & "\lmp-updates.ico"
FileInstall("Icons\lmp-updates.ico", $mupd, 1)
$mabout = @TempDir & "\lmp-about.ico"
FileInstall("Icons\lmp-about.ico", $mabout, 1)
$mvid = @TempDir & "\lmp-video.ico"
FileInstall("Icons\lmp-video.ico", $mvid, 1)
$rcmplay = @TempDir & "\lmp-rcplay.ico"
FileInstall("Icons\lmp-rcplay.ico", $rcmplay, 1)
$rcmpause = @TempDir & "\lmp-rcpause.ico"
FileInstall("Icons\lmp-rcpause.ico", $rcmpause, 1)
$rcmstop = @TempDir & "\lmp-rcstop.ico"
FileInstall("Icons\lmp-rcstop.ico", $rcmstop, 1)
$rcmdelete = @TempDir & "\lmp-rcdelete.ico"
FileInstall("Icons\lmp-rcdelete.ico", $rcmdelete, 1)

;~ Splash
Global Const $AC_SRC_ALPHA = 1
Global Const $ULW_ALPHA = 2
_GDIPlus_Startup()
$pngSrc = $spimg
$hImage = _GDIPlus_ImageLoadFromFile($pngSrc)
$width = _GDIPlus_ImageGetWidth($hImage)
$height = _GDIPlus_ImageGetHeight($hImage)
$Splash = GUICreate("L|M|TER Media Player", $width, $height, -1, -1, $WS_POPUP, $WS_EX_LAYERED, $DS_MODALFRAME)
GUISetState(@SW_LOCK)
SetBitmap($Splash, $hImage, 0)
GUISetState()
WinSetOnTop($Splash, "", 1)
For $i = 0 To 255 Step 10
	SetBitmap($Splash, $hImage, $i)
Next
Sleep(1000)
InetGet("                                         ", @TempDir & "\lmp.ver", 1, 1)
If @error Then MsgBox(32, "LMP Update", $lang[2])
While @InetGetActive
WEnd
Sleep(1000)
For $i = 255 To 0 Step -10
	SetBitmap($Splash, $hImage, $i)
Next
GUIDelete($Splash)
_GDIPlus_ImageDispose($hImage)
_GDIPlus_Shutdown()

_ReduceMemory(@AutoItPID)

;~ Update check
If FileReadLine($inipath, 2) = "Enabled=1" Then
	$dat = FileOpen(@TempDir & "\lmp.ver", 0)
	Global $nver = FileReadLine($dat, 1)
	FileClose($dat)
	If $nver = $cver Then
		TrayTip("L|M|TER Media Player", $lang[3], 2, 1)
		Sleep(600)
		TrayTip("", "", 0)
	EndIf
	If $nver > $cver Then
		If $debug = 1 Then
			$filed = FileOpen($debuglog, 1)
			FileWrite($filed, "New version available ! (Current : " & $cver & " Newer : " & $nver & ")" & @CRLF)
			FileClose($filed)
		EndIf
		Call("update")
	EndIf
EndIf

;~ Demo song
If FileReadLine($inipath, 18) = "Enabled=1" Or FileReadLine($inipath, 18) = "" Then
$lmpds = GUICreate("LMP Demo Song", 263, 69, 194, 126)
GUISetOnEvent($GUI_EVENT_CLOSE,"dsexit")
GUISetBkColor(0x000000)
$txtds = GUICtrlCreateLabel("Do you want to download LMP's Demo Song ?", 18, 8, 222, 17)
GUICtrlSetColor(-1, 0xFFFFFF)
GUICtrlSetCursor (-1, 0)
$dldbds = GUICtrlCreateButton("Download now", 8, 32, 91, 25)
GUICtrlSetOnEvent(-1,"demos")
$okbds = GUICtrlCreateButton("Download later", 160, 32, 91, 25)
GUICtrlSetOnEvent(-1,"dsexit")
GUISetState()
EndIf

Global $WM_DROPFILES = 0x233
Global $gaDropFiles[1], $str = ""

GUIRegisterMsg($WM_DROPFILES, "WM_DROPFILES_FUNC") ; drag 'n drop function
If $debug = 1 Then $filed = FileOpen($debuglog, 1)

_ReduceMemory(@AutoItPID)

;~ Main GUI
If $debug = 1 Then FileWrite($filed, "Creating GUI ..." & @CRLF)
$gui = GUICreate("L|M|TER Media Player v." & $cver & " - © 2008 L|M|TER", 634, 465, 190, 121, $GUI_SS_DEFAULT_GUI, $WS_EX_ACCEPTFILES)
GUISetOnEvent($GUI_EVENT_CLOSE,"_Exit")
If $theme = "Black" Then
GUISetBkColor(0x000000)
Else
GUISetBkColor(0xD8E4F8)
EndIf
GUIRegisterMsg($WM_NOTIFY, "WM_NOTIFY")
$logo = GUICtrlCreatePic($loimg, 210, 0, 163, 117, BitOR($SS_NOTIFY, $WS_GROUP, $WS_CLIPSIBLINGS))
$playlist = GUICtrlCreateListView($lang[4] & "|" & $lang[5] & "|" & $lang[6] & "|" & $lang[7], 8, 202, 618, 214)
GUICtrlSetOnEvent(-1,"pevent")
If $theme = "Black" Then
GUICtrlSetBkColor(-1, 0x555555)
GUICtrlSetColor(-1, 0xFFFFFF)
Else
GUICtrlSetBkColor(-1, 0xDFECFF)
EndIf
GUICtrlSendMsg(-1, 0x101E, 0, 150)
GUICtrlSendMsg(-1, 0x101E, 1, 150)
GUICtrlSendMsg(-1, 0x101E, 2, 150)
GUICtrlSendMsg(-1, 0x101E, 3, 160)

If $debug = 1 Then FileWrite($filed, "Creating playlist context menu ..." & @CRLF)
If $theme = "Black" Then
_SetMenuBkColor(0x000000)
_SetMenuIconBkColor(0x000000)
_SetMenuTextColor(0xFFFFFF)
_SetMenuSelectRectColor(0x555555)
_SetMenuSelectTextColor(0xFFFFFF)
Else
_SetMenuBkColor(0xF8E4D8)
_SetMenuIconBkColor(0xF8E4D8)
EndIf
$menu1 = GUICtrlCreateContextMenu($playlist)
$RCaddfile = _GUICtrlCreateODMenuItem($lang[8], $menu1, $mfile)
GUICtrlSetOnEvent(-1,"AddFile")
$RCadddir = _GUICtrlCreateODMenuItem($lang[9], $menu1, $mdir)
GUICtrlSetOnEvent(-1,"add")
$RCplay = _GUICtrlCreateODMenuItem($lang[10], $menu1, $rcmplay)
GUICtrlSetOnEvent(-1,"play")
$RCpause = _GUICtrlCreateODMenuItem($lang[11], $menu1, $rcmpause)
GUICtrlSetOnEvent(-1,"pause")
$RCstop = _GUICtrlCreateODMenuItem($lang[12], $menu1, $rcmstop)
GUICtrlSetOnEvent(-1,"stop")
$RCsonginfo = _GUICtrlCreateODMenuItem($lang[13], $menu1, $mabout)
GUICtrlSetOnEvent(-1,"rcsonggui")
$RCdelete = _GUICtrlCreateODMenuItem("Delete this song", $menu1, $rcmdelete)
GUICtrlSetOnEvent(-1,"remove")

If $debug = 1 Then FileWrite($filed, "Creating buttons ..." & @CRLF)
If $theme = "Black" Then
$play = GUICtrlCreatePic($plimgv, 8, 144, 50, 50)
GUICtrlSetOnHover(-1, "Hover_Func", "Leave_Hover_Func")
GUICtrlSetOnEvent(-1,"play")
$pause = GUICtrlCreatePic($paimgv, 64, 144, 50, 50)
GUICtrlSetOnHover(-1, "Hover_Func", "Leave_Hover_Func")
GUICtrlSetOnEvent(-1,"pause")
$stop = GUICtrlCreatePic($stimgv, 120, 144, 50, 50)
GUICtrlSetOnHover(-1, "Hover_Func", "Leave_Hover_Func")
GUICtrlSetOnEvent(-1,"stop")
$browse = GUICtrlCreatePic($brimgv, 176, 144, 50, 50)
GUICtrlSetOnEvent(-1,"add")
GUICtrlSetTip($browse, $lang[17], "L|M|TER Media Player", 1, 1)
GUICtrlSetOnHover(-1, "Hover_Func", "Leave_Hover_Func")
Else
$play = GUICtrlCreatePic($plimg, 8, 144, 50, 50)
GUICtrlSetOnEvent(-1,"play")
GUICtrlSetOnHover(-1, "Hover_Func", "Leave_Hover_Func")
$pause = GUICtrlCreatePic($paimg, 64, 144, 50, 50)
GUICtrlSetOnEvent(-1,"pause")
GUICtrlSetOnHover(-1, "Hover_Func", "Leave_Hover_Func")
$stop = GUICtrlCreatePic($stimg, 120, 144, 50, 50)
GUICtrlSetOnEvent(-1,"stop")
GUICtrlSetOnHover(-1, "Hover_Func", "Leave_Hover_Func")
$browse = GUICtrlCreatePic($brimg, 176, 144, 50, 50)
GUICtrlSetOnEvent(-1,"add")
GUICtrlSetTip($browse, $lang[17], "L|M|TER Media Player", 1, 1)
GUICtrlSetOnHover(-1, "Hover_Func", "Leave_Hover_Func")
EndIf
$about = GUICtrlCreateButton($lang[18], 544, 144, 75, 25)
GUICtrlSetOnEvent(-1,"about")
GUICtrlSetFont(-1, 8, 800, 0, "MS Sans Serif")
$help = GUICtrlCreateButton($lang[19], 544, 168, 75, 25)
GUICtrlSetOnEvent(-1,"help")
GUICtrlSetFont(-1, 8, 800, 0, "MS Sans Serif")
$songinfo = GUICtrlCreateButton($lang[20], 434, 144, 107, 25, 0)
GUICtrlSetOnEvent(-1,"songgui")
GUICtrlSetFont(-1, 8, 800, 0, "MS Sans Serif")
GUICtrlSetTip($songinfo, $lang[21], "L|M|TER Media Player", 1, 1)
$nextbtn = GUICtrlCreateButton($lang[22], 434, 168, 107, 25, 0)
GUICtrlSetOnEvent(-1,"nexts")
GUICtrlSetFont(-1, 8, 800, 0, "MS Sans Serif")
GUICtrlSetTip($nextbtn, $lang[23] & @CRLF & "Shortcut : Ctrl + Shift + B", "L|M|TER Media Player", 1, 1)
GUICtrlSetState($nextbtn, $GUI_DISABLE)
If $theme = "Black" Then
$Label2 = GUICtrlCreateLabel($lang[24], 240, 152, 48, 17)
GUICtrlSetColor(-1, 0xFFFFFF)
$Label3 = GUICtrlCreateLabel($lang[25], 240, 168, 60, 17)
GUICtrlSetColor(-1, 0xFFFFFF)
$elapsedt = GUICtrlCreateLabel("00:00:00", 302, 152, 46, 17)
GUICtrlSetColor(-1, 0xFFFFFF)
$remainingt = GUICtrlCreateLabel("00:00:00", 302, 168, 44, 17)
GUICtrlSetColor(-1, 0xFFFFFF)
Else
$Label2 = GUICtrlCreateLabel($lang[24], 240, 152, 48, 17)
$Label3 = GUICtrlCreateLabel($lang[25], 240, 168, 60, 17)
$elapsedt = GUICtrlCreateLabel("00:00:00", 302, 152, 46, 17)
$remainingt = GUICtrlCreateLabel("00:00:00", 302, 168, 44, 17)
EndIf

If $debug = 1 Then FileWrite($filed, "Creating menu ..." & @CRLF)
$file = GUICtrlCreateMenu($lang[26])
$adddir = _GUICtrlCreateODMenuItem($lang[27], $file, $mdir)
GUICtrlSetOnEvent(-1,"add")
$addfile = _GUICtrlCreateODMenuItem($lang[28], $file, $mfile)
GUICtrlSetOnEvent(-1,"AddFile")
_GUICtrlCreateODMenuItem("", $file)
$exit = _GUICtrlCreateODMenuItem($lang[29] & @TAB & "Esc", $file, $mexit)
GUICtrlSetOnEvent(-1,"_Exit")
$settings1 = GUICtrlCreateMenu($lang[30])
$settings = _GUICtrlCreateODMenuItem($lang[30], $settings1, $mset)
GUICtrlSetOnEvent(-1,"settings")
$vpmenu = GUICtrlCreateMenu("Video Player")
$vps = _GUICtrlCreateODMenuItem("Open L|M|TER Video Player" & @TAB & "Ctrl + Shift + V", $vpmenu, $mvid)
GUICtrlSetOnEvent(-1,"vplayer")
$hel = GUICtrlCreateMenu($lang[31])
$helpmenu = _GUICtrlCreateODMenuItem($lang[31] & @TAB & "Alt + H", $hel, $mhelp)
GUICtrlSetOnEvent(-1,"help")
$updchk = _GUICtrlCreateODMenuItem($lang[32], $hel, $mupd)
GUICtrlSetOnEvent(-1,"updchk")
$aboutlmp = _GUICtrlCreateODMenuItem($lang[33] & @TAB & "Alt + A", $hel, $mabout)
GUICtrlSetOnEvent(-1,"about")

$search = GUICtrlCreateButton($lang[34], 352, 144, 80, 25, 0)
GUICtrlSetOnEvent(-1,"search")
GUICtrlSetFont($search, Default, 800)
GUICtrlSetState($search, $GUI_DISABLE)
$clear = GUICtrlCreateButton($lang[35], 352, 168, 80, 25, 0)
GUICtrlSetOnEvent(-1,"_clear")

If $debug = 1 Then FileWrite($filed, "Creating volume slider ..." & @CRLF)
$volslider = GUICtrlCreateSlider(584, 24, 30, 77, BitOR($TBS_VERT, $TBS_AUTOTICKS, $TBS_TOP, $TBS_LEFT))
If $theme = "Black" Then
GUICtrlSetBkColor($volslider, 0x000000)
$playlistsong = ""
GUICtrlSetState($volslider, @SW_DISABLE)
$Label1 = GUICtrlCreateLabel($lang[36] & "100", 555, 8, 70, 17)
GUICtrlSetColor(-1, 0xFFFFFF)
$Label4 = GUICtrlCreateLabel("Max", 560, 32, 21, 17)
GUICtrlSetColor(-1, 0xFFFFFF)
$Label5 = GUICtrlCreateLabel("Min", 560, 80, 24, 17)
GUICtrlSetColor(-1, 0xFFFFFF)
Else
GUICtrlSetBkColor($volslider, 0xD8E4F8)
$playlistsong = ""
GUICtrlSetState($volslider, @SW_DISABLE)
$Label1 = GUICtrlCreateLabel($lang[36] & "100", 555, 8, 70, 17)
$Label4 = GUICtrlCreateLabel("Max", 560, 32, 21, 17)
$Label5 = GUICtrlCreateLabel("Min", 560, 80, 24, 17)
EndIf

If $debug = 1 Then FileWrite($filed, "Creating seek slider ..." & @CRLF)
$PosSlider = GUICtrlCreateSlider(8, 100, 614, 42)
If $theme = "Black" Then
GUICtrlSetBkColor($PosSlider, 0x000000)
Else
GUICtrlSetBkColor($PosSlider, 0xD8E4F8)
EndIf
GUICtrlSetState($PosSlider, $GUI_DISABLE)
If FileReadLine($inipath, 4) = "Enabled=1" Then
	$tray_hide = TrayCreateItem($lang[37])
	TrayCreateItem("")
	$tray_Restore = TrayCreateItem($lang[38])
	TrayItemSetState($tray_Restore, $GUI_DISABLE)
EndIf

If $debug = 1 Then FileWrite($filed, "Creating tray menu ..." & @CRLF)
TrayCreateItem("")
$trayplay = TrayCreateItem("Play")
TrayItemSetState($trayplay, $GUI_DISABLE)
$traystop = TrayCreateItem("Stop")
TrayItemSetState($traystop, $GUI_DISABLE)
$traypause = TrayCreateItem("Pause")
TrayItemSetState($traypause, $GUI_DISABLE)
$traysonginfo = TrayCreateItem("Song Information")
TrayItemSetState($traysonginfo, $GUI_DISABLE)
$traynext = TrayCreateItem("Next Song")
TrayItemSetState($traynext, $GUI_DISABLE)
TrayCreateItem("")
$traysrch = TrayCreateItem("Search")
TrayItemSetState($traysrch, $GUI_DISABLE)
TrayCreateItem("")
$tray_exit = TrayCreateItem("Exit")

If $debug = 1 Then FileWrite($filed, "Creating statusbar ..." & @CRLF)
$statusbar = _GUICtrlStatusBar_Create($gui)
Dim $statusbar_PartsWidth[3] = [150, 400, 650]
_GUICtrlStatusBar_SetParts($statusbar, $statusbar_PartsWidth)
_GUICtrlStatusBar_SetText($statusbar, $lang[39], 0)
_GUICtrlStatusBar_SetText($statusbar, $lang[40], 1)
_GUICtrlStatusBar_SetText($statusbar, $lang[41], 2)

GUICtrlSetState($playlist, $GUI_SHOW)
If $noeffect = 0 Then DllCall("user32.dll", "int", "AnimateWindow", "hwnd", $gui, "int", 500, "long", 0x00080000);fade-in
GUISetState(@SW_SHOW)
GUICtrlSetState($playlist, $GUI_SHOW)
GUICtrlRegisterListViewSort($playlist, "LVSort")
If $debug = 1 Then FileWrite($filed, "All created !" & @CRLF)

Dim $var, $hour, $min, $sec, $filep, $pcdir, $playlistsong, $playlistsong1, $bitrate, $tracknr, $ttime, $comments, $protected, $copyright, $author, $genre, $year, $album, $title, $artist, $remove, $status, $1b, $link, $vplay, $vstop, $vpause, $busy1, $scrgui, $nCurCol = -1, $nSortDir = 1, $bSet = 0, $nCol = -1, $DoubleClicked = False, $scrolltxt, $Form1, $Form2, $lmpupdate, $songgui, $settingsgui, $enable, $disable, $minenabled, $mindisabled, $showen, $showdis, $randen, $disen, $saveen, $savedis, $openen, $opendis, $classic, $blackrd, $lang_set, $player, $vplayer, $Wpop, $aCpos, $1a1, $1b1, $gstate1

If FileReadLine($inipath, 12) = "Enabled=1" Then
	If $debug = 1 Then FileWrite($filed, "Loading playlist ..." & @CRLF)
	plsopen()
	If $debug = 1 Then FileWrite($filed, "Playlist loaded !" & @CRLF)
EndIf
If $noeffect = 0 Then _GUIEnhanceAnimateTitle($gui, "L|M|TER Media Player v." & $cver & " - © 2008 L|M|TER", $GUI_EN_TITLE_DROP, Default, 25)
_ReduceMemory(@AutoItPID)
If $cmdplay = 1 Then
	$playlistsong1 = $playsong
	start($playlistsong1)
EndIf

;Set tray events :)
TrayItemSetOnEvent($trayplay, "_trayplay")
TrayItemSetOnEvent($traypause, "_traypause")
TrayItemSetOnEvent($traynext, "_traynext")
TrayItemSetOnEvent($traysonginfo, "_traysonginfo")
TrayItemSetOnEvent($traystop, "_traystop")
TrayItemSetOnEvent($traysrch, "_traysrch")
TrayItemSetOnEvent($tray_exit, "_trayexit")
TrayItemSetOnEvent($tray_hide, "_trayhide")
TrayItemSetOnEvent($tray_Restore, "_trayrestore")
TraySetOnEvent($TRAY_EVENT_PRIMARYDOUBLE, "_trayprimdouble")

AdlibEnable("updatedata",500)

$Sleep = 50
$_RedTimer = TimerInit()

While 1
	Sleep(500)
	
	#cs
	;TRAY FUNCTIONS MOVED DOWN! (Right under the while loop inside a #region :D )
	$msgt = TrayGetMsg()
	Switch $msgt
		Case $trayplay
			play()
		Case $traypause
			pause()
		Case $traynext
			nexts()
		Case $traysonginfo
			songgui()
		Case $traystop
			stop()
		Case $traysrch
			search()
		Case $tray_exit
			AdlibDisable()
			For $i = (100 - GUICtrlRead($volslider)) * 10 To 0 Step -5
				_SoundVolume($playlistsong, $i)
			Next
			_SoundClose($playlistsong)
			If FileReadLine($inipath, 10) = "Enabled=1" Then plssave()
			If $noeffect = 0 Then DllCall("user32.dll", "int", "AnimateWindow", "hwnd", $gui, "int", 400, "long", 0x00090000);fade-out
			DelRes()
			If $debug = 1 Then
				FileWrite($filed, "------------------------------------------------------------------" & @CRLF)
				FileWrite($filed, "Log ended at : " & @HOUR & ":" & @MIN & ":" & @SEC & " - " & @MDAY & "/" & @MON & "/" & @YEAR & @CRLF)
				FileClose($filed)
			EndIf
			Exit
	EndSwitch
	#ce
	
	If FileReadLine($inipath, 4) = "Enabled=1" Then
		#cs
		Switch $msgt
			Case $tray_hide
				TrayItemSetState($tray_Restore, $GUI_ENABLE)
				TrayItemSetState($tray_hide, $GUI_DISABLE)
				GUISetState(@SW_HIDE, $gui)
			Case $tray_Restore
				TrayItemSetState($tray_Restore, $GUI_DISABLE)
				TrayItemSetState($tray_hide, $GUI_ENABLE)
				WinActivate("L|M|TER Media Player")
				If $noeffect = 0 Then DllCall("user32.dll", "int", "AnimateWindow", "hwnd", $gui, "int", 500, "long", 0x0004000a)
				GUISetState(@SW_SHOW, $gui)
			Case $TRAY_EVENT_PRIMARYDOUBLE
				$check = WinGetState("L|M|TER Media Player v.", "")
				If BitAND($check, 2) Then
					TrayItemSetState($tray_Restore, $GUI_ENABLE)
					TrayItemSetState($tray_hide, $GUI_DISABLE)
					GUISetState(@SW_HIDE, $gui)
				Else
					TrayItemSetState($tray_Restore, $GUI_DISABLE)
					TrayItemSetState($tray_hide, $GUI_ENABLE)
					WinActivate("L|M|TER Media Player")
					If $noeffect = 0 Then DllCall("user32.dll", "int", "AnimateWindow", "hwnd", $gui, "int", 500, "long", 0x0004000a)
					GUISetState(@SW_SHOW, $gui)
				EndIf
		EndSwitch
		#ce
	EndIf
	
	;---
	Sleep($Sleep)
	;---

	$gstate = WinGetState("L|M|TER Media Player")
	If _SoundStatus($playlistsong) = "playing" And BitAND($gstate, 8) Then
		$1a = _SoundPos($playlistsong, 2)
		$1b = _SoundLength($playlistsong, 2)
		$1e = _SoundPos($playlistsong)
		$1f = _SoundLength($playlistsong)
		$1c = Round(($1a / $1b) * 100)
		$1d = Round((($1b - $1a) / 1000) / 60)
		$txt7 = GUICtrlRead($elapsedt)
		$txt8 = _SoundPos($playlistsong)
		If $txt8 <> $txt7 Then GUICtrlSetData($elapsedt, $txt8)
		$1f1 = _GetExtProperty($playlistsong1, 21)
		$1aa = StringSplit($1f1, ":")
		$txt3 = _SoundMsToTime(_SoundTimeToMs($1aa[1], $1aa[2], $1aa[3]) - $1a)
		If $txt3[0] < 10 Then $txt3[0] = "0" & $txt3[0]
		If $txt3[1] < 10 Then $txt3[1] = "0" & $txt3[1]
		If $txt3[2] < 10 Then $txt3[2] = "0" & $txt3[2]
		$txt2 = $txt3[0] & ":" & $txt3[1] & ":" & $txt3[2]
		$txt1 = GUICtrlRead($remainingt)
		If $txt2 <> $txt1 Then GUICtrlSetData($remainingt, $txt2)
		
		$VolLevel = _SoundInfo($playlistsong, "volume") / 10
		If 100 - GUICtrlRead($volslider) <> $VolLevel Then
			_SoundVolume($playlistsong, (100 - GUICtrlRead($volslider)) * 10)
		EndIf
		$vl2 = GUICtrlRead($Label1)
		$vl1 = StringSplit($vl2, ":")
		If $vl1[2] <> $VolLevel Then GUICtrlSetData($Label1, "Volume : " & 100 - GUICtrlRead($volslider))
		If abs($vl1[2]-$VolLevel)>1 Then GUICtrlSetData($Label1, "Volume : " & 100 - GUICtrlRead($volslider))
	EndIf
	
	;---
	Sleep($Sleep)
	;---
	
	$cursor = GUIGetCursorInfo($gui)
	If $cursor[2] = 1 And $cursor[4] = $PosSlider Then
		If _IsPressed("01") And WinActive("L|M|TER Media Player v.") Then
			While _IsPressed("01")
				Sleep(100)
				_TicksToTime(GUICtrlRead($PosSlider) / ($1b / 1000) * $1b, $hour, $min, $sec)
				$s = StringFormat("%i:%02i:%02i", $hour, $min, $sec)
				ToolTip($s)
			WEnd
			ToolTip('')
			_SoundSeek($playlistsong, $hour, $min, $sec)
			_SoundPlay($playlistsong)
		EndIf
	EndIf
	$1a = _SoundPos($playlistsong, 2)
	$1b = _SoundLength($playlistsong, 2)
	GUICtrlSetData($PosSlider, $1a / 1000); move the slider as the song progresses
	
	;---
	Sleep($Sleep)
	;---
	
	If $DoubleClicked And BitAND($gstate, 8) Then
		DoubleClickFunc()
		$DoubleClicked = False
	EndIf
	
	;---
	Sleep($Sleep)
	;---

	If $debug = 1 And @error > 0 Then FileWrite($filed, "Unexpected error ! (" & @error & " Ext : " & @extended & ") at line " & @ScriptLineNumber & @CRLF)
		
	;=================================================================
	
	If WinActive ( "L|M|TER Video Player" ) = 1 Then
		If WMGetState() = "Stopped" Then
				If GUICtrlRead($slider) <> Round(_wmpsetvalue($player, "getposition")) Then GUICtrlSetData($slider, _wmpsetvalue($player, "getposition"))
				If GUICtrlRead($clabel) <> "00:00:00" Then GUICtrlSetData($clabel, "00:00:00")
			EndIf
			If WMGetState() = "Playing" Then
				If GUICtrlRead($slider) <> Round(_wmpsetvalue($player, "getposition")) Then GUICtrlSetData($slider, _wmpsetvalue($player, "getposition"))
				If GUICtrlRead($clabel) <> "00:" & _wmpsetvalue($player, "getpositionstring") Then GUICtrlSetData($clabel, "00:" & _wmpsetvalue($player, "getpositionstring"))
			EndIf
			If WinActive("L|M|TER Video Player", "") = 1 Then HotKeySet("{F1}", "VHelp")
			If WinActive("L|M|TER Video Player", "") = 0 Then HotKeySet("{F1}")

			$cursor = GUIGetCursorInfo($vplayer)
			If $cursor[2] = 1 And $cursor[4] = $slider Then
				If _IsPressed("01") And WinActive("L|M|TER Video Player v.") Then
					While _IsPressed("01")
						Sleep(100)
					WEnd
					_wmpsetvalue($player, "setposition", GUICtrlRead($slider))
				EndIf
			EndIf
	EndIf ;==> If video player is active
		
	;=================================================================
	If TimerDiff($_RedTimer) > 10000 Then
		_ReduceMemory()
		$_RedTimer = TimerInit()
	EndIf
WEnd

;~ Functions
;===================================================
#region TRAY FUNCTIONS!

Func _trayplay()
	play()
EndFunc

Func _traypause()
	pause()
EndFunc

Func _traysrch()
	search()
EndFunc

Func _traynext()
	nexts()
EndFunc

Func _traysonginfo()
	songgui()
EndFunc

Func _traystop()
	stop()
EndFunc

Func _trayexit()
	AdlibDisable()
	For $i = (100 - GUICtrlRead($volslider)) * 10 To 0 Step -5
		_SoundVolume($playlistsong, $i)
	Next
	_SoundClose($playlistsong)
	If FileReadLine($inipath, 10) = "Enabled=1" Then plssave()
	If $noeffect = 0 Then DllCall("user32.dll", "int", "AnimateWindow", "hwnd", $gui, "int", 400, "long", 0x00090000);fade-out
	DelRes()
	If $debug = 1 Then
		FileWrite($filed, "------------------------------------------------------------------" & @CRLF)
		FileWrite($filed, "Log ended at : " & @HOUR & ":" & @MIN & ":" & @SEC & " - " & @MDAY & "/" & @MON & "/" & @YEAR & @CRLF)
		FileClose($filed)
	EndIf
	Exit
EndFunc

Func _trayhide()
	TrayItemSetState($tray_Restore, $GUI_ENABLE)
	TrayItemSetState($tray_hide, $GUI_DISABLE)
	GUISetState(@SW_HIDE, $gui)
EndFunc
	
Func _trayrestore()
	TrayItemSetState($tray_Restore, $GUI_DISABLE)
	TrayItemSetState($tray_hide, $GUI_ENABLE)
	WinActivate("L|M|TER Media Player")
	If $noeffect = 0 Then DllCall("user32.dll", "int", "AnimateWindow", "hwnd", $gui, "int", 500, "long", 0x0004000a)
	GUISetState(@SW_SHOW, $gui)
EndFunc

Func _trayprimdouble()
	$check = WinGetState("L|M|TER Media Player v.", "")
	If BitAND($check, 2) Then
		TrayItemSetState($tray_Restore, $GUI_ENABLE)
		TrayItemSetState($tray_hide, $GUI_DISABLE)
		GUISetState(@SW_HIDE, $gui)
	Else
		TrayItemSetState($tray_Restore, $GUI_DISABLE)
		TrayItemSetState($tray_hide, $GUI_ENABLE)
		WinActivate("L|M|TER Media Player")
		If $noeffect = 0 Then DllCall("user32.dll", "int", "AnimateWindow", "hwnd", $gui, "int", 500, "long", 0x0004000a)
		GUISetState(@SW_SHOW, $gui)
	EndIf
EndFunc

#endregion TRAY FUNCTIONS!
;===================================================

Func play()
	If _SoundStatus($playlistsong) = "playing" Then
	_SoundStop($playlistsong)
	For $i = (100 - GUICtrlRead($volslider)) * 10 To 0 Step -5
		_SoundVolume($playlistsong, $i)
	Next
	EndIf
	If _SoundStatus($playlistsong) = "paused" Then
	_SoundResume($playlistsong)
	For $i = 0  To (100 - GUICtrlRead($volslider)) * 10 Step 5
		_SoundVolume($playlistsong, $i)
	Next
	Else
	$dbclick1 = GUICtrlRead(GUICtrlRead($playlist))
	$dbclick2 = StringTrimRight($dbclick1, 1)
	$dbclick3 = StringSplit($dbclick2, "|")
	If $dbclick3[0] <> 1 Then
		GUICtrlSetState($PosSlider, $GUI_ENABLE)
		GUICtrlSetState($nextbtn, $GUI_ENABLE)
		TrayItemSetState($trayplay, $GUI_ENABLE)
		TrayItemSetState($traystop, $GUI_ENABLE)
		TrayItemSetState($traypause, $GUI_ENABLE)
		TrayItemSetState($traysonginfo, $GUI_ENABLE)
		TrayItemSetState($traynext, $GUI_ENABLE)
		TrayItemSetState($traysrch, $GUI_ENABLE)
		GUICtrlSetState($search, $GUI_ENABLE)
		GUICtrlSetData($PosSlider, "0")
		GUICtrlSetData($elapsedt, "00:00:00")
		GUICtrlSetData($remainingt, "00:00:00")
		$playlistsong1 = $dbclick3[4]
		$playlistsong = _SoundOpen($playlistsong1)
		If $debug = 1 And @error > 0 Then FileWrite($filed, "An error has ocurred when trying to open the sound (" & $playlistsong1 & ") !" & "Error code : " & @error & " ( Ext :" & @extended & " )" & @CRLF)
		$aa = _SoundPlay($playlistsong)
		If @error > 0 Then
			MsgBox(48, "L|M|TER Media Player", "An error has ocurred when trying to play the sound !" & @CRLF & "Error code : " & @error & " ( " & @extended & " )")
			If $debug = 1 Then FileWrite($filed, "An error has ocurred when trying to play the sound (" & $playlistsong1 & ") !" & "Error code : " & @error & " ( Ext :" & @extended & " )" & @CRLF)
		EndIf
		For $i = 0 To (100 - GUICtrlRead($volslider)) * 10 Step 5
			_SoundVolume($playlistsong, $i)
		Next
		_GUICtrlStatusBar_SetText($statusbar, "Status : Playing ...", 0)
		_GUICtrlStatusBar_SetText($statusbar, "Artist : " & _GetExtProperty($playlistsong1, 16), 1)
		_GUICtrlStatusBar_SetText($statusbar, "Title : " & _GetExtProperty($playlistsong1, 10), 2)
		TraySetToolTip("L|M|TER Media Player v. " & $cver & @CRLF & _GetExtProperty($playlistsong1, 16) & " - " & _GetExtProperty($playlistsong1, 10))
	Else
		TrayTip("L|M|TER Media Player v. " & $cver, $lang[43], 10, 2)
		_GUICtrlStatusBar_SetText($statusbar, $lang[44], 0)
	EndIf
	EndIf
	_ReduceMemory()
EndFunc   ;==>play

Func stop()
	For $i = (100 - GUICtrlRead($volslider)) * 10 To 0 Step -5
		_SoundVolume($playlistsong, $i)
	Next
	GUICtrlSetData($PosSlider, "0")
	GUICtrlSetData($elapsedt, "00:00:00")
	GUICtrlSetData($remainingt, "00:00:00")
	_SoundStop($playlistsong)
	_GUICtrlStatusBar_SetText($statusbar, "Status : Stopped ...", 0)
	TraySetToolTip("L|M|TER Media Player v. " & $cver & @CRLF & "Song stopped ...")
EndFunc   ;==>stop

Func pause()
	Local $volume1 = (100 - GUICtrlRead($volslider)) * 10
	If _SoundStatus($playlistsong) = "playing" Then
		For $i = (100 - GUICtrlRead($volslider)) * 10 To 0 Step -5
			_SoundVolume($playlistsong, $i)
		Next
		$volume1 = (100 - GUICtrlRead($volslider)) * 10
		_SoundPause($playlistsong)
		_GUICtrlStatusBar_SetText($statusbar, "Status : Paused ...", 0)
		TraySetToolTip("L|M|TER Media Player v. " & $cver & @CRLF & "Song paused ...")
	Else
		_SoundResume($playlistsong)
		For $i = 0  To $volume1 Step 5
			_SoundVolume($playlistsong, $i)
		Next
		_GUICtrlStatusBar_SetText($statusbar, "Status : Playing ...", 0)
		TraySetToolTip("L|M|TER Media Player v. " & $cver & @CRLF & _GetExtProperty($playlistsong1, 16) & " - " & _GetExtProperty($playlistsong1, 10))
	EndIf
EndFunc   ;==>pause

Func about()
	$Form1 = GUICreate("About L|M|TER Media Player", 324, 227)
	GUISetOnEvent($GUI_EVENT_CLOSE,"aboutex")
	GUISetBkColor(0xD8E4F8)
	If $theme = "Black" Then GUISetBkColor(0x000000)
	$GroupBox1 = GUICtrlCreateGroup("", 8, 0, 305, 185)
	$Image1 = GUICtrlCreatePic($loimg, 88, 16, 147, 101, BitOR($SS_NOTIFY, $WS_GROUP, $WS_CLIPSIBLINGS))
	$Label132131 = GUICtrlCreateLabel("L|M|TER Media Player " & "Version " & $cver & @CRLF & "Copyright © 2007, 2008 - L|M|TER" & @CRLF & "All Rights Reserved.", 16, 135, 200, 45)
	If $theme = "Black" Then GUICtrlSetColor(-1, 0xFFFFFF)
	$Button1 = GUICtrlCreateButton("OK", 123, 192, 75, 25)
	GUICtrlSetOnEvent(-1,"aboutex")
	$link = GUICtrlCreateLabel("                        ", 208, 197, 109, 17)
	GUICtrlSetOnEvent(-1,"alink")
	GUICtrlSetColor(-1, 0x0000FF)
	GUICtrlSetCursor(-1, 0)
	GUICtrlSetOnHover(-1, "Hover_Func", "Leave_Hover_Func")
	$gplbtn = GUICtrlCreateButton("View GPL", 8, 192, 75, 25, 0)
	GUICtrlSetOnEvent(-1,"Scrollgui")
	If $noeffect = 0 Then DllCall("user32.dll", "int", "AnimateWindow", "hwnd", $Form1, "int", 500, "long", 0x00080000);fade-in
	GUISetState(@SW_SHOW)
	If $noeffect = 0 Then _GUIEnhanceAnimateTitle($Form1, "About L|M|TER Media Player", $GUI_EN_TITLE_DROP, Default, 25)
EndFunc   ;==>about

Func help()
	$Form2 = GUICreate("Help", 412, 335, 267, 175)
	GUISetOnEvent($GUI_EVENT_CLOSE,"helpex")
	GUISetBkColor(0xD8E4F8)
	If $theme = "Black" Then GUISetBkColor(0x000000)
	GUISetIcon($mhelp)
	$Group1 = GUICtrlCreateGroup($lang[84], 5, 5, 400, 290)
	$Edit1 = GUICtrlCreateEdit("", 15, 25, 380, 259, BitOR($ES_AUTOVSCROLL, $ES_AUTOHSCROLL, $ES_READONLY, $ES_WANTRETURN, $WS_HSCROLL, $WS_VSCROLL))
	GUICtrlSetBkColor(-1, 0xD8E4F8)
	If $theme = "Black" Then
	GUICtrlSetBkColor(-1, 0x000000)
	GUICtrlSetColor(-1, 0xFFFFFF)
	EndIf
	GUICtrlSetData(-1, StringFormat(".-=-. L|M|TER Media Player v." & $cver & $lang[85] & Chr(39) & $lang[86] & Chr(39) & $lang[87]))
	GUICtrlCreateGroup("", -99, -99, 1, 1)
	$helpok = GUICtrlCreateButton("&OK", 165, 300, 75, 25, 0)
	GUICtrlSetOnEvent(-1,"helpex")
	If $noeffect = 0 Then DllCall("user32.dll", "int", "AnimateWindow", "hwnd", $Form2, "int", 500, "long", 0x00080000);fade-in
	GUISetState(@SW_SHOW)
	If $noeffect = 0 Then _GUIEnhanceAnimateTitle($Form2, "Help", $GUI_EN_TITLE_DROP, 25)
EndFunc   ;==>help


Func update()
	$lmpupdate = GUICreate("LMP - " & $cver, 258, 66, 193, 125)
	GUISetOnEvent($GUI_EVENT_CLOSE,"updex")
	GUISetBkColor(0xD8E4F8)
	If $theme = "Black" Then GUISetBkColor(0x000000)
	GUISetIcon($mupd)
	$txt = GUICtrlCreateLabel($lang[46] & $nver & $lang[47], 8, 8, 238, 17)
	If $theme = "Black" Then GUICtrlSetColor(-1, 0xFFFFFF)
	GUICtrlSetCursor(-1, 0)
	$dldb = GUICtrlCreateButton($lang[48], 8, 32, 91, 25, 0)
	GUICtrlSetOnEvent(-1,"dldf")
	$okb = GUICtrlCreateButton($lang[49], 160, 32, 91, 25, 0)
	GUICtrlSetOnEvent(-1,"updex")
	If $noeffect = 0 Then DllCall("user32.dll", "int", "AnimateWindow", "hwnd", $lmpupdate, "int", 500, "long", 0x00080000)
	GUISetState(@SW_SHOW)
EndFunc   ;==>update

Func add()
	$pcdir = FileSelectFolder($lang[55], @HomeDrive)
	If @error = 1 Then
		MsgBox(48, "L|M|TER Media Player", "Please select a folder !")
	ElseIf $pcdir = "" Then
		MsgBox(48, "L|M|TER Media Player", "Please select a folder !")
	Else
		Call("pcdir")
	EndIf
EndFunc   ;==>add

Func pcdir()
	If FileReadLine($inipath, 6) = "Enabled=1" Then GUICtrlSetState($playlist, $GUI_HIDE)
	$filesArray = RecursiveFileSearch($pcdir, "(?i)\.(mp3|wav|wma)")
	If Not IsArray($filesArray) Then
		MsgBox(48, "L|M|TER Media Player", "Empty directory and/or subdirectory found !")
		ctrlen()
		GUICtrlSetState($playlist, $GUI_SHOW)
	Else
		For $i = 1 To $filesArray[0]
			_GUICtrlStatusBar_SetText($statusbar, "Adding file ( " & $i & " of " & $filesArray[0] & " )", 0)

			$path = $filesArray[$i]
			$artist1 = _GetExtProperty($path, 16) & "|"
			$title1 = _GetExtProperty($path, 10) & "|"
			$album1 = _GetExtProperty($path, 17) & "|"

			GUICtrlCreateListViewItem($artist1 & $title1 & $album1 & $path, $playlist)
		Next
		
		If FileReadLine($inipath, 6) = "Enabled=1" Then GUICtrlSetState($playlist, $GUI_SHOW)
		_GUICtrlStatusBar_SetText($statusbar, "Finished ...", 0)
		ctrlen()
	EndIf
EndFunc   ;==>pcdir

Func remove()
	$hplaylist = GUICtrlGetHandle($playlist)
	_GUICtrlListView_DeleteItemsSelected($hplaylist)
EndFunc   ;==>remove

Func songgui()
	$songgui = GUICreate("Song Information", 413, 298)
	GUISetOnEvent($GUI_EVENT_CLOSE,"sguiex")
	GUISetBkColor(0xD8E4F8)
	If $theme = "Black" Then GUISetBkColor(0x000000)
	GUISetIcon($mabout)
	$bitrate = GUICtrlCreateLabel("Bit Rate : None", 12, 273, 300, 18)
	If $theme = "Black" Then GUICtrlSetColor(-1, 0xFFFFFF)
	GUICtrlSetFont($bitrate, Default, "800")
	GUICtrlSetData($bitrate, $lang[56] & " " & _GetExtProperty($playlistsong1, 22))
	$tracknr = GUICtrlCreateLabel("Track Number : None", 12, 249, 400, 18)
	If $theme = "Black" Then GUICtrlSetColor(-1, 0xFFFFFF)
	GUICtrlSetFont($tracknr, Default, "800")
	GUICtrlSetData($tracknr, $lang[57] & " " & _GetExtProperty($playlistsong1, 19))
	$ttime = GUICtrlCreateLabel("Duration : None", 12, 225, 400, 18)
	If $theme = "Black" Then GUICtrlSetColor(-1, 0xFFFFFF)
	GUICtrlSetFont($ttime, Default, "800")
	GUICtrlSetData($ttime, $lang[58] & " " & _GetExtProperty($playlistsong1, 21))
	$comments = GUICtrlCreateLabel("Comments : None", 12, 201, 400, 18)
	If $theme = "Black" Then GUICtrlSetColor(-1, 0xFFFFFF)
	GUICtrlSetFont($comments, Default, "800")
	GUICtrlSetData($comments, $lang[59] & " " & _GetExtProperty($playlistsong1, 14))
	$protected = GUICtrlCreateLabel("Protected : None", 12, 177, 400, 18)
	If $theme = "Black" Then GUICtrlSetColor(-1, 0xFFFFFF)
	GUICtrlSetFont($protected, Default, "800")
	GUICtrlSetData($protected, $lang[60] & " " & _GetExtProperty($playlistsong1, 23))
	$copyright = GUICtrlCreateLabel("Copyright : None", 12, 153, 400, 18)
	If $theme = "Black" Then GUICtrlSetColor(-1, 0xFFFFFF)
	GUICtrlSetFont($copyright, Default, "800")
	GUICtrlSetData($copyright, $lang[61] & " " & _GetExtProperty($playlistsong1, 15))
	$author = GUICtrlCreateLabel("Author : None", 12, 129, 400, 18)
	If $theme = "Black" Then GUICtrlSetColor(-1, 0xFFFFFF)
	GUICtrlSetFont($author, Default, "800")
	GUICtrlSetData($author, $lang[62] & " " & _GetExtProperty($playlistsong1, 9))
	$genre = GUICtrlCreateLabel("Genre : None", 12, 105, 400, 18)
	If $theme = "Black" Then GUICtrlSetColor(-1, 0xFFFFFF)
	GUICtrlSetFont($genre, Default, "800")
	GUICtrlSetData($genre, $lang[63] & " " & _GetExtProperty($playlistsong1, 20))
	$year = GUICtrlCreateLabel("Year : None", 12, 81, 400, 18)
	If $theme = "Black" Then GUICtrlSetColor(-1, 0xFFFFFF)
	GUICtrlSetFont($year, Default, "800")
	GUICtrlSetData($year, $lang[64] & " " & _GetExtProperty($playlistsong1, 18))
	$album = GUICtrlCreateLabel("Album : None", 12, 57, 400, 18)
	If $theme = "Black" Then GUICtrlSetColor(-1, 0xFFFFFF)
	GUICtrlSetFont($album, Default, "800")
	GUICtrlSetData($album, $lang[65] & " " & _GetExtProperty($playlistsong1, 17))
	$title = GUICtrlCreateLabel("Title : None", 12, 33, 400, 18)
	If $theme = "Black" Then GUICtrlSetColor(-1, 0xFFFFFF)
	GUICtrlSetFont($title, Default, "800")
	GUICtrlSetData($title, $lang[66] & " " & _GetExtProperty($playlistsong1, 10))
	$artist = GUICtrlCreateLabel("Artist : None", 12, 9, 400, 18)
	If $theme = "Black" Then GUICtrlSetColor(-1, 0xFFFFFF)
	GUICtrlSetFont($artist, Default, "800")
	GUICtrlSetData($artist, $lang[67] & " " & _GetExtProperty($playlistsong1, 16))
	$ok = GUICtrlCreateButton("&OK", 328, 264, 75, 25, 0)
	GUICtrlSetOnEvent(-1,"sguiex")
	If $noeffect = 0 Then DllCall("user32.dll", "int", "AnimateWindow", "hwnd", $songgui, "int", 500, "long", 0x00080000);fade-in
	GUISetState(@SW_SHOW)
	If $noeffect = 0 Then _GUIEnhanceAnimateTitle($songgui, "Song Information", $GUI_EN_TITLE_DROP, Default, 25)
EndFunc   ;==>songgui

Func updchk()
	If $debug = 1 Then FileClose($filed)
	InetGet("                                         ", @TempDir & "\lmp.ver", 1, 1)
	If @error Then MsgBox(32, "LMP Update", $lang[69])
	While @InetGetActive
	WEnd
	$dat = FileOpen(@TempDir & "\lmp.ver", 0)
	Global $nver = FileReadLine($dat, 1)
	FileClose($dat)
	If $nver = $cver Then
		MsgBox(32, "L|M|TER Media Player", $lang[70] & @CRLF & @CRLF & $lang[71] & " " & $cver & @CRLF & $lang[72] & " " & $nver)
	EndIf
	If $nver > $cver Then
		update()
	EndIf
	If $debug = 1 Then $filed = FileOpen($debuglog, 1)
EndFunc   ;==>updchk

Func settings()
	$settingsgui = GUICreate($lang[73], 508, 308)
	GUISetOnEvent($GUI_EVENT_CLOSE,"setex")
	GUISetBkColor(0xD8E4F8)
	If $theme = "Black" Then GUISetBkColor(0x555555)
	GUISetIcon($mset)
	$Group1 = GUICtrlCreateGroup($lang[74], 8, 8, 155, 73)
	$enable = GUICtrlCreateRadio($lang[75], 16, 32, 145, 17)
	If $theme = "Black" Then
	DllCall("UxTheme.dll", "int", "SetWindowTheme", "hwnd", GUICtrlGetHandle($enable), "wstr", "", "wstr", "")
	GUICtrlSetColor(-1, 0xFFFFFF)
	EndIf
	If FileReadLine($inipath, 2) = "Enabled=1" Then GUICtrlSetState($enable, $GUI_CHECKED)
	$disable = GUICtrlCreateRadio($lang[76], 16, 56, 57, 17)
	If $theme = "Black" Then
	DllCall("UxTheme.dll", "int", "SetWindowTheme", "hwnd", GUICtrlGetHandle($disable), "wstr", "", "wstr", "")
	GUICtrlSetColor(-1, 0xFFFFFF)
	EndIf
	If FileReadLine($inipath, 2) = "Enabled=0" Then GUICtrlSetState($disable, $GUI_CHECKED)
	GUICtrlCreateGroup("", -99, -99, 1, 1)
	$apply = GUICtrlCreateButton($lang[77], 8, 271, 490, 25)
	GUICtrlSetOnEvent(-1,"setapply")
	GUICtrlSetFont(-1, 8, 800, 0, "MS Sans Serif")
	$Group2 = GUICtrlCreateGroup($lang[78], 176, 8, 155, 73)
	$minenabled = GUICtrlCreateRadio($lang[75], 184, 32, 145, 17)
	If $theme = "Black" Then
	DllCall("UxTheme.dll", "int", "SetWindowTheme", "hwnd", GUICtrlGetHandle($minenabled), "wstr", "", "wstr", "")
	GUICtrlSetColor(-1, 0xFFFFFF)
	EndIf
	If FileReadLine($inipath, 4) = "Enabled=1" Then GUICtrlSetState($minenabled, $GUI_CHECKED)
	$mindisabled = GUICtrlCreateRadio($lang[76], 184, 56, 113, 17)
	If $theme = "Black" Then
	DllCall("UxTheme.dll", "int", "SetWindowTheme", "hwnd", GUICtrlGetHandle($mindisabled), "wstr", "", "wstr", "")
	GUICtrlSetColor(-1, 0xFFFFFF)
	EndIf
	If FileReadLine($inipath, 4) = "Enabled=0" Then GUICtrlSetState($mindisabled, $GUI_CHECKED)
	GUICtrlCreateGroup("", -99, -99, 1, 1)
	$Group3 = GUICtrlCreateGroup($lang[79], 8, 96, 155, 73)
	$showen = GUICtrlCreateRadio($lang[75], 16, 120, 145, 17)
	If $theme = "Black" Then
	DllCall("UxTheme.dll", "int", "SetWindowTheme", "hwnd", GUICtrlGetHandle($showen), "wstr", "", "wstr", "")
	GUICtrlSetColor(-1, 0xFFFFFF)
	EndIf
	If FileReadLine($inipath, 6) = "Enabled=1" Then GUICtrlSetState($showen, $GUI_CHECKED)
	$showdis = GUICtrlCreateRadio($lang[76], 16, 144, 145, 17)
	If $theme = "Black" Then
	DllCall("UxTheme.dll", "int", "SetWindowTheme", "hwnd", GUICtrlGetHandle($showdis), "wstr", "", "wstr", "")
	GUICtrlSetColor(-1, 0xFFFFFF)
	EndIf
	If FileReadLine($inipath, 6) = "Enabled=0" Then GUICtrlSetState($showdis, $GUI_CHECKED)
	GUICtrlCreateGroup("", -99, -99, 1, 1)
	$Group4 = GUICtrlCreateGroup("Shuffle", 176, 96, 155, 73)
	$randen = GUICtrlCreateRadio($lang[75], 184, 120, 145, 17)
	If $theme = "Black" Then
	DllCall("UxTheme.dll", "int", "SetWindowTheme", "hwnd", GUICtrlGetHandle($randen), "wstr", "", "wstr", "")
	GUICtrlSetColor(-1, 0xFFFFFF)
	EndIf
	If FileReadLine($inipath, 8) = "Enabled=1" Then GUICtrlSetState($randen, $GUI_CHECKED)
	$disen = GUICtrlCreateRadio($lang[76], 184, 144, 145, 17)
	If $theme = "Black" Then
	DllCall("UxTheme.dll", "int", "SetWindowTheme", "hwnd", GUICtrlGetHandle($disen), "wstr", "", "wstr", "")
	GUICtrlSetColor(-1, 0xFFFFFF)
	EndIf
	If FileReadLine($inipath, 8) = "Enabled=0" Then GUICtrlSetState($disen, $GUI_CHECKED)
	GUICtrlCreateGroup("", -99, -99, 1, 1)
	$Group5 = GUICtrlCreateGroup($lang[80], 344, 8, 155, 73)
	$saveen = GUICtrlCreateRadio($lang[75], 352, 32, 145, 17)
	If $theme = "Black" Then
	DllCall("UxTheme.dll", "int", "SetWindowTheme", "hwnd", GUICtrlGetHandle($saveen), "wstr", "", "wstr", "")
	GUICtrlSetColor(-1, 0xFFFFFF)
	EndIf
	If FileReadLine($inipath, 10) = "Enabled=1" Then GUICtrlSetState($saveen, $GUI_CHECKED)
	$savedis = GUICtrlCreateRadio($lang[76], 352, 56, 113, 17)
	If $theme = "Black" Then
	DllCall("UxTheme.dll", "int", "SetWindowTheme", "hwnd", GUICtrlGetHandle($savedis), "wstr", "", "wstr", "")
	GUICtrlSetColor(-1, 0xFFFFFF)
	EndIf
	If FileReadLine($inipath, 10) = "Enabled=0" Then GUICtrlSetState($savedis, $GUI_CHECKED)
	GUICtrlCreateGroup("", -99, -99, 1, 1)
	$Group6 = GUICtrlCreateGroup($lang[81], 344, 96, 155, 73)
	$openen = GUICtrlCreateRadio($lang[75], 352, 120, 145, 17)
	If $theme = "Black" Then
	DllCall("UxTheme.dll", "int", "SetWindowTheme", "hwnd", GUICtrlGetHandle($openen), "wstr", "", "wstr", "")
	GUICtrlSetColor(-1, 0xFFFFFF)
	EndIf
	If FileReadLine($inipath, 12) = "Enabled=1" Then GUICtrlSetState($openen, $GUI_CHECKED)
	$opendis = GUICtrlCreateRadio($lang[76], 352, 144, 113, 17)
	If $theme = "Black" Then
	DllCall("UxTheme.dll", "int", "SetWindowTheme", "hwnd", GUICtrlGetHandle($opendis), "wstr", "", "wstr", "")
	GUICtrlSetColor(-1, 0xFFFFFF)
	EndIf
	If FileReadLine($inipath, 12) = "Enabled=0" Then GUICtrlSetState($opendis, $GUI_CHECKED)
	GUICtrlCreateGroup("", -99, -99, 1, 1)
	$Group7 = GUICtrlCreateGroup("Language", 8, 184, 155, 73)
	GUICtrlCreateLabel($lang[82], 16, 214, 80, 23)
	If $theme = "Black" Then GUICtrlSetColor(-1, 0xFFFFFF)
	$lang_set = GUICtrlCreateCombo($lng, 102, 210, 50, 25)
	If $lng = "PL" Then GUICtrlSetData(-1, "ENG")
	If $lng = "ENG" Then GUICtrlSetData(-1, "PL")
	$Group8 = GUICtrlCreateGroup("Theme", 176, 184, 155, 73)
	$classic = GUICtrlCreateRadio("Classic Blue ( Default )", 184, 208, 145, 17)
	If $theme = "Black" Then
	DllCall("UxTheme.dll", "int", "SetWindowTheme", "hwnd", GUICtrlGetHandle($classic), "wstr", "", "wstr", "")
	GUICtrlSetColor(-1, 0xFFFFFF)
	EndIf
	If FileReadLine($inipath, 16) = "Blue" Then GUICtrlSetState($classic, $GUI_CHECKED)
	$blackrd = GUICtrlCreateRadio("Black", 184, 232, 145, 17)
	If $theme = "Black" Then
	DllCall("UxTheme.dll", "int", "SetWindowTheme", "hwnd", GUICtrlGetHandle($blackrd), "wstr", "", "wstr", "")
	GUICtrlSetColor(-1, 0xFFFFFF)
	EndIf
	If FileReadLine($inipath, 16) = "Black" Then GUICtrlSetState($blackrd, $GUI_CHECKED)
	GUICtrlCreateGroup("", -99, -99, 1, 1)
	$Label146 = GUICtrlCreateLabel("For changes to take effect, you" & @CRLF & "need to restart LMP !", 344, 192, 152, 65)
	If $theme = "Black" Then GUICtrlSetColor(-1, 0xFFFFFF)

	If $noeffect = 0 Then DllCall("user32.dll", "int", "AnimateWindow", "hwnd", $settingsgui, "int", 500, "long", 0x00080000);fade-in
	GUISetState(@SW_SHOW)
EndFunc   ;==>settings

Func WM_NOTIFY($hWnd, $MsgID, $wParam, $lParam)
	Local $tagNMHDR, $event, $hwndFrom, $code
	$tagNMHDR = DllStructCreate("int;int;int", $lParam)
	If @error Then Return 0
	$code = DllStructGetData($tagNMHDR, 3)
	If $wParam = $playlist And $code = -3 Then $DoubleClicked = True
	Return $GUI_RUNDEFMSG
EndFunc   ;==>WM_NOTIFY

Func DoubleClickFunc()
	If _SoundStatus($playlistsong) = "playing" Then
	For $i = (100 - GUICtrlRead($volslider)) * 10 To 0 Step -5
		_SoundVolume($playlistsong, $i)
	Next
	_SoundStop($playlistsong)
	EndIf
	$dbclick1 = GUICtrlRead(GUICtrlRead($playlist))
	$dbclick2 = StringTrimRight($dbclick1, 1)
	$dbclick3 = StringSplit($dbclick2, "|")
	If $dbclick3[0] <> 1 Then
		$playlistsong1 = $dbclick3[4]
		start($playlistsong1)
	Else
		TrayTip("L|M|TER Media Player v. " & $cver, $lang[43], 10, 2)
		_GUICtrlStatusBar_SetText($statusbar, $lang[44], 0)
	EndIf
EndFunc   ;==>DoubleClickFunc

Func AddFile()
	$sFile = FileOpenDialog("Open File", "", "Audio Files (*.mp3;*.wav;*.wma)|MP3 (*.mp3)|WAV (*.wav)|WMA (*.wma)")
	If FileExists($sFile) Then
		$path = $sFile
		$artist1 = _GetExtProperty($path, 16) & "|"
		$title1 = _GetExtProperty($path, 10) & "|"
		$album1 = _GetExtProperty($path, 17) & "|"
		GUICtrlCreateListViewItem($artist1 & $title1 & $album1 & $path, $playlist)
	Else
		MsgBox(48, "L|M|TER Media Player", "Please select a file to add !")
	EndIf
EndFunc   ;==>AddFile

Func search()
	$searchstring = InputBox("L|M|TER Media Player", $lang[83] & @CRLF & @CRLF & "NOTICE : LMP plays the most apropiate song that matches the search string !", "", " M")
	If @error = 1 Then
	Else
		$playlisthandle = GUICtrlGetHandle($playlist)
		$index = _GUICtrlListView_FindInText($playlisthandle, $searchstring)
		$searchtxt = _GUICtrlListView_GetItemTextArray($playlisthandle, $index)
		If _SoundStatus($playlistsong) = "playing" Then
		_SoundStop($playlistsong)
		For $i = (100 - GUICtrlRead($volslider)) * 10 To 0 Step -5
			_SoundVolume($playlistsong, $i)
		Next
		EndIf
		$iY = _GUICtrlListView_GetItemPositionY($playlisthandle, $index - 2)
		_GUICtrlListView_Scroll($playlisthandle, 0, $iY)
		_GUICtrlListView_SetItemFocused($playlisthandle, $index)
		_GUICtrlListView_SetItemSelected($playlisthandle, $index)
		$playlistsong1 = $searchtxt[4]
		start($playlistsong1)
	EndIf
EndFunc   ;==>search

Func nexts()
	If _SoundStatus($playlistsong) = "playing" Then
	For $i = (100 - GUICtrlRead($volslider)) * 10 To 0 Step -5
		_SoundVolume($playlistsong, $i)
	Next
	_SoundStop($playlistsong)
	EndIf
	$pls1 = GUICtrlGetHandle($playlist)
	$max1 = _GUICtrlListView_GetItemCount($pls1)
	$rand1 = Random(1, $max1)
	$next1 = _GUICtrlListView_GetItemTextArray($pls1, $rand1)
	$iY1 = _GUICtrlListView_GetItemPositionY($pls1, $rand1 - 2)
	_GUICtrlListView_Scroll($pls1, 0, $iY1)
	_GUICtrlListView_SetItemFocused($pls1, $rand1)
	_GUICtrlListView_SetItemSelected($pls1, $rand1)
	$playlistsong1 = $next1[4]
	start($playlistsong1)
EndFunc   ;==>nexts

Func WM_DROPFILES_FUNC($hWnd, $MsgID, $wParam, $lParam)
	Local $nSize, $pFileName
	Local $nAmt = DllCall("shell32.dll", "int", "DragQueryFile", "hwnd", $wParam, "int", 0xFFFFFFFF, "ptr", 0, "int", 255)

	For $i = 0 To $nAmt[0] - 1
		$nSize = DllCall("shell32.dll", "int", "DragQueryFile", "hwnd", $wParam, "int", $i, "ptr", 0, "int", 0)
		$nSize = $nSize[0] + 1
		$pFileName = DllStructCreate("char[" & $nSize & "]")
		DllCall("shell32.dll", "int", "DragQueryFile", "hwnd", $wParam, "int", $i, "ptr", DllStructGetPtr($pFileName), "int", $nSize)
		ReDim $gaDropFiles[$i + 1]
		$gaDropFiles[$i] = DllStructGetData($pFileName, 1)
		$pFileName = 0
	Next

	GetDroppedFiles()
EndFunc   ;==>WM_DROPFILES_FUNC

Func GetDroppedFiles()
	Local $nbrFiles
	Local $i

	$nbrFiles = UBound($gaDropFiles) - 1; -- global
	For $i = 0 To $nbrFiles
		_GUICtrlStatusBar_SetText($statusbar, "Adding file ( " & $i & " of " & $nbrFiles & " )", 2)

		If FileExists($gaDropFiles[$i]) Then

			$path = $gaDropFiles[$i]
			$artist1 = _GetExtProperty($path, 16) & "|"
			$title1 = _GetExtProperty($path, 10) & "|"
			$album1 = _GetExtProperty($path, 17) & "|"

			GUICtrlCreateListViewItem($artist1 & $title1 & $album1 & $path, $playlist)

		EndIf
	Next
EndFunc   ;==>GetDroppedFiles

Func start($playlistsong1)
	_ReduceMemory(@AutoItPID)
	$playlistsong = _SoundOpen($playlistsong1)
	_SoundPlay($playlistsong)
	If @error > 0 Then
		MsgBox(48, "L|M|TER Media Player", "An error has ocurred when trying to play the sound !" & @CRLF & "Error code : " & @error & " ( " & @extended & " )")
		If $debug = 1 Then FileWrite($filed, "An error has ocurred when trying to play the sound (" & $playlistsong1 & ") !" & "Error code : " & @error & " ( Ext :" & @extended & " )" & @CRLF)
	EndIf
	For $i = 0 To (100 - GUICtrlRead($volslider)) * 10 Step 5
		_SoundVolume($playlistsong, $i)
	Next
	GUICtrlSetState($PosSlider, $GUI_ENABLE)
	GUICtrlSetLimit($PosSlider, _SoundLength($playlistsong1, 2) / 1000)
	GUICtrlSetState($nextbtn, $GUI_ENABLE)
	GUICtrlSetState($search, $GUI_ENABLE)
	TrayItemSetState($trayplay, $GUI_ENABLE)
	TrayItemSetState($traystop, $GUI_ENABLE)
	TrayItemSetState($traypause, $GUI_ENABLE)
	TrayItemSetState($traysonginfo, $GUI_ENABLE)
	TrayItemSetState($traynext, $GUI_ENABLE)
	TrayItemSetState($traysrch, $GUI_ENABLE)
	_GUICtrlStatusBar_SetText($statusbar, "Status : Playing ...", 0)
	_GUICtrlStatusBar_SetText($statusbar, "Artist : " & _GetExtProperty($playlistsong1, 16), 1)
	_GUICtrlStatusBar_SetText($statusbar, "Title : " & _GetExtProperty($playlistsong1, 10), 2)
	TraySetToolTip("L|M|TER Media Player v. " & $cver & @CRLF & _GetExtProperty($playlistsong1, 16) & " - " & _GetExtProperty($playlistsong1, 10))
	$artist2 = _GetExtProperty($playlistsong1, 16)
	$title2 = _GetExtProperty($playlistsong1, 10)
	$album2 = _GetExtProperty($playlistsong1, 17)
	$duration2 = _GetExtProperty($playlistsong1, 21)
	_SoundVolume($playlistsong, (100 - GUICtrlRead($volslider)) * 10)
	pop($artist2, $title2, $album2, $duration2)
	_ReduceMemory(@AutoItPID)
EndFunc   ;==>start

Func ctrlen()
	GUICtrlSetState($search, $GUI_ENABLE)
	GUICtrlSetState($nextbtn, $GUI_ENABLE)
	TrayItemSetState($trayplay, $GUI_ENABLE)
	TrayItemSetState($traystop, $GUI_ENABLE)
	TrayItemSetState($traypause, $GUI_ENABLE)
	TrayItemSetState($traysonginfo, $GUI_ENABLE)
	TrayItemSetState($traynext, $GUI_ENABLE)
	TrayItemSetState($traysrch, $GUI_ENABLE)
EndFunc   ;==>ctrlen

Func plssave()
	$pls2 = GUICtrlGetHandle($playlist)
	$max2 = _GUICtrlListView_GetItemCount($pls2)
	
	$plsloc1 = @AppDataDir & "\LMP\playlist.lmp"
	If FileExists($plsloc1) = 0 Then _FileCreate($plsloc1)
	$plsloc = FileOpen($plsloc1, 2)

	For $i = 0 To $max2
		$plsfile = _GUICtrlListView_GetItemTextArray($pls2, $i)
		FileWrite($plsloc, $plsfile[1] & "|" & $plsfile[2] & "|" & $plsfile[3] & "|" & $plsfile[4] & @CRLF)
		_GUICtrlStatusBar_SetText($statusbar, "Saving playlist ( " & $i & " of " & $max2 & " )", 0)
	Next

	FileClose($plsloc)
EndFunc   ;==>plssave

Func plsopen()
	$plsloc2 = @AppDataDir & "\LMP\playlist.lmp"
	$plsloc3 = FileOpen($plsloc2, 0)
	$pls3 = GUICtrlGetHandle($playlist)
	$max3 = _FileCountLines($plsloc2) - 1
	If FileReadLine($inipath, 6) = "Enabled=1" Then GUICtrlSetState($playlist, $GUI_HIDE)

	For $i = 1 To $max3
		_GUICtrlStatusBar_SetText($statusbar, "Creating playlist ( " & $i & " of " & $max3 & " )", 0)
		$fileread = FileReadLine($plsloc3, $i)

		GUICtrlCreateListViewItem($fileread, $playlist)
	Next
	If FileReadLine($inipath, 6) = "Enabled=1" Then
	GUICtrlSetState($playlist, $GUI_SHOW)
	GUICtrlSendMsg($playlist, 0x101E, 0, 150)
	GUICtrlSendMsg($playlist, 0x101E, 1, 150)
	GUICtrlSendMsg($playlist, 0x101E, 2, 150)
	GUICtrlSendMsg($playlist, 0x101E, 3, 145)
	EndIf
	_GUICtrlStatusBar_SetText($statusbar, "Playlist loaded ...", 0)
EndFunc   ;==>plsopen

Func rcsonggui()
	$rcsong3 = GUICtrlRead(GUICtrlRead($playlist))
	$rcsong2 = StringTrimRight($rcsong3, 1)
	$rcsong1 = StringSplit($rcsong2, "|")
	$rcsong = $rcsong1[4]
	$songgui = GUICreate("Song Information", 413, 298)
	GUISetOnEvent($GUI_EVENT_CLOSE,"rcsguiex")
	GUISetBkColor(0xD8E4F8)
	If $theme = "Black" Then GUISetBkColor(0x000000)
	GUISetIcon($mabout)
	$bitrate = GUICtrlCreateLabel("Bit Rate : None", 12, 273, 300, 18)
	If $theme = "Black" Then GUICtrlSetColor(-1, 0xFFFFFF)
	GUICtrlSetFont($bitrate, Default, "800")
	GUICtrlSetData($bitrate, "Bit Rate : " & _GetExtProperty($rcsong, 22))
	$tracknr = GUICtrlCreateLabel("Track Number : None", 12, 249, 400, 18)
	If $theme = "Black" Then GUICtrlSetColor(-1, 0xFFFFFF)
	GUICtrlSetFont($tracknr, Default, "800")
	GUICtrlSetData($tracknr, "Track Number : " & _GetExtProperty($rcsong, 19))
	$ttime = GUICtrlCreateLabel("Duration : None", 12, 225, 400, 18)
	If $theme = "Black" Then GUICtrlSetColor(-1, 0xFFFFFF)
	GUICtrlSetFont($ttime, Default, "800")
	GUICtrlSetData($ttime, "Duration : " & _GetExtProperty($rcsong, 21))
	$comments = GUICtrlCreateLabel("Comments : None", 12, 201, 400, 18)
	If $theme = "Black" Then GUICtrlSetColor(-1, 0xFFFFFF)
	GUICtrlSetFont($comments, Default, "800")
	GUICtrlSetData($comments, "Comments : " & _GetExtProperty($rcsong, 14))
	$protected = GUICtrlCreateLabel("Protected : None", 12, 177, 400, 18)
	If $theme = "Black" Then GUICtrlSetColor(-1, 0xFFFFFF)
	GUICtrlSetFont($protected, Default, "800")
	GUICtrlSetData($protected, "Protected : " & _GetExtProperty($rcsong, 23))
	$copyright = GUICtrlCreateLabel("Copyright : None", 12, 153, 400, 18)
	If $theme = "Black" Then GUICtrlSetColor(-1, 0xFFFFFF)
	GUICtrlSetFont($copyright, Default, "800")
	GUICtrlSetData($copyright, "Copyright : " & _GetExtProperty($rcsong, 15))
	$author = GUICtrlCreateLabel("Author : None", 12, 129, 400, 18)
	If $theme = "Black" Then GUICtrlSetColor(-1, 0xFFFFFF)
	GUICtrlSetFont($author, Default, "800")
	GUICtrlSetData($author, "Author : " & _GetExtProperty($rcsong, 9))
	$genre = GUICtrlCreateLabel("Genre : None", 12, 105, 400, 18)
	If $theme = "Black" Then GUICtrlSetColor(-1, 0xFFFFFF)
	GUICtrlSetFont($genre, Default, "800")
	GUICtrlSetData($genre, "Genre : " & _GetExtProperty($rcsong, 20))
	$year = GUICtrlCreateLabel("Year : None", 12, 81, 400, 18)
	If $theme = "Black" Then GUICtrlSetColor(-1, 0xFFFFFF)
	GUICtrlSetFont($year, Default, "800")
	GUICtrlSetData($year, "Year : " & _GetExtProperty($rcsong, 18))
	$album = GUICtrlCreateLabel("Album : None", 12, 57, 400, 18)
	If $theme = "Black" Then GUICtrlSetColor(-1, 0xFFFFFF)
	GUICtrlSetFont($album, Default, "800")
	GUICtrlSetData($album, "Album : " & _GetExtProperty($rcsong, 17))
	$title = GUICtrlCreateLabel("Title : None", 12, 33, 400, 18)
	If $theme = "Black" Then GUICtrlSetColor(-1, 0xFFFFFF)
	GUICtrlSetFont($title, Default, "800")
	GUICtrlSetData($title, "Title : " & _GetExtProperty($rcsong, 10))
	$artist = GUICtrlCreateLabel("Artist : None", 12, 9, 400, 18)
	If $theme = "Black" Then GUICtrlSetColor(-1, 0xFFFFFF)
	GUICtrlSetFont($artist, Default, "800")
	GUICtrlSetData($artist, "Artist : " & _GetExtProperty($rcsong, 16))
	$ok = GUICtrlCreateButton("&OK", 328, 264, 75, 25, 0)
	GUICtrlSetOnEvent(-1,"rcsguiex")
	If $noeffect = 0 Then DllCall("user32.dll", "int", "AnimateWindow", "hwnd", $songgui, "int", 500, "long", 0x00080000);fade-in
	GUISetState(@SW_SHOW)
	If $noeffect = 0 Then _GUIEnhanceAnimateTitle($songgui, "Song Information", $GUI_EN_TITLE_DROP, Default, 25)
EndFunc   ;==>rcsonggui

Func LVSort($hWnd, $nItem1, $nItem2, $nColumn)
	Local $nSort
	Local $tInfo = DllStructCreate($tagLVFINDINFO)
	DllStructSetData($tInfo, "Flags", $LVFI_PARAM)

	; Switch the sorting direction
	If $nColumn = $nCurCol Then
		If Not $bSet Then
			$nSortDir = $nSortDir * - 1
			$bSet = 1
		EndIf
	Else
		$nSortDir = 1
	EndIf
	$nCol = $nColumn

	DllStructSetData($tInfo, "Param", $nItem1)
	$val1 = _GUICtrlListView_FindItem($hWnd, -1, $tInfo)
	DllStructSetData($tInfo, "Param", $nItem2)
	$val2 = _GUICtrlListView_FindItem($hWnd, -1, $tInfo)
	$val1 = _GUICtrlListView_GetItemText($hWnd, $val1, $nColumn)
	$val2 = _GUICtrlListView_GetItemText($hWnd, $val2, $nColumn)

	$nResult = 0 ; No change of item1 and item2 positions

	If $val1 < $val2 Then
		$nResult = -1 ; Put item2 before item1
	ElseIf $val1 > $val2 Then
		$nResult = 1 ; Put item2 behind item1
	EndIf

	$nResult = $nResult * $nSortDir

	Return $nResult
EndFunc   ;==>LVSort

;///////////////////////////////;///////////////////////////////
;///////////////////////////////;///////////////////////////////
;///////////////////////////////;///////////////////////////////
;///////////////////////////////;///////////////////////////////
;///////////////////////////////;///////////////////////////////

Func vplayer()
	Local $vExit = 0
	;Opt("GUIOnEventMode",0)
	$vfile = FileOpenDialog("L|M|TER Video Player - Select a video to play", @HomeDrive, "Video Files (*.avi;*.mpg;*.wmv) |AVI (*.avi) |MPG (*.mpg) |WMV (*.wmv)")
	If @error = 1 Then
		MsgBox(48, "L|M|TER Media Player", "Please select a video !")
	ElseIf $vfile = "" Then
		MsgBox(48, "L|M|TER Media Player", "Please select a video !")
	Else
		$w1 = _GetExtProperty($vfile, 27)
		$w2 = StringSplit($w1, " ")
		$w = $w2[1]
		$vw = 0
		$h1 = _GetExtProperty($vfile, 28)
		$h2 = StringSplit($h1, " ")
		$h = $h2[1]
		$gh = $h + 65
		$bh = $h + 10
		$duration = _GetExtProperty($vfile, 21)
		If $w < 350 Then
			$vw = (510 - $w) / 2
			$w = 510
		EndIf
		If $h < 350 Then $h = 350

		Global $vplayer = GUICreate("L|M|TER Video Player v." & $vver & " - © 2008 L|M|TER", $w, $gh)
		GUISetBkColor(0x000000)
		GUISetIcon($mvid)
		Global $vplay = GUICtrlCreatePic($plimgv, 8, $bh, 50, 50)
		GUICtrlSetOnHover(-1, "Hover_Func", "Leave_Hover_Func")
		Global $vstop = GUICtrlCreatePic($stimgv, 64, $bh, 50, 50)
		GUICtrlSetOnHover(-1, "Hover_Func", "Leave_Hover_Func")
		Global $vpause = GUICtrlCreatePic($paimgv, 120, $bh, 50, 50)
		GUICtrlSetOnHover(-1, "Hover_Func", "Leave_Hover_Func")
		Global $clabel = GUICtrlCreateLabel("00:00:00", 183, $bh + 35, 44, 17)
		GUICtrlSetColor(-1, 0xFFFFFF)
		Global $hlabel = GUICtrlCreateLabel("Press F1 for help.", 415, $bh + 35, 100, 17)
		GUICtrlSetColor(-1, 0xFFFFFF)
		Global $dlabel = GUICtrlCreateLabel(" / " & $duration, 225, $bh + 35, 57, 17)
		GUICtrlSetColor(-1, 0xFFFFFF)
		Global $slider = GUICtrlCreateSlider(175, $bh + 10, 330, 25)
		GUICtrlSetBkColor($slider, 0x000000)
		GUICtrlSetState($slider, @SW_DISABLE)
		Global $player = _wmpcreate(1, $vw, 0, $w, $h)
		If $noeffect = 0 Then DllCall("user32.dll", "int", "AnimateWindow", "hwnd", $vplayer, "int", 500, "long", 0x00080000);fade-in
		GUISetState(@SW_SHOW)

		_wmpsetvalue($player, "nocontrols");hides controls
		_wmpsetvalue($player, "cm");disables right-click
		_wmpsetvalue($player, "volume", 100);sets volume to 100
		_wmploadmedia($player, $vfile)
		
		GUISetOnEvent($GUI_EVENT_CLOSE, "_Vclose" )
		GUICtrlSetOnEvent($vplay, "_Vplay" )
		GUICtrlSetOnEvent($vpause, "_Vpause" )
		GUICtrlSetOnEvent($vstop, "_Vstop" )

		While _wmpsetvalue($player, "getduration") = 0
			Sleep(50)
		WEnd
		GUICtrlSetLimit($slider, _wmpsetvalue($player, "getduration"), 0)
		#cs
		While 1
			Sleep (100)
			;#cs
			$nMsg = GUIGetMsg()
			Switch $nMsg
				Case $GUI_EVENT_CLOSE
					_wmpsetvalue($player, "stop")
					If $noeffect = 0 Then DllCall("user32.dll", "int", "AnimateWindow", "hwnd", $vplayer, "int", 500, "long", 0x00090000)
					GUIDelete($vplayer)
					_ReduceMemory(@AutoItPID)
					HotKeySet("{F1}")
					Opt("GUIOnEventMode",1)
					ExitLoop
				Case $vplay
					_wmpsetvalue($player, "play")
				Case $vstop
					_wmpsetvalue($player, "stop")
				Case $vpause
					If WMGetState() = "Playing" Then
						_wmpsetvalue($player, "pause")
					Else
						_wmpsetvalue($player, "play")
					EndIf
			EndSwitch
			;#ce
			If WMGetState() = "Stopped" Then
				If GUICtrlRead($slider) <> Round(_wmpsetvalue($player, "getposition")) Then GUICtrlSetData($slider, _wmpsetvalue($player, "getposition"))
				If GUICtrlRead($clabel) <> "00:00:00" Then GUICtrlSetData($clabel, "00:00:00")
			EndIf
			If WMGetState() = "Playing" Then
				If GUICtrlRead($slider) <> Round(_wmpsetvalue($player, "getposition")) Then GUICtrlSetData($slider, _wmpsetvalue($player, "getposition"))
				If GUICtrlRead($clabel) <> "00:" & _wmpsetvalue($player, "getpositionstring") Then GUICtrlSetData($clabel, "00:" & _wmpsetvalue($player, "getpositionstring"))
			EndIf
			If WinActive("L|M|TER Video Player", "") = 1 Then HotKeySet("{F1}", "VHelp")
			If WinActive("L|M|TER Video Player", "") = 0 Then HotKeySet("{F1}")

			$cursor = GUIGetCursorInfo($vplayer)
			If $cursor[2] = 1 And $cursor[4] = $slider Then
				If _IsPressed("01") And WinActive("L|M|TER Video Player v.") Then
					While _IsPressed("01")
						Sleep(100)
					WEnd
					_wmpsetvalue($player, "setposition", GUICtrlRead($slider))
				EndIf
			EndIf
			
			If $vExit = 1 Then ExitLoop
		WEnd
		#ce
	EndIf

EndFunc   ;==>vplayer

#region VIDEO PLAYER FUNCTIONS

Func _Vclose() ;GUI close button is pressed
	_wmpsetvalue($player, "stop")
	If $noeffect = 0 Then DllCall("user32.dll", "int", "AnimateWindow", "hwnd", $vplayer, "int", 500, "long", 0x00090000)
	GUIDelete($vplayer)
	_ReduceMemory(@AutoItPID)
	HotKeySet("{F1}")
	;Opt("GUIOnEventMode",1)
EndFunc

Func _Vplay()
	_wmpsetvalue($player, "play")
EndFunc

Func _Vpause()
	If WMGetState() = "Playing" Then
		_wmpsetvalue($player, "pause")
	Else
		_wmpsetvalue($player, "play")
	EndIf
EndFunc

Func _Vstop()
	_wmpsetvalue($player, "stop")
EndFunc

#EndRegion

;///////////////////////////////;///////////////////////////////
;///////////////////////////////;///////////////////////////////
;///////////////////////////////;///////////////////////////////
;///////////////////////////////;///////////////////////////////
;///////////////////////////////;///////////////////////////////

Func VHelp()
	MsgBox(32, "L|M|TER Video Player - © 2008 L|M|TER", "Shortcuts : " & @CRLF & @CRLF & "Doubleclick on video - Enters full-screen mode" & @CRLF & "Pressing ESC in full-screen mode - Exits the full-screen mode" & @CRLF & "Left clicking in full-screen mode - Pauses the video" & @CRLF & @CRLF & "L|M|TER Video Player v." & $vver & @CRLF & "All Rights Reserved." & @CRLF & "Copyright © 2008 - L|M|TER")
EndFunc   ;==>VHelp

Func _SoundVolume($sSnd_id, $Volume); $Volume: 0 - 1000,  1000= normal
	;Declare variables
	Local $iRet
	If StringInStr($sSnd_id, '!') Then Return SetError(3, 0, 0); invalid file/alias
	If $Volume < 0 Or $Volume > 1000 Then Return SetError(1, 0, 0)
	$iRet = mciSendString("setaudio " & FileGetShortName($sSnd_id) & " volume to " & $Volume)
	;return
	If $iRet = 0 Then
		Return 1
	Else
		Return SetError(1, 0, 0)
	EndIf
EndFunc   ;==>_SoundVolume

Func _SoundTimeToMs($Hours, $Minutes, $Seconds)
	Return ($Hours * 3600000) + ($Minutes * 60000) + ($Seconds * 1000)
EndFunc   ;==>_SoundTimeToMs

Func _SoundMsToTime($ms)
	Local $Return[3]
	If $ms >= 3600000 Then; 1000*60*60 = 3600000
		$Hours = Floor($ms / 3600000)
		$Rest = $ms - ($Hours * 3600000)
	Else
		$Hours = 0
		$Rest = $ms
	EndIf
	If $Rest >= 60000 Then; 1000*60 = 60000
		$Minutes = Floor($Rest / 60000)
		$Rest = $Rest - ($Minutes * 60000)
	Else
		$Minutes = 0
		$Rest = $ms
	EndIf
	$Seconds = Round($Rest / 1000)
	$Return[0] = $Hours
	$Return[1] = $Minutes
	$Return[2] = $Seconds
	Return $Return
EndFunc   ;==>_SoundMsToTime

Func _SoundInfo($sSnd_id, $Parameter); look at "http://msdn2.microsoft.com/en-us/library/ms713277(VS.85).aspx" at the table "digitalvideo" for possible parameters

	If StringInStr($sSnd_id, '!') Then Return SetError(3, 0, 0); invalid file/alias

	Return mciSendString("status " & FileGetShortName($sSnd_id) & " " & $Parameter)
EndFunc   ;==>_SoundInfo

Func pop($artst, $sng, $albm, $durtion)
	_SoundVolume($playlistsong, (100 - GUICtrlRead($volslider)) * 10)
	$Wpop = GUICreate("LMP", 269, 146, @DesktopWidth - 280, @DesktopHeight - 170, $WS_POPUP, $WS_EX_TOOLWINDOW)
	GUISetOnEvent($GUI_EVENT_CLOSE,"popex")
	GUISetBkColor(0xD8E4F8)
	If $theme = "Black" Then GUISetBkColor(0x000000)
	DllCall("user32.dll", "int", "AnimateWindow", "hwnd", $Wpop, "int", 300, "long", 0x00040008);slide-in from bottom
	$Label132 = GUICtrlCreateLabel("L|M|TER Media Player v." & $cver & @CRLF & "Now Playing :", 8, 8, 200, 34)
	GUICtrlSetColor(-1, 0x9A3416)
	If $theme = "Black" Then GUICtrlSetColor(-1, 0xf96134)
	$data1 = GUICtrlCreateLabel("", 8, 42, 200, 58)
	If $theme = "Black" Then GUICtrlSetColor(-1, 0xFFFFFF)
	GUICtrlSetData($data1, $artst & @CRLF & $sng)
	GUICtrlSetFont(-1, 8, 800, 0, "MS Sans Serif")
	$data2 = GUICtrlCreateLabel("", 8, 102, 260, 15)
	If $theme = "Black" Then GUICtrlSetColor(-1, 0xFFFFFF)
	GUICtrlSetData($data2, _Trim("Album : " & $albm))
	$data3 = GUICtrlCreateLabel("", 8, 118, 200, 17)
	If $theme = "Black" Then GUICtrlSetColor(-1, 0xFFFFFF)
	GUICtrlSetData($data3, "Duration : " & $durtion)
	WinSetTrans("LMP", "", 200)
	GUISetState(@SW_LOCK)
	_GuiRoundCorners($Wpop, 0, 0, 10, 10) ;<= Patent GUI Glass style
	$tmr = TimerInit()
	
	Sleep(2500)
	DllCall("user32.dll", "int", "AnimateWindow", "hwnd", $Wpop, "int", 300, "long", 0x00050004)
	GUIDelete($Wpop)
EndFunc   ;==>pop

Func _GuiRoundCorners($h_win, $i_x1, $i_y1, $i_x3, $i_y3);==>_GuiRoundCorners
	Dim $pos, $ret, $ret2
	$pos = WinGetPos($h_win)
	$ret = DllCall("gdi32.dll", "long", "CreateRoundRectRgn", "long", $i_x1, "long", $i_y1, "long", $pos[2], "long", $pos[3], "long", $i_x3, "long", $i_y3)
	If $ret[0] Then
		$ret2 = DllCall("user32.dll", "long", "SetWindowRgn", "hwnd", $h_win, "long", $ret[0], "int", 1)
		If $ret2[0] Then
			Return 1
		Else
			Return 0
		EndIf
	Else
		Return 0
	EndIf
EndFunc   ;==>_GuiRoundCorners

Func _ReduceMemory($i_PID = -1)
	If $i_PID <> -1 Then
		Local $ai_Handle = DllCall("kernel32.dll", 'int', 'OpenProcess', 'int', 0x1f0fff, 'int', False, 'int', $i_PID)
		Local $ai_Return = DllCall("psapi.dll", 'int', 'EmptyWorkingSet', 'long', $ai_Handle[0])
		DllCall('kernel32.dll', 'int', 'CloseHandle', 'int', $ai_Handle[0])
	Else
		Local $ai_Return = DllCall("psapi.dll", 'int', 'EmptyWorkingSet', 'long', -1)
	EndIf

	Return $ai_Return[0]
EndFunc   ;==>_ReduceMemory

Func Hover_Func($CtrlID)
	If $theme = "Black" Then
	Switch $CtrlID
		Case $play
			GUICtrlSetImage($CtrlID, $plimgov)
		Case $stop
			GUICtrlSetImage($CtrlID, $stimgov)
		Case $pause
			GUICtrlSetImage($CtrlID, $paimgov)
		Case $browse
			GUICtrlSetImage($CtrlID, $brimgov)
		Case $vplay
			GUICtrlSetImage($CtrlID, $plimgov)
		Case $vstop
			GUICtrlSetImage($CtrlID, $stimgov)
		Case $vpause
			GUICtrlSetImage($CtrlID, $paimgov)
		Case $browse
			GUICtrlSetImage($CtrlID, $brimgo)
		Case $link
			GUICtrlSetColor($CtrlID, 0xFF0000)
	EndSwitch
	Else
	Switch $CtrlID
		Case $play
			GUICtrlSetImage($CtrlID, $plimgo)
		Case $stop
			GUICtrlSetImage($CtrlID, $stimgo)
		Case $pause
			GUICtrlSetImage($CtrlID, $paimgo)
		Case $browse
			GUICtrlSetImage($CtrlID, $brimgo)
		Case $vplay
			GUICtrlSetImage($CtrlID, $plimgov)
		Case $vstop
			GUICtrlSetImage($CtrlID, $stimgov)
		Case $vpause
			GUICtrlSetImage($CtrlID, $paimgov)
		Case $browse
			GUICtrlSetImage($CtrlID, $brimgo)
		Case $link
			GUICtrlSetColor($CtrlID, 0xFF0000)
	EndSwitch
	EndIf
EndFunc   ;==>Hover_Func

Func Leave_Hover_Func($CtrlID)
	If $theme = "Black" Then
	Switch $CtrlID
		Case $play
			GUICtrlSetImage($CtrlID, $plimgv)
		Case $stop
			GUICtrlSetImage($CtrlID, $stimgv)
		Case $pause
			GUICtrlSetImage($CtrlID, $paimgv)
		Case $browse
			GUICtrlSetImage($CtrlID, $brimgv)
		Case $vplay
			GUICtrlSetImage($CtrlID, $plimgv)
		Case $vstop
			GUICtrlSetImage($CtrlID, $stimgv)
		Case $vpause
			GUICtrlSetImage($CtrlID, $paimgv)
		Case $link
			GUICtrlSetColor($CtrlID, 0x0000FF)
	EndSwitch
	Else
	Switch $CtrlID
		Case $play
			GUICtrlSetImage($CtrlID, $plimg)
		Case $stop
			GUICtrlSetImage($CtrlID, $stimg)
		Case $pause
			GUICtrlSetImage($CtrlID, $paimg)
		Case $browse
			GUICtrlSetImage($CtrlID, $brimg)
		Case $vplay
			GUICtrlSetImage($CtrlID, $plimgv)
		Case $vstop
			GUICtrlSetImage($CtrlID, $stimgv)
		Case $vpause
			GUICtrlSetImage($CtrlID, $paimgv)
		Case $link
			GUICtrlSetColor($CtrlID, 0x0000FF)
	EndSwitch
	EndIf
EndFunc   ;==>Leave_Hover_Func

Func Scrollgui()
	$scrltext = "                          L|M|TER Media Player v." & $cver & @CRLF & _
			"                               © Copyright 2007, 2008" & @CRLF & _
			"                                           L|M|TER" & @CRLF & _
			"" & @CRLF & _
			"This program is free software: you can redistribute it and/or modify" & @CRLF & _
			"it under the terms of the GNU General Public License as published by" & @CRLF & _
			"the Free Software Foundation, either version 3 of the License," & @CRLF & _
			"or (at your option) any later version." & @CRLF & _
			"" & @CRLF & _
			"This program is distributed in the hope that it will be useful," & @CRLF & _
			"but WITHOUT ANY WARRANTY; without even the implied warranty of" & @CRLF & _
			"MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the" & @CRLF & _
			"GNU General Public License for more details." & @CRLF & _
			"" & @CRLF & _
			"You should have received a copy of the GNU General Public License" & @CRLF & _
			"along with this program.  If not, see <http://www.gnu.org/licenses/>."

	$scrgui = GUICreate("L|M|TER Media Player - GPL", 303, 291)
	GUISetOnEvent($GUI_EVENT_CLOSE,"scrlgex")
	GUISetBkColor(0xD8E4F8)
	If $theme = "Black" Then GUISetBkColor(0x000000)
	$scrolltxt = GUICtrlCreateLabel($scrltext, 5, 300, 303, 285)
	If $theme = "Black" Then GUICtrlSetColor(-1, 0xFFFFFF)
	DllCall("user32.dll", "int", "AnimateWindow", "hwnd", $scrgui, "int", 400, "long", 0x00080000);fade-in
	GUISetState(@SW_SHOW)
	AdlibEnable('_MoveMarquee', 60)
EndFunc   ;==>Scrollgui

Func _MoveMarquee()
	$aCpos = ControlGetPos($scrgui, '', $scrolltxt)
	If IsArray($aCpos) Then
	If $aCpos[1] <= -300 Then $aCpos[1] = 300
	ControlMove($scrgui, '', $scrolltxt, 5, $aCpos[1] - 1)
	EndIf
EndFunc   ;==>_MoveMarquee

Func SetBitmap($hGUI, $hImage, $iOpacity)
	Local $hScrDC, $hMemDC, $hBitmap, $hOld, $pSize, $tSize, $pSource, $tSource, $pBlend, $tBlend
	$hScrDC = _WinAPI_GetDC(0)
	$hMemDC = _WinAPI_CreateCompatibleDC($hScrDC)
	$hBitmap = _GDIPlus_BitmapCreateHBITMAPFromBitmap($hImage)
	$hOld = _WinAPI_SelectObject($hMemDC, $hBitmap)
	$tSize = DllStructCreate($tagSIZE)
	$pSize = DllStructGetPtr($tSize)
	DllStructSetData($tSize, "X", _GDIPlus_ImageGetWidth($hImage))
	DllStructSetData($tSize, "Y", _GDIPlus_ImageGetHeight($hImage))
	$tSource = DllStructCreate($tagPOINT)
	$pSource = DllStructGetPtr($tSource)
	$tBlend = DllStructCreate($tagBLENDFUNCTION)
	$pBlend = DllStructGetPtr($tBlend)
	DllStructSetData($tBlend, "Alpha", $iOpacity)
	DllStructSetData($tBlend, "Format", $AC_SRC_ALPHA)
	_WinAPI_UpdateLayeredWindow($hGUI, $hScrDC, 0, $pSize, $hMemDC, $pSource, 0, $pBlend, $ULW_ALPHA)
	_WinAPI_ReleaseDC(0, $hScrDC)
	_WinAPI_SelectObject($hMemDC, $hOld)
	_WinAPI_DeleteObject($hBitmap)
	_WinAPI_DeleteDC($hMemDC)
EndFunc   ;==>SetBitmap

Func DelRes()
	FileDelete($rcmdelete)
	FileDelete($rcmstop)
	FileDelete($rcmpause)
	FileDelete($rcmplay)
	FileDelete($mvid)
	FileDelete($mabout)
	FileDelete($mupd)
	FileDelete($mhelp)
	FileDelete($mset)
	FileDelete($mexit)
	FileDelete($mfile)
	FileDelete($mdir)
	FileDelete($spimg)
	FileDelete($stimgv)
	FileDelete($plimgv)
	FileDelete($paimgv)
	FileDelete($stimgov)
	FileDelete($plimgov)
	FileDelete($paimgov)
	FileDelete($brimgo)
	FileDelete($stimgo)
	FileDelete($plimgo)
	FileDelete($paimgo)
	FileDelete($brimg)
	FileDelete($stimg)
	FileDelete($plimg)
	FileDelete($paimg)
	FileDelete($loimg)
	FileDelete(@TempDir & "\lmp.ver")
	FileDelete(@TempDir & "\lmp.bat")
	If FileExists(@ScriptDir & "\lmp.exe.log") = 1 Then FileDelete(@ScriptDir & "\lmp.exe.log")
EndFunc   ;==>DelRes

Func _Trim($string)
	$len = StringLen($string)
	$out = $string
	If $len > 49 Then $out = StringTrimRight($string,$len - 49) & "..."
	Return $out
EndFunc

Func pevent()
$bSet = 0
$nCurCol = $nCol
$SendMsg = GUICtrlSendMsg($playlist, $LVM_SETSELECTEDCOLUMN, GUICtrlGetState($playlist), 0)
DllCall("user32.dll", "int", "InvalidateRect", "hwnd", GUICtrlGetHandle($playlist), "int", 0, "int", 1)
EndFunc

Func _Exit()
AdlibDisable()
For $i = (100 - GUICtrlRead($volslider)) * 10 To 0 Step -5
_SoundVolume($playlistsong, $i)
Next
_SoundClose($playlistsong)
If FileReadLine($inipath, 10) = "Enabled=1" Then plssave()
If $noeffect = 0 Then DllCall("user32.dll", "int", "AnimateWindow", "hwnd", $gui, "int", 400, "long", 0x00090000);fade-out
DelRes()
If $debug = 1 Then
FileWrite($filed, "------------------------------------------------------------------" & @CRLF)
FileWrite($filed, "Log ended at : " & @HOUR & ":" & @MIN & ":" & @SEC & " - " & @MDAY & "/" & @MON & "/" & @YEAR & @CRLF)
FileClose($filed)
EndIf
Exit
EndFunc

Func _clear()
$playlisthandle = GUICtrlGetHandle($playlist)
_GUICtrlListView_DeleteAllItems($playlisthandle)
GUICtrlSetState($search, $GUI_DISABLE)
GUICtrlSetState($nextbtn, $GUI_DISABLE)
TrayItemSetState($trayplay, $GUI_DISABLE)
TrayItemSetState($traystop, $GUI_DISABLE)
TrayItemSetState($traypause, $GUI_DISABLE)
TrayItemSetState($traysonginfo, $GUI_DISABLE)
TrayItemSetState($traynext, $GUI_DISABLE)
TrayItemSetState($traysrch, $GUI_DISABLE)
EndFunc

Func aboutex()
If $noeffect = 0 Then DllCall("user32.dll", "int", "AnimateWindow", "hwnd", $Form1, "int", 500, "long", 0x00090000)
GUIDelete($Form1)
EndFunc

Func alink()
_IECreate("                        ")
EndFunc

Func helpex()
If $noeffect = 0 Then DllCall("user32.dll", "int", "AnimateWindow", "hwnd", $Form2, "int", 500, "long", 0x00090000)
GUIDelete($Form2)
EndFunc

Func updex()
If $noeffect = 0 Then DllCall("user32.dll", "int", "AnimateWindow", "hwnd", $lmpupdate, "int", 1000, "long", 0x00090000)
GUIDelete($lmpupdate)
EndFunc

Func dldf()
				If $debug = 1 Then FileClose($filed)
				$newlmp = @ScriptDir & "\lmp.new.exe"
				GUIDelete($lmpupdate)
				InetGet("                                         ", $newlmp, 1, 1)
				If @error Then
					MsgBox(32, "LMP Update", $lang[50] & @LF & $lang[51])
					GUIDelete($lmpupdate)
				EndIf
				While @InetGetActive
					$i_BytesRead = @InetGetBytesRead
					$i_DownSize = InetGetSize("                                         ")
					$percent = Round($i_BytesRead / $i_DownSize * 100)
					$Time = @SEC
					$Bytes = Round(@InetGetBytesRead)
					While @SEC = $Time
					WEnd
					$NewBytes = Round(@InetGetBytesRead)
					$speed = ($NewBytes - $Bytes) / 1024 & " KB/s"

					TrayTip("L|M|TER Media Player", $lang[52] & @LF & $lang[53] & @LF & $percent & "% ... done  -  " & $speed, 1, 1)
				WEnd
				TrayTip("L|M|TER Media Player", $lang[54], 1)
				;exit old v ... starting new v
				$sFilePath = @TempDir & "\lmp.bat"
				_FileCreate($sFilePath)
				$file = FileOpen($sFilePath, 1)
				FileWrite($file, "taskkill /im lmp.exe" & @CRLF)
				FileWrite($file, "@echo Starting the new version of LMP" & @CRLF)
				FileWrite($file, "cd " & @ScriptDir & "\" & @CRLF)
				FileWrite($file, "del lmp.exe" & @CRLF)
				FileWrite($file, "rename lmp.new.exe lmp.exe" & @CRLF)
				FileWrite($file, "lmp.exe" & @CRLF)
				FileWrite($file, "exit" & @CRLF)
				FileClose($file)
				Run($sFilePath, "", @SW_HIDE)
				Exit
EndFunc

Func sguiex()
If $noeffect = 0 Then DllCall("user32.dll", "int", "AnimateWindow", "hwnd", $songgui, "int", 500, "long", 0x00090000)
_ReduceMemory(@AutoItPID)
GUIDelete($songgui)
EndFunc

Func setex()
If $noeffect = 0 Then DllCall("user32.dll", "int", "AnimateWindow", "hwnd", $settingsgui, "int", 500, "long", 0x00090000);fade-out
_ReduceMemory(@AutoItPID)
GUIDelete($settingsgui)
EndFunc

Func setapply()
				If GUICtrlRead($enable) = 1 Then IniWriteSection($inipath, "Auto-Update", "Enabled=1")
				If GUICtrlRead($disable) = 1 Then IniWriteSection($inipath, "Auto-Update", "Enabled=0")
				If GUICtrlRead($minenabled) = 1 Then IniWriteSection($inipath, "Minimize To Tray", "Enabled=1")
				If GUICtrlRead($mindisabled) = 1 Then IniWriteSection($inipath, "Minimize To Tray", "Enabled=0")
				If GUICtrlRead($showen) = 1 Then IniWriteSection($inipath, "Playlist-Hide", "Enabled=1")
				If GUICtrlRead($showdis) = 1 Then IniWriteSection($inipath, "Playlist-Hide", "Enabled=0")
				If GUICtrlRead($randen) = 1 Then IniWriteSection($inipath, "Random", "Enabled=1")
				If GUICtrlRead($disen) = 1 Then IniWriteSection($inipath, "Random", "Enabled=0")
				If GUICtrlRead($saveen) = 1 Then IniWriteSection($inipath, "Playlist-Save", "Enabled=1")
				If GUICtrlRead($savedis) = 1 Then IniWriteSection($inipath, "Playlist-Save", "Enabled=0")
				If GUICtrlRead($openen) = 1 Then IniWriteSection($inipath, "Playlist-Open", "Enabled=1")
				If GUICtrlRead($opendis) = 1 Then IniWriteSection($inipath, "Playlist-Open", "Enabled=0")
				If GUICtrlRead($classic) = 1 Then IniWriteSection($inipath, "Theme", "Blue")
				If GUICtrlRead($blackrd) = 1 Then IniWriteSection($inipath, "Theme", "Black")
				IniWriteSection($inipath, "Language", "Lang=" & GUICtrlRead($lang_set))
				If $noeffect = 0 Then DllCall("user32.dll", "int", "AnimateWindow", "hwnd", $settingsgui, "int", 500, "long", 0x00090000);fade-out
				_ReduceMemory(@AutoItPID)
				GUIDelete($settingsgui)
EndFunc

Func rcsguiex()
				If $noeffect = 0 Then DllCall("user32.dll", "int", "AnimateWindow", "hwnd", $songgui, "int", 500, "long", 0x00090000)
				_ReduceMemory(@AutoItPID)
				GUIDelete($songgui)
EndFunc

Func popex()
DllCall("user32.dll", "int", "AnimateWindow", "hwnd", $Wpop, "int", 300, "long", 0x00050004)
GUIDelete($Wpop)
EndFunc

Func scrlgex()
AdlibDisable()
DllCall("user32.dll", "int", "AnimateWindow", "hwnd", $scrgui, "int", 400, "long", 0x00090000)
_ReduceMemory(@AutoItPID)
GUIDelete($scrgui)
EndFunc

Func updatedata()
	$1a1 = _SoundPos($playlistsong, 2)
	$1b1 = _SoundLength($playlistsong, 2)
	$gstate1 = WinGetState("L|M|TER Media Player")
	If $1a1 = $1b1 And _SoundStatus($playlistsong) = "playing" And BitAND($gstate1, 8) Then
		_SoundStop($playlistsong)
		$1 = GUICtrlRead($remainingt)
		$2 = "00:00:00"
		If $2 <> $1 Then GUICtrlSetData($remainingt, $2)
		$3 = GUICtrlRead($elapsedt)
		$4 = "00:00:00"
		If $4 <> $3 Then GUICtrlSetData($elapsedt, $4)
		$5 = GUICtrlRead($PosSlider)
		$6 = "00:00:00"
		If $6 <> $5 Then GUICtrlSetData($PosSlider, $6)
		Sleep(5)
		_GUICtrlStatusBar_SetText($statusbar, "Status :", 0)
	EndIf
	
	If $1a1 = $1b1 And _SoundStatus($playlistsong) = "playing" And BitAND($gstate1, 8) Then
		_SoundStop($playlistsong)
		$1 = GUICtrlRead($remainingt)
		$2 = "00:00:00"
		If $2 <> $1 Then GUICtrlSetData($remainingt, $2)
		$3 = GUICtrlRead($elapsedt)
		$4 = "00:00:00"
		If $4 <> $3 Then GUICtrlSetData($elapsedt, $4)
		$5 = GUICtrlRead($PosSlider)
		$6 = "00:00:00"
		If $6 <> $5 Then GUICtrlSetData($PosSlider, $6)
		Sleep(5)
		_GUICtrlStatusBar_SetText($statusbar, "Status :", 0)
	EndIf
	
	If FileReadLine($inipath, 8) = "Enabled=1" Then
		If $1a1 = $1b1 And _SoundStatus($playlistsong) = "stopped" Then
			$pls = GUICtrlGetHandle($playlist)
			$max = _GUICtrlListView_GetItemCount($pls)
			$rand = Random(1, $max)
			$next = _GUICtrlListView_GetItemTextArray($pls, $rand)
			$iY2 = _GUICtrlListView_GetItemPositionY($pls, $rand - 2)
			_GUICtrlListView_Scroll($pls, 0, $iY2)
			_GUICtrlListView_SetItemFocused($pls, $rand)
			_GUICtrlListView_SetItemSelected($pls, $rand)
			$playlistsong1 = $next[4]
			start($playlistsong1)
		EndIf
	EndIf
	
	If BitAND($gstate1, 8) Then
		HotKeySet("^+z", "play")
		HotKeySet("^+x", "pause")
		HotKeySet("^+c", "stop")
		HotKeySet("^+v", "vplayer")
		HotKeySet("^+b", "nexts")
	Else
		HotKeySet("^+z")
		HotKeySet("^+x")
		HotKeySet("^+c")
		HotKeySet("^+v")
		HotKeySet("^+b")
	EndIf
EndFunc

Func demos()
	_FileWriteToLine($inipath,18,"Enabled=0",1)
	DllCall("user32.dll", "int", "AnimateWindow", "hwnd", $lmpds, "int", 300, "long", 0x00090000)
	GUIDelete($lmpds)
	InetGet("                                          ", @AppDataDir & "\LMP\demo.mp3",1,1)
	While @InetGetActive
	$i_BytesRead = @InetGetBytesRead
	$i_DownSize = InetGetSize("                                          ")
	$percent = Round($i_BytesRead / $i_DownSize * 100)
	TrayTip("L|M|TER Media Player","Downloading demo song ..." & @CRLF & $percent & "% done ...",10,1)
	WEnd
	$playlisthandle = GUICtrlGetHandle($playlist)
	_GUICtrlListView_DeleteAllItems($playlisthandle)
	GUICtrlCreateListViewItem("James Brooks|Loving The Life|Hits 2008|" & @AppDataDir & "\LMP\demo.mp3",$playlist)
	TrayTip("L|M|TER Media Player","Download finished !",1,1)
	$ds = @AppDataDir & "\LMP\demo.mp3"
	TrayTip("","",0)
EndFunc

Func dsexit()
_FileWriteToLine($inipath,18,"Enabled=0",1)
DllCall("user32.dll", "int", "AnimateWindow", "hwnd", $lmpds, "int", 300, "long", 0x00090000)
GUIDelete($lmpds)
EndFunc