#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_outfile=..\File Sync.exe
#AutoIt3Wrapper_UseX64=n
#AutoIt3Wrapper_Res_Description=Lets you backup a folder or file to a location of your choice.
#AutoIt3Wrapper_Res_Fileversion=1.0.0.3
#AutoIt3Wrapper_Res_Fileversion_AutoIncrement=p
#AutoIt3Wrapper_Res_Language=1033
#AutoIt3Wrapper_Res_Field=Developer|Gary Haag
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

#include <GUIConstantsEx.au3>
#include <ProgressConstants.au3>
#include <GUIEdit.au3>
#include <EditConstants.au3>
#include <StaticConstants.au3>
#include <ButtonConstants.au3>
#include <File.au3>
#include <Array.au3>
#include <WindowsConstants.au3>
#include <GuiStatusBar.au3>
#include <ButtonConstants.au3>

Local $Total_Files, $Copied_Files_Array[1]

$Main = GUICreate("Backup a folder", 457, 250) ;Main GUI
GUICtrlCreateLabel("Select the folder you want to back up here:", 15, 5)
$Input_Src_Dir = GUICtrlCreateInput("", 15, 20, 300, 20) ;Inputbox
$Src_Label = GUICtrlCreateLabel("", 15, 45, 300, 18, $SS_SUNKEN) ;Inputbox label
$Set_Src = GUICtrlCreateButton("Set", 320, 19, 60, 22) ;"Set" button
$Select_Src = GUICtrlCreateButton("Browse", 385, 19, 60, 22) ;"Browse" button
$Clear_Src = GUICtrlCreateButton("Clear", 353, 45, 60, 22) ;"Clear" button
GUICtrlCreateLabel("Select where you want to copy the files here:", 15, 70)
$Input_Dest_Dir = GUICtrlCreateInput("", 15, 90, 300, 20) ;Inputbox
$Dest_Label = GUICtrlCreateLabel("", 15, 115, 300, 18, $SS_SUNKEN) ;Inputbox label
$Set_Dest = GUICtrlCreateButton("Set", 320, 89, 60, 22) ;"Set" button
$Select_Dest = GUICtrlCreateButton("Browse", 385, 89, 60, 22) ;"Browse" button
$Clear_Dest = GUICtrlCreateButton("Clear", 353, 115, 60, 22) ;"Clear" button
$Btn_1 = GUICtrlCreateButton("Start backup", 290, 195, 75) ;"Start" button
$Btn_2 = GUICtrlCreateButton("Quit", 370, 195, 75) ;"Quit" button
$Gui_Progress = GUICtrlCreateProgress(0, 227, 457, 23, $PBS_SMOOTH) ;Progress bar
GUISetState()
$Copying_label = GUICtrlCreateLabel("", 5, 140, 445, 50) ;Current file being copied label
GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
$Perc_label = GUICtrlCreateLabel("", 5, 209, 90, 18) ;Progress bar, percent remaining label
GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
$Remain_label = GUICtrlCreateLabel("", 100, 209, 140, 18) ;Progress bar, files remaining label
GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)


