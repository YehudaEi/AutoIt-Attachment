;---------------Libraries to include------------------
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
;-----------------------------------------------------
Opt("GUIOnEventMode", 1)
;~ Opt("TrayMenuMode", 1)
;~ Opt("TrayOnEventMode", 1)
;---------------Variable Declaration-------------------
Global $iniTRpathinfo, $s_inianime, $s_iniextra, $allfet, $y, $s_initv, $s_iniMov, $s_iniAni, $s_iniext, $TRH_opt_gui
;Search Variables-------------------------------------------------------------------------
$searchlog = "######################## END Session"
$historypath = "C:\Users\Administrator\Documents\theRenamer\History\"
Global $searchresult

; Movie Variables-------------------------------------------------------------------------
$movie_down = "I:\ServerFolders\Download_movies\"
$movies = "V:\Movies"
$movielog = "C:\Users\Administrator\Documents\logs\movielog.txt"

; TV Variables-------------------------------------------------------------------------
$tv_down = "I:\ServerFolders\Download\"
$tvshows = "V:\TV"
$tvlog = "C:\Users\Administrator\Documents\logs\tvlog.txt"

; Anime Variables-------------------------------------------------------------------------
$anime_down = "I:\ServerFolders\Download_anime\"
$animes = "V:\Anime"
$animelog = "C:\Users\Administrator\Documents\logs\animelog.txt"

; Extra Variables-------------------------------------------------------------------------
$extra_down = "I:\ServerFolders\Download_movies\"
$extras = "V:\Movies"
$extralog = "C:\Users\Administrator\Documents\logs\movielog.txt"

; TheRenamer-------------------------------------------------------------------------
$renamerpath = "C:\Program Files (x86)\theRenamer\theRenamer.exe"
$renamerlog = "C:\Users\Administrator\Documents\theRenamer\log.txt"
$historylog ="C:\Users\Administrator\Documents\theRenamer\History\" & _DateToMonth(@mon,1) & "." & @MDAY & ".log"
$fetchTV = $renamerpath & " -fetch"
$fetchmovie = $renamerpath & " -fetchmovie"
$fetchanime = $renamerpath & " -fetch -ff=" & '"' & $anime_down & '"' & " -af="& '"' & $animes & '"'
$fetchextra = $renamerpath & " -fetch -ff=" & '"' & $extra_down & '"' & " -af="& '"' & $extras & '"'

; GUI Flags----------------------------------------------------------------------
Global $pausef = False
Global $Runf = True
$ptitle = "Monitoring Progression"
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
;~ $prefsitem = TrayCreateItem("Pause/Unpause")
;~ TrayItemSetOnEvent( -1, "_actions")
;~ TrayCreateItem("")
;~ $tvitem = TrayCreateItem("Tv Logs")
;~ TrayItemSetOnEvent( -1, "_about")
;~ TrayCreateItem("")
;~ $exititem = TrayCreateItem("Exit")
;~ TrayItemSetOnEvent( -1, "_exit")
;~ TraySetState()
;-----------End System Tray Icon--------------

;----------GUI Event buttons---------------------------

GUICtrlSetOnEvent($start, "_actions")
GUICtrlSetOnEvent($stop, "_actions")
GUICtrlSetOnEvent($pauseme, "_actions")
GUICtrlSetOnEvent($tvb, "_actions")
GUICtrlSetOnEvent($animeb, "_actions")
GUICtrlSetOnEvent($movieb, "_actions")
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
	Local $max[5][2] = [["$tvlog",FileGetSize($tvlog)],["$movlog",FileGetSize($movielog)],["$animelog",FileGetSize($animelog)],["$extralog",FileGetSize($extralog)] _
	,["",52428800]]
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
	$Hasfiles = DirGetSize($tv_down)
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
		FileWriteLine($file2, "############ " & @MDAY & "/" & @MON & "/" & @YEAR & "############ " & @CRLF)
		FileWriteLine($file2, "############ " & @HOUR & "h:" & @MIN & "############ " & @CRLF)
		FileWriteLine($file2,$file3)
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

