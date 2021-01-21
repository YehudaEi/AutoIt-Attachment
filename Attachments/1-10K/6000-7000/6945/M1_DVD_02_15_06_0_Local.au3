opt("RunErrorsFatal", 0)
opt("GUIOnEventMode", 1)

Global $apptype, $attempt = 0, $copy_check, $copy_list, $copy_log, $copy_log_0, $copy_log_1, $copy_log_2, $copy_log_3, $copy_log_file
Global $copy_log_open, $copy_log_output, $copy_log_path, $copy_path, $copy_progress, $copy_progress2, $current_os, $dest_drv, $dest_size
Global $disc_in_drive, $disk_in_drive, $drv_spc_calc, $drv_spc_free, $drv_spc_need, $dvd_desc1, $dvd_desc2, $dvd_drv, $dvd_ltr = 65
Global $dvd_num = 1, $error, $error_check, $error_send, $fldr_attrib, $fldr_file, $fldr_srch, $folders, $iMsgBoxAnswer, $ini_desc1
Global $ini_desc2, $length_drv, $length_dvd, $length_ini, $loop_thru, $path_check, $prog_label_1, $prog_label_2, $set_desc_dvd
Global $set_desc_ini, $sk_add, $source_attrib, $source_file, $source_get_size, $source_search, $source_size, $ssid_dvd, $ssid_ini
Global $status, $stop, $update, $update_error, $wait, $warning = String("--------------------"), $wintype, $winver, $working, $x, $y

