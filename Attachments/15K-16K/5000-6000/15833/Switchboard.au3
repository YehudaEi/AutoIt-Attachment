#NoTrayIcon
#include <GUIConstants.au3>

;Set HotKeys
HotKeySet("{PGUP}", "Show")
HotKeySet("{PGDN}", "Hide")

Dim $Profile = " -P "
Dim $Host = " -H "

$GUI_W = "633";Absolute GUI Width
$GUI_H = "447";Absolute GUI Height
$laHors = "8"     ;horizontal positioning of Local Admin group box
$laVert = "140"   ;vertical positioning of Local Admin group box
$laHorsBut = "88" ;horzontal button positioning compared to Local Admin group box & used as multable
$laVertBut = "30" ;vertical button positioning compared to Local Admin group box & used as multable
$laButSize = "75, 25" ;Size of buttons in Local Admin group box
#Region ### START Koda GUI section ### Form=
$hGui = GUICreate("Switchboard", $GUI_W, $GUI_H, (@DesktopWidth-$GUI_W)/10, (@DesktopHeight-$GUI_H)/10)
Opt("GuiOnEventMode", 1)
$Tab1 = GUICtrlCreateTab(16, 40, 601, 337)
$TabSheet1 = GUICtrlCreateTabItem("INTRO")
GUICtrlCreateLabel("Please choose a TAB to find your ", 10, 10, 450, 20, $SS_Left)
$Edit1 = GUICtrlCreateEdit("", 40, 88, 537, 257)
GUICtrlSetData(-1, StringFormat("This is where you can put your custom instructions\r\nDeveloped by: can go here\r\n\r\nThis demonstrates skipping a line in your text."))
GUICtrlSetBkColor(-1, 0xD8E4F8)
GUICtrlSetTip(-1, "You must click on a tab to launch a switch")
;------------------------------------------------------------------------
$TabSheet2 = GUICtrlCreateTabItem("Section 1")
; Here is the setup for APAC TAB

GUICtrlCreateGroup("Section 1 Telnet Switches", $laHors * 3, $laVert / 2, 585, 315)
GUISetOnEvent($GUI_EVENT_CLOSE, "_Quit")
GUICtrlCreateLabel("Choose A Section 1 Telnet Switch To Open", 10, 10, 450, 20, $SS_Left)
$IniFile = @ScriptDir & '\IP.ini'
$avSwitches = IniReadSection($IniFile, "section1")
If @error Or $avSwitches[0][0] = 0 Then
    MsgBox(16, "Error", "Error reading ini file, or no data.")
Else
    $h = 0
    $v = 0
For $n = 1 To $avSwitches[0][0]
    $avSwitches[$n][0] = GUICtrlCreateRadio($avSwitches[$n][0], 95 + $laHors + $laHorsBut * $h, -50 + $laVert + $laVertBut * $v, $laButSize)
            $h = $h + 1
            if $h > 4 Then
                $h = 0
                $v = $v + 1
            EndIf
GUICtrlSetOnEvent(-1, "_section1")
Next
EndIf
;------------------------------------------------------------------------
$TabSheet3 = GUICtrlCreateTabItem("Section 2")
; Here is the setup for APAC TAB

GUICtrlCreateGroup("Section 2 Telnet Switches", $laHors * 3, $laVert / 2, 585, 315)
GUISetOnEvent($GUI_EVENT_CLOSE, "_Quit")
GUICtrlCreateLabel("Choose A Section 2 Telnet Switch To Launch", 10, 10, 450, 20, $SS_Left)
$IniFile = @ScriptDir & '\IP.ini'
$avSwitches1 = IniReadSection($IniFile, "section2")
If @error Or $avSwitches1[0][0] = 0 Then
    MsgBox(16, "Error", "Error reading ini file, or no data.")
Else
    $h = 0
    $v = 0