While 1
	Switch GUIGetMsg()
		Case $GUI_EVENT_CLOSE ;Tells the program to exit when you click the "X / Close" button
			Exit

		Case $Btn_2 ;Tells the program to exit when you click the "Quit" button
			Exit

		Case $Clear_Src ;Tells the program to clear the source folder inputbox
			_GUICtrlEdit_SetText($Src_Label, "")
			_GUICtrlEdit_SetText($Input_Src_Dir, "")

		Case $Clear_Dest ;Tells the program to clear the destination folder inputbox
			_GUICtrlEdit_SetText($Dest_Label, "")
			_GUICtrlEdit_SetText($Input_Dest_Dir, "")

		Case $Select_Src ;Opens a browse to interface
			$Src_Dir = FileSelectFolder("Select folder", "") ;Sets the source folder
			$Src_Dir_Size = DirGetSize($Src_Dir) / 1024 / 1024 ;Stores the filesize of the selected folder and converts output to MB
			$Total_Files = DirGetSize($Src_Dir, 1) ;Stores the file count of the source folder
			_GUICtrlEdit_SetText($Src_Label, "") ;Erases the source label
			If GUICtrlGetState($Src_Dir) == -1 Then ;Folder selected
				$Src_Label = GUICtrlCreateLabel(Round($Src_Dir_Size / 1024, 2) & "=GB | " & Round($Src_Dir_Size, 2) & "=MB | " _
						 & $Total_Files[2] & "=Folders | " & $Total_Files[1] & "=Files", 15, 45, 300, 20, $SS_SUNKEN) ;Populates the source label
			ElseIf GUICtrlGetState($Src_Dir) = -1 Then ;Cancel button clicked
			EndIf

			_GUICtrlEdit_SetText($Input_Src_Dir, $Src_Dir) ;Transfers the folder you select to the inputbox

		Case $Set_Src ;Tells the program to set the folder you type to the source folder
			If FileExists(GUICtrlRead($Input_Src_Dir)) Then ;Determines if the folder you typed actually exists
				$Src_Dir = GUICtrlRead($Input_Src_Dir) ;Sets the source folder
				$Src_Dir_Size = DirGetSize($Src_Dir) / 1024 / 1024 ;Stores the filesize of the selected folder and converts output to MB
				$Total_Files = DirGetSize($Src_Dir, 1) ;Stores the file count of the source folder
				_GUICtrlEdit_SetText($Src_Label, "") ;Erases the source label

				$Src_Label = GUICtrlCreateLabel(Round($Src_Dir_Size / 1024, 2) & "=GB | " & Round($Src_Dir_Size, 2) _
						 & "=MB | " & $Total_Files[2] & "=Folders | " & $Total_Files[1] & "=Files", 15, 45, 300, 20, $SS_SUNKEN) ;Populates the source label

			Else
				MsgBox(48, "Invalid", "Folder or File entered does not exist, please check spelling or use the browse button to ensure correct folder/file is selected", 15)
				_GUICtrlEdit_SetText($Src_Label, "") ;Erases the source label
				_GUICtrlEdit_SetText($Input_Src_Dir, "") ;Erases the source inputbox
			EndIf

		Case $Select_Dest ;Opens a browse to folder interface so you can select a destination folder
			$Dest_Dir = FileSelectFolder("Select folder", "", 1) ;Opens a browse to interface with "New Folder" option
			$Dest_Dir_Total = DriveSpaceFree($Dest_Dir) ;Stores the destination folder size in MB
			_GUICtrlEdit_SetText($Dest_Label, "") ;Erases the destination label
			If GUICtrlGetState($Dest_Dir) == -1 Then ;Folder selected
				$Dest_Label = GUICtrlCreateLabel(Round(DriveSpaceTotal($Dest_Dir) / 1024, 2) & " GB free", 15, 115, 300, 20, $SS_SUNKEN)
			ElseIf GUICtrlGetState($Dest_Dir) = -1 Then ;Cancel button clicked
			EndIf
			_GUICtrlEdit_SetText($Input_Dest_Dir, $Dest_Dir) ;Transfers the folder you select to the inputbox

		Case $Set_Dest ;Tells the program to set the folder you type to the destination folder
			$Dest_Dir = GUICtrlRead($Input_Dest_Dir) ;Sets the destination folder

			If DriveStatus($Dest_Dir) = "READY" Or "UNKNOWN" Then ;Checks if the drive is connected and ready
				If FileExists($Dest_Dir) Then ;Determines if the folder you typed actually exists
					$Dest_Dir = GUICtrlRead($Input_Dest_Dir) ;Sets the destination folder
					$Dest_Dir_Total = DriveSpaceFree($Dest_Dir) ;Stores the destination folder size in MB
					_GUICtrlEdit_SetText($Dest_Label, "") ;Erases the destination label
					$Dest_Label = GUICtrlCreateLabel(Round(DriveSpaceTotal($Dest_Dir) / 1024, 2) & " GB free", 15, 115, 300, 20, $SS_SUNKEN) ;Populates the destination label
				Else
					$No_Dir = MsgBox(52, "Invalid", "Folder entered does not exist. Would you like to create it now?", 999) ;Checks if folder exists and gives the option to create it if it does not
					If $No_Dir = 6 Then
						DirCreate($Dest_Dir) ;Creates the directory you typed
						$Dest_Dir = GUICtrlRead($Input_Dest_Dir) ;Sets the destination folder
						$Dest_Dir_Total = DriveSpaceFree($Dest_Dir) ;Stores the destination folder size in MB
						$Dest_Label = GUICtrlCreateLabel(Round(DriveSpaceTotal($Dest_Dir) / 1024, 2) & " GB free", 15, 115, 300, 20, $SS_SUNKEN) ;Populates the destination label
					Else
						_GUICtrlEdit_SetText($Dest_Label, "") ;Erases the destination label
						_GUICtrlEdit_SetText($Input_Dest_Dir, "") ;Erases the destination inputbox
					EndIf
				EndIf
			Else
				MsgBox(48, "No Drive", "The drive label you entered does not appear to be connected, check drive connections and try again.", 15)
				_GUICtrlEdit_SetText($Input_Dest_Dir, "") ;Erases the destination inputbox
			EndIf

		Case $Btn_1 ;Tells the program to proceed with the folder copy operation when the "Start" button is clicked
			If GUICtrlRead($Input_Dest_Dir) = "" Then ;Checks if a destination folder is set
				MsgBox(48, "Error", "No destination folder selected.", 15)

			ElseIf GUICtrlRead($Input_Src_Dir) = "" Then ;Checks if a source folder is set
				MsgBox(48, "Error", "No Src folder selected.", 15)

			ElseIf $Dest_Dir = $Src_Dir Then ;Checks to make sure the source and destination are not the same place
				MsgBox(48, "Error", "Destination folder cannot be the same as the Source folder", 15)
				_GUICtrlEdit_SetText($Input_Src_Dir, "") ;Erases the source label
				_GUICtrlEdit_SetText($Input_Dest_Dir, "") ;Erases the destination label

			ElseIf $Dest_Dir_Total < $Src_Dir_Size Then ;Checks stored information to make sure destination drive has more free space than the amount selected
				MsgBox(48, "Error", "Destination drive does not contain enough free space.", 15)
				_GUICtrlEdit_SetText($Input_Src_Dir, "") ;Erases the source inputbox
				_GUICtrlEdit_SetText($Src_Label, "") ;Erases the source label
				_GUICtrlEdit_SetText($Input_Dest_Dir, "") ;Erases the destination inputbox
				_GUICtrlEdit_SetText($Dest_Label, "") ;Erases the destination label
			Else

				GUICtrlSetData($Btn_1, "Stop Backup") ;Changes the "Start" button to a "Stop" button
				GUICtrlSetState($Btn_2, @SW_HIDE) ;Disables the quit button while file copy is in progress


				$File_Copy_List = _FileListToArray($Src_Dir) ;Creates and stores an array with all the files and folders in the source folder
				$Max = UBound($File_Copy_List) ;Stores the total number of files in the array

				For $Copied = 0 To $Total_Files[1] ;Starts the file copy loop (the bracketed 1 tells the program to read the total entry count in the array)

					$m = GUIGetMsg() ;Checks to see if the "Stop" button was clicked

					If $m = $Btn_1 Then ;"Stop" button clicked
						MsgBox(0, "Aborted", "File copy aborted, " & $Copied & " Files still copied to " & $Dest_Dir) ;Displays how many files still copied before process was aborted
						GUICtrlSetData($Btn_1, "Start Backup") ;Changes the "Stop" button back to a "Start" button
						_GUICtrlEdit_SetText($Perc_label, "") ;Erases the percent remaining label
						_GUICtrlEdit_SetText($Remain_label, "") ;Erases the files remaining label
						_ArrayReverse($Copied_Files_Array)
						_ArrayPop($Copied_Files_Array)
						$Delete = MsgBox(4, "Delete files", "Do you want to delete the files that already copied?", 999)
						If $Delete = 6 Then
							$Delete_Total = UBound($Copied_Files_Array)
							While $Delete_Total > 1
								$File_to_delete = _ArrayToString($Copied_Files_Array, "", $Delete_Total, $Delete_Total - 1)
								$Delete_Total = $Delete_Total - 1
								FileDelete($Dest_Dir & "\" & $File_to_delete)
							WEnd
							MsgBox(0, "File deletion complete", "Done deleting all copied files", 15)
							$Dest_Dir_Del = MsgBox(4, "Delete folder?", "Delete destination directory also?", 999)
							If $Dest_Dir_Del = 6 Then
								DirRemove($Dest_Dir)
								MsgBox(0, "Deleted", $Dest_Dir & " Deleted", 5)
							EndIf
							Exit
						Else
							Exit ;Aborts the copy process
						EndIf
					Else

						GUICtrlSetData($Gui_Progress, $Copied / $Total_Files[1] * 100) ;Calculates the percentage of files copied then sends that to the progress bar

						$File_to_copy = _ArrayToString($File_Copy_List, "", $Max, $Max) ;Stores the last filename in the array

						If FileGetAttrib($Src_Dir & "\" & $File_to_copy) = "D" Then ;Checks if the stored filename is a directory
							$Dir_Files = DirGetSize($Src_Dir & "\" & $File_to_copy, 1)
							$Copying = StringFormat("Copying folder " & $File_to_copy & " / containing " & $Dir_Files[1] & " files / folders and a total size of " & round(DirGetSize($Src_Dir & "\" & $File_to_copy) / 1024 / 1024, 2) & " MB")
							$Perc_Done = StringFormat(Round(0 + $Copied / $Total_Files[1] * 100) & " percent done") ;Calculates and stores the percentage of files copied
							$Remaining = StringFormat("No. of files remaining = " & $Total_Files[1] - $Copied) ;Calculates and stores the count of files remaining to be copied

							GUICtrlSetData($Copying_label, $Copying)
							GUICtrlSetData($Perc_label, $Perc_Done) ;Sends the percentage of files copied to the percent remaining label
							GUICtrlSetData($Remain_label, $Remaining) ;Sends the remaining files count to the files remaining label

							DirCopy($Src_Dir & "\" & $File_to_copy, $Dest_Dir & "\" & $File_to_copy, 0) ;Copies the directory to the destination folder
							_ArrayAdd($Copied_Files_Array, $File_to_copy)
							$Max = $Max - 1 ;Subtracts 1 from the total count of the array

						Else ;Filename is not a directory
							$Copying = StringFormat("Copying file " & $File_to_copy)
							$Perc_Done = StringFormat(Round(0 + $Copied / $Total_Files[1] * 100) & " percent done") ;Calculates and stores the percentage of files copied
							$Remaining = StringFormat("No. of files remaining = " & $Total_Files[1] - $Copied) ;Calculates and stores the count of files remaining to be copied

							GUICtrlSetData($Copying_label, $Copying)
							GUICtrlSetData($Perc_label, $Perc_Done) ;Sends the percentage of files copied to the percent remaining label
							GUICtrlSetData($Remain_label, $Remaining) ;Sends the remaining files count to the files remaining label

							FileCopy($Src_Dir & "\" & $File_to_copy, $Dest_Dir & "\" & $File_to_copy, 0) ;Copies the file to the destination directory
							_ArrayAdd($Copied_Files_Array, $File_to_copy)
							$Max = $Max - 1 ;Subtracts 1 from the total count of the array
						EndIf

					EndIf
				Next ;Tells the program what to do once all files are copied
				MsgBox(0, "Complete", "Backup operation complete. " & $Copied & " files copied to " & $Dest_Dir)

				$Open = MsgBox(4, "Open folder", "Would you like to open the destination folder now?", 999)
				If $Open = 6 Then
					ShellExecute($Dest_Dir)
				Else
					Exit
				EndIf

				GUICtrlSetData($Gui_Progress, 0) ;Clears the progress bar
			EndIf

			_GUICtrlEdit_SetText($Input_Src_Dir, "") ;Erases the source inputbox
			_GUICtrlEdit_SetText($Src_Label, "") ;Erases the source label
			_GUICtrlEdit_SetText($Input_Dest_Dir, "") ;Erases the destination inputbox
			_GUICtrlEdit_SetText($Dest_Label, "") ;Erases the destination label
			GUICtrlSetData($Perc_label, "") ;Erases the percent remaining label
			GUICtrlSetData($Remain_label, "") ;Erases the files remaining label
	EndSwitch
WEnd
Exit