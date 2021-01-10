#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.2.12.1
 Author:        Jason Morgan

 Script Function: 	Backup a desired user profile and dumps the data to another folder.
					Will notify the user if the process was successful and display a 
					reading of the file size.

					-----------------------------------------
					August 22, 2008 - 10:00:52 - Jason Morgan V1.2
					- Created msg box' to give feedback on file size and successfulness of transfers.
					- Added menu feature to application



					
					-----------------------------------------
					August 25, 2008 - 11:04:22 - Jason Morgan V2.0
					- Added a User choice of where to place copied profile folder.
	
	
					-----------------------------------------
					August 25, 2008 - 13:23:45 - Jason Morgan V2.01
					- Created a Progress bar to show that 


					

#ce ----------------------------------------------------------------------------




;------------------------------------About Me Captions-------------------------------------------
$Author = "IT Microsystems Technicians" & @LF & "        Profile Backup Tool" & @LF & "             Version 1.2" & @CRLF & "             Created by " & @LF & "           Jason Morgan"
$me = StringAddCR($Author)
Dim $test, $i, $profile, $FolderList
;------------------------------------End of About Me Captions-------------------------------------------


; Script Start - Add your code below here

#include <ButtonConstants.au3>
#include <ComboConstants.au3>
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#Include <File.au3>
#include <AVIConstants.au3>
#include <TreeViewConstants.au3>




;----------------------------------------Form creation begins--------------------------------------------
Opt("GUIOnEventMode", 1)
#Region ### START Koda GUI section ### Form=
$Form1 = GUICreate("Profile Copier", 297, 291, 389, 180)
	GUISetOnEvent($GUI_EVENT_CLOSE, "Form1Close")
$Group1 = GUICtrlCreateGroup("", 40, 32, 209, 193)
$Combo1 = GUICtrlCreateCombo("", 88, 64, 113, 25)
	GUICtrlSetOnEvent(-1, "Combo1Change")

$Button1 = GUICtrlCreateButton("&Get User", 112, 112, 57, 25, 0)
	GUICtrlSetOnEvent(-1, "Button1Click")

$Button2 = GUICtrlCreateButton("&Backup", 112, 160, 57, 25, 0)
	GUICtrlSetOnEvent(-1, "BackupClick")
GUICtrlCreateGroup("", -99, -99, 1, 1)
$Exit = GUICtrlCreateButton("E&xit", 104, 232, 81, 33, 0)
	GUICtrlSetOnEvent(-1, "Exitclick")

	GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###
;----------------------------------------Form Creation Ends Here-------------------------------------------



; ----------------------------------------Menu creation starts Here----------------------------------------;		
$File = GuiCtrlCreateMenu("&File")
$helpmenu = GuiCtrlCreateMenu ("&Help")
$aboutitem = GuiCtrlCreateMenuitem ("&About",$helpmenu)
		GUICtrlSetOnEvent(-1, "Aboutclick")
; ----------------------------------------Menu creation ends Here----------------------------------------;		





While 1					
    Sleep(100)
WEnd


;-----------------------------------Button1 Function--------------------------------------------
Func Button1Click()
    Local $combo_string = ""    															;the string used to populate the combo
    $FolderList = _FileListToArray("C:\Documents and Settings", "*", 2)						;get folder list
    For $i = 1 To $FolderList[0]
        Switch $FolderList[$i]
            Case "All Users","Default User", "LocalService", "NetworkService"				;filter common dirs
                ContinueLoop
            Case Else
                If $i = $FolderList[0] Then
                    $combo_string &= $FolderList[$i]    									;if it's the last element
                Else
                    $combo_string &= $FolderList[$i]&"|"
                EndIf
        EndSwitch
    Next
	GUICtrlSetData($Combo1, $combo_string)    												;update the combo content
EndFunc
;-----------------------------------End of Button1 Function--------------------------------------------


;-----------------------------------Combo1 Function--------------------------------------------
Func Combo1Change()
    MsgBox(0, "Profile Selected", GUICtrlRead($Combo1))										;what happens when you change the content
EndFunc
;-----------------------------------End of Combo1 Function--------------------------------------------

$profile = GUICtrlRead($Combo1)
;------------------------------------Backup Button Function-------------------------------------------
Func BackupClick()
	
	
	$MyDocsFolder = "::{450D8FBA-AD25-11D0-98A8-0800361B1103}"
	$var = FileSaveDialog( "Choose a name.", "C:\", "All (*.*)" , 2)				;Allows the user to choose where to save files to (default is ...)
		
		If @error Then
	MsgBox(4096,"","Save cancelled.")
		Else
	$Confirm = MsgBox(3+32,"Confirm"," " & $var)
			if $Confirm = 7 Then
				Exit
			Else
	
										;------------------------------------Progress Bar-------------------------------------------;
			$From = GUICtrlRead($Combo1)
				ProgressOn("Progress Meter" ,"Copying " & $From & " profile ", "Destination is " & $var)
            For $INDEX = 1 To $FolderList[0]
			$success = DirCopy ("C:\Documents and Settings\" & GUICtrlRead($Combo1) , $var, 1)		;Performs a directory copy to the user specified directory location
				ProgressSet($INDEX*100/Number($FolderList[0]), "")
            Next
            ProgressOff()
		EndIf
		
			;------------------------------------Progress Bar-------------------------------------------;
		EndIf

	
		If $success = 1	Then																;If condition for a successful transfer and performs a folder size comparison with the original folder							
				$size = DirGetSize("C:\Documents and Settings\" & GUICtrlRead($Combo1))
				Msgbox(0, "status", "Original file Size is (MegaBytes):" & Round($size / 1024 / 1024))
				$test = DirGetSize("C:\profiles\" & GUICtrlRead($Combo1))
				Msgbox(0, "status", "Transfer successful, file size is (MegaBytes):" & Round($size / 1024 / 1024))
								
				
		ElseIf $success = 0 Then	
				$retry = MsgBox(5, "status", "Transfer error")								;if transfer was unsuccessful, will prompt user to retry or cancel.
						If $retry = 4 Then 													; if retry (code 4) is replied then transfer process will retry.
							$success = DirCopy ("C:\Documents and Settings\" & GUICtrlRead($Combo1) , "C:\profiles\" & GUICtrlRead($Combo1), 1)
								If $success = 1	Then							
										$size = DirGetSize("C:\Documents and Settings\" & GUICtrlRead($Combo1))
										Msgbox(0, "status", "Original file Size is(MegaBytes):" & Round($size / 1024 / 1024))
										$test = DirGetSize("C:\profiles\" & GUICtrlRead($Combo1))
										Msgbox(0, "status", "Transfer successful, file size is (MegaBytes):" & Round($size / 1024 / 1024))
							
								ElseIf $success = 0 Then									;Alerts the user that there was an error and to check the file or folder
										$retry = MsgBox(16, "status", "Transfer error - Check your file")
								EndIf
						EndIf	

				
		EndIf
		
EndFunc
;-------------------------------------End of Backup Button Function------------------------------------------




;------------------------------------------Exit Button Function-------------------------------------
Func Exitclick()
		Exit
EndFunc
;------------------------------------------End of Exit Button Funtion-------------------------------------




;------------------------------------------Form1 Function-------------------------------------
Func Form1Close()
		Exit
EndFunc
;------------------------------------------End of Form1 Function-------------------------------------




;------------------------------------------About Function-------------------------------------
Func Aboutclick()
		Msgbox(0,"About", $me  )
EndFunc
;------------------------------------------End of About Function-------------------------------------




