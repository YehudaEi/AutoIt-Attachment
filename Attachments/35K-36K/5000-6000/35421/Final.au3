;#################Libraries to include####################
#Include <Date.au3>
#include <ButtonConstants.au3>
#include <GUIConstantsEx.au3>
#include <GuiStatusBar.au3>
#include <ProgressConstants.au3>
#include <Progress.au3>
#include <WindowsConstants.au3>
#Include <StaticConstants.au3>
#include <Misc.au3>
#include <TabConstants.au3>
#include <EditConstants.au3>
#include <Array.au3>
;#####################Option Modes##################################
Opt("GUIOnEventMode", 1)
Opt("TrayMenuMode", 3)
Opt("TrayOnEventMode", 1)
;---------------Variable Declaration-------------------

Global  $TR_GUI, _
		$TRH_opt_GUI=9999, $Ok, $Cancel, $saveset, $y, _ ; <=== Option GUI
		$x86, $x64, $custom, $custompath, $win, $win64cus, $win86cus, $Brow_cus, _ ; <=== TheRenamer Tab
		$Anime, $ani_fetch, $Ani_arch, $extra, $ext_fetch, $ext_Arch, $TV_fet, $Mov_fet, _ 
		$changeMovpath, $changeTVpath,$extcontentname,$tv_fet_input,$mov_fet_input, _ 
		$Brow_ani_fet, $Brow_ani_arch, $Brow_ext_fet, $Brow_ext_arch, _ ; <=== Fetching Extra Tab
		$TVlog_chk, $TVlogname, $TVlogpath, $Movlog_chk, $Movlogname, $Movlogpath, _ 
		$Anilog_chk, $Anilogname, $Anilogpath, $extlog_chk, $extlogname, $extlogpath, _
		$Brow_Tvlog, $Brow_movlog, $Brow_anilog, $Brow_extlog, _  ; <=== Log Tab
		$iniTRpathinfo, $s_inianime, $s_iniextra, $allfet, $s_initv, $s_iniMov, $s_iniAni, $s_iniext ; <=== Save function
;#############Verify if ini file exist already#######################
If not FileExists("TRH_settings.ini") then 
	_save()
	_inisave()
	MSGbox(16,"First Step", "Please fill out the Options before pressing the Start button ")
Elseif FileExists("TRH_settings.ini") Then
	$_Down = IniReadSection("TRH_settings.ini","TV_Movie_Download")
	if $_Down[1][1] = "" and $_Down[2][1] = "" then 
	  MSGbox(48,"Warning", "mandatory options are missing. Please open options. ")
	EndIf
EndIf
;####################################################################	
Global $TRpath = IniRead("TRH_settings.ini", "therenamer", "Path", "none"), _ 
      $_anifet = IniReadSection("TRH_settings.ini","anime"), $_extfet = IniReadSection("TRH_settings.ini","extra"), _ 
	  $_active = IniReadSection("TRH_settings.ini","Active_Sections"), $_logs = IniReadSection("TRH_settings.ini","logs"), _ 
	  $_Down = IniReadSection("TRH_settings.ini","TV_Movie_Download")
	  
	  
;Search Variables-------------------------------------------------------------------------
$searchstring= "######################## END Session"
;~ $historypath = "C:\Users\Administrator\Documents\theRenamer\History\"
Global $searchresult

; Movie Variables-------------------------------------------------------------------------
$movie_down = $_Down[2][1]
ConsoleWrite($movie_down & @CRLF)
$movielog = $_Logs[2][1]

; TV Variables-------------------------------------------------------------------------
$tv_down = $_Down[1][1]
ConsoleWrite($tv_down & @CRLF)
$tvlog = $_Logs[1][1]

; Anime Variables-------------------------------------------------------------------------
$anime_down = $_anifet[1][1]
ConsoleWrite($anime_down & @CRLF)
$animes = $_anifet[2][1]
$animelog = $_Logs[3][1]

; Extra Variables-------------------------------------------------------------------------
$extra_down = $_extfet[1][1]
ConsoleWrite($extra_down & @CRLF)
$extras = $_extfet[2][1]
$extralog = $_Logs[4][1]

; TheRenamer-------------------------------------------------------------------------
$renamerpath = $TRpath
$renamerlog = @MyDocumentsDir & "\theRenamer\log.txt"
$historylog = @MyDocumentsDir & "\theRenamer\History\" & _DateToMonth(@mon,1) & "." & @MDAY & ".log"
$fetchTV = $renamerpath & " -fetch"
$fetchmovie = $renamerpath & " -fetchmovie"
$fetchanime = $renamerpath & " -fetch -ff=" & '"' & $anime_down & '"' & " -af="& '"' & $animes & '"'
$fetchextra = $renamerpath & " -fetch -ff=" & '"' & $extra_down & '"' & " -af="& '"' & $extras & '"'

; GUI Flags----------------------------------------------------------------------
Global $pausef = False
Global $Runf = False
;GUI interface---------------------------
$TR_GUI = GUICreate("TRHelper",413, 300, 192, 124)
GUISetOnEvent($GUI_EVENT_CLOSE, "_exit")
$Progress1 = GUICtrlCreateProgress(47, 64, 225, 25, $PBS_SMOOTH)
$start = GUICtrlCreateButton("Start", 120, 208, 49, 57)
$stop = GUICtrlCreateButton("Stop", 120, 128, 49, 57)
$extrab = GUICtrlCreateButton("Extra Log", 15, 120, 97, 25)
$tvb = GUICtrlCreateButton("Tv Log", 15, 152, 97, 25)
$animeb = GUICtrlCreateButton("Anime Log", 15, 184, 97, 25)
$movieb = GUICtrlCreateButton("Movie Log", 15, 217, 97, 25)
$exit = GUICtrlCreateButton("Exit", 15, 248, 97, 25)
$pauseme = GUICtrlCreateButton("Pause", 176, 128, 49, 57)
$options = GUICtrlCreateButton("Options", 176, 208, 49, 57)
$Label1 = GUICtrlCreateLabel("", 48, 24, 220, 25, BitOR($SS_CENTER,$SS_CENTERIMAGE))
$Label2 = GUICtrlCreateLabel("0%", 288, 64, 76, 25, BitOR($SS_CENTER,$SS_CENTERIMAGE))
GUISetState(@SW_SHOW)


;~ _Singleton("main")

;-----------End of GUI Creation----------------

