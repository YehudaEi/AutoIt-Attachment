;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;	SimpleEdit 2.1 
;Author:	
;		Nick Koontz <Gamefreaknic94@aol.com>
;
;What is it:
;		A simple text editor written in autoit
;
;Thanks to: 
;		ThatsGreat2345 for the color picker
;
;Features in progress for 2.2 (or 3.0)
;		Menus for maximised type space
;		Font Chooser
;		To request a feature, E-mail me 
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


#include <GuiConstants.au3>
#include <Misc.au3>
GuiCreate("MyGUI", 467, 556,-1, -1 , BitOR($WS_OVERLAPPEDWINDOW, $WS_CLIPSIBLINGS))

$Edit_1 = GuiCtrlCreateEdit("Welcome to SimpleEdit 2.0!", 10, 10, 450, 340)
$Button_2 = GuiCtrlCreateButton("Open", 30, 360, 110, 30)
$Button_3 = GuiCtrlCreateButton("New", 180, 360, 110, 30)
$Button_4 = GuiCtrlCreateButton("Save", 330, 360, 110, 30)
$Button_5 = GuiCtrlCreateButton("Choose Color", 190, 430, 90, 30)
$Label_8 = GuiCtrlCreateLabel("BG color", 212, 410, 170, 20)
$Button_11 = GuiCtrlCreateButton("Normal", 190, 470, 90, 30)

GuiSetState()
While 1
    $msg = GuiGetMsg()
    Select
    Case $msg = $GUI_EVENT_CLOSE
        ExitLoop
    Case $msg = $Button_2
        GUICtrlSetData($Edit_1,Fileread(FileOpenDialog("Select a file to open",@ScriptDir, "All Files (*.*)")))
    Case $msg = $Button_3
        GUICtrlSetData($edit_1, "")
    Case $Msg = $Button_4
        FileWrite(FilesaveDialog("Select a file to save",@ScriptDir, "All Files (*.*)"),GUICtrlRead($Edit_1))
    Case $msg = $Button_5
        GUISetBkColor(_ChooseColor(2, 255))
    Case $msg = $Button_11
        GUISetBkColor(0xece9d8)
        EndSelect
WEnd
Exit