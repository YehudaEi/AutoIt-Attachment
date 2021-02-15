#NoTrayIcon
Opt("TrayIconHide", 1) 
Opt("TrayMenuMode", 1)
#AutoIt3Wrapper_Icon=d:\Documents and Settings\shafikovis\MyDocs_07_2010\» ŒÕ » ÕŒ¬€≈\FILES1.ICO


; --------------------- INCLUDE
#include <Array.au3>
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include <EditConstants.au3>
#include <ProgressConstants.au3>
#Include <File.au3>

; --------------------- DECLARE
Global $a_FoundFiles[1]
$a_FoundFiles[0] = ""

Global $g_b_movefiles = $GUI_CHECKED, $g_b_overwrite = $GUI_UNCHECKED, $g_b_recurse = $GUI_CHECKED, $g_b_makepath = $GUI_CHECKED

Global $gui, $edit_todir, $btn_browse_todir, $edit_fromdir, $btn_browse_fromdir, $btn_start, $edit_fname_mask, $edit_fext_mask, _
	$lab_todir, $lab_fromdir, $lab_fname_mask, $lab_fext_mask, $lab_prog, $lab_prog1, $pr_files, $btn_options, $btn_pause, $btn_cancel

Global $gui_dlg, $btn_set, $btn_cancel, $rb_overwrite, $rb_rename, $rb_movefiles, $rb_copyfiles, $cb_recurse, $cb_makepathnames, $input_pathseparator

; --------------------- FUNCS
; ----- Find files recursive
Func ScanFolder($SourceFolder, $FileMask, ByRef $array, $Recurse = True)

	Local $File
	Local $Search
	Local $FileAttributes
	Local $FullFilePath

	$Search = FileFindFirstFile($SourceFolder & "\*.*")
	If $Search = -1 Then
		FileClose($Search)
		Return
	EndIf

	While @error <> 1
		$File = FileFindNextFile($Search)
		If @error Then ExitLoop

		$FullFilePath = $SourceFolder & "\" & $File
		$FileAttributes = FileGetAttrib($FullFilePath)	

		If StringInStr($FileAttributes, "D") > 0 Then			
			If $Recurse = True Then
				ScanFolder($FullFilePath, $FileMask, $array, $Recurse)
			EndIf
		Else
			If StringRegExp($File, $FileMask) = 1 Then				
				If UBound($array) = 1 And $array[0] = "" Then
					$array[0] = $FullFilePath
					GUICtrlSetData($lab_prog1, "Found: 1")
				Else
					_ArrayAdd($array, $FullFilePath)
					GUICtrlSetData($lab_prog1, "Found: " & UBound($array))					
				EndIf
			EndIf
		EndIf
	WEnd

	FileClose($Search)
	Return
EndFunc   ;==>ScanFolder

; ----- Rename file if it exists by adding [1],[2],... etc. to its name
; Returns either the full path to the renamed file or just the filename and extension
Func RenameFile($filename, $b_returnfullpath=false)
	if not FileExists($filename) Then
		return $filename
	endif
	
	Local $count = 1
	Local $filename_new
	Local $szDrive, $szDir, $szFName, $szExt
	
	Local $TestPath = _PathSplit($filename, $szDrive, $szDir, $szFName, $szExt)
	$filename_new = $filename
	
	While FileExists($filename_new)		
		$filename_new = $szDrive & $szDir & $szFName & " [" & $count & "]" & $szExt
		$count = $count + 1
	WEnd
	
	if $b_returnfullpath then
		Return $filename_new
	Else
		$TestPath = _PathSplit($filename_new, $szDrive, $szDir, $szFName, $szExt)
		Return ($szFName & $szExt)
	endif
EndFunc