;------System Tray Icon------------------------
$pauseitem = TrayCreateItem("Pause/Unpause")
TrayItemSetOnEvent(-1, "_Trayitems")
$startitem = TrayCreateItem("Start")
TrayItemSetOnEvent(-1, "_Trayitems")
$stopitem = TrayCreateItem("Stop")
TrayItemSetOnEvent(-1, "_Trayitems")
TrayCreateItem("")
$tvitem = TrayCreateItem("Tv Logs")
TrayItemSetOnEvent(-1, "_Trayitems")
$movitem = TrayCreateItem("Movie Logs")
TrayItemSetOnEvent(-1, "_Trayitems")
$aniitem = TrayCreateItem("Anime Logs")
TrayItemSetOnEvent(-1, "_Trayitems")
$extitem = TrayCreateItem("Extra Logs")
TrayItemSetOnEvent(-1, "_Trayitems")
TrayCreateItem("")
$exititem = TrayCreateItem("Exit")
TrayItemSetOnEvent($exit, "_exit")
TrayCreateItem("")
$opt_item = TrayCreateItem("Options")
TrayItemSetOnEvent(-1, "_opt")
TraySetState()
;-----------End System Tray Icon--------------

;----------GUI Event buttons---------------------------

GUICtrlSetOnEvent($start, "_actions")
GUICtrlSetOnEvent($stop, "_actions")
GUICtrlSetOnEvent($pauseme, "_actions")
GUICtrlSetOnEvent($tvb, "_actions")
GUICtrlSetOnEvent($animeb, "_actions")
GUICtrlSetOnEvent($movieb, "_actions")
GUICtrlSetOnEvent($extrab, "_actions")
GUICtrlSetOnEvent($exit, "_exit")
GUICtrlSetOnEvent($options, "_opt")
;------------------------------------------------------
While 1
    Sleep(10)
    ; Check if the flag has been set by the OnEvent function
    If $Runf Then
        ; Now start the "real" function from within the main code
        _Monitor()
    EndIf
WEnd

;##################Functions#####################################
Func _Monitor()
Do
	GuiCtrlSetData($progress1, 0)
	GUICtrlSetData($Label1, "")
	GUICtrlSetData($Label2, 0 & '%')
	sleep(1000)
;Delete History log if it Exsist
	if FileExists($historylog) then Filedelete($historylog)
;-----------------------------------------------------------------

;Check log sizes and delete if logs is 50MB or more
	Local $max[5][2] = [["$tvlog",FileGetSize($tvlog)],["$movlog",FileGetSize($movielog)],["$animelog",FileGetSize($animelog)], _ 
	["$extralog",FileGetSize($extralog)], ["",52428800]]
	Local $s

For $s = 0 to 4 - 1
	If $max[$s][1] >= $max[4][1] then
		FileDelete($max[$s][0])
	Endif
Next
	GuiCtrlSetData($progress1, Round (1/9*100,0))
	GUICtrlSetData($Label1, "Checking log size done")
	GUICtrlSetData($Label2, Round (1/9*100,0) & '%')
	sleep(1000)
	if $Runf = False Then ExitLoop
	If $pausef = True Then _pause ()
;--------------------------------------

;--Fetching----------------------------

;TVshow Fetching
if $_active[1][1] = "True" Then
	$Hasfiles = DirGetSize($tv_down)
	ConsoleWrite($hasfiles & " TV" & @CRLF)
	if $hasfiles > 0 then
		GuiCtrlSetData($progress1, Round (1/9*100,0))
		GUICtrlSetData($Label1, "Running TheRenamer TV")
		GUICtrlSetData($Label2, Round (1/9*100,0) & '%')
		RunWait($fetchTV)
		GuiCtrlSetData($progress1, Round (2/9*100,0))
		GUICtrlSetData($Label1, "Finish TheRenamer TV")
		GUICtrlSetData($Label2, Round (2/9*100,0) & '%')
		sleep(1000)
		if $Runf = False Then ExitLoop
		If $pausef = True Then _pause ()
		GuiCtrlSetData($progress1, Round (2/9*100,0))
		GUICtrlSetData($Label1, "Updating TV Logs")
		GUICtrlSetData($Label2, Round (2/9*100,0) & '%')
		Sleep(300)
		$file1 = FileRead($renamerlog)
		$file2 = FileOpen($tvlog,1)
		$file3 = FileRead($historylog)
		;URL for following expression: http://www.autoitscript.com/forum/topic/133363-remove-blank-lines-in-a-file/
		$sRtn = stringreplace(StringRegExpReplace(StringRegExpReplace($file3, "(\v)+", @CRLF), "(^\v*)|(\v*\Z)", ""), "######################## END Session", "")
		FileWriteLine($file2, "############ " & @MDAY & "/" & @MON & "/" & @YEAR & "############ " & @CRLF)
		FileWriteLine($file2, "############ " & @HOUR & "h:" & @MIN & "############ " & @CRLF)
		FileWriteLine($file2,$sRtn)
		FileWriteLine($file2,$file1)
		FileClose($file2)
		Filedelete($historylog)
		GuiCtrlSetData($progress1, Round (3/9*100,0))
		GUICtrlSetData($Label1, "Finish Updating TV Logs")
		GUICtrlSetData($Label2, Round (3/9*100,0) & '%')
		Sleep(1000)
		if $Runf = False Then ExitLoop
		If $pausef = True Then _pause ()
	Else
		GuiCtrlSetData($progress1, Round (3/9*100,0))
		GUICtrlSetData($Label1, "No TV Shows Added")
		GUICtrlSetData($Label2, Round (3/9*100,0) & '%')
		sleep(1000)
		if $Runf = False Then ExitLoop
		If $pausef = True Then _pause ()
	Endif
	ConsoleWrite($hasfiles & " TV2" & @CRLF)
Else 
	GuiCtrlSetData($progress1, Round (3/9*100,0))
	GUICtrlSetData($Label2, Round (3/9*100,0) & '%')
	sleep(1000)
Endif

