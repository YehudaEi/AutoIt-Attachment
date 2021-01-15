#Include <Constants.au3>
#include <file.au3>

Opt("TrayMenuMode",1)	; Default tray menu items (Script Paused/Exit) will not be shown.


$files = TrayCreateMenu("Files")
$openfile = TrayCreateItem("Open",$files)
$savefile = TrayCreateItem("Create",$files)
$printfile = TrayCreateItem("Print",$files)
TrayCreateItem("")
$aboutitem		= TrayCreateItem("About")
TrayCreateItem("")
$exititem		= TrayCreateItem("Exit")

TraySetState()
While 1

	$msg = TrayGetMsg()
	Select
		Case $msg = 0
			ContinueLoop
		Case $msg = $aboutitem
			Msgbox(64,"About:","AutoIt3-Tray-sample")
		Case $msg = $exititem
			ExitLoop
		Case $msg = $openfile
			$message = "Hold down Ctrl or Shift to choose multiple files."
			$var = FileOpenDialog($message, @MyDocumentsDir , "All Files(*.*)", 1 + 4 )
			MsgBox(1,$var,$var)
			If @error Then
			MsgBox(4096,"","No File(s) chosen")
			Else
			ShellExecute($var) 
			EndIf
		Case $msg = $savefile
			$var = FileSelectFolder("Choose a folder.", "") 
			$new = InputBox("File name/type","What should the file be named with file extension.")
				_FileCreate($var & $new)
			Case $msg = $printfile
			$message = "Hold down Ctrl or Shift to choose multiple files."
			$var = FileOpenDialog($message, @MyDocumentsDir , "Text Files(*.txt)", 1 + 4 )	
			_FilePrint($var)
	EndSelect
WEnd

Exit