For $n = 1 To $avSwitches1[0][0]
    $avSwitches1[$n][0] = GUICtrlCreateRadio($avSwitches1[$n][0], 95 + $laHors + $laHorsBut * $h, -50 + $laVert + $laVertBut * $v, $laButSize)
            $h = $h + 1
            if $h > 4 Then
                $h = 0
                $v = $v + 1
            EndIf
GUICtrlSetOnEvent(-1, "_section2")
Next
EndIf
;------------------------------------------------------------------------
$TabSheet4 = GUICtrlCreateTabItem("Section3")
; Here is the setup for APAC TAB

GUICtrlCreateGroup("Section 3 Telnet Switches", $laHors * 3, $laVert / 2, 585, 315)
GUISetOnEvent($GUI_EVENT_CLOSE, "_Quit")
GUICtrlCreateLabel("Choose A Section 3 Telnet Switch To Launch", 10, 10, 450, 20, $SS_Left)
$IniFile = @ScriptDir & '\IP.ini'
$avSwitches2 = IniReadSection($IniFile, "section3")
If @error Or $avSwitches2[0][0] = 0 Then
    MsgBox(16, "Error", "Error reading ini file, or no data.")
Else
    $h = 0
    $v = 0
For $n = 1 To $avSwitches2[0][0]
    $avSwitches2[$n][0] = GUICtrlCreateRadio($avSwitches2[$n][0], 95 + $laHors + $laHorsBut * $h, -50 + $laVert + $laVertBut * $v, $laButSize)
            $h = $h + 1
            if $h > 4 Then
                $h = 0
                $v = $v + 1
            EndIf
GUICtrlSetOnEvent(-1, "_section3")
Next
EndIf
;------------------------------------------------------------------------
$TabSheet5 = GUICtrlCreateTabItem("Section 4")
; Here is the setup for APAC TAB

GUICtrlCreateGroup("Section 4 Telnet Switches", $laHors * 3, $laVert / 2, 585, 315)
GUISetOnEvent($GUI_EVENT_CLOSE, "_Quit")
GUICtrlCreateLabel("Choose A Section 4 Telnet Switch To Launch", 10, 10, 450, 20, $SS_Left)
$IniFile = @ScriptDir & '\IP.ini'
$avSwitches3 = IniReadSection($IniFile, "section4")
If @error Or $avSwitches3[0][0] = 0 Then
    MsgBox(16, "Error", "Error reading ini file, or no data.")
Else
    $h = 0
    $v = 0
For $n = 1 To $avSwitches3[0][0]
    $avSwitches3[$n][0] = GUICtrlCreateRadio($avSwitches3[$n][0], 95 + $laHors + $laHorsBut * $h, -50 + $laVert + $laVertBut * $v, $laButSize)
            $h = $h + 1
            if $h > 4 Then
                $h = 0
                $v = $v + 1
            EndIf
GUICtrlSetOnEvent(-1, "_section4")
Next
EndIf
;------------------------------------------------------------------------
$TabSheet5 = GUICtrlCreateTabItem("Section 5")
; Here is the setup for APAC TAB

GUICtrlCreateGroup("Section 5 Telnet Switches", $laHors * 3, $laVert / 2, 585, 315)
GUISetOnEvent($GUI_EVENT_CLOSE, "_Quit")
GUICtrlCreateLabel("Choose A Section 5 Telnet Switch To Launch", 10, 10, 450, 20, $SS_Left)
$IniFile = @ScriptDir & '\IP.ini'
$avSwitches4 = IniReadSection($IniFile, "section5")
If @error Or $avSwitches4[0][0] = 0 Then
    MsgBox(16, "Error", "Error reading ini file, or no data.")
Else
    $h = 0
    $v = 0
For $n = 1 To $avSwitches4[0][0]
    $avSwitches4[$n][0] = GUICtrlCreateRadio($avSwitches4[$n][0], 95 + $laHors + $laHorsBut * $h, -50 + $laVert + $laVertBut * $v, $laButSize)
            $h = $h + 1
            if $h > 4 Then
                $h = 0
                $v = $v + 1
            EndIf
