#include <GUIConstants.au3>
; == GUI generated with Koda ==
Opt("GUIOnEventMode", 1)
$Form1 = GUICreate("Folder2Folder", 539, 136, 228, 283)
$FileFrom = GUICtrlCreateInput(IniRead ( "SavedFields", "", "FileFrom", "default" ), 72, 24, 153, 21, -1, $WS_EX_CLIENTEDGE)
$FileTo = GUICtrlCreateInput(IniRead ( "SavedFields", "", "Fileto", "default" ), 72, 56, 153, 21, -1, $WS_EX_CLIENTEDGE)
GUICtrlCreateLabel("To:", 16, 56, 20, 17)
GUICtrlCreateLabel("From:", 16, 32, 30, 17)
$SendFile = GUICtrlCreateButton("Send Files", 64, 88, 177, 33)
guictrlsetonevent ($SendFile, "SendFiles")
$CreateFolder = GUICtrlCreateButton("Create Folder", 312, 88, 177, 33)
GuiCtrlSetOnEvent ($CreateFolder, "FolderCreate")
$FolderName = GUICtrlCreateInput("", 320, 24, 153, 21, -1, $WS_EX_CLIENTEDGE)
GUICtrlSetData ( $Foldername, guictrlread ($FolderName ) )



$CreateWhere = GUICtrlCreateInput(IniRead ( "SavedFields", "", "CreateWhere", "default" ), 320, 56, 153, 21, -1, $WS_EX_CLIENTEDGE)
GUICtrlCreateLabel("Folder Name", 240, 32, 64, 17)
GUICtrlCreateLabel("Create where?", 240, 64, 73, 17)
$Save = GUICtrlCreateButton("Save", 88, 0, 113, 17)
guictrlsetonevent ($Save, "Save")
GUISetOnEvent ($GUI_EVENT_CLOSE, "Exit1")
GUISetState(@SW_SHOW)
While 1
	$msg = GuiGetMsg()
	Select
	Case $msg = $GUI_EVENT_CLOSE
		ExitLoop
	Case Else
		;;;;;;;
	EndSelect
WEnd
Exit

func Save()
   IniWrite ( "SavedFields", "", "FileFrom", Guictrlread ($Filefrom) )
   IniWrite ( "SavedFields", "", "FileTo", Guictrlread ($FileTo) )
   IniWrite ( "SavedFields", "", "CreateWhere", Guictrlread ($CreateWhere) )
endfunc

func FolderCreate()
   DirCreate (GuiCtrlRead ($CreateWhere) &"\"& GuiCtrlRead ($FolderName) )
endfunc

func SendFiles()
   FileCopy ( GuiCtrlRead ($FileFrom), GuiCtrlRead ($FileTo) )
   endfunc

func Exit1()
   Exit
endfunc