;Movie Fetching
	$Hasfiles = DirGetSize($movie_down)
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
		FileWriteLine($file2, "############ " & @MDAY & "/" & @MON & "/" & @YEAR & "############ " & @CRLF)
		FileWriteLine($file2, "############ " & @HOUR & "h:" & @MIN & "############ " & @CRLF)
		FileWriteLine($file2,$file3)
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

;Anime Fetching
	$Hasfiles = DirGetSize($anime_down)
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
		FileWriteLine($file2, "############ " & @MDAY & "/" & @MON & "/" & @YEAR & "############ " & @CRLF)
		FileWriteLine($file2, "############ " & @HOUR & "h:" & @MIN & "############ " & @CRLF)
		FileWriteLine($file2,$file3)
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

;Extra Fetching
	$Hasfiles = DirGetSize($extra_down)
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
		FileWriteLine($file2, "############ " & @MDAY & "/" & @MON & "/" & @YEAR & "############ " & @CRLF)
		FileWriteLine($file2, "############ " & @HOUR & "h:" & @MIN & "############ " & @CRLF)
		FileWriteLine($file2,$file3)
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
;---End of Fetching-----------------------

; Kill Therenamer if its still running
	$PID = ProcessExists("theRenamer.exe")
	If $PID Then ProcessClose($PID)
Until $Runf = False
EndFunc	;===> Monitoring






; ---Pause Mode----------------------------------
Func _pause()
 Opt("GUIOnEventMode", 0)
    GUICtrlSetData($pauseme,"Resume")
    While 1
        $msg = GUIGetMsg()
        Select
         Case $msg = $GUI_EVENT_CLOSE
             Exit
         Case $msg = $exit
             Exit
         Case $msg = $pauseme
             ExitLoop
		Case $Msg = $tvb
			ShellExecute($tvlog)
		Case $Msg = $movieb
			ShellExecute($movielog)
		Case $Msg = $animeb
			ShellExecute($animelog)
         EndSelect
         Sleep(200)
     WEnd
    Opt("GUIOnEventMode", 1)
	Global $pausef = False
	GUICtrlSetData($pauseme,"Pause")
EndFunc
;-----------------------------------------

;~ ;---exit from program------------------------
Func _exit()
	Switch @GUI_WINHANDLE ; See which GUI sent the CLOSE message
        Case $TR_GUI
            Exit ; If it was this GUI - we exit <<<<<<<<<<<<<<<
        Case $TRH_opt_Gui
            GUIDelete($TRH_opt_Gui) ; If it was this GUI - we just delete the GUI <<<<<<<<<<<<<<<
            GUISetState(@SW_ENABLE)
    EndSwitch