#NoTrayIcon
#include <Process.au3>
#include <Array.au3>
#include <GuiConstants.au3>
;-----------------------------------------------------------------------------------------------------------------------------
;Copy/Update/Looking/Re-Insert GUI
;-----------------------------------------------------------------------------------------------------------------------------
$progress_gui = GUICreate("M1 DVD Utility", 400, 110, (@DesktopWidth - 400) / 2, (@DesktopHeight - 110) / 2, $WS_OVERLAPPEDWINDOW + $WS_CLIPSIBLINGS)
GUISetState(@SW_HIDE, $progress_gui)
$Progress_meter = GUICtrlCreateProgress(98, 40, 205, 20)
$prog_gui_cancel = GUICtrlCreateButton("Cancel", 167, 76, 68, 26)
$prog_gui_text = GUICtrlCreateLabel($prog_label_1, 20, 6, 360, 30, $SS_CENTER)
GUICtrlSetFont($prog_gui_text, 12, 700)
$percent_text = GUICtrlCreateLabel($prog_label_2, 100, 62, 100, 15)
;-----------------------------------------------------------------------------------------------------------------------------
GUISetOnEvent($GUI_EVENT_CLOSE, "ExitConfirm1")
GUICtrlSetOnEvent($prog_gui_cancel, "ExitConfirm1")
;-----------------------------------------------------------------------------------------------------------------------------
;Error GUI
;-----------------------------------------------------------------------------------------------------------------------------
$error_gui = GUICreate("Error", 400, 242, (@DesktopWidth - 400) / 2, (@DesktopHeight - 242) / 2, $WS_OVERLAPPEDWINDOW + $WS_CLIPSIBLINGS)
$Button_Retry = GUICtrlCreateButton("Retry", 86, 208, 68, 26)
$Button_Next = GUICtrlCreateButton("Next Disc", 168, 208, 68, 26)
$Button_Cancel = GUICtrlCreateButton("Cancel", 251, 208, 68, 26)
$intro_text = GUICtrlCreateLabel("The following errors have been detected:", 10, 5, 380, 25, $SS_CENTER)
$error_text = GUICtrlCreateLabel("", 10, 25, 380, 70, $SS_CENTER + $SS_SUNKEN)
$action_text = GUICtrlCreateLabel("To retry the update click 'Retry'." & @CRLF & "To skip to the next disc in the series click 'Next Disc'.", 10, 105, 380, 40, $SS_CENTER)
$note1_text = GUICtrlCreateLabel($warning & "----------     W A R N I N G     ----------" & $warning, 10, 140, 380, 20, $SS_CENTER)
GUICtrlSetFont(-1, 10, 700)
$note2_text = GUICtrlCreateLabel("If you choose 'Next Disc' the data paths for this disc will not be set.", 10, 170, 380, 20, $SS_CENTER)
GUICtrlSetFont(-1, 9, 700)
;-----------------------------------------------------------------------------------------------------------------------------
GUISetOnEvent($GUI_EVENT_CLOSE, "ExitConfirm2")
GUICtrlSetOnEvent($Button_Retry, "RestartCopy")
GUICtrlSetOnEvent($Button_Next, "ErrorSend")
GUICtrlSetOnEvent($Button_Cancel, "ExitConfirm2")
;-----------------------------------------------------------------------------------------------------------------------------
FileInstall("C:\Documents and Settings\Administrator\Desktop\Transfer\Dminion\M1 DVD\Exe's\robocopy.exe", @WindowsDir & "\robocopy.exe", 1)
FileInstall("C:\Documents and Settings\Administrator\Desktop\Transfer\Dminion\M1 DVD\Exe's\M1_Link.exe", @WindowsDir & "\M1_Link.exe", 1)
;-----------------------------------------------------------------------------------------------------------------------------
;Final Version Splash Screen.
;-----------------------------------------------------------------------------------------------------------------------------
$destination = @TempDir & "\M1Splash.jpg"
FileInstall("C:\Documents and Settings\Administrator\Desktop\Transfer\Dminion\M1 DVD\Graphics\M1Splash.jpg", $destination, 1)  ;source must be literal string
SplashImageOn("Final Splash", $destination, 300, 90, -1, -1, 1)
Sleep(2500)
SplashOff()
;-----------------------------------------------------------------------------------------------------------------------------
;Verify windows version, Rep/Est installed, data added, backup ini file and store all ini variables.
;-----------------------------------------------------------------------------------------------------------------------------
$iMsgBoxAnswer = MsgBox(262145, "M1 DVD Utility", "  This utility will copy the Repair DVD's to your computer." & @CRLF & @CRLF & " If you have recently received a software update, please" & @CRLF & "cancel this utility and follow the update instructions before" & @CRLF & "   using this utility. Click 'OK' to begin or 'Cancel' to exit.")
Select
	Case $iMsgBoxAnswer = 1 ;OK
		If FileExists(@WindowsDir & "\od5.ini") Then
			$apptype = String("od5")
			;~ 		ElseIf FileExists(@WindowsDir & "\sk5.ini") Then
			;~ 			$apptype = String("sk5")
			;~ 			$sk_add = String("SK")
		Else
			MsgBox(262160, "Error", "The Repair & Estimator program could not be found. " & @CRLF & " Please install the program or call technical support" & @CRLF & "             at 1-888-724-6742 for assistance.")
			Exit
		EndIf
		FileCopy(@WindowsDir & "\" & $apptype & ".ini", @WindowsDir & "\" & $apptype & ".ini.bak", 1)
		;-----------------------------------------------------------------------------------------------------------------------------
		;-----------------------------------------------------------------------------------------------------------------------------
		;INI Variables
		$shared_path = IniRead(@WindowsDir & "\" & $apptype & ".ini", "Paths", "SharedPath", "1")
		If $shared_path = 1 Then
			MsgBox(262160, "Error", "       The shared path could not be found.         " & @CRLF & "Please reinstall the program or call technical support" & @CRLF & "             at 1-888-724-6742 for assistance.")
			Exit
		EndIf
		;-----------------------------------------------------------------------------------------------------------------------------
		$discs_in_set = IniRead($shared_path & "\shared.ini", "ODM", "DiscsInSet", "1")
		If $discs_in_set = 1 Then
			MsgBox(262160, "Error", "The Repair data has not been added to the program. " & @CRLF & " Please add the repair data or call technical support" & @CRLF & "             at 1-888-724-6742 for assistance.")
			Exit
		EndIf
		;-----------------------------------------------------------------------------------------------------------------------------
		$ssid_ini = IniRead($shared_path & "\shared.ini", "ODM1", "SilkScreenID", "1")
		If $ssid_ini = 1 Then
			MsgBox(262160, "Error", "The Repair data has not been added to the program. " & @CRLF & " Please add the repair data or call technical support" & @CRLF & "             at 1-888-724-6742 for assistance.")
			Exit
		EndIf
		$ssid_ini = StringTrimRight($ssid_ini, 1)
		$ssid_ini = $ssid_ini & Chr($dvd_ltr)
		;-----------------------------------------------------------------------------------------------------------------------------
		$set_desc_ini = IniRead($shared_path & "\shared.ini", "ODM1", "SetDescription", "1")
		If $ssid_ini = 1 Then
			MsgBox(262160, "Error", "The Repair data has not been added to the program. " & @CRLF & " Please add the repair data or call technical support" & @CRLF & "             at 1-888-724-6742 for assistance.")
			Exit
		EndIf
		$length_ini = StringLen($set_desc_ini) - 1
		$ini_desc1 = StringTrimRight($set_desc_ini, $length_ini)
		$ini_desc2 = StringTrimLeft($set_desc_ini, 1)
		$ini_desc2 = StringLower($ini_desc2)
		$set_desc_ini = String($ini_desc1 & $ini_desc2)
		;-----------------------------------------------------------------------------------------------------------------------------
		;-----------------------------------------------------------------------------------------------------------------------------
		$copy_path = String($shared_path & "\Repair\")
		$path_check = StringInStr($copy_path, " ")
		If Not $path_check = 0 Then
			$copy_path = FileGetShortName($copy_path)
		EndIf
		$copy_log_path = String($copy_path & "Logs\")
		;-----------------------------------------------------------------------------------------------------------------------------
		;-----------------------------------------------------------------------------------------------------------------------------
		$wintype = @OSTYPE
		$winver = @OSVersion
		Select
			Case $winver = "WIN_2003"
				$current_os = "Windows 2003"
			Case $winver = "WIN_XP"
				$current_os = "Windows XP"
			Case $winver = "WIN_2000"
				$current_os = "Windows 2000"
			Case $winver = "WIN_NT4"
				$current_os = "Windows NT"
			Case $winver = "WIN_ME"
				$current_os = "Windows ME"
			Case $winver = "WIN_98"
				$current_os = "Windows 98"
			Case $winver = "WIN_95"
				$current_os = "Windows 95"
		EndSelect
		If $wintype = ("WIN32_NT") And $winver = ("WIN_NT4") Then
			FileInstall("C:\Program Files\AutoIt3\psapi.dll", @SystemDir & "/psapi.dll")
		EndIf
		If $wintype = ("WIN32_WINDOWS") Then
			MsgBox(262160, "Unsupported OS", "  " & $current_os & " is an unsupported operating system." & @CRLF & "" & @CRLF & "This utility is compatible with the following platforms:" & @CRLF & "                Windows NT4 / 2000 / XP / 2003" & @CRLF & "" & @CRLF & "    Please run this utility on a supported platform.                " & @CRLF & "" & @CRLF & "                          Click 'OK' to exit.")
			Exit
		EndIf
		;-----------------------------------------------------------------------------------------------------------------------------
		;Check For Available Drive Space
		$folders = 0
		$length_drv = StringLen($copy_path) - 3
		$dest_drv = StringTrimRight($copy_path, $length_drv)
		$drv_spc_free = DriveSpaceFree($dest_drv)
		$drv_spc_free = Int($drv_spc_free)
		$drv_spc_need = $discs_in_set * 8000
		If FileExists($copy_path) Then
			$fldr_srch = FileFindFirstFile($copy_path & "*.*")
			If $fldr_srch = -1 Then
				MsgBox(0, "Error", "No files/directories found in " & $copy_path)
				Exit
			EndIf
			While 1
				$fldr_file = FileFindNextFile($fldr_srch)
				If @error Then
					ExitLoop
				EndIf
				If $fldr_file = "." Or $fldr_file = ".." Or $fldr_file = "Logs" Then
					ContinueLoop
				EndIf
				$fldr_attrib = FileGetAttrib($copy_path & $fldr_file)
				If StringInStr($fldr_attrib, "D") Then
					$folders = $folders + 1
				EndIf
			WEnd
			$drv_spc_calc = $folders * 8000
			$drv_spc_free = $drv_spc_free + $drv_spc_calc
		EndIf
		If $drv_spc_free < $drv_spc_need Then
			$drv_spc_free = $drv_spc_free / 1000
			$drv_spc_free = Round($drv_spc_free, 2)
			$drv_spc_need = $drv_spc_need / 1000
			MsgBox(48, "Insufficient Space", "You do not have enough disk space to copy all" & @CRLF & "         the Repair DVD's to your computer." & @CRLF & "" & @CRLF & " The required disk space is approximately " & $drv_spc_need & " GB." & @CRLF & @CRLF & "Please free up the necessary space on your hard             " & @CRLF & "                    disk (" & $dest_drv & ") and try again.")
			Call("ExitConfirm")
		EndIf
		;-----------------------------------------------------------------------------------------------------------------------------
		;-----------------------------------------------------------------------------------------------------------------------------
		$dvd_drv = DriveGetDrive("cdrom")
		$stop = 0
		$disk_in_drive = ""
		$loop_thru = 0
		While $stop = 0
			$iMsgBoxAnswer = MsgBox(1, "Insert DVD", "Please insert the disc labeled " & $set_desc_ini & " " & $dvd_num & " (" & $sk_add & $ssid_ini & ") into any DVD drive and click 'OK'.")
			$dvdget = 1
			Select
				Case $iMsgBoxAnswer = 2 ;Cancel
					Call("ExitConfirm")
				Case $iMsgBoxAnswer = 1 ;OK
					While $stop = 0
						If $dvd_num = $discs_in_set Then
							$stop = 1
						EndIf
						$prog_label_1 = ("Looking for " & $set_desc_ini & " " & $dvd_num & " (" & $sk_add & $ssid_ini & ") . . .")
						$prog_label_2 = ""
						GUICtrlSetState($Progress_meter, $GUI_DISABLE + $GUI_HIDE)
						GUICtrlSetData($prog_gui_text, $prog_label_1)
						GUICtrlSetData($percent_text, $prog_label_2)
						GUISetState(@SW_SHOW, $progress_gui)
						$attempt = 1
						Do
							If Not @error Then
								For $i = 1 To $dvd_drv[0]
									$status = DriveStatus($dvd_drv[$i])
									If $status <> ("READY") Then
										Sleep(2000)
										ContinueLoop
									EndIf
									If FileExists($dvd_drv[$i] & "\mitchell.txt") Then
										$disc_id_dvd = IniRead($dvd_drv[$i] & "\mitchell.txt", "MRIC", "DiscID", "1")
										$ssid_dvd = IniRead($dvd_drv[$i] & "\mitchell.txt", "DISC" & $disc_id_dvd, "SilkScreenID", "1")
										If $ssid_dvd = $ssid_ini Then
											Call("CopyStart")
											$copied = String("                       " & $set_desc_ini & " " & $dvd_num & " (" & $sk_add & $ssid_ini & ")" & @CRLF)
											If $copied = $error Then
												$copied = ""
												$error = ""
												GUISetState(@SW_HIDE, $error_gui)
											EndIf
											$copy_list = String($copy_list & $copied)
											$dvd_num = $dvd_num + 1
											$dvdget = $dvdget + 1
											$dvd_ltr = $dvd_ltr + 1
											$ssid_ini = StringTrimRight($ssid_ini & "", 1)
											$ssid_ini = $ssid_ini & Chr($dvd_ltr)
											$attempt = 10
											ExitLoop
										ElseIf $ssid_dvd <> $ssid_ini Then
											If $loop_thru = 10 Then
												For $i = 1 To $dvd_drv[0]
													If FileExists($dvd_drv[$i] & "\mitchell.txt") Then
														$disc_id_dvd = IniRead($dvd_drv[$i] & "\mitchell.txt", "MRIC", "DiscID", "1")
														$set_desc_dvd = IniRead($dvd_drv[$i] & "\mitchell.txt", "MRIC", "SetDescription", "1")
														$length_dvd = StringLen($set_desc_dvd) - 1
														$dvd_desc1 = StringTrimRight($set_desc_dvd, $length_dvd)
														$dvd_desc2 = StringTrimLeft($set_desc_dvd, 1)
														$dvd_desc2 = StringLower($dvd_desc2)
														$set_desc_dvd = String($dvd_desc1 & $dvd_desc2)
														$ssid_dvd = IniRead($dvd_drv[$i] & "\mitchell.txt", "DISC" & $disc_id_dvd, "SilkScreenID", "1")
														$disk_in_drive = String($disk_in_drive & @CRLF & "Drive " & $dvd_drv[$i] & " - " & $set_desc_dvd & " " & $disc_id_dvd & " (" & $ssid_dvd & ")")
													EndIf
												Next
												GUISetState(@SW_HIDE, $progress_gui)
												$attempt = $attempt + 1
												$iMsgBoxAnswer = MsgBox(1, "DVD Needed...", "Disk(s) currently in drive(s):" & $disk_in_drive & @CRLF & "Please insert the disc labeled Repair " & $dvd_num & " (" & $ssid_ini & ") into any DVD drive and click 'OK'.")
												$disk_in_drive = ""
												$loop_thru = 0
												Select
													Case $iMsgBoxAnswer = 1 ;OK
														$prog_label_1 = ("Looking for " & $set_desc_ini & " " & $dvd_num & " (" & $sk_add & $ssid_ini & ") . . .")
														$prog_label_2 = ""
														GUICtrlSetState($Progress_meter, $GUI_DISABLE + $GUI_HIDE)
														GUICtrlSetData($prog_gui_text, $prog_label_1)
														GUICtrlSetData($percent_text, $prog_label_2)
														GUISetState(@SW_SHOW, $progress_gui)
														ExitLoop
													Case $iMsgBoxAnswer = 2 ;Cancel
														Call("ExitConfirm")
												EndSelect
											Else
												$loop_thru = $loop_thru + 1
												Sleep(5000)
												ContinueLoop
											EndIf
										EndIf
									ElseIf Not FileExists($dvd_drv[$i] & "\mitchell.txt") Then
										$attempt = $attempt + 1
										ContinueLoop
									EndIf
								Next
							EndIf
						Until $attempt = 10
					WEnd
			EndSelect
		WEnd
		GUISetState(@SW_HIDE, $progress_gui)
		MsgBox(0, "Finished ! ! !", "Congratulations! The disc copy process is now complete." & @CRLF & "       The following discs were successfully copied: " & @CRLF & @CRLF & $copy_list & @CRLF & "  The Repair/Estimator program is now ready to use.")
		Exit
	Case $iMsgBoxAnswer = 2 ;Cancel
		Exit
EndSelect
;-----------------------------------------------------------------------------------------------------------------------------
Func CopyStart()
	If ProcessExists("robocopy.exe") Then
		$proc_wait = ""
		ProcessClose("robocopy.exe")
		$proc_wait = ProcessWaitClose("robocopy.exe", 10)
		If $proc_wait = 0 Then
			$copy_log_output = "The copy process command failed to terminate within the specified time." & @CRLF & @CRLF & "Please call Technical Support at (888) 724-6742 if the issue persists."
			GUICtrlSetData($error_text, @CRLF & $copy_log_output)
			GUISetState(@SW_SHOW, $error_gui)
			While 1
				If $error_send = 1 Then
					$error_send = ""
					$error = ("                       " & $set_desc_ini & " " & $dvd_num & " (" & $sk_add & $ssid_ini & ")" & @CRLF)
					ExitLoop
				Else
					Sleep(1000)
				EndIf
			WEnd
			Return
		EndIf
	EndIf
	GUISetState(@SW_HIDE, $error_gui)
	IniWrite(@WindowsDir & "\M1_Link.ini", "Action", "Receive", "")
	IniWrite(@WindowsDir & "\M1_Link.ini", "Action", "Return", "")
	IniWrite(@WindowsDir & "\M1_Link.ini", "DVD_ID", "SSID", $set_desc_ini & " " & $dvd_num & " (" & $sk_add & $ssid_ini & ")")
	IniWrite(@WindowsDir & "\M1_Link.ini", "Error", "Return", "None")
	GUISetState(@SW_HIDE, $progress_gui)
	Run(@WindowsDir & "\M1_Link.exe")
	$working = 0
	$loop_thru = 0
	$dest_size = 0
	$source_get_size = 0
	$source_size = 0
	$source_search = FileFindFirstFile($dvd_drv[$i] & "\*.*")
	If $source_search = -1 Then
		MsgBox(0, "Error", "No files/directories found in " & $dvd_drv[$i])
		Exit
	EndIf
	$proc_check = 0
	While 1
		$exit = IniRead(@WindowsDir & "\M1_Link.ini", "Action", "Return", "None")
		If $exit = "Exit" Then
			ProcessClose("M1_Link.exe")
			Call("ExitConfirm")
		EndIf
		$error_ret = IniRead(@WindowsDir & "\M1_Link.ini", "Error", "Return", "None")
		If Not $error_ret = "None" Then
			ProcessClose("M1_Link.exe")
			MsgBox(0, "Error", "The M1_Link.ini File returned the following error:" & @CRLF & @CRLF & $error_ret)
			Exit
		EndIf
		If Not ProcessExists("M1_Link.exe") Then
			Run(@WindowsDir & "\M1_Link.exe")
		EndIf
		$status = 0
		$status = DriveStatus($dvd_drv[$i])
		If $status <> ("READY") Then
			$prog_label_1 = "Please re-insert " & $set_desc_ini & " " & $dvd_num & " (" & $sk_add & $ssid_ini & ")"
			$prog_label_2 = "Waiting for DVD . . ."
			GUICtrlSetState($Progress_meter, $GUI_DISABLE + $GUI_HIDE)
			GUICtrlSetData($prog_gui_text, $prog_label_1)
			GUICtrlSetData($percent_text, $prog_label_2)
			GUISetState(@SW_SHOW, $progress_gui)
			ProcessClose("M1_Link.exe")
			While 1
				Sleep(1000)
				$status = DriveStatus($dvd_drv[$i])
				If $status = ("READY") And FileExists($dvd_drv[$i] & "\mitchell.txt") Then
					$disc_id_dvd = IniRead($dvd_drv[$i] & "\mitchell.txt", "MRIC", "DiscID", "1")
					$ssid_dvd = IniRead($dvd_drv[$i] & "\mitchell.txt", "DISC" & $disc_id_dvd, "SilkScreenID", "1")
					If $ssid_dvd = $ssid_ini Then
						Call("CopyStart")
					Else
						ContinueLoop
					EndIf
				EndIf
			WEnd
		EndIf
		$source_file = FileFindNextFile($source_search)
		If @error Then
			ExitLoop
		EndIf
		$source_attrib = FileGetAttrib($dvd_drv[$i] & "\" & $source_file)
		If @error = 1 Then
			$copy_log_output = "The attributes could not be retrieved from the following file/folder:" & @CRLF & $dvd_drv[$i] & "\" & $source_file & @CRLF & "The disc may be dirty or damaged. Please check the disc and try again."
			GUICtrlSetData($error_text, @CRLF & $copy_log_output)
			GUISetState(@SW_SHOW, $error_gui)
			ProcessClose("M1_Link.exe")
			While 1
				If $error_send = 1 Then
					$error_send = ""
					$error = ("                       " & $set_desc_ini & " " & $dvd_num & " (" & $sk_add & $ssid_ini & ")" & @CRLF)
					ExitLoop
				Else
					Sleep(1000)
				EndIf
			WEnd
			Return
		EndIf
		$error_pop = 0
		If StringInStr($source_attrib, "D") Then
			$source_get_size = DirGetSize($dvd_drv[$i] & "\" & $source_file)
			If @error = 1 Then $error_pop = 1
		Else
			$source_get_size = FileGetSize($dvd_drv[$i] & "\" & $source_file)
			If @error = 1 Then $error_pop = 1
		EndIf
		If $error_pop = 1 Then
			$error_pop = 0
			$copy_log_output = "The size could not be retrieved from the following file/folder:" & @CRLF & $dvd_drv[$i] & "\" & $source_file & @CRLF & "The disc may be dirty or damaged. Please check the disc and try again."
			GUICtrlSetData($error_text, @CRLF & $copy_log_output)
			GUISetState(@SW_SHOW, $error_gui)
			ProcessClose("M1_Link.exe")
			While 1
				If $error_send = 1 Then
					$error_send = ""
					$error = ("                       " & $set_desc_ini & " " & $dvd_num & " (" & $sk_add & $ssid_ini & ")" & @CRLF)
					ExitLoop
				Else
					Sleep(1000)
				EndIf
			WEnd
			Return
		EndIf
		$source_size = $source_size + $source_get_size
	WEnd
	FileClose($source_search)
	IniWrite(@WindowsDir & "\M1_Link.ini", "Action", "Receive", "Close")
	Sleep(1400)
	$copy_log_file = String($copy_log_path & $dvd_num & ".log")
	If Not FileExists($copy_path) Then
		DirCreate($copy_path)
	EndIf
	If Not FileExists($copy_log_path) Then
		DirCreate($copy_log_path)
	EndIf
	If FileExists($copy_path & $dvd_num) Then
		$prog_label_1 = ("Updating to " & $set_desc_ini & " " & $dvd_num & " (" & $sk_add & $ssid_ini & ")")
		$prog_label_2 = "Please Wait . . ."
		GUICtrlSetState($Progress_meter, $GUI_ENABLE + $GUI_SHOW)
		GUICtrlSetData($prog_gui_text, $prog_label_1)
		GUICtrlSetData($percent_text, $prog_label_2)
		GUISetState(@SW_SHOW, $progress_gui)
		$update = 1
	Else
		$copy_progress2 = 0
		$prog_label_1 = ("Copying " & $set_desc_ini & " " & $dvd_num & " (" & $sk_add & $ssid_ini & ")")
		GUICtrlSetState($Progress_meter, $GUI_ENABLE + $GUI_SHOW)
		GUICtrlSetData($prog_gui_text, $prog_label_1)
		GUICtrlSetData($percent_text, $copy_progress2 & " %")
		GUISetState(@SW_SHOW, $progress_gui)
		$update = 0
	EndIf
	Run("robocopy " & $dvd_drv[$i] & " " & $copy_path & $dvd_num & " /MIR /NC /NJH /NJS /NS /NP /LOG:" & $copy_log_file, "", @SW_HIDE)
	$wait = ProcessWait("robocopy.exe", 10)
	If $wait = 0 Then
		$wait = ""
		Run(@ComSpec & " /c " & "robocopy " & $dvd_drv[$i] & " " & $copy_path & $dvd_num & " /MIR /NC /NJH /NJS /NS /NP /LOG:" & $copy_log_file, "", @SW_HIDE)
		$wait = ProcessWait("robocopy.exe", 10)
		If $wait = 0 Then
			GUISetState(@SW_HIDE, $progress_gui)
			MsgBox(0, "Error", "The copy command timed out.")
			Exit
		EndIf
	EndIf
	Select
		Case $update = 0
			$x = 0
			While 1
				$status = 0
				$status = DriveStatus($dvd_drv[$i])
				If $status <> ("READY") Then
					$prog_label_1 = "Please re-insert " & $set_desc_ini & " " & $dvd_num & " (" & $sk_add & $ssid_ini & ")"
					$prog_label_2 = "Waiting for DVD . . ."
					GUICtrlSetState($Progress_meter, $GUI_DISABLE + $GUI_HIDE)
					GUICtrlSetData($prog_gui_text, $prog_label_1)
					GUICtrlSetData($percent_text, $prog_label_2)
					While 1
						Sleep(1000)
						$status = DriveStatus($dvd_drv[$i])
						If $status = ("READY") And FileExists($dvd_drv[$i] & "\mitchell.txt") Then
							$disc_id_dvd = IniRead($dvd_drv[$i] & "\mitchell.txt", "MRIC", "DiscID", "1")
							$ssid_dvd = IniRead($dvd_drv[$i] & "\mitchell.txt", "DISC" & $disc_id_dvd, "SilkScreenID", "1")
							If $ssid_dvd = $ssid_ini Then
								$prog_label_1 = ("Copying " & $set_desc_ini & " " & $dvd_num & " (" & $sk_add & $ssid_ini & ")")
								GUICtrlSetState($Progress_meter, $GUI_ENABLE + $GUI_SHOW)
								GUICtrlSetData($prog_gui_text, $prog_label_1)
								GUICtrlSetData($Progress_meter, $copy_progress2)
								GUICtrlSetData($percent_text, $copy_progress2 & " %")
								GUISetState(@SW_SHOW, $progress_gui)
								ExitLoop
							Else
								ContinueLoop
							EndIf
						EndIf
					WEnd
				EndIf
				$dest_size = DirGetSize($copy_path & $dvd_num)
				$progress_calc = $dest_size * 100
				$copy_progress = $progress_calc / $source_size
				$copy_progress2 = Int($copy_progress)
				$ctrl_state = GUICtrlGetState($Progress_meter)
				GUICtrlSetData($Progress_meter, $copy_progress2)
				GUICtrlSetData($percent_text, $copy_progress2 & " %")
				If $copy_progress = 100 Then
					If $ctrl_state = 160 Then
						$prog_label_1 = ("Copying " & $set_desc_ini & " " & $dvd_num & " (" & $sk_add & $ssid_ini & ")")
						GUICtrlSetState($Progress_meter, $GUI_ENABLE + $GUI_SHOW)
						GUICtrlSetData($prog_gui_text, $prog_label_1)
						GUICtrlSetData($Progress_meter, $copy_progress2)
						GUICtrlSetData($percent_text, $copy_progress2 & " %")
						GUISetState(@SW_SHOW, $progress_gui)
					EndIf
					GUICtrlSetData($prog_gui_text, $set_desc_ini & " " & $dvd_num & " Copied Successfully!")
					GUICtrlSetData($Progress_meter, $copy_progress2)
					GUICtrlSetData($percent_text, "Complete")
					IniDelete(@WindowsDir & "\" & $apptype & ".ini", "ODM", "Disc_" & $dvd_num)
					IniWrite(@WindowsDir & "\" & $apptype & ".ini", "ODM", "Disc_" & $dvd_num, $copy_path & $dvd_num)
					Sleep(2000)
					ExitLoop
				Else
					$x = $x + 1
					If $x = 1 Then
						$copy_check = $copy_progress
					EndIf
					$ctrl_state = GUICtrlGetState($Progress_meter)
					If $ctrl_state = 160 Then
						$prog_label_1 = ("Copying " & $set_desc_ini & " " & $dvd_num & " (" & $sk_add & $ssid_ini & ")")
						GUICtrlSetState($Progress_meter, $GUI_ENABLE + $GUI_SHOW)
						GUICtrlSetData($prog_gui_text, $prog_label_1)
						GUICtrlSetData($Progress_meter, $copy_progress2)
						GUICtrlSetData($percent_text, $copy_progress2 & " %")
						GUISetState(@SW_SHOW, $progress_gui)
					EndIf
					Sleep(4000)
					If $x = 25 And $copy_progress = $copy_check Then
						MsgBox(0, "Error Log Opened", "", 10)
						$copy_log_open = FileOpen($copy_log_file, 0)
						If $copy_log_open = -1 Then
							GUISetState(@SW_HIDE, $progress_gui)
							MsgBox(0, "Error", "Unable to open log file.")
							Exit
						EndIf
						While 1
							$copy_log_0 = String($copy_log_1)
							$copy_log_1 = String($copy_log_2)
							$copy_log_2 = String($copy_log_3)
							$copy_log_3 = FileReadLine($copy_log_open)
							If @error = -1 Then
								$string_len = StringLen($copy_log_0)
								$string_trim = $string_len - 4
								$digit = StringTrimRight($copy_log_0, $string_trim)
								$digit_check = StringIsDigit($digit)
								If $digit_check = 1 Then
									ExitLoop
								Else
									FileClose($copy_log_open)
									$copy_log_open = FileOpen($copy_log_file, 0)
									If $copy_log_open = -1 Then
										GUISetState(@SW_HIDE, $progress_gui)
										MsgBox(0, "Error", "Unable to open log file.")
										Exit
									EndIf
									ContinueLoop
								EndIf
							EndIf
							$copy_log_3 = StringStripCR($copy_log_3)
							If $copy_log_3 = "" Then
								$copy_log_3 = FileReadLine($copy_log_open)
								ContinueLoop
							EndIf
						WEnd
						FileClose($copy_log_open)
						$copy_log_0 = StringTrimLeft($copy_log_0, 20)
						$copy_log_0 = StringReplace($copy_log_0, "ERROR", "Error",1 ,1)
						$code_start = StringInStr($copy_log_0, "(")
						If Not $code_start = 0 Then
							$code_start = $code_start - 1
							$code_end = StringInStr($copy_log_0, ")")
							$log_len = StringLen($copy_log_0)
							$trim = $log_len - $code_start
							$log_temp_1 = StringTrimRight($copy_log_0, $trim)
							$log_temp_2 = StringTrimLeft($copy_log_0, $code_end)
							$copy_log_0 = $log_temp_1 & ":" & $log_temp_2
						EndIf
						$copy_log_output = String($copy_log_0 & @CRLF & $copy_log_1 & @CRLF & $copy_log_2)
						If Not StringInStr($copy_log_output, "Waiting 30 Seconds") Then
							MsgBox(0, "Error Skipped", "", 10)
							$error_check = 0
							ContinueLoop
						EndIf
						$copy_log_output = String($copy_log_0 & @CRLF & @CRLF & $copy_log_1)
						GUISetState(@SW_HIDE, $progress_gui)
						GUICtrlSetData($error_text, @CRLF & $copy_log_output)
						GUISetState(@SW_SHOW, $error_gui)
						While 1
							If $error_send = 1 Then
								$error_send = ""
								$error = ("                       " & $set_desc_ini & " " & $dvd_num & " (" & $sk_add & $ssid_ini & ")" & @CRLF)
								ExitLoop
							Else
								Sleep(1000)
							EndIf							
						WEnd
						ExitLoop
					Else
						$x = 0
					EndIf
				EndIf
			WEnd
		Case $update = 1
			GUISetState(@SW_SHOW, $progress_gui)
			$error_check = 0
			While 1
				If ProcessExists("robocopy.exe") Then
					$error_check = $error_check + 1
					$status = 0
					$status = DriveStatus($dvd_drv[$i])
					If $status <> ("READY") Then
						$prog_label_1 = "Please re-insert " & $set_desc_ini & " " & $dvd_num & " (" & $sk_add & $ssid_ini & ")"
						$prog_label_2 = "Waiting for DVD . . ."
						GUICtrlSetState($Progress_meter, $GUI_DISABLE + $GUI_HIDE)
						GUICtrlSetData($prog_gui_text, $prog_label_1)
						GUICtrlSetData($percent_text, $prog_label_2)
						GUISetState(@SW_SHOW, $progress_gui)
						While 1
							Sleep(1000)
							$status = DriveStatus($dvd_drv[$i])
							If $status = ("READY") And FileExists($dvd_drv[$i] & "\mitchell.txt") Then
								$disc_id_dvd = IniRead($dvd_drv[$i] & "\mitchell.txt", "MRIC", "DiscID", "1")
								$ssid_dvd = IniRead($dvd_drv[$i] & "\mitchell.txt", "DISC" & $disc_id_dvd, "SilkScreenID", "1")
								If $ssid_dvd = $ssid_ini Then
									$prog_label_1 = ("Updating to " & $set_desc_ini & " " & $dvd_num & " (" & $sk_add & $ssid_ini & ")")
									GUICtrlSetState($Progress_meter, $GUI_ENABLE + $GUI_SHOW)
									GUICtrlSetData($prog_gui_text, $prog_label_1)
									GUICtrlSetData($Progress_meter, $working)
									GUICtrlSetData($percent_text, "Please Wait . . .")
									GUISetState(@SW_SHOW, $progress_gui)
									ExitLoop
								Else
									ContinueLoop
								EndIf
							EndIf
						WEnd
					EndIf
					If Not StringInStr($prog_label_1, "Updating") Then
						$prog_label_1 = ("Updating to " & $set_desc_ini & " " & $dvd_num & " (" & $sk_add & $ssid_ini & ")")
						GUICtrlSetState($Progress_meter, $GUI_ENABLE + $GUI_SHOW)
						GUICtrlSetData($prog_gui_text, $prog_label_1)
						GUICtrlSetData($Progress_meter, $working)
						GUICtrlSetData($percent_text, "Please Wait . . .")
						GUISetState(@SW_SHOW, $progress_gui)
					EndIf
					For $working = 0 To 100 Step 10
						GUICtrlSetData($Progress_meter, $working)
						GUISetState(@SW_SHOW, $progress_gui)
						Sleep(100)
					Next
					If $error_check = 150 Then
;~ 						MsgBox(0, "Error Log Opened", "", 10)
						$copy_log_open = FileOpen($copy_log_file, 0)
						If $copy_log_open = -1 Then
							GUISetState(@SW_HIDE, $progress_gui)
							MsgBox(0, "Error", "Unable to open log file.")
							Exit
						EndIf
						While 1
							$copy_log_0 = String($copy_log_1)
							$copy_log_1 = String($copy_log_2)
							$copy_log_2 = String($copy_log_3)
							$copy_log_3 = FileReadLine($copy_log_open)
							If @error = -1 Then
								$string_len = StringLen($copy_log_0)
								$string_trim = $string_len - 4
								$digit = StringTrimRight($copy_log_0, $string_trim)
								$digit_check = StringIsDigit($digit)
								If $digit_check = 1 Then
									ExitLoop
								Else
									FileClose($copy_log_open)
									$copy_log_open = FileOpen($copy_log_file, 0)
									If $copy_log_open = -1 Then
										GUISetState(@SW_HIDE, $progress_gui)
										MsgBox(0, "Error", "Unable to open log file.")
										Exit
									EndIf
									ContinueLoop
								EndIf
							EndIf
							$copy_log_3 = StringStripCR($copy_log_3)
							If $copy_log_3 = "" Then
								$copy_log_3 = FileReadLine($copy_log_open)
								ContinueLoop
							EndIf
						WEnd
						FileClose($copy_log_open)
						$copy_log_0 = StringTrimLeft($copy_log_0, 20)
						$copy_log_0 = StringReplace($copy_log_0, "ERROR", "Error",1 ,1)
						$code_start = StringInStr($copy_log_0, "(")
						If Not $code_start = 0 Then
							$code_start = $code_start - 1
							$code_end = StringInStr($copy_log_0, ")")
							$log_len = StringLen($copy_log_0)
							$trim = $log_len - $code_start
							$log_temp_1 = StringTrimRight($copy_log_0, $trim)
							$log_temp_2 = StringTrimLeft($copy_log_0, $code_end)
							$copy_log_0 = $log_temp_1 & ":" & $log_temp_2
						EndIf
						$copy_log_output = String($copy_log_0 & @CRLF & $copy_log_1 & @CRLF & $copy_log_2)
						If Not StringInStr($copy_log_output, "Waiting 30 Seconds") Then
;~ 							MsgBox(0, "Error Skipped", "", 10)
							$error_check = 0
							ContinueLoop
						EndIf
						$copy_log_output = String($copy_log_0 & @CRLF & @CRLF & $copy_log_1)
						GUISetState(@SW_HIDE, $progress_gui)
						GUICtrlSetData($error_text, @CRLF & $copy_log_output)
						GUISetState(@SW_SHOW, $error_gui)
						While 1
							If $error_send = 1 Then
								$error_send = ""
								$error = ("                       " & $set_desc_ini & " " & $dvd_num & " (" & $sk_add & $ssid_ini & ")" & @CRLF)
								ExitLoop
							Else
								Sleep(1000)
							EndIf
						WEnd
						ExitLoop
					EndIf
				ElseIf Not ProcessExists("robocopy.exe") Then
					Sleep(5000)
					If Not ProcessExists("robocopy.exe") Then
						$dest_size = DirGetSize($copy_path & $dvd_num)
						If $source_size = $dest_size Then
							$prog_label_1 = ($set_desc_ini & " " & $dvd_num & " Updated Successfully!")
							GUICtrlSetState($Progress_meter, $GUI_ENABLE + $GUI_SHOW)
							GUICtrlSetData($prog_gui_text, $prog_label_1)
							GUICtrlSetData($Progress_meter, 100)
							GUICtrlSetData($percent_text, "Complete!")
							GUISetState(@SW_SHOW, $progress_gui)
							IniDelete(@WindowsDir & "\" & $apptype & ".ini", "ODM", "Disc_" & $dvd_num)
							IniWrite(@WindowsDir & "\" & $apptype & ".ini", "ODM", "Disc_" & $dvd_num, $copy_path & $dvd_num)
							Sleep(2000)
							ExitLoop
						Else
							GUISetState(@SW_HIDE, $progress_gui)
							$copy_log_output = @CRLF & "The source size does not match the destination size."
							GUICtrlSetData($error_text, $copy_log_output)
							GUISetState(@SW_SHOW, $error_gui)
							While 1
								If $error_send = 1 Then
									$error_send = ""
									$error = String("                       " & $set_desc_ini & " " & $dvd_num & " (" & $sk_add & $ssid_ini & ")" & @CRLF)
									ExitLoop
								Else
								Sleep(1000)
							EndIf
							WEnd
							ExitLoop
						EndIf
					EndIf
				EndIf
			WEnd
	EndSelect
	Return
EndFunc   ;==>CopyStart
;-----------------------------------------------------------------------------------------------------------------------------
Func RestartCopy()
	Call("CopyStart")
EndFunc   ;==>RestartCopy
;-----------------------------------------------------------------------------------------------------------------------------
Func ErrorSend()
	$error_send = 1
EndFunc   ;==>ErrorSend
;-----------------------------------------------------------------------------------------------------------------------------
Func ExitConfirm1()
	GUISetState(@SW_HIDE, $progress_gui)
	$ExitConfirm = MsgBox(292, "Quit?", "              Are you sure you want to Quit?" & @CRLF & @CRLF & $warning & "   W A R N I N G   " & $warning & "              " & @CRLF & @CRLF & "  Ending the copy process now will require you to   " & @CRLF & "repeat the entire copy process from the beginning.")
	Select
		Case $ExitConfirm = 6 ;Yes
			While 1
				If ProcessExists("robocopy.exe") Then
					ProcessClose("robocopy.exe")
					ProcessWaitClose("robocopy.exe")
				Else
					ExitLoop
				EndIf
			WEnd
			Exit
		Case $ExitConfirm = 7 ;No
			GUISetState(@SW_SHOW, $progress_gui)
			Return
	EndSelect
EndFunc   ;==>ExitConfirm
;-----------------------------------------------------------------------------------------------------------------------------
Func ExitConfirm2()
	GUISetState(@SW_HIDE, $error_gui)
	$ExitConfirm = MsgBox(292, "Quit?", "              Are you sure you want to Quit?" & @CRLF & @CRLF & $warning & "   W A R N I N G   " & $warning & "              " & @CRLF & @CRLF & "  Ending the copy process now will require you to   " & @CRLF & "repeat the entire copy process from the beginning.")
	Select
		Case $ExitConfirm = 6 ;Yes
			While 1
				If ProcessExists("robocopy.exe") Then
					ProcessClose("robocopy.exe")
					ProcessWaitClose("robocopy.exe")
				Else
					ExitLoop
				EndIf
			WEnd
			Exit
		Case $ExitConfirm = 7 ;No
			GUISetState(@SW_SHOW, $error_gui)
			Return
	EndSelect
EndFunc   ;==>ExitConfirm
;-----------------------------------------------------------------------------------------------------------------------------
#Region Compiler directives section
;** This is a list of compiler directives used by CompileAU3.exe.
;** comment the lines you don't need or else it will override the default settings
#Compiler_Prompt=y															;y=show compile menu
;#Compiler_AUTOIT3=         											    ;Override the default Interpreter with this version.
;#Compiler_AUT2EXE=															;Override the default compiler with this version.
#Compiler_Icon=C:\Documents and Settings\Administrator\Desktop\Transfer\Dminion\M1 DVD\Graphics\DVD Logo Icon.ico    ;Filename of the Ico file to use
#Compiler_OutFile=C:\Documents and Settings\Administrator\Desktop\Transfer\Dminion\M1 DVD\Exe's\M1 DVD.exe			 ;Target exe filename.
#Compiler_Compression=2														;Compression parameter 0-4  0=Low 2=normal 4=High
#Compiler_Allow_Decompile=n													;y= allow decompile
;#Compiler_PassPhrase=														;Password to use for compilation;** Target program Resource info
#Compiler_Res_Comment=MRIC													;Comment field
#Compiler_Res_Description=Mitchell1 DVD Utility								;Description field
#Compiler_Res_Fileversion=2.9.06.0											;File Version
#Compiler_Res_LegalCopyright=MRIC © 2006									;Copyright field; free form resource fields ... max 15
;#Compiler_Res_Field=Name|Value												;Free format fieldname|fieldvalue
;#Compiler_Res_Field=Name|Value												;Free format fieldname|fieldvalue
;#Compiler_Res_Field=Name|Value												;Free format fieldname|fieldvalue
;#Compiler_Res_Field=Name|Value												;Free format fieldname|fieldvalue
#Compiler_Run_AU3Check=y													;Run au3check before compilation
;#Compiler_AU3Check_Dat=													;Override the default AU3Check Definition file used when running Beta etc.
; The following directives can contain:
;   %in% , %out%, %icon% which will be replaced by the fullpath\filename.
;   %scriptdir% same as @ScriptDir and %scriptfile% = filename without extension.
;#Compiler_Run_Before=														;process to run before compilation - you can have multiple records that will be processed in sequence
;#Compiler_Run_After=														;process to run After compilation - you can have multiple records that will be processed in sequence
#EndRegion