;Movie Fetching
if $_active[2][1] = "True" Then
	$Hasfiles = DirGetSize($movie_down)
	ConsoleWrite($hasfiles & " Movies" & @CRLF)
	if $hasfiles > 0 then
		GuiCtrlSetData($progress1, Round (3/9*100,0))
		GUICtrlSetData($Label1, "Running TheRenamer Movie")
		GUICtrlSetData($Label2, Round (3/9*100,0) & '%')
		RunWait($fetchmovie)
		GuiCtrlSetData($progress1, Round (4/9*100,0))
		GUICtrlSetData($Label1, "Finish TheRenamer Movie")
		GUICtrlSetData($Label2, Round (4/9*100,0) & '%')
		sleep(1000)
		if $Runf = False Then ExitLoop
		If $pausef = True Then _pause ()
		GuiCtrlSetData($progress1, Round (4/9*100,0))
		GUICtrlSetData($Label1, "Updating Movie Logs")
		GUICtrlSetData($Label2, Round (4/9*100,0) & '%')
		Sleep(1000)
		$file1 = FileRead($renamerlog)
		$file2 = FileOpen($movielog,1)
		$file3 = FileRead($historylog)
		;URL for following expression: http://www.autoitscript.com/forum/topic/133363-remove-blank-lines-in-a-file/
		$sRtn = stringreplace(StringRegExpReplace(StringRegExpReplace($file3, "(\v)+", @CRLF), "(^\v*)|(\v*\Z)", ""), "######################## END Session", "")
		FileWriteLine($file2, "############ " & @MDAY & "/" & @MON & "/" & @YEAR & "############ " & @CRLF)
		FileWriteLine($file2, "############ " & @HOUR & "h:" & @MIN & "############ " & @CRLF)
		FileWriteLine($file2,$sRtn)
		FileWriteLine($file2,$file1)
		FileClose($file2)
		Filedelete($historylog)
		GuiCtrlSetData($progress1, Round (5/9*100,0))
		GUICtrlSetData($Label1, "Finish Updating Movie Logs")
		GUICtrlSetData($Label2, Round (5/9*100,0) & '%')
		Sleep(1000)
		if $Runf = False Then ExitLoop
		If $pausef = True Then _pause ()
	Else
		GuiCtrlSetData($progress1, Round (5/9*100,0))
		GUICtrlSetData($Label1, "No Movies Added")
		GUICtrlSetData($Label2, Round (5/9*100,0) & '%')
		sleep(1000)
		if $Runf = False Then ExitLoop
		If $pausef = True Then _pause ()
	Endif
Else 
	GuiCtrlSetData($progress1, Round (5/9*100,0))
	GUICtrlSetData($Label2, Round (5/9*100,0) & '%')
	sleep(1000)
Endif

;Anime Fetching
if $_active[3][1] = "True" Then
	Local $Hasfiles = DirGetSize($anime_down)
	ConsoleWrite($hasfiles & " Anime" & @CRLF)
	if $hasfiles > 0 then
		GuiCtrlSetData($progress1, Round (5/9*100,0))
		GUICtrlSetData($Label1, "Running TheRenamer Anime")
		GUICtrlSetData($Label2, Round (5/8*100,0) & '%')
		RunWait($fetchanime)
		GuiCtrlSetData($progress1, Round (6/9*100,0))
		GUICtrlSetData($Label1, "Finish TheRenamer Anime")
		GUICtrlSetData($Label2, Round (6/9*100,0) & '%')
		sleep(1000)
		if $Runf = False Then ExitLoop
		If $pausef = True Then _pause ()
		GuiCtrlSetData($progress1, Round (6/9*100,0))
		GUICtrlSetData($Label1, "Updating Anime Logs")
		GUICtrlSetData($Label2, Round (6/9*100,0) & '%')
		Sleep(1000)
		$file1 = FileRead($renamerlog)
		$file2 = FileOpen($Animelog,1)
		$file3 = FileRead($historylog)
		;URL for following expression: http://www.autoitscript.com/forum/topic/133363-remove-blank-lines-in-a-file/
		$sRtn = stringreplace(StringRegExpReplace(StringRegExpReplace($file3, "(\v)+", @CRLF), "(^\v*)|(\v*\Z)", ""), "######################## END Session", "")
		FileWriteLine($file2, "############ " & @MDAY & "/" & @MON & "/" & @YEAR & "############ " & @CRLF)
		FileWriteLine($file2, "############ " & @HOUR & "h:" & @MIN & "############ " & @CRLF)
		FileWriteLine($file2,$sRtn)
		FileWriteLine($file2,$file1)
		FileClose($file2)
		Filedelete($historylog)
		GuiCtrlSetData($progress1, Round (7/9*100,0))
		GUICtrlSetData($Label1, "Finish Updating Anime Logs")
		GUICtrlSetData($Label2, Round (7/9*100,0) & '%')
		Sleep(1000)
		if $Runf = False Then ExitLoop
		If $pausef = True Then _pause ()
	Else
		GuiCtrlSetData($progress1, Round (7/9*100,0))
		GUICtrlSetData($Label1, "No Anime Added")
		GUICtrlSetData($Label2, Round (7/9*100,0) & '%')
		sleep(1000)
		if $Runf = False Then ExitLoop
		If $pausef = True Then _pause ()
	Endif
ConsoleWrite($hasfiles & " Anime" & @CRLF)
Else 
	GuiCtrlSetData($progress1, Round (7/9*100,0))
	GUICtrlSetData($Label2, Round (7/9*100,0) & '%')
	sleep(1000)
Endif

;Extra Fetching
if $_active[4][1] = "True" Then
	$Hasfiles = DirGetSize($extra_down)
	ConsoleWrite($hasfiles & " extra" & @CRLF)
	if $hasfiles > 0 then
		GuiCtrlSetData($progress1, Round (7/9*100,0))
		GUICtrlSetData($Label1, "Running TheRenamer Extra")
		GUICtrlSetData($Label2, Round (7/8*100,0) & '%')
		RunWait($fetchextra)
		GuiCtrlSetData($progress1, Round (8/9*100,0))
		GUICtrlSetData($Label1, "Finish TheRenamer Extra")
		GUICtrlSetData($Label2, Round (8/8*100,0) & '%')
		sleep(1000)
		if $Runf = False Then ExitLoop
		If $pausef = True Then _pause ()
		GuiCtrlSetData($progress1, Round (8/9*100,0))
		GUICtrlSetData($Label1, "Updating Extra Logs")
		GUICtrlSetData($Label2, Round (4/7*100,0) & '%')
		Sleep(1000)
		$file1 = FileRead($renamerlog)
		$file2 = FileOpen($extralog,1)
		$file3 = FileRead($historylog)
		;URL for following expression: http://www.autoitscript.com/forum/topic/133363-remove-blank-lines-in-a-file/
		$sRtn = stringreplace(StringRegExpReplace(StringRegExpReplace($file3, "(\v)+", @CRLF), "(^\v*)|(\v*\Z)", ""), "######################## END Session", "")
		FileWriteLine($file2, "############ " & @MDAY & "/" & @MON & "/" & @YEAR & "############ " & @CRLF)
		FileWriteLine($file2, "############ " & @HOUR & "h:" & @MIN & "############ " & @CRLF)
		FileWriteLine($file2,$sRtn)
		FileWriteLine($file2,$file1)
		FileClose($file2)
		Filedelete($historylog)
		GuiCtrlSetData($progress1, Round (9/9*100,0))
		GUICtrlSetData($Label1, "Finish Updating Extra Logs")
		GUICtrlSetData($Label2, Round (9/9*100,0) & '%')
		Sleep(1000)
		if $Runf = False Then ExitLoop
		If $pausef = True Then _pause ()
	Else
		GuiCtrlSetData($progress1, Round (9/9*100,0))
		GUICtrlSetData($Label1, "No Files from Extra folder Added")
		GUICtrlSetData($Label2, Round (9/9*100,0) & '%')
		sleep(1000)
		if $Runf = False Then ExitLoop
		If $pausef = True Then _pause ()
	Endif
