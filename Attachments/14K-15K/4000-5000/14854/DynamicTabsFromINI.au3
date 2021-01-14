#include <GUIConstants.au3>

$iniFile = @ScriptDir & "\IP.ini";Reads ini file in general
$iniSections = IniReadSectionNames($iniFile);Reads ini section names for tabs

$seH = "5" ;horizontal positioning of each section in ini file
$seL = "5" ;vertical positioning of each section in ini file
;Creating the GUI
$GUIForm = GUICreate("GUI Name", 633, 447, 193, 115)
$Group1 = GUICtrlCreateGroup("Your Group Box", 16, 16, 601, 417, -1, $WS_EX_TRANSPARENT)
$Tab1 = GUICtrlCreateTab(25, 48, 583, 377)
GUICtrlSetState(-1,$GUI_SHOW)
GUICtrlCreateTabItem("")
GUICtrlCreateGroup("", -99, -99, 1, 1)
GUISetState(@SW_SHOW)

If @error Then
    MsgBox(4096, "", "Error occurred, probably no INI file.");Shows error if there is no ini file
Else

    For $i = 1 To $iniSections[0];Setting up the dynamic tabs
        if $iniSections[$i] <> "Setup" then
            $tabName = $iniSections[$i]
            GUICtrlCreateTab($tabName, $seH + 15, $seL * 110,$WS_MAXIMIZE,$WS_EX_TRANSPARENT )
$tab0=GUICtrlCreateTabitem ($tabName)
        EndIf
    Next
EndIf

GUISetState()
While 1
    $msg = GUIGetMsg()
    Switch $msg
        Case $GUI_EVENT_CLOSE
            ExitLoop
           
    EndSwitch
WEnd