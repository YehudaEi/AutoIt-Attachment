#include <GUIConstants.au3>
$iniFile = @ScriptDir & "\IP.ini";Reads ini file in general
$iniSections = IniReadSectionNames($iniFile);Reads ini section names for tabs
; Get data from ini file
$iniFile = @ScriptDir & "\IP.ini"
$avSwitches = IniReadSection($IniFile, "Switches")
If @error Or $avSwitches[0][0] = 0 Then
    MsgBox(16, "Error", "Error reading ini file, or no data.")
    Exit
EndIf



$seH = "5" ;horizontal positioning of each section in ini file
$seL = "5" ;vertical positioning of each section in ini file
;Creating the GUI
;Opt("GuiOnEventMode", 1)
$hGui = GUICreate("GUI Name", 633, 447, 193, 115)
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
For $n = 1 To $avSwitches[0][0]
    $avSwitches[$n][0] = GUICtrlCreateRadio($avSwitches[$n][0] & ": " & $avSwitches, 30, 90 + ($n * 30), 400, 20)
Next
$okbutton = GUICtrlCreateButton("OK", 75, 120 + ($avSwitches[0][0] * 30), 50, 30)
GUICtrlSetOnEvent(-1, "_OK")

        EndIf
    Next
EndIf


GUISetState(@SW_SHOW)
While 1
    $hGui = GUIGetMsg()
    Switch $hGui
        Case $GUI_EVENT_CLOSE
            ExitLoop
           
    EndSwitch
WEnd
Func _OK()
    For $n = 1 To $avSwitches[0][0]
        If ControlCommand($hGui, "", $avSwitches[$n][0], "IsChecked") Then
            ShellExecute("HOSTEX32.EXE", $avSwitches[$n][1], "", "",)
            ;MsgBox(64, "Results", 'Running: ShellExecute("terminal.exe", ' & $avSwitches[$n][1] & ', "%PROGRAMFILES%\HostExplorer\", "",)')
        EndIf
    Next
EndFunc   ;==>_OK

Func _Quit()
    Exit
EndFunc   ;==>_Quit