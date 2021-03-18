#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <ProgressConstants.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#Include<Array.au3>
#include<file.au3>


;### Programme Name: DirCopier
;### Version: V0.3 (alpha)
;### Author: Karl Griffiths
;### Description: This programme will copy files from one location to another. It will replace all files
;### with the same name in the destination folder currently. It has a very basis check
;### function which compares the size of the source and destination folders to see if they	
;### match in size, it uses this same logic to confirm when copy is complete. It creates
;### a CSV file in the same location as the compiled script and uses this to store the 
;### last used source and destination locations incase you want to use it as a regular back up tool.				
;### Further Development Needs: See script
;### Special thanks: Wayfarer, Universalist, AZJIO											

Global $srcbutton, $destbutton, $src1, $src2, $dest1, $dest2, $destinput, $srcsize, $destsize, $file

;####   GUI   ####

;Main Gui
GUICreate("DirCopier", 623, 233, 267, 178)
GUISetFont(8, 800, 0, "MS Sans Serif")
;Location Inputs
GUICtrlCreateGroup("Locations", 8, 16, 601, 97)
GUICtrlCreateLabel("Source", 16, 48, 44, 17)
GUICtrlCreateLabel("Destination", 16, 88, 68, 17)
$srcinput = GUICtrlCreateInput("", 94, 46, 393, 21)
GUICtrlSetState($srcinput,$GUI_DISABLE)
$destinput = GUICtrlCreateInput("", 93, 83, 393, 21)
GUICtrlSetState($destinput,$GUI_DISABLE)
$srcbutton = GUICtrlCreateButton("Src", 495, 45, 75, 25)
$destbutton = GUICtrlCreateButton("Dest", 494, 80, 75, 25)
;File Management radios
GUICtrlCreateGroup("File Management", 8, 128, 281, 89)
$replace_off = GUICtrlCreateRadio("Do not override existing files (Default)", 16, 152, 249, 17)
GUICtrlSetState($replace_off,$GUI_DISABLE)
$replace_on = GUICtrlCreateRadio("Override existing files", 16, 176, 241, 17)
GUICtrlSetState(-1, $GUI_CHECKED)
GUICtrlSetState($replace_on,$GUI_DISABLE)
GUICtrlCreateGroup("", -99, -99, 1, 1)
;Pre scan and go buttons
GUICtrlCreateGroup("Execution", 312, 128, 297, 89)
$go = GUICtrlCreateButton("Copy", 496, 152, 75, 25)
$check = GUICtrlCreateButton("Pre-Scan", 328, 152, 97, 25)
;The progress GUI should not be included until code is provided to support progress
;GUICtrlCreateProgress(392, 192, 174, 17)
;GUICtrlCreateLabel("Progress", 328, 192, 53, 17)


;####Functions####

