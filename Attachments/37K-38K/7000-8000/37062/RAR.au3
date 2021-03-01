#include <GUIConstantsEx.au3>

Opt('MustDeclareVars', 1)

Global $Program = 'C:\Program Files\WinRAR'

Dim $msg, $fsf
Dim $guiHandle = GUICreate("RAR", 200, 135)

GUICtrlCreateLabel('Name of RAR:' , 5, 5, 190)
Dim $Name = GUICtrlCreateInput("", 5, 20, 165)

GUICtrlCreateLabel('Archive File:' , 5, 50, 190)
Dim $Arc = GUICtrlCreateInput("", 5, 65, 165)
Dim $Folder = GUICtrlCreateButton( '...', 170, 65, 25, 22)

Dim $rarbutton  = GUICtrlCreateButton("Run RAR", 5, 108, 75)

Dim $exitbutton = GUICtrlCreateButton("Exit", 120, 108, 75)
GUISetState(@SW_SHOW, $guiHandle )
While 1
    $msg = GUIGetMsg($guiHandle )

	Select
        Case $msg == $GUI_EVENT_CLOSE Or $msg = $exitbutton
            Exit
        Case $msg == $Folder
            $fsf = FileSelectFolder('Choose Folder to Archive','')
            If Not @error Then GUICtrlSetData($Arc, $fsf)
		Case $msg == $rarbutton
			RunWait($Program & '\Rar.exe a -av -m5 -o+ -r -sfx' & GUICtrlRead($Name) & '.rar' & '\' & GUICtrlRead($Arc)
        Case Default
    EndSelect
WEnd