Else 
	GuiCtrlSetData($progress1, Round (9/9*100,0))
	GUICtrlSetData($Label2, Round (9/9*100,0) & '%')
	sleep(1000)
Endif
;---End of Fetching-----------------------

; Kill Therenamer if its still running
	$PID = ProcessExists("theRenamer.exe")
	If $PID Then ProcessClose($PID)
Until $Runf = False
EndFunc	;===> Monitoring






; ---Pause Mode----------------------------------
Func _pause()
 Opt("GUIOnEventMode", 0)
 Opt("TrayOnEventMode", 0)
    GUICtrlSetData($pauseme,"Resume")
    While 1
        $msg = GUIGetMsg() 
		$msg1 = TrayGetMsg ()
        Select
			Case $msg = $GUI_EVENT_CLOSE
				Exit
			Case $msg = $exit
				Exit
			Case $msg = $pauseme or $msg1 = $pauseitem
				ExitLoop
			Case $msg = $options
				_opt()
				ExitLoop
			Case $Msg = $tvb or $msg1 = $tvitem
				ShellExecute($tvlog)
			Case $Msg = $movieb or $msg1 = $movieitem
				ShellExecute($movielog)
			Case $Msg = $animeb or $msg1 = $aniitem
				ShellExecute($animelog)
			Case $Msg = $extrab or $msg1 = $extitem
				ShellExecute($extralog)
         EndSelect
         Sleep(200)
     WEnd
    Opt("GUIOnEventMode", 1)
	Opt("TrayOnEventMode", 1)
	Global $pausef = False
	GUICtrlSetData($pauseme,"Pause")
EndFunc
;-----------------------------------------

;~ ;---exit from program------------------------
Func _exit()
	Switch @GUI_WINHANDLE ; See which GUI sent the CLOSE message
        Case $TR_GUI
            Exit 
        Case $TRH_opt_Gui
			GUISetState(@SW_ENABLE, $TR_GUI)
            GUIDelete($TRH_opt_Gui)
			$Runf = True
			GUICtrlSetState($start, $Gui_disable)
		EndSwitch
