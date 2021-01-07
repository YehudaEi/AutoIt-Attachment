opt("RunErrorsFatal", 0)

Dim $iMsgBoxAnswer, $apptype, $sequence_ini, $dvd_drv = DriveGetDrive("cdrom"), $i, $x, $dest_drv, $winver = @OSVersion
Dim $copy_log, $stop, $dvd_num = 1, $dvd_ltr = 65, $ssid_ini, $ssid_dvd, $set_desc_dvd, $length_dvd, $dvd_desc1, $dvd_desc2
Dim $sk_add, $loop_thru = 1, $disc_in_drive, $set_desc_ini, $length_ini, $ini_desc1, $ini_desc2, $copy_path, $status, $error_check
Dim $copy_log_path, $copy_log_file, $copy_log_output, $copy_log_1, $copy_log_2, $copy_log_3, $copy_log_open, $copy_list, $copy_progress
Dim $update, $update_error, $working = String(" . . ."), $attempt = 0, $dest_size, $source_get_size, $source_size, $source_file, $source_attrib
Dim $source_search, $disk_in_drive, $error, $copy_check

#include <Process.au3>
;-----------------------------------------------------------------------------------------------------------------------------
HotKeySet("{ESC}", "ExitConfirm")
;-----------------------------------------------------------------------------------------------------------------------------
;~ ;Beta Version Splash Screen.
;~ ;-----------------------------------------------------------------------------------------------------------------------------
;~ $destination = @TempDir & "\BetaSplash.jpg"
;~ FileInstall("C:\Documents and Settings\Administrator\Desktop\BetaSplash.jpg", $destination)  ;source must be literal string
;~ SplashImageOn("Beta Splash", $destination, 300, 200, -1, -1, 1)
;~ Sleep(4000)
;~ SplashOff()
;-----------------------------------------------------------------------------------------------------------------------------
;Final Version Splash Screen.
;-----------------------------------------------------------------------------------------------------------------------------
$destination = @TempDir & "\FinalSplash.jpg"
FileInstall("C:\Documents and Settings\Administrator\Desktop\FinalSplash.jpg", $destination)  ;source must be literal string
SplashImageOn("Final Splash", $destination, 300, 90, -1, -1, 1)
Sleep(4000)
SplashOff()
;-----------------------------------------------------------------------------------------------------------------------------
;Verify windows version, Rep/Est installed, data added, backup ini file and store all ini variables.
;-----------------------------------------------------------------------------------------------------------------------------
$iMsgBoxAnswer = MsgBox(262145, "Disc Copy Utility", "  This utility will copy the Repair DVD's to your computer." & @CRLF & " If you have recently received a software update, please" & @CRLF & "cancel this utility and follow the update instructions before" & @CRLF & "   using this utility. Click 'OK' to begin or 'Cancel' to exit.")
Select
	Case $iMsgBoxAnswer = 1 ;OK
		If FileExists(@WindowsDir & "\od5.ini") Then
			$apptype = String("od5")
		ElseIf FileExists(@WindowsDir & "\sk5.ini") Then
			$apptype = String("sk5")
			$sk_add = String("SK")
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
		$sequence_ini = IniRead($shared_path & "\shared.ini", "ODM", "SequenceNumber", "1")
		If $sequence_ini = 1 Then
			MsgBox(262160, "Error", "     The shared.ini file could not be found.       " & @CRLF & "Please reinstall the program or call technical support" & @CRLF & "             at 1-888-724-6742 for assistance.")
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
		If $apptype = String("od5") Then
			$copy_path = StringReplace($shared_path, "\OnDemand5\Shared", "\Repair\")
			$copy_log_path = StringReplace($shared_path, "\OnDemand5\Shared", "\Repair\Logs\")
		EndIf
		If $apptype = String("sk5") Then
			$copy_path = StringReplace($shared_path, "\ShopKey5\Shared", "\Repair\")
			$copy_log_path = StringReplace($shared_path, "\ShopKey5\Shared", "\Repair\Logs\")
		EndIf
		;-----------------------------------------------------------------------------------------------------------------------------
		;-----------------------------------------------------------------------------------------------------------------------------
		If $winver = ("WIN_2003") or ("WIN_XP") or ("WIN_2000") or ("WIN_NT4") Then
			FileInstall("C:\windows\robocopy.exe", @WindowsDir & "\robocopy.exe")
			$copyproc1 = String("robocopy")
		Else
			$copyproc1 = String("xcopy")
		EndIf
		;-----------------------------------------------------------------------------------------------------------------------------
		$stop = 0
		$disk_in_drive = ""
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
						SplashTextOn("", "" & @CRLF & "Looking for " & $set_desc_ini & " " & $dvd_num & " (" & $sk_add & $ssid_ini & ") . . .", "325", "50", "-1", "-1", 1, "", "10", "700")
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
											SplashOff()
											Call("CopyStart")
											$copied = String("                       " & $set_desc_ini & " " & $dvd_num & " (" & $sk_add & $ssid_ini & ")" & @CRLF)
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
												SplashOff()
												$attempt = $attempt + 1
												$iMsgBoxAnswer = MsgBox(1, "DVD Needed...", "Disk(s) currently in drive(s):" & $disk_in_drive & @CRLF & "Please insert the disc labeled Repair " & $dvd_num & " (" & $ssid_ini & ") into any DVD drive and click 'OK'.")
												$disk_in_drive = ""
												Select
													Case $iMsgBoxAnswer = 1 ;OK
														SplashTextOn("", "" & @CRLF & "Looking for " & $set_desc_ini & " " & $dvd_num & " (" & $sk_add & $ssid_ini & ") . . .", "325", "50", "-1", "-1", 1, "", "10", "700")
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
		SplashOff()
		MsgBox(0, "Finished ! ! !", "Congratulations! The disc copy process is now complete." & @CRLF & "       The following discs were successfully copied: " & @CRLF & @CRLF & $copy_list & @CRLF & "  The Repair/Estimator program is now ready to use.")
		Exit
		
	Case $iMsgBoxAnswer = 2 ;Cancel
		Call("ExitConfirm")
		
EndSelect
;-----------------------------------------------------------------------------------------------------------------------------
Func ExitConfirm()
	SplashOff()
	ProgressOff()
	$ExitConfirm = MsgBox(36, "Exit?", "Are you sure you want to exit?              ")
	Select
		Case $ExitConfirm = 6 ;Yes
			While 1
				If ProcessExists("robocopy.exe") Then
					ProcessClose("robocopy.exe")
					Sleep(3000)
				Else
					ExitLoop
				EndIf
			WEnd
			While 1
				If ProcessExists("xcopy.exe") Then
					ProcessClose("xcopy.exe")
					Sleep(3000)
				Else
					ExitLoop
				EndIf
			WEnd
			Exit
		Case $ExitConfirm = 7 ;No
			Return
	EndSelect
EndFunc   ;==>ExitConfirm
;-----------------------------------------------------------------------------------------------------------------------------
Func CopyStart()
	SplashTextOn("Processing", @CRLF & "Processing . . .", "325", "50", "-1", "-1", 1, "", "10", "700")
	$dest_size = 0
	$source_get_size = 0
	$source_size = 0
	$source_search = FileFindFirstFile($dvd_drv[$i] & "\*.*")
	If $source_search = -1 Then
		MsgBox(0, "Error", "No files/directories found in " & $dvd_drv[$i])
		Exit
	EndIf
	While 1
		$source_file = FileFindNextFile($source_search)
		If @error Then
			ExitLoop
		EndIf
		$source_attrib = FileGetAttrib($dvd_drv[$i] & "\" & $source_file)
		If StringInStr($source_attrib, "D") Then
			$source_get_size = DirGetSize($dvd_drv[$i] & "\" & $source_file)
		Else
			$source_get_size = FileGetSize($dvd_drv[$i] & "\" & $source_file)
		EndIf
		$source_size = $source_size + $source_get_size
;~ 	MsgBox(4096, "Disc Size", "File/Folder: " & $source_file & @CRLF & "File/Folder Size: " & $source_get_size & @CRLF & "Total Size: " & $source_size)
	WEnd
	$copy_log_file = String($copy_log_path & $dvd_num & ".log")
	$copyproc2 = String(" " & $dvd_drv[$i] & " " & $copy_path & $dvd_num)
	If $copyproc1 = String("robocopy") Then
		$copyproc3 = String(" /MIR /NC /NJH /NJS /NS /NP /LOG:" & $copy_log_file)
	Else
		$copyproc3 = String(" \s\i\r\y >" & $copy_log_file)
	EndIf
	$copy_process = String($copyproc1 & $copyproc2 & $copyproc3)
	If Not FileExists($copy_path) Then
		DirCreate($copy_path)
	EndIf
	If Not FileExists($copy_log_path) Then
		DirCreate($copy_log_path)
	EndIf
	If FileExists($copy_path & $dvd_num) And $copyproc1 = String("robocopy") Then
		SplashOff()
		SplashTextOn("Updating", @CRLF & "Updating data to " & $set_desc_ini & " " & $dvd_num & " (" & $sk_add & $ssid_ini & ")" & $working, "325", "50", "-1", "-1", 1, "", "10", "700")
		$update = 1
	Else
		DirRemove($copy_path & $dvd_num, 1)
		SplashOff()
		ProgressOn("Copying", "Copying " & $set_desc_ini & " " & $dvd_num & " (" & $sk_add & $ssid_ini & ") . . .", "0 %")
		$update = 0
	EndIf
;~ 	MsgBox(0,"Output", $copy_process)
	Run($copy_process, "", @SW_HIDE)
	Sleep(5000)
	If Not ProcessExists($copyproc1 & ".exe") Then
		MsgBox(0, "Error", "The Command Failed")
		Exit
	EndIf
	Select
		Case $update = 0
			$x = 0
			While 1
				$dest_size = DirGetSize($copy_path & $dvd_num)
				$progress_calc = $dest_size * 100
				$copy_progress = $progress_calc / $source_size
				$copy_progress = Int($copy_progress)
				If $copy_progress = 100 Then
					ProgressSet($copy_progress, "(" & $sk_add & $ssid_ini & ") Complete!", $set_desc_ini & " " & $dvd_num & " Copied Successfully!")
					IniDelete(@WindowsDir & "\" & $apptype & ".ini", "ODM", "Disc_" & $dvd_num)
					IniWrite(@WindowsDir & "\" & $apptype & ".ini", "ODM", "Disc_" & $dvd_num, $copy_path & $dvd_num)
					Sleep(2000)
					ProgressOff()
					ExitLoop
				Else
					$x = $x + 1
					If $x = 1 Then
						$copy_check = $copy_progress
					EndIf
					ProgressSet($copy_progress, $copy_progress & " %", "Copying " & $set_desc_ini & " " & $dvd_num & " (" & $sk_add & $ssid_ini & ") . . .")
					If $x = 1000 Then
						If $copy_progress = $copy_check Then
							$copy_log_open = FileOpen($copy_log_file, 0)
							If $copy_log_open = -1 Then
								ProgressOff()
								MsgBox(0, "Error", "Unable to open log file.")
								Exit
							EndIf
							While 1
								$copy_log_1 = String($copy_log_2)
								$copy_log_2 = String($copy_log_3)
								$copy_log_3 = FileReadLine($copy_log_open)
								If @error = -1 Then
									ExitLoop
								EndIf
								$copy_log_output = String($copy_log_1 & @CRLF & $copy_log_2 & @CRLF & $copy_log_3)
							WEnd
							FileClose($copy_log_open)
							ProgressOff()
							$update_error = MsgBox(53, "Error", "       The following errors have been detected:" & @CRLF & "" & @CRLF & $copy_log_output & @CRLF & "" & @CRLF & "To attempt to continue the copy process, click 'Retry'                  " & @CRLF & "                      or click 'Cancel' to exit.")
							Select
								Case $update_error = 4 ;Retry
									Call("CopyContinue")
								Case $update_error = 2 ;Cancel
									Call("ExitConfirm")
							EndSelect
						Else
							$x = 0
						EndIf
					EndIf
				EndIf
			WEnd
			ProgressOff()
		Case $update = 1
			$error_check = 0
			While 1
				If ProcessExists($copyproc1 & ".exe") Then
					$error_check = $error_check + 1
					$working = String("      ")
					ControlSetText("Updating", "", "Static1", @CRLF & "Updating data to " & $set_desc_ini & " " & $dvd_num & " (" & $sk_add & $ssid_ini & ")" & $working)
					Sleep(500)
					$working = String(" .    ")
					ControlSetText("Updating", "", "Static1", @CRLF & "Updating data to " & $set_desc_ini & " " & $dvd_num & " (" & $sk_add & $ssid_ini & ")" & $working)
					Sleep(500)
					$working = String(" . .  ")
					ControlSetText("Updating", "", "Static1", @CRLF & "Updating data to " & $set_desc_ini & " " & $dvd_num & " (" & $sk_add & $ssid_ini & ")" & $working)
					Sleep(500)
					$working = String(" . . .")
					ControlSetText("Updating", "", "Static1", @CRLF & "Updating data to " & $set_desc_ini & " " & $dvd_num & " (" & $sk_add & $ssid_ini & ")" & $working)
					Sleep(500)
					If $error_check = 600 Then
						$copy_log_open = FileOpen($copy_log_file, 0)
						If $copy_log_open = -1 Then
							SplashOff()
							MsgBox(0, "Error", "Unable to open log file.")
							Exit
						EndIf
						While 1
							$copy_log_1 = String($copy_log_2)
							$copy_log_2 = String($copy_log_3)
							$copy_log_3 = FileReadLine($copy_log_open)
							If @error = -1 Then
								ExitLoop
							EndIf
							$copy_log_output = String($copy_log_1 & @CRLF & $copy_log_2 & @CRLF & $copy_log_3)
						WEnd
						FileClose($copy_log_open)
						SplashOff()
						$update_error = MsgBox(53, "Error", "       The following errors have been detected:" & @CRLF & "" & @CRLF & $copy_log_output & @CRLF & "" & @CRLF & "To attempt to continue the copy process, click 'Retry'                  " & @CRLF & "                      or click 'Cancel' to exit.")
						Select
							Case $update_error = 4 ;Retry
								$error = 1
								Call("RestartCopy")
							Case $update_error = 2 ;Cancel
								Call("ExitConfirm")
						EndSelect
					EndIf
				ElseIf Not ProcessExists($copyproc1 & ".exe") Then
					Sleep(5000)
					If Not ProcessExists($copyproc1 & ".exe") Then
						$dest_size = DirGetSize($copy_path & $dvd_num)
						If $source_size = $dest_size Then
							ControlSetText("Updating", "", "Static1", @CRLF & "Successfully Updated " & $set_desc_ini & " " & $dvd_num & " (" & $sk_add & $ssid_ini & ")")
							IniDelete(@WindowsDir & "\" & $apptype & ".ini", "ODM", "Disc_" & $dvd_num)
							IniWrite(@WindowsDir & "\" & $apptype & ".ini", "ODM", "Disc_" & $dvd_num, $copy_path & $dvd_num)
							Sleep(2000)
							SplashOff()
							ExitLoop
						Else
							SplashOff()
							$update_error = MsgBox(19, "Error", "       There were errors during the update process." & @CRLF & "  The source size does not match the destination size." & @CRLF & "              Would you like to retry the update?" & @CRLF & "                 Click 'Yes' to retry the update." & @CRLF & "   Click 'No' to move on to the next disc in the series.                " & @CRLF & "                                      Note:" & @CRLF & "                     If you choose 'No' the data " & @CRLF & "                  paths for this disc will not be set.")
							Select
								Case $update_error = 6 ;Yes
									$error = 1
									Call("RestartCopy")
								Case $update_error = 7 ;No
									ExitLoop
								Case $update_error = 2 ;Cancel
									Call("ExitConfirm")
							EndSelect
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
Func CopyContinue()
	If Not ProcessExists($copyproc1 & ".exe") Then
		MsgBox(0, "Error", "The Command Failed")
		Exit
	EndIf
	Select
		Case $update = 0
			$x = 0
			ProgressOn("Copying", "Copying " & $set_desc_ini & " " & $dvd_num & " (" & $sk_add & $ssid_ini & ") . . .", "0 %")
			While 1
				$dest_size = DirGetSize($copy_path & $dvd_num)
				$progress_calc = $dest_size * 100
				$copy_progress = $progress_calc / $source_size
				$copy_progress = Int($copy_progress)
				If $copy_progress = 100 Then
					ProgressSet($copy_progress, "(" & $sk_add & $ssid_ini & ") Complete!", $set_desc_ini & " " & $dvd_num & " Copied Successfully!")
					IniDelete(@WindowsDir & "\" & $apptype & ".ini", "ODM", "Disc_" & $dvd_num)
					IniWrite(@WindowsDir & "\" & $apptype & ".ini", "ODM", "Disc_" & $dvd_num, $copy_path & $dvd_num)
					Sleep(2000)
					ProgressOff()
					ExitLoop
				Else
					$x = $x + 1
					If $x = 1 Then
						$copy_check = $copy_progress
					EndIf
					ProgressSet($copy_progress, $copy_progress & " %", "Copying " & $set_desc_ini & " " & $dvd_num & " (" & $sk_add & $ssid_ini & ") . . .")
					If $x = 1000 Then
						If $copy_progress = $copy_check Then
							$copy_log_open = FileOpen($copy_log_file, 0)
							If $copy_log_open = -1 Then
								ProgressOff()
								MsgBox(0, "Error", "Unable to open log file.")
								Exit
							EndIf
							While 1
								$copy_log_1 = String($copy_log_2)
								$copy_log_2 = String($copy_log_3)
								$copy_log_3 = FileReadLine($copy_log_open)
								If @error = -1 Then
									ExitLoop
								EndIf
								$copy_log_output = String($copy_log_1 & @CRLF & $copy_log_2 & @CRLF & $copy_log_3)
							WEnd
							FileClose($copy_log_open)
							ProgressOff()
							$update_error = MsgBox(53, "Error", "       The following errors have been detected:" & @CRLF & "" & @CRLF & $copy_log_output & @CRLF & "" & @CRLF & "To attempt to continue the copy process, click 'Retry'                  " & @CRLF & "                      or click 'Cancel' to exit.")
							Select
								Case $update_error = 4 ;Retry
									Call("RestartCopy")
								Case $update_error = 2 ;Cancel
									Call("ExitConfirm")
							EndSelect
						Else
							$x = 0
						EndIf
					EndIf
				EndIf
			WEnd
			ProgressOff()
		Case $update = 1
			SplashTextOn("Updating", @CRLF & "Updating data to " & $set_desc_ini & " " & $dvd_num & " (" & $sk_add & $ssid_ini & ")" & $working, "325", "50", "-1", "-1", 1, "", "10", "700")
			$error_check = 0
			While 1
				If ProcessExists($copyproc1 & ".exe") Then
					$error_check = $error_check + 1
					$working = String("      ")
					ControlSetText("Updating", "", "Static1", @CRLF & "Updating data to " & $set_desc_ini & " " & $dvd_num & " (" & $sk_add & $ssid_ini & ")" & $working)
					Sleep(500)
					$working = String(" .    ")
					ControlSetText("Updating", "", "Static1", @CRLF & "Updating data to " & $set_desc_ini & " " & $dvd_num & " (" & $sk_add & $ssid_ini & ")" & $working)
					Sleep(500)
					$working = String(" . .  ")
					ControlSetText("Updating", "", "Static1", @CRLF & "Updating data to " & $set_desc_ini & " " & $dvd_num & " (" & $sk_add & $ssid_ini & ")" & $working)
					Sleep(500)
					$working = String(" . . .")
					ControlSetText("Updating", "", "Static1", @CRLF & "Updating data to " & $set_desc_ini & " " & $dvd_num & " (" & $sk_add & $ssid_ini & ")" & $working)
					Sleep(500)
					If $error_check = 600 Then
						$copy_log_open = FileOpen($copy_log_file, 0)
						If $copy_log_open = -1 Then
							SplashOff()
							MsgBox(0, "Error", "Unable to open log file.")
							Exit
						EndIf
						While 1
							$copy_log_1 = String($copy_log_2)
							$copy_log_2 = String($copy_log_3)
							$copy_log_3 = FileReadLine($copy_log_open)
							If @error = -1 Then
								ExitLoop
							EndIf
							$copy_log_output = String($copy_log_1 & @CRLF & $copy_log_2 & @CRLF & $copy_log_3)
						WEnd
						FileClose($copy_log_open)
						SplashOff()
						$update_error = MsgBox(53, "Error", "       The following errors have been detected:" & @CRLF & "" & @CRLF & $copy_log_output & @CRLF & "" & @CRLF & "To attempt to continue the copy process, click 'Retry'                  " & @CRLF & "                      or click 'Cancel' to exit.")
						Select
							Case $update_error = 4 ;Retry
								$error = 1
								Call("RestartCopy")
							Case $update_error = 2 ;Cancel
								Call("ExitConfirm")
						EndSelect
					EndIf
				ElseIf Not ProcessExists($copyproc1 & ".exe") Then
					Sleep(5000)
					If Not ProcessExists($copyproc1 & ".exe") Then
						$dest_size = DirGetSize($copy_path & $dvd_num)
						If $source_size = $dest_size Then
							ControlSetText("Updating", "", "Static1", @CRLF & "Successfully Updated " & $set_desc_ini & " " & $dvd_num & " (" & $sk_add & $ssid_ini & ")")
							IniDelete(@WindowsDir & "\" & $apptype & ".ini", "ODM", "Disc_" & $dvd_num)
							IniWrite(@WindowsDir & "\" & $apptype & ".ini", "ODM", "Disc_" & $dvd_num, $copy_path & $dvd_num)
							Sleep(2000)
							SplashOff()
							ExitLoop
						Else
							SplashOff()
							$update_error = MsgBox(19, "Error", "       There were errors during the update process." & @CRLF & "  The source size does not match the destination size." & @CRLF & "              Would you like to retry the update?" & @CRLF & "                 Click 'Yes' to retry the update." & @CRLF & "   Click 'No' to move on to the next disc in the series.                " & @CRLF & "                                      Note:" & @CRLF & "                     If you choose 'No' the data " & @CRLF & "                  paths for this disc will not be set.")
							Select
								Case $update_error = 6 ;Yes
									$error = 1
									Call("RestartCopy")
								Case $update_error = 7 ;No
									ExitLoop
								Case $update_error = 2 ;Cancel
									Call("ExitConfirm")
							EndSelect
						EndIf
					EndIf
				EndIf
			WEnd
		EndSelect
	Return
EndFunc   ;==>CopyContinue
;-----------------------------------------------------------------------------------------------------------------------------
#Region Compiler directives section
;** This is a list of compiler directives used by CompileAU3.exe.
;** comment the lines you don't need or else it will override the default settings
#Compiler_Prompt=y															;y=show compile menu
;#Compiler_AUTOIT3=         											    ;Override the default Interpreter with this version.
;#Compiler_AUT2EXE=															;Override the default compiler with this version.
#Compiler_Icon=\\dakota\user\mm1228\ts\My Documents\System\System Settings\Icons\Dminion\M1.ico       ;Filename of the Ico file to use
#Compiler_OutFile=\\dakota\user\mm1228\ts\My Documents\Link\Scripting\Complete\Dminion\DiscCopy\Disc Copy Packs\DVD Utility.exe	;Target exe filename.
#Compiler_Compression=2														;Compression parameter 0-4  0=Low 2=normal 4=High
#Compiler_Allow_Decompile=n													;y= allow decompile
;#Compiler_PassPhrase=														;Password to use for compilation;** Target program Resource info
#Compiler_Res_Comment=MRIC													;Comment field
#Compiler_Res_Description=M1 DVD Copy Utility								;Description field
#Compiler_Res_Fileversion=1.10.06.0											;File Version
#Compiler_Res_LegalCopyright=Dminion © 2006									;Copyright field; free form resource fields ... max 15
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