; ----- Add to filename its full path (replacing '\' by '_')
; E.g. FilenameFromPath("C:\Folder\Subfolder\File.txt") RETURNS "Folder_Subfolder_File.txt"
Func FilenameFromPath($filename, $splitter="_", $b_returnfullpath=false)
	Local $szDrive, $szDir, $szFName, $szExt, $i
	Local $TestPath = _PathSplit($filename, $szDrive, $szDir, $szFName, $szExt)
	
	Local $SplitDir = StringSplit($szDir, "\")
	Local $DirPath = ""
	for $i = 1 to $SplitDir[0]
		$DirPath &= $SplitDir[$i] & $splitter
	next
	
	if $b_returnfullpath then
		Return $szDrive & $szDir & $DirPath & $szFName & $szExt
	Else
		Return $DirPath & $szFName & $szExt
	EndIf	
EndFunc

; ----- Main func to copy or move files from one dir to another
Func DumpFiles($from_dir, $to_dir, $filemask_regex='(.*?)\.(.*?)', $b_movefiles=true, $b_overwrite_existing=false, $b_recurse=true, $b_makepath=true)
	Local $count = 0, $count_ok = 0
	Local $fname, $i
	
	GUICtrlSetData($lab_prog1, "Searching source files...")
	ScanFolder($from_dir, $filemask_regex, $a_FoundFiles, $b_recurse)
	GUICtrlSetData($lab_prog1, "...")
	
	$count = UBound($a_FoundFiles)
	
	if ($count=1) and ($a_FoundFiles[0]="") Then
		Return 0
	endif
	
	Local $perc = 0, $perc_str = ""
	
	GUICtrlSetData($pr_files, $perc)
	
	for $i=0 to ($count-1)
		if $b_movefiles Then
			if $b_overwrite_existing then
				if $b_makepath then
					if FileMove($a_FoundFiles[$i], $to_dir & FilenameFromPath($a_FoundFiles[$i]), 1) then $count_ok = $count_ok + 1
				Else
					if FileMove($a_FoundFiles[$i], $to_dir & $a_FoundFiles[$i], 1) then $count_ok = $count_ok + 1
				endif
			Else
				if $b_makepath then
					if FileMove($a_FoundFiles[$i], $to_dir & RenameFile(FilenameFromPath($a_FoundFiles[$i]))) then $count_ok = $count_ok + 1
				else
					if FileMove($a_FoundFiles[$i], $to_dir & RenameFile($a_FoundFiles[$i])) then $count_ok = $count_ok + 1
				endif
			endif
		Else
			if $b_overwrite_existing then
				if $b_makepath then
					if FileCopy($a_FoundFiles[$i], $to_dir & FilenameFromPath($a_FoundFiles[$i]), 1) then $count_ok = $count_ok + 1
				Else
					if FileCopy($a_FoundFiles[$i], $to_dir & $a_FoundFiles[$i], 1) then $count_ok = $count_ok + 1
				endif
			Else
				if $b_makepath then
					if FileCopy($a_FoundFiles[$i], $to_dir & RenameFile(FilenameFromPath($a_FoundFiles[$i]))) then $count_ok = $count_ok + 1
				else
					if FileCopy($a_FoundFiles[$i], $to_dir & RenameFile($a_FoundFiles[$i])) then $count_ok = $count_ok + 1
				endif
			endif
		endif
		
		$perc = 100 * ($i+1) / $count
		GUICtrlSetData($pr_files, $perc)
		$perc_str = Round($perc) & "% [" & String($i+1) & " of " & $count & "]"
		GUICtrlSetData($lab_prog1, $perc_str)
		
		; Show progress percent in the window caption:
		WinSetTitle($gui, "", String($perc))
	next
		
		WinSetTitle($gui, "", "Dump Files")
		
	Return $count_ok
	
EndFunc

Func GUI_Main()
	$gui = GUICreate("Dump Files", 400, 330)

	$lab_fromdir = GUICtrlCreateLabel("FROM    (dir):", 10, 5, 380)
	GUICtrlSetColor(-1, 0x0000ff)
	$edit_fromdir = GUICtrlCreateEdit(@DesktopDir, 10, 20, 355, 20, BitOR($ES_AUTOVSCROLL, $ES_AUTOHSCROLL))
	$btn_browse_fromdir = GUICtrlCreateButton("...", 370, 20, 20, 20)

	$lab_todir = GUICtrlCreateLabel("TO         (dir):", 10, 50, 380)
	GUICtrlSetColor(-1, 0x0000ff)
	$edit_todir = GUICtrlCreateEdit(@DesktopDir, 10, 65, 355, 20, BitOR($ES_AUTOVSCROLL, $ES_AUTOHSCROLL))
	$btn_browse_todir = GUICtrlCreateButton("...", 370, 65, 20, 20)

	$lab_fname_mask = GUICtrlCreateLabel("File name contains (leave empty if any file name):", 10, 100, 380)
	GUICtrlSetColor(-1, 0x751E29)
	$edit_fname_mask = GUICtrlCreateEdit("", 10, 115, 380, 20, BitOR($ES_AUTOVSCROLL, $ES_AUTOHSCROLL))
	GUICtrlSetBkColor(-1, 0xffff00)

	$lab_fext_mask = GUICtrlCreateLabel("File extension, e.g. ""mp3"" (leave empty if any extension):", 10, 140, 380)
	GUICtrlSetColor(-1, 0x751E29)
	$edit_fext_mask = GUICtrlCreateEdit("jpg", 10, 155, 380, 20, BitOR($ES_AUTOVSCROLL, $ES_AUTOHSCROLL))
	GUICtrlSetBkColor(-1, 0xffff00)

	$btn_options = GUICtrlCreateButton("Settings...", 10, 180, 80, 25)

	$btn_start = GUICtrlCreateButton("START", 150, 200, 100, 30)
	
	$btn_pause = GUICtrlCreateButton("Pause", 150, 235, 47, 20)
	GUICtrlSetState (-1, $GUI_DISABLE)
	$btn_pause = GUICtrlCreateButton("Stop", 203, 235, 47, 20)
	GUICtrlSetState (-1, $GUI_DISABLE)

	$lab_prog = GUICtrlCreateLabel("Progress:", 10, 275, 140)
	GUICtrlSetColor(-1, 0xff0000)
	$lab_prog1 = GUICtrlCreateLabel("...", 150, 275, 240)
	GUICtrlSetColor(-1, 0x246B15)
	$pr_files = GUICtrlCreateProgress(10, 295, 380, 20, $PBS_SMOOTH)
	GUICtrlSetBkColor(-1, 0)
	GUICtrlSetColor(-1, 0x00ff00)
	GUICtrlSetData(-1, 0)
	GUICtrlSetState(-1, $GUI_SHOW)

	GUISetState()	
	
	While True

		$msg = GUIGetMsg(1)
;~ 		$msg = GUIGetMsg()
		Switch $msg[1]
			Case 0
				ContinueLoop
			
			Case $gui
;~ 			Case $msg[1] = $gui
;~ 				ToolTip("FORM 1", 600, 300)

				Switch $msg[0]
					Case $btn_browse_fromdir
						Local $selecteddir = FileSelectFolder("Select source directory:", "", 2, "", $gui)
						If $selecteddir <> "" And FileExists($selecteddir) Then				
							GUICtrlSetData($edit_fromdir, $selecteddir)
						EndIf
						
					Case $btn_browse_todir
						Local $selecteddir = FileSelectFolder("Select destination directory:", "", 2, "", $gui)
						If $selecteddir <> "" And FileExists($selecteddir) Then				
							GUICtrlSetData($edit_todir, $selecteddir)
						EndIf
					
					Case $btn_options						
						GUISetState(@SW_DISABLE, $gui)
						GUI_Options()
																		
					Case $btn_start
						Local $from = GUICtrlRead($edit_fromdir)
						Local $to = GUICtrlRead($edit_todir)
						if StringRight($from, 1) <> "\" Then
							$from &= "\"
							GUICtrlSetData($edit_fromdir, $from)
						EndIf
						if StringRight($to, 1) <> "\" Then
							$to &= "\"
							GUICtrlSetData($edit_todir, $to)
						EndIf
						
						if FileExists($from) Then
							if FileExists($to) Then					
								Local $bmove, $boverwrite, $bmakepaths, $brecurse, $fnamemask, $fextmask
								
								if $g_b_movefiles = $GUI_CHECKED Then
									$bmove = true
								Else
									$bmove = false
								EndIf
								
								if $g_b_overwrite = $GUI_CHECKED Then
									$boverwrite = true
								Else
									$boverwrite = false
								EndIf
								
								if $g_b_recurse = $GUI_CHECKED Then
									$brecurse = true
								Else
									$brecurse = false
								EndIf
								
								if $g_b_makepath = $GUI_CHECKED Then
									$bmakepaths = true
								Else
									$bmakepaths = false
								EndIf
								
								if GUICtrlRead($edit_fname_mask) <> "" then
									$fnamemask = '(?i)(.*?)' & GUICtrlRead($edit_fname_mask) & '(.*?)'
								Else
									$fnamemask = '(?i)(.*?)'
								EndIf
								
								if GUICtrlRead($edit_fext_mask) <> "" then
									$fextmask = '\.(?i)' & GUICtrlRead($edit_fext_mask)
								Else
									$fextmask = '\.(?i)(.*?)'
								EndIf
								
								Local $fullmask = $fnamemask & $fextmask					
												
								Local $res = DumpFiles($from, $to, $fullmask, $bmove, $boverwrite, $brecurse, $bmakepaths)
								
								MsgBox(0, "Completed", "Copied/moved " & $res & " files.")
							Else
								MsgBox(16, "Error", "Destination dir not available!")
							endif
						Else
							MsgBox(16, "Error", "Source dir not available!")
						endif
					
					Case $GUI_EVENT_CLOSE
						ExitLoop
				EndSwitch
			
			Case $gui_dlg
;~ 			Case $msg[1] = $gui_dlg
;~ 				ToolTip("FORM 2", 600, 300)
				Switch $msg[0]					
	 				Case $btn_set
;~ 	 					ToolTip("FORM 2: BTN_SET", 600, 300)
	 					$g_b_movefiles = GUICtrlRead($rb_movefiles)	
	 					$g_b_overwrite = GUICtrlRead($rb_overwrite)
						
						$g_b_recurse = GUICtrlRead($cb_recurse)
						$g_b_makepath = GUICtrlRead($cb_makepathnames)
						
						GUIDelete($gui_dlg)
						GUISetState(@SW_ENABLE, $gui)
						WinActivate($gui)
						
;~ 					Case $btn_cancel						
;~ 						GUIDelete($gui_dlg)
;~ 						GUISetState(@SW_ENABLE, $gui)
;~ 						WinActivate($gui)
												
					Case $GUI_EVENT_CLOSE, $btn_cancel				
						GUIDelete($gui_dlg)
						GUISetState(@SW_ENABLE, $gui)
						WinActivate($gui)
						
				EndSwitch
			
		EndSwitch
		
	WEnd
EndFunc

Func GUI_Options()
	$gui_dlg = GUICreate("ŒÔˆËË", 400, 250, -1, -1, $DS_MODALFRAME)
	
	$cb_recurse = GUICtrlCreateCheckbox("Search in sub-directories", 10, 10)	
	GUICtrlSetState($cb_recurse, $g_b_recurse)
	$cb_makepathnames = GUICtrlCreateCheckbox("Rename copied files according to their source path", 10, 30)
	GUICtrlSetState($cb_makepathnames, $g_b_makepath)	 
	
	GUICtrlCreateGroup("If destination file exists:", 10, 55, 370, 60)
	
	$rb_overwrite = GUICtrlCreateRadio("Overwrite", 20, 70, 300, 20)
	GUICtrlSetState($rb_overwrite, $g_b_overwrite)
	$rb_rename = GUICtrlCreateRadio("Auto rename", 20, 90, 300, 20)	
	
	if $g_b_overwrite = $GUI_CHECKED then
		GUICtrlSetState($rb_overwrite, $GUI_CHECKED)
		GUICtrlSetState($rb_rename, $GUI_UNCHECKED)
	Else
		GUICtrlSetState($rb_overwrite, $GUI_UNCHECKED)
		GUICtrlSetState($rb_rename, $GUI_CHECKED)
	endif
	
	GUICtrlCreateGroup("", -99, -99, 1, 1)  ;close group
	
	GUICtrlCreateGroup("Dump mode (COPY or MOVE):", 10, 120, 370, 60)
	
	$rb_copyfiles = GUICtrlCreateRadio("Copy", 20, 135, 150, 20)	
	$rb_movefiles = GUICtrlCreateRadio("Move", 20, 155, 150, 20)
	GUICtrlSetState($rb_movefiles, $g_b_movefiles)
	
	if $g_b_movefiles = $GUI_CHECKED then
		GUICtrlSetState($rb_movefiles, $GUI_CHECKED)
		GUICtrlSetState($rb_copyfiles, $GUI_UNCHECKED)
	Else
		GUICtrlSetState($rb_movefiles, $GUI_UNCHECKED)
		GUICtrlSetState($rb_copyfiles, $GUI_CHECKED)
	endif
	
	GUICtrlCreateGroup("", -99, -99, 1, 1)  ;close group

	$btn_set = GUICtrlCreateButton("—Óı‡ÌËÚ¸", 5, 190, 180, 25)	
	$btn_cancel = GUICtrlCreateButton("ŒÚÏÂÌ‡", 210, 190, 180, 25)
			
	GUISetState()
EndFunc

; --------------------- GO!

GUI_Main()