EndFunc
Func _opt()
	$Runf = False
	GUISetState(@SW_DISABLE,$TR_GUI)
	;Global Options Menu ######################################
	$TRH_opt_Gui = GUICreate("TRHelper Options", 615, 438, 1044, 160)
	GUICtrlCreateTab(32, 8, 553, 385)
	GUISetOnEvent($GUI_EVENT_CLOSE, "_exit")
	ConsoleWrite("Ok function GUI 2 active" & @CRLF)
	$OK = GUICtrlCreateButton("OK", 104, 392, 81, 25)
	GUICtrlSetState(-1, $Gui_disable)
	$Cancel = GUICtrlCreateButton("Cancel", 408, 392, 81, 25)
	$Saveset = GUICtrlCreateButton("Save", 256, 392, 81, 25)

	;TheRenamer TAB ######################################
	GUICtrlCreateTabItem("TheRenamer")
	GUICtrlSetState(-1,$GUI_SHOW)
	GUICtrlSetTip(-1, "Set TheRenamer Path")
	$x86 = GUICtrlCreateCheckbox("Windows 32bit", 40, 64, 89, 17)
	$x64 = GUICtrlCreateCheckbox("Windows 64bit", 40, 96, 89, 17)
	$custom = GUICtrlCreateCheckbox("Custom path",  40, 168, 81, 17)
	$custompath = GUICtrlCreateInput("", 41, 192, 393, 21)
	GUICtrlSetState(-1, $Gui_disable)
	$brow_cus = GUICtrlCreateButton("Browse", 444, 193, 49, 25)
	GUICtrlSetState(-1, $Gui_disable)
	$win = GUICtrlRead($x86) or GUICtrlRead($x64)
	$win64cus = GUICtrlRead($custom)or GUICtrlRead($x64)
	$win86cus = GUICtrlRead($custom)or GUICtrlRead($x86)
	
	;Fetching Extra TAB#########################################	
	GUICtrlCreateTabItem("Fetching / Extras")
	GUICtrlSetTip(-1, "")
	$Anime = GUICtrlCreateCheckbox("  Anime", 36, 49, 81, 17)
	GUICtrlCreateLabel("Anime Fetch Folder :", 36, 73, 101, 17)
	$Ani_fetch = GUICtrlCreateInput("", 36, 91, 393, 21)
	GUICtrlSetState(-1, $Gui_disable)
	$Brow_ani_fet = GUICtrlCreateButton("...", 148, 73, 25, 17)
	GUICtrlSetState(-1, $Gui_disable)
	GUICtrlSetTip(-1, "Folder that will contain the non-process files")
	GUICtrlCreateLabel("Anime Archive Folder :", 36, 121, 110, 17)
	$Ani_arch = GUICtrlCreateInput("", 36, 145, 393, 21)
	GUICtrlSetState(-1, $Gui_disable)
	$Brow_ani_arch = GUICtrlCreateButton("...", 156, 121, 25, 17)
	GUICtrlSetState(-1, $Gui_disable)
	GUICtrlSetTip(-1, "Folder where you store your anime")
	$Extra = GUICtrlCreateCheckbox("  Extra", 36, 177, 81, 17)
	GUICtrlCreateLabel("Extra Fetch Folder :", 36, 201, 96, 17)
	$Brow_ext_fet = GUICtrlCreateButton("...", 140, 201, 25, 17)
	GUICtrlSetTip(-1, "Folder that will contain the non-process files")
	GUICtrlSetState(-1, $Gui_disable)
	$ext_fetch = GUICtrlCreateInput("", 36, 225, 393, 21)
	GUICtrlSetState(-1, $Gui_disable)
	GUICtrlCreateLabel("Extra  Archive Folder :", 36, 249, 108, 17)
	$Brow_ext_arch = GUICtrlCreateButton("...", 156, 249, 25, 17)
	GUICtrlSetState(-1, $Gui_disable)
	$ext_arch = GUICtrlCreateInput("", 36, 273, 393, 21)
	GUICtrlSetState(-1, $Gui_disable)
	$extcontentname = GUICtrlCreateInput("Name of your Extra folder", 192, 192, 129, 21)
	GUICtrlSetTip(-1, 'For example: "HDMovies"')
	GUICtrlSetState(-1, $Gui_disable)
	$TV_fet = GUICtrlCreateCheckbox("TV Fetcher", 36, 305, 81, 17)
	GUICtrlSetTip(-1, "If TV Settings are activated in TheRename, check this box")
	$changeTVpath = GUICtrlCreateButton("...", 132, 305, 25, 17)
	GUICtrlSetState(-1, $Gui_disable)
	$Tv_fet_input = GUICtrlCreateInput("", 180, 305, 241, 21, BitOR($GUI_SS_DEFAULT_INPUT,$ES_READONLY))
	$Mov_fet = GUICtrlCreateCheckbox("Movie Fetcher", 36, 337, 89, 17)
	$changeMovpath = GUICtrlCreateButton("...", 132, 337, 25, 17)
	GUICtrlSetState(-1, $Gui_disable)
	GUICtrlSetTip(-1, "If Movie Settings are activated in TheRename, check this box")
	$mov_fet_input = GUICtrlCreateInput("", 180, 337, 241, 21, BitOR($GUI_SS_DEFAULT_INPUT,$ES_READONLY))
	GUICtrlCreateLabel("If you have TVshow or Movies configured in The Renamer , these boxes must be checked", 128, 368, 431, 17)
	GUICtrlSetFont(-1, 8, 400, 0, "Tahoma")
	GUICtrlSetColor(-1, 0xFF0000)
	
	;LOG TAB#########################################
	GUICtrlCreateTabItem("Log Settings")
	$TVlog_chk = GUICtrlCreateCheckbox("TV Log Path :", 36, 49, 79, 17)
	$TVlogpath = GUICtrlCreateInput("", 36, 73, 393, 21)
	GUICtrlSetState(-1, $Gui_disable)
	$Brow_tvlog = GUICtrlCreateButton("...", 441, 81, 25, 17)
	GUICtrlSetState(-1, $Gui_disable)
	$Movlog_chk = GUICtrlCreateCheckbox("Movie Log Path :", 36, 121, 95, 17)
	$Movlogpath = GUICtrlCreateInput("", 36, 145, 393, 21)
	GUICtrlSetState(-1, $Gui_disable)
	$Brow_movlog = GUICtrlCreateButton("...", 441, 153, 25, 17)
	GUICtrlSetState(-1, $Gui_disable)
	$Anilog_chk = GUICtrlCreateCheckbox("Anime Log Path :", 36, 193, 95, 17)
	$Anilogpath = GUICtrlCreateInput("", 36, 217, 393, 21)
	GUICtrlSetState(-1, $Gui_disable)
	$Brow_anilog = GUICtrlCreateButton("...", 441, 225, 25, 17)
	GUICtrlSetState(-1, $Gui_disable)
	$extlog_chk = GUICtrlCreateCheckbox("Extra Log Path :", 36, 265, 95, 17)
	$extlogpath = GUICtrlCreateInput("", 36, 289, 393, 21)
	GUICtrlSetState(-1, $Gui_disable)
	$Brow_extlog = GUICtrlCreateButton("...", 441, 297, 25, 17)
	GUICtrlSetState(-1, $Gui_disable)
	GUICtrlCreateLabel("* If Log is enabled, Log path must be filled out." & _ 
	"Log path must have this form (c:\myfolder\mylog.(log or txt)", 40, 336, 550, 49)
	GUICtrlSetFont(-1, 8, 400, 0, "Tahoma")
	GUICtrlSetColor(-1, 0xFF0000)
	GUICtrlCreateLabel("*", 140, 265, 8, 17)
	GUICtrlSetFont(-1, 10, 400, 0, "Tahoma")
	GUICtrlSetColor(-1, 0xFF0000)
	GUICtrlCreateLabel("*", 140, 193, 8, 17)
	GUICtrlSetFont(-1, 10, 400, 0, "Tahoma")
	GUICtrlSetColor(-1, 0xFF0000)
	GUICtrlCreateLabel("*", 140, 121, 8, 17)
	GUICtrlSetFont(-1, 10, 400, 0, "Tahoma")
	GUICtrlSetColor(-1, 0xFF0000)
	GUICtrlCreateLabel("*", 140, 49, 8, 17)
	GUICtrlSetFont(-1, 10, 400, 0, "Tahoma")
	GUICtrlSetColor(-1, 0xFF0000)
	
	If FileExists("TRH_settings.ini") Then
		if $TRpath = 'C:\Program Files\theRenamer\theRenamer.exe' Then
			GUICtrlSetState($x86, $Gui_checked +  $gui_disable)
		ElseIf $TRpath = 'C:\Program Files (x86)\theRenamer\theRenamer.exe' Then
			GUICtrlSetState($x64, $Gui_checked +  $gui_disable)
		Elseif $TRpath <> "" then
			GUICtrlSetState($custom, $Gui_checked +  $gui_disable)
			GUICtrlSetState($custompath, $Gui_enable)
			GUICtrlSetData($custompath, IniRead("TRH_settings.ini", "therenamer", "Path",""))
		EndIf
		If $_active[3][1] = "True" Then
			GUICtrlSetState($anime, $Gui_checked)
			GUICtrlSetState($Ani_fetch, $Gui_enable)
			GUICtrlSetState($Ani_Arch, $Gui_enable)
			GUICtrlSetData($Ani_fetch, $_anifet[1][1])
			GUICtrlSetData($Ani_Arch, $_anifet[2][1])
			GUICtrlSetState($Brow_ani_arch, $Gui_enable)
			GUICtrlSetState($Brow_ani_fet, $Gui_enable)
		EndIf
		If $_active[4][1] = "True" Then
			GUICtrlSetState($extra, $Gui_checked)
			GUICtrlSetState($ext_fetch, $Gui_enable)
			GUICtrlSetState($ext_Arch, $Gui_enable)
			GUICtrlSetState($extcontentname, $Gui_enable)
			GUICtrlSetData($ext_fetch, $_extfet[1][1])
			GUICtrlSetData($ext_Arch, $_extfet[2][1])
			GUICtrlSetData($extcontentname, $_extfet[3][1])
			GUICtrlSetState($Brow_ext_arch, $Gui_enable)
			GUICtrlSetState($Brow_ext_fet, $Gui_enable)
		EndIf
		If $_active[1][1] = "True" then
			GUICtrlSetState($tv_fet, $Gui_checked)
			GUICtrlSetState($changetvpath, $Gui_enable)
			GUICtrlSetData($tv_fet_input, $_Down[1][1])
			ConsoleWrite("TV Feth" & @CRLF)
		Endif
		If $_active[2][1] = "True" then
			GUICtrlSetState($mov_fet, $Gui_checked)
			GUICtrlSetState($changemovpath, $Gui_enable)
			GUICtrlSetData($mov_fet_input, $_Down[2][1])
			ConsoleWrite("Movie Feth" & @CRLF)
		Endif
		if $_logs[1][1] <> "" Then
			GUICtrlSetState($TVlogpath, $Gui_enable)
			GUICtrlSetState($tvlog_chk, $Gui_checked)
			GUICtrlSetData($TVlogpath,$_logs[1][1])
			GUICtrlSetState($Brow_tvlog, $Gui_enable)
		EndIf
		if $_logs[2][1] <> "" Then
			GUICtrlSetState($Movlogpath, $Gui_enable)
			GUICtrlSetState($movlog_chk, $Gui_checked)
			GUICtrlSetData($movlogpath,$_logs[2][1])
			GUICtrlSetState($Brow_movlog, $Gui_enable)
		EndIf
		if $_logs[3][1] <> "" Then
			GUICtrlSetState($anilogpath, $Gui_enable)
			GUICtrlSetState($anilog_chk, $Gui_checked)
			GUICtrlSetData($anilogpath,$_logs[3][1])
			GUICtrlSetState($Brow_anilog, $Gui_enable)
		EndIf
		if $_logs[4][1] <> "" Then
			GUICtrlSetState($extlogpath, $Gui_enable)
			GUICtrlSetState($extlog_chk, $Gui_checked)
			GUICtrlSetData($extlogpath,$_logs[4][1])
			GUICtrlSetState($Brow_extlog, $Gui_enable)
		EndIf
	EndIf
	GUISetState(@SW_SHOW)		
	;----------GUI Event buttons---------------------------
	GUICtrlSetOnEvent($custom, "_actions")
	GUICtrlSetOnEvent($x86, "_actions")
	GUICtrlSetOnEvent($x64, "_actions")
	GUICtrlSetOnEvent($anime, "_actions")
	GUICtrlSetOnEvent($extra, "_actions")
	GUICtrlSetOnEvent($TVlog_chk, "_actions")
	GUICtrlSetOnEvent($Movlog_chk, "_actions")
	GUICtrlSetOnEvent($Anilog_chk, "_actions")
	GUICtrlSetOnEvent($extlog_chk, "_actions")
	GUICtrlSetOnEvent($ok, "_actions")
	GUICtrlSetOnEvent($cancel, "_actions")
	GUICtrlSetOnEvent($saveset, "_actions")
	GUICtrlSetOnEvent($TV_fet, "_actions")
	GUICtrlSetOnEvent($Mov_fet, "_actions")
	GUICtrlSetOnEvent($changeTVpath, "_actions")
	GUICtrlSetOnEvent($changeMovpath, "_actions")
	GUICtrlSetOnEvent($Brow_cus, "_actions")
	GUICtrlSetOnEvent($Brow_ani_arch, "_actions")
	GUICtrlSetOnEvent($Brow_ani_fet, "_actions")
	GUICtrlSetOnEvent($Brow_ext_arch, "_actions")
	GUICtrlSetOnEvent($Brow_ext_fet, "_actions")
	GUICtrlSetOnEvent($Brow_tvlog, "_actions")
	GUICtrlSetOnEvent($Brow_movlog, "_actions")
	GUICtrlSetOnEvent($Brow_anilog, "_actions")
	GUICtrlSetOnEvent($Brow_extlog, "_actions")
