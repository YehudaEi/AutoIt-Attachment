#include <GuiConstantsEx.au3>
#include <AVIConstants.au3>
#include <TreeViewConstants.au3>

; GUI
GUICreate("Invoice Entry", 300, 70)
GUISetIcon(@SystemDir & "\explorer.exe", 0)

$invoer = GUICtrlCreateInput("", 15, 23, 180, 20)
$voerin = GUICtrlCreateButton("Click Here", 197, 23, 100, 20)

GUICtrlCreateLabel("Name:", 20,7, 400, 15)


GUISetState()

$hFile = FileOpen("Friends Details.xlsx", 1)

While 1
    $msg = GUIGetMsg()
    Select
        Case $msg = $GUI_EVENT_CLOSE
            ExitLoop
        Case $msg = $voerin
            FileWriteLine($hFile, GUICtrlRead($invoer))
            GUICtrlSetData($invoer, "")
    EndSelect
WEnd


FileClose($hFile)

GUICtrlCreateLabel("Mobile Number:", 20,7, 400, 15)

GUISetState()

$hFile1 = FileOpen("Friends Details.xls", 1)

While 1
    $msg = GUIGetMsg()
    Select
        Case $msg = $GUI_EVENT_CLOSE
            ExitLoop
        Case $msg = $voerin
            FileWriteLine($hFile1, GUICtrlRead($invoer))
            GUICtrlSetData($invoer, "")
    EndSelect
WEnd

FileClose($hFile)