; =========================================================================================================
; To Do:
;  - remaining timers
;  - TreeList still not resizing correctly
;  - network drive support
; How?
;  - return multiple TreeViewItem selections
; =========================================================================================================

; ======================
; VARIABLES
; ======================
#include <Array.au3>
#include <GUIConstants.au3>
#include <math.au3>
Opt("GUICloseOnESC", 0)
Opt("TrayIconHide", 1)
Opt("WinTitleMatchMode", 4)
If WinExists("%_DELETE_GUI") Then Exit
AutoItWinSetTitle("%_DELETE_GUI_%")
GLOBAL $a, $b, $c, $d, $DriveListing, $fixed_ary, $fixed_name, $fixed_list, $fixed_labels, $fixed_lblsto, $ViewItem, $msg
GLOBAL $fixed_ary = DriveGetDrive("FIXED")
GLOBAL $fixed_ary_upper[1], $fixed_labels[1], $fixed_status[1], $fixed_filesystem[1], $fixed_capacity[1], $fixed_free[1], $time_start[3]
DIM Const $v_title = "DELETE GUI v0.1"
DIM Const $helpfile = "                                               "

FileInstall( "img_about.jpg", @scriptdir & "\")

; ======================
; GUI - Formatting
; ======================
$gui_main = GuiCreate($v_title, 500, 194,(@DesktopWidth-500)/2, (@DesktopHeight-194)/2 , $WS_CLIPSIBLINGS + $WS_OVERLAPPEDWINDOW)
WinSetOnTop($v_title, "", 0)

	GUICtrlDelete($DriveListing)
	$DriveListing = GUICtrlCreateListView("Volume    | Status|File System|Capacity|Free Space|% Free Space", 0, 0, 500, 97, $LVS_NOSORTHEADER + $LVS_SHOWSELALWAYS)
	
	;//adds drive information to arrays
	For $a = 1 to $fixed_ary[0]
	   _ArrayInsert($fixed_ary_upper, $a, StringUpper($fixed_ary[$a]))
	   _ArrayInsert($fixed_labels, $a, DriveGetlabel($fixed_ary[$a]))
	   _ArrayInsert($fixed_status, $a, DriveStatus($fixed_ary[$a]))
	   _ArrayInsert($fixed_filesystem, $a, DriveGetFileSystem($fixed_ary[$a]))
	   _ArrayInsert($fixed_capacity, $a, DriveSpaceTotal($fixed_ary[$a]))
	   _ArrayInsert($fixed_free, $a, DriveSpaceFree($fixed_ary[$a]))
	Next
	;//end drive information arrays
	
	;//fixed drive formatting
	For $b = 2 to $fixed_ary[0]
	   If $fixed_labels[1] = "" Then
		  $fixed_list = $fixed_list & @LF & $fixed_labels[1] & "(" & StringUpper($fixed_ary[1]) & ")"
	   Else
		  $fixed_list = $fixed_list & @LF & $fixed_labels[1] & " (" & StringUpper($fixed_ary[1]) & ")"
	   EndIf
	Next
	$fixed_list = StringSplit($fixed_list, @LF)
	GLOBAL $fixed_list_item[$fixed_ary[0] + 1]
	For $c = 1 to $fixed_ary[0]   
		If $fixed_labels[$c] = "" Then
			$fixed_list_item[$c]=GUICtrlCreateListViewItem($fixed_labels[$c] & "(" & $fixed_ary_upper[$c] & ")" & "|" & $fixed_status[$c]_
			& "|" & $fixed_filesystem[$c] & "|" & Round($fixed_capacity[$c]/1000, 2) & " GB" & "|" & Round($fixed_free[$c]/1000, 2)_
			& " GB" & "|" & Round(100*($fixed_free[$c]/$fixed_capacity[$c]), 0) & " %", $Drivelisting)
		Else
			$fixed_list_item[$c]=GUICtrlCreateListViewItem($fixed_labels[$c] & " (" & $fixed_ary_upper[$c] & ")" & "|" & $fixed_status[$c]_
			& "|" & $fixed_filesystem[$c] & "|" & Round($fixed_capacity[$c]/1000, 2) & " GB" & "|" & Round($fixed_free[$c]/1000, 2)_
			& " GB" & "|" & Round(100*($fixed_free[$c]/$fixed_capacity[$c]), 0) & " %", $Drivelisting)
		EndIf
	Next
	;//end fixed drive formatting
	
	GUICtrlSetData($DriveListing, $fixed_list)

; ======================
; GUI - Main - Controls
; ======================
$file_menu = GUICtrlCreateMenu ("&File")
	$file_options = GUICtrlCreateMenuitem ("Options", $file_menu)
	$file_seperator = GUICtrlCreateMenuitem ("", $file_menu)
	$file_exit = GUICtrlCreateMenuitem ("Exit      (CTRL+Q)", $file_menu)
$action_menu = GUICtrlCreateMenu ("&Action")
	$action_run = GUICtrlCreateMenuitem ("&Run",$action_menu)
	$action_stop = GUICtrlCreateMenuitem ("&Stop",$action_menu)
	GUICtrlSetState($action_stop, $GUI_DISABLE)
	$action_seperator = GUICtrlCreateMenuitem ("", $action_menu)
	$action_schedule = GUICtrlCreateMenuitem ("&Schedule", $action_menu)
$help_menu = GUICtrlCreateMenu ("&Help")
	$help_topics = GUICtrlCreateMenuitem ("&DELETE GUI Help", $help_menu)
	$help_seperator = GUICtrlCreateMenuitem ("", $help_menu)
	$help_about = GUICtrlCreateMenuitem ("&About", $help_menu)
	
$gui_run = GuiCtrlCreateButton("Run", 10, 110, 100, 30)
$gui_stop = GuiCtrlCreateButton("Stop", 120, 110, 100, 30)
GUICtrlSetState($gui_stop, $GUI_DISABLE)	

$Label_status = GuiCtrlCreateLabel("Status: " & "Idle", 5, 157, 265, 15)
$Label_elapsed = GuiCtrlCreateLabel("Elapsed: ", 280, 157, 220, 15)
$Label_background = GuiCtrlCreateLabel("", 0, 154, 500, 20,BitOr($SS_SIMPLE,$SS_SUNKEN))

$group1 = GuiCtrlCreateGroup("", 0, 95, 500, 55)

$dock_settings = BitOR($GUI_DOCKLEFT, $GUI_DOCKBOTTOM, $GUI_DOCKSIZE, $GUI_DOCKVCENTER)
$stat_settings = BitOR($GUI_DOCKLEFT, $GUI_DOCKBOTTOM, $GUI_DOCKHEIGHT, $GUI_DOCKVCENTER)

GUICtrlSetResizing($gui_run, $dock_settings)
GUICtrlSetResizing($gui_stop, $dock_settings)
GUICtrlSetResizing($group1, $stat_settings)
GUICtrlSetResizing($Label_status, $stat_settings)
GUICtrlSetResizing($Label_elapsed, $stat_settings)
GUICtrlSetResizing($Label_background, $stat_settings)

GUISetState()

; ========================================
; GUI - About
; ========================================
$gui_about = GuiCreate('About', 300+51, 161, -1, -1, BitOr($WS_CAPTION, $WS_SYSMENU), -1, $gui_Main)

GUICtrlCreatePic("img_about.jpg", 0, 0, 51, 161)

GuiCtrlCreateLabel($v_title & @LF &_
				   @LF &_
                   'This application provides a GUI interface for ' &_
				   'deleteing temp folders under windows' & @LF & @LF &_
                   'DELETE GUI was created with AutoIt v3 .', 5+51, 5, 290, 85)

$about_visit = GuiCtrlCreateLabel('Visit AutoIt Website', 5+51, 85, 145, 15)
GuiCtrlSetFont(-1, 8, 400, 4)
GuiCtrlSetColor(-1, 0x0000ff)
GuiCtrlSetCursor(-1, 0)
GuiCtrlSetTip(-1, 'http://www.autoitscript.com')
$about_deletegui = GuiCtrlCreateLabel('Visit My Website', 5+51, 100, 125, 15)
GuiCtrlSetFont(-1, 8, 400, 4)
GuiCtrlSetColor(-1, 0x0000ff)
GuiCtrlSetCursor(-1, 0)
GuiCtrlSetTip(-1, '                       ')
$about_thread = GuiCtrlCreateLabel('Official DELETE GUI Thread', 5+51, 115, 165, 15)
GuiCtrlSetFont(-1, 8, 400, 4)
GuiCtrlSetColor(-1, 0x0000ff)
GuiCtrlSetCursor(-1, 0)
GuiCtrlSetTip(-1, '                                               ')
$about_pethread = GuiCtrlCreateLabel('bart pe DELETE GUI Thread', 5+51, 130, 165, 15)
GuiCtrlSetFont(-1, 8, 400, 4)
GuiCtrlSetColor(-1, 0x0000ff)
GuiCtrlSetCursor(-1, 0)
GuiCtrlSetTip(-1, '                                               ')

$about_close = GuiCtrlCreateButton('&Close', 220+51, 130, 75, 25)

; ========================================
; GUI - Options
; ========================================
GLOBAL $StoreTime = FileGetTime(@ScriptDir & "\config.ini", 0, 1)

$gui_options = GuiCreate("Options", 331, 171, -1, -1, BitOr($WS_CAPTION, $WS_SYSMENU), -1, $gui_Main)
	
$action_group = GuiCtrlCreateGroup("Delete folders and files", 2, 0, 147, 140)
	$action_user_files = GuiCtrlCreateCheckbox("User files", 10, 20, 100, 20)
	$action_sys_files = GuiCtrlCreateCheckbox("System files", 10, 40, 100, 20)
	$action_recycler = GuiCtrlCreateCheckbox("Recycle Bin", 10, 60, 100, 20)
	$action_sys_restore = GuiCtrlCreateCheckbox("System Restore", 10, 80, 100, 20)
	
$option_group = GuiCtrlCreateGroup("", 151, 0, 178, 140)
	$option_log = GuiCtrlCreateCheckbox("Write Log", 160, 20, 70, 20)
	$option_shutdown = GuiCtrlCreateCheckbox("Automatic Shutdown", 160, 40, 130, 20)
	$option_status = GuiCtrlCreateCheckbox("Status Bar", 160, 60, 130, 20)
	$option_stop = GuiCtrlCreateCheckbox("Allow Stop", 160, 80, 130, 20)

$option_close = GuiCtrlCreateButton('&Close', 251, 142, 75, 25)

GuiCtrlSetState($action_user_files, INIRead("config.ini", "actions", "User files", $GUI_CHECKED))
GuiCtrlSetState($action_sys_files, INIRead("config.ini", "actions", "Sys files", $GUI_CHECKED))
GuiCtrlSetState($action_recycler, INIRead("config.ini", "actions", "Recycle Bin", $GUI_CHECKED))
GuiCtrlSetState($action_sys_restore, INIRead("config.ini", "actions", "System Restore", $GUI_UNCHECKED))
GuiCtrlSetState($option_log, INIRead("config.ini", "options", "Write Log", $GUI_UNCHECKED))
GuiCtrlSetState($option_shutdown, INIRead("config.ini", "options", "Automatic Shutdown", $GUI_UNCHECKED))
GuiCtrlSetState($option_status, INIRead("config.ini", "options", "Status Bar", $GUI_CHECKED))
GuiCtrlSetState($option_stop, INIRead("config.ini", "options", "Allow Stop", $GUI_CHECKED))

Call("_SetConfigVar")


Func _SetConfigVar()
	
	iniwrite("config.ini", "Actions", "User files", GUICtrlRead($action_sys_files))
	iniwrite("config.ini", "Actions", "Sys files", GUICtrlRead($action_sys_files))
	iniwrite("config.ini", "Actions", "Recycle Bin", GUICtrlRead($action_recycler))
	iniwrite("config.ini", "Actions", "System Restore", GUICtrlRead($action_sys_restore))
	iniwrite("config.ini", "Options", "Write Log", GUICtrlRead($option_log))
	iniwrite("config.ini", "Options", "Automatic Shutdown", GUICtrlRead($option_shutdown))
	iniwrite("config.ini", "Options", "Status Bar", GUICtrlRead($option_status))
	iniwrite("config.ini", "Options", "Allow Stop", GUICtrlRead($option_stop))
	
	GLOBAL $StoreTime = FileGetTime(@ScriptDir & "\config.ini", 0, 1)
		
EndFunc


; ==========================
; GUI - Loop
; ==========================
While 1

	If WinActive($v_title) Then
		Hotkeyset("^q", "ExitScript")
	Else
		Hotkeyset("^q")
	EndIf
	
	If $StoreTime <> FileGetTime(@ScriptDir & "\config.ini", 0, 1) Then Call("_SetConfigVar")
	
	$msg = GUIGetMsg(1)
		
	If $msg[1] = $gui_main Then
		
		Select
		
			Case $msg[0] = $file_exit
				Return -3
		
			Case $msg[0] = -3
				ExitScript()
					
			Case $msg[0] = $action_run
;        MsgBox(0,"listview", "clicked="& GUICtrlGetState($Drivelisting))
				_BtnRun()
				
			Case $msg[0] = $gui_run
			  $gui_run_read_test = GuiCtrlRead($Drivelisting)
			  MsgBox(0,"listview", "clicked=" & $gui_run_read_test)
				_BtnRun()
				
				
			Case $msg[0] = $help_topics
				_Start($helpfile)
				
			Case $msg[0] = $help_about
				$gui_pos = WinGetPos($v_title, "")
				ControlMove ("About", "", $gui_about, $gui_pos[0] + (($gui_pos[2] / 2) - 165) - 300, $gui_pos[1] + (($gui_pos[3] / 2) - 90) - 110)
				GuiSetState(@SW_SHOW, $gui_about)
				
			Case $msg[0] = $file_options
				$gui_pos = WinGetPos($v_title, "")
				ControlMove ("About", "", $gui_options, $gui_pos[0] + (($gui_pos[2] / 2) - 150) - 300, $gui_pos[1] + (($gui_pos[3] / 2) - 100) - 110)
				GuiSetState(@SW_SHOW, $gui_options)
			
		EndSelect
			
	ElseIf $msg[1] = $gui_about Then
			
		Select
			
			Case $msg[0] = -3
				GuiSetState(@SW_HIDE, $gui_about)
		
			Case $msg[0] = $about_close
				GuiSetState(@SW_HIDE, $gui_about)
				
			Case $msg[0] = $about_visit
				_Start('http://www.autoitscript.com')
			
			Case $msg[0] = $about_deletegui
				_Start('                       ')
				
			Case $msg[0] = $about_thread
				_Start('                                               ')

			Case $msg[0] = $about_pethread
				_Start('                                               ')

		EndSelect
		
	ElseIf $msg[1] = $gui_options Then
		
		Select
			
			Case $msg[0] = -3 
				GuiSetState(@SW_HIDE, $gui_options)
				
			Case $msg[0] = $option_close
				GuiSetState(@SW_HIDE, $gui_options)
				
			Case $msg[0] <> -3 OR <> $option_close
				_SetConfigVar()
				
		EndSelect
			
	EndIf
		
WEnd

Exit

; ==========================
; Functions
; ==========================
Func _BtnRun()
	If GUICtrlRead($DriveListing) = 0 Then Return
	GUICtrlSetState($gui_run, $GUI_DISABLE)
	GUICtrlSetState($gui_stop, $GUI_ENABLE)
	GUICtrlSetState($action_run, $GUI_DISABLE)
	GUICtrlSetState($action_stop, $GUI_ENABLE)

	GLOBAL $d_drive_ary = StringSplit(GUICtrlRead(GUICtrlRead($DriveListing)), "()")
;	GLOBAL $d_letter = StringTrimRight($d_drive_ary[2], 1)
	GLOBAL $d_letter = $d_drive_ary[2]
  GLOBAL $tmptotal = 0
	GLOBAL $elapsed_start = TimerStart()

	BeginDelete()

  GUICtrlSetState($gui_run, $GUI_ENABLE)
	GUICtrlSetState($gui_stop, $GUI_DISABLE)
	GUICtrlSetState($action_run, $GUI_ENABLE)
	GUICtrlSetState($action_stop, $GUI_DISABLE)
	GUICtrlSetData($Label_status, "Status: " & "Deleted a total of " & $tmptotal & " temporary files")

	;//adds drive information to arrays
	For $a = 1 to $fixed_ary[0]
	   _ArrayInsert($fixed_ary_upper, $a, StringUpper($fixed_ary[$a]))
	   _ArrayInsert($fixed_labels, $a, DriveGetlabel($fixed_ary[$a]))
	   _ArrayInsert($fixed_status, $a, DriveStatus($fixed_ary[$a]))
	   _ArrayInsert($fixed_filesystem, $a, DriveGetFileSystem($fixed_ary[$a]))
	   _ArrayInsert($fixed_capacity, $a, DriveSpaceTotal($fixed_ary[$a]))
	   _ArrayInsert($fixed_free, $a, DriveSpaceFree($fixed_ary[$a]))
	Next
	;//end drive information arrays

	For $c = 1 to $fixed_ary[0]
		If $fixed_labels[$c] = "" Then
			GUICtrlSetData($fixed_list_item[$c], $fixed_labels[$c] & "(" & $fixed_ary_upper[$c] & ")" & "|" & $fixed_status[$c]_
			& "|" & $fixed_filesystem[$c] & "|" & Round($fixed_capacity[$c]/1000, 2) & " GB" & "|" & Round($fixed_free[$c]/1000, 2)_
			& " GB" & "|" & Round(100*($fixed_free[$c]/$fixed_capacity[$c]), 0) & " %")
		Else
			GUICtrlSetData($fixed_list_item[$c], $fixed_labels[$c] & "(" & $fixed_ary_upper[$c] & ")" & "|" & $fixed_status[$c]_
			& "|" & $fixed_filesystem[$c] & "|" & Round($fixed_capacity[$c]/1000, 2) & " GB" & "|" & Round($fixed_free[$c]/1000, 2)_
			& " GB" & "|" & Round(100*($fixed_free[$c]/$fixed_capacity[$c]), 0) & " %")
		EndIf
	Next
	;//end fixed drive formatting

	;GUICtrlSetData($DriveListing, $fixed_list)

EndFunc

func BeginDelete()

  if DriveStatus($d_letter & "\") = "READY" then

    if GUICtrlRead($action_sys_files) = $GUI_CHECKED then
      GUICtrlSetData($Label_status, "Status: " & "Deleting Users temp files - " & $d_drive_ary[1] & "(" &$d_drive_ary[2] & ")")
      if FileExists($d_letter & "\Documents And Settings\") then
        $users = FileFindFirstFile($d_letter & "\Documents And Settings\*.*")
        If $users <> -1 Then
          while 1
            $cuser = FileFindNextFile($users)
            If @error Then ExitLoop
            if $cuser = "All Users" or $cuser = "Default User" or $cuser = "LocalService" or $cuser = "NetworkService" or $cuser = "." or $cuser = ".." then ContinueLoop
            delcont($d_letter & "\Documents And Settings\" & $cuser & "\Local Settings\Temp", "", 0)
            if GUICtrlGetState($gui_stop) = "144" then Return
            delcont($d_letter & "\Documents And Settings\" & $cuser & "\Local Settings\Temporary Internet Files\Content.IE5", ".txt", 0)
            if GUICtrlGetState($gui_stop) = "144" then Return
          wend
        endif
        FileClose($users)
      endif
      if FileExists($d_letter & "\WINNT\Profiles\") then
        $users = FileFindFirstFile($d_letter & "\WINNT\Profiles\*.*")
        If $users <> -1 Then
          while 1
            $cuser = FileFindNextFile($users)
            If @error Then ExitLoop
            if $cuser = "All Users" or $cuser = "Default User" or $cuser = "LocalService" or $cuser = "NetworkService" or $cuser = "." or $cuser = ".." then ContinueLoop
            delcont($d_letter & "\WINNT\Profiles\" & $cuser & "\Local Settings\Temp", "", 0)
            if GUICtrlGetState($gui_stop) = "144" then Return
            delcont($d_letter & "\WINNT\Profiles\" & $cuser & "\Local Settings\Temporary Internet Files\Content.IE5", ".txt", 0)
            if GUICtrlGetState($gui_stop) = "144" then Return
          wend
        endif
        FileClose($users)
      endif
    endif

    if GUICtrlRead($action_sys_files) = $GUI_CHECKED then
      GUICtrlSetData($Label_status, "Status: " & "Deleting system temp files - " & $d_drive_ary[1] & "(" &$d_drive_ary[2] & ")")
      delcont($d_letter & "\Windows\Temp", "", 0)
      if GUICtrlGetState($gui_stop) = "144" then Return
      delcont($d_letter & "\Windows\msdwnload.dir", "", 0)
      if GUICtrlGetState($gui_stop) = "144" then Return
      delcont($d_letter & "\WINNT\Temp", "", 0)
      if GUICtrlGetState($gui_stop) = "144" then Return
      delcont($d_letter & "\WINNT\msdwnload.dir", "", 0)
      if GUICtrlGetState($gui_stop) = "144" then Return
      delcont($d_letter & "\Temp", "", 0)
      if GUICtrlGetState($gui_stop) = "144" then Return
      delcont($d_letter & "\Windows\Temporary Internet Files\Content.IE5", ".txt", 0)
      if GUICtrlGetState($gui_stop) = "144" then Return
    endif
    
    if GUICtrlRead($action_recycler) = $GUI_CHECKED then
      GUICtrlSetData($Label_status, "Status: " & "Empty recycle bin - " & $d_drive_ary[1] & "(" &$d_drive_ary[2] & ")")
      delcont($d_letter & "\RECYCLER", "", 0)
      if GUICtrlGetState($gui_stop) = "144" then Return
    endif

    if GUICtrlRead($action_sys_restore) = $GUI_CHECKED then
      GUICtrlSetData($Label_status, "Status: " & "Deleting System Restore - " & $d_drive_ary[1] & "(" &$d_drive_ary[2] & ")")
      delcont($d_letter & "\System Volume Information", "", 0)
      if GUICtrlGetState($gui_stop) = "144" then Return
    endif
  endif
EndFunc

func delcont($folder, $filespec, $dlfldr)
 if not FileExists($folder) then Return
 if StringInStr(FileGetAttrib($folder), "D") then
  $cur = FileFindFirstFile($folder & "\*")
  While 1
   $curfile = FileFindNextFile($cur)
   If @error Then ExitLoop
   if $curfile = "." or $curfile = ".." then ContinueLoop
   if StringInStr(FileGetAttrib($folder & "\" & $curfile), "D") then
    delcont($folder & "\" & $curfile, $filespec, 1)
   else
    if $filespec = "" then
     mydel($folder & "\" & $curfile)
    else
     if not StringInStr($curfile, $filespec) then
      mydel($folder & "\" & $curfile)
     endif
    endif
   endif
   if GUICtrlGetState($gui_stop) = "144" then ExitLoop
  WEnd
  if GUICtrlGetState($gui_stop) = "144" then Return
  FileClose($cur)
  if $dlfldr = 1 then rmifempty($folder)
 endif
endfunc

func mydel($fl)
 if StringInStr(FileGetAttrib($fl), "R") then FileSetAttrib($fl, "-R")
 $tst = FileDelete($fl)
 if $tst <> 0 then $tmptotal = $tmptotal + 1
  ; ToolTip("Files Deleted: " & $tmptotal); & @LF & "Current File: " & $fl
  ;// elapsed time
	GLOBAL $elapsed_end = TimerDiff($elapsed_start)/1000;elapsed time in seconds
	$elapsed_hour = Int($elapsed_end / 3600)
	$elapsed_min = Int(($elapsed_end - ($elapsed_hour * 3600)) / 60)
	$elapsed_sec = Round($elapsed_end - Int($elapsed_end / 60) * 60, 0)
  If $elapsed_end < 60 Then
		$elapsed_calc = $elapsed_sec & " seconds";Int displays smallest integer only
	ElseIf $elapsed_end < 3600 Then
		$elapsed_calc = $elapsed_min & " min " & $elapsed_sec & " seconds"
	Else
		$elapsed_calc = $elapsed_hour & " hour " & $elapsed_min & " min " & $elapsed_sec & " seconds"
		$msg = GuiGetMsg()
	EndIf
	If $elapsed_hour > 999 Then $elapsed_calc = "Out of range"

	GUICtrlSetData($Label_elapsed, "Elapsed: " & $elapsed_calc)
  ;// end elapsed time

    $mydel_msg = GUIGetMsg()
  	Select
			Case $mydel_msg = $gui_stop
				GUICtrlSetState($gui_run, $GUI_ENABLE)
				GUICtrlSetState($gui_stop, $GUI_DISABLE)
				GUICtrlSetState($action_run, $GUI_ENABLE)
				GUICtrlSetState($action_stop, $GUI_DISABLE)

      Case $mydel_msg = $action_stop
				GUICtrlSetState($gui_run, $GUI_ENABLE)
				GUICtrlSetState($gui_stop, $GUI_DISABLE)
				GUICtrlSetState($action_run, $GUI_ENABLE)
				GUICtrlSetState($action_stop, $GUI_DISABLE)

			Case $mydel_msg = $GUI_EVENT_CLOSE
				ExitScript()

		EndSelect
;		Sleep(10)
endfunc

func rmifempty($fl)
 $fld = FileFindFirstFile($fl & "\*")
  While 1
   $fldr = FileFindNextFile($fld)
   If @error Then ExitLoop
   if $fldr = "." or $fldr = ".." then ContinueLoop
   Return
  WEnd
 FileClose($fld)
DirRemove($fl)
endfunc

Func Timer()
	$time_current = @HOUR & ":" &@MIN & ":" & @SEC
EndFunc

Func _Start($s_StartPath)
	If @OSType = 'WIN32_NT' Then
		$s_StartStr = @ComSpec & ' /c start "" '
	Else
		$s_StartStr = @ComSpec & ' /c start '
	EndIf
	
	Run($s_StartStr & $s_StartPath, '', @SW_HIDE)
EndFunc

Func ExitScript()
	GUIDelete()
	Exit
EndFunc