EndFunc ;====> _opt

Func _actions()
	Switch @GUI_CtrlId 
		;Main GUI----------
		Case $start
			if $_Down[1][1] = "" and $_Down[2][1] = "" then 
				$Runf = False
			Else
				$Runf = True
				GUICtrlSetState($start, $gui_disable)
			EndIf
		Case $stop
			$Runf = False
			GUICtrlSetState($start, $gui_enable)
		Case $pauseme
			If $Runf = True then
				$pausef = True
			Else
				$pausef = False
			EndIf
		Case $tvb
			ShellExecute($tvlog)
		Case $movieb
			ShellExecute($movielog)
		Case $animeb
			ShellExecute($animelog)
		Case $extrab
			ShellExecute($extralog)
		;End of Main GUI------------
		
		;TheRenamer Tab options-------------------------------
		Case $custom
			If $win = $GUI_CHECKED Then
				GUICtrlSetState($x86, $GUI_UNCHECKED + $gui_enable)
				GUICtrlSetState($x64, $GUI_UNCHECKED + $gui_enable)
				GUICtrlSetState($custom, $GUI_disable)
				GUICtrlSetState($custompath, $Gui_enable)
				GUICtrlSetState($Brow_cus, $Gui_enable)
			EndIf
		Case $Brow_cus
			$txt = FileOpenDialog("TheRenamer.exe Location",@HomeDrive,"Executable Files (TheRenamer.exe)")
			GUICtrlSetData($custompath, $txt)
		Case $x86
			If $win64cus = $GUI_CHECKED Then
				GUICtrlSetState($custom, $GUI_UNCHECKED + $gui_enable)
				GUICtrlSetState($x64, $GUI_UNCHECKED + $gui_enable)
				GUICtrlSetState($custompath, $Gui_disable)
				GUICtrlSetState($Brow_cus, $Gui_disable)
				GUICtrlSetState($x86, $GUI_disable)
			EndIf
		Case $x64
			If $win86cus = $GUI_CHECKED Then
				GUICtrlSetState($custom, $GUI_UNCHECKED + $gui_enable)
				GUICtrlSetState($x86, $GUI_UNCHECKED + $gui_enable)
				GUICtrlSetState($custompath, $Gui_disable)
				GUICtrlSetState($Brow_cus, $Gui_disable)
				GUICtrlSetState($x64, $GUI_disable)
			EndIf
		;End TheRenamer Tab options-------------------------------	
		
		;Fetchching Tab-------------------------------------
		Case $Anime
			If GUICtrlRead($anime) = $gui_checked Then
				GUICtrlSetState($ani_fetch, $Gui_enable)
				GUICtrlSetState($ani_Arch, $Gui_enable)
				GUICtrlSetState($Brow_ani_arch, $Gui_enable)
				GUICtrlSetState($Brow_ani_fet, $Gui_enable)
			Else
				GUICtrlSetState($ani_fetch, $Gui_disable)
				GUICtrlSetData($ani_fetch, "")
				GUICtrlSetState($ani_Arch, $Gui_disable)
				GUICtrlSetData($ani_Arch, "")
				GUICtrlSetState($Brow_ani_arch, $Gui_disable)
				GUICtrlSetState($Brow_ani_fet, $Gui_disable)
			endif
		Case $Brow_ani_arch
				$txt = FileSelectFolder("Select Anime Archive folder","",4)
				GUICtrlSetData($ani_Arch, $txt)
		Case $Brow_ani_fet
				$txt = FileSelectFolder("Select Anime Fetch folder","",4)
				GUICtrlSetData($ani_fetch, $txt)
		Case $extra
			If GUICtrlRead($extra) = $gui_checked Then
				GUICtrlSetState($ext_fetch, $Gui_enable)
				GUICtrlSetState($ext_Arch, $Gui_enable)
				GUICtrlSetState($extcontentname, $Gui_enable)
				GUICtrlSetState($Brow_ext_arch, $Gui_enable)
				GUICtrlSetState($Brow_ext_fet, $Gui_enable)
			Else
				GUICtrlSetState($ext_fetch, $Gui_disable)
				GUICtrlSetData($ext_fetch, "")
				GUICtrlSetState($ext_Arch, $Gui_disable)
				GUICtrlSetData($ext_Arch, "")
				GUICtrlSetState($extcontentname, $Gui_disable)
				GUICtrlSetData($extcontentname,"Name of your Extra folder")
				GUICtrlSetState($Brow_ext_arch, $Gui_disable)
				GUICtrlSetState($Brow_ext_fet, $Gui_disable)
			endif
		Case $Brow_ext_arch
				$txt = FileSelectFolder("Select Extra Archive folder","",4)
				GUICtrlSetData($ext_Arch, $txt)
		Case $Brow_ext_fet 
				$txt = FileSelectFolder("Select Extra Fetch folder","",4)
				GUICtrlSetData($ext_fetch, $txt)
		Case $tv_fet
			If GUICtrlRead($tv_fet) = $gui_checked Then
				GUICtrlSetState($changetvpath, $Gui_enable)
			Else
				GUICtrlSetState($changetvpath, $Gui_disable)
				$tv_fet_input=""
			endif
		Case $changetvpath
			$txt = FileSelectFolder("TV Fetch Folder","",4)
			GUICtrlSetData($tv_fet_input, $txt)
		Case $Mov_fet
			If GUICtrlRead($mov_fet) = $gui_checked Then
				GUICtrlSetState($changemovpath, $Gui_enable)
				ConsoleWrite("Mov_fet" & @CRLF)
			Else
				GUICtrlSetState($changemovpath, $Gui_disable)
				$mov_fet_input=""
			endif
		Case $changemovpath
			$txt = FileSelectFolder("Movie Fetch Folder","",4)
			GUICtrlSetData($mov_fet_input, $txt)
		;End Fetchching Tab-------------------------------------

		;Log Tab----------------------------------------------
		Case $TVlog_chk
			If GUICtrlRead($TVlog_chk) = $gui_checked Then
				GUICtrlSetState($TVlogpath, $Gui_enable)
				GUICtrlSetState($Brow_tvlog, $Gui_enable)
			Else
				GUICtrlSetState($TVlogpath, $Gui_disable)
				GUICtrlSetData($TVlogpath, "")
				GUICtrlSetState($Brow_tvlog, $Gui_disable)
			endif
		Case $Brow_tvlog
			$txt = FileOpenDialog("Log Location",@HomeDrive,"Text File (*.txt)|Log File (*.log)|Both types (*.txt;*.log)")
			GUICtrlSetData($TVlogpath, $txt)
		Case $Movlog_chk
			If GUICtrlRead($Movlog_chk) = $gui_checked Then
				GUICtrlSetState($Movlogpath, $Gui_enable)
				GUICtrlSetState($Brow_movlog, $Gui_enable)
			Else
				GUICtrlSetState($Movlogpath, $Gui_disable)
				GUICtrlSetData($Movlogpath, "")
				GUICtrlSetState($Brow_movlog, $Gui_disable)
			endif
		Case $Brow_movlog
			$txt = FileOpenDialog("Log Location",@HomeDrive,"Text File (*.txt)|Log File (*.log)|Both types (*.txt;*.log)")
			GUICtrlSetData($movlogpath, $txt)	
		Case $Anilog_chk
			If GUICtrlRead($Anilog_chk) = $gui_checked Then
				GUICtrlSetState($Anilogpath, $Gui_enable)
				GUICtrlSetState($Brow_anilog, $Gui_enable)
			Else
				GUICtrlSetState($Anilogpath, $Gui_disable)
				GUICtrlSetData($Anilogpath, "")
				GUICtrlSetState($Brow_anilog, $Gui_disable)
			endif
		Case $Brow_anilog
			$txt = FileOpenDialog("Log Location",@HomeDrive,"Text File (*.txt)|Log File (*.log)|Both types (*.txt;*.log)")
			GUICtrlSetData($anilogpath, $txt)
		Case $extlog_chk
			If GUICtrlRead($extlog_chk) = $gui_checked Then
				GUICtrlSetState($extlogpath, $Gui_enable)
				GUICtrlSetState($Brow_extlog, $Gui_enable)
			Else
				GUICtrlSetState($extlogpath, $Gui_disable)
				GUICtrlSetData($extlogpath, "")
				GUICtrlSetState($Brow_extlog, $Gui_disable)
			endif
		Case $Brow_extlog
			$txt = FileOpenDialog("Log Location",@HomeDrive,"Text File (*.txt)|Log File (*.log)|Both types (*.txt;*.log)")
			GUICtrlSetData($extlogpath, $txt)
		;End Log Tab----------------------------------------------	
		
		;Option Menu button actions--------------
		Case $ok
			_save()
			ConsoleWrite("Ok function GUI 2" & @CRLF)
			if $y > 0 then 
				$y = 0
				ConsoleWrite("Ok function GUI 2 if" & @CRLF)
			Else
				ConsoleWrite("Ok function GUI 2 Else" & @CRLF)
				_inisave()
				_exit()
			EndIf
		Case $cancel
			ConsoleWrite(" function GUI 2 Cancel" & @CRLF)
			_exit()
		Case $saveset
			ConsoleWrite(" function GUI 2 Save" & @CRLF)
			_save()
			_inisave()
		;End Option Menu button actions--------------	
	EndSwitch
