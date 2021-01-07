#NoTrayIcon
#include <GUIConstants.au3>
; Install setontop au3 file
$ins = FileInstall("SetWinOnTop.au3",@TempDir & "\SetWinOnTop.au3")
	If @error Then
		MsgBox(4096,"","File is not installed")
	Else
		MsgBox(4096,"","File is installed")
	EndIf

; Create GUI
$Form6 = GUICreate("Test dialog", 292, 170, 192, 125)
GUICtrlCreateLabel("Select folder..", 10, 10, 127, 20)
GUICtrlSetFont(-1, 10, 800, 0, "MS Sans Serif")
$Button1 = GUICtrlCreateButton("...", 250, 10, 33, 17)
GUICtrlSetFont(-1, 8, 800, 0, "MS Sans Serif")
GUICtrlCreateLabel("", 8, 58, 276, 20)
GUICtrlSetFont(-1, 10, 400, 0, "MS Sans Serif")
GUISetState(@SW_SHOW)

; Set Options..
AutoItSetOption("WinTitleMatchMode", 2)
AutoItSetOption("WinSearchChildren", 1)
While 1
	$msg = GuiGetMsg()
	Select
	Case $msg = $GUI_EVENT_CLOSE
; Delete "set on top" au3 file at the end of app
		$search = FileFindFirstFile(@TempDir & "\SetWinOnTop.au3")  
; Check if the search was successful
		If $search = -1 Then
			MsgBox(0, "Error", "No files/directories matched the search pattern")
		Else
; Close the search handle
			FileClose($search)
; Delete au3 file
			FileDelete(@TempDir & "\SetWinOnTop.au3")
		EndIf
; Terminate project
		ExitLoop
	Case $msg = $Button1
; Show select folder dialog
		SelectFolder()
	EndSelect
WEnd
Exit


Func SelectFolder()
; Disable GUI button
	GUICtrlSetState($Button1,$GUI_DISABLE)
; Start au3 file to detect the availability of "Browse for Folder" dialog and set it on top	
	Run(@AutoItExe & ' "' & @TempDir & '\SetWinOnTop.au3"')
; Start "Browse for Folder" dialog	
	$SelectedFolder = FileSelectFolder("Choose a folder with plugins..", "","4","c:\")
	If @error Then
		MsgBox(4096,"","No Folder chosen")
	Else
		$NumOfFiles = DirGetSize($SelectedFolder,1)
		MsgBox(4096,"","Num of files in sel. dir.. " & $NumOfFiles[1])
	EndIf			
; Enable GUI button
	GUICtrlSetState($Button1,$GUI_ENABLE)
EndFunc	