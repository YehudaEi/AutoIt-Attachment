#include <GuiConstantsEx.au3>

$IniUsing = @TempDir & "Notes.ini"
$FileExists = FileExists($IniUsing)
$OpenLabText = IniRead(@TempDir & "Notes.ini", "Customize", "OpenLabel", "Open")
$WriteLabText = IniRead(@TempDir & "Notes.ini", "Customize", "WriteLabel", "Write")
$SaveButText = IniRead(@TempDir & "Notes.ini", "Customize", "SaveButton", "Save")
$OpenButText = IniRead(@TempDir & "Notes.ini", "Customize", "OpenButton", "Open")
$DeleteButText = IniRead(@TempDir & "Notes.ini", "Customize", "DeleteButton", "Delete")
$CloseButText = IniRead(@TempDir & "Notes.ini", "Customize", "CloseButton", "Close")

If $FileExists = 0 Then
	IniWrite($IniUsing, "Files", "ReadMe", "Notes made by Minikori. For ideas or bug reports, email me at elkemore@gmail.com.")
EndIf

$Notes = IniReadSection ($IniUsing, "Files")

GuiCreate("Notes", 320, 310)

$NameInput = GUICtrlCreateInput("Name", 120, 30, 190, 20)
$TextInput = GUICtrlCreateEdit("Text", 120, 60, 190, 184)
$FileList = GUICtrlCreateList ("Populating...", 10, 30, 100, 215)
$OpenLabel = GUICtrlCreateLabel($OpenLabText, 45, 10, 40, 20)
$WriteLabel = GUICtrlCreateLabel($WriteLabText, 200, 10, 40, 15)
$MenuFile = GUICtrlCreateMenu("File")
$MenuFileNew = GUICtrlCreateMenuitem("New", $MenuFile)
$MenuFileOpen = GUICtrlCreateMenuitem("Open", $MenuFile)
$MenuFileSave = GUICtrlCreateMenuitem("Save", $MenuFile)
$MenuFileDelete = GUICtrlCreateMenuitem("Delete", $MenuFile)
$MenuFileSep1 = GUICtrlCreateMenuItem("", $MenuFile)
$MenuFileImport = GUICtrlCreateMenuItem("Import .ini...", $MenuFile)
$MenuFileSep2 = GUICtrlCreateMenuItem("", $MenuFile)
$MenuFileClose = GUICtrlCreateMenuitem("Close", $MenuFile)
$MenuInfo = GUICtrlCreateMenu("Info")
$MenuInfoCustomize = GUICtrlCreateMenuItem("Customize...", $MenuInfo)
$MenuInfoAbout = GUICtrlCreateMenuitem("About...", $MenuInfo)
$Save = GUICtrlCreateButton($SaveButText, 10, 255, 50, 25)
$Close = GUICtrlCreateButton($CloseButText, 260, 255, 50, 25)
$Open = GUICtrlCreateButton($OpenButText, 93, 255, 50, 25)
$Delete = GUICtrlCreateButton($DeleteButText, 176, 255, 50, 25)

GUICtrlSetData($FileList, "")
For $x = 1 to $Notes[0][0]
	GUICtrlSetData($FileList, $Notes[$x][0])
Next

