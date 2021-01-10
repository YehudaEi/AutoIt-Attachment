#include <GuiConstants.au3>


$FileExists = FileExists("Files.ini")

If $FileExists = 0 Then
	IniWrite("Files.ini", "Files", "ReadMe", "Notes made by Minikori. For ideas or bug reports, email me at elkemore@gmail.com.")
EndIf

$Notes = IniReadSection ("Files.ini", "Files")

GuiCreate("Notes", 392, 326, -1, -1)

$NameInput = GUICtrlCreateInput("Name", 180, 40, 190, 20)
$TextInput = GUICtrlCreateEdit("Text", 180, 70, 190, 184)
$FileList = GUICtrlCreateList ("", 30, 40, 100, 214)
$Open = GUICtrlCreateLabel("Open", 60, 20, 90, 20)
$Write = GUICtrlCreateLabel("Write", 260, 20, 190, 15)
$MenuFile = GUICtrlCreateMenu("&File")
$MenuFileNew = GUICtrlCreateMenuitem("New", $MenuFile)
$MenuFileOpen = GUICtrlCreateMenuitem("Open", $MenuFile)
$MenuFileSave = GUICtrlCreateMenuitem("Save", $MenuFile)
$MenuFileDelete = GUICtrlCreateMenuitem("Delete", $MenuFile)
$MenuFileClose = GUICtrlCreateMenuitem("Close", $MenuFile)
$MenuInfo = GUICtrlCreateMenu("&Info")
$MenuInfoAbout = GUICtrlCreateMenuitem("About...", $MenuInfo)
$Save = GUICtrlCreateButton("Save...", 40, 267, 50, 25)
$Close = GUICtrlCreateButton("Close", 302, 267, 50, 25)
$Open = GUICtrlCreateButton("Open", 127, 267, 50, 25)
$Delete = GUICtrlCreateButton("Delete", 214, 267, 50, 25)

For $x = 1 to $Notes[0][0]
	GUICtrlSetData(5, $Notes[$x][0])
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
		IniWrite("Files.ini", "Files", $Name, $Text2)
		MsgBox(0, "Saved", "File saved successfully.")
		$Notes = IniReadSection ("Files.ini", "Files")
		For $x = 1 to $Notes[0][0]
			GUICtrlSetData(5, $Notes[$x][0])
		Next
	EndIf
	If $msg = $MenuFileOpen Or $msg = $Open Then
		$Selected = GUICtrlRead($FileList)
		$NoteOpen1 = IniRead("Files.ini", "Files", $Selected, "Not Found")
		$NoteOpen2 = StringReplace($NoteOpen1, "@CRLF", @CRLF)
		GUICtrlSetData($NameInput, $Selected)
		GUICtrlSetData($TextInput, $NoteOpen2)
	EndIf
	If $msg = $MenuFileDelete Or $msg = $Delete Then
		$DFile = GUICtrlRead($FileList)
		$DConfirm = MsgBox(4, "Confirmation", "Are you sure you want to delete the file " & $DFile & "?")
		If $DConfirm = 6 Then
			IniDelete("Files.ini", "Files", $DFile)
			MsgBox(0, "Deleted", "File deleted successfully.")
			GUICtrlSetData($FileList, "")
			$Notes = IniReadSection ("Files.ini", "Files")
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
	If $msg = $MenuInfoAbout Then
		MsgBox(0, "About", "Notes Version 1.1 by Minikori. To contact, email me at elkemore@gmail.com")
	EndIf
	If @error Then
		MsgBox(0, "Errored", "Sorry, but there has been an error. Notes will now exit.")
		ExitLoop
	EndIf
WEnd
Exit