; Set initial filepath and create if file not already present
Func _FilePathCall()
$file = FileOpen(@ScriptDir & "\filepath.csv", 0) ;Open file to call the filepaths
If $file = -1 Then ;If file is not found then do something
   FileWrite(@scriptdir & "\filepath.csv", "C:\" & @CRLF ) ;create file, write to first line and then move to next line
   FileWrite(@scriptdir & "\filepath.csv", "C:\") ;continue to write to file on next line
   MsgBox(0,"Notification","This is the first time you have run this programme." & @CRLF & _
						   "Initially the copy cource and destination folders are the same." & @CRLF & _ 
						   "You can change this by clicking the Src and Dest buttons")
EndIf
$file = FileOpen(@ScriptDir & "\filepath.csv", 0) ;Open file to call the filepaths
$src1 = FileReadLine($file,1) ;make first line of file the variable
$dest1 = FileReadLine($file,2) ;make second line of file the variable
FileClose($file) ;close off file for later use
GUICtrlSetData($srcinput,$src1) ;Set input box for the source so the assigned variable
GUICtrlSetData($destinput,$dest1) ;Set input box for the source so the assigned variable
EndFunc ;==>_FilePathCall()

;Setting a new default input(done everytime the Dir location is amended)
Func _SetNewDir($inputname, $csvLine)
   $tmp = FileSelectFolder("Please Select Backup Source","") ;user prompt to select a folder
    If @error Then Return SetError(1, 0, 'Error')
   _FileWriteToLine(@ScriptDir & "\filepath.csv", $csvLine, $tmp, 1) ;Writes the new location to the filepath csv used in 'Func _FilePathCall()'
   $file = FileOpen(@ScriptDir & "\filepath.csv", 0) ;Opens file with read access
   $DirSelect = FileReadLine($file,$csvLine) ;Reads the new location that has been set
   FileClose($file) ;Closes file for later use
   GUICtrlSetData($inputname,$DirSelect) ;Sets the input box to reflect the new location
EndFunc ;==>_SetNewDir

;Checks the size of a folder - script taken from autoit forums but in my haste I didnt take down detail of who produced it and cannot find post
;edit made by AZJIO to optimise function

Func _GetFolderSize($dir, $units = "b")
    $obj = DirGetSize($dir)
    If Not @error Then
        Switch $units 
            Case "b"
                Return $obj 
            Case "kb"
                Return $obj  / 1024
            Case "mb"
                Return $obj  / 1024 / 1024
            Case "gb"
                Return $obj  / 1024 / 1024 / 1024
            Case "tb"
                Return $obj  / 1024 / 1024 / 1024 / 1024
        EndSwitch
    Else
        MsgBox(0, "", "An error occurred, check that " & $dir & " exists.", 0, $hGUI)
    EndIf
EndFunc   ;==>_GetFolderSize
 
; Checks if two folders are the same size - not the most accurate way to confirm two folders are the same 
; ##### this feature needs to be improved to check files and version numbers #####
 Func _Compare ()
   If guictrlread($srcinput) = "" Then
	   MsgBox(0,"Error", "Please choose a source directory")
	   ElseIf guictrlread($destinput) = "" Then
	     MsgBox(0,"Error", "Please choose a destination directory")
		 Else
			$srcsize = _GetFolderSize(guictrlread($srcinput), "mb")
			$destsize = _GetFolderSize(guictrlread($destinput), "mb")
			   If $srcsize = $destsize Then
				  MsgBox(0,"Folder Check", "Each folder is the same size" & @CRLF & _
						   "This would suggest no back up is required")
			   Else
				  MsgBox(0,"Folder Check", "Folders sizes do not match." & @CRLF & _
										   "This would suggest you should run a back up")
										EndIf
   EndIf
EndFunc ;==>_Compare()
	
;Checks the folder sizes every 30 seconds until they match - a weak way of veryfying copy has completed (assumes directories would be different sizes before copy)
;##### this feature needs to be improved to calculate progress and provide %complete  #####
Func _CheckProgress()
   While 1
	  Sleep(1000)
	  $srcsize = _GetFolderSize(guictrlread($srcinput), "b")
	  $destsize = _GetFolderSize(guictrlread($destinput), "b")
	  If $srcsize = $destsize Then ExitLoop
   WEnd
   MsgBox(0,"Notification","Folders are now of equal size." & @CRLF & _
						   "This would suggest the copy process is now complete") 
EndFunc	;==>_CheckProgress

;This function carries out the copy of files from source location to destination location
;##### this feature needs to be improved to check which files need copying based on version (last modified) rather than copying all files  #####

Func _CopyFiles()
   If guictrlread($srcinput) = guictrlread($destinput) Then
	  MsgBox(0,"Error","The source and destination directory must not be the same")
   Else
	  If guictrlread($replace_on) = 1 Then ;Checks to if the radio to replace files with the same name is on
		 DirCopy ( guictrlread($srcinput), guictrlread($destinput) , 1 ) ;Copies - allows files to be replaced
		 _CheckProgress()
	  ElseIf  guictrlread($replace_on) = 4 Then ;Checks to if the radio to replace files with the same name is off
		 DirCopy ( guictrlread($srcinput), guictrlread($destinput) , 0 ) ;Copies - does not allow files to be replaced
	  EndIf
   EndIf
EndFunc ;==>_CopyFile

; ########################## Function Calls ########################

GUISetState(@SW_SHOW) ;Shows the GUI

_FilePathCall()

 While 1
;Calls various functions depending on certain button presses
   $msg = GUIGetMsg()
	  Select
		 Case $msg = $GUI_EVENT_CLOSE
			ExitLoop
		 Case $msg = $srcbutton
			_SetNewDir($srcinput, "1")
		 Case $msg = $destbutton
			_SetNewDir($destinput, "2")
		 Case $msg = $check
			_Compare ()
		 Case $msg = $go
			_CopyFiles()			
        EndSelect
WEnd