GUISetState()
While 1
	$msg = GuiGetMsg()
	If $msg = $GUI_EVENT_CLOSE Or $msg = $Close  Or $msg = $MenuFileClose Then
		ExitLoop
	EndIf
	If $msg = $MenuFileSave Or $msg = $Save Then
		$Name = GUICtrlRead($NameInput)
		$Text1 = GUICtrlRead($TextInput)
		$Text2 = StringReplace($Text1, @CRLF, "@CRLF")
		IniWrite($IniUsing, "Files", $Name, $Text2)
		MsgBox(0, "Saved", "File saved successfully.")
		$Notes = IniReadSection ($IniUsing, "Files")
		For $x = 1 to $Notes[0][0]
			GUICtrlSetData($FileList, $Notes[$x][0])
		Next
	EndIf
	If $msg = $MenuFileOpen Or $msg = $Open Then
		$Selected = GUICtrlRead($FileList)
		$NoteOpen1 = IniRead($IniUsing, "Files", $Selected, "Not Found")
		$NoteOpen2 = StringReplace($NoteOpen1, "@CRLF", @CRLF)
		GUICtrlSetData($NameInput, $Selected)
		GUICtrlSetData($TextInput, $NoteOpen2)
	EndIf
	If $msg = $MenuFileDelete Or $msg = $Delete Then
		$DFile = GUICtrlRead($FileList)
		$DConfirm = MsgBox(4, "Confirmation", "Are you sure you want to delete the file " & $DFile & "?")
		$Notes = IniReadSection ($IniUsing, "Files")
		If $Notes[0][0] = 1 Then
			MsgBox(0, "Sorry", "Sorry, you can't delete this file, you must have one file at all times!")
			$DConfirm = 7
		EndIf
		If $DConfirm = 6 Then
			IniDelete($IniUsing, "Files", $DFile)
			MsgBox(0, "Deleted", "File deleted successfully.")
			GUICtrlSetData($FileList, "")
			$Notes = IniReadSection ($IniUsing, "Files")
			For $x = 1 to $Notes[0][0]
				GUICtrlSetData($FileList, $Notes[$x][0])
			Next
			GUICtrlSetData($NameInput, "")
			GUICtrlSetData($TextInput, "")
		EndIf
	EndIf
	If $msg = $MenuFileNew Then
		GUICtrlSetData($NameInput, "")
		GUICtrlSetData($TextInput, "")
	EndIf
	If $msg = $MenuFileImport Then
		$IniUsing = FileOpenDialog("Import .ini File", @ScriptDir, "Ini Files (*.ini)")
		If @error Then
			Sleep(10)
		Else
			$Notes = IniReadSection ($IniUsing, "Files")
			GUICtrlSetData($FileList, "")
			For $x = 1 to $Notes[0][0]
				GUICtrlSetData($FileList, $Notes[$x][0])
			Next
		EndIf
	EndIf
	If $msg = $MenuInfoAbout Then
		MsgBox(0, "About", "Notes Version 1.3 by Minikori. To contact, email me at elkemore@gmail.com")
	EndIf
	If $msg = $MenuInfoCustomize Then
		GUICreate("Customize Window", 220, 350)
		GUICtrlCreateLabel("Open Label", 10, 10, 80, 20)
		$OpenLabInput = GUICtrlCreateInput($OpenLabText, 10, 30, 200, 20)
		GUICtrlCreateLabel("Write Label", 10, 60, 80, 20)
		$WriteLabInput = GUICtrlCreateInput($WriteLabText, 10, 80, 200, 20)
		GUICtrlCreateLabel("Save Button", 10, 110, 80, 20)
		$SaveButInput = GUICtrlCreateInput($SaveButText, 10, 130, 200, 20)
		GUICtrlCreateLabel("Open Button", 10, 160, 80, 20)
		$OpenButInput = GUICtrlCreateInput($OpenButText, 10, 180, 200, 20)
		GUICtrlCreateLabel("Delete Button", 10, 210, 80, 20)
		$DeleteButInput = GUICtrlCreateInput($DeleteButText, 10, 230, 200, 20)
		GUICtrlCreateLabel("Close Button", 10, 260, 80, 20)
		$CloseButInput = GUICtrlCreateInput($CloseButText, 10, 280, 200, 20)
		$OKBut = GUICtrlCreateButton("OK", 33, 310, 60, 30)
		$CancelBut = GUICtrlCreateButton("Cancel", 133, 310, 60, 30)
		GUISetState()
		While 1
			$msg = GUIGetMsg()
			If $msg = $GUI_EVENT_CLOSE Or $msg = $CancelBut Then
				ExitLoop
			EndIf
			If $msg = $OKBut Then
				$OpenLabText = GUICtrlRead($OpenLabInput)
				$WriteLabText = GUICtrlRead($WriteLabInput)
				$SaveButText = GUICtrlRead($SaveButInput)
				$OpenButText = GUICtrlRead($OpenButInput)
				$DeleteButText = GUICtrlRead($DeleteButInput)
				$CloseButText = GUICtrlRead($CloseButInput)
				IniWrite(@TempDir & "Notes.ini", "Customize", "OpenLabel", $OpenLabText)
				IniWrite(@TempDir & "Notes.ini", "Customize", "WriteLabel", $WriteLabText)
				IniWrite(@TempDir & "Notes.ini", "Customize", "SaveButton", $SaveButText)
				IniWrite(@TempDir & "Notes.ini", "Customize", "OpenButton", $OpenButText)
				IniWrite(@TempDir & "Notes.ini", "Customize", "DeleteButton", $DeleteButText)
				IniWrite(@TempDir & "Notes.ini", "Customize", "CloseButton", $CloseButText)
				GUIDelete()
				$EConfirm = MsgBox(4, "Exit Now?", "You need to exit Notes to save the changes, exit now?")
				If $EConfirm = 6 Then
					Exit
				EndIf
				If $EConfirm = 7 Then
					ExitLoop
				EndIf
			EndIf
		WEnd
		GUIDelete()
	EndIf
	If @error Then
		MsgBox(0, "Errored", "Sorry, but there has been an error. Notes will now exit.")
		ExitLoop
	EndIf
WEnd
Exit