EndFunc
Func _opt()
	
	GUISetState(@SW_DISABLE,$TR_GUI)
	;Global Options Menu ######################################
	$TRH_opt_Gui = GUICreate("TRHelper Options", 615, 438, 1044, 160)
	GUICtrlCreateTab(32, 8, 553, 385)
	GUISetOnEvent($GUI_EVENT_CLOSE, "_exit")
	$OK = GUICtrlCreateButton("OK", 104, 392, 81, 25)
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
	GUICtrlCreateLabel("Anime Archive Folder :", 36, 121, 110, 17)
	$Ani_arch = GUICtrlCreateInput("", 36, 145, 393, 21)
	GUICtrlSetState(-1, $Gui_disable)
	$Extra = GUICtrlCreateCheckbox("  Extra", 36, 177, 81, 17)
	GUICtrlCreateLabel("Extra Fetch Folder :", 36, 201, 96, 17)
	$ext_fetch = GUICtrlCreateInput("", 36, 225, 393, 21)
	GUICtrlSetState(-1, $Gui_disable)
	GUICtrlCreateLabel("Extra  Archive Folder :", 36, 249, 108, 17)
	$ext_arch = GUICtrlCreateInput("", 36, 273, 393, 21)
	GUICtrlSetState(-1, $Gui_disable)
	$TV_fet = GUICtrlCreateCheckbox("TV Fetcher", 36, 305, 81, 17)
	GUICtrlSetTip(-1, "If TV Settings are activated in TheRename, check this box")
	$Mov_fet = GUICtrlCreateCheckbox("Movie Fetcher", 36, 337, 89, 17)
	GUICtrlSetTip(-1, "If Movie Settings are activated in TheRename, check this box")
	GUICtrlCreateLabel("If you have TVshow or Movies configured in The Renamer , these boxes must be checked", 128, 320, 431, 17)
	GUICtrlSetFont(-1, 8, 400, 0, "Tahoma")
	GUICtrlSetColor(-1, 0xFF0000)
	
	;LOG TAB#########################################
	$Logtab = GUICtrlCreateTabItem("Log Settings")
	$TVlog_chk = GUICtrlCreateCheckbox("TV Log name", 36, 49, 79, 17)
	$TVlogname = GUICtrlCreateInput("", 36, 73, 113, 21)
	GUICtrlSetState(-1, $Gui_disable)
	GUICtrlSetLimit(-1, 12)
	GUICtrlSetTip(-1, 'Max 12 letters (no extension".log")')
	GUICtrlCreateLabel("TV Log Path :", 188, 49, 70, 17)
	$TVlogpath = GUICtrlCreateInput("", 188, 73, 393, 21)
	GUICtrlSetState(-1, $Gui_disable)
	$Movlog_chk = GUICtrlCreateCheckbox("Movie Log name", 36, 121, 95, 17)
	$Movlogname = GUICtrlCreateInput("", 36, 145, 113, 21)
	GUICtrlSetState(-1, $Gui_disable)
	GUICtrlSetLimit(-1, 12)
	GUICtrlSetTip(-1, 'Max 12 letters (no extension".log")')
	GUICtrlCreateLabel("Movie Log Path :", 188, 121, 85, 17)
	$Movlogpath = GUICtrlCreateInput("", 188, 145, 393, 21)
	GUICtrlSetState(-1, $Gui_disable)
	$Anilog_chk = GUICtrlCreateCheckbox("Anime Log name", 36, 193, 95, 17)
	$Anilogname = GUICtrlCreateInput("", 36, 217, 113, 21)
	GUICtrlSetState(-1, $Gui_disable)
	GUICtrlSetLimit(-1, 12)
	GUICtrlSetTip(-1, 'Max 12 letters (no extension".log")')
	GUICtrlCreateLabel("Anime Log Path :", 188, 193, 85, 17)
	$Anilogpath = GUICtrlCreateInput("", 188, 217, 393, 21)
	GUICtrlSetState(-1, $Gui_disable)
	$extlog_chk = GUICtrlCreateCheckbox("Extra Log name", 36, 265, 95, 17)
	$extlogname = GUICtrlCreateInput("", 36, 289, 113, 21)
	GUICtrlSetState(-1, $Gui_disable)
	GUICtrlSetLimit(-1, 12)
	GUICtrlSetTip(-1, 'Max 12 letters (no extension".log")')
	GUICtrlCreateLabel("Extra Log Path :", 188, 265, 80, 17)
	$extlogpath = GUICtrlCreateInput("", 188, 289, 393, 21)
	GUICtrlSetState(-1, $Gui_disable)
	GUICtrlCreateLabel("* If Log is enabled, Log name & Log path must be filled out. Lob path must have a trailing backslash (c:\myfolder\)" & _
	". Log name must not contain extension.", 40, 336, 550, 49)
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
	GUISetState(@SW_SHOW)
	While 1
			Sleep(10)
	WEnd
	
			
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
EndFunc ;====> _opt

