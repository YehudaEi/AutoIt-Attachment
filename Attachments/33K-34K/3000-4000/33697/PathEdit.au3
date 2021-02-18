#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.6.1
 Author:         myName

 Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------

; Script Start - Add your code below here

#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>

$Box = GUICreate("Config", 211, 67, 388, 177)
$Input1 = GUICtrlCreateInput("", 8, 8, 193, 21)
$Button1 = GUICtrlCreateButton("Browse", 8, 32, 75, 25)
GUISetState(@SW_SHOW)

While 1
    $nMsg = GUIGetMsg()
    Switch $nMsg
        Case $GUI_EVENT_CLOSE
            Exit
        Case $Button1
            $path=FileOpenDialog("Select File",@ScriptDir,"All(*.*)")
            GUICtrlSetData($Input1,$path)
    EndSwitch
WEnd