EndFunc ;===> _actions

Func _Trayitems()
	Switch @TRAY_ID
		Case $startitem
			if $_Down[1][1] = "" and $_Down[2][1] = "" then 
				$Runf = False
			Else
				$Runf = True
				GUICtrlSetState($start, $gui_disable)
			EndIf
		Case $stopitem
			$Runf = False
			GUICtrlSetState($start, $gui_enable)
		Case $pauseitem
			If $Runf = True then
				$pausef = True
			Else
				$pausef = False
			EndIf
		Case $tvitem
			ShellExecute($tvlog)
		Case $movieitem
			ShellExecute($movielog)
		Case $aniitem
			ShellExecute($animelog)
		Case $extitem
			ShellExecute($extralog)
	EndSwitch
EndFunc ; ===> _Trayitems		
Func _save()
	GUICtrlSetState($ok, $Gui_enable)
	;TheRenamer Tab Options=============================
	If GUICtrlRead($x86) = $GUI_CHECKED then
		ConsoleWrite(GUICtrlRead($x86) & @CRLF)
		$iniTRpathinfo = 'C:\Program Files\theRenamer\theRenamer.exe'
	ElseIf GUICtrlRead($x64) = $GUI_CHECKED Then
		$iniTRpathinfo = 'C:\Program Files (x86)\theRenamer\theRenamer.exe'
	Elseif GUICtrlRead($custom) = $GUI_CHECKED Then
		$iniTRpathinfo = GUICtrlRead($custompath)
	EndIf
	
	;Fetching Tab Options===============================
	If Guictrlread($anime) = $GUI_CHECKED then
		$inianime1 = GUICtrlRead($ani_fetch)
		$inianime2 = GUICtrlRead($ani_Arch)
		$s_inianime = "Fetch=" & $inianime1 & @LF & "Archive=" & $inianime2
		$y = 0
		if $inianime1 = "" or $inianime2 = "" then 
			MSGbox(64,"Error", "You forgot to enter the path of the Anime Fetch or Archive Folder.")
			$y = $y + 1
		EndIf
	Else 
		$s_inianime = 'Fetch=' & @LF & 'Archive='
	endif
	If Guictrlread($extra) = $GUI_CHECKED then
		$iniextra1 = GUICtrlRead($ext_fetch)
		$iniextra2 = GUICtrlRead($ext_Arch)
		$iniextra3 = GUICtrlRead($extcontentname)
		$s_iniextra = "Fetch=" & $iniextra1 & @LF & "Archive=" & $iniextra2 & @LF & "Folder_Name=" & $iniextra3
		$y = 0
		if $iniextra1 = "" or $iniextra2 = "" or $iniextra3 = "Name of your Extra folder" Then 
			MSGbox(64,"Error", "You forgot to enter the path of the Extra Fetch or Archive Folder or the Extra folder name.")
			$y = $y + 1
		EndIf
	Else 
		$s_iniextra = 'Fetch=' & @LF & 'Archive='
	endif
	$tvfet = BitAND(GUICtrlread($tv_fet),$gui_checked) = $gui_checked
	$movfet = BitAND(GUICtrlread($mov_fet),$gui_checked) = $gui_checked
	$anifet = BitAND(GUICtrlread($anime),$gui_checked) = $gui_checked
	$extfet = BitAND(GUICtrlread($extra),$gui_checked) = $gui_checked
	If $tvfet = False and $movfet = False Then
		$y = $y + 1
		MSGbox(64,"Error", "Either TV or Movie Fetcher must be configured")
	EndIf
	$allfet = "TV=" & $tvfet & @LF & "Movies=" & $movfet & @LF  & "Anime=" & $anifet & @LF & "Extra=" & $extfet
	
	;Log Tab Options==============================================
	If Guictrlread($TVlog_chk) = $GUI_CHECKED then
		$initv2 = GUICtrlRead($TVlogpath)
		$s_initv = "tvlog_path=" & $initv2
		$y = 0
		if $initv2 = "" Then 
			MSGbox(64,"Error", "TV Log file information missing")
			$y = $y + 1
		EndIf
	Else 
		$s_initv = 'tvlog_path='
	endif
	If Guictrlread($Movlog_chk) = $GUI_CHECKED then
		$iniMov2 = GUICtrlRead($Movlogpath)
		$s_iniMov = "Movlog_path=" & $iniMov2 
		$y = 0
		if $iniMov2 = "" Then
			MSGbox(64,"Error", "Movie Log file information missing")
			$y = $y + 1
		EndIf	
	Else 
		$s_iniMov = 'Movlog_path='
	endif
	If Guictrlread($Anilog_chk) = $GUI_CHECKED then
		$iniAni2 = GUICtrlRead($Anilogpath)
		$s_iniAni = "Anilog_path=" & $iniAni2
		$y = 0
		if $iniAni2 = "" Then 
			MSGbox(64,"Error", "Anime Log file information missing")
			$y = $y + 1
		EndIf
	Else 
		$s_iniAni = 'Anilog_path='
	endif
	If Guictrlread($extlog_chk) = $GUI_CHECKED then
		$iniext2 = GUICtrlRead($extlogpath)
		$s_iniext = "extlog_path=" & $iniext2
		$y = 0
		if $iniext2 = "" Then 
			MSGbox(64,"Error", "Extra Log file information missing")
			$y = $y + 1
		EndIf
	Else 
		$s_iniext = 'extlog_path='
	endif
endfunc;===> save
			
func _inisave()
	IniWrite("TRH_settings.ini", "therenamer", "Path", $iniTRpathinfo)
	IniWriteSection("TRH_settings.ini", "Anime", $s_inianime)
	IniWriteSection("TRH_settings.ini", "Extra", $s_iniextra)
	IniWriteSection("TRH_settings.ini", "Active_Sections", $allfet)
	IniWriteSection("TRH_settings.ini", "Logs", $s_initv & @LF & $s_iniMov & @LF & $s_iniani & @LF & $s_iniext)
	IniWrite("TRH_settings.ini", "TV_Movie_Download", "TVPath", $tv_fet_input)
	IniWrite("TRH_settings.ini", "TV_Movie_Download", "MoviePath", $mov_fet_input)
	$TRpath = IniRead("TRH_settings.ini", "therenamer", "Path", "none")
	$_anifet = IniReadSection("TRH_settings.ini","anime") 
	$_extfet = IniReadSection("TRH_settings.ini","extra")
	$_active = IniReadSection("TRH_settings.ini","Active_Sections")
	$_logs = IniReadSection("TRH_settings.ini","logs")
	$_Down = IniReadSection("TRH_settings.ini","TV_Movie_Download")
EndFunc;===> _inisave