Func _actions()
	Switch @GUI_CtrlId
		;Main GUI----------
		Case $start
			$Runf = True
		Case $stop
			$Runf = False
		Case $pauseme
			$pausef = True
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
			EndIf
		Case $x86
			If $win64cus = $GUI_CHECKED Then
				GUICtrlSetState($custom, $GUI_UNCHECKED + $gui_enable)
				GUICtrlSetState($x64, $GUI_UNCHECKED + $gui_enable)
				GUICtrlSetState($custompath, $Gui_disable)
				GUICtrlSetState($x86, $GUI_disable)
			EndIf
		Case $x64
			If $win86cus = $GUI_CHECKED Then
				GUICtrlSetState($custom, $GUI_UNCHECKED + $gui_enable)
				GUICtrlSetState($x86, $GUI_UNCHECKED + $gui_enable)
				GUICtrlSetState($custompath, $Gui_disable)
				GUICtrlSetState($x64, $GUI_disable)
			EndIf
		;End TheRenamer Tab options-------------------------------	
		
		;Fetchching Tab-------------------------------------
		Case $Anime
			If GUICtrlRead($anime) = $gui_checked Then
				GUICtrlSetState($ani_fetch, $Gui_enable)
				GUICtrlSetState($ani_Arch, $Gui_enable)
			ElseIf GUICtrlRead($anime) = $gui_unchecked Then
				GUICtrlSetState($ani_fetch, $Gui_disable)
				GUICtrlSetState($ani_Arch, $Gui_disable)
			endif
		Case $extra
			If GUICtrlRead($extra) = $gui_checked Then
				GUICtrlSetState($ext_fetch, $Gui_enable)
				GUICtrlSetState($ext_Arch, $Gui_enable)
			ElseIf GUICtrlRead($extra) = $gui_unchecked Then
				GUICtrlSetState($ext_fetch, $Gui_disable)
				GUICtrlSetState($ext_Arch, $Gui_disable)
			endif
		;End Fetchching Tab-------------------------------------

		;Log Tab----------------------------------------------
		Case $TVlog_chk
			If GUICtrlRead($TVlog_chk) = $gui_checked Then
				GUICtrlSetState($TVlogname, $Gui_enable)
				GUICtrlSetState($TVlogpath, $Gui_enable)
			ElseIf GUICtrlRead($TVlog_chk) = $gui_unchecked Then
				GUICtrlSetState($TVlogname, $Gui_disable)
				GUICtrlSetState($TVlogpath, $Gui_disable)
			endif
		Case $Movlog_chk
			If GUICtrlRead($Movlog_chk) = $gui_checked Then
				GUICtrlSetState($Movlogname, $Gui_enable)
				GUICtrlSetState($Movlogpath, $Gui_enable)
			ElseIf GUICtrlRead($Movlog_chk) = $gui_unchecked Then
				GUICtrlSetState($Movlogname, $Gui_disable)
				GUICtrlSetState($Movlogpath, $Gui_disable)
			endif
		Case $Anilog_chk
			If GUICtrlRead($Anilog_chk) = $gui_checked Then
				GUICtrlSetState($Anilogname, $Gui_enable)
				GUICtrlSetState($Anilogpath, $Gui_enable)
			ElseIf GUICtrlRead($Anilog_chk) = $gui_unchecked Then
				GUICtrlSetState($Anilogname, $Gui_disable)
				GUICtrlSetState($Anilogpath, $Gui_disable)
			endif
		Case $extlog_chk
			If GUICtrlRead($extlog_chk) = $gui_checked Then
				GUICtrlSetState($extlogname, $Gui_enable)
				GUICtrlSetState($extlogpath, $Gui_enable)
			ElseIf GUICtrlRead($extlog_chk) = $gui_unchecked Then
				GUICtrlSetState($extlogname, $Gui_disable)
				GUICtrlSetState($extlogpath, $Gui_disable)
			endif
		;End Log Tab----------------------------------------------	
		
		;Option Menu button actions--------------
		Case $ok
			_save()
			if $y > 0 then 
				$y = 0
			Else
				_inisave()
				_exit()
			EndIf
		Case $cancel
			_exit()
		Case $saveset
			_save()
			_inisave()
		;End Option Menu button actions--------------	
	EndSwitch
EndFunc ;===> _actions
		
