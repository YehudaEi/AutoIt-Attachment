#include <ButtonConstants.au3>
#include <ComboConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; Creates the GUI
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
$Connecto = GUICreate("Install WIM Image", 268, 107, 342, 126)
    GUISetBkColor(0xFFFFFF)

$Label1 = GUICtrlCreateLabel("Select a WIM Image to Deploy:", 8, 8, 250, 27)
    GUICtrlSetFont(-1, 14, 400, 0, "Tahoma")

$DropDown = GUICtrlCreateCombo("", 8, 40, 249, 25)
    GUICtrlSetData($DropDown, "WIMimage01|WIMimage02|WIMimage03", "WIMimage01")

$STARTWIM = GUICtrlCreateButton("Start Deploy", 8, 72, 75, 25, $WS_GROUP)

$Exit = GUICtrlCreateButton("Exit", 184, 72, 75, 25, $WS_GROUP)

GUISetState(@SW_SHOW)
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; Sets conditions of the GUI
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
While 1
    $nMsg = GUIGetMsg()
    Switch $nMsg
        Case $GUI_EVENT_CLOSE
            Exit

        ; Sets Combo box
        Case $DropDown

        ; Sets "Start Deploy" button to Start Deploy WIM
        Case $STARTWIM
            $cmd = '"' & @ComSpec & '" /k k:\Imagex32.exe /apply '& $DropDown & ' 1 w:'
            MsgBox(0, 'CMD string to use', $cmd)
            RunWait('"' & @ComSpec & '" /k k:\Imagex32.exe /apply '& $DropDown & ' 1 w:', "", @SW_SHOW)

            Exit

        ; Sets Exit button to exit GUI
        Case $Exit
            Exit
    EndSwitch
WEnd
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
