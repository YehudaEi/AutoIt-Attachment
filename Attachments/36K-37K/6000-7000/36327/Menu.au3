#include <buttonconstants.au3>
#include <guibutton.au3>
#include <windowsconstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <TabConstants.au3>

$hGUI = GUICreate("Main Menu", 800, 600, -1, -1, $WS_BORDER)
GUICtrlCreatePic(".\Background.bmp", 0, 0, 800, 600)

GUISetState()
GUICtrlSetState(-1, $GUI_DISABLE)

$b1label = GUICtrlCreateLabel("Main Menu",250,50,340)
GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
GUICtrlSetColor(-1, 0xff0000)
GUICtrlSetFont(-1, 12, 400, 2)

$idButtonB1 = GUICtrlCreateButton("Cmd", 50, 500, 100, 50, $BS_COMMANDLINK)
_GUICtrlButton_SetImage($idButtonB1, "shell32.dll", 16, True)
GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
GUICtrlSetColor(-1, 0xff0000)
GUICtrlSetFont(-1, 12, 400, 2)

$idButtonM2 = GUICtrlCreateButton("Notepad", 50, 200, 220, 50, $BS_COMMANDLINK)
_GUICtrlButton_SetImage($idButtonM2, "shell32.dll", 15, True)



Do
    $msg = GUIGetMsg()
    Switch $msg
        Case -3
            Exit
       
	Case $idButtonB1
            #MsgBox(0, "Button", " B1 - Cmd pressed")
		Run("cmd.exe")

	Case $idButtonM2
            #MsgBox(0, "Button", " M2 - Notepad pressed")
		Run("notepad.exe")

     EndSwitch
Until False

Exit