Func _save()
	If GUICtrlRead($x86) = $GUI_CHECKED then
		ConsoleWrite(GUICtrlRead($x86) & @CRLF)
		$iniTRpathinfo = '"C:\Program Files\theRenamer\theRenamer.exe"'
	ElseIf GUICtrlRead($x64) = $GUI_CHECKED Then
		$iniTRpathinfo = '"C:\Program Files (x86)\theRenamer\theRenamer.exe"'
	Else
		$iniTRpathinfo = GUICtrlRead($custompath)
	EndIf
	If Guictrlread($anime) = $GUI_CHECKED then
		$inianime1 = GUICtrlRead($ani_fetch)
		$inianime2 = GUICtrlRead($ani_Arch)
		$s_inianime = "Fetch=" & '"' & $inianime1 & '"' & @LF & "Archive=" & '"' & $inianime2 & '"'
		if $inianime1 = "" or $inianime2 = "" then 
			MSGbox(64,"Error", "You forgot to enter the path of the Anime Fetch or Archive Folder.")
			$y = $y + 1
		EndIf
	Else 
		$s_inianime = 'Fetch=""' & @LF & 'Archive=""'
	endif
	If Guictrlread($extra) = $GUI_CHECKED then
		$iniextra1 = GUICtrlRead($ext_fetch)
		$iniextra2 = GUICtrlRead($ext_Arch)
		$s_iniextra = "Fetch=" & '"' & $iniextra1 & '"' & @LF & "Archive=" & '"' & $iniextra2 & '"'
		if $iniextra1 = "" or $iniextra2 = "" Then 
			MSGbox(64,"Error", "You forgot to enter the path of the Extra Fetch or Archive Folder.")
			$y = $y + 1
		EndIf
	Else 
		$s_iniextra = 'Fetch=""' & @LF & 'Archive=""'
	endif
	$tvfet = BitAND(GUICtrlread($tv_fet),$gui_checked) = $gui_checked
	$movfet = BitAND(GUICtrlread($mov_fet),$gui_checked) = $gui_checked
	$anifet = BitAND(GUICtrlread($anime),$gui_checked) = $gui_checked
	$extfet = BitAND(GUICtrlread($extra),$gui_checked) = $gui_checked
	$allfet = "TV=" & '"' & $tvfet & '"' & @LF & "Movies=" & '"' & $movfet & '"' & @LF  & "Anime=" & '"' & $anifet & '"' & @LF & "Extra=" & '"' & $extfet & '"'
	If Guictrlread($TVlog_chk) = $GUI_CHECKED then
		$initv1 = GUICtrlRead($TVlogname)
		$initv2 = GUICtrlRead($TVlogpath)
		$s_initv = "tvlog_path=" & '"' & $initv2 & $initv1 & '.log"'
		if $initv1 = "" or $initv2 = "" Then 
			MSGbox(64,"Error", "TV Log file information missing")
			$y = $y + 1
		EndIf
	Else 
		$s_initv = 'tvlog_path=""'
	endif
	If Guictrlread($Movlog_chk) = $GUI_CHECKED then
		$iniMov1 = GUICtrlRead($Movlogname)
		$iniMov2 = GUICtrlRead($Movlogpath)
		$s_iniMov = "Movlog_path=" & '"' & $iniMov2 & $iniMov1 & '.log"'
		if $iniMov1 = "" or $iniMov2 = "" Then 
			MSGbox(64,"Error", "Movie Log file information missing")
			$y = $y + 1
		EndIf	
	Else 
		$s_iniMov = 'Movlog_path=""'
	endif
	If Guictrlread($Anilog_chk) = $GUI_CHECKED then
		$iniAni1 = GUICtrlRead($Anilogname)
		$iniAni2 = GUICtrlRead($Anilogpath)
		$s_iniAni = "Anilog_path=" & '"' & $iniAni2 & $iniAni1 & '.log"'
		if $iniAni1 = "" or $iniAni2 = "" Then 
			MSGbox(64,"Error", "Anime Log file information missing")
			$y = $y + 1
		EndIf
	Else 
		$s_iniAni = 'Anilog_path=""'
	endif
	If Guictrlread($extlog_chk) = $GUI_CHECKED then
		$iniext1 = GUICtrlRead($extlogname)
		$iniext2 = GUICtrlRead($extlogpath)
		$s_iniext = "extlog_path=" & '"' & $iniext2 & $iniext1 & '.log"'
		if $iniext1 = "" or $iniext2 = "" Then 
			MSGbox(64,"Error", "Extra Log file information missing")
			$y = $y + 1
		EndIf
	Else 
		$s_iniext = 'extlog_path=""'
	endif
endfunc;===> save
			
func _inisave()
	IniWrite("msettings.ini", "therenamer", "Path", $iniTRpathinfo)
	IniWriteSection("msettings.ini", "Anime", $s_inianime)
	IniWriteSection("msettings.ini", "Extra", $s_iniextra)
	IniWriteSection("msettings.ini", "Active_Sections", $allfet)
	IniWriteSection("msettings.ini", "Logs", $s_initv & @LF & $s_iniMov & @LF & $s_iniani & @LF & $s_iniext)
EndFunc;===> _inisave