GUICtrlSetOnEvent(-1, "_section5")
Next
EndIf
;------------------------------------------------------------------------


GUICtrlSetState(-1,$GUI_SHOW)
GUICtrlCreateTabItem("")
GUICtrlCreateGroup("", -99, -99, 1, 1)
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###
Dim $MenuFile = @ScriptDir & '\Menu.ini', $ItemEventsArr[1][1]
_GUICtrlCreateCustomMenu($MenuFile, $ItemEventsArr)


While 1
    Sleep(20)
WEnd
Func Show()
	GUISetState(@SW_SHOW, $hGui)
EndFunc

Func Hide()
	GUISetState(@SW_HIDE, $hGui)
EndFunc
Func _section1()
    For $n = 1 To $avSwitches[0][0]
        If ControlCommand($hGui, "", $avSwitches[$n][0], "IsChecked") Then
            ;ShellExecute("HOSTEX32.EXE", " " & $avSwitches[$n][1],@ProgramFilesDir & "\Hummingbird\Connectivity\10.00\HostExplorer", "",)
            MsgBox(64, "Results", 'Running: ShellExecute("terminal.exe", ' & $avSwitches[$n][1] & ', "%PROGRAMFILES%\HostExplorer\", "",)')
        EndIf
    Next
EndFunc   ;==>_OK
Func _section2()
    For $n = 1 To $avSwitches1[0][0]
        If ControlCommand($hGui, "", $avSwitches1[$n][0], "IsChecked") Then
			;ShellExecute("HOSTEX32.EXE", " " & $avSwitches1[$n][1],@ProgramFilesDir & "\Hummingbird\Connectivity\10.00\HostExplorer", "",)
            MsgBox(64, "Results", 'Running: ShellExecute("terminal.exe", ' & $avSwitches1[$n][1] & ', "%PROGRAMFILES%\HostExplorer\", "",)')
        EndIf
    Next
EndFunc   ;==>_OK
Func _section3()
    For $n = 1 To $avSwitches2[0][0]
        If ControlCommand($hGui, "", $avSwitches2[$n][0], "IsChecked") Then
            ;ShellExecute("HOSTEX32.EXE", " " & $avSwitches2[$n][1],@ProgramFilesDir & "\Hummingbird\Connectivity\10.00\HostExplorer", "",)
            MsgBox(64, "Results", 'Running: ShellExecute("terminal.exe", ' & $avSwitches2[$n][1] & ', "%PROGRAMFILES%\HostExplorer\", "",)')
        EndIf
    Next
EndFunc   ;==>_OK
Func _section4()
    For $n = 1 To $avSwitches3[0][0]
        If ControlCommand($hGui, "", $avSwitches3[$n][0], "IsChecked") Then
            ;ShellExecute("HOSTEX32.EXE", " " & $avSwitches4[$n][1],@ProgramFilesDir & "\Hummingbird\Connectivity\10.00\HostExplorer", "",)
            MsgBox(64, "Results", 'Running: ShellExecute("terminal.exe", ' & $avSwitches3[$n][1] & ', "%PROGRAMFILES%\HostExplorer\", "",)')
        EndIf
    Next
EndFunc   ;==>_OK
Func _section5()
    For $n = 1 To $avSwitches4[0][0]
        If ControlCommand($hGui, "", $avSwitches4[$n][0], "IsChecked") Then
            ;ShellExecute("HOSTEX32.EXE", " " & $avSwitches4[$n][1],@ProgramFilesDir & "\Hummingbird\Connectivity\10.00\HostExplorer", "",)
            MsgBox(64, "Results", 'Running: ShellExecute("terminal.exe", ' & $avSwitches4[$n][1] & ', "%PROGRAMFILES%\HostExplorer\", "",)')
        EndIf
    Next
EndFunc   ;==>_OK
Func _Quit()
    Exit
EndFunc   ;==>_Quit
Func _GUICtrlCreateCustomMenu($MenuFile, ByRef $ItemEventsArr)
    Local $MenuID, $MenuID2, $ItemID, $iCnt = 0
    $MainMenuSectArr = IniReadSection($MenuFile, "Main Menu")
    If Not @error Then
        For $iArr = 1 To $MainMenuSectArr[0][0]
            If StringLeft($MainMenuSectArr[$iArr][0], 8) = "Submenu," Then $MenuID = GUICtrlCreateMenu(StringTrimLeft($MainMenuSectArr[$iArr][0], 9))
            $SubMenuArr = IniReadSection($MenuFile, StringTrimLeft($MainMenuSectArr[$iArr][0], 9))
            If Not @error Then
                For $jArr = 1 To $SubMenuArr[0][0]
                    $iCnt += 1
                    ReDim $ItemEventsArr[$iCnt + 1][2]
                    If StringLeft($SubMenuArr[$jArr][0], 5) = "Item," Then
                        $ItemID = GUICtrlCreateMenuitem(StringTrimLeft($SubMenuArr[$jArr][0], 6), $MenuID)
                        $ItemEventsArr[$iCnt][0] = $ItemID
                        $ItemEventsArr[$iCnt][1] = $SubMenuArr[$jArr][1]
                    ElseIf StringLeft($SubMenuArr[$jArr][0], 8) = "Submenu," Then
                        $MenuID2 = GUICtrlCreateMenu(StringTrimLeft($SubMenuArr[$jArr][0], 9), $MenuID)
                        $SubSubMenuArr = IniReadSection($MenuFile, StringTrimLeft($SubMenuArr[$jArr][0], 9))
                        If Not @error Then
                            For $ijArr = 1 To $SubSubMenuArr[0][0]
                                $iCnt += 1
                                ReDim $ItemEventsArr[$iCnt + 1][2]
                                If StringLeft($SubSubMenuArr[$ijArr][0], 5) = "Item," Then $ItemID = GUICtrlCreateMenuitem(StringTrimLeft($SubSubMenuArr[$ijArr][0], 6), $MenuID2)
                                GUICtrlSetOnEvent($ItemID, "MainEvents")
                                $ItemEventsArr[$iCnt][0] = $ItemID
                                $ItemEventsArr[$iCnt][1] = $SubSubMenuArr[$ijArr][1]
                                $ItemEventsArr[0][0] = $iCnt
                            Next
                        EndIf
                    EndIf
                    GUICtrlSetOnEvent($ItemID, "MainEvents")
                    $ItemEventsArr[0][0] = $iCnt
                Next
            EndIf
        Next
    EndIf
EndFunc

Func MainEvents()
    For $iEv = 1 To $ItemEventsArr[0][0]
        If @GUI_CtrlId = $ItemEventsArr[$iEv][0] Then
            $CurentIDVal = $ItemEventsArr[$iEv][1]
            Select
                Case StringLeft($CurentIDVal, 8) = "Execute,"
                    Run(StringStripWS(StringTrimLeft($CurentIDVal, 8), 3))
                    If @error Then MsgBox(16, "Error - Program not found", "Can not execute an external program")
                Case $CurentIDVal = "Exit"
                    Exit
                Case StringLeft($CurentIDVal, 7) = "MsgBox,"
                    Local $Title, $Message
                    $TitleMsgArr = StringSplit($CurentIDVal, ",")
                    If IsArray($TitleMsgArr) Then
                        If $TitleMsgArr[0] >= 3 Then $Title = $TitleMsgArr[3]
                        If $TitleMsgArr[0] >= 5 Then $Message = $TitleMsgArr[5]
                        MsgBox(64, $Title, $Message)
                    EndIf
            EndSelect   
            ExitLoop
        EndIf
    Next
EndFunc