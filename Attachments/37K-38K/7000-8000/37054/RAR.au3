#include <GUIConstantsEx.au3>

Opt('MustDeclareVars', 1)

;Global $Program = 'C:\Program Files\WinRAR'

Dim $msg, $fsf
Dim $guiHandle = GUICreate("RAR", 200, 135)
GUICtrlCreateLabel('Archive:' , 5, 5, 190)
Dim $Arc = GUICtrlCreateInput("", 5, 20, 165)
Dim $Folder = GUICtrlCreateButton( '...', 170, 19, 25, 22)
GUICtrlCreateLabel('Name:' , 5, 50, 190)
Dim $Name = GUICtrlCreateInput("", 5, 65, 190)
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
			RunWait(@ComSpec & " /k Start RAR a -av -m5 -o+ -r -sfx "& '\' & '" archive "' & GUICtrlRead($Archive)) & ' \' & GUICtrlRead($Name) & .rar)
        Case Default
    